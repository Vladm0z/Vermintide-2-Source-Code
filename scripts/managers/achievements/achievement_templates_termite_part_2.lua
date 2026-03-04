-- chunkname: @scripts/managers/achievements/achievement_templates_termite_part_2.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = AchievementTemplateHelper.add_console_achievements
local var_0_6 = {
	termite2_mushroom_challenge = 126,
	termite2_water_challenge = 127,
	termite2_complete_legend = 125
}
local var_0_7 = {
	termite2_mushroom_challenge = "094"
}
local var_0_8 = {
	LevelSettings.dlc_termite_2
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
	local var_0_13 = "termite2_complete_" .. var_0_10[var_0_12]
	local var_0_14 = "achv_termite2_complete_" .. var_0_10[var_0_12] .. "_icon"

	var_0_11[iter_0_0] = var_0_13

	var_0_1(var_0_4, var_0_13, var_0_8, DifficultySettings[var_0_12].rank, var_0_14, nil, var_0_6[var_0_13], var_0_7[var_0_13])
end

var_0_4.termite2_mushroom_challenge = {
	name = "achv_termite2_mushrooms_name",
	display_completion_ui = true,
	icon = "achv_termite2_mushrooms_icon",
	desc = "achv_termite2_mushrooms_desc",
	events = {
		"termite2_mushroom_challenge"
	},
	completed = function (arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "termite2_mushroom_challenge") >= 1
	end,
	on_event = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		arg_2_0:increment_stat(arg_2_1, "termite2_mushroom_challenge")
	end
}
var_0_4.termite2_water_challenge = {
	name = "achv_termite2_water_name",
	display_completion_ui = true,
	icon = "achv_termite2_water_icon",
	desc = "achv_termite2_water_desc",
	events = {
		"register_damage_taken",
		"register_completed_level"
	},
	completed = function (arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "termite2_water_challenge") >= 1
	end,
	on_event = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = Managers.state.game_mode:level_key()

		if not var_4_0 or var_4_0 ~= "dlc_termite_2" then
			return
		end

		if arg_4_3 == "register_damage_taken" then
			local var_4_1 = arg_4_4[1]
			local var_4_2 = Managers.player:owner(var_4_1)

			if var_4_2 ~= Managers.player:local_player() then
				return
			end

			if not var_4_2 or var_4_2.player_unit ~= var_4_1 then
				return
			end

			local var_4_3 = arg_4_4[2]
			local var_4_4 = var_4_3 and var_4_3[DamageDataIndex.ATTACKER]

			if not Unit.alive(var_4_4) then
				return
			end

			if not Unit.get_data(var_4_4, "is_termite_water") then
				return
			end

			arg_4_2.damaged_by_termite_water = true
		elseif arg_4_3 == "register_completed_level" and not arg_4_2.damaged_by_termite_water then
			arg_4_0:increment_stat(arg_4_1, "termite2_water_challenge")
		end
	end
}

local var_0_15 = 5
local var_0_16 = 4

var_0_4.termite2_timer_challenge = {
	name = "achv_termite2_timer_name",
	display_completion_ui = true,
	icon = "achv_termite2_timer_icon",
	desc = function ()
		return string.format(Localize("achv_termite2_timer_desc"), var_0_15, var_0_16)
	end,
	events = {
		"termite2_timer_challenge"
	},
	completed = function (arg_6_0, arg_6_1, arg_6_2)
		return arg_6_0:get_persistent_stat(arg_6_1, "termite2_timer_challenge") >= 1
	end,
	on_event = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		arg_7_0:increment_stat(arg_7_1, "termite2_timer_challenge")
	end
}
termite2_all_challenges = table.clone(var_0_11)

table.remove(termite2_all_challenges, #termite2_all_challenges)

termite2_all_challenges[#termite2_all_challenges + 1] = "termite2_mushroom_challenge"
termite2_all_challenges[#termite2_all_challenges + 1] = "termite2_water_challenge"

var_0_2(var_0_4, "termite2_all_challenges", termite2_all_challenges, "achv_termite2_all_challenges_icon", nil, nil, nil)
var_0_5(var_0_6, var_0_7)
