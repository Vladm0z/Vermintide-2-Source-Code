-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_twitch_login.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_login_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition

StartGameWindowTwitchLogin = class(StartGameWindowTwitchLogin)
StartGameWindowTwitchLogin.NAME = "StartGameWindowTwitchLogin"

function StartGameWindowTwitchLogin.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowTwitchLogin")

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

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:set_active(true)
	arg_1_0:_set_disconnect_button_text()
end

function StartGameWindowTwitchLogin.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
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

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end
end

function StartGameWindowTwitchLogin.on_exit(arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowTwitchLogin")
	arg_3_0:set_active(false)
end

function StartGameWindowTwitchLogin.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_popup()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:_update_game_options(arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

function StartGameWindowTwitchLogin.set_active(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._active = arg_5_1

	if IS_WINDOWS then
		if arg_5_1 then
			Managers.irc:register_message_callback("twitch", Irc.CHANNEL_MSG, callback(arg_5_0, "cb_on_message_received"))
		else
			Managers.irc:unregister_message_callback("twitch")
		end
	end
end

function StartGameWindowTwitchLogin._update_popup(arg_6_0)
	if arg_6_0._error_popup_id then
		local var_6_0 = Managers.popup:query_result(arg_6_0._error_popup_id)

		if var_6_0 == "ok" then
			arg_6_0._error_popup_id = nil
		elseif var_6_0 then
			fassert(false, "[StateTitleScreenMainMenu] The popup result doesn't exist (%s)", var_6_0)
		end
	end
end

function StartGameWindowTwitchLogin._handle_input(arg_7_0, arg_7_1, arg_7_2)
	if not Managers.twitch:is_connecting() then
		local var_7_0 = Managers.twitch:is_connected()
		local var_7_1 = arg_7_0._widgets_by_name.frame_widget

		if IS_WINDOWS then
			local var_7_2 = var_7_1.content
			local var_7_3 = var_7_2.text_input_hotspot
			local var_7_4 = var_7_2.screen_hotspot
			local var_7_5 = var_7_2.frame_hotspot

			if var_7_3.on_pressed and not var_7_0 then
				arg_7_0.parent.parent:set_input_blocked(true)

				var_7_2.text_field_active = true
			elseif var_7_4.on_pressed or var_7_0 then
				if var_7_4.on_pressed and not var_7_2.text_field_active and not var_7_5.on_pressed then
					arg_7_0:set_active(false)

					var_7_2.text_field_active = false

					arg_7_0.parent.parent:set_input_blocked(false)

					return
				end

				var_7_2.text_field_active = false

				arg_7_0.parent.parent:set_input_blocked(false)
			end

			if var_7_2.text_field_active then
				Managers.chat:block_chat_input_for_one_frame()

				local var_7_6 = Keyboard.keystrokes()

				var_7_2.twitch_name, var_7_2.caret_index = KeystrokeHelper.parse_strokes(var_7_2.twitch_name, var_7_2.caret_index, "insert", var_7_6, 32)

				if arg_7_0.parent:window_input_service():get("execute_chat_input", true) then
					var_7_2.text_field_active = false

					local var_7_7 = string.gsub(var_7_2.twitch_name, " ", "")

					Managers.twitch:connect(var_7_7, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_7_0, "cb_connection_success_callback"))
				end
			end
		end

		if not var_7_0 then
			local var_7_8 = arg_7_0._widgets_by_name.button_1

			if arg_7_0:_is_button_hover_enter(var_7_8) then
				arg_7_0:_play_sound("Play_hud_hover")
			end

			if arg_7_0:_is_button_pressed(var_7_8) then
				local var_7_9 = ""

				if var_7_1 then
					local var_7_10 = var_7_1.content

					var_7_9 = string.gsub(var_7_10.twitch_name, " ", "")
				end

				Managers.twitch:connect(var_7_9, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_7_0, "cb_connection_success_callback"))
				arg_7_0:_play_sound("Play_hud_select")
			end
		else
			local var_7_11 = arg_7_0._widgets_by_name.button_2

			if arg_7_0:_is_button_hover_enter(var_7_11) then
				arg_7_0:_play_sound("Play_hud_hover")
			end

			if arg_7_0:_is_button_pressed(var_7_11) then
				arg_7_0:_play_sound("Play_hud_select")
				Managers.twitch:disconnect()

				local var_7_12 = arg_7_0._widgets_by_name.chat_output_widget.content

				var_7_12.message_tables = {}
				var_7_12.text_start_offset = 0
			end
		end
	end
end

function StartGameWindowTwitchLogin._update_game_options(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.twitch:is_connected()
	local var_8_1 = Managers.twitch:is_connecting()

	if var_8_1 or var_8_0 then
		arg_8_0.parent:enable_widget(1, "game_option_1", false)
		arg_8_0.parent:enable_widget(1, "game_option_2", false)
		arg_8_0.parent:enable_widget(1, "game_option_3", false)
		arg_8_0.parent:enable_widget(1, "game_option_5", false)
	elseif not var_8_1 and not var_8_0 then
		arg_8_0.parent:enable_widget(1, "game_option_1", true)
		arg_8_0.parent:enable_widget(1, "game_option_2", true)
		arg_8_0.parent:enable_widget(1, "game_option_3", true)
		arg_8_0.parent:enable_widget(1, "game_option_5", true)
	end
end

function StartGameWindowTwitchLogin.cb_connection_success_callback(arg_9_0, arg_9_1)
	arg_9_0:_set_disconnect_button_text()
end

function StartGameWindowTwitchLogin._set_disconnect_button_text(arg_10_0)
	local var_10_0 = Managers.twitch and Managers.twitch:user_name() or "N/A"

	arg_10_0._widgets_by_name.button_2.content.button_hotspot.text = string.format(Localize("start_game_window_twitch_disconnect"), var_10_0)
end

function StartGameWindowTwitchLogin.cb_on_message_received(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0._widgets_by_name.chat_output_widget.content
	local var_11_1 = var_11_0.message_tables
	local var_11_2 = {}

	var_11_2.is_dev = false
	var_11_2.is_system = false
	var_11_2.sender = string.format("%s: ", arg_11_3)
	var_11_2.message = arg_11_4
	var_11_1[#var_11_1 + 1] = var_11_2

	if #var_11_1 > 20 then
		table.remove(var_11_1, 1)
	else
		var_11_0.text_start_offset = var_11_0.text_start_offset + 1
	end
end

function StartGameWindowTwitchLogin._is_button_pressed(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.on_release then
		var_12_0.on_release = false

		return true
	end
end

function StartGameWindowTwitchLogin._is_button_hover_enter(arg_13_0, arg_13_1)
	return arg_13_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowTwitchLogin.post_update(arg_14_0, arg_14_1, arg_14_2)
	return
end

function StartGameWindowTwitchLogin._update_animations(arg_15_0, arg_15_1)
	arg_15_0:_update_button_animations(arg_15_1)
end

function StartGameWindowTwitchLogin._update_button_animations(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._widgets_by_name
	local var_16_1 = "button_"

	for iter_16_0 = 1, 2 do
		local var_16_2 = var_16_0[var_16_1 .. iter_16_0]

		arg_16_0:_animate_button(var_16_2, arg_16_1)
	end
end

function StartGameWindowTwitchLogin._animate_button(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_1.content.button_hotspot
	local var_17_1 = 20
	local var_17_2 = var_17_0.input_progress or 0

	if var_17_0.is_clicked and var_17_0.is_clicked == 0 then
		var_17_2 = math.min(var_17_2 + arg_17_2 * var_17_1, 1)
	else
		var_17_2 = math.max(var_17_2 - arg_17_2 * var_17_1, 0)
	end

	local var_17_3 = 8
	local var_17_4 = var_17_0.hover_progress or 0

	if not var_17_0.disable_button and var_17_0.is_hover then
		var_17_4 = math.min(var_17_4 + arg_17_2 * var_17_3, 1)
	else
		var_17_4 = math.max(var_17_4 - arg_17_2 * var_17_3, 0)
	end

	local var_17_5 = var_17_0.selection_progress or 0

	if not var_17_0.disable_button and var_17_0.is_selected then
		var_17_5 = math.min(var_17_5 + arg_17_2 * var_17_3, 1)
	else
		var_17_5 = math.max(var_17_5 - arg_17_2 * var_17_3, 0)
	end

	local var_17_6 = math.max(var_17_4, var_17_5)
	local var_17_7 = arg_17_1.style

	var_17_7.clicked_rect.color[1] = 100 * var_17_2

	local var_17_8 = "hover_glow"
	local var_17_9 = 255 * var_17_6

	var_17_7[var_17_8].color[1] = var_17_9

	local var_17_10 = var_17_7.text
	local var_17_11 = var_17_10.text_color
	local var_17_12 = var_17_10.default_text_color
	local var_17_13 = var_17_10.select_text_color

	Colors.lerp_color_tables(var_17_12, var_17_13, var_17_6, var_17_11)

	var_17_0.hover_progress = var_17_4
	var_17_0.input_progress = var_17_2
	var_17_0.selection_progress = var_17_5
end

function StartGameWindowTwitchLogin.draw(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.ui_renderer
	local var_18_1 = arg_18_0.ui_scenegraph
	local var_18_2 = arg_18_0.parent:window_input_service()

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1, nil, arg_18_0.render_settings)

	local var_18_3 = arg_18_0._widgets

	for iter_18_0 = 1, #var_18_3 do
		local var_18_4 = var_18_3[iter_18_0]

		UIRenderer.draw_widget(var_18_0, var_18_4)
	end

	UIRenderer.end_pass(var_18_0)
end

function StartGameWindowTwitchLogin._play_sound(arg_19_0, arg_19_1)
	arg_19_0.parent:play_sound(arg_19_1)
end
