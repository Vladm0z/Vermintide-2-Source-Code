-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_select_weave.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_select_weave_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowWeaveSelectWeave = class(StartGameWindowWeaveSelectWeave)
StartGameWindowWeaveSelectWeave.NAME = "StartGameWindowWeaveSelectWeave"

StartGameWindowWeaveSelectWeave.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveSelectWeave")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0._player_manager = var_1_1
	arg_1_0._peer_id = var_1_0.peer_id

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
end

StartGameWindowWeaveSelectWeave._create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_2_0._ui_scenegraph = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_3
		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._ui_animations = {}
	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_3)

	local var_2_4 = var_2_2.overlay_button
	local var_2_5 = arg_2_0:_animate_pulse(var_2_4.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(var_2_4, var_2_5)

	if arg_2_2 then
		local var_2_6 = var_2_0.window.local_position

		var_2_6[1] = var_2_6[1] + arg_2_2[1]
		var_2_6[2] = var_2_6[2] + arg_2_2[2]
		var_2_6[3] = var_2_6[3] + arg_2_2[3]
	end
end

StartGameWindowWeaveSelectWeave.on_exit = function (arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveSelectWeave")

	arg_3_0._ui_animator = nil
end

StartGameWindowWeaveSelectWeave._is_button_hover_enter = function (arg_4_0, arg_4_1)
	return arg_4_1.content.button_hotspot.on_hover_enter
end

StartGameWindowWeaveSelectWeave._is_button_hover_exit = function (arg_5_0, arg_5_1)
	return arg_5_1.content.button_hotspot.on_hover_exit
end

StartGameWindowWeaveSelectWeave._update_game_options_hover_effect = function (arg_6_0)
	local var_6_0 = arg_6_0._widgets_by_name.overlay_button

	if arg_6_0:_is_button_hover_enter(var_6_0) then
		arg_6_0:_on_option_button_hover_enter(var_6_0, 2)
	elseif arg_6_0:_is_button_hover_exit(var_6_0) then
		arg_6_0:_on_option_button_hover_exit(var_6_0, 2)
	end
end

StartGameWindowWeaveSelectWeave._on_option_button_hover_enter = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:_create_style_animation_enter(arg_7_1, 255, "glow", arg_7_2, arg_7_3)
	arg_7_0:_create_style_animation_exit(arg_7_1, 0, "button_hover_rect", arg_7_2, arg_7_3)
end

StartGameWindowWeaveSelectWeave._on_option_button_hover_exit = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:_create_style_animation_exit(arg_8_1, 0, "glow", arg_8_2, arg_8_3)
	arg_8_0:_create_style_animation_enter(arg_8_1, 30, "button_hover_rect", arg_8_2, arg_8_3)
end

StartGameWindowWeaveSelectWeave._create_style_animation_enter = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_1.style[arg_9_3]

	if not var_9_0 then
		return
	end

	local var_9_1 = var_9_0.color[1]
	local var_9_2 = arg_9_2
	local var_9_3 = 0.2
	local var_9_4 = (1 - var_9_1 / var_9_2) * var_9_3

	if var_9_4 > 0 and not arg_9_5 then
		arg_9_0._ui_animations[("game_option_" .. arg_9_3) .. "_hover_" .. arg_9_4] = arg_9_0:_animate_element_by_time(var_9_0.color, 1, var_9_1, var_9_2, var_9_4)
	else
		var_9_0.color[1] = var_9_2
	end
end

StartGameWindowWeaveSelectWeave._animate_pulse = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5))
end

StartGameWindowWeaveSelectWeave._animate_element_by_time = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, math.ease_out_quad))
end

StartGameWindowWeaveSelectWeave._create_style_animation_exit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_1.style[arg_12_3]

	if not var_12_0 then
		return
	end

	local var_12_1 = var_12_0.color[1]
	local var_12_2 = arg_12_2
	local var_12_3 = 0.2
	local var_12_4 = var_12_1 / 255 * var_12_3

	if var_12_4 > 0 and not arg_12_5 then
		arg_12_0._ui_animations[("game_option_" .. arg_12_3) .. "_hover_" .. arg_12_4] = arg_12_0:_animate_element_by_time(var_12_0.color, 1, var_12_1, var_12_2, var_12_4)
	else
		var_12_0.color[1] = var_12_2
	end
end

StartGameWindowWeaveSelectWeave._play_sound = function (arg_13_0, arg_13_1)
	arg_13_0._parent:play_sound(arg_13_1)
end

StartGameWindowWeaveSelectWeave.update = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0:_update_animations(arg_14_1, arg_14_2)
	arg_14_0:_update_input(arg_14_1, arg_14_2)
	arg_14_0:_draw(arg_14_1)
end

StartGameWindowWeaveSelectWeave._update_animations = function (arg_15_0, arg_15_1)
	arg_15_0:_update_game_options_hover_effect()

	local var_15_0 = arg_15_0._ui_animations or {}

	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		UIAnimation.update(iter_15_1, arg_15_1)

		if UIAnimation.completed(iter_15_1) then
			var_15_0[iter_15_0] = nil
		end
	end

	arg_15_0._ui_animator:update(arg_15_1)
end

StartGameWindowWeaveSelectWeave._update_input = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._widgets_by_name.overlay_button
	local var_16_1 = var_16_0.content.button_hotspot

	if arg_16_0:_is_button_hover_enter(var_16_0) then
		arg_16_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if var_16_1.on_pressed then
		arg_16_0._parent:set_layout_by_name("weave_selection")
	end
end

StartGameWindowWeaveSelectWeave.post_update = function (arg_17_0, arg_17_1, arg_17_2)
	return
end

StartGameWindowWeaveSelectWeave._draw = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._ui_renderer
	local var_18_1 = arg_18_0._ui_scenegraph
	local var_18_2 = arg_18_0._parent:window_input_service()

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1, nil, arg_18_0._render_settings)

	local var_18_3 = arg_18_0._widgets

	for iter_18_0 = 1, #var_18_3 do
		local var_18_4 = var_18_3[iter_18_0]

		UIRenderer.draw_widget(var_18_0, var_18_4)
	end

	UIRenderer.end_pass(var_18_0)
end
