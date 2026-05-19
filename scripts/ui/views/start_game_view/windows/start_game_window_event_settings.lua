-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_settings_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowEventSettings = class(StartGameWindowEventSettings)
StartGameWindowEventSettings.NAME = "StartGameWindowEventSettings"

function StartGameWindowEventSettings.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowEventSettings")

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
	arg_1_0._enable_play = false
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_update_difficulty_option()
end

function StartGameWindowEventSettings.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_3
		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_3)

	if arg_2_2 then
		local var_2_4 = var_2_0.window.local_position

		var_2_4[1] = var_2_4[1] + arg_2_2[1]
		var_2_4[2] = var_2_4[2] + arg_2_2[2]
		var_2_4[3] = var_2_4[3] + arg_2_2[3]
	end

	var_2_2.play_button.content.button_hotspot.disable_button = true

	local var_2_5 = var_2_2.game_option_difficulty
	local var_2_6 = arg_2_0:_animate_pulse(var_2_5.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(var_2_5, var_2_6)
	arg_2_0:_setup_content_from_backend()
end

function StartGameWindowEventSettings._setup_content_from_backend(arg_3_0)
	local var_3_0 = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local var_3_1 = arg_3_0._widgets_by_name.event_summary
	local var_3_2 = var_3_0.mutators
	local var_3_3 = var_3_0.level_key

	var_3_1.content.item = {
		level_key = var_3_3,
		mutators = var_3_2
	}
end

function StartGameWindowEventSettings.on_exit(arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowEventSettings")

	arg_4_0.ui_animator = nil
end

function StartGameWindowEventSettings.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_difficulty_option()
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:draw(arg_5_1)
end

function StartGameWindowEventSettings.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function StartGameWindowEventSettings._update_animations(arg_7_0, arg_7_1)
	arg_7_0:_update_game_options_hover_effect()

	local var_7_0 = arg_7_0._ui_animations

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			var_7_0[iter_7_0] = nil
		end
	end

	local var_7_1 = arg_7_0.ui_animator

	var_7_1:update(arg_7_1)

	local var_7_2 = arg_7_0._animations

	for iter_7_2, iter_7_3 in pairs(var_7_2) do
		if var_7_1:is_animation_completed(iter_7_3) then
			var_7_1:stop_animation(iter_7_3)

			var_7_2[iter_7_2] = nil
		end
	end
end

function StartGameWindowEventSettings._is_button_released(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content.button_hotspot

	if var_8_0.on_release then
		var_8_0.on_release = false

		return true
	end
end

function StartGameWindowEventSettings._is_button_hover_enter(arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowEventSettings._is_button_hover_exit(arg_10_0, arg_10_1)
	return arg_10_1.content.button_hotspot.on_hover_exit
end

function StartGameWindowEventSettings._handle_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._widgets_by_name

	if arg_11_0:_is_button_hover_enter(var_11_0.game_option_difficulty) or arg_11_0:_is_button_hover_enter(var_11_0.play_button) then
		arg_11_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	local var_11_1 = arg_11_0.parent

	if arg_11_0:_is_button_released(var_11_0.game_option_difficulty) then
		var_11_1:set_layout_by_name("difficulty_selection_event")
	end

	local var_11_2 = arg_11_0.parent:window_input_service()
	local var_11_3 = Managers.input:is_device_active("gamepad") and arg_11_0._enable_play and var_11_2:get("refresh_press")

	if arg_11_0:_is_button_released(var_11_0.play_button) or var_11_3 then
		var_11_1:play(arg_11_2, "event")
	end
end

function StartGameWindowEventSettings._play_sound(arg_12_0, arg_12_1)
	arg_12_0.parent:play_sound(arg_12_1)
end

function StartGameWindowEventSettings._update_difficulty_option(arg_13_0)
	local var_13_0 = arg_13_0.parent:get_difficulty_option()

	if var_13_0 ~= arg_13_0._difficulty_key then
		arg_13_0:_set_difficulty_option(var_13_0)

		arg_13_0._difficulty_key = var_13_0
		arg_13_0._enable_play = DifficultySettings[var_13_0] ~= nil
		arg_13_0._widgets_by_name.play_button.content.button_hotspot.disable_button = not arg_13_0._enable_play

		if arg_13_0._enable_play then
			arg_13_0.parent:set_input_description("play_available")
		else
			arg_13_0.parent:set_input_description(nil)
		end
	end
end

function StartGameWindowEventSettings._set_difficulty_option(arg_14_0, arg_14_1)
	local var_14_0 = DifficultySettings[arg_14_1]
	local var_14_1 = var_14_0 and var_14_0.display_name
	local var_14_2 = var_14_0 and var_14_0.display_image
	local var_14_3 = var_14_0 and var_14_0.completed_frame_texture or "map_frame_00"
	local var_14_4 = arg_14_0._widgets_by_name

	var_14_4.game_option_difficulty.content.option_text = var_14_1 and Localize(var_14_1) or ""
	var_14_4.game_option_difficulty.content.icon = var_14_2 or nil
	var_14_4.game_option_difficulty.content.icon_frame = var_14_3
end

function StartGameWindowEventSettings.draw(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.ui_renderer
	local var_15_1 = arg_15_0.ui_scenegraph
	local var_15_2 = arg_15_0.parent:window_input_service()

	UIRenderer.begin_pass(var_15_0, var_15_1, var_15_2, arg_15_1, nil, arg_15_0.render_settings)

	local var_15_3 = arg_15_0._widgets

	for iter_15_0 = 1, #var_15_3 do
		local var_15_4 = var_15_3[iter_15_0]

		UIRenderer.draw_widget(var_15_0, var_15_4)
	end

	UIRenderer.end_pass(var_15_0)
end

function StartGameWindowEventSettings._play_sound(arg_16_0, arg_16_1)
	arg_16_0.parent:play_sound(arg_16_1)
end

function StartGameWindowEventSettings._update_game_options_hover_effect(arg_17_0)
	local var_17_0 = arg_17_0._widgets_by_name.game_option_difficulty

	if arg_17_0:_is_button_hover_enter(var_17_0) then
		arg_17_0:_on_option_button_hover_enter(var_17_0, 1)
	elseif arg_17_0:_is_button_hover_exit(var_17_0) then
		arg_17_0:_on_option_button_hover_exit(var_17_0, 1)
	end
end

function StartGameWindowEventSettings._on_option_button_hover_enter(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0:_create_style_animation_enter(arg_18_1, 255, "glow", arg_18_2, arg_18_3)
	arg_18_0:_create_style_animation_enter(arg_18_1, 255, "icon_glow", arg_18_2, arg_18_3)
	arg_18_0:_create_style_animation_exit(arg_18_1, 0, "button_hover_rect", arg_18_2, arg_18_3)
end

function StartGameWindowEventSettings._on_option_button_hover_exit(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0:_create_style_animation_exit(arg_19_1, 0, "glow", arg_19_2, arg_19_3)
	arg_19_0:_create_style_animation_exit(arg_19_1, 0, "icon_glow", arg_19_2, arg_19_3)
	arg_19_0:_create_style_animation_enter(arg_19_1, 30, "button_hover_rect", arg_19_2, arg_19_3)
end

function StartGameWindowEventSettings._create_style_animation_enter(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_1.style[arg_20_3]

	if not var_20_0 then
		return
	end

	local var_20_1 = var_20_0.color[1]
	local var_20_2 = arg_20_2
	local var_20_3 = 0.2
	local var_20_4 = (1 - var_20_1 / var_20_2) * var_20_3

	if var_20_4 > 0 and not arg_20_5 then
		arg_20_0._ui_animations[("game_option_" .. arg_20_3) .. "_hover_" .. arg_20_4] = arg_20_0:_animate_element_by_time(var_20_0.color, 1, var_20_1, var_20_2, var_20_4)
	else
		var_20_0.color[1] = var_20_2
	end
end

function StartGameWindowEventSettings._create_style_animation_exit(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local var_21_0 = arg_21_1.style[arg_21_3]

	if not var_21_0 then
		return
	end

	local var_21_1 = var_21_0.color[1]
	local var_21_2 = arg_21_2
	local var_21_3 = 0.2
	local var_21_4 = var_21_1 / 255 * var_21_3

	if var_21_4 > 0 and not arg_21_5 then
		arg_21_0._ui_animations[("game_option_" .. arg_21_3) .. "_hover_" .. arg_21_4] = arg_21_0:_animate_element_by_time(var_21_0.color, 1, var_21_1, var_21_2, var_21_4)
	else
		var_21_0.color[1] = var_21_2
	end
end

function StartGameWindowEventSettings._animate_pulse(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5))
end

function StartGameWindowEventSettings._animate_element_by_time(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, math.ease_out_quad))
end
