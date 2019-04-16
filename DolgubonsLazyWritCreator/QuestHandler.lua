-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: QuestHandler.lua
-- File Description: Handles automatic acceptance and completion of quests
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------


WritCreater = WritCreater or {}
local completionStrings


-- Handles the dialogue where we actually complete the quest
local function HandleQuestCompleteDialog(eventCode, journalIndex)
	local writs = WritCreater.writSearch()
	if not GetJournalQuestIsComplete(journalIndex) then return end
	local currentWritDialogue 
	for i = 1, 7 do
		if writs[i] == journalIndex then -- determine which type of writ it is
			
			currentWritDialogue= i
		end
	end
	--d(writs[currentWritDialogue])
	--d(journalIndex)
	if zo_plainstrfind( ZO_InteractWindowTargetAreaTitle:GetText() ,completionStrings["Rolis Hlaalu"]) then
		--d("complete")
		CompleteQuest()
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG)
		WritCreater.analytic()
		return 
	end
	EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG)
	if not currentWritDialogue then return end
	
	-- Increment the number of writs complete number
	WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] = WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] + 1
	WritCreater.savedVarsAccountWide["total"] = WritCreater.savedVarsAccountWide["total"] + 1
    -- Complete the writ quest
    if not WritCreater:GetSettings().autoAccept then return end
	CompleteQuest()
	WritCreater.analytic()

end

local wasQuestAccepted

-- Handles the dialogue where we actually accept the quest
local function HandleEventQuestOffered(eventCode)
    -- Stop listening for quest offering
    EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED)
    -- Accept the writ quest
    wasQuestAccepted = true
    AcceptOfferedQuest()
end

-- Checks if we should deal with this type of quest or not
local function isQuestTypeActive(optionString)
	optionString = string.gsub(optionString, "couture","tailleur")

	for i = 1, 7 do
		if string.find(string.lower(optionString), string.lower(WritCreater.writNames[i])) and (WritCreater:GetSettings()[i] or WritCreater:GetSettings()[i]==nil) then 
			return true
		
		end
	end

	return false
end

-- Automatically accepts master writs. Off by default but it's written so not deleting it just in case
local function handleMasterWritQuestOffered()

	local a = {GetOfferedQuestInfo()}
	-- If it is a Master Writ offering
    if string.find(a[1], completionStrings["Rolis Hlaalu"]) and a[2] == completionStrings.masterStart and not WritCreater:GetSettings().preventMasterWritAccept then

		--d("Accept")
    	AcceptOfferedQuest()
	end
end

--EVENT_MANAGER:RegisterForEvent("DolgubonsLazyWritCreatorMasterWrit", EVENT_QUEST_OFFERED, handleMasterWritQuestOffered)
-- Handles dialogue start. It will fire on any NPC dialogue, so we need to filter out a bit
local function HandleChatterBegin(eventCode, optionCount)

	
    -- Ignore interactions with no options
    if optionCount == 0 then return end

    for i = 1, optionCount do
	    -- Get details of first option

	    local optionString, optionType = GetChatterOption(i)

	    -- If it is a writ quest option...
	    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL 
	       and string.find(string.lower(optionString), string.lower(WritCreater.writNames["G"])) ~= nil 
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	    	if isQuestTypeActive(optionString) then
				-- Listen for the quest offering
				EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
				-- Select the first writ
				SelectChatterOption(i)
				return
			else
				if i == optionCount and wasQuestAccepted then
					EndInteraction( INTERACTION_CONVERSATION)
					wasQuestAccepted = nil
				end
			end
			
	    -- If it is a writ quest completion option
	    elseif optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
	       and string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil  
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to complete the quest
	        SelectChatterOption(1)
	    
	    -- If the goods were already placed, then complete the quest
	    elseif optionType == CHATTER_START_COMPLETE_QUEST
	       and (string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil 
	            or string.find(string.lower(optionString), string.lower(completionStrings.sign)) ~= nil)
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to place goods and/or sign the manifest
	        SelectChatterOption(1)
	        -- Talking to the master writ person?
	    elseif zo_plainstrfind( ZO_InteractWindowTargetAreaTitle:GetText() ,completionStrings["Rolis Hlaalu"]) then 
	    	if not WritCreater:GetSettings().autoAccept then return end
	    	--d(optionType)
	    	--d(optionString)
		    if optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
		       and string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil  
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to complete the quest
		        --d("Chat")
		        SelectChatterOption(1)
		        -- If the goods were already placed, then complete the quest
		    elseif optionType == CHATTER_START_COMPLETE_QUEST
		       and (string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil 
		            or string.find(string.lower(optionString), string.lower(completionStrings.masterSign)) ~= nil)
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to place goods and/or sign the manifest
		        --d("Chat2")
		        SelectChatterOption(1)
		    end
		elseif optionType == CHATTER_START_BANK then
			if WritCreater:GetSettings().autoCloseBank then
				WritCreater.alchGrab()
			end
	    end
	end
