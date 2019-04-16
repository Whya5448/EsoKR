DailyAlchemy = {
    displayName = "|c3CB371" .. "Daily Alchemy" .. "|r",
    shortName = "DA",
    name = "DailyAlchemy",
    version = "1.2.23",

    DA_PRIORITY_BY_STOCK = 1,
    DA_PRIORITY_BY_MM = 2,
    DA_PRIORITY_BY_MANUAL = 3,
    DA_PRIORITY_BY_TTC = 4,
    DA_PRIORITY_BY_ATT = 5,

    emptySlot = nil,        -- ※Don't Finalize

    bulkConditionText = nil,
    executeCurrent = nil,
    executeToEnd = nil,
    infos = nil,
    checkedJournal = {},
    stackList = {},
    houseStackList =  {},
    lockedList = {},

    acquiredItemId = nil,
    acquiredItemCurrent = nil,
    isSilent = false,
}




function DailyAlchemy:CraftCompleted(eventCode, craftSkill)

    if craftSkill ~= CRAFTING_TYPE_ALCHEMY then
        return
    end


    local result = self:Crafting(eventCode, craftSkill)


    -- AutoExit check
    if (not self.savedVariables.isAutoExit) then
        return
    end
    if (not result) then
        return
    end
    if (self.savedVariables.bulkQuantity) and (self.executeToEnd ~= nil) then
       return
    end

    local isEmpty = true
    for _, value in pairs(self.checkedJournal) do
        if (not value) then
           return
        end
        isEmpty = false
    end
    if isEmpty then
        return
    end
    EndInteraction(INTERACTION_CRAFT)
end




function DailyAlchemy:Crafting(eventCode, craftSkill)

    self:Debug("[Pre Crafting]")
    self.infos = self.infos or self:GetQuestInfos()
    if self.infos == nil or #self.infos == 0 then
        self:Debug("　　No Quest")
        return true
    end


    self:Debug("[Crafting]")
    for _, info in pairs(self.infos) do
        if self:IsValidConditions(info) then
            local parameter = self:CreateParameter(info)

            if parameter then
                self:SetStation(parameter)
                CraftAlchemyItem(parameter.solvent.bagId,   parameter.solvent.slotIndex,
                                 parameter.reagent1.bagId,  parameter.reagent1.slotIndex,
                                 parameter.reagent2.bagId,  parameter.reagent2.slotIndex,
                                 parameter.reagent3.bagId,  parameter.reagent3.slotIndex)

                local quantity = tostring(info.max - info.current)
                if self.executeCurrent then
                    self.executeCurrent = self.executeCurrent + parameter.stack
                    if (self.executeCurrent > self.executeToEnd) then
                        self.executeCurrent = self.executeToEnd
                    end
                    quantity = self.executeCurrent .. "/" .. self.executeToEnd .. " [" .. GetString(DA_BULK_HEADER) .. "]"
                end
                self:Message(parameter.resultLink .. " x " .. quantity)

                info.current = math.min(info.current + self:GetAmountToMake(parameter.itemType), info.max)
                self.checkedJournal[info.key] = true
                if info.uniqueId then
                    self.savedVariables.reservations[info.uniqueId].current = info.current
                end
                return false

            elseif GetInteractionType() == INTERACTION_CRAFT then
                self.executeCurrent = nil
                self.checkedJournal[info.key] = true
            end

        elseif info.isAcquire and info.current < info.max then
            local msg, msg2 = self:Contains(info.convertedTxt, self:AcquireConditions())
            if msg then
                if self.checkedJournal[info.key] == nil then
                    msg = msg .. (msg2 or "")
                    self:Message(zo_strformat(GetString(DA_NOTHING_ITEM), msg))
                end
                self.checkedJournal[info.key] = false
            end
        end

    end
    return true
end




