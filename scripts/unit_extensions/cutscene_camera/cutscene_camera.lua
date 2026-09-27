-- chunkname: @scripts/unit_extensions/cutscene_camera/cutscene_camera.lua

CutsceneCamera = class(CutsceneCamera)

CutsceneCamera.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.level = LevelHelper:current_level(world)
	self.unit = arg_1_2
	self.camera = Unit.camera(self.unit, "camera")
	self.viewport = "player_1"
	self.source_camera = nil
	self.target_camera = nil
	self.transition_start_time = nil
	self.transition_end_time = nil

	local get_data = Unit.get_data(self.unit, "near_range")

	get_data = get_data or 0.1

	local get_data_2 = Unit.get_data(self.unit, "far_range")

	get_data_2 = get_data_2 or 1000

	Camera.set_near_range(self.camera, get_data)
	Camera.set_far_range(self.camera, get_data_2)
end

CutsceneCamera.destroy = function (self)
	-- function 2
	self.level = nil
	self.unit = nil
	self.camera = nil
	self.source_camera = nil
	self.target_camera = nil
end

CutsceneCamera.activate = function (self, arg_3_1)
	-- function 3
	local transition = arg_3_1.transition
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4

	if transition == "NONE" then
		var_3_1 = self
	end

	if transition == "PLAYER_TO_CUTSCENE" then
		local time

		var_3_1, time = self:setup_external_camera(transition, "first_person", "first_person_node"), Managers.time:time("game")
		var_3_2 = self

		local transition_start_time = arg_3_1.transition_start_time

		transition_start_time = transition_start_time or 0
		var_3_3 = time + transition_start_time
		var_3_4 = var_3_3 + arg_3_1.transition_length
	end

	if transition == "CUTSCENE_TO_PLAYER" then
		local setup_external_camera = self:setup_external_camera(transition, "first_person", "first_person_node")
		local time_2 = Managers.time:time("game")

		var_3_1 = self
		var_3_2 = setup_external_camera

		local transition_start_time_2 = arg_3_1.transition_start_time

		transition_start_time_2 = transition_start_time_2 or 0
		var_3_3 = time_2 + transition_start_time_2
		var_3_4 = var_3_3 + arg_3_1.transition_length
	end

	self.source_camera = var_3_1
	self.target_camera = var_3_2
	self.transition_start_time = var_3_3
	self.transition_end_time = var_3_4
	self.allow_controls = arg_3_1.allow_controls

	local degrees_to_radians = math.degrees_to_radians
	local max_pitch_angle = arg_3_1.max_pitch_angle

	max_pitch_angle = max_pitch_angle or 0
	self.max_pitch_angle = degrees_to_radians(max_pitch_angle)

	local degrees_to_radians_2 = math.degrees_to_radians
	local max_yaw_angle = arg_3_1.max_yaw_angle

	max_yaw_angle = max_yaw_angle or 0
	self.max_yaw_angle = degrees_to_radians_2(max_yaw_angle)
	self.look_offset = {
		0,
		0
	}
end

CutsceneCamera.setup_external_camera = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local camera = Managers.state.camera
	local tree_node = camera:tree_node(self.viewport, arg_4_2, arg_4_3)

	tree_node:set_active(true)
	camera:force_update_nodes(0, self.viewport)

	return tree_node
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
	local var_7_2
	local var_7_3
	local var_7_4
	local var_7_5
	local var_7_6
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10

	if not target_camera then
		local time = Managers.time:time("game")
		local transition_progress = self:transition_progress(self.transition_start_time, self.transition_end_time, time)

		var_7_2 = Matrix4x4.lerp(source_camera:pose(), target_camera:pose(), transition_progress)
		var_7_3 = math.lerp(source_camera:vertical_fov(), target_camera:vertical_fov(), transition_progress)
		var_7_4 = math.lerp(source_camera:near_range(), target_camera:near_range(), transition_progress)
		var_7_5 = math.lerp(source_camera:far_range(), target_camera:far_range(), transition_progress)
	else
		var_7_2 = source_camera:pose()
		var_7_3 = source_camera:vertical_fov()
		var_7_4 = source_camera:near_range()
		var_7_5 = source_camera:far_range()
	end

	if not Unit.has_data(self.unit, "dof_data") then
		local get_data = Unit.get_data(self.unit, "dof_data")

		var_7_6 = get_data.dof_enabled
		var_7_7 = get_data.focal_distance
		var_7_8 = get_data.focal_region
		var_7_9 = get_data.focal_padding
		var_7_10 = get_data.focal_scale
	else
		var_7_6 = 0
	end

	if not self.allow_controls then
		self:_handle_input(var_7_2)
	end

	local camera = Managers.state.camera
	local viewport = self.viewport

	camera:set_node_tree_root_position(viewport, "cutscene", Matrix4x4.translation(var_7_2))
	camera:set_node_tree_root_rotation(viewport, "cutscene", Matrix4x4.rotation(var_7_2))
	camera:set_node_tree_root_vertical_fov(viewport, "cutscene", var_7_3)
	camera:set_node_tree_root_near_range(viewport, "cutscene", var_7_4)
	camera:set_node_tree_root_far_range(viewport, "cutscene", var_7_5)
	camera:set_node_tree_root_dof_enabled(viewport, "cutscene", var_7_6)

	if var_7_6 > 0 then
		camera:set_node_tree_root_focal_distance(viewport, "cutscene", var_7_7)
		camera:set_node_tree_root_focal_region(viewport, "cutscene", var_7_8)
		camera:set_node_tree_root_focal_padding(viewport, "cutscene", var_7_9)
		camera:set_node_tree_root_focal_scale(viewport, "cutscene", var_7_10)
	end

	camera:set_camera_node(viewport, "cutscene", "root_node")
