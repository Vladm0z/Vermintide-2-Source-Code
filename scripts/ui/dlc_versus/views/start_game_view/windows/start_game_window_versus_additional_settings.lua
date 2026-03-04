-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_additional_settings.lua

StartGameWindowVersusAdditionalSettings = class(StartGameWindowVersusAdditionalSettings, StartGameWindowAdditionalSettingsConsole)
StartGameWindowVersusAdditionalSettings.NAME = "StartGameWindowVersusAdditionalSettings"

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_additional_settings_definitions")

StartGameWindowVersusAdditionalSettings.create_ui_elements = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	StartGameWindowVersusAdditionalSettings.super.create_ui_elements(arg_1_0, var_0_0, arg_1_2, arg_1_3)
end

StartGameWindowVersusAdditionalSettings._set_additional_options_enabled_state = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0._widgets_by_name

	var_2_0.dedicated_servers_win_checkbox.content.button_hotspot.disable_button = not arg_2_1
	var_2_0.dedicated_servers_aws_checkbox.content.button_hotspot.disable_button = not arg_2_1
	var_2_0.player_hosted_checkbox.content.button_hotspot.disable_button = not arg_2_1
	arg_2_0._additional_option_enabled = arg_2_1
end

StartGameWindowVersusAdditionalSettings._handle_input = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.parent
	local var_3_1 = var_3_0:window_input_service()

	if arg_3_0._additional_option_enabled then
		if Managers.input:is_device_active("gamepad") then
			arg_3_0:_handle_gamepad_input(arg_3_1, arg_3_2, var_3_1)
		else
			arg_3_0:_handle_mouse_input(arg_3_1, arg_3_2, var_3_1)
		end

		local var_3_2 = arg_3_0._widgets_by_name
		local var_3_3 = var_3_2.dedicated_servers_win_checkbox
		local var_3_4 = var_3_2.dedicated_servers_aws_checkbox
		local var_3_5 = var_3_2.player_hosted_checkbox

		UIWidgetUtils.animate_default_checkbox_button_console(var_3_3, arg_3_1)
		UIWidgetUtils.animate_default_checkbox_button_console(var_3_4, arg_3_1)
		UIWidgetUtils.animate_default_checkbox_button_console(var_3_5, arg_3_1)

		if arg_3_0:_is_button_hover_enter(var_3_3) or arg_3_0:_is_button_hover_enter(var_3_4) or arg_3_0:_is_button_hover_enter(var_3_5) then
			arg_3_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local var_3_6 = arg_3_0:_is_other_option_button_selected(var_3_3, arg_3_0._dedicated_servers_win_checkbox_enabled)

		if var_3_6 ~= nil then
			var_3_0:set_dedicated_or_player_hosted_search(var_3_6, arg_3_0._dedicated_servers_aws_checkbox_enabled, arg_3_0._player_hosted_checkbox_enabled)
		end

		local var_3_7 = arg_3_0:_is_other_option_button_selected(var_3_4, arg_3_0._dedicated_servers_aws_checkbox_enabled)

		if var_3_7 ~= nil then
			var_3_0:set_dedicated_or_player_hosted_search(arg_3_0._dedicated_servers_win_checkbox_enabled, var_3_7, arg_3_0._player_hosted_checkbox_enabled)
		end

		local var_3_8 = arg_3_0:_is_other_option_button_selected(var_3_5, arg_3_0._player_hosted_checkbox_enabled)

		if var_3_8 ~= nil then
			var_3_0:set_dedicated_or_player_hosted_search(arg_3_0._dedicated_servers_win_checkbox_enabled, arg_3_0._dedicated_servers_aws_checkbox_enabled, var_3_8)
		end
	end

	if arg_3_0.gamepad_active_last_frame then
		local var_3_9 = true

		if var_3_1:get("back_menu", var_3_9) or var_3_1:get("refresh", var_3_9) or var_3_1:get("right_stick_press", var_3_9) then
			var_3_0:set_window_input_focus(arg_3_0._parent_window_name or "custom_game_overview")
		end
	end
end

StartGameWindowVersusAdditionalSettings._update_additional_options = function (arg_4_0)
	local var_4_0 = arg_4_0.parent
	local var_4_1 = var_4_0:using_player_hosted_search()
	local var_4_2, var_4_3 = var_4_0:using_dedicated_servers_search()
	local var_4_4 = arg_4_0._network_lobby:members():get_member_count() == 1

	if var_4_4 ~= arg_4_0._is_alone or var_4_1 ~= arg_4_0._player_hosted_enabled or var_4_2 ~= arg_4_0._dedicated_servers_win_enabled or var_4_3 ~= arg_4_0._dedicated_servers_aws_enabled then
		local var_4_5 = arg_4_0._widgets_by_name

		var_4_5.player_hosted_checkbox.content.button_hotspot.is_selected = var_4_1

		local var_4_6 = var_4_5.dedicated_servers_win_checkbox.content.button_hotspot

		var_4_6.is_selected = var_4_2
		var_4_6.disable_button = not var_4_3

		local var_4_7 = var_4_5.dedicated_servers_aws_checkbox.content.button_hotspot

		var_4_7.is_selected = var_4_3
		var_4_7.disable_button = not var_4_2
		arg_4_0._dedicated_servers_win_checkbox_enabled = var_4_2
		arg_4_0._dedicated_servers_aws_checkbox_enabled = var_4_3
		arg_4_0._player_hosted_checkbox_enabled = var_4_1
		arg_4_0._is_alone = var_4_4
	end
end
