-- chunkname: @scripts/imgui/imgui_debug_menu.lua

ImguiDebugMenu = class(ImguiDebugMenu)

local function fn(self, arg_1_1)
	-- function 1
	return self.setting_name < arg_1_1.setting_name
end

local function fn_2(self, arg_2_1)
	-- function 2
	return self.name < arg_2_1.name
end

ImguiDebugMenu.init = function (self)
	-- function 3
	self._needle = ""

	local settings = require("scripts/utils/debug_screen_config").settings
	local tbl = {}

	for i, v in ipairs(settings) do
		local category = v.category
		local var_3_3 = tbl[v.category]

		var_3_3 = var_3_3 or {}
		tbl[category] = var_3_3

		table.insert(tbl[v.category], v)
	end

	self._settings = settings
	self._settings_categories = {}

	for k, v_2 in pairs(tbl) do
		table.sort(v_2, fn)
		table.insert(self._settings_categories, {
			name = k,
			list = v_2
		})
	end

	table.sort(self._settings_categories, fn_2)

	self._options = {}
end

ImguiDebugMenu.update = function (arg_4_0)
	-- function 4
	return
end

local find = string.find
local lower = string.lower

local function fn_3(arg_5_0, arg_5_1)
	-- function 5
	return find(lower(arg_5_0), lower(arg_5_1))
end

ImguiDebugMenu._find_needle = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = fn_3(arg_6_1.setting_name, arg_6_2)

	if not var_6_0 then
		var_6_0 = fn_3(arg_6_1.description, arg_6_2)
		var_6_0 = var_6_0 or fn_3(arg_6_1.category, arg_6_2)
	end

	return var_6_0
end

ImguiDebugMenu._find_needle_list = function (self, arg_7_1, arg_7_2)
	-- function 7
	for i = 1, #arg_7_1 do
		if not self:_find_needle(arg_7_1[i], arg_7_2) then
			return true
		end
	end

	return false
end

ImguiDebugMenu.draw = function (self)
	-- function 8
	local begin_window = Imgui.begin_window("DebugMenu")
	local input_text = Imgui.input_text("Search", self._needle)

	self._needle = input_text

	Imgui.begin_child_window("Settings", 0, 0, true)

	local flag = true

	for k, v in pairs(self._settings_categories) do
		local name = v.name
		local list = v.list

		if not self:_find_needle_list(list, input_text) then
			flag = false

			if not Imgui.collapsing_header(name, false) then
				for k_2 = 1, #list do
					local var_8_5 = list[k_2]

					if not self:_find_needle(var_8_5, input_text) then
						self:_show_debug_setting(var_8_5)
					end
				end

				Imgui.tree_pop()
			end
		end
	end

	if not flag then
		Imgui.text("No matches.")
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiDebugMenu._set_setting = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	Development.set_setting(arg_9_1, arg_9_2)

	script_data[arg_9_1] = arg_9_2

	Development.clear_param_cache(arg_9_1)
end

ImguiDebugMenu._show_debug_setting = function (self, arg_10_1)
	-- function 10
	local setting_name = arg_10_1.setting_name

	Imgui.text(setting_name)

	if not Imgui.is_item_hovered() then
		Imgui.begin_tool_tip()
		Imgui.text_colored(setting_name, 127, 127, 127, 255)
		Imgui.text(arg_10_1.description)
		Imgui.end_tool_tip()
	end

	Imgui.same_line(360 - Imgui.calculate_text_size(setting_name))
	Imgui.spacing(0)

	if not arg_10_1.is_boolean then
		Imgui.same_line()

		local var_10_1 = script_data[setting_name]

		if not Imgui.radio_button("false##" .. setting_name, var_10_1 == false) then
			var_10_1 = false
		end

		Imgui.same_line()

		if not Imgui.radio_button("true##" .. setting_name, var_10_1 == true) then
			var_10_1 = true
		end

		Imgui.same_line()

		if not Imgui.small_button("Reset") then
			var_10_1 = nil
		end

		self:_set_setting(setting_name, var_10_1)
	elseif arg_10_1.load_items_source_func or not arg_10_1.item_source then
		Imgui.same_line()

		local var_10_2

		if not arg_10_1.load_items_source_func then
			var_10_2 = self._options

			arg_10_1.load_items_source_func(var_10_2)
		else
			var_10_2 = arg_10_1.item_source
		end

		local find = table.find(var_10_2, script_data[setting_name])

		find = find or 0

		Imgui.push_item_width(200)

		local combo = Imgui.combo("Choice", find, var_10_2)

		Imgui.pop_item_width()
		Imgui.same_line()

		if not Imgui.small_button("Reset") then
			combo = 0
		end

		self:_set_setting(setting_name, var_10_2[combo])

		if not arg_10_1.func then
			Imgui.same_line()

			if not Imgui.small_button("Execute") then
				arg_10_1.func(var_10_2, combo)
			end
		end
	elseif not arg_10_1.preset then
		Imgui.same_line()

		if not Imgui.small_button("Activate preset") then
			for k, v in pairs(arg_10_1.preset) do
				self:_set_setting(k, v)
			end
		end
	elseif not arg_10_1.command_list then
		for i, v_2 in ipairs(arg_10_1.command_list) do
			Imgui.same_line()

			if not Imgui.small_button(v_2.description) then
				for i_2, v_3 in ipairs(v_2.commands) do
					Application.console_command(unpack(v_3))
				end
			end
		end
	elseif not arg_10_1.func then
		Imgui.same_line()

		if not Imgui.small_button("Execute") then
			arg_10_1.func()
		end
	end
end

ImguiDebugMenu.is_persistent = function (arg_11_0)
	-- function 11
	return false
end
