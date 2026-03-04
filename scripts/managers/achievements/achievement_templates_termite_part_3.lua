-- chunkname: @scripts/managers/achievements/achievement_templates_termite_part_3.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = AchievementTemplateHelper.add_console_achievements
local var_0_6 = {
	termite3_collectible_challenge = 129,
	termite3_complete_legend = 128,
	termite3_generator_challenge = 130
}
local var_0_7 = {
	termite3_generator_challenge = "095"
}
local var_0_8 = {
	LevelSettings.dlc_termite_3
}
local var_0_9 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_10 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}
local var_0_11 = {}

for iter_0_0 = 1, #var_0_9 do
	local var_0_12 = var_0_9[iter_0_0]
	local var_0_13 = "termite3_complete_" .. var_0_10[var_0_12]
	local var_0_14 = "achv_termite3_complete_" .. var_0_10[var_0_12] .. "_icon"

	var_0_11[iter_0_0] = var_0_13

	var_0_1(var_0_4, var_0_13, var_0_8, DifficultySettings[var_0_12].rank, var_0_14, nil, var_0_6[var_0_13], var_0_7[var_0_13])
end

local var_0_15 = 20

var_0_4.termite3_collectible_challenge = {
	name = "achv_termite3_collectible_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_collectibles",
	desc = function ()
		return string.format(Localize("achv_termite3_collectible_challenge_desc"), var_0_15)
	end,
	events = {
		"termite3_collectible_challenge"
	},
	completed = function (arg_2_0, arg_2_1, arg_2_2)
		return arg_2_0:get_persistent_stat(arg_2_1, "termite3_collectible_challenge") >= 1
	end,
	on_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		arg_3_0:increment_stat(arg_3_1, "termite3_collectible_challenge")
	end
}
var_0_4.termite3_searchlight_challenge = {
	name = "achv_termite3_searchlight_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_searchlight_icon",
	desc = "achv_termite3_searchlight_challenge_desc",
	events = {
		"termite3_searchlight_challenge"
	},
	completed = function (arg_4_0, arg_4_1, arg_4_2)
		return arg_4_0:get_persistent_stat(arg_4_1, "termite3_searchlight_challenge") >= 1
	end,
	on_event = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		arg_5_0:increment_stat(arg_5_1, "termite3_searchlight_challenge")
	end
}

local var_0_16 = 4

var_0_4.termite3_generator_challenge = {
	name = "achv_termite3_generator_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_generator",
	desc = function ()
		return string.format(Localize("achv_termite3_generator_challenge_desc"), var_0_16)
	end,
	events = {
		"termite3_generator_challenge"
	},
	completed = function (arg_7_0, arg_7_1, arg_7_2)
		return arg_7_0:get_persistent_stat(arg_7_1, "termite3_generator_challenge") >= 1
	end,
	on_event = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		arg_8_0:increment_stat(arg_8_1, "termite3_generator_challenge")
	end
}

local var_0_17 = 3

var_0_4.termite3_portal_challenge = {
	name = "achv_termite3_portal_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_portal_icon",
	desc = function ()
		return string.format(Localize("achv_termite3_portal_challenge_desc"), var_0_17)
	end,
	events = {
		"termite3_portal_challenge"
	},
	completed = function (arg_10_0, arg_10_1, arg_10_2)
		return arg_10_0:get_persistent_stat(arg_10_1, "termite3_portal_challenge") >= 1
	end,
	on_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		arg_11_0:increment_stat(arg_11_1, "termite3_portal_challenge")
	end
}
termite3_all_challenges = table.clone(var_0_11)

table.remove(termite3_all_challenges, #termite3_all_challenges)

termite3_all_challenges[#termite3_all_challenges + 1] = "termite3_collectible_challenge"
termite3_all_challenges[#termite3_all_challenges + 1] = "termite3_searchlight_challenge"
termite3_all_challenges[#termite3_all_challenges + 1] = "termite3_generator_challenge"

var_0_2(var_0_4, "termite3_all_challenges", termite3_all_challenges, "achv_termite3_complete_all_icon", nil, nil, nil)
var_0_5(var_0_6, var_0_7)
