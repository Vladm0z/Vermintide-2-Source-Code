-- chunkname: @scripts/ui/hud_ui/deus_debug_map_ui.lua

require("scripts/managers/game_mode/mechanisms/deus_layout_base_graph")
require("scripts/managers/game_mode/mechanisms/deus_base_graph_generator")
require("scripts/managers/game_mode/mechanisms/deus_populate_graph")
require("scripts/settings/dlcs/morris/deus_default_graph_settings")

DeusDebugMapUI = class(DeusDebugMapUI)

local DeusDebugDrawMapSettings = DeusDebugDrawMapSettings

DeusDebugDrawMapSettings = DeusDebugDrawMapSettings or {}
DeusDebugDrawMapSettings = DeusDebugDrawMapSettings

local tbl = {
	[0] = ColorBox(Colors.get("black")),
	ColorBox(Colors.get("red")),
	ColorBox(Colors.get("green")),
	ColorBox(Colors.get("blue")),
	ColorBox(Colors.get("dark_cyan")),
	ColorBox(Colors.get("purple")),
	(ColorBox(Colors.get("orange")))
}
local num = 0.2
local num_2 = 0.2
local num_3 = 0.7
local num_4 = 0.7

DeusDebugMapUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._world = arg_1_2.world_manager:world("level_world")
	self._gui = World.create_screen_gui(self._world, "immediate", "material", "materials/fonts/gw_fonts")
end

DeusDebugMapUI.destroy = function (self)
	-- function 2
	World.destroy_gui(self._world, self._gui)

	self._gui = nil
end

DeusDebugMapUI.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not script_data.deus_debug_draw_map then
		self._current_seed = nil

		return
	end

	local resolution, var_3_1 = Gui.resolution()

	Gui.rect(self._gui, Vector2(0, 0), Vector2(resolution, var_3_1), Color(255, 255, 255, 255))

	local game_mechanism = Managers.mechanism:game_mechanism()
	local flag = not game_mechanism and game_mechanism:get_deus_run_controller()

	if not flag then
		self:_draw_final_graph(flag:get_graph_data())
	elseif not DeusDebugDrawMapSettings.base_graph then
		self:_draw_base_graph(DeusDebugDrawMapSettings.base_graph)
	elseif not DeusDebugDrawMapSettings.final_graph then
		self:_draw_final_graph(DeusDebugDrawMapSettings.final_graph)
	end
end

