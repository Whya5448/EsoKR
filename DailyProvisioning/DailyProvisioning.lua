DailyProvisioning = {
    displayName = "Daily Provisioning",
    name = "DailyProvisioning",
    version = "1.2.16",

    emptySlot = nil,        -- ※Don't Finalize

    bulkConditionText = nil,
    executeCurrent = nil,
    executeToEnd = nil,
    checkedJournal = {},
    stackList = {},
    houseStackList =  {},

    recipeList = nil,
    itemTypeFilter = {},
    isSilent = false,
    isDontKnow = nil,
    dontKnowRecipe = nil,
}




-- TODO: Remove after system bug fixes
local function GetCraftingSkillLineIndices(tradeskillType)

    local skillLineData = SKILLS_DATA_MANAGER:GetCraftingSkillLineData(tradeskillType)
    if skillLineData then
        return skillLineData:GetIndices()
    end
    return 0, 0, 0
end




local function Choice(conditions, trueValue, falseValue)

    if conditions then
        if trueValue then
            return trueValue
        else
            return conditions
        end
    else
        return falseValue
    end
end




local function Contains(text, keyList)

    if text == nil or text == "" then
        return nil
    end

    local lowerText = string.lower(text)

    local result
    for _, key in ipairs(keyList) do
        if key and key ~= "" then
            result, result2 = string.match(text, key)
            if result then
                return result, result2
            end

            local lowerKey = string.lower(key)
            if lowerText and lowerKey then
                result, result2 = string.match(lowerText, lowerKey)
                if result then
                    return result, result2
                end
            end
        end
    end
    return nil
end




local function ContainsNumber(num, keyList)

    if num == nil then
        return false
    end
    for _, key in ipairs(keyList) do
        if num == key then
            return true
        end
    end
    return false
end




local function Debug(text)
    if DailyProvisioning.isSilent then
        return
    end
    if DailyProvisioning.savedVariables.isDebug then
        d(text)
        local log = tostring(text):gsub("　", "  "):gsub("|c5c5c5c", ""):gsub("|cffff66", ""):gsub("|r", "")
        table.insert(DailyProvisioning.savedVariables.debugLog, log)
    end
end




local function IsDebug()
    if DailyProvisioning.isSilent then
        return false
    end
    return DailyProvisioning.savedVariables.isDebug
end




function DailyProvisioning:Acquire(eventCode)

    if (not self.savedVariables.isAcquireItem) then
        return
    end


    Debug("[Pre Acquire]")
    local infos, hasMaster, hasDaily = self:GetQuestInfos()
    if (not infos) or #infos == 0 then
        Debug("　　No Quest")
        return
    end

    self.emptySlot = self:NextEmptySlot()
    if (not self.recipeList) then
        self.recipeList = self:GetRecipeList(hasMaster, hasDaily)
    end
    self.stackList = self:GetStackList()
    self.houseStackList = self:GetHouseStackList()


    Debug("[Acquire]")
    for _, info in pairs(infos) do
        local parameterList
        if self:IsValidAcquireItemConditions(info.current, info.max, info.isVisible, info.convertedTxt) then
            Debug("　　　　[AcquireItem]")
            parameterList = self:CreateParameterQuiet(info)
            self:AcquireItem(info, parameterList)
        end
        if self:IsValidAcquireMaterialConditions(info.current, info.max, info.isVisible, info.convertedTxt) then
            Debug("　　　　[AcquireMaterial]")
            if (not parameterList) then
                parameterList = self:CreateParameterQuiet(info)
            end
            self:AcquireMaterial(info, parameterList)
        end
    end
end




function DailyProvisioning:AcquireItem(info, parameterList)

    if (info.current >= info.max) then
        return
    end
    if #parameterList == 0 then
        return
    end
    parameter = parameterList[1]
    if (not parameter.itemId) then
        return
    end


    local isWorkingByWritcreater = (not info.isMaster)
                                    and WritCreater
                                    and WritCreater:GetSettings().shouldGrab
                                    and WritCreater:GetSettings()[CRAFTING_TYPE_PROVISIONING]
    local bagIdList = self:GetItemBagList()
    local moved = 0
    if isWorkingByWritcreater then
        moved = self:CountByItem(parameter.recipeLink, info.current, info.max, bagIdList)
    else
        moved = self:MoveByItem(parameter.recipeLink, info.current, info.max, bagIdList)
    end
    if moved > 0 then
        info.current = info.current + moved
    end
end




function DailyProvisioning:AcquireMaterial(info, parameterList)

    if (info.current >= info.max) then
        return
    end
    if #parameterList == 0 then
        return
    end
    parameter = parameterList[1]
    if parameter.errorMsg and (not parameter.isKnown) then
        return
    end


    local quantity = (info.max - info.current)
    if IsDebug() then
        d("　　　　　　" .. parameter.recipeLink .. " x " .. quantity .. " ["
                         .. table.concat(parameter.ingredientLinks, ", ")
                         .. "]")
    end

    local bagIdList = self:GetHouseBankIdList()
    local materialMax = math.ceil(quantity / self:GetAmountToMake(parameter.itemType))
    local totalMax = 4
    local total = 0
    for _, material in ipairs(parameter.ingredients) do
        local stack = self.stackList[material.itemId] or 0
        local houseStack = self.houseStackList[material.itemId] or 0
        local used = math.min(materialMax, stack)
        self.stackList[material.itemId] = stack - used
        local materialCurrent = Choice(material.itemName, used, materialMax)
        Debug("　　　　　　" .. material.itemLink
                             .. "(" .. stack .. "/" .. materialMax .. ")"
                             .. " UsedStack x" .. used
                             .. " HouseStack x" .. houseStack)
        local moved = self:MoveByItem(material.itemLink, materialCurrent, materialMax, bagIdList)
        if (moved + materialCurrent >= materialMax) then
            total = total + 1
        end
    end
    if (total >= totalMax) then
        info.current = info.max
    end
end




function DailyProvisioning:Camehome(eventCode)
    if IsOwnerOfCurrentHouse() then
        zo_callLater(function()
            self:Acquire(eventCode)
            self:Finalize()

            zo_callLater(function()
                self.isSilent = true
                self:Acquire(eventCode)
                self:Finalize()
            end, 1000 * 2)

        end, 1000 * 3)
    end
