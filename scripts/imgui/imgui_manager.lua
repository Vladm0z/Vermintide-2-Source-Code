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

ImguiManager.init = function (self)
	-- function 1
	self._open = false
	self._persistant_windows = 0
	self._guis_by_category = {}
	self._key_bindings = {}
	self._input_stack = 0

	for k, v in pairs(ImguiConfigurationSettings) do
		require(v.file)

		local var_1_0 = _G[v.class]

		self:add_gui(var_1_0, v.category, v.name)
	end

	self:_load_settings()
end

local function fn(self, arg_2_1)
	-- function 2
	for i = 1, #self do
		local name = self[i].name

		if name == arg_2_1 then
			return i, true
		elseif arg_2_1 < name then
			return i, false
		end
	end

	return #self + 1, false
end

ImguiManager._call_on_guis = function (self, arg_3_1, ...)
	-- function 3
	for k, v in pairs(self._guis_by_category) do
		for k_2, v_2 in pairs(v.list) do
			local gui = v_2.gui
			local var_3_1 = gui[arg_3_1]

			if not var_3_1 then
				var_3_1(gui, ...)
			end
		end
	end
end

ImguiManager.add_gui = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0 = arg_4_1:new()

	assert(var_4_0.init)
	assert(var_4_0.update)
	assert(var_4_0.draw)
	assert(var_4_0.is_persistent)

	local var_4_1, var_4_2 = fn(self._guis_by_category, arg_4_2)

	if not var_4_2 then
		table.insert(self._guis_by_category, var_4_1, {
			name = arg_4_2,
			list = {}
		})

		self._key_bindings[arg_4_2] = {}
	end

	local list = self._guis_by_category[var_4_1].list
	local var_4_4 = fn(list, arg_4_3)

	table.insert(list, var_4_4, {
		gui = var_4_0,
		name = arg_4_3,
		enabled = arg_4_4
	})

	if not self._key_bindings[arg_4_2][arg_4_3] then
		self._key_bindings[arg_4_2][arg_4_3] = {
			id = 0,
			keybind = {}
		}
	end

	local var_4_5 = self._key_bindings[arg_4_2]

	for k, v in pairs(list) do
		var_4_5[v.name].id = k
	end
end

ImguiManager.destroy = function (self)
	-- function 5
	return self:_call_on_guis("destroy")
end

ImguiManager.set_open = function (self, arg_6_1)
	-- function 6
	if arg_6_1 ~= self._open then
		if not arg_6_1 then
			Imgui.open_imgui()
			self:_capture_input()
		else
			if self._persistant_windows == 0 then
				Imgui.close_imgui()
			end

			self:_release_input()

			self._settings = false
		end

		self._open = arg_6_1
	end
end

ImguiManager.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not Keyboard.pressed(Keyboard.button_index("f3")) then
		self:set_open(not self._open)
	end

	if not self._open then
		self:update_main_menu()
	end

	self:update_guis(arg_7_1, arg_7_2)
	self:_update_keybinds()
end

ImguiManager.post_update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:post_update_guis(arg_8_1, arg_8_2)
end

ImguiManager.post_update_guis = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _persistant_windows = self._persistant_windows
	local _open = self._open

	for k, v in pairs(self._guis_by_category) do
		for k_2, v_2 in pairs(v.list) do
			if not v_2.enabled then
				local gui = v_2.gui

				if not gui.post_update then
					gui:post_update(arg_9_1, arg_9_2, _open)

					if _open or gui:is_persistent() or not v_2.opened_with_keybind then
						if not gui:post_draw(_open, arg_9_1, arg_9_2) then
							self:_set_gui_enabled(v_2, false)
						end

						self._persistant_windows = self._persistant_windows + 1
					end
				end
			end
		end
	end

	if not (_open or not (_persistant_windows <= 0) or not (self._persistant_windows > 0)) then
		Imgui.open_imgui()
	elseif not (_open or not (_persistant_windows > 0) or not (self._persistant_windows <= 0)) then
		Imgui.close_imgui()
	end
end

ImguiManager.update_main_menu = function (self)
	-- function 10
	if not Imgui.begin_main_menu_bar() then
		for k, v in pairs(self._guis_by_category) do
			local name = v.name
			local list = v.list

			if not Imgui.begin_menu(name) then
				for k_2, v_2 in pairs(list) do
					local _get_keybind_text = self:_get_keybind_text(name, v_2.name)

					if not Imgui.menu_item(v_2.name .. _get_keybind_text) then
						self:_set_gui_enabled(v_2, not v_2.enabled)
					end
				end

				Imgui.end_menu()
			end
		end

		if not Imgui.menu_item("[Keybinds]") then
			self._settings = not self._settings
		end

		if not Imgui.menu_item("[X]") then
			self:set_open(false)
		end

		Imgui.end_main_menu_bar()
	end
