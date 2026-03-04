-- chunkname: @scripts/managers/game_mode/horde_surge_handler.lua

HordeSurgeHandler = class(HordeSurgeHandler)

local var_0_0 = {
	"rpc_horde_surge_freeze",
	"rpc_horde_surge_set_level"
}

HordeSurgeHandler.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._is_server = arg_1_1
	arg_1_0._world = arg_1_2

	if not arg_1_3 then
		arg_1_0.disabled = true
	end

	arg_1_0._events = arg_1_3
	arg_1_0._current_event = nil
	arg_1_0._seed = arg_1_4
	arg_1_0._level_index = 0
	arg_1_0._current_terror_event_index = 0
	arg_1_0._end_time = nil
	arg_1_0._start_time = 0
	arg_1_0._freeze_time = 0
	arg_1_0._frozen = false
	arg_1_0._active = arg_1_5
	arg_1_0._first_update = true
	arg_1_0._time_modifier = 1
	arg_1_0._game_object_id = nil
	arg_1_0._progress = 0
	arg_1_0._time_to_next = 0
	arg_1_0._current_terror_event = nil

	if arg_1_0._is_server then
		local var_1_0 = {
			progress = 0,
			go_type = NetworkLookup.go_types.horde_surge
		}

		arg_1_0._game_object_id = Managers.state.network:create_game_object("horde_surge", var_1_0)
	else
		arg_1_0._target_progress = 0
		arg_1_0._time_until_next_update = 0
		arg_1_0._last_update_time = 0
	end
end

HordeSurgeHandler.register_rpcs = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:register(arg_2_0, unpack(var_0_0))

	arg_2_0._network_event_delegate = arg_2_1
	arg_2_0._network_transmit = arg_2_2
end

