local EsoKR = {}
EsoKR.name = "EsoKR"
EsoKR.Flags = { "en", "kr", "kb", "tr" }
EsoKR.firstInit = true
EsoKR.chat = { changed = true, privCursorPos = 0, editing = false }

local function setLanguage(lang)
    zo_callLater(function()
        SetCVar("language.2", lang)
        EsoKR.savedVars.lang = lang
        ReloadUI()
    end, 500)
end

local function getLanguage()
    return GetCVar("language.2")
end

local function chsize(char)
    if not char then return 0
    elseif char > 240 then return 4
    elseif char > 225 then return 3
    elseif char > 192 then return 2
    else return 1
    end
end

local function utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end



local function con2CNKR(text)
    local temp = ""
    local scanleft = 0
    local result = ""
    local num = 0
    local hashan = false;
    for i in string.gmatch(text, ".") do
        --[[if(num >= 39) and hashan then
            temp = ""
            scanleft = 0
            result = utf8sub(result, 1, 40)
        else]]--
        local r = ""
        byte = string.byte(i)
        hex = string.format('%02X', byte)
        if scanleft > 0 then
            temp = temp .. hex
            scanleft = scanleft - 1
            if scanleft == 0 then
                temp = tonumber(temp, 16)
                if temp >= 0xE18480 and temp <= 0xE187BF then
                    temp = temp + 0x43400
                elseif temp > 0xe384b0 and temp <= 0xe384bf then
                    temp = temp + 0x237d0
                elseif temp > 0xe38580 and temp <= 0xe3868f then
                    temp = temp + 0x23710
                elseif temp >= 0xeab080 and temp <= 0xed9eac then
                    if temp >= 0xeab880 and temp <= 0xeabfbf then
                        temp = temp - 0x33800
                    elseif temp >= 0xebb880 and temp <= 0xebbfbf then
                        temp = temp - 0x33800
                    elseif temp >= 0xECB880 and temp <= 0xECBFBF then
                        temp = temp - 0x33800
                    else
                        temp = temp - 0x3f800
                    end
                end
                temp = string.format('%02X', temp)
                r = (temp:gsub('..', function (cc) return string.char(tonumber(cc, 16)) end))
                temp = ""
                hashan = true
                num = num + 1
            end
        else
            if byte > 224 and byte <= 239 then
                -- 3 bytes
                scanleft = 2
                temp = hex
            else
                r = i
                num = num + 1
            end
        end
        result = result .. r
        --end
    end
    return result
end

local function utfstrlen(str, targetlen)
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
        local tmp=string.byte(str,-left);
        local i=#arr;
        while arr[i] do
            if tmp>=arr[i] then left=left-i;break;end
            i=i-1;
        end
        cnt=cnt+1;
    end
    return cnt;
end

local function RefreshUI()
    local flagControl
    local count = 0
    local flagTexture
    for _, flagCode in pairs(EsoKR.Flags) do
        flagTexture = "EsoKR/flags/"..flagCode..".dds"
        flagControl = GetControl("EsoKR_FlagControl_"..tostring(flagCode))
        if flagControl == nil then
            flagControl = CreateControlFromVirtual("EsoKR_FlagControl_", EsoKRUI, "EsoKR_FlagControl", tostring(flagCode))
            GetControl("EsoKR_FlagControl_"..flagCode.."Texture"):SetTexture(flagTexture)
            if getLanguage() ~= flagCode then
                flagControl:SetAlpha(0.3)
                if flagControl:GetHandler("OnMouseDown") == nil then
                    flagControl:SetHandler("OnMouseDown", function() setLanguage(flagCode) end)
                end
            end
        end
        flagControl:ClearAnchors()
        flagControl:SetAnchor(LEFT, EsoKRUI, LEFT, 14 +count*34, 0)
        count = count + 1
    end
    EsoKRUI:SetDimensions(25 +count*34, 50)
    EsoKRUI:SetMouseEnabled(true)
end

