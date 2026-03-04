-- chunkname: @scripts/ui/views/start_menu_view/start_menu_view.lua

require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/character_selection_view/states/character_selection_state_character")
require("scripts/ui/views/start_menu_view/states/start_menu_state_overview")
require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/start_menu_view/start_menu_view_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.settings_by_screen
local var_0_4 = var_0_0.attachments
local var_0_5 = var_0_0.flow_events

local function var_0_6(...)
	print("[StartMenuView]", ...)
end

local var_0_7 = true
local var_0_8 = false
local var_0_9 = true

StartMenuView = class(StartMenuView)

StartMenuView.init = function (arg_2_0, arg_2_1)
	arg_2_0.world = arg_2_1.world
	arg_2_0.player_manager = arg_2_1.player_manager
	arg_2_0.ui_renderer = arg_2_1.ui_renderer
	arg_2_0.ui_top_renderer = arg_2_1.ui_top_renderer
	arg_2_0.ingame_ui = arg_2_1.ingame_ui
	arg_2_0.voting_manager = arg_2_1.voting_manager
	arg_2_0.profile_synchronizer = arg_2_1.profile_synchronizer
	arg_2_0.peer_id = arg_2_1.peer_id
	arg_2_0.local_player_id = arg_2_1.local_player_id
	arg_2_0.is_server = arg_2_1.is_server
	arg_2_0.is_in_inn = arg_2_1.is_in_inn
	arg_2_0.world_manager = arg_2_1.world_manager

	local var_2_0 = arg_2_0.world_manager:world("level_world")

	arg_2_0.wwise_world = Managers.world:wwise_world(var_2_0)

	local var_2_1 = arg_2_1.input_manager

	arg_2_0.input_manager = var_2_1

	var_2_1:create_input_service("start_menu_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_2_1:map_device_to_service("start_menu_view", "keyboard")
	var_2_1:map_device_to_service("start_menu_view", "mouse")
	var_2_1:map_device_to_service("start_menu_view", "gamepad")

	arg_2_0.world_previewer = MenuWorldPreviewer:new(arg_2_1, UISettings.hero_selection_camera_position_by_character, "StartMenuView")

	arg_2_0.world_previewer:force_stream_highest_mip_levels()

	arg_2_0._state_machine_params = {
		wwise_world = arg_2_0.wwise_world,
		ingame_ui_context = arg_2_1,
		parent = arg_2_0,
		world_previewer = arg_2_0.world_previewer,
		settings_by_screen = var_0_3,
		input_service = FAKE_INPUT_SERVICE
	}
	arg_2_0.units = {}
	arg_2_0.attachment_units = {}
	arg_2_0.unit_states = {}
	arg_2_0.ui_animations = {}
	arg_2_0.ingame_ui_context = arg_2_1
	var_0_7 = false
end

StartMenuView.initial_profile_view = function (arg_3_0)
	return arg_3_0.ingame_ui.initial_profile_view
end

StartMenuView._setup_state_machine = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_0._machine then
		arg_4_0._machine:destroy()

		arg_4_0._machine = nil
	end

	local var_4_0 = arg_4_2 or StartMenuStateOverview
	local var_4_1 = false

	arg_4_1.start_state = arg_4_3
	arg_4_1.state_params = arg_4_4
	arg_4_0._machine = GameStateMachine:new(arg_4_0, var_4_0, arg_4_1, var_4_1)
	arg_4_0._state_machine_params = arg_4_1
	arg_4_1.state_params = nil
end

StartMenuView.wanted_state = function (arg_5_0)
	return arg_5_0._wanted_state
end

StartMenuView.clear_wanted_state = function (arg_6_0)
	arg_6_0._wanted_state = nil
end

StartMenuView.input_service = function (arg_7_0, arg_7_1)
	if not arg_7_1 then
		local var_7_0 = arg_7_0._machine

		if var_7_0 then
			return var_7_0:state():input_service()
		end
	end

	return arg_7_0.input_manager:get_service("start_menu_view")
end

StartMenuView.set_input_blocked = function (arg_8_0, arg_8_1)
	arg_8_0._input_blocked = arg_8_1
end

StartMenuView.input_blocked = function (arg_9_0)
	return arg_9_0._input_blocked
end

StartMenuView.play_sound = function (arg_10_0, arg_10_1)
	WwiseWorld.trigger_event(arg_10_0.wwise_world, arg_10_1)
end

StartMenuView.create_ui_elements = function (arg_11_0)
	arg_11_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_11_0._static_widgets = {}
	arg_11_0._exit_button_widget = UIWidget.init(var_0_1.exit_button)
	arg_11_0._console_cursor_widget = UIWidget.init(var_0_1.console_cursor)

	UIRenderer.clear_scenegraph_queue(arg_11_0.ui_top_renderer)

	arg_11_0.ui_animator = UIAnimator:new(arg_11_0.ui_scenegraph, var_0_0.animations)
end

StartMenuView.get_background_world = function (arg_12_0)
	local var_12_0 = arg_12_0.viewport_widget.element.pass_data[1]
	local var_12_1 = var_12_0.viewport

	return var_12_0.world, var_12_1
end

StartMenuView.show_hero_world = function (arg_13_0)
	if not arg_13_0._draw_menu_world then
		arg_13_0._draw_menu_world = true

		local var_13_0 = "player_1"
		local var_13_1 = Managers.world:world("level_world")
		local var_13_2 = ScriptWorld.viewport(var_13_1, var_13_0)

		ScriptWorld.deactivate_viewport(var_13_1, var_13_2)
	end
end

StartMenuView.hide_hero_world = function (arg_14_0)
	if arg_14_0._draw_menu_world then
		arg_14_0._draw_menu_world = false

		local var_14_0 = "player_1"
		local var_14_1 = Managers.world:world("level_world")
		local var_14_2 = ScriptWorld.viewport(var_14_1, var_14_0)

		ScriptWorld.activate_viewport(var_14_1, var_14_2)
	end
end

StartMenuView.draw = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.ui_renderer
	local var_15_1 = arg_15_0.ui_top_renderer
	local var_15_2 = arg_15_0.ui_scenegraph
	local var_15_3 = arg_15_0.input_manager:is_device_active("gamepad")
	local var_15_4 = arg_15_0:initial_profile_view()

	UIRenderer.begin_pass(var_15_1, var_15_2, arg_15_2, arg_15_1)

	if var_0_8 then
		UISceneGraph.debug_render_scenegraph(var_15_1, var_15_2)
	end

	if not var_15_4 then
		UIRenderer.draw_widget(var_15_1, arg_15_0._exit_button_widget)
	end

	if var_15_3 then
		UIRenderer.draw_widget(var_15_1, arg_15_0._console_cursor_widget)
	end

	if arg_15_0.viewport_widget and arg_15_0._draw_menu_world then
		UIRenderer.draw_widget(var_15_1, arg_15_0.viewport_widget)
	end

	UIRenderer.end_pass(var_15_1)
end

StartMenuView.post_update = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._machine:post_update(arg_16_1, arg_16_2)
	arg_16_0.world_previewer:post_update(arg_16_1, arg_16_2)
end

StartMenuView._has_active_level_vote = function (arg_17_0)
	local var_17_0 = arg_17_0.voting_manager

	return var_17_0:vote_in_progress() and var_17_0:is_mission_vote() and not var_17_0:has_voted(Network.peer_id())
end

StartMenuView.update = function (arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0.suspended or arg_18_0.waiting_for_post_update_enter then
		return
	end

	if arg_18_0:_has_active_level_vote() then
		arg_18_0:close_menu(false)
	end

	local var_18_0 = arg_18_0._requested_screen_change_data

	if var_18_0 then
		local var_18_1 = var_18_0.screen_name
		local var_18_2 = var_18_0.sub_screen_name

		arg_18_0:_change_screen_by_name(var_18_1, var_18_2)

		arg_18_0._requested_screen_change_data = nil
	end

	local var_18_3 = true
	local var_18_4 = arg_18_0.input_manager
	local var_18_5 = var_18_4:is_device_active("gamepad")
	local var_18_6 = arg_18_0:input_blocked() and not var_18_5 and FAKE_INPUT_SERVICE or var_18_4:get_service("start_menu_view")

	arg_18_0._state_machine_params.input_service = var_18_6

	local var_18_7 = arg_18_0:transitioning()

	arg_18_0.ui_animator:update(arg_18_1)
	arg_18_0.world_previewer:update(arg_18_1, arg_18_2)

	for iter_18_0, iter_18_1 in pairs(arg_18_0.ui_animations) do
		UIAnimation.update(iter_18_1, arg_18_1)

		if UIAnimation.completed(iter_18_1) then
			arg_18_0.ui_animations[iter_18_0] = nil
		end
	end

	if not var_18_7 then
		arg_18_0:_handle_mouse_input(arg_18_1, arg_18_2, var_18_6)
		arg_18_0:_handle_exit(var_18_6)
	end

	arg_18_0._machine:update(arg_18_1, arg_18_2)
	arg_18_0:draw(arg_18_1, var_18_6)
end

StartMenuView.on_enter = function (arg_19_0, arg_19_1)
	ShowCursorStack.show("StartMenuView")

	local var_19_0 = arg_19_0.input_manager

	var_19_0:block_device_except_service("start_menu_view", "keyboard", 1)
	var_19_0:block_device_except_service("start_menu_view", "mouse", 1)
	var_19_0:block_device_except_service("start_menu_view", "gamepad", 1)

	arg_19_0._state_machine_params.initial_state = true

	arg_19_0:create_ui_elements()

	local var_19_1 = arg_19_0.profile_synchronizer:profile_by_peer(arg_19_0.peer_id, arg_19_0.local_player_id)

	if var_19_1 then
		arg_19_0:set_current_hero(var_19_1)
	end

	arg_19_0.waiting_for_post_update_enter = true
	arg_19_0._on_enter_transition_params = arg_19_1

	Managers.music:duck_sounds()
	arg_19_0:play_sound("play_gui_amb_start_screen_enter")
	arg_19_0:play_sound("play_gui_amb_hero_screen_loop_begin")
	arg_19_0:play_sound("Play_menu_screen_music")
	UISettings.hero_fullscreen_menu_on_enter()
end

StartMenuView.set_current_hero = function (arg_20_0, arg_20_1)
	local var_20_0 = SPProfiles[arg_20_1]
	local var_20_1 = var_20_0.display_name
	local var_20_2 = var_20_0.character_name

	arg_20_0._hero_name = var_20_1
	arg_20_0._state_machine_params.hero_name = var_20_1
end

StartMenuView._get_sorted_players = function (arg_21_0)
	local var_21_0 = arg_21_0.player_manager:human_players()
	local var_21_1 = {}

	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		var_21_1[#var_21_1 + 1] = iter_21_1
	end

	table.sort(var_21_1, function (arg_22_0, arg_22_1)
		return arg_22_0.local_player and not arg_22_1.local_player
	end)

	return var_21_1
end

StartMenuView._handle_mouse_input = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	return
end

StartMenuView._is_selection_widget_pressed = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1.content
	local var_24_1 = var_24_0.steps

	for iter_24_0 = 1, var_24_1 do
		if var_24_0["hotspot_" .. iter_24_0].on_release then
			return true, iter_24_0
		end
	end
end

StartMenuView.hotkey_allowed = function (arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0:input_blocked() then
		return false
	end

	local var_25_0 = arg_25_2.transition_state
	local var_25_1 = arg_25_2.transition_sub_state
	local var_25_2 = arg_25_0._machine

	if var_25_2 then
		local var_25_3 = var_25_2:state()
		local var_25_4 = var_25_3.NAME

		if arg_25_0:_get_screen_settings_by_state_name(var_25_4).name == var_25_0 then
			local var_25_5 = var_25_3.get_selected_layout_name and var_25_3:get_selected_layout_name()

			if not var_25_1 or var_25_1 == var_25_5 then
				return true
			elseif var_25_1 then
				var_25_3:requested_screen_change_by_name(var_25_1)
			end
		elseif var_25_0 then
			arg_25_0:requested_screen_change_by_name(var_25_0, var_25_1)
		else
			return true
		end
	end

	return false
end

StartMenuView._get_screen_settings_by_state_name = function (arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in ipairs(var_0_3) do
		if iter_26_1.state_name == arg_26_1 then
			return iter_26_1
		end
	end
end

StartMenuView.requested_screen_change_by_name = function (arg_27_0, arg_27_1, arg_27_2)
	arg_27_0._requested_screen_change_data = {
		screen_name = arg_27_1,
		sub_screen_name = arg_27_2
	}
end

StartMenuView._change_screen_by_name = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0
	local var_28_1

	for iter_28_0, iter_28_1 in ipairs(var_0_3) do
		if iter_28_1.name == arg_28_1 then
			var_28_0 = iter_28_1
			var_28_1 = iter_28_0

			break
		end
	end

	fassert(var_28_1, "[StartMenuView] - Could not find state by name %s", arg_28_1)

	local var_28_2 = var_28_0.state_name
	local var_28_3 = rawget(_G, var_28_2)

	if arg_28_0._machine and not arg_28_2 then
		arg_28_0._wanted_state = var_28_3
	else
		arg_28_0:_setup_state_machine(arg_28_0._state_machine_params, var_28_3, arg_28_2, arg_28_3)
	end

	if var_28_0.draw_background_world then
		arg_28_0:show_hero_world()
	else
		arg_28_0:hide_hero_world()
	end

	local var_28_4 = var_28_0.camera_position

	if var_28_4 then
		arg_28_0.world_previewer:set_camera_axis_offset("x", var_28_4[1], 0.5, math.easeOutCubic)
		arg_28_0.world_previewer:set_camera_axis_offset("y", var_28_4[2], 0.5, math.easeOutCubic)
		arg_28_0.world_previewer:set_camera_axis_offset("z", var_28_4[3], 0.5, math.easeOutCubic)
	end

	local var_28_5 = var_28_0.camera_rotation

	if var_28_5 then
		arg_28_0.world_previewer:set_camera_rotation_axis_offset("x", var_28_5[1], 0.5, math.easeOutCubic)
		arg_28_0.world_previewer:set_camera_rotation_axis_offset("y", var_28_5[2], 0.5, math.easeOutCubic)
		arg_28_0.world_previewer:set_camera_rotation_axis_offset("z", var_28_5[3], 0.5, math.easeOutCubic)
	end
end

StartMenuView._change_screen_by_index = function (arg_29_0, arg_29_1)
	local var_29_0 = var_0_3[arg_29_1].name

	arg_29_0:_change_screen_by_name(var_29_0)
end

StartMenuView.post_update_on_enter = function (arg_30_0)
	assert(arg_30_0.viewport_widget == nil)

	arg_30_0.viewport_widget = UIWidget.init(var_0_1.viewport)
	arg_30_0.waiting_for_post_update_enter = nil

	arg_30_0.world_previewer:on_enter(arg_30_0.viewport_widget, arg_30_0._hero_name)

	local var_30_0 = arg_30_0._on_enter_transition_params

	if var_30_0 and var_30_0.menu_state_name then
		local var_30_1 = var_30_0.menu_state_name
		local var_30_2 = var_30_0.menu_sub_state_name

		arg_30_0:_change_screen_by_name(var_30_1, var_30_2, var_30_0)

		arg_30_0._on_enter_transition_params = nil
	else
		arg_30_0:_change_screen_by_index(1)
	end
end

StartMenuView.post_update_on_exit = function (arg_31_0)
	arg_31_0.world_previewer:prepare_exit()
	arg_31_0.world_previewer:on_exit()

	if arg_31_0.viewport_widget then
		UIWidget.destroy(arg_31_0.ui_top_renderer, arg_31_0.viewport_widget)

		arg_31_0.viewport_widget = nil
	end

	if arg_31_0:initial_profile_view() then
		local var_31_0 = Managers.world

		if var_31_0:has_world("level_world") then
			local var_31_1 = var_31_0:world("level_world")
			local var_31_2 = Managers.mechanism:game_mechanism():get_hub_level_key()
			local var_31_3 = LevelSettings[var_31_2].level_name
			local var_31_4 = ScriptWorld.level(var_31_1, var_31_3)

			if var_31_4 then
				Level.trigger_event(var_31_4, "play_keep_intro_cutscene")
			end
		end
	end
end

StartMenuView.on_exit = function (arg_32_0)
	arg_32_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_32_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_32_0.input_manager:device_unblock_all_services("gamepad", 1)

	arg_32_0.exiting = nil

	if arg_32_0._machine then
		arg_32_0._machine:destroy()

		arg_32_0._machine = nil
	end

	ShowCursorStack.hide("StartMenuView")
	arg_32_0:hide_hero_world()
	Managers.music:unduck_sounds()
	arg_32_0:play_sound("play_gui_amb_hero_screen_loop_end")
	arg_32_0:play_sound("Stop_menu_screen_music")
	UISettings.hero_fullscreen_menu_on_exit()
end

StartMenuView.exit = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0:initial_profile_view() and "exit_initial_start_menu_view" or arg_33_1 and "exit_menu" or "ingame_menu"

	arg_33_0.ingame_ui:transition_with_fade(var_33_0)
	arg_33_0:play_sound("Play_hud_button_close")

	arg_33_0.exiting = true
	arg_33_0._public_game_search_time = nil
end

StartMenuView.transitioning = function (arg_34_0)
	if arg_34_0.exiting then
		return true
	else
		return false
	end
end

StartMenuView.suspend = function (arg_35_0)
	arg_35_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_35_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_35_0.input_manager:device_unblock_all_services("gamepad", 1)

	arg_35_0.suspended = true

	local var_35_0 = "player_1"
	local var_35_1 = Managers.world:world("level_world")
	local var_35_2 = ScriptWorld.viewport(var_35_1, var_35_0)

	ScriptWorld.activate_viewport(var_35_1, var_35_2)

	local var_35_3 = arg_35_0.viewport_widget.element.pass_data[1]
	local var_35_4 = var_35_3.viewport
	local var_35_5 = var_35_3.world

	ScriptWorld.deactivate_viewport(var_35_5, var_35_4)
end

StartMenuView.unsuspend = function (arg_36_0)
	arg_36_0.input_manager:block_device_except_service("start_menu_view", "keyboard", 1)
	arg_36_0.input_manager:block_device_except_service("start_menu_view", "mouse", 1)
	arg_36_0.input_manager:block_device_except_service("start_menu_view", "gamepad", 1)

	arg_36_0.suspended = nil

	if arg_36_0.viewport_widget then
		local var_36_0 = "player_1"
		local var_36_1 = Managers.world:world("level_world")
		local var_36_2 = ScriptWorld.viewport(var_36_1, var_36_0)

		ScriptWorld.deactivate_viewport(var_36_1, var_36_2)

		local var_36_3 = arg_36_0.viewport_widget.element.pass_data[1]
		local var_36_4 = var_36_3.viewport
		local var_36_5 = var_36_3.world

		ScriptWorld.activate_viewport(var_36_5, var_36_4)
	end
end

StartMenuView._handle_exit = function (arg_37_0, arg_37_1)
	if not arg_37_0:initial_profile_view() then
		local var_37_0 = arg_37_0._exit_button_widget

		if var_37_0.content.button_hotspot.on_hover_enter then
			arg_37_0:play_sound("Play_hud_hover")
		end

		if (var_37_0.content.button_hotspot.on_release or arg_37_1:get("toggle_menu")) and not arg_37_0:_game_popup_active() then
			arg_37_0:play_sound("Play_hud_hover")
			arg_37_0:close_menu(not arg_37_0.exit_to_game)
		end
	end
end

StartMenuView._game_popup_active = function (arg_38_0)
	local var_38_0 = arg_38_0._machine

	if var_38_0 then
		local var_38_1 = var_38_0:state()

		if var_38_1.NAME == "StartMenuStateOverview" and var_38_1:game_popup_active() then
			return true
		end
	end
end

StartMenuView.close_menu = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._machine

	if var_39_0 then
		local var_39_1 = var_39_0:state().NAME

		if (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) and var_39_1 ~= "StartMenuStateOverview" then
			arg_39_0:_change_screen_by_name("overview")

			return
		end
	end

	local var_39_2 = not arg_39_1

	arg_39_0:exit(var_39_2)
end

StartMenuView.destroy = function (arg_40_0)
	if arg_40_0.viewport_widget then
		UIWidget.destroy(arg_40_0.ui_top_renderer, arg_40_0.viewport_widget)

		arg_40_0.viewport_widget = nil
	end

	arg_40_0.ingame_ui_context = nil
	arg_40_0.ui_animator = nil

	local var_40_0 = "level_world"
	local var_40_1 = Managers.world

	if var_40_1:has_world(var_40_0) then
		local var_40_2 = var_40_1:world(var_40_0)
		local var_40_3 = ScriptWorld.viewport(var_40_2, "player_1")

		ScriptWorld.activate_viewport(var_40_2, var_40_3)
	end

	if arg_40_0._machine then
		arg_40_0._machine:destroy()

		arg_40_0._machine = nil
	end
end

StartMenuView._is_button_pressed = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1.content.button_hotspot

	if var_41_0.on_release then
		var_41_0.on_release = false

		return true
	end
end
