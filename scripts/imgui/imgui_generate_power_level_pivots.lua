-- chunkname: @scripts/imgui/imgui_generate_power_level_pivots.lua

local scripts_utils_serialize = require("scripts/utils/serialize")

ImguiGeneratePowerLevelPivots = class(ImguiGeneratePowerLevelPivots)

local num = 80
local num_2 = 30
local num_3 = 30
local tbl = {
	{
		key = "min",
		precision = 0.25,
		type = "float",
		label = "Min:",
		column_width = 85
	},
	{
		key = "max",
		precision = 0.25,
		type = "float",
		label = "Max:",
		column_width = 85
	},
	{
		min = 0.01,
		key = "pivot_power",
		precision = 0.25,
		type = "slider_float",
		label = "Pivot Power:",
		column_width = 210,
		max = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
			-- function 1
			return arg_1_2.max * 2
		end
	},
	{
		min = 1,
		key = "pivot_level",
		type = "slider_int",
		label = "Level:",
		column_width = 140,
		max = 45
	},
	{
		min = 0.01,
		key = "easing_power",
		precision = 0.1,
		type = "slider_float",
		label = "Easing Power:",
		column_width = 200,
		max = 2
	},
	{
		type = "text",
		label = "Color:",
		column_width = 205,
		data = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
			-- function 2
			return self._colors
		end,
		key = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
			-- function 3
			return arg_3_1 .. "." .. arg_3_5
		end
	}
}
local num_4 = 0

for i = 1, #tbl do
	num_4 = num_4 + tbl[i].column_width
end

ImguiGeneratePowerLevelPivots.init = function (arg_4_0)
	-- function 4
	return
end

ImguiGeneratePowerLevelPivots._lazy_init = function (self)
	-- function 5
	local _power_level_settings = self:_power_level_settings()
	local _default_settings = self._default_settings

	_default_settings = _default_settings or table.clone(_power_level_settings)
	self._default_settings = _default_settings
	self._tabs = {
		"Graph",
		"Code"
	}

	local _selected_tab = self._selected_tab

	_selected_tab = _selected_tab or "Graph"
	self._selected_tab = _selected_tab

	local num = 0
	local huge = math.huge

	for k, v in pairs(self._default_settings.pivots) do
		if num < v.hi.max then
			num = v.hi.max
		end

		if huge > v.hi.min then
			huge = v.hi.min
		end

		if num < v.low.max then
			num = v.low.max
		end

		if huge > v.low.min then
			huge = v.low.min
		end
	end

	self._max_power_level = num
	self._min_power_level = huge
	self._colors = {
		normal = {
			hi = "common",
			low = "common"
		},
		hard = {
			hi = "rare",
			low = "rare"
		},
		harder = {
			hi = "exotic",
			low = "exotic"
		},
		hardest = {
			hi = "unique",
			low = "unique"
		}
	}
	self._fallback_color = "pale_golden_rod"
	self._display_order = {
		harder = 3,
		hard = 2,
		hardest = 4,
		normal = 1
	}
	self._easing_functions = {
		{
			inverse = "easeOutCubicInv",
			ease = "easeOutCubic"
		},
		{
			inverse = "linear_inv",
			ease = "linear"
		},
		{
			inverse = "ease_out_quart_inv",
			ease = "ease_out_quart"
		}
	}
	self._easing_as_array = table.select_array(self._easing_functions, function (arg_6_0, arg_6_1)
		-- function 6
		return arg_6_1.ease
	end)

	local _easing_func_index = self._easing_func_index

	_easing_func_index = _easing_func_index or 1
	self._easing_func_index = _easing_func_index

	local _history = self._history

	_history = _history or {
		table.clone(self._default_settings)
	}
	self._history = _history
	self._history_index = 1
	self._filter = ""
end

ImguiGeneratePowerLevelPivots.is_persistent = function (arg_7_0)
	-- function 7
	return false
end

ImguiGeneratePowerLevelPivots._power_level_settings = function (arg_8_0)
	-- function 8
	return (Managers.backend:get_interface("loot"):get_power_level_settings())
end

local flag = true

