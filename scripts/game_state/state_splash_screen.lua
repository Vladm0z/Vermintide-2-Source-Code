-- chunkname: @scripts/game_state/state_splash_screen.lua

if IS_WINDOWS then
	require("scripts/managers/input/input_manager")
	require("scripts/utils/visual_assert_log")
	require("scripts/managers/debug/debug")
end

require("foundation/scripts/util/garbage_leak_detector")

StateSplashScreen = class(StateSplashScreen)
StateSplashScreen.NAME = "StateSplashScreen"
StateSplashScreen.packages_to_load = {
	"resource_packages/title_screen",
	"resource_packages/menu",
	"resource_packages/platform_specific/platform_specific",
	"resource_packages/menu_assets",
	"resource_packages/loading_screens/loading_screen_default"
}

if not IS_WINDOWS then
	StateSplashScreen.packages_to_load[#StateSplashScreen.packages_to_load + 1] = "resource_packages/news_splash/news_splash"
end

StateSplashScreen.on_enter = function (arg_1_0)
	Framerate.set_low_power()

	if IS_WINDOWS then
		local var_1_0 = true

		GarbageLeakDetector.run_leak_detection(var_1_0)
		GarbageLeakDetector.register_object(arg_1_0, "StateSplashScreen")
		VisualAssertLog.setup(nil)
	end

	if script_data.honduras_demo then
		table.insert(StateSplashScreen.packages_to_load, 1, DemoSettings.level_resource_package)
		table.insert(StateSplashScreen.packages_to_load, 1, DemoSettings.inventory_resource_package)
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_one")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_two")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_three")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_weapon_general")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_enemy_clan_rat_vce")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_player_foley_common")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_hud_dice_game")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_general_props")
		table.insert(StateSplashScreen.packages_to_load, 1, "resource_packages/ingame_sounds_honduras")
	end

	Managers.transition:force_fade_in()
	Managers.transition:show_loading_icon(false)
	arg_1_0:setup_world()

	if IS_WINDOWS or IS_XB1 then
		arg_1_0:setup_input()
	end

	if IS_WINDOWS then
		Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(arg_1_0, "cb_splashes_loaded"), true, true)
	elseif IS_PS4 then
		if PS4.title_id() == "CUSA14407_00" or PS4.title_id() == "CUSA13595_00" then
			arg_1_0:setup_esrb_logo()
		else
			Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(arg_1_0, "cb_splashes_loaded"), true, true)
		end
	elseif IS_XB1 then
		if arg_1_0:_is_in_esrb_region() then
			arg_1_0:setup_esrb_logo()
		else
			Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(arg_1_0, "cb_splashes_loaded"), true, true)
		end
	end

	if Managers.popup then
		Managers.popup:destroy()

		Managers.popup = nil
	end

	local var_1_1 = arg_1_0.parent.loading_context

	if var_1_1.reload_packages then
		arg_1_0:unload_packages()
	end

	arg_1_0:load_packages()
	Managers.transition:fade_out(1)

	if LEVEL_EDITOR_TEST then
		arg_1_0._skip_splash = true
	else
		local var_1_2 = {
			"auto_host_level",
			"auto_join",
			"vs_auto_search",
			"skip_splash",
			"attract_mode",
			"benchmark_mode",
			"weave_name"
		}

		for iter_1_0 = 1, #var_1_2 do
			local var_1_3 = var_1_2[iter_1_0]

			if Development.parameter(var_1_3) then
				arg_1_0._skip_splash = true

				break
			end
		end
	end

	local var_1_4 = {
		Application.argv()
	}

	for iter_1_1 = 1, #var_1_4 do
		if var_1_4[iter_1_1] == "-skip-splash" then
			arg_1_0._skip_splash = true

			break
		end
	end

	if IS_WINDOWS and not arg_1_0._skip_splash then
		var_1_1.first_time = true
	end

	arg_1_0.parent.loading_context.show_profile_on_startup = true
end

