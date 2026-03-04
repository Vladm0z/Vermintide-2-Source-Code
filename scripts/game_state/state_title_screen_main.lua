-- chunkname: @scripts/game_state/state_title_screen_main.lua

require("scripts/ui/views/title_main_ui")
require("scripts/ui/views/weave_splash_ui")

if script_data.honduras_demo then
	require("scripts/ui/views/demo_title_ui")
end

StateTitleScreenMain = class(StateTitleScreenMain)
StateTitleScreenMain.NAME = "StateTitleScreenMain"

local var_0_0 = script_data.honduras_demo and DemoSettings.attract_timer or nil

function StateTitleScreenMain.on_enter(arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateTitleScreenMain")

	arg_1_0._params = arg_1_1
	arg_1_0._world = arg_1_0._params.world
	arg_1_0._viewport = arg_1_0._params.viewport
	arg_1_0._attract_mode_timer = var_0_0
	arg_1_0._attract_mode_active = false
	arg_1_0._auto_start = arg_1_1.auto_start
	arg_1_0._auto_sign_in = arg_1_1.auto_sign_in
	arg_1_0.input_manager = Managers.input
	arg_1_0._windows_auto_sign_in = arg_1_0.parent.parent.loading_context.windows_auto_sign_in
	arg_1_0.parent.parent.loading_context.windows_auto_sign_in = nil
	arg_1_0._title_start_ui = arg_1_1.ui

	if arg_1_0._title_start_ui and IS_CONSOLE then
		arg_1_0._title_start_ui:clear_user_name()
	end

	arg_1_0:_setup_account_manager()

	arg_1_0._error_popups = {}

	if IS_XB1 then
		if not Managers.account:should_teardown_xboxlive() then
			Managers.account:reset()
		end

		if Managers.xbox_stats then
			Managers.xbox_stats:destroy()

			Managers.xbox_stats = nil
		end
	elseif IS_PS4 then
		Managers.account:reset()
	else
		Managers.account:reset()
	end

	if Managers.twitch then
		Managers.twitch:reset()
	end

	if Managers.matchmaking then
		Managers.matchmaking:destroy()

		Managers.matchmaking = nil
	end

	Managers.input:set_all_gamepads_available()

	if Managers.voice_chat and Managers.voice_chat:initiated() then
		Managers.voice_chat:reset()
	end

	arg_1_0._network_event_meta_table = {}

	function arg_1_0._network_event_meta_table.__index(arg_2_0, arg_2_1)
		return function()
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_2_1)
		end
	end

	if IS_PS4 and arg_1_0.parent.invite_handled then
		Managers.invite:clear_invites()

		arg_1_0.parent.invite_handled = nil
	end

	if script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "true")
	end

	if not arg_1_0._params.menu_screen_music_playing and not GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") and not arg_1_0._auto_start then
		Managers.music:trigger_event("Play_console_menu_music")

		arg_1_0._params.menu_screen_music_playing = true
	elseif arg_1_0._params.menu_screen_music_playing then
		Managers.music:trigger_event("Play_console_menu_music_reset_switch")
	end
end

