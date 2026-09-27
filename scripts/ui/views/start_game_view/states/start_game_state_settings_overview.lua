-- chunkname: @scripts/ui/views/start_game_view/states/start_game_state_settings_overview.lua

require("scripts/ui/views/start_game_view/windows/start_game_window_adventure")
require("scripts/ui/views/start_game_view/windows/start_game_window_adventure_settings")
require("scripts/ui/views/start_game_view/windows/start_game_window_adventure_mode")
require("scripts/ui/views/start_game_view/windows/start_game_window_adventure_mode_settings")
require("scripts/ui/views/start_game_view/windows/start_game_window_game_mode")
require("scripts/ui/views/start_game_view/windows/start_game_window_settings")
require("scripts/ui/views/start_game_view/windows/start_game_window_mission")
require("scripts/ui/views/start_game_view/windows/start_game_window_area_selection")
require("scripts/ui/views/start_game_view/windows/start_game_window_mission_selection")
require("scripts/ui/views/start_game_view/windows/start_game_window_difficulty")
require("scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser")
require("scripts/ui/views/start_game_view/windows/start_game_window_mutator")
require("scripts/ui/views/start_game_view/windows/start_game_window_mutator_list")
require("scripts/ui/views/start_game_view/windows/start_game_window_mutator_summary")
require("scripts/ui/views/start_game_view/windows/start_game_window_mutator_grid")
require("scripts/ui/views/start_game_view/windows/start_game_window_twitch_login")
require("scripts/ui/views/start_game_view/windows/start_game_window_twitch_game_settings")
require("scripts/ui/views/start_game_view/windows/start_game_window_panel_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_background_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_adventure_overview_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_custom_game_overview_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_heroic_deed_overview_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_twitch_overview_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_mission_selection_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_area_selection_console_v2")
require("scripts/ui/views/start_game_view/windows/start_game_window_difficulty_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_mutator_grid_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_mutator_summary_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_additional_settings_console")
require("scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser_console")
DLCUtils.require_list("start_game_windows")

local var_0_0 = local_require("scripts/ui/views/start_game_view/states/definitions/start_game_state_settings_overview_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

StartGameStateSettingsOverview = class(StartGameStateSettingsOverview)
StartGameStateSettingsOverview.NAME = "StartGameStateSettingsOverview"

StartGameStateSettingsOverview.on_enter = function (self, arg_1_1)
	-- function 1
	print("[StartGameState] Enter Substate StartGameStateSettingsOverview")

	self.parent = arg_1_1.parent
	self._mechanism_name = Managers.mechanism:current_mechanism_name()

	self:_setup_menu_layout(self._mechanism_name)

	self._wwise_world = arg_1_1.wwise_world
	self._hero_name = arg_1_1.hero_name

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._ingame_ui = ingame_ui_context.ingame_ui
	self._stats_id = Managers.player:local_player():stats_id()
	self._animations = {}
	self._ui_animations = {}
	self._cloned_materials_by_reference = {}
	self._gui_by_cloned_material_reference = {}
	self._material_references_to_unload = {}
	self._is_game_private = false
	self._always_host = false
	self._use_strict_matchmaking = true
	self._is_open = true
	self._selected_weave_objective_index = 1

	self:_create_ui_elements(arg_1_1)
	self:_create_hdr_gui()

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	local tbl = {
		wwise_world = self._wwise_world,
		ingame_ui_context = ingame_ui_context,
		parent = self,
		windows_settings = self._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		layout_settings = self._layout_settings,
		start_state = arg_1_1.start_state,
		use_gamepad_layout = self._gamepad_style_active,
		mechanism_name = self._mechanism_name
	}

	self:set_confirm_button_visibility(false)

	if not self._gamepad_style_active then
		self:_setup_gamepad_gui()
		self:disable_player_world()
	end

	self:_initial_windows_setups(tbl)
	self:_calculate_current_weave()

	self._input_paused = false

	Managers.state.event:trigger("tutorial_trigger", "start_game_menu_opened")
end

StartGameStateSettingsOverview._calculate_current_weave = function (self)
	-- function 2
	local flag = false
	local templates_ordered = WeaveSettings.templates_ordered
	local count = #templates_ordered
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()
	local num = 1
	local flag_2 = false

	for i = 1, count do
		local var_2_7 = templates_ordered[i]
		local weave_unlocked = LevelUnlockUtils.weave_unlocked(statistics_db, stats_id, var_2_7.name, flag)

		if not ((weave_unlocked or num == i) and LevelUnlockUtils.weave_disabled(var_2_7.name)) then
			if not (not weave_unlocked and flag_2) then
				if not templates_ordered[i + 1] then
					num = i + 1
				end
			else
				flag_2 = true
			end
		end
	end

	local var_2_9

	if not num then
		var_2_9 = templates_ordered[num]

		if not var_2_9 then
			-- Nothing
		end
	end

	var_2_9 = templates_ordered[1]

	::label_2_0::

	self._next_weave = var_2_9.name

	if not self._selected_weave_id then
		self:set_selected_weave_id(self._next_weave)
		self:set_selected_weave_objective_index(1)
	end
end

StartGameStateSettingsOverview._setup_menu_layout = function (self, arg_3_1)
	-- function 3
	local var_3_0
	local IS_CONSOLE = IS_CONSOLE

	if not IS_CONSOLE then
		IS_CONSOLE = Managers.input:is_device_active("gamepad")
		IS_CONSOLE = (IS_CONSOLE or not UISettings.use_pc_menu_layout) and MechanismSettings[arg_3_1].use_gamepad_layout
	end

	if not IS_CONSOLE then
		var_3_0 = local_require("scripts/ui/views/start_game_view/states/start_game_window_layout_console")
	else
		var_3_0 = local_require("scripts/ui/views/start_game_view/states/start_game_window_layout")
	end

	self._generic_input_actions = var_3_0.generic_input_actions
	self._video_resources = var_3_0.video_resources
	self._windows_settings = var_3_0.windows
	self._max_active_windows = var_3_0.max_active_windows
	self._max_alignment_windows = var_3_0.max_alignment_windows
	self._gamepad_style_active = IS_CONSOLE
	self._layout_settings = var_3_0
	self._window_layouts = var_3_0.window_layouts
	self._mechanism_quickplay_settings = var_3_0.mechanism_quickplay_settings
	self._mechanism_custom_game_settings = var_3_0.mechanism_custom_game_settings
	self._mechanism_twitch_settings = var_3_0.mechanism_twitch_settings
	self._save_data_table_maps = var_3_0.save_data_table_maps
end

StartGameStateSettingsOverview._create_ui_elements = function (self, arg_4_1)
	-- function 4
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		if not v then
			local var_4_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_4_2
			tbl_2[k] = var_4_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local num = UILayer.default + 30
	local input_service = self:input_service()
	local _gamepad_style_active = self._gamepad_style_active

	if not self._generic_input_actions then
		self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, input_service, 8, num, self._generic_input_actions.default, _gamepad_style_active)

		self._menu_input_description:set_input_description(nil)
	end

	self:_create_video_players()
