------------------------------------------------
-- Japanese localization for DailyAlchemy
------------------------------------------------

ZO_CreateStringId("DA_CRAFTING_QUEST",      "錬金術師の依頼")
ZO_CreateStringId("DA_CRAFTING_MASTER",     "優れた調合薬")

ZO_CreateStringId("DA_BULK_HEADER",         "一括作成")
ZO_CreateStringId("DA_BULK_FLG",            "依頼品を一括作成する")
ZO_CreateStringId("DA_BULK_FLG_TOOLTIP",    "依頼品を大量に作成しておきたい場合などに使用します。")
ZO_CreateStringId("DA_BULK_COUNT",          "作成数量")
ZO_CreateStringId("DA_BULK_COUNT_TOOLTIP",  "実際にはこの数量より多く作成されます。(錬金術スキルに依存)")

ZO_CreateStringId("DA_CRAFT_WRIT",          "依頼品を作成する")
ZO_CreateStringId("DA_CRAFT_WRIT_MSG",      "錬金台にアクセス時、<<1>>")
ZO_CreateStringId("DA_CANCEL_WRIT",         "依頼品の作成をキャンセル")
ZO_CreateStringId("DA_CANCEL_WRIT_MSG",     "依頼品の作成をキャンセルしました")

ZO_CreateStringId("DA_PRIORITY_HEADER",     "試料の優先順位")
ZO_CreateStringId("DA_PRIORITY_BY",         "使用する試料の優先順位")
ZO_CreateStringId("DA_PRIORITY_BY_STOCK",   "在庫が多い")
ZO_CreateStringId("DA_PRIORITY_BY_MM",      "[MasterMerchant]価格が安い")
ZO_CreateStringId("DA_PRIORITY_BY_TTC",     "[TamrielTradeCentre]価格が安い")
ZO_CreateStringId("DA_PRIORITY_BY_ATT",     "[ArkadiusTradeTools]価格が安い")
ZO_CreateStringId("DA_PRIORITY_BY_MANUAL",  "手動で設定する")
ZO_CreateStringId("DA_SHOW_PRICE_MANUAL",   "価格を表示[<<1>>]")
ZO_CreateStringId("DA_PRIORITY_CHANGED",    "<<2>>がオフになったため、アドオン設定[<<1>>]が変更されました")

ZO_CreateStringId("DA_OTHER_HEADER",        "その他")
ZO_CreateStringId("DA_ACQUIRE_ITEM",        "銀行からアイテムを取り出す")
ZO_CreateStringId("DA_AUTO_EXIT",           "生産メニューを自動退出する")
ZO_CreateStringId("DA_AUTO_EXIT_TOOLTIP",   "自動作成が終わると生産メニューから退出します")
ZO_CreateStringId("DA_ITEM_LOCK",           "ロック中のアイテムは使用しない")
ZO_CreateStringId("DA_LOG",                 "ログを表示")
ZO_CreateStringId("DA_DEBUG_LOG",           "デバッグログを表示")

ZO_CreateStringId("DA_NOTHING_ITEM",        "バックパックにアイテムを持っていません (<<1>>)")
ZO_CreateStringId("DA_SHORT_OF",            "... 材料が不足しています(<<1>>)")
ZO_CreateStringId("DA_MISMATCH_ITEM",       "... [エラー]名前が一致しません (<<1>>)")

