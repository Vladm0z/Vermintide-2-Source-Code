-- chunkname: @scripts/managers/input/input_debugger.lua

local num = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str
local scripts_utils_serialize = require("scripts/utils/serialize")
local script_data = script_data
local input_debug_device_state = script_data.input_debug_device_state

input_debug_device_state = input_debug_device_state or Development.parameter("input_debug_device_state")
script_data.input_debug_device_state = input_debug_device_state

local script_data_2 = script_data
local input_debug_filters = script_data.input_debug_filters

input_debug_filters = input_debug_filters or Development.parameter("input_debug_filters")
script_data_2.input_debug_filters = input_debug_filters

local InputDebugger = InputDebugger

InputDebugger = InputDebugger or {}
InputDebugger = InputDebugger

InputDebugger.setup = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.input_device_data = {}
	self.gui = World.create_screen_gui(arg_1_1, "material", "materials/fonts/gw_fonts", "immediate")
	self.num_updated_devices = 0
	self.input_manager = arg_1_2
	self.hold_timer = 0
	self.current_selection = 1
	self.debug_edit_keymap = false
	self.enabled = true
	self.world = arg_1_1
end

InputDebugger.clear = function (self)
	-- function 2
	self.world = nil
	self.gui = nil
	self.input_manager = nil
end

InputDebugger.pre_update_device = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if not script_data.input_debug_device_state then
		-- Nothing
	end
end

local num_2 = 100

InputDebugger.post_update_device = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not self.input_manager then
		return
	end

	if not script_data.debug_enabled then
		return
	end

	if not script_data.input_debug_device_state then
		local gui = self.gui
		local var_4_1 = Color(255, 255, 255)
		local var_4_2 = Color(128, 128, 255)
		local var_4_3 = Color(128, 255, 128)
		local name = arg_4_1:name()
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h

		Gui.text(gui, name, str_2, num, str, Vector3(100 + self.num_updated_devices * num_2, res_h - num, 900), var_4_1)

		local var_4_7 = self.input_device_data[name]

		var_4_7 = var_4_7 or {}
		self.input_device_data[name] = var_4_7

		for k, v in pairs(arg_4_2) do
			if type(v) == "table" then
				local var_4_8 = var_4_7[k]

				var_4_8 = var_4_8 or {}
				var_4_7[k] = var_4_8

				for k_2, v_2 in pairs(v) do
					local type_name = Script.type_name(v_2)

					if not (type_name ~= "number" or not (v_2 > 0)) then
						var_4_8[k_2] = 1
					elseif type_name == "Vector3" then
						if Vector3.distance(v_2, Vector3.zero()) < 0.1 then
							if not (not var_4_8[k_2] and not (var_4_8[k_2] > 0)) then
								var_4_8[k_2] = var_4_8[k_2] - arg_4_3
							end
						else
							var_4_8[k_2] = 1
						end
					elseif type_name == "number" or not v_2 then
						var_4_8[k_2] = 1
					elseif not (not var_4_8[k_2] and not (var_4_8[k_2] > 0)) then
						var_4_8[k_2] = var_4_8[k_2] - arg_4_3
					end
				end
			else
				var_4_7[k] = v
			end
		end

		local num_3 = 1

		for k_3, v_3 in pairs(arg_4_2) do
			local var_4_11 = var_4_7[k_3]

			if type(v_3) == "table" then
				num_3 = num_3 + 1

				Gui.text(gui, "  " .. k_3, str_2, num, str, Vector3(100 + self.num_updated_devices * num_2, res_h - num * num_3, 900), var_4_2)

				for k_4, v_4 in pairs(v_3) do
					if type(k_4) == "number" then
						local var_4_12 = var_4_11[k_4]

						if not (not var_4_12 and not (var_4_12 > 0)) then
							local var_4_13 = Color(255 * var_4_12, 128, 255, 128)
							local axis_name

							if k_3 == "axis" then
								axis_name = arg_4_1.axis_name(k_4)

								if not axis_name then
									-- Nothing
								end
							end

							axis_name = arg_4_1.button_name(k_4)

							::label_4_0::

							local format = string.format("    [%s]:%s", axis_name, tostring(v_4))

							num_3 = num_3 + 1

							Gui.text(gui, format, str_2, num, str, Vector3(100 + self.num_updated_devices * num_2, res_h - num * num_3, 900), var_4_13)
						end
					end
				end
			end
		end

		self.num_updated_devices = self.num_updated_devices + 1
	end
