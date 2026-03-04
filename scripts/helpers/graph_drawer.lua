-- chunkname: @scripts/helpers/graph_drawer.lua

local var_0_0 = require("foundation/scripts/util/array")

GraphDrawer = class(GraphDrawer)

GraphDrawer.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.world = arg_1_1
	arg_1_0.input_manager = arg_1_2
	arg_1_0.gui = World.create_screen_gui(arg_1_1, "material", "materials/fonts/gw_fonts", "material", "materials/menu/debug_screen", "immediate")
	arg_1_0.graphs = {}
	arg_1_0.unblocked_services = {}
	arg_1_0.unblocked_services_n = 0
	arg_1_0.active = false
end

GraphDrawer.create_graph = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Graph:new(arg_2_1, arg_2_2)

	arg_2_0.graphs[arg_2_1] = var_2_0

	return var_2_0
end

GraphDrawer.destroy_graph = function (arg_3_0, arg_3_1)
	arg_3_0.graphs[arg_3_1.name] = nil
end

GraphDrawer.graph = function (arg_4_0, arg_4_1)
	return arg_4_0.graphs[arg_4_1]
end

GraphDrawer.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1:get("f11")

	if arg_5_0.active then
		Debug.text("GraphDrawer active, other mouse input disabled")

		local var_5_1 = arg_5_0.input_manager:get_input_service("Debug")

		if not var_5_1 or var_5_1:is_blocked() then
			var_5_0 = true
		end
	end

	if var_5_0 then
		if not arg_5_0.active then
			arg_5_0.input_manager:capture_input({
				"mouse"
			}, 1, "Debug", "GraphDrawer")
			Window.set_show_cursor(true)
		else
			arg_5_0.input_manager:release_input({
				"mouse"
			}, 1, "Debug", "GraphDrawer")
			Window.set_show_cursor(false)
		end

		arg_5_0.active = not arg_5_0.active
	end

	local var_5_2 = RESOLUTION_LOOKUP.res_w
	local var_5_3 = RESOLUTION_LOOKUP.res_h
	local var_5_4 = arg_5_0.gui

	for iter_5_0, iter_5_1 in pairs(arg_5_0.graphs) do
		if iter_5_1.active then
			if arg_5_0.active then
				iter_5_1:update(arg_5_1, arg_5_2)
			end

			iter_5_1:draw(var_5_4, arg_5_1, arg_5_2)
		end
	end
end

Graph = class(Graph)

Graph.init = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.name = arg_6_1
	arg_6_0.axis_names = arg_6_2
	arg_6_0.circle_index = 0
	arg_6_0.active = true
	arg_6_0.range_x = {
		math.huge,
		-math.huge
	}
	arg_6_0.range_y = {
		math.huge,
		-math.huge
	}
	arg_6_0.visual_frame = {
		x_min = 0,
		x_max = 0,
		y_min = 0,
		y_max = 0
	}
	arg_6_0.plots = {}
	arg_6_0.annotations_x = var_0_0.new()
	arg_6_0.annotations_data = var_0_0.new()
	arg_6_0.scroll_lock = {
		vertical = true,
		left = true,
		right = true
	}
	arg_6_0.valid = false
	arg_6_0.zoom_window = nil
end

Graph.reset = function (arg_7_0)
	arg_7_0.plots = {}

	var_0_0.set_empty(arg_7_0.annotations_x)
	var_0_0.set_empty(arg_7_0.annotations_data)

	arg_7_0.range_x = {
		math.huge,
		-math.huge
	}
	arg_7_0.range_y = {
		math.huge,
		-math.huge
	}
	arg_7_0.visual_frame = {
		x_min = 0,
		x_max = 0,
		y_min = 0,
		y_max = 0
	}
	arg_7_0.valid = false
	arg_7_0.scroll_lock = {
		vertical = true,
		left = true,
		right = true
	}
	arg_7_0.zoom_window = nil
	arg_7_0.state = nil
