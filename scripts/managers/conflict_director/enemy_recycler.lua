-- chunkname: @scripts/managers/conflict_director/enemy_recycler.lua

EnemyRecycler = class(EnemyRecycler)

local var_0_0 = InterestPointUnits
local var_0_1 = POSITION_LOOKUP
local var_0_2 = Unit.alive
local var_0_3 = 1
local var_0_4 = 2
local var_0_5 = 3
local var_0_6 = 4
local var_0_7 = 5
local var_0_8 = 2
local var_0_9 = 5
local var_0_10 = 7
local var_0_11 = 8
local var_0_12 = 9
local var_0_13 = 10
local var_0_14 = 11
local var_0_15 = 1
local var_0_16 = 2
local var_0_17 = 3
local var_0_18 = 4

local function var_0_19(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0[arg_1_1]
	local var_1_1 = #arg_1_0

	arg_1_0[arg_1_1] = arg_1_0[var_1_1]
	arg_1_0[var_1_1] = nil

	return var_1_0
end

function EnemyRecycler.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	arg_2_0._seed = arg_2_8
	arg_2_0.world = arg_2_1
	arg_2_0.nav_world = arg_2_2
	arg_2_0.conflict_director = Managers.state.conflict
	arg_2_0.group_manager = arg_2_0.conflict_director.navigation_group_manager
	arg_2_0.areas = {}
	arg_2_0.shutdown_areas = {}
	arg_2_0.inside_areas = {}
	arg_2_0.main_path_events = {}
	arg_2_0.current_main_path_event_id = 1
	arg_2_0.current_main_path_event_activation_dist = 999999
	arg_2_0.main_path_info = arg_2_0.conflict_director.main_path_info
	arg_2_0._roaming_ai = 0
	arg_2_0.group_id = 0
	arg_2_0.visible = 0
	arg_2_0.level = LevelHelper:current_level(arg_2_1)
	arg_2_0.ai_group_system = Managers.state.entity:system("ai_group_system")
	arg_2_0.patrol_analysis = arg_2_0.conflict_director.patrol_analysis

	arg_2_0:setup(arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

function EnemyRecycler.debug_print_all_unspawned_packs(arg_3_0)
	local var_3_0 = arg_3_0.areas

	for iter_3_0 = 1, #var_3_0 do
		local var_3_1 = var_3_0[iter_3_0]
		local var_3_2 = var_3_1[var_0_8]
		local var_3_3 = var_3_1[var_0_12]
		local var_3_4 = var_3_1[var_0_10]

		if not var_3_2 and var_3_3 and var_3_4 == "pack" then
			for iter_3_1 = 1, #var_3_3 do
				local var_3_5 = var_3_3[iter_3_1]

				if var_3_5.name then
					print("Found breed:", var_3_5.name, "in area:", iter_3_0)
				else
					for iter_3_2 = 1, #var_3_5 do
						print("Found sub-breeds:", var_3_5[iter_3_2].name, "in area:", iter_3_0)
					end
				end
			end
		end
	end
end

function EnemyRecycler.get_replacement_breed(arg_4_0, arg_4_1)
	local var_4_0

	if type(arg_4_1) == "table" then
		var_4_0 = Breeds[arg_4_1[math.random(1, #arg_4_1)]]
	else
		var_4_0 = Breeds[arg_4_1]
	end

	return var_4_0
end

function EnemyRecycler.patch_override_breed(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.areas

	for iter_5_0 = 1, #var_5_0 do
		local var_5_1 = var_5_0[iter_5_0]
		local var_5_2 = var_5_1[var_0_8]
		local var_5_3 = var_5_1[var_0_12]
		local var_5_4 = var_5_1[var_0_10]

		if not var_5_2 and var_5_3 and var_5_4 == "pack" then
			for iter_5_1 = 1, #var_5_3 do
				local var_5_5 = var_5_3[iter_5_1]

				if var_5_5.name then
					if var_5_5.name == arg_5_1 then
						local var_5_6 = arg_5_0:get_replacement_breed(arg_5_2)

						var_5_3[iter_5_1] = var_5_6

						print("Replacing breed:", arg_5_1, "with:", var_5_6.name, "in area:", iter_5_0)
					end
				else
					for iter_5_2 = 1, #var_5_5 do
						if var_5_5[iter_5_2].name == arg_5_1 then
							local var_5_7 = arg_5_0:get_replacement_breed(arg_5_2)

							var_5_5[iter_5_2] = var_5_7

							print("Replacing sub-breed:", arg_5_1, "with:", var_5_7.name, "in area:", iter_5_0)
						end
					end
				end
			end
		end
	end
end

function EnemyRecycler._random(arg_6_0, ...)
	local var_6_0, var_6_1 = Math.next_random(arg_6_0._seed, ...)

	arg_6_0._seed = var_6_0

	return var_6_1
end

function EnemyRecycler._random_dice_roll(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0, var_7_1 = LoadedDice.roll_seeded(arg_7_1, arg_7_2, arg_7_0._seed)

	arg_7_0._seed = var_7_0

	return var_7_1
end

function EnemyRecycler.set_seed(arg_8_0, arg_8_1)
	fassert(arg_8_1 and type(arg_8_1) == "number", "Bad seed input!")

	arg_8_0._seed = arg_8_1
end

function EnemyRecycler.setup_forbidden_zones(arg_9_0, arg_9_1)
	arg_9_0.forbidden_zones = {}

	local var_9_0 = arg_9_0.forbidden_zones

	for iter_9_0 = 1, 9 do
		local var_9_1 = "forbidden_zone" .. iter_9_0

		if Level.has_volume(arg_9_0.level, var_9_1) then
			var_9_0[#var_9_0 + 1] = var_9_1
		end
	end

	local var_9_2 = Managers.state.spawn:checkpoint_data()

	if var_9_2 then
		var_9_0[#var_9_0 + 1] = var_9_2.no_spawn_volume
	end

	for iter_9_1 = 20, 39 do
		local var_9_3 = LAYER_ID_MAPPING[iter_9_1]

		if var_9_3 and NAV_TAG_VOLUME_LAYER_COST_AI[var_9_3] == 0 then
			print("Layer named:", var_9_3, ", id:", iter_9_1, " has cost 0 --> removed all roaming spawns found inside")

			var_9_0[#var_9_0 + 1] = var_9_3
		end
	end

	arg_9_0.has_forbidden_zones = #var_9_0 > 0
end

local function var_0_20(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	for iter_10_0 = 1, arg_10_2 do
		if Level.is_point_inside_volume(arg_10_0, arg_10_1[iter_10_0], arg_10_3) then
			return false
		end
	end

	return true
end

function EnemyRecycler.add_critters(arg_11_0)
	local var_11_0 = Managers.state.game_mode:level_key()
	local var_11_1 = LevelSettings[var_11_0].level_name

	if LevelResource.nested_level_count(var_11_1) > 0 then
		var_11_1 = LevelResource.nested_level_resource_name(var_11_1, 0)
	end

	local var_11_2 = LevelResource.unit_indices(var_11_1, "units/hub_elements/critter_spawner")

	for iter_11_0, iter_11_1 in ipairs(var_11_2) do
		local var_11_3 = LevelResource.unit_position(var_11_1, iter_11_1)
		local var_11_4 = LevelResource.unit_data(var_11_1, iter_11_1)
		local var_11_5 = DynamicData.get(var_11_4, "breed")

		assert(Breeds[var_11_5], "Level '%s' has placed a 'critter_spawner' unit, with a bad breed-name: '%s'", var_11_1, var_11_5)

		local var_11_6 = QuaternionBox(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))))
		local var_11_7 = Vector3Box(var_11_3)

		arg_11_0:add_breed(var_11_5, var_11_7, var_11_6)
	end
end

function EnemyRecycler.boxify_waypoint_table(arg_12_0, arg_12_1)
	local var_12_0 = {}

	for iter_12_0 = 1, #arg_12_1 do
		local var_12_1 = arg_12_1[iter_12_0]

		var_12_0[iter_12_0] = Vector3Box(var_12_1[1], var_12_1[2], var_12_1[3])
	end

	return var_12_0
end

function EnemyRecycler.draw_roaming_splines(arg_13_0)
	local var_13_0 = Color(75, 200, 200)
	local var_13_1 = Color(200, 75, 0)
	local var_13_2 = QuickDrawerStay
	local var_13_3 = arg_13_0.ai_group_system._roaming_splines

	for iter_13_0, iter_13_1 in pairs(var_13_3) do
		if iter_13_1.spline_points then
			local var_13_4 = iter_13_1.has_party

			if var_13_4 then
				QuickDrawerStay:sphere(iter_13_1.has_party:unbox(), 1, Color(0, 255, 0))
				print("FOUND ROAMING!")
			end

			local var_13_5 = var_13_4 and var_13_0 or var_13_1

			arg_13_0.ai_group_system:draw_spline(iter_13_1.spline_points, var_13_2, var_13_5)
		end
	end
end

local var_0_21 = SizeOfInterestPoint
local var_0_22 = 3

function EnemyRecycler.inject_roaming_patrol(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = var_0_21[arg_14_4]

	if var_14_0 < var_0_22 then
		return
	end

	local var_14_1 = BreedPacks[arg_14_3].patrol_overrides

	if var_14_1 and arg_14_0:_random() < var_14_1.patrol_chance then
		local var_14_2 = false
		local var_14_3, var_14_4, var_14_5 = arg_14_0.conflict_director.level_analysis:get_closest_roaming_spline(arg_14_1:unbox(), var_14_2)

		if not var_14_3 then
			return false
		end

		local var_14_6 = arg_14_0.ai_group_system:spline(var_14_3)

		if var_14_6 then
			var_14_5 = arg_14_0.patrol_analysis:get_path_point(var_14_6.spline_points, nil, arg_14_0:_random() * 0.9)
		end

		local var_14_7 = arg_14_0.group_manager:get_group_from_position(var_14_5)
		local var_14_8 = BreedPacksBySize[arg_14_3][var_14_0]
		local var_14_9 = var_14_8.prob
		local var_14_10 = var_14_8.alias
		local var_14_11 = arg_14_0:_random_dice_roll(var_14_9, var_14_10)
		local var_14_12 = var_14_8.packs[var_14_11]
		local var_14_13 = Vector3Box(var_14_5)
		local var_14_14 = var_14_4.waypoints

		if var_14_6 then
			var_14_6.has_party = var_14_13
		end

		local var_14_15 = not var_14_6 and arg_14_0:boxify_waypoint_table(var_14_14) or nil
		local var_14_16 = {
			spline_type = "roaming",
			optional_pos = var_14_13,
			pack_type = arg_14_3,
			spline_name = var_14_3,
			pack = var_14_12,
			spline_way_points = var_14_15,
			zone_data = arg_14_5
		}

		return {
			var_14_13,
			false,
			0,
			0,
			"roaming_patrol",
			var_14_7,
			"event",
			var_14_16
		}
	end

	return false
end

function EnemyRecycler.setup(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_0.unique_area_id = 0

	arg_15_0:reset_areas()
	arg_15_0:setup_forbidden_zones()

	local var_15_0 = arg_15_0.areas
	local var_15_1 = LevelHelper:current_level_settings()
	local var_15_2 = 1
	local var_15_3 = arg_15_0.forbidden_zones
	local var_15_4 = #arg_15_0.forbidden_zones
	local var_15_5 = arg_15_0.level
	local var_15_6 = arg_15_0.nav_world
	local var_15_7 = arg_15_0.conflict_director.nav_tag_volume_handler
	local var_15_8 = not script_data.ai_roaming_patrols_disabled and arg_15_0.conflict_director.level_analysis.patrol_waypoints

	if not CurrentConflictSettings.roaming.disabled then
		for iter_15_0 = 1, #arg_15_1 do
			local var_15_9 = arg_15_1[iter_15_0]
			local var_15_10 = arg_15_2[iter_15_0]
			local var_15_11 = arg_15_3[iter_15_0]
			local var_15_12 = arg_15_4[iter_15_0]
			local var_15_13 = arg_15_5[iter_15_0]
			local var_15_14 = var_15_9:unbox()
			local var_15_15 = true
			local var_15_16 = arg_15_0.group_manager:get_group_from_position(var_15_14)

			if not var_0_20(var_15_5, var_15_3, var_15_4, var_15_14) then
				var_15_15 = false
			elseif NavTagVolumeUtils.inside_level_volume_layer(var_15_5, var_15_7, var_15_14, "NO_SPAWN") or NavTagVolumeUtils.inside_level_volume_layer(var_15_5, var_15_7, var_15_14, "NO_BOTS_NO_SPAWN") then
				var_15_15 = false
			elseif var_15_8 then
				local var_15_17 = arg_15_0:inject_roaming_patrol(var_15_9, var_15_11, var_15_12.type, var_15_10, var_15_13)

				if var_15_17 then
					var_15_0[var_15_2] = var_15_17
					var_15_2 = var_15_2 + 1
					var_15_15 = false
				end
			end

			fassert(var_15_10, "Fatal error, missing interest point unit")

			if var_15_15 then
				var_15_0[var_15_2] = {
					var_15_9,
					false,
					0,
					0,
					var_15_10,
					var_15_16,
					"pack",
					var_15_11,
					var_15_12,
					var_15_13
				}
				var_15_2 = var_15_2 + 1
			end
		end

		arg_15_0.unique_area_id = var_15_2
	end

	if not CurrentConflictSettings.roaming.disabled and not script_data.ai_critter_spawning_disabled then
		arg_15_0:add_critters()
	end
end

function EnemyRecycler.reset_areas(arg_16_0)
	local var_16_0 = arg_16_0.areas

	for iter_16_0 = 1, #var_16_0 do
		local var_16_1 = var_16_0[iter_16_0]
		local var_16_2 = var_16_1[var_0_10]
		local var_16_3 = var_16_1[var_0_8]

		if var_16_3 and (var_16_2 ~= "pack" or var_16_3[1][1] ~= nil) then
			arg_16_0:deactivate_area(var_16_1)
		end

		var_16_0[iter_16_0] = nil
	end

	local var_16_4 = arg_16_0.shutdown_areas

	for iter_16_1 = 1, #var_16_4 do
		var_16_4[iter_16_1] = nil
	end

	local var_16_5 = arg_16_0.inside_areas

	for iter_16_2 = 1, #var_16_5 do
		var_16_5[iter_16_2] = nil
	end

	table.clear(arg_16_0.main_path_events)
end

function EnemyRecycler.update(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	arg_17_0:_update_roaming_spawning(arg_17_1, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	arg_17_0.ai_group_system:prepare_update_recycler(arg_17_3, arg_17_5, arg_17_6)
end

function EnemyRecycler.update_main_path_events(arg_18_0, arg_18_1)
	if not arg_18_0.current_main_path_event_id or script_data.ai_boss_spawning_disabled then
		return
	end

	if arg_18_0.main_path_info.ahead_travel_dist >= arg_18_0.current_main_path_event_activation_dist then
		local var_18_0 = arg_18_0.current_main_path_event_id
		local var_18_1 = arg_18_0.main_path_events
		local var_18_2 = var_18_1[var_18_0]
		local var_18_3 = var_18_2[var_0_17]
		local var_18_4 = var_18_2[var_0_16]
		local var_18_5 = var_18_2[var_0_18]
		local var_18_6

		if var_18_5 then
			local var_18_7 = var_18_5.gizmo_unit

			if var_18_7 then
				var_18_6 = Unit.get_data(var_18_7, "map_section")
			end

			var_18_5.optional_pos = var_18_4
			var_18_5.map_section = var_18_6
		end

		print("main path terror event triggered:", var_18_3)
		TerrorEventMixer.start_event(var_18_3, var_18_5)

		local var_18_8 = var_18_0 + 1
		local var_18_9 = var_18_1[var_18_8]

		if var_18_9 then
			arg_18_0.current_main_path_event_id = var_18_8
			arg_18_0.current_main_path_event_activation_dist = var_18_9[var_0_15]
		else
			arg_18_0.current_main_path_event_id = nil
		end
	end
end

function EnemyRecycler.spawn_interest_point(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0 = {
		ai_interest_point_system = {
			recycler = true,
			do_spawn = arg_19_3,
			pack_members = arg_19_5,
			zone_data = arg_19_6
		}
	}
	local var_19_1 = Quaternion(Vector3.up(), arg_19_4)
	local var_19_2 = Managers.state.unit_spawner:spawn_network_unit(arg_19_1, "interest_point", var_19_0, arg_19_2:unbox(), var_19_1)

	assert(var_19_2, "Bad interest point, not found")

	return var_19_2
end

function EnemyRecycler.add_breed(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_0.unique_area_id = arg_20_0.unique_area_id + 1

	local var_20_0 = {
		[2] = arg_20_1,
		[3] = arg_20_2,
		[4] = arg_20_3,
		[5] = arg_20_4
	}
	local var_20_1 = {
		var_20_0
	}
	local var_20_2 = arg_20_0.group_manager:get_group_from_position(arg_20_2:unbox())

	arg_20_0.areas[#arg_20_0.areas + 1] = {
		arg_20_2,
		var_20_1,
		0,
		0,
		false,
		var_20_2,
		"breed"
	}
end

function EnemyRecycler.breed_spawned_callback(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_2.dead_breed_data

	BREED_DIE_LOOKUP[arg_21_0] = {
		EnemyRecycler.cleanup_dead_breed,
		var_21_0
	}
end

function EnemyRecycler.cleanup_dead_breed(arg_22_0, arg_22_1)
	arg_22_1[var_0_3] = nil
end

function EnemyRecycler.activate_area(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = 2
	local var_23_1 = arg_23_1[var_0_8]
	local var_23_2 = arg_23_1[var_0_10]

	if not var_23_1 then
		if var_23_2 == "pack" then
			if arg_23_2 == 0 then
				return true
			else
				local var_23_3 = arg_23_1[var_0_9]
				local var_23_4 = arg_23_1[var_0_12]
				local var_23_5 = arg_23_1[var_0_13]
				local var_23_6 = arg_23_1[1]
				local var_23_7 = true
				local var_23_8 = arg_23_0:spawn_interest_point(var_23_3, var_23_6, var_23_7, arg_23_1[var_0_11], var_23_4, var_23_5)

				arg_23_1[var_23_0] = {
					{
						var_23_8,
						var_23_3,
						var_23_6
					}
				}
			end
		elseif var_23_2 == "event" then
			local var_23_9 = arg_23_1[1]
			local var_23_10 = arg_23_1[var_0_9]
			local var_23_11 = arg_23_1[var_0_11] or {
				optional_pos = var_23_9
			}

			TerrorEventMixer.start_event(var_23_10, var_23_11)

			return true
		end
	elseif var_23_2 == "pack" then
		local var_23_12 = var_23_1[1][1]
		local var_23_13 = var_23_1[1][2]
		local var_23_14 = var_23_1[1][3]

		assert(var_23_12 == nil, "lolwut")

		local var_23_15 = false
		local var_23_16 = arg_23_0:spawn_interest_point(var_23_13, var_23_14, var_23_15, arg_23_1[var_0_11])

		var_23_1[1][1] = var_23_16

		for iter_23_0 = 2, #var_23_1 do
			local var_23_17 = var_23_1[iter_23_0]
			local var_23_18 = var_23_17[var_0_4]
			local var_23_19 = var_23_17[var_0_5]
			local var_23_20 = var_23_17[var_0_6]
			local var_23_21 = var_23_17[var_0_7] or {}

			var_23_21.ignore_event_counter = true
			var_23_21.spawned_func = EnemyRecycler.breed_spawned_callback
			var_23_21.dead_breed_data = var_23_17

			local var_23_22 = Breeds[var_23_18]
			local var_23_23 = "enemy_recycler"
			local var_23_24 = "roam"
			local var_23_25 = arg_23_0.conflict_director:spawn_queued_unit(var_23_22, var_23_19, var_23_20, var_23_23, nil, var_23_24, var_23_21, nil, var_23_17)

			var_23_17[var_0_3] = var_23_25
			arg_23_0._roaming_ai = arg_23_0._roaming_ai + 1
		end
	elseif var_23_2 == "breed" then
		local var_23_26 = var_23_1[1]
		local var_23_27 = var_23_26[var_0_4]
		local var_23_28 = var_23_26[var_0_5]
		local var_23_29 = var_23_26[var_0_6]
		local var_23_30 = var_23_26[var_0_7] or {}

		var_23_30.ignore_event_counter = true
		var_23_30.spawned_func = EnemyRecycler.breed_spawned_callback
		var_23_30.dead_breed_data = var_23_26

		local var_23_31 = Breeds[var_23_27]
		local var_23_32 = "enemy_recycler"
		local var_23_33 = var_23_30.spawn_type or "roam"
		local var_23_34 = arg_23_0.conflict_director:spawn_queued_unit(var_23_31, var_23_28, var_23_29, var_23_32, nil, var_23_33, var_23_30, nil, var_23_26)

		var_23_26[var_0_3] = var_23_34
		arg_23_0._roaming_ai = arg_23_0._roaming_ai + 1
	end

	return false
end

local var_0_23 = 25

function EnemyRecycler.deactivate_area(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1[var_0_8]
	local var_24_1 = arg_24_1[var_0_10]
	local var_24_2 = BLACKBOARDS

	if var_24_1 == "pack" then
		if var_24_0 then
			local var_24_3 = var_24_0[1][1]
			local var_24_4 = ScriptUnit.extension(var_24_3, "ai_interest_point_system")
			local var_24_5 = var_24_4.points
			local var_24_6 = var_24_4.points_n
			local var_24_7 = 1
			local var_24_8

			for iter_24_0 = 2, #var_24_0 do
				local var_24_9 = var_24_0[iter_24_0][1]

				if type(var_24_9) == "number" then
					local var_24_10 = arg_24_0.conflict_director:remove_queued_unit(var_24_9)

					arg_24_0._roaming_ai = arg_24_0._roaming_ai - 1
					var_24_7 = var_24_7 + 1
					var_24_0[var_24_7] = {
						[2] = var_24_10[1].name,
						[3] = var_24_10[2],
						[4] = var_24_10[3],
						[5] = var_24_10[7]
					}
					var_24_8 = true
				elseif HEALTH_ALIVE[var_24_9] then
					local var_24_11 = var_24_9
					local var_24_12 = var_24_2[var_24_11]

					if not var_24_12.target_unit_found_time then
						local var_24_13 = var_0_1[var_24_11]

						if var_24_12.next_smart_object_data.next_smart_object_id ~= nil then
							var_24_13 = var_24_12.next_smart_object_data.entrance_pos:unbox()
						end

						var_24_7 = var_24_7 + 1
						var_24_0[var_24_7] = {
							[2] = Unit.get_data(var_24_11, "breed").name,
							[3] = Vector3Box(var_24_13),
							[4] = QuaternionBox(Unit.local_rotation(var_24_11, 0)),
							[5] = var_24_12.optional_spawn_data
						}

						arg_24_0.conflict_director:destroy_unit(var_24_11, var_24_12, "deactivate_area")

						arg_24_0._roaming_ai = arg_24_0._roaming_ai - 1
					end

					var_24_8 = true
				end
			end

			if not var_24_8 then
				for iter_24_1 = 1, var_24_6 do
					local var_24_14 = var_24_5[iter_24_1]

					if type(var_24_14[1]) == "number" then
						local var_24_15 = arg_24_0.conflict_director:remove_queued_unit(var_24_14[1])

						arg_24_0._roaming_ai = arg_24_0._roaming_ai - 1
						var_24_7 = var_24_7 + 1
						var_24_0[var_24_7] = {
							[2] = var_24_15[1].name,
							[3] = var_24_15[2],
							[4] = var_24_15[3],
							[5] = var_24_15[7]
						}
					end

					local var_24_16 = var_24_14.claim_unit or type(var_24_14[1]) ~= "number" and var_24_14[1]

					if var_24_16 and HEALTH_ALIVE[var_24_16] then
						local var_24_17 = var_24_2[var_24_16]

						if not var_24_17.target_unit_found_time then
							local var_24_18 = var_0_1[var_24_16]

							if var_24_17.next_smart_object_data.next_smart_object_id ~= nil then
								var_24_18 = var_24_17.next_smart_object_data.entrance_pos:unbox()
							end

							var_24_7 = var_24_7 + 1
							var_24_0[var_24_7] = {
								[2] = Unit.get_data(var_24_16, "breed").name,
								[3] = Vector3Box(var_24_18),
								[4] = QuaternionBox(Unit.local_rotation(var_24_16, 0)),
								[5] = var_24_17.optional_spawn_data
							}

							arg_24_0.conflict_director:destroy_unit(var_24_16, var_24_17, "deactivate_area")

							arg_24_0._roaming_ai = arg_24_0._roaming_ai - 1
						end
					end
				end
			end

			for iter_24_2 = var_24_7 + 1, #var_24_0 do
				assert(iter_24_2 ~= 1)

				var_24_0[iter_24_2] = nil
			end

			Managers.state.unit_spawner:mark_for_deletion(var_24_3)

			var_24_0[1][1] = nil

			if var_24_7 == 1 then
				return false
			end
		end
	elseif var_24_1 == "breed" then
		local var_24_19 = var_24_0[1]
		local var_24_20 = var_24_19[var_0_3]

		if type(var_24_20) == "number" then
			arg_24_0.conflict_director:remove_queued_unit(var_24_20)

			arg_24_0._roaming_ai = arg_24_0._roaming_ai - 1

			return true
		end

		local var_24_21 = HEALTH_ALIVE[var_24_20]
		local var_24_22 = false
		local var_24_23

		if var_24_21 then
			var_24_23 = var_24_2[var_24_20]

			if not var_24_23.target_unit_found_time then
				local var_24_24 = var_0_1[var_24_20]

				if var_24_23.next_smart_object_data.next_smart_object_id ~= nil then
					var_24_24 = var_24_23.next_smart_object_data.entrance_pos:unbox()
				end

				var_24_19[var_0_5] = Vector3Box(var_24_24)
				var_24_19[var_0_6] = QuaternionBox(Unit.local_rotation(var_24_20, 0))
				var_24_19[var_0_4] = var_24_23.breed.name
				var_24_22 = true
			end
		end

		if var_24_22 then
			arg_24_0.conflict_director:destroy_unit(var_24_20, var_24_23, "deactivate_area")

			arg_24_0._roaming_ai = arg_24_0._roaming_ai - 1
		else
			return false
		end
	end

	return true
end

local var_0_24 = 20
local var_0_25 = {}

function EnemyRecycler._update_roaming_spawning(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = 3
	local var_25_1 = 4
	local var_25_2 = 6
	local var_25_3 = CurrentRoamingSettings
	local var_25_4 = var_25_3.despawn_distance
	local var_25_5 = var_25_3.despawn_distance_z or 30
	local var_25_6 = var_25_4 + 5
	local var_25_7 = math.abs
	local var_25_8 = arg_25_0.areas
	local var_25_9 = arg_25_0.shutdown_areas
	local var_25_10 = #arg_25_2
	local var_25_11 = CurrentRoamingSettings.despawn_path_distance
	local var_25_12 = arg_25_0.remembered_area_index or 1
	local var_25_13 = #var_25_8
	local var_25_14 = var_0_24

	if var_25_13 < var_25_14 then
		var_25_14 = var_25_13
		var_25_12 = 1
	end

	local var_25_15 = 0
	local var_25_16 = 0
	local var_25_17 = var_25_12
	local var_25_18 = 1

	while var_25_18 <= var_25_14 do
		if var_25_13 < var_25_12 then
			var_25_12 = 1
		end

		local var_25_19 = var_25_8[var_25_12]

		var_25_19[var_25_1] = var_25_19[var_25_0]
		var_25_19[var_25_0] = 0

		local var_25_20 = var_25_19[1]:unbox()

		for iter_25_0 = 1, var_25_10 do
			local var_25_21 = var_25_20 - arg_25_2[iter_25_0]
			local var_25_22 = var_25_21.z

			Vector3.set_z(var_25_21, 0)

			if var_25_4 > Vector3.length(var_25_21) and var_25_5 > var_25_7(var_25_22) then
				local var_25_23 = arg_25_4[iter_25_0]

				if arg_25_5 and var_25_23 and var_25_19[var_25_2] then
					local var_25_24, var_25_25, var_25_26 = arg_25_0.group_manager:a_star_cached(var_25_23, var_25_19[var_25_2])

					if not var_25_25 or var_25_25 < var_25_11 then
						var_25_19[var_25_0] = var_25_19[var_25_0] + 1
					end
				else
					var_25_19[var_25_0] = var_25_19[var_25_0] + 1
				end
			end
		end

		local var_25_27 = var_25_19[var_25_0]
		local var_25_28 = var_25_19[var_25_1]

		if var_25_27 ~= var_25_28 then
			if var_25_27 > 0 then
				if var_25_28 == 0 then
					if arg_25_0:activate_area(var_25_19, arg_25_3) then
						var_25_15 = var_25_15 + 1
						var_0_25[var_25_15] = var_25_12
					else
						var_25_16 = var_25_16 + 1
						arg_25_0.inside_areas[var_25_19] = true
					end
				end
			elseif var_25_28 > 0 then
				if not arg_25_0:deactivate_area(var_25_19) then
					var_25_15 = var_25_15 + 1
					var_0_25[var_25_15] = var_25_12
				end

				var_25_16 = var_25_16 - 1
			end
		end

		var_25_12 = var_25_12 + 1
		var_25_18 = var_25_18 + 1
	end

	if var_25_15 > 0 then
		local function var_25_29(arg_26_0, arg_26_1)
			return arg_26_1 < arg_26_0
		end

		table.sort(var_0_25, var_25_29)

		for iter_25_1 = 1, var_25_15 do
			var_25_9[#var_25_9 + 1] = var_0_19(var_25_8, var_0_25[iter_25_1])
			var_0_25[iter_25_1] = nil
		end
	end

	arg_25_0.remembered_area_index = math.clamp(var_25_12 - var_25_15, 1, #var_25_8)
	arg_25_0.visible = arg_25_0.visible + var_25_16
end

function EnemyRecycler.add_terror_event_in_area(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0.group_manager:get_group_from_position(arg_27_1:unbox())

	arg_27_0.areas[#arg_27_0.areas + 1] = {
		arg_27_1,
		nil,
		0,
		0,
		arg_27_2,
		var_27_0,
		"event",
		arg_27_3 or false,
		[11] = arg_27_0.unique_area_id
	}
end

function EnemyRecycler.add_main_path_terror_event(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	print("Adding main path event:", arg_28_1, arg_28_2, arg_28_3, arg_28_4)

	local var_28_0 = arg_28_0.main_path_events
	local var_28_1, var_28_2, var_28_3, var_28_4, var_28_5 = MainPathUtils.closest_pos_at_main_path(nil, arg_28_1:unbox())

	var_28_2 = arg_28_5 or math.max(0, var_28_2 - (arg_28_3 or 45))

	local var_28_6 = #var_28_0 + 1

	var_28_0[var_28_6] = {
		var_28_2,
		arg_28_1,
		arg_28_2,
		arg_28_4
	}

	if var_28_6 == 1 then
		arg_28_0.current_main_path_event_id = 1
		arg_28_0.current_main_path_event_activation_dist = var_28_2
	else
		table.sort(var_28_0, function(arg_29_0, arg_29_1)
			return arg_29_0[1] < arg_29_1[1]
		end)

		local var_28_7 = var_28_0[arg_28_0.current_main_path_event_id]

		arg_28_0.current_main_path_event_activation_dist = math.min(var_28_7[var_0_15], arg_28_0.current_main_path_event_activation_dist)
	end
end

function EnemyRecycler.setup_main_path_events(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.main_path_events

	if #var_30_0 <= 0 then
		arg_30_0.current_main_path_event_id = nil

		return
	end

	table.sort(var_30_0, function(arg_31_0, arg_31_1)
		return arg_31_0[1] < arg_31_1[1]
	end)

	arg_30_0.current_main_path_event_id = 1
	arg_30_0.current_main_path_event_activation_dist = var_30_0[1][1]
end

function EnemyRecycler.draw_main_path_events(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.main_path_events

	for iter_32_0 = 1, #var_32_0 do
		local var_32_1 = var_32_0[iter_32_0][4]

		if var_32_1.event_kind == "event_spline_patrol" then
			arg_32_0.conflict_director.patrol_analysis:draw_spline_path(var_32_1.spline_way_points, QuickDrawerStay)
		end
	end
end

function EnemyRecycler.draw_debug(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.shutdown_areas
	local var_33_1 = Managers.state.debug:drawer({
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
	local var_33_11 = CurrentRoamingSettings
	local var_33_12 = arg_33_1[1]

	if not var_33_12 then
		return
	end

	local var_33_13 = var_33_11.despawn_distance_z
	local var_33_14 = var_33_11.despawn_distance

	var_33_1:cylinder(var_33_12 + Vector3(0, 0, -var_33_13), var_33_12 + Vector3(0, 0, var_33_13), var_33_14, var_33_2, 8)
	var_33_1:cylinder(var_33_12 + Vector3(0, 0, -var_33_13), var_33_12 + Vector3(0, 0, var_33_13), var_33_14, var_33_2, 8)
	var_33_1:line(var_33_12 + Vector3(var_33_14, 0, -var_33_13), var_33_12 + Vector3(-var_33_14, 0, -var_33_13), var_33_2, 8)
	var_33_1:line(var_33_12 + Vector3(0, var_33_14, -var_33_13), var_33_12 + Vector3(0, -var_33_14, -var_33_13), var_33_2, 8)
	var_33_1:line(var_33_12 + Vector3(var_33_14, 0, var_33_13), var_33_12 + Vector3(-var_33_14, 0, var_33_13), var_33_2, 8)
	var_33_1:line(var_33_12 + Vector3(0, var_33_14, var_33_13), var_33_12 + Vector3(0, -var_33_14, var_33_13), var_33_2, 8)

	local var_33_15 = arg_33_0.areas
	local var_33_16 = arg_33_0.visible
	local var_33_17 = #var_33_15 - var_33_16

	Debug.text("Areas: " .. #var_33_15 .. ", visible: " .. var_33_16 .. ", not visible: " .. var_33_17)

	local var_33_18 = ""
	local var_33_19 = ""

	for iter_33_0 = 1, #var_33_15 do
		local var_33_20 = var_33_15[iter_33_0]
		local var_33_21 = var_33_20[1]:unbox()
		local var_33_22 = var_33_20[3]

		if var_33_20[7] == "event" then
			if var_33_20[5] == "roaming_patrol" then
				var_33_1:sphere(var_33_21 + var_33_7, 0.7, var_33_6)
				var_33_1:sphere(var_33_21 + var_33_8, 0.7, var_33_6)
				var_33_1:sphere(var_33_21 + var_33_9, 0.7, var_33_6)
			else
				var_33_1:sphere(var_33_21 + var_33_7, 2, var_33_5)
				var_33_1:sphere(var_33_21 + var_33_8, 1, var_33_5)
				var_33_1:sphere(var_33_21 + var_33_9, 0.5, var_33_5)
			end
		end

		if var_33_22 > 0 then
			var_33_1:line(var_33_21, var_33_21 + var_33_7, var_33_2)
			Debug.world_text(var_33_21 + var_33_10, string.format("%s id(%s) S%s/%s", var_33_20[7], var_33_20[11], var_33_20[3], var_33_20[4]), "teal")
		else
			var_33_1:line(var_33_21, var_33_21 + var_33_7, var_33_3)
			Debug.world_text(var_33_21 + var_33_10, string.format("%s id(%s) S%s/%s", var_33_20[7], var_33_20[11], var_33_20[3], var_33_20[4]), "tomato")
		end
	end

	for iter_33_1 = 1, #var_33_0 do
		local var_33_23 = var_33_0[iter_33_1]
		local var_33_24 = var_33_23[1]:unbox()

		var_33_1:line(var_33_24, var_33_24 + var_33_7 * 0.66, var_33_4)
		Debug.world_text(var_33_24 + var_33_10, string.format("%s id(%s) S%s/%s", var_33_23[7], var_33_23[11], var_33_23[3], var_33_23[4]), "red")
	end

	local var_33_25 = Managers.player:local_player().player_unit

	if ALIVE[var_33_25] then
		local var_33_26 = arg_33_0.conflict_director.main_path_player_info[var_33_25]

		if var_33_26 then
			Debug.text("travel-dist: %.1fm, move_percent: %.1f%%, path-index: %d, sub-index: %d", var_33_26.travel_dist, var_33_26.move_percent * 100, var_33_26.path_index, var_33_26.sub_index)
		end
	end
end

local var_0_26 = 6

function EnemyRecycler.far_off_despawn(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = arg_34_0.far_off_index or 1
	local var_34_1 = #arg_34_4
	local var_34_2 = var_0_26

	if var_34_1 < var_34_2 then
		var_34_2 = var_34_1
		var_34_0 = 1
	end

	local var_34_3 = LevelHelper:current_level_settings().destroy_los_distance_squared or RecycleSettings.destroy_los_distance_squared
	local var_34_4 = arg_34_0.nav_world
	local var_34_5 = #arg_34_3

	if var_34_5 == 0 then
		return
	end

	local var_34_6 = Vector3.distance_squared
	local var_34_7 = 1

	while var_34_7 <= var_34_2 do
		if var_34_1 < var_34_0 then
			var_34_0 = 1
		end

		local var_34_8 = var_34_3
		local var_34_9 = false
		local var_34_10 = arg_34_4[var_34_0]
		local var_34_11 = var_0_1[var_34_10]
		local var_34_12 = BLACKBOARDS[var_34_10]

		if not var_34_12 then
			print("is related to freezing: ", not not (rawget(_G, "DoubleFreezeContext") or {})[var_34_10])
		end

		if arg_34_1 > var_34_12.stuck_check_time then
			if not var_34_12.far_off_despawn_immunity then
				if var_34_12.navigation_extension._enabled and var_34_12.no_path_found then
					if not var_34_12.stuck_time then
						var_34_12.stuck_time = arg_34_1 + 3
					elseif arg_34_1 > var_34_12.stuck_time then
						var_34_9 = true
						var_34_8 = RecycleSettings.destroy_stuck_distance_squared
						var_34_12.stuck_time = nil
					end
				elseif not var_34_12.no_path_found then
					var_34_12.stuck_time = nil
				end
			end

			var_34_12.stuck_check_time = arg_34_1 + 3 + var_34_7 * arg_34_2
		end

		local var_34_13 = 0

		for iter_34_0 = 1, var_34_5 do
			local var_34_14 = arg_34_3[iter_34_0]

			if var_34_8 < var_34_6(var_34_11, var_34_14) then
				var_34_13 = var_34_13 + 1
			end
		end

		if var_34_13 == var_34_5 then
			if var_34_9 then
				printf("Destroying unit - ai got stuck breed: %s index: %d size: %d action: %s", var_34_12.breed.name, var_34_0, var_34_1, var_34_12.action and var_34_12.action.name)
				arg_34_0.conflict_director:destroy_unit(var_34_10, var_34_12, "stuck")
			elseif not var_34_12.far_off_despawn_immunity then
				print("Destroying unit - ai too far away from all players. ", var_34_12.breed.name, var_34_7, var_34_0, var_34_1)
				arg_34_0.conflict_director:destroy_unit(var_34_10, var_34_12, "far_away")
			end

			var_34_1 = #arg_34_4

			if var_34_1 == 0 then
				break
			end
		end

		var_34_0 = var_34_0 + 1
		var_34_7 = var_34_7 + 1
	end

	arg_34_0.far_off_index = var_34_0
end
