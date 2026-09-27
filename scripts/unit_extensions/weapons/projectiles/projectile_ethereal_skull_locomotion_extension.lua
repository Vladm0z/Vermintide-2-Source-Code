-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_ethereal_skull_locomotion_extension.lua

ProjectileEtherealSkullLocomotionExtension = class(ProjectileEtherealSkullLocomotionExtension)

local ethereal_skull_settings = DLCSettings.wizards_part_2.ethereal_skull_settings
local ethereal_skulls = AIGroupTemplates.ethereal_skulls
local local_position = Unit.local_position
local length_squared = Vector3.length_squared
local direction_length = Vector3.direction_length
local rotate = Quaternion.rotate

local function fn(self)
	-- function 1
	local min = NetworkConstants.position.min
	local max = NetworkConstants.position.max

	for i = 1, 3 do
		local var_1_2 = self[i]

		if not (var_1_2 < min or not (max < var_1_2)) then
			print("[ProjectileEtherealSkullLocomotionExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

ProjectileEtherealSkullLocomotionExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local time = Managers.time:time("game")

	self._spawn_time = time

	local min_speed_multiplier = ethereal_skull_settings.min_speed_multiplier
	local max_speed_multiplier = ethereal_skull_settings.max_speed_multiplier
	local num = min_speed_multiplier - max_speed_multiplier

	self._speed_multiplier = max_speed_multiplier + math.random() * num
	self._use_sin_for_vertical_trajectory = math.random(1, 2) == 1
	self._base_position = Vector3Box(local_position(arg_2_2, 0))
	self._unit = arg_2_2

	local var_2_4 = BLACKBOARDS[arg_2_2]

	self._patrol_origin = var_2_4.optional_spawn_data.sofia_unit_pos

	local unbox = var_2_4.optional_spawn_data.sofia_unit_pos:unbox()

	self._origin_x = unbox.x
	self._origin_y = unbox.y
	self._current_state = "spawn_traversal"
	self._spawn_traversal_start = time

	if not var_2_4.optional_spawn_data.target then
		self:set_target(var_2_4.optional_spawn_data.target)
	end

	self._cached_direction = Vector3Box(Vector3.right())

	Managers.state.event:register(self, "set_tower_skulls_target", "set_target")
end

ProjectileEtherealSkullLocomotionExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	self._moved = false

	if not self._stopped then
		return
	end

	local unbox = self._base_position:unbox()
	local var_3_1
	local var_3_2
	local _current_state = self._current_state

	if _current_state == "homing" then
		var_3_2, var_3_1 = self:get_homing_movement(arg_3_1, unbox, arg_3_5, arg_3_3)
	elseif _current_state == "patrol" then
		var_3_2, var_3_1 = self:get_patrol_movement(arg_3_1, unbox, arg_3_5, arg_3_3)
	elseif _current_state == "spawn_traversal" then
		var_3_2, var_3_1 = self:get_spawn_traversal_movement(arg_3_1, unbox, arg_3_5, arg_3_3)
	end

	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_3_1)

	self:set_rotation(arg_3_1, var_3_1, game, go_id, arg_3_3)
	self:set_movement(arg_3_1, unbox, var_3_2, game, go_id, arg_3_5, arg_3_3)

	self._moved = true
end

ProjectileEtherealSkullLocomotionExtension.get_homing_movement = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local unbox = self._patrol_origin:unbox()

	if Vector3.distance_squared(unbox, arg_4_2) > ethereal_skull_settings.despawn_dist_sq then
		AiUtils.kill_unit(self._unit, nil, nil, nil, nil)
	end

	local _speed_multiplier = self._speed_multiplier
	local num = ethereal_skull_settings.base_speed * _speed_multiplier
	local num_2 = arg_4_3 - self._spawn_time
	local num_3 = num * ethereal_skull_settings.speed_multiplier_curve_func(num_2)
	local get_homing_target_direction = self:get_homing_target_direction(arg_4_2)

	return arg_4_2 + get_homing_target_direction * num_3 * arg_4_4, get_homing_target_direction
end

