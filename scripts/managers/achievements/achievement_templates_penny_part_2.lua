-- chunkname: @scripts/managers/achievements/achievement_templates_penny_part_2.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local tbl = {
	penny_bastion_sprinter = 89,
	penny_bastion_torch = 88
}
local tbl_2 = {
	penny_bastion_sprinter = "082"
}
local num = 50

add_event_challenge(achievements, "penny_portals_grapes", nil, nil, nil, tbl.penny_portals_grapes, tbl_2.penny_portals_grapes)
add_event_challenge(achievements, "penny_portals_coop", nil, nil, nil, tbl.penny_portals_coop, tbl_2.penny_portals_coop)
add_event_challenge(achievements, "penny_portals_templerun", nil, nil, nil, tbl.penny_portals_templerun, tbl_2.penny_portals_templerun)
add_event_challenge(achievements, "penny_portals_careful", nil, nil, nil, tbl.penny_portals_careful, tbl_2.penny_portals_careful)
add_event_challenge(achievements, "penny_bastion_journal", nil, nil, nil, tbl.penny_bastion_journal, tbl_2.penny_bastion_journal)
add_event_challenge(achievements, "penny_bastion_overstay", nil, nil, nil, tbl.penny_bastion_overstay, tbl_2.penny_bastion_overstay)
add_event_challenge(achievements, "penny_bastion_sprinter", nil, {
	num
}, nil, tbl.penny_bastion_sprinter, tbl_2.penny_bastion_sprinter)
add_event_challenge(achievements, "penny_bastion_yorick", nil, nil, nil, tbl.penny_bastion_yorick, tbl_2.penny_bastion_yorick)
add_event_challenge(achievements, "penny_bastion_torch", nil, nil, nil, tbl.penny_bastion_torch, tbl_2.penny_bastion_torch)

local tbl_3 = {
	LevelSettings.dlc_bastion
}
local tbl_4 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for i = 1, #tbl_4 do
	local var_0_10 = tbl_4[i]
	local var_0_11 = DifficultyMapping[var_0_10]
	local str = "penny_complete_bastion_" .. var_0_11

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_10].rank, nil, nil, tbl[str], tbl_2[str])
end

add_meta_challenge(achievements, "penny_complete_bastion", {
	"penny_bastion_journal",
	"penny_bastion_overstay",
	"penny_bastion_sprinter",
	"penny_bastion_yorick",
	"penny_bastion_torch"
})
