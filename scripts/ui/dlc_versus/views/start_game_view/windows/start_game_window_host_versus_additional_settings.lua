-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_host_versus_additional_settings.lua

StartGameWindowHostVersusAdditionalSettings = class(StartGameWindowHostVersusAdditionalSettings, StartGameWindowAdditionalSettingsConsole)
StartGameWindowHostVersusAdditionalSettings.NAME = "StartGameWindowHostVersusAdditionalSettings"

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_host_versus_additional_settings_definitions")

StartGameWindowHostVersusAdditionalSettings.create_ui_elements = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	StartGameWindowHostVersusAdditionalSettings.super.create_ui_elements(arg_1_0, var_0_0, arg_1_2, arg_1_3)
end

StartGameWindowHostVersusAdditionalSettings._set_additional_options_enabled_state = function (arg_2_0, arg_2_1)
	arg_2_0._widgets_by_name.private_button.content.button_hotspot.disable_button = not arg_2_1
	arg_2_0._additional_option_enabled = arg_2_1
end

StartGameWindowHostVersusAdditionalSettings._handle_input = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.parent
	local var_3_1 = var_3_0:window_input_service()

	if arg_3_0._additional_option_enabled then
		if Managers.input:is_device_active("gamepad") then
			arg_3_0:_handle_gamepad_input(arg_3_1, arg_3_2, var_3_1)
		else
			arg_3_0:_handle_mouse_input(arg_3_1, arg_3_2, var_3_1)
		end

		local var_3_2 = arg_3_0._widgets_by_name.private_button

		UIWidgetUtils.animate_default_checkbox_button_console(var_3_2, arg_3_1)

		if arg_3_0:_is_button_hover_enter(var_3_2) then
			arg_3_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local var_3_3 = arg_3_0:_is_other_option_button_selected(var_3_2, arg_3_0._private_enabled)

		if var_3_3 ~= nil then
			var_3_0:set_private_option_enabled(var_3_3)
		end
	end

	if arg_3_0.gamepad_active_last_frame then
		local var_3_4 = true

		if var_3_1:get("back_menu", var_3_4) or var_3_1:get("refresh", var_3_4) or var_3_1:get("right_stick_press", var_3_4) then
			var_3_0:set_window_input_focus(arg_3_0._parent_window_name or "custom_game_overview")
		end
	end
end

StartGameWindowHostVersusAdditionalSettings._update_additional_options = function (arg_4_0)
	local var_4_0 = arg_4_0.parent:is_private_option_enabled()
	local var_4_1 = arg_4_0._network_lobby:members():get_member_count() == 1

	if var_4_1 ~= arg_4_0._is_alone or var_4_0 ~= arg_4_0._private_enabled then
		local var_4_2 = arg_4_0._widgets_by_name
		local var_4_3 = var_4_0

		var_4_2.private_button.content.button_hotspot.is_selected = var_4_3
		arg_4_0._private_enabled = var_4_0
		arg_4_0._is_alone = var_4_1
	end
end
