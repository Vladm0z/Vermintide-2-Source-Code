-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_list.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_list_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowMutatorList = class(StartGameWindowMutatorList)
StartGameWindowMutatorList.NAME = "StartGameWindowMutatorList"

StartGameWindowMutatorList.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorList")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._active_mutator_widgets = {}
end

StartGameWindowMutatorList.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_3)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end

	var_2_1.play_button.content.button_hotspot.disable_button = true

	local var_2_4 = var_2_1.overlay_button
	local var_2_5 = arg_2_0:_animate_pulse(var_2_4.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(var_2_4, var_2_5)

	if arg_2_0:_has_deed_items() then
		var_2_4.content.button_hotspot.disable_button = false
	else
		var_2_4.content.button_hotspot.disable_button = true
	end
end

StartGameWindowMutatorList._has_deed_items = function (arg_3_0)
	local var_3_0 = Managers.backend:get_interface("items")
	local var_3_1 = "item_type == deed"
	local var_3_2 = var_3_0:get_filtered_items(var_3_1)

	return var_3_2 and #var_3_2 > 0
end

StartGameWindowMutatorList.on_exit = function (arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorList")

	arg_4_0.ui_animator = nil
end

StartGameWindowMutatorList.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:_update_selected_item_backend_id()
	arg_5_0:draw(arg_5_1)
end

StartGameWindowMutatorList.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	return
end

StartGameWindowMutatorList._update_animations = function (arg_7_0, arg_7_1)
	arg_7_0:_update_game_options_hover_effect()

	local var_7_0 = arg_7_0._ui_animations

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			var_7_0[iter_7_0] = nil
		end
	end

	arg_7_0.ui_animator:update(arg_7_1)
end

StartGameWindowMutatorList._is_button_pressed = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content.button_hotspot

	if var_8_0.on_release then
		var_8_0.on_release = false

		return true
	end
end

StartGameWindowMutatorList._is_button_hover_enter = function (arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.on_hover_enter
end

StartGameWindowMutatorList._is_button_hover_exit = function (arg_10_0, arg_10_1)
	return arg_10_1.content.button_hotspot.on_hover_exit
end

StartGameWindowMutatorList._handle_input = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._widgets_by_name

	if arg_11_0:_is_button_hover_enter(var_11_0.overlay_button) or arg_11_0:_is_button_hover_enter(var_11_0.play_button) then
		arg_11_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_11_0:_is_button_pressed(var_11_0.overlay_button) then
		arg_11_0.parent:set_layout_by_name("heroic_deed_selection")
	elseif arg_11_0:_is_button_pressed(var_11_0.play_button) and arg_11_0._selected_backend_id then
		arg_11_0.parent:play(arg_11_2, "deed")
	end
end

StartGameWindowMutatorList._update_selected_item_backend_id = function (arg_12_0)
	local var_12_0 = arg_12_0.parent:get_selected_heroic_deed_backend_id()

	if var_12_0 ~= arg_12_0._selected_backend_id then
		arg_12_0._selected_backend_id = var_12_0

		arg_12_0:_present_item_by_backend_id(var_12_0)
	end

	if arg_12_0._selected_backend_id then
		arg_12_0.parent:set_input_description("play_available")
	else
		arg_12_0.parent:set_input_description(nil)
	end
end

StartGameWindowMutatorList._present_item_by_backend_id = function (arg_13_0, arg_13_1)
	if not arg_13_1 then
		return
	end

	local var_13_0 = Managers.backend:get_interface("items"):get_item_from_id(arg_13_1)
	local var_13_1 = arg_13_0._widgets_by_name

	var_13_1.item_presentation.content.item = var_13_0
	var_13_1.play_button.content.button_hotspot.disable_button = false
	var_13_1.overlay_button.content.has_item = true
end

StartGameWindowMutatorList.draw = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_scenegraph
	local var_14_2 = arg_14_0.parent:window_input_service()

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, arg_14_0.render_settings)

	local var_14_3 = arg_14_0._widgets

	for iter_14_0 = 1, #var_14_3 do
		local var_14_4 = var_14_3[iter_14_0]

		UIRenderer.draw_widget(var_14_0, var_14_4)
	end

	UIRenderer.end_pass(var_14_0)
end

StartGameWindowMutatorList._play_sound = function (arg_15_0, arg_15_1)
	arg_15_0.parent:play_sound(arg_15_1)
end

StartGameWindowMutatorList._update_game_options_hover_effect = function (arg_16_0)
	local var_16_0 = arg_16_0._widgets_by_name.overlay_button

	if arg_16_0:_is_button_hover_enter(var_16_0) then
		arg_16_0:_on_option_button_hover_enter(var_16_0, 2)
	elseif arg_16_0:_is_button_hover_exit(var_16_0) then
		arg_16_0:_on_option_button_hover_exit(var_16_0, 2)
	end
end

StartGameWindowMutatorList._on_option_button_hover_enter = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0:_create_style_animation_enter(arg_17_1, 255, "glow", arg_17_2, arg_17_3)
	arg_17_0:_create_style_animation_exit(arg_17_1, 0, "button_hover_rect", arg_17_2, arg_17_3)
end

StartGameWindowMutatorList._on_option_button_hover_exit = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0:_create_style_animation_exit(arg_18_1, 0, "glow", arg_18_2, arg_18_3)
	arg_18_0:_create_style_animation_enter(arg_18_1, 30, "button_hover_rect", arg_18_2, arg_18_3)
end

StartGameWindowMutatorList._create_style_animation_enter = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = arg_19_1.style[arg_19_3]

	if not var_19_0 then
		return
	end

	local var_19_1 = var_19_0.color[1]
	local var_19_2 = arg_19_2
	local var_19_3 = 0.2
	local var_19_4 = (1 - var_19_1 / var_19_2) * var_19_3

	if var_19_4 > 0 and not arg_19_5 then
		arg_19_0._ui_animations[("game_option_" .. arg_19_3) .. "_hover_" .. arg_19_4] = arg_19_0:_animate_element_by_time(var_19_0.color, 1, var_19_1, var_19_2, var_19_4)
	else
		var_19_0.color[1] = var_19_2
	end
end

StartGameWindowMutatorList._create_style_animation_exit = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_1.style[arg_20_3]

	if not var_20_0 then
		return
	end

	local var_20_1 = var_20_0.color[1]
	local var_20_2 = arg_20_2
	local var_20_3 = 0.2
	local var_20_4 = var_20_1 / 255 * var_20_3

	if var_20_4 > 0 and not arg_20_5 then
		arg_20_0._ui_animations[("game_option_" .. arg_20_3) .. "_hover_" .. arg_20_4] = arg_20_0:_animate_element_by_time(var_20_0.color, 1, var_20_1, var_20_2, var_20_4)
	else
		var_20_0.color[1] = var_20_2
	end
end

StartGameWindowMutatorList._animate_pulse = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5))
end

StartGameWindowMutatorList._animate_element_by_time = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, math.ease_out_quad))
end
