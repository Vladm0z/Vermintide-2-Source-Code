-- chunkname: @scripts/game_state/title_screen_substates/xb1/state_title_screen_main_menu.lua

require("scripts/ui/views/additional_content/additional_content_view")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

local var_0_0 = {
	INVITATION = "invitation",
	OFFLINE = "offline",
	ONLINE = "online"
}
local var_0_1

if script_data.honduras_demo then
	var_0_1 = {
		function(arg_1_0)
			arg_1_0:_start_game(var_0_0.ONLINE, DemoSettings.demo_level)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end
	}
elseif script_data.settings.use_beta_mode then
	if script_data.settings.disable_tutorial_at_start then
		var_0_1 = {
			function(arg_2_0)
				local var_2_0 = arg_2_0._title_start_ui:game_type() or var_0_0.ONLINE

				arg_2_0:_start_game(var_2_0)
				arg_2_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function(arg_3_0)
				Managers.input:block_device_except_service("options_menu", "gamepad")
				arg_3_0:activate_view("options_view")
				arg_3_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function(arg_4_0)
				arg_4_0:activate_view("credits_view")
				arg_4_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	else
		var_0_1 = {
			function(arg_5_0)
				local var_5_0 = arg_5_0._title_start_ui:game_type() or var_0_0.ONLINE

				arg_5_0:_start_game(var_5_0)
				arg_5_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function(arg_6_0)
				local var_6_0 = arg_6_0._title_start_ui:game_type() or var_0_0.ONLINE

				arg_6_0:_start_game(var_6_0, "prologue")
				arg_6_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function(arg_7_0)
				Managers.input:block_device_except_service("options_menu", "gamepad")
				arg_7_0:activate_view("options_view")
				arg_7_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function(arg_8_0)
				arg_8_0:activate_view("credits_view")
				arg_8_0._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	end
elseif GameSettingsDevelopment.additional_content_view_enabled then
	var_0_1 = {
		function(arg_9_0)
			local var_9_0 = arg_9_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_9_0:_start_game(var_9_0)
			arg_9_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function(arg_10_0)
			local var_10_0 = arg_10_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_10_0:_start_game(var_10_0, "prologue")
			arg_10_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function(arg_11_0)
			Managers.input:block_device_except_service("options_menu", "gamepad")
			arg_11_0:activate_view("options_view")
			arg_11_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function(arg_12_0)
			local var_12_0 = Managers.input

			arg_12_0:activate_view("cinematics_view")
			arg_12_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function(arg_13_0)
			Managers.input:block_device_except_service("additional_content_menu", "gamepad")
			arg_13_0:activate_view("additional_content_view")
			arg_13_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function(arg_14_0)
			arg_14_0:activate_view("credits_view")
			arg_14_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
else
	var_0_1 = {
		function(arg_15_0)
			local var_15_0 = arg_15_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_15_0:_start_game(var_15_0)
			arg_15_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function(arg_16_0)
			local var_16_0 = arg_16_0._title_start_ui:game_type() or var_0_0.ONLINE

			arg_16_0:_start_game(var_16_0, "prologue")
			arg_16_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function(arg_17_0)
			Managers.input:block_device_except_service("options_menu", "gamepad")
			arg_17_0:activate_view("options_view")
			arg_17_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function(arg_18_0)
			arg_18_0:activate_view("credits_view")
			arg_18_0._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
end

function StateTitleScreenMainMenu.on_enter(arg_19_0, arg_19_1)
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
	arg_19_0:_init_managers()
	arg_19_0:_update_chat_ignore_list()

	if arg_19_1.skip_signin then
		arg_19_0._title_start_ui:set_start_pressed(true)
	end

	Managers.transition:hide_loading_icon()

	arg_19_0._network_event_meta_table = {}

	function arg_19_0._network_event_meta_table.__index(arg_20_0, arg_20_1)
		return function()
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

	if GameSettingsDevelopment.additional_content_view_enabled then
		local var_19_0 = arg_19_0._views.additional_content_view

		if not (var_19_0 and var_19_0:has_active_splashes()) then
			arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("store", false, true, "start_game_disabled_playgo")
		else
			arg_19_0._title_start_ui:set_menu_item_enable_state_by_index("store", true, true)
		end
	end
end

function StateTitleScreenMainMenu._setup_sound(arg_22_0)
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

function StateTitleScreenMainMenu.cb_camera_animation_complete(arg_23_0)
	ShowCursorStack.show("StateTitleScreenMainMenu")
	arg_23_0._title_start_ui:activate_career_ui(true)
end

function StateTitleScreenMainMenu.cb_camera_animation_complete_back(arg_24_0)
	arg_24_0._new_state = StateTitleScreenMain
end

function StateTitleScreenMainMenu._setup_input(arg_25_0)
	arg_25_0.input_manager = Managers.input
end

function StateTitleScreenMainMenu._init_menu_views(arg_26_0)
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
			additional_content_view = GameSettingsDevelopment.additional_content_view_enabled and AdditionalContentView:new(var_26_1) or nil
		}
	end

	for iter_26_0, iter_26_1 in pairs(arg_26_0._views) do
		function iter_26_1.exit()
			arg_26_0:exit_current_view()
		end
	end
end

function StateTitleScreenMainMenu._init_managers(arg_28_0)
	local var_28_0 = Managers.account:user_id()

	Managers.xbox_stats = StatsManager2017:new(var_28_0)
end

function StateTitleScreenMainMenu._update_chat_ignore_list(arg_29_0)
	Managers.chat:update_ignore_list()
end

function StateTitleScreenMainMenu._try_activate_splash(arg_30_0)
	local var_30_0 = arg_30_0._views.additional_content_view

	if var_30_0 and var_30_0:has_active_splashes() and not SaveData.store_shown then
		Managers.input:block_device_except_service("additional_content_menu", "gamepad")
		arg_30_0:activate_view("additional_content_view")
		arg_30_0._title_start_ui:menu_option_activated(true)
		arg_30_0.parent:show_menu(true, true)
	else
		arg_30_0.parent:show_menu(true)
	end
end

if not BACKGROUND_ONLY then
	local var_0_2 = true
end

function StateTitleScreenMainMenu._update_network(arg_31_0, arg_31_1, arg_31_2)
	if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() then
		Network.update(arg_31_1, setmetatable({}, arg_31_0._network_event_meta_table))
	end
end

function StateTitleScreenMainMenu._start_game(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	arg_32_0._game_type = arg_32_1
	arg_32_0._level_key = arg_32_2
	arg_32_0._disable_trailer = arg_32_3 or not Application.user_setting("play_intro_cinematic")
	arg_32_0._profile_name = arg_32_4
	arg_32_0._input_disabled = true

	Managers.transition:show_loading_icon(false)
	arg_32_0._title_start_ui:disable_input(true)

	if arg_32_1 == var_0_0.OFFLINE then
		arg_32_0._state = "signin_to_backend"
	else
		arg_32_0._state = "check_connection_state"
	end
end

function StateTitleScreenMainMenu.update(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._title_start_ui

	arg_33_0:_update_play_go(arg_33_1, arg_33_2)
	arg_33_0:_update_network(arg_33_1, arg_33_2)

	local var_33_1 = false

	if arg_33_0._auto_start then
		local var_33_2 = arg_33_0.parent.parent.loading_context

		if var_33_2.offline_invite then
			var_33_1 = true
			var_33_2.offline_invite = nil
		else
			arg_33_0:_start_game(var_0_0.ONLINE)
		end

		arg_33_0._auto_start = nil
	end

	local var_33_3 = Managers.popup:has_popup()
	local var_33_4 = Managers.account:user_detached()

	if (Managers.invite:has_invitation() or var_33_1) and not arg_33_0._input_disabled and not var_33_3 and not var_33_4 and not arg_33_0._popup_id then
		if arg_33_0._is_installed then
			arg_33_0:_start_game(var_0_0.INVITATION, nil, true)
		else
			arg_33_0._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
			arg_33_0._state = "check_popup"
		end
	end

	local var_33_5 = arg_33_0._active_view

	if var_33_5 then
		arg_33_0._views[var_33_5]:update(arg_33_1, arg_33_2)
	else
		var_33_0:update(arg_33_1, arg_33_2)

		if script_data.honduras_demo then
			arg_33_0:_update_demo_input(arg_33_1, arg_33_2)
		else
			arg_33_0:_update_input(arg_33_1, arg_33_2)
		end
	end

	if not Managers.account:user_detached() then
		if arg_33_0._state == "check_connection_state" then
			arg_33_0:_check_connection_state()
			var_33_0:set_information_text(Localize("loading_checking_online_state"))
		elseif arg_33_0._state == "check_multiplayer_privileges" then
			arg_33_0:_check_privileges()
			var_33_0:set_information_text(Localize("loading_checking_privileges"))
		elseif arg_33_0._state == "signin_to_xsts" then
			var_33_0:set_information_text(Localize("loading_acquiring_xsts_token"))
			arg_33_0:_signin_to_xsts()
		elseif arg_33_0._state == "signin_to_backend" then
			arg_33_0:_signin_to_backend()
			var_33_0:set_information_text(Localize("loading_signing_in"))
		elseif arg_33_0._state == "waiting_for_backend_signin" then
			arg_33_0:_waiting_for_backend_signin()
		elseif arg_33_0._state == "check_popup" then
			arg_33_0:_check_popup()
		end
	elseif arg_33_0._popup_id then
		arg_33_0:_check_popup()
	end

	if Managers.account:leaving_game() then
		if var_33_5 then
			arg_33_0:exit_current_view()
		end

		arg_33_0.parent:show_menu(false)
		arg_33_0._title_start_ui:set_start_pressed(false)
	end

	return arg_33_0:_next_state()
end

function StateTitleScreenMainMenu._check_popup(arg_34_0)
	local var_34_0 = Managers.popup:query_result(arg_34_0._popup_id)

	if var_34_0 == "xbox_live_connection_error" then
		Managers.invite:clear_invites()
		arg_34_0:_close_menu()
	elseif var_34_0 == "privilege_error" then
		Managers.invite:clear_invites()
		arg_34_0:_close_menu()
	elseif var_34_0 == "xsts_error" then
		Managers.invite:clear_invites()
		arg_34_0:_close_menu()
	elseif var_34_0 == "not_installed" then
		Managers.invite:clear_invites()

		arg_34_0._state = "none"
	elseif var_34_0 == "update_offline_data" then
		print("[StateTitleScreenMainMenu] Updating offline data...")
		PlayfabBackendSaveDataUtils.update_offline_data(callback(arg_34_0, "cb_offline_data_updated"))
		arg_34_0._title_start_ui:set_update_offline_data_enabled(false)
		arg_34_0._title_start_ui:disable_input(true)

		arg_34_0._input_disabled = true

		Managers.transition:show_loading_icon(false)

		arg_34_0._state = "waiting_for_offline_data_update"
	elseif var_34_0 == "do_nothing" then
		arg_34_0._state = "none"
	elseif var_34_0 then
		fassert(false, "[StateTitleScreenMainMenu] The popup result doesn't exist (%s)", var_34_0)
	end

	if var_34_0 then
		arg_34_0._popup_id = nil
	end
end

function StateTitleScreenMainMenu.cb_offline_data_updated(arg_35_0, arg_35_1)
	if arg_35_1 then
		print("[StateTitleScreenMainMenu] Offline data update SUCCESS")
	else
		print("[StateTitleScreenMainMenu] Offline data update ERROR")
	end

	arg_35_0._title_start_ui:disable_input(false)

	arg_35_0._input_disabled = false

	Managers.transition:hide_loading_icon()

	arg_35_0._state = "none"
end

function StateTitleScreenMainMenu._close_menu(arg_36_0)
	arg_36_0.parent:show_menu(false)
	arg_36_0._title_start_ui:set_start_pressed(false)
	arg_36_0._title_start_ui:disable_input(false)
	arg_36_0._title_start_ui:set_game_type(nil)

	arg_36_0._closing_menu = true

	Managers.transition:hide_loading_icon()
	Managers.account:close_storage()

	if Managers.transition:fade_state() == "in" then
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(1)
	end

	arg_36_0._new_state = StateTitleScreenMain
	arg_36_0._state = "none"
end

function StateTitleScreenMainMenu._next_state(arg_37_0)
	if not Managers.popup:has_popup() and not arg_37_0._popup_id then
		if script_data.honduras_demo and not arg_37_0._title_start_ui:is_ready() then
			return
		end

		if Managers.backend and Managers.backend:is_disconnected() then
			arg_37_0:_close_menu()

			return arg_37_0._new_state
		elseif arg_37_0._closing_menu then
			return arg_37_0._new_state
		else
			return nil
		end
	end
end

function StateTitleScreenMainMenu._update_input(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.input_manager:get_service("main_menu")
	local var_38_1 = arg_38_0._title_start_ui:current_menu_index()
	local var_38_2 = arg_38_0._title_start_ui:active_menu_selection()
	local var_38_3 = Managers.popup:has_popup()
	local var_38_4 = Managers.account:user_detached()
	local var_38_5 = Managers.account:active_controller()

	if var_38_2 and not arg_38_0._input_disabled and not var_38_3 and not var_38_4 and not arg_38_0._popup_id then
		if var_38_1 and var_38_0:get("start", true) then
			var_38_0:get("confirm_press", true)
			var_0_1[var_38_1](arg_38_0)
		elseif var_38_0:get("back") then
			arg_38_0:_close_menu()
		elseif var_38_5.pressed(var_38_5.button_index("x")) then
			local var_38_6 = tonumber(string.gsub(var_38_5._name, "Pad", ""), 10)

			XboxLive.show_account_picker(var_38_6)

			local var_38_7, var_38_8, var_38_9, var_38_10 = XboxLive.show_account_picker_result()

			while var_38_7 do
				XboxLive.show_account_picker(var_38_6)

				local var_38_11

				var_38_7, var_38_11, var_38_9, var_38_10 = XboxLive.show_account_picker_result()
			end

			if var_38_10 == var_38_9 and var_38_10 == AccountManager.SIGNED_OUT then
				return
			elseif var_38_10 ~= AccountManager.SIGNED_OUT then
				arg_38_0._params.switch_user_auto_sign_in = true
			end

			arg_38_0:_close_menu()
		elseif arg_38_0._title_start_ui:offline_data_available() and var_38_5.pressed(var_38_5.button_index("y")) then
			arg_38_0._popup_id = Managers.popup:queue_popup(Localize("popup_update_offline_data"), Localize("popup_update_offline_data_header"), "update_offline_data", Localize("popup_choice_yes"), "do_nothing", Localize("popup_choice_no"))
			arg_38_0._state = "check_popup"
		end
	elseif not var_38_2 and not arg_38_0._input_disabled and var_38_0:get("back") then
		arg_38_0:_close_menu()
	end
end

function StateTitleScreenMainMenu._update_demo_input(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0._title_start_ui
	local var_39_1 = arg_39_0.input_manager:get_service("main_menu")
	local var_39_2 = Managers.popup:has_popup()
	local var_39_3 = Managers.account:user_detached()
	local var_39_4 = Managers.account:active_controller()

	if var_39_0:should_start() and not arg_39_0._input_disabled then
		local var_39_5, var_39_6 = var_39_0:selected_profile()

		arg_39_0:_start_game(var_0_0.ONLINE, DemoSettings.demo_level, nil, var_39_5)
		Managers.music:trigger_event("Play_console_menu_start_game")

		return
	end

	if Managers.time:get_demo_transition() and not var_39_0:in_transition() then
		var_39_0:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(arg_39_0, "cb_camera_animation_complete_back"))
		var_39_0:activate_career_ui(false)
		arg_39_0.parent:show_menu(false)
	end

	if not arg_39_0._input_disabled and not var_39_2 and not var_39_3 and not arg_39_0._popup_id then
		if var_39_1:get("back") then
			if not var_39_0:in_transition() then
				var_39_0:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(arg_39_0, "cb_camera_animation_complete_back"))
				var_39_0:activate_career_ui(false)
				arg_39_0:_close_menu()
			end
		elseif var_39_4.pressed(var_39_4.button_index("x")) and not var_39_0:in_transition() then
			local var_39_7 = tonumber(string.gsub(var_39_4._name, "Pad", ""), 10)

			XboxLive.show_account_picker(var_39_7)

			local var_39_8, var_39_9, var_39_10, var_39_11 = XboxLive.show_account_picker_result()

			while var_39_8 do
				XboxLive.show_account_picker(var_39_7)

				local var_39_12

				var_39_8, var_39_12, var_39_10, var_39_11 = XboxLive.show_account_picker_result()
			end

			if var_39_11 == var_39_10 and var_39_11 == AccountManager.SIGNED_OUT then
				return
			elseif var_39_11 ~= AccountManager.SIGNED_OUT then
				arg_39_0._params.switch_user_auto_sign_in = true
			end

			arg_39_0:_close_menu()
			var_39_0:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(arg_39_0, "cb_camera_animation_complete_back"))
			var_39_0:activate_career_ui(false)
		end
	end
end

function StateTitleScreenMainMenu._update_play_go(arg_40_0, arg_40_1, arg_40_2)
	if arg_40_0._is_installed then
		return
	end

	if Managers.play_go:installed() then
		arg_40_0._title_start_ui:set_menu_item_enable_state_by_index("start_game", true, true)
		arg_40_0._title_start_ui:set_menu_item_enable_state_by_index("cinematics", true, true)

		arg_40_0._is_installed = true
	end
end

function StateTitleScreenMainMenu.on_exit(arg_41_0)
	for iter_41_0, iter_41_1 in pairs(arg_41_0._views) do
		if iter_41_1.destroy then
			iter_41_1:destroy()
		end
	end

	arg_41_0._views = nil
end

function StateTitleScreenMainMenu.cb_fade_in_done(arg_42_0)
	local var_42_0 = arg_42_0._game_type
	local var_42_1 = arg_42_0._level_key
	local var_42_2 = arg_42_0._disable_trailer or not Application.user_setting("play_intro_cinematic")
	local var_42_3 = arg_42_0._profile_name
	local var_42_4, var_42_5 = Managers.mechanism:should_run_tutorial()

	if var_42_4 and not Managers.backend:get_user_data("prologue_started") and not script_data.settings.disable_tutorial_at_start and not script_data.disable_prologue and not script_data.honduras_demo then
		var_42_2 = false
		var_42_1 = "prologue"
	end

	arg_42_0.parent.state = StateLoading

	local var_42_6 = arg_42_0.parent.parent.loading_context

	var_42_6.restart_network = true
	var_42_6.level_key = var_42_1

	if var_42_0 == var_0_0.INVITATION then
		var_42_6.first_time = false
	end

	if var_42_1 then
		local var_42_7 = LevelHelper.get_environment_variation_id and LevelHelper:get_environment_variation_id(var_42_1) or nil

		Managers.level_transition_handler:set_next_level(var_42_1, var_42_7)
	end

	if var_42_1 == "prologue" then
		var_42_6.gamma_correct = not SaveData.gamma_corrected
		var_42_6.play_trailer = true
		var_42_6.switch_to_tutorial_backend = var_42_4
		var_42_6.wanted_tutorial_state = var_42_5
	elseif script_data.honduras_demo then
		arg_42_0.parent.parent.loading_context.wanted_profile_index = var_42_3 and FindProfileIndex(var_42_3) or DemoSettings.wanted_profile_index
		GameSettingsDevelopment.disable_free_flight = DemoSettings.disable_free_flight
		GameSettingsDevelopment.disable_intro_trailer = DemoSettings.disable_intro_trailer
	elseif not var_42_1 then
		var_42_6.gamma_correct = not SaveData.gamma_corrected
		var_42_6.show_profile_on_startup = true

		if not var_42_2 then
			var_42_6.play_trailer = true
		end
	end
end

function StateTitleScreenMainMenu.activate_view(arg_43_0, arg_43_1)
	arg_43_0._active_view = arg_43_1

	local var_43_0 = arg_43_0._views

	assert(var_43_0[arg_43_1])

	if arg_43_1 and var_43_0[arg_43_1] and var_43_0[arg_43_1].on_enter then
		var_43_0[arg_43_1]:on_enter()
	end
end

function StateTitleScreenMainMenu.exit_current_view(arg_44_0)
	local var_44_0 = arg_44_0._active_view
	local var_44_1 = arg_44_0._views

	assert(var_44_0)

	if var_44_1[var_44_0] and var_44_1[var_44_0].on_exit then
		var_44_1[var_44_0]:on_exit()
	end

	arg_44_0._active_view = nil

	Managers.input:block_device_except_service("main_menu", "gamepad")
	arg_44_0._title_start_ui:menu_option_activated(false)
end

function StateTitleScreenMainMenu._check_connection_state(arg_45_0)
	if XboxLive.online_state() == XboxOne.OFFLINE then
		arg_45_0._popup_id = Managers.popup:queue_popup(Localize("popup_xbox_live_connection_error"), Localize("popup_xbox_live_connection_error_header"), "xbox_live_connection_error", Localize("menu_ok"))
		arg_45_0._state = "check_popup"
	else
		arg_45_0._state = "check_multiplayer_privileges"
	end
end

function StateTitleScreenMainMenu._check_privileges(arg_46_0)
	if Managers.account:is_privileges_initialized() then
		Managers.account:get_privilege_async(UserPrivilege.MULTIPLAYER_SESSIONS, true, callback(arg_46_0, "cb_privilege_updated"))

		arg_46_0._state = "none"
	end
end

function StateTitleScreenMainMenu.cb_privilege_updated(arg_47_0, arg_47_1)
	if Managers.account:has_privilege_error() then
		arg_47_0._popup_id = Managers.popup:queue_popup(Localize("popup_privilege_error"), Localize("popup_privilege_error_header"), "privilege_error", Localize("menu_ok"))
		arg_47_0._state = "check_popup"
	elseif Managers.account:has_privilege(UserPrivilege.MULTIPLAYER_SESSIONS) then
		arg_47_0._state = "signin_to_xsts"
	else
		arg_47_0._popup_id = Managers.popup:queue_popup(Localize("popup_xbox_live_gold_error"), Localize("popup_xbox_live_gold_error_header"), "privilege_error", Localize("menu_ok"))
		arg_47_0._state = "check_popup"
	end
end

function StateTitleScreenMainMenu._signin_to_xsts(arg_48_0)
	local var_48_0 = UserXSTS.has(Managers.account:user_id())
	local var_48_1 = ScriptXSTSToken:new(var_48_0)

	Managers.token:register_token(var_48_1, callback(arg_48_0, "cb_xsts_token_received"))

	arg_48_0._state = "waiting_for_xsts"
end

function StateTitleScreenMainMenu.cb_xsts_token_received(arg_49_0, arg_49_1)
	print("[StateTitleScreenMainMenu] cb_xsts_token_received")

	local var_49_0 = arg_49_0._title_start_ui

	if arg_49_1.error then
		arg_49_0._popup_id = Managers.popup:queue_popup(Localize("popup_xsts_signin_failed"), Localize("popup_xsts_signin_failed_header"), "xsts_error", Localize("menu_ok"))
		arg_49_0._state = "check_popup"
	else
		print("[StateTitleScreenMainMenu] Successfully acquired an XSTS token")
		print("################  XSTS  ##################")

		arg_49_0._xsts_result = arg_49_1.result

		print(arg_49_0._xsts_result)
		print("################ XSTS END ################")

		arg_49_0._state = "signin_to_backend"
	end
end

function StateTitleScreenMainMenu._signin_to_backend(arg_50_0)
	local var_50_0 = Development.parameter("mechanism") or "adventure"
	local var_50_1 = MechanismSettings[var_50_0]
	local var_50_2 = var_50_1 and var_50_1.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.unlock = UnlockManager:new()

	if arg_50_0._game_type == var_0_0.OFFLINE then
		print("Using Offline Backend")
		Managers.account:set_offline_mode(true)

		if not Managers.rest_transport_offline then
			require("scripts/managers/rest_transport_offline/rest_transport_manager_offline")

			local var_50_3 = require("scripts/managers/rest_transport_offline/offline_backend_playfab")

			Managers.rest_transport_offline = RestTransportManagerOffline:new(var_50_3.endpoints)
		end

		Managers.rest_transport = Managers.rest_transport_offline
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabXbox", var_50_2, "DataServerQueue")

		Managers.backend:signin("")
	else
		print("Using Online Backend")
		Managers.account:set_offline_mode(false)

		Managers.rest_transport = Managers.rest_transport_online
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabXbox", var_50_2, "DataServerQueue")

		Managers.backend:signin(arg_50_0._xsts_result)
		Managers.account:set_xsts_token(arg_50_0._xsts_result)

		arg_50_0._xsts_result = nil
	end

	arg_50_0._state = "waiting_for_backend_signin"
end

function StateTitleScreenMainMenu._waiting_for_backend_signin(arg_51_0)
	local var_51_0 = Managers.backend

	if var_51_0 and var_51_0:authenticated() then
		arg_51_0._params.menu_screen_music_playing = false

		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(arg_51_0, "cb_fade_in_done"))

		arg_51_0._state = "none"
	end
end
