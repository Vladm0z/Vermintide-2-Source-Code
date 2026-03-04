-- chunkname: @scripts/managers/achievements/achievement_templates_penny_part_2.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = {
	penny_bastion_sprinter = 89,
	penny_bastion_torch = 88
}
local var_0_6 = {
	penny_bastion_sprinter = "082"
}
local var_0_7 = 50

var_0_0(var_0_4, "penny_portals_grapes", nil, nil, nil, var_0_5.penny_portals_grapes, var_0_6.penny_portals_grapes)
var_0_0(var_0_4, "penny_portals_coop", nil, nil, nil, var_0_5.penny_portals_coop, var_0_6.penny_portals_coop)
var_0_0(var_0_4, "penny_portals_templerun", nil, nil, nil, var_0_5.penny_portals_templerun, var_0_6.penny_portals_templerun)
var_0_0(var_0_4, "penny_portals_careful", nil, nil, nil, var_0_5.penny_portals_careful, var_0_6.penny_portals_careful)
var_0_0(var_0_4, "penny_bastion_journal", nil, nil, nil, var_0_5.penny_bastion_journal, var_0_6.penny_bastion_journal)
var_0_0(var_0_4, "penny_bastion_overstay", nil, nil, nil, var_0_5.penny_bastion_overstay, var_0_6.penny_bastion_overstay)
var_0_0(var_0_4, "penny_bastion_sprinter", nil, {
	var_0_7
}, nil, var_0_5.penny_bastion_sprinter, var_0_6.penny_bastion_sprinter)
var_0_0(var_0_4, "penny_bastion_yorick", nil, nil, nil, var_0_5.penny_bastion_yorick, var_0_6.penny_bastion_yorick)
var_0_0(var_0_4, "penny_bastion_torch", nil, nil, nil, var_0_5.penny_bastion_torch, var_0_6.penny_bastion_torch)

local var_0_8 = {
	LevelSettings.dlc_bastion
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
	local var_0_12 = "penny_complete_bastion_" .. var_0_11

	var_0_1(var_0_4, var_0_12, var_0_8, DifficultySettings[var_0_10].rank, nil, nil, var_0_5[var_0_12], var_0_6[var_0_12])
end

var_0_2(var_0_4, "penny_complete_bastion", {
	"penny_bastion_journal",
	"penny_bastion_overstay",
	"penny_bastion_sprinter",
	"penny_bastion_yorick",
	"penny_bastion_torch"
})
