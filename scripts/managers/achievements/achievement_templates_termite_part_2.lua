-- chunkname: @scripts/managers/achievements/achievement_templates_termite_part_2.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	termite2_mushroom_challenge = 126,
	termite2_water_challenge = 127,
	termite2_complete_legend = 125
}
local tbl_2 = {
	termite2_mushroom_challenge = "094"
}
local tbl_3 = {
	LevelSettings.dlc_termite_2
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
	local str = "termite2_complete_" .. tbl_5[var_0_12]
	local str_2 = "achv_termite2_complete_" .. tbl_5[var_0_12] .. "_icon"

	tbl_6[i] = str

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_12].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.termite2_mushroom_challenge = {
	name = "achv_termite2_mushrooms_name",
	display_completion_ui = true,
	icon = "achv_termite2_mushrooms_icon",
	desc = "achv_termite2_mushrooms_desc",
	events = {
		"termite2_mushroom_challenge"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "termite2_mushroom_challenge") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		self:increment_stat(arg_2_1, "termite2_mushroom_challenge")
	end
}
achievements.termite2_water_challenge = {
	name = "achv_termite2_water_name",
	display_completion_ui = true,
	icon = "achv_termite2_water_icon",
	desc = "achv_termite2_water_desc",
	events = {
		"register_damage_taken",
		"register_completed_level"
	},
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "termite2_water_challenge") >= 1
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local level_key = Managers.state.game_mode:level_key()

		if not (not level_key and level_key == "dlc_termite_2") then
			return
		end

		if arg_4_3 == "register_damage_taken" then
			local var_4_1 = arg_4_4[1]
			local owner = Managers.player:owner(var_4_1)

			if owner ~= Managers.player:local_player() then
				return
			end

			if not (not owner and owner.player_unit == var_4_1) then
				return
			end

			local var_4_3 = arg_4_4[2]
			local flag = not var_4_3 and var_4_3[DamageDataIndex.ATTACKER]

			if not Unit.alive(flag) then
				return
			end

			if not Unit.get_data(flag, "is_termite_water") then
				return
			end

			arg_4_2.damaged_by_termite_water = true
		elseif not (arg_4_3 ~= "register_completed_level" or arg_4_2.damaged_by_termite_water) then
			self:increment_stat(arg_4_1, "termite2_water_challenge")
		end
	end
}

local num = 5
local num_2 = 4

achievements.termite2_timer_challenge = {
	name = "achv_termite2_timer_name",
	display_completion_ui = true,
	icon = "achv_termite2_timer_icon",
	desc = function ()
		-- function 5
		return string.format(Localize("achv_termite2_timer_desc"), num, num_2)
	end,
	events = {
		"termite2_timer_challenge"
	},
	completed = function (self, arg_6_1, arg_6_2)
		-- function 6
		return self:get_persistent_stat(arg_6_1, "termite2_timer_challenge") >= 1
	end,
	on_event = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		self:increment_stat(arg_7_1, "termite2_timer_challenge")
	end
}
termite2_all_challenges = table.clone(tbl_6)

table.remove(termite2_all_challenges, #termite2_all_challenges)

termite2_all_challenges[#termite2_all_challenges + 1] = "termite2_mushroom_challenge"
termite2_all_challenges[#termite2_all_challenges + 1] = "termite2_water_challenge"

add_meta_challenge(achievements, "termite2_all_challenges", termite2_all_challenges, "achv_termite2_all_challenges_icon", nil, nil, nil)
add_console_achievements(tbl, tbl_2)
