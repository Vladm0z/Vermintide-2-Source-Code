-- chunkname: @scripts/unit_extensions/default_player_unit/ghost_mode/player_unit_ghost_mode_extension.lua

require("scripts/entity_system/systems/ghost_mode/ghost_mode_utils")

PlayerUnitGhostModeExtension = class(PlayerUnitGhostModeExtension)

PlayerUnitGhostModeExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._is_server = arg_1_0._network_transmit.is_server
	arg_1_0._unit_storage = arg_1_1.unit_storage
	arg_1_0._teleport_target_unit = nil
	arg_1_0._teleport_target_index_fallback = 1
	arg_1_0._player = arg_1_3.player

	local var_1_0 = arg_1_3.side_id

	arg_1_0._side = Managers.state.side:get_side(var_1_0)

	fassert(arg_1_0._side, "no side assigned.")

	arg_1_0._allowed_to_leave = false
	arg_1_0._ghost_mode_active = false
	arg_1_0._allowed_to_enter = false
	arg_1_0._reason_not_allowed_to_leave = nil
	arg_1_0._reason_allowed_to_enter = nil

	arg_1_0:_set_teleport_target_type("disabled")

	arg_1_0._has_teleported = false
	arg_1_0._has_left_once = false
	arg_1_0._external_no_spawn_reasons = {}
	arg_1_0._enter_ghost_mode_allowance_check_time = 0
	arg_1_0._leave_ghost_mode_allowance_check_time = 0
	arg_1_0._is_husk = false
	arg_1_0._latest_range_update = math.huge
	arg_1_0._range = math.huge
	arg_1_0._minimum_spawn_distance = GameModeSettings.versus.dark_pact_minimum_spawn_distance
	arg_1_0._prev_round_started = Managers.state.game_mode:is_round_started()
end

