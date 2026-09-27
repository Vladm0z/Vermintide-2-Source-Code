-- chunkname: @scripts/managers/input/input_manager.lua

require("scripts/managers/input/input_service")
require("scripts/managers/input/play_recording_input_device")
require("scripts/managers/input/network_input_device")
require("scripts/managers/input/input_aux")
require("scripts/managers/input/input_filters")
require("scripts/managers/input/input_debugger")
require("scripts/managers/input/input_stack_settings")

local most_recent_input_device = most_recent_input_device

if not most_recent_input_device then
	if not IS_WINDOWS then
		most_recent_input_device = Keyboard

		if not most_recent_input_device then
			-- Nothing
		end
	end

	most_recent_input_device = Pad1
end

::label_0_0::

local most_recent_input_device_type = most_recent_input_device_type

most_recent_input_device_type = most_recent_input_device_type or not IS_WINDOWS or "keyboard" or "gamepad"

local parameter = Development.parameter("disable_gamepad")

local function fn(...)
	-- function 1
	if not script_data.input_debug_filters then
		printf(...)
	end
end

InputManager = class(InputManager)

InputManager.init = function (self)
	-- function 2
	self.platform = PLATFORM
	self.input_services = {}
	self.input_devices = {}
	self.stored_keymaps_data = {}
	self.stored_filters_data = {}
	self.blocked_gamepad_services = {}
	self._device_input_groups = {}
	self._active_input_group_id = nil

	local gamepad = InputAux.input_device_mapping.gamepad

	for i, v in ipairs(gamepad) do
		v.set_down_threshold(0.25)
	end
end

InputManager.destroy = function (self)
	-- function 3
	self.input_services = nil
	self.input_devices = nil
end

InputManager.initialize_device = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not (not parameter and arg_4_1 ~= "gamepad") then
		return
	end

	if not (not IS_CONSOLE and arg_4_1 == "keyboard" and arg_4_1 == "mouse" and GameSettingsDevelopment.allow_keyboard_mouse) then
		return
	end

	local var_4_0 = InputAux.input_device_mapping[arg_4_1]

	assert(var_4_0, "No such input device type: %s", arg_4_1)

	if arg_4_1 == "gamepad" then
		for i, v in ipairs(var_4_0) do
			assert(not self.input_devices[v], "Input device already initialized %s %d.", arg_4_1, i)

			self.input_devices[v] = {
				pressed = {},
				released = {},
				held = {},
				soft_button = {},
				num_buttons = v.num_buttons(),
				axis = {},
				num_axes = v.num_axes(),
				blocked_access = {},
				consumed_input = {}
			}
		end
	else
		arg_4_2 = arg_4_2 or 1

		local var_4_1 = var_4_0[arg_4_2]

		assert(var_4_1, "No input device %s with index %d", arg_4_1, arg_4_2)
		assert(not self.input_devices[var_4_1], "Input device already initialized %s %d.", arg_4_1, arg_4_2)

		self.input_devices[var_4_1] = {
			pressed = {},
			released = {},
			held = {},
			soft_button = {},
			num_buttons = var_4_1.num_buttons(),
			axis = {},
			num_axes = var_4_1.num_axes(),
			blocked_access = {},
			consumed_input = {}
		}
	end
end

InputManager.remove_all_devices = function (self, arg_5_1)
	-- function 5
	local var_5_0 = InputAux.input_device_mapping[arg_5_1]

	if not var_5_0 then
		return
	end

	for i, v in ipairs(var_5_0) do
		for k, v_2 in pairs(self.input_services) do
			v_2:unmap_device(arg_5_1, v)
		end

		self.input_devices[v] = nil
	end

	for i4 = #var_5_0, 1, -1 do
		local var_5_1 = var_5_0[i4]

		InputAux.remove_device(arg_5_1, var_5_1)
	end
end

InputManager.set_exclusive_gamepad = function (self, arg_6_1)
	-- function 6
	local str = "gamepad"

	self:remove_all_devices(str)
	InputAux.add_device(str, arg_6_1)
	self:initialize_device(str)

	local var_6_1 = self.input_devices[arg_6_1]

	for k, v in pairs(self.input_services) do
		v:map_device(str, arg_6_1, self.input_devices[arg_6_1])

		if not self.blocked_gamepad_services[k] then
			var_6_1.blocked_access[k] = true
		end
	end
end