function StateTitleScreenMain._queue_popup(arg_4_0, ...)
	arg_4_0._error_popups[#arg_4_0._error_popups + 1] = Managers.popup:queue_popup(...)
end

function StateTitleScreenMain._setup_account_manager(arg_5_0)
	Managers.account = Managers.account or AccountManager:new()

	Crashify.print_property("region", Managers.account:region())
end

function StateTitleScreenMain.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_network(arg_6_1, arg_6_2)

	if Managers.voice_chat then
		Managers.voice_chat:update(arg_6_1, arg_6_2)
	end

	if not GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		local var_6_0 = arg_6_0.parent.parent.loading_context

		if var_6_0.previous_session_error then
			local var_6_1 = var_6_0.previous_session_error

			var_6_0.previous_session_error = nil

			arg_6_0:_queue_popup(Localize(var_6_1), Localize("popup_error_topic"), "ok", Localize("menu_ok"))
		end

		arg_6_0._title_start_ui:update(arg_6_1, arg_6_2)

		local var_6_2 = #arg_6_0._error_popups
		local var_6_3 = arg_6_0._error_popups[var_6_2]

		if var_6_3 then
			local var_6_4 = Managers.popup:query_result(var_6_3)

			if var_6_4 == "ok" then
				Managers.popup:cancel_popup(var_6_3)
				table.remove(arg_6_0._error_popups, 1)
			elseif var_6_4 == "not_installed" then
				Managers.invite:clear_invites()
				Managers.popup:cancel_popup(var_6_3)
				table.remove(arg_6_0._error_popups, 1)
			elseif var_6_4 then
				fassert(false, "Unhandled popup result %s", var_6_4)
			end
		else
			arg_6_0:_handle_continue_input(arg_6_1, arg_6_2)
			arg_6_0:_update_input(arg_6_1, arg_6_2)
			arg_6_0:_update_attract_mode(arg_6_1, arg_6_2)
		end
	else
		arg_6_0._state = StateTitleScreenInitNetwork
	end

	return arg_6_0:_next_state()
end

function StateTitleScreenMain._update_network(arg_7_0, arg_7_1, arg_7_2)
	if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() then
		Network.update(arg_7_1, setmetatable({}, arg_7_0._network_event_meta_table))
	end
end

function StateTitleScreenMain._update_attract_mode(arg_8_0, arg_8_1, arg_8_2)
	if IS_WINDOWS then
		return
	end

	if arg_8_0._title_start_ui:attract_mode() then
		if arg_8_0._title_start_ui:video_completed() then
			arg_8_0:_exit_attract_mode()
		end
	elseif arg_8_0._attract_mode_timer then
		arg_8_0._attract_mode_timer = arg_8_0._attract_mode_timer - arg_8_1

		if arg_8_0._attract_mode_timer <= 0 then
			arg_8_0:_enter_attract_mode()
		end
	end
end

function StateTitleScreenMain._enter_attract_mode(arg_9_0)
	Managers.music:stop_all_sounds()
	arg_9_0._title_start_ui:enter_attract_mode()
	arg_9_0.parent:enter_attract_mode(true)

	arg_9_0._attract_mode_active = true
end

function StateTitleScreenMain._exit_attract_mode(arg_10_0)
	Managers.music:stop_all_sounds()
	Managers.music:trigger_event("Play_menu_screen_music")

	arg_10_0._params.menu_screen_music_playing = true
	arg_10_0._attract_mode_timer = var_0_0
	arg_10_0._attract_mode_active = false

	Managers.transition:force_fade_in()
	Managers.transition:fade_out(1)
	arg_10_0._title_start_ui:exit_attract_mode()
	arg_10_0.parent:enter_attract_mode(false)
end

function StateTitleScreenMain._handle_continue_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.input_manager:get_service("main_menu")
	local var_11_1 = true

	if script_data.honduras_demo then
		var_11_1 = not arg_11_0._title_start_ui:in_transition()
	end

	if var_11_1 then
		if var_11_0:get("start", true) or arg_11_0._windows_auto_sign_in then
			local var_11_2 = Managers.input:get_most_recent_device()

			if IS_XB1 and (var_11_2._name == "Keyboard" or var_11_2._name == "Mouse") then
				arg_11_0:_queue_popup(Localize("popup_signin_only_with_gamepad"), Localize("popup_notice_topic"), "ok", Localize("popup_choice_ok"))
			else
				arg_11_0._start_pressed = true
			end
		elseif script_data.honduras_demo then
			local var_11_3 = Managers.input:get_most_recent_device()

			if var_11_3:any_pressed() then
				if IS_XB1 and (var_11_3._name == "Keyboard" or var_11_3._name == "Mouse") then
					arg_11_0:_queue_popup(Localize("popup_signin_only_with_gamepad"), Localize("popup_notice_topic"), "ok", Localize("popup_choice_ok"))
				else
					arg_11_0._start_pressed = true
				end
			end
		end
	end

	if IS_CONSOLE and arg_11_0._title_start_ui:attract_mode() and Managers.input:get_most_recent_device():any_pressed() then
		arg_11_0._start_pressed = true
	end

	if var_11_0:has("delete_save") and var_11_0:get("delete_save") and BUILD ~= "release" then
		StateTitleScreenLoadSave.DELETE_SAVE = true
	end
end

function StateTitleScreenMain._user_exists(arg_12_0, arg_12_1)
	local var_12_0 = {
		XboxLive.users()
	}

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_1.id == arg_12_1 then
			return true
		end
	end

	return false
end

function StateTitleScreenMain._update_input(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = PLATFORM
	local var_13_1 = Managers.input:get_most_recent_device()

	if IS_PS4 then
		local var_13_2 = SessionInvitation.play_together_list()

		if var_13_2 then
			Managers.invite:set_play_together_list(var_13_2)
		end
	end

	if IS_PS4 and (Managers.invite:has_invitation() or Managers.invite:play_together_list()) and not arg_13_0._state then
		if Managers.play_go:installed() then
			Managers.music:trigger_event("Play_console_menu_select")

			if PS4.signed_in() then
				Managers.account:set_controller(var_13_1)
				Managers.input:set_exclusive_gamepad(var_13_1)
				arg_13_0._title_start_ui:set_start_pressed(true)

				arg_13_0._state = StateTitleScreenLoadSave

				if Managers.invite:has_invitation() then
					arg_13_0.parent.invite_handled = true
				end
			else
				arg_13_0:_queue_popup(Localize("popup_ps4_not_signed_in"), Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))

				arg_13_0._start_pressed = false
			end
		else
			arg_13_0:_queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		end
	elseif (arg_13_0._start_pressed or LEVEL_EDITOR_TEST or arg_13_0._auto_start or GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") or arg_13_0._params.switch_user_auto_sign_in or arg_13_0._has_engaged) and not arg_13_0._state then
		if IS_CONSOLE and arg_13_0._title_start_ui:attract_mode() then
			arg_13_0:_exit_attract_mode()

			arg_13_0._start_pressed = false
		elseif IS_WINDOWS then
			arg_13_0._state = StateTitleScreenInitNetwork

			arg_13_0._title_start_ui:set_start_pressed(true)
			arg_13_0._title_start_ui:set_information_text(Localize("loading_signing_in"))
		elseif IS_XB1 then
			if not var_13_1 or var_13_1.type() ~= "xbox_controller" then
				arg_13_0._start_pressed = false

				return
			end

			if not Managers.account:all_sessions_cleaned_up() then
				arg_13_0._start_pressed = false

				return
			end

			local var_13_3 = var_13_1 and var_13_1.user_id()

			if Application.is_constrained() then
				arg_13_0._has_engaged = false
			end

			local var_13_4 = true

			if arg_13_0._has_engaged then
				var_13_4 = var_13_3 and arg_13_0:_user_exists(var_13_3)
			end

			if var_13_4 and var_13_3 and Managers.account:user_exists(var_13_3) then
				if Managers.account:sign_in(var_13_3, var_13_1, arg_13_0._auto_sign_in) then
					Managers.music:trigger_event("Play_console_menu_select")
					arg_13_0._title_start_ui:set_start_pressed(true)

					arg_13_0._params.switch_user_auto_sign_in = nil
					arg_13_0._state = StateTitleScreenLoadSave
				else
					arg_13_0._has_engaged = false
					arg_13_0._start_pressed = false
				end
			elseif var_13_1 and string.match(var_13_1._name, "Pad") and not arg_13_0._has_engaged and not Application.is_constrained() then
				local var_13_5 = tonumber(string.gsub(var_13_1._name, "Pad", ""), 10)

				XboxLive.show_account_picker(var_13_5)

				local var_13_6, var_13_7, var_13_8, var_13_9 = XboxLive.show_account_picker_result()
				local var_13_10 = 4294967295

				if var_13_6 or var_13_9 == var_13_10 then
					print("[StateTitleScreenMain] Invalid profile selected from account picker --> Resetting")

					arg_13_0._has_engaged = false
					arg_13_0._start_pressed = false
				else
					arg_13_0._has_engaged = true
				end
			elseif var_13_4 then
				arg_13_0._has_engaged = false
				arg_13_0._start_pressed = false
			end
		elseif IS_PS4 then
			Managers.music:trigger_event("Play_console_menu_select")
			Managers.input:set_exclusive_gamepad(var_13_1)
			Managers.account:set_controller(var_13_1)
			arg_13_0._title_start_ui:set_start_pressed(true)

			arg_13_0._state = StateTitleScreenLoadSave
		end
	else
		arg_13_0._title_start_ui:set_start_pressed(false)
	end
end

function StateTitleScreenMain._next_state(arg_14_0)
	if arg_14_0._state then
		return arg_14_0._state
	end
end

function StateTitleScreenMain.on_exit(arg_15_0)
	return
end
