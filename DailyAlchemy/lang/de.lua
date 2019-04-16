------------------------------------------------     
-- German localization for DailyAlchemy
------------------------------------------------

ZO_CreateStringId("DA_CRAFTING_QUEST",      "Alchemistenschrieb")
ZO_CreateStringId("DA_CRAFTING_MASTER",     "Ein meisterhaftes Gebräu")

ZO_CreateStringId("DA_BULK_HEADER",         "Massenerstellung")
ZO_CreateStringId("DA_BULK_FLG",            "Créer de nombreux médicaments et poisons")
ZO_CreateStringId("DA_BULK_FLG_TOOLTIP",    "Es wird verwendet, wenn Sie eine große Anzahl angeforderter Elemente erstellen möchten.")
ZO_CreateStringId("DA_BULK_COUNT",          "Zu erstellende Menge")
ZO_CreateStringId("DA_BULK_COUNT_TOOLTIP",  "In der Tat wird es mehr als diese Menge erstellt werden.(Hängt von Alchemie-Fähigkeiten ab)")

ZO_CreateStringId("DA_CRAFT_WRIT",          "Craft Versiegelter Meisterschrieb")
ZO_CreateStringId("DA_CRAFT_WRIT_MSG",      "Beim Zugriff auf die Alchemietisch, <<1>>")
ZO_CreateStringId("DA_CANCEL_WRIT",         "Versiegelter Meisterschrieb abbrechen")
ZO_CreateStringId("DA_CANCEL_WRIT_MSG",     "Stornierte Versiegelter Meisterschrieb")

ZO_CreateStringId("DA_PRIORITY_HEADER",     "Priorität des Reagenzien")
ZO_CreateStringId("DA_PRIORITY_BY",         "Priorität des zu verwendenden Reagenzes")
ZO_CreateStringId("DA_PRIORITY_BY_STOCK",   "Viel Vorrat")
ZO_CreateStringId("DA_PRIORITY_BY_MM",      "Niedrigpreis-Reagenz bei [MasterMerchant]")
ZO_CreateStringId("DA_PRIORITY_BY_TTC",     "Niedrigpreis-Reagenz bei [TamrielTradeCentre]")
ZO_CreateStringId("DA_PRIORITY_BY_ATT",     "Niedrigpreis-Reagenz bei [ArkadiusTradeTools]")
ZO_CreateStringId("DA_PRIORITY_BY_MANUAL",  "Manuell einstellen")
ZO_CreateStringId("DA_SHOW_PRICE_MANUAL",   "Preis anzeigen[<<1>>]")
ZO_CreateStringId("DA_PRIORITY_CHANGED",    "Die Add-on-Einstellung [<<1>>] wurde geändert, weil <<2>> deaktiviert ist")

ZO_CreateStringId("DA_OTHER_HEADER",        "Andere")
ZO_CreateStringId("DA_ACQUIRE_ITEM",        "Gegenstände von der Bank abholen")
ZO_CreateStringId("DA_AUTO_EXIT",           "Automatischer Austritt aus dem Crafting-Fenster")
ZO_CreateStringId("DA_AUTO_EXIT_TOOLTIP",   "Automatischer Austritt aus dem Crafting-Fenster, wenn alles abgeschlossen ist.")
ZO_CreateStringId("DA_ITEM_LOCK",           "Verwenden Sie keine gesperrten Elemente")
ZO_CreateStringId("DA_LOG",                 "Protokoll anzeigen")
ZO_CreateStringId("DA_DEBUG_LOG",           "Debug-Protokoll anzeigen")

ZO_CreateStringId("DA_NOTHING_ITEM",        "Keine Gegenstände im Rucksack (<<1>>)")
ZO_CreateStringId("DA_SHORT_OF",            "... Mangel an Materialien(<<1>>)")
ZO_CreateStringId("DA_MISMATCH_ITEM",       "... [Fehler]Name des Artikels (<<1>>)")

