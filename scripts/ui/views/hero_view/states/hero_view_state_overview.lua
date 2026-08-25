-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_overview.lua

require("scripts/ui/views/hero_view/windows/hero_window_prestige")
require("scripts/ui/views/hero_view/windows/hero_window_talents")
require("scripts/ui/views/hero_view/windows/hero_window_talents_console")
require("scripts/ui/views/hero_view/windows/hero_window_options")
require("scripts/ui/views/hero_view/windows/hero_window_crafting")
require("scripts/ui/views/hero_view/windows/hero_window_inventory")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_inventory")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout")
require("scripts/ui/views/hero_view/windows/hero_window_loadout")
require("scripts/ui/views/hero_view/windows/hero_window_background_console")
require("scripts/ui/views/hero_view/windows/hero_window_panel_console")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_console")
require("scripts/ui/views/hero_view/windows/hero_window_character_info")
require("scripts/ui/views/hero_view/windows/hero_window_character_selection_console")
require("scripts/ui/views/hero_view/windows/hero_window_crafting_list_console")
require("scripts/ui/views/hero_view/windows/hero_window_crafting_console")
require("scripts/ui/views/hero_view/windows/hero_window_crafting_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_hero_power_console")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_console")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_selection_console")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_pose_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_dark_pact_character_selection_console")
require("scripts/ui/views/hero_view/windows/hero_window_ingame_view")
require("scripts/ui/views/hero_view/windows/hero_window_character_preview")
require("scripts/ui/views/hero_view/windows/hero_window_item_customization")
require("scripts/ui/views/hero_view/windows/hero_window_character_summary")
DLCUtils.require_list("hero_view_windows")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_overview_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = false
local var_0_5 = {
	common = 2,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 5
}
local var_0_6 = script_data.testify and require("scripts/ui/views/hero_view/states/hero_view_state_overview_testify")

HeroViewStateOverview = class(HeroViewStateOverview)
HeroViewStateOverview.NAME = "HeroViewStateOverview"

function HeroViewStateOverview.on_enter(arg_1_0, arg_1_1)
	print("[HeroViewState] Enter Substate HeroViewStateOverview")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0._gamepad_style_active = arg_1_0:_setup_menu_layout(arg_1_1)

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.voting_manager = var_1_0.voting_manager
	arg_1_0.profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.ingame_ui = var_1_0.ingame_ui
	arg_1_0.is_in_inn = var_1_0.is_in_inn
	arg_1_0.force_ingame_menu = arg_1_1.state_params.force_ingame_menu
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.platform = PLATFORM

	local var_1_1 = Managers.player
	local var_1_2 = var_1_1:local_player()

	arg_1_0._stats_id = var_1_2:stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.local_player_id = var_1_0.local_player_id
	arg_1_0.player = var_1_2
	arg_1_0.is_server = arg_1_0.parent.is_server

	local var_1_3, var_1_4 = arg_1_0.profile_synchronizer:profile_by_peer(arg_1_0.peer_id, arg_1_0.local_player_id)

	arg_1_0.profile_index = var_1_3 or 1
	arg_1_0.career_index = var_1_4 or 1
	arg_1_0.hero_name = SPProfiles[arg_1_0.profile_index].display_name
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0.loadout_sync_id = 0
	arg_1_0.inventory_sync_id = 0
	arg_1_0.talent_sync_id = 0
	arg_1_0.skin_sync_id = 0
	arg_1_0.disabled_backend_ids_sync_id = 0
	arg_1_0._disabled_backend_ids = {}
	arg_1_0.character_pose_animation_sync_id = 0
	arg_1_0._current_pose_animation_event = nil
	arg_1_0.temporary_loadout_sync_id = 0
	arg_1_0._temporary_loadout = {}

	if IS_WINDOWS then
		arg_1_0._friends_component_ui = FriendsUIComponent:new(var_1_0)
	end

	arg_1_0:create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	local var_1_5 = {
		wwise_world = arg_1_0.wwise_world,
		ingame_ui_context = var_1_0,
		parent = arg_1_0,
		windows_settings = arg_1_0._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		hero_name = arg_1_0.hero_name,
		career_index = arg_1_0.career_index,
		profile_index = arg_1_0.profile_index,
		start_state = arg_1_1.start_state,
		force_ingame_menu = arg_1_0.force_ingame_menu
	}

	arg_1_0:_initial_windows_setups(var_1_5)

	if arg_1_0._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_enter()

		if arg_1_0.is_in_inn and not arg_1_0.force_ingame_menu then
			arg_1_0:play_sound("play_gui_amb_hero_screen_loop_begin")
			arg_1_0:disable_player_world()
		else
			arg_1_0:enable_ingame_overlay()
		end
	end
end

function HeroViewStateOverview._setup_menu_layout(arg_2_0, arg_2_1)
	local var_2_0 = IS_CONSOLE or Managers.input:is_device_active("gamepad") or not UISettings.use_pc_menu_layout or arg_2_1.state_params.force_ingame_menu

	if var_2_0 then
		arg_2_0._layout_settings = local_require("scripts/ui/views/hero_view/states/hero_window_layout_console")
	else
		arg_2_0._layout_settings = local_require("scripts/ui/views/hero_view/states/hero_window_layout")
	end

	arg_2_0._windows_settings = arg_2_0._layout_settings.windows
	arg_2_0._window_layouts = arg_2_0._layout_settings.window_layouts
	arg_2_0._max_active_windows = arg_2_0._layout_settings.max_active_windows

	return var_2_0