end

StartGameStateSettingsOverview._create_hdr_gui = function (self)
	-- function 5
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local num = 800
	local str = "start_game_menu_hdr_view"
	local str_2 = "start_game_menu_hdr_view"
	local str_3 = "environment/ui_hdr"
	local create_world = Managers.world:create_world(str, str_3, nil, num, unpack(tbl))
	local str_4 = "overlay"
	local create_viewport = ScriptWorld.create_viewport(create_world, str_2, str_4, num)

	self._ui_hdr_viewport_name = str_2
	self._ui_hdr_world_name = str
	self._ui_hdr_world = create_world
	self._ui_hdr_renderer = self._ingame_ui:create_ui_renderer(create_world, false, self._is_in_inn)
end

StartGameStateSettingsOverview.hdr_renderer = function (self)
	-- function 6
	return self._ui_hdr_renderer
end

StartGameStateSettingsOverview.ui_renderer = function (self)
	-- function 7
	if not self._gamepad_style_active then
		return self._gui_data.bottom.renderer
	else
		return self.ui_renderer
	end
end

StartGameStateSettingsOverview._create_video_players = function (self)
	-- function 8
	self:_destroy_video_players()

	local tbl = {}

	if not self._video_resources then
		local world = self._ui_top_renderer.world

		for k, v in pairs(self._video_resources) do
			local resource = v.resource

			tbl[k] = World.create_video_player(world, resource, true, false)
		end
	end

	self._video_players = tbl
end

StartGameStateSettingsOverview._destroy_video_players = function (self)
	-- function 9
	local _video_players = self._video_players

	if not _video_players then
		local world = self._ui_top_renderer.world

		for k, v in pairs(_video_players) do
			World.destroy_video_player(world, v)
		end
	end

	self._video_players = nil
end

StartGameStateSettingsOverview.get_video_player_by_name = function (self, arg_10_1)
	-- function 10
	return self._video_players[arg_10_1]
end

StartGameStateSettingsOverview._setup_gamepad_gui = function (self)
	-- function 11
	if not self._is_in_inn then
		local tbl = {}
		local str = "start_weave_gamepad"
		local _setup_gamepad_renderer, var_11_3, var_11_4 = self:_setup_gamepad_renderer(str, 1, GameSettingsDevelopment.default_environment)

		tbl.bottom = {
			renderer = _setup_gamepad_renderer,
			world = var_11_3,
			viewport_name = var_11_4
		}
		self._gui_data = tbl
	end
end

StartGameStateSettingsOverview._setup_gamepad_renderer = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_12_1 = arg_12_1
	local var_12_2 = arg_12_1
	local create_world = Managers.world:create_world(var_12_1, arg_12_3, nil, arg_12_2, unpack(tbl))
	local str = "overlay"
	local create_viewport = ScriptWorld.create_viewport(create_world, var_12_2, str, 999)

	return self._ingame_ui:create_ui_renderer(create_world, false, self._is_in_inn), create_world, var_12_2
end

StartGameStateSettingsOverview._destroy_gamepad_gui = function (self)
	-- function 13
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

StartGameStateSettingsOverview.disable_player_world = function (self)
	-- function 14
	if not self._player_world_disabled then
		self._player_world_disabled = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

StartGameStateSettingsOverview.enable_player_world = function (self)
	-- function 15
	if not self._player_world_disabled then
		self._player_world_disabled = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

StartGameStateSettingsOverview._start_layout_name = function (self)
	-- function 16
	local start_layout = PlayerData.mission_selection.start_layout
	local get_layout_setting_by_name = self:get_layout_setting_by_name(start_layout)

	if not get_layout_setting_by_name and not self:can_add_layout(get_layout_setting_by_name) then
		return start_layout
	else
		return self:_get_first_game_mode_option_layout()
	end
end

StartGameStateSettingsOverview.can_add_layout = function (arg_17_0, arg_17_1)
	-- function 17
	local can_add_function = arg_17_1.can_add_function
	local name = arg_17_1.name

	if not Managers.ui:is_ui_layout_hidden(name) then
		return false
	end

	return not can_add_function and can_add_function(arg_17_0)
end

StartGameStateSettingsOverview._initial_windows_setups = function (self, arg_18_1)
	-- function 18
	self._active_windows = {}
	self._window_params = arg_18_1

	local var_18_0
	local flag

	flag = not Managers.twitch and (Managers.twitch:is_connecting() or not Managers.twitch:is_connected() or Managers.mechanism:current_mechanism_name() ~= "deus") and not "deus_twitch" and "twitch" and arg_18_1.start_state and self:_start_layout_name()

	self:set_layout_by_name(flag)
	self:set_top_level_layout_name(flag)
end

StartGameStateSettingsOverview.window_input_service = function (self)
	-- function 19
	local FAKE_INPUT_SERVICE

	if not self._show_difficulty_option then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_19_0::

	return FAKE_INPUT_SERVICE
end

StartGameStateSettingsOverview._close_window_at_index = function (self, arg_20_1)
	-- function 20
	local _active_windows = self._active_windows
	local _window_params = self._window_params
	local var_20_2 = _active_windows[arg_20_1]

	if not var_20_2 and not var_20_2.on_exit then
		var_20_2:on_exit(_window_params)
	end

	_active_windows[arg_20_1] = nil
end

StartGameStateSettingsOverview._change_window = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _active_windows = self._active_windows
	local var_21_1 = self._windows_settings[arg_21_2]
	local class_name = var_21_1.class_name
	local var_21_3 = _active_windows[arg_21_1]

	if not var_21_3 then
		if var_21_3.NAME == class_name then
			return
		end

		self:_close_window_at_index(arg_21_1)
	end

	local var_21_4 = rawget(_G, class_name):new()
	local ignore_alignment = var_21_1.ignore_alignment
	local parent_window_name = var_21_1.parent_window_name
	local var_21_7

	if not ignore_alignment then
		local game_start_windows = UISettings.game_start_windows
		local size = game_start_windows.size
		local spacing = game_start_windows.spacing

		spacing = spacing or 10

		local var_21_11 = size[1]
		local _max_alignment_windows = self._max_alignment_windows

		_max_alignment_windows = _max_alignment_windows or self._max_active_windows

		local num = spacing * (_max_alignment_windows - 1)
		local num_2 = -(_max_alignment_windows * var_21_11 / 2 + var_21_11 / 2) - (num / 2 + spacing) + arg_21_1 * var_21_11 + arg_21_1 * spacing

		var_21_7 = {
			num_2,
			0,
			3
		}
	end

	if not var_21_4.on_enter then
		local _window_params = self._window_params

		var_21_4:on_enter(_window_params, var_21_7, parent_window_name)
	end

	_active_windows[arg_21_1] = var_21_4
end

