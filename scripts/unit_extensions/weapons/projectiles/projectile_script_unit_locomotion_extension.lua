-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_script_unit_locomotion_extension.lua

require("scripts/helpers/network_utils")

ProjectileScriptUnitLocomotionExtension = class(ProjectileScriptUnitLocomotionExtension)

ProjectileScriptUnitLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.world = arg_1_1.world

	local time = Managers.time:time("game")
	local fast_forward_time = arg_1_3.fast_forward_time

	fast_forward_time = fast_forward_time or 0
	self.spawn_time = time - fast_forward_time
	self.t = self.spawn_time

	local gravity_settings = arg_1_3.gravity_settings

	gravity_settings = gravity_settings or "default"
	self.gravity_settings = gravity_settings

	local rotation_speed = arg_1_3.rotation_speed

	rotation_speed = rotation_speed or 0
	self.rotation_speed = rotation_speed

	local rotate_around_forward = arg_1_3.rotate_around_forward

	rotate_around_forward = rotate_around_forward or false
	self.rotate_around_forward = rotate_around_forward
	self.rotation_offset = arg_1_3.rotation_offset
	self.gravity = ProjectileGravitySettings[self.gravity_settings]
	self.velocity = Vector3Box()
	self.angle = arg_1_3.angle
	self.radians = math.degrees_to_radians(self.angle)
	self.speed = arg_1_3.speed

	local initial_position = arg_1_3.initial_position

	self.initial_position_boxed = Vector3Box(initial_position)
	self.target_vector = arg_1_3.target_vector
	self.target_vector_boxed = Vector3Box(self.target_vector)
	self.trajectory_template_name = arg_1_3.trajectory_template_name

	fassert(self.trajectory_template_name, "No trajectory template defined when initializing ProjectileScriptUnitLocomotionExtension")

	local linear_dampening = arg_1_3.linear_dampening

	linear_dampening = linear_dampening or 1
	self._linear_dampening = linear_dampening
	self.is_husk = not not arg_1_3.is_husk
	self.traversal_data = {}

	if self.trajectory_template_name == "random_spinning_target_traversal" then
		self.traversal_data.random_spin_dir = (math.random(0, 1) - 0.5) * 2
	end

	if not arg_1_3.target_positions then
		self.target_positions = arg_1_3.target_positions
		self.target_units = arg_1_3.target_units
		self._has_multiple_targets = true
		self.current_target_index = 1
		self.has_reached_all_targets = false

		local impact_with_last_target = arg_1_3.impact_with_last_target

		impact_with_last_target = impact_with_last_target or false
		self.impact_with_last_target = impact_with_last_target
		self.random_x_axis = math.random(-100, 100) / 100
		self.random_y_axis = math.random(-30, 100) / 100
		self.distance_to_traverse = Vector3.distance(self.target_positions[1]:unbox(), initial_position)
	end

	self._last_position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	self._position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	self._rotation = QuaternionBox(Unit.world_rotation(arg_1_2, 0))
	self.is_server = Managers.player.is_server
	self.stopped = false
	self.moved = false

	local var_1_8
	local var_1_9

	if not self._has_multiple_targets then
		var_1_8 = self:_get_new_position_multiple_targetpoints(0, 0)
		var_1_9 = self:_get_new_rotation(self.target_vector, 0)
	else
		var_1_8 = self:_get_new_position(0)
		var_1_9 = self:_get_new_rotation(self.target_vector, 0)
	end

	Unit.set_local_position(arg_1_2, 0, var_1_8)
	Unit.set_local_rotation(arg_1_2, 0, var_1_9)

	self.start_paused_for_time = arg_1_3.start_paused_for_time
end

ProjectileScriptUnitLocomotionExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

ProjectileScriptUnitLocomotionExtension.bounce = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local normalize = Vector3.normalize(Vector3.reflect(arg_3_2, arg_3_3))
	local num = arg_3_1 - arg_3_2 * 0.25 + arg_3_3 * 0.1
	local look = Quaternion.look(normalize)

	self.spawn_time = Managers.time:time("game")
	self.t = self.spawn_time

	self.target_vector_boxed:store(normalize)
	self.initial_position_boxed:store(num)

	self.radians = math.degrees_to_radians(ActionUtils.pitch_from_rotation(look))

	self._position:store(num)
	self:_unit_set_position_rotation(self.unit, num, look)
end

ProjectileScriptUnitLocomotionExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self.time_lived = arg_4_5 - self.spawn_time

	if not self.start_paused_for_time then
		self.time_lived = math.max(0, self.time_lived - self.start_paused_for_time)
	end

	self.dt = arg_4_5 - self.t
	self.moved = false

	if not self.stopped then
		return
	end

	local unbox = self._position:unbox()

	self.speed = self.speed - self.dt * self.speed * (1 - self._linear_dampening)

	local time_lived = self.time_lived
	local var_4_2

	if not (not self._has_multiple_targets and self.has_reached_all_targets) then
		var_4_2 = self:_get_new_position_multiple_targetpoints(time_lived, self.dt)
	else
		var_4_2 = self:_get_new_position(time_lived, self.dt)
	end

	local num = var_4_2 - unbox
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)

	if not (not NetworkUtils.network_safe_position(var_4_2) and not self.has_reached_all_targets and not (self.time_lived >= 10)) then
		self:stop()

		if not self.is_husk then
			Managers.state.unit_spawner:mark_for_deletion(self.unit)
		end

		return
	end

	if length <= 0.001 then
		return
	end

	local _get_new_rotation = self:_get_new_rotation(normalize, time_lived)

	self:_unit_set_position_rotation(arg_4_1, var_4_2, _get_new_rotation)
	self._last_position:store(unbox)
	self._position:store(var_4_2)
	self.velocity:store(num)
	self._rotation:store(_get_new_rotation)

	self.moved = true
	self.t = arg_4_5
