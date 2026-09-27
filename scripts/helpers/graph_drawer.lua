-- chunkname: @scripts/helpers/graph_drawer.lua

local foundation_scripts_util_array = require("foundation/scripts/util/array")

GraphDrawer = class(GraphDrawer)

GraphDrawer.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.world = arg_1_1
	self.input_manager = arg_1_2
	self.gui = World.create_screen_gui(arg_1_1, "material", "materials/fonts/gw_fonts", "material", "materials/menu/debug_screen", "immediate")
	self.graphs = {}
	self.unblocked_services = {}
	self.unblocked_services_n = 0
	self.active = false
end

GraphDrawer.create_graph = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = Graph:new(arg_2_1, arg_2_2)

	arg_2_0.graphs[arg_2_1] = var_2_0

	return var_2_0
end

GraphDrawer.destroy_graph = function (arg_3_0, arg_3_1)
	-- function 3
	arg_3_0.graphs[arg_3_1.name] = nil
end

GraphDrawer.graph = function (self, arg_4_1)
	-- function 4
	return self.graphs[arg_4_1]
end

GraphDrawer.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get = arg_5_1:get("f11")

	if not self.active then
		Debug.text("GraphDrawer active, other mouse input disabled")

		local get_input_service = self.input_manager:get_input_service("Debug")

		if not get_input_service and not get_input_service:is_blocked() then
			get = true
		end
	end

	if not get then
		if not self.active then
			self.input_manager:capture_input({
				"mouse"
			}, 1, "Debug", "GraphDrawer")
			Window.set_show_cursor(true)
		else
			self.input_manager:release_input({
				"mouse"
			}, 1, "Debug", "GraphDrawer")
			Window.set_show_cursor(false)
		end

		self.active = not self.active
	end

	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local gui = self.gui

	for k, v in pairs(self.graphs) do
		if not v.active then
			if not self.active then
				v:update(arg_5_1, arg_5_2)
			end

			v:draw(gui, arg_5_1, arg_5_2)
		end
	end
end

Graph = class(Graph)

Graph.init = function (self, arg_6_1, arg_6_2)
	-- function 6
	self.name = arg_6_1
	self.axis_names = arg_6_2
	self.circle_index = 0
	self.active = true
	self.range_x = {
		math.huge,
		-math.huge
	}
	self.range_y = {
		math.huge,
		-math.huge
	}
	self.visual_frame = {
		x_min = 0,
		x_max = 0,
		y_min = 0,
		y_max = 0
	}
	self.plots = {}
	self.annotations_x = foundation_scripts_util_array.new()
	self.annotations_data = foundation_scripts_util_array.new()
	self.scroll_lock = {
		vertical = true,
		left = true,
		right = true
	}
	self.valid = false
	self.zoom_window = nil
end

Graph.reset = function (self)
	-- function 7
	self.plots = {}

	foundation_scripts_util_array.set_empty(self.annotations_x)
	foundation_scripts_util_array.set_empty(self.annotations_data)

	self.range_x = {
		math.huge,
		-math.huge
	}
	self.range_y = {
		math.huge,
		-math.huge
	}
	self.visual_frame = {
		x_min = 0,
		x_max = 0,
		y_min = 0,
		y_max = 0
	}
	self.valid = false
	self.scroll_lock = {
		vertical = true,
		left = true,
		right = true
	}
	self.zoom_window = nil
	self.state = nil
end

Graph.set_active = function (self, arg_8_1)
	-- function 8
	self.active = arg_8_1
end

Graph.set_plot_color = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0 = self.plots[arg_9_1]

	if var_9_0 == nil then
		var_9_0 = {
			points_x = foundation_scripts_util_array.new(),
			points_y = foundation_scripts_util_array.new()
		}
		self.plots[arg_9_1] = var_9_0
	end

	var_9_0.point_color = arg_9_2
	var_9_0.line_color = arg_9_3
end