end




function DailyProvisioning:CraftCompleted(eventCode, craftSkill)

    if craftSkill ~= CRAFTING_TYPE_PROVISIONING then
        return false
    end


    if (self:Crafting(eventCode, craftSkill)) and (self.savedVariables.isAutoExit) then
        if (self.savedVariables.bulkQuantity) and (self.executeToEnd ~= nil) then
            return
        end
        local isEmpty = true
        for _, value in pairs(self.checkedJournal) do
            if value == false then
                return
            end
            isEmpty = false
        end
        if isEmpty then
            return
        end

        local provisioner = Choice(IsInGamepadPreferredMode(), GAMEPAD_PROVISIONER, PROVISIONER)
        provisioner:StartHide()
        SCENE_MANAGER:Hide(provisioner.mainSceneName)
    end
end




function DailyProvisioning:Crafting(eventCode, craftSkill)

    Debug("bulkQuantity=" .. tostring(self.savedVariables.bulkQuantity))
    Debug("isAcquireItem=" .. tostring(self.savedVariables.isAcquireItem))
    Debug("isAutoExit=" .. tostring(self.savedVariables.isAutoExit))
    Debug("isDontKnow=" .. tostring(self.savedVariables.isDontKnow))
    Debug("isDebug=" .. tostring(self.savedVariables.isDebug))

    Debug("[Pre Crafting]")
    local infos, hasMaster, hasDaily = self:GetQuestInfos()
    if (not infos) or #infos == 0 then
        Debug("　　No Quest")
        return
    end

    self.recipeList = self.recipeList or self:GetRecipeList(hasMaster, hasDaily)
    local isDontKnow, recipeName = self:IsDontKnow(infos)
    Debug("　　isDontKnow=" .. tostring(isDontKnow) .. ", recipeName=" .. tostring(recipeName))
    if isDontKnow then
        local msg = zo_strformat(GetString(DP_UNKNOWN_RECIPE), recipeName)
        self:Message(msg, ZO_ERROR_COLOR:ToHex())
        return false
    elseif isDontKnow == nil then
        return false
    end


    Debug("[Crafting]")
    for _, info in pairs(infos) do
        info.convertedTxt = self:IsValidConditions(info.convertedTxt, info.current, info.max, info.isVisible)
        if info.convertedTxt then
            local parameter = self:CreateParameter(info)[1]
            if (not parameter) then
                if (self.checkedJournal[info.key] ~= false) then
                    local msg = zo_strformat(GetString(DP_MISMATCH_RECIPE), info.txt:gsub("\n", ""))
                    self:Message(msg, ZO_ERROR_COLOR:ToHex())
                end
                self.checkedJournal[info.key] = false
                return false

            elseif parameter.errorMsg then
                if (self.checkedJournal[info.key] ~= false) then
                    self:Message(parameter.recipeName .. parameter.errorMsg)
                end
                self.executeCurrent = nil
                self.checkedJournal[info.key] = false

            elseif parameter.recipeLink then
                self:SetStation(parameter)
                CraftProvisionerItem(parameter.listIndex, parameter.recipeIndex)

                local remainingQuantity = tostring(info.max - info.current)
                if self.executeCurrent then
                    local _, _, stack = GetRecipeResultItemInfo(parameter.listIndex, parameter.recipeIndex)
                    self.executeCurrent = math.min(self.executeCurrent + stack, self.executeToEnd)
                    remainingQuantity = self.executeCurrent .. "/" .. self.executeToEnd
                                        .. " [" .. GetString(DP_BULK_HEADER) .. "]"
                end
                self:Message(parameter.recipeLink .. " x " .. remainingQuantity)
                info.current = math.min(info.current + self:GetAmountToMake(parameter.itemType), info.max)
                if info.uniqueId then
                    self.savedVariables.reservations[info.uniqueId].current = info.current
                end
                self.checkedJournal[info.key] = true
                return false
            end
        end
    end
    return true
end




function DailyProvisioning:CreateMenu()

    if self.savedVariables.isAcquireItem == nil then
        self.savedVariables.isAcquireItem = true
    end
    if self.savedVariables.isDontKnow == nil then
        self.savedVariables.isDontKnow = true
    end
    if self.savedVariables.isLog == nil then
        self.savedVariables.isLog = true
    end


    local LAM2 = LibStub("LibAddonMenu-2.0")
    local panelData = {
        type = "panel",
        name = self.displayName,
        displayName = self.displayName,
        author = "Marify",
        version = self.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }
    LAM2:RegisterAddonPanel(self.displayName, panelData)


    local optionsTable = {
        {
            type = "header",
            name = GetString(DP_BULK_HEADER),
            width = "full",
        },
        {
            type = "checkbox",
            name = GetString(DP_BULK_FLG),
            tooltip = GetString(DP_BULK_FLG_TOOLTIP),
            getFunc = function()
                return self.savedVariables.bulkQuantity
            end,
            setFunc = function(value)
                if value then
                    self.savedVariables.bulkQuantity = 1
                else
                    self.savedVariables.bulkQuantity = nil
                end
            end,
            width = "full",
            default = false,
        },
        {
            type = "slider",
            name = GetString(DP_BULK_COUNT),
            tooltip = GetString(DP_BULK_COUNT_TOOLTIP),
            min = 1,
            max = 100,
            step = 1,
            disabled = function()
                return (not self.savedVariables.bulkQuantity)
            end,
            getFunc = function()
                return self.savedVariables.bulkQuantity
            end,
            setFunc = function(value)
                self.savedVariables.bulkQuantity = tonumber(value)
            end,
            width = "full",
            default = 1,
        },
        {
            type = "header",
            name = GetString(DP_OTHER_HEADER),
            width = "full",
        },
        {
            type = "checkbox",
            name = GetString(DP_ACQUIRE_ITEM),
            getFunc = function()
                return self.savedVariables.isAcquireItem
            end,
            setFunc = function(value)
                self.savedVariables.isAcquireItem = value
            end,
            width = "full",
            default = true,
        },
        {
            type = "checkbox",
            name = GetString(DP_AUTO_EXIT),
            tooltip = GetString(DP_AUTO_EXIT_TOOLTIP),
            getFunc = function()
                return self.savedVariables.isAutoExit
            end,
            setFunc = function(value)
                self.savedVariables.isAutoExit = value
            end,
            width = "full",
            default = false,
        },
        {
            type = "checkbox",
            name = GetString(DP_DONT_KNOW),
            tooltip = GetString(DP_DONT_KNOW_TOOLTIP),
            getFunc = function()
                return self.savedVariables.isDontKnow
            end,
            setFunc = function(value)
                self.savedVariables.isDontKnow = value
            end,
            width = "full",
            default = true,
        },
        {
            type = "checkbox",
            name = GetString(DP_LOG),
            getFunc = function()
                return self.savedVariables.isLog
            end,
            setFunc = function(value)
                self.savedVariables.isLog = value
            end,
            width = "full",
            default = true,
        },
        {
            type = "checkbox",
            name = GetString(DP_DEBUG_LOG),
            getFunc = function()
                return self.savedVariables.isDebug
            end,
            setFunc = function(value)
                self.savedVariables.isDebug = value
            end,
            width = "full",
            default = false,
        },
    }
    LAM2:RegisterOptionControls(self.displayName, optionsTable)
