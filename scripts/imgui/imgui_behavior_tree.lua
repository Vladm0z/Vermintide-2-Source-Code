-- chunkname: @scripts/imgui/imgui_behavior_tree.lua

ImguiBehaviorTree = class(ImguiBehaviorTree)

ImguiBehaviorTree.init = function (self, arg_1_1, ...)
	-- function 1
	self._window_width = 1800
	self._window_height = 1000
	self._padding = 38
	self._show_graph_settings = false
	self._show_considerations = false
	self._left_panel_width = 600
	self._scrolling = {
		x = 0,
		y = 0
	}
	self._node_size = {
		width = 150,
		height = 0
	}
	self._grid_size = 64
	self._offset = {
		x = 0,
		y = 0
	}
	self._zoom = 1
	self._node_inner_padding = {
		x = 5,
		y = 5
	}
	self._node_font_size = 10
	self._node_text_distance = 10
	self._use_width_padding_zoom = true
	self._use_height_padding_zoom = true
	self._zoom_speed = 0.1
	self._original_font_size = Imgui.get_font_size()
	self._curve_in_offset = {
		x = -50,
		y = 0
	}
	self._curve_out_offset = {
		x = 50,
		y = 0
	}
	self._running_blackboard = nil
	self._last_leaf_node_run = nil
	self._running_leaf_history = {}
	self._max_history_quantity = 5
	self._history_id = 1
	self._use_history_slider = false
	self._history_stack = {}
end

