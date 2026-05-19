-- chunkname: @scripts/unit_extensions/cutscene_camera/cutscene_camera.lua

CutsceneCamera = class(CutsceneCamera)

function CutsceneCamera.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.level = LevelHelper:current_level(var_1_0)
	arg_1_0.unit = arg_1_2
	arg_1_0.camera = Unit.camera(arg_1_0.unit, "camera")
	arg_1_0.viewport = "player_1"
	arg_1_0.source_camera = nil
	arg_1_0.target_camera = nil
	arg_1_0.transition_start_time = nil
	arg_1_0.transition_end_time = nil

	local var_1_1 = Unit.get_data(arg_1_0.unit, "near_range") or 0.1
	local var_1_2 = Unit.get_data(arg_1_0.unit, "far_range") or 1000

	Camera.set_near_range(arg_1_0.camera, var_1_1)
	Camera.set_far_range(arg_1_0.camera, var_1_2)
end

function CutsceneCamera.destroy(arg_2_0)
	arg_2_0.level = nil
	arg_2_0.unit = nil
	arg_2_0.camera = nil
	arg_2_0.source_camera = nil
	arg_2_0.target_camera = nil
end

function CutsceneCamera.activate(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.transition
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4

	if var_3_0 == "NONE" then
		var_3_1 = arg_3_0
	end

	if var_3_0 == "PLAYER_TO_CUTSCENE" then
		local var_3_5

		var_3_1, var_3_5 = arg_3_0:setup_external_camera(var_3_0, "first_person", "first_person_node"), Managers.time:time("game")
		var_3_2 = arg_3_0
		var_3_3 = var_3_5 + (arg_3_1.transition_start_time or 0)
		var_3_4 = var_3_3 + arg_3_1.transition_length
	end

	if var_3_0 == "CUTSCENE_TO_PLAYER" then
		local var_3_6 = arg_3_0:setup_external_camera(var_3_0, "first_person", "first_person_node")
		local var_3_7 = Managers.time:time("game")

		var_3_1 = arg_3_0
		var_3_2 = var_3_6
		var_3_3 = var_3_7 + (arg_3_1.transition_start_time or 0)
		var_3_4 = var_3_3 + arg_3_1.transition_length
	end

	arg_3_0.source_camera = var_3_1
	arg_3_0.target_camera = var_3_2
	arg_3_0.transition_start_time = var_3_3
	arg_3_0.transition_end_time = var_3_4
	arg_3_0.allow_controls = arg_3_1.allow_controls
	arg_3_0.max_pitch_angle = math.degrees_to_radians(arg_3_1.max_pitch_angle or 0)
	arg_3_0.max_yaw_angle = math.degrees_to_radians(arg_3_1.max_yaw_angle or 0)
	arg_3_0.look_offset = {
		0,
		0
	}
end

function CutsceneCamera.setup_external_camera(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = Managers.state.camera
	local var_4_1 = var_4_0:tree_node(arg_4_0.viewport, arg_4_2, arg_4_3)

	var_4_1:set_active(true)
	var_4_0:force_update_nodes(0, arg_4_0.viewport)

	return var_4_1
end

function CutsceneCamera.update(arg_5_0)
	arg_5_0:update_cutscene_camera()
end

function CutsceneCamera.unsafe_entity_update(arg_6_0)
	arg_6_0:update_cutscene_camera()
end

function CutsceneCamera.update_cutscene_camera(arg_7_0)
	local var_7_0 = arg_7_0.source_camera
	local var_7_1 = arg_7_0.target_camera
	local var_7_2
	local var_7_3
	local var_7_4
	local var_7_5
	local var_7_6
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10

	if var_7_1 then
		local var_7_11 = Managers.time:time("game")
		local var_7_12 = arg_7_0:transition_progress(arg_7_0.transition_start_time, arg_7_0.transition_end_time, var_7_11)

		var_7_2 = Matrix4x4.lerp(var_7_0:pose(), var_7_1:pose(), var_7_12)
		var_7_3 = math.lerp(var_7_0:vertical_fov(), var_7_1:vertical_fov(), var_7_12)
		var_7_4 = math.lerp(var_7_0:near_range(), var_7_1:near_range(), var_7_12)
		var_7_5 = math.lerp(var_7_0:far_range(), var_7_1:far_range(), var_7_12)
	else
		var_7_2 = var_7_0:pose()
		var_7_3 = var_7_0:vertical_fov()
		var_7_4 = var_7_0:near_range()
		var_7_5 = var_7_0:far_range()
	end

	if Unit.has_data(arg_7_0.unit, "dof_data") then
		local var_7_13 = Unit.get_data(arg_7_0.unit, "dof_data")

		var_7_6 = var_7_13.dof_enabled
		var_7_7 = var_7_13.focal_distance
		var_7_8 = var_7_13.focal_region
		var_7_9 = var_7_13.focal_padding
		var_7_10 = var_7_13.focal_scale
	else
		var_7_6 = 0
	end

	if arg_7_0.allow_controls then
		arg_7_0:_handle_input(var_7_2)
	end

	local var_7_14 = Managers.state.camera
	local var_7_15 = arg_7_0.viewport

	var_7_14:set_node_tree_root_position(var_7_15, "cutscene", Matrix4x4.translation(var_7_2))
	var_7_14:set_node_tree_root_rotation(var_7_15, "cutscene", Matrix4x4.rotation(var_7_2))
	var_7_14:set_node_tree_root_vertical_fov(var_7_15, "cutscene", var_7_3)
	var_7_14:set_node_tree_root_near_range(var_7_15, "cutscene", var_7_4)
	var_7_14:set_node_tree_root_far_range(var_7_15, "cutscene", var_7_5)
	var_7_14:set_node_tree_root_dof_enabled(var_7_15, "cutscene", var_7_6)

	if var_7_6 > 0 then
		var_7_14:set_node_tree_root_focal_distance(var_7_15, "cutscene", var_7_7)
		var_7_14:set_node_tree_root_focal_region(var_7_15, "cutscene", var_7_8)
		var_7_14:set_node_tree_root_focal_padding(var_7_15, "cutscene", var_7_9)
		var_7_14:set_node_tree_root_focal_scale(var_7_15, "cutscene", var_7_10)
	end

	var_7_14:set_camera_node(var_7_15, "cutscene", "root_node")
end

function CutsceneCamera._handle_input(arg_8_0, arg_8_1)
	local var_8_0 = Managers.input:get_input_service("cutscene")

	if var_8_0 and var_8_0:is_blocked() then
		return
	end

	local var_8_1

	if Managers.input:is_device_active("gamepad") then
		local var_8_2 = Managers.input:get_most_recent_device()
		local var_8_3 = var_8_2.axis(var_8_2.axis_index("right"))
		local var_8_4 = Application.user_setting("gamepad_look_invert_y")

		var_8_1 = var_8_3 * 0.025

		if not var_8_4 then
			var_8_1.y = -var_8_1.y
		end
	else
		local var_8_5 = Mouse.axis(Mouse.axis_index("mouse"))
		local var_8_6 = Application.user_setting("mouse_look_invert_y") or false
		local var_8_7 = Application.user_setting("mouse_look_sensitivity") or 0

		var_8_1 = var_8_5 * 0.0006 * 0.85^-var_8_7

		if var_8_6 then
			var_8_1.y = -var_8_1.y
		end
	end

	if math.sign(var_8_1.x) ~= math.sign(arg_8_0.look_offset[1]) then
		var_8_1.x = var_8_1.x * math.clamp(math.easeInCubic(1 - math.abs(arg_8_0.look_offset[1]) / arg_8_0.max_yaw_angle), 0.01, 1)
	end

	if math.sign(var_8_1.y) ~= math.sign(arg_8_0.look_offset[2]) then
		var_8_1.y = var_8_1.y * math.clamp(math.easeInCubic(1 - math.abs(arg_8_0.look_offset[2]) / arg_8_0.max_pitch_angle), 0.01, 1)
	end

	arg_8_0.look_offset[1] = math.clamp(arg_8_0.look_offset[1] - var_8_1.x, -arg_8_0.max_yaw_angle, arg_8_0.max_yaw_angle)
	arg_8_0.look_offset[2] = math.clamp(arg_8_0.look_offset[2] - var_8_1.y, -arg_8_0.max_pitch_angle, arg_8_0.max_pitch_angle)

	local var_8_8 = Matrix4x4.rotation(arg_8_1)
	local var_8_9 = Quaternion.yaw(var_8_8) + arg_8_0.look_offset[1]
	local var_8_10 = Quaternion.pitch(var_8_8) + arg_8_0.look_offset[2]
	local var_8_11 = Quaternion.roll(var_8_8)
	local var_8_12 = Quaternion(Vector3(0, 0, 1), var_8_9)
	local var_8_13 = Quaternion(Vector3(1, 0, 0), var_8_10)
	local var_8_14 = Quaternion(Vector3(0, 1, 0), var_8_11)
	local var_8_15 = Quaternion.multiply(Quaternion.multiply(var_8_12, var_8_13), var_8_14)

	Matrix4x4.set_rotation(arg_8_1, var_8_15)
end

function CutsceneCamera.transition_progress(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0
	local var_9_1 = arg_9_2 - arg_9_1
	local var_9_2

	if var_9_1 <= 0.001 then
		var_9_2 = 1
	else
		local var_9_3 = math.clamp((arg_9_3 - arg_9_1) / var_9_1, 0, 1)

		var_9_2 = (3 - 2 * var_9_3) * var_9_3^2
	end

	return var_9_2
end

function CutsceneCamera.pose(arg_10_0)
	return Unit.world_pose(arg_10_0.unit, 0)
end

function CutsceneCamera.vertical_fov(arg_11_0)
	return Camera.vertical_fov(arg_11_0.camera)
end

function CutsceneCamera.near_range(arg_12_0)
	return Camera.near_range(arg_12_0.camera)
end

function CutsceneCamera.far_range(arg_13_0)
	return Camera.far_range(arg_13_0.camera)
end
