-- chunkname: @scripts/managers/conflict_director/spawn_zone_baker.lua

require("scripts/managers/conflict_director/main_path_spawning_generator")

SpawnZoneBaker = class(SpawnZoneBaker)

local var_0_0 = InterestPointUnits
local var_0_1 = 1.5

SpawnZoneBaker.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.world = arg_1_1
	arg_1_0.nav_world = arg_1_2
	arg_1_0.level_analyzer = arg_1_3
	arg_1_0.spawn_zones_available = false

	arg_1_0:set_seed(arg_1_4)

	if not InterestPointUnitsLookup then
		ConflictUtils.generate_spawn_point_lookup(arg_1_1)
	end

	local var_1_0 = LevelHelper:current_level_settings().level_name

	if var_1_0 then
		if LevelResource.nested_level_count(var_1_0) > 0 then
			var_1_0 = LevelResource.nested_level_resource_name(var_1_0, 0)
		end

		local var_1_1 = var_1_0 .. "_patrol_waypoints"

		if Application.can_get("lua", var_1_1) then
			local var_1_2 = require(var_1_1)
			local var_1_3 = var_1_2.patrol_waypoints
			local var_1_4 = table.clone(var_1_2.boss_waypoints)
			local var_1_5 = var_1_2.event_waypoints

			arg_1_0.level_analyzer:store_patrol_waypoints(var_1_4, var_1_3, var_1_5)
		end

		local var_1_6 = arg_1_3.spawn_zone_data

		if var_1_6 then
			arg_1_0.zone_convert = {}
			arg_1_0.zones = var_1_6.zones
			arg_1_0.spawn_pos_lookup = var_1_6.position_lookup
			arg_1_0.num_main_zones = var_1_6.num_main_zones
			arg_1_0.total_main_path_length_unmodified = var_1_6.total_main_path_length

			local var_1_7 = var_1_6.main_paths

			arg_1_0.main_paths = var_1_7

			local var_1_8 = var_1_6.path_markers

			arg_1_0.path_markers = var_1_8

			local var_1_9 = var_1_6.crossroads
			local var_1_10, var_1_11 = arg_1_3:remove_crossroads_extra_path_branches(var_1_7, var_1_9, arg_1_0.total_main_path_length_unmodified, arg_1_0.zones, arg_1_0.num_main_zones, var_1_8)

			if var_1_10 then
				arg_1_0.num_main_zones = var_1_11
			end

			local var_1_12 = Managers.state.entity:system("door_system")
			local var_1_13 = {}
			local var_1_14 = 0

			for iter_1_0 = 1, #var_1_7 do
				local var_1_15 = var_1_7[iter_1_0]
				local var_1_16 = var_1_15.nodes

				for iter_1_1 = 1, #var_1_16 do
					local var_1_17 = var_1_16[iter_1_1]
					local var_1_18 = Vector3(var_1_17[1], var_1_17[2], var_1_17[3])

					if var_1_12:get_doors(var_1_18, var_0_1, var_1_13) > 0 then
						local var_1_19 = var_1_13[1]
						local var_1_20 = MainPathUtils.resolve_node_in_door(arg_1_2, var_1_18, var_1_19)

						if var_1_20 then
							var_1_18 = var_1_20
						else
							print("MainPathUtils.resolve_node_in_door: Error - was unable to resolve node in door at position", var_1_18)
						end
					end

					var_1_16[iter_1_1] = Vector3Box(var_1_18)
				end

				var_1_14 = var_1_14 + var_1_15.path_length
			end

			MainPathSpawningGenerator.inject_travel_dists(var_1_7, var_1_10)
			arg_1_3:store_path_markers(var_1_8)

			arg_1_0.total_main_path_length = var_1_14

			arg_1_3:store_main_paths(var_1_7)
			arg_1_3:brute_force_calc_zone_distances(arg_1_0.zones, arg_1_0.num_main_zones, arg_1_0.spawn_pos_lookup)

			if var_1_10 then
				Managers.state.game_mode:recalc_respawner_dist_due_to_crossroads()
			end

			arg_1_0:create_cover_points(var_1_6.cover_points, arg_1_3.cover_points_broadphase)

			arg_1_0.spawn_zones_available = true
		end
	end
end

SpawnZoneBaker._random = function (arg_2_0, ...)
	local var_2_0, var_2_1 = Math.next_random(arg_2_0.seed, ...)

	arg_2_0.seed = var_2_0

	return var_2_1
end

SpawnZoneBaker._random_dice_roll = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0, var_3_1 = LoadedDice.roll_seeded(arg_3_1, arg_3_2, arg_3_0.seed)

	arg_3_0.seed = var_3_0

	return var_3_1
end

SpawnZoneBaker.set_seed = function (arg_4_0, arg_4_1)
	fassert(arg_4_1 and type(arg_4_1) == "number", "Bad seed input!")

	arg_4_0.seed = arg_4_1
	arg_4_0._initial_seed = arg_4_1
end

SpawnZoneBaker._random_interval = function (arg_5_0, arg_5_1)
	if type(arg_5_1) == "table" then
		return arg_5_0:_random(arg_5_1[1], arg_5_1[2])
	else
		return arg_5_1
	end
end

local var_0_2 = {}
local var_0_3 = {}

SpawnZoneBaker._get_random_array_indices = function (arg_6_0, arg_6_1, arg_6_2)
	fassert(arg_6_2 <= arg_6_1, "Can't pick more elements than the size of the")
	fassert(arg_6_1 < 128, "Don't use this for large arrays, since it will be inefficient. It creates large tables then.")

	for iter_6_0 = 1, arg_6_1 do
		var_0_3[iter_6_0] = iter_6_0
	end

	for iter_6_1 = 1, arg_6_2 do
		local var_6_0 = arg_6_0:_random(1, arg_6_1)

		var_0_2[iter_6_1] = var_0_3[var_6_0]
		var_0_3[var_6_0] = var_0_3[arg_6_1]
		arg_6_1 = arg_6_1 - 1
	end

	return var_0_2
end

SpawnZoneBaker.loaded_spawn_zones_available = function (arg_7_0)
	return arg_7_0.spawn_zones_available
end

