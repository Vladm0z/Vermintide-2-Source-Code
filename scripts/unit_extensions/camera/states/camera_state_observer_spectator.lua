-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer_spectator.lua

CameraStateObserverSpectator = class(CameraStateObserverSpectator, CameraStateObserver)

local var_0_0 = {
	"third_person",
	"first_person"
}
local var_0_1 = {
	"free",
	"follow",
	"locked"
}

CameraStateObserverSpectator.on_enter = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0._current_view_id = 1
	arg_1_0._num_views = #var_0_0
	arg_1_0._locked_rotation = false
	arg_1_0._follow_rotation = false
	arg_1_0._offset_scale = 0.5
	arg_1_0._camera_offset = 0
	arg_1_0._rotation_state = var_0_1[1]
	arg_1_0._rotation_state_index = 1
	arg_1_0._current_view = var_0_0[1]
	arg_1_0._pinged_units = {}

	local var_1_0 = Managers.state.side:get_side_from_name("dark_pact").PLAYER_AND_BOT_UNITS

	for iter_1_0, iter_1_1 in ipairs(var_1_0) do
		if ALIVE[iter_1_1] then
			local var_1_1 = ScriptUnit.extension(iter_1_1, "ghost_mode_system")

			if var_1_1:is_in_ghost_mode() then
				var_1_1:husk_leave_ghost_mode(true)
				var_1_1:husk_enter_ghost_mode()
			end
		end
	end

	CameraStateObserver.on_enter(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)

	if arg_1_0._observed_unit then
		Managers.state.event:trigger("on_spectator_target_changed", arg_1_0._observed_unit)
	end
end

local var_0_2 = math.pi / 2 - math.pi / 15

CameraStateObserverSpectator.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0.csm
	local var_2_1 = arg_2_0.camera_extension
	local var_2_2 = var_2_1.external_state_change
	local var_2_3 = var_2_1.external_state_change_params

	if var_2_2 and var_2_2 ~= arg_2_0.name then
		var_2_0:change_state(var_2_2, var_2_3)
		var_2_1:set_external_state_change(nil)

		return
	end

	local var_2_4 = Managers.input
	local var_2_5 = var_2_4:get_service("Player")
	local var_2_6 = var_2_5:get("next_observer_target")
	local var_2_7 = var_2_5:get("previous_observer_target")
	local var_2_8 = Unit.alive(arg_2_0._observed_unit)
	local var_2_9 = arg_2_0._observed_unit
	local var_2_10 = false

	if not var_2_8 or var_2_6 then
		var_2_9, var_2_10 = arg_2_0:follow_next_unit(false)
	elseif var_2_7 then
		var_2_9, var_2_10 = arg_2_0:follow_next_unit(true)
	end

	if var_2_10 then
		Managers.state.event:trigger("on_spectator_target_changed", arg_2_0._observed_unit)
	elseif not Unit.alive(var_2_9) then
		var_2_0:change_state("idle")

		return
	end

	local var_2_11 = var_2_5:get("observer_change_offset").y

	if var_2_11 ~= 0 then
		arg_2_0._camera_offset = math.clamp(arg_2_0._camera_offset + var_2_11 * arg_2_0._offset_scale, 0, 5)
	end

	local var_2_12 = Managers.state.camera
	local var_2_13 = var_2_1.viewport_name
	local var_2_14 = var_2_4:is_device_active("gamepad") and var_2_5:get("look_controller_3p") or var_2_5:get("look")
	local var_2_15 = Vector3(0, 0, 0)

	if var_2_14 then
		var_2_15 = var_2_15 + var_2_14 * (var_2_12:has_viewport(var_2_13) and var_2_12:fov(var_2_13) / 0.785 or 1)
	end

	local var_2_16 = var_2_5:get("next_observer_rotation_state")
	local var_2_17 = var_2_5:get("previous_observer_rotation_state")

	if var_2_16 then
		arg_2_0._rotation_state_index = arg_2_0._rotation_state_index % #var_0_1 + 1
		arg_2_0._rotation_state = var_0_1[arg_2_0._rotation_state_index]
	elseif var_2_17 then
		arg_2_0._rotation_state_index = (arg_2_0._rotation_state_index - 2) % #var_0_1 + 1
		arg_2_0._rotation_state = var_0_1[arg_2_0._rotation_state_index]
	end

	local var_2_18 = Unit.local_rotation(arg_2_1, 0)
	local var_2_19 = math.clamp(Quaternion.pitch(var_2_18) + var_2_15.y, -var_0_2, var_0_2)
	local var_2_20 = Quaternion(Vector3.right(), var_2_19)
	local var_2_21

	if arg_2_0._rotation_state == "follow" then
		var_2_21 = Unit.local_rotation(var_2_9, 0)
		var_2_21 = Quaternion.multiply(var_2_21, var_2_20)
	elseif arg_2_0._rotation_state == "locked" then
		-- Nothing
	else
		local var_2_22 = Quaternion.yaw(var_2_18) - var_2_15.x
		local var_2_23 = Quaternion(Vector3.up(), var_2_22)

		var_2_21 = Quaternion.multiply(var_2_23, var_2_20)
	end

	if var_2_21 then
		Unit.set_local_rotation(arg_2_1, 0, var_2_21)
	end

	local var_2_24 = Unit.node(var_2_9, arg_2_0._observed_node_name)
	local var_2_25 = Unit.world_position(var_2_9, var_2_24) + Vector3(0, 0, arg_2_0._camera_offset)
	local var_2_26 = Unit.world_position(arg_2_1, 0)
	local var_2_27 = math.min(arg_2_3 * 10, 1)
	local var_2_28 = Vector3.lerp(var_2_26, var_2_25, var_2_27)

	if arg_2_0._snap_camera then
		var_2_28 = var_2_25
		arg_2_0._snap_camera = false

		Managers.state.event:trigger("camera_teleported")
	end

	fassert(Vector3.is_valid(var_2_28), "Camera position invalid.")
	Unit.set_local_position(arg_2_1, 0, var_2_28)
end