ImguiBehaviorTree._update_leaf_history = function (self, arg_2_1)
	-- function 2
	self._running_leaf_history[#self._running_leaf_history + 1] = arg_2_1

	if #self._running_leaf_history > self._max_history_quantity then
		local num = #self._running_leaf_history - self._max_history_quantity

		for i = 1, num do
			table.remove(self._running_leaf_history, i)
		end
	end
end

ImguiBehaviorTree._calculate_rect_box = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local calculate_text_size, var_3_1 = Imgui.calculate_text_size(arg_3_1)
	local calculate_text_size_2, var_3_3 = Imgui.calculate_text_size(arg_3_2)
	local calculate_text_size_3, var_3_5 = Imgui.calculate_text_size(arg_3_3)
	local max = math.max(calculate_text_size, calculate_text_size_2, calculate_text_size_3)
	local num = var_3_1 + var_3_3 + var_3_5

	return max, num
end

ImguiBehaviorTree._draw_node = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local _identifier = arg_4_3._identifier
	local name = arg_4_3.name
	local _condition_name = arg_4_3._condition_name
	local var_4_3 = Color(500, 255, 255, 255)
	local var_4_4 = Color(255, 0, 0, 0)
	local var_4_5 = Color(255, 0, 0, 200)
	local var_4_6 = Color(255, 100, 100, 100)
	local var_4_7 = Color(255, 255, 255, 255)
	local var_4_8 = Color(255, 255, 255, 255)
	local var_4_9 = Color(255, 240, 130, 10)
	local num = 1
	local num_2 = 1

	if #self._history_stack > 0 then
		if not self._use_history_slider then
			self._history_id = #self._history_stack
		end

		local var_4_12 = self._history_stack[self._history_id]

		if not table.contains(var_4_12.blackboard.running_nodes, arg_4_3) then
			var_4_6 = var_4_9
			var_4_8 = var_4_9
			num_2 = 4
		end
	end

	Imgui.set_window_font_scale(self._node_font_size / self._original_font_size * self._zoom)
	Imgui.channel_set_current(1)

	local _calculate_rect_box, var_4_14 = self:_calculate_rect_box(name, _identifier, _condition_name)
	local num_3 = self._node_text_distance * self._zoom
	local num_4 = self._offset.x + arg_4_1
	local num_5 = self._offset.y + arg_4_2
	local num_6 = num_4 + _calculate_rect_box
	local num_7 = num_5 + var_4_14

	Imgui.add_text(name, num_4, num_5, var_4_3, self._node_font_size * self._zoom)
	Imgui.add_text(_identifier, num_4, num_5 + num_3, var_4_4, self._node_font_size * self._zoom)
	Imgui.add_text(_condition_name, num_4, num_5 + num_3 + num_3, var_4_5, self._node_font_size * self._zoom)

	local num_8 = num_4 - self._node_inner_padding.x
	local num_9 = num_5 - self._node_inner_padding.y
	local num_10 = num_6 + self._node_inner_padding.x
	local num_11 = num_7 + self._node_inner_padding.y

	Imgui.channel_set_current(0)
	Imgui.add_rect_filled(num_8, num_9, num_10, num_11, var_4_6, 5)
	Imgui.add_rect(num_8, num_9, num_10, num_11, var_4_7, 5, num)
	Imgui.channel_set_current(1)

	local var_4_24 = num_8
	local num_12 = num_9 + (num_11 - num_9) / 2

	if arg_4_4 ~= nil then
		Imgui.add_bezier_curve(arg_4_4.x, arg_4_4.y, var_4_24, num_12, self._curve_out_offset.x, self._curve_out_offset.y, self._curve_in_offset.x, self._curve_in_offset.y, var_4_8, num_2)
	end

	local tbl = {
		x = 0,
		y = 0,
		x = num_4 + (num_10 - num_4),
		y = num_9 + (num_11 - num_9) / 2
	}

	return num_10 - num_4, tbl
end

ImguiBehaviorTree._draw_nodes = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local _draw_node, var_5_1 = self:_draw_node(arg_5_2, arg_5_3, arg_5_1, arg_5_4)
	local num = 0

	if not arg_5_1._children then
		local _padding = self._padding
		local _use_width_padding_zoom = self._use_width_padding_zoom
		local _zoom = self._zoom
		local flag = not _use_width_padding_zoom and _zoom and 1
		local flag_2 = not _use_width_padding_zoom and _zoom and 1

		arg_5_2 = arg_5_2 + _draw_node + _padding * flag

		for k, v in pairs(arg_5_1._children) do
			arg_5_3 = self:_draw_nodes(v, arg_5_2, arg_5_3, var_5_1)
			num = num + 1

			if num < table.size(arg_5_1._children) then
				arg_5_3 = arg_5_3 + _padding * flag_2
			end
		end
	end

	return arg_5_3
end

ImguiBehaviorTree._get_blackboard_value_type = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	for k, v in pairs(arg_6_2) do
		if k == arg_6_1 then
			arg_6_3 = arg_6_2[arg_6_1]

			return arg_6_3
		end

		if type(v) == "table" then
			arg_6_3 = self:_get_blackboard_value_type(arg_6_1, v, arg_6_3)

			if arg_6_3 ~= nil then
				return arg_6_3
			end
		end
	end

	return arg_6_3
end

ImguiBehaviorTree._draw_blackboard_element = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = type(arg_7_2)

	Imgui.indent(10)

	if var_7_0 == "Vector3Box" then
		local unbox = arg_7_2:unbox()

		Imgui.text(tostring(arg_7_1) .. ": " .. "X:" .. tostring(unbox.x) .. " Y:" .. tostring(unbox.y) .. " Z:" .. tostring(unbox.z))
	elseif type(arg_7_2) == "boolean" then
		Imgui.text(tostring(arg_7_1) .. ": " .. tostring(arg_7_2))
	elseif type(arg_7_2) == "string" then
		Imgui.text(tostring(arg_7_1) .. ": " .. tostring(arg_7_2))
	elseif var_7_0 == "number" then
		Imgui.text(tostring(arg_7_1) .. ": " .. tostring(arg_7_2))
	elseif var_7_0 == "float" then
		Imgui.text(tostring(arg_7_1) .. ": " .. tostring(arg_7_2))
	elseif var_7_0 == "Unit" then
		Imgui.text(arg_7_1 .. ": " .. tostring(arg_7_2))
	end

	Imgui.unindent(10)
end

ImguiBehaviorTree._draw_blackboard_value = function (self, arg_8_1)
	-- function 8
	for k, v in pairs(arg_8_1) do
		if k ~= "running_nodes" then
			if type(v) == "table" then
				Imgui.text_colored(k, 255, 153, 102, 255)

				for k_2, v_2 in pairs(v) do
					self:_draw_blackboard_element(k_2, v_2)
				end
			else
				self:_draw_blackboard_element(k, v)
			end
		end
	end
end

ImguiBehaviorTree._save_history = function (self, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0

	for k, v in pairs(arg_9_1._blackboard.running_nodes) do
		if v._identifier == arg_9_2 then
			var_9_0 = v
		end
	end

	if var_9_0 == nil then
		return
	end

	self._last_leaf_node_run = arg_9_2

	local num = 1
	local var_9_2 = var_9_0
	local tbl = {}

	if var_9_2 ~= nil then
		while not var_9_2 do
			tbl[num] = var_9_2
			num = num + 1
			var_9_2 = var_9_2._parent
		end
	end

	local tbl_2 = {}

	for k_2, v_2 in pairs(arg_9_1._blackboard) do
		tbl_2[k_2] = v_2

		if type(v_2) == "table" then
			for k_3, v_3 in pairs(v_2) do
				if type(v_3) ~= "table" then
					v_2[k_3] = v_3
				end
			end
		end
	end

	tbl_2.running_nodes = tbl

	local tbl_3 = {
		blackboard = tbl_2
	}

	self._history_stack[#self._history_stack + 1] = tbl_3
end

ImguiBehaviorTree.update = function (arg_10_0)
	-- function 10
	return
end

ImguiBehaviorTree.draw = function (self)
	-- function 11
	local begin_window = Imgui.begin_window("Behavior Tree")

	Imgui.set_window_size(self._window_width, self._window_height, "once")

	self._show_considerations = Imgui.checkbox("Show considerations", self._show_considerations)

	Imgui.same_line(10)

	self._use_history_slider = Imgui.checkbox("Use History Slider", self._use_history_slider)

	Imgui.same_line(10)

	self._history_id = Imgui.slider_int("", self._history_id, 1, table.size(self._history_stack))

	Imgui.begin_child_window("Settings", self._left_panel_width, 0, true)

	self._show_graph_settings = Imgui.checkbox("Show Graph Settings", self._show_graph_settings)

	if not self._show_graph_settings then
		Imgui.text_colored("Graph Settings:", 255, 51, 204, 255)

		self._left_panel_width = Imgui.input_int("Panel width", self._left_panel_width)
		self._zoom = Imgui.input_float("Zoom", self._zoom)
		self._zoom_speed = Imgui.input_float("Zoom speed", self._zoom_speed)
		self._padding = Imgui.input_int("Node padding", self._padding)
		self._use_width_padding_zoom = Imgui.checkbox("Use width padding zoom", self._use_width_padding_zoom)
		self._use_height_padding_zoom = Imgui.checkbox("Use height padding zoom", self._use_height_padding_zoom)
		self._max_history_quantity = Imgui.input_int("#Max history", self._max_history_quantity)
		self._node_size.height = Imgui.input_int("Node Height", self._node_size.height)
		self._node_font_size = Imgui.input_int("Node font size", self._node_font_size)
		self._node_text_distance = Imgui.input_int("Node text distance", self._node_text_distance)
		self._node_inner_padding.x, self._node_inner_padding.y = Imgui.input_int_2("Inner Padding", self._node_inner_padding.x, self._node_inner_padding.y)
	end

	Imgui.text_colored("---------------------------------------------------------------------------------------", 255, 51, 204, 255)
	Imgui.text_colored("History leaf nodes:", 255, 51, 204, 255)
	Imgui.indent(10)

	local _running_leaf_history = self._running_leaf_history

	for i = 1, self._max_history_quantity do
		local var_11_2 = _running_leaf_history[i]

		if var_11_2 == nil then
			var_11_2 = ""
		end

		Imgui.text_colored(var_11_2, 250, 250, 250, 250)
	end

	Imgui.unindent(10)
	Imgui.text_colored("---------------------------------------------------------------------------------------", 255, 51, 204, 255)
	Imgui.text_colored("Blackboard:", 255, 51, 204, 255)

	if #self._history_stack > 0 then
		if not self._use_history_slider then
			self._history_id = #self._history_stack
		end

		local var_11_3 = self._history_stack[self._history_id]

		if var_11_3 ~= nil then
			self:_draw_blackboard_value(var_11_3.blackboard)
		end
	end

	Imgui.end_child_window()
	Imgui.same_line(10)
	Imgui.begin_child_window("Graph", 0, 0, true, "no_scroll_bar")
	Imgui.channel_split(2)

	local get_cursor_screen_pos, var_11_5 = Imgui.get_cursor_screen_pos()
	local get_window_size, var_11_7 = Imgui.get_window_size()

	self._offset.x = get_cursor_screen_pos + self._scrolling.x
	self._offset.y = var_11_5 + self._scrolling.y

	local fmod = math.fmod(self._scrolling.x, self._grid_size * self._zoom)
	local fmod_2 = math.fmod(self._scrolling.y, self._grid_size * self._zoom)
	local var_11_10 = Color(255, 100, 100, 100)

	while fmod < get_window_size do
		local num = fmod + get_cursor_screen_pos
		local var_11_12 = var_11_5
		local num_2 = fmod + get_cursor_screen_pos
		local num_3 = var_11_7 + var_11_5

		Imgui.add_line(num, var_11_12, num_2, num_3, var_11_10, 1)

		fmod = fmod + self._grid_size * self._zoom
	end

	while fmod_2 < var_11_7 do
		local var_11_15 = get_cursor_screen_pos
		local num_4 = var_11_5 + fmod_2
		local num_5 = get_window_size + get_cursor_screen_pos
		local num_6 = var_11_5 + fmod_2

		Imgui.add_line(var_11_15, num_4, num_5, num_6, var_11_10, 1)

		fmod_2 = fmod_2 + self._grid_size * self._zoom
	end

	local has_extension = ScriptUnit.has_extension(script_data.debug_unit, "ai_system")

	if not has_extension then
		local brain = has_extension:brain()
		local root = brain:bt():root()
		local _blackboard = brain._blackboard

		if self._running_blackboard ~= _blackboard then
			self._running_blackboard = _blackboard

			table.clear(self._running_leaf_history)
			table.clear(self._history_stack)

			self._last_leaf_node_run = nil
			self._use_history_slider = false
		end

		local _identifier

		if not brain._leaf_node then
			_identifier = brain._leaf_node._identifier

			if not _identifier then
				-- Nothing
			end
		end

		_identifier = _blackboard.btnode_name

		::label_11_0::

		if not (_identifier == nil or _identifier == self._last_leaf_node_run) then
			self:_save_history(brain, _identifier)
			self:_update_leaf_history(_identifier)
		end

		self:_draw_nodes(root, 0, 0)
	end

	if not Imgui.is_window_hovered() and not Imgui.is_mouse_dragging(2, 0) then
		local get_mouse_delta, var_11_25 = Imgui.get_mouse_delta()

		self._scrolling.x = self._scrolling.x + get_mouse_delta
		self._scrolling.y = self._scrolling.y + var_11_25
	end

	local get_mouse_wheel_value = Imgui.get_mouse_wheel_value()

	if not (not Imgui.is_window_hovered() and get_mouse_wheel_value == 0) then
		self._zoom = self._zoom * (1 + get_mouse_wheel_value * self._zoom_speed)
		self._zoom = math.clamp(self._zoom, 0.3, 10)
	end

	Imgui.channels_merge()
	Imgui.end_child_window()
	Imgui.same_line(10)
	Imgui.end_window()

	if not self._show_considerations then
		Imgui.begin_window("Considerations")

		if not has_extension then
			local brain_2 = has_extension:brain()
			local action_data = brain_2:bt():action_data()
			local _blackboard_2 = brain_2._blackboard

			self:_draw_action_data(action_data, _blackboard_2)
		end

		Imgui.end_window()
	end

	return begin_window
end

ImguiBehaviorTree._draw_graph = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local var_12_0 = Color(180, 100, 100, 100)
	local var_12_1 = Color(255, 255, 255, 255)
	local var_12_2 = Color(255, 255, 255, 255)
	local var_12_3 = Color(255, 255, 255, 255)
	local var_12_4 = Color(255, 255, 0, 0)
	local num = 10
	local num_2 = 10
	local num_3 = 300
	local num_4 = 150
	local num_5 = 50
	local num_6 = 20
	local num_7 = -20
	local num_8 = 0
	local num_9 = 1
	local num_10 = 2
	local num_11 = 10
	local spline = arg_12_2.spline
	local blackboard_input = arg_12_2.blackboard_input

	Imgui.text(blackboard_input)
	Imgui.channel_split(2)
	Imgui.channel_set_current(0)

	local get_cursor_screen_pos, var_12_19 = Imgui.get_cursor_screen_pos()

	Imgui.add_rect_filled(get_cursor_screen_pos + num, var_12_19 + num_2, get_cursor_screen_pos + num_3 - num, var_12_19 + num_4 - num_2, var_12_0, 3)
	Imgui.add_rect(get_cursor_screen_pos + num, var_12_19 + num_2, get_cursor_screen_pos + num_3 - num, var_12_19 + num_4 - num_2, var_12_1, 3, 1)

	local num_12 = get_cursor_screen_pos + num + num_5 + num_7
	local num_13 = var_12_19 + num_2 + num_6 + num_8
	local num_14 = get_cursor_screen_pos - num - num_5 + num_3 + num_7
	local num_15 = var_12_19 - num_2 - num_6 + num_4 + num_8
	local num_16 = num_14 - num_12
	local num_17 = num_15 - num_13

	Imgui.add_line(num_12 - num_11, num_15, num_14 + num_11, num_15, var_12_2, num_10)
	Imgui.add_line(num_12, num_13 - num_11, num_12, num_15 + num_11, var_12_2, num_10)

	local max_value = arg_12_2.max_value
	local format = string.format("%.2f", max_value)
	local calculate_text_size, var_12_29 = Imgui.calculate_text_size(format)

	Imgui.add_text(format, num_14 + num_10, num_15 - var_12_29, var_12_2)
	Imgui.channel_set_current(1)

	local var_12_30 = arg_12_4[blackboard_input]

	if not var_12_30 then
		var_12_30 = arg_12_3[blackboard_input]
		var_12_30 = var_12_30 or 0
	end

	local clamp = math.clamp(var_12_30 / max_value, 0, 1)
	local num_18 = 0
	local num_19 = num_12 + spline[1] * num_16
	local num_20 = num_13 + num_17 - spline[2] * num_17

	for i = 3, #spline, 2 do
		local num_21 = num_12 + spline[i] * num_16
		local num_22 = num_13 + num_17 - spline[i + 1] * num_17

		Imgui.add_line(num_19, num_20, num_21, num_22, var_12_3, num_9)

		if not (not (clamp >= spline[i - 2]) or not (clamp <= spline[i])) then
			local num_23 = (clamp - spline[i - 2]) / (spline[i] - spline[i - 2])

			num_18 = spline[i - 1] + (spline[i + 1] - spline[i - 1]) * num_23
		end

		num_19 = num_21
		num_20 = num_22
	end

	if not var_12_30 then
		local num_24 = num_12 + clamp * num_16

		Imgui.add_line(num_24, num_13, num_24, num_15 + num_11, var_12_4, num_10)

		local format_2 = string.format("%.2f", var_12_30)

		Imgui.add_text(format_2, num_24 + num_10, num_15, var_12_4)

		local format_3 = string.format("%.2f", num_18)

		Imgui.add_text(format_3, num_24 + num_10, num_13, var_12_4)
	end

	Imgui.channels_merge()
	Imgui.dummy(num_3, num_4)
end

ImguiBehaviorTree._draw_action_data = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_1 then
		return
	end

	local var_13_0 = Color(255, 0, 255, 0)
	local var_13_1 = Color(255, 255, 0, 0)

	for k, v in pairs(arg_13_1) do
		local considerations = v.considerations

		if not considerations and not Imgui.tree_node(k) then
			for k_2, v_2 in pairs(considerations) do
				if not v_2.spline then
					self:_draw_graph(k_2, v_2, arg_13_2, arg_13_1)
				elseif not v_2.is_condition then
					local blackboard_input = v_2.blackboard_input
					local var_13_4 = arg_13_1[blackboard_input]

					var_13_4 = var_13_4 or arg_13_2[blackboard_input]

					if not considerations.invert then
						var_13_4 = not var_13_4
					end

					local flag

					flag = not var_13_4 and "true" and "false"

					Imgui.text(k_2)

					if k_2 ~= blackboard_input then
						Imgui.same_line()
						Imgui.text("(")
						Imgui.text(blackboard_input)
						Imgui.text(")")
					end

					Imgui.same_line()

					if not var_13_4 then
						Imgui.text_colored("true", 0, 255, 0, 255)
					else
						Imgui.text_colored("false", 255, 0, 0, 255)
					end
				end

				Imgui.separator()
			end

			Imgui.tree_pop()
			Imgui.separator()
		end
	end
end

ImguiBehaviorTree.is_persistent = function (arg_14_0)
	-- function 14
	return true
end

return ImguiBehaviorTree
