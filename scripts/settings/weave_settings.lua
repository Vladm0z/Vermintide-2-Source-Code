-- chunkname: @scripts/settings/weave_settings.lua

require("scripts/settings/horde_compositions")
require("scripts/settings/horde_compositions_pacing")
require("scripts/settings/difficulty_settings")
require("scripts/managers/conflict_director/conflict_utils")
require("scripts/settings/terror_event_blueprints")
require("scripts/settings/objective_lists")

local num = 100
local num_2 = 80
local num_3 = 5
local num_4 = 0.8
local tbl = {
	kill = true,
	interactions = true,
	targets = true,
	sockets = true,
	capture_points = false,
	doom_wheels = true
}
local WeaveSettings = WeaveSettings

WeaveSettings = WeaveSettings or {}
WeaveSettings = WeaveSettings
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

local tbl_2 = {}
local tbl_3 = {
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

for i = 1, #tbl_3 do
	local var_0_8 = tbl_3[i]
	local format = string.format("scripts/settings/weaves/%s", var_0_8)
	local var_0_10 = local_require(format)
	local wind = var_0_10.wind

	if not WeaveSettings.weave_wind_ranges[wind] then
		WeaveSettings.weave_wind_ranges[wind] = {
			i
		}
	else
		table.insert(WeaveSettings.weave_wind_ranges[wind], i)
	end

	tbl_2[#tbl_2 + 1] = var_0_10
end

local count = #tbl_2

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

local tbl_4 = {}

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

for j = 1, count * 4 do
	local num_5 = j % count

	num_5 = num_5 ~= 0 or not count or num_5

	local clone = table.clone(tbl_2[num_5])
	local str = "weave_" .. j
	local objectives = clone.objectives
	local var_0_18 = objectives[1]
	local wind_2 = clone.wind

	clone.display_name = var_0_18.base_level_id .. "_" .. wind_2 .. "_name"
	clone.name = str
	clone.tier = j
	clone.dlc_name = "scorpion"

	local str_2 = "cataclysm_3"
	local var_0_21

	for i_2, v in ipairs(WeaveSettings.difficulty_increases) do
		if j <= v.breakpoint then
			str_2 = v.difficulty_key
			var_0_21 = v.scaling_settings

			break
		end
	end

	clone.difficulty_key = str_2
	clone.scaling_settings = var_0_21

	for i4 = 1, #objectives do
		local objective_settings = objectives[i4].objective_settings
		local var_0_23 = ObjectiveLists[not objective_settings and objective_settings.objective_lists]

		if not var_0_23 then
			for i_3, v_2 in ipairs(var_0_23) do
				for k, v_3 in pairs(v_2) do
					tbl_4[k] = true
				end
			end
		end
	end

	WeaveSettings.templates[str] = clone
	WeaveSettings.templates_ordered[j] = clone
end

WeaveSettings.weave_objective_names = tbl_4

local pow = math.pow(2, 32)
local tbl_5 = {}

local function fn(self, arg_1_1)
	-- function 1
	return self.sort_index < arg_1_1.sort_index
end

local function fn_2(self)
	-- function 2
	local tbl = {}
	local objectives = self.objectives

	for i, v in ipairs(objectives) do
		tbl[i] = {}

		local objective_settings = v.objective_settings
		local var_2_3 = ObjectiveLists[not objective_settings and objective_settings.objective_lists]

		if not var_2_3 then
			for i_2, v_2 in ipairs(var_2_3) do
				table.clear(tbl_5)

				for k, v_3 in pairs(v_2) do
					local sort_index = v_3.sort_index

					sort_index = sort_index or pow
					tbl_5[#tbl_5 + 1] = {
						sort_index = sort_index,
						objective_name = k
					}
				end

				table.sort(tbl_5, fn)

				for k_2, v_4 in pairs(tbl_5) do
					local objective_name = v_4.objective_name

					tbl[i][#tbl[i] + 1] = objective_name
				end
			end
		end
	end

	self.objectives_ordered = tbl
end

for i_4, v_4 in ipairs(WeaveSettings.templates_ordered) do
	fn_2(v_4)
end

local tbl_6 = {}

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local num = 0
	local difficulty_requirement = arg_3_1.difficulty_requirement

	if not (not difficulty_requirement and not (arg_3_0 < difficulty_requirement)) then
		return num
	end

	local breed_name = arg_3_1.breed_name

	if not breed_name then
		table.dump(arg_3_1, "TEST", 2)
		assert(false)
	elseif type(breed_name) == "table" then
		num = #breed_name

		for k, v in pairs(breed_name) do
			local var_3_3 = tbl_6
			local var_3_4 = tbl_6[v]

			var_3_4 = var_3_4 or 0
			var_3_3[v] = var_3_4 + 1
		end
	else
		local var_3_5 = tbl_6
		local var_3_6 = tbl_6[breed_name]

		var_3_6 = var_3_6 or 0
		var_3_5[breed_name] = var_3_6 + 1
		num = 1
	end

	return num
end

local function fn_4(self, arg_4_1, arg_4_2)
	-- function 4
	local num = 0
	local difficulty_requirement = self.difficulty_requirement

	if not (not difficulty_requirement and not (difficulty_requirement <= arg_4_1)) then
		local breed_name = self.breed_name
		local amount = self.amount

		amount = amount or 1

		for i = 1, amount do
			local var_4_4
			local var_4_5

			if type(breed_name) == "table" then
				local var_4_6

				arg_4_2, var_4_6 = Math.next_random(arg_4_2, 1, #breed_name)

				local var_4_7 = breed_name[var_4_6]
				local var_4_8 = tbl_6
				local var_4_9 = tbl_6[var_4_7]

				var_4_9 = var_4_9 or 0
				var_4_8[var_4_7] = var_4_9 + 1
			else
				local var_4_10 = breed_name
				local var_4_11 = tbl_6
				local var_4_12 = tbl_6[var_4_10]

				var_4_12 = var_4_12 or 0
				var_4_11[var_4_10] = var_4_12 + 1
			end

			num = num + 1
		end
	end

	return num, arg_4_2
end

local function fn_5(self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0
	local breed_name = self.breed_name
	local amount = self.amount

	amount = amount or 1

	local difficulty_amount = self.difficulty_amount

	if not difficulty_amount then
		local var_5_4 = difficulty_amount[arg_5_1]

		var_5_4 = var_5_4 or difficulty_amount.hardest

		if type(var_5_4) == "table" then
			local var_5_5
			local var_5_6

			arg_5_2, var_5_6 = Math.next_random(arg_5_2, 1, #var_5_4)
			amount = var_5_4[var_5_6]
		else
			amount = var_5_4
		end
	elseif type(amount) == "table" then
		local var_5_7
		local var_5_8

		arg_5_2, var_5_8 = Math.next_random(arg_5_2, 1, #amount)
		amount = amount[var_5_8]
	end

	if type(breed_name) == "table" then
		local var_5_9
		local var_5_10

		arg_5_2, var_5_10 = Math.next_random(arg_5_2, 1, #breed_name)
		var_5_0 = breed_name[var_5_10]
	else
		var_5_0 = breed_name
	end

	local var_5_11 = amount
	local var_5_12 = tbl_6
	local var_5_13 = tbl_6[var_5_0]

	var_5_13 = var_5_13 or 0
	var_5_12[var_5_0] = var_5_13 + amount

	return var_5_11, arg_5_2
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local rank = DifficultySettings[arg_6_1].rank
	local var_6_1 = TerrorEventBlueprints.weaves[arg_6_0]

	for i = 1, #var_6_1 do
		local var_6_2 = var_6_1[i]
		local var_6_3 = var_6_2[1]

		if var_6_3 == "spawn_weave_special" then
			local var_6_4
			local var_6_5, var_6_6 = fn_4(var_6_2, rank, arg_6_3)

			arg_6_3 = var_6_6
			arg_6_2 = arg_6_2 + var_6_5
		elseif var_6_3 == "spawn_weave_special_event" then
			local var_6_7
			local var_6_8, var_6_9 = fn_5(var_6_2, arg_6_1, arg_6_3)

			arg_6_3 = var_6_9
			arg_6_2 = arg_6_2 + var_6_8
		elseif not (var_6_3 == "spawn" or var_6_3 ~= "spawn_at_raw") then
			arg_6_2 = arg_6_2 + fn_3(rank, var_6_2)
		elseif not (var_6_3 == "event_horde" or var_6_3 ~= "ambush_horde") then
			local composition_type = var_6_2.composition_type
			local num = rank - 1
			local var_6_12 = HordeCompositions[composition_type][num]

			fassert(var_6_12 ~= nil, string.format("[WeaveSettings] No horde composition found for '%s' on difficulty '%s'", composition_type, arg_6_1))

			for j = 1, #var_6_12 do
				local breeds = var_6_12[j].breeds

				for k = 1, #breeds, 2 do
					local var_6_14 = breeds[k]
					local var_6_15 = breeds[k + 1]

					if type(var_6_15) == "table" then
						var_6_15 = var_6_15[1]
					end

					arg_6_2 = arg_6_2 + var_6_15

					local var_6_16 = tbl_6
					local var_6_17 = tbl_6[var_6_14]

					var_6_17 = var_6_17 or 0
					var_6_16[var_6_14] = var_6_17 + var_6_15
				end
			end
		end
	end

	return arg_6_2, arg_6_3
end

local function fn_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	for i, v in ipairs(arg_7_0) do
		local terror_event_name = v.terror_event_name

		arg_7_3, i = fn_6(terror_event_name, arg_7_1, arg_7_3, arg_7_4)
	end

	return arg_7_3, arg_7_4
end

local function fn_8(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	for i, v in ipairs(arg_8_0) do
		arg_8_3, i = fn_6(v, arg_8_1, arg_8_3, arg_8_4)
	end

	return arg_8_3, arg_8_4
end

local function fn_9(self, arg_9_1, arg_9_2)
	-- function 9
	local objective_settings = self.objective_settings
	local var_9_1 = ObjectiveLists[objective_settings.objective_lists]

	for k, v in pairs(var_9_1) do
		for k_2, v_2 in pairs(v) do
			if k_2 == "kill_enemies" then
				v_2.score_multiplier = arg_9_1
			end

			if not v_2.is_scored then
				v_2.score_for_completion = arg_9_2
			end
		end
	end
end

local function fn_10(self)
	-- function 10
	local objective_settings = self.objective_settings
	local var_10_1 = ObjectiveLists[objective_settings.objective_lists]
	local num = 0

	for k, v in pairs(var_10_1) do
		for k_2, v_2 in pairs(v) do
			if not v_2.is_scored then
				num = num + 1
			end
		end
	end

	return num
end

local function fn_11(self, arg_11_1)
	-- function 11
	local objective_settings = self.objective_settings

	if not ObjectiveLists[not objective_settings and objective_settings.objective_lists] then
		return
	end

	local var_11_1 = fn_10(self)
	local flag

	flag = var_11_1 ~= 0 or not 0 or num_2

	local max = math.max(num - flag, num_3)
	local num_5 = flag / var_11_1
	local to_spawn = self.to_spawn
	local tbl = {}

	for k, v in pairs(DifficultySettings) do
		for k_2, v_2 in pairs(to_spawn[k]) do
			local var_11_7 = WeaveSettings.enemies_score_multipliers[k_2]

			var_11_7 = var_11_7 or WeaveSettings.enemies_score_multipliers.default

			local var_11_8 = tbl[k]

			var_11_8 = var_11_8 or 0
			tbl[k] = var_11_8 + var_11_7 * v_2
		end
	end

	local tbl_2 = {}

	for k_3, v_3 in pairs(tbl) do
		tbl_2[k_3] = max / (v_3 * num_4)
	end

	fn_9(self, tbl_2, num_5)
end

local tbl_7 = {}
local clock = os.clock()

for k_2, v_5 in pairs(WeaveSettings.templates) do
	local objectives_2 = v_5.objectives

	for i_5, v_6 in ipairs(objectives_2) do
		table.clear(tbl_7)

		local objective_type = v_6.objective_type
		local spawning_settings = v_6.spawning_settings
		local flag = not spawning_settings and spawning_settings.main_path_spawning
		local terror_events = v_6.terror_events

		terror_events = terror_events or tbl_7

		fassert(flag, "[WeaveSettings] No main path spawning in %q on objective: %q", k_2, i_5)

		local tbl_8 = {}
		local tbl_9 = {}

		for k_3, v_7 in pairs(DifficultySettings) do
			table.clear(tbl_6)

			local spawning_seed = v_6.spawning_seed
			local var_0_48 = fn_7(flag, k_3, k_2, 0, spawning_seed)

			if not objective_type and not tbl[objective_type] then
				var_0_48 = fn_8(terror_events, k_3, k_2, var_0_48, spawning_seed)
			end

			tbl_8[k_3] = var_0_48
			tbl_9[k_3] = table.clone(tbl_6)
		end

		v_6.to_spawn = tbl_9
		v_6.enemy_count = tbl_8

		if v_6.conflict_settings == "weave_disabled" then
			v_6.track_kills = true
			v_6.bar_cutoff = 100
			v_6.bar_multiplier = 0.25
		else
			v_6.bar_cutoff = 75
			v_6.bar_multiplier = 0.75
		end

		fn_11(v_6, k_2)
	end
end

print("TIME: " .. os.clock() - clock)
