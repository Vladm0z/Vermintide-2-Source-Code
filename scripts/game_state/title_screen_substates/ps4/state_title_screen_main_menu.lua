-- chunkname: @scripts/game_state/title_screen_substates/ps4/state_title_screen_main_menu.lua

require("scripts/ui/views/additional_content/additional_content_view")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

local game_types = {
	HOST_PLAY_TOGETHER = "host_play_together",
	INVITATION = "invitation",
	OFFLINE = "offline",
	ONLINE = "online"
}
local menu_functions

if script_data.honduras_demo then
	menu_functions = {
		function (this)
			-- function 1
			this:_start_game(game_types.ONLINE, DemoSettings.demo_level)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end
	}
elseif script_data.settings.use_beta_mode then
	if script_data.settings.disable_tutorial_at_start then
		menu_functions = {
			function (this)
				-- function 2
				local game_type_2 = this._title_start_ui:game_type()

				if not game_type_2 then
					-- Nothing
				end

				game_type_2 = game_types.ONLINE

				local game_type = game_type_2

				::label_2_0::

				this:_start_game(game_type)
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (this)
				-- function 3
				local input_manager = Managers.input

				input_manager:block_device_except_service("options_menu", "gamepad")
				this:activate_view("options_view")
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function (this)
				-- function 4
				this:activate_view("credits_view")
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	else
		menu_functions = {
			function (this)
				-- function 5
				local game_type_2 = this._title_start_ui:game_type()

				if not game_type_2 then
					-- Nothing
				end

				game_type_2 = game_types.ONLINE

				local game_type = game_type_2

				::label_5_0::

				this:_start_game(game_type)
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (this)
				-- function 6
				local game_type_2 = this._title_start_ui:game_type()

				if not game_type_2 then
					-- Nothing
				end

				game_type_2 = game_types.ONLINE

				local game_type = game_type_2

				::label_6_0::

				this:_start_game(game_type, "prologue")
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_start_game")
			end,
			function (this)
				-- function 7
				local input_manager = Managers.input

				input_manager:block_device_except_service("options_menu", "gamepad")
				this:activate_view("options_view")
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end,
			function (this)
				-- function 8
				this:activate_view("credits_view")
				this._title_start_ui:menu_option_activated(true)
				Managers.music:trigger_event("Play_console_menu_select")
			end
		}
	end
elseif GameSettingsDevelopment.additional_content_view_enabled then
	menu_functions = {
		function (this)
			-- function 9
			local game_type_2 = this._title_start_ui:game_type()

			if not game_type_2 then
				-- Nothing
			end

			game_type_2 = game_types.ONLINE

			local game_type = game_type_2

			::label_9_0::

			this:_start_game(game_type)
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (this)
			-- function 10
			local game_type_2 = this._title_start_ui:game_type()

			if not game_type_2 then
				-- Nothing
			end

			game_type_2 = game_types.ONLINE

			local game_type = game_type_2

			::label_10_0::

			this:_start_game(game_type, "prologue")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (this)
			-- function 11
			local input_manager = Managers.input

			input_manager:block_device_except_service("options_menu", "gamepad")
			this:activate_view("options_view")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (this)
			-- function 12
			local input_manager = Managers.input

			this:activate_view("cinematics_view")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (this)
			-- function 13
			local input_manager = Managers.input

			input_manager:block_device_except_service("additional_content_menu", "gamepad")
			this:activate_view("additional_content_view")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (this)
			-- function 14
			this:activate_view("credits_view")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
else
	menu_functions = {
		function (this)
			-- function 15
			local game_type_2 = this._title_start_ui:game_type()

			if not game_type_2 then
				-- Nothing
			end

			game_type_2 = game_types.ONLINE

			local game_type = game_type_2

			::label_15_0::

			this:_start_game(game_type)
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (this)
			-- function 16
			local game_type_2 = this._title_start_ui:game_type()

			if not game_type_2 then
				-- Nothing
			end

			game_type_2 = game_types.ONLINE

			local game_type = game_type_2

			::label_16_0::

			this:_start_game(game_type, "prologue")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_start_game")
		end,
		function (this)
			-- function 17
			local input_manager = Managers.input

			input_manager:block_device_except_service("options_menu", "gamepad")
			this:activate_view("options_view")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end,
		function (this)
			-- function 18
			this:activate_view("credits_view")
			this._title_start_ui:menu_option_activated(true)
			Managers.music:trigger_event("Play_console_menu_select")
		end
	}
end

StateTitleScreenMainMenu.on_enter = function (self, params)
	-- function 19
	print("[Gamestate] Enter Substate StateTitleScreenMainMenu")

	self._params = params
	self._world = params.world
	self._viewport = params.viewport
	self._title_start_ui = params.ui
	self._auto_start = params.auto_start
	params.auto_start = nil
	self._state = "none"
	self._new_state = nil
	self._input_disabled = false
	self._game_type = nil
	self._level_key = nil
	self._disable_trailer = nil
	self._profile_name = nil

	if script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "false")
	end

	UISettings.set_console_settings()
	self._setup_sound()
	self:_setup_input()
	self:_init_menu_views()
	self:_update_chat_ignore_list()

	if params.skip_signin then
		self._title_start_ui:set_start_pressed(true)
	end

	Managers.transition:hide_loading_icon()

	self._network_event_meta_table = {}

	self._network_event_meta_table.__index = function (event_table, event_key)
		-- function 20
		return function ()
			-- function 21
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", event_key)
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

	if PlayfabBackendSaveDataUtils.online_data_is_dirty() then
		self._title_start_ui:set_update_offline_data_enabled(true)
	else
		self._title_start_ui:set_update_offline_data_enabled(false)
	end

	self:_try_activate_splash()

	if not script_data.settings.use_beta_mode and GameSettingsDevelopment.additional_content_view_enabled then
		local additional_content_view = self._views.additional_content_view
		local has_splashes = not not additional_content_view and not not additional_content_view:has_active_splashes()

		if not has_splashes then
			self._title_start_ui:set_menu_item_enable_state_by_index("store", false, true, "start_game_disabled_playgo")
		else
			self._title_start_ui:set_menu_item_enable_state_by_index("store", true, true)
		end
	end
end

StateTitleScreenMainMenu._setup_sound = function (self)
	-- function 22
	local user_setting = Application.user_setting("master_bus_volume")

	if not user_setting then
		-- Nothing
	end

	user_setting = 90

	local master_bus_volume = user_setting

	::label_22_0::

	local user_setting_2 = Application.user_setting("music_bus_volume")

	if not user_setting_2 then
		-- Nothing
	end

	user_setting_2 = 90

	local music_bus_volume = user_setting_2

	::label_22_1::

	local wwise_world

	if GLOBAL_MUSIC_WORLD then
		wwise_world = MUSIC_WWISE_WORLD
	else
		local music_world = Managers.world:world("music_world")

		wwise_world = Managers.world:wwise_world(music_world)
	end

	WwiseWorld.set_global_parameter(wwise_world, "master_bus_volume", master_bus_volume)
	Managers.music:set_master_volume(master_bus_volume)
	Managers.music:set_music_volume(music_bus_volume)
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
	local input_manager = Managers.input

	self.input_manager = input_manager
end

StateTitleScreenMainMenu._init_menu_views = function (self)
	-- function 26
	local ui_renderer = self._title_start_ui:get_ui_renderer()
	local view_context = {
		in_title_screen = true,
		ui_renderer = ui_renderer,
		ui_top_renderer = ui_renderer,
		input_manager = Managers.input,
		world_manager = Managers.world
	}

	if script_data.honduras_demo then
		self._title_start_ui:animate_to_camera(DemoSettings.camera_end_position, nil, callback(self, "cb_camera_animation_complete"))

		self._views = {}
	else
		local tbl = {
			credits_view = CreditsView:new(view_context),
			options_view = OptionsView:new(view_context),
			cinematics_view = CinematicsView:new(view_context)
		}
		local var_26_1

		if not script_data.settings.use_beta_mode and GameSettingsDevelopment.additional_content_view_enabled then
			var_26_1 = AdditionalContentView:new(view_context)

			if not var_26_1 then
				-- Nothing
			end
		end

		var_26_1 = nil

		::label_26_0::

		tbl.additional_content_view = var_26_1
		self._views = tbl
	end

	for name, view in pairs(self._views) do
		view.exit = function ()
			-- function 27
			self:exit_current_view()
		end
	end
end

StateTitleScreenMainMenu._update_chat_ignore_list = function (self)
	-- function 28
	Managers.chat:update_ignore_list()
end

StateTitleScreenMainMenu._try_activate_splash = function (self)
	-- function 29
	local additional_content_view = self._views.additional_content_view

	if additional_content_view and additional_content_view:has_active_splashes() and not SaveData.store_shown then
		local input_manager = Managers.input

		input_manager:block_device_except_service("additional_content_menu", "gamepad")
		self:activate_view("additional_content_view")
		self._title_start_ui:menu_option_activated(true)
		self.parent:show_menu(true, true)
	else
		self.parent:show_menu(true)
	end
end

local BACKGROUND_ONLY_2 = BACKGROUND_ONLY

if not BACKGROUND_ONLY_2 then
	-- Nothing
end

BACKGROUND_ONLY_2 = true

local BACKGROUND_ONLY = BACKGROUND_ONLY_2

::label_0_0::

StateTitleScreenMainMenu._update_network = function (self, dt, t)
	-- function 30
	if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() then
		Network.update(dt, setmetatable({}, self._network_event_meta_table))
	end
end

StateTitleScreenMainMenu._start_game = function (self, game_type, level_key, disable_trailer, profile_name)
	-- function 31
	self._game_type = game_type
	self._level_key = level_key
	self._disable_trailer = not not disable_trailer or not not not Application.user_setting("play_intro_cinematic")
	self._profile_name = profile_name
	self._input_disabled = true

	Managers.transition:show_loading_icon(false)
	self._title_start_ui:disable_input(true)

	if game_type == game_types.OFFLINE then
		self._state = "signin_to_backend"
	else
		self._state = "check_restrictions"
	end
end

StateTitleScreenMainMenu.update = function (self, dt, t)
	-- function 32
	local title_start_ui = self._title_start_ui

	self:_update_play_go(dt, t)
	self:_update_network(dt, t)

	local has_offline_invitation = false
	local play_together_list = Managers.invite:play_together_list()

	if self._auto_start then
		local loading_context = self.parent.parent.loading_context

		if loading_context.offline_invite then
			has_offline_invitation = true
			loading_context.offline_invite = nil
		elseif not play_together_list then
			self:_start_game(game_types.ONLINE)
		end

		self._auto_start = nil
	end

	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()

	if not self._input_disabled and not has_popup and not user_detached and not self._popup_id then
		if Managers.invite:has_invitation() or has_offline_invitation then
			if self._is_installed then
				self:_start_game(game_types.INVITATION, nil, true)
			else
				self._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
				self._state = "check_popup"
			end
		elseif play_together_list then
			if self._is_installed then
				self:_start_game(game_types.HOST_PLAY_TOGETHER, nil, true)
			else
				self._popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
				self._state = "check_popup"
			end
		end
	end

	local active_view = self._active_view

	if active_view then
		self._views[active_view]:update(dt, t)
	else
		title_start_ui:update(dt, t)

		if script_data.honduras_demo then
			self:_update_demo_input(dt, t)
		else
			self:_update_input(dt, t)
		end
	end

	if not Managers.account:user_detached() then
		if self._state == "check_restrictions" then
			self:_check_restrictions()
			title_start_ui:set_information_text(Localize("loading_checking_privileges"))
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
			title_start_ui:set_information_text(Localize("loading_requesting_np_auth_data"))
			self:_request_np_auth_data()
		elseif self._state == "signin_to_backend" then
			self:_signin_to_backend()
			title_start_ui:set_information_text(Localize("loading_signing_in"))
		elseif self._state == "waiting_for_backend_signin" then
			self:_waiting_for_backend_signin()
		elseif self._state == "check_popup" then
			self:_check_popup()
		end
	elseif self._state == "check_popup" then
		self:_check_popup()
	end

	if Managers.account:leaving_game() then
		if active_view then
			self:exit_current_view()
		end

		self.parent:show_menu(false)
		self._title_start_ui:set_start_pressed(false)
	end

	return self:_next_state()
end

StateTitleScreenMainMenu._check_popup = function (self)
	-- function 33
	local result = Managers.popup:query_result(self._popup_id)

	if result == "close_menu" then
		Managers.invite:clear_invites()
		self:_close_menu()
	elseif result == "not_installed" then
		Managers.invite:clear_invites()

		self._state = "none"
	elseif result == "update_offline_data" then
		print("[StateTitleScreenMainMenu] Updating offline data...")
		PlayfabBackendSaveDataUtils.update_offline_data(callback(self, "cb_offline_data_updated"))
		self._title_start_ui:set_update_offline_data_enabled(false)
		self._title_start_ui:disable_input(true)

		self._input_disabled = true

		Managers.transition:show_loading_icon(false)

		self._state = "waiting_for_offline_data_update"
	elseif result == "do_nothing" then
		self._state = "none"
	elseif result then
		fassert(false, "[StateTitleScreenMainMenu] The popup result doesn't exist (%s)", result)
	end

	if result then
		self._popup_id = nil
	end
end

StateTitleScreenMainMenu.cb_offline_data_updated = function (self, success)
	-- function 34
	if success then
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
	if not Managers.popup:has_popup() and not self._popup_id then
		if script_data.honduras_demo and not self._title_start_ui:is_ready() then
			return
		end

		if Managers.backend and Managers.backend:is_disconnected() then
			self:_close_menu()

			return self._new_state
		elseif self._closing_menu then
			return self._new_state
		else
			return nil
		end
	end
end

StateTitleScreenMainMenu._update_input = function (self, dt, t)
	-- function 37
	local input_service = self.input_manager:get_service("main_menu")
	local current_menu_index = self._title_start_ui:current_menu_index()
	local active_menu_selection = self._title_start_ui:active_menu_selection()
	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()
	local active_controller = Managers.account:active_controller()

	if active_menu_selection and not self._input_disabled and not has_popup and not user_detached and not self._popup_id then
		if current_menu_index and input_service:get("start", true) then
			input_service:get("confirm_press", true)
			menu_functions[current_menu_index](self)
		elseif input_service:get("back") then
			self:_close_menu()
		elseif self._title_start_ui:offline_data_available() and active_controller.pressed(active_controller.button_index("triangle")) then
			self._popup_id = Managers.popup:queue_popup(Localize("popup_update_offline_data"), Localize("popup_update_offline_data_header"), "update_offline_data", Localize("popup_choice_yes"), "do_nothing", Localize("popup_choice_no"))
			self._state = "check_popup"
		end
	end
end

StateTitleScreenMainMenu._update_demo_input = function (self, dt, t)
	-- function 38
	local demo_ui = self._title_start_ui
	local input_service = self.input_manager:get_service("main_menu")
	local has_popup = Managers.popup:has_popup()
	local user_detached = Managers.account:user_detached()
	local active_controller = Managers.account:active_controller()

	if demo_ui:should_start() and not self._input_disabled then
		local profile_name, career_index = demo_ui:selected_profile()

		self:_start_game(game_types.ONLINE, DemoSettings.demo_level, nil, profile_name)
		Managers.music:trigger_event("Play_console_menu_start_game")

		return
	end

	if Managers.time:get_demo_transition() and not demo_ui:in_transition() then
		demo_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
		demo_ui:activate_career_ui(false)
		self.parent:show_menu(false)
	end

	if not self._input_disabled and not has_popup and not user_detached and not self._popup_id and input_service:get("back") and not demo_ui:in_transition() then
		demo_ui:animate_to_camera(DemoSettings.starting_camera_name, nil, callback(self, "cb_camera_animation_complete_back"))
		demo_ui:activate_career_ui(false)
		self:_close_menu()
	end
end

StateTitleScreenMainMenu._update_play_go = function (self, dt, t)
	-- function 39
	if self._is_installed then
		return
	end

	local installed = Managers.play_go:installed()

	if installed then
		self._title_start_ui:set_menu_item_enable_state_by_index("start_game", true, true)
		self._title_start_ui:set_menu_item_enable_state_by_index("cinematics", true, true)

		self._is_installed = true
	end
end

StateTitleScreenMainMenu.on_exit = function (self)
	-- function 40
	for k, view in pairs(self._views) do
		if view.destroy then
			view:destroy()
		end
	end

	self._views = nil
end

StateTitleScreenMainMenu.cb_fade_in_done = function (self)
	-- function 41
	local game_type = self._game_type
	local level_key = self._level_key
	local _disable_trailer = self._disable_trailer

	if not _disable_trailer then
		-- Nothing
	end

	_disable_trailer = not Application.user_setting("play_intro_cinematic")

	local disable_trailer = _disable_trailer

	::label_41_0::

	local profile_name = self._profile_name
	local switch_to_tutorial_backend, tutorial_state = Managers.mechanism:should_run_tutorial()

	if switch_to_tutorial_backend and not Managers.backend:get_user_data("prologue_started") and not script_data.settings.disable_tutorial_at_start and not script_data.disable_prologue and not script_data.honduras_demo then
		disable_trailer = false
		level_key = "prologue"
	end

	self.parent.state = StateLoading

	local loading_context = self.parent.parent.loading_context

	loading_context.restart_network = true
	loading_context.level_key = level_key

	if game_type == game_types.INVITATION or game_type == game_types.HOST_PLAY_TOGETHER then
		loading_context.first_time = false
	end

	if level_key then
		local environment_variation_id = LevelHelper:get_environment_variation_id(level_key)

		Managers.level_transition_handler:set_next_level(level_key, environment_variation_id)
	end

	if level_key == "prologue" then
		loading_context.gamma_correct = not SaveData.gamma_corrected
		loading_context.play_trailer = true
		loading_context.switch_to_tutorial_backend = switch_to_tutorial_backend
		loading_context.wanted_tutorial_state = tutorial_state
	elseif script_data.honduras_demo then
		local loading_context_2 = self.parent.parent.loading_context
		local var_41_2

		if profile_name then
			var_41_2 = FindProfileIndex(profile_name)

			if not var_41_2 then
				-- Nothing
			end
		end

		var_41_2 = DemoSettings.wanted_profile_index

		::label_41_1::

		loading_context_2.wanted_profile_index = var_41_2
		GameSettingsDevelopment.disable_free_flight = DemoSettings.disable_free_flight
		GameSettingsDevelopment.disable_intro_trailer = DemoSettings.disable_intro_trailer
	elseif not level_key then
		loading_context.gamma_correct = not SaveData.gamma_corrected
		loading_context.show_profile_on_startup = true

		if not disable_trailer then
			loading_context.play_trailer = true
		end
	end
end

StateTitleScreenMainMenu.activate_view = function (self, new_view)
	-- function 42
	self._active_view = new_view

	local views = self._views

	assert(views[new_view])

	if new_view and views[new_view] and views[new_view].on_enter then
		views[new_view]:on_enter()
	end
end

StateTitleScreenMainMenu.exit_current_view = function (self)
	-- function 43
	local active_view = self._active_view
	local views = self._views

	assert(active_view)

	if views[active_view] and views[active_view].on_exit then
		views[active_view]:on_exit()
	end

	self._active_view = nil

	local input_manager = Managers.input

	input_manager:block_device_except_service("main_menu", "gamepad")
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

	local error_code = Managers.account:has_error("network_availability")
	local has_access = Managers.account:has_access("network_availability")

	if error_code then
		self:_show_error_dialog(error_code)
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

	local error_code = Managers.account:has_error("playstation_plus")
	local has_access = Managers.account:has_access("playstation_plus")

	if error_code then
		self:_show_error_dialog(error_code)
	elseif not has_access then
		self:_setup_playstation_plus_dialog()
	else
		self._state = "check_restrictions_chat"
	end
end

StateTitleScreenMainMenu._check_restrictions_chat = function (self)
	-- function 47
	local account_manager = Managers.account

	if not account_manager:restriction_access_fetched("chat") then
		return
	end

	local error_code = account_manager:has_error("chat")
	local has_access = account_manager:has_access("chat")

	if error_code then
		self:_show_error_dialog(error_code)
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
	if Managers.system_dialog:has_open_dialogs() then
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
	local status = NpCommerceDialog.update()

	if status == NpCommerceDialog.INITIALIZED then
		NpCommerceDialog.open2(NpCommerceDialog.MODE_PLUS, Managers.account:user_id(), NpCheck.REALTIME_MULTIPLAY)
	elseif status == NpCommerceDialog.FINISHED then
		local action, result = NpCommerceDialog.result()

		NpCommerceDialog.terminate()

		if result == true then
			Managers.account:refetch_restriction_access(nil, {
				"playstation_plus"
			})

			self._state = "check_restrictions_ps_plus"
		else
			self:_close_menu()
		end
	end
end

StateTitleScreenMainMenu._show_error_dialog = function (self, error_code)
	-- function 52
	self._state = "waiting_for_error_dialog"

	Managers.system_dialog:open_error_dialog(error_code, callback(self, "cb_error_dialog_done"))
end

StateTitleScreenMainMenu.cb_error_dialog_done = function (self)
	-- function 53
	self:_close_menu()
end

StateTitleScreenMainMenu._request_np_auth_data = function (self)
	-- function 54
	local token = NpAuth.create_async_token()
	local script_token = ScriptNpAuthToken:new(token)

	Managers.token:register_token(script_token, callback(self, "cb_np_auth_data_received"))

	self._state = "waiting_for_np_auth_data"
end

StateTitleScreenMainMenu.cb_np_auth_data_received = function (self, result)
	-- function 55
	print("[StateTitleScreenMainMenu] cb_np_auth_data_received")

	if result.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_np_auth_failed"), Localize("popup_np_auth_failed_header"), "close_menu", Localize("menu_ok"))
		self._state = "check_popup"
	else
		print("[StateTitleScreenMainMenu] Successfully acquired NpAuth data")

		self._np_auth_data = result.data
		self._state = "signin_to_backend"
	end
end

StateTitleScreenMainMenu._signin_to_backend = function (self)
	-- function 56
	local parameter = Development.parameter("mechanism")

	if not parameter then
		-- Nothing
	end

	parameter = "adventure"

	local mechanism_name = parameter

	::label_56_0::

	local mechanism_settings = MechanismSettings[mechanism_name]
	local playfab_mirror = not not mechanism_settings and not not mechanism_settings.playfab_mirror
	local mirror = not not playfab_mirror or not not "PlayFabMirrorAdventure"

	Managers.unlock = UnlockManager:new()

	if self._game_type == game_types.OFFLINE then
		print("Using Offline Backend")
		Managers.account:set_offline_mode(true)

		if not Managers.rest_transport_offline then
			require("scripts/managers/rest_transport_offline/rest_transport_manager_offline")

			local offline_backend = require("scripts/managers/rest_transport_offline/offline_backend_playfab")

			Managers.rest_transport_offline = RestTransportManagerOffline:new(offline_backend.endpoints)
		end

		Managers.rest_transport = Managers.rest_transport_offline
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabPS4", mirror, "DataServerQueue")

		Managers.backend:signin()
	else
		print("Using Online Backend")
		Managers.account:set_offline_mode(false)
		Managers.account:fetch_user_data()

		Managers.rest_transport = Managers.rest_transport_online
		Managers.backend = BackendManagerPlayFab:new("ScriptBackendPlayFabPS4", mirror, "DataServerQueue")

		Managers.backend:signin(self._np_auth_data)

		self._np_auth_data = nil
	end

	self._state = "waiting_for_backend_signin"
end

StateTitleScreenMainMenu._waiting_for_backend_signin = function (self)
	-- function 57
	local backend_manager = Managers.backend

	if backend_manager and backend_manager:authenticated() then
		self._params.menu_screen_music_playing = false

		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(self, "cb_fade_in_done"))

		self._state = "none"
	end
end
