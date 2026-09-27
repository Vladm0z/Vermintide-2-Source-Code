-- chunkname: @foundation/scripts/managers/free_flight/free_flight_manager.lua

require("foundation/scripts/managers/free_flight/free_flight_controller_settings")
require("foundation/scripts/managers/free_flight/control_points")

local testify = script_data.testify

testify = not testify and require("foundation/scripts/managers/free_flight/free_flight_manager_testify")
FreeFlightManager = class(FreeFlightManager)

FreeFlightManager.init = function (self)
	-- function 1
	self.current_control_point = 1
	self._has_terrain = not not rawget(s3d, "TerrainDecoration")
	self.data = {}

	self:_setup_data(self.data)

	self._frames_to_step = 1
	self._max_players = 4
	self._input_service_wrapper = {
		get = function (arg_2_0, arg_2_1)
			-- function 2
			local PLATFORM = PLATFORM
			local var_2_1 = FreeFlightFilters[PLATFORM][arg_2_1]

			if not var_2_1 then
				if var_2_1.filter_type == "virtual_axis" then
					return Vector3(0, 0, 0)
				else
					return false
				end
			else
				local var_2_2 = FreeFlightKeymaps[PLATFORM][arg_2_1].input_mappings[1][3]

				if not (var_2_2 == "pressed" or var_2_2 ~= "held") then
					return false
				elseif var_2_2 == "soft_button" then
					return 0
				elseif not (var_2_2 == "axis" or var_2_2 ~= "filter") then
					return Vector3(0, 0, 0)
				end
			end
		end
	}
end

FreeFlightManager.register_input_manager = function (self, arg_3_1)
	-- function 3
	self.input_manager = arg_3_1

	arg_3_1:create_input_service("FreeFlight", "FreeFlightKeymaps", "FreeFlightFilters")
	arg_3_1:map_device_to_service("FreeFlight", "keyboard")
	arg_3_1:map_device_to_service("FreeFlight", "mouse")
	arg_3_1:map_device_to_service("FreeFlight", "gamepad")
end

FreeFlightManager.unregister_input_manager = function (self)
	-- function 4
	self.input_manager = nil
end

FreeFlightManager.destroy = function (self)
	-- function 5
	self.input_manager = nil
	self.data = nil
end

FreeFlightManager.update = function (self, arg_6_1)
	-- function 6
	if Development.parameter("gdc") or not GameSettingsDevelopment.disable_free_flight then
		return
	end

	if not self._paused then
		Debug.text("FreeFlightManager: game is paused")
	end

	self:_update_global(arg_6_1)

	local player = Managers.player

	for k, v in pairs(self.data) do
		if k ~= "global" then
			local local_player = player:local_player(k)

			self:_update_player(arg_6_1, local_player, v)
		end
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

FreeFlightManager.set_teleport_override = function (self, arg_7_1)
	-- function 7
	self._teleport_override = arg_7_1
end

FreeFlightManager._get_camera = function (self, arg_8_1)
	-- function 8
	if not arg_8_1 then
		local var_8_0 = self.data[arg_8_1]
		local viewport_name = var_8_0.viewport_name

		if not viewport_name then
			printf("[FreeFlightManager] Free flight camera for local player id %i not active. Try pressing f8 first.", arg_8_1)

			return false
		end

		local world = Managers.world:world(var_8_0.viewport_world_name)

		return ScriptViewport.camera(ScriptWorld.free_flight_viewport(world, viewport_name))
	else
		local viewport_world_name = self.data.global.viewport_world_name

		if not viewport_world_name then
			printf("[FreeFlightManager] Global free flight camera not active. Press F9 first.")

			return false
		end

		local world_2 = Managers.world:world(viewport_world_name)

		return ScriptViewport.camera(ScriptWorld.global_free_flight_viewport(world_2))
	end
end

FreeFlightManager.teleport_camera = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local _get_camera = self:_get_camera(arg_9_1)

	if not _get_camera then
		return
	end

	if not arg_9_3 then
		local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_9_3, arg_9_2)

		ScriptCamera.set_local_pose(_get_camera, from_quaternion_position)
	else
		ScriptCamera.set_local_position(_get_camera, arg_9_2)
	end
