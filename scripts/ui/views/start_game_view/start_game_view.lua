-- chunkname: @scripts/ui/views/start_game_view/start_game_view.lua

require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/start_game_view/states/start_game_state_settings_overview")
require("scripts/ui/views/start_game_view/states/start_game_state_weave_leaderboard")

local var_0_0 = local_require("scripts/ui/views/start_game_view/start_game_view_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.settings_by_screen
local var_0_4 = var_0_0.attachments
local var_0_5 = var_0_0.flow_events

local function var_0_6(...)
	print("[StartGameView]", ...)
end

local var_0_7 = true
local var_0_8 = false
local var_0_9 = true
local var_0_10 = {}

if not IS_WINDOWS then
	var_0_10.console_friends_menu = function (arg_2_0)
		Managers.input:block_device_except_service("console_friends_menu", "gamepad")
		arg_2_0:_activate_view("console_friends_view")
	end
end

StartGameView = class(StartGameView)

StartGameView.init = function (arg_3_0, arg_3_1)
	arg_3_0.world = arg_3_1.world
	arg_3_0.player_manager = arg_3_1.player_manager
	arg_3_0.ui_renderer = arg_3_1.ui_renderer
	arg_3_0.ui_top_renderer = arg_3_1.ui_top_renderer
	arg_3_0.ingame_ui = arg_3_1.ingame_ui
	arg_3_0.voting_manager = arg_3_1.voting_manager
	arg_3_0.profile_synchronizer = arg_3_1.profile_synchronizer
	arg_3_0.peer_id = arg_3_1.peer_id
	arg_3_0.local_player_id = arg_3_1.local_player_id
	arg_3_0.is_server = arg_3_1.is_server
	arg_3_0.is_in_inn = arg_3_1.is_in_inn
	arg_3_0.world_manager = arg_3_1.world_manager

	local var_3_0 = arg_3_0.world_manager:world("level_world")

	arg_3_0.wwise_world = Managers.world:wwise_world(var_3_0)

	local var_3_1 = arg_3_1.input_manager

	arg_3_0.input_manager = var_3_1

	var_3_1:create_input_service("start_game_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_3_1:map_device_to_service("start_game_view", "keyboard")
	var_3_1:map_device_to_service("start_game_view", "mouse")
	var_3_1:map_device_to_service("start_game_view", "gamepad")

	arg_3_0._state_machine_params = {
		wwise_world = arg_3_0.wwise_world,
		ingame_ui_context = arg_3_1,
		parent = arg_3_0,
		settings_by_screen = var_0_3,
		input_service = FAKE_INPUT_SERVICE
	}
	arg_3_0.units = {}
	arg_3_0.attachment_units = {}
	arg_3_0.unit_states = {}
	arg_3_0.ui_animations = {}
	arg_3_0.ingame_ui_context = arg_3_1
	var_0_7 = false
end

StartGameView._init_menu_views = function (arg_4_0)
	local var_4_0 = arg_4_0.ingame_ui_context

	arg_4_0._views = {
		console_friends_view = var_4_0.ingame_ui.views.console_friends_view
	}

	for iter_4_0, iter_4_1 in pairs(arg_4_0._views) do
		iter_4_1.exit = function ()
			arg_4_0:exit_current_view()
		end
	end
end

StartGameView._activate_view = function (arg_6_0, arg_6_1)
	arg_6_0._active_view = arg_6_1

	local var_6_0 = arg_6_0._views

	assert(var_6_0[arg_6_1])

	if arg_6_1 and var_6_0[arg_6_1] and var_6_0[arg_6_1].on_enter then
		var_6_0[arg_6_1]:on_enter()
	end
end

StartGameView.active_view = function (arg_7_0)
	return arg_7_0._active_view
end

StartGameView.exit_current_view = function (arg_8_0)
	local var_8_0 = arg_8_0._active_view
	local var_8_1 = arg_8_0._views

	assert(var_8_0)

	if var_8_1[var_8_0] and var_8_1[var_8_0].on_exit then
		var_8_1[var_8_0]:on_exit()
	end

	arg_8_0._active_view = nil

	local var_8_2 = Managers.input:get_service("start_game_view").name
	local var_8_3 = Managers.input

	var_8_3:block_device_except_service(var_8_2, "keyboard")
	var_8_3:block_device_except_service(var_8_2, "mouse")
	var_8_3:block_device_except_service(var_8_2, "gamepad")
	var_8_3:disable_gamepad_cursor()
end

StartGameView.initial_profile_view = function (arg_9_0)
	return arg_9_0.ingame_ui.initial_profile_view
end

StartGameView._setup_state_machine = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if arg_10_0._machine then
		arg_10_0._machine:destroy()

		arg_10_0._machine = nil
	end

	local var_10_0 = arg_10_2 or StartGameStateSettingsOverview
	local var_10_1 = false

	arg_10_1.start_state = arg_10_3
	arg_10_1.state_params = arg_10_4
	arg_10_0._machine = GameStateMachine:new(arg_10_0, var_10_0, arg_10_1, var_10_1)
	arg_10_0._state_machine_params = arg_10_1
	arg_10_1.state_params = nil
end

StartGameView.wanted_state = function (arg_11_0)
	return arg_11_0._wanted_state
end

StartGameView.clear_wanted_state = function (arg_12_0)
	arg_12_0._wanted_state = nil
end

StartGameView.input_service = function (arg_13_0)
	return arg_13_0._draw_loading and FAKE_INPUT_SERVICE or arg_13_0.input_manager:get_service("start_game_view")
end

StartGameView.set_input_blocked = function (arg_14_0, arg_14_1)
	arg_14_0._input_blocked = arg_14_1
end

StartGameView.input_blocked = function (arg_15_0)
	return arg_15_0._input_blocked
end

StartGameView.play_sound = function (arg_16_0, arg_16_1)
	WwiseWorld.trigger_event(arg_16_0.wwise_world, arg_16_1)
end

StartGameView.play_mechanism_sound = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.mechanism:mechanism_setting(arg_17_1) or arg_17_2

	if var_17_0 then
		arg_17_0:play_sound(var_17_0)
	end
end

StartGameView.create_ui_elements = function (arg_18_0)
	arg_18_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_18_0._static_widgets = {}
	arg_18_0._loading_widgets = {
		background = UIWidget.init(var_0_1.loading_bg),
		text = UIWidget.init(var_0_1.loading_text)
	}
	arg_18_0._console_cursor_widget = UIWidget.init(var_0_1.console_cursor)

	UIRenderer.clear_scenegraph_queue(arg_18_0.ui_renderer)

	arg_18_0.ui_animator = UIAnimator:new(arg_18_0.ui_scenegraph, var_0_0.animations)
end

StartGameView.draw = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.ui_renderer
	local var_19_1 = arg_19_0.ui_top_renderer
	local var_19_2 = arg_19_0.ui_scenegraph
	local var_19_3 = arg_19_0.input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(var_19_0, var_19_2, arg_19_2, arg_19_1)

	if var_0_8 then
		UISceneGraph.debug_render_scenegraph(var_19_0, var_19_2)
	end

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._static_widgets) do
		UIRenderer.draw_widget(var_19_0, iter_19_1)
	end

	UIRenderer.draw_widget(var_19_0, arg_19_0._console_cursor_widget)

	if arg_19_0._draw_loading then
		UIRenderer.begin_pass(var_19_1, var_19_2, arg_19_2, arg_19_1)

		for iter_19_2, iter_19_3 in pairs(arg_19_0._loading_widgets) do
			UIRenderer.draw_widget(var_19_1, iter_19_3)
		end

		UIRenderer.end_pass(var_19_1)
	end

	UIRenderer.end_pass(var_19_0)
end

StartGameView.post_update = function (arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0._machine then
		arg_20_0._machine:post_update(arg_20_1, arg_20_2)
	end
end

StartGameView.update = function (arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0.suspended or arg_21_0.waiting_for_post_update_enter then
		return
	end

	if arg_21_0:_has_active_level_vote() then
		arg_21_0:close_menu(nil, true)
	end

	local var_21_0 = arg_21_0._requested_screen_change_data

	if var_21_0 then
		local var_21_1 = var_21_0.screen_name
		local var_21_2 = var_21_0.sub_screen_name

		arg_21_0:_change_screen_by_name(var_21_1, var_21_2)

		arg_21_0._requested_screen_change_data = nil
	end

	local var_21_3 = true
	local var_21_4 = arg_21_0.input_manager:is_device_active("gamepad")
	local var_21_5 = arg_21_0:input_blocked() and FAKE_INPUT_SERVICE or arg_21_0:input_service()

	arg_21_0._state_machine_params.input_service = var_21_5

	local var_21_6 = arg_21_0:transitioning()

	arg_21_0.ui_animator:update(arg_21_1)

	for iter_21_0, iter_21_1 in pairs(arg_21_0.ui_animations) do
		UIAnimation.update(iter_21_1, arg_21_1)

		if UIAnimation.completed(iter_21_1) then
			arg_21_0.ui_animations[iter_21_0] = nil
		end
	end

	if not var_21_6 then
		arg_21_0:_handle_mouse_input(arg_21_1, arg_21_2, var_21_5)

		local var_21_7 = arg_21_0._active_view

		if var_21_7 then
			arg_21_0._views[var_21_7]:update(arg_21_1, arg_21_2)
		else
			arg_21_0:_handle_input(arg_21_1, arg_21_2)
		end
	end

	if arg_21_0._machine then
		arg_21_0._machine:update(arg_21_1, arg_21_2)
	end

	arg_21_0:draw(arg_21_1, var_21_5)
end

StartGameView.on_enter = function (arg_22_0, arg_22_1)
	ShowCursorStack.show("StartGameView")

	local var_22_0 = arg_22_0.input_manager

	var_22_0:block_device_except_service("start_game_view", "keyboard", 1)
	var_22_0:block_device_except_service("start_game_view", "mouse", 1)
	var_22_0:block_device_except_service("start_game_view", "gamepad", 1)

	arg_22_0._state_machine_params.initial_state = true

	arg_22_0:create_ui_elements()

	local var_22_1 = arg_22_0.profile_synchronizer:profile_by_peer(arg_22_0.peer_id, arg_22_0.local_player_id)

	arg_22_0:set_current_hero(var_22_1)

	arg_22_0.waiting_for_post_update_enter = true
	arg_22_0._on_enter_transition_params = arg_22_1
	arg_22_0._on_enter_sub_state = arg_22_1.menu_sub_state_name

	arg_22_0:play_mechanism_sound("start_game_open_sound_event")
	Managers.music:duck_sounds()

	arg_22_0._draw_loading = false

	arg_22_0:_init_menu_views()
	arg_22_0:_handle_new_ui_disclaimer()
end

StartGameView._handle_new_ui_disclaimer = function (arg_23_0)
	local var_23_0 = Managers.mechanism:current_mechanism_name()
	local var_23_1 = {
		deus = {
			play = false,
			default = false
		},
		adventure = {
			default = true,
			leaderboard = false
		},
		default = {
			default = true,
			leaderboard = false
		}
	}
	local var_23_2 = var_23_1[var_23_0] or var_23_1.default
	local var_23_3 = arg_23_0._on_enter_transition_params
	local var_23_4 = var_23_3 and var_23_3.menu_state_name or "default"

	Managers.ui:handle_new_ui_disclaimer(var_23_2, var_23_4)
end

StartGameView.on_enter_sub_state = function (arg_24_0)
	return arg_24_0._on_enter_sub_state
end

StartGameView.set_current_hero = function (arg_25_0, arg_25_1)
	local var_25_0 = SPProfiles[arg_25_1]
	local var_25_1 = var_25_0.display_name
	local var_25_2 = var_25_0.character_name

	arg_25_0._hero_name = var_25_1
	arg_25_0._state_machine_params.hero_name = var_25_1
end

StartGameView._get_sorted_players = function (arg_26_0)
	local var_26_0 = arg_26_0.player_manager:human_players()
	local var_26_1 = {}

	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		var_26_1[#var_26_1 + 1] = iter_26_1
	end

	table.sort(var_26_1, function (arg_27_0, arg_27_1)
		return arg_27_0.local_player and not arg_27_1.local_player
	end)

	return var_26_1
end

StartGameView._handle_mouse_input = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	return
end

StartGameView._handle_input = function (arg_29_0, arg_29_1, arg_29_2)
	if Managers.account:offline_mode() then
		return
	end

	if arg_29_0:input_service():get("show_gamercard") and var_0_10.console_friends_menu then
		local var_29_0 = arg_29_0._machine:state()

		if var_29_0.disable_input and var_29_0:disable_input("show_gamercard") then
			return
		end

		var_0_10.console_friends_menu(arg_29_0)
	end
end

StartGameView._is_selection_widget_pressed = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_1.content
	local var_30_1 = var_30_0.steps

	for iter_30_0 = 1, var_30_1 do
		if var_30_0["hotspot_" .. iter_30_0].on_release then
			return true, iter_30_0
		end
	end
end

StartGameView.hotkey_allowed = function (arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0:input_blocked() then
		return false
	end

	local var_31_0 = arg_31_2.transition_state
	local var_31_1 = arg_31_2.transition_sub_state
	local var_31_2 = arg_31_0._machine

	if var_31_2 then
		local var_31_3 = var_31_2:state()
		local var_31_4 = var_31_3.NAME

		if var_31_3.hotkey_allowed and not var_31_3:hotkey_allowed(arg_31_1, arg_31_2) then
			return false
		end

		if arg_31_0:_get_screen_settings_by_state_name(var_31_4).name == var_31_0 then
			local var_31_5 = var_31_3.get_selected_layout_name and var_31_3:get_selected_layout_name()

			if not var_31_1 or var_31_1 == var_31_5 then
				return true
			elseif var_31_1 then
				return true
			end
		elseif var_31_0 then
			arg_31_0:requested_screen_change_by_name(var_31_0, var_31_1)
		else
			return true
		end
	end

	return false
end

StartGameView._get_screen_settings_by_state_name = function (arg_32_0, arg_32_1)
	for iter_32_0, iter_32_1 in ipairs(var_0_3) do
		if iter_32_1.state_name == arg_32_1 then
			return iter_32_1
		end
	end
end

StartGameView.requested_screen_change_by_name = function (arg_33_0, arg_33_1, arg_33_2)
	arg_33_0._requested_screen_change_data = {
		screen_name = arg_33_1,
		sub_screen_name = arg_33_2
	}
end

StartGameView._change_screen_by_name = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0
	local var_34_1

	for iter_34_0, iter_34_1 in ipairs(var_0_3) do
		if iter_34_1.name == arg_34_1 then
			var_34_0 = iter_34_1
			var_34_1 = iter_34_0

			break
		end
	end

	assert(var_34_1, "[StartGameView] - Could not find state by name: %s", arg_34_1)

	local var_34_2 = var_34_0.state_name
	local var_34_3 = rawget(_G, var_34_2)

	if arg_34_0._machine and not arg_34_2 then
		arg_34_0._wanted_state = var_34_3
	else
		arg_34_0:_setup_state_machine(arg_34_0._state_machine_params, var_34_3, arg_34_2, arg_34_3)
	end
end

StartGameView._change_screen_by_index = function (arg_35_0, arg_35_1)
	local var_35_0 = var_0_3[arg_35_1].name

	arg_35_0:_change_screen_by_name(var_35_0)
end

StartGameView.post_update_on_enter = function (arg_36_0)
	arg_36_0.waiting_for_post_update_enter = nil

	local var_36_0 = arg_36_0._on_enter_transition_params

	if var_36_0 and var_36_0.menu_state_name then
		local var_36_1 = var_36_0.menu_state_name
		local var_36_2 = var_36_0.menu_sub_state_name

		arg_36_0:_change_screen_by_name(var_36_1, var_36_2, var_36_0)

		arg_36_0._on_enter_transition_params = nil
	else
		arg_36_0:_change_screen_by_index(1)
	end
end

StartGameView.post_update_on_exit = function (arg_37_0)
	return
end

StartGameView.on_exit = function (arg_38_0)
	arg_38_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_38_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_38_0.input_manager:device_unblock_all_services("gamepad", 1)
	ShowCursorStack.hide("StartGameView")

	arg_38_0.exiting = nil

	if arg_38_0._machine then
		arg_38_0._machine:destroy()

		arg_38_0._machine = nil
	end

	local var_38_0 = arg_38_0._active_view
	local var_38_1 = arg_38_0._views

	if var_38_1[var_38_0] and var_38_1[var_38_0].on_exit then
		var_38_1[var_38_0]:on_exit()
	end

	arg_38_0._active_view = nil

	arg_38_0:play_mechanism_sound("start_game_close_sound_event")
	Managers.music:unduck_sounds()

	arg_38_0._draw_loading = false
end

StartGameView.exit = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_1 and "exit_menu" or "ingame_menu"

	arg_39_0.ingame_ui:transition_with_fade(var_39_0)

	if arg_39_0._active_view then
		arg_39_0:exit_current_view()
	end

	if not arg_39_2 then
		arg_39_0:play_mechanism_sound("close_start_menu_sound_event", "Play_hud_button_close")
	end

	arg_39_0.exiting = true
end

StartGameView.transitioning = function (arg_40_0)
	if arg_40_0.exiting then
		return true
	else
		return false
	end
end

StartGameView.suspend = function (arg_41_0)
	arg_41_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_41_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_41_0.input_manager:device_unblock_all_services("gamepad", 1)

	arg_41_0.suspended = true
end

StartGameView.unsuspend = function (arg_42_0)
	arg_42_0.input_manager:block_device_except_service("start_game_view", "keyboard", 1)
	arg_42_0.input_manager:block_device_except_service("start_game_view", "mouse", 1)
	arg_42_0.input_manager:block_device_except_service("start_game_view", "gamepad", 1)

	arg_42_0.suspended = nil
end

StartGameView.close_menu = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = not arg_43_1

	arg_43_0:exit(var_43_0, arg_43_2)
end

StartGameView.destroy = function (arg_44_0)
	arg_44_0.ingame_ui_context = nil
	arg_44_0.ui_animator = nil

	if arg_44_0._machine then
		arg_44_0._machine:destroy()

		arg_44_0._machine = nil
	end
end

StartGameView._is_button_pressed = function (arg_45_0, arg_45_1)
	local var_45_0 = arg_45_1.content.button_hotspot

	if var_45_0.on_release then
		var_45_0.on_release = false

		return true
	end
end

StartGameView._has_active_level_vote = function (arg_46_0)
	local var_46_0 = arg_46_0.voting_manager

	return var_46_0:vote_in_progress() and var_46_0:is_mission_vote() and not var_46_0:has_voted(Network.peer_id())
end

StartGameView._set_loading_overlay_enabled = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._loading_widgets
	local var_47_1 = var_47_0.text
	local var_47_2 = var_47_0.background
	local var_47_3 = arg_47_1 and 255 or 0

	var_47_2.style.color[1] = var_47_3
	var_47_1.style.text.text_color[1] = var_47_3
	var_47_1.content.text = arg_47_2 or ""
	arg_47_0._draw_loading = arg_47_1
end

StartGameView.number_of_players = function (arg_48_0)
	return Managers.player:num_human_players()
end

StartGameView.start_game = function (arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_2 then
		Managers.mechanism:request_vote(arg_49_1)
	end

	arg_49_0:play_mechanism_sound("start_game_play_sound_event", "play_gui_lobby_button_play")

	if arg_49_1.matchmaking_type == "custom" and arg_49_1.player_hosted == true and arg_49_1.mechanism == "versus" then
		return
	end

	arg_49_0:close_menu()
end

StartGameView.cancel_matchmaking = function (arg_50_0)
	local var_50_0 = Managers.matchmaking

	if var_50_0:is_game_matchmaking() then
		var_50_0:cancel_matchmaking()
	end
end
