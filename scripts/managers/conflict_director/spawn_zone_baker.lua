-- chunkname: @scripts/managers/conflict_director/spawn_zone_baker.lua

require("scripts/managers/conflict_director/main_path_spawning_generator")

SpawnZoneBaker = class(SpawnZoneBaker)

local InterestPointUnits = InterestPointUnits
local num = 1.5

SpawnZoneBaker.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.world = arg_1_1
	self.nav_world = arg_1_2
	self.level_analyzer = arg_1_3
	self.spawn_zones_available = false

	self:set_seed(arg_1_4)

	if not InterestPointUnitsLookup then
		ConflictUtils.generate_spawn_point_lookup(arg_1_1)
	end

	local level_name = LevelHelper:current_level_settings().level_name

	if not level_name then
		if LevelResource.nested_level_count(level_name) > 0 then
			level_name = LevelResource.nested_level_resource_name(level_name, 0)
		end

		local str = level_name .. "_patrol_waypoints"

		if not Application.can_get("lua", str) then
			local var_1_2 = require(str)
			local patrol_waypoints = var_1_2.patrol_waypoints
			local clone = table.clone(var_1_2.boss_waypoints)
			local event_waypoints = var_1_2.event_waypoints

			self.level_analyzer:store_patrol_waypoints(clone, patrol_waypoints, event_waypoints)
		end

		local spawn_zone_data = arg_1_3.spawn_zone_data

		if not spawn_zone_data then
			self.zone_convert = {}
			self.zones = spawn_zone_data.zones
			self.spawn_pos_lookup = spawn_zone_data.position_lookup
			self.num_main_zones = spawn_zone_data.num_main_zones
			self.total_main_path_length_unmodified = spawn_zone_data.total_main_path_length

			local main_paths = spawn_zone_data.main_paths

			self.main_paths = main_paths

			local path_markers = spawn_zone_data.path_markers

			self.path_markers = path_markers

			local crossroads = spawn_zone_data.crossroads
			local remove_crossroads_extra_path_branches, var_1_11 = arg_1_3:remove_crossroads_extra_path_branches(main_paths, crossroads, self.total_main_path_length_unmodified, self.zones, self.num_main_zones, path_markers)

			if not remove_crossroads_extra_path_branches then
				self.num_main_zones = var_1_11
			end

			local system = Managers.state.entity:system("door_system")
			local tbl = {}
			local num_2 = 0

			for i = 1, #main_paths do
				local var_1_15 = main_paths[i]
				local nodes = var_1_15.nodes

				for j = 1, #nodes do
					local var_1_17 = nodes[j]
					local var_1_18 = Vector3(var_1_17[1], var_1_17[2], var_1_17[3])

					if system:get_doors(var_1_18, num, tbl) > 0 then
						local var_1_19 = tbl[1]
						local resolve_node_in_door = MainPathUtils.resolve_node_in_door(arg_1_2, var_1_18, var_1_19)

						if not resolve_node_in_door then
							var_1_18 = resolve_node_in_door
						else
							print("MainPathUtils.resolve_node_in_door: Error - was unable to resolve node in door at position", var_1_18)
						end
					end

					nodes[j] = Vector3Box(var_1_18)
				end

				num_2 = num_2 + var_1_15.path_length
			end

			MainPathSpawningGenerator.inject_travel_dists(main_paths, remove_crossroads_extra_path_branches)
			arg_1_3:store_path_markers(path_markers)

			self.total_main_path_length = num_2

			arg_1_3:store_main_paths(main_paths)
			arg_1_3:brute_force_calc_zone_distances(self.zones, self.num_main_zones, self.spawn_pos_lookup)

			if not remove_crossroads_extra_path_branches then
				Managers.state.game_mode:recalc_respawner_dist_due_to_crossroads()
			end

			self:create_cover_points(spawn_zone_data.cover_points, arg_1_3.cover_points_broadphase)

			self.spawn_zones_available = true
		end
	end
end

SpawnZoneBaker._random = function (self, ...)
	-- function 2
	local next_random, var_2_1 = Math.next_random(self.seed, ...)

	self.seed = next_random

	return var_2_1
end

SpawnZoneBaker._random_dice_roll = function (self, arg_3_1, arg_3_2)
	-- function 3
	local roll_seeded, var_3_1 = LoadedDice.roll_seeded(arg_3_1, arg_3_2, self.seed)

	self.seed = roll_seeded

	return var_3_1
end

SpawnZoneBaker.set_seed = function (self, arg_4_1)
	-- function 4
	fassert(not arg_4_1 and type(arg_4_1) == "number", "Bad seed input!")

	self.seed = arg_4_1
	self._initial_seed = arg_4_1
end

SpawnZoneBaker._random_interval = function (self, arg_5_1)
	-- function 5
	if type(arg_5_1) == "table" then
		return self:_random(arg_5_1[1], arg_5_1[2])
	else
		return arg_5_1
	end
end

local tbl = {}
local tbl_2 = {}

SpawnZoneBaker._get_random_array_indices = function (self, arg_6_1, arg_6_2)
	-- function 6
	fassert(arg_6_2 <= arg_6_1, "Can't pick more elements than the size of the")
	fassert(arg_6_1 < 128, "Don't use this for large arrays, since it will be inefficient. It creates large tables then.")

	for i = 1, arg_6_1 do
		tbl_2[i] = i
	end

	for j = 1, arg_6_2 do
		local _random = self:_random(1, arg_6_1)

		tbl[j] = tbl_2[_random]
		tbl_2[_random] = tbl_2[arg_6_1]
		arg_6_1 = arg_6_1 - 1
	end

	return tbl
end

SpawnZoneBaker.loaded_spawn_zones_available = function (self)
	-- function 7
	return self.spawn_zones_available
end

