-- chunkname: @scripts/managers/achievements/achievement_templates_termite_part_1.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	termite1_complete_legend = 122,
	termite1_waystone_timer_challenge_easy = 131,
	termite1_towers_challenge = 123,
	termite1_bell_challenge = 124
}
local tbl_2 = {
	termite1_bell_challenge = "093"
}
local tbl_3 = {
	LevelSettings.dlc_termite_1
}
local tbl_4 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_5 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}
local tbl_6 = {}

for i = 1, #tbl_4 do
	local var_0_12 = tbl_4[i]
	local str = "termite1_complete_" .. tbl_5[var_0_12]
	local str_2 = "achv_termite1_complete_" .. tbl_5[var_0_12] .. "_icon"

	tbl_6[i] = str

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_12].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.termite1_skaven_markings_challenge = {
	name = "achv_termite1_skaven_markings_name",
	display_completion_ui = true,
	icon = "achv_termite1_skaven_markings_icon",
	desc = "achv_termite1_skaven_markings_desc",
	events = {
		"termite1_skaven_markings_challenge"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "termite1_skaven_markings_challenge") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		self:increment_stat(arg_2_1, "termite1_skaven_markings_challenge")
	end
}
achievements.termite1_bell_challenge = {
	name = "achv_termite1_bell_name",
	display_completion_ui = true,
	icon = "achv_termite1_bell_icon",
	desc = "achv_termite1_bell_desc",
	events = {
		"termite1_bell_challenge"
	},
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "termite1_bell_challenge") >= 1
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		self:increment_stat(arg_4_1, "termite1_bell_challenge")
	end
}
achievements.termite1_towers_challenge = {
	name = "achv_termite1_towers_name",
	display_completion_ui = true,
	icon = "achv_termite1_towers_icon",
	desc = "achv_termite1_towers_desc",
	events = {
		"termite1_towers_challenge"
	},
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "termite1_towers_challenge") >= 1
	end,
	on_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		self:increment_stat(arg_6_1, "termite1_towers_challenge")
	end
}

local num = 180
local num_2 = 90

achievements.termite1_waystone_timer_challenge_easy = {
	name = "achv_termite1_waystone_timer_easy_name",
	display_completion_ui = true,
	icon = "achv_termite1_waystone_timer_easy_icon",
	desc = function ()
		-- function 7
		return string.format(Localize("achv_termite1_waystone_timer_easy_desc"), num)
	end,
	events = {
		"termite1_waystone_timer_challenge_easy"
	},
	completed = function (self, arg_8_1, arg_8_2)
		-- function 8
		return self:get_persistent_stat(arg_8_1, "termite1_waystone_timer_challenge_easy") >= 1
	end,
	on_event = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		self:increment_stat(arg_9_1, "termite1_waystone_timer_challenge_easy")
	end
}
achievements.termite1_waystone_timer_challenge_hard = {
	name = "achv_termite1_waystone_timer_hard_name",
	display_completion_ui = true,
	icon = "achv_termite1_waystone_timer_hard_icon",
	desc = function ()
		-- function 10
		return string.format(Localize("achv_termite1_waystone_timer_hard_desc"), num_2)
	end,
	events = {
		"termite1_waystone_timer_challenge_hard"
	},
	completed = function (self, arg_11_1, arg_11_2)
		-- function 11
		return self:get_persistent_stat(arg_11_1, "termite1_waystone_timer_challenge_hard") >= 1
	end,
	on_event = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		self:increment_stat(arg_12_1, "termite1_waystone_timer_challenge_hard")
	end
}
termite1_all_challenges = table.clone(tbl_6)

table.remove(termite1_all_challenges, #termite1_all_challenges)

termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_skaven_markings_challenge"
termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_bell_challenge"
termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_towers_challenge"
termite1_all_challenges[#termite1_all_challenges + 1] = "termite1_waystone_timer_challenge_easy"

add_meta_challenge(achievements, "termite1_all_challenges", termite1_all_challenges, "achv_termite1_complete_all_icon", nil, nil, nil)
add_console_achievements(tbl, tbl_2)
