-- chunkname: @scripts/imgui/imgui_debug_menu.lua

ImguiDebugMenu = class(ImguiDebugMenu)

local function var_0_0(arg_1_0, arg_1_1)
	return arg_1_0.setting_name < arg_1_1.setting_name
end

local function var_0_1(arg_2_0, arg_2_1)
	return arg_2_0.name < arg_2_1.name
end

ImguiDebugMenu.init = function (arg_3_0)
	arg_3_0._needle = ""

	local var_3_0 = require("scripts/utils/debug_screen_config").settings
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		var_3_1[iter_3_1.category] = var_3_1[iter_3_1.category] or {}

		table.insert(var_3_1[iter_3_1.category], iter_3_1)
	end

	arg_3_0._settings = var_3_0
	arg_3_0._settings_categories = {}

	for iter_3_2, iter_3_3 in pairs(var_3_1) do
		table.sort(iter_3_3, var_0_0)
		table.insert(arg_3_0._settings_categories, {
			name = iter_3_2,
			list = iter_3_3
		})
	end

	table.sort(arg_3_0._settings_categories, var_0_1)

	arg_3_0._options = {}
end

ImguiDebugMenu.update = function (arg_4_0)
	return
end

local var_0_2 = string.find
local var_0_3 = string.lower

local function var_0_4(arg_5_0, arg_5_1)
	return var_0_2(var_0_3(arg_5_0), var_0_3(arg_5_1))
end

ImguiDebugMenu._find_needle = function (arg_6_0, arg_6_1, arg_6_2)
	return var_0_4(arg_6_1.setting_name, arg_6_2) or var_0_4(arg_6_1.description, arg_6_2) or var_0_4(arg_6_1.category, arg_6_2)
end

ImguiDebugMenu._find_needle_list = function (arg_7_0, arg_7_1, arg_7_2)
	for iter_7_0 = 1, #arg_7_1 do
		if arg_7_0:_find_needle(arg_7_1[iter_7_0], arg_7_2) then
			return true
		end
	end

	return false
end

ImguiDebugMenu.draw = function (arg_8_0)
	local var_8_0 = Imgui.begin_window("DebugMenu")
	local var_8_1 = Imgui.input_text("Search", arg_8_0._needle)

	arg_8_0._needle = var_8_1

	Imgui.begin_child_window("Settings", 0, 0, true)

	local var_8_2 = true

	for iter_8_0, iter_8_1 in pairs(arg_8_0._settings_categories) do
		local var_8_3 = iter_8_1.name
		local var_8_4 = iter_8_1.list

		if arg_8_0:_find_needle_list(var_8_4, var_8_1) then
			var_8_2 = false

			if Imgui.collapsing_header(var_8_3, false) then
				for iter_8_2 = 1, #var_8_4 do
					local var_8_5 = var_8_4[iter_8_2]

					if arg_8_0:_find_needle(var_8_5, var_8_1) then
						arg_8_0:_show_debug_setting(var_8_5)
					end
				end

				Imgui.tree_pop()
			end
		end
	end

	if var_8_2 then
		Imgui.text("No matches.")
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return var_8_0
end

ImguiDebugMenu._set_setting = function (arg_9_0, arg_9_1, arg_9_2)
	Development.set_setting(arg_9_1, arg_9_2)

	script_data[arg_9_1] = arg_9_2

	Development.clear_param_cache(arg_9_1)
end

ImguiDebugMenu._show_debug_setting = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.setting_name

	Imgui.text(var_10_0)

	if Imgui.is_item_hovered() then
		Imgui.begin_tool_tip()
		Imgui.text_colored(var_10_0, 127, 127, 127, 255)
		Imgui.text(arg_10_1.description)
		Imgui.end_tool_tip()
	end

	Imgui.same_line(360 - Imgui.calculate_text_size(var_10_0))
	Imgui.spacing(0)

	if arg_10_1.is_boolean then
		Imgui.same_line()

		local var_10_1 = script_data[var_10_0]

		if Imgui.radio_button("false##" .. var_10_0, var_10_1 == false) then
			var_10_1 = false
		end

		Imgui.same_line()

		if Imgui.radio_button("true##" .. var_10_0, var_10_1 == true) then
			var_10_1 = true
		end

		Imgui.same_line()

		if Imgui.small_button("Reset") then
			var_10_1 = nil
		end

		arg_10_0:_set_setting(var_10_0, var_10_1)
	elseif arg_10_1.load_items_source_func or arg_10_1.item_source then
		Imgui.same_line()

		local var_10_2

		if arg_10_1.load_items_source_func then
			var_10_2 = arg_10_0._options

			arg_10_1.load_items_source_func(var_10_2)
		else
			var_10_2 = arg_10_1.item_source
		end

		local var_10_3 = table.find(var_10_2, script_data[var_10_0]) or 0

		Imgui.push_item_width(200)

		local var_10_4 = Imgui.combo("Choice", var_10_3, var_10_2)

		Imgui.pop_item_width()
		Imgui.same_line()

		if Imgui.small_button("Reset") then
			var_10_4 = 0
		end

		arg_10_0:_set_setting(var_10_0, var_10_2[var_10_4])

		if arg_10_1.func then
			Imgui.same_line()

			if Imgui.small_button("Execute") then
				arg_10_1.func(var_10_2, var_10_4)
			end
		end
	elseif arg_10_1.preset then
		Imgui.same_line()

		if Imgui.small_button("Activate preset") then
			for iter_10_0, iter_10_1 in pairs(arg_10_1.preset) do
				arg_10_0:_set_setting(iter_10_0, iter_10_1)
			end
		end
	elseif arg_10_1.command_list then
		for iter_10_2, iter_10_3 in ipairs(arg_10_1.command_list) do
			Imgui.same_line()

			if Imgui.small_button(iter_10_3.description) then
				for iter_10_4, iter_10_5 in ipairs(iter_10_3.commands) do
					Application.console_command(unpack(iter_10_5))
				end
			end
		end
	elseif arg_10_1.func then
		Imgui.same_line()

		if Imgui.small_button("Execute") then
			arg_10_1.func()
		end
	end
end

ImguiDebugMenu.is_persistent = function (arg_11_0)
	return false
end
