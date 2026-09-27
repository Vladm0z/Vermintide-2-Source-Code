-- chunkname: @scripts/unit_extensions/level/rotating_hazard_extension.lua

RotatingHazardExtension = class(RotatingHazardExtension)

local pi = math.pi
local num = pi * 2
local num_2 = 1
local num_3 = 2
local num_4 = 3
local tbl = {
	damage_entry = 40,
	random_direction = true,
	anticipation_delay = 5,
	random_start_rotation = true,
	damage_tick = 15,
	rotation_speed = 10,
	damage_tick_rate = 0.5,
	buffs_on_entry = {
		"wall_slow_debuff"
	},
	buffs_on_tick = {
		"wall_slow_debuff"
	},
	starting_state = num_4,
	areas = {
		{
			angle_offset = 0,
			height_min = -1,
			length = 35,
			height_max = 5,
			flow_name = "first",
			width = 10,
			length_offset = 1
		},
		{
			height_min = -1,
			length = 35,
			height_max = 5,
			flow_name = "second",
			width = 10,
			length_offset = 1,
			angle_offset = pi
		}
	},
	init_func = function ()
		-- function 1
		return
	end,
	update_func = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
		-- function 2
		if arg_2_4 == true then
			return
		end

		local num = 7
		local num_3 = 0.3
		local num_4 = 0.55
		local num_5 = 2
		local num_6 = 2
		local num_7 = 0
		local num_8 = 0.3
		local num_9 = 0.4
		local num_10 = pi / 15
		local flag

		flag = arg_2_3 ~= num_2 or not 1 or 0

		local axis_angle = Quaternion.axis_angle(Vector3.up(), arg_2_7 + arg_2_5.angle_offset + math.rad(arg_2_2.rotation_speed) * flag * arg_2_8)
		local forward = Quaternion.forward(axis_angle)
		local local_position = Unit.local_position(arg_2_1, 0)
		local num_11 = arg_2_5.width / 2
		local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
		local last_index = arg_2_6.last_index

		last_index = last_index or 1

		local hand_units_by_player = arg_2_6.hand_units_by_player

		hand_units_by_player = hand_units_by_player or {}
		arg_2_6.hand_units_by_player = hand_units_by_player

		local count = #PLAYER_UNITS
		local flag_2

		flag_2 = not (count <= last_index) or not 0 or last_index

		for i = 0, count - 1 do
			local num_12 = (i + flag_2) % count + 1
			local var_2_20 = PLAYER_UNITS[num_12]
			local var_2_21 = arg_2_6[var_2_20]

			if not (not ALIVE[var_2_20] and not var_2_21 and not (var_2_21 <= arg_2_9)) then
				local var_2_22 = POSITION_LOOKUP[var_2_20]
				local length = Vector3.length(var_2_22 - local_position)
				local min = math.min(length / arg_2_5.length, 1)
				local num_13 = num_11 * min
				local closest_point_on_line = Geometry.closest_point_on_line(var_2_22, local_position + forward * arg_2_5.length_offset, local_position + forward * arg_2_5.length)
				local num_14 = var_2_22 - closest_point_on_line
				local normalize = Vector3.normalize(num_14)
				local length_2 = Vector3.length(num_14)

				if length_2 <= num_13 + num then
					local flag_3 = not (length_2 <= num_13) or not var_2_22 or closest_point_on_line + normalize * num_13
					local normalize_2 = Vector3.normalize(local_position - flag_3)
					local length_3 = Vector3.length(local_position - flag_3)

					if length_3 > arg_2_5.length then
						flag_3 = flag_3 + normalize_2 * (length_3 - arg_2_5.length)
					end

					local clamp = math.clamp(1 - length_2 / num_13, 0, 1)
					local min_2 = math.min(math.lerp(num_4, num_5, clamp), math.max(num_13, num_3))
					local min_3 = math.min(math.max(length_3 - arg_2_5.length_offset, 0), math.max(arg_2_5.length - length_3, 0))
					local min_4 = math.min(math.lerp(num_6, num_7, clamp), min_3)
					local num_15 = flag_3 + normalize_2 * ((math.random() - 0.5) * 2 * min_4)
					local nav_world = Managers.state.entity:system("ai_system"):nav_world()
					local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(nav_world, num_15, 0.1, min_2 * 2, 1, false, nil, nil, 5, 5)

					if not get_spawn_pos_on_circle then
						local up = Vector3.up()
						local multiply = Quaternion.multiply(Quaternion.look(var_2_22 - get_spawn_pos_on_circle, up), Quaternion.axis_angle(up, (math.random() - 0.5) * num_10))
						local spawn_unit = World.spawn_unit(arg_2_0, "units/beings/enemies/undead_skeleton_hand/chr_undead_skeleton_hand", get_spawn_pos_on_circle, multiply)
						local num_16 = 1.75

						Unit.set_local_scale(spawn_unit, 0, Vector3(num_16, num_16, num_16))

						arg_2_6[var_2_20] = arg_2_9 + math.max((0.3 - min) / 0.3, 0) * num_9 + num_8

						local var_2_44 = hand_units_by_player[var_2_20]

						var_2_44 = var_2_44 or {}
						hand_units_by_player[var_2_20] = var_2_44
						var_2_44[spawn_unit] = Unit.animation_find_constraint_target(spawn_unit, "look_at")
						arg_2_6.last_index = num_12

						break
					end
				end
			end
		end

		for k, v in pairs(hand_units_by_player) do
			local var_2_45 = POSITION_LOOKUP[k]

			if not var_2_45 then
				for k_2, v_2 in pairs(v) do
					if not Unit.alive(k_2) then
						v[k_2] = nil
					else
						Unit.animation_set_constraint_target(k_2, v_2, var_2_45)
					end
				end
			else
				hand_units_by_player[k] = nil
			end
		end
	end
}

