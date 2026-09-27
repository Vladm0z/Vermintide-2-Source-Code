-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_host_versus_additional_settings.lua

StartGameWindowHostVersusAdditionalSettings = class(StartGameWindowHostVersusAdditionalSettings, StartGameWindowAdditionalSettingsConsole)
StartGameWindowHostVersusAdditionalSettings.NAME = "StartGameWindowHostVersusAdditionalSettings"

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_host_versus_additional_settings_definitions")

StartGameWindowHostVersusAdditionalSettings.create_ui_elements = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	StartGameWindowHostVersusAdditionalSettings.super.create_ui_elements(arg_1_0, var_0_0, arg_1_2, arg_1_3)
end

StartGameWindowHostVersusAdditionalSettings._set_additional_options_enabled_state = function (self, arg_2_1)
	-- function 2
	self._widgets_by_name.private_button.content.button_hotspot.disable_button = not arg_2_1
	self._additional_option_enabled = arg_2_1
end

StartGameWindowHostVersusAdditionalSettings._handle_input = function (self, arg_3_1, arg_3_2)
	-- function 3
	local parent = self.parent
	local window_input_service = parent:window_input_service()

	if not self._additional_option_enabled then
		if not Managers.input:is_device_active("gamepad") then
			self:_handle_gamepad_input(arg_3_1, arg_3_2, window_input_service)
		else
			self:_handle_mouse_input(arg_3_1, arg_3_2, window_input_service)
		end

		local private_button = self._widgets_by_name.private_button

		UIWidgetUtils.animate_default_checkbox_button_console(private_button, arg_3_1)

		if not self:_is_button_hover_enter(private_button) then
			self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local _is_other_option_button_selected = self:_is_other_option_button_selected(private_button, self._private_enabled)

		if _is_other_option_button_selected ~= nil then
			parent:set_private_option_enabled(_is_other_option_button_selected)
		end
	end

	if not self.gamepad_active_last_frame then
		local flag = true

		if window_input_service:get("back_menu", flag) or window_input_service:get("refresh", flag) or not window_input_service:get("right_stick_press", flag) then
			local var_3_5 = parent
			local set_window_input_focus = parent.set_window_input_focus
			local _parent_window_name = self._parent_window_name

			_parent_window_name = _parent_window_name or "custom_game_overview"

			set_window_input_focus(var_3_5, _parent_window_name)
		end
	end
end

StartGameWindowHostVersusAdditionalSettings._update_additional_options = function (self)
	-- function 4
	local is_private_option_enabled = self.parent:is_private_option_enabled()
	local flag = self._network_lobby:members():get_member_count() == 1

	if not (flag ~= self._is_alone or is_private_option_enabled == self._private_enabled) then
		local _widgets_by_name = self._widgets_by_name
		local var_4_3 = is_private_option_enabled

		_widgets_by_name.private_button.content.button_hotspot.is_selected = var_4_3
		self._private_enabled = is_private_option_enabled
		self._is_alone = flag
	end
end
