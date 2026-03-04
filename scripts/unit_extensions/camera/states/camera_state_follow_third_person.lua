-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_third_person.lua

CameraStateFollowThirdPerson = class(CameraStateFollowThirdPerson, CameraState)

function CameraStateFollowThirdPerson.init(arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "follow_third_person")

	arg_1_0._follow_unit = nil
	arg_1_0._follow_node = 0
end

function CameraStateFollowThirdPerson.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.camera_extension
	local var_2_1, var_2_2 = var_2_0:get_follow_data()
	local var_2_3 = var_2_0.viewport_name

	arg_2_0._min_leave_t = arg_2_7.min_leave_t or 0

	local var_2_4 = arg_2_7.override_follow_unit

	if var_2_4 and Unit.alive(var_2_4) then
		var_2_1 = var_2_4
	end

	if not var_2_1 or not Unit.alive(var_2_1) then
		arg_2_0._follow_unit = nil

		return
	end

	local var_2_5 = arg_2_7.override_node_name

	if var_2_5 then
		if Unit.has_node(var_2_1, var_2_5) then
			var_2_2 = Unit.node(var_2_1, var_2_5)
		else
			printf(string.format("Tried to get non existing node '%s' for unit '%s'", var_2_5, tostring(var_2_1)))
		end
	end

	local var_2_6 = arg_2_7.camera_offset

	arg_2_0._camera_offset = var_2_6 and Vector3Box(var_2_6)
	arg_2_0._allow_camera_movement = arg_2_7.allow_camera_movement
	arg_2_0._follow_unit_rotation = arg_2_7.follow_unit_rotation == nil and true or arg_2_7.follow_unit_rotation
	arg_2_0._follow_unit = var_2_1
	arg_2_0._follow_node = var_2_2
	arg_2_0._fallback_pose = Matrix4x4Box(Unit.alive(var_2_1) and Unit.world_pose(var_2_1, 0) or Matrix4x4.identity())

	local var_2_7 = Managers.state.camera
	local var_2_8 = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(var_2_1, 0))))
	local var_2_9 = math.atan2(var_2_8.y, var_2_8.x)

	var_2_7:set_pitch_yaw(var_2_3, -0.6, var_2_9)
	Unit.set_data(arg_2_1, "camera", "settings_node", arg_2_7.camera_node or "heal_self")
end

function CameraStateFollowThirdPerson.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._follow_unit = nil
end

function CameraStateFollowThirdPerson.refresh_follow_unit(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._follow_unit = arg_4_1
	arg_4_0._follow_node = arg_4_2
end

function CameraStateFollowThirdPerson.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.camera_extension
	local var_5_3 = arg_5_0._follow_unit
	local var_5_4 = arg_5_0._follow_node or 0
	local var_5_5 = var_5_2.external_state_change
	local var_5_6 = var_5_2.external_state_change_params
	local var_5_7 = var_5_6 and var_5_6.force_state_change

	if var_5_5 and (var_5_5 ~= arg_5_0.name or var_5_7) then
		var_5_0:change_state(var_5_5, var_5_6)
		var_5_2:set_external_state_change(nil)

		return
	end

	if not var_5_3 or not Unit.alive(var_5_3) and arg_5_5 > arg_5_0._min_leave_t then
		var_5_0:change_state("observer")

		return
	end

	if arg_5_0.calculate_lerp then
		local var_5_8 = arg_5_0.total_lerp_time
		local var_5_9 = arg_5_0.lerp_time
		local var_5_10 = arg_5_0.progress
		local var_5_11 = math.min(var_5_9 + arg_5_3, var_5_8)
		local var_5_12 = var_5_11 / var_5_8
		local var_5_13 = math.smoothstep(var_5_12, 0, 1)

		if Unit.alive(var_5_3) then
			arg_5_0._fallback_pose:store(Unit.world_pose(var_5_3, 0))
		end

		local var_5_14 = arg_5_0._fallback_pose:unbox()
		local var_5_15 = arg_5_0.camera_start_pose:unbox()
		local var_5_16 = Matrix4x4.lerp(var_5_15, var_5_14, var_5_13)

		assert(Matrix4x4.is_valid(var_5_16), "Camera unit lerp pose invalid.")
		Unit.set_local_pose(var_5_1, 0, var_5_16)

		if var_5_10 == 1 then
			arg_5_0.calculate_lerp = nil
			arg_5_0.camera_start_pose = nil
			arg_5_0.total_lerp_time = nil
			arg_5_0.lerp_time = nil
			arg_5_0.progress = nil
		else
			arg_5_0.progress = var_5_12
			arg_5_0.lerp_time = var_5_11
		end
	elseif arg_5_0._follow_unit_rotation and not arg_5_0._allow_camera_movement and Unit.alive(var_5_3) then
		CameraStateHelper.set_local_pose(var_5_1, var_5_3, var_5_4)
	else
		if arg_5_0._allow_camera_movement then
			CameraStateHelper.set_camera_rotation(var_5_1, var_5_2)
		end

		local var_5_17 = arg_5_0._camera_offset and Vector3Box.unbox(arg_5_0._camera_offset)
		local var_5_18

		if Unit.alive(var_5_3) then
			var_5_18 = Unit.world_position(var_5_3, var_5_4)
		else
			var_5_18 = Matrix4x4.translation(arg_5_0._fallback_pose:unbox())
		end

		CameraStateHelper.set_follow_camera_position(var_5_1, var_5_18, var_5_17, nil, arg_5_3)
	end
end