end

function HeroViewStateOverview.can_add(arg_3_0, arg_3_1)
	if Managers.ui:is_ui_layout_disabled(arg_3_1) then
		return false
	end

	local var_3_0, var_3_1 = table.find_by_key(arg_3_0._window_layouts, "name", arg_3_1)

	if var_3_1 and var_3_1.can_add_function then
		local var_3_2 = Managers.mechanism:current_mechanism_name()

		return var_3_1.can_add_function(var_3_2)
	end

	return true
end

function HeroViewStateOverview.create_ui_elements(arg_4_0, arg_4_1)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

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

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_3)
end

function HeroViewStateOverview.disable_player_world(arg_5_0)
	if not arg_5_0._player_world_disabled then
		arg_5_0._player_world_disabled = true

		local var_5_0 = "player_1"
		local var_5_1 = Managers.world:world("level_world")
		local var_5_2 = ScriptWorld.viewport(var_5_1, var_5_0)

		ScriptWorld.deactivate_viewport(var_5_1, var_5_2)
	end
end

function HeroViewStateOverview.enable_player_world(arg_6_0)
	if arg_6_0._player_world_disabled then
		arg_6_0._player_world_disabled = false

		local var_6_0 = "player_1"
		local var_6_1 = Managers.world:world("level_world")
		local var_6_2 = ScriptWorld.viewport(var_6_1, var_6_0)

		ScriptWorld.activate_viewport(var_6_1, var_6_2)
	end
end

function HeroViewStateOverview.enable_ingame_overlay(arg_7_0)
	if not arg_7_0._ingame_overlay_enabled then
		arg_7_0._ingame_overlay_enabled = true

		local var_7_0 = Managers.world:world("level_world")

		World.set_data(var_7_0, "fullscreen_blur", 0.5)
		World.set_data(var_7_0, "greyscale", 1)
		Managers.state.event:trigger("ingame_menu_opened", "interacting")
	end
end

function HeroViewStateOverview.disable_ingame_overlay(arg_8_0)
	if arg_8_0._ingame_overlay_enabled then
		arg_8_0._ingame_overlay_enabled = false

		local var_8_0 = Managers.world:world("level_world")

		World.set_data(var_8_0, "fullscreen_blur", nil)
		World.set_data(var_8_0, "greyscale", nil)
		Managers.state.event:trigger("ingame_menu_closed")
	end
end

function HeroViewStateOverview._initial_windows_setups(arg_9_0, arg_9_1)
	arg_9_0._active_windows = {}
	arg_9_0._window_params = arg_9_1

	local var_9_0 = arg_9_1.start_state

	if var_9_0 then
		arg_9_0:set_layout_by_name(var_9_0)
	else
		arg_9_0:set_layout(1)
	end
end

function HeroViewStateOverview.window_input_service(arg_10_0)
	return arg_10_0._input_blocked and FAKE_INPUT_SERVICE or arg_10_0:input_service()
end

