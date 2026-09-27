-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_main_menu.lua

local var_0_0 = local_require("scripts/game_state/title_screen_substates/win32/state_title_screen_main_menu_settings")

StateTitleScreenMainMenu = class(StateTitleScreenMainMenu)
StateTitleScreenMainMenu.NAME = "StateTitleScreenMainMenu"

StateTitleScreenMainMenu.on_enter = function (self, arg_1_1)
	-- function 1
	self._params = arg_1_1
	self._world = arg_1_1.world
	self._viewport = arg_1_1.viewport
	self._title_start_ui = arg_1_1.ui
	self._auto_start = arg_1_1.auto_start

	if not script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "false")
	end

	self._setup_sound()
	self:_init_menu_views()
	self:_setup_menu_options()
	self.parent:show_menu(true)
	Managers.transition:hide_loading_icon()
end

StateTitleScreenMainMenu._check_prologue_status = function (self)
	-- function 2
	local flag = true
	local get_user_data = Managers.backend:get_user_data("has_completed_tutorial")

	if not get_user_data then
		get_user_data = SaveData.has_completed_tutorial
		get_user_data = get_user_data or false
	end

	if get_user_data or not script_data.disable_tutorial_at_start then
		flag = false
	else
		self._input_disabled = true

		Managers.transition:show_loading_icon(false)
		self._title_start_ui:disable_input(true)

		self._new_state = StateTitleScreenLoadSave
	end

	return flag
end

StateTitleScreenMainMenu._start_game = function (self, arg_3_1)
	-- function 3
	local flag = arg_3_1 == "prologue"

	self.parent.parent.loading_context.restart_network = true
	self.parent.parent.loading_context.level_key = arg_3_1
	self.parent.parent.loading_context.play_trailer = flag or Application.user_setting("play_intro_cinematic")
	self.parent.parent.loading_context.force_run_tutorial = flag
	self.parent.parent.loading_context.first_time = flag

	Managers.level_transition_handler:set_next_level(arg_3_1)
	Managers.level_transition_handler:promote_next_level_data()

	local var_3_1

	if not Managers.mechanism then
		var_3_1 = Managers.mechanism:current_mechanism_name()

		Managers.mechanism:destroy()
	end

	Managers.mechanism = GameMechanismManager:new(var_3_1)
	self._input_disabled = true

	Managers.transition:show_loading_icon(false)
	self._title_start_ui:disable_input(true)
	self._title_start_ui:view_activated(true)

	self._new_state = StateTitleScreenLoadSave
end