ZO_CreateStringId("DA_DETECTION",           "Detektion")                    -- 1:Detection
ZO_CreateStringId("DA_ARMOR",               "Erhöht Rüstung")               -- 2:Increase Armor
ZO_CreateStringId("DA_SPELL_POWER",         "Erhöht Magiekraft")            -- 3:Increase Spell Power
ZO_CreateStringId("DA_SPELL_RESIST",        "Erhöht Magieresistenz")        -- 4:Increase Spell Resist
ZO_CreateStringId("DA_WEAPON_POWER",        "Erhöht Waffenkraft")           -- 5:Increase Weapon Power
ZO_CreateStringId("DA_INVISIBLE",           "Unsichtbarkeit")               -- 6:Invisible
ZO_CreateStringId("DA_FRACTURE",            "Fraktur")                      -- 7:Fracture
ZO_CreateStringId("DA_UNCERTAINTY",         "Ungewissheit")                 -- 8:Uncertainty
ZO_CreateStringId("DA_COWARDICE",           "Feigheit")                     -- 9:Cowardice
ZO_CreateStringId("DA_BREACH",              "Bruch")                        -- 10:Breach
ZO_CreateStringId("DA_ENERVATE",            "Schwäche")                     -- 11:Enervation
ZO_CreateStringId("DA_MAIM",                "Verkrüppeln")                  -- 12:Maim
ZO_CreateStringId("DA_RVG_HEALTH",          "Lebensverwüstung")             -- 13:Ravage Health
ZO_CreateStringId("DA_RVG_MAGICKA",         "Magickaverwüstung")            -- 14:Ravage Magicka
ZO_CreateStringId("DA_RVG_STAMINA",         "Ausdauerverwüstung")           -- 15:Ravage Stamina
ZO_CreateStringId("DA_HINDRANCE",           "Einschränken")                 -- 16:Hindrance
ZO_CreateStringId("DA_HEALTH",              "Leben wiederherstellen")       -- 17:Restore Health
ZO_CreateStringId("DA_MAGICKA",             "Magicka wiederherstellen")     -- 18:Restore Magicka
ZO_CreateStringId("DA_STAMINA",             "Ausdauer wiederherstellen")    -- 19:Restore Stamina
ZO_CreateStringId("DA_SPEED",               "Tempo")                        -- 20:Speed
ZO_CreateStringId("DA_SPELL_CRIT",          "Kritische Magietreffer")       -- 21:Spell Critical
ZO_CreateStringId("DA_ENTRAPMENT",          "Einfangen")                    -- 22:Entrapment
ZO_CreateStringId("DA_UNSTOP",              "Sicherer Stand")               -- 23:Unstoppable
ZO_CreateStringId("DA_WEAPON_CRIT",         "Kritische Waffentreffer")      -- 24:Weapon Critical
ZO_CreateStringId("DA_VULNERABILITY",       "Verwundbarkeit")               -- 25:Vulnerability
ZO_CreateStringId("DA_DEFILE",              "Schänden")                     -- 26:Defile
ZO_CreateStringId("DA_GR_RVG_HEALTH",       "Langsame Lebensverwüstung")    -- 27:Gradual Ravage Health
ZO_CreateStringId("DA_LGR_HEALTH",          "Beständige Heilung")           -- 28:Lingering Health
ZO_CreateStringId("DA_VITALITY",            "Vitalität")                    -- 29:Vitality
ZO_CreateStringId("DA_PROTECTION",          "Schutz")                       -- 30:Protection




function DailyAlchemy:AcquireConditions()
    local list = {
        "Beschafft%s(.*)",
        "Besorgt%s%a*%s(.*)",
    }
    return list
end

function DailyAlchemy:ConvertedItemNames(itemName)

    local function Convert(itemName)
        local list = {
            {"ä",           "a"},
            {"ö",           "o"},
            {"ü",           "u"},
            {"(\-)",        "(\-)"},
            {" ",           " "},   -- NO-BREAK SPACE(U+00A0) to SPACE (U+0020)
            {"(%a%a)%l%l ", "%1%%l* "},
            {" IX$",        " Ⅸ"},
            {" VIII$",      " Ⅷ"},
            {" VII$",       " Ⅶ"},
            {" VI$",        " Ⅵ"},
            {" IV$",        " Ⅳ"},
            {" V$",         " Ⅴ"},
            {" III$",       " Ⅲ"},
            {" II$",        " Ⅱ"},
            {" I$",         " Ⅰ"},
        }

        local convertedItemName = itemName
        for _, value in ipairs(list) do
            convertedItemName = string.gsub(convertedItemName, value[1], value[2])
        end
        return convertedItemName
    end


    if string.match(itemName, "(\|)") then
        local itemName1 = itemName:gsub("(\|)[%a%s%p]*", "")
        local itemName2 = itemName:gsub("[%a%s%p]*(\|)", "")
        local list = {}

        local convertedItemName1 = Convert(itemName1)
        if convertedItemName1 == itemName1 then
            list[#list + 1] = itemName1
        else
            list[#list + 1] = convertedItemName1
            list[#list + 1] = itemName1
        end

        local convertedItemName2 = Convert(itemName2)
        if convertedItemName2 == itemName2 then
            list[#list + 1] = itemName2
        else
            list[#list + 1] = convertedItemName2
            list[#list + 1] = itemName2
        end

        return list
    else
        itemName = itemName:gsub("(\^)%a*", ""):gsub("(\^)%a*", "")
        local convertedItemName = Convert(itemName)
        if convertedItemName == itemName then
            return {
                itemName,
            }
        else
            return {
                Convert(itemName),
                itemName,
            }
        end
    end
end

function DailyAlchemy:ConvertedJournalCondition(journalCondition)
    local list = {
        {"ä",       "a"},
        {"ö",       "o"},
        {"ü",       "u"},
        {" ",       " "}, -- NO-BREAK SPACE(U+00A0) to SPACE (U+0020)
        {" IX ",    " Ⅸ "},
        {" VIII ",  " Ⅷ "},
        {" VII ",   " Ⅶ "},
        {" VI ",    " Ⅵ "},
        {" IV ",    " Ⅳ "},
        {" V ",     " Ⅴ "},
        {" III ",   " Ⅲ "},
        {" II ",    " Ⅱ "},
        {" I",      " Ⅰ "},

        {"(Stellt.*)mit.*her.*%c• (.*)%c• (.*)%c• (.*)%c• .*",  "%1...%2, %3, %4"},
        {".*(Stellt.*)mit.*her.*%c(.*)%c(.*)%c(.*)",            "%1...%2, %3, %4"},
        {":.*",                                                 ""}, 
    }

    local convertedCondition = journalCondition
    for _, value in ipairs(list) do
        convertedCondition = string.gsub(convertedCondition, value[1], value[2])
    end
    return convertedCondition
end

function DailyAlchemy:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n(.*) mit.*\n(.*)\n(.*)\n(.*)", "%1 [%2, %3, %4]")
end

function DailyAlchemy:CraftingConditions()
    local list = {
        "Stellt",
    }
    return list
end

function DailyAlchemy:isPoison(conditionText)
    return string.match(conditionText, "Gift de")
end

