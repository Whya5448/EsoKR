-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: tr.lua
-- File Description: Korean Localization
-- Load Order Requirements: None
--
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--
-- TRANSLATION NOTES - PLEASE READ
--
-- If you are not looking to translate the addon you can ignore this. :D
--
-- If you ARE looking to translate this to something else then anything with a comment of Vital beside it is
-- REQUIRED for the addon to function properly. These strings MUST BE TRANSLATED EXACTLY!
-- If only going for functionality, ctrl+f for Vital. Otherwise, you should just translate everything. Note that some strings
-- Note that if you are going for a full translation, you must also translate defualt.lua and paste it into your localization file.
--
-- For languages that do not use the Latin Alphabet, there is also an optional langParser() function. IF the language you are translating
-- requires some changes to the WritCreater.parser() function then write the optional langParser() function here, and the addon
-- will use that instead. Just below is a commented out langParser for English. Be sure to remove the comments if rewriting it. [[  ]]
--
-- If you run into problems, please feel free to contact me on ESOUI.
--
-----------------------------------------------------------------------------------
--

function WritCreater.langParser(str)  -- Optional overwrite function for language translations
	local seperater = "[ ]+"

	str = string.gsub(str,EsoKR:E("을"),"") --을
	str = string.gsub(str,EsoKR:E("를"),"") --를
	str = string.gsub(str,"_"," ") --를

	local params = {}
	local i = 1
	local searchResult1, searchResult2  = string.find(str,seperater)
	if searchResult1 == 1 then
		str = string.sub(str, searchResult2+1)
		searchResult1, searchResult2  = string.find(str,seperater)
	end

	while searchResult1 do

		params[i] = string.sub(str, 1, searchResult1-1)
		str = string.sub(str, searchResult2+1)
		searchResult1, searchResult2  = string.find(str,seperater)
		i=i+1
	end
	params[i] = str
	return params

end


WritCreater = WritCreater or {}

local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

function WritCreater.langWritNames() -- Vital
	-- Exact!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
		["G"] = EsoKR:E("의뢰서를 확인한다."),
		[CRAFTING_TYPE_ENCHANTING] = EsoKR:E("마법부여가"),
		[CRAFTING_TYPE_BLACKSMITHING] = EsoKR:E("대장장이"),
		[CRAFTING_TYPE_CLOTHIER] = EsoKR:E("재봉사"),
		[CRAFTING_TYPE_PROVISIONING] = EsoKR:E("요리사"),
		[CRAFTING_TYPE_WOODWORKING] = EsoKR:E("목세공사"),
		[CRAFTING_TYPE_ALCHEMY] = EsoKR:E("연금술사"),
		[CRAFTING_TYPE_JEWELRYCRAFTING] = "Jewelry",
	}
	return names
end

function WritCreater.langMasterWritNames() -- Vital
	local names = {
		["M"] 							= "masterful",
		["M1"]							= "master",
		[CRAFTING_TYPE_ALCHEMY]			= "concoction",
		[CRAFTING_TYPE_ENCHANTING]		= "glyph",
		[CRAFTING_TYPE_PROVISIONING]	= "feast",
		["plate"]						= "plate",
		["tailoring"]					= "tailoring",
		["leatherwear"]					= "leatherwear",
		["weapon"]						= "weapon",
		["shield"]						= "shield",
	}
	return names

end

function WritCreater.writCompleteStrings() -- Vital for translation
	local strings = {
		["place"] = "<紼湴襄 苁覐蟐 猣璔瓤.>",
		["sign"] = "Sign the Manifest",
		["masterPlace"] = "I've finished the ",
		["masterSign"] = "<Finish the job.>",
		["masterStart"] = "<Accept the contract.>",
		["Rolis Hlaalu"] = "Rolis Hlaalu", -- This is the same in most languages but ofc chinese and japanese
		["Deliver"] = "縰瓬靘瀰",
	}
	return strings
end


