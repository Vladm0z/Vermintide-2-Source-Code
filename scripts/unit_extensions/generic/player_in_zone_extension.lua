-- chunkname: @scripts/unit_extensions/generic/player_in_zone_extension.lua

PlayerInZoneExtension = class(PlayerInZoneExtension)

PlayerInZoneExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._unit = arg_1_2

	self:_get_script_data()

	self._world = arg_1_1.world
	self._extension_init_context = arg_1_1
	self._activated = false
	self._state = "_idle"
	self._client_state = "progress_inactive"
	self._is_server = arg_1_1.is_server
	self._state_data = {}
	self._closest_player_distance = math.huge
	self._player_distances = {}
	self._progress_time = 0
	self._unit_in_progress = false
	self._state_data.end_progression_timer = 0
	self._progress_is_frozen = false
	self._game = Managers.state.network:game()
	self._has_register_count_up = false
	self._has_been_in_zone = false
	self._progression_percentage = {}

	for i = 1, 3 do
		self._progression_percentage[i * 25] = false
	end
end

PlayerInZoneExtension._get_script_data = function (self)
	-- function 2
	self._num_player_in_zone = Unit.get_data(self._unit, "player_in_zone", "num_player_in_zone")
	self._animation_time = Unit.get_data(self._unit, "player_in_zone", "start_stop_animation_time")
	self._timer = Unit.get_data(self._unit, "player_in_zone", "timer")
	self._progress_bar_countdown = Unit.get_data(self._unit, "player_in_zone", "progression_countdown")
	self._progress_bar_smooth_back = Unit.get_data(self._unit, "player_in_zone", "progress_bar_smooth_back")
	self._progress_bar_freeze = Unit.get_data(self._unit, "player_in_zone", "progress_bar_freeze")
	self._show_progress_bar_global = Unit.get_data(self._unit, "player_in_zone", "show_progress_bar_global")
	self._show_progress_bar_personal = Unit.get_data(self._unit, "player_in_zone", "show_progress_bar_personal")
	self._progress_zone_size = Unit.get_data(self._unit, "player_in_zone", "zone_radius")

	local get_data

	if not Unit.has_data(self._unit, "player_in_zone", "time_modifier_per_player") then
		get_data = Unit.get_data(self._unit, "player_in_zone", "time_modifier_per_player")

		if not get_data then
			-- Nothing
		end
	end

	get_data = 0

	::label_2_0::

	self._time_modifier_per_player = get_data

	local flag = Unit.get_data(self._unit, "player_in_zone", "player_side") or "heroes"

	self._player_units = Managers.state.side:get_side_from_name(flag).PLAYER_UNITS
end

PlayerInZoneExtension._create_game_object = function (self)
	-- function 3
	local current_level = LevelHelper:current_level(self._world)

	self._level_unit_index = Level.unit_index(current_level, self._unit)

	local tbl = {
		progress_time = 0,
		go_type = NetworkLookup.go_types.progress_timer,
		level_unit_index = self._level_unit_index,
		unit_in_progress = self._unit_in_progress,
		progress_is_frozen = self._progress_is_frozen,
		counting_up = self._progress_bar_countdown
	}
	local var_3_2 = callback(self, "cb_game_session_disconnect")

	self._go_id = Managers.state.network:create_game_object("progress_timer", tbl, var_3_2)
end

PlayerInZoneExtension.cb_game_session_disconnect = function (self)
	-- function 4
	self._go_id = nil
end

PlayerInZoneExtension.on_game_object_created = function (self, arg_5_1)
	-- function 5
	self._go_id = arg_5_1
end

PlayerInZoneExtension.on_game_object_destroyed = function (self)
	-- function 6
	self._go_id = nil
end

PlayerInZoneExtension.extensions_ready = function (self)
	-- function 7
	if not self._is_server then
		return
	end

	if not Managers.state.network:in_game_session() then
		self:_create_game_object()
	else
		self._waiting_for_game_session = true
	end
end

PlayerInZoneExtension.activated = function (self)
	-- function 8
	return self._activated
end

PlayerInZoneExtension._current_time = function (self)
	-- function 9
	return self._state_data.end_progression_timer
end

PlayerInZoneExtension.should_progress_count_down = function (self)
	-- function 10
	return self._progress_bar_countdown
end

