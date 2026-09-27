-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_game_mode.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_game_mode_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowGameMode = class(StartGameWindowGameMode)
StartGameWindowGameMode.NAME = "StartGameWindowGameMode"

StartGameWindowGameMode.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowGameMode")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
end

StartGameWindowGameMode.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local window_layouts = self._layout_settings.window_layouts
	local num = 16

	for k_2 = 1, #window_layouts do
		local var_2_7 = window_layouts[k_2]

		if not var_2_7.panel_sorting and not self.parent:can_add_layout(var_2_7) then
			local str = "game_mode_option"
			local size = scenegraph_definition[str].size
			local display_name = var_2_7.display_name

			display_name = display_name or "n/a"

			if not (var_2_7.localize == nil or var_2_7.localize) then
				display_name = Localize(display_name)
			end

			local icon_name = var_2_7.icon_name
			local background_icon_name = var_2_7.background_icon_name
			local dynamic_font_size = var_2_7.dynamic_font_size
			local create_window_category_button = UIWidgets.create_window_category_button(str, size, display_name, icon_name, background_icon_name, dynamic_font_size)
			local var_2_15 = UIWidget.init(create_window_category_button)
			local num_2 = #tbl_3 + 1
			local name = var_2_7.name

			var_2_15.content.layout_name = name
			var_2_15.offset[2] = -num * num_2 - size[2] * (num_2 - 1)

			if name == "twitch" then
				var_2_15.content.disabled = not GameSettingsDevelopment.twitch_enabled and Managers.account:offline_mode()
			end

			tbl_3[num_2] = var_2_15
		end
	end

	self._game_mode_widgets = tbl_3

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowGameMode.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowGameMode")

	self.ui_animator = nil
end

StartGameWindowGameMode.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_selected_option()
	self:_update_animations(arg_4_1)
	self:_handle_input(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

StartGameWindowGameMode.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

StartGameWindowGameMode._update_animations = function (self, arg_6_1)
	-- function 6
	self:_update_game_options_hover_effect(arg_6_1)

	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	local ui_animator = self.ui_animator

	ui_animator:update(arg_6_1)

	local _animations = self._animations

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

StartGameWindowGameMode._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowGameMode._is_button_hover_enter = function (arg_8_0, arg_8_1)
	-- function 8
	return arg_8_1.content.button_hotspot.on_hover_enter
end

StartGameWindowGameMode._is_button_selected = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.is_selected
end

StartGameWindowGameMode._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _game_mode_widgets = self._game_mode_widgets

	for i = 1, #_game_mode_widgets do
		local var_10_1 = _game_mode_widgets[i]

		if not (not self:_is_button_pressed(var_10_1) and self:_is_button_selected(var_10_1)) then
			local layout_name = var_10_1.content.layout_name

			self.parent:set_layout_by_name(layout_name)

			PlayerData.mission_selection.start_layout = layout_name
		end
	end

	local lobby_browser_option = self._widgets_by_name.lobby_browser_option

	if not self:_is_button_pressed(lobby_browser_option) then
		self.parent:set_layout_by_name("lobby_browser")
	end
end

StartGameWindowGameMode._update_game_options_hover_effect = function (self, arg_11_1)
	-- function 11
	local _game_mode_widgets = self._game_mode_widgets

	for i = 1, #_game_mode_widgets do
		local var_11_1 = _game_mode_widgets[i]

		UIWidgetUtils.animate_option_button(var_11_1, arg_11_1)

		if not (not self:_is_button_hover_enter(var_11_1) and self:_is_button_selected(var_11_1)) then
			self:_play_sound("play_gui_equipment_button_hover")
		end
	end

	local lobby_browser_option = self._widgets_by_name.lobby_browser_option

	if not self:_is_button_hover_enter(lobby_browser_option) then
		self:_play_sound("play_gui_equipment_button_hover")
	end

	UIWidgetUtils.animate_default_button(lobby_browser_option, arg_11_1)
end

StartGameWindowGameMode._set_selected_option = function (self, arg_12_1)
	-- function 12
	local _game_mode_widgets = self._game_mode_widgets

	for i = 1, #_game_mode_widgets do
		local var_12_1 = _game_mode_widgets[i]
		local flag = var_12_1.content.layout_name == arg_12_1

		var_12_1.content.button_hotspot.is_selected = flag
	end

	self._selected_layout_name = arg_12_1
end

StartGameWindowGameMode._update_selected_option = function (self)
	-- function 13
	local get_selected_layout_name = self.parent:get_selected_layout_name()

	if get_selected_layout_name ~= self._selected_layout_name then
		self:_set_selected_option(get_selected_layout_name)
	end
end

StartGameWindowGameMode.draw = function (self, arg_14_1)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_14_1, nil, self.render_settings)

	for k, v in pairs(self._widgets_by_name) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	local _game_mode_widgets = self._game_mode_widgets

	for k_2 = 1, #_game_mode_widgets do
		local var_14_4 = _game_mode_widgets[k_2]

		if not var_14_4.content.disabled then
			UIRenderer.draw_widget(ui_renderer, var_14_4)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowGameMode._play_sound = function (self, arg_15_1)
	-- function 15
	self.parent:play_sound(arg_15_1)
end
