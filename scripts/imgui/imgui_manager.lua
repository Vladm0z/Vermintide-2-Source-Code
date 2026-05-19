-- chunkname: @scripts/imgui/imgui_manager.lua

ImguiManager = class(ImguiManager)
ImguiKeymaps = {
	win32 = {
		toggle_imgui = {
			"keyboard",
			"f3",
			"pressed"
		}
	}
}

require("scripts/imgui/imgui_configuration_settings")

function ImguiManager.init(arg_1_0)
	arg_1_0._open = false
	arg_1_0._persistant_windows = 0
	arg_1_0._guis_by_category = {}
	arg_1_0._key_bindings = {}
	arg_1_0._input_stack = 0

	for iter_1_0, iter_1_1 in pairs(ImguiConfigurationSettings) do
		require(iter_1_1.file)

		local var_1_0 = _G[iter_1_1.class]

		arg_1_0:add_gui(var_1_0, iter_1_1.category, iter_1_1.name)
	end

	arg_1_0:_load_settings()
end

local function var_0_0(arg_2_0, arg_2_1)
	for iter_2_0 = 1, #arg_2_0 do
		local var_2_0 = arg_2_0[iter_2_0].name

		if var_2_0 == arg_2_1 then
			return iter_2_0, true
		elseif arg_2_1 < var_2_0 then
			return iter_2_0, false
		end
	end

	return #arg_2_0 + 1, false
end

function ImguiManager._call_on_guis(arg_3_0, arg_3_1, ...)
	for iter_3_0, iter_3_1 in pairs(arg_3_0._guis_by_category) do
		for iter_3_2, iter_3_3 in pairs(iter_3_1.list) do
			local var_3_0 = iter_3_3.gui
			local var_3_1 = var_3_0[arg_3_1]

			if var_3_1 then
				var_3_1(var_3_0, ...)
			end
		end
	end
end

