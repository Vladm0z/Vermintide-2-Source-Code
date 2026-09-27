-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_custom_game.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_custom_game_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local animation_definitions = var_0_0.animation_definitions
local selector_input_definition = var_0_0.selector_input_definition
local str = "refresh_press"
local str_2 = "confirm_press"

StartGameWindowVersusCustomGame = class(StartGameWindowVersusCustomGame)
StartGameWindowVersusCustomGame.NAME = "StartGameWindowVersusCustomGame"

StartGameWindowVersusCustomGame.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowVersusCustomGame")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._mechanism_name = Managers.mechanism:current_mechanism_name()
	self._stats_id = Managers.player:local_player():stats_id()
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)

	local input_index = arg_1_1.input_index

	input_index = input_index or 1
	self._input_index = input_index

	self:_handle_new_selection(self._input_index)

	self._is_focused = false
	self._play_button_pressed = false
	self._previous_can_play = nil

	local flag = not Managers.account:offline_mode()

	self._is_online = flag

	if not flag then
		self._parent:change_generic_actions("default_custom_game")
	else
		self._parent:change_generic_actions("offline_custom_game")
	end

	self:_start_transition_animation("on_enter")
end

StartGameWindowVersusCustomGame._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowVersusCustomGame._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self._ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_3
		tbl_2[k] = var_3_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

StartGameWindowVersusCustomGame.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameViewWindow] Exit Substate StartGameWindowVersusCustomGame")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = self._input_index
	end
end

StartGameWindowVersusCustomGame.set_focus = function (self, arg_5_1)
	-- function 5
	self._is_focused = arg_5_1
end

StartGameWindowVersusCustomGame.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local is_device_active = Managers.input:is_device_active("gamepad")

	self:_update_can_play()
	self:_update_animations(arg_6_1)

	if not self._is_focused then
		self:_handle_input(arg_6_1, arg_6_2)
		self:_update_play_button_texture(is_device_active)
	end

	self:_draw(arg_6_1)
end

StartGameWindowVersusCustomGame.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowVersusCustomGame._update_can_play = function (self)
	-- function 8
	local _can_play = self:_can_play()

	if self._previous_can_play ~= _can_play then
		self._previous_can_play = _can_play

		local play_button = self._widgets_by_name.play_button

		play_button.content.button_hotspot.disable_button = not _can_play
		play_button.content.disabled = not _can_play

		if not _can_play then
			self._parent:set_input_description("play_available")
		else
			self._parent:set_input_description(nil)
		end
	end
end

StartGameWindowVersusCustomGame._handle_input = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()

	if not window_input_service:get(str_2, true) then
		self:_option_selected(self._input_index, arg_9_2)
	end

	local _input_index = self._input_index

	if not window_input_service:get("move_down") then
		_input_index = _input_index + 1
	elseif not window_input_service:get("move_up") then
		_input_index = _input_index - 1
	end

	if _input_index ~= self._input_index then
		self:_handle_new_selection(_input_index)
	end

	local _widgets_by_name = self._widgets_by_name

	for i = 1, #selector_input_definition do
		local var_9_4 = _widgets_by_name[selector_input_definition[i]]

		if var_9_4.content.is_selected or not UIUtils.is_button_hover_enter(var_9_4) then
			self:_handle_new_selection(i)
		end

		if not UIUtils.is_button_pressed(var_9_4) then
			self:_option_selected(self._input_index, arg_9_2)
		end
	end

	if not self:_can_play() then
		if not UIUtils.is_button_hover_enter(_widgets_by_name.play_button) then
			self._parent:play_sound("Play_hud_hover")
		end

		if window_input_service:get(str) or not UIUtils.is_button_pressed(_widgets_by_name.play_button) then
			self._play_button_pressed = true

			self:_play()
		end
	end

	local flag = true

	if not window_input_service:get("right_stick_press", flag) and not self._is_online then
		_parent:set_window_input_focus("versus_additional_custom_settings")
	end
end

