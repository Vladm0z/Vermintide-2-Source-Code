-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_ethereal_skull_locomotion_extension.lua

ProjectileEtherealSkullLocomotionExtension = class(ProjectileEtherealSkullLocomotionExtension)

local var_0_0 = DLCSettings.wizards_part_2.ethereal_skull_settings
local var_0_1 = AIGroupTemplates.ethereal_skulls
local var_0_2 = Unit.local_position
local var_0_3 = Vector3.length_squared
local var_0_4 = Vector3.direction_length
local var_0_5 = Quaternion.rotate

local function var_0_6(arg_1_0)
	local var_1_0 = NetworkConstants.position.min
	local var_1_1 = NetworkConstants.position.max

	for iter_1_0 = 1, 3 do
		local var_1_2 = arg_1_0[iter_1_0]

		if var_1_2 < var_1_0 or var_1_1 < var_1_2 then
			print("[ProjectileEtherealSkullLocomotionExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

function ProjectileEtherealSkullLocomotionExtension.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.time:time("game")

	arg_2_0._spawn_time = var_2_0

	local var_2_1 = var_0_0.min_speed_multiplier
	local var_2_2 = var_0_0.max_speed_multiplier
	local var_2_3 = var_2_1 - var_2_2

	arg_2_0._speed_multiplier = var_2_2 + math.random() * var_2_3
	arg_2_0._use_sin_for_vertical_trajectory = math.random(1, 2) == 1
	arg_2_0._base_position = Vector3Box(var_0_2(arg_2_2, 0))
	arg_2_0._unit = arg_2_2

	local var_2_4 = BLACKBOARDS[arg_2_2]

	arg_2_0._patrol_origin = var_2_4.optional_spawn_data.sofia_unit_pos

	local var_2_5 = var_2_4.optional_spawn_data.sofia_unit_pos:unbox()

	arg_2_0._origin_x = var_2_5.x
	arg_2_0._origin_y = var_2_5.y
	arg_2_0._current_state = "spawn_traversal"
	arg_2_0._spawn_traversal_start = var_2_0

	if var_2_4.optional_spawn_data.target then
		arg_2_0:set_target(var_2_4.optional_spawn_data.target)
	end

	arg_2_0._cached_direction = Vector3Box(Vector3.right())

	Managers.state.event:register(arg_2_0, "set_tower_skulls_target", "set_target")
end

function ProjectileEtherealSkullLocomotionExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0._moved = false

	if arg_3_0._stopped then
		return
	end

	local var_3_0 = arg_3_0._base_position:unbox()
	local var_3_1
	local var_3_2
	local var_3_3 = arg_3_0._current_state

	if var_3_3 == "homing" then
		var_3_2, var_3_1 = arg_3_0:get_homing_movement(arg_3_1, var_3_0, arg_3_5, arg_3_3)
	elseif var_3_3 == "patrol" then
		var_3_2, var_3_1 = arg_3_0:get_patrol_movement(arg_3_1, var_3_0, arg_3_5, arg_3_3)
	elseif var_3_3 == "spawn_traversal" then
		var_3_2, var_3_1 = arg_3_0:get_spawn_traversal_movement(arg_3_1, var_3_0, arg_3_5, arg_3_3)
	end

	local var_3_4 = Managers.state.network:game()
	local var_3_5 = Managers.state.unit_storage:go_id(arg_3_1)

	arg_3_0:set_rotation(arg_3_1, var_3_1, var_3_4, var_3_5, arg_3_3)
	arg_3_0:set_movement(arg_3_1, var_3_0, var_3_2, var_3_4, var_3_5, arg_3_5, arg_3_3)

	arg_3_0._moved = true
end

function ProjectileEtherealSkullLocomotionExtension.get_homing_movement(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0._patrol_origin:unbox()

	if Vector3.distance_squared(var_4_0, arg_4_2) > var_0_0.despawn_dist_sq then
		AiUtils.kill_unit(arg_4_0._unit, nil, nil, nil, nil)
	end

	local var_4_1 = arg_4_0._speed_multiplier
	local var_4_2 = var_0_0.base_speed * var_4_1
	local var_4_3 = arg_4_3 - arg_4_0._spawn_time
	local var_4_4 = var_4_2 * var_0_0.speed_multiplier_curve_func(var_4_3)
	local var_4_5 = arg_4_0:get_homing_target_direction(arg_4_2)

	return arg_4_2 + var_4_5 * var_4_4 * arg_4_4, var_4_5
end

function ProjectileEtherealSkullLocomotionExtension.get_patrol_movement(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = Vector3(arg_5_0._origin_x, arg_5_0._origin_y, arg_5_2.z)
	local var_5_1, var_5_2 = var_0_4(arg_5_2 - var_5_0)
	local var_5_3 = var_5_2 - var_0_0.patrol_target_horizontal_dist_from_origin
	local var_5_4 = arg_5_2.z - var_0_0.patrol_target_height
	local var_5_5 = Vector3.zero()
	local var_5_6 = var_0_0.patrol_target_adjustment_speed * arg_5_4

	if math.abs(var_5_3) > var_0_0.patrol_target_marginal then
		local var_5_7 = math.sign(var_5_3)

		var_5_5 = var_5_1 * var_5_6 * -var_5_7
	end

	if math.abs(var_5_4) > var_0_0.patrol_target_marginal then
		local var_5_8 = math.sign(var_5_4)

		var_5_5 = var_5_5 + Vector3.up() * var_5_6 * -var_5_8
	end

	local var_5_9 = var_0_0.patrol_speed / (var_5_2 * math.pi * 2) * arg_5_4
	local var_5_10 = Quaternion(Vector3.up(), var_5_9)
	local var_5_11 = var_5_0 + var_0_5(var_5_10, var_5_1 * var_5_2) + var_5_5
	local var_5_12 = Vector3.normalize(var_5_11 - arg_5_2)

	if arg_5_0:has_target() then
		local var_5_13 = Unit.world_position(arg_5_0._target_unit, 0)

		if Vector3.distance_squared(Vector3.flat(var_5_11), Vector3.flat(var_5_13)) < var_0_0.aggro_distance_sq then
			arg_5_0._current_state = "homing"

			Unit.flow_event(arg_5_0._unit, "on_aggro")
		end
	end

	return var_5_11, var_5_12
end

function ProjectileEtherealSkullLocomotionExtension.get_spawn_traversal_movement(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = (arg_6_3 - arg_6_0._spawn_traversal_start) / var_0_0.spawn_traversal_duration
	local var_6_1 = Vector3(arg_6_0._origin_x, arg_6_0._origin_y, arg_6_2.z)
	local var_6_2, var_6_3 = var_0_4(arg_6_2 - var_6_1)
	local var_6_4 = var_6_3 + var_0_0.spawn_traversal_outward_speed * arg_6_4
	local var_6_5 = var_6_2 * var_6_4
	local var_6_6 = Vector3(0, 0, -var_0_0.spawn_traversal_downward_speed * arg_6_4)
	local var_6_7 = var_0_0.patrol_speed / (var_6_4 * math.pi * 2) * arg_6_4
	local var_6_8 = Quaternion(Vector3.up(), var_6_7)
	local var_6_9 = var_6_1 + var_0_5(var_6_8, var_6_2 * var_6_3) + var_6_6
	local var_6_10 = var_6_1 + var_0_5(var_6_8, var_6_5)
	local var_6_11 = Vector3.smoothstep(var_6_0, var_6_9, var_6_10)
	local var_6_12 = Vector3.normalize(var_6_11 - arg_6_2)

	if arg_6_3 > arg_6_0._spawn_traversal_start + var_0_0.spawn_traversal_duration then
		arg_6_0._current_state = "patrol"
	end

	return var_6_11, var_6_12
end

function ProjectileEtherealSkullLocomotionExtension.set_movement(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	if not arg_7_4 and arg_7_5 then
		return
	end

	if not arg_7_3 then
		return
	end

	if arg_7_0._in_knockback then
		local var_7_0 = arg_7_0._knockback_start + var_0_0.knockback_duration
		local var_7_1 = math.inv_lerp(arg_7_0._knockback_start, var_7_0, arg_7_6)
		local var_7_2 = math.easeOutCubic(var_7_1)
		local var_7_3 = arg_7_2 + arg_7_0._knockback_velocity:unbox() * arg_7_7

		arg_7_3 = Vector3.lerp(var_7_3, arg_7_3, var_7_2)

		if var_7_0 < arg_7_6 then
			arg_7_0._in_knockback = false
		end
	end

	arg_7_0._base_position:store(arg_7_3)

	local var_7_4 = arg_7_3 + arg_7_0:get_vertical_offset(arg_7_6)
	local var_7_5 = var_7_4 - var_0_2(arg_7_1, 0)

	if var_0_3(var_7_5) <= 1e-06 then
		return
	end

	if not var_0_6(var_7_4) then
		arg_7_0:stop()

		return
	end

	Unit.set_local_position(arg_7_1, 0, var_7_4)
	GameSession.set_game_object_field(arg_7_4, arg_7_5, "position", var_7_4)

	local var_7_6 = NetworkConstants.enemy_velocity
	local var_7_7 = var_7_6.min
	local var_7_8 = var_7_6.max
	local var_7_9 = Vector3(var_7_7, var_7_7, var_7_7)
	local var_7_10 = Vector3(var_7_8, var_7_8, var_7_8)
	local var_7_11 = Vector3.min(Vector3.max(var_7_5, var_7_9), var_7_10)

	GameSession.set_game_object_field(arg_7_4, arg_7_5, "velocity", var_7_11)
end

function ProjectileEtherealSkullLocomotionExtension.set_knockback(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_2 = Vector3(arg_8_2[1], arg_8_2[2], arg_8_2[3])
	arg_8_0._knockback_end = arg_8_4 + var_0_0.knockback_duration
	arg_8_0._knockback_start = arg_8_4
	arg_8_0._in_knockback = true

	local var_8_0 = Unit.world_position(arg_8_0._unit, 0)
	local var_8_1 = ScriptUnit.has_extension(arg_8_1, "first_person_system")
	local var_8_2

	if var_8_1 then
		local var_8_3 = var_8_1:current_rotation()

		var_8_2 = Quaternion.forward(var_8_3)
	else
		local var_8_4 = arg_8_0:get_target_node_position(arg_8_1)

		var_8_2 = Vector3.normalize(var_8_4 - var_8_0)
	end

	local var_8_5 = Vector3.normalize(arg_8_2 + var_8_2 * 0.5) * var_0_0.knockback_speed

	arg_8_0._knockback_velocity = Vector3Box(var_8_5)
end

function ProjectileEtherealSkullLocomotionExtension.set_rotation(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	if not arg_9_3 and arg_9_4 then
		return
	end

	local var_9_0 = Quaternion.look(arg_9_2)
	local var_9_1 = Unit.local_rotation(arg_9_0._unit, 0)
	local var_9_2 = arg_9_5 * var_0_0.lerp_constant
	local var_9_3 = Quaternion.lerp(var_9_1, var_9_0, var_9_2)

	Unit.set_local_rotation(arg_9_1, 0, var_9_3)
	GameSession.set_game_object_field(arg_9_3, arg_9_4, "rotation", var_9_3)

	arg_9_0._direction = Quaternion.forward(var_9_3)
	arg_9_0._target_direction = arg_9_2

	arg_9_0._cached_direction:store(arg_9_2)
end

function ProjectileEtherealSkullLocomotionExtension.get_vertical_offset(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 - arg_10_0._spawn_time
	local var_10_1 = arg_10_0._target_direction
	local var_10_2 = arg_10_0._direction
	local var_10_3 = Vector3(var_10_1.x, var_10_1.y, math.abs(var_10_2.z) + 1)
	local var_10_4 = Vector3.cross(var_10_1, var_10_3)
	local var_10_5 = Vector3.cross(var_10_1, var_10_4)
	local var_10_6 = arg_10_0._use_sin_for_vertical_trajectory and math.sin or math.cos

	return Vector3.normalize(var_10_5) * var_0_0.vertical_offset_multiplier * var_10_6(var_10_0 * var_0_0.vertical_offset_frequency_multiplier)
end

function ProjectileEtherealSkullLocomotionExtension.get_homing_target_direction(arg_11_0, arg_11_1)
	local var_11_0

	if not arg_11_0:has_target() then
		var_11_0 = arg_11_0._cached_direction:unbox()
	else
		local var_11_1 = arg_11_0:get_target_node_position(arg_11_0._target_unit)

		var_11_0 = Vector3.normalize(var_11_1 - arg_11_1)
		arg_11_0._cached_direction = Vector3Box(var_11_0)
	end

	return var_11_0
end

function ProjectileEtherealSkullLocomotionExtension.set_target(arg_12_0, arg_12_1, arg_12_2)
	if AIGroupTemplates.ethereal_skulls.last_state == "spawned" then
		return
	end

	arg_12_0._thrown = arg_12_2
	arg_12_0._target_unit = arg_12_1
end

function ProjectileEtherealSkullLocomotionExtension.get_target_node_position(arg_13_0, arg_13_1)
	local var_13_0 = BLACKBOARDS[arg_13_1]
	local var_13_1 = var_13_0 and var_13_0.breed
	local var_13_2 = ScriptUnit.has_extension(arg_13_1, "pickup_system")

	if var_13_1 and var_13_1.target_head_node then
		return Unit.world_position(arg_13_1, Unit.node(arg_13_1, var_13_1.target_head_node))
	elseif var_13_2 and var_13_2.pickup_name == "wizards_barrel" then
		return Unit.world_position(arg_13_1, Unit.node(arg_13_1, "fx_fuse"))
	else
		return Unit.world_position(arg_13_1, Unit.node(arg_13_1, "c_head"))
	end
end

function ProjectileEtherealSkullLocomotionExtension.has_target(arg_14_0)
	return arg_14_0._target_unit and Unit.alive(arg_14_0._target_unit)
end

function ProjectileEtherealSkullLocomotionExtension.moved_this_frame(arg_15_0)
	return not arg_15_0._stopped and arg_15_0._moved
end

function ProjectileEtherealSkullLocomotionExtension.destroy(arg_16_0)
	arg_16_0._stopped = true
	arg_16_0._target_unit = nil

	Managers.state.event:unregister("set_tower_skulls_target", arg_16_0)
end

function ProjectileEtherealSkullLocomotionExtension.stop(arg_17_0)
	arg_17_0._stopped = true
end
