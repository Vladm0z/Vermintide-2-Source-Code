-- chunkname: @scripts/unit_extensions/generic/player_in_zone_extension.lua

PlayerInZoneExtension = class(PlayerInZoneExtension)

function PlayerInZoneExtension.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._unit = arg_1_2

	arg_1_0:_get_script_data()

	arg_1_0._world = arg_1_1.world
	arg_1_0._extension_init_context = arg_1_1
	arg_1_0._activated = false
	arg_1_0._state = "_idle"
	arg_1_0._client_state = "progress_inactive"
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._state_data = {}
	arg_1_0._closest_player_distance = math.huge
	arg_1_0._player_distances = {}
	arg_1_0._progress_time = 0
	arg_1_0._unit_in_progress = false
	arg_1_0._state_data.end_progression_timer = 0
	arg_1_0._progress_is_frozen = false
	arg_1_0._game = Managers.state.network:game()
	arg_1_0._has_register_count_up = false
	arg_1_0._has_been_in_zone = false
	arg_1_0._progression_percentage = {}

	for iter_1_0 = 1, 3 do
		arg_1_0._progression_percentage[iter_1_0 * 25] = false
	end
end

function PlayerInZoneExtension._get_script_data(arg_2_0)
	arg_2_0._num_player_in_zone = Unit.get_data(arg_2_0._unit, "player_in_zone", "num_player_in_zone")
	arg_2_0._animation_time = Unit.get_data(arg_2_0._unit, "player_in_zone", "start_stop_animation_time")
	arg_2_0._timer = Unit.get_data(arg_2_0._unit, "player_in_zone", "timer")
	arg_2_0._progress_bar_countdown = Unit.get_data(arg_2_0._unit, "player_in_zone", "progression_countdown")
	arg_2_0._progress_bar_smooth_back = Unit.get_data(arg_2_0._unit, "player_in_zone", "progress_bar_smooth_back")
	arg_2_0._progress_bar_freeze = Unit.get_data(arg_2_0._unit, "player_in_zone", "progress_bar_freeze")
	arg_2_0._show_progress_bar_global = Unit.get_data(arg_2_0._unit, "player_in_zone", "show_progress_bar_global")
	arg_2_0._show_progress_bar_personal = Unit.get_data(arg_2_0._unit, "player_in_zone", "show_progress_bar_personal")
	arg_2_0._progress_zone_size = Unit.get_data(arg_2_0._unit, "player_in_zone", "zone_radius")
	arg_2_0._time_modifier_per_player = Unit.has_data(arg_2_0._unit, "player_in_zone", "time_modifier_per_player") and Unit.get_data(arg_2_0._unit, "player_in_zone", "time_modifier_per_player") or 0

	local var_2_0 = Unit.get_data(arg_2_0._unit, "player_in_zone", "player_side") or "heroes"

	arg_2_0._player_units = Managers.state.side:get_side_from_name(var_2_0).PLAYER_UNITS
end

function PlayerInZoneExtension._create_game_object(arg_3_0)
	local var_3_0 = LevelHelper:current_level(arg_3_0._world)

	arg_3_0._level_unit_index = Level.unit_index(var_3_0, arg_3_0._unit)

	local var_3_1 = {
		progress_time = 0,
		go_type = NetworkLookup.go_types.progress_timer,
		level_unit_index = arg_3_0._level_unit_index,
		unit_in_progress = arg_3_0._unit_in_progress,
		progress_is_frozen = arg_3_0._progress_is_frozen,
		counting_up = arg_3_0._progress_bar_countdown
	}
	local var_3_2 = callback(arg_3_0, "cb_game_session_disconnect")

	arg_3_0._go_id = Managers.state.network:create_game_object("progress_timer", var_3_1, var_3_2)
end

function PlayerInZoneExtension.cb_game_session_disconnect(arg_4_0)
	arg_4_0._go_id = nil
end

function PlayerInZoneExtension.on_game_object_created(arg_5_0, arg_5_1)
	arg_5_0._go_id = arg_5_1
end

function PlayerInZoneExtension.on_game_object_destroyed(arg_6_0)
	arg_6_0._go_id = nil
end

function PlayerInZoneExtension.extensions_ready(arg_7_0)
	if not arg_7_0._is_server then
		return
	end

	if Managers.state.network:in_game_session() then
		arg_7_0:_create_game_object()
	else
		arg_7_0._waiting_for_game_session = true
	end
end

function PlayerInZoneExtension.activated(arg_8_0)
	return arg_8_0._activated
end

function PlayerInZoneExtension._current_time(arg_9_0)
	return arg_9_0._state_data.end_progression_timer
end

function PlayerInZoneExtension.should_progress_count_down(arg_10_0)
	return arg_10_0._progress_bar_countdown
end