end

FreeFlightManager.camera_position_rotation = function (self, arg_10_1)
	-- function 10
	local _get_camera = self:_get_camera(arg_10_1)

	if not _get_camera then
		return
	end

	local local_pose = Camera.local_pose(_get_camera)
	local position = ScriptCamera.position(_get_camera)
	local rotation = ScriptCamera.rotation(_get_camera)

	return position, rotation
end

FreeFlightManager._update_global = function (self, arg_11_1)
	-- function 11
	local global = self.data.global
	local _resolve_input_service = self:_resolve_input_service()

	if not IS_LINUX then
		return
	end

	local get = _resolve_input_service:get("global_free_flight_toggle")
	local get_2 = _resolve_input_service:get("frustum_freeze_toggle")
	local get_3 = _resolve_input_service:get("player_controls_toggle")

	if not (not global.active and Managers.world:has_world(global.viewport_world_name)) then
		self:_clear_global_free_flight(global)
	elseif not global.active and not get_2 then
		local world = Managers.world:world(global.viewport_world_name)

		self:_toggle_frustum_freeze(arg_11_1, global, world, ScriptWorld.global_free_flight_viewport(world), true)
	elseif not global.active and not get_3 then
		self:_set_control_input(not self._controlling_input)
	elseif not global.active and not get then
		self:_exit_global_free_flight(global)
	elseif not get then
		self:_enter_global_free_flight(global)
	elseif not global.active and not self._controlling_input then
		self:_update_global_free_flight(arg_11_1, global, _resolve_input_service)
	end
end

FreeFlightManager._resolve_input_service = function (self)
	-- function 12
	if not self.input_manager then
		return self.input_manager:get_service("FreeFlight")
	else
		return self._input_service_wrapper
	end
end

FreeFlightManager._exit_frustum_freeze = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	World.set_frustum_inspector_camera(arg_13_2, nil)

	local frustum_freeze_camera = arg_13_1.frustum_freeze_camera
	local get_data = Camera.get_data(frustum_freeze_camera, "unit")
	local camera = ScriptViewport.camera(arg_13_3)
	local get_data_2 = Camera.get_data(camera, "unit")
	local local_pose = Camera.local_pose(frustum_freeze_camera)

	Camera.set_local_pose(camera, get_data_2, local_pose)

	if not arg_13_4 then
		World.destroy_unit(arg_13_2, get_data)
	end

	arg_13_1.frustum_freeze_camera = nil
end

FreeFlightManager._enter_frustum_freeze = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local var_14_0
	local camera = ScriptViewport.camera(arg_14_3)
	local vertical_fov = Camera.vertical_fov(camera)

	if not arg_14_4 then
		local spawn_unit = World.spawn_unit(arg_14_2, "core/units/camera")

		var_14_0 = Unit.camera(spawn_unit, "camera")

		Camera.set_data(var_14_0, "unit", spawn_unit)

		local local_pose = Camera.local_pose(camera)

		Camera.set_local_pose(var_14_0, spawn_unit, local_pose)
		Camera.set_vertical_fov(var_14_0, vertical_fov)
	else
		var_14_0 = camera
	end

	arg_14_1.frustum_freeze_camera = var_14_0

	World.set_frustum_inspector_camera(arg_14_2, var_14_0)
end

FreeFlightManager._toggle_frustum_freeze = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not arg_15_2.frustum_freeze_camera then
		self:_exit_frustum_freeze(arg_15_2, arg_15_3, arg_15_4, true)
	else
		self:_enter_frustum_freeze(arg_15_2, arg_15_3, arg_15_4, true)
	end
end

FreeFlightManager.camera_pose = function (arg_16_0, arg_16_1)
	-- function 16
	local world = Managers.world:world(arg_16_1.viewport_world_name)
	local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(world)
	local frustum_freeze_camera = arg_16_1.frustum_freeze_camera

	frustum_freeze_camera = frustum_freeze_camera or ScriptViewport.camera(global_free_flight_viewport)

	return (Camera.local_pose(frustum_freeze_camera))