RotatingHazardExtension.init = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = tbl

	self._settings = var_3_0
	self._unit = arg_3_2
	self._world = arg_3_1.world
	self._is_server = arg_3_1.is_server

	local state = arg_3_3.state

	state = state or var_3_0.starting_state
	self._state = state

	local start_network_time = arg_3_3.start_network_time

	start_network_time = start_network_time or Managers.state.network:network_time()
	self._start_t = start_network_time
	self._pause_t = self._start_t
	self._next_damage_t = 0
	self._last_update_idx = 0
	self._num_areas = #var_3_0.areas
	self._rotation_speed_rad = math.rad(var_3_0.rotation_speed)
	self._start_rotation_offset = 0
	self._rotation_direction = 1
	self._current_seed = Managers.mechanism:get_level_seed()
	self._next_seed = self._current_seed
	self._area_data = {}

	for i = 1, self._num_areas do
		local var_3_3 = var_3_0.areas[i]
		local angular_half_size = var_3_3.angular_half_size

		angular_half_size = angular_half_size or math.atan2(var_3_3.width / 2, var_3_3.length)
		var_3_3.angular_half_size = angular_half_size
		self._area_data[i] = {
			overlapping_units = {}
		}
	end
end

RotatingHazardExtension.hot_join_sync = function (self, arg_4_1)
	-- function 4
	local network = Managers.state.network
	local game_object_or_level_id, var_4_2 = network:game_object_or_level_id(self._unit)

	if not game_object_or_level_id then
		network.network_transmit:send_rpc("rpc_sync_rotating_hazard", arg_4_1, game_object_or_level_id, var_4_2, self._start_t, self._pause_t, self._state, self._current_seed)
	end
end

RotatingHazardExtension.network_sync = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	self._start_t = arg_5_1
	self._pause_t = arg_5_2
	self._state = arg_5_3
	self._is_activating = nil

	if arg_5_3 == num_2 then
		for i = 1, self._num_areas do
			self._area_data[i].last_update_t = nil
		end

		self:_update_random_settings_from_seed(arg_5_4)
	end

	if arg_5_3 == num_4 then
		Unit.flow_event(self._unit, "stop")
	elseif arg_5_3 == num_3 then
		Unit.flow_event(self._unit, "pause")
	end
end

RotatingHazardExtension.destroy = function (arg_6_0)
	-- function 6
	return