PlayerInZoneExtension.progress_bar_personal = function (self)
	-- function 11
	return self._show_progress_bar_personal
end

PlayerInZoneExtension.progress_bar_global = function (self)
	-- function 12
	return self._show_progress_bar_global
end

PlayerInZoneExtension.player_been_in_zone = function (self)
	-- function 13
	return self._has_been_in_zone
end

PlayerInZoneExtension.progress = function (self)
	-- function 14
	return self._state_data.end_progression_timer
end

PlayerInZoneExtension.update = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not self._activated then
		return
	end

	self:_update_distances()

	if not self._is_server then
		self:_update_state(arg_15_3, arg_15_5)
	else
		self:_update_client(arg_15_3)
	end
end

PlayerInZoneExtension._update_client = function (self, arg_16_1)
	-- function 16
	local _go_id = self._go_id

	if not _go_id then
		return
	end

	local _game = self._game
	local game_object_field = GameSession.game_object_field(_game, _go_id, "progress_time")
	local game_object_field_2 = GameSession.game_object_field(_game, _go_id, "unit_in_progress")
	local game_object_field_3 = GameSession.game_object_field(_game, _go_id, "counting_up")
	local game_object_field_4 = GameSession.game_object_field(_game, _go_id, "progress_is_frozen")
	local _client_state = self._client_state

	if _client_state == "progress_inactive" then
		if not game_object_field_2 then
			self._client_state = "progress_active"
			self._state_data.end_progression_timer = game_object_field

			self:_trigger_start_events()
		end
	elseif _client_state == "progress_active" then
		if self._has_been_in_zone or not self:_local_player_in_zone() then
			self._has_been_in_zone = true
		end

		if not game_object_field_4 then
			self._state_data.end_progression_timer = game_object_field
		else
			self:_client_progress(game_object_field_3, game_object_field, arg_16_1)
		end

		if not game_object_field_2 then
			self._client_state = "progress_inactive"

			self:_client_unit_inactive(game_object_field)
		end
	end

	self:_check_progress_percent(self._state_data.end_progression_timer)
end

PlayerInZoneExtension._client_unit_inactive = function (self, arg_17_1)
	-- function 17
	self._state_data.end_progression_timer = arg_17_1
	self._progress_time = arg_17_1
	self._has_been_in_zone = false

	self:_trigger_stop_events()
end

PlayerInZoneExtension._client_progress = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not arg_18_1 then
		local _fulfill_in_zone_check, var_18_1 = self:_fulfill_in_zone_check()

		self._state_data.end_progression_timer = self:_count_up(arg_18_3, var_18_1)
	else
		self._state_data.end_progression_timer = self:_count_down(arg_18_3)
	end
end

PlayerInZoneExtension.set_active = function (self)
	-- function 19
	if not self._activated then
		return
	end

	local network = Managers.state.network
	local unit_index = LevelHelper:unit_index(self._world, self._unit)

	if not self._is_server then
		if not unit_index then
			network.network_transmit:send_rpc_clients("rpc_player_in_zone_set_active", unit_index)
		end
	elseif not unit_index then
		network.network_transmit:send_rpc_server("rpc_player_in_zone_set_active", unit_index)
	end

	self:set_active_rpc()
end

PlayerInZoneExtension.set_active_rpc = function (self)
	-- function 20
	self._activated = true
end

PlayerInZoneExtension._update_state = function (self, arg_21_1, arg_21_2)
	-- function 21
	self[self._state](self, arg_21_1, arg_21_2, self._state_data)
end

PlayerInZoneExtension.hot_join_sync = function (self, arg_22_1)
	-- function 22
	if not self._activated then
		local network = Managers.state.network
		local unit_index = LevelHelper:unit_index(self._world, self._unit)

		if not unit_index then
			network.network_transmit:send_rpc("rpc_player_in_zone_set_active", arg_22_1, unit_index)
		end
	end
end

PlayerInZoneExtension.destroy = function (arg_23_0)
	-- function 23
	Managers.state.network.network_transmit.network_event_delegate:unregister(arg_23_0)
end

