-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_additional_settings.lua

StartGameWindowVersusAdditionalSettings = class(StartGameWindowVersusAdditionalSettings, StartGameWindowAdditionalSettingsConsole)
StartGameWindowVersusAdditionalSettings.NAME = "StartGameWindowVersusAdditionalSettings"

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_additional_settings_definitions")

StartGameWindowVersusAdditionalSettings.create_ui_elements = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	StartGameWindowVersusAdditionalSettings.super.create_ui_elements(arg_1_0, var_0_0, arg_1_2, arg_1_3)
end

StartGameWindowVersusAdditionalSettings._set_additional_options_enabled_state = function (self, arg_2_1)
	-- function 2
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.dedicated_servers_win_checkbox.content.button_hotspot.disable_button = not arg_2_1
	_widgets_by_name.dedicated_servers_aws_checkbox.content.button_hotspot.disable_button = not arg_2_1
	_widgets_by_name.player_hosted_checkbox.content.button_hotspot.disable_button = not arg_2_1
	self._additional_option_enabled = arg_2_1
end

StartGameWindowVersusAdditionalSettings._handle_input = function (self, arg_3_1, arg_3_2)
	-- function 3
	local parent = self.parent
	local window_input_service = parent:window_input_service()

	if not self._additional_option_enabled then
		if not Managers.input:is_device_active("gamepad") then
			self:_handle_gamepad_input(arg_3_1, arg_3_2, window_input_service)
		else
			self:_handle_mouse_input(arg_3_1, arg_3_2, window_input_service)
		end

		local _widgets_by_name = self._widgets_by_name
		local dedicated_servers_win_checkbox = _widgets_by_name.dedicated_servers_win_checkbox
		local dedicated_servers_aws_checkbox = _widgets_by_name.dedicated_servers_aws_checkbox
		local player_hosted_checkbox = _widgets_by_name.player_hosted_checkbox

		UIWidgetUtils.animate_default_checkbox_button_console(dedicated_servers_win_checkbox, arg_3_1)
		UIWidgetUtils.animate_default_checkbox_button_console(dedicated_servers_aws_checkbox, arg_3_1)
		UIWidgetUtils.animate_default_checkbox_button_console(player_hosted_checkbox, arg_3_1)

		if self:_is_button_hover_enter(dedicated_servers_win_checkbox) or self:_is_button_hover_enter(dedicated_servers_aws_checkbox) or not self:_is_button_hover_enter(player_hosted_checkbox) then
			self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local _is_other_option_button_selected = self:_is_other_option_button_selected(dedicated_servers_win_checkbox, self._dedicated_servers_win_checkbox_enabled)

		if _is_other_option_button_selected ~= nil then
			parent:set_dedicated_or_player_hosted_search(_is_other_option_button_selected, self._dedicated_servers_aws_checkbox_enabled, self._player_hosted_checkbox_enabled)
		end

		local _is_other_option_button_selected_2 = self:_is_other_option_button_selected(dedicated_servers_aws_checkbox, self._dedicated_servers_aws_checkbox_enabled)

		if _is_other_option_button_selected_2 ~= nil then
			parent:set_dedicated_or_player_hosted_search(self._dedicated_servers_win_checkbox_enabled, _is_other_option_button_selected_2, self._player_hosted_checkbox_enabled)
		end

		local _is_other_option_button_selected_3 = self:_is_other_option_button_selected(player_hosted_checkbox, self._player_hosted_checkbox_enabled)

		if _is_other_option_button_selected_3 ~= nil then
			parent:set_dedicated_or_player_hosted_search(self._dedicated_servers_win_checkbox_enabled, self._dedicated_servers_aws_checkbox_enabled, _is_other_option_button_selected_3)
		end
	end

	if not self.gamepad_active_last_frame then
		local flag = true

		if window_input_service:get("back_menu", flag) or window_input_service:get("refresh", flag) or not window_input_service:get("right_stick_press", flag) then
			local var_3_10 = parent
			local set_window_input_focus = parent.set_window_input_focus
			local _parent_window_name = self._parent_window_name

			_parent_window_name = _parent_window_name or "custom_game_overview"

			set_window_input_focus(var_3_10, _parent_window_name)
		end
	end
end

StartGameWindowVersusAdditionalSettings._update_additional_options = function (self)
	-- function 4
	local parent = self.parent
	local using_player_hosted_search = parent:using_player_hosted_search()
	local using_dedicated_servers_search, var_4_3 = parent:using_dedicated_servers_search()
	local flag = self._network_lobby:members():get_member_count() == 1

	if not (flag ~= self._is_alone or using_player_hosted_search ~= self._player_hosted_enabled or using_dedicated_servers_search ~= self._dedicated_servers_win_enabled or var_4_3 == self._dedicated_servers_aws_enabled) then
		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.player_hosted_checkbox.content.button_hotspot.is_selected = using_player_hosted_search

		local button_hotspot = _widgets_by_name.dedicated_servers_win_checkbox.content.button_hotspot

		button_hotspot.is_selected = using_dedicated_servers_search
		button_hotspot.disable_button = not var_4_3

		local button_hotspot_2 = _widgets_by_name.dedicated_servers_aws_checkbox.content.button_hotspot

		button_hotspot_2.is_selected = var_4_3
		button_hotspot_2.disable_button = not using_dedicated_servers_search
		self._dedicated_servers_win_checkbox_enabled = using_dedicated_servers_search
		self._dedicated_servers_aws_checkbox_enabled = var_4_3
		self._player_hosted_checkbox_enabled = using_player_hosted_search
		self._is_alone = flag
	end
end
