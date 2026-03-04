-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_1.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplates.achievements
local var_0_4 = AchievementTemplateHelper.add_console_achievements
local var_0_5 = {
	dwarf_valaya_emote = 113,
	dwarf_barrel_carry = 112,
	karak_azgaraz_complete_dlc_dwarf_interior_legend = 119
}
local var_0_6 = {
	dwarf_valaya_emote = "092"
}
local var_0_7 = {}
local var_0_8 = {
	LevelSettings.dlc_dwarf_interior
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
	local var_0_12 = "karak_azgaraz_complete_dlc_dwarf_interior_" .. var_0_10[var_0_11]
	local var_0_13 = "achievement_interior_" .. var_0_10[var_0_11]

	var_0_7[iter_0_0] = var_0_12

	var_0_1(var_0_3, var_0_12, var_0_8, DifficultySettings[var_0_11].rank, var_0_13, nil, var_0_5[var_0_12], var_0_6[var_0_12])
end

var_0_3.dwarf_valaya_emote = {
	name = "achv_dwarf_valaya_emote_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_valaya_emote",
	desc = "achv_dwarf_valaya_emote_desc",
	events = {
		"dwarf_valaya_emote"
	},
	completed = function(arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "dwarf_valaya_emote") >= 1
	end,
	on_event = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		if not arg_2_4[1] then
			arg_2_2.end_t = nil

			return
		end

		local var_2_0 = Managers.player:local_player()
		local var_2_1 = var_2_0 and var_2_0.player_unit

		if not var_2_1 then
			return
		end

		local var_2_2 = ScriptUnit.extension(var_2_1, "character_state_machine_system").state_machine
		local var_2_3 = var_2_2 and var_2_2.state_current

		if not (var_2_3 and var_2_3.name == "emote" and var_2_3.current_emote == "anim_pose_unarmed_05") then
			arg_2_2.end_t = nil

			return
		end

		local var_2_4 = Managers.time:time("game")

		if not arg_2_2.end_t then
			arg_2_2.end_t = var_2_4 + 5
			arg_2_2.completed = false

			return
		end

		if var_2_4 > arg_2_2.end_t and not arg_2_2.completed then
			Managers.state.entity:system("audio_system"):_play_event("Play_hud_small_puzzle_cue", var_2_1)

			local var_2_5 = ScriptUnit.extension(var_2_1, "health_system"):get_max_health() / 2

			if Managers.player.is_server then
				DamageUtils.heal_network(var_2_1, var_2_1, var_2_5, "healing_draught")
			else
				local var_2_6 = Managers.state.network
				local var_2_7 = var_2_6.network_transmit
				local var_2_8 = var_2_6:unit_game_object_id(var_2_1)
				local var_2_9 = NetworkLookup.heal_types.healing_draught

				var_2_7:send_rpc_server("rpc_request_heal", var_2_8, var_2_5, var_2_9)
			end

			arg_2_0:increment_stat(arg_2_1, "dwarf_valaya_emote")

			arg_2_2.completed = true
		end
	end
}
var_0_3.dwarf_rune = {
	name = "achv_dwarf_rune_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_rune",
	desc = "achv_dwarf_rune_desc",
	events = {
		"dwarf_rune"
	},
	completed = function(arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "dwarf_rune") >= 1
	end,
	on_event = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		arg_4_0:increment_stat(arg_4_1, "dwarf_rune")
	end
}
var_0_3.dwarf_barrel_carry = {
	name = "achv_dwarf_barrel_carry_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_barrel_carry",
	desc = "achv_dwarf_barrel_carry_desc",
	events = {
		"objective_entered_socket_zone",
		"dwarf_barrel_carry"
	},
	completed = function(arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "dwarf_barrel_carry") >= 1
	end,
	on_event = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = Managers.state.game_mode:level_key()

		if not var_6_0 or var_6_0 ~= "dlc_dwarf_interior" then
			return
		end

		if arg_6_2.failed then
			return
		end

		if arg_6_4[2] then
			arg_6_2.failed = true

			return
		end

		if arg_6_4[1] then
			arg_6_0:increment_stat(arg_6_1, "dwarf_barrel_carry")
		end
	end
}
var_0_3.dwarf_bells = {
	name = "achv_dwarf_bells_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_bells",
	desc = "achv_dwarf_bells_desc",
	events = {
		"dwarf_bells"
	},
	completed = function(arg_7_0, arg_7_1, arg_7_2)
		return arg_7_0:get_persistent_stat(arg_7_1, "dwarf_bells") >= 1
	end,
	on_event = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		arg_8_0:increment_stat(arg_8_1, "dwarf_bells")
	end
}

local var_0_14 = 8

var_0_3.dwarf_pressure = {
	name = "achv_dwarf_pressure_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_pressure",
	desc = function()
		return string.format(Localize("achv_dwarf_pressure_desc"), var_0_14)
	end,
	events = {
		"dwarf_pressure"
	},
	completed = function(arg_10_0, arg_10_1, arg_10_2)
		return arg_10_0:get_persistent_stat(arg_10_1, "dwarf_pressure") >= 1
	end,
	on_event = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		if arg_11_2.failed then
			return
		end

		local var_11_0 = arg_11_4[1]
		local var_11_1 = Managers.time:time("game")

		if not arg_11_2.num_valves then
			arg_11_2.num_valves = 0
		end

		if var_11_0 then
			arg_11_2.start_t = var_11_1

			return
		end

		arg_11_2.num_valves = arg_11_2.num_valves + 1

		if arg_11_2.num_valves >= 4 then
			local var_11_2 = Managers.state.network.network_transmit
			local var_11_3 = NetworkLookup.statistics.dwarf_pressure

			if Managers.state.network.is_server then
				var_11_2:send_rpc_clients("rpc_increment_stat_party", var_11_3)
			else
				var_11_2:send_rpc_server("rpc_increment_stat_party", var_11_3)
			end
		end

		if arg_11_2.start_t and var_11_1 > arg_11_2.start_t + var_0_14 then
			arg_11_2.failed = true

			return
		end
	end
}
interior_all_challenges = table.clone(var_0_7)

table.remove(interior_all_challenges, #interior_all_challenges)

interior_all_challenges[#interior_all_challenges + 1] = "dwarf_valaya_emote"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_rune"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_barrel_carry"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_bells"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_pressure"

var_0_2(var_0_3, "interior_all_challenges", interior_all_challenges, "achievement_interior_meta", nil, var_0_5[name], var_0_6[name])
var_0_4(var_0_5, var_0_6)
