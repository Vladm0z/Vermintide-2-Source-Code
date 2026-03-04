-- chunkname: @scripts/managers/input/input_service.lua

InputService = class(InputService)

function InputService.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.platform = PLATFORM
	arg_1_0.mapped_devices = {
		gamepad = {},
		ps_pad = {},
		mouse = {},
		keyboard = {},
		network = {},
		recording = {}
	}
	arg_1_0.input_devices_data = {}
	arg_1_0.name = arg_1_1
	arg_1_0.controller_select = Vector3Box()
	arg_1_0.block_reasons = arg_1_4
	arg_1_0.keymaps_name = arg_1_2
	arg_1_0.filters_name = arg_1_3
	arg_1_0.input_manager = Managers.input
	arg_1_0.blocked_input = {}
end

function InputService.map_device(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0.mapped_devices[arg_2_1]

	var_2_0[#var_2_0 + 1] = arg_2_2
	var_2_0.n = #var_2_0
	arg_2_0.input_devices_data[arg_2_2] = arg_2_3
end

function InputService.unmap_device(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.mapped_devices[arg_3_1]
	local var_3_1 = table.find(var_3_0, arg_3_2)

	if not var_3_1 then
		Application.warning("[InputService] No mapped input called %s for input service %s", arg_3_2.name(), arg_3_0.name)

		return
	end

	table.remove(var_3_0, var_3_1)

	var_3_0.n = #var_3_0
end

local var_0_0 = math.max

function InputService.get(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0, var_4_1 = arg_4_0:get_active_keymaps(nil, arg_4_1)
	local var_4_2 = var_4_0[arg_4_1]
	local var_4_3 = arg_4_0:get_active_filters(nil, arg_4_1)
	local var_4_4 = var_4_3 and var_4_3[arg_4_1]

	if var_4_2 and (var_4_2.n > 0 or not var_4_4) then
		local var_4_5 = arg_4_0.mapped_devices
		local var_4_6 = arg_4_0.input_devices_data
		local var_4_7 = arg_4_0.name
		local var_4_8 = arg_4_0.disabled_input_group
		local var_4_9
		local var_4_10 = var_4_2.n

		if var_4_8 then
			var_4_9 = nil
		elseif var_4_10 then
			for iter_4_0 = 1, var_4_10, 3 do
				local var_4_11 = var_4_2[iter_4_0]
				local var_4_12 = var_4_2[iter_4_0 + 1]
				local var_4_13 = var_4_2[iter_4_0 + 2]

				if var_4_12 ~= UNASSIGNED_KEY then
					local var_4_14 = var_4_5[var_4_11]

					if var_4_14 and var_4_14.n then
						for iter_4_1 = 1, var_4_14.n do
							local var_4_15 = var_4_14[iter_4_1]
							local var_4_16 = var_4_6[var_4_15]

							if var_4_15:active() and not var_4_16.blocked_access[var_4_7] then
								if var_4_13 == "soft_button" then
									var_4_9 = var_0_0(var_4_9 or 0, var_4_16[var_4_13][var_4_12])
								elseif var_4_13 == "axis" and (not var_4_9 or var_4_9 and Vector3.length_squared(var_4_9) < 0.01) then
									var_4_9 = var_4_16[var_4_13][var_4_12]
								else
									var_4_9 = var_4_9 or var_4_16[var_4_13][var_4_12]
								end

								if var_4_9 == true then
									if var_4_16.consumed_input[var_4_12] then
										var_4_9 = nil
									elseif arg_4_2 then
										var_4_16.consumed_input[var_4_12] = true
									end
								end
							elseif var_4_15:active() then
								var_4_9 = nil

								break
							end
						end

						var_4_9 = var_4_14.n > 0 and var_4_9 or nil
					end
				end
			end
		end

		if var_4_9 == nil or arg_4_0.blocked_input[arg_4_1] then
			var_4_9 = InputAux.default_values_for_types[var_4_1[arg_4_1]]
		end

		return var_4_9
	elseif var_4_4 then
		local var_4_17 = Managers.input:get_most_recent_device()
		local var_4_18 = arg_4_0.input_devices_data[var_4_17]
		local var_4_19 = var_4_4.function_data
		local var_4_20 = InputFilters[var_4_19.filter_type].update(var_4_19, arg_4_0)

		if arg_4_0.blocked_input[arg_4_1] or var_4_18 and var_4_18.consumed_input[arg_4_1] then
			if type(var_4_20) == "boolean" then
				var_4_20 = false
			elseif type(var_4_20) == "userdata" then
				var_4_20 = Vector3.zero()
			elseif type(var_4_20) == "number" then
				var_4_20 = 0
			end
		elseif arg_4_2 then
			var_4_18.consumed_input[arg_4_1] = true
		end

		return var_4_20
	end
end

function InputService.get_controller_cursor_position(arg_5_0)
	return arg_5_0.controller_select:unbox()
end

function InputService.set_controller_cursor_position(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.controller_select:store(arg_6_1, arg_6_2, arg_6_3)
end

function InputService.get_active_keymaps(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1 or arg_7_0.platform

	if not arg_7_1 and IS_WINDOWS and arg_7_0.input_manager:is_device_active("gamepad") then
		local var_7_1 = Managers.input:get_most_recent_device()

		var_7_0 = (var_7_1 and var_7_1.type()) == "sce_pad" and "ps_pad" or "xb1"
	end

	if not arg_7_1 and IS_XB1 and (arg_7_0.input_manager:is_device_active("keyboard") or arg_7_0.input_manager:is_device_active("mouse")) then
		local var_7_2 = arg_7_0.keymaps_name
		local var_7_3 = arg_7_0.input_manager:keymaps_data(var_7_2)
		local var_7_4 = var_7_3.win32

		if not var_7_4.keymaps[arg_7_2] then
			var_7_4 = var_7_3[var_7_0]
		end

		return var_7_4.keymaps, var_7_4.default_data_types
	end

	local var_7_5 = arg_7_0.keymaps_name
	local var_7_6 = arg_7_0.input_manager:keymaps_data(var_7_5)[var_7_0]

	return var_7_6.keymaps, var_7_6.default_data_types
end

function InputService.get_active_filters(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.filters_name

	if not var_8_0 then
		return
	end

	local var_8_1 = arg_8_1 or arg_8_0.platform

	if not arg_8_1 and IS_WINDOWS and arg_8_0.input_manager:is_device_active("gamepad") then
		var_8_1 = "xb1"
		var_8_1 = Managers.input:get_most_recent_device().type() == "sce_pad" and "ps_pad" or var_8_1
	end

	if not arg_8_1 and IS_XB1 and (arg_8_0.input_manager:is_device_active("keyboard") or arg_8_0.input_manager:is_device_active("mouse")) then
		local var_8_2 = arg_8_0.input_manager:filters_data(var_8_0)
		local var_8_3 = var_8_2.win32

		if not var_8_3[arg_8_2] then
			return var_8_2[var_8_1]
		else
			return var_8_3
		end
	end

	return arg_8_0.input_manager:filters_data(var_8_0)[var_8_1]
end

function InputService.get_keymapping(arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0:get_active_keymaps(arg_9_2, arg_9_1)[arg_9_1]
end

function InputService.add_keymap(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:get_active_keymaps()
	local var_10_1 = not var_10_0[arg_10_1]

	fassert(var_10_1, "Keymap already exists: name %s in service %s", arg_10_1, input_service_name)

	var_10_0[arg_10_1] = {
		input_mappings = {
			n = 0
		}
	}
end

function InputService.remove_keymap(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:get_active_keymaps()
	local var_11_1 = var_11_0[arg_11_1]

	fassert(var_11_1, "No such keymap name %s in service %s", arg_11_1, arg_11_0.name)

	var_11_0[arg_11_1] = nil
end

function InputService.generate_keybinding_setting(arg_12_0)
	local var_12_0 = {}
	local var_12_1 = arg_12_0:get_active_keymaps()

	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		local var_12_2 = {}

		var_12_0[iter_12_0] = {
			input_mappings = var_12_2,
			combination_type = iter_12_1.combination_type
		}

		for iter_12_2 = 1, iter_12_1.input_mappings.n do
			local var_12_3 = {}

			var_12_2[iter_12_2] = var_12_3

			local var_12_4 = iter_12_1.input_mappings[iter_12_2]

			for iter_12_3 = 1, var_12_4.n, 3 do
				local var_12_5 = var_12_4[iter_12_3]

				var_12_3[iter_12_3] = var_12_5

				local var_12_6 = InputAux.input_device_mapping[var_12_5][1]
				local var_12_7

				if var_12_4[iter_12_3 + 2] == "axis" then
					var_12_7 = var_12_6.axis_name(var_12_4[iter_12_3 + 1])
				else
					var_12_7 = var_12_6.button_name(var_12_4[iter_12_3 + 1])

					assert(var_12_4[iter_12_3 + 1] == var_12_6.button_index(var_12_7))
				end

				var_12_3[iter_12_3 + 1] = var_12_7
				var_12_3[iter_12_3 + 2] = var_12_4[iter_12_3 + 2]
			end
		end
	end

	return var_12_0
end

function InputService.generate_filters_setting(arg_13_0)
	local var_13_0 = {}
	local var_13_1 = arg_13_0:get_active_filters()

	if var_13_1 then
		for iter_13_0, iter_13_1 in pairs(var_13_1) do
			local var_13_2 = table.clone(iter_13_1.function_data)

			var_13_2.filter_type = iter_13_1.filter_type
			var_13_0[iter_13_0] = var_13_2
		end
	end

	return var_13_0
end

function InputService.has(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:get_active_keymaps(nil, arg_14_1)
	local var_14_1 = arg_14_0:get_active_filters(nil, arg_14_1)

	return var_14_0[arg_14_1] or var_14_1 and var_14_1[arg_14_1] and true or false
end

function InputService.is_blocked(arg_15_0)
	return arg_15_0.service_is_blocked or arg_15_0.disabled_input_group
end

function InputService.set_blocked(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.service_is_blocked = arg_16_1
end

function InputService.set_disabled_input_group(arg_17_0, arg_17_1)
	arg_17_0.disabled_input_group = arg_17_1
end

function InputService.set_input_blocked(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_0.blocked_input
	local var_18_1 = var_18_0[arg_18_1]

	if not var_18_1 and not arg_18_2 then
		return
	end

	var_18_1 = var_18_1 or {}
	var_18_0[arg_18_1] = var_18_1
	var_18_1[arg_18_3 or "_no_reason"] = arg_18_2 or nil

	if not next(var_18_1) then
		var_18_0[arg_18_1] = nil
	end

	if Application.user_setting("debug_blocked_input") then
		printf("[InputService] Blocked input changed (%s): %s", arg_18_4, cjson.encode(arg_18_0.blocked_input))
	end
end

function InputService.set_hover(arg_19_0, arg_19_1)
	arg_19_0.hovering = arg_19_0.hovering or arg_19_1
end

function InputService.is_hovering(arg_20_0)
	return arg_20_0.hovering
end
