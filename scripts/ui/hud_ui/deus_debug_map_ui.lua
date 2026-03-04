-- chunkname: @scripts/ui/hud_ui/deus_debug_map_ui.lua

require("scripts/managers/game_mode/mechanisms/deus_layout_base_graph")
require("scripts/managers/game_mode/mechanisms/deus_base_graph_generator")
require("scripts/managers/game_mode/mechanisms/deus_populate_graph")
require("scripts/settings/dlcs/morris/deus_default_graph_settings")

DeusDebugMapUI = class(DeusDebugMapUI)
DeusDebugDrawMapSettings = DeusDebugDrawMapSettings or {}

local var_0_0 = {
	[0] = ColorBox(Colors.get("black")),
	ColorBox(Colors.get("red")),
	ColorBox(Colors.get("green")),
	ColorBox(Colors.get("blue")),
	ColorBox(Colors.get("dark_cyan")),
	ColorBox(Colors.get("purple")),
	(ColorBox(Colors.get("orange")))
}
local var_0_1 = 0.2
local var_0_2 = 0.2
local var_0_3 = 0.7
local var_0_4 = 0.7

DeusDebugMapUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._world = arg_1_2.world_manager:world("level_world")
	arg_1_0._gui = World.create_screen_gui(arg_1_0._world, "immediate", "material", "materials/fonts/gw_fonts")
end

DeusDebugMapUI.destroy = function (arg_2_0)
	World.destroy_gui(arg_2_0._world, arg_2_0._gui)

	arg_2_0._gui = nil
end

DeusDebugMapUI.update = function (arg_3_0, arg_3_1, arg_3_2)
	if not script_data.deus_debug_draw_map then
		arg_3_0._current_seed = nil

		return
	end

	local var_3_0, var_3_1 = Gui.resolution()

	Gui.rect(arg_3_0._gui, Vector2(0, 0), Vector2(var_3_0, var_3_1), Color(255, 255, 255, 255))

	local var_3_2 = Managers.mechanism:game_mechanism()
	local var_3_3 = var_3_2 and var_3_2:get_deus_run_controller()

	if var_3_3 then
		arg_3_0:_draw_final_graph(var_3_3:get_graph_data())
	elseif DeusDebugDrawMapSettings.base_graph then
		arg_3_0:_draw_base_graph(DeusDebugDrawMapSettings.base_graph)
	elseif DeusDebugDrawMapSettings.final_graph then
		arg_3_0:_draw_final_graph(DeusDebugDrawMapSettings.final_graph)
	end
end

DeusDebugMapUI._draw_base_graph = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = "materials/fonts/arial"
	local var_4_1 = "arial"
	local var_4_2 = 10
	local var_4_3, var_4_4 = Gui.resolution()
	local var_4_5 = var_4_3 * var_0_1
	local var_4_6 = var_4_4 * var_0_2
	local var_4_7 = var_4_3 * var_0_3
	local var_4_8 = var_4_4 * var_0_4
	local var_4_9 = arg_4_0._gui

	arg_4_0:_draw_edges(arg_4_1)

	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		local var_4_10 = var_4_5 + var_4_7 * arg_4_1[iter_4_0].layout_x
		local var_4_11 = var_4_6 + var_4_8 * arg_4_1[iter_4_0].layout_y

		if iter_4_1.type == "SIGNATURE" then
			Gui.rect(var_4_9, Vector2(var_4_10 - 10, var_4_11 - 10), Vector2(20, 20), var_0_0[iter_4_1.label or 0]:unbox())
		elseif iter_4_1.type == "TRAVEL" then
			local var_4_12 = Vector3(var_4_10 + 10, 0, var_4_11 - 10)
			local var_4_13 = Vector3(var_4_10 - 10, 0, var_4_11 - 10)
			local var_4_14 = Vector3(var_4_10, 0, var_4_11 + 10)

			Gui.triangle(var_4_9, var_4_12, var_4_13, var_4_14, 1, var_0_0[iter_4_1.label or 0]:unbox())
		else
			Gui.rect(var_4_9, Vector2(var_4_10 - 10, var_4_11 - 10), Vector2(15, 15), var_0_0[iter_4_1.label or 0]:unbox())
		end

		local var_4_15, var_4_16 = Gui.text_extents(var_4_9, iter_4_1.type or "", var_4_0, var_4_2)
		local var_4_17 = var_4_16.x - var_4_15.x

		Gui.text(var_4_9, iter_4_1.type or "", var_4_0, var_4_2, var_4_1, Vector3(var_4_10 - var_4_17 * 0.5, var_4_11 - 20, 0), Color(255, 0, 0, 0))

		local var_4_18 = "connected_to:" .. (iter_4_1.connected_to or 0)
		local var_4_19, var_4_20 = Gui.text_extents(var_4_9, var_4_18, var_4_0, var_4_2)
		local var_4_21 = var_4_20.x - var_4_19.x

		Gui.text(var_4_9, var_4_18, var_4_0, var_4_2, var_4_1, Vector3(var_4_10 - var_4_21 * 0.5, var_4_11 - 40, 0), Color(255, 0, 0, 0))

		local var_4_22 = "label:" .. (iter_4_1.label or 0)
		local var_4_23, var_4_24 = Gui.text_extents(var_4_9, var_4_22, var_4_0, var_4_2)
		local var_4_25 = var_4_24.x - var_4_23.x

		Gui.text(var_4_9, var_4_22, var_4_0, var_4_2, var_4_1, Vector3(var_4_10 - var_4_25 * 0.5, var_4_11 - 50, 0), var_0_0[iter_4_1.label or 0]:unbox())

		local var_4_26, var_4_27 = Gui.text_extents(var_4_9, iter_4_0, var_4_0, var_4_2)
		local var_4_28 = var_4_27.x - var_4_26.x

		Gui.text(var_4_9, iter_4_0, var_4_0, var_4_2, var_4_1, Vector3(var_4_10 - var_4_28 * 0.5, var_4_11 + 20, 0), Color(255, 0, 0, 0))
	end
