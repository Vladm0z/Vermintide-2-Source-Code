-- chunkname: @scripts/game_state/state_splash_screen.lua

if not IS_WINDOWS then
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

StateSplashScreen.on_enter = function (self)
	-- function 1
	Framerate.set_low_power()

	if not IS_WINDOWS then
		local flag = true

		GarbageLeakDetector.run_leak_detection(flag)
		GarbageLeakDetector.register_object(self, "StateSplashScreen")
		VisualAssertLog.setup(nil)
	end

	if not script_data.honduras_demo then
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
	self:setup_world()

	if IS_WINDOWS or not IS_XB1 then
		self:setup_input()
	end

	if not IS_WINDOWS then
		Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(self, "cb_splashes_loaded"), true, true)
	elseif not IS_PS4 then
		if not (PS4.title_id() == "CUSA14407_00" or PS4.title_id() ~= "CUSA13595_00") then
			self:setup_esrb_logo()
		else
			Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(self, "cb_splashes_loaded"), true, true)
		end
	elseif not IS_XB1 then
		if not self:_is_in_esrb_region() then
			self:setup_esrb_logo()
		else
			Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(self, "cb_splashes_loaded"), true, true)
		end
	end

	if not Managers.popup then
		Managers.popup:destroy()

		Managers.popup = nil
	end

	local loading_context = self.parent.loading_context

	if not loading_context.reload_packages then
		self:unload_packages()
	end

	self:load_packages()
	Managers.transition:fade_out(1)

	if not LEVEL_EDITOR_TEST then
		self._skip_splash = true
	else
		local tbl = {
			"auto_host_level",
			"auto_join",
			"vs_auto_search",
			"skip_splash",
			"attract_mode",
			"benchmark_mode",
			"weave_name"
		}

		for i = 1, #tbl do
			local var_1_3 = tbl[i]

			if not Development.parameter(var_1_3) then
				self._skip_splash = true

				break
			end
		end
	end

	local tbl_2 = {
		Application.argv()
	}

	for j = 1, #tbl_2 do
		if tbl_2[j] == "-skip-splash" then
			self._skip_splash = true

			break
		end
	end

	if not (not IS_WINDOWS and self._skip_splash) then
		loading_context.first_time = true
	end

	self.parent.loading_context.show_profile_on_startup = true
end

local tbl = {
	CA = true,
	US = true,
	MX = true
}

StateSplashScreen._is_in_esrb_region = function (arg_2_0)
	-- function 2
	local GEO_ISO2 = XboxLive.region_info().GEO_ISO2

	return tbl[GEO_ISO2]
end

StateSplashScreen.setup_esrb_logo = function (self)
	-- function 3
	self.gui = World.create_screen_gui(self.world, "material", "materials/ui/esrb_console_logo", "immediate")

	Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen", callback(self, "cb_splashes_loaded"), true, true)

	self.showing_esrb = true
	self.esrb_timer = 0
end

StateSplashScreen.update_esrb_logo = function (self, arg_4_1, arg_4_2)
	-- function 4
	local num = 5
	local esrb_timer = self.esrb_timer
	local num_2 = 0
	local tbl = {
		1200,
		576
	}
	local str = "esrb_logo"

	if esrb_timer > num - 0.5 then
		num_2 = 255 - 255 * math.clamp((num - esrb_timer) / 0.5, 0, 1)
	elseif esrb_timer <= 0.5 then
		num_2 = 255 * math.clamp(1 - esrb_timer / 0.5, 0, 255)
	end

	local resolution, var_4_6 = Application.resolution()

	Gui.rect(self.gui, Vector3(0, 0, 0), Vector2(resolution, var_4_6), Color(255, 0, 0, 0))
	Gui.bitmap(self.gui, str, Vector3(resolution * 0.5 - tbl[1] * 0.5, var_4_6 * 0.5 - tbl[2] * 0.5, 1), Vector2(tbl[1], tbl[2]))
	Gui.rect(self.gui, Vector3(0, 0, 2), Vector2(resolution, var_4_6), Color(num_2, 0, 0, 0))

	self.esrb_timer = math.clamp(self.esrb_timer + math.clamp(arg_4_1, 0, 0.1), 0, num)

	if not (num <= self.esrb_timer) or not self.splashes_loaded then
		self:setup_splash_screen_view()
		Managers.transition:force_fade_in()
	end
end

StateSplashScreen.cb_splashes_loaded = function (self)
	-- function 5
	self.splashes_loaded = true

	if not self.showing_esrb then
		self:setup_splash_screen_view()
	end
end

