-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_panel_console.lua

local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_panel_console_definitions")
local INPUT_ACTION_NEXT = "cycle_next"
local INPUT_ACTION_PREVIOUS = "cycle_previous"

StartGameWindowPanelConsole = class(StartGameWindowPanelConsole)
StartGameWindowPanelConsole.NAME = "StartGameWindowPanelConsole"

StartGameWindowPanelConsole.on_enter = function (self, params, offset)
	-- function 1
	print("[HeroViewWindow] Enter Substate StartGameWindowPanelConsole")

	self.params = params
	self.parent = params.parent

	local ingame_ui_context = params.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = params.layout_settings
	self._mechanism_name = params.mechanism_name
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(definitions, params, offset)
	self:_setup_text_buttons_width_and_position()
	self:_setup_input_buttons()
end

StartGameWindowPanelConsole._create_ui_elements = function (self, definitions, params, offset)
	-- function 2
	local scenegraph_definition = definitions.scenegraph_definition
	local ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = ui_scenegraph
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(definitions.widget_definitions)

	local title_button_widgets = {}
	local window_layouts = self._layout_settings.window_layouts
	local parent = self.parent

	for i = 1, #window_layouts do
		local settings = window_layouts[i]

		if settings.panel_sorting and parent:can_add_layout(settings) then
			local scenegraph_id = "game_mode_option"
			local size = scenegraph_definition[scenegraph_id].size
			local display_name_2 = settings.display_name

			if not display_name_2 then
				-- Nothing
			end

			display_name_2 = "n/a"

			local display_name = display_name_2

			::label_2_0::

			local font_size = 32
			local horizontal_alignment = "center"
			local widget_definition = definitions.create_panel_button(scenegraph_id, size, display_name, font_size, nil, horizontal_alignment)
			local widget = UIWidget.init(widget_definition)
			local layout_name = settings.name

			widget.content.layout_name = layout_name
			widget.disable_function_name = settings.disable_function_name
			widget.is_layout_disabled = Managers.ui:is_ui_layout_disabled(layout_name)
			title_button_widgets[#title_button_widgets + 1] = widget
		end
	end

	self._title_button_widgets = title_button_widgets

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(ui_scenegraph, definitions.animation_definitions)

	if offset then
		local window_position = ui_scenegraph.window.local_position

		window_position[1] = window_position[1] + offset[1]
		window_position[2] = window_position[2] + offset[2]
		window_position[3] = window_position[3] + offset[3]
	end
end

StartGameWindowPanelConsole._setup_text_buttons_width_and_position = function (self)
	-- function 3
	local ui_scenegraph = self.ui_scenegraph
	local area_size = ui_scenegraph.panel_entry_area.size
	local total_width = area_size[1]
	local title_button_widgets = self._title_button_widgets
	local num_title_button_widgets = #title_button_widgets
	local entry_width = math.floor(total_width / num_title_button_widgets)

	ui_scenegraph.game_mode_option.size[1] = entry_width

	for i = 1, num_title_button_widgets do
		local widget = title_button_widgets[i]

		self:_set_text_button_size(widget, entry_width)

		local position_x = entry_width * (i - 1)

		widget.offset[1] = position_x
	end

	local widgets_by_name = self._widgets_by_name
	local panel_input_area_2_widget = widgets_by_name.panel_input_area_2

	panel_input_area_2_widget.offset[1] = entry_width * (num_title_button_widgets - 1)
end

StartGameWindowPanelConsole._set_text_button_size = function (self, widget, width)
	-- function 4
	local style = widget.style

	style.selected_texture.texture_size[1] = width

	local text_width_offset = 5
	local text_width = width - text_width_offset * 2

	style.text.size[1] = text_width
	style.text_shadow.size[1] = text_width
	style.text_hover.size[1] = text_width
	style.text_disabled.size[1] = text_width
	style.text.offset[1] = style.text.default_offset[1] + text_width_offset
	style.text_shadow.offset[1] = style.text_shadow.default_offset[1] + text_width_offset
	style.text_hover.offset[1] = style.text_hover.default_offset[1] + text_width_offset
	style.text_disabled.offset[1] = style.text_disabled.default_offset[1] + text_width_offset
end

StartGameWindowPanelConsole.on_exit = function (self, params)
	-- function 5
	print("[HeroViewWindow] Exit Substate StartGameWindowPanelConsole")

	self.ui_animator = nil
end

StartGameWindowPanelConsole.update = function (self, dt, t)
	-- function 6
	self:_handle_gamepad_activity()
	self:_handle_back_button_visibility()
	self:_update_title_buttons_disable_status()
	self:_update_selected_option()
	self:_update_animations(dt, t)
	self:draw(dt)
end

StartGameWindowPanelConsole._update_selected_option = function (self)
	-- function 7
	local parent = self.parent
	local selected_layout_name = parent:get_selected_layout_name()

	if selected_layout_name ~= self._selected_layout_name then
		self:_set_selected_option(selected_layout_name)
	end
end

StartGameWindowPanelConsole._update_title_buttons_disable_status = function (self)
	-- function 8
	local title_button_widgets = self._title_button_widgets

	for i = 1, #title_button_widgets do
		local widget = title_button_widgets[i]
		local is_disabled = false

		if widget.is_layout_disabled then
			is_disabled = true
		else
			local disable_function_name = widget.disable_function_name

			if disable_function_name then
				is_disabled = self[disable_function_name](self)
			end
		end

		widget.content.button_hotspot.disable_button = is_disabled
	end
end

StartGameWindowPanelConsole.post_update = function (self, dt, t)
	-- function 9
	self:_handle_input(dt, t)
end

StartGameWindowPanelConsole._update_animations = function (self, dt, t)
	-- function 10
	local ui_animations = self._ui_animations

	for name, animation in pairs(ui_animations) do
		UIAnimation.update(animation, dt)

		if UIAnimation.completed(animation) then
			ui_animations[name] = nil
		end
	end

	local ui_animator = self.ui_animator

	ui_animator:update(dt)

	local animations = self._animations

	for animation_name, animation_id in pairs(animations) do
		if ui_animator:is_animation_completed(animation_id) then
			animations[animation_name] = nil
		end
	end

	local title_button_widgets = self._title_button_widgets

	for i = 1, #title_button_widgets do
		self:_animate_title_entry(title_button_widgets[i], dt, t)
	end

	self:_animate_back_button(self._widgets_by_name.back_button, dt)
	self:_animate_back_button(self._widgets_by_name.close_button, dt)
end

StartGameWindowPanelConsole._find_next_layout_name = function (self, direction)
	-- function 11
	local selected_layout_index = 1
	local selected_layout_name = self._selected_layout_name
	local title_button_widgets = self._title_button_widgets

	for i = 1, #title_button_widgets do
		local widget = title_button_widgets[i]
		local layout_name = widget.content.layout_name

		if layout_name == selected_layout_name then
			selected_layout_index = i

			break
		end
	end

	local new_layout_name
	local new_index = selected_layout_index
	local done = false

	repeat
		new_index = math.index_wrapper(new_index + direction, #title_button_widgets)

		local widget = title_button_widgets[new_index]

		if new_index == selected_layout_index then
			done = true
		elseif not widget.content.button_hotspot.disable_button then
			new_layout_name = widget.content.layout_name
			done = true
		end
	until done

	return new_layout_name
end

StartGameWindowPanelConsole._handle_input = function (self, dt, t)
	-- function 12
	local input_made = false
	local selected_layout_name
	local title_button_widgets = self._title_button_widgets

	for i = 1, #title_button_widgets do
		local widget = title_button_widgets[i]

		if not UIUtils.is_button_selected(widget) then
			if UIUtils.is_button_hover_enter(widget) then
				self:_play_sound("Play_hud_hover")
			end

			if UIUtils.is_button_pressed(widget) then
				selected_layout_name = widget.content.layout_name
				input_made = true
			end
		end
	end

	local widgets_by_name = self._widgets_by_name
	local close_button = widgets_by_name.close_button
	local back_button = widgets_by_name.back_button

	if UIUtils.is_button_hover_enter(back_button) or UIUtils.is_button_hover_enter(close_button) then
		self:_play_sound("Play_hud_hover")
	end

	local parent = self.parent
	local close_on_exit = parent:close_on_exit()

	if not close_on_exit and not input_made and UIUtils.is_button_pressed(back_button) then
		local return_layout_name
		local params = self.params

		if params then
			return_layout_name = params.return_layout_name
			params.return_layout_name = nil
		end

		return_layout_name = not not return_layout_name or not not parent:get_previous_selected_layout_name()

		if return_layout_name then
			self:_reset_back_button()

			selected_layout_name = return_layout_name
			input_made = true
		end
	end

	if not input_made and UIUtils.is_button_pressed(close_button) then
		parent:close_menu()

		input_made = true
	end

	if not input_made and not self.parent:panel_title_buttons_hidden() then
		local input_service = parent:window_input_service()
		local num

		if input_service:get(INPUT_ACTION_PREVIOUS) then
			num = -1

			goto label_12_0
		end

		num = input_service:get(INPUT_ACTION_NEXT)

		if num then
			-- Nothing
		end

		num = 1

		local direction = num

		::label_12_0::

		if direction then
			selected_layout_name = self:_find_next_layout_name(direction)
			input_made = true
		end
	end

	if input_made and selected_layout_name then
		parent:set_layout_by_name(selected_layout_name)

		PlayerData.mission_selection.start_layout = selected_layout_name
	end
end

StartGameWindowPanelConsole._set_selected_option = function (self, selected_layout_name)
	-- function 13
	local title_button_widgets = self._title_button_widgets

	for i = 1, #title_button_widgets do
		local widget = title_button_widgets[i]
		local content = widget.content
		local layout_name = content.layout_name

		content.button_hotspot.is_selected = layout_name == selected_layout_name
	end

	self._selected_layout_name = selected_layout_name
end

StartGameWindowPanelConsole.draw = function (self, dt)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, self.render_settings)
	UIRenderer.draw_all_widgets(ui_renderer, self._widgets)

	if not self.parent:panel_title_buttons_hidden() then
		UIRenderer.draw_all_widgets(ui_renderer, self._title_button_widgets)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowPanelConsole._play_sound = function (self, event)
	-- function 15
	self.parent:play_sound(event)
end

StartGameWindowPanelConsole._setup_input_buttons = function (self)
	-- function 16
	local input_service = self.parent:window_input_service()
	local widgets_by_name = self._widgets_by_name
	local input_1_widget = widgets_by_name.panel_input_area_1
	local icon_style_input_1 = input_1_widget.style.texture_id
	local input_1_texture_data = UISettings.get_gamepad_input_texture_data(input_service, INPUT_ACTION_PREVIOUS, true)

	icon_style_input_1.horizontal_alignment = "center"
	icon_style_input_1.vertical_alignment = "center"
	icon_style_input_1.texture_size = {
		input_1_texture_data.size[1],
		input_1_texture_data.size[2]
	}
	input_1_widget.content.texture_id = input_1_texture_data.texture

	local input_2_widget = widgets_by_name.panel_input_area_2
	local icon_style_input_2 = input_2_widget.style.texture_id
	local input_2_texture_data = UISettings.get_gamepad_input_texture_data(input_service, INPUT_ACTION_NEXT, true)

	icon_style_input_2.horizontal_alignment = "center"
	icon_style_input_2.vertical_alignment = "center"
	icon_style_input_2.texture_size = {
		input_2_texture_data.size[1],
		input_2_texture_data.size[2]
	}
	input_2_widget.content.texture_id = input_2_texture_data.texture
end

StartGameWindowPanelConsole._handle_back_button_visibility = function (self)
	-- function 17
	if not self.gamepad_active_last_frame then
		local close_on_exit = self.parent:close_on_exit()
		local new_visibility = not close_on_exit
		local back_button = self._widgets_by_name.back_button

		back_button.content.visible = new_visibility
	end
end

StartGameWindowPanelConsole._reset_back_button = function (self)
	-- function 18
	local back_button = self._widgets_by_name.back_button
	local hotspot = back_button.content.button_hotspot

	table.clear(hotspot)
end

StartGameWindowPanelConsole._handle_gamepad_activity = function (self)
	-- function 19
	local force_update = self.gamepad_active_last_frame == nil
	local gamepad_active = Managers.input:is_device_active("gamepad")
	local most_recent_device = Managers.input:get_most_recent_device()
	local force_update = (self.gamepad_active_last_frame == nil or not not gamepad_active) and most_recent_device ~= self._most_recent_device

	if gamepad_active then
		if not self.gamepad_active_last_frame or force_update then
			self.gamepad_active_last_frame = true

			if not self.parent:panel_title_buttons_hidden() then
				local widgets_by_name = self._widgets_by_name

				widgets_by_name.panel_input_area_1.content.visible = true
				widgets_by_name.panel_input_area_2.content.visible = true
				widgets_by_name.back_button.content.visible = false
				widgets_by_name.close_button.content.visible = false
			end

			self:_setup_input_buttons()
		end
	elseif self.gamepad_active_last_frame or force_update then
		self.gamepad_active_last_frame = false

		local widgets_by_name = self._widgets_by_name

		widgets_by_name.panel_input_area_1.content.visible = false
		widgets_by_name.panel_input_area_2.content.visible = false
		widgets_by_name.close_button.content.visible = true
	end

	self._most_recent_device = most_recent_device
end

StartGameWindowPanelConsole._is_in_quickplay_weave_menu = function (self)
	-- function 20
	return self.parent.parent:on_enter_sub_state() == "weave_quickplay"
end

StartGameWindowPanelConsole._is_supported_with_twitch = function (self, game_mode)
	-- function 21
	local twich_manager = Managers.twitch

	if twich_manager and (twich_manager:is_connecting() or twich_manager:is_connected()) then
		return twich_manager:game_mode_supported(game_mode)
	end

	return true
end

StartGameWindowPanelConsole._event_disable_function = function (self)
	-- function 22
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("event")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._adventure_disable_function = function (self)
	-- function 23
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("adventure")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._custom_game_disable_function = function (self)
	-- function 24
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("custom")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._heroic_deed_disable_function = function (self)
	-- function 25
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not self:_is_supported_with_twitch("deed") or not not script_data.use_beta_mode

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._lobby_browser_disable_function = function (self)
	-- function 26
	return not self:_is_supported_with_twitch("lobby_browser")
end

StartGameWindowPanelConsole._weave_disable_function = function (self)
	-- function 27
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("weave")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._deus_quickplay_disable_function = function (self)
	-- function 28
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("deus_quickplay")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._deus_custom_disable_function = function (self)
	-- function 29
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("deus_custom")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._versus_quickplay_disable_function = function (self)
	-- function 30
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("versus_quickplay")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._versus_custom_disable_function = function (self)
	-- function 31
	local _is_in_quickplay_weave_menu = self:_is_in_quickplay_weave_menu()

	_is_in_quickplay_weave_menu = not not _is_in_quickplay_weave_menu or not not not self:_is_supported_with_twitch("versus_custom")

	return _is_in_quickplay_weave_menu
end

StartGameWindowPanelConsole._streaming_disable_function = function (self)
	-- function 32
	if self:_is_in_quickplay_weave_menu() then
		return true
	end

	local twitch_enabled = GameSettingsDevelopment.twitch_enabled
	local is_offline = Managers.account:offline_mode()

	return not twitch_enabled or not not is_offline
end

StartGameWindowPanelConsole._animate_title_entry = function (self, widget, dt, t)
	-- function 33
	local content = widget.content
	local hotspot = content.button_hotspot
	local is_selected = hotspot.is_selected
	local input_speed = 20
	local is_clicked

	if not is_selected then
		is_clicked = hotspot.is_clicked

		if is_clicked then
			-- Nothing
		end

		if hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_33_1

	::label_33_0::

	is_clicked = true

	local input_pressed = is_clicked

	::label_33_1::

	local animate_value = UIUtils.animate_value
	local input_progress_2 = hotspot.input_progress

	input_progress_2 = not not input_progress_2 or not not 0

	local input_progress = animate_value(input_progress_2, dt * input_speed, input_pressed)
	local speed = 8
	local animate_value_2 = UIUtils.animate_value
	local hover_progress_2 = hotspot.hover_progress

	hover_progress_2 = not not hover_progress_2 or not not 0

	local hover_progress = animate_value_2(hover_progress_2, dt * speed, hotspot.is_hover)
	local animate_value_3 = UIUtils.animate_value
	local selection_progress_2 = hotspot.selection_progress

	selection_progress_2 = not not selection_progress_2 or not not 0

	local selection_progress = animate_value_3(selection_progress_2, dt * speed, is_selected)
	local combined_progress = math.max(hover_progress, selection_progress)
	local hover_alpha = 255 * combined_progress
	local style = widget.style

	style.selected_texture.color[1] = hover_alpha

	local text_height_offset = 4 * combined_progress

	style.text.offset[2] = 5 - text_height_offset
	style.text_shadow.offset[2] = 3 - text_height_offset
	style.text_hover.offset[2] = 5 - text_height_offset
	style.text_disabled.offset[2] = 5 - text_height_offset

	local new_marker_progress = 0.5 + math.sin(t * 5) * 0.5

	style.new_marker.color[1] = 100 + 155 * new_marker_progress
	hotspot.hover_progress = hover_progress
	hotspot.input_progress = input_progress
	hotspot.selection_progress = selection_progress
end

StartGameWindowPanelConsole._animate_back_button = function (self, widget, dt)
	-- function 34
	local content = widget.content
	local style = widget.style
	local hotspot = content.button_hotspot
	local is_selected = hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = hotspot.is_clicked

		if is_clicked then
			-- Nothing
		end

		if hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_34_1

	::label_34_0::

	is_clicked = true

	local input_pressed = is_clicked

	::label_34_1::

	local input_speed = 20
	local animate_value = UIUtils.animate_value
	local input_progress_2 = hotspot.input_progress

	input_progress_2 = not not input_progress_2 or not not 0

	local input_progress = animate_value(input_progress_2, dt * input_speed, input_pressed)
	local speed = 8
	local animate_value_2 = UIUtils.animate_value
	local hover_progress_2 = hotspot.hover_progress

	hover_progress_2 = not not hover_progress_2 or not not 0

	local hover_progress = animate_value_2(hover_progress_2, speed * dt, hotspot.is_hover)
	local animate_value_3 = UIUtils.animate_value
	local selection_progress_2 = hotspot.selection_progress

	selection_progress_2 = not not selection_progress_2 or not not 0

	local selection_progress = animate_value_3(selection_progress_2, speed * dt, is_selected)
	local combined_progress = math.max(hover_progress, selection_progress)
	local hover_alpha = 255 * combined_progress

	style.texture_id.color[1] = 255 - hover_alpha
	style.texture_hover_id.color[1] = hover_alpha
	style.selected_texture.color[1] = hover_alpha
	hotspot.hover_progress = hover_progress
	hotspot.input_progress = input_progress
	hotspot.selection_progress = selection_progress
end
