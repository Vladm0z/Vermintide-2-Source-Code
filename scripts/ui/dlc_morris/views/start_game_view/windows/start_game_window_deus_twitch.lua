-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_twitch.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_twitch_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.selection_widgets
local var_0_4 = var_0_0.client_widgets
local var_0_5 = var_0_0.server_widgets
local var_0_6 = var_0_0.additional_settings_widgets
local var_0_7 = var_0_0.animation_definitions
local var_0_8 = var_0_0.selector_input_definition
local var_0_9 = "refresh_press"
local var_0_10 = "confirm_press"
local var_0_11 = "special_1_press"

StartGameWindowDeusTwitch = class(StartGameWindowDeusTwitch)
StartGameWindowDeusTwitch.NAME = "StartGameWindowDeusTwitch"

StartGameWindowDeusTwitch.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
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
	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._show_additional_settings = false
	arg_1_0._previous_can_play = nil
	arg_1_0._current_difficulty = arg_1_0._parent:get_difficulty_option(true) or Managers.state.difficulty:get_difficulty()
	arg_1_0._dlc_name = nil
	arg_1_0._backend_deus = Managers.backend:get_interface("deus")
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)

	if arg_1_0._is_server then
		arg_1_0:_gamepad_selector_input_func(arg_1_1.input_index or 1)
		arg_1_0:_update_expedition_option()
		arg_1_0:_update_difficulty_option(arg_1_0._current_difficulty)
	end

	local var_1_1 = Managers.twitch and Managers.twitch:is_connected()

	arg_1_0:_set_input_description(var_1_1)
	arg_1_0:_set_disconnect_button_text()
	arg_1_0:_setup_connected_status()

	if Managers.twitch:is_connected() then
		arg_1_0:_set_active(true)
	end

	arg_1_0:_start_transition_animation("on_enter")
	Managers.state.event:register(arg_1_0, "_update_additional_curse_frame", "_update_additional_curse_frame")
end

StartGameWindowDeusTwitch._create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_2_0._expedition_widgets = {}

	local var_2_0 = {}
	local var_2_1 = {}

	if arg_2_0._is_server then
		var_2_0, var_2_1 = UIUtils.create_widgets(var_0_3)

		UIUtils.create_widgets(var_0_5, arg_2_0._widgets, arg_2_0._widgets_by_name)
		arg_2_0:_gather_unlocked_journeys()
		arg_2_0:_setup_journey_widgets()
		arg_2_0:_refresh_journey_cycle()
	else
		UIUtils.create_widgets(var_0_4, arg_2_0._widgets, arg_2_0._widgets_by_name)
	end

	arg_2_0._selection_widgets = var_2_0
	arg_2_0._selection_widgets_by_name = var_2_1
	arg_2_0._additional_settings_widgets, arg_2_0._additional_settings_widgets_by_name = UIUtils.create_widgets(var_0_6)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_7)

	if arg_2_2 then
		local var_2_2 = arg_2_0._ui_scenegraph.window.local_position

		var_2_2[1] = var_2_2[1] + arg_2_2[1]
		var_2_2[2] = var_2_2[2] + arg_2_2[2]
		var_2_2[3] = var_2_2[3] + arg_2_2[3]
	end

	if IS_PS4 then
		arg_2_0._widgets_by_name.frame_widget.content.twitch_name = PlayerData.twitch_user_name or ""
	end

	arg_2_0._widgets_by_name.difficulty_info.content.visible = false
	arg_2_0._widgets_by_name.upsell_button.content.visible = false
end

StartGameWindowDeusTwitch.set_focus = function (arg_3_0, arg_3_1)
	arg_3_0._is_focused = arg_3_1
end

StartGameWindowDeusTwitch._set_active = function (arg_4_0, arg_4_1)
	if arg_4_1 then
		Managers.irc:register_message_callback("twitch_gamepad", Irc.CHANNEL_MSG, callback(arg_4_0, "cb_on_message_received"))
	else
		Managers.irc:unregister_message_callback("twitch_gamepad")

		local var_4_0 = arg_4_0._widgets_by_name.chat_output_widget.content

		table.clear(var_4_0.message_tables)
	end
end

StartGameWindowDeusTwitch._set_disconnect_button_text = function (arg_5_0)
	local var_5_0 = arg_5_0._widgets_by_name.button_2

	if var_5_0 then
		local var_5_1 = Managers.twitch and Managers.twitch:user_name() or "N/A"

		var_5_0.content.button_hotspot.text = string.format(Localize("start_game_window_twitch_disconnect"), var_5_1)
	end
end