function DailyAlchemy:CreateParameter(info)

    self:Debug("　　[CreateParameter]")
    self.stackList = self:GetStackList()
    self.houseStackList = self:GetHouseStackList()
    local parameterList = self:Advice(info.convertedTxt, info.current, info.max, info.isMaster)

    local solvent
    local reagent1
    local reagent2
    local reagent3
    local result
    for _, parameter in ipairs(parameterList) do
        solvent = parameter.solvent
        solvent.bagId, solvent.slotIndex = self:GetFirstStack(solvent.itemId)

        reagent1 = parameter.reagent1
        reagent1.bagId, reagent1.slotIndex = self:GetFirstStack(reagent1.itemId)

        reagent2 = parameter.reagent2
        reagent2.bagId, reagent2.slotIndex = self:GetFirstStack(reagent2.itemId)

        reagent3 = parameter.reagent3
        reagent3.bagId, reagent3.slotIndex = self:GetFirstStack(reagent3.itemId)

        result = self:CreateResult(info.convertedTxt, solvent, reagent1, reagent2, reagent3)
        if result then
            break
        end
    end


    if self:IsDebug() then
        if result then
            local mark = "|cffff66"
            local addInfo1 = ""
            local addInfo2 = ""
            local addInfo3 = ""
            if self.savedVariables.priorityBy == self.DA_PRIORITY_BY_STOCK then
                local icon = zo_iconFormat("EsoUI/Art/currency/currency_gold.dds", 16, 16)
                addInfo1 = "x" .. (result.reagent1.stack or 0)
                addInfo2 = "x" .. (result.reagent2.stack or 0)
                addInfo3 = "x" .. (result.reagent3.stack or 0)
            elseif self:ContainsNumber(self.savedVariables.priorityBy, self.DA_PRIORITY_BY_MM,
                                                                       self.DA_PRIORITY_BY_TTC,
                                                                       self.DA_PRIORITY_BY_ATT) then
            elseif self.savedVariables.priorityBy == self.DA_PRIORITY_BY_MANUAL then
                local icon = zo_iconFormat("esoui/art/skillsadvisor/advisor_tabicon_settings_down.dds", 18, 18)
                addInfo1 = " " .. result.reagent1.priority .. icon
                addInfo2 = " " .. result.reagent2.priority .. icon
                addInfo3 = " " .. result.reagent3.priority .. icon
            end
            local reagent3info = ""
            if result.reagent3.itemLink then
                reagent3info = ", " .. result.reagent3.itemLink .. addInfo3
            end
            self:Debug("　　　　parameter ="
                              .. result.resultLink
                              .. " [" .. result.solvent.itemLink .. ", "
                              .. result.reagent1.itemLink .. addInfo1 .. ", "
                              .. result.reagent2.itemLink .. addInfo2
                              .. reagent3info .. " ]" )
        else
            self:Debug("　　　　parameter is nil")
        end
    end
    return result
end




function DailyAlchemy:CreateResult(conditionText, solvent, reagent1, reagent2, reagent3)

    self:Debug("　　　　[CreateResult]")
    if (not reagent3) then
        reagent3 = {}
        reagent3.bagId = nil
        reagent3.slotIndex = nil
        reagent3.itemId = 0
        reagent3.itemName = nil
        reagent3.itemLink = nil
        reagent3.stack = " "
        reagent3.price = 0
        reagent3.priority = self:GetPriority(itemId)
    end


    local resultName, _, stack, _, _, _, _, _, alchemyResult = GetAlchemyResultingItemInfo(solvent.bagId,
                                                                                           solvent.slotIndex,
                                                                                           reagent1.bagId,
                                                                                           reagent1.slotIndex,
                                                                                           reagent2.bagId,
                                                                                           reagent2.slotIndex,
                                                                                           reagent3.bagId,
                                                                                           reagent3.slotIndex)
    self:Debug("　　　　　　resultName=" .. tostring(resultName))
    self:Debug("　　　　　　alchemyResult=" .. tostring(alchemyResult))
    if resultName
        and resultName ~= ""
        and alchemyResult ~= PROSPECTIVE_ALCHEMY_RESULT_UNCRAFTABLE
        and self:Contains(conditionText, self:ConvertedItemNames(resultName)) then

        local resultLink = GetAlchemyResultingItemLink(solvent.bagId,
                                                       solvent.slotIndex,
                                                       reagent1.bagId,
                                                       reagent1.slotIndex,
                                                       reagent2.bagId,
                                                       reagent2.slotIndex,
                                                       reagent3.bagId,
                                                       reagent3.slotIndex)

        local result = {}
        result.resultLink = resultLink
        result.itemId     = GetItemLinkItemId(resultLink)
        result.itemType   = GetItemLinkItemType(resultLink)
        result.stack      = stack
        result.solvent    = solvent
        result.reagent1   = reagent1
        result.reagent2   = reagent2
        result.reagent3   = reagent3
        return result
    end
    return nil

