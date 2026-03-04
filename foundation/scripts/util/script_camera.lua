-- chunkname: @foundation/scripts/util/script_camera.lua

ScriptCamera = ScriptCamera or {}

ScriptCamera.position = function (arg_1_0)
	local var_1_0 = Camera.get_data(arg_1_0, "unit")

	return Unit.local_position(var_1_0, 0)
end

ScriptCamera.rotation = function (arg_2_0)
	local var_2_0 = Camera.get_data(arg_2_0, "unit")

	return Unit.local_rotation(var_2_0, 0)
end

ScriptCamera.pose = function (arg_3_0)
	local var_3_0 = Camera.get_data(arg_3_0, "unit")

	return Unit.local_pose(var_3_0, 0)
end

ScriptCamera.set_local_position = function (arg_4_0, arg_4_1)
	local var_4_0 = Camera.get_data(arg_4_0, "unit")

	Camera.set_local_position(arg_4_0, var_4_0, arg_4_1)
end

ScriptCamera.set_local_rotation = function (arg_5_0, arg_5_1)
	local var_5_0 = Camera.get_data(arg_5_0, "unit")

	Camera.set_local_rotation(arg_5_0, var_5_0, arg_5_1)
end

ScriptCamera.set_local_pose = function (arg_6_0, arg_6_1)
	local var_6_0 = Camera.get_data(arg_6_0, "unit")

	Camera.set_local_pose(arg_6_0, var_6_0, arg_6_1)
end

ScriptCamera.force_update = function (arg_7_0, arg_7_1)
	local var_7_0 = Camera.get_data(arg_7_1, "unit")

	World.update_unit(arg_7_0, var_7_0)
end

ScriptCamera.world_to_screen_uv = function (...)
	local var_8_0 = Camera.world_to_screen(...)
	local var_8_1, var_8_2 = Application.resolution()

	return Vector3(var_8_0[1] / var_8_1, var_8_0[2] / var_8_2, 0)
end
