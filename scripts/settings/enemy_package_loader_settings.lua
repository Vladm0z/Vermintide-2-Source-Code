-- chunkname: @scripts/settings/enemy_package_loader_settings.lua

EnemyPackageLoaderSettings = EnemyPackageLoaderSettings or {}
EnemyPackageLoaderSettings.policy = "default"
EnemyPackageLoaderSettings.max_loaded_breed_cap = 35
EnemyPackageLoaderSettings.breed_path = "resource_packages/breeds/"
EnemyPackageLoaderSettings.categories = {
	{
		id = "bosses",
		dynamic_loading = false,
		limit = math.huge,
		breeds = {
			"chaos_spawn",
			"chaos_troll",
			"skaven_rat_ogre",
			"skaven_stormfiend"
		}
	},
	{
		id = "specials",
		dynamic_loading = false,
		limit = math.huge,
		breeds = {
			"chaos_corruptor_sorcerer",
			"skaven_gutter_runner",
			"skaven_pack_master",
			"skaven_poison_wind_globadier",
			"skaven_ratling_gunner",
			"skaven_warpfire_thrower",
			"chaos_vortex_sorcerer"
		}
	},
	{
		id = "level_specific",
		dynamic_loading = true,
		limit = math.huge,
		breeds = {
			"chaos_dummy_sorcerer",
			"chaos_exalted_champion_warcamp",
			"chaos_exalted_sorcerer",
			"skaven_storm_vermin_warlord",
			"skaven_storm_vermin_champion",
			"chaos_plague_wave_spawner",
			"skaven_stormfiend_boss",
			"skaven_grey_seer",
			"training_dummy",
			"chaos_troll_chief",
			"pet_skeleton",
			"pet_skeleton_with_shield",
			"pet_skeleton_dual_wield",
			"pet_skeleton_armored",
			"chaos_bulwark",
			"critter_nurgling"
		}
	},
	{
		id = "debug",
		dynamic_loading = true,
		forbidden_in_build = "release",
		limit = math.huge,
		breeds = {
			"chaos_zombie",
			"chaos_skeleton",
			"chaos_tentacle",
			"skaven_stormfiend_demo"
		}
	},
	{
		id = "always_loaded",
		dynamic_loading = false,
		breeds = {
			"chaos_vortex",
			"critter_rat",
			"critter_pig"
		}
	}
}

