-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_script_unit_locomotion_extension.lua

require("scripts/helpers/network_utils")

ProjectileScriptUnitLocomotionExtension = class(ProjectileScriptUnitLocomotionExtension)

function ProjectileScriptUnitLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.spawn_time = Managers.time:time("game") - (arg_1_3.fast_forward_time or 0)
	arg_1_0.t = arg_1_0.spawn_time
	arg_1_0.gravity_settings = arg_1_3.gravity_settings or "default"
	arg_1_0.rotation_speed = arg_1_3.rotation_speed or 0
	arg_1_0.rotate_around_forward = arg_1_3.rotate_around_forward or false
	arg_1_0.rotation_offset = arg_1_3.rotation_offset
	arg_1_0.gravity = ProjectileGravitySettings[arg_1_0.gravity_settings]
	arg_1_0.velocity = Vector3Box()
	arg_1_0.angle = arg_1_3.angle
	arg_1_0.radians = math.degrees_to_radians(arg_1_0.angle)
	arg_1_0.speed = arg_1_3.speed

	local var_1_0 = arg_1_3.initial_position

	arg_1_0.initial_position_boxed = Vector3Box(var_1_0)
	arg_1_0.target_vector = arg_1_3.target_vector
	arg_1_0.target_vector_boxed = Vector3Box(arg_1_0.target_vector)
	arg_1_0.trajectory_template_name = arg_1_3.trajectory_template_name

	fassert(arg_1_0.trajectory_template_name, "No trajectory template defined when initializing ProjectileScriptUnitLocomotionExtension")

	arg_1_0._linear_dampening = arg_1_3.linear_dampening or 1
	arg_1_0.is_husk = not not arg_1_3.is_husk
	arg_1_0.traversal_data = {}

	if arg_1_0.trajectory_template_name == "random_spinning_target_traversal" then
		arg_1_0.traversal_data.random_spin_dir = (math.random(0, 1) - 0.5) * 2
	end

	if arg_1_3.target_positions then
		arg_1_0.target_positions = arg_1_3.target_positions
		arg_1_0.target_units = arg_1_3.target_units
		arg_1_0._has_multiple_targets = true
		arg_1_0.current_target_index = 1
		arg_1_0.has_reached_all_targets = false
		arg_1_0.impact_with_last_target = arg_1_3.impact_with_last_target or false
		arg_1_0.random_x_axis = math.random(-100, 100) / 100
		arg_1_0.random_y_axis = math.random(-30, 100) / 100
		arg_1_0.distance_to_traverse = Vector3.distance(arg_1_0.target_positions[1]:unbox(), var_1_0)
	end

	arg_1_0._last_position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	arg_1_0._position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	arg_1_0._rotation = QuaternionBox(Unit.world_rotation(arg_1_2, 0))
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.stopped = false
	arg_1_0.moved = false

	local var_1_1
	local var_1_2

	if arg_1_0._has_multiple_targets then
		var_1_1 = arg_1_0:_get_new_position_multiple_targetpoints(0, 0)
		var_1_2 = arg_1_0:_get_new_rotation(arg_1_0.target_vector, 0)
	else
		var_1_1 = arg_1_0:_get_new_position(0)
		var_1_2 = arg_1_0:_get_new_rotation(arg_1_0.target_vector, 0)
	end

	Unit.set_local_position(arg_1_2, 0, var_1_1)
	Unit.set_local_rotation(arg_1_2, 0, var_1_2)

	arg_1_0.start_paused_for_time = arg_1_3.start_paused_for_time
end

function ProjectileScriptUnitLocomotionExtension.destroy(arg_2_0)
	return
end

