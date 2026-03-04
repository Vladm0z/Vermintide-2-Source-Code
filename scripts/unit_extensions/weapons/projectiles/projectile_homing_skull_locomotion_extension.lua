-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_homing_skull_locomotion_extension.lua

ProjectileHomingSkullLocomotionExtension = class(ProjectileHomingSkullLocomotionExtension)

ProjectileHomingSkullLocomotionExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._spawn_time = Managers.time:time("game")

	local var_1_0 = BelakorBalancing.homing_skulls_min_speed_multiplier
	local var_1_1 = BelakorBalancing.homing_skulls_max_speed_multiplier
	local var_1_2 = var_1_0 - var_1_1

	arg_1_0._speed_multiplier = var_1_1 + math.random() * var_1_2
	arg_1_0._use_sin_for_vertical_trajectory = Math.random(1, 2) == 1
	arg_1_0._base_position = Vector3Box(Unit.local_position(arg_1_2, 0))
end

local function var_0_0(arg_2_0, arg_2_1)
	local var_2_0 = BLACKBOARDS[arg_2_0]
	local var_2_1 = var_2_0 and var_2_0.breed

	if var_2_1 and var_2_1.target_head_node then
		return Unit.world_position(arg_2_0, Unit.node(arg_2_0, var_2_1.target_head_node))
	else
		return Unit.world_position(arg_2_0, Unit.node(arg_2_0, arg_2_1))
	end
end

local function var_0_1(arg_3_0)
	local var_3_0 = NetworkConstants.position.min
	local var_3_1 = NetworkConstants.position.max

	for iter_3_0 = 1, 3 do
		local var_3_2 = arg_3_0[iter_3_0]

		if var_3_2 < var_3_0 or var_3_1 < var_3_2 then
			print("[ProjectileHomingSkullLocomotionExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

ProjectileHomingSkullLocomotionExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0.moved = false

	if arg_4_0.stopped then
		return
	end

	local var_4_0 = BLACKBOARDS[arg_4_1].target_unit

	if not var_4_0 or not ALIVE[var_4_0] then
		return
	end

	local var_4_1 = arg_4_0._base_position:unbox()
	local var_4_2 = Unit.local_rotation(arg_4_1, 0)
	local var_4_3 = var_0_0(var_4_0, "c_head") - var_4_1
	local var_4_4 = Vector3.normalize(var_4_3)
	local var_4_5 = Quaternion.look(var_4_4)
	local var_4_6 = arg_4_3 * BelakorBalancing.homing_skulls_lerp_constant
	local var_4_7 = Quaternion.lerp(var_4_2, var_4_5, var_4_6)
	local var_4_8 = Quaternion.forward(var_4_7)
	local var_4_9 = arg_4_0._speed_multiplier
	local var_4_10 = BelakorBalancing.homing_skulls_base_speed * var_4_9
	local var_4_11 = arg_4_5 - arg_4_0._spawn_time
	local var_4_12 = var_4_10 * BelakorBalancing.homing_skulls_speed_multiplier_curve_func(var_4_11)
	local var_4_13 = Vector3(var_4_4.x, var_4_4.y, math.abs(var_4_8.z) + 1)
	local var_4_14 = Vector3.cross(var_4_4, var_4_13)
	local var_4_15 = Vector3.cross(var_4_4, var_4_14)
	local var_4_16 = arg_4_0._use_sin_for_vertical_trajectory and math.sin or math.cos
	local var_4_17 = Vector3.normalize(var_4_15) * BelakorBalancing.homing_skulls_vertical_offset_multiplier * var_4_16(var_4_11 * BelakorBalancing.homing_skulls_vertical_offset_frequency_multiplier)
	local var_4_18 = var_4_1 + var_4_8 * var_4_12 * arg_4_3

	arg_4_0._base_position:store(var_4_18)

	local var_4_19 = var_4_18 + var_4_17

	if not var_0_1(var_4_19) then
		arg_4_0:stop()

		return
	end

	local var_4_20 = var_4_19 - Unit.local_position(arg_4_1, 0)

	if Vector3.length(var_4_20) <= 0.001 then
		return
	end

	Unit.set_local_rotation(arg_4_1, 0, var_4_7)
	Unit.set_local_position(arg_4_1, 0, var_4_19)

	local var_4_21 = Managers.state.network:game()
	local var_4_22 = Managers.state.unit_storage:go_id(arg_4_1)

	if var_4_21 and var_4_22 then
		GameSession.set_game_object_field(var_4_21, var_4_22, "position", var_4_19)
		GameSession.set_game_object_field(var_4_21, var_4_22, "rotation", var_4_7)

		local var_4_23 = NetworkConstants.enemy_velocity
		local var_4_24 = var_4_23.min
		local var_4_25 = var_4_23.max
		local var_4_26 = Vector3(var_4_24, var_4_24, var_4_24)
		local var_4_27 = Vector3(var_4_25, var_4_25, var_4_25)
		local var_4_28 = Vector3.min(Vector3.max(var_4_20, var_4_26), var_4_27)

		GameSession.set_game_object_field(var_4_21, var_4_22, "velocity", var_4_28)
	end

	arg_4_0.moved = true
end

ProjectileHomingSkullLocomotionExtension.moved_this_frame = function (arg_5_0)
	return not arg_5_0.stopped and arg_5_0.moved
end

ProjectileHomingSkullLocomotionExtension.destroy = function (arg_6_0)
	arg_6_0.stopped = true
end

ProjectileHomingSkullLocomotionExtension.stop = function (arg_7_0)
	arg_7_0.stopped = true
end