StartGameStateSettingsOverview._set_new_save_data_table = function (self, arg_22_1)
	-- function 22
	if not arg_22_1 then
		local mission_selection = PlayerData.mission_selection
		local var_22_1 = mission_selection[arg_22_1]

		if not (not var_22_1 and self:_validate_mission_save_data(var_22_1)) then
			mission_selection[arg_22_1] = {}
		end

		local var_22_2 = mission_selection[arg_22_1]

		self._layout_save_settings = var_22_2

		self:set_private_option_enabled(var_22_2.is_private)
		self:set_always_host_option_enabled(var_22_2.always_host)
		self:set_strict_matchmaking_option_enabled(var_22_2.use_strict_matchmaking)
		self:set_selected_level_id(var_22_2.level_id)
		self:set_difficulty_option(var_22_2.difficulty_key)
		self:set_selected_weave_id(var_22_2.weave_id)
		self:set_dedicated_or_player_hosted_search(var_22_2.use_dedicated_win_servers, var_22_2.use_dedicated_aws_servers, var_22_2.use_player_hosted)
	else
		self._layout_save_settings = nil
	end
end

StartGameStateSettingsOverview._validate_mission_save_data = function (self, arg_23_1)
	-- function 23
	local flag = not arg_23_1 and arg_23_1.level_id

	if not flag then
		return true
	elseif not rawget(LevelSettings, flag) then
		return false
	end

	local _stats_id = self._stats_id
	local _statistics_db = self._statistics_db

	return LevelUnlockUtils.level_unlocked(_statistics_db, _stats_id, flag)
end

StartGameStateSettingsOverview.close_on_exit = function (self)
	-- function 24
	return self._close_on_exit
end

StartGameStateSettingsOverview.set_hide_panel_title_butttons = function (self, arg_25_1)
	-- function 25
	self._panel_title_buttons_hidden = arg_25_1
end

StartGameStateSettingsOverview.panel_title_buttons_hidden = function (self)
	-- function 26
	return self._panel_title_buttons_hidden
end

StartGameStateSettingsOverview.get_current_window_layout_settings = function (self)
	-- function 27
	for i, v in ipairs(self._window_layouts) do
		if v.name == self._selected_layout_name then
			return v
		end
	end
end

StartGameStateSettingsOverview.set_layout_by_name = function (self, arg_28_1)
	-- function 28
	printf("[StartGameStateSettingsOverview]:set_layout_by_name() - %s", arg_28_1)

	local find_by_key = table.find_by_key(self._window_layouts, "name", arg_28_1)

	if not find_by_key then
		ferror("[StartGameStateSettingsOverview]:set_layout_by_name() - Could not find a layout with name %s. Layouts: (%s)", arg_28_1, table.concat(table.select_array(self._window_layouts, function (arg_29_0, arg_29_1)
			-- function 29
			return arg_29_1.name
		end), ", "))
	end

	self:set_layout(find_by_key)
end

StartGameStateSettingsOverview.get_mechanism_name = function (self)
	-- function 30
	return self._mechanism_name
end

StartGameStateSettingsOverview.is_in_mechanism = function (self, arg_31_1)
	-- function 31
	local flag = self.parent:on_enter_sub_state() == "weave_quickplay"

	if arg_31_1 == "weave" then
		return self._mechanism_name ~= "adventure" or flag
	else
		return self._mechanism_name ~= arg_31_1 or not flag
	end
end

StartGameStateSettingsOverview.is_weekly_event_active = function (arg_32_0)
	-- function 32
	return Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data() ~= nil
end

StartGameStateSettingsOverview.get_quickplay_settings = function (self, arg_33_1)
	-- function 33
	return self._mechanism_quickplay_settings[arg_33_1 or self._mechanism_name]
end

StartGameStateSettingsOverview.get_custom_game_settings = function (self, arg_34_1)
	-- function 34
	return self._mechanism_custom_game_settings[arg_34_1 or self._mechanism_name]
end

StartGameStateSettingsOverview.get_twitch_settings = function (self, arg_35_1)
	-- function 35
	return self._mechanism_twitch_settings[arg_35_1 or self._mechanism_name]
end

StartGameStateSettingsOverview.get_save_data_table_map = function (self, arg_36_1)
	-- function 36
	return self._save_data_table_maps[arg_36_1 or self._mechanism_name]
end

StartGameStateSettingsOverview.set_layout = function (self, arg_37_1)
	-- function 37
	local get_layout_setting = self:get_layout_setting(arg_37_1)
	local sound_event_enter = get_layout_setting.sound_event_enter

	if not sound_event_enter then
		self:play_sound(sound_event_enter)
	end

	local save_data_table = get_layout_setting.save_data_table
	local get_save_data_table_map = self:get_save_data_table_map(self._mechanism_name)

	get_save_data_table_map = get_save_data_table_map or self:get_quickplay_settings("adventure")
	save_data_table = not get_save_data_table_map and get_save_data_table_map[save_data_table] and save_data_table

	self:_set_new_save_data_table(save_data_table)

	local close_on_exit = get_layout_setting.close_on_exit
	local reset_on_exit = get_layout_setting.reset_on_exit
	local content = self._widgets_by_name.exit_button.content

	if not reset_on_exit then
		-- Nothing
	end

	content.visible = close_on_exit
	self._widgets_by_name.back_button.content.visible = reset_on_exit or not close_on_exit
	self._close_on_exit = close_on_exit
	self._reset_on_exit = reset_on_exit

	local windows = get_layout_setting.windows
	local _max_active_windows = self._max_active_windows

	for i = 1, _max_active_windows do
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

	local name = get_layout_setting.name

	if not get_layout_setting.game_mode_option then
		if not self._selected_game_mode_layout_name then
			self._previous_selected_game_mode_layout_name = self._selected_game_mode_layout_name
		end

		self._selected_game_mode_layout_name = name
	end

	if not self._selected_layout_name then
		self._previous_selected_layout_name = self._selected_layout_name
	end

	self._selected_layout_name = name

	local input_focus_window = get_layout_setting.input_focus_window

	self:set_window_input_focus(input_focus_window)
end

StartGameStateSettingsOverview.set_window_input_focus = function (self, arg_38_1)
	-- function 38
	local var_38_0 = self._windows_settings[arg_38_1]
	local flag = not var_38_0 and var_38_0.class_name
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

	if not (not arg_38_1 and flag_2) then
		ferror("[StartGameStateSettingsOverview] - (set_window_input_focus) Could not find a window by name: %s", arg_38_1)
	end

	self._window_focused = arg_38_1
end

StartGameStateSettingsOverview.set_top_level_layout_name = function (self, arg_39_1)
	-- function 39
	self._top_level_layout_name = arg_39_1
end

StartGameStateSettingsOverview.get_top_level_layout_name = function (self)
	-- function 40
	return self._top_level_layout_name
end

StartGameStateSettingsOverview.get_selected_game_mode_layout_name = function (self)
	-- function 41
	return self._selected_game_mode_layout_name