local var_0_0 = {
	CA = true,
	US = true,
	MX = true
}

StateSplashScreen._is_in_esrb_region = function (arg_2_0)
	local var_2_0 = XboxLive.region_info().GEO_ISO2

	return var_0_0[var_2_0]
end

StateSplashScreen.setup_esrb_logo = function (arg_3_0)
	arg_3_0.gui = World.create_screen_gui(arg_3_0.world, "material", "materials/ui/esrb_console_logo", "immediate")

	Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(arg_3_0, "cb_splashes_loaded"), true, true)

	arg_3_0.showing_esrb = true
	arg_3_0.esrb_timer = 0
end

StateSplashScreen.update_esrb_logo = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = 5
	local var_4_1 = arg_4_0.esrb_timer
	local var_4_2 = 0
	local var_4_3 = {
		1200,
		576
	}
	local var_4_4 = "esrb_logo"

	if var_4_1 > var_4_0 - 0.5 then
		var_4_2 = 255 - 255 * math.clamp((var_4_0 - var_4_1) / 0.5, 0, 1)
	elseif var_4_1 <= 0.5 then
		var_4_2 = 255 * math.clamp(1 - var_4_1 / 0.5, 0, 255)
	end

	local var_4_5, var_4_6 = Application.resolution()

	Gui.rect(arg_4_0.gui, Vector3(0, 0, 0), Vector2(var_4_5, var_4_6), Color(255, 0, 0, 0))
	Gui.bitmap(arg_4_0.gui, var_4_4, Vector3(var_4_5 * 0.5 - var_4_3[1] * 0.5, var_4_6 * 0.5 - var_4_3[2] * 0.5, 1), Vector2(var_4_3[1], var_4_3[2]))
	Gui.rect(arg_4_0.gui, Vector3(0, 0, 2), Vector2(var_4_5, var_4_6), Color(var_4_2, 0, 0, 0))

	arg_4_0.esrb_timer = math.clamp(arg_4_0.esrb_timer + math.clamp(arg_4_1, 0, 0.1), 0, var_4_0)

	if var_4_0 <= arg_4_0.esrb_timer and arg_4_0.splashes_loaded then
		arg_4_0:setup_splash_screen_view()
		Managers.transition:force_fade_in()
	end
end

StateSplashScreen.cb_splashes_loaded = function (arg_5_0)
	arg_5_0.splashes_loaded = true

	if not arg_5_0.showing_esrb then
		arg_5_0:setup_splash_screen_view()
	end
end

StateSplashScreen.setup_world = function (arg_6_0)
	arg_6_0._world_name = "splash_ui"
	arg_6_0._viewport_name = "splash_view_viewport"
	arg_6_0.world = Managers.world:create_world(arg_6_0._world_name, GameSettingsDevelopment.default_environment, nil, 980, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)
	arg_6_0.viewport = ScriptWorld.create_viewport(arg_6_0.world, arg_6_0._viewport_name, "overlay", 1)
end

if IS_WINDOWS or IS_XB1 then
	StateSplashScreen.setup_input = function (arg_7_0)
		arg_7_0.input_manager = InputManager:new()
		Managers.input = arg_7_0.input_manager

		arg_7_0.input_manager:initialize_device("keyboard", 1)
		arg_7_0.input_manager:initialize_device("mouse", 1)
		arg_7_0.input_manager:initialize_device("gamepad")
	end
end

StateSplashScreen.setup_splash_screen_view = function (arg_8_0)
	if not Managers.package:has_loaded("resource_packages/start_menu_splash", "StateSplashScreen") then
		local var_8_0 = os.clock()

		print("Stall loading splash screen", var_8_0)
		Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen")
		print("done stall loading splash screen", os.clock() - var_8_0)
	end

	require("scripts/ui/views/splash_view")

	arg_8_0.splash_view = SplashView:new(arg_8_0.input_manager, arg_8_0.world)

	if arg_8_0.parent.loading_context.show_splash_screens then
		arg_8_0.parent.loading_context.show_splash_screens = false
	else
		arg_8_0.splash_view:set_index(4)
	end