InputManager.set_all_gamepads_available = function (self)
	-- function 7
	local str = "gamepad"

	self:remove_all_devices(str)

	local tbl = {
		rawget(_G, "Pad1"),
		rawget(_G, "Pad2"),
		rawget(_G, "Pad3"),
		rawget(_G, "Pad4"),
		rawget(_G, "Pad5"),
		rawget(_G, "Pad6"),
		rawget(_G, "Pad7"),
		rawget(_G, "Pad8")
	}

	for i, v in ipairs(tbl) do
		local var_7_2 = tbl[i]

		InputAux.add_device(str, var_7_2)
	end

	self:initialize_device(str)

	for i_2, v_2 in ipairs(tbl) do
		local var_7_3 = self.input_devices[v_2]

		for k, v_3 in pairs(self.input_services) do
			v_3:map_device(str, v_2, self.input_devices[v_2])

			if not self.blocked_gamepad_services[k] then
				var_7_3.blocked_access[k] = true
			end
		end
	end
end

InputManager.block_device_except_service = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if not (not parameter and arg_8_2 == "gamepad" or arg_8_2 ~= "ps_pad") then
		return
	end

	arg_8_3 = arg_8_3 or 1

	local var_8_0 = InputAux.input_device_mapping[arg_8_2]

	if not var_8_0 then
		return
	end

	if not (arg_8_2 == "gamepad" or arg_8_2 ~= "ps_pad") then
		for i, v in ipairs(var_8_0) do
			local var_8_1 = self.input_devices[v]

			for k, v_2 in pairs(self.input_services) do
				if not v_2.block_reasons and not v_2.block_reasons[arg_8_4] then
					var_8_1.blocked_access[k] = true

					v_2:set_blocked(true)
				elseif not v_2.block_reasons then
					var_8_1.blocked_access[k] = true

					v_2:set_blocked(true)
				end

				self.blocked_gamepad_services[k] = true
			end

			if not arg_8_1 and not var_8_1.blocked_access[arg_8_1] then
				self.input_services[arg_8_1]:set_blocked(nil)

				var_8_1.blocked_access[arg_8_1] = nil
			end

			if not arg_8_1 then
				self.blocked_gamepad_services[arg_8_1] = nil
			end
		end
	else
		local var_8_2 = var_8_0[arg_8_3]
		local var_8_3 = self.input_devices[var_8_2]

		if not var_8_3 then
			for k_2, v_3 in pairs(self.input_services) do
				if not v_3.block_reasons and not v_3.block_reasons[arg_8_4] then
					var_8_3.blocked_access[k_2] = true

					v_3:set_blocked(true)
				elseif not v_3.block_reasons then
					var_8_3.blocked_access[k_2] = true

					v_3:set_blocked(true)
				end
			end

			if not arg_8_1 and not var_8_3.blocked_access[arg_8_1] then
				self.input_services[arg_8_1]:set_blocked(nil)

				var_8_3.blocked_access[arg_8_1] = nil
			end
		end
	end

	if not (not IS_WINDOWS and arg_8_2 ~= "gamepad") then
		self:block_device_except_service(arg_8_1, "ps_pad", arg_8_3, arg_8_4)
	end
end

InputManager.device_unblock_all_services = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not (not parameter and arg_9_1 == "gamepad" or arg_9_1 ~= "ps_pad") then
		return
	end

	local var_9_0 = InputAux.input_device_mapping[arg_9_1]

	if not var_9_0 then
		return
	end

	if not (arg_9_1 == "gamepad" or arg_9_1 ~= "ps_pad") then
		for i, v in ipairs(var_9_0) do
			local var_9_1 = self.input_devices[v]
			local input_services = self.input_services

			for k, v_2 in pairs(var_9_1.blocked_access) do
				input_services[k]:set_blocked(nil)

				var_9_1.blocked_access[k] = nil
			end
		end

		self.blocked_gamepad_services = {}
	else
		arg_9_2 = arg_9_2 or 1

		local var_9_3 = var_9_0[arg_9_2]
		local var_9_4 = self.input_devices[var_9_3]

		if not var_9_4 then
			local input_services_2 = self.input_services

			for k_2, v_3 in pairs(var_9_4.blocked_access) do
				input_services_2[k_2]:set_blocked(nil)

				var_9_4.blocked_access[k_2] = nil
			end
		end
	end

	if not (not IS_WINDOWS and arg_9_1 ~= "gamepad") then
		self:device_unblock_all_services("ps_pad", arg_9_2)
	end
end

