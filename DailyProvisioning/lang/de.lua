------------------------------------------------
-- German localization for DailyProvisioning
------------------------------------------------

ZO_CreateStringId("DP_CRAFTING_QUEST",      "Versorgerschrieb")
ZO_CreateStringId("DP_CRAFTING_MASTER",     "Ein meisterhaftes Mahl")

ZO_CreateStringId("DP_BULK_HEADER",         "Massenerstellung")
ZO_CreateStringId("DP_BULK_FLG",            "Créer de nombreux médicaments et poisons")
ZO_CreateStringId("DP_BULK_FLG_TOOLTIP",    "Es wird verwendet, wenn Sie eine große Anzahl angeforderter Elemente erstellen möchten.")
ZO_CreateStringId("DP_BULK_COUNT",          "Zu erstellende Menge")
ZO_CreateStringId("DP_BULK_COUNT_TOOLTIP",  "In der Tat wird es mehr als diese Menge erstellt werden.(Hängt von Kochkunst/Braukunst-Fähigkeiten ab)")

ZO_CreateStringId("DP_CRAFT_WRIT",          "Craft Versiegelter Meisterschrieb")
ZO_CreateStringId("DP_CRAFT_WRIT_MSG",      "Beim Zugriff auf den Feuerstelle, <<1>>")
ZO_CreateStringId("DP_CANCEL_WRIT",         "Versiegelter Meisterschrieb abbrechen")
ZO_CreateStringId("DP_CANCEL_WRIT_MSG",     "Stornierte Versiegelter Meisterschrieb")

ZO_CreateStringId("DP_OTHER_HEADER",        "Andere")
ZO_CreateStringId("DP_ACQUIRE_ITEM",        "Gegenstände von der Bank abholen")
ZO_CreateStringId("DP_AUTO_EXIT",           "Automatischer Austritt aus dem Crafting-Fenster")
ZO_CreateStringId("DP_AUTO_EXIT_TOOLTIP",   "Automatischer Austritt aus dem Crafting-Fenster, wenn alles abgeschlossen ist.")
ZO_CreateStringId("DP_DONT_KNOW",           "Deaktivieren Autocrafting,wenn Rezept nicht kennen")
ZO_CreateStringId("DP_DONT_KNOW_TOOLTIP",   "Wir kochen zwei Rezepte auf eine tägliche Anfrage, aber wenn Sie kein Rezept kennen, wird es nicht automatisch erstellt.")
ZO_CreateStringId("DP_LOG",                 "Protokoll anzeigen")
ZO_CreateStringId("DP_DEBUG_LOG",           "Debug-Protokoll anzeigen")

ZO_CreateStringId("DP_UNKNOWN_RECIPE",      " Rezept [<<1>>] ist unbekannt. Der Artikel wurde nicht erstellt.")
ZO_CreateStringId("DP_MISMATCH_RECIPE",     " ... [Fehler]Rezeptname stimmt nicht überein (<<1>>)")
ZO_CreateStringId("DP_NOTHING_RECIPE",      " ... Keinen Rezept haben")
ZO_CreateStringId("DP_SHORT_OF",            " ... Mangel an Materialien (<<1>>)")




function DailyProvisioning:CraftingConditions()
    local list = {
        "Stellt",
    }
    return list
end

function DailyProvisioning:ConvertedItemNameForDisplay(itemName)
    return itemName:gsub("(\^).*", ""):gsub("(\|).*", "")
end

function DailyProvisioning:ConvertedItemNames(itemName)

    local function Convert(itemName)

        local list = {
            {"(\-)",            "(\-)"},
            {"atherischer Tee", "Ätherischen Tee"},
            {"%l%l ",           "%%l* "},
            {"ﻻ",               " "}, -- A piece of BOM ? (239)
        }

        local convertedItemName = itemName
        for _, value in ipairs(list) do
            convertedItemName = string.gsub(convertedItemName, value[1], value[2])
        end
        return convertedItemName
    end


    if string.match(itemName, "(\|)") then
        local itemName1 = itemName:gsub("(\|)[%a%s%p]*", ""):gsub("(\^)%a*", ""):gsub("ä", "a"):gsub("ö", "o"):gsub("ü", "u")
        local itemName2 = itemName:gsub("[%a%s%p]*(\|)", ""):gsub("(\^)%a*", ""):gsub("ä", "a"):gsub("ö", "o"):gsub("ü", "u")
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
        itemName = itemName:gsub("(\^)%a*", ""):gsub("(\^)%a*", ""):gsub("ä", "a"):gsub("ö", "o"):gsub("ü", "u")
        local convertedItemName = Convert(itemName)
        if convertedItemName == itemName then
            return {
                itemName
            }
        else
            return {
                Convert(itemName),
                itemName,
            }
        end
    end
end

function DailyProvisioning:ConvertedJournalCondition(journalCondition)
    return journalCondition:gsub("ä", "a"):gsub("ö", "o"):gsub("ü", "u") -- Replace Umlaut
end

function DailyProvisioning:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n(.*)", "%1")
end

