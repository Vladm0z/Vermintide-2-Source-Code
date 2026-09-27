-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_panel_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_panel_console_definitions")
local str = "cycle_next"
local str_2 = "cycle_previous"

StartGameWindowPanelConsole = class(StartGameWindowPanelConsole)
StartGameWindowPanelConsole.NAME = "StartGameWindowPanelConsole"

StartGameWindowPanelConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate StartGameWindowPanelConsole")

	self.params = arg_1_1
	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings
	self._mechanism_name = arg_1_1.mechanism_name
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(var_0_0, arg_1_1, arg_1_2)
	self:_setup_text_buttons_width_and_position()
	self:_setup_input_buttons()
end

StartGameWindowPanelConsole._create_ui_elements = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local scenegraph_definition = arg_2_1.scenegraph_definition
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(arg_2_1.widget_definitions)

	local tbl = {}
	local window_layouts = self._layout_settings.window_layouts
	local parent = self.parent

	for i = 1, #window_layouts do
		local var_2_5 = window_layouts[i]

		if not var_2_5.panel_sorting and not parent:can_add_layout(var_2_5) then
			local str = "game_mode_option"
			local size = scenegraph_definition[str].size
			local display_name = var_2_5.display_name

			display_name = display_name or "n/a"

			local num = 32
			local str_2 = "center"
			local create_panel_button = arg_2_1.create_panel_button(str, size, display_name, num, nil, str_2)
			local var_2_12 = UIWidget.init(create_panel_button)
			local name = var_2_5.name

			var_2_12.content.layout_name = name
			var_2_12.disable_function_name = var_2_5.disable_function_name
			var_2_12.is_layout_disabled = Managers.ui:is_ui_layout_disabled(name)
			tbl[#tbl + 1] = var_2_12
		end
	end

	self._title_button_widgets = tbl

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, arg_2_1.animation_definitions)

	if not arg_2_3 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_3[1]
		local_position[2] = local_position[2] + arg_2_3[2]
		local_position[3] = local_position[3] + arg_2_3[3]
	end
end

StartGameWindowPanelConsole._setup_text_buttons_width_and_position = function (self)
	-- function 3
	local ui_scenegraph = self.ui_scenegraph
	local var_3_1 = ui_scenegraph.panel_entry_area.size[1]
	local _title_button_widgets = self._title_button_widgets
	local count = #_title_button_widgets
	local floor = math.floor(var_3_1 / count)

	ui_scenegraph.game_mode_option.size[1] = floor

	for i = 1, count do
		local var_3_5 = _title_button_widgets[i]

		self:_set_text_button_size(var_3_5, floor)

		local num = floor * (i - 1)

		var_3_5.offset[1] = num
	end

	self._widgets_by_name.panel_input_area_2.offset[1] = floor * (count - 1)
end

StartGameWindowPanelConsole._set_text_button_size = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local style = arg_4_1.style

	style.selected_texture.texture_size[1] = arg_4_2

	local num = 5
	local num_2 = arg_4_2 - num * 2

	style.text.size[1] = num_2
	style.text_shadow.size[1] = num_2
	style.text_hover.size[1] = num_2
	style.text_disabled.size[1] = num_2
	style.text.offset[1] = style.text.default_offset[1] + num
	style.text_shadow.offset[1] = style.text_shadow.default_offset[1] + num
	style.text_hover.offset[1] = style.text_hover.default_offset[1] + num
	style.text_disabled.offset[1] = style.text_disabled.default_offset[1] + num
end

StartGameWindowPanelConsole.on_exit = function (self, arg_5_1)
	-- function 5
	print("[HeroViewWindow] Exit Substate StartGameWindowPanelConsole")

	self.ui_animator = nil
end

StartGameWindowPanelConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_handle_gamepad_activity()
	self:_handle_back_button_visibility()
	self:_update_title_buttons_disable_status()
	self:_update_selected_option()
	self:_update_animations(arg_6_1, arg_6_2)
	self:draw(arg_6_1)