Graph.add_point = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	arg_10_3 = arg_10_3 or "default"

	local var_10_0 = self.plots[arg_10_3]

	if var_10_0 == nil then
		var_10_0 = {
			points_x = foundation_scripts_util_array.new(),
			points_y = foundation_scripts_util_array.new()
		}
		self.plots[arg_10_3] = var_10_0
	end

	self.range_x[1] = math.min(arg_10_1, self.range_x[1])
	self.range_x[2] = math.max(arg_10_1, self.range_x[2])
	self.range_y[1] = math.min(arg_10_2, self.range_y[1])
	self.range_y[2] = math.max(arg_10_2, self.range_y[2])

	local binary_insert = foundation_scripts_util_array.binary_insert(var_10_0.points_x, arg_10_1)

	foundation_scripts_util_array.insert_at(var_10_0.points_y, arg_10_2, binary_insert)

	local num_items = foundation_scripts_util_array.num_items(var_10_0.points_x)

	if not self.scroll_lock.left then
		self.visual_frame.x_min = self.range_x[1]
	end

	if not self.scroll_lock.right then
		self.visual_frame.x_max = self.range_x[2]
	end

	if not self.scroll_lock.vertical then
		self.visual_frame.y_min = self.range_y[1]
		self.visual_frame.y_max = self.range_y[2]
	end

	local valid = self.valid

	valid = valid or not (num_items > 1) or not (math.abs(self.range_x[2] - self.range_x[1]) > 1e-05) or math.abs(self.range_y[2] - self.range_y[1]) > 1e-05
	self.valid = valid
end

Graph.add_annotation = function (self, arg_11_1)
	-- function 11
	local binary_insert = foundation_scripts_util_array.binary_insert(self.annotations_x, arg_11_1.x)

	foundation_scripts_util_array.insert_at(self.annotations_data, arg_11_1, binary_insert)
end

Graph.move_annotation = function (self, arg_12_1, arg_12_2)
	-- function 12
	if arg_12_2 == arg_12_1.x then
		return
	end

	local pop_item_ordered, var_12_1 = foundation_scripts_util_array.pop_item_ordered(self.annotations_data, arg_12_1)

	if not pop_item_ordered then
		foundation_scripts_util_array.pop_item_ordered(self.annotations_x, arg_12_1.x)

		arg_12_1.x = arg_12_2

		local binary_insert = foundation_scripts_util_array.binary_insert(self.annotations_x, arg_12_2)

		foundation_scripts_util_array.insert_at(self.annotations_data, arg_12_1, binary_insert)
	end
end

Graph.set_visual_range = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	self.visual_frame = {
		x_min = arg_13_1,
		x_max = arg_13_2,
		y_min = arg_13_3,
		y_max = arg_13_4
	}
end

