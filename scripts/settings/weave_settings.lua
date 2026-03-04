-- chunkname: @scripts/settings/weave_settings.lua

require("scripts/settings/horde_compositions")
require("scripts/settings/horde_compositions_pacing")
require("scripts/settings/difficulty_settings")
require("scripts/managers/conflict_director/conflict_utils")
require("scripts/settings/terror_event_blueprints")
require("scripts/settings/objective_lists")

local var_0_0 = 100
local var_0_1 = 80
local var_0_2 = 5
local var_0_3 = 0.8
local var_0_4 = {
	kill = true,
	interactions = true,
	targets = true,
	sockets = true,
	capture_points = false,
	doom_wheels = true
}

WeaveSettings = WeaveSettings or {}
WeaveSettings.damage_taken_score_weighting = 1
WeaveSettings.time_score_weighting = 1
WeaveSettings.starting_time = 900
WeaveSettings.bonus_time = 300
WeaveSettings.max_time = WeaveSettings.starting_time + WeaveSettings.bonus_time
WeaveSettings.max_damage_taken = 900
WeaveSettings.rating_values = {
	12000,
	9000,
	6000,
	3000,
	0
}
WeaveSettings.roaming_multiplier = {
	xb1 = 0.3,
	win32 = 0.1,
	ps4 = 0.3
}
WeaveSettings.enemies_score_multipliers = {
	default = 1,
	skaven_plague_monk = 5,
	skaven_clan_rat_with_shield = 2,
	chaos_exalted_champion = 12,
	skaven_poison_wind_globadier = 8,
	beastmen_bestigor = 5,
	chaos_raider = 5,
	skaven_gutter_runner = 8,
	chaos_marauder = 2,
	beastmen_minotaur = 32,
	chaos_fanatic = 1.5,
	skaven_slave = 1,
	skaven_storm_vermin_champion = 32,
	skaven_storm_vermin_warlord = 32,
	skaven_clan_rat = 1.5,
	skaven_stormfiend = 32,
	skaven_stormfiend_boss = 32,
	skaven_storm_vermin_with_shield = 8,
	chaos_exalted_sorcerer = 8,
	skaven_rat_ogre = 32,
	chaos_troll = 32,
	chaos_spawn = 32,
	chaos_corruptor_sorcerer = 8,
	chaos_vortex_sorcerer = 10,
	skaven_storm_vermin = 5,
	beastmen_gor = 2,
	beastmen_standard_bearer = 5,
	chaos_berzerker = 5,
	skaven_warpfire_thrower = 8,
	chaos_marauder_with_shield = 4,
	skaven_pack_master = 8,
	beastmen_ungor = 1.5,
	skaven_grey_seer = 8,
	chaos_warrior = 12,
	beastmen_ungor_archer = 1.5,
	skaven_storm_vermin_commander = 5,
	skaven_ratling_gunner = 8
}
WeaveSettings.score = {
	{
		essence = 80
	},
	{
		essence = 100
	},
	{
		essence = 105
	},
	{
		essence = 110
	},
	{
		essence = 120
	},
	{
		essence = 150
	},
	{
		essence = 180
	},
	{
		essence = 210
	},
	{
		essence = 280
	},
	{
		essence = 370
	},
	{
		essence = 500
	},
	{
		essence = 670
	},
	{
		essence = 920
	},
	{
		essence = 1260
	},
	{
		essence = 1730
	},
	{
		essence = 2380
	},
	{
		essence = 3300
	},
	{
		essence = 4580
	},
	{
		essence = 6390
	},
	{
		essence = 6390
	},
	{
		essence = 7400
	},
	{
		essence = 8320
	},
	{
		essence = 9160
	},
	{
		essence = 9940
	},
	{
		essence = 10650
	},
	{
		essence = 11300
	},
	{
		essence = 11910
	},
	{
		essence = 12470
	},
	{
		essence = 13000
	},
	{
		essence = 13490
	},
	{
		essence = 13950
	},
	{
		essence = 14380
	},
	{
		essence = 14780
	},
	{
		essence = 15160
	},
	{
		essence = 15520
	},
	{
		essence = 15860
	},
	{
		essence = 16180
	},
	{
		essence = 16480
	},
	{
		essence = 16770
	},
	{
		essence = 17040
	}
}