end

StartGameWindowPanelConsole._update_selected_option = function (self)
	-- function 7
	local get_selected_layout_name = self.parent:get_selected_layout_name()

	if get_selected_layout_name ~= self._selected_layout_name then
		self:_set_selected_option(get_selected_layout_name)
	end
end

StartGameWindowPanelConsole._update_title_buttons_disable_status = function (self)
	-- function 8
	local _title_button_widgets = self._title_button_widgets

	for i = 1, #_title_button_widgets do
		local var_8_1 = _title_button_widgets[i]
		local flag = false

		if not var_8_1.is_layout_disabled then
			flag = true
		else
			local disable_function_name = var_8_1.disable_function_name

			if not disable_function_name then
				flag = self[disable_function_name](self)
			end
		end

		var_8_1.content.button_hotspot.disable_button = flag
	end
end

StartGameWindowPanelConsole.post_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:_handle_input(arg_9_1, arg_9_2)
end

StartGameWindowPanelConsole._update_animations = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_10_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	local ui_animator = self.ui_animator

	ui_animator:update(arg_10_1)

	local _animations = self._animations

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			_animations[k_2] = nil
		end
	end

	local _title_button_widgets = self._title_button_widgets

	for i4 = 1, #_title_button_widgets do
		self:_animate_title_entry(_title_button_widgets[i4], arg_10_1, arg_10_2)
	end

	self:_animate_back_button(self._widgets_by_name.back_button, arg_10_1)
	self:_animate_back_button(self._widgets_by_name.close_button, arg_10_1)
end

StartGameWindowPanelConsole._find_next_layout_name = function (self, arg_11_1)
	-- function 11
	local num = 1
	local _selected_layout_name = self._selected_layout_name
	local _title_button_widgets = self._title_button_widgets

	for i = 1, #_title_button_widgets do
		if _title_button_widgets[i].content.layout_name == _selected_layout_name then
			num = i

			break
		end
	end

	local var_11_3
	local var_11_4 = num
	local flag = false

	repeat
		var_11_4 = math.index_wrapper(var_11_4 + arg_11_1, #_title_button_widgets)

		local var_11_6 = _title_button_widgets[var_11_4]

		if var_11_4 == num then
			flag = true
		elseif not var_11_6.content.button_hotspot.disable_button then
			var_11_3 = var_11_6.content.layout_name
			flag = true
		end
	until not flag

	return var_11_3
end

StartGameWindowPanelConsole._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local flag = false
	local var_12_1
	local _title_button_widgets = self._title_button_widgets

	for i = 1, #_title_button_widgets do
		local var_12_3 = _title_button_widgets[i]

		if not UIUtils.is_button_selected(var_12_3) then
			if not UIUtils.is_button_hover_enter(var_12_3) then
				self:_play_sound("Play_hud_hover")
			end

			if not UIUtils.is_button_pressed(var_12_3) then
				var_12_1 = var_12_3.content.layout_name
				flag = true
			end
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local close_button = _widgets_by_name.close_button
	local back_button = _widgets_by_name.back_button

	if UIUtils.is_button_hover_enter(back_button) or not UIUtils.is_button_hover_enter(close_button) then
		self:_play_sound("Play_hud_hover")
	end

	local parent = self.parent

	if parent:close_on_exit() or flag or not UIUtils.is_button_pressed(back_button) then
		local var_12_8
		local params = self.params

		if not params then
			var_12_8 = params.return_layout_name
			params.return_layout_name = nil
		end

		var_12_8 = var_12_8 or parent:get_previous_selected_layout_name()

		if not var_12_8 then
			self:_reset_back_button()

			var_12_1 = var_12_8
			flag = true
		end
	end

	if flag or not UIUtils.is_button_pressed(close_button) then
		parent:close_menu()

		flag = true
	end

	if not (flag or self.parent:panel_title_buttons_hidden()) then
		local window_input_service = parent:window_input_service()
		local num

		if not window_input_service:get(str_2) then
			num = -1
		else
			num = window_input_service:get(str)
			num = not num and 1
		end

		if not num then
			var_12_1 = self:_find_next_layout_name(num)
			flag = true
		end
	end

	if not flag and not var_12_1 then
		parent:set_layout_by_name(var_12_1)

		PlayerData.mission_selection.start_layout = var_12_1
	end
end

StartGameWindowPanelConsole._set_selected_option = function (self, arg_13_1)
	-- function 13
	local _title_button_widgets = self._title_button_widgets

	for i = 1, #_title_button_widgets do
		local content = _title_button_widgets[i].content
		local layout_name = content.layout_name

		content.button_hotspot.is_selected = layout_name == arg_13_1
	end

	self._selected_layout_name = arg_13_1
end

StartGameWindowPanelConsole.draw = function (self, arg_14_1)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_14_1, nil, self.render_settings)
	UIRenderer.draw_all_widgets(ui_renderer, self._widgets)

	if not self.parent:panel_title_buttons_hidden() then
		UIRenderer.draw_all_widgets(ui_renderer, self._title_button_widgets)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowPanelConsole._play_sound = function (self, arg_15_1)
	-- function 15
	self.parent:play_sound(arg_15_1)
