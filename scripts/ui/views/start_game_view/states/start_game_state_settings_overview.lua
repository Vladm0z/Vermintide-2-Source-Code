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

local definitions = local_require("scripts/ui/views/start_game_view/states/definitions/start_game_state_settings_overview_definitions")
local widget_definitions = definitions.widgets
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions
local DO_RELOAD = false
local STREAMING_PLACEHOLDER_TEXTURE_PATH = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

StartGameStateSettingsOverview = class(StartGameStateSettingsOverview)
StartGameStateSettingsOverview.NAME = "StartGameStateSettingsOverview"

StartGameStateSettingsOverview.on_enter = function (self, params)
	-- function 1
	print("[StartGameState] Enter Substate StartGameStateSettingsOverview")

	self.parent = params.parent
	self._mechanism_name = Managers.mechanism:current_mechanism_name()

	self:_setup_menu_layout(self._mechanism_name)

	self._wwise_world = params.wwise_world
	self._hero_name = params.hero_name

	local ingame_ui_context = params.ingame_ui_context

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

	local player_manager = Managers.player
	local local_player = player_manager:local_player()

	self._stats_id = local_player:stats_id()
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

	self:_create_ui_elements(params)
	self:_create_hdr_gui()

	if params.initial_state then
		params.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	local window_params = {
		wwise_world = self._wwise_world,
		ingame_ui_context = ingame_ui_context,
		parent = self,
		windows_settings = self._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		layout_settings = self._layout_settings,
		start_state = params.start_state,
		use_gamepad_layout = self._gamepad_style_active,
		mechanism_name = self._mechanism_name
	}

	self:set_confirm_button_visibility(false)

	if self._gamepad_style_active then
		self:_setup_gamepad_gui()
		self:disable_player_world()
	end

	self:_initial_windows_setups(window_params)
	self:_calculate_current_weave()

	self._input_paused = false

	Managers.state.event:trigger("tutorial_trigger", "start_game_menu_opened")
end

StartGameStateSettingsOverview._calculate_current_weave = function (self)
	-- function 2
	local ignore_dlc_check = false
	local weave_templates = WeaveSettings.templates_ordered
	local num_entries = #weave_templates
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()
	local highest_consecutive_unlocked_weave = 1
	local highest_consecutive_unlocked_weave_found = false

	for i = 1, num_entries do
		local template = weave_templates[i]
		local weave_completed = LevelUnlockUtils.weave_unlocked(statistics_db, stats_id, template.name, ignore_dlc_check)

		if (weave_completed or highest_consecutive_unlocked_weave == i) and not LevelUnlockUtils.weave_disabled(template.name) then
			if weave_completed and not highest_consecutive_unlocked_weave_found then
				if weave_templates[i + 1] then
					highest_consecutive_unlocked_weave = i + 1
				end
			else
				highest_consecutive_unlocked_weave_found = true
			end
		end
	end

	local var_2_0

	if highest_consecutive_unlocked_weave then
		var_2_0 = weave_templates[highest_consecutive_unlocked_weave]

		if not var_2_0 then
			-- Nothing
		end
	end

	var_2_0 = weave_templates[1]

	local weave_template = var_2_0

	::label_2_0::

	local weave_name = weave_template.name

	self._next_weave = weave_name

	if not self._selected_weave_id then
		self:set_selected_weave_id(self._next_weave)
		self:set_selected_weave_objective_index(1)
	end
end

StartGameStateSettingsOverview._setup_menu_layout = function (self, mechanism_name)
	-- function 3
	local layout_settings
	local IS_CONSOLE = IS_CONSOLE

	if not IS_CONSOLE then
		-- Nothing
	end

	IS_CONSOLE = Managers.input:is_device_active("gamepad")

	if not IS_CONSOLE then
		-- Nothing
	end

	if UISettings.use_pc_menu_layout then
		IS_CONSOLE = MechanismSettings[mechanism_name].use_gamepad_layout

		if false then
			IS_CONSOLE = false
		end

		goto label_3_0
	end

	IS_CONSOLE = true

	local use_gamepad_layout = IS_CONSOLE

	::label_3_0::

	if use_gamepad_layout then
		layout_settings = local_require("scripts/ui/views/start_game_view/states/start_game_window_layout_console")
	else
		layout_settings = local_require("scripts/ui/views/start_game_view/states/start_game_window_layout")
	end

	self._generic_input_actions = layout_settings.generic_input_actions
	self._video_resources = layout_settings.video_resources
	self._windows_settings = layout_settings.windows
	self._max_active_windows = layout_settings.max_active_windows
	self._max_alignment_windows = layout_settings.max_alignment_windows
	self._gamepad_style_active = use_gamepad_layout
	self._layout_settings = layout_settings
	self._window_layouts = layout_settings.window_layouts
	self._mechanism_quickplay_settings = layout_settings.mechanism_quickplay_settings
	self._mechanism_custom_game_settings = layout_settings.mechanism_custom_game_settings
	self._mechanism_twitch_settings = layout_settings.mechanism_twitch_settings
	self._save_data_table_maps = layout_settings.save_data_table_maps
end

StartGameStateSettingsOverview._create_ui_elements = function (self, params)
	-- function 4
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widgets = {}
	local widgets_by_name = {}

	for name, widget_definition in pairs(widget_definitions) do
		if widget_definition then
			local widget = UIWidget.init(widget_definition)

			widgets[#widgets + 1] = widget
			widgets_by_name[name] = widget
		end
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local gui_layer = UILayer.default + 30
	local input_service = self:input_service()
	local use_fullscreen_layout = self._gamepad_style_active

	if self._generic_input_actions then
		self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, input_service, 8, gui_layer, self._generic_input_actions.default, use_fullscreen_layout)

		self._menu_input_description:set_input_description(nil)
	end

	self:_create_video_players()
end

StartGameStateSettingsOverview._create_hdr_gui = function (self)
	-- function 5
	local world_flags = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local layer = 800
	local world_name = "start_game_menu_hdr_view"
	local viewport_name = "start_game_menu_hdr_view"
	local shading_environment = "environment/ui_hdr"
	local world = Managers.world:create_world(world_name, shading_environment, nil, layer, unpack(world_flags))
	local viewport_type = "overlay"
	local viewport = ScriptWorld.create_viewport(world, viewport_name, viewport_type, layer)

	self._ui_hdr_viewport_name = viewport_name
	self._ui_hdr_world_name = world_name
	self._ui_hdr_world = world
	self._ui_hdr_renderer = self._ingame_ui:create_ui_renderer(world, false, self._is_in_inn)
end

StartGameStateSettingsOverview.hdr_renderer = function (self)
	-- function 6
	return self._ui_hdr_renderer
end

StartGameStateSettingsOverview.ui_renderer = function (self)
	-- function 7
	if self._gamepad_style_active then
		return self._gui_data.bottom.renderer
	else
		return self.ui_renderer
	end