end

local num = 9

ProjectileScriptUnitLocomotionExtension._get_new_position_multiple_targetpoints = function (self, arg_5_1, arg_5_2)
	-- function 5
	local speed = self.speed
	local radians = self.radians
	local gravity = self.gravity
	local is_husk = self.is_husk
	local get_trajectory_template = ProjectileTemplates.get_trajectory_template(self.trajectory_template_name, is_husk)
	local unbox = self.target_vector_boxed:unbox()
	local unbox_2 = Vector3Box.unbox(self.initial_position_boxed)
	local unbox_3 = self.target_positions[self.current_target_index]:unbox()
	local unbox_4 = self._position:unbox()

	self.traversal_data.current_target = unbox_3
	self.traversal_data.position = unbox_4
	self.traversal_data.random_x_axis = self.random_x_axis
	self.traversal_data.random_y_axis = self.random_y_axis
	self.traversal_data.distance_to_traverse = self.distance_to_traverse

	local update = get_trajectory_template.update(speed, radians, gravity, unbox_2, unbox, arg_5_1, arg_5_2, self.traversal_data)

	if not (Vector3.distance_squared(update, unbox_3) < num) then
		return update
	end

	if not (#self.target_positions > self.current_target_index) then
		self.current_target_index = self.current_target_index + 1
		self.trajectory_template_name = "straight_target_traversal"
	elseif not self.impact_with_last_target then
		if 0.010000000000000002 > Vector3.distance_squared(update, unbox_3) then
			ScriptUnit.extension(self.unit, "projectile_system"):force_impact(self.unit, update)
		end
	else
		self:rotate_projectile_away_from_target(update, unbox_4)
		Unit.flow_event(self.target_units[self.current_target_index], "deflect_projectile")

		self.trajectory_template_name = "straight_direction_traversal"
	end

	return update
end

ProjectileScriptUnitLocomotionExtension._get_new_position = function (self, arg_6_1, arg_6_2)
	-- function 6
	local speed = self.speed
	local trajectory_template_name = self.trajectory_template_name

	if trajectory_template_name == "throw_trajectory" then
		speed = speed / 100
	end

	local radians = self.radians
	local gravity = self.gravity
	local is_husk = self.is_husk
	local get_trajectory_template = ProjectileTemplates.get_trajectory_template(trajectory_template_name, is_husk)
	local unbox = self.target_vector_boxed:unbox()
	local unbox_2 = Vector3Box.unbox(self.initial_position_boxed)
	local unbox_3 = self._position:unbox()
	local tbl = {
		position = unbox_3
	}

	return (get_trajectory_template.update(speed, radians, gravity, unbox_2, unbox, arg_6_1, arg_6_2, tbl))
end

ProjectileScriptUnitLocomotionExtension._get_new_rotation = function (self, arg_7_1, arg_7_2)
	-- function 7
	local normalize = Vector3.normalize(arg_7_1)
	local look = Quaternion.look(normalize)

	if not self.rotation_offset then
		look = Quaternion.multiply(look, Quaternion.from_euler_angles_xyz(self.rotation_offset.x, self.rotation_offset.y, self.rotation_offset.z))
	end

	if self.rotation_speed ~= 0 then
		local look_2 = Quaternion.look(normalize, Vector3.up())
		local var_7_3

		if not self.rotate_around_forward then
			var_7_3 = Quaternion.forward(look_2)
		else
			var_7_3 = -Quaternion.right(look_2)
		end

		look = Quaternion.multiply(Quaternion.axis_angle(var_7_3, arg_7_2 * self.rotation_speed), look)
	end

	return look
end

ProjectileScriptUnitLocomotionExtension.rotate_projectile_away_from_target = function (self, arg_8_1, arg_8_2)
	-- function 8
	self.has_reached_all_targets = true
	self._has_multiple_targets = false

	local normalize = Vector3.normalize(arg_8_1 - arg_8_2)
	local get_uniformly_random_point_inside_sector, var_8_2 = math.get_uniformly_random_point_inside_sector(0.75, 1.5, 0, 2 * math.pi)
	local rotate = Quaternion.rotate(Quaternion.look(normalize, Vector3.up()), Vector3.normalize(Vector3(get_uniformly_random_point_inside_sector, 2, var_8_2)))

	self.target_vector_boxed = Vector3Box(rotate)
end

ProjectileScriptUnitLocomotionExtension._unit_set_position_rotation = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	Unit.set_local_rotation(arg_9_1, 0, arg_9_3)
	Unit.set_local_position(arg_9_1, 0, arg_9_2)
end

ProjectileScriptUnitLocomotionExtension.moved_this_frame = function (self)
	-- function 10
	return self.moved
end

ProjectileScriptUnitLocomotionExtension.current_velocity = function (self)
	-- function 11
	return self.velocity:unbox()
end

ProjectileScriptUnitLocomotionExtension.current_position = function (self)
	-- function 12
	return self._position:unbox()
end

ProjectileScriptUnitLocomotionExtension.current_rotation = function (self)
	-- function 13
	return self._rotation:unbox()
end

ProjectileScriptUnitLocomotionExtension.last_position = function (self)
	-- function 14
	return self._last_position:unbox()
end

ProjectileScriptUnitLocomotionExtension.stop = function (self)
	-- function 15
	self.stopped = true
end

ProjectileScriptUnitLocomotionExtension.has_stopped = function (self)
	-- function 16
	return self.stopped
end
