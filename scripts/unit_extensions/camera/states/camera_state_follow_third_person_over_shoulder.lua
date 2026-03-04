-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_third_person_over_shoulder.lua

CameraStateFollowThirdPersonOverShoulder = class(CameraStateFollowThirdPersonOverShoulder, CameraState)

function CameraStateFollowThirdPersonOverShoulder.init(arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "follow_third_person_over_shoulder")

	arg_1_0._follow_unit = nil
	arg_1_0._follow_node = 0
end

function CameraStateFollowThirdPersonOverShoulder.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.camera_extension
	local var_2_1, var_2_2 = var_2_0:get_follow_data()
	local var_2_3 = var_2_0.viewport_name

	if ALIVE[var_2_1] then
		arg_2_0._follow_unit = var_2_1
		arg_2_0._follow_node = var_2_2

		local var_2_4 = Managers.state.camera
		local var_2_5 = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(var_2_1, 0))))
		local var_2_6 = math.atan2(var_2_5.y, var_2_5.x)

		var_2_4:set_pitch_yaw(var_2_3, -0.6, var_2_6)
	end

	Unit.set_data(arg_2_1, "camera", "settings_node", "over_shoulder")
end

function CameraStateFollowThirdPersonOverShoulder.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._follow_unit = nil
end

function CameraStateFollowThirdPersonOverShoulder.refresh_follow_unit(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._follow_unit = arg_4_1
	arg_4_0._follow_node = arg_4_2
end

function CameraStateFollowThirdPersonOverShoulder.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.camera_extension
	local var_5_3 = arg_5_0._follow_unit
	local var_5_4 = arg_5_0._follow_node

	if not Unit.alive(var_5_3) then
		var_5_0:change_state("idle")

		return
	end

	local var_5_5 = var_5_2.external_state_change
	local var_5_6 = var_5_2.external_state_change_params

	if var_5_5 and var_5_5 ~= arg_5_0.name then
		var_5_0:change_state(var_5_5, var_5_6)
		var_5_2:set_external_state_change(nil)

		return
	end

	CameraStateHelper.set_local_pose(var_5_1, var_5_3, var_5_4)
end