end

StartGameStateSettingsOverview._create_video_players = function (self)
	-- function 8
	self:_destroy_video_players()

	local video_players = {}

	if self._video_resources then
		local world = self._ui_top_renderer.world

		for name, settings in pairs(self._video_resources) do
			local resource = settings.resource
			local video_player = World.create_video_player(world, resource, true, false)

			video_players[name] = video_player
		end
	end

	self._video_players = video_players
end

StartGameStateSettingsOverview._destroy_video_players = function (self)
	-- function 9
	local video_players = self._video_players

	if video_players then
		local world = self._ui_top_renderer.world

		for name, video_player in pairs(video_players) do
			World.destroy_video_player(world, video_player)
		end
	end

	self._video_players = nil
end

StartGameStateSettingsOverview.get_video_player_by_name = function (self, name)
	-- function 10
	return self._video_players[name]
end

StartGameStateSettingsOverview._setup_gamepad_gui = function (self)
	-- function 11
	if self._is_in_inn then
		local gui_data = {}
		local world_name = "start_weave_gamepad"
		local renderer, world, viewport_name = self:_setup_gamepad_renderer(world_name, 1, GameSettingsDevelopment.default_environment)

		gui_data.bottom = {
			renderer = renderer,
			world = world,
			viewport_name = viewport_name
		}
		self._gui_data = gui_data
	end
end

StartGameStateSettingsOverview._setup_gamepad_renderer = function (self, name, layer, shading_environment)
	-- function 12
	local world_flags = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local world_name = name
	local viewport_name = name
	local world = Managers.world:create_world(world_name, shading_environment, nil, layer, unpack(world_flags))
	local viewport_type = "overlay"
	local viewport = ScriptWorld.create_viewport(world, viewport_name, viewport_type, 999)
	local renderer = self._ingame_ui:create_ui_renderer(world, false, self._is_in_inn)

	return renderer, world, viewport_name
end

StartGameStateSettingsOverview._destroy_gamepad_gui = function (self)
	-- function 13
	local gui_data = self._gui_data

	if gui_data then
		for _, data in pairs(gui_data) do
			local renderer = data.renderer
			local world = data.world
			local viewport_name = data.viewport_name

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

		local viewport_name = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, viewport_name)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

StartGameStateSettingsOverview.enable_player_world = function (self)
	-- function 15
	if self._player_world_disabled then
		self._player_world_disabled = false

		local viewport_name = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, viewport_name)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

StartGameStateSettingsOverview._start_layout_name = function (self)
	-- function 16
	local start_layout_name = PlayerData.mission_selection.start_layout
	local layout_setting = self:get_layout_setting_by_name(start_layout_name)

	if layout_setting and self:can_add_layout(layout_setting) then
		return start_layout_name
	else
		return self:_get_first_game_mode_option_layout()
	end
end

StartGameStateSettingsOverview.can_add_layout = function (self, layout_setting)
	-- function 17
	local can_add_function = layout_setting.can_add_function
	local layout_name = layout_setting.name

	if Managers.ui:is_ui_layout_hidden(layout_name) then
		return false
	end

	return not not can_add_function and not not can_add_function(self)
end

StartGameStateSettingsOverview._initial_windows_setups = function (self, params)
	-- function 18
	local active_windows = {}

	self._active_windows = active_windows
	self._window_params = params

	local start_layout_name

	if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) then
		if Managers.mechanism:current_mechanism_name() == "deus" then
			start_layout_name = "deus_twitch"
		else
			start_layout_name = "twitch"
		end
	else
		if not params.start_state then
			-- Nothing
		end

		::label_18_0::

		start_layout_name = self:_start_layout_name()
	end

	::label_18_1::

	self:set_layout_by_name(start_layout_name)
	self:set_top_level_layout_name(start_layout_name)
end

StartGameStateSettingsOverview.window_input_service = function (self)
	-- function 19
	local FAKE_INPUT_SERVICE

	if self._show_difficulty_option then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_19_0::

	return FAKE_INPUT_SERVICE
end

StartGameStateSettingsOverview._close_window_at_index = function (self, window_index)
	-- function 20
	local active_windows = self._active_windows
	local params = self._window_params
	local current_window = active_windows[window_index]

	if current_window and current_window.on_exit then
		current_window:on_exit(params)
	end

	active_windows[window_index] = nil
end

StartGameStateSettingsOverview._change_window = function (self, window_index, window_name)
	-- function 21
	local active_windows = self._active_windows
	local new_window_settings = self._windows_settings[window_name]
	local window_class_name = new_window_settings.class_name
	local current_window = active_windows[window_index]

	if current_window then
		if current_window.NAME == window_class_name then
			return
		end

		self:_close_window_at_index(window_index)
	end

	local window_class = rawget(_G, window_class_name)
	local window = window_class:new()
	local ignore_alignment = new_window_settings.ignore_alignment
	local parent_window_name = new_window_settings.parent_window_name
	local window_offset

	if not ignore_alignment then
		local window_default_settings = UISettings.game_start_windows
		local window_size = window_default_settings.size
		local spacing = window_default_settings.spacing

		if not spacing then
			-- Nothing
		end

		spacing = 10

		local window_spacing = spacing

		::label_21_0::

		local window_width = window_size[1]
		local _max_alignment_windows = self._max_alignment_windows

		if not _max_alignment_windows then
			-- Nothing
		end

		_max_alignment_windows = self._max_active_windows

		local max_active_windows = _max_alignment_windows

		::label_21_1::

		local total_spacing = window_spacing * (max_active_windows - 1)
		local total_windows_width = max_active_windows * window_width
		local start_width_offset = -(total_windows_width / 2 + window_width / 2) - (total_spacing / 2 + window_spacing)
		local window_width_offset = start_width_offset + window_index * window_width + window_index * window_spacing

		window_offset = {
			window_width_offset,
			0,
			3
		}
	end

	if window.on_enter then
		local params = self._window_params

		window:on_enter(params, window_offset, parent_window_name)
	end

	active_windows[window_index] = window
end

StartGameStateSettingsOverview._set_new_save_data_table = function (self, table_name)
	-- function 22
	if table_name then
		local mission_selection_save_data = PlayerData.mission_selection
		local mission_select_data = mission_selection_save_data[table_name]

		if not mission_select_data or not self:_validate_mission_save_data(mission_select_data) then
			mission_selection_save_data[table_name] = {}
		end

		local table = mission_selection_save_data[table_name]

		self._layout_save_settings = table

		self:set_private_option_enabled(table.is_private)
		self:set_always_host_option_enabled(table.always_host)
		self:set_strict_matchmaking_option_enabled(table.use_strict_matchmaking)
		self:set_selected_level_id(table.level_id)
		self:set_difficulty_option(table.difficulty_key)
		self:set_selected_weave_id(table.weave_id)
		self:set_dedicated_or_player_hosted_search(table.use_dedicated_win_servers, table.use_dedicated_aws_servers, table.use_player_hosted)
	else
		self._layout_save_settings = nil
	end
