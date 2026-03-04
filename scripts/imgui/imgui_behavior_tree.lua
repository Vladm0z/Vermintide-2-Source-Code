-- chunkname: @scripts/imgui/imgui_behavior_tree.lua

ImguiBehaviorTree = class(ImguiBehaviorTree)

ImguiBehaviorTree.init = function (arg_1_0, arg_1_1, ...)
	arg_1_0._window_width = 1800
	arg_1_0._window_height = 1000
	arg_1_0._padding = 38
	arg_1_0._show_graph_settings = false
	arg_1_0._show_considerations = false
	arg_1_0._left_panel_width = 600
	arg_1_0._scrolling = {
		x = 0,
		y = 0
	}
	arg_1_0._node_size = {
		width = 150,
		height = 0
	}
	arg_1_0._grid_size = 64
	arg_1_0._offset = {
		x = 0,
		y = 0
	}
	arg_1_0._zoom = 1
	arg_1_0._node_inner_padding = {
		x = 5,
		y = 5
	}
	arg_1_0._node_font_size = 10
	arg_1_0._node_text_distance = 10
	arg_1_0._use_width_padding_zoom = true
	arg_1_0._use_height_padding_zoom = true
	arg_1_0._zoom_speed = 0.1
	arg_1_0._original_font_size = Imgui.get_font_size()
	arg_1_0._curve_in_offset = {
		x = -50,
		y = 0
	}
	arg_1_0._curve_out_offset = {
		x = 50,
		y = 0
	}
	arg_1_0._running_blackboard = nil
	arg_1_0._last_leaf_node_run = nil
	arg_1_0._running_leaf_history = {}
	arg_1_0._max_history_quantity = 5
	arg_1_0._history_id = 1
	arg_1_0._use_history_slider = false
	arg_1_0._history_stack = {}
end