local var_0_0 = EnemyPackageLoaderSettings.categories

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_1 = iter_0_1.enemy_package_loader_breed_categories

	if var_0_1 then
		for iter_0_2, iter_0_3 in pairs(var_0_1) do
			local var_0_2

			for iter_0_4 = 1, #var_0_0 do
				local var_0_3 = var_0_0[iter_0_4]

				if var_0_3.id == iter_0_2 then
					var_0_2 = var_0_3

					break
				end
			end

			fassert(var_0_2 ~= nil, "Couldn't find EnemeyPackageLoader category %s specified in DLC %s.", iter_0_2, iter_0_0)

			for iter_0_5 = 1, #var_0_0 do
				local var_0_4 = var_0_0[iter_0_5]
				local var_0_5 = var_0_4.breeds

				for iter_0_6 = 1, #iter_0_3 do
					local var_0_6 = iter_0_3[iter_0_6]

					for iter_0_7 = 1, #var_0_5 do
						local var_0_7 = var_0_5[iter_0_7]

						fassert(var_0_7 ~= var_0_6, "Breed %s (DLC: %s) is already defined in category %s!", var_0_6, iter_0_0, var_0_4.id)
					end
				end
			end

			local var_0_8 = var_0_2.breeds

			for iter_0_8 = 1, #iter_0_3 do
				local var_0_9 = iter_0_3[iter_0_8]

				var_0_8[#var_0_8 + 1] = var_0_9

				printf("[EnemyPackageLoaderSettings] Added DLC breed %s (DLC %s) to category %s.", var_0_9, iter_0_0, iter_0_2)
			end
		end
	end
end

local var_0_10

if IS_CONSOLE or script_data.enemy_package_loader_policy == "console" then
	EnemyPackageLoaderSettings.policy = "console"
	EnemyPackageLoaderSettings.max_loaded_breed_cap = 35
	var_0_10 = {
		bosses = {
			limit = 1,
			dynamic_loading = true
		},
		specials = {
			dynamic_loading = true,
			limit = 3,
			replacement_breed_override_funcs = {
				patrol = "find_patrol_replacement"
			}
		},
		level_specific = {
			dynamic_loading = true,
			limit = math.huge
		},
		debug = {
			forbidden_in_build = "release",
			dynamic_loading = true,
			limit = math.huge
		}
	}
end

print("[EnemyPackageLoaderSettings] enemy_package_loader_policy:", EnemyPackageLoaderSettings.policy)

if var_0_10 then
	local var_0_11 = EnemyPackageLoaderSettings.categories

	for iter_0_9 = 1, #var_0_11 do
		local var_0_12 = var_0_11[iter_0_9]
		local var_0_13 = var_0_10[var_0_12.id]

		if var_0_13 then
			for iter_0_10, iter_0_11 in pairs(var_0_13) do
				var_0_12[iter_0_10] = iter_0_11
			end
		end
	end
end

EnemyPackageLoaderSettings.opt_lookup_breed_names = {
	skaven_storm_vermin_with_shield = "skaven_storm_vermin_with_shield_opt",
	chaos_raider = "chaos_raider_opt",
	chaos_berzerker = "chaos_berzerker_opt",
	skaven_clan_rat_with_shield = "skaven_clan_rat_with_shield_opt",
	chaos_marauder_with_shield = "chaos_marauder_with_shield_opt",
	chaos_fanatic = "chaos_fanatic_opt",
	skaven_slave = "skaven_slave_opt",
	skaven_storm_vermin = "skaven_storm_vermin_opt",
	skaven_clan_rat = "skaven_clan_rat_opt",
	chaos_marauder = "chaos_marauder_opt"
}
EnemyPackageLoaderSettings.alias_to_breed = {
	chaos_raider_tutorial = "chaos_raider",
	chaos_dummy_troll = "chaos_troll",
	chaos_tether_sorcerer = "chaos_corruptor_sorcerer",
	skaven_dummy_slave = "skaven_slave",
	chaos_exalted_champion_norsca = "chaos_exalted_champion_warcamp",
	chaos_marauder_tutorial = "chaos_marauder",
	skaven_storm_vermin_commander = "skaven_storm_vermin",
	chaos_spawn_exalted_champion_norsca = "chaos_spawn",
	skaven_clan_rat_tutorial = "skaven_clan_rat",
	skaven_dummy_clan_rat = "skaven_clan_rat"
}
EnemyPackageLoaderSettings.breed_to_aliases = {}

for iter_0_12, iter_0_13 in pairs(DLCSettings) do
	local var_0_14 = iter_0_13.alias_to_breed

	if var_0_14 then
		for iter_0_14, iter_0_15 in pairs(var_0_14) do
			EnemyPackageLoaderSettings.alias_to_breed[iter_0_14] = iter_0_15
		end
	end

	local var_0_15 = iter_0_13.opt_lookup_breed_names

	if var_0_15 then
		for iter_0_16, iter_0_17 in pairs(var_0_15) do
			EnemyPackageLoaderSettings.opt_lookup_breed_names[iter_0_16] = iter_0_17
		end
	end
end

local var_0_16 = EnemyPackageLoaderSettings.alias_to_breed
local var_0_17 = EnemyPackageLoaderSettings.breed_to_aliases

for iter_0_18, iter_0_19 in pairs(var_0_16) do
	if not var_0_17[iter_0_19] then
		var_0_17[iter_0_19] = {}
	end

	local var_0_18 = var_0_17[iter_0_19]

	var_0_18[#var_0_18 + 1] = iter_0_18
end