end

StartGameStateSettingsOverview._validate_mission_save_data = function (self, mission_save_data)
	-- function 23
	local level_id = not not mission_save_data and not not mission_save_data.level_id

	if not level_id then
		return true
	elseif not rawget(LevelSettings, level_id) then
		return false
	end

	local stats_id = self._stats_id
	local statistics_db = self._statistics_db

	return LevelUnlockUtils.level_unlocked(statistics_db, stats_id, level_id)
end

StartGameStateSettingsOverview.close_on_exit = function (self)
	-- function 24
	return self._close_on_exit
end

StartGameStateSettingsOverview.set_hide_panel_title_butttons = function (self, bool)
	-- function 25
	self._panel_title_buttons_hidden = bool
end

StartGameStateSettingsOverview.panel_title_buttons_hidden = function (self)
	-- function 26
	return self._panel_title_buttons_hidden
end

StartGameStateSettingsOverview.get_current_window_layout_settings = function (self)
	-- function 27
	for index, layout_setting in ipairs(self._window_layouts) do
		if layout_setting.name == self._selected_layout_name then
			return layout_setting
		end
	end
end

StartGameStateSettingsOverview.set_layout_by_name = function (self, name)
	-- function 28
	printf("[StartGameStateSettingsOverview]:set_layout_by_name() - %s", name)

	local index = table.find_by_key(self._window_layouts, "name", name)

	if not index then
		ferror("[StartGameStateSettingsOverview]:set_layout_by_name() - Could not find a layout with name %s. Layouts: (%s)", name, table.concat(table.select_array(self._window_layouts, function (_, l)
			-- function 29
			return l.name
		end), ", "))
	end

	self:set_layout(index)
end

StartGameStateSettingsOverview.get_mechanism_name = function (self)
	-- function 30
	return self._mechanism_name
end

StartGameStateSettingsOverview.is_in_mechanism = function (self, mechanism_name)
	-- function 31
	local is_in_weave_menu = self.parent:on_enter_sub_state() == "weave_quickplay"

	if mechanism_name == "weave" then
		return self._mechanism_name == "adventure" and not not is_in_weave_menu
	else
		return self._mechanism_name == mechanism_name and not not not is_in_weave_menu
	end
end

StartGameStateSettingsOverview.is_weekly_event_active = function (self)
	-- function 32
	local live_event_interface = Managers.backend:get_interface("live_events")
	local game_mode_data = live_event_interface:get_weekly_events_game_mode_data()

	return game_mode_data ~= nil
end

StartGameStateSettingsOverview.get_quickplay_settings = function (self, mechanism_name)
	-- function 33
	return self._mechanism_quickplay_settings[not not mechanism_name or not not self._mechanism_name]
end

StartGameStateSettingsOverview.get_custom_game_settings = function (self, mechanism_name)
	-- function 34
	return self._mechanism_custom_game_settings[not not mechanism_name or not not self._mechanism_name]
end

StartGameStateSettingsOverview.get_twitch_settings = function (self, mechanism_name)
	-- function 35
	return self._mechanism_twitch_settings[not not mechanism_name or not not self._mechanism_name]
end

StartGameStateSettingsOverview.get_save_data_table_map = function (self, mechanism_name)
	-- function 36
	return self._save_data_table_maps[not not mechanism_name or not not self._mechanism_name]
end

StartGameStateSettingsOverview.set_layout = function (self, index)
	-- function 37
	local layout_setting = self:get_layout_setting(index)
	local sound_event_enter = layout_setting.sound_event_enter

	if sound_event_enter then
		self:play_sound(sound_event_enter)
	end

	local save_data_table_name = layout_setting.save_data_table
	local get_save_data_table_map = self:get_save_data_table_map(self._mechanism_name)

	if not get_save_data_table_map then
		-- Nothing
	end

	get_save_data_table_map = self:get_quickplay_settings("adventure")

	local save_data_table_map = get_save_data_table_map

	::label_37_0::

	if save_data_table_map and not save_data_table_map[save_data_table_name] then
		-- Nothing
	end

	self:_set_new_save_data_table(save_data_table_name)

	local close_on_exit = layout_setting.close_on_exit
	local reset_on_exit = layout_setting.reset_on_exit
	local content = self._widgets_by_name.exit_button.content

	if reset_on_exit then
		-- Nothing
	end

	content.visible = close_on_exit
	self._widgets_by_name.back_button.content.visible = not not reset_on_exit or not not not close_on_exit
	self._close_on_exit = close_on_exit
	self._reset_on_exit = reset_on_exit

	local windows = layout_setting.windows
	local max_active_windows = self._max_active_windows

	for i = 1, max_active_windows do
		local window_changed = false

		for window_name, window_position_index in pairs(windows) do
			if window_position_index == i then
				self:_change_window(window_position_index, window_name)

				window_changed = true
			end
		end

		if not window_changed then
			self:_close_window_at_index(i)
		end
	end

	local layout_name = layout_setting.name
	local game_mode_option = layout_setting.game_mode_option

	if game_mode_option then
		if self._selected_game_mode_layout_name then
			self._previous_selected_game_mode_layout_name = self._selected_game_mode_layout_name
		end

		self._selected_game_mode_layout_name = layout_name
	end

	if self._selected_layout_name then
		self._previous_selected_layout_name = self._selected_layout_name
	end

	self._selected_layout_name = layout_name

	local input_focus_window = layout_setting.input_focus_window

	self:set_window_input_focus(input_focus_window)
end

StartGameStateSettingsOverview.set_window_input_focus = function (self, window_name)
	-- function 38
	local window_setting = self._windows_settings[window_name]
	local window_class_name = not not window_setting and not not window_setting.class_name
	local window_found = false
	local active_windows = self._active_windows

	for _, window in pairs(active_windows) do
		local name = window.NAME
		local focused = name == window_class_name

		if window.set_focus then
			window:set_focus(focused)
		end

		if focused then
			window_found = true
		end
	end

	if window_name and not window_found then
		ferror("[StartGameStateSettingsOverview] - (set_window_input_focus) Could not find a window by name: %s", window_name)
	end

	self._window_focused = window_name
end

StartGameStateSettingsOverview.set_top_level_layout_name = function (self, layout_name)
	-- function 39
	self._top_level_layout_name = layout_name
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

StartGameStateSettingsOverview.get_layout_setting = function (self, index)
	-- function 45
	return self._window_layouts[index]
end

StartGameStateSettingsOverview.get_layout_setting_by_name = function (self, name)
	-- function 46
	local _, layout_setting = table.find_by_key(self._window_layouts, "name", name)

	return layout_setting
