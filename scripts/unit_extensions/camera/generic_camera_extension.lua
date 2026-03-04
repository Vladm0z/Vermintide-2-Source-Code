-- chunkname: @scripts/unit_extensions/camera/generic_camera_extension.lua

GenericCameraExtension = class(GenericCameraExtension)

GenericCameraExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.player = arg_1_3.player
	arg_1_0.viewport_name = arg_1_0.player.viewport_name
	arg_1_0.idle_position = Vector3Box(0, 0, 0)
	arg_1_0.idle_rotation = QuaternionBox(Quaternion.identity())
	arg_1_0.external_state_change = nil
	arg_1_0.external_state_change_params = nil
end

GenericCameraExtension.extensions_ready = function (arg_2_0)
	return
end

GenericCameraExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0._delayed_state_change and arg_3_5 > arg_3_0._delayed_state_change_t then
		arg_3_0:set_external_state_change(arg_3_0._delayed_state_change, arg_3_0._delayed_state_change_params)
	end

	local var_3_0 = arg_3_0.override_follow_unit

	if var_3_0 and not Unit.alive(var_3_0) then
		arg_3_0:set_follow_unit(nil, nil)
	end
end

GenericCameraExtension.set_external_state_change = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.external_state_change = arg_4_1
	arg_4_0.external_state_change_params = arg_4_2
	arg_4_0._delayed_state_change = nil
	arg_4_0._delayed_state_change_t = nil
	arg_4_0._delayed_state_change_params = nil
end

GenericCameraExtension.set_delayed_external_state_change = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0._delayed_state_change = arg_5_1
	arg_5_0._delayed_state_change_t = arg_5_3
	arg_5_0._delayed_state_change_params = arg_5_2
end

GenericCameraExtension.set_idle_position = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.viewport_name

	assert(Vector3.is_valid(arg_6_1), "Trying to set invalid camera position")
	arg_6_0.idle_position:store(arg_6_1)
end

GenericCameraExtension.set_idle_rotation = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.viewport_name

	arg_7_0.idle_rotation:store(arg_7_1)
end

GenericCameraExtension.get_idle_position = function (arg_8_0)
	return arg_8_0.idle_position:unbox()
end

GenericCameraExtension.get_idle_rotation = function (arg_9_0)
	return arg_9_0.idle_rotation:unbox()
end

GenericCameraExtension.set_follow_unit = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.override_follow_unit = arg_10_1
	arg_10_0.override_follow_node = arg_10_2 and Unit.node(arg_10_1, arg_10_2) or nil
end

GenericCameraExtension.get_follow_data = function (arg_11_0)
	local var_11_0 = arg_11_0.player
	local var_11_1 = var_11_0.player_unit
	local var_11_2
	local var_11_3

	if var_11_0.respawning then
		return
	end

	if arg_11_0.override_follow_unit then
		return arg_11_0.override_follow_unit, arg_11_0.override_follow_node
	elseif var_11_1 and ScriptUnit.has_extension(var_11_1, "first_person_system") then
		var_11_2 = ScriptUnit.extension(var_11_1, "first_person_system"):get_first_person_unit()
		var_11_3 = Unit.node(var_11_2, "camera_node")
	end

	return var_11_2, var_11_3
end

GenericCameraExtension.destroy = function (arg_12_0)
	return
end
