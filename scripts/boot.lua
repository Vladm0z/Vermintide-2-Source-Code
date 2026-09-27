-- chunkname: @scripts/boot.lua

print("boot.lua start, os clock:", os.clock())
dofile("scripts/boot_init")

if not DEDICATED_SERVER then
	dofile("scripts/global_shader_flags")
end

local BUILD = BUILD
local PLATFORM = PLATFORM

if not IS_XB1 then
	local tbl = {
		[XboxOne.CONSOLE_TYPE_UNKNOWN] = "unknown",
		[XboxOne.CONSOLE_TYPE_XBOX_ONE] = "xb1",
		[XboxOne.CONSOLE_TYPE_XBOX_ONE_S] = "xb1s",
		[XboxOne.CONSOLE_TYPE_XBOX_ONE_X] = "xb1x",
		[XboxOne.CONSOLE_TYPE_XBOX_ONE_X_DEVKIT] = "xb1x-devkit",
		[XboxOne.CONSOLE_TYPE_XBOX_LOCKHART] = "xbs_lockhart",
		[XboxOne.CONSOLE_TYPE_XBOX_ANACONDA] = "xbs_anaconda",
		[XboxOne.CONSOLE_TYPE_XBOX_SERIES_X_DEVKIT] = "xbs_anaconda-devkit"
	}

	XboxOne.console_type_string = function ()
		-- function 1
		return tbl[XboxOne.console_type()]
	end
end

local function fn(arg_2_0, ...)
	-- function 2
	for i, v in ipairs({
		...
	}) do
		require(string.format("foundation/scripts/%s/%s", arg_2_0, v))
	end
end

local function fn_2(arg_3_0, ...)
	-- function 3
	for i, v in ipairs({
		...
	}) do
		require("core/" .. arg_3_0 .. "/" .. v)
	end
end

local function fn_3(arg_4_0, ...)
	-- function 4
	for i, v in ipairs({
		...
	}) do
		require("scripts/" .. arg_4_0 .. "/" .. v)
	end
end

local function fn_4(arg_5_0, ...)
	-- function 5
	for i, v in ipairs({
		...
	}) do
		require("foundation/scripts/" .. arg_5_0 .. "/" .. v)
	end
end

print("Active feature-flags:")
Application.print_strip_tags()
print("")
require("scripts/settings/dlc_settings")
require("scripts/helpers/dlc_utils")

local Boot = Boot

Boot = Boot or {}
Boot = Boot
Boot.flow_return_table = Script.new_map(32)
Boot.is_controlled_exit = false

local function fn_5(arg_6_0)
	-- function 6
	return {
		title = arg_6_0,
		start_time = os.clock()
	}
end

local function fn_6(self, arg_7_1)
	-- function 7
	local count = #self
	local var_7_1 = self[count]

	if not (not var_7_1 and var_7_1.alias ~= arg_7_1) then
		var_7_1.end_time = os.clock()
	else
		local tbl = {
			alias = arg_7_1
		}

		self[count + 1] = tbl
		tbl.start_time = os.clock()
	end
end

local function fn_7(self)
	-- function 8
	local num = os.clock() - self.start_time

	print(self.title .. " total time: " .. num)

	local num_2 = 0

	for i, v in ipairs(self) do
		local end_time = v.end_time

		end_time = end_time or math.huge

		local num_3 = end_time - v.start_time

		print("\t" .. v.alias .. ": ", num_3)

		num_2 = num_2 + num_3
	end

	print("")
	print("\t unaccounted: ", num - num_2)
end

Boot.setup = function (self)
	-- function 9
	_G.Crashify = require("foundation/scripts/util/crashify")

	if DEDICATED_SERVER or not IS_WINDOWS then
		Application.set_time_step_policy("throttle", 30)
	end

	Script.set_index_offset(0)
	print("Boot:setup() entered. time: ", 0, "os-clock: ", os.clock())

	Boot.startup_timer = 0
	Boot.startup_state = "loading"

	if not IS_WINDOWS then
		Window.set_focus()
		Window.set_mouse_focus(true)
	end

	print(Application.sysinfo())
	self:_init_localizer()

	Boot.startup_packages = {
		"resource_packages/boot_assets",
		"resource_packages/fonts",
		"resource_packages/strings",
		"resource_packages/foundation_scripts",
		"resource_packages/game_scripts",
		"resource_packages/level_scripts",
		"resource_packages/levels/benchmark_levels",
		"resource_packages/levels/honduras_levels"
	}
	Boot.temporary_network_lookup_packages = {
		"resource_packages/dialogues/dialogues_generated_lookup"
	}

	local tbl = {}

	for i, v in ipairs(Boot.startup_packages) do
		local resource_package = Application.resource_package(v)

		ResourcePackage.load(resource_package)

		tbl[v] = resource_package
	end

	Boot.startup_package_handles = tbl

	local tbl_2 = {}

	for i_2, v_2 in ipairs(Boot.temporary_network_lookup_packages) do
		local resource_package_2 = Application.resource_package(v_2)

		ResourcePackage.load(resource_package_2)

		tbl_2[v_2] = resource_package_2
	end

	Boot.temp_network_lookup_package_handles = tbl_2
	Boot.render = Boot.booting_render

	create_startup_world()
end

local function fn_8(arg_10_0)
	-- function 10
	local var_10_0 = ({
		["zh-hk"] = "zh",
		["fr-ch"] = "fr",
		["ru-ru"] = "ru",
		["nb-no"] = "nb",
		["en-us"] = "en",
		["en-gb"] = "en",
		["en-il"] = "en",
		["es-mx"] = "es",
		["en-nz"] = "en",
		["da-dk"] = "da",
		["en-sa"] = "en",
		["pt-pt"] = "pt",
		["es-co"] = "es",
		["en-hu"] = "en",
		["en-sg"] = "en",
		["fr-ca"] = "fr",
		["en-ae"] = "en",
		["nl-be"] = "nl",
		["en-in"] = "en",
		["zh-tw"] = "zh",
		["en-cz"] = "en",
		["de-ch"] = "de",
		["de-de"] = "de",
		["fr-be"] = "fr",
		["en-gr"] = "en",
		["ko-kr"] = "kr",
		["tr-tr"] = "tr",
		["sv-se"] = "sv",
		["zh-sg"] = "zh",
		["es-ar"] = "es",
		["en-sk"] = "en",
		["pl-pl"] = "pl",
		["nl-nl"] = "nl",
		["pt-br"] = "br-pt",
		["it-it"] = "it",
		["es-es"] = "es",
		["en-au"] = "en",
		["de-at"] = "de",
		["en-ca"] = "en",
		["zh-cn"] = "zh",
		["fr-fr"] = "fr",
		["en-hk"] = "en",
		["ja-jp"] = "jp",
		["es-cl"] = "es",
		["fi-fi"] = "fi",
		["en-ie"] = "en",
		["en-za"] = "en"
	})[string.lower(arg_10_0)]

	var_10_0 = var_10_0 or "en"

	return var_10_0
