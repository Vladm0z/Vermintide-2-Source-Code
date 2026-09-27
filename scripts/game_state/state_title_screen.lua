-- chunkname: @scripts/game_state/state_title_screen.lua

require("scripts/game_state/state_title_screen_main")
require("scripts/settings/platform_specific")
require("scripts/game_state/state_loading")
require("scripts/managers/eac/eac_manager")
require("scripts/settings/game_settings")
require("scripts/ui/views/beta_overlay")
require("foundation/scripts/managers/chat/chat_manager")

if not IS_XB1 then
	require("scripts/managers/stats/stats_manager_2017")
end

StateTitleScreen = class(StateTitleScreen)
StateTitleScreen.NAME = "StateTitleScreen"

StateTitleScreen.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter StateTitleScreen")

	if not IS_XB1 then
		Application.set_kinect_enabled(true)

		if not Managers.backend then
			Managers.backend:reset()
		end
	elseif not IS_PS4 and not Managers.backend then
		Managers.backend:reset()
	end

	if not script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "true")
	end

	if not IS_CONSOLE then
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		Managers.mechanism:destroy()

		Managers.mechanism = GameMechanismManager:new(current_mechanism_name)

		if not rawget(_G, "LobbyInternal") and not LobbyInternal.network_initialized() and IS_PS4 and not Managers.account:offline_mode() then
			if not Managers.party:has_party_lobby() then
				local steal_lobby = Managers.party:steal_lobby()

				if type(steal_lobby) ~= "table" then
					LobbyInternal.leave_lobby(steal_lobby)
				end
			end

			LobbyInternal.shutdown_client()
		end
	end

	local loading_context = self.parent.loading_context
	local tbl = {
		Application.argv()
	}

	for k, v in pairs(tbl) do
		if not (v == "-auto-host-level" or v == "-auto-join" or v == "-skip-splash" or v == "-deus-auto-host" or v == "-vs-auto-search" or loading_context.join_lobby_data or loading_context.offline_invite or v ~= "-weave-name") then
			self._auto_start = true

			break
		elseif not IS_PS4 then
			local play_together_list = SessionInvitation.play_together_list()

			if not play_together_list then
				Managers.invite:set_play_together_list(play_together_list)

				self._auto_start = true

				break
			end
		end
	end

	Framerate.set_low_power()

	if not script_data.honduras_demo then
		self:_demo_hack_state_managers()
	end

	self._params = arg_1_1

	self:_setup_world()
	self:_setup_leak_prevention()
	self:_init_input()
	self:_init_ui()
	self:_setup_state_machine()
	self:_init_popup_manager()
	self:_init_chat_manager()

	if IS_WINDOWS or not IS_LINUX then
		self:_load_global_resources()
	end

	local Managers = Managers
	local eac = Managers.eac

	eac = eac or EacManager:new()
	Managers.eac = eac

	if not Managers.beta_overlay then
		Managers.beta_overlay:destroy()

		Managers.beta_overlay = nil
	end

	if not IS_PS4 then
		local account = Managers.account

		if not account:is_online() then
			account:set_presence("title_screen")
		end
	end

	self:_fade_out()

	if not rawget(_G, "ControllerFeaturesManager") then
		Managers.state.controller_features = ControllerFeaturesManager:new()
	end

	self._is_installed = Managers.play_go:installed()
	self._play_go_progress_string = Localize("play_go_installing_progress")

	if not (not Managers.backend and Managers.backend:item_script_type() ~= "tutorial") then
		Managers.backend:stop_tutorial()
	end

	ShowCursorStack.show("StateTitleScreen")
end

StateTitleScreen._load_global_resources = function (arg_2_0)
	-- function 2
	GlobalResources.update_loading()
end

StateTitleScreen._demo_hack_state_managers = function (self)
	-- function 3
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {
		__index = function ()
			-- function 4
			return tbl_3
		end
	}

	setmetatable(tbl, tbl_4)

	local tbl_5 = {
		__index = function ()
			-- function 5
			return tbl_2
		end
	}

	setmetatable(tbl_3, tbl_5)

	local tbl_6 = {
		__index = function ()
			-- function 6
			return tbl_2
		end,
		__call = function ()
			-- function 7
			return nil
		end
	}

	setmetatable(tbl_2, tbl_6)

	self._old_state_manager = Managers.state
	Managers.state = tbl
end

StateTitleScreen._fade_out = function (self)
	-- function 8
	if not IS_XB1 then
		if not Managers.account:should_teardown_xboxlive() then
			Managers.account:teardown_xboxlive()

			self._wait_for_xboxlive_teardown = true
		elseif not self._auto_start then
			Managers.transition:hide_loading_icon()
			Managers.transition:fade_out(1)
		end
	else
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(1)
	end