function WritCreater.languageInfo() -- Vital

	local craftInfo =
	{
		[ CRAFTING_TYPE_CLOTHIER] =
		{
			["pieces"] = --exact!!
			{
				[1] = EsoKR:E("로브"), -- "robe",
				[2] = EsoKR:E("셔츠"), -- "jerkin",
				[3] = EsoKR:E("신발"), -- "shoes",
				[4] = EsoKR:E("장갑"), -- "gloves",
				[5] = EsoKR:E("모자"), -- "hat",
				[6] = EsoKR:E("바지"), -- "breeches",
				[7] = EsoKR:E("어깨장식"), -- "epaulet",
				[8] = EsoKR:E("허리띠"), -- "sash",
				[9] = EsoKR:E("경갑"), -- "jack",
				[10]= EsoKR:E("부츠"), -- "boots",
				[11]= EsoKR:E("팔목보호대"), -- "bracers",
				[12]= EsoKR:E("투구"), -- "helmet",
				[13]= EsoKR:E("다리보호대"), -- "guards",
				[14]= EsoKR:E("어깨보호대"), -- "cops",
				[15]= EsoKR:E("벨트"), -- "belt",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = EsoKR:E("수제"), -- "Homespun", --lvtier one of mats
				[2] = EsoKR:E("아마포"), -- "Linen",	--l
				[3] = EsoKR:E("면포"), -- "Cotton",
				[4] = EsoKR:E("거미 비단"), -- "Spidersilk",
				[5] = EsoKR:E("에본실"), -- "Ebonthread",
				[6] = EsoKR:E("크레시"), -- "Kresh",
				[7] = EsoKR:E("철실"), -- "Ironthread",
				[8] = EsoKR:E("은섬유"), -- "Silverweave",
				[9] = EsoKR:E("그림자 천"), -- "Shadowspun",
				[10]= EsoKR:E("선조"), -- "Ancestor",
				[11]= EsoKR:E("생가죽"), -- "Rawhide",
				[12]= "Hide", -- "Hide",
				[13]= "Leather", -- "Leather",
				[14]= "Full-Leather", -- "Full-Leather",
				[15]= "Fell", -- "Fell",
				[16]= "Brigandine", -- "Brigandine",
				[17]= EsoKR:E("철 가죽"), -- "Ironhide",
				[18]= EsoKR:E("최상급"), -- "Superb",
				[19]= EsoKR:E("그림자가죽"), -- "Shadowhide",
				[20]= EsoKR:E("루베도"), -- "Rubedo",
			},

		},
		[CRAFTING_TYPE_BLACKSMITHING] =
		{
			["pieces"] = --exact!!
			{
				[1] = EsoKR:E("도끼"), -- "axe",
				[2] = EsoKR:E("둔기"), -- "mace",
				[3] = EsoKR:E("검"), -- "sword",
				[4] = EsoKR:E("전투도끼"), -- "battle",
				[5] = EsoKR:E("전투망치"), -- "maul",
				[6] = EsoKR:E("대검"), -- "greatsword",
				[7] = EsoKR:E("단검"), -- "dagger",
				[8] = EsoKR:E("흉갑"), -- "cuirass",
				[9] = EsoKR:E("구두"), -- "sabatons",
				[10] = EsoKR:E("건틀렛"), -- "gauntlets",
				[11] = EsoKR:E("헬름"), -- "helm",
				[12] = EsoKR:E("각반"), -- "greaves",
				[13] = EsoKR:E("견갑"), -- "pauldron",
				[14] = EsoKR:E("거들"), -- "girdle",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = EsoKR:E("철"), -- "Iron",
				[2] = "Steel", -- "Steel",
				[3] = EsoKR:E("오리할콘"), -- "Orichalc",
				[4] = EsoKR:E("드워븐"), -- "Dwarven",
				[5] = EsoKR:E("에보니"), -- "Ebon",
				[6] = EsoKR:E("칼시니움"), -- "Calcinium",
				[7] = EsoKR:E("갈라타이트"), -- "Galatite",
				[8] = EsoKR:E("수은"), -- "Quicksilver",
				[9] = EsoKR:E("공허강"), -- "Voidsteel",
				[10]= EsoKR:E("루비다이트"), -- "Rubedite",
			},

		},
		[CRAFTING_TYPE_WOODWORKING] =
		{
			["pieces"] = --Exact!!!
			{
				[1] = EsoKR:E("활"), -- "bow",
				[3] = EsoKR:E("화염"), -- "inferno",
				[4] = EsoKR:E("냉기"), -- "ice",
				[5] = EsoKR:E("전격"), -- "lightning",
				[6] = EsoKR:E("치유"), -- "restoration",
				[2] = EsoKR:E("방패"), -- "shield",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = EsoKR:E("단풍나무"), -- "Maple",
				[2] = EsoKR:E("참나무"), -- "Oak",
				[3] = EsoKR:E("너도밤나무"), -- "Beech",
				[4] = EsoKR:E("히코리"), -- "Hickory",
				[5] = EsoKR:E("주목"), -- "Yew",
				[6] = EsoKR:E("자작나무"), -- "Birch",
				[7] = EsoKR:E("물푸레나무"), -- "Ash",
				[8] = EsoKR:E("마호가니"), -- "Mahogany",
				[9] = EsoKR:E("나이트우드"), -- "Nightwood",
				[10] = EsoKR:E("루비"), -- "Ruby",
			},

		},
		[CRAFTING_TYPE_JEWELRYCRAFTING] =
		{
			["pieces"] = --Exact!!!
			{
				[1] = "ring", -- "ring",
				[2] = "necklace", -- "necklace",

			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "Pewter", -- "Pewter", -- 1
				[2] = "Copper", -- "Copper", -- 26
				[3] = "Silver", -- "Silver", -- CP10
				[4] = "Electrum", -- "Electrum", --CP80
				[5] = "Platinum", -- "Platinum", -- CP150
			},

		},
		[CRAFTING_TYPE_ENCHANTING] =
		{
			["pieces"] = --exact!!
			{ --{String Identifier, ItemId, positive or negative}
				{"disease", 45841,2},
				{"foulness", 45841,1},
				{"absorb stamina", 45833,2},
				{"absorb magicka", 45832,2},
				{"absorb health", 45831,2},
				{"frost resist",45839,2},
				{"frost",45839,1},
				{"feat", 45836,2},
				{"stamina recovery", 45836,1},
				{"hardening", 45842,1},
				{"crushing", 45842,2},
				{"onslaught", 68342,2},
				{"defense", 68342,1},
				{"shielding",45849,2},
				{"bashing",45849,1},
				{"poison resist",45837,2},
				{"poison",45837,1},
				{"spell harm",45848,2},
				{"magical",45848,1},
				{"magicka recovery", 45835,1},
				{"spell cost", 45835,2},
				{"shock resist",45840,2},
				{"shock",45840,1},
				{"health recovery",45834,1},
				{"decrease health",45834,2},
				{"weakening",45843,2},
				{"weapon",45843,1},
				{"boost",45846,1},
				{"speed",45846,2},
				{"flame resist",45838,2},
				{"flame",45838,1},
				{"decrease physical", 45847,2},
				{"increase physical", 45847,1},
				{EsoKR:E("스태미나"),45833,1}, -- stamina
				{EsoKR:E("체력"),45831,1}, -- health
				{EsoKR:E("매지카"),45832,1} -- magicka
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				[1] = {EsoKR:E("티끌만한"),45855}, -- trifling
				[2] = {EsoKR:E("열등한"),45856}, -- inferior
				[3] = {EsoKR:E("하찮은"),45857}, -- petty
				[4] = {EsoKR:E("미약한"),45806}, -- slight
				[5] = {EsoKR:E("아담한"),45807}, -- minor
				[6] = {EsoKR:E("하등한"),45808}, -- lesser
				[7] = {EsoKR:E("일반적인"),45809}, -- moderate
				[8] = {EsoKR:E("평균적인"),45810}, -- average
				[9] = {EsoKR:E("강력한"),45811}, -- strong
				[10]= {EsoKR:E("우수한"),45812}, -- major
				[11]= {EsoKR:E("대단한"),45813}, -- greater
				[12]= {EsoKR:E("강대한"),45814}, -- grand
				[13]= {EsoKR:E("탁월한"),45815}, -- splendid
				[14]= {EsoKR:E("기념적인"),45816}, -- monumental
				[15]= {EsoKR:E("초월"),{68341,68340,},}, -- truly
				[16]= {EsoKR:E("우월한"),{64509,64508,},},

			},
			["quality"] =
			{
				{"normal",45850}, -- normal
				{EsoKR:E("좋은"),45851}, -- fine
				{EsoKR:E("우수한"),45852}, -- superior
				{"epic",45853}, -- epic
				{EsoKR:E("전설적인"),45854}, -- legendary
				{"", 45850} -- default, if nothing is mentioned. Default should be Ta.
			}
		},
	}

	return craftInfo

