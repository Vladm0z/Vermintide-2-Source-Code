-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_third_person_tunneling.lua

CameraStateFollowThirdPersonTunneling = class(CameraStateFollowThirdPersonTunneling, CameraState)

function CameraStateFollowThirdPersonTunneling.init(arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "follow_third_person_tunneling")
end

function CameraStateFollowThirdPersonTunneling.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.camera_extension
	local var_2_1, var_2_2 = var_2_0:get_follow_data()
	local var_2_3 = var_2_0.viewport_name

	arg_2_0._follow_unit = var_2_1
	arg_2_0._follow_node = var_2_2
	arg_2_0._unit = arg_2_1

	local var_2_4 = Managers.state.camera
	local var_2_5 = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(var_2_1, 0))))
	local var_2_6 = math.atan2(var_2_5.y, var_2_5.x)

	var_2_4:set_pitch_yaw(var_2_3, -0.6, var_2_6)
	Unit.set_data(arg_2_1, "camera", "settings_node", "tunneling")

	arg_2_0.total_lerp_time = 2
	arg_2_0.lerp_time = 0
	arg_2_0.progress = 0
	arg_2_0.calculate_lerp = true
	arg_2_0.camera_start_pose = Matrix4x4Box(Unit.local_pose(arg_2_1, 0))
end

function CameraStateFollowThirdPersonTunneling.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._follow_unit = nil
end

function CameraStateFollowThirdPersonTunneling.update_tunnel_camera_position(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._unit

	Unit.set_local_position(var_4_0, 0, arg_4_1)

	local var_4_1 = arg_4_0._follow_unit
	local var_4_2 = Unit.local_position(var_4_1, 0) - arg_4_1
	local var_4_3 = Quaternion.look(var_4_2)

	Unit.set_local_rotation(var_4_0, 0, var_4_3)

	arg_4_0.calculate_lerp = true
	arg_4_0.total_lerp_time = 2
	arg_4_0.lerp_time = 0
	arg_4_0.progress = 0
	arg_4_0.calculate_lerp = true
	arg_4_0.camera_start_pose = Matrix4x4Box(Unit.local_pose(var_4_0, 0))
end

function CameraStateFollowThirdPersonTunneling.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.camera_extension
	local var_5_2 = arg_5_0._follow_unit

	if not Unit.alive(var_5_2) then
		var_5_0:change_state("idle")

		return
	end

	local var_5_3 = var_5_1.external_state_change
	local var_5_4 = var_5_1.external_state_change_params

	if var_5_3 and var_5_3 ~= arg_5_0.name then
		var_5_0:change_state(var_5_3, var_5_4)
		var_5_1:set_external_state_change(nil)

		return
	end

	if arg_5_0.calculate_lerp then
		local var_5_5 = arg_5_0.total_lerp_time
		local var_5_6 = arg_5_0.lerp_time
		local var_5_7 = arg_5_0.progress
		local var_5_8 = math.min(var_5_6 + arg_5_3, var_5_5)
		local var_5_9 = var_5_8 / var_5_5
		local var_5_10 = math.smoothstep(var_5_9, 0, 1)
		local var_5_11 = Unit.local_pose(var_5_2, 0)
		local var_5_12 = arg_5_0.camera_start_pose:unbox()
		local var_5_13 = Matrix4x4.lerp(var_5_12, var_5_11, var_5_10)

		Unit.set_local_pose(arg_5_1, 0, var_5_13)

		if var_5_7 == 1 then
			arg_5_0.calculate_lerp = nil
			arg_5_0.camera_start_pose = nil
			arg_5_0.total_lerp_time = nil
			arg_5_0.lerp_time = nil
			arg_5_0.progress = nil
		else
			arg_5_0.progress = var_5_9
			arg_5_0.lerp_time = var_5_8
		end
	end
end
