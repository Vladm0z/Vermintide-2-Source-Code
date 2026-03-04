-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow.lua

CameraStateFollow = class(CameraStateFollow, CameraState)

CameraStateFollow.init = function (arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "follow")

	arg_1_0._follow_unit = nil
	arg_1_0._follow_node = 0
end

CameraStateFollow.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0, var_2_1 = arg_2_0.camera_extension:get_follow_data()

	arg_2_0._follow_unit = var_2_0
	arg_2_0._follow_node = var_2_1

	Unit.set_data(arg_2_1, "camera", "settings_node", "first_person_node")

	local var_2_2 = Managers.mechanism:current_mechanism_name()

	if arg_2_6 == "camera_state_interaction" or var_2_2 == "versus" and arg_2_6 == "observer" then
		arg_2_0.total_lerp_time = UISettings.map.camera_time_exit
		arg_2_0.lerp_time = 0
		arg_2_0.progress = 0
		arg_2_0.calculate_lerp = true
		arg_2_0.camera_start_pose = Matrix4x4Box(Unit.world_pose(arg_2_1, 0))
	end
end

CameraStateFollow.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._follow_unit = nil
end

CameraStateFollow.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.camera_extension
	local var_4_3 = arg_4_0._follow_unit
	local var_4_4 = arg_4_0._follow_node

	if not Unit.alive(var_4_3) then
		var_4_0:change_state("idle")

		return
	end

	local var_4_5 = var_4_2.external_state_change
	local var_4_6 = var_4_2.external_state_change_params

	if var_4_5 and var_4_5 ~= arg_4_0.name then
		var_4_0:change_state(var_4_5, var_4_6)
		var_4_2:set_external_state_change(nil)

		return
	end

	CameraStateHelper.set_local_pose(var_4_1, var_4_3, var_4_4)

	if arg_4_0.calculate_lerp then
		local var_4_7 = arg_4_0.total_lerp_time
		local var_4_8 = arg_4_0.lerp_time
		local var_4_9 = arg_4_0.progress
		local var_4_10 = math.min(var_4_8 + arg_4_3, var_4_7)
		local var_4_11 = var_4_10 / var_4_7
		local var_4_12 = math.smoothstep(var_4_11, 0, 1)
		local var_4_13 = Unit.world_pose(var_4_3, 0)
		local var_4_14 = arg_4_0.camera_start_pose:unbox()
		local var_4_15 = Matrix4x4.lerp(var_4_14, var_4_13, var_4_12)

		assert(Matrix4x4.is_valid(var_4_15), "Camera unit lerp pose invalid.")
		Unit.set_local_pose(var_4_1, 0, var_4_15)

		if var_4_9 == 1 then
			arg_4_0.calculate_lerp = nil
			arg_4_0.camera_start_pose = nil
			arg_4_0.total_lerp_time = nil
			arg_4_0.lerp_time = nil
			arg_4_0.progress = nil
		else
			arg_4_0.progress = var_4_11
			arg_4_0.lerp_time = var_4_10
		end
	end
end