end

FreeFlightManager.set_pause_on_enter_freeflight = function (self, arg_17_1)
	-- function 17
	self._pause_on_enter_freeflight = arg_17_1
end

FreeFlightManager.paused = function (self)
	-- function 18
	return self._paused
end

FreeFlightManager._pause_game = function (self, arg_19_1)
	-- function 19
	self._paused = arg_19_1

	local global = self.data.global
	local world = Managers.world:world(global.viewport_world_name)

	if not arg_19_1 then
		ScriptWorld.pause(world)
	else
		ScriptWorld.unpause(world)
	end
end

FreeFlightManager._update_global_free_flight = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local world = Managers.world:world(arg_20_2.viewport_world_name)
	local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(world)
	local frustum_freeze_camera = arg_20_2.frustum_freeze_camera

	frustum_freeze_camera = frustum_freeze_camera or ScriptViewport.camera(global_free_flight_viewport)

	local get = arg_20_3:get("projection_mode")

	if not (not get and arg_20_2.projection_type ~= Camera.PERSPECTIVE) then
		arg_20_2.projection_type = Camera.ORTHOGRAPHIC
	elseif not (not get and arg_20_2.projection_type ~= Camera.ORTHOGRAPHIC) then
		arg_20_2.projection_type = Camera.PERSPECTIVE
	end

	Camera.set_projection_type(frustum_freeze_camera, arg_20_2.projection_type)

	local num = arg_20_2.translation_speed * 0.5
	local y = Vector3.y(arg_20_3:get("speed_change"))

	arg_20_2.translation_speed = arg_20_2.translation_speed + y * num

	if arg_20_2.translation_speed < 0.001 then
		arg_20_2.translation_speed = 0.001
	end

	local local_pose = Camera.local_pose(frustum_freeze_camera)
	local translation = Matrix4x4.translation(local_pose)
	local get_2 = arg_20_3:get("look")

	if arg_20_2.projection_type == Camera.ORTHOGRAPHIC then
		local orthographic_data = arg_20_2.orthographic_data
		local yaw = orthographic_data.yaw

		yaw = yaw or 0
		orthographic_data.yaw = yaw - Vector3.x(get_2) * arg_20_2.rotation_speed

		local var_20_11 = Quaternion(Vector3(0, 0, 1), orthographic_data.yaw)
		local var_20_12 = Quaternion(Vector3.right(), -math.half_pi)
		local multiply = Quaternion.multiply(var_20_11, var_20_12)
		local num_2 = (arg_20_3:get("move_right") - arg_20_3:get("move_left")) * arg_20_1 * 250
		local num_3 = (arg_20_3:get("move_forward") - arg_20_3:get("move_back")) * arg_20_1 * 250
		local num_4 = translation + Quaternion.up(multiply) * num_3 + Quaternion.right(multiply) * num_2

		local_pose = Matrix4x4.from_quaternion_position(multiply, num_4)

		local size = orthographic_data.size
		local num_5 = size - y * (size * arg_20_1)

		orthographic_data.size = num_5

		Camera.set_orthographic_view(frustum_freeze_camera, -num_5, num_5, -num_5, num_5)
	else
		Matrix4x4.set_translation(local_pose, Vector3(0, 0, 0))

		local var_20_19 = Quaternion(Vector3(0, 0, 1), -Vector3.x(get_2) * arg_20_2.rotation_speed)
		local var_20_20 = Quaternion(Matrix4x4.x(local_pose), -Vector3.y(get_2) * arg_20_2.rotation_speed)
		local multiply_2 = Quaternion.multiply(var_20_19, var_20_20)

		local_pose = Matrix4x4.multiply(local_pose, Matrix4x4.from_quaternion(multiply_2))

		local num_6 = arg_20_3:get("move_right") - arg_20_3:get("move_left")
		local num_7 = arg_20_3:get("move_forward") - arg_20_3:get("move_back")

		if not IS_XB1 then
			local get_3 = arg_20_3:get("move")

			num_6 = get_3.x * 2
			num_7 = get_3.y * 2
		end

		local num_8 = arg_20_3:get("move_up") - arg_20_3:get("move_down")
		local transform = Matrix4x4.transform(local_pose, Vector3(num_6, num_7, num_8) * arg_20_2.translation_speed)

		translation = Vector3.add(translation, transform)

		Matrix4x4.set_translation(local_pose, translation)
	end

	if not self._frames_until_pause then
		self._frames_until_pause = self._frames_until_pause - 1

		if self._frames_until_pause <= 0 then
			self._frames_until_pause = nil

			self:_pause_game(true)
		end
	elseif not arg_20_3:get("step_frame") then
		printf("step %d frame", self._frames_to_step)
		self:_pause_game(false)

		self._frames_until_pause = self._frames_to_step
	end

	if not arg_20_3:get("play_pause") then
		self:_pause_game(not self._paused)
	end

	if not arg_20_3:get("decrease_frame_step") then
		local num_9

		if self._frames_to_step > 1 then
			num_9 = self._frames_to_step - 1

			if not num_9 then
				-- Nothing
			end
		end

		num_9 = 1

		::label_20_0::

		self._frames_to_step = num_9

		print("Frame step:", self._frames_to_step)
	elseif not arg_20_3:get("increase_frame_step") then
		self._frames_to_step = self._frames_to_step + 1

		print("Frame step:", self._frames_to_step)
	end

	local rotation = Matrix4x4.rotation(local_pose)
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.set_listener(wwise_world, 0, local_pose)

	if not self._has_terrain then
		TerrainDecoration.move_observer(world, arg_20_2.terrain_decoration_observer, translation)
	end

	ScatterSystem.move_observer(World.scatter_system(world), arg_20_2.scatter_system_observer, translation, rotation)

	if not arg_20_3:get("mark") then
		print("Camera at: " .. tostring(local_pose))
	end

	if not arg_20_3:get("toggle_control_points") then
		local_pose = FreeFlightControlPoints[self.current_control_point]:unbox()
		self.current_control_point = self.current_control_point % #FreeFlightControlPoints + 1

		print("Control Point: " .. tostring(self.current_control_point))
	end

	if not arg_20_3:get("set_drop_position") then
		self:drop_player_at_camera_pos(frustum_freeze_camera)
	end

	ScriptCamera.set_local_pose(frustum_freeze_camera, local_pose)