ProjectileEtherealSkullLocomotionExtension.get_patrol_movement = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = Vector3(self._origin_x, self._origin_y, arg_5_2.z)
	local var_5_1, var_5_2 = direction_length(arg_5_2 - var_5_0)
	local num = var_5_2 - ethereal_skull_settings.patrol_target_horizontal_dist_from_origin
	local num_2 = arg_5_2.z - ethereal_skull_settings.patrol_target_height
	local zero = Vector3.zero()
	local num_3 = ethereal_skull_settings.patrol_target_adjustment_speed * arg_5_4

	if math.abs(num) > ethereal_skull_settings.patrol_target_marginal then
		local sign = math.sign(num)

		zero = var_5_1 * num_3 * -sign
	end

	if math.abs(num_2) > ethereal_skull_settings.patrol_target_marginal then
		local sign_2 = math.sign(num_2)

		zero = zero + Vector3.up() * num_3 * -sign_2
	end

	local num_4 = ethereal_skull_settings.patrol_speed / (var_5_2 * math.pi * 2) * arg_5_4
	local var_5_10 = Quaternion(Vector3.up(), num_4)
	local num_5 = var_5_0 + rotate(var_5_10, var_5_1 * var_5_2) + zero
	local normalize = Vector3.normalize(num_5 - arg_5_2)

	if not self:has_target() then
		local world_position = Unit.world_position(self._target_unit, 0)

		if Vector3.distance_squared(Vector3.flat(num_5), Vector3.flat(world_position)) < ethereal_skull_settings.aggro_distance_sq then
			self._current_state = "homing"

			Unit.flow_event(self._unit, "on_aggro")
		end
	end

	return num_5, normalize
end

ProjectileEtherealSkullLocomotionExtension.get_spawn_traversal_movement = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local num = (arg_6_3 - self._spawn_traversal_start) / ethereal_skull_settings.spawn_traversal_duration
	local var_6_1 = Vector3(self._origin_x, self._origin_y, arg_6_2.z)
	local var_6_2, var_6_3 = direction_length(arg_6_2 - var_6_1)
	local num_2 = var_6_3 + ethereal_skull_settings.spawn_traversal_outward_speed * arg_6_4
	local num_3 = var_6_2 * num_2
	local var_6_6 = Vector3(0, 0, -ethereal_skull_settings.spawn_traversal_downward_speed * arg_6_4)
	local num_4 = ethereal_skull_settings.patrol_speed / (num_2 * math.pi * 2) * arg_6_4
	local var_6_8 = Quaternion(Vector3.up(), num_4)
	local num_5 = var_6_1 + rotate(var_6_8, var_6_2 * var_6_3) + var_6_6
	local num_6 = var_6_1 + rotate(var_6_8, num_3)
	local smoothstep = Vector3.smoothstep(num, num_5, num_6)
	local normalize = Vector3.normalize(smoothstep - arg_6_2)

	if arg_6_3 > self._spawn_traversal_start + ethereal_skull_settings.spawn_traversal_duration then
		self._current_state = "patrol"
	end

	return smoothstep, normalize
end

ProjectileEtherealSkullLocomotionExtension.set_movement = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	-- function 7
	if arg_7_4 or not arg_7_5 then
		return
	end

	if not arg_7_3 then
		return
	end

	if not self._in_knockback then
		local num = self._knockback_start + ethereal_skull_settings.knockback_duration
		local inv_lerp = math.inv_lerp(self._knockback_start, num, arg_7_6)
		local easeOutCubic = math.easeOutCubic(inv_lerp)
		local num_2 = arg_7_2 + self._knockback_velocity:unbox() * arg_7_7

		arg_7_3 = Vector3.lerp(num_2, arg_7_3, easeOutCubic)

		if num < arg_7_6 then
			self._in_knockback = false
		end
	end

	self._base_position:store(arg_7_3)

	local num_3 = arg_7_3 + self:get_vertical_offset(arg_7_6)
	local num_4 = num_3 - local_position(arg_7_1, 0)

	if length_squared(num_4) <= 1e-06 then
		return
	end

	if not fn(num_3) then
		self:stop()

		return
	end

	Unit.set_local_position(arg_7_1, 0, num_3)
	GameSession.set_game_object_field(arg_7_4, arg_7_5, "position", num_3)

	local enemy_velocity = NetworkConstants.enemy_velocity
	local min = enemy_velocity.min
	local max = enemy_velocity.max
	local var_7_9 = Vector3(min, min, min)
	local var_7_10 = Vector3(max, max, max)
	local min_2 = Vector3.min(Vector3.max(num_4, var_7_9), var_7_10)

	GameSession.set_game_object_field(arg_7_4, arg_7_5, "velocity", min_2)
end

