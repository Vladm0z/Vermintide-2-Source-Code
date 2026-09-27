-- chunkname: @scripts/game_state/state_title_screen_main.lua

require("scripts/ui/views/title_main_ui")
require("scripts/ui/views/weave_splash_ui")

if not script_data.honduras_demo then
	require("scripts/ui/views/demo_title_ui")
end

StateTitleScreenMain = class(StateTitleScreenMain)
StateTitleScreenMain.NAME = "StateTitleScreenMain"

local attract_timer

if not script_data.honduras_demo then
	attract_timer = DemoSettings.attract_timer

	if not attract_timer then
		-- Nothing
	end
end

attract_timer = nil

::label_0_0::

StateTitleScreenMain.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateTitleScreenMain")

	self._params = arg_1_1
	self._world = self._params.world
	self._viewport = self._params.viewport
	self._attract_mode_timer = attract_timer
	self._attract_mode_active = false
	self._auto_start = arg_1_1.auto_start
	self._auto_sign_in = arg_1_1.auto_sign_in
	self.input_manager = Managers.input
	self._windows_auto_sign_in = self.parent.parent.loading_context.windows_auto_sign_in
	self.parent.parent.loading_context.windows_auto_sign_in = nil
	self._title_start_ui = arg_1_1.ui

	if not self._title_start_ui and not IS_CONSOLE then
		self._title_start_ui:clear_user_name()
	end

	self:_setup_account_manager()

	self._error_popups = {}

	if not IS_XB1 then
		if not Managers.account:should_teardown_xboxlive() then
			Managers.account:reset()
		end

		if not Managers.xbox_stats then
			Managers.xbox_stats:destroy()

			Managers.xbox_stats = nil
		end
	elseif not IS_PS4 then
		Managers.account:reset()
	else
		Managers.account:reset()
	end

	if not Managers.twitch then
		Managers.twitch:reset()
	end

	if not Managers.matchmaking then
		Managers.matchmaking:destroy()

		Managers.matchmaking = nil
	end

	Managers.input:set_all_gamepads_available()

	if not Managers.voice_chat and not Managers.voice_chat:initiated() then
		Managers.voice_chat:reset()
	end

	self._network_event_meta_table = {}

	self._network_event_meta_table.__index = function (arg_2_0, arg_2_1)
		-- function 2
		return function ()
			-- function 3
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_2_1)
		end
	end

	if not IS_PS4 and not self.parent.invite_handled then
		Managers.invite:clear_invites()

		self.parent.invite_handled = nil
	end

	if not script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "true")
	end

	if not (self._params.menu_screen_music_playing or GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") or self._auto_start) then
		Managers.music:trigger_event("Play_console_menu_music")

		self._params.menu_screen_music_playing = true
	elseif not self._params.menu_screen_music_playing then
		Managers.music:trigger_event("Play_console_menu_music_reset_switch")
	end
end

StateTitleScreenMain._queue_popup = function (arg_4_0, ...)
	-- function 4
	arg_4_0._error_popups[#arg_4_0._error_popups + 1] = Managers.popup:queue_popup(...)
end

StateTitleScreenMain._setup_account_manager = function (arg_5_0)
	-- function 5
	local Managers = Managers
	local account = Managers.account

	account = account or AccountManager:new()
	Managers.account = account

	Crashify.print_property("region", Managers.account:region())
end

StateTitleScreenMain.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_network(arg_6_1, arg_6_2)

	if not Managers.voice_chat then
		Managers.voice_chat:update(arg_6_1, arg_6_2)
	end

	if not (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		local loading_context = self.parent.parent.loading_context

		if not loading_context.previous_session_error then
			local previous_session_error = loading_context.previous_session_error

			loading_context.previous_session_error = nil

			self:_queue_popup(Localize(previous_session_error), Localize("popup_error_topic"), "ok", Localize("menu_ok"))
		end

		self._title_start_ui:update(arg_6_1, arg_6_2)

		local count = #self._error_popups
		local var_6_3 = self._error_popups[count]

		if not var_6_3 then
			local query_result = Managers.popup:query_result(var_6_3)

			if query_result == "ok" then
				Managers.popup:cancel_popup(var_6_3)
				table.remove(self._error_popups, 1)
			elseif query_result == "not_installed" then
				Managers.invite:clear_invites()
				Managers.popup:cancel_popup(var_6_3)
				table.remove(self._error_popups, 1)
			elseif not query_result then
				fassert(false, "Unhandled popup result %s", query_result)
			end
		else
			self:_handle_continue_input(arg_6_1, arg_6_2)
			self:_update_input(arg_6_1, arg_6_2)
			self:_update_attract_mode(arg_6_1, arg_6_2)
		end
	else
		self._state = StateTitleScreenInitNetwork
	end

	return self:_next_state()
end

StateTitleScreenMain._update_network = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not rawget(_G, "LobbyInternal") and not LobbyInternal.network_initialized() then
		Network.update(arg_7_1, setmetatable({}, self._network_event_meta_table))
	end
end

StateTitleScreenMain._update_attract_mode = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not IS_WINDOWS then
		return
	end

	if not self._title_start_ui:attract_mode() then
		if not self._title_start_ui:video_completed() then
			self:_exit_attract_mode()
		end
	elseif not self._attract_mode_timer then
		self._attract_mode_timer = self._attract_mode_timer - arg_8_1

		if self._attract_mode_timer <= 0 then
			self:_enter_attract_mode()
		end
	end
end

StateTitleScreenMain._enter_attract_mode = function (self)
	-- function 9
	Managers.music:stop_all_sounds()
	self._title_start_ui:enter_attract_mode()
	self.parent:enter_attract_mode(true)

	self._attract_mode_active = true
end

StateTitleScreenMain._exit_attract_mode = function (self)
	-- function 10
	Managers.music:stop_all_sounds()
	Managers.music:trigger_event("Play_menu_screen_music")

	self._params.menu_screen_music_playing = true
	self._attract_mode_timer = attract_timer
	self._attract_mode_active = false

	Managers.transition:force_fade_in()
	Managers.transition:fade_out(1)
	self._title_start_ui:exit_attract_mode()
	self.parent:enter_attract_mode(false)
end

StateTitleScreenMain._handle_continue_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get_service = self.input_manager:get_service("main_menu")
	local flag = true

	if not script_data.honduras_demo then
		flag = not self._title_start_ui:in_transition()
	end

	if not flag then
		if get_service:get("start", true) or not self._windows_auto_sign_in then
			local get_most_recent_device = Managers.input:get_most_recent_device()

			if not (not IS_XB1 and get_most_recent_device._name == "Keyboard" or get_most_recent_device._name ~= "Mouse") then
				self:_queue_popup(Localize("popup_signin_only_with_gamepad"), Localize("popup_notice_topic"), "ok", Localize("popup_choice_ok"))
			else
				self._start_pressed = true
			end
		elseif not script_data.honduras_demo then
			local get_most_recent_device_2 = Managers.input:get_most_recent_device()

			if not get_most_recent_device_2:any_pressed() then
				if not (not IS_XB1 and get_most_recent_device_2._name == "Keyboard" or get_most_recent_device_2._name ~= "Mouse") then
					self:_queue_popup(Localize("popup_signin_only_with_gamepad"), Localize("popup_notice_topic"), "ok", Localize("popup_choice_ok"))
				else
					self._start_pressed = true
				end
			end
		end
	end

	if not IS_CONSOLE and not self._title_start_ui:attract_mode() and not Managers.input:get_most_recent_device():any_pressed() then
		self._start_pressed = true
	end

	if not (not get_service:has("delete_save") and not get_service:get("delete_save") and BUILD == "release") then
		StateTitleScreenLoadSave.DELETE_SAVE = true
	end
end

StateTitleScreenMain._user_exists = function (arg_12_0, arg_12_1)
	-- function 12
	local tbl = {
		XboxLive.users()
	}

	for k, v in pairs(tbl) do
		if v.id == arg_12_1 then
			return true
		end
	end

	return false
end

StateTitleScreenMain._update_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local PLATFORM = PLATFORM
	local get_most_recent_device = Managers.input:get_most_recent_device()

	if not IS_PS4 then
		local play_together_list = SessionInvitation.play_together_list()

		if not play_together_list then
			Managers.invite:set_play_together_list(play_together_list)
		end
	end

	if not (not IS_PS4 and Managers.invite:has_invitation() and not Managers.invite:play_together_list() and self._state) then
		if not Managers.play_go:installed() then
			Managers.music:trigger_event("Play_console_menu_select")

			if not PS4.signed_in() then
				Managers.account:set_controller(get_most_recent_device)
				Managers.input:set_exclusive_gamepad(get_most_recent_device)
				self._title_start_ui:set_start_pressed(true)

				self._state = StateTitleScreenLoadSave

				if not Managers.invite:has_invitation() then
					self.parent.invite_handled = true
				end
			else
				self:_queue_popup(Localize("popup_ps4_not_signed_in"), Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))

				self._start_pressed = false
			end
		else
			self:_queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		end
	elseif not ((self._start_pressed or LEVEL_EDITOR_TEST or self._auto_start or GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") or self._params.switch_user_auto_sign_in or not self._has_engaged) and self._state) then
		if not IS_CONSOLE and not self._title_start_ui:attract_mode() then
			self:_exit_attract_mode()

			self._start_pressed = false
		elseif not IS_WINDOWS then
			self._state = StateTitleScreenInitNetwork

			self._title_start_ui:set_start_pressed(true)
			self._title_start_ui:set_information_text(Localize("loading_signing_in"))
		elseif not IS_XB1 then
			if not (not get_most_recent_device and get_most_recent_device.type() == "xbox_controller") then
				self._start_pressed = false

				return
			end

			if not Managers.account:all_sessions_cleaned_up() then
				self._start_pressed = false

				return
			end

			local flag = not get_most_recent_device and get_most_recent_device.user_id()

			if not Application.is_constrained() then
				self._has_engaged = false
			end

			local flag_2 = true

			if not self._has_engaged then
				flag_2 = not flag and self:_user_exists(flag)
			end

			if not flag_2 and not flag and not Managers.account:user_exists(flag) then
				if not Managers.account:sign_in(flag, get_most_recent_device, self._auto_sign_in) then
					Managers.music:trigger_event("Play_console_menu_select")
					self._title_start_ui:set_start_pressed(true)

					self._params.switch_user_auto_sign_in = nil
					self._state = StateTitleScreenLoadSave
				else
					self._has_engaged = false
					self._start_pressed = false
				end
			elseif not (not get_most_recent_device and not string.match(get_most_recent_device._name, "Pad") and self._has_engaged or Application.is_constrained()) then
				local var_13_5 = tonumber(string.gsub(get_most_recent_device._name, "Pad", ""), 10)

				XboxLive.show_account_picker(var_13_5)

				local show_account_picker_result, var_13_7, var_13_8, var_13_9 = XboxLive.show_account_picker_result()
				local num = 4294967295

				if not (show_account_picker_result or var_13_9 ~= num) then
					print("[StateTitleScreenMain] Invalid profile selected from account picker --> Resetting")

					self._has_engaged = false
					self._start_pressed = false
				else
					self._has_engaged = true
				end
			elseif not flag_2 then
				self._has_engaged = false
				self._start_pressed = false
			end
		elseif not IS_PS4 then
			Managers.music:trigger_event("Play_console_menu_select")
			Managers.input:set_exclusive_gamepad(get_most_recent_device)
			Managers.account:set_controller(get_most_recent_device)
			self._title_start_ui:set_start_pressed(true)

			self._state = StateTitleScreenLoadSave
		end
	else
		self._title_start_ui:set_start_pressed(false)
	end
end

StateTitleScreenMain._next_state = function (self)
	-- function 14
	if not self._state then
		return self._state
	end
end

StateTitleScreenMain.on_exit = function (arg_15_0)
	-- function 15
	return
end
