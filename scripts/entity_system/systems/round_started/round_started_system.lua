-- chunkname: @scripts/entity_system/systems/round_started/round_started_system.lua

RoundStartedSystem = class(RoundStartedSystem, ExtensionSystemBase)

local tbl = {
	"RoundStartedExtension"
}
local tbl_2 = {
	"rpc_round_started"
}

RoundStartedExtension = class(RoundStartedExtension)

RoundStartedExtension.init = function (arg_1_0)
	-- function 1
	return
end

RoundStartedExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

RoundStartedSystem.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	arg_3_1.entity_manager:register_system(self, arg_3_2, tbl)

	self._is_server = arg_3_1.is_server
	self._world = arg_3_1.world
	self._network_event_delegate = arg_3_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))

	self._start_area = "start_area"
	self._round_started = false
	self._player_spawned = false
	self._units = {}
	self._player_moved_positions = {}
end

RoundStartedSystem.destroy = function (self)
	-- function 4
	self._network_event_delegate:unregister(self)
end

RoundStartedSystem.set_start_area = function (self, arg_5_1)
	-- function 5
	local current_level = LevelHelper:current_level(self._world)
	local level_name = LevelHelper:current_level_settings(self._world).level_name

	self._start_area = arg_5_1
end

RoundStartedSystem.on_add_extension = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	ScriptUnit.add_extension(nil, arg_6_2, "RoundStartedExtension", self.NAME, arg_6_4)

	local extension = ScriptUnit.extension(arg_6_2, self.NAME)

	self._units[arg_6_2] = extension

	return extension
end

RoundStartedSystem.on_remove_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	ScriptUnit.remove_extension(arg_7_1, self.NAME)

	self._units[arg_7_1] = nil
end

RoundStartedSystem.hot_join_sync = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

RoundStartedSystem.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._round_started then
		return
	end

	self:_update_player_moved()

	if not self._is_server then
		return
	end

	if self:_players_left_start_area() or not self._force_start_round then
		Managers.state.game_mode:round_started()

		local score_type = LevelHelper:current_level_settings().score_type

		if not score_type then
			local tbl = {
				start_time = arg_9_2
			}

			Managers.state.entity:system("leaderboard_system"):round_started(score_type, tbl)
		end

		self:_on_round_started()
	end
end

RoundStartedSystem._players_left_start_area = function (self)
	-- function 10
	local checkpoint_data = Managers.state.spawn:checkpoint_data()
	local safe_zone_volume_name

	if not checkpoint_data then
		safe_zone_volume_name = checkpoint_data.safe_zone_volume_name

		if not safe_zone_volume_name then
			-- Nothing
		end
	end

	safe_zone_volume_name = self._start_area

	::label_10_0::

	local current_level = LevelHelper:current_level(self._world)

	if not Level.has_volume(current_level, safe_zone_volume_name) then
		if not script_data.debug_level then
			Application.warning("Level is missing start area.")
		end

		return self._player_spawned
	end

	for k, v in pairs(self._units) do
		local var_10_3 = POSITION_LOOKUP[k]

		if not Level.is_point_inside_volume(current_level, safe_zone_volume_name, var_10_3) then
			return true
		end
	end

	return false
end

RoundStartedSystem.player_spawned = function (self)
	-- function 11
	self._player_spawned = true
end

RoundStartedSystem.player_has_moved = function (self)
	-- function 12
	return self._player_moved
end

RoundStartedSystem.round_has_started = function (self)
	-- function 13
	return self._round_started
end

RoundStartedSystem._update_player_moved = function (self)
	-- function 14
	if not self._player_moved then
		return true
	end

	local _player_moved_positions = self._player_moved_positions
	local num = 2
	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		local player_unit = v.player_unit
		local var_14_4 = POSITION_LOOKUP[player_unit]

		if not var_14_4 then
			local var_14_5 = _player_moved_positions[player_unit]

			var_14_5 = var_14_5 or Vector3Box(var_14_4)
			_player_moved_positions[player_unit] = var_14_5

			if Vector3.distance_squared(var_14_4, _player_moved_positions[player_unit]:unbox()) > num^2 then
				self._player_moved = true

				return true
			end
		end
	end
end

RoundStartedSystem._on_round_started = function (self)
	-- function 15
	self._round_started = true
	self._player_moved = true

	Managers.state.achievement:trigger_event("on_round_started")

	if not self._is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_round_started")
	end
end

RoundStartedSystem.rpc_round_started = function (self)
	-- function 16
	self:_on_round_started()
end

RoundStartedSystem.force_start_round = function (self)
	-- function 17
	self._force_start_round = true
end
