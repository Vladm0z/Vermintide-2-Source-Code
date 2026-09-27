-- chunkname: @scripts/managers/achievements/achievement_templates_penny_part_3.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local tbl = {
	penny_complete_veteran = 83,
	penny_castle_eruptions = 90,
	penny_complete_recruit = 82,
	penny_complete_legend = 85,
	penny_complete_champion = 84,
	penny_castle_no_kill = 91
}
local tbl_2 = {
	penny_castle_eruptions = "083"
}

add_event_challenge(achievements, "penny_castle_chalice", nil, nil, nil, tbl.penny_castle_chalice, tbl_2.penny_castle_chalice)
add_event_challenge(achievements, "penny_castle_skull", nil, nil, nil, tbl.penny_castle_skull, tbl_2.penny_castle_skull)
add_event_challenge(achievements, "penny_castle_flask", nil, nil, nil, tbl.penny_castle_flask, tbl_2.penny_castle_flask)
add_event_challenge(achievements, "penny_castle_eruptions", nil, nil, nil, tbl.penny_castle_eruptions, tbl_2.penny_castle_eruptions)
add_event_challenge(achievements, "penny_castle_no_kill", nil, nil, nil, tbl.penny_castle_no_kill, tbl_2.penny_castle_no_kill)

local tbl_3 = {
	LevelSettings.dlc_portals,
	LevelSettings.dlc_bastion,
	LevelSettings.dlc_castle
}
local tbl_4 = {
	LevelSettings.dlc_castle
}
local tbl_5 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for i = 1, #tbl_5 do
	local var_0_10 = tbl_5[i]
	local var_0_11 = DifficultyMapping[var_0_10]
	local str = "penny_complete_" .. var_0_11

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_10].rank, nil, nil, tbl[str], tbl_2[str])

	local str_2 = "penny_complete_castle_" .. var_0_11

	add_levels_complete_challenge(achievements, str_2, tbl_4, DifficultySettings[var_0_10].rank, nil, nil, tbl[str_2], tbl_2[str_2])
end

add_meta_challenge(achievements, "penny_complete_castle", {
	"penny_castle_chalice",
	"penny_castle_skull",
	"penny_castle_flask",
	"penny_castle_eruptions",
	"penny_castle_no_kill"
})