ProjectileEtherealSkullLocomotionExtension.set_knockback = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	arg_8_2 = Vector3(arg_8_2[1], arg_8_2[2], arg_8_2[3])
	self._knockback_end = arg_8_4 + ethereal_skull_settings.knockback_duration
	self._knockback_start = arg_8_4
	self._in_knockback = true

	local world_position = Unit.world_position(self._unit, 0)
	local has_extension = ScriptUnit.has_extension(arg_8_1, "first_person_system")
	local var_8_2

	if not has_extension then
		local current_rotation = has_extension:current_rotation()

		var_8_2 = Quaternion.forward(current_rotation)
	else
		local get_target_node_position = self:get_target_node_position(arg_8_1)

		var_8_2 = Vector3.normalize(get_target_node_position - world_position)
	end

	local num = Vector3.normalize(arg_8_2 + var_8_2 * 0.5) * ethereal_skull_settings.knockback_speed

	self._knockback_velocity = Vector3Box(num)
end

ProjectileEtherealSkullLocomotionExtension.set_rotation = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	if arg_9_3 or not arg_9_4 then
		return
	end

	local look = Quaternion.look(arg_9_2)
	local local_rotation = Unit.local_rotation(self._unit, 0)
	local num = arg_9_5 * ethereal_skull_settings.lerp_constant
	local lerp = Quaternion.lerp(local_rotation, look, num)

	Unit.set_local_rotation(arg_9_1, 0, lerp)
	GameSession.set_game_object_field(arg_9_3, arg_9_4, "rotation", lerp)

	self._direction = Quaternion.forward(lerp)
	self._target_direction = arg_9_2

	self._cached_direction:store(arg_9_2)
end

ProjectileEtherealSkullLocomotionExtension.get_vertical_offset = function (self, arg_10_1)
	-- function 10
	local num = arg_10_1 - self._spawn_time
	local _target_direction = self._target_direction
	local _direction = self._direction
	local var_10_3 = Vector3(_target_direction.x, _target_direction.y, math.abs(_direction.z) + 1)
	local cross = Vector3.cross(_target_direction, var_10_3)
	local cross_2 = Vector3.cross(_target_direction, cross)
	local sin

	if not self._use_sin_for_vertical_trajectory then
		sin = math.sin

		if not sin then
			-- Nothing
		end
	end

	sin = math.cos

	::label_10_0::

	return Vector3.normalize(cross_2) * ethereal_skull_settings.vertical_offset_multiplier * sin(num * ethereal_skull_settings.vertical_offset_frequency_multiplier)
end

ProjectileEtherealSkullLocomotionExtension.get_homing_target_direction = function (self, arg_11_1)
	-- function 11
	local var_11_0

	if not self:has_target() then
		var_11_0 = self._cached_direction:unbox()
	else
		local get_target_node_position = self:get_target_node_position(self._target_unit)

		var_11_0 = Vector3.normalize(get_target_node_position - arg_11_1)
		self._cached_direction = Vector3Box(var_11_0)
	end

	return var_11_0
end

ProjectileEtherealSkullLocomotionExtension.set_target = function (self, arg_12_1, arg_12_2)
	-- function 12
	if AIGroupTemplates.ethereal_skulls.last_state == "spawned" then
		return
	end

	self._thrown = arg_12_2
	self._target_unit = arg_12_1
end

ProjectileEtherealSkullLocomotionExtension.get_target_node_position = function (arg_13_0, arg_13_1)
	-- function 13
	local var_13_0 = BLACKBOARDS[arg_13_1]
	local flag = not var_13_0 and var_13_0.breed
	local has_extension = ScriptUnit.has_extension(arg_13_1, "pickup_system")

	if not flag and not flag.target_head_node then
		return Unit.world_position(arg_13_1, Unit.node(arg_13_1, flag.target_head_node))
	elseif not (not has_extension and has_extension.pickup_name ~= "wizards_barrel") then
		return Unit.world_position(arg_13_1, Unit.node(arg_13_1, "fx_fuse"))
	else
		return Unit.world_position(arg_13_1, Unit.node(arg_13_1, "c_head"))
	end
end

ProjectileEtherealSkullLocomotionExtension.has_target = function (self)
	-- function 14
	local _target_unit = self._target_unit

	_target_unit = not _target_unit and Unit.alive(self._target_unit)

	return _target_unit
end

ProjectileEtherealSkullLocomotionExtension.moved_this_frame = function (self)
	-- function 15
	return not not self._stopped or self._moved
end

ProjectileEtherealSkullLocomotionExtension.destroy = function (self)
	-- function 16
	self._stopped = true
	self._target_unit = nil

	Managers.state.event:unregister("set_tower_skulls_target", self)
end

ProjectileEtherealSkullLocomotionExtension.stop = function (self)
	-- function 17
	self._stopped = true
end
