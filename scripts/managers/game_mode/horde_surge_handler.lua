-- chunkname: @scripts/managers/game_mode/horde_surge_handler.lua

HordeSurgeHandler = class(HordeSurgeHandler)

local tbl = {
	"rpc_horde_surge_freeze",
	"rpc_horde_surge_set_level"
}

HordeSurgeHandler.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._is_server = arg_1_1
	self._world = arg_1_2

	if not arg_1_3 then
		self.disabled = true
	end

	self._events = arg_1_3
	self._current_event = nil
	self._seed = arg_1_4
	self._level_index = 0
	self._current_terror_event_index = 0
	self._end_time = nil
	self._start_time = 0
	self._freeze_time = 0
	self._frozen = false
	self._active = arg_1_5
	self._first_update = true
	self._time_modifier = 1
	self._game_object_id = nil
	self._progress = 0
	self._time_to_next = 0
	self._current_terror_event = nil

	if not self._is_server then
		local tbl = {
			progress = 0,
			go_type = NetworkLookup.go_types.horde_surge
		}

		self._game_object_id = Managers.state.network:create_game_object("horde_surge", tbl)
	else
		self._target_progress = 0
		self._time_until_next_update = 0
		self._last_update_time = 0
	end
end

HordeSurgeHandler.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
	self._network_transmit = arg_2_2
end

HordeSurgeHandler.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

HordeSurgeHandler.destroy = function (self)
	-- function 4
	if not self._is_server then
		local game_session = Network.game_session()

		GameSession.destroy_game_object(game_session, self._game_object_id)
	end
end

HordeSurgeHandler.server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._active and not self._game_object_id and script_data.disable_horde_surge or not self.disabled then
		return
	end

	local game_session = Network.game_session()

	if not game_session then
		return
	end

	local flag = self._freeze_time ~= 0

	if flag or not self._events then
		if not self._first_update then
			self:_next_level(arg_5_1, game_session)

			self._first_update = false
		end

		if arg_5_1 > self._end_time then
			self:_trigger_event()
			self:_next_level(arg_5_1, game_session)
		end

		self._time_to_next = self._end_time - arg_5_1
		self._progress = (arg_5_1 - self._start_time) / (self._end_time - self._start_time) * 100

		GameSession.set_game_object_field(game_session, self._game_object_id, "progress", self._progress)
	else
		self._freeze_time = math.max(self._freeze_time - arg_5_2, 0)
	end

	self._frozen = flag
end

HordeSurgeHandler.client_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._game_object_id and script_data.disable_horde_surge or not self.disabled then
		return
	end

	local game_session = Network.game_session()

	if not game_session then
		return
	end

	local game_object_field = GameSession.game_object_field(game_session, self._game_object_id, "progress")

	if game_object_field < self._target_progress then
		self._target_progress = 0
		self._progress = 0
	end

	if game_object_field ~= self._target_progress then
		self._progress = self._target_progress
		self._target_progress = game_object_field
		self._time_until_next_update = arg_6_1 - self._last_update_time
		self._last_update_time = arg_6_1
	end

	if self._progress ~= self._target_progress then
		local num = self._target_progress - self._progress

		self._progress = math.min(self._progress + num / self._time_until_next_update * arg_6_2, self._target_progress)
		self._time_until_next_update = self._time_until_next_update - arg_6_2
	end

	self._time_to_next = math.max(0, self._time_to_next - arg_6_2)

	if not self._frozen then
		self._freeze_time = math.max(0, self._freeze_time - arg_6_2)

		if self._freeze_time == 0 then
			self._frozen = false
		end
	end
end

HordeSurgeHandler._trigger_event = function (self)
	-- function 7
	local tbl = {}
	local next_random, var_7_2 = Math.next_random(self._seed, 1, #self._current_event.terror_events)

	self._seed = next_random

	local var_7_3 = self._current_event.terror_events[var_7_2]

	TerrorEventMixer.start_event(var_7_3, tbl)

	self._current_terror_event = var_7_3
	self._current_terror_event_index = var_7_2
end

HordeSurgeHandler._next_level = function (self, arg_8_1, arg_8_2)
	-- function 8
	fassert(self._is_server, "This should only be called on the server")

	if not self._events[self._level_index + 1] then
		self._level_index = self._level_index + 1
		self._current_event = self._events[self._level_index]
	else
		self._time_modifier = math.max(self._time_modifier * 0.9, 0.5)
	end

	local num = self._current_event.time * self._time_modifier

	self._start_time = arg_8_1
	self._end_time = arg_8_1 + num

	Managers.state.event:trigger("horde_surge_level_changed", self._level_index)
	self._network_transmit:send_rpc_clients("rpc_horde_surge_set_level", self._level_index, self._current_terror_event_index, self._time_to_next)
end

HordeSurgeHandler.freeze_timer = function (self, arg_9_1)
	-- function 9
	fassert(self._is_server, "This should only be called on the server")

	if not self._frozen then
		arg_9_1 = arg_9_1 - self._freeze_time
	end

	self._freeze_time = self._freeze_time + arg_9_1
	self._end_time = self._end_time + arg_9_1
	self._start_time = self._start_time + arg_9_1

	self._network_transmit:send_rpc_clients("rpc_horde_surge_freeze", self._freeze_time)
end

HordeSurgeHandler.activate = function (self)
	-- function 10
	self._active = true
end

HordeSurgeHandler.deactivate = function (self)
	-- function 11
	self._active = false
end

HordeSurgeHandler.get_progress = function (self)
	-- function 12
	return self._progress
end

HordeSurgeHandler.get_freeze_time = function (self)
	-- function 13
	return self._freeze_time
end

HordeSurgeHandler.is_frozen = function (self)
	-- function 14
	return self._frozen
end

HordeSurgeHandler.get_level = function (self)
	-- function 15
	return self._level_index
end

HordeSurgeHandler.rpc_horde_surge_freeze = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._freeze_time = arg_16_2
	self._frozen = true
end

HordeSurgeHandler.rpc_horde_surge_set_level = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	self._level_index = arg_17_2

	if arg_17_3 ~= 0 then
		self._current_terror_event_index = arg_17_3
		self._current_terror_event = self._events[arg_17_2 - 1].terror_events[arg_17_3]
	end

	self._time_to_next = arg_17_4

	Managers.state.event:trigger("horde_surge_changed_level", arg_17_2)
end

HordeSurgeHandler.hot_join_sync = function (self, arg_18_1)
	-- function 18
	self._network_transmit:send_rpc("rpc_horde_surge_set_level", arg_18_1, self._level_index, self._current_terror_event_index, self._time_to_next)

	if not self._frozen then
		self._network_transmit:send_rpc("rpc_horde_surge_freeze", arg_18_1, self._freeze_time)
	end
end
