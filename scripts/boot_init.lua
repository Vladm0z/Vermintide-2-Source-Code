-- chunkname: @scripts/boot_init.lua

if rawget(_G, "jit") then
	jit.off()
end

MODE = {}

if not LEVEL_EDITOR_TEST then
	LEVEL_EDITOR_TEST = false
end

local function import(lib)
	-- function 1
	for k, v in pairs(lib) do
		rawset(_G, k, v)
	end
end

if s3d then
	import(s3d)
end

GLOBAL_MUSIC_WORLD = true

local dummy_wwise_world = {
	stop_all = function ()
		-- function 2
		return
	end
}

if GLOBAL_MUSIC_WORLD then
	MUSIC_WORLD = Application.new_world("music_world", Application.DISABLE_PHYSICS, Application.DISABLE_RENDERING)
	MUSIC_WWISE_WORLD = Wwise.wwise_world(MUSIC_WORLD)
end

BUILD = BUILD
PLATFORM = PLATFORM
IS_CONSOLE = PLATFORM == "ps4" or PLATFORM == "xb1"
IS_WINDOWS = PLATFORM == "win32"
IS_LINUX = PLATFORM == "linux"
IS_XB1 = PLATFORM == "xb1"
IS_PS4 = PLATFORM == "ps4"
IS_NOT_CONSOLE = not IS_CONSOLE
IS_NOT_WINDOWS = not IS_WINDOWS
IS_NOT_LINUX = not IS_LINUX
IS_NOT_XB1 = not IS_XB1
IS_NOT_PS4 = not IS_PS4
LAUNCH_MODE = "game"
HAS_STEAM = HAS_STEAM ~= false and rawget(_G, "Steam")
DEDICATED_SERVER = Application.is_dedicated_server()

local args = {
	Application.argv()
}

for _, arg in pairs(args) do
	if arg == "-attract-mode" then
		LAUNCH_MODE = "attract"

		break
	end

	if arg == "-benchmark-mode" then
		LAUNCH_MODE = "attract_benchmark"

		break
	end
end

Application.build = function ()
	-- function 3
	error("Trying to use Application.build, use global variable BUILD instead.")
end

Application.platform = function ()
	-- function 4
	error("Trying to use Application.platform(), use global variable PLATFORM instead.")
end

GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX
script_data = script_data

if LEVEL_EDITOR_TEST then
	GlobalResources = GlobalResources
elseif IS_PS4 then
	GlobalResources = GlobalResources
elseif IS_XB1 then
	GlobalResources = GlobalResources
else
	GlobalResources = GlobalResources
end

GlobalResources.unload = {}
GlobalResources.handle_and_remove_on_load = {
	["resource_packages/dialogues/auto_load_files"] = function (name, reference_name)
		-- function 5
		DialogueSettings.cached_auto_load_files = {}

		local auto_load_files = DialogueSettings.auto_load_files

		for _, file_name in ipairs(auto_load_files) do
			if Application.can_get("lua", file_name) then
				DialogueSettings.cached_auto_load_files[file_name] = require(file_name)
			end

			if Application.can_get("lua", file_name .. "_markers") then
				DialogueSettings.cached_auto_load_files[file_name .. "_markers"] = dofile(file_name .. "_markers")
			end
		end
	end
}

GlobalResources.update_loading = function ()
	-- function 6
	if not GlobalResources.loaded then
		local is_loaded = true
		local package_manager = Managers.package

		for i, name in ipairs(GlobalResources) do
			if package_manager:is_loading(name, "global") then
				is_loaded = false
			elseif not package_manager:has_loaded(name, "global") then
				package_manager:load(name, "global", nil, true)

				is_loaded = false
			elseif GlobalResources.handle_and_remove_on_load[name] then
				GlobalResources.handle_and_remove_on_load[name](name, "global")
				table.insert(GlobalResources.unload, {
					reference_name = "global",
					name = name
				})
			end
		end

		GlobalResources.loaded = is_loaded

		for i = 1, #GlobalResources.unload do
			local unload_data = GlobalResources.unload[i]

			Managers.package:unload(unload_data.name, unload_data.reference_name)
			table.remove(GlobalResources, table.index_of(GlobalResources, unload_data.name))
		end
	end

	return GlobalResources.loaded
end

if BUILD ~= "dev" and BUILD ~= "debug" and LAUNCH_MODE ~= "attract_benchmark" then
	local function scrub_library(lib)
		-- function 7
		rawset(_G, lib, nil)

		package.loaded[lib] = nil
		package.preload[lib] = nil
	end

	scrub_library("ffi")
	scrub_library("io")

	if rawget(_G, "jit") then
		jit.on = nil
		jit.off = nil
		jit.flush = nil
	end

	os = {
		clock = os.clock,
		date = os.date,
		difftime = os.difftime,
		time = os.time,
		getenv = os.getenv
	}
	package.loadlib = nil
	package.loaders[3] = nil
	package.loaders[4] = nil
end