end

Graph.set_active = function (arg_8_0, arg_8_1)
	arg_8_0.active = arg_8_1
end

Graph.set_plot_color = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.plots[arg_9_1]

	if var_9_0 == nil then
		var_9_0 = {
			points_x = var_0_0.new(),
			points_y = var_0_0.new()
		}
		arg_9_0.plots[arg_9_1] = var_9_0
	end

	var_9_0.point_color = arg_9_2
	var_9_0.line_color = arg_9_3
end

Graph.add_point = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_3 = arg_10_3 or "default"

	local var_10_0 = arg_10_0.plots[arg_10_3]

	if var_10_0 == nil then
		var_10_0 = {
			points_x = var_0_0.new(),
			points_y = var_0_0.new()
		}
		arg_10_0.plots[arg_10_3] = var_10_0
	end

	arg_10_0.range_x[1] = math.min(arg_10_1, arg_10_0.range_x[1])
	arg_10_0.range_x[2] = math.max(arg_10_1, arg_10_0.range_x[2])
	arg_10_0.range_y[1] = math.min(arg_10_2, arg_10_0.range_y[1])
	arg_10_0.range_y[2] = math.max(arg_10_2, arg_10_0.range_y[2])

	local var_10_1 = var_0_0.binary_insert(var_10_0.points_x, arg_10_1)

	var_0_0.insert_at(var_10_0.points_y, arg_10_2, var_10_1)

	local var_10_2 = var_0_0.num_items(var_10_0.points_x)

	if arg_10_0.scroll_lock.left then
		arg_10_0.visual_frame.x_min = arg_10_0.range_x[1]
	end

	if arg_10_0.scroll_lock.right then
		arg_10_0.visual_frame.x_max = arg_10_0.range_x[2]
	end

	if arg_10_0.scroll_lock.vertical then
		arg_10_0.visual_frame.y_min = arg_10_0.range_y[1]
		arg_10_0.visual_frame.y_max = arg_10_0.range_y[2]
	end

	arg_10_0.valid = arg_10_0.valid or var_10_2 > 1 and math.abs(arg_10_0.range_x[2] - arg_10_0.range_x[1]) > 1e-05 and math.abs(arg_10_0.range_y[2] - arg_10_0.range_y[1]) > 1e-05
end

Graph.add_annotation = function (arg_11_0, arg_11_1)
	local var_11_0 = var_0_0.binary_insert(arg_11_0.annotations_x, arg_11_1.x)

	var_0_0.insert_at(arg_11_0.annotations_data, arg_11_1, var_11_0)
end