InputManager.device_block_service = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	if not (not parameter and arg_10_1 == "gamepad" or arg_10_1 ~= "ps_pad") then
		return
	end

	local var_10_0 = self.input_services[arg_10_3]

	if not (not var_10_0.block_reasons and var_10_0.block_reasons[arg_10_4]) then
		return
	end

	local var_10_1 = InputAux.input_device_mapping[arg_10_1]

	if not var_10_1 then
		return
	end

	if arg_10_1 == "gamepad" then
		for i, v in ipairs(var_10_1) do
			self.input_devices[v].blocked_access[arg_10_3] = true

			var_10_0:set_blocked(true)
		end

		self.blocked_gamepad_services[arg_10_3] = true
	else
		arg_10_2 = arg_10_2 or 1

		local var_10_2 = var_10_1[arg_10_2]
		local var_10_3 = self.input_devices[var_10_2]

		if not var_10_3 then
			var_10_3.blocked_access[arg_10_3] = true

			var_10_0:set_blocked(true)
		end
	end

	if not (not IS_WINDOWS and arg_10_1 ~= "gamepad") then
		self:device_block_service("ps_pad", arg_10_2, arg_10_3, arg_10_4)
	end
end

InputManager.device_unblock_service = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	if not (not parameter and arg_11_1 == "gamepad" or arg_11_1 ~= "ps_pad") then
		return
	end

	local var_11_0 = InputAux.input_device_mapping[arg_11_1]

	if not var_11_0 then
		return
	end

	if arg_11_1 == "gamepad" then
		for i, v in ipairs(var_11_0) do
			self.input_devices[v].blocked_access[arg_11_3] = nil

			self.input_services[arg_11_3]:set_blocked(nil)
		end

		self.blocked_gamepad_services[arg_11_3] = nil
	else
		arg_11_2 = arg_11_2 or 1

		local var_11_1 = var_11_0[arg_11_2]
		local var_11_2 = self.input_devices[var_11_1]

		if not var_11_2 then
			var_11_2.blocked_access[arg_11_3] = nil

			self.input_services[arg_11_3]:set_blocked(nil)
		end
	end

	if not (not IS_WINDOWS and arg_11_1 ~= "gamepad") then
		self:device_unblock_service("ps_pad", arg_11_2, arg_11_3)
	end
end

InputManager.get_unblocked_services = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local num = 0

	for k, v in pairs(self.input_services) do
		if not v:is_blocked() then
			num = num + 1
			arg_12_3[num] = k
		end
	end

	return num
end

InputManager.get_blocked_services = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local num = 0

	for k, v in pairs(self.input_services) do
		if not v:is_blocked() then
			num = num + 1
			arg_13_3[num] = k
		end
	end

	return num
end

InputManager.device_block_services = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	arg_14_2 = arg_14_2 or 1

	for i = 1, arg_14_4 do
		local var_14_0 = arg_14_3[i]

		self:device_block_service(arg_14_1, arg_14_2, var_14_0, arg_14_5)
	end
end

InputManager.device_unblock_services = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	arg_15_2 = arg_15_2 or 1

	for i = 1, arg_15_4 do
		local var_15_0 = arg_15_3[i]

		self:device_unblock_service(arg_15_1, arg_15_2, var_15_0)
	end
end

InputManager.capture_input = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	if not arg_16_1 then
		return
	end

	if not arg_16_2 then
		return
	end

	if not arg_16_3 then
		return
	end

	if not arg_16_4 then
		return
	end

	for i = 1, #arg_16_1 do
		self:device_unblock_service(arg_16_1[i], arg_16_2, arg_16_3)
	end

	local _find_service_input_group = self:_find_service_input_group(arg_16_3)

	if not _find_service_input_group then
		local _device_input_groups = self._device_input_groups
		local var_16_2 = _device_input_groups[_find_service_input_group]

		if not var_16_2 then
			var_16_2 = {}
			_device_input_groups[_find_service_input_group] = var_16_2
		end

		local var_16_3 = var_16_2[arg_16_3]

		if not var_16_3 then
			var_16_3 = {}
			var_16_2[arg_16_3] = var_16_3
		end

		if not table.contains(var_16_3, arg_16_4) then
			local is_empty = table.is_empty(var_16_3)

			table.insert(var_16_3, arg_16_4)

			if not is_empty then
				self:_refresh_active_input_group()
			end
		end
	end
end

