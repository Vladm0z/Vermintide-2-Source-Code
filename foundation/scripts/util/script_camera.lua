-- chunkname: @foundation/scripts/util/script_camera.lua

local ScriptCamera = ScriptCamera

ScriptCamera = ScriptCamera or {}
ScriptCamera = ScriptCamera

ScriptCamera.position = function (arg_1_0)
	-- function 1
	local get_data = Camera.get_data(arg_1_0, "unit")

	return Unit.local_position(get_data, 0)
end

ScriptCamera.rotation = function (arg_2_0)
	-- function 2
	local get_data = Camera.get_data(arg_2_0, "unit")

	return Unit.local_rotation(get_data, 0)
end

ScriptCamera.pose = function (arg_3_0)
	-- function 3
	local get_data = Camera.get_data(arg_3_0, "unit")

	return Unit.local_pose(get_data, 0)
end

ScriptCamera.set_local_position = function (arg_4_0, arg_4_1)
	-- function 4
	local get_data = Camera.get_data(arg_4_0, "unit")

	Camera.set_local_position(arg_4_0, get_data, arg_4_1)
end

ScriptCamera.set_local_rotation = function (arg_5_0, arg_5_1)
	-- function 5
	local get_data = Camera.get_data(arg_5_0, "unit")

	Camera.set_local_rotation(arg_5_0, get_data, arg_5_1)
end

ScriptCamera.set_local_pose = function (arg_6_0, arg_6_1)
	-- function 6
	local get_data = Camera.get_data(arg_6_0, "unit")

	Camera.set_local_pose(arg_6_0, get_data, arg_6_1)
end

ScriptCamera.force_update = function (arg_7_0, arg_7_1)
	-- function 7
	local get_data = Camera.get_data(arg_7_1, "unit")

	World.update_unit(arg_7_0, get_data)
end

ScriptCamera.world_to_screen_uv = function (...)
	-- function 8
	local world_to_screen = Camera.world_to_screen(...)
	local resolution, var_8_2 = Application.resolution()

	return Vector3(world_to_screen[1] / resolution, world_to_screen[2] / var_8_2, 0)
end