end

function WritCreater.masterWritQuality() -- Vital . This is probably not necessary, but it stays for now because it works
	return {{"Epic",4},{"Legendary",5}}
end




function WritCreater.langEssenceNames() -- Vital

	local essenceNames =
	{
		[1] = EsoKR:E("오코"), -- "Oko", --health
		[2] = EsoKR:E("데니"), -- "Deni", --stamina
		[3] = EsoKR:E("마코"), -- "Makko", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() -- Vital
	--exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames =
	{
		[1] = EsoKR:E("조라"), -- "Jora", --Lowest potency stone lvl
		[2] = EsoKR:E("포라데"), -- "Porade",
		[3] = EsoKR:E("제라"), -- "Jera",
		[4] = EsoKR:E("제조라"), -- "Jejora",
		[5] = EsoKR:E("오드라"), -- "Odra",
		[6] = EsoKR:E("포조라"), -- "Pojora",
		[7] = EsoKR:E("에도라"), -- "Edora",
		[8] = EsoKR:E("제에라"), -- "Jaera",
		[9] = EsoKR:E("포라"), -- "Pora",
		[10]= EsoKR:E("데나라"), -- "Denara",
		[11]= EsoKR:E("레라"), -- "Rera",
		[12]= EsoKR:E("데라도"), -- "Derado",
		[13]= EsoKR:E("레쿠라"), -- "Rekura",
		[14]= EsoKR:E("쿠라"), -- "Kura",
		[15]= EsoKR:E("레제라"), -- "Rejera",
		[16]= EsoKR:E("레포라"), -- "Repora", --v16 potency stone

	}
	return potencyNames
end

local exceptions =
{
	[1] =
	{
		["original"] = EsoKR:E("강철"), --강철
		["corrected"] = "Steel", --Steel
	},
	[2] =
	{
		["original"] = EsoKR:E("루비 물푸레나무"), --루비 물푸레나무
		["corrected"] = EsoKR:E("루비"), --루비
	},
}

function WritCreater.exceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)

	for i = 1, #exceptions do

		if string.find(condition, exceptions[i]["original"]) then
			condition = string.gsub(condition, exceptions[i]["original"],exceptions[i]["corrected"])
		end
	end
	return condition
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)

	condition = string.gsub(condition, " "," ")
	return condition