end

StartGameWindowPanelConsole._setup_input_buttons = function (self)
	-- function 16
	local window_input_service = self.parent:window_input_service()
	local _widgets_by_name = self._widgets_by_name
	local panel_input_area_1 = _widgets_by_name.panel_input_area_1
	local texture_id = panel_input_area_1.style.texture_id
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str_2, true)

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	panel_input_area_1.content.texture_id = get_gamepad_input_texture_data.texture

	local panel_input_area_2 = _widgets_by_name.panel_input_area_2
	local texture_id_2 = panel_input_area_2.style.texture_id
	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(window_input_service, str, true)

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	panel_input_area_2.content.texture_id = get_gamepad_input_texture_data_2.texture
end

StartGameWindowPanelConsole._handle_back_button_visibility = function (self)
	-- function 17
	if not self.gamepad_active_last_frame then
		local flag = not self.parent:close_on_exit()

		self._widgets_by_name.back_button.content.visible = flag
	end
end

StartGameWindowPanelConsole._reset_back_button = function (self)
	-- function 18
	local button_hotspot = self._widgets_by_name.back_button.content.button_hotspot

	table.clear(button_hotspot)
end

StartGameWindowPanelConsole._handle_gamepad_activity = function (self)
	-- function 19
	local flag

	flag = self.gamepad_active_last_frame == nil

	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag_2 = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag_2 then
			self.gamepad_active_last_frame = true

			if not self.parent:panel_title_buttons_hidden() then
				local _widgets_by_name = self._widgets_by_name

				_widgets_by_name.panel_input_area_1.content.visible = true
				_widgets_by_name.panel_input_area_2.content.visible = true
				_widgets_by_name.back_button.content.visible = false
				_widgets_by_name.close_button.content.visible = false
			end

			self:_setup_input_buttons()
		end
	elseif self.gamepad_active_last_frame or not flag_2 then
		self.gamepad_active_last_frame = false

		local _widgets_by_name_2 = self._widgets_by_name

		_widgets_by_name_2.panel_input_area_1.content.visible = false
		_widgets_by_name_2.panel_input_area_2.content.visible = false
		_widgets_by_name_2.close_button.content.visible = true
	end

	self._most_recent_device = get_most_recent_device
end

StartGameWindowPanelConsole._is_in_quickplay_weave_menu = function (self)
	-- function 20
	return self.parent.parent:on_enter_sub_state() == "weave_quickplay"
end

StartGameWindowPanelConsole._is_supported_with_twitch = function (arg_21_0, arg_21_1)
	-- function 21
	local twitch = Managers.twitch

	if not twitch and twitch:is_connecting() and not twitch:is_connected() then
		return twitch:game_mode_supported(arg_21_1)
	end

	return true
