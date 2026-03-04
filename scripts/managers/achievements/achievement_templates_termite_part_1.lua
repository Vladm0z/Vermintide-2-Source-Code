-- chunkname: @scripts/managers/achievements/achievement_templates_termite_part_1.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = AchievementTemplateHelper.add_console_achievements
local var_0_6 = {
	termite1_complete_legend = 122,
	termite1_waystone_timer_challenge_easy = 131,
	termite1_towers_challenge = 123,
	termite1_bell_challenge = 124
}
local var_0_7 = {
	termite1_bell_challenge = "093"
}
local var_0_8 = {
	LevelSettings.dlc_termite_1
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
	local var_0_13 = "termite1_complete_" .. var_0_10[var_0_12]
	local var_0_14 = "achv_termite1_complete_" .. var_0_10[var_0_12] .. "_icon"

	var_0_11[iter_0_0] = var_0_13

	var_0_1(var_0_4, var_0_13, var_0_8, DifficultySettings[var_0_12].rank, var_0_14, nil, var_0_6[var_0_13], var_0_7[var_0_13])
end

var_0_4.termite1_skaven_markings_challenge = {
	name = "achv_termite1_skaven_markings_name",
	display_completion_ui = true,
	icon = "achv_termite1_skaven_markings_icon",
	desc = "achv_termite1_skaven_markings_desc",
	events = {
		"termite1_skaven_markings_challenge"
	},
	completed = function (arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "termite1_skaven_markings_challenge") >= 1
	end,
	on_event = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		arg_2_0:increment_stat(arg_2_1, "termite1_skaven_markings_challenge")
	end
}
var_0_4.termite1_bell_challenge = {
	name = "achv_termite1_bell_name",
	display_completion_ui = true,
	icon = "achv_termite1_bell_icon",
	desc = "achv_termite1_bell_desc",
	events = {
		"termite1_bell_challenge"
	},
	completed = function (arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "termite1_bell_challenge") >= 1
	end,
	on_event = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		arg_4_0:increment_stat(arg_4_1, "termite1_bell_challenge")
	end
}
var_0_4.termite1_towers_challenge = {
	name = "achv_termite1_towers_name",
	display_completion_ui = true,
	icon = "achv_termite1_towers_icon",
	desc = "achv_termite1_towers_desc",
	events = {
		"termite1_towers_challenge"
	},
	completed = function (arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "termite1_towers_challenge") >= 1
	end,
	on_event = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		arg_6_0:increment_stat(arg_6_1, "termite1_towers_challenge")
	end
}

local var_0_15 = 180
local var_0_16 = 90

var_0_4.termite1_waystone_timer_challenge_easy = {
	name = "achv_termite1_waystone_timer_easy_name",
	display_completion_ui = true,
	icon = "achv_termite1_waystone_timer_easy_icon",
	desc = function ()
		return string.format(Localize("achv_termite1_waystone_timer_easy_desc"), var_0_15)
	end,
	events = {
		"termite1_waystone_timer_challenge_easy"
	},
	completed = function (arg_8_0, arg_8_1, arg_8_2)
		return arg_8_0:get_persistent_stat(arg_8_1, "termite1_waystone_timer_challenge_easy") >= 1
	end,
	on_event = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		arg_9_0:increment_stat(arg_9_1, "termite1_waystone_timer_challenge_easy")
	end
}
var_0_4.termite1_waystone_timer_challenge_hard = {
	name = "achv_termite1_waystone_timer_hard_name",
	display_completion_ui = true,
	icon = "achv_termite1_waystone_timer_hard_icon",
	desc = function ()
		return string.format(Localize("achv_termite1_waystone_timer_hard_desc"), var_0_16)
	end,
	events = {
		"termite1_waystone_timer_challenge_hard"
	},
	completed = function (arg_11_0, arg_11_1, arg_11_2)
		return arg_11_0:get_persistent_stat(arg_11_1, "termite1_waystone_timer_challenge_hard") >= 1
	end,
	on_event = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		arg_12_0:increment_stat(arg_12_1, "termite1_waystone_timer_challenge_hard")
	end
}
termite1_all_challenges = table.clone(var_0_11)

table.remove(termite1_all_challenges, #termite1_all_challenges)

termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_skaven_markings_challenge"
termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_bell_challenge"
termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_towers_challenge"
termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_waystone_timer_challenge_easy"

var_0_2(var_0_4, "termite1_all_challenges", termite1_all_challenges, "achv_termite1_complete_all_icon", nil, nil, nil)
var_0_5(var_0_6, var_0_7)