end




function DailyAlchemy:Finalize()

    self:Debug("[Finalize]")
    self.bulkConditionText = nil
    self.executeCurrent = nil
    self.executeToEnd = nil
    self.infos = nil
    self.checkedJournal = {}

    self.acquiredItemId = nil
    self.acquiredItemCurrent = nil
    self.stackList = {}
    self.houseStackList = {}
    self.lockedList = {}
    self.isSilent = false
end




function DailyAlchemy:GetAmountToMake(itemType)

    local skillType, skillIndex = GetCraftingSkillLineIndices(CRAFTING_TYPE_ALCHEMY)
    local abilityIndex = 4
    local abilityName, _, _, _, _, purchased, _, rankIndex = GetSkillAbilityInfo(skillType, skillIndex, abilityIndex)
    if (not purchased) then
        rankIndex = 0
    end
    if itemType == ITEMTYPE_POTION then
        return 1 + rankIndex
    else
        return 4 + (rankIndex * 4)
    end
end




function DailyAlchemy:GetAvgPrice(itemLink)

    local saveVer = self.savedVariables
    if saveVer.priorityBy == self.DA_PRIORITY_BY_STOCK then
        return 0
    end


    if MasterMerchant then
        if (saveVer.priorityBy == self.DA_PRIORITY_BY_MM)
        or (saveVer.priorityBy == self.DA_PRIORITY_BY_MANUAL and saveVer.showPriceMM) then

            local tipStats = MasterMerchant:itemStats(itemLink)
            if tipStats and tipStats.avgPrice then
                return tipStats.avgPrice
            end
            return 0
        end
    end


    if TamrielTradeCentre then
        if (saveVer.priorityBy == self.DA_PRIORITY_BY_TTC)
        or (saveVer.priorityBy == self.DA_PRIORITY_BY_MANUAL and saveVer.showPriceTTC) then

            local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(itemLink)
            if priceInfo and priceInfo.Avg then
                return priceInfo.Avg
            end
            return 0
        end
    end


    if ArkadiusTradeTools and ArkadiusTradeTools.Modules and ArkadiusTradeTools.Modules.Sales then
        if (saveVer.priorityBy == self.DA_PRIORITY_BY_ATT)
        or (saveVer.priorityBy == self.DA_PRIORITY_BY_MANUAL and saveVer.showPriceATT) then

            -- Returns an average price for the last 3 days
            local days = GetTimeStamp() - (24 * 60 * 60 * 3)
            local avgPrice = ArkadiusTradeTools.Modules.Sales:GetAveragePricePerItem(itemLink, days)
            if avgPrice then
                return avgPrice
            end
            return 0
        end
    end


    return 0
end




function DailyAlchemy:GetCraftingBagList()

    if GetInteractionType() == INTERACTION_BANK and IsOwnerOfCurrentHouse() then
        local _, name, _, _, additionalInfo, houseBankBagId = GetGameCameraInteractableActionInfo()
        if additionalInfo == ADDITIONAL_INTERACT_INFO_HOUSE_BANK then
            return {
                BAG_BANK,
                BAG_BACKPACK,
                BAG_VIRTUAL,
                houseBankBagId,
            }
        end
    end

    return {
        BAG_BANK,
        BAG_BACKPACK,
        BAG_VIRTUAL,
        BAG_SUBSCRIBER_BANK,
    }
end




function DailyAlchemy:GetFirstStack(itemId)
    if itemId == nil then
        return nil, nil
    end

    for i, bagId in ipairs(self:GetCraftingBagList()) do
        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            local itemType = GetItemType(bagId, slotIndex)
            if self:ContainsNumber(itemType, ITEMTYPE_POTION_BASE,
                                             ITEMTYPE_POISON_BASE,
                                             ITEMTYPE_REAGENT) and self:IsUnLocked(bagId, slotIndex) then

                if GetItemId(bagId, slotIndex) == itemId then
                    return bagId, slotIndex
                end
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return nil, nil
end




