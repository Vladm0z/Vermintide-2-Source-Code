-- chunkname: @scripts/ui/hud_ui/deus_debug_map_ui.lua

require("scripts/managers/game_mode/mechanisms/deus_layout_base_graph")
require("scripts/managers/game_mode/mechanisms/deus_base_graph_generator")
require("scripts/managers/game_mode/mechanisms/deus_populate_graph")
require("scripts/settings/dlcs/morris/deus_default_graph_settings")

DeusDebugMapUI = class(DeusDebugMapUI)

local DeusDebugDrawMapSettings = DeusDebugDrawMapSettings

DeusDebugDrawMapSettings = not not DeusDebugDrawMapSettings or not not {}
DeusDebugDrawMapSettings = DeusDebugDrawMapSettings

local color_map_for_label = {
	[0] = ColorBox(Colors.get("black")),
	ColorBox(Colors.get("red")),
	ColorBox(Colors.get("green")),
	ColorBox(Colors.get("blue")),
	ColorBox(Colors.get("dark_cyan")),
	ColorBox(Colors.get("purple")),
	(ColorBox(Colors.get("orange")))
}
local start_x = 0.2
local start_y = 0.2
local total_width = 0.7
local total_height = 0.7

DeusDebugMapUI.init = function (self, parent, ingame_ui_context)
	-- function 1
	self._world = ingame_ui_context.world_manager:world("level_world")
	self._gui = World.create_screen_gui(self._world, "immediate", "material", "materials/fonts/gw_fonts")
end

DeusDebugMapUI.destroy = function (self)
	-- function 2
	World.destroy_gui(self._world, self._gui)

	self._gui = nil
end

DeusDebugMapUI.update = function (self, dt, t)
	-- function 3
	if not script_data.deus_debug_draw_map then
		self._current_seed = nil

		return
	end

	local width, height = Gui.resolution()

	Gui.rect(self._gui, Vector2(0, 0), Vector2(width, height), Color(255, 255, 255, 255))

	local mechanism = Managers.mechanism:game_mechanism()
	local deus_run_controller = not not mechanism and not not mechanism:get_deus_run_controller()

	if deus_run_controller then
		self:_draw_final_graph(deus_run_controller:get_graph_data())
	elseif DeusDebugDrawMapSettings.base_graph then
		self:_draw_base_graph(DeusDebugDrawMapSettings.base_graph)
	elseif DeusDebugDrawMapSettings.final_graph then
		self:_draw_final_graph(DeusDebugDrawMapSettings.final_graph)
	end
end

