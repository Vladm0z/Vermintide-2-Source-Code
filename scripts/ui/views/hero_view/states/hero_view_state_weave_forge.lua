-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_weave_forge.lua

local_require("scripts/ui/views/hero_view/windows/hero_window_weave_properties")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_overview")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_weapons")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_background")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_panel")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_weave_forge_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local console_cursor_definition = var_0_0.console_cursor_definition
local generic_input_actions = var_0_0.generic_input_actions
local flag = false
local tbl = {
	common = 2,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 5
}

HeroViewStateWeaveForge = class(HeroViewStateWeaveForge)
HeroViewStateWeaveForge.NAME = "HeroViewStateWeaveForge"

HeroViewStateWeaveForge.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewState] Enter Substate HeroViewStateWeaveForge")

	self.parent = arg_1_1.parent
	self._gamepad_style_active = self:_setup_menu_layout()

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.voting_manager = ingame_ui_context.voting_manager
	self.profile_synchronizer = ingame_ui_context.profile_synchronizer
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.wwise_world = arg_1_1.wwise_world
	self.ingame_ui = ingame_ui_context.ingame_ui
	self.is_in_inn = ingame_ui_context.is_in_inn
	self.world_previewer = arg_1_1.world_previewer
	self.platform = PLATFORM

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.local_player_id = ingame_ui_context.local_player_id
	self.player = local_player

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)
	local var_1_4 = SPProfiles[profile_by_peer]
	local display_name = var_1_4.display_name
	local character_name = var_1_4.character_name

	self.career_index, self.hero_name = Managers.backend:get_interface("hero_attributes"):get(display_name, "career"), display_name
	self.profile_index = profile_by_peer
	self._animations = {}
	self._ui_animations = {}

	if not IS_WINDOWS then
		self._friends_component_ui = FriendsUIComponent:new(ingame_ui_context)
	end

	self:create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	local tbl = {
		wwise_world = self.wwise_world,
		ingame_ui_context = ingame_ui_context,
		parent = self,
		windows_settings = self._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		hero_name = self.hero_name,
		career_index = self.career_index,
		profile_index = self.profile_index,
		start_state = arg_1_1.start_state
	}

	self:_initial_windows_setups(tbl)

	if not self._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_enter()

		if not self.is_in_inn then
			self:play_sound("play_gui_amb_hero_screen_loop_begin")
			self:_setup_gamepad_gui()
			self:disable_player_world()
		else
			self:enable_ingame_overlay()
		end
	else
		self:play_sound("hud_magic_forge_open")
	end

	Managers.input:enable_gamepad_cursor()
	Managers.state.event:trigger("weave_forge_entered")
end

HeroViewStateWeaveForge.gamepad_style_active = function (self)
	-- function 2
	return self._gamepad_style_active
end

HeroViewStateWeaveForge.get_ui_renderer = function (self)
	-- function 3
	if not self._gamepad_style_active then
		return self._gui_data.bottom.renderer
	else
		return self.ui_renderer
	end
end

HeroViewStateWeaveForge.get_ui_top_renderer = function (self)
	-- function 4
	return self.ui_top_renderer
end

HeroViewStateWeaveForge.hdr_renderer = function (self)
	-- function 5
	return self.parent:hdr_renderer()
end

HeroViewStateWeaveForge.hdr_top_renderer = function (self)
	-- function 6
	return self.parent:hdr_top_renderer()
end

HeroViewStateWeaveForge._setup_gamepad_gui = function (self)
	-- function 7
	if not self.is_in_inn then
		local tbl = {}
		local str = "weave_forge_gamepad"
		local _setup_gamepad_renderer, var_7_3, var_7_4 = self:_setup_gamepad_renderer(str, 1, GameSettingsDevelopment.default_environment)

		tbl.bottom = {
			renderer = _setup_gamepad_renderer,
			world = var_7_3,
			viewport_name = var_7_4
		}
		self._gui_data = tbl
	end