Graph.move_annotation = function (arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2 == arg_12_1.x then
		return
	end

	local var_12_0, var_12_1 = var_0_0.pop_item_ordered(arg_12_0.annotations_data, arg_12_1)

	if var_12_0 then
		var_0_0.pop_item_ordered(arg_12_0.annotations_x, arg_12_1.x)

		arg_12_1.x = arg_12_2

		local var_12_2 = var_0_0.binary_insert(arg_12_0.annotations_x, arg_12_2)

		var_0_0.insert_at(arg_12_0.annotations_data, arg_12_1, var_12_2)
	end
end

Graph.set_visual_range = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0.visual_frame = {
		x_min = arg_13_1,
		x_max = arg_13_2,
		y_min = arg_13_3,
		y_max = arg_13_4
	}
end

Graph.update = function (arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0.valid then
		return
	end

	local var_14_0 = arg_14_1:get("cursor")
	local var_14_1 = Vector3(100, 100, 0)
	local var_14_2 = 800
	local var_14_3 = 400

	arg_14_0.state = arg_14_0.state or "waiting_for_zoom_window"

	if arg_14_0.state == "waiting_for_zoom_window" then
		if arg_14_1:get("mouse_left_held") then
			arg_14_0.state = "drawing_zoom_window"
		end

		if arg_14_1:get("mouse_middle_held") then
			arg_14_0.state = "panning"
		end

		if arg_14_1:get("mouse_right_held") then
			arg_14_0.zoom_window = {}

			local var_14_4 = (arg_14_0.visual_frame.x_max - arg_14_0.range_x[1]) / (arg_14_0.visual_frame.x_max - arg_14_0.visual_frame.x_min)
			local var_14_5 = (arg_14_0.range_x[2] - arg_14_0.visual_frame.x_min) / (arg_14_0.visual_frame.x_max - arg_14_0.visual_frame.x_min)
			local var_14_6 = (arg_14_0.visual_frame.y_max - arg_14_0.range_y[1]) / (arg_14_0.visual_frame.y_max - arg_14_0.visual_frame.y_min)
			local var_14_7 = (arg_14_0.range_y[2] - arg_14_0.visual_frame.y_min) / (arg_14_0.visual_frame.y_max - arg_14_0.visual_frame.y_min)

			arg_14_0.zoom_window.x_min = var_14_1.x + var_14_2 - var_14_2 * var_14_4
			arg_14_0.zoom_window.x_max = var_14_1.x + var_14_2 * var_14_5
			arg_14_0.zoom_window.y_min = var_14_1.y + var_14_3 - var_14_3 * var_14_6
			arg_14_0.zoom_window.y_max = var_14_1.y + var_14_3 * var_14_7
			arg_14_0.zoom_window.min_size = 100
			arg_14_0.scroll_lock.right = true
			arg_14_0.scroll_lock.left = true
			arg_14_0.scroll_lock.vertical = true
			arg_14_0.state = "zoom_prepare"
		end
	end

	if arg_14_0.state == "drawing_zoom_window" then
		if arg_14_1:get("mouse_left_held") then
			if arg_14_0.zoom_window == nil then
				local var_14_8 = true
				local var_14_9 = true

				if var_14_0.x > var_14_1.x + var_14_2 then
					local var_14_10 = (arg_14_0.range_x[2] - arg_14_0.visual_frame.x_min) / (arg_14_0.visual_frame.x_max - arg_14_0.visual_frame.x_min)

					arg_14_0.zoom_window = {}
					arg_14_0.zoom_window.x_min = var_14_1.x
					arg_14_0.zoom_window.x_max = var_14_1.x + var_14_2 * var_14_10
					arg_14_0.zoom_window.y_min = var_14_1.y
					arg_14_0.zoom_window.y_max = var_14_1.y + var_14_3
					arg_14_0.zoom_window.min_size = 100
					arg_14_0.scroll_lock.right = true
					arg_14_0.state = "zoom_prepare"

					return
				elseif var_14_0.x < var_14_1.x then
					local var_14_11 = (arg_14_0.visual_frame.x_max - arg_14_0.range_x[1]) / (arg_14_0.visual_frame.x_max - arg_14_0.visual_frame.x_min)

					arg_14_0.zoom_window = {}
					arg_14_0.zoom_window.x_min = var_14_1.x + var_14_2 - var_14_2 * var_14_11
					arg_14_0.zoom_window.x_max = var_14_1.x + var_14_2
					arg_14_0.zoom_window.y_min = var_14_1.y
					arg_14_0.zoom_window.y_max = var_14_1.y + var_14_3
					arg_14_0.zoom_window.min_size = 100
					arg_14_0.scroll_lock.left = true
					arg_14_0.state = "zoom_prepare"

					return
				end

				if var_14_0.y > var_14_1.y + var_14_3 then
					local var_14_12 = (arg_14_0.visual_frame.y_max - arg_14_0.range_y[1]) / (arg_14_0.visual_frame.y_max - arg_14_0.visual_frame.y_min)
					local var_14_13 = (arg_14_0.range_y[2] - arg_14_0.visual_frame.y_min) / (arg_14_0.visual_frame.y_max - arg_14_0.visual_frame.y_min)

					arg_14_0.zoom_window = {}
					arg_14_0.zoom_window.x_min = var_14_1.x + var_14_2 - var_14_2
					arg_14_0.zoom_window.x_max = var_14_1.x + var_14_2
					arg_14_0.zoom_window.y_min = var_14_1.y + var_14_3 - var_14_3 * var_14_12
					arg_14_0.zoom_window.y_max = var_14_1.y + var_14_3 * var_14_13
					arg_14_0.zoom_window.min_size = 100
					arg_14_0.scroll_lock.vertical = true
					arg_14_0.state = "zoom_prepare"

					return
				end

				arg_14_0.zoom_window = {
					x_start = var_14_0.x,
					y_start = var_14_0.y
				}
			end

			arg_14_0.zoom_window.x_end = var_14_0.x
			arg_14_0.zoom_window.y_end = var_14_0.y
			arg_14_0.zoom_window.x_min = math.min(arg_14_0.zoom_window.x_end, arg_14_0.zoom_window.x_start)
			arg_14_0.zoom_window.x_max = math.max(arg_14_0.zoom_window.x_end, arg_14_0.zoom_window.x_start)
			arg_14_0.zoom_window.y_min = math.min(arg_14_0.zoom_window.y_end, arg_14_0.zoom_window.y_start)
			arg_14_0.zoom_window.y_max = math.max(arg_14_0.zoom_window.y_end, arg_14_0.zoom_window.y_start)
			arg_14_0.zoom_window.min_size = math.min(arg_14_0.zoom_window.x_max - arg_14_0.zoom_window.x_min, arg_14_0.zoom_window.y_max - arg_14_0.zoom_window.y_min)
		elseif arg_14_0.zoom_window ~= nil and arg_14_0.zoom_window.min_size < 20 then
			arg_14_0.zoom_window = nil
			arg_14_0.state = "waiting_for_zoom_window"
		elseif arg_14_0.zoom_window then
			arg_14_0.state = "zoom_prepare"
			arg_14_0.scroll_lock.left = false
			arg_14_0.scroll_lock.right = false
			arg_14_0.scroll_lock.vertical = false
		end
	end

	if arg_14_0.state == "panning" then
		if not arg_14_1:get("mouse_middle_held") then
			arg_14_0.state = "waiting_for_zoom_window"
			arg_14_0.pan_previous = nil

			return
		end

		if arg_14_0.pan_previous == nil then
			arg_14_0.pan_previous = {
				x = var_14_0.x,
				y = var_14_0.y
			}
		end

		local var_14_14 = Vector2(arg_14_0.pan_previous.x - var_14_0.x, arg_14_0.pan_previous.y - var_14_0.y)
		local var_14_15 = (arg_14_0.visual_frame.x_max - arg_14_0.visual_frame.x_min) / var_14_2
		local var_14_16 = (arg_14_0.visual_frame.y_max - arg_14_0.visual_frame.y_min) / var_14_3

		if not arg_14_0.scroll_lock.left then
			arg_14_0.visual_frame.x_min = arg_14_0.visual_frame.x_min + var_14_14.x * var_14_15
		end

		if not arg_14_0.scroll_lock.right then
			arg_14_0.visual_frame.x_max = arg_14_0.visual_frame.x_max + var_14_14.x * var_14_15
		end

		if not arg_14_0.scroll_lock.vertical then
			arg_14_0.visual_frame.y_min = arg_14_0.visual_frame.y_min + var_14_14.y * var_14_16
			arg_14_0.visual_frame.y_max = arg_14_0.visual_frame.y_max + var_14_14.y * var_14_16
		end

		arg_14_0.pan_previous = {
			x = var_14_0.x,
			y = var_14_0.y
		}
	end

	if arg_14_0.state == "zoom_prepare" then
		local var_14_17 = (arg_14_0.zoom_window.x_min - var_14_1.x) / var_14_2
		local var_14_18 = (arg_14_0.zoom_window.x_max - var_14_1.x) / var_14_2
		local var_14_19 = (arg_14_0.zoom_window.y_min - var_14_1.x) / var_14_3
		local var_14_20 = (arg_14_0.zoom_window.y_max - var_14_1.x) / var_14_3

		arg_14_0.visual_frame.x_min = math.max(arg_14_0.range_x[1], arg_14_0.visual_frame.x_min)
		arg_14_0.visual_frame.x_max = math.min(arg_14_0.range_x[2], arg_14_0.visual_frame.x_max)
		arg_14_0.visual_frame.y_min = math.max(arg_14_0.range_y[1], arg_14_0.visual_frame.y_min)
		arg_14_0.visual_frame.y_max = math.min(arg_14_0.range_y[2], arg_14_0.visual_frame.y_max)

		local var_14_21 = arg_14_0.visual_frame.x_min
		local var_14_22 = arg_14_0.visual_frame.x_max
		local var_14_23 = arg_14_0.visual_frame.y_min
		local var_14_24 = arg_14_0.visual_frame.y_max
		local var_14_25 = math.lerp(var_14_21, var_14_22, var_14_17)
		local var_14_26 = math.lerp(var_14_21, var_14_22, var_14_18)
		local var_14_27 = math.lerp(var_14_23, var_14_24, var_14_19)
		local var_14_28 = math.lerp(var_14_23, var_14_24, var_14_20)

		arg_14_0.zoom_window.target_x_min = var_14_25
		arg_14_0.zoom_window.target_x_max = var_14_26
		arg_14_0.zoom_window.target_y_min = var_14_27
		arg_14_0.zoom_window.target_y_max = var_14_28
		arg_14_0.anim_done_t = arg_14_2 + 1
		arg_14_0.state = "zooming"
	end

	if arg_14_0.state == "zooming" then
		Debug.text("zooming")

		arg_14_0.zoom_window.x_min = math.lerp(arg_14_0.zoom_window.x_min, var_14_1.x, 0.2)
		arg_14_0.zoom_window.x_max = math.lerp(arg_14_0.zoom_window.x_max, var_14_1.x + var_14_2, 0.2)
		arg_14_0.zoom_window.y_min = math.lerp(arg_14_0.zoom_window.y_min, var_14_1.y, 0.2)
		arg_14_0.zoom_window.y_max = math.lerp(arg_14_0.zoom_window.y_max, var_14_1.y + var_14_3, 0.2)

		local var_14_29 = arg_14_0.zoom_window.target_x_min
		local var_14_30 = arg_14_0.zoom_window.target_x_max
		local var_14_31 = arg_14_0.zoom_window.target_y_min
		local var_14_32 = arg_14_0.zoom_window.target_y_max

		arg_14_0.visual_frame.x_min = math.lerp(arg_14_0.visual_frame.x_min, var_14_29, 0.2)
		arg_14_0.visual_frame.x_max = math.lerp(arg_14_0.visual_frame.x_max, var_14_30, 0.2)
		arg_14_0.visual_frame.y_min = math.lerp(arg_14_0.visual_frame.y_min, var_14_31, 0.2)
		arg_14_0.visual_frame.y_max = math.lerp(arg_14_0.visual_frame.y_max, var_14_32, 0.2)

		Debug.text(arg_14_0.visual_frame.x_min)

		if arg_14_2 > arg_14_0.anim_done_t then
			arg_14_0.visual_frame.x_min = var_14_29
			arg_14_0.visual_frame.x_max = var_14_30
			arg_14_0.visual_frame.y_min = var_14_31
			arg_14_0.visual_frame.y_max = var_14_32
			arg_14_0.anim_done_t = nil
			arg_14_0.zoom_window = nil
			arg_14_0.state = "waiting_for_zoom_window"
		end
	end
end

Graph.draw = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_2:get("cursor")
	local var_15_1 = 1
	local var_15_2 = 2
	local var_15_3 = 26
	local var_15_4 = "arial"
	local var_15_5 = "materials/fonts/" .. var_15_4
	local var_15_6 = Colors.get_color_with_alpha("navy", Window.show_cursor() and 100 or 50)
	local var_15_7 = Colors.get("aqua_marine")
	local var_15_8 = Colors.get("white")
	local var_15_9 = Colors.get("black")
	local var_15_10 = Colors.get("white")
	local var_15_11 = Colors.get_color_with_alpha("yellow", 100)
	local var_15_12 = Colors.get("yellow")
	local var_15_13 = Colors.get_color_with_alpha("black", 100)
	local var_15_14 = Colors.get_color_with_alpha("black", 150)
	local var_15_15 = Colors.get("white")
	local var_15_16 = Colors.get_color_with_alpha("white", arg_15_0.anim_done_t == nil and 100 or math.lerp(100, 0, 1 - (arg_15_0.anim_done_t - arg_15_3)))
	local var_15_17 = Colors.get_color_with_alpha("red", 100)
	local var_15_18 = Vector3(100, 100, 0)
	local var_15_19 = 800
	local var_15_20 = 400

	Gui.rect(arg_15_1, var_15_18, Vector2(var_15_19, var_15_20), var_15_6)

	local var_15_21 = Vector3(var_15_18.x + var_15_19 + 5, 0, var_15_18.y + 5)
	local var_15_22 = Vector3(var_15_18.x + var_15_19 + 5, 0, var_15_18.y - 5)
	local var_15_23 = Vector3(var_15_18.x + var_15_19 + 15, 0, var_15_18.y)

	Gui.triangle(arg_15_1, var_15_21, var_15_22, var_15_23, var_15_1, var_15_15)

	local var_15_24 = Vector3(var_15_18.x + 5, 0, var_15_18.y + var_15_20 + 5)
	local var_15_25 = Vector3(var_15_18.x - 5, 0, var_15_18.y + var_15_20 + 5)
	local var_15_26 = Vector3(var_15_18.x, 0, var_15_18.y + var_15_20 + 15)

	Gui.triangle(arg_15_1, var_15_24, var_15_25, var_15_26, var_15_1, var_15_15)
	ScriptGUI.hud_line(arg_15_1, var_15_18, var_15_18 + Vector3(var_15_19 + 10, 0, 0), var_15_1, 1, var_15_15)
	ScriptGUI.hud_line(arg_15_1, var_15_18, var_15_18 + Vector3(0, var_15_20 + 10, 0), var_15_1, 1, var_15_15)
	Gui.text(arg_15_1, arg_15_0.axis_names[1], var_15_5, var_15_3, var_15_4, var_15_18 + Vector3(-50 + var_15_19, -20, 0), var_15_15)
	Gui.text(arg_15_1, arg_15_0.axis_names[2], var_15_5, var_15_3, var_15_4, var_15_18 + Vector3(-50, var_15_20 + 20, 0), var_15_15)

	local var_15_27 = arg_15_0.visual_frame.x_min
	local var_15_28 = arg_15_0.visual_frame.x_max
	local var_15_29 = arg_15_0.visual_frame.y_min
	local var_15_30 = arg_15_0.visual_frame.y_max

	if var_15_28 == var_15_27 or var_15_30 == var_15_29 then
		return
	end

	Gui.text(arg_15_1, string.format("(%.2f, %.2f)", var_15_27, var_15_29), var_15_5, var_15_3, var_15_4, var_15_18 + Vector3(-50, -20, 0), var_15_15)
	Gui.text(arg_15_1, string.format("(%.2f, %.2f)", var_15_28, var_15_30), var_15_5, var_15_3, var_15_4, var_15_18 + Vector3(-50 + var_15_19, 10 + var_15_20, 0), var_15_15)

	if not arg_15_0.valid then
		return
	end

	local var_15_31 = var_15_19 / (var_15_28 - var_15_27)
	local var_15_32 = var_15_20 / (var_15_30 - var_15_29)

	for iter_15_0, iter_15_1 in pairs(arg_15_0.plots) do
		local var_15_33 = iter_15_1.line_color and Colors.get(iter_15_1.line_color) or var_15_7
		local var_15_34 = iter_15_1.line_color and Colors.get(iter_15_1.line_color) or var_15_8
		local var_15_35 = var_0_0.items(iter_15_1.points_x)
		local var_15_36 = var_0_0.items(iter_15_1.points_y)
		local var_15_37 = Vector3((var_15_35[1] - var_15_27) * var_15_31, (var_15_36[1] - var_15_29) * var_15_32, 0)
		local var_15_38 = var_0_0.num_items(iter_15_1.points_x)

		for iter_15_2 = 2, var_15_38 do
			local var_15_39 = Vector3((var_15_35[iter_15_2] - var_15_27) * var_15_31, (var_15_36[iter_15_2] - var_15_29) * var_15_32, 0)
			local var_15_40 = var_15_37.x >= 0 and var_15_19 >= var_15_37.x
			local var_15_41 = var_15_37.y >= 0 and var_15_20 >= var_15_37.y
			local var_15_42 = var_15_39.x >= 0 and var_15_19 >= var_15_39.x
			local var_15_43 = var_15_39.y >= 0 and var_15_20 >= var_15_39.y

			if var_15_40 and var_15_41 or var_15_42 and var_15_43 then
				ScriptGUI.hud_line(arg_15_1, var_15_37 + var_15_18, var_15_39 + var_15_18, var_15_1, var_15_2, var_15_33)
				Gui.rect(arg_15_1, var_15_39 + var_15_18 + Vector3(-3, -3, 100), Vector3(6, 6, 0), var_15_34)
			end

			var_15_37 = var_15_39
		end
	end

	local var_15_44 = var_0_0.items(arg_15_0.annotations_data)
	local var_15_45 = var_0_0.num_items(arg_15_0.annotations_data)
	local var_15_46 = -10
	local var_15_47 = -10
	local var_15_48 = 0

	for iter_15_3 = 1, var_15_45 do
		local var_15_49 = var_15_44[iter_15_3]
		local var_15_50 = Vector3((var_15_49.x - var_15_27) * var_15_31, 0, 0)

		if var_15_50.x >= 0 and var_15_19 >= var_15_50.x then
			if var_15_50.x < var_15_46 + 8 then
				var_15_47 = var_15_47 - 10
			else
				var_15_47 = -10
			end

			var_15_46 = var_15_50.x
			var_15_50.y = var_15_50.y + var_15_47

			if Vector3.distance_squared(var_15_50 + var_15_18, var_15_0) < 64 then
				Gui.rect(arg_15_1, var_15_50 + var_15_18 + Vector3(-5, -5, 10), Vector3(10, 10, 0), var_15_10)

				local var_15_51 = Colors.get(var_15_49.color)

				ScriptGUI.hud_line(arg_15_1, var_15_50 + var_15_18 + Vector3(0, -var_15_48, 0), var_15_50 + var_15_18 + Vector3(0, var_15_20, 0), var_15_1, 2, var_15_51)

				local var_15_52, var_15_53, var_15_54 = Gui.text_extents(arg_15_1, var_15_49.text, var_15_5, var_15_3)
				local var_15_55 = var_15_53.x - var_15_52.x + 10
				local var_15_56 = Colors.get(var_15_49.color)

				Gui.rect(arg_15_1, var_15_18 + Vector3(0, -70 - var_15_48, 0), Vector3(var_15_55, 30, 0), var_15_13)
				Gui.rect(arg_15_1, var_15_18 + Vector3(0, -70 - var_15_48, 0), Vector3(var_15_55, 5, 0), var_15_56)
				Gui.text(arg_15_1, var_15_49.text, var_15_5, var_15_3, var_15_4, var_15_18 + Vector3(5, -60 - var_15_48, 0), var_15_8)

				local var_15_57 = Vector3(var_15_50.x, (var_15_49.y - var_15_29) * var_15_32, 0)

				Gui.rect(arg_15_1, var_15_57 + var_15_18 + Vector3(-5, -5, 101), Vector3(10, 10, 0), var_15_56)
				Gui.rect(arg_15_1, var_15_57 + var_15_18 + Vector3(-6, -6, 100), Vector3(12, 12, 0), var_15_8)

				var_15_48 = var_15_48 + 30
			else
				local var_15_58 = Colors.get_color_with_alpha(var_15_49.color, 50)

				ScriptGUI.hud_line(arg_15_1, var_15_50 + var_15_18, var_15_50 + var_15_18 + Vector3(0, var_15_20, 0), var_15_1, 1, var_15_58)

				local var_15_59 = Colors.get_color_with_alpha(var_15_49.color, 150)
				local var_15_60 = Vector3(var_15_50.x, (var_15_49.y - var_15_29) * var_15_32, 0)

				Gui.rect(arg_15_1, var_15_60 + var_15_18 + Vector3(-3, -3, 100), Vector3(6, 6, 0), var_15_59)
			end

			local var_15_61 = Colors.get(var_15_49.color)

			Gui.rect(arg_15_1, var_15_50 + var_15_18 + Vector3(-4, -4, 100), Vector3(8, 8, 0), var_15_61)
			ScriptGUI.hud_line(arg_15_1, var_15_50 + var_15_18, var_15_50 + var_15_18 + Vector3(0, var_15_20, 0), var_15_1, 1, var_15_11)

			if var_15_49.live then
				local var_15_62 = Vector3(var_15_50.x, (var_15_49.y - var_15_29) * var_15_32, 0) + var_15_18 + Vector3(-3, -3, 100)

				Gui.text(arg_15_1, var_15_49.text, var_15_5, var_15_3, var_15_4, var_15_62, var_15_61)
			end
		end
	end

	Gui.rect(arg_15_1, var_15_18 + Vector3(0, -40, 0), Vector3(var_15_19, 40, 0), var_15_14)

	if arg_15_0.zoom_window then
		local var_15_63 = Vector3(arg_15_0.zoom_window.x_min, arg_15_0.zoom_window.y_min, 0)
		local var_15_64 = Vector3(arg_15_0.zoom_window.x_max - arg_15_0.zoom_window.x_min, arg_15_0.zoom_window.y_max - arg_15_0.zoom_window.y_min, 0)

		if arg_15_0.zoom_window.min_size < 20 then
			Gui.rect(arg_15_1, var_15_63, var_15_64, var_15_17)
		else
			Gui.rect(arg_15_1, var_15_63, var_15_64, var_15_16)
		end
	else
		if var_15_0.x > var_15_18.x + var_15_19 then
			Gui.rect(arg_15_1, var_15_18 + Vector3(var_15_19, 0, 0), Vector2(50, var_15_20), var_15_16)
		elseif var_15_0.x < var_15_18.x then
			Gui.rect(arg_15_1, var_15_18 + Vector3(-50, 0, 0), Vector2(50, var_15_20), var_15_16)
		end

		if var_15_0.y > var_15_18.y + var_15_20 then
			Gui.rect(arg_15_1, var_15_18 + Vector3(0, -50, 0), Vector2(var_15_19, 50), var_15_16)
			Gui.rect(arg_15_1, var_15_18 + Vector3(0, var_15_20, 0), Vector2(var_15_19, 50), var_15_16)
		end
	end
end
