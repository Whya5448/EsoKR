------------------------------------------------
-- French localization for DailyAlchemy
------------------------------------------------

ZO_CreateStringId("DA_CRAFTING_QUEST",      "Commande d'alchimie")
ZO_CreateStringId("DA_CRAFTING_MASTER",     "Une concoction magistrale")

ZO_CreateStringId("DA_BULK_HEADER",         "Création en bloc")
ZO_CreateStringId("DA_BULK_FLG",            "Créer tous les éléments demandés à la fois")
ZO_CreateStringId("DA_BULK_FLG_TOOLTIP",    "Utilisez-le lorsque vous souhaitez créer une grande quantité d'éléments demandés.")
ZO_CreateStringId("DA_BULK_COUNT",          "Quantité à créer")
ZO_CreateStringId("DA_BULK_COUNT_TOOLTIP",  "En fait, plus que cette quantité sera faite.(Dépend des compétences d'alchimie)")

ZO_CreateStringId("DA_CRAFT_WRIT",          "Artisanat Commande de maître")
ZO_CreateStringId("DA_CRAFT_WRIT_MSG",      "En accédant à la Établi d'alchimie, <<1>>")
ZO_CreateStringId("DA_CANCEL_WRIT",         "Annuler Commande de maître")
ZO_CreateStringId("DA_CANCEL_WRIT_MSG",     "Annulé Commande de maître")

ZO_CreateStringId("DA_PRIORITY_HEADER",     "Priorité de Réactifs")
ZO_CreateStringId("DA_PRIORITY_BY",         "Priorité du réactif à utiliser")
ZO_CreateStringId("DA_PRIORITY_BY_STOCK",   "Beaucoup d'inventaire")
ZO_CreateStringId("DA_PRIORITY_BY_MM",      "Réactif à bas prix chez [MasterMerchant]")
ZO_CreateStringId("DA_PRIORITY_BY_TTC",     "Réactif à bas prix chez [TamrielTradeCentre]")
ZO_CreateStringId("DA_PRIORITY_BY_ATT",     "Réactif à bas prix chez [ArkadiusTradeTools]")
ZO_CreateStringId("DA_PRIORITY_BY_MANUAL",  "Définir manuellement")
ZO_CreateStringId("DA_SHOW_PRICE_MANUAL",   "Afficher le prix[<<1>>]")
ZO_CreateStringId("DA_PRIORITY_CHANGED",    "Le paramètre d'extension [<<1>>] a été modifié car <<2>> est désactivé")

ZO_CreateStringId("DA_OTHER_HEADER",        "Autre")
ZO_CreateStringId("DA_ACQUIRE_ITEM",        "Récupérer des articles de la banque")
ZO_CreateStringId("DA_AUTO_EXIT",           "Sortie automatique de la fenêtre d'artisanat")
ZO_CreateStringId("DA_AUTO_EXIT_TOOLTIP",   "Sortie automatique de la fenêtre d'artisanat lorsque tout est terminé.")
ZO_CreateStringId("DA_ITEM_LOCK",           "Ne pas utiliser d'objets verrouillés")
ZO_CreateStringId("DA_LOG",                 "Afficher le journal")
ZO_CreateStringId("DA_DEBUG_LOG",           "Afficher le journal de débogage")

ZO_CreateStringId("DA_NOTHING_ITEM",        "Aucun articles dans le sac à dos (<<1>>)")
ZO_CreateStringId("DA_SHORT_OF",            "... court de matériaux(<<1>>)")
ZO_CreateStringId("DA_MISMATCH_ITEM",       "... [Erreur]Le nom ne correspond pas (<<1>>)")