end

StartGameStateSettingsOverview._get_first_game_mode_option_layout = function (self)
	-- function 47
	local window_layouts = self._window_layouts

	for i = 1, #window_layouts do
		local layout_setting = window_layouts[i]
		local layout_name = layout_setting.name
		local is_valid = self:can_add_layout(layout_setting)

		is_valid = not not is_valid and not not not Managers.ui:is_ui_layout_disabled(layout_name)

		if is_valid then
			return layout_name, layout_setting
		end
	end
end

StartGameStateSettingsOverview._windows_update = function (self, dt, t)
	-- function 48
	local active_windows = self._active_windows

	for _, window in pairs(active_windows) do
		window:update(dt, t)
	end
end

StartGameStateSettingsOverview._windows_post_update = function (self, dt, t)
	-- function 49
	local active_windows = self._active_windows

	for _, window in pairs(active_windows) do
		window:post_update(dt, t)
	end
end

StartGameStateSettingsOverview.enable_widget = function (self, active_window_index, widget_name, enable)
	-- function 50
	local active_windows = self._active_windows
	local active_window = active_windows[active_window_index]
	local widget = active_window._widgets_by_name[widget_name]

	if widget then
		local widget_content = widget.content
		local button_hotspot = widget_content.button_hotspot

		if button_hotspot then
			button_hotspot.disable_button = not enable
		end
	end
end

StartGameStateSettingsOverview.disable_input = function (self, input_name)
	-- function 51
	local active_windows = self._active_windows

	for _, active_window in pairs(active_windows) do
		if active_window.disable_input and active_window:disable_input(input_name) then
			return true
		end
	end
end

StartGameStateSettingsOverview.transitioning = function (self)
	-- function 52
	if self.exiting then
		return true
	else
		return false
	end
end

StartGameStateSettingsOverview._wanted_state = function (self)
	-- function 53
	local new_state = self.parent:wanted_state()

	return new_state
end

StartGameStateSettingsOverview.wanted_menu_state = function (self)
	-- function 54
	return self._wanted_menu_state
end

StartGameStateSettingsOverview.clear_wanted_menu_state = function (self)
	-- function 55
	self._wanted_menu_state = nil
end

StartGameStateSettingsOverview.on_exit = function (self, params)
	-- function 56
	print("[StartGameState] Exit Substate StartGameStateSettingsOverview")

	self.ui_animator = nil
	self._is_open = false

	if self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	Managers.save:auto_save(SaveFileName, SaveData, nil)
	self:_close_active_windows()
	self:_destroy_video_players()

	if self._gamepad_style_active then
		self:_destroy_gamepad_gui()
		self:enable_player_world()
	end

	self:_reset_cloned_materials()

	if self._ui_hdr_renderer then
		UIRenderer.destroy(self._ui_hdr_renderer, self._ui_hdr_world)

		self._ui_hdr_renderer = nil
	end

	if self._ui_hdr_world then
		ScriptWorld.destroy_viewport(self._ui_hdr_world, self._ui_hdr_viewport_name)
		Managers.world:destroy_world(self._ui_hdr_world)

		self._ui_hdr_viewport_name = nil
		self._ui_hdr_world_name = nil
		self._ui_hdr_world = nil
	end
end

StartGameStateSettingsOverview._close_active_windows = function (self)
	-- function 57
	local active_windows = self._active_windows
	local params = self._window_params

	for _, window in pairs(active_windows) do
		if window.on_exit then
			window:on_exit(params)
		end
	end

	table.clear(active_windows)
end

StartGameStateSettingsOverview._update_transition_timer = function (self, dt)
	-- function 58
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - dt, 0)
	end
end

StartGameStateSettingsOverview.input_service = function (self)
	-- function 59
	return self.parent:input_service()
end

StartGameStateSettingsOverview.update = function (self, dt, t)
	-- function 60
	if DO_RELOAD then
		DO_RELOAD = false

		self:_create_ui_elements()
	end

	if Managers.matchmaking:is_in_versus_custom_game_lobby() then
		local network_handler = Managers.mechanism:network_handler()
		local match_handler = network_handler:get_match_handler()
		local is_match_host = match_handler:query_peer_data(Network.peer_id(), "is_match_owner")

		if not is_match_host then
			local current_layout = self._selected_layout_name
			local wanted_layout = "versus_player_hosted_lobby"

			if current_layout ~= wanted_layout then
				self:set_layout_by_name(wanted_layout)
			end
		end
	end

	local input_manager = self._input_manager
	local input_service = self.parent:input_service()

	self:draw(input_service, dt)
	self:_update_transition_timer(dt)

	if not self._show_difficulty_option then
		self:_windows_update(dt, t)
	end

	local wanted_state = self:_wanted_state()

	if not self._transition_timer and (wanted_state or self._new_state) then
		self.parent:clear_wanted_state()

		return not not wanted_state or not not self._new_state
	end
end

StartGameStateSettingsOverview.post_update = function (self, dt, t)
	-- function 61
	self.ui_animator:update(dt)
	self:_update_animations(dt)

	local transitioning = self.parent:transitioning()

	if not transitioning and not self._transition_timer and not self:input_paused() then
		self:_handle_input(dt, t)
	end

	self:_windows_post_update(dt, t)
end

StartGameStateSettingsOverview._update_animations = function (self, dt)
	-- function 62
	for name, animation in pairs(self._ui_animations) do
		UIAnimation.update(animation, dt)

		if UIAnimation.completed(animation) then
			self._ui_animations[name] = nil
		end
	end

	local animations = self._animations
	local ui_animator = self.ui_animator

	for animation_name, animation_id in pairs(animations) do
		if ui_animator:is_animation_completed(animation_id) then
			ui_animator:stop_animation(animation_id)

			animations[animation_name] = nil
		end
	end
end

StartGameStateSettingsOverview._is_button_hover_enter = function (self, widget)
	-- function 63
	local content = widget.content
	local hotspot = content.button_hotspot

	return hotspot.on_hover_enter
end

