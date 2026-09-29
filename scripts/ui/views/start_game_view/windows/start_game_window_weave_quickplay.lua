-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_quickplay.lua

local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_quickplay_definitions")
local widgets_definitions = definitions.widgets
local create_difficulty_button = definitions.create_difficulty_button
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions
local DO_RELOAD = false
local STARTING_DIFFICULTY_INDEX = 1

StartGameWindowWeaveQuickplay = class(StartGameWindowWeaveQuickplay)
StartGameWindowWeaveQuickplay.NAME = "StartGameWindowWeaveQuickplay"

StartGameWindowWeaveQuickplay.on_enter = function (self, params, offset)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveQuickplay")

	self._params = params
	self._parent = params.parent

	local ingame_ui_context = params.ingame_ui_context

	self._ingame_ui = ingame_ui_context.ingame_ui
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._is_server = ingame_ui_context.is_server
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._ui_hdr_renderer = self._parent:hdr_renderer()
	self._my_player = ingame_ui_context.player
	self._selected_difficulty_index = 1
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(params, offset)
	self:_setup_difficulties()
	self:_start_transition_animation("on_enter")

	local ignore_approval = true
	local selected_difficulty_key = self._parent:get_difficulty_option(ignore_approval)

	if not selected_difficulty_key then
		self._parent:set_difficulty_option(DefaultQuickPlayStartingDifficulty)
	end

	self._parent:set_input_description("play_available")
	self._parent:change_generic_actions("default_weave_quick_play")
end

StartGameWindowWeaveQuickplay._start_transition_animation = function (self, animation_name)
	-- function 2
	local params = {
		render_settings = self._render_settings
	}
	local widgets = self._widgets_by_name
	local anim_id = self._ui_animator:start_animation(animation_name, widgets, scenegraph_definition, params)

	self._animations[animation_name] = anim_id
end