ZO_CreateStringId("DA_DETECTION",           "de détection")                     -- 1:Detection
ZO_CreateStringId("DA_ARMOR",               "Augmente l'armure")                -- 2:Increase Armor
ZO_CreateStringId("DA_SPELL_POWER",         "Augmente la puissance des sorts")  -- 3:Increase Spell Power
ZO_CreateStringId("DA_SPELL_RESIST",        "Augmente la résistance aux sorts") -- 4:Increase Spell Resist
ZO_CreateStringId("DA_WEAPON_POWER",        "Augmente la puissance de l'arme")  -- 5:Increase Weapon Power
ZO_CreateStringId("DA_INVISIBLE",           "invisible")                        -- 6:Invisible
ZO_CreateStringId("DA_FRACTURE",            "Fracture")                         -- 7:Fracture
ZO_CreateStringId("DA_UNCERTAINTY",         "Incertitude")                      -- 8:Uncertainty
ZO_CreateStringId("DA_COWARDICE",           "Couardise")                        -- 9:Cowardice
ZO_CreateStringId("DA_BREACH",              "Brèche")                           -- 10:Breach
ZO_CreateStringId("DA_ENERVATE",            "Affaiblissement")                  -- 11:Enervation
ZO_CreateStringId("DA_MAIM",                "Mutilation")                       -- 12:Maim
ZO_CreateStringId("DA_RVG_HEALTH",          "Réduit la Santé")                  -- 13:Ravage Health
ZO_CreateStringId("DA_RVG_MAGICKA",         "Réduit la Magie")                  -- 14:Ravage Magicka
ZO_CreateStringId("DA_RVG_STAMINA",         "Ravage de Vigueur")                -- 15:Ravage Stamina
ZO_CreateStringId("DA_HINDRANCE",           "Entrave")                          -- 16:Hindrance
ZO_CreateStringId("DA_HEALTH",              "Rend de la Santé")                 -- 17:Restore Health
ZO_CreateStringId("DA_MAGICKA",             "Rend de la Magie")                 -- 18:Restore Magicka
ZO_CreateStringId("DA_STAMINA",             "Rend de la Vigueur")               -- 19:Restore Stamina
ZO_CreateStringId("DA_SPEED",               "Vitesse")                          -- 20:Speed
ZO_CreateStringId("DA_SPELL_CRIT",          "Critique de sorts")                -- 21:Spell Critical
ZO_CreateStringId("DA_ENTRAPMENT",          "Capture")                          -- 22:Entrapment
ZO_CreateStringId("DA_UNSTOP",              "Implacable")                       -- 23:Unstoppable
ZO_CreateStringId("DA_WEAPON_CRIT",         "Critique d'armes")                 -- 24:Weapon Critical
ZO_CreateStringId("DA_VULNERABILITY",       "Vulnérabilité")                    -- 25:Vulnerability
ZO_CreateStringId("DA_DEFILE",              "Profanation")                      -- 26:Defile
ZO_CreateStringId("DA_GR_RVG_HEALTH",       "Ravage de Santé graduel")          -- 27:Gradual Ravage Health
ZO_CreateStringId("DA_LGR_HEALTH",          "Santé persistante")                -- 28:Lingering Health
ZO_CreateStringId("DA_VITALITY",            "Vitalité")                         -- 29:Vitality
ZO_CreateStringId("DA_PROTECTION",          "Protection")                       -- 30:Protection




function DailyAlchemy:AcquireConditions()
    local list = {
        "Acquerez%s%w+%s(.*)",
        "Acquerir%s%w+%s(.*)",
    }
    return list
end

function DailyAlchemy:ConvertedItemNames(itemName)

    local function Convert(itemName)
        local list = {
            {"é",       "e"},
            {"è",       "e"},
            {"â",       "a"},
            {"(\-)",    "(\-)"},
            {" ",       " "}, -- NO-BREAK SPACE(U+00A0) to SPACE (U+0020)
            {" IX$",    " Ⅸ"},
            {" VIII$",  " Ⅷ"},
            {" VII$",   " Ⅶ"},
            {" VI$",    " Ⅵ"},
            {" IV$",    " Ⅳ"},
            {" V$",     " Ⅴ"},
            {" III$",   " Ⅲ"},
            {" II$",    " Ⅱ"},
            {" I$",     " Ⅰ"},
        }

        local convertedItemName = itemName
        for _, value in ipairs(list) do
            convertedItemName = string.gsub(convertedItemName, value[1], value[2])
        end
        return convertedItemName
    end


    if string.match(itemName, "(\|)") then
        local itemName1 = itemName:gsub("(\|)[%a%s%p]*", ""):gsub("(\^)%a*", "")
        local itemName2 = itemName:gsub("[%a%s%p]*(\|)", ""):gsub("(\^)%a*", "")
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
        itemName = itemName:gsub("(\^)%a*", "")
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
        {"é",                   "e"},
        {"è",                   "e"},
        {"â",                   "a"},
        {" ",                   " "},  -- NO-BREAK SPACE(U+00A0) to SPACE (U+0020)
        {" D’",                " de "},
        {" d’",                " de "},
        {"poison de Degats ",   "Poison de ravage "},
        {"poison de Drain ",    "Poison de drain "},
        {" IX ",                " Ⅸ "},
        {" VIII ",              " Ⅷ "},
        {" VII ",               " Ⅶ "},
        {" VI ",                " Ⅵ "},
        {" IV ",                " Ⅳ "},
        {" V ",                 " Ⅴ "},
        {" III ",               " Ⅲ "},
        {" II ",                " Ⅱ "},
        {" I ",                 " Ⅰ "},

        {"(Fabrique.*)avec.*suivant.*%c• (.*)%c• (.*)%c• (.*)%c.*",  "%1...%2, %3, %4"},
        {".*(Fabrique.*)avec.*suivant.*:(.*)",                       "%1...%2"},
        {":.*",                                                      ""}, 
    }

    local convertedCondition = journalCondition
    local result
    local lowerKey
    for _, value in ipairs(list) do
        result = string.match(convertedCondition, value[1])
        if result then
            convertedCondition = string.gsub(convertedCondition, value[1], value[2])
        else
            lowerKey = string.lower(value[1])
            result = string.match(convertedCondition, lowerKey)
            if result then
                convertedCondition = string.gsub(convertedCondition, lowerKey, value[2])
            end
        end
    end
    return convertedCondition
end

function DailyAlchemy:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n(.*) avec.*: (.*)", "%1 [%2]")
end

function DailyAlchemy:CraftingConditions()
    local list = {
        "Preparez",
        "Fabrique",
    }
    return list
end

function DailyAlchemy:isPoison(conditionText)
    return string.match(conditionText, "Poison")
end