function ImguiManager.add_gui(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_1:new()

	assert(var_4_0.init)
	assert(var_4_0.update)
	assert(var_4_0.draw)
	assert(var_4_0.is_persistent)

	local var_4_1, var_4_2 = var_0_0(arg_4_0._guis_by_category, arg_4_2)

	if not var_4_2 then
		table.insert(arg_4_0._guis_by_category, var_4_1, {
			name = arg_4_2,
			list = {}
		})

		arg_4_0._key_bindings[arg_4_2] = {}
	end

	local var_4_3 = arg_4_0._guis_by_category[var_4_1].list
	local var_4_4 = var_0_0(var_4_3, arg_4_3)

	table.insert(var_4_3, var_4_4, {
		gui = var_4_0,
		name = arg_4_3,
		enabled = arg_4_4
	})

	if not arg_4_0._key_bindings[arg_4_2][arg_4_3] then
		arg_4_0._key_bindings[arg_4_2][arg_4_3] = {
			id = 0,
			keybind = {}
		}
	end

	local var_4_5 = arg_4_0._key_bindings[arg_4_2]

	for iter_4_0, iter_4_1 in pairs(var_4_3) do
		var_4_5[iter_4_1.name].id = iter_4_0
	end
end

function ImguiManager.destroy(arg_5_0)
	return arg_5_0:_call_on_guis("destroy")
end

function ImguiManager.set_open(arg_6_0, arg_6_1)
	if arg_6_1 ~= arg_6_0._open then
		if arg_6_1 then
			Imgui.open_imgui()
			arg_6_0:_capture_input()
		else
			if arg_6_0._persistant_windows == 0 then
				Imgui.close_imgui()
			end

			arg_6_0:_release_input()

			arg_6_0._settings = false
		end

		arg_6_0._open = arg_6_1
	end
end

function ImguiManager.update(arg_7_0, arg_7_1, arg_7_2)
	if Keyboard.pressed(Keyboard.button_index("f3")) then
		arg_7_0:set_open(not arg_7_0._open)
	end

	if arg_7_0._open then
		arg_7_0:update_main_menu()
	end

	arg_7_0:update_guis(arg_7_1, arg_7_2)
	arg_7_0:_update_keybinds()
end

function ImguiManager.post_update(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:post_update_guis(arg_8_1, arg_8_2)
end

function ImguiManager.post_update_guis(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._persistant_windows
	local var_9_1 = arg_9_0._open

	for iter_9_0, iter_9_1 in pairs(arg_9_0._guis_by_category) do
		for iter_9_2, iter_9_3 in pairs(iter_9_1.list) do
			if iter_9_3.enabled then
				local var_9_2 = iter_9_3.gui

				if var_9_2.post_update then
					var_9_2:post_update(arg_9_1, arg_9_2, var_9_1)

					if var_9_1 or var_9_2:is_persistent() or iter_9_3.opened_with_keybind then
						if var_9_2:post_draw(var_9_1, arg_9_1, arg_9_2) then
							arg_9_0:_set_gui_enabled(iter_9_3, false)
						end

						arg_9_0._persistant_windows = arg_9_0._persistant_windows + 1
					end
				end
			end
		end
	end

	if not var_9_1 and var_9_0 <= 0 and arg_9_0._persistant_windows > 0 then
		Imgui.open_imgui()
	elseif not var_9_1 and var_9_0 > 0 and arg_9_0._persistant_windows <= 0 then
		Imgui.close_imgui()
	end
end

function ImguiManager.update_main_menu(arg_10_0)
	if Imgui.begin_main_menu_bar() then
		for iter_10_0, iter_10_1 in pairs(arg_10_0._guis_by_category) do
			local var_10_0 = iter_10_1.name
			local var_10_1 = iter_10_1.list

			if Imgui.begin_menu(var_10_0) then
				for iter_10_2, iter_10_3 in pairs(var_10_1) do
					local var_10_2 = arg_10_0:_get_keybind_text(var_10_0, iter_10_3.name)

					if Imgui.menu_item(iter_10_3.name .. var_10_2) then
						arg_10_0:_set_gui_enabled(iter_10_3, not iter_10_3.enabled)
					end
				end

				Imgui.end_menu()
			end
		end

		if Imgui.menu_item("[Keybinds]") then
			arg_10_0._settings = not arg_10_0._settings
		end

		if Imgui.menu_item("[X]") then
			arg_10_0:set_open(false)
		end

		Imgui.end_main_menu_bar()
	end
end

function ImguiManager.update_guis(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._persistant_windows

	arg_11_0._persistant_windows = 0

	local var_11_1 = arg_11_0._open

	for iter_11_0, iter_11_1 in pairs(arg_11_0._guis_by_category) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1.list) do
			if iter_11_3.enabled then
				local var_11_2 = iter_11_3.gui

				var_11_2:update(arg_11_1, arg_11_2, var_11_1)

				if var_11_1 or var_11_2:is_persistent() or iter_11_3.opened_with_keybind then
					if var_11_2:draw(var_11_1, arg_11_1, arg_11_2) then
						arg_11_0:_set_gui_enabled(iter_11_3, false)
					end

					arg_11_0._persistant_windows = arg_11_0._persistant_windows + 1
				end
			end
		end
	end

	if not var_11_1 and var_11_0 <= 0 and arg_11_0._persistant_windows > 0 then
		Imgui.open_imgui()
	elseif not var_11_1 and var_11_0 > 0 and arg_11_0._persistant_windows <= 0 then
		Imgui.close_imgui()
	end

	if arg_11_0._settings then
		if arg_11_0:_draw_keybind_settings() then
			arg_11_0._settings = false
		end
	else
		arg_11_0._rebind_action = nil
	end
end

function ImguiManager.on_round_start(arg_12_0, ...)
	return arg_12_0:_call_on_guis("on_round_start", ...)
end

function ImguiManager.on_round_end(arg_13_0, ...)
	return arg_13_0:_call_on_guis("on_round_end", ...)
end

function ImguiManager.on_venture_start(arg_14_0, ...)
	return arg_14_0:_call_on_guis("on_venture_start", ...)
end

function ImguiManager.on_venture_end(arg_15_0, ...)
	return arg_15_0:_call_on_guis("on_venture_end", ...)
end

function ImguiManager._input_manager_do(arg_16_0, arg_16_1)
	local var_16_0 = Managers.input

	if var_16_0 then
		if not var_16_0:get_input_service("imgui") then
			var_16_0:create_input_service("imgui", "ImguiKeymaps")
			var_16_0:map_device_to_service("imgui", "keyboard")
			var_16_0:map_device_to_service("imgui", "gamepad")
			var_16_0:map_device_to_service("imgui", "mouse")
		end

		var_16_0[arg_16_1](var_16_0, ALL_INPUT_METHODS, 1, "imgui", "ImguiManager")
	end
end

function ImguiManager._set_gui_enabled(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if arg_17_2 then
		if arg_17_1.gui.on_show then
			arg_17_1.gui:on_show()
		end

		if arg_17_3 then
			arg_17_0:_capture_input()

			arg_17_1.opened_with_keybind = true
		end
	else
		if arg_17_1.gui.on_hide then
			arg_17_1.gui:on_hide()
		end

		if arg_17_1.opened_with_keybind then
			arg_17_0:_release_input()

			arg_17_1.opened_with_keybind = false
		end
	end

	arg_17_1.enabled = arg_17_2
end

function ImguiManager._update_keybinds(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0._key_bindings) do
		for iter_18_2, iter_18_3 in pairs(iter_18_1) do
			local var_18_0 = iter_18_3.keybind
			local var_18_1 = #var_18_0

			if var_18_1 > 0 then
				local var_18_2 = true

				for iter_18_4 = 1, var_18_1 - 1 do
					local var_18_3 = Keyboard.button_index(var_18_0[iter_18_4])

					if not var_18_3 or Keyboard.button(var_18_3) <= 0 then
						var_18_2 = false

						break
					end
				end

				if var_18_2 then
					local var_18_4 = Keyboard.button_index(var_18_0[var_18_1])

					if var_18_4 and Keyboard.pressed(var_18_4) then
						local var_18_5, var_18_6 = table.find_by_key(arg_18_0._guis_by_category, "name", iter_18_0)
						local var_18_7 = var_18_6.list[iter_18_3.id]

						arg_18_0:_set_gui_enabled(var_18_7, not var_18_7.enabled, true)
					end
				end
			end
		end
	end
end

function ImguiManager._draw_keybind_settings(arg_19_0)
	local var_19_0 = Imgui.begin_window("Keybinds")

	Imgui.text("<esc> to clear keybind")

	for iter_19_0, iter_19_1 in pairs(arg_19_0._key_bindings) do
		Imgui.text(iter_19_0)
		Imgui.tree_push(iter_19_0)

		for iter_19_2, iter_19_3 in pairs(iter_19_1) do
			Imgui.tree_push(iter_19_2)

			local var_19_1 = iter_19_3.keybind

			for iter_19_4 = 1, #var_19_1 do
				local var_19_2 = arg_19_0._rebind_action == iter_19_2 and arg_19_0._rebind_category == iter_19_0 and arg_19_0._rebind_id == iter_19_4 and "<?>" or var_19_1[iter_19_4]

				if Imgui.button(var_19_2) then
					arg_19_0._rebind_id = iter_19_4
					arg_19_0._rebind_action = iter_19_2
					arg_19_0._rebind_category = iter_19_0
				end

				Imgui.same_line()
			end

			if Imgui.button("+", 20, 20) then
				local var_19_3 = #var_19_1 + 1

				var_19_1[var_19_3] = ""
				arg_19_0._rebind_id = var_19_3
				arg_19_0._rebind_action = iter_19_2
				arg_19_0._rebind_category = iter_19_0
			end

			Imgui.same_line()
			Imgui.text(iter_19_2)
			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end

	if arg_19_0._rebind_action then
		local var_19_4 = Keyboard.any_pressed()

		if var_19_4 then
			local var_19_5 = Keyboard.button_name(var_19_4)
			local var_19_6 = arg_19_0._key_bindings[arg_19_0._rebind_category][arg_19_0._rebind_action].keybind

			if var_19_5 == "esc" then
				table.remove(var_19_6, arg_19_0._rebind_id)
			else
				var_19_6[arg_19_0._rebind_id] = var_19_5
			end

			arg_19_0._rebind_action = nil
			arg_19_0._rebind_category = nil
			arg_19_0._rebind_id = nil

			arg_19_0:_save_settings()
		end
	end

	Imgui.end_window()

	return var_19_0
end

function ImguiManager._get_keybind_text(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._key_bindings[arg_20_1][arg_20_2].keybind
	local var_20_1 = #var_20_0

	if var_20_1 > 0 then
		local var_20_2 = " ["

		for iter_20_0 = 1, var_20_1 do
			if iter_20_0 > 1 then
				var_20_2 = var_20_2 .. "+"
			end

			var_20_2 = var_20_2 .. var_20_0[iter_20_0]
		end

		local var_20_3 = var_20_2 .. "]"

		return string.upper(var_20_3)
	end

	return ""
end

function ImguiManager._save_settings(arg_21_0)
	Development.set_setting("ImguiManager_keybinds", arg_21_0._key_bindings)
	Application.save_user_settings()
end

function ImguiManager._load_settings(arg_22_0)
	local var_22_0 = Development.setting("ImguiManager_keybinds") or {}

	for iter_22_0, iter_22_1 in pairs(arg_22_0._key_bindings) do
		local var_22_1 = var_22_0[iter_22_0]

		if var_22_1 then
			for iter_22_2, iter_22_3 in pairs(iter_22_1) do
				iter_22_1[iter_22_2].keybind = var_22_1[iter_22_2] and var_22_1[iter_22_2].keybind or iter_22_1[iter_22_2].keybind
			end
		end
	end
end

function ImguiManager._capture_input(arg_23_0)
	local var_23_0 = arg_23_0._input_stack

	if var_23_0 == 0 then
		arg_23_0:_input_manager_do("capture_input")
		ShowCursorStack.show("ImguiManager")
		Imgui.enable_imgui_input_system(Imgui.KEYBOARD)
		Imgui.enable_imgui_input_system(Imgui.MOUSE)
		Imgui.enable_imgui_input_system(Imgui.GAMEPAD)
	end

	arg_23_0._input_stack = var_23_0 + 1
end

function ImguiManager._release_input(arg_24_0)
	local var_24_0 = arg_24_0._input_stack - 1

	assert(var_24_0 >= 0, "imgui input stack underflow")

	if var_24_0 == 0 then
		arg_24_0:_input_manager_do("release_input")
		ShowCursorStack.hide("ImguiManager")
		Imgui.disable_imgui_input_system(Imgui.KEYBOARD)
		Imgui.disable_imgui_input_system(Imgui.GAMEPAD)
		Imgui.disable_imgui_input_system(Imgui.MOUSE)
	end

	arg_24_0._input_stack = var_24_0
end

ImguiX = ImguiX or {}

function ImguiX.color_edit_4(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	arg_25_2, arg_25_3, arg_25_4, arg_25_1 = Imgui.color_edit_4(arg_25_0, arg_25_2 / 255, arg_25_3 / 255, arg_25_4 / 255, arg_25_1 / 255)

	return arg_25_1 * 255, arg_25_2 * 255, arg_25_3 * 255, arg_25_4 * 255
end

function ImguiX.heading(arg_26_0, arg_26_1, ...)
	Imgui.text_colored(arg_26_0 .. ":", 200, 200, 255, 255)
	Imgui.same_line()
	Imgui.text(string.format(arg_26_1, ...))
end

function ImguiX.combo_search(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = Imgui.input_text("Search", arg_27_2)

	if var_27_0 ~= arg_27_2 then
		arg_27_1 = {}

		local var_27_1 = string.gsub(string.lower(var_27_0), " ", ".-")

		for iter_27_0, iter_27_1 in ipairs(arg_27_3) do
			if string.find(string.lower(iter_27_1), var_27_1) then
				arg_27_1[#arg_27_1 + 1] = iter_27_1
			elseif arg_27_4 then
				for iter_27_2, iter_27_3 in ipairs(arg_27_4) do
					if string.find(string.lower(iter_27_3[iter_27_0]), var_27_1) then
						arg_27_1[#arg_27_1 + 1] = iter_27_1

						break
					end
				end
			end
		end

		arg_27_0 = -1
		arg_27_2 = var_27_0
	end

	arg_27_0 = Imgui.list_box("##element_select", arg_27_0, arg_27_1, 5)

	return arg_27_0, arg_27_1, arg_27_2
end
