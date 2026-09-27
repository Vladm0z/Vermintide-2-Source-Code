-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_homing_skull_locomotion_extension.lua

ProjectileHomingSkullLocomotionExtension = class(ProjectileHomingSkullLocomotionExtension)

ProjectileHomingSkullLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._spawn_time = Managers.time:time("game")

	local homing_skulls_min_speed_multiplier = BelakorBalancing.homing_skulls_min_speed_multiplier
	local homing_skulls_max_speed_multiplier = BelakorBalancing.homing_skulls_max_speed_multiplier
	local num = homing_skulls_min_speed_multiplier - homing_skulls_max_speed_multiplier

	self._speed_multiplier = homing_skulls_max_speed_multiplier + math.random() * num
	self._use_sin_for_vertical_trajectory = Math.random(1, 2) == 1
	self._base_position = Vector3Box(Unit.local_position(arg_1_2, 0))
end

local function fn(arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = BLACKBOARDS[arg_2_0]
	local flag = not var_2_0 and var_2_0.breed

	if not flag and not flag.target_head_node then
		return Unit.world_position(arg_2_0, Unit.node(arg_2_0, flag.target_head_node))
	else
		return Unit.world_position(arg_2_0, Unit.node(arg_2_0, arg_2_1))
	end
end

local function fn_2(self)
	-- function 3
	local min = NetworkConstants.position.min
	local max = NetworkConstants.position.max

	for i = 1, 3 do
		local var_3_2 = self[i]

		if not (var_3_2 < min or not (max < var_3_2)) then
			print("[ProjectileHomingSkullLocomotionExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

ProjectileHomingSkullLocomotionExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self.moved = false

	if not self.stopped then
		return
	end

	local target_unit = BLACKBOARDS[arg_4_1].target_unit

	if not (not target_unit and ALIVE[target_unit]) then
		return
	end

	local unbox = self._base_position:unbox()
	local local_rotation = Unit.local_rotation(arg_4_1, 0)
	local num = fn(target_unit, "c_head") - unbox
	local normalize = Vector3.normalize(num)
	local look = Quaternion.look(normalize)
	local num_2 = arg_4_3 * BelakorBalancing.homing_skulls_lerp_constant
	local lerp = Quaternion.lerp(local_rotation, look, num_2)
	local forward = Quaternion.forward(lerp)
	local _speed_multiplier = self._speed_multiplier
	local num_3 = BelakorBalancing.homing_skulls_base_speed * _speed_multiplier
	local num_4 = arg_4_5 - self._spawn_time
	local num_5 = num_3 * BelakorBalancing.homing_skulls_speed_multiplier_curve_func(num_4)
	local var_4_13 = Vector3(normalize.x, normalize.y, math.abs(forward.z) + 1)
	local cross = Vector3.cross(normalize, var_4_13)
	local cross_2 = Vector3.cross(normalize, cross)
	local sin

	if not self._use_sin_for_vertical_trajectory then
		sin = math.sin

		if not sin then
			-- Nothing
		end
	end

	sin = math.cos

	::label_4_0::

	local num_6 = Vector3.normalize(cross_2) * BelakorBalancing.homing_skulls_vertical_offset_multiplier * sin(num_4 * BelakorBalancing.homing_skulls_vertical_offset_frequency_multiplier)
	local num_7 = unbox + forward * num_5 * arg_4_3

	self._base_position:store(num_7)

	local num_8 = num_7 + num_6

	if not fn_2(num_8) then
		self:stop()

		return
	end

	local num_9 = num_8 - Unit.local_position(arg_4_1, 0)

	if Vector3.length(num_9) <= 0.001 then
		return
	end

	Unit.set_local_rotation(arg_4_1, 0, lerp)
	Unit.set_local_position(arg_4_1, 0, num_8)

	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_4_1)

	if not game and not go_id then
		GameSession.set_game_object_field(game, go_id, "position", num_8)
		GameSession.set_game_object_field(game, go_id, "rotation", lerp)

		local enemy_velocity = NetworkConstants.enemy_velocity
		local min = enemy_velocity.min
		local max = enemy_velocity.max
		local var_4_26 = Vector3(min, min, min)
		local var_4_27 = Vector3(max, max, max)
		local min_2 = Vector3.min(Vector3.max(num_9, var_4_26), var_4_27)

		GameSession.set_game_object_field(game, go_id, "velocity", min_2)
	end

	self.moved = true
end

ProjectileHomingSkullLocomotionExtension.moved_this_frame = function (self)
	-- function 5
	return not not self.stopped or self.moved
end

ProjectileHomingSkullLocomotionExtension.destroy = function (self)
	-- function 6
	self.stopped = true
end

ProjectileHomingSkullLocomotionExtension.stop = function (self)
	-- function 7
	self.stopped = true
end