Graph.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not self.valid then
		return
	end

	local get = arg_14_1:get("cursor")
	local var_14_1 = Vector3(100, 100, 0)
	local num = 800
	local num_2 = 400
	local state = self.state

	state = state or "waiting_for_zoom_window"
	self.state = state

	if self.state == "waiting_for_zoom_window" then
		if not arg_14_1:get("mouse_left_held") then
			self.state = "drawing_zoom_window"
		end

		if not arg_14_1:get("mouse_middle_held") then
			self.state = "panning"
		end

		if not arg_14_1:get("mouse_right_held") then
			self.zoom_window = {}

			local num_3 = (self.visual_frame.x_max - self.range_x[1]) / (self.visual_frame.x_max - self.visual_frame.x_min)
			local num_4 = (self.range_x[2] - self.visual_frame.x_min) / (self.visual_frame.x_max - self.visual_frame.x_min)
			local num_5 = (self.visual_frame.y_max - self.range_y[1]) / (self.visual_frame.y_max - self.visual_frame.y_min)
			local num_6 = (self.range_y[2] - self.visual_frame.y_min) / (self.visual_frame.y_max - self.visual_frame.y_min)

			self.zoom_window.x_min = var_14_1.x + num - num * num_3
			self.zoom_window.x_max = var_14_1.x + num * num_4
			self.zoom_window.y_min = var_14_1.y + num_2 - num_2 * num_5
			self.zoom_window.y_max = var_14_1.y + num_2 * num_6
			self.zoom_window.min_size = 100
			self.scroll_lock.right = true
			self.scroll_lock.left = true
			self.scroll_lock.vertical = true
			self.state = "zoom_prepare"
		end
	end

	if self.state == "drawing_zoom_window" then
		if not arg_14_1:get("mouse_left_held") then
			if self.zoom_window == nil then
				local flag = true
				local flag_2 = true

				if get.x > var_14_1.x + num then
					local num_7 = (self.range_x[2] - self.visual_frame.x_min) / (self.visual_frame.x_max - self.visual_frame.x_min)

					self.zoom_window = {}
					self.zoom_window.x_min = var_14_1.x
					self.zoom_window.x_max = var_14_1.x + num * num_7
					self.zoom_window.y_min = var_14_1.y
					self.zoom_window.y_max = var_14_1.y + num_2
					self.zoom_window.min_size = 100
					self.scroll_lock.right = true
					self.state = "zoom_prepare"

					return
				elseif get.x < var_14_1.x then
					local num_8 = (self.visual_frame.x_max - self.range_x[1]) / (self.visual_frame.x_max - self.visual_frame.x_min)

					self.zoom_window = {}
					self.zoom_window.x_min = var_14_1.x + num - num * num_8
					self.zoom_window.x_max = var_14_1.x + num
					self.zoom_window.y_min = var_14_1.y
					self.zoom_window.y_max = var_14_1.y + num_2
					self.zoom_window.min_size = 100
					self.scroll_lock.left = true
					self.state = "zoom_prepare"

					return
				end

				if get.y > var_14_1.y + num_2 then
					local num_9 = (self.visual_frame.y_max - self.range_y[1]) / (self.visual_frame.y_max - self.visual_frame.y_min)
					local num_10 = (self.range_y[2] - self.visual_frame.y_min) / (self.visual_frame.y_max - self.visual_frame.y_min)

					self.zoom_window = {}
					self.zoom_window.x_min = var_14_1.x + num - num
					self.zoom_window.x_max = var_14_1.x + num
					self.zoom_window.y_min = var_14_1.y + num_2 - num_2 * num_9
					self.zoom_window.y_max = var_14_1.y + num_2 * num_10
					self.zoom_window.min_size = 100
					self.scroll_lock.vertical = true
					self.state = "zoom_prepare"

					return
				end

				self.zoom_window = {
					x_start = get.x,
					y_start = get.y
				}
			end

			self.zoom_window.x_end = get.x
			self.zoom_window.y_end = get.y
			self.zoom_window.x_min = math.min(self.zoom_window.x_end, self.zoom_window.x_start)
			self.zoom_window.x_max = math.max(self.zoom_window.x_end, self.zoom_window.x_start)
			self.zoom_window.y_min = math.min(self.zoom_window.y_end, self.zoom_window.y_start)
			self.zoom_window.y_max = math.max(self.zoom_window.y_end, self.zoom_window.y_start)
			self.zoom_window.min_size = math.min(self.zoom_window.x_max - self.zoom_window.x_min, self.zoom_window.y_max - self.zoom_window.y_min)
		elseif not (self.zoom_window == nil or not (self.zoom_window.min_size < 20)) then
			self.zoom_window = nil
			self.state = "waiting_for_zoom_window"
		elseif not self.zoom_window then
			self.state = "zoom_prepare"
			self.scroll_lock.left = false
			self.scroll_lock.right = false
			self.scroll_lock.vertical = false
		end
	end

	if self.state == "panning" then
		if not arg_14_1:get("mouse_middle_held") then
			self.state = "waiting_for_zoom_window"
			self.pan_previous = nil

			return
		end

		if self.pan_previous == nil then
			self.pan_previous = {
				x = get.x,
				y = get.y
			}
		end

		local var_14_15 = Vector2(self.pan_previous.x - get.x, self.pan_previous.y - get.y)
		local num_11 = (self.visual_frame.x_max - self.visual_frame.x_min) / num
		local num_12 = (self.visual_frame.y_max - self.visual_frame.y_min) / num_2

		if not self.scroll_lock.left then
			self.visual_frame.x_min = self.visual_frame.x_min + var_14_15.x * num_11
		end

		if not self.scroll_lock.right then
			self.visual_frame.x_max = self.visual_frame.x_max + var_14_15.x * num_11
		end

		if not self.scroll_lock.vertical then
			self.visual_frame.y_min = self.visual_frame.y_min + var_14_15.y * num_12
			self.visual_frame.y_max = self.visual_frame.y_max + var_14_15.y * num_12
		end

		self.pan_previous = {
			x = get.x,
			y = get.y
		}
	end

	if self.state == "zoom_prepare" then
		local num_13 = (self.zoom_window.x_min - var_14_1.x) / num
		local num_14 = (self.zoom_window.x_max - var_14_1.x) / num
		local num_15 = (self.zoom_window.y_min - var_14_1.x) / num_2
		local num_16 = (self.zoom_window.y_max - var_14_1.x) / num_2

		self.visual_frame.x_min = math.max(self.range_x[1], self.visual_frame.x_min)
		self.visual_frame.x_max = math.min(self.range_x[2], self.visual_frame.x_max)
		self.visual_frame.y_min = math.max(self.range_y[1], self.visual_frame.y_min)
		self.visual_frame.y_max = math.min(self.range_y[2], self.visual_frame.y_max)

		local x_min = self.visual_frame.x_min
		local x_max = self.visual_frame.x_max
		local y_min = self.visual_frame.y_min
		local y_max = self.visual_frame.y_max
		local lerp = math.lerp(x_min, x_max, num_13)
		local lerp_2 = math.lerp(x_min, x_max, num_14)
		local lerp_3 = math.lerp(y_min, y_max, num_15)
		local lerp_4 = math.lerp(y_min, y_max, num_16)

		self.zoom_window.target_x_min = lerp
		self.zoom_window.target_x_max = lerp_2
		self.zoom_window.target_y_min = lerp_3
		self.zoom_window.target_y_max = lerp_4
		self.anim_done_t = arg_14_2 + 1
		self.state = "zooming"
	end

	if self.state == "zooming" then
		Debug.text("zooming")

		self.zoom_window.x_min = math.lerp(self.zoom_window.x_min, var_14_1.x, 0.2)
		self.zoom_window.x_max = math.lerp(self.zoom_window.x_max, var_14_1.x + num, 0.2)
		self.zoom_window.y_min = math.lerp(self.zoom_window.y_min, var_14_1.y, 0.2)
		self.zoom_window.y_max = math.lerp(self.zoom_window.y_max, var_14_1.y + num_2, 0.2)

		local target_x_min = self.zoom_window.target_x_min
		local target_x_max = self.zoom_window.target_x_max
		local target_y_min = self.zoom_window.target_y_min
		local target_y_max = self.zoom_window.target_y_max

		self.visual_frame.x_min = math.lerp(self.visual_frame.x_min, target_x_min, 0.2)
		self.visual_frame.x_max = math.lerp(self.visual_frame.x_max, target_x_max, 0.2)
		self.visual_frame.y_min = math.lerp(self.visual_frame.y_min, target_y_min, 0.2)
		self.visual_frame.y_max = math.lerp(self.visual_frame.y_max, target_y_max, 0.2)

		Debug.text(self.visual_frame.x_min)

		if arg_14_2 > self.anim_done_t then
			self.visual_frame.x_min = target_x_min
			self.visual_frame.x_max = target_x_max
			self.visual_frame.y_min = target_y_min
			self.visual_frame.y_max = target_y_max
			self.anim_done_t = nil
			self.zoom_window = nil
			self.state = "waiting_for_zoom_window"
		end
	end