end

HeroViewStateWeaveForge._setup_gamepad_renderer = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_8_1 = arg_8_1
	local var_8_2 = arg_8_1
	local create_world = Managers.world:create_world(var_8_1, arg_8_3, nil, arg_8_2, unpack(tbl))
	local str = "overlay"
	local create_viewport = ScriptWorld.create_viewport(create_world, var_8_2, str, 999)

	return self.ingame_ui:create_ui_renderer(create_world, false, self.is_in_inn), create_world, var_8_2
end

HeroViewStateWeaveForge._destroy_gamepad_gui = function (self)
	-- function 9
	local _gui_data = self._gui_data

	if not _gui_data then
		for k, v in pairs(_gui_data) do
			local renderer = v.renderer
			local world = v.world
			local viewport_name = v.viewport_name

			UIRenderer.destroy(renderer, world)
			ScriptWorld.destroy_viewport(world, viewport_name)
			Managers.world:destroy_world(world)
		end

		self._gui_data = nil
	end
end

HeroViewStateWeaveForge._setup_menu_layout = function (self)
	-- function 10
	local IS_CONSOLE = IS_CONSOLE

	if not IS_CONSOLE then
		IS_CONSOLE = Managers.input:is_device_active("gamepad")
		IS_CONSOLE = IS_CONSOLE or not UISettings.use_pc_menu_layout
	end

	self._layout_settings = local_require("scripts/ui/views/hero_view/states/weave_forge_window_layout")
	self._windows_settings = self._layout_settings.windows
	self._window_layouts = self._layout_settings.window_layouts
	self._max_active_windows = self._layout_settings.max_active_windows

	return IS_CONSOLE
end

HeroViewStateWeaveForge.create_ui_elements = function (self, arg_11_1)
	-- function 11
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._console_cursor_widget = UIWidget.init(console_cursor_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		if not v then
			local var_11_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_11_2
			tbl_2[k] = var_11_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	tbl_2.loading_icon.content.visible = false

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	local num = UILayer.default + 30
	local input_service = self:input_service()
	local _gamepad_style_active = self._gamepad_style_active

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, input_service, 6, num, generic_input_actions.default, _gamepad_style_active)

	self._menu_input_description:set_input_description(nil)

	self._current_input_desc = nil
end

HeroViewStateWeaveForge.set_input_description = function (self, arg_12_1)
	-- function 12
	local var_12_0 = generic_input_actions[arg_12_1]

	if self._current_input_desc == arg_12_1 then
		return
	end

	if not var_12_0 then
		self._menu_input_description:set_input_description(var_12_0)
	else
		self._menu_input_description:set_input_description(nil)
	end

	self._current_input_desc = arg_12_1
end

HeroViewStateWeaveForge.disable_player_world = function (self)
	-- function 13
	if not self._player_world_disabled then
		self._player_world_disabled = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

HeroViewStateWeaveForge.enable_player_world = function (self)
	-- function 14
	if not self._player_world_disabled then
		self._player_world_disabled = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

HeroViewStateWeaveForge.enable_ingame_overlay = function (self)
	-- function 15
	if not self._ingame_overlay_enabled then
		self._ingame_overlay_enabled = true

		local world = Managers.world:world("level_world")

		World.set_data(world, "fullscreen_blur", 0.5)
		World.set_data(world, "greyscale", 1)
	end
end

HeroViewStateWeaveForge.disable_ingame_overlay = function (self)
	-- function 16
	if not self._ingame_overlay_enabled then
		self._ingame_overlay_enabled = false

		local world = Managers.world:world("level_world")

		World.set_data(world, "fullscreen_blur", nil)
		World.set_data(world, "greyscale", nil)
	end
end

HeroViewStateWeaveForge._initial_windows_setups = function (self, arg_17_1)
	-- function 17
	self._active_windows = {}
	self._window_params = arg_17_1
	self._layouts_index_history = {}

	local start_state = arg_17_1.start_state

	if not start_state then
		self:set_layout_by_name(start_state)
	else
		self:set_layout(1)
	end