StartGameWindowVersusCustomGame._can_play = function (self)
	-- function 10
	local network_id = Managers.player:local_player():network_id()
	local var_10_1
	local var_10_2
	local get_local_player_party = Managers.party:get_local_player_party()
	local flag = not get_local_player_party and get_local_player_party.num_used_slots == 1

	if not DEDICATED_SERVER then
		var_10_2 = Managers.party:client_is_friend_party_leader(network_id) or Managers.party:is_leader(network_id)
	else
		var_10_2 = Managers.party:is_leader(network_id) or self._ingame_ui_context.is_server
	end

	return flag or var_10_2
end

StartGameWindowVersusCustomGame._play = function (self)
	-- function 11
	self._parent:play_sound("Play_vs_hud_play_menu_host_lobby")
	self._parent:set_layout_by_name("versus_player_hosted_lobby")

	local get_selected_level_id = self._parent:get_selected_level_id()

	get_selected_level_id = get_selected_level_id or "any"

	local is_private_option_enabled = self._parent:is_private_option_enabled()
	local lobby = Managers.state.network:lobby()
	local tbl = {
		player_hosted = true,
		matchmaking_start_state = "MatchmakingStatePlayerHostedGame",
		dedicated_server = false,
		matchmaking_type = "custom",
		mechanism = "versus",
		quick_game = false,
		difficulty = "versus_base",
		mission_id = get_selected_level_id,
		any_level = get_selected_level_id == "any",
		private_game = is_private_option_enabled or false,
		party_lobby_host = lobby,
		max_num_players = GameModeSettings.versus.max_num_players
	}

	Managers.matchmaking:find_game(tbl)
end

StartGameWindowVersusCustomGame._option_selected = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _parent = self._parent
	local get_custom_game_settings = _parent:get_custom_game_settings(self._mechanism_name)

	get_custom_game_settings = get_custom_game_settings or _parent:get_custom_game_settings("adventure")

	local var_12_2 = selector_input_definition[arg_12_1]

	if var_12_2 == "mission_setting" then
		self._parent:set_layout_by_name(get_custom_game_settings.layout_name)
	elseif var_12_2 == "difficulty_setting" then
		self._parent:set_layout_by_name("difficulty_selection_custom")
	elseif var_12_2 == "play_button" then
		self._play_button_pressed = true

		self:_play()
	else
		ferror("Unknown selector_input_definition: %s", var_12_2)
	end
end

StartGameWindowVersusCustomGame._handle_new_selection = function (self, arg_13_1)
	-- function 13
	local _widgets_by_name = self._widgets_by_name
	local count = #selector_input_definition

	arg_13_1 = math.clamp(arg_13_1, 1, count)

	if not _widgets_by_name[selector_input_definition[arg_13_1]].content.disabled then
		return
	end

	for i = 1, #selector_input_definition do
		local var_13_2 = _widgets_by_name[selector_input_definition[i]]
		local flag = i ~= arg_13_1 or self._gamepad_active

		var_13_2.content.is_selected = flag
	end

	if self._input_index ~= arg_13_1 then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
	end

	self._input_index = arg_13_1
end

StartGameWindowVersusCustomGame._update_animations = function (self, arg_14_1)
	-- function 14
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_14_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name

	if not _widgets_by_name.play_button.content.button_hotspot.disable_button then
		UIWidgetUtils.animate_play_button(_widgets_by_name.play_button, arg_14_1)
	end
end

StartGameWindowVersusCustomGame._draw = function (self, arg_15_1)
	-- function 15
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_15_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_15_1, var_15_4, _render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_15_6 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_15_6)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowVersusCustomGame._update_play_button_texture = function (self, arg_16_1)
	-- function 16
	local _widgets_by_name = self._widgets_by_name

	if self._gamepad_active ~= arg_16_1 then
		self._gamepad_active = arg_16_1

		if not arg_16_1 then
			local window_input_service = self._parent:window_input_service()
			local str = "refresh"
			local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str, arg_16_1)

			if not get_gamepad_input_texture_data then
				_widgets_by_name.play_button.content.texture_icon_id = get_gamepad_input_texture_data.texture
			end
		else
			_widgets_by_name.play_button.content.texture_icon_id = "options_button_icon_quickplay"
		end

		self:_handle_new_selection(self._input_index)
	end
end
