-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_twitch_game_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_game_settings_definitions")
local widgets = var_0_0.widgets
local other_options_widgets = var_0_0.other_options_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowTwitchGameSettings = class(StartGameWindowTwitchGameSettings)
StartGameWindowTwitchGameSettings.NAME = "StartGameWindowTwitchGameSettings"

StartGameWindowTwitchGameSettings.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowTwitchGameSettings")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._mechanism_name = Managers.mechanism:current_mechanism_name()

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._enable_play = false
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self._twitch_active = nil

	self:_update_difficulty_option()
end

StartGameWindowTwitchGameSettings.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local is_dedicated_server = self._network_lobby:is_dedicated_server()
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_4 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_4
		tbl_2[k] = var_2_4
	end

	local tbl_3 = {}

	for k_2, v_2 in pairs(other_options_widgets) do
		local var_2_6 = UIWidget.init(v_2)

		var_2_6.content.visible = not is_dedicated_server
		tbl_3[#tbl_3 + 1] = var_2_6
		tbl_2[k_2] = var_2_6
	end

	self._widgets = tbl
	self._other_options_widgets = tbl_3
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
	tbl_2.game_option_2.content.button_hotspot.disable_button = true

	self:_set_additional_options_enabled_state(false)
	self:_update_additional_options(true)

	local game_option_1 = tbl_2.game_option_1
	local _animate_pulse = self:_animate_pulse(game_option_1.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(game_option_1, _animate_pulse)

	local game_option_2 = tbl_2.game_option_2
	local _animate_pulse_2 = self:_animate_pulse(game_option_2.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(game_option_2, _animate_pulse_2)
end

StartGameWindowTwitchGameSettings._set_additional_options_enabled_state = function (self, arg_3_1)
	-- function 3
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.additional_option.content.button_hotspot.disable_button = not arg_3_1
	_widgets_by_name.private_button.content.button_hotspot.disable_button = not arg_3_1
	_widgets_by_name.host_button.content.button_hotspot.disable_button = not arg_3_1
	_widgets_by_name.strict_matchmaking_button.content.button_hotspot.disable_button = not arg_3_1
	self._additional_option_enabled = arg_3_1
end

StartGameWindowTwitchGameSettings.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowTwitchGameSettings")

	self.ui_animator = nil
end

StartGameWindowTwitchGameSettings.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_mission_selection()

	if not self._additional_option_enabled then
		self:_update_additional_options()
	end

	self:_update_difficulty_option()
	self:_update_animations(arg_5_1)
	self:_handle_input(arg_5_1, arg_5_2)
	self:draw(arg_5_1)
end

StartGameWindowTwitchGameSettings.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowTwitchGameSettings._update_animations = function (self, arg_7_1)
	-- function 7
	self:_update_game_options_hover_effect()

	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	self.ui_animator:update(arg_7_1)
end

StartGameWindowTwitchGameSettings._is_button_released = function (arg_8_0, arg_8_1)
	-- function 8
	local button_hotspot = arg_8_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowTwitchGameSettings._is_button_hover_enter = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.on_hover_enter
end

StartGameWindowTwitchGameSettings._is_button_hover_exit = function (arg_10_0, arg_10_1)
	-- function 10
	return arg_10_1.content.button_hotspot.on_hover_exit
end

StartGameWindowTwitchGameSettings._is_other_option_button_selected = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self:_is_button_released(arg_11_1) then
		local flag = not arg_11_2

		if not flag then
			self:_play_sound("play_gui_lobby_button_03_private")
		else
			self:_play_sound("play_gui_lobby_button_03_public")
		end

		return flag
	end

	return nil
end

StartGameWindowTwitchGameSettings._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name

	if not self._additional_option_enabled then
		local private_button = _widgets_by_name.private_button

		UIWidgetUtils.animate_default_checkbox_button(private_button, arg_12_1)

		local _is_other_option_button_selected = self:_is_other_option_button_selected(private_button, self._private_enabled)

		if _is_other_option_button_selected ~= nil then
			parent:set_private_option_enabled(_is_other_option_button_selected)
		end

		local host_button = _widgets_by_name.host_button
		local strict_matchmaking_button = _widgets_by_name.strict_matchmaking_button

		UIWidgetUtils.animate_default_checkbox_button(host_button, arg_12_1)
		UIWidgetUtils.animate_default_checkbox_button(strict_matchmaking_button, arg_12_1)

		if self:_is_button_hover_enter(_widgets_by_name.game_option_1) or self:_is_button_hover_enter(_widgets_by_name.game_option_2) or not self:_is_button_hover_enter(_widgets_by_name.play_button) then
			self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
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

	local get_twitch_settings = parent:get_twitch_settings(self._mechanism_name)

	get_twitch_settings = get_twitch_settings or parent:get_twitch_settings("adventure")

	if not self:_is_button_released(_widgets_by_name.game_option_1) then
		parent:set_layout_by_name(get_twitch_settings.layout_name)
	elseif not self:_is_button_released(_widgets_by_name.game_option_2) then
		parent:set_layout_by_name("difficulty_selection_twitch")
	end

	if not self:_is_button_released(_widgets_by_name.play_button) then
		parent:play(arg_12_2, get_twitch_settings.game_mode_type)
	end
end

StartGameWindowTwitchGameSettings._play_sound = function (self, arg_13_1)
	-- function 13
	self.parent:play_sound(arg_13_1)
end

StartGameWindowTwitchGameSettings._update_game_options_hover_effect = function (self)
	-- function 14
	local _widgets_by_name = self._widgets_by_name
	local str = "game_option_"

	for i = 1, 2 do
		local var_14_2 = _widgets_by_name[str .. i]

		if not self:_is_button_hover_enter(var_14_2) then
			self:_on_option_button_hover_enter(i)
		elseif not self:_is_button_hover_exit(var_14_2) then
			self:_on_option_button_hover_exit(i)
		end
	end
end

StartGameWindowTwitchGameSettings._on_option_button_hover_enter = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = self._widgets_by_name["game_option_" .. arg_15_1]

	self:_create_style_animation_enter(var_15_0, 255, "glow", arg_15_1, arg_15_2)
	self:_create_style_animation_enter(var_15_0, 255, "icon_glow", arg_15_1, arg_15_2)
	self:_create_style_animation_exit(var_15_0, 0, "button_hover_rect", arg_15_1, arg_15_2)
end

StartGameWindowTwitchGameSettings._on_option_button_hover_exit = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self._widgets_by_name["game_option_" .. arg_16_1]

	self:_create_style_animation_exit(var_16_0, 0, "glow", arg_16_1, arg_16_2)
	self:_create_style_animation_exit(var_16_0, 0, "icon_glow", arg_16_1, arg_16_2)
	self:_create_style_animation_enter(var_16_0, 30, "button_hover_rect", arg_16_1, arg_16_2)
end

StartGameWindowTwitchGameSettings._update_additional_options = function (self, arg_17_1)
	-- function 17
	local flag = true
	local flag_2 = true
	local flag_3 = false
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	local flag_4 = self._network_lobby:members():get_member_count() == 1

	if not (arg_17_1 or flag_4 ~= self._is_alone or flag ~= self._private_enabled or flag_2 ~= self._always_host_enabled or flag_3 ~= self._strict_matchmaking_enabled or twitch == self._twitch_active) then
		local _widgets_by_name = self._widgets_by_name
		local flag_5 = true
		local flag_6 = true
		local flag_7 = false
		local private_button = _widgets_by_name.private_button

		private_button.content.button_hotspot.disable_button = true
		private_button.content.button_hotspot.is_selected = flag_5
		private_button.style.hover_glow.color[1] = 0

		local host_button = _widgets_by_name.host_button

		host_button.content.button_hotspot.disable_button = true
		host_button.content.button_hotspot.is_selected = flag_6
		host_button.style.hover_glow.color[1] = 0

		local strict_matchmaking_button = _widgets_by_name.strict_matchmaking_button

		strict_matchmaking_button.content.button_hotspot.disable_button = true
		strict_matchmaking_button.content.button_hotspot.is_selected = flag_7
		strict_matchmaking_button.style.hover_glow.color[1] = 0
		self._private_enabled = flag
		self._always_host_enabled = flag_2
		self._strict_matchmaking_enabled = flag_3
		self._twitch_active = twitch
		self._is_alone = flag_4
	end
end

StartGameWindowTwitchGameSettings._update_difficulty_option = function (self)
	-- function 18
	local get_difficulty_option = self.parent:get_difficulty_option()
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	if not (get_difficulty_option ~= self._difficulty_key or twitch == self._twitch_active) then
		self:_set_difficulty_option(get_difficulty_option)

		self._difficulty_key = get_difficulty_option

		local flag = DifficultySettings[get_difficulty_option] == nil or rawget(LevelSettings, self._selected_level_id) ~= nil
		local _widgets_by_name = self._widgets_by_name

		self._enable_play = not flag and twitch
		_widgets_by_name.play_button.content.button_hotspot.disable_button = not self._enable_play

		if not self._enable_play then
			self.parent:set_input_description("play_available")
		else
			self.parent:set_input_description(nil)
		end
	end
end

StartGameWindowTwitchGameSettings._set_difficulty_option = function (self, arg_19_1)
	-- function 19
	local var_19_0 = DifficultySettings[arg_19_1]
	local flag = not var_19_0 and var_19_0.display_name
	local flag_2 = not var_19_0 and var_19_0.display_image
	local completed_frame_texture

	if not var_19_0 then
		completed_frame_texture = var_19_0.completed_frame_texture

		if not completed_frame_texture then
			-- Nothing
		end
	end

	completed_frame_texture = "map_frame_00"

	::label_19_0::

	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.game_option_2.content
	local var_19_6

	if not flag then
		var_19_6 = Localize(flag)

		if not var_19_6 then
			-- Nothing
		end
	end

	var_19_6 = ""

	::label_19_1::

	content.option_text = var_19_6
	_widgets_by_name.game_option_2.content.icon = flag_2 or nil
	_widgets_by_name.game_option_2.content.icon_frame = completed_frame_texture
end

StartGameWindowTwitchGameSettings._update_mission_selection = function (self)
	-- function 20
	local get_selected_level_id = self.parent:get_selected_level_id()

	if not (not get_selected_level_id and get_selected_level_id == self._selected_level_id) then
		self:_set_selected_level(get_selected_level_id)

		self._selected_level_id = get_selected_level_id
	end

	self._widgets_by_name.game_option_2.content.button_hotspot.disable_button = get_selected_level_id == nil
end

StartGameWindowTwitchGameSettings._set_selected_level = function (self, arg_21_1)
	-- function 21
	local game_option_1 = self._widgets_by_name.game_option_1
	local str = "n/a"

	if not arg_21_1 then
		local var_21_2 = LevelSettings[arg_21_1]
		local display_name = var_21_2.display_name
		local level_image = var_21_2.level_image

		str = Localize(display_name)

		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(level_image)
		local texture_size = game_option_1.style.icon.texture_size

		texture_size[1] = get_atlas_settings_by_texture_name.size[1]
		texture_size[2] = get_atlas_settings_by_texture_name.size[2]
		game_option_1.content.icon = level_image

		local get_completed_level_difficulty_index = self.parent:get_completed_level_difficulty_index(self.statistics_db, self._stats_id, arg_21_1)
		local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(get_completed_level_difficulty_index)

		game_option_1.content.icon_frame = get_level_frame_by_difficulty_index
	end

	game_option_1.content.option_text = str
end

StartGameWindowTwitchGameSettings.draw = function (self, arg_22_1)
	-- function 22
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_22_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_22_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_22_4)
	end

	local _other_options_widgets = self._other_options_widgets

	for j = 1, #_other_options_widgets do
		local var_22_6 = _other_options_widgets[j]

		UIRenderer.draw_widget(ui_renderer, var_22_6)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowTwitchGameSettings._play_sound = function (self, arg_23_1)
	-- function 23
	self.parent:play_sound(arg_23_1)
end

StartGameWindowTwitchGameSettings._create_style_animation_enter = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local var_24_0 = arg_24_1.style[arg_24_3]

	if not var_24_0 then
		return
	end

	local var_24_1 = var_24_0.color[1]
	local var_24_2 = arg_24_2
	local num = 0.2
	local num_2 = (1 - var_24_1 / var_24_2) * num

	if not (not (num_2 > 0) or arg_24_5) then
		self._ui_animations[("game_option_" .. arg_24_3) .. "_hover_" .. arg_24_4] = self:_animate_element_by_time(var_24_0.color, 1, var_24_1, var_24_2, num_2)
	else
		var_24_0.color[1] = var_24_2
	end
end

StartGameWindowTwitchGameSettings._create_style_animation_exit = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local var_25_0 = arg_25_1.style[arg_25_3]

	if not var_25_0 then
		return
	end

	local var_25_1 = var_25_0.color[1]
	local var_25_2 = arg_25_2
	local num = 0.2
	local num_2 = var_25_1 / 255 * num

	if not (not (num_2 > 0) or arg_25_5) then
		self._ui_animations[("game_option_" .. arg_25_3) .. "_hover_" .. arg_25_4] = self:_animate_element_by_time(var_25_0.color, 1, var_25_1, var_25_2, num_2)
	else
		var_25_0.color[1] = var_25_2
	end
end

StartGameWindowTwitchGameSettings._animate_pulse = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5))
end

StartGameWindowTwitchGameSettings._animate_element_by_time = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	-- function 27
	return (UIAnimation.init(UIAnimation.function_by_time, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, math.ease_out_quad))
end
