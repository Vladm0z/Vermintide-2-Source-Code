-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_main_menu.lua

local var_0_0 = local_require("scripts/game_state/title_screen_substates/win32/state_title_screen_main_menu_settings")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

function StateTitleScreenMainMenu.on_enter(arg_1_0, arg_1_1)
	arg_1_0._params = arg_1_1
	arg_1_0._world = arg_1_1.world
	arg_1_0._viewport = arg_1_1.viewport
	arg_1_0._title_start_ui = arg_1_1.ui
	arg_1_0._auto_start = arg_1_1.auto_start

	if script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "false")
	end

	arg_1_0._setup_sound()
	arg_1_0:_init_menu_views()
	arg_1_0:_setup_menu_options()
	arg_1_0.parent:show_menu(true)
	Managers.transition:hide_loading_icon()
end

function StateTitleScreenMainMenu._check_prologue_status(arg_2_0)
	local var_2_0 = true

	if Managers.backend:get_user_data("has_completed_tutorial") or SaveData.has_completed_tutorial or false or script_data.disable_tutorial_at_start then
		var_2_0 = false
	else
		arg_2_0._input_disabled = true

		Managers.transition:show_loading_icon(false)
		arg_2_0._title_start_ui:disable_input(true)

		arg_2_0._new_state = StateTitleScreenLoadSave
	end

	return var_2_0
end

