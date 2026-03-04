-- chunkname: @scripts/imgui/imgui_teleport_tool.lua

ImguiTeleportTool = class(ImguiTeleportTool)

local var_0_0 = true
local var_0_1 = {}

ImguiTeleportTool.init = function (arg_1_0)
	arg_1_0._current_level = nil
	arg_1_0._teleport_name_map = {}
	arg_1_0._teleport_point_map = {}
	arg_1_0._filter_text = ""
	arg_1_0._filtered_teleport_names = {}
	arg_1_0._filtered_teleport_ids = {}
	arg_1_0._selected_teleport = 0
	arg_1_0._register_point_name = ""
	arg_1_0._register_point_active = false
	arg_1_0._is_persistent = false
	arg_1_0._key_bindings = {
		select_down = "down",
		teleport = "home",
		quick_teleport = "home",
		teleport_from_clipboard = "numpad enter",
		confirm = "enter",
		register_new = "insert",
		delete = "delete",
		select_up = "up",
		save_to_clipboatd = "numpad 0"
	}
	arg_1_0._custom_target_point = {
		0,
		0,
		0,
		0,
		0,
		0,
		1
	}
	arg_1_0._key_states = {}
	arg_1_0._rebind_action = nil

	arg_1_0:_load_points()
	arg_1_0:_refresh_filter()
end

ImguiTeleportTool.update = function (arg_2_0)
	if var_0_0 then
		arg_2_0:init()

		var_0_0 = false
	end

	local var_2_0 = Managers.state.game_mode
	local var_2_1 = var_2_0 and var_2_0:level_key()

	if arg_2_0._current_level == nil and var_2_1 or var_2_1 ~= arg_2_0._current_level then
		arg_2_0._current_level = var_2_1

		arg_2_0:_refresh_filter()
	end
end

ImguiTeleportTool.is_persistent = function (arg_3_0)
	return arg_3_0._is_persistent
end

ImguiTeleportTool.draw = function (arg_4_0, arg_4_1)
	local var_4_0 = false
	local var_4_1 = Imgui.begin_window("Teleport Tool", "menu_bar")

	Imgui.set_window_size(300, 0, "once")

	if Imgui.begin_menu_bar() then
		if Imgui.menu_item("Configure keybinds") then
			var_4_0 = true
		end

		Imgui.end_menu_bar()
	end

	if var_4_0 then
		Imgui.open_popup("config_keybinds_popup")
	end

	arg_4_0._is_persistent = Imgui.checkbox("Keep on screen", arg_4_0._is_persistent)

	Imgui.separator()
	Imgui.text("Current level: ")
	Imgui.same_line()
	Imgui.text(tostring(arg_4_0._current_level))

	local var_4_2 = arg_4_0._filter_text

	arg_4_0._filter_text = Imgui.input_text("Search", arg_4_0._filter_text)

	if arg_4_0._filter_text ~= var_4_2 then
		arg_4_0:_refresh_filter()
	end

	arg_4_0._selected_teleport = Imgui.list_box("", arg_4_0._selected_teleport, arg_4_0._filtered_teleport_names)

	if Imgui.button("Register Point") or arg_4_0._key_states.register_new then
		Imgui.open_popup("register_point_popup")
	end

	Imgui.same_line()

	if Imgui.button("Teleport") or arg_4_0._key_states.teleport and not Imgui.is_popup_open("register_point_popup") then
		local var_4_3 = Managers.player:local_player()
		local var_4_4 = var_4_3 and var_4_3.player_unit

		arg_4_0:_teleport_to_selected(var_4_4)
	end

	Imgui.same_line()

	if Imgui.button("Save to Clipboard") or arg_4_0._key_states.save_to_clipboatd then
		local var_4_5 = Managers.player:local_player()
		local var_4_6 = var_4_5 and var_4_5.player_unit
		local var_4_7 = arg_4_0:_get_unit_location(var_4_6)

		arg_4_0:_save_point_to_clipboard(var_4_7)
	end

	Imgui.same_line()

	if Imgui.button("Teleport from Clipboard") or arg_4_0._key_states.teleport_from_clipboard then
		local var_4_8 = Managers.player:local_player()
		local var_4_9 = var_4_8 and var_4_8.player_unit
		local var_4_10 = arg_4_0:_get_point_from_clipboard()

		arg_4_0:_teleport_to_point(var_4_9, var_4_10)
	end

	Imgui.dummy(0, 5)
	Imgui.separator()
	Imgui.dummy(0, 5)

	local var_4_11 = arg_4_0._custom_target_point

	var_4_11[1], var_4_11[2], var_4_11[3] = Imgui.input_float_3("Point position", var_4_11[1], var_4_11[2], var_4_11[3])

	if Imgui.button("Teleport to position") then
		local var_4_12 = Managers.player:local_player()
		local var_4_13 = var_4_12 and var_4_12.player_unit

		arg_4_0:_teleport_to_point(var_4_13, var_4_11)
	end

	if Imgui.begin_popup("register_point_popup") then
		arg_4_0._register_point_name = Imgui.input_text("Name", arg_4_0._register_point_name)

		if Imgui.button("Confirm") or arg_4_0._key_states.confirm then
			arg_4_0:_register_point(arg_4_0._register_point_name)
			arg_4_0:_refresh_filter()
			Imgui.close_current_popup()
		end

		Imgui.same_line()

		if Imgui.button("Cancel") then
			Imgui.close_current_popup()
		end

		Imgui.end_popup()
	else
		arg_4_0._register_point_name = ""
	end

	if Imgui.begin_popup("config_keybinds_popup") then
		for iter_4_0, iter_4_1 in pairs(arg_4_0._key_bindings) do
			Imgui.tree_push(iter_4_0)

			local var_4_14 = arg_4_0._rebind_action == iter_4_0 and "<?>" or iter_4_1

			if Imgui.button(var_4_14, 100, 20) then
				arg_4_0._rebind_action = iter_4_0
			end

			Imgui.same_line()
			Imgui.text(iter_4_0)
			Imgui.tree_pop()
		end

		if arg_4_0._rebind_action then
			local var_4_15 = Keyboard.any_pressed()

			if var_4_15 then
				local var_4_16 = Keyboard.button_name(var_4_15)

				arg_4_0._key_bindings[arg_4_0._rebind_action] = var_4_16 == "esc" and "" or var_4_16
				arg_4_0._rebind_action = nil

				arg_4_0:_save_points()
			end
		end

		Imgui.end_popup()
	else
		arg_4_0._rebind_action = nil
	end

	local var_4_17 = Imgui.is_popup_open("config_keybinds_popup")

	Imgui.end_window()

	if not var_4_17 then
		arg_4_0:_update_input()
		arg_4_0:_handle_input()
	end

	return var_4_1