end

Boot._init_localizer = function (arg_11_0)
	-- function 11
	local str = "en"
	local var_11_1

	if not IS_WINDOWS then
		var_11_1 = Application.user_setting("language_id") or not rawget(_G, "Steam") or Steam:language() or str
	elseif not IS_PS4 then
		var_11_1 = PS4.locale() or str
	elseif not IS_XB1 then
		local var_11_2 = fn_8
		local locale = XboxLive.locale()

		locale = locale or str
		var_11_1 = var_11_2(locale)
	elseif not IS_LINUX then
		var_11_1 = "en"
	end

	if var_11_1 == str then
		Application.set_resource_property_preference_order(str)
	else
		Application.set_resource_property_preference_order(var_11_1, str)
	end
end

local function fn_9()
	-- function 12
	require("foundation/scripts/util/user_setting")
	Development.init_user_settings()
	require("foundation/scripts/util/application_parameter")
	Development.init_application_parameters({
		Application.argv()
	}, true)
	require("foundation/scripts/util/development_parameter")
	Development.init_parameters()

	local num = 0

	for k, v in pairs(script_data) do
		num = math.max(num, #k)
	end

	local tbl = {}

	for k_2, v_2 in pairs(script_data) do
		if type(v_2) == "table" then
			local format = string.format("script_data.%%-%ds = {", num)
			local format_2 = string.format(format, k_2)

			for i4 = 1, #v_2 do
				format_2 = format_2 .. ", " .. tostring(v_2[i4])
			end

			local str = format_2 .. " }"

			tbl[#tbl + 1] = str
		else
			local format_3 = string.format("script_data.%%-%ds = %%s", num)

			tbl[#tbl + 1] = string.format(format_3, k_2, tostring(v_2))
		end
	end

	table.sort(tbl, function (arg_13_0, arg_13_1)
		-- function 13
		return arg_13_0 < arg_13_1
	end)
	print("*****************************************************************")
	print("**                Initial contents of script_data              **")

	for i5 = 1, #tbl do
		print(tbl[i5])
	end

	print("*****************************************************************")

	local script_data = script_data
	local honduras_demo = script_data.settings.honduras_demo

	honduras_demo = honduras_demo or script_data["honduras-demo"]
	script_data.honduras_demo = honduras_demo

	local settings = script_data.settings
	local use_beta_overlay = script_data.settings.use_beta_overlay

	use_beta_overlay = use_beta_overlay or script_data.use_beta_overlay
	settings.use_beta_overlay = use_beta_overlay

	local settings_2 = script_data.settings
	local use_beta_mode = script_data.settings.use_beta_mode

	use_beta_mode = use_beta_mode or script_data.use_beta_mode
	settings_2.use_beta_mode = use_beta_mode
	script_data.use_optimized_breed_units = IS_CONSOLE

	print("[Boot] use baked enemy meshes:", script_data.use_optimized_breed_units)
end

Boot.booting_update = function (self, arg_14_1)
	-- function 14
	local startup_timer = Boot.startup_timer

	Boot.startup_timer = startup_timer + arg_14_1

	local flag = true

	for k, v in pairs(Boot.startup_package_handles) do
		if not ResourcePackage.has_loaded(v) then
			flag = false

			break
		end
	end

	for k_2, v_2 in pairs(Boot.temp_network_lookup_package_handles) do
		if not ResourcePackage.has_loaded(v_2) then
			flag = false

			break
		end
	end

	if not (not flag and Boot.startup_state ~= "loading") then
		local clock = os.clock()

		print("Boot:booting_update() reports boot packages loaded, initializing scripts. time: ", Boot.startup_timer, "os-clock: ", clock)

		local startup_package_handles = Boot.startup_package_handles

		for i, v_3 in ipairs(Boot.startup_packages) do
			local var_14_4 = startup_package_handles[v_3]

			ResourcePackage.flush(var_14_4)
			print("Flushing:", v_3, var_14_4)
		end

		for i_2, v_4 in ipairs(Boot.temp_network_lookup_package_handles) do
			ResourcePackage.flush(v_4)
			print("Flushing:", i_2, v_4)
		end

		fn("managers", "managers", "package/package_manager")

		Managers.package = PackageManager

		Managers.package:init()
		fn_9()

		for k_3, v_5 in pairs(DLCSettings) do
			local package_name = v_5.package_name

			if not package_name then
				Managers.package:load(package_name, "boot", nil, true)
			end

			local platform_specific = v_5.platform_specific

			if not platform_specific then
				Managers.package:load(platform_specific, "boot", nil, true)
			end
		end

		local clock_2 = os.clock()

		self:_require_foundation_scripts()

		Boot.startup_state = "loading_dlcs"
	elseif Boot.startup_state == "loading_dlcs" then
		fn_4("util", "local_require")

		if not Managers.package:update(arg_14_1) then
			Boot.startup_state = "done_loading_dlcs"
			Boot.disable_loading_bar = true
		end
	elseif Boot.startup_state == "done_loading_dlcs" then
		DLCUtils.require_list("additional_settings")
		DLCUtils.merge("script_data", script_data)
		Game:require_game_scripts()

		if not (not IS_WINDOWS and LAUNCH_MODE == "attract_benchmark") then
			Boot.startup_state = "init_mods"
		elseif not IS_LINUX then
			Managers.mod = MockClass:new()
			Boot.startup_state = "ready"
		else
			Boot.startup_state = "ready"
		end
	elseif Boot.startup_state == "init_mods" then
		Managers.curl = CurlManager:new()

		fn_3("managers", "mod/mod_manager")

		Managers.mod = ModManager:new(Boot.gui)
		Boot.startup_state = "loading_mods"
	elseif Boot.startup_state == "loading_mods" then
		Managers.curl:update(true)
		Managers.mod:update(arg_14_1)

		if not Managers.mod:all_mods_loaded() then
			Managers.mod:remove_gui()

			Boot.startup_state = "ready"
		end
	elseif Boot.startup_state == "ready" then
		local scripts_settings_crashify_settings = require("scripts/settings/crashify_settings")

		Crashify.print_property("project", scripts_settings_crashify_settings.project)
		Crashify.print_property("project_branch", scripts_settings_crashify_settings.branch)
		Crashify.print_property("build", BUILD)
		Crashify.print_property("platform", PLATFORM)
		Crashify.print_property("dedicated_server", DEDICATED_SERVER)
		Crashify.print_property("title_id", GameSettingsDevelopment.backend_settings.title_id)

		local print_property = Crashify.print_property
		local str = "content_revision"
		local parameter

		if script_data.settings.content_revision == "" then
			parameter = Development.parameter("content_revision")

			if not parameter then
				-- Nothing
			end
		end

		parameter = script_data.settings.content_revision

		::label_14_0::

		print_property(str, parameter)

		local print_property_2 = Crashify.print_property
		local str_2 = "engine_revision"
		local build_identifier = script_data.build_identifier

		build_identifier = build_identifier or Development.parameter("engine_revision")

		print_property_2(str_2, build_identifier)
		Crashify.print_property("release_version", VersionSettings.version)
		Crashify.print_property("rendering_backend", Renderer.render_device_string())
		Crashify.print_property("teamcity_build_id", script_data.settings.teamcity_build_id)

		if not script_data.testify then
			Crashify.print_property("testify", true)
		end

		if IS_WINDOWS or not IS_LINUX then
			if not rawget(_G, "Steam") then
				Crashify.print_property("steam_id", Steam.user_id())
				Crashify.print_property("steam_profile_name", Steam.user_name())
				Crashify.print_property("steam_app_id", Steam.app_id())

				if not Application.user_setting("write_network_debug_output_to_log") then
					print("Network.write_debug_output_to_log(true)")

					local num = 17
					local num_2 = 7

					Network.set_config_value(num, num_2)
					Network.write_debug_output_to_log(true)
				end
			end

			Crashify.print_property("machine_id", Application.machine_id())
		elseif not IS_PS4 then
			Crashify.print_property("machine_id", Application.machine_id())

			local str_3 = "ps4"

			if not PS4.is_ps5() then
				str_3 = "ps5"
			elseif not PS4.is_pro() then
				str_3 = "ps4_pro"
			end

			Crashify.print_property("console_type", str_3)
		elseif not IS_XB1 then
			Crashify.print_property("console_type", XboxOne.console_type_string())
		end

		local clock_3 = os.clock()

		FrameTable.init()

		local clock_4 = os.clock()
		local clock_5 = os.clock()

		self:_init_managers()

		local clock_6 = os.clock()
		local clock_7 = os.clock()

		Game:setup()

		local select_starting_state, var_14_24 = Game:select_starting_state()
		local IS_WINDOWS = IS_WINDOWS

		IS_WINDOWS = not IS_WINDOWS and LAUNCH_MODE ~= "attract_benchmark"
		var_14_24.notify_mod_manager = IS_WINDOWS

		local clock_8 = os.clock()
		local clock_9 = os.clock()

		self:_setup_statemachine(select_starting_state, var_14_24)

		local clock_10 = os.clock()
		local clock_11 = os.clock()

		Testify:ready()

		Boot.render = Boot.game_render
		Boot.has_booted = true

		destroy_startup_world()

		return true
	end

	update_startup_world(arg_14_1)

	return false
end

Boot.booting_render = function (arg_15_0)
	-- function 15
	render_startup_world()
end

Boot._require_foundation_scripts = function (arg_16_0)
	-- function 16
	fn("util", "verify_plugins", "error", "patches", "class", "callback", "rectangle", "state_machine", "visual_state_machine", "misc_util", "stack", "circular_queue", "grow_queue", "table", "testify", "math", "vector3", "quaternion", "script_world", "script_viewport", "script_camera", "script_unit", "frame_table", "path", "string", "reportify")
	fn("debug", "table_trap")
	fn("managers", "world/world_manager", "player/player", "free_flight/free_flight_manager", "state/state_machine_manager", "time/time_manager", "token/token_manager")
	fn("managers", "localization/localization_manager", "event/event_manager")
end

Boot._init_managers = function (arg_17_0)
	-- function 17
	Managers.time = TimeManager:new()
	Managers.world = WorldManager:new()
	Managers.token = TokenManager:new()
	Managers.state_machine = StateMachineManager:new()
	Managers.url_loader = UrlLoaderManager:new()
end

Boot.game_render = function (self)
	-- function 18
	if not self._machine.pre_render then
		self._machine:pre_render()
	end

	Managers.world:render()
	self._machine:render()

	if not self._machine.post_render then
		self._machine:post_render()
	end

	Managers.url_loader:post_render()
end

Boot._setup_statemachine = function (self, arg_19_1, arg_19_2)
	-- function 19
	self._machine = GameStateMachine:new(self, arg_19_1, arg_19_2, true)
end

Boot.on_close = function (self)
	-- function 20
	print("[Boot] on_close")

	if not self._machine and not self._machine.on_close then
		return self._machine:on_close()
	end

	return true
end

function init()
	-- function 21
	Boot:setup()
end

function update(arg_22_0)
	-- function 22
	if not Boot.has_booted then
		Boot:game_update(arg_22_0)
	elseif not Boot:booting_update(arg_22_0) then
		Boot:game_update(arg_22_0)
	end
end

function render()
	-- function 23
	Boot:render()
end

function on_close()
	-- function 24
	local on_close = Boot:on_close()

	if not on_close then
		Application.force_silent_exit_policy()
		Crashify.print_property("shutdown", true)
	end

	return on_close
end

function shutdown()
	-- function 25
	Application.force_silent_exit_policy()
	Crashify.print_property("shutdown", true)
	Boot:shutdown()
end

function create_startup_world()
	-- function 26
	assert(not Boot.world)

	Boot.world = Application.new_world("boot_world", Application.DISABLE_PHYSICS, Application.DISABLE_SOUND, Application.DISABLE_APEX_CLOTH)
	Boot.shading_env = World.create_shading_environment(Boot.world, "environment/blank")
	Boot.viewport = Application.create_viewport(Boot.world, "overlay")

	local spawn_unit = World.spawn_unit(Boot.world, "core/units/camera")
	local camera = Unit.camera(spawn_unit, "camera")

	Camera.set_data(camera, "unit", spawn_unit)
	Viewport.set_data(Boot.viewport, "camera", camera)

	Boot.gui = World.create_screen_gui(Boot.world, "immediate")
	Boot.bar_timer = 0
end

function update_startup_world(arg_27_0)
	-- function 27
	local resolution, var_27_1 = Application.resolution()

	Gui.rect(Boot.gui, Vector3(0, 0, 0), Vector2(resolution, var_27_1), Color(255, 0, 0, 0))

	if not (not IS_CONSOLE and Boot.disable_loading_bar) then
		local function fn(arg_28_0, arg_28_1, arg_28_2)
			-- function 28
			if arg_28_2 < arg_28_0 then
				return arg_28_2
			elseif arg_28_0 < arg_28_1 then
				return arg_28_1
			else
				return arg_28_0
			end
		end

		Boot.bar_timer = (Boot.bar_timer + arg_27_0) % 2

		local resolution_2, var_27_4 = Gui.resolution()
		local num = resolution_2 / 1920
		local var_27_6 = Vector2(120 * num, 13 * num)
		local num_2 = 1 * num
		local var_27_8 = fn(Boot.bar_timer, 0, 1)
		local num_3 = var_27_8 * var_27_8 * var_27_8
		local var_27_10 = fn(2 - Boot.bar_timer, 0, 1)

		Gui.rect(Boot.gui, Vector3(resolution_2 - 200 * num, 50 * num, 900), var_27_6)
		Gui.rect(Boot.gui, Vector3(resolution_2 - 200 * num + num_2, 50 * num + num_2, 901), Vector2(var_27_6[1] - num_2 * 2, var_27_6[2] - num_2 * 2), Color(0, 0, 0))
		Gui.rect(Boot.gui, Vector3(resolution_2 - 200 * num + num_2 * 3, 50 * num + num_2 * 4, 902), Vector2((var_27_6[1] - num_2 * 6) * num_3, var_27_6[2] - num_2 * 8), Color(var_27_10 * 255, 255, 255, 255))
	end

	World.update_scene(Boot.world, arg_27_0)
end

function render_startup_world()
	-- function 29
	local world = Boot.world
	local shading_env = Boot.shading_env
	local viewport = Boot.viewport
	local get_data = Viewport.get_data(Boot.viewport, "camera")

	Application.render_world(world, get_data, viewport, shading_env)
end

function destroy_startup_world()
	-- function 30
	assert(Boot.world)
	Application.release_world(Boot.world)

	Boot.world = nil
	Boot.viewport = nil
	Boot.shading_env = nil
	Boot.gui = nil
end

local ReplayBoot = ReplayBoot

ReplayBoot = ReplayBoot or {}
ReplayBoot = ReplayBoot

ReplayBoot.init = function (self)
	-- function 31
	self._packages = {}

	for i, v in ipairs(ExtendedReplay.packages_to_load()) do
		print("Loading package " .. v)

		local resource_package = Application.resource_package(v)

		resource_package:load()
		resource_package:flush()
		table.insert(self._packages, resource_package)
	end

	fn("util", "verify_plugins", "error", "framerate", "patches", "class", "callback", "rectangle", "misc_util", "stack", "circular_queue", "grow_queue", "table", "math", "vector3", "quaternion", "frame_table", "path", "script_extended_replay")
	fn("managers", "managers", "replay/replay_manager")
	Framerate.set_replay()

	self._world = Application.new_world("replay")

	ExtendedReplay.set_world(self._world)

	Managers.replay = ReplayManager:new(self._world)
end

ReplayBoot.update = function (self, arg_32_1)
	-- function 32
	arg_32_1 = Managers.replay:update(arg_32_1)

	World.update(self._world, arg_32_1)
end

ReplayBoot.render = function (self)
	-- function 33
	local render_objects = ExtendedReplay.render_objects()

	if not render_objects then
		local overriding_camera = Managers.replay:overriding_camera()

		overriding_camera = overriding_camera or render_objects.camera

		Application.render_world(self._world, overriding_camera, render_objects.viewport, render_objects.shading_environment)
	end
end

ReplayBoot.shutdown = function (self)
	-- function 34
	Managers:destroy()
	Application.release_world(self._world)

	for i, v in ipairs(self._packages) do
		v:unload()
		Application.release_resource_package(v)
	end
end

function replay_init()
	-- function 35
	ReplayBoot:init()
end

function replay_update(arg_36_0)
	-- function 36
	ReplayBoot:update(arg_36_0)
end

function replay_render()
	-- function 37
	ReplayBoot:render()
end

function replay_shutdown()
	-- function 38
	ReplayBoot:shutdown()
end

function force_render(arg_39_0)
	-- function 39
	if not Managers.transition then
		Managers.transition:force_render(arg_39_0)
	end

	render()
end

local tbl_2 = {}

Boot.game_update = function (self, arg_40_1)
	-- function 40
	local Managers = Managers
	local scaled_delta_time = Managers.time:scaled_delta_time(arg_40_1)

	if not Managers.mod then
		Managers.mod:update(scaled_delta_time)
	end

	UPDATE_RESOLUTION_LOOKUP()
	Managers.perfhud:update(scaled_delta_time)
	Managers.updator:update(scaled_delta_time)

	GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX + 1

	Managers.time:update(scaled_delta_time)

	local time = Managers.time:time("main")

	for k, v in pairs(DLCSettings) do
		local manager_settings = v.manager_settings

		manager_settings = manager_settings or tbl_2

		for k_2, v_2 in pairs(manager_settings) do
			if not v_2.pre_update then
				Managers[k_2].pre_update(Managers[k_2], scaled_delta_time, time)
			end
		end
	end

	self._machine:pre_update(scaled_delta_time, time)
	Managers.package:update(scaled_delta_time, time)
	Managers.token:update(scaled_delta_time, time)

	for k_3, v_3 in pairs(DLCSettings) do
		local manager_settings_2 = v_3.manager_settings

		manager_settings_2 = manager_settings_2 or tbl_2

		for k_4, v_4 in pairs(manager_settings_2) do
			if not v_4.update then
				Managers[k_4].update(Managers[k_4], scaled_delta_time, time)
			end
		end
	end

	self._machine:update(scaled_delta_time, time)
	Managers.state_machine:update(scaled_delta_time)
	Managers.world:update(scaled_delta_time, time)
	Managers.url_loader:update(scaled_delta_time)

	if not LEVEL_EDITOR_TEST and not Keyboard.pressed(Keyboard.button_index("f5")) then
		Application.console_send({
			type = "stop_testing"
		})
	end

	if not IS_WINDOWS then
		Managers.curl:update(true)
		Managers.irc:update(scaled_delta_time)
		Managers.twitch:update(scaled_delta_time, time)

		if not rawget(_G, "Steam") then
			Managers.steam:update(time, scaled_delta_time)
		end
	elseif not IS_XB1 then
		Managers.rest_transport:update(true, scaled_delta_time, time)

		if not GameSettingsDevelopment.twitch_enabled then
			Managers.twitch:update(scaled_delta_time)
			Managers.irc:update(scaled_delta_time)
		end
	elseif not IS_PS4 then
		Managers.rest_transport:update(true, scaled_delta_time, time)
		Managers.irc:update(scaled_delta_time)
		Managers.twitch:update(scaled_delta_time)
		Managers.system_dialog:update(scaled_delta_time)
	elseif not IS_LINUX then
		Managers.curl:update(true)
		Managers.irc:update(scaled_delta_time)
		Managers.twitch:update(scaled_delta_time)
	end

	Managers.weave:update(scaled_delta_time, time)
	Managers.news_ticker:update(scaled_delta_time)
	Managers.transition:update(scaled_delta_time)
	Managers.load_time:update(scaled_delta_time)

	if not Managers.splitscreen then
		Managers.splitscreen:update(scaled_delta_time)
	end

	Managers.telemetry_reporters:update(scaled_delta_time, time)
	Managers.telemetry:update(scaled_delta_time, time)
	Managers.invite:update(scaled_delta_time, time)
	Managers.admin:update(scaled_delta_time)

	if not Managers.ping then
		Managers.ping:update(scaled_delta_time, time)
	end

	if not Managers.account then
		Managers.account:update(scaled_delta_time)
	end

	if not Managers.light_fx then
		Managers.light_fx:update(scaled_delta_time)
	end

	if not Managers.razer_chroma then
		Managers.razer_chroma:update(scaled_delta_time)
	end

	if not Managers.unlock then
		Managers.unlock:update(scaled_delta_time, time)
	end

	if not Managers.popup then
		Managers.simple_popup:update(scaled_delta_time)
		Managers.popup:update(scaled_delta_time)
	end

	if not Managers.beta_overlay then
		Managers.beta_overlay:update(scaled_delta_time)
	end

	Managers.play_go:update(scaled_delta_time)

	if not IS_XB1 then
		Managers.xbox_events:update(scaled_delta_time)

		if Managers.xbox_stats ~= nil then
			Managers.xbox_stats:update()
		end
	end

	if not script_data.testify then
		Managers.mechanism:update_testify(scaled_delta_time, time)

		if not Managers.state.side then
			Managers.state.side:update_testify(scaled_delta_time, time)
		end
	end

	Testify:update(scaled_delta_time, time)
	end_function_call_collection()
	table.clear(Boot.flow_return_table)

	for k_5, v_5 in pairs(DLCSettings) do
		local manager_settings_3 = v_5.manager_settings

		manager_settings_3 = manager_settings_3 or tbl_2

		for k_6, v_6 in pairs(manager_settings_3) do
			if not v_6.post_update then
				Managers[k_6].post_update(Managers[k_6], scaled_delta_time, time)
			end
		end
	end

	self._machine:post_update(scaled_delta_time)
	FrameTable.swap_and_clear()

	if not self.quit_game then
		local function fn(arg_41_0)
			-- function 41
			Boot.is_controlled_exit = true

			ShowCursorStack.dump()
			Application.quit()
		end

		if not self._saving then
			Managers.save:auto_save(SaveFileName, SaveData, fn)

			self._saving = true
		end
	end
end

Boot.shutdown = function (self, arg_42_1)
	-- function 42
	print("[Boot] shutdown")

	if not self._machine then
		self._machine:destroy(true)
	end

	if not Managers then
		Managers:destroy()
	end

	if not Boot.world then
		destroy_startup_world()
	end

	for k, v in pairs(Boot.startup_package_handles) do
		if not ResourcePackage.has_loaded(v) then
			ResourcePackage.unload(v)
			Application.release_resource_package(v)
		end
	end

	if not GLOBAL_MUSIC_WORLD then
		Application.release_world(MUSIC_WORLD)
	end
end

local Game = Game

Game = Game or {}
Game = Game

Game.setup = function (self)
	-- function 43
	local var_43_0 = fn_5("Game:setup()")
	local flag = BUILD == "dev" or BUILD == "debug"

	if not IS_XB1 then
		Application.set_kinect_enabled(true)
	end

	if not script_data.honduras_demo then
		self:_demo_setup()
	end

	local var_43_2

	if not IS_WINDOWS then
		if not Application.is_dedicated_server() then
			fn_6(var_43_0, "handle gfx quality")
			self:_handle_win32_graphics_quality()
			fn_6(var_43_0, "handle gfx quality")
		end

		if not rawget(_G, "Steam") then
			print("[Boot] User ID:", Steam.user_id(), Steam.user_name())
		end

		fn_6(var_43_0, "default settings")
		DefaultUserSettings.set_default_user_settings()
		fn_6(var_43_0, "default settings")
		fn_6(var_43_0, "user settings")
		self:_load_win32_user_settings()
		fn_6(var_43_0, "user settings")
		self:_init_mouse()

		if not flag then
			Window.set_resizable(true)
		else
			Window.set_resizable(false)
		end
	else
		fn_6(var_43_0, "default settings")
		DefaultUserSettings.set_default_user_settings()
		fn_6(var_43_0, "default settings")

		if not IS_PS4 then
			self:_set_ps4_content_restrictions()
		end
	end

	fn_6(var_43_0, "set frame times")
	Framerate.set_playing()
	fn_6(var_43_0, "set frame times")

	if not Development.parameter("network_log_spew") then
		Network.log("spew")
	elseif not Development.parameter("network_log_messages") then
		Network.log("messages")
	elseif not Development.parameter("network_log_messages") then
		Network.log("info")
	end

	if not GameSettingsDevelopment.remove_debug_stuff then
		fn_6(var_43_0, "remove debug stuff")
		DebugHelper.remove_debug_stuff()
		fn_6(var_43_0, "remove debug stuff")
	end

	if not script_data.settings.physics_dump then
		fn_6(var_43_0, "physics_dump")
		DebugHelper.enable_physics_dump()
		fn_6(var_43_0, "physics_dump")
	end

	for k, v in pairs(DLCSettings) do
		local ingame_package_name = v.ingame_package_name

		if not ingame_package_name then
			GlobalResources[#GlobalResources + 1] = ingame_package_name
		end
	end

	fn_6(var_43_0, "init random")
	self:_init_random()
	fn_6(var_43_0, "init random")
	fn_6(var_43_0, "managers")
	self:_init_managers()
	fn_6(var_43_0, "managers")
	fn_7(var_43_0)
end

Game._set_ps4_content_restrictions = function (arg_44_0)
	-- function 44
	local tbl = {
		{
			country = "at",
			age = 18
		},
		{
			country = "bh",
			age = 18
		},
		{
			country = "be",
			age = 18
		},
		{
			country = "bg",
			age = 18
		},
		{
			country = "hr",
			age = 18
		},
		{
			country = "cy",
			age = 18
		},
		{
			country = "cz",
			age = 18
		},
		{
			country = "dk",
			age = 18
		},
		{
			country = "fi",
			age = 18
		},
		{
			country = "fr",
			age = 18
		},
		{
			country = "gr",
			age = 18
		},
		{
			country = "hu",
			age = 18
		},
		{
			country = "is",
			age = 18
		},
		{
			country = "in",
			age = 18
		},
		{
			country = "ie",
			age = 18
		},
		{
			country = "il",
			age = 18
		},
		{
			country = "it",
			age = 18
		},
		{
			country = "kw",
			age = 18
		},
		{
			country = "lb",
			age = 18
		},
		{
			country = "lu",
			age = 18
		},
		{
			country = "mt",
			age = 18
		},
		{
			country = "nl",
			age = 18
		},
		{
			country = "no",
			age = 18
		},
		{
			country = "om",
			age = 18
		},
		{
			country = "pl",
			age = 18
		},
		{
			country = "pt",
			age = 18
		},
		{
			country = "qa",
			age = 18
		},
		{
			country = "ro",
			age = 18
		},
		{
			country = "sa",
			age = 18
		},
		{
			country = "sk",
			age = 18
		},
		{
			country = "si",
			age = 18
		},
		{
			country = "za",
			age = 18
		},
		{
			country = "es",
			age = 18
		},
		{
			country = "se",
			age = 18
		},
		{
			country = "ch",
			age = 18
		},
		{
			country = "tr",
			age = 18
		},
		{
			country = "ua",
			age = 18
		},
		{
			country = "ae",
			age = 18
		},
		{
			country = "gb",
			age = 18
		},
		{
			country = "de",
			age = 18
		},
		{
			country = "ar",
			age = 17
		},
		{
			country = "bo",
			age = 17
		},
		{
			country = "br",
			age = 17
		},
		{
			country = "ca",
			age = 17
		},
		{
			country = "cl",
			age = 17
		},
		{
			country = "co",
			age = 17
		},
		{
			country = "cr",
			age = 17
		},
		{
			country = "ec",
			age = 17
		},
		{
			country = "sv",
			age = 17
		},
		{
			country = "gt",
			age = 17
		},
		{
			country = "hn",
			age = 17
		},
		{
			country = "mx",
			age = 17
		},
		{
			country = "ni",
			age = 17
		},
		{
			country = "pa",
			age = 17
		},
		{
			country = "py",
			age = 17
		},
		{
			country = "pe",
			age = 17
		},
		{
			country = "us",
			age = 17
		},
		{
			country = "uy",
			age = 17
		},
		{
			country = "au",
			age = 15
		},
		{
			country = "nz",
			age = 16
		},
		{
			country = "tw",
			age = 15
		},
		{
			country = "ru",
			age = 18
		}
	}

	NpCheck.set_content_restriction(18, tbl)
end

Game.require_game_scripts = function (self)
	-- function 45
	fn_3("utils", "patches", "colors", "framerate", "global_utils", "function_call_stats", "loaded_dice", "deadlock_stack", "benchmark/benchmark_handler")
	fn_3("settings", "version_settings")
	fn_3("ui", "views/show_cursor_stack", "ui_fonts")
	fn_3("settings", "demo_settings", "motion_control_settings", "game_settings_development", "controller_settings", "default_user_settings")
	fn_3("entity_system", "entity_system")
	fn_3("game_state", "game_state_machine", "state_context", "state_splash_screen", "state_loading", "state_ingame", "state_demo_end")
	require("scripts/managers/network/lobby_setup")
	fn_3("managers", "admin/admin_manager", "news_ticker/news_ticker_manager", "player/player_manager", "player/player_bot", "save/save_manager", "save/save_data", "perfhud/perfhud_manager", "music/music_manager", "network/party_manager", "network/lobby_manager", "transition/transition_manager", "debug/updator", "invite/invite_manager", "unlock/unlock_manager", "popup/popup_manager", "popup/simple_popup", "light_fx/light_fx_manager", "razer_chroma/razer_chroma_manager", "play_go/play_go_manager", "controller_features/controller_features_manager", "deed/deed_manager", "boon/boon_manager", "telemetry/telemetry_manager", "telemetry/telemetry_events", "telemetry/telemetry_reporters", "load_time/load_time_manager", "game_mode/game_mechanism_manager", "ui/ui_manager", "weave/weave_manager")

	if not IS_WINDOWS then
		fn_3("managers", "irc/irc_manager", "curl/curl_manager", "curl/curl_token", "ping/ping_manager", "twitch/twitch_manager")

		if not rawget(_G, "Steam") then
			fn_3("managers", "steam/steam_manager")
		end
	elseif not IS_XB1 then
		fn_3("managers", "events/xbox_event_manager", "rest_transport/rest_transport_manager", "twitch/twitch_manager", "irc/irc_manager")
	elseif not IS_PS4 then
		fn_3("managers", "irc/irc_manager", "twitch/twitch_manager", "rest_transport/rest_transport_manager", "system_dialog/system_dialog_manager")
	elseif not IS_LINUX then
		fn_3("managers", "irc/irc_manager", "curl/curl_manager", "curl/curl_token", "twitch/twitch_manager", "ping/ping_manager")
	end

	fn_3("helpers", "effect_helper", "weapon_helper", "item_helper", "lorebook_helper", "ui_atlas_helper", "scoreboard_helper")
	fn_3("network", "unit_spawner", "unit_storage", "network_unit")
	self:_init_localization_manager()
	require("scripts/ui/views/ingame_ui")
	require("scripts/ui/views/level_end/level_end_view_wrapper")
	require("scripts/ui/views/title_loading_ui")
	require("scripts/network_lookup/network_lookup")
	require("scripts/tests/test_cases")
end

Game._handle_win32_graphics_quality = function (arg_46_0)
	-- function 46
	local var_46_0 = fn_5("Game:_handle_win32_graphics_quality()")
	local user_setting = Application.user_setting("graphics_quality")
	local flag = false

	if not Application.render_caps("reflex_supported") then
		local user_setting_2 = Application.user_setting("max_fps")

		user_setting_2 = user_setting_2 or 0

		if user_setting_2 > 0 then
			print("[Boot] Migrating from max_fps to nv_framerate_cap. Value:", user_setting_2)
			Application.set_user_setting("render_settings", "nv_framerate_cap", user_setting_2)
			Application.set_user_setting("max_fps", 0)

			flag = true
		end
	else
		local user_setting_3 = Application.user_setting("render_settings", "nv_framerate_cap")

		user_setting_3 = user_setting_3 or 0

		if user_setting_3 > 0 then
			print("[Boot] Migrating from nv_framerate_cap to max_fps. Value:", user_setting_3)
			Application.set_user_setting("max_fps", user_setting_3)
			Application.set_user_setting("render_settings", "nv_framerate_cap", 0)

			flag = true
		end
	end

	local user_setting_4 = Application.user_setting("render_settings", "upscaling_mode")

	user_setting_4 = user_setting_4 or "none"

	if user_setting_4 ~= "none" then
		if not Application.user_setting("render_settings", "fsr_enabled") then
			print("[Boot] Disabling fsr1 because another upscaler was enabled.")
			Application.set_render_setting("fsr_enabled", "false")

			flag = true
		end

		if user_setting_4 == "fsr2" then
			if not Application.render_caps("d3d12") then
				print("[Boot] Disabling fsr2 because d3d12 was false.")
				Application.set_user_setting("fsr2_enabled", false)
				Application.set_render_setting("upscaling_enabled", "false")
				Application.set_render_setting("upscaling_mode", "none")
				Application.set_render_setting("upscaling_quality", "none")

				flag = true
			end
		elseif not (user_setting_4 ~= "dlss" or Application.render_caps("dlss_supported")) then
			print("[Boot] Disabling dlss because dlss_supported was false.")
			Application.set_render_setting("upscaling_enabled", "false")
			Application.set_render_setting("upscaling_mode", "none")
			Application.set_render_setting("upscaling_quality", "none")

			flag = true
		end
	end

	if not (not Application.user_setting("render_settings", "dlss_g_enabled") and Application.render_caps("dlss_g_supported")) then
		print("[Boot] Disabling dlss_g due because dlss_g_supported was false.")
		Application.set_render_setting("dlss_g_enabled", "false")
		Application.set_user_setting("overriden_settings", "dlss_frame_generation", true)

		flag = true
	end

	if not (not Application.user_setting("dlss_enabled") and Application.render_caps("dlss_supported")) then
		print("[Boot] Disabling dlss_enabled because dlss_supported was false.")
		Application.set_user_setting("dlss_enabled", false)
	end

	local function fn(self, arg_47_1)
		-- function 47
		if self == arg_47_1 then
			return true
		elseif not (type(self) ~= "table" or type(arg_47_1) ~= "table") then
			for k, v in pairs(self) do
				if arg_47_1[k] ~= v then
					return false
				end
			end

			for k_2, v_2 in pairs(arg_47_1) do
				if self[k_2] ~= v_2 then
					return false
				end
			end

			return true
		else
			return false
		end
	end

	local function fn_2(arg_48_0, arg_48_1, arg_48_2)
		-- function 48
		if arg_48_2 ~= nil then
			local user_setting = Application.user_setting(arg_48_0, arg_48_1)

			if not fn(user_setting, arg_48_2) then
				Application.set_user_setting(arg_48_0, arg_48_1, arg_48_2)
				print("Diff in user_setting:", arg_48_0, arg_48_1, user_setting, arg_48_2)

				flag = true
			end
		else
			arg_48_2 = arg_48_1
			arg_48_1 = arg_48_0

			local user_setting_2 = Application.user_setting(arg_48_1)

			if not fn(user_setting_2, arg_48_2) then
				Application.set_user_setting(arg_48_1, arg_48_2)
				print("Diff in user_setting:", arg_48_1, user_setting_2, arg_48_2)

				flag = true
			end
		end
	end

	if user_setting == nil then
		user_setting = script_data.settings.default_graphics_quality or "medium"

		Application.set_user_setting("graphics_quality", user_setting)
	end

	local var_46_8 = GraphicsQuality[user_setting]

	if not ((LEVEL_EDITOR_TEST or not var_46_8) and var_46_8.is_custom) then
		local user_settings = var_46_8.user_settings

		for k, v in pairs(user_settings) do
			if k == "char_texture_quality" then
				local var_46_10 = TextureQuality.characters[v]

				for i, v_2 in ipairs(var_46_10) do
					fn_2("texture_settings", v_2.texture_setting, v_2.mip_level)
				end
			elseif k == "env_texture_quality" then
				local var_46_11 = TextureQuality.environment[v]

				for i_2, v_3 in ipairs(var_46_11) do
					fn_2("texture_settings", v_3.texture_setting, v_3.mip_level)
				end
			elseif k == "local_light_shadow_quality" then
				local var_46_12 = LocalLightShadowQuality[v]

				for k_2, v_4 in pairs(var_46_12) do
					fn_2("render_settings", k_2, v_4)
				end
			elseif k == "particles_quality" then
				local var_46_13 = ParticlesQuality[v]

				for k_3, v_5 in pairs(var_46_13) do
					Application.set_user_setting("render_settings", k_3, v_5)
				end
			elseif k == "sun_shadow_quality" then
				local var_46_14 = SunShadowQuality[v]

				for k_4, v_6 in pairs(var_46_14) do
					fn_2("render_settings", k_4, v_6)
				end
			elseif k == "volumetric_fog_quality" then
				local var_46_15 = VolumetricFogQuality[v]

				for k_5, v_7 in pairs(var_46_15) do
					fn_2("render_settings", k_5, v_7)
				end
			elseif k == "ambient_light_quality" then
				local var_46_16 = AmbientLightQuality[v]

				for k_6, v_8 in pairs(var_46_16) do
					fn_2("render_settings", k_6, v_8)
				end
			elseif k == "ao_quality" then
				local var_46_17 = AmbientOcclusionQuality[v]

				for k_7, v_9 in pairs(var_46_17) do
					fn_2("render_settings", k_7, v_9)
				end
			end

			fn_2(k, v)
		end

		local render_settings = var_46_8.render_settings

		for k_8, v_10 in pairs(render_settings) do
			fn_2("render_settings", k_8, v_10)
		end
	end

	if not flag then
		fn_6(var_46_0, "apply")
		Application.apply_user_settings()
		GlobalShaderFlags.apply_settings()
		fn_6(var_46_0, "apply")
	end

	fn_6(var_46_0, "save")
	Application.save_user_settings()
	fn_6(var_46_0, "save")
	fn_7(var_46_0)
end

Game._init_random = function (arg_49_0)
	-- function 49
	local num = os.clock() * 10000 % 1000

	math.randomseed(num)
	math.random(5, 30000)
end

Game._init_mouse = function (arg_50_0)
	-- function 50
	Window.set_cursor("gui/cursors/mouse_cursor")
	Window.set_clip_cursor(true)
end

Game._init_managers = function (self)
	-- function 51
	parse_item_master_list()

	Managers.persistent_event = EventManager:new()
	Managers.save = SaveManager:new(script_data.settings.disable_cloud_save)

	if not IS_XB1 then
		self:_init_backend_xbox()
	elseif not IS_PS4 then
		self:_init_backend_ps4()
	else
		self:_init_backend()
	end

	Managers.admin = AdminManager:new()
	Managers.perfhud = PerfhudManager:new()
	Managers.updator = Updator:new()
	Managers.music = MusicManager:new()
	Managers.transition = TransitionManager:new()
	Managers.play_go = PlayGoManager:new()

	local Managers = Managers
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and PingManager:new()
	Managers.ping = IS_WINDOWS

	if not IS_WINDOWS then
		Managers.irc = IRCManager:new()

		if not Managers.curl then
			Managers.curl = CurlManager:new()
		end

		Managers.twitch = TwitchManager:new()
		Managers.unlock = UnlockManager:new()

		if not rawget(_G, "Steam") then
			Managers.steam = SteamManager:new()
		end
	elseif not IS_XB1 then
		Managers.xbox_events = XboxEventManager:new()
		Managers.rest_transport_online = RestTransportManager:new()
		Managers.rest_transport = Managers.rest_transport_online

		if not GameSettingsDevelopment.twitch_enabled then
			Managers.twitch = TwitchManager:new()
			Managers.irc = IRCManager:new()
		end
	elseif not IS_PS4 then
		Managers.rest_transport_online = RestTransportManager:new()
		Managers.rest_transport = Managers.rest_transport_online
		Managers.system_dialog = SystemDialogManager:new()
		Managers.irc = IRCManager:new()
		Managers.twitch = TwitchManager:new()
	elseif not IS_LINUX then
		Managers.irc = IRCManager:new()

		if not Managers.curl then
			Managers.curl = CurlManager:new()
		end

		Managers.twitch = TwitchManager:new()
		Managers.unlock = UnlockManager:new()
	end

	Managers.ui = UIManager:new()
	Managers.weave = WeaveManager:new()
	Managers.telemetry = TelemetryManager.create()
	Managers.telemetry_events = TelemetryEvents:new(Managers.telemetry)
	Managers.telemetry_reporters = TelemetryReporters:new()
	Managers.player = PlayerManager:new()
	Managers.free_flight = FreeFlightManager:new()
	Managers.invite = InviteManager:new()
	Managers.news_ticker = NewsTickerManager:new()
	Managers.light_fx = LightFXManager:new()
	Managers.razer_chroma = RazerChromaManager:new()
	Managers.party = PartyManager:new()
	Managers.deed = DeedManager:new()
	Managers.boon = BoonManager:new()
	Managers.load_time = LoadTimeManager:new()
	Managers.level_transition_handler = LevelTransitionHandler:new()
	Managers.mechanism = GameMechanismManager:new()
	Managers.lobby = LobbyManager:new()

	if GameSettingsDevelopment.use_leaderboards or not Development.parameter("use_leaderboards") then
		Managers.leaderboards = LeaderboardManager:new()
	end

	local tbl = {}

	for k, v in pairs(DLCSettings) do
		local manager_settings = v.manager_settings

		manager_settings = manager_settings or tbl

		for k_2, v_2 in pairs(manager_settings) do
			Managers[k_2] = rawget(_G, v_2.klass):new()
		end
	end
end

Game._init_backend = function (arg_52_0)
	-- function 52
	local var_52_0
	local var_52_1
	local str

	if not DEDICATED_SERVER then
		var_52_0 = "ScriptBackendPlayFabDedicated"
		str = "PlayFabMirrorDedicated"
	else
		local parameter = Development.parameter("mechanism")

		parameter = parameter or "adventure"

		local var_52_4 = MechanismSettings[parameter]

		var_52_0 = "ScriptBackendPlayFab"

		local flag = not var_52_4 and var_52_4.playfab_mirror

		str = not flag and flag and "PlayFabMirrorAdventure"
	end

	Managers.backend = BackendManagerPlayFab:new(var_52_0, str, "DataServerQueue")
end

Game._init_backend_xbox = function (arg_53_0)
	-- function 53
	local str = "ScriptBackendPlayFabXbox"
	local parameter = Development.parameter("mechanism")

	parameter = parameter or "adventure"

	local var_53_2 = MechanismSettings[parameter]
	local flag = not var_53_2 and var_53_2.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.backend = BackendManagerPlayFab:new(str, flag, "DataServerQueue")
end

Game._init_backend_ps4 = function (arg_54_0)
	-- function 54
	local str = "ScriptBackendPlayFabPS4"
	local parameter = Development.parameter("mechanism")

	parameter = parameter or "adventure"

	local var_54_2 = MechanismSettings[parameter]
	local flag = not var_54_2 and var_54_2.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.backend = BackendManagerPlayFab:new(str, flag, "DataServerQueue")
end

Game._load_win32_user_settings = function (arg_55_0)
	-- function 55
	local win32_user_setting = Application.win32_user_setting("max_stacking_frames")

	if not win32_user_setting then
		Application.set_max_frame_stacking(win32_user_setting)
	end
end

Game._demo_setup = function (arg_56_0)
	-- function 56
	Application.save_user_settings = function ()
		-- function 57
		return
	end

	local key_combinations_allowed = DemoSettings.key_combinations_allowed

	for k, v in pairs(key_combinations_allowed) do
		Window.set_keystroke_enabled(k, v)
	end

	Managers.package:load("resource_packages/demo", "boot")
end

Game._init_localization_manager = function (arg_58_0)
	-- function 58
	Managers.localizer = LocalizationManager:new()

	local function fn(arg_59_0)
		-- function 59
		local var_59_0 = LocalizerTweakData[arg_59_0]

		var_59_0 = var_59_0 or "<missing LocalizerTweakData \"" .. arg_59_0 .. "\">"

		return var_59_0
	end

	Managers.localizer:add_macro("TWEAK", fn)

	local function fn_2(arg_60_0)
		-- function 60
		local find, var_60_1 = string.find(arg_60_0, "__")

		assert(not find and var_60_1, "[key_parser] You need to specify a key using this format $KEY;<input_service>__<key>. Example: $KEY;options_menu__back (note the dubbel underline separating input service and key")

		local sub = string.sub(arg_60_0, 1, find - 1)
		local sub_2 = string.sub(arg_60_0, var_60_1 + 1)
		local get_service = Managers.input:get_service(sub)

		fassert(get_service, "[key_parser] No input service with the name %s", sub)

		local get_keymapping = get_service:get_keymapping(sub_2)

		fassert(get_keymapping, "[key_parser] There is no such key: %s in input service: %s", sub_2, sub)

		local var_60_6

		for i = 1, get_keymapping.n, 3 do
			local var_60_7 = get_keymapping[i]
			local var_60_8 = get_keymapping[i + 1]

			if var_60_8 == UNASSIGNED_KEY then
				var_60_6 = "n/a"
			elseif Managers.input:is_device_active("keyboard") or not Managers.input:is_device_active("mouse") then
				if var_60_7 == "keyboard" then
					var_60_6 = Keyboard.button_locale_name(var_60_8) or Keyboard.button_name(var_60_8)
				elseif var_60_7 == "mouse" then
					var_60_6 = Mouse.button_name(var_60_8)
				end
			elseif not (not Managers.input:is_device_active("gamepad") and var_60_7 ~= "gamepad") then
				var_60_6 = Pad1.button_name(var_60_8)
			end
		end

		return var_60_6
	end

	Managers.localizer:add_macro("KEY", fn_2)
end

Game.select_starting_state = function (arg_61_0)
	-- function 61
	local tbl = {
		Application.argv()
	}

	for i = 1, #tbl do
		if tbl[i] == "safe-mode" then
			Game.safe_mode = true

			assert(false)
		end
	end

	if GameSettingsDevelopment.start_state == "dedicated_server" then
		Managers.package:load("resource_packages/menu", "boot")
		Managers.package:load("resource_packages/menu_assets_common", "global")
		Managers.package:load("resource_packages/ingame", "global")
		Managers.package:load("resource_packages/inventory", "global")
		Managers.package:load("resource_packages/careers", "global")
		Managers.package:load("resource_packages/pickups", "global")
		Managers.package:load("resource_packages/decals", "global")
		Managers.package:load("resource_packages/platform_specific/platform_specific", "boot")

		Boot.loading_context = {}

		require("scripts/game_state/state_dedicated_server")

		return StateDedicatedServer, {}
	elseif GameSettingsDevelopment.start_state == "game" then
		local flag

		flag = not LEVEL_EDITOR_TEST and "resource_packages/ingame_light" and "resource_packages/ingame"

		Managers.package:load("resource_packages/menu", "boot")
		Managers.package:load("resource_packages/menu_assets_common", "global")
		Managers.package:load(flag, "global")
		Managers.package:load("resource_packages/inventory", "global")
		Managers.package:load("resource_packages/careers", "global")
		Managers.package:load("resource_packages/pickups", "global")
		Managers.package:load("resource_packages/decals", "global")

		local level_key = GameSettingsDevelopment.quicklaunch_params.level_key

		Boot.loading_context = {}
		Boot.loading_context.level_key = level_key

		require("scripts/game_state/state_splash_screen")

		return StateSplashScreen, {}
	elseif GameSettingsDevelopment.start_state == "menu" then
		Boot.loading_context = {}
		Boot.loading_context.show_splash_screens = true

		require("scripts/game_state/state_splash_screen")

		return StateSplashScreen, {}
	end

	return StateSplashScreen, {}
end