end

-- All the abilityIDs for pets that should not be near writ containers. Grrr
local petIds = { 
[23304]=true, [30631]=true, [30636]=true, [30641]=true, [23319]=true, [30647]=true, 
[30652]=true, [30657]=true, [23316]=true, [30664]=true, [30669]=true, [30674]=true , 
[24613]=true, [30581]=true, [30584]=true, [30587]=true, [24636]=true, [30592]=true, 
[30595]=true, [30598]=true, [24639]=true, [30618]=true, [30622]=true, [30626]=true, 
[85982]=true, [85983]=true, [85984]=true, [85985]=true, [85986]=true, [85987]=true, 
[85988]=true, [85989]=true, [85990]=true, [85991]=true, [85992]=true, [85993]=true, }

local function DismissPets()

	-- Walk through the player's active buffs
	for i = 1, GetNumBuffs("player") do
		local _, _, _, buffSlot, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("player", i)
		-- Compare each buff's abilityID to the list of IDs we were given
		if petIds[abilityId] then
			-- Cancel the buff if we got a match
			CancelBuff(buffSlot)
		end
	end
end

WritCreater.DismissPets = DismissPets

local watchedZones = 
{--	[zoneIndex] = {zoneId, x, y, distance}
	[645] =  {1011 , 0.22504281997681, 0.70089447498322, 0.03}, -- summerset
	[496]= {849 , 0.25478214025497,  0.55092114210129, 0.035 }, -- vivec
	[179]= {382 ,0.3137067258358,  0.39710983633995, 0.04}, -- Rawlkha
	[16]= {103 , 0.65962821245193, 0.59825921058655 , 0.045}, -- Riften
	[154] = {347 , 0.26477551460266,  0.57783675193787, 0.04 }, -- coldharbour
	[5] = {20 ,0.85589545965195, 0.60531121492386, 0.05 }, -- Shornhelm 
	[10] = {57 ,0.73952090740204, 0.75583720207214, 0.03 }, -- Mournhold
}
local function calculateDistance()
	
	local zoneIndex = GetUnitZoneIndex("player")
	if not watchedZones[zoneIndex] then
		return
	end
	local zoneId = GetZoneId(zoneIndex)
	if not watchedZones[zoneIndex][1] == zoneId then
		return
	end
	if not watchedZones[zoneIndex][2] then return end
	-- Pretty sure that means we're in the right zone so let's calculate!
	local x, y = GetMapPlayerPosition("player")
	x = watchedZones[zoneIndex][2] - x
	y = watchedZones[zoneIndex][3] - y
	local dist = math.sqrt(x*x + y*y)
	local _, hasWrit = WritCreater.writSearch()
	if not hasWrit then
		dist = dist + 0.016
	end
	if dist<(watchedZones[zoneIndex][4] or 0) then
		DismissPets()
	end
	return dist
end

-- Initialize the event listener, and grab the language strings
function WritCreater.InitializeQuestHandling()
	EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."Pe(s)tControl", 400, calculateDistance)
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CHATTER_BEGIN, HandleChatterBegin)
	completionStrings = WritCreater.writCompleteStrings()
	local original = AcceptOfferedQuest
	AcceptOfferedQuest = function()
	if string.find(GetOfferedQuestInfo(), completionStrings["Rolis Hlaalu"]) and WritCreater:GetSettings().preventMasterWritAccept then 
		d(WritCreater.strings.masterWritSave)  else original() end end
end

-- /script JumpToSpecificHouse("@marcopolo184", 46)