end

RotatingHazardExtension.start = function (self, arg_7_1)
	-- function 7
	if not self._is_server and self._state ~= num_2 and not arg_7_1 then
		self._state = num_2
		self._is_activating = nil

		if not arg_7_1 then
			self._start_t = Managers.state.network:network_time()
			self._pause_t = self._start_t

			for i = 1, self._num_areas do
				self._area_data[i].last_update_t = nil
			end

			self:_update_random_settings_from_seed(self._next_seed)
		else
			self._start_t = Managers.state.network:network_time() - (self._pause_t - self._start_t)
		end

		local game_object_or_level_id, var_7_1 = Managers.state.network:game_object_or_level_id(self._unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_rotating_hazard", game_object_or_level_id, var_7_1, self._start_t, self._pause_t, self._state, self._current_seed)
	end
end

RotatingHazardExtension._update_random_settings_from_seed = function (self, arg_8_1)
	-- function 8
	local var_8_0 = arg_8_1
	local var_8_1
	local _settings = self._settings

	if not _settings.random_start_rotation then
		local var_8_3

		var_8_0, var_8_3 = Math.next_random(var_8_0)
		self._start_rotation_offset = num * var_8_3
	end

	if not _settings.random_direction then
		local var_8_4

		var_8_0, var_8_4 = Math.next_random(var_8_0)

		local flag

		flag = not (var_8_4 >= 0.5) or not 1 or -1
		self._rotation_direction = flag
	end

	self._current_seed = arg_8_1
	self._next_seed = var_8_0

	Unit.set_data(self._unit, "rotation_direction", self._rotation_direction)

	for i = 1, self._num_areas do
		local var_8_6 = _settings.areas[i]

		if not var_8_6.flow_name then
			local angular_half_size = var_8_6.angular_half_size
			local angle_offset = var_8_6.angle_offset
			local axis_angle = Quaternion.axis_angle(Vector3.up(), angle_offset + self._rotation_direction * angular_half_size)
			local axis_angle_2 = Quaternion.axis_angle(Vector3.up(), angle_offset)
			local axis_angle_3 = Quaternion.axis_angle(Vector3.up(), angle_offset - self._rotation_direction * angular_half_size)

			Unit.set_data(self._unit, "fx_rotation", "front", var_8_6.flow_name, axis_angle)
			Unit.set_data(self._unit, "fx_rotation", "center", var_8_6.flow_name, axis_angle_2)
			Unit.set_data(self._unit, "fx_rotation", "back", var_8_6.flow_name, axis_angle_3)
		end
	end
end

RotatingHazardExtension.pause = function (self)
	-- function 9
	if not (not self._is_server and self._state ~= num_2) then
		self._state = num_3
		self._is_activating = nil
		self._pause_t = Managers.state.network:network_time()

		local game_object_or_level_id, var_9_1 = Managers.state.network:game_object_or_level_id(self._unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_rotating_hazard", game_object_or_level_id, var_9_1, self._start_t, self._pause_t, self._state, self._current_seed)
		Unit.flow_event(self._unit, "pause")
	end
end

RotatingHazardExtension.stop = function (self)
	-- function 10
	if not (not self._is_server and self._state == num_4) then
		if self._state == num_2 then
			self._pause_t = Managers.state.network:network_time()
		end

		self._state = num_4
		self._is_activating = nil

		local game_object_or_level_id, var_10_1 = Managers.state.network:game_object_or_level_id(self._unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_rotating_hazard", game_object_or_level_id, var_10_1, self._start_t, self._pause_t, self._state, self._current_seed)
		Unit.flow_event(self._unit, "stop")
	end
end

RotatingHazardExtension.update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local _state = self._state

	if _state == num_4 then
		return
	end

	local network_time = Managers.state.network:network_time()

	if _state == num_3 then
		network_time = self._pause_t
	end

	local _settings = self._settings
	local anticipation_delay = _settings.anticipation_delay
	local flag = network_time < anticipation_delay + self._start_t
	local flag_2 = not flag and network_time and anticipation_delay + self._start_t
	local num_5 = (self._start_rotation_offset + (network_time - flag_2) * self._rotation_speed_rad * self._rotation_direction) % num

	Unit.set_local_rotation(arg_11_1, 0, Quaternion.axis_angle(Vector3.up(), num_5))

	if not (_state ~= num_2 or self._is_activating == flag) then
		self._is_activating = flag

		if not flag then
			Unit.flow_event(self._unit, "start_anticipation")
		else
			Unit.flow_event(self._unit, "start_rotation")
		end
	end

	local num_6 = self._last_update_idx % self._num_areas + 1
	local var_11_8 = self._area_data[num_6]
	local var_11_9 = _settings.areas[num_6]

	if not (not self._is_server and flag) then
		self:_update_damage(var_11_9, var_11_8, num_5, arg_11_3, network_time)
	end

	_settings.update_func(self._world, arg_11_1, _settings, _state, flag, var_11_9, var_11_8, num_5, self._rotation_direction, arg_11_5)

	self._last_update_idx = num_6
end

local tbl_2 = {}

RotatingHazardExtension._update_damage = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local last_update_t = arg_12_2.last_update_t

	last_update_t = last_update_t or arg_12_5

	local angle_offset = arg_12_1.angle_offset
	local num = (arg_12_5 - last_update_t) * self._rotation_speed_rad
	local axis_angle = Quaternion.axis_angle(Vector3.up(), arg_12_3 + angle_offset - num / 2)
	local forward = Quaternion.forward(axis_angle)
	local num_2 = num / 2 + arg_12_1.angular_half_size
	local cos = math.cos(num_2)
	local _settings = self._settings
	local overlapping_units = arg_12_2.overlapping_units
	local human_players = Managers.player:human_players()
	local _unit = self._unit
	local local_position = Unit.local_position(_unit, 0)
	local num_3 = arg_12_1.length * arg_12_1.length
	local num_4 = arg_12_1.length_offset * arg_12_1.length_offset
	local system = Managers.state.entity:system("buff_system")

	for k, v in pairs(human_players) do
		local player_unit = v.player_unit
		local var_12_16 = POSITION_LOOKUP[player_unit]

		if not var_12_16 then
			local distance_squared = Vector3.distance_squared(var_12_16, local_position)

			if not (not (num_4 <= distance_squared) or not (distance_squared <= num_3)) then
				local normalize = Vector3.normalize(Vector3.flat(var_12_16 - local_position))

				if cos <= Vector3.dot(forward, normalize) then
					tbl_2[player_unit] = true

					if not overlapping_units[player_unit] then
						local str = "kinetic"
						local str_2 = "heavy"

						DamageUtils.add_damage_network(player_unit, _unit, _settings.damage_entry, "full", str, nil, normalize, nil, nil, _unit, nil, str_2)

						local buffs_on_entry = _settings.buffs_on_entry

						for k_2 = 1, #buffs_on_entry do
							system:add_buff_synced(player_unit, buffs_on_entry[k_2], BuffSyncType.All)
						end

						overlapping_units[player_unit] = arg_12_5
					else
						local var_12_22 = overlapping_units[player_unit]
						local damage_tick_rate = _settings.damage_tick_rate

						if arg_12_5 >= var_12_22 + damage_tick_rate then
							local str_3 = "kinetic"
							local str_4 = "medium"

							DamageUtils.add_damage_network(player_unit, _unit, _settings.damage_tick, "full", str_3, nil, normalize, nil, nil, _unit, nil, str_4, nil, nil, nil, nil, nil, nil, 1)

							local buffs_on_tick = _settings.buffs_on_tick

							for l = 1, #buffs_on_tick do
								system:add_buff_synced(player_unit, buffs_on_tick[l], BuffSyncType.All)
							end

							overlapping_units[player_unit] = var_12_22 + damage_tick_rate
						end
					end
				end
			end
		end
	end

	for k_3 in pairs(overlapping_units) do
		if not tbl_2[k_3] then
			overlapping_units[k_3] = nil
		end
	end

	table.clear(tbl_2)

	arg_12_2.last_update_t = arg_12_5
end
