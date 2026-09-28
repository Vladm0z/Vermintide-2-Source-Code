-- chunkname: @scripts/unit_extensions/cutscene_camera/cutscene_camera.lua

CutsceneCamera = class(CutsceneCamera)

CutsceneCamera.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	local world = extension_init_context.world

	self.level = LevelHelper:current_level(world)
	self.unit = unit
	self.camera = Unit.camera(self.unit, "camera")
	self.viewport = "player_1"
	self.source_camera = nil
	self.target_camera = nil
	self.transition_start_time = nil
	self.transition_end_time = nil

	local get_data = Unit.get_data(self.unit, "near_range")

	if not get_data then
		-- Nothing
	end

	get_data = 0.1

	local near_range = get_data

	::label_1_0::

	local get_data_2 = Unit.get_data(self.unit, "far_range")

	if not get_data_2 then
		-- Nothing
	end

	get_data_2 = 1000

	local far_range = get_data_2

	::label_1_1::

	Camera.set_near_range(self.camera, near_range)
	Camera.set_far_range(self.camera, far_range)
end

CutsceneCamera.destroy = function (self)
	-- function 2
	self.level = nil
	self.unit = nil
	self.camera = nil
	self.source_camera = nil
	self.target_camera = nil
end

CutsceneCamera.activate = function (self, transition_data)
	-- function 3
	local transition = transition_data.transition
	local source_camera, target_camera, transition_start_time, transition_end_time

	if transition == "NONE" then
		source_camera = self
	end

	if transition == "PLAYER_TO_CUTSCENE" then
		local external_camera = self:setup_external_camera(transition, "first_person", "first_person_node")
		local time = Managers.time:time("game")

		source_camera = external_camera
		target_camera = self

		local transition_start_time_2 = transition_data.transition_start_time

		transition_start_time_2 = not not transition_start_time_2 or not not 0
		transition_start_time = time + transition_start_time_2
		transition_end_time = transition_start_time + transition_data.transition_length
	end

	if transition == "CUTSCENE_TO_PLAYER" then
		local external_camera = self:setup_external_camera(transition, "first_person", "first_person_node")
		local time = Managers.time:time("game")

		source_camera = self
		target_camera = external_camera

		local transition_start_time_3 = transition_data.transition_start_time

		transition_start_time_3 = not not transition_start_time_3 or not not 0
		transition_start_time = time + transition_start_time_3
		transition_end_time = transition_start_time + transition_data.transition_length
	end

	self.source_camera = source_camera
	self.target_camera = target_camera
	self.transition_start_time = transition_start_time
	self.transition_end_time = transition_end_time
	self.allow_controls = transition_data.allow_controls

	local degrees_to_radians = math.degrees_to_radians
	local max_pitch_angle = transition_data.max_pitch_angle

	max_pitch_angle = not not max_pitch_angle or not not 0
	self.max_pitch_angle = degrees_to_radians(max_pitch_angle)

	local degrees_to_radians_2 = math.degrees_to_radians
	local max_yaw_angle = transition_data.max_yaw_angle

	max_yaw_angle = not not max_yaw_angle or not not 0
	self.max_yaw_angle = degrees_to_radians_2(max_yaw_angle)
	self.look_offset = {
		0,
		0
	}
end

CutsceneCamera.setup_external_camera = function (self, transition, tree_name, node_name)
	-- function 4
	local camera_manager = Managers.state.camera
	local camera_node = camera_manager:tree_node(self.viewport, tree_name, node_name)

	camera_node:set_active(true)
	camera_manager:force_update_nodes(0, self.viewport)

	return camera_node
end

CutsceneCamera.update = function (self)
	-- function 5
	self:update_cutscene_camera()
end

CutsceneCamera.unsafe_entity_update = function (self)
	-- function 6
	self:update_cutscene_camera()
end