end

HeroViewStateWeaveForge.window_input_service = function (self)
	-- function 18
	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_18_0::

	return FAKE_INPUT_SERVICE
end

HeroViewStateWeaveForge._close_window_at_index = function (self, arg_19_1)
	-- function 19
	local _active_windows = self._active_windows
	local _window_params = self._window_params
	local var_19_2 = _active_windows[arg_19_1]

	if not var_19_2 and not var_19_2.on_exit then
		var_19_2:on_exit(_window_params)
	end

	_active_windows[arg_19_1] = nil
end

HeroViewStateWeaveForge._change_window = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _active_windows = self._active_windows
	local var_20_1 = self._windows_settings[arg_20_2]
	local class_name = var_20_1.class_name
	local var_20_3 = _active_windows[arg_20_1]

	if not var_20_3 then
		if var_20_3.NAME == class_name then
			return
		end

		self:_close_window_at_index(arg_20_1)
	end

	local var_20_4 = rawget(_G, class_name):new()
	local ignore_alignment = var_20_1.ignore_alignment
	local var_20_6

	if not ignore_alignment then
		local alignment_index = var_20_1.alignment_index

		alignment_index = alignment_index or arg_20_1

		local game_start_windows = UISettings.game_start_windows
		local size = game_start_windows.size
		local spacing = game_start_windows.spacing

		spacing = spacing or 10

		local var_20_11 = size[1]
		local num = spacing * 2
		local num_2 = -(3 * var_20_11 / 2 + var_20_11 / 2) - (num / 2 + spacing) + alignment_index * var_20_11 + alignment_index * spacing

		var_20_6 = {
			num_2,
			0,
			3
		}
	end

	if not var_20_4.on_enter then
		local _window_params = self._window_params

		var_20_4:on_enter(_window_params, var_20_6)
	end

	_active_windows[arg_20_1] = var_20_4
end

HeroViewStateWeaveForge.get_layout_name = function (self)
	-- function 21
	local _selected_layout_index = self._selected_layout_index

	for i, v in ipairs(self._window_layouts) do
		if i == _selected_layout_index then
			return v.name
		end
	end
end

HeroViewStateWeaveForge.set_layout_by_name = function (self, arg_22_1)
	-- function 22
	for i, v in ipairs(self._window_layouts) do
		if v.name == arg_22_1 then
			self:set_layout(i)

			return
		end
	end
end

HeroViewStateWeaveForge.close_on_exit = function (self)
	-- function 23
	return self._close_on_exit
end