local var_0_5 = {}
local var_0_6 = {
	"weave_1",
	"weave_2",
	"weave_3",
	"weave_4",
	"weave_5",
	"weave_6",
	"weave_7",
	"weave_8",
	"weave_9",
	"weave_10",
	"weave_11",
	"weave_12",
	"weave_13",
	"weave_14",
	"weave_15",
	"weave_16",
	"weave_17",
	"weave_18",
	"weave_19",
	"weave_20",
	"weave_21",
	"weave_22",
	"weave_23",
	"weave_24",
	"weave_25",
	"weave_26",
	"weave_27",
	"weave_28",
	"weave_29",
	"weave_30",
	"weave_31",
	"weave_32",
	"weave_33",
	"weave_34",
	"weave_35",
	"weave_36",
	"weave_37",
	"weave_38",
	"weave_39",
	"weave_40"
}

WeaveSettings.weave_wind_ranges = {}

for iter_0_0 = 1, #var_0_6 do
	local var_0_7 = var_0_6[iter_0_0]
	local var_0_8 = string.format("scripts/settings/weaves/%s", var_0_7)
	local var_0_9 = local_require(var_0_8)
	local var_0_10 = var_0_9.wind

	if not WeaveSettings.weave_wind_ranges[var_0_10] then
		WeaveSettings.weave_wind_ranges[var_0_10] = {
			iter_0_0
		}
	else
		table.insert(WeaveSettings.weave_wind_ranges[var_0_10], iter_0_0)
	end

	var_0_5[#var_0_5 + 1] = var_0_9
end

local var_0_11 = #var_0_5

WeaveSettings.difficulty_increases = {
	{
		breakpoint = 10,
		difficulty_key = "normal",
		scaling_settings = {
			enemy_damage = {
				0,
				0.35
			}
		}
	},
	{
		breakpoint = 20,
		difficulty_key = "hard",
		scaling_settings = {
			enemy_damage = {
				0,
				0.35
			}
		}
	},
	{
		breakpoint = 30,
		difficulty_key = "harder",
		scaling_settings = {
			enemy_damage = {
				0,
				0.5
			}
		}
	},
	{
		breakpoint = 40,
		difficulty_key = "hardest"
	},
	{
		breakpoint = 60,
		difficulty_key = "cataclysm",
		scaling_settings = {
			diminishing_damage = {
				0,
				0.3
			}
		}
	},
	{
		breakpoint = 80,
		difficulty_key = "cataclysm_2",
		scaling_settings = {
			diminishing_damage = {
				0.3,
				0.6
			}
		}
	},
	{
		breakpoint = 90,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				0.6,
				0.8
			}
		}
	},
	{
		breakpoint = 100,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				0.8,
				1
			}
		}
	},
	{
		breakpoint = 110,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				1,
				1
			},
			enemy_damage = {
				0,
				0.25
			}
		}
	},
	{
		breakpoint = 120,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				1,
				1
			},
			enemy_damage = {
				0.25,
				0.75
			}
		}
	},
	{
		breakpoint = 130,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				1,
				1
			},
			enemy_damage = {
				0.75,
				2
			}
		}
	},
	{
		breakpoint = 140,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				1,
				1
			},
			enemy_damage = {
				2,
				5
			}
		}
	},
	{
		breakpoint = 150,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				1,
				1
			},
			enemy_damage = {
				5,
				9
			}
		}
	},
	{
		breakpoint = 160,
		difficulty_key = "cataclysm_3",
		scaling_settings = {
			diminishing_damage = {
				1,
				1
			},
			enemy_damage = {
				9,
				9
			}
		}
	}
}

local var_0_12 = {}

WeaveSettings.winds = {
	"fire",
	"beasts",
	"death",
	"heavens",
	"light",
	"shadow",
	"life",
	"metal"
}
WeaveSettings.templates = {}
WeaveSettings.templates_ordered = {}

