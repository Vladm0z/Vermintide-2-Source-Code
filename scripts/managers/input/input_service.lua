-- chunkname: @scripts/managers/input/input_service.lua

InputService = class(InputService)

InputService.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.platform = PLATFORM
	self.mapped_devices = {
		gamepad = {},
		ps_pad = {},
		mouse = {},
		keyboard = {},
		network = {},
		recording = {}
	}
	self.input_devices_data = {}
	self.name = arg_1_1
	self.controller_select = Vector3Box()
	self.block_reasons = arg_1_4
	self.keymaps_name = arg_1_2
	self.filters_name = arg_1_3
	self.input_manager = Managers.input
	self.blocked_input = {}
end

InputService.map_device = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = self.mapped_devices[arg_2_1]

	var_2_0[#var_2_0 + 1] = arg_2_2
	var_2_0.n = #var_2_0
	self.input_devices_data[arg_2_2] = arg_2_3
end

InputService.unmap_device = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = self.mapped_devices[arg_3_1]
	local find = table.find(var_3_0, arg_3_2)

	if not find then
		Application.warning("[InputService] No mapped input called %s for input service %s", arg_3_2.name(), self.name)

		return
	end

	table.remove(var_3_0, find)

	var_3_0.n = #var_3_0
end

local max = math.max

InputService.get = function (self, arg_4_1, arg_4_2)
	-- function 4
	local get_active_keymaps, var_4_1 = self:get_active_keymaps(nil, arg_4_1)
	local var_4_2 = get_active_keymaps[arg_4_1]
	local get_active_filters = self:get_active_filters(nil, arg_4_1)
	local flag = not get_active_filters and get_active_filters[arg_4_1]

	if not (not var_4_2 and var_4_2.n > 0 or flag) then
		local mapped_devices = self.mapped_devices
		local input_devices_data = self.input_devices_data
		local name = self.name
		local disabled_input_group = self.disabled_input_group
		local var_4_9
		local n = var_4_2.n

		if not disabled_input_group then
			var_4_9 = nil
		elseif not n then
			for i = 1, n, 3 do
				local var_4_11 = var_4_2[i]
				local var_4_12 = var_4_2[i + 1]
				local var_4_13 = var_4_2[i + 2]

				if var_4_12 ~= UNASSIGNED_KEY then
					local var_4_14 = mapped_devices[var_4_11]

					if not var_4_14 and not var_4_14.n then
						for j = 1, var_4_14.n do
							local var_4_15 = var_4_14[j]
							local var_4_16 = input_devices_data[var_4_15]

							if not (not var_4_15:active() and var_4_16.blocked_access[name]) then
								if var_4_13 == "soft_button" then
									var_4_9 = max(var_4_9 or 0, var_4_16[var_4_13][var_4_12])
								elseif not (var_4_13 ~= "axis" or not var_4_9 or not var_4_9 or not (Vector3.length_squared(var_4_9) < 0.01)) then
									var_4_9 = var_4_16[var_4_13][var_4_12]
								else
									var_4_9 = var_4_9 or var_4_16[var_4_13][var_4_12]
								end

								if var_4_9 == true then
									if not var_4_16.consumed_input[var_4_12] then
										var_4_9 = nil
									elseif not arg_4_2 then
										var_4_16.consumed_input[var_4_12] = true
									end
								end
							elseif not var_4_15:active() then
								var_4_9 = nil

								break
							end
						end

						var_4_9 = not (var_4_14.n > 0) or not var_4_9 or nil
					end
				end
			end
		end

		if var_4_9 == nil or not self.blocked_input[arg_4_1] then
			var_4_9 = InputAux.default_values_for_types[var_4_1[arg_4_1]]
		end

		return var_4_9
	elseif not flag then
		local get_most_recent_device = Managers.input:get_most_recent_device()
		local var_4_18 = self.input_devices_data[get_most_recent_device]
		local function_data = flag.function_data
		local update = InputFilters[function_data.filter_type].update(function_data, self)

		if self.blocked_input[arg_4_1] or not var_4_18 or not var_4_18.consumed_input[arg_4_1] then
			if type(update) == "boolean" then
				update = false
			elseif type(update) == "userdata" then
				update = Vector3.zero()
			elseif type(update) == "number" then
				update = 0
			end
		elseif not arg_4_2 then
			var_4_18.consumed_input[arg_4_1] = true
		end

		return update
	end
end

InputService.get_controller_cursor_position = function (self)
	-- function 5
	return self.controller_select:unbox()
end

InputService.set_controller_cursor_position = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self.controller_select:store(arg_6_1, arg_6_2, arg_6_3)
end

InputService.get_active_keymaps = function (self, arg_7_1, arg_7_2)
	-- function 7
	local flag = arg_7_1 or self.platform

	if (arg_7_1 or not IS_WINDOWS) and not self.input_manager:is_device_active("gamepad") then
		local get_most_recent_device = Managers.input:get_most_recent_device()

		flag = not ((not get_most_recent_device and get_most_recent_device.type()) == "sce_pad") and "ps_pad" and "xb1"
	end

	if (arg_7_1 or not IS_XB1) and self.input_manager:is_device_active("keyboard") and not self.input_manager:is_device_active("mouse") then
		local keymaps_name = self.keymaps_name
		local keymaps_data = self.input_manager:keymaps_data(keymaps_name)
		local win32 = keymaps_data.win32

		if not win32.keymaps[arg_7_2] then
			win32 = keymaps_data[flag]
		end

		return win32.keymaps, win32.default_data_types
	end

	local keymaps_name_2 = self.keymaps_name
	local var_7_6 = self.input_manager:keymaps_data(keymaps_name_2)[flag]

	return var_7_6.keymaps, var_7_6.default_data_types
end

InputService.get_active_filters = function (self, arg_8_1, arg_8_2)
	-- function 8
	local filters_name = self.filters_name

	if not filters_name then
		return
	end

	local flag = arg_8_1 or self.platform

	if (arg_8_1 or not IS_WINDOWS) and not self.input_manager:is_device_active("gamepad") then
		flag = "xb1"
		flag = Managers.input:get_most_recent_device().type() ~= "sce_pad" or not "ps_pad" or flag
	end

	if (arg_8_1 or not IS_XB1) and self.input_manager:is_device_active("keyboard") and not self.input_manager:is_device_active("mouse") then
		local filters_data = self.input_manager:filters_data(filters_name)
		local win32 = filters_data.win32

		if not win32[arg_8_2] then
			return filters_data[flag]
		else
			return win32
		end
	end

	return self.input_manager:filters_data(filters_name)[flag]
end

InputService.get_keymapping = function (self, arg_9_1, arg_9_2)
	-- function 9
	return self:get_active_keymaps(arg_9_2, arg_9_1)[arg_9_1]
end

InputService.add_keymap = function (self, arg_10_1)
	-- function 10
	local get_active_keymaps = self:get_active_keymaps()
	local flag = not get_active_keymaps[arg_10_1]

	fassert(flag, "Keymap already exists: name %s in service %s", arg_10_1, input_service_name)

	get_active_keymaps[arg_10_1] = {
		input_mappings = {
			n = 0
		}
	}
end

InputService.remove_keymap = function (self, arg_11_1)
	-- function 11
	local get_active_keymaps = self:get_active_keymaps()
	local var_11_1 = get_active_keymaps[arg_11_1]

	fassert(var_11_1, "No such keymap name %s in service %s", arg_11_1, self.name)

	get_active_keymaps[arg_11_1] = nil
end

InputService.generate_keybinding_setting = function (self)
	-- function 12
	local tbl = {}
	local get_active_keymaps = self:get_active_keymaps()

	for k, v in pairs(get_active_keymaps) do
		local tbl_2 = {}

		tbl[k] = {
			input_mappings = tbl_2,
			combination_type = v.combination_type
		}

		for k_2 = 1, v.input_mappings.n do
			local tbl_3 = {}

			tbl_2[k_2] = tbl_3

			local var_12_4 = v.input_mappings[k_2]

			for l = 1, var_12_4.n, 3 do
				local var_12_5 = var_12_4[l]

				tbl_3[l] = var_12_5

				local var_12_6 = InputAux.input_device_mapping[var_12_5][1]
				local var_12_7

				if var_12_4[l + 2] == "axis" then
					var_12_7 = var_12_6.axis_name(var_12_4[l + 1])
				else
					var_12_7 = var_12_6.button_name(var_12_4[l + 1])

					assert(var_12_4[l + 1] == var_12_6.button_index(var_12_7))
				end

				tbl_3[l + 1] = var_12_7
				tbl_3[l + 2] = var_12_4[l + 2]
			end
		end
	end

	return tbl
end

InputService.generate_filters_setting = function (self)
	-- function 13
	local tbl = {}
	local get_active_filters = self:get_active_filters()

	if not get_active_filters then
		for k, v in pairs(get_active_filters) do
			local clone = table.clone(v.function_data)

			clone.filter_type = v.filter_type
			tbl[k] = clone
		end
	end

	return tbl
end

InputService.has = function (self, arg_14_1)
	-- function 14
	local get_active_keymaps = self:get_active_keymaps(nil, arg_14_1)
	local get_active_filters = self:get_active_filters(nil, arg_14_1)
	local var_14_2 = get_active_keymaps[arg_14_1]

	var_14_2 = var_14_2 or not get_active_filters or not get_active_filters[arg_14_1] or true or false

	return var_14_2
end

InputService.is_blocked = function (self)
	-- function 15
	local service_is_blocked = self.service_is_blocked

	service_is_blocked = service_is_blocked or self.disabled_input_group

	return service_is_blocked
end

InputService.set_blocked = function (self, arg_16_1, arg_16_2)
	-- function 16
	self.service_is_blocked = arg_16_1
end

InputService.set_disabled_input_group = function (self, arg_17_1)
	-- function 17
	self.disabled_input_group = arg_17_1
end

InputService.set_input_blocked = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local blocked_input = self.blocked_input
	local var_18_1 = blocked_input[arg_18_1]

	if not (var_18_1 or arg_18_2) then
		return
	end

	var_18_1 = var_18_1 or {}
	blocked_input[arg_18_1] = var_18_1
	var_18_1[arg_18_3 or "_no_reason"] = arg_18_2 or nil

	if not next(var_18_1) then
		blocked_input[arg_18_1] = nil
	end

	if not Application.user_setting("debug_blocked_input") then
		printf("[InputService] Blocked input changed (%s): %s", arg_18_4, cjson.encode(self.blocked_input))
	end
end

InputService.set_hover = function (self, arg_19_1)
	-- function 19
	local hovering = self.hovering

	hovering = hovering or arg_19_1
	self.hovering = hovering
end

InputService.is_hovering = function (self)
	-- function 20
	return self.hovering
end