SpawnZoneBaker.create_cover_points = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not arg_8_1 then
		print("No cover points found")

		return
	end

	local count = #arg_8_1
	local up = Vector3.up()

	for i = 1, count, 5 do
		local temp_count, var_8_3, var_8_4 = Script.temp_count()
		local var_8_5 = arg_8_1[i]
		local var_8_6 = arg_8_1[i + 1]
		local var_8_7 = arg_8_1[i + 2]
		local var_8_8 = Vector3(var_8_5, var_8_6, var_8_7)
		local var_8_9 = arg_8_1[i + 3]
		local var_8_10 = arg_8_1[i + 4]
		local look = Quaternion.look(Vector3(var_8_9, var_8_10, 0), up)
		local spawn_unit = World.spawn_unit(self.world, "units/hub_elements/empty", var_8_8, look)

		Broadphase.add(arg_8_2, spawn_unit, var_8_8, 1)
		Script.set_temp_count(temp_count, var_8_3, var_8_4)
	end
end

SpawnZoneBaker.periodical = function (self, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0
	local var_9_1

	if not arg_9_1 then
		var_9_0 = self:_random(arg_9_2.min_low_dist, arg_9_2.max_low_dist)
		var_9_1 = arg_9_2.min_low_density + self:_random() * (arg_9_2.max_low_density - arg_9_2.min_low_density)
		arg_9_1 = false
	else
		var_9_0 = self:_random(arg_9_2.min_hi_dist, arg_9_2.max_hi_dist)
		var_9_1 = arg_9_2.min_hi_density + self:_random() * (arg_9_2.max_hi_density - arg_9_2.min_hi_density)
		arg_9_1 = true
	end

	return var_9_0, var_9_1, arg_9_1
end

local function fn(self, arg_10_1, arg_10_2)
	-- function 10
	for i = 1, arg_10_2 do
		arg_10_1[i] = self[i]
	end
end

local function fn_2(self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self[arg_11_1]

	self[arg_11_1] = self[arg_11_2]
	self[arg_11_2] = nil

	return var_11_0
end

local tbl_3 = {}
local tbl_4 = {}

SpawnZoneBaker.generate_spawns = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	if not InterestPointUnitsLookup then
		ConflictUtils.generate_spawn_point_lookup(self.world)
	end

	if not self.spawn_zones_available then
		print("No spawn zones where found, can't generate spawns")
	end

	self._all_hi_data = {}
	self._count_up = 0

	local get_difficulty, var_12_1 = Managers.state.difficulty:get_difficulty()

	self.composition_difficulty = DifficultyTweak.converters.composition(get_difficulty, var_12_1)

	local zones = self.zones
	local num_main_zones = self.num_main_zones
	local zone_convert = self.zone_convert

	arg_12_5 = arg_12_5 or "default"

	local var_12_5 = ConflictDirectors[arg_12_5]
	local _initial_seed = self._initial_seed
	local generate_great_cycles = MainPathSpawningGenerator.generate_great_cycles(var_12_5, arg_12_6, zones, zone_convert, num_main_zones, arg_12_1, _initial_seed)
	local tbl = {}
	local tbl_2 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {}
	local distribution_method = PackSpawningDistribution.standard.distribution_method
	local var_12_14 = PackDistributions[distribution_method]
	local count = #generate_great_cycles

	for i = 1, count do
		local zones_2 = generate_great_cycles[i].zones
		local count_2 = #zones_2
		local num = 0
		local num_2 = 0
		local var_12_20

		if distribution_method == "random" then
			for j = 1, count_2 do
				local var_12_21 = zones_2[j]
				local _random = self:_random()

				var_12_21.density = _random
				num = num + _random
			end
		elseif distribution_method == "periodical" then
			local var_12_23
			local var_12_24
			local var_12_25
			local flag = self:_random() > 0.5
			local periodical, var_12_28, var_12_29 = self:periodical(flag, var_12_14)
			local var_12_30 = zones_2[1]

			var_12_30.period_length = periodical
			var_12_30.hi = var_12_29

			local create_hi_data = self:create_hi_data(var_12_30, var_12_30.pack_type)
			local var_12_32 = periodical

			num_2 = not var_12_29 and 1 and 0

			local var_12_33
			local var_12_34

			for k = 1, count_2 do
				local var_12_35 = zones_2[k]

				var_12_35.hi_data = create_hi_data

				if var_12_32 < k then
					local periodical_2

					periodical_2, var_12_28, var_12_29 = self:periodical(var_12_29, var_12_14)
					var_12_34 = false
					var_12_32 = k + periodical_2 - 1

					if count_2 < var_12_32 then
						periodical_2 = count_2 - k
						var_12_32 = count_2
					end

					var_12_35.period_length = periodical_2
					var_12_35.hi_data = create_hi_data
					var_12_35.hi = var_12_29
					create_hi_data = self:create_hi_data(var_12_35, var_12_35.pack_type)

					local flag_2

					flag_2 = not var_12_29 and 1 and 0
					num_2 = num_2 + flag_2
				elseif not var_12_14.random_distribution then
					if not var_12_29 then
						var_12_28 = var_12_14.min_hi_density + self:_random() * (var_12_14.max_hi_density - var_12_14.min_hi_density)
					else
						var_12_28 = var_12_14.min_low_density + self:_random() * (var_12_14.max_low_density - var_12_14.min_low_density)
					end
				elseif not (var_12_33 ~= var_12_14.zero_clamp_max_dist or var_12_29) then
					var_12_34 = true
					var_12_28 = var_12_14.min_low_density + self:_random() * (var_12_14.max_low_density - var_12_14.min_low_density)
				end

				var_12_33 = not var_12_35.period_length and 1 and var_12_33 + 1

				if not (not (var_12_28 < var_12_14.zero_density_below) or var_12_34) then
					var_12_28 = 0
				end

				var_12_35.density = var_12_28
				var_12_35.hi = var_12_29
				num = num + var_12_28
			end
		end

		local num_3 = 0
		local var_12_39
		local var_12_40

		for l = 1, count_2 do
			local var_12_41 = zones_2[l]

			if var_12_39 ~= var_12_41.pack_spawning_setting then
				var_12_40 = var_12_41.pack_spawning_setting.basics.goal_density
			end

			num_3 = num_3 + var_12_40
		end

		if num > 0 then
			local num_4 = num_3 / num
			local num_5 = 0

			print("-------------> JOW Perfect-density", num_3, "Sum density", num, "Normalized coefficient:", num_4)

			for i4 = 1, count_2 do
				local var_12_44 = zones_2[i4]

				var_12_44.density = var_12_44.density * num_4

				if num_5 > 0 then
					var_12_44.density = var_12_44.density + num_5
					num_5 = 0
				end

				if var_12_44.density > 1 then
					num_5 = num_5 + var_12_44.density - 1
					var_12_44.density = 1
				end
			end

			if distribution_method == "periodical" then
				self:inject_special_packs(num_2, zones_2)
			end

			local num_6 = 1

			for i5 = 1, count_2 do
				local var_12_46 = zones_2[i5]
				local density, outer = var_12_46.density, var_12_46.outer

				for i6 = 1, #outer do
					local var_12_49 = outer[i6]

					density = math.clamp(density * num_6 + (1 - num_6) * (2 * self:_random() - 1), 0, 1)
					var_12_49.density = density
					var_12_49.hi_data = var_12_46.hi_data
					var_12_49.hi = var_12_46.hi
				end
			end

			self:populate_spawns_by_rats(var_12_39, tbl, tbl_2, tbl_5, tbl_6, tbl_7, zones_2, var_12_39, arg_12_4, nil, true, nil)

			for i7 = 1, count_2 do
				local var_12_50 = zones_2[i7]
				local outer_2 = var_12_50.outer
				local pack_spawning_setting = var_12_50.pack_spawning_setting
				local clamp_outer_zones_used = pack_spawning_setting.basics.clamp_outer_zones_used

				if not clamp_outer_zones_used then
					local count_3 = #outer_2
					local num_7 = count_3 - clamp_outer_zones_used

					if num_7 > 0 then
						fn(outer_2, tbl_3, count_3)

						local count_4 = #outer_2

						for i8 = 1, num_7 do
							fn_2(tbl_3, self:_random(1, count_4), count_4)

							count_4 = count_4 - 1
						end

						outer_2 = tbl_3
					end
				end

				self:populate_spawns_by_rats(pack_spawning_setting, tbl, tbl_2, tbl_5, tbl_6, tbl_7, outer_2, arg_12_3, 0, var_12_50.pack_type, nil, var_12_50)
			end
		else
			print(sprintf("Spawn density in great_cycle %d is 0, num cycle zones: %d ", i, count_2))
		end
	end

	local tbl_8 = {}

	for i9 = num_main_zones + 1, #zones do
		local var_12_58 = zones[i9]
		local parent_zone_id = var_12_58.parent_zone_id

		if not parent_zone_id then
			print("Missing parent zone id for island-zone", i9)
			table.dump(var_12_58, "ISLAND ZONE", 2)
		end

		local flag_3 = not parent_zone_id and self.level_analyzer:get_zone_from_unique_id(zone_convert, parent_zone_id)

		if not flag_3 then
			local conflict_setting = flag_3.conflict_setting
			local pack_spawning_setting_2 = flag_3.pack_spawning_setting
			local pack_type = flag_3.pack_type
			local area_density_coefficient = pack_spawning_setting_2.area_density_coefficient

			if not (not var_12_58.on_roof and BreedPacks[pack_type].roof_spawning_allowed) then
				local sub = var_12_58.sub
				local sub_areas = var_12_58.sub_areas

				for i10 = 1, #sub do
					local var_12_67 = sub[i10]
					local var_12_68 = sub_areas[i10]
					local _random_2 = self:_random()
					local floor = math.floor(var_12_68 * _random_2 * area_density_coefficient)
					local tbl_9 = {
						total_area = 0,
						nodes = var_12_67,
						area = var_12_68,
						outer = {},
						pack_type = pack_type,
						pack_spawning_setting = pack_spawning_setting_2,
						conflict_setting = conflict_setting,
						unique_zone_id = var_12_58.unique_zone_id
					}

					tbl_9.period_length = 1
					tbl_9.hi = false
					tbl_9.island = true
					tbl_9.density = _random_2
					tbl_9.parent_zone = flag_3

					self:create_hi_data(tbl_9, pack_type)

					tbl_8[#tbl_8 + 1] = tbl_9
					tbl_9.unique_zone_id = #tbl_8

					local islands = flag_3.islands

					if not islands then
						islands = {}
						flag_3.islands = islands
					end

					islands[#islands + 1] = tbl_9.unique_zone_id

					if floor > 0 then
						self:spawn_amount_rats(tbl, tbl_2, tbl_5, tbl_6, tbl_7, var_12_67, floor, pack_type, var_12_68, tbl_9)
					end
				end
			end
		end
	end

	fassert(#tbl == #tbl_2, "Mismatching sizes!")

	self.great_cycles = generate_great_cycles
	self.island_zones = tbl_8

	table.clear(tbl_4)

	return tbl, tbl_2, tbl_5, tbl_6, tbl_7
end

SpawnZoneBaker.inject_special_packs = function (self, arg_13_1, arg_13_2)
	-- function 13
	local breed_packs_peeks_overide_chance = arg_13_2[1].pack_spawning_setting.roaming_set.breed_packs_peeks_overide_chance

	if not breed_packs_peeks_overide_chance then
		return
	end

	local num = self:_random() * (breed_packs_peeks_overide_chance[2] - breed_packs_peeks_overide_chance[1]) + breed_packs_peeks_overide_chance[1]
	local floor = math.floor(arg_13_1 * num)

	if not (floor <= 0 or not (arg_13_1 <= 0)) then
		return
	end

	local _get_random_array_indices = self:_get_random_array_indices(arg_13_1, floor)
	local tbl = {}

	for i = 1, floor do
		tbl[_get_random_array_indices[i]] = true
	end

	local count = #arg_13_2
	local num_2 = 1
	local num_3 = 1

	while num_2 < count do
		local var_13_8 = arg_13_2[num_2]
		local period_length = var_13_8.period_length

		if not period_length and not var_13_8.hi then
			if not tbl[num_3] then
				local roaming_set = var_13_8.pack_spawning_setting.roaming_set
				local breed_packs_override = roaming_set.breed_packs_override

				if not breed_packs_override then
					local breed_packs_override_loaded_dice = roaming_set.breed_packs_override_loaded_dice
					local var_13_13 = breed_packs_override_loaded_dice[1]
					local var_13_14 = breed_packs_override_loaded_dice[2]
					local _random_dice_roll = self:_random_dice_roll(var_13_13, var_13_14)
					local var_13_16 = breed_packs_override[_random_dice_roll][1]
					local var_13_17 = breed_packs_override[_random_dice_roll][3]
					local create_hi_data = self:create_hi_data(var_13_8, var_13_16)

					for j = num_2, num_2 + period_length - 1 do
						local var_13_19 = arg_13_2[j]

						var_13_19.pack_type = var_13_16
						var_13_19.density_coefficient = var_13_17
						var_13_19.hi_data = create_hi_data
					end
				end

				num_2 = num_2 + period_length - 1
			end

			num_3 = num_3 + 1
		end

		num_2 = num_2 + 1
	end
end

SpawnZoneBaker.create_hi_data = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0
	local zone_checks = BreedPacks[arg_14_2].zone_checks

	if not zone_checks then
		self._count_up = self._count_up + 1
		var_14_0 = {
			id = self._count_up
		}
		arg_14_1.hi_data = var_14_0

		local clamp_breeds_hi

		if not arg_14_1.hi then
			clamp_breeds_hi = zone_checks.clamp_breeds_hi

			if not clamp_breeds_hi then
				-- Nothing
			end
		end

		clamp_breeds_hi = zone_checks.clamp_breeds_low

		::label_14_0::

		if not clamp_breeds_hi then
			local var_14_3 = clamp_breeds_hi[self.composition_difficulty]

			if not var_14_3 then
				local tbl = {}

				for i = 1, #var_14_3 do
					local var_14_5 = var_14_3[i]
					local _random_interval = self:_random_interval(var_14_5[1])
					local var_14_7 = var_14_5[2]
					local var_14_8 = var_14_5[3]

					tbl[var_14_7] = {
						switch_count = 0,
						count = 0,
						max_amount = _random_interval,
						switch_breed = var_14_8,
						hi = arg_14_1.hi
					}
				end

				var_14_0.breed_count = tbl
			end
		end

		self._all_hi_data[#self._all_hi_data + 1] = var_14_0
	end

	return var_14_0
end

SpawnZoneBaker.populate_spawns_by_rats = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12)
	-- function 15
	local count = #arg_15_7
	local num = 0
	local num_2 = 0
	local num_3 = 10

	for i = 1, count do
		local var_15_4 = arg_15_7[i]
		local pack_spawning_setting = var_15_4.pack_spawning_setting

		pack_spawning_setting = pack_spawning_setting or arg_15_1

		local basics = pack_spawning_setting.basics
		local density_coefficient

		if not arg_15_11 then
			density_coefficient = var_15_4.density_coefficient

			if not density_coefficient then
				-- Nothing
			end
		end

		density_coefficient = pack_spawning_setting.area_density_coefficient
		density_coefficient = density_coefficient or arg_15_8

		do
			local length_density_coefficient
		end

		::label_15_0::

		if not arg_15_11 then
			length_density_coefficient = basics.length_density_coefficient

			if not length_density_coefficient then
				-- Nothing
			end
		end

		length_density_coefficient = arg_15_9

		::label_15_1::

		local flag = not arg_15_11 and basics.clamp_main_path_zone_area
		local nodes = var_15_4.nodes

		if not nodes then
			local flag_2 = not arg_15_11 and flag > var_15_4.area and flag and var_15_4.area
			local num_4 = flag_2 * var_15_4.density * density_coefficient + num
			local floor = math.floor(num_4)

			num = num_4 - floor

			local num_5 = num_3 * var_15_4.density * length_density_coefficient + num_2
			local floor_2 = math.floor(num_5)

			num_2 = num_5 - floor_2

			local num_6 = floor + floor_2

			if num_6 > 0 then
				local temp_count, var_15_18, var_15_19 = Script.temp_count()

				var_15_4.wanted_spawns = self:spawn_amount_rats(arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, nodes, num_6, arg_15_10 or var_15_4.pack_type, flag_2, arg_15_12 or var_15_4)

				Script.set_temp_count(temp_count, var_15_18, var_15_19)
			end
		else
			print("Warning: missing nodes! in zones")
		end
	end
end

SpawnZoneBaker._generate_pack_members = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local var_16_0 = BreedPacksBySize[arg_16_1][arg_16_2]
	local prob = var_16_0.prob
	local alias = var_16_0.alias
	local _random_dice_roll = self:_random_dice_roll(prob, alias)
	local var_16_4 = var_16_0.packs[_random_dice_roll]
	local clone = table.clone(var_16_4.members)

	clone.type = arg_16_1

	local flag = not arg_16_3 and arg_16_3.hi_data

	if not flag and not flag.breed_count then
		local breed_count = flag.breed_count

		for i = 1, arg_16_2 do
			local var_16_8 = clone[i]

			if not var_16_8.name then
				var_16_8 = var_16_8[math.random(1, #var_16_8)]
				clone[i] = var_16_8
			end

			local var_16_9 = breed_count[var_16_8.name]

			if not var_16_9 then
				var_16_9.count = var_16_9.count + 1

				if var_16_9.count > var_16_9.max_amount then
					clone[i] = var_16_9.switch_breed
					var_16_9.switch_count = var_16_9.switch_count + 1
				end
			end
		end
	end

	return clone
end

local count = #InterestPointUnits

SpawnZoneBaker.spawn_amount_rats = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
	-- function 17
	local normalize = Vector3.normalize
	local var_17_1 = InterestPointUnits
	local InterestPointPickListIndexLookup = InterestPointPickListIndexLookup
	local nav_world = self.nav_world
	local spawn_pos_lookup = self.spawn_pos_lookup
	local count_2 = #arg_17_1
	local num = 0
	local count_3 = #arg_17_6
	local num_2 = 0

	while arg_17_7 > 0 do
		num_2 = num_2 + 1

		local var_17_9 = InterestPointPickListIndexLookup[math.min(arg_17_7, count)]
		local var_17_10 = InterestPointPickList[self:_random(var_17_9)]
		local var_17_11 = var_17_1[var_17_10]
		local count_4 = #var_17_11
		local flag

		flag = count_4 ~= 1 or not 1 or self:_random(count_4)

		local var_17_14 = var_17_11[flag]

		for i = 1, 10 do
			local temp_count, var_17_16, var_17_17 = Script.temp_count()
			local _random = self:_random(count_3)
			local var_17_19 = arg_17_6[_random]

			if not tbl_4[var_17_19] then
				local var_17_20 = spawn_pos_lookup[arg_17_6[_random]]
				local var_17_21 = Vector3(var_17_20[1], var_17_20[2], var_17_20[3])
				local num_3 = self:_random() * 2 * math.pi
				local var_17_23 = Quaternion(Vector3.up(), num_3)
				local interest_point_outside_nav_mesh = ConflictUtils.interest_point_outside_nav_mesh(nav_world, var_17_14, var_17_21, var_17_23)
				local num_4 = 0

				while not (not interest_point_outside_nav_mesh and not (num_4 < 3)) do
					num_4 = num_4 + 1
					var_17_21 = var_17_21 + normalize(var_17_21 - interest_point_outside_nav_mesh)
					interest_point_outside_nav_mesh = ConflictUtils.interest_point_outside_nav_mesh(nav_world, var_17_14, var_17_21, var_17_23)
				end

				if not interest_point_outside_nav_mesh then
					fassert(var_17_14, "what the - no spawn point unit name?")

					local _generate_pack_members = self:_generate_pack_members(arg_17_8, var_17_10, arg_17_10, var_17_14, var_17_21)

					count_2 = count_2 + 1
					arg_17_1[count_2] = Vector3Box(var_17_21)
					arg_17_2[count_2] = var_17_14
					arg_17_3[count_2] = num_3
					arg_17_4[count_2] = _generate_pack_members
					arg_17_5[count_2] = arg_17_10
					arg_17_7 = arg_17_7 - var_17_10
					tbl_4[var_17_19] = true

					break
				end
			end

			Script.set_temp_count(temp_count, var_17_16, var_17_17)
		end

		num = num + 1

		if num > 100 then
			print("cannot find place to spawn rats")

			break
		end
	end

	table.clear(tbl_4)

	return num_2
end

SpawnZoneBaker.get_zone_segment_from_travel_dist = function (self, arg_18_1)
	-- function 18
	local zones = self.zones
	local num_main_zones = self.num_main_zones

	for i = 1, num_main_zones do
		if arg_18_1 < zones[i].travel_dist - 5 then
			local num

			if i > 1 then
				num = i - 1

				if not num then
					-- Nothing
				end
			end

			num = i

			::label_18_0::

			local var_18_3 = zones[num]
			local var_18_4 = self.zone_convert[num]

			return num, var_18_3, var_18_4
		end
	end

	return num_main_zones, zones[num_main_zones], self.zone_convert[num_main_zones]
end

SpawnZoneBaker.draw_zones = function (self, arg_19_1, arg_19_2)
	-- function 19
	local flag = false
	local flag_2 = true

	if not self.gui then
		World.destroy_gui(self.world, self.gui)

		self.gui = nil

		return
	else
		self.gui = World.create_world_gui(self.world, Matrix4x4.identity(), 1, 1)
	end

	local zone_convert = self.zone_convert
	local gui = self.gui
	local num = 64
	local zones = self.zones
	local spawn_pos_lookup = self.spawn_pos_lookup
	local tbl = {}

	if not flag then
		for i = 1, 16 do
			local var_19_8 = heatmap_colors_lookup[i]

			tbl[i] = Color(200, var_19_8[1], var_19_8[2], var_19_8[3])
		end
	end

	for j = math.clamp(arg_19_2 or 1, 1, #zones), #zones do
		local var_19_9 = zones[j]
		local sub = var_19_9.sub
		local var_19_11
		local var_19_12

		if not flag then
			local floor = math.floor
			local density

			if not zone_convert[j] then
				density = zone_convert[j].density

				if not density then
					-- Nothing
				end
			end

			density = 1

			::label_19_0::

			var_19_12 = floor(density * 16)
		else
			local num_2 = 92 + 63 * (j % 3)
			local num_3 = num_2 / 2

			var_19_11 = {
				Color(num, 0, num_2, 0),
				Color(num, 0, 0, num_2),
				Color(num, num_2, 0, 0),
				Color(num, num_2, num_2, 0),
				Color(num, 0, num_2, num_2),
				Color(num, num_2, 0, num_2),
				Color(num, num_2, num_3, 0),
				Color(num, num_2, 0, num_3),
				Color(num, 0, num_3, num_2),
				Color(num, num_3, 0, num_2)
			}
		end

		if not flag_2 then
			local var_19_17 = spawn_pos_lookup[sub[1][1]]
			local format = string.format
			local str = "%d %.1f <- %.1f"
			local var_19_20 = j
			local travel_dist = var_19_9.travel_dist

			travel_dist = travel_dist or 0

			local old_travel_dist = var_19_9.old_travel_dist

			old_travel_dist = old_travel_dist or 0

			local var_19_23 = format(str, var_19_20, travel_dist, old_travel_dist)

			Debug.world_sticky_text(var_19_17, var_19_23, var_19_11[1])
		end

		local var_19_24 = Vector3(0, 0, 0.1)

		for k = 1, #sub do
			local var_19_25 = sub[k]

			if not var_19_25 then
				for l = 1, #var_19_25 do
					local var_19_26 = var_19_25[l]
					local temp_count, var_19_28, var_19_29 = Script.temp_count()
					local var_19_30 = spawn_pos_lookup[var_19_26]
					local get_seed_triangle = GwNavTraversal.get_seed_triangle(arg_19_1, Vector3(var_19_30[1], var_19_30[2], var_19_30[3]), 0.5, 0.5)

					if not get_seed_triangle then
						local get_triangle_vertices, var_19_33, var_19_34 = GwNavTraversal.get_triangle_vertices(arg_19_1, get_seed_triangle)

						if not flag then
							Gui.triangle(gui, get_triangle_vertices + var_19_24, var_19_33 + var_19_24, var_19_34 + var_19_24, 2, tbl[var_19_12])
						else
							local var_19_35 = var_19_11[k]

							var_19_35 = var_19_35 or Colors.get_indexed((j * 7 + k + 5) % 32 + 1)

							Gui.triangle(gui, get_triangle_vertices + var_19_24, var_19_33 + var_19_24, var_19_34 + var_19_24, 2, var_19_35)
						end
					end

					Script.set_temp_count(temp_count, var_19_28, var_19_29)
				end
			end
		end

		if not arg_19_2 then
			break
		end
	end
end

SpawnZoneBaker.show_debug = function (self, arg_20_1)
	-- function 20
	if not arg_20_1 then
		if not self.graph then
			self:draw_pack_density_graph()
		end

		self.graph:set_active(true)
	elseif not self.graph then
		self.graph:set_active(false)
	end

	return true
end

SpawnZoneBaker.execute_debug = function (self)
	-- function 21
	QuickDrawerStay:reset()
	Managers.state.conflict:respawn_level(script_data.debug_pacing_seed)

	self.plain_zone_list = nil
	self._breed_pack_legend = nil
end

function print_zone_list(self)
	-- function 22
	for i = 1, #self do
		local var_22_0 = self[i]
		local clamp = math.clamp(var_22_0.area * 0.5, 0, 100)

		if not var_22_0.hi_data then
			local id = var_22_0.hi_data.id
			local print = print
			local format = string.format("Zone: %d, hi: %s, hi-id: %d, Density: %.1f, Area: %.1f", i, tostring(var_22_0.hi), id, var_22_0.density, clamp)
			local str = "con:"
			local name = var_22_0.conflict_setting.name
			local str_2 = "period_len:"
			local period_length = var_22_0.period_length

			period_length = period_length or "--"

			local str_3 = "data:"
			local flag

			flag = not var_22_0.hi_data and "Y" and "N"

			print(format, str, name, str_2, period_length, str_3, flag, string.format("Director / Packtype: %s / %s ", var_22_0.conflict_setting.name, var_22_0.pack_type))

			local outer = var_22_0.outer

			for j = 1, #outer do
				local var_22_12 = outer[j]

				if not var_22_12.hi_data then
					if id ~= var_22_12.hi_data.id then
						print(string.format("BAD OUTER=%d hi-id: %d != %d", j, id, var_22_12.hi_data.id))
					else
						print(string.format("outer=%d hi=%s hi-id: %d ", j, tostring(var_22_12.hi), id))
					end
				else
					print(string.format("outer=%d hi=-- hi-id: -- NO CLAMPING IN PACK_TYPE %s", j, tostring(var_22_12.pack_type)))
				end
			end
		else
			local print_2 = print
			local format_2 = string.format("Zone: %d, hi: %s, hi-id: --, Density: %.1f, Area: %.1f", i, tostring(var_22_0.hi), var_22_0.density, clamp)
			local str_4 = "con:"
			local name_2 = var_22_0.conflict_setting.name
			local str_5 = "period_len:"
			local period_length_2 = var_22_0.period_length

			period_length_2 = period_length_2 or "--"

			local str_6 = "data:"
			local flag_2

			flag_2 = not var_22_0.hi_data and "Y" and "N"

			print_2(format_2, str_4, name_2, str_5, period_length_2, str_6, flag_2, string.format("Director / Packtype: %s / %s ", var_22_0.conflict_setting.name, var_22_0.pack_type))
		end
	end
end

SpawnZoneBaker.debug_print_hi_data = function (self)
	-- function 23
	local var_23_0
	local great_cycles = self.great_cycles

	for i = 1, #great_cycles do
		local var_23_2 = great_cycles[i]

		print("Great Cycle", i, "-------------")

		local zones = var_23_2.zones

		for j = 1, #zones do
			local var_23_4 = zones[j]
			local hi_data = var_23_4.hi_data

			if hi_data ~= var_23_0 then
				local flag

				flag = not var_23_4.hi and "Hi" and "Low"

				local str = flag .. "-data for zone:" .. tostring(j) .. " -> " .. j + var_23_4.period_length - 1

				if not hi_data then
					local breed_count = hi_data.breed_count

					if not breed_count then
						table.dump(breed_count, str, 1)
					end
				end
			end

			var_23_0 = hi_data
		end
	end

	for k = 1, #self._all_hi_data do
		local var_23_9 = self._all_hi_data[k]
		local breed_count_2 = var_23_9.breed_count

		if not breed_count_2 then
			for k_2, v in pairs(breed_count_2) do
				local print = print
				local str_2 = "Hidata id:"
				local id = var_23_9.id
				local flag_2

				flag_2 = not v.hi and "HI" and "LOW"

				print(str_2, id, flag_2, "count:", v.count, "switched:", v.switch_count, "max:", v.max_amount, "breed:", k_2, "switched to:", v.switch_breed.name)
			end
		else
			print("Hidata id:", var_23_9.id, " (no breed_count)")
		end
	end
end

SpawnZoneBaker.draw_pack_density_graph = function (self)
	-- function 24
	if not self.graph then
		self.graph = Managers.state.debug.graph_drawer:create_graph("spawn density", {
			"distance",
			"density"
		})
		self.graph.visual_frame.y_max = 100
		self.graph.scroll_lock.vertical = false
		self.graph.scroll_lock.left = false
	end

	local graph = self.graph

	if not graph.active then
		graph:set_active(true)
	end

	local sub_zone_length = self.zones[1].sub_zone_length
	local num = 0
	local great_cycles = self.great_cycles
	local count = #great_cycles

	if not script_data.debug_zone_baker then
		self:debug_print_zones()
	end

	graph:set_plot_color("density", "maroon", "crimson")

	if count > 0 then
		local var_24_5
		local breed_packs = great_cycles[1].zones[1].conflict_setting.pack_spawning.roaming_set.breed_packs

		for i = 1, count do
			local zones = great_cycles[i].zones

			if i > 1 then
				self.graph:add_annotation({
					text = "Cycle",
					live = true,
					y = 105,
					color = "green",
					x = num
				})
			end

			for j = 1, #zones do
				local var_24_8 = zones[j]
				local density = var_24_8.density

				if breed_packs ~= var_24_8.pack_type then
					self.graph:add_annotation({
						text = "O",
						live = true,
						color = "lawn_green",
						x = num,
						y = density * 100
					})
				elseif not var_24_8.hi then
					self.graph:add_annotation({
						text = "H",
						live = true,
						color = "lawn_green",
						x = num,
						y = density * 100
					})
				end

				if var_24_5 ~= var_24_8.conflict_setting then
					var_24_5 = var_24_8.conflict_setting
					breed_packs = var_24_5.pack_spawning.roaming_set.breed_packs

					self.graph:add_annotation({
						live = true,
						y = 110,
						color = "orange",
						x = num,
						text = var_24_5.name
					})
				end

				graph:add_point(num, density * 100, "density")

				local var_24_10 = self.spawn_pos_lookup[var_24_8.nodes[1]]
				local var_24_11 = Vector3(var_24_10[1], var_24_10[2], var_24_10[3])
				local num_2 = math.sqrt(var_24_8.total_area) / 5
				local var_24_13 = Vector3(num_2, num_2, num_2)
				local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.look(Vector3.up()), var_24_11)

				QuickDrawerStay:box(from_quaternion_position, var_24_13, Color(255, 0, 200, 0))
				QuickDrawerStay:sphere(var_24_11, 7 * density)

				num = num + sub_zone_length
			end
		end
	end

	local boss_event_list = self.level_analyzer.boss_event_list
	local num_3 = 60

	for k = 1, #boss_event_list do
		local var_24_17 = boss_event_list[k]
		local var_24_18 = var_24_17[3]
		local var_24_19 = var_24_17[2]
		local var_24_20 = var_24_17[4]

		self.graph:add_annotation({
			live = true,
			x = var_24_18,
			y = num_3,
			text = var_24_19,
			color = var_24_20
		})

		num_3 = num_3 + 7

		if num_3 > 70 then
			num_3 = 30
		end
	end

	local tbl = {
		text = "PLAYER",
		live = true,
		y = 50,
		color = "green",
		x = 0
	}

	self.graph:add_annotation(tbl)

	self.player_annotation = tbl
end

SpawnZoneBaker.draw_player_in_density_graph = function (self, arg_25_1)
	-- function 25
	if not self.graph then
		if not self.player_annotation then
			local tbl = {
				text = "PLAYER",
				live = true,
				y = 50,
				color = "green",
				x = 0
			}

			self.graph:add_annotation(tbl)

			self.player_annotation = tbl
		end

		self.graph:move_annotation(self.player_annotation, arg_25_1)
	end
end

SpawnZoneBaker.draw_func1 = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	local flag

	flag = not arg_26_1.island and "ISLAND" and "MAIN"

	local format = string.format
	local str = "%d %s: %d %s"
	local var_26_3 = arg_26_3
	local var_26_4 = flag
	local var_26_5 = arg_26_2
	local name = arg_26_1.pack_spawning_setting.name

	name = name or "?"

	local var_26_7 = format(str, var_26_3, var_26_4, var_26_5, name)

	Gui.text(self._gui, var_26_7, "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_26_4 + 200, arg_26_5, 1000))
end

SpawnZoneBaker._draw_zone = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0 = Vector3(0, 0, 1.5)
	local nodes = arg_27_1.nodes

	for i = 1, #nodes do
		local var_27_2 = nodes[i]
		local var_27_3 = self.spawn_pos_lookup[var_27_2]
		local var_27_4 = Vector3(var_27_3[1], var_27_3[2], var_27_3[3])

		QuickDrawer:circle(var_27_4 + var_27_0, 0.5, var_27_0, arg_27_2)
	end
end

local flag = true

SpawnZoneBaker.draw_func2 = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	-- function 28
	local _breed_pack_legend = self._breed_pack_legend
	local hi_data = arg_28_1.hi_data
	local str = _breed_pack_legend[arg_28_1.pack_type] .. "(" .. hi_data.id .. ")"
	local outer = arg_28_1.outer

	for i = 1, #outer do
		str = str .. " " .. _breed_pack_legend[arg_28_1.pack_type] .. "(" .. arg_28_1.hi_data.id .. ") "
	end

	local islands = arg_28_1.islands

	if not islands then
		str = str .. " <--- "

		for j = 1, #islands do
			local var_28_5 = islands[j]
			local var_28_6 = self.island_zones[var_28_5]

			str = str .. " " .. _breed_pack_legend[var_28_6.pack_type] .. "(" .. var_28_6.hi_data.id .. ") "
		end
	end

	local var_28_7

	if not arg_28_6 then
		var_28_7 = Color(200, 200, 0)

		if not var_28_7 then
			-- Nothing
		end
	end

	if not arg_28_1.hi then
		var_28_7 = Color(255, 255, 255)

		if not var_28_7 then
			-- Nothing
		end
	end

	var_28_7 = Color(175, 175, 175)

	::label_28_0::

	if not flag and not arg_28_6 then
		self:_draw_zone(arg_28_1, var_28_7)

		if not arg_28_1.islands then
			for k = 1, #arg_28_1.islands do
				local var_28_8 = self.island_zones[islands[k]]

				if not var_28_8 then
					self:_draw_zone(var_28_8, Color(255, 0, 128))
				end
			end
		end

		local outer_2 = arg_28_1.outer

		for l = 1, #outer_2 do
			self:_draw_zone(outer_2[l], Color(55, 200 - (l - 1) * 24, (l - 1) * 24))
		end

		local spawned_units_by_breed_table = Managers.state.conflict:spawned_units_by_breed_table()

		str = str .. ConflictUtils.display_number_of_breeds_in_segment("BREEDS: ", spawned_units_by_breed_table, arg_28_1)
	end

	local flag_2

	flag_2 = not arg_28_1.island and "ISLAND" and "MAIN"

	local format = string.format("%s: %d %s", flag_2, arg_28_2, str)

	Gui.text(self._gui, format, "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_28_4 + 200, arg_28_5, 1000), var_28_7)
end

SpawnZoneBaker._draw_legend = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	Gui.text(self._gui, string.format("LEGEND OF PACK-TYPES"), "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_29_2, arg_29_3, 1000))

	arg_29_3 = arg_29_3 - 30

	for k, v in pairs(arg_29_1) do
		Gui.text(self._gui, string.format("%s = %s", k, v), "materials/fonts/arial", 14, "materials/fonts/arial", Vector3(arg_29_2, arg_29_3, 1000))

		arg_29_3 = arg_29_3 - 20
	end
end

SpawnZoneBaker.draw_zone_info_on_screen = function (self)
	-- function 30
	if not self._gui then
		self._gui = World.create_screen_gui(self.world, "immediate")
	end

	if not self.plain_zone_list then
		local tbl = {}
		local great_cycles = self.great_cycles

		for i = 1, #great_cycles do
			local zones = great_cycles[i].zones

			for j = 1, #zones do
				local var_30_3 = zones[j]

				tbl[#tbl + 1] = var_30_3
			end
		end

		local island_zones = self.island_zones

		for k = 1, #island_zones do
			local var_30_5 = island_zones[k]

			tbl[#tbl + 1] = var_30_5
		end

		self.plain_zone_list = tbl
	end

	if not self._breed_pack_legend then
		local tbl_2 = {}
		local num = 1

		for k_2, v in pairs(BreedPacks) do
			local char = string.char(65 + num)

			tbl_2[k_2] = char .. char .. char
			num = num + 1
		end

		self._breed_pack_legend = tbl_2
	end

	local var_30_9
	local var_30_10

	if not Application.screen_resolution then
		var_30_9, var_30_10 = Application.screen_resolution()
	else
		var_30_9, var_30_10 = Application.resolution()
	end

	local plain_zone_list = self.plain_zone_list
	local count = #plain_zone_list
	local num_2 = 60
	local num_3 = 640
	local num_4 = 40
	local num_5 = var_30_9 - 100
	local num_6 = var_30_10 - 100
	local num_7 = 40
	local num_8 = var_30_10 - 40

	Gui.rect(self._gui, Vector3(num_3, num_4, UILayer.transition), Vector2(num_5, num_6), Color(num_2, 40, 40, 40))
	self:_draw_legend(self._breed_pack_legend, var_30_9 - 450, num_8 - 40)
	Gui.text(self._gui, string.format("Spawn Zone Baker. #zones=%d", count), "materials/fonts/arial", 14, "arial", Vector3(num_7 + 15, num_8 - 40, 1000))

	local num_9 = 40
	local floor = math.floor(num_9 / 2)
	local main_path_info = Managers.state.conflict.main_path_info
	local get_zone_segment_from_travel_dist, var_30_24, var_30_25 = self:get_zone_segment_from_travel_dist(main_path_info.ahead_travel_dist)

	Debug.text("zone:%d, unique_id %d %s", get_zone_segment_from_travel_dist, var_30_25.unique_zone_id, var_30_25.pack_type)

	local flag

	flag = not (get_zone_segment_from_travel_dist <= floor) or not 1 or get_zone_segment_from_travel_dist - floor

	local num_10 = num_8 - 40
	local num_11 = 1

	while not (not (num_11 < num_9) or not (flag <= count)) do
		local var_30_29 = plain_zone_list[flag]

		if not var_30_29 then
			self:draw_func2(var_30_29, flag, num_11, num_7, num_10, var_30_25 == var_30_29)

			num_10 = num_10 - 20
			num_11 = num_11 + 1
		end

		flag = flag + 1
	end
end

SpawnZoneBaker._debug_draw_baker_data = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	if arg_31_2.count > arg_31_2.max_amount then
		local var_31_0 = Colors.distinct_colors_lookup[arg_31_1.id]

		var_31_0 = var_31_0 or Colors.distinct_colors_lookup[1]

		local var_31_1 = Color(var_31_0[1], var_31_0[2], var_31_0[3])

		QuickDrawerStay:sphere(Vector3Aux.unbox(arg_31_4), 0.5, var_31_1)
		print(string.format("SPAWN SWITCH breed %s -> %s, hidata-id: %s count: %d/%d", arg_31_3, arg_31_2.switch_breed.name, arg_31_1.id, arg_31_2.switch_count, arg_31_2.max_amount))
	else
		local var_31_2 = Colors.distinct_colors_lookup[arg_31_1.id]

		var_31_2 = var_31_2 or Colors.distinct_colors_lookup[1]

		local var_31_3 = Color(var_31_2[1], var_31_2[2], var_31_2[3])

		QuickDrawerStay:sphere(Vector3Aux.unbox(arg_31_4), 0.1, var_31_3)
		print(string.format("SPAWN NORMAL breed %s, hidata-id: %s count: %d/%d", arg_31_3, arg_31_1.id, arg_31_2.switch_count, arg_31_2.max_amount))
	end
end
