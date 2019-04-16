------------------------------------------------
-- Russian localization for DailyAlchemy
------------------------------------------------

ZO_CreateStringId("DA_CRAFTING_QUEST",      "Заказ алхимику")
ZO_CreateStringId("DA_CRAFTING_MASTER",     "Искусное варево")

ZO_CreateStringId("DA_BULK_HEADER",         "Массовое создание")
ZO_CreateStringId("DA_BULK_FLG",            "Создаёт все необходимые предметы за раз")
ZO_CreateStringId("DA_BULK_FLG_TOOLTIP",    "Используется, если вы хотите создать несколько требуемых предметов.")
ZO_CreateStringId("DA_BULK_COUNT",          "Количество")
ZO_CreateStringId("DA_BULK_COUNT_TOOLTIP",  "На самом деле, будет создано больше, чем указанное число. (Зависит от навыков алхимии)")

ZO_CreateStringId("DA_CRAFT_WRIT",          "Ремесло Запечатанная заказ")
ZO_CreateStringId("DA_CRAFT_WRIT_MSG",      "При доступе Алхимическая станция, <<1>>")
ZO_CreateStringId("DA_CANCEL_WRIT",         "Отменить Запечатанная заказ")
ZO_CreateStringId("DA_CANCEL_WRIT_MSG",     "Отменено Запечатанная заказ")

ZO_CreateStringId("DA_PRIORITY_HEADER",     "Приоритет реагента")
ZO_CreateStringId("DA_PRIORITY_BY",         "Использование реагента по приоритету")
ZO_CreateStringId("DA_PRIORITY_BY_STOCK",   "По количеству")
ZO_CreateStringId("DA_PRIORITY_BY_MM",      "По низкой цене [MasterMerchant]")
ZO_CreateStringId("DA_PRIORITY_BY_TTC",     "По низкой цене [TamrielTradeCentre]")
ZO_CreateStringId("DA_PRIORITY_BY_ATT",     "По низкой цене [ArkadiusTradeTools]")
ZO_CreateStringId("DA_PRIORITY_BY_MANUAL",  "Задано вручную")
ZO_CreateStringId("DA_SHOW_PRICE_MANUAL",   "Показать цену[<<1>>]")
ZO_CreateStringId("DA_PRIORITY_CHANGED",    "Настройка аддона [<<1>>] была изменена, так как <<2>> выключен")  

ZO_CreateStringId("DA_OTHER_HEADER",        "Другое")
ZO_CreateStringId("DA_ACQUIRE_ITEM",        "Забирать предметы из банка")
ZO_CreateStringId("DA_AUTO_EXIT",           "Автовыход из окна крафта")
ZO_CreateStringId("DA_AUTO_EXIT_TOOLTIP",   "Автоматически закрывает окна крафта по выполнению задания")
ZO_CreateStringId("DA_ITEM_LOCK",           "Не используйте заблокированные предметы")
ZO_CreateStringId("DA_LOG",                 "Показать журнал")
ZO_CreateStringId("DA_DEBUG_LOG",           "Показать журнал отладки")

ZO_CreateStringId("DA_NOTHING_ITEM",        "Нет нужных предметов: (<<1>>)")
ZO_CreateStringId("DA_SHORT_OF",            "... Не хватает реагентов: (<<1>>)")
ZO_CreateStringId("DA_MISMATCH_ITEM",       "... [Ошибка] Имя не совпадает: (<<1>>)")