function DailyAlchemy:GetPriority(itemId)

    if self.savedVariables.priorityBy ~= self.DA_PRIORITY_BY_MANUAL then
        return nil
    end
    if (not itemId) or (itemId == 0) then
        return #self.savedVariables.priorityByManual + 1
    end


    for key, value in ipairs(self.savedVariables.priorityByManual) do
        if value == itemId then
            return key
        end
    end
    return #self.savedVariables.priorityByManual + 1
end




function DailyAlchemy:GetQuestInfos()

    self.acquiredItemId = nil
    self.acquiredItemCurrent = nil
    local list = {}
    for questIdx = 1, MAX_JOURNAL_QUESTS do
        local questName = GetJournalQuestName(questIdx)
        if self:IsValidQuest(questIdx, questName) then

            local isMaster = string.match(questName, GetString(DA_CRAFTING_MASTER))
            for stepIdx = 1, GetJournalQuestNumSteps(questIdx) do
                for conditionIdx = 1, GetJournalQuestNumConditions(questIdx, stepIdx) do

                    local key = table.concat({questIdx, stepIdx, conditionIdx}, "_")
                    local txt, current, max, _, _, _, isVisible, conditionType = GetJournalQuestConditionInfo(questIdx,
                                                                                                              stepIdx,
                                                                                                              conditionIdx)
                    local convertedTxt = self:ConvertedJournalCondition(txt)
                    local isCrafting, isAcquire = self:IsValidJournal(isVisible, current, max, convertedTxt)
                    if isCrafting or isAcquire then
                        local info = {}
                        info.txt = txt
                        info.convertedTxt = convertedTxt
                        info.current = current
                        info.max = max
                        info.isMaster = isMaster
                        info.isCrafting = isCrafting
                        info.isAcquire = isAcquire
                        info.key = key
                        info.questIdx = questIdx
                        info.stepIdx = stepIdx
                        info.conditionIdx = conditionIdx
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
        if string.match(GetItemInfo(BAG_BACKPACK, slotIndex), "master_writ_alchemy") then
            uniqueId = Id64ToString(GetItemUniqueId(BAG_BACKPACK, slotIndex))
            reservation = reservations[uniqueId]
            if reservation and reservation.current < reservation.max then
                self:Debug("questName(O):--")
                txt = GenerateMasterWritBaseText(GetItemLink(BAG_BACKPACK, slotIndex))
                local info = {}
                info.uniqueId = uniqueId
                info.txt = txt
                info.convertedTxt = self:ConvertedJournalCondition(txt)
                info.current = reservation.current
                info.max = reservation.max
                info.isMaster = true
                info.isCrafting = true
                info.isAcquire = false
                info.key = uniqueId
                list[#list + 1] = info
                self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>)", info.convertedTxt,
                                                                              info.current,
                                                                              info.max))
            end
        end
        slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, slotIndex)
    end
    return list
end




function DailyAlchemy:GetSkillRank()

    local skillType, skillIndex = GetCraftingSkillLineIndices(CRAFTING_TYPE_ALCHEMY)
    local abilityIndex = 1
    local abilityName, _, _, _, _, purchased, _, rankIndex = GetSkillAbilityInfo(skillType, skillIndex, abilityIndex)
    if (not purchased) then
        rankIndex = 0
    end
    return rankIndex
end



function DailyAlchemy:IsLocked(itemLink)

    if self.savedVariables.useItemLock and FCOIS then
        return self.lockedList[itemLink]
    end

    return false
end




function DailyAlchemy:IsUnLocked(bagId, slotIndex)

    if self.savedVariables.useItemLock and FCOIS and FCOIS.IsMarked(bagId, slotIndex, -1) then
        self.lockedList[GetItemLink(bagId, slotIndex)] = true
        return false
    end

    return true
end




function DailyAlchemy:IsValidConditions(info)

    if info.isCrafting then
        if self.savedVariables.bulkQuantity then
            if self.executeCurrent == nil and info.isCrafting and info.current < info.max then
                self.bulkConditionText = info.convertedTxt
                self.executeCurrent = 0
                self.executeToEnd = tonumber(self.savedVariables.bulkQuantity)
                self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>) ※bulkStart", self.bulkConditionText,
                                                                                          info.current,
                                                                                          info.max))
                return true

            elseif self.executeCurrent and self.executeCurrent < self.executeToEnd then
                self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>) ※bulk", self.bulkConditionText,
                                                                                     self.executeCurrent,
                                                                                     self.executeToEnd))
                info.convertedTxt = self.bulkConditionText
                return true

            else
                self.bulkConditionText = nil
                self.executeCurrent = nil
                self.executeToEnd = nil
            end

        elseif info.current < info.max then
            self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>)", info.convertedTxt,
                                                                          info.current,
                                                                          info.max))
            return true
        end
    end

    self:Debug(zo_strformat("|c5c5c5c　　journal(X):<<1>> (<<2>>/<<3>>)|r", info.convertedTxt,
                                                                            info.current,
                                                                            info.max))
    return false
