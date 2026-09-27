-- chunkname: @scripts/boot_init.lua

if not rawget(_G, "jit") then
	jit.off()
end

MODE = {}

if not LEVEL_EDITOR_TEST then
	LEVEL_EDITOR_TEST = false
end

local function fn(arg_1_0)
	-- function 1
	for k, v in pairs(arg_1_0) do
		rawset(_G, k, v)
	end
end

if not s3d then
	fn(s3d)
end

GLOBAL_MUSIC_WORLD = true

local tbl = {
	stop_all = function ()
		-- function 2
		return
	end
}

if not GLOBAL_MUSIC_WORLD then
	MUSIC_WORLD = Application.new_world("music_world", Application.DISABLE_PHYSICS, Application.DISABLE_RENDERING)

	local wwise_world = Wwise.wwise_world(MUSIC_WORLD)

	wwise_world = wwise_world or Application.platform() ~= "ps4" or not tbl or "dedicated_server_no_wwise_dummy"
	MUSIC_WWISE_WORLD = wwise_world
end

local BUILD = BUILD

BUILD = BUILD or Application.build()
BUILD = BUILD

local PLATFORM = PLATFORM

PLATFORM = PLATFORM or Application.platform()
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
HAS_STEAM = HAS_STEAM == false or not not rawget(_G, "Steam")
DEDICATED_SERVER = Application.is_dedicated_server()

local tbl_2 = {
	Application.argv()
}

for k, v in pairs(tbl_2) do
	if v == "-attract-mode" then
		LAUNCH_MODE = "attract"

		break
	end

	if v == "-benchmark-mode" then
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

local GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX

GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX or 0
GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX

local script_data = script_data

script_data = script_data or {
	settings = Application.settings(),
	build_identifier = Application.build_identifier()
}
script_data = script_data

if not LEVEL_EDITOR_TEST then
	local GlobalResources = GlobalResources

	GlobalResources = GlobalResources or {
		"resource_packages/menu_assets_common",
		"resource_packages/ingame_light",
		"resource_packages/projection_decals",
		"resource_packages/inventory",
		"resource_packages/careers",
		"resource_packages/pickups",
		"resource_packages/decals",
		"resource_packages/levels/ui_loot_preview",
		"resource_packages/breeds",
		"resource_packages/breeds_common_resources",
		"resource_packages/dialogues/auto_load_files"
	}
	GlobalResources = GlobalResources
elseif not IS_PS4 then
	local GlobalResources_2 = GlobalResources

	GlobalResources_2 = GlobalResources_2 or {
		"resource_packages/menu_assets_common",
		"resource_packages/ingame_sounds_one",
		"resource_packages/ingame_sounds_two",
		"resource_packages/ingame_sounds_three",
		"resource_packages/ingame_sounds_weapon_general",
		"resource_packages/ingame_sounds_enemy_clan_rat_vce",
		"resource_packages/ingame_sounds_player_foley_common",
		"resource_packages/ingame_sounds_hud_dice_game",
		"resource_packages/ingame_sounds_general_props",
		"resource_packages/inventory",
		"resource_packages/careers",
		"resource_packages/decals",
		"resource_packages/levels/ui_loot_preview",
		"resource_packages/ingame",
		"resource_packages/pickups",
		"resource_packages/projection_decals",
		"resource_packages/ingame_sounds_honduras",
		"resource_packages/breeds",
		"resource_packages/breeds_common_resources",
		"resource_packages/dialogues/auto_load_files"
	}
	GlobalResources = GlobalResources_2