end

DeusDebugMapUI._draw_final_graph = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = "materials/fonts/arial"
	local var_5_1 = "arial"
	local var_5_2 = 10
	local var_5_3, var_5_4 = Gui.resolution()
	local var_5_5 = var_5_3 * var_0_1
	local var_5_6 = var_5_4 * var_0_2
	local var_5_7 = var_5_3 * var_0_3
	local var_5_8 = var_5_4 * var_0_4
	local var_5_9 = arg_5_0._gui

	arg_5_0:_draw_edges(arg_5_1)

	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		local var_5_10 = var_5_5 + var_5_7 * arg_5_1[iter_5_0].layout_x
		local var_5_11 = var_5_6 + var_5_8 * arg_5_1[iter_5_0].layout_y
		local var_5_12 = 10

		Gui.rect(var_5_9, Vector2(var_5_10 - 10, var_5_11 - 10), Vector2(20, 20), Color(255, 0, 0, 0))

		local var_5_13 = iter_5_1.level
		local var_5_14, var_5_15 = Gui.text_extents(var_5_9, var_5_13, var_5_0, var_5_2)
		local var_5_16 = var_5_15.x - var_5_14.x
		local var_5_17 = var_5_12 + 10

		Gui.text(var_5_9, var_5_13, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_16 * 0.5, var_5_11 - var_5_17, 0), Color(255, 0, 0, 0))

		local var_5_18 = iter_5_1.conflict_settings
		local var_5_19 = var_5_18 or ""
		local var_5_20, var_5_21 = Gui.text_extents(var_5_9, var_5_19, var_5_0, var_5_2)
		local var_5_22 = var_5_21.x - var_5_20.x
		local var_5_23 = var_5_17 + 10

		Gui.text(var_5_9, var_5_19, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_22 * 0.5, var_5_11 - var_5_23, 0), Color(255, 0, 0, 0))

		local var_5_24 = ConflictDirectors[var_5_18]

		if var_5_24 and var_5_24.description then
			local var_5_25 = "breed: " .. Localize(var_5_24.description) or ""
			local var_5_26, var_5_27 = Gui.text_extents(var_5_9, var_5_25, var_5_0, var_5_2)
			local var_5_28 = var_5_27.x - var_5_26.x

			var_5_23 = var_5_23 + 10

			Gui.text(var_5_9, var_5_25, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_28 * 0.5, var_5_11 - var_5_23, 0), Color(255, 0, 0, 0))
		end

		if iter_5_1.curse then
			local var_5_29 = "curse: " .. iter_5_1.curse
			local var_5_30, var_5_31 = Gui.text_extents(var_5_9, var_5_29, var_5_0, var_5_2)
			local var_5_32 = var_5_31.x - var_5_30.x

			var_5_23 = var_5_23 + 10

			Gui.text(var_5_9, var_5_29, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_32 * 0.5, var_5_11 - var_5_23, 0), Color(255, 0, 0, 0))
		end

		if iter_5_1.minor_modifier_group then
			local var_5_33 = "modifiers: " .. table.concat(iter_5_1.minor_modifier_group, ", ")
			local var_5_34, var_5_35 = Gui.text_extents(var_5_9, var_5_33, var_5_0, var_5_2)
			local var_5_36 = var_5_35.x - var_5_34.x

			var_5_23 = var_5_23 + 10

			Gui.text(var_5_9, var_5_33, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_36 * 0.5, var_5_11 - var_5_23, 0), Color(255, 0, 0, 0))
		end

		if iter_5_1.terror_event_power_up then
			local var_5_37 = "power_up: " .. iter_5_1.terror_event_power_up .. "(" .. iter_5_1.terror_event_power_up_rarity .. ")"
			local var_5_38, var_5_39 = Gui.text_extents(var_5_9, var_5_37, var_5_0, var_5_2)
			local var_5_40 = var_5_39.x - var_5_38.x

			var_5_23 = var_5_23 + 10

			Gui.text(var_5_9, var_5_37, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_40 * 0.5, var_5_11 - var_5_23, 0), Color(255, 0, 0, 0))
		end

		local var_5_41 = iter_5_0 .. " (" .. math.floor(iter_5_1.run_progress * 100) / 100 .. ")"
		local var_5_42, var_5_43 = Gui.text_extents(var_5_9, var_5_41, var_5_0, var_5_2)
		local var_5_44 = var_5_43.x - var_5_42.x

		Gui.text(var_5_9, var_5_41, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_44 * 0.5, var_5_11 + 20, 0), Color(255, 0, 0, 0))

		local var_5_45 = "level_seed :" .. iter_5_1.level_seed
		local var_5_46, var_5_47 = Gui.text_extents(var_5_9, var_5_45, var_5_0, var_5_2)
		local var_5_48 = var_5_47.x - var_5_46.x
		local var_5_49 = var_5_23 + 10

		Gui.text(var_5_9, var_5_45, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_48 * 0.5, var_5_11 - var_5_49, 0), Color(255, 0, 0, 0))

		if iter_5_1.possible_arena_belakor_nodes then
			local var_5_50 = "arena_belakor_nodes: " .. table.concat(iter_5_1.possible_arena_belakor_nodes, ", ")
			local var_5_51, var_5_52 = Gui.text_extents(var_5_9, var_5_50, var_5_0, var_5_2)
			local var_5_53 = var_5_52.x - var_5_51.x
			local var_5_54 = var_5_49 + 10

			Gui.text(var_5_9, var_5_50, var_5_0, var_5_2, var_5_1, Vector3(var_5_10 - var_5_53 * 0.5, var_5_11 - var_5_54, 0), Color(255, 0, 0, 0))
		end
	end