end

CutsceneCamera._handle_input = function (self, arg_8_1)
	-- function 8
	local get_input_service = Managers.input:get_input_service("cutscene")

	if not get_input_service and not get_input_service:is_blocked() then
		return
	end

	local var_8_1

	if not Managers.input:is_device_active("gamepad") then
		local get_most_recent_device = Managers.input:get_most_recent_device()
		local axis = get_most_recent_device.axis(get_most_recent_device.axis_index("right"))
		local user_setting = Application.user_setting("gamepad_look_invert_y")

		var_8_1 = axis * 0.025

		if not user_setting then
			var_8_1.y = -var_8_1.y
		end
	else
		local axis_2 = Mouse.axis(Mouse.axis_index("mouse"))
		local user_setting_2 = Application.user_setting("mouse_look_invert_y")

		user_setting_2 = user_setting_2 or false

		local user_setting_3 = Application.user_setting("mouse_look_sensitivity")

		user_setting_3 = user_setting_3 or 0
		var_8_1 = axis_2 * 0.0006 * 0.85^-user_setting_3

		if not user_setting_2 then
			var_8_1.y = -var_8_1.y
		end
	end

	if math.sign(var_8_1.x) ~= math.sign(self.look_offset[1]) then
		var_8_1.x = var_8_1.x * math.clamp(math.easeInCubic(1 - math.abs(self.look_offset[1]) / self.max_yaw_angle), 0.01, 1)
	end

	if math.sign(var_8_1.y) ~= math.sign(self.look_offset[2]) then
		var_8_1.y = var_8_1.y * math.clamp(math.easeInCubic(1 - math.abs(self.look_offset[2]) / self.max_pitch_angle), 0.01, 1)
	end

	self.look_offset[1] = math.clamp(self.look_offset[1] - var_8_1.x, -self.max_yaw_angle, self.max_yaw_angle)
	self.look_offset[2] = math.clamp(self.look_offset[2] - var_8_1.y, -self.max_pitch_angle, self.max_pitch_angle)

	local rotation = Matrix4x4.rotation(arg_8_1)
	local num = Quaternion.yaw(rotation) + self.look_offset[1]
	local num_2 = Quaternion.pitch(rotation) + self.look_offset[2]
	local roll = Quaternion.roll(rotation)
	local var_8_12 = Quaternion(Vector3(0, 0, 1), num)
	local var_8_13 = Quaternion(Vector3(1, 0, 0), num_2)
	local var_8_14 = Quaternion(Vector3(0, 1, 0), roll)
	local multiply = Quaternion.multiply(Quaternion.multiply(var_8_12, var_8_13), var_8_14)

	Matrix4x4.set_rotation(arg_8_1, multiply)
end

CutsceneCamera.transition_progress = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0
	local num = arg_9_2 - arg_9_1
	local num_2

	if num <= 0.001 then
		num_2 = 1
	else
		local clamp = math.clamp((arg_9_3 - arg_9_1) / num, 0, 1)

		num_2 = (3 - 2 * clamp) * clamp^2
	end

	return num_2
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