StartGameStateSettingsOverview._handle_input = function (self, dt, t)
	-- function 64
	local widgets_by_name = self._widgets_by_name
	local input_service = self.parent:input_service()
	local input_pressed = input_service:get("toggle_menu", true)
	local gamepad_active = Managers.input:is_device_active("gamepad")
	local back_pressed = not not gamepad_active and not not input_service:get("back_menu", true)
	local close_on_exit = self._close_on_exit
	local reset_on_exit = self._reset_on_exit
	local back_button = widgets_by_name.back_button
	local exit_button = widgets_by_name.exit_button

	UIWidgetUtils.animate_default_button(back_button, dt)
	UIWidgetUtils.animate_default_button(exit_button, dt)

	if self:_is_button_hover_enter(back_button) or self:_is_button_hover_enter(exit_button) then
		self:play_sound("play_gui_equipment_button_hover")
	end

	if reset_on_exit and (input_pressed or back_pressed or self:_is_button_pressed(back_button)) then
		self:play_sound("play_gui_lobby_back")

		local start_layout_name = self:_start_layout_name()

		self:set_layout_by_name(start_layout_name)
	elseif close_on_exit and (back_pressed or input_pressed or self:_is_button_pressed(exit_button)) then
		self:close_menu()

		return
	elseif input_pressed or back_pressed or self:_is_button_pressed(back_button) then
		self:play_sound("Play_hud_select")

		local return_layout_name
		local window_params = self._window_params

		if window_params then
			return_layout_name = window_params.return_layout_name
			window_params.return_layout_name = nil
		end

		if not return_layout_name then
			local layout_settings = self:get_layout_setting_by_name(self._selected_layout_name)

			if layout_settings.return_to_top_level then
				return_layout_name = not not self:get_top_level_layout_name() or not not self:get_previous_selected_layout_name()
			else
				return_layout_name = self:get_previous_selected_layout_name()
			end
		end

		if return_layout_name then
			self:set_layout_by_name(return_layout_name)
		end
	end
end

StartGameStateSettingsOverview.pause_input = function (self, pause)
	-- function 65
	self._input_paused = pause
end

StartGameStateSettingsOverview.input_paused = function (self)
	-- function 66
	return self._input_paused
end

StartGameStateSettingsOverview.close_menu = function (self, ignore_sound_on_close_menu)
	-- function 67
	self.parent:close_menu(nil, ignore_sound_on_close_menu)
end

StartGameStateSettingsOverview.cancel_matchmaking = function (self)
	-- function 68
	self.parent:cancel_matchmaking()
end

local EMPTY_TABLE = {}

