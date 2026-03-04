-- chunkname: @scripts/managers/input/input_manager.lua

require("scripts/managers/input/input_service")
require("scripts/managers/input/play_recording_input_device")
require("scripts/managers/input/network_input_device")
require("scripts/managers/input/input_aux")
require("scripts/managers/input/input_filters")
require("scripts/managers/input/input_debugger")
require("scripts/managers/input/input_stack_settings")

local var_0_0 = most_recent_input_device or IS_WINDOWS and Keyboard or Pad1
local var_0_1 = most_recent_input_device_type or IS_WINDOWS and "keyboard" or "gamepad"
local var_0_2 = Development.parameter("disable_gamepad")

local function var_0_3(...)
	if script_data.input_debug_filters then
		printf(...)
	end
end

InputManager = class(InputManager)

function InputManager.init(arg_2_0)
	arg_2_0.platform = PLATFORM
	arg_2_0.input_services = {}
	arg_2_0.input_devices = {}
	arg_2_0.stored_keymaps_data = {}
	arg_2_0.stored_filters_data = {}
	arg_2_0.blocked_gamepad_services = {}
	arg_2_0._device_input_groups = {}
	arg_2_0._active_input_group_id = nil

	local var_2_0 = InputAux.input_device_mapping.gamepad

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		iter_2_1.set_down_threshold(0.25)
	end
end

function InputManager.destroy(arg_3_0)
	arg_3_0.input_services = nil
	arg_3_0.input_devices = nil
end

