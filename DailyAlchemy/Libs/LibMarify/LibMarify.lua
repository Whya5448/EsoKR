
local LibMarify = LibStub:NewLibrary("LibMarify", "1.0.2")
if (not LibMarify) then
    return
end






function LibMarify:Choice(conditions, trueValue, falseValue)

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




function LibMarify:Contains(text, ...)
    if text == nil or text == "" then
        return nil
    end
    if type(text) == "table" then
        local msg = "text is table! @Equal()"
        d("|c88aaff" .. self.name .. ":|r |cFF0000" .. msg .. "|r")
        return false
    end

    local keyList = {...}
    if type(keyList[1]) == "table" then
        keyList = keyList[1]
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





function LibMarify:ContainsNumber(num, ...)

    if num == nil then
        return false
    end
    if type(num) == "table" then
        local msg = "num is table! @ContainsNumber()"
        d("|c88aaff" .. self.name .. ":|r |cFF0000" .. msg .. "|r")
        return false
    end

    local keyList = {...}
    if type(keyList[1]) == "table" then
        keyList = keyList[1]
    end
    for i, key in ipairs(keyList) do
        if num == key then
            return true
        end
    end
    return false
end




function LibMarify:Debug(text)
    if self.isSilent then
        return
    end
    if self.savedVariables and self.savedVariables.isDebug then
        d((self.shortName or self.name) .. ":" .. text)

        local log = tostring(text):gsub("　", "  "):gsub("|c5c5c5c", ""):gsub("|cffff66", ""):gsub("|r", "")
        if self.savedVariables.debugLog == nil then
            self.savedVariables.debugLog = {}
        end
        table.insert(self.savedVariables.debugLog, log)
    end
end




function LibMarify:DebugIfMarify(text)

    if GetDisplayName() == "@Marify" then
        if self.isSilent then
            return
        end
        d((self.shortName or self.name) .. ":" .. text)
    end
end




function LibMarify:Equal(text, ...)

    if text == nil or text == "" then
        return false
    end
    if type(text) == "table" then
        local msg = "text is table! @Equal()"
        d("|c88aaff" .. self.name .. ":|r |cFF0000" .. msg .. "|r")
        return false
    end

    local keyList = {...}
    if type(keyList[1]) == "table" then
        keyList = keyList[1]
    end


    local lowerText = string.lower(text)
    local result
    for _, key in ipairs(keyList) do
        if key and key ~= "" then
            if text == key then
                return true
            end

            local lowerKey = string.lower(key)
            if lowerText == lowerKey then
                return true
            end
        end
    end
    return nil
end




function LibMarify:GetHouseBankIdList()

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




function LibMarify:GetItemBagList()

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
                BAG_SUBSCRIBER_BANK}

    else
        return {BAG_BANK, BAG_SUBSCRIBER_BANK}
    end
end




function LibMarify:IsDebug()
    if self.isSilent then
        return false
    end
    return self.savedVariables and self.savedVariables.isDebug
end




function LibMarify:Message(msg, color)
    if self.isSilent then
        return
    end
    if self.savedVariables and self.savedVariables.isLog == false then
        return
    end
    if color then
        d("|c88aaff" .. self.name .. ":|r |c" .. color .. msg .. "|r")
    else
        d("|c88aaff" .. self.name .. ":|r |cffffff" .. msg .. "|r")
    end
    if self.savedVariables.isDebug then
        local log = self.name .. tostring(msg):gsub("　", "  "):gsub("|c5c5c5c", ""):gsub("|cffff66", ""):gsub("|r", "")
        if self.savedVariables.debugLog == nil then
            self.savedVariables.debugLog = {}
        end
        table.insert(self.savedVariables.debugLog, log)
    end
end




function LibMarify:NextEmptySlot(bagId, slotIndex)

    if slotIndex then
        slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        while slotIndex and GetItemId(bagId, slotIndex) ~= 0 do
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end

    if slotIndex == nil then
        slotIndex = FindFirstEmptySlotInBag(bagId)
    end
    return slotIndex
end




function LibMarify:PostHook(objectTable, existingFunctionName, hookFunction)

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