end




function DailyProvisioning:CreateParameter(info)

    Debug("　　[Parameter]")
    local qualityMax = 1
    local qualityMin = 1
    if info.isMaster then
        qualityMax = 4
        qualityMin = 2 -- TODO: In case of Master, is there quality 1?
    end

    local listIndexs = {1, 2,  3,  4,  5,  6,  7, 16,
                        8, 9, 10, 11, 12, 13, 14, 15} -- ALL
    if info.isMaster and info.conditionIdx == 2 then
        listIndexs = {4, 5, 6, 7, 16}
    elseif info.isMaster and info.conditionIdx == 3 then
        listIndexs = {11, 12, 13, 14, 15}
    elseif info.conditionIdx == 2 then
        listIndexs = {1, 2, 3}
    elseif info.conditionIdx == 3 then
        listIndexs = {8, 9, 10}
    end

    Debug("　　　　convertedTxt=" .. tostring(info.convertedTxt))
    Debug("　　　　questIdx=" .. tostring(info.questIdx)
                              .. ", stepIdx=" .. tostring(info.stepIdx)
                              .. ", conditionIdx=" .. tostring(info.conditionIdx))
    Debug("　　　　Quality=" .. tostring(qualityMin) .. " to " .. tostring(qualityMax))

    local parameterList = {}
    for _, recipe in ipairs (self.recipeList) do
        if ContainsNumber(recipe.listIndex, listIndexs)
            and recipe.skillQuality <= qualityMax
            and recipe.skillQuality >= qualityMin then

            if IsDebug() then
                local convertedItemNames = self:ConvertedItemNames(recipe.recipeName)
                local mark = Choice(Contains(info.convertedTxt, convertedItemNames), "|cffff66(O)", "|c5c5c5c(X)")
                Debug("　　　　　　" .. mark .. ": " .. table.concat(convertedItemNames, ", ") .. (recipe.errorMsg or "") .. "|r ") 
            end

            if Contains(info.convertedTxt, self:ConvertedItemNames(recipe.recipeName))then
                parameterList[#parameterList + 1] = recipe
                break
            end
        end
    end
    if #parameterList == 0 then
        local recipe = self:GetRecipeException(info)
        if recipe then
            if IsDebug() or GetDisplayName() == "@Marify" then
                local mark = Choice(recipe.isKnown, "|cff00ff(O)", "|cff00ff(X)")
                local convertedItemNames = self:ConvertedItemNames(recipe.recipeName)
                Debug("　　　　　　" .. mark .. ": " .. table.concat(convertedItemNames, ", ") .. (recipe.errorMsg or "") .. "|r ") 
            end
            parameterList[#parameterList + 1] = recipe
        else
            return {}
        end
    end


    local recipe = parameterList[1]
    recipe.recipeName = self:ConvertedItemNameForDisplay(recipe.recipeName)
    if (not recipe.isKnown) then
        return {recipe}
    end


    recipe.recipeLink = GetRecipeResultItemLink(recipe.listIndex, recipe.recipeIndex)
    recipe.itemId = GetItemLinkItemId(recipe.recipeLink)
    recipe.itemType = GetItemLinkItemType(recipe.recipeLink)
    recipe.ingredients = {}
    recipe.ingredientLinks = {}
    local shortList = {}
    for ingredientIndex = 1, recipe.numIngredients do
        local ingredient = {}
        ingredient.itemName, _, ingredient.quantity = GetRecipeIngredientItemInfo(recipe.listIndex, recipe.recipeIndex, ingredientIndex)
        ingredient.itemLink = GetRecipeIngredientItemLink(recipe.listIndex, recipe.recipeIndex, ingredientIndex)
        ingredient.itemId = GetItemLinkItemId(ingredient.itemLink)
        ingredient.icon = zo_iconFormat(GetItemLinkIcon(ingredient.itemLink), 20, 20)
        local count = GetCurrentRecipeIngredientCount(recipe.listIndex, recipe.recipeIndex, ingredientIndex)
        if count < ingredient.quantity then
            shortList[#shortList + 1] = ingredient.icon .. self:ConvertedItemNameForDisplay(ingredient.itemName)
        end
        recipe.ingredients[#recipe.ingredients + 1] = ingredient
        recipe.ingredientLinks[#recipe.ingredientLinks + 1] = ingredient.itemLink
    end
    if #shortList > 0 then
        recipe.errorMsg = zo_strformat(GetString(DP_SHORT_OF), table.concat(shortList, ", "))
    end
    return {recipe}
end




function DailyProvisioning:CreateParameterQuiet(info)

    if IsDebug() then
        self.savedVariables.isDebug = false
        local parameterList = self:CreateParameter(info)
        self.savedVariables.isDebug = true
        return parameterList
    else
        return self:CreateParameter(info)
    end
end




function DailyProvisioning:Finalize()
    self.bulkConditionText = nil
    self.executeCurrent = nil
    self.executeToEnd = nil
    self.checkedJournal = {}

    self.recipeList = nil
    self.itemTypeFilter = {}
    self.stackList = {}
    self.houseStackList = {}
    self.isSilent = false
    self.isDontKnow = nil
    self.dontKnowRecipe = nil
end




function DailyProvisioning:GetAmountToMake(itemType)

    local skillType, skillIndex = GetCraftingSkillLineIndices(CRAFTING_TYPE_PROVISIONING)
    local abilityIndex = 5
    if itemType == ITEMTYPE_DRINK then
        abilityIndex = 6
    end
    local abilityName, _, _, _, _, purchased, _, rankIndex = GetSkillAbilityInfo(skillType, skillIndex, abilityIndex)
    if (not purchased) then
        rankIndex = 0
    end

    -- Rank0:1
    -- Rank1:2 (+1)
    -- Rank2:3 (+2)
    -- Rank3:4 (+3)
    abilityName = abilityName:gsub("(\^)%a*", "")
    Debug("　　" .. abilityName .. " Rank" .. rankIndex)
    return 1 + rankIndex
end




function DailyProvisioning:GetHouseBankIdList()

    local houseBankBagId = GetBankingBag()
    if GetInteractionType() == INTERACTION_BANK
        and IsOwnerOfCurrentHouse()
        and IsHouseBankBag(houseBankBagId) then
        return {houseBankBagId}

    elseif IsOwnerOfCurrentHouse() then
        return {BAG_HOUSE_BANK_ONE,
                BAG_HOUSE_BANK_TWO,
                BAG_HOUSE_BANK_THREE,
                BAG_HOUSE_BANK_FOUR,
                BAG_HOUSE_BANK_FIVE,
                BAG_HOUSE_BANK_SIX,
                BAG_HOUSE_BANK_SEVEN,
                BAG_HOUSE_BANK_EIGHT,
                BAG_HOUSE_BANK_NINE,
                BAG_HOUSE_BANK_TEN}
    end
    return {}
end




function DailyProvisioning:GetHouseStackList()

    if GetInteractionType() == INTERACTION_BANK then
        if (not IsOwnerOfCurrentHouse()) then
            return {}
        end
    end


    local list = {}
    for _, bagId in pairs(self:GetHouseBankIdList()) do
        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            local itemType = GetItemType(bagId, slotIndex)
            if ContainsNumber(itemType, self.itemTypeFilter) then
                local itemId = GetItemId(bagId, slotIndex)
                local _, stack = GetItemInfo(bagId, slotIndex)
                local totalStack = list[itemId] or 0
                list[itemId] = totalStack + stack
            end

            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return list
end




function DailyProvisioning:GetItemBagList()

    local houseBankBagId = GetBankingBag()
    if GetInteractionType() == INTERACTION_BANK
        and IsOwnerOfCurrentHouse()
        and IsHouseBankBag(houseBankBagId) then
        return {houseBankBagId, BAG_BANK, BAG_SUBSCRIBER_BANK}

    elseif IsOwnerOfCurrentHouse() then
        return {BAG_HOUSE_BANK_ONE,
                BAG_HOUSE_BANK_TWO,
                BAG_HOUSE_BANK_THREE,
                BAG_HOUSE_BANK_FOUR,
                BAG_HOUSE_BANK_FIVE,
                BAG_HOUSE_BANK_SIX,
                BAG_HOUSE_BANK_SEVEN,
                BAG_HOUSE_BANK_EIGHT,
                BAG_HOUSE_BANK_NINE,
                BAG_HOUSE_BANK_TEN,
                BAG_BANK,
                BAG_SUBSCRIBER_BANK}
    end
    return {BAG_BANK, BAG_SUBSCRIBER_BANK}
end




function DailyProvisioning:GetQuestInfos()

    Debug("[Quest]")
    local hasMaster = false
    local hasDaily = false
    local list = {}
    for questIdx = 1, MAX_JOURNAL_QUESTS do
        local questName = GetJournalQuestName(questIdx)
        if self:IsValidQuest(questIdx, questName) then

            local isMaster = string.match(questName, GetString(DP_CRAFTING_MASTER))
            if isMaster then
                hasMaster = true
            else
                hasDaily = true
            end
            for stepIdx = 1, GetJournalQuestNumSteps(questIdx) do
                for conditionIdx = 1, GetJournalQuestNumConditions(questIdx, stepIdx) do

                    local key = table.concat({questIdx, stepIdx, conditionIdx}, "_")
                    local txt, current, max, _, _, _, isVisible, conditionType = GetJournalQuestConditionInfo(questIdx,
                                                                                                              stepIdx,
                                                                                                              conditionIdx)
                    if isVisible and txt and txt ~="" then
                        local info = {}
                        info.txt = txt
                        info.convertedTxt = self:ConvertedJournalCondition(txt)
                        info.current = current
                        info.max = max
                        info.isVisible = isVisible
                        info.isMaster = isMaster
                        info.key = key
                        info.questIdx = questIdx
                        info.stepIdx = stepIdx
                        info.conditionIdx = conditionIdx
                        Debug("　　　　"
                            .. tostring(info.questIdx)
                            .. "-" .. tostring(info.stepIdx)
                            .. "-" .. tostring(info.conditionIdx)
                            .. ":" .. tostring(info.convertedTxt)
                        )
                        list[#list + 1] = info
                    end
                end
            end
        end
    end


    local reservations = self.savedVariables.reservations or {}
    local uniqueId
    local reservation
    local txt
    local slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, nil)
    while slotIndex do
        if string.match(GetItemInfo(BAG_BACKPACK, slotIndex), "master_writ_provisioning") then
            uniqueId = Id64ToString(GetItemUniqueId(BAG_BACKPACK, slotIndex))
            reservation = reservations[uniqueId]
            if reservation and reservation.current < reservation.max then
                Debug("　　questName(O):" .. GetString(DP_CRAFTING_MASTER))
                txt = GenerateMasterWritBaseText(GetItemLink(BAG_BACKPACK, slotIndex))
                local info = {}
                info.recipeItemId = reservation.recipeItemId
                info.uniqueId = uniqueId
                info.txt = txt
                info.convertedTxt = self:ConvertedJournalCondition(txt)
                info.current = reservation.current
                info.max = reservation.max
                info.isVisible = true
                info.isMaster = true
                info.key = uniqueId
                list[#list + 1] = info
                hasMaster = true
                Debug(zo_strformat("　　　　<<1>>:<<2>> <<3>> / <<4>>", info.recipeItemId,
                                                                        tostring(reservation.txt),
                                                                        tostring(reservation.current),
                                                                        tostring(reservation.max)))
            end
        end
        slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, slotIndex)
    end
    return list, hasMaster, hasDaily
end




function DailyProvisioning:GetRecipeException(info)

    Debug("　　[RecipeException]")
    local listName, numRecipes
    local isKnown, recipeName, numIg, level, quality, ingredientType, stationType
    local itemLink
    Debug("　　　　info.questIdx=" .. tostring(info.questIdx))
    Debug("　　　　info.stepIdx=" .. tostring(info.stepIdx))
    Debug("　　　　info.conditionIdx=" .. tostring(info.conditionIdx))

    for listIndex = 1, GetNumRecipeLists() do
        listName, numRecipes = GetRecipeListInfo(listIndex)
        for recipeIndex = 1, numRecipes do
            isKnown, recipeName, numIg, level, quality, ingredientType, stationType = GetRecipeInfo(listIndex,
                                                                                                    recipeIndex)
            itemLink = GetRecipeResultItemLink(listIndex, recipeIndex)

            if (info.questIdx and DoesItemLinkFulfillJournalQuestCondition(itemLink,
                                                                           info.questIdx,
                                                                           info.stepIdx,
                                                                           info.conditionIdx))
            or (info.recipeItemId and info.recipeItemId == GetItemLinkItemId(itemLink)) then

                local recipe = {}
                recipe.recipeName       = recipeName
                recipe.isKnown          = isKnown
                recipe.listIndex        = listIndex
                recipe.recipeIndex      = recipeIndex
                recipe.ingredientType   = ingredientType
                recipe.numIngredients   = numIg
                recipe.len              = string.len(recipeName)
                recipe.skillLevel       = level
                recipe.skillQuality     = quality

                if (not isKnown) then
                    recipe.errorMsg = GetString(DP_NOTHING_RECIPE)
                end
                return recipe
            end
        end
    end
    return nil
end




function DailyProvisioning:GetRecipeList(hasMaster, hasDaily)

    Debug("[Recipe]")
    self.itemTypeFilter = {ITEMTYPE_INGREDIENT}
    local itemTypeCache = {ITEMTYPE_INGREDIENT}
    local list = {}
    local listName, numRecipes
    local isKnown, recipeName, numIg, level, quality, ingredientType, stationType
    local itemLink
    local itemType


    local levelMax = self.savedCharVariables.levelWhenReceived
    local levelMin = levelMax
    if (not levelMax) then
        levelMax = self:GetSkillLevel()
        levelMin = math.max(levelMax - 3, 1)
    end
    if hasMaster then
        levelMax = 6
        levelMin = 1
    end

    local qualityMax = 1
    local qualityMin = 1
    if hasMaster then
        qualityMax = 4
        qualityMin = 1 -- TODO: In case of Master, is there quality 1?
    end

    local recipe
    for listIndex = 1, GetNumRecipeLists() do
        listName, numRecipes = GetRecipeListInfo(listIndex)
        for recipeIndex = 1, numRecipes do
            isKnown, recipeName, numIg, level, quality, ingredientType, stationType = GetRecipeInfo(listIndex, recipeIndex)

            if recipeName
                and recipeName ~= ""
                and stationType == CRAFTING_TYPE_PROVISIONING
                and ingredientType ~= PROVISIONER_SPECIAL_INGREDIENT_TYPE_FURNISHING
                and level <= levelMax
                and level >= levelMin
                and quality <= qualityMax
                and quality >= qualityMin then

                recipe = {}
                recipe.recipeName       = recipeName
                recipe.isKnown          = isKnown
                recipe.listIndex        = listIndex
                recipe.recipeIndex      = recipeIndex
                recipe.ingredientType   = ingredientType
                recipe.numIngredients   = numIg
                recipe.len              = string.len(recipeName)
                recipe.skillLevel       = level
                recipe.skillQuality     = quality

                if (not isKnown) then
                    recipe.errorMsg = GetString(DP_NOTHING_RECIPE)

                elseif quality >= 2 then
                    for igIndex = 1, numIg do
                        itemLink = GetRecipeIngredientItemLink(listIndex, recipeIndex, igIndex)
                        itemType = GetItemLinkItemType(itemLink)
                        if (not itemTypeCache[itemType]) then
                            itemTypeCache[itemType] = true
                            self.itemTypeFilter[#self.itemTypeFilter + 1] = itemType
                        end
                    end
                end
                list[#list + 1] = recipe
            end
        end
    end
    table.sort(list, function(a, b)

        local isMasterA = (a.skillQuality > 1)
        local isMasterB = (b.skillQuality > 1)
        if isMasterA and isMasterB then
            return a.len > b.len
        end
        if isMasterA then -- a > b
            return true
        end
        if isMasterB then -- b > a
            return false
        end

        if a.skillLevel ~= b.skillLevel then
            return a.skillLevel > b.skillLevel
        end

        return a.len > b.len
    end)

    if IsDebug() then
        self:GetSkillLevel()
        self:GetSkillQuality()
        Debug("　　LevelWhenReceived=" .. tostring(self.savedCharVariables.levelWhenReceived))
        Debug("　　QualityWhenReceived=" .. tostring(self.savedCharVariables.qualityWhenReceived))
        Debug("　　hasMaster=" .. tostring(hasMaster))
        Debug("　　hasDaily=" .. tostring(hasDaily))
        Debug("　　Level=" .. tostring(levelMin) .. " to " .. tostring(levelMax))
        Debug("　　Quality=" .. tostring(qualityMin) .. " to " .. tostring(qualityMax))
        for _, recipe in pairs(list) do
            local convertedItemNames = self:ConvertedItemNames(recipe.recipeName)
            local mark = Choice(recipe.isKnown, "|cffff66", "|c5c5c5c")
            Debug("　　" .. mark
                         .. "Lv" .. recipe.skillLevel
                         .. ":Quality".. recipe.skillQuality
                         .. ":Index".. recipe.listIndex .. "-" .. recipe.recipeIndex
                         .. ": " .. table.concat(convertedItemNames, ", ")
                         .. (recipe.errorMsg or "") .. "|r ") 
        end
        Debug("　　Total:" .. #list)
    end

    return list
end




function DailyProvisioning:GetSkillLevel()

    local skillType, skillIndex = GetCraftingSkillLineIndices(CRAFTING_TYPE_PROVISIONING)
    local abilityIndex = 2
    local abilityName, _, _, _, _, purchased, _, rankIndex = GetSkillAbilityInfo(skillType, skillIndex, abilityIndex)
    if (not purchased) then
        rankIndex = 1
    end

    abilityName = abilityName:gsub("(\^)%a*", "")
    Debug("　　" .. abilityName .. " Level" .. rankIndex)
    return rankIndex
end




function DailyProvisioning:GetSkillQuality()

    local skillType, skillIndex = GetCraftingSkillLineIndices(CRAFTING_TYPE_PROVISIONING)
    local abilityIndex = 1
    local abilityName, _, _, _, _, purchased, _, rankIndex = GetSkillAbilityInfo(skillType, skillIndex, abilityIndex)
    if (not purchased) then
        rankIndex = 1
    end

    abilityName = abilityName:gsub("(\^)%a*", "")
    Debug("　　" .. abilityName .. " Quality" .. rankIndex)
    return rankIndex
end




function DailyProvisioning:GetStackList()

    local stackList = {}
    for i, bagId in ipairs({BAG_BACKPACK, BAG_VIRTUAL, BAG_BANK, BAG_SUBSCRIBER_BANK}) do
        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            local itemType = GetItemType(bagId, slotIndex)
            if ContainsNumber(itemType, self.itemTypeFilter) then
                local itemId = GetItemId(bagId, slotIndex)
                local _, stack = GetItemInfo(bagId, slotIndex)
                local totalStack = stackList[itemId] or 0
                stackList[itemId] = totalStack + stack
            end

            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return stackList
end




function DailyProvisioning:IsDontKnow(infos)

    if self.isDontKnow ~= nil then
        return self.isDontKnow, self.dontKnowRecipe
    end

    if (not self.savedVariables.isDontKnow) then
        Debug("　　　　Off")
        self.isDontKnow = false
        self.dontKnowRecipe = nil
        return self.isDontKnow, self.dontKnowRecipe
    end


    Debug("[IsDontKnow]")
    local parameter
    for _, info in pairs(infos) do
        if (not info.isMaster)
            and self:IsValidConditions(info.convertedTxt, info.current, info.max, info.isVisible) then

            parameter = self:CreateParameter(info)[1]
            if (not parameter) then
                if (self.checkedJournal[info.key] ~= false) then
                    local msg = zo_strformat(GetString(DP_MISMATCH_RECIPE), info.txt:gsub("\n", ""))
                    self:Message(msg, ZO_ERROR_COLOR:ToHex())
                end
                self.isDontKnow = nil
                self.dontKnowRecipe = nil
                return self.isDontKnow, self.dontKnowRecipe

            elseif parameter.errorMsg and (not parameter.isKnown) then
                self.bulkConditionText = nil
                self.executeCurrent = nil
                self.executeToEnd = nil
                self.isDontKnow = true
                self.dontKnowRecipe = parameter.recipeName
                return self.isDontKnow, self.dontKnowRecipe
            end
            self.bulkConditionText = nil
            self.executeCurrent = nil
            self.executeToEnd = nil
        end
    end
    self.bulkConditionText = nil
    self.executeCurrent = nil
    self.executeToEnd = nil
    self.isDontKnow = false
    self.dontKnowRecipe = nil
    return self.isDontKnow, self.dontKnowRecipe
end




function DailyProvisioning:IsValidAcquireItemConditions(current, max, isVisible, conditionText)

    if (not isVisible) then
        return false
    end
    if (not conditionText) or conditionText == "" then
        return false
    end


    if current < max then
        if Contains(conditionText, self:CraftingConditions()) then

            Debug("　　journalAcquireCondition(O):" .. tostring(conditionText))
            return true
        end
    end
    Debug("|c5c5c5c" .. "　　journalAcquireCondition(X):" .. tostring(conditionText) .. "|r")
    return false
end




function DailyProvisioning:IsValidAcquireMaterialConditions(current, max, isVisible, conditionText)

    if (not isVisible) then
        return false
    end
    if (not conditionText) or conditionText == "" then
        return false
    end


    if current < max then
        if Contains(conditionText, self:CraftingConditions()) then
            Debug("　　journalMaterialCondition(O):" .. tostring(conditionText))
            return true
        end
    end
    Debug("|c5c5c5c" .. "　　journalMaterialCondition(X):" .. tostring(conditionText) .. "|r")
    return false
end




function DailyProvisioning:IsValidConditions(conditionText, current, max, isVisible)

    if (not conditionText) or conditionText == "" then
        return nil
    end

    if (self.savedVariables.bulkQuantity) then
        if self.executeCurrent == nil and isVisible and (current < max) then
            local conditions = self.CraftingConditions()
            if (#conditions == 0) or Contains(conditionText, conditions) then
                self.bulkConditionText = conditionText
                self.executeCurrent = 0
                self.executeToEnd = tonumber(self.savedVariables.bulkQuantity)
                Debug("　　journalCondition(O):" .. tostring(conditionText))
                return conditionText
            end

        elseif self.executeCurrent == nil then
            Debug("|c5c5c5c" .. "　　journalCondition(X):" .. tostring(conditionText) .. "|r")
            return nil

        elseif self.executeCurrent < self.executeToEnd then
            Debug("　　journalCondition(O):" .. tostring(self.bulkConditionText))
            return self.bulkConditionText
        else
            self.bulkConditionText = nil
            self.executeCurrent = nil
            self.executeToEnd = nil
        end

    elseif isVisible and (current < max) then
        local conditions = self.CraftingConditions()
        if (#conditions == 0) or Contains(conditionText, conditions) then
            Debug("　　journalCondition(O):" .. tostring(conditionText))
            return conditionText
        end
    end

    Debug("|c5c5c5c" .. "　　journalCondition(X):" .. tostring(conditionText) .. "|r")
    return nil
end




function DailyProvisioning:IsValidQuest(questIdx, questName)

    local craftingQuests = {GetString(DP_CRAFTING_QUEST), GetString(DP_CRAFTING_MASTER)}

    if GetJournalQuestType(questIdx) == QUEST_TYPE_CRAFTING then
        if (not GetJournalQuestIsComplete(questIdx)) then
            if Contains(questName, craftingQuests) then
                Debug("　　questName(O):" .. tostring(questName))
                return true
            end
        end
        Debug("　　|c5c5c5c" .. "questName(X):" .. tostring(questName) .. "|r")
    end
    return false
end




function DailyProvisioning:Message(msg, color)
    if self.isSilent then
        return
    end
    if (not self.savedVariables.isLog) then
        return
    end
    if color then
        d("|c88aaff" .. self.name .. ":|r |c" .. color .. msg .. "|r")
    else
        d("|c88aaff" .. self.name .. ":|r |cffffff" .. msg .. "|r")
    end
    if self.savedVariables.isDebug then
        local log = self.name .. tostring(msg):gsub("　", "  "):gsub("|c5c5c5c", ""):gsub("|cffff66", ""):gsub("|r", "")
        table.insert(DailyProvisioning.savedVariables.debugLog, log)
    end
end




function DailyProvisioning:CountByItem(itemLink, current, max, bagIdList)

    if (not itemLink) then
        return 0
    end
    if current >= max then
        return 0
    end


    Debug("　　　　　　[CountByItem " .. itemLink .. " (" .. current .. " to " .. max .. ")]")
    local itemId = GetItemLinkItemId(itemLink)
    local counted = 0
    for _, bagId in ipairs(bagIdList) do
        if current >= max then
            return counted
        end

        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            if (current >= max) then
                return counted
            end
            if GetItemId(bagId, slotIndex) == itemId then
                itemLink = GetItemLink(bagId, slotIndex)    -- GetItemLink() ≠ GetRecipeResultItemLink()
                local _, stack = GetItemInfo(bagId, slotIndex)
                local quantity = math.min(max - current, stack)
                Debug(zo_iconFormat(GetItemLinkIcon(itemLink), 18, 18) .. itemLink .. " x " .. quantity)
                current = current + quantity
                counted = counted + quantity
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return counted
end




function DailyProvisioning:MoveByItem(itemLink, current, max, bagIdList)

    if (not itemLink) then
        return 0
    end
    if current >= max then
        return 0
    end


    Debug("　　　　　　[MoveByItem " .. itemLink .. " (" .. current .. " to " .. max .. ")]")
    local itemId = GetItemLinkItemId(itemLink)
    local moved = 0
    for _, bagId in ipairs(bagIdList) do
        if current >= max then
            return moved
        end

        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            if (current >= max) then
                return moved
            end
            if GetItemId(bagId, slotIndex) == itemId then
                itemLink = GetItemLink(bagId, slotIndex)    -- GetItemLink() ≠ GetRecipeResultItemLink()
                local _, stack = GetItemInfo(bagId, slotIndex)
                local quantity = math.min(max - current, stack)

                if IsProtectedFunction("RequestMoveItem") then
                    CallSecureProtected("RequestMoveItem", bagId, slotIndex, BAG_BACKPACK, self.emptySlot, quantity)
                else
                    RequestMoveItem(bagId, slotIndex, BAG_BACKPACK, self.emptySlot, quantity)
                end
                self.emptySlot = self:NextEmptySlot(self.emptySlot)
                self:Message(zo_iconFormat(GetItemLinkIcon(itemLink), 18, 18) .. itemLink .. " x " .. quantity)
                current = current + quantity
                moved = moved + quantity
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return moved
end




function DailyProvisioning:NextEmptySlot(slotIndex)

    if slotIndex == nil and DailyAlchemy and DailyAlchemy.emptySlot then
        Debug("took over the emptySlot of DailyAlchemy:" .. tostring(DailyAlchemy.emptySlot))
        return DailyAlchemy.emptySlot
    end

    if slotIndex then
        slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, slotIndex)
        while slotIndex and GetItemId(BAG_BACKPACK, slotIndex) ~= 0 do
            slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, slotIndex)
        end
    end

    if slotIndex == nil then
        slotIndex = FindFirstEmptySlotInBag(BAG_BACKPACK)
    end

    return slotIndex
end




function DailyProvisioning:OnAddOnLoaded(event, addonName)
    if addonName ~= self.name then
        return
    end

    SLASH_COMMANDS["/langen"] = function() SetCVar("language.2", "en") end
    SLASH_COMMANDS["/langjp"] = function() SetCVar("language.2", "jp") end
    SLASH_COMMANDS["/langde"] = function() SetCVar("language.2", "de") end
    SLASH_COMMANDS["/langfr"] = function() SetCVar("language.2", "fr") end
    if RuESO then
        SLASH_COMMANDS["/langru"] = function() SetCVar("language.2", "ru") end
    end

    self.savedVariables = ZO_SavedVars:NewAccountWide("DailyProvisioningVariables", 1, nil, {})
    self.savedCharVariables  = ZO_SavedVars:New("DailyProvisioningVariables", 1, nil, {})
    self.savedVariables.debugLog = {}

    self:CreateMenu()

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_CRAFTING_STATION_INTERACT,     function(...) self:StationInteract(...) end)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_CRAFT_COMPLETED,               function(...) self:CraftCompleted(...) end)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_END_CRAFTING_STATION_INTERACT, function(...) self:Finalize(...) end)

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED,              function(...) self:Camehome(...) end)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_OPEN_BANK,                     function(...) self:Acquire(...) end)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_CLOSE_BANK,                    function(...) self:Finalize(...) end)


    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_ADDED,                   function(...) self:QuestReceived(...) end)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_COMPLETE,                function(...) self:QuestComplete(...) end)
    ZO_PreHook("ZO_InventorySlot_ShowContextMenu",                                 function(...) self:ShowContextMenu(...) end)
    self:PostHook(ZO_PlayerInventoryBackpack.dataTypes[1], "setupCallback",        function(...) self:UpdateInventory(...) end)