CutsceneCamera.update_cutscene_camera = function (self)
	-- function 7
	local source_camera = self.source_camera
	local target_camera = self.target_camera
	local pose, vertical_fov, near_range, far_range, dof_enabled, focal_distance, focal_region, focal_padding, focal_scale

	if target_camera then
		local time = Managers.time:time("game")
		local progress = self:transition_progress(self.transition_start_time, self.transition_end_time, time)

		pose = Matrix4x4.lerp(source_camera:pose(), target_camera:pose(), progress)
		vertical_fov = math.lerp(source_camera:vertical_fov(), target_camera:vertical_fov(), progress)
		near_range = math.lerp(source_camera:near_range(), target_camera:near_range(), progress)
		far_range = math.lerp(source_camera:far_range(), target_camera:far_range(), progress)
	else
		pose = source_camera:pose()
		vertical_fov = source_camera:vertical_fov()
		near_range = source_camera:near_range()
		far_range = source_camera:far_range()
	end

	if Unit.has_data(self.unit, "dof_data") then
		local dof_data = Unit.get_data(self.unit, "dof_data")

		dof_enabled = dof_data.dof_enabled
		focal_distance = dof_data.focal_distance
		focal_region = dof_data.focal_region
		focal_padding = dof_data.focal_padding
		focal_scale = dof_data.focal_scale
	else
		dof_enabled = 0
	end

	if self.allow_controls then
		self:_handle_input(pose)
	end

	local camera_manager = Managers.state.camera
	local viewport = self.viewport

	camera_manager:set_node_tree_root_position(viewport, "cutscene", Matrix4x4.translation(pose))
	camera_manager:set_node_tree_root_rotation(viewport, "cutscene", Matrix4x4.rotation(pose))
	camera_manager:set_node_tree_root_vertical_fov(viewport, "cutscene", vertical_fov)
	camera_manager:set_node_tree_root_near_range(viewport, "cutscene", near_range)
	camera_manager:set_node_tree_root_far_range(viewport, "cutscene", far_range)
	camera_manager:set_node_tree_root_dof_enabled(viewport, "cutscene", dof_enabled)

	if dof_enabled > 0 then
		camera_manager:set_node_tree_root_focal_distance(viewport, "cutscene", focal_distance)
		camera_manager:set_node_tree_root_focal_region(viewport, "cutscene", focal_region)
		camera_manager:set_node_tree_root_focal_padding(viewport, "cutscene", focal_padding)
		camera_manager:set_node_tree_root_focal_scale(viewport, "cutscene", focal_scale)
	end

	camera_manager:set_camera_node(viewport, "cutscene", "root_node")
end

CutsceneCamera._handle_input = function (self, pose)
	-- function 8
	local input_service = Managers.input:get_input_service("cutscene")

	if input_service and input_service:is_blocked() then
		return
	end

	local look_delta
	local gamepad_active = Managers.input:is_device_active("gamepad")

	if gamepad_active then
		local gamepad = Managers.input:get_most_recent_device()
		local look_delta_raw = gamepad.axis(gamepad.axis_index("right"))
		local gamepad_look_invert_y = Application.user_setting("gamepad_look_invert_y")

		look_delta = look_delta_raw * 0.025

		if not gamepad_look_invert_y then
			look_delta.y = -look_delta.y
		end
	else
		local look_delta_raw = Mouse.axis(Mouse.axis_index("mouse"))
		local user_setting = Application.user_setting("mouse_look_invert_y")

		if not user_setting then
			-- Nothing
		end

		user_setting = false

		local mouse_look_invert_y = user_setting

		::label_8_0::

		local user_setting_2 = Application.user_setting("mouse_look_sensitivity")

		if not user_setting_2 then
			-- Nothing
		end

		user_setting_2 = 0

		local mouse_look_sensitivity = user_setting_2

		::label_8_1::

		look_delta = look_delta_raw * 0.0006 * 0.85^-mouse_look_sensitivity

		if mouse_look_invert_y then
			look_delta.y = -look_delta.y
		end
	end

	if math.sign(look_delta.x) ~= math.sign(self.look_offset[1]) then
		look_delta.x = look_delta.x * math.clamp(math.easeInCubic(1 - math.abs(self.look_offset[1]) / self.max_yaw_angle), 0.01, 1)
	end

	if math.sign(look_delta.y) ~= math.sign(self.look_offset[2]) then
		look_delta.y = look_delta.y * math.clamp(math.easeInCubic(1 - math.abs(self.look_offset[2]) / self.max_pitch_angle), 0.01, 1)
	end

	self.look_offset[1] = math.clamp(self.look_offset[1] - look_delta.x, -self.max_yaw_angle, self.max_yaw_angle)
	self.look_offset[2] = math.clamp(self.look_offset[2] - look_delta.y, -self.max_pitch_angle, self.max_pitch_angle)

	local current_rotation = Matrix4x4.rotation(pose)
	local yaw = Quaternion.yaw(current_rotation) + self.look_offset[1]
	local pitch = Quaternion.pitch(current_rotation) + self.look_offset[2]
	local roll = Quaternion.roll(current_rotation)
	local rotation_yaw = Quaternion(Vector3(0, 0, 1), yaw)
	local rotation_pitch = Quaternion(Vector3(1, 0, 0), pitch)
	local rotation_roll = Quaternion(Vector3(0, 1, 0), roll)
	local offset_rotation = Quaternion.multiply(Quaternion.multiply(rotation_yaw, rotation_pitch), rotation_roll)

	Matrix4x4.set_rotation(pose, offset_rotation)
end

CutsceneCamera.transition_progress = function (self, start_time, end_time, time)
	-- function 9
	local progress
	local interpolation_time = end_time - start_time

	if interpolation_time <= 0.001 then
		progress = 1
	else
		progress = math.clamp((time - start_time) / interpolation_time, 0, 1)
		progress = (3 - 2 * progress) * progress^2
	end

	return progress
end

CutsceneCamera.pose = function (self)
	-- function 10
	return Unit.world_pose(self.unit, 0)
end

CutsceneCamera.vertical_fov = function (self)
	-- function 11
	return Camera.vertical_fov(self.camera)
end

CutsceneCamera.near_range = function (self)
	-- function 12
	return Camera.near_range(self.camera)
end

CutsceneCamera.far_range = function (self)
	-- function 13
	return Camera.far_range(self.camera)
end