end

FreeFlightManager.cleanup_free_flight = function (self)
	-- function 21
	local global = self.data.global

	if not global.active then
		self:_exit_global_free_flight(global)
	end

	local player = Managers.player

	for k, v in pairs(self.data) do
		if k == "global" or not v.active then
			local local_player = player:local_player(k)

			self:_exit_free_flight(local_player, v)
		end
	end
end

FreeFlightManager._enter_global_free_flight = function (self, arg_22_1)
	-- function 22
	local main_world = Application.main_world()

	if not main_world then
		return
	end

	local create_global_free_flight_viewport = ScriptWorld.create_global_free_flight_viewport(main_world, "default")

	if not create_global_free_flight_viewport then
		return
	end

	arg_22_1.active = true
	arg_22_1.viewport_world_name = ScriptWorld.name(main_world)

	local camera = ScriptViewport.camera(create_global_free_flight_viewport)
	local local_pose = Camera.local_pose(camera)
	local translation = Matrix4x4.translation(local_pose)
	local rotation = Matrix4x4.rotation(local_pose)

	if not self._has_terrain then
		arg_22_1.terrain_decoration_observer = TerrainDecoration.create_observer(main_world, translation)
	end

	arg_22_1.scatter_system_observer = ScatterSystem.make_observer(World.scatter_system(main_world), translation, rotation)

	if not self._pause_on_enter_freeflight then
		self:_pause_game(true)
	end

	self:_set_control_input(true)
end