InputManager.release_input = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	if not arg_17_1 then
		return
	end

	if not arg_17_2 then
		return
	end

	if not arg_17_3 then
		return
	end

	if not arg_17_4 then
		return
	end

	for i = 1, #arg_17_1 do
		self:device_block_service(arg_17_1[i], arg_17_2, arg_17_3, arg_17_5)
	end

	local _find_service_input_group = self:_find_service_input_group(arg_17_3)

	if not _find_service_input_group then
		local _device_input_groups = self._device_input_groups
		local var_17_2 = _device_input_groups[_find_service_input_group]

		if not var_17_2 then
			return
		end

		local var_17_3 = var_17_2[arg_17_3]

		if not var_17_3 then
			return
		end

		if not table.find(var_17_3, arg_17_4) then
			table.remove(var_17_3, table.find(var_17_3, arg_17_4))
		end

		if not table.is_empty(var_17_3) then
			var_17_2[arg_17_3] = nil

			if not table.is_empty(var_17_2) then
				_device_input_groups[_find_service_input_group] = nil
			end

			self:_refresh_active_input_group()
		end
	end
end

InputManager._find_service_input_group = function (arg_18_0, arg_18_1)
	-- function 18
	local var_18_0 = InputServiceToGroupMap[arg_18_1]

	if not var_18_0 then
		return nil
	end

	return InputStackSettings[var_18_0].group_name
end

InputManager._refresh_active_input_group = function (self)
	-- function 19
	local _device_input_groups = self._device_input_groups
	local _find_active_input_group_id = self:_find_active_input_group_id(_device_input_groups)

	self:_capture_input_group(_find_active_input_group_id)
end

InputManager._capture_input_group = function (self, arg_20_1)
	-- function 20
	self._active_input_group_id = arg_20_1

	local input_services = self.input_services

	if not (not arg_20_1 and InputStackSettings[arg_20_1]) then
		for k, v in pairs(input_services) do
			local var_20_1 = InputServiceToGroupMap[k]
			local flag = var_20_1 == nil or arg_20_1 < var_20_1

			v:set_disabled_input_group(flag)
		end
	else
		for k_2, v_2 in pairs(input_services) do
			v_2:set_disabled_input_group(nil)
		end
	end
end

InputManager._update_service_input_group = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	if not arg_21_1 then
		return
	end

	local flag = not arg_21_2 and InputStackSettings[arg_21_2]

	if not flag then
		arg_21_1:set_disabled_input_group(nil)
	else
		local contains = table.contains(flag.services, arg_21_1.name)

		arg_21_1:set_disabled_input_group(not contains)
	end
end

InputManager._find_active_input_group_id = function (arg_22_0, arg_22_1)
	-- function 22
	for i = 1, #InputStackSettings do
		if not arg_22_1[InputStackSettings[i].group_name] then
			return i
		end
	end

	return nil
end

InputManager.create_input_service = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local var_23_0 = rawget(_G, arg_23_2)

	fassert(var_23_0, "[InputManager] - No keymaps found for %s", arg_23_2)

	if not self.stored_keymaps_data[arg_23_2] then
		self:add_keymaps_data(var_23_0, arg_23_2)
	end

	if not arg_23_3 then
		local var_23_1 = rawget(_G, arg_23_3)

		fassert(var_23_1, "[InputManager] - No filters found for %s", arg_23_3)

		if not self.stored_filters_data[arg_23_3] then
			self:add_filters_data(var_23_1, arg_23_3)
		end
	end

	local var_23_2 = InputService:new(arg_23_1, arg_23_2, arg_23_3, arg_23_4)

	self.input_services[arg_23_1] = var_23_2

	self:_update_service_input_group(var_23_2, self._active_input_group_id)
end

InputManager.get_input_service = function (self, arg_24_1)
	-- function 24
	return self.input_services[arg_24_1]
end

InputManager.get_active_input_service_by_device = function (self, arg_25_1)
	-- function 25
	for k, v in pairs(self.input_services) do
		if not v:is_blocked() then
			local mapped_devices = v.mapped_devices

			if not mapped_devices then
				for k_2, v_2 in pairs(mapped_devices) do
					if k_2 == arg_25_1 then
						return v
					end
				end
			end
		end
	end
end

