-- chunkname: @scripts/managers/achievements/achievement_templates_penny_part_1.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local tbl = {
	penny_portals_heads = 86,
	penny_portals_vintage = 87
}
local tbl_2 = {
	penny_portals_vintage = "081"
}

add_event_challenge(achievements, "penny_portals_portal", nil, nil, nil, tbl.penny_portals_portal, tbl_2.penny_portals_portal)
add_event_challenge(achievements, "penny_portals_heads", nil, nil, nil, tbl.penny_portals_heads, tbl_2.penny_portals_heads)
add_event_challenge(achievements, "penny_portals_cleanser", nil, nil, nil, tbl.penny_portals_cleanser, tbl_2.penny_portals_cleanser)
add_event_challenge(achievements, "penny_portals_vintage", nil, nil, nil, tbl.penny_portals_vintage, tbl_2.penny_portals_vintage)
add_event_challenge(achievements, "penny_portals_hideout", nil, nil, nil, tbl.penny_portals_hideout, tbl_2.penny_portals_hideout)

local tbl_3 = {
	LevelSettings.dlc_portals
}
local tbl_4 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for i = 1, #tbl_4 do
	local var_0_9 = tbl_4[i]
	local var_0_10 = DifficultyMapping[var_0_9]
	local str = "penny_complete_portals_" .. var_0_10

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_9].rank, nil, nil, tbl[str], tbl_2[str])
end

add_meta_challenge(achievements, "penny_complete_portals", {
	"penny_portals_portal",
	"penny_portals_heads",
	"penny_portals_cleanser",
	"penny_portals_vintage",
	"penny_portals_hideout"
})
