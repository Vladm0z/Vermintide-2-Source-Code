-- chunkname: @scripts/unit_extensions/camera/states/camera_state_idle.lua

CameraStateIdle = class(CameraStateIdle, CameraState)

CameraStateIdle.init = function (arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "idle")
end

CameraStateIdle.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	return
end

CameraStateIdle.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	return
end

CameraStateIdle.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.camera_extension
	local var_4_3, var_4_4 = var_4_2:get_follow_data()

	if var_4_3 then
		var_4_0:change_state("follow")

		return
	end

	local var_4_5 = var_4_2.external_state_change
	local var_4_6 = var_4_2.external_state_change_params

	if var_4_5 and var_4_5 ~= arg_4_0.name then
		var_4_0:change_state(var_4_5, var_4_6)
		var_4_2:set_external_state_change(nil)

		return
	end

	local var_4_7 = arg_4_0.camera_extension.player:unique_id()
	local var_4_8 = Managers.state.side:get_side_from_player_unique_id(var_4_7)

	if (var_4_8 and var_4_8:name()) == "spectators" then
		var_4_0:change_state("observer")

		return
	end

	local var_4_9 = var_4_2:get_idle_position()
	local var_4_10 = var_4_2:get_idle_rotation()

	assert(Vector3.is_valid(var_4_9), "Camera position invalid.")
	Unit.set_local_position(var_4_1, 0, var_4_9)
	Unit.set_local_rotation(var_4_1, 0, var_4_10)
end