function InputManager.initialize_device(arg_4_0, arg_4_1, arg_4_2)
	if var_0_2 and arg_4_1 == "gamepad" then
		return
	end

	if IS_CONSOLE and (arg_4_1 == "keyboard" or arg_4_1 == "mouse") and not GameSettingsDevelopment.allow_keyboard_mouse then
		return
	end

	local var_4_0 = InputAux.input_device_mapping[arg_4_1]

	assert(var_4_0, "No such input device type: %s", arg_4_1)

	if arg_4_1 == "gamepad" then
		for iter_4_0, iter_4_1 in ipairs(var_4_0) do
			assert(not arg_4_0.input_devices[iter_4_1], "Input device already initialized %s %d.", arg_4_1, iter_4_0)

			arg_4_0.input_devices[iter_4_1] = {
				pressed = {},
				released = {},
				held = {},
				soft_button = {},
				num_buttons = iter_4_1.num_buttons(),
				axis = {},
				num_axes = iter_4_1.num_axes(),
				blocked_access = {},
				consumed_input = {}
			}
		end
	else
		arg_4_2 = arg_4_2 or 1

		local var_4_1 = var_4_0[arg_4_2]

		assert(var_4_1, "No input device %s with index %d", arg_4_1, arg_4_2)
		assert(not arg_4_0.input_devices[var_4_1], "Input device already initialized %s %d.", arg_4_1, arg_4_2)

		arg_4_0.input_devices[var_4_1] = {
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

function InputManager.remove_all_devices(arg_5_0, arg_5_1)
	local var_5_0 = InputAux.input_device_mapping[arg_5_1]

	if not var_5_0 then
		return
	end

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		for iter_5_2, iter_5_3 in pairs(arg_5_0.input_services) do
			iter_5_3:unmap_device(arg_5_1, iter_5_1)
		end

		arg_5_0.input_devices[iter_5_1] = nil
	end

	for iter_5_4 = #var_5_0, 1, -1 do
		local var_5_1 = var_5_0[iter_5_4]

		InputAux.remove_device(arg_5_1, var_5_1)
	end
end

function InputManager.set_exclusive_gamepad(arg_6_0, arg_6_1)
	local var_6_0 = "gamepad"

	arg_6_0:remove_all_devices(var_6_0)
	InputAux.add_device(var_6_0, arg_6_1)
	arg_6_0:initialize_device(var_6_0)

	local var_6_1 = arg_6_0.input_devices[arg_6_1]

	for iter_6_0, iter_6_1 in pairs(arg_6_0.input_services) do
		iter_6_1:map_device(var_6_0, arg_6_1, arg_6_0.input_devices[arg_6_1])

		if arg_6_0.blocked_gamepad_services[iter_6_0] then
			var_6_1.blocked_access[iter_6_0] = true
		end
	end
end

function InputManager.set_all_gamepads_available(arg_7_0)
	local var_7_0 = "gamepad"

	arg_7_0:remove_all_devices(var_7_0)

	local var_7_1 = {
		rawget(_G, "Pad1"),
		rawget(_G, "Pad2"),
		rawget(_G, "Pad3"),
		rawget(_G, "Pad4"),
		rawget(_G, "Pad5"),
		rawget(_G, "Pad6"),
		rawget(_G, "Pad7"),
		rawget(_G, "Pad8")
	}

	for iter_7_0, iter_7_1 in ipairs(var_7_1) do
		local var_7_2 = var_7_1[iter_7_0]

		InputAux.add_device(var_7_0, var_7_2)
	end

	arg_7_0:initialize_device(var_7_0)

	for iter_7_2, iter_7_3 in ipairs(var_7_1) do
		local var_7_3 = arg_7_0.input_devices[iter_7_3]

		for iter_7_4, iter_7_5 in pairs(arg_7_0.input_services) do
			iter_7_5:map_device(var_7_0, iter_7_3, arg_7_0.input_devices[iter_7_3])

			if arg_7_0.blocked_gamepad_services[iter_7_4] then
				var_7_3.blocked_access[iter_7_4] = true
			end
		end
	end
end

function InputManager.block_device_except_service(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if var_0_2 and (arg_8_2 == "gamepad" or arg_8_2 == "ps_pad") then
		return
	end

	arg_8_3 = arg_8_3 or 1

	local var_8_0 = InputAux.input_device_mapping[arg_8_2]

	if not var_8_0 then
		return
	end

	if arg_8_2 == "gamepad" or arg_8_2 == "ps_pad" then
		for iter_8_0, iter_8_1 in ipairs(var_8_0) do
			local var_8_1 = arg_8_0.input_devices[iter_8_1]

			for iter_8_2, iter_8_3 in pairs(arg_8_0.input_services) do
				if iter_8_3.block_reasons and iter_8_3.block_reasons[arg_8_4] then
					var_8_1.blocked_access[iter_8_2] = true

					iter_8_3:set_blocked(true)
				elseif not iter_8_3.block_reasons then
					var_8_1.blocked_access[iter_8_2] = true

					iter_8_3:set_blocked(true)
				end

				arg_8_0.blocked_gamepad_services[iter_8_2] = true
			end

			if arg_8_1 and var_8_1.blocked_access[arg_8_1] then
				arg_8_0.input_services[arg_8_1]:set_blocked(nil)

				var_8_1.blocked_access[arg_8_1] = nil
			end

			if arg_8_1 then
				arg_8_0.blocked_gamepad_services[arg_8_1] = nil
			end
		end
	else
		local var_8_2 = var_8_0[arg_8_3]
		local var_8_3 = arg_8_0.input_devices[var_8_2]

		if var_8_3 then
			for iter_8_4, iter_8_5 in pairs(arg_8_0.input_services) do
				if iter_8_5.block_reasons and iter_8_5.block_reasons[arg_8_4] then
					var_8_3.blocked_access[iter_8_4] = true

					iter_8_5:set_blocked(true)
				elseif not iter_8_5.block_reasons then
					var_8_3.blocked_access[iter_8_4] = true

					iter_8_5:set_blocked(true)
				end
			end

			if arg_8_1 and var_8_3.blocked_access[arg_8_1] then
				arg_8_0.input_services[arg_8_1]:set_blocked(nil)

				var_8_3.blocked_access[arg_8_1] = nil
			end
		end
	end

	if IS_WINDOWS and arg_8_2 == "gamepad" then
		arg_8_0:block_device_except_service(arg_8_1, "ps_pad", arg_8_3, arg_8_4)
	end
end

function InputManager.device_unblock_all_services(arg_9_0, arg_9_1, arg_9_2)
	if var_0_2 and (arg_9_1 == "gamepad" or arg_9_1 == "ps_pad") then
		return
	end

	local var_9_0 = InputAux.input_device_mapping[arg_9_1]

	if not var_9_0 then
		return
	end

	if arg_9_1 == "gamepad" or arg_9_1 == "ps_pad" then
		for iter_9_0, iter_9_1 in ipairs(var_9_0) do
			local var_9_1 = arg_9_0.input_devices[iter_9_1]
			local var_9_2 = arg_9_0.input_services

			for iter_9_2, iter_9_3 in pairs(var_9_1.blocked_access) do
				var_9_2[iter_9_2]:set_blocked(nil)

				var_9_1.blocked_access[iter_9_2] = nil
			end
		end

		arg_9_0.blocked_gamepad_services = {}
	else
		arg_9_2 = arg_9_2 or 1

		local var_9_3 = var_9_0[arg_9_2]
		local var_9_4 = arg_9_0.input_devices[var_9_3]

		if var_9_4 then
			local var_9_5 = arg_9_0.input_services

			for iter_9_4, iter_9_5 in pairs(var_9_4.blocked_access) do
				var_9_5[iter_9_4]:set_blocked(nil)

				var_9_4.blocked_access[iter_9_4] = nil
			end
		end
	end

	if IS_WINDOWS and arg_9_1 == "gamepad" then
		arg_9_0:device_unblock_all_services("ps_pad", arg_9_2)
	end
end

function InputManager.device_block_service(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if var_0_2 and (arg_10_1 == "gamepad" or arg_10_1 == "ps_pad") then
		return
	end

	local var_10_0 = arg_10_0.input_services[arg_10_3]

	if var_10_0.block_reasons and not var_10_0.block_reasons[arg_10_4] then
		return
	end

	local var_10_1 = InputAux.input_device_mapping[arg_10_1]

	if not var_10_1 then
		return
	end

	if arg_10_1 == "gamepad" then
		for iter_10_0, iter_10_1 in ipairs(var_10_1) do
			arg_10_0.input_devices[iter_10_1].blocked_access[arg_10_3] = true

			var_10_0:set_blocked(true)
		end

		arg_10_0.blocked_gamepad_services[arg_10_3] = true
	else
		arg_10_2 = arg_10_2 or 1

		local var_10_2 = var_10_1[arg_10_2]
		local var_10_3 = arg_10_0.input_devices[var_10_2]

		if var_10_3 then
			var_10_3.blocked_access[arg_10_3] = true

			var_10_0:set_blocked(true)
		end
	end

	if IS_WINDOWS and arg_10_1 == "gamepad" then
		arg_10_0:device_block_service("ps_pad", arg_10_2, arg_10_3, arg_10_4)
	end
end

function InputManager.device_unblock_service(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if var_0_2 and (arg_11_1 == "gamepad" or arg_11_1 == "ps_pad") then
		return
	end

	local var_11_0 = InputAux.input_device_mapping[arg_11_1]

	if not var_11_0 then
		return
	end

	if arg_11_1 == "gamepad" then
		for iter_11_0, iter_11_1 in ipairs(var_11_0) do
			arg_11_0.input_devices[iter_11_1].blocked_access[arg_11_3] = nil

			arg_11_0.input_services[arg_11_3]:set_blocked(nil)
		end

		arg_11_0.blocked_gamepad_services[arg_11_3] = nil
	else
		arg_11_2 = arg_11_2 or 1

		local var_11_1 = var_11_0[arg_11_2]
		local var_11_2 = arg_11_0.input_devices[var_11_1]

		if var_11_2 then
			var_11_2.blocked_access[arg_11_3] = nil

			arg_11_0.input_services[arg_11_3]:set_blocked(nil)
		end
	end

	if IS_WINDOWS and arg_11_1 == "gamepad" then
		arg_11_0:device_unblock_service("ps_pad", arg_11_2, arg_11_3)
	end
end

function InputManager.get_unblocked_services(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = 0

	for iter_12_0, iter_12_1 in pairs(arg_12_0.input_services) do
		if not iter_12_1:is_blocked() then
			var_12_0 = var_12_0 + 1
			arg_12_3[var_12_0] = iter_12_0
		end
	end

	return var_12_0
end

function InputManager.get_blocked_services(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = 0

	for iter_13_0, iter_13_1 in pairs(arg_13_0.input_services) do
		if iter_13_1:is_blocked() then
			var_13_0 = var_13_0 + 1
			arg_13_3[var_13_0] = iter_13_0
		end
	end

	return var_13_0
end

function InputManager.device_block_services(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_2 = arg_14_2 or 1

	for iter_14_0 = 1, arg_14_4 do
		local var_14_0 = arg_14_3[iter_14_0]

		arg_14_0:device_block_service(arg_14_1, arg_14_2, var_14_0, arg_14_5)
	end
end

function InputManager.device_unblock_services(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	arg_15_2 = arg_15_2 or 1

	for iter_15_0 = 1, arg_15_4 do
		local var_15_0 = arg_15_3[iter_15_0]

		arg_15_0:device_unblock_service(arg_15_1, arg_15_2, var_15_0)
	end
end

function InputManager.capture_input(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
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

	for iter_16_0 = 1, #arg_16_1 do
		arg_16_0:device_unblock_service(arg_16_1[iter_16_0], arg_16_2, arg_16_3)
	end

	local var_16_0 = arg_16_0:_find_service_input_group(arg_16_3)

	if var_16_0 then
		local var_16_1 = arg_16_0._device_input_groups
		local var_16_2 = var_16_1[var_16_0]

		if not var_16_2 then
			var_16_2 = {}
			var_16_1[var_16_0] = var_16_2
		end

		local var_16_3 = var_16_2[arg_16_3]

		if not var_16_3 then
			var_16_3 = {}
			var_16_2[arg_16_3] = var_16_3
		end

		if not table.contains(var_16_3, arg_16_4) then
			local var_16_4 = table.is_empty(var_16_3)

			table.insert(var_16_3, arg_16_4)

			if var_16_4 then
				arg_16_0:_refresh_active_input_group()
			end
		end
	end
end

function InputManager.release_input(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
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

	for iter_17_0 = 1, #arg_17_1 do
		arg_17_0:device_block_service(arg_17_1[iter_17_0], arg_17_2, arg_17_3, arg_17_5)
	end

	local var_17_0 = arg_17_0:_find_service_input_group(arg_17_3)

	if var_17_0 then
		local var_17_1 = arg_17_0._device_input_groups
		local var_17_2 = var_17_1[var_17_0]

		if not var_17_2 then
			return
		end

		local var_17_3 = var_17_2[arg_17_3]

		if not var_17_3 then
			return
		end

		if table.find(var_17_3, arg_17_4) then
			table.remove(var_17_3, table.find(var_17_3, arg_17_4))
		end

		if table.is_empty(var_17_3) then
			var_17_2[arg_17_3] = nil

			if table.is_empty(var_17_2) then
				var_17_1[var_17_0] = nil
			end

			arg_17_0:_refresh_active_input_group()
		end
	end
end

function InputManager._find_service_input_group(arg_18_0, arg_18_1)
	local var_18_0 = InputServiceToGroupMap[arg_18_1]

	if not var_18_0 then
		return nil
	end

	return InputStackSettings[var_18_0].group_name
end

function InputManager._refresh_active_input_group(arg_19_0)
	local var_19_0 = arg_19_0._device_input_groups
	local var_19_1 = arg_19_0:_find_active_input_group_id(var_19_0)

	arg_19_0:_capture_input_group(var_19_1)
end

function InputManager._capture_input_group(arg_20_0, arg_20_1)
	arg_20_0._active_input_group_id = arg_20_1

	local var_20_0 = arg_20_0.input_services

	if arg_20_1 and InputStackSettings[arg_20_1] then
		for iter_20_0, iter_20_1 in pairs(var_20_0) do
			local var_20_1 = InputServiceToGroupMap[iter_20_0]
			local var_20_2 = var_20_1 == nil or arg_20_1 < var_20_1

			iter_20_1:set_disabled_input_group(var_20_2)
		end
	else
		for iter_20_2, iter_20_3 in pairs(var_20_0) do
			iter_20_3:set_disabled_input_group(nil)
		end
	end
end

function InputManager._update_service_input_group(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_1 then
		return
	end

	local var_21_0 = arg_21_2 and InputStackSettings[arg_21_2]

	if not var_21_0 then
		arg_21_1:set_disabled_input_group(nil)
	else
		local var_21_1 = table.contains(var_21_0.services, arg_21_1.name)

		arg_21_1:set_disabled_input_group(not var_21_1)
	end
end

function InputManager._find_active_input_group_id(arg_22_0, arg_22_1)
	for iter_22_0 = 1, #InputStackSettings do
		if arg_22_1[InputStackSettings[iter_22_0].group_name] then
			return iter_22_0
		end
	end

	return nil
end

function InputManager.create_input_service(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = rawget(_G, arg_23_2)

	fassert(var_23_0, "[InputManager] - No keymaps found for %s", arg_23_2)

	if not arg_23_0.stored_keymaps_data[arg_23_2] then
		arg_23_0:add_keymaps_data(var_23_0, arg_23_2)
	end

	if arg_23_3 then
		local var_23_1 = rawget(_G, arg_23_3)

		fassert(var_23_1, "[InputManager] - No filters found for %s", arg_23_3)

		if not arg_23_0.stored_filters_data[arg_23_3] then
			arg_23_0:add_filters_data(var_23_1, arg_23_3)
		end
	end

	local var_23_2 = InputService:new(arg_23_1, arg_23_2, arg_23_3, arg_23_4)

	arg_23_0.input_services[arg_23_1] = var_23_2

	arg_23_0:_update_service_input_group(var_23_2, arg_23_0._active_input_group_id)
end

function InputManager.get_input_service(arg_24_0, arg_24_1)
	return arg_24_0.input_services[arg_24_1]
end

function InputManager.get_active_input_service_by_device(arg_25_0, arg_25_1)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.input_services) do
		if not iter_25_1:is_blocked() then
			local var_25_0 = iter_25_1.mapped_devices

			if var_25_0 then
				for iter_25_2, iter_25_3 in pairs(var_25_0) do
					if iter_25_2 == arg_25_1 then
						return iter_25_1
					end
				end
			end
		end
	end
end

function InputManager.map_device_to_service(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if var_0_2 and (arg_26_2 == "gamepad" or arg_26_2 == "ps_pad") then
		return
	end

	if IS_CONSOLE and (arg_26_2 == "keyboard" or arg_26_2 == "mouse") and not GameSettingsDevelopment.allow_keyboard_mouse then
		return
	end

	local var_26_0 = arg_26_0.input_services[arg_26_1]

	assert(var_26_0, "No such input service name: %s", arg_26_1)

	local var_26_1 = InputAux.input_device_mapping[arg_26_2]

	assert(var_26_1, "No such input device type: %s", arg_26_2)

	if arg_26_2 == "gamepad" or arg_26_2 == "ps_pad" then
		for iter_26_0, iter_26_1 in ipairs(var_26_1) do
			local var_26_2 = arg_26_0.input_devices[iter_26_1]

			var_26_0:map_device(arg_26_2, iter_26_1, var_26_2)
		end
	else
		arg_26_3 = arg_26_3 or 1

		local var_26_3 = var_26_1[arg_26_3]

		assert(var_26_3, "No input device %s with index %d", arg_26_2, arg_26_3)

		local var_26_4 = arg_26_0.input_devices[var_26_3]

		var_26_0:map_device(arg_26_2, var_26_3, var_26_4)
	end

	if IS_WINDOWS and arg_26_2 == "gamepad" then
		arg_26_0:map_device_to_service(arg_26_1, "ps_pad", arg_26_3)
	end
end

function InputManager.update(arg_27_0, arg_27_1, arg_27_2)
	InputAux.default_values_for_types.Vector3 = Vector3.zero()
	arg_27_0._hovering = arg_27_0._frame_hovering
	arg_27_0._frame_hovering = false
	arg_27_0._showing_tooltip = false

	arg_27_0:update_devices(arg_27_1, arg_27_2)
end

local var_0_4 = {
	left = true,
	right = true
}

function InputManager.update_devices(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.input_devices

	arg_28_0.any_device_input_pressed = nil
	arg_28_0.any_device_input_released = nil
	arg_28_0.any_device_input_axis_moved = nil

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		local var_28_1 = iter_28_1.pressed
		local var_28_2 = iter_28_1.held
		local var_28_3 = iter_28_1.soft_button
		local var_28_4 = iter_28_0.type() == "sce_pad"
		local var_28_5 = iter_28_1.num_buttons - 1

		for iter_28_2 = 0, var_28_5 do
			local var_28_6 = iter_28_0.button(iter_28_2)

			var_28_3[iter_28_2] = var_28_6
			var_28_2[iter_28_2] = var_28_6 > 0.5
		end

		local var_28_7 = iter_28_0.any_pressed()

		if var_28_7 then
			for iter_28_3 = 0, var_28_5 do
				var_28_1[iter_28_3] = iter_28_0.pressed(iter_28_3)
			end
		else
			for iter_28_4 = 0, var_28_5 do
				var_28_1[iter_28_4] = false
			end
		end

		local var_28_8 = iter_28_0.any_released()
		local var_28_9 = iter_28_1.released

		if var_28_8 then
			for iter_28_5 = 0, var_28_5 do
				var_28_9[iter_28_5] = iter_28_0.released(iter_28_5)
			end
		else
			for iter_28_6 = 0, var_28_5 do
				var_28_9[iter_28_6] = false
			end
		end

		local var_28_10 = false
		local var_28_11 = iter_28_1.axis

		for iter_28_7 = 0, iter_28_1.num_axes - 1 do
			var_28_11[iter_28_7] = iter_28_0.axis(iter_28_7)

			local var_28_12 = iter_28_0.axis_name(iter_28_7)

			if IS_PS4 or var_28_4 then
				if var_0_4[var_28_12] and Vector3.length(var_28_11[iter_28_7]) ~= 0 then
					var_28_10 = true
				end
			elseif iter_28_0.axis_name(iter_28_7) ~= "cursor" and Vector3.length(var_28_11[iter_28_7]) ~= 0 then
				var_28_10 = true
			end
		end

		if var_28_7 then
			arg_28_0.any_device_input_pressed = true
		end

		if var_28_8 then
			arg_28_0.any_device_input_released = true
		end

		if var_28_10 then
			arg_28_0.any_device_input_axis_moved = true
		end

		if var_28_7 or var_28_10 then
			arg_28_0.last_active_time = arg_28_2

			if var_0_0 ~= iter_28_0 then
				var_0_0 = iter_28_0
				var_0_1 = InputAux.input_device_type_lookup[iter_28_0]

				local var_28_13 = var_0_0.type()
				local var_28_14 = iter_28_0._name
				local var_28_15 = var_28_14 == "Keyboard" or var_28_14 == "Mouse"

				ShowCursorStack.render_cursor(var_28_15)
			end
		end

		table.clear(iter_28_1.consumed_input)
	end
end

function InputManager.get_service(arg_29_0, arg_29_1)
	if arg_29_0.input_services then
		return arg_29_0.input_services[arg_29_1]
	else
		return FAKE_INPUT_SERVICE
	end
end

local var_0_5 = {
	active = function()
		return false
	end
}

function InputManager.get_device(arg_31_0, arg_31_1, arg_31_2)
	if var_0_2 and arg_31_1 == "gamepad" then
		return var_0_5
	end

	local var_31_0 = InputAux.input_device_mapping[arg_31_1]

	assert(var_31_0, "No such input device type: %s", arg_31_1)

	arg_31_2 = arg_31_2 or 1

	return var_31_0[arg_31_2]
end

function InputManager.any_input_pressed(arg_32_0)
	return arg_32_0.any_device_input_pressed
end

function InputManager.any_input_released(arg_33_0)
	return arg_33_0.any_device_input_released
end

function InputManager.any_input_axis_moved(arg_34_0)
	return arg_34_0.any_device_input_axis_moved
end

function InputManager.get_most_recent_device(arg_35_0)
	return var_0_0
end

function InputManager.get_most_recent_device_type(arg_36_0)
	return var_0_1
end

function InputManager.is_device_active(arg_37_0, arg_37_1)
	if arg_37_1 == "gamepad" and var_0_2 then
		return false
	end

	return var_0_1 == arg_37_1
end

function InputManager.add_filters_data(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.stored_filters_data

	fassert(not var_38_0[arg_38_2], "[InputManager] - filters already stored with name: %s", arg_38_2)

	local var_38_1 = {}

	for iter_38_0, iter_38_1 in pairs(arg_38_1) do
		var_38_1[iter_38_0] = arg_38_0:setup_filters(iter_38_1)
	end

	var_38_0[arg_38_2] = var_38_1

	var_0_3("[InputManager] - Add filters data for name: %s", arg_38_2)
end

function InputManager.update_filters_data(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0.stored_filters_data
	local var_39_1 = var_39_0[arg_39_2]

	fassert(var_39_0[arg_39_2], "[InputManager] - no filters stored with name: %s", arg_39_2)

	for iter_39_0, iter_39_1 in pairs(arg_39_1) do
		local var_39_2 = var_39_1[iter_39_0]
		local var_39_3 = arg_39_0:setup_filters(iter_39_1)

		table.merge_recursive(var_39_2, var_39_3)
	end

	var_0_3("[InputManager] - Updated filters data for name: %s", arg_39_2)
end

function InputManager.setup_filters(arg_40_0, arg_40_1)
	local var_40_0 = {}

	if arg_40_1 then
		for iter_40_0, iter_40_1 in pairs(arg_40_1) do
			local var_40_1 = iter_40_1.filter_type

			var_40_0[iter_40_0] = {
				function_data = InputFilters[var_40_1].init(iter_40_1) or true,
				filter_output = iter_40_0,
				filter_type = var_40_1,
				filter_function = InputFilters[var_40_1].update
			}
		end
	end

	return var_40_0
end

function InputManager.filters_data(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.stored_filters_data[arg_41_1]

	fassert(var_41_0, "[InputManager] - No filters found by name %s", arg_41_1)

	return var_41_0
end

function InputManager.apply_saved_keymaps(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.stored_keymaps_data

	if IS_WINDOWS or IS_XB1 or IS_LINUX then
		local var_42_1 = PlayerData.controls or {}

		for iter_42_0, iter_42_1 in pairs(var_42_1) do
			if (not arg_42_1 or arg_42_1 == iter_42_0) and var_42_0[iter_42_0] then
				arg_42_0:update_keymaps_data(iter_42_1, iter_42_0)
			end
		end
	end

	local var_42_2 = Application.user_setting("gamepad_layout")

	if var_42_2 then
		local var_42_3 = Application.user_setting("gamepad_left_handed")
		local var_42_4

		if var_42_3 then
			var_42_4 = AlternatateGamepadKeymapsLayoutsLeftHanded
		else
			var_42_4 = AlternatateGamepadKeymapsLayouts
		end

		local var_42_5 = var_42_4[var_42_2]

		for iter_42_2, iter_42_3 in pairs(var_42_5) do
			if (not arg_42_1 or arg_42_1 == iter_42_2) and var_42_0[iter_42_2] then
				arg_42_0:update_keymaps_data(iter_42_3, iter_42_2)
			end
		end
	end
end

function InputManager.set_hovering(arg_43_0, arg_43_1)
	if arg_43_1 and not arg_43_0._hovering then
		-- block empty
	end

	arg_43_0._hovering = arg_43_0._hovering or arg_43_1
	arg_43_0._frame_hovering = arg_43_0._frame_hovering or arg_43_1
end

local var_0_6 = {}

function InputManager.set_gamepad_cursor_pos(arg_44_0, arg_44_1, arg_44_2)
	var_0_6[1] = arg_44_1
	var_0_6[2] = arg_44_2
end

function InputManager.center_gamepad_cursor_pos(arg_45_0)
	var_0_6[1] = 960
	var_0_6[2] = 540
end

function InputManager.get_gamepad_cursor_pos(arg_46_0)
	local var_46_0 = var_0_6[1]
	local var_46_1 = var_0_6[2]

	table.clear(var_0_6)

	return var_46_0, var_46_1
end

function InputManager.disable_gamepad_cursor(arg_47_0)
	arg_47_0._gamepad_cursor_active = false
end

function InputManager.enable_gamepad_cursor(arg_48_0)
	arg_48_0._gamepad_cursor_active = true
end

function InputManager.gamepad_cursor_active(arg_49_0)
	return arg_49_0._gamepad_cursor_active
end

function InputManager.is_hovering(arg_50_0)
	return arg_50_0._hovering
end

function InputManager.is_frame_hovering(arg_51_0)
	return arg_51_0._frame_hovering
end

function InputManager.set_showing_tooltip(arg_52_0, arg_52_1)
	arg_52_0._showing_tooltip = arg_52_1
end

function InputManager.is_showing_tooltip(arg_53_0)
	return arg_53_0._showing_tooltip
end

function InputManager.add_keymaps_data(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0.stored_keymaps_data
	local var_54_1 = PlayerData.controls

	fassert(not var_54_0[arg_54_2], "[InputManager] - keymaps already stored with name: %s", arg_54_2)

	local var_54_2 = {}

	var_54_0[arg_54_2] = var_54_2

	for iter_54_0, iter_54_1 in pairs(arg_54_1) do
		local var_54_3, var_54_4 = arg_54_0:setup_keymaps(iter_54_1)

		var_54_2[iter_54_0] = {
			keymaps = var_54_3,
			default_data_types = var_54_4
		}
	end

	if var_54_1 then
		arg_54_0:apply_saved_keymaps(arg_54_2)
	end

	var_0_3("[InputManager] - Add keymaps data for name: %s", arg_54_2)
end

function InputManager.update_keymaps_data(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = arg_55_0.stored_keymaps_data[arg_55_2]

	fassert(var_55_0, "[InputManager] - no keymaps stored with name: %s", arg_55_2)

	for iter_55_0, iter_55_1 in pairs(arg_55_1) do
		local var_55_1 = var_55_0[iter_55_0]
		local var_55_2, var_55_3 = arg_55_0:setup_keymaps(iter_55_1)

		table.merge_recursive(var_55_1.keymaps, var_55_2)
		table.merge_recursive(var_55_1.default_data_types, var_55_3)
	end

	var_0_3("[InputManager] - Updated keymaps data for name: %s", arg_55_2)
end

function InputManager.keymaps_data(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.stored_keymaps_data[arg_56_1]

	fassert(var_56_0, "[InputManager] - No keymaps found by name %s", arg_56_1)

	return var_56_0
end

function InputManager.setup_keymaps(arg_57_0, arg_57_1)
	local var_57_0 = InputAux.input_map_types
	local var_57_1 = InputAux.input_device_mapping
	local var_57_2 = {}
	local var_57_3 = table.clone(arg_57_1)

	for iter_57_0, iter_57_1 in pairs(var_57_3) do
		local var_57_4 = #iter_57_1

		iter_57_1.n = var_57_4

		assert(var_57_4 / 3 == math.floor(var_57_4 / 3), "An input mapping must be paired by three arguments: device-type, button-name, operation")

		local var_57_5

		for iter_57_2 = 1, var_57_4, 3 do
			local var_57_6 = iter_57_1[iter_57_2]
			local var_57_7 = var_57_1[var_57_6][1]
			local var_57_8 = var_57_0[iter_57_1[iter_57_2 + 2]]

			assert(not var_57_5 or var_57_5 == var_57_8, "Bad input map combination for %q. Combinations must have the same result (%s vs %s)", iter_57_0, var_57_8, var_57_5)

			var_57_5 = var_57_8

			local var_57_9
			local var_57_10 = iter_57_1[iter_57_2 + 2]
			local var_57_11 = iter_57_1[iter_57_2 + 1]

			if var_57_11 ~= UNASSIGNED_KEY then
				if IS_CONSOLE then
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

			iter_57_1[iter_57_2 + 1] = var_57_9 or UNASSIGNED_KEY
		end

		var_57_2[iter_57_0] = var_57_5
	end

	return var_57_3, var_57_2
end

function InputManager.clear_keybinding(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = arg_58_0:keymaps_data(arg_58_1)

	assert(var_58_0, "No keymaps data found under table_name: %s", arg_58_1)

	local var_58_1 = var_58_0[arg_58_2]

	assert(var_58_1, "No keymaps data found under table_key: %s", arg_58_2)

	local var_58_2 = var_58_1.keymaps

	assert(var_58_2, "No keymaps found under %s with table_key: %s", arg_58_1, arg_58_2)

	local var_58_3 = var_58_2[arg_58_3]

	assert(var_58_3, "No such keymap name %s", arg_58_3)

	var_58_3[2] = UNASSIGNED_KEY
end

function InputManager.change_keybinding(arg_59_0, arg_59_1, arg_59_2, arg_59_3, ...)
	local var_59_0 = arg_59_0:keymaps_data(arg_59_1)

	assert(var_59_0, "No keymaps data found under table_name: %s", arg_59_1)

	local var_59_1 = var_59_0[arg_59_2]

	assert(var_59_1, "No keymaps data found under table_key: %s", arg_59_2)

	local var_59_2 = var_59_1.keymaps

	assert(var_59_2, "No keymaps found under %s with table_key: %s", arg_59_1, arg_59_2)

	local var_59_3 = var_59_2[arg_59_3]

	assert(var_59_3, "No such keymap name %s", arg_59_3)

	local var_59_4 = select("#", ...)

	assert(var_59_4 / 2 == math.floor(var_59_4 / 2), "Bad amount of arguments (%d) to :change_keybinding(). Must supply input device type and keymap button index type for every key.", var_59_4)

	local var_59_5 = 0

	for iter_59_0 = 1, var_59_4, 2 do
		local var_59_6, var_59_7 = select(iter_59_0, ...)

		assert(type(var_59_6) == "number", "New button index must be a number.")
		fassert(InputAux.input_device_mapping[var_59_7], "No such input device type %s", var_59_7)

		var_59_3[var_59_5 + 1] = var_59_7
		var_59_3[var_59_5 + 2] = var_59_6
		var_59_3[var_59_5 + 3] = var_59_3[3]
		var_59_5 = var_59_5 + 3
	end

	for iter_59_1 = var_59_5 + 1, #var_59_3 do
		var_59_3[iter_59_1] = nil
	end

	var_59_3.n = var_59_5
end

function InputManager.add_keybinding(arg_60_0, arg_60_1, arg_60_2, arg_60_3, ...)
	assert(type(new_button_index) == "number", "New button index must be a number.")

	local var_60_0 = arg_60_0:keymaps_data(arg_60_1)

	assert(var_60_0, "No keymaps data found under table_name: %s", arg_60_1)

	local var_60_1 = var_60_0[arg_60_2]

	assert(var_60_1, "No keymaps data found under table_key: %s", arg_60_2)

	local var_60_2 = var_60_1.keymaps

	assert(var_60_2, "No keymaps found under %s with table_key: %s", arg_60_1, arg_60_2)

	local var_60_3 = var_60_2[arg_60_3]

	assert(var_60_3, "No such keymap name %s", arg_60_3)

	local var_60_4 = select("#", ...)

	assert(var_60_4 / 3 == math.floor(var_60_4 / 3), "Bad amount of arguments (%d) to :add_keybinding(). Must supply input device type, keymap button index and keymap type for every key.", var_60_4)

	local var_60_5 = {
		n = 0
	}

	var_60_2[arg_60_3] = var_60_5

	for iter_60_0 = 1, var_60_4 / 3 do
		local var_60_6 = var_60_5.n
		local var_60_7 = select(iter_60_0 * 3 - 2, ...)
		local var_60_8 = select(iter_60_0 * 3 - 1, ...)
		local var_60_9 = select(iter_60_0 * 3, ...)

		assert(type(var_60_8) == "number", "New button index must be a number.")

		local var_60_10 = InputAux.input_device_mapping[var_60_7]

		assert(var_60_10, "No such input device type %s", var_60_7)

		local var_60_11 = var_60_10[1]

		if var_60_9 ~= "axis" then
			assert(var_60_11.button_name(var_60_8), "No such button index %d in device type %s", var_60_8, var_60_7)
		else
			assert(var_60_11.axis_name(var_60_8), "No such axis index %d in device type %s", var_60_8, var_60_7)
		end

		assert(InputAux.input_map_types[var_60_9], "Bad keymap type %s to add_keybinding() at vararg %d", var_60_9, iter_60_0 * 3)

		var_60_5[var_60_6 + 1] = var_60_7
		var_60_5[var_60_6 + 2] = var_60_8
		var_60_5[var_60_6 + 3] = var_60_9
		var_60_5.n = var_60_6 + 3
	end
end
