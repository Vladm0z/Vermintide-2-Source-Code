-- chunkname: @scripts/game_state/title_screen_substates/ps4/state_title_screen_main_menu.lua

require("scripts/ui/views/additional_content/additional_content_view")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

local var_0_0 = {
	HOST_PLAY_TOGETHER = "host_play_together",
	INVITATION = "invitation",
	OFFLINE = "offline",
	ONLINE = "online"
}
local var_0_1

if script_data.honduras_demo then
	var_0_1 = {
		function (arg_1_0)
			arg_1_0:_start_game(var_0_0.ONLINE, DemoSettings.demo_level)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end
	}
elseif script_data.settings.use_beta_mode then
	if script_data.settings.disable_tutorial_at_start then
		var_0_1 = {
			function (arg_2_0)
				local var_2_0 = arg_2_0._title_start_ui:game_type() or var_0_0.ONLINE

				arg_2_0:_start_game(var_2_0)
				arg_2_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (arg_3_0)
				Managers.input:block_device_except_service("options_menu", "gamepad")
				arg_3_0:activate_view("options_view")
				arg_3_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function (arg_4_0)
				arg_4_0:activate_view("credits_view")
				arg_4_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	else
		var_0_1 = {
			function (arg_5_0)
				local var_5_0 = arg_5_0._title_start_ui:game_type() or var_0_0.ONLINE

				arg_5_0:_start_game(var_5_0)
				arg_5_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (arg_6_0)
				local var_6_0 = arg_6_0._title_start_ui:game_type() or var_0_0.ONLINE

				arg_6_0:_start_game(var_6_0, "prologue")
				arg_6_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (arg_7_0)
				Managers.input:block_device_except_service("options_menu", "gamepad")
				arg_7_0:activate_view("options_view")
				arg_7_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function (arg_8_0)
				arg_8_0:activate_view("credits_view")
				arg_8_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	end
elseif GameSettingsDevelopment.additional_content_view_enabled then
	var_0_1 = {
		function (arg_9_0)
			local var_9_0 = arg_9_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_9_0:_start_game(var_9_0)
			arg_9_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (arg_10_0)
			local var_10_0 = arg_10_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_10_0:_start_game(var_10_0, "prologue")
			arg_10_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (arg_11_0)
			Managers.input:block_device_except_service("options_menu", "gamepad")
			arg_11_0:activate_view("options_view")
			arg_11_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (arg_12_0)
			local var_12_0 = Managers.input

			arg_12_0:activate_view("cinematics_view")
			arg_12_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (arg_13_0)
			Managers.input:block_device_except_service("additional_content_menu", "gamepad")
			arg_13_0:activate_view("additional_content_view")
			arg_13_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (arg_14_0)
			arg_14_0:activate_view("credits_view")
			arg_14_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
else
	var_0_1 = {
		function (arg_15_0)
			local var_15_0 = arg_15_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_15_0:_start_game(var_15_0)
			arg_15_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (arg_16_0)
			local var_16_0 = arg_16_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_16_0:_start_game(var_16_0, "prologue")
			arg_16_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (arg_17_0)
			Managers.input:block_device_except_service("options_menu", "gamepad")
			arg_17_0:activate_view("options_view")
			arg_17_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (arg_18_0)
			arg_18_0:activate_view("credits_view")
			arg_18_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
end

StateTitleScreenMainMenu.on_enter = function (arg_19_0, arg_19_1)
	print("[Gamestate] Enter Substate StateTitleScreenMainMenu")

	arg_19_0._params = arg_19_1
	arg_19_0._world = arg_19_1.world
	arg_19_0._viewport = arg_19_1.viewport
	arg_19_0._title_start_ui = arg_19_1.ui
	arg_19_0._auto_start = arg_19_1.auto_start
	arg_19_1.auto_start = nil
	arg_19_0._state = "none"
	arg_19_0._new_state = nil
	arg_19_0._input_disabled = false
	arg_19_0._game_type = nil
	arg_19_0._level_key = nil
	arg_19_0._disable_trailer = nil
	arg_19_0._profile_name = nil

	if script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "false")
	end

	UISettings.set_console_settings()
	arg_19_0._setup_sound()
	arg_19_0:_setup_input()
	arg_19_0:_init_menu_views()
	arg_19_0:_update_chat_ignore_list()

	if arg_19_1.skip_signin then
		arg_19_0._title_start_ui:set_start_pressed(true)
	end

	Managers.transition:hide_loading_icon()

	arg_19_0._network_event_meta_table = {}

	arg_19_0._network_event_meta_table.__index = function (arg_20_0, arg_20_1)
		return function ()
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_20_1)
		end
	end

	arg_19_0._is_installed = Managers.play_go:installed()

	if not arg_19_0._is_installed then
		arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("start_game", false, true, "start_game_disabled_playgo")
		arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("cinematics", false, true, "start_game_disabled_playgo")
	else
		arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("start_game", true, true)
		arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("cinematics", true, true)
	end

	if PlayfabBackendSaveDataUtils.online_data_is_dirty() then
		arg_19_0._title_start_ui:set_update_offline_data_enabled(true)
	else
		arg_19_0._title_start_ui:set_update_offline_data_enabled(false)
	end

	arg_19_0:_try_activate_splash()

	if not script_data.settings.use_beta_mode and GameSettingsDevelopment.additional_content_view_enabled then
		local var_19_0 = arg_19_0._views.additional_content_view

		if not (var_19_0 and var_19_0:has_active_splashes()) then
			arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("store", false, true, "start_game_disabled_playgo")
		else
			arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("store", true, true)
		end
	end
end

StateTitleScreenMainMenu._setup_sound = function (arg_22_0)
	local var_22_0 = Application.user_setting("master_bus_volume") or 90
	local var_22_1 = Application.user_setting("music_bus_volume") or 90
	local var_22_2

	if GLOBAL_MUSIC_WORLD then
		var_22_2 = MUSIC_WWISE_WORLD
	else
		local var_22_3 = Managers.world:world("music_world")

		var_22_2 = Managers.world:wwise_world(var_22_3)
	end

	WwiseWorld.set_global_parameter(var_22_2, "master_bus_volume", var_22_0)
	Managers.music:set_master_volume(var_22_0)
	Managers.music:set_music_volume(var_22_1)
end

StateTitleScreenMainMenu.cb_camera_animation_complete = function (arg_23_0)
	arg_23_0._title_start_ui:activate_career_ui(true)
end

StateTitleScreenMainMenu.cb_camera_animation_complete_back = function (arg_24_0)
	arg_24_0._new_state = StateTitleScreenMain
end

StateTitleScreenMainMenu._setup_input = function (arg_25_0)
	arg_25_0.input_manager = Managers.input
end

StateTitleScreenMainMenu._init_menu_views = function (arg_26_0)
	local var_26_0 = arg_26_0._title_start_ui:get_ui_renderer()
	local var_26_1 = {
		in_title_screen = true,
		ui_renderer = var_26_0,
		ui_top_renderer = var_26_0,
		input_manager = Managers.input,
		world_manager = Managers.world
	}

	if script_data.honduras_demo then
		arg_26_0._title_start_ui:animate_to_camera(DemoSettings.camera_end_position, nil, callback(arg_26_0, "cb_camera_animation_complete"))

		arg_26_0._views = {}
	else
		arg_26_0._views = {
			credits_view = CreditsView:new(var_26_1),
			options_view = OptionsView:new(var_26_1),
			cinematics_view = CinematicsView:new(var_26_1),
			additional_content_view = not script_data.settings.use_beta_mode and GameSettingsDevelopment.additional_content_view_enabled and AdditionalContentView:new(var_26_1) or nil
		}
	end

	for iter_26_0, iter_26_1 in pairs(arg_26_0._views) do
		iter_26_1.exit = function ()
			arg_26_0:exit_current_view()
		end
	end
end

StateTitleScreenMainMenu._update_chat_ignore_list = function (arg_28_0)
	Managers.chat:update_ignore_list()
end

StateTitleScreenMainMenu._try_activate_splash = function (arg_29_0)
	local var_29_0 = arg_29_0._views.additional_content_view

	if var_29_0 and var_29_0:has_active_splashes() and not SaveData.store_shown then
		Managers.input:block_device_except_service("additional_content_menu", "gamepad")
		arg_29_0:activate_view("additional_content_view")
		arg_29_0._title_start_ui:menu_option_activated(true)
		arg_29_0.parent:show_menu(true, true)
	else
		arg_29_0.parent:show_menu(true)
	end
end

if not BACKGROUND_ONLY then
	local var_0_2 = true
end

StateTitleScreenMainMenu._update_network = function (arg_30_0, arg_30_1, arg_30_2)
	if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() then
		Network.update(arg_30_1, setmetatable({}, arg_30_0._network_event_meta_table))
	end
end

StateTitleScreenMainMenu._start_game = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	arg_31_0._game_type = arg_31_1
	arg_31_0._level_key = arg_31_2
	arg_31_0._disable_trailer = arg_31_3 or not Application.user_setting("play_intro_cinematic")
	arg_31_0._profile_name = arg_31_4
	arg_31_0._input_disabled = true

	Managers.transition:show_loading_icon(false)
	arg_31_0._title_start_ui:disable_input(true)

	if arg_31_1 == var_0_0.OFFLINE then
		arg_31_0._state = "signin_to_backend"
	else
		arg_31_0._state = "check_restrictions"
	end
end

StateTitleScreenMainMenu.update = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._title_start_ui

	arg_32_0:_update_play_go(arg_32_1, arg_32_2)
	arg_32_0:_update_network(arg_32_1, arg_32_2)

	local var_32_1 = false
	local var_32_2 = Managers.invite:play_together_list()

	if arg_32_0._auto_start then
		local var_32_3 = arg_32_0.parent.parent.loading_context

		if var_32_3.offline_invite then
			var_32_1 = true
			var_32_3.offline_invite = nil
		elseif not var_32_2 then
			arg_32_0:_start_game(var_0_0.ONLINE)
		end

		arg_32_0._auto_start = nil
	end

	local var_32_4 = Managers.popup:has_popup()
	local var_32_5 = Managers.account:user_detached()

	if not arg_32_0._input_disabled and not var_32_4 and not var_32_5 and not arg_32_0._popup_id then
		if Managers.invite:has_invitation() or var_32_1 then
			if arg_32_0._is_installed then
				arg_32_0:_start_game(var_0_0.INVITATION, nil, true)
			else
				arg_32_0._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
				arg_32_0._state = "check_popup"
			end
		elseif var_32_2 then
			if arg_32_0._is_installed then
				arg_32_0:_start_game(var_0_0.HOST_PLAY_TOGETHER, nil, true)
			else
				arg_32_0._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
				arg_32_0._state = "check_popup"
			end
		end
	end

	local var_32_6 = arg_32_0._active_view

	if var_32_6 then
		arg_32_0._views[var_32_6]:update(arg_32_1, arg_32_2)
	else
		var_32_0:update(arg_32_1, arg_32_2)

		if script_data.honduras_demo then
			arg_32_0:_update_demo_input(arg_32_1, arg_32_2)
		else
			arg_32_0:_update_input(arg_32_1, arg_32_2)
		end
	end

	if not Managers.account:user_detached() then
		if arg_32_0._state == "check_restrictions" then
			arg_32_0:_check_restrictions()
			var_32_0:set_information_text(Localize("loading_checking_privileges"))
		elseif arg_32_0._state == "check_restrictions_network" then
			arg_32_0:_check_restrictions_network()
		elseif arg_32_0._state == "check_restrictions_ps_plus" then
			arg_32_0:_check_restrictions_ps_plus()
		elseif arg_32_0._state == "check_restrictions_chat" then
			arg_32_0:_check_restrictions_chat()
		elseif arg_32_0._state == "update_ps_plus_dialog" then
			arg_32_0:_update_ps_plus_dialog()
		elseif arg_32_0._state == "update_chat_restriction_dialog" then
			arg_32_0:_update_chat_restriction_dialog()
		elseif arg_32_0._state == "request_np_auth_data" then
			var_32_0:set_information_text(Localize("loading_requesting_np_auth_data"))
			arg_32_0:_request_np_auth_data()
		elseif arg_32_0._state == "signin_to_backend" then
			arg_32_0:_signin_to_backend()
			var_32_0:set_information_text(Localize("loading_signing_in"))
		elseif arg_32_0._state == "waiting_for_backend_signin" then
			arg_32_0:_waiting_for_backend_signin()
		elseif arg_32_0._state == "check_popup" then
			arg_32_0:_check_popup()
		end
	elseif arg_32_0._state == "check_popup" then
		arg_32_0:_check_popup()
	end

	if Managers.account:leaving_game() then
		if var_32_6 then
			arg_32_0:exit_current_view()
		end

		arg_32_0.parent:show_menu(false)
		arg_32_0._title_start_ui:set_start_pressed(false)
	end

	return arg_32_0:_next_state()
end

StateTitleScreenMainMenu._check_popup = function (arg_33_0)
	local var_33_0 = Managers.popup:query_result(arg_33_0._popup_id)

	if var_33_0 == "close_menu" then
		Managers.invite:clear_invites()
		arg_33_0:_close_menu()
	elseif var_33_0 == "not_installed" then
		Managers.invite:clear_invites()

		arg_33_0._state = "none"
	elseif var_33_0 == "update_offline_data" then
		print("[StateTitleScreenMainMenu] Updating offline data...")
		PlayfabBackendSaveDataUtils.update_offline_data(callback(arg_33_0, "cb_offline_data_updated"))
		arg_33_0._title_start_ui:set_update_offline_data_enabled(false)
		arg_33_0._title_start_ui:disable_input(true)

		arg_33_0._input_disabled = true

		Managers.transition:show_loading_icon(false)

		arg_33_0._state = "waiting_for_offline_data_update"
	elseif var_33_0 == "do_nothing" then
		arg_33_0._state = "none"
	elseif var_33_0 then
		fassert(false, "[StateTitleScreenMainMenu] The popup result doesn't exist (%s)", var_33_0)
	end

	if var_33_0 then
		arg_33_0._popup_id = nil
	end
end

StateTitleScreenMainMenu.cb_offline_data_updated = function (arg_34_0, arg_34_1)
	if arg_34_1 then
		print("[StateTitleScreenMainMenu] Offline data update SUCCESS")
	else
		print("[StateTitleScreenMainMenu] Offline data update ERROR")
	end

	arg_34_0._title_start_ui:disable_input(false)

	arg_34_0._input_disabled = false

	Managers.transition:hide_loading_icon()

	arg_34_0._state = "none"
end

StateTitleScreenMainMenu._close_menu = function (arg_35_0)
	arg_35_0.parent:show_menu(false)
	arg_35_0._title_start_ui:set_start_pressed(false)
	arg_35_0._title_start_ui:disable_input(false)
	arg_35_0._title_start_ui:set_game_type(nil)

	arg_35_0._closing_menu = true

	Managers.transition:hide_loading_icon()

	if Managers.transition:fade_state() == "in" then
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(1)
	end

	arg_35_0._new_state = StateTitleScreenMain
	arg_35_0._state = "none"
end

StateTitleScreenMainMenu._next_state = function (arg_36_0)
	if not Managers.popup:has_popup() and not arg_36_0._popup_id then
		if script_data.honduras_demo and not arg_36_0._title_start_ui:is_ready() then
			return
		end

		if Managers.backend and Managers.backend:is_disconnected() then
			arg_36_0:_close_menu()

			return arg_36_0._new_state
		elseif arg_36_0._closing_menu then
			return arg_36_0._new_state
		else
			return nil
		end
	end
end

StateTitleScreenMainMenu._update_input = function (arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0.input_manager:get_service("main_menu")
	local var_37_1 = arg_37_0._title_start_ui:current_menu_index()
	local var_37_2 = arg_37_0._title_start_ui:active_menu_selection()
	local var_37_3 = Managers.popup:has_popup()
	local var_37_4 = Managers.account:user_detached()
	local var_37_5 = Managers.account:active_controller()

	if var_37_2 and not arg_37_0._input_disabled and not var_37_3 and not var_37_4 and not arg_37_0._popup_id then
		if var_37_1 and var_37_0:get("start", true) then
			var_37_0:get("confirm_press", true)
			var_0_1[var_37_1](arg_37_0)
		elseif var_37_0:get("back") then
			arg_37_0:_close_menu()
		elseif arg_37_0._title_start_ui:offline_data_available() and var_37_5.pressed(var_37_5.button_index("triangle")) then
			arg_37_0._popup_id = Managers.popup:queue_popup(Localize("popup_update_offline_data"), Localize("popup_update_offline_data_header"), "update_offline_data", Localize("popup_choice_yes"), "do_nothing", Localize("popup_choice_no"))
			arg_37_0._state = "check_popup"
		end
	end
end

StateTitleScreenMainMenu._update_demo_input = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0._title_start_ui
	local var_38_1 = arg_38_0.input_manager:get_service("main_menu")
	local var_38_2 = Managers.popup:has_popup()
	local var_38_3 = Managers.account:user_detached()
	local var_38_4 = Managers.account:active_controller()

	if var_38_0:should_start() and not arg_38_0._input_disabled then
		local var_38_5, var_38_6 = var_38_0:selected_profile()

		arg_38_0:_start_game(var_0_0.ONLINE, DemoSettings.demo_level, nil, var_38_5)
		Managers.music:trigger_event("Play_console_menu_start_game")

		return
	end

	if Managers.time:get_demo_transition() and not var_38_0:in_transition() then
		var_38_0:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(arg_38_0, "cb_camera_animation_complete_back"))
		var_38_0:activate_career_ui(false)
		arg_38_0.parent:show_menu(false)
	end

	if not arg_38_0._input_disabled and not var_38_2 and not var_38_3 and not arg_38_0._popup_id and var_38_1:get("back") and not var_38_0:in_transition() then
		var_38_0:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(arg_38_0, "cb_camera_animation_complete_back"))
		var_38_0:activate_career_ui(false)
		arg_38_0:_close_menu()
	end
end

StateTitleScreenMainMenu._update_play_go = function (arg_39_0, arg_39_1, arg_39_2)
	if arg_39_0._is_installed then
		return
	end

	if Managers.play_go:installed() then
		arg_39_0._title_start_ui:set_menu_item_enable_state_by_index("start_game", true, true)
		arg_39_0._title_start_ui:set_menu_item_enable_state_by_index("cinematics", true, true)

		arg_39_0._is_installed = true
	end
end

StateTitleScreenMainMenu.on_exit = function (arg_40_0)
	for iter_40_0, iter_40_1 in pairs(arg_40_0._views) do
		if iter_40_1.destroy then
			iter_40_1:destroy()
		end
	end

	arg_40_0._views = nil
end

StateTitleScreenMainMenu.cb_fade_in_done = function (arg_41_0)
	local var_41_0 = arg_41_0._game_type
	local var_41_1 = arg_41_0._level_key
	local var_41_2 = arg_41_0._disable_trailer or not Application.user_setting("play_intro_cinematic")
	local var_41_3 = arg_41_0._profile_name
	local var_41_4, var_41_5 = Managers.mechanism:should_run_tutorial()

	if var_41_4 and not Managers.backend:get_user_data("prologue_started") and not script_data.settings.disable_tutorial_at_start and not script_data.disable_prologue and not script_data.honduras_demo then
		var_41_2 = false
		var_41_1 = "prologue"
	end

	arg_41_0.parent.state = StateLoading

	local var_41_6 = arg_41_0.parent.parent.loading_context

	var_41_6.restart_network = true
	var_41_6.level_key = var_41_1

	if var_41_0 == var_0_0.INVITATION or var_41_0 == var_0_0.HOST_PLAY_TOGETHER then
		var_41_6.first_time = false
	end

	if var_41_1 then
		local var_41_7 = LevelHelper:get_environment_variation_id(var_41_1)

		Managers.level_transition_handler:set_next_level(var_41_1, var_41_7)
	end

	if var_41_1 == "prologue" then
		var_41_6.gamma_correct = not SaveData.gamma_corrected
		var_41_6.play_trailer = true
		var_41_6.switch_to_tutorial_backend = var_41_4
		var_41_6.wanted_tutorial_state = var_41_5
	elseif script_data.honduras_demo then
		arg_41_0.parent.parent.loading_context.wanted_profile_index = var_41_3 and FindProfileIndex(var_41_3) or DemoSettings.wanted_profile_index
		GameSettingsDevelopment.disable_free_flight = DemoSettings.disable_free_flight
		GameSettingsDevelopment.disable_intro_trailer = DemoSettings.disable_intro_trailer
	elseif not var_41_1 then
		var_41_6.gamma_correct = not SaveData.gamma_corrected
		var_41_6.show_profile_on_startup = true

		if not var_41_2 then
			var_41_6.play_trailer = true
		end
	end
end

StateTitleScreenMainMenu.activate_view = function (arg_42_0, arg_42_1)
	arg_42_0._active_view = arg_42_1

	local var_42_0 = arg_42_0._views

	assert(var_42_0[arg_42_1])

	if arg_42_1 and var_42_0[arg_42_1] and var_42_0[arg_42_1].on_enter then
		var_42_0[arg_42_1]:on_enter()
	end
end

StateTitleScreenMainMenu.exit_current_view = function (arg_43_0)
	local var_43_0 = arg_43_0._active_view
	local var_43_1 = arg_43_0._views

	assert(var_43_0)

	if var_43_1[var_43_0] and var_43_1[var_43_0].on_exit then
		var_43_1[var_43_0]:on_exit()
	end

	arg_43_0._active_view = nil

	Managers.input:block_device_except_service("main_menu", "gamepad")
	arg_43_0._title_start_ui:menu_option_activated(false)
end

StateTitleScreenMainMenu._check_restrictions = function (arg_44_0)
	Managers.account:add_restriction_user(Managers.account:user_id())

	arg_44_0._state = "check_restrictions_network"
end

StateTitleScreenMainMenu._check_restrictions_network = function (arg_45_0)
	if not Managers.account:restriction_access_fetched("network_availability") then
		return
	end

	local var_45_0 = Managers.account:has_error("network_availability")
	local var_45_1 = Managers.account:has_access("network_availability")

	if var_45_0 then
		arg_45_0:_show_error_dialog(var_45_0)
	elseif not var_45_1 then
		arg_45_0._popup_id = Managers.popup:queue_popup(Localize("popup_ps4_network_not_available"), Localize("popup_error_topic"), "close_menu", Localize("popup_choice_ok"))
		arg_45_0._state = "check_popup"
	else
		arg_45_0._state = "check_restrictions_ps_plus"
	end
end

StateTitleScreenMainMenu._check_restrictions_ps_plus = function (arg_46_0)
	if not Managers.account:restriction_access_fetched("playstation_plus") then
		return
	end

	local var_46_0 = Managers.account:has_error("playstation_plus")
	local var_46_1 = Managers.account:has_access("playstation_plus")

	if var_46_0 then
		arg_46_0:_show_error_dialog(var_46_0)
	elseif not var_46_1 then
		arg_46_0:_setup_playstation_plus_dialog()
	else
		arg_46_0._state = "check_restrictions_chat"
	end
end

StateTitleScreenMainMenu._check_restrictions_chat = function (arg_47_0)
	local var_47_0 = Managers.account

	if not var_47_0:restriction_access_fetched("chat") then
		return
	end

	local var_47_1 = var_47_0:has_error("chat")
	local var_47_2 = var_47_0:has_access("chat")

	if var_47_1 then
		arg_47_0:_show_error_dialog(var_47_1)
	elseif not var_47_2 then
		arg_47_0:_setup_chat_restriction_dialog()
	else
		arg_47_0._state = "request_np_auth_data"
	end
end

StateTitleScreenMainMenu._setup_chat_restriction_dialog = function (arg_48_0)
	local var_48_0 = Managers.account:user_id()

	Managers.system_dialog:open_system_dialog(MsgDialog.SYSTEM_MSG_TRC_PSN_CHAT_RESTRICTION, var_48_0)

	arg_48_0._state = "update_chat_restriction_dialog"
end

StateTitleScreenMainMenu._update_chat_restriction_dialog = function (arg_49_0)
	if Managers.system_dialog:has_open_dialogs() then
		return
	end

	arg_49_0._state = "request_np_auth_data"
end

StateTitleScreenMainMenu._setup_playstation_plus_dialog = function (arg_50_0)
	NpCommerceDialog.initialize()

	arg_50_0._state = "update_ps_plus_dialog"
end

StateTitleScreenMainMenu._update_ps_plus_dialog = function (arg_51_0)
	local var_51_0 = NpCommerceDialog.update()

	if var_51_0 == NpCommerceDialog.INITIALIZED then
		NpCommerceDialog.open2(NpCommerceDialog.MODE_PLUS, Managers.account:user_id(), NpCheck.REALTIME_MULTIPLAY)
	elseif var_51_0 == NpCommerceDialog.FINISHED then
		local var_51_1, var_51_2 = NpCommerceDialog.result()

		NpCommerceDialog.terminate()

		if var_51_2 == true then
			Managers.account:refetch_restriction_access(nil, {
				"playstation_plus"
			})

			arg_51_0._state = "check_restrictions_ps_plus"
		else
			arg_51_0:_close_menu()
		end
	end
end

StateTitleScreenMainMenu._show_error_dialog = function (arg_52_0, arg_52_1)
	arg_52_0._state = "waiting_for_error_dialog"

	Managers.system_dialog:open_error_dialog(arg_52_1, callback(arg_52_0, "cb_error_dialog_done"))
end

StateTitleScreenMainMenu.cb_error_dialog_done = function (arg_53_0)
	arg_53_0:_close_menu()
end

StateTitleScreenMainMenu._request_np_auth_data = function (arg_54_0)
	local var_54_0 = NpAuth.create_async_token()
	local var_54_1 = ScriptNpAuthToken:new(var_54_0)

	Managers.token:register_token(var_54_1, callback(arg_54_0, "cb_np_auth_data_received"))

	arg_54_0._state = "waiting_for_np_auth_data"
end

StateTitleScreenMainMenu.cb_np_auth_data_received = function (arg_55_0, arg_55_1)
	print("[StateTitleScreenMainMenu] cb_np_auth_data_received")

	if arg_55_1.error then
		arg_55_0._popup_id = Managers.popup:queue_popup(Localize("popup_np_auth_failed"), Localize("popup_np_auth_failed_header"), "close_menu", Localize("menu_ok"))
		arg_55_0._state = "check_popup"
	else
		print("[StateTitleScreenMainMenu] Successfully acquired NpAuth data")

		arg_55_0._np_auth_data = arg_55_1.data
		arg_55_0._state = "signin_to_backend"
	end
end

StateTitleScreenMainMenu._signin_to_backend = function (arg_56_0)
	local var_56_0 = Development.parameter("mechanism") or "adventure"
	local var_56_1 = MechanismSettings[var_56_0]
	local var_56_2 = var_56_1 and var_56_1.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.unlock = UnlockManager:new()

	if arg_56_0._game_type == var_0_0.OFFLINE then
		print("Using Offline Backend")
		Managers.account:set_offline_mode(true)

		if not Managers.rest_transport_offline then
			require("scripts/managers/rest_transport_offline/rest_transport_manager_offline")

			local var_56_3 = require("scripts/managers/rest_transport_offline/offline_backend_playfab")

			Managers.rest_transport_offline = RestTransportManagerOffline:new(var_56_3.endpoints)
		end

		Managers.rest_transport = Managers.rest_transport_offline
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabPS4", var_56_2, "DataServerQueue")

		Managers.backend:signin()
	else
		print("Using Online Backend")
		Managers.account:set_offline_mode(false)
		Managers.account:fetch_user_data()

		Managers.rest_transport = Managers.rest_transport_online
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabPS4", var_56_2, "DataServerQueue")

		Managers.backend:signin(arg_56_0._np_auth_data)

		arg_56_0._np_auth_data = nil
	end

	arg_56_0._state = "waiting_for_backend_signin"
end

StateTitleScreenMainMenu._waiting_for_backend_signin = function (arg_57_0)
	local var_57_0 = Managers.backend

	if var_57_0 and var_57_0:authenticated() then
		arg_57_0._params.menu_screen_music_playing = false

		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(arg_57_0, "cb_fade_in_done"))

		arg_57_0._state = "none"
	end
end