StartGameWindowDeusTwitch.cb_on_message_received = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._widgets_by_name.chat_output_widget.content
	local var_6_1 = var_6_0.message_tables
	local var_6_2 = {}

	var_6_2.is_dev = false
	var_6_2.is_system = false
	var_6_2.sender = string.format("%s: ", arg_6_3)
	var_6_2.message = arg_6_4
	var_6_1[#var_6_1 + 1] = var_6_2

	if #var_6_1 > 45 then
		table.remove(var_6_1, 1)
	else
		var_6_0.text_start_offset = var_6_0.text_start_offset + 1
	end
end

StartGameWindowDeusTwitch.set_input_blocked = function (arg_7_0, arg_7_1)
	local var_7_0 = Managers.input

	if arg_7_1 then
		var_7_0:block_device_except_service("start_game_view", "keyboard", 1, "twitch")
		var_7_0:block_device_except_service("start_game_view", "mouse", 1, "twitch")
		var_7_0:block_device_except_service("start_game_view", "gamepad", 1, "twitch")
		arg_7_0._parent.parent:set_input_blocked(true)
	else
		var_7_0:device_unblock_all_services("keyboard")
		var_7_0:device_unblock_all_services("mouse")
		var_7_0:device_unblock_all_services("gamepad")
		var_7_0:block_device_except_service("start_game_view", "keyboard", 1)
		var_7_0:block_device_except_service("start_game_view", "mouse", 1)
		var_7_0:block_device_except_service("start_game_view", "gamepad", 1)
		arg_7_0._parent.parent:set_input_blocked(false)
	end
end

StartGameWindowDeusTwitch._handle_twitch_login_input = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not Managers.twitch:is_connecting() then
		local var_8_0 = Managers.twitch:is_connected()
		local var_8_1 = arg_8_0._widgets_by_name.frame_widget

		if IS_WINDOWS then
			local var_8_2 = var_8_1.content
			local var_8_3 = var_8_2.text_input_hotspot
			local var_8_4 = var_8_2.screen_hotspot
			local var_8_5 = var_8_2.frame_hotspot

			if var_8_3.on_pressed and not var_8_0 then
				arg_8_0:set_input_blocked(true)

				var_8_2.text_field_active = true
			elseif var_8_4.on_pressed or var_8_0 then
				if var_8_4.on_pressed and not var_8_2.text_field_active and not var_8_5.on_pressed then
					var_8_2.text_field_active = false

					arg_8_0:set_input_blocked(false)

					return
				end

				var_8_2.text_field_active = false

				arg_8_0:set_input_blocked(false)
			end

			if var_8_2.text_field_active then
				if arg_8_3:get("toggle_menu", true) then
					var_8_2.text_field_active = false

					arg_8_0:set_input_blocked(false)
				else
					Managers.chat:block_chat_input_for_one_frame()

					local var_8_6 = Keyboard.keystrokes()

					var_8_2.twitch_name, var_8_2.caret_index = KeystrokeHelper.parse_strokes(var_8_2.twitch_name, var_8_2.caret_index, "insert", var_8_6)

					if arg_8_3:get("execute_chat_input", true) then
						var_8_2.text_field_active = false

						arg_8_0:set_input_blocked(false)

						local var_8_7 = string.gsub(var_8_2.twitch_name, " ", "")

						Managers.twitch:connect(var_8_7, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_8_0, "cb_connection_success_callback"))
					end
				end
			end
		end

		if not var_8_0 then
			local var_8_8 = arg_8_0._widgets_by_name.button_1

			if var_8_8 and UIUtils.is_button_hover_enter(var_8_8) then
				arg_8_0:_play_sound("Play_hud_hover")
			end

			if var_8_8 and UIUtils.is_button_pressed(var_8_8) or arg_8_3:get(var_0_11) then
				if IS_PS4 then
					local var_8_9 = Managers.account:user_id()
					local var_8_10 = PlayerData.twitch_user_name
					local var_8_11 = Localize("start_game_window_twitch_login_hint")
					local var_8_12 = var_0_0.twitch_keyboard_anchor_point
					local var_8_13 = RESOLUTION_LOOKUP.inv_scale

					arg_8_0._virtual_keyboard_id = Managers.system_dialog:open_virtual_keyboard(var_8_9, var_8_11, var_8_10, var_8_12)
				elseif IS_XB1 then
					local var_8_14 = PlayerData.twitch_user_name
					local var_8_15 = Localize("start_game_window_twitch_login_hint")

					XboxInterface.show_virtual_keyboard(var_8_14, var_8_15)

					arg_8_0._virtual_keyboard_id = true
				else
					local var_8_16 = ""

					if var_8_1 then
						local var_8_17 = var_8_1.content

						var_8_16 = string.gsub(var_8_17.twitch_name, " ", "")
					end

					Managers.twitch:connect(var_8_16, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_8_0, "cb_connection_success_callback"))
					arg_8_0:_play_sound("Play_hud_select")
				end
			end
		else
			local var_8_18 = arg_8_0._widgets_by_name.button_2

			if var_8_18 and UIUtils.is_button_hover_enter(var_8_18) then
				arg_8_0:_play_sound("Play_hud_hover")
			end

			if var_8_18 and UIUtils.is_button_pressed(var_8_18) or arg_8_3:get(var_0_11) then
				arg_8_0:_play_sound("Play_hud_select")
				arg_8_0:_set_active(false)
				Managers.twitch:disconnect()
			end
		end
	end
end

StartGameWindowDeusTwitch.cb_connection_success_callback = function (arg_9_0, arg_9_1)
	arg_9_0:_set_disconnect_button_text()
	arg_9_0:_setup_connected_status()
	arg_9_0:_set_active(true)