PlayerUnitGhostModeExtension.extensions_ready = function (arg_2_0)
	arg_2_0._locomotion_extension = ScriptUnit.extension(arg_2_0._unit, "locomotion_system")
	arg_2_0._inventory_extension = ScriptUnit.extension(arg_2_0._unit, "inventory_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_0._unit, "career_system")
	arg_2_0._breed = Unit.get_data(arg_2_0._unit, "breed")
end

PlayerUnitGhostModeExtension.game_object_initialized = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = true

	if var_3_0 then
		local var_3_1 = false

		arg_3_0:_enter_ghost_mode(var_3_1)
	end
end

PlayerUnitGhostModeExtension.destroy = function (arg_4_0)
	return
end

PlayerUnitGhostModeExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_0:is_in_ghost_mode() then
		arg_5_0:_update_allowed_to_leave(arg_5_5)
	else
		arg_5_0:_update_allowed_to_enter(arg_5_5)
	end
end

PlayerUnitGhostModeExtension._update_allowed_to_leave = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._unit

	arg_6_0._range = math.ceil(arg_6_0:get_distance_from_players(var_6_0))

	if arg_6_0._range and arg_6_0._range ~= arg_6_0._latest_range_update then
		Managers.state.event:trigger("update_range_to_spawn", arg_6_0._range)

		arg_6_0._latest_range_update = arg_6_0._range
	end

	if not arg_6_2 and arg_6_1 < arg_6_0._leave_ghost_mode_allowance_check_time then
		return
	end

	arg_6_0._leave_ghost_mode_allowance_check_time = arg_6_1 + 0.2

	local var_6_1 = arg_6_0._world
	local var_6_2 = script_data.always_allow_leave_ghost_mode or Development.parameter("disable_ghost_mode")
	local var_6_3 = arg_6_0._side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_6_4 = {}

	for iter_6_0 = 1, #var_6_3 do
		local var_6_5 = var_6_3[iter_6_0]

		if not ScriptUnit.extension(var_6_5, "status_system"):is_knocked_down() then
			var_6_4[#var_6_4 + 1] = POSITION_LOOKUP[var_6_5]
		end
	end

	local var_6_6 = World.get_data(var_6_1, "physics_world")
	local var_6_7 = GhostModeUtils.in_line_of_sight_of_enemies(var_6_0, var_6_4, var_6_6)
	local var_6_8 = arg_6_0._player:profile_index()
	local var_6_9 = SPProfiles[var_6_8]
	local var_6_10 = var_6_9.enemy_role and var_6_9.enemy_role == "boss"
	local var_6_11 = GhostModeUtils.in_range_of_enemies(POSITION_LOOKUP[var_6_0], arg_6_0._side, var_6_10)
	local var_6_12 = GhostModeUtils.pact_sworn_round_started(var_6_0)
	local var_6_13 = GhostModeUtils.enemy_players_using_transport(var_6_0)
	local var_6_14 = GhostModeUtils.in_safe_zone(var_6_0)
	local var_6_15 = arg_6_0:_external_no_spawn_reason()
	local var_6_16 = "player"

	if not var_6_2 and (var_6_13 or not var_6_12) then
		var_6_16 = "disabled"
	end

	if var_6_16 ~= arg_6_0._teleport_target_type then
		arg_6_0:_set_teleport_target_type(var_6_16)
	end

	local var_6_17, var_6_18 = arg_6_0:allowed_to_leave()
	local var_6_19 = arg_6_0._player
	local var_6_20 = Managers.party:get_player_status(var_6_19.peer_id, var_6_19:local_player_id())
	local var_6_21 = var_6_20 and var_6_20.game_mode_data.spawn_timer or 0
	local var_6_22 = "allowed"

	if var_6_13 then
		var_6_22 = "transport"
	elseif var_6_11 then
		var_6_22 = "range"
	elseif var_6_7 then
		var_6_22 = "los"
	elseif var_6_21 - arg_6_1 > 0 then
		var_6_22 = "w8_to_spawn"
	elseif not var_6_12 then
		var_6_22 = "start_zone"
	elseif var_6_14 then
		var_6_22 = "in_safe_zone"
	elseif var_6_15 then
		var_6_22 = "external_no_spawn_reason"
	end

	if var_6_22 ~= var_6_18 then
		local var_6_23 = var_6_22 == "allowed"

		arg_6_0:_set_allowed_to_leave(var_6_23, var_6_22)

		if arg_6_0:is_in_ghost_mode() then
			arg_6_0:_update_allowed_to_leave_ui()
		end
	end
end

PlayerUnitGhostModeExtension._update_allowed_to_enter = function (arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_2 and arg_7_1 < arg_7_0._enter_ghost_mode_allowance_check_time then
		return
	end

	arg_7_0._enter_ghost_mode_allowance_check_time = arg_7_1 + 0.2

	arg_7_0:_update_allowed_to_leave(arg_7_1, true, true)

	local var_7_0 = arg_7_0._unit
	local var_7_1 = GhostModeUtils.enemy_players_using_transport(var_7_0)
	local var_7_2 = GhostModeUtils.far_enough_to_enter_ghost_mode(var_7_0)
	local var_7_3 = ScriptUnit.extension(var_7_0, "status_system")
	local var_7_4 = not not HEALTH_ALIVE[var_7_0] and not var_7_3:is_dead()
	local var_7_5 = false
	local var_7_6, var_7_7, var_7_8 = CharacterStateHelper.get_item_data_and_weapon_extensions(arg_7_0._inventory_extension)
	local var_7_9 = CharacterStateHelper.get_current_action_data(var_7_8, var_7_7)

	if var_7_9 and var_7_9.disallow_ghost_mode then
		var_7_5 = true
	end

	local var_7_10 = var_7_4 and (var_7_2 or var_7_1) and not var_7_5 and arg_7_0:allowed_to_leave()
	local var_7_11, var_7_12 = arg_7_0:allowed_to_enter()
	local var_7_13 = not var_7_4 and "dead" or var_7_2 and "distance" or var_7_1 and "transport" or var_7_5 and "blocking_action"

	if var_7_10 ~= var_7_11 or not var_7_10 and var_7_13 ~= var_7_12 then
		arg_7_0:_set_allowed_to_enter(var_7_10, var_7_13)
	end
end

PlayerUnitGhostModeExtension._set_allowed_to_leave = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0._allowed_to_leave = arg_8_1
	arg_8_0._reason_not_allowed_to_leave = arg_8_2
end

PlayerUnitGhostModeExtension._update_allowed_to_leave_ui = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._allowed_to_leave
	local var_9_1 = arg_9_0._reason_not_allowed_to_leave
	local var_9_2 = Managers.state.game_mode:is_round_started()

	if var_9_2 then
		local var_9_3 = arg_9_0:_get_target_teleport_unit()

		Managers.state.event:trigger("add_gameplay_info_event", "ghost_catchup", true, nil, var_9_3)
	end

	if var_9_0 then
		Managers.state.event:trigger("add_gameplay_info_event", "ghost_spawn", true)

		if not arg_9_1 then
			arg_9_0:_play_sound("versus_ghost_mode_spawn_indicator")
		end
	else
		if not var_9_2 then
			Managers.state.event:trigger("add_gameplay_info_event", "hide_teleport", true, var_9_1)
		end

		Managers.state.event:trigger("add_gameplay_info_event", "ghost_cantspawn", true, var_9_1)
	end
end

PlayerUnitGhostModeExtension.get_distance_from_players = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_10_1 = POSITION_LOOKUP[arg_10_1]
	local var_10_2 = math.huge
	local var_10_3 = arg_10_0._player:profile_index()
	local var_10_4 = SPProfiles[var_10_3]
	local var_10_5 = var_10_4.enemy_role and var_10_4.enemy_role == "boss"
	local var_10_6 = var_10_5 and GameModeSettings.versus.boss_minimum_spawn_distance or GameModeSettings.versus.dark_pact_minimum_spawn_distance
	local var_10_7 = var_10_5 and "boss_spawn_range_distance" or "special_spawn_range_distance"
	local var_10_8, var_10_9, var_10_10 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", var_10_7)

	if var_10_8 and var_10_10 then
		var_10_6 = var_10_9
	end

	for iter_10_0 = 1, #var_10_0 do
		local var_10_11 = var_10_0[iter_10_0]
		local var_10_12 = Vector3.distance(var_10_11, var_10_1)

		if var_10_12 < var_10_6 and var_10_12 < var_10_2 then
			var_10_2 = var_10_6 - var_10_12
		end
	end

	if var_10_2 < 0 or var_10_6 < var_10_2 then
		return 0
	else
		return var_10_2
	end
end

PlayerUnitGhostModeExtension.allowed_to_leave = function (arg_11_0)
	if Development.parameter("disable_ghost_mode") then
		return true
	else
		return arg_11_0._allowed_to_leave, arg_11_0._reason_not_allowed_to_leave
	end
end

PlayerUnitGhostModeExtension._get_target_teleport_unit = function (arg_12_0)
	if ALIVE[arg_12_0._teleport_target_unit] then
		return arg_12_0._teleport_target_unit
	end

	arg_12_0:_progress_teleport_target()

	return arg_12_0._teleport_target_unit
end

PlayerUnitGhostModeExtension._progress_teleport_target = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_13_1 = #var_13_0
	local var_13_2

	if arg_13_1 then
		for iter_13_0 = 1, var_13_1 do
			if var_13_0[iter_13_0] == arg_13_1 then
				var_13_2 = iter_13_0

				break
			end
		end
	end

	var_13_2 = var_13_2 or math.min(arg_13_0._teleport_target_index_fallback, var_13_1)

	local var_13_3 = math.index_wrapper(var_13_2 + 1, var_13_1)

	arg_13_0._teleport_target_unit = var_13_0[var_13_3]
	arg_13_0._teleport_target_index_fallback = var_13_3
end

PlayerUnitGhostModeExtension._set_allowed_to_enter = function (arg_14_0, arg_14_1, arg_14_2)
	if arg_14_1 then
		local var_14_0 = arg_14_0:_get_target_teleport_unit()

		Managers.state.event:trigger("add_gameplay_info_event", "ghost_catchup", true, nil, var_14_0)
		Managers.state.event:trigger("add_gameplay_info_event", "hide_text", true, nil, var_14_0)
	else
		Managers.state.event:trigger("add_gameplay_info_event", "ghost_catchup", false, nil)
		Managers.state.event:trigger("add_gameplay_info_event", "hide_teleport", true, nil)
	end

	arg_14_0._allowed_to_enter = arg_14_1
	arg_14_0._reason_allowed_to_enter = arg_14_2
end

PlayerUnitGhostModeExtension.allowed_to_enter = function (arg_15_0)
	return arg_15_0._allowed_to_enter, arg_15_0._reason_allowed_to_enter
end

PlayerUnitGhostModeExtension.is_in_ghost_mode = function (arg_16_0)
	return arg_16_0._ghost_mode_active, arg_16_0._has_left_once
end

PlayerUnitGhostModeExtension.is_husk = function (arg_17_0)
	return arg_17_0._is_husk
end

PlayerUnitGhostModeExtension.teleport_player = function (arg_18_0, arg_18_1)
	if arg_18_0._teleport_target_type == "player" then
		arg_18_0:_teleport_to_next_enemy(arg_18_1)
	elseif arg_18_0._teleport_target_type == "safe_spot" then
		arg_18_0:_teleport_to_safe_spot()
	end
end

PlayerUnitGhostModeExtension._furthest_player_enemy_unit = function (arg_19_0)
	local var_19_0 = POSITION_LOOKUP[arg_19_0._unit]
	local var_19_1 = arg_19_0._side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_19_2 = 0
	local var_19_3

	for iter_19_0 = 1, #var_19_1 do
		local var_19_4 = POSITION_LOOKUP[var_19_1[iter_19_0]]
		local var_19_5 = Vector3.distance_squared(var_19_4, var_19_0)

		if var_19_2 < var_19_5 then
			var_19_2 = var_19_5
			var_19_3 = var_19_1[iter_19_0]
		end
	end

	return var_19_3
end

PlayerUnitGhostModeExtension._teleport_to_next_enemy = function (arg_20_0, arg_20_1)
	if #arg_20_0._side.ENEMY_PLAYER_AND_BOT_UNITS == 0 then
		return
	end

	arg_20_0:_set_allowed_to_leave(false, "los", true)

	local var_20_0 = arg_20_1 and arg_20_0:_furthest_player_enemy_unit() or arg_20_0:_get_target_teleport_unit()
	local var_20_1 = POSITION_LOOKUP[var_20_0] + Vector3(0, 0, 0.2)

	arg_20_0._locomotion_extension:teleport_to(var_20_1)

	arg_20_0._has_teleported = true

	arg_20_0:_progress_teleport_target(var_20_0)
	arg_20_0:_update_allowed_to_leave_ui(true)
end

PlayerUnitGhostModeExtension._teleport_to_safe_spot = function (arg_21_0)
	arg_21_0._locomotion_extension:teleport_to(arg_21_0._safe_spot:unbox() + Vector3(0, 0, 0.2))
end

PlayerUnitGhostModeExtension._enter_ghost_mode = function (arg_22_0, arg_22_1)
	arg_22_0._ghost_mode_active = true

	if not DEDICATED_SERVER then
		local var_22_0 = CosmeticsUtils.get_third_person_mesh_unit(arg_22_0._unit)

		Unit.flow_event(var_22_0, "lua_entered_ghost_mode")
	end

	local var_22_1 = arg_22_0._inventory_extension:equipment()
	local var_22_2 = var_22_1.right_hand_wielded_unit or var_22_1.left_hand_wielded_unit

	if not DEDICATED_SERVER and var_22_2 then
		Unit.flow_event(var_22_2, "lua_entered_ghost_mode")
	end

	Managers.state.camera:set_mood("ghost_mode", arg_22_0, true)

	if arg_22_1 then
		local var_22_3 = true

		arg_22_0:teleport_player(var_22_3)
	end

	local var_22_4 = ScriptUnit.extension(arg_22_0._unit, "status_system")

	var_22_4:set_ghost_mode(true)
	var_22_4:set_invisible(true, nil, "ghost_mode")
	GhostModeSystem.set_sweep_actors(arg_22_0._unit, arg_22_0._breed, false)
	arg_22_0._locomotion_extension:set_mover_filter_property("dark_pact_noclip", true)

	local var_22_5 = arg_22_0._unit_storage:go_id(arg_22_0._unit)

	if arg_22_0._is_server then
		arg_22_0._network_transmit:send_rpc_clients("rpc_entered_ghost_mode", var_22_5)
	else
		arg_22_0._network_transmit:send_rpc_server("rpc_entered_ghost_mode", var_22_5)
	end

	Managers.state.event:trigger("enter_ghostmode", true, arg_22_0._unit)
	Managers.state.event:trigger("set_new_enemy_role")
	arg_22_0:_play_sound("versus_enter_ghost_mode")
	Managers.state.entity:system("dialogue_context_system"):set_context_value(arg_22_0._unit, "is_in_ghost_mode", true)
end

PlayerUnitGhostModeExtension._leave_ghost_mode = function (arg_23_0)
	arg_23_0._ghost_mode_active = false
	arg_23_0._has_teleported = false
	arg_23_0._has_left_once = true

	local var_23_0 = arg_23_0._unit
	local var_23_1 = arg_23_0._inventory_extension:equipment()
	local var_23_2 = var_23_1.right_hand_wielded_unit or var_23_1.left_hand_wielded_unit
	local var_23_3 = ScriptUnit.extension(arg_23_0._unit, "status_system")

	var_23_3:set_ghost_mode(false)
	var_23_3:set_invisible(false, nil, "ghost_mode")
	GhostModeSystem.set_sweep_actors(arg_23_0._unit, arg_23_0._breed, true)
	Managers.telemetry_events:left_ghost_mode(arg_23_0._breed.name, POSITION_LOOKUP[arg_23_0._unit])

	if not DEDICATED_SERVER then
		if var_23_2 then
			Unit.flow_event(var_23_2, "lua_left_ghost_mode")
		end

		local var_23_4 = CosmeticsUtils.get_third_person_mesh_unit(arg_23_0._unit)

		Unit.flow_event(var_23_4, "lua_left_ghost_mode")
	end

	Managers.state.camera:set_mood("ghost_mode", arg_23_0, false)
	arg_23_0._locomotion_extension:set_mover_filter_property("dark_pact_noclip", false)
	Managers.state.event:trigger("enter_ghostmode", false, var_23_0)
	Managers.state.event:trigger("add_gameplay_info_event", "hide_text", true, {
		"los",
		"start_zone",
		"transport"
	})

	if not arg_23_0._display_equipment then
		arg_23_0._display_equipment = true
	end

	arg_23_0:_play_sound("menu_versus_pactsworn_spawn")

	if arg_23_0._is_server then
		ScriptUnit.extension_input(var_23_0, "dialogue_system"):trigger_dialogue_event("spawning")

		if not arg_23_0._has_played_boss_sound and arg_23_0._breed.boss then
			Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_new_spawn_monster")

			arg_23_0._has_played_boss_sound = true
		end
	end

	local var_23_5 = arg_23_0._unit_storage:go_id(arg_23_0._unit)

	if arg_23_0._is_server then
		arg_23_0._network_transmit:send_rpc_clients("rpc_left_ghost_mode", var_23_5)
	else
		arg_23_0._network_transmit:send_rpc_server("rpc_left_ghost_mode", var_23_5)
	end

	Managers.state.entity:system("dialogue_context_system"):set_context_value(var_23_0, "is_in_ghost_mode", false)

	local var_23_6 = arg_23_0._career_extension:profile_index()
	local var_23_7 = arg_23_0._career_extension:career_index()
	local var_23_8 = CareerUtils.get_abilities(var_23_6, var_23_7)

	for iter_23_0 = 1, #var_23_8 do
		if var_23_8[iter_23_0].unpause_on_leave_ghost_mode then
			arg_23_0._career_extension:set_activated_ability_cooldown_unpaused(iter_23_0)
		end
	end
end

PlayerUnitGhostModeExtension.try_enter_ghost_mode = function (arg_24_0)
	fassert(not arg_24_0:is_in_ghost_mode(), "In ghost mode already.")

	local var_24_0 = Managers.time:time("game")

	arg_24_0:_update_allowed_to_enter(var_24_0, true)

	if arg_24_0:allowed_to_enter() then
		local var_24_1 = true

		arg_24_0:_enter_ghost_mode(var_24_1)
	end
end

PlayerUnitGhostModeExtension.try_leave_ghost_mode = function (arg_25_0, arg_25_1)
	fassert(arg_25_0:is_in_ghost_mode(), "In ghost mode already.")

	local var_25_0 = Managers.time:time("game")

	arg_25_0:_update_allowed_to_leave(var_25_0, true)

	if arg_25_1 or arg_25_0:allowed_to_leave() then
		arg_25_0:_leave_ghost_mode()
	end
end

PlayerUnitGhostModeExtension.set_safe_spot = function (arg_26_0, arg_26_1)
	arg_26_0._safe_spot = arg_26_1
end

PlayerUnitGhostModeExtension._set_teleport_target_type = function (arg_27_0, arg_27_1)
	if arg_27_0:allowed_to_enter() and arg_27_1 ~= "player" then
		print(arg_27_0:allowed_to_enter(), arg_27_1)
		Crashify.print_exception("GhostModeSystem", "Allowed to enter ghost mode while not allowed to teleport.")
	end

	arg_27_0._teleport_target_type = arg_27_1
end

PlayerUnitGhostModeExtension._play_sound = function (arg_28_0, arg_28_1)
	local var_28_0 = Managers.world:world("level_world")
	local var_28_1 = Managers.world:wwise_world(var_28_0)

	WwiseWorld.trigger_event(var_28_1, arg_28_1)
end

PlayerUnitGhostModeExtension.set_external_no_spawn_reason = function (arg_29_0, arg_29_1, arg_29_2)
	arg_29_0._external_no_spawn_reasons[arg_29_1] = arg_29_2 or nil

	local var_29_0 = Managers.time:time("game")
	local var_29_1 = true

	arg_29_0:_update_allowed_to_leave(var_29_0, var_29_1)
end

PlayerUnitGhostModeExtension._external_no_spawn_reason = function (arg_30_0)
	return next(arg_30_0._external_no_spawn_reasons)
end