DeusDebugMapUI._draw_base_graph = function (self, graph, dt, t)
	-- function 4
	local font = "materials/fonts/arial"
	local font_material = "arial"
	local font_size = 10
	local width, height = Gui.resolution()
	local min_x = width * start_x
	local min_y = height * start_y
	local layout_width = width * total_width
	local layout_height = height * total_height
	local gui = self._gui

	self:_draw_edges(graph)

	for key, node in pairs(graph) do
		local pos_x = min_x + layout_width * graph[key].layout_x
		local pos_y = min_y + layout_height * graph[key].layout_y

		if node.type == "SIGNATURE" then
			local rect = Gui.rect
			local var_4_1 = gui
			local var_4_2 = Vector2(pos_x - 10, pos_y - 10)
			local var_4_3 = Vector2(20, 20)
			local var_4_4 = color_map_for_label
			local label = node.label

			label = not not label or not not 0

			rect(var_4_1, var_4_2, var_4_3, var_4_4[label]:unbox())
		elseif node.type == "TRAVEL" then
			local axis_y_p1 = Vector3(pos_x + 10, 0, pos_y - 10)
			local axis_y_p2 = Vector3(pos_x - 10, 0, pos_y - 10)
			local axis_y_p3 = Vector3(pos_x, 0, pos_y + 10)
			local triangle = Gui.triangle
			local var_4_7 = gui
			local var_4_8 = axis_y_p1
			local var_4_9 = axis_y_p2
			local var_4_10 = axis_y_p3
			local num = 1
			local var_4_12 = color_map_for_label
			local label_2 = node.label

			label_2 = not not label_2 or not not 0

			triangle(var_4_7, var_4_8, var_4_9, var_4_10, num, var_4_12[label_2]:unbox())
		else
			local rect_2 = Gui.rect
			local var_4_15 = gui
			local var_4_16 = Vector2(pos_x - 10, pos_y - 10)
			local var_4_17 = Vector2(15, 15)
			local var_4_18 = color_map_for_label
			local label_3 = node.label

			label_3 = not not label_3 or not not 0

			rect_2(var_4_15, var_4_16, var_4_17, var_4_18[label_3]:unbox())
		end

		local text_extents = Gui.text_extents
		local var_4_21 = gui
		local type = node.type

		type = not not type or not not ""

		local min, max = text_extents(var_4_21, type, font, font_size)
		local text_width = max.x - min.x
		local text = Gui.text
		local var_4_24 = gui
		local type_2 = node.type

		type_2 = not not type_2 or not not ""

		text(var_4_24, type_2, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - 20, 0), Color(255, 0, 0, 0))

		local str = "connected_to:"
		local connected_to = node.connected_to

		connected_to = not not connected_to or not not 0

		local connected_to_text = str .. connected_to

		min, max = Gui.text_extents(gui, connected_to_text, font, font_size)
		text_width = max.x - min.x

		Gui.text(gui, connected_to_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - 40, 0), Color(255, 0, 0, 0))

		local str_2 = "label:"
		local label_4 = node.label

		label_4 = not not label_4 or not not 0

		local label_text = str_2 .. label_4

		min, max = Gui.text_extents(gui, label_text, font, font_size)
		text_width = max.x - min.x

		local text_2 = Gui.text
		local var_4_31 = gui
		local var_4_32 = label_text
		local var_4_33 = font
		local var_4_34 = font_size
		local var_4_35 = font_material
		local var_4_36 = Vector3(pos_x - text_width * 0.5, pos_y - 50, 0)
		local var_4_37 = color_map_for_label
		local label_5 = node.label

		label_5 = not not label_5 or not not 0

		text_2(var_4_31, var_4_32, var_4_33, var_4_34, var_4_35, var_4_36, var_4_37[label_5]:unbox())

		min, max = Gui.text_extents(gui, key, font, font_size)
		text_width = max.x - min.x

		Gui.text(gui, key, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y + 20, 0), Color(255, 0, 0, 0))
	end
end

