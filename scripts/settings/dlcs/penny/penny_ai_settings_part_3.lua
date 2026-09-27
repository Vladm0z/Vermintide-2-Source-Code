-- chunkname: @scripts/settings/dlcs/penny/penny_ai_settings_part_3.lua

local penny_part_3 = DLCSettings.penny_part_3

penny_part_3.breeds = {
	"scripts/settings/breeds/breed_chaos_exalted_sorcerer_drachenfels"
}
penny_part_3.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_exalted_sorcerer_drachenfels"
}
penny_part_3.anim_lookup = {
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
penny_part_3.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/chaos/chaos_exalted_sorcerer_drachenfels_behavior"
}
penny_part_3.behaviour_tree_nodes = {
	"scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_charge_action",
	"scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_swarm_action"
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local var_1_0
	local get_random_spawner_with_id = ConflictUtils.get_random_spawner_with_id("sorcerer_boss_drachenfels")

	if not get_random_spawner_with_id then
		var_1_0 = Unit.local_position(get_random_spawner_with_id, 0)

		local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(ScriptUnit.extension(get_random_spawner_with_id, "spawner_system"):spawn_rotation())))

		arg_1_2.spawn_forward = Vector3Box(normalize)

		local tbl = {
			(ConflictUtils.get_random_spawner_with_id("sorcerer_boss_drachenfels_minion"))
		}

		print("found spawner for sorcerer_boss_drachenfels_minion:", tbl[1])

		tbl[2] = ConflictUtils.get_random_spawner_with_id("sorcerer_boss_drachenfels_minion", tbl[1])

		print("found spawner for sorcerer_boss_drachenfels_minion:", tbl[2])

		arg_1_2.spawners = tbl
		arg_1_1.defensive_spawner = get_random_spawner_with_id
	else
		local tbl_2 = {
			spawn_group = "default",
			use_fallback_spawners = true
		}

		var_1_0 = BTSpawnAllies.find_spawn_point(arg_1_0, arg_1_1, tbl_2, arg_1_2)
	end

	return var_1_0
end

