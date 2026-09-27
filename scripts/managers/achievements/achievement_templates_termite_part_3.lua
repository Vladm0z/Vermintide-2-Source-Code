-- chunkname: @scripts/managers/achievements/achievement_templates_termite_part_3.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	termite3_collectible_challenge = 129,
	termite3_complete_legend = 128,
	termite3_generator_challenge = 130
}
local tbl_2 = {
	termite3_generator_challenge = "095"
}
local tbl_3 = {
	LevelSettings.dlc_termite_3
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
	local str = "termite3_complete_" .. tbl_5[var_0_12]
	local str_2 = "achv_termite3_complete_" .. tbl_5[var_0_12] .. "_icon"

	tbl_6[i] = str

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_12].rank, str_2, nil, tbl[str], tbl_2[str])
end

local num = 20

achievements.termite3_collectible_challenge = {
	name = "achv_termite3_collectible_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_collectibles",
	desc = function ()
		-- function 1
		return string.format(Localize("achv_termite3_collectible_challenge_desc"), num)
	end,
	events = {
		"termite3_collectible_challenge"
	},
	completed = function (self, arg_2_1, arg_2_2)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "termite3_collectible_challenge") >= 1
	end,
	on_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		self:increment_stat(arg_3_1, "termite3_collectible_challenge")
	end
}
achievements.termite3_searchlight_challenge = {
	name = "achv_termite3_searchlight_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_searchlight_icon",
	desc = "achv_termite3_searchlight_challenge_desc",
	events = {
		"termite3_searchlight_challenge"
	},
	completed = function (self, arg_4_1, arg_4_2)
		-- function 4
		return self:get_persistent_stat(arg_4_1, "termite3_searchlight_challenge") >= 1
	end,
	on_event = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		self:increment_stat(arg_5_1, "termite3_searchlight_challenge")
	end
}

local num_2 = 4

achievements.termite3_generator_challenge = {
	name = "achv_termite3_generator_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_generator",
	desc = function ()
		-- function 6
		return string.format(Localize("achv_termite3_generator_challenge_desc"), num_2)
	end,
	events = {
		"termite3_generator_challenge"
	},
	completed = function (self, arg_7_1, arg_7_2)
		-- function 7
		return self:get_persistent_stat(arg_7_1, "termite3_generator_challenge") >= 1
	end,
	on_event = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		self:increment_stat(arg_8_1, "termite3_generator_challenge")
	end
}

local num_3 = 3

achievements.termite3_portal_challenge = {
	name = "achv_termite3_portal_challenge_name",
	display_completion_ui = true,
	icon = "achv_termite3_portal_icon",
	desc = function ()
		-- function 9
		return string.format(Localize("achv_termite3_portal_challenge_desc"), num_3)
	end,
	events = {
		"termite3_portal_challenge"
	},
	completed = function (self, arg_10_1, arg_10_2)
		-- function 10
		return self:get_persistent_stat(arg_10_1, "termite3_portal_challenge") >= 1
	end,
	on_event = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		self:increment_stat(arg_11_1, "termite3_portal_challenge")
	end
}
termite3_all_challenges = table.clone(tbl_6)

table.remove(termite3_all_challenges, #termite3_all_challenges)

termite3_all_challenges[#termite3_all_challenges + 1] = "termite3_collectible_challenge"
termite3_all_challenges[#termite3_all_challenges + 1] = "termite3_searchlight_challenge"
termite3_all_challenges[#termite3_all_challenges + 1] = "termite3_generator_challenge"

add_meta_challenge(achievements, "termite3_all_challenges", termite3_all_challenges, "achv_termite3_complete_all_icon", nil, nil, nil)
add_console_achievements(tbl, tbl_2)
