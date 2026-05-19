-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_4.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplates.achievements
local var_0_4 = AchievementTemplateHelper.add_console_achievements
local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = {}
local var_0_8 = {
	LevelSettings.dlc_dwarf_whaling
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
	local var_0_12 = "karak_azgaraz_complete_dlc_dwarf_whaling_" .. var_0_10[var_0_11]
	local var_0_13 = "achievement_dwarf_" .. var_0_10[var_0_11]

	var_0_7[iter_0_0] = var_0_12

	var_0_1(var_0_3, var_0_12, var_0_8, DifficultySettings[var_0_11].rank, var_0_13, nil, var_0_5[var_0_12], var_0_6[var_0_12])
end

var_0_3.dwarf_feculent_buboes = {
	name = "achv_dwarf_feculent_buboes_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_feculent_buboes",
	desc = "achv_dwarf_feculent_buboes_desc",
	events = {
		"dwarf_feculent_buboes"
	},
	completed = function(arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "dwarf_feculent_buboes") >= 1
	end,
	on_event = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		arg_2_0:increment_stat(arg_2_1, "dwarf_feculent_buboes")
	end
}
var_0_3.dwarf_statue_emote = {
	name = "achv_dwarf_statue_emote_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_statue_emote",
	desc = "achv_dwarf_statue_emote_desc",
	events = {
		"dwarf_statue_emote"
	},
	completed = function(arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "dwarf_statue_emote") >= 1
	end,
	on_event = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		if not arg_4_4[1] then
			arg_4_2.end_t = nil

			return
		end

		local var_4_0 = Managers.player:local_player()
		local var_4_1 = var_4_0 and var_4_0.player_unit

		if not var_4_1 then
			return
		end

		local var_4_2 = ScriptUnit.extension(var_4_1, "character_state_machine_system").state_machine
		local var_4_3 = var_4_2 and var_4_2.state_current

		if not (var_4_3 and var_4_3.name == "emote") then
			arg_4_2.end_t = nil

			return
		end

		arg_4_0:increment_stat(arg_4_1, "dwarf_statue_emote")
	end
}
var_0_3.dwarf_go_fish = {
	name = "achv_dwarf_go_fish_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_go_fish",
	desc = "achv_dwarf_go_fish_desc",
	events = {
		"dwarf_go_fish"
	},
	completed = function(arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "dwarf_go_fish") >= 1
	end,
	on_event = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		arg_6_0:increment_stat(arg_6_1, "dwarf_go_fish")
	end
}

local var_0_14 = 75

var_0_3.dwarf_barrel_kill = {
	name = "achv_dwarf_barrel_kill_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_barrel_kill",
	desc = "achv_dwarf_barrel_kill_desc",
	events = {
		"register_kill"
	},
	completed = function(arg_7_0, arg_7_1, arg_7_2)
		return arg_7_0:get_persistent_stat(arg_7_1, "dwarf_barrel_kill") >= 1
	end,
	on_event = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		local var_8_0 = Managers.state.game_mode:level_key()

		if not var_8_0 or var_8_0 ~= "dlc_dwarf_whaling" then
			return
		end

		if not arg_8_2.current_kills then
			arg_8_2.current_kills = 0
		end

		if arg_8_4[3][7] == "lamp_oil_fire" then
			arg_8_2.current_kills = arg_8_2.current_kills + 1
		end

		if arg_8_2.current_kills >= var_0_14 then
			arg_8_0:increment_stat(arg_8_1, "dwarf_barrel_kill")
		end
	end
}
var_0_3.dwarf_elevator_speedrun = {
	name = "achv_dwarf_elevator_speedrun_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_elevator_speedrun",
	desc = "achv_dwarf_elevator_speedrun_desc",
	events = {
		"dwarf_elevator_speedrun"
	},
	completed = function(arg_9_0, arg_9_1, arg_9_2)
		return arg_9_0:get_persistent_stat(arg_9_1, "dwarf_elevator_speedrun") >= 1
	end,
	on_event = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		arg_10_0:increment_stat(arg_10_1, "dwarf_elevator_speedrun")
	end
}
whaling_all_challenges = table.clone(var_0_7)

table.remove(whaling_all_challenges, #whaling_all_challenges)

whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_feculent_buboes"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_statue_emote"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_go_fish"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_barrel_kill"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_elevator_speedrun"

var_0_2(var_0_3, "whaling_all_challenges", whaling_all_challenges, "achievement_dwarf_meta", nil, nil, nil)
