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
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = false
local var_0_5 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

StartGameStateSettingsOverview = class(StartGameStateSettingsOverview)
StartGameStateSettingsOverview.NAME = "StartGameStateSettingsOverview"

StartGameStateSettingsOverview.on_enter = function (arg_1_0, arg_1_1)
	print("[StartGameState] Enter Substate StartGameStateSettingsOverview")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()

	arg_1_0:_setup_menu_layout(arg_1_0._mechanism_name)

	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._hero_name = arg_1_1.hero_name

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = var_1_0.network_lobby
	arg_1_0._is_in_inn = var_1_0.is_in_inn
	arg_1_0._ingame_ui = var_1_0.ingame_ui
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._cloned_materials_by_reference = {}
	arg_1_0._gui_by_cloned_material_reference = {}
	arg_1_0._material_references_to_unload = {}
	arg_1_0._is_game_private = false
	arg_1_0._always_host = false
	arg_1_0._use_strict_matchmaking = true
	arg_1_0._is_open = true
	arg_1_0._selected_weave_objective_index = 1

	arg_1_0:_create_ui_elements(arg_1_1)
	arg_1_0:_create_hdr_gui()

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	local var_1_1 = {
		wwise_world = arg_1_0._wwise_world,
		ingame_ui_context = var_1_0,
		parent = arg_1_0,
		windows_settings = arg_1_0._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		layout_settings = arg_1_0._layout_settings,
		start_state = arg_1_1.start_state,
		use_gamepad_layout = arg_1_0._gamepad_style_active,
		mechanism_name = arg_1_0._mechanism_name
	}

	arg_1_0:set_confirm_button_visibility(false)

	if arg_1_0._gamepad_style_active then
		arg_1_0:_setup_gamepad_gui()
		arg_1_0:disable_player_world()
	end

	arg_1_0:_initial_windows_setups(var_1_1)
	arg_1_0:_calculate_current_weave()

	arg_1_0._input_paused = false

	Managers.state.event:trigger("tutorial_trigger", "start_game_menu_opened")
end

StartGameStateSettingsOverview._calculate_current_weave = function (arg_2_0)
	local var_2_0 = false
	local var_2_1 = WeaveSettings.templates_ordered
	local var_2_2 = #var_2_1
	local var_2_3 = Managers.player:statistics_db()
	local var_2_4 = Managers.player:local_player():stats_id()
	local var_2_5 = 1
	local var_2_6 = false

	for iter_2_0 = 1, var_2_2 do
		local var_2_7 = var_2_1[iter_2_0]
		local var_2_8 = LevelUnlockUtils.weave_unlocked(var_2_3, var_2_4, var_2_7.name, var_2_0)

		if (var_2_8 or var_2_5 == iter_2_0) and not LevelUnlockUtils.weave_disabled(var_2_7.name) then
			if var_2_8 and not var_2_6 then
				if var_2_1[iter_2_0 + 1] then
					var_2_5 = iter_2_0 + 1
				end
			else
				var_2_6 = true
			end
		end
	end

	arg_2_0._next_weave = (var_2_5 and var_2_1[var_2_5] or var_2_1[1]).name

	if not arg_2_0._selected_weave_id then
		arg_2_0:set_selected_weave_id(arg_2_0._next_weave)
		arg_2_0:set_selected_weave_objective_index(1)
	end
end

StartGameStateSettingsOverview._setup_menu_layout = function (arg_3_0, arg_3_1)
	local var_3_0
	local var_3_1 = IS_CONSOLE or Managers.input:is_device_active("gamepad") or not UISettings.use_pc_menu_layout or MechanismSettings[arg_3_1].use_gamepad_layout

	if var_3_1 then
		var_3_0 = local_require("scripts/ui/views/start_game_view/states/start_game_window_layout_console")
	else
		var_3_0 = local_require("scripts/ui/views/start_game_view/states/start_game_window_layout")
	end

	arg_3_0._generic_input_actions = var_3_0.generic_input_actions
	arg_3_0._video_resources = var_3_0.video_resources
	arg_3_0._windows_settings = var_3_0.windows
	arg_3_0._max_active_windows = var_3_0.max_active_windows
	arg_3_0._max_alignment_windows = var_3_0.max_alignment_windows
	arg_3_0._gamepad_style_active = var_3_1
	arg_3_0._layout_settings = var_3_0
	arg_3_0._window_layouts = var_3_0.window_layouts
	arg_3_0._mechanism_quickplay_settings = var_3_0.mechanism_quickplay_settings
	arg_3_0._mechanism_custom_game_settings = var_3_0.mechanism_custom_game_settings
	arg_3_0._mechanism_twitch_settings = var_3_0.mechanism_twitch_settings
	arg_3_0._save_data_table_maps = var_3_0.save_data_table_maps
end

StartGameStateSettingsOverview._create_ui_elements = function (arg_4_0, arg_4_1)
	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		if iter_4_1 then
			local var_4_2 = UIWidget.init(iter_4_1)

			var_4_0[#var_4_0 + 1] = var_4_2
			var_4_1[iter_4_0] = var_4_2
		end
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_3)

	local var_4_3 = UILayer.default + 30
	local var_4_4 = arg_4_0:input_service()
	local var_4_5 = arg_4_0._gamepad_style_active

	if arg_4_0._generic_input_actions then
		arg_4_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_4_0._ui_top_renderer, var_4_4, 8, var_4_3, arg_4_0._generic_input_actions.default, var_4_5)

		arg_4_0._menu_input_description:set_input_description(nil)
	end

	arg_4_0:_create_video_players()
end

StartGameStateSettingsOverview._create_hdr_gui = function (arg_5_0)
	local var_5_0 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_5_1 = 800
	local var_5_2 = "start_game_menu_hdr_view"
	local var_5_3 = "start_game_menu_hdr_view"
	local var_5_4 = "environment/ui_hdr"
	local var_5_5 = Managers.world:create_world(var_5_2, var_5_4, nil, var_5_1, unpack(var_5_0))
	local var_5_6 = "overlay"
	local var_5_7 = ScriptWorld.create_viewport(var_5_5, var_5_3, var_5_6, var_5_1)

	arg_5_0._ui_hdr_viewport_name = var_5_3
	arg_5_0._ui_hdr_world_name = var_5_2
	arg_5_0._ui_hdr_world = var_5_5
	arg_5_0._ui_hdr_renderer = arg_5_0._ingame_ui:create_ui_renderer(var_5_5, false, arg_5_0._is_in_inn)
end

StartGameStateSettingsOverview.hdr_renderer = function (arg_6_0)
	return arg_6_0._ui_hdr_renderer
end

StartGameStateSettingsOverview.ui_renderer = function (arg_7_0)
	if arg_7_0._gamepad_style_active then
		return arg_7_0._gui_data.bottom.renderer
	else
		return arg_7_0.ui_renderer
	end
end

StartGameStateSettingsOverview._create_video_players = function (arg_8_0)
	arg_8_0:_destroy_video_players()

	local var_8_0 = {}

	if arg_8_0._video_resources then
		local var_8_1 = arg_8_0._ui_top_renderer.world

		for iter_8_0, iter_8_1 in pairs(arg_8_0._video_resources) do
			local var_8_2 = iter_8_1.resource

			var_8_0[iter_8_0] = World.create_video_player(var_8_1, var_8_2, true, false)
		end
	end

	arg_8_0._video_players = var_8_0
