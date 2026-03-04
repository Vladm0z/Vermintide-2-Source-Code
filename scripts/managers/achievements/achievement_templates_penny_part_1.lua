-- chunkname: @scripts/managers/achievements/achievement_templates_penny_part_1.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = {
	penny_portals_heads = 86,
	penny_portals_vintage = 87
}
local var_0_6 = {
	penny_portals_vintage = "081"
}

var_0_0(var_0_4, "penny_portals_portal", nil, nil, nil, var_0_5.penny_portals_portal, var_0_6.penny_portals_portal)
var_0_0(var_0_4, "penny_portals_heads", nil, nil, nil, var_0_5.penny_portals_heads, var_0_6.penny_portals_heads)
var_0_0(var_0_4, "penny_portals_cleanser", nil, nil, nil, var_0_5.penny_portals_cleanser, var_0_6.penny_portals_cleanser)
var_0_0(var_0_4, "penny_portals_vintage", nil, nil, nil, var_0_5.penny_portals_vintage, var_0_6.penny_portals_vintage)
var_0_0(var_0_4, "penny_portals_hideout", nil, nil, nil, var_0_5.penny_portals_hideout, var_0_6.penny_portals_hideout)

local var_0_7 = {
	LevelSettings.dlc_portals
}
local var_0_8 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for iter_0_0 = 1, #var_0_8 do
	local var_0_9 = var_0_8[iter_0_0]
	local var_0_10 = DifficultyMapping[var_0_9]
	local var_0_11 = "penny_complete_portals_" .. var_0_10

	var_0_1(var_0_4, var_0_11, var_0_7, DifficultySettings[var_0_9].rank, nil, nil, var_0_5[var_0_11], var_0_6[var_0_11])
end

var_0_2(var_0_4, "penny_complete_portals", {
	"penny_portals_portal",
	"penny_portals_heads",
	"penny_portals_cleanser",
	"penny_portals_vintage",
	"penny_portals_hideout"
})