end

StateSplashScreen.update = function (arg_9_0, arg_9_1, arg_9_2)
	if not IS_CONSOLE then
		Debug.update(arg_9_2, arg_9_1)
		arg_9_0.input_manager:update(arg_9_1, arg_9_2)
	end

	if arg_9_0.splash_view then
		arg_9_0.splash_view:update(arg_9_1)
	elseif arg_9_0.showing_esrb then
		arg_9_0:update_esrb_logo(arg_9_1, arg_9_2)
	end

	if not arg_9_0.wanted_state and (arg_9_0.splash_view and arg_9_0.splash_view:is_completed() or arg_9_0._skip_splash) and arg_9_0:packages_loaded() then
		require("scripts/game_state/state_title_screen")
		Managers.transition:fade_in(0.5, callback(arg_9_0, "cb_fade_in_done"))
	end

	return (arg_9_0:next_state())
end

StateSplashScreen.render = function (arg_10_0)
	if arg_10_0.splash_view then
		arg_10_0.splash_view:render()
	end
end

StateSplashScreen.next_state = function (arg_11_0)
	if not arg_11_0:packages_loaded() or not arg_11_0.wanted_state then
		return
	end

	if IS_WINDOWS and not arg_11_0.debug_setup then
		arg_11_0.debug_setup = true

		Debug.setup(arg_11_0.world, "splash_ui")
	end

	return arg_11_0.wanted_state
end

StateSplashScreen.unload_packages = function (arg_12_0)
	local var_12_0 = Managers.package

	for iter_12_0, iter_12_1 in ipairs(StateSplashScreen.packages_to_load) do
		if var_12_0:has_loaded(iter_12_1, "state_splash_screen") then
			var_12_0:unload(iter_12_1, "state_splash_screen")
		end
	end
end

StateSplashScreen.load_packages = function (arg_13_0)
	local var_13_0 = Managers.package

	for iter_13_0, iter_13_1 in ipairs(StateSplashScreen.packages_to_load) do
		if not var_13_0:has_loaded(iter_13_1, "state_splash_screen") then
			var_13_0:load(iter_13_1, "state_splash_screen", nil, true)
		end
	end

	arg_13_0._base_packages_loading = true
end

StateSplashScreen.packages_loaded = function (arg_14_0)
	local var_14_0 = Managers.package

	for iter_14_0, iter_14_1 in ipairs(StateSplashScreen.packages_to_load) do
		if not var_14_0:has_loaded(iter_14_1) then
			return false
		end
	end

	if arg_14_0._base_packages_loading then
		Managers.transition:hide_loading_icon()

		arg_14_0._base_packages_loading = nil
	end

	if IS_CONSOLE and arg_14_0.splash_view then
		arg_14_0.splash_view:allow_console_skip()
	end

	return (GlobalResources.update_loading())
end

StateSplashScreen.cb_fade_in_done = function (arg_15_0)
	arg_15_0.wanted_state = StateTitleScreen
end

StateSplashScreen.on_exit = function (arg_16_0, arg_16_1)
	Framerate.set_playing()

	if arg_16_0.splash_view then
		arg_16_0.splash_view:destroy()

		arg_16_0.splash_view = nil
	end

	ScriptWorld.destroy_viewport(arg_16_0.world, "splash_view_viewport")

	if rawget(_G, "Debug") and Debug.active then
		Debug.teardown()
	end

	Managers.world:destroy_world(arg_16_0.world)

	arg_16_0.world = nil

	if IS_WINDOWS then
		arg_16_0.input_manager:destroy()

		arg_16_0.input_manager = nil
		Managers.input = nil

		if GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") then
			Managers.package:unload("resource_packages/start_menu_splash", "StateSplashScreen")
		end

		VisualAssertLog.cleanup()

		arg_16_0.parent.loading_context.windows_auto_sign_in = true
	end
end
