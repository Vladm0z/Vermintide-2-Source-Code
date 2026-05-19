-- chunkname: @scripts/managers/networked_flow_state/networked_flow_state_manager.lua

NetworkedFlowStateManager = class(NetworkedFlowStateManager)

local var_0_0 = 30
local var_0_1 = {
	boolean = {
		rpcs = {
			change = "rpc_flow_state_bool_changed"
		}
	},
	number = {
		network_constant = "number",
		rpcs = {
			change = "rpc_flow_state_number_changed"
		}
	}
}
local var_0_2 = {
	"none",
	"loop",
	"ping_pong"
}

for iter_0_0, iter_0_1 in ipairs(var_0_2) do
	var_0_2[iter_0_1] = iter_0_0
end

local var_0_3 = {
	"rpc_flow_state_story_played",
	"rpc_flow_state_story_stopped"
}

for iter_0_2, iter_0_3 in pairs(var_0_1) do
	for iter_0_4, iter_0_5 in pairs(iter_0_3.rpcs) do
		var_0_3[#var_0_3 + 1] = iter_0_5
	end
end

script_data.networked_flow_state_debug = false

local function var_0_4(arg_1_0, ...)
	if script_data.networked_flow_state_debug then
		print("[NetworkedFlowStateManager]", string.format(arg_1_0, ...))
	end
end

function NetworkedFlowStateManager.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._level = nil
	arg_2_0._story_lookup = {}
	arg_2_0._playing_stories = {}
	arg_2_0._canceled_stories = {}
	arg_2_0._object_states = {}
	arg_2_0._num_states = 0
	arg_2_0._max_states = 512

	if arg_2_2 then
		arg_2_0._is_client = false
		arg_2_0._storyteller = World.storyteller(arg_2_1)
	else
		arg_2_0._is_client = true

		arg_2_3:register(arg_2_0, unpack(var_0_3))

		arg_2_0._network_event_delegate = arg_2_3
	end
end

function NetworkedFlowStateManager.create_checkpoint_data(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_0._object_states) do
		var_3_0[Level.unit_index(arg_3_0._level, iter_3_0)] = table.clone(iter_3_1)
	end

	local var_3_1 = {}
	local var_3_2 = arg_3_0._storyteller

	for iter_3_2, iter_3_3 in pairs(arg_3_0._playing_stories) do
		local var_3_3 = table.clone(iter_3_3)

		if not iter_3_3.stopped then
			var_3_3.current_time = var_3_2:time(iter_3_3.id)
		end

		var_3_1[iter_3_2] = var_3_3
	end

	return {
		object_states = var_3_0,
		playing_stories = var_3_1
	}
end

function NetworkedFlowStateManager.load_checkpoint_data(arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in pairs(arg_4_1.object_states) do
		for iter_4_2, iter_4_3 in pairs(iter_4_1.states) do
			local var_4_0 = iter_4_3.value

			if var_4_0 ~= iter_4_3.default_value then
				local var_4_1 = iter_4_1.lookup[iter_4_2]

				arg_4_0:client_flow_state_changed(iter_4_0, var_4_1, var_4_0, true)
			end
		end
	end

	local var_4_2 = arg_4_0._playing_stories

	for iter_4_4, iter_4_5 in pairs(arg_4_1.playing_stories) do
		local var_4_3 = table.clone(iter_4_5)

		var_4_2[iter_4_4] = var_4_3

		if var_4_3.stopped then
			var_0_4("Story %q has_stopped (checkpoint).", iter_4_4)

			local var_4_4 = var_4_3.stop_time or var_4_3.length

			arg_4_0._client_call_data = {
				stop_out = true
			}

			Level.trigger_event(arg_4_0._level, iter_4_4)

			arg_4_0._client_call_data = {
				play_out = true,
				time_out = var_4_4
			}

			Level.trigger_event(arg_4_0._level, iter_4_4)

			arg_4_0._client_call_data = {
				stop_out = true
			}

			Level.trigger_event(arg_4_0._level, iter_4_4)
		else
			local var_4_5 = var_4_3.current_time

			arg_4_0._client_call_data = {
				play_out = true,
				time_out = var_4_5
			}

			var_0_4("Story %q played (checkpoint) start_time: %2.2f,", iter_4_4, var_4_5)
			Level.trigger_event(arg_4_0._level, iter_4_4)

			var_4_3.current_time = nil
		end
	end
end

function NetworkedFlowStateManager.destroy(arg_5_0)
	if arg_5_0._is_client then
		arg_5_0._network_event_delegate:unregister(arg_5_0)
	end
end

function NetworkedFlowStateManager.flow_cb_create_story(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._story_lookup
	local var_6_1 = arg_6_1.client_call_event_name

	var_0_4("Story %q created", var_6_1)

	if not var_6_0[var_6_1] then
		local var_6_2 = #var_6_0 + 1

		var_6_0[var_6_1] = var_6_2
		var_6_0[var_6_2] = var_6_1
	end
end

function NetworkedFlowStateManager.flow_cb_play_networked_story(arg_7_0, arg_7_1)
	if arg_7_0._is_client then
		return nil
	end

	local var_7_0 = arg_7_1.client_call_event_name

	fassert(arg_7_0._story_lookup[var_7_0], "[NetworkedFlowStateManager] Trying to play networked story with client call event name %q that hasn't been created", var_7_0)
	fassert(arg_7_0._playing_stories[var_7_0] == nil or arg_7_0._playing_stories[var_7_0].stopped, "Tried to play networked story with client call event name %q, but it is already playing.", var_7_0)

	local var_7_1 = arg_7_0._playing_stories[var_7_0]
	local var_7_2 = arg_7_1.start_time or arg_7_1.start_from_stop_time and var_7_1 and var_7_1.stop_time or 0

	Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_state_story_played", arg_7_0._story_lookup[var_7_0], var_7_2, false)

	arg_7_0._playing_stories[var_7_0] = {
		start_time = var_7_2
	}

	var_0_4("Story %q played (server) start_time: %2.2f", var_7_0, var_7_2)

	return {
		play_out = true,
		time_out = var_7_2
	}
end

function NetworkedFlowStateManager.rpc_flow_state_story_played(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._story_lookup[arg_8_2]

	arg_8_0._client_call_data = {
		play_out = true,
		time_out = arg_8_3
	}

	var_0_4("Story %q played (client) start_time: %2.2f,", var_8_0, arg_8_3)
	Level.trigger_event(arg_8_0._level, var_8_0)
end

function NetworkedFlowStateManager.flow_cb_networked_story_client_call(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._client_call_data

	arg_9_0._client_call_data = nil

	var_0_4("Story %q client call (client).", arg_9_1.client_call_event_name)

	return var_9_0
end

function NetworkedFlowStateManager.flow_cb_stop_networked_story(arg_10_0, arg_10_1)
	if arg_10_0._is_client then
		return nil
	end

	local var_10_0 = arg_10_1.client_call_event_name

	var_0_4("Stopping story %q (server).", var_10_0)

	local var_10_1 = arg_10_0._playing_stories[var_10_0]

	if not var_10_1 then
		var_0_4("Story canceled: called stop before play %q (server).", var_10_0)

		arg_10_0._canceled_stories[var_10_0] = arg_10_1

		return nil
	end

	local var_10_2 = arg_10_0._storyteller:time(var_10_1.id)

	var_10_1.stop_time = var_10_2

	Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_state_story_stopped", arg_10_0._story_lookup[var_10_0], var_10_2)

	return {
		stop_out = true
	}
end

function NetworkedFlowStateManager.rpc_flow_state_story_stopped(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0._story_lookup[arg_11_2]

	var_0_4("Story %q has_stopped via rpc (client).", var_11_0)

	arg_11_0._client_call_data = {
		stop_out = true
	}

	Level.trigger_event(arg_11_0._level, var_11_0)

	arg_11_0._client_call_data = {
		play_out = true,
		time_out = arg_11_3
	}

	Level.trigger_event(arg_11_0._level, var_11_0)

	arg_11_0._client_call_data = {
		stop_out = true
	}

	Level.trigger_event(arg_11_0._level, var_11_0)
end

function NetworkedFlowStateManager.flow_cb_has_stopped_networked_story(arg_12_0, arg_12_1)
	if arg_12_0._is_client then
		return nil
	end

	local var_12_0 = arg_12_1.client_call_event_name
	local var_12_1 = arg_12_0._playing_stories[var_12_0]

	fassert(var_12_1, "[NetworkedFlowStateManager] Networked story with client call event name %q which is not running is reported as stopped.", var_12_0)

	var_12_1.stopped = true

	var_0_4("Story %q has_stopped (server).", var_12_0)
end

function NetworkedFlowStateManager.flow_cb_has_played_networked_story(arg_13_0, arg_13_1)
	if arg_13_0._is_client then
		return nil
	end

	local var_13_0 = arg_13_1.client_call_event_name
	local var_13_1 = arg_13_0._playing_stories[var_13_0]

	fassert(var_13_1, "[NetworkedFlowStateManager] Networked story with client call event name %q which is not running is reported as running.", var_13_0)
	var_0_4("Story %q has_played (server).", var_13_0)

	local var_13_2 = arg_13_1.story_id

	var_13_1.id = var_13_2
	var_13_1.length = arg_13_0._storyteller:length(var_13_2)

	if arg_13_0._canceled_stories[var_13_0] then
		var_0_4("stopping story due to cancel %q (server).", var_13_0)

		local var_13_3 = arg_13_0:flow_cb_stop_networked_story(arg_13_0._canceled_stories[var_13_0])

		arg_13_0._canceled_stories[var_13_0] = nil

		return var_13_3
	end
end

function NetworkedFlowStateManager.hot_join_sync(arg_14_0, arg_14_1)
	arg_14_0:_sync_states(arg_14_1)
	arg_14_0:_sync_stories(arg_14_1)
end

function NetworkedFlowStateManager._sync_stories(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._storyteller

	var_0_4("Hot join syncing peer %s", arg_15_1)

	for iter_15_0, iter_15_1 in pairs(arg_15_0._playing_stories) do
		local var_15_1
		local var_15_2 = iter_15_1.stopped
		local var_15_3 = NetworkConstants.story_time
		local var_15_4 = PEER_ID_TO_CHANNEL[arg_15_1]

		if var_15_2 then
			RPC.rpc_flow_state_story_stopped(var_15_4, arg_15_0._story_lookup[iter_15_0], math.clamp(iter_15_1.stop_time or iter_15_1.length, var_15_3.min, var_15_3.max))
		else
			RPC.rpc_flow_state_story_played(var_15_4, arg_15_0._story_lookup[iter_15_0], math.clamp(var_15_0:time(iter_15_1.id), var_15_3.min, var_15_3.max))
		end

		var_0_4("Story %q being hot join synced to peer %s (server).", iter_15_0, arg_15_1)
	end
end

function NetworkedFlowStateManager._sync_states(arg_16_0, arg_16_1)
	local var_16_0 = Managers.state.network

	for iter_16_0, iter_16_1 in pairs(arg_16_0._object_states) do
		if Unit.alive(iter_16_0) then
			local var_16_1, var_16_2 = var_16_0:game_object_or_level_id(iter_16_0)
			local var_16_3 = PEER_ID_TO_CHANNEL[arg_16_1]

			for iter_16_2, iter_16_3 in pairs(iter_16_1.states) do
				local var_16_4 = iter_16_3.value

				if var_16_4 ~= iter_16_3.default_value then
					local var_16_5 = iter_16_1.lookup[iter_16_2]
					local var_16_6 = var_0_1[type(var_16_4)]
					local var_16_7 = arg_16_0:_clamp_state(iter_16_2, var_16_6, var_16_4, iter_16_0)

					RPC[var_16_6.rpcs.change](var_16_3, var_16_1, var_16_5, var_16_7, true, not var_16_2)
				end
			end
		end
	end
end

function NetworkedFlowStateManager.set_level(arg_17_0, arg_17_1)
	arg_17_0._level = arg_17_1
end

function NetworkedFlowStateManager.flow_cb_create_state(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	fassert(Unit.alive(arg_18_1), "[NetworkedFlowStateManager] Passing destroyed unit into create flow state for state_name %q", arg_18_2)
	fassert(arg_18_0._num_states < arg_18_0._max_states, "[NetworkedFlowStateManager] Too many object states(%i).", arg_18_0._max_states)

	local var_18_0 = arg_18_0._object_states
	local var_18_1 = var_18_0[arg_18_1] or {
		lookup = {},
		states = {}
	}

	if var_18_1.states[arg_18_2] then
		return
	end

	local var_18_2 = #var_18_1.lookup + 1

	var_18_1.lookup[arg_18_2] = var_18_2
	var_18_1.lookup[var_18_2] = arg_18_2
	var_18_1.states[arg_18_2] = {
		value = arg_18_3,
		default_value = arg_18_3,
		client_state_changed_event = arg_18_4,
		client_state_set_event = arg_18_5,
		state_network_id = var_18_2,
		is_game_object = arg_18_6 or false
	}
	var_18_0[arg_18_1] = var_18_1
	arg_18_0._num_states = arg_18_0._num_states + 1

	return true, arg_18_3
end

function NetworkedFlowStateManager.flow_cb_get_state(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._object_states[arg_19_1]
	local var_19_1 = var_19_0 and var_19_0.states[arg_19_2]

	fassert(var_19_1 ~= nil, "[NetworkedFlowStateManager] State %s doesn't exists in unit %s", arg_19_2, Unit.debug_name(arg_19_1))

	return var_19_1.value
end

function NetworkedFlowStateManager.flow_cb_change_state(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_0._is_client then
		return
	end

	local var_20_0 = arg_20_0._level

	fassert(var_20_0, "[NetworkedFlowStateManager] Trying to change state %q to %s before level has been created. Feed correct setting on create instead of changing during level spawn.", arg_20_2, tostring(arg_20_3))
	fassert(Unit.alive(arg_20_1), "[NetworkedFlowStateManager] Passing destroyed unit into change state for state_name %q", arg_20_2)

	local var_20_1 = arg_20_0._object_states[arg_20_1]
	local var_20_2 = var_20_1 and var_20_1.states[arg_20_2]

	fassert(var_20_2 ~= nil, "[NetworkedFlowStateManager] State %q unit %q is being changed but has not yet been created.", arg_20_2, Unit.debug_name(arg_20_1))

	var_20_2.value = arg_20_3

	local var_20_3 = Managers.state.network:game_object_or_level_id(arg_20_1)
	local var_20_4 = var_20_2.state_network_id
	local var_20_5 = var_20_2 ~= arg_20_3

	if var_20_5 then
		local var_20_6 = var_0_1[type(arg_20_3)]

		arg_20_3 = arg_20_0:_clamp_state(arg_20_2, var_20_6, arg_20_3, arg_20_1)

		Managers.state.network.network_transmit:send_rpc_clients(var_20_6.rpcs.change, var_20_3, var_20_4, arg_20_3, false, var_20_2.is_game_object or false)
	end

	return var_20_5, arg_20_3
end

function NetworkedFlowStateManager._clamp_state(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_2.network_constant and NetworkConstants[arg_21_2.network_constant]

	if var_21_0 and (arg_21_3 < var_21_0.min or arg_21_3 > var_21_0.max) then
		arg_21_3 = math.max(var_21_0.min, math.min(var_21_0.max, arg_21_3))

		Application.warning("[NetworkedFlowStateManager] Networked Flow State %q value %f out of bounds [%f..%f] (%s)", arg_21_1, arg_21_3, var_21_0.min, var_21_0.max, Unit.debug_name(arg_21_4))
	end

	return arg_21_3
end

function NetworkedFlowStateManager.client_flow_state_changed(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = Managers.state.network:game_object_or_level_unit(arg_22_1, not arg_22_5)
	local var_22_1 = arg_22_0._object_states[var_22_0]

	fassert(var_22_1, "[NetworkedFlowStateManager] Trying to change state for unit %q on client despite network flow state node not having been created on client.", tostring(var_22_0))

	local var_22_2 = var_22_1.lookup[arg_22_2]
	local var_22_3 = var_22_1.states[var_22_2]

	if script_data.debug_client_flow_state then
		printf("client flow state %q changed, old value: %s, new value: %s", var_22_2, tostring(var_22_3.value), tostring(arg_22_3))
	end

	var_22_3.value = arg_22_3

	local var_22_4 = arg_22_4 and var_22_3.client_state_set_event or var_22_3.client_state_changed_event

	Unit.flow_event(var_22_0, var_22_4)
end

function NetworkedFlowStateManager.rpc_flow_state_bool_changed(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	arg_23_0:client_flow_state_changed(arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
end

function NetworkedFlowStateManager.rpc_flow_state_number_changed(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	arg_24_0:client_flow_state_changed(arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
end

function NetworkedFlowStateManager.clear_object_state(arg_25_0, arg_25_1)
	arg_25_0._object_states[arg_25_1] = nil
end
