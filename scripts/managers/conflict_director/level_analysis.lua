-- chunkname: @scripts/managers/conflict_director/level_analysis.lua

require("scripts/managers/conflict_director/main_path_spawning_generator")

LevelAnalysis = class(LevelAnalysis)

function LevelAnalysis.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.nav_world = arg_1_1
	arg_1_0.using_editor = arg_1_2
	arg_1_0.cover_points_broadphase = Broadphase(40, 512)
	arg_1_0.used_roaming_waypoints = {}
	arg_1_0.generic_ai_node_units = {}

	local var_1_0 = {
		event_boss = {
			spawners = {},
			level_sections = {}
		},
		event_patrol = {
			spawners = {},
			level_sections = {}
		}
	}

	if not arg_1_2 then
		local var_1_1 = Managers.mechanism:get_current_level_keys()

		arg_1_0._skip_to_map_section = LevelSettings[var_1_1].override_map_start_section and Managers.mechanism:game_mechanism():get_map_start_section()
	end

	arg_1_0.terror_spawners = var_1_0
	arg_1_0.boss_waypoints = {}
	arg_1_0.override_spawners = {}
	arg_1_0.num_override_spawners = 0

	arg_1_0:set_random_seed(nil, arg_1_4)

	if arg_1_3 and not arg_1_2 then
		arg_1_0:_setup_level_data(arg_1_3, arg_1_4)
	end
end

function LevelAnalysis._setup_level_data(arg_2_0, arg_2_1, arg_2_2)
	if LevelResource.nested_level_count(arg_2_1) > 0 then
		arg_2_1 = LevelResource.nested_level_resource_name(arg_2_1, 0)
	end

	local var_2_0 = arg_2_1 .. "_spawn_zones"

	if Application.can_get("lua", var_2_0) then
		arg_2_0._last_loaded_zone_package = var_2_0

		local var_2_1 = MainPathSpawningGenerator.load_spawn_zone_data(var_2_0)

		arg_2_0.spawn_zone_data = var_2_1

		local var_2_2 = var_2_1.crossroads

		arg_2_0.chosen_crossroads = MainPathSpawningGenerator.generate_crossroad_path_choices(var_2_2, arg_2_2)
	else
		ferror("Cant get %s, make sure this is added to the \\resource_packages\\level_scripts.package file. Or have you forgotten to run generate_resource_packages.bat?", var_2_0)
	end
end