end

ImguiTeleportTool._update_input = function (arg_5_0)
	for iter_5_0, iter_5_1 in pairs(arg_5_0._key_bindings) do
		local var_5_0 = Keyboard.button_index(iter_5_1)

		arg_5_0._key_states[iter_5_0] = var_5_0 and Keyboard.pressed(var_5_0)
	end
end

ImguiTeleportTool._handle_input = function (arg_6_0)
	if arg_6_0._key_states.delete then
		local var_6_0 = arg_6_0:_get_selected_teleport_id()
		local var_6_1 = arg_6_0._current_level
		local var_6_2 = arg_6_0._teleport_name_map[var_6_1]
		local var_6_3 = arg_6_0._teleport_point_map[var_6_1]
		local var_6_4 = #var_6_2
		local var_6_5 = #var_6_3

		if var_6_0 <= var_6_4 then
			fassert(var_6_4 == var_6_5, "Missaligned num names and points")
			table.remove(var_6_2, var_6_0)
			table.remove(var_6_3, var_6_0)
			arg_6_0:_refresh_filter()
			arg_6_0:_save_points()
		end
	end

	if arg_6_0._key_states.select_up then
		arg_6_0._selected_teleport = math.max(math.min(arg_6_0._selected_teleport - 1, #arg_6_0._filtered_teleport_names - 1), 0)
	end

	if arg_6_0._key_states.select_down then
		arg_6_0._selected_teleport = math.max(math.min(arg_6_0._selected_teleport + 1, #arg_6_0._filtered_teleport_names - 1), 0)
	end

	if arg_6_0._key_states.quick_teleport then
		local var_6_6 = Managers.player:local_player()
		local var_6_7 = var_6_6 and var_6_6.player_unit

		arg_6_0:_teleport_to_selected(var_6_7)
	end
end

ImguiTeleportTool._refresh_filter = function (arg_7_0)
	local var_7_0 = arg_7_0:_get_teleport_names(arg_7_0._current_level)

	arg_7_0._filtered_teleport_names, arg_7_0._filtered_teleport_ids = arg_7_0:_apply_filter(arg_7_0._filter_text, var_7_0)
	arg_7_0._selected_teleport = math.max(math.min(arg_7_0._selected_teleport, #arg_7_0._filtered_teleport_names) - 1, 0)
end

ImguiTeleportTool._apply_filter = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == "" then
		return arg_8_2
	end

	local var_8_0 = {}
	local var_8_1 = {}
	local var_8_2 = string.gsub(arg_8_1, "[_ ]", "")

	for iter_8_0 = 1, #arg_8_2 do
		local var_8_3 = arg_8_2[iter_8_0]

		if string.gsub(var_8_3, "[_ ]", ""):find(var_8_2, 1, true) then
			table.insert(var_8_0, var_8_3)
			table.insert(var_8_1, iter_8_0)
		end
	end

	return var_8_0, var_8_1
end

ImguiTeleportTool._register_point = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._current_level

	if not var_9_0 then
		return
	end

	local var_9_1 = Managers.player:local_player()
	local var_9_2 = var_9_1 and var_9_1.player_unit
	local var_9_3 = arg_9_0:_get_unit_location(var_9_2)

	if var_9_3 then
		if not arg_9_0._teleport_name_map[var_9_0] then
			arg_9_0._teleport_name_map[var_9_0] = {}
			arg_9_0._teleport_point_map[var_9_0] = {}
		end

		table.insert(arg_9_0._teleport_name_map[var_9_0], arg_9_1)
		table.insert(arg_9_0._teleport_point_map[var_9_0], var_9_3)
		arg_9_0:_save_points()
	end
end

ImguiTeleportTool._get_unit_location = function (arg_10_0, arg_10_1)
	if Unit.alive(arg_10_1) then
		local var_10_0 = Unit.world_position(arg_10_1, 0)
		local var_10_1 = Unit.world_rotation(arg_10_1, 0)
		local var_10_2, var_10_3, var_10_4 = Vector3.to_elements(var_10_0)
		local var_10_5, var_10_6, var_10_7, var_10_8 = Quaternion.to_elements(var_10_1)

		return {
			var_10_2,
			var_10_3,
			var_10_4,
			var_10_5,
			var_10_6,
			var_10_7,
			var_10_8
		}
	end

	return nil
end

ImguiTeleportTool._get_selected_teleport_coords = function (arg_11_0)
	local var_11_0 = arg_11_0._current_level
	local var_11_1 = arg_11_0:_get_selected_teleport_id()

	if var_11_0 and var_11_1 then
		local var_11_2 = arg_11_0._teleport_point_map[var_11_0]

		return var_11_2 and var_11_2[var_11_1]
	end

	return nil
end

ImguiTeleportTool._teleport_to_selected = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:_get_selected_teleport_coords()

	arg_12_0:_teleport_to_point(arg_12_1, var_12_0)
end

ImguiTeleportTool._teleport_to_point = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2 and Unit.alive(arg_13_1) then
		local var_13_0 = Vector3(arg_13_2[1], arg_13_2[2], arg_13_2[3])
		local var_13_1 = Quaternion.from_elements(arg_13_2[4], arg_13_2[5], arg_13_2[6], arg_13_2[7])
		local var_13_2 = ScriptUnit.extension(arg_13_1, "locomotion_system")
		local var_13_3 = arg_13_0._custom_target_point

		var_13_3[1], var_13_3[2], var_13_3[3] = arg_13_2[1], arg_13_2[2], arg_13_2[3]

		if var_13_2 then
			var_13_2:teleport_to(var_13_0, var_13_1)
		end
	end
end

ImguiTeleportTool._get_teleport_names = function (arg_14_0, arg_14_1)
	return arg_14_1 and arg_14_0._teleport_name_map[arg_14_1] or var_0_1
end

ImguiTeleportTool._get_selected_teleport_id = function (arg_15_0)
	local var_15_0 = arg_15_0._selected_teleport
	local var_15_1 = arg_15_0._filtered_teleport_ids

	if var_15_0 and var_15_0 > 0 and var_15_1 then
		return var_15_1[var_15_0]
	end

	return var_15_0
end

ImguiTeleportTool._save_points = function (arg_16_0)
	Development.set_setting("ImguiTeleportTool_names", arg_16_0._teleport_name_map)
	Development.set_setting("ImguiTeleportTool_points", arg_16_0._teleport_point_map)
	Development.set_setting("ImguiTeleportTool_keybinds", arg_16_0._key_bindings)
	Application.save_user_settings()
end

ImguiTeleportTool._load_points = function (arg_17_0)
	arg_17_0._teleport_name_map = Development.setting("ImguiTeleportTool_names") or arg_17_0._teleport_name_map
	arg_17_0._teleport_point_map = Development.setting("ImguiTeleportTool_points") or arg_17_0._teleport_point_map
	arg_17_0._key_bindings = Development.setting("ImguiTeleportTool_keybinds") or arg_17_0._key_bindings
end

ImguiTeleportTool._save_point_to_clipboard = function (arg_18_0, arg_18_1)
	if arg_18_1 then
		local var_18_0 = "ITT##" .. tostring(arg_18_0._current_level) .. "##" .. cjson.encode(arg_18_1) .. "##END"

		Clipboard.put(var_18_0)
	end
end

ImguiTeleportTool._get_point_from_clipboard = function (arg_19_0)
	local var_19_0 = Clipboard.get()
	local var_19_1 = string.split_deprecated(var_19_0, "##")
	local var_19_2 = true and #var_19_1 == 4

	var_19_2 = var_19_2 and var_19_1[1] == "ITT"
	var_19_2 = var_19_2 and var_19_1[2] == arg_19_0._current_level
	var_19_2 = var_19_2 and string.sub(var_19_1[4], 1, 3) == "END"

	if var_19_2 then
		local var_19_3 = cjson.decode(var_19_1[3])

		if var_19_3 then
			local var_19_4 = Managers.player:local_player()
			local var_19_5 = var_19_4 and var_19_4.player_unit

			arg_19_0:_teleport_to_point(var_19_5, var_19_3)
		end
	end
end