end




function DailyAlchemy:IsValidJournal(isVisible, current, max, conditionText)

    if conditionText == nil or conditionText == "" then
        return false, false
    end


    if isVisible then
        if current < max and self:Contains(conditionText, self:CraftingConditions()) then
            self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>)", conditionText,
                                                                          current,
                                                                          max))
            return true, false
        end

        if self:Contains(conditionText, self:AcquireConditions()) then
            local itemId
            local stack
            local slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, nil)
            while slotIndex do
                itemId = self:IsValidItem(conditionText, BAG_BACKPACK, slotIndex)
                stack = GetItemTotalCount(BAG_BACKPACK, slotIndex)
                if itemId and itemId ~= 0 then
                    self:Debug("※Acquired " .. GetItemLink(BAG_BACKPACK, slotIndex) .. "x" .. stack .. " in Backpack")
                    self.acquiredItemId = itemId
                    self.acquiredItemCurrent = current
                    break
                end
                slotIndex = ZO_GetNextBagSlotIndex(BAG_BACKPACK, slotIndex)
            end

            if current < max then
                self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>)", conditionText,
                                                                              current,
                                                                              max))
                return false, true
            end
        end
    end
    self:Debug(zo_strformat("|c5c5c5c　　journal(X):<<1>> (<<2>>/<<3>>)|r", conditionText,
                                                                            current,
                                                                            max))
    return false, false
end