end

StartGameStateSettingsOverview.get_previous_selected_game_mode_layout_name = function (self)
	-- function 42
	return self._previous_selected_game_mode_layout_name
end

StartGameStateSettingsOverview.get_selected_layout_name = function (self)
	-- function 43
	return self._selected_layout_name
end

StartGameStateSettingsOverview.get_previous_selected_layout_name = function (self)
	-- function 44
	return self._previous_selected_layout_name
end

StartGameStateSettingsOverview.get_layout_setting = function (self, arg_45_1)
	-- function 45
	return self._window_layouts[arg_45_1]
end

StartGameStateSettingsOverview.get_layout_setting_by_name = function (self, arg_46_1)
	-- function 46
	local find_by_key, var_46_1 = table.find_by_key(self._window_layouts, "name", arg_46_1)

	return var_46_1
end

StartGameStateSettingsOverview._get_first_game_mode_option_layout = function (self)
	-- function 47
	local _window_layouts = self._window_layouts

	for i = 1, #_window_layouts do
		local var_47_1 = _window_layouts[i]
		local name = var_47_1.name
		local can_add_layout = self:can_add_layout(var_47_1)

		can_add_layout = not can_add_layout and not Managers.ui:is_ui_layout_disabled(name)

		if not can_add_layout then
			return name, var_47_1
		end
	end
end

StartGameStateSettingsOverview._windows_update = function (self, arg_48_1, arg_48_2)
	-- function 48
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		v:update(arg_48_1, arg_48_2)
	end
end

StartGameStateSettingsOverview._windows_post_update = function (self, arg_49_1, arg_49_2)
	-- function 49
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		v:post_update(arg_49_1, arg_49_2)
	end
end

StartGameStateSettingsOverview.enable_widget = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local var_50_0 = self._active_windows[arg_50_1]._widgets_by_name[arg_50_2]

	if not var_50_0 then
		local button_hotspot = var_50_0.content.button_hotspot

		if not button_hotspot then
			button_hotspot.disable_button = not arg_50_3
		end
	end
end

StartGameStateSettingsOverview.disable_input = function (self, arg_51_1)
	-- function 51
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		if not v.disable_input and not v:disable_input(arg_51_1) then
			return true
		end
	end
end

StartGameStateSettingsOverview.transitioning = function (self)
	-- function 52
	if not self.exiting then
		return true
	else
		return false
	end
end

StartGameStateSettingsOverview._wanted_state = function (self)
	-- function 53
	return (self.parent:wanted_state())
end

StartGameStateSettingsOverview.wanted_menu_state = function (self)
	-- function 54
	return self._wanted_menu_state
end

StartGameStateSettingsOverview.clear_wanted_menu_state = function (self)
	-- function 55
	self._wanted_menu_state = nil
end

StartGameStateSettingsOverview.on_exit = function (self, arg_56_1)
	-- function 56
	print("[StartGameState] Exit Substate StartGameStateSettingsOverview")

	self.ui_animator = nil
	self._is_open = false

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	Managers.save:auto_save(SaveFileName, SaveData, nil)
	self:_close_active_windows()
	self:_destroy_video_players()

	if not self._gamepad_style_active then
		self:_destroy_gamepad_gui()
		self:enable_player_world()
	end

	self:_reset_cloned_materials()

	if not self._ui_hdr_renderer then
		UIRenderer.destroy(self._ui_hdr_renderer, self._ui_hdr_world)

		self._ui_hdr_renderer = nil
	end

	if not self._ui_hdr_world then
		ScriptWorld.destroy_viewport(self._ui_hdr_world, self._ui_hdr_viewport_name)
		Managers.world:destroy_world(self._ui_hdr_world)

		self._ui_hdr_viewport_name = nil
		self._ui_hdr_world_name = nil
		self._ui_hdr_world = nil
	end
end

StartGameStateSettingsOverview._close_active_windows = function (self)
	-- function 57
	local _active_windows = self._active_windows
	local _window_params = self._window_params

	for k, v in pairs(_active_windows) do
		if not v.on_exit then
			v:on_exit(_window_params)
		end
	end

	table.clear(_active_windows)
end

StartGameStateSettingsOverview._update_transition_timer = function (self, arg_58_1)
	-- function 58
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_58_1, 0)
	end
end

StartGameStateSettingsOverview.input_service = function (self)
	-- function 59
	return self.parent:input_service()
end

StartGameStateSettingsOverview.update = function (self, arg_60_1, arg_60_2)
	-- function 60
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	if not (not Managers.matchmaking:is_in_versus_custom_game_lobby() and Managers.mechanism:network_handler():get_match_handler():query_peer_data(Network.peer_id(), "is_match_owner")) then
		local _selected_layout_name = self._selected_layout_name
		local str = "versus_player_hosted_lobby"

		if _selected_layout_name ~= str then
			self:set_layout_by_name(str)
		end
	end

	local _input_manager = self._input_manager
	local input_service = self.parent:input_service()

	self:draw(input_service, arg_60_1)
	self:_update_transition_timer(arg_60_1)

	if not self._show_difficulty_option then
		self:_windows_update(arg_60_1, arg_60_2)
	end

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		self.parent:clear_wanted_state()

		return _wanted_state or self._new_state
	end
end

StartGameStateSettingsOverview.post_update = function (self, arg_61_1, arg_61_2)
	-- function 61
	self.ui_animator:update(arg_61_1)
	self:_update_animations(arg_61_1)

	if not (self.parent:transitioning() or self._transition_timer or self:input_paused()) then
		self:_handle_input(arg_61_1, arg_61_2)
	end

	self:_windows_post_update(arg_61_1, arg_61_2)
end

StartGameStateSettingsOverview._update_animations = function (self, arg_62_1)
	-- function 62
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_62_1)

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

StartGameStateSettingsOverview._is_button_hover_enter = function (arg_63_0, arg_63_1)
	-- function 63
	return arg_63_1.content.button_hotspot.on_hover_enter
end