ZO_CreateStringId("DA_DETECTION",           "Обнаружение")
ZO_CreateStringId("DA_ARMOR",               "Увеличение брони")
ZO_CreateStringId("DA_SPELL_POWER",         "Увеличение силы заклинаний")
ZO_CreateStringId("DA_SPELL_RESIST",        "Увеличение защиты от магии")
ZO_CreateStringId("DA_WEAPON_POWER",        "Увеличение силы оружия")
ZO_CreateStringId("DA_INVISIBLE",           "Невидимость")
ZO_CreateStringId("DA_FRACTURE",            "Перелом")
ZO_CreateStringId("DA_UNCERTAINTY",         "Неуверенность")
ZO_CreateStringId("DA_COWARDICE",           "Трусость")
ZO_CreateStringId("DA_BREACH",              "Разрыв")
ZO_CreateStringId("DA_ENERVATE",            "Слабость")
ZO_CreateStringId("DA_MAIM",                "Травма")
ZO_CreateStringId("DA_RVG_HEALTH",          "Опустошение здоровья")
ZO_CreateStringId("DA_RVG_MAGICKA",         "Опустошение магии")
ZO_CreateStringId("DA_RVG_STAMINA",         "Опустошение запаса сил")
ZO_CreateStringId("DA_HINDRANCE",           "Помеха")
ZO_CreateStringId("DA_HEALTH",              "Восстановление здоровья")
ZO_CreateStringId("DA_MAGICKA",             "Восстановление магии")
ZO_CreateStringId("DA_STAMINA",             "Восстановление запаса сил")
ZO_CreateStringId("DA_SPEED",               "Скорость")
ZO_CreateStringId("DA_SPELL_CRIT",          "Критический урон заклинаниями")
ZO_CreateStringId("DA_ENTRAPMENT",          "Защемление")
ZO_CreateStringId("DA_UNSTOP",              "Неудержимость")
ZO_CreateStringId("DA_WEAPON_CRIT",         "Критический урон оружием")
ZO_CreateStringId("DA_VULNERABILITY",       "Уязвимость")
ZO_CreateStringId("DA_DEFILE",              "Осквернение")
ZO_CreateStringId("DA_GR_RVG_HEALTH",       "Постепенное опустош. здоровья")
ZO_CreateStringId("DA_LGR_HEALTH",          "Длительное исцеление")
ZO_CreateStringId("DA_VITALITY",            "Живучесть")
ZO_CreateStringId("DA_PROTECTION",          "Защита")




function DailyAlchemy:AcquireConditions()
    local list = {
        "Раздобыть — (.*)",
        "Раздобыть%s(.*)",
        "Добыть%s(.*)",
        "Достать%s(.*)",
    }
    return list
end

function DailyAlchemy:ConvertedItemNames(itemName)
    local list = {
        {"(\-)", "(\-)"},
        {" IX$",   " Ⅸ"},
        {" VIII$", " Ⅷ"},
        {" VII$",  " Ⅶ"},
        {" VI$",   " Ⅵ"},
        {" IV$",   " Ⅳ"},
        {" V$",    " Ⅴ"},
        {" III$",  " Ⅲ"},
        {" II$",   " Ⅱ"},
        {" I$",    " Ⅰ"},
    }

    local convertedItemName = itemName
    for _, value in ipairs(list) do
        convertedItemName = string.gsub(convertedItemName, value[1], value[2])
    end
    return {convertedItemName}
end

function DailyAlchemy:ConvertedJournalCondition(journalCondition)
    local list = {
        {" природную воду([):%s])",      " природная вода%1"},
        {"фильтрованную воду",       "фильтрованная вода"},
        {"дистиллированную воду", "дистиллированная вода"},

        {" IX([):%s])",   " Ⅸ%1"},
        {" VIII([):%s])", " Ⅷ%1"},
        {" VII([):%s])",  " Ⅶ%1"},
        {" VI([):%s])",   " Ⅵ%1"},
        {" IV([):%s])",   " Ⅳ%1"},
        {" V([):%s])",    " Ⅴ%1"},
        {" III([):%s])",  " Ⅲ%1"},
        {" II([):%s])",   " Ⅱ%1"},
        {" I([):%s])",    " Ⅰ%1"},

        {"(Создать.*) со .*эффектами.*%c• (.*)%c• (.*)%c• (.*)%c• .*",  "%1...%2, %3, %4"},
        {".*(Создать.*) со .*эффектами.*:(.*)",                         "%1...%2"},
        {":.*",                                                                           ""}, 
    }

    local convertedCondition = journalCondition
    for _, value in ipairs(list) do
        convertedCondition = string.gsub(convertedCondition, value[1], value[2])
    end
    return convertedCondition
end

function DailyAlchemy:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n(.*) со следующими.*: (.*)", "%1 [%2]")
end

function DailyAlchemy:CraftingConditions()
    local list = {
        "Создать",
        "Craft",
        "Мне нужно создать",
    }
    return list
end

function DailyAlchemy:isPoison(conditionText)
    local list = {
        "Яд",
        "Poison",
    }
    for _, value in ipairs(list) do
        if string.match(conditionText, value) then
            return true
        end
    end
    return false
end