HeroViewStateWeaveForge.set_layout = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _get_layout_setting = self:_get_layout_setting(arg_24_1)
	local windows = _get_layout_setting.windows
	local sound_event_enter = _get_layout_setting.sound_event_enter
	local close_on_exit = _get_layout_setting.close_on_exit
	local input_focus_window = _get_layout_setting.input_focus_window
	local name = _get_layout_setting.name

	if not sound_event_enter then
		self:play_sound(sound_event_enter)
	end

	self._widgets_by_name.exit_button.content.visible = close_on_exit
	self._widgets_by_name.back_button.content.visible = not close_on_exit
	self._close_on_exit = close_on_exit

	for i = 1, self._max_active_windows do
		local flag = false

		for k, v in pairs(windows) do
			if v == i then
				self:_change_window(v, k)

				flag = true
			end
		end

		if not flag then
			self:_close_window_at_index(i)
		end
	end

	if not self._selected_layout_index then
		self._previous_selected_layout_index = self._selected_layout_index

		if not arg_24_2 then
			self._layouts_index_history[#self._layouts_index_history + 1] = self._previous_selected_layout_index
		end
	end

	self._selected_layout_name = name
	self._selected_layout_index = arg_24_1

	self:set_window_input_focus(input_focus_window)
end

HeroViewStateWeaveForge.set_window_input_focus = function (self, arg_25_1)
	-- function 25
	local _selected_layout_index = self._selected_layout_index
	local _get_layout_setting = self:_get_layout_setting(_selected_layout_index)
	local var_25_2 = self._windows_settings[arg_25_1]
	local flag = not var_25_2 and var_25_2.class_name
	local flag_2 = false
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		local flag_3 = v.NAME == flag

		if not v.set_focus then
			v:set_focus(flag_3)
		end

		if not flag_3 then
			flag_2 = true
		end
	end

	if not (not arg_25_1 and flag_2) then
		ferror("[HeroViewStateWeaveForge] - (set_window_input_focus) Could not find a window by name: %s", arg_25_1)
	end

	self._window_focused = arg_25_1
end

HeroViewStateWeaveForge.get_selected_layout_name = function (self)
	-- function 26
	return self._selected_layout_name
end

HeroViewStateWeaveForge.get_selected_layout_index = function (self)
	-- function 27
	return self._selected_layout_index
end

HeroViewStateWeaveForge.get_previous_selected_layout_index = function (self)
	-- function 28
	return self._previous_selected_layout_index
end

HeroViewStateWeaveForge._get_layout_setting = function (self, arg_29_1)
	-- function 29
	return self._window_layouts[arg_29_1]
end

HeroViewStateWeaveForge._windows_update = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		v:update(arg_30_1, arg_30_2)
	end
end

HeroViewStateWeaveForge._windows_post_update = function (self, arg_31_1, arg_31_2)
	-- function 31
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		if not v.post_update then
			v:post_update(arg_31_1, arg_31_2)
		end
	end
end

HeroViewStateWeaveForge.enable_widget = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local var_32_0 = self._active_windows[arg_32_1]._widgets_by_name[arg_32_2]

	if not var_32_0 then
		local button_hotspot = var_32_0.content.button_hotspot

		if not button_hotspot then
			button_hotspot.disable_button = not arg_32_3
		end
	end
end

HeroViewStateWeaveForge.transitioning = function (self)
	-- function 33
	if not self.exiting then
		return true
	else
		return false
	end
end

HeroViewStateWeaveForge._wanted_state = function (self)
	-- function 34
	return (self.parent:wanted_state())
end

HeroViewStateWeaveForge.wanted_menu_state = function (self)
	-- function 35
	return self._wanted_menu_state
end

HeroViewStateWeaveForge.clear_wanted_menu_state = function (self)
	-- function 36
	self._wanted_menu_state = nil
end

HeroViewStateWeaveForge.requested_screen_change_by_name = function (self, arg_37_1)
	-- function 37
	self._on_close_next_state = arg_37_1

	self:close_menu()
end

HeroViewStateWeaveForge.on_exit = function (self, arg_38_1)
	-- function 38
	print("[HeroViewState] Exit Substate HeroViewStateWeaveForge")

	self.ui_animator = nil

	local _friends_component_ui = self._friends_component_ui

	if not _friends_component_ui and not self:is_friends_list_active() then
		_friends_component_ui:deactivate_friends_ui()
	end

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	self:_close_active_windows()

	if not self._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_exit()

		if not self.is_in_inn then
			self:play_sound("play_gui_amb_hero_screen_loop_end")
			self:_destroy_gamepad_gui()
			self:enable_player_world()
		else
			self:disable_ingame_overlay()
		end
	else
		self:play_sound("hud_magic_forge_close")
	end

	Managers.input:disable_gamepad_cursor()
end

HeroViewStateWeaveForge._close_active_windows = function (self)
	-- function 39
	local _active_windows = self._active_windows
	local _window_params = self._window_params

	for k, v in pairs(_active_windows) do
		if not v.on_exit then
			v:on_exit(_window_params)
		end
	end

	table.clear(_active_windows)
end

HeroViewStateWeaveForge._update_transition_timer = function (self, arg_40_1)
	-- function 40
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_40_1, 0)
	end
