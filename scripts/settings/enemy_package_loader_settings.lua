-- chunkname: @scripts/settings/enemy_package_loader_settings.lua

local EnemyPackageLoaderSettings = EnemyPackageLoaderSettings

EnemyPackageLoaderSettings = EnemyPackageLoaderSettings or {}
EnemyPackageLoaderSettings = EnemyPackageLoaderSettings
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

local categories = EnemyPackageLoaderSettings.categories

for k, v in pairs(DLCSettings) do
	local enemy_package_loader_breed_categories = v.enemy_package_loader_breed_categories

	if not enemy_package_loader_breed_categories then
		for k_2, v_2 in pairs(enemy_package_loader_breed_categories) do
			local var_0_3

			for i4 = 1, #categories do
				local var_0_4 = categories[i4]

				if var_0_4.id == k_2 then
					var_0_3 = var_0_4

					break
				end
			end

			fassert(var_0_3 ~= nil, "Couldn't find EnemeyPackageLoader category %s specified in DLC %s.", k_2, k)

			for i5 = 1, #categories do
				local var_0_5 = categories[i5]
				local breeds = var_0_5.breeds

				for i6 = 1, #v_2 do
					local var_0_7 = v_2[i6]

					for i7 = 1, #breeds do
						local var_0_8 = breeds[i7]

						fassert(var_0_8 ~= var_0_7, "Breed %s (DLC: %s) is already defined in category %s!", var_0_7, k, var_0_5.id)
					end
				end
			end

			local breeds_2 = var_0_3.breeds

			for i8 = 1, #v_2 do
				local var_0_10 = v_2[i8]

				breeds_2[#breeds_2 + 1] = var_0_10

				printf("[EnemyPackageLoaderSettings] Added DLC breed %s (DLC %s) to category %s.", var_0_10, k, k_2)
			end
		end
	end
end

local var_0_11

if not (IS_CONSOLE or script_data.enemy_package_loader_policy ~= "console") then
	EnemyPackageLoaderSettings.policy = "console"
	EnemyPackageLoaderSettings.max_loaded_breed_cap = 35
	var_0_11 = {
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

if not var_0_11 then
	local categories_2 = EnemyPackageLoaderSettings.categories

	for i9 = 1, #categories_2 do
		local var_0_13 = categories_2[i9]
		local var_0_14 = var_0_11[var_0_13.id]

		if not var_0_14 then
			for k_3, v_3 in pairs(var_0_14) do
				var_0_13[k_3] = v_3
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

for k_4, v_4 in pairs(DLCSettings) do
	local alias_to_breed = v_4.alias_to_breed

	if not alias_to_breed then
		for k_5, v_5 in pairs(alias_to_breed) do
			EnemyPackageLoaderSettings.alias_to_breed[k_5] = v_5
		end
	end

	local opt_lookup_breed_names = v_4.opt_lookup_breed_names

	if not opt_lookup_breed_names then
		for k_6, v_6 in pairs(opt_lookup_breed_names) do
			EnemyPackageLoaderSettings.opt_lookup_breed_names[k_6] = v_6
		end
	end
end

local alias_to_breed_2 = EnemyPackageLoaderSettings.alias_to_breed
local breed_to_aliases = EnemyPackageLoaderSettings.breed_to_aliases

for k_7, v_7 in pairs(alias_to_breed_2) do
	if not breed_to_aliases[v_7] then
		breed_to_aliases[v_7] = {}
	end

	local var_0_19 = breed_to_aliases[v_7]

	var_0_19[#var_0_19 + 1] = k_7
end