StateTitleScreenMainMenu._quit_game = function (self)
	-- function 4
	self._popup_id = Managers.popup:queue_popup(Localize("quit_game_popup_text"), Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel", Localize("popup_choice_no"))
end

StateTitleScreenMainMenu._initiate_quit_game = function (self)
	-- function 5
	self._input_disabled = true

	self._title_start_ui:disable_input(true)
	Managers.transition:fade_in(GameSettings.transition_fade_in_speed, callback(self, "cb_quit_game"))
end

StateTitleScreenMainMenu.cb_quit_game = function (arg_6_0)
	-- function 6
	Boot.quit_game = true
end

StateTitleScreenMainMenu._setup_menu_options = function (self)
	-- function 7
	local create_menu_layout = var_0_0.create_menu_layout(self)

	self._title_start_ui:create_menu_options(create_menu_layout)
end

StateTitleScreenMainMenu._setup_sound = function (arg_8_0)
	-- function 8
	local user_setting = Application.user_setting("master_bus_volume")

	user_setting = user_setting or 90

	local user_setting_2 = Application.user_setting("music_bus_volume")

	user_setting_2 = user_setting_2 or 90

	local var_8_2

	if not GLOBAL_MUSIC_WORLD then
		var_8_2 = MUSIC_WWISE_WORLD
	else
		local world = Managers.world:world("music_world")

		var_8_2 = Managers.world:wwise_world(world)
	end

	WwiseWorld.set_global_parameter(var_8_2, "master_bus_volume", user_setting)
	Managers.music:set_master_volume(user_setting)
	Managers.music:set_music_volume(user_setting_2)
end

StateTitleScreenMainMenu.cb_camera_animation_complete = function (self)
	-- function 9
	ShowCursorStack.show("StateTitleScreenMainMenu")
	self._title_start_ui:activate_career_ui(true)
end

StateTitleScreenMainMenu.cb_camera_animation_complete_back = function (self)
	-- function 10
	self._new_state = StateTitleScreenMain
end

StateTitleScreenMainMenu._init_menu_views = function (self)
	-- function 11
	local get_ui_renderer = self._title_start_ui:get_ui_renderer()
	local tbl = {
		in_title_screen = true,
		ui_renderer = get_ui_renderer,
		ui_top_renderer = get_ui_renderer,
		input_manager = Managers.input,
		world_manager = Managers.world
	}

	self._views = {
		credits_view = CreditsView:new(tbl),
		options_view = OptionsView:new(tbl),
		cinematics_view = CinematicsView:new(tbl)
	}

	ShowCursorStack.show("StateTitleScreenMainMenu")

	for k, v in pairs(self._views) do
		v.exit = function ()
			-- function 12
			self:exit_current_view()
		end
	end
end

StateTitleScreenMainMenu.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _active_view = self._active_view

	if not self._auto_start and Development.parameter("auto_host_level") and Development.parameter("auto_join") and Development.parameter("deus_auto_host") and Development.parameter("vs_auto_search") and not Development.parameter("weave_name") then
		self._input_disabled = true

		Managers.transition:show_loading_icon(false)
		self._title_start_ui:disable_input(true)

		self._new_state = StateTitleScreenLoadSave
		self._auto_start = nil
	elseif not self._auto_start and not Development.parameter("skip_splash") then
		local num = 1

		self._title_start_ui:_activate_menu_widget(num)

		self._auto_start = nil
	elseif not _active_view then
		self._views[_active_view]:update(arg_13_1, arg_13_2)
	end

	self._title_start_ui:update(arg_13_1, arg_13_2)

	if self._input_disabled or not Managers.input:get_service("main_menu"):get("back") then
		self:_close_menu()
	end

	self:_handle_popups()

	return self._new_state
end

StateTitleScreenMainMenu._handle_popups = function (self)
	-- function 14
	if not self._popup_id then
		return
	end

	local query_result = Managers.popup:query_result(self._popup_id)

	if not query_result then
		self._popup_id = nil

		self:_handle_popup_result(query_result)
	end
end

StateTitleScreenMainMenu._handle_popup_result = function (self, arg_15_1)
	-- function 15
	if arg_15_1 == "end_game" then
		self:_initiate_quit_game()
	end
end

StateTitleScreenMainMenu._close_menu = function (self)
	-- function 16
	self.parent:show_menu(false)
	self._title_start_ui:set_start_pressed(false)
	self._title_start_ui:disable_input(false)

	self._closing_menu = true

	Managers.transition:hide_loading_icon()
	Managers.transition:force_fade_in()
	Managers.transition:fade_out(GameSettings.transition_fade_in_speed * 2)

	self._new_state = StateTitleScreenMain
end

StateTitleScreenMainMenu.on_exit = function (self)
	-- function 17
	for k, v in pairs(self._views) do
		if not v.destroy then
			v:destroy()
		end
	end

	self._views = nil

	ShowCursorStack.hide("StateTitleScreenMainMenu")
end

StateTitleScreenMainMenu.cb_fade_in_done = function (self, arg_18_1, arg_18_2)
	-- function 18
	self._new_state = StateTitleScreenLoadSave
	self.parent.parent.loading_context.restart_network = true
	self.parent.parent.loading_context.level_key = arg_18_1
	self.parent.parent.loading_context.play_trailer = arg_18_1 == "prologue" or Application.user_setting("play_intro_cinematic")

	if arg_18_1 == "tutorial" then
		Managers.backend:make_tutorial()

		self.parent.parent.loading_context.wanted_profile_index = 4
	elseif not script_data.honduras_demo then
		local loading_context = self.parent.parent.loading_context
		local var_18_1

		if not arg_18_2 then
			var_18_1 = FindProfileIndex(arg_18_2)

			if not var_18_1 then
				-- Nothing
			end
		end

		var_18_1 = DemoSettings.wanted_profile_index

		::label_18_0::

		loading_context.wanted_profile_index = var_18_1
		GameSettingsDevelopment.disable_free_flight = DemoSettings.disable_free_flight
		GameSettingsDevelopment.disable_intro_trailer = DemoSettings.disable_intro_trailer
	end
end

StateTitleScreenMainMenu._activate_view = function (self, arg_19_1)
	-- function 19
	self._active_view = arg_19_1

	local _views = self._views

	assert(_views[arg_19_1])

	if not arg_19_1 and not _views[arg_19_1] and not _views[arg_19_1].on_enter then
		_views[arg_19_1]:on_enter()

		self._input_disabled = true

		self._title_start_ui:disable_input(true)
		self._title_start_ui:view_activated(true)
	end
end

StateTitleScreenMainMenu.exit_current_view = function (self)
	-- function 20
	local _active_view = self._active_view
	local _views = self._views

	assert(_active_view)

	if not _views[_active_view] and not _views[_active_view].on_exit then
		_views[_active_view]:on_exit()

		self._input_disabled = false

		self._title_start_ui:disable_input(false)
		self._title_start_ui:view_activated(false)
	end

	self._active_view = nil

	Managers.input:block_device_except_service("main_menu", "gamepad", 1)
end
