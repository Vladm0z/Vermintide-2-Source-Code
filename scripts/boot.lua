-- chunkname: @scripts/boot.lua

print("boot.lua start, os clock:", os.clock())
dofile("scripts/boot_init")

if not DEDICATED_SERVER then
	dofile("scripts/global_shader_flags")
end

local var_0_0 = BUILD
local var_0_1 = PLATFORM

if IS_XB1 then
	local var_0_2 = {
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
		return var_0_2[XboxOne.console_type()]
	end
end

local function var_0_3(arg_2_0, ...)
	for iter_2_0, iter_2_1 in ipairs({
		...
	}) do
		require(string.format("foundation/scripts/%s/%s", arg_2_0, iter_2_1))
	end
end

local function var_0_4(arg_3_0, ...)
	for iter_3_0, iter_3_1 in ipairs({
		...
	}) do
		require("core/" .. arg_3_0 .. "/" .. iter_3_1)
	end
end

local function var_0_5(arg_4_0, ...)
	for iter_4_0, iter_4_1 in ipairs({
		...
	}) do
		require("scripts/" .. arg_4_0 .. "/" .. iter_4_1)
	end
end

local function var_0_6(arg_5_0, ...)
	for iter_5_0, iter_5_1 in ipairs({
		...
	}) do
		require("foundation/scripts/" .. arg_5_0 .. "/" .. iter_5_1)
	end
end

print("Active feature-flags:")
Application.print_strip_tags()
print("")
require("scripts/settings/dlc_settings")
require("scripts/helpers/dlc_utils")

Boot = Boot or {}
Boot.flow_return_table = Script.new_map(32)
Boot.is_controlled_exit = false

local function var_0_7(arg_6_0)
	return {
		title = arg_6_0,
		start_time = os.clock()
	}
end

local function var_0_8(arg_7_0, arg_7_1)
	local var_7_0 = #arg_7_0
	local var_7_1 = arg_7_0[var_7_0]

	if var_7_1 and var_7_1.alias == arg_7_1 then
		var_7_1.end_time = os.clock()
	else
		local var_7_2 = {
			alias = arg_7_1
		}

		arg_7_0[var_7_0 + 1] = var_7_2
		var_7_2.start_time = os.clock()
	end
end

local function var_0_9(arg_8_0)
	local var_8_0 = os.clock() - arg_8_0.start_time

	print(arg_8_0.title .. " total time: " .. var_8_0)

	local var_8_1 = 0

	for iter_8_0, iter_8_1 in ipairs(arg_8_0) do
		local var_8_2 = (iter_8_1.end_time or math.huge) - iter_8_1.start_time

		print("\t" .. iter_8_1.alias .. ": ", var_8_2)

		var_8_1 = var_8_1 + var_8_2
	end

	print("")
	print("\t unaccounted: ", var_8_0 - var_8_1)
end

Boot.setup = function (arg_9_0)
	_G.Crashify = require("foundation/scripts/util/crashify")

	if not DEDICATED_SERVER and IS_WINDOWS then
		Application.set_time_step_policy("throttle", 30)
	end

	Script.set_index_offset(0)
	print("Boot:setup() entered. time: ", 0, "os-clock: ", os.clock())

	Boot.startup_timer = 0
	Boot.startup_state = "loading"

	if IS_WINDOWS then
		Window.set_focus()
		Window.set_mouse_focus(true)
	end

	print(Application.sysinfo())
	arg_9_0:_init_localizer()

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

	local var_9_0 = {}

	for iter_9_0, iter_9_1 in ipairs(Boot.startup_packages) do
		local var_9_1 = Application.resource_package(iter_9_1)

		ResourcePackage.load(var_9_1)

		var_9_0[iter_9_1] = var_9_1
	end

	Boot.startup_package_handles = var_9_0

	local var_9_2 = {}

	for iter_9_2, iter_9_3 in ipairs(Boot.temporary_network_lookup_packages) do
		local var_9_3 = Application.resource_package(iter_9_3)

		ResourcePackage.load(var_9_3)

		var_9_2[iter_9_3] = var_9_3
	end

	Boot.temp_network_lookup_package_handles = var_9_2
	Boot.render = Boot.booting_render

	create_startup_world()
end

local function var_0_10(arg_10_0)
	return ({
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
	})[string.lower(arg_10_0)] or "en"
end

Boot._init_localizer = function (arg_11_0)
	local var_11_0 = "en"
	local var_11_1

	if IS_WINDOWS then
		var_11_1 = Application.user_setting("language_id") or rawget(_G, "Steam") and Steam:language() or var_11_0
	elseif IS_PS4 then
		var_11_1 = PS4.locale() or var_11_0
	elseif IS_XB1 then
		var_11_1 = var_0_10(XboxLive.locale() or var_11_0)
	elseif IS_LINUX then
		var_11_1 = "en"
	end

	if var_11_1 == var_11_0 then
		Application.set_resource_property_preference_order(var_11_0)
	else
		Application.set_resource_property_preference_order(var_11_1, var_11_0)
	end
end

local function var_0_11()
	require("foundation/scripts/util/user_setting")
	Development.init_user_settings()
	require("foundation/scripts/util/application_parameter")
	Development.init_application_parameters({
		Application.argv()
	}, true)
	require("foundation/scripts/util/development_parameter")
	Development.init_parameters()

	local var_12_0 = 0

	for iter_12_0, iter_12_1 in pairs(script_data) do
		var_12_0 = math.max(var_12_0, #iter_12_0)
	end

	local var_12_1 = {}

	for iter_12_2, iter_12_3 in pairs(script_data) do
		if type(iter_12_3) == "table" then
			local var_12_2 = string.format("script_data.%%-%ds = {", var_12_0)
			local var_12_3 = string.format(var_12_2, iter_12_2)

			for iter_12_4 = 1, #iter_12_3 do
				var_12_3 = var_12_3 .. ", " .. tostring(iter_12_3[iter_12_4])
			end

			local var_12_4 = var_12_3 .. " }"

			var_12_1[#var_12_1 + 1] = var_12_4
		else
			local var_12_5 = string.format("script_data.%%-%ds = %%s", var_12_0)

			var_12_1[#var_12_1 + 1] = string.format(var_12_5, iter_12_2, tostring(iter_12_3))
		end
	end

	table.sort(var_12_1, function (arg_13_0, arg_13_1)
		return arg_13_0 < arg_13_1
	end)
	print("*****************************************************************")
	print("**                Initial contents of script_data              **")

	for iter_12_5 = 1, #var_12_1 do
		print(var_12_1[iter_12_5])
	end

	print("*****************************************************************")

	script_data.honduras_demo = script_data.settings.honduras_demo or script_data["honduras-demo"]
	script_data.settings.use_beta_overlay = script_data.settings.use_beta_overlay or script_data.use_beta_overlay
	script_data.settings.use_beta_mode = script_data.settings.use_beta_mode or script_data.use_beta_mode
	script_data.use_optimized_breed_units = IS_CONSOLE

	print("[Boot] use baked enemy meshes:", script_data.use_optimized_breed_units)
end

Boot.booting_update = function (arg_14_0, arg_14_1)
	local var_14_0 = Boot.startup_timer

	Boot.startup_timer = var_14_0 + arg_14_1

	local var_14_1 = true

	for iter_14_0, iter_14_1 in pairs(Boot.startup_package_handles) do
		if not ResourcePackage.has_loaded(iter_14_1) then
			var_14_1 = false

			break
		end
	end

	for iter_14_2, iter_14_3 in pairs(Boot.temp_network_lookup_package_handles) do
		if not ResourcePackage.has_loaded(iter_14_3) then
			var_14_1 = false

			break
		end
	end

	if var_14_1 and Boot.startup_state == "loading" then
		local var_14_2 = os.clock()

		print("Boot:booting_update() reports boot packages loaded, initializing scripts. time: ", Boot.startup_timer, "os-clock: ", var_14_2)

		local var_14_3 = Boot.startup_package_handles

		for iter_14_4, iter_14_5 in ipairs(Boot.startup_packages) do
			local var_14_4 = var_14_3[iter_14_5]

			ResourcePackage.flush(var_14_4)
			print("Flushing:", iter_14_5, var_14_4)
		end

		for iter_14_6, iter_14_7 in ipairs(Boot.temp_network_lookup_package_handles) do
			ResourcePackage.flush(iter_14_7)
			print("Flushing:", iter_14_6, iter_14_7)
		end

		var_0_3("managers", "managers", "package/package_manager")

		Managers.package = PackageManager

		Managers.package:init()
		var_0_11()

		for iter_14_8, iter_14_9 in pairs(DLCSettings) do
			local var_14_5 = iter_14_9.package_name

			if var_14_5 then
				Managers.package:load(var_14_5, "boot", nil, true)
			end

			local var_14_6 = iter_14_9.platform_specific

			if var_14_6 then
				Managers.package:load(var_14_6, "boot", nil, true)
			end
		end

		local var_14_7 = os.clock()

		arg_14_0:_require_foundation_scripts()

		Boot.startup_state = "loading_dlcs"
	elseif Boot.startup_state == "loading_dlcs" then
		var_0_6("util", "local_require")

		if Managers.package:update(arg_14_1) then
			Boot.startup_state = "done_loading_dlcs"
			Boot.disable_loading_bar = true
		end
	elseif Boot.startup_state == "done_loading_dlcs" then
		DLCUtils.require_list("additional_settings")
		DLCUtils.merge("script_data", script_data)
		Game:require_game_scripts()

		if IS_WINDOWS and LAUNCH_MODE ~= "attract_benchmark" then
			Boot.startup_state = "init_mods"
		elseif IS_LINUX then
			Managers.mod = MockClass:new()
			Boot.startup_state = "ready"
		else
			Boot.startup_state = "ready"
		end
	elseif Boot.startup_state == "init_mods" then
		Managers.curl = CurlManager:new()

		var_0_5("managers", "mod/mod_manager")

		Managers.mod = ModManager:new(Boot.gui)
		Boot.startup_state = "loading_mods"
	elseif Boot.startup_state == "loading_mods" then
		Managers.curl:update(true)
		Managers.mod:update(arg_14_1)

		if Managers.mod:all_mods_loaded() then
			Managers.mod:remove_gui()

			Boot.startup_state = "ready"
		end
	elseif Boot.startup_state == "ready" then
		local var_14_8 = require("scripts/settings/crashify_settings")

		Crashify.print_property("project", var_14_8.project)
		Crashify.print_property("project_branch", var_14_8.branch)
		Crashify.print_property("build", var_0_0)
		Crashify.print_property("platform", var_0_1)
		Crashify.print_property("dedicated_server", DEDICATED_SERVER)
		Crashify.print_property("title_id", GameSettingsDevelopment.backend_settings.title_id)
		Crashify.print_property("content_revision", script_data.settings.content_revision == "" and Development.parameter("content_revision") or script_data.settings.content_revision)
		Crashify.print_property("engine_revision", script_data.build_identifier or Development.parameter("engine_revision"))
		Crashify.print_property("release_version", VersionSettings.version)
		Crashify.print_property("rendering_backend", Renderer.render_device_string())
		Crashify.print_property("teamcity_build_id", script_data.settings.teamcity_build_id)

		if script_data.testify then
			Crashify.print_property("testify", true)
		end

		if IS_WINDOWS or IS_LINUX then
			if rawget(_G, "Steam") then
				Crashify.print_property("steam_id", Steam.user_id())
				Crashify.print_property("steam_profile_name", Steam.user_name())
				Crashify.print_property("steam_app_id", Steam.app_id())

				if Application.user_setting("write_network_debug_output_to_log") then
					print("Network.write_debug_output_to_log(true)")

					local var_14_9 = 17
					local var_14_10 = 7

					Network.set_config_value(var_14_9, var_14_10)
					Network.write_debug_output_to_log(true)
				end
			end

			Crashify.print_property("machine_id", Application.machine_id())
		elseif IS_PS4 then
			Crashify.print_property("machine_id", Application.machine_id())

			local var_14_11 = "ps4"

			if PS4.is_ps5() then
				var_14_11 = "ps5"
			elseif PS4.is_pro() then
				var_14_11 = "ps4_pro"
			end

			Crashify.print_property("console_type", var_14_11)
		elseif IS_XB1 then
			Crashify.print_property("console_type", XboxOne.console_type_string())
		end

		local var_14_12 = os.clock()

		FrameTable.init()

		local var_14_13 = os.clock()
		local var_14_14 = os.clock()

		arg_14_0:_init_managers()

		local var_14_15 = os.clock()
		local var_14_16 = os.clock()

		Game:setup()

		local var_14_17, var_14_18 = Game:select_starting_state()

		var_14_18.notify_mod_manager = IS_WINDOWS and LAUNCH_MODE ~= "attract_benchmark"

		local var_14_19 = os.clock()
		local var_14_20 = os.clock()

		arg_14_0:_setup_statemachine(var_14_17, var_14_18)

		local var_14_21 = os.clock()
		local var_14_22 = os.clock()

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
	render_startup_world()
end

Boot._require_foundation_scripts = function (arg_16_0)
	var_0_3("util", "verify_plugins", "error", "patches", "class", "callback", "rectangle", "state_machine", "visual_state_machine", "misc_util", "stack", "circular_queue", "grow_queue", "table", "testify", "math", "vector3", "quaternion", "script_world", "script_viewport", "script_camera", "script_unit", "frame_table", "path", "string", "reportify")
	var_0_3("debug", "table_trap")
	var_0_3("managers", "world/world_manager", "player/player", "free_flight/free_flight_manager", "state/state_machine_manager", "time/time_manager", "token/token_manager")
	var_0_3("managers", "localization/localization_manager", "event/event_manager")
end

Boot._init_managers = function (arg_17_0)
	Managers.time = TimeManager:new()
	Managers.world = WorldManager:new()
	Managers.token = TokenManager:new()
	Managers.state_machine = StateMachineManager:new()
	Managers.url_loader = UrlLoaderManager:new()
end

Boot.game_render = function (arg_18_0)
	if arg_18_0._machine.pre_render then
		arg_18_0._machine:pre_render()
	end

	Managers.world:render()
	arg_18_0._machine:render()

	if arg_18_0._machine.post_render then
		arg_18_0._machine:post_render()
	end

	Managers.url_loader:post_render()
end

Boot._setup_statemachine = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._machine = GameStateMachine:new(arg_19_0, arg_19_1, arg_19_2, true)
end

Boot.on_close = function (arg_20_0)
	if arg_20_0._machine and arg_20_0._machine.on_close then
		return arg_20_0._machine:on_close()
	end

	return true
end

function init()
	Boot:setup()
end

function update(arg_22_0)
	if Boot.has_booted then
		Boot:game_update(arg_22_0)
	elseif Boot:booting_update(arg_22_0) then
		Boot:game_update(arg_22_0)
	end
end

function render()
	Boot:render()
end

function on_close()
	local var_24_0 = Boot:on_close()

	if var_24_0 then
		Application.force_silent_exit_policy()
		Crashify.print_property("shutdown", true)
	end

	return var_24_0
end

function shutdown()
	Application.force_silent_exit_policy()
	Crashify.print_property("shutdown", true)
	Boot:shutdown()
end

function create_startup_world()
	assert(not Boot.world)

	Boot.world = Application.new_world("boot_world", Application.DISABLE_PHYSICS, Application.DISABLE_SOUND, Application.DISABLE_APEX_CLOTH)
	Boot.shading_env = World.create_shading_environment(Boot.world, "environment/blank")
	Boot.viewport = Application.create_viewport(Boot.world, "overlay")

	local var_26_0 = World.spawn_unit(Boot.world, "core/units/camera")
	local var_26_1 = Unit.camera(var_26_0, "camera")

	Camera.set_data(var_26_1, "unit", var_26_0)
	Viewport.set_data(Boot.viewport, "camera", var_26_1)

	Boot.gui = World.create_screen_gui(Boot.world, "immediate")
	Boot.bar_timer = 0
end

function update_startup_world(arg_27_0)
	local var_27_0, var_27_1 = Application.resolution()

	Gui.rect(Boot.gui, Vector3(0, 0, 0), Vector2(var_27_0, var_27_1), Color(255, 0, 0, 0))

	if IS_CONSOLE and not Boot.disable_loading_bar then
		local function var_27_2(arg_28_0, arg_28_1, arg_28_2)
			if arg_28_2 < arg_28_0 then
				return arg_28_2
			elseif arg_28_0 < arg_28_1 then
				return arg_28_1
			else
				return arg_28_0
			end
		end

		Boot.bar_timer = (Boot.bar_timer + arg_27_0) % 2

		local var_27_3, var_27_4 = Gui.resolution()
		local var_27_5 = var_27_3 / 1920
		local var_27_6 = Vector2(120 * var_27_5, 13 * var_27_5)
		local var_27_7 = 1 * var_27_5
		local var_27_8 = var_27_2(Boot.bar_timer, 0, 1)
		local var_27_9 = var_27_8 * var_27_8 * var_27_8
		local var_27_10 = var_27_2(2 - Boot.bar_timer, 0, 1)

		Gui.rect(Boot.gui, Vector3(var_27_3 - 200 * var_27_5, 50 * var_27_5, 900), var_27_6)
		Gui.rect(Boot.gui, Vector3(var_27_3 - 200 * var_27_5 + var_27_7, 50 * var_27_5 + var_27_7, 901), Vector2(var_27_6[1] - var_27_7 * 2, var_27_6[2] - var_27_7 * 2), Color(0, 0, 0))
		Gui.rect(Boot.gui, Vector3(var_27_3 - 200 * var_27_5 + var_27_7 * 3, 50 * var_27_5 + var_27_7 * 4, 902), Vector2((var_27_6[1] - var_27_7 * 6) * var_27_9, var_27_6[2] - var_27_7 * 8), Color(var_27_10 * 255, 255, 255, 255))
	end

	World.update_scene(Boot.world, arg_27_0)
end

function render_startup_world()
	local var_29_0 = Boot.world
	local var_29_1 = Boot.shading_env
	local var_29_2 = Boot.viewport
	local var_29_3 = Viewport.get_data(Boot.viewport, "camera")

	Application.render_world(var_29_0, var_29_3, var_29_2, var_29_1)
end

function destroy_startup_world()
	assert(Boot.world)
	Application.release_world(Boot.world)

	Boot.world = nil
	Boot.viewport = nil
	Boot.shading_env = nil
	Boot.gui = nil
end

ReplayBoot = ReplayBoot or {}

ReplayBoot.init = function (arg_31_0)
	arg_31_0._packages = {}

	for iter_31_0, iter_31_1 in ipairs(ExtendedReplay.packages_to_load()) do
		print("Loading package " .. iter_31_1)

		local var_31_0 = Application.resource_package(iter_31_1)

		var_31_0:load()
		var_31_0:flush()
		table.insert(arg_31_0._packages, var_31_0)
	end

	var_0_3("util", "verify_plugins", "error", "framerate", "patches", "class", "callback", "rectangle", "misc_util", "stack", "circular_queue", "grow_queue", "table", "math", "vector3", "quaternion", "frame_table", "path", "script_extended_replay")
	var_0_3("managers", "managers", "replay/replay_manager")
	Framerate.set_replay()

	arg_31_0._world = Application.new_world("replay")

	ExtendedReplay.set_world(arg_31_0._world)

	Managers.replay = ReplayManager:new(arg_31_0._world)
end

ReplayBoot.update = function (arg_32_0, arg_32_1)
	arg_32_1 = Managers.replay:update(arg_32_1)

	World.update(arg_32_0._world, arg_32_1)
end

ReplayBoot.render = function (arg_33_0)
	local var_33_0 = ExtendedReplay.render_objects()

	if var_33_0 then
		local var_33_1 = Managers.replay:overriding_camera() or var_33_0.camera

		Application.render_world(arg_33_0._world, var_33_1, var_33_0.viewport, var_33_0.shading_environment)
	end
end

ReplayBoot.shutdown = function (arg_34_0)
	Managers:destroy()
	Application.release_world(arg_34_0._world)

	for iter_34_0, iter_34_1 in ipairs(arg_34_0._packages) do
		iter_34_1:unload()
		Application.release_resource_package(iter_34_1)
	end
end

function replay_init()
	ReplayBoot:init()
end

function replay_update(arg_36_0)
	ReplayBoot:update(arg_36_0)
end

function replay_render()
	ReplayBoot:render()
end

function replay_shutdown()
	ReplayBoot:shutdown()
end

function force_render(arg_39_0)
	if Managers.transition then
		Managers.transition:force_render(arg_39_0)
	end

	render()
end

local var_0_12 = {}

Boot.game_update = function (arg_40_0, arg_40_1)
	local var_40_0 = Managers
	local var_40_1 = var_40_0.time:scaled_delta_time(arg_40_1)

	if var_40_0.mod then
		var_40_0.mod:update(var_40_1)
	end

	UPDATE_RESOLUTION_LOOKUP()
	var_40_0.perfhud:update(var_40_1)
	var_40_0.updator:update(var_40_1)

	GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX + 1

	var_40_0.time:update(var_40_1)

	local var_40_2 = var_40_0.time:time("main")

	for iter_40_0, iter_40_1 in pairs(DLCSettings) do
		local var_40_3 = iter_40_1.manager_settings or var_0_12

		for iter_40_2, iter_40_3 in pairs(var_40_3) do
			if iter_40_3.pre_update then
				var_40_0[iter_40_2].pre_update(var_40_0[iter_40_2], var_40_1, var_40_2)
			end
		end
	end

	arg_40_0._machine:pre_update(var_40_1, var_40_2)
	var_40_0.package:update(var_40_1, var_40_2)
	var_40_0.token:update(var_40_1, var_40_2)

	for iter_40_4, iter_40_5 in pairs(DLCSettings) do
		local var_40_4 = iter_40_5.manager_settings or var_0_12

		for iter_40_6, iter_40_7 in pairs(var_40_4) do
			if iter_40_7.update then
				var_40_0[iter_40_6].update(var_40_0[iter_40_6], var_40_1, var_40_2)
			end
		end
	end

	arg_40_0._machine:update(var_40_1, var_40_2)
	var_40_0.state_machine:update(var_40_1)
	var_40_0.world:update(var_40_1, var_40_2)
	var_40_0.url_loader:update(var_40_1)

	if LEVEL_EDITOR_TEST and Keyboard.pressed(Keyboard.button_index("f5")) then
		Application.console_send({
			type = "stop_testing"
		})
	end

	if IS_WINDOWS then
		var_40_0.curl:update(true)
		var_40_0.irc:update(var_40_1)
		var_40_0.twitch:update(var_40_1, var_40_2)

		if rawget(_G, "Steam") then
			var_40_0.steam:update(var_40_2, var_40_1)
		end
	elseif IS_XB1 then
		var_40_0.rest_transport:update(true, var_40_1, var_40_2)

		if GameSettingsDevelopment.twitch_enabled then
			var_40_0.twitch:update(var_40_1)
			var_40_0.irc:update(var_40_1)
		end
	elseif IS_PS4 then
		var_40_0.rest_transport:update(true, var_40_1, var_40_2)
		var_40_0.irc:update(var_40_1)
		var_40_0.twitch:update(var_40_1)
		var_40_0.system_dialog:update(var_40_1)
	elseif IS_LINUX then
		var_40_0.curl:update(true)
		var_40_0.irc:update(var_40_1)
		var_40_0.twitch:update(var_40_1)
	end

	var_40_0.weave:update(var_40_1, var_40_2)
	var_40_0.news_ticker:update(var_40_1)
	var_40_0.transition:update(var_40_1)
	var_40_0.load_time:update(var_40_1)

	if var_40_0.splitscreen then
		var_40_0.splitscreen:update(var_40_1)
	end

	var_40_0.telemetry_reporters:update(var_40_1, var_40_2)
	var_40_0.telemetry:update(var_40_1, var_40_2)
	var_40_0.invite:update(var_40_1, var_40_2)
	var_40_0.admin:update(var_40_1)

	if var_40_0.ping then
		var_40_0.ping:update(var_40_1, var_40_2)
	end

	if var_40_0.account then
		var_40_0.account:update(var_40_1)
	end

	if var_40_0.light_fx then
		var_40_0.light_fx:update(var_40_1)
	end

	if var_40_0.razer_chroma then
		var_40_0.razer_chroma:update(var_40_1)
	end

	if var_40_0.unlock then
		var_40_0.unlock:update(var_40_1, var_40_2)
	end

	if var_40_0.popup then
		var_40_0.simple_popup:update(var_40_1)
		var_40_0.popup:update(var_40_1)
	end

	if var_40_0.beta_overlay then
		var_40_0.beta_overlay:update(var_40_1)
	end

	var_40_0.play_go:update(var_40_1)

	if IS_XB1 then
		var_40_0.xbox_events:update(var_40_1)

		if var_40_0.xbox_stats ~= nil then
			var_40_0.xbox_stats:update()
		end
	end

	if script_data.testify then
		var_40_0.mechanism:update_testify(var_40_1, var_40_2)

		if var_40_0.state.side then
			var_40_0.state.side:update_testify(var_40_1, var_40_2)
		end
	end

	Testify:update(var_40_1, var_40_2)
	end_function_call_collection()
	table.clear(Boot.flow_return_table)

	for iter_40_8, iter_40_9 in pairs(DLCSettings) do
		local var_40_5 = iter_40_9.manager_settings or var_0_12

		for iter_40_10, iter_40_11 in pairs(var_40_5) do
			if iter_40_11.post_update then
				var_40_0[iter_40_10].post_update(var_40_0[iter_40_10], var_40_1, var_40_2)
			end
		end
	end

	arg_40_0._machine:post_update(var_40_1)
	FrameTable.swap_and_clear()

	if arg_40_0.quit_game then
		local function var_40_6(arg_41_0)
			Boot.is_controlled_exit = true

			ShowCursorStack.dump()
			Application.quit()
		end

		if not arg_40_0._saving then
			var_40_0.save:auto_save(SaveFileName, SaveData, var_40_6)

			arg_40_0._saving = true
		end
	end
end

Boot.shutdown = function (arg_42_0, arg_42_1)
	if arg_42_0._machine then
		arg_42_0._machine:destroy(true)
	end

	if Managers then
		Managers:destroy()
	end

	if Boot.world then
		destroy_startup_world()
	end

	for iter_42_0, iter_42_1 in pairs(Boot.startup_package_handles) do
		if ResourcePackage.has_loaded(iter_42_1) then
			ResourcePackage.unload(iter_42_1)
			Application.release_resource_package(iter_42_1)
		end
	end

	if GLOBAL_MUSIC_WORLD then
		Application.release_world(MUSIC_WORLD)
	end
end

Game = Game or {}

Game.setup = function (arg_43_0)
	local var_43_0 = var_0_7("Game:setup()")
	local var_43_1 = var_0_0 == "dev" or var_0_0 == "debug"

	if IS_XB1 then
		Application.set_kinect_enabled(true)
	end

	if script_data.honduras_demo then
		arg_43_0:_demo_setup()
	end

	local var_43_2

	if IS_WINDOWS then
		if not Application.is_dedicated_server() then
			var_0_8(var_43_0, "handle gfx quality")
			arg_43_0:_handle_win32_graphics_quality()
			var_0_8(var_43_0, "handle gfx quality")
		end

		if rawget(_G, "Steam") then
			print("[Boot] User ID:", Steam.user_id(), Steam.user_name())
		end

		var_0_8(var_43_0, "default settings")
		DefaultUserSettings.set_default_user_settings()
		var_0_8(var_43_0, "default settings")
		var_0_8(var_43_0, "user settings")
		arg_43_0:_load_win32_user_settings()
		var_0_8(var_43_0, "user settings")
		arg_43_0:_init_mouse()

		if var_43_1 then
			Window.set_resizable(true)
		else
			Window.set_resizable(false)
		end
	else
		var_0_8(var_43_0, "default settings")
		DefaultUserSettings.set_default_user_settings()
		var_0_8(var_43_0, "default settings")

		if IS_PS4 then
			arg_43_0:_set_ps4_content_restrictions()
		end
	end

	var_0_8(var_43_0, "set frame times")
	Framerate.set_playing()
	var_0_8(var_43_0, "set frame times")

	if Development.parameter("network_log_spew") then
		Network.log("spew")
	elseif Development.parameter("network_log_messages") then
		Network.log("messages")
	elseif Development.parameter("network_log_messages") then
		Network.log("info")
	end

	if GameSettingsDevelopment.remove_debug_stuff then
		var_0_8(var_43_0, "remove debug stuff")
		DebugHelper.remove_debug_stuff()
		var_0_8(var_43_0, "remove debug stuff")
	end

	if script_data.settings.physics_dump then
		var_0_8(var_43_0, "physics_dump")
		DebugHelper.enable_physics_dump()
		var_0_8(var_43_0, "physics_dump")
	end

	for iter_43_0, iter_43_1 in pairs(DLCSettings) do
		local var_43_3 = iter_43_1.ingame_package_name

		if var_43_3 then
			GlobalResources[#GlobalResources + 1] = var_43_3
		end
	end

	var_0_8(var_43_0, "init random")
	arg_43_0:_init_random()
	var_0_8(var_43_0, "init random")
	var_0_8(var_43_0, "managers")
	arg_43_0:_init_managers()
	var_0_8(var_43_0, "managers")
	var_0_9(var_43_0)
end

Game._set_ps4_content_restrictions = function (arg_44_0)
	local var_44_0 = {
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

	NpCheck.set_content_restriction(18, var_44_0)
end

Game.require_game_scripts = function (arg_45_0)
	var_0_5("utils", "patches", "colors", "framerate", "global_utils", "function_call_stats", "loaded_dice", "deadlock_stack", "benchmark/benchmark_handler")
	var_0_5("settings", "version_settings")
	var_0_5("ui", "views/show_cursor_stack", "ui_fonts")
	var_0_5("settings", "demo_settings", "motion_control_settings", "game_settings_development", "controller_settings", "default_user_settings")
	var_0_5("entity_system", "entity_system")
	var_0_5("game_state", "game_state_machine", "state_context", "state_splash_screen", "state_loading", "state_ingame", "state_demo_end")
	require("scripts/managers/network/lobby_setup")
	var_0_5("managers", "admin/admin_manager", "news_ticker/news_ticker_manager", "player/player_manager", "player/player_bot", "save/save_manager", "save/save_data", "perfhud/perfhud_manager", "music/music_manager", "network/party_manager", "network/lobby_manager", "transition/transition_manager", "debug/updator", "invite/invite_manager", "unlock/unlock_manager", "popup/popup_manager", "popup/simple_popup", "light_fx/light_fx_manager", "razer_chroma/razer_chroma_manager", "play_go/play_go_manager", "controller_features/controller_features_manager", "deed/deed_manager", "boon/boon_manager", "telemetry/telemetry_manager", "telemetry/telemetry_events", "telemetry/telemetry_reporters", "load_time/load_time_manager", "game_mode/game_mechanism_manager", "ui/ui_manager", "weave/weave_manager")

	if IS_WINDOWS then
		var_0_5("managers", "irc/irc_manager", "curl/curl_manager", "curl/curl_token", "ping/ping_manager", "twitch/twitch_manager")

		if rawget(_G, "Steam") then
			var_0_5("managers", "steam/steam_manager")
		end
	elseif IS_XB1 then
		var_0_5("managers", "events/xbox_event_manager", "rest_transport/rest_transport_manager", "twitch/twitch_manager", "irc/irc_manager")
	elseif IS_PS4 then
		var_0_5("managers", "irc/irc_manager", "twitch/twitch_manager", "rest_transport/rest_transport_manager", "system_dialog/system_dialog_manager")
	elseif IS_LINUX then
		var_0_5("managers", "irc/irc_manager", "curl/curl_manager", "curl/curl_token", "twitch/twitch_manager", "ping/ping_manager")
	end

	var_0_5("helpers", "effect_helper", "weapon_helper", "item_helper", "lorebook_helper", "ui_atlas_helper", "scoreboard_helper")
	var_0_5("network", "unit_spawner", "unit_storage", "network_unit")
	arg_45_0:_init_localization_manager()
	require("scripts/ui/views/ingame_ui")
	require("scripts/ui/views/level_end/level_end_view_wrapper")
	require("scripts/ui/views/title_loading_ui")
	require("scripts/network_lookup/network_lookup")
	require("scripts/tests/test_cases")
end

Game._handle_win32_graphics_quality = function (arg_46_0)
	local var_46_0 = var_0_7("Game:_handle_win32_graphics_quality()")
	local var_46_1 = Application.user_setting("graphics_quality")
	local var_46_2 = false

	if Application.render_caps("reflex_supported") then
		local var_46_3 = Application.user_setting("max_fps") or 0

		if var_46_3 > 0 then
			print("[Boot] Migrating from max_fps to nv_framerate_cap. Value:", var_46_3)
			Application.set_user_setting("render_settings", "nv_framerate_cap", var_46_3)
			Application.set_user_setting("max_fps", 0)

			var_46_2 = true
		end
	else
		local var_46_4 = Application.user_setting("render_settings", "nv_framerate_cap") or 0

		if var_46_4 > 0 then
			print("[Boot] Migrating from nv_framerate_cap to max_fps. Value:", var_46_4)
			Application.set_user_setting("max_fps", var_46_4)
			Application.set_user_setting("render_settings", "nv_framerate_cap", 0)

			var_46_2 = true
		end
	end

	local var_46_5 = Application.user_setting("render_settings", "upscaling_mode") or "none"

	if var_46_5 ~= "none" then
		if Application.user_setting("render_settings", "fsr_enabled") then
			print("[Boot] Disabling fsr1 because another upscaler was enabled.")
			Application.set_render_setting("fsr_enabled", "false")

			var_46_2 = true
		end

		if var_46_5 == "fsr2" then
			if not Application.render_caps("d3d12") then
				print("[Boot] Disabling fsr2 because d3d12 was false.")
				Application.set_user_setting("fsr2_enabled", false)
				Application.set_render_setting("upscaling_enabled", "false")
				Application.set_render_setting("upscaling_mode", "none")
				Application.set_render_setting("upscaling_quality", "none")

				var_46_2 = true
			end
		elseif var_46_5 == "dlss" and not Application.render_caps("dlss_supported") then
			print("[Boot] Disabling dlss because dlss_supported was false.")
			Application.set_render_setting("upscaling_enabled", "false")
			Application.set_render_setting("upscaling_mode", "none")
			Application.set_render_setting("upscaling_quality", "none")

			var_46_2 = true
		end
	end

	if Application.user_setting("render_settings", "dlss_g_enabled") and not Application.render_caps("dlss_g_supported") then
		print("[Boot] Disabling dlss_g due because dlss_g_supported was false.")
		Application.set_render_setting("dlss_g_enabled", "false")
		Application.set_user_setting("overriden_settings", "dlss_frame_generation", true)

		var_46_2 = true
	end

	if Application.user_setting("dlss_enabled") and not Application.render_caps("dlss_supported") then
		print("[Boot] Disabling dlss_enabled because dlss_supported was false.")
		Application.set_user_setting("dlss_enabled", false)
	end

	local function var_46_6(arg_47_0, arg_47_1)
		if arg_47_0 == arg_47_1 then
			return true
		elseif type(arg_47_0) == "table" and type(arg_47_1) == "table" then
			for iter_47_0, iter_47_1 in pairs(arg_47_0) do
				if arg_47_1[iter_47_0] ~= iter_47_1 then
					return false
				end
			end

			for iter_47_2, iter_47_3 in pairs(arg_47_1) do
				if arg_47_0[iter_47_2] ~= iter_47_3 then
					return false
				end
			end

			return true
		else
			return false
		end
	end

	local function var_46_7(arg_48_0, arg_48_1, arg_48_2)
		if arg_48_2 ~= nil then
			local var_48_0 = Application.user_setting(arg_48_0, arg_48_1)

			if not var_46_6(var_48_0, arg_48_2) then
				Application.set_user_setting(arg_48_0, arg_48_1, arg_48_2)
				print("Diff in user_setting:", arg_48_0, arg_48_1, var_48_0, arg_48_2)

				var_46_2 = true
			end
		else
			arg_48_2 = arg_48_1
			arg_48_1 = arg_48_0

			local var_48_1 = Application.user_setting(arg_48_1)

			if not var_46_6(var_48_1, arg_48_2) then
				Application.set_user_setting(arg_48_1, arg_48_2)
				print("Diff in user_setting:", arg_48_1, var_48_1, arg_48_2)

				var_46_2 = true
			end
		end
	end

	if var_46_1 == nil then
		var_46_1 = script_data.settings.default_graphics_quality or "medium"

		Application.set_user_setting("graphics_quality", var_46_1)
	end

	local var_46_8 = GraphicsQuality[var_46_1]

	if not LEVEL_EDITOR_TEST and var_46_8 and not var_46_8.is_custom then
		local var_46_9 = var_46_8.user_settings

		for iter_46_0, iter_46_1 in pairs(var_46_9) do
			if iter_46_0 == "char_texture_quality" then
				local var_46_10 = TextureQuality.characters[iter_46_1]

				for iter_46_2, iter_46_3 in ipairs(var_46_10) do
					var_46_7("texture_settings", iter_46_3.texture_setting, iter_46_3.mip_level)
				end
			elseif iter_46_0 == "env_texture_quality" then
				local var_46_11 = TextureQuality.environment[iter_46_1]

				for iter_46_4, iter_46_5 in ipairs(var_46_11) do
					var_46_7("texture_settings", iter_46_5.texture_setting, iter_46_5.mip_level)
				end
			elseif iter_46_0 == "local_light_shadow_quality" then
				local var_46_12 = LocalLightShadowQuality[iter_46_1]

				for iter_46_6, iter_46_7 in pairs(var_46_12) do
					var_46_7("render_settings", iter_46_6, iter_46_7)
				end
			elseif iter_46_0 == "particles_quality" then
				local var_46_13 = ParticlesQuality[iter_46_1]

				for iter_46_8, iter_46_9 in pairs(var_46_13) do
					Application.set_user_setting("render_settings", iter_46_8, iter_46_9)
				end
			elseif iter_46_0 == "sun_shadow_quality" then
				local var_46_14 = SunShadowQuality[iter_46_1]

				for iter_46_10, iter_46_11 in pairs(var_46_14) do
					var_46_7("render_settings", iter_46_10, iter_46_11)
				end
			elseif iter_46_0 == "volumetric_fog_quality" then
				local var_46_15 = VolumetricFogQuality[iter_46_1]

				for iter_46_12, iter_46_13 in pairs(var_46_15) do
					var_46_7("render_settings", iter_46_12, iter_46_13)
				end
			elseif iter_46_0 == "ambient_light_quality" then
				local var_46_16 = AmbientLightQuality[iter_46_1]

				for iter_46_14, iter_46_15 in pairs(var_46_16) do
					var_46_7("render_settings", iter_46_14, iter_46_15)
				end
			elseif iter_46_0 == "ao_quality" then
				local var_46_17 = AmbientOcclusionQuality[iter_46_1]

				for iter_46_16, iter_46_17 in pairs(var_46_17) do
					var_46_7("render_settings", iter_46_16, iter_46_17)
				end
			end

			var_46_7(iter_46_0, iter_46_1)
		end

		local var_46_18 = var_46_8.render_settings

		for iter_46_18, iter_46_19 in pairs(var_46_18) do
			var_46_7("render_settings", iter_46_18, iter_46_19)
		end
	end

	if var_46_2 then
		var_0_8(var_46_0, "apply")
		Application.apply_user_settings()
		GlobalShaderFlags.apply_settings()
		var_0_8(var_46_0, "apply")
	end

	var_0_8(var_46_0, "save")
	Application.save_user_settings()
	var_0_8(var_46_0, "save")
	var_0_9(var_46_0)
end

Game._init_random = function (arg_49_0)
	local var_49_0 = os.clock() * 10000 % 1000

	math.randomseed(var_49_0)
	math.random(5, 30000)
end

Game._init_mouse = function (arg_50_0)
	Window.set_cursor("gui/cursors/mouse_cursor")
	Window.set_clip_cursor(true)
end

Game._init_managers = function (arg_51_0)
	parse_item_master_list()

	Managers.persistent_event = EventManager:new()
	Managers.save = SaveManager:new(script_data.settings.disable_cloud_save)

	if IS_XB1 then
		arg_51_0:_init_backend_xbox()
	elseif IS_PS4 then
		arg_51_0:_init_backend_ps4()
	else
		arg_51_0:_init_backend()
	end

	Managers.admin = AdminManager:new()
	Managers.perfhud = PerfhudManager:new()
	Managers.updator = Updator:new()
	Managers.music = MusicManager:new()
	Managers.transition = TransitionManager:new()
	Managers.play_go = PlayGoManager:new()
	Managers.ping = IS_WINDOWS and PingManager:new()

	if IS_WINDOWS then
		Managers.irc = IRCManager:new()

		if not Managers.curl then
			Managers.curl = CurlManager:new()
		end

		Managers.twitch = TwitchManager:new()
		Managers.unlock = UnlockManager:new()

		if rawget(_G, "Steam") then
			Managers.steam = SteamManager:new()
		end
	elseif IS_XB1 then
		Managers.xbox_events = XboxEventManager:new()
		Managers.rest_transport_online = RestTransportManager:new()
		Managers.rest_transport = Managers.rest_transport_online

		if GameSettingsDevelopment.twitch_enabled then
			Managers.twitch = TwitchManager:new()
			Managers.irc = IRCManager:new()
		end
	elseif IS_PS4 then
		Managers.rest_transport_online = RestTransportManager:new()
		Managers.rest_transport = Managers.rest_transport_online
		Managers.system_dialog = SystemDialogManager:new()
		Managers.irc = IRCManager:new()
		Managers.twitch = TwitchManager:new()
	elseif IS_LINUX then
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

	if GameSettingsDevelopment.use_leaderboards or Development.parameter("use_leaderboards") then
		Managers.leaderboards = LeaderboardManager:new()
	end

	local var_51_0 = {}

	for iter_51_0, iter_51_1 in pairs(DLCSettings) do
		local var_51_1 = iter_51_1.manager_settings or var_51_0

		for iter_51_2, iter_51_3 in pairs(var_51_1) do
			Managers[iter_51_2] = rawget(_G, iter_51_3.klass):new()
		end
	end
end

Game._init_backend = function (arg_52_0)
	local var_52_0
	local var_52_1
	local var_52_2

	if DEDICATED_SERVER then
		var_52_0 = "ScriptBackendPlayFabDedicated"
		var_52_2 = "PlayFabMirrorDedicated"
	else
		local var_52_3 = Development.parameter("mechanism") or "adventure"
		local var_52_4 = MechanismSettings[var_52_3]

		var_52_0 = "ScriptBackendPlayFab"

		local var_52_5 = var_52_4 and var_52_4.playfab_mirror

		var_52_2 = var_52_5 and var_52_5 or "PlayFabMirrorAdventure"
	end

	Managers.backend = BackendManagerPlayFab:new(var_52_0, var_52_2, "DataServerQueue")
end

Game._init_backend_xbox = function (arg_53_0)
	local var_53_0 = "ScriptBackendPlayFabXbox"
	local var_53_1 = Development.parameter("mechanism") or "adventure"
	local var_53_2 = MechanismSettings[var_53_1]
	local var_53_3 = var_53_2 and var_53_2.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.backend = BackendManagerPlayFab:new(var_53_0, var_53_3, "DataServerQueue")
end

Game._init_backend_ps4 = function (arg_54_0)
	local var_54_0 = "ScriptBackendPlayFabPS4"
	local var_54_1 = Development.parameter("mechanism") or "adventure"
	local var_54_2 = MechanismSettings[var_54_1]
	local var_54_3 = var_54_2 and var_54_2.playfab_mirror or "PlayFabMirrorAdventure"

	Managers.backend = BackendManagerPlayFab:new(var_54_0, var_54_3, "DataServerQueue")
end

Game._load_win32_user_settings = function (arg_55_0)
	local var_55_0 = Application.win32_user_setting("max_stacking_frames")

	if var_55_0 then
		Application.set_max_frame_stacking(var_55_0)
	end
end

Game._demo_setup = function (arg_56_0)
	Application.save_user_settings = function ()
		return
	end

	local var_56_0 = DemoSettings.key_combinations_allowed

	for iter_56_0, iter_56_1 in pairs(var_56_0) do
		Window.set_keystroke_enabled(iter_56_0, iter_56_1)
	end

	Managers.package:load("resource_packages/demo", "boot")
end

Game._init_localization_manager = function (arg_58_0)
	Managers.localizer = LocalizationManager:new()

	local function var_58_0(arg_59_0)
		return LocalizerTweakData[arg_59_0] or "<missing LocalizerTweakData \"" .. arg_59_0 .. "\">"
	end

	Managers.localizer:add_macro("TWEAK", var_58_0)

	local function var_58_1(arg_60_0)
		local var_60_0, var_60_1 = string.find(arg_60_0, "__")

		assert(var_60_0 and var_60_1, "[key_parser] You need to specify a key using this format $KEY;<input_service>__<key>. Example: $KEY;options_menu__back (note the dubbel underline separating input service and key")

		local var_60_2 = string.sub(arg_60_0, 1, var_60_0 - 1)
		local var_60_3 = string.sub(arg_60_0, var_60_1 + 1)
		local var_60_4 = Managers.input:get_service(var_60_2)

		fassert(var_60_4, "[key_parser] No input service with the name %s", var_60_2)

		local var_60_5 = var_60_4:get_keymapping(var_60_3)

		fassert(var_60_5, "[key_parser] There is no such key: %s in input service: %s", var_60_3, var_60_2)

		local var_60_6

		for iter_60_0 = 1, var_60_5.n, 3 do
			local var_60_7 = var_60_5[iter_60_0]
			local var_60_8 = var_60_5[iter_60_0 + 1]

			if var_60_8 == UNASSIGNED_KEY then
				var_60_6 = "n/a"
			elseif Managers.input:is_device_active("keyboard") or Managers.input:is_device_active("mouse") then
				if var_60_7 == "keyboard" then
					var_60_6 = Keyboard.button_locale_name(var_60_8) or Keyboard.button_name(var_60_8)
				elseif var_60_7 == "mouse" then
					var_60_6 = Mouse.button_name(var_60_8)
				end
			elseif Managers.input:is_device_active("gamepad") and var_60_7 == "gamepad" then
				var_60_6 = Pad1.button_name(var_60_8)
			end
		end

		return var_60_6
	end

	Managers.localizer:add_macro("KEY", var_58_1)
end

Game.select_starting_state = function (arg_61_0)
	local var_61_0 = {
		Application.argv()
	}

	for iter_61_0 = 1, #var_61_0 do
		if var_61_0[iter_61_0] == "safe-mode" then
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
		local var_61_1 = LEVEL_EDITOR_TEST and "resource_packages/ingame_light" or "resource_packages/ingame"

		Managers.package:load("resource_packages/menu", "boot")
		Managers.package:load("resource_packages/menu_assets_common", "global")
		Managers.package:load(var_61_1, "global")
		Managers.package:load("resource_packages/inventory", "global")
		Managers.package:load("resource_packages/careers", "global")
		Managers.package:load("resource_packages/pickups", "global")
		Managers.package:load("resource_packages/decals", "global")

		local var_61_2 = GameSettingsDevelopment.quicklaunch_params.level_key

		Boot.loading_context = {}
		Boot.loading_context.level_key = var_61_2

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