FreeFlightManager._set_control_input = function (self, arg_23_1)
	-- function 23
	arg_23_1 = not not arg_23_1

	if self._controlling_input == arg_23_1 then
		return
	end

	self._controlling_input = arg_23_1

	if not arg_23_1 then
		self.input_manager:block_device_except_service("FreeFlight", "keyboard", nil, "free_flight")
		self.input_manager:block_device_except_service("FreeFlight", "mouse", nil, "free_flight")
		self.input_manager:block_device_except_service("FreeFlight", "gamepad", nil, "free_flight")
		self.input_manager:device_unblock_service("keyboard", 1, "DebugMenu")
		self.input_manager:device_unblock_service("mouse", 1, "DebugMenu")
		self.input_manager:device_unblock_service("gamepad", 1, "DebugMenu")
		self.input_manager:device_unblock_service("keyboard", 1, "Debug")
		self.input_manager:device_unblock_service("mouse", 1, "Debug")
		self.input_manager:device_unblock_service("gamepad", 1, "Debug")
	else
		self.input_manager:device_unblock_all_services("keyboard")
		self.input_manager:device_unblock_all_services("mouse")
		self.input_manager:device_unblock_all_services("gamepad")
	end
end

FreeFlightManager._exit_global_free_flight = function (self, arg_24_1)
	-- function 24
	local world = Managers.world:world(arg_24_1.viewport_world_name)

	if not arg_24_1.frustum_freeze_camera then
		self:_exit_frustum_freeze(arg_24_1, world, ScriptWorld.global_free_flight_viewport(world), true)
	end

	local viewport_world_name = arg_24_1.viewport_world_name

	if not self._has_terrain then
		TerrainDecoration.destroy_observer(world, arg_24_1.terrain_decoration_observer)
	end

	ScatterSystem.destroy_observer(World.scatter_system(world), arg_24_1.scatter_system_observer)

	if not self._paused then
		self:_pause_game(false)
	end

	arg_24_1.active = false
	arg_24_1.viewport_world_name = nil

	ScriptWorld.destroy_global_free_flight_viewport(Managers.world:world(viewport_world_name))
	self:_set_control_input(false)
end

FreeFlightManager._clear_global_free_flight = function (arg_25_0, arg_25_1)
	-- function 25
	arg_25_1.active = false
	arg_25_1.viewport_world_name = nil
end

FreeFlightManager._update_player = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local input_service = arg_26_3.input_service
	local get = input_service:get("frustum_freeze_toggle")
	local get_2 = input_service:get("free_flight_toggle")

	if not (not arg_26_3.active and Managers.world:has_world(arg_26_3.viewport_world_name)) then
		self:_clear_free_flight(arg_26_3)
	elseif not arg_26_3.active and not get then
		local world = Managers.world:world(arg_26_3.viewport_world_name)

		self:_toggle_frustum_freeze(arg_26_1, arg_26_3, world, ScriptWorld.free_flight_viewport(world, arg_26_3.viewport_name))
	elseif not arg_26_3.active and not get_2 then
		self:_exit_free_flight(arg_26_2, arg_26_3)
	elseif get_2 or not Testify:poll_request("activate_free_flight") then
		self:_enter_free_flight(arg_26_2, arg_26_3)
	elseif not (not arg_26_3.active and self.data.global.active) then
		self:_update_free_flight(arg_26_1, arg_26_2, arg_26_3)
	end
end

FreeFlightManager._clear_free_flight = function (arg_27_0, arg_27_1)
	-- function 27
	arg_27_1.active = false
	arg_27_1.viewport_world_name = nil
	arg_27_1.viewport_name = nil
end

FreeFlightManager.register_player = function (self, arg_28_1)
	-- function 28
	local get_service = self.input_manager:get_service("FreeFlight")

	self.data[arg_28_1] = {
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
		input_service = get_service,
		rotation_accumulation = Vector3Box(),
		current_translation_speed = Vector3Box()
	}
end

FreeFlightManager.unregister_player = function (self, arg_29_1)
	-- function 29
	local var_29_0 = self.data[arg_29_1]

	fassert(var_29_0, "Trying to unregister player %i not registered", arg_29_1)

	if not var_29_0.active then
		self:_clear_free_flight(var_29_0)
	end

	self.data[arg_29_1] = nil