end

DeusDebugMapUI._draw_edges = function (arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = Gui.resolution()
	local var_6_2 = var_6_0 * var_0_1
	local var_6_3 = var_6_1 * var_0_2
	local var_6_4 = var_6_0 * var_0_3
	local var_6_5 = var_6_1 * var_0_4

	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		local var_6_6 = var_6_2 + var_6_4 * arg_6_1[iter_6_0].layout_x
		local var_6_7 = var_6_3 + var_6_5 * arg_6_1[iter_6_0].layout_y

		for iter_6_2, iter_6_3 in ipairs(iter_6_1.next) do
			local var_6_8 = var_6_2 + var_6_4 * arg_6_1[iter_6_3].layout_x
			local var_6_9 = var_6_3 + var_6_5 * arg_6_1[iter_6_3].layout_y

			arg_6_0:_draw_edge(var_6_6, var_6_7, var_6_8, var_6_9)
		end
	end
end

DeusDebugMapUI._draw_edge = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_3 - arg_7_1
	local var_7_1 = arg_7_4 - arg_7_2

	if var_7_0 ~= 0 or var_7_1 ~= 0 then
		local var_7_2 = math.sqrt(var_7_0 * var_7_0 + var_7_1 * var_7_1)
		local var_7_3 = math.floor(var_7_2 / 10)
		local var_7_4 = var_7_0 / var_7_3
		local var_7_5 = var_7_1 / var_7_3
		local var_7_6 = arg_7_1
		local var_7_7 = arg_7_2

		for iter_7_0 = 1, var_7_3 do
			Gui.rect(arg_7_0._gui, Vector2(var_7_6, var_7_7), Vector2(2 + 5 * (iter_7_0 / var_7_3), 2 + 5 * (iter_7_0 / var_7_3)), Color(128, 0, 0, 0))

			var_7_6 = var_7_6 + var_7_4
			var_7_7 = var_7_7 + var_7_5
		end
	end
end