for iter_0_1 = 1, var_0_11 * 4 do
	local var_0_13 = iter_0_1 % var_0_11

	var_0_13 = var_0_13 == 0 and var_0_11 or var_0_13

	local var_0_14 = table.clone(var_0_5[var_0_13])
	local var_0_15 = "weave_" .. iter_0_1
	local var_0_16 = var_0_14.objectives
	local var_0_17 = var_0_16[1]
	local var_0_18 = var_0_14.wind

	var_0_14.display_name = var_0_17.base_level_id .. "_" .. var_0_18 .. "_name"
	var_0_14.name = var_0_15
	var_0_14.tier = iter_0_1
	var_0_14.dlc_name = "scorpion"

	local var_0_19 = "cataclysm_3"
	local var_0_20

	for iter_0_2, iter_0_3 in ipairs(WeaveSettings.difficulty_increases) do
		if iter_0_1 <= iter_0_3.breakpoint then
			var_0_19 = iter_0_3.difficulty_key
			var_0_20 = iter_0_3.scaling_settings

			break
		end
	end

	var_0_14.difficulty_key = var_0_19
	var_0_14.scaling_settings = var_0_20

	for iter_0_4 = 1, #var_0_16 do
		local var_0_21 = var_0_16[iter_0_4].objective_settings
		local var_0_22 = ObjectiveLists[var_0_21 and var_0_21.objective_lists]

		if var_0_22 then
			for iter_0_5, iter_0_6 in ipairs(var_0_22) do
				for iter_0_7, iter_0_8 in pairs(iter_0_6) do
					var_0_12[iter_0_7] = true
				end
			end
		end
	end

	WeaveSettings.templates[var_0_15] = var_0_14
	WeaveSettings.templates_ordered[iter_0_1] = var_0_14
end

WeaveSettings.weave_objective_names = var_0_12

local var_0_23 = math.pow(2, 32)
local var_0_24 = {}

local function var_0_25(arg_1_0, arg_1_1)
	return arg_1_0.sort_index < arg_1_1.sort_index
end

