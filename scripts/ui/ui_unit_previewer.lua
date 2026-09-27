-- chunkname: @scripts/ui/ui_unit_previewer.lua

local num = 0

UIUnitPreviewer = class(UIUnitPreviewer)

UIUnitPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self._background_world = arg_1_4
	self._background_viewport = arg_1_5
	self._unique_id = arg_1_6
	self._loaded_packages = {}
	self._packages_to_load = {}
	self._camera_xy_angle_target = num
	self._camera_xy_angle_current = num
	self._spawn_position = arg_1_3
	self._unit_to_spawn = arg_1_1
	self._package_name = arg_1_2

	self:_load_package(arg_1_2)
end

UIUnitPreviewer.register_spawn_callback = function (self, arg_2_1)
	-- function 2
	self._spawn_callback = arg_2_1
end

UIUnitPreviewer.activate_auto_spin = function (self)
	-- function 3
	self._auto_spin_random_seed = math.random(5, 30000)
end

UIUnitPreviewer.destroy = function (self)
	-- function 4
	self:_destroy_unit()
	self:_unload_package()
	table.clear(self._loaded_packages)
	table.clear(self._packages_to_load)

	self._background_viewport = nil
	self._background_world = nil
end

UIUnitPreviewer._destroy_unit = function (self)
	-- function 5
	local _background_world = self._background_world
	local _spawned_unit = self._spawned_unit

	if not _spawned_unit then
		World.destroy_unit(_background_world, _spawned_unit)

		self._spawned_unit = nil
	end
end

UIUnitPreviewer.update = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not self._unit_spawned then
		if not arg_6_3 then
			local input = Managers.input

			if not input:is_device_active("mouse") then
				self:_handle_mouse_input(arg_6_3, arg_6_1)
			elseif not input:is_device_active("gamepad") then
				self:_handle_controller_input(arg_6_3, arg_6_1)
			end
		end

		if self._camera_xy_angle_target > math.pi * 2 then
			self._camera_xy_angle_current = self._camera_xy_angle_current - math.pi * 2
			self._camera_xy_angle_target = self._camera_xy_angle_target - math.pi * 2
		end

		local lerp = math.lerp(self._camera_xy_angle_current, self._camera_xy_angle_target, 0.1)

		self._camera_xy_angle_current = lerp

		local _auto_spin_values, var_6_3 = self:_auto_spin_values(arg_6_1, arg_6_2)
		local axis_angle = Quaternion.axis_angle(Vector3(0, _auto_spin_values, 1), -(lerp + var_6_3))
		local _spawned_unit = self._spawned_unit

		Unit.set_local_rotation(_spawned_unit, 0, axis_angle)

		if not self._zoom_dirty then
			local _zoom_fraction = self._zoom_fraction

			_zoom_fraction = _zoom_fraction or 0

			local unbox = self._unit_start_position_boxed:unbox()

			unbox[1] = unbox[1] * (1 - _zoom_fraction)
			unbox[2] = unbox[2] * (1 - _zoom_fraction)

			Unit.set_local_position(_spawned_unit, 0, unbox)

			self._zoom_dirty = nil
		end
	end
end

UIUnitPreviewer.set_zoom_fraction = function (self, arg_7_1)
	-- function 7
	self._zoom_fraction = math.clamp(arg_7_1, 0, 1)
	self._zoom_dirty = true
end

UIUnitPreviewer.set_zoom_fraction_unclamped = function (self, arg_8_1)
	-- function 8
	self._zoom_fraction = arg_8_1
	self._zoom_dirty = true
end

UIUnitPreviewer.zoom_fraction = function (self)
	-- function 9
	local _zoom_fraction = self._zoom_fraction

	_zoom_fraction = _zoom_fraction or 0

	return _zoom_fraction
end

UIUnitPreviewer._auto_spin_values = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _auto_spin_random_seed = self._auto_spin_random_seed

	if not _auto_spin_random_seed then
		return 0, 0
	end

	local num = 0.2
	local num_2 = 0.3
	local num_3 = math.sin((_auto_spin_random_seed + arg_10_2) * num) * num_2
	local num_4 = -(num_3 * 0.5)
	local num_5 = -(num_3 * math.pi / 2)

	return num_4, num_5
end

local tbl = {}

