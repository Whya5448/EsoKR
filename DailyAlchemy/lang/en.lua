------------------------------------------------
-- English localization for DailyAlchemy
------------------------------------------------

ZO_CreateStringId("DA_CRAFTING_QUEST",      "Alchemist Writ")
ZO_CreateStringId("DA_CRAFTING_MASTER",     "A Masterful Concoction")

ZO_CreateStringId("DA_BULK_HEADER",         "Bulk Creation")
ZO_CreateStringId("DA_BULK_FLG",            "Create all the requested items at once")
ZO_CreateStringId("DA_BULK_FLG_TOOLTIP",    "It is used when you want to create a large number of requested items.")
ZO_CreateStringId("DA_BULK_COUNT",          "Created quantity")
ZO_CreateStringId("DA_BULK_COUNT_TOOLTIP",  "In fact it will be created more than this quantity.(Depends on alchemy skills)")

ZO_CreateStringId("DA_CRAFT_WRIT",          "Craft Sealed Writ")
ZO_CreateStringId("DA_CRAFT_WRIT_MSG",      "When accessing the alchemy station, <<1>>")
ZO_CreateStringId("DA_CANCEL_WRIT",         "Cancel Sealed Writ")
ZO_CreateStringId("DA_CANCEL_WRIT_MSG",     "Canceled Sealed Writ")

ZO_CreateStringId("DA_PRIORITY_HEADER",     "Reagent priority")
ZO_CreateStringId("DA_PRIORITY_BY",         "Priority of reagent to be used")
ZO_CreateStringId("DA_PRIORITY_BY_STOCK",   "Many stocks")
ZO_CreateStringId("DA_PRIORITY_BY_MM",      "Low price reagent at [MasterMerchant]")
ZO_CreateStringId("DA_PRIORITY_BY_TTC",     "Low price reagent at [TamrielTradeCentre]")
ZO_CreateStringId("DA_PRIORITY_BY_ATT",     "Low price reagent at [ArkadiusTradeTools]")
ZO_CreateStringId("DA_PRIORITY_BY_MANUAL",  "Set manually")
ZO_CreateStringId("DA_SHOW_PRICE_MANUAL",   "Show price[<<1>>]")
ZO_CreateStringId("DA_PRIORITY_CHANGED",    "The add-on setting [<<1>>] has been changed because the <<2>> is turned off")

ZO_CreateStringId("DA_OTHER_HEADER",        "Other")
ZO_CreateStringId("DA_ACQUIRE_ITEM",        "Retrieve items from bank")
ZO_CreateStringId("DA_AUTO_EXIT",           "Auto exit")
ZO_CreateStringId("DA_AUTO_EXIT_TOOLTIP",   "You will automatically leave the crafting table after completing the daily writ.")
ZO_CreateStringId("DA_ITEM_LOCK",           "Do not use locked items")
ZO_CreateStringId("DA_LOG",                 "Show log")
ZO_CreateStringId("DA_DEBUG_LOG",           "Show debug log")

ZO_CreateStringId("DA_NOTHING_ITEM",        "No items in the backpack (<<1>>)")
ZO_CreateStringId("DA_SHORT_OF",            "... Short of Materials(<<1>>)")
ZO_CreateStringId("DA_MISMATCH_ITEM",       "... [Error]Name does not match (<<1>>)")

