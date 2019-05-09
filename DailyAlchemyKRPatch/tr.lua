------------------------------------------------
-- Korean localization for DailyAlchemy
------------------------------------------------

ZO_CreateStringId("DA_RVG_HEALTH",          EsoKR:E("체력 파괴"))
ZO_CreateStringId("DA_RVG_MAGICKA",         EsoKR:E("매지카 피해"))
ZO_CreateStringId("DA_RVG_STAMINA",         EsoKR:E("스태미나 파괴"))

ZO_CreateStringId("DA_HEALTH",              EsoKR:E("체력 회복"))
ZO_CreateStringId("DA_MAGICKA",             EsoKR:E("매지카 회복"))
ZO_CreateStringId("DA_STAMINA",             EsoKR:E("스태미나 회복"))


local function langParser(str)
    local seperater = "_"

    local level
    local type

    local searchResult1, searchResult2  = string.find(str,"[ ]+")
    level = string.sub(str, 1, searchResult1-1)
    type = string.sub(str, searchResult2)

    searchResult1, searchResult2  = string.find(level,seperater)

    while searchResult1 do
        level = string.sub(level, searchResult2+1)
        searchResult1, searchResult2  = string.find(level,seperater)
    end

    searchResult1, searchResult2  = string.find(type,seperater)

    while searchResult1 do
        type = string.sub(type, searchResult2+1)
        searchResult1, searchResult2  = string.find(type,seperater)
    end
    return level, type
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

function DailyAlchemy:CraftingConditions()
    local list = {
        EsoKR:E("제작"),
        "I need to create the",
    }
    return list
end

function DailyAlchemy:isPoison(conditionText)
    return string.match(conditionText, EsoKR:E("독"))
end