StartGameStateSettingsOverview._handle_input = function (self, arg_64_1, arg_64_2)
	-- function 64
	local _widgets_by_name = self._widgets_by_name
	local input_service = self.parent:input_service()
	local get = input_service:get("toggle_menu", true)
	local flag = not Managers.input:is_device_active("gamepad") and input_service:get("back_menu", true)
	local _close_on_exit = self._close_on_exit
	local _reset_on_exit = self._reset_on_exit
	local back_button = _widgets_by_name.back_button
	local exit_button = _widgets_by_name.exit_button

	UIWidgetUtils.animate_default_button(back_button, arg_64_1)
	UIWidgetUtils.animate_default_button(exit_button, arg_64_1)

	if self:_is_button_hover_enter(back_button) or not self:_is_button_hover_enter(exit_button) then
		self:play_sound("play_gui_equipment_button_hover")
	end

	if not _reset_on_exit and get and flag and not self:_is_button_pressed(back_button) then
		self:play_sound("play_gui_lobby_back")

		local _start_layout_name = self:_start_layout_name()

		self:set_layout_by_name(_start_layout_name)
	elseif not _close_on_exit and flag and get and not self:_is_button_pressed(exit_button) then
		self:close_menu()

		return
	elseif get or flag or not self:_is_button_pressed(back_button) then
		self:play_sound("Play_hud_select")

		local var_64_9
		local _window_params = self._window_params

		if not _window_params then
			var_64_9 = _window_params.return_layout_name
			_window_params.return_layout_name = nil
		end

		if not var_64_9 then
			if not self:get_layout_setting_by_name(self._selected_layout_name).return_to_top_level then
				var_64_9 = self:get_top_level_layout_name() or self:get_previous_selected_layout_name()
			else
				var_64_9 = self:get_previous_selected_layout_name()
			end
		end

		if not var_64_9 then
			self:set_layout_by_name(var_64_9)
		end
	end
end

StartGameStateSettingsOverview.pause_input = function (self, arg_65_1)
	-- function 65
	self._input_paused = arg_65_1
end

StartGameStateSettingsOverview.input_paused = function (self)
	-- function 66
	return self._input_paused
end

StartGameStateSettingsOverview.close_menu = function (self, arg_67_1)
	-- function 67
	self.parent:close_menu(nil, arg_67_1)
end

StartGameStateSettingsOverview.cancel_matchmaking = function (self)
	-- function 68
	self.parent:cancel_matchmaking()
end

local tbl = {}

StartGameStateSettingsOverview.play = function (self, arg_69_1, arg_69_2, arg_69_3)
	-- function 69
	printf("[StartGameStateSettingsOverview:play() - vote_type(%s)", arg_69_2)

	local offline_mode = Managers.account:offline_mode()

	if arg_69_2 == "adventure_mode" then
		local get_selected_level_id = self:get_selected_level_id()
		local _selected_difficulty_key = self._selected_difficulty_key
		local flag = true
		local flag_2 = false
		local flag_3 = true
		local flag_4 = false
		local var_69_7
		local var_69_8

		self.parent:start_game(get_selected_level_id, _selected_difficulty_key, flag, flag_2, flag_3, flag_4, arg_69_1, matchmaking_type, var_69_7, var_69_8)
	elseif arg_69_2 == "adventure" then
		local tbl_2 = {
			mechanism = "adventure",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = self._selected_difficulty_key,
			private_game = offline_mode,
			always_host = offline_mode,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_2)
	elseif arg_69_2 == "weave_quick_play" then
		local tbl_3 = {
			private_game = false,
			mechanism = "weave",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = self._selected_difficulty_key,
			always_host = offline_mode,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_3)
	elseif arg_69_2 == "custom" then
		local _network_lobby = self._network_lobby
		local get_member_count = _network_lobby:members():get_member_count()
		local is_private_option_enabled = self:is_private_option_enabled()

		is_private_option_enabled = not IS_CONSOLE and offline_mode and is_private_option_enabled

		local flag_5 = get_member_count == 1
		local flag_6 = is_private_option_enabled or self:is_always_host_option_enabled()
		local tbl_4 = {
			mechanism = "adventure",
			matchmaking_type = "custom",
			quick_game = false,
			network_lobby = _network_lobby,
			num_members = get_member_count,
			is_alone = flag_5,
			mission_id = self:get_selected_level_id(),
			difficulty = self._selected_difficulty_key,
			private_game = is_private_option_enabled,
			always_host = flag_6,
			strict_matchmaking = not flag_5 and not not is_private_option_enabled and not not flag_6 or self:is_strict_matchmaking_option_enabled(),
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_4)
	elseif arg_69_2 == "deed" then
		local tbl_5 = {
			is_private = true,
			mechanism = "adventure",
			quick_game = false,
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "deed",
			deed_backend_id = self:get_selected_heroic_deed_backend_id(),
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_5)
	elseif arg_69_2 == "twitch" then
		local tbl_6 = {
			private_game = true,
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "custom",
			mechanism = "adventure",
			quick_game = false,
			twitch_enabled = true,
			mission_id = self:get_selected_level_id(),
			difficulty = self._selected_difficulty_key,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_6)
	elseif arg_69_2 == "event" then
		local get_weekly_events_game_mode_data = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
		local var_69_20

		if not get_weekly_events_game_mode_data.mutators then
			var_69_20 = {
				mutators = get_weekly_events_game_mode_data.mutators
			}
		end

		local tbl_7 = {
			private_game = false,
			strict_matchmaking = false,
			always_host = false,
			matchmaking_type = "event",
			mechanism = "adventure",
			quick_game = false,
			mission_id = get_weekly_events_game_mode_data.level_key,
			difficulty = self._selected_difficulty_key,
			event_data = var_69_20,
			excluded_level_keys = get_weekly_events_game_mode_data.excluded_level_keys,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_7)
	elseif arg_69_2 == "versus_quickplay" then
		local tbl_8 = {
			private_game = false,
			dedicated_servers_aws = true,
			player_hosted = false,
			dedicated_servers_win = false,
			matchmaking_type = "standard",
			mechanism = "versus",
			quick_game = true,
			difficulty = "versus_base",
			join_method = "party",
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_8)
	elseif arg_69_2 == "versus_custom" then
		local is_private_option_enabled_2 = self:is_private_option_enabled()
		local get_selected_level_id_2 = self:get_selected_level_id()
		local tbl_9 = {
			player_hosted = true,
			dedicated_servers_win = false,
			dedicated_servers_aws = false,
			matchmaking_type = "custom",
			mechanism = "versus",
			quick_game = false,
			difficulty = "versus_base",
			join_method = "party",
			mission_id = get_selected_level_id_2,
			any_level = not get_selected_level_id_2,
			private_game = is_private_option_enabled_2,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_9)
	elseif arg_69_2 == "weave" then
		local get_selected_weave_id = self:get_selected_weave_id()
		local difficulty_key = WeaveSettings.templates[get_selected_weave_id].difficulty_key
		local get_selected_weave_objective_index = self:get_selected_weave_objective_index()
		local is_private_option_enabled_3 = self:is_private_option_enabled()
		local var_69_30 = offline_mode
		local tbl_10 = {
			matchmaking_type = "custom",
			mechanism = "weave",
			quick_game = false,
			mission_id = get_selected_weave_id,
			difficulty = difficulty_key,
			objective_index = get_selected_weave_objective_index,
			private_game = is_private_option_enabled_3,
			always_host = offline_mode,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_10)
	elseif arg_69_2 == "deus_custom" then
		local flag_7 = self._network_lobby:members():get_member_count() == 1
		local flag_8 = offline_mode or self:is_private_option_enabled()
		local flag_9 = flag_8 or self:is_always_host_option_enabled()
		local get_journey_cycle = Managers.backend:get_interface("deus"):get_journey_cycle()
		local get_selected_level_id_3 = self:get_selected_level_id()

		get_selected_level_id_3 = not DeusJourneySettings[get_selected_level_id_3] and get_selected_level_id_3 and AvailableJourneyOrder[1]

		local dominant_god = get_journey_cycle.journey_data[get_selected_level_id_3].dominant_god
		local tbl_11 = {
			matchmaking_type = "custom",
			mechanism = "deus",
			quick_game = false,
			mission_id = get_selected_level_id_3,
			difficulty = self._selected_difficulty_key,
			private_game = flag_8,
			always_host = flag_9,
			strict_matchmaking = not flag_7 and not not flag_8 and not not flag_9 or self:is_strict_matchmaking_option_enabled(),
			dominant_god = dominant_god,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_11)
	elseif arg_69_2 == "deus_twitch" then
		local get_journey_cycle_2 = Managers.backend:get_interface("deus"):get_journey_cycle()
		local get_selected_level_id_4 = self:get_selected_level_id()

		get_selected_level_id_4 = not DeusJourneySettings[get_selected_level_id_4] and get_selected_level_id_4 and AvailableJourneyOrder[1]

		local dominant_god_2 = get_journey_cycle_2.journey_data[get_selected_level_id_4].dominant_god
		local tbl_12 = {
			private_game = true,
			mechanism = "deus",
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "custom",
			quick_game = false,
			twitch_enabled = true,
			mission_id = get_selected_level_id_4,
			difficulty = self._selected_difficulty_key,
			dominant_god = dominant_god_2,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_12)
	elseif arg_69_2 == "deus_quickplay" then
		local tbl_13 = {
			mechanism = "deus",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = self._selected_difficulty_key,
			private_game = offline_mode,
			always_host = offline_mode,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_13)
	elseif arg_69_2 == "deus_weekly" then
		local get_weekly_chaos_wastes_game_mode_data = Managers.backend:get_interface("live_events"):get_weekly_chaos_wastes_game_mode_data()

		get_weekly_chaos_wastes_game_mode_data = get_weekly_chaos_wastes_game_mode_data or tbl

		local var_69_45

		if not get_weekly_chaos_wastes_game_mode_data.mutators then
			var_69_45 = var_69_45 or {}
			var_69_45.mutators = get_weekly_chaos_wastes_game_mode_data.mutators
		end

		if not get_weekly_chaos_wastes_game_mode_data.boons then
			var_69_45 = var_69_45 or {}
			var_69_45.boons = get_weekly_chaos_wastes_game_mode_data.boons
		end

		local journey_name = get_weekly_chaos_wastes_game_mode_data.journey_name
		local dominant_god_3 = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data[journey_name].dominant_god
		local tbl_14 = {
			private_game = false,
			strict_matchmaking = false,
			always_host = false,
			matchmaking_type = "event",
			mechanism = "deus",
			quick_game = false,
			mission_id = journey_name,
			difficulty = self._selected_difficulty_key,
			dominant_god = dominant_god_3,
			event_data = var_69_45,
			excluded_level_keys = get_weekly_chaos_wastes_game_mode_data.excluded_level_keys,
			request_type = arg_69_2
		}

		self.parent:start_game(tbl_14)
	else
		ferror("Unknown vote_type(%s)", arg_69_2)
	end
