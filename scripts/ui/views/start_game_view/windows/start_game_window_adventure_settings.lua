-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_adventure_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_settings_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowAdventureSettings = class(StartGameWindowAdventureSettings)
StartGameWindowAdventureSettings.NAME = "StartGameWindowAdventureSettings"

StartGameWindowAdventureSettings.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowAdventureSettings")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._mechanism_name = Managers.mechanism:current_mechanism_name()

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

StartGameWindowAdventureSettings.create_ui_elements = function (self, arg_2_1, arg_2_2)
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
	tbl_2.game_option_reward.content.button_hotspot.disable_button = true

	local game_option_difficulty = tbl_2.game_option_difficulty
	local _animate_pulse = self:_animate_pulse(game_option_difficulty.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(game_option_difficulty, _animate_pulse)
end

StartGameWindowAdventureSettings.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowAdventureSettings")

	self.ui_animator = nil
end

StartGameWindowAdventureSettings.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_difficulty_option()
	self:_update_animations(arg_4_1)
	self:_handle_input(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

StartGameWindowAdventureSettings.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

StartGameWindowAdventureSettings._update_animations = function (self, arg_6_1)
	-- function 6
	self:_update_game_options_hover_effect()

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

StartGameWindowAdventureSettings._is_button_released = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowAdventureSettings._is_button_hover_enter = function (arg_8_0, arg_8_1)
	-- function 8
	return arg_8_1.content.button_hotspot.on_hover_enter
end

StartGameWindowAdventureSettings._is_button_hover_exit = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.on_hover_exit
end

StartGameWindowAdventureSettings._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _widgets_by_name = self._widgets_by_name

	if self:_is_button_hover_enter(_widgets_by_name.game_option_difficulty) or not self:_is_button_hover_enter(_widgets_by_name.play_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	local parent = self.parent

	if not self:_is_button_released(_widgets_by_name.game_option_difficulty) then
		parent:set_layout_by_name("difficulty_selection_adventure")
	end

	local window_input_service = self.parent:window_input_service()

	if not Managers.input:is_device_active("gamepad") then
		-- Nothing
	end

	::label_10_0::

	local _enable_play = self._enable_play

	_enable_play = not _enable_play and window_input_service:get("refresh_press")

	::label_10_1::

	if self:_is_button_released(_widgets_by_name.play_button) or not _enable_play then
		local get_quickplay_settings = parent:get_quickplay_settings(self._mechanism_name)

		get_quickplay_settings = get_quickplay_settings or parent:get_quickplay_settings("adventure")

		local game_mode_type = get_quickplay_settings.game_mode_type

		parent:set_private_option_enabled(false)
		parent:play(arg_10_2, game_mode_type)
	end
end

StartGameWindowAdventureSettings._play_sound = function (self, arg_11_1)
	-- function 11
	self.parent:play_sound(arg_11_1)
end

StartGameWindowAdventureSettings._update_difficulty_option = function (self)
	-- function 12
	local get_difficulty_option = self.parent:get_difficulty_option()

	if get_difficulty_option ~= self._difficulty_key then
		self:_set_difficulty_option(get_difficulty_option)

		self._difficulty_key = get_difficulty_option
		self._enable_play = DifficultySettings[get_difficulty_option] ~= nil
		self._widgets_by_name.play_button.content.button_hotspot.disable_button = not self._enable_play
		self._widgets_by_name.game_option_reward.content.button_hotspot.disable_button = not self._enable_play

		if not self._enable_play then
			self.parent:set_input_description("play_available")
		else
			self.parent:set_input_description(nil)
		end
	end
end

StartGameWindowAdventureSettings._set_difficulty_option = function (self, arg_13_1)
	-- function 13
	local var_13_0 = DifficultySettings[arg_13_1]
	local flag = not var_13_0 and var_13_0.display_name
	local flag_2 = not var_13_0 and var_13_0.display_image
	local completed_frame_texture

	if not var_13_0 then
		completed_frame_texture = var_13_0.completed_frame_texture

		if not completed_frame_texture then
			-- Nothing
		end
	end

	completed_frame_texture = "map_frame_00"

	::label_13_0::

	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.game_option_difficulty.content
	local var_13_6

	if not flag then
		var_13_6 = Localize(flag)

		if not var_13_6 then
			-- Nothing
		end
	end

	var_13_6 = ""

	::label_13_1::

	content.option_text = var_13_6
	_widgets_by_name.game_option_difficulty.content.icon = flag_2 or nil
	_widgets_by_name.game_option_difficulty.content.icon_frame = completed_frame_texture
end

StartGameWindowAdventureSettings.draw = function (self, arg_14_1)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_14_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_14_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_14_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowAdventureSettings._play_sound = function (self, arg_15_1)
	-- function 15
	self.parent:play_sound(arg_15_1)
end

StartGameWindowAdventureSettings._update_game_options_hover_effect = function (self)
	-- function 16
	local game_option_difficulty = self._widgets_by_name.game_option_difficulty

	if not self:_is_button_hover_enter(game_option_difficulty) then
		self:_on_option_button_hover_enter(game_option_difficulty, 1)
	elseif not self:_is_button_hover_exit(game_option_difficulty) then
		self:_on_option_button_hover_exit(game_option_difficulty, 1)
	end
end

StartGameWindowAdventureSettings._on_option_button_hover_enter = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	self:_create_style_animation_enter(arg_17_1, 255, "glow", arg_17_2, arg_17_3)
	self:_create_style_animation_enter(arg_17_1, 255, "icon_glow", arg_17_2, arg_17_3)
	self:_create_style_animation_exit(arg_17_1, 0, "button_hover_rect", arg_17_2, arg_17_3)
end

StartGameWindowAdventureSettings._on_option_button_hover_exit = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	self:_create_style_animation_exit(arg_18_1, 0, "glow", arg_18_2, arg_18_3)
	self:_create_style_animation_exit(arg_18_1, 0, "icon_glow", arg_18_2, arg_18_3)
	self:_create_style_animation_enter(arg_18_1, 30, "button_hover_rect", arg_18_2, arg_18_3)
end

StartGameWindowAdventureSettings._create_style_animation_enter = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local var_19_0 = arg_19_1.style[arg_19_3]

	if not var_19_0 then
		return
	end

	local var_19_1 = var_19_0.color[1]
	local var_19_2 = arg_19_2
	local num = 0.2
	local num_2 = (1 - var_19_1 / var_19_2) * num

	if not (not (num_2 > 0) or arg_19_5) then
		self._ui_animations[("game_option_" .. arg_19_3) .. "_hover_" .. arg_19_4] = self:_animate_element_by_time(var_19_0.color, 1, var_19_1, var_19_2, num_2)
	else
		var_19_0.color[1] = var_19_2
	end
end

StartGameWindowAdventureSettings._create_style_animation_exit = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local var_20_0 = arg_20_1.style[arg_20_3]

	if not var_20_0 then
		return
	end

	local var_20_1 = var_20_0.color[1]
	local var_20_2 = arg_20_2
	local num = 0.2
	local num_2 = var_20_1 / 255 * num

	if not (not (num_2 > 0) or arg_20_5) then
		self._ui_animations[("game_option_" .. arg_20_3) .. "_hover_" .. arg_20_4] = self:_animate_element_by_time(var_20_0.color, 1, var_20_1, var_20_2, num_2)
	else
		var_20_0.color[1] = var_20_2
	end
end

StartGameWindowAdventureSettings._animate_pulse = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5))
end

StartGameWindowAdventureSettings._animate_element_by_time = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	return (UIAnimation.init(UIAnimation.function_by_time, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, math.ease_out_quad))
end
