-- chunkname: @scripts/game_state/state_title_screen.lua

require("scripts/game_state/state_title_screen_main")
require("scripts/settings/platform_specific")
require("scripts/game_state/state_loading")
require("scripts/managers/eac/eac_manager")
require("scripts/settings/game_settings")
require("scripts/ui/views/beta_overlay")
require("foundation/scripts/managers/chat/chat_manager")

if IS_XB1 then
	require("scripts/managers/stats/stats_manager_2017")
end

StateTitleScreen = class(StateTitleScreen)
StateTitleScreen.NAME = "StateTitleScreen"

function StateTitleScreen.on_enter(arg_1_0, arg_1_1)
	print("[Gamestate] Enter StateTitleScreen")

	if IS_XB1 then
		Application.set_kinect_enabled(true)

		if Managers.backend then
			Managers.backend:reset()
		end
	elseif IS_PS4 and Managers.backend then
		Managers.backend:reset()
	end

	if script_data.honduras_demo then
		Wwise.set_state("menu_mute_ingame_sounds", "true")
	end

	if IS_CONSOLE then
		local var_1_0 = Managers.mechanism:current_mechanism_name()

		Managers.mechanism:destroy()

		Managers.mechanism = GameMechanismManager:new(var_1_0)

		if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() and (IS_PS4 or Managers.account:offline_mode()) then
			if Managers.party:has_party_lobby() then
				local var_1_1 = Managers.party:steal_lobby()

				if type(var_1_1) ~= "table" then
					LobbyInternal.leave_lobby(var_1_1)
				end
			end

			LobbyInternal.shutdown_client()
		end
	end

	local var_1_2 = arg_1_0.parent.loading_context
	local var_1_3 = {
		Application.argv()
	}

	for iter_1_0, iter_1_1 in pairs(var_1_3) do
		if iter_1_1 == "-auto-host-level" or iter_1_1 == "-auto-join" or iter_1_1 == "-skip-splash" or iter_1_1 == "-deus-auto-host" or iter_1_1 == "-vs-auto-search" or var_1_2.join_lobby_data or var_1_2.offline_invite or iter_1_1 == "-weave-name" then
			arg_1_0._auto_start = true

			break
		elseif IS_PS4 then
			local var_1_4 = SessionInvitation.play_together_list()

			if var_1_4 then
				Managers.invite:set_play_together_list(var_1_4)

				arg_1_0._auto_start = true

				break
			end
		end
	end

	Framerate.set_low_power()

	if script_data.honduras_demo then
		arg_1_0:_demo_hack_state_managers()
	end

	arg_1_0._params = arg_1_1

	arg_1_0:_setup_world()
	arg_1_0:_setup_leak_prevention()
	arg_1_0:_init_input()
	arg_1_0:_init_ui()
	arg_1_0:_setup_state_machine()
	arg_1_0:_init_popup_manager()
	arg_1_0:_init_chat_manager()

	if IS_WINDOWS or IS_LINUX then
		arg_1_0:_load_global_resources()
	end

	Managers.eac = Managers.eac or EacManager:new()

	if Managers.beta_overlay then
		Managers.beta_overlay:destroy()

		Managers.beta_overlay = nil
	end

	if IS_PS4 then
		local var_1_5 = Managers.account

		if var_1_5:is_online() then
			var_1_5:set_presence("title_screen")
		end
	end

	arg_1_0:_fade_out()

	if rawget(_G, "ControllerFeaturesManager") then
		Managers.state.controller_features = ControllerFeaturesManager:new()
	end

	arg_1_0._is_installed = Managers.play_go:installed()
	arg_1_0._play_go_progress_string = Localize("play_go_installing_progress")

	if Managers.backend and Managers.backend:item_script_type() == "tutorial" then
		Managers.backend:stop_tutorial()
	end

	ShowCursorStack.show("StateTitleScreen")
end

function StateTitleScreen._load_global_resources(arg_2_0)
	GlobalResources.update_loading()
end

