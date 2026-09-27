-- chunkname: @scripts/game_state/title_screen_substates/ps4/state_title_screen_main_menu.lua

require("scripts/ui/views/additional_content/additional_content_view")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

local tbl = {
	HOST_PLAY_TOGETHER = "host_play_together",
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

	if script_data.settings.use_beta_mode or not GameSettingsDevelopment.additional_content_view_enabled then
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

		if script_data.settings.use_beta_mode or not GameSettingsDevelopment.additional_content_view_enabled then
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

StateTitleScreenMainMenu._update_chat_ignore_list = function (arg_28_0)
	-- function 28
	Managers.chat:update_ignore_list()
end

StateTitleScreenMainMenu._try_activate_splash = function (self)
	-- function 29
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

StateTitleScreenMainMenu._update_network = function (self, arg_30_1, arg_30_2)
	-- function 30
	if not rawget(_G, "LobbyInternal") and not LobbyInternal.network_initialized() then
		Network.update(arg_30_1, setmetatable({}, self._network_event_meta_table))
	end
end

StateTitleScreenMainMenu._start_game = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	self._game_type = arg_31_1
	self._level_key = arg_31_2
	self._disable_trailer = arg_31_3 or not Application.user_setting("play_intro_cinematic")
	self._profile_name = arg_31_4
	self._input_disabled = true

	Managers.transition:show_loading_icon(false)
	self._title_start_ui:disable_input(true)

	if arg_31_1 == tbl.OFFLINE then
		self._state = "signin_to_backend"
	else
		self._state = "check_restrictions"
	end
end

StateTitleScreenMainMenu.update = function (self, arg_32_1, arg_32_2)
	-- function 32
	local _title_start_ui = self._title_start_ui

	self:_update_play_go(arg_32_1, arg_32_2)
	self:_update_network(arg_32_1, arg_32_2)

	local flag = false
	local play_together_list = Managers.invite:play_together_list()

	if not self._auto_start then
		local loading_context = self.parent.parent.loading_context

		if not loading_context.offline_invite then
			flag = true
			loading_context.offline_invite = nil
		elseif not play_together_list then
			self:_start_game(tbl.ONLINE)
		end

		self._auto_start = nil
	end

	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()

	if not (self._input_disabled or has_popup or user_detached or self._popup_id) then
		if Managers.invite:has_invitation() or not flag then
			if not self._is_installed then
				self:_start_game(tbl.INVITATION, nil, true)
			else
				self._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
				self._state = "check_popup"
			end
		elseif not play_together_list then
			if not self._is_installed then
				self:_start_game(tbl.HOST_PLAY_TOGETHER, nil, true)
			else
				self._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
				self._state = "check_popup"
			end
		end
	end

	local _active_view = self._active_view

	if not _active_view then
		self._views[_active_view]:update(arg_32_1, arg_32_2)
	else
		_title_start_ui:update(arg_32_1, arg_32_2)

		if not script_data.honduras_demo then
			self:_update_demo_input(arg_32_1, arg_32_2)
		else
			self:_update_input(arg_32_1, arg_32_2)
		end
	end

	if not Managers.account:user_detached() then
		if self._state == "check_restrictions" then
			self:_check_restrictions()
			_title_start_ui:set_information_text(Localize("loading_checking_privileges"))
		elseif self._state == "check_restrictions_network" then
			self:_check_restrictions_network()
		elseif self._state == "check_restrictions_ps_plus" then
			self:_check_restrictions_ps_plus()
		elseif self._state == "check_restrictions_chat" then
			self:_check_restrictions_chat()
		elseif self._state == "update_ps_plus_dialog" then
			self:_update_ps_plus_dialog()
		elseif self._state == "update_chat_restriction_dialog" then
			self:_update_chat_restriction_dialog()
		elseif self._state == "request_np_auth_data" then
			_title_start_ui:set_information_text(Localize("loading_requesting_np_auth_data"))
			self:_request_np_auth_data()
		elseif self._state == "signin_to_backend" then
			self:_signin_to_backend()
			_title_start_ui:set_information_text(Localize("loading_signing_in"))
		elseif self._state == "waiting_for_backend_signin" then
			self:_waiting_for_backend_signin()
		elseif self._state == "check_popup" then
			self:_check_popup()
		end
	elseif self._state == "check_popup" then
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
	-- function 33
	local query_result = Managers.popup:query_result(self._popup_id)

	if query_result == "close_menu" then
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

StateTitleScreenMainMenu.cb_offline_data_updated = function (self, arg_34_1)
	-- function 34
	if not arg_34_1 then
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
	-- function 35
	self.parent:show_menu(false)
	self._title_start_ui:set_start_pressed(false)
	self._title_start_ui:disable_input(false)
	self._title_start_ui:set_game_type(nil)

	self._closing_menu = true

	Managers.transition:hide_loading_icon()

	if Managers.transition:fade_state() == "in" then
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(1)
	end

	self._new_state = StateTitleScreenMain
	self._state = "none"
end

StateTitleScreenMainMenu._next_state = function (self)
	-- function 36
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

StateTitleScreenMainMenu._update_input = function (self, arg_37_1, arg_37_2)
	-- function 37
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
		elseif not self._title_start_ui:offline_data_available() and not active_controller.pressed(active_controller.button_index("triangle")) then
			self._popup_id = Managers.popup:queue_popup(Localize("popup_update_offline_data"), Localize("popup_update_offline_data_header"), "update_offline_data", Localize("popup_choice_yes"), "do_nothing", Localize("popup_choice_no"))
			self._state = "check_popup"
		end
	end
end

StateTitleScreenMainMenu._update_demo_input = function (self, arg_38_1, arg_38_2)
	-- function 38
	local _title_start_ui = self._title_start_ui
	local get_service = self.input_manager:get_service("main_menu")
	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()
	local active_controller = Managers.account:active_controller()

	if not (not _title_start_ui:should_start() and self._input_disabled) then
		local selected_profile, var_38_6 = _title_start_ui:selected_profile()

		self:_start_game(tbl.ONLINE, DemoSettings.demo_level, nil, selected_profile)
		Managers.music:trigger_event("Play_console_menu_start_game")

		return
	end

	if not (not Managers.time:get_demo_transition() and _title_start_ui:in_transition()) then
		_title_start_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
		_title_start_ui:activate_career_ui(false)
		self.parent:show_menu(false)
	end

	if not ((self._input_disabled or has_popup or user_detached or self._popup_id or not get_service:get("back")) and _title_start_ui:in_transition()) then
		_title_start_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
		_title_start_ui:activate_career_ui(false)
		self:_close_menu()
	end
end

StateTitleScreenMainMenu._update_play_go = function (self, arg_39_1, arg_39_2)
	-- function 39
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
	-- function 40
	for k, v in pairs(self._views) do
		if not v.destroy then
			v:destroy()
		end
	end

	self._views = nil
end

StateTitleScreenMainMenu.cb_fade_in_done = function (self)
	-- function 41
	local _game_type = self._game_type
	local _level_key = self._level_key
	local _disable_trailer = self._disable_trailer

	_disable_trailer = _disable_trailer or not Application.user_setting("play_intro_cinematic")

	local _profile_name = self._profile_name
	local should_run_tutorial, var_41_5 = Managers.mechanism:should_run_tutorial()

	if not (not should_run_tutorial and Managers.backend:get_user_data("prologue_started") or script_data.settings.disable_tutorial_at_start or script_data.disable_prologue or script_data.honduras_demo) then
		_disable_trailer = false
		_level_key = "prologue"
	end

	self.parent.state = StateLoading

	local loading_context = self.parent.parent.loading_context

	loading_context.restart_network = true
	loading_context.level_key = _level_key

	if not (_game_type == tbl.INVITATION or _game_type ~= tbl.HOST_PLAY_TOGETHER) then
		loading_context.first_time = false
	end

	if not _level_key then
		local get_environment_variation_id = LevelHelper:get_environment_variation_id(_level_key)

		Managers.level_transition_handler:set_next_level(_level_key, get_environment_variation_id)
	end

	if _level_key == "prologue" then
		loading_context.gamma_correct = not SaveData.gamma_corrected
		loading_context.play_trailer = true
		loading_context.switch_to_tutorial_backend = should_run_tutorial
		loading_context.wanted_tutorial_state = var_41_5
	elseif not script_data.honduras_demo then
		local loading_context_2 = self.parent.parent.loading_context
		local var_41_9

		if not _profile_name then
			var_41_9 = FindProfileIndex(_profile_name)

			if not var_41_9 then
				-- Nothing
			end
		end

		var_41_9 = DemoSettings.wanted_profile_index

		::label_41_0::

		loading_context_2.wanted_profile_index = var_41_9
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

StateTitleScreenMainMenu.activate_view = function (self, arg_42_1)
	-- function 42
	self._active_view = arg_42_1

	local _views = self._views

	assert(_views[arg_42_1])

	if not arg_42_1 and not _views[arg_42_1] and not _views[arg_42_1].on_enter then
		_views[arg_42_1]:on_enter()
	end
end

StateTitleScreenMainMenu.exit_current_view = function (self)
	-- function 43
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

StateTitleScreenMainMenu._check_restrictions = function (self)
	-- function 44
	Managers.account:add_restriction_user(Managers.account:user_id())

	self._state = "check_restrictions_network"
end

StateTitleScreenMainMenu._check_restrictions_network = function (self)
	-- function 45
	if not Managers.account:restriction_access_fetched("network_availability") then
		return
	end

	local has_error = Managers.account:has_error("network_availability")
	local has_access = Managers.account:has_access("network_availability")

	if not has_error then
		self:_show_error_dialog(has_error)
	elseif not has_access then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_ps4_network_not_available"), Localize("popup_error_topic"), "close_menu", Localize("popup_choice_ok"))
		self._state = "check_popup"
	else
		self._state = "check_restrictions_ps_plus"
	end
end

StateTitleScreenMainMenu._check_restrictions_ps_plus = function (self)
	-- function 46
	if not Managers.account:restriction_access_fetched("playstation_plus") then
		return
	end

	local has_error = Managers.account:has_error("playstation_plus")
	local has_access = Managers.account:has_access("playstation_plus")

	if not has_error then
		self:_show_error_dialog(has_error)
	elseif not has_access then
		self:_setup_playstation_plus_dialog()
	else
		self._state = "check_restrictions_chat"
	end
end

StateTitleScreenMainMenu._check_restrictions_chat = function (self)
	-- function 47
	local account = Managers.account

	if not account:restriction_access_fetched("chat") then
		return
	end

	local has_error = account:has_error("chat")
	local has_access = account:has_access("chat")

	if not has_error then
		self:_show_error_dialog(has_error)
	elseif not has_access then
		self:_setup_chat_restriction_dialog()
	else
		self._state = "request_np_auth_data"
	end
end

StateTitleScreenMainMenu._setup_chat_restriction_dialog = function (self)
	-- function 48
	local user_id = Managers.account:user_id()

	Managers.system_dialog:open_system_dialog(MsgDialog.SYSTEM_MSG_TRC_PSN_CHAT_RESTRICTION, user_id)

	self._state = "update_chat_restriction_dialog"
end

StateTitleScreenMainMenu._update_chat_restriction_dialog = function (self)
	-- function 49
	if not Managers.system_dialog:has_open_dialogs() then
		return
	end

	self._state = "request_np_auth_data"
end

StateTitleScreenMainMenu._setup_playstation_plus_dialog = function (self)
	-- function 50
	NpCommerceDialog.initialize()

	self._state = "update_ps_plus_dialog"
end

StateTitleScreenMainMenu._update_ps_plus_dialog = function (self)
	-- function 51
	local update = NpCommerceDialog.update()

	if update == NpCommerceDialog.INITIALIZED then
		NpCommerceDialog.open2(NpCommerceDialog.MODE_PLUS, Managers.account:user_id(), NpCheck.REALTIME_MULTIPLAY)
	elseif update == NpCommerceDialog.FINISHED then
		local result, var_51_2 = NpCommerceDialog.result()

		NpCommerceDialog.terminate()

		if var_51_2 == true then
			Managers.account:refetch_restriction_access(nil, {
				"playstation_plus"
			})

			self._state = "check_restrictions_ps_plus"
		else
			self:_close_menu()
		end
	end
end

StateTitleScreenMainMenu._show_error_dialog = function (self, arg_52_1)
	-- function 52
	self._state = "waiting_for_error_dialog"

	Managers.system_dialog:open_error_dialog(arg_52_1, callback(self, "cb_error_dialog_done"))
end

StateTitleScreenMainMenu.cb_error_dialog_done = function (self)
	-- function 53
	self:_close_menu()
end

StateTitleScreenMainMenu._request_np_auth_data = function (self)
	-- function 54
	local create_async_token = NpAuth.create_async_token()
	local var_54_1 = ScriptNpAuthToken:new(create_async_token)

	Managers.token:register_token(var_54_1, callback(self, "cb_np_auth_data_received"))

	self._state = "waiting_for_np_auth_data"
end

StateTitleScreenMainMenu.cb_np_auth_data_received = function (self, arg_55_1)
	-- function 55
	print("[StateTitleScreenMainMenu] cb_np_auth_data_received")

	if not arg_55_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_np_auth_failed"), Localize("popup_np_auth_failed_header"), "close_menu", Localize("menu_ok"))
		self._state = "check_popup"
	else
		print("[StateTitleScreenMainMenu] Successfully acquired NpAuth data")

		self._np_auth_data = arg_55_1.data
		self._state = "signin_to_backend"
	end
end

StateTitleScreenMainMenu._signin_to_backend = function (self)
	-- function 56
	local parameter = Development.parameter("mechanism")

	parameter = parameter or "adventure"

	local var_56_1 = MechanismSettings[parameter]
	local flag = not var_56_1 and var_56_1.playfab_mirror or "PlayFabMirrorAdventure"

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
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabPS4", flag, "DataServerQueue")

		Managers.backend:signin()
	else
		print("Using Online Backend")
		Managers.account:set_offline_mode(false)
		Managers.account:fetch_user_data()

		Managers.rest_transport = Managers.rest_transport_online
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabPS4", flag, "DataServerQueue")

		Managers.backend:signin(self._np_auth_data)

		self._np_auth_data = nil
	end

	self._state = "waiting_for_backend_signin"
end

StateTitleScreenMainMenu._waiting_for_backend_signin = function (self)
	-- function 57
	local backend = Managers.backend

	if not backend and not backend:authenticated() then
		self._params.menu_screen_music_playing = false

		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(self, "cb_fade_in_done"))

		self._state = "none"
	end
end