end

StateTitleScreen._setup_leak_prevention = function (self)
	-- function 9
	local flag = true

	GarbageLeakDetector.run_leak_detection(flag)
	GarbageLeakDetector.register_object(self, "StateTitleScreen")
	VisualAssertLog.setup(self._world)
end

StateTitleScreen._setup_world = function (self)
	-- function 10
	if not (Managers.package:has_loaded("resource_packages/start_menu_splash", "StateSplashScreen") or GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen")
	end

	if not (not IS_CONSOLE and Managers.package:has_loaded("resource_packages/news_splash/news_splash", "state_splash_screen") or GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		Managers.package:load("resource_packages/news_splash/news_splash", "state_splash_screen")
	end

	self._world_name = "title_screen_world"
	self._viewport_name = "title_screen_viewport"
	self._world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, 100, Application.ENABLE_UMBRA, Application.ENABLE_VOLUMETRICS)

	if not script_data.honduras_demo then
		self._viewport = ScriptWorld.create_viewport(self._world, self._viewport_name, "default", 1)
	else
		self._viewport = ScriptWorld.create_viewport(self._world, self._viewport_name, "overlay", 1)
		self._gui = World.create_screen_gui(self._world)

		local resolution, var_10_1 = Application.resolution()

		Gui.rect(self._gui, Vector3(0, 0, 0), Vector2(resolution, var_10_1), Color(255, 0, 0, 0))
	end

	local camera = ScriptViewport.camera(self._viewport)

	Camera.set_vertical_fov(camera, math.pi * 65 / 180)
	Camera.set_far_range(camera, 5000)
end

StateTitleScreen._init_input = function (self)
	-- function 11
	self._input_manager = InputManager:new()

	local _input_manager = self._input_manager

	Managers.input = _input_manager

	_input_manager:initialize_device("keyboard", 1)
	_input_manager:initialize_device("mouse", 1)
	_input_manager:initialize_device("gamepad")
	_input_manager:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
	_input_manager:create_input_service("chat_input", "ChatControllerSettings", "ChatControllerFilters")
	_input_manager:create_input_service("player_list_input", "IngamePlayerListKeymaps", "IngamePlayerListFilters")
end

local flag = true

StateTitleScreen._init_ui = function (self)
	-- function 12
	if not (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		if not script_data.honduras_demo then
			self._title_start_ui = DemoTitleUI:new(self._world, self._viewport, self)
		else
			self._title_start_ui = TitleMainUI:new(self._world)
		end
	end
end

StateTitleScreen._setup_state_machine = function (self)
	-- function 13
	local loading_context = self.parent.loading_context

	if not loading_context.skip_signin then
		loading_context.skip_signin = nil
		self._machine = GameStateMachine:new(self, StateTitleScreenMainMenu, {
			skip_signin = true,
			world = self._world,
			ui = self._title_start_ui,
			viewport = self._viewport,
			auto_start = self._auto_start,
			auto_sign_in = self._auto_sign_in
		}, true)
	else
		self._machine = GameStateMachine:new(self, StateTitleScreenMain, {
			world = self._world,
			ui = self._title_start_ui,
			viewport = self._viewport,
			auto_start = self._auto_start,
			auto_sign_in = self._auto_sign_in
		}, true)
	end
end

StateTitleScreen._init_popup_manager = function (self)
	-- function 14
	local Managers = Managers
	local popup = Managers.popup

	popup = popup or PopupManager:new()
	Managers.popup = popup

	Managers.popup:set_input_manager(self._input_manager)

	local Managers_2 = Managers
	local simple_popup = Managers.simple_popup

	simple_popup = simple_popup or SimplePopup:new()
	Managers_2.simple_popup = simple_popup
end

StateTitleScreen._init_chat_manager = function (arg_15_0)
	-- function 15
	local Managers = Managers
	local chat = Managers.chat

	chat = chat or ChatManager:new()
	Managers.chat = chat
end

StateTitleScreen._init_beta_overlay = function (arg_16_0)
	-- function 16
	if not Managers.beta_overlay then
		Managers.beta_overlay = BetaOverlay:new(Managers.world:world("top_ingame_view"))
	end
end

StateTitleScreen.update = function (self, arg_17_1, arg_17_2)
	-- function 17
	self:_handle_delayed_fade_in()
	Managers.input:update(arg_17_1, arg_17_2)
	self._machine:update(arg_17_1, arg_17_2)

	if not (not Managers.backend and Managers.backend:is_disconnected()) then
		Managers.backend:update(arg_17_1, arg_17_2)
	end

	self:_update_play_go_progress(arg_17_1, arg_17_2)

	if not Managers.state.controller_features then
		Managers.state.controller_features:update(arg_17_1, arg_17_2)
	end

	if Managers.eac ~= nil then
		Managers.eac:update(arg_17_1, arg_17_2)
	end

	if not Managers.music then
		Managers.music:update(arg_17_1, arg_17_2)
	end

	local skip_start_screen = GameSettingsDevelopment.skip_start_screen

	self:_render(arg_17_1, skip_start_screen)

	if not script_data.debug_enabled then
		VisualAssertLog.update(arg_17_1)
	end

	return self:_next_state()
end

StateTitleScreen.post_update = function (self, arg_18_1, arg_18_2)
	-- function 18
	self._machine:post_update(arg_18_1, arg_18_2)
end

StateTitleScreen._next_state = function (self)
	-- function 19
	if Managers.popup:has_popup() or not Managers.account:user_detached() then
		if not Managers.account:leaving_game() then
			print("Reloading StateTitleScreen due to user detatched")

			self.state = StateTitleScreen

			Managers.popup:cancel_all_popups()
		else
			return
		end
	elseif not (not Managers.account:leaving_game() and self._wait_for_xboxlive_teardown) then
		print("Reloading StateTitleScreen due to leaving game")

		self.state = StateTitleScreen

		Managers.popup:cancel_all_popups()
	elseif not IS_XB1 and not Managers.backend and not Managers.backend:is_disconnected() then
		print("Reloading StateTitleScreen due to backend disconnect")

		self.state = StateTitleScreen

		Managers.popup:cancel_all_popups()
	end

	return self.state
end

StateTitleScreen._handle_delayed_fade_in = function (self)
	-- function 20
	if not (not IS_XB1 and not self._wait_for_xboxlive_teardown and Managers.account:should_teardown_xboxlive() or self._auto_start) then
		Managers.transition:fade_out(1)

		self._wait_for_xboxlive_teardown = nil

		Managers.transition:hide_loading_icon()
	end
end

StateTitleScreen._update_play_go_progress = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not self._is_installed then
		return
	end

	if not Managers.play_go:installed() then
		self._title_start_ui:clear_playgo_status()

		self._is_installed = true
	else
		local progress_percentage = Managers.play_go:progress_percentage()
		local var_21_1 = tostring(100 * progress_percentage)
		local format = string.format(self._play_go_progress_string, var_21_1)

		self._title_start_ui:set_playgo_status(format)
	end
end

StateTitleScreen.enter_attract_mode = function (self, arg_22_1)
	-- function 22
	self._attract_mode_active = arg_22_1
end

StateTitleScreen._render = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	return
end

StateTitleScreen.show_menu = function (self, arg_24_1, arg_24_2)
	-- function 24
	self._title_start_ui:show_menu(arg_24_1, arg_24_2)
end

StateTitleScreen.on_exit = function (self, arg_25_1)
	-- function 25
	Framerate.set_playing()
	self._machine:destroy()
	VisualAssertLog.cleanup()

	if not self._title_start_ui then
		self._title_start_ui:destroy()

		self._title_start_ui = nil
	end

	if not script_data.disable_beta_overlay then
		self:_init_beta_overlay()
	end

	if not arg_25_1 and not rawget(_G, "LobbyInternal") and not LobbyInternal.client then
		if not Managers.party:has_party_lobby() then
			local steal_lobby = Managers.party:steal_lobby()

			if type(steal_lobby) ~= "table" then
				LobbyInternal.leave_lobby(steal_lobby)
			end
		end

		LobbyInternal.shutdown_client()
	end

	World.destroy_gui(self._world, self._gui)
	ScriptWorld.destroy_viewport(self._world, self._viewport_name)
	Managers.world:destroy_world(self._world)
	Managers.popup:remove_input_manager(arg_25_1)
	self._input_manager:destroy()

	self._input_manager = nil
	Managers.input = nil

	if not script_data.honduras_demo then
		Managers.state = self._old_state_manager

		Wwise.set_state("menu_mute_ingame_sounds", "default")
	end

	Managers.state:destroy()

	if not Managers.package:has_loaded("resource_packages/news_splash/news_splash", "state_splash_screen") then
		Managers.package:unload("resource_packages/news_splash/news_splash", "state_splash_screen")
		Managers.package:unload("resource_packages/start_menu_splash", "StateSplashScreen")
	end

	if not (not IS_CONSOLE and GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		Managers.music:trigger_event("Stop_menu_screen_music")
	end

	ShowCursorStack.hide("StateTitleScreen")
end