end

ImguiManager.update_guis = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _persistant_windows = self._persistant_windows

	self._persistant_windows = 0

	local _open = self._open

	for k, v in pairs(self._guis_by_category) do
		for k_2, v_2 in pairs(v.list) do
			if not v_2.enabled then
				local gui = v_2.gui

				gui:update(arg_11_1, arg_11_2, _open)

				if _open or gui:is_persistent() or not v_2.opened_with_keybind then
					if not gui:draw(_open, arg_11_1, arg_11_2) then
						self:_set_gui_enabled(v_2, false)
					end

					self._persistant_windows = self._persistant_windows + 1
				end
			end
		end
	end

	if not (_open or not (_persistant_windows <= 0) or not (self._persistant_windows > 0)) then
		Imgui.open_imgui()
	elseif not (_open or not (_persistant_windows > 0) or not (self._persistant_windows <= 0)) then
		Imgui.close_imgui()
	end

	if not self._settings then
		if not self:_draw_keybind_settings() then
			self._settings = false
		end
	else
		self._rebind_action = nil
	end
end

ImguiManager.on_round_start = function (self, ...)
	-- function 12
	return self:_call_on_guis("on_round_start", ...)
end

ImguiManager.on_round_end = function (self, ...)
	-- function 13
	return self:_call_on_guis("on_round_end", ...)
end

ImguiManager.on_venture_start = function (self, ...)
	-- function 14
	return self:_call_on_guis("on_venture_start", ...)
end

ImguiManager.on_venture_end = function (self, ...)
	-- function 15
	return self:_call_on_guis("on_venture_end", ...)
end

ImguiManager._input_manager_do = function (arg_16_0, arg_16_1)
	-- function 16
	local input = Managers.input

	if not input then
		if not input:get_input_service("imgui") then
			input:create_input_service("imgui", "ImguiKeymaps")
			input:map_device_to_service("imgui", "keyboard")
			input:map_device_to_service("imgui", "gamepad")
			input:map_device_to_service("imgui", "mouse")
		end

		input[arg_16_1](input, ALL_INPUT_METHODS, 1, "imgui", "ImguiManager")
	end
end

ImguiManager._set_gui_enabled = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not arg_17_2 then
		if not arg_17_1.gui.on_show then
			arg_17_1.gui:on_show()
		end

		if not arg_17_3 then
			self:_capture_input()

			arg_17_1.opened_with_keybind = true
		end
	else
		if not arg_17_1.gui.on_hide then
			arg_17_1.gui:on_hide()
		end

		if not arg_17_1.opened_with_keybind then
			self:_release_input()

			arg_17_1.opened_with_keybind = false
		end
	end

	arg_17_1.enabled = arg_17_2
end

ImguiManager._update_keybinds = function (self)
	-- function 18
	for k, v in pairs(self._key_bindings) do
		for k_2, v_2 in pairs(v) do
			local keybind = v_2.keybind
			local count = #keybind

			if count > 0 then
				local flag = true

				for i4 = 1, count - 1 do
					local button_index = Keyboard.button_index(keybind[i4])

					if not (not button_index and not (Keyboard.button(button_index) <= 0)) then
						flag = false

						break
					end
				end

				if not flag then
					local button_index_2 = Keyboard.button_index(keybind[count])

					if not button_index_2 and not Keyboard.pressed(button_index_2) then
						local find_by_key, var_18_6 = table.find_by_key(self._guis_by_category, "name", k)
						local var_18_7 = var_18_6.list[v_2.id]

						self:_set_gui_enabled(var_18_7, not var_18_7.enabled, true)
					end
				end
			end
		end
	end
end

ImguiManager._draw_keybind_settings = function (self)
	-- function 19
	local begin_window = Imgui.begin_window("Keybinds")

	Imgui.text("<esc> to clear keybind")

	for k, v in pairs(self._key_bindings) do
		Imgui.text(k)
		Imgui.tree_push(k)

		for k_2, v_2 in pairs(v) do
			Imgui.tree_push(k_2)

			local keybind = v_2.keybind

			for i4 = 1, #keybind do
				local flag

				flag = not (self._rebind_action ~= k_2 or self._rebind_category ~= k or self._rebind_id == i4) and "<?>" and keybind[i4]

				if not Imgui.button(flag) then
					self._rebind_id = i4
					self._rebind_action = k_2
					self._rebind_category = k
				end

				Imgui.same_line()
			end

			if not Imgui.button("+", 20, 20) then
				local num = #keybind + 1

				keybind[num] = ""
				self._rebind_id = num
				self._rebind_action = k_2
				self._rebind_category = k
			end

			Imgui.same_line()
			Imgui.text(k_2)
			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end

	if not self._rebind_action then
		local any_pressed = Keyboard.any_pressed()

		if not any_pressed then
			local button_name = Keyboard.button_name(any_pressed)
			local keybind_2 = self._key_bindings[self._rebind_category][self._rebind_action].keybind

			if button_name == "esc" then
				table.remove(keybind_2, self._rebind_id)
			else
				keybind_2[self._rebind_id] = button_name
			end

			self._rebind_action = nil
			self._rebind_category = nil
			self._rebind_id = nil

			self:_save_settings()
		end
	end

	Imgui.end_window()

	return begin_window