function StateTitleScreen._demo_hack_state_managers(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = {}
	local var_3_3 = {
		__index = function()
			return var_3_2
		end
	}

	setmetatable(var_3_0, var_3_3)

	local var_3_4 = {
		__index = function()
			return var_3_1
		end
	}

	setmetatable(var_3_2, var_3_4)

	local var_3_5 = {
		__index = function()
			return var_3_1
		end,
		__call = function()
			return nil
		end
	}

	setmetatable(var_3_1, var_3_5)

	arg_3_0._old_state_manager = Managers.state
	Managers.state = var_3_0
end

function StateTitleScreen._fade_out(arg_8_0)
	if IS_XB1 then
		if Managers.account:should_teardown_xboxlive() then
			Managers.account:teardown_xboxlive()

			arg_8_0._wait_for_xboxlive_teardown = true
		elseif not arg_8_0._auto_start then
			Managers.transition:hide_loading_icon()
			Managers.transition:fade_out(1)
		end
	else
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(1)
	end
end

function StateTitleScreen._setup_leak_prevention(arg_9_0)
	local var_9_0 = true

	GarbageLeakDetector.run_leak_detection(var_9_0)
	GarbageLeakDetector.register_object(arg_9_0, "StateTitleScreen")
	VisualAssertLog.setup(arg_9_0._world)
end

function StateTitleScreen._setup_world(arg_10_0)
	if not Managers.package:has_loaded("resource_packages/start_menu_splash", "StateSplashScreen") and not GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen")
	end

	if IS_CONSOLE and not Managers.package:has_loaded("resource_packages/news_splash/news_splash", "state_splash_screen") and not GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		Managers.package:load("resource_packages/news_splash/news_splash", "state_splash_screen")
	end

	arg_10_0._world_name = "title_screen_world"
	arg_10_0._viewport_name = "title_screen_viewport"
	arg_10_0._world = Managers.world:create_world(arg_10_0._world_name, GameSettingsDevelopment.default_environment, nil, 100, Application.ENABLE_UMBRA, Application.ENABLE_VOLUMETRICS)

	if script_data.honduras_demo then
		arg_10_0._viewport = ScriptWorld.create_viewport(arg_10_0._world, arg_10_0._viewport_name, "default", 1)
	else
		arg_10_0._viewport = ScriptWorld.create_viewport(arg_10_0._world, arg_10_0._viewport_name, "overlay", 1)
		arg_10_0._gui = World.create_screen_gui(arg_10_0._world)

		local var_10_0, var_10_1 = Application.resolution()

		Gui.rect(arg_10_0._gui, Vector3(0, 0, 0), Vector2(var_10_0, var_10_1), Color(255, 0, 0, 0))
	end

	local var_10_2 = ScriptViewport.camera(arg_10_0._viewport)

	Camera.set_vertical_fov(var_10_2, math.pi * 65 / 180)
	Camera.set_far_range(var_10_2, 5000)
end

function StateTitleScreen._init_input(arg_11_0)
	arg_11_0._input_manager = InputManager:new()

	local var_11_0 = arg_11_0._input_manager

	Managers.input = var_11_0

	var_11_0:initialize_device("keyboard", 1)
	var_11_0:initialize_device("mouse", 1)
	var_11_0:initialize_device("gamepad")
	var_11_0:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
	var_11_0:create_input_service("chat_input", "ChatControllerSettings", "ChatControllerFilters")
	var_11_0:create_input_service("player_list_input", "IngamePlayerListKeymaps", "IngamePlayerListFilters")
end

local var_0_0 = true

function StateTitleScreen._init_ui(arg_12_0)
	if not GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		if script_data.honduras_demo then
			arg_12_0._title_start_ui = DemoTitleUI:new(arg_12_0._world, arg_12_0._viewport, arg_12_0)
		else
			arg_12_0._title_start_ui = TitleMainUI:new(arg_12_0._world)
		end
	end
end

function StateTitleScreen._setup_state_machine(arg_13_0)
	local var_13_0 = arg_13_0.parent.loading_context

	if var_13_0.skip_signin then
		var_13_0.skip_signin = nil
		arg_13_0._machine = GameStateMachine:new(arg_13_0, StateTitleScreenMainMenu, {
			skip_signin = true,
			world = arg_13_0._world,
			ui = arg_13_0._title_start_ui,
			viewport = arg_13_0._viewport,
			auto_start = arg_13_0._auto_start,
			auto_sign_in = arg_13_0._auto_sign_in
		}, true)
	else
		arg_13_0._machine = GameStateMachine:new(arg_13_0, StateTitleScreenMain, {
			world = arg_13_0._world,
			ui = arg_13_0._title_start_ui,
			viewport = arg_13_0._viewport,
			auto_start = arg_13_0._auto_start,
			auto_sign_in = arg_13_0._auto_sign_in
		}, true)
	end
end

function StateTitleScreen._init_popup_manager(arg_14_0)
	Managers.popup = Managers.popup or PopupManager:new()

	Managers.popup:set_input_manager(arg_14_0._input_manager)

	Managers.simple_popup = Managers.simple_popup or SimplePopup:new()
end

function StateTitleScreen._init_chat_manager(arg_15_0)
	Managers.chat = Managers.chat or ChatManager:new()
end

function StateTitleScreen._init_beta_overlay(arg_16_0)
	if not Managers.beta_overlay then
		Managers.beta_overlay = BetaOverlay:new(Managers.world:world("top_ingame_view"))
	end
end

function StateTitleScreen.update(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:_handle_delayed_fade_in()
	Managers.input:update(arg_17_1, arg_17_2)
	arg_17_0._machine:update(arg_17_1, arg_17_2)

	if Managers.backend and not Managers.backend:is_disconnected() then
		Managers.backend:update(arg_17_1, arg_17_2)
	end

	arg_17_0:_update_play_go_progress(arg_17_1, arg_17_2)

	if Managers.state.controller_features then
		Managers.state.controller_features:update(arg_17_1, arg_17_2)
	end

	if Managers.eac ~= nil then
		Managers.eac:update(arg_17_1, arg_17_2)
	end

	if Managers.music then
		Managers.music:update(arg_17_1, arg_17_2)
	end

	local var_17_0 = GameSettingsDevelopment.skip_start_screen

	arg_17_0:_render(arg_17_1, var_17_0)

	if script_data.debug_enabled then
		VisualAssertLog.update(arg_17_1)
	end

	return arg_17_0:_next_state()
end

function StateTitleScreen.post_update(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._machine:post_update(arg_18_1, arg_18_2)
end

function StateTitleScreen._next_state(arg_19_0)
	if Managers.popup:has_popup() or Managers.account:user_detached() then
		if Managers.account:leaving_game() then
			print("Reloading StateTitleScreen due to user detatched")

			arg_19_0.state = StateTitleScreen

			Managers.popup:cancel_all_popups()
		else
			return
		end
	elseif Managers.account:leaving_game() and not arg_19_0._wait_for_xboxlive_teardown then
		print("Reloading StateTitleScreen due to leaving game")

		arg_19_0.state = StateTitleScreen

		Managers.popup:cancel_all_popups()
	elseif IS_XB1 and Managers.backend and Managers.backend:is_disconnected() then
		print("Reloading StateTitleScreen due to backend disconnect")

		arg_19_0.state = StateTitleScreen

		Managers.popup:cancel_all_popups()
	end

	return arg_19_0.state
end

function StateTitleScreen._handle_delayed_fade_in(arg_20_0)
	if IS_XB1 and arg_20_0._wait_for_xboxlive_teardown and not Managers.account:should_teardown_xboxlive() and not arg_20_0._auto_start then
		Managers.transition:fade_out(1)

		arg_20_0._wait_for_xboxlive_teardown = nil

		Managers.transition:hide_loading_icon()
	end
end

function StateTitleScreen._update_play_go_progress(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0._is_installed then
		return
	end

	if Managers.play_go:installed() then
		arg_21_0._title_start_ui:clear_playgo_status()

		arg_21_0._is_installed = true
	else
		local var_21_0 = Managers.play_go:progress_percentage()
		local var_21_1 = tostring(100 * var_21_0)
		local var_21_2 = string.format(arg_21_0._play_go_progress_string, var_21_1)

		arg_21_0._title_start_ui:set_playgo_status(var_21_2)
	end
end

function StateTitleScreen.enter_attract_mode(arg_22_0, arg_22_1)
	arg_22_0._attract_mode_active = arg_22_1
end

function StateTitleScreen._render(arg_23_0, arg_23_1, arg_23_2)
	return
end

function StateTitleScreen.show_menu(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._title_start_ui:show_menu(arg_24_1, arg_24_2)
end

function StateTitleScreen.on_exit(arg_25_0, arg_25_1)
	Framerate.set_playing()
	arg_25_0._machine:destroy()
	VisualAssertLog.cleanup()

	if arg_25_0._title_start_ui then
		arg_25_0._title_start_ui:destroy()

		arg_25_0._title_start_ui = nil
	end

	if not script_data.disable_beta_overlay then
		arg_25_0:_init_beta_overlay()
	end

	if arg_25_1 and rawget(_G, "LobbyInternal") and LobbyInternal.client then
		if Managers.party:has_party_lobby() then
			local var_25_0 = Managers.party:steal_lobby()

			if type(var_25_0) ~= "table" then
				LobbyInternal.leave_lobby(var_25_0)
			end
		end

		LobbyInternal.shutdown_client()
	end

	World.destroy_gui(arg_25_0._world, arg_25_0._gui)
	ScriptWorld.destroy_viewport(arg_25_0._world, arg_25_0._viewport_name)
	Managers.world:destroy_world(arg_25_0._world)
	Managers.popup:remove_input_manager(arg_25_1)
	arg_25_0._input_manager:destroy()

	arg_25_0._input_manager = nil
	Managers.input = nil

	if script_data.honduras_demo then
		Managers.state = arg_25_0._old_state_manager

		Wwise.set_state("menu_mute_ingame_sounds", "default")
	end

	Managers.state:destroy()

	if Managers.package:has_loaded("resource_packages/news_splash/news_splash", "state_splash_screen") then
		Managers.package:unload("resource_packages/news_splash/news_splash", "state_splash_screen")
		Managers.package:unload("resource_packages/start_menu_splash", "StateSplashScreen")
	end

	if IS_CONSOLE and not GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		Managers.music:trigger_event("Stop_menu_screen_music")
	end

	ShowCursorStack.hide("StateTitleScreen")
end