StartGameStateSettingsOverview.play = function (self, t, vote_type, force_close_menu)
	-- function 69
	printf("[StartGameStateSettingsOverview:play() - vote_type(%s)", vote_type)

	local is_offline = Managers.account:offline_mode()

	if vote_type == "adventure_mode" then
		local level_key = self:get_selected_level_id()
		local difficulty = self._selected_difficulty_key
		local is_private = true
		local quick_game = false
		local always_host = true
		local strict_matchmaking = false
		local deed_backend_id, event_data

		self.parent:start_game(level_key, difficulty, is_private, quick_game, always_host, strict_matchmaking, t, matchmaking_type, deed_backend_id, event_data)
	elseif vote_type == "adventure" then
		local params = {
			mechanism = "adventure",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = self._selected_difficulty_key,
			private_game = is_offline,
			always_host = is_offline,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "weave_quick_play" then
		local params = {
			private_game = false,
			mechanism = "weave",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = self._selected_difficulty_key,
			always_host = is_offline,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "custom" then
		local network_lobby = self._network_lobby
		local num_members = network_lobby:members():get_member_count()
		local is_private = self:is_private_option_enabled()

		if IS_CONSOLE and not is_offline then
			-- Nothing
		end

		local is_alone = num_members == 1
		local always_host = not not is_private or not not self:is_always_host_option_enabled()
		local params = {
			mechanism = "adventure",
			matchmaking_type = "custom",
			quick_game = false,
			network_lobby = network_lobby,
			num_members = num_members,
			is_alone = is_alone,
			mission_id = self:get_selected_level_id(),
			difficulty = self._selected_difficulty_key,
			private_game = is_private,
			always_host = always_host,
			strict_matchmaking = not not is_alone and not is_private and not always_host and not not self:is_strict_matchmaking_option_enabled(),
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "deed" then
		local params = {
			is_private = true,
			mechanism = "adventure",
			quick_game = false,
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "deed",
			deed_backend_id = self:get_selected_heroic_deed_backend_id(),
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "twitch" then
		local params = {
			private_game = true,
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "custom",
			mechanism = "adventure",
			quick_game = false,
			twitch_enabled = true,
			mission_id = self:get_selected_level_id(),
			difficulty = self._selected_difficulty_key,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "event" then
		local live_event_interface = Managers.backend:get_interface("live_events")
		local game_mode_data = live_event_interface:get_weekly_events_game_mode_data()
		local event_data

		if game_mode_data.mutators then
			event_data = {
				mutators = game_mode_data.mutators
			}
		end

		local params = {
			private_game = false,
			strict_matchmaking = false,
			always_host = false,
			matchmaking_type = "event",
			mechanism = "adventure",
			quick_game = false,
			mission_id = game_mode_data.level_key,
			difficulty = self._selected_difficulty_key,
			event_data = event_data,
			excluded_level_keys = game_mode_data.excluded_level_keys,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "versus_quickplay" then
		local params = {
			private_game = false,
			dedicated_servers_aws = true,
			player_hosted = false,
			dedicated_servers_win = false,
			matchmaking_type = "standard",
			mechanism = "versus",
			quick_game = true,
			difficulty = "versus_base",
			join_method = "party",
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "versus_custom" then
		local is_private = self:is_private_option_enabled()
		local mission_id = self:get_selected_level_id()
		local params = {
			player_hosted = true,
			dedicated_servers_win = false,
			dedicated_servers_aws = false,
			matchmaking_type = "custom",
			mechanism = "versus",
			quick_game = false,
			difficulty = "versus_base",
			join_method = "party",
			mission_id = mission_id,
			any_level = not mission_id,
			private_game = is_private,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "weave" then
		local weave_name = self:get_selected_weave_id()
		local weave_template = WeaveSettings.templates[weave_name]
		local difficulty = weave_template.difficulty_key
		local objective_index = self:get_selected_weave_objective_index()
		local is_private = self:is_private_option_enabled()
		local always_host = is_offline
		local params = {
			matchmaking_type = "custom",
			mechanism = "weave",
			quick_game = false,
			mission_id = weave_name,
			difficulty = difficulty,
			objective_index = objective_index,
			private_game = is_private,
			always_host = is_offline,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "deus_custom" then
		local network_lobby = self._network_lobby
		local num_members = network_lobby:members():get_member_count()
		local is_alone = num_members == 1
		local private_game = not not is_offline or not not self:is_private_option_enabled()
		local always_host = not not private_game or not not self:is_always_host_option_enabled()
		local backend_deus = Managers.backend:get_interface("deus")
		local journey_cycle = backend_deus:get_journey_cycle()
		local journey_name = self:get_selected_level_id()

		journey_name = (not DeusJourneySettings[journey_name] or not journey_name) and not not AvailableJourneyOrder[1]

		local dominant_god = journey_cycle.journey_data[journey_name].dominant_god
		local params = {
			matchmaking_type = "custom",
			mechanism = "deus",
			quick_game = false,
			mission_id = journey_name,
			difficulty = self._selected_difficulty_key,
			private_game = private_game,
			always_host = always_host,
			strict_matchmaking = not not is_alone and not private_game and not always_host and not not self:is_strict_matchmaking_option_enabled(),
			dominant_god = dominant_god,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "deus_twitch" then
		local backend_deus = Managers.backend:get_interface("deus")
		local journey_cycle = backend_deus:get_journey_cycle()
		local journey_name = self:get_selected_level_id()

		journey_name = (not DeusJourneySettings[journey_name] or not journey_name) and not not AvailableJourneyOrder[1]

		local dominant_god = journey_cycle.journey_data[journey_name].dominant_god
		local params = {
			private_game = true,
			mechanism = "deus",
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "custom",
			quick_game = false,
			twitch_enabled = true,
			mission_id = journey_name,
			difficulty = self._selected_difficulty_key,
			dominant_god = dominant_god,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "deus_quickplay" then
		local params = {
			mechanism = "deus",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = self._selected_difficulty_key,
			private_game = is_offline,
			always_host = is_offline,
			request_type = vote_type
		}

		self.parent:start_game(params)
	elseif vote_type == "deus_weekly" then
		local live_event_interface = Managers.backend:get_interface("live_events")
		local get_weekly_chaos_wastes_game_mode_data = live_event_interface:get_weekly_chaos_wastes_game_mode_data()

		if not get_weekly_chaos_wastes_game_mode_data then
			-- Nothing
		end

		get_weekly_chaos_wastes_game_mode_data = EMPTY_TABLE

		local game_mode_data = get_weekly_chaos_wastes_game_mode_data

		::label_69_0::

		local event_data

		if game_mode_data.mutators then
			event_data = not not event_data or not not {}
			event_data.mutators = game_mode_data.mutators
		end

		if game_mode_data.boons then
			event_data = not not event_data or not not {}
			event_data.boons = game_mode_data.boons
		end

		local mission_id = game_mode_data.journey_name
		local backend_deus = Managers.backend:get_interface("deus")
		local journey_cycle = backend_deus:get_journey_cycle()
		local journey_data = journey_cycle.journey_data
		local journey_settings = journey_data[mission_id]
		local dominant_god = journey_settings.dominant_god
		local params = {
			private_game = false,
			strict_matchmaking = false,
			always_host = false,
			matchmaking_type = "event",
			mechanism = "deus",
			quick_game = false,
			mission_id = mission_id,
			difficulty = self._selected_difficulty_key,
			dominant_god = dominant_god,
			event_data = event_data,
			excluded_level_keys = game_mode_data.excluded_level_keys,
			request_type = vote_type
		}

		self.parent:start_game(params)
	else
		ferror("Unknown vote_type(%s)", vote_type)
	end
end

StartGameStateSettingsOverview.is_confirm_putton_pressed = function (self)
	-- function 70
	return false
end

StartGameStateSettingsOverview.set_input_description = function (self, input_description)
	-- function 71
	if not self._menu_input_description then
		return
	end

	fassert(not input_description or not not self._generic_input_actions[input_description], "[StartGameStateSettingsOverview:set_input_description] There is no such input_description (%s)", input_description)
	self._menu_input_description:set_input_description(self._generic_input_actions[input_description])
end

StartGameStateSettingsOverview.change_generic_actions = function (self, input_description)
	-- function 72
	if not self._menu_input_description then
		return
	end

	fassert(self._generic_input_actions[input_description], "[StartGameStateSettingsOverview:set_input_description] There is no such input_description (%s)", input_description)
	self._menu_input_description:change_generic_actions(self._generic_input_actions[input_description])
end

StartGameStateSettingsOverview.draw = function (self, input_service, dt)
	-- function 73
	local ui_renderer = self._ui_renderer
	local ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self._ui_scenegraph
	local input_manager = self._input_manager
	local render_settings = self._render_settings

	if not self._gamepad_style_active then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

		local snap_pixel_positions = render_settings.snap_pixel_positions

		for _, widget in ipairs(self._widgets) do
			if widget.snap_pixel_positions ~= nil then
				render_settings.snap_pixel_positions = widget.snap_pixel_positions
			end

			UIRenderer.draw_widget(ui_renderer, widget)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end

		UIRenderer.end_pass(ui_renderer)
	end

	local gamepad_active = input_manager:is_device_active("gamepad")

	if gamepad_active and self._menu_input_description and not self.parent:active_view() then
		self._menu_input_description:draw(ui_top_renderer, dt)
	end
end

StartGameStateSettingsOverview.draw_menu_input_description = function (self, input_service, dt)
	-- function 74
	local ui_top_renderer = self._ui_top_renderer

	self._menu_input_description:draw(ui_top_renderer, dt)
end

StartGameStateSettingsOverview._is_button_pressed = function (self, widget)
	-- function 75
	local content = widget.content
	local button_hotspot = content.button_hotspot

	if not button_hotspot then
		-- Nothing
	end

	button_hotspot = content.hotspot

	local hotspot = button_hotspot

	::label_75_0::

	if hotspot.on_release then
		hotspot.on_release = false

		return true
	end
end

StartGameStateSettingsOverview.play_sound = function (self, event)
	-- function 76
	self.parent:play_sound(event)
end

StartGameStateSettingsOverview._start_transition_animation = function (self, key, animation_name)
	-- function 77
	local params = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local widgets = {}
	local anim_id = self.ui_animator:start_animation(animation_name, widgets, scenegraph_definition, params)

	self._animations[key] = anim_id
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

StartGameStateSettingsOverview.set_selected_weave_id = function (self, weave_name)
	-- function 81
	if self._layout_save_settings then
		self._layout_save_settings.weave_id = weave_name
	end

	if weave_name then
		self._selected_weave_id = weave_name
	end
end

StartGameStateSettingsOverview.set_selected_weave_objective_index = function (self, objective_index)
	-- function 82
	self._selected_weave_objective_index = objective_index
end

StartGameStateSettingsOverview.get_selected_heroic_deed_backend_id = function (self)
	-- function 83
	return self._selected_heroic_deed_backend_id
end

StartGameStateSettingsOverview.set_selected_heroic_deed_backend_id = function (self, backend_id)
	-- function 84
	self._selected_heroic_deed_backend_id = backend_id
end

StartGameStateSettingsOverview.get_selected_level_id = function (self)
	-- function 85
	local dlc_approved = true
	local extra_requirements_approved = true
	local _specific_level_id = self._specific_level_id

	if _specific_level_id then
		-- Nothing
	end

	_specific_level_id = LevelSettings[self._specific_level_id]

	local level_settings = _specific_level_id

	::label_85_0::

	if level_settings and level_settings.dlc_name then
		dlc_approved = Managers.unlock:is_dlc_unlocked(level_settings.dlc_name)
	end

	local selected_area_name = self:get_selected_area_name()

	if selected_area_name then
		local area_settings = AreaSettings[selected_area_name]

		if area_settings and area_settings.unlock_requirement_function then
			extra_requirements_approved = area_settings.unlock_requirement_function(self._statistics_db, self._stats_id)
		end
	end

	local _specific_level_id_2

	if dlc_approved and extra_requirements_approved then
		_specific_level_id_2 = self._specific_level_id

		if not _specific_level_id_2 then
			-- Nothing
		end
	end

	_specific_level_id_2 = nil

	::label_85_1::

	return _specific_level_id_2
end

StartGameStateSettingsOverview.set_selected_level_id = function (self, level_id)
	-- function 86
	if self._layout_save_settings then
		self._layout_save_settings.level_id = level_id
	end

	self._specific_level_id = level_id
end

StartGameStateSettingsOverview.get_selected_area_name = function (self)
	-- function 87
	if self._specific_area_name then
		local specific_area_name = self._specific_area_name

		if AreaSettings[specific_area_name] then
			return self._specific_area_name
		end
	end

	if self._layout_save_settings then
		local area_name = self._layout_save_settings.area_name

		if area_name and AreaSettings[area_name] then
			return area_name
		end
	end

	return "helmgart"
end

StartGameStateSettingsOverview.set_selected_area_name = function (self, area_name)
	-- function 88
	if self._layout_save_settings then
		self._layout_save_settings.area_name = area_name
	end

	self._specific_area_name = area_name
end

StartGameStateSettingsOverview.show_difficulty_option = function (self)
	-- function 89
	self._show_difficulty_option = true
end

StartGameStateSettingsOverview.hide_difficulty_option = function (self)
	-- function 90
	self._show_difficulty_option = false
end

StartGameStateSettingsOverview.set_private_option_enabled = function (self, is_private)
	-- function 91
	if is_private == nil then
		is_private = false
	end

	if self._layout_save_settings then
		self._layout_save_settings.is_private = is_private
	end

	self._is_game_private = is_private
end

StartGameStateSettingsOverview.is_private_option_enabled = function (self)
	-- function 92
	return self._is_game_private
end

StartGameStateSettingsOverview.set_always_host_option_enabled = function (self, always_host)
	-- function 93
	if always_host == nil then
		always_host = false
	end

	if self._layout_save_settings then
		self._layout_save_settings.always_host = always_host
	end

	self._always_host = always_host
end

StartGameStateSettingsOverview.is_always_host_option_enabled = function (self)
	-- function 94
	return self._always_host
end

StartGameStateSettingsOverview.set_strict_matchmaking_option_enabled = function (self, use_strict_matchmaking)
	-- function 95
	if use_strict_matchmaking == nil then
		use_strict_matchmaking = true
	end

	if self._layout_save_settings then
		self._layout_save_settings.use_strict_matchmaking = use_strict_matchmaking
	end

	self._use_strict_matchmaking = use_strict_matchmaking
end

StartGameStateSettingsOverview.is_strict_matchmaking_option_enabled = function (self)
	-- function 96
	return self._use_strict_matchmaking
end

local host_human_players = {}

StartGameStateSettingsOverview.is_difficulty_approved = function (self, difficulty_key)
	-- function 97
	if Development.parameter("unlock_all_difficulties") then
		return true
	end

	if script_data.disable_hero_power_requirement then
		return true
	end

	if not difficulty_key then
		return false
	end

	local difficulty_approved = true
	local extra_requirement, dlc_requirement, below_power_level
	local human_players = Managers.player:human_players()

	if not self:is_private_option_enabled() then
		local players_below_difficulty = DifficultyManager.players_below_required_power_level(difficulty_key, human_players)

		if #players_below_difficulty > 0 then
			difficulty_approved = false
			below_power_level = true
		end
	end

	local difficulty_settings = DifficultySettings[difficulty_key]

	if difficulty_settings.extra_requirement_name then
		local players = human_players

		if Managers.state.network.is_server then
			host_human_players[1] = Managers.player:local_player()
			players = host_human_players
		end

		local players_not_meeting_requirements = DifficultyManager.players_locked_difficulty_rank(difficulty_key, players)

		if #players_not_meeting_requirements > 0 then
			local extra_requirement_name = difficulty_settings.extra_requirement_name
			local requirement_data = ExtraDifficultyRequirements[extra_requirement_name]

			extra_requirement = requirement_data.description_text
			difficulty_approved = false
		end
	end

	if difficulty_settings.dlc_requirement then
		local network_handler = Managers.mechanism:network_handler()

		if network_handler then
			local anyone_has_unlocked_dlc = false
			local peers = network_handler:get_peers()

			for i = 1, #peers do
				local peer_id = peers[i]

				if network_handler:is_network_state_fully_synced_for_peer(peer_id) and network_handler:has_unlocked_dlc(peer_id, difficulty_settings.dlc_requirement) then
					anyone_has_unlocked_dlc = true
				end
			end

			if not anyone_has_unlocked_dlc then
				difficulty_approved = false
				dlc_requirement = difficulty_settings.dlc_requirement
			end
		end
	end

	return difficulty_approved, extra_requirement, dlc_requirement, below_power_level
end

StartGameStateSettingsOverview.set_difficulty_option = function (self, difficulty_key)
	-- function 98
	if self._layout_save_settings then
		self._layout_save_settings.difficulty_key = difficulty_key
	end

	self._selected_difficulty_key = difficulty_key
end

StartGameStateSettingsOverview.get_difficulty_option = function (self, ignore_approval)
	-- function 99
	local default_mechanism_difficulty = Managers.mechanism:mechanism_setting("default_difficulty")
	local selected_difficulty_key = self._selected_difficulty_key
	local find = table.find(Difficulties, selected_difficulty_key)

	if not find then
		-- Nothing
	end

	find = table.index_of(Difficulties, default_mechanism_difficulty)

	local difficulty_index = find

	::label_99_0::

	for i = difficulty_index, 1, -1 do
		selected_difficulty_key = Difficulties[i]

		if self:is_difficulty_approved(selected_difficulty_key) then
			break
		end
	end

	self:set_difficulty_option(selected_difficulty_key)

	return selected_difficulty_key
end

StartGameStateSettingsOverview.set_dedicated_or_player_hosted_search = function (self, use_dedicated_win_servers, use_dedicated_aws_servers, use_player_hosted)
	-- function 100
	local flag

	flag = (use_dedicated_win_servers ~= nil or not true) and not not use_dedicated_win_servers
	self._use_dedicated_win_servers = flag

	local flag_2

	flag_2 = (use_dedicated_aws_servers ~= nil or not true) and not not use_dedicated_aws_servers
	self._use_dedicated_aws_servers = flag_2

	local flag_3

	flag_3 = (use_player_hosted ~= nil or not true) and not not use_player_hosted
	self._use_player_hosted = flag_3

	if self._layout_save_settings then
		self._layout_save_settings.use_dedicated_win_servers = use_dedicated_win_servers
		self._layout_save_settings.use_dedicated_aws_servers = use_dedicated_aws_servers
		self._layout_save_settings.use_player_hosted = use_player_hosted
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

StartGameStateSettingsOverview.set_play_button_enabled = function (self, enabled)
	-- function 103
	return
end

StartGameStateSettingsOverview.set_confirm_button_visibility = function (self, visible)
	-- function 104
	return
end

StartGameStateSettingsOverview.set_fullscreen_effect_enable_state = function (self, enabled)
	-- function 105
	local world = self._ui_renderer.world
	local shading_env = World.get_data(world, "shading_environment")

	if shading_env then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_105_1 = shading_env
		local str = "fullscreen_blur_enabled"
		local flag

		flag = (not enabled or not 1) and not not 0

		set_scalar(var_105_1, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_105_5 = shading_env
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = (not enabled or not 0.75) and not not 0

		set_scalar_2(var_105_5, str_2, flag_2)
		ShadingEnvironment.apply(shading_env)
	end

	self._fullscreen_effect_enabled = enabled
end

StartGameStateSettingsOverview.set_mutator_option = function (self, mutator_key)
	-- function 106
	self._selected_mutator_key = mutator_key
end

StartGameStateSettingsOverview.get_mutator_option = function (self)
	-- function 107
	return self._selected_mutator_key
end

StartGameStateSettingsOverview.get_completed_level_difficulty_index = function (self, statistics_db, stats_id, level_id)
	-- function 108
	local get_custom_game_settings = self:get_custom_game_settings(self._mechanism_name)

	if not get_custom_game_settings then
		-- Nothing
	end

	get_custom_game_settings = self:get_custom_game_settings("adventure")

	local settings = get_custom_game_settings

	::label_108_0::

	local function_name = settings.difficulty_index_getter_name

	return LevelUnlockUtils[function_name](statistics_db, stats_id, level_id)
end

StartGameStateSettingsOverview.can_use_streaming = function (self)
	-- function 109
	if IS_WINDOWS then
		return true
	end

	local twitch_enabled = GameSettingsDevelopment.twitch_enabled
	local is_offline = Managers.account:offline_mode()

	return not not twitch_enabled and not not not is_offline
end

StartGameStateSettingsOverview.setup_backend_image_material = function (self, gui, reference_name, texture_name, masked)
	-- function 110
	local material_name = "StartGameStateSettingsOverview_" .. reference_name
	local cloned_materials_by_reference = self._cloned_materials_by_reference

	if cloned_materials_by_reference[reference_name] then
		return material_name
	end

	local str

	if masked then
		str = "template_menu_diffuse_masked"

		goto label_110_0
	end

	str = "template_menu_diffuse"

	local template_material_name = str

	::label_110_0::

	self:_create_material_instance(gui, material_name, template_material_name, reference_name)

	local cdn = Managers.backend:get_interface("cdn")
	local cb = callback(self, "_cb_on_backend_url_loaded", gui, reference_name, texture_name, material_name)

	cdn:get_resource_urls({
		texture_name
	}, cb)

	return material_name
end

StartGameStateSettingsOverview._cb_on_backend_url_loaded = function (self, gui, reference_name, texture_name, material_name, result)
	-- function 111
	local texture_url = result[texture_name]

	if not texture_url then
		return
	end

	if self._is_open == false then
		return
	end

	self._material_references_to_unload[reference_name] = true

	local cb = callback(self, "_cb_on_backend_image_loaded", gui, reference_name, material_name)

	Managers.url_loader:load_resource(reference_name, texture_url, cb, texture_name)
end

StartGameStateSettingsOverview._cb_on_backend_image_loaded = function (self, gui, reference_name, material_name, texture_resource)
	-- function 112
	if not self._cloned_materials_by_reference[reference_name] then
		return
	end

	if texture_resource then
		self:_set_material_diffuse_by_resource(gui, material_name, texture_resource)
	else
		self._material_references_to_unload[reference_name] = nil

		Application.warning(string.format("[StartGameStateSettingsOverview] - Failed loading image for reference name: (%s)", reference_name))
	end
end

StartGameStateSettingsOverview._create_material_instance = function (self, gui, new_material_name, template_material_name, reference_name)
	-- function 113
	local cloned_materials_by_reference = self._cloned_materials_by_reference

	cloned_materials_by_reference[reference_name] = new_material_name

	local gui_by_cloned_material_reference = self._gui_by_cloned_material_reference

	gui_by_cloned_material_reference[reference_name] = gui

	return Gui.clone_material_from_template(gui, new_material_name, template_material_name)
end

StartGameStateSettingsOverview._set_material_diffuse_by_resource = function (self, gui, material_name, texture_resource)
	-- function 114
	local material = Gui.material(gui, material_name)

	if material then
		Material.set_resource(material, "diffuse_map", texture_resource)
	end
end

StartGameStateSettingsOverview._set_material_diffuse_by_path = function (self, gui, material_name, texture_path)
	-- function 115
	local material = Gui.material(gui, material_name)

	if material then
		Material.set_texture(material, "diffuse_map", texture_path)
	end
end

StartGameStateSettingsOverview._is_unique_reference_to_material = function (self, reference_name)
	-- function 116
	local cloned_materials_by_reference = self._cloned_materials_by_reference
	local material_name = cloned_materials_by_reference[reference_name]

	fassert(material_name, "[StartGameStateSettingsOverview] - Could not find a used material for reference name: (%s)", reference_name)

	for key, value in pairs(cloned_materials_by_reference) do
		if material_name == value and reference_name ~= key then
			return false
		end
	end

	return true
end

StartGameStateSettingsOverview.reset_cloned_material = function (self, reference_name)
	-- function 117
	local gui_by_cloned_material_reference = self._gui_by_cloned_material_reference
	local cloned_materials_by_reference = self._cloned_materials_by_reference
	local material_references_to_unload = self._material_references_to_unload

	if material_references_to_unload[reference_name] then
		material_references_to_unload[reference_name] = nil

		Managers.url_loader:unload_resource(reference_name)
	end

	if self:_is_unique_reference_to_material(reference_name) then
		local gui = gui_by_cloned_material_reference[reference_name]
		local material_name = cloned_materials_by_reference[reference_name]

		self:_set_material_diffuse_by_path(gui, material_name, STREAMING_PLACEHOLDER_TEXTURE_PATH)
	end

	cloned_materials_by_reference[reference_name] = nil
	gui_by_cloned_material_reference[reference_name] = nil
end

StartGameStateSettingsOverview._reset_cloned_materials = function (self)
	-- function 118
	local cloned_materials_by_reference = self._cloned_materials_by_reference

	for reference_name, material_name in pairs(cloned_materials_by_reference) do
		self:reset_cloned_material(reference_name)
	end
end