PlayerInZoneExtension._update_distances = function (self)
	-- function 24
	local local_position = Unit.local_position(self._unit, 0)
	local _player_units = self._player_units
	local _player_distances = self._player_distances

	table.clear(_player_distances)

	local huge = math.huge

	for k, v in pairs(_player_units) do
		local var_24_4 = POSITION_LOOKUP[v]

		if not var_24_4 then
			local distance_squared = Vector3.distance_squared(local_position, var_24_4)

			if distance_squared < huge then
				huge = distance_squared
			end

			_player_distances[v] = distance_squared
		end
	end

	self._closest_player_distance = huge
end

PlayerInZoneExtension._idle = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not self:_fulfill_in_zone_check() then
		self._state = "_progress_check"
	end
end

PlayerInZoneExtension._fulfill_in_zone_check = function (self)
	-- function 26
	local num = self._progress_zone_size * self._progress_zone_size

	if not (num >= self._closest_player_distance) then
		return false, 0
	end

	local num_2 = 0
	local num_3 = 0

	for k, v in pairs(self._player_distances) do
		num_3 = num_3 + 1

		if v < num then
			num_2 = num_2 + 1
		end
	end

	return num_3 == num_2 or num_2 >= self._num_player_in_zone, num_2
end

PlayerInZoneExtension._local_player_in_zone = function (self)
	-- function 27
	local local_player = Managers.player:local_player()

	if not local_player then
		return false
	end

	local player_unit = local_player.player_unit

	if not player_unit then
		return false
	end

	local var_27_2 = self._player_distances[player_unit]

	if not var_27_2 then
		return false
	end

	if var_27_2 > self._progress_zone_size * self._progress_zone_size then
		return false
	end

	return true
end

PlayerInZoneExtension._progress_frozen = function (self)
	-- function 28
	local _fulfill_in_zone_check, var_28_1 = self:_fulfill_in_zone_check()

	if not _fulfill_in_zone_check then
		self._state = "_progress_check"
	end

	local _go_id = self._go_id
	local _game = self._game

	if not (not _go_id and GameSession.game_object_field(_game, _go_id, "progress_is_frozen")) then
		GameSession.set_game_object_field(_game, _go_id, "progress_is_frozen", true)
	end
end

PlayerInZoneExtension._progress_check = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _go_id = self._go_id
	local _game = self._game
	local var_29_2

	if not self._progress_check_entered then
		self._progress_check_entered = true

		if not _go_id then
			if not GameSession.game_object_field(_game, _go_id, "unit_in_progress") then
				GameSession.set_game_object_field(_game, _go_id, "unit_in_progress", true)
			end

			if not GameSession.game_object_field(_game, _go_id, "progress_is_frozen") then
				GameSession.set_game_object_field(_game, _go_id, "progress_is_frozen", false)
			end
		end

		self:_trigger_start_events()
	end

	local _fulfill_in_zone_check, var_29_4 = self:_fulfill_in_zone_check()

	if not _fulfill_in_zone_check then
		if not self._has_register_count_up then
			self._has_register_count_up = true

			self:_register_count_up(true)
		end

		if self._has_been_in_zone or not self:_local_player_in_zone() then
			self._has_been_in_zone = true
		end

		self._state_data.end_progression_timer = self:_count_up(arg_29_1, var_29_4)

		if self._state_data.end_progression_timer == 1 then
			var_29_2 = "_progress_finished"
		end
	else
		if not self._progress_bar_smooth_back then
			if not self._has_register_count_up then
				self._has_register_count_up = false

				self:_register_count_up(false)
			end

			self._state_data.end_progression_timer = self:_count_down(arg_29_1)
		elseif not self._progress_bar_freeze then
			var_29_2 = "_progress_frozen"
		else
			self._state_data.end_progression_timer = 0
		end

		if self._state_data.end_progression_timer == 0 then
			if not _go_id and not GameSession.game_object_field(_game, _go_id, "unit_in_progress") then
				GameSession.set_game_object_field(_game, _go_id, "unit_in_progress", false)
			end

			var_29_2 = "_idle"
		end
	end

	self:_check_progress_percent(self._state_data.end_progression_timer)

	if not _go_id then
		GameSession.set_game_object_field(_game, _go_id, "progress_time", self._state_data.end_progression_timer)
	end

	if not var_29_2 then
		if var_29_2 ~= "_progress_frozen" then
			self._has_been_in_zone = false

			self:_trigger_stop_events()
		end

		self._progress_check_entered = nil
		self._state = var_29_2
	end