local function var_0_26(arg_2_0)
	local var_2_0 = {}
	local var_2_1 = arg_2_0.objectives

	for iter_2_0, iter_2_1 in ipairs(var_2_1) do
		var_2_0[iter_2_0] = {}

		local var_2_2 = iter_2_1.objective_settings
		local var_2_3 = ObjectiveLists[var_2_2 and var_2_2.objective_lists]

		if var_2_3 then
			for iter_2_2, iter_2_3 in ipairs(var_2_3) do
				table.clear(var_0_24)

				for iter_2_4, iter_2_5 in pairs(iter_2_3) do
					local var_2_4 = iter_2_5.sort_index or var_0_23

					var_0_24[#var_0_24 + 1] = {
						sort_index = var_2_4,
						objective_name = iter_2_4
					}
				end

				table.sort(var_0_24, var_0_25)

				for iter_2_6, iter_2_7 in pairs(var_0_24) do
					local var_2_5 = iter_2_7.objective_name

					var_2_0[iter_2_0][#var_2_0[iter_2_0] + 1] = var_2_5
				end
			end
		end
	end

	arg_2_0.objectives_ordered = var_2_0
end

for iter_0_9, iter_0_10 in ipairs(WeaveSettings.templates_ordered) do
	var_0_26(iter_0_10)
end

local var_0_27 = {}

local function var_0_28(arg_3_0, arg_3_1)
	local var_3_0 = 0
	local var_3_1 = arg_3_1.difficulty_requirement

	if var_3_1 and arg_3_0 < var_3_1 then
		return var_3_0
	end

	local var_3_2 = arg_3_1.breed_name

	if not var_3_2 then
		table.dump(arg_3_1, "TEST", 2)
		assert(false)
	elseif type(var_3_2) == "table" then
		var_3_0 = #var_3_2

		for iter_3_0, iter_3_1 in pairs(var_3_2) do
			var_0_27[iter_3_1] = (var_0_27[iter_3_1] or 0) + 1
		end
	else
		var_0_27[var_3_2] = (var_0_27[var_3_2] or 0) + 1
		var_3_0 = 1
	end

	return var_3_0
end

local function var_0_29(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = 0
	local var_4_1 = arg_4_0.difficulty_requirement

	if not var_4_1 or var_4_1 <= arg_4_1 then
		local var_4_2 = arg_4_0.breed_name
		local var_4_3 = arg_4_0.amount or 1

		for iter_4_0 = 1, var_4_3 do
			local var_4_4
			local var_4_5

			if type(var_4_2) == "table" then
				local var_4_6

				arg_4_2, var_4_6 = Math.next_random(arg_4_2, 1, #var_4_2)

				local var_4_7 = var_4_2[var_4_6]

				var_0_27[var_4_7] = (var_0_27[var_4_7] or 0) + 1
			else
				local var_4_8 = var_4_2

				var_0_27[var_4_8] = (var_0_27[var_4_8] or 0) + 1
			end

			var_4_0 = var_4_0 + 1
		end
	end

	return var_4_0, arg_4_2
end

local function var_0_30(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0
	local var_5_1 = arg_5_0.breed_name
	local var_5_2 = arg_5_0.amount or 1
	local var_5_3 = arg_5_0.difficulty_amount

	if var_5_3 then
		local var_5_4 = var_5_3[arg_5_1] or var_5_3.hardest

		if type(var_5_4) == "table" then
			local var_5_5
			local var_5_6

			arg_5_2, var_5_6 = Math.next_random(arg_5_2, 1, #var_5_4)
			var_5_2 = var_5_4[var_5_6]
		else
			var_5_2 = var_5_4
		end
	elseif type(var_5_2) == "table" then
		local var_5_7
		local var_5_8

		arg_5_2, var_5_8 = Math.next_random(arg_5_2, 1, #var_5_2)
		var_5_2 = var_5_2[var_5_8]
	end

	if type(var_5_1) == "table" then
		local var_5_9
		local var_5_10

		arg_5_2, var_5_10 = Math.next_random(arg_5_2, 1, #var_5_1)
		var_5_0 = var_5_1[var_5_10]
	else
		var_5_0 = var_5_1
	end

	local var_5_11 = var_5_2

	var_0_27[var_5_0] = (var_0_27[var_5_0] or 0) + var_5_2

	return var_5_11, arg_5_2
end

local function var_0_31(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = DifficultySettings[arg_6_1].rank
	local var_6_1 = TerrorEventBlueprints.weaves[arg_6_0]

	for iter_6_0 = 1, #var_6_1 do
		local var_6_2 = var_6_1[iter_6_0]
		local var_6_3 = var_6_2[1]

		if var_6_3 == "spawn_weave_special" then
			local var_6_4
			local var_6_5, var_6_6 = var_0_29(var_6_2, var_6_0, arg_6_3)

			arg_6_3 = var_6_6
			arg_6_2 = arg_6_2 + var_6_5
		elseif var_6_3 == "spawn_weave_special_event" then
			local var_6_7
			local var_6_8, var_6_9 = var_0_30(var_6_2, arg_6_1, arg_6_3)

			arg_6_3 = var_6_9
			arg_6_2 = arg_6_2 + var_6_8
		elseif var_6_3 == "spawn" or var_6_3 == "spawn_at_raw" then
			arg_6_2 = arg_6_2 + var_0_28(var_6_0, var_6_2)
		elseif var_6_3 == "event_horde" or var_6_3 == "ambush_horde" then
			local var_6_10 = var_6_2.composition_type
			local var_6_11 = var_6_0 - 1
			local var_6_12 = HordeCompositions[var_6_10][var_6_11]

			fassert(var_6_12 ~= nil, string.format("[WeaveSettings] No horde composition found for '%s' on difficulty '%s'", var_6_10, arg_6_1))

			for iter_6_1 = 1, #var_6_12 do
				local var_6_13 = var_6_12[iter_6_1].breeds

				for iter_6_2 = 1, #var_6_13, 2 do
					local var_6_14 = var_6_13[iter_6_2]
					local var_6_15 = var_6_13[iter_6_2 + 1]

					if type(var_6_15) == "table" then
						var_6_15 = var_6_15[1]
					end

					arg_6_2 = arg_6_2 + var_6_15
					var_0_27[var_6_14] = (var_0_27[var_6_14] or 0) + var_6_15
				end
			end
		end
	end

	return arg_6_2, arg_6_3
end

local function var_0_32(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	for iter_7_0, iter_7_1 in ipairs(arg_7_0) do
		local var_7_0 = iter_7_1.terror_event_name

		arg_7_3, iter_7_0 = var_0_31(var_7_0, arg_7_1, arg_7_3, arg_7_4)
	end

	return arg_7_3, arg_7_4
end

local function var_0_33(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	for iter_8_0, iter_8_1 in ipairs(arg_8_0) do
		arg_8_3, iter_8_0 = var_0_31(iter_8_1, arg_8_1, arg_8_3, arg_8_4)
	end

	return arg_8_3, arg_8_4
end

local function var_0_34(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.objective_settings
	local var_9_1 = ObjectiveLists[var_9_0.objective_lists]

	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		for iter_9_2, iter_9_3 in pairs(iter_9_1) do
			if iter_9_2 == "kill_enemies" then
				iter_9_3.score_multiplier = arg_9_1
			end

			if iter_9_3.is_scored then
				iter_9_3.score_for_completion = arg_9_2
			end
		end
	end
end

local function var_0_35(arg_10_0)
	local var_10_0 = arg_10_0.objective_settings
	local var_10_1 = ObjectiveLists[var_10_0.objective_lists]
	local var_10_2 = 0

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		for iter_10_2, iter_10_3 in pairs(iter_10_1) do
			if iter_10_3.is_scored then
				var_10_2 = var_10_2 + 1
			end
		end
	end

	return var_10_2
end

local function var_0_36(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.objective_settings

	if not ObjectiveLists[var_11_0 and var_11_0.objective_lists] then
		return
	end

	local var_11_1 = var_0_35(arg_11_0)
	local var_11_2 = var_11_1 == 0 and 0 or var_0_1
	local var_11_3 = math.max(var_0_0 - var_11_2, var_0_2)
	local var_11_4 = var_11_2 / var_11_1
	local var_11_5 = arg_11_0.to_spawn
	local var_11_6 = {}

	for iter_11_0, iter_11_1 in pairs(DifficultySettings) do
		for iter_11_2, iter_11_3 in pairs(var_11_5[iter_11_0]) do
			local var_11_7 = WeaveSettings.enemies_score_multipliers[iter_11_2] or WeaveSettings.enemies_score_multipliers.default

			var_11_6[iter_11_0] = (var_11_6[iter_11_0] or 0) + var_11_7 * iter_11_3
		end
	end

	local var_11_8 = {}

	for iter_11_4, iter_11_5 in pairs(var_11_6) do
		var_11_8[iter_11_4] = var_11_3 / (iter_11_5 * var_0_3)
	end

	var_0_34(arg_11_0, var_11_8, var_11_4)
end

local var_0_37 = {}
local var_0_38 = os.clock()

for iter_0_11, iter_0_12 in pairs(WeaveSettings.templates) do
	local var_0_39 = iter_0_12.objectives

	for iter_0_13, iter_0_14 in ipairs(var_0_39) do
		table.clear(var_0_37)

		local var_0_40 = iter_0_14.objective_type
		local var_0_41 = iter_0_14.spawning_settings
		local var_0_42 = var_0_41 and var_0_41.main_path_spawning
		local var_0_43 = iter_0_14.terror_events or var_0_37

		fassert(var_0_42, "[WeaveSettings] No main path spawning in %q on objective: %q", iter_0_11, iter_0_13)

		local var_0_44 = {}
		local var_0_45 = {}

		for iter_0_15, iter_0_16 in pairs(DifficultySettings) do
			table.clear(var_0_27)

			local var_0_46 = iter_0_14.spawning_seed
			local var_0_47 = var_0_32(var_0_42, iter_0_15, iter_0_11, 0, var_0_46)

			if var_0_40 and var_0_4[var_0_40] then
				var_0_47 = var_0_33(var_0_43, iter_0_15, iter_0_11, var_0_47, var_0_46)
			end

			var_0_44[iter_0_15] = var_0_47
			var_0_45[iter_0_15] = table.clone(var_0_27)
		end

		iter_0_14.to_spawn = var_0_45
		iter_0_14.enemy_count = var_0_44

		if iter_0_14.conflict_settings == "weave_disabled" then
			iter_0_14.track_kills = true
			iter_0_14.bar_cutoff = 100
			iter_0_14.bar_multiplier = 0.25
		else
			iter_0_14.bar_cutoff = 75
			iter_0_14.bar_multiplier = 0.75
		end

		var_0_36(iter_0_14, iter_0_11)
	end
end

print("TIME: " .. os.clock() - var_0_38)