end




function DailyProvisioning:PostHook(objectTable, existingFunctionName, hookFunction)
    local existingFunction = objectTable[existingFunctionName]
    if existingFunction == nil then
        return
    end
    if type(existingFunction) ~= "function" then
        return
    end

    local newFunction = function(...)
        local result = existingFunction(...)
        hookFunction(...)
        return result
    end
    objectTable[existingFunctionName] = newFunction
end




function DailyProvisioning:QuestComplete()
    local oldReservations = self.savedVariables.reservations
    local newReservations = {}
    local uniqueId
    local reservation
    local slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, nil)
    while slotIndex do
        if string.match(GetItemInfo(BAG_BACKPACK, slotIndex), "master_writ_alchemy") then
            uniqueId = Id64ToString(GetItemUniqueId(BAG_BACKPACK, slotIndex))
            reservation = oldReservations[uniqueId]
            if reservation then
                newReservations[uniqueId] = reservation
            end
        end
        slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, slotIndex)
    end
    self.savedVariables.reservations = newReservations
end




function DailyProvisioning:QuestReceived(eventCode, journalIndex, questName, objectiveName)

    if Contains(questName, {GetString(DP_CRAFTING_QUEST)}) then
        self.savedCharVariables.levelWhenReceived = self:GetSkillLevel()
        self.savedCharVariables.qualityWhenReceived = self:GetSkillQuality()
        self.savedVariables.debugLog = {}
    end
