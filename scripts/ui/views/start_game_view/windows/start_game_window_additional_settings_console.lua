-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_additional_settings_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_additional_settings_console_definitions")

StartGameWindowAdditionalSettingsConsole = class(StartGameWindowAdditionalSettingsConsole)
StartGameWindowAdditionalSettingsConsole.NAME = "StartGameWindowAdditionalSettingsConsole"

StartGameWindowAdditionalSettingsConsole.on_enter = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowAdditionalSettingsConsole")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._mechanism_name = arg_1_1.mechanism_name
	self._params = arg_1_1
	self._parent_window_name = arg_1_3

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(var_0_0, arg_1_1, arg_1_2)
	self:_update_additional_options()

	self._input_index = 0

	self:_handle_input_index(1)

	self._is_focused = false
	self._versus_custom_lobby_view_active = arg_1_1.versus_custom_lobby_view_active
end

StartGameWindowAdditionalSettingsConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, self._scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowAdditionalSettingsConsole.create_ui_elements = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self._widget_definitions = arg_3_1.widgets
	self._scenegraph_definition = arg_3_1.scenegraph_definition
	self._animation_definitions = arg_3_1.animation_definitions
	self._gamepad_widget_navigation = arg_3_1.gamepad_widget_navigation

	local init_scenegraph = UISceneGraph.init_scenegraph(self._scenegraph_definition)

	self.ui_scenegraph = init_scenegraph
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(self._widget_definitions)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, self._animation_definitions)

	if not arg_3_3 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_3[1]
		local_position[2] = local_position[2] + arg_3_3[2]
		local_position[3] = local_position[3] + arg_3_3[3]
	end

	self:_set_additional_options_enabled_state(true)
end

StartGameWindowAdditionalSettingsConsole._set_additional_options_enabled_state = function (self, arg_4_1)
	-- function 4
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.private_button.content.button_hotspot.disable_button = not arg_4_1
	_widgets_by_name.host_button.content.button_hotspot.disable_button = not arg_4_1
	_widgets_by_name.strict_matchmaking_button.content.button_hotspot.disable_button = not arg_4_1
	self._additional_option_enabled = arg_4_1
end

StartGameWindowAdditionalSettingsConsole.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowAdditionalSettingsConsole")

	self.ui_animator = nil

	Managers.state.event:unregister("versus_custom_lobby_state_changed", self)
end

StartGameWindowAdditionalSettingsConsole.set_focus = function (self, arg_6_1)
	-- function 6
	self._is_focused = arg_6_1

	if not arg_6_1 then
		self:_start_transition_animation("on_enter")
	else
		self.render_settings.alpha_multiplier = 0
	end
end

StartGameWindowAdditionalSettingsConsole.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if self._mechanism_name ~= "versus" or not Managers.matchmaking:is_matchmaking_versus() then
		return
	end

	if not self._additional_option_enabled then
		self:_update_additional_options()
	end

	self:_update_animations(arg_7_1)

	if not (self._is_focused or self.gamepad_active_last_frame) then
		self:_handle_input(arg_7_1, arg_7_2)
	end

	self:_handle_gamepad_activity()
	self:draw(arg_7_1)
end

StartGameWindowAdditionalSettingsConsole.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

