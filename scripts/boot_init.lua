-- chunkname: @scripts/boot_init.lua

jit.off()

MODE = {}

if not LEVEL_EDITOR_TEST then
	LEVEL_EDITOR_TEST = false
end

local function var_0_0(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		rawset(_G, iter_1_0, iter_1_1)
	end
end

if s3d then
	var_0_0(s3d)
end

GLOBAL_MUSIC_WORLD = true

local var_0_1 = {
	stop_all = function()
		return
	end
}

if GLOBAL_MUSIC_WORLD then
	MUSIC_WORLD = Application.new_world("music_world", Application.DISABLE_PHYSICS, Application.DISABLE_RENDERING)
	MUSIC_WWISE_WORLD = Wwise.wwise_world(MUSIC_WORLD) or Application.platform() == "ps4" and var_0_1 or "dedicated_server_no_wwise_dummy"
end

BUILD = BUILD or Application.build()
PLATFORM = PLATFORM or Application.platform()
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
HAS_STEAM = HAS_STEAM ~= false and not not rawget(_G, "Steam")
DEDICATED_SERVER = Application.is_dedicated_server()

local var_0_2 = {
	Application.argv()
}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	if iter_0_1 == "-attract-mode" then
		LAUNCH_MODE = "attract"

		break
	end

	if iter_0_1 == "-benchmark-mode" then
		LAUNCH_MODE = "attract_benchmark"

		break
	end
end

function Application.build()
	error("Trying to use Application.build, use global variable BUILD instead.")
end

function Application.platform()
	error("Trying to use Application.platform(), use global variable PLATFORM instead.")
end

GLOBAL_FRAME_INDEX = GLOBAL_FRAME_INDEX or 0
script_data = script_data or {
	settings = Application.settings(),
	build_identifier = Application.build_identifier()
}

if LEVEL_EDITOR_TEST then
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
elseif IS_PS4 then
	GlobalResources = GlobalResources or {
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
elseif IS_XB1 then
	GlobalResources = GlobalResources or {
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
else
	GlobalResources = GlobalResources or {
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
end

GlobalResources.unload = {}
GlobalResources.handle_and_remove_on_load = {
	["resource_packages/dialogues/auto_load_files"] = function(arg_5_0, arg_5_1)
		DialogueSettings.cached_auto_load_files = {}

		local var_5_0 = DialogueSettings.auto_load_files

		for iter_5_0, iter_5_1 in ipairs(var_5_0) do
			if Application.can_get("lua", iter_5_1) then
				DialogueSettings.cached_auto_load_files[iter_5_1] = require(iter_5_1)
			end

			if Application.can_get("lua", iter_5_1 .. "_markers") then
				DialogueSettings.cached_auto_load_files[iter_5_1 .. "_markers"] = dofile(iter_5_1 .. "_markers")
			end
		end
	end
}

function GlobalResources.update_loading()
	if not GlobalResources.loaded then
		local var_6_0 = true
		local var_6_1 = Managers.package

		for iter_6_0, iter_6_1 in ipairs(GlobalResources) do
			if var_6_1:is_loading(iter_6_1, "global") then
				var_6_0 = false
			elseif not var_6_1:has_loaded(iter_6_1, "global") then
				var_6_1:load(iter_6_1, "global", nil, true)

				var_6_0 = false
			elseif GlobalResources.handle_and_remove_on_load[iter_6_1] then
				GlobalResources.handle_and_remove_on_load[iter_6_1](iter_6_1, "global")
				table.insert(GlobalResources.unload, {
					reference_name = "global",
					name = iter_6_1
				})
			end
		end

		GlobalResources.loaded = var_6_0

		for iter_6_2 = 1, #GlobalResources.unload do
			local var_6_2 = GlobalResources.unload[iter_6_2]

			Managers.package:unload(var_6_2.name, var_6_2.reference_name)
			table.remove(GlobalResources, table.index_of(GlobalResources, var_6_2.name))
		end
	end

	return GlobalResources.loaded
end

if BUILD ~= "dev" and BUILD ~= "debug" and LAUNCH_MODE ~= "attract_benchmark" then
	local function var_0_3(arg_7_0)
		rawset(_G, arg_7_0, nil)

		package.loaded[arg_7_0] = nil
		package.preload[arg_7_0] = nil
	end

	var_0_3("ffi")
	var_0_3("io")

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