end

StartGameWindowDeusTwitch._setup_connected_status = function (arg_10_0)
	local var_10_0 = Managers.twitch and Managers.twitch:user_name() or "N/A"

	arg_10_0._widgets_by_name.frame_widget.content.connected = Localize("start_game_window_twitch_connected_to") .. var_10_0
end

local function var_0_12(arg_11_0, arg_11_1)
	return arg_11_0.remaining_time - (arg_11_1 - arg_11_0.time_of_update) < 0
end

StartGameWindowDeusTwitch._gather_unlocked_journeys = function (arg_12_0)
	local var_12_0 = {}

	for iter_12_0, iter_12_1 in ipairs(LevelUnlockUtils.unlocked_journeys(arg_12_0._statistics_db, arg_12_0._stats_id)) do
		var_12_0[iter_12_1] = true
	end

	local var_12_1 = arg_12_0._backend_deus:get_journey_cycle().journey_data

	for iter_12_2, iter_12_3 in pairs(var_12_0) do
		if LevelUnlockUtils.is_chaos_waste_god_disabled(var_12_1[iter_12_2].dominant_god) then
			var_12_0[iter_12_2] = nil
		end
	end

	arg_12_0._unlocked_journeys = var_12_0
end

StartGameWindowDeusTwitch._setup_journey_widgets = function (arg_13_0)
	local var_13_0 = arg_13_0._node_widgets
	local var_13_1 = arg_13_0._statistics_db
	local var_13_2 = arg_13_0._stats_id
	local var_13_3 = arg_13_0._unlocked_journeys
	local var_13_4 = {}
	local var_13_5 = -365
	local var_13_6 = var_0_0.journey_widget_settings
	local var_13_7 = AvailableJourneyOrder

	for iter_13_0 = 1, #var_13_7 do
		local var_13_8 = AvailableJourneyOrder[iter_13_0]
		local var_13_9 = arg_13_0._backend_deus:deus_journey_with_belakor(var_13_8)
		local var_13_10 = DeusJourneySettings[var_13_8]
		local var_13_11 = #var_13_4 + 1
		local var_13_12 = var_13_7[var_13_11 + 1]
		local var_13_13 = UIWidgets.create_expedition_widget_func("level_root_node", var_13_11, var_13_10, var_13_8, var_13_6)
		local var_13_14 = UIWidget.init(var_13_13)
		local var_13_15 = var_13_14.content

		var_13_15.text = Localize(var_13_10.display_name)
		var_13_5 = var_13_5 + (var_13_6.width + var_13_6.spacing_x)

		local var_13_16 = var_13_14.offset

		var_13_16[1] = var_13_5
		var_13_16[2] = 0

		local var_13_17 = LevelUnlockUtils.completed_level_difficulty_index(var_13_1, var_13_2, var_13_8)
		local var_13_18 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_13_17)
		local var_13_19 = var_13_3[var_13_8]

		var_13_15.level_icon = var_13_10.level_image
		var_13_15.locked = not var_13_19
		var_13_15.frame = var_13_18
		var_13_15.journey_name = var_13_8
		var_13_15.level_icon_frame = var_13_9 and "morris_expedition_select_border_belakor" or "morris_expedition_select_border"
		var_13_15.draw_path = var_13_12 ~= nil
		var_13_15.draw_path_fill = var_13_3[var_13_12]
		var_13_14.style.path.texture_size[1] = var_13_6.spacing_x
		var_13_14.style.path_glow.texture_size[1] = var_13_6.spacing_x
		var_13_4[var_13_11] = var_13_14
		var_13_5 = var_13_5 + var_13_6.spacing_x
	end

	arg_13_0._expedition_widgets = var_13_4
end

StartGameWindowDeusTwitch._refresh_journey_cycle = function (arg_14_0)
	arg_14_0._journey_cycle = arg_14_0._backend_deus:get_journey_cycle()

	arg_14_0:_on_new_journey_cycle()
end

StartGameWindowDeusTwitch._on_new_journey_cycle = function (arg_15_0)
	arg_15_0:_update_journey_god_icons()
end

StartGameWindowDeusTwitch._update_journey_god_icons = function (arg_16_0)
	local var_16_0 = arg_16_0._journey_cycle

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._expedition_widgets) do
		local var_16_1 = iter_16_1.content
		local var_16_2 = var_16_0.journey_data[var_16_1.journey_name].dominant_god

		var_16_1.theme_icon = DeusThemeSettings[var_16_2].text_icon
	end
end

