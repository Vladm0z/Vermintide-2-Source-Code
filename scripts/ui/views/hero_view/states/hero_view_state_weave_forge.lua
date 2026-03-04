-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_weave_forge.lua

local_require("scripts/ui/views/hero_view/windows/hero_window_weave_properties")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_overview")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_weapons")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_background")
local_require("scripts/ui/views/hero_view/windows/hero_window_weave_forge_panel")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_weave_forge_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.console_cursor_definition
local var_0_5 = var_0_0.generic_input_actions
local var_0_6 = false
local var_0_7 = {
	common = 2,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 5
}

HeroViewStateWeaveForge = class(HeroViewStateWeaveForge)
HeroViewStateWeaveForge.NAME = "HeroViewStateWeaveForge"

function HeroViewStateWeaveForge.on_enter(arg_1_0, arg_1_1)
	print("[HeroViewState] Enter Substate HeroViewStateWeaveForge")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0._gamepad_style_active = arg_1_0:_setup_menu_layout()

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
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.platform = PLATFORM

	local var_1_1 = Managers.player
	local var_1_2 = var_1_1:local_player()

	arg_1_0._stats_id = var_1_2:stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.local_player_id = var_1_0.local_player_id
	arg_1_0.player = var_1_2

	local var_1_3 = arg_1_0.profile_synchronizer:profile_by_peer(arg_1_0.peer_id, arg_1_0.local_player_id)
	local var_1_4 = SPProfiles[var_1_3]
	local var_1_5 = var_1_4.display_name
	local var_1_6 = var_1_4.character_name

	arg_1_0.career_index, arg_1_0.hero_name = Managers.backend:get_interface("hero_attributes"):get(var_1_5, "career"), var_1_5
	arg_1_0.profile_index = var_1_3
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	if IS_WINDOWS then
		arg_1_0._friends_component_ui = FriendsUIComponent:new(var_1_0)
	end

	arg_1_0:create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	local var_1_7 = {
		wwise_world = arg_1_0.wwise_world,
		ingame_ui_context = var_1_0,
		parent = arg_1_0,
		windows_settings = arg_1_0._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		hero_name = arg_1_0.hero_name,
		career_index = arg_1_0.career_index,
		profile_index = arg_1_0.profile_index,
		start_state = arg_1_1.start_state
	}

	arg_1_0:_initial_windows_setups(var_1_7)

	if arg_1_0._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_enter()

		if arg_1_0.is_in_inn then
			arg_1_0:play_sound("play_gui_amb_hero_screen_loop_begin")
			arg_1_0:_setup_gamepad_gui()
			arg_1_0:disable_player_world()
		else
			arg_1_0:enable_ingame_overlay()
		end
	else
		arg_1_0:play_sound("hud_magic_forge_open")
	end

	Managers.input:enable_gamepad_cursor()
	Managers.state.event:trigger("weave_forge_entered")
end

function HeroViewStateWeaveForge.gamepad_style_active(arg_2_0)
	return arg_2_0._gamepad_style_active
end

function HeroViewStateWeaveForge.get_ui_renderer(arg_3_0)
	if arg_3_0._gamepad_style_active then
		return arg_3_0._gui_data.bottom.renderer
	else
		return arg_3_0.ui_renderer
	end
end

function HeroViewStateWeaveForge.get_ui_top_renderer(arg_4_0)
	return arg_4_0.ui_top_renderer
end

function HeroViewStateWeaveForge.hdr_renderer(arg_5_0)
	return arg_5_0.parent:hdr_renderer()
end

function HeroViewStateWeaveForge.hdr_top_renderer(arg_6_0)
	return arg_6_0.parent:hdr_top_renderer()
end

function HeroViewStateWeaveForge._setup_gamepad_gui(arg_7_0)
	if arg_7_0.is_in_inn then
		local var_7_0 = {}
		local var_7_1 = "weave_forge_gamepad"
		local var_7_2, var_7_3, var_7_4 = arg_7_0:_setup_gamepad_renderer(var_7_1, 1, GameSettingsDevelopment.default_environment)

		var_7_0.bottom = {
			renderer = var_7_2,
			world = var_7_3,
			viewport_name = var_7_4
		}
		arg_7_0._gui_data = var_7_0
	end