function StateTitleScreenMainMenu._start_game(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1 == "prologue"

	arg_3_0.parent.parent.loading_context.restart_network = true
	arg_3_0.parent.parent.loading_context.level_key = arg_3_1
	arg_3_0.parent.parent.loading_context.play_trailer = var_3_0 or Application.user_setting("play_intro_cinematic")
	arg_3_0.parent.parent.loading_context.force_run_tutorial = var_3_0
	arg_3_0.parent.parent.loading_context.first_time = var_3_0

	Managers.level_transition_handler:set_next_level(arg_3_1)
	Managers.level_transition_handler:promote_next_level_data()

	local var_3_1

	if Managers.mechanism then
		var_3_1 = Managers.mechanism:current_mechanism_name()

		Managers.mechanism:destroy()
	end

	Managers.mechanism = GameMechanismManager:new(var_3_1)
	arg_3_0._input_disabled = true

	Managers.transition:show_loading_icon(false)
	arg_3_0._title_start_ui:disable_input(true)
	arg_3_0._title_start_ui:view_activated(true)

	arg_3_0._new_state = StateTitleScreenLoadSave
end

function StateTitleScreenMainMenu._quit_game(arg_4_0)
	arg_4_0._popup_id = Managers.popup:queue_popup(Localize("quit_game_popup_text"), Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel", Localize("popup_choice_no"))
end

function StateTitleScreenMainMenu._initiate_quit_game(arg_5_0)
	arg_5_0._input_disabled = true

	arg_5_0._title_start_ui:disable_input(true)
	Managers.transition:fade_in(GameSettings.transition_fade_in_speed, callback(arg_5_0, "cb_quit_game"))
end

function StateTitleScreenMainMenu.cb_quit_game(arg_6_0)
	Boot.quit_game = true
end

function StateTitleScreenMainMenu._setup_menu_options(arg_7_0)
	local var_7_0 = var_0_0.create_menu_layout(arg_7_0)

	arg_7_0._title_start_ui:create_menu_options(var_7_0)
end

function StateTitleScreenMainMenu._setup_sound(arg_8_0)
	local var_8_0 = Application.user_setting("master_bus_volume") or 90
	local var_8_1 = Application.user_setting("music_bus_volume") or 90
	local var_8_2

	if GLOBAL_MUSIC_WORLD then
		var_8_2 = MUSIC_WWISE_WORLD
	else
		local var_8_3 = Managers.world:world("music_world")

		var_8_2 = Managers.world:wwise_world(var_8_3)
	end

	WwiseWorld.set_global_parameter(var_8_2, "master_bus_volume", var_8_0)
	Managers.music:set_master_volume(var_8_0)
	Managers.music:set_music_volume(var_8_1)
end

function StateTitleScreenMainMenu.cb_camera_animation_complete(arg_9_0)
	ShowCursorStack.show("StateTitleScreenMainMenu")
	arg_9_0._title_start_ui:activate_career_ui(true)
end

function StateTitleScreenMainMenu.cb_camera_animation_complete_back(arg_10_0)
	arg_10_0._new_state = StateTitleScreenMain
end

function StateTitleScreenMainMenu._init_menu_views(arg_11_0)
	local var_11_0 = arg_11_0._title_start_ui:get_ui_renderer()
	local var_11_1 = {
		in_title_screen = true,
		ui_renderer = var_11_0,
		ui_top_renderer = var_11_0,
		input_manager = Managers.input,
		world_manager = Managers.world
	}

	arg_11_0._views = {
		credits_view = CreditsView:new(var_11_1),
		options_view = OptionsView:new(var_11_1),
		cinematics_view = CinematicsView:new(var_11_1)
	}

	ShowCursorStack.show("StateTitleScreenMainMenu")

	for iter_11_0, iter_11_1 in pairs(arg_11_0._views) do
		function iter_11_1.exit()
			arg_11_0:exit_current_view()
		end
	end
end

function StateTitleScreenMainMenu.update(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._active_view

	if arg_13_0._auto_start and (Development.parameter("auto_host_level") or Development.parameter("auto_join") or Development.parameter("deus_auto_host") or Development.parameter("vs_auto_search") or Development.parameter("weave_name")) then
		arg_13_0._input_disabled = true

		Managers.transition:show_loading_icon(false)
		arg_13_0._title_start_ui:disable_input(true)

		arg_13_0._new_state = StateTitleScreenLoadSave
		arg_13_0._auto_start = nil
	elseif arg_13_0._auto_start and Development.parameter("skip_splash") then
		local var_13_1 = 1

		arg_13_0._title_start_ui:_activate_menu_widget(var_13_1)

		arg_13_0._auto_start = nil
	elseif var_13_0 then
		arg_13_0._views[var_13_0]:update(arg_13_1, arg_13_2)
	end

	arg_13_0._title_start_ui:update(arg_13_1, arg_13_2)

	if not arg_13_0._input_disabled and Managers.input:get_service("main_menu"):get("back") then
		arg_13_0:_close_menu()
	end

	arg_13_0:_handle_popups()

	return arg_13_0._new_state
end

function StateTitleScreenMainMenu._handle_popups(arg_14_0)
	if not arg_14_0._popup_id then
		return
	end

	local var_14_0 = Managers.popup:query_result(arg_14_0._popup_id)

	if var_14_0 then
		arg_14_0._popup_id = nil

		arg_14_0:_handle_popup_result(var_14_0)
	end
end

function StateTitleScreenMainMenu._handle_popup_result(arg_15_0, arg_15_1)
	if arg_15_1 == "end_game" then
		arg_15_0:_initiate_quit_game()
	end
end

function StateTitleScreenMainMenu._close_menu(arg_16_0)
	arg_16_0.parent:show_menu(false)
	arg_16_0._title_start_ui:set_start_pressed(false)
	arg_16_0._title_start_ui:disable_input(false)

	arg_16_0._closing_menu = true

	Managers.transition:hide_loading_icon()
	Managers.transition:force_fade_in()
	Managers.transition:fade_out(GameSettings.transition_fade_in_speed * 2)

	arg_16_0._new_state = StateTitleScreenMain
end

function StateTitleScreenMainMenu.on_exit(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0._views) do
		if iter_17_1.destroy then
			iter_17_1:destroy()
		end
	end

	arg_17_0._views = nil

	ShowCursorStack.hide("StateTitleScreenMainMenu")
end

function StateTitleScreenMainMenu.cb_fade_in_done(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._new_state = StateTitleScreenLoadSave
	arg_18_0.parent.parent.loading_context.restart_network = true
	arg_18_0.parent.parent.loading_context.level_key = arg_18_1
	arg_18_0.parent.parent.loading_context.play_trailer = arg_18_1 == "prologue" or Application.user_setting("play_intro_cinematic")

	if arg_18_1 == "tutorial" then
		Managers.backend:make_tutorial()

		arg_18_0.parent.parent.loading_context.wanted_profile_index = 4
	elseif script_data.honduras_demo then
		arg_18_0.parent.parent.loading_context.wanted_profile_index = arg_18_2 and FindProfileIndex(arg_18_2) or DemoSettings.wanted_profile_index
		GameSettingsDevelopment.disable_free_flight = DemoSettings.disable_free_flight
		GameSettingsDevelopment.disable_intro_trailer = DemoSettings.disable_intro_trailer
	end
end

function StateTitleScreenMainMenu._activate_view(arg_19_0, arg_19_1)
	arg_19_0._active_view = arg_19_1

	local var_19_0 = arg_19_0._views

	assert(var_19_0[arg_19_1])

	if arg_19_1 and var_19_0[arg_19_1] and var_19_0[arg_19_1].on_enter then
		var_19_0[arg_19_1]:on_enter()

		arg_19_0._input_disabled = true

		arg_19_0._title_start_ui:disable_input(true)
		arg_19_0._title_start_ui:view_activated(true)
	end
end

function StateTitleScreenMainMenu.exit_current_view(arg_20_0)
	local var_20_0 = arg_20_0._active_view
	local var_20_1 = arg_20_0._views

	assert(var_20_0)

	if var_20_1[var_20_0] and var_20_1[var_20_0].on_exit then
		var_20_1[var_20_0]:on_exit()

		arg_20_0._input_disabled = false

		arg_20_0._title_start_ui:disable_input(false)
		arg_20_0._title_start_ui:view_activated(false)
	end

	arg_20_0._active_view = nil

	Managers.input:block_device_except_service("main_menu", "gamepad", 1)
end