end




function DailyProvisioning:SetStation(recipe)

    if IsInGamepadPreferredMode() then
        if GAMEPAD_PROVISIONER.filterType ~= recipe.ingredientType then
            ZO_GamepadGenericHeader_SetActiveTabIndex(GAMEPAD_PROVISIONER.header, recipe.ingredientType, false)
        end

        GAMEPAD_PROVISIONER:RefreshRecipeList()
        for i, data in pairs (GAMEPAD_PROVISIONER.recipeList.dataList) do
            if data.recipeListIndex == recipe.listIndex then
                if data.recipeIndex == recipe.recipeIndex then
                    zo_callLater(function()
                        GAMEPAD_PROVISIONER.recipeList:SetSelectedIndex(i, true)
                    end, 0)
                    break
                end
            end
        end
        return

    else
        if PROVISIONER.filterType ~= recipe.ingredientType then
            ZO_MenuBar_SelectDescriptor(PROVISIONER.tabs, recipe.ingredientType)
            PROVISIONER:RefreshRecipeList()
        end

        local nodes = PROVISIONER.recipeTree.rootNode:GetChildren()
        if (not nodes) then
            PROVISIONER:RefreshRecipeList()
            nodes = PROVISIONER.recipeTree.rootNode:GetChildren()
            if (not nodes) then
                return
            end
        end
        for _, node in pairs (nodes) do
            if node.data.recipeListIndex == recipe.listIndex then
                PROVISIONER.recipeTree:ToggleNode(node)
                for _, childNode in pairs (node:GetChildren()) do
                    if childNode.data.recipeIndex == recipe.recipeIndex then
                        PROVISIONER.recipeTree:SelectNode(childNode)
                        break
                    end
                end
                break
            end
        end
    end