end

StartGameStateSettingsOverview.is_confirm_putton_pressed = function (arg_70_0)
	-- function 70
	return false
end

StartGameStateSettingsOverview.set_input_description = function (self, arg_71_1)
	-- function 71
	if not self._menu_input_description then
		return
	end

	fassert(not arg_71_1 and self._generic_input_actions[arg_71_1], "[StartGameStateSettingsOverview:set_input_description] There is no such input_description (%s)", arg_71_1)
	self._menu_input_description:set_input_description(self._generic_input_actions[arg_71_1])
end

StartGameStateSettingsOverview.change_generic_actions = function (self, arg_72_1)
	-- function 72
	if not self._menu_input_description then
		return
	end

	fassert(self._generic_input_actions[arg_72_1], "[StartGameStateSettingsOverview:set_input_description] There is no such input_description (%s)", arg_72_1)
	self._menu_input_description:change_generic_actions(self._generic_input_actions[arg_72_1])
end

StartGameStateSettingsOverview.draw = function (self, arg_73_1, arg_73_2)
	-- function 73
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_manager = self._input_manager
	local _render_settings = self._render_settings

	if not self._gamepad_style_active then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, arg_73_1, arg_73_2, nil, _render_settings)

		local snap_pixel_positions = _render_settings.snap_pixel_positions

		for i, v in ipairs(self._widgets) do
			if v.snap_pixel_positions ~= nil then
				_render_settings.snap_pixel_positions = v.snap_pixel_positions
			end

			UIRenderer.draw_widget(_ui_renderer, v)

			_render_settings.snap_pixel_positions = snap_pixel_positions
		end

		UIRenderer.end_pass(_ui_renderer)
	end

	if not (not _input_manager:is_device_active("gamepad") and not self._menu_input_description and self.parent:active_view()) then
		self._menu_input_description:draw(_ui_top_renderer, arg_73_2)
	end
end

StartGameStateSettingsOverview.draw_menu_input_description = function (self, arg_74_1, arg_74_2)
	-- function 74
	local _ui_top_renderer = self._ui_top_renderer

	self._menu_input_description:draw(_ui_top_renderer, arg_74_2)
end

StartGameStateSettingsOverview._is_button_pressed = function (arg_75_0, arg_75_1)
	-- function 75
	local content = arg_75_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameStateSettingsOverview.play_sound = function (self, arg_76_1)
	-- function 76
	self.parent:play_sound(arg_76_1)
end

StartGameStateSettingsOverview._start_transition_animation = function (self, arg_77_1, arg_77_2)
	-- function 77
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_77_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_77_1] = start_animation
end

StartGameStateSettingsOverview.get_selected_weave_id = function (self)
	-- function 78
	return self._selected_weave_id
end

StartGameStateSettingsOverview.get_selected_weave_objective_index = function (self)
	-- function 79
	return self._selected_weave_objective_index
end

StartGameStateSettingsOverview.set_next_weave = function (self)
	-- function 80
	if self._selected_weave_id ~= self._next_weave then
		self:set_selected_weave_id(self._next_weave)
		self:set_selected_weave_objective_index(1)
		self:play_sound("play_gui_lobby_button_00_quickplay")
	end
end

StartGameStateSettingsOverview.set_selected_weave_id = function (self, arg_81_1)
	-- function 81
	if not self._layout_save_settings then
		self._layout_save_settings.weave_id = arg_81_1
	end

	if not arg_81_1 then
		self._selected_weave_id = arg_81_1
	end
end

StartGameStateSettingsOverview.set_selected_weave_objective_index = function (self, arg_82_1)
	-- function 82
	self._selected_weave_objective_index = arg_82_1
end