end

StartGameStateSettingsOverview._destroy_video_players = function (arg_9_0)
	local var_9_0 = arg_9_0._video_players

	if var_9_0 then
		local var_9_1 = arg_9_0._ui_top_renderer.world

		for iter_9_0, iter_9_1 in pairs(var_9_0) do
			World.destroy_video_player(var_9_1, iter_9_1)
		end
	end

	arg_9_0._video_players = nil
end

StartGameStateSettingsOverview.get_video_player_by_name = function (arg_10_0, arg_10_1)
	return arg_10_0._video_players[arg_10_1]
end

StartGameStateSettingsOverview._setup_gamepad_gui = function (arg_11_0)
	if arg_11_0._is_in_inn then
		local var_11_0 = {}
		local var_11_1 = "start_weave_gamepad"
		local var_11_2, var_11_3, var_11_4 = arg_11_0:_setup_gamepad_renderer(var_11_1, 1, GameSettingsDevelopment.default_environment)

		var_11_0.bottom = {
			renderer = var_11_2,
			world = var_11_3,
			viewport_name = var_11_4
		}
		arg_11_0._gui_data = var_11_0
	end
end

StartGameStateSettingsOverview._setup_gamepad_renderer = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_12_1 = arg_12_1
	local var_12_2 = arg_12_1
	local var_12_3 = Managers.world:create_world(var_12_1, arg_12_3, nil, arg_12_2, unpack(var_12_0))
	local var_12_4 = "overlay"
	local var_12_5 = ScriptWorld.create_viewport(var_12_3, var_12_2, var_12_4, 999)

	return arg_12_0._ingame_ui:create_ui_renderer(var_12_3, false, arg_12_0._is_in_inn), var_12_3, var_12_2
end

StartGameStateSettingsOverview._destroy_gamepad_gui = function (arg_13_0)
	local var_13_0 = arg_13_0._gui_data

	if var_13_0 then
		for iter_13_0, iter_13_1 in pairs(var_13_0) do
			local var_13_1 = iter_13_1.renderer
			local var_13_2 = iter_13_1.world
			local var_13_3 = iter_13_1.viewport_name

			UIRenderer.destroy(var_13_1, var_13_2)
			ScriptWorld.destroy_viewport(var_13_2, var_13_3)
			Managers.world:destroy_world(var_13_2)
		end

		arg_13_0._gui_data = nil
	end
end

StartGameStateSettingsOverview.disable_player_world = function (arg_14_0)
	if not arg_14_0._player_world_disabled then
		arg_14_0._player_world_disabled = true

		local var_14_0 = "player_1"
		local var_14_1 = Managers.world:world("level_world")
		local var_14_2 = ScriptWorld.viewport(var_14_1, var_14_0)

		ScriptWorld.deactivate_viewport(var_14_1, var_14_2)
	end
end

StartGameStateSettingsOverview.enable_player_world = function (arg_15_0)
	if arg_15_0._player_world_disabled then
		arg_15_0._player_world_disabled = false

		local var_15_0 = "player_1"
		local var_15_1 = Managers.world:world("level_world")
		local var_15_2 = ScriptWorld.viewport(var_15_1, var_15_0)

		ScriptWorld.activate_viewport(var_15_1, var_15_2)
	end
end

StartGameStateSettingsOverview._start_layout_name = function (arg_16_0)
	local var_16_0 = PlayerData.mission_selection.start_layout
	local var_16_1 = arg_16_0:get_layout_setting_by_name(var_16_0)

	if var_16_1 and arg_16_0:can_add_layout(var_16_1) then
		return var_16_0
	else
		return arg_16_0:_get_first_game_mode_option_layout()
	end
end

StartGameStateSettingsOverview.can_add_layout = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.can_add_function

	return var_17_0 and var_17_0(arg_17_0)
end

StartGameStateSettingsOverview._initial_windows_setups = function (arg_18_0, arg_18_1)
	arg_18_0._active_windows = {}
	arg_18_0._window_params = arg_18_1

	local var_18_0
	local var_18_1 = Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and (Managers.mechanism:current_mechanism_name() == "deus" and "deus_twitch" or "twitch") or arg_18_1.start_state or arg_18_0:_start_layout_name()

	arg_18_0:set_layout_by_name(var_18_1)
	arg_18_0:set_top_level_layout_name(var_18_1)
end

StartGameStateSettingsOverview.window_input_service = function (arg_19_0)
	return arg_19_0._show_difficulty_option and FAKE_INPUT_SERVICE or arg_19_0:input_service()
end

StartGameStateSettingsOverview._close_window_at_index = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._active_windows
	local var_20_1 = arg_20_0._window_params
	local var_20_2 = var_20_0[arg_20_1]

	if var_20_2 and var_20_2.on_exit then
		var_20_2:on_exit(var_20_1)
	end

	var_20_0[arg_20_1] = nil
end

StartGameStateSettingsOverview._change_window = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._active_windows
	local var_21_1 = arg_21_0._windows_settings[arg_21_2]
	local var_21_2 = var_21_1.class_name
	local var_21_3 = var_21_0[arg_21_1]

	if var_21_3 then
		if var_21_3.NAME == var_21_2 then
			return
		end

		arg_21_0:_close_window_at_index(arg_21_1)
	end

	local var_21_4 = rawget(_G, var_21_2):new()
	local var_21_5 = var_21_1.ignore_alignment
	local var_21_6 = var_21_1.parent_window_name
	local var_21_7

	if not var_21_5 then
		local var_21_8 = UISettings.game_start_windows
		local var_21_9 = var_21_8.size
		local var_21_10 = var_21_8.spacing or 10
		local var_21_11 = var_21_9[1]
		local var_21_12 = arg_21_0._max_alignment_windows or arg_21_0._max_active_windows
		local var_21_13 = var_21_10 * (var_21_12 - 1)
		local var_21_14 = -(var_21_12 * var_21_11 / 2 + var_21_11 / 2) - (var_21_13 / 2 + var_21_10) + arg_21_1 * var_21_11 + arg_21_1 * var_21_10

		var_21_7 = {
			var_21_14,
			0,
			3
		}
	end

	if var_21_4.on_enter then
		local var_21_15 = arg_21_0._window_params

		var_21_4:on_enter(var_21_15, var_21_7, var_21_6)
	end

	var_21_0[arg_21_1] = var_21_4
end

StartGameStateSettingsOverview._set_new_save_data_table = function (arg_22_0, arg_22_1)
	if arg_22_1 then
		local var_22_0 = PlayerData.mission_selection
		local var_22_1 = var_22_0[arg_22_1]

		if not var_22_1 or not arg_22_0:_validate_mission_save_data(var_22_1) then
			var_22_0[arg_22_1] = {}
		end

		local var_22_2 = var_22_0[arg_22_1]

		arg_22_0._layout_save_settings = var_22_2

		arg_22_0:set_private_option_enabled(var_22_2.is_private)
		arg_22_0:set_always_host_option_enabled(var_22_2.always_host)
		arg_22_0:set_strict_matchmaking_option_enabled(var_22_2.use_strict_matchmaking)
		arg_22_0:set_selected_level_id(var_22_2.level_id)
		arg_22_0:set_difficulty_option(var_22_2.difficulty_key)
		arg_22_0:set_selected_weave_id(var_22_2.weave_id)
		arg_22_0:set_dedicated_or_player_hosted_search(var_22_2.use_dedicated_win_servers, var_22_2.use_dedicated_aws_servers, var_22_2.use_player_hosted)
	else
		arg_22_0._layout_save_settings = nil
	end