end

HeroViewStateWeaveForge.input_service = function (self)
	-- function 41
	return self.parent:input_service()
end

HeroViewStateWeaveForge.update = function (self, arg_42_1, arg_42_2)
	-- function 42
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local input_manager = self.input_manager
	local window_input_service = self:window_input_service()
	local _friends_component_ui = self._friends_component_ui
	local is_device_active = input_manager:is_device_active("gamepad")

	if not _friends_component_ui and is_device_active or not Managers.account:is_online() then
		_friends_component_ui:update(arg_42_1, window_input_service)
	end

	if not self._gamepad_style_active then
		self:draw(window_input_service, arg_42_1)
	else
		self:draw_gamepad_cursor(window_input_service, arg_42_1)
	end

	self:_update_transition_timer(arg_42_1)
	self:_windows_update(arg_42_1, arg_42_2)

	local transitioning = self.parent:transitioning()
	local _wanted_state = self:_wanted_state()

	if not self._transition_timer then
		if transitioning or not self:_has_active_level_vote() then
			local flag_2 = true

			self:close_menu(flag_2)
		end

		if not _wanted_state then
			self.parent:clear_wanted_state()

			self._new_state = _wanted_state
		else
			return self._new_state
		end
	end
end

HeroViewStateWeaveForge.is_friends_list_active = function (self)
	-- function 43
	local _friends_component_ui = self._friends_component_ui

	if not _friends_component_ui then
		return _friends_component_ui:is_active()
	end

	return false
end

HeroViewStateWeaveForge._handle_friend_joining = function (self)
	-- function 44
	local _friends_component_ui = self._friends_component_ui

	if not _friends_component_ui then
		local join_lobby_data = _friends_component_ui:join_lobby_data()

		if not join_lobby_data and not Managers.matchmaking:allowed_to_initiate_join_lobby() then
			Managers.matchmaking:request_join_lobby(join_lobby_data)
			self:close_menu(true)

			return true
		end
	end
end

HeroViewStateWeaveForge._has_active_level_vote = function (self)
	-- function 45
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	return not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
end

HeroViewStateWeaveForge.post_update = function (self, arg_46_1, arg_46_2)
	-- function 46
	self.ui_animator:update(arg_46_1)
	self:_update_animations(arg_46_1)

	if not (self._transition_timer or self._new_state or self.parent:transitioning() or self:_has_active_level_vote()) then
		self:_handle_input(arg_46_1, arg_46_2)
	end

	self:_windows_post_update(arg_46_1, arg_46_2)

	if not self._new_state then
		self:_close_active_windows()
	end
end

HeroViewStateWeaveForge._update_animations = function (self, arg_47_1)
	-- function 47
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_47_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroViewStateWeaveForge._is_button_hover_enter = function (arg_48_0, arg_48_1)
	-- function 48
	return arg_48_1.content.button_hotspot.on_hover_enter
end