InputManager.map_device_to_service = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if not (not parameter and arg_26_2 == "gamepad" or arg_26_2 ~= "ps_pad") then
		return
	end

	if not (not IS_CONSOLE and arg_26_2 == "keyboard" and arg_26_2 == "mouse" and GameSettingsDevelopment.allow_keyboard_mouse) then
		return
	end

	local var_26_0 = self.input_services[arg_26_1]

	assert(var_26_0, "No such input service name: %s", arg_26_1)

	local var_26_1 = InputAux.input_device_mapping[arg_26_2]

	assert(var_26_1, "No such input device type: %s", arg_26_2)

	if not (arg_26_2 == "gamepad" or arg_26_2 ~= "ps_pad") then
		for i, v in ipairs(var_26_1) do
			local var_26_2 = self.input_devices[v]

			var_26_0:map_device(arg_26_2, v, var_26_2)
		end
	else
		arg_26_3 = arg_26_3 or 1

		local var_26_3 = var_26_1[arg_26_3]

		assert(var_26_3, "No input device %s with index %d", arg_26_2, arg_26_3)

		local var_26_4 = self.input_devices[var_26_3]

		var_26_0:map_device(arg_26_2, var_26_3, var_26_4)
	end

	if not (not IS_WINDOWS and arg_26_2 ~= "gamepad") then
		self:map_device_to_service(arg_26_1, "ps_pad", arg_26_3)
	end
end

InputManager.update = function (self, arg_27_1, arg_27_2)
	-- function 27
	InputAux.default_values_for_types.Vector3 = Vector3.zero()
	self._hovering = self._frame_hovering
	self._frame_hovering = false
	self._showing_tooltip = false

	self:update_devices(arg_27_1, arg_27_2)
end

local tbl = {
	left = true,
	right = true
}

InputManager.update_devices = function (self, arg_28_1, arg_28_2)
	-- function 28
	local input_devices = self.input_devices

	self.any_device_input_pressed = nil
	self.any_device_input_released = nil
	self.any_device_input_axis_moved = nil

	for k, v in pairs(input_devices) do
		local pressed = v.pressed
		local held = v.held
		local soft_button = v.soft_button
		local flag = k.type() == "sce_pad"
		local num = v.num_buttons - 1

		for k_2 = 0, num do
			local button = k.button(k_2)

			soft_button[k_2] = button
			held[k_2] = button > 0.5
		end

		local any_pressed = k.any_pressed()

		if not any_pressed then
			for l = 0, num do
				pressed[l] = k.pressed(l)
			end
		else
			for i4 = 0, num do
				pressed[i4] = false
			end
		end

		local any_released = k.any_released()
		local released = v.released

		if not any_released then
			for i5 = 0, num do
				released[i5] = k.released(i5)
			end
		else
			for i6 = 0, num do
				released[i6] = false
			end
		end

		local flag_2 = false
		local axis = v.axis

		for i7 = 0, v.num_axes - 1 do
			local axis_2 = k.axis(i7)

			axis[i7] = axis_2

			local axis_name = k.axis_name(i7)

			if IS_PS4 or not flag then
				if not (not tbl[axis_name] and Vector3.length(axis_2) == 0) then
					flag_2 = true
				end
			elseif not (axis_name == "cursor" or Vector3.length(axis_2) == 0) then
				flag_2 = true
			end
		end

		if not any_pressed then
			self.any_device_input_pressed = true
		end

		if not any_released then
			self.any_device_input_released = true
		end

		if not flag_2 then
			self.any_device_input_axis_moved = true
		end

		if any_pressed or not flag_2 then
			self.last_active_time = arg_28_2

			if most_recent_input_device ~= k then
				most_recent_input_device = k
				most_recent_input_device_type = InputAux.input_device_type_lookup[k]

				local type = most_recent_input_device.type()
				local _name = k._name
				local flag_3 = _name == "Keyboard" or _name == "Mouse"

				ShowCursorStack.render_cursor(flag_3)
			end
		end

		table.clear(v.consumed_input)
	end
end

InputManager.get_service = function (self, arg_29_1)
	-- function 29
	if not self.input_services then
		return self.input_services[arg_29_1]
	else
		return FAKE_INPUT_SERVICE
	end
end

local tbl_2 = {
	active = function ()
		-- function 30
		return false
	end
}

InputManager.get_device = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	if not (not parameter and arg_31_1 ~= "gamepad") then
		return tbl_2
	end

	local var_31_0 = InputAux.input_device_mapping[arg_31_1]

	assert(var_31_0, "No such input device type: %s", arg_31_1)

	arg_31_2 = arg_31_2 or 1

	return var_31_0[arg_31_2]
end

InputManager.any_input_pressed = function (self)
	-- function 32
	return self.any_device_input_pressed
end

InputManager.any_input_released = function (self)
	-- function 33
	return self.any_device_input_released
end

InputManager.any_input_axis_moved = function (self)
	-- function 34
	return self.any_device_input_axis_moved
end

InputManager.get_most_recent_device = function (arg_35_0)
	-- function 35
	return most_recent_input_device
