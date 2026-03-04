-- chunkname: @scripts/managers/camera/cameras/root_camera.lua

require("scripts/managers/camera/cameras/base_camera")

RootCamera = class(RootCamera, BaseCamera)

RootCamera.init = function (arg_1_0)
	BaseCamera.init(arg_1_0, arg_1_0)

	arg_1_0._aim_pitch = 0
	arg_1_0._aim_yaw = 0
	arg_1_0._pitch_min = -math.huge
	arg_1_0._pitch_max = math.huge
	arg_1_0._environment_params = {}
end

RootCamera.set_root_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	BaseCamera.set_root_unit(arg_2_0, arg_2_1, arg_2_2)

	if not arg_2_3 then
		local var_2_0 = Unit.world_rotation(arg_2_1, 0)
		local var_2_1 = Quaternion.forward(var_2_0)
		local var_2_2 = Vector3(var_2_1.x, var_2_1.y, 0)
		local var_2_3 = Vector3.normalize(var_2_2)
		local var_2_4 = math.atan2(var_2_3.x, var_2_3.y)

		if script_data.spawn_debug then
			Managers.state.debug:drawer({
				name = "spawn"
			}):quaternion(Unit.world_position(arg_2_1, 0), Unit.world_rotation(arg_2_1, 0), 1)
		end

		arg_2_0._aim_yaw = -var_2_4
	end
end

RootCamera.parse_parameters = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1.name then
		arg_3_0._name = arg_3_1.name
	end

	local var_3_0 = math.pi / 180

	arg_3_0._vertical_fov = arg_3_1.vertical_fov and arg_3_1.vertical_fov * var_3_0
	arg_3_0._should_apply_fov_multiplier = arg_3_1.should_apply_fov_multiplier or false
	arg_3_0._default_fov = arg_3_1.default_fov and arg_3_1.default_fov * var_3_0 or arg_3_0._vertical_fov
	arg_3_0._near_range = arg_3_1.near_range
	arg_3_0._far_range = arg_3_1.far_range
	arg_3_0._pitch_min = arg_3_1.pitch_min and arg_3_1.pitch_min * var_3_0
	arg_3_0._pitch_max = arg_3_1.pitch_max and arg_3_1.pitch_max * var_3_0
	arg_3_0._pitch_speed = arg_3_1.pitch_speed and arg_3_1.pitch_speed * var_3_0
	arg_3_0._yaw_speed = arg_3_1.yaw_speed and arg_3_1.yaw_speed * var_3_0
	arg_3_0._pitch_offset = arg_3_1.pitch_offset and arg_3_1.pitch_offset * var_3_0
	arg_3_0._safe_position_offset = arg_3_1.safe_position_offset
	arg_3_0._tree_transitions = arg_3_1.tree_transitions
	arg_3_0._node_transitions = arg_3_1.node_transitions
	arg_3_0._fade_to_black = arg_3_1.fade_to_black or 0

	if arg_3_1.root_object_name then
		arg_3_0._object_name = arg_3_1.root_object_name
	end
end

RootCamera.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not arg_4_0:active() then
		return
	end

	local var_4_0
	local var_4_1
	local var_4_2 = arg_4_0._root_unit
	local var_4_3 = arg_4_0._root_object

	if var_4_2 and Unit.alive(var_4_2) then
		var_4_0 = Unit.world_position(var_4_2, var_4_3)
		var_4_1 = Unit.world_rotation(var_4_2, var_4_3)

		arg_4_0._root_position:store(var_4_0)
		arg_4_0._root_rotation:store(var_4_1)
	else
		var_4_0 = arg_4_0._root_position:unbox()
		var_4_1 = arg_4_0._root_rotation:unbox()
	end

	BaseCamera.update(arg_4_0, arg_4_1, var_4_0, var_4_1, arg_4_2)
end

RootCamera.update_pitch_yaw = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2.pitch_speed or arg_5_0._pitch_speed
	local var_5_1 = arg_5_2.yaw_speed or arg_5_0._yaw_speed
	local var_5_2 = 1
	local var_5_3 = 1
	local var_5_4
	local var_5_5 = arg_5_2.look_controller_input and arg_5_2.look_controller_input:unbox() or Vector3(0, 0, 0)

	if arg_5_0._root_unit and Unit.alive(arg_5_0._root_unit) then
		var_5_2 = 1
		var_5_3 = 1
		var_5_4 = Unit.get_data(arg_5_0._root_unit, "camera", "dynamic_max_yaw_speed")
	end

	local var_5_6

	if var_5_4 and var_5_1 then
		arg_5_0._accumulated_dt = arg_5_0._accumulated_dt or 0

		if math.abs(var_5_5.x) > 0 then
			local var_5_7 = var_5_4 * (arg_5_0._accumulated_dt + arg_5_1)

			var_5_6 = math.clamp(var_5_5.x * var_5_1 * var_5_3, -var_5_7, var_5_7)
			arg_5_0._accumulated_dt = 0
		else
			var_5_6 = 0
			arg_5_0._accumulated_dt = arg_5_0._accumulated_dt + arg_5_1

			if arg_5_0._accumulated_dt > 0.1 then
				arg_5_0._accumulated_dt = 0
			end
		end
	elseif var_5_1 then
		arg_5_0._accumulated_dt = 0
		var_5_6 = var_5_5.x * var_5_1 * var_5_3
	end

	local var_5_8 = var_5_5.y * var_5_0 * var_5_2
	local var_5_9 = arg_5_3:constraint_function()

	if var_5_9 then
		local var_5_10 = Unit.local_rotation(arg_5_0._root_unit, 0)
		local var_5_11 = Quaternion.forward(var_5_10)
		local var_5_12 = Vector3.normalize(Vector3.flat(var_5_11))
		local var_5_13 = math.atan2(var_5_12.x, var_5_12.y)
		local var_5_14 = (var_5_13 + arg_5_0._aim_yaw + math.pi) % (2 * math.pi) - math.pi
		local var_5_15 = arg_5_0._aim_pitch
		local var_5_16, var_5_17 = var_5_9(var_5_14, var_5_15, var_5_6, var_5_8)

		arg_5_0._aim_yaw = (var_5_16 - var_5_13) % (2 * math.pi)

		if not var_5_17 then
			if var_5_0 then
				arg_5_0._aim_pitch = math.clamp(arg_5_0._aim_pitch + var_5_8, arg_5_0._pitch_min, arg_5_0._pitch_max)
			end
		else
			arg_5_0._aim_pitch = var_5_17
		end
	else
		if var_5_0 then
			arg_5_0._aim_pitch = math.clamp(arg_5_0._aim_pitch + var_5_8, arg_5_0._pitch_min, arg_5_0._pitch_max)
		end

		if var_5_1 then
			arg_5_0._aim_yaw = (arg_5_0._aim_yaw - var_5_6) % (2 * math.pi)
		end
	end
end

RootCamera.aim_pitch = function (arg_6_0)
	return arg_6_0._aim_pitch
end

RootCamera.aim_yaw = function (arg_7_0)
	return arg_7_0._aim_yaw
end

RootCamera.set_aim_pitch = function (arg_8_0, arg_8_1)
	arg_8_0._aim_pitch = arg_8_1
end

RootCamera.set_aim_yaw = function (arg_9_0, arg_9_1)
	arg_9_0._aim_yaw = arg_9_1
end