end

StartGameWindowPanelConsole._event_disable_function = function (self)
	-- function 22
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("event")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._adventure_disable_function = function (self)
	-- function 23
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("adventure")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._custom_game_disable_function = function (self)
	-- function 24
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("custom")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._heroic_deed_disable_function = function (self)
	-- function 25
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = (_is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("deed")) and script_data.use_beta_mode

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._lobby_browser_disable_function = function (self)
	-- function 26
	return not self:_is_supported_with_twitch("lobby_browser")
end

StartGameWindowPanelConsole._weave_disable_function = function (self)
	-- function 27
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("weave")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._deus_quickplay_disable_function = function (self)
	-- function 28
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("deus_quickplay")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._deus_custom_disable_function = function (self)
	-- function 29
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("deus_custom")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._versus_quickplay_disable_function = function (self)
	-- function 30
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("versus_quickplay")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._versus_custom_disable_function = function (self)
	-- function 31
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("versus_custom")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._streaming_disable_function = function (self)
	-- function 32
	if not self:_is_in_quickplay_weave_menu() then
		return true
	end

	local twitch_enabled = GameSettingsDevelopment.twitch_enabled
	local offline_mode = Managers.account:offline_mode()

	return not twitch_enabled and offline_mode
end

StartGameWindowPanelConsole._animate_title_entry = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local button_hotspot = arg_33_1.content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local num = 20
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_33_1

	::label_33_0::

	is_clicked = true

	::label_33_1::

	local animate_value = UIUtils.animate_value
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local var_33_6 = animate_value(input_progress, arg_33_2 * num, is_clicked)
	local num_2 = 8
	local animate_value_2 = UIUtils.animate_value
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local var_33_10 = animate_value_2(hover_progress, arg_33_2 * num_2, button_hotspot.is_hover)
	local animate_value_3 = UIUtils.animate_value
	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local var_33_13 = animate_value_3(selection_progress, arg_33_2 * num_2, is_selected)
	local max = math.max(var_33_10, var_33_13)
	local num_3 = 255 * max
	local style = arg_33_1.style

	style.selected_texture.color[1] = num_3

	local num_4 = 4 * max

	style.text.offset[2] = 5 - num_4
	style.text_shadow.offset[2] = 3 - num_4
	style.text_hover.offset[2] = 5 - num_4
	style.text_disabled.offset[2] = 5 - num_4

	local num_5 = 0.5 + math.sin(arg_33_3 * 5) * 0.5

	style.new_marker.color[1] = 100 + 155 * num_5
	button_hotspot.hover_progress = var_33_10
	button_hotspot.input_progress = var_33_6
	button_hotspot.selection_progress = var_33_13
end

StartGameWindowPanelConsole._animate_back_button = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local content = arg_34_1.content
	local style = arg_34_1.style
	local button_hotspot = content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_34_1

	::label_34_0::

	is_clicked = true

	::label_34_1::

	local num = 20
	local animate_value = UIUtils.animate_value
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local var_34_8 = animate_value(input_progress, arg_34_2 * num, is_clicked)
	local num_2 = 8
	local animate_value_2 = UIUtils.animate_value
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local var_34_12 = animate_value_2(hover_progress, num_2 * arg_34_2, button_hotspot.is_hover)
	local animate_value_3 = UIUtils.animate_value
	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local var_34_15 = animate_value_3(selection_progress, num_2 * arg_34_2, is_selected)
	local num_3 = 255 * math.max(var_34_12, var_34_15)

	style.texture_id.color[1] = 255 - num_3
	style.texture_hover_id.color[1] = num_3
	style.selected_texture.color[1] = num_3
	button_hotspot.hover_progress = var_34_12
	button_hotspot.input_progress = var_34_8
	button_hotspot.selection_progress = var_34_15
end
