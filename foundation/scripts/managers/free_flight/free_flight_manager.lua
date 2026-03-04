-- chunkname: @foundation/scripts/managers/free_flight/free_flight_manager.lua

require("foundation/scripts/managers/free_flight/free_flight_controller_settings")
require("foundation/scripts/managers/free_flight/control_points")

local var_0_0 = script_data.testify and require("foundation/scripts/managers/free_flight/free_flight_manager_testify")

FreeFlightManager = class(FreeFlightManager)

function FreeFlightManager.init(arg_1_0)
	arg_1_0.current_control_point = 1
	arg_1_0._has_terrain = not not rawget(s3d, "TerrainDecoration")
	arg_1_0.data = {}

	arg_1_0:_setup_data(arg_1_0.data)

	arg_1_0._frames_to_step = 1
	arg_1_0._max_players = 4
	arg_1_0._input_service_wrapper = {
		get = function(arg_2_0, arg_2_1)
			local var_2_0 = PLATFORM
			local var_2_1 = FreeFlightFilters[var_2_0][arg_2_1]

			if var_2_1 then
				if var_2_1.filter_type == "virtual_axis" then
					return Vector3(0, 0, 0)
				else
					return false
				end
			else
				local var_2_2 = FreeFlightKeymaps[var_2_0][arg_2_1].input_mappings[1][3]

				if var_2_2 == "pressed" or var_2_2 == "held" then
					return false
				elseif var_2_2 == "soft_button" then
					return 0
				elseif var_2_2 == "axis" or var_2_2 == "filter" then
					return Vector3(0, 0, 0)
				end
			end
		end
	}
end

function FreeFlightManager.register_input_manager(arg_3_0, arg_3_1)
	arg_3_0.input_manager = arg_3_1

	arg_3_1:create_input_service("FreeFlight", "FreeFlightKeymaps", "FreeFlightFilters")
	arg_3_1:map_device_to_service("FreeFlight", "keyboard")
	arg_3_1:map_device_to_service("FreeFlight", "mouse")
	arg_3_1:map_device_to_service("FreeFlight", "gamepad")
end

function FreeFlightManager.unregister_input_manager(arg_4_0)
	arg_4_0.input_manager = nil
end

function FreeFlightManager.destroy(arg_5_0)
	arg_5_0.input_manager = nil
	arg_5_0.data = nil
end

function FreeFlightManager.update(arg_6_0, arg_6_1)
	if Development.parameter("gdc") or GameSettingsDevelopment.disable_free_flight then
		return
	end

	if arg_6_0._paused then
		Debug.text("FreeFlightManager: game is paused")
	end

	arg_6_0:_update_global(arg_6_1)

	local var_6_0 = Managers.player

	for iter_6_0, iter_6_1 in pairs(arg_6_0.data) do
		if iter_6_0 ~= "global" then
			local var_6_1 = var_6_0:local_player(iter_6_0)

			arg_6_0:_update_player(arg_6_1, var_6_1, iter_6_1)
		end
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_6_0)
	end
end

function FreeFlightManager.set_teleport_override(arg_7_0, arg_7_1)
	arg_7_0._teleport_override = arg_7_1
end

function FreeFlightManager._get_camera(arg_8_0, arg_8_1)
	if arg_8_1 then
		local var_8_0 = arg_8_0.data[arg_8_1]
		local var_8_1 = var_8_0.viewport_name

		if not var_8_1 then
			printf("[FreeFlightManager] Free flight camera for local player id %i not active. Try pressing f8 first.", arg_8_1)

			return false
		end

		local var_8_2 = Managers.world:world(var_8_0.viewport_world_name)

		return ScriptViewport.camera(ScriptWorld.free_flight_viewport(var_8_2, var_8_1))
	else
		local var_8_3 = arg_8_0.data.global.viewport_world_name

		if not var_8_3 then
			printf("[FreeFlightManager] Global free flight camera not active. Press F9 first.")

			return false
		end

		local var_8_4 = Managers.world:world(var_8_3)

		return ScriptViewport.camera(ScriptWorld.global_free_flight_viewport(var_8_4))
	end
end