UIUnitPreviewer._handle_mouse_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get = arg_11_1:get("cursor")

	if not get then
		return
	end

	if not arg_11_1:get("left_press") then
		self._is_moving_camera = true
		self._last_mouse_position = nil
	elseif not arg_11_1:get("right_press") then
		self._camera_xy_angle_target = num
	end

	local _is_moving_camera = self._is_moving_camera
	local get_2 = arg_11_1:get("left_hold")

	if not _is_moving_camera and not get_2 then
		if not self._last_mouse_position then
			self._camera_xy_angle_target = self._camera_xy_angle_target - (get.x - self._last_mouse_position[1]) * 0.01
		end

		tbl[1] = get.x
		tbl[2] = get.y
		self._last_mouse_position = tbl
	elseif not _is_moving_camera then
		self._is_moving_camera = false
	end
end

UIUnitPreviewer._handle_controller_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local get = arg_12_1:get("gamepad_right_axis")

	if not (not get and not (Vector3.length(get) > 0.01)) then
		self._camera_xy_angle_target = self._camera_xy_angle_target + -get.x * arg_12_2 * 5
	end
end

UIUnitPreviewer.post_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._spawn_callback and not self._unit_spawned then
		self._spawn_callback()

		self._spawn_callback = nil
	end
end

UIUnitPreviewer._trigger_unit_flow_event = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not arg_14_1 and not Unit.alive(arg_14_1) then
		Unit.flow_event(arg_14_1, arg_14_2)
	end
end

UIUnitPreviewer._get_world = function (self)
	-- function 15
	return self._background_world, self._background_viewport
end

UIUnitPreviewer._get_camera_position = function (self)
	-- function 16
	local _background_viewport = self._background_viewport
	local camera = ScriptViewport.camera(_background_viewport)

	return ScriptCamera.position(camera)
end

UIUnitPreviewer._get_camera_rotation = function (self)
	-- function 17
	local _background_viewport = self._background_viewport
	local camera = ScriptViewport.camera(_background_viewport)

	return ScriptCamera.rotation(camera)
end

UIUnitPreviewer._packages_loaded = function (self)
	-- function 18
	local units_to_spawn = self.units_to_spawn
	local _loaded_packages = self._loaded_packages

	for i, v in ipairs(units_to_spawn) do
		for i_2, v_2 in ipairs(v) do
			if not _loaded_packages[v_2.unit_name] then
				return false
			end
		end
	end

	return true
end

UIUnitPreviewer._load_package = function (self, arg_19_1)
	-- function 19
	local package = Managers.package
	local var_19_1 = callback(self, "_on_load_complete", arg_19_1)
	local str = "UIUnitPreviewer"

	if not self._unique_id then
		str = str .. tostring(self._unique_id)
	end

	package:load(arg_19_1, str, var_19_1, true)
end

UIUnitPreviewer._on_load_complete = function (self, arg_20_1)
	-- function 20
	self._package_loaded = true

	if not self._unit_to_spawn and not self._background_viewport then
		self._spawned_unit = self:_spawn_unit(self._unit_to_spawn, true)
		self._unit_to_spawn = nil
		self._unit_spawned = true
	end
end

UIUnitPreviewer._unload_package = function (self)
	-- function 21
	local _package_name = self._package_name
	local str = "UIUnitPreviewer"

	if not self._unique_id then
		str = str .. tostring(self._unique_id)
	end

	Managers.package:unload(_package_name, str)
end

UIUnitPreviewer._spawn_unit = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _get_camera_rotation = self:_get_camera_rotation()
	local forward = Quaternion.forward(_get_camera_rotation)
	local look = Quaternion.look(forward, Vector3.up())
	local axis_angle = Quaternion.axis_angle(Vector3.up(), 0)
	local multiply = Quaternion.multiply(look, axis_angle)
	local _spawn_position = self._spawn_position
	local num = self:_get_camera_position() + forward + Vector3(_spawn_position[1], _spawn_position[2], _spawn_position[3])
	local _background_world = self._background_world
	local spawn_unit = World.spawn_unit(_background_world, arg_22_1, num, multiply)

	Unit.set_unit_visibility(spawn_unit, arg_22_2)

	local world_position = Unit.world_position(spawn_unit, 0)

	self._unit_start_position_boxed = Vector3Box(world_position)

	return spawn_unit
end
