-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_settings_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowEventSettings = class(StartGameWindowEventSettings)
StartGameWindowEventSettings.NAME = "StartGameWindowEventSettings"

StartGameWindowEventSettings.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowEventSettings")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._enable_play = false
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_update_difficulty_option()
end

StartGameWindowEventSettings.create_ui_elements = function (self, arg_2_1, arg_2_2)
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

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	tbl_2.play_button.content.button_hotspot.disable_button = true

	local game_option_difficulty = tbl_2.game_option_difficulty
	local _animate_pulse = self:_animate_pulse(game_option_difficulty.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(game_option_difficulty, _animate_pulse)
	self:_setup_content_from_backend()
end

StartGameWindowEventSettings._setup_content_from_backend = function (self)
	-- function 3
	local get_weekly_events_game_mode_data = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local event_summary = self._widgets_by_name.event_summary
	local mutators = get_weekly_events_game_mode_data.mutators
	local level_key = get_weekly_events_game_mode_data.level_key

	event_summary.content.item = {
		level_key = level_key,
		mutators = mutators
	}
end

StartGameWindowEventSettings.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowEventSettings")

	self.ui_animator = nil
end

StartGameWindowEventSettings.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_difficulty_option()
	self:_update_animations(arg_5_1)
	self:_handle_input(arg_5_1, arg_5_2)
	self:draw(arg_5_1)
end

StartGameWindowEventSettings.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowEventSettings._update_animations = function (self, arg_7_1)
	-- function 7
	self:_update_game_options_hover_effect()

	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	local ui_animator = self.ui_animator

	ui_animator:update(arg_7_1)

	local _animations = self._animations

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

StartGameWindowEventSettings._is_button_released = function (arg_8_0, arg_8_1)
	-- function 8
	local button_hotspot = arg_8_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowEventSettings._is_button_hover_enter = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.on_hover_enter
end

StartGameWindowEventSettings._is_button_hover_exit = function (arg_10_0, arg_10_1)
	-- function 10
	return arg_10_1.content.button_hotspot.on_hover_exit
end

StartGameWindowEventSettings._handle_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _widgets_by_name = self._widgets_by_name

	if self:_is_button_hover_enter(_widgets_by_name.game_option_difficulty) or not self:_is_button_hover_enter(_widgets_by_name.play_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	local parent = self.parent

	if not self:_is_button_released(_widgets_by_name.game_option_difficulty) then
		parent:set_layout_by_name("difficulty_selection_event")
	end

	local window_input_service = self.parent:window_input_service()

	if not Managers.input:is_device_active("gamepad") then
		-- Nothing
	end

	::label_11_0::

	local _enable_play = self._enable_play

	_enable_play = not _enable_play and window_input_service:get("refresh_press")

	::label_11_1::

	if self:_is_button_released(_widgets_by_name.play_button) or not _enable_play then
		parent:play(arg_11_2, "event")
	end
end

StartGameWindowEventSettings._play_sound = function (self, arg_12_1)
	-- function 12
	self.parent:play_sound(arg_12_1)
end

StartGameWindowEventSettings._update_difficulty_option = function (self)
	-- function 13
	local get_difficulty_option = self.parent:get_difficulty_option()

	if get_difficulty_option ~= self._difficulty_key then
		self:_set_difficulty_option(get_difficulty_option)

		self._difficulty_key = get_difficulty_option
		self._enable_play = DifficultySettings[get_difficulty_option] ~= nil
		self._widgets_by_name.play_button.content.button_hotspot.disable_button = not self._enable_play

		if not self._enable_play then
			self.parent:set_input_description("play_available")
		else
			self.parent:set_input_description(nil)
		end
	end
end

StartGameWindowEventSettings._set_difficulty_option = function (self, arg_14_1)
	-- function 14
	local var_14_0 = DifficultySettings[arg_14_1]
	local flag = not var_14_0 and var_14_0.display_name
	local flag_2 = not var_14_0 and var_14_0.display_image
	local completed_frame_texture

	if not var_14_0 then
		completed_frame_texture = var_14_0.completed_frame_texture

		if not completed_frame_texture then
			-- Nothing
		end
	end

	completed_frame_texture = "map_frame_00"

	::label_14_0::

	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.game_option_difficulty.content
	local var_14_6

	if not flag then
		var_14_6 = Localize(flag)

		if not var_14_6 then
			-- Nothing
		end
	end

	var_14_6 = ""

	::label_14_1::

	content.option_text = var_14_6
	_widgets_by_name.game_option_difficulty.content.icon = flag_2 or nil
	_widgets_by_name.game_option_difficulty.content.icon_frame = completed_frame_texture
end

StartGameWindowEventSettings.draw = function (self, arg_15_1)
	-- function 15
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_15_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_15_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_15_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowEventSettings._play_sound = function (self, arg_16_1)
	-- function 16
	self.parent:play_sound(arg_16_1)
end

StartGameWindowEventSettings._update_game_options_hover_effect = function (self)
	-- function 17
	local game_option_difficulty = self._widgets_by_name.game_option_difficulty

	if not self:_is_button_hover_enter(game_option_difficulty) then
		self:_on_option_button_hover_enter(game_option_difficulty, 1)
	elseif not self:_is_button_hover_exit(game_option_difficulty) then
		self:_on_option_button_hover_exit(game_option_difficulty, 1)
	end
end

StartGameWindowEventSettings._on_option_button_hover_enter = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	self:_create_style_animation_enter(arg_18_1, 255, "glow", arg_18_2, arg_18_3)
	self:_create_style_animation_enter(arg_18_1, 255, "icon_glow", arg_18_2, arg_18_3)
	self:_create_style_animation_exit(arg_18_1, 0, "button_hover_rect", arg_18_2, arg_18_3)
end

StartGameWindowEventSettings._on_option_button_hover_exit = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	self:_create_style_animation_exit(arg_19_1, 0, "glow", arg_19_2, arg_19_3)
	self:_create_style_animation_exit(arg_19_1, 0, "icon_glow", arg_19_2, arg_19_3)
	self:_create_style_animation_enter(arg_19_1, 30, "button_hover_rect", arg_19_2, arg_19_3)
end

StartGameWindowEventSettings._create_style_animation_enter = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local var_20_0 = arg_20_1.style[arg_20_3]

	if not var_20_0 then
		return
	end

	local var_20_1 = var_20_0.color[1]
	local var_20_2 = arg_20_2
	local num = 0.2
	local num_2 = (1 - var_20_1 / var_20_2) * num

	if not (not (num_2 > 0) or arg_20_5) then
		self._ui_animations[("game_option_" .. arg_20_3) .. "_hover_" .. arg_20_4] = self:_animate_element_by_time(var_20_0.color, 1, var_20_1, var_20_2, num_2)
	else
		var_20_0.color[1] = var_20_2
	end
end

StartGameWindowEventSettings._create_style_animation_exit = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	local var_21_0 = arg_21_1.style[arg_21_3]

	if not var_21_0 then
		return
	end

	local var_21_1 = var_21_0.color[1]
	local var_21_2 = arg_21_2
	local num = 0.2
	local num_2 = var_21_1 / 255 * num

	if not (not (num_2 > 0) or arg_21_5) then
		self._ui_animations[("game_option_" .. arg_21_3) .. "_hover_" .. arg_21_4] = self:_animate_element_by_time(var_21_0.color, 1, var_21_1, var_21_2, num_2)
	else
		var_21_0.color[1] = var_21_2
	end
end

StartGameWindowEventSettings._animate_pulse = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5))
end

StartGameWindowEventSettings._animate_element_by_time = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	return (UIAnimation.init(UIAnimation.function_by_time, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, math.ease_out_quad))
end
