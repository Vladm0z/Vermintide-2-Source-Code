-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_twitch_overview_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_overview_console_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.play_widgets
local var_0_4 = var_0_0.client_widgets
local var_0_5 = var_0_0.additional_settings_widgets
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = var_0_0.selector_input_definition
local var_0_8 = "refresh_press"
local var_0_9 = "confirm_press"
local var_0_10 = "special_1_press"

StartGameWindowTwitchOverviewConsole = class(StartGameWindowTwitchOverviewConsole)
StartGameWindowTwitchOverviewConsole.NAME = "StartGameWindowTwitchOverviewConsole"

function StartGameWindowTwitchOverviewConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowTwitchOverviewConsole")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)

	if arg_1_0._is_server then
		arg_1_0._input_index = arg_1_1.input_index or 1

		arg_1_0:_handle_new_selection(arg_1_0._input_index)
	end

	if arg_1_0._is_server then
		arg_1_0:_update_mission_option()
		arg_1_0:_update_difficulty_option()
	end

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._show_additional_settings = false
	arg_1_0._previous_can_play = nil

	local var_1_1 = Managers.twitch and Managers.twitch:is_connected()

	arg_1_0:_set_input_description(var_1_1)
	arg_1_0:_set_disconnect_button_text()
	arg_1_0:_setup_connected_status()

	if Managers.twitch:is_connected() then
		arg_1_0:_set_active(true)
	end

	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowTwitchOverviewConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowTwitchOverviewConsole._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	if arg_3_0._is_server then
		for iter_3_2, iter_3_3 in pairs(var_0_3) do
			local var_3_3 = UIWidget.init(iter_3_3)

			var_3_0[#var_3_0 + 1] = var_3_3
			var_3_1[iter_3_2] = var_3_3
		end
	else
		for iter_3_4, iter_3_5 in pairs(var_0_4) do
			local var_3_4 = UIWidget.init(iter_3_5)

			var_3_0[#var_3_0 + 1] = var_3_4
			var_3_1[iter_3_4] = var_3_4
		end
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_5 = {}
	local var_3_6 = {}

	for iter_3_6, iter_3_7 in pairs(var_0_5) do
		local var_3_7 = UIWidget.init(iter_3_7)

		var_3_5[#var_3_5 + 1] = var_3_7
		var_3_6[iter_3_6] = var_3_7
	end

	arg_3_0._additional_settings_widgets = var_3_5
	arg_3_0._additional_settings_widgets_by_name = var_3_6

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_6)

	if arg_3_2 then
		local var_3_8 = arg_3_0._ui_scenegraph.window.local_position

		var_3_8[1] = var_3_8[1] + arg_3_2[1]
		var_3_8[2] = var_3_8[2] + arg_3_2[2]
		var_3_8[3] = var_3_8[3] + arg_3_2[3]
	end

	if IS_PS4 then
		arg_3_0._widgets_by_name.frame_widget.content.twitch_name = PlayerData.twitch_user_name or ""
	end
end

function StartGameWindowTwitchOverviewConsole._set_input_description(arg_4_0, arg_4_1)
	if arg_4_0._is_server then
		if arg_4_1 then
			arg_4_0._parent:change_generic_actions("default_twitch_connected")
		else
			arg_4_0._parent:change_generic_actions("default_twitch")
		end
	elseif arg_4_1 then
		arg_4_0._parent:change_generic_actions("default_twitch_client_connected")
	else
		arg_4_0._parent:change_generic_actions("default_twitch_client")
	end

	arg_4_0._input_description_connected = arg_4_1
end

function StartGameWindowTwitchOverviewConsole._set_disconnect_button_text(arg_5_0)
	local var_5_0 = arg_5_0._widgets_by_name.button_2

	if var_5_0 then
		local var_5_1 = Managers.twitch and Managers.twitch:user_name() or "N/A"

		var_5_0.content.button_hotspot.text = string.format(Localize("start_game_window_twitch_disconnect"), var_5_1)
	end
end

function StartGameWindowTwitchOverviewConsole.on_exit(arg_6_0, arg_6_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowTwitchOverviewConsole")

	arg_6_0._ui_animator = nil

	if arg_6_0._play_button_pressed then
		arg_6_1.input_index = nil
	else
		arg_6_1.input_index = arg_6_0._input_index
	end

	arg_6_0:_set_active(false)
end

function StartGameWindowTwitchOverviewConsole.set_focus(arg_7_0, arg_7_1)
	arg_7_0._is_focused = arg_7_1
end

function StartGameWindowTwitchOverviewConsole.update(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_update_input_description()
	arg_8_0:_update_can_play()
	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_handle_virtual_keyboard(arg_8_1, arg_8_2)
	arg_8_0:_handle_input(arg_8_1, arg_8_2)
	arg_8_0:_draw(arg_8_1)
end

function StartGameWindowTwitchOverviewConsole.post_update(arg_9_0, arg_9_1, arg_9_2)
	return
end

function StartGameWindowTwitchOverviewConsole._update_input_description(arg_10_0)
	local var_10_0 = arg_10_0._input_description_connected
	local var_10_1 = Managers.twitch and Managers.twitch:is_connected()

	if var_10_1 ~= var_10_0 then
		arg_10_0:_set_input_description(var_10_1)
	end
end

function StartGameWindowTwitchOverviewConsole._update_can_play(arg_11_0)
	if arg_11_0._is_server then
		local var_11_0 = arg_11_0:_can_play()

		if arg_11_0._previous_can_play ~= var_11_0 then
			arg_11_0._previous_can_play = var_11_0

			local var_11_1 = arg_11_0._widgets_by_name.play_button

			var_11_1.content.button_hotspot.disable_button = not var_11_0
			var_11_1.content.disabled = not var_11_0

			if var_11_0 then
				arg_11_0._parent:set_input_description("play_available")
			else
				arg_11_0._parent:set_input_description(nil)
			end
		end
	end
end

function StartGameWindowTwitchOverviewConsole._set_active(arg_12_0, arg_12_1)
	if arg_12_1 then
		Managers.irc:register_message_callback("twitch_gamepad", Irc.CHANNEL_MSG, callback(arg_12_0, "cb_on_message_received"))
	else
		Managers.irc:unregister_message_callback("twitch_gamepad")

		local var_12_0 = arg_12_0._widgets_by_name.chat_output_widget.content

		table.clear(var_12_0.message_tables)
	end
end

function StartGameWindowTwitchOverviewConsole.cb_on_message_received(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = arg_13_0._widgets_by_name.chat_output_widget.content
	local var_13_1 = var_13_0.message_tables
	local var_13_2 = {}

	var_13_2.is_dev = false
	var_13_2.is_system = false
	var_13_2.sender = string.format("%s: ", arg_13_3)
	var_13_2.message = arg_13_4
	var_13_1[#var_13_1 + 1] = var_13_2

	if #var_13_1 > 45 then
		table.remove(var_13_1, 1)
	else
		var_13_0.text_start_offset = var_13_0.text_start_offset + 1
	end
end

function StartGameWindowTwitchOverviewConsole._handle_virtual_keyboard(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0._virtual_keyboard_id then
		return
	end

	if IS_XB1 then
		if not XboxInterface.interface_active() then
			local var_14_0 = XboxInterface.get_keyboard_result()

			arg_14_0._virtual_keyboard_id = nil

			local var_14_1 = string.gsub(var_14_0, " ", "")

			if var_14_1 then
				PlayerData.twitch_user_name = var_14_1
			end

			arg_14_0._widgets_by_name.frame_widget.content.twitch_name = var_14_1

			Managers.twitch:connect(var_14_1, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_14_0, "cb_connection_success_callback"))
			arg_14_0:_play_sound("Play_hud_select")
		end
	else
		local var_14_2, var_14_3, var_14_4 = Managers.system_dialog:poll_virtual_keyboard(arg_14_0._virtual_keyboard_id)

		if var_14_2 then
			arg_14_0._virtual_keyboard_id = nil

			if var_14_3 then
				local var_14_5 = string.gsub(var_14_4, " ", "")

				if var_14_5 then
					PlayerData.twitch_user_name = var_14_5
				end

				arg_14_0._widgets_by_name.frame_widget.content.twitch_name = var_14_5

				Managers.twitch:connect(var_14_5, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_14_0, "cb_connection_success_callback"))
				arg_14_0:_play_sound("Play_hud_select")
			end
		end
	end
end

function StartGameWindowTwitchOverviewConsole._handle_input(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0._virtual_keyboard_id then
		return
	end

	local var_15_0 = arg_15_0._parent
	local var_15_1 = var_15_0:window_input_service()

	arg_15_0:_handle_twitch_login_input(arg_15_1, arg_15_2, var_15_1)

	if arg_15_0._is_server then
		if var_15_1:get(var_0_9) then
			arg_15_0:_option_selected(arg_15_0._input_index, arg_15_2)
		end

		local var_15_2 = arg_15_0._input_index

		if var_15_1:get("move_down") then
			var_15_2 = var_15_2 + 1
		elseif var_15_1:get("move_up") then
			var_15_2 = var_15_2 - 1
		end

		if var_15_2 ~= arg_15_0._input_index then
			arg_15_0:_handle_new_selection(var_15_2)
		end

		local var_15_3 = arg_15_0._widgets_by_name

		for iter_15_0 = 1, #var_0_7 do
			local var_15_4 = var_15_3[var_0_7[iter_15_0]]

			if not var_15_4.content.is_selected and arg_15_0:_is_button_hover_enter(var_15_4) then
				arg_15_0:_handle_new_selection(iter_15_0)
			end

			if arg_15_0:_is_button_pressed(var_15_4) then
				arg_15_0:_option_selected(arg_15_0._input_index, arg_15_2)
			end
		end

		if arg_15_0:_can_play() then
			if arg_15_0:_is_button_hover_enter(var_15_3.play_button) then
				arg_15_0._parent:play_sound("Play_hud_hover")
			end

			if var_15_1:get(var_0_8) or arg_15_0:_is_button_pressed(var_15_3.play_button) then
				local var_15_5 = var_15_0:get_twitch_settings(arg_15_0._mechanism_name) or var_15_0:get_twitch_settings("adventure")

				var_15_0:play(arg_15_2, var_15_5.game_mode_type)

				arg_15_0._play_button_pressed = true
			end
		end
	end
end

function StartGameWindowTwitchOverviewConsole._handle_twitch_login_input(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if not Managers.twitch:is_connecting() then
		local var_16_0 = Managers.twitch:is_connected()
		local var_16_1 = arg_16_0._widgets_by_name.frame_widget

		if IS_WINDOWS then
			local var_16_2 = var_16_1.content
			local var_16_3 = var_16_2.text_input_hotspot
			local var_16_4 = var_16_2.screen_hotspot
			local var_16_5 = var_16_2.frame_hotspot

			if var_16_3.on_pressed and not var_16_0 then
				arg_16_0._parent.parent:set_input_blocked(true)

				var_16_2.text_field_active = true
			elseif var_16_2.text_field_active and var_16_4.on_pressed then
				var_16_2.text_field_active = false

				arg_16_0._parent.parent:set_input_blocked(false)
			end

			if var_16_2.text_field_active then
				arg_16_3:get("move_up", true)
				arg_16_3:get("move_down", true)
				arg_16_3:get("cycle_next", true)
				arg_16_3:get("cycle_previous", true)
				Managers.chat:block_chat_input_for_one_frame()

				local var_16_6 = Keyboard.keystrokes()

				var_16_2.twitch_name, var_16_2.caret_index = KeystrokeHelper.parse_strokes(var_16_2.twitch_name, var_16_2.caret_index, "insert", var_16_6)

				if arg_16_3:get("execute_chat_input", true) then
					var_16_2.text_field_active = false

					local var_16_7 = string.gsub(var_16_2.twitch_name, " ", "")

					Managers.twitch:connect(var_16_7, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_16_0, "cb_connection_success_callback"))
				elseif arg_16_3:get("toggle_menu", true) then
					var_16_2.text_field_active = false

					arg_16_0._parent.parent:set_input_blocked(false)
				end
			end
		end

		if not var_16_0 then
			local var_16_8 = arg_16_0._widgets_by_name.button_1

			if var_16_8 and arg_16_0:_is_button_hover_enter(var_16_8) then
				arg_16_0:_play_sound("Play_hud_hover")
			end

			if var_16_8 and arg_16_0:_is_button_pressed(var_16_8) or arg_16_3:get(var_0_10) then
				if IS_PS4 then
					local var_16_9 = Managers.account:user_id()
					local var_16_10 = PlayerData.twitch_user_name
					local var_16_11 = Localize("start_game_window_twitch_login_hint")
					local var_16_12 = var_0_0.twitch_keyboard_anchor_point
					local var_16_13 = RESOLUTION_LOOKUP.inv_scale

					arg_16_0._virtual_keyboard_id = Managers.system_dialog:open_virtual_keyboard(var_16_9, var_16_11, var_16_10, var_16_12)
				elseif IS_XB1 then
					local var_16_14 = PlayerData.twitch_user_name
					local var_16_15 = Localize("start_game_window_twitch_login_hint")

					XboxInterface.show_virtual_keyboard(var_16_14, var_16_15)

					arg_16_0._virtual_keyboard_id = true
				else
					local var_16_16 = ""

					if var_16_1 then
						local var_16_17 = var_16_1.content

						var_16_16 = string.gsub(var_16_17.twitch_name, " ", "")
					end

					Managers.twitch:connect(var_16_16, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_16_0, "cb_connection_success_callback"))
					arg_16_0:_play_sound("Play_hud_select")
				end
			end
		else
			local var_16_18 = arg_16_0._widgets_by_name.button_2

			if var_16_18 and arg_16_0:_is_button_hover_enter(var_16_18) then
				arg_16_0:_play_sound("Play_hud_hover")
			end

			if var_16_18 and arg_16_0:_is_button_pressed(var_16_18) or arg_16_3:get(var_0_10) then
				arg_16_0:_play_sound("Play_hud_select")
				arg_16_0:_set_active(false)
				Managers.twitch:disconnect()
			end
		end
	end
end

function StartGameWindowTwitchOverviewConsole._is_button_pressed(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.content.button_hotspot

	if var_17_0.on_release then
		var_17_0.on_release = false

		return true
	end
end

function StartGameWindowTwitchOverviewConsole._is_button_hover_enter(arg_18_0, arg_18_1)
	return arg_18_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowTwitchOverviewConsole.cb_connection_success_callback(arg_19_0, arg_19_1)
	arg_19_0:_set_disconnect_button_text()
	arg_19_0:_setup_connected_status()
	arg_19_0:_set_active(true)
end

function StartGameWindowTwitchOverviewConsole._setup_connected_status(arg_20_0)
	local var_20_0 = Managers.twitch and Managers.twitch:user_name() or "N/A"

	arg_20_0._widgets_by_name.frame_widget.content.connected = Localize("start_game_window_twitch_connected_to") .. var_20_0
end

function StartGameWindowTwitchOverviewConsole._can_play(arg_21_0)
	if not arg_21_0._is_server then
		return false
	end

	local var_21_0 = arg_21_0._parent
	local var_21_1 = var_21_0:get_selected_level_id()
	local var_21_2 = var_21_0:get_difficulty_option()
	local var_21_3 = Managers.twitch and Managers.twitch:is_connected()

	return var_21_1 ~= nil and var_21_2 ~= nil and var_21_3
end

function StartGameWindowTwitchOverviewConsole._update_mission_option(arg_22_0)
	local var_22_0 = arg_22_0._parent:get_selected_level_id()

	if var_22_0 then
		arg_22_0:_set_selected_level(var_22_0)
	end
end

function StartGameWindowTwitchOverviewConsole._set_selected_level(arg_23_0, arg_23_1)
	local var_23_0 = LevelSettings[arg_23_1]
	local var_23_1 = arg_23_0._widgets_by_name.mission_setting

	var_23_1.content.input_text = Localize(var_23_0.display_name)

	local var_23_2 = var_23_0.level_image

	var_23_1.content.icon_texture = var_23_2

	local var_23_3 = arg_23_0._parent:get_completed_level_difficulty_index(arg_23_0._statistics_db, arg_23_0._stats_id, arg_23_1)
	local var_23_4 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_23_3)

	var_23_1.content.icon_frame_texture = var_23_4
end

function StartGameWindowTwitchOverviewConsole._update_difficulty_option(arg_24_0)
	local var_24_0 = arg_24_0._parent:get_difficulty_option()

	if var_24_0 then
		local var_24_1 = DifficultySettings[var_24_0]
		local var_24_2 = arg_24_0._widgets_by_name.difficulty_setting

		var_24_2.content.input_text = Localize(var_24_1.display_name)

		local var_24_3 = var_24_1.display_image

		var_24_2.content.icon_texture = var_24_3

		local var_24_4 = var_24_1.completed_frame_texture

		var_24_2.content.icon_frame_texture = var_24_4
	end
end

function StartGameWindowTwitchOverviewConsole._option_selected(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._parent
	local var_25_1 = var_25_0:get_twitch_settings(arg_25_0._mechanism_name) or var_25_0:get_twitch_settings("adventure")
	local var_25_2 = var_0_7[arg_25_1]

	if var_25_2 == "mission_setting" then
		arg_25_0._parent:set_layout_by_name(var_25_1.layout_name)
	elseif var_25_2 == "difficulty_setting" then
		arg_25_0._parent:set_layout_by_name("difficulty_selection_custom")
	elseif var_25_2 == "play_button" then
		if arg_25_0:_can_play() then
			arg_25_0._play_button_pressed = true

			arg_25_0._parent:play(arg_25_2, var_25_1.game_mode_type)
		end
	else
		ferror("Unknown selector_input_definition: %s", var_25_2)
	end
end

function StartGameWindowTwitchOverviewConsole._handle_new_selection(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._widgets_by_name
	local var_26_1 = #var_0_7

	arg_26_1 = math.clamp(arg_26_1, 1, var_26_1)

	if var_26_0[var_0_7[arg_26_1]].content.disabled then
		return
	end

	for iter_26_0 = 1, #var_0_7 do
		local var_26_2 = var_26_0[var_0_7[iter_26_0]]

		if var_26_2 then
			local var_26_3 = iter_26_0 == arg_26_1

			var_26_2.content.is_selected = var_26_3
		end
	end

	if arg_26_0._input_index ~= arg_26_1 then
		arg_26_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
	end

	arg_26_0._input_index = arg_26_1
end

function StartGameWindowTwitchOverviewConsole._update_animations(arg_27_0, arg_27_1)
	if not IS_PS4 and not Managers.input:is_device_active("gamepad") then
		arg_27_0:_update_button_animations(arg_27_1)
	end

	local var_27_0 = arg_27_0._ui_animator

	var_27_0:update(arg_27_1)

	local var_27_1 = arg_27_0._animations

	for iter_27_0, iter_27_1 in pairs(var_27_1) do
		if var_27_0:is_animation_completed(iter_27_1) then
			var_27_0:stop_animation(iter_27_1)

			var_27_1[iter_27_0] = nil
		end
	end

	if arg_27_0._is_server then
		local var_27_2 = arg_27_0._widgets_by_name

		UIWidgetUtils.animate_start_game_console_setting_button(var_27_2.mission_setting, arg_27_1)
		UIWidgetUtils.animate_start_game_console_setting_button(var_27_2.difficulty_setting, arg_27_1)
		UIWidgetUtils.animate_play_button(var_27_2.play_button, arg_27_1)
	end
end

function StartGameWindowTwitchOverviewConsole._update_button_animations(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._widgets_by_name
	local var_28_1 = "button_"

	for iter_28_0 = 1, 2 do
		local var_28_2 = var_28_0[var_28_1 .. iter_28_0]

		arg_28_0:_animate_button(var_28_2, arg_28_1)
	end
end

function StartGameWindowTwitchOverviewConsole._animate_button(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_1.content.button_hotspot
	local var_29_1 = 20
	local var_29_2 = var_29_0.input_progress or 0

	if var_29_0.is_clicked and var_29_0.is_clicked == 0 then
		var_29_2 = math.min(var_29_2 + arg_29_2 * var_29_1, 1)
	else
		var_29_2 = math.max(var_29_2 - arg_29_2 * var_29_1, 0)
	end

	local var_29_3 = 8
	local var_29_4 = var_29_0.hover_progress or 0

	if not var_29_0.disable_button and var_29_0.is_hover then
		var_29_4 = math.min(var_29_4 + arg_29_2 * var_29_3, 1)
	else
		var_29_4 = math.max(var_29_4 - arg_29_2 * var_29_3, 0)
	end

	local var_29_5 = var_29_0.selection_progress or 0

	if not var_29_0.disable_button and var_29_0.is_selected then
		var_29_5 = math.min(var_29_5 + arg_29_2 * var_29_3, 1)
	else
		var_29_5 = math.max(var_29_5 - arg_29_2 * var_29_3, 0)
	end

	local var_29_6 = math.max(var_29_4, var_29_5)
	local var_29_7 = arg_29_1.style

	var_29_7.clicked_rect.color[1] = 100 * var_29_2

	local var_29_8 = "hover_glow"
	local var_29_9 = 255 * var_29_6

	var_29_7[var_29_8].color[1] = var_29_9

	local var_29_10 = var_29_7.text
	local var_29_11 = var_29_10.text_color
	local var_29_12 = var_29_10.default_text_color
	local var_29_13 = var_29_10.select_text_color

	Colors.lerp_color_tables(var_29_12, var_29_13, var_29_6, var_29_11)

	var_29_0.hover_progress = var_29_4
	var_29_0.input_progress = var_29_2
	var_29_0.selection_progress = var_29_5
end

function StartGameWindowTwitchOverviewConsole._draw(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._ui_top_renderer
	local var_30_1 = arg_30_0._ui_scenegraph
	local var_30_2 = arg_30_0._parent:window_input_service()
	local var_30_3 = arg_30_0._render_settings
	local var_30_4

	UIRenderer.begin_pass(var_30_0, var_30_1, var_30_2, arg_30_1, var_30_4, var_30_3)

	local var_30_5 = arg_30_0._widgets

	for iter_30_0 = 1, #var_30_5 do
		local var_30_6 = var_30_5[iter_30_0]

		UIRenderer.draw_widget(var_30_0, var_30_6)
	end

	if arg_30_0._show_additional_settings then
		local var_30_7 = arg_30_0._additional_settings_widgets

		for iter_30_1 = 1, #var_30_7 do
			local var_30_8 = var_30_7[iter_30_1]

			UIRenderer.draw_widget(var_30_0, var_30_8)
		end
	end

	UIRenderer.end_pass(var_30_0)
end

function StartGameWindowTwitchOverviewConsole._play_sound(arg_31_0, arg_31_1)
	arg_31_0._parent:play_sound(arg_31_1)
end
