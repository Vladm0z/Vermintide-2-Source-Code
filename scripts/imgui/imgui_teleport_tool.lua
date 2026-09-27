-- chunkname: @scripts/imgui/imgui_teleport_tool.lua

ImguiTeleportTool = class(ImguiTeleportTool)

local flag = true
local tbl = {}

ImguiTeleportTool.init = function (self)
	-- function 1
	self._current_level = nil
	self._teleport_name_map = {}
	self._teleport_point_map = {}
	self._filter_text = ""
	self._filtered_teleport_names = {}
	self._filtered_teleport_ids = {}
	self._selected_teleport = 0
	self._register_point_name = ""
	self._register_point_active = false
	self._is_persistent = false
	self._key_bindings = {
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
	self._custom_target_point = {
		0,
		0,
		0,
		0,
		0,
		0,
		1
	}
	self._key_states = {}
	self._rebind_action = nil

	self:_load_points()
	self:_refresh_filter()
end

ImguiTeleportTool.update = function (self)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end

	local game_mode = Managers.state.game_mode
	local flag_2 = not game_mode and game_mode:level_key()

	if not (self._current_level ~= nil or not flag_2 or flag_2 == self._current_level) then
		self._current_level = flag_2

		self:_refresh_filter()
	end
end

ImguiTeleportTool.is_persistent = function (self)
	-- function 3
	return self._is_persistent
end

ImguiTeleportTool.draw = function (self, arg_4_1)
	-- function 4
	local flag = false
	local begin_window = Imgui.begin_window("Teleport Tool", "menu_bar")

	Imgui.set_window_size(300, 0, "once")

	if not Imgui.begin_menu_bar() then
		if not Imgui.menu_item("Configure keybinds") then
			flag = true
		end

		Imgui.end_menu_bar()
	end

	if not flag then
		Imgui.open_popup("config_keybinds_popup")
	end

	self._is_persistent = Imgui.checkbox("Keep on screen", self._is_persistent)

	Imgui.separator()
	Imgui.text("Current level: ")
	Imgui.same_line()
	Imgui.text(tostring(self._current_level))

	local _filter_text = self._filter_text

	self._filter_text = Imgui.input_text("Search", self._filter_text)

	if self._filter_text ~= _filter_text then
		self:_refresh_filter()
	end

	self._selected_teleport = Imgui.list_box("", self._selected_teleport, self._filtered_teleport_names)

	if Imgui.button("Register Point") or not self._key_states.register_new then
		Imgui.open_popup("register_point_popup")
	end

	Imgui.same_line()

	if not ((Imgui.button("Teleport") or not self._key_states.teleport) and Imgui.is_popup_open("register_point_popup")) then
		local local_player = Managers.player:local_player()
		local flag_2 = not local_player and local_player.player_unit

		self:_teleport_to_selected(flag_2)
	end

	Imgui.same_line()

	if Imgui.button("Save to Clipboard") or not self._key_states.save_to_clipboatd then
		local local_player_2 = Managers.player:local_player()
		local flag_3 = not local_player_2 and local_player_2.player_unit
		local _get_unit_location = self:_get_unit_location(flag_3)

		self:_save_point_to_clipboard(_get_unit_location)
	end

	Imgui.same_line()

	if Imgui.button("Teleport from Clipboard") or not self._key_states.teleport_from_clipboard then
		local local_player_3 = Managers.player:local_player()
		local flag_4 = not local_player_3 and local_player_3.player_unit
		local _get_point_from_clipboard = self:_get_point_from_clipboard()

		self:_teleport_to_point(flag_4, _get_point_from_clipboard)
	end

	Imgui.dummy(0, 5)
	Imgui.separator()
	Imgui.dummy(0, 5)

	local _custom_target_point = self._custom_target_point

	_custom_target_point[1], _custom_target_point[2], _custom_target_point[3] = Imgui.input_float_3("Point position", _custom_target_point[1], _custom_target_point[2], _custom_target_point[3])

	if not Imgui.button("Teleport to position") then
		local local_player_4 = Managers.player:local_player()
		local flag_5 = not local_player_4 and local_player_4.player_unit

		self:_teleport_to_point(flag_5, _custom_target_point)
	end

	if not Imgui.begin_popup("register_point_popup") then
		self._register_point_name = Imgui.input_text("Name", self._register_point_name)

		if Imgui.button("Confirm") or not self._key_states.confirm then
			self:_register_point(self._register_point_name)
			self:_refresh_filter()
			Imgui.close_current_popup()
		end

		Imgui.same_line()

		if not Imgui.button("Cancel") then
			Imgui.close_current_popup()
		end

		Imgui.end_popup()
	else
		self._register_point_name = ""
	end

	if not Imgui.begin_popup("config_keybinds_popup") then
		for k, v in pairs(self._key_bindings) do
			Imgui.tree_push(k)

			local flag_6

			flag_6 = not (self._rebind_action == k) and "<?>" and v

			if not Imgui.button(flag_6, 100, 20) then
				self._rebind_action = k
			end

			Imgui.same_line()
			Imgui.text(k)
			Imgui.tree_pop()
		end

		if not self._rebind_action then
			local any_pressed = Keyboard.any_pressed()

			if not any_pressed then
				local button_name = Keyboard.button_name(any_pressed)
				local _key_bindings = self._key_bindings
				local _rebind_action = self._rebind_action
				local flag_7

				flag_7 = button_name ~= "esc" or not "" or button_name
				_key_bindings[_rebind_action] = flag_7
				self._rebind_action = nil

				self:_save_points()
			end
		end

		Imgui.end_popup()
	else
		self._rebind_action = nil
	end

	local is_popup_open = Imgui.is_popup_open("config_keybinds_popup")

	Imgui.end_window()

	if not is_popup_open then
		self:_update_input()
		self:_handle_input()
	end

	return begin_window
end

ImguiTeleportTool._update_input = function (self)
	-- function 5
	for k, v in pairs(self._key_bindings) do
		local button_index = Keyboard.button_index(v)

		self._key_states[k] = not button_index and Keyboard.pressed(button_index)
	end
end

ImguiTeleportTool._handle_input = function (self)
	-- function 6
	if not self._key_states.delete then
		local _get_selected_teleport_id = self:_get_selected_teleport_id()
		local _current_level = self._current_level
		local var_6_2 = self._teleport_name_map[_current_level]
		local var_6_3 = self._teleport_point_map[_current_level]
		local count = #var_6_2
		local count_2 = #var_6_3

		if _get_selected_teleport_id <= count then
			fassert(count == count_2, "Missaligned num names and points")
			table.remove(var_6_2, _get_selected_teleport_id)
			table.remove(var_6_3, _get_selected_teleport_id)
			self:_refresh_filter()
			self:_save_points()
		end
	end

	if not self._key_states.select_up then
		self._selected_teleport = math.max(math.min(self._selected_teleport - 1, #self._filtered_teleport_names - 1), 0)
	end

	if not self._key_states.select_down then
		self._selected_teleport = math.max(math.min(self._selected_teleport + 1, #self._filtered_teleport_names - 1), 0)
	end

	if not self._key_states.quick_teleport then
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		self:_teleport_to_selected(flag)
	end
end

ImguiTeleportTool._refresh_filter = function (self)
	-- function 7
	local _get_teleport_names = self:_get_teleport_names(self._current_level)

	self._filtered_teleport_names, self._filtered_teleport_ids = self:_apply_filter(self._filter_text, _get_teleport_names)
	self._selected_teleport = math.max(math.min(self._selected_teleport, #self._filtered_teleport_names) - 1, 0)
end

ImguiTeleportTool._apply_filter = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if arg_8_1 == "" then
		return arg_8_2
	end

	local tbl = {}
	local tbl_2 = {}
	local gsub = string.gsub(arg_8_1, "[_ ]", "")

	for i = 1, #arg_8_2 do
		local var_8_3 = arg_8_2[i]

		if not string.gsub(var_8_3, "[_ ]", ""):find(gsub, 1, true) then
			table.insert(tbl, var_8_3)
			table.insert(tbl_2, i)
		end
	end

	return tbl, tbl_2
end

ImguiTeleportTool._register_point = function (self, arg_9_1)
	-- function 9
	local _current_level = self._current_level

	if not _current_level then
		return
	end

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit
	local _get_unit_location = self:_get_unit_location(flag)

	if not _get_unit_location then
		if not self._teleport_name_map[_current_level] then
			self._teleport_name_map[_current_level] = {}
			self._teleport_point_map[_current_level] = {}
		end

		table.insert(self._teleport_name_map[_current_level], arg_9_1)
		table.insert(self._teleport_point_map[_current_level], _get_unit_location)
		self:_save_points()
	end
end

ImguiTeleportTool._get_unit_location = function (arg_10_0, arg_10_1)
	-- function 10
	if not Unit.alive(arg_10_1) then
		local world_position = Unit.world_position(arg_10_1, 0)
		local world_rotation = Unit.world_rotation(arg_10_1, 0)
		local to_elements, var_10_3, var_10_4 = Vector3.to_elements(world_position)
		local to_elements_2, var_10_6, var_10_7, var_10_8 = Quaternion.to_elements(world_rotation)

		return {
			to_elements,
			var_10_3,
			var_10_4,
			to_elements_2,
			var_10_6,
			var_10_7,
			var_10_8
		}
	end

	return nil
end

ImguiTeleportTool._get_selected_teleport_coords = function (self)
	-- function 11
	local _current_level = self._current_level
	local _get_selected_teleport_id = self:_get_selected_teleport_id()

	if not _current_level and not _get_selected_teleport_id then
		local var_11_2 = self._teleport_point_map[_current_level]

		return not var_11_2 and var_11_2[_get_selected_teleport_id]
	end

	return nil
end

ImguiTeleportTool._teleport_to_selected = function (self, arg_12_1)
	-- function 12
	local _get_selected_teleport_coords = self:_get_selected_teleport_coords()

	self:_teleport_to_point(arg_12_1, _get_selected_teleport_coords)
end

ImguiTeleportTool._teleport_to_point = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_2 and not Unit.alive(arg_13_1) then
		local var_13_0 = Vector3(arg_13_2[1], arg_13_2[2], arg_13_2[3])
		local from_elements = Quaternion.from_elements(arg_13_2[4], arg_13_2[5], arg_13_2[6], arg_13_2[7])
		local extension = ScriptUnit.extension(arg_13_1, "locomotion_system")
		local _custom_target_point = self._custom_target_point

		_custom_target_point[1], _custom_target_point[2], _custom_target_point[3] = arg_13_2[1], arg_13_2[2], arg_13_2[3]

		if not extension then
			extension:teleport_to(var_13_0, from_elements)
		end
	end
end

ImguiTeleportTool._get_teleport_names = function (self, arg_14_1)
	-- function 14
	local var_14_0

	if not arg_14_1 then
		var_14_0 = self._teleport_name_map[arg_14_1]

		if not var_14_0 then
			-- Nothing
		end
	end

	var_14_0 = tbl

	::label_14_0::

	return var_14_0
end

ImguiTeleportTool._get_selected_teleport_id = function (self)
	-- function 15
	local _selected_teleport = self._selected_teleport
	local _filtered_teleport_ids = self._filtered_teleport_ids

	if not _selected_teleport and not (_selected_teleport > 0) or not _filtered_teleport_ids then
		return _filtered_teleport_ids[_selected_teleport]
	end

	return _selected_teleport
end

ImguiTeleportTool._save_points = function (self)
	-- function 16
	Development.set_setting("ImguiTeleportTool_names", self._teleport_name_map)
	Development.set_setting("ImguiTeleportTool_points", self._teleport_point_map)
	Development.set_setting("ImguiTeleportTool_keybinds", self._key_bindings)
	Application.save_user_settings()
end

ImguiTeleportTool._load_points = function (self)
	-- function 17
	local setting = Development.setting("ImguiTeleportTool_names")

	setting = setting or self._teleport_name_map
	self._teleport_name_map = setting

	local setting_2 = Development.setting("ImguiTeleportTool_points")

	setting_2 = setting_2 or self._teleport_point_map
	self._teleport_point_map = setting_2

	local setting_3 = Development.setting("ImguiTeleportTool_keybinds")

	setting_3 = setting_3 or self._key_bindings
	self._key_bindings = setting_3
end

ImguiTeleportTool._save_point_to_clipboard = function (self, arg_18_1)
	-- function 18
	if not arg_18_1 then
		local str = "ITT##" .. tostring(self._current_level) .. "##" .. cjson.encode(arg_18_1) .. "##END"

		Clipboard.put(str)
	end
end

ImguiTeleportTool._get_point_from_clipboard = function (self)
	-- function 19
	local get = Clipboard.get()
	local split_deprecated = string.split_deprecated(get, "##")
	local flag = true

	flag = not flag and #split_deprecated == 4
	flag = not flag and split_deprecated[1] == "ITT"
	flag = not flag and split_deprecated[2] == self._current_level
	flag = not flag and string.sub(split_deprecated[4], 1, 3) == "END"

	if not flag then
		local decode = cjson.decode(split_deprecated[3])

		if not decode then
			local local_player = Managers.player:local_player()
			local flag_2 = not local_player and local_player.player_unit

			self:_teleport_to_point(flag_2, decode)
		end
	end
end