end

InputManager.get_most_recent_device_type = function (arg_36_0)
	-- function 36
	return most_recent_input_device_type
end

InputManager.is_device_active = function (arg_37_0, arg_37_1)
	-- function 37
	if arg_37_1 ~= "gamepad" or not parameter then
		return false
	end

	return most_recent_input_device_type == arg_37_1
end

InputManager.add_filters_data = function (self, arg_38_1, arg_38_2)
	-- function 38
	local stored_filters_data = self.stored_filters_data

	fassert(not stored_filters_data[arg_38_2], "[InputManager] - filters already stored with name: %s", arg_38_2)

	local tbl = {}

	for k, v in pairs(arg_38_1) do
		tbl[k] = self:setup_filters(v)
	end

	stored_filters_data[arg_38_2] = tbl

	fn("[InputManager] - Add filters data for name: %s", arg_38_2)
end

InputManager.update_filters_data = function (self, arg_39_1, arg_39_2)
	-- function 39
	local stored_filters_data = self.stored_filters_data
	local var_39_1 = stored_filters_data[arg_39_2]

	fassert(stored_filters_data[arg_39_2], "[InputManager] - no filters stored with name: %s", arg_39_2)

	for k, v in pairs(arg_39_1) do
		local var_39_2 = var_39_1[k]
		local setup_filters = self:setup_filters(v)

		table.merge_recursive(var_39_2, setup_filters)
	end

	fn("[InputManager] - Updated filters data for name: %s", arg_39_2)
end

InputManager.setup_filters = function (arg_40_0, arg_40_1)
	-- function 40
	local tbl = {}

	if not arg_40_1 then
		for k, v in pairs(arg_40_1) do
			local filter_type = v.filter_type
			local tbl_2 = {}
			local var_40_3 = InputFilters[filter_type].init(v)

			var_40_3 = var_40_3 or true
			tbl_2.function_data = var_40_3
			tbl_2.filter_output = k
			tbl_2.filter_type = filter_type
			tbl_2.filter_function = InputFilters[filter_type].update
			tbl[k] = tbl_2
		end
	end

	return tbl
end

InputManager.filters_data = function (self, arg_41_1)
	-- function 41
	local var_41_0 = self.stored_filters_data[arg_41_1]

	fassert(var_41_0, "[InputManager] - No filters found by name %s", arg_41_1)

	return var_41_0
end

InputManager.apply_saved_keymaps = function (self, arg_42_1)
	-- function 42
	local stored_keymaps_data = self.stored_keymaps_data

	if IS_WINDOWS or IS_XB1 or not IS_LINUX then
		local controls = PlayerData.controls

		controls = controls or {}

		for k, v in pairs(controls) do
			if not arg_42_1 and arg_42_1 ~= k or not stored_keymaps_data[k] then
				self:update_keymaps_data(v, k)
			end
		end
	end

	local user_setting = Application.user_setting("gamepad_layout")

	if not user_setting then
		local user_setting_2 = Application.user_setting("gamepad_left_handed")
		local var_42_4

		if not user_setting_2 then
			var_42_4 = AlternatateGamepadKeymapsLayoutsLeftHanded
		else
			var_42_4 = AlternatateGamepadKeymapsLayouts
		end

		local var_42_5 = var_42_4[user_setting]

		for k_2, v_2 in pairs(var_42_5) do
			if not arg_42_1 and arg_42_1 ~= k_2 or not stored_keymaps_data[k_2] then
				self:update_keymaps_data(v_2, k_2)
			end
		end
	end
end

InputManager.set_hovering = function (self, arg_43_1)
	-- function 43
	if not (not arg_43_1 and self._hovering) then
		-- Nothing
	end

	local _hovering = self._hovering

	_hovering = _hovering or arg_43_1
	self._hovering = _hovering

	local _frame_hovering = self._frame_hovering

	_frame_hovering = _frame_hovering or arg_43_1
	self._frame_hovering = _frame_hovering
end

local tbl_3 = {}

