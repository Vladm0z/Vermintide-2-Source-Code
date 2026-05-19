-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer.lua

local var_0_0 = script_data.testify and require("scripts/unit_extensions/camera/states/camera_state_observer_testify")

CameraStateObserver = class(CameraStateObserver, CameraState)

function CameraStateObserver.init(arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "observer")

	arg_1_0._game_settings = Managers.state.game_mode:settings()
end

function CameraStateObserver.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0._observed_unit = nil
	arg_2_0._network_transmit = arg_2_4.network_transmit
	arg_2_0._is_server = arg_2_4.network_transmit.is_server
	arg_2_0._default_observed_node_name = "camera_attach"
	arg_2_0._input_service_name = arg_2_7.input_service_name or "Player"
	arg_2_0._has_read_camera_input = false
	arg_2_0._observed_node_name = arg_2_7.override_observed_node or arg_2_0._default_observed_node_name

	local var_2_0 = arg_2_7.override_follow_unit or arg_2_0._observed_unit

	if Unit.alive(var_2_0) then
		local var_2_1 = Unit.node(var_2_0, arg_2_0._observed_node_name)

		arg_2_0:_set_observed_unit(var_2_0, var_2_1)
	else
		arg_2_0:follow_next_unit(false)
	end

	Managers.state.event:trigger("camera_teleported")
end

function CameraStateObserver.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	Managers.player:local_player():set_observed_unit(nil)
	Managers.state.event:trigger("camera_teleported")
end

function CameraStateObserver.refresh_follow_unit(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_set_observed_unit(arg_4_1, arg_4_2)
end

local var_0_1 = math.pi / 2 - math.pi / 15

function CameraStateObserver.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.camera_extension
	local var_5_2 = var_5_1.external_state_change
	local var_5_3 = var_5_1.external_state_change_params

	if var_5_2 and var_5_2 ~= arg_5_0.name then
		var_5_0:change_state(var_5_2, var_5_3)
		var_5_1:set_external_state_change(nil)

		return
	end

	local var_5_4 = Managers.input:get_service(arg_5_0._input_service_name)
	local var_5_5 = var_5_4:get("next_observer_target") or not Unit.alive(arg_5_0._observed_unit)
	local var_5_6 = var_5_4:get("previous_observer_target")

	if var_5_5 or var_5_6 then
		if var_5_5 then
			arg_5_0:follow_next_unit(false)
		else
			arg_5_0:follow_next_unit(true)
		end
	end

	if CameraStateHelper.set_camera_rotation(arg_5_1, var_5_1) then
		arg_5_0._has_read_camera_input = true
	end

	local var_5_7 = arg_5_0._observed_unit

	if not Unit.alive(var_5_7) then
		arg_5_0._observed_unit = nil

		return
	end

	if not arg_5_0._has_read_camera_input and not Managers.player:owner(var_5_7) then
		CameraStateHelper.set_camera_rotation_observe_static(arg_5_1, var_5_7)
	end

	local var_5_8 = arg_5_0._observed_node
	local var_5_9 = arg_5_0._snap_camera
	local var_5_10 = Unit.world_position(var_5_7, var_5_8)
	local var_5_11 = Managers.player:is_player_unit(var_5_7) and ScriptUnit.extension(var_5_7, "status_system")

	if var_5_11 and (var_5_11:is_hanging_from_hook() or var_5_11:is_grabbed_by_pack_master()) then
		var_5_10 = Unit.world_position(var_5_7, 0)
		var_5_10 = var_5_10 + Vector3(0, 0, 1.5)
	elseif var_5_8 == 0 and not Managers.player:owner(var_5_7) then
		var_5_10 = var_5_10 + Vector3(0, 0, 1.5)
	end

	CameraStateHelper.set_follow_camera_position(arg_5_1, var_5_10, nil, var_5_9, arg_5_3)

	arg_5_0._snap_camera = false

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_5_0)
	end
end

function CameraStateObserver.follow_next_unit(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.camera_extension.player
	local var_6_1 = var_6_0:unique_id()
	local var_6_2 = Managers.state.side:get_side_from_player_unique_id(var_6_1)
	local var_6_3 = CameraStateHelper.get_valid_unit_to_observe(arg_6_1, var_6_2, arg_6_0._observed_unit, var_6_0)
	local var_6_4 = var_6_3 ~= arg_6_0._observed_unit

	if var_6_4 then
		local var_6_5 = Unit.alive(var_6_3) and Unit.has_node(var_6_3, arg_6_0._observed_node_name) and Unit.node(var_6_3, arg_6_0._observed_node_name) or 0

		arg_6_0:_set_observed_unit(var_6_3, var_6_5)
	end

	return var_6_3, var_6_4
end

function CameraStateObserver._set_observed_unit(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._observed_unit = arg_7_1
	arg_7_0._observed_node = arg_7_2 or arg_7_1 and (Unit.has_node(arg_7_1, arg_7_0._default_observed_node_name) and Unit.node(arg_7_1, arg_7_0._default_observed_node_name) or 0)

	if not Unit.alive(arg_7_1) then
		return false
	end

	local var_7_0
	local var_7_1 = arg_7_0.unit
	local var_7_2 = arg_7_0.camera_extension.viewport_name
	local var_7_3 = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(arg_7_1, 0))))
	local var_7_4 = math.atan2(var_7_3.y, var_7_3.x)

	Managers.state.camera:set_pitch_yaw(var_7_2, -0.6, var_7_4)
	Unit.set_data(var_7_1, "camera", "settings_node", "observer")

	local var_7_5 = Unit.world_position(var_7_1, 0)
	local var_7_6 = Unit.world_position(arg_7_1, 0)

	if Vector3.distance(var_7_5, var_7_6) > 50 then
		var_7_0 = true
	end

	arg_7_0._snap_camera = var_7_0

	local var_7_7 = arg_7_0.camera_extension.player

	var_7_7:set_observed_unit(arg_7_1)

	if not arg_7_0._is_server then
		local var_7_8 = var_7_7:local_player_id()
		local var_7_9, var_7_10 = Managers.state.network:game_object_or_level_id(arg_7_1)

		var_7_9 = var_7_9 or NetworkConstants.invalid_game_object_id

		local var_7_11 = not not var_7_10

		arg_7_0._network_transmit:send_rpc_server("rpc_set_observed_unit", var_7_8, var_7_9, var_7_11)
	end

	arg_7_0._has_read_camera_input = false

	return true
end