function LevelAnalysis.set_random_seed(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0

	if arg_3_1 then
		var_3_0 = arg_3_1.seed
	else
		var_3_0 = arg_3_2 or math.random_seed()
	end

	arg_3_0.starting_seed = var_3_0
	arg_3_0.seed = var_3_0

	print("[LevelAnalysis] set_random_seed( " .. arg_3_0.starting_seed .. ")")
end

function LevelAnalysis.create_checkpoint_data(arg_4_0)
	return {
		seed = arg_4_0.starting_seed
	}
end

function LevelAnalysis._random(arg_5_0, ...)
	local var_5_0, var_5_1 = Math.next_random(arg_5_0.seed, ...)

	arg_5_0.seed = var_5_0

	return var_5_1
end

function LevelAnalysis._random_float_interval(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0, var_6_1 = Math.next_random(arg_6_0.seed)
	local var_6_2 = arg_6_1 + (arg_6_2 - arg_6_1) * var_6_1

	arg_6_0.seed = var_6_0

	return var_6_2
end

function LevelAnalysis.destroy(arg_7_0)
	arg_7_0:reset()

	if arg_7_0.traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(arg_7_0.navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(arg_7_0.nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(arg_7_0.traverse_logic)
	end

	if arg_7_0.astar_list then
		local var_7_0 = arg_7_0.astar_list

		for iter_7_0 = 1, #var_7_0 do
			local var_7_1 = var_7_0[iter_7_0][1]

			GwNavAStar.destroy(var_7_1)
		end
	end

	EngineOptimized.unregister_main_path()
end

function LevelAnalysis.reset(arg_8_0)
	if arg_8_0._last_loaded_zone_package then
		package.loaded[arg_8_0._last_loaded_zone_package] = nil
	end
end

function LevelAnalysis.set_enemy_recycler(arg_9_0, arg_9_1)
	arg_9_0.enemy_recycler = arg_9_1
end

function LevelAnalysis.get_start_and_finish(arg_10_0)
	return arg_10_0.start, arg_10_0.finish
end

function LevelAnalysis.get_path_markers(arg_11_0)
	return arg_11_0.path_markers
end

function LevelAnalysis._add_path_marker_data(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_9, arg_12_10)
	local var_12_0
	local var_12_1 = #arg_12_10 + 1

	if not GwNavTraversal.get_seed_triangle(arg_12_9, arg_12_1) then
		var_12_0 = "outside"

		printf("Path marker with order %s is outside of navigation mesh (%s).", tostring(arg_12_3), tostring(arg_12_1))
	end

	for iter_12_0 = 1, #arg_12_10 do
		if arg_12_3 < arg_12_10[iter_12_0].order then
			var_12_1 = iter_12_0
			var_12_0 = var_12_0 or "good"

			break
		elseif arg_12_3 == arg_12_10[iter_12_0].order then
			var_12_1 = iter_12_0
			var_12_0 = var_12_0 or "duplicate"

			printf("Two path markers in the level has the same order: %s (%s)", tostring(arg_12_3), tostring(arg_12_1))

			break
		end
	end

	var_12_0 = var_12_0 or "good"

	table.insert(arg_12_10, var_12_1, {
		pos = Vector3Box(arg_12_1),
		marker_type = arg_12_2,
		main_path_index = arg_12_4,
		order = arg_12_3,
		kind = var_12_0,
		crossroads = arg_12_5,
		roaming_set = arg_12_6,
		mutators = arg_12_7,
		peak = arg_12_8
	})

	return var_12_0 == "good"
end

function LevelAnalysis._initialize_path_markers_from_editor(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Unit.alive
	local var_13_1 = Unit.is_a
	local var_13_2 = Unit.get_data
	local var_13_3 = Unit.local_position
	local var_13_4 = Script.index_offset()
	local var_13_5 = LevelEditor.objects
	local var_13_6 = arg_13_0.nav_world
	local var_13_7 = true

	for iter_13_0, iter_13_1 in pairs(var_13_5) do
		local var_13_8 = iter_13_1._unit

		if var_13_0(var_13_8) and var_13_1(var_13_8, "units/gamemode/path_marker") then
			local var_13_9 = tonumber(Unit.get_data(var_13_8, "order"))
			local var_13_10 = var_13_2(var_13_8, "marker_type")
			local var_13_11 = var_13_3(var_13_8, var_13_4)
			local var_13_12 = var_13_2(var_13_8, "crossroads")
			local var_13_13 = var_13_2(var_13_8, "roaming_set")
			local var_13_14 = var_13_2(var_13_8, "mutators")
			local var_13_15 = var_13_2(var_13_8, "peak") or nil

			var_13_13 = var_13_13 ~= "" and var_13_13 or nil
			var_13_14 = var_13_14 ~= "" and var_13_14 or nil

			if not arg_13_0:_add_path_marker_data(var_13_11, var_13_10, var_13_9, 1, var_13_12, var_13_13, var_13_14, var_13_15, var_13_6, arg_13_1) then
				var_13_7 = false
			end
		end
	end

	return var_13_7
end

function LevelAnalysis._initialize_path_markers_from_ingame(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = LevelResource.unit_position
	local var_14_1 = LevelResource.unit_data
	local var_14_2 = DynamicData.get
	local var_14_3 = LevelResource.unit_indices(arg_14_2, "units/gamemode/path_marker")
	local var_14_4 = arg_14_0.nav_world
	local var_14_5 = true

	for iter_14_0, iter_14_1 in ipairs(var_14_3) do
		local var_14_6 = var_14_0(arg_14_2, iter_14_1)
		local var_14_7 = var_14_1(arg_14_2, iter_14_1)
		local var_14_8 = tonumber(var_14_2(var_14_7, "order"))
		local var_14_9 = var_14_2(var_14_7, "marker_type")
		local var_14_10 = var_14_2(var_14_7, "crossroads")
		local var_14_11 = var_14_2(var_14_7, "roaming_set")
		local var_14_12 = var_14_2(var_14_7, "mutators")
		local var_14_13 = var_14_2(var_14_7, "peak") or nil

		var_14_12 = var_14_12 ~= "" and var_14_12 or nil
		var_14_11 = var_14_11 ~= "" and var_14_11 or nil

		if not arg_14_0:_add_path_marker_data(var_14_6, var_14_9, var_14_8, 1, var_14_10, var_14_11, var_14_12, var_14_13, var_14_4, arg_14_1) then
			var_14_5 = false
		end
	end

	return var_14_5
end

function LevelAnalysis.generate_main_path(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if not arg_15_2 then
		arg_15_2 = {}

		if not arg_15_1 then
			local var_15_0 = Managers.state.game_mode:level_key()

			arg_15_1 = LevelSettings[var_15_0].level_name
		end

		if arg_15_5 and LevelResource.nested_level_count(arg_15_1) > 0 then
			arg_15_1 = LevelResource.nested_level_resource_name(arg_15_1, 0)
		end

		print("[LevelAnalysis] Generating main-path for level:", arg_15_1)

		if arg_15_3 then
			if not arg_15_0:_initialize_path_markers_from_editor(arg_15_2, arg_15_4) then
				return "[LevelAnalysis] Failed to initialize all path markers from editor (see Console for conflicting markers)."
			end
		elseif not arg_15_0:_initialize_path_markers_from_ingame(arg_15_2, arg_15_1) then
			print("[LevelAnalysis] Failed to initialize all path markers from ingame.")
		end
	else
		print("[LevelAnalysis] path markers aready generated")
	end

	if #arg_15_2 < 2 then
		return "Missing path markers in level. Need at least 2."
	end

	table.sort(arg_15_2, function(arg_16_0, arg_16_1)
		return arg_16_0.order < arg_16_1.order
	end)
	print("[LevelAnalysis] Path-markers:")

	local var_15_1 = 1
	local var_15_2 = 0
	local var_15_3 = {}
	local var_15_4 = 0

	for iter_15_0 = 1, #arg_15_2 do
		local var_15_5 = arg_15_2[iter_15_0]

		printf("\tread path_marker (crossroad: %s)", var_15_5.crossroads)

		if var_15_5.crossroads and var_15_5.crossroads ~= "" then
			local var_15_6 = string.split_deprecated(var_15_5.crossroads, ":")
			local var_15_7 = var_15_6[1]
			local var_15_8 = tonumber(var_15_6[2])

			fassert(var_15_8, "bad road_id")

			var_15_5.crossroads_id = var_15_7
			var_15_5.road_id = var_15_8

			local var_15_9 = var_15_3[var_15_7]

			if not var_15_9 then
				var_15_9 = {
					num_roads = 0,
					main_path_index = var_15_1,
					roads = {}
				}
				var_15_3[var_15_7] = var_15_9
				var_15_2 = var_15_2 + 1
			end

			var_15_9.roads[var_15_8] = (var_15_9.roads[var_15_8] or 0) + 1
			var_15_9.num_roads = var_15_9.num_roads + 1
		end

		var_15_5.main_path_index = var_15_1

		if var_15_5.marker_type == "break" or var_15_5.marker_type == "crossroad_break" then
			var_15_1 = var_15_1 + 1
			var_15_4 = var_15_4 + 1

			if var_15_4 < 2 then
				return "If using breaks in main-path, then each sub-path needs at least 2 path markers. Check path marker with order -> " .. tostring(var_15_5.order)
			end

			var_15_4 = 0
		else
			var_15_4 = var_15_4 + 1
		end

		printf("\t\tmarker: %d,\torder: %d,\tmain_path_index: %d,\tcrossroads: %s %s", iter_15_0, var_15_5.order, var_15_5.main_path_index, var_15_5.crossroads_id, var_15_5.road_id)
	end

	if var_15_4 < 2 then
		return "If using breaks in main-path, then each sub-path needs at least 2 path markers. Last path marker is lonely!"
	end

	arg_15_0.crossroads = var_15_3
	arg_15_0.num_crossroads = var_15_2
	arg_15_0.path_markers = arg_15_2
	arg_15_0.start = arg_15_2[1].pos
	arg_15_0.finish = arg_15_2[#arg_15_2].pos

	arg_15_0:start_main_path_generation(var_15_1)

	return "success", arg_15_2
end

function LevelAnalysis.start_main_path_generation(arg_17_0, arg_17_1)
	print("[LevelAnalysis] start_main_path_generation")

	arg_17_0.stitching_path = true

	local var_17_0 = arg_17_0.nav_world
	local var_17_1 = arg_17_0.path_markers

	arg_17_0.astar_list = {}
	arg_17_0.main_paths = {}

	local var_17_2 = {
		bot_ladders = 20,
		ledges_with_fence = 20,
		jumps = 20,
		ledges = 20,
		bot_jumps = 20,
		bot_drops = 20
	}
	local var_17_3 = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(var_17_3)

	arg_17_0.nav_cost_map_cost_table = var_17_3

	local var_17_4 = GwNavTraverseLogic.create(var_17_0, var_17_3)

	arg_17_0.traverse_logic = var_17_4
	arg_17_0.navtag_layer_cost_table = GwNavTagLayerCostTable.create()

	arg_17_0:initialize_cost_table(arg_17_0.navtag_layer_cost_table, var_17_2)
	GwNavTraverseLogic.set_navtag_layer_cost_table(var_17_4, arg_17_0.navtag_layer_cost_table)

	local var_17_5 = 1
	local var_17_6 = 1

	for iter_17_0 = 1, #var_17_1 - 1 do
		local var_17_7 = var_17_1[iter_17_0].pos:unbox()
		local var_17_8 = var_17_1[iter_17_0 + 1].pos:unbox()

		if var_17_1[iter_17_0].marker_type == "break" or var_17_1[iter_17_0].marker_type == "crossroad_break" then
			var_17_6 = 1
		else
			arg_17_0.astar_list[var_17_5] = {
				GwNavAStar.create(),
				var_17_6,
				var_17_1[iter_17_0].main_path_index,
				iter_17_0
			}

			GwNavAStar.start(arg_17_0.astar_list[var_17_5][1], var_17_0, var_17_7, var_17_8, var_17_4)

			var_17_5 = var_17_5 + 1
			var_17_6 = var_17_6 + 1
		end
	end

	for iter_17_1 = 1, arg_17_1 do
		arg_17_0.main_paths[iter_17_1] = {
			path_length = 0,
			nodes = {},
			astar_paths = {},
			path_markers = {}
		}
	end

	printf("[LevelAnalysis] main path generation - found %d main paths, total of %d sub-paths.", arg_17_1, #arg_17_0.astar_list)
end

function LevelAnalysis.initialize_cost_table(arg_18_0, arg_18_1, arg_18_2)
	for iter_18_0, iter_18_1 in ipairs(LAYER_ID_MAPPING) do
		local var_18_0 = arg_18_2[iter_18_1]

		if var_18_0 then
			if var_18_0 == 0 then
				GwNavTagLayerCostTable.forbid_layer(arg_18_1, iter_18_0)
			else
				GwNavTagLayerCostTable.allow_layer(arg_18_1, iter_18_0)
				GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_18_1, iter_18_0, var_18_0)
			end
		end
	end
end

function LevelAnalysis.boxify_pos_array(arg_19_0)
	for iter_19_0 = 1, #arg_19_0 do
		arg_19_0[iter_19_0] = Vector3Box(arg_19_0[iter_19_0])
	end
end

function LevelAnalysis.boxify_table_pos_array(arg_20_0)
	local var_20_0 = {}

	for iter_20_0 = 1, #arg_20_0 do
		local var_20_1 = arg_20_0[iter_20_0]

		var_20_0[iter_20_0] = Vector3Box(var_20_1[1], var_20_1[2], var_20_1[3])
	end

	return var_20_0
end

function LevelAnalysis.update_main_path_generation(arg_21_0)
	local var_21_0 = GwNavAStar.processing_finished
	local var_21_1 = GwNavAStar.path_found
	local var_21_2 = GwNavAStar.node_count
	local var_21_3 = GwNavAStar.node_at_index
	local var_21_4 = GwNavAStar.path_cost
	local var_21_5 = GwNavAStar.path_distance
	local var_21_6 = GwNavAStar.destroy
	local var_21_7 = arg_21_0.astar_list
	local var_21_8 = #var_21_7
	local var_21_9 = arg_21_0.main_paths
	local var_21_10 = 1

	while var_21_10 <= var_21_8 do
		local var_21_11 = var_21_7[var_21_10][1]

		if var_21_0(var_21_11) then
			if var_21_1(var_21_11) then
				local var_21_12 = var_21_2(var_21_11)

				print("[LevelAnalysis] Found path! node-count:", var_21_12)

				local var_21_13 = {}

				for iter_21_0 = 1, var_21_12 do
					var_21_13[iter_21_0] = var_21_3(var_21_11, iter_21_0)
				end

				LevelAnalysis.boxify_pos_array(var_21_13)

				local var_21_14 = var_21_4(var_21_11)
				local var_21_15 = var_21_5(var_21_11)
				local var_21_16 = var_21_7[var_21_10][3]
				local var_21_17 = var_21_9[var_21_16]
				local var_21_18 = var_21_7[var_21_10][2]
				local var_21_19 = var_21_7[var_21_10][4]

				var_21_17.astar_paths[var_21_18] = {
					var_21_15,
					var_21_14,
					var_21_13,
					var_21_16,
					var_21_19
				}

				var_21_6(var_21_11)

				var_21_7[var_21_10] = var_21_7[var_21_8]
				var_21_7[var_21_8] = nil
				var_21_8 = var_21_8 - 1

				if var_21_8 == 0 then
					print("[LevelAnalysis] main path generation - all sub paths generated")

					local var_21_20 = 0

					for iter_21_1 = 1, #var_21_9 do
						local var_21_21 = var_21_9[iter_21_1]
						local var_21_22 = var_21_21.astar_paths
						local var_21_23 = var_21_21.nodes

						for iter_21_2 = 1, #var_21_22 do
							local var_21_24 = var_21_22[iter_21_2]
							local var_21_25 = var_21_24[1]
							local var_21_26 = var_21_24[3]
							local var_21_27 = #var_21_23 + 1
							local var_21_28 = var_21_27

							for iter_21_3 = 1, #var_21_26 - 1 do
								var_21_23[var_21_27] = var_21_26[iter_21_3]
								var_21_27 = var_21_27 + 1
							end

							var_21_21.path_length = var_21_21.path_length + var_21_25

							local var_21_29 = var_21_24[5]
							local var_21_30 = arg_21_0.path_markers[var_21_29]

							var_21_21.path_markers[var_21_28] = var_21_30

							local var_21_31 = var_21_30.crossroads_id

							if var_21_31 then
								fassert(not var_21_21.crossroads_id or var_21_21.crossroads_id == var_21_31, "If using crossroads, all path-markers in the same main-path must be have the same crossroads id")

								var_21_21.crossroads_id = var_21_31
								var_21_21.road_id = var_21_30.road_id
							end
						end

						var_21_21.dist_from_start = var_21_20
						var_21_20 = var_21_20 + var_21_21.path_length

						local var_21_32 = var_21_22[#var_21_22][3]

						var_21_23[#var_21_23 + 1] = var_21_32[#var_21_32]
					end

					arg_21_0.total_main_path_length = var_21_20

					MainPathSpawningGenerator.inject_travel_dists(var_21_9)

					arg_21_0.stitching_path = false
					arg_21_0.boss_event_list = {}

					if CurrentBossSettings and not CurrentBossSettings.disabled and not arg_21_0.using_editor then
						arg_21_0:generate_boss_paths()
					end

					return "done"
				end
			else
				local var_21_33 = var_21_7[var_21_10][4]
				local var_21_34 = arg_21_0.path_markers[var_21_33].order
				local var_21_35 = string.format("[LevelAnalysis] Level fail: No path found between path-markers with order %s and the next. Cannot create main path. No bosses will spawn.", tostring(var_21_34))

				if Debug then
					Debug.sticky_text(var_21_35, "delay", 20)
				end

				print(var_21_35)

				arg_21_0.stitching_path = false

				return "fail", var_21_35
			end
		else
			var_21_10 = var_21_10 + 1
		end
	end
end

function LevelAnalysis.calc_dists_to_start(arg_22_0)
	local var_22_0 = arg_22_0.main_paths
	local var_22_1 = 0

	for iter_22_0 = 1, #var_22_0 do
		local var_22_2 = var_22_0[iter_22_0]

		var_22_2.dist_from_start = var_22_1
		var_22_1 = var_22_1 + var_22_2.path_length
	end

	return var_22_1
end

function LevelAnalysis.boss_gizmo_spawned(arg_23_0, arg_23_1)
	local var_23_0 = Unit.get_data(arg_23_1, "travel_dist")
	local var_23_1 = tonumber(Unit.get_data(arg_23_1, "map_section"))

	if arg_23_0._skip_to_map_section and var_23_1 < arg_23_0._skip_to_map_section then
		return
	end

	local var_23_2 = arg_23_0.override_spawners
	local var_23_3 = Unit.get_data(arg_23_1, "event_encampment")

	if var_23_3 and var_23_3 > 0 then
		local var_23_4 = var_23_2[var_23_1]

		if not var_23_4 then
			var_23_4 = {}
			var_23_2[var_23_1] = var_23_4
		end

		if EncampmentTemplates[var_23_3] then
			var_23_4[#var_23_4 + 1] = {
				arg_23_1,
				var_23_0,
				var_23_1,
				var_23_3
			}
			arg_23_0.num_override_spawners = arg_23_0.num_override_spawners + 1
		end
	end

	local var_23_5 = arg_23_0.terror_spawners

	for iter_23_0, iter_23_1 in pairs(var_23_5) do
		if Unit.get_data(arg_23_1, iter_23_0) then
			local var_23_6 = iter_23_1.spawners

			var_23_6[#var_23_6 + 1] = {
				arg_23_1,
				var_23_0,
				var_23_1
			}
		end
	end
end

function LevelAnalysis.generic_ai_node_spawned(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.generic_ai_node_units
	local var_24_1 = Unit.get_data(arg_24_1, "id")
	local var_24_2 = var_24_0[var_24_1]

	if not var_24_2 then
		var_24_2 = {}
		var_24_0[var_24_1] = var_24_2
	end

	var_24_2[#var_24_2 + 1] = arg_24_1
end

function LevelAnalysis.group_spawners(arg_25_0, arg_25_1, arg_25_2)
	table.sort(arg_25_1, function(arg_26_0, arg_26_1)
		return arg_26_0[3] < arg_26_1[3]
	end)

	local var_25_0 = 0
	local var_25_1 = {}

	for iter_25_0 = 1, #arg_25_1 do
		local var_25_2 = arg_25_1[iter_25_0]
		local var_25_3 = var_25_2[1]
		local var_25_4 = var_25_2[2]
		local var_25_5 = var_25_2[3]
		local var_25_6 = var_25_2[4]

		if var_25_5 ~= var_25_0 then
			if var_25_0 < var_25_5 then
				arg_25_2[var_25_5] = iter_25_0
			elseif var_25_5 < var_25_0 then
				-- block empty
			end
		end

		var_25_0 = var_25_5
	end

	arg_25_2[var_25_0 + 1] = #arg_25_1 + 1

	local var_25_7 = var_25_0

	for iter_25_1 = 1, var_25_7 do
		if not arg_25_2[iter_25_1] then
			for iter_25_2 = iter_25_1 + 1, var_25_7 do
				local var_25_8 = arg_25_2[iter_25_2]

				if var_25_8 and not arg_25_2[iter_25_1] then
					arg_25_2[iter_25_1] = var_25_8
				end
			end

			for iter_25_3 = iter_25_1 - 1, 1, -1 do
				local var_25_9 = arg_25_2[iter_25_3]

				if var_25_9 and not arg_25_2[iter_25_1] then
					arg_25_2[iter_25_1] = var_25_9
				end
			end
		end
	end

	for iter_25_4 = 1, var_25_7 do
		local var_25_10 = arg_25_2[iter_25_4]

		if not var_25_10 then
			table.dump(arg_25_2, "LEVEL_SECTIONS ERROR-----------------------", 3)
			error()
		end

		local var_25_11 = arg_25_1[var_25_10][1]
		local var_25_12 = Unit.local_position(var_25_11, 0)
		local var_25_13, var_25_14, var_25_15, var_25_16, var_25_17 = MainPathUtils.closest_pos_at_main_path(nil, var_25_12)
		local var_25_18, var_25_19, var_25_20 = Managers.state.conflict.spawn_zone_baker:get_zone_segment_from_travel_dist(var_25_14)

		var_25_1[iter_25_4] = var_25_20.conflict_setting
	end

	return var_25_7, var_25_1
end

function LevelAnalysis.boxify_waypoint_table(arg_27_0, arg_27_1)
	local var_27_0 = {}

	for iter_27_0 = 1, #arg_27_1 do
		local var_27_1 = arg_27_1[iter_27_0]

		var_27_0[iter_27_0] = Vector3Box(var_27_1[1], var_27_1[2], var_27_1[3])
	end

	return var_27_0
end

function LevelAnalysis.print_boss_waypoints(arg_28_0)
	local var_28_0 = arg_28_0.boss_waypoints

	for iter_28_0 = 1, #var_28_0 do
		local var_28_1 = var_28_0[iter_28_0]

		print("Section:", iter_28_0)

		for iter_28_1 = 1, #var_28_1 do
			local var_28_2 = var_28_1[iter_28_1]

			print(string.format("BossWaypoint section: %q, #wp %q travel-dist: %.1f", iter_28_0, iter_28_1, var_28_2.travel_dist))
		end
	end
end

function LevelAnalysis.get_boss_spline_travel_distance(arg_29_0, arg_29_1)
	local var_29_0

	if arg_29_1.main_path_connector then
		local var_29_1 = arg_29_1.main_path_connector
		local var_29_2 = Vector3(var_29_1[1], var_29_1[2], var_29_1[3])
		local var_29_3, var_29_4 = MainPathUtils.closest_pos_at_main_path(nil, var_29_2)

		var_29_0 = var_29_4

		print("MAIN PATH CONNECTOR ", var_29_0)
	else
		local var_29_5 = arg_29_1.waypoints[1]
		local var_29_6 = Vector3(var_29_5[1], var_29_5[2], var_29_5[3])
		local var_29_7, var_29_8 = MainPathUtils.closest_pos_at_main_path(nil, var_29_6)

		var_29_0 = var_29_8

		print("NORMAL PATROL MAIN PATH ", var_29_0)
	end

	table.dump(arg_29_1)

	return var_29_0
end

function LevelAnalysis.get_possible_events(arg_30_0)
	local var_30_0 = {}
	local var_30_1 = arg_30_0.boss_waypoints

	for iter_30_0, iter_30_1 in ipairs(var_30_1) do
		for iter_30_2, iter_30_3 in ipairs(iter_30_1) do
			local var_30_2 = arg_30_0:get_boss_spline_travel_distance(iter_30_3)

			var_30_0[#var_30_0 + 1] = {
				kind = "event_patrol",
				travel_dist = var_30_2,
				waypoints_table = iter_30_3
			}
		end
	end

	local var_30_3 = arg_30_0.terror_spawners.event_boss.spawners

	for iter_30_4, iter_30_5 in ipairs(var_30_3) do
		local var_30_4 = Unit.local_position(iter_30_5[1], 0)
		local var_30_5, var_30_6, var_30_7, var_30_8, var_30_9 = MainPathUtils.closest_pos_at_main_path(nil, var_30_4)

		var_30_0[#var_30_0 + 1] = {
			kind = "event_boss",
			travel_dist = var_30_6,
			spawner = iter_30_5
		}
	end

	table.sort(var_30_0, function(arg_31_0, arg_31_1)
		return arg_31_0.travel_dist < arg_31_1.travel_dist
	end)

	return var_30_0
end

function LevelAnalysis.pick_boss_spline(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_0.boss_waypoints

	if not var_32_0 then
		return false, "no boss waypoints table, you need to regenerate boss waypoints in editor!"
	end

	local var_32_1 = var_32_0[arg_32_1]

	if not var_32_1 then
		return false, string.format("no section waypoints for section %d - You need to add boss waypoints or set boss_spawning_method to nil in level_settings. Or set boss_events = { max_events_of_this_kind = { event_patrol = 0 }, } in level settings.", arg_32_1)
	end

	local var_32_2 = var_32_1[1].travel_dist
	local var_32_3 = arg_32_3 + arg_32_2

	var_32_3 = var_32_2 < var_32_3 and var_32_3 or var_32_2

	local var_32_4

	for iter_32_0 = 1, #var_32_1 do
		if var_32_3 <= var_32_1[iter_32_0].travel_dist then
			var_32_4 = iter_32_0

			break
		end
	end

	local var_32_5

	if not var_32_4 then
		printf("[LevelAnalysis] waypoint is too close to the last section's waypoint (map section=%d) -> using fallback (last waypoint in section)", arg_32_1)

		var_32_4 = #var_32_1
	end

	local var_32_6 = var_32_1[arg_32_0:_random(var_32_4, #var_32_1)]
	local var_32_7 = arg_32_0:boxify_waypoint_table(var_32_6.waypoints)
	local var_32_8 = {
		spline_type = "patrol",
		event_kind = "event_spline_patrol",
		spline_id = var_32_6.id,
		spline_way_points = var_32_7,
		one_directional = var_32_6.one_directional
	}
	local var_32_9 = arg_32_0:get_boss_spline_travel_distance(var_32_6)

	return true, var_32_5, var_32_7[1], var_32_8, var_32_9
end

function LevelAnalysis.spawn_all_boss_spline_patrols(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.boss_waypoints

	if not var_33_0 then
		print("No boss_waypoints found in level!")

		return false
	end

	print("SPAWN BOSS SPLINES")

	for iter_33_0 = 1, #var_33_0 do
		local var_33_1 = var_33_0[iter_33_0]

		for iter_33_1 = 1, #var_33_1 do
			local var_33_2 = var_33_1[iter_33_1]

			if not arg_33_1 or var_33_2.id == arg_33_1 then
				local var_33_3 = arg_33_0:boxify_waypoint_table(var_33_2.waypoints)
				local var_33_4 = {
					spline_type = "patrol",
					event_kind = "event_spline_patrol",
					spline_id = var_33_2.id,
					spline_way_points = var_33_3
				}

				arg_33_0.enemy_recycler:add_main_path_terror_event(var_33_3[1], "boss_event_spline_patrol", 45, var_33_4)
				print("INJECTING BOSS SPLINE ID", var_33_2.id)

				local var_33_5 = var_33_3[1]:unbox()
				local var_33_6, var_33_7, var_33_8, var_33_9, var_33_10 = MainPathUtils.closest_pos_at_main_path(nil, var_33_5)
				local var_33_11, var_33_12 = MainPathUtils.point_on_mainpath(nil, var_33_7 - 45)

				QuickDrawerStay:line(var_33_5, var_33_5 + Vector3(0, 0, 15), Color(125, 255, 0))
				QuickDrawerStay:sphere(var_33_5, 5, Colors.get("purple"))
				QuickDrawerStay:line(var_33_5, var_33_11, Color(125, 255, 0))
				QuickDrawerStay:sphere(var_33_11, 5, Colors.get("pink"))
			end
		end
	end
end

function LevelAnalysis.inject_all_bosses_into_main_path(arg_34_0)
	if not arg_34_0.boss_waypoints then
		return false
	end

	print("SPAWN BOSS SPLINES")

	local var_34_0 = "event_boss"
	local var_34_1 = arg_34_0.terror_spawners[var_34_0].spawners

	table.clear(arg_34_0.enemy_recycler.main_path_events)

	for iter_34_0 = 1, #var_34_1 do
		local var_34_2 = var_34_1[iter_34_0]
		local var_34_3 = Unit.local_position(var_34_2[1], 0)
		local var_34_4 = Vector3Box(var_34_3)
		local var_34_5 = {
			event_kind = "event_boss"
		}

		arg_34_0.enemy_recycler:add_main_path_terror_event(var_34_4, "boss_event_rat_ogre", 45, var_34_5)

		local var_34_6, var_34_7, var_34_8, var_34_9, var_34_10 = MainPathUtils.closest_pos_at_main_path(nil, var_34_4:unbox())
		local var_34_11, var_34_12 = MainPathUtils.point_on_mainpath(nil, var_34_7 - 45)

		QuickDrawerStay:line(var_34_3, var_34_3 + Vector3(0, 0, 15), Color(125, 255, 0))
		QuickDrawerStay:sphere(var_34_3, 5, Colors.get("purple"))
		QuickDrawerStay:line(var_34_3, var_34_11, Color(125, 255, 0))
		QuickDrawerStay:sphere(var_34_11, 5, Colors.get("pink"))
	end

	arg_34_0.enemy_recycler.current_main_path_event_id = 1

	local var_34_13 = arg_34_0.enemy_recycler.main_path_events[1][1]

	arg_34_0.enemy_recycler.current_main_path_event_activation_dist = var_34_13
end

function LevelAnalysis.inject_playable_boss_into_main_path(arg_35_0)
	if not arg_35_0.boss_waypoints then
		return false
	end

	print("SPAWN BOSS SPLINES")

	local var_35_0 = "event_boss"
	local var_35_1 = arg_35_0.terror_spawners[var_35_0].spawners

	table.clear(arg_35_0.enemy_recycler.main_path_events)

	for iter_35_0 = 1, #var_35_1 do
		local var_35_2 = var_35_1[iter_35_0]
		local var_35_3 = Unit.local_position(var_35_2[1], 0)
		local var_35_4 = Vector3Box(var_35_3)
		local var_35_5 = {
			event_kind = "event_boss"
		}

		arg_35_0.enemy_recycler:add_main_path_terror_event(var_35_4, "playable_boss_rat_ogre", 45, var_35_5)

		local var_35_6, var_35_7, var_35_8, var_35_9, var_35_10 = MainPathUtils.closest_pos_at_main_path(nil, var_35_4:unbox())
		local var_35_11, var_35_12 = MainPathUtils.point_on_mainpath(nil, var_35_7 - 45)

		QuickDrawerStay:line(var_35_3, var_35_3 + Vector3(0, 0, 15), Color(125, 255, 0))
		QuickDrawerStay:sphere(var_35_3, 5, Colors.get("purple"))
		QuickDrawerStay:line(var_35_3, var_35_11, Color(125, 255, 0))
		QuickDrawerStay:sphere(var_35_11, 5, Colors.get("pink"))
	end

	arg_35_0.enemy_recycler.current_main_path_event_id = 1

	local var_35_13 = arg_35_0.enemy_recycler.main_path_events[1][1]

	arg_35_0.enemy_recycler.current_main_path_event_activation_dist = var_35_13
end

function LevelAnalysis._give_events(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	local var_36_0 = 0
	local var_36_1 = 10
	local var_36_2
	local var_36_3

	for iter_36_0 = arg_36_0._skip_to_map_section or 1, #arg_36_5 do
		local var_36_4
		local var_36_5
		local var_36_6
		local var_36_7 = arg_36_3[iter_36_0]
		local var_36_8
		local var_36_9
		local var_36_10 = arg_36_5[iter_36_0].boss[arg_36_6]

		if var_36_7 == "event_boss" or var_36_7 == "event_patrol" then
			local var_36_11 = var_36_10.event_lookup[var_36_7]

			var_36_8 = var_36_11[arg_36_0:_random(#var_36_11)]

			local var_36_12
			local var_36_13
			local var_36_14

			if var_36_7 == "event_patrol" then
				local var_36_15, var_36_16, var_36_17

				var_36_15, var_36_16, var_36_4, var_36_6, var_36_17 = arg_36_0:pick_boss_spline(iter_36_0, var_36_1, var_36_0)

				fassert(var_36_15, "[LevelAnalysis] Failed finding patrol spline! [reason=%s]", var_36_16)
				print(" ----> using boss spline path!")

				var_36_0 = var_36_17
				var_36_9 = var_36_17
			else
				local var_36_18 = Managers.mechanism:mechanism_setting_for_title("playable_boss_terror_events")

				if var_36_18 then
					local var_36_19 = FrameTable.alloc_table()

					for iter_36_1, iter_36_2 in pairs(var_36_18) do
						if PlayerUtils.get_career_override(iter_36_1) then
							table.append(var_36_19, iter_36_2)
						end
					end

					if not table.is_empty(var_36_19) then
						var_36_8 = table.random(var_36_19)
					end
				end

				print(" ----> using boss gizmo!")

				local var_36_20 = arg_36_2[var_36_7]
				local var_36_21 = var_36_20.level_sections
				local var_36_22 = var_36_20.spawners
				local var_36_23 = var_36_21[iter_36_0]
				local var_36_24 = var_36_21[iter_36_0 + 1] - 1

				fassert(var_36_23 <= var_36_24, "Level Error: Too few boss-gizmo spawners of type '%s' in section %d: start-index: %d, end-index: %d,", var_36_7, iter_36_0, tostring(var_36_23), tostring(var_36_24))

				local var_36_25 = var_36_22[var_36_23][2]
				local var_36_26 = var_36_22[var_36_24][2]
				local var_36_27 = var_36_1 - (var_36_25 - var_36_0)

				print(string.format("[LevelAnalysis] section: %d, start-index: %d, end-index: %d, forbidden-dist: %.1f start-travel-dist: %.1f, end-travel-dist: %.1f spawn_distance %.1f", iter_36_0, var_36_23, var_36_24, var_36_27, var_36_25, var_36_26, var_36_0))

				if var_36_27 > 0 then
					local var_36_28 = var_36_25 + var_36_27
					local var_36_29

					for iter_36_3 = var_36_23, var_36_24 do
						local var_36_30 = var_36_22[iter_36_3][2]

						if var_36_28 <= var_36_30 then
							var_36_29 = iter_36_3

							break
						else
							print("[LevelAnalysis] \t\t--> since forbidden dist, skipping spawner ", iter_36_3, " at distance,", var_36_30)
						end
					end

					if var_36_29 then
						print("[LevelAnalysis] \t\t--> found new spawner ", var_36_29, " at distance,", var_36_22[var_36_29][2], " passing forbidden dist:", var_36_28)

						var_36_23 = var_36_29
					else
						print(string.format("[LevelAnalysis] failed to find spawner - too few spawners in section %d, forbidden-dist %.1f from: %.1f to: %.1f", iter_36_0, var_36_27, var_36_28, var_36_26))
						print("[LevelAnalysis] \t\t--> fallback -> using main-path spawning for section", iter_36_0, var_36_28, var_36_26)

						local var_36_31 = arg_36_0:_random_float_interval(var_36_28, var_36_26)
						local var_36_32 = MainPathUtils.point_on_mainpath(arg_36_1, var_36_31)

						if var_36_32 then
							var_36_0 = var_36_31
							var_36_4 = Vector3Box(var_36_32)
							var_36_6 = {
								event_kind = var_36_7
							}
						else
							print("[LevelAnalysis] \t\t--> fallback 2 -> pick any spawner in segment (MIGHT GET BOSSES VERY CLOSE TO EACHOTHER)", iter_36_0)

							var_36_23 = var_36_21[iter_36_0]
						end
					end
				end

				if not var_36_4 then
					local var_36_33 = var_36_22[arg_36_0:_random(var_36_23, var_36_24)]
					local var_36_34 = Unit.local_position(var_36_33[1], 0)

					var_36_4 = Vector3Box(var_36_34)

					local var_36_35 = var_36_33[1]

					var_36_0 = var_36_33[2]
					var_36_6 = {
						gizmo_unit = var_36_35,
						event_kind = var_36_7
					}
				end
			end
		elseif var_36_7 == "encampment" then
			var_36_8 = "boss_event_encampment"

			print("pick section:", iter_36_0)

			local var_36_36 = arg_36_0.override_spawners[iter_36_0]
			local var_36_37 = var_36_36[arg_36_0:_random(1, #var_36_36)]
			local var_36_38 = var_36_37[1]
			local var_36_39 = var_36_37[4]
			local var_36_40 = EncampmentTemplates[var_36_39]

			var_36_4 = Vector3Box(Unit.local_position(var_36_38, 0))
			var_36_0 = var_36_37[2]

			local var_36_41 = arg_36_0:_random(1, #var_36_40.unit_compositions)

			var_36_6 = {
				encampment_id = var_36_39,
				unit_compositions_id = var_36_41,
				gizmo_unit = var_36_38,
				event_kind = var_36_7
			}
		else
			var_36_8 = "nothing"

			local var_36_42 = arg_36_2.event_boss
			local var_36_43 = var_36_42.level_sections
			local var_36_44 = var_36_42.spawners
			local var_36_45 = var_36_43[iter_36_0]
			local var_36_46 = var_36_43[iter_36_0 + 1] - 1
			local var_36_47 = math.floor((var_36_45 + var_36_46) / 2)
			local var_36_48 = var_36_44[math.clamp(var_36_47, var_36_45, var_36_43[iter_36_0 + 1])]

			var_36_4 = Vector3Box(Unit.local_position(var_36_48[1], 0))

			local var_36_49 = var_36_48[1]

			var_36_0 = var_36_48[2]
		end

		if var_36_7 ~= "nothing" then
			if var_36_10.terror_events_using_packs then
				arg_36_0.enemy_recycler:add_terror_event_in_area(var_36_4, var_36_8, var_36_6)
			else
				local var_36_50 = var_36_7 == "event_boss" and Managers.mechanism:mechanism_setting_for_title("override_boss_activation_distance") or 45
				local var_36_51

				if var_36_9 then
					var_36_51 = var_36_9 - var_36_50
				end

				arg_36_0.enemy_recycler:add_main_path_terror_event(var_36_4, var_36_8, var_36_50, var_36_6, var_36_51)
			end
		end

		local var_36_52 = var_36_10 and var_36_10.debug_color or "deep_pink"

		arg_36_4[#arg_36_4 + 1] = {
			var_36_4,
			var_36_8,
			var_36_0,
			var_36_52
		}
	end
end

function LevelAnalysis._override_generated_event_list(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = arg_37_0.override_spawners

	if arg_37_0.num_override_spawners <= 0 then
		return
	end

	local var_37_1 = {}

	for iter_37_0 = 1, #arg_37_2 do
		local var_37_2 = arg_37_2[iter_37_0].boss[arg_37_3].chance_of_encampment

		if var_37_0[iter_37_0] and var_37_2 > arg_37_0:_random() then
			var_37_1[#var_37_1 + 1] = iter_37_0
		end
	end

	if #var_37_1 <= 0 then
		return
	end

	local var_37_3 = var_37_1[arg_37_0:_random(1, #var_37_1)]

	print("[LevelAnalysis] Overriding section ", var_37_3, " with an encampment")

	arg_37_1[var_37_3] = "encampment"
end

function LevelAnalysis._generate_event_name_list(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	print("[LevelAnalysis] Terror events added:")

	local var_38_0 = {}
	local var_38_1 = {}
	local var_38_2 = -1

	for iter_38_0 = 1, #arg_38_1 do
		local var_38_3 = arg_38_1[iter_38_0].boss

		if var_38_3.disabled then
			var_38_0[iter_38_0] = "nothing"
		else
			local var_38_4 = var_38_3[arg_38_3].events
			local var_38_5 = #var_38_4
			local var_38_6 = arg_38_0:_random(1, var_38_5)

			while var_38_6 == var_38_2 and var_38_5 >= 2 do
				var_38_6 = arg_38_0:_random(1, var_38_5)
			end

			local var_38_7 = var_38_4[var_38_6]
			local var_38_8 = var_38_1[var_38_7]

			if var_38_8 then
				var_38_8 = var_38_8 + 1
			else
				var_38_8 = 1
			end

			var_38_1[var_38_7] = var_38_8

			if arg_38_2 then
				local var_38_9 = arg_38_2[var_38_7]

				if var_38_9 and var_38_9 < var_38_8 then
					var_38_7 = "nothing"
				end
			end

			var_38_0[iter_38_0] = var_38_7

			if var_38_7 == var_38_4[var_38_6] then
				printf("[LevelAnalysis] %d -->Added boss/special event: %s", iter_38_0, var_38_7)
			else
				printf("[LevelAnalysis] %d\t-->Added boss/special event: %s (, %s -> removed due to too many.)", iter_38_0, var_38_7, var_38_4[var_38_6])
			end

			var_38_2 = var_38_6
		end
	end

	return var_38_0
end

function LevelAnalysis._hand_placed_terror_creation(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0
	local var_39_1
	local var_39_2 = arg_39_0.terror_spawners
	local var_39_3
	local var_39_4

	for iter_39_0, iter_39_1 in pairs(var_39_2) do
		print("[LevelAnalysis] grouping spawners for ", iter_39_0)

		local var_39_5

		var_39_5, var_39_1 = arg_39_0:group_spawners(iter_39_1.spawners, iter_39_1.level_sections)

		if var_39_3 and var_39_5 ~= var_39_3 then
			error("Not all sectors has boss event gizmos in level for  " .. (var_39_5 < var_39_3 and iter_39_0 or var_39_4))
		end

		var_39_3 = var_39_5
		var_39_4 = iter_39_0

		print("[LevelAnalysis] ")
	end

	local var_39_6 = arg_39_0.level_settings[arg_39_3]
	local var_39_7 = var_39_6 and var_39_6.max_events_of_this_kind or {
		event_boss = 2
	}
	local var_39_8 = arg_39_0:_generate_event_name_list(var_39_1, var_39_7, arg_39_3)

	arg_39_0:_override_generated_event_list(var_39_8, var_39_1, arg_39_3)

	local var_39_9 = Managers.mechanism:mechanism_setting_for_title("always_spawn_a_boss")
	local var_39_10 = Managers.mechanism:mechanism_setting_for_title("num_bosses_to_spawn")
	local var_39_11 = Managers.mechanism:mechanism_setting_for_title("spawn_boss_every_section")

	if var_39_9 or var_39_10 then
		var_39_8 = arg_39_0:_add_boss_to_generated_list(var_39_8, var_39_10)
	end

	if var_39_11 then
		for iter_39_2, iter_39_3 in ipairs(var_39_8) do
			var_39_8[iter_39_2] = "event_boss"
		end
	end

	arg_39_0:_give_events(arg_39_1, arg_39_0.terror_spawners, var_39_8, arg_39_2, var_39_1, arg_39_3)
end

function LevelAnalysis._automatic_terror_creation(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	arg_40_3[#arg_40_3 + 1] = {
		Vector3Box(0, 0, 0),
		"safe-dist",
		arg_40_6,
		"deep_pink"
	}

	local var_40_0 = arg_40_2
	local var_40_1 = (var_40_0 - arg_40_6) / arg_40_5
	local var_40_2 = math.floor(var_40_1)
	local var_40_3 = var_40_1 % 1
	local var_40_4 = var_40_2 + (var_40_3 >= arg_40_0:_random() and 1 or 0)

	print("[LevelAnalysis] num_event_places_f:", var_40_1, ", num_event_places:", var_40_2, ", trailing_event_fraction:", var_40_3, ", num_events:", var_40_4)
	print("[LevelAnalysis] Level path distance:", var_40_0)

	if var_40_4 <= 0 then
		return
	end

	local var_40_5 = 100
	local var_40_6 = 0
	local var_40_7 = {}
	local var_40_8 = {}
	local var_40_9
	local var_40_10 = arg_40_6

	for iter_40_0 = 1, var_40_4 do
		local var_40_11 = var_40_10

		var_40_10 = var_40_11 + arg_40_5
		var_40_10 = math.clamp(var_40_10, 0, var_40_0)

		local var_40_12 = var_40_5 - (var_40_10 - var_40_6)

		print("[LevelAnalysis] path_dist1:", var_40_11, ", path_dist2:", var_40_10, " forbidden_dist:", var_40_12)

		if var_40_12 > 0 then
			var_40_11 = var_40_11 + var_40_12
		end

		if var_40_10 < var_40_11 then
			print("[LevelAnalysis] skipping event - not enough space left in this segment")

			break
		end

		var_40_10 = math.clamp(var_40_10, 0, var_40_0)

		local var_40_13 = arg_40_0:_random_float_interval(var_40_11, var_40_10)

		print("[LevelAnalysis] wanted_distance:", var_40_13)

		var_40_7[iter_40_0] = var_40_13
		var_40_6 = var_40_13

		local var_40_14, var_40_15, var_40_16 = Managers.state.conflict.spawn_zone_baker:get_zone_segment_from_travel_dist(var_40_13)

		var_40_8[iter_40_0] = var_40_16.conflict_setting
	end

	local var_40_17 = arg_40_0.level_settings[arg_40_4]
	local var_40_18 = var_40_17 and var_40_17.max_events_of_this_kind or {
		event_boss = 2
	}
	local var_40_19 = arg_40_0:_generate_event_name_list(var_40_8, var_40_18, arg_40_4)

	for iter_40_1 = 1, #var_40_19 do
		local var_40_20 = var_40_7[iter_40_1]
		local var_40_21 = MainPathUtils.point_on_mainpath(arg_40_1, var_40_20)
		local var_40_22 = Vector3Box(var_40_21)
		local var_40_23 = "nothing"
		local var_40_24 = var_40_19[iter_40_1]
		local var_40_25 = "deep_pink"

		if var_40_24 ~= "nothing" then
			local var_40_26 = var_40_8[iter_40_1].boss[arg_40_4]

			var_40_25 = var_40_26.debug_color

			local var_40_27 = {}
			local var_40_28 = var_40_26.event_lookup[var_40_24]

			var_40_23 = var_40_28[arg_40_0:_random(#var_40_28)]

			if var_40_26.terror_events_using_packs then
				arg_40_0.enemy_recycler:add_terror_event_in_area(var_40_22, var_40_23, var_40_27)
			else
				arg_40_0.enemy_recycler:add_main_path_terror_event(var_40_22, var_40_23, 45, var_40_27)
			end
		end

		arg_40_3[#arg_40_3 + 1] = {
			var_40_22,
			var_40_23,
			var_40_20,
			var_40_25
		}
	end
end

function LevelAnalysis.debug_spawn_boss_from_closest_spawner_to_player(arg_41_0, arg_41_1)
	local var_41_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS[1]
	local var_41_1 = math.huge
	local var_41_2
	local var_41_3 = arg_41_0.saved_terror_spawners

	if not var_41_3 then
		print("debug_spawn_boss_from_closest_spawner_to_player - no spawners found")

		return
	end

	print("debug_spawn_boss_from_closest_spawner_to_player")

	local var_41_4 = var_41_3.event_boss.spawners

	for iter_41_0 = 1, #var_41_4 do
		local var_41_5 = var_41_4[iter_41_0]
		local var_41_6 = Unit.local_position(var_41_5[1], 0)
		local var_41_7 = Vector3.distance(var_41_0, var_41_6)

		if var_41_7 < var_41_1 then
			var_41_1 = var_41_7
			var_41_2 = var_41_6
		end

		QuickDrawer:sphere(var_41_6, 1.5, Color(100, 200, 10))
	end

	if var_41_2 then
		print("debug_spawn_boss_from_closest_spawner_to_player - found spawner!")
		QuickDrawerStay:sphere(var_41_2, 1.6, Color(50, 200, 10))

		if not arg_41_1 then
			print("\t spawning ogre")

			local var_41_8 = Quaternion(Vector3.up(), 0)
			local var_41_9

			Managers.state.conflict:spawn_queued_unit(Breeds.skaven_rat_ogre, Vector3Box(var_41_2), QuaternionBox(var_41_8), "debug_spawn", nil, nil, var_41_9)
		end
	end
end

function LevelAnalysis.generate_boss_paths(arg_42_0)
	arg_42_0.boss_event_list = {}
	arg_42_0.total_main_path_dist = arg_42_0:calc_dists_to_start()

	local var_42_0 = arg_42_0.level_settings

	printf("[LevelAnalysis] Generating boss paths for level: %s", var_42_0.level_id)
	printf("[LevelAnalysis] This level has a total main-path length of %.3f meters.", arg_42_0.total_main_path_dist)

	local var_42_1 = var_42_0.boss_spawning_method

	if var_42_1 == "hand_placed" then
		arg_42_0:_hand_placed_terror_creation(arg_42_0.main_paths, arg_42_0.boss_event_list, "boss_events")
	elseif var_42_1 == "bypassed" then
		-- block empty
	else
		local var_42_2 = var_42_0.boss_events
		local var_42_3 = var_42_2 and var_42_2.recurring_distance or 300
		local var_42_4 = var_42_2 and var_42_2.safe_dist or 150

		arg_42_0:_automatic_terror_creation(arg_42_0.main_paths, arg_42_0.total_main_path_dist, arg_42_0.boss_event_list, "boss_events", var_42_3, var_42_4)
	end

	local var_42_5 = var_42_0.rare_events

	if not var_42_5 or var_42_5 and not var_42_5.disabled then
		local var_42_6 = var_42_5 and var_42_5.recurring_distance or 1500
		local var_42_7 = var_42_5 and var_42_5.safe_dist or 50

		arg_42_0:_automatic_terror_creation(arg_42_0.main_paths, arg_42_0.total_main_path_dist, arg_42_0.boss_event_list, "rare_events", var_42_6, var_42_7)
	end
end

function LevelAnalysis.get_main_paths(arg_43_0)
	return arg_43_0.main_paths
end

function LevelAnalysis.get_crossroads(arg_44_0)
	return arg_44_0.crossroads
end

local function var_0_0(arg_45_0, arg_45_1)
	for iter_45_0 = 1, #arg_45_0 do
		local var_45_0 = arg_45_0[iter_45_0]
		local var_45_1 = var_45_0.id

		if var_45_1 then
			arg_45_1[var_45_1] = var_45_0
		end
	end
end

function LevelAnalysis._make_waypoint_lookup(arg_46_0)
	arg_46_0.waypoint_lookup_table = {}

	if arg_46_0.event_waypoints then
		var_0_0(arg_46_0.event_waypoints, arg_46_0.waypoint_lookup_table)
	end

	if arg_46_0.patrol_waypoints then
		var_0_0(arg_46_0.patrol_waypoints, arg_46_0.waypoint_lookup_table)
	end

	if arg_46_0.boss_waypoints then
		for iter_46_0, iter_46_1 in pairs(arg_46_0.boss_waypoints) do
			var_0_0(iter_46_1, arg_46_0.waypoint_lookup_table)
		end
	end
end

function LevelAnalysis._remove_short_routes(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_1 then
		return
	end

	local var_47_0 = Vector3.distance

	for iter_47_0 = #arg_47_1, 1, -1 do
		local var_47_1 = arg_47_1[iter_47_0]
		local var_47_2 = var_47_1.waypoints
		local var_47_3 = 0
		local var_47_4 = var_47_2[1]
		local var_47_5 = Vector3(var_47_4[1], var_47_4[2], var_47_4[3])
		local var_47_6

		for iter_47_1 = 2, #var_47_2 do
			local var_47_7 = var_47_2[iter_47_1]
			local var_47_8 = Vector3(var_47_7[1], var_47_7[2], var_47_7[3])

			var_47_3 = var_47_3 + var_47_0(var_47_5, var_47_8)

			if var_47_3 > 15 then
				break
			end

			var_47_5 = var_47_8
		end

		if var_47_3 <= 15 then
			print("Removing patrol of type: '" .. arg_47_2 .. "', called: '" .. var_47_1.id .. "' because it is too short: " .. var_47_3 .. "m, which is less then 15m.")
			table.remove(arg_47_1, iter_47_0)
		end
	end
end

function LevelAnalysis.store_patrol_waypoints(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if arg_48_1 then
		for iter_48_0 = 1, #arg_48_1 do
			arg_48_0:_remove_short_routes(arg_48_1[iter_48_0], "boss")

			if arg_48_0._skip_to_map_section and iter_48_0 < arg_48_0._skip_to_map_section then
				table.clear(arg_48_1[iter_48_0])
			end
		end
	end

	arg_48_0:_remove_short_routes(arg_48_2, "roaming")
	arg_48_0:_remove_short_routes(arg_48_3, "event")

	arg_48_0.used_roaming_waypoints = {}
	arg_48_0.boss_waypoints = arg_48_1
	arg_48_0.patrol_waypoints = arg_48_2

	local var_48_0 = Managers.state.entity:system("ai_group_system")

	if arg_48_3 then
		arg_48_0.event_waypoints = arg_48_3

		var_48_0:add_ready_splines(arg_48_0.event_waypoints, "event")
	end

	arg_48_0:_make_waypoint_lookup()
	var_48_0:add_ready_splines(arg_48_0.patrol_waypoints, "roaming")
end

function LevelAnalysis.draw_patrol_route(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = Vector3(0, 0, 1)
	local var_49_1 = arg_49_1.waypoints
	local var_49_2 = var_49_1[1]
	local var_49_3 = Vector3(var_49_2[1], var_49_2[2], var_49_2[3]) + var_49_0

	arg_49_2:sphere(var_49_3, 0.5, arg_49_3)

	local var_49_4

	for iter_49_0 = 2, #var_49_1 do
		local var_49_5 = var_49_1[iter_49_0]
		local var_49_6 = Vector3(var_49_5[1], var_49_5[2], var_49_5[3]) + var_49_0

		arg_49_2:sphere(var_49_6, 0.5, arg_49_3)
		arg_49_2:line(var_49_3, var_49_6, arg_49_3)

		var_49_3 = var_49_6
	end
end

function LevelAnalysis.draw_patrol_routes(arg_50_0)
	local var_50_0 = QuickDrawerStay
	local var_50_1 = {
		Color(0, 255, 40),
		Color(0, 75, 255),
		Color(200, 25, 40),
		Color(255, 0, 255),
		Color(0, 0, 255),
		Color(0, 200, 0),
		Color(220, 200, 0)
	}
	local var_50_2 = arg_50_0.boss_waypoints

	if var_50_2 then
		for iter_50_0 = 1, #var_50_2 do
			local var_50_3 = var_50_2[iter_50_0]
			local var_50_4 = var_50_1[iter_50_0]

			for iter_50_1 = 1, #var_50_3 do
				local var_50_5 = var_50_3[iter_50_1]

				arg_50_0:draw_patrol_route(var_50_5, var_50_0, var_50_4)
			end
		end
	end

	local var_50_6 = Color(0, 220, 200)
	local var_50_7 = arg_50_0.patrol_waypoints

	if var_50_7 then
		for iter_50_2 = 1, #var_50_7 do
			local var_50_8 = var_50_7[iter_50_2]

			arg_50_0:draw_patrol_route(var_50_8, var_50_0, var_50_6)
		end
	end

	local var_50_9 = Color(100, 100, 0)
	local var_50_10 = arg_50_0.event_waypoints

	if var_50_10 then
		for iter_50_3 = 1, #var_50_10 do
			local var_50_11 = var_50_10[iter_50_3]

			arg_50_0:draw_patrol_route(var_50_11, var_50_0, var_50_9)
		end
	end
end

function LevelAnalysis.draw_patrol_start_position(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	local var_51_0 = Vector3(0, 0, 1)
	local var_51_1 = arg_51_1.waypoints[1]
	local var_51_2 = Vector3(var_51_1[1], var_51_1[2], var_51_1[3]) + var_51_0

	arg_51_2:sphere(var_51_2, 1, arg_51_3)
	arg_51_2:line(var_51_2, var_51_2 + Vector3(0, 0, 50), Colors.get("red"))
	table.dump(arg_51_1)

	local var_51_3

	if arg_51_1.one_directional then
		var_51_3 = "Patrol " .. arg_51_1.id .. " one_directional " .. " MS: " .. arg_51_4
	else
		var_51_3 = "Patrol " .. arg_51_1.id .. " MS: " .. arg_51_4
	end

	local var_51_4

	if arg_51_1.main_path_connector then
		local var_51_5 = Vector3(arg_51_1.main_path_connector[1], arg_51_1.main_path_connector[2], arg_51_1.main_path_connector[3])

		arg_51_2:sphere(var_51_5, 1, Colors.get("lime"))
		print("Found main path connector")

		var_51_4 = var_51_5
	end

	Managers.state.debug_text:output_world_text(var_51_3, 0.5, var_51_2 + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))

	local var_51_6

	if var_51_4 then
		local var_51_7, var_51_8 = MainPathUtils.closest_pos_at_main_path(nil, var_51_4)

		arg_51_2:sphere(var_51_7, 1, Colors.get("cyan"))

		local var_51_9 = "" .. arg_51_1.id .. " using main path connection "

		Managers.state.debug_text:output_world_text(var_51_9, 0.5, var_51_7 + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))
		arg_51_2:line(var_51_2, var_51_7, Colors.get("cyan"))

		var_51_6 = var_51_8

		print("Main path connector travel dist ", var_51_6)
	else
		local var_51_10, var_51_11 = MainPathUtils.closest_pos_at_main_path(nil, var_51_2)

		arg_51_2:sphere(var_51_10, 1, Colors.get("cyan"))

		local var_51_12 = "" .. arg_51_1.id .. " connection "

		Managers.state.debug_text:output_world_text(var_51_12, 0.5, var_51_10 + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))
		arg_51_2:line(var_51_2, var_51_10, Colors.get("cyan"))

		var_51_6 = var_51_11
	end

	local var_51_13 = MainPathUtils.point_on_mainpath(nil, var_51_6 - 45)

	if var_51_13 then
		arg_51_2:line(var_51_2, var_51_13, Colors.get("yellow"))
		arg_51_2:sphere(var_51_13, 1, arg_51_3)

		local var_51_14 = "" .. arg_51_1.id .. " trigger "

		Managers.state.debug_text:output_world_text(var_51_14, 0.4, var_51_13 + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))
	end
end

function LevelAnalysis.draw_patrol_start_positions(arg_52_0)
	local var_52_0 = QuickDrawerStay
	local var_52_1 = Colors.get("purple")
	local var_52_2 = arg_52_0.boss_waypoints

	Managers.state.debug_text:clear_world_text("patrol_start_position_debug")

	if var_52_2 then
		for iter_52_0 = 1, #var_52_2 do
			local var_52_3 = var_52_2[iter_52_0]

			for iter_52_1 = 1, #var_52_3 do
				local var_52_4 = var_52_3[iter_52_1]

				arg_52_0:draw_patrol_start_position(var_52_4, var_52_0, var_52_1, iter_52_0)
			end
		end
	end
end

function LevelAnalysis.debug_get_closest_boss_patrol_spawn(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0.boss_waypoints
	local var_53_1
	local var_53_2 = math.huge

	if var_53_0 then
		for iter_53_0 = 1, #var_53_0 do
			local var_53_3 = var_53_0[iter_53_0]

			for iter_53_1 = 1, #var_53_3 do
				local var_53_4 = var_53_3[iter_53_1]
				local var_53_5 = Vector3(0, 0, 1)
				local var_53_6 = var_53_4.waypoints[1]
				local var_53_7 = Vector3(var_53_6[1], var_53_6[2], var_53_6[3]) + var_53_5
				local var_53_8 = Vector3.distance(arg_53_1, var_53_7)

				if var_53_8 < var_53_2 then
					var_53_1 = var_53_4
					var_53_2 = var_53_8
				end
			end
		end
	end

	local var_53_9 = arg_53_0:boxify_waypoint_table(var_53_1.waypoints)

	return var_53_1, var_53_9
end

function LevelAnalysis.get_waypoint_spline(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.waypoint_lookup_table and arg_54_0.waypoint_lookup_table[arg_54_1]

	if var_54_0 then
		local var_54_1 = var_54_0.waypoints
		local var_54_2 = var_54_1[1]
		local var_54_3 = Vector3(var_54_2[1], var_54_2[2], var_54_2[3])

		if var_54_0.one_directional then
			print("Getting waypoint spline, is one one_directional")
		end

		return var_54_0, var_54_1, var_54_3, var_54_0.one_directional
	end
end

function LevelAnalysis.get_closest_waypoint_spline(arg_55_0, arg_55_1)
	if not arg_55_0.waypoint_lookup_table then
		return
	end

	local var_55_0 = arg_55_0.waypoint_lookup_table

	if not var_55_0 then
		printf("Missing patrol waypoints")

		return
	end

	local var_55_1 = math.huge
	local var_55_2

	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		local var_55_3 = iter_55_1.waypoints[1]
		local var_55_4 = Vector3(var_55_3[1], var_55_3[2], var_55_3[3])
		local var_55_5 = Vector3.distance(arg_55_1, var_55_4)

		if var_55_5 < var_55_1 then
			var_55_2 = iter_55_0
			var_55_1 = var_55_5
		end
	end

	if var_55_2 then
		local var_55_6 = var_55_0[var_55_2]
		local var_55_7 = LevelAnalysis.boxify_table_pos_array(var_55_6.waypoints)

		return var_55_2, var_55_7, var_55_7[1]:unbox()
	end

	print("Closest")

	return nil
end

local var_0_1 = Vector3.to_elements
local var_0_2 = Vector3.set_xyz
local var_0_3 = Script.temp_count
local var_0_4 = Script.set_temp_count
local var_0_5 = Geometry.closest_point_on_line
local var_0_6 = Vector3.distance_squared

function LevelAnalysis.get_closest_pos_to_waypoint_list(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = Vector3(0, 0, 0)
	local var_56_1 = math.huge
	local var_56_2 = Vector3(unpack(arg_56_1[1]))
	local var_56_3, var_56_4, var_56_5 = var_0_3()

	for iter_56_0 = 2, #arg_56_1 do
		local var_56_6 = Vector3(unpack(arg_56_1[iter_56_0]))
		local var_56_7 = var_0_5(arg_56_2, var_56_2, var_56_6)
		local var_56_8 = var_0_6(arg_56_2, var_56_7)

		if var_56_8 < var_56_1 then
			var_56_1 = var_56_8

			var_0_2(var_56_0, var_0_1(var_56_7))
		end

		var_56_2 = var_56_6
	end

	var_0_4(var_56_3, var_56_4, var_56_5)

	return var_56_0
end

function LevelAnalysis.get_closest_roaming_spline(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0
	local var_57_1
	local var_57_2
	local var_57_3
	local var_57_4 = 30
	local var_57_5 = Vector3.distance
	local var_57_6 = arg_57_0.used_roaming_waypoints
	local var_57_7
	local var_57_8 = arg_57_0.patrol_waypoints

	for iter_57_0 = 1, #var_57_8 do
		if not var_57_6[iter_57_0] then
			local var_57_9 = var_57_8[iter_57_0]
			local var_57_10 = arg_57_2 and arg_57_0:get_closest_pos_to_waypoint_list(var_57_9.waypoints, arg_57_1) or var_57_9.waypoints[1]
			local var_57_11 = Vector3(var_57_10[1], var_57_10[2], var_57_10[3])
			local var_57_12 = var_57_5(arg_57_1, var_57_11)

			if var_57_12 < var_57_4 then
				var_57_4 = var_57_12
				var_57_0 = var_57_9.id
				var_57_1 = var_57_9
				var_57_7 = iter_57_0
				var_57_2 = var_57_11
			end
		end
	end

	if var_57_0 then
		var_57_6[var_57_7] = true
	end

	return var_57_0, var_57_1, var_57_2
end

function LevelAnalysis.store_main_paths(arg_58_0, arg_58_1)
	arg_58_0.main_paths = arg_58_1

	local var_58_0, var_58_1, var_58_2, var_58_3, var_58_4 = MainPathUtils.collapse_main_paths(arg_58_1)
	local var_58_5 = var_58_1[#var_58_1]

	arg_58_0.main_path_data = {
		collapsed_path = var_58_0,
		collapsed_travel_dists = var_58_1,
		breaks_lookup = var_58_3,
		breaks_order = var_58_4,
		total_dist = var_58_5
	}
end

function LevelAnalysis.remove_crossroads_extra_path_branches(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6)
	arg_59_1 = arg_59_1 or arg_59_0.main_paths
	arg_59_2 = arg_59_2 or arg_59_0.crossroads

	local var_59_0 = arg_59_0.starting_seed
	local var_59_1 = arg_59_0.chosen_crossroads
	local var_59_2, var_59_3, var_59_4 = MainPathSpawningGenerator.remove_crossroads_extra_path_branches(arg_59_2, var_59_1, arg_59_1, arg_59_4, arg_59_5, arg_59_6, var_59_0)

	if var_59_2 then
		arg_59_0:remove_terror_spawners_due_to_crossroads(var_59_4)
		Managers.state.entity:system("pickup_system"):remove_pickups_due_to_crossroads(var_59_4, arg_59_3)
		Managers.state.game_mode:remove_respawn_units_due_to_crossroads(var_59_4, arg_59_3)

		return true, var_59_3
	else
		return false, arg_59_5
	end
end

function LevelAnalysis.remove_terror_spawners_due_to_crossroads(arg_60_0, arg_60_1)
	local var_60_0 = {}
	local var_60_1 = arg_60_0.terror_spawners
	local var_60_2 = #arg_60_1

	for iter_60_0, iter_60_1 in pairs(var_60_1) do
		table.clear(var_60_0)

		local var_60_3 = iter_60_1.spawners

		for iter_60_2 = 1, #var_60_3 do
			local var_60_4 = var_60_3[iter_60_2][2]

			for iter_60_3 = 1, var_60_2 do
				local var_60_5 = arg_60_1[iter_60_3]

				if var_60_4 > var_60_5[1] and var_60_4 < var_60_5[2] then
					var_60_0[#var_60_0 + 1] = iter_60_2

					break
				end
			end
		end

		for iter_60_4 = #var_60_0, 1, -1 do
			table.remove(var_60_3, var_60_0[iter_60_4])
		end
	end

	local var_60_6 = arg_60_0.boss_waypoints

	if not var_60_6 then
		return false, "no boss waypoints table, you need to regenerate boss waypoints in editor!"
	end

	table.clear(var_60_0)

	for iter_60_5 = 1, #var_60_6 do
		local var_60_7 = var_60_6[iter_60_5]

		for iter_60_6 = 1, #var_60_7 do
			local var_60_8 = var_60_7[iter_60_6]
			local var_60_9 = var_60_8.travel_dist

			for iter_60_7 = 1, var_60_2 do
				local var_60_10 = arg_60_1[iter_60_7]

				if var_60_9 > var_60_10[1] and var_60_9 < var_60_10[2] then
					var_60_0[#var_60_0 + 1] = var_60_8.id

					break
				end
			end
		end

		for iter_60_8 = 1, #var_60_0 do
			local var_60_11 = var_60_0[iter_60_8]

			for iter_60_9 = 1, #var_60_7 do
				if var_60_7[iter_60_9].id == var_60_11 then
					table.remove(var_60_7, iter_60_9)

					break
				end
			end
		end

		table.dump(var_60_7)
	end
end

function LevelAnalysis.brute_force_calc_zone_distances(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	for iter_61_0 = 1, arg_61_2 do
		local var_61_0 = arg_61_1[iter_61_0]
		local var_61_1 = var_61_0.sub

		if var_61_1[1] then
			local var_61_2 = arg_61_3[var_61_1[1][1]]
			local var_61_3, var_61_4, var_61_5, var_61_6, var_61_7 = EngineOptimized.closest_pos_at_main_path(Vector3(var_61_2[1], var_61_2[2], var_61_2[3]))

			var_61_0.old_travel_dist = var_61_0.travel_dist
			var_61_0.travel_dist = var_61_4
		end
	end
end

function LevelAnalysis.store_path_markers(arg_62_0, arg_62_1)
	arg_62_0.path_markers = arg_62_1
	arg_62_0.start = arg_62_1[1].pos
	arg_62_0.finish = arg_62_1[#arg_62_1].pos
end

function LevelAnalysis.main_path(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0.main_paths[arg_63_1]

	return var_63_0.nodes, var_63_0.path_length
end

function LevelAnalysis.get_path_point(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = 0
	local var_64_1 = arg_64_2 * arg_64_1
	local var_64_2 = Vector3.length

	for iter_64_0 = 1, #arg_64_0 - 1 do
		local var_64_3 = arg_64_0[iter_64_0]:unbox()
		local var_64_4 = arg_64_0[iter_64_0 + 1]:unbox() - var_64_3
		local var_64_5 = var_64_2(var_64_4)

		var_64_0 = var_64_0 + var_64_5

		if var_64_1 < var_64_0 then
			return var_64_3 + var_64_4 * ((var_64_5 - (var_64_0 - var_64_1)) / var_64_5), iter_64_0
		end
	end

	return arg_64_0[#arg_64_0]:unbox(), #arg_64_0
end

function LevelAnalysis.reset_debug(arg_65_0)
	Managers.state.debug_text:clear_world_text("boss_spawning")

	arg_65_0.used_roaming_waypoints = {}
end

function LevelAnalysis.debug(arg_66_0, arg_66_1)
	local var_66_0 = Managers.state.debug_text

	var_66_0:clear_world_text("boss")

	if false and not arg_66_0._debug_boss_spawning then
		local var_66_1 = arg_66_0.terror_spawners
		local var_66_2 = 0

		for iter_66_0, iter_66_1 in pairs(var_66_1) do
			local var_66_3 = Vector3(0, 0, 22 + var_66_2)
			local var_66_4 = iter_66_1.spawners

			for iter_66_2 = 1, #var_66_4 do
				local var_66_5 = var_66_4[iter_66_2]
				local var_66_6 = var_66_5[1]
				local var_66_7 = var_66_5[3]
				local var_66_8 = Unit.local_position(var_66_6, 0)
				local var_66_9 = var_66_8 + var_66_3
				local var_66_10 = Colors.distinct_colors_lookup[(var_66_7 + 3) % 10]
				local var_66_11 = Color(var_66_10[1], var_66_10[2], var_66_10[3])

				QuickDrawerStay:line(var_66_8, var_66_9, var_66_11)
				var_66_0:output_world_text(iter_66_0, 0.5, var_66_9, nil, "boss_spawning", Vector3(var_66_10[1], var_66_10[2], var_66_10[3]), "player_1")

				local var_66_12 = var_66_5[2]
				local var_66_13 = MainPathUtils.point_on_mainpath(arg_66_0.main_paths, var_66_12)

				QuickDrawerStay:line(var_66_9, var_66_13, var_66_11)
			end

			var_66_2 = var_66_2 + 0.5
		end

		arg_66_0._debug_boss_spawning = true
	end

	if arg_66_0.path_markers then
		for iter_66_3 = 1, #arg_66_0.path_markers do
			local var_66_14 = arg_66_0.path_markers[iter_66_3].pos:unbox()

			if arg_66_0.path_markers[iter_66_3].marker_type == "break" or arg_66_0.path_markers[iter_66_3].marker_type == "crossroad_break" then
				QuickDrawer:cylinder(var_66_14, var_66_14 + Vector3(0, 0, 8), 0.6, Color(255, 194, 13, 17), 16)
				QuickDrawer:sphere(var_66_14 + Vector3(0, 0, 8), 0.4, Color(255, 194, 13, 17))
			else
				QuickDrawer:cylinder(var_66_14, var_66_14 + Vector3(0, 0, 8), 0.8, Color(255, 244, 183, 7), 16)
			end
		end
	end

	for iter_66_4 = 1, #arg_66_0.main_paths do
		local var_66_15 = arg_66_0.main_paths[iter_66_4]
		local var_66_16 = var_66_15.nodes
		local var_66_17 = var_66_15.path_length

		if var_66_16 and #var_66_16 > 0 then
			local var_66_18 = var_66_16[1]:unbox()

			for iter_66_5 = 1, #var_66_16 do
				local var_66_19 = var_66_16[iter_66_5]:unbox()

				QuickDrawer:sphere(var_66_19 + Vector3(0, 0, 1.5), 0.4, Color(255, 44, 143, 7))
				QuickDrawer:line(var_66_19 + Vector3(0, 0, 1.5), var_66_18 + Vector3(0, 0, 1.5), Color(255, 44, 143, 7))

				var_66_18 = var_66_19
			end

			local var_66_20
			local var_66_21

			if arg_66_0.boss_event_list then
				for iter_66_6 = 1, #arg_66_0.boss_event_list do
					local var_66_22 = arg_66_0.boss_event_list[iter_66_6]
					local var_66_23 = var_66_22[1]:unbox()
					local var_66_24 = var_66_22[2]
					local var_66_25 = var_66_23 + Vector3(0, 0, 10)
					local var_66_26 = var_66_22[4]
					local var_66_27 = Colors.get(var_66_26)

					QuickDrawer:cylinder(var_66_23, var_66_25, 0.5, var_66_27, 10)
					QuickDrawer:sphere(var_66_25, 2, var_66_27)

					local var_66_28 = Colors.color_definitions[var_66_26]

					var_66_0:output_world_text(var_66_24, 0.5, var_66_25, nil, "boss", Vector3(var_66_28[2], var_66_28[3], var_66_28[4]), "player_1")
				end
			end

			local var_66_29 = arg_66_1 % 5 / 5
			local var_66_30 = LevelAnalysis.get_path_point(var_66_16, var_66_17, var_66_29)

			QuickDrawer:sphere(var_66_30 + Vector3(0, 0, 1.5), 1.366, Color(255, 244, 183, 7))
		end
	end
end

function LevelAnalysis.update(arg_67_0, arg_67_1)
	if arg_67_0.stitching_path then
		arg_67_0:update_main_path_generation()
	end
end

function LevelAnalysis.get_main_and_sub_zone_index_from_pos(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
	local var_68_0 = GwNavTraversal.get_seed_triangle(arg_68_0, arg_68_3)

	if var_68_0 then
		local var_68_1, var_68_2, var_68_3 = Script.temp_count()
		local var_68_4, var_68_5, var_68_6 = GwNavTraversal.get_triangle_vertices(arg_68_0, var_68_0)
		local var_68_7 = (var_68_4 + var_68_5 + var_68_6) / 3
		local var_68_8 = var_68_7.x * 0.0001 + var_68_7.y + var_68_7.z * 10000

		Script.set_temp_count(var_68_1, var_68_2, var_68_3)

		local var_68_9 = arg_68_2[var_68_8]
		local var_68_10 = arg_68_4[var_68_9]

		print("get_main_and_sub_zone_index_from_pos", arg_68_3, var_68_8, var_68_9, var_68_10)

		if var_68_10 then
			local var_68_11 = math.floor(var_68_10 / 10000)
			local var_68_12 = var_68_10 % 10000

			return arg_68_1[var_68_11], var_68_11, var_68_12
		end
	end
end

function LevelAnalysis.get_zone_from_unique_id(arg_69_0, arg_69_1, arg_69_2)
	for iter_69_0 = 1, #arg_69_1 do
		local var_69_0 = arg_69_1[iter_69_0]

		if var_69_0.unique_zone_id == arg_69_2 then
			return var_69_0
		end
	end
end

function LevelAnalysis.get_zone_segment_from_travel_dist(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = arg_70_2

	for iter_70_0 = 1, var_70_0 do
		if arg_70_0 < arg_70_1[iter_70_0].travel_dist - 5 then
			local var_70_1 = iter_70_0 > 1 and iter_70_0 - 1 or iter_70_0
			local var_70_2 = arg_70_1[var_70_1]

			return var_70_1, var_70_2
		end
	end

	return var_70_0, arg_70_1[var_70_0]
end

function LevelAnalysis.setup_unreachable_processing(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	return {
		investigated_points = 0,
		num_points_started = 0,
		running_astar_list = {},
		free_astar_list = {},
		remove_list = {},
		main_paths = arg_71_1,
		nav_world = arg_71_0,
		point_list = arg_71_2,
		max_running_astars = arg_71_3 and arg_71_3.max_concurrent_astars or 25,
		delete_failed_points = arg_71_3 and arg_71_3.delete_failed_points,
		get_pos_func = arg_71_3 and arg_71_3.get_pos_func,
		get_pos_func2 = arg_71_3 and arg_71_3.get_pos_func2,
		path_found_func = arg_71_3 and arg_71_3.path_found_func,
		path_not_found_func = arg_71_3 and arg_71_3.path_not_found_func,
		traverse_logic = arg_71_3 and arg_71_3.traverse_logic or GwNavTraverseLogic.create(arg_71_0),
		line_object = arg_71_3 and arg_71_3.line_object,
		fail_color = arg_71_3 and arg_71_3.fail_color,
		ok_color = arg_71_3 and arg_71_3.ok_color,
		translate_vec = arg_71_3 and arg_71_3.translate_vec
	}
end

function LevelAnalysis.process_unreachable(arg_72_0)
	local var_72_0 = arg_72_0.point_list
	local var_72_1 = arg_72_0.delete_failed_points
	local var_72_2 = arg_72_0.path_found_func or function()
		return
	end
	local var_72_3 = arg_72_0.path_not_found_func or function()
		return
	end
	local var_72_4 = arg_72_0.get_pos_func or function(arg_75_0, arg_75_1)
		return arg_75_0[arg_75_1]:unbox()
	end
	local var_72_5 = arg_72_0.get_pos_func2 or function()
		return
	end
	local var_72_6 = arg_72_0.max_running_astars
	local var_72_7 = arg_72_0.running_astar_list
	local var_72_8 = arg_72_0.free_astar_list
	local var_72_9 = arg_72_0.remove_list
	local var_72_10 = #var_72_7 + #var_72_8
	local var_72_11 = arg_72_0.num_points_started
	local var_72_12 = #var_72_0
	local var_72_13 = arg_72_0.line_object
	local var_72_14 = arg_72_0.fail_color and Color(unpack(arg_72_0.fail_color)) or Color(255, 0, 0)
	local var_72_15 = arg_72_0.ok_color and Color(unpack(arg_72_0.ok_color)) or Color(255, 255, 255)
	local var_72_16 = arg_72_0.translate_vec and Vector3(unpack(arg_72_0.translate_vec)) or Vector3(0, 0, 0)

	Debug.text("Processing points: %d, %d/%d, astars: free %d running %d", arg_72_0.num_points_started, arg_72_0.investigated_points, var_72_12, #var_72_8, #var_72_7)
	printf("[LevelAnalysis] Processing points: %d, %d/%d, astars: free %d running %d", arg_72_0.num_points_started, arg_72_0.investigated_points, var_72_12, #var_72_8, #var_72_7)

	if var_72_12 <= arg_72_0.investigated_points then
		print("[LevelAnalysis] -->processing done!")

		if var_72_1 then
			if #var_72_9 > 0 then
				print("[LevelAnalysis] -->removing bad points:")
				table.sort(var_72_9)

				for iter_72_0 = #var_72_9, 1, -1 do
					local var_72_17 = var_72_9[iter_72_0]

					var_72_0[var_72_17] = nil

					print("[LevelAnalysis] \tpoint", var_72_17, "removed")
				end
			else
				print("[LevelAnalysis] --> no bad points were found!")
			end
		end

		print("[LevelAnalysis] --> clearing up free_astars:", #var_72_8)

		local var_72_18 = GwNavAStar.destroy

		for iter_72_1 = 1, #var_72_8 do
			var_72_18(var_72_8[iter_72_1].astar)
		end

		print("[LevelAnalysis] -->clearing up running_astars:", #var_72_7)

		for iter_72_2 = 1, #var_72_7 do
			local var_72_19 = var_72_7[iter_72_2].astar

			var_72_18(var_72_19)
		end

		print("[LevelAnalysis] -->bye!")

		return true
	end

	local var_72_20 = arg_72_0.traverse_logic
	local var_72_21 = 0
	local var_72_22

	if var_72_6 > #var_72_7 - #var_72_8 then
		local var_72_23 = GwNavAStar.start

		while var_72_11 < var_72_12 and var_72_21 < var_72_6 do
			local var_72_24

			if #var_72_8 > 0 then
				var_72_24 = var_72_8[#var_72_8]
				var_72_8[#var_72_8] = nil
				var_72_22 = var_72_24.astar
				var_72_24.point_index = var_72_11 + 1
				var_72_7[#var_72_7 + 1] = var_72_24
			elseif var_72_10 < var_72_6 then
				var_72_21 = var_72_21 + 1
				var_72_22 = GwNavAStar.create()
				var_72_10 = var_72_10 + 1
				var_72_24 = {
					astar = var_72_22,
					point_index = var_72_11 + 1
				}
				var_72_7[var_72_21] = var_72_24
			else
				break
			end

			local var_72_25 = var_72_4(var_72_0, var_72_11 + 1)
			local var_72_26 = var_72_5(var_72_0, var_72_11 + 1) or MainPathUtils.closest_pos_at_main_path_lua(arg_72_0.main_paths, var_72_25)

			var_72_24.goal_pos_boxed = Vector3Box(var_72_26)
			var_72_11 = var_72_11 + 1

			fassert(var_72_26, "No main-path pos found")
			var_72_23(var_72_22, arg_72_0.nav_world, var_72_25, var_72_26, var_72_20)
		end
	end

	arg_72_0.num_points_started = var_72_11

	local var_72_27 = 1
	local var_72_28 = #var_72_7
	local var_72_29 = GwNavAStar.processing_finished
	local var_72_30 = GwNavAStar.path_found
	local var_72_31 = GwNavAStar.node_at_index
	local var_72_32 = GwNavAStar.node_count

	while var_72_27 <= var_72_28 do
		local var_72_33 = var_72_7[var_72_27]
		local var_72_34 = var_72_33.astar

		if var_72_29(var_72_34) then
			arg_72_0.investigated_points = arg_72_0.investigated_points + 1

			if var_72_30(var_72_34) then
				if var_72_13 then
					local var_72_35, var_72_36, var_72_37 = Script.temp_count()
					local var_72_38 = var_72_31(var_72_34, 1)
					local var_72_39 = Vector3(0, 0, 0.2) + var_72_16

					for iter_72_3 = 2, var_72_32(var_72_34) do
						local var_72_40 = var_72_31(var_72_34, iter_72_3)

						var_72_13:line(var_72_38 + var_72_39, var_72_40 + var_72_39, var_72_15)

						var_72_38 = var_72_40
					end

					Script.set_temp_count(var_72_35, var_72_36, var_72_37)
				end

				printf("[LevelAnalysis] \tpoint: %d ok! (%d/%d)", var_72_33.point_index, arg_72_0.investigated_points, var_72_12)
				var_72_2(var_72_0, var_72_33.point_index, var_72_33)
			else
				if var_72_13 then
					local var_72_41 = Vector3(0, 0, 0.2) + var_72_16
					local var_72_42 = var_72_4(var_72_0, var_72_33.point_index)
					local var_72_43 = MainPathUtils.closest_pos_at_main_path_lua(arg_72_0.main_paths, var_72_42)

					var_72_13:line(var_72_42 + var_72_41, var_72_43 + var_72_41, var_72_14)
					var_72_13:sphere(var_72_42 + var_72_41, 0.2, var_72_14)
					var_72_13:sphere(var_72_43 + var_72_41, 0.2, var_72_14)
				end

				printf("[LevelAnalysis] \tpoint: %d failed! (%d/%d)", var_72_33.point_index, arg_72_0.investigated_points, var_72_12)
				var_72_3(var_72_0, var_72_33.point_index)

				if var_72_1 then
					var_72_9[#var_72_9 + 1] = var_72_33.point_index
				end
			end

			var_72_8[#var_72_8 + 1] = var_72_33
			var_72_7[var_72_27] = var_72_7[var_72_28]
			var_72_7[var_72_28] = nil
			var_72_28 = var_72_28 - 1
		else
			var_72_27 = var_72_27 + 1
		end
	end
end

function LevelAnalysis.setup_main_path_breaks_check(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	local var_77_0 = {
		max_running_astars = 50,
		nav_world = arg_77_0,
		traverse_logic = arg_77_2,
		running_astar_list = {},
		free_astar_list = {},
		nodes_to_check = {},
		drawer = arg_77_4,
		failed_main_path_breaks = {},
		optional_failed_messages = {}
	}
	local var_77_1 = var_77_0.nodes_to_check
	local var_77_2 = var_77_0.optional_failed_messages
	local var_77_3 = #arg_77_1

	for iter_77_0 = var_77_3, 1, -1 do
		local var_77_4 = arg_77_1[iter_77_0]
		local var_77_5 = var_77_4.nodes
		local var_77_6 = var_77_5[1]

		for iter_77_1 = iter_77_0 - 1, 1, -1 do
			local var_77_7 = arg_77_1[iter_77_1]
			local var_77_8 = var_77_7.nodes
			local var_77_9 = var_77_8[#var_77_8]
			local var_77_10 = var_77_4.crossroads_id or var_77_7.crossroads_id
			local var_77_11 = var_77_10 and MainPathSpawningGenerator.main_path_has_marker_type(arg_77_3, iter_77_1, "crossroad_break")
			local var_77_12 = var_77_4.crossroads_id == var_77_7.crossroads_id
			local var_77_13 = var_77_4.road_id == var_77_7.road_id

			var_77_1[#var_77_1 + 1] = {
				from_node_box = var_77_6,
				to_node_box = var_77_9,
				from_main_path_index = iter_77_0,
				to_main_path_index = iter_77_1,
				is_crossroad = var_77_10,
				has_crossroad_break = var_77_11,
				shares_crossroad_id = var_77_12,
				shares_road_id = var_77_13
			}
		end

		if MainPathSpawningGenerator.main_path_has_marker_type(arg_77_3, iter_77_0, "crossroad_break") then
			local var_77_14 = var_77_5[#var_77_5]
			local var_77_15 = var_77_4.crossroads_id

			if var_77_15 then
				for iter_77_2 = iter_77_0 + 1, var_77_3 do
					local var_77_16 = arg_77_1[iter_77_2]
					local var_77_17 = var_77_16.nodes[1]
					local var_77_18 = var_77_16.crossroads_id

					if not var_77_18 or var_77_18 == var_77_15 then
						var_77_1[#var_77_1 + 1] = {
							crossroad_break_check = true,
							from_node_box = var_77_14,
							to_node_box = var_77_17,
							from_main_path_index = iter_77_0,
							to_main_path_index = iter_77_2
						}

						print("Checking crossroad break on a crossroad between " .. iter_77_0 .. " to " .. iter_77_2)

						break
					end
				end
			else
				local var_77_19
				local var_77_20 = {}

				for iter_77_3 = iter_77_0 + 1, var_77_3 do
					local var_77_21 = arg_77_1[iter_77_3]
					local var_77_22 = var_77_21.nodes[1]
					local var_77_23 = var_77_21.crossroads_id
					local var_77_24 = var_77_21.road_id

					if var_77_23 then
						var_77_19 = var_77_19 or var_77_23

						if var_77_23 == var_77_19 and not var_77_20[var_77_24] then
							var_77_1[#var_77_1 + 1] = {
								crossroad_break_check = true,
								from_node_box = var_77_14,
								to_node_box = var_77_22,
								from_main_path_index = iter_77_0,
								to_main_path_index = iter_77_3
							}
							var_77_20[var_77_24] = true

							print("Checking crossroad break between " .. iter_77_0 .. " to " .. iter_77_3)
						end
					else
						if not var_77_19 then
							print("There is no crossroad after crossroad break " .. iter_77_0)

							var_77_2[#var_77_2 + 1] = string.format("Error! There is not a crossroad after crossroad break at main path %d at position %s ", iter_77_0, tostring(var_77_22:unbox()))
						end

						break
					end
				end
			end
		end
	end

	return var_77_0
end

function LevelAnalysis.process_main_path_breaks_check(arg_78_0)
	local var_78_0 = arg_78_0.nav_world
	local var_78_1 = arg_78_0.traverse_logic
	local var_78_2 = arg_78_0.running_astar_list
	local var_78_3 = arg_78_0.free_astar_list
	local var_78_4 = arg_78_0.nodes_to_check
	local var_78_5 = arg_78_0.max_running_astars
	local var_78_6 = arg_78_0.drawer
	local var_78_7 = arg_78_0.failed_main_path_breaks
	local var_78_8 = arg_78_0.optional_failed_messages
	local var_78_9 = GwNavAStar.create
	local var_78_10 = GwNavAStar.start
	local var_78_11 = GwNavAStar.processing_finished
	local var_78_12 = GwNavAStar.path_found
	local var_78_13 = GwNavAStar.node_count
	local var_78_14 = GwNavAStar.node_at_index
	local var_78_15 = GwNavAStar.destroy

	while #var_78_4 > 0 and var_78_5 > #var_78_2 do
		local var_78_16 = #var_78_4
		local var_78_17 = var_78_4[var_78_16]

		var_78_4[var_78_16] = nil

		local var_78_18

		if #var_78_3 > 0 then
			var_78_18 = var_78_3[#var_78_3]
			var_78_3[#var_78_3] = nil
		else
			var_78_18 = {
				astar = var_78_9()
			}
		end

		local var_78_19 = var_78_18.astar
		local var_78_20 = var_78_17.from_node_box:unbox()
		local var_78_21 = var_78_17.to_node_box:unbox()

		var_78_18.from_main_path_index = var_78_17.from_main_path_index
		var_78_18.to_main_path_index = var_78_17.to_main_path_index
		var_78_18.from_node_box = var_78_17.from_node_box
		var_78_18.to_node_box = var_78_17.to_node_box
		var_78_18.is_crossroad = var_78_17.is_crossroad
		var_78_18.has_crossroad_break = var_78_17.has_crossroad_break
		var_78_18.shares_crossroad_id = var_78_17.shares_crossroad_id
		var_78_18.shares_road_id = var_78_17.shares_road_id
		var_78_18.crossroad_break_check = var_78_17.crossroad_break_check

		var_78_10(var_78_19, var_78_0, var_78_20, var_78_21, var_78_1)

		var_78_2[#var_78_2 + 1] = var_78_18
	end

	local var_78_22 = 1
	local var_78_23 = #var_78_2

	while var_78_22 <= var_78_23 do
		local var_78_24 = var_78_2[var_78_22]
		local var_78_25 = var_78_24.astar

		if var_78_11(var_78_25) then
			local var_78_26 = var_78_24.from_main_path_index
			local var_78_27 = var_78_24.to_main_path_index
			local var_78_28 = var_78_24.from_node_box
			local var_78_29 = var_78_24.to_node_box
			local var_78_30 = var_78_24.crossroad_break_check

			if var_78_12(var_78_25) then
				local var_78_31, var_78_32, var_78_33 = Script.temp_count()
				local var_78_34 = Colors.get("red")
				local var_78_35 = Vector3.up() * 0.25
				local var_78_36 = Vector3.up() * 25
				local var_78_37 = var_78_13(var_78_25)

				for iter_78_0 = 2, var_78_37 do
					local var_78_38 = var_78_14(var_78_25, iter_78_0 - 1) + var_78_35
					local var_78_39 = var_78_14(var_78_25, iter_78_0) + var_78_35

					var_78_6:sphere(var_78_38, 0.25, var_78_34)
					var_78_6:line(var_78_38, var_78_39, var_78_34)

					if iter_78_0 == 2 then
						var_78_6:line(var_78_38, var_78_38 + var_78_36, var_78_34)
					end

					if iter_78_0 == var_78_37 then
						var_78_6:sphere(var_78_39, 0.25, var_78_34)
						var_78_6:line(var_78_39, var_78_39 + var_78_36, var_78_34)
					end
				end

				Script.set_temp_count(var_78_31, var_78_32, var_78_33)

				local var_78_40 = var_78_24.is_crossroad
				local var_78_41 = var_78_24.has_crossroad_break
				local var_78_42 = var_78_24.shares_crossroad_id
				local var_78_43 = var_78_24.shares_road_id

				if var_78_30 then
					printf("[LevelAnalysis] Found path from crossroad break between main_path_index %d and %d (start=%s end=%s). But that's ok since it will be stitched", var_78_26, var_78_27, tostring(var_78_28:unbox()), tostring(var_78_29:unbox()))
				elseif not var_78_40 or not var_78_41 and (not var_78_42 or var_78_43) then
					local var_78_44 = var_78_7[var_78_26] or {}

					var_78_44[var_78_27] = {
						node = var_78_29,
						is_crossroad = var_78_40
					}
					var_78_7[var_78_26] = var_78_44

					printf("[LevelAnalysis] Error! Path exist between main_path_index %d and %d (start=%s end=%s)!", var_78_26, var_78_27, tostring(var_78_28:unbox()), tostring(var_78_29:unbox()))
				elseif not var_78_43 and var_78_42 then
					printf("[LevelAnalysis] Path exist between main_path_index %d and %d (start=%s end=%s), but it is between two diffrent roads in the same crossroad that wont exist together.", var_78_26, var_78_27, tostring(var_78_28:unbox()), tostring(var_78_29:unbox()))
				end
			elseif var_78_30 then
				local var_78_45 = var_78_7[var_78_26] or {}

				var_78_45[var_78_27] = {
					node = var_78_29,
					optional_failed_messages = var_78_8
				}
				var_78_7[var_78_26] = var_78_45

				printf("[LevelAnalysis] Could not find path to mainpath after crossroad break %d and %d (start=%s end=%s), make sure crossroad breaks can be stitched to either a crossroad or another mainpath.", var_78_26, var_78_27, tostring(var_78_28:unbox()), tostring(var_78_29:unbox()))
			else
				printf("[LevelAnalysis] Break between main_path_index %d and %d seems good (start=%s end=%s).", var_78_26, var_78_27, tostring(var_78_28:unbox()), tostring(var_78_29:unbox()))
			end

			var_78_3[#var_78_3 + 1] = var_78_24
			var_78_2[var_78_22] = var_78_2[var_78_23]
			var_78_2[var_78_23] = nil
			var_78_23 = var_78_23 - 1
		else
			var_78_22 = var_78_22 + 1
		end
	end

	if #var_78_4 == 0 and #var_78_2 == 0 then
		local var_78_46 = #var_78_3

		for iter_78_1 = 1, var_78_46 do
			local var_78_47 = var_78_3[iter_78_1].astar

			var_78_15(var_78_47)

			var_78_3[iter_78_1] = nil
		end

		local var_78_48

		for iter_78_2, iter_78_3 in pairs(var_78_7) do
			if var_78_48 == nil then
				var_78_48 = "Found player path(s) between the main path indexes listed below. Either remove main path break or the path that allows the player to traverse back."
			end

			for iter_78_4, iter_78_5 in pairs(iter_78_3) do
				local var_78_49 = iter_78_5.node
				local var_78_50 = ""

				if iter_78_5.is_crossroad then
					var_78_50 = "\nNote: Breaks in this crossroad path needs to be changed to crossroad_break."
				end

				var_78_48 = string.format("%s\n%d -> %d:\t%s %s", var_78_48, iter_78_2, iter_78_4, tostring(var_78_49:unbox()), var_78_50)
			end
		end

		if var_78_8 then
			for iter_78_6 = 1, #var_78_8 do
				local var_78_51 = var_78_8[iter_78_6]

				var_78_48 = "\n" .. var_78_48 .. var_78_51
			end
		end

		printf("[LevelAnalysis] Main Path Break Check Done!")

		return true, var_78_48
	else
		return false
	end
end

function LevelAnalysis.check_splines_integrity(arg_79_0)
	print("----> Checking splines integrity START:")

	local var_79_0 = Managers.state.entity:system("ai_group_system")
	local var_79_1 = PatrolFormationSettings.storm_vermin_two_column.normal
	local var_79_2 = arg_79_0.patrol_waypoints

	for iter_79_0 = 1, #var_79_2 do
		local var_79_3 = var_79_2[iter_79_0]
		local var_79_4 = var_79_3.astar_points
		local var_79_5 = var_79_3.id
		local var_79_6 = false
		local var_79_7, var_79_8 = var_79_4[1]:unbox()

		for iter_79_1 = 2, #var_79_4 do
			local var_79_9 = var_79_4[iter_79_1]:unbox()

			if Vector3.distance_squared(var_79_7, var_79_9) > 0.01 then
				var_79_7 = var_79_9
			else
				var_79_7 = var_79_9
				var_79_6 = true

				print("SPLINE HAS FAULTY POINTS:", iter_79_1, var_79_5, var_79_7, var_79_9, Vector3.distance(var_79_7, var_79_9))
			end
		end

		if var_79_6 then
			print("Faulty spline - ", var_79_5, ", points:")

			for iter_79_2 = 1, #var_79_4 do
				print(iter_79_2, var_79_4[iter_79_2]:unbox())
			end

			print("")
		end

		local var_79_10 = var_79_0:spline_start_position(var_79_5)
		local var_79_11 = var_79_0:create_formation_data(var_79_10, var_79_1, var_79_5)
	end

	print("----> Checking splines integrity ENDS.")
end

function LevelAnalysis._add_boss_to_generated_list(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0 = false
	local var_80_1 = {}
	local var_80_2 = {}

	for iter_80_0, iter_80_1 in ipairs(arg_80_1) do
		if iter_80_1 == "event_boss" then
			var_80_0 = true
			var_80_1[#var_80_1 + 1] = iter_80_0
		else
			var_80_2[#var_80_2 + 1] = iter_80_0
		end
	end

	if var_80_0 and not arg_80_2 then
		return arg_80_1
	elseif arg_80_2 > #var_80_1 then
		local var_80_3 = #var_80_2

		for iter_80_2 = 1, var_80_3 do
			local var_80_4 = math.random(1, #var_80_2)

			if var_80_4 then
				local var_80_5 = var_80_2[var_80_4]

				if var_80_5 then
					arg_80_1[var_80_5] = "event_boss"
					var_80_0 = true

					table.swap_delete(var_80_2, var_80_4)
				end
			end
		end

		return arg_80_1
	end

	if not var_80_0 then
		arg_80_1[math.random(1, #arg_80_1)] = "event_boss"
	end

	return arg_80_1
end
