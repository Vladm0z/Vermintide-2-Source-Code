-- chunkname: @scripts/managers/conflict_director/enemy_recycler.lua

EnemyRecycler = class(EnemyRecycler)

local InterestPointUnits = InterestPointUnits
local POSITION_LOOKUP = POSITION_LOOKUP
local alive = Unit.alive
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local num_6 = 2
local num_7 = 5
local num_8 = 7
local num_9 = 8
local num_10 = 9
local num_11 = 10
local num_12 = 11
local num_13 = 1
local num_14 = 2
local num_15 = 3
local num_16 = 4

local function fn(self, arg_1_1)
	-- function 1
	local var_1_0 = self[arg_1_1]
	local count = #self

	self[arg_1_1] = self[count]
	self[count] = nil

	return var_1_0
end

EnemyRecycler.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	self._seed = arg_2_8
	self.world = arg_2_1
	self.nav_world = arg_2_2
	self.conflict_director = Managers.state.conflict
	self.group_manager = self.conflict_director.navigation_group_manager
	self.areas = {}
	self.shutdown_areas = {}
	self.inside_areas = {}
	self.main_path_events = {}
	self.current_main_path_event_id = 1
	self.current_main_path_event_activation_dist = 999999
	self.main_path_info = self.conflict_director.main_path_info
	self._roaming_ai = 0
	self.group_id = 0
	self.visible = 0
	self.level = LevelHelper:current_level(arg_2_1)
	self.ai_group_system = Managers.state.entity:system("ai_group_system")
	self.patrol_analysis = self.conflict_director.patrol_analysis

	self:setup(arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

EnemyRecycler.debug_print_all_unspawned_packs = function (self)
	-- function 3
	local areas = self.areas

	for i = 1, #areas do
		local var_3_1 = areas[i]
		local var_3_2 = var_3_1[num_6]
		local var_3_3 = var_3_1[num_10]
		local var_3_4 = var_3_1[num_8]

		if not ((var_3_2 or not var_3_3) and var_3_4 ~= "pack") then
			for j = 1, #var_3_3 do
				local var_3_5 = var_3_3[j]

				if not var_3_5.name then
					print("Found breed:", var_3_5.name, "in area:", i)
				else
					for k = 1, #var_3_5 do
						print("Found sub-breeds:", var_3_5[k].name, "in area:", i)
					end
				end
			end
		end
	end
end

EnemyRecycler.get_replacement_breed = function (arg_4_0, arg_4_1)
	-- function 4
	local var_4_0

	if type(arg_4_1) == "table" then
		var_4_0 = Breeds[arg_4_1[math.random(1, #arg_4_1)]]
	else
		var_4_0 = Breeds[arg_4_1]
	end

	return var_4_0
end

EnemyRecycler.patch_override_breed = function (self, arg_5_1, arg_5_2)
	-- function 5
	local areas = self.areas

	for i = 1, #areas do
		local var_5_1 = areas[i]
		local var_5_2 = var_5_1[num_6]
		local var_5_3 = var_5_1[num_10]
		local var_5_4 = var_5_1[num_8]

		if not ((var_5_2 or not var_5_3) and var_5_4 ~= "pack") then
			for j = 1, #var_5_3 do
				local var_5_5 = var_5_3[j]

				if not var_5_5.name then
					if var_5_5.name == arg_5_1 then
						local get_replacement_breed = self:get_replacement_breed(arg_5_2)

						var_5_3[j] = get_replacement_breed

						print("Replacing breed:", arg_5_1, "with:", get_replacement_breed.name, "in area:", i)
					end
				else
					for k = 1, #var_5_5 do
						if var_5_5[k].name == arg_5_1 then
							local get_replacement_breed_2 = self:get_replacement_breed(arg_5_2)

							var_5_5[k] = get_replacement_breed_2

							print("Replacing sub-breed:", arg_5_1, "with:", get_replacement_breed_2.name, "in area:", i)
						end
					end
				end
			end
		end
	end
end

EnemyRecycler._random = function (self, ...)
	-- function 6
	local next_random, var_6_1 = Math.next_random(self._seed, ...)

	self._seed = next_random

	return var_6_1
end

EnemyRecycler._random_dice_roll = function (self, arg_7_1, arg_7_2)
	-- function 7
	local roll_seeded, var_7_1 = LoadedDice.roll_seeded(arg_7_1, arg_7_2, self._seed)

	self._seed = roll_seeded

	return var_7_1
end

EnemyRecycler.set_seed = function (self, arg_8_1)
	-- function 8
	fassert(not arg_8_1 and type(arg_8_1) == "number", "Bad seed input!")

	self._seed = arg_8_1
end

EnemyRecycler.setup_forbidden_zones = function (self, arg_9_1)
	-- function 9
	self.forbidden_zones = {}

	local forbidden_zones = self.forbidden_zones

	for i = 1, 9 do
		local str = "forbidden_zone" .. i

		if not Level.has_volume(self.level, str) then
			forbidden_zones[#forbidden_zones + 1] = str
		end
	end

	local checkpoint_data = Managers.state.spawn:checkpoint_data()

	if not checkpoint_data then
		forbidden_zones[#forbidden_zones + 1] = checkpoint_data.no_spawn_volume
	end

	for j = 20, 39 do
		local var_9_3 = LAYER_ID_MAPPING[j]

		if not (not var_9_3 and NAV_TAG_VOLUME_LAYER_COST_AI[var_9_3] ~= 0) then
			print("Layer named:", var_9_3, ", id:", j, " has cost 0 --> removed all roaming spawns found inside")

			forbidden_zones[#forbidden_zones + 1] = var_9_3
		end
	end

	self.has_forbidden_zones = #forbidden_zones > 0
end

local function fn_2(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	for i = 1, arg_10_2 do
		if not Level.is_point_inside_volume(arg_10_0, arg_10_1[i], arg_10_3) then
			return false
		end
	end

	return true
end

EnemyRecycler.add_critters = function (self)
	-- function 11
	local level_key = Managers.state.game_mode:level_key()
	local level_name = LevelSettings[level_key].level_name

	if LevelResource.nested_level_count(level_name) > 0 then
		level_name = LevelResource.nested_level_resource_name(level_name, 0)
	end

	local unit_indices = LevelResource.unit_indices(level_name, "units/hub_elements/critter_spawner")

	for i, v in ipairs(unit_indices) do
		local unit_position = LevelResource.unit_position(level_name, v)
		local unit_data = LevelResource.unit_data(level_name, v)
		local get = DynamicData.get(unit_data, "breed")

		assert(Breeds[get], "Level '%s' has placed a 'critter_spawner' unit, with a bad breed-name: '%s'", level_name, get)

		local var_11_6 = QuaternionBox(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))))
		local var_11_7 = Vector3Box(unit_position)

		self:add_breed(get, var_11_7, var_11_6)
	end
end

EnemyRecycler.boxify_waypoint_table = function (arg_12_0, arg_12_1)
	-- function 12
	local tbl = {}

	for i = 1, #arg_12_1 do
		local var_12_1 = arg_12_1[i]

		tbl[i] = Vector3Box(var_12_1[1], var_12_1[2], var_12_1[3])
	end

	return tbl
end

EnemyRecycler.draw_roaming_splines = function (self)
	-- function 13
	local var_13_0 = Color(75, 200, 200)
	local var_13_1 = Color(200, 75, 0)
	local QuickDrawerStay = QuickDrawerStay
	local _roaming_splines = self.ai_group_system._roaming_splines

	for k, v in pairs(_roaming_splines) do
		if not v.spline_points then
			local has_party = v.has_party

			if not has_party then
				QuickDrawerStay:sphere(v.has_party:unbox(), 1, Color(0, 255, 0))
				print("FOUND ROAMING!")
			end

			local flag = not has_party and var_13_0 and var_13_1

			self.ai_group_system:draw_spline(v.spline_points, QuickDrawerStay, flag)
		end
	end
end

local SizeOfInterestPoint = SizeOfInterestPoint
local num_17 = 3

EnemyRecycler.inject_roaming_patrol = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local var_14_0 = SizeOfInterestPoint[arg_14_4]

	if var_14_0 < num_17 then
		return
	end

	local patrol_overrides = BreedPacks[arg_14_3].patrol_overrides

	if not (not patrol_overrides and not (self:_random() < patrol_overrides.patrol_chance)) then
		local flag = false
		local get_closest_roaming_spline, var_14_4, var_14_5 = self.conflict_director.level_analysis:get_closest_roaming_spline(arg_14_1:unbox(), flag)

		if not get_closest_roaming_spline then
			return false
		end

		local spline = self.ai_group_system:spline(get_closest_roaming_spline)

		if not spline then
			var_14_5 = self.patrol_analysis:get_path_point(spline.spline_points, nil, self:_random() * 0.9)
		end

		local get_group_from_position = self.group_manager:get_group_from_position(var_14_5)
		local var_14_8 = BreedPacksBySize[arg_14_3][var_14_0]
		local prob = var_14_8.prob
		local alias = var_14_8.alias
		local _random_dice_roll = self:_random_dice_roll(prob, alias)
		local var_14_12 = var_14_8.packs[_random_dice_roll]
		local var_14_13 = Vector3Box(var_14_5)
		local waypoints = var_14_4.waypoints

		if not spline then
			spline.has_party = var_14_13
		end

		local boxify_waypoint_table

		if not spline then
			boxify_waypoint_table = self:boxify_waypoint_table(waypoints)

			if not boxify_waypoint_table then
				-- Nothing
			end
		end

		boxify_waypoint_table = nil

		::label_14_0::

		local tbl = {
			spline_type = "roaming",
			optional_pos = var_14_13,
			pack_type = arg_14_3,
			spline_name = get_closest_roaming_spline,
			pack = var_14_12,
			spline_way_points = boxify_waypoint_table,
			zone_data = arg_14_5
		}

		return {
			var_14_13,
			false,
			0,
			0,
			"roaming_patrol",
			get_group_from_position,
			"event",
			tbl
		}
	end

	return false
end

EnemyRecycler.setup = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	self.unique_area_id = 0

	self:reset_areas()
	self:setup_forbidden_zones()

	local areas = self.areas
	local current_level_settings = LevelHelper:current_level_settings()
	local num = 1
	local forbidden_zones = self.forbidden_zones
	local count = #self.forbidden_zones
	local level = self.level
	local nav_world = self.nav_world
	local nav_tag_volume_handler = self.conflict_director.nav_tag_volume_handler
	local flag = not not script_data.ai_roaming_patrols_disabled or self.conflict_director.level_analysis.patrol_waypoints

	if not CurrentConflictSettings.roaming.disabled then
		for i = 1, #arg_15_1 do
			local var_15_9 = arg_15_1[i]
			local var_15_10 = arg_15_2[i]
			local var_15_11 = arg_15_3[i]
			local var_15_12 = arg_15_4[i]
			local var_15_13 = arg_15_5[i]
			local unbox = var_15_9:unbox()
			local flag_2 = true
			local get_group_from_position = self.group_manager:get_group_from_position(unbox)

			if not fn_2(level, forbidden_zones, count, unbox) then
				flag_2 = false
			elseif NavTagVolumeUtils.inside_level_volume_layer(level, nav_tag_volume_handler, unbox, "NO_SPAWN") or not NavTagVolumeUtils.inside_level_volume_layer(level, nav_tag_volume_handler, unbox, "NO_BOTS_NO_SPAWN") then
				flag_2 = false
			elseif not flag then
				local inject_roaming_patrol = self:inject_roaming_patrol(var_15_9, var_15_11, var_15_12.type, var_15_10, var_15_13)

				if not inject_roaming_patrol then
					areas[num] = inject_roaming_patrol
					num = num + 1
					flag_2 = false
				end
			end

			fassert(var_15_10, "Fatal error, missing interest point unit")

			if not flag_2 then
				areas[num] = {
					var_15_9,
					false,
					0,
					0,
					var_15_10,
					get_group_from_position,
					"pack",
					var_15_11,
					var_15_12,
					var_15_13
				}
				num = num + 1
			end
		end

		self.unique_area_id = num
	end

	if not (CurrentConflictSettings.roaming.disabled or script_data.ai_critter_spawning_disabled) then
		self:add_critters()
	end
end

EnemyRecycler.reset_areas = function (self)
	-- function 16
	local areas = self.areas

	for i = 1, #areas do
		local var_16_1 = areas[i]
		local var_16_2 = var_16_1[num_8]
		local var_16_3 = var_16_1[num_6]

		if not (not var_16_3 and var_16_2 ~= "pack" and var_16_3[1][1] ~= nil) then
			self:deactivate_area(var_16_1)
		end

		areas[i] = nil
	end

	local shutdown_areas = self.shutdown_areas

	for j = 1, #shutdown_areas do
		shutdown_areas[j] = nil
	end

	local inside_areas = self.inside_areas

	for k = 1, #inside_areas do
		inside_areas[k] = nil
	end

	table.clear(self.main_path_events)
end

EnemyRecycler.update = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	-- function 17
	self:_update_roaming_spawning(arg_17_1, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	self.ai_group_system:prepare_update_recycler(arg_17_3, arg_17_5, arg_17_6)
end

EnemyRecycler.update_main_path_events = function (self, arg_18_1)
	-- function 18
	if not self.current_main_path_event_id and not script_data.ai_boss_spawning_disabled then
		return
	end

	if self.main_path_info.ahead_travel_dist >= self.current_main_path_event_activation_dist then
		local current_main_path_event_id = self.current_main_path_event_id
		local main_path_events = self.main_path_events
		local var_18_2 = main_path_events[current_main_path_event_id]
		local var_18_3 = var_18_2[num_15]
		local var_18_4 = var_18_2[num_14]
		local var_18_5 = var_18_2[num_16]
		local var_18_6

		if not var_18_5 then
			local gizmo_unit = var_18_5.gizmo_unit

			if not gizmo_unit then
				var_18_6 = Unit.get_data(gizmo_unit, "map_section")
			end

			var_18_5.optional_pos = var_18_4
			var_18_5.map_section = var_18_6
		end

		print("main path terror event triggered:", var_18_3)
		TerrorEventMixer.start_event(var_18_3, var_18_5)

		local num = current_main_path_event_id + 1
		local var_18_9 = main_path_events[num]

		if not var_18_9 then
			self.current_main_path_event_id = num
			self.current_main_path_event_activation_dist = var_18_9[num_13]
		else
			self.current_main_path_event_id = nil
		end
	end
end

EnemyRecycler.spawn_interest_point = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	-- function 19
	local tbl = {
		ai_interest_point_system = {
			recycler = true,
			do_spawn = arg_19_3,
			pack_members = arg_19_5,
			zone_data = arg_19_6
		}
	}
	local var_19_1 = Quaternion(Vector3.up(), arg_19_4)
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(arg_19_1, "interest_point", tbl, arg_19_2:unbox(), var_19_1)

	assert(spawn_network_unit, "Bad interest point, not found")

	return spawn_network_unit
end

EnemyRecycler.add_breed = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	self.unique_area_id = self.unique_area_id + 1

	local tbl = {
		[2] = arg_20_1,
		[3] = arg_20_2,
		[4] = arg_20_3,
		[5] = arg_20_4
	}
	local tbl_2 = {
		tbl
	}
	local get_group_from_position = self.group_manager:get_group_from_position(arg_20_2:unbox())

	self.areas[#self.areas + 1] = {
		arg_20_2,
		tbl_2,
		0,
		0,
		false,
		get_group_from_position,
		"breed"
	}
end

EnemyRecycler.breed_spawned_callback = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local dead_breed_data = arg_21_2.dead_breed_data

	BREED_DIE_LOOKUP[arg_21_0] = {
		EnemyRecycler.cleanup_dead_breed,
		dead_breed_data
	}
end

EnemyRecycler.cleanup_dead_breed = function (arg_22_0, arg_22_1)
	-- function 22
	arg_22_1[num] = nil
end

EnemyRecycler.activate_area = function (self, arg_23_1, arg_23_2)
	-- function 23
	local num_12 = 2
	local var_23_1 = arg_23_1[num_6]
	local var_23_2 = arg_23_1[num_8]

	if not var_23_1 then
		if var_23_2 == "pack" then
			if arg_23_2 == 0 then
				return true
			else
				local var_23_3 = arg_23_1[num_7]
				local var_23_4 = arg_23_1[num_10]
				local var_23_5 = arg_23_1[num_11]
				local var_23_6 = arg_23_1[1]
				local flag = true
				local spawn_interest_point = self:spawn_interest_point(var_23_3, var_23_6, flag, arg_23_1[num_9], var_23_4, var_23_5)

				arg_23_1[num_12] = {
					{
						spawn_interest_point,
						var_23_3,
						var_23_6
					}
				}
			end
		elseif var_23_2 == "event" then
			local var_23_9 = arg_23_1[1]
			local var_23_10 = arg_23_1[num_7]
			local flag_2 = arg_23_1[num_9] or {
				optional_pos = var_23_9
			}

			TerrorEventMixer.start_event(var_23_10, flag_2)

			return true
		end
	elseif var_23_2 == "pack" then
		local var_23_12 = var_23_1[1][1]
		local var_23_13 = var_23_1[1][2]
		local var_23_14 = var_23_1[1][3]

		assert(var_23_12 == nil, "lolwut")

		local flag_3 = false
		local spawn_interest_point_2 = self:spawn_interest_point(var_23_13, var_23_14, flag_3, arg_23_1[num_9])

		var_23_1[1][1] = spawn_interest_point_2

		for i = 2, #var_23_1 do
			local var_23_17 = var_23_1[i]
			local var_23_18 = var_23_17[num_2]
			local var_23_19 = var_23_17[num_3]
			local var_23_20 = var_23_17[num_4]
			local var_23_21 = var_23_17[num_5]

			var_23_21 = var_23_21 or {}
			var_23_21.ignore_event_counter = true
			var_23_21.spawned_func = EnemyRecycler.breed_spawned_callback
			var_23_21.dead_breed_data = var_23_17

			local var_23_22 = Breeds[var_23_18]
			local str = "enemy_recycler"
			local str_2 = "roam"
			local spawn_queued_unit = self.conflict_director:spawn_queued_unit(var_23_22, var_23_19, var_23_20, str, nil, str_2, var_23_21, nil, var_23_17)

			var_23_17[num] = spawn_queued_unit
			self._roaming_ai = self._roaming_ai + 1
		end
	elseif var_23_2 == "breed" then
		local var_23_26 = var_23_1[1]
		local var_23_27 = var_23_26[num_2]
		local var_23_28 = var_23_26[num_3]
		local var_23_29 = var_23_26[num_4]
		local var_23_30 = var_23_26[num_5]

		var_23_30 = var_23_30 or {}
		var_23_30.ignore_event_counter = true
		var_23_30.spawned_func = EnemyRecycler.breed_spawned_callback
		var_23_30.dead_breed_data = var_23_26

		local var_23_31 = Breeds[var_23_27]
		local str_3 = "enemy_recycler"
		local spawn_type = var_23_30.spawn_type

		spawn_type = spawn_type or "roam"

		local spawn_queued_unit_2 = self.conflict_director:spawn_queued_unit(var_23_31, var_23_28, var_23_29, str_3, nil, spawn_type, var_23_30, nil, var_23_26)

		var_23_26[num] = spawn_queued_unit_2
		self._roaming_ai = self._roaming_ai + 1
	end

	return false
end

local num_18 = 25

EnemyRecycler.deactivate_area = function (self, arg_24_1)
	-- function 24
	local var_24_0 = arg_24_1[num_6]
	local var_24_1 = arg_24_1[num_8]
	local BLACKBOARDS = BLACKBOARDS

	if var_24_1 == "pack" then
		if not var_24_0 then
			local var_24_3 = var_24_0[1][1]
			local extension = ScriptUnit.extension(var_24_3, "ai_interest_point_system")
			local points = extension.points
			local points_n = extension.points_n
			local num_5 = 1
			local var_24_8

			for i = 2, #var_24_0 do
				local var_24_9 = var_24_0[i][1]

				if type(var_24_9) == "number" then
					local remove_queued_unit = self.conflict_director:remove_queued_unit(var_24_9)

					self._roaming_ai = self._roaming_ai - 1
					num_5 = num_5 + 1
					var_24_0[num_5] = {
						[2] = remove_queued_unit[1].name,
						[3] = remove_queued_unit[2],
						[4] = remove_queued_unit[3],
						[5] = remove_queued_unit[7]
					}
					var_24_8 = true
				elseif not HEALTH_ALIVE[var_24_9] then
					local var_24_11 = var_24_9
					local var_24_12 = BLACKBOARDS[var_24_11]

					if not var_24_12.target_unit_found_time then
						local var_24_13 = POSITION_LOOKUP[var_24_11]

						if var_24_12.next_smart_object_data.next_smart_object_id ~= nil then
							var_24_13 = var_24_12.next_smart_object_data.entrance_pos:unbox()
						end

						num_5 = num_5 + 1
						var_24_0[num_5] = {
							[2] = Unit.get_data(var_24_11, "breed").name,
							[3] = Vector3Box(var_24_13),
							[4] = QuaternionBox(Unit.local_rotation(var_24_11, 0)),
							[5] = var_24_12.optional_spawn_data
						}

						self.conflict_director:destroy_unit(var_24_11, var_24_12, "deactivate_area")

						self._roaming_ai = self._roaming_ai - 1
					end

					var_24_8 = true
				end
			end

			if not var_24_8 then
				for j = 1, points_n do
					local var_24_14 = points[j]

					if type(var_24_14[1]) == "number" then
						local remove_queued_unit_2 = self.conflict_director:remove_queued_unit(var_24_14[1])

						self._roaming_ai = self._roaming_ai - 1
						num_5 = num_5 + 1
						var_24_0[num_5] = {
							[2] = remove_queued_unit_2[1].name,
							[3] = remove_queued_unit_2[2],
							[4] = remove_queued_unit_2[3],
							[5] = remove_queued_unit_2[7]
						}
					end

					local claim_unit = var_24_14.claim_unit

					claim_unit = claim_unit or type(var_24_14[1]) == "number" or var_24_14[1]

					if not claim_unit and not HEALTH_ALIVE[claim_unit] then
						local var_24_17 = BLACKBOARDS[claim_unit]

						if not var_24_17.target_unit_found_time then
							local var_24_18 = POSITION_LOOKUP[claim_unit]

							if var_24_17.next_smart_object_data.next_smart_object_id ~= nil then
								var_24_18 = var_24_17.next_smart_object_data.entrance_pos:unbox()
							end

							num_5 = num_5 + 1
							var_24_0[num_5] = {
								[2] = Unit.get_data(claim_unit, "breed").name,
								[3] = Vector3Box(var_24_18),
								[4] = QuaternionBox(Unit.local_rotation(claim_unit, 0)),
								[5] = var_24_17.optional_spawn_data
							}

							self.conflict_director:destroy_unit(claim_unit, var_24_17, "deactivate_area")

							self._roaming_ai = self._roaming_ai - 1
						end
					end
				end
			end

			for k = num_5 + 1, #var_24_0 do
				assert(k ~= 1)

				var_24_0[k] = nil
			end

			Managers.state.unit_spawner:mark_for_deletion(var_24_3)

			var_24_0[1][1] = nil

			if num_5 == 1 then
				return false
			end
		end
	elseif var_24_1 == "breed" then
		local var_24_19 = var_24_0[1]
		local var_24_20 = var_24_19[num]

		if type(var_24_20) == "number" then
			self.conflict_director:remove_queued_unit(var_24_20)

			self._roaming_ai = self._roaming_ai - 1

			return true
		end

		local var_24_21 = HEALTH_ALIVE[var_24_20]
		local flag = false
		local var_24_23

		if not var_24_21 then
			var_24_23 = BLACKBOARDS[var_24_20]

			if not var_24_23.target_unit_found_time then
				local var_24_24 = POSITION_LOOKUP[var_24_20]

				if var_24_23.next_smart_object_data.next_smart_object_id ~= nil then
					var_24_24 = var_24_23.next_smart_object_data.entrance_pos:unbox()
				end

				var_24_19[num_3] = Vector3Box(var_24_24)
				var_24_19[num_4] = QuaternionBox(Unit.local_rotation(var_24_20, 0))
				var_24_19[num_2] = var_24_23.breed.name
				flag = true
			end
		end

		if not flag then
			self.conflict_director:destroy_unit(var_24_20, var_24_23, "deactivate_area")

			self._roaming_ai = self._roaming_ai - 1
		else
			return false
		end
	end

	return true
end

local num_19 = 20
local tbl = {}

EnemyRecycler._update_roaming_spawning = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local num = 3
	local num_2 = 4
	local num_3 = 6
	local CurrentRoamingSettings = CurrentRoamingSettings
	local despawn_distance = CurrentRoamingSettings.despawn_distance
	local despawn_distance_z = CurrentRoamingSettings.despawn_distance_z

	despawn_distance_z = despawn_distance_z or 30

	local num_4 = despawn_distance + 5
	local abs = math.abs
	local areas = self.areas
	local shutdown_areas = self.shutdown_areas
	local count = #arg_25_2
	local despawn_path_distance = CurrentRoamingSettings.despawn_path_distance
	local remembered_area_index = self.remembered_area_index

	remembered_area_index = remembered_area_index or 1

	local count_2 = #areas
	local var_25_14 = num_19

	if count_2 < var_25_14 then
		var_25_14 = count_2
		remembered_area_index = 1
	end

	local num_5 = 0
	local num_6 = 0
	local var_25_17 = remembered_area_index
	local num_7 = 1

	while num_7 <= var_25_14 do
		if count_2 < remembered_area_index then
			remembered_area_index = 1
		end

		local var_25_19 = areas[remembered_area_index]

		var_25_19[num_2] = var_25_19[num]
		var_25_19[num] = 0

		local unbox = var_25_19[1]:unbox()

		for i = 1, count do
			local num_8 = unbox - arg_25_2[i]
			local z = num_8.z

			Vector3.set_z(num_8, 0)

			if not (not (despawn_distance > Vector3.length(num_8)) or not (despawn_distance_z > abs(z))) then
				local var_25_23 = arg_25_4[i]

				if not arg_25_5 and not var_25_23 and not var_25_19[num_3] then
					local a_star_cached, var_25_25, var_25_26 = self.group_manager:a_star_cached(var_25_23, var_25_19[num_3])

					if not (not var_25_25 and not (var_25_25 < despawn_path_distance)) then
						var_25_19[num] = var_25_19[num] + 1
					end
				else
					var_25_19[num] = var_25_19[num] + 1
				end
			end
		end

		local var_25_27 = var_25_19[num]
		local var_25_28 = var_25_19[num_2]

		if var_25_27 ~= var_25_28 then
			if var_25_27 > 0 then
				if var_25_28 == 0 then
					if not self:activate_area(var_25_19, arg_25_3) then
						num_5 = num_5 + 1
						tbl[num_5] = remembered_area_index
					else
						num_6 = num_6 + 1
						self.inside_areas[var_25_19] = true
					end
				end
			elseif var_25_28 > 0 then
				if not self:deactivate_area(var_25_19) then
					num_5 = num_5 + 1
					tbl[num_5] = remembered_area_index
				end

				num_6 = num_6 - 1
			end
		end

		remembered_area_index = remembered_area_index + 1
		num_7 = num_7 + 1
	end

	if num_5 > 0 then
		local function fn_2(arg_26_0, arg_26_1)
			-- function 26
			return arg_26_1 < arg_26_0
		end

		table.sort(tbl, fn_2)

		for j = 1, num_5 do
			shutdown_areas[#shutdown_areas + 1] = fn(areas, tbl[j])
			tbl[j] = nil
		end
	end

	self.remembered_area_index = math.clamp(remembered_area_index - num_5, 1, #areas)
	self.visible = self.visible + num_6
end

EnemyRecycler.add_terror_event_in_area = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local get_group_from_position = self.group_manager:get_group_from_position(arg_27_1:unbox())

	self.areas[#self.areas + 1] = {
		arg_27_1,
		nil,
		0,
		0,
		arg_27_2,
		get_group_from_position,
		"event",
		arg_27_3 or false,
		[11] = self.unique_area_id
	}
end

EnemyRecycler.add_main_path_terror_event = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	print("Adding main path event:", arg_28_1, arg_28_2, arg_28_3, arg_28_4)

	local main_path_events = self.main_path_events
	local closest_pos_at_main_path, var_28_2, var_28_3, var_28_4, var_28_5 = MainPathUtils.closest_pos_at_main_path(nil, arg_28_1:unbox())

	var_28_2 = arg_28_5 or math.max(0, var_28_2 - (arg_28_3 or 45))

	local num = #main_path_events + 1

	main_path_events[num] = {
		var_28_2,
		arg_28_1,
		arg_28_2,
		arg_28_4
	}

	if num == 1 then
		self.current_main_path_event_id = 1
		self.current_main_path_event_activation_dist = var_28_2
	else
		table.sort(main_path_events, function (self, arg_29_1)
			-- function 29
			return self[1] < arg_29_1[1]
		end)

		local var_28_7 = main_path_events[self.current_main_path_event_id]

		self.current_main_path_event_activation_dist = math.min(var_28_7[num_13], self.current_main_path_event_activation_dist)
	end
end

EnemyRecycler.setup_main_path_events = function (self, arg_30_1)
	-- function 30
	local main_path_events = self.main_path_events

	if #main_path_events <= 0 then
		self.current_main_path_event_id = nil

		return
	end

	table.sort(main_path_events, function (self, arg_31_1)
		-- function 31
		return self[1] < arg_31_1[1]
	end)

	self.current_main_path_event_id = 1
	self.current_main_path_event_activation_dist = main_path_events[1][1]
end

EnemyRecycler.draw_main_path_events = function (self, arg_32_1)
	-- function 32
	local main_path_events = self.main_path_events

	for i = 1, #main_path_events do
		local var_32_1 = main_path_events[i][4]

		if var_32_1.event_kind == "event_spline_patrol" then
			self.conflict_director.patrol_analysis:draw_spline_path(var_32_1.spline_way_points, QuickDrawerStay)
		end
	end
end

EnemyRecycler.draw_debug = function (self, arg_33_1)
	-- function 33
	local shutdown_areas = self.shutdown_areas
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "ai_recycler"
	})
	local var_33_2 = Color(255, 140, 255, 200)
	local var_33_3 = Color(255, 255, 40, 100)
	local var_33_4 = Color(128, 30, 40, 230)
	local var_33_5 = Color(255, 255, 200, 0)
	local var_33_6 = Color(255, 0, 200, 100)
	local var_33_7 = Vector3(0, 0, 12)
	local var_33_8 = Vector3(0, 0, 9.5)
	local var_33_9 = Vector3(0, 0, 8.5)
	local var_33_10 = Vector3(0, 0, 3)
	local CurrentRoamingSettings = CurrentRoamingSettings
	local var_33_12 = arg_33_1[1]

	if not var_33_12 then
		return
	end

	local despawn_distance_z = CurrentRoamingSettings.despawn_distance_z
	local despawn_distance = CurrentRoamingSettings.despawn_distance

	drawer:cylinder(var_33_12 + Vector3(0, 0, -despawn_distance_z), var_33_12 + Vector3(0, 0, despawn_distance_z), despawn_distance, var_33_2, 8)
	drawer:cylinder(var_33_12 + Vector3(0, 0, -despawn_distance_z), var_33_12 + Vector3(0, 0, despawn_distance_z), despawn_distance, var_33_2, 8)
	drawer:line(var_33_12 + Vector3(despawn_distance, 0, -despawn_distance_z), var_33_12 + Vector3(-despawn_distance, 0, -despawn_distance_z), var_33_2, 8)
	drawer:line(var_33_12 + Vector3(0, despawn_distance, -despawn_distance_z), var_33_12 + Vector3(0, -despawn_distance, -despawn_distance_z), var_33_2, 8)
	drawer:line(var_33_12 + Vector3(despawn_distance, 0, despawn_distance_z), var_33_12 + Vector3(-despawn_distance, 0, despawn_distance_z), var_33_2, 8)
	drawer:line(var_33_12 + Vector3(0, despawn_distance, despawn_distance_z), var_33_12 + Vector3(0, -despawn_distance, despawn_distance_z), var_33_2, 8)

	local areas = self.areas
	local visible = self.visible
	local num = #areas - visible

	Debug.text("Areas: " .. #areas .. ", visible: " .. visible .. ", not visible: " .. num)

	local str = ""
	local str_2 = ""

	for i = 1, #areas do
		local var_33_20 = areas[i]
		local unbox = var_33_20[1]:unbox()
		local var_33_22 = var_33_20[3]

		if var_33_20[7] == "event" then
			if var_33_20[5] == "roaming_patrol" then
				drawer:sphere(unbox + var_33_7, 0.7, var_33_6)
				drawer:sphere(unbox + var_33_8, 0.7, var_33_6)
				drawer:sphere(unbox + var_33_9, 0.7, var_33_6)
			else
				drawer:sphere(unbox + var_33_7, 2, var_33_5)
				drawer:sphere(unbox + var_33_8, 1, var_33_5)
				drawer:sphere(unbox + var_33_9, 0.5, var_33_5)
			end
		end

		if var_33_22 > 0 then
			drawer:line(unbox, unbox + var_33_7, var_33_2)
			Debug.world_text(unbox + var_33_10, string.format("%s id(%s) S%s/%s", var_33_20[7], var_33_20[11], var_33_20[3], var_33_20[4]), "teal")
		else
			drawer:line(unbox, unbox + var_33_7, var_33_3)
			Debug.world_text(unbox + var_33_10, string.format("%s id(%s) S%s/%s", var_33_20[7], var_33_20[11], var_33_20[3], var_33_20[4]), "tomato")
		end
	end

	for j = 1, #shutdown_areas do
		local var_33_23 = shutdown_areas[j]
		local unbox_2 = var_33_23[1]:unbox()

		drawer:line(unbox_2, unbox_2 + var_33_7 * 0.66, var_33_4)
		Debug.world_text(unbox_2 + var_33_10, string.format("%s id(%s) S%s/%s", var_33_23[7], var_33_23[11], var_33_23[3], var_33_23[4]), "red")
	end

	local player_unit = Managers.player:local_player().player_unit

	if not ALIVE[player_unit] then
		local var_33_26 = self.conflict_director.main_path_player_info[player_unit]

		if not var_33_26 then
			Debug.text("travel-dist: %.1fm, move_percent: %.1f%%, path-index: %d, sub-index: %d", var_33_26.travel_dist, var_33_26.move_percent * 100, var_33_26.path_index, var_33_26.sub_index)
		end
	end
end

local num_20 = 6

EnemyRecycler.far_off_despawn = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local far_off_index = self.far_off_index

	far_off_index = far_off_index or 1

	local count = #arg_34_4
	local var_34_2 = num_20

	if count < var_34_2 then
		var_34_2 = count
		far_off_index = 1
	end

	local destroy_los_distance_squared = LevelHelper:current_level_settings().destroy_los_distance_squared

	destroy_los_distance_squared = destroy_los_distance_squared or RecycleSettings.destroy_los_distance_squared

	local nav_world = self.nav_world
	local count_2 = #arg_34_3

	if count_2 == 0 then
		return
	end

	local distance_squared = Vector3.distance_squared
	local num = 1

	while num <= var_34_2 do
		if count < far_off_index then
			far_off_index = 1
		end

		local var_34_8 = destroy_los_distance_squared
		local flag = false
		local var_34_10 = arg_34_4[far_off_index]
		local var_34_11 = POSITION_LOOKUP[var_34_10]
		local var_34_12 = BLACKBOARDS[var_34_10]

		if not var_34_12 then
			local print = print
			local str = "is related to freezing: "
			local var_34_15 = rawget(_G, "DoubleFreezeContext")

			var_34_15 = var_34_15 or {}

			print(str, not not var_34_15[var_34_10])
		end

		if arg_34_1 > var_34_12.stuck_check_time then
			if not var_34_12.far_off_despawn_immunity then
				if not var_34_12.navigation_extension._enabled and not var_34_12.no_path_found then
					if not var_34_12.stuck_time then
						var_34_12.stuck_time = arg_34_1 + 3
					elseif arg_34_1 > var_34_12.stuck_time then
						flag = true
						var_34_8 = RecycleSettings.destroy_stuck_distance_squared
						var_34_12.stuck_time = nil
					end
				elseif not var_34_12.no_path_found then
					var_34_12.stuck_time = nil
				end
			end

			var_34_12.stuck_check_time = arg_34_1 + 3 + num * arg_34_2
		end

		local num_2 = 0

		for i = 1, count_2 do
			local var_34_17 = arg_34_3[i]

			if var_34_8 < distance_squared(var_34_11, var_34_17) then
				num_2 = num_2 + 1
			end
		end

		if num_2 == count_2 then
			if not flag then
				local printf = printf
				local str_2 = "Destroying unit - ai got stuck breed: %s index: %d size: %d action: %s"
				local name = var_34_12.breed.name
				local var_34_21 = far_off_index
				local var_34_22 = count
				local action = var_34_12.action

				action = not action and var_34_12.action.name

				printf(str_2, name, var_34_21, var_34_22, action)
				self.conflict_director:destroy_unit(var_34_10, var_34_12, "stuck")
			elseif not var_34_12.far_off_despawn_immunity then
				print("Destroying unit - ai too far away from all players. ", var_34_12.breed.name, num, far_off_index, count)
				self.conflict_director:destroy_unit(var_34_10, var_34_12, "far_away")
			end

			count = #arg_34_4

			if count == 0 then
				break
			end
		end

		far_off_index = far_off_index + 1
		num = num + 1
	end

	self.far_off_index = far_off_index
end
