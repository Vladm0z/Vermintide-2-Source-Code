-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_adventure_mode_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_mode_settings_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowAdventureModeSettings = class(StartGameWindowAdventureModeSettings)
StartGameWindowAdventureModeSettings.NAME = "StartGameWindowAdventureModeSettings"

StartGameWindowAdventureModeSettings.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowAdventureModeSettings")

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
	self:_update_next_level_option()
end

StartGameWindowAdventureModeSettings.create_ui_elements = function (self, arg_2_1, arg_2_2)
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
	tbl_2.game_option_next_mission.content.button_hotspot.disable_button = false

	local game_option_difficulty = tbl_2.game_option_difficulty
	local _animate_pulse = self:_animate_pulse(game_option_difficulty.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(game_option_difficulty, _animate_pulse)
end

StartGameWindowAdventureModeSettings.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowAdventureModeSettings")

	self.ui_animator = nil
end

StartGameWindowAdventureModeSettings.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_difficulty_option()
	self:_update_animations(arg_4_1)
	self:_handle_input(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

StartGameWindowAdventureModeSettings.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

StartGameWindowAdventureModeSettings._update_animations = function (self, arg_6_1)
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

StartGameWindowAdventureModeSettings._is_button_released = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowAdventureModeSettings._is_button_hover_enter = function (arg_8_0, arg_8_1)
	-- function 8
	return arg_8_1.content.button_hotspot.on_hover_enter
end

StartGameWindowAdventureModeSettings._is_button_hover_exit = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.on_hover_exit
end

StartGameWindowAdventureModeSettings._handle_input = function (self, arg_10_1, arg_10_2)
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
		parent:set_private_option_enabled(true)
		parent:play(arg_10_2, "adventure_mode")
	end
end

StartGameWindowAdventureModeSettings._play_sound = function (self, arg_11_1)
	-- function 11
	self.parent:play_sound(arg_11_1)
end

StartGameWindowAdventureModeSettings._update_difficulty_option = function (self)
	-- function 12
	local parent = self.parent
	local get_difficulty_option = parent:get_difficulty_option()

	if get_difficulty_option == nil then
		parent:set_difficulty_option(DefaultAdventureModeStartingDifficulty)
	end

	if get_difficulty_option ~= self._difficulty_key then
		self:_set_difficulty_option(get_difficulty_option)

		self._difficulty_key = get_difficulty_option
		self._enable_play = DifficultySettings[get_difficulty_option] == nil or rawget(LevelSettings, self._selected_level_id) ~= nil
		self._widgets_by_name.play_button.content.button_hotspot.disable_button = not self._enable_play

		if not self._enable_play then
			self.parent:set_input_description("play_available")
		else
			self.parent:set_input_description(nil)
		end
	end
end

StartGameWindowAdventureModeSettings._update_next_level_option = function (self)
	-- function 13
	local get_next_adventure_level = LevelUnlockUtils.get_next_adventure_level(self.statistics_db, self._stats_id)

	self.parent:set_selected_level_id(get_next_adventure_level)
	self:_set_selected_level(get_next_adventure_level)
end

StartGameWindowAdventureModeSettings._set_selected_level = function (self, arg_14_1)
	-- function 14
	local game_option_next_mission = self._widgets_by_name.game_option_next_mission
	local str = "n/a"

	if not arg_14_1 then
		local var_14_2 = LevelSettings[arg_14_1]
		local display_name = var_14_2.display_name
		local level_image = var_14_2.level_image

		str = Localize(display_name)

		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(level_image)
		local texture_size = game_option_next_mission.style.icon.texture_size

		texture_size[1] = get_atlas_settings_by_texture_name.size[1]
		texture_size[2] = get_atlas_settings_by_texture_name.size[2]
		game_option_next_mission.content.icon = level_image

		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(self.statistics_db, self._stats_id, arg_14_1)

		completed_level_difficulty_index = completed_level_difficulty_index or 0

		local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)

		game_option_next_mission.content.icon_frame = get_level_frame_by_difficulty_index
	end

	game_option_next_mission.content.option_text = str
end

StartGameWindowAdventureModeSettings._set_difficulty_option = function (self, arg_15_1)
	-- function 15
	local var_15_0 = DifficultySettings[arg_15_1]
	local flag = not var_15_0 and var_15_0.display_name
	local flag_2 = not var_15_0 and var_15_0.display_image
	local completed_frame_texture

	if not var_15_0 then
		completed_frame_texture = var_15_0.completed_frame_texture

		if not completed_frame_texture then
			-- Nothing
		end
	end

	completed_frame_texture = "map_frame_00"

	::label_15_0::

	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.game_option_difficulty.content
	local var_15_6

	if not flag then
		var_15_6 = Localize(flag)

		if not var_15_6 then
			-- Nothing
		end
	end

	var_15_6 = ""

	::label_15_1::

	content.option_text = var_15_6
	_widgets_by_name.game_option_difficulty.content.icon = flag_2 or nil
	_widgets_by_name.game_option_difficulty.content.icon_frame = completed_frame_texture
end

StartGameWindowAdventureModeSettings.draw = function (self, arg_16_1)
	-- function 16
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_16_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_16_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_16_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowAdventureModeSettings._play_sound = function (self, arg_17_1)
	-- function 17
	self.parent:play_sound(arg_17_1)
end

StartGameWindowAdventureModeSettings._update_game_options_hover_effect = function (self)
	-- function 18
	local game_option_difficulty = self._widgets_by_name.game_option_difficulty

	if not self:_is_button_hover_enter(game_option_difficulty) then
		self:_on_option_button_hover_enter(game_option_difficulty, 1)
	elseif not self:_is_button_hover_exit(game_option_difficulty) then
		self:_on_option_button_hover_exit(game_option_difficulty, 1)
	end
end

StartGameWindowAdventureModeSettings._on_option_button_hover_enter = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	self:_create_style_animation_enter(arg_19_1, 255, "glow", arg_19_2, arg_19_3)
	self:_create_style_animation_enter(arg_19_1, 255, "icon_glow", arg_19_2, arg_19_3)
	self:_create_style_animation_exit(arg_19_1, 0, "button_hover_rect", arg_19_2, arg_19_3)
end

StartGameWindowAdventureModeSettings._on_option_button_hover_exit = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	self:_create_style_animation_exit(arg_20_1, 0, "glow", arg_20_2, arg_20_3)
	self:_create_style_animation_exit(arg_20_1, 0, "icon_glow", arg_20_2, arg_20_3)
	self:_create_style_animation_enter(arg_20_1, 30, "button_hover_rect", arg_20_2, arg_20_3)
end

StartGameWindowAdventureModeSettings._create_style_animation_enter = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	local var_21_0 = arg_21_1.style[arg_21_3]

	if not var_21_0 then
		return
	end

	local var_21_1 = var_21_0.color[1]
	local var_21_2 = arg_21_2
	local num = 0.2
	local num_2 = (1 - var_21_1 / var_21_2) * num

	if not (not (num_2 > 0) or arg_21_5) then
		self._ui_animations[("game_option_" .. arg_21_3) .. "_hover_" .. arg_21_4] = self:_animate_element_by_time(var_21_0.color, 1, var_21_1, var_21_2, num_2)
	else
		var_21_0.color[1] = var_21_2
	end
end

StartGameWindowAdventureModeSettings._create_style_animation_exit = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local var_22_0 = arg_22_1.style[arg_22_3]

	if not var_22_0 then
		return
	end

	local var_22_1 = var_22_0.color[1]
	local var_22_2 = arg_22_2
	local num = 0.2
	local num_2 = var_22_1 / 255 * num

	if not (not (num_2 > 0) or arg_22_5) then
		self._ui_animations[("game_option_" .. arg_22_3) .. "_hover_" .. arg_22_4] = self:_animate_element_by_time(var_22_0.color, 1, var_22_1, var_22_2, num_2)
	else
		var_22_0.color[1] = var_22_2
	end
end

StartGameWindowAdventureModeSettings._animate_pulse = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5))
end

StartGameWindowAdventureModeSettings._animate_element_by_time = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	return (UIAnimation.init(UIAnimation.function_by_time, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, math.ease_out_quad))
end