end




function DailyProvisioning:ShowContextMenu(inventorySlot)

    local slotType = ZO_InventorySlot_GetType(inventorySlot)
    if slotType == SLOT_TYPE_ITEM then
        local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
        local itemLink = GetItemLink(bagId, slotIndex)
        local itemIcon = GetItemLinkIcon(itemLink) 
        if string.match(itemIcon, "master_writ_provisioning") then
            local uniqueId = Id64ToString(GetItemUniqueId(bagId, slotIndex))
            local lang = GetCVar("language.2")
            local txt = GenerateMasterWritBaseText(itemLink)
            txt = self:ConvertedMasterWritText(txt)

            zo_callLater(function()
                local reservations = self.savedVariables.reservations
                if (not reservations) then
                    reservations = {}
                    self.savedVariables.reservations = reservations
                end

                local reservation = reservations[uniqueId]
                if reservation and reservation.current < reservation.max then
                    AddMenuItem(GetString(DP_CANCEL_WRIT), function()
                        reservations[uniqueId] = nil
                        self:Message(GetString(DP_CANCEL_WRIT_MSG))
                        PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_BACKPACK)
                    end)
                else
                    AddMenuItem(GetString(DP_CRAFT_WRIT), function()
                        local reservation = {}
                        reservation.recipeItemId = self:SplitRecipeItemId(itemLink)
                        reservation.txt = txt
                        reservation.current = 0
                        reservation.max = 8
                        reservations[uniqueId] = reservation
                        self:Message(zo_strformat(GetString(DP_CRAFT_WRIT_MSG), txt))
                        PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_BACKPACK)
                    end)
                end
                ShowMenu(self)
            end, 50)
        end
    end