StartGameWindowDeusTwitch.update = function (arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:_update_modifiers(arg_17_1, arg_17_2)
	arg_17_0:_update_input_description(arg_17_1, arg_17_2)
	arg_17_0:_update_can_play(arg_17_1, arg_17_2)
	arg_17_0:_update_animations(arg_17_1)
	arg_17_0:_handle_virtual_keyboard(arg_17_1, arg_17_2)
	arg_17_0:_handle_gamepad_activity(arg_17_1, arg_17_2)
	arg_17_0:_handle_input(arg_17_1, arg_17_2)
	arg_17_0:_draw(arg_17_1, arg_17_2)
end

StartGameWindowDeusTwitch.post_update = function (arg_18_0, arg_18_1, arg_18_2)
	return
end

StartGameWindowDeusTwitch._handle_input = function (arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0._virtual_keyboard_id then
		return
	end

	local var_19_0 = arg_19_0._parent
	local var_19_1 = var_19_0:window_input_service()
	local var_19_2 = Managers.input:is_device_active("mouse")

	if arg_19_0._widgets_by_name.frame_widget.content.text_field_active then
		var_19_1:get("move_up", true)
		var_19_1:get("move_down", true)
		var_19_1:get("move_left", true)
		var_19_1:get("move_right", true)
		var_19_1:get("cycle_next", true)
		var_19_1:get("cycle_previous", true)
	end

	if arg_19_0._is_server then
		if not var_19_2 then
			local var_19_3
			local var_19_4 = arg_19_0._input_index

			if var_19_1:get("move_down") then
				var_19_4 = var_19_4 + 1
				var_19_3 = 1
			elseif var_19_1:get("move_up") then
				var_19_4 = var_19_4 - 1
				var_19_3 = -1
			else
				var_0_8[var_19_4].update(arg_19_0, var_19_1, arg_19_1, arg_19_2)
			end

			if var_19_4 ~= arg_19_0._input_index then
				arg_19_0:_gamepad_selector_input_func(var_19_4, var_19_3)
			end
		else
			local var_19_5 = arg_19_0._selection_widgets_by_name

			for iter_19_0, iter_19_1 in pairs(var_19_5) do
				if iter_19_0 == "difficulty_stepper" then
					if UIUtils.is_button_pressed(iter_19_1, "left_arrow_hotspot") then
						arg_19_0:_option_selected(iter_19_0, "left_arrow", arg_19_2)
					elseif UIUtils.is_button_pressed(iter_19_1, "right_arrow_hotspot") then
						arg_19_0:_option_selected(iter_19_0, "right_arrow", arg_19_2)
					end

					if UIUtils.is_button_hover(iter_19_1, "info_hotspot") or UIUtils.is_button_hover(arg_19_0._widgets_by_name.difficulty_info, "widget_hotspot") then
						local var_19_6 = {
							difficulty_info = arg_19_0._widgets_by_name.difficulty_info,
							upsell_button = arg_19_0._widgets_by_name.upsell_button
						}

						if not arg_19_0.diff_info_anim_played then
							arg_19_0._diff_anim_id = arg_19_0._ui_animator:start_animation("difficulty_info_enter", var_19_6, var_0_1)
							arg_19_0.diff_info_anim_played = true
						end

						arg_19_0:_update_difficulty_lock()
					else
						if arg_19_0._diff_anim_id then
							arg_19_0._ui_animator:stop_animation(arg_19_0._diff_anim_id)
						end

						arg_19_0.diff_info_anim_played = false
						arg_19_0._widgets_by_name.upsell_button.content.visible = false
						arg_19_0._widgets_by_name.difficulty_info.content.visible = false
					end
				elseif UIUtils.is_button_pressed(iter_19_1) then
					arg_19_0:_option_selected(iter_19_0, nil, arg_19_2)
				end

				if iter_19_0 == "difficulty_stepper" then
					iter_19_1.content.is_selected = UIUtils.is_button_hover(iter_19_1, "left_arrow_hotspot") or UIUtils.is_button_hover(iter_19_1, "right_arrow_hotspot")
				else
					iter_19_1.content.is_selected = UIUtils.is_button_hover(iter_19_1)
				end
			end
		end

		local var_19_7 = arg_19_0._expeditions_selection_index
		local var_19_8 = arg_19_0._expedition_widgets[arg_19_0._expeditions_selection_index]

		for iter_19_2 = 1, #arg_19_0._expedition_widgets do
			local var_19_9 = arg_19_0._expedition_widgets[iter_19_2]

			if UIUtils.is_button_pressed(var_19_9) then
				if var_19_8 then
					var_19_8.content.button_hotspot.is_selected = nil
				end

				var_19_9.content.button_hotspot.is_selected = true

				local var_19_10 = var_19_9.content.journey_name

				var_19_0:set_selected_level_id(var_19_10)

				arg_19_0._expeditions_selection_index = iter_19_2

				arg_19_0:_play_sound("play_gui_lobby_button_01_difficulty_select_normal")
			end

			if UIUtils.is_button_hover_enter(var_19_9) then
				arg_19_0._parent:play_sound("Play_hud_hover")
			end
		end

		local var_19_11 = arg_19_0._widgets_by_name.upsell_button

		if UIUtils.is_button_pressed(var_19_11) then
			Managers.unlock:open_dlc_page(arg_19_0._dlc_name)
		end

		if arg_19_0:_can_play() then
			local var_19_12 = arg_19_0._selection_widgets_by_name

			if UIUtils.is_button_hover_enter(var_19_12.play_button) then
				arg_19_0._parent:play_sound("Play_hud_hover")
			end

			if var_19_1:get(var_0_9) or UIUtils.is_button_pressed(var_19_12.play_button) then
				local var_19_13 = var_19_0:get_twitch_settings(arg_19_0._mechanism_name) or var_19_0:get_twitch_settings("adventure")

				arg_19_0._parent:set_difficulty_option(arg_19_0._current_difficulty)
				var_19_0:play(arg_19_2, var_19_13.game_mode_type)

				arg_19_0._play_button_pressed = true
			end
		end
	end

	arg_19_0:_update_gamemode_info_text(var_19_1)
	arg_19_0:_handle_twitch_login_input(arg_19_1, arg_19_2, var_19_1)
end

StartGameWindowDeusTwitch._update_input_description = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = Managers.twitch and Managers.twitch:is_connected()

	arg_20_0:_set_input_description(var_20_0)
end

StartGameWindowDeusTwitch._update_modifiers = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = Managers.time:time("main")
	local var_21_1 = arg_21_0._journey_cycle

	if not var_21_1 or var_0_12(var_21_1, var_21_0) then
		arg_21_0:_refresh_journey_cycle()
	end
end

StartGameWindowDeusTwitch._update_expedition_option = function (arg_22_0)
	local var_22_0 = arg_22_0._parent:get_selected_level_id()

	if not var_22_0 then
		return
	end

	local var_22_1 = LevelSettings[var_22_0]
	local var_22_2 = var_22_1.display_name
	local var_22_3 = var_22_1.level_image
	local var_22_4 = arg_22_0._parent:get_completed_level_difficulty_index(arg_22_0._statistics_db, arg_22_0._stats_id, var_22_0)

	for iter_22_0 = 1, #arg_22_0._expedition_widgets do
		local var_22_5 = arg_22_0._expedition_widgets[iter_22_0].content

		if var_22_0 == var_22_5.journey_name then
			var_22_5.button_hotspot.is_selected = true
			arg_22_0._expeditions_selection_index = iter_22_0

			break
		end
	end
end

StartGameWindowDeusTwitch._update_button_animations = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._widgets_by_name

	arg_23_0:_animate_button(var_23_0.button_1, arg_23_1)
	arg_23_0:_animate_button(var_23_0.button_2, arg_23_1)
end

StartGameWindowDeusTwitch._update_animations = function (arg_24_0, arg_24_1, arg_24_2)
	if not IS_PS4 and not Managers.input:is_device_active("gamepad") then
		arg_24_0:_update_button_animations(arg_24_1)
	end

	local var_24_0 = arg_24_0._ui_animator

	var_24_0:update(arg_24_1)

	local var_24_1 = arg_24_0._animations

	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		if var_24_0:is_animation_completed(iter_24_1) then
			var_24_1[iter_24_0] = nil
		end
	end

	local var_24_2 = arg_24_0._expedition_widgets

	for iter_24_2 = 1, #var_24_2 do
		local var_24_3 = var_24_2[iter_24_2]

		arg_24_0:_animate_expedition_widget(var_24_3, arg_24_1)
	end
end

StartGameWindowDeusTwitch._draw = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._ui_top_renderer
	local var_25_1 = arg_25_0._ui_scenegraph
	local var_25_2 = arg_25_0._parent:window_input_service()
	local var_25_3 = arg_25_0._render_settings
	local var_25_4

	UIRenderer.begin_pass(var_25_0, var_25_1, var_25_2, arg_25_1, var_25_4, var_25_3)
	UIRenderer.draw_all_widgets(var_25_0, arg_25_0._widgets)
	UIRenderer.draw_all_widgets(var_25_0, arg_25_0._expedition_widgets)
	UIRenderer.draw_all_widgets(var_25_0, arg_25_0._selection_widgets)

	if arg_25_0._show_additional_settings then
		UIRenderer.draw_all_widgets(var_25_0, arg_25_0._additional_settings_widgets)
	end

	UIRenderer.end_pass(var_25_0)
end

StartGameWindowDeusTwitch._start_transition_animation = function (arg_26_0, arg_26_1)
	local var_26_0 = {
		render_settings = arg_26_0._render_settings
	}
	local var_26_1 = arg_26_0._ui_animator:start_animation(arg_26_1, nil, var_0_1, var_26_0)

	arg_26_0._animations[arg_26_1] = var_26_1
end

StartGameWindowDeusTwitch._animate_button = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_1.content.button_hotspot
	local var_27_1 = 20
	local var_27_2 = var_27_0.input_progress or 0
	local var_27_3 = var_27_0.is_clicked and var_27_0.is_clicked == 0
	local var_27_4 = UIUtils.animate_value(var_27_2, arg_27_2 * var_27_1, var_27_3)
	local var_27_5 = 8
	local var_27_6 = var_27_0.hover_progress or 0
	local var_27_7 = not var_27_0.disable_button and var_27_0.is_hover
	local var_27_8 = UIUtils.animate_value(var_27_6, arg_27_2 * var_27_5, var_27_7)
	local var_27_9 = var_27_0.selection_progress or 0
	local var_27_10 = not var_27_0.disable_button and var_27_0.is_selected
	local var_27_11 = UIUtils.animate_value(var_27_9, arg_27_2 * var_27_5, var_27_10)
	local var_27_12 = math.max(var_27_8, var_27_11)
	local var_27_13 = arg_27_1.style

	var_27_13.clicked_rect.color[1] = 100 * var_27_4

	local var_27_14 = "hover_glow"
	local var_27_15 = 255 * var_27_12

	var_27_13[var_27_14].color[1] = var_27_15

	local var_27_16 = var_27_13.text
	local var_27_17 = var_27_16.text_color
	local var_27_18 = var_27_16.default_text_color
	local var_27_19 = var_27_16.select_text_color

	Colors.lerp_color_tables(var_27_18, var_27_19, var_27_12, var_27_17)

	var_27_0.hover_progress = var_27_8
	var_27_0.input_progress = var_27_4
	var_27_0.selection_progress = var_27_11
end

StartGameWindowDeusTwitch._animate_expedition_widget = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1.content.button_hotspot
	local var_28_1 = var_28_0.is_selected
	local var_28_2 = var_28_0.selected_progress or 0
	local var_28_3 = 1.5
	local var_28_4 = UIUtils.animate_value(var_28_2, var_28_3 * arg_28_2, var_28_1)

	arg_28_1.style.purple_glow.color[1] = 255 * var_28_4
	var_28_0.selected_progress = var_28_4
end

StartGameWindowDeusTwitch._play_sound = function (arg_29_0, arg_29_1)
	arg_29_0._parent:play_sound(arg_29_1)
end

StartGameWindowDeusTwitch._handle_virtual_keyboard = function (arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_0._virtual_keyboard_id then
		return
	end

	if IS_XB1 then
		if not XboxInterface.interface_active() then
			local var_30_0 = XboxInterface.get_keyboard_result()

			arg_30_0._virtual_keyboard_id = nil

			local var_30_1 = string.gsub(var_30_0, " ", "")

			if var_30_1 then
				PlayerData.twitch_user_name = var_30_1
			end

			arg_30_0._widgets_by_name.frame_widget.content.twitch_name = var_30_1

			Managers.twitch:connect(var_30_1, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_30_0, "cb_connection_success_callback"))
			arg_30_0:_play_sound("Play_hud_select")
		end
	else
		local var_30_2, var_30_3, var_30_4 = Managers.system_dialog:poll_virtual_keyboard(arg_30_0._virtual_keyboard_id)

		if var_30_2 then
			arg_30_0._virtual_keyboard_id = nil

			if var_30_3 then
				local var_30_5 = string.gsub(var_30_4, " ", "")

				if var_30_5 then
					PlayerData.twitch_user_name = var_30_5
				end

				arg_30_0._widgets_by_name.frame_widget.content.twitch_name = var_30_5

				Managers.twitch:connect(var_30_5, callback(Managers.twitch, "cb_connection_error_callback"), callback(arg_30_0, "cb_connection_success_callback"))
				arg_30_0:_play_sound("Play_hud_select")
			end
		end
	end
end

StartGameWindowDeusTwitch._handle_gamepad_activity = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not arg_31_0.gamepad_active_last_frame or var_31_0 then
			arg_31_0.gamepad_active_last_frame = true
			arg_31_0._input_index = 1

			local var_31_1 = var_0_8[arg_31_0._input_index]

			if var_31_1 and var_31_1.enter_requirements(arg_31_0) then
				var_31_1.on_enter(arg_31_0)
			end
		end
	elseif arg_31_0.gamepad_active_last_frame or var_31_0 then
		arg_31_0.gamepad_active_last_frame = false

		local var_31_2 = var_0_8[arg_31_0._input_index]

		if var_31_2 then
			var_31_2.on_exit(arg_31_0)
		end
	end
end

StartGameWindowDeusTwitch._verify_selection_index = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._input_index
	local var_32_1 = #var_0_8

	arg_32_1 = math.clamp(arg_32_1, 1, var_32_1)

	if not arg_32_2 then
		return arg_32_1
	end

	local var_32_2 = var_0_8[arg_32_1]

	while var_32_2 and arg_32_1 < var_32_1 and not var_32_2.enter_requirements(arg_32_0) do
		arg_32_1 = arg_32_1 + arg_32_2
		var_32_2 = var_0_8[arg_32_1]
	end

	if var_32_2 and var_32_2.enter_requirements(arg_32_0) then
		var_32_0 = arg_32_1
	end

	return var_32_0
end

StartGameWindowDeusTwitch._gamepad_selector_input_func = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = Managers.input:is_device_active("mouse")

	arg_33_1 = arg_33_0:_verify_selection_index(arg_33_1, arg_33_2)

	if arg_33_0._input_index ~= arg_33_1 and not var_33_0 then
		arg_33_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if arg_33_0._input_index then
			var_0_8[arg_33_0._input_index].on_exit(arg_33_0)
		end

		var_0_8[arg_33_1].on_enter(arg_33_0)
	end

	arg_33_0._input_index = arg_33_1
end

StartGameWindowDeusTwitch._update_difficulty_option = function (arg_34_0, arg_34_1)
	if arg_34_1 then
		local var_34_0 = DifficultySettings[arg_34_1]
		local var_34_1 = arg_34_0._selection_widgets_by_name.difficulty_stepper

		var_34_1.content.selected_difficulty_text = Localize(var_34_0.display_name)

		local var_34_2 = var_34_0.display_image

		var_34_1.content.difficulty_icon = var_34_2

		arg_34_0:_set_info_window(arg_34_1)

		arg_34_0._current_difficulty = arg_34_1
	end
end

StartGameWindowDeusTwitch._option_selected = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0._parent
	local var_35_1 = var_35_0:get_twitch_settings(arg_35_0._mechanism_name) or var_35_0:get_twitch_settings("adventure")

	if arg_35_1 == "difficulty_stepper" then
		local var_35_2 = arg_35_0._current_difficulty
		local var_35_3 = GameModeSettings.deus.difficulties
		local var_35_4 = table.find(var_35_3, var_35_2)
		local var_35_5 = 0

		if arg_35_2 == "left_arrow" then
			if var_35_4 - 1 >= 1 then
				var_35_5 = var_35_4 - 1

				arg_35_0._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif arg_35_2 == "right_arrow" and var_35_4 + 1 <= #var_35_3 then
			var_35_5 = var_35_4 + 1

			arg_35_0._parent:play_sound("hud_morris_start_menu_set")
		end

		arg_35_0:_update_difficulty_option(var_35_3[var_35_5])
	elseif arg_35_1 == "play_button" then
		arg_35_0._play_button_pressed = true

		arg_35_0._parent:set_difficulty_option(arg_35_0._current_difficulty)
		arg_35_0._parent:play(arg_35_3, var_35_1.game_mode_type)
	else
		ferror("Unknown selector_input_definition: %s", arg_35_1)
	end
end

StartGameWindowDeusTwitch._set_input_description = function (arg_36_0, arg_36_1)
	if arg_36_0._is_server then
		if arg_36_1 then
			local var_36_0 = arg_36_0._dlc_locked and "deus_twitch_buy_connected" or "deus_default_twitch_connected"

			arg_36_0._parent:change_generic_actions(var_36_0)
		else
			local var_36_1 = arg_36_0._dlc_locked and "deus_twitch_buy" or "deus_default_twitch"

			arg_36_0._parent:change_generic_actions(var_36_1)
		end
	elseif arg_36_1 then
		arg_36_0._parent:change_generic_actions("deus_default_twitch_client_connected")
	else
		arg_36_0._parent:change_generic_actions("deus_default_twitch_client")
	end

	arg_36_0._input_description_connected = arg_36_1
end

StartGameWindowDeusTwitch._update_can_play = function (arg_37_0, arg_37_1, arg_37_2)
	if arg_37_0._is_server then
		local var_37_0 = arg_37_0:_can_play()

		if arg_37_0._previous_can_play ~= var_37_0 then
			arg_37_0._previous_can_play = var_37_0
			arg_37_0._selection_widgets_by_name.play_button.content.button_hotspot.disable_button = not var_37_0

			if var_37_0 then
				arg_37_0._parent:set_input_description("play_available")
			else
				arg_37_0._parent:set_input_description(nil)
			end
		end
	end
end

StartGameWindowDeusTwitch._can_play = function (arg_38_0)
	if not arg_38_0._is_server then
		return false
	end

	local var_38_0 = arg_38_0._parent:get_selected_level_id()
	local var_38_1 = Managers.twitch and Managers.twitch:is_connected()

	return var_38_0 ~= nil and var_38_1 and not arg_38_0._dlc_locked
end

StartGameWindowDeusTwitch.on_exit = function (arg_39_0, arg_39_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowTwitchOverviewConsole")

	arg_39_0._ui_animator = nil

	if arg_39_0._play_button_pressed then
		arg_39_1.input_index = nil
	else
		arg_39_1.input_index = arg_39_0._input_index
	end

	arg_39_0._parent:set_difficulty_option(arg_39_0._current_difficulty)
	arg_39_0:_set_active(false)
	Managers.state.event:unregister("_update_additional_curse_frame", arg_39_0)
end

StartGameWindowDeusTwitch._set_info_window = function (arg_40_0, arg_40_1)
	local var_40_0 = DifficultySettings[arg_40_1]
	local var_40_1 = var_40_0.description
	local var_40_2 = var_40_0.max_chest_power_level
	local var_40_3 = arg_40_0._widgets_by_name.difficulty_info

	var_40_3.content.difficulty_description = Localize(var_40_1)
	var_40_3.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(var_40_2)
end

StartGameWindowDeusTwitch._update_difficulty_lock = function (arg_41_0)
	local var_41_0 = arg_41_0._current_difficulty
	local var_41_1 = arg_41_0._widgets_by_name.difficulty_info
	local var_41_2 = arg_41_0._widgets_by_name.upsell_button

	if var_41_0 then
		local var_41_3, var_41_4, var_41_5, var_41_6 = arg_41_0._parent:is_difficulty_approved(var_41_0)

		if not var_41_3 then
			if var_41_4 then
				var_41_1.content.should_show_diff_lock_text = true
				var_41_1.content.difficulty_lock_text = var_41_4 and Localize(var_41_4) or ""
			else
				var_41_1.content.should_show_diff_lock_text = false
			end

			if var_41_5 then
				var_41_1.content.should_show_dlc_lock = true
				arg_41_0._dlc_locked = var_41_5
				arg_41_0._dlc_name = var_41_5
				var_41_2.content.visible = true
			else
				var_41_1.content.should_show_dlc_lock = false
				var_41_2.content.visible = false
				arg_41_0._dlc_locked = nil
				arg_41_0._dlc_name = nil
			end
		else
			var_41_1.content.should_show_dlc_lock = false
			var_41_1.content.should_show_diff_lock_text = false
			var_41_1.content.should_resize = false
			var_41_2.content.visible = false
			arg_41_0._dlc_locked = nil
			arg_41_0._dlc_name = nil
		end

		arg_41_0._difficulty_approved = var_41_3
	else
		var_41_1.content.should_show_dlc_lock = false
		var_41_2.content.visible = false
	end

	local var_41_7 = arg_41_0:_calculate_difficulty_info_widget_size(var_41_1)
	local var_41_8 = (math.floor(var_41_7) - var_0_1.difficulty_info.size[2]) / 2

	arg_41_0:_resize_difficulty_info({
		math.floor(var_0_1.difficulty_info.size[1]),
		math.floor(var_41_7)
	}, {
		0,
		-var_41_8,
		1
	})

	var_41_2.offset[2] = -math.floor(var_41_7) / 2 + 24
end

StartGameWindowDeusTwitch._calculate_difficulty_info_widget_size = function (arg_42_0, arg_42_1)
	local var_42_0 = 20
	local var_42_1 = arg_42_1.style.difficulty_description
	local var_42_2 = arg_42_1.content.difficulty_description
	local var_42_3 = UIUtils.get_text_height(arg_42_0._ui_renderer, var_42_1.size, var_42_1, var_42_2)

	arg_42_1.content.difficulty_description_text_size = var_42_3

	local var_42_4 = arg_42_1.style.highest_obtainable_level
	local var_42_5 = arg_42_1.content.highest_obtainable_level
	local var_42_6 = UIUtils.get_text_height(arg_42_0._ui_renderer, var_42_4.size, var_42_4, var_42_5) + var_42_0
	local var_42_7 = arg_42_1.style.difficulty_lock_text
	local var_42_8 = arg_42_1.content.difficulty_lock_text
	local var_42_9 = 0

	if arg_42_1.content.should_show_diff_lock_text then
		var_42_9 = UIUtils.get_text_height(arg_42_0._ui_renderer, var_42_7.size, var_42_7, var_42_8) + var_42_0
		arg_42_1.content.difficulty_lock_text_height = var_42_9
	end

	local var_42_10 = arg_42_1.style.dlc_lock_text
	local var_42_11 = arg_42_1.content.dlc_lock_text
	local var_42_12 = 0

	if arg_42_1.content.should_show_dlc_lock then
		var_42_12 = UIUtils.get_text_height(arg_42_0._ui_renderer, var_42_10.size, var_42_10, var_42_11) + var_42_0
	end

	return var_42_6 + var_42_3 + var_42_9 + var_42_12 + 50
end

StartGameWindowDeusTwitch._resize_difficulty_info = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._widgets_by_name.difficulty_info

	var_43_0.content.should_resize = true
	var_43_0.content.resize_size = arg_43_1
	var_43_0.content.resize_offset = arg_43_2
	var_43_0.style.widget_hotspot.size = arg_43_1
	var_43_0.style.widget_hotspot.offset = arg_43_2
end

StartGameWindowDeusTwitch._update_gamemode_info_text = function (arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._widgets_by_name.twitch_gamemode_info_box

	if arg_44_1:get("trigger_cycle_next") and not var_44_0.content.is_showing_info then
		arg_44_0._ui_animator:start_animation("gamemode_text_swap", var_44_0, var_0_1)

		var_44_0.content.is_showing_info = true
	elseif arg_44_1:get("trigger_cycle_next") and var_44_0.content.is_showing_info then
		arg_44_0._ui_animator:start_animation("gamemode_text_swap", var_44_0, var_0_1)

		var_44_0.content.is_showing_info = false
	end

	if UIUtils.is_button_pressed(var_44_0, "info_hotspot") then
		if not var_44_0.content.is_showing_info then
			arg_44_0._ui_animator:start_animation("gamemode_text_swap", var_44_0, var_0_1)

			var_44_0.content.is_showing_info = true
		else
			arg_44_0._ui_animator:start_animation("gamemode_text_swap", var_44_0, var_0_1)

			var_44_0.content.is_showing_info = false
		end
	end
end

StartGameWindowDeusTwitch._update_additional_curse_frame = function (arg_45_0, arg_45_1)
	for iter_45_0, iter_45_1 in ipairs(arg_45_0._expedition_widgets) do
		local var_45_0 = iter_45_1.content

		var_45_0.level_icon_frame = var_45_0.journey_name == arg_45_1 and "morris_expedition_select_border_belakor" or "morris_expedition_select_border"
	end
end