InputManager.set_gamepad_cursor_pos = function (arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	tbl_3[1] = arg_44_1
	tbl_3[2] = arg_44_2
end

InputManager.center_gamepad_cursor_pos = function (arg_45_0)
	-- function 45
	tbl_3[1] = 960
	tbl_3[2] = 540
end

InputManager.get_gamepad_cursor_pos = function (arg_46_0)
	-- function 46
	local var_46_0 = tbl_3[1]
	local var_46_1 = tbl_3[2]

	table.clear(tbl_3)

	return var_46_0, var_46_1
end

InputManager.disable_gamepad_cursor = function (self)
	-- function 47
	self._gamepad_cursor_active = false
end

InputManager.enable_gamepad_cursor = function (self)
	-- function 48
	self._gamepad_cursor_active = true
end

InputManager.gamepad_cursor_active = function (self)
	-- function 49
	return self._gamepad_cursor_active
end

InputManager.is_hovering = function (self)
	-- function 50
	return self._hovering
end

InputManager.is_frame_hovering = function (self)
	-- function 51
	return self._frame_hovering
end

InputManager.set_showing_tooltip = function (self, arg_52_1)
	-- function 52
	self._showing_tooltip = arg_52_1
end

InputManager.is_showing_tooltip = function (self)
	-- function 53
	return self._showing_tooltip
end

InputManager.add_keymaps_data = function (self, arg_54_1, arg_54_2)
	-- function 54
	local stored_keymaps_data = self.stored_keymaps_data
	local controls = PlayerData.controls

	fassert(not stored_keymaps_data[arg_54_2], "[InputManager] - keymaps already stored with name: %s", arg_54_2)

	local tbl = {}

	stored_keymaps_data[arg_54_2] = tbl

	for k, v in pairs(arg_54_1) do
		local setup_keymaps, var_54_4 = self:setup_keymaps(v)

		tbl[k] = {
			keymaps = setup_keymaps,
			default_data_types = var_54_4
		}
	end

	if not controls then
		self:apply_saved_keymaps(arg_54_2)
	end

	fn("[InputManager] - Add keymaps data for name: %s", arg_54_2)
end

InputManager.update_keymaps_data = function (self, arg_55_1, arg_55_2)
	-- function 55
	local var_55_0 = self.stored_keymaps_data[arg_55_2]

	fassert(var_55_0, "[InputManager] - no keymaps stored with name: %s", arg_55_2)

	for k, v in pairs(arg_55_1) do
		local var_55_1 = var_55_0[k]
		local setup_keymaps, var_55_3 = self:setup_keymaps(v)

		table.merge_recursive(var_55_1.keymaps, setup_keymaps)
		table.merge_recursive(var_55_1.default_data_types, var_55_3)
	end

	fn("[InputManager] - Updated keymaps data for name: %s", arg_55_2)
end

InputManager.keymaps_data = function (self, arg_56_1)
	-- function 56
	local var_56_0 = self.stored_keymaps_data[arg_56_1]

	fassert(var_56_0, "[InputManager] - No keymaps found by name %s", arg_56_1)

	return var_56_0
end

InputManager.setup_keymaps = function (arg_57_0, arg_57_1)
	-- function 57
	local input_map_types = InputAux.input_map_types
	local input_device_mapping = InputAux.input_device_mapping
	local tbl = {}
	local clone = table.clone(arg_57_1)

	for k, v in pairs(clone) do
		local count = #v

		v.n = count

		assert(count / 3 == math.floor(count / 3), "An input mapping must be paired by three arguments: device-type, button-name, operation")

		local var_57_5

		for k_2 = 1, count, 3 do
			local var_57_6 = v[k_2]
			local var_57_7 = input_device_mapping[var_57_6][1]
			local var_57_8 = input_map_types[v[k_2 + 2]]

			assert(not var_57_5 and var_57_5 == var_57_8, "Bad input map combination for %q. Combinations must have the same result (%s vs %s)", k, var_57_8, var_57_5)

			var_57_5 = var_57_8

			local var_57_9
			local var_57_10 = v[k_2 + 2]
			local var_57_11 = v[k_2 + 1]

			if var_57_11 ~= UNASSIGNED_KEY then
				if not IS_CONSOLE then
					if var_57_10 == "axis" then
						var_57_9 = var_57_7.axis_index(var_57_11)
					else
						var_57_9 = var_57_7.button_index(var_57_11)
					end

					if not var_57_9 then
						printf("No such %q %q in input device type %q.", tostring(var_57_10), var_57_11, var_57_6)
					end
				elseif var_57_10 == "axis" then
					var_57_9 = var_57_7.axis_index(var_57_11)

					assert(var_57_9, string.format("No such axis %q in input device type %q.", var_57_11, var_57_6))
				else
					var_57_9 = var_57_7.button_index(var_57_11)

					assert(var_57_9, string.format("No such key %q in input device type %q.", var_57_11, var_57_6))
				end
			end

			v[k_2 + 1] = var_57_9 or UNASSIGNED_KEY
		end

		tbl[k] = var_57_5
	end

	return clone, tbl
end

InputManager.clear_keybinding = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local keymaps_data = self:keymaps_data(arg_58_1)

	assert(keymaps_data, "No keymaps data found under table_name: %s", arg_58_1)

	local var_58_1 = keymaps_data[arg_58_2]

	assert(var_58_1, "No keymaps data found under table_key: %s", arg_58_2)

	local keymaps = var_58_1.keymaps

	assert(keymaps, "No keymaps found under %s with table_key: %s", arg_58_1, arg_58_2)

	local var_58_3 = keymaps[arg_58_3]

	assert(var_58_3, "No such keymap name %s", arg_58_3)

	var_58_3[2] = UNASSIGNED_KEY
end

InputManager.change_keybinding = function (self, arg_59_1, arg_59_2, arg_59_3, ...)
	-- function 59
	local keymaps_data = self:keymaps_data(arg_59_1)

	assert(keymaps_data, "No keymaps data found under table_name: %s", arg_59_1)

	local var_59_1 = keymaps_data[arg_59_2]

	assert(var_59_1, "No keymaps data found under table_key: %s", arg_59_2)

	local keymaps = var_59_1.keymaps

	assert(keymaps, "No keymaps found under %s with table_key: %s", arg_59_1, arg_59_2)

	local var_59_3 = keymaps[arg_59_3]

	assert(var_59_3, "No such keymap name %s", arg_59_3)

	local var_59_4 = select("#", ...)

	assert(var_59_4 / 2 == math.floor(var_59_4 / 2), "Bad amount of arguments (%d) to :change_keybinding(). Must supply input device type and keymap button index type for every key.", var_59_4)

	local num = 0

	for i = 1, var_59_4, 2 do
		local var_59_6, var_59_7 = select(i, ...)

		assert(type(var_59_6) == "number", "New button index must be a number.")
		fassert(InputAux.input_device_mapping[var_59_7], "No such input device type %s", var_59_7)

		var_59_3[num + 1] = var_59_7
		var_59_3[num + 2] = var_59_6
		var_59_3[num + 3] = var_59_3[3]
		num = num + 3
	end

	for j = num + 1, #var_59_3 do
		var_59_3[j] = nil
	end

	var_59_3.n = num
end

InputManager.add_keybinding = function (self, arg_60_1, arg_60_2, arg_60_3, ...)
	-- function 60
	assert(type(new_button_index) == "number", "New button index must be a number.")

	local keymaps_data = self:keymaps_data(arg_60_1)

	assert(keymaps_data, "No keymaps data found under table_name: %s", arg_60_1)

	local var_60_1 = keymaps_data[arg_60_2]

	assert(var_60_1, "No keymaps data found under table_key: %s", arg_60_2)

	local keymaps = var_60_1.keymaps

	assert(keymaps, "No keymaps found under %s with table_key: %s", arg_60_1, arg_60_2)

	local var_60_3 = keymaps[arg_60_3]

	assert(var_60_3, "No such keymap name %s", arg_60_3)

	local var_60_4 = select("#", ...)

	assert(var_60_4 / 3 == math.floor(var_60_4 / 3), "Bad amount of arguments (%d) to :add_keybinding(). Must supply input device type, keymap button index and keymap type for every key.", var_60_4)

	local tbl = {
		n = 0
	}

	keymaps[arg_60_3] = tbl

	for i = 1, var_60_4 / 3 do
		local n = tbl.n
		local var_60_7 = select(i * 3 - 2, ...)
		local var_60_8 = select(i * 3 - 1, ...)
		local var_60_9 = select(i * 3, ...)

		assert(type(var_60_8) == "number", "New button index must be a number.")

		local var_60_10 = InputAux.input_device_mapping[var_60_7]

		assert(var_60_10, "No such input device type %s", var_60_7)

		local var_60_11 = var_60_10[1]

		if var_60_9 ~= "axis" then
			assert(var_60_11.button_name(var_60_8), "No such button index %d in device type %s", var_60_8, var_60_7)
		else
			assert(var_60_11.axis_name(var_60_8), "No such axis index %d in device type %s", var_60_8, var_60_7)
		end

		assert(InputAux.input_map_types[var_60_9], "Bad keymap type %s to add_keybinding() at vararg %d", var_60_9, i * 3)

		tbl[n + 1] = var_60_7
		tbl[n + 2] = var_60_8
		tbl[n + 3] = var_60_9
		tbl.n = n + 3
	end
end