end


function WritCreater.langTutorial(i)
	local t = {
		[5]="There's also a few things you should know.\nFirst, /dailyreset is a slash command that will tell you\nhow long until the next daily server reset.",
		[4]="Finally, you can also choose to deactivate or\nactivate this addon for each profession.\nBy default, all applicable crafts are on.\nIf you wish to turn some off, please check the settings.",
		[3]="Next, you need to choose if you wish to see this\nwindow when using a crafting station.\nThe window will tell you how many mats the writ will require, as well as how many you currently have.",
		[2]="The first setting to choose is if you\nwant to useAutoCraft.\nIf on, when you enter a crafting station, the addon will start crafting.",
		[1]="Welcome to Dolgubon's Lazy Writ Crafter!\nThere are a few settings you should choose first.\n You can change the settings at any\n time in the settings menu.",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) -- sentimental and short please. These must fit on a small button
	local tOn =
	{
		[1]=EsoKR:E("기본값 사용"),
		[2]=EsoKR:E("켜기"),
		[3]=EsoKR:E("표시"),
		[4]=EsoKR:E("계속"),
		[5]=EsoKR:E("완료"),
	}
	local tOff=
	{
		[1]=EsoKR:E("계속"),
		[2]=EsoKR:E("끄기"),
		[3]=EsoKR:E("다시 표시 안함"),
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end

function WritCreater.langStationNames()
	return
	{[EsoKR:E("대장기술 제작대")] = 1, [EsoKR:E("재봉 제작대")] = 2,
	 [EsoKR:E("마법부여 제작대")] = 3,[EsoKR:E("연금술 제작대")] = 4, [EsoKR:E("요리용 화로")] = 5, [EsoKR:E("목공 제작대")] = 6, ["Jewelry Crafting Station"] = 7, }
end

local function alternateListener(eventCode,  channelType, fromName, text, isCustomerService, fromDisplayName)
	-- if GetDisplayName() == "@Dolgubon" then
	-- 	d(WritCreater.alternateUniverse)
	-- 	return
	-- end
	if not WritCreater.alternateUniverse and fromDisplayName == "@Dolgubon"and text == "Let the Isles bleed into Nirn!" then
		enableAlternateUniverse(true)
		WritCreater.WipeThatFrownOffYourFace(true)
	end
end
-- 20764
-- 21465

EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_CHAT_MESSAGE_CHANNEL, alternateListener)

--Hide craft window when done
--"Verstecke Fenster anschließend",
-- [tooltip ] = "Verstecke das Writ Crafter Fenster an der Handwerksstation automatisch, nachdem die Gegenstände hergestellt wurden"

function WritCreater.langWritRewardBoxes () return {
	[CRAFTING_TYPE_ALCHEMY] = EsoKR:E("연금술사의 용기"), -- "Alchemist's Vessel",
	[CRAFTING_TYPE_ENCHANTING] = EsoKR:E("마법부여가의 궤짝"), -- "Enchanter's Coffer",
	[CRAFTING_TYPE_PROVISIONING] = EsoKR:E("요리사의 꾸러미"), -- "Provisioner's Pack",
	[CRAFTING_TYPE_BLACKSMITHING] = EsoKR:E("대장장이의 상자"), -- "Blacksmith's Crate",
	[CRAFTING_TYPE_CLOTHIER] = EsoKR:E("재봉사의 가방"), -- "Clothier's Satchel",
	[CRAFTING_TYPE_WOODWORKING] = EsoKR:E("목세공사의 상자"), -- "Woodworker's Case",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "Jewelry Crafter's Coffer", -- "Jewelry Crafter's Coffer",
	[8] = EsoKR:E("적하물"), -- "Shipment",
	[9] = "Shipment", -- "Shipment",
}
end


function WritCreater.getTaString()
	return EsoKR:E("타") -- ta
end

WritCreater.lang = EsoKR.langVer.index
WritCreater.langIsMasterWritSupported = true