StartGameStateSettingsOverview.get_selected_heroic_deed_backend_id = function (self)
	-- function 83
	return self._selected_heroic_deed_backend_id
end

StartGameStateSettingsOverview.set_selected_heroic_deed_backend_id = function (self, arg_84_1)
	-- function 84
	self._selected_heroic_deed_backend_id = arg_84_1
end

StartGameStateSettingsOverview.get_selected_level_id = function (self)
	-- function 85
	local flag = true
	local flag_2 = true
	local _specific_level_id = self._specific_level_id

	_specific_level_id = not _specific_level_id and LevelSettings[self._specific_level_id]

	if not _specific_level_id and not _specific_level_id.dlc_name then
		flag = Managers.unlock:is_dlc_unlocked(_specific_level_id.dlc_name)
	end

	local get_selected_area_name = self:get_selected_area_name()

	if not get_selected_area_name then
		local var_85_4 = AreaSettings[get_selected_area_name]

		if not var_85_4 and not var_85_4.unlock_requirement_function then
			flag_2 = var_85_4.unlock_requirement_function(self._statistics_db, self._stats_id)
		end
	end

	local _specific_level_id_2

	if not flag and not flag_2 then
		_specific_level_id_2 = self._specific_level_id

		if not _specific_level_id_2 then
			-- Nothing
		end
	end

	_specific_level_id_2 = nil

	::label_85_0::

	return _specific_level_id_2
end

StartGameStateSettingsOverview.set_selected_level_id = function (self, arg_86_1)
	-- function 86
	if not self._layout_save_settings then
		self._layout_save_settings.level_id = arg_86_1
	end

	self._specific_level_id = arg_86_1
end

StartGameStateSettingsOverview.get_selected_area_name = function (self)
	-- function 87
	if not self._specific_area_name then
		local _specific_area_name = self._specific_area_name

		if not AreaSettings[_specific_area_name] then
			return self._specific_area_name
		end
	end

	if not self._layout_save_settings then
		local area_name = self._layout_save_settings.area_name

		if not area_name and not AreaSettings[area_name] then
			return area_name
		end
	end

	return "helmgart"
end

StartGameStateSettingsOverview.set_selected_area_name = function (self, arg_88_1)
	-- function 88
	if not self._layout_save_settings then
		self._layout_save_settings.area_name = arg_88_1
	end

	self._specific_area_name = arg_88_1
end

StartGameStateSettingsOverview.show_difficulty_option = function (self)
	-- function 89
	self._show_difficulty_option = true
end

StartGameStateSettingsOverview.hide_difficulty_option = function (self)
	-- function 90
	self._show_difficulty_option = false
end

StartGameStateSettingsOverview.set_private_option_enabled = function (self, arg_91_1)
	-- function 91
	if arg_91_1 == nil then
		arg_91_1 = false
	end

	if not self._layout_save_settings then
		self._layout_save_settings.is_private = arg_91_1
	end

	self._is_game_private = arg_91_1
end

StartGameStateSettingsOverview.is_private_option_enabled = function (self)
	-- function 92
	return self._is_game_private
end

StartGameStateSettingsOverview.set_always_host_option_enabled = function (self, arg_93_1)
	-- function 93
	if arg_93_1 == nil then
		arg_93_1 = false
	end

	if not self._layout_save_settings then
		self._layout_save_settings.always_host = arg_93_1
	end

	self._always_host = arg_93_1
end

StartGameStateSettingsOverview.is_always_host_option_enabled = function (self)
	-- function 94
	return self._always_host
end

StartGameStateSettingsOverview.set_strict_matchmaking_option_enabled = function (self, arg_95_1)
	-- function 95
	if arg_95_1 == nil then
		arg_95_1 = true
	end

	if not self._layout_save_settings then
		self._layout_save_settings.use_strict_matchmaking = arg_95_1
	end

	self._use_strict_matchmaking = arg_95_1
end

StartGameStateSettingsOverview.is_strict_matchmaking_option_enabled = function (self)
	-- function 96
	return self._use_strict_matchmaking
end

local tbl_2 = {}

