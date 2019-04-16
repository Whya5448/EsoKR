------------------------------------------------
-- Russian localization for DailyProvisioning
------------------------------------------------

ZO_CreateStringId("DP_CRAFTING_QUEST",      "Заказ снабженцу")
ZO_CreateStringId("DP_CRAFTING_MASTER",     "Искусный пир")

ZO_CreateStringId("DP_BULK_HEADER",         "Массовое создание")
ZO_CreateStringId("DP_BULK_FLG",            "Создаёт все необходимые предметы за раз")
ZO_CreateStringId("DP_BULK_FLG_TOOLTIP",    "Используется, если вы хотите создать несколько требуемых предметов.")
ZO_CreateStringId("DP_BULK_COUNT",          "Количество")
ZO_CreateStringId("DP_BULK_COUNT_TOOLTIP",  "На самом деле, будет создано больше, чем указанное число. (Зависит от навыков снабжения)")

ZO_CreateStringId("DP_CRAFT_WRIT",          "Ремесло Запечатанная заказ")
ZO_CreateStringId("DP_CRAFT_WRIT_MSG",      "При доступе Огонь для приготовления пиши, <<1>>")
ZO_CreateStringId("DP_CANCEL_WRIT",         "Отменить Запечатанная заказ")
ZO_CreateStringId("DP_CANCEL_WRIT_MSG",     "Отменено Запечатанная заказ")

ZO_CreateStringId("DP_OTHER_HEADER",        "Другое")
ZO_CreateStringId("DP_ACQUIRE_ITEM",        "Забирать предметы из банка")
ZO_CreateStringId("DP_AUTO_EXIT",           "Автовыход из окна крафта")
ZO_CreateStringId("DP_AUTO_EXIT_TOOLTIP",   "Автоматически закрывает окна крафта по выполнению задания")
ZO_CreateStringId("DP_DONT_KNOW",           "Отключить автосоздание, если рецепт неизвестен.")
ZO_CreateStringId("DP_DONT_KNOW_TOOLTIP",   "Мы готовим по двум рецептам для еженедельных заданий, но если вы не знаете хотя бы одного рецепта, блюдо не будет создано автоматически.")
ZO_CreateStringId("DP_LOG",                 "Показать журнал")
ZO_CreateStringId("DP_DEBUG_LOG",           "Показать журнал отладки")

ZO_CreateStringId("DP_UNKNOWN_RECIPE",      " Рецепт [<<1>>] неизвестен, Элемент не был создан.")
ZO_CreateStringId("DP_MISMATCH_RECIPE",     " ... [Ошибка] Название рецепта не обнаружено: (<<1>>)")
ZO_CreateStringId("DP_NOTHING_RECIPE",      " ... Не изучен рецепт")
ZO_CreateStringId("DP_SHORT_OF",            " ... Не хватает ингредиентов: (<<1>>)")




function DailyProvisioning:ConvertedItemNameForDisplay(itemName)
    return itemName
end

function DailyProvisioning:ConvertedItemNames(itemName)
    local list = {
        {"(\-)", "(\-)"},
    }

    local convertedItemName = itemName
    for _, value in ipairs(list) do
        convertedItemName = string.gsub(convertedItemName, value[1], value[2])
    end
    return {convertedItemName}
end

function DailyProvisioning:ConvertedJournalCondition(journalCondition)
    local list = {
        {"запеканка с ка...\n",    "запеканка с каплуном \n"},
        {"«Высохшего дер...\n",    "«Высохшего дерева»\n"},
        {"от Орзор.*[)]",               "от Орзорги)"},
        {"от Орзо.* ",                   "от Орзорги "},
        {"«Велотийский[)]",         "«Велотийский вид»"},
        {"аргонианская дев[)]", "аргонианская дева»"},
        {"окунем в дынно.* ",      "окунем в дынном соусе "},
        {"«Похотливая.*\n",          "«Похотливая аргонианская дева» \n"},
    }
    local convertedJournalCondition = journalCondition
    for _, value in ipairs(list) do
        convertedJournalCondition = string.gsub(convertedJournalCondition, value[1], value[2])
    end
    return convertedJournalCondition
end

function DailyProvisioning:ConvertedMasterWritText(txt)
    return string.gsub(txt, ".*:\n(.*)", "%1")
end

function DailyProvisioning:CraftingConditions()
    local list = {
        "Создать",
    }
    return list
end