end

StartGameStateSettingsOverview._validate_mission_save_data = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1 and arg_23_1.level_id

	if not var_23_0 then
		return true
	elseif not rawget(LevelSettings, var_23_0) then
		return false
	end

	local var_23_1 = arg_23_0._stats_id
	local var_23_2 = arg_23_0._statistics_db

	return LevelUnlockUtils.level_unlocked(var_23_2, var_23_1, var_23_0)
end

StartGameStateSettingsOverview.close_on_exit = function (arg_24_0)
	return arg_24_0._close_on_exit
end

StartGameStateSettingsOverview.set_hide_panel_title_butttons = function (arg_25_0, arg_25_1)
	arg_25_0._panel_title_buttons_hidden = arg_25_1
end

StartGameStateSettingsOverview.panel_title_buttons_hidden = function (arg_26_0)
	return arg_26_0._panel_title_buttons_hidden
end

StartGameStateSettingsOverview.get_current_window_layout_settings = function (arg_27_0)
	for iter_27_0, iter_27_1 in ipairs(arg_27_0._window_layouts) do
		if iter_27_1.name == arg_27_0._selected_layout_name then
			return iter_27_1
		end
	end
end

StartGameStateSettingsOverview.set_layout_by_name = function (arg_28_0, arg_28_1)
	printf("[StartGameStateSettingsOverview]:set_layout_by_name() - %s", arg_28_1)

	local var_28_0 = table.find_by_key(arg_28_0._window_layouts, "name", arg_28_1)

	if not var_28_0 then
		ferror("[StartGameStateSettingsOverview]:set_layout_by_name() - Could not find a layout with name %s. Layouts: (%s)", arg_28_1, table.concat(table.select_array(arg_28_0._window_layouts, function (arg_29_0, arg_29_1)
			return arg_29_1.name
		end), ", "))
	end

	arg_28_0:set_layout(var_28_0)
end

StartGameStateSettingsOverview.get_mechanism_name = function (arg_30_0)
	return arg_30_0._mechanism_name
end

StartGameStateSettingsOverview.is_in_mechanism = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.parent:on_enter_sub_state() == "weave_quickplay"

	if arg_31_1 == "weave" then
		return arg_31_0._mechanism_name == "adventure" and var_31_0
	else
		return arg_31_0._mechanism_name == arg_31_1 and not var_31_0
	end
end

StartGameStateSettingsOverview.is_weekly_event_active = function (arg_32_0)
	return Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data() ~= nil
end

StartGameStateSettingsOverview.get_quickplay_settings = function (arg_33_0, arg_33_1)
	return arg_33_0._mechanism_quickplay_settings[arg_33_1 or arg_33_0._mechanism_name]
end

StartGameStateSettingsOverview.get_custom_game_settings = function (arg_34_0, arg_34_1)
	return arg_34_0._mechanism_custom_game_settings[arg_34_1 or arg_34_0._mechanism_name]
end

StartGameStateSettingsOverview.get_twitch_settings = function (arg_35_0, arg_35_1)
	return arg_35_0._mechanism_twitch_settings[arg_35_1 or arg_35_0._mechanism_name]
end

StartGameStateSettingsOverview.get_save_data_table_map = function (arg_36_0, arg_36_1)
	return arg_36_0._save_data_table_maps[arg_36_1 or arg_36_0._mechanism_name]
end

StartGameStateSettingsOverview.set_layout = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0:get_layout_setting(arg_37_1)
	local var_37_1 = var_37_0.sound_event_enter

	if var_37_1 then
		arg_37_0:play_sound(var_37_1)
	end

	local var_37_2 = var_37_0.save_data_table
	local var_37_3 = arg_37_0:get_save_data_table_map(arg_37_0._mechanism_name) or arg_37_0:get_quickplay_settings("adventure")

	var_37_2 = var_37_3 and var_37_3[var_37_2] or var_37_2

	arg_37_0:_set_new_save_data_table(var_37_2)

	local var_37_4 = var_37_0.close_on_exit
	local var_37_5 = var_37_0.reset_on_exit
	local var_37_6 = arg_37_0._widgets_by_name.exit_button.content

	if var_37_5 then
		-- Nothing
	end

	var_37_6.visible = var_37_4
	arg_37_0._widgets_by_name.back_button.content.visible = var_37_5 or not var_37_4
	arg_37_0._close_on_exit = var_37_4
	arg_37_0._reset_on_exit = var_37_5

	local var_37_7 = var_37_0.windows
	local var_37_8 = arg_37_0._max_active_windows

	for iter_37_0 = 1, var_37_8 do
		local var_37_9 = false

		for iter_37_1, iter_37_2 in pairs(var_37_7) do
			if iter_37_2 == iter_37_0 then
				arg_37_0:_change_window(iter_37_2, iter_37_1)

				var_37_9 = true
			end
		end

		if not var_37_9 then
			arg_37_0:_close_window_at_index(iter_37_0)
		end
	end

	local var_37_10 = var_37_0.name

	if var_37_0.game_mode_option then
		if arg_37_0._selected_game_mode_layout_name then
			arg_37_0._previous_selected_game_mode_layout_name = arg_37_0._selected_game_mode_layout_name
		end

		arg_37_0._selected_game_mode_layout_name = var_37_10
	end

	if arg_37_0._selected_layout_name then
		arg_37_0._previous_selected_layout_name = arg_37_0._selected_layout_name
	end

	arg_37_0._selected_layout_name = var_37_10

	local var_37_11 = var_37_0.input_focus_window

	arg_37_0:set_window_input_focus(var_37_11)
end

StartGameStateSettingsOverview.set_window_input_focus = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._windows_settings[arg_38_1]
	local var_38_1 = var_38_0 and var_38_0.class_name
	local var_38_2 = false
	local var_38_3 = arg_38_0._active_windows

	for iter_38_0, iter_38_1 in pairs(var_38_3) do
		local var_38_4 = iter_38_1.NAME == var_38_1

		if iter_38_1.set_focus then
			iter_38_1:set_focus(var_38_4)
		end

		if var_38_4 then
			var_38_2 = true
		end
	end

	if arg_38_1 and not var_38_2 then
		ferror("[StartGameStateSettingsOverview] - (set_window_input_focus) Could not find a window by name: %s", arg_38_1)
	end

	arg_38_0._window_focused = arg_38_1
end

StartGameStateSettingsOverview.set_top_level_layout_name = function (arg_39_0, arg_39_1)
	arg_39_0._top_level_layout_name = arg_39_1
end

StartGameStateSettingsOverview.get_top_level_layout_name = function (arg_40_0)
	return arg_40_0._top_level_layout_name
end

StartGameStateSettingsOverview.get_selected_game_mode_layout_name = function (arg_41_0)
	return arg_41_0._selected_game_mode_layout_name
end

StartGameStateSettingsOverview.get_previous_selected_game_mode_layout_name = function (arg_42_0)
	return arg_42_0._previous_selected_game_mode_layout_name
end

StartGameStateSettingsOverview.get_selected_layout_name = function (arg_43_0)
	return arg_43_0._selected_layout_name
end