end

FreeFlightManager._setup_data = function (arg_30_0, arg_30_1)
	-- function 30
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

FreeFlightManager._enter_free_flight = function (self, arg_31_1, arg_31_2)
	-- function 31
	local viewport_world_name = arg_31_1.viewport_world_name
	local viewport_name = arg_31_1.viewport_name
	local world = Managers.world:world(viewport_world_name)
	local get_data = World.get_data(world, "viewports")
	local camera = ScriptViewport.camera(get_data[viewport_name])
	local vertical_fov = Camera.vertical_fov(camera)

	arg_31_2.active = true
	arg_31_2.viewport_name = arg_31_1.viewport_name
	arg_31_2.viewport_world_name = viewport_world_name

	local create_free_flight_viewport = ScriptWorld.create_free_flight_viewport(world, viewport_name, "default")
	local camera_2 = ScriptViewport.camera(create_free_flight_viewport)
	local local_pose = Camera.local_pose(camera_2)
	local translation = Matrix4x4.translation(local_pose)
	local rotation = Matrix4x4.rotation(local_pose)

	Camera.set_vertical_fov(camera_2, vertical_fov)

	if not self._has_terrain then
		arg_31_2.terrain_decoration_observer = TerrainDecoration.create_observer(world, translation)
	end

	arg_31_2.scatter_system_observer = ScatterSystem.make_observer(World.scatter_system(world), translation, rotation)

	self.input_manager:block_device_except_service("FreeFlight", "keyboard", nil, "free_flight")
	self.input_manager:block_device_except_service("FreeFlight", "mouse", nil, "free_flight")
	self.input_manager:block_device_except_service("FreeFlight", "gamepad", nil, "free_flight")

	if not script_data.testify and not Testify:poll_request("activate_free_flight") then
		Testify:respond_to_request("activate_free_flight")
	end
end

FreeFlightManager._exit_free_flight = function (self, arg_32_1, arg_32_2)
	-- function 32
	local world = Managers.world:world(arg_32_2.viewport_world_name)

	if not arg_32_2.frustum_freeze_camera then
		self:_exit_frustum_freeze(arg_32_2, world, ScriptWorld.viewport(world, arg_32_2.viewport_name))
	end

	local viewport_name = arg_32_2.viewport_name

	arg_32_2.active = false
	arg_32_2.viewport_name = nil
	arg_32_2.viewport_world_name = nil

	if not self._has_terrain then
		TerrainDecoration.destroy_observer(world, arg_32_2.terrain_decoration_observer)
	end

	ScatterSystem.destroy_observer(World.scatter_system(world), arg_32_2.scatter_system_observer)

	arg_32_2.terrain_decoration_observer = nil
	arg_32_2.scatter_system_observer = nil

	ScriptWorld.destroy_free_flight_viewport(world, viewport_name)
	self.input_manager:device_unblock_all_services("keyboard")
	self.input_manager:device_unblock_all_services("mouse")
	self.input_manager:device_unblock_all_services("gamepad")
end

FreeFlightManager.active = function (self, arg_33_1)
	-- function 33
	local var_33_0 = self.data[arg_33_1]

	var_33_0 = not var_33_0 and self.data[arg_33_1].active

	return var_33_0
end

FreeFlightManager.mode = function (self, arg_34_1)
	-- function 34
	return self.data[arg_34_1].mode
end