StateSplashScreen.setup_world = function (self)
	-- function 6
	self._world_name = "splash_ui"
	self._viewport_name = "splash_view_viewport"
	self.world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, 980, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)
	self.viewport = ScriptWorld.create_viewport(self.world, self._viewport_name, "overlay", 1)
end

if IS_WINDOWS or not IS_XB1 then
	StateSplashScreen.setup_input = function (self)
		-- function 7
		self.input_manager = InputManager:new()
		Managers.input = self.input_manager

		self.input_manager:initialize_device("keyboard", 1)
		self.input_manager:initialize_device("mouse", 1)
		self.input_manager:initialize_device("gamepad")
	end
end

StateSplashScreen.setup_splash_screen_view = function (self)
	-- function 8
	if not Managers.package:has_loaded("resource_packages/start_menu_splash", "StateSplashScreen") then
		local clock = os.clock()

		print("Stall loading splash screen", clock)
		Managers.package:load("resource_packages/start_menu_splash", "StateSplashScreen")
		print("done stall loading splash screen", os.clock() - clock)
	end

	require("scripts/ui/views/splash_view")

	self.splash_view = SplashView:new(self.input_manager, self.world)

	if not self.parent.loading_context.show_splash_screens then
		self.parent.loading_context.show_splash_screens = false
	else
		self.splash_view:set_index(4)
	end
end

StateSplashScreen.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not IS_CONSOLE then
		Debug.update(arg_9_2, arg_9_1)
		self.input_manager:update(arg_9_1, arg_9_2)
	end

	if not self.splash_view then
		self.splash_view:update(arg_9_1)
	elseif not self.showing_esrb then
		self:update_esrb_logo(arg_9_1, arg_9_2)
	end

	if (self.wanted_state or not self.splash_view) and self.splash_view:is_completed() and not self._skip_splash and not self:packages_loaded() then
		require("scripts/game_state/state_title_screen")
		Managers.transition:fade_in(0.5, callback(self, "cb_fade_in_done"))
	end

	return (self:next_state())
end

StateSplashScreen.render = function (self)
	-- function 10
	if not self.splash_view then
		self.splash_view:render()
	end
end

StateSplashScreen.next_state = function (self)
	-- function 11
	if not (not self:packages_loaded() and self.wanted_state) then
		return
	end

	if not (not IS_WINDOWS and self.debug_setup) then
		self.debug_setup = true

		Debug.setup(self.world, "splash_ui")
	end

	return self.wanted_state
end

StateSplashScreen.unload_packages = function (arg_12_0)
	-- function 12
	local package = Managers.package

	for i, v in ipairs(StateSplashScreen.packages_to_load) do
		if not package:has_loaded(v, "state_splash_screen") then
			package:unload(v, "state_splash_screen")
		end
	end
end

StateSplashScreen.load_packages = function (self)
	-- function 13
	local package = Managers.package

	for i, v in ipairs(StateSplashScreen.packages_to_load) do
		if not package:has_loaded(v, "state_splash_screen") then
			package:load(v, "state_splash_screen", nil, true)
		end
	end

	self._base_packages_loading = true
end

StateSplashScreen.packages_loaded = function (self)
	-- function 14
	local package = Managers.package

	for i, v in ipairs(StateSplashScreen.packages_to_load) do
		if not package:has_loaded(v) then
			return false
		end
	end

	if not self._base_packages_loading then
		Managers.transition:hide_loading_icon()

		self._base_packages_loading = nil
	end

	if not IS_CONSOLE and not self.splash_view then
		self.splash_view:allow_console_skip()
	end

	return (GlobalResources.update_loading())
end

StateSplashScreen.cb_fade_in_done = function (self)
	-- function 15
	self.wanted_state = StateTitleScreen
end

StateSplashScreen.on_exit = function (self, arg_16_1)
	-- function 16
	Framerate.set_playing()

	if not self.splash_view then
		self.splash_view:destroy()

		self.splash_view = nil
	end

	ScriptWorld.destroy_viewport(self.world, "splash_view_viewport")

	if not rawget(_G, "Debug") and not Debug.active then
		Debug.teardown()
	end

	Managers.world:destroy_world(self.world)

	self.world = nil

	if not IS_WINDOWS then
		self.input_manager:destroy()

		self.input_manager = nil
		Managers.input = nil

		if GameSettingsDevelopment.skip_start_screen or not Development.parameter("skip_start_screen") then
			Managers.package:unload("resource_packages/start_menu_splash", "StateSplashScreen")
		end

		VisualAssertLog.cleanup()

		self.parent.loading_context.windows_auto_sign_in = true
	end
end