function PlayerInZoneExtension.progress_bar_personal(arg_11_0)
	return arg_11_0._show_progress_bar_personal
end

function PlayerInZoneExtension.progress_bar_global(arg_12_0)
	return arg_12_0._show_progress_bar_global
end

function PlayerInZoneExtension.player_been_in_zone(arg_13_0)
	return arg_13_0._has_been_in_zone
end

function PlayerInZoneExtension.progress(arg_14_0)
	return arg_14_0._state_data.end_progression_timer
end

function PlayerInZoneExtension.update(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if not arg_15_0._activated then
		return
	end

	arg_15_0:_update_distances()

	if arg_15_0._is_server then
		arg_15_0:_update_state(arg_15_3, arg_15_5)
	else
		arg_15_0:_update_client(arg_15_3)
	end
end

function PlayerInZoneExtension._update_client(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._go_id

	if not var_16_0 then
		return
	end

	local var_16_1 = arg_16_0._game
	local var_16_2 = GameSession.game_object_field(var_16_1, var_16_0, "progress_time")
	local var_16_3 = GameSession.game_object_field(var_16_1, var_16_0, "unit_in_progress")
	local var_16_4 = GameSession.game_object_field(var_16_1, var_16_0, "counting_up")
	local var_16_5 = GameSession.game_object_field(var_16_1, var_16_0, "progress_is_frozen")
	local var_16_6 = arg_16_0._client_state

	if var_16_6 == "progress_inactive" then
		if var_16_3 then
			arg_16_0._client_state = "progress_active"
			arg_16_0._state_data.end_progression_timer = var_16_2

			arg_16_0:_trigger_start_events()
		end
	elseif var_16_6 == "progress_active" then
		if not arg_16_0._has_been_in_zone and arg_16_0:_local_player_in_zone() then
			arg_16_0._has_been_in_zone = true
		end

		if var_16_5 then
			arg_16_0._state_data.end_progression_timer = var_16_2
		else
			arg_16_0:_client_progress(var_16_4, var_16_2, arg_16_1)
		end

		if not var_16_3 then
			arg_16_0._client_state = "progress_inactive"

			arg_16_0:_client_unit_inactive(var_16_2)
		end
	end

	arg_16_0:_check_progress_percent(arg_16_0._state_data.end_progression_timer)
end

function PlayerInZoneExtension._client_unit_inactive(arg_17_0, arg_17_1)
	arg_17_0._state_data.end_progression_timer = arg_17_1
	arg_17_0._progress_time = arg_17_1
	arg_17_0._has_been_in_zone = false

	arg_17_0:_trigger_stop_events()
end

function PlayerInZoneExtension._client_progress(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_1 then
		local var_18_0, var_18_1 = arg_18_0:_fulfill_in_zone_check()

		arg_18_0._state_data.end_progression_timer = arg_18_0:_count_up(arg_18_3, var_18_1)
	else
		arg_18_0._state_data.end_progression_timer = arg_18_0:_count_down(arg_18_3)
	end
end

function PlayerInZoneExtension.set_active(arg_19_0)
	if arg_19_0._activated then
		return
	end

	local var_19_0 = Managers.state.network
	local var_19_1 = LevelHelper:unit_index(arg_19_0._world, arg_19_0._unit)

	if arg_19_0._is_server then
		if var_19_1 then
			var_19_0.network_transmit:send_rpc_clients("rpc_player_in_zone_set_active", var_19_1)
		end
	elseif var_19_1 then
		var_19_0.network_transmit:send_rpc_server("rpc_player_in_zone_set_active", var_19_1)
	end

	arg_19_0:set_active_rpc()
end

function PlayerInZoneExtension.set_active_rpc(arg_20_0)
	arg_20_0._activated = true
end

function PlayerInZoneExtension._update_state(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0[arg_21_0._state](arg_21_0, arg_21_1, arg_21_2, arg_21_0._state_data)
end

function PlayerInZoneExtension.hot_join_sync(arg_22_0, arg_22_1)
	if arg_22_0._activated then
		local var_22_0 = Managers.state.network
		local var_22_1 = LevelHelper:unit_index(arg_22_0._world, arg_22_0._unit)

		if var_22_1 then
			var_22_0.network_transmit:send_rpc("rpc_player_in_zone_set_active", arg_22_1, var_22_1)
		end
	end
end

function PlayerInZoneExtension.destroy(arg_23_0)
	Managers.state.network.network_transmit.network_event_delegate:unregister(arg_23_0)
end

function PlayerInZoneExtension._update_distances(arg_24_0)
	local var_24_0 = Unit.local_position(arg_24_0._unit, 0)
	local var_24_1 = arg_24_0._player_units
	local var_24_2 = arg_24_0._player_distances

	table.clear(var_24_2)

	local var_24_3 = math.huge

	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		local var_24_4 = POSITION_LOOKUP[iter_24_1]

		if var_24_4 then
			local var_24_5 = Vector3.distance_squared(var_24_0, var_24_4)

			if var_24_5 < var_24_3 then
				var_24_3 = var_24_5
			end

			var_24_2[iter_24_1] = var_24_5
		end
	end

	arg_24_0._closest_player_distance = var_24_3
end

function PlayerInZoneExtension._idle(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0:_fulfill_in_zone_check() then
		arg_25_0._state = "_progress_check"
	end
end

function PlayerInZoneExtension._fulfill_in_zone_check(arg_26_0)
	local var_26_0 = arg_26_0._progress_zone_size * arg_26_0._progress_zone_size

	if not (var_26_0 >= arg_26_0._closest_player_distance) then
		return false, 0
	end

	local var_26_1 = 0
	local var_26_2 = 0

	for iter_26_0, iter_26_1 in pairs(arg_26_0._player_distances) do
		var_26_2 = var_26_2 + 1

		if iter_26_1 < var_26_0 then
			var_26_1 = var_26_1 + 1
		end
	end

	return var_26_2 == var_26_1 or var_26_1 >= arg_26_0._num_player_in_zone, var_26_1
end

function PlayerInZoneExtension._local_player_in_zone(arg_27_0)
	local var_27_0 = Managers.player:local_player()

	if not var_27_0 then
		return false
	end

	local var_27_1 = var_27_0.player_unit

	if not var_27_1 then
		return false
	end

	local var_27_2 = arg_27_0._player_distances[var_27_1]

	if not var_27_2 then
		return false
	end

	if var_27_2 > arg_27_0._progress_zone_size * arg_27_0._progress_zone_size then
		return false
	end

	return true
end

function PlayerInZoneExtension._progress_frozen(arg_28_0)
	local var_28_0, var_28_1 = arg_28_0:_fulfill_in_zone_check()

	if var_28_0 then
		arg_28_0._state = "_progress_check"
	end

	local var_28_2 = arg_28_0._go_id
	local var_28_3 = arg_28_0._game

	if var_28_2 and not GameSession.game_object_field(var_28_3, var_28_2, "progress_is_frozen") then
		GameSession.set_game_object_field(var_28_3, var_28_2, "progress_is_frozen", true)
	end
end

function PlayerInZoneExtension._progress_check(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._go_id
	local var_29_1 = arg_29_0._game
	local var_29_2

	if not arg_29_0._progress_check_entered then
		arg_29_0._progress_check_entered = true

		if var_29_0 then
			if not GameSession.game_object_field(var_29_1, var_29_0, "unit_in_progress") then
				GameSession.set_game_object_field(var_29_1, var_29_0, "unit_in_progress", true)
			end

			if GameSession.game_object_field(var_29_1, var_29_0, "progress_is_frozen") then
				GameSession.set_game_object_field(var_29_1, var_29_0, "progress_is_frozen", false)
			end
		end

		arg_29_0:_trigger_start_events()
	end

	local var_29_3, var_29_4 = arg_29_0:_fulfill_in_zone_check()

	if var_29_3 then
		if not arg_29_0._has_register_count_up then
			arg_29_0._has_register_count_up = true

			arg_29_0:_register_count_up(true)
		end

		if not arg_29_0._has_been_in_zone and arg_29_0:_local_player_in_zone() then
			arg_29_0._has_been_in_zone = true
		end

		arg_29_0._state_data.end_progression_timer = arg_29_0:_count_up(arg_29_1, var_29_4)

		if arg_29_0._state_data.end_progression_timer == 1 then
			var_29_2 = "_progress_finished"
		end
	else
		if arg_29_0._progress_bar_smooth_back then
			if arg_29_0._has_register_count_up then
				arg_29_0._has_register_count_up = false

				arg_29_0:_register_count_up(false)
			end

			arg_29_0._state_data.end_progression_timer = arg_29_0:_count_down(arg_29_1)
		elseif arg_29_0._progress_bar_freeze then
			var_29_2 = "_progress_frozen"
		else
			arg_29_0._state_data.end_progression_timer = 0
		end

		if arg_29_0._state_data.end_progression_timer == 0 then
			if var_29_0 and GameSession.game_object_field(var_29_1, var_29_0, "unit_in_progress") then
				GameSession.set_game_object_field(var_29_1, var_29_0, "unit_in_progress", false)
			end

			var_29_2 = "_idle"
		end
	end

	arg_29_0:_check_progress_percent(arg_29_0._state_data.end_progression_timer)

	if var_29_0 then
		GameSession.set_game_object_field(var_29_1, var_29_0, "progress_time", arg_29_0._state_data.end_progression_timer)
	end

	if var_29_2 then
		if var_29_2 ~= "_progress_frozen" then
			arg_29_0._has_been_in_zone = false

			arg_29_0:_trigger_stop_events()
		end

		arg_29_0._progress_check_entered = nil
		arg_29_0._state = var_29_2
	end
end

function PlayerInZoneExtension._progress_finished(arg_30_0)
	local var_30_0 = Managers.state.network
	local var_30_1 = LevelHelper:unit_index(arg_30_0._world, arg_30_0._unit)

	var_30_0.network_transmit:send_rpc_clients("rpc_player_in_zone_end_event", var_30_1)
	arg_30_0:end_event()
end

function PlayerInZoneExtension._trigger_start_events(arg_31_0)
	Managers.state.event:trigger("start_progression_zone", arg_31_0._unit, arg_31_0)
	Unit.flow_event(arg_31_0._unit, "lua_start_progression")
end

function PlayerInZoneExtension._trigger_stop_events(arg_32_0)
	Managers.state.event:trigger("stop_progression_zone", arg_32_0._unit, arg_32_0)
	Unit.flow_event(arg_32_0._unit, "lua_stop_progression")
end

function PlayerInZoneExtension._check_progress_percent(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._progression_percentage
	local var_33_1 = arg_33_0._unit

	for iter_33_0, iter_33_1 in pairs(arg_33_0._progression_percentage) do
		local var_33_2 = iter_33_0 / 100

		if var_33_2 < arg_33_1 and not iter_33_1 then
			Unit.flow_event(var_33_1, "lua_check_progression_" .. iter_33_0 .. "_start")

			var_33_0[iter_33_0] = true
		elseif arg_33_1 < var_33_2 and iter_33_1 then
			Unit.flow_event(var_33_1, "lua_check_progression_" .. iter_33_0 .. "_stop")

			var_33_0[iter_33_0] = false
		end
	end
end

function PlayerInZoneExtension._count_up(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._timer
	local var_34_1 = 1

	if arg_34_2 and arg_34_2 > 1 then
		var_34_1 = var_34_1 + arg_34_0._time_modifier_per_player * arg_34_2
	end

	return math.clamp(arg_34_0:_current_time() + arg_34_1 / var_34_0 * var_34_1, 0, 1)
end

function PlayerInZoneExtension._count_down(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._timer

	return math.clamp(arg_35_0:_current_time() - arg_35_1 / var_35_0, 0, 1)
end

function PlayerInZoneExtension._reset(arg_36_0)
	arg_36_0._activated = false

	Managers.state.event:trigger("stop_progression_zone", arg_36_0._unit)

	arg_36_0._state_data.end_progression_timer = 0

	arg_36_0:_check_progress_percent(arg_36_0._state_data.end_progression_timer)

	if arg_36_0._is_server then
		local var_36_0 = arg_36_0._go_id

		if var_36_0 then
			local var_36_1 = arg_36_0._game

			GameSession.set_game_object_field(var_36_1, var_36_0, "progress_time", arg_36_0._state_data.end_progression_timer)
		end
	end
end

function PlayerInZoneExtension.end_event(arg_37_0)
	arg_37_0:_reset()
	Unit.flow_event(arg_37_0._unit, "lua_start_end_event")
end

function PlayerInZoneExtension._register_count_up(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._go_id
	local var_38_1 = arg_38_0._game

	GameSession.set_game_object_field(var_38_1, var_38_0, "counting_up", arg_38_1)
end

function PlayerInZoneExtension._debug_drawer(arg_39_0, arg_39_1)
	if arg_39_1 == "counting" then
		arg_39_0._drawer = arg_39_0._drawer or Managers.state.debug:drawer({
			mode = "immediate"
		})

		arg_39_0._drawer:reset()

		local var_39_0 = arg_39_0._state_data.end_progression_timer
		local var_39_1 = math.lerp(1, 0, var_39_0) * 255
		local var_39_2 = math.lerp(0, 1, var_39_0) * 255

		arg_39_0._drawer:sphere(Unit.local_position(arg_39_0._unit, 0), arg_39_0._progress_zone_size, Color(var_39_1, var_39_2, 0), 30, 30)
	elseif arg_39_1 == "stop" then
		arg_39_0._drawer = arg_39_0._drawer or Managers.state.debug:drawer({
			mode = "immediate"
		})

		arg_39_0._drawer:reset()
		arg_39_0._drawer:sphere(Unit.local_position(arg_39_0._unit, 0), arg_39_0._progress_zone_size, Color(255, 255, 0), 10, 10)
	elseif arg_39_1 == "idle" then
		arg_39_0._drawer = arg_39_0._drawer or Managers.state.debug:drawer({
			mode = "immediate"
		})

		arg_39_0._drawer:reset()
		arg_39_0._drawer:sphere(Unit.local_position(arg_39_0._unit, 0), arg_39_0._progress_zone_size, Color(255, 255, 0), 30, 30)
	end
end
