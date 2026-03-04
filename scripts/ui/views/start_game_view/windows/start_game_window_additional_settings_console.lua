-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_additional_settings_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_additional_settings_console_definitions")

StartGameWindowAdditionalSettingsConsole = class(StartGameWindowAdditionalSettingsConsole)
StartGameWindowAdditionalSettingsConsole.NAME = "StartGameWindowAdditionalSettingsConsole"

StartGameWindowAdditionalSettingsConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	print("[StartGameWindow] Enter Substate StartGameWindowAdditionalSettingsConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = var_1_0.network_lobby
	arg_1_0._mechanism_name = arg_1_1.mechanism_name
	arg_1_0._params = arg_1_1
	arg_1_0._parent_window_name = arg_1_3

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(var_0_0, arg_1_1, arg_1_2)
	arg_1_0:_update_additional_options()

	arg_1_0._input_index = 0

	arg_1_0:_handle_input_index(1)

	arg_1_0._is_focused = false
	arg_1_0._versus_custom_lobby_view_active = arg_1_1.versus_custom_lobby_view_active
end

StartGameWindowAdditionalSettingsConsole._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, arg_2_0._scenegraph_definition, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

StartGameWindowAdditionalSettingsConsole.create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0._widget_definitions = arg_3_1.widgets
	arg_3_0._scenegraph_definition = arg_3_1.scenegraph_definition
	arg_3_0._animation_definitions = arg_3_1.animation_definitions
	arg_3_0._gamepad_widget_navigation = arg_3_1.gamepad_widget_navigation

	local var_3_0 = UISceneGraph.init_scenegraph(arg_3_0._scenegraph_definition)

	arg_3_0.ui_scenegraph = var_3_0
	arg_3_0._widgets, arg_3_0._widgets_by_name = UIUtils.create_widgets(arg_3_0._widget_definitions)

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(var_3_0, arg_3_0._animation_definitions)

	if arg_3_3 then
		local var_3_1 = var_3_0.window.local_position

		var_3_1[1] = var_3_1[1] + arg_3_3[1]
		var_3_1[2] = var_3_1[2] + arg_3_3[2]
		var_3_1[3] = var_3_1[3] + arg_3_3[3]
	end

	arg_3_0:_set_additional_options_enabled_state(true)
end

StartGameWindowAdditionalSettingsConsole._set_additional_options_enabled_state = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._widgets_by_name

	var_4_0.private_button.content.button_hotspot.disable_button = not arg_4_1
	var_4_0.host_button.content.button_hotspot.disable_button = not arg_4_1
	var_4_0.strict_matchmaking_button.content.button_hotspot.disable_button = not arg_4_1
	arg_4_0._additional_option_enabled = arg_4_1
end

StartGameWindowAdditionalSettingsConsole.on_exit = function (arg_5_0, arg_5_1)
	print("[StartGameWindow] Exit Substate StartGameWindowAdditionalSettingsConsole")

	arg_5_0.ui_animator = nil

	Managers.state.event:unregister("versus_custom_lobby_state_changed", arg_5_0)
end

StartGameWindowAdditionalSettingsConsole.set_focus = function (arg_6_0, arg_6_1)
	arg_6_0._is_focused = arg_6_1

	if arg_6_1 then
		arg_6_0:_start_transition_animation("on_enter")
	else
		arg_6_0.render_settings.alpha_multiplier = 0
	end
end

StartGameWindowAdditionalSettingsConsole.update = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._mechanism_name == "versus" and Managers.matchmaking:is_matchmaking_versus() then
		return
	end

	if arg_7_0._additional_option_enabled then
		arg_7_0:_update_additional_options()
	end

	arg_7_0:_update_animations(arg_7_1)

	if arg_7_0._is_focused or not arg_7_0.gamepad_active_last_frame then
		arg_7_0:_handle_input(arg_7_1, arg_7_2)
	end

	arg_7_0:_handle_gamepad_activity()
	arg_7_0:draw(arg_7_1)
end

StartGameWindowAdditionalSettingsConsole.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	return
end

StartGameWindowAdditionalSettingsConsole._update_animations = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.ui_animator

	var_9_0:update(arg_9_1)

	local var_9_1 = arg_9_0._animations

	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		if var_9_0:is_animation_completed(iter_9_1) then
			var_9_0:stop_animation(iter_9_1)

			var_9_1[iter_9_0] = nil
		end
	end
end

StartGameWindowAdditionalSettingsConsole._is_button_released = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

StartGameWindowAdditionalSettingsConsole._is_button_hover_enter = function (arg_11_0, arg_11_1)
	return arg_11_1.content.button_hotspot.on_hover_enter
end

StartGameWindowAdditionalSettingsConsole._is_button_hover = function (arg_12_0, arg_12_1)
	return arg_12_1.content.button_hotspot.is_hover
end

StartGameWindowAdditionalSettingsConsole._is_button_hover_exit = function (arg_13_0, arg_13_1)
	return arg_13_1.content.button_hotspot.on_hover_exit
end

StartGameWindowAdditionalSettingsConsole._is_other_option_button_selected = function (arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0:_is_button_released(arg_14_1) then
		local var_14_0 = not arg_14_2

		if var_14_0 then
			arg_14_0:_play_sound("play_gui_lobby_button_03_private")
		else
			arg_14_0:_play_sound("play_gui_lobby_button_03_public")
		end

		return var_14_0
	end

	return nil
end

StartGameWindowAdditionalSettingsConsole._handle_input_index = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._input_index
	local var_15_1 = arg_15_0._widgets_by_name

	repeat
		var_15_0 = var_15_0 + arg_15_1

		local var_15_2 = arg_15_0._gamepad_widget_navigation[var_15_0]

		if not var_15_2 then
			var_15_0 = arg_15_0._input_index
		elseif not var_15_1[var_15_2].content.button_hotspot.disable_button then
			arg_15_0._input_index = var_15_0
		end
	until arg_15_0._input_index == var_15_0
end

StartGameWindowAdditionalSettingsConsole._handle_gamepad_input = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0

	if arg_16_3:get("move_down") then
		var_16_0 = 1
	elseif arg_16_3:get("move_up") then
		var_16_0 = -1
	end

	if var_16_0 then
		arg_16_0:_handle_input_index(var_16_0)
	end

	local var_16_1 = arg_16_0._input_index
	local var_16_2 = arg_16_0._widgets_by_name
	local var_16_3 = var_16_2.option_tooltip
	local var_16_4 = false

	if arg_16_3:get("confirm") then
		var_16_4 = true
	end

	local var_16_5 = arg_16_0._gamepad_widget_navigation
	local var_16_6 = #var_16_5

	for iter_16_0 = 1, var_16_6 do
		local var_16_7 = var_16_2[var_16_5[iter_16_0]]
		local var_16_8 = var_16_7.content.button_hotspot
		local var_16_9 = iter_16_0 == var_16_1

		var_16_8.is_hover = var_16_9

		if var_16_9 then
			var_16_3.content.text = var_16_7.content.tooltip_info.description

			if var_16_4 then
				var_16_8.on_release = true
			end
		end
	end
end

StartGameWindowAdditionalSettingsConsole._handle_mouse_input = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0._widgets_by_name
	local var_17_1 = var_17_0.option_tooltip
	local var_17_2 = false
	local var_17_3 = arg_17_0._gamepad_widget_navigation
	local var_17_4 = #var_17_3

	for iter_17_0 = 1, var_17_4 do
		local var_17_5 = var_17_0[var_17_3[iter_17_0]]

		if arg_17_0:_is_button_hover_enter(var_17_5) then
			var_17_1.content.text = var_17_5.content.tooltip_info.description
		end

		if arg_17_0:_is_button_hover(var_17_5) then
			var_17_2 = true
		end
	end

	if not var_17_2 then
		var_17_1.content.text = ""
	end
end

StartGameWindowAdditionalSettingsConsole._handle_input = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.parent
	local var_18_1 = var_18_0:window_input_service()

	if arg_18_0._additional_option_enabled then
		if Managers.input:is_device_active("gamepad") then
			arg_18_0:_handle_gamepad_input(arg_18_1, arg_18_2, var_18_1)
		else
			arg_18_0:_handle_mouse_input(arg_18_1, arg_18_2, var_18_1)
		end

		local var_18_2 = arg_18_0._widgets_by_name
		local var_18_3 = var_18_2.host_button
		local var_18_4 = var_18_2.private_button
		local var_18_5 = var_18_2.strict_matchmaking_button

		UIWidgetUtils.animate_default_checkbox_button_console(var_18_4, arg_18_1)
		UIWidgetUtils.animate_default_checkbox_button_console(var_18_3, arg_18_1)
		UIWidgetUtils.animate_default_checkbox_button_console(var_18_5, arg_18_1)

		if arg_18_0:_is_button_hover_enter(var_18_4) or arg_18_0:_is_button_hover_enter(var_18_3) or arg_18_0:_is_button_hover_enter(var_18_5) then
			arg_18_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local var_18_6 = arg_18_0:_is_other_option_button_selected(var_18_4, arg_18_0._private_enabled)

		if var_18_6 ~= nil then
			var_18_0:set_private_option_enabled(var_18_6)
		end

		local var_18_7 = arg_18_0:_is_other_option_button_selected(var_18_3, arg_18_0._always_host_enabled)

		if var_18_7 ~= nil then
			var_18_0:set_always_host_option_enabled(var_18_7)
		end

		local var_18_8 = arg_18_0:_is_other_option_button_selected(var_18_5, arg_18_0._strict_matchmaking_enabled)

		if var_18_8 ~= nil then
			var_18_0:set_strict_matchmaking_option_enabled(var_18_8)
		end
	end

	if arg_18_0.gamepad_active_last_frame then
		local var_18_9 = true

		if var_18_1:get("back_menu", var_18_9) or var_18_1:get("refresh", var_18_9) or var_18_1:get("right_stick_press", var_18_9) then
			var_18_0:set_window_input_focus(arg_18_0._parent_window_name or "custom_game_overview")
		end
	end
end

StartGameWindowAdditionalSettingsConsole._play_sound = function (arg_19_0, arg_19_1)
	arg_19_0.parent:play_sound(arg_19_1)
end

StartGameWindowAdditionalSettingsConsole._update_additional_options = function (arg_20_0)
	local var_20_0 = arg_20_0.parent
	local var_20_1 = var_20_0:is_private_option_enabled()
	local var_20_2 = var_20_0:is_always_host_option_enabled()
	local var_20_3 = var_20_0:is_strict_matchmaking_option_enabled()
	local var_20_4 = Managers.twitch and Managers.twitch:is_connected()
	local var_20_5 = arg_20_0._network_lobby:members():get_member_count() == 1

	if var_20_5 ~= arg_20_0._is_alone or var_20_1 ~= arg_20_0._private_enabled or var_20_2 ~= arg_20_0._always_host_enabled or var_20_3 ~= arg_20_0._strict_matchmaking_enabled or var_20_4 ~= arg_20_0._twitch_active then
		local var_20_6 = arg_20_0._widgets_by_name
		local var_20_7

		var_20_7.is_selected, var_20_7.disable_button, var_20_7 = var_20_1, var_20_4, var_20_6.private_button.content.button_hotspot

		local var_20_8

		var_20_8.is_selected, var_20_8.disable_button, var_20_8 = var_20_1 or not var_20_5 or var_20_2, var_20_1 or not var_20_5 or var_20_4, var_20_6.host_button.content.button_hotspot

		local var_20_9

		var_20_9.is_selected, var_20_9.disable_button, var_20_9 = not var_20_2 and not var_20_1 and var_20_5 and var_20_3, var_20_1 or var_20_2 or not var_20_5 or var_20_4, var_20_6.strict_matchmaking_button.content.button_hotspot
		arg_20_0._private_enabled = var_20_1
		arg_20_0._always_host_enabled = var_20_2
		arg_20_0._strict_matchmaking_enabled = var_20_3
		arg_20_0._twitch_active = var_20_4
		arg_20_0._is_alone = var_20_5
	end
end

StartGameWindowAdditionalSettingsConsole.draw = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._ui_top_renderer
	local var_21_1 = arg_21_0.ui_scenegraph
	local var_21_2 = arg_21_0.parent:window_input_service()

	UIRenderer.begin_pass(var_21_0, var_21_1, var_21_2, arg_21_1, nil, arg_21_0.render_settings)

	local var_21_3 = arg_21_0._widgets

	for iter_21_0 = 1, #var_21_3 do
		local var_21_4 = var_21_3[iter_21_0]

		UIRenderer.draw_widget(var_21_0, var_21_4)
	end

	UIRenderer.end_pass(var_21_0)
end

StartGameWindowAdditionalSettingsConsole._handle_gamepad_activity = function (arg_22_0)
	local var_22_0 = arg_22_0.gamepad_active_last_frame == nil

	if Managers.input:is_device_active("gamepad") then
		if not arg_22_0.gamepad_active_last_frame or var_22_0 then
			arg_22_0.gamepad_active_last_frame = true
			arg_22_0.render_settings.alpha_multiplier = 0
		end
	elseif arg_22_0.gamepad_active_last_frame or var_22_0 then
		arg_22_0.gamepad_active_last_frame = false

		if arg_22_0._is_focused then
			arg_22_0.parent:set_window_input_focus(arg_22_0._parent_window_name or "custom_game_overview")
		end

		arg_22_0.render_settings.alpha_multiplier = 1
	end
end