end

ImguiManager._get_keybind_text = function (self, arg_20_1, arg_20_2)
	-- function 20
	local keybind = self._key_bindings[arg_20_1][arg_20_2].keybind
	local count = #keybind

	if count > 0 then
		local str = " ["

		for i = 1, count do
			if i > 1 then
				str = str .. "+"
			end

			str = str .. keybind[i]
		end

		local str_2 = str .. "]"

		return string.upper(str_2)
	end

	return ""
end

ImguiManager._save_settings = function (self)
	-- function 21
	Development.set_setting("ImguiManager_keybinds", self._key_bindings)
	Application.save_user_settings()
end

ImguiManager._load_settings = function (self)
	-- function 22
	local setting = Development.setting("ImguiManager_keybinds")

	setting = setting or {}

	for k, v in pairs(self._key_bindings) do
		local var_22_1 = setting[k]

		if not var_22_1 then
			for k_2, v_2 in pairs(v) do
				local var_22_2 = v[k_2]
				local keybind

				if not var_22_1[k_2] then
					keybind = var_22_1[k_2].keybind

					if not keybind then
						-- Nothing
					end
				end

				keybind = v[k_2].keybind

				::label_22_0::

				var_22_2.keybind = keybind
			end
		end
	end
end

ImguiManager._capture_input = function (self)
	-- function 23
	local _input_stack = self._input_stack

	if _input_stack == 0 then
		self:_input_manager_do("capture_input")
		ShowCursorStack.show("ImguiManager")
		Imgui.enable_imgui_input_system(Imgui.KEYBOARD)
		Imgui.enable_imgui_input_system(Imgui.MOUSE)
		Imgui.enable_imgui_input_system(Imgui.GAMEPAD)
	end

	self._input_stack = _input_stack + 1
end

ImguiManager._release_input = function (self)
	-- function 24
	local num = self._input_stack - 1

	assert(num >= 0, "imgui input stack underflow")

	if num == 0 then
		self:_input_manager_do("release_input")
		ShowCursorStack.hide("ImguiManager")
		Imgui.disable_imgui_input_system(Imgui.KEYBOARD)
		Imgui.disable_imgui_input_system(Imgui.GAMEPAD)
		Imgui.disable_imgui_input_system(Imgui.MOUSE)
	end

	self._input_stack = num
end

local ImguiX = ImguiX

ImguiX = ImguiX or {}
ImguiX = ImguiX

ImguiX.color_edit_4 = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	arg_25_2, arg_25_3, arg_25_4, arg_25_1 = Imgui.color_edit_4(arg_25_0, arg_25_2 / 255, arg_25_3 / 255, arg_25_4 / 255, arg_25_1 / 255)

	return arg_25_1 * 255, arg_25_2 * 255, arg_25_3 * 255, arg_25_4 * 255
end

ImguiX.heading = function (arg_26_0, arg_26_1, ...)
	-- function 26
	Imgui.text_colored(arg_26_0 .. ":", 200, 200, 255, 255)
	Imgui.same_line()
	Imgui.text(string.format(arg_26_1, ...))
end

ImguiX.combo_search = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local input_text = Imgui.input_text("Search", arg_27_2)

	if input_text ~= arg_27_2 then
		arg_27_1 = {}

		local gsub = string.gsub(string.lower(input_text), " ", ".-")

		for i, v in ipairs(arg_27_3) do
			if not string.find(string.lower(v), gsub) then
				arg_27_1[#arg_27_1 + 1] = v
			elseif not arg_27_4 then
				for i_2, v_2 in ipairs(arg_27_4) do
					if not string.find(string.lower(v_2[i]), gsub) then
						arg_27_1[#arg_27_1 + 1] = v

						break
					end
				end
			end
		end

		arg_27_0 = -1
		arg_27_2 = input_text
	end

	arg_27_0 = Imgui.list_box("##element_select", arg_27_0, arg_27_1, 5)

	return arg_27_0, arg_27_1, arg_27_2
end
