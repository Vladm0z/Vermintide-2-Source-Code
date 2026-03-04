-- chunkname: @scripts/ui/views/twitch_view.lua

require("scripts/utils/keystroke_helper")

local var_0_0 = local_require("scripts/ui/views/twitch_view_definitions")

TwitchView = class(TwitchView)

function TwitchView.init(arg_1_0, arg_1_1)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._network_lobby = arg_1_1.network_lobby
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_server = arg_1_1.network_server

	local var_1_0 = arg_1_1.input_manager

	var_1_0:create_input_service("twitch_view", "TwitchControllerSettings", "TwitchControllerFilters")
	var_1_0:map_device_to_service("twitch_view", "keyboard")
	var_1_0:map_device_to_service("twitch_view", "mouse")
	var_1_0:map_device_to_service("twitch_view", "gamepad")

	arg_1_0._input_manager = var_1_0

	local var_1_1 = arg_1_1.world_manager:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_1)

	arg_1_0:_create_ui_elements()
end

function TwitchView._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._widgets = {}

	local var_2_0 = var_0_0.widget_definitions

	for iter_2_0, iter_2_1 in pairs(var_2_0.widgets) do
		arg_2_0._widgets[iter_2_0] = UIWidget.init(iter_2_1)
	end

	arg_2_0._connect_button_widget = UIWidget.init(var_0_0.widget_definitions.connect_button)

	local var_2_1 = arg_2_0._connect_button_widget.style.title_text

	var_2_1.text_color = Colors.get_color_table_with_alpha("twitch", 255)
	var_2_1.text_color_enabled = Colors.get_color_table_with_alpha("twitch", 255)
	arg_2_0._disconnect_button_widget = UIWidget.init(var_0_0.widget_definitions.disconnect_button)

	local var_2_2 = arg_2_0._disconnect_button_widget.style.title_text

	var_2_2.text_color = Colors.get_color_table_with_alpha("red", 255)
	var_2_2.text_color_enabled = Colors.get_color_table_with_alpha("red", 255)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._error_timer = nil
end

function TwitchView.on_enter(arg_3_0)
	ShowCursorStack.show("TwitchView")
	arg_3_0:set_active(true)
end

local var_0_1 = true

function TwitchView.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if var_0_1 then
		var_0_1 = false

		arg_4_0:_create_ui_elements()
	end

	if arg_4_0._suspended or not arg_4_0._active then
		return
	end

	arg_4_0:_draw(arg_4_1, arg_4_2)
	arg_4_0:_update_input(arg_4_1, arg_4_2)
	arg_4_0:_update_error(arg_4_1, arg_4_2)
end