StartGameStateSettingsOverview.is_difficulty_approved = function (self, arg_97_1)
	-- function 97
	if not Development.parameter("unlock_all_difficulties") then
		return true
	end

	if not script_data.disable_hero_power_requirement then
		return true
	end

	if not arg_97_1 then
		return false
	end

	local flag = true
	local var_97_1
	local var_97_2
	local var_97_3
	local human_players = Managers.player:human_players()

	if not (self:is_private_option_enabled() or not (#DifficultyManager.players_below_required_power_level(arg_97_1, human_players) > 0)) then
		flag = false
		var_97_3 = true
	end

	local var_97_5 = DifficultySettings[arg_97_1]

	if not var_97_5.extra_requirement_name then
		local var_97_6 = human_players

		if not Managers.state.network.is_server then
			tbl_2[1] = Managers.player:local_player()
			var_97_6 = tbl_2
		end

		if #DifficultyManager.players_locked_difficulty_rank(arg_97_1, var_97_6) > 0 then
			local extra_requirement_name = var_97_5.extra_requirement_name

			var_97_1 = ExtraDifficultyRequirements[extra_requirement_name].description_text
			flag = false
		end
	end

	if not var_97_5.dlc_requirement then
		local network_handler = Managers.mechanism:network_handler()

		if not network_handler then
			local flag_2 = false
			local get_peers = network_handler:get_peers()

			for i = 1, #get_peers do
				local var_97_11 = get_peers[i]

				if not network_handler:is_network_state_fully_synced_for_peer(var_97_11) and not network_handler:has_unlocked_dlc(var_97_11, var_97_5.dlc_requirement) then
					flag_2 = true
				end
			end

			if not flag_2 then
				flag = false
				var_97_2 = var_97_5.dlc_requirement
			end
		end
	end

	return flag, var_97_1, var_97_2, var_97_3
end

StartGameStateSettingsOverview.set_difficulty_option = function (self, arg_98_1)
	-- function 98
	if not self._layout_save_settings then
		self._layout_save_settings.difficulty_key = arg_98_1
	end

	self._selected_difficulty_key = arg_98_1
end

StartGameStateSettingsOverview.get_difficulty_option = function (self, arg_99_1)
	-- function 99
	local mechanism_setting = Managers.mechanism:mechanism_setting("default_difficulty")
	local _selected_difficulty_key = self._selected_difficulty_key
	local find = table.find(Difficulties, _selected_difficulty_key)

	find = find or table.index_of(Difficulties, mechanism_setting)

	for i = find, 1, -1 do
		_selected_difficulty_key = Difficulties[i]

		if not self:is_difficulty_approved(_selected_difficulty_key) then
			break
		end
	end

	self:set_difficulty_option(_selected_difficulty_key)

	return _selected_difficulty_key
end

StartGameStateSettingsOverview.set_dedicated_or_player_hosted_search = function (self, arg_100_1, arg_100_2, arg_100_3)
	-- function 100
	local flag

	flag = arg_100_1 ~= nil or not true or arg_100_1
	self._use_dedicated_win_servers = flag

	local flag_2

	flag_2 = arg_100_2 ~= nil or not true or arg_100_2
	self._use_dedicated_aws_servers = flag_2

	local flag_3

	flag_3 = arg_100_3 ~= nil or not true or arg_100_3
	self._use_player_hosted = flag_3

	if not self._layout_save_settings then
		self._layout_save_settings.use_dedicated_win_servers = arg_100_1
		self._layout_save_settings.use_dedicated_aws_servers = arg_100_2
		self._layout_save_settings.use_player_hosted = arg_100_3
	end
end

StartGameStateSettingsOverview.using_player_hosted_search = function (self)
	-- function 101
	return self._use_player_hosted
end

StartGameStateSettingsOverview.using_dedicated_servers_search = function (self)
	-- function 102
	return self._use_dedicated_win_servers, self._use_dedicated_aws_servers
end

StartGameStateSettingsOverview.set_play_button_enabled = function (arg_103_0, arg_103_1)
	-- function 103
	return
end

StartGameStateSettingsOverview.set_confirm_button_visibility = function (arg_104_0, arg_104_1)
	-- function 104
	return
end

StartGameStateSettingsOverview.set_fullscreen_effect_enable_state = function (self, arg_105_1)
	-- function 105
	local world = self._ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_105_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_105_1 and 1 and 0

		set_scalar(var_105_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_105_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_105_1 and 0.75 and 0

		set_scalar_2(var_105_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_105_1
end

StartGameStateSettingsOverview.set_mutator_option = function (self, arg_106_1)
	-- function 106
	self._selected_mutator_key = arg_106_1
end

StartGameStateSettingsOverview.get_mutator_option = function (self)
	-- function 107
	return self._selected_mutator_key
end

StartGameStateSettingsOverview.get_completed_level_difficulty_index = function (self, arg_108_1, arg_108_2, arg_108_3)
	-- function 108
	local get_custom_game_settings = self:get_custom_game_settings(self._mechanism_name)

	get_custom_game_settings = get_custom_game_settings or self:get_custom_game_settings("adventure")

	local difficulty_index_getter_name = get_custom_game_settings.difficulty_index_getter_name

	return LevelUnlockUtils[difficulty_index_getter_name](arg_108_1, arg_108_2, arg_108_3)
end

StartGameStateSettingsOverview.can_use_streaming = function (arg_109_0)
	-- function 109
	if not IS_WINDOWS then
		return true
	end

	local twitch_enabled = GameSettingsDevelopment.twitch_enabled
	local offline_mode = Managers.account:offline_mode()

	return not twitch_enabled and not offline_mode
end

StartGameStateSettingsOverview.setup_backend_image_material = function (self, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	-- function 110
	local str = "StartGameStateSettingsOverview_" .. arg_110_2

	if not self._cloned_materials_by_reference[arg_110_2] then
		return str
	end

	local flag

	flag = not arg_110_4 and "template_menu_diffuse_masked" and "template_menu_diffuse"

	self:_create_material_instance(arg_110_1, str, flag, arg_110_2)

	local get_interface = Managers.backend:get_interface("cdn")
	local var_110_3 = callback(self, "_cb_on_backend_url_loaded", arg_110_1, arg_110_2, arg_110_3, str)

	get_interface:get_resource_urls({
		arg_110_3
	}, var_110_3)

	return str
end

StartGameStateSettingsOverview._cb_on_backend_url_loaded = function (self, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5)
	-- function 111
	local var_111_0 = arg_111_5[arg_111_3]

	if not var_111_0 then
		return
	end

	if self._is_open == false then
		return
	end

	self._material_references_to_unload[arg_111_2] = true

	local var_111_1 = callback(self, "_cb_on_backend_image_loaded", arg_111_1, arg_111_2, arg_111_4)

	Managers.url_loader:load_resource(arg_111_2, var_111_0, var_111_1, arg_111_3)
end

StartGameStateSettingsOverview._cb_on_backend_image_loaded = function (self, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
	-- function 112
	if not self._cloned_materials_by_reference[arg_112_2] then
		return
	end

	if not arg_112_4 then
		self:_set_material_diffuse_by_resource(arg_112_1, arg_112_3, arg_112_4)
	else
		self._material_references_to_unload[arg_112_2] = nil

		Application.warning(string.format("[StartGameStateSettingsOverview] - Failed loading image for reference name: (%s)", arg_112_2))
	end
end

StartGameStateSettingsOverview._create_material_instance = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	-- function 113
	arg_113_0._cloned_materials_by_reference[arg_113_4] = arg_113_2
	arg_113_0._gui_by_cloned_material_reference[arg_113_4] = arg_113_1

	return Gui.clone_material_from_template(arg_113_1, arg_113_2, arg_113_3)
end

StartGameStateSettingsOverview._set_material_diffuse_by_resource = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3)
	-- function 114
	local material = Gui.material(arg_114_1, arg_114_2)

	if not material then
		Material.set_resource(material, "diffuse_map", arg_114_3)
	end
end

StartGameStateSettingsOverview._set_material_diffuse_by_path = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
	-- function 115
	local material = Gui.material(arg_115_1, arg_115_2)

	if not material then
		Material.set_texture(material, "diffuse_map", arg_115_3)
	end
end

StartGameStateSettingsOverview._is_unique_reference_to_material = function (self, arg_116_1)
	-- function 116
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_116_1 = _cloned_materials_by_reference[arg_116_1]

	fassert(var_116_1, "[StartGameStateSettingsOverview] - Could not find a used material for reference name: (%s)", arg_116_1)

	for k, v in pairs(_cloned_materials_by_reference) do
		if not (var_116_1 ~= v or arg_116_1 == k) then
			return false
		end
	end

	return true
end

StartGameStateSettingsOverview.reset_cloned_material = function (self, arg_117_1)
	-- function 117
	local _gui_by_cloned_material_reference = self._gui_by_cloned_material_reference
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local _material_references_to_unload = self._material_references_to_unload

	if not _material_references_to_unload[arg_117_1] then
		_material_references_to_unload[arg_117_1] = nil

		Managers.url_loader:unload_resource(arg_117_1)
	end

	if not self:_is_unique_reference_to_material(arg_117_1) then
		local var_117_3 = _gui_by_cloned_material_reference[arg_117_1]
		local var_117_4 = _cloned_materials_by_reference[arg_117_1]

		self:_set_material_diffuse_by_path(var_117_3, var_117_4, str)
	end

	_cloned_materials_by_reference[arg_117_1] = nil
	_gui_by_cloned_material_reference[arg_117_1] = nil
end

StartGameStateSettingsOverview._reset_cloned_materials = function (self)
	-- function 118
	local _cloned_materials_by_reference = self._cloned_materials_by_reference

	for k, v in pairs(_cloned_materials_by_reference) do
		self:reset_cloned_material(k)
	end
end