StartGameWindowAdditionalSettingsConsole._update_animations = function (self, arg_9_1)
	-- function 9
	local ui_animator = self.ui_animator

	ui_animator:update(arg_9_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowAdditionalSettingsConsole._is_button_released = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowAdditionalSettingsConsole._is_button_hover_enter = function (arg_11_0, arg_11_1)
	-- function 11
	return arg_11_1.content.button_hotspot.on_hover_enter
end

StartGameWindowAdditionalSettingsConsole._is_button_hover = function (arg_12_0, arg_12_1)
	-- function 12
	return arg_12_1.content.button_hotspot.is_hover
end

StartGameWindowAdditionalSettingsConsole._is_button_hover_exit = function (arg_13_0, arg_13_1)
	-- function 13
	return arg_13_1.content.button_hotspot.on_hover_exit
end

StartGameWindowAdditionalSettingsConsole._is_other_option_button_selected = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not self:_is_button_released(arg_14_1) then
		local flag = not arg_14_2

		if not flag then
			self:_play_sound("play_gui_lobby_button_03_private")
		else
			self:_play_sound("play_gui_lobby_button_03_public")
		end

		return flag
	end

	return nil
end

StartGameWindowAdditionalSettingsConsole._handle_input_index = function (self, arg_15_1)
	-- function 15
	local _input_index = self._input_index
	local _widgets_by_name = self._widgets_by_name

	repeat
		_input_index = _input_index + arg_15_1

		local var_15_2 = self._gamepad_widget_navigation[_input_index]

		if not var_15_2 then
			_input_index = self._input_index
		elseif not _widgets_by_name[var_15_2].content.button_hotspot.disable_button then
			self._input_index = _input_index
		end
	until self._input_index == _input_index
end

StartGameWindowAdditionalSettingsConsole._handle_gamepad_input = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local var_16_0

	if not arg_16_3:get("move_down") then
		var_16_0 = 1
	elseif not arg_16_3:get("move_up") then
		var_16_0 = -1
	end

	if not var_16_0 then
		self:_handle_input_index(var_16_0)
	end

	local _input_index = self._input_index
	local _widgets_by_name = self._widgets_by_name
	local option_tooltip = _widgets_by_name.option_tooltip
	local flag = false

	if not arg_16_3:get("confirm") then
		flag = true
	end

	local _gamepad_widget_navigation = self._gamepad_widget_navigation
	local count = #_gamepad_widget_navigation

	for i = 1, count do
		local var_16_7 = _widgets_by_name[_gamepad_widget_navigation[i]]
		local button_hotspot = var_16_7.content.button_hotspot
		local flag_2 = i == _input_index

		button_hotspot.is_hover = flag_2

		if not flag_2 then
			option_tooltip.content.text = var_16_7.content.tooltip_info.description

			if not flag then
				button_hotspot.on_release = true
			end
		end
	end
end

StartGameWindowAdditionalSettingsConsole._handle_mouse_input = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local _widgets_by_name = self._widgets_by_name
	local option_tooltip = _widgets_by_name.option_tooltip
	local flag = false
	local _gamepad_widget_navigation = self._gamepad_widget_navigation
	local count = #_gamepad_widget_navigation

	for i = 1, count do
		local var_17_5 = _widgets_by_name[_gamepad_widget_navigation[i]]

		if not self:_is_button_hover_enter(var_17_5) then
			option_tooltip.content.text = var_17_5.content.tooltip_info.description
		end

		if not self:_is_button_hover(var_17_5) then
			flag = true
		end
	end

	if not flag then
		option_tooltip.content.text = ""
	end
end

StartGameWindowAdditionalSettingsConsole._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	local parent = self.parent
	local window_input_service = parent:window_input_service()

	if not self._additional_option_enabled then
		if not Managers.input:is_device_active("gamepad") then
			self:_handle_gamepad_input(arg_18_1, arg_18_2, window_input_service)
		else
			self:_handle_mouse_input(arg_18_1, arg_18_2, window_input_service)
		end

		local _widgets_by_name = self._widgets_by_name
		local host_button = _widgets_by_name.host_button
		local private_button = _widgets_by_name.private_button
		local strict_matchmaking_button = _widgets_by_name.strict_matchmaking_button

		UIWidgetUtils.animate_default_checkbox_button_console(private_button, arg_18_1)
		UIWidgetUtils.animate_default_checkbox_button_console(host_button, arg_18_1)
		UIWidgetUtils.animate_default_checkbox_button_console(strict_matchmaking_button, arg_18_1)

		if self:_is_button_hover_enter(private_button) or self:_is_button_hover_enter(host_button) or not self:_is_button_hover_enter(strict_matchmaking_button) then
			self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local _is_other_option_button_selected = self:_is_other_option_button_selected(private_button, self._private_enabled)

		if _is_other_option_button_selected ~= nil then
			parent:set_private_option_enabled(_is_other_option_button_selected)
		end

		local _is_other_option_button_selected_2 = self:_is_other_option_button_selected(host_button, self._always_host_enabled)

		if _is_other_option_button_selected_2 ~= nil then
			parent:set_always_host_option_enabled(_is_other_option_button_selected_2)
		end

		local _is_other_option_button_selected_3 = self:_is_other_option_button_selected(strict_matchmaking_button, self._strict_matchmaking_enabled)

		if _is_other_option_button_selected_3 ~= nil then
			parent:set_strict_matchmaking_option_enabled(_is_other_option_button_selected_3)
		end
	end

	if not self.gamepad_active_last_frame then
		local flag = true

		if window_input_service:get("back_menu", flag) or window_input_service:get("refresh", flag) or not window_input_service:get("right_stick_press", flag) then
			local var_18_10 = parent
			local set_window_input_focus = parent.set_window_input_focus
			local _parent_window_name = self._parent_window_name

			_parent_window_name = _parent_window_name or "custom_game_overview"

			set_window_input_focus(var_18_10, _parent_window_name)
		end
	end
end

StartGameWindowAdditionalSettingsConsole._play_sound = function (self, arg_19_1)
	-- function 19
	self.parent:play_sound(arg_19_1)
end

StartGameWindowAdditionalSettingsConsole._update_additional_options = function (self)
	-- function 20
	local parent = self.parent
	local is_private_option_enabled = parent:is_private_option_enabled()
	local is_always_host_option_enabled = parent:is_always_host_option_enabled()
	local is_strict_matchmaking_option_enabled = parent:is_strict_matchmaking_option_enabled()
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	local flag = self._network_lobby:members():get_member_count() == 1

	if not (flag ~= self._is_alone or is_private_option_enabled ~= self._private_enabled or is_always_host_option_enabled ~= self._always_host_enabled or is_strict_matchmaking_option_enabled ~= self._strict_matchmaking_enabled or twitch == self._twitch_active) then
		local _widgets_by_name = self._widgets_by_name
		local button_hotspot

		button_hotspot.is_selected, button_hotspot.disable_button, button_hotspot = is_private_option_enabled, twitch, _widgets_by_name.private_button.content.button_hotspot

		local button_hotspot_2

		button_hotspot_2.is_selected, button_hotspot_2.disable_button, button_hotspot_2 = (is_private_option_enabled or not flag) and is_always_host_option_enabled, (is_private_option_enabled or not flag) and twitch, _widgets_by_name.host_button.content.button_hotspot

		local button_hotspot_3

		button_hotspot_3.is_selected, button_hotspot_3.disable_button, button_hotspot_3 = (not not is_always_host_option_enabled or not not is_private_option_enabled or not flag) and is_strict_matchmaking_option_enabled, (is_private_option_enabled or is_always_host_option_enabled or not flag) and twitch, _widgets_by_name.strict_matchmaking_button.content.button_hotspot
		self._private_enabled = is_private_option_enabled
		self._always_host_enabled = is_always_host_option_enabled
		self._strict_matchmaking_enabled = is_strict_matchmaking_option_enabled
		self._twitch_active = twitch
		self._is_alone = flag
	end
end

StartGameWindowAdditionalSettingsConsole.draw = function (self, arg_21_1)
	-- function 21
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, window_input_service, arg_21_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_21_4 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_21_4)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowAdditionalSettingsConsole._handle_gamepad_activity = function (self)
	-- function 22
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("gamepad") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true
			self.render_settings.alpha_multiplier = 0
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		if not self._is_focused then
			local parent = self.parent
			local var_22_2 = parent
			local set_window_input_focus = parent.set_window_input_focus
			local _parent_window_name = self._parent_window_name

			_parent_window_name = _parent_window_name or "custom_game_overview"

			set_window_input_focus(var_22_2, _parent_window_name)
		end

		self.render_settings.alpha_multiplier = 1
	end
end