penny_part_3.bt_enter_hooks = {
	on_chaos_exalted_sorcerer_drachenfels_intro_enter = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		local sorcerer_boss_drachenfels_intro = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_intro

		if not sorcerer_boss_drachenfels_intro then
			local var_2_1 = sorcerer_boss_drachenfels_intro[1]
			local local_position = Unit.local_position(var_2_1, 0)
			local local_rotation = Unit.local_rotation(var_2_1, 0)

			arg_2_1.quick_teleport_exit_pos = Vector3Box(local_position)
			arg_2_1.quick_teleport = true

			Unit.set_local_rotation(arg_2_0, 0, local_rotation)

			ScriptUnit.extension(arg_2_0, "health_system").is_invincible = true
		else
			print("Found no generic AI node (sorcerer_boss_drachenfels_intro) for lord intro, ", arg_2_0)

			arg_2_1.intro_timer = nil
		end

		LevelHelper:flow_event(arg_2_1.world, "spawn_shield")
		arg_2_1.health_extension:set_min_health_percentage(0.65)
	end,
	stop_fly_sound = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_stop", arg_3_0)
	end,
	sorcerer_drachenfels_begin_defensive_mode = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local tbl = {
			stay_still = true,
			end_time = math.huge
		}
		local var_4_1 = fn(arg_4_0, arg_4_1, tbl)

		arg_4_1.defensive_phase_duration = arg_4_1.defensive_phase_max_duration
		arg_4_1.spawning_allies = tbl
		arg_4_1.quick_teleport_exit_pos = Vector3Box(var_4_1)
		arg_4_1.quick_teleport = true
		tbl.call_position = arg_4_1.quick_teleport_exit_pos
		arg_4_1.has_call_position = true
		arg_4_1.teleport_health_percent = arg_4_1.health_extension:current_health_percent() - 0.1
		arg_4_1.spell_count = 0

		local extension_input = ScriptUnit.extension_input(arg_4_0, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("ebh_summon", alloc_table)
	end,
	sorcerer_drachenfels_re_enter_defensive_mode = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		local tbl = {
			stay_still = true,
			end_time = math.huge
		}
		local var_5_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_intro[1]
		local local_position = Unit.local_position(var_5_1, 0)

		arg_5_1.spawning_allies = tbl
		arg_5_1.quick_teleport_exit_pos = Vector3Box(local_position)
		arg_5_1.quick_teleport = true
		tbl.call_position = arg_5_1.quick_teleport_exit_pos
		arg_5_1.has_call_position = true

		LevelHelper:flow_event(arg_5_1.world, "spawn_shield")

		local health_extension = arg_5_1.health_extension

		health_extension.is_invincible = true

		if not (arg_5_1.two_thirds_transition_done or arg_5_1.one_third_transition_done) then
			health_extension:set_min_health_percentage(0.32)
		elseif not arg_5_1.one_third_transition_done then
			health_extension:set_min_health_percentage(0)
		end

		arg_5_1.teleport_health_percent = arg_5_1.health_extension:current_health_percent() - 0.1
		arg_5_1.spell_count = 0

		local extension_input = ScriptUnit.extension_input(arg_5_0, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("ebh_summon", alloc_table)
	end,
	teleport_spawn_sequence_drachenfels = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		local tbl = {
			stay_still = true,
			end_time = math.huge
		}

		fn(arg_6_0, arg_6_1, tbl)

		arg_6_1.spawning_allies = tbl
	end,
	trickle_spawn_drachenfels = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		local tbl = {
			stay_still = true,
			end_time = math.huge
		}

		fn(arg_7_0, arg_7_1, tbl)

		arg_7_1.spawning_allies = tbl
	end,
	teleport_to_center_drachenfels = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		local tbl = {
			stay_still = true,
			end_time = math.huge
		}

		fn(arg_8_0, arg_8_1, tbl)

		arg_8_1.spawning_allies = tbl

		local var_8_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center[1]
		local local_position = Unit.local_position(var_8_1, 0)

		if not local_position then
			arg_8_1.quick_teleport_exit_pos = Vector3Box(local_position)
			arg_8_1.quick_teleport = true
			arg_8_1.move_pos = nil

			return
		end
	end
}
penny_part_3.bt_leave_hooks = {
	sorcerer_drachenfels_go_offensive = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		arg_9_1.mode = "offensive"
		arg_9_1.health_extension.is_invincible = false
		arg_9_1.ring_cooldown = arg_9_1.ring_total_cooldown

		LevelHelper:flow_event(arg_9_1.world, "destroy_shield")
	end,
	transition_at_two_thirds = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		arg_10_1.two_thirds_transition_done = true
	end,
	transition_at_one_third = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		arg_11_1.one_third_transition_done = true
	end,
	transition_at_one_fifth = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		arg_12_1.one_fifth_transition_done = true
	end,
	transition_at_three_fifths = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		arg_13_1.three_fifths_transition_done = true
	end,
	sorcerer_drachenfels_go_offensive_intense = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		arg_14_1.mode = "offensive"
		arg_14_1.health_extension.is_invincible = false
		arg_14_1.ring_cooldown = arg_14_1.ring_total_cooldown

		Unit.flow_event(arg_14_0, "lua_mover_blocker_on")
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_start", arg_14_0)

		if not arg_14_1.one_third_transition_done then
			arg_14_1.third_phase_in_progress = true
		end

		LevelHelper:flow_event(arg_14_1.world, "destroy_shield")
	end,
	sorcerer_drachenfels_go_defensive = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		arg_15_1.mode = "defensive"
		arg_15_1.phase = "defensive_starts"
		arg_15_1.setup_done = true
	end,
	sorcerer_drachenfels_re_enter_defensive = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		arg_16_1.mode = "defensive"
		arg_16_1.phase = "defensive_starts"
		arg_16_1.transition_done = true
	end,
	on_drachenfels_sorcerer_intro_leave = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		if not (not HEALTH_ALIVE[arg_17_0] and arg_17_1.exit_last_action) then
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_17_0)

			GameSession.set_game_object_field(game, go_id, "show_health_bar", true)
			Managers.state.event:trigger("boss_health_bar_register_unit", arg_17_0, "lord")
			Managers.state.conflict:add_angry_boss(1, arg_17_1)

			arg_17_1.is_angry = true
			arg_17_1.intro_timer = nil
		end

		local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for k, v in pairs(PLAYER_AND_BOT_UNITS) do
			ScriptUnit.extension(v, "health_system").is_invincible = false
		end

		arg_17_1.stagger = nil
		arg_17_1.stagger_immune_time = arg_17_2 + 2
	end
}
penny_part_3.utility_considerations_file_names = {
	"scripts/settings/dlcs/penny/penny_utility_considerations"
}
penny_part_3.unit_extension_templates = {
	"scripts/settings/dlcs/penny/penny_unit_extension_templates"
}
penny_part_3.ai_breed_snippets_file_names = {
	"scripts/settings/dlcs/penny/penny_ai_breed_snippets"
}
penny_part_3.enemy_package_loader_breed_categories = {
	level_specific = {
		"chaos_exalted_sorcerer_drachenfels"
	}
}