StartGameWindowWeaveQuickplay._create_ui_elements = function (self, params, offset)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widgets_by_name = {}
	local widgets = {}

	for name, widget_definition in pairs(widgets_definitions) do
		local widget = UIWidget.init(widget_definition)

		widgets[#widgets + 1] = widget
		widgets_by_name[name] = widget
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	self:_setup_input_buttons()
end

StartGameWindowWeaveQuickplay._setup_input_buttons = function (self)
	-- function 4
	local input_service = self._parent:window_input_service()
	local start_game_input_data = UISettings.get_gamepad_input_texture_data(input_service, "refresh_press", true)
	local widgets_by_name = self._widgets_by_name
	local play_button_console = widgets_by_name.play_button_console
	local input_texture_style = play_button_console.style.input_texture

	input_texture_style.horizontal_alignment = "center"
	input_texture_style.vertical_alignment = "center"
	input_texture_style.texture_size = {
		start_game_input_data.size[1],
		start_game_input_data.size[2]
	}
	play_button_console.content.input_texture = start_game_input_data.texture
end

StartGameWindowWeaveQuickplay.on_exit = function (self, params)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveQuickplay")

	self._ui_animator = nil
end

StartGameWindowWeaveQuickplay.update = function (self, dt, t)
	-- function 6
	if DO_RELOAD then
		DO_RELOAD = false

		self:_create_ui_elements()
	end

	self:_update_can_play()
	self:_handle_gamepad_activity()
	self:_sync_selected_difficulty()
	self:_handle_input(dt, t)
	self:_update_animations(dt)
	self:draw(dt)
end

StartGameWindowWeaveQuickplay._handle_gamepad_activity = function (self)
	-- function 7
	local force_update = self.gamepad_active_last_frame == nil
	local gamepad_active = Managers.input:is_device_active("gamepad")

	if gamepad_active then
		if not self.gamepad_active_last_frame or force_update then
			self.gamepad_active_last_frame = true

			local widgets_by_name = self._widgets_by_name

			widgets_by_name.play_button.content.visible = false
			widgets_by_name.play_button_console.content.visible = true
		end
	elseif self.gamepad_active_last_frame or force_update then
		self.gamepad_active_last_frame = false

		local widgets_by_name = self._widgets_by_name

		widgets_by_name.play_button.content.visible = true
		widgets_by_name.play_button_console.content.visible = false
	end
end

StartGameWindowWeaveQuickplay._update_can_play = function (self)
	-- function 8
	local widgets_by_name = self._widgets_by_name
	local is_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local was_matchmaking = self._is_matchmaking

	self._is_matchmaking = is_matchmaking

	if is_matchmaking ~= was_matchmaking then
		if is_matchmaking then
			widgets_by_name.play_button.content.button_hotspot.disable_button = true

			self._parent:set_input_description("cancel_matchmaking")
		else
			self._parent:set_input_description("play_available")
		end
	end

	local play_button_console = self._widgets_by_name.play_button_console

	if is_matchmaking then
		play_button_console.content.text = Localize("cancel_matchmaking")

		if self._is_server then
			play_button_console.content.locked = false
		else
			play_button_console.content.locked = true
		end
	else
		play_button_console.content.locked = false
		play_button_console.content.text = Localize("start_game_window_play")
	end
end

StartGameWindowWeaveQuickplay._sync_selected_difficulty = function (self)
	-- function 9
	local parent = self._parent
	local ignore_approval = true
	local selected_difficulty_key = parent:get_difficulty_option(ignore_approval)

	if selected_difficulty_key and selected_difficulty_key ~= self._selected_difficulty_key then
		print(selected_difficulty_key)

		self._selected_difficulty_key = selected_difficulty_key

		self:_set_difficulty_selected(selected_difficulty_key)

		local difficulty_widgets = self._difficulty_widgets

		for i = 1, #difficulty_widgets do
			local widget = difficulty_widgets[i]
			local content = widget.content
			local difficulty_key = content.difficulty_key
			local is_selected = difficulty_key == selected_difficulty_key

			content.button_hotspot.is_selected = is_selected

			if is_selected then
				self._selected_difficulty_index = i
			end
		end
	end
end

StartGameWindowWeaveQuickplay._handle_input = function (self, dt, t)
	-- function 10
	local parent = self._parent
	local widgets_by_name = self._widgets_by_name
	local mouse_active = Managers.input:is_device_active("mouse")
	local input_service = self._parent:window_input_service()
	local play_button = widgets_by_name.play_button

	if self:_is_button_hover_enter(play_button) then
		self:_play_sound("Play_hud_hover")
	end

	local play_pressed = mouse_active and not not input_service:get("skip_press") or not mouse_active and not not input_service:get("refresh_press")

	if self._is_matchmaking then
		if play_pressed then
			Managers.matchmaking:cancel_matchmaking()
			self:_play_sound("play_gui_lobby_button_01_difficulty_select_hover")
		end
	elseif self:_is_button_released(play_button) or play_pressed then
		parent:play(t, "weave_quick_play")
		self:_play_sound("menu_wind_level_choose_wind")
	end

	local difficulty_widgets = self._difficulty_widgets

	if mouse_active then
		for i = 1, #difficulty_widgets do
			local widget = difficulty_widgets[i]

			if self:_is_button_hover_enter(widget) then
				self:_play_sound("play_gui_lobby_button_01_difficulty_select_hover")
			end

			if self:_is_button_released(widget) then
				local content = widget.content
				local difficulty_key = content.difficulty_key

				parent:set_difficulty_option(difficulty_key)

				local difficulties_select_sounds = UISettings.difficulties_select_sounds
				local sound_event = not not difficulties_select_sounds[i]

				self:_play_sound(sound_event)
			end
		end
	else
		local old_current_difficulty_index = self._current_difficulty_index

		self._current_difficulty_index = not not self._current_difficulty_index

		if input_service:get("move_left") then
			self._current_difficulty_index = math.clamp(self._current_difficulty_index - 1, 1, #difficulty_widgets)
		elseif input_service:get("move_right") then
			self._current_difficulty_index = math.clamp(self._current_difficulty_index + 1, 1, #difficulty_widgets)
		elseif input_service:get("confirm_press") then
			if self._current_difficulty_index ~= self._selected_difficulty_index then
				local widget = self._difficulty_widgets[self._current_difficulty_index]
				local content = widget.content
				local difficulty_key = content.difficulty_key

				parent:set_difficulty_option(difficulty_key)

				local difficulties_select_sounds = UISettings.difficulties_select_sounds
				local sound_event = not not difficulties_select_sounds[self._current_difficulty_index]

				self:_play_sound(sound_event)

				self._selected_difficulty_index = self._current_difficulty_index
			end
		elseif input_service:get("trigger_cycle_next") then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.weave_quickplay_desc)
		end

		if old_current_difficulty_index ~= self._current_difficulty_index then
			self:_play_sound("play_gui_lobby_button_01_difficulty_select_hover")

			if old_current_difficulty_index then
				local widget = self._difficulty_widgets[old_current_difficulty_index]

				widget.content.has_focus = false
			end

			local widget = self._difficulty_widgets[self._current_difficulty_index]

			widget.content.has_focus = true
		end
	end
end

StartGameWindowWeaveQuickplay._is_button_released = function (self, widget)
	-- function 11
	local content = widget.content
	local hotspot = not not content.button_hotspot

	if hotspot.on_release then
		hotspot.on_release = false

		return true
	end
end

StartGameWindowWeaveQuickplay._is_button_hover_enter = function (self, widget)
	-- function 12
	local content = widget.content
	local hotspot = not not content.button_hotspot

	return hotspot.on_hover_enter
end

StartGameWindowWeaveQuickplay.post_update = function (self, dt, t)
	-- function 13
	return
end

StartGameWindowWeaveQuickplay._update_animations = function (self, dt)
	-- function 14
	local difficulty_widgets = self._difficulty_widgets

	if difficulty_widgets then
		for i = 1, #difficulty_widgets do
			local widget = difficulty_widgets[i]

			self:_animate_difficulty_button(widget, dt)
		end
	end

	local ui_animations = self._ui_animations
	local animations = self._animations
	local ui_animator = self._ui_animator

	for name, animation in pairs(ui_animations) do
		UIAnimation.update(animation, dt)

		if UIAnimation.completed(animation) then
			ui_animations[name] = nil
		end
	end

	ui_animator:update(dt)

	for animation_name, animation_id in pairs(animations) do
		if ui_animator:is_animation_completed(animation_id) then
			ui_animator:stop_animation(animation_id)

			animations[animation_name] = nil
		end
	end
end

StartGameWindowWeaveQuickplay._play_sound = function (self, event)
	-- function 15
	self._parent:play_sound(event)
end

StartGameWindowWeaveQuickplay._exit = function (self, selected_level)
	-- function 16
	self.exit = true
	self.exit_level_id = selected_level
end

StartGameWindowWeaveQuickplay.draw = function (self, dt)
	-- function 17
	local ui_renderer = self._ui_renderer
	local ui_top_renderer = self._ui_top_renderer
	local ui_hdr_renderer = self._ui_hdr_renderer
	local ui_scenegraph = self._ui_scenegraph
	local render_settings = self._render_settings
	local input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

	for _, widget in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, widget)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

StartGameWindowWeaveQuickplay._play_sound = function (self, event)
	-- function 18
	self._parent:play_sound(event)
end

StartGameWindowWeaveQuickplay._animate_pulse = function (self, target, target_index, from, to, speed)
	-- function 19
	local new_animation = UIAnimation.init(UIAnimation.pulse_animation, target, target_index, from, to, speed)

	return new_animation
end

StartGameWindowWeaveQuickplay._animate_element_by_time = function (self, target, target_index, from, to, time)
	-- function 20
	local new_animation = UIAnimation.init(UIAnimation.function_by_time, target, target_index, from, to, time, math.ease_out_quad)

	return new_animation
end

StartGameWindowWeaveQuickplay._animate_element_by_catmullrom = function (self, target, target_index, target_value, p0, p1, p2, p3, time)
	-- function 21
	local new_animation = UIAnimation.init(UIAnimation.catmullrom, target, target_index, target_value, p0, p1, p2, p3, time)

	return new_animation
end

StartGameWindowWeaveQuickplay._set_difficulty_selected = function (self, difficulty_key)
	-- function 22
	local widgets_by_name = self._widgets_by_name
	local difficulty_settings = DifficultySettings[difficulty_key]
	local display_name = difficulty_settings.display_name
	local description = difficulty_settings.description
	local display_image = difficulty_settings.display_image

	widgets_by_name.difficulty_title.content.text = display_name
	widgets_by_name.difficulty_description.content.text = description
	widgets_by_name.difficulty_selected.content.texture_id = display_image
end

StartGameWindowWeaveQuickplay._setup_difficulties = function (self)
	-- function 23
	local difficulty_widgets = {}
	local difficulties = Managers.state.difficulty:get_default_difficulties()
	local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
	local widget_index_counter = 1
	local widget_prefix = "difficulty_option_"
	local spacing = 70
	local scenegraph_id = "difficulty_option"
	local size = scenegraph_definition[scenegraph_id].size
	local widget_definition = create_difficulty_button(scenegraph_id, size)
	local current_offset = 0
	local dlc_difficulties = {}

	for i = STARTING_DIFFICULTY_INDEX, #difficulties do
		local difficulty_key = difficulties[i]
		local difficulty_settings = DifficultySettings[difficulty_key]
		local display_name = difficulty_settings.display_name
		local display_image = difficulty_settings.display_image
		local widget = UIWidget.init(widget_definition)
		local widget_name = widget_prefix .. widget_index_counter

		widgets_by_name[widget_name] = widget
		widgets[#widgets + 1] = widget
		difficulty_widgets[#difficulty_widgets + 1] = widget

		local offset = widget.offset
		local content = widget.content

		content.difficulty_key = difficulty_key
		content.title_text = Localize(display_name)
		content.icon = display_image
		offset[1] = current_offset
		current_offset = current_offset + (size[1] + spacing)
		widget_index_counter = widget_index_counter + 1
	end

	self._ui_scenegraph[scenegraph_id].position[1] = -(widget_index_counter * (size[1] + spacing) * 0.5) + (size[1] + spacing)
	self._difficulty_widgets = difficulty_widgets
end

StartGameWindowWeaveQuickplay._animate_difficulty_button = function (self, widget, dt)
	-- function 24
	local content = widget.content
	local style = widget.style
	local hotspot = not not content.hotspot
	local has_focus = content.has_focus
	local is_hover = not not hotspot.is_hover
	local is_selected = hotspot.is_selected
	local input_pressed = not is_selected and not not hotspot.is_clicked
	local hover_progress = not not hotspot.hover_progress
	local selection_progress = not not hotspot.selection_progress
	local speed = 3

	if is_hover then
		hover_progress = math.min(hover_progress + dt * speed, 1)
	else
		hover_progress = math.max(hover_progress - dt * speed, 0)
	end

	if is_selected then
		selection_progress = math.min(selection_progress + dt * speed, 1)
	else
		selection_progress = math.max(selection_progress - dt * speed, 0)
	end

	local combined_progress = math.max(hover_progress, selection_progress)
	local hover_alpha = 255 * hover_progress
	local combined_alpha = 255 * combined_progress
	local select_alpha = 255 * selection_progress

	style.background_glow.color[1] = hover_alpha
	style.title_text.text_color[1] = hover_alpha
	style.title_text_shadow.text_color[1] = hover_alpha
	style.title_text_disabled.text_color[1] = hover_alpha
	style.select_texture.color[1] = select_alpha
	style.select_edge.color[1] = select_alpha
	hotspot.hover_progress = hover_progress
	hotspot.selection_progress = selection_progress
end