end

local function fn(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	Gui.text(InputDebugger.gui, arg_5_0, str_2, num, str, arg_5_1, arg_5_2)
end

InputDebugger.debug_input_filters = function (self)
	-- function 6
	local var_6_0 = Color(128, 128, 255)
	local var_6_1 = Color(128, 255, 128)
	local num_2 = 0
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h

	for k, v in pairs(self.input_manager.input_services) do
		if not v.input_filters then
			fn(string.format("Filters: %s", k), Vector3(20, res_h / 2 - num * num_2, 900), var_6_0)

			num_2 = num_2 + 1

			for k_2, v_2 in pairs(v.input_filters) do
				local filter_output = v_2.filter_output
				local update = InputFilters[v_2.function_data.filter_type].update(v_2.function_data, v)

				fn(string.format("[%s]:%s", filter_output, tostring(update)), Vector3(20, res_h / 2 - num * num_2, 900), var_6_1)

				num_2 = num_2 + 1
			end
		end
	end
end

InputDebugger.update_input_service_data = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = Color(128, 128, 192)
	local var_7_1 = Color(255, 255, 255)
	local var_7_2 = Color(192, 192, 64)
	local var_7_3 = Color(64, 192, 64)

	if not arg_7_1:get("esc") then
		if not self.selected_input_service then
			self.debug_edit_keymap = false

			self.input_manager:device_unblock_all_services("keyboard")
			self.input_manager:device_unblock_all_services("mouse")
		elseif not (self.selected_keymap or self.added_keymap) then
			if not self.selected_input_type then
				self.selected_input_type = nil
			else
				self.selected_input_service = nil
			end

			self.current_selection = 1

			return
		end
	end

	local selected_input_service = self.selected_input_service
	local current_selection = self.current_selection
	local res_w = RESOLUTION_LOOKUP.res_w
	local num_2 = RESOLUTION_LOOKUP.res_h - 20 - num
	local num_3 = res_w / 2
	local num_4 = 0
	local var_7_10

	if not selected_input_service then
		fn("Select input service (press 's' to print it to console):", Vector3(num_3, num_2, 900), var_7_3)
	else
		if not self.selected_input_type then
			if self.selected_keymap or not self.selected_input_filter_name then
				num_3 = num_3 - 360
			else
				num_3 = num_3 - 240
			end
		else
			num_3 = num_3 - 120
		end

		fn("InputService", Vector3(num_3, num_2, 900), var_7_3)
	end

	local num_5 = num_2 - num

	for k, v in pairs(self.input_manager.input_services) do
		num_4 = num_4 + 1

		local var_7_12 = var_7_1

		if not selected_input_service then
			if selected_input_service == k then
				var_7_10 = v
				var_7_12 = var_7_0
			end
		elseif current_selection == num_4 then
			var_7_12 = var_7_2

			self:handle_edit_debug_keys(arg_7_1, k, "selected_input_service", nil, table.size(self.input_manager.input_services), arg_7_2)

			if not DebugKeyHandler.key_pressed("s", "Save Keybinding", "Input") then
				local get_service = self.input_manager:get_service(k)
				local generate_keybinding_setting = get_service:generate_keybinding_setting()
				local generate_filters_setting = get_service:generate_filters_setting()

				print("---------------> SNIP SNIP <-----------------")

				local save_simple = scripts_utils_serialize.save_simple(generate_keybinding_setting)

				print(save_simple)
				print("---------------> SNIP SNIP <-----------------")

				local PlayerData = PlayerData
				local controls = PlayerData.controls

				controls = controls or {}
				PlayerData.controls = controls

				local var_7_19 = PlayerData.controls[k]

				var_7_19 = var_7_19 or {}
				PlayerData.controls[k] = var_7_19
				var_7_19.keymap = generate_keybinding_setting
				var_7_19.filters = generate_filters_setting

				Managers.save:auto_save(SaveFileName, SaveData)
			end
		end

		fn(k, Vector3(num_3, num_5, 900), var_7_12)

		num_5 = num_5 - num
	end

	return var_7_10, num_3
end

InputDebugger.update_selected_device = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local var_8_0 = Color(128, 128, 192)
	local var_8_1 = Color(255, 255, 255)
	local var_8_2 = Color(192, 192, 64)
	local var_8_3 = Color(64, 192, 64)
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local current_selection = self.current_selection

	fn("Select button press type", Vector3(arg_8_2, arg_8_3, 900), var_8_3)

	arg_8_3 = arg_8_3 - num

	local num_2 = 0
	local selected_map_type = self.selected_map_type

	for k, v in pairs(InputAux.input_map_types) do
		num_2 = num_2 + 1

		local var_8_9 = var_8_1

		if not selected_map_type then
			if selected_map_type == k then
				var_8_9 = var_8_0
			end
		elseif current_selection == num_2 then
			var_8_9 = var_8_2

			self:handle_edit_debug_keys(arg_8_1, k, "selected_map_type", "current_selected_device", table.size(InputAux.input_map_types), arg_8_4)
		end

		fn(k, Vector3(arg_8_2, arg_8_3, 900), var_8_9)

		arg_8_3 = arg_8_3 - num
	end

	if not (not selected_map_type and selected_map_type == "axis") then
		fn("Please press key (escape to cancel).", Vector3(res_w / 2, res_h / 2, 900), var_8_1)

		local current_selected_device = self.current_selected_device
		local var_8_11 = InputAux.input_device_mapping[current_selected_device][1]
		local any_pressed = var_8_11.any_pressed()
		local last_pressed = self.last_pressed

		last_pressed = last_pressed or any_pressed
		self.last_pressed = last_pressed

		if not last_pressed then
			fn(string.format("You pressed: %s (%d)", var_8_11.button_name(last_pressed), last_pressed), Vector3(res_w / 2, res_h / 2 - num * num_2, 900), var_8_1)

			local key_selected_wait = self.key_selected_wait

			key_selected_wait = key_selected_wait or arg_8_4 + 1
			self.key_selected_wait = key_selected_wait

			if key_selected_wait < arg_8_4 then
				local current_keybinds = self.current_keybinds

				current_keybinds = current_keybinds or {}
				self.current_keybinds = current_keybinds

				local count = #current_keybinds

				current_keybinds[count + 1] = current_selected_device
				current_keybinds[count + 2] = last_pressed
				current_keybinds[count + 3] = selected_map_type
				self.key_selected_wait = nil
				self.last_pressed = nil
				self.selected_map_type = nil
				self.current_selected_device = nil
			end
		end
	elseif selected_map_type == "axis" then
		-- Nothing
	end
end

InputDebugger.update_input_modify_type = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0 = Color(128, 128, 192)
	local var_9_1 = Color(255, 255, 255)
	local var_9_2 = Color(192, 192, 64)
	local var_9_3 = Color(64, 192, 64)
	local res_w = RESOLUTION_LOOKUP.res_w
	local num_2 = RESOLUTION_LOOKUP.res_h - 20 - num

	arg_9_3 = arg_9_3 + 120

	local current_selection = self.current_selection

	if not self.selected_input_type then
		fn("Select input filters to modify or keymap.", Vector3(arg_9_3, num_2, 900), var_9_3)
	end

	local num_3 = num_2 - num

	if self.selected_input_type == "filters" then
		fn("Input Filters", Vector3(arg_9_3, num_3, 900), var_9_0)
		fn("Input Keymap", Vector3(arg_9_3, num_3 - num, 900), var_9_1)
	elseif self.selected_input_type == "keymap" then
		fn("Input Filters", Vector3(arg_9_3, num_3, 900), var_9_1)
		fn("Input Keymap", Vector3(arg_9_3, num_3 - num, 900), var_9_0)
	else
		fn("Input Filters", Vector3(arg_9_3, num_3, 900), current_selection ~= 1 or not var_9_2 or var_9_1)
		fn("Input Keymap", Vector3(arg_9_3, num_3 - num, 900), current_selection ~= 2 or not var_9_2 or var_9_1)

		if not arg_9_1:get("enter_key") then
			local flag

			flag = current_selection ~= 1 or not "filters" or "keymap"
			self.selected_input_type = flag
			self.current_selection = 1
		elseif not (not arg_9_1:get("up_key") and not (arg_9_2 > self.hold_timer)) then
			self.current_selection = 3 - current_selection
			self.hold_timer = arg_9_2 + 0.1
		elseif not (not arg_9_1:get("down_key") and not (arg_9_2 > self.hold_timer)) then
			self.current_selection = 3 - current_selection
			self.hold_timer = arg_9_2 + 0.1
		elseif not arg_9_1:get("backspace") then
			self.selected_input_service = nil
			self.current_selection = 1
		end
	end

	local num_4 = num_3 - num * 2

	return arg_9_3
end

InputDebugger.update_selected_keymap_edit = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local var_10_0 = Color(128, 128, 192)
	local var_10_1 = Color(255, 255, 255)
	local var_10_2 = Color(192, 192, 64)
	local var_10_3 = Color(64, 192, 64)
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local current_selection = self.current_selection
	local num_2 = res_h - 20 - num

	arg_10_4 = arg_10_4 + 120

	local selected_keymap = self.selected_keymap

	if not (selected_keymap or self.added_keymap) then
		fn("Select keymap to modify. Press 'a' to add, 'd' to delete.", Vector3(arg_10_4, num_2, 900), var_10_3)
	else
		fn("Keymap", Vector3(arg_10_4, num_2, 900), var_10_3)
	end

	local num_3 = num_2 - num
	local num_4 = 0
	local added_keymap = self.added_keymap

	if not added_keymap then
		if added_keymap.edit_mode == "device" then
			fn(string.format("Keymap name: %s (press 'f' to finalize, 'esc' to cancel)", added_keymap.name), Vector3(arg_10_4, num_3, 900), var_10_3)
		else
			fn("Keymap name: " .. added_keymap.name, Vector3(arg_10_4, num_3, 900), var_10_1)
		end

		if not arg_10_1:get("esc") then
			self.added_keymap = nil
			self.current_selection = 1

			return
		end

		num_3 = num_3 - num

		if not self.current_keybinds then
			fn("Current buttons:", Vector3(arg_10_4, num_3, 900), var_10_3)

			num_3 = num_3 - num

			local current_keybinds = self.current_keybinds

			for i = 1, #current_keybinds / 3 do
				local var_10_13 = current_keybinds[i * 3 - 2]
				local button_name = InputAux.input_device_mapping[var_10_13][1].button_name(current_keybinds[i * 3 - 1])

				fn(string.format("%s:%s[%d] (%s)", var_10_13, button_name, current_keybinds[i * 3 - 1], current_keybinds[i * 3]), Vector3(arg_10_4, num_3, 900), var_10_0)

				num_3 = num_3 - num
			end

			if not DebugKeyHandler.key_pressed("f", "Finalize Keybinding (store)", "Input") then
				local name = added_keymap.name
				local get_service = self.input_manager:get_service(self.selected_input_service)

				get_service:add_keymap(name)
				get_service:add_keybinding(name, unpack(self.current_keybinds))

				self.current_keybinds = nil
				self.added_keymap = nil
				self.current_selection = 1
				self.current_selected_device = nil
				self.selected_map_type = nil
				self.key_selected_wait = nil
				self.last_pressed = nil

				return
			end
		end

		local edit_mode = added_keymap.edit_mode

		if not edit_mode then
			local edit_index = self.edit_index

			edit_index = edit_index or 1

			local edit_mode_2 = self.edit_mode
			local keystrokes = Keyboard.keystrokes()
			local parse_strokes, var_10_22, var_10_23 = KeystrokeHelper.parse_strokes(added_keymap.name, edit_index, edit_mode_2, keystrokes)

			self.edit_index = var_10_22
			self.edit_mode = var_10_23
			added_keymap.name = parse_strokes

			if not arg_10_1:get("enter_key") then
				added_keymap.edit_mode = "device"
				self.current_selection = 1
			end
		end

		local current_selected_device = self.current_selected_device

		if edit_mode == "device" then
			fn("Select device-type:", Vector3(arg_10_4, num_3, 900), var_10_3)

			num_3 = num_3 - num

			local num_5 = 0

			for k, v in pairs(arg_10_5.mapped_devices) do
				if #v > 0 then
					num_5 = num_5 + 1
				end
			end

			for k_2, v_2 in pairs(arg_10_5.mapped_devices) do
				if #v_2 > 0 then
					local var_10_26 = var_10_1

					num_4 = num_4 + 1

					if not current_selected_device then
						if current_selected_device == k_2 then
							var_10_26 = var_10_0
						end
					elseif current_selection == num_4 then
						var_10_26 = var_10_2

						self:handle_edit_debug_keys(arg_10_1, k_2, "selected_input_type", nil, num_5, arg_10_3)
					end

					fn(k_2, Vector3(arg_10_4, num_3, 900), var_10_26)

					num_3 = num_3 - num
				end
			end
		end

		if not current_selected_device then
			self:update_selected_device(arg_10_1, arg_10_4, num_3, arg_10_3)
		end

		return
	end

	local num_6 = 40
	local size = table.size(arg_10_5.keymaps)
	local min = math.min(size, current_selection + 20)
	local max = math.max(1, min - 40)
	local min_2 = math.min(size, max + 40)
	local var_10_32

	for k_3, v_3 in pairs(arg_10_5.keymaps) do
		num_4 = num_4 + 1

		local var_10_33 = var_10_1

		if not selected_keymap then
			if selected_keymap == k_3 then
				var_10_32 = v_3
				var_10_33 = var_10_0
			end
		elseif current_selection == num_4 then
			var_10_33 = var_10_2

			if not DebugKeyHandler.key_pressed("a", "Add Keymap", "Input") then
				self.added_keymap = {
					name = ""
				}
			elseif not DebugKeyHandler.key_pressed("d", "Delete Keymap", "Input") then
				self.input_manager:get_service(self.selected_input_service):remove_keymap(k_3)
			else
				self:handle_edit_debug_keys(arg_10_1, k_3, "selected_keymap", "selected_input_type", size, arg_10_3)
			end
		end

		if not (not (max <= num_4) or not (num_4 <= min_2)) then
			fn(k_3, Vector3(arg_10_4, num_3, 900), var_10_33)

			num_3 = num_3 - num
		end
	end

	if not var_10_32 then
		return
	end

	if not arg_10_1:get("esc") then
		self.selected_input_type = nil
		self.current_selection = 1

		return
	end

	arg_10_4 = arg_10_4 + 120

	local num_7 = res_h - 20 - num

	fn("Select keybinding to modify. Press 'a' to add, 'enter' to edit.", Vector3(arg_10_4, num_7, 900), var_10_3)

	local num_8 = num_7 - num

	fn("   'del' to delete.", Vector3(arg_10_4, num_8, 900), var_10_3)

	local num_9 = num_8 - num
	local selected_binding = self.selected_binding
	local var_10_38
	local var_10_39
	local var_10_40
	local num_10 = 0
	local num_11 = 0

	for i_2, v_4 in ipairs(var_10_32.input_mappings) do
		num_11 = num_11 + v_4.n
	end

	for i_3, v_5 in ipairs(var_10_32.input_mappings) do
		for i11 = 1, v_5.n, 3 do
			num_10 = num_10 + 1

			local var_10_43 = v_5[i11]
			local var_10_44 = InputAux.input_device_mapping[var_10_43][1]
			local var_10_45 = v_5[i11 + 1]
			local var_10_46 = var_10_1

			if not selected_binding then
				if selected_binding == num_10 then
					var_10_46 = var_10_0
					var_10_40 = v_5
					var_10_38 = i_3
					var_10_39 = math.ceil(i11 / 3)
				end
			elseif current_selection == num_10 then
				self:handle_edit_debug_keys(arg_10_1, num_10, "selected_binding", "selected_keymap", num_11 / 3, arg_10_3)

				var_10_46 = var_10_2
			end

			local format = string.format("[%d.%d] %s [%d] %s (%s)", i_3, math.ceil(i11 / 3), var_10_43, var_10_45, var_10_44.button_name(var_10_45), v_5[i11 + 2])

			fn(format, Vector3(arg_10_4, num_9, 900), var_10_46)

			num_9 = num_9 - num
		end
	end

	if not var_10_40 then
		return
	end

	fn("Please press new key (escape to cancel).", Vector3(res_w / 2, res_h / 2, 900), var_10_1)

	local var_10_48 = var_10_40[var_10_39 * 3 - 2]
	local var_10_49 = InputAux.input_device_mapping[var_10_48][1]
	local any_pressed = var_10_49.any_pressed()
	local last_pressed = self.last_pressed

	last_pressed = last_pressed or any_pressed
	self.last_pressed = last_pressed

	if not self.last_pressed then
		fn(string.format("You pressed: %s (%d)", var_10_49.button_name(self.last_pressed), self.last_pressed), Vector3(res_w / 2, res_h / 2 - num, 900), var_10_1)

		local key_selected_wait = self.key_selected_wait

		key_selected_wait = key_selected_wait or arg_10_3 + 1
		self.key_selected_wait = key_selected_wait

		if key_selected_wait < arg_10_3 then
			local selected_input_service = self.selected_input_service

			self.input_manager:get_service(selected_input_service):change_keybinding(selected_keymap, var_10_38, var_10_39, self.last_pressed)

			self.key_selected_wait = nil
			self.selected_binding = nil
			self.last_pressed = nil
		end
	end
end

InputDebugger.update_selected_filter_edit = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local var_11_0 = Color(128, 128, 192)
	local var_11_1 = Color(255, 255, 255)
	local var_11_2 = Color(192, 192, 64)
	local var_11_3 = Color(64, 192, 64)
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local current_selection = self.current_selection
	local num_2 = res_h - 20 - num

	arg_11_4 = arg_11_4 + 120

	local selected_input_filter_name = self.selected_input_filter_name

	if not selected_input_filter_name then
		fn("Select filter to modify. Press 'a' to add, 'd' to delete.", Vector3(arg_11_4, num_2, 900), var_11_3)
	else
		fn("Filter", Vector3(arg_11_4, num_2, 900), var_11_3)
	end

	local num_3 = num_2 - num
	local input_filters = arg_11_5.input_filters
	local var_11_11
	local num_4 = 0

	for k, v in pairs(input_filters) do
		num_4 = num_4 + 1

		if not selected_input_filter_name then
			fn(k, Vector3(arg_11_4, num_3, 900), selected_input_filter_name ~= k or not var_11_0 or var_11_1)

			if selected_input_filter_name == k then
				var_11_11 = v
			end
		elseif num_4 == current_selection then
			fn(k, Vector3(arg_11_4, num_3, 900), var_11_2)
			self:handle_edit_debug_keys(arg_11_1, k, "selected_input_filter_name", "selected_input_type", table.size(input_filters), arg_11_3)
		else
			fn(k, Vector3(arg_11_4, num_3, 900), var_11_1)
		end

		num_3 = num_3 - num
	end

	if not var_11_11 then
		return
	end

	arg_11_4 = arg_11_4 + 120

	local num_5 = res_h - 20 - num

	fn("Select filter-data to edit:", Vector3(arg_11_4, num_5, 900), var_11_3)

	local num_6 = num_5 - num
	local selected_edit_type_index = self.selected_edit_type_index
	local flag = (selected_edit_type_index ~= 1 or not var_11_0 or selected_edit_type_index) and (current_selection ~= 1 or not var_11_2 or var_11_1)

	fn("Type: " .. var_11_11.filter_type, Vector3(arg_11_4, num_6, 900), flag)

	local edit_types = InputFilters[var_11_11.filter_type].edit_types

	if not (current_selection ~= 1 or selected_edit_type_index) then
		self:handle_edit_debug_keys(arg_11_1, 1, "selected_edit_type_index", "selected_input_filter_name", #edit_types + 1, arg_11_3)
	end

	local num_7 = num_6 - num
	local var_11_19

	for i, v_2 in ipairs(edit_types) do
		local var_11_20 = var_11_1

		if not selected_edit_type_index then
			if selected_edit_type_index == i + 1 then
				var_11_19 = v_2
				var_11_20 = var_11_0
			end
		elseif current_selection == i + 1 then
			var_11_20 = var_11_2

			self:handle_edit_debug_keys(arg_11_1, i + 1, "selected_edit_type_index", "selected_input_filter_name", #edit_types + 1, arg_11_3)
		end

		local tostring = tostring
		local var_11_22

		if not v_2[4] then
			var_11_22 = var_11_11.function_data[v_2[4]][v_2[1]]

			if not var_11_22 then
				-- Nothing
			end
		end

		var_11_22 = var_11_11.function_data[v_2[1]]

		::label_11_0::

		local var_11_23 = tostring(var_11_22)
		local format = string.format("%s [%s] (%s)", v_2[1], v_2[2], var_11_23)

		fn(format, Vector3(arg_11_4, num_7, 900), var_11_20)

		num_7 = num_7 - num
	end

	if not selected_edit_type_index then
		return
	end

	local num_8 = res_h - 20 - num

	arg_11_4 = arg_11_4 + 120

	if selected_edit_type_index == 1 then
		fn("Select new filter type", Vector3(arg_11_4, num_8, 900), var_11_3)

		num_8 = num_8 - num

		local num_9 = 0

		for k_2, v_3 in pairs(InputFilters) do
			num_9 = num_9 + 1

			local var_11_27 = var_11_1

			if current_selection == num_9 then
				var_11_27 = var_11_2

				self:handle_edit_debug_keys(arg_11_1, k_2, "current_selected_filter_data_name", nil, table.size(InputFilters), arg_11_3)
			end

			fn(k_2, Vector3(arg_11_4, num_8, 900), var_11_27)

			num_8 = num_8 - num
		end

		local current_selected_filter_data_name = self.current_selected_filter_data_name

		if not current_selected_filter_data_name then
			self.current_selected_filter_data_name = nil
			self.selected_edit_type_index = nil
			var_11_11.filter_type = current_selected_filter_data_name

			local tbl = {}
			local edit_types_2 = InputFilters[current_selected_filter_data_name].edit_types
			local var_11_31

			for i_2, v_4 in ipairs(edit_types_2) do
				if v_4[2] == "number" then
					tbl[v_4[1]] = 1
				elseif v_4[2] == "keymap" then
					local var_11_32, var_11_33 = next(arg_11_5.keymaps, var_11_31)

					var_11_31 = var_11_32
					tbl[v_4[1]] = var_11_32
				end
			end

			var_11_11.filter_data = InputFilters[current_selected_filter_data_name].init(tbl)
			var_11_11.filter_function = InputFilters[current_selected_filter_data_name].update
		end
	elseif var_11_19[2] == "keymap" then
		local num_10 = 40
		local num_11 = 0
		local var_11_36 = var_11_19[3]

		for k_3, v_5 in pairs(arg_11_5.keymaps) do
			if not (not (v_5.input_mappings.n > 0) or not (v_5.input_mappings[1].n > 0) or v_5.input_mappings[1][3] ~= var_11_36) then
				num_11 = num_11 + 1
			end
		end

		local min = math.min(num_11, current_selection + 20)
		local max = math.max(1, min - 40)
		local min_2 = math.min(num_11, max + 40)
		local var_11_40
		local num_12 = 0

		for k_4, v_6 in pairs(arg_11_5.keymaps) do
			if not (not (v_6.input_mappings.n > 0) or not (v_6.input_mappings[1].n > 0) or v_6.input_mappings[1][3] ~= var_11_36) then
				num_12 = num_12 + 1

				local var_11_42 = var_11_1

				if current_selection == num_12 then
					var_11_42 = var_11_2

					self:handle_edit_debug_keys(arg_11_1, k_4, "selected_keymap", "selected_edit_type_index", num_11, arg_11_3)
				end

				if not (not (max <= num_12) or not (num_12 <= min_2)) then
					fn(k_4, Vector3(arg_11_4, num_8, 900), var_11_42)

					num_8 = num_8 - num
				end
			end
		end

		if not self.selected_keymap then
			if not var_11_19[4] then
				var_11_11.function_data[var_11_19[4]][var_11_19[1]] = self.selected_keymap
			else
				var_11_11.function_data[var_11_19[1]] = self.selected_keymap
			end

			self.selected_edit_type_index = nil
			self.selected_keymap = nil
		end
	elseif var_11_19[2] == "number" then
		local current_number_text = self.current_number_text

		current_number_text = current_number_text or ""

		fn("Enter new number: " .. current_number_text, Vector3(arg_11_4, num_8, 900), var_11_1)

		local number_edit_index = self.number_edit_index

		number_edit_index = number_edit_index or 1

		local number_edit_mode = self.number_edit_mode

		number_edit_mode = number_edit_mode or ""

		local keystrokes = Keyboard.keystrokes()

		for i12 = #keystrokes, 1, -1 do
			local var_11_47 = keystrokes[i12]

			if not ((tonumber(var_11_47) or var_11_47 == "." or not string.find(current_number_text, "%.")) and var_11_47 ~= ".") then
				table.remove(keystrokes, i12)
			end
		end

		local parse_strokes, var_11_49, var_11_50 = KeystrokeHelper.parse_strokes(current_number_text, number_edit_index, number_edit_mode, keystrokes)

		self.number_edit_index = var_11_49
		self.number_edit_mode = var_11_50
		self.current_number_text = parse_strokes

		if not arg_11_1:get("enter_key") then
			self.current_selection = 1
			self.selected_edit_type_index = nil

			local var_11_51 = tonumber(parse_strokes)

			self.current_number_text = nil
			self.number_edit_mode = nil
			self.number_edit_index = nil

			if not var_11_51 then
				var_11_11.function_data[var_11_19[1]] = var_11_51
			end
		end
	end
end

InputDebugger.finalize_update = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not self.input_manager then
		return
	end

	if not script_data.debug_enabled then
		return
	end

	self.num_updated_devices = 0

	local gui = self.gui

	if not script_data.input_debug_filters then
		self:debug_input_filters()
	end

	if not self.debug_edit_keymap then
		local get_service = self.input_manager:get_service("Debug")
		local var_12_2 = Color(128, 128, 192)
		local var_12_3 = Color(255, 255, 255)
		local var_12_4 = Color(192, 192, 64)
		local var_12_5 = Color(64, 192, 64)
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local current_selection = self.current_selection
		local update_input_service_data, var_12_10 = self:update_input_service_data(get_service, arg_12_3)

		if not update_input_service_data then
			return
		end

		local selected_input_type = self.selected_input_type
		local update_input_modify_type = self:update_input_modify_type(get_service, arg_12_3, var_12_10)

		if not selected_input_type then
			return
		end

		if selected_input_type == "keymap" then
			self:update_selected_keymap_edit(get_service, arg_12_2, arg_12_3, update_input_modify_type, update_input_service_data)
		elseif selected_input_type == "filters" then
			self:update_selected_filter_edit(get_service, arg_12_2, arg_12_3, update_input_modify_type, update_input_service_data)
		end
	elseif not self.input_device_data and IS_LINUX or not DebugKeyHandler.key_pressed("f4", "Enable keymap editor.", "Input", "left ctrl") then
		self.debug_edit_keymap = true

		self.input_manager:block_device_except_service("Debug", "keyboard")
		self.input_manager:block_device_except_service("Debug", "mouse")
	end
end

InputDebugger.handle_edit_debug_keys = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local current_selection = self.current_selection

	if not arg_13_1:get("enter_key") then
		self[arg_13_3] = arg_13_2
		self.current_selection = 1
	elseif not (not arg_13_1:get("up_key") and not (arg_13_6 > self.hold_timer)) then
		local num

		if current_selection - 1 > 0 then
			num = current_selection - 1

			if not num then
				-- Nothing
			end
		end

		num = arg_13_5

		::label_13_0::

		self.current_selection = num
		self.hold_timer = arg_13_6 + 0.1
	elseif not (not arg_13_1:get("down_key") and not (arg_13_6 > self.hold_timer)) then
		local flag

		flag = not (arg_13_5 < current_selection + 1) or not 1 or current_selection + 1
		self.current_selection = flag
		self.hold_timer = arg_13_6 + 0.1
	elseif not arg_13_1:get("backspace") and not arg_13_4 then
		self[arg_13_4] = nil
		self.current_selection = 1
	end
end
