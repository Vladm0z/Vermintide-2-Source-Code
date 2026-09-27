-- chunkname: @scripts/managers/networked_flow_state/networked_flow_state_manager.lua

NetworkedFlowStateManager = class(NetworkedFlowStateManager)

local num = 30
local tbl = {
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
local tbl_2 = {
	"none",
	"loop",
	"ping_pong"
}

for i, v in ipairs(tbl_2) do
	tbl_2[v] = i
end

local tbl_3 = {
	"rpc_flow_state_story_played",
	"rpc_flow_state_story_stopped"
}

for k, v_2 in pairs(tbl) do
	for k_2, v_3 in pairs(v_2.rpcs) do
		tbl_3[#tbl_3 + 1] = v_3
	end
end

script_data.networked_flow_state_debug = false

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.networked_flow_state_debug then
		print("[NetworkedFlowStateManager]", string.format(arg_1_0, ...))
	end
end

NetworkedFlowStateManager.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._level = nil
	self._story_lookup = {}
	self._playing_stories = {}
	self._canceled_stories = {}
	self._object_states = {}
	self._num_states = 0
	self._max_states = 512

	if not arg_2_2 then
		self._is_client = false
		self._storyteller = World.storyteller(arg_2_1)
	else
		self._is_client = true

		arg_2_3:register(self, unpack(tbl_3))

		self._network_event_delegate = arg_2_3
	end
end

NetworkedFlowStateManager.create_checkpoint_data = function (self)
	-- function 3
	local tbl = {}

	for k, v in pairs(self._object_states) do
		tbl[Level.unit_index(self._level, k)] = table.clone(v)
	end

	local tbl_2 = {}
	local _storyteller = self._storyteller

	for k_2, v_2 in pairs(self._playing_stories) do
		local clone = table.clone(v_2)

		if not v_2.stopped then
			clone.current_time = _storyteller:time(v_2.id)
		end

		tbl_2[k_2] = clone
	end

	return {
		object_states = tbl,
		playing_stories = tbl_2
	}
end

NetworkedFlowStateManager.load_checkpoint_data = function (self, arg_4_1)
	-- function 4
	for k, v in pairs(arg_4_1.object_states) do
		for k_2, v_2 in pairs(v.states) do
			local value = v_2.value

			if value ~= v_2.default_value then
				local var_4_1 = v.lookup[k_2]

				self:client_flow_state_changed(k, var_4_1, value, true)
			end
		end
	end

	local _playing_stories = self._playing_stories

	for k_3, v_3 in pairs(arg_4_1.playing_stories) do
		local clone = table.clone(v_3)

		_playing_stories[k_3] = clone

		if not clone.stopped then
			fn("Story %q has_stopped (checkpoint).", k_3)

			local stop_time = clone.stop_time

			stop_time = stop_time or clone.length
			self._client_call_data = {
				stop_out = true
			}

			Level.trigger_event(self._level, k_3)

			self._client_call_data = {
				play_out = true,
				time_out = stop_time
			}

			Level.trigger_event(self._level, k_3)

			self._client_call_data = {
				stop_out = true
			}

			Level.trigger_event(self._level, k_3)
		else
			local current_time = clone.current_time

			self._client_call_data = {
				play_out = true,
				time_out = current_time
			}

			fn("Story %q played (checkpoint) start_time: %2.2f,", k_3, current_time)
			Level.trigger_event(self._level, k_3)

			clone.current_time = nil
		end
	end
end

NetworkedFlowStateManager.destroy = function (self)
	-- function 5
	if not self._is_client then
		self._network_event_delegate:unregister(self)
	end
end

NetworkedFlowStateManager.flow_cb_create_story = function (self, arg_6_1)
	-- function 6
	local _story_lookup = self._story_lookup
	local client_call_event_name = arg_6_1.client_call_event_name

	fn("Story %q created", client_call_event_name)

	if not _story_lookup[client_call_event_name] then
		local num = #_story_lookup + 1

		_story_lookup[client_call_event_name] = num
		_story_lookup[num] = client_call_event_name
	end
end

NetworkedFlowStateManager.flow_cb_play_networked_story = function (self, arg_7_1)
	-- function 7
	if not self._is_client then
		return nil
	end

	local client_call_event_name = arg_7_1.client_call_event_name

	fassert(self._story_lookup[client_call_event_name], "[NetworkedFlowStateManager] Trying to play networked story with client call event name %q that hasn't been created", client_call_event_name)
	fassert(self._playing_stories[client_call_event_name] == nil or self._playing_stories[client_call_event_name].stopped, "Tried to play networked story with client call event name %q, but it is already playing.", client_call_event_name)

	local var_7_1 = self._playing_stories[client_call_event_name]
	local start_time = arg_7_1.start_time

	if not start_time then
		if not arg_7_1.start_from_stop_time and not var_7_1 then
			start_time = var_7_1.stop_time

			if not start_time then
				-- Nothing
			end
		end

		start_time = 0
	end

	::label_7_0::

	Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_state_story_played", self._story_lookup[client_call_event_name], start_time, false)

	self._playing_stories[client_call_event_name] = {
		start_time = start_time
	}

	fn("Story %q played (server) start_time: %2.2f", client_call_event_name, start_time)

	return {
		play_out = true,
		time_out = start_time
	}
end

NetworkedFlowStateManager.rpc_flow_state_story_played = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local var_8_0 = self._story_lookup[arg_8_2]

	self._client_call_data = {
		play_out = true,
		time_out = arg_8_3
	}

	fn("Story %q played (client) start_time: %2.2f,", var_8_0, arg_8_3)
	Level.trigger_event(self._level, var_8_0)
end

NetworkedFlowStateManager.flow_cb_networked_story_client_call = function (self, arg_9_1)
	-- function 9
	local _client_call_data = self._client_call_data

	self._client_call_data = nil

	fn("Story %q client call (client).", arg_9_1.client_call_event_name)

	return _client_call_data
end

NetworkedFlowStateManager.flow_cb_stop_networked_story = function (self, arg_10_1)
	-- function 10
	if not self._is_client then
		return nil
	end

	local client_call_event_name = arg_10_1.client_call_event_name

	fn("Stopping story %q (server).", client_call_event_name)

	local var_10_1 = self._playing_stories[client_call_event_name]

	if not var_10_1 then
		fn("Story canceled: called stop before play %q (server).", client_call_event_name)

		self._canceled_stories[client_call_event_name] = arg_10_1

		return nil
	end

	local time = self._storyteller:time(var_10_1.id)

	var_10_1.stop_time = time

	Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_state_story_stopped", self._story_lookup[client_call_event_name], time)

	return {
		stop_out = true
	}
end

NetworkedFlowStateManager.rpc_flow_state_story_stopped = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0 = self._story_lookup[arg_11_2]

	fn("Story %q has_stopped via rpc (client).", var_11_0)

	self._client_call_data = {
		stop_out = true
	}

	Level.trigger_event(self._level, var_11_0)

	self._client_call_data = {
		play_out = true,
		time_out = arg_11_3
	}

	Level.trigger_event(self._level, var_11_0)

	self._client_call_data = {
		stop_out = true
	}

	Level.trigger_event(self._level, var_11_0)
end

NetworkedFlowStateManager.flow_cb_has_stopped_networked_story = function (self, arg_12_1)
	-- function 12
	if not self._is_client then
		return nil
	end

	local client_call_event_name = arg_12_1.client_call_event_name
	local var_12_1 = self._playing_stories[client_call_event_name]

	fassert(var_12_1, "[NetworkedFlowStateManager] Networked story with client call event name %q which is not running is reported as stopped.", client_call_event_name)

	var_12_1.stopped = true

	fn("Story %q has_stopped (server).", client_call_event_name)
end

NetworkedFlowStateManager.flow_cb_has_played_networked_story = function (self, arg_13_1)
	-- function 13
	if not self._is_client then
		return nil
	end

	local client_call_event_name = arg_13_1.client_call_event_name
	local var_13_1 = self._playing_stories[client_call_event_name]

	fassert(var_13_1, "[NetworkedFlowStateManager] Networked story with client call event name %q which is not running is reported as running.", client_call_event_name)
	fn("Story %q has_played (server).", client_call_event_name)

	local story_id = arg_13_1.story_id

	var_13_1.id = story_id
	var_13_1.length = self._storyteller:length(story_id)

	if not self._canceled_stories[client_call_event_name] then
		fn("stopping story due to cancel %q (server).", client_call_event_name)

		local flow_cb_stop_networked_story = self:flow_cb_stop_networked_story(self._canceled_stories[client_call_event_name])

		self._canceled_stories[client_call_event_name] = nil

		return flow_cb_stop_networked_story
	end
end

NetworkedFlowStateManager.hot_join_sync = function (self, arg_14_1)
	-- function 14
	self:_sync_states(arg_14_1)
	self:_sync_stories(arg_14_1)
end

NetworkedFlowStateManager._sync_stories = function (self, arg_15_1)
	-- function 15
	local _storyteller = self._storyteller

	fn("Hot join syncing peer %s", arg_15_1)

	for k, v in pairs(self._playing_stories) do
		local var_15_1
		local stopped = v.stopped
		local story_time = NetworkConstants.story_time
		local var_15_4 = PEER_ID_TO_CHANNEL[arg_15_1]

		if not stopped then
			local rpc_flow_state_story_stopped = RPC.rpc_flow_state_story_stopped
			local var_15_6 = var_15_4
			local var_15_7 = self._story_lookup[k]
			local clamp = math.clamp
			local stop_time = v.stop_time

			stop_time = stop_time or v.length

			rpc_flow_state_story_stopped(var_15_6, var_15_7, clamp(stop_time, story_time.min, story_time.max))
		else
			RPC.rpc_flow_state_story_played(var_15_4, self._story_lookup[k], math.clamp(_storyteller:time(v.id), story_time.min, story_time.max))
		end

		fn("Story %q being hot join synced to peer %s (server).", k, arg_15_1)
	end
end

NetworkedFlowStateManager._sync_states = function (self, arg_16_1)
	-- function 16
	local network = Managers.state.network

	for k, v in pairs(self._object_states) do
		if not Unit.alive(k) then
			local game_object_or_level_id, var_16_2 = network:game_object_or_level_id(k)
			local var_16_3 = PEER_ID_TO_CHANNEL[arg_16_1]

			for k_2, v_2 in pairs(v.states) do
				local value = v_2.value

				if value ~= v_2.default_value then
					local var_16_5 = v.lookup[k_2]
					local var_16_6 = tbl[type(value)]
					local _clamp_state = self:_clamp_state(k_2, var_16_6, value, k)

					RPC[var_16_6.rpcs.change](var_16_3, game_object_or_level_id, var_16_5, _clamp_state, true, not var_16_2)
				end
			end
		end
	end
end

NetworkedFlowStateManager.set_level = function (self, arg_17_1)
	-- function 17
	self._level = arg_17_1
end

NetworkedFlowStateManager.flow_cb_create_state = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	-- function 18
	fassert(Unit.alive(arg_18_1), "[NetworkedFlowStateManager] Passing destroyed unit into create flow state for state_name %q", arg_18_2)
	fassert(self._num_states < self._max_states, "[NetworkedFlowStateManager] Too many object states(%i).", self._max_states)

	local _object_states = self._object_states
	local var_18_1 = _object_states[arg_18_1]

	var_18_1 = var_18_1 or {
		lookup = {},
		states = {}
	}

	if not var_18_1.states[arg_18_2] then
		return
	end

	local num = #var_18_1.lookup + 1

	var_18_1.lookup[arg_18_2] = num
	var_18_1.lookup[num] = arg_18_2
	var_18_1.states[arg_18_2] = {
		value = arg_18_3,
		default_value = arg_18_3,
		client_state_changed_event = arg_18_4,
		client_state_set_event = arg_18_5,
		state_network_id = num,
		is_game_object = arg_18_6 or false
	}
	_object_states[arg_18_1] = var_18_1
	self._num_states = self._num_states + 1

	return true, arg_18_3
end

NetworkedFlowStateManager.flow_cb_get_state = function (self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = self._object_states[arg_19_1]
	local flag = not var_19_0 and var_19_0.states[arg_19_2]

	fassert(flag ~= nil, "[NetworkedFlowStateManager] State %s doesn't exists in unit %s", arg_19_2, Unit.debug_name(arg_19_1))

	return flag.value
end

NetworkedFlowStateManager.flow_cb_change_state = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	if not self._is_client then
		return
	end

	local _level = self._level

	fassert(_level, "[NetworkedFlowStateManager] Trying to change state %q to %s before level has been created. Feed correct setting on create instead of changing during level spawn.", arg_20_2, tostring(arg_20_3))
	fassert(Unit.alive(arg_20_1), "[NetworkedFlowStateManager] Passing destroyed unit into change state for state_name %q", arg_20_2)

	local var_20_1 = self._object_states[arg_20_1]
	local flag = not var_20_1 and var_20_1.states[arg_20_2]

	fassert(flag ~= nil, "[NetworkedFlowStateManager] State %q unit %q is being changed but has not yet been created.", arg_20_2, Unit.debug_name(arg_20_1))

	flag.value = arg_20_3

	local game_object_or_level_id = Managers.state.network:game_object_or_level_id(arg_20_1)
	local state_network_id = flag.state_network_id
	local flag_2 = flag ~= arg_20_3

	if not flag_2 then
		local var_20_6 = tbl[type(arg_20_3)]

		arg_20_3 = self:_clamp_state(arg_20_2, var_20_6, arg_20_3, arg_20_1)

		local network_transmit = Managers.state.network.network_transmit
		local var_20_8 = network_transmit
		local send_rpc_clients = network_transmit.send_rpc_clients
		local change = var_20_6.rpcs.change
		local var_20_11 = game_object_or_level_id
		local var_20_12 = state_network_id
		local var_20_13 = arg_20_3
		local flag_3 = false
		local is_game_object = flag.is_game_object

		is_game_object = is_game_object or false

		send_rpc_clients(var_20_8, change, var_20_11, var_20_12, var_20_13, flag_3, is_game_object)
	end

	return flag_2, arg_20_3
end

NetworkedFlowStateManager._clamp_state = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local network_constant = arg_21_2.network_constant

	network_constant = not network_constant and NetworkConstants[arg_21_2.network_constant]

	if not (not network_constant and arg_21_3 < network_constant.min or not (arg_21_3 > network_constant.max)) then
		arg_21_3 = math.max(network_constant.min, math.min(network_constant.max, arg_21_3))

		Application.warning("[NetworkedFlowStateManager] Networked Flow State %q value %f out of bounds [%f..%f] (%s)", arg_21_1, arg_21_3, network_constant.min, network_constant.max, Unit.debug_name(arg_21_4))
	end

	return arg_21_3
end

NetworkedFlowStateManager.client_flow_state_changed = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_22_1, not arg_22_5)
	local var_22_1 = self._object_states[game_object_or_level_unit]

	fassert(var_22_1, "[NetworkedFlowStateManager] Trying to change state for unit %q on client despite network flow state node not having been created on client.", tostring(game_object_or_level_unit))

	local var_22_2 = var_22_1.lookup[arg_22_2]
	local var_22_3 = var_22_1.states[var_22_2]

	if not script_data.debug_client_flow_state then
		printf("client flow state %q changed, old value: %s, new value: %s", var_22_2, tostring(var_22_3.value), tostring(arg_22_3))
	end

	var_22_3.value = arg_22_3

	local client_state_set_event

	if not arg_22_4 then
		client_state_set_event = var_22_3.client_state_set_event

		if not client_state_set_event then
			-- Nothing
		end
	end

	client_state_set_event = var_22_3.client_state_changed_event

	::label_22_0::

	Unit.flow_event(game_object_or_level_unit, client_state_set_event)
end

NetworkedFlowStateManager.rpc_flow_state_bool_changed = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	-- function 23
	self:client_flow_state_changed(arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
end

NetworkedFlowStateManager.rpc_flow_state_number_changed = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	self:client_flow_state_changed(arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
end

NetworkedFlowStateManager.clear_object_state = function (arg_25_0, arg_25_1)
	-- function 25
	arg_25_0._object_states[arg_25_1] = nil
end