local function init(eventCode, addOnName)
    if (addOnName):find("^ZO_") then return end

    local defaultVars = { lang = "kr" }
    EsoKR.savedVars = ZO_SavedVars:NewAccountWide("EsoKR_Variables", 1, nil, defaultVars)

    for _, flagCode in pairs(EsoKR.Flags) do
        ZO_CreateStringId("SI_BINDING_NAME_"..string.upper(flagCode), string.upper(flagCode))
    end

    ZO_TOOLTIP_STYLES["tooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["bodySection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["bodyHeader"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["itemTagsSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["itemTradeBoPSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["attributeBody"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["bagCountSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["stableGamepadTooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["abilityHeaderSection"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["worldMapTooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["mapTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["mapQuestTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["mapLocationTooltipContentHeader"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["mapLocationTooltipWayshrineHeader"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["mapKeepUnderAttack"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["cadwellObjectiveTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["lootTooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["socialTitle"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["collectionsInfoSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["instantUnlockIneligibilitySection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["voiceChatBodyHeader"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_TOOLTIP_STYLES["groupDescription"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["attributeTitleSection"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["itemComparisonStatValuePairValue"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["defaultAccessTopSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["defaultAccessBody"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["currencyLocationTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_TOOLTIP_STYLES["currencyStatValuePairStat"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_TOOLTIP_STYLES["currencyStatValuePairValue"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["tooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["bodySection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["bodyHeader"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["itemTagsSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["itemTradeBoPSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["attributeBody"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["bagCountSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["stableGamepadTooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["abilityHeaderSection"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["worldMapTooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["mapTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["mapQuestTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["mapLocationTooltipContentHeader"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["mapLocationTooltipWayshrineHeader"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["mapKeepUnderAttack"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["cadwellObjectiveTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["lootTooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["socialTitle"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["collectionsInfoSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["instantUnlockIneligibilitySection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["voiceChatBodyHeader"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["groupDescription"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["attributeTitleSection"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["itemComparisonStatValuePairValue"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["defaultAccessTopSection"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["defaultAccessBody"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["currencyLocationTitle"]["fontFace"] = "EsoKR/fonts/ftn87.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["currencyStatValuePairStat"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_CRAFTING_TOOLTIP_STYLES["currencyStatValuePairValue"]["fontFace"] = "EsoKR/fonts/ftn47.otf"
    ZO_GAMEPAD_DYEING_TOOLTIP_STYLES["tooltip"]["fontFace"] = "EsoKR/fonts/ftn57.otf"
    ZO_GAMEPAD_DYEING_TOOLTIP_STYLES["body"]["fontFace"] = "EsoKR/fonts/ftn57.otf"

    SetSCTKeyboardFont("EsoKR/fonts/univers67.otf|29|soft-shadow-thick")
    SetSCTGamepadFont("EsoKR/fonts/univers67.otf|35|soft-shadow-thick")
    SetNameplateKeyboardFont("EsoKR/fonts/univers67.otf", 4)
    SetNameplateGamepadFont("EsoKR/fonts/univers67.otf", 4)

    if LibStub then
        local LMP = LibStub("LibMediaProvider-1.0", true)
        if LMP then
            LMP.MediaTable.font["Univers 67"] = nil 
            LMP.MediaTable.font["Univers 57"] = nil
            LMP.MediaTable.font["Skyrim Handwritten"] = nil
            LMP.MediaTable.font["ProseAntique"] = nil
            LMP.MediaTable.font["Trajan Pro"] = nil
            LMP.MediaTable.font["Futura Condensed"] = nil
            LMP.MediaTable.font["Futura Condensed Bold"] = nil
            LMP.MediaTable.font["Futura Condensed Light"] = nil
            LMP:Register("font", "Univers 67", "EsoKR/fonts/univers67.otf")
            LMP:Register("font", "Univers 57", "EsoKR/fonts/univers57.otf")
            LMP:Register("font", "Skyrim Handwritten", "EsoKR/fonts/handwritten_bold.otf")
            LMP:Register("font", "ProseAntique", "EsoKR/fonts/proseantiquepsmt.otf")
            LMP:Register("font", "Trajan Pro", "EsoKR/fonts/trajanpro-regular.otf")
            LMP:Register("font", "Futura Condensed", "EsoKR/fonts/ftn57.otf")
            LMP:Register("font", "Futura Condensed Bold", "EsoKR/fonts/ftn87.otf")
            LMP:Register("font", "Futura Condensed Light", "EsoKR/fonts/ftn47.otf")
            LMP:SetDefault("font", "Univers 57")
        end
    end

	if LWF3 then
		LWF3.data.Fonts = {
            ["Arial Narrow"] = "EsoKR/fonts/univers57.otf",
            ["Consolas"] = "EsoKR/fonts/univers57.otf",
            ["ESO Cartographer"] = "EsoKR/fonts/univers57.otf",
            ["Fontin Bold"] = "EsoKR/fonts/univers57.otf",
            ["Fontin Italic"] = "EsoKR/fonts/univers57.otf",
            ["Fontin Regular"] = "EsoKR/fonts/univers57.otf",
            ["Fontin SmallCaps"] = "EsoKR/fonts/univers57.otf",
            ["Futura Condensed"]= "EsoKR/fonts/univers57.otf",
            ["Futura Light"] = "EsoKR/fonts/ftn47.otf",
            ["ProseAntique"] = "EsoKR/fonts/proseantiquepsmt.otf",
            ["Skyrim Handwritten"]= "EsoKR/fonts/handwritten_bold.otf",
            ["Trajan Pro"] = "EsoKR/fonts/trajanpro-regular.otf",
            ["Univers 55"] = "EsoKR/fonts/univers57.otf",
            ["Univers 57"] = "EsoKR/fonts/univers57.otf",
            ["Univers 67"] = "EsoKR/fonts/univers67.otf",
		}
	end
	
	if LWF4 then
		LWF4.data.Fonts = {
            ["Arial Narrow"] = "EsoKR/fonts/univers57.otf",
            ["Consolas"] = "EsoKR/fonts/univers57.otf",
            ["ESO Cartographer"] = "EsoKR/fonts/univers57.otf",
            ["Fontin Bold"] = "EsoKR/fonts/univers57.otf",
            ["Fontin Italic"] = "EsoKR/fonts/univers57.otf",
            ["Fontin Regular"] = "EsoKR/fonts/univers57.otf",
            ["Fontin SmallCaps"] = "EsoKR/fonts/univers57.otf",
            ["Futura Condensed"]= "EsoKR/fonts/ftn57.otf",
            ["Futura Light"] = "EsoKR/fonts/ftn47.otf",
            ["ProseAntique"] = "EsoKR/fonts/proseantiquepsmt.otf",
            ["Skyrim Handwritten"]= "EsoKR/fonts/handwritten_bold.otf",
            ["Trajan Pro"] = "EsoKR/fonts/trajanpro-regular.otf",
            ["Univers 55"] = "EsoKR/fonts/univers57.otf",
            ["Univers 57"] = "EsoKR/fonts/univers57.otf",
            ["Univers 67"] = "EsoKR/fonts/univers67.otf",
		}
	end

    function ZO_TooltipStyledObject:GetFontString(...)
        local fontFace = self:GetProperty("fontFace", ...)
        local fontSize = self:GetProperty("fontSize", ...)
        local fontStyle = self:GetProperty("fontStyle", ...)

        if fontFace == "$(GAMEPAD_LIGHT_FONT)" then
            fontFace = "EsoKR/fonts/ftn47.otf"
        end
        if fontFace == "$(GAMEPAD_MEDIUM_FONT)" then
            fontFace = "EsoKR/fonts/ftn57.otf"
        end
        if fontFace == "$(GAMEPAD_BOLD_FONT)" then
            fontFace = "EsoKR/fonts/ftn87.otf"
        end

        if(fontFace and fontSize) then
            if type(fontSize) == "number" then
                fontSize = tostring(fontSize)
            end
            if(fontStyle) then
                return string.format("%s|%s|%s", fontFace, fontSize, fontStyle)
            else
                return string.format("%s|%s", fontFace, fontSize)
            end
        else
            return "ZoFontGame"
        end
    end

    RefreshUI()

    function ZO_GameMenu_OnShow(control)
        if control.OnShow then
            control.OnShow(control.gameMenu)
            EsoKRUI:SetHidden(hidden)
        end
    end
    
    function ZO_GameMenu_OnHide(control)
        if control.OnHide then
            control.OnHide(control.gameMenu)
            EsoKRUI:SetHidden(not hidden)
        end
    end

    ZO_PreHook("ZO_ChatTextEntry_Execute", function(control)
        control.system:CloseTextEntry(true)
    end)

    ZO_PreHook("ZO_ChatTextEntry_Escape", function(control)
        control.system:CloseTextEntry(true)
    end)

    ZO_PreHook("ZO_ChatTextEntry_TextChanged", function(control, newText)
        if EsoKR.chat.editing then return end
        local cursorPos = control.system.textEntry:GetCursorPosition()
        if cursorPos ~= EsoKR.chat.privCursorPos and cursorPos ~= 0 then
            EsoKR.chat.editing = true
            local text = control.system.textEntry:GetText()
            text = con2CNKR(text)
            control.system.textEntry:SetText(text)
            if(cursorPos < utfstrlen(text)) then
                control.system.textEntry:SetCursorPosition(cursorPos)
            end
            EsoKR.chat.editing = false
        end
        EsoKR.chat.privCursorPos = cursorPos
    end)
end

local function loadScreen(event)
    SetSCTKeyboardFont("EsoKR/fonts/univers67.otf|29|soft-shadow-thick")
    SetSCTGamepadFont("EsoKR/fonts/univers67.otf|35|soft-shadow-thick")
    SetNameplateKeyboardFont("EsoKR/fonts/univers67.otf", 4)
    SetNameplateGamepadFont("EsoKR/fonts/univers67.otf", 4)
    
    if EsoKR.firstInit then
        EsoKR.firstInit = false
        if getLanguage() ~= "kr" and EsoKR.savedVars.lang == "kr" then
            setLanguage("kr")
        end
    end
end


local function closeMessageBox()
    ZO_Dialogs_ReleaseDialog("EsoKR:MessageBox", false)
end

local function showMessageBox(title, msg, btnText, callback)
    local confirmDialog =
    {
        title = { text = title },
        mainText = { text = msg },
        buttons =
        {
            {
                text = btnText,
                callback = callback
            }
        }
    }

    ZO_Dialogs_RegisterCustomDialog("EsoKR:MessageBox", confirmDialog)
    closeMessageBox()
    ZO_Dialogs_ShowDialog("EsoKR:MessageBox")
end

local function onAddonLoaded(eventCode, addOnName)
    init(eventCode, addOnName)
    if(addOnName ~= EsoKR.name) then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(EsoKR.name, EVENT_ADD_ON_LOADED)
    showMessageBox("its Title", "Hello!", SI_DIALOG_CONFIRM)
end

EVENT_MANAGER:RegisterForEvent(EsoKR.name, EVENT_ADD_ON_LOADED, onAddonLoaded)
EVENT_MANAGER:RegisterForEvent("EsoKR_LoadScreen", EVENT_PLAYER_ACTIVATED, loadScreen)