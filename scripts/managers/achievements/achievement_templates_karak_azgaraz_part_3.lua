-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_3.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplates.achievements
local var_0_4 = AchievementTemplateHelper.add_console_achievements
local var_0_5 = {
	karak_azgaraz_complete_dlc_dwarf_beacons_legend = 121,
	dwarf_big_jump = 118,
	dwarf_pressure_pad = 114,
	dwarf_crows = 115
}
local var_0_6 = {
	dwarf_crows = "091"
}
local var_0_7 = {}
local var_0_8 = {
	LevelSettings.dlc_dwarf_beacons
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

for iter_0_0 = 1, #var_0_9 do
	local var_0_11 = var_0_9[iter_0_0]
	local var_0_12 = "karak_azgaraz_complete_dlc_dwarf_beacons_" .. var_0_10[var_0_11]
	local var_0_13 = "achievement_beacons_" .. var_0_10[var_0_11]

	var_0_7[iter_0_0] = var_0_12

	var_0_1(var_0_3, var_0_12, var_0_8, DifficultySettings[var_0_11].rank, var_0_13, nil, var_0_5[var_0_12], var_0_6[var_0_12])
end

var_0_3.dwarf_pressure_pad = {
	name = "achv_dwarf_pressure_pad_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_pressure_pad",
	desc = "achv_dwarf_pressure_pad_desc",
	events = {
		"dwarf_pressure_pad"
	},
	completed = function(arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "dwarf_pressure_pad") >= 1
	end,
	on_event = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = arg_2_4[1]
		local var_2_1 = arg_2_4[2]
		local var_2_2 = arg_2_4[3]

		if not var_2_2 and (Managers.player:unit_owner(var_2_0).bot_player or arg_2_2.challenge_over) then
			return
		end

		if not arg_2_2.num_on_pad then
			arg_2_2.num_on_pad = 0
		end

		if var_2_2 and arg_2_2.num_on_pad and arg_2_2.num_on_pad >= 1 then
			arg_2_0:increment_stat(arg_2_1, "dwarf_pressure_pad")

			arg_2_2.challenge_over = true
		elseif var_2_1 then
			arg_2_2.num_on_pad = arg_2_2.num_on_pad + 1
		else
			arg_2_2.num_on_pad = arg_2_2.num_on_pad - 1

			if arg_2_2.num_on_pad < 1 then
				arg_2_2.challenge_over = true
			end
		end
	end
}
var_0_3.dwarf_big_jump = {
	name = "achv_dwarf_big_jump_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_big_jump",
	desc = "achv_dwarf_big_jump_desc",
	events = {
		"dwarf_big_jump"
	},
	completed = function(arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "dwarf_big_jump") >= 1
	end,
	on_event = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = arg_4_4[1]
		local var_4_1 = Managers.time:time("game")

		if var_4_0 and arg_4_2.exit_t and var_4_1 < arg_4_2.exit_t then
			arg_4_0:increment_stat(arg_4_1, "dwarf_big_jump")
		elseif not var_4_0 then
			arg_4_2.exit_t = var_4_1 + 4
		end
	end
}
var_0_3.dwarf_crows = {
	name = "achv_dwarf_crows_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_crows",
	desc = "achv_dwarf_crows_desc",
	events = {
		"dwarf_crows"
	},
	completed = function(arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "dwarf_crows") >= 1
	end,
	on_event = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		arg_6_0:increment_stat(arg_6_1, "dwarf_crows")
	end
}
var_0_3.dwarf_speedrun = {
	name = "achv_dwarf_speedrun_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_speedrun",
	desc = "achv_dwarf_speedrun_desc",
	events = {
		"dwarf_speedrun_start",
		"dwarf_speedrun_end"
	},
	completed = function(arg_7_0, arg_7_1, arg_7_2)
		return arg_7_0:get_persistent_stat(arg_7_1, "dwarf_speedrun") >= 1
	end,
	on_event = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		if arg_8_3 == "dwarf_speedrun_start" then
			arg_8_2.started = true

			return
		end

		if arg_8_3 == "dwarf_speedrun_end" and arg_8_2.started then
			arg_8_0:increment_stat(arg_8_1, "dwarf_speedrun")
		end
	end
}
beacons_all_challenges = table.clone(var_0_7)

table.remove(beacons_all_challenges, #beacons_all_challenges)

beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_pressure_pad"
beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_big_jump"
beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_crows"
beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_speedrun"

var_0_2(var_0_3, "beacons_all_challenges", beacons_all_challenges, "achievement_beacons_meta", nil, var_0_5[name], var_0_6[name])
var_0_4(var_0_5, var_0_6)