function ProjectileScriptUnitLocomotionExtension.bounce(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Vector3.normalize(Vector3.reflect(arg_3_2, arg_3_3))
	local var_3_1 = arg_3_1 - arg_3_2 * 0.25 + arg_3_3 * 0.1
	local var_3_2 = Quaternion.look(var_3_0)

	arg_3_0.spawn_time = Managers.time:time("game")
	arg_3_0.t = arg_3_0.spawn_time

	arg_3_0.target_vector_boxed:store(var_3_0)
	arg_3_0.initial_position_boxed:store(var_3_1)

	arg_3_0.radians = math.degrees_to_radians(ActionUtils.pitch_from_rotation(var_3_2))

	arg_3_0._position:store(var_3_1)
	arg_3_0:_unit_set_position_rotation(arg_3_0.unit, var_3_1, var_3_2)
end

function ProjectileScriptUnitLocomotionExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0.time_lived = arg_4_5 - arg_4_0.spawn_time

	if arg_4_0.start_paused_for_time then
		arg_4_0.time_lived = math.max(0, arg_4_0.time_lived - arg_4_0.start_paused_for_time)
	end

	arg_4_0.dt = arg_4_5 - arg_4_0.t
	arg_4_0.moved = false

	if arg_4_0.stopped then
		return
	end

	local var_4_0 = arg_4_0._position:unbox()

	arg_4_0.speed = arg_4_0.speed - arg_4_0.dt * arg_4_0.speed * (1 - arg_4_0._linear_dampening)

	local var_4_1 = arg_4_0.time_lived
	local var_4_2

	if arg_4_0._has_multiple_targets and not arg_4_0.has_reached_all_targets then
		var_4_2 = arg_4_0:_get_new_position_multiple_targetpoints(var_4_1, arg_4_0.dt)
	else
		var_4_2 = arg_4_0:_get_new_position(var_4_1, arg_4_0.dt)
	end

	local var_4_3 = var_4_2 - var_4_0
	local var_4_4 = Vector3.normalize(var_4_3)
	local var_4_5 = Vector3.length(var_4_3)

	if not NetworkUtils.network_safe_position(var_4_2) or arg_4_0.has_reached_all_targets and arg_4_0.time_lived >= 10 then
		arg_4_0:stop()

		if not arg_4_0.is_husk then
			Managers.state.unit_spawner:mark_for_deletion(arg_4_0.unit)
		end

		return
	end

	if var_4_5 <= 0.001 then
		return
	end

	local var_4_6 = arg_4_0:_get_new_rotation(var_4_4, var_4_1)

	arg_4_0:_unit_set_position_rotation(arg_4_1, var_4_2, var_4_6)
	arg_4_0._last_position:store(var_4_0)
	arg_4_0._position:store(var_4_2)
	arg_4_0.velocity:store(var_4_3)
	arg_4_0._rotation:store(var_4_6)

	arg_4_0.moved = true
	arg_4_0.t = arg_4_5
end

local var_0_0 = 9

function ProjectileScriptUnitLocomotionExtension._get_new_position_multiple_targetpoints(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.speed
	local var_5_1 = arg_5_0.radians
	local var_5_2 = arg_5_0.gravity
	local var_5_3 = arg_5_0.is_husk
	local var_5_4 = ProjectileTemplates.get_trajectory_template(arg_5_0.trajectory_template_name, var_5_3)
	local var_5_5 = arg_5_0.target_vector_boxed:unbox()
	local var_5_6 = Vector3Box.unbox(arg_5_0.initial_position_boxed)
	local var_5_7 = arg_5_0.target_positions[arg_5_0.current_target_index]:unbox()
	local var_5_8 = arg_5_0._position:unbox()

	arg_5_0.traversal_data.current_target = var_5_7
	arg_5_0.traversal_data.position = var_5_8
	arg_5_0.traversal_data.random_x_axis = arg_5_0.random_x_axis
	arg_5_0.traversal_data.random_y_axis = arg_5_0.random_y_axis
	arg_5_0.traversal_data.distance_to_traverse = arg_5_0.distance_to_traverse

	local var_5_9 = var_5_4.update(var_5_0, var_5_1, var_5_2, var_5_6, var_5_5, arg_5_1, arg_5_2, arg_5_0.traversal_data)

	if not (Vector3.distance_squared(var_5_9, var_5_7) < var_0_0) then
		return var_5_9
	end

	if #arg_5_0.target_positions > arg_5_0.current_target_index then
		arg_5_0.current_target_index = arg_5_0.current_target_index + 1
		arg_5_0.trajectory_template_name = "straight_target_traversal"
	elseif arg_5_0.impact_with_last_target then
		if 0.010000000000000002 > Vector3.distance_squared(var_5_9, var_5_7) then
			ScriptUnit.extension(arg_5_0.unit, "projectile_system"):force_impact(arg_5_0.unit, var_5_9)
		end
	else
		arg_5_0:rotate_projectile_away_from_target(var_5_9, var_5_8)
		Unit.flow_event(arg_5_0.target_units[arg_5_0.current_target_index], "deflect_projectile")

		arg_5_0.trajectory_template_name = "straight_direction_traversal"
	end

	return var_5_9
end

function ProjectileScriptUnitLocomotionExtension._get_new_position(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.speed
	local var_6_1 = arg_6_0.trajectory_template_name

	if var_6_1 == "throw_trajectory" then
		var_6_0 = var_6_0 / 100
	end

	local var_6_2 = arg_6_0.radians
	local var_6_3 = arg_6_0.gravity
	local var_6_4 = arg_6_0.is_husk
	local var_6_5 = ProjectileTemplates.get_trajectory_template(var_6_1, var_6_4)
	local var_6_6 = arg_6_0.target_vector_boxed:unbox()
	local var_6_7 = Vector3Box.unbox(arg_6_0.initial_position_boxed)
	local var_6_8 = arg_6_0._position:unbox()
	local var_6_9 = {
		position = var_6_8
	}

	return (var_6_5.update(var_6_0, var_6_2, var_6_3, var_6_7, var_6_6, arg_6_1, arg_6_2, var_6_9))
end

function ProjectileScriptUnitLocomotionExtension._get_new_rotation(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Vector3.normalize(arg_7_1)
	local var_7_1 = Quaternion.look(var_7_0)

	if arg_7_0.rotation_offset then
		var_7_1 = Quaternion.multiply(var_7_1, Quaternion.from_euler_angles_xyz(arg_7_0.rotation_offset.x, arg_7_0.rotation_offset.y, arg_7_0.rotation_offset.z))
	end

	if arg_7_0.rotation_speed ~= 0 then
		local var_7_2 = Quaternion.look(var_7_0, Vector3.up())
		local var_7_3

		if arg_7_0.rotate_around_forward then
			var_7_3 = Quaternion.forward(var_7_2)
		else
			var_7_3 = -Quaternion.right(var_7_2)
		end

		var_7_1 = Quaternion.multiply(Quaternion.axis_angle(var_7_3, arg_7_2 * arg_7_0.rotation_speed), var_7_1)
	end

	return var_7_1
end

function ProjectileScriptUnitLocomotionExtension.rotate_projectile_away_from_target(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.has_reached_all_targets = true
	arg_8_0._has_multiple_targets = false

	local var_8_0 = Vector3.normalize(arg_8_1 - arg_8_2)
	local var_8_1, var_8_2 = math.get_uniformly_random_point_inside_sector(0.75, 1.5, 0, 2 * math.pi)
	local var_8_3 = Quaternion.rotate(Quaternion.look(var_8_0, Vector3.up()), Vector3.normalize(Vector3(var_8_1, 2, var_8_2)))

	arg_8_0.target_vector_boxed = Vector3Box(var_8_3)
end

function ProjectileScriptUnitLocomotionExtension._unit_set_position_rotation(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	Unit.set_local_rotation(arg_9_1, 0, arg_9_3)
	Unit.set_local_position(arg_9_1, 0, arg_9_2)
end

function ProjectileScriptUnitLocomotionExtension.moved_this_frame(arg_10_0)
	return arg_10_0.moved
end

function ProjectileScriptUnitLocomotionExtension.current_velocity(arg_11_0)
	return arg_11_0.velocity:unbox()
end

function ProjectileScriptUnitLocomotionExtension.current_position(arg_12_0)
	return arg_12_0._position:unbox()
end

function ProjectileScriptUnitLocomotionExtension.current_rotation(arg_13_0)
	return arg_13_0._rotation:unbox()
end

function ProjectileScriptUnitLocomotionExtension.last_position(arg_14_0)
	return arg_14_0._last_position:unbox()
end

function ProjectileScriptUnitLocomotionExtension.stop(arg_15_0)
	arg_15_0.stopped = true
end

function ProjectileScriptUnitLocomotionExtension.has_stopped(arg_16_0)
	return arg_16_0.stopped
end