SpawnZoneBaker.create_cover_points = function (arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_1 then
		print("No cover points found")

		return
	end

	local var_8_0 = #arg_8_1
	local var_8_1 = Vector3.up()

	for iter_8_0 = 1, var_8_0, 5 do
		local var_8_2, var_8_3, var_8_4 = Script.temp_count()
		local var_8_5 = arg_8_1[iter_8_0]
		local var_8_6 = arg_8_1[iter_8_0 + 1]
		local var_8_7 = arg_8_1[iter_8_0 + 2]
		local var_8_8 = Vector3(var_8_5, var_8_6, var_8_7)
		local var_8_9 = arg_8_1[iter_8_0 + 3]
		local var_8_10 = arg_8_1[iter_8_0 + 4]
		local var_8_11 = Quaternion.look(Vector3(var_8_9, var_8_10, 0), var_8_1)
		local var_8_12 = World.spawn_unit(arg_8_0.world, "units/hub_elements/empty", var_8_8, var_8_11)

		Broadphase.add(arg_8_2, var_8_12, var_8_8, 1)
		Script.set_temp_count(var_8_2, var_8_3, var_8_4)
	end
end

SpawnZoneBaker.periodical = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0
	local var_9_1

	if arg_9_1 then
		var_9_0 = arg_9_0:_random(arg_9_2.min_low_dist, arg_9_2.max_low_dist)
		var_9_1 = arg_9_2.min_low_density + arg_9_0:_random() * (arg_9_2.max_low_density - arg_9_2.min_low_density)
		arg_9_1 = false
	else
		var_9_0 = arg_9_0:_random(arg_9_2.min_hi_dist, arg_9_2.max_hi_dist)
		var_9_1 = arg_9_2.min_hi_density + arg_9_0:_random() * (arg_9_2.max_hi_density - arg_9_2.min_hi_density)
		arg_9_1 = true
	end

	return var_9_0, var_9_1, arg_9_1
end

local function var_0_4(arg_10_0, arg_10_1, arg_10_2)
	for iter_10_0 = 1, arg_10_2 do
		arg_10_1[iter_10_0] = arg_10_0[iter_10_0]
	end
end

local function var_0_5(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0[arg_11_1]

	arg_11_0[arg_11_1] = arg_11_0[arg_11_2]
	arg_11_0[arg_11_2] = nil

	return var_11_0
end

local var_0_6 = {}
local var_0_7 = {}

SpawnZoneBaker.generate_spawns = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	if not InterestPointUnitsLookup then
		ConflictUtils.generate_spawn_point_lookup(arg_12_0.world)
	end

	if not arg_12_0.spawn_zones_available then
		print("No spawn zones where found, can't generate spawns")
	end

	arg_12_0._all_hi_data = {}
	arg_12_0._count_up = 0

	local var_12_0, var_12_1 = Managers.state.difficulty:get_difficulty()

	arg_12_0.composition_difficulty = DifficultyTweak.converters.composition(var_12_0, var_12_1)

	local var_12_2 = arg_12_0.zones
	local var_12_3 = arg_12_0.num_main_zones
	local var_12_4 = arg_12_0.zone_convert

	arg_12_5 = arg_12_5 or "default"

	local var_12_5 = ConflictDirectors[arg_12_5]
	local var_12_6 = arg_12_0._initial_seed
	local var_12_7 = MainPathSpawningGenerator.generate_great_cycles(var_12_5, arg_12_6, var_12_2, var_12_4, var_12_3, arg_12_1, var_12_6)
	local var_12_8 = {}
	local var_12_9 = {}
	local var_12_10 = {}
	local var_12_11 = {}
	local var_12_12 = {}
	local var_12_13 = PackSpawningDistribution.standard.distribution_method
	local var_12_14 = PackDistributions[var_12_13]
	local var_12_15 = #var_12_7

	for iter_12_0 = 1, var_12_15 do
		local var_12_16 = var_12_7[iter_12_0].zones
		local var_12_17 = #var_12_16
		local var_12_18 = 0
		local var_12_19 = 0
		local var_12_20

		if var_12_13 == "random" then
			for iter_12_1 = 1, var_12_17 do
				local var_12_21 = var_12_16[iter_12_1]
				local var_12_22 = arg_12_0:_random()

				var_12_21.density = var_12_22
				var_12_18 = var_12_18 + var_12_22
			end
		elseif var_12_13 == "periodical" then
			local var_12_23
			local var_12_24
			local var_12_25
			local var_12_26 = arg_12_0:_random() > 0.5
			local var_12_27, var_12_28, var_12_29 = arg_12_0:periodical(var_12_26, var_12_14)
			local var_12_30 = var_12_16[1]

			var_12_30.period_length = var_12_27
			var_12_30.hi = var_12_29

			local var_12_31 = arg_12_0:create_hi_data(var_12_30, var_12_30.pack_type)
			local var_12_32 = var_12_27

			var_12_19 = var_12_29 and 1 or 0

			local var_12_33
			local var_12_34

			for iter_12_2 = 1, var_12_17 do
				local var_12_35 = var_12_16[iter_12_2]

				var_12_35.hi_data = var_12_31

				if var_12_32 < iter_12_2 then
					local var_12_36

					var_12_36, var_12_28, var_12_29 = arg_12_0:periodical(var_12_29, var_12_14)
					var_12_34 = false
					var_12_32 = iter_12_2 + var_12_36 - 1

					if var_12_17 < var_12_32 then
						var_12_36 = var_12_17 - iter_12_2
						var_12_32 = var_12_17
					end

					var_12_35.period_length = var_12_36
					var_12_35.hi_data = var_12_31
					var_12_35.hi = var_12_29
					var_12_31 = arg_12_0:create_hi_data(var_12_35, var_12_35.pack_type)
					var_12_19 = var_12_19 + (var_12_29 and 1 or 0)
				elseif var_12_14.random_distribution then
					if var_12_29 then
						var_12_28 = var_12_14.min_hi_density + arg_12_0:_random() * (var_12_14.max_hi_density - var_12_14.min_hi_density)
					else
						var_12_28 = var_12_14.min_low_density + arg_12_0:_random() * (var_12_14.max_low_density - var_12_14.min_low_density)
					end
				elseif var_12_33 == var_12_14.zero_clamp_max_dist and not var_12_29 then
					var_12_34 = true
					var_12_28 = var_12_14.min_low_density + arg_12_0:_random() * (var_12_14.max_low_density - var_12_14.min_low_density)
				end

				var_12_33 = var_12_35.period_length and 1 or var_12_33 + 1

				if var_12_28 < var_12_14.zero_density_below and not var_12_34 then
					var_12_28 = 0
				end

				var_12_35.density = var_12_28
				var_12_35.hi = var_12_29
				var_12_18 = var_12_18 + var_12_28
			end
		end

		local var_12_37 = 0
		local var_12_38
		local var_12_39

		for iter_12_3 = 1, var_12_17 do
			local var_12_40 = var_12_16[iter_12_3]

			if var_12_38 ~= var_12_40.pack_spawning_setting then
				var_12_39 = var_12_40.pack_spawning_setting.basics.goal_density
			end

			var_12_37 = var_12_37 + var_12_39
		end

		if var_12_18 > 0 then
			local var_12_41 = var_12_37 / var_12_18
			local var_12_42 = 0

			print("-------------> JOW Perfect-density", var_12_37, "Sum density", var_12_18, "Normalized coefficient:", var_12_41)

			for iter_12_4 = 1, var_12_17 do
				local var_12_43 = var_12_16[iter_12_4]

				var_12_43.density = var_12_43.density * var_12_41

				if var_12_42 > 0 then
					var_12_43.density = var_12_43.density + var_12_42
					var_12_42 = 0
				end

				if var_12_43.density > 1 then
					var_12_42 = var_12_42 + var_12_43.density - 1
					var_12_43.density = 1
				end
			end

			if var_12_13 == "periodical" then
				arg_12_0:inject_special_packs(var_12_19, var_12_16)
			end

			local var_12_44 = 1

			for iter_12_5 = 1, var_12_17 do
				local var_12_45 = var_12_16[iter_12_5]
				local var_12_46, var_12_47 = var_12_45.density, var_12_45.outer

				for iter_12_6 = 1, #var_12_47 do
					local var_12_48 = var_12_47[iter_12_6]

					var_12_46 = math.clamp(var_12_46 * var_12_44 + (1 - var_12_44) * (2 * arg_12_0:_random() - 1), 0, 1)
					var_12_48.density = var_12_46
					var_12_48.hi_data = var_12_45.hi_data
					var_12_48.hi = var_12_45.hi
				end
			end

			arg_12_0:populate_spawns_by_rats(var_12_38, var_12_8, var_12_9, var_12_10, var_12_11, var_12_12, var_12_16, var_12_38, arg_12_4, nil, true, nil)

			for iter_12_7 = 1, var_12_17 do
				local var_12_49 = var_12_16[iter_12_7]
				local var_12_50 = var_12_49.outer
				local var_12_51 = var_12_49.pack_spawning_setting
				local var_12_52 = var_12_51.basics.clamp_outer_zones_used

				if var_12_52 then
					local var_12_53 = #var_12_50
					local var_12_54 = var_12_53 - var_12_52

					if var_12_54 > 0 then
						var_0_4(var_12_50, var_0_6, var_12_53)

						local var_12_55 = #var_12_50

						for iter_12_8 = 1, var_12_54 do
							var_0_5(var_0_6, arg_12_0:_random(1, var_12_55), var_12_55)

							var_12_55 = var_12_55 - 1
						end

						var_12_50 = var_0_6
					end
				end

				arg_12_0:populate_spawns_by_rats(var_12_51, var_12_8, var_12_9, var_12_10, var_12_11, var_12_12, var_12_50, arg_12_3, 0, var_12_49.pack_type, nil, var_12_49)
			end
		else
			print(sprintf("Spawn density in great_cycle %d is 0, num cycle zones: %d ", iter_12_0, var_12_17))
		end
	end

	local var_12_56 = {}

	for iter_12_9 = var_12_3 + 1, #var_12_2 do
		local var_12_57 = var_12_2[iter_12_9]
		local var_12_58 = var_12_57.parent_zone_id

		if not var_12_58 then
			print("Missing parent zone id for island-zone", iter_12_9)
			table.dump(var_12_57, "ISLAND ZONE", 2)
		end

		local var_12_59 = var_12_58 and arg_12_0.level_analyzer:get_zone_from_unique_id(var_12_4, var_12_58)

		if var_12_59 then
			local var_12_60 = var_12_59.conflict_setting
			local var_12_61 = var_12_59.pack_spawning_setting
			local var_12_62 = var_12_59.pack_type
			local var_12_63 = var_12_61.area_density_coefficient

			if not var_12_57.on_roof or BreedPacks[var_12_62].roof_spawning_allowed then
				local var_12_64 = var_12_57.sub
				local var_12_65 = var_12_57.sub_areas

				for iter_12_10 = 1, #var_12_64 do
					local var_12_66 = var_12_64[iter_12_10]
					local var_12_67 = var_12_65[iter_12_10]
					local var_12_68 = arg_12_0:_random()
					local var_12_69 = math.floor(var_12_67 * var_12_68 * var_12_63)
					local var_12_70 = {
						total_area = 0,
						nodes = var_12_66,
						area = var_12_67,
						outer = {},
						pack_type = var_12_62,
						pack_spawning_setting = var_12_61,
						conflict_setting = var_12_60,
						unique_zone_id = var_12_57.unique_zone_id
					}

					var_12_70.period_length = 1
					var_12_70.hi = false
					var_12_70.island = true
					var_12_70.density = var_12_68
					var_12_70.parent_zone = var_12_59

					arg_12_0:create_hi_data(var_12_70, var_12_62)

					var_12_56[#var_12_56 + 1] = var_12_70
					var_12_70.unique_zone_id = #var_12_56

					local var_12_71 = var_12_59.islands

					if not var_12_71 then
						var_12_71 = {}
						var_12_59.islands = var_12_71
					end

					var_12_71[#var_12_71 + 1] = var_12_70.unique_zone_id

					if var_12_69 > 0 then
						arg_12_0:spawn_amount_rats(var_12_8, var_12_9, var_12_10, var_12_11, var_12_12, var_12_66, var_12_69, var_12_62, var_12_67, var_12_70)
					end
				end
			end
		end
	end

	fassert(#var_12_8 == #var_12_9, "Mismatching sizes!")

	arg_12_0.great_cycles = var_12_7
	arg_12_0.island_zones = var_12_56

	table.clear(var_0_7)

	return var_12_8, var_12_9, var_12_10, var_12_11, var_12_12
end

SpawnZoneBaker.inject_special_packs = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2[1].pack_spawning_setting.roaming_set.breed_packs_peeks_overide_chance

	if not var_13_0 then
		return
	end

	local var_13_1 = arg_13_0:_random() * (var_13_0[2] - var_13_0[1]) + var_13_0[1]
	local var_13_2 = math.floor(arg_13_1 * var_13_1)

	if var_13_2 <= 0 or arg_13_1 <= 0 then
		return
	end

	local var_13_3 = arg_13_0:_get_random_array_indices(arg_13_1, var_13_2)
	local var_13_4 = {}

	for iter_13_0 = 1, var_13_2 do
		var_13_4[var_13_3[iter_13_0]] = true
	end

	local var_13_5 = #arg_13_2
	local var_13_6 = 1
	local var_13_7 = 1

	while var_13_6 < var_13_5 do
		local var_13_8 = arg_13_2[var_13_6]
		local var_13_9 = var_13_8.period_length

		if var_13_9 and var_13_8.hi then
			if var_13_4[var_13_7] then
				local var_13_10 = var_13_8.pack_spawning_setting.roaming_set
				local var_13_11 = var_13_10.breed_packs_override

				if var_13_11 then
					local var_13_12 = var_13_10.breed_packs_override_loaded_dice
					local var_13_13 = var_13_12[1]
					local var_13_14 = var_13_12[2]
					local var_13_15 = arg_13_0:_random_dice_roll(var_13_13, var_13_14)
					local var_13_16 = var_13_11[var_13_15][1]
					local var_13_17 = var_13_11[var_13_15][3]
					local var_13_18 = arg_13_0:create_hi_data(var_13_8, var_13_16)

					for iter_13_1 = var_13_6, var_13_6 + var_13_9 - 1 do
						local var_13_19 = arg_13_2[iter_13_1]

						var_13_19.pack_type = var_13_16
						var_13_19.density_coefficient = var_13_17
						var_13_19.hi_data = var_13_18
					end
				end

				var_13_6 = var_13_6 + var_13_9 - 1
			end

			var_13_7 = var_13_7 + 1
		end

		var_13_6 = var_13_6 + 1
	end
end

SpawnZoneBaker.create_hi_data = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0
	local var_14_1 = BreedPacks[arg_14_2].zone_checks

	if var_14_1 then
		arg_14_0._count_up = arg_14_0._count_up + 1
		var_14_0 = {
			id = arg_14_0._count_up
		}
		arg_14_1.hi_data = var_14_0

		local var_14_2 = arg_14_1.hi and var_14_1.clamp_breeds_hi or var_14_1.clamp_breeds_low

		if var_14_2 then
			local var_14_3 = var_14_2[arg_14_0.composition_difficulty]

			if var_14_3 then
				local var_14_4 = {}

				for iter_14_0 = 1, #var_14_3 do
					local var_14_5 = var_14_3[iter_14_0]
					local var_14_6 = arg_14_0:_random_interval(var_14_5[1])
					local var_14_7 = var_14_5[2]
					local var_14_8 = var_14_5[3]

					var_14_4[var_14_7] = {
						switch_count = 0,
						count = 0,
						max_amount = var_14_6,
						switch_breed = var_14_8,
						hi = arg_14_1.hi
					}
				end

				var_14_0.breed_count = var_14_4
			end
		end

		arg_14_0._all_hi_data[#arg_14_0._all_hi_data + 1] = var_14_0
	end

	return var_14_0
end

SpawnZoneBaker.populate_spawns_by_rats = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12)
	local var_15_0 = #arg_15_7
	local var_15_1 = 0
	local var_15_2 = 0
	local var_15_3 = 10

	for iter_15_0 = 1, var_15_0 do
		local var_15_4 = arg_15_7[iter_15_0]
		local var_15_5 = var_15_4.pack_spawning_setting or arg_15_1
		local var_15_6 = var_15_5.basics
		local var_15_7 = arg_15_11 and var_15_4.density_coefficient or var_15_5.area_density_coefficient or arg_15_8
		local var_15_8 = arg_15_11 and var_15_6.length_density_coefficient or arg_15_9
		local var_15_9 = arg_15_11 and var_15_6.clamp_main_path_zone_area
		local var_15_10 = var_15_4.nodes

		if var_15_10 then
			local var_15_11 = arg_15_11 and var_15_9 > var_15_4.area and var_15_9 or var_15_4.area
			local var_15_12 = var_15_11 * var_15_4.density * var_15_7 + var_15_1
			local var_15_13 = math.floor(var_15_12)

			var_15_1 = var_15_12 - var_15_13

			local var_15_14 = var_15_3 * var_15_4.density * var_15_8 + var_15_2
			local var_15_15 = math.floor(var_15_14)

			var_15_2 = var_15_14 - var_15_15

			local var_15_16 = var_15_13 + var_15_15

			if var_15_16 > 0 then
				local var_15_17, var_15_18, var_15_19 = Script.temp_count()

				var_15_4.wanted_spawns = arg_15_0:spawn_amount_rats(arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, var_15_10, var_15_16, arg_15_10 or var_15_4.pack_type, var_15_11, arg_15_12 or var_15_4)

				Script.set_temp_count(var_15_17, var_15_18, var_15_19)
			end
		else
			print("Warning: missing nodes! in zones")
		end
	end
end

SpawnZoneBaker._generate_pack_members = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = BreedPacksBySize[arg_16_1][arg_16_2]
	local var_16_1 = var_16_0.prob
	local var_16_2 = var_16_0.alias
	local var_16_3 = arg_16_0:_random_dice_roll(var_16_1, var_16_2)
	local var_16_4 = var_16_0.packs[var_16_3]
	local var_16_5 = table.clone(var_16_4.members)

	var_16_5.type = arg_16_1

	local var_16_6 = arg_16_3 and arg_16_3.hi_data

	if var_16_6 and var_16_6.breed_count then
		local var_16_7 = var_16_6.breed_count

		for iter_16_0 = 1, arg_16_2 do
			local var_16_8 = var_16_5[iter_16_0]

			if not var_16_8.name then
				var_16_8 = var_16_8[math.random(1, #var_16_8)]
				var_16_5[iter_16_0] = var_16_8
			end

			local var_16_9 = var_16_7[var_16_8.name]

			if var_16_9 then
				var_16_9.count = var_16_9.count + 1

				if var_16_9.count > var_16_9.max_amount then
					var_16_5[iter_16_0] = var_16_9.switch_breed
					var_16_9.switch_count = var_16_9.switch_count + 1
				end
			end
		end
	end

	return var_16_5
end

local var_0_8 = #var_0_0

SpawnZoneBaker.spawn_amount_rats = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
	local var_17_0 = Vector3.normalize
	local var_17_1 = var_0_0
	local var_17_2 = InterestPointPickListIndexLookup
	local var_17_3 = arg_17_0.nav_world
	local var_17_4 = arg_17_0.spawn_pos_lookup
	local var_17_5 = #arg_17_1
	local var_17_6 = 0
	local var_17_7 = #arg_17_6
	local var_17_8 = 0

	while arg_17_7 > 0 do
		var_17_8 = var_17_8 + 1

		local var_17_9 = var_17_2[math.min(arg_17_7, var_0_8)]
		local var_17_10 = InterestPointPickList[arg_17_0:_random(var_17_9)]
		local var_17_11 = var_17_1[var_17_10]
		local var_17_12 = #var_17_11
		local var_17_13 = var_17_11[var_17_12 == 1 and 1 or arg_17_0:_random(var_17_12)]

		for iter_17_0 = 1, 10 do
			local var_17_14, var_17_15, var_17_16 = Script.temp_count()
			local var_17_17 = arg_17_0:_random(var_17_7)
			local var_17_18 = arg_17_6[var_17_17]

			if not var_0_7[var_17_18] then
				local var_17_19 = var_17_4[arg_17_6[var_17_17]]
				local var_17_20 = Vector3(var_17_19[1], var_17_19[2], var_17_19[3])
				local var_17_21 = arg_17_0:_random() * 2 * math.pi
				local var_17_22 = Quaternion(Vector3.up(), var_17_21)
				local var_17_23 = ConflictUtils.interest_point_outside_nav_mesh(var_17_3, var_17_13, var_17_20, var_17_22)
				local var_17_24 = 0

				while var_17_23 and var_17_24 < 3 do
					var_17_24 = var_17_24 + 1
					var_17_20 = var_17_20 + var_17_0(var_17_20 - var_17_23)
					var_17_23 = ConflictUtils.interest_point_outside_nav_mesh(var_17_3, var_17_13, var_17_20, var_17_22)
				end

				if not var_17_23 then
					fassert(var_17_13, "what the - no spawn point unit name?")

					local var_17_25 = arg_17_0:_generate_pack_members(arg_17_8, var_17_10, arg_17_10, var_17_13, var_17_20)

					var_17_5 = var_17_5 + 1
					arg_17_1[var_17_5] = Vector3Box(var_17_20)
					arg_17_2[var_17_5] = var_17_13
					arg_17_3[var_17_5] = var_17_21
					arg_17_4[var_17_5] = var_17_25
					arg_17_5[var_17_5] = arg_17_10
					arg_17_7 = arg_17_7 - var_17_10
					var_0_7[var_17_18] = true

					break
				end
			end

			Script.set_temp_count(var_17_14, var_17_15, var_17_16)
		end

		var_17_6 = var_17_6 + 1

		if var_17_6 > 100 then
			print("cannot find place to spawn rats")

			break
		end
	end

	table.clear(var_0_7)

	return var_17_8
end

SpawnZoneBaker.get_zone_segment_from_travel_dist = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.zones
	local var_18_1 = arg_18_0.num_main_zones

	for iter_18_0 = 1, var_18_1 do
		if arg_18_1 < var_18_0[iter_18_0].travel_dist - 5 then
			local var_18_2 = iter_18_0 > 1 and iter_18_0 - 1 or iter_18_0
			local var_18_3 = var_18_0[var_18_2]
			local var_18_4 = arg_18_0.zone_convert[var_18_2]

			return var_18_2, var_18_3, var_18_4
		end
	end

	return var_18_1, var_18_0[var_18_1], arg_18_0.zone_convert[var_18_1]
end

SpawnZoneBaker.draw_zones = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = false
	local var_19_1 = true

	if arg_19_0.gui then
		World.destroy_gui(arg_19_0.world, arg_19_0.gui)

		arg_19_0.gui = nil

		return
	else
		arg_19_0.gui = World.create_world_gui(arg_19_0.world, Matrix4x4.identity(), 1, 1)
	end

	local var_19_2 = arg_19_0.zone_convert
	local var_19_3 = arg_19_0.gui
	local var_19_4 = 64
	local var_19_5 = arg_19_0.zones
	local var_19_6 = arg_19_0.spawn_pos_lookup
	local var_19_7 = {}

	if var_19_0 then
		for iter_19_0 = 1, 16 do
			local var_19_8 = heatmap_colors_lookup[iter_19_0]

			var_19_7[iter_19_0] = Color(200, var_19_8[1], var_19_8[2], var_19_8[3])
		end
	end

	for iter_19_1 = math.clamp(arg_19_2 or 1, 1, #var_19_5), #var_19_5 do
		local var_19_9 = var_19_5[iter_19_1]
		local var_19_10 = var_19_9.sub
		local var_19_11
		local var_19_12

		if var_19_0 then
			var_19_12 = math.floor((var_19_2[iter_19_1] and var_19_2[iter_19_1].density or 1) * 16)
		else
			local var_19_13 = 92 + 63 * (iter_19_1 % 3)
			local var_19_14 = var_19_13 / 2

			var_19_11 = {
				Color(var_19_4, 0, var_19_13, 0),
				Color(var_19_4, 0, 0, var_19_13),
				Color(var_19_4, var_19_13, 0, 0),
				Color(var_19_4, var_19_13, var_19_13, 0),
				Color(var_19_4, 0, var_19_13, var_19_13),
				Color(var_19_4, var_19_13, 0, var_19_13),
				Color(var_19_4, var_19_13, var_19_14, 0),
				Color(var_19_4, var_19_13, 0, var_19_14),
				Color(var_19_4, 0, var_19_14, var_19_13),
				Color(var_19_4, var_19_14, 0, var_19_13)
			}
		end

		if var_19_1 then
			local var_19_15 = var_19_6[var_19_10[1][1]]
			local var_19_16 = string.format("%d %.1f <- %.1f", iter_19_1, var_19_9.travel_dist or 0, var_19_9.old_travel_dist or 0)

			Debug.world_sticky_text(var_19_15, var_19_16, var_19_11[1])
		end

		local var_19_17 = Vector3(0, 0, 0.1)

		for iter_19_2 = 1, #var_19_10 do
			local var_19_18 = var_19_10[iter_19_2]

			if var_19_18 then
				for iter_19_3 = 1, #var_19_18 do
					local var_19_19 = var_19_18[iter_19_3]
					local var_19_20, var_19_21, var_19_22 = Script.temp_count()
					local var_19_23 = var_19_6[var_19_19]
					local var_19_24 = GwNavTraversal.get_seed_triangle(arg_19_1, Vector3(var_19_23[1], var_19_23[2], var_19_23[3]), 0.5, 0.5)

					if var_19_24 then
						local var_19_25, var_19_26, var_19_27 = GwNavTraversal.get_triangle_vertices(arg_19_1, var_19_24)

						if var_19_0 then
							Gui.triangle(var_19_3, var_19_25 + var_19_17, var_19_26 + var_19_17, var_19_27 + var_19_17, 2, var_19_7[var_19_12])
						else
							local var_19_28 = var_19_11[iter_19_2] or Colors.get_indexed((iter_19_1 * 7 + iter_19_2 + 5) % 32 + 1)

							Gui.triangle(var_19_3, var_19_25 + var_19_17, var_19_26 + var_19_17, var_19_27 + var_19_17, 2, var_19_28)
						end
					end

					Script.set_temp_count(var_19_20, var_19_21, var_19_22)
				end
			end
		end

		if arg_19_2 then
			break
		end
	end
end

SpawnZoneBaker.show_debug = function (arg_20_0, arg_20_1)
	if arg_20_1 then
		if not arg_20_0.graph then
			arg_20_0:draw_pack_density_graph()
		end

		arg_20_0.graph:set_active(true)
	elseif arg_20_0.graph then
		arg_20_0.graph:set_active(false)
	end

	return true
end

SpawnZoneBaker.execute_debug = function (arg_21_0)
	QuickDrawerStay:reset()
	Managers.state.conflict:respawn_level(script_data.debug_pacing_seed)

	arg_21_0.plain_zone_list = nil
	arg_21_0._breed_pack_legend = nil
end

function print_zone_list(arg_22_0)
	for iter_22_0 = 1, #arg_22_0 do
		local var_22_0 = arg_22_0[iter_22_0]
		local var_22_1 = math.clamp(var_22_0.area * 0.5, 0, 100)

		if var_22_0.hi_data then
			local var_22_2 = var_22_0.hi_data.id

			print(string.format("Zone: %d, hi: %s, hi-id: %d, Density: %.1f, Area: %.1f", iter_22_0, tostring(var_22_0.hi), var_22_2, var_22_0.density, var_22_1), "con:", var_22_0.conflict_setting.name, "period_len:", var_22_0.period_length or "--", "data:", var_22_0.hi_data and "Y" or "N", string.format("Director / Packtype: %s / %s ", var_22_0.conflict_setting.name, var_22_0.pack_type))

			local var_22_3 = var_22_0.outer

			for iter_22_1 = 1, #var_22_3 do
				local var_22_4 = var_22_3[iter_22_1]

				if var_22_4.hi_data then
					if var_22_2 ~= var_22_4.hi_data.id then
						print(string.format("BAD OUTER=%d hi-id: %d != %d", iter_22_1, var_22_2, var_22_4.hi_data.id))
					else
						print(string.format("outer=%d hi=%s hi-id: %d ", iter_22_1, tostring(var_22_4.hi), var_22_2))
					end
				else
					print(string.format("outer=%d hi=-- hi-id: -- NO CLAMPING IN PACK_TYPE %s", iter_22_1, tostring(var_22_4.pack_type)))
				end
			end
		else
			print(string.format("Zone: %d, hi: %s, hi-id: --, Density: %.1f, Area: %.1f", iter_22_0, tostring(var_22_0.hi), var_22_0.density, var_22_1), "con:", var_22_0.conflict_setting.name, "period_len:", var_22_0.period_length or "--", "data:", var_22_0.hi_data and "Y" or "N", string.format("Director / Packtype: %s / %s ", var_22_0.conflict_setting.name, var_22_0.pack_type))
		end
	end
end

SpawnZoneBaker.debug_print_hi_data = function (arg_23_0)
	local var_23_0
	local var_23_1 = arg_23_0.great_cycles

	for iter_23_0 = 1, #var_23_1 do
		local var_23_2 = var_23_1[iter_23_0]

		print("Great Cycle", iter_23_0, "-------------")

		local var_23_3 = var_23_2.zones

		for iter_23_1 = 1, #var_23_3 do
			local var_23_4 = var_23_3[iter_23_1]
			local var_23_5 = var_23_4.hi_data

			if var_23_5 ~= var_23_0 then
				local var_23_6 = (var_23_4.hi and "Hi" or "Low") .. "-data for zone:" .. tostring(iter_23_1) .. " -> " .. iter_23_1 + var_23_4.period_length - 1

				if var_23_5 then
					local var_23_7 = var_23_5.breed_count

					if var_23_7 then
						table.dump(var_23_7, var_23_6, 1)
					end
				end
			end

			var_23_0 = var_23_5
		end
	end

	for iter_23_2 = 1, #arg_23_0._all_hi_data do
		local var_23_8 = arg_23_0._all_hi_data[iter_23_2]
		local var_23_9 = var_23_8.breed_count

		if var_23_9 then
			for iter_23_3, iter_23_4 in pairs(var_23_9) do
				print("Hidata id:", var_23_8.id, iter_23_4.hi and "HI" or "LOW", "count:", iter_23_4.count, "switched:", iter_23_4.switch_count, "max:", iter_23_4.max_amount, "breed:", iter_23_3, "switched to:", iter_23_4.switch_breed.name)
			end
		else
			print("Hidata id:", var_23_8.id, " (no breed_count)")
		end
	end
end

SpawnZoneBaker.draw_pack_density_graph = function (arg_24_0)
	if not arg_24_0.graph then
		arg_24_0.graph = Managers.state.debug.graph_drawer:create_graph("spawn density", {
			"distance",
			"density"
		})
		arg_24_0.graph.visual_frame.y_max = 100
		arg_24_0.graph.scroll_lock.vertical = false
		arg_24_0.graph.scroll_lock.left = false
	end

	local var_24_0 = arg_24_0.graph

	if not var_24_0.active then
		var_24_0:set_active(true)
	end

	local var_24_1 = arg_24_0.zones[1].sub_zone_length
	local var_24_2 = 0
	local var_24_3 = arg_24_0.great_cycles
	local var_24_4 = #var_24_3

	if script_data.debug_zone_baker then
		arg_24_0:debug_print_zones()
	end

	var_24_0:set_plot_color("density", "maroon", "crimson")

	if var_24_4 > 0 then
		local var_24_5
		local var_24_6 = var_24_3[1].zones[1].conflict_setting.pack_spawning.roaming_set.breed_packs

		for iter_24_0 = 1, var_24_4 do
			local var_24_7 = var_24_3[iter_24_0].zones

			if iter_24_0 > 1 then
				arg_24_0.graph:add_annotation({
					text = "Cycle",
					live = true,
					y = 105,
					color = "green",
					x = var_24_2
				})
			end

			for iter_24_1 = 1, #var_24_7 do
				local var_24_8 = var_24_7[iter_24_1]
				local var_24_9 = var_24_8.density

				if var_24_6 ~= var_24_8.pack_type then
					arg_24_0.graph:add_annotation({
						text = "O",
						live = true,
						color = "lawn_green",
						x = var_24_2,
						y = var_24_9 * 100
					})
				elseif var_24_8.hi then
					arg_24_0.graph:add_annotation({
						text = "H",
						live = true,
						color = "lawn_green",
						x = var_24_2,
						y = var_24_9 * 100
					})
				end

				if var_24_5 ~= var_24_8.conflict_setting then
					var_24_5 = var_24_8.conflict_setting
					var_24_6 = var_24_5.pack_spawning.roaming_set.breed_packs

					arg_24_0.graph:add_annotation({
						live = true,
						y = 110,
						color = "orange",
						x = var_24_2,
						text = var_24_5.name
					})
				end

				var_24_0:add_point(var_24_2, var_24_9 * 100, "density")

				local var_24_10 = arg_24_0.spawn_pos_lookup[var_24_8.nodes[1]]
				local var_24_11 = Vector3(var_24_10[1], var_24_10[2], var_24_10[3])
				local var_24_12 = math.sqrt(var_24_8.total_area) / 5
				local var_24_13 = Vector3(var_24_12, var_24_12, var_24_12)
				local var_24_14 = Matrix4x4.from_quaternion_position(Quaternion.look(Vector3.up()), var_24_11)

				QuickDrawerStay:box(var_24_14, var_24_13, Color(255, 0, 200, 0))
				QuickDrawerStay:sphere(var_24_11, 7 * var_24_9)

				var_24_2 = var_24_2 + var_24_1
			end
		end
	end

	local var_24_15 = arg_24_0.level_analyzer.boss_event_list
	local var_24_16 = 60

	for iter_24_2 = 1, #var_24_15 do
		local var_24_17 = var_24_15[iter_24_2]
		local var_24_18 = var_24_17[3]
		local var_24_19 = var_24_17[2]
		local var_24_20 = var_24_17[4]

		arg_24_0.graph:add_annotation({
			live = true,
			x = var_24_18,
			y = var_24_16,
			text = var_24_19,
			color = var_24_20
		})

		var_24_16 = var_24_16 + 7

		if var_24_16 > 70 then
			var_24_16 = 30
		end
	end

	local var_24_21 = {
		text = "PLAYER",
		live = true,
		y = 50,
		color = "green",
		x = 0
	}

	arg_24_0.graph:add_annotation(var_24_21)

	arg_24_0.player_annotation = var_24_21
end

SpawnZoneBaker.draw_player_in_density_graph = function (arg_25_0, arg_25_1)
	if arg_25_0.graph then
		if not arg_25_0.player_annotation then
			local var_25_0 = {
				text = "PLAYER",
				live = true,
				y = 50,
				color = "green",
				x = 0
			}

			arg_25_0.graph:add_annotation(var_25_0)

			arg_25_0.player_annotation = var_25_0
		end

		arg_25_0.graph:move_annotation(arg_25_0.player_annotation, arg_25_1)
	end
end

SpawnZoneBaker.draw_func1 = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	local var_26_0 = arg_26_1.island and "ISLAND" or "MAIN"
	local var_26_1 = string.format("%d %s: %d %s", arg_26_3, var_26_0, arg_26_2, arg_26_1.pack_spawning_setting.name or "?")

	Gui.text(arg_26_0._gui, var_26_1, "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_26_4 + 200, arg_26_5, 1000))
end

SpawnZoneBaker._draw_zone = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = Vector3(0, 0, 1.5)
	local var_27_1 = arg_27_1.nodes

	for iter_27_0 = 1, #var_27_1 do
		local var_27_2 = var_27_1[iter_27_0]
		local var_27_3 = arg_27_0.spawn_pos_lookup[var_27_2]
		local var_27_4 = Vector3(var_27_3[1], var_27_3[2], var_27_3[3])

		QuickDrawer:circle(var_27_4 + var_27_0, 0.5, var_27_0, arg_27_2)
	end
end

local var_0_9 = true

SpawnZoneBaker.draw_func2 = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	local var_28_0 = arg_28_0._breed_pack_legend
	local var_28_1 = arg_28_1.hi_data
	local var_28_2 = var_28_0[arg_28_1.pack_type] .. "(" .. var_28_1.id .. ")"
	local var_28_3 = arg_28_1.outer

	for iter_28_0 = 1, #var_28_3 do
		var_28_2 = var_28_2 .. " " .. var_28_0[arg_28_1.pack_type] .. "(" .. arg_28_1.hi_data.id .. ") "
	end

	local var_28_4 = arg_28_1.islands

	if var_28_4 then
		var_28_2 = var_28_2 .. " <--- "

		for iter_28_1 = 1, #var_28_4 do
			local var_28_5 = var_28_4[iter_28_1]
			local var_28_6 = arg_28_0.island_zones[var_28_5]

			var_28_2 = var_28_2 .. " " .. var_28_0[var_28_6.pack_type] .. "(" .. var_28_6.hi_data.id .. ") "
		end
	end

	local var_28_7 = arg_28_6 and Color(200, 200, 0) or arg_28_1.hi and Color(255, 255, 255) or Color(175, 175, 175)

	if var_0_9 and arg_28_6 then
		arg_28_0:_draw_zone(arg_28_1, var_28_7)

		if arg_28_1.islands then
			for iter_28_2 = 1, #arg_28_1.islands do
				local var_28_8 = arg_28_0.island_zones[var_28_4[iter_28_2]]

				if var_28_8 then
					arg_28_0:_draw_zone(var_28_8, Color(255, 0, 128))
				end
			end
		end

		local var_28_9 = arg_28_1.outer

		for iter_28_3 = 1, #var_28_9 do
			arg_28_0:_draw_zone(var_28_9[iter_28_3], Color(55, 200 - (iter_28_3 - 1) * 24, (iter_28_3 - 1) * 24))
		end

		local var_28_10 = Managers.state.conflict:spawned_units_by_breed_table()

		var_28_2 = var_28_2 .. ConflictUtils.display_number_of_breeds_in_segment("BREEDS: ", var_28_10, arg_28_1)
	end

	local var_28_11 = arg_28_1.island and "ISLAND" or "MAIN"
	local var_28_12 = string.format("%s: %d %s", var_28_11, arg_28_2, var_28_2)

	Gui.text(arg_28_0._gui, var_28_12, "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_28_4 + 200, arg_28_5, 1000), var_28_7)
end

SpawnZoneBaker._draw_legend = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	Gui.text(arg_29_0._gui, string.format("LEGEND OF PACK-TYPES"), "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_29_2, arg_29_3, 1000))

	arg_29_3 = arg_29_3 - 30

	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		Gui.text(arg_29_0._gui, string.format("%s = %s", iter_29_0, iter_29_1), "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_29_2, arg_29_3, 1000))

		arg_29_3 = arg_29_3 - 20
	end
end

SpawnZoneBaker.draw_zone_info_on_screen = function (arg_30_0)
	if not arg_30_0._gui then
		arg_30_0._gui = World.create_screen_gui(arg_30_0.world, "immediate")
	end

	if not arg_30_0.plain_zone_list then
		local var_30_0 = {}
		local var_30_1 = arg_30_0.great_cycles

		for iter_30_0 = 1, #var_30_1 do
			local var_30_2 = var_30_1[iter_30_0].zones

			for iter_30_1 = 1, #var_30_2 do
				local var_30_3 = var_30_2[iter_30_1]

				var_30_0[#var_30_0 + 1] = var_30_3
			end
		end

		local var_30_4 = arg_30_0.island_zones

		for iter_30_2 = 1, #var_30_4 do
			local var_30_5 = var_30_4[iter_30_2]

			var_30_0[#var_30_0 + 1] = var_30_5
		end

		arg_30_0.plain_zone_list = var_30_0
	end

	if not arg_30_0._breed_pack_legend then
		local var_30_6 = {}
		local var_30_7 = 1

		for iter_30_3, iter_30_4 in pairs(BreedPacks) do
			local var_30_8 = string.char(65 + var_30_7)

			var_30_6[iter_30_3] = var_30_8 .. var_30_8 .. var_30_8
			var_30_7 = var_30_7 + 1
		end

		arg_30_0._breed_pack_legend = var_30_6
	end

	local var_30_9
	local var_30_10

	if Application.screen_resolution then
		var_30_9, var_30_10 = Application.screen_resolution()
	else
		var_30_9, var_30_10 = Application.resolution()
	end

	local var_30_11 = arg_30_0.plain_zone_list
	local var_30_12 = #var_30_11
	local var_30_13 = 60
	local var_30_14 = 640
	local var_30_15 = 40
	local var_30_16 = var_30_9 - 100
	local var_30_17 = var_30_10 - 100
	local var_30_18 = 40
	local var_30_19 = var_30_10 - 40

	Gui.rect(arg_30_0._gui, Vector3(var_30_14, var_30_15, UILayer.transition), Vector2(var_30_16, var_30_17), Color(var_30_13, 40, 40, 40))
	arg_30_0:_draw_legend(arg_30_0._breed_pack_legend, var_30_9 - 450, var_30_19 - 40)
	Gui.text(arg_30_0._gui, string.format("Spawn Zone Baker. #zones=%d", var_30_12), "materials/fonts/arial", 14, "arial", Vector3(var_30_18 + 15, var_30_19 - 40, 1000))

	local var_30_20 = 40
	local var_30_21 = math.floor(var_30_20 / 2)
	local var_30_22 = Managers.state.conflict.main_path_info
	local var_30_23, var_30_24, var_30_25 = arg_30_0:get_zone_segment_from_travel_dist(var_30_22.ahead_travel_dist)

	Debug.text("zone:%d, unique_id %d %s", var_30_23, var_30_25.unique_zone_id, var_30_25.pack_type)

	local var_30_26 = var_30_23 <= var_30_21 and 1 or var_30_23 - var_30_21
	local var_30_27 = var_30_19 - 40
	local var_30_28 = 1

	while var_30_28 < var_30_20 and var_30_26 <= var_30_12 do
		local var_30_29 = var_30_11[var_30_26]

		if var_30_29 then
			arg_30_0:draw_func2(var_30_29, var_30_26, var_30_28, var_30_18, var_30_27, var_30_25 == var_30_29)

			var_30_27 = var_30_27 - 20
			var_30_28 = var_30_28 + 1
		end

		var_30_26 = var_30_26 + 1
	end
end

SpawnZoneBaker._debug_draw_baker_data = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	if arg_31_2.count > arg_31_2.max_amount then
		local var_31_0 = Colors.distinct_colors_lookup[arg_31_1.id] or Colors.distinct_colors_lookup[1]
		local var_31_1 = Color(var_31_0[1], var_31_0[2], var_31_0[3])

		QuickDrawerStay:sphere(Vector3Aux.unbox(arg_31_4), 0.5, var_31_1)
		print(string.format("SPAWN SWITCH breed %s -> %s, hidata-id: %s count: %d/%d", arg_31_3, arg_31_2.switch_breed.name, arg_31_1.id, arg_31_2.switch_count, arg_31_2.max_amount))
	else
		local var_31_2 = Colors.distinct_colors_lookup[arg_31_1.id] or Colors.distinct_colors_lookup[1]
		local var_31_3 = Color(var_31_2[1], var_31_2[2], var_31_2[3])

		QuickDrawerStay:sphere(Vector3Aux.unbox(arg_31_4), 0.1, var_31_3)
		print(string.format("SPAWN NORMAL breed %s, hidata-id: %s count: %d/%d", arg_31_3, arg_31_1.id, arg_31_2.switch_count, arg_31_2.max_amount))
	end
end
