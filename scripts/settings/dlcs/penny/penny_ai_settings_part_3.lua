-- chunkname: @scripts/settings/dlcs/penny/penny_ai_settings_part_3.lua

local var_0_0 = DLCSettings.penny_part_3

var_0_0.breeds = {
	"scripts/settings/breeds/breed_chaos_exalted_sorcerer_drachenfels"
}
var_0_0.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_exalted_sorcerer_drachenfels"
}
var_0_0.anim_lookup = {
	"attack_float_01",
	"attack_float_02",
	"attack_float_01_fwd",
	"attack_float_02_fwd",
	"attack_float_03",
	"attack_float_06",
	"attack_float_03_fwd",
	"attack_float_06_fwd",
	"attack_close_01",
	"attack_close_02",
	"attack_close_03",
	"attack_float_special",
	"attack_float_combo_01",
	"float_teleport_start",
	"float_teleport_end",
	"teleport_defensive",
	"to_exhausted",
	"toggle_movement",
	"teleport_to_aoe",
	"teleport_to_flying",
	"float_teleport_death_end"
}
var_0_0.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/chaos/chaos_exalted_sorcerer_drachenfels_behavior"
}
var_0_0.behaviour_tree_nodes = {
	"scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_charge_action",
	"scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_swarm_action"
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0
	local var_1_1 = ConflictUtils.get_random_spawner_with_id("sorcerer_boss_drachenfels")

	if var_1_1 then
		var_1_0 = Unit.local_position(var_1_1, 0)

		local var_1_2 = Vector3.normalize(Vector3.flat(Quaternion.forward(ScriptUnit.extension(var_1_1, "spawner_system"):spawn_rotation())))

		arg_1_2.spawn_forward = Vector3Box(var_1_2)

		local var_1_3 = {
			(ConflictUtils.get_random_spawner_with_id("sorcerer_boss_drachenfels_minion"))
		}

		print("found spawner for sorcerer_boss_drachenfels_minion:", var_1_3[1])

		var_1_3[2] = ConflictUtils.get_random_spawner_with_id("sorcerer_boss_drachenfels_minion", var_1_3[1])

		print("found spawner for sorcerer_boss_drachenfels_minion:", var_1_3[2])

		arg_1_2.spawners = var_1_3
		arg_1_1.defensive_spawner = var_1_1
	else
		local var_1_4 = {
			spawn_group = "default",
			use_fallback_spawners = true
		}

		var_1_0 = BTSpawnAllies.find_spawn_point(arg_1_0, arg_1_1, var_1_4, arg_1_2)
	end

	return var_1_0
end

var_0_0.bt_enter_hooks = {
	on_chaos_exalted_sorcerer_drachenfels_intro_enter = function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_intro

		if var_2_0 then
			local var_2_1 = var_2_0[1]
			local var_2_2 = Unit.local_position(var_2_1, 0)
			local var_2_3 = Unit.local_rotation(var_2_1, 0)

			arg_2_1.quick_teleport_exit_pos = Vector3Box(var_2_2)
			arg_2_1.quick_teleport = true

			Unit.set_local_rotation(arg_2_0, 0, var_2_3)

			ScriptUnit.extension(arg_2_0, "health_system").is_invincible = true
		else
			print("Found no generic AI node (sorcerer_boss_drachenfels_intro) for lord intro, ", arg_2_0)

			arg_2_1.intro_timer = nil
		end

		LevelHelper:flow_event(arg_2_1.world, "spawn_shield")
		arg_2_1.health_extension:set_min_health_percentage(0.65)
	end,
	stop_fly_sound = function(arg_3_0, arg_3_1, arg_3_2)
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_stop", arg_3_0)
	end,
	sorcerer_drachenfels_begin_defensive_mode = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = {
			stay_still = true,
			end_time = math.huge
		}
		local var_4_1 = var_0_1(arg_4_0, arg_4_1, var_4_0)

		arg_4_1.defensive_phase_duration = arg_4_1.defensive_phase_max_duration
		arg_4_1.spawning_allies = var_4_0
		arg_4_1.quick_teleport_exit_pos = Vector3Box(var_4_1)
		arg_4_1.quick_teleport = true
		var_4_0.call_position = arg_4_1.quick_teleport_exit_pos
		arg_4_1.has_call_position = true
		arg_4_1.teleport_health_percent = arg_4_1.health_extension:current_health_percent() - 0.1
		arg_4_1.spell_count = 0

		local var_4_2 = ScriptUnit.extension_input(arg_4_0, "dialogue_system")
		local var_4_3 = FrameTable.alloc_table()

		var_4_2:trigger_networked_dialogue_event("ebh_summon", var_4_3)
	end,
	sorcerer_drachenfels_re_enter_defensive_mode = function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = {
			stay_still = true,
			end_time = math.huge
		}
		local var_5_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_intro[1]
		local var_5_2 = Unit.local_position(var_5_1, 0)

		arg_5_1.spawning_allies = var_5_0
		arg_5_1.quick_teleport_exit_pos = Vector3Box(var_5_2)
		arg_5_1.quick_teleport = true
		var_5_0.call_position = arg_5_1.quick_teleport_exit_pos
		arg_5_1.has_call_position = true

		LevelHelper:flow_event(arg_5_1.world, "spawn_shield")

		local var_5_3 = arg_5_1.health_extension

		var_5_3.is_invincible = true

		if not arg_5_1.two_thirds_transition_done and not arg_5_1.one_third_transition_done then
			var_5_3:set_min_health_percentage(0.32)
		elseif not arg_5_1.one_third_transition_done then
			var_5_3:set_min_health_percentage(0)
		end

		arg_5_1.teleport_health_percent = arg_5_1.health_extension:current_health_percent() - 0.1
		arg_5_1.spell_count = 0

		local var_5_4 = ScriptUnit.extension_input(arg_5_0, "dialogue_system")
		local var_5_5 = FrameTable.alloc_table()

		var_5_4:trigger_networked_dialogue_event("ebh_summon", var_5_5)
	end,
	teleport_spawn_sequence_drachenfels = function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = {
			stay_still = true,
			end_time = math.huge
		}

		var_0_1(arg_6_0, arg_6_1, var_6_0)

		arg_6_1.spawning_allies = var_6_0
	end,
	trickle_spawn_drachenfels = function(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = {
			stay_still = true,
			end_time = math.huge
		}

		var_0_1(arg_7_0, arg_7_1, var_7_0)

		arg_7_1.spawning_allies = var_7_0
	end,
	teleport_to_center_drachenfels = function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = {
			stay_still = true,
			end_time = math.huge
		}

		var_0_1(arg_8_0, arg_8_1, var_8_0)

		arg_8_1.spawning_allies = var_8_0

		local var_8_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center[1]
		local var_8_2 = Unit.local_position(var_8_1, 0)

		if var_8_2 then
			arg_8_1.quick_teleport_exit_pos = Vector3Box(var_8_2)
			arg_8_1.quick_teleport = true
			arg_8_1.move_pos = nil

			return
		end
	end
}
var_0_0.bt_leave_hooks = {
	sorcerer_drachenfels_go_offensive = function(arg_9_0, arg_9_1, arg_9_2)
		arg_9_1.mode = "offensive"
		arg_9_1.health_extension.is_invincible = false
		arg_9_1.ring_cooldown = arg_9_1.ring_total_cooldown

		LevelHelper:flow_event(arg_9_1.world, "destroy_shield")
	end,
	transition_at_two_thirds = function(arg_10_0, arg_10_1, arg_10_2)
		arg_10_1.two_thirds_transition_done = true
	end,
	transition_at_one_third = function(arg_11_0, arg_11_1, arg_11_2)
		arg_11_1.one_third_transition_done = true
	end,
	transition_at_one_fifth = function(arg_12_0, arg_12_1, arg_12_2)
		arg_12_1.one_fifth_transition_done = true
	end,
	transition_at_three_fifths = function(arg_13_0, arg_13_1, arg_13_2)
		arg_13_1.three_fifths_transition_done = true
	end,
	sorcerer_drachenfels_go_offensive_intense = function(arg_14_0, arg_14_1, arg_14_2)
		arg_14_1.mode = "offensive"
		arg_14_1.health_extension.is_invincible = false
		arg_14_1.ring_cooldown = arg_14_1.ring_total_cooldown

		Unit.flow_event(arg_14_0, "lua_mover_blocker_on")
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_start", arg_14_0)

		if arg_14_1.one_third_transition_done then
			arg_14_1.third_phase_in_progress = true
		end

		LevelHelper:flow_event(arg_14_1.world, "destroy_shield")
	end,
	sorcerer_drachenfels_go_defensive = function(arg_15_0, arg_15_1, arg_15_2)
		arg_15_1.mode = "defensive"
		arg_15_1.phase = "defensive_starts"
		arg_15_1.setup_done = true
	end,
	sorcerer_drachenfels_re_enter_defensive = function(arg_16_0, arg_16_1, arg_16_2)
		arg_16_1.mode = "defensive"
		arg_16_1.phase = "defensive_starts"
		arg_16_1.transition_done = true
	end,
	on_drachenfels_sorcerer_intro_leave = function(arg_17_0, arg_17_1, arg_17_2)
		if HEALTH_ALIVE[arg_17_0] and not arg_17_1.exit_last_action then
			local var_17_0 = Managers.state.network:game()
			local var_17_1 = Managers.state.unit_storage:go_id(arg_17_0)

			GameSession.set_game_object_field(var_17_0, var_17_1, "show_health_bar", true)
			Managers.state.event:trigger("boss_health_bar_register_unit", arg_17_0, "lord")
			Managers.state.conflict:add_angry_boss(1, arg_17_1)

			arg_17_1.is_angry = true
			arg_17_1.intro_timer = nil
		end

		local var_17_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for iter_17_0, iter_17_1 in pairs(var_17_2) do
			ScriptUnit.extension(iter_17_1, "health_system").is_invincible = false
		end

		arg_17_1.stagger = nil
		arg_17_1.stagger_immune_time = arg_17_2 + 2
	end
}
var_0_0.utility_considerations_file_names = {
	"scripts/settings/dlcs/penny/penny_utility_considerations"
}
var_0_0.unit_extension_templates = {
	"scripts/settings/dlcs/penny/penny_unit_extension_templates"
}
var_0_0.ai_breed_snippets_file_names = {
	"scripts/settings/dlcs/penny/penny_ai_breed_snippets"
}
var_0_0.enemy_package_loader_breed_categories = {
	level_specific = {
		"chaos_exalted_sorcerer_drachenfels"
	}
}