function TwitchView.cb_on_message_received(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0._widgets.chat_output_widget.content
	local var_5_1 = var_5_0.message_tables
	local var_5_2 = {}

	var_5_2.is_dev = false
	var_5_2.is_system = false
	var_5_2.sender = string.format("%s: ", arg_5_3)
	var_5_2.message = arg_5_4
	var_5_1[#var_5_1 + 1] = var_5_2

	if #var_5_1 > 20 then
		table.remove(var_5_1, 1)
	else
		var_5_0.text_start_offset = var_5_0.text_start_offset + 1
	end
end

function TwitchView._play_sound(arg_6_0, arg_6_1)
	WwiseWorld.trigger_event(arg_6_0._wwise_world, arg_6_1)
end

function TwitchView._update_input(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._widgets.frame_widget.content
	local var_7_1 = arg_7_0._input_manager:get_service("twitch_view")

	if var_7_1:get("back", true) then
		if var_7_0.text_field_active then
			var_7_0.text_field_active = false
		else
			arg_7_0:set_active(false)

			return
		end
	end

	local var_7_2 = Managers.twitch:is_connecting()
	local var_7_3 = Managers.twitch:is_connected()

	if var_7_2 then
		arg_7_0._connect_button_widget.content.button_hotspot.on_pressed = false
		arg_7_0._disconnect_button_widget.content.button_hotspot.on_pressed = false
	else
		local var_7_4 = var_7_0.text_input_hotspot
		local var_7_5 = var_7_0.screen_hotspot
		local var_7_6 = var_7_0.frame_hotspot

		if var_7_4.on_pressed and not var_7_3 then
			var_7_0.text_field_active = true
		elseif var_7_5.on_pressed or var_7_3 then
			if var_7_5.on_pressed and not var_7_0.text_field_active and not var_7_6.on_pressed then
				arg_7_0:set_active(false)

				return
			end

			var_7_0.text_field_active = false
		end

		if var_7_0.text_field_active then
			local var_7_7 = Keyboard.keystrokes()

			var_7_0.twitch_name, var_7_0.caret_index = KeystrokeHelper.parse_strokes(var_7_0.twitch_name, var_7_0.caret_index, "insert", var_7_7)

			if var_7_1:get("execute_login") then
				var_7_0.text_field_active = false

				local var_7_8 = string.gsub(var_7_0.twitch_name, " ", "")

				Managers.twitch:connect(var_7_8, callback(arg_7_0, "cb_connection_callback"))
			end
		end

		if arg_7_0._widgets.exit_button.content.button_hotspot.on_pressed then
			arg_7_0:set_active(false)

			return
		end

		if arg_7_0._connect_button_widget.content.button_hotspot.on_pressed and not var_7_3 then
			local var_7_9 = string.gsub(var_7_0.twitch_name, " ", "")

			Managers.twitch:connect(var_7_9, callback(arg_7_0, "cb_connection_callback"))
		end

		if arg_7_0._disconnect_button_widget.content.button_hotspot.on_pressed and var_7_3 then
			Managers.twitch:disconnect()

			local var_7_10 = arg_7_0._widgets.chat_output_widget.content

			var_7_10.message_tables = {}
			var_7_10.text_start_offset = 0
		end
	end
end

function TwitchView._update_error(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0._error_timer then
		return
	end

	local var_8_0 = arg_8_0._widgets.frame_widget.style

	arg_8_0._error_timer = arg_8_0._error_timer - arg_8_1

	local var_8_1 = math.lerp(0, 255, math.min(arg_8_0._error_timer, 1))

	var_8_0.error_field.text_color[1] = var_8_1

	if arg_8_0._error_timer <= 0 then
		var_8_0.error_field.text_color[1] = 0
		arg_8_0._error_timer = nil
	end
end

function TwitchView.cb_connection_callback(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._widgets.frame_widget.content
	local var_9_1 = arg_9_0._widgets.frame_widget.style

	var_9_0.error_id = arg_9_1
	var_9_1.error_field.text_color[1] = 255
	arg_9_0._error_timer = 5
end

function TwitchView.set_active(arg_10_0, arg_10_1)
	arg_10_0._active = arg_10_1

	if arg_10_0._active then
		arg_10_0._input_manager:block_device_except_service("twitch_view", "keyboard", 1, "twitch")
		arg_10_0._input_manager:block_device_except_service("twitch_view", "mouse", 1, "twitch")
		arg_10_0._input_manager:block_device_except_service("twitch_view", "gamepad", 1, "twitch")
		Managers.irc:register_message_callback("twitch", Irc.CHANNEL_MSG, callback(arg_10_0, "cb_on_message_received"))
	else
		arg_10_0._input_manager:device_unblock_all_services("keyboard", 1)
		arg_10_0._input_manager:device_unblock_all_services("mouse", 1)
		arg_10_0._input_manager:device_unblock_all_services("gamepad", 1)
		arg_10_0._input_manager:block_device_except_service("start_game_view", "keyboard", 1, "start_game_view")
		arg_10_0._input_manager:block_device_except_service("start_game_view", "mouse", 1, "start_game_view")
		arg_10_0._input_manager:block_device_except_service("start_game_view", "gamepad", 1, "start_game_view")
		Managers.irc:unregister_message_callback("twitch")
	end
end

function TwitchView.is_active(arg_11_0)
	return arg_11_0._active
end

function TwitchView.suspend(arg_12_0)
	arg_12_0._suspended = true

	arg_12_0._input_manager:device_unblock_all_services("keyboard", 1)
	arg_12_0._input_manager:device_unblock_all_services("mouse", 1)
	arg_12_0._input_manager:device_unblock_all_services("gamepad", 1)
end

function TwitchView.unsuspend(arg_13_0)
	arg_13_0._input_manager:block_device_except_service("twitch_view", "keyboard", 1, "twitch")
	arg_13_0._input_manager:block_device_except_service("twitch_view", "mouse", 1, "twitch")
	arg_13_0._input_manager:block_device_except_service("twitch_view", "gamepad", 1, "twitch")

	arg_13_0._suspended = nil
end

function TwitchView._draw(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._ui_renderer
	local var_14_1 = arg_14_0._ui_scenegraph
	local var_14_2 = arg_14_0._input_manager:get_service("twitch_view")
	local var_14_3 = arg_14_0._render_settings
	local var_14_4 = Managers.twitch:is_connected()
	local var_14_5 = Managers.twitch:is_connecting()

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, var_14_3)

	for iter_14_0, iter_14_1 in pairs(arg_14_0._widgets) do
		UIRenderer.draw_widget(var_14_0, iter_14_1)
	end

	if not var_14_5 then
		if var_14_4 then
			UIRenderer.draw_widget(var_14_0, arg_14_0._disconnect_button_widget)
		else
			UIRenderer.draw_widget(var_14_0, arg_14_0._connect_button_widget)
		end
	end

	UIRenderer.end_pass(var_14_0)
end

function TwitchView.on_exit(arg_15_0)
	ShowCursorStack.hide("TwitchView")
	arg_15_0:set_active(false)
end

function TwitchView.destroy(arg_16_0)
	return
end

function TwitchView._exit(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1 and "exit_menu" or "ingame_menu"

	arg_17_0._ingame_ui:handle_transition(var_17_0)
end

function TwitchView.input_service(arg_18_0)
	return arg_18_0._input_manager:get_service("twitch_view")
end