function FreeFlightManager.teleport_camera(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0:_get_camera(arg_9_1)

	if not var_9_0 then
		return
	end

	if arg_9_3 then
		local var_9_1 = Matrix4x4.from_quaternion_position(arg_9_3, arg_9_2)

		ScriptCamera.set_local_pose(var_9_0, var_9_1)
	else
		ScriptCamera.set_local_position(var_9_0, arg_9_2)
	end
end

function FreeFlightManager.camera_position_rotation(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:_get_camera(arg_10_1)

	if not var_10_0 then
		return
	end

	local var_10_1 = Camera.local_pose(var_10_0)
	local var_10_2 = ScriptCamera.position(var_10_0)
	local var_10_3 = ScriptCamera.rotation(var_10_0)

	return var_10_2, var_10_3
end

function FreeFlightManager._update_global(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.data.global
	local var_11_1 = arg_11_0:_resolve_input_service()

	if IS_LINUX then
		return
	end

	local var_11_2 = var_11_1:get("global_free_flight_toggle")
	local var_11_3 = var_11_1:get("frustum_freeze_toggle")
	local var_11_4 = var_11_1:get("player_controls_toggle")

	if var_11_0.active and not Managers.world:has_world(var_11_0.viewport_world_name) then
		arg_11_0:_clear_global_free_flight(var_11_0)
	elseif var_11_0.active and var_11_3 then
		local var_11_5 = Managers.world:world(var_11_0.viewport_world_name)

		arg_11_0:_toggle_frustum_freeze(arg_11_1, var_11_0, var_11_5, ScriptWorld.global_free_flight_viewport(var_11_5), true)
	elseif var_11_0.active and var_11_4 then
		arg_11_0:_set_control_input(not arg_11_0._controlling_input)
	elseif var_11_0.active and var_11_2 then
		arg_11_0:_exit_global_free_flight(var_11_0)
	elseif var_11_2 then
		arg_11_0:_enter_global_free_flight(var_11_0)
	elseif var_11_0.active and arg_11_0._controlling_input then
		arg_11_0:_update_global_free_flight(arg_11_1, var_11_0, var_11_1)
	end
end

function FreeFlightManager._resolve_input_service(arg_12_0)
	if arg_12_0.input_manager then
		return arg_12_0.input_manager:get_service("FreeFlight")
	else
		return arg_12_0._input_service_wrapper
	end
end

function FreeFlightManager._exit_frustum_freeze(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	World.set_frustum_inspector_camera(arg_13_2, nil)

	local var_13_0 = arg_13_1.frustum_freeze_camera
	local var_13_1 = Camera.get_data(var_13_0, "unit")
	local var_13_2 = ScriptViewport.camera(arg_13_3)
	local var_13_3 = Camera.get_data(var_13_2, "unit")
	local var_13_4 = Camera.local_pose(var_13_0)

	Camera.set_local_pose(var_13_2, var_13_3, var_13_4)

	if arg_13_4 then
		World.destroy_unit(arg_13_2, var_13_1)
	end

	arg_13_1.frustum_freeze_camera = nil
end

function FreeFlightManager._enter_frustum_freeze(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0
	local var_14_1 = ScriptViewport.camera(arg_14_3)
	local var_14_2 = Camera.vertical_fov(var_14_1)

	if arg_14_4 then
		local var_14_3 = World.spawn_unit(arg_14_2, "core/units/camera")

		var_14_0 = Unit.camera(var_14_3, "camera")

		Camera.set_data(var_14_0, "unit", var_14_3)

		local var_14_4 = Camera.local_pose(var_14_1)

		Camera.set_local_pose(var_14_0, var_14_3, var_14_4)
		Camera.set_vertical_fov(var_14_0, var_14_2)
	else
		var_14_0 = var_14_1
	end

	arg_14_1.frustum_freeze_camera = var_14_0

	World.set_frustum_inspector_camera(arg_14_2, var_14_0)
end

function FreeFlightManager._toggle_frustum_freeze(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_2.frustum_freeze_camera then
		arg_15_0:_exit_frustum_freeze(arg_15_2, arg_15_3, arg_15_4, true)
	else
		arg_15_0:_enter_frustum_freeze(arg_15_2, arg_15_3, arg_15_4, true)
	end
end

function FreeFlightManager.camera_pose(arg_16_0, arg_16_1)
	local var_16_0 = Managers.world:world(arg_16_1.viewport_world_name)
	local var_16_1 = ScriptWorld.global_free_flight_viewport(var_16_0)
	local var_16_2 = arg_16_1.frustum_freeze_camera or ScriptViewport.camera(var_16_1)

	return (Camera.local_pose(var_16_2))
end

function FreeFlightManager.set_pause_on_enter_freeflight(arg_17_0, arg_17_1)
	arg_17_0._pause_on_enter_freeflight = arg_17_1
end

function FreeFlightManager.paused(arg_18_0)
	return arg_18_0._paused
end

function FreeFlightManager._pause_game(arg_19_0, arg_19_1)
	arg_19_0._paused = arg_19_1

	local var_19_0 = arg_19_0.data.global
	local var_19_1 = Managers.world:world(var_19_0.viewport_world_name)

	if arg_19_1 then
		ScriptWorld.pause(var_19_1)
	else
		ScriptWorld.unpause(var_19_1)
	end
end

function FreeFlightManager._update_global_free_flight(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = Managers.world:world(arg_20_2.viewport_world_name)
	local var_20_1 = ScriptWorld.global_free_flight_viewport(var_20_0)
	local var_20_2 = arg_20_2.frustum_freeze_camera or ScriptViewport.camera(var_20_1)
	local var_20_3 = arg_20_3:get("projection_mode")

	if var_20_3 and arg_20_2.projection_type == Camera.PERSPECTIVE then
		arg_20_2.projection_type = Camera.ORTHOGRAPHIC
	elseif var_20_3 and arg_20_2.projection_type == Camera.ORTHOGRAPHIC then
		arg_20_2.projection_type = Camera.PERSPECTIVE
	end

	Camera.set_projection_type(var_20_2, arg_20_2.projection_type)

	local var_20_4 = arg_20_2.translation_speed * 0.5
	local var_20_5 = Vector3.y(arg_20_3:get("speed_change"))

	arg_20_2.translation_speed = arg_20_2.translation_speed + var_20_5 * var_20_4

	if arg_20_2.translation_speed < 0.001 then
		arg_20_2.translation_speed = 0.001
	end

	local var_20_6 = Camera.local_pose(var_20_2)
	local var_20_7 = Matrix4x4.translation(var_20_6)
	local var_20_8 = arg_20_3:get("look")

	if arg_20_2.projection_type == Camera.ORTHOGRAPHIC then
		local var_20_9 = arg_20_2.orthographic_data

		var_20_9.yaw = (var_20_9.yaw or 0) - Vector3.x(var_20_8) * arg_20_2.rotation_speed

		local var_20_10 = Quaternion(Vector3(0, 0, 1), var_20_9.yaw)
		local var_20_11 = Quaternion(Vector3.right(), -math.half_pi)
		local var_20_12 = Quaternion.multiply(var_20_10, var_20_11)
		local var_20_13 = (arg_20_3:get("move_right") - arg_20_3:get("move_left")) * arg_20_1 * 250
		local var_20_14 = (arg_20_3:get("move_forward") - arg_20_3:get("move_back")) * arg_20_1 * 250
		local var_20_15 = var_20_7 + Quaternion.up(var_20_12) * var_20_14 + Quaternion.right(var_20_12) * var_20_13

		var_20_6 = Matrix4x4.from_quaternion_position(var_20_12, var_20_15)

		local var_20_16 = var_20_9.size
		local var_20_17 = var_20_16 - var_20_5 * (var_20_16 * arg_20_1)

		var_20_9.size = var_20_17

		Camera.set_orthographic_view(var_20_2, -var_20_17, var_20_17, -var_20_17, var_20_17)
	else
		Matrix4x4.set_translation(var_20_6, Vector3(0, 0, 0))

		local var_20_18 = Quaternion(Vector3(0, 0, 1), -Vector3.x(var_20_8) * arg_20_2.rotation_speed)
		local var_20_19 = Quaternion(Matrix4x4.x(var_20_6), -Vector3.y(var_20_8) * arg_20_2.rotation_speed)
		local var_20_20 = Quaternion.multiply(var_20_18, var_20_19)

		var_20_6 = Matrix4x4.multiply(var_20_6, Matrix4x4.from_quaternion(var_20_20))

		local var_20_21 = arg_20_3:get("move_right") - arg_20_3:get("move_left")
		local var_20_22 = arg_20_3:get("move_forward") - arg_20_3:get("move_back")

		if IS_XB1 then
			local var_20_23 = arg_20_3:get("move")

			var_20_21 = var_20_23.x * 2
			var_20_22 = var_20_23.y * 2
		end

		local var_20_24 = arg_20_3:get("move_up") - arg_20_3:get("move_down")
		local var_20_25 = Matrix4x4.transform(var_20_6, Vector3(var_20_21, var_20_22, var_20_24) * arg_20_2.translation_speed)

		var_20_7 = Vector3.add(var_20_7, var_20_25)

		Matrix4x4.set_translation(var_20_6, var_20_7)
	end

	if arg_20_0._frames_until_pause then
		arg_20_0._frames_until_pause = arg_20_0._frames_until_pause - 1

		if arg_20_0._frames_until_pause <= 0 then
			arg_20_0._frames_until_pause = nil

			arg_20_0:_pause_game(true)
		end
	elseif arg_20_3:get("step_frame") then
		printf("step %d frame", arg_20_0._frames_to_step)
		arg_20_0:_pause_game(false)

		arg_20_0._frames_until_pause = arg_20_0._frames_to_step
	end

	if arg_20_3:get("play_pause") then
		arg_20_0:_pause_game(not arg_20_0._paused)
	end

	if arg_20_3:get("decrease_frame_step") then
		arg_20_0._frames_to_step = arg_20_0._frames_to_step > 1 and arg_20_0._frames_to_step - 1 or 1

		print("Frame step:", arg_20_0._frames_to_step)
	elseif arg_20_3:get("increase_frame_step") then
		arg_20_0._frames_to_step = arg_20_0._frames_to_step + 1

		print("Frame step:", arg_20_0._frames_to_step)
	end

	local var_20_26 = Matrix4x4.rotation(var_20_6)
	local var_20_27 = Managers.world:wwise_world(var_20_0)

	WwiseWorld.set_listener(var_20_27, 0, var_20_6)

	if arg_20_0._has_terrain then
		TerrainDecoration.move_observer(var_20_0, arg_20_2.terrain_decoration_observer, var_20_7)
	end

	ScatterSystem.move_observer(World.scatter_system(var_20_0), arg_20_2.scatter_system_observer, var_20_7, var_20_26)

	if arg_20_3:get("mark") then
		print("Camera at: " .. tostring(var_20_6))
	end

	if arg_20_3:get("toggle_control_points") then
		var_20_6 = FreeFlightControlPoints[arg_20_0.current_control_point]:unbox()
		arg_20_0.current_control_point = arg_20_0.current_control_point % #FreeFlightControlPoints + 1

		print("Control Point: " .. tostring(arg_20_0.current_control_point))
	end

	if arg_20_3:get("set_drop_position") then
		arg_20_0:drop_player_at_camera_pos(var_20_2)
	end

	ScriptCamera.set_local_pose(var_20_2, var_20_6)
end

function FreeFlightManager.cleanup_free_flight(arg_21_0)
	local var_21_0 = arg_21_0.data.global

	if var_21_0.active then
		arg_21_0:_exit_global_free_flight(var_21_0)
	end

	local var_21_1 = Managers.player

	for iter_21_0, iter_21_1 in pairs(arg_21_0.data) do
		if iter_21_0 ~= "global" and iter_21_1.active then
			local var_21_2 = var_21_1:local_player(iter_21_0)

			arg_21_0:_exit_free_flight(var_21_2, iter_21_1)
		end
	end
end

function FreeFlightManager._enter_global_free_flight(arg_22_0, arg_22_1)
	local var_22_0 = Application.main_world()

	if not var_22_0 then
		return
	end

	local var_22_1 = ScriptWorld.create_global_free_flight_viewport(var_22_0, "default")

	if not var_22_1 then
		return
	end

	arg_22_1.active = true
	arg_22_1.viewport_world_name = ScriptWorld.name(var_22_0)

	local var_22_2 = ScriptViewport.camera(var_22_1)
	local var_22_3 = Camera.local_pose(var_22_2)
	local var_22_4 = Matrix4x4.translation(var_22_3)
	local var_22_5 = Matrix4x4.rotation(var_22_3)

	if arg_22_0._has_terrain then
		arg_22_1.terrain_decoration_observer = TerrainDecoration.create_observer(var_22_0, var_22_4)
	end

	arg_22_1.scatter_system_observer = ScatterSystem.make_observer(World.scatter_system(var_22_0), var_22_4, var_22_5)

	if arg_22_0._pause_on_enter_freeflight then
		arg_22_0:_pause_game(true)
	end

	arg_22_0:_set_control_input(true)
end

function FreeFlightManager._set_control_input(arg_23_0, arg_23_1)
	arg_23_1 = not not arg_23_1

	if arg_23_0._controlling_input == arg_23_1 then
		return
	end

	arg_23_0._controlling_input = arg_23_1

	if arg_23_1 then
		arg_23_0.input_manager:block_device_except_service("FreeFlight", "keyboard", nil, "free_flight")
		arg_23_0.input_manager:block_device_except_service("FreeFlight", "mouse", nil, "free_flight")
		arg_23_0.input_manager:block_device_except_service("FreeFlight", "gamepad", nil, "free_flight")
		arg_23_0.input_manager:device_unblock_service("keyboard", 1, "DebugMenu")
		arg_23_0.input_manager:device_unblock_service("mouse", 1, "DebugMenu")
		arg_23_0.input_manager:device_unblock_service("gamepad", 1, "DebugMenu")
		arg_23_0.input_manager:device_unblock_service("keyboard", 1, "Debug")
		arg_23_0.input_manager:device_unblock_service("mouse", 1, "Debug")
		arg_23_0.input_manager:device_unblock_service("gamepad", 1, "Debug")
	else
		arg_23_0.input_manager:device_unblock_all_services("keyboard")
		arg_23_0.input_manager:device_unblock_all_services("mouse")
		arg_23_0.input_manager:device_unblock_all_services("gamepad")
	end
end

function FreeFlightManager._exit_global_free_flight(arg_24_0, arg_24_1)
	local var_24_0 = Managers.world:world(arg_24_1.viewport_world_name)

	if arg_24_1.frustum_freeze_camera then
		arg_24_0:_exit_frustum_freeze(arg_24_1, var_24_0, ScriptWorld.global_free_flight_viewport(var_24_0), true)
	end

	local var_24_1 = arg_24_1.viewport_world_name

	if arg_24_0._has_terrain then
		TerrainDecoration.destroy_observer(var_24_0, arg_24_1.terrain_decoration_observer)
	end

	ScatterSystem.destroy_observer(World.scatter_system(var_24_0), arg_24_1.scatter_system_observer)

	if arg_24_0._paused then
		arg_24_0:_pause_game(false)
	end

	arg_24_1.active = false
	arg_24_1.viewport_world_name = nil

	ScriptWorld.destroy_global_free_flight_viewport(Managers.world:world(var_24_1))
	arg_24_0:_set_control_input(false)
end

function FreeFlightManager._clear_global_free_flight(arg_25_0, arg_25_1)
	arg_25_1.active = false
	arg_25_1.viewport_world_name = nil
end

function FreeFlightManager._update_player(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_3.input_service
	local var_26_1 = var_26_0:get("frustum_freeze_toggle")
	local var_26_2 = var_26_0:get("free_flight_toggle")

	if arg_26_3.active and not Managers.world:has_world(arg_26_3.viewport_world_name) then
		arg_26_0:_clear_free_flight(arg_26_3)
	elseif arg_26_3.active and var_26_1 then
		local var_26_3 = Managers.world:world(arg_26_3.viewport_world_name)

		arg_26_0:_toggle_frustum_freeze(arg_26_1, arg_26_3, var_26_3, ScriptWorld.free_flight_viewport(var_26_3, arg_26_3.viewport_name))
	elseif arg_26_3.active and var_26_2 then
		arg_26_0:_exit_free_flight(arg_26_2, arg_26_3)
	elseif var_26_2 or Testify:poll_request("activate_free_flight") then
		arg_26_0:_enter_free_flight(arg_26_2, arg_26_3)
	elseif arg_26_3.active and not arg_26_0.data.global.active then
		arg_26_0:_update_free_flight(arg_26_1, arg_26_2, arg_26_3)
	end
end

function FreeFlightManager._clear_free_flight(arg_27_0, arg_27_1)
	arg_27_1.active = false
	arg_27_1.viewport_world_name = nil
	arg_27_1.viewport_name = nil
end

function FreeFlightManager.register_player(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.input_manager:get_service("FreeFlight")

	arg_28_0.data[arg_28_1] = {
		mode = "paused",
		current_translation_max_speed = 10,
		dof_focal_distance = 10,
		acceleration = 10,
		dof_focal_region_end = 4,
		dof_focal_near_scale = 1,
		rotation_speed = 0.003,
		dof_focal_far_scale = 1,
		dof_focal_region_start = 4,
		dof_enabled = 0,
		active = false,
		dof_focal_region = 8,
		input_service = var_28_0,
		rotation_accumulation = Vector3Box(),
		current_translation_speed = Vector3Box()
	}
end

function FreeFlightManager.unregister_player(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0.data[arg_29_1]

	fassert(var_29_0, "Trying to unregister player %i not registered", arg_29_1)

	if var_29_0.active then
		arg_29_0:_clear_free_flight(var_29_0)
	end

	arg_29_0.data[arg_29_1] = nil
end

function FreeFlightManager._setup_data(arg_30_0, arg_30_1)
	arg_30_1.global = {
		translation_speed = 0.05,
		rotation_speed = 0.003,
		mode = "paused",
		active = false,
		projection_type = Camera.PERSPECTIVE,
		orthographic_data = {
			size = 100
		}
	}
end

function FreeFlightManager._enter_free_flight(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_1.viewport_world_name
	local var_31_1 = arg_31_1.viewport_name
	local var_31_2 = Managers.world:world(var_31_0)
	local var_31_3 = World.get_data(var_31_2, "viewports")
	local var_31_4 = ScriptViewport.camera(var_31_3[var_31_1])
	local var_31_5 = Camera.vertical_fov(var_31_4)

	arg_31_2.active = true
	arg_31_2.viewport_name = arg_31_1.viewport_name
	arg_31_2.viewport_world_name = var_31_0

	local var_31_6 = ScriptWorld.create_free_flight_viewport(var_31_2, var_31_1, "default")
	local var_31_7 = ScriptViewport.camera(var_31_6)
	local var_31_8 = Camera.local_pose(var_31_7)
	local var_31_9 = Matrix4x4.translation(var_31_8)
	local var_31_10 = Matrix4x4.rotation(var_31_8)

	Camera.set_vertical_fov(var_31_7, var_31_5)

	if arg_31_0._has_terrain then
		arg_31_2.terrain_decoration_observer = TerrainDecoration.create_observer(var_31_2, var_31_9)
	end

	arg_31_2.scatter_system_observer = ScatterSystem.make_observer(World.scatter_system(var_31_2), var_31_9, var_31_10)

	arg_31_0.input_manager:block_device_except_service("FreeFlight", "keyboard", nil, "free_flight")
	arg_31_0.input_manager:block_device_except_service("FreeFlight", "mouse", nil, "free_flight")
	arg_31_0.input_manager:block_device_except_service("FreeFlight", "gamepad", nil, "free_flight")

	if script_data.testify and Testify:poll_request("activate_free_flight") then
		Testify:respond_to_request("activate_free_flight")
	end
end

function FreeFlightManager._exit_free_flight(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = Managers.world:world(arg_32_2.viewport_world_name)

	if arg_32_2.frustum_freeze_camera then
		arg_32_0:_exit_frustum_freeze(arg_32_2, var_32_0, ScriptWorld.viewport(var_32_0, arg_32_2.viewport_name))
	end

	local var_32_1 = arg_32_2.viewport_name

	arg_32_2.active = false
	arg_32_2.viewport_name = nil
	arg_32_2.viewport_world_name = nil

	if arg_32_0._has_terrain then
		TerrainDecoration.destroy_observer(var_32_0, arg_32_2.terrain_decoration_observer)
	end

	ScatterSystem.destroy_observer(World.scatter_system(var_32_0), arg_32_2.scatter_system_observer)

	arg_32_2.terrain_decoration_observer = nil
	arg_32_2.scatter_system_observer = nil

	ScriptWorld.destroy_free_flight_viewport(var_32_0, var_32_1)
	arg_32_0.input_manager:device_unblock_all_services("keyboard")
	arg_32_0.input_manager:device_unblock_all_services("mouse")
	arg_32_0.input_manager:device_unblock_all_services("gamepad")
end

function FreeFlightManager.active(arg_33_0, arg_33_1)
	return arg_33_0.data[arg_33_1] and arg_33_0.data[arg_33_1].active
end

function FreeFlightManager.mode(arg_34_0, arg_34_1)
	return arg_34_0.data[arg_34_1].mode
end

function FreeFlightManager._update_free_flight(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = Managers.world:world(arg_35_3.viewport_world_name)
	local var_35_1 = ScriptWorld.free_flight_viewport(var_35_0, arg_35_3.viewport_name)
	local var_35_2 = arg_35_3.frustum_freeze_camera or ScriptViewport.camera(var_35_1)
	local var_35_3 = arg_35_0.input_manager:get_service("FreeFlight")
	local var_35_4 = arg_35_3.current_translation_max_speed * 0.5
	local var_35_5 = Vector3.y(var_35_3:get("speed_change") or Vector3(0, 0, 0))

	arg_35_3.current_translation_max_speed = math.max(arg_35_3.current_translation_max_speed + var_35_5 * var_35_4, 0.01)

	local var_35_6 = Camera.local_pose(var_35_2)
	local var_35_7 = Matrix4x4.translation(var_35_6)

	Matrix4x4.set_translation(var_35_6, Vector3(0, 0, 0))

	local var_35_8 = var_35_3:get("look")
	local var_35_9 = arg_35_3.rotation_accumulation:unbox() + var_35_8
	local var_35_10 = var_35_9 * math.min(arg_35_1, 1) * (arg_35_2.free_flight_movement_filter_speed or 15)

	arg_35_3.rotation_accumulation:store(var_35_9 - var_35_10)

	local var_35_11 = Quaternion(Vector3(0, 0, 1), -Vector3.x(var_35_10) * arg_35_3.rotation_speed)
	local var_35_12 = Quaternion(Matrix4x4.x(var_35_6), -Vector3.y(var_35_10) * arg_35_3.rotation_speed)
	local var_35_13 = Quaternion.multiply(var_35_11, var_35_12)
	local var_35_14 = Matrix4x4.multiply(var_35_6, Matrix4x4.from_quaternion(var_35_13))
	local var_35_15 = var_35_3:get("move") * arg_35_3.current_translation_max_speed
	local var_35_16 = arg_35_3.current_translation_speed:unbox()
	local var_35_17 = var_35_15 - var_35_16
	local var_35_18 = Vector3.length(var_35_17)
	local var_35_19 = Vector3.normalize(var_35_17)

	if var_35_5 ~= 0 then
		arg_35_3.acceleration = (arg_35_2.free_flight_acceleration_factor or 5) * Vector3.length(var_35_17)
	end

	local var_35_20 = arg_35_3.acceleration
	local var_35_21 = var_35_16 + var_35_19 * math.min(var_35_18, var_35_20 * arg_35_1)

	if not Vector3.equal(var_35_21, var_35_16) then
		-- block empty
	end

	arg_35_3.current_translation_speed:store(var_35_21)

	local var_35_22 = Matrix4x4.rotation(var_35_14)
	local var_35_23 = (Quaternion.forward(var_35_22) * var_35_21.y + Quaternion.right(var_35_22) * var_35_21.x + Quaternion.up(var_35_22) * var_35_21.z) * arg_35_1
	local var_35_24 = Vector3.add(var_35_7, var_35_23)

	Matrix4x4.set_translation(var_35_14, var_35_24)
	ScriptCamera.set_local_pose(var_35_2, var_35_14)

	local var_35_25 = Managers.world:wwise_world(var_35_0)

	WwiseWorld.set_listener(var_35_25, 0, var_35_14)

	if arg_35_0._has_terrain then
		TerrainDecoration.move_observer(var_35_0, arg_35_3.terrain_decoration_observer, var_35_24)
	end

	ScatterSystem.move_observer(World.scatter_system(var_35_0), arg_35_3.scatter_system_observer, var_35_24, var_35_22)

	if var_35_3:get("set_drop_position") then
		arg_35_0:drop_player_at_camera_pos(var_35_2, arg_35_2)
	end

	if var_35_3:get("increase_fov") then
		local var_35_26 = Camera.vertical_fov(var_35_2)

		Camera.set_vertical_fov(var_35_2, var_35_26 + math.pi / 72)
	end

	if var_35_3:get("ray") then
		local var_35_27 = World.get_data(var_35_0, "physics_world")
		local var_35_28, var_35_29, var_35_30, var_35_31, var_35_32 = PhysicsWorld.immediate_raycast(var_35_27, Camera.local_position(var_35_2), Quaternion.forward(Camera.local_rotation(var_35_2)), 999, "closest")

		if var_35_32 then
			print(var_35_32)
		end
	end

	if var_35_3:get("decrease_fov") then
		local var_35_33 = Camera.vertical_fov(var_35_2)

		Camera.set_vertical_fov(var_35_2, var_35_33 - math.pi / 72)
	end

	local var_35_34 = World.get_data(var_35_0, "shading_environment")

	if var_35_34 then
		if var_35_3:get("toggle_dof") and not var_35_3:get("dof_reset") then
			arg_35_3.dof_enabled = 1 - arg_35_3.dof_enabled
		end

		if var_35_3:get("inc_dof_distance") and not var_35_3:get("inc_dof_region") and not var_35_3:get("inc_dof_padding") and not var_35_3:get("inc_dof_scale") then
			arg_35_3.dof_focal_distance = arg_35_3.dof_focal_distance + 0.2

			print("Dof Focal Distance: ", arg_35_3.dof_focal_distance)
		end

		if var_35_3:get("dec_dof_distance") and not var_35_3:get("dec_dof_region") and not var_35_3:get("dec_dof_padding") and not var_35_3:get("dec_dof_scale") then
			arg_35_3.dof_focal_distance = arg_35_3.dof_focal_distance - 0.2

			if arg_35_3.dof_focal_distance < 0 then
				arg_35_3.dof_focal_distance = 0
			end

			print("Dof Focal Distance: ", arg_35_3.dof_focal_distance)
		end

		if var_35_3:get("inc_dof_region") then
			arg_35_3.dof_focal_region = arg_35_3.dof_focal_region + 0.2

			print("Dof Focal Region: ", arg_35_3.dof_focal_region)
		end

		if var_35_3:get("dec_dof_region") then
			arg_35_3.dof_focal_region = arg_35_3.dof_focal_region - 0.2

			if arg_35_3.dof_focal_region < 0 then
				arg_35_3.dof_focal_region = 0
			end

			print("Dof Focal Region: ", arg_35_3.dof_focal_region)
		end

		if var_35_3:get("inc_dof_padding") then
			arg_35_3.dof_focal_region_start = arg_35_3.dof_focal_region_start + 0.1
			arg_35_3.dof_focal_region_end = arg_35_3.dof_focal_region_end + 0.1

			print("Dof Focal Padding: ", arg_35_3.dof_focal_region_start)
		end

		if var_35_3:get("dec_dof_padding") then
			arg_35_3.dof_focal_region_start = arg_35_3.dof_focal_region_start - 0.1
			arg_35_3.dof_focal_region_end = arg_35_3.dof_focal_region_end - 0.1

			if arg_35_3.dof_focal_region_start < 0 then
				arg_35_3.dof_focal_region_start = 0
			end

			if arg_35_3.dof_focal_region_end < 0 then
				arg_35_3.dof_focal_region_end = 0
			end

			print("Dof Focal Padding: ", arg_35_3.dof_focal_region_start)
		end

		if var_35_3:get("inc_dof_scale") then
			arg_35_3.dof_focal_near_scale = arg_35_3.dof_focal_near_scale + 0.02
			arg_35_3.dof_focal_far_scale = arg_35_3.dof_focal_far_scale + 0.02

			if arg_35_3.dof_focal_near_scale > 1 then
				arg_35_3.dof_focal_near_scale = 1
			end

			if arg_35_3.dof_focal_far_scale > 1 then
				arg_35_3.dof_focal_far_scale = 1
			end

			print("Dof Focal Scale: ", arg_35_3.dof_focal_near_scale)
		end

		if var_35_3:get("dec_dof_scale") then
			arg_35_3.dof_focal_near_scale = arg_35_3.dof_focal_near_scale - 0.02
			arg_35_3.dof_focal_far_scale = arg_35_3.dof_focal_far_scale - 0.02

			if arg_35_3.dof_focal_near_scale < 0 then
				arg_35_3.dof_focal_near_scale = 0
			end

			if arg_35_3.dof_focal_far_scale < 0 then
				arg_35_3.dof_focal_far_scale = 0
			end

			print("Dof Focal Scale: ", arg_35_3.dof_focal_near_scale)
		end

		if var_35_3:get("dof_reset") then
			arg_35_3.dof_focal_distance = 10
			arg_35_3.dof_focal_region = 8
			arg_35_3.dof_focal_region_start = 3
			arg_35_3.dof_focal_region_end = 3
			arg_35_3.dof_focal_near_scale = 1
			arg_35_3.dof_focal_far_scale = 1

			print("Dof Focal Distance: ", arg_35_3.dof_focal_distance)
			print("Dof Focal Region: ", arg_35_3.dof_focal_region)
			print("Dof Focal Padding: ", arg_35_3.dof_focal_region_start)
			print("Dof Focal Scale: ", arg_35_3.dof_focal_near_scale)
		end

		ShadingEnvironment.set_scalar(var_35_34, "dof_enabled", arg_35_3.dof_enabled)
		ShadingEnvironment.set_scalar(var_35_34, "dof_focal_distance", arg_35_3.dof_focal_distance)
		ShadingEnvironment.set_scalar(var_35_34, "dof_focal_region", arg_35_3.dof_focal_region)
		ShadingEnvironment.set_scalar(var_35_34, "dof_focal_region_start", arg_35_3.dof_focal_region_start)
		ShadingEnvironment.set_scalar(var_35_34, "dof_focal_region_end", arg_35_3.dof_focal_region_end)
		ShadingEnvironment.set_scalar(var_35_34, "dof_focal_near_scale", arg_35_3.dof_focal_near_scale)
		ShadingEnvironment.set_scalar(var_35_34, "dof_focal_far_scale", arg_35_3.dof_focal_far_scale)

		if ShadingEnvironment.scalar(var_35_34, "dof_enabled") then
			ShadingEnvironment.apply(var_35_34)
		end
	end
end

function FreeFlightManager.drop_player_at_camera_pos(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = Camera.local_position(arg_36_1)
	local var_36_1 = Camera.local_rotation(arg_36_1)

	if arg_36_0._teleport_override then
		arg_36_0._teleport_override(var_36_0, var_36_1)
	elseif arg_36_2 and arg_36_2.camera_follow_unit then
		Unit.set_local_position(arg_36_2.camera_follow_unit, 0, var_36_0)

		local var_36_2 = Unit.mover(arg_36_2.camera_follow_unit)

		if var_36_2 then
			Mover.set_position(var_36_2, var_36_0)
		end
	end
end