DeusDebugMapUI._draw_final_graph = function (self, graph, dt, t)
	-- function 5
	local font = "materials/fonts/arial"
	local font_material = "arial"
	local font_size = 10
	local width, height = Gui.resolution()
	local min_x = width * start_x
	local min_y = height * start_y
	local layout_width = width * total_width
	local layout_height = height * total_height
	local gui = self._gui

	self:_draw_edges(graph)

	for key, node in pairs(graph) do
		local pos_x = min_x + layout_width * graph[key].layout_x
		local pos_y = min_y + layout_height * graph[key].layout_y
		local y_delta = 10

		Gui.rect(gui, Vector2(pos_x - 10, pos_y - 10), Vector2(20, 20), Color(255, 0, 0, 0))

		local level_text = node.level
		local min, max = Gui.text_extents(gui, level_text, font, font_size)
		local text_width = max.x - min.x

		y_delta = y_delta + 10

		Gui.text(gui, level_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))

		local director_name = node.conflict_settings
		local conflict_text = not not director_name or not not ""

		min, max = Gui.text_extents(gui, conflict_text, font, font_size)
		text_width = max.x - min.x
		y_delta = y_delta + 10

		Gui.text(gui, conflict_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))

		local director = ConflictDirectors[director_name]

		if director and director.description then
			local str = "breed: " .. Localize(director.description)

			if not str then
				-- Nothing
			end

			str = ""

			local conflict_description_text = str

			::label_5_0::

			min, max = Gui.text_extents(gui, conflict_description_text, font, font_size)
			text_width = max.x - min.x
			y_delta = y_delta + 10

			Gui.text(gui, conflict_description_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))
		end

		if node.curse then
			local curse_text = "curse: " .. node.curse

			min, max = Gui.text_extents(gui, curse_text, font, font_size)
			text_width = max.x - min.x
			y_delta = y_delta + 10

			Gui.text(gui, curse_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))
		end

		if node.minor_modifier_group then
			local minor_modifier_text = "modifiers: " .. table.concat(node.minor_modifier_group, ", ")

			min, max = Gui.text_extents(gui, minor_modifier_text, font, font_size)
			text_width = max.x - min.x
			y_delta = y_delta + 10

			Gui.text(gui, minor_modifier_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))
		end

		if node.terror_event_power_up then
			local terror_event_power_up_text = "power_up: " .. node.terror_event_power_up .. "(" .. node.terror_event_power_up_rarity .. ")"

			min, max = Gui.text_extents(gui, terror_event_power_up_text, font, font_size)
			text_width = max.x - min.x
			y_delta = y_delta + 10

			Gui.text(gui, terror_event_power_up_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))
		end

		local key_text = key .. " (" .. math.floor(node.run_progress * 100) / 100 .. ")"

		min, max = Gui.text_extents(gui, key_text, font, font_size)
		text_width = max.x - min.x

		Gui.text(gui, key_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y + 20, 0), Color(255, 0, 0, 0))

		local level_seed_text = "level_seed :" .. node.level_seed

		min, max = Gui.text_extents(gui, level_seed_text, font, font_size)
		text_width = max.x - min.x
		y_delta = y_delta + 10

		Gui.text(gui, level_seed_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))

		if node.possible_arena_belakor_nodes then
			local possible_arena_belakor_nodes_text = "arena_belakor_nodes: " .. table.concat(node.possible_arena_belakor_nodes, ", ")

			min, max = Gui.text_extents(gui, possible_arena_belakor_nodes_text, font, font_size)
			text_width = max.x - min.x
			y_delta = y_delta + 10

			Gui.text(gui, possible_arena_belakor_nodes_text, font, font_size, font_material, Vector3(pos_x - text_width * 0.5, pos_y - y_delta, 0), Color(255, 0, 0, 0))
		end
	end
end

DeusDebugMapUI._draw_edges = function (self, graph)
	-- function 6
	local width, height = Gui.resolution()
	local min_x = width * start_x
	local min_y = height * start_y
	local layout_width = width * total_width
	local layout_height = height * total_height

	for key, node in pairs(graph) do
		local pos_x = min_x + layout_width * graph[key].layout_x
		local pos_y = min_y + layout_height * graph[key].layout_y

		for _, next in ipairs(node.next) do
			local target_x = min_x + layout_width * graph[next].layout_x
			local target_y = min_y + layout_height * graph[next].layout_y

			self:_draw_edge(pos_x, pos_y, target_x, target_y)
		end
	end
end

DeusDebugMapUI._draw_edge = function (self, from_x, from_y, to_x, to_y)
	-- function 7
	local dx, dy = to_x - from_x, to_y - from_y

	if dx ~= 0 or dy ~= 0 then
		local distance = math.sqrt(dx * dx + dy * dy)
		local dot_count = math.floor(distance / 10)
		local dot_delta_x, dot_delta_y = dx / dot_count, dy / dot_count
		local current_dot_x, current_dot_y = from_x, from_y

		for i = 1, dot_count do
			Gui.rect(self._gui, Vector2(current_dot_x, current_dot_y), Vector2(2 + 5 * (i / dot_count), 2 + 5 * (i / dot_count)), Color(128, 0, 0, 0))

			current_dot_x = current_dot_x + dot_delta_x
			current_dot_y = current_dot_y + dot_delta_y
		end
	end
end
