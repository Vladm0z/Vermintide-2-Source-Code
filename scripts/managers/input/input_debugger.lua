-- chunkname: @scripts/managers/input/input_debugger.lua

local var_0_0 = 16
local var_0_1 = "arial"
local var_0_2 = "materials/fonts/" .. var_0_1
local var_0_3 = require("scripts/utils/serialize")

script_data.input_debug_device_state = script_data.input_debug_device_state or Development.parameter("input_debug_device_state")
script_data.input_debug_filters = script_data.input_debug_filters or Development.parameter("input_debug_filters")
InputDebugger = InputDebugger or {}

function InputDebugger.setup(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.input_device_data = {}
	arg_1_0.gui = World.create_screen_gui(arg_1_1, "material", "materials/fonts/gw_fonts", "immediate")
	arg_1_0.num_updated_devices = 0
	arg_1_0.input_manager = arg_1_2
	arg_1_0.hold_timer = 0
	arg_1_0.current_selection = 1
	arg_1_0.debug_edit_keymap = false
	arg_1_0.enabled = true
	arg_1_0.world = arg_1_1
end

function InputDebugger.clear(arg_2_0)
	arg_2_0.world = nil
	arg_2_0.gui = nil
	arg_2_0.input_manager = nil
end

function InputDebugger.pre_update_device(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if script_data.input_debug_device_state then
		-- block empty
	end
end

local var_0_4 = 100

function InputDebugger.post_update_device(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_0.input_manager then
		return
	end

	if not script_data.debug_enabled then
		return
	end

	if script_data.input_debug_device_state then
		local var_4_0 = arg_4_0.gui
		local var_4_1 = Color(255, 255, 255)
		local var_4_2 = Color(128, 128, 255)
		local var_4_3 = Color(128, 255, 128)
		local var_4_4 = arg_4_1:name()
		local var_4_5 = RESOLUTION_LOOKUP.res_w
		local var_4_6 = RESOLUTION_LOOKUP.res_h

		Gui.text(var_4_0, var_4_4, var_0_2, var_0_0, var_0_1, Vector3(100 + arg_4_0.num_updated_devices * var_0_4, var_4_6 - var_0_0, 900), var_4_1)

		local var_4_7 = arg_4_0.input_device_data[var_4_4] or {}

		arg_4_0.input_device_data[var_4_4] = var_4_7

		for iter_4_0, iter_4_1 in pairs(arg_4_2) do
			if type(iter_4_1) == "table" then
				local var_4_8 = var_4_7[iter_4_0] or {}

				var_4_7[iter_4_0] = var_4_8

				for iter_4_2, iter_4_3 in pairs(iter_4_1) do
					local var_4_9 = Script.type_name(iter_4_3)

					if var_4_9 == "number" and iter_4_3 > 0 then
						var_4_8[iter_4_2] = 1
					elseif var_4_9 == "Vector3" then
						if Vector3.distance(iter_4_3, Vector3.zero()) < 0.1 then
							if var_4_8[iter_4_2] and var_4_8[iter_4_2] > 0 then
								var_4_8[iter_4_2] = var_4_8[iter_4_2] - arg_4_3
							end
						else
							var_4_8[iter_4_2] = 1
						end
					elseif var_4_9 ~= "number" and iter_4_3 then
						var_4_8[iter_4_2] = 1
					elseif var_4_8[iter_4_2] and var_4_8[iter_4_2] > 0 then
						var_4_8[iter_4_2] = var_4_8[iter_4_2] - arg_4_3
					end
				end
			else
				var_4_7[iter_4_0] = iter_4_1
			end
		end

		local var_4_10 = 1

		for iter_4_4, iter_4_5 in pairs(arg_4_2) do
			local var_4_11 = var_4_7[iter_4_4]

			if type(iter_4_5) == "table" then
				var_4_10 = var_4_10 + 1

				Gui.text(var_4_0, "  " .. iter_4_4, var_0_2, var_0_0, var_0_1, Vector3(100 + arg_4_0.num_updated_devices * var_0_4, var_4_6 - var_0_0 * var_4_10, 900), var_4_2)

				for iter_4_6, iter_4_7 in pairs(iter_4_5) do
					if type(iter_4_6) == "number" then
						local var_4_12 = var_4_11[iter_4_6]

						if var_4_12 and var_4_12 > 0 then
							local var_4_13 = Color(255 * var_4_12, 128, 255, 128)
							local var_4_14 = iter_4_4 == "axis" and arg_4_1.axis_name(iter_4_6) or arg_4_1.button_name(iter_4_6)
							local var_4_15 = string.format("    [%s]:%s", var_4_14, tostring(iter_4_7))

							var_4_10 = var_4_10 + 1

							Gui.text(var_4_0, var_4_15, var_0_2, var_0_0, var_0_1, Vector3(100 + arg_4_0.num_updated_devices * var_0_4, var_4_6 - var_0_0 * var_4_10, 900), var_4_13)
						end
					end
				end
			end
		end

		arg_4_0.num_updated_devices = arg_4_0.num_updated_devices + 1
	end
end

local function var_0_5(arg_5_0, arg_5_1, arg_5_2)
	Gui.text(InputDebugger.gui, arg_5_0, var_0_2, var_0_0, var_0_1, arg_5_1, arg_5_2)
end

function InputDebugger.debug_input_filters(arg_6_0)
	local var_6_0 = Color(128, 128, 255)
	local var_6_1 = Color(128, 255, 128)
	local var_6_2 = 0
	local var_6_3 = RESOLUTION_LOOKUP.res_w
	local var_6_4 = RESOLUTION_LOOKUP.res_h

	for iter_6_0, iter_6_1 in pairs(arg_6_0.input_manager.input_services) do
		if iter_6_1.input_filters then
			var_0_5(string.format("Filters: %s", iter_6_0), Vector3(20, var_6_4 / 2 - var_0_0 * var_6_2, 900), var_6_0)

			var_6_2 = var_6_2 + 1

			for iter_6_2, iter_6_3 in pairs(iter_6_1.input_filters) do
				local var_6_5 = iter_6_3.filter_output
				local var_6_6 = InputFilters[iter_6_3.function_data.filter_type].update(iter_6_3.function_data, iter_6_1)

				var_0_5(string.format("[%s]:%s", var_6_5, tostring(var_6_6)), Vector3(20, var_6_4 / 2 - var_0_0 * var_6_2, 900), var_6_1)

				var_6_2 = var_6_2 + 1
			end
		end
	end
end

function InputDebugger.update_input_service_data(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Color(128, 128, 192)
	local var_7_1 = Color(255, 255, 255)
	local var_7_2 = Color(192, 192, 64)
	local var_7_3 = Color(64, 192, 64)

	if arg_7_1:get("esc") then
		if not arg_7_0.selected_input_service then
			arg_7_0.debug_edit_keymap = false

			arg_7_0.input_manager:device_unblock_all_services("keyboard")
			arg_7_0.input_manager:device_unblock_all_services("mouse")
		elseif not arg_7_0.selected_keymap and not arg_7_0.added_keymap then
			if arg_7_0.selected_input_type then
				arg_7_0.selected_input_type = nil
			else
				arg_7_0.selected_input_service = nil
			end

			arg_7_0.current_selection = 1

			return
		end
	end

	local var_7_4 = arg_7_0.selected_input_service
	local var_7_5 = arg_7_0.current_selection
	local var_7_6 = RESOLUTION_LOOKUP.res_w
	local var_7_7 = RESOLUTION_LOOKUP.res_h - 20 - var_0_0
	local var_7_8 = var_7_6 / 2
	local var_7_9 = 0
	local var_7_10

	if not var_7_4 then
		var_0_5("Select input service (press 's' to print it to console):", Vector3(var_7_8, var_7_7, 900), var_7_3)
	else
		if arg_7_0.selected_input_type then
			if arg_7_0.selected_keymap or arg_7_0.selected_input_filter_name then
				var_7_8 = var_7_8 - 360
			else
				var_7_8 = var_7_8 - 240
			end
		else
			var_7_8 = var_7_8 - 120
		end

		var_0_5("InputService", Vector3(var_7_8, var_7_7, 900), var_7_3)
	end

	local var_7_11 = var_7_7 - var_0_0

	for iter_7_0, iter_7_1 in pairs(arg_7_0.input_manager.input_services) do
		var_7_9 = var_7_9 + 1

		local var_7_12 = var_7_1

		if var_7_4 then
			if var_7_4 == iter_7_0 then
				var_7_10 = iter_7_1
				var_7_12 = var_7_0
			end
		elseif var_7_5 == var_7_9 then
			var_7_12 = var_7_2

			arg_7_0:handle_edit_debug_keys(arg_7_1, iter_7_0, "selected_input_service", nil, table.size(arg_7_0.input_manager.input_services), arg_7_2)

			if DebugKeyHandler.key_pressed("s", "Save Keybinding", "Input") then
				local var_7_13 = arg_7_0.input_manager:get_service(iter_7_0)
				local var_7_14 = var_7_13:generate_keybinding_setting()
				local var_7_15 = var_7_13:generate_filters_setting()

				print("---------------> SNIP SNIP <-----------------")

				local var_7_16 = var_0_3.save_simple(var_7_14)

				print(var_7_16)
				print("---------------> SNIP SNIP <-----------------")

				PlayerData.controls = PlayerData.controls or {}

				local var_7_17 = PlayerData.controls[iter_7_0] or {}

				PlayerData.controls[iter_7_0] = var_7_17
				var_7_17.keymap = var_7_14
				var_7_17.filters = var_7_15

				Managers.save:auto_save(SaveFileName, SaveData)
			end
		end

		var_0_5(iter_7_0, Vector3(var_7_8, var_7_11, 900), var_7_12)

		var_7_11 = var_7_11 - var_0_0
	end

	return var_7_10, var_7_8
end

function InputDebugger.update_selected_device(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = Color(128, 128, 192)
	local var_8_1 = Color(255, 255, 255)
	local var_8_2 = Color(192, 192, 64)
	local var_8_3 = Color(64, 192, 64)
	local var_8_4 = RESOLUTION_LOOKUP.res_w
	local var_8_5 = RESOLUTION_LOOKUP.res_h
	local var_8_6 = arg_8_0.current_selection

	var_0_5("Select button press type", Vector3(arg_8_2, arg_8_3, 900), var_8_3)

	arg_8_3 = arg_8_3 - var_0_0

	local var_8_7 = 0
	local var_8_8 = arg_8_0.selected_map_type

	for iter_8_0, iter_8_1 in pairs(InputAux.input_map_types) do
		var_8_7 = var_8_7 + 1

		local var_8_9 = var_8_1

		if var_8_8 then
			if var_8_8 == iter_8_0 then
				var_8_9 = var_8_0
			end
		elseif var_8_6 == var_8_7 then
			var_8_9 = var_8_2

			arg_8_0:handle_edit_debug_keys(arg_8_1, iter_8_0, "selected_map_type", "current_selected_device", table.size(InputAux.input_map_types), arg_8_4)
		end

		var_0_5(iter_8_0, Vector3(arg_8_2, arg_8_3, 900), var_8_9)

		arg_8_3 = arg_8_3 - var_0_0
	end

	if var_8_8 and var_8_8 ~= "axis" then
		var_0_5("Please press key (escape to cancel).", Vector3(var_8_4 / 2, var_8_5 / 2, 900), var_8_1)

		local var_8_10 = arg_8_0.current_selected_device
		local var_8_11 = InputAux.input_device_mapping[var_8_10][1]
		local var_8_12 = var_8_11.any_pressed()
		local var_8_13 = arg_8_0.last_pressed or var_8_12

		arg_8_0.last_pressed = var_8_13

		if var_8_13 then
			var_0_5(string.format("You pressed: %s (%d)", var_8_11.button_name(var_8_13), var_8_13), Vector3(var_8_4 / 2, var_8_5 / 2 - var_0_0 * var_8_7, 900), var_8_1)

			local var_8_14 = arg_8_0.key_selected_wait or arg_8_4 + 1

			arg_8_0.key_selected_wait = var_8_14

			if var_8_14 < arg_8_4 then
				local var_8_15 = arg_8_0.current_keybinds or {}

				arg_8_0.current_keybinds = var_8_15

				local var_8_16 = #var_8_15

				var_8_15[var_8_16 + 1] = var_8_10
				var_8_15[var_8_16 + 2] = var_8_13
				var_8_15[var_8_16 + 3] = var_8_8
				arg_8_0.key_selected_wait = nil
				arg_8_0.last_pressed = nil
				arg_8_0.selected_map_type = nil
				arg_8_0.current_selected_device = nil
			end
		end
	elseif var_8_8 == "axis" then
		-- block empty
	end
end

function InputDebugger.update_input_modify_type(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = Color(128, 128, 192)
	local var_9_1 = Color(255, 255, 255)
	local var_9_2 = Color(192, 192, 64)
	local var_9_3 = Color(64, 192, 64)
	local var_9_4 = RESOLUTION_LOOKUP.res_w
	local var_9_5 = RESOLUTION_LOOKUP.res_h - 20 - var_0_0

	arg_9_3 = arg_9_3 + 120

	local var_9_6 = arg_9_0.current_selection

	if not arg_9_0.selected_input_type then
		var_0_5("Select input filters to modify or keymap.", Vector3(arg_9_3, var_9_5, 900), var_9_3)
	end

	local var_9_7 = var_9_5 - var_0_0

	if arg_9_0.selected_input_type == "filters" then
		var_0_5("Input Filters", Vector3(arg_9_3, var_9_7, 900), var_9_0)
		var_0_5("Input Keymap", Vector3(arg_9_3, var_9_7 - var_0_0, 900), var_9_1)
	elseif arg_9_0.selected_input_type == "keymap" then
		var_0_5("Input Filters", Vector3(arg_9_3, var_9_7, 900), var_9_1)
		var_0_5("Input Keymap", Vector3(arg_9_3, var_9_7 - var_0_0, 900), var_9_0)
	else
		var_0_5("Input Filters", Vector3(arg_9_3, var_9_7, 900), var_9_6 == 1 and var_9_2 or var_9_1)
		var_0_5("Input Keymap", Vector3(arg_9_3, var_9_7 - var_0_0, 900), var_9_6 == 2 and var_9_2 or var_9_1)

		if arg_9_1:get("enter_key") then
			arg_9_0.selected_input_type = var_9_6 == 1 and "filters" or "keymap"
			arg_9_0.current_selection = 1
		elseif arg_9_1:get("up_key") and arg_9_2 > arg_9_0.hold_timer then
			arg_9_0.current_selection = 3 - var_9_6
			arg_9_0.hold_timer = arg_9_2 + 0.1
		elseif arg_9_1:get("down_key") and arg_9_2 > arg_9_0.hold_timer then
			arg_9_0.current_selection = 3 - var_9_6
			arg_9_0.hold_timer = arg_9_2 + 0.1
		elseif arg_9_1:get("backspace") then
			arg_9_0.selected_input_service = nil
			arg_9_0.current_selection = 1
		end
	end

	local var_9_8 = var_9_7 - var_0_0 * 2

	return arg_9_3
end

function InputDebugger.update_selected_keymap_edit(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = Color(128, 128, 192)
	local var_10_1 = Color(255, 255, 255)
	local var_10_2 = Color(192, 192, 64)
	local var_10_3 = Color(64, 192, 64)
	local var_10_4 = RESOLUTION_LOOKUP.res_w
	local var_10_5 = RESOLUTION_LOOKUP.res_h
	local var_10_6 = arg_10_0.current_selection
	local var_10_7 = var_10_5 - 20 - var_0_0

	arg_10_4 = arg_10_4 + 120

	local var_10_8 = arg_10_0.selected_keymap

	if not var_10_8 and not arg_10_0.added_keymap then
		var_0_5("Select keymap to modify. Press 'a' to add, 'd' to delete.", Vector3(arg_10_4, var_10_7, 900), var_10_3)
	else
		var_0_5("Keymap", Vector3(arg_10_4, var_10_7, 900), var_10_3)
	end

	local var_10_9 = var_10_7 - var_0_0
	local var_10_10 = 0
	local var_10_11 = arg_10_0.added_keymap

	if var_10_11 then
		if var_10_11.edit_mode == "device" then
			var_0_5(string.format("Keymap name: %s (press 'f' to finalize, 'esc' to cancel)", var_10_11.name), Vector3(arg_10_4, var_10_9, 900), var_10_3)
		else
			var_0_5("Keymap name: " .. var_10_11.name, Vector3(arg_10_4, var_10_9, 900), var_10_1)
		end

		if arg_10_1:get("esc") then
			arg_10_0.added_keymap = nil
			arg_10_0.current_selection = 1

			return
		end

		var_10_9 = var_10_9 - var_0_0

		if arg_10_0.current_keybinds then
			var_0_5("Current buttons:", Vector3(arg_10_4, var_10_9, 900), var_10_3)

			var_10_9 = var_10_9 - var_0_0

			local var_10_12 = arg_10_0.current_keybinds

			for iter_10_0 = 1, #var_10_12 / 3 do
				local var_10_13 = var_10_12[iter_10_0 * 3 - 2]
				local var_10_14 = InputAux.input_device_mapping[var_10_13][1].button_name(var_10_12[iter_10_0 * 3 - 1])

				var_0_5(string.format("%s:%s[%d] (%s)", var_10_13, var_10_14, var_10_12[iter_10_0 * 3 - 1], var_10_12[iter_10_0 * 3]), Vector3(arg_10_4, var_10_9, 900), var_10_0)

				var_10_9 = var_10_9 - var_0_0
			end

			if DebugKeyHandler.key_pressed("f", "Finalize Keybinding (store)", "Input") then
				local var_10_15 = var_10_11.name
				local var_10_16 = arg_10_0.input_manager:get_service(arg_10_0.selected_input_service)

				var_10_16:add_keymap(var_10_15)
				var_10_16:add_keybinding(var_10_15, unpack(arg_10_0.current_keybinds))

				arg_10_0.current_keybinds = nil
				arg_10_0.added_keymap = nil
				arg_10_0.current_selection = 1
				arg_10_0.current_selected_device = nil
				arg_10_0.selected_map_type = nil
				arg_10_0.key_selected_wait = nil
				arg_10_0.last_pressed = nil

				return
			end
		end

		local var_10_17 = var_10_11.edit_mode

		if not var_10_17 then
			local var_10_18 = arg_10_0.edit_index or 1
			local var_10_19 = arg_10_0.edit_mode
			local var_10_20 = Keyboard.keystrokes()
			local var_10_21, var_10_22, var_10_23 = KeystrokeHelper.parse_strokes(var_10_11.name, var_10_18, var_10_19, var_10_20)

			arg_10_0.edit_index = var_10_22
			arg_10_0.edit_mode = var_10_23
			var_10_11.name = var_10_21

			if arg_10_1:get("enter_key") then
				var_10_11.edit_mode = "device"
				arg_10_0.current_selection = 1
			end
		end

		local var_10_24 = arg_10_0.current_selected_device

		if var_10_17 == "device" then
			var_0_5("Select device-type:", Vector3(arg_10_4, var_10_9, 900), var_10_3)

			var_10_9 = var_10_9 - var_0_0

			local var_10_25 = 0

			for iter_10_1, iter_10_2 in pairs(arg_10_5.mapped_devices) do
				if #iter_10_2 > 0 then
					var_10_25 = var_10_25 + 1
				end
			end

			for iter_10_3, iter_10_4 in pairs(arg_10_5.mapped_devices) do
				if #iter_10_4 > 0 then
					local var_10_26 = var_10_1

					var_10_10 = var_10_10 + 1

					if var_10_24 then
						if var_10_24 == iter_10_3 then
							var_10_26 = var_10_0
						end
					elseif var_10_6 == var_10_10 then
						var_10_26 = var_10_2

						arg_10_0:handle_edit_debug_keys(arg_10_1, iter_10_3, "selected_input_type", nil, var_10_25, arg_10_3)
					end

					var_0_5(iter_10_3, Vector3(arg_10_4, var_10_9, 900), var_10_26)

					var_10_9 = var_10_9 - var_0_0
				end
			end
		end

		if var_10_24 then
			arg_10_0:update_selected_device(arg_10_1, arg_10_4, var_10_9, arg_10_3)
		end

		return
	end

	local var_10_27 = 40
	local var_10_28 = table.size(arg_10_5.keymaps)
	local var_10_29 = math.min(var_10_28, var_10_6 + 20)
	local var_10_30 = math.max(1, var_10_29 - 40)
	local var_10_31 = math.min(var_10_28, var_10_30 + 40)
	local var_10_32

	for iter_10_5, iter_10_6 in pairs(arg_10_5.keymaps) do
		var_10_10 = var_10_10 + 1

		local var_10_33 = var_10_1

		if var_10_8 then
			if var_10_8 == iter_10_5 then
				var_10_32 = iter_10_6
				var_10_33 = var_10_0
			end
		elseif var_10_6 == var_10_10 then
			var_10_33 = var_10_2

			if DebugKeyHandler.key_pressed("a", "Add Keymap", "Input") then
				arg_10_0.added_keymap = {
					name = ""
				}
			elseif DebugKeyHandler.key_pressed("d", "Delete Keymap", "Input") then
				arg_10_0.input_manager:get_service(arg_10_0.selected_input_service):remove_keymap(iter_10_5)
			else
				arg_10_0:handle_edit_debug_keys(arg_10_1, iter_10_5, "selected_keymap", "selected_input_type", var_10_28, arg_10_3)
			end
		end

		if var_10_30 <= var_10_10 and var_10_10 <= var_10_31 then
			var_0_5(iter_10_5, Vector3(arg_10_4, var_10_9, 900), var_10_33)

			var_10_9 = var_10_9 - var_0_0
		end
	end

	if not var_10_32 then
		return
	end

	if arg_10_1:get("esc") then
		arg_10_0.selected_input_type = nil
		arg_10_0.current_selection = 1

		return
	end

	arg_10_4 = arg_10_4 + 120

	local var_10_34 = var_10_5 - 20 - var_0_0

	var_0_5("Select keybinding to modify. Press 'a' to add, 'enter' to edit.", Vector3(arg_10_4, var_10_34, 900), var_10_3)

	local var_10_35 = var_10_34 - var_0_0

	var_0_5("   'del' to delete.", Vector3(arg_10_4, var_10_35, 900), var_10_3)

	local var_10_36 = var_10_35 - var_0_0
	local var_10_37 = arg_10_0.selected_binding
	local var_10_38
	local var_10_39
	local var_10_40
	local var_10_41 = 0
	local var_10_42 = 0

	for iter_10_7, iter_10_8 in ipairs(var_10_32.input_mappings) do
		var_10_42 = var_10_42 + iter_10_8.n
	end

	for iter_10_9, iter_10_10 in ipairs(var_10_32.input_mappings) do
		for iter_10_11 = 1, iter_10_10.n, 3 do
			var_10_41 = var_10_41 + 1

			local var_10_43 = iter_10_10[iter_10_11]
			local var_10_44 = InputAux.input_device_mapping[var_10_43][1]
			local var_10_45 = iter_10_10[iter_10_11 + 1]
			local var_10_46 = var_10_1

			if var_10_37 then
				if var_10_37 == var_10_41 then
					var_10_46 = var_10_0
					var_10_40 = iter_10_10
					var_10_38 = iter_10_9
					var_10_39 = math.ceil(iter_10_11 / 3)
				end
			elseif var_10_6 == var_10_41 then
				arg_10_0:handle_edit_debug_keys(arg_10_1, var_10_41, "selected_binding", "selected_keymap", var_10_42 / 3, arg_10_3)

				var_10_46 = var_10_2
			end

			local var_10_47 = string.format("[%d.%d] %s [%d] %s (%s)", iter_10_9, math.ceil(iter_10_11 / 3), var_10_43, var_10_45, var_10_44.button_name(var_10_45), iter_10_10[iter_10_11 + 2])

			var_0_5(var_10_47, Vector3(arg_10_4, var_10_36, 900), var_10_46)

			var_10_36 = var_10_36 - var_0_0
		end
	end

	if not var_10_40 then
		return
	end

	var_0_5("Please press new key (escape to cancel).", Vector3(var_10_4 / 2, var_10_5 / 2, 900), var_10_1)

	local var_10_48 = var_10_40[var_10_39 * 3 - 2]
	local var_10_49 = InputAux.input_device_mapping[var_10_48][1]
	local var_10_50 = var_10_49.any_pressed()

	arg_10_0.last_pressed = arg_10_0.last_pressed or var_10_50

	if arg_10_0.last_pressed then
		var_0_5(string.format("You pressed: %s (%d)", var_10_49.button_name(arg_10_0.last_pressed), arg_10_0.last_pressed), Vector3(var_10_4 / 2, var_10_5 / 2 - var_0_0, 900), var_10_1)

		local var_10_51 = arg_10_0.key_selected_wait or arg_10_3 + 1

		arg_10_0.key_selected_wait = var_10_51

		if var_10_51 < arg_10_3 then
			local var_10_52 = arg_10_0.selected_input_service

			arg_10_0.input_manager:get_service(var_10_52):change_keybinding(var_10_8, var_10_38, var_10_39, arg_10_0.last_pressed)

			arg_10_0.key_selected_wait = nil
			arg_10_0.selected_binding = nil
			arg_10_0.last_pressed = nil
		end
	end
end

function InputDebugger.update_selected_filter_edit(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = Color(128, 128, 192)
	local var_11_1 = Color(255, 255, 255)
	local var_11_2 = Color(192, 192, 64)
	local var_11_3 = Color(64, 192, 64)
	local var_11_4 = RESOLUTION_LOOKUP.res_w
	local var_11_5 = RESOLUTION_LOOKUP.res_h
	local var_11_6 = arg_11_0.current_selection
	local var_11_7 = var_11_5 - 20 - var_0_0

	arg_11_4 = arg_11_4 + 120

	local var_11_8 = arg_11_0.selected_input_filter_name

	if not var_11_8 then
		var_0_5("Select filter to modify. Press 'a' to add, 'd' to delete.", Vector3(arg_11_4, var_11_7, 900), var_11_3)
	else
		var_0_5("Filter", Vector3(arg_11_4, var_11_7, 900), var_11_3)
	end

	local var_11_9 = var_11_7 - var_0_0
	local var_11_10 = arg_11_5.input_filters
	local var_11_11
	local var_11_12 = 0

	for iter_11_0, iter_11_1 in pairs(var_11_10) do
		var_11_12 = var_11_12 + 1

		if var_11_8 then
			var_0_5(iter_11_0, Vector3(arg_11_4, var_11_9, 900), var_11_8 == iter_11_0 and var_11_0 or var_11_1)

			if var_11_8 == iter_11_0 then
				var_11_11 = iter_11_1
			end
		elseif var_11_12 == var_11_6 then
			var_0_5(iter_11_0, Vector3(arg_11_4, var_11_9, 900), var_11_2)
			arg_11_0:handle_edit_debug_keys(arg_11_1, iter_11_0, "selected_input_filter_name", "selected_input_type", table.size(var_11_10), arg_11_3)
		else
			var_0_5(iter_11_0, Vector3(arg_11_4, var_11_9, 900), var_11_1)
		end

		var_11_9 = var_11_9 - var_0_0
	end

	if not var_11_11 then
		return
	end

	arg_11_4 = arg_11_4 + 120

	local var_11_13 = var_11_5 - 20 - var_0_0

	var_0_5("Select filter-data to edit:", Vector3(arg_11_4, var_11_13, 900), var_11_3)

	local var_11_14 = var_11_13 - var_0_0
	local var_11_15 = arg_11_0.selected_edit_type_index
	local var_11_16 = var_11_15 == 1 and var_11_0 or not var_11_15 and var_11_6 == 1 and var_11_2 or var_11_1

	var_0_5("Type: " .. var_11_11.filter_type, Vector3(arg_11_4, var_11_14, 900), var_11_16)

	local var_11_17 = InputFilters[var_11_11.filter_type].edit_types

	if var_11_6 == 1 and not var_11_15 then
		arg_11_0:handle_edit_debug_keys(arg_11_1, 1, "selected_edit_type_index", "selected_input_filter_name", #var_11_17 + 1, arg_11_3)
	end

	local var_11_18 = var_11_14 - var_0_0
	local var_11_19

	for iter_11_2, iter_11_3 in ipairs(var_11_17) do
		local var_11_20 = var_11_1

		if var_11_15 then
			if var_11_15 == iter_11_2 + 1 then
				var_11_19 = iter_11_3
				var_11_20 = var_11_0
			end
		elseif var_11_6 == iter_11_2 + 1 then
			var_11_20 = var_11_2

			arg_11_0:handle_edit_debug_keys(arg_11_1, iter_11_2 + 1, "selected_edit_type_index", "selected_input_filter_name", #var_11_17 + 1, arg_11_3)
		end

		local var_11_21 = tostring(iter_11_3[4] and var_11_11.function_data[iter_11_3[4]][iter_11_3[1]] or var_11_11.function_data[iter_11_3[1]])
		local var_11_22 = string.format("%s [%s] (%s)", iter_11_3[1], iter_11_3[2], var_11_21)

		var_0_5(var_11_22, Vector3(arg_11_4, var_11_18, 900), var_11_20)

		var_11_18 = var_11_18 - var_0_0
	end

	if not var_11_15 then
		return
	end

	local var_11_23 = var_11_5 - 20 - var_0_0

	arg_11_4 = arg_11_4 + 120

	if var_11_15 == 1 then
		var_0_5("Select new filter type", Vector3(arg_11_4, var_11_23, 900), var_11_3)

		var_11_23 = var_11_23 - var_0_0

		local var_11_24 = 0

		for iter_11_4, iter_11_5 in pairs(InputFilters) do
			var_11_24 = var_11_24 + 1

			local var_11_25 = var_11_1

			if var_11_6 == var_11_24 then
				var_11_25 = var_11_2

				arg_11_0:handle_edit_debug_keys(arg_11_1, iter_11_4, "current_selected_filter_data_name", nil, table.size(InputFilters), arg_11_3)
			end

			var_0_5(iter_11_4, Vector3(arg_11_4, var_11_23, 900), var_11_25)

			var_11_23 = var_11_23 - var_0_0
		end

		local var_11_26 = arg_11_0.current_selected_filter_data_name

		if var_11_26 then
			arg_11_0.current_selected_filter_data_name = nil
			arg_11_0.selected_edit_type_index = nil
			var_11_11.filter_type = var_11_26

			local var_11_27 = {}
			local var_11_28 = InputFilters[var_11_26].edit_types
			local var_11_29

			for iter_11_6, iter_11_7 in ipairs(var_11_28) do
				if iter_11_7[2] == "number" then
					var_11_27[iter_11_7[1]] = 1
				elseif iter_11_7[2] == "keymap" then
					local var_11_30, var_11_31 = next(arg_11_5.keymaps, var_11_29)

					var_11_29 = var_11_30
					var_11_27[iter_11_7[1]] = var_11_30
				end
			end

			var_11_11.filter_data = InputFilters[var_11_26].init(var_11_27)
			var_11_11.filter_function = InputFilters[var_11_26].update
		end
	elseif var_11_19[2] == "keymap" then
		local var_11_32 = 40
		local var_11_33 = 0
		local var_11_34 = var_11_19[3]

		for iter_11_8, iter_11_9 in pairs(arg_11_5.keymaps) do
			if iter_11_9.input_mappings.n > 0 and iter_11_9.input_mappings[1].n > 0 and iter_11_9.input_mappings[1][3] == var_11_34 then
				var_11_33 = var_11_33 + 1
			end
		end

		local var_11_35 = math.min(var_11_33, var_11_6 + 20)
		local var_11_36 = math.max(1, var_11_35 - 40)
		local var_11_37 = math.min(var_11_33, var_11_36 + 40)
		local var_11_38
		local var_11_39 = 0

		for iter_11_10, iter_11_11 in pairs(arg_11_5.keymaps) do
			if iter_11_11.input_mappings.n > 0 and iter_11_11.input_mappings[1].n > 0 and iter_11_11.input_mappings[1][3] == var_11_34 then
				var_11_39 = var_11_39 + 1

				local var_11_40 = var_11_1

				if var_11_6 == var_11_39 then
					var_11_40 = var_11_2

					arg_11_0:handle_edit_debug_keys(arg_11_1, iter_11_10, "selected_keymap", "selected_edit_type_index", var_11_33, arg_11_3)
				end

				if var_11_36 <= var_11_39 and var_11_39 <= var_11_37 then
					var_0_5(iter_11_10, Vector3(arg_11_4, var_11_23, 900), var_11_40)

					var_11_23 = var_11_23 - var_0_0
				end
			end
		end

		if arg_11_0.selected_keymap then
			if var_11_19[4] then
				var_11_11.function_data[var_11_19[4]][var_11_19[1]] = arg_11_0.selected_keymap
			else
				var_11_11.function_data[var_11_19[1]] = arg_11_0.selected_keymap
			end

			arg_11_0.selected_edit_type_index = nil
			arg_11_0.selected_keymap = nil
		end
	elseif var_11_19[2] == "number" then
		local var_11_41 = arg_11_0.current_number_text or ""

		var_0_5("Enter new number: " .. var_11_41, Vector3(arg_11_4, var_11_23, 900), var_11_1)

		local var_11_42 = arg_11_0.number_edit_index or 1
		local var_11_43 = arg_11_0.number_edit_mode or ""
		local var_11_44 = Keyboard.keystrokes()

		for iter_11_12 = #var_11_44, 1, -1 do
			local var_11_45 = var_11_44[iter_11_12]

			if not tonumber(var_11_45) and var_11_45 ~= "." or string.find(var_11_41, "%.") and var_11_45 == "." then
				table.remove(var_11_44, iter_11_12)
			end
		end

		local var_11_46, var_11_47, var_11_48 = KeystrokeHelper.parse_strokes(var_11_41, var_11_42, var_11_43, var_11_44)

		arg_11_0.number_edit_index = var_11_47
		arg_11_0.number_edit_mode = var_11_48
		arg_11_0.current_number_text = var_11_46

		if arg_11_1:get("enter_key") then
			arg_11_0.current_selection = 1
			arg_11_0.selected_edit_type_index = nil

			local var_11_49 = tonumber(var_11_46)

			arg_11_0.current_number_text = nil
			arg_11_0.number_edit_mode = nil
			arg_11_0.number_edit_index = nil

			if var_11_49 then
				var_11_11.function_data[var_11_19[1]] = var_11_49
			end
		end
	end
end

function InputDebugger.finalize_update(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not arg_12_0.input_manager then
		return
	end

	if not script_data.debug_enabled then
		return
	end

	arg_12_0.num_updated_devices = 0

	local var_12_0 = arg_12_0.gui

	if script_data.input_debug_filters then
		arg_12_0:debug_input_filters()
	end

	if arg_12_0.debug_edit_keymap then
		local var_12_1 = arg_12_0.input_manager:get_service("Debug")
		local var_12_2 = Color(128, 128, 192)
		local var_12_3 = Color(255, 255, 255)
		local var_12_4 = Color(192, 192, 64)
		local var_12_5 = Color(64, 192, 64)
		local var_12_6 = RESOLUTION_LOOKUP.res_w
		local var_12_7 = RESOLUTION_LOOKUP.res_h
		local var_12_8 = arg_12_0.current_selection
		local var_12_9, var_12_10 = arg_12_0:update_input_service_data(var_12_1, arg_12_3)

		if not var_12_9 then
			return
		end

		local var_12_11 = arg_12_0.selected_input_type
		local var_12_12 = arg_12_0:update_input_modify_type(var_12_1, arg_12_3, var_12_10)

		if not var_12_11 then
			return
		end

		if var_12_11 == "keymap" then
			arg_12_0:update_selected_keymap_edit(var_12_1, arg_12_2, arg_12_3, var_12_12, var_12_9)
		elseif var_12_11 == "filters" then
			arg_12_0:update_selected_filter_edit(var_12_1, arg_12_2, arg_12_3, var_12_12, var_12_9)
		end
	elseif arg_12_0.input_device_data and not IS_LINUX and DebugKeyHandler.key_pressed("f4", "Enable keymap editor.", "Input", "left ctrl") then
		arg_12_0.debug_edit_keymap = true

		arg_12_0.input_manager:block_device_except_service("Debug", "keyboard")
		arg_12_0.input_manager:block_device_except_service("Debug", "mouse")
	end
end

function InputDebugger.handle_edit_debug_keys(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = arg_13_0.current_selection

	if arg_13_1:get("enter_key") then
		arg_13_0[arg_13_3] = arg_13_2
		arg_13_0.current_selection = 1
	elseif arg_13_1:get("up_key") and arg_13_6 > arg_13_0.hold_timer then
		arg_13_0.current_selection = var_13_0 - 1 > 0 and var_13_0 - 1 or arg_13_5
		arg_13_0.hold_timer = arg_13_6 + 0.1
	elseif arg_13_1:get("down_key") and arg_13_6 > arg_13_0.hold_timer then
		arg_13_0.current_selection = arg_13_5 < var_13_0 + 1 and 1 or var_13_0 + 1
		arg_13_0.hold_timer = arg_13_6 + 0.1
	elseif arg_13_1:get("backspace") and arg_13_4 then
		arg_13_0[arg_13_4] = nil
		arg_13_0.current_selection = 1
	end
end