ZO_CreateStringId("DA_DETECTION",           "Detection")
ZO_CreateStringId("DA_ARMOR",               "Increase Armor")
ZO_CreateStringId("DA_SPELL_POWER",         "Increase Spell Power")
ZO_CreateStringId("DA_SPELL_RESIST",        "Increase Spell Resist")
ZO_CreateStringId("DA_WEAPON_POWER",        "Increase Weapon Power")
ZO_CreateStringId("DA_INVISIBLE",           "Invisible")
ZO_CreateStringId("DA_FRACTURE",            "Fracture")
ZO_CreateStringId("DA_UNCERTAINTY",         "Uncertainty")
ZO_CreateStringId("DA_COWARDICE",           "Cowardice")
ZO_CreateStringId("DA_BREACH",              "Breach")
ZO_CreateStringId("DA_ENERVATE",            "Enervation")
ZO_CreateStringId("DA_MAIM",                "Maim")
ZO_CreateStringId("DA_RVG_HEALTH",          "Ravage Health")
ZO_CreateStringId("DA_RVG_MAGICKA",         "Ravage Magicka")
ZO_CreateStringId("DA_RVG_STAMINA",         "Ravage Stamina")
ZO_CreateStringId("DA_HINDRANCE",           "Hindrance")
ZO_CreateStringId("DA_HEALTH",              "Restore Health")
ZO_CreateStringId("DA_MAGICKA",             "Restore Magicka")
ZO_CreateStringId("DA_STAMINA",             "Restore Stamina")
ZO_CreateStringId("DA_SPEED",               "Speed")
ZO_CreateStringId("DA_SPELL_CRIT",          "Spell Critical")
ZO_CreateStringId("DA_ENTRAPMENT",          "Entrapment")
ZO_CreateStringId("DA_UNSTOP",              "Unstoppable")
ZO_CreateStringId("DA_WEAPON_CRIT",         "Weapon Critical")
ZO_CreateStringId("DA_VULNERABILITY",       "Vulnerability")
ZO_CreateStringId("DA_DEFILE",              "Defile")
ZO_CreateStringId("DA_GR_RVG_HEALTH",       "Gradual Ravage Health")
ZO_CreateStringId("DA_LGR_HEALTH",          "Lingering Health")
ZO_CreateStringId("DA_VITALITY",            "Vitality")
ZO_CreateStringId("DA_PROTECTION",          "Protection")




function DailyAlchemy:AcquireConditions()
    local list = {
        "Acquire%s(.*)",
    }
    return list
end

function DailyAlchemy:ConvertedItemNames(itemName)
    local list = {
        {"(\-)",     "(\-)"},
        {" IX$",     " Ⅸ"},
        {" VIII$",   " Ⅷ"},
        {" VII$",    " Ⅶ"},
        {" VI$",     " Ⅵ"},
        {" IV$",     " Ⅳ"},
        {" V$",      " Ⅴ"},
        {" III$",    " Ⅲ"},
        {" II$",     " Ⅱ"},
        {" I$",      " Ⅰ"},
        {"panacea ", "Panacea "},   -- Some users have string.lower() disabled?
        {" health",  " Health"},    -- Some users have string.lower() disabled?
        {" stamina", " Stamina"},   -- Some users have string.lower() disabled?
    }

    local convertedItemName = itemName
    for _, value in ipairs(list) do
        convertedItemName = string.gsub(convertedItemName, value[1], value[2])
    end
    return {convertedItemName}
end

function DailyAlchemy:ConvertedJournalCondition(journalCondition)
    local list = {
        {" IX([:%s])",   " Ⅸ%1"},
        {" VIII([:%s])", " Ⅷ%1"},
        {" VII([:%s])",  " Ⅶ%1"},
        {" VI([:%s])",   " Ⅵ%1"},
        {" IV([:%s])",   " Ⅳ%1"},
        {" V([:%s])",    " Ⅴ%1"},
        {" III([:%s])",  " Ⅲ%1"},
        {" II([:%s])",   " Ⅱ%1"},
        {" I([:%s])",    " Ⅰ%1"},
        {"panacea ",     "Panacea "},   -- Some users have string.lower() disabled?
        {" health",      " Health"},    -- Some users have string.lower() disabled?
        {" stamina",     " Stamina"},   -- Some users have string.lower() disabled?

        {"(Craft.*)with.*Traits:%c•(.*)%c•(.*)%c•(.*)%c•.*",  "%1...%2, %3, %4"},
        {".*(Craft.*)with.*properties:(.*)",                  "%1...%2"},
        {":.*",                                               ""}, 
    }

    local convertedCondition = journalCondition
    for _, value in ipairs(list) do
        convertedCondition = string.gsub(convertedCondition, value[1], value[2])
    end
    return convertedCondition
end

function DailyAlchemy:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n(.*) with.*: (.*)", "%1 [%2]")
end

function DailyAlchemy:CraftingConditions()
    local list = {
        "Craft",
        "I need to create the",
    }
    return list
end

function DailyAlchemy:isPoison(conditionText)
    return string.match(conditionText, "Poison")
end