DeusDebugMapUI._draw_base_graph = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local str = "materials/fonts/arial"
	local str_2 = "arial"
	local num_5 = 10
	local resolution, var_4_4 = Gui.resolution()
	local num_6 = resolution * num
	local num_7 = var_4_4 * num_2
	local num_8 = resolution * num_3
	local num_9 = var_4_4 * num_4
	local _gui = self._gui

	self:_draw_edges(arg_4_1)

	for k, v in pairs(arg_4_1) do
		local num_10 = num_6 + num_8 * arg_4_1[k].layout_x
		local num_11 = num_7 + num_9 * arg_4_1[k].layout_y

		if v.type == "SIGNATURE" then
			local rect = Gui.rect
			local var_4_13 = _gui
			local var_4_14 = Vector2(num_10 - 10, num_11 - 10)
			local var_4_15 = Vector2(20, 20)
			local var_4_16 = tbl
			local label = v.label

			label = label or 0

			rect(var_4_13, var_4_14, var_4_15, var_4_16[label]:unbox())
		elseif v.type == "TRAVEL" then
			local var_4_18 = Vector3(num_10 + 10, 0, num_11 - 10)
			local var_4_19 = Vector3(num_10 - 10, 0, num_11 - 10)
			local var_4_20 = Vector3(num_10, 0, num_11 + 10)
			local triangle = Gui.triangle
			local var_4_22 = _gui
			local var_4_23 = var_4_18
			local var_4_24 = var_4_19
			local var_4_25 = var_4_20
			local num_12 = 1
			local var_4_27 = tbl
			local label_2 = v.label

			label_2 = label_2 or 0

			triangle(var_4_22, var_4_23, var_4_24, var_4_25, num_12, var_4_27[label_2]:unbox())
		else
			local rect_2 = Gui.rect
			local var_4_30 = _gui
			local var_4_31 = Vector2(num_10 - 10, num_11 - 10)
			local var_4_32 = Vector2(15, 15)
			local var_4_33 = tbl
			local label_3 = v.label

			label_3 = label_3 or 0

			rect_2(var_4_30, var_4_31, var_4_32, var_4_33[label_3]:unbox())
		end

		local text_extents = Gui.text_extents
		local var_4_36 = _gui
		local type = v.type

		type = type or ""

		local var_4_38, var_4_39 = text_extents(var_4_36, type, str, num_5)
		local num_13 = var_4_39.x - var_4_38.x
		local text = Gui.text
		local var_4_42 = _gui
		local type_2 = v.type

		type_2 = type_2 or ""

		text(var_4_42, type_2, str, num_5, str_2, Vector3(num_10 - num_13 * 0.5, num_11 - 20, 0), Color(255, 0, 0, 0))

		local str_3 = "connected_to:"
		local connected_to = v.connected_to

		connected_to = connected_to or 0

		local str_4 = str_3 .. connected_to
		local text_extents_2, var_4_48 = Gui.text_extents(_gui, str_4, str, num_5)
		local num_14 = var_4_48.x - text_extents_2.x

		Gui.text(_gui, str_4, str, num_5, str_2, Vector3(num_10 - num_14 * 0.5, num_11 - 40, 0), Color(255, 0, 0, 0))

		local str_5 = "label:"
		local label_4 = v.label

		label_4 = label_4 or 0

		local str_6 = str_5 .. label_4
		local text_extents_3, var_4_54 = Gui.text_extents(_gui, str_6, str, num_5)
		local num_15 = var_4_54.x - text_extents_3.x
		local text_2 = Gui.text
		local var_4_57 = _gui
		local var_4_58 = str_6
		local var_4_59 = str
		local var_4_60 = num_5
		local var_4_61 = str_2
		local var_4_62 = Vector3(num_10 - num_15 * 0.5, num_11 - 50, 0)
		local var_4_63 = tbl
		local label_5 = v.label

		label_5 = label_5 or 0

		text_2(var_4_57, var_4_58, var_4_59, var_4_60, var_4_61, var_4_62, var_4_63[label_5]:unbox())

		local text_extents_4, var_4_66 = Gui.text_extents(_gui, k, str, num_5)
		local num_16 = var_4_66.x - text_extents_4.x

		Gui.text(_gui, k, str, num_5, str_2, Vector3(num_10 - num_16 * 0.5, num_11 + 20, 0), Color(255, 0, 0, 0))
	end
end