ImguiBehaviorTree._update_leaf_history = function (arg_2_0, arg_2_1)
	arg_2_0._running_leaf_history[#arg_2_0._running_leaf_history + 1] = arg_2_1

	if #arg_2_0._running_leaf_history > arg_2_0._max_history_quantity then
		local var_2_0 = #arg_2_0._running_leaf_history - arg_2_0._max_history_quantity

		for iter_2_0 = 1, var_2_0 do
			table.remove(arg_2_0._running_leaf_history, iter_2_0)
		end
	end
end

ImguiBehaviorTree._calculate_rect_box = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0, var_3_1 = Imgui.calculate_text_size(arg_3_1)
	local var_3_2, var_3_3 = Imgui.calculate_text_size(arg_3_2)
	local var_3_4, var_3_5 = Imgui.calculate_text_size(arg_3_3)
	local var_3_6 = math.max(var_3_0, var_3_2, var_3_4)
	local var_3_7 = var_3_1 + var_3_3 + var_3_5

	return var_3_6, var_3_7
end

ImguiBehaviorTree._draw_node = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_3._identifier
	local var_4_1 = arg_4_3.name
	local var_4_2 = arg_4_3._condition_name
	local var_4_3 = Color(500, 255, 255, 255)
	local var_4_4 = Color(255, 0, 0, 0)
	local var_4_5 = Color(255, 0, 0, 200)
	local var_4_6 = Color(255, 100, 100, 100)
	local var_4_7 = Color(255, 255, 255, 255)
	local var_4_8 = Color(255, 255, 255, 255)
	local var_4_9 = Color(255, 240, 130, 10)
	local var_4_10 = 1
	local var_4_11 = 1

	if #arg_4_0._history_stack > 0 then
		if not arg_4_0._use_history_slider then
			arg_4_0._history_id = #arg_4_0._history_stack
		end

		local var_4_12 = arg_4_0._history_stack[arg_4_0._history_id]

		if table.contains(var_4_12.blackboard.running_nodes, arg_4_3) then
			var_4_6 = var_4_9
			var_4_8 = var_4_9
			var_4_11 = 4
		end
	end

	Imgui.set_window_font_scale(arg_4_0._node_font_size / arg_4_0._original_font_size * arg_4_0._zoom)
	Imgui.channel_set_current(1)

	local var_4_13, var_4_14 = arg_4_0:_calculate_rect_box(var_4_1, var_4_0, var_4_2)
	local var_4_15 = arg_4_0._node_text_distance * arg_4_0._zoom
	local var_4_16 = arg_4_0._offset.x + arg_4_1
	local var_4_17 = arg_4_0._offset.y + arg_4_2
	local var_4_18 = var_4_16 + var_4_13
	local var_4_19 = var_4_17 + var_4_14

	Imgui.add_text(var_4_1, var_4_16, var_4_17, var_4_3, arg_4_0._node_font_size * arg_4_0._zoom)
	Imgui.add_text(var_4_0, var_4_16, var_4_17 + var_4_15, var_4_4, arg_4_0._node_font_size * arg_4_0._zoom)
	Imgui.add_text(var_4_2, var_4_16, var_4_17 + var_4_15 + var_4_15, var_4_5, arg_4_0._node_font_size * arg_4_0._zoom)

	local var_4_20 = var_4_16 - arg_4_0._node_inner_padding.x
	local var_4_21 = var_4_17 - arg_4_0._node_inner_padding.y
	local var_4_22 = var_4_18 + arg_4_0._node_inner_padding.x
	local var_4_23 = var_4_19 + arg_4_0._node_inner_padding.y

	Imgui.channel_set_current(0)
	Imgui.add_rect_filled(var_4_20, var_4_21, var_4_22, var_4_23, var_4_6, 5)
	Imgui.add_rect(var_4_20, var_4_21, var_4_22, var_4_23, var_4_7, 5, var_4_10)
	Imgui.channel_set_current(1)

	local var_4_24 = var_4_20
	local var_4_25 = var_4_21 + (var_4_23 - var_4_21) / 2

	if arg_4_4 ~= nil then
		Imgui.add_bezier_curve(arg_4_4.x, arg_4_4.y, var_4_24, var_4_25, arg_4_0._curve_out_offset.x, arg_4_0._curve_out_offset.y, arg_4_0._curve_in_offset.x, arg_4_0._curve_in_offset.y, var_4_8, var_4_11)
	end

	local var_4_26 = {
		x = 0,
		y = 0,
		x = var_4_16 + (var_4_22 - var_4_16),
		y = var_4_21 + (var_4_23 - var_4_21) / 2
	}

	return var_4_22 - var_4_16, var_4_26
end

ImguiBehaviorTree._draw_nodes = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0, var_5_1 = arg_5_0:_draw_node(arg_5_2, arg_5_3, arg_5_1, arg_5_4)
	local var_5_2 = 0

	if arg_5_1._children then
		local var_5_3 = arg_5_0._padding
		local var_5_4 = arg_5_0._use_width_padding_zoom
		local var_5_5 = arg_5_0._zoom
		local var_5_6 = var_5_4 and var_5_5 or 1
		local var_5_7 = var_5_4 and var_5_5 or 1

		arg_5_2 = arg_5_2 + var_5_0 + var_5_3 * var_5_6

		for iter_5_0, iter_5_1 in pairs(arg_5_1._children) do
			arg_5_3 = arg_5_0:_draw_nodes(iter_5_1, arg_5_2, arg_5_3, var_5_1)
			var_5_2 = var_5_2 + 1

			if var_5_2 < table.size(arg_5_1._children) then
				arg_5_3 = arg_5_3 + var_5_3 * var_5_7
			end
		end
	end

	return arg_5_3
end

ImguiBehaviorTree._get_blackboard_value_type = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	for iter_6_0, iter_6_1 in pairs(arg_6_2) do
		if iter_6_0 == arg_6_1 then
			arg_6_3 = arg_6_2[arg_6_1]

			return arg_6_3
		end

		if type(iter_6_1) == "table" then
			arg_6_3 = arg_6_0:_get_blackboard_value_type(arg_6_1, iter_6_1, arg_6_3)

			if arg_6_3 ~= nil then
				return arg_6_3
			end
		end
	end

	return arg_6_3
end

ImguiBehaviorTree._draw_blackboard_element = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = type(arg_7_2)

	Imgui.indent(10)

	if var_7_0 == "Vector3Box" then
		local var_7_1 = arg_7_2:unbox()

		Imgui.text(tostring(arg_7_1) .. ": " .. "X:" .. tostring(var_7_1.x) .. " Y:" .. tostring(var_7_1.y) .. " Z:" .. tostring(var_7_1.z))
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

ImguiBehaviorTree._draw_blackboard_value = function (arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if iter_8_0 ~= "running_nodes" then
			if type(iter_8_1) == "table" then
				Imgui.text_colored(iter_8_0, 255, 153, 102, 255)

				for iter_8_2, iter_8_3 in pairs(iter_8_1) do
					arg_8_0:_draw_blackboard_element(iter_8_2, iter_8_3)
				end
			else
				arg_8_0:_draw_blackboard_element(iter_8_0, iter_8_1)
			end
		end
	end
end

ImguiBehaviorTree._save_history = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0

	for iter_9_0, iter_9_1 in pairs(arg_9_1._blackboard.running_nodes) do
		if iter_9_1._identifier == arg_9_2 then
			var_9_0 = iter_9_1
		end
	end

	if var_9_0 == nil then
		return
	end

	arg_9_0._last_leaf_node_run = arg_9_2

	local var_9_1 = 1
	local var_9_2 = var_9_0
	local var_9_3 = {}

	if var_9_2 ~= nil then
		while var_9_2 do
			var_9_3[var_9_1] = var_9_2
			var_9_1 = var_9_1 + 1
			var_9_2 = var_9_2._parent
		end
	end

	local var_9_4 = {}

	for iter_9_2, iter_9_3 in pairs(arg_9_1._blackboard) do
		var_9_4[iter_9_2] = iter_9_3

		if type(iter_9_3) == "table" then
			for iter_9_4, iter_9_5 in pairs(iter_9_3) do
				if type(iter_9_5) ~= "table" then
					iter_9_3[iter_9_4] = iter_9_5
				end
			end
		end
	end

	var_9_4.running_nodes = var_9_3

	local var_9_5 = {
		blackboard = var_9_4
	}

	arg_9_0._history_stack[#arg_9_0._history_stack + 1] = var_9_5
end

ImguiBehaviorTree.update = function (arg_10_0)
	return
end

ImguiBehaviorTree.draw = function (arg_11_0)
	local var_11_0 = Imgui.begin_window("Behavior Tree")

	Imgui.set_window_size(arg_11_0._window_width, arg_11_0._window_height, "once")

	arg_11_0._show_considerations = Imgui.checkbox("Show considerations", arg_11_0._show_considerations)

	Imgui.same_line(10)

	arg_11_0._use_history_slider = Imgui.checkbox("Use History Slider", arg_11_0._use_history_slider)

	Imgui.same_line(10)

	arg_11_0._history_id = Imgui.slider_int("", arg_11_0._history_id, 1, table.size(arg_11_0._history_stack))

	Imgui.begin_child_window("Settings", arg_11_0._left_panel_width, 0, true)

	arg_11_0._show_graph_settings = Imgui.checkbox("Show Graph Settings", arg_11_0._show_graph_settings)

	if arg_11_0._show_graph_settings then
		Imgui.text_colored("Graph Settings:", 255, 51, 204, 255)

		arg_11_0._left_panel_width = Imgui.input_int("Panel width", arg_11_0._left_panel_width)
		arg_11_0._zoom = Imgui.input_float("Zoom", arg_11_0._zoom)
		arg_11_0._zoom_speed = Imgui.input_float("Zoom speed", arg_11_0._zoom_speed)
		arg_11_0._padding = Imgui.input_int("Node padding", arg_11_0._padding)
		arg_11_0._use_width_padding_zoom = Imgui.checkbox("Use width padding zoom", arg_11_0._use_width_padding_zoom)
		arg_11_0._use_height_padding_zoom = Imgui.checkbox("Use height padding zoom", arg_11_0._use_height_padding_zoom)
		arg_11_0._max_history_quantity = Imgui.input_int("#Max history", arg_11_0._max_history_quantity)
		arg_11_0._node_size.height = Imgui.input_int("Node Height", arg_11_0._node_size.height)
		arg_11_0._node_font_size = Imgui.input_int("Node font size", arg_11_0._node_font_size)
		arg_11_0._node_text_distance = Imgui.input_int("Node text distance", arg_11_0._node_text_distance)
		arg_11_0._node_inner_padding.x, arg_11_0._node_inner_padding.y = Imgui.input_int_2("Inner Padding", arg_11_0._node_inner_padding.x, arg_11_0._node_inner_padding.y)
	end

	Imgui.text_colored("---------------------------------------------------------------------------------------", 255, 51, 204, 255)
	Imgui.text_colored("History leaf nodes:", 255, 51, 204, 255)
	Imgui.indent(10)

	local var_11_1 = arg_11_0._running_leaf_history

	for iter_11_0 = 1, arg_11_0._max_history_quantity do
		local var_11_2 = var_11_1[iter_11_0]

		if var_11_2 == nil then
			var_11_2 = ""
		end

		Imgui.text_colored(var_11_2, 250, 250, 250, 250)
	end

	Imgui.unindent(10)
	Imgui.text_colored("---------------------------------------------------------------------------------------", 255, 51, 204, 255)
	Imgui.text_colored("Blackboard:", 255, 51, 204, 255)

	if #arg_11_0._history_stack > 0 then
		if not arg_11_0._use_history_slider then
			arg_11_0._history_id = #arg_11_0._history_stack
		end

		local var_11_3 = arg_11_0._history_stack[arg_11_0._history_id]

		if var_11_3 ~= nil then
			arg_11_0:_draw_blackboard_value(var_11_3.blackboard)
		end
	end

	Imgui.end_child_window()
	Imgui.same_line(10)
	Imgui.begin_child_window("Graph", 0, 0, true, "no_scroll_bar")
	Imgui.channel_split(2)

	local var_11_4, var_11_5 = Imgui.get_cursor_screen_pos()
	local var_11_6, var_11_7 = Imgui.get_window_size()

	arg_11_0._offset.x = var_11_4 + arg_11_0._scrolling.x
	arg_11_0._offset.y = var_11_5 + arg_11_0._scrolling.y

	local var_11_8 = math.fmod(arg_11_0._scrolling.x, arg_11_0._grid_size * arg_11_0._zoom)
	local var_11_9 = math.fmod(arg_11_0._scrolling.y, arg_11_0._grid_size * arg_11_0._zoom)
	local var_11_10 = Color(255, 100, 100, 100)

	while var_11_8 < var_11_6 do
		local var_11_11 = var_11_8 + var_11_4
		local var_11_12 = var_11_5
		local var_11_13 = var_11_8 + var_11_4
		local var_11_14 = var_11_7 + var_11_5

		Imgui.add_line(var_11_11, var_11_12, var_11_13, var_11_14, var_11_10, 1)

		var_11_8 = var_11_8 + arg_11_0._grid_size * arg_11_0._zoom
	end

	while var_11_9 < var_11_7 do
		local var_11_15 = var_11_4
		local var_11_16 = var_11_5 + var_11_9
		local var_11_17 = var_11_6 + var_11_4
		local var_11_18 = var_11_5 + var_11_9

		Imgui.add_line(var_11_15, var_11_16, var_11_17, var_11_18, var_11_10, 1)

		var_11_9 = var_11_9 + arg_11_0._grid_size * arg_11_0._zoom
	end

	local var_11_19 = ScriptUnit.has_extension(script_data.debug_unit, "ai_system")

	if var_11_19 then
		local var_11_20 = var_11_19:brain()
		local var_11_21 = var_11_20:bt():root()
		local var_11_22 = var_11_20._blackboard

		if arg_11_0._running_blackboard ~= var_11_22 then
			arg_11_0._running_blackboard = var_11_22

			table.clear(arg_11_0._running_leaf_history)
			table.clear(arg_11_0._history_stack)

			arg_11_0._last_leaf_node_run = nil
			arg_11_0._use_history_slider = false
		end

		local var_11_23 = var_11_20._leaf_node and var_11_20._leaf_node._identifier or var_11_22.btnode_name

		if var_11_23 ~= nil and var_11_23 ~= arg_11_0._last_leaf_node_run then
			arg_11_0:_save_history(var_11_20, var_11_23)
			arg_11_0:_update_leaf_history(var_11_23)
		end

		arg_11_0:_draw_nodes(var_11_21, 0, 0)
	end

	if Imgui.is_window_hovered() and Imgui.is_mouse_dragging(2, 0) then
		local var_11_24, var_11_25 = Imgui.get_mouse_delta()

		arg_11_0._scrolling.x = arg_11_0._scrolling.x + var_11_24
		arg_11_0._scrolling.y = arg_11_0._scrolling.y + var_11_25
	end

	local var_11_26 = Imgui.get_mouse_wheel_value()

	if Imgui.is_window_hovered() and var_11_26 ~= 0 then
		arg_11_0._zoom = arg_11_0._zoom * (1 + var_11_26 * arg_11_0._zoom_speed)
		arg_11_0._zoom = math.clamp(arg_11_0._zoom, 0.3, 10)
	end

	Imgui.channels_merge()
	Imgui.end_child_window()
	Imgui.same_line(10)
	Imgui.end_window()

	if arg_11_0._show_considerations then
		Imgui.begin_window("Considerations")

		if var_11_19 then
			local var_11_27 = var_11_19:brain()
			local var_11_28 = var_11_27:bt():action_data()
			local var_11_29 = var_11_27._blackboard

			arg_11_0:_draw_action_data(var_11_28, var_11_29)
		end

		Imgui.end_window()
	end

	return var_11_0
end

ImguiBehaviorTree._draw_graph = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = Color(180, 100, 100, 100)
	local var_12_1 = Color(255, 255, 255, 255)
	local var_12_2 = Color(255, 255, 255, 255)
	local var_12_3 = Color(255, 255, 255, 255)
	local var_12_4 = Color(255, 255, 0, 0)
	local var_12_5 = 10
	local var_12_6 = 10
	local var_12_7 = 300
	local var_12_8 = 150
	local var_12_9 = 50
	local var_12_10 = 20
	local var_12_11 = -20
	local var_12_12 = 0
	local var_12_13 = 1
	local var_12_14 = 2
	local var_12_15 = 10
	local var_12_16 = arg_12_2.spline
	local var_12_17 = arg_12_2.blackboard_input

	Imgui.text(var_12_17)
	Imgui.channel_split(2)
	Imgui.channel_set_current(0)

	local var_12_18, var_12_19 = Imgui.get_cursor_screen_pos()

	Imgui.add_rect_filled(var_12_18 + var_12_5, var_12_19 + var_12_6, var_12_18 + var_12_7 - var_12_5, var_12_19 + var_12_8 - var_12_6, var_12_0, 3)
	Imgui.add_rect(var_12_18 + var_12_5, var_12_19 + var_12_6, var_12_18 + var_12_7 - var_12_5, var_12_19 + var_12_8 - var_12_6, var_12_1, 3, 1)

	local var_12_20 = var_12_18 + var_12_5 + var_12_9 + var_12_11
	local var_12_21 = var_12_19 + var_12_6 + var_12_10 + var_12_12
	local var_12_22 = var_12_18 - var_12_5 - var_12_9 + var_12_7 + var_12_11
	local var_12_23 = var_12_19 - var_12_6 - var_12_10 + var_12_8 + var_12_12
	local var_12_24 = var_12_22 - var_12_20
	local var_12_25 = var_12_23 - var_12_21

	Imgui.add_line(var_12_20 - var_12_15, var_12_23, var_12_22 + var_12_15, var_12_23, var_12_2, var_12_14)
	Imgui.add_line(var_12_20, var_12_21 - var_12_15, var_12_20, var_12_23 + var_12_15, var_12_2, var_12_14)

	local var_12_26 = arg_12_2.max_value
	local var_12_27 = string.format("%.2f", var_12_26)
	local var_12_28, var_12_29 = Imgui.calculate_text_size(var_12_27)

	Imgui.add_text(var_12_27, var_12_22 + var_12_14, var_12_23 - var_12_29, var_12_2)
	Imgui.channel_set_current(1)

	local var_12_30 = arg_12_4[var_12_17] or arg_12_3[var_12_17] or 0
	local var_12_31 = math.clamp(var_12_30 / var_12_26, 0, 1)
	local var_12_32 = 0
	local var_12_33 = var_12_20 + var_12_16[1] * var_12_24
	local var_12_34 = var_12_21 + var_12_25 - var_12_16[2] * var_12_25

	for iter_12_0 = 3, #var_12_16, 2 do
		local var_12_35 = var_12_20 + var_12_16[iter_12_0] * var_12_24
		local var_12_36 = var_12_21 + var_12_25 - var_12_16[iter_12_0 + 1] * var_12_25

		Imgui.add_line(var_12_33, var_12_34, var_12_35, var_12_36, var_12_3, var_12_13)

		if var_12_31 >= var_12_16[iter_12_0 - 2] and var_12_31 <= var_12_16[iter_12_0] then
			local var_12_37 = (var_12_31 - var_12_16[iter_12_0 - 2]) / (var_12_16[iter_12_0] - var_12_16[iter_12_0 - 2])

			var_12_32 = var_12_16[iter_12_0 - 1] + (var_12_16[iter_12_0 + 1] - var_12_16[iter_12_0 - 1]) * var_12_37
		end

		var_12_33 = var_12_35
		var_12_34 = var_12_36
	end

	if var_12_30 then
		local var_12_38 = var_12_20 + var_12_31 * var_12_24

		Imgui.add_line(var_12_38, var_12_21, var_12_38, var_12_23 + var_12_15, var_12_4, var_12_14)

		local var_12_39 = string.format("%.2f", var_12_30)

		Imgui.add_text(var_12_39, var_12_38 + var_12_14, var_12_23, var_12_4)

		local var_12_40 = string.format("%.2f", var_12_32)

		Imgui.add_text(var_12_40, var_12_38 + var_12_14, var_12_21, var_12_4)
	end

	Imgui.channels_merge()
	Imgui.dummy(var_12_7, var_12_8)
end

ImguiBehaviorTree._draw_action_data = function (arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 then
		return
	end

	local var_13_0 = Color(255, 0, 255, 0)
	local var_13_1 = Color(255, 255, 0, 0)

	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		local var_13_2 = iter_13_1.considerations

		if var_13_2 and Imgui.tree_node(iter_13_0) then
			for iter_13_2, iter_13_3 in pairs(var_13_2) do
				if iter_13_3.spline then
					arg_13_0:_draw_graph(iter_13_2, iter_13_3, arg_13_2, arg_13_1)
				elseif iter_13_3.is_condition then
					local var_13_3 = iter_13_3.blackboard_input
					local var_13_4 = arg_13_1[var_13_3] or arg_13_2[var_13_3]

					if var_13_2.invert then
						var_13_4 = not var_13_4
					end

					local var_13_5

					var_13_5 = var_13_4 and "true" or "false"

					Imgui.text(iter_13_2)

					if iter_13_2 ~= var_13_3 then
						Imgui.same_line()
						Imgui.text("(")
						Imgui.text(var_13_3)
						Imgui.text(")")
					end

					Imgui.same_line()

					if var_13_4 then
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
	return true
end

return ImguiBehaviorTree