elseif not IS_XB1 then
	local GlobalResources_3 = GlobalResources

	GlobalResources_3 = GlobalResources_3 or {
		"resource_packages/menu_assets_common",
		"resource_packages/ingame_sounds_one",
		"resource_packages/ingame_sounds_two",
		"resource_packages/ingame_sounds_three",
		"resource_packages/ingame_sounds_weapon_general",
		"resource_packages/ingame_sounds_enemy_clan_rat_vce",
		"resource_packages/ingame_sounds_player_foley_common",
		"resource_packages/ingame_sounds_hud_dice_game",
		"resource_packages/ingame_sounds_general_props",
		"resource_packages/inventory",
		"resource_packages/careers",
		"resource_packages/decals",
		"resource_packages/levels/ui_loot_preview",
		"resource_packages/ingame",
		"resource_packages/pickups",
		"resource_packages/projection_decals",
		"resource_packages/ingame_sounds_honduras",
		"resource_packages/breeds",
		"resource_packages/breeds_common_resources",
		"resource_packages/dialogues/auto_load_files"
	}
	GlobalResources = GlobalResources_3
else
	local GlobalResources_4 = GlobalResources

	GlobalResources_4 = GlobalResources_4 or {
		"resource_packages/menu_assets_common",
		"resource_packages/ingame_sounds_one",
		"resource_packages/ingame_sounds_two",
		"resource_packages/ingame_sounds_three",
		"resource_packages/ingame_sounds_weapon_general",
		"resource_packages/ingame_sounds_enemy_clan_rat_vce",
		"resource_packages/ingame_sounds_player_foley_common",
		"resource_packages/ingame_sounds_hud_dice_game",
		"resource_packages/ingame_sounds_general_props",
		"resource_packages/ingame_sounds_honduras",
		"resource_packages/inventory",
		"resource_packages/careers",
		"resource_packages/decals",
		"resource_packages/levels/ui_loot_preview",
		"resource_packages/ingame",
		"resource_packages/pickups",
		"resource_packages/projection_decals",
		"resource_packages/slug_core_materials",
		"resource_packages/breeds",
		"resource_packages/breeds_common_resources",
		"resource_packages/dialogues/auto_load_files"
	}
	GlobalResources = GlobalResources_4
end

GlobalResources.unload = {}
GlobalResources.handle_and_remove_on_load = {
	["resource_packages/dialogues/auto_load_files"] = function (arg_5_0, arg_5_1)
		-- function 5
		DialogueSettings.cached_auto_load_files = {}

		local auto_load_files = DialogueSettings.auto_load_files

		for i, v in ipairs(auto_load_files) do
			if not Application.can_get("lua", v) then
				DialogueSettings.cached_auto_load_files[v] = require(v)
			end

			if not Application.can_get("lua", v .. "_markers") then
				DialogueSettings.cached_auto_load_files[v .. "_markers"] = dofile(v .. "_markers")
			end
		end
	end
}

GlobalResources.update_loading = function ()
	-- function 6
	if not GlobalResources.loaded then
		local flag = true
		local package = Managers.package

		for i, v in ipairs(GlobalResources) do
			if not package:is_loading(v, "global") then
				flag = false
			elseif not package:has_loaded(v, "global") then
				package:load(v, "global", nil, true)

				flag = false
			elseif not GlobalResources.handle_and_remove_on_load[v] then
				GlobalResources.handle_and_remove_on_load[v](v, "global")
				table.insert(GlobalResources.unload, {
					reference_name = "global",
					name = v
				})
			end
		end

		GlobalResources.loaded = flag

		for k = 1, #GlobalResources.unload do
			local var_6_2 = GlobalResources.unload[k]

			Managers.package:unload(var_6_2.name, var_6_2.reference_name)
			table.remove(GlobalResources, table.index_of(GlobalResources, var_6_2.name))
		end
	end

	return GlobalResources.loaded
end

if not (BUILD == "dev" or BUILD == "debug" or LAUNCH_MODE == "attract_benchmark") then
	local function fn_2(arg_7_0)
		-- function 7
		rawset(_G, arg_7_0, nil)

		package.loaded[arg_7_0] = nil
		package.preload[arg_7_0] = nil
	end

	fn_2("ffi")
	fn_2("io")

	if not rawget(_G, "jit") then
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