DeusDebugMapUI._draw_final_graph = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local str = "materials/fonts/arial"
	local str_2 = "arial"
	local num_5 = 10
	local resolution, var_5_4 = Gui.resolution()
	local num_6 = resolution * num
	local num_7 = var_5_4 * num_2
	local num_8 = resolution * num_3
	local num_9 = var_5_4 * num_4
	local _gui = self._gui

	self:_draw_edges(arg_5_1)

	for k, v in pairs(arg_5_1) do
		local num_10 = num_6 + num_8 * arg_5_1[k].layout_x
		local num_11 = num_7 + num_9 * arg_5_1[k].layout_y
		local num_12 = 10

		Gui.rect(_gui, Vector2(num_10 - 10, num_11 - 10), Vector2(20, 20), Color(255, 0, 0, 0))

		local level = v.level
		local text_extents, var_5_15 = Gui.text_extents(_gui, level, str, num_5)
		local num_13 = var_5_15.x - text_extents.x
		local num_14 = num_12 + 10

		Gui.text(_gui, level, str, num_5, str_2, Vector3(num_10 - num_13 * 0.5, num_11 - num_14, 0), Color(255, 0, 0, 0))

		local conflict_settings = v.conflict_settings
		local flag = conflict_settings or ""
		local text_extents_2, var_5_21 = Gui.text_extents(_gui, flag, str, num_5)
		local num_15 = var_5_21.x - text_extents_2.x
		local num_16 = num_14 + 10

		Gui.text(_gui, flag, str, num_5, str_2, Vector3(num_10 - num_15 * 0.5, num_11 - num_16, 0), Color(255, 0, 0, 0))

		local var_5_24 = ConflictDirectors[conflict_settings]

		if not var_5_24 and not var_5_24.description then
			local str_3 = "breed: " .. Localize(var_5_24.description)

			str_3 = str_3 or ""

			local text_extents_3, var_5_27 = Gui.text_extents(_gui, str_3, str, num_5)
			local num_17 = var_5_27.x - text_extents_3.x

			num_16 = num_16 + 10

			Gui.text(_gui, str_3, str, num_5, str_2, Vector3(num_10 - num_17 * 0.5, num_11 - num_16, 0), Color(255, 0, 0, 0))
		end

		if not v.curse then
			local str_4 = "curse: " .. v.curse
			local text_extents_4, var_5_31 = Gui.text_extents(_gui, str_4, str, num_5)
			local num_18 = var_5_31.x - text_extents_4.x

			num_16 = num_16 + 10

			Gui.text(_gui, str_4, str, num_5, str_2, Vector3(num_10 - num_18 * 0.5, num_11 - num_16, 0), Color(255, 0, 0, 0))
		end

		if not v.minor_modifier_group then
			local str_5 = "modifiers: " .. table.concat(v.minor_modifier_group, ", ")
			local text_extents_5, var_5_35 = Gui.text_extents(_gui, str_5, str, num_5)
			local num_19 = var_5_35.x - text_extents_5.x

			num_16 = num_16 + 10

			Gui.text(_gui, str_5, str, num_5, str_2, Vector3(num_10 - num_19 * 0.5, num_11 - num_16, 0), Color(255, 0, 0, 0))
		end

		if not v.terror_event_power_up then
			local str_6 = "power_up: " .. v.terror_event_power_up .. "(" .. v.terror_event_power_up_rarity .. ")"
			local text_extents_6, var_5_39 = Gui.text_extents(_gui, str_6, str, num_5)
			local num_20 = var_5_39.x - text_extents_6.x

			num_16 = num_16 + 10

			Gui.text(_gui, str_6, str, num_5, str_2, Vector3(num_10 - num_20 * 0.5, num_11 - num_16, 0), Color(255, 0, 0, 0))
		end

		local str_7 = k .. " (" .. math.floor(v.run_progress * 100) / 100 .. ")"
		local text_extents_7, var_5_43 = Gui.text_extents(_gui, str_7, str, num_5)
		local num_21 = var_5_43.x - text_extents_7.x

		Gui.text(_gui, str_7, str, num_5, str_2, Vector3(num_10 - num_21 * 0.5, num_11 + 20, 0), Color(255, 0, 0, 0))

		local str_8 = "level_seed :" .. v.level_seed
		local text_extents_8, var_5_47 = Gui.text_extents(_gui, str_8, str, num_5)
		local num_22 = var_5_47.x - text_extents_8.x
		local num_23 = num_16 + 10

		Gui.text(_gui, str_8, str, num_5, str_2, Vector3(num_10 - num_22 * 0.5, num_11 - num_23, 0), Color(255, 0, 0, 0))

		if not v.possible_arena_belakor_nodes then
			local str_9 = "arena_belakor_nodes: " .. table.concat(v.possible_arena_belakor_nodes, ", ")
			local text_extents_9, var_5_52 = Gui.text_extents(_gui, str_9, str, num_5)
			local num_24 = var_5_52.x - text_extents_9.x
			local num_25 = num_23 + 10

			Gui.text(_gui, str_9, str, num_5, str_2, Vector3(num_10 - num_24 * 0.5, num_11 - num_25, 0), Color(255, 0, 0, 0))
		end
	end
end

DeusDebugMapUI._draw_edges = function (self, arg_6_1)
	-- function 6
	local resolution, var_6_1 = Gui.resolution()
	local num_5 = resolution * num
	local num_6 = var_6_1 * num_2
	local num_7 = resolution * num_3
	local num_8 = var_6_1 * num_4

	for k, v in pairs(arg_6_1) do
		local num_9 = num_5 + num_7 * arg_6_1[k].layout_x
		local num_10 = num_6 + num_8 * arg_6_1[k].layout_y

		for i, v_2 in ipairs(v.next) do
			local num_11 = num_5 + num_7 * arg_6_1[v_2].layout_x
			local num_12 = num_6 + num_8 * arg_6_1[v_2].layout_y

			self:_draw_edge(num_9, num_10, num_11, num_12)
		end
	end
end

DeusDebugMapUI._draw_edge = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local num = arg_7_3 - arg_7_1
	local num_2 = arg_7_4 - arg_7_2

	if not (num ~= 0 or num_2 == 0) then
		local sqrt = math.sqrt(num * num + num_2 * num_2)
		local floor = math.floor(sqrt / 10)
		local num_3 = num / floor
		local num_4 = num_2 / floor
		local var_7_6 = arg_7_1
		local var_7_7 = arg_7_2

		for i = 1, floor do
			Gui.rect(self._gui, Vector2(var_7_6, var_7_7), Vector2(2 + 5 * (i / floor), 2 + 5 * (i / floor)), Color(128, 0, 0, 0))

			var_7_6 = var_7_6 + num_3
			var_7_7 = var_7_7 + num_4
		end
	end
end
