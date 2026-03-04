-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_chaos_spawn_grabbed.lua

CameraStateFollowChaosSpawnGrabbed = class(CameraStateFollowChaosSpawnGrabbed, CameraState)

CameraStateFollowChaosSpawnGrabbed.init = function (arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "chaos_spawn_grabbed")

	arg_1_0._follow_unit = nil
	arg_1_0._follow_node = 0
end

CameraStateFollowChaosSpawnGrabbed.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.camera_extension
	local var_2_1, var_2_2 = var_2_0:get_follow_data()
	local var_2_3 = var_2_0.viewport_name

	arg_2_0._follow_unit = var_2_1
	arg_2_0._follow_node = var_2_2

	local var_2_4 = Managers.state.camera
	local var_2_5 = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(var_2_1, 0))))
	local var_2_6 = math.atan2(var_2_5.y, var_2_5.x)

	var_2_4:set_pitch_yaw(var_2_3, -0.5, var_2_6)
	Unit.set_data(arg_2_1, "camera", "settings_node", "chaos_spawn_grabbed")
end

CameraStateFollowChaosSpawnGrabbed.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._follow_unit = nil
end

CameraStateFollowChaosSpawnGrabbed.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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
end