function HeroViewStateOverview.change_profile(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.profile_index = arg_11_1
	arg_11_0.hero_name = SPProfiles[arg_11_1].display_name
	arg_11_0.career_index = arg_11_2
	arg_11_0._window_params.hero_name = arg_11_0.hero_name
	arg_11_0._window_params.profile_index = arg_11_0.profile_index
	arg_11_0._window_params.career_index = arg_11_0.career_index
end

function HeroViewStateOverview.currently_selected_profile(arg_12_0)
	return arg_12_0.profile_index, arg_12_0.career_index, arg_12_0.hero_name
end

function HeroViewStateOverview._close_window_at_index(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._active_windows
	local var_13_1 = arg_13_0._window_params
	local var_13_2 = var_13_0[arg_13_1]

	if var_13_2 and var_13_2.on_exit then
		var_13_2:on_exit(var_13_1)
	end

	var_13_0[arg_13_1] = nil
end

function HeroViewStateOverview._change_window(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._active_windows
	local var_14_1 = arg_14_0._windows_settings[arg_14_2]
	local var_14_2 = var_14_1.class_name
	local var_14_3 = var_14_0[arg_14_1]

	if var_14_3 then
		if var_14_3.NAME == var_14_2 then
			return
		end

		arg_14_0:_close_window_at_index(arg_14_1)
	end

	local var_14_4 = rawget(_G, var_14_2):new()
	local var_14_5 = var_14_1.ignore_alignment
	local var_14_6

	if not var_14_5 then
		local var_14_7 = var_14_1.alignment_index or arg_14_1
		local var_14_8 = UISettings.game_start_windows
		local var_14_9 = var_14_8.size
		local var_14_10 = var_14_8.spacing or 10
		local var_14_11 = var_14_9[1]
		local var_14_12 = var_14_10 * 2
		local var_14_13 = -(3 * var_14_11 / 2 + var_14_11 / 2) - (var_14_12 / 2 + var_14_10) + var_14_7 * var_14_11 + var_14_7 * var_14_10

		var_14_6 = {
			var_14_13,
			0,
			3
		}
	end

	if var_14_4.on_enter then
		local var_14_14 = arg_14_0._window_params

		var_14_4:on_enter(var_14_14, var_14_6)
	end

	var_14_0[arg_14_1] = var_14_4
end

function HeroViewStateOverview.get_selected_layout_name(arg_15_0)
	return arg_15_0:get_layout_name()
end

function HeroViewStateOverview.get_layout_name(arg_16_0)
	local var_16_0 = arg_16_0._selected_game_mode_index

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._window_layouts) do
		if iter_16_0 == var_16_0 then
			return iter_16_1.name
		end
	end
end

function HeroViewStateOverview.set_layout_by_name(arg_17_0, arg_17_1)
	local var_17_0 = table.find_by_key(arg_17_0._window_layouts, "name", arg_17_1)

	if var_17_0 then
		arg_17_0:set_layout(var_17_0)
	end
end

function HeroViewStateOverview.close_on_exit(arg_18_0)
	return arg_18_0._close_on_exit
end

function HeroViewStateOverview.set_layout(arg_19_0, arg_19_1)
	arg_19_0._wanted_layout_index = arg_19_1
end

function HeroViewStateOverview._update_set_layout(arg_20_0)
	local var_20_0 = arg_20_0._wanted_layout_index

	if not var_20_0 then
		return
	end

	arg_20_0._wanted_layout_index = nil

	local var_20_1 = arg_20_0:_get_layout_setting(var_20_0)
	local var_20_2 = var_20_1.windows
	local var_20_3 = var_20_1.sound_event_enter
	local var_20_4 = var_20_1.close_on_exit
	local var_20_5 = var_20_1.input_focus_window

	if var_20_3 then
		arg_20_0:play_sound(var_20_3)
	end

	arg_20_0._widgets_by_name.exit_button.content.visible = var_20_4
	arg_20_0._widgets_by_name.back_button.content.visible = not var_20_4
	arg_20_0._close_on_exit = var_20_4

	for iter_20_0 = 1, arg_20_0._max_active_windows do
		local var_20_6 = false

		for iter_20_1, iter_20_2 in pairs(var_20_2) do
			if iter_20_2 == iter_20_0 then
				arg_20_0:_change_window(iter_20_2, iter_20_1)

				var_20_6 = true
			end
		end

		if not var_20_6 then
			arg_20_0:_close_window_at_index(iter_20_0)
		end
	end

	local var_20_7 = arg_20_0:_get_layout_setting(arg_20_0._selected_game_mode_index)

	if arg_20_0._selected_game_mode_index and var_20_7.close_on_exit then
		arg_20_0._previous_selected_game_mode_index = arg_20_0._selected_game_mode_index
	end

	arg_20_0._selected_game_mode_index = var_20_0

	arg_20_0:set_window_input_focus(var_20_5)
end

function HeroViewStateOverview.set_window_input_focus(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._selected_game_mode_index
	local var_21_1 = arg_21_0:_get_layout_setting(var_21_0)
	local var_21_2 = arg_21_0._windows_settings[arg_21_1]
	local var_21_3 = var_21_2 and var_21_2.class_name
	local var_21_4 = false
	local var_21_5 = arg_21_0._active_windows

	for iter_21_0, iter_21_1 in pairs(var_21_5) do
		local var_21_6 = iter_21_1.NAME == var_21_3

		if iter_21_1.set_focus then
			iter_21_1:set_focus(var_21_6)
		end

		if var_21_6 then
			var_21_4 = true
		end
	end

	if arg_21_1 and not var_21_4 then
		ferror("[HeroViewStateOverview] - (set_window_input_focus) Could not find a window by name: %s", arg_21_1)
	end

	arg_21_0._window_focused = arg_21_1
end

function HeroViewStateOverview.get_selected_game_mode_index(arg_22_0)
	return arg_22_0._selected_game_mode_index
end

function HeroViewStateOverview.get_previous_selected_game_mode_index(arg_23_0)
	return arg_23_0._previous_selected_game_mode_index
end

function HeroViewStateOverview._get_layout_setting(arg_24_0, arg_24_1)
	return arg_24_0._window_layouts[arg_24_1]
end

function HeroViewStateOverview.get_layout_setting_by_name(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._window_layouts

	for iter_25_0 = 1, #var_25_0 do
		local var_25_1 = var_25_0[iter_25_0]

		if arg_25_1 == var_25_1.name then
			return var_25_1
		end
	end
end

function HeroViewStateOverview.get_layout_setting_by_name(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._window_layouts

	for iter_26_0 = 1, #var_26_0 do
		local var_26_1 = var_26_0[iter_26_0]

		if arg_26_1 == var_26_1.name then
			return var_26_1
		end
	end
end

function HeroViewStateOverview._windows_update(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0._active_windows

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		iter_27_1:update(arg_27_1, arg_27_2)
	end
end

function HeroViewStateOverview._windows_post_update(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._active_windows

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		if iter_28_1.post_update then
			iter_28_1:post_update(arg_28_1, arg_28_2)
		end
	end
end

function HeroViewStateOverview.enable_widget(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0._active_windows[arg_29_1]._widgets_by_name[arg_29_2]

	if var_29_0 then
		local var_29_1 = var_29_0.content.button_hotspot

		if var_29_1 then
			var_29_1.disable_button = not arg_29_3
		end
	end
end

function HeroViewStateOverview.transitioning(arg_30_0)
	if arg_30_0.exiting then
		return true
	else
		return false
	end
end

function HeroViewStateOverview._wanted_state(arg_31_0)
	return (arg_31_0.parent:wanted_state())
end

function HeroViewStateOverview.wanted_menu_state(arg_32_0)
	return arg_32_0._wanted_menu_state
end

function HeroViewStateOverview.clear_wanted_menu_state(arg_33_0)
	arg_33_0._wanted_menu_state = nil
end

function HeroViewStateOverview.requested_screen_change_by_name(arg_34_0, arg_34_1)
	arg_34_0._on_close_next_state = arg_34_1

	arg_34_0:close_menu()
end

function HeroViewStateOverview.on_exit(arg_35_0, arg_35_1)
	print("[HeroViewState] Exit Substate HeroViewStateOverview")

	arg_35_0.ui_animator = nil

	local var_35_0 = arg_35_0._friends_component_ui

	if var_35_0 and arg_35_0:is_friends_list_active() then
		var_35_0:deactivate_friends_ui()
	end

	if arg_35_0._fullscreen_effect_enabled then
		arg_35_0:set_fullscreen_effect_enable_state(false)
	end

	arg_35_0:_close_active_windows()

	if arg_35_0._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_exit()

		if arg_35_0.is_in_inn and not arg_35_0.force_ingame_menu then
			arg_35_0:play_sound("play_gui_amb_hero_screen_loop_end")
			arg_35_0:enable_player_world()
		else
			arg_35_0:disable_ingame_overlay()
		end
	end

	local var_35_1 = Managers.player:local_player()

	if var_35_1 and var_35_1:career_name() == "bw_necromancer" then
		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", true)
	else
		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", false)
	end
end

function HeroViewStateOverview._close_active_windows(arg_36_0)
	local var_36_0 = arg_36_0._active_windows
	local var_36_1 = arg_36_0._window_params

	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		if iter_36_1.on_exit then
			iter_36_1:on_exit(var_36_1)
		end
	end

	table.clear(var_36_0)
end

function HeroViewStateOverview._update_transition_timer(arg_37_0, arg_37_1)
	if not arg_37_0._transition_timer then
		return
	end

	if arg_37_0._transition_timer == 0 then
		arg_37_0._transition_timer = nil
	else
		arg_37_0._transition_timer = math.max(arg_37_0._transition_timer - arg_37_1, 0)
	end
end

function HeroViewStateOverview.input_service(arg_38_0)
	return arg_38_0.parent:input_service()
end

function HeroViewStateOverview.update(arg_39_0, arg_39_1, arg_39_2)
	if var_0_4 then
		var_0_4 = false

		arg_39_0:create_ui_elements()
	end

	arg_39_0:_update_set_layout()

	local var_39_0 = arg_39_0.input_manager
	local var_39_1 = arg_39_0:window_input_service()
	local var_39_2 = arg_39_0._friends_component_ui
	local var_39_3 = var_39_0:is_device_active("gamepad")

	if var_39_2 and not var_39_3 and Managers.account:is_online() then
		var_39_2:update(arg_39_1, var_39_1)
	end

	if not arg_39_0._gamepad_style_active then
		arg_39_0:draw(var_39_1, arg_39_1)
	end

	arg_39_0:_update_transition_timer(arg_39_1)
	arg_39_0:_windows_update(arg_39_1, arg_39_2)

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_6, arg_39_0)
	end

	local var_39_4 = arg_39_0.parent:transitioning()
	local var_39_5 = arg_39_0:_wanted_state()

	if not arg_39_0._transition_timer then
		if not var_39_4 then
			if arg_39_0:_has_active_level_vote() then
				local var_39_6 = true

				arg_39_0:close_menu(var_39_6)
			else
				arg_39_0:_handle_input(arg_39_1, arg_39_2)
			end
		end

		if var_39_5 then
			arg_39_0.parent:clear_wanted_state()

			arg_39_0._new_state = var_39_5
		else
			return arg_39_0._new_state
		end
	end
end

function HeroViewStateOverview.is_friends_list_active(arg_40_0)
	local var_40_0 = arg_40_0._friends_component_ui

	if var_40_0 then
		return var_40_0:is_active()
	end

	return false
end

function HeroViewStateOverview._handle_friend_joining(arg_41_0)
	local var_41_0 = arg_41_0._friends_component_ui

	if var_41_0 then
		local var_41_1 = var_41_0:join_lobby_data()

		if var_41_1 and Managers.matchmaking:allowed_to_initiate_join_lobby() then
			Managers.matchmaking:request_join_lobby(var_41_1, {
				friend_join = true
			})
			arg_41_0:close_menu(true)

			return true
		end
	end
end

function HeroViewStateOverview._has_active_level_vote(arg_42_0)
	local var_42_0 = arg_42_0.voting_manager

	return var_42_0:vote_in_progress() and var_42_0:is_mission_vote() and not var_42_0:has_voted(Network.peer_id())
end

function HeroViewStateOverview.post_update(arg_43_0, arg_43_1, arg_43_2)
	arg_43_0.ui_animator:update(arg_43_1)
	arg_43_0:_update_animations(arg_43_1)
	arg_43_0:_windows_post_update(arg_43_1, arg_43_2)

	if arg_43_0._new_state then
		arg_43_0:_close_active_windows()
	end

	local var_43_0 = arg_43_0._equip_request

	if var_43_0 then
		arg_43_0._equip_request = nil

		local var_43_1 = var_43_0.slot_type
		local var_43_2 = var_43_0.slot_name
		local var_43_3 = var_43_0.backend_id
		local var_43_4 = var_43_0.unit

		if var_43_1 == "melee" or var_43_1 == "ranged" then
			ScriptUnit.extension(var_43_4, "inventory_system"):create_equipment_in_slot(var_43_2, var_43_3)
		elseif var_43_1 == "hat" or var_43_1 == "trinket" or var_43_1 == "ring" or var_43_1 == "necklace" then
			ScriptUnit.extension(var_43_4, "attachment_system"):create_attachment_in_slot(var_43_2, var_43_3)
		end
	end
end

function HeroViewStateOverview._update_animations(arg_44_0, arg_44_1)
	for iter_44_0, iter_44_1 in pairs(arg_44_0._ui_animations) do
		UIAnimation.update(iter_44_1, arg_44_1)

		if UIAnimation.completed(iter_44_1) then
			arg_44_0._ui_animations[iter_44_0] = nil
		end
	end

	local var_44_0 = arg_44_0._animations
	local var_44_1 = arg_44_0.ui_animator

	for iter_44_2, iter_44_3 in pairs(var_44_0) do
		if var_44_1:is_animation_completed(iter_44_3) then
			var_44_1:stop_animation(iter_44_3)

			var_44_0[iter_44_2] = nil
		end
	end
end

function HeroViewStateOverview._is_button_hover_enter(arg_45_0, arg_45_1)
	return arg_45_1.content.button_hotspot.on_hover_enter
end

function HeroViewStateOverview._handle_input(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0._input_blocked
	local var_46_1 = Managers.input:is_device_active("gamepad")
	local var_46_2 = arg_46_0._input_paused and var_46_1

	if var_46_0 or var_46_2 then
		return
	end

	if arg_46_0:_handle_friend_joining() then
		return
	end

	local var_46_3 = arg_46_0._widgets_by_name
	local var_46_4 = arg_46_0.parent:input_service()
	local var_46_5 = var_46_4:get("toggle_menu", true)
	local var_46_6 = var_46_1 and var_46_4:get("back_menu", true)
	local var_46_7 = arg_46_0._close_on_exit
	local var_46_8 = var_46_3.exit_button
	local var_46_9 = var_46_3.back_button

	UIWidgetUtils.animate_default_button(var_46_8, arg_46_1)
	UIWidgetUtils.animate_default_button(var_46_9, arg_46_1)

	if arg_46_0:_is_button_hover_enter(var_46_9) or arg_46_0:_is_button_hover_enter(var_46_8) then
		arg_46_0:play_sound("play_gui_equipment_button_hover")
	end

	if var_46_7 and (var_46_6 or var_46_5 or arg_46_0:_is_button_pressed(var_46_8)) then
		arg_46_0:play_sound("Play_hud_hover")
		arg_46_0:close_menu()

		return
	elseif var_46_5 or var_46_6 or arg_46_0:_is_button_pressed(var_46_9) then
		arg_46_0:play_sound("Play_hud_hover")

		local var_46_10 = arg_46_0:get_previous_selected_game_mode_index()

		if var_46_10 then
			arg_46_0:set_layout(var_46_10)
		end
	end
end

function HeroViewStateOverview.close_menu(arg_47_0, arg_47_1)
	if arg_47_0._on_close_next_state then
		arg_47_0.parent:requested_screen_change_by_name(arg_47_0._on_close_next_state)
	else
		arg_47_0.parent:close_menu(nil, arg_47_1)
	end
end

function HeroViewStateOverview.draw(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0.ui_renderer
	local var_48_1 = arg_48_0.ui_top_renderer
	local var_48_2 = arg_48_0.ui_scenegraph
	local var_48_3 = arg_48_0.input_manager
	local var_48_4 = arg_48_0.render_settings
	local var_48_5 = var_48_3:is_device_active("gamepad")

	UIRenderer.begin_pass(var_48_0, var_48_2, arg_48_1, arg_48_2, nil, var_48_4)

	local var_48_6 = var_48_4.snap_pixel_positions

	for iter_48_0, iter_48_1 in ipairs(arg_48_0._widgets) do
		if iter_48_1.snap_pixel_positions ~= nil then
			var_48_4.snap_pixel_positions = iter_48_1.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_48_0, iter_48_1)

		var_48_4.snap_pixel_positions = var_48_6
	end

	UIRenderer.end_pass(var_48_0)
end

function HeroViewStateOverview._is_button_pressed(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_1.content
	local var_49_1 = var_49_0.button_hotspot or var_49_0.hotspot

	if var_49_1.on_release then
		var_49_1.on_release = false

		return true
	end
end

function HeroViewStateOverview.play_sound(arg_50_0, arg_50_1)
	arg_50_0.parent:play_sound(arg_50_1)
end

function HeroViewStateOverview._start_transition_animation(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = {
		wwise_world = arg_51_0.wwise_world,
		render_settings = arg_51_0.render_settings
	}
	local var_51_1 = {}
	local var_51_2 = arg_51_0.ui_animator:start_animation(arg_51_2, var_51_1, var_0_2, var_51_0)

	arg_51_0._animations[arg_51_1] = var_51_2
end

function HeroViewStateOverview.set_auto_fill_rarity(arg_52_0, arg_52_1)
	arg_52_0._auto_fill_rarity = arg_52_1
end

function HeroViewStateOverview.get_auto_fill_rarity(arg_53_0)
	local var_53_0 = arg_53_0._auto_fill_rarity

	arg_53_0._auto_fill_rarity = nil

	return var_53_0
end

function HeroViewStateOverview.set_filter_selected(arg_54_0, arg_54_1)
	arg_54_0._filter_selected = arg_54_1
end

function HeroViewStateOverview.filter_selected(arg_55_0)
	return arg_55_0._filter_selected
end

function HeroViewStateOverview.set_filter_active(arg_56_0, arg_56_1)
	arg_56_0._filter_active = arg_56_1
end

function HeroViewStateOverview.filter_active(arg_57_0)
	return arg_57_0._filter_active
end

function HeroViewStateOverview.reset_filter(arg_58_0)
	arg_58_0._filter_reset = true
end

function HeroViewStateOverview.filter_reset(arg_59_0)
	local var_59_0 = arg_59_0._filter_reset

	arg_59_0._filter_reset = nil

	return var_59_0
end

function HeroViewStateOverview.disable_filter(arg_60_0, arg_60_1)
	arg_60_0._filter_disabled = arg_60_1
end

function HeroViewStateOverview.disable_search(arg_61_0, arg_61_1)
	arg_61_0._search_disabled = arg_61_1
end

function HeroViewStateOverview.filter_search_disabled(arg_62_0)
	return arg_62_0._filter_disabled, arg_62_0._search_disabled
end

function HeroViewStateOverview.set_selected_items_backend_ids(arg_63_0, arg_63_1)
	arg_63_0._selected_items_backend_ids = arg_63_1
end

function HeroViewStateOverview.get_selected_items_backend_ids(arg_64_0)
	return arg_64_0._selected_items_backend_ids
end

function HeroViewStateOverview.set_pressed_item_backend_id(arg_65_0, arg_65_1, arg_65_2)
	arg_65_0._pressed_item_backend_id = arg_65_1
	arg_65_0._pressed_item_by_drag = arg_65_1 and arg_65_2 or nil
end

function HeroViewStateOverview.get_disabled_backend_ids(arg_66_0)
	return arg_66_0._disabled_backend_ids
end

function HeroViewStateOverview.clear_disabled_backend_ids(arg_67_0)
	arg_67_0._disabled_backend_ids = {}
	arg_67_0.disabled_backend_ids_sync_id = arg_67_0.disabled_backend_ids_sync_id + 1
end

function HeroViewStateOverview.disabled_item_icon(arg_68_0)
	return arg_68_0._disabled_item_icon
end

function HeroViewStateOverview.set_disabled_item_icon(arg_69_0, arg_69_1)
	arg_69_0._disabled_item_icon = arg_69_1
end

function HeroViewStateOverview.set_disabled_backend_id(arg_70_0, arg_70_1, arg_70_2)
	if arg_70_2 then
		arg_70_0._disabled_backend_ids[arg_70_1] = true
	else
		arg_70_0._disabled_backend_ids[arg_70_1] = nil
	end

	arg_70_0.disabled_backend_ids_sync_id = arg_70_0.disabled_backend_ids_sync_id + 1
end

function HeroViewStateOverview.get_pressed_item_backend_id(arg_71_0)
	return arg_71_0._pressed_item_backend_id, arg_71_0._pressed_item_by_drag
end

function HeroViewStateOverview.get_inventory_grid(arg_72_0)
	return arg_72_0._current_inventory_grid
end

function HeroViewStateOverview.set_inventory_grid(arg_73_0, arg_73_1)
	arg_73_0._current_inventory_grid = arg_73_1
end

function HeroViewStateOverview.set_fullscreen_effect_enable_state(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0.ui_renderer.world
	local var_74_1 = World.get_data(var_74_0, "shading_environment")

	if var_74_1 then
		ShadingEnvironment.set_scalar(var_74_1, "fullscreen_blur_enabled", arg_74_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_74_1, "fullscreen_blur_amount", arg_74_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_74_1)
	end

	arg_74_0._fullscreen_effect_enabled = arg_74_1
end

function HeroViewStateOverview.block_input(arg_75_0)
	arg_75_0._input_blocked = true
end

function HeroViewStateOverview.unblock_input(arg_76_0)
	arg_76_0._input_blocked = false
end

function HeroViewStateOverview.input_blocked(arg_77_0)
	return arg_77_0._input_blocked
end

function HeroViewStateOverview.set_selected_craft_page(arg_78_0, arg_78_1)
	arg_78_0._selected_craft_page_name = arg_78_1
end

function HeroViewStateOverview.get_selected_craft_page(arg_79_0)
	return arg_79_0._selected_craft_page_name
end

function HeroViewStateOverview.set_craft_optional_item_filter(arg_80_0, arg_80_1)
	arg_80_0._craft_optional_item_filter = arg_80_1
end

function HeroViewStateOverview.get_craft_optional_item_filter(arg_81_0)
	return arg_81_0._craft_optional_item_filter
end

function HeroViewStateOverview.set_selected_loadout_slot_index(arg_82_0, arg_82_1)
	arg_82_0._selected_loadout_slot_index = arg_82_1
end

function HeroViewStateOverview.get_selected_loadout_slot_index(arg_83_0)
	return arg_83_0._selected_loadout_slot_index or 1
end

function HeroViewStateOverview.set_selected_cosmetic_slot_index(arg_84_0, arg_84_1)
	arg_84_0._selected_cosmetic_slot_index = arg_84_1
end

function HeroViewStateOverview.get_selected_cosmetic_slot_index(arg_85_0)
	return arg_85_0._selected_cosmetic_slot_index or 1
end

function HeroViewStateOverview.set_temporary_loadout_item(arg_86_0, arg_86_1, arg_86_2)
	local var_86_0 = arg_86_1.data.slot_type

	arg_86_0._temporary_loadout[var_86_0] = arg_86_1
	arg_86_0._skip_wield_anim = arg_86_2
	arg_86_0.temporary_loadout_sync_id = arg_86_0.temporary_loadout_sync_id + 1
	arg_86_0.character_pose_animation_sync_id = arg_86_0.character_pose_animation_sync_id + 1
end

function HeroViewStateOverview.clear_temporary_loadout(arg_87_0)
	table.clear(arg_87_0._temporary_loadout)

	arg_87_0._skip_wield_anim = nil
	arg_87_0.loadout_sync_id = arg_87_0.loadout_sync_id + 1
end

function HeroViewStateOverview.get_temporary_loadout_item(arg_88_0, arg_88_1)
	return arg_88_0._temporary_loadout[arg_88_1], arg_88_0._skip_wield_anim
end

function HeroViewStateOverview.set_character_pose_animation(arg_89_0, arg_89_1)
	arg_89_0._current_pose_animation_event = arg_89_1
	arg_89_0.character_pose_animation_sync_id = arg_89_0.character_pose_animation_sync_id + 1
end

local var_0_7 = {}

function HeroViewStateOverview.clear_character_animation(arg_90_0, arg_90_1)
	arg_90_0._current_pose_animation_event = nil

	local var_90_0 = Managers.backend:get_interface("items")
	local var_90_1 = arg_90_0.hero_name
	local var_90_2 = arg_90_0.career_index
	local var_90_3 = FindProfileIndex(var_90_1)
	local var_90_4 = SPProfiles[var_90_3].careers[var_90_2].name
	local var_90_5 = var_90_0:get_loadout_item_id(var_90_4, "slot_pose")
	local var_90_6 = var_90_0:get_unlocked_weapon_poses()[arg_90_1] or var_0_7

	if table.find(var_90_6, var_90_5) then
		arg_90_0._current_pose_animation_event = var_90_0:get_item_from_id(var_90_5).data.data.anim_event
	else
		arg_90_0._current_pose_animation_event = nil
	end

	arg_90_0.character_pose_animation_sync_id = arg_90_0.character_pose_animation_sync_id + 1
end

function HeroViewStateOverview.get_character_animation_event(arg_91_0)
	return arg_91_0._current_pose_animation_event
end

function HeroViewStateOverview._set_loadout_item(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = arg_92_0.hero_name
	local var_92_1 = arg_92_0.career_index
	local var_92_2 = arg_92_0.player_manager
	local var_92_3 = arg_92_0.peer_id
	local var_92_4 = var_92_2:player_from_peer_id(var_92_3).player_unit

	if not var_92_4 or not Unit.alive(var_92_4) then
		return
	end

	if not Managers.state.network:game() then
		return
	end

	if LoadoutUtils.is_item_disabled(arg_92_1.ItemId) then
		return
	end

	local var_92_5 = arg_92_1.backend_id
	local var_92_6 = arg_92_1.data
	local var_92_7
	local var_92_8

	if arg_92_2 then
		var_92_7 = InventorySettings.slots_by_name[arg_92_2]
		var_92_8 = var_92_7.type
	else
		var_92_8 = var_92_6.slot_type
		var_92_7 = arg_92_0:_get_slot_by_type(var_92_8)
	end

	local var_92_9 = var_92_7.name
	local var_92_10 = FindProfileIndex(var_92_0)
	local var_92_11 = SPProfiles[var_92_10].careers[var_92_1].name

	BackendUtils.set_loadout_item(var_92_5, var_92_11, var_92_9)

	if not arg_92_0:is_bot_career() then
		if not arg_92_0.parent:is_loadout_dirty() then
			if var_92_8 == "frame" then
				Managers.state.entity:system("cosmetic_system"):set_equipped_frame(var_92_4, var_92_6.key)
			elseif var_92_8 ~= "skin" and var_92_8 ~= "weapon_pose" then
				arg_92_0._equip_request = {
					slot_type = var_92_8,
					slot_name = var_92_9,
					backend_id = var_92_5,
					unit = var_92_4
				}
			end
		end
	elseif var_92_8 == "hat" then
		arg_92_0.skin_sync_id = arg_92_0.skin_sync_id + 1
	end

	arg_92_0.loadout_sync_id = arg_92_0.loadout_sync_id + 1
	arg_92_0.inventory_sync_id = arg_92_0.inventory_sync_id + 1

	local var_92_12 = arg_92_0.statistics_db:get_persistent_stat(arg_92_0._stats_id, "highest_equipped_rarity", var_92_8)
	local var_92_13 = var_0_5[arg_92_1.rarity]

	if var_92_13 and var_92_12 < var_92_13 then
		arg_92_0.statistics_db:set_stat(arg_92_0._stats_id, "highest_equipped_rarity", var_92_8, var_92_13)
	end

	Managers.state.event:trigger("event_set_loadout_items")
end

function HeroViewStateOverview.is_bot_career(arg_93_0)
	local var_93_0 = Managers.player:local_player()
	local var_93_1 = var_93_0:profile_index()
	local var_93_2 = var_93_0:career_index()

	return var_93_1 ~= arg_93_0.profile_index or var_93_2 ~= arg_93_0.career_index, arg_93_0.profile_index, arg_93_0.career_index
end

function HeroViewStateOverview.get_career_data(arg_94_0)
	return arg_94_0.profile_index, arg_94_0.career_index
end

function HeroViewStateOverview.update_talent_sync(arg_95_0)
	arg_95_0.talent_sync_id = arg_95_0.talent_sync_id + 1
end

function HeroViewStateOverview.update_skin_sync(arg_96_0)
	arg_96_0.skin_sync_id = arg_96_0.skin_sync_id + 1

	arg_96_0.ingame_ui:respawn()
end

function HeroViewStateOverview.unequip_item_in_slot(arg_97_0, arg_97_1)
	local var_97_0 = arg_97_0.hero_name
	local var_97_1 = arg_97_0.career_index
	local var_97_2 = arg_97_0:_get_slot_by_type(arg_97_1)

	if not var_97_2.unequippable then
		return false
	end

	local var_97_3 = var_97_2.name
	local var_97_4 = var_97_2.slot_index
	local var_97_5 = FindProfileIndex(var_97_0)
	local var_97_6 = SPProfiles[var_97_5].careers[var_97_1].name

	if not BackendUtils.get_loadout_item(var_97_6, var_97_3) then
		return false
	end

	BackendUtils.set_loadout_item(nil, var_97_6, var_97_3)

	arg_97_0.loadout_sync_id = arg_97_0.loadout_sync_id + 1
	arg_97_0.inventory_sync_id = arg_97_0.inventory_sync_id + 1

	return true
end

function HeroViewStateOverview.update_full_loadout(arg_98_0)
	arg_98_0.loadout_sync_id = arg_98_0.loadout_sync_id + 1
	arg_98_0.inventory_sync_id = arg_98_0.inventory_sync_id + 1
	arg_98_0.talent_sync_id = arg_98_0.talent_sync_id + 1
	arg_98_0.skin_sync_id = arg_98_0.skin_sync_id + 1
end

function HeroViewStateOverview.update_inventory_items(arg_99_0)
	arg_99_0.inventory_sync_id = arg_99_0.inventory_sync_id + 1
end

function HeroViewStateOverview._get_slot_by_type(arg_100_0, arg_100_1)
	local var_100_0 = InventorySettings.slots_by_slot_index

	for iter_100_0, iter_100_1 in pairs(var_100_0) do
		if arg_100_1 == iter_100_1.type then
			return iter_100_1
		end
	end
end

function HeroViewStateOverview.window_layout_on_exit(arg_101_0, arg_101_1)
	local var_101_0 = arg_101_0:get_layout_setting_by_name(arg_101_1)

	if var_101_0 and var_101_0.on_exit then
		var_101_0.on_exit(arg_101_0)
	end
end

function HeroViewStateOverview.pause_input(arg_102_0, arg_102_1)
	arg_102_0._input_paused = arg_102_1
end

function HeroViewStateOverview.input_paused(arg_103_0)
	return arg_103_0._input_paused
end

function HeroViewStateOverview.set_background_mood(arg_104_0, arg_104_1)
	local var_104_0 = "character_preview"
	local var_104_1 = Managers.world:world(var_104_0)

	World.set_data(var_104_1, "shading_settings", {
		arg_104_1,
		1
	})
end

function HeroViewStateOverview.set_loadout_dirty(arg_105_0)
	arg_105_0.parent:set_loadout_dirty()
end