end




function DailyProvisioning:SplitRecipeItemId(masterWrit)
    return string.match(masterWrit, "item:%d+:%d+:%d+:%d+:%d+:%d+:(%d+)")
end




function DailyProvisioning:StationInteract(eventCode, craftSkill, sameStation)

    if craftSkill ~= CRAFTING_TYPE_PROVISIONING then
        return false
    end

    self.savedVariables.debugLog = {}
    self.recipeList = nil
    self:Crafting(eventCode, craftSkill)
end




function DailyProvisioning:UpdateInventory(control)

    local reservations = self.savedVariables.reservations
    if (not reservations) then
        reservations = {}
        self.savedVariables.reservations = reservations
        return
    end

    if ConfirmMasterWrit then
        return
    end

    if (not control) then
        return
    end

    local slot = control.dataEntry.data
    if (not slot) then
        return
    end

    local uniqueId = Id64ToString(GetItemUniqueId(slot.bagId, slot.slotIndex))
    if (not uniqueId) then
        return
    end


    local mark = control:GetNamedChild("DP_ItemMark")
    if (not mark) and reservations[uniqueId] then
        mark = WINDOW_MANAGER:CreateControl(control:GetName() .. "DP_ItemMark", control, CT_TEXTURE)
        mark:SetDrawLayer(3)
        mark:SetDimensions(20, 20)
        mark:ClearAnchors()
        mark:SetAnchor(LEFT, control:GetNamedChild('Bg'), LEFT, 80, 10)
        mark:SetTexture("esoui/art/journal/journal_quest_selected.dds")
    end
    if (not mark) then
        return
    end


    reservation = reservations[uniqueId]
    if reservation then
        if (reservation.current < reservation.max) then
            mark:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_LEGENDARY))
        else
            mark:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_DISABLED))
        end
        mark:SetHidden(false)
    else
        mark:SetHidden(true)
    end
end




EVENT_MANAGER:RegisterForEvent(DailyProvisioning.name, EVENT_ADD_ON_LOADED, function(...) DailyProvisioning:OnAddOnLoaded(...) end)