ZO_CreateStringId("DA_DETECTION",           "探知")             -- 1:Detection
ZO_CreateStringId("DA_ARMOR",               "防御力増大")       -- 2:Increase Armor
ZO_CreateStringId("DA_SPELL_POWER",         "呪文攻撃力上昇")   -- 3:Increase Spell Power
ZO_CreateStringId("DA_SPELL_RESIST",        "呪文耐性増大")     -- 4:Increase Spell Resist
ZO_CreateStringId("DA_WEAPON_POWER",        "武器攻撃力上昇")   -- 5:Increase Weapon Power
ZO_CreateStringId("DA_INVISIBLE",           "透明化")           -- 6:Invisible
ZO_CreateStringId("DA_FRACTURE",            "破砕")             -- 7:Fracture
ZO_CreateStringId("DA_UNCERTAINTY",         "不信")             -- 8:Uncertainty
ZO_CreateStringId("DA_COWARDICE",           "臆病")             -- 9:Cowardice
ZO_CreateStringId("DA_BREACH",              "侵害")             -- 10:Breach
ZO_CreateStringId("DA_ENERVATE",            "弱体化")           -- 11:Enervation
ZO_CreateStringId("DA_MAIM",                "不自由")           -- 12:Maim
ZO_CreateStringId("DA_RVG_HEALTH",          "体力減少")         -- 13:Ravage Health
ZO_CreateStringId("DA_RVG_MAGICKA",         "マジカ減少")       -- 14:Ravage Magicka
ZO_CreateStringId("DA_RVG_STAMINA",         "スタミナ減少")     -- 15:Ravage Stamina
ZO_CreateStringId("DA_HINDRANCE",           "妨害")             -- 16:Hindrance
ZO_CreateStringId("DA_HEALTH",              "体力回復")         -- 17:Restore Health
ZO_CreateStringId("DA_MAGICKA",             "マジカ回復")       -- 18:Restore Magicka
ZO_CreateStringId("DA_STAMINA",             "スタミナ回復")     -- 19:Restore Stamina
ZO_CreateStringId("DA_SPEED",               "加速")             -- 20:Speed
ZO_CreateStringId("DA_SPELL_CRIT",          "呪文クリティカル") -- 21:Spell Critical
ZO_CreateStringId("DA_ENTRAPMENT",          "罠")               -- 22:Entrapment
ZO_CreateStringId("DA_UNSTOP",              "猪突猛進")         -- 23:Unstoppable
ZO_CreateStringId("DA_WEAPON_CRIT",         "武器クリティカル") -- 24:Weapon Critical
ZO_CreateStringId("DA_VULNERABILITY",       "脆弱")             -- 25:Vulnerability
ZO_CreateStringId("DA_DEFILE",              "汚染")             -- 26:Defile
ZO_CreateStringId("DA_GR_RVG_HEALTH",       "体力漸減")         -- 27:Gradual Ravage Health
ZO_CreateStringId("DA_LGR_HEALTH",          "体力継続")         -- 28:Lingering Health
ZO_CreateStringId("DA_VITALITY",            "生命力")           -- 29:Vitality
ZO_CreateStringId("DA_PROTECTION",          "防護")             -- 30:Protection




function DailyAlchemy:AcquireConditions()
    local list = {
        "(.*)を手に入れる(.*)",
    }
    return list
end

function DailyAlchemy:ConvertedItemNames(itemName)
    local list = {
        {" ",    ""},
        {"毒9",  "毒IX"},
        {"毒8",  "毒Ⅷ"},
        {"毒7",  "毒Ⅶ"},
        {"毒6",  "毒Ⅵ"},
        {"毒5",  "毒Ⅴ"},
        {"毒4",  "毒Ⅳ"},
        {"毒3",  "毒Ⅲ"},
        {"毒2",  "毒Ⅱ"},
        {"毒1",  "毒Ⅰ"},
    }

    local convertedItemName = itemName
    for _, value in ipairs(list) do
        convertedItemName = string.gsub(convertedItemName, value[1], value[2])
    end
    return {convertedItemName}
end

function DailyAlchemy:ConvertedJournalCondition(journalCondition)
    local list = {
        {" ",   ""},
        {"毒9", "毒IX"},
        {"毒8", "毒Ⅷ"},
        {"毒7", "毒Ⅶ"},
        {"毒6", "毒Ⅵ"},
        {"毒5", "毒Ⅴ"},
        {"毒4", "毒Ⅳ"},
        {"毒3", "毒Ⅲ"},
        {"毒2", "毒Ⅱ"},
        {"毒1", "毒Ⅰ"},

        {"(次の.*作成する):%c•(.*)%c•(.*)%c•(.*)%c•.*",  "%1...%2, %3, %4"},
        {".*(次の.*作成する):(.*)",                      "%1...%2"},
        {":.*",                                          ""}, 
    }

    local convertedCondition = journalCondition
    for _, value in ipairs(list) do
        convertedCondition = string.gsub(convertedCondition, value[1], value[2])
    end
    return convertedCondition
end

function DailyAlchemy:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n次の(.*)%s(.*): (.*)", "%1%2 [%3]")
end

function DailyAlchemy:CraftingConditions()
    local list = {
        "を作る",
        "を生産する",
        "を作成する",
    }
    return list
end

function DailyAlchemy:isPoison(conditionText)
    return string.match(conditionText, "の毒")
end