ImguiGeneratePowerLevelPivots.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not Managers.state.game_mode then
		return
	end

	if flag or not self._run_lazy_init then
		self:_lazy_init()

		flag = false
	end

	if Keyboard.button(Keyboard.button_index("left ctrl")) > 0 then
		if not Keyboard.pressed(Keyboard.button_index("z")) then
			if self._history_index > 1 then
				self._history_index = self._history_index - 1

				Managers.backend:get_interface("loot"):debug_override_power_level_settings(table.clone(self._history[self._history_index]))
			end
		elseif not (not Keyboard.pressed(Keyboard.button_index("y")) and not (self._history_index + 1 <= #self._history)) then
			self._history_index = self._history_index + 1

			Managers.backend:get_interface("loot"):debug_override_power_level_settings(table.clone(self._history[self._history_index]))
		end
	end
end

ImguiGeneratePowerLevelPivots.on_show = function (self)
	-- function 10
	self._run_lazy_init = true
end

ImguiGeneratePowerLevelPivots.draw = function (self)
	-- function 11
	local begin_window, var_11_1 = Imgui.begin_window("Generate Power Level Pivots", "always_auto_resize", "menu_bar")

	if not var_11_1 then
		return begin_window
	end

	if not Managers.state.game_mode then
		Imgui.text("Disabled outside game state.")
		Imgui.end_window()

		return
	end

	self:_reset_control_id()

	self._menu_bar_height = 0

	if not Imgui.begin_menu_bar() then
		for i, v in ipairs(self._tabs) do
			local str

			if self._selected_tab ~= v then
				str = " " .. v .. " "

				if not str then
					-- Nothing
				end
			end

			str = "[" .. v .. "]"

			::label_11_0::

			if not Imgui.menu_item(str) then
				self._selected_tab = v
			end
		end

		Imgui.end_menu_bar()

		self.asdf, self._menu_bar_height = Imgui.get_item_rect_size()
	end

	local tbl = {
		num_4 + 170,
		500
	}
	local num = tbl[2] + 290

	Imgui.begin_child_window("GraphEditor", tbl[1], num, true, "always_auto_resize")

	local _selected_tab = self._selected_tab

	if _selected_tab == "Graph" then
		self:_draw_graph(tbl)
	elseif _selected_tab == "Code" then
		self:_draw_code(tbl)
	end

	Imgui.end_child_window()
	Imgui.same_line()

	local num_2 = 800

	Imgui.begin_child_window("Summary", num_2, num, true, "always_auto_resize")
	self:_draw_summary(num_2)
	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiGeneratePowerLevelPivots._reset_control_id = function (self)
	-- function 12
	self._next_control_id_internal = 0
end

ImguiGeneratePowerLevelPivots._next_control_id = function (self)
	-- function 13
	self._next_control_id_internal = self._next_control_id_internal + 1

	return tostring(self._next_control_id_internal)
end

ImguiGeneratePowerLevelPivots._nan_backup = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if arg_14_1 ~= arg_14_1 then
		return 0, true, arg_14_3
	end

	return arg_14_1, arg_14_2, arg_14_3
end

ImguiGeneratePowerLevelPivots._draw_graph = function (self, arg_15_1)
	-- function 15
	local var_15_0 = Color(180, 100, 100, 100)
	local var_15_1 = Color(255, 255, 255, 255)
	local var_15_2 = Color(255, 255, 255, 255)
	local var_15_3 = Color(255, 255, 255, 255)
	local var_15_4 = Color(255, 255, 0, 0)
	local num_4 = 0
	local num_5 = 0
	local var_15_7 = arg_15_1[1]
	local var_15_8 = arg_15_1[2]
	local num_6 = 20
	local num_7 = 20
	local num_8 = 0
	local num_9 = 0
	local num_10 = 1
	local num_11 = 2
	local num_12 = 10

	Imgui.channel_split(2)
	Imgui.channel_set_current(0)

	local get_cursor_screen_pos, var_15_17 = Imgui.get_cursor_screen_pos()

	Imgui.add_rect_filled(get_cursor_screen_pos + num_4, var_15_17 + num_5, get_cursor_screen_pos + var_15_7 - num_4, var_15_17 + var_15_8 - num_5, var_15_0, 3)
	Imgui.add_rect(get_cursor_screen_pos + num_4, var_15_17 + num_5, get_cursor_screen_pos + var_15_7 - num_4, var_15_17 + var_15_8 - num_5, var_15_1, 3, 1)

	local num_13 = get_cursor_screen_pos + num_4 + num_6 + num_8
	local num_14 = var_15_17 + num_5 + num_7 + num_9
	local num_15 = get_cursor_screen_pos - num_4 - num_6 + var_15_7 + num_8
	local num_16 = var_15_17 - num_5 - num_7 + var_15_8 + num_9
	local num_17 = num_15 - num_13
	local num_18 = num_16 - num_14

	Imgui.add_line(num_13 - num_12, num_16, num_15 + num_12, num_16, var_15_2, num_11)
	Imgui.add_line(num_13, num_14 - num_12, num_13, num_16 + num_12, var_15_2, num_11)

	local var_15_24 = Color(100, 255, 255, 255)

	Imgui.add_line(num_13, num_14, num_13 + num_17, num_14, var_15_24)
	Imgui.add_text("300", num_13, num_14 - 15, Colors.get("white"))
	Imgui.add_line(num_13, num_14 + num_18 * 0.3333333333333333, num_13 + num_17, num_14 + num_18 * 0.3333333333333333, var_15_24)
	Imgui.add_text("200", num_13, num_14 + num_18 * 0.3333333333333333 - 15, Colors.get("white"))
	Imgui.add_line(num_13, num_14 + num_18 * 0.6666666666666666, num_13 + num_17, num_14 + num_18 * 0.6666666666666666, var_15_24)
	Imgui.add_text("100", num_13, num_14 + num_18 * 0.6666666666666666 - 15, Colors.get("white"))
	Imgui.channel_set_current(1)

	local num_19 = num_13 + 1 / num_2 * num_17
	local num_20 = num_13 + num_17
	local var_15_27 = num_14
	local num_21 = num_14 + num_18 - num_18 * self._min_power_level / self._max_power_level
	local num_22 = 0
	local var_15_30
	local _power_level_settings = self:_power_level_settings()
	local pivots = _power_level_settings.pivots
	local clone = table.clone(pivots)

	for k, v in pairs(pivots) do
		repeat
			if not string.find(k, self._filter) then
				break
			end

			local _graph_colors = self:_graph_colors(k)
			local get

			if not Colors.color_definitions[_graph_colors.hi] then
				get = Colors.get(_graph_colors.hi)

				if not get then
					-- Nothing
				end
			end

			get = Colors.get(self._fallback_color)

			do
				local get_2
			end

			::label_15_0::

			if not Colors.color_definitions[_graph_colors.low] then
				get_2 = Colors.get(_graph_colors.low)

				if not get_2 then
					-- Nothing
				end
			end

			get_2 = Colors.get(self._fallback_color)

			::label_15_1::

			local min = v.low.min
			local max = v.low.max
			local min_2 = v.hi.min
			local max_2 = v.hi.max
			local num_23 = 1 / num_2
			local calculate_power_level, var_15_43 = LootChestData.calculate_power_level(1, v)
			local num_24 = calculate_power_level / self._max_power_level
			local num_25 = var_15_43 / self._max_power_level
			local var_15_46
			local var_15_47
			local _nan_backup, var_15_49 = self:_nan_backup(num_24, var_15_46)
			local _nan_backup_2, var_15_51 = self:_nan_backup(num_25, var_15_47)

			for k_2 = 1, num do
				local num_26 = k_2 / num

				if num_26 * num_2 > 1 then
					local calculate_power_level_2, var_15_54 = LootChestData.calculate_power_level(num_26 * num_2, v)
					local num_27 = calculate_power_level_2 / self._max_power_level
					local num_28 = var_15_54 / self._max_power_level
					local _nan_backup_3

					_nan_backup_3, var_15_49 = self:_nan_backup(num_27, var_15_49)

					local _nan_backup_4

					_nan_backup_4, var_15_51 = self:_nan_backup(num_28, var_15_51)

					Imgui.add_line(num_13 + num_17 * num_23, num_14 + num_18 - num_18 * _nan_backup_2, num_13 + num_17 * num_26, num_14 + num_18 - num_18 * _nan_backup_4, get, 1.5)
					Imgui.add_line(num_13 + num_17 * num_23, num_14 + num_18 - num_18 * _nan_backup, num_13 + num_17 * num_26, num_14 + num_18 - num_18 * _nan_backup_3, get_2, 1.5)

					num_23 = num_26
					_nan_backup_2 = _nan_backup_4
					_nan_backup = _nan_backup_3
				end
			end

			if not var_15_49 then
				num_22 = num_22 + 1

				local get_cursor_screen_pos_2, var_15_60 = Imgui.get_cursor_screen_pos()

				Imgui.set_cursor_screen_pos(num_13 + 10, num_14 + num_18 - 20 * num_22)
				Imgui.push_style_color(Imgui.COLOR_TEXT, 255, 0, 0, 255)
				Imgui.text("Error: nan value detected in: " .. k .. "; low")
				Imgui.pop_style_color(1)
				Imgui.set_cursor_screen_pos(get_cursor_screen_pos_2, var_15_60)
			end

			if not var_15_51 then
				num_22 = num_22 + 1

				local get_cursor_screen_pos_3, var_15_62 = Imgui.get_cursor_screen_pos()

				Imgui.set_cursor_screen_pos(num_13 + 10, num_14 + num_18 - 20 * num_22)
				Imgui.push_style_color(Imgui.COLOR_TEXT, 255, 0, 0, 255)
				Imgui.text("Error: nan value detected in: " .. k .. "; high")
				Imgui.pop_style_color(1)
				Imgui.set_cursor_screen_pos(get_cursor_screen_pos_3, var_15_62)
			end
		until true
	end

	Imgui.channels_merge()
	Imgui.dummy(var_15_7, var_15_8)

	local get_item_rect_min, var_15_64 = Imgui.get_item_rect_min()

	if not Imgui.is_item_hovered() then
		local axis = Mouse.axis(Mouse.axis_id("cursor"))
		local get_window_pos, var_15_67 = Imgui.get_window_pos()
		local resolution, var_15_69 = Application.resolution()
		local x = axis.x
		local num_29 = math.clamp(axis.x, num_19, num_20) - num_19
		local round_to_closest_multiple = math.round_to_closest_multiple(num_29, 1 / num_2 * num_17)
		local num_30 = num_19 + round_to_closest_multiple
		local clamp = math.clamp(num_30, num_19, num_20)
		local clamp_2 = math.clamp(var_15_69 - axis.y + num_3, var_15_27, num_21)

		Imgui.add_line(clamp, num_14, clamp, num_14 + num_18, Colors.get("white"))

		local num_31 = (1 - (clamp_2 - num_14) / num_18) * self._max_power_level
		local huge = math.huge
		local num_32 = 0
		local var_15_79
		local round = math.round(round_to_closest_multiple / num_17 * num_2)

		for k_3, v_2 in pairs(pivots) do
			repeat
				if not string.find(k_3, self._filter) then
					break
				end

				local _graph_colors_2 = self:_graph_colors(k_3)
				local get_3

				if not Colors.color_definitions[_graph_colors_2.hi] then
					get_3 = Colors.get(_graph_colors_2.hi)

					if not get_3 then
						-- Nothing
					end
				end

				get_3 = Colors.get(self._fallback_color)

				do
					local get_4
				end

				::label_15_2::

				if not Colors.color_definitions[_graph_colors_2.low] then
					get_4 = Colors.get(_graph_colors_2.low)

					if not get_4 then
						-- Nothing
					end
				end

				get_4 = Colors.get(self._fallback_color)

				::label_15_3::

				local num_33 = 1 / num_2
				local calculate_power_level_3, var_15_86 = LootChestData.calculate_power_level(round, v_2)
				local round_2, round_3 = math.round(calculate_power_level_3), math.round(var_15_86)

				if huge > math.abs(round_2 - num_31) then
					num_32 = round_2
					huge = math.abs(round_2 - num_31)
					var_15_79 = get_4
				end

				if huge > math.abs(round_3 - num_31) then
					num_32 = round_3
					huge = math.abs(round_3 - num_31)
					var_15_79 = get_3
				end
			until true
		end

		if num_32 ~= 0 then
			local num_34 = num_14 + num_18 - num_32 / self._max_power_level * num_18

			Imgui.add_text(tostring(num_32), clamp + 5, num_34 - 15, var_15_79)
			Imgui.add_text(tostring(round), clamp, num_14 + num_18, Colors.get("white"))
		end
	end

	Imgui.dummy(var_15_7, 5)
	Imgui.separator()
	Imgui.dummy(var_15_7, 5)
	Imgui.tree_push(self:_next_control_id())
	Imgui.unindent()
	Imgui.text("Easing Function")
	Imgui.same_line()

	self._easing_func_index = Imgui.combo("", self._easing_func_index, self._easing_as_array)

	Imgui.indent()
	Imgui.tree_pop()

	_power_level_settings.easing_function = self._easing_functions[self._easing_func_index].ease
	_power_level_settings.inverse_easing_function = self._easing_functions[self._easing_func_index].inverse

	Imgui.same_line()
	Imgui.indent(350)
	Imgui.tree_push(self:_next_control_id())
	Imgui.unindent()
	Imgui.text("Filter")
	Imgui.same_line()

	self._filter = Imgui.input_text("", self._filter)

	Imgui.indent()
	Imgui.tree_pop()
	Imgui.unindent(350)
	Imgui.dummy(var_15_7, 5)
	Imgui.separator()
	Imgui.dummy(var_15_7, 5)
	Imgui.columns(8)

	local _sorted_pivot_keys = self:_sorted_pivot_keys(pivots)
	local var_15_91

	for i5 = 1, #_sorted_pivot_keys do
		repeat
			local var_15_92 = _sorted_pivot_keys[i5]

			if not string.find(var_15_92, self._filter) then
				break
			end

			local var_15_93 = pivots[var_15_92]

			Imgui.set_column_width(123)
			Imgui.tree_push(self:_next_control_id())
			Imgui.unindent()

			if not Imgui.button("x") then
				pivots[var_15_92] = nil

				Imgui.indent()
				Imgui.tree_pop()

				break
			end

			Imgui.same_line()
			Imgui.push_item_width(85)

			local input_text = Imgui.input_text
			local str = ""
			local _pivot_key_edit

			if self._pivot_key_original == var_15_92 then
				_pivot_key_edit = self._pivot_key_edit

				if not _pivot_key_edit then
					-- Nothing
				end
			end

			_pivot_key_edit = var_15_92

			::label_15_4::

			local var_15_97 = input_text(str, _pivot_key_edit)
			local is_item_active = Imgui.is_item_active()

			Imgui.indent()
			Imgui.tree_pop()
			Imgui.pop_item_width()

			if not ((is_item_active or var_15_92 == self._pivot_key_original) and var_15_97 == var_15_92) then
				if not is_item_active then
					self._pivot_key_edit = var_15_97
					self._pivot_key_original = var_15_92
				else
					pivots[var_15_92] = nil
					pivots[var_15_97] = var_15_93
					self._pivot_key_edit = nil
					self._pivot_key_original = nil

					break
				end
			end

			self:_draw_pivot_edit_row(var_15_92, var_15_93.low, "low", 0, "low")
			self:_draw_pivot_edit_row(var_15_92, var_15_93.hi, "high", 1, "hi")
			Imgui.next_column()

			var_15_91 = var_15_93
		until true
	end

	Imgui.columns(1)

	if not Imgui.button("Add") then
		local str_2 = ""

		while not pivots[str_2] do
			str_2 = str_2 .. " "
		end

		local clone_2 = table.clone(var_15_91)

		clone_2 = clone_2 or {
			pivot_level = 30,
			min = 10,
			pivot_power = 300,
			max = 300
		}
		pivots[str_2] = clone_2
	end

	Imgui.same_line()

	if not Imgui.button("Reset") then
		Managers.backend:get_interface("loot"):debug_override_power_level_settings(self._default_settings)
	end

	if not table.deep_equal(clone, pivots) then
		self._history_index = self._history_index + 1
		self._history[self._history_index] = table.clone(_power_level_settings)

		for i6 = self._history_index + 1, #self._history do
			self._history[i6] = nil
		end
	end
end

ImguiGeneratePowerLevelPivots._draw_pivot_edit_row = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	for i = 1, arg_16_4 do
		Imgui.next_column()
	end

	Imgui.next_column()
	Imgui.set_column_width(50)
	Imgui.text(arg_16_3)

	for j = 1, #tbl do
		Imgui.next_column()

		local var_16_0 = tbl[j]
		local data

		if not var_16_0.data then
			data = var_16_0.data(self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)

			if not data then
				-- Nothing
			end
		end

		data = arg_16_2

		::label_16_0::

		local column_width = var_16_0.column_width
		local label = var_16_0.label

		label = label or var_16_0.key

		local key

		if type(var_16_0.key) == "function" then
			key = var_16_0.key(self, arg_16_1, arg_16_2, label, arg_16_4, arg_16_5)

			if not key then
				-- Nothing
			end
		end

		key = var_16_0.key

		::label_16_1::

		local split = string.split(key, ".")
		local max

		if type(var_16_0.max) == "function" then
			max = var_16_0.max(self, arg_16_1, arg_16_2, label, arg_16_4, arg_16_5)

			if not max then
				-- Nothing
			end
		end

		max = var_16_0.max

		::label_16_2::

		local type = var_16_0.type

		Imgui.set_column_width(column_width)

		local num = 0

		if not label then
			num = Imgui.calculate_text_size(label)

			Imgui.text(label)
			Imgui.same_line()
		end

		if not split then
			Imgui.tree_push(self:_next_control_id())
			Imgui.unindent()

			for k = 1, #split - 1 do
				data = data[split[k]]
			end

			local var_16_9 = split[#split]

			Imgui.dummy(num, 0)
			Imgui.same_line()
			Imgui.push_item_width(column_width - num)

			if type == "float" then
				local input_text = Imgui.input_text
				local str = ""
				local tostring = tostring
				local var_16_13 = data[var_16_9]

				var_16_13 = var_16_13 or 0
				data[var_16_9] = input_text(str, tostring(var_16_13))

				local var_16_14 = tonumber(data[var_16_9])

				var_16_14 = var_16_14 or 0
				data[var_16_9] = var_16_14
			elseif type == "slider_float" then
				local slider_float = Imgui.slider_float
				local str_2 = ""
				local var_16_17 = data[var_16_9]
				local min = var_16_0.min

				min = min or 0

				local var_16_19 = slider_float(str_2, var_16_17, min, max or 1)

				var_16_19 = var_16_19 or 0
				data[var_16_9] = var_16_19
			elseif type == "slider_int" then
				local slider_int = Imgui.slider_int
				local str_3 = ""
				local var_16_22 = data[var_16_9]
				local min_2 = var_16_0.min

				min_2 = min_2 or 0

				local var_16_24 = slider_int(str_3, var_16_22, min_2, max or 1)

				var_16_24 = var_16_24 or 0
				data[var_16_9] = var_16_24
			elseif type == "text" then
				local input_text_2 = Imgui.input_text("", data[var_16_9])

				input_text_2 = input_text_2 or ""
				data[var_16_9] = input_text_2
			end

			Imgui.pop_item_width()

			if not var_16_0.precision then
				data[var_16_9] = math.round_to_closest_multiple(data[var_16_9], var_16_0.precision)
			end

			Imgui.indent()
			Imgui.tree_pop()
		end
	end
end

ImguiGeneratePowerLevelPivots._draw_code = function (self, arg_17_1)
	-- function 17
	Imgui.push_item_width(arg_17_1[1])

	local _power_level_settings = self:_power_level_settings()
	local save_simple = scripts_utils_serialize.save_simple(_power_level_settings)
	local input_text_multiline = Imgui.input_text_multiline("", save_simple, arg_17_1[2])
	local var_17_3, var_17_4 = pcall(function ()
		-- function 18
		return cjson.decode(input_text_multiline)
	end)

	if not var_17_3 then
		Managers.backend:get_interface("loot"):debug_override_power_level_settings(var_17_4)
	else
		local str = "Error: " .. var_17_4

		Imgui.text(str)
	end

	Imgui.text("Code doesn't support clipboard. Need to implement serializer.")
	Imgui.pop_item_width()
end

ImguiGeneratePowerLevelPivots._draw_summary = function (self, arg_19_1)
	-- function 19
	local pivots = self:_power_level_settings().pivots
	local _sorted_pivot_keys = self:_sorted_pivot_keys(pivots)
	local num = 47
	local num_3 = (arg_19_1 - 47) / #_sorted_pivot_keys * 0.5

	Imgui.columns(1 + #_sorted_pivot_keys * 2)
	Imgui.set_column_width(num)
	Imgui.text("Level")

	for i = 1, #_sorted_pivot_keys do
		local var_19_4 = _sorted_pivot_keys[i]
		local var_19_5 = pivots[var_19_4]
		local var_19_6 = DifficultySettings[var_19_4]
		local var_19_7

		if not var_19_6 and not var_19_6.display_name then
			var_19_7 = Localize(var_19_6.display_name)

			if not var_19_7 then
				-- Nothing
			end
		end

		var_19_7 = var_19_4

		::label_19_0::

		Imgui.next_column()
		Imgui.set_column_width(num_3)
		Imgui.text(var_19_7 .. " min")
		Imgui.next_column()
		Imgui.set_column_width(num_3)
		Imgui.text(var_19_7 .. " max")
	end

	Imgui.separator()

	for j = 1, num_2 do
		Imgui.next_column()
		Imgui.set_column_width(num)
		Imgui.text(j)

		for k = 1, #_sorted_pivot_keys do
			local var_19_8 = _sorted_pivot_keys[k]
			local var_19_9 = pivots[var_19_8]
			local _graph_colors = self:_graph_colors(var_19_8)
			local hi = _graph_colors.hi
			local low = _graph_colors.low
			local calculate_power_level, var_19_14 = LootChestData.calculate_power_level(j, var_19_9)

			Imgui.push_style_color(Imgui.COLOR_TEXT, unpack(Colors.get_table_rgba(hi)))
			Imgui.next_column()
			Imgui.set_column_width(num_3)
			Imgui.text(math.round(calculate_power_level))
			Imgui.push_style_color(Imgui.COLOR_TEXT, unpack(Colors.get_table_rgba(low)))
			Imgui.next_column()
			Imgui.set_column_width(num_3)
			Imgui.text(math.round(var_19_14))
			Imgui.pop_style_color(2)
		end

		Imgui.separator()

		if not (j % 5 ~= 0 or j == num_2) then
			Imgui.separator()
		end
	end
end

ImguiGeneratePowerLevelPivots._sorted_pivot_keys = function (arg_20_0, arg_20_1)
	-- function 20
	local keys = table.keys(arg_20_1)

	table.sort(keys, function (arg_21_0, arg_21_1)
		-- function 21
		if not arg_20_0._display_order[arg_21_0] then
			local var_21_0 = arg_20_0._display_order[arg_21_0]
			local var_21_1 = arg_20_0._display_order[arg_21_1]

			var_21_1 = var_21_1 or math.huge

			return var_21_0 < var_21_1
		elseif not arg_20_0._display_order[arg_21_1] then
			return false
		end

		return arg_21_0 < arg_21_1
	end)

	return keys
end

ImguiGeneratePowerLevelPivots._graph_colors = function (self, arg_22_1)
	-- function 22
	local _colors = self._colors
	local var_22_1 = self._colors[arg_22_1]

	var_22_1 = var_22_1 or {
		hi = self._fallback_color,
		low = self._fallback_color
	}
	_colors[arg_22_1] = var_22_1

	local tbl = {}
	local hi

	if not Colors.color_definitions[self._colors[arg_22_1].hi] then
		hi = self._colors[arg_22_1].hi

		if not hi then
			-- Nothing
		end
	end

	hi = self._fallback_color

	::label_22_0::

	tbl.hi = hi

	local low

	if not Colors.color_definitions[self._colors[arg_22_1].low] then
		low = self._colors[arg_22_1].low

		if not low then
			-- Nothing
		end
	end

	low = self._fallback_color

	::label_22_1::

	tbl.low = low

	return tbl
end