end

Graph.draw = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local get = arg_15_2:get("cursor")
	local num = 1
	local num_2 = 2
	local num_3 = 26
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local get_color_with_alpha = Colors.get_color_with_alpha
	local str_3 = "navy"
	local flag

	flag = not Window.show_cursor() and 100 and 50

	local var_15_9 = get_color_with_alpha(str_3, flag)
	local get_2 = Colors.get("aqua_marine")
	local get_3 = Colors.get("white")
	local get_4 = Colors.get("black")
	local get_5 = Colors.get("white")
	local get_color_with_alpha_2 = Colors.get_color_with_alpha("yellow", 100)
	local get_6 = Colors.get("yellow")
	local get_color_with_alpha_3 = Colors.get_color_with_alpha("black", 100)
	local get_color_with_alpha_4 = Colors.get_color_with_alpha("black", 150)
	local get_7 = Colors.get("white")
	local get_color_with_alpha_5 = Colors.get_color_with_alpha
	local str_4 = "white"
	local flag_2

	flag_2 = self.anim_done_t ~= nil or not 100 or math.lerp(100, 0, 1 - (self.anim_done_t - arg_15_3))

	local var_15_22 = get_color_with_alpha_5(str_4, flag_2)
	local get_color_with_alpha_6 = Colors.get_color_with_alpha("red", 100)
	local var_15_24 = Vector3(100, 100, 0)
	local num_4 = 800
	local num_5 = 400

	Gui.rect(arg_15_1, var_15_24, Vector2(num_4, num_5), var_15_9)

	local var_15_27 = Vector3(var_15_24.x + num_4 + 5, 0, var_15_24.y + 5)
	local var_15_28 = Vector3(var_15_24.x + num_4 + 5, 0, var_15_24.y - 5)
	local var_15_29 = Vector3(var_15_24.x + num_4 + 15, 0, var_15_24.y)

	Gui.triangle(arg_15_1, var_15_27, var_15_28, var_15_29, num, get_7)

	local var_15_30 = Vector3(var_15_24.x + 5, 0, var_15_24.y + num_5 + 5)
	local var_15_31 = Vector3(var_15_24.x - 5, 0, var_15_24.y + num_5 + 5)
	local var_15_32 = Vector3(var_15_24.x, 0, var_15_24.y + num_5 + 15)

	Gui.triangle(arg_15_1, var_15_30, var_15_31, var_15_32, num, get_7)
	ScriptGUI.hud_line(arg_15_1, var_15_24, var_15_24 + Vector3(num_4 + 10, 0, 0), num, 1, get_7)
	ScriptGUI.hud_line(arg_15_1, var_15_24, var_15_24 + Vector3(0, num_5 + 10, 0), num, 1, get_7)
	Gui.text(arg_15_1, self.axis_names[1], str_2, num_3, str, var_15_24 + Vector3(-50 + num_4, -20, 0), get_7)
	Gui.text(arg_15_1, self.axis_names[2], str_2, num_3, str, var_15_24 + Vector3(-50, num_5 + 20, 0), get_7)

	local x_min = self.visual_frame.x_min
	local x_max = self.visual_frame.x_max
	local y_min = self.visual_frame.y_min
	local y_max = self.visual_frame.y_max

	if not (x_max == x_min or y_max ~= y_min) then
		return
	end

	Gui.text(arg_15_1, string.format("(%.2f, %.2f)", x_min, y_min), str_2, num_3, str, var_15_24 + Vector3(-50, -20, 0), get_7)
	Gui.text(arg_15_1, string.format("(%.2f, %.2f)", x_max, y_max), str_2, num_3, str, var_15_24 + Vector3(-50 + num_4, 10 + num_5, 0), get_7)

	if not self.valid then
		return
	end

	local num_6 = num_4 / (x_max - x_min)
	local num_7 = num_5 / (y_max - y_min)

	for k, v in pairs(self.plots) do
		local get_8

		if not v.line_color then
			get_8 = Colors.get(v.line_color)

			if not get_8 then
				-- Nothing
			end
		end

		get_8 = get_2

		do
			local get_9
		end

		::label_15_0::

		if not v.line_color then
			get_9 = Colors.get(v.line_color)

			if not get_9 then
				-- Nothing
			end
		end

		get_9 = get_3

		::label_15_1::

		local items = foundation_scripts_util_array.items(v.points_x)
		local items_2 = foundation_scripts_util_array.items(v.points_y)
		local var_15_43 = Vector3((items[1] - x_min) * num_6, (items_2[1] - y_min) * num_7, 0)
		local num_items = foundation_scripts_util_array.num_items(v.points_x)

		for k_2 = 2, num_items do
			local var_15_45 = Vector3((items[k_2] - x_min) * num_6, (items_2[k_2] - y_min) * num_7, 0)
			local flag_3 = not (var_15_43.x >= 0) or num_4 >= var_15_43.x
			local flag_4 = not (var_15_43.y >= 0) or num_5 >= var_15_43.y
			local flag_5 = not (var_15_45.x >= 0) or num_4 >= var_15_45.x
			local flag_6 = not (var_15_45.y >= 0) or num_5 >= var_15_45.y

			if not flag_3 and flag_4 and not flag_5 or not flag_6 then
				ScriptGUI.hud_line(arg_15_1, var_15_43 + var_15_24, var_15_45 + var_15_24, num, num_2, get_8)
				Gui.rect(arg_15_1, var_15_45 + var_15_24 + Vector3(-3, -3, 100), Vector3(6, 6, 0), get_9)
			end

			var_15_43 = var_15_45
		end
	end

	local items_3 = foundation_scripts_util_array.items(self.annotations_data)
	local num_items_2 = foundation_scripts_util_array.num_items(self.annotations_data)
	local num_8 = -10
	local num_9 = -10
	local num_10 = 0

	for l = 1, num_items_2 do
		local var_15_55 = items_3[l]
		local var_15_56 = Vector3((var_15_55.x - x_min) * num_6, 0, 0)

		if not (not (var_15_56.x >= 0) or num_4 >= var_15_56.x) then
			if var_15_56.x < num_8 + 8 then
				num_9 = num_9 - 10
			else
				num_9 = -10
			end

			num_8 = var_15_56.x
			var_15_56.y = var_15_56.y + num_9

			if Vector3.distance_squared(var_15_56 + var_15_24, get) < 64 then
				Gui.rect(arg_15_1, var_15_56 + var_15_24 + Vector3(-5, -5, 10), Vector3(10, 10, 0), get_5)

				local get_10 = Colors.get(var_15_55.color)

				ScriptGUI.hud_line(arg_15_1, var_15_56 + var_15_24 + Vector3(0, -num_10, 0), var_15_56 + var_15_24 + Vector3(0, num_5, 0), num, 2, get_10)

				local text_extents, var_15_59, var_15_60 = Gui.text_extents(arg_15_1, var_15_55.text, str_2, num_3)
				local num_11 = var_15_59.x - text_extents.x + 10
				local get_11 = Colors.get(var_15_55.color)

				Gui.rect(arg_15_1, var_15_24 + Vector3(0, -70 - num_10, 0), Vector3(num_11, 30, 0), get_color_with_alpha_3)
				Gui.rect(arg_15_1, var_15_24 + Vector3(0, -70 - num_10, 0), Vector3(num_11, 5, 0), get_11)
				Gui.text(arg_15_1, var_15_55.text, str_2, num_3, str, var_15_24 + Vector3(5, -60 - num_10, 0), get_3)

				local var_15_63 = Vector3(var_15_56.x, (var_15_55.y - y_min) * num_7, 0)

				Gui.rect(arg_15_1, var_15_63 + var_15_24 + Vector3(-5, -5, 101), Vector3(10, 10, 0), get_11)
				Gui.rect(arg_15_1, var_15_63 + var_15_24 + Vector3(-6, -6, 100), Vector3(12, 12, 0), get_3)

				num_10 = num_10 + 30
			else
				local get_color_with_alpha_7 = Colors.get_color_with_alpha(var_15_55.color, 50)

				ScriptGUI.hud_line(arg_15_1, var_15_56 + var_15_24, var_15_56 + var_15_24 + Vector3(0, num_5, 0), num, 1, get_color_with_alpha_7)

				local get_color_with_alpha_8 = Colors.get_color_with_alpha(var_15_55.color, 150)
				local var_15_66 = Vector3(var_15_56.x, (var_15_55.y - y_min) * num_7, 0)

				Gui.rect(arg_15_1, var_15_66 + var_15_24 + Vector3(-3, -3, 100), Vector3(6, 6, 0), get_color_with_alpha_8)
			end

			local get_12 = Colors.get(var_15_55.color)

			Gui.rect(arg_15_1, var_15_56 + var_15_24 + Vector3(-4, -4, 100), Vector3(8, 8, 0), get_12)
			ScriptGUI.hud_line(arg_15_1, var_15_56 + var_15_24, var_15_56 + var_15_24 + Vector3(0, num_5, 0), num, 1, get_color_with_alpha_2)

			if not var_15_55.live then
				local num_12 = Vector3(var_15_56.x, (var_15_55.y - y_min) * num_7, 0) + var_15_24 + Vector3(-3, -3, 100)

				Gui.text(arg_15_1, var_15_55.text, str_2, num_3, str, num_12, get_12)
			end
		end
	end

	Gui.rect(arg_15_1, var_15_24 + Vector3(0, -40, 0), Vector3(num_4, 40, 0), get_color_with_alpha_4)

	if not self.zoom_window then
		local var_15_69 = Vector3(self.zoom_window.x_min, self.zoom_window.y_min, 0)
		local var_15_70 = Vector3(self.zoom_window.x_max - self.zoom_window.x_min, self.zoom_window.y_max - self.zoom_window.y_min, 0)

		if self.zoom_window.min_size < 20 then
			Gui.rect(arg_15_1, var_15_69, var_15_70, get_color_with_alpha_6)
		else
			Gui.rect(arg_15_1, var_15_69, var_15_70, var_15_22)
		end
	else
		if get.x > var_15_24.x + num_4 then
			Gui.rect(arg_15_1, var_15_24 + Vector3(num_4, 0, 0), Vector2(50, num_5), var_15_22)
		elseif get.x < var_15_24.x then
			Gui.rect(arg_15_1, var_15_24 + Vector3(-50, 0, 0), Vector2(50, num_5), var_15_22)
		end

		if get.y > var_15_24.y + num_5 then
			Gui.rect(arg_15_1, var_15_24 + Vector3(0, -50, 0), Vector2(num_4, 50), var_15_22)
			Gui.rect(arg_15_1, var_15_24 + Vector3(0, num_5, 0), Vector2(num_4, 50), var_15_22)
		end
	end
end