function DailyAlchemy:IsValidParameter(validKeyCache, reagent1, reagent2, reagent3)

    local traitMinCount
    local list
    local keyList
    if reagent3 then
        if reagent1.itemId == reagent2.itemId then
            return nil
        end
        if reagent1.itemId == reagent3.itemId then
            return nil
        end
        if reagent2.itemId == reagent3.itemId then
            return nil
        end
        list = {reagent1, reagent2, reagent3}
        keyList = {reagent1.itemId, reagent2.itemId, reagent3.itemId}
        traitMinCount = 3

    else
        if reagent2.itemId == reagent1.itemId then
            return nil
        end
        list = {reagent1, reagent2}
        keyList = {reagent1.itemId, reagent2.itemId}
        traitMinCount = 1
    end

    table.sort(keyList)
    local key = tonumber(table.concat(keyList, ""))
    if validKeyCache[key] then
        return nil
    end
    validKeyCache[key] = true


    local summary = {}
    for _, reagent in ipairs(list) do
        for i, trait in ipairs(reagent.traits) do
            if summary[trait] then
                summary[trait].total = summary[trait].total + 1
            else
                summary[trait] = {}
                summary[trait].trait = trait
                summary[trait].total = 1
                summary[trait].traitPriority = reagent.traitPrioritys[i]
            end
        end
    end


    local resultTraits = {}
    local traitCount = 0
    for _, value in pairs(summary) do
        if value.total >= 2 then
            traitCount = traitCount + 1
            resultTraits[#resultTraits + 1] = value
        end
    end
    if traitCount < traitMinCount then
        return nil
    end

    table.sort(resultTraits, function(a, b)
        return a.traitPriority < b.traitPriority
    end)


    local traits = {}
    for _, resultTrait in pairs(resultTraits) do
        traits[#traits + 1] = resultTrait.trait
    end
    return traits, resultTraits[1].traitPriority
end




function DailyAlchemy:IsValidQuest(questIdx, questName)

    local craftingQuests = {GetString(DA_CRAFTING_QUEST), GetString(DA_CRAFTING_MASTER)}

    if GetJournalQuestType(questIdx) == QUEST_TYPE_CRAFTING then
        if (not GetJournalQuestIsComplete(questIdx)) then
            if self:Contains(questName, craftingQuests) then
                self:Debug("questName(O):" .. tostring(questName))
                return true
            end
        end
    end
    return false
end




function DailyAlchemy:OnAddOnLoaded(event, addonName)

    if addonName ~= DailyAlchemy.name then
        return
    end
    setmetatable(DailyAlchemy, {__index = LibStub("LibMarify")})

    SLASH_COMMANDS["/langen"] = function() SetCVar("language.2", "en") end
    SLASH_COMMANDS["/langjp"] = function() SetCVar("language.2", "jp") end
    SLASH_COMMANDS["/langde"] = function() SetCVar("language.2", "de") end
    SLASH_COMMANDS["/langfr"] = function() SetCVar("language.2", "fr") end
    if RuESO then
        SLASH_COMMANDS["/langru"] = function() SetCVar("language.2", "ru") end
    end

    self.savedVariables = ZO_SavedVars:NewAccountWide("DailyAlchemyVariables", 1, nil, {})
    self.savedCharVariables  = ZO_SavedVars:New("DailyAlchemyVariables", 1, nil, {})
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
    self:PostHook(ZO_PlayerInventoryBackpack.dataTypes[1], "setupCallback",        function(obj, ...) self:UpdateInventory(obj) end)
end




function DailyAlchemy:QuestComplete()
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




function DailyAlchemy:QuestReceived(eventCode, journalIndex, questName, objectiveName)

    if self:Contains(questName, {GetString(DA_CRAFTING_QUEST)}) then
        self.savedCharVariables.rankWhenReceived = self:GetSkillRank()
        self.savedVariables.debugLog = {}
    end
end




function DailyAlchemy:SetStation(parameter)

    if ALCHEMY:HasSelections() then
        ALCHEMY:ClearSelections()
    end
    ALCHEMY:SetSolventItem(parameter.solvent.bagId,     parameter.solvent.slotIndex) 
    ALCHEMY:SetReagentItem(1, parameter.reagent1.bagId, parameter.reagent1.slotIndex)
    ALCHEMY:SetReagentItem(2, parameter.reagent2.bagId, parameter.reagent2.slotIndex)
    if parameter.reagent3.bagId then
        ALCHEMY:SetReagentItem(3, parameter.reagent3.bagId, parameter.reagent3.slotIndex)
    end
end




function DailyAlchemy:ShowContextMenu(inventorySlot)

    local slotType = ZO_InventorySlot_GetType(inventorySlot)
    if slotType == SLOT_TYPE_ITEM then
        local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
        local itemLink = GetItemLink(bagId, slotIndex)
        local itemIcon = GetItemLinkIcon(itemLink) 
        if string.match(itemIcon, "master_writ_alchemy") then
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

                if reservations[uniqueId] then
                    AddMenuItem(GetString(DA_CANCEL_WRIT), function()
                        reservations[uniqueId] = nil
                        self:Message(GetString(DA_CANCEL_WRIT_MSG))
                        PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_BACKPACK)
                    end)
                else
                    AddMenuItem(GetString(DA_CRAFT_WRIT), function()
                        local reservation = {}
                        reservation.txt = txt
                        reservation.current = 0
                        reservation.max = 20
                        reservations[uniqueId] = reservation
                        self:Message(zo_strformat(GetString(DA_CRAFT_WRIT_MSG), txt))
                        PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_BACKPACK)
                    end)
                end
                ShowMenu(self)
            end, 50)
        end
    end
end




function DailyAlchemy:StationInteract(eventCode, craftSkill, sameStation)

    if craftSkill ~= CRAFTING_TYPE_ALCHEMY then
        return
    end

    self.savedVariables.debugLog = {}
    self:Crafting(eventCode, craftSkill)
end




function DailyAlchemy:UpdateInventory(control)

    local reservations = self.savedVariables.reservations
    if (not reservations) then
        reservations = {}
        self.savedVariables.reservations = reservations
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


    local mark = control:GetNamedChild("DA_ItemMark")
    if (not mark) and reservations[uniqueId] then
        mark = WINDOW_MANAGER:CreateControl(control:GetName() .. "DA_ItemMark", control, CT_TEXTURE)
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




EVENT_MANAGER:RegisterForEvent(DailyAlchemy.name, EVENT_ADD_ON_LOADED, function(...) DailyAlchemy:OnAddOnLoaded(...) end)