end

function HeroViewStateWeaveForge._setup_gamepad_renderer(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_8_1 = arg_8_1
	local var_8_2 = arg_8_1
	local var_8_3 = Managers.world:create_world(var_8_1, arg_8_3, nil, arg_8_2, unpack(var_8_0))
	local var_8_4 = "overlay"
	local var_8_5 = ScriptWorld.create_viewport(var_8_3, var_8_2, var_8_4, 999)

	return arg_8_0.ingame_ui:create_ui_renderer(var_8_3, false, arg_8_0.is_in_inn), var_8_3, var_8_2
end

function HeroViewStateWeaveForge._destroy_gamepad_gui(arg_9_0)
	local var_9_0 = arg_9_0._gui_data

	if var_9_0 then
		for iter_9_0, iter_9_1 in pairs(var_9_0) do
			local var_9_1 = iter_9_1.renderer
			local var_9_2 = iter_9_1.world
			local var_9_3 = iter_9_1.viewport_name

			UIRenderer.destroy(var_9_1, var_9_2)
			ScriptWorld.destroy_viewport(var_9_2, var_9_3)
			Managers.world:destroy_world(var_9_2)
		end

		arg_9_0._gui_data = nil
	end
end

function HeroViewStateWeaveForge._setup_menu_layout(arg_10_0)
	local var_10_0 = IS_CONSOLE or Managers.input:is_device_active("gamepad") or not UISettings.use_pc_menu_layout

	arg_10_0._layout_settings = local_require("scripts/ui/views/hero_view/states/weave_forge_window_layout")
	arg_10_0._windows_settings = arg_10_0._layout_settings.windows
	arg_10_0._window_layouts = arg_10_0._layout_settings.window_layouts
	arg_10_0._max_active_windows = arg_10_0._layout_settings.max_active_windows

	return var_10_0
end

function HeroViewStateWeaveForge.create_ui_elements(arg_11_0, arg_11_1)
	arg_11_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_11_0._console_cursor_widget = UIWidget.init(var_0_4)

	local var_11_0 = {}
	local var_11_1 = {}

	for iter_11_0, iter_11_1 in pairs(var_0_1) do
		if iter_11_1 then
			local var_11_2 = UIWidget.init(iter_11_1)

			var_11_0[#var_11_0 + 1] = var_11_2
			var_11_1[iter_11_0] = var_11_2
		end
	end

	arg_11_0._widgets = var_11_0
	arg_11_0._widgets_by_name = var_11_1
	var_11_1.loading_icon.content.visible = false

	UIRenderer.clear_scenegraph_queue(arg_11_0.ui_renderer)

	arg_11_0.ui_animator = UIAnimator:new(arg_11_0.ui_scenegraph, var_0_3)

	local var_11_3 = UILayer.default + 30
	local var_11_4 = arg_11_0:input_service()
	local var_11_5 = arg_11_0._gamepad_style_active

	arg_11_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_11_0.ui_top_renderer, var_11_4, 6, var_11_3, var_0_5.default, var_11_5)

	arg_11_0._menu_input_description:set_input_description(nil)

	arg_11_0._current_input_desc = nil
end

function HeroViewStateWeaveForge.set_input_description(arg_12_0, arg_12_1)
	local var_12_0 = var_0_5[arg_12_1]

	if arg_12_0._current_input_desc == arg_12_1 then
		return
	end

	if var_12_0 then
		arg_12_0._menu_input_description:set_input_description(var_12_0)
	else
		arg_12_0._menu_input_description:set_input_description(nil)
	end

	arg_12_0._current_input_desc = arg_12_1
end

function HeroViewStateWeaveForge.disable_player_world(arg_13_0)
	if not arg_13_0._player_world_disabled then
		arg_13_0._player_world_disabled = true

		local var_13_0 = "player_1"
		local var_13_1 = Managers.world:world("level_world")
		local var_13_2 = ScriptWorld.viewport(var_13_1, var_13_0)

		ScriptWorld.deactivate_viewport(var_13_1, var_13_2)
	end
end

function HeroViewStateWeaveForge.enable_player_world(arg_14_0)
	if arg_14_0._player_world_disabled then
		arg_14_0._player_world_disabled = false

		local var_14_0 = "player_1"
		local var_14_1 = Managers.world:world("level_world")
		local var_14_2 = ScriptWorld.viewport(var_14_1, var_14_0)

		ScriptWorld.activate_viewport(var_14_1, var_14_2)
	end
end

function HeroViewStateWeaveForge.enable_ingame_overlay(arg_15_0)
	if not arg_15_0._ingame_overlay_enabled then
		arg_15_0._ingame_overlay_enabled = true

		local var_15_0 = Managers.world:world("level_world")

		World.set_data(var_15_0, "fullscreen_blur", 0.5)
		World.set_data(var_15_0, "greyscale", 1)
	end
end

function HeroViewStateWeaveForge.disable_ingame_overlay(arg_16_0)
	if arg_16_0._ingame_overlay_enabled then
		arg_16_0._ingame_overlay_enabled = false

		local var_16_0 = Managers.world:world("level_world")

		World.set_data(var_16_0, "fullscreen_blur", nil)
		World.set_data(var_16_0, "greyscale", nil)
	end
end

function HeroViewStateWeaveForge._initial_windows_setups(arg_17_0, arg_17_1)
	arg_17_0._active_windows = {}
	arg_17_0._window_params = arg_17_1
	arg_17_0._layouts_index_history = {}

	local var_17_0 = arg_17_1.start_state

	if var_17_0 then
		arg_17_0:set_layout_by_name(var_17_0)
	else
		arg_17_0:set_layout(1)
	end
end

function HeroViewStateWeaveForge.window_input_service(arg_18_0)
	return arg_18_0._input_blocked and FAKE_INPUT_SERVICE or arg_18_0:input_service()
end

function HeroViewStateWeaveForge._close_window_at_index(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._active_windows
	local var_19_1 = arg_19_0._window_params
	local var_19_2 = var_19_0[arg_19_1]

	if var_19_2 and var_19_2.on_exit then
		var_19_2:on_exit(var_19_1)
	end

	var_19_0[arg_19_1] = nil
end

function HeroViewStateWeaveForge._change_window(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._active_windows
	local var_20_1 = arg_20_0._windows_settings[arg_20_2]
	local var_20_2 = var_20_1.class_name
	local var_20_3 = var_20_0[arg_20_1]

	if var_20_3 then
		if var_20_3.NAME == var_20_2 then
			return
		end

		arg_20_0:_close_window_at_index(arg_20_1)
	end

	local var_20_4 = rawget(_G, var_20_2):new()
	local var_20_5 = var_20_1.ignore_alignment
	local var_20_6

	if not var_20_5 then
		local var_20_7 = var_20_1.alignment_index or arg_20_1
		local var_20_8 = UISettings.game_start_windows
		local var_20_9 = var_20_8.size
		local var_20_10 = var_20_8.spacing or 10
		local var_20_11 = var_20_9[1]
		local var_20_12 = var_20_10 * 2
		local var_20_13 = -(3 * var_20_11 / 2 + var_20_11 / 2) - (var_20_12 / 2 + var_20_10) + var_20_7 * var_20_11 + var_20_7 * var_20_10

		var_20_6 = {
			var_20_13,
			0,
			3
		}
	end

	if var_20_4.on_enter then
		local var_20_14 = arg_20_0._window_params

		var_20_4:on_enter(var_20_14, var_20_6)
	end

	var_20_0[arg_20_1] = var_20_4
end

function HeroViewStateWeaveForge.get_layout_name(arg_21_0)
	local var_21_0 = arg_21_0._selected_layout_index

	for iter_21_0, iter_21_1 in ipairs(arg_21_0._window_layouts) do
		if iter_21_0 == var_21_0 then
			return iter_21_1.name
		end
	end
end

function HeroViewStateWeaveForge.set_layout_by_name(arg_22_0, arg_22_1)
	for iter_22_0, iter_22_1 in ipairs(arg_22_0._window_layouts) do
		if iter_22_1.name == arg_22_1 then
			arg_22_0:set_layout(iter_22_0)

			return
		end
	end
end

function HeroViewStateWeaveForge.close_on_exit(arg_23_0)
	return arg_23_0._close_on_exit
end

function HeroViewStateWeaveForge.set_layout(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0:_get_layout_setting(arg_24_1)
	local var_24_1 = var_24_0.windows
	local var_24_2 = var_24_0.sound_event_enter
	local var_24_3 = var_24_0.close_on_exit
	local var_24_4 = var_24_0.input_focus_window
	local var_24_5 = var_24_0.name

	if var_24_2 then
		arg_24_0:play_sound(var_24_2)
	end

	arg_24_0._widgets_by_name.exit_button.content.visible = var_24_3
	arg_24_0._widgets_by_name.back_button.content.visible = not var_24_3
	arg_24_0._close_on_exit = var_24_3

	for iter_24_0 = 1, arg_24_0._max_active_windows do
		local var_24_6 = false

		for iter_24_1, iter_24_2 in pairs(var_24_1) do
			if iter_24_2 == iter_24_0 then
				arg_24_0:_change_window(iter_24_2, iter_24_1)

				var_24_6 = true
			end
		end

		if not var_24_6 then
			arg_24_0:_close_window_at_index(iter_24_0)
		end
	end

	if arg_24_0._selected_layout_index then
		arg_24_0._previous_selected_layout_index = arg_24_0._selected_layout_index

		if not arg_24_2 then
			arg_24_0._layouts_index_history[#arg_24_0._layouts_index_history + 1] = arg_24_0._previous_selected_layout_index
		end
	end

	arg_24_0._selected_layout_name = var_24_5
	arg_24_0._selected_layout_index = arg_24_1

	arg_24_0:set_window_input_focus(var_24_4)
end

function HeroViewStateWeaveForge.set_window_input_focus(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._selected_layout_index
	local var_25_1 = arg_25_0:_get_layout_setting(var_25_0)
	local var_25_2 = arg_25_0._windows_settings[arg_25_1]
	local var_25_3 = var_25_2 and var_25_2.class_name
	local var_25_4 = false
	local var_25_5 = arg_25_0._active_windows

	for iter_25_0, iter_25_1 in pairs(var_25_5) do
		local var_25_6 = iter_25_1.NAME == var_25_3

		if iter_25_1.set_focus then
			iter_25_1:set_focus(var_25_6)
		end

		if var_25_6 then
			var_25_4 = true
		end
	end

	if arg_25_1 and not var_25_4 then
		ferror("[HeroViewStateWeaveForge] - (set_window_input_focus) Could not find a window by name: %s", arg_25_1)
	end

	arg_25_0._window_focused = arg_25_1
end

function HeroViewStateWeaveForge.get_selected_layout_name(arg_26_0)
	return arg_26_0._selected_layout_name
end

function HeroViewStateWeaveForge.get_selected_layout_index(arg_27_0)
	return arg_27_0._selected_layout_index
end

function HeroViewStateWeaveForge.get_previous_selected_layout_index(arg_28_0)
	return arg_28_0._previous_selected_layout_index
end

function HeroViewStateWeaveForge._get_layout_setting(arg_29_0, arg_29_1)
	return arg_29_0._window_layouts[arg_29_1]
end

function HeroViewStateWeaveForge._windows_update(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._active_windows

	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		iter_30_1:update(arg_30_1, arg_30_2)
	end
end

function HeroViewStateWeaveForge._windows_post_update(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0._active_windows

	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		if iter_31_1.post_update then
			iter_31_1:post_update(arg_31_1, arg_31_2)
		end
	end
end

function HeroViewStateWeaveForge.enable_widget(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_0._active_windows[arg_32_1]._widgets_by_name[arg_32_2]

	if var_32_0 then
		local var_32_1 = var_32_0.content.button_hotspot

		if var_32_1 then
			var_32_1.disable_button = not arg_32_3
		end
	end
end

function HeroViewStateWeaveForge.transitioning(arg_33_0)
	if arg_33_0.exiting then
		return true
	else
		return false
	end
end

function HeroViewStateWeaveForge._wanted_state(arg_34_0)
	return (arg_34_0.parent:wanted_state())
end

function HeroViewStateWeaveForge.wanted_menu_state(arg_35_0)
	return arg_35_0._wanted_menu_state
end

function HeroViewStateWeaveForge.clear_wanted_menu_state(arg_36_0)
	arg_36_0._wanted_menu_state = nil
end

function HeroViewStateWeaveForge.requested_screen_change_by_name(arg_37_0, arg_37_1)
	arg_37_0._on_close_next_state = arg_37_1

	arg_37_0:close_menu()
end

function HeroViewStateWeaveForge.on_exit(arg_38_0, arg_38_1)
	print("[HeroViewState] Exit Substate HeroViewStateWeaveForge")

	arg_38_0.ui_animator = nil

	local var_38_0 = arg_38_0._friends_component_ui

	if var_38_0 and arg_38_0:is_friends_list_active() then
		var_38_0:deactivate_friends_ui()
	end

	if arg_38_0._fullscreen_effect_enabled then
		arg_38_0:set_fullscreen_effect_enable_state(false)
	end

	arg_38_0:_close_active_windows()

	if arg_38_0._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_exit()

		if arg_38_0.is_in_inn then
			arg_38_0:play_sound("play_gui_amb_hero_screen_loop_end")
			arg_38_0:_destroy_gamepad_gui()
			arg_38_0:enable_player_world()
		else
			arg_38_0:disable_ingame_overlay()
		end
	else
		arg_38_0:play_sound("hud_magic_forge_close")
	end

	Managers.input:disable_gamepad_cursor()
end

function HeroViewStateWeaveForge._close_active_windows(arg_39_0)
	local var_39_0 = arg_39_0._active_windows
	local var_39_1 = arg_39_0._window_params

	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if iter_39_1.on_exit then
			iter_39_1:on_exit(var_39_1)
		end
	end

	table.clear(var_39_0)
end

function HeroViewStateWeaveForge._update_transition_timer(arg_40_0, arg_40_1)
	if not arg_40_0._transition_timer then
		return
	end

	if arg_40_0._transition_timer == 0 then
		arg_40_0._transition_timer = nil
	else
		arg_40_0._transition_timer = math.max(arg_40_0._transition_timer - arg_40_1, 0)
	end
end

function HeroViewStateWeaveForge.input_service(arg_41_0)
	return arg_41_0.parent:input_service()
end

function HeroViewStateWeaveForge.update(arg_42_0, arg_42_1, arg_42_2)
	if var_0_6 then
		var_0_6 = false

		arg_42_0:create_ui_elements()
	end

	local var_42_0 = arg_42_0.input_manager
	local var_42_1 = arg_42_0:window_input_service()
	local var_42_2 = arg_42_0._friends_component_ui
	local var_42_3 = var_42_0:is_device_active("gamepad")

	if var_42_2 and not var_42_3 and Managers.account:is_online() then
		var_42_2:update(arg_42_1, var_42_1)
	end

	if not arg_42_0._gamepad_style_active then
		arg_42_0:draw(var_42_1, arg_42_1)
	else
		arg_42_0:draw_gamepad_cursor(var_42_1, arg_42_1)
	end

	arg_42_0:_update_transition_timer(arg_42_1)
	arg_42_0:_windows_update(arg_42_1, arg_42_2)

	local var_42_4 = arg_42_0.parent:transitioning()
	local var_42_5 = arg_42_0:_wanted_state()

	if not arg_42_0._transition_timer then
		if not var_42_4 and arg_42_0:_has_active_level_vote() then
			local var_42_6 = true

			arg_42_0:close_menu(var_42_6)
		end

		if var_42_5 then
			arg_42_0.parent:clear_wanted_state()

			arg_42_0._new_state = var_42_5
		else
			return arg_42_0._new_state
		end
	end
end

function HeroViewStateWeaveForge.is_friends_list_active(arg_43_0)
	local var_43_0 = arg_43_0._friends_component_ui

	if var_43_0 then
		return var_43_0:is_active()
	end

	return false
end

function HeroViewStateWeaveForge._handle_friend_joining(arg_44_0)
	local var_44_0 = arg_44_0._friends_component_ui

	if var_44_0 then
		local var_44_1 = var_44_0:join_lobby_data()

		if var_44_1 and Managers.matchmaking:allowed_to_initiate_join_lobby() then
			Managers.matchmaking:request_join_lobby(var_44_1)
			arg_44_0:close_menu(true)

			return true
		end
	end
end

function HeroViewStateWeaveForge._has_active_level_vote(arg_45_0)
	local var_45_0 = arg_45_0.voting_manager

	return var_45_0:vote_in_progress() and var_45_0:is_mission_vote() and not var_45_0:has_voted(Network.peer_id())
end

function HeroViewStateWeaveForge.post_update(arg_46_0, arg_46_1, arg_46_2)
	arg_46_0.ui_animator:update(arg_46_1)
	arg_46_0:_update_animations(arg_46_1)

	if not arg_46_0._transition_timer and not arg_46_0._new_state and not arg_46_0.parent:transitioning() and not arg_46_0:_has_active_level_vote() then
		arg_46_0:_handle_input(arg_46_1, arg_46_2)
	end

	arg_46_0:_windows_post_update(arg_46_1, arg_46_2)

	if arg_46_0._new_state then
		arg_46_0:_close_active_windows()
	end
end

function HeroViewStateWeaveForge._update_animations(arg_47_0, arg_47_1)
	for iter_47_0, iter_47_1 in pairs(arg_47_0._ui_animations) do
		UIAnimation.update(iter_47_1, arg_47_1)

		if UIAnimation.completed(iter_47_1) then
			arg_47_0._ui_animations[iter_47_0] = nil
		end
	end

	local var_47_0 = arg_47_0._animations
	local var_47_1 = arg_47_0.ui_animator

	for iter_47_2, iter_47_3 in pairs(var_47_0) do
		if var_47_1:is_animation_completed(iter_47_3) then
			var_47_1:stop_animation(iter_47_3)

			var_47_0[iter_47_2] = nil
		end
	end
end

function HeroViewStateWeaveForge._is_button_hover_enter(arg_48_0, arg_48_1)
	return arg_48_1.content.button_hotspot.on_hover_enter
end

function HeroViewStateWeaveForge._handle_input(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._input_blocked
	local var_49_1 = arg_49_0._window_focused

	if var_49_0 then
		return
	end

	if arg_49_0:_handle_friend_joining() then
		return
	end

	local var_49_2 = arg_49_0._widgets_by_name
	local var_49_3 = arg_49_0.parent:input_service()
	local var_49_4 = var_49_3:get("toggle_menu", true)
	local var_49_5 = Managers.input:is_device_active("gamepad") and var_49_3:get("back_menu", true)
	local var_49_6 = arg_49_0._close_on_exit
	local var_49_7 = var_49_2.exit_button
	local var_49_8 = var_49_2.back_button

	UIWidgetUtils.animate_default_button(var_49_7, arg_49_1)
	UIWidgetUtils.animate_default_button(var_49_8, arg_49_1)

	if arg_49_0:_is_button_hover_enter(var_49_8) or arg_49_0:_is_button_hover_enter(var_49_7) then
		arg_49_0:play_sound("play_gui_equipment_button_hover")
	end

	if var_49_6 and (var_49_5 or var_49_4 or arg_49_0:_is_button_pressed(var_49_7)) then
		arg_49_0:play_sound("Play_hud_hover")
		arg_49_0:close_menu()

		return
	elseif var_49_4 or var_49_5 or arg_49_0:_is_button_pressed(var_49_8) then
		arg_49_0:play_sound("Play_hud_hover")

		local var_49_9 = arg_49_0:get_previous_selected_layout_index()
		local var_49_10 = arg_49_0._layouts_index_history

		if var_49_10 and #var_49_10 >= 1 then
			local var_49_11 = var_49_10[#var_49_10]

			var_49_10[#var_49_10] = nil

			arg_49_0:set_layout(var_49_11, true)
		end
	end
end

function HeroViewStateWeaveForge.close_menu(arg_50_0, arg_50_1)
	if arg_50_0._on_close_next_state then
		arg_50_0.parent:requested_screen_change_by_name(arg_50_0._on_close_next_state)
	else
		arg_50_0.parent:close_menu(nil, arg_50_1)
	end
end

function HeroViewStateWeaveForge.draw_gamepad_cursor(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0:get_ui_renderer()
	local var_51_1 = arg_51_0:get_ui_top_renderer()
	local var_51_2 = arg_51_0.ui_scenegraph
	local var_51_3 = arg_51_0.input_manager
	local var_51_4 = arg_51_0.render_settings

	if var_51_3:is_device_active("gamepad") then
		UIRenderer.begin_pass(var_51_1, var_51_2, arg_51_1, arg_51_2)
		UIRenderer.draw_widget(var_51_1, arg_51_0._console_cursor_widget)
		UIRenderer.end_pass(var_51_1)

		if arg_51_0._menu_input_description then
			arg_51_0._menu_input_description:draw(var_51_1, arg_51_2)
		end
	end
end

function HeroViewStateWeaveForge.draw(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0.ui_renderer
	local var_52_1 = arg_52_0.ui_top_renderer
	local var_52_2 = arg_52_0.ui_scenegraph
	local var_52_3 = arg_52_0.input_manager
	local var_52_4 = arg_52_0.render_settings
	local var_52_5 = var_52_3:is_device_active("gamepad")

	UIRenderer.begin_pass(var_52_1, var_52_2, arg_52_1, arg_52_2, nil, var_52_4)

	local var_52_6 = var_52_4.snap_pixel_positions

	for iter_52_0, iter_52_1 in ipairs(arg_52_0._widgets) do
		if iter_52_1.snap_pixel_positions ~= nil then
			var_52_4.snap_pixel_positions = iter_52_1.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_52_1, iter_52_1)

		var_52_4.snap_pixel_positions = var_52_6
	end

	UIRenderer.end_pass(var_52_1)

	if var_52_5 then
		UIRenderer.begin_pass(var_52_1, var_52_2, arg_52_1, arg_52_2)
		UIRenderer.draw_widget(var_52_1, arg_52_0._console_cursor_widget)
		UIRenderer.end_pass(var_52_1)

		if arg_52_0._menu_input_description then
			arg_52_0._menu_input_description:draw(var_52_1, arg_52_2)
		end
	end
end

function HeroViewStateWeaveForge._is_button_pressed(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_1.content
	local var_53_1 = var_53_0.button_hotspot or var_53_0.hotspot

	if var_53_1.on_release then
		var_53_1.on_release = false

		return true
	end
end

function HeroViewStateWeaveForge.play_sound(arg_54_0, arg_54_1)
	arg_54_0.parent:play_sound(arg_54_1)
end

function HeroViewStateWeaveForge._start_transition_animation(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = {
		wwise_world = arg_55_0.wwise_world,
		render_settings = arg_55_0.render_settings
	}
	local var_55_1 = {}
	local var_55_2 = arg_55_0.ui_animator:start_animation(arg_55_2, var_55_1, var_0_2, var_55_0)

	arg_55_0._animations[arg_55_1] = var_55_2
end

function HeroViewStateWeaveForge.set_fullscreen_effect_enable_state(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.ui_renderer.world
	local var_56_1 = World.get_data(var_56_0, "shading_environment")

	if var_56_1 then
		ShadingEnvironment.set_scalar(var_56_1, "fullscreen_blur_enabled", arg_56_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_56_1, "fullscreen_blur_amount", arg_56_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_56_1)
	end

	arg_56_0._fullscreen_effect_enabled = arg_56_1
end

function HeroViewStateWeaveForge.block_input(arg_57_0, arg_57_1)
	arg_57_0._input_blocked = true

	local var_57_0 = arg_57_0._widgets_by_name

	if arg_57_1 then
		var_57_0.loading_icon.content.visible = true
	end

	var_57_0.exit_button.content.button_hotspot.disable_button = true
	var_57_0.back_button.content.button_hotspot.disable_button = true

	arg_57_0.parent:set_input_blocked(true)
end

function HeroViewStateWeaveForge.unblock_input(arg_58_0)
	arg_58_0._input_blocked = false

	local var_58_0 = arg_58_0._widgets_by_name

	var_58_0.loading_icon.content.visible = false
	var_58_0.exit_button.content.button_hotspot.disable_button = false
	var_58_0.back_button.content.button_hotspot.disable_button = false

	arg_58_0.parent:set_input_blocked(false)
end

function HeroViewStateWeaveForge.input_blocked(arg_59_0)
	return arg_59_0._input_blocked
end
