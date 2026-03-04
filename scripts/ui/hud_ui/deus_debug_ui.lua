-- chunkname: @scripts/ui/hud_ui/deus_debug_ui.lua

DeusDebugUI = class(DeusDebugUI)

DeusDebugUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._world = arg_1_2.world_manager:world("level_world")
	arg_1_0._gui = World.create_screen_gui(arg_1_0._world, "immediate", "material", "materials/fonts/gw_fonts")
end

DeusDebugUI.destroy = function (arg_2_0)
	World.destroy_gui(arg_2_0._world, arg_2_0._gui)

	arg_2_0._gui = nil
end

DeusDebugUI.update = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_draw(arg_3_1, arg_3_2)
end

DeusDebugUI._draw = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_draw_left_side(arg_4_1, arg_4_2)
	arg_4_0:_draw_right_side(arg_4_1, arg_4_2)
end

DeusDebugUI._draw_right_side = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = "materials/fonts/arial"
	local var_5_1 = "arial"
	local var_5_2 = 12
	local var_5_3, var_5_4 = Gui.resolution()
	local var_5_5 = var_5_3 * 0.75
	local var_5_6 = var_5_4
	local var_5_7 = ""
	local var_5_8 = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if var_5_8 then
		var_5_7 = var_5_7 .. "Run seed: " .. var_5_8:get_run_seed()
	end

	if IS_WINDOWS and rawget(_G, "Steam") then
		var_5_7 = var_5_7 .. " User: " .. Steam.user_name()
	end

	if var_5_7 == "" then
		return
	end

	local var_5_9, var_5_10 = Gui.text_extents(arg_5_0._gui, var_5_7, var_5_0, var_5_2)
	local var_5_11 = var_5_10.x - var_5_9.x
	local var_5_12 = var_5_10.y
	local var_5_13 = 5
	local var_5_14 = var_5_5 - var_5_11 * 0.5 - var_5_13
	local var_5_15 = var_5_6 - var_5_12 - var_5_13
	local var_5_16 = var_5_11 + var_5_13 * 2
	local var_5_17 = var_5_12 + var_5_13 * 2
	local var_5_18 = var_5_14 - var_5_13
	local var_5_19 = var_5_15 - var_5_13

	Gui.rect(arg_5_0._gui, Vector2(var_5_18, var_5_19), Vector2(var_5_16, var_5_17), Color(128, 0, 0, 0))
	Gui.text(arg_5_0._gui, var_5_7, var_5_0, var_5_2, var_5_1, Vector3(var_5_14, var_5_15, 0), Color(255, 255, 255, 0))
end

DeusDebugUI._draw_left_side = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not var_6_0 then
		return
	end

	local var_6_1 = "materials/fonts/arial"
	local var_6_2 = "arial"
	local var_6_3 = 12
	local var_6_4, var_6_5 = Gui.resolution()
	local var_6_6 = var_6_4 * 0.25
	local var_6_7 = var_6_5
	local var_6_8 = "Level: " .. var_6_0:get_current_node().level
	local var_6_9, var_6_10 = Gui.text_extents(arg_6_0._gui, var_6_8, var_6_1, var_6_3)
	local var_6_11 = var_6_10.x - var_6_9.x
	local var_6_12 = var_6_10.y
	local var_6_13 = 5
	local var_6_14 = var_6_6 - var_6_11 * 0.5 - var_6_13
	local var_6_15 = var_6_7 - var_6_12 - var_6_13
	local var_6_16 = var_6_11 + var_6_13 * 2
	local var_6_17 = var_6_12 + var_6_13 * 2
	local var_6_18 = var_6_14 - var_6_13
	local var_6_19 = var_6_15 - var_6_13

	Gui.rect(arg_6_0._gui, Vector2(var_6_18, var_6_19), Vector2(var_6_16, var_6_17), Color(128, 0, 0, 0))
	Gui.text(arg_6_0._gui, var_6_8, var_6_1, var_6_3, var_6_2, Vector3(var_6_14, var_6_15, 0), Color(255, 255, 255, 0))
end