end

PlayerInZoneExtension._progress_finished = function (self)
	-- function 30
	local network = Managers.state.network
	local unit_index = LevelHelper:unit_index(self._world, self._unit)

	network.network_transmit:send_rpc_clients("rpc_player_in_zone_end_event", unit_index)
	self:end_event()
end

PlayerInZoneExtension._trigger_start_events = function (self)
	-- function 31
	Managers.state.event:trigger("start_progression_zone", self._unit, self)
	Unit.flow_event(self._unit, "lua_start_progression")
end

PlayerInZoneExtension._trigger_stop_events = function (self)
	-- function 32
	Managers.state.event:trigger("stop_progression_zone", self._unit, self)
	Unit.flow_event(self._unit, "lua_stop_progression")
end

PlayerInZoneExtension._check_progress_percent = function (self, arg_33_1)
	-- function 33
	local _progression_percentage = self._progression_percentage
	local _unit = self._unit

	for k, v in pairs(self._progression_percentage) do
		local num = k / 100

		if not (not (num < arg_33_1) or v) then
			Unit.flow_event(_unit, "lua_check_progression_" .. k .. "_start")

			_progression_percentage[k] = true
		elseif not (arg_33_1 < num) or not v then
			Unit.flow_event(_unit, "lua_check_progression_" .. k .. "_stop")

			_progression_percentage[k] = false
		end
	end
end

PlayerInZoneExtension._count_up = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _timer = self._timer
	local num = 1

	if not (not arg_34_2 and not (arg_34_2 > 1)) then
		num = num + self._time_modifier_per_player * arg_34_2
	end

	return math.clamp(self:_current_time() + arg_34_1 / _timer * num, 0, 1)
end

PlayerInZoneExtension._count_down = function (self, arg_35_1)
	-- function 35
	local _timer = self._timer

	return math.clamp(self:_current_time() - arg_35_1 / _timer, 0, 1)
end

PlayerInZoneExtension._reset = function (self)
	-- function 36
	self._activated = false

	Managers.state.event:trigger("stop_progression_zone", self._unit)

	self._state_data.end_progression_timer = 0

	self:_check_progress_percent(self._state_data.end_progression_timer)

	if not self._is_server then
		local _go_id = self._go_id

		if not _go_id then
			local _game = self._game

			GameSession.set_game_object_field(_game, _go_id, "progress_time", self._state_data.end_progression_timer)
		end
	end
end

PlayerInZoneExtension.end_event = function (self)
	-- function 37
	self:_reset()
	Unit.flow_event(self._unit, "lua_start_end_event")
end

PlayerInZoneExtension._register_count_up = function (self, arg_38_1)
	-- function 38
	local _go_id = self._go_id
	local _game = self._game

	GameSession.set_game_object_field(_game, _go_id, "counting_up", arg_38_1)
end

PlayerInZoneExtension._debug_drawer = function (self, arg_39_1)
	-- function 39
	if arg_39_1 == "counting" then
		local _drawer = self._drawer

		_drawer = _drawer or Managers.state.debug:drawer({
			mode = "immediate"
		})
		self._drawer = _drawer

		self._drawer:reset()

		local end_progression_timer = self._state_data.end_progression_timer
		local num = math.lerp(1, 0, end_progression_timer) * 255
		local num_2 = math.lerp(0, 1, end_progression_timer) * 255

		self._drawer:sphere(Unit.local_position(self._unit, 0), self._progress_zone_size, Color(num, num_2, 0), 30, 30)
	elseif arg_39_1 == "stop" then
		local _drawer_2 = self._drawer

		_drawer_2 = _drawer_2 or Managers.state.debug:drawer({
			mode = "immediate"
		})
		self._drawer = _drawer_2

		self._drawer:reset()
		self._drawer:sphere(Unit.local_position(self._unit, 0), self._progress_zone_size, Color(255, 255, 0), 10, 10)
	elseif arg_39_1 == "idle" then
		local _drawer_3 = self._drawer

		_drawer_3 = _drawer_3 or Managers.state.debug:drawer({
			mode = "immediate"
		})
		self._drawer = _drawer_3

		self._drawer:reset()
		self._drawer:sphere(Unit.local_position(self._unit, 0), self._progress_zone_size, Color(255, 255, 0), 30, 30)
	end
end
