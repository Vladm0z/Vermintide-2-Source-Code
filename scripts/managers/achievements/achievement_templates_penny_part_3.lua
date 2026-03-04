-- chunkname: @scripts/managers/achievements/achievement_templates_penny_part_3.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = {
	penny_complete_veteran = 83,
	penny_castle_eruptions = 90,
	penny_complete_recruit = 82,
	penny_complete_legend = 85,
	penny_complete_champion = 84,
	penny_castle_no_kill = 91
}
local var_0_6 = {
	penny_castle_eruptions = "083"
}

var_0_0(var_0_4, "penny_castle_chalice", nil, nil, nil, var_0_5.penny_castle_chalice, var_0_6.penny_castle_chalice)
var_0_0(var_0_4, "penny_castle_skull", nil, nil, nil, var_0_5.penny_castle_skull, var_0_6.penny_castle_skull)
var_0_0(var_0_4, "penny_castle_flask", nil, nil, nil, var_0_5.penny_castle_flask, var_0_6.penny_castle_flask)
var_0_0(var_0_4, "penny_castle_eruptions", nil, nil, nil, var_0_5.penny_castle_eruptions, var_0_6.penny_castle_eruptions)
var_0_0(var_0_4, "penny_castle_no_kill", nil, nil, nil, var_0_5.penny_castle_no_kill, var_0_6.penny_castle_no_kill)

local var_0_7 = {
	LevelSettings.dlc_portals,
	LevelSettings.dlc_bastion,
	LevelSettings.dlc_castle
}
local var_0_8 = {
	LevelSettings.dlc_castle
}
local var_0_9 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for iter_0_0 = 1, #var_0_9 do
	local var_0_10 = var_0_9[iter_0_0]
	local var_0_11 = DifficultyMapping[var_0_10]
	local var_0_12 = "penny_complete_" .. var_0_11

	var_0_1(var_0_4, var_0_12, var_0_7, DifficultySettings[var_0_10].rank, nil, nil, var_0_5[var_0_12], var_0_6[var_0_12])

	local var_0_13 = "penny_complete_castle_" .. var_0_11

	var_0_1(var_0_4, var_0_13, var_0_8, DifficultySettings[var_0_10].rank, nil, nil, var_0_5[var_0_13], var_0_6[var_0_13])
end

var_0_2(var_0_4, "penny_complete_castle", {
	"penny_castle_chalice",
	"penny_castle_skull",
	"penny_castle_flask",
	"penny_castle_eruptions",
	"penny_castle_no_kill"
})