FreeFlightManager._update_free_flight = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local world = Managers.world:world(arg_35_3.viewport_world_name)
	local free_flight_viewport = ScriptWorld.free_flight_viewport(world, arg_35_3.viewport_name)
	local frustum_freeze_camera = arg_35_3.frustum_freeze_camera

	frustum_freeze_camera = frustum_freeze_camera or ScriptViewport.camera(free_flight_viewport)

	local get_service = self.input_manager:get_service("FreeFlight")
	local num = arg_35_3.current_translation_max_speed * 0.5
	local y = Vector3.y
	local get = get_service:get("speed_change")

	get = get or Vector3(0, 0, 0)

	local var_35_7 = y(get)

	arg_35_3.current_translation_max_speed = math.max(arg_35_3.current_translation_max_speed + var_35_7 * num, 0.01)

	local local_pose = Camera.local_pose(frustum_freeze_camera)
	local translation = Matrix4x4.translation(local_pose)

	Matrix4x4.set_translation(local_pose, Vector3(0, 0, 0))

	local get_2 = get_service:get("look")
	local num_2 = arg_35_3.rotation_accumulation:unbox() + get_2
	local num_3 = num_2 * math.min(arg_35_1, 1)
	local free_flight_movement_filter_speed = arg_35_2.free_flight_movement_filter_speed

	free_flight_movement_filter_speed = free_flight_movement_filter_speed or 15

	local num_4 = num_3 * free_flight_movement_filter_speed

	arg_35_3.rotation_accumulation:store(num_2 - num_4)

	local var_35_15 = Quaternion(Vector3(0, 0, 1), -Vector3.x(num_4) * arg_35_3.rotation_speed)
	local var_35_16 = Quaternion(Matrix4x4.x(local_pose), -Vector3.y(num_4) * arg_35_3.rotation_speed)
	local multiply = Quaternion.multiply(var_35_15, var_35_16)
	local multiply_2 = Matrix4x4.multiply(local_pose, Matrix4x4.from_quaternion(multiply))
	local num_5 = get_service:get("move") * arg_35_3.current_translation_max_speed
	local unbox = arg_35_3.current_translation_speed:unbox()
	local num_6 = num_5 - unbox
	local length = Vector3.length(num_6)
	local normalize = Vector3.normalize(num_6)

	if var_35_7 ~= 0 then
		local free_flight_acceleration_factor = arg_35_2.free_flight_acceleration_factor

		free_flight_acceleration_factor = free_flight_acceleration_factor or 5
		arg_35_3.acceleration = free_flight_acceleration_factor * Vector3.length(num_6)
	end

	local acceleration = arg_35_3.acceleration
	local num_7 = unbox + normalize * math.min(length, acceleration * arg_35_1)

	if not Vector3.equal(num_7, unbox) then
		-- Nothing
	end

	arg_35_3.current_translation_speed:store(num_7)

	local rotation = Matrix4x4.rotation(multiply_2)
	local num_8 = (Quaternion.forward(rotation) * num_7.y + Quaternion.right(rotation) * num_7.x + Quaternion.up(rotation) * num_7.z) * arg_35_1
	local add = Vector3.add(translation, num_8)

	Matrix4x4.set_translation(multiply_2, add)
	ScriptCamera.set_local_pose(frustum_freeze_camera, multiply_2)

	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.set_listener(wwise_world, 0, multiply_2)

	if not self._has_terrain then
		TerrainDecoration.move_observer(world, arg_35_3.terrain_decoration_observer, add)
	end

	ScatterSystem.move_observer(World.scatter_system(world), arg_35_3.scatter_system_observer, add, rotation)

	if not get_service:get("set_drop_position") then
		self:drop_player_at_camera_pos(frustum_freeze_camera, arg_35_2)
	end

	if not get_service:get("increase_fov") then
		local vertical_fov = Camera.vertical_fov(frustum_freeze_camera)

		Camera.set_vertical_fov(frustum_freeze_camera, vertical_fov + math.pi / 72)
	end

	if not get_service:get("ray") then
		local get_data = World.get_data(world, "physics_world")
		local immediate_raycast, var_35_34, var_35_35, var_35_36, var_35_37 = PhysicsWorld.immediate_raycast(get_data, Camera.local_position(frustum_freeze_camera), Quaternion.forward(Camera.local_rotation(frustum_freeze_camera)), 999, "closest")

		if not var_35_37 then
			print(var_35_37)
		end
	end

	if not get_service:get("decrease_fov") then
		local vertical_fov_2 = Camera.vertical_fov(frustum_freeze_camera)

		Camera.set_vertical_fov(frustum_freeze_camera, vertical_fov_2 - math.pi / 72)
	end

	local get_data_2 = World.get_data(world, "shading_environment")

	if not get_data_2 then
		if not (not get_service:get("toggle_dof") and get_service:get("dof_reset")) then
			arg_35_3.dof_enabled = 1 - arg_35_3.dof_enabled
		end

		if not (not get_service:get("inc_dof_distance") and get_service:get("inc_dof_region") or get_service:get("inc_dof_padding") or get_service:get("inc_dof_scale")) then
			arg_35_3.dof_focal_distance = arg_35_3.dof_focal_distance + 0.2

			print("Dof Focal Distance: ", arg_35_3.dof_focal_distance)
		end

		if not (not get_service:get("dec_dof_distance") and get_service:get("dec_dof_region") or get_service:get("dec_dof_padding") or get_service:get("dec_dof_scale")) then
			arg_35_3.dof_focal_distance = arg_35_3.dof_focal_distance - 0.2

			if arg_35_3.dof_focal_distance < 0 then
				arg_35_3.dof_focal_distance = 0
			end

			print("Dof Focal Distance: ", arg_35_3.dof_focal_distance)
		end

		if not get_service:get("inc_dof_region") then
			arg_35_3.dof_focal_region = arg_35_3.dof_focal_region + 0.2

			print("Dof Focal Region: ", arg_35_3.dof_focal_region)
		end

		if not get_service:get("dec_dof_region") then
			arg_35_3.dof_focal_region = arg_35_3.dof_focal_region - 0.2

			if arg_35_3.dof_focal_region < 0 then
				arg_35_3.dof_focal_region = 0
			end

			print("Dof Focal Region: ", arg_35_3.dof_focal_region)
		end

		if not get_service:get("inc_dof_padding") then
			arg_35_3.dof_focal_region_start = arg_35_3.dof_focal_region_start + 0.1
			arg_35_3.dof_focal_region_end = arg_35_3.dof_focal_region_end + 0.1

			print("Dof Focal Padding: ", arg_35_3.dof_focal_region_start)
		end

		if not get_service:get("dec_dof_padding") then
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

		if not get_service:get("inc_dof_scale") then
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

		if not get_service:get("dec_dof_scale") then
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

		if not get_service:get("dof_reset") then
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

		ShadingEnvironment.set_scalar(get_data_2, "dof_enabled", arg_35_3.dof_enabled)
		ShadingEnvironment.set_scalar(get_data_2, "dof_focal_distance", arg_35_3.dof_focal_distance)
		ShadingEnvironment.set_scalar(get_data_2, "dof_focal_region", arg_35_3.dof_focal_region)
		ShadingEnvironment.set_scalar(get_data_2, "dof_focal_region_start", arg_35_3.dof_focal_region_start)
		ShadingEnvironment.set_scalar(get_data_2, "dof_focal_region_end", arg_35_3.dof_focal_region_end)
		ShadingEnvironment.set_scalar(get_data_2, "dof_focal_near_scale", arg_35_3.dof_focal_near_scale)
		ShadingEnvironment.set_scalar(get_data_2, "dof_focal_far_scale", arg_35_3.dof_focal_far_scale)

		if not ShadingEnvironment.scalar(get_data_2, "dof_enabled") then
			ShadingEnvironment.apply(get_data_2)
		end
	end
end

FreeFlightManager.drop_player_at_camera_pos = function (self, arg_36_1, arg_36_2)
	-- function 36
	local local_position = Camera.local_position(arg_36_1)
	local local_rotation = Camera.local_rotation(arg_36_1)

	if not self._teleport_override then
		self._teleport_override(local_position, local_rotation)
	elseif not arg_36_2 and not arg_36_2.camera_follow_unit then
		Unit.set_local_position(arg_36_2.camera_follow_unit, 0, local_position)

		local mover = Unit.mover(arg_36_2.camera_follow_unit)

		if not mover then
			Mover.set_position(mover, local_position)
		end
	end
end