HordeSurgeHandler.unregister_rpcs = function (arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
	arg_3_0._network_transmit = nil
end

HordeSurgeHandler.destroy = function (arg_4_0)
	if arg_4_0._is_server then
		local var_4_0 = Network.game_session()

		GameSession.destroy_game_object(var_4_0, arg_4_0._game_object_id)
	end
end

HordeSurgeHandler.server_update = function (arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._active or not arg_5_0._game_object_id or script_data.disable_horde_surge or arg_5_0.disabled then
		return
	end

	local var_5_0 = Network.game_session()

	if not var_5_0 then
		return
	end

	local var_5_1 = arg_5_0._freeze_time ~= 0

	if not var_5_1 and arg_5_0._events then
		if arg_5_0._first_update then
			arg_5_0:_next_level(arg_5_1, var_5_0)

			arg_5_0._first_update = false
		end

		if arg_5_1 > arg_5_0._end_time then
			arg_5_0:_trigger_event()
			arg_5_0:_next_level(arg_5_1, var_5_0)
		end

		arg_5_0._time_to_next = arg_5_0._end_time - arg_5_1
		arg_5_0._progress = (arg_5_1 - arg_5_0._start_time) / (arg_5_0._end_time - arg_5_0._start_time) * 100

		GameSession.set_game_object_field(var_5_0, arg_5_0._game_object_id, "progress", arg_5_0._progress)
	else
		arg_5_0._freeze_time = math.max(arg_5_0._freeze_time - arg_5_2, 0)
	end

	arg_5_0._frozen = var_5_1
end

HordeSurgeHandler.client_update = function (arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._game_object_id or script_data.disable_horde_surge or arg_6_0.disabled then
		return
	end

	local var_6_0 = Network.game_session()

	if not var_6_0 then
		return
	end

	local var_6_1 = GameSession.game_object_field(var_6_0, arg_6_0._game_object_id, "progress")

	if var_6_1 < arg_6_0._target_progress then
		arg_6_0._target_progress = 0
		arg_6_0._progress = 0
	end

	if var_6_1 ~= arg_6_0._target_progress then
		arg_6_0._progress = arg_6_0._target_progress
		arg_6_0._target_progress = var_6_1
		arg_6_0._time_until_next_update = arg_6_1 - arg_6_0._last_update_time
		arg_6_0._last_update_time = arg_6_1
	end

	if arg_6_0._progress ~= arg_6_0._target_progress then
		local var_6_2 = arg_6_0._target_progress - arg_6_0._progress

		arg_6_0._progress = math.min(arg_6_0._progress + var_6_2 / arg_6_0._time_until_next_update * arg_6_2, arg_6_0._target_progress)
		arg_6_0._time_until_next_update = arg_6_0._time_until_next_update - arg_6_2
	end

	arg_6_0._time_to_next = math.max(0, arg_6_0._time_to_next - arg_6_2)

	if arg_6_0._frozen then
		arg_6_0._freeze_time = math.max(0, arg_6_0._freeze_time - arg_6_2)

		if arg_6_0._freeze_time == 0 then
			arg_6_0._frozen = false
		end
	end
end

HordeSurgeHandler._trigger_event = function (arg_7_0)
	local var_7_0 = {}
	local var_7_1, var_7_2 = Math.next_random(arg_7_0._seed, 1, #arg_7_0._current_event.terror_events)

	arg_7_0._seed = var_7_1

	local var_7_3 = arg_7_0._current_event.terror_events[var_7_2]

	TerrorEventMixer.start_event(var_7_3, var_7_0)

	arg_7_0._current_terror_event = var_7_3
	arg_7_0._current_terror_event_index = var_7_2
end

HordeSurgeHandler._next_level = function (arg_8_0, arg_8_1, arg_8_2)
	fassert(arg_8_0._is_server, "This should only be called on the server")

	if arg_8_0._events[arg_8_0._level_index + 1] then
		arg_8_0._level_index = arg_8_0._level_index + 1
		arg_8_0._current_event = arg_8_0._events[arg_8_0._level_index]
	else
		arg_8_0._time_modifier = math.max(arg_8_0._time_modifier * 0.9, 0.5)
	end

	local var_8_0 = arg_8_0._current_event.time * arg_8_0._time_modifier

	arg_8_0._start_time = arg_8_1
	arg_8_0._end_time = arg_8_1 + var_8_0

	Managers.state.event:trigger("horde_surge_level_changed", arg_8_0._level_index)
	arg_8_0._network_transmit:send_rpc_clients("rpc_horde_surge_set_level", arg_8_0._level_index, arg_8_0._current_terror_event_index, arg_8_0._time_to_next)
end

HordeSurgeHandler.freeze_timer = function (arg_9_0, arg_9_1)
	fassert(arg_9_0._is_server, "This should only be called on the server")

	if arg_9_0._frozen then
		arg_9_1 = arg_9_1 - arg_9_0._freeze_time
	end

	arg_9_0._freeze_time = arg_9_0._freeze_time + arg_9_1
	arg_9_0._end_time = arg_9_0._end_time + arg_9_1
	arg_9_0._start_time = arg_9_0._start_time + arg_9_1

	arg_9_0._network_transmit:send_rpc_clients("rpc_horde_surge_freeze", arg_9_0._freeze_time)
end

HordeSurgeHandler.activate = function (arg_10_0)
	arg_10_0._active = true
end

HordeSurgeHandler.deactivate = function (arg_11_0)
	arg_11_0._active = false
end

HordeSurgeHandler.get_progress = function (arg_12_0)
	return arg_12_0._progress
end

HordeSurgeHandler.get_freeze_time = function (arg_13_0)
	return arg_13_0._freeze_time
end

HordeSurgeHandler.is_frozen = function (arg_14_0)
	return arg_14_0._frozen
end

HordeSurgeHandler.get_level = function (arg_15_0)
	return arg_15_0._level_index
end

HordeSurgeHandler.rpc_horde_surge_freeze = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._freeze_time = arg_16_2
	arg_16_0._frozen = true
end

HordeSurgeHandler.rpc_horde_surge_set_level = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_0._level_index = arg_17_2

	if arg_17_3 ~= 0 then
		arg_17_0._current_terror_event_index = arg_17_3
		arg_17_0._current_terror_event = arg_17_0._events[arg_17_2 - 1].terror_events[arg_17_3]
	end

	arg_17_0._time_to_next = arg_17_4

	Managers.state.event:trigger("horde_surge_changed_level", arg_17_2)
end

HordeSurgeHandler.hot_join_sync = function (arg_18_0, arg_18_1)
	arg_18_0._network_transmit:send_rpc("rpc_horde_surge_set_level", arg_18_1, arg_18_0._level_index, arg_18_0._current_terror_event_index, arg_18_0._time_to_next)

	if arg_18_0._frozen then
		arg_18_0._network_transmit:send_rpc("rpc_horde_surge_freeze", arg_18_1, arg_18_0._freeze_time)
	end
end