HeroViewStateWeaveForge._handle_input = function (self, arg_49_1, arg_49_2)
	-- function 49
	local _input_blocked = self._input_blocked
	local _window_focused = self._window_focused

	if not _input_blocked then
		return
	end

	if not self:_handle_friend_joining() then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local input_service = self.parent:input_service()
	local get = input_service:get("toggle_menu", true)
	local flag = not Managers.input:is_device_active("gamepad") and input_service:get("back_menu", true)
	local _close_on_exit = self._close_on_exit
	local exit_button = _widgets_by_name.exit_button
	local back_button = _widgets_by_name.back_button

	UIWidgetUtils.animate_default_button(exit_button, arg_49_1)
	UIWidgetUtils.animate_default_button(back_button, arg_49_1)

	if self:_is_button_hover_enter(back_button) or not self:_is_button_hover_enter(exit_button) then
		self:play_sound("play_gui_equipment_button_hover")
	end

	if not _close_on_exit and flag and get and not self:_is_button_pressed(exit_button) then
		self:play_sound("Play_hud_hover")
		self:close_menu()

		return
	elseif get or flag or not self:_is_button_pressed(back_button) then
		self:play_sound("Play_hud_hover")

		local get_previous_selected_layout_index = self:get_previous_selected_layout_index()
		local _layouts_index_history = self._layouts_index_history

		if not (not _layouts_index_history and not (#_layouts_index_history >= 1)) then
			local var_49_11 = _layouts_index_history[#_layouts_index_history]

			_layouts_index_history[#_layouts_index_history] = nil

			self:set_layout(var_49_11, true)
		end
	end
end

HeroViewStateWeaveForge.close_menu = function (self, arg_50_1)
	-- function 50
	if not self._on_close_next_state then
		self.parent:requested_screen_change_by_name(self._on_close_next_state)
	else
		self.parent:close_menu(nil, arg_50_1)
	end
end

HeroViewStateWeaveForge.draw_gamepad_cursor = function (self, arg_51_1, arg_51_2)
	-- function 51
	local get_ui_renderer = self:get_ui_renderer()
	local get_ui_top_renderer = self:get_ui_top_renderer()
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self.render_settings

	if not input_manager:is_device_active("gamepad") then
		UIRenderer.begin_pass(get_ui_top_renderer, ui_scenegraph, arg_51_1, arg_51_2)
		UIRenderer.draw_widget(get_ui_top_renderer, self._console_cursor_widget)
		UIRenderer.end_pass(get_ui_top_renderer)

		if not self._menu_input_description then
			self._menu_input_description:draw(get_ui_top_renderer, arg_51_2)
		end
	end
end

HeroViewStateWeaveForge.draw = function (self, arg_52_1, arg_52_2)
	-- function 52
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self.render_settings
	local is_device_active = input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_52_1, arg_52_2, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions

	for i, v in ipairs(self._widgets) do
		if v.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		UIRenderer.draw_widget(ui_top_renderer, v)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active then
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_52_1, arg_52_2)
		UIRenderer.draw_widget(ui_top_renderer, self._console_cursor_widget)
		UIRenderer.end_pass(ui_top_renderer)

		if not self._menu_input_description then
			self._menu_input_description:draw(ui_top_renderer, arg_52_2)
		end
	end
end

HeroViewStateWeaveForge._is_button_pressed = function (arg_53_0, arg_53_1)
	-- function 53
	local content = arg_53_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroViewStateWeaveForge.play_sound = function (self, arg_54_1)
	-- function 54
	self.parent:play_sound(arg_54_1)
end

HeroViewStateWeaveForge._start_transition_animation = function (self, arg_55_1, arg_55_2)
	-- function 55
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_55_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_55_1] = start_animation
end

HeroViewStateWeaveForge.set_fullscreen_effect_enable_state = function (self, arg_56_1)
	-- function 56
	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_56_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_56_1 and 1 and 0

		set_scalar(var_56_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_56_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_56_1 and 0.75 and 0

		set_scalar_2(var_56_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_56_1
end

HeroViewStateWeaveForge.block_input = function (self, arg_57_1)
	-- function 57
	self._input_blocked = true

	local _widgets_by_name = self._widgets_by_name

	if not arg_57_1 then
		_widgets_by_name.loading_icon.content.visible = true
	end

	_widgets_by_name.exit_button.content.button_hotspot.disable_button = true
	_widgets_by_name.back_button.content.button_hotspot.disable_button = true

	self.parent:set_input_blocked(true)
end

HeroViewStateWeaveForge.unblock_input = function (self)
	-- function 58
	self._input_blocked = false

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.loading_icon.content.visible = false
	_widgets_by_name.exit_button.content.button_hotspot.disable_button = false
	_widgets_by_name.back_button.content.button_hotspot.disable_button = false

	self.parent:set_input_blocked(false)
end

HeroViewStateWeaveForge.input_blocked = function (self)
	-- function 59
	return self._input_blocked
end
