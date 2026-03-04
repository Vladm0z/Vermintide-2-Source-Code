-- chunkname: @foundation/scripts/util/script_camera.lua

ScriptCamera = ScriptCamera or {}

function ScriptCamera.position(arg_1_0)
	local var_1_0 = Camera.get_data(arg_1_0, "unit")

	return Unit.local_position(var_1_0, 0)
end

function ScriptCamera.rotation(arg_2_0)
	local var_2_0 = Camera.get_data(arg_2_0, "unit")

	return Unit.local_rotation(var_2_0, 0)
end

function ScriptCamera.pose(arg_3_0)
	local var_3_0 = Camera.get_data(arg_3_0, "unit")

	return Unit.local_pose(var_3_0, 0)
end

function ScriptCamera.set_local_position(arg_4_0, arg_4_1)
	local var_4_0 = Camera.get_data(arg_4_0, "unit")

	Camera.set_local_position(arg_4_0, var_4_0, arg_4_1)
end

function ScriptCamera.set_local_rotation(arg_5_0, arg_5_1)
	local var_5_0 = Camera.get_data(arg_5_0, "unit")

	Camera.set_local_rotation(arg_5_0, var_5_0, arg_5_1)
end

function ScriptCamera.set_local_pose(arg_6_0, arg_6_1)
	local var_6_0 = Camera.get_data(arg_6_0, "unit")

	Camera.set_local_pose(arg_6_0, var_6_0, arg_6_1)
end

function ScriptCamera.force_update(arg_7_0, arg_7_1)
	local var_7_0 = Camera.get_data(arg_7_1, "unit")

	World.update_unit(arg_7_0, var_7_0)
end

function ScriptCamera.world_to_screen_uv(...)
	local var_8_0 = Camera.world_to_screen(...)
	local var_8_1, var_8_2 = Application.resolution()

	return Vector3(var_8_0[1] / var_8_1, var_8_0[2] / var_8_2, 0)
end
