-- chunkname: @scripts/game_state/title_screen_substates/xb1/state_title_screen_main_menu.lua

require("scripts/ui/views/additional_content/additional_content_view")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

local tbl = {
	INVITATION = "invitation",
	OFFLINE = "offline",
	ONLINE = "online"
}
local var_0_1

if not script_data.honduras_demo then
	var_0_1 = {
		function (self)
			-- function 1
			self:_start_game(tbl.ONLINE, DemoSettings.demo_level)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end
	}
elseif not script_data.settings.use_beta_mode then
	if not script_data.settings.disable_tutorial_at_start then
		var_0_1 = {
			function (self)
				-- function 2
				local game_type = self._title_start_ui:game_type()

				game_type = game_type or tbl.ONLINE

				self:_start_game(game_type)
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (self)
				-- function 3
				Managers.input:block_device_except_service("options_menu", "gamepad")
				self:activate_view("options_view")
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function (self)
				-- function 4
				self:activate_view("credits_view")
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	else
		var_0_1 = {
			function (self)
				-- function 5
				local game_type = self._title_start_ui:game_type()

				game_type = game_type or tbl.ONLINE

				self:_start_game(game_type)
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (self)
				-- function 6
				local game_type = self._title_start_ui:game_type()

				game_type = game_type or tbl.ONLINE

				self:_start_game(game_type, "prologue")
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (self)
				-- function 7
				Managers.input:block_device_except_service("options_menu", "gamepad")
				self:activate_view("options_view")
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function (self)
				-- function 8
				self:activate_view("credits_view")
				self._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	end
elseif not GameSettingsDevelopment.additional_content_view_enabled then
	var_0_1 = {
		function (self)
			-- function 9
			local game_type = self._title_start_ui:game_type()

			game_type = game_type or tbl.ONLINE

			self:_start_game(game_type)
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (self)
			-- function 10
			local game_type = self._title_start_ui:game_type()

			game_type = game_type or tbl.ONLINE

			self:_start_game(game_type, "prologue")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (self)
			-- function 11
			Managers.input:block_device_except_service("options_menu", "gamepad")
			self:activate_view("options_view")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (self)
			-- function 12
			local input = Managers.input

			self:activate_view("cinematics_view")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (self)
			-- function 13
			Managers.input:block_device_except_service("additional_content_menu", "gamepad")
			self:activate_view("additional_content_view")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (self)
			-- function 14
			self:activate_view("credits_view")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
else
	var_0_1 = {
		function (self)
			-- function 15
			local game_type = self._title_start_ui:game_type()

			game_type = game_type or tbl.ONLINE

			self:_start_game(game_type)
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (self)
			-- function 16
			local game_type = self._title_start_ui:game_type()

			game_type = game_type or tbl.ONLINE

			self:_start_game(game_type, "prologue")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (self)
			-- function 17
			Managers.input:block_device_except_service("options_menu", "gamepad")
			self:activate_view("options_view")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (self)
			-- function 18
			self:activate_view("credits_view")
			self._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
end

StateTitleScreenMainMenu.on_enter = function (self, arg_19_1)
	-- function 19
	print("[Gamestate] Enter Substate StateTitleScreenMainMenu")

	self._params = arg_19_1
	self._world = arg_19_1.world
	self._viewport = arg_19_1.viewport
	self._title_start_ui = arg_19_1.ui
	self._auto_start = arg_19_1.auto_start
	arg_19_1.auto_start = nil
	self._state = "none"
	self._new_state = nil
	self._input_disabled = false
	self._game_type = nil
	self._level_key = nil
	self._disable_trailer = nil
	self._profile_name = nil

	if not script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "false")
	end

	UISettings.set_console_settings()
	self._setup_sound()
	self:_setup_input()
	self:_init_menu_views()
	self:_init_managers()
	self:_update_chat_ignore_list()

	if not arg_19_1.skip_signin then
		self._title_start_ui:set_start_pressed(true)
	end

	Managers.transition:hide_loading_icon()

	self._network_event_meta_table = {}

	self._network_event_meta_table.__index = function (arg_20_0, arg_20_1)
		-- function 20
		return function ()
			-- function 21
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_20_1)
		end
	end

	self._is_installed = Managers.play_go:installed()

	if not self._is_installed then
		self._title_start_ui:set_menu_item_enable_state_by_index("start_game", false, true, "start_game_disabled_playgo")
		self._title_start_ui:set_menu_item_enable_state_by_index("cinematics", false, true, "start_game_disabled_playgo")
	else
		self._title_start_ui:set_menu_item_enable_state_by_index("start_game", true, true)
		self._title_start_ui:set_menu_item_enable_state_by_index("cinematics", true, true)
	end

	if not PlayfabBackendSaveDataUtils.online_data_is_dirty() then
		self._title_start_ui:set_update_offline_data_enabled(true)
	else
		self._title_start_ui:set_update_offline_data_enabled(false)
	end

	self:_try_activate_splash()

	if not GameSettingsDevelopment.additional_content_view_enabled then
		local additional_content_view = self._views.additional_content_view

		if not (not additional_content_view and additional_content_view:has_active_splashes()) then
			self._title_start_ui:set_menu_item_enable_state_by_index("store", false, true, "start_game_disabled_playgo")
		else
			self._title_start_ui:set_menu_item_enable_state_by_index("store", true, true)
		end
	end
end

StateTitleScreenMainMenu._setup_sound = function (arg_22_0)
	-- function 22
	local user_setting = Application.user_setting("master_bus_volume")

	user_setting = user_setting or 90

	local user_setting_2 = Application.user_setting("music_bus_volume")

	user_setting_2 = user_setting_2 or 90

	local var_22_2

	if not GLOBAL_MUSIC_WORLD then
		var_22_2 = MUSIC_WWISE_WORLD
	else
		local world = Managers.world:world("music_world")

		var_22_2 = Managers.world:wwise_world(world)
	end

	WwiseWorld.set_global_parameter(var_22_2, "master_bus_volume", user_setting)
	Managers.music:set_master_volume(user_setting)
	Managers.music:set_music_volume(user_setting_2)
end

StateTitleScreenMainMenu.cb_camera_animation_complete = function (self)
	-- function 23
	ShowCursorStack.show("StateTitleScreenMainMenu")
	self._title_start_ui:activate_career_ui(true)
end

StateTitleScreenMainMenu.cb_camera_animation_complete_back = function (self)
	-- function 24
	self._new_state = StateTitleScreenMain
end

StateTitleScreenMainMenu._setup_input = function (self)
	-- function 25
	self.input_manager = Managers.input
end

StateTitleScreenMainMenu._init_menu_views = function (self)
	-- function 26
	local get_ui_renderer = self._title_start_ui:get_ui_renderer()
	local tbl = {
		in_title_screen = true,
		ui_renderer = get_ui_renderer,
		ui_top_renderer = get_ui_renderer,
		input_manager = Managers.input,
		world_manager = Managers.world
	}

	if not script_data.honduras_demo then
		self._title_start_ui:animate_to_camera(DemoSettings.camera_end_position, nil, callback(self, "cb_camera_animation_complete"))

		self._views = {}
	else
		local tbl_2 = {
			credits_view = CreditsView:new(tbl),
			options_view = OptionsView:new(tbl),
			cinematics_view = CinematicsView:new(tbl)
		}
		local var_26_3

		if not GameSettingsDevelopment.additional_content_view_enabled then
			var_26_3 = AdditionalContentView:new(tbl)

			if not var_26_3 then
				-- Nothing
			end
		end

		var_26_3 = nil

		::label_26_0::

		tbl_2.additional_content_view = var_26_3
		self._views = tbl_2
	end

	for k, v in pairs(self._views) do
		v.exit = function ()
			-- function 27
			self:exit_current_view()
		end
	end
end

StateTitleScreenMainMenu._init_managers = function (arg_28_0)
	-- function 28
	local user_id = Managers.account:user_id()

	Managers.xbox_stats = StatsManager2017:new(user_id)
end

StateTitleScreenMainMenu._update_chat_ignore_list = function (arg_29_0)
	-- function 29
	Managers.chat:update_ignore_list()
end

StateTitleScreenMainMenu._try_activate_splash = function (self)
	-- function 30
	local additional_content_view = self._views.additional_content_view

	if not (not additional_content_view and not additional_content_view:has_active_splashes() and SaveData.store_shown) then
		Managers.input:block_device_except_service("additional_content_menu", "gamepad")
		self:activate_view("additional_content_view")
		self._title_start_ui:menu_option_activated(true)
		self.parent:show_menu(true, true)
	else
		self.parent:show_menu(true)
	end
end

if not BACKGROUND_ONLY then
	local flag = true
end

StateTitleScreenMainMenu._update_network = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not rawget(_G, "LobbyInternal") and not LobbyInternal.network_initialized() then
		Network.update(arg_31_1, setmetatable({}, self._network_event_meta_table))
	end
end

StateTitleScreenMainMenu._start_game = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	self._game_type = arg_32_1
	self._level_key = arg_32_2
	self._disable_trailer = arg_32_3 or not Application.user_setting("play_intro_cinematic")
	self._profile_name = arg_32_4
	self._input_disabled = true

	Managers.transition:show_loading_icon(false)
	self._title_start_ui:disable_input(true)

	if arg_32_1 == tbl.OFFLINE then
		self._state = "signin_to_backend"
	else
		self._state = "check_connection_state"
	end
end

StateTitleScreenMainMenu.update = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _title_start_ui = self._title_start_ui

	self:_update_play_go(arg_33_1, arg_33_2)
	self:_update_network(arg_33_1, arg_33_2)

	local flag = false

	if not self._auto_start then
		local loading_context = self.parent.parent.loading_context

		if not loading_context.offline_invite then
			flag = true
			loading_context.offline_invite = nil
		else
			self:_start_game(tbl.ONLINE)
		end

		self._auto_start = nil
	end

	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()

	if not ((Managers.invite:has_invitation() or not flag) and self._input_disabled or has_popup or user_detached or self._popup_id) then
		if not self._is_installed then
			self:_start_game(tbl.INVITATION, nil, true)
		else
			self._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
			self._state = "check_popup"
		end
	end

	local _active_view = self._active_view

	if not _active_view then
		self._views[_active_view]:update(arg_33_1, arg_33_2)
	else
		_title_start_ui:update(arg_33_1, arg_33_2)

		if not script_data.honduras_demo then
			self:_update_demo_input(arg_33_1, arg_33_2)
		else
			self:_update_input(arg_33_1, arg_33_2)
		end
	end

	if not Managers.account:user_detached() then
		if self._state == "check_connection_state" then
			self:_check_connection_state()
			_title_start_ui:set_information_text(Localize("loading_checking_online_state"))
		elseif self._state == "check_multiplayer_privileges" then
			self:_check_privileges()
			_title_start_ui:set_information_text(Localize("loading_checking_privileges"))
		elseif self._state == "signin_to_xsts" then
			_title_start_ui:set_information_text(Localize("loading_acquiring_xsts_token"))
			self:_signin_to_xsts()
		elseif self._state == "signin_to_backend" then
			self:_signin_to_backend()
			_title_start_ui:set_information_text(Localize("loading_signing_in"))
		elseif self._state == "waiting_for_backend_signin" then
			self:_waiting_for_backend_signin()
		elseif self._state == "check_popup" then
			self:_check_popup()
		end
	elseif not self._popup_id then
		self:_check_popup()
	end

	if not Managers.account:leaving_game() then
		if not _active_view then
			self:exit_current_view()
		end

		self.parent:show_menu(false)
		self._title_start_ui:set_start_pressed(false)
	end

	return self:_next_state()
end

StateTitleScreenMainMenu._check_popup = function (self)
	-- function 34
	local query_result = Managers.popup:query_result(self._popup_id)

	if query_result == "xbox_live_connection_error" then
		Managers.invite:clear_invites()
		self:_close_menu()
	elseif query_result == "privilege_error" then
		Managers.invite:clear_invites()
		self:_close_menu()
	elseif query_result == "xsts_error" then
		Managers.invite:clear_invites()
		self:_close_menu()
	elseif query_result == "not_installed" then
		Managers.invite:clear_invites()

		self._state = "none"
	elseif query_result == "update_offline_data" then
		print("[StateTitleScreenMainMenu] Updating offline data...")
		PlayfabBackendSaveDataUtils.update_offline_data(callback(self, "cb_offline_data_updated"))
		self._title_start_ui:set_update_offline_data_enabled(false)
		self._title_start_ui:disable_input(true)

		self._input_disabled = true

		Managers.transition:show_loading_icon(false)

		self._state = "waiting_for_offline_data_update"
	elseif query_result == "do_nothing" then
		self._state = "none"
	elseif not query_result then
		fassert(false, "[StateTitleScreenMainMenu] The popup result doesn't exist (%s)", query_result)
	end

	if not query_result then
		self._popup_id = nil
	end
end

StateTitleScreenMainMenu.cb_offline_data_updated = function (self, arg_35_1)
	-- function 35
	if not arg_35_1 then
		print("[StateTitleScreenMainMenu] Offline data update SUCCESS")
	else
		print("[StateTitleScreenMainMenu] Offline data update ERROR")
	end

	self._title_start_ui:disable_input(false)

	self._input_disabled = false

	Managers.transition:hide_loading_icon()

	self._state = "none"
end

StateTitleScreenMainMenu._close_menu = function (self)
	-- function 36
	self.parent:show_menu(false)
	self._title_start_ui:set_start_pressed(false)
	self._title_start_ui:disable_input(false)
	self._title_start_ui:set_game_type(nil)

	self._closing_menu = true

	Managers.transition:hide_loading_icon()
	Managers.account:close_storage()

	if Managers.transition:fade_state() == "in" then
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(1)
	end

	self._new_state = StateTitleScreenMain
	self._state = "none"
end

StateTitleScreenMainMenu._next_state = function (self)
	-- function 37
	if not (Managers.popup:has_popup() or self._popup_id) then
		if not (not script_data.honduras_demo and self._title_start_ui:is_ready()) then
			return
		end

		if not Managers.backend and not Managers.backend:is_disconnected() then
			self:_close_menu()

			return self._new_state
		elseif not self._closing_menu then
			return self._new_state
		else
			return nil
		end
	end
end

StateTitleScreenMainMenu._update_input = function (self, arg_38_1, arg_38_2)
	-- function 38
	local get_service = self.input_manager:get_service("main_menu")
	local current_menu_index = self._title_start_ui:current_menu_index()
	local active_menu_selection = self._title_start_ui:active_menu_selection()
	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()
	local active_controller = Managers.account:active_controller()

	if not (not active_menu_selection and self._input_disabled or has_popup or user_detached or self._popup_id) then
		if not current_menu_index and not get_service:get("start", true) then
			get_service:get("confirm_press", true)
			var_0_1[current_menu_index](self)
		elseif not get_service:get("back") then
			self:_close_menu()
		elseif not active_controller.pressed(active_controller.button_index("x")) then
			local var_38_6 = tonumber(string.gsub(active_controller._name, "Pad", ""), 10)

			XboxLive.show_account_picker(var_38_6)

			local show_account_picker_result, var_38_8, var_38_9, var_38_10 = XboxLive.show_account_picker_result()

			while not show_account_picker_result do
				XboxLive.show_account_picker(var_38_6)

				local var_38_11

				show_account_picker_result, var_38_11, var_38_9, var_38_10 = XboxLive.show_account_picker_result()
			end

			if not (var_38_10 ~= var_38_9 or var_38_10 ~= AccountManager.SIGNED_OUT) then
				return
			elseif var_38_10 ~= AccountManager.SIGNED_OUT then
				self._params.switch_user_auto_sign_in = true
			end

			self:_close_menu()
		elseif not self._title_start_ui:offline_data_available() and not active_controller.pressed(active_controller.button_index("y")) then
			self._popup_id = Managers.popup:queue_popup(Localize("popup_update_offline_data"), Localize("popup_update_offline_data_header"), "update_offline_data", Localize("popup_choice_yes"), "do_nothing", Localize("popup_choice_no"))
			self._state = "check_popup"
		end
	elseif active_menu_selection or self._input_disabled or not get_service:get("back") then
		self:_close_menu()
	end
end

StateTitleScreenMainMenu._update_demo_input = function (self, arg_39_1, arg_39_2)
	-- function 39
	local _title_start_ui = self._title_start_ui
	local get_service = self.input_manager:get_service("main_menu")
	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()
	local active_controller = Managers.account:active_controller()

	if not (not _title_start_ui:should_start() and self._input_disabled) then
		local selected_profile, var_39_6 = _title_start_ui:selected_profile()

		self:_start_game(tbl.ONLINE, DemoSettings.demo_level, nil, selected_profile)
		Managers.music:trigger_event("Play_console_menu_start_game")

		return
	end

	if not (not Managers.time:get_demo_transition() and _title_start_ui:in_transition()) then
		_title_start_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
		_title_start_ui:activate_career_ui(false)
		self.parent:show_menu(false)
	end

	if not (self._input_disabled or has_popup or user_detached or self._popup_id) then
		if not get_service:get("back") then
			if not _title_start_ui:in_transition() then
				_title_start_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
				_title_start_ui:activate_career_ui(false)
				self:_close_menu()
			end
		elseif not (not active_controller.pressed(active_controller.button_index("x")) and _title_start_ui:in_transition()) then
			local var_39_7 = tonumber(string.gsub(active_controller._name, "Pad", ""), 10)

			XboxLive.show_account_picker(var_39_7)

			local show_account_picker_result, var_39_9, var_39_10, var_39_11 = XboxLive.show_account_picker_result()

			while not show_account_picker_result do
				XboxLive.show_account_picker(var_39_7)

				local var_39_12

				show_account_picker_result, var_39_12, var_39_10, var_39_11 = XboxLive.show_account_picker_result()
			end

			if not (var_39_11 ~= var_39_10 or var_39_11 ~= AccountManager.SIGNED_OUT) then
				return
			elseif var_39_11 ~= AccountManager.SIGNED_OUT then
				self._params.switch_user_auto_sign_in = true
			end

			self:_close_menu()
			_title_start_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
			_title_start_ui:activate_career_ui(false)
		end
	end
end

StateTitleScreenMainMenu._update_play_go = function (self, arg_40_1, arg_40_2)
	-- function 40
	if not self._is_installed then
		return
	end

	if not Managers.play_go:installed() then
		self._title_start_ui:set_menu_item_enable_state_by_index("start_game", true, true)
		self._title_start_ui:set_menu_item_enable_state_by_index("cinematics", true, true)

		self._is_installed = true
	end
end

StateTitleScreenMainMenu.on_exit = function (self)
	-- function 41
	for k, v in pairs(self._views) do
		if not v.destroy then
			v:destroy()
		end
	end

	self._views = nil
end

StateTitleScreenMainMenu.cb_fade_in_done = function (self)
	-- function 42
	local _game_type = self._game_type
	local _level_key = self._level_key
	local _disable_trailer = self._disable_trailer

	_disable_trailer = _disable_trailer or not Application.user_setting("play_intro_cinematic")

	local _profile_name = self._profile_name
	local should_run_tutorial, var_42_5 = Managers.mechanism:should_run_tutorial()

	if not (not should_run_tutorial and Managers.backend:get_user_data("prologue_started") or script_data.settings.disable_tutorial_at_start or script_data.disable_prologue or script_data.honduras_demo) then
		_disable_trailer = false
		_level_key = "prologue"
	end

	self.parent.state = StateLoading

	local loading_context = self.parent.parent.loading_context

	loading_context.restart_network = true
	loading_context.level_key = _level_key

	if _game_type == tbl.INVITATION then
		loading_context.first_time = false
	end

	if not _level_key then
		local get_environment_variation_id

		if not LevelHelper.get_environment_variation_id then
			get_environment_variation_id = LevelHelper:get_environment_variation_id(_level_key)

			if not get_environment_variation_id then
				-- Nothing
			end
		end

		get_environment_variation_id = nil

		::label_42_0::

		Managers.level_transition_handler:set_next_level(_level_key, get_environment_variation_id)
	end

	if _level_key == "prologue" then
		loading_context.gamma_correct = not SaveData.gamma_corrected
		loading_context.play_trailer = true
		loading_context.switch_to_tutorial_backend = should_run_tutorial
		loading_context.wanted_tutorial_state = var_42_5
	elseif not script_data.honduras_demo then
		local loading_context_2 = self.parent.parent.loading_context
		local var_42_9

		if not _profile_name then
			var_42_9 = FindProfileIndex(_profile_name)

			if not var_42_9 then
				-- Nothing
			end
		end

		var_42_9 = DemoSettings.wanted_profile_index

		::label_42_1::

		loading_context_2.wanted_profile_index = var_42_9
		GameSettingsDevelopment.disable_free_flight = DemoSettings.disable_free_flight
		GameSettingsDevelopment.disable_intro_trailer = DemoSettings.disable_intro_trailer
	elseif not _level_key then
		loading_context.gamma_correct = not SaveData.gamma_corrected
		loading_context.show_profile_on_startup = true

		if not _disable_trailer then
			loading_context.play_trailer = true
		end
	end
end

StateTitleScreenMainMenu.activate_view = function (self, arg_43_1)
	-- function 43
	self._active_view = arg_43_1

	local _views = self._views

	assert(_views[arg_43_1])

	if not arg_43_1 and not _views[arg_43_1] and not _views[arg_43_1].on_enter then
		_views[arg_43_1]:on_enter()
	end
end

StateTitleScreenMainMenu.exit_current_view = function (self)
	-- function 44
	local _active_view = self._active_view
	local _views = self._views

	assert(_active_view)

	if not _views[_active_view] and not _views[_active_view].on_exit then
		_views[_active_view]:on_exit()
	end

	self._active_view = nil

	Managers.input:block_device_except_service("main_menu", "gamepad")
	self._title_start_ui:menu_option_activated(false)
end

StateTitleScreenMainMenu._check_connection_state = function (self)
	-- function 45
	if XboxLive.online_state() == XboxOne.OFFLINE then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_xbox_live_connection_error"), Localize("popup_xbox_live_connection_error_header"), "xbox_live_connection_error", Localize("menu_ok"))
		self._state = "check_popup"
	else
		self._state = "check_multiplayer_privileges"
	end
end

StateTitleScreenMainMenu._check_privileges = function (self)
	-- function 46
	if not Managers.account:is_privileges_initialized() then
		Managers.account:get_privilege_async(UserPrivilege.MULTIPLAYER_SESSIONS, true, callback(self, "cb_privilege_updated"))

		self._state = "none"
	end
end

StateTitleScreenMainMenu.cb_privilege_updated = function (self, arg_47_1)
	-- function 47
	if not Managers.account:has_privilege_error() then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_privilege_error"), Localize("popup_privilege_error_header"), "privilege_error", Localize("menu_ok"))
		self._state = "check_popup"
	elseif not Managers.account:has_privilege(UserPrivilege.MULTIPLAYER_SESSIONS) then
		self._state = "signin_to_xsts"
	else
		self._popup_id = Managers.popup:queue_popup(Localize("popup_xbox_live_gold_error"), Localize("popup_xbox_live_gold_error_header"), "privilege_error", Localize("menu_ok"))
		self._state = "check_popup"
	end
end

StateTitleScreenMainMenu._signin_to_xsts = function (self)
	-- function 48
	local has = UserXSTS.has(Managers.account:user_id())
	local var_48_1 = ScriptXSTSToken:new(has)

	Managers.token:register_token(var_48_1, callback(self, "cb_xsts_token_received"))

	self._state = "waiting_for_xsts"
end

StateTitleScreenMainMenu.cb_xsts_token_received = function (self, arg_49_1)
	-- function 49
	print("[StateTitleScreenMainMenu] cb_xsts_token_received")

	local _title_start_ui = self._title_start_ui

	if not arg_49_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_xsts_signin_failed"), Localize("popup_xsts_signin_failed_header"), "xsts_error", Localize("menu_ok"))
		self._state = "check_popup"
	else
		print("[StateTitleScreenMainMenu] Successfully acquired an XSTS token")
		print("################  XSTS  ##################")

		self._xsts_result = arg_49_1.result

		print(self._xsts_result)
		print("################ XSTS END ################")

		self._state = "signin_to_backend"
	end
end

StateTitleScreenMainMenu._signin_to_backend = function (self)
	-- function 50
	local parameter = Development.parameter("mechanism")

	parameter = parameter or "adventure"

	local var_50_1 = MechanismSettings[parameter]
	local flag = not var_50_1 and var_50_1.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.unlock = UnlockManager:new()

	if self._game_type == tbl.OFFLINE then
		print("Using Offline Backend")
		Managers.account:set_offline_mode(true)

		if not Managers.rest_transport_offline then
			require("scripts/managers/rest_transport_offline/rest_transport_manager_offline")

			local scripts_managers_rest_transport_offline_offline_backend_playfab = require("scripts/managers/rest_transport_offline/offline_backend_playfab")

			Managers.rest_transport_offline = RestTransportManagerOffline:new(scripts_managers_rest_transport_offline_offline_backend_playfab.endpoints)
		end

		Managers.rest_transport = Managers.rest_transport_offline
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabXbox", flag, "DataServerQueue")

		Managers.backend:signin("")
	else
		print("Using Online Backend")
		Managers.account:set_offline_mode(false)

		Managers.rest_transport = Managers.rest_transport_online
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabXbox", flag, "DataServerQueue")

		Managers.backend:signin(self._xsts_result)
		Managers.account:set_xsts_token(self._xsts_result)

		self._xsts_result = nil
	end

	self._state = "waiting_for_backend_signin"
end

StateTitleScreenMainMenu._waiting_for_backend_signin = function (self)
	-- function 51
	local backend = Managers.backend

	if not backend and not backend:authenticated() then
		self._params.menu_screen_music_playing = false

		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(self, "cb_fade_in_done"))

		self._state = "none"
	end
end