StartGameStateSettingsOverview.get_previous_selected_layout_name = function (arg_44_0)
	return arg_44_0._previous_selected_layout_name
end

StartGameStateSettingsOverview.get_layout_setting = function (arg_45_0, arg_45_1)
	return arg_45_0._window_layouts[arg_45_1]
end

StartGameStateSettingsOverview.get_layout_setting_by_name = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._window_layouts

	for iter_46_0 = 1, #var_46_0 do
		local var_46_1 = var_46_0[iter_46_0]

		if arg_46_1 == var_46_1.name then
			return var_46_1
		end
	end
end

StartGameStateSettingsOverview._get_first_game_mode_option_layout = function (arg_47_0)
	local var_47_0 = arg_47_0._window_layouts

	for iter_47_0 = 1, #var_47_0 do
		local var_47_1 = var_47_0[iter_47_0]

		if arg_47_0:can_add_layout(var_47_1) then
			return var_47_1.name, var_47_1
		end
	end
end

StartGameStateSettingsOverview._windows_update = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0._active_windows

	for iter_48_0, iter_48_1 in pairs(var_48_0) do
		iter_48_1:update(arg_48_1, arg_48_2)
	end
end

StartGameStateSettingsOverview._windows_post_update = function (arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._active_windows

	for iter_49_0, iter_49_1 in pairs(var_49_0) do
		iter_49_1:post_update(arg_49_1, arg_49_2)
	end
end

StartGameStateSettingsOverview.enable_widget = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = arg_50_0._active_windows[arg_50_1]._widgets_by_name[arg_50_2]

	if var_50_0 then
		local var_50_1 = var_50_0.content.button_hotspot

		if var_50_1 then
			var_50_1.disable_button = not arg_50_3
		end
	end
end

StartGameStateSettingsOverview.disable_input = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0._active_windows

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if iter_51_1.disable_input and iter_51_1:disable_input(arg_51_1) then
			return true
		end
	end
end

StartGameStateSettingsOverview.transitioning = function (arg_52_0)
	if arg_52_0.exiting then
		return true
	else
		return false
	end
end

StartGameStateSettingsOverview._wanted_state = function (arg_53_0)
	return (arg_53_0.parent:wanted_state())
end

StartGameStateSettingsOverview.wanted_menu_state = function (arg_54_0)
	return arg_54_0._wanted_menu_state
end

StartGameStateSettingsOverview.clear_wanted_menu_state = function (arg_55_0)
	arg_55_0._wanted_menu_state = nil
end

StartGameStateSettingsOverview.on_exit = function (arg_56_0, arg_56_1)
	print("[StartGameState] Exit Substate StartGameStateSettingsOverview")

	arg_56_0.ui_animator = nil
	arg_56_0._is_open = false

	if arg_56_0._fullscreen_effect_enabled then
		arg_56_0:set_fullscreen_effect_enable_state(false)
	end

	Managers.save:auto_save(SaveFileName, SaveData, nil)
	arg_56_0:_close_active_windows()
	arg_56_0:_destroy_video_players()

	if arg_56_0._gamepad_style_active then
		arg_56_0:_destroy_gamepad_gui()
		arg_56_0:enable_player_world()
	end

	arg_56_0:_reset_cloned_materials()

	if arg_56_0._ui_hdr_renderer then
		UIRenderer.destroy(arg_56_0._ui_hdr_renderer, arg_56_0._ui_hdr_world)

		arg_56_0._ui_hdr_renderer = nil
	end

	if arg_56_0._ui_hdr_world then
		ScriptWorld.destroy_viewport(arg_56_0._ui_hdr_world, arg_56_0._ui_hdr_viewport_name)
		Managers.world:destroy_world(arg_56_0._ui_hdr_world)

		arg_56_0._ui_hdr_viewport_name = nil
		arg_56_0._ui_hdr_world_name = nil
		arg_56_0._ui_hdr_world = nil
	end
end

StartGameStateSettingsOverview._close_active_windows = function (arg_57_0)
	local var_57_0 = arg_57_0._active_windows
	local var_57_1 = arg_57_0._window_params

	for iter_57_0, iter_57_1 in pairs(var_57_0) do
		if iter_57_1.on_exit then
			iter_57_1:on_exit(var_57_1)
		end
	end

	table.clear(var_57_0)
end

StartGameStateSettingsOverview._update_transition_timer = function (arg_58_0, arg_58_1)
	if not arg_58_0._transition_timer then
		return
	end

	if arg_58_0._transition_timer == 0 then
		arg_58_0._transition_timer = nil
	else
		arg_58_0._transition_timer = math.max(arg_58_0._transition_timer - arg_58_1, 0)
	end
end

StartGameStateSettingsOverview.input_service = function (arg_59_0)
	return arg_59_0.parent:input_service()
end

StartGameStateSettingsOverview.update = function (arg_60_0, arg_60_1, arg_60_2)
	if var_0_4 then
		var_0_4 = false

		arg_60_0:_create_ui_elements()
	end

	if Managers.matchmaking:is_in_versus_custom_game_lobby() and not Managers.mechanism:network_handler():get_match_handler():query_peer_data(Network.peer_id(), "is_match_owner") then
		local var_60_0 = arg_60_0._selected_layout_name
		local var_60_1 = "versus_player_hosted_lobby"

		if var_60_0 ~= var_60_1 then
			arg_60_0:set_layout_by_name(var_60_1)
		end
	end

	local var_60_2 = arg_60_0._input_manager
	local var_60_3 = arg_60_0.parent:input_service()

	arg_60_0:draw(var_60_3, arg_60_1)
	arg_60_0:_update_transition_timer(arg_60_1)

	if not arg_60_0._show_difficulty_option then
		arg_60_0:_windows_update(arg_60_1, arg_60_2)
	end

	local var_60_4 = arg_60_0:_wanted_state()

	if not arg_60_0._transition_timer and (var_60_4 or arg_60_0._new_state) then
		arg_60_0.parent:clear_wanted_state()

		return var_60_4 or arg_60_0._new_state
	end
end

StartGameStateSettingsOverview.post_update = function (arg_61_0, arg_61_1, arg_61_2)
	arg_61_0.ui_animator:update(arg_61_1)
	arg_61_0:_update_animations(arg_61_1)

	if not arg_61_0.parent:transitioning() and not arg_61_0._transition_timer and not arg_61_0:input_paused() then
		arg_61_0:_handle_input(arg_61_1, arg_61_2)
	end

	arg_61_0:_windows_post_update(arg_61_1, arg_61_2)
end

StartGameStateSettingsOverview._update_animations = function (arg_62_0, arg_62_1)
	for iter_62_0, iter_62_1 in pairs(arg_62_0._ui_animations) do
		UIAnimation.update(iter_62_1, arg_62_1)

		if UIAnimation.completed(iter_62_1) then
			arg_62_0._ui_animations[iter_62_0] = nil
		end
	end

	local var_62_0 = arg_62_0._animations
	local var_62_1 = arg_62_0.ui_animator

	for iter_62_2, iter_62_3 in pairs(var_62_0) do
		if var_62_1:is_animation_completed(iter_62_3) then
			var_62_1:stop_animation(iter_62_3)

			var_62_0[iter_62_2] = nil
		end
	end
end

StartGameStateSettingsOverview._is_button_hover_enter = function (arg_63_0, arg_63_1)
	return arg_63_1.content.button_hotspot.on_hover_enter
end

StartGameStateSettingsOverview._handle_input = function (arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = arg_64_0._widgets_by_name
	local var_64_1 = arg_64_0.parent:input_service()
	local var_64_2 = var_64_1:get("toggle_menu", true)
	local var_64_3 = Managers.input:is_device_active("gamepad") and var_64_1:get("back_menu", true)
	local var_64_4 = arg_64_0._close_on_exit
	local var_64_5 = arg_64_0._reset_on_exit
	local var_64_6 = var_64_0.back_button
	local var_64_7 = var_64_0.exit_button

	UIWidgetUtils.animate_default_button(var_64_6, arg_64_1)
	UIWidgetUtils.animate_default_button(var_64_7, arg_64_1)

	if arg_64_0:_is_button_hover_enter(var_64_6) or arg_64_0:_is_button_hover_enter(var_64_7) then
		arg_64_0:play_sound("play_gui_equipment_button_hover")
	end

	if var_64_5 and (var_64_2 or var_64_3 or arg_64_0:_is_button_pressed(var_64_6)) then
		arg_64_0:play_sound("play_gui_lobby_back")

		local var_64_8 = arg_64_0:_start_layout_name()

		arg_64_0:set_layout_by_name(var_64_8)
	elseif var_64_4 and (var_64_3 or var_64_2 or arg_64_0:_is_button_pressed(var_64_7)) then
		arg_64_0:close_menu()

		return
	elseif var_64_2 or var_64_3 or arg_64_0:_is_button_pressed(var_64_6) then
		arg_64_0:play_sound("Play_hud_select")

		local var_64_9
		local var_64_10 = arg_64_0._window_params

		if var_64_10 then
			var_64_9 = var_64_10.return_layout_name
			var_64_10.return_layout_name = nil
		end

		if not var_64_9 then
			if arg_64_0:get_layout_setting_by_name(arg_64_0._selected_layout_name).return_to_top_level then
				var_64_9 = arg_64_0:get_top_level_layout_name() or arg_64_0:get_previous_selected_layout_name()
			else
				var_64_9 = arg_64_0:get_previous_selected_layout_name()
			end
		end

		if var_64_9 then
			arg_64_0:set_layout_by_name(var_64_9)
		end
	end
end

StartGameStateSettingsOverview.pause_input = function (arg_65_0, arg_65_1)
	arg_65_0._input_paused = arg_65_1
end

StartGameStateSettingsOverview.input_paused = function (arg_66_0)
	return arg_66_0._input_paused
end

StartGameStateSettingsOverview.close_menu = function (arg_67_0, arg_67_1)
	arg_67_0.parent:close_menu(nil, arg_67_1)
end

StartGameStateSettingsOverview.cancel_matchmaking = function (arg_68_0)
	arg_68_0.parent:cancel_matchmaking()
end

local var_0_6 = {}

StartGameStateSettingsOverview.play = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	printf("[StartGameStateSettingsOverview:play() - vote_type(%s)", arg_69_2)

	local var_69_0 = Managers.account:offline_mode()

	if arg_69_2 == "adventure_mode" then
		local var_69_1 = arg_69_0:get_selected_level_id()
		local var_69_2 = arg_69_0._selected_difficulty_key
		local var_69_3 = true
		local var_69_4 = false
		local var_69_5 = true
		local var_69_6 = false
		local var_69_7
		local var_69_8

		arg_69_0.parent:start_game(var_69_1, var_69_2, var_69_3, var_69_4, var_69_5, var_69_6, arg_69_1, matchmaking_type, var_69_7, var_69_8)
	elseif arg_69_2 == "adventure" then
		local var_69_9 = {
			mechanism = "adventure",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = arg_69_0._selected_difficulty_key,
			private_game = var_69_0,
			always_host = var_69_0,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_9)
	elseif arg_69_2 == "weave_quick_play" then
		local var_69_10 = {
			private_game = false,
			mechanism = "weave",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = arg_69_0._selected_difficulty_key,
			always_host = var_69_0,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_10)
	elseif arg_69_2 == "custom" then
		local var_69_11 = arg_69_0._network_lobby
		local var_69_12 = var_69_11:members():get_member_count()
		local var_69_13 = arg_69_0:is_private_option_enabled()

		var_69_13 = IS_CONSOLE and var_69_0 or var_69_13

		local var_69_14 = var_69_12 == 1
		local var_69_15 = var_69_13 or arg_69_0:is_always_host_option_enabled()
		local var_69_16 = {
			mechanism = "adventure",
			matchmaking_type = "custom",
			quick_game = false,
			network_lobby = var_69_11,
			num_members = var_69_12,
			is_alone = var_69_14,
			mission_id = arg_69_0:get_selected_level_id(),
			difficulty = arg_69_0._selected_difficulty_key,
			private_game = var_69_13,
			always_host = var_69_15,
			strict_matchmaking = var_69_14 and not var_69_13 and not var_69_15 and arg_69_0:is_strict_matchmaking_option_enabled(),
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_16)
	elseif arg_69_2 == "deed" then
		local var_69_17 = {
			is_private = true,
			mechanism = "adventure",
			quick_game = false,
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "deed",
			deed_backend_id = arg_69_0:get_selected_heroic_deed_backend_id(),
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_17)
	elseif arg_69_2 == "twitch" then
		local var_69_18 = {
			private_game = true,
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "custom",
			mechanism = "adventure",
			quick_game = false,
			twitch_enabled = true,
			mission_id = arg_69_0:get_selected_level_id(),
			difficulty = arg_69_0._selected_difficulty_key,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_18)
	elseif arg_69_2 == "event" then
		local var_69_19 = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
		local var_69_20

		if var_69_19.mutators then
			var_69_20 = {
				mutators = var_69_19.mutators
			}
		end

		local var_69_21 = {
			private_game = false,
			strict_matchmaking = false,
			always_host = false,
			matchmaking_type = "event",
			mechanism = "adventure",
			quick_game = false,
			mission_id = var_69_19.level_key,
			difficulty = arg_69_0._selected_difficulty_key,
			event_data = var_69_20,
			excluded_level_keys = var_69_19.excluded_level_keys,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_21)
	elseif arg_69_2 == "versus_quickplay" then
		local var_69_22 = {
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

		arg_69_0.parent:start_game(var_69_22)
	elseif arg_69_2 == "versus_custom" then
		local var_69_23 = arg_69_0:is_private_option_enabled()
		local var_69_24 = arg_69_0:get_selected_level_id()
		local var_69_25 = {
			player_hosted = true,
			dedicated_servers_win = false,
			dedicated_servers_aws = false,
			matchmaking_type = "custom",
			mechanism = "versus",
			quick_game = false,
			difficulty = "versus_base",
			join_method = "party",
			mission_id = var_69_24,
			any_level = not var_69_24,
			private_game = var_69_23,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_25)
	elseif arg_69_2 == "weave" then
		local var_69_26 = arg_69_0:get_selected_weave_id()
		local var_69_27 = WeaveSettings.templates[var_69_26].difficulty_key
		local var_69_28 = arg_69_0:get_selected_weave_objective_index()
		local var_69_29 = arg_69_0:is_private_option_enabled()
		local var_69_30 = var_69_0
		local var_69_31 = {
			matchmaking_type = "custom",
			mechanism = "weave",
			quick_game = false,
			mission_id = var_69_26,
			difficulty = var_69_27,
			objective_index = var_69_28,
			private_game = var_69_29,
			always_host = var_69_0,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_31)
	elseif arg_69_2 == "deus_custom" then
		local var_69_32 = arg_69_0._network_lobby:members():get_member_count() == 1
		local var_69_33 = var_69_0 or arg_69_0:is_private_option_enabled()
		local var_69_34 = var_69_33 or arg_69_0:is_always_host_option_enabled()
		local var_69_35 = Managers.backend:get_interface("deus"):get_journey_cycle()
		local var_69_36 = arg_69_0:get_selected_level_id()

		var_69_36 = DeusJourneySettings[var_69_36] and var_69_36 or AvailableJourneyOrder[1]

		local var_69_37 = var_69_35.journey_data[var_69_36].dominant_god
		local var_69_38 = {
			matchmaking_type = "custom",
			mechanism = "deus",
			quick_game = false,
			mission_id = var_69_36,
			difficulty = arg_69_0._selected_difficulty_key,
			private_game = var_69_33,
			always_host = var_69_34,
			strict_matchmaking = var_69_32 and not var_69_33 and not var_69_34 and arg_69_0:is_strict_matchmaking_option_enabled(),
			dominant_god = var_69_37,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_38)
	elseif arg_69_2 == "deus_twitch" then
		local var_69_39 = Managers.backend:get_interface("deus"):get_journey_cycle()
		local var_69_40 = arg_69_0:get_selected_level_id()

		var_69_40 = DeusJourneySettings[var_69_40] and var_69_40 or AvailableJourneyOrder[1]

		local var_69_41 = var_69_39.journey_data[var_69_40].dominant_god
		local var_69_42 = {
			private_game = true,
			mechanism = "deus",
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "custom",
			quick_game = false,
			twitch_enabled = true,
			mission_id = var_69_40,
			difficulty = arg_69_0._selected_difficulty_key,
			dominant_god = var_69_41,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_42)
	elseif arg_69_2 == "deus_quickplay" then
		local var_69_43 = {
			mechanism = "deus",
			quick_game = true,
			strict_matchmaking = false,
			matchmaking_type = "standard",
			difficulty = arg_69_0._selected_difficulty_key,
			private_game = var_69_0,
			always_host = var_69_0,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_43)
	elseif arg_69_2 == "deus_weekly" then
		local var_69_44 = Managers.backend:get_interface("live_events"):get_weekly_chaos_wastes_game_mode_data() or var_0_6
		local var_69_45

		if var_69_44.mutators then
			var_69_45 = var_69_45 or {}
			var_69_45.mutators = var_69_44.mutators
		end

		if var_69_44.boons then
			var_69_45 = var_69_45 or {}
			var_69_45.boons = var_69_44.boons
		end

		local var_69_46 = var_69_44.journey_name
		local var_69_47 = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data[var_69_46].dominant_god
		local var_69_48 = {
			private_game = false,
			strict_matchmaking = false,
			always_host = false,
			matchmaking_type = "event",
			mechanism = "deus",
			quick_game = false,
			mission_id = var_69_46,
			difficulty = arg_69_0._selected_difficulty_key,
			dominant_god = var_69_47,
			event_data = var_69_45,
			excluded_level_keys = var_69_44.excluded_level_keys,
			request_type = arg_69_2
		}

		arg_69_0.parent:start_game(var_69_48)
	else
		ferror("Unknown vote_type(%s)", arg_69_2)
	end
end

StartGameStateSettingsOverview.is_confirm_putton_pressed = function (arg_70_0)
	return false
end

StartGameStateSettingsOverview.set_input_description = function (arg_71_0, arg_71_1)
	if not arg_71_0._menu_input_description then
		return
	end

	fassert(not arg_71_1 or arg_71_0._generic_input_actions[arg_71_1], "[StartGameStateSettingsOverview:set_input_description] There is no such input_description (%s)", arg_71_1)
	arg_71_0._menu_input_description:set_input_description(arg_71_0._generic_input_actions[arg_71_1])
end

StartGameStateSettingsOverview.change_generic_actions = function (arg_72_0, arg_72_1)
	if not arg_72_0._menu_input_description then
		return
	end

	fassert(arg_72_0._generic_input_actions[arg_72_1], "[StartGameStateSettingsOverview:set_input_description] There is no such input_description (%s)", arg_72_1)
	arg_72_0._menu_input_description:change_generic_actions(arg_72_0._generic_input_actions[arg_72_1])
end

StartGameStateSettingsOverview.draw = function (arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = arg_73_0._ui_renderer
	local var_73_1 = arg_73_0._ui_top_renderer
	local var_73_2 = arg_73_0._ui_scenegraph
	local var_73_3 = arg_73_0._input_manager
	local var_73_4 = arg_73_0._render_settings

	if not arg_73_0._gamepad_style_active then
		UIRenderer.begin_pass(var_73_0, var_73_2, arg_73_1, arg_73_2, nil, var_73_4)

		local var_73_5 = var_73_4.snap_pixel_positions

		for iter_73_0, iter_73_1 in ipairs(arg_73_0._widgets) do
			if iter_73_1.snap_pixel_positions ~= nil then
				var_73_4.snap_pixel_positions = iter_73_1.snap_pixel_positions
			end

			UIRenderer.draw_widget(var_73_0, iter_73_1)

			var_73_4.snap_pixel_positions = var_73_5
		end

		UIRenderer.end_pass(var_73_0)
	end

	if var_73_3:is_device_active("gamepad") and arg_73_0._menu_input_description and not arg_73_0.parent:active_view() then
		arg_73_0._menu_input_description:draw(var_73_1, arg_73_2)
	end
end

StartGameStateSettingsOverview.draw_menu_input_description = function (arg_74_0, arg_74_1, arg_74_2)
	local var_74_0 = arg_74_0._ui_top_renderer

	arg_74_0._menu_input_description:draw(var_74_0, arg_74_2)
end

StartGameStateSettingsOverview._is_button_pressed = function (arg_75_0, arg_75_1)
	local var_75_0 = arg_75_1.content
	local var_75_1 = var_75_0.button_hotspot or var_75_0.hotspot

	if var_75_1.on_release then
		var_75_1.on_release = false

		return true
	end
end

StartGameStateSettingsOverview.play_sound = function (arg_76_0, arg_76_1)
	arg_76_0.parent:play_sound(arg_76_1)
end

StartGameStateSettingsOverview._start_transition_animation = function (arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = {
		wwise_world = arg_77_0._wwise_world,
		render_settings = arg_77_0._render_settings
	}
	local var_77_1 = {}
	local var_77_2 = arg_77_0.ui_animator:start_animation(arg_77_2, var_77_1, var_0_2, var_77_0)

	arg_77_0._animations[arg_77_1] = var_77_2
end

StartGameStateSettingsOverview.get_selected_weave_id = function (arg_78_0)
	return arg_78_0._selected_weave_id
end

StartGameStateSettingsOverview.get_selected_weave_objective_index = function (arg_79_0)
	return arg_79_0._selected_weave_objective_index
end

StartGameStateSettingsOverview.set_next_weave = function (arg_80_0)
	if arg_80_0._selected_weave_id ~= arg_80_0._next_weave then
		arg_80_0:set_selected_weave_id(arg_80_0._next_weave)
		arg_80_0:set_selected_weave_objective_index(1)
		arg_80_0:play_sound("play_gui_lobby_button_00_quickplay")
	end
end

StartGameStateSettingsOverview.set_selected_weave_id = function (arg_81_0, arg_81_1)
	if arg_81_0._layout_save_settings then
		arg_81_0._layout_save_settings.weave_id = arg_81_1
	end

	if arg_81_1 then
		arg_81_0._selected_weave_id = arg_81_1
	end
end

StartGameStateSettingsOverview.set_selected_weave_objective_index = function (arg_82_0, arg_82_1)
	arg_82_0._selected_weave_objective_index = arg_82_1
end

StartGameStateSettingsOverview.get_selected_heroic_deed_backend_id = function (arg_83_0)
	return arg_83_0._selected_heroic_deed_backend_id
end

StartGameStateSettingsOverview.set_selected_heroic_deed_backend_id = function (arg_84_0, arg_84_1)
	arg_84_0._selected_heroic_deed_backend_id = arg_84_1
end

StartGameStateSettingsOverview.get_selected_level_id = function (arg_85_0)
	local var_85_0 = true
	local var_85_1 = true
	local var_85_2 = arg_85_0._specific_level_id and LevelSettings[arg_85_0._specific_level_id]

	if var_85_2 and var_85_2.dlc_name then
		var_85_0 = Managers.unlock:is_dlc_unlocked(var_85_2.dlc_name)
	end

	local var_85_3 = arg_85_0:get_selected_area_name()

	if var_85_3 then
		local var_85_4 = AreaSettings[var_85_3]

		if var_85_4 and var_85_4.unlock_requirement_function then
			var_85_1 = var_85_4.unlock_requirement_function(arg_85_0._statistics_db, arg_85_0._stats_id)
		end
	end

	return var_85_0 and var_85_1 and arg_85_0._specific_level_id or nil
end

StartGameStateSettingsOverview.set_selected_level_id = function (arg_86_0, arg_86_1)
	if arg_86_0._layout_save_settings then
		arg_86_0._layout_save_settings.level_id = arg_86_1
	end

	arg_86_0._specific_level_id = arg_86_1
end

StartGameStateSettingsOverview.get_selected_area_name = function (arg_87_0)
	if arg_87_0._specific_area_name then
		local var_87_0 = arg_87_0._specific_area_name

		if AreaSettings[var_87_0] then
			return arg_87_0._specific_area_name
		end
	end

	if arg_87_0._layout_save_settings then
		local var_87_1 = arg_87_0._layout_save_settings.area_name

		if var_87_1 and AreaSettings[var_87_1] then
			return var_87_1
		end
	end

	return "helmgart"
end

StartGameStateSettingsOverview.set_selected_area_name = function (arg_88_0, arg_88_1)
	if arg_88_0._layout_save_settings then
		arg_88_0._layout_save_settings.area_name = arg_88_1
	end

	arg_88_0._specific_area_name = arg_88_1
end

StartGameStateSettingsOverview.show_difficulty_option = function (arg_89_0)
	arg_89_0._show_difficulty_option = true
end

StartGameStateSettingsOverview.hide_difficulty_option = function (arg_90_0)
	arg_90_0._show_difficulty_option = false
end

StartGameStateSettingsOverview.set_private_option_enabled = function (arg_91_0, arg_91_1)
	if arg_91_1 == nil then
		arg_91_1 = false
	end

	if arg_91_0._layout_save_settings then
		arg_91_0._layout_save_settings.is_private = arg_91_1
	end

	arg_91_0._is_game_private = arg_91_1
end

StartGameStateSettingsOverview.is_private_option_enabled = function (arg_92_0)
	return arg_92_0._is_game_private
end

StartGameStateSettingsOverview.set_always_host_option_enabled = function (arg_93_0, arg_93_1)
	if arg_93_1 == nil then
		arg_93_1 = false
	end

	if arg_93_0._layout_save_settings then
		arg_93_0._layout_save_settings.always_host = arg_93_1
	end

	arg_93_0._always_host = arg_93_1
end

StartGameStateSettingsOverview.is_always_host_option_enabled = function (arg_94_0)
	return arg_94_0._always_host
end

StartGameStateSettingsOverview.set_strict_matchmaking_option_enabled = function (arg_95_0, arg_95_1)
	if arg_95_1 == nil then
		arg_95_1 = true
	end

	if arg_95_0._layout_save_settings then
		arg_95_0._layout_save_settings.use_strict_matchmaking = arg_95_1
	end

	arg_95_0._use_strict_matchmaking = arg_95_1
end

StartGameStateSettingsOverview.is_strict_matchmaking_option_enabled = function (arg_96_0)
	return arg_96_0._use_strict_matchmaking
end

local var_0_7 = {}

StartGameStateSettingsOverview.is_difficulty_approved = function (arg_97_0, arg_97_1)
	if Development.parameter("unlock_all_difficulties") then
		return true
	end

	if script_data.disable_hero_power_requirement then
		return true
	end

	if not arg_97_1 then
		return false
	end

	local var_97_0 = true
	local var_97_1
	local var_97_2
	local var_97_3
	local var_97_4 = Managers.player:human_players()

	if not arg_97_0:is_private_option_enabled() and #DifficultyManager.players_below_required_power_level(arg_97_1, var_97_4) > 0 then
		var_97_0 = false
		var_97_3 = true
	end

	local var_97_5 = DifficultySettings[arg_97_1]

	if var_97_5.extra_requirement_name then
		local var_97_6 = var_97_4

		if Managers.state.network.is_server then
			var_0_7[1] = Managers.player:local_player()
			var_97_6 = var_0_7
		end

		if #DifficultyManager.players_locked_difficulty_rank(arg_97_1, var_97_6) > 0 then
			local var_97_7 = var_97_5.extra_requirement_name

			var_97_1 = ExtraDifficultyRequirements[var_97_7].description_text
			var_97_0 = false
		end
	end

	if var_97_5.dlc_requirement then
		local var_97_8 = Managers.mechanism:network_handler()

		if var_97_8 then
			local var_97_9 = false
			local var_97_10 = var_97_8:get_peers()

			for iter_97_0 = 1, #var_97_10 do
				local var_97_11 = var_97_10[iter_97_0]

				if var_97_8:is_network_state_fully_synced_for_peer(var_97_11) and var_97_8:has_unlocked_dlc(var_97_11, var_97_5.dlc_requirement) then
					var_97_9 = true
				end
			end

			if not var_97_9 then
				var_97_0 = false
				var_97_2 = var_97_5.dlc_requirement
			end
		end
	end

	return var_97_0, var_97_1, var_97_2, var_97_3
end

StartGameStateSettingsOverview.set_difficulty_option = function (arg_98_0, arg_98_1)
	if arg_98_0._layout_save_settings then
		arg_98_0._layout_save_settings.difficulty_key = arg_98_1
	end

	arg_98_0._selected_difficulty_key = arg_98_1
end

StartGameStateSettingsOverview.get_difficulty_option = function (arg_99_0, arg_99_1)
	local var_99_0 = Managers.mechanism:mechanism_setting("default_difficulty")
	local var_99_1 = arg_99_0._selected_difficulty_key

	for iter_99_0 = table.find(Difficulties, var_99_1) or table.index_of(Difficulties, var_99_0), 1, -1 do
		var_99_1 = Difficulties[iter_99_0]

		if arg_99_0:is_difficulty_approved(var_99_1) then
			break
		end
	end

	arg_99_0:set_difficulty_option(var_99_1)

	return var_99_1
end

StartGameStateSettingsOverview.set_dedicated_or_player_hosted_search = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	arg_100_0._use_dedicated_win_servers = arg_100_1 == nil and true or arg_100_1
	arg_100_0._use_dedicated_aws_servers = arg_100_2 == nil and true or arg_100_2
	arg_100_0._use_player_hosted = arg_100_3 == nil and true or arg_100_3

	if arg_100_0._layout_save_settings then
		arg_100_0._layout_save_settings.use_dedicated_win_servers = arg_100_1
		arg_100_0._layout_save_settings.use_dedicated_aws_servers = arg_100_2
		arg_100_0._layout_save_settings.use_player_hosted = arg_100_3
	end
end

StartGameStateSettingsOverview.using_player_hosted_search = function (arg_101_0)
	return arg_101_0._use_player_hosted
end

StartGameStateSettingsOverview.using_dedicated_servers_search = function (arg_102_0)
	return arg_102_0._use_dedicated_win_servers, arg_102_0._use_dedicated_aws_servers
end

StartGameStateSettingsOverview.set_play_button_enabled = function (arg_103_0, arg_103_1)
	return
end

StartGameStateSettingsOverview.set_confirm_button_visibility = function (arg_104_0, arg_104_1)
	return
end

StartGameStateSettingsOverview.set_fullscreen_effect_enable_state = function (arg_105_0, arg_105_1)
	local var_105_0 = arg_105_0._ui_renderer.world
	local var_105_1 = World.get_data(var_105_0, "shading_environment")

	if var_105_1 then
		ShadingEnvironment.set_scalar(var_105_1, "fullscreen_blur_enabled", arg_105_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_105_1, "fullscreen_blur_amount", arg_105_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_105_1)
	end

	arg_105_0._fullscreen_effect_enabled = arg_105_1
end

StartGameStateSettingsOverview.set_mutator_option = function (arg_106_0, arg_106_1)
	arg_106_0._selected_mutator_key = arg_106_1
end

StartGameStateSettingsOverview.get_mutator_option = function (arg_107_0)
	return arg_107_0._selected_mutator_key
end

StartGameStateSettingsOverview.get_completed_level_difficulty_index = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	local var_108_0 = (arg_108_0:get_custom_game_settings(arg_108_0._mechanism_name) or arg_108_0:get_custom_game_settings("adventure")).difficulty_index_getter_name

	return LevelUnlockUtils[var_108_0](arg_108_1, arg_108_2, arg_108_3)
end

StartGameStateSettingsOverview.can_use_streaming = function (arg_109_0)
	if IS_WINDOWS then
		return true
	end

	local var_109_0 = GameSettingsDevelopment.twitch_enabled
	local var_109_1 = Managers.account:offline_mode()

	return var_109_0 and not var_109_1
end

StartGameStateSettingsOverview.setup_backend_image_material = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	local var_110_0 = "StartGameStateSettingsOverview_" .. arg_110_2

	if arg_110_0._cloned_materials_by_reference[arg_110_2] then
		return var_110_0
	end

	local var_110_1 = arg_110_4 and "template_menu_diffuse_masked" or "template_menu_diffuse"

	arg_110_0:_create_material_instance(arg_110_1, var_110_0, var_110_1, arg_110_2)

	local var_110_2 = Managers.backend:get_interface("cdn")
	local var_110_3 = callback(arg_110_0, "_cb_on_backend_url_loaded", arg_110_1, arg_110_2, arg_110_3, var_110_0)

	var_110_2:get_resource_urls({
		arg_110_3
	}, var_110_3)

	return var_110_0
end

StartGameStateSettingsOverview._cb_on_backend_url_loaded = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5)
	local var_111_0 = arg_111_5[arg_111_3]

	if not var_111_0 then
		return
	end

	if arg_111_0._is_open == false then
		return
	end

	arg_111_0._material_references_to_unload[arg_111_2] = true

	local var_111_1 = callback(arg_111_0, "_cb_on_backend_image_loaded", arg_111_1, arg_111_2, arg_111_4)

	Managers.url_loader:load_resource(arg_111_2, var_111_0, var_111_1, arg_111_3)
end

StartGameStateSettingsOverview._cb_on_backend_image_loaded = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
	if not arg_112_0._cloned_materials_by_reference[arg_112_2] then
		return
	end

	if arg_112_4 then
		arg_112_0:_set_material_diffuse_by_resource(arg_112_1, arg_112_3, arg_112_4)
	else
		arg_112_0._material_references_to_unload[arg_112_2] = nil

		Application.warning(string.format("[StartGameStateSettingsOverview] - Failed loading image for reference name: (%s)", arg_112_2))
	end
end

StartGameStateSettingsOverview._create_material_instance = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	arg_113_0._cloned_materials_by_reference[arg_113_4] = arg_113_2
	arg_113_0._gui_by_cloned_material_reference[arg_113_4] = arg_113_1

	return Gui.clone_material_from_template(arg_113_1, arg_113_2, arg_113_3)
end

StartGameStateSettingsOverview._set_material_diffuse_by_resource = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3)
	local var_114_0 = Gui.material(arg_114_1, arg_114_2)

	if var_114_0 then
		Material.set_resource(var_114_0, "diffuse_map", arg_114_3)
	end
end

StartGameStateSettingsOverview._set_material_diffuse_by_path = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
	local var_115_0 = Gui.material(arg_115_1, arg_115_2)

	if var_115_0 then
		Material.set_texture(var_115_0, "diffuse_map", arg_115_3)
	end
end

StartGameStateSettingsOverview._is_unique_reference_to_material = function (arg_116_0, arg_116_1)
	local var_116_0 = arg_116_0._cloned_materials_by_reference
	local var_116_1 = var_116_0[arg_116_1]

	fassert(var_116_1, "[StartGameStateSettingsOverview] - Could not find a used material for reference name: (%s)", arg_116_1)

	for iter_116_0, iter_116_1 in pairs(var_116_0) do
		if var_116_1 == iter_116_1 and arg_116_1 ~= iter_116_0 then
			return false
		end
	end

	return true
end

StartGameStateSettingsOverview.reset_cloned_material = function (arg_117_0, arg_117_1)
	local var_117_0 = arg_117_0._gui_by_cloned_material_reference
	local var_117_1 = arg_117_0._cloned_materials_by_reference
	local var_117_2 = arg_117_0._material_references_to_unload

	if var_117_2[arg_117_1] then
		var_117_2[arg_117_1] = nil

		Managers.url_loader:unload_resource(arg_117_1)
	end

	if arg_117_0:_is_unique_reference_to_material(arg_117_1) then
		local var_117_3 = var_117_0[arg_117_1]
		local var_117_4 = var_117_1[arg_117_1]

		arg_117_0:_set_material_diffuse_by_path(var_117_3, var_117_4, var_0_5)
	end

	var_117_1[arg_117_1] = nil
	var_117_0[arg_117_1] = nil
end

StartGameStateSettingsOverview._reset_cloned_materials = function (arg_118_0)
	local var_118_0 = arg_118_0._cloned_materials_by_reference

	for iter_118_0, iter_118_1 in pairs(var_118_0) do
		arg_118_0:reset_cloned_material(iter_118_0)
	end
end
