-- chunkname: @scripts/managers/conflict_director/level_analysis.lua

require("scripts/managers/conflict_director/main_path_spawning_generator")

LevelAnalysis = class(LevelAnalysis)

LevelAnalysis.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.nav_world = arg_1_1
	self.using_editor = arg_1_2
	self.cover_points_broadphase = Broadphase(40, 512)
	self.used_roaming_waypoints = {}
	self.generic_ai_node_units = {}

	local tbl = {
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
		local get_current_level_keys = Managers.mechanism:get_current_level_keys()
		local override_map_start_section = LevelSettings[get_current_level_keys].override_map_start_section

		override_map_start_section = not override_map_start_section and Managers.mechanism:game_mechanism():get_map_start_section()
		self._skip_to_map_section = override_map_start_section
	end

	self.terror_spawners = tbl
	self.boss_waypoints = {}
	self.override_spawners = {}
	self.num_override_spawners = 0

	self:set_random_seed(nil, arg_1_4)

	if not (not arg_1_3 and arg_1_2) then
		self:_setup_level_data(arg_1_3, arg_1_4)
	end
end

LevelAnalysis._setup_level_data = function (self, arg_2_1, arg_2_2)
	-- function 2
	if LevelResource.nested_level_count(arg_2_1) > 0 then
		arg_2_1 = LevelResource.nested_level_resource_name(arg_2_1, 0)
	end

	local str = arg_2_1 .. "_spawn_zones"

	if not Application.can_get("lua", str) then
		self._last_loaded_zone_package = str

		local load_spawn_zone_data = MainPathSpawningGenerator.load_spawn_zone_data(str)

		self.spawn_zone_data = load_spawn_zone_data

		local crossroads = load_spawn_zone_data.crossroads

		self.chosen_crossroads = MainPathSpawningGenerator.generate_crossroad_path_choices(crossroads, arg_2_2)
	else
		ferror("Cant get %s, make sure this is added to the \\resource_packages\\level_scripts.package file. Or have you forgotten to run generate_resource_packages.bat?", str)
	end
end

LevelAnalysis.set_random_seed = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0

	if not arg_3_1 then
		var_3_0 = arg_3_1.seed
	else
		var_3_0 = arg_3_2 or math.random_seed()
	end

	self.starting_seed = var_3_0
	self.seed = var_3_0

	print("[LevelAnalysis] set_random_seed( " .. self.starting_seed .. ")")
end

LevelAnalysis.create_checkpoint_data = function (self)
	-- function 4
	return {
		seed = self.starting_seed
	}
end

LevelAnalysis._random = function (self, ...)
	-- function 5
	local next_random, var_5_1 = Math.next_random(self.seed, ...)

	self.seed = next_random

	return var_5_1
end

LevelAnalysis._random_float_interval = function (self, arg_6_1, arg_6_2)
	-- function 6
	local next_random, var_6_1 = Math.next_random(self.seed)
	local num = arg_6_1 + (arg_6_2 - arg_6_1) * var_6_1

	self.seed = next_random

	return num
end

LevelAnalysis.destroy = function (self)
	-- function 7
	self:reset()

	if self.traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(self.navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(self.nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(self.traverse_logic)
	end

	if not self.astar_list then
		local astar_list = self.astar_list

		for i = 1, #astar_list do
			local var_7_1 = astar_list[i][1]

			GwNavAStar.destroy(var_7_1)
		end
	end

	EngineOptimized.unregister_main_path()
end

LevelAnalysis.reset = function (self)
	-- function 8
	if not self._last_loaded_zone_package then
		package.loaded[self._last_loaded_zone_package] = nil
	end
end

LevelAnalysis.set_enemy_recycler = function (self, arg_9_1)
	-- function 9
	self.enemy_recycler = arg_9_1
end

LevelAnalysis.get_start_and_finish = function (self)
	-- function 10
	return self.start, self.finish
end

LevelAnalysis.get_path_markers = function (self)
	-- function 11
	return self.path_markers
end

LevelAnalysis._add_path_marker_data = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_9, arg_12_10)
	-- function 12
	local var_12_0
	local num = #arg_12_10 + 1

	if not GwNavTraversal.get_seed_triangle(arg_12_9, arg_12_1) then
		var_12_0 = "outside"

		printf("Path marker with order %s is outside of navigation mesh (%s).", tostring(arg_12_3), tostring(arg_12_1))
	end

	for i = 1, #arg_12_10 do
		if arg_12_3 < arg_12_10[i].order then
			num = i
			var_12_0 = var_12_0 or "good"

			break
		elseif arg_12_3 == arg_12_10[i].order then
			num = i
			var_12_0 = var_12_0 or "duplicate"

			printf("Two path markers in the level has the same order: %s (%s)", tostring(arg_12_3), tostring(arg_12_1))

			break
		end
	end

	var_12_0 = var_12_0 or "good"

	table.insert(arg_12_10, num, {
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

LevelAnalysis._initialize_path_markers_from_editor = function (self, arg_13_1, arg_13_2)
	-- function 13
	local alive = Unit.alive
	local is_a = Unit.is_a
	local get_data = Unit.get_data
	local local_position = Unit.local_position
	local index_offset = Script.index_offset()
	local objects = LevelEditor.objects
	local nav_world = self.nav_world
	local flag = true

	for k, v in pairs(objects) do
		local _unit = v._unit

		if not alive(_unit) and not is_a(_unit, "units/gamemode/path_marker") then
			local var_13_9 = tonumber(Unit.get_data(_unit, "order"))
			local var_13_10 = get_data(_unit, "marker_type")
			local var_13_11 = local_position(_unit, index_offset)
			local var_13_12 = get_data(_unit, "crossroads")
			local var_13_13 = get_data(_unit, "roaming_set")
			local var_13_14 = get_data(_unit, "mutators")
			local var_13_15 = get_data(_unit, "peak")

			var_13_15 = var_13_15 or nil
			var_13_13 = var_13_13 == "" or not var_13_13 or nil
			var_13_14 = var_13_14 == "" or not var_13_14 or nil

			if not self:_add_path_marker_data(var_13_11, var_13_10, var_13_9, 1, var_13_12, var_13_13, var_13_14, var_13_15, nav_world, arg_13_1) then
				flag = false
			end
		end
	end

	return flag
end

LevelAnalysis._initialize_path_markers_from_ingame = function (self, arg_14_1, arg_14_2)
	-- function 14
	local unit_position = LevelResource.unit_position
	local unit_data = LevelResource.unit_data
	local get = DynamicData.get
	local unit_indices = LevelResource.unit_indices(arg_14_2, "units/gamemode/path_marker")
	local nav_world = self.nav_world
	local flag = true

	for i, v in ipairs(unit_indices) do
		local var_14_6 = unit_position(arg_14_2, v)
		local var_14_7 = unit_data(arg_14_2, v)
		local var_14_8 = tonumber(get(var_14_7, "order"))
		local var_14_9 = get(var_14_7, "marker_type")
		local var_14_10 = get(var_14_7, "crossroads")
		local var_14_11 = get(var_14_7, "roaming_set")
		local var_14_12 = get(var_14_7, "mutators")
		local var_14_13 = get(var_14_7, "peak")

		var_14_13 = var_14_13 or nil
		var_14_12 = var_14_12 == "" or not var_14_12 or nil
		var_14_11 = var_14_11 == "" or not var_14_11 or nil

		if not self:_add_path_marker_data(var_14_6, var_14_9, var_14_8, 1, var_14_10, var_14_11, var_14_12, var_14_13, nav_world, arg_14_1) then
			flag = false
		end
	end

	return flag
end

LevelAnalysis.generate_main_path = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not arg_15_2 then
		arg_15_2 = {}

		if not arg_15_1 then
			local level_key = Managers.state.game_mode:level_key()

			arg_15_1 = LevelSettings[level_key].level_name
		end

		if not (not arg_15_5 and not (LevelResource.nested_level_count(arg_15_1) > 0)) then
			arg_15_1 = LevelResource.nested_level_resource_name(arg_15_1, 0)
		end

		print("[LevelAnalysis] Generating main-path for level:", arg_15_1)

		if not arg_15_3 then
			if not self:_initialize_path_markers_from_editor(arg_15_2, arg_15_4) then
				return "[LevelAnalysis] Failed to initialize all path markers from editor (see Console for conflicting markers)."
			end
		elseif not self:_initialize_path_markers_from_ingame(arg_15_2, arg_15_1) then
			print("[LevelAnalysis] Failed to initialize all path markers from ingame.")
		end
	else
		print("[LevelAnalysis] path markers aready generated")
	end

	if #arg_15_2 < 2 then
		return "Missing path markers in level. Need at least 2."
	end

	table.sort(arg_15_2, function (self, arg_16_1)
		-- function 16
		return self.order < arg_16_1.order
	end)
	print("[LevelAnalysis] Path-markers:")

	local num = 1
	local num_2 = 0
	local tbl = {}
	local num_3 = 0

	for i = 1, #arg_15_2 do
		local var_15_5 = arg_15_2[i]

		printf("\tread path_marker (crossroad: %s)", var_15_5.crossroads)

		if not (not var_15_5.crossroads and var_15_5.crossroads == "") then
			local split_deprecated = string.split_deprecated(var_15_5.crossroads, ":")
			local var_15_7 = split_deprecated[1]
			local var_15_8 = tonumber(split_deprecated[2])

			fassert(var_15_8, "bad road_id")

			var_15_5.crossroads_id = var_15_7
			var_15_5.road_id = var_15_8

			local var_15_9 = tbl[var_15_7]

			if not var_15_9 then
				var_15_9 = {
					num_roads = 0,
					main_path_index = num,
					roads = {}
				}
				tbl[var_15_7] = var_15_9
				num_2 = num_2 + 1
			end

			local roads = var_15_9.roads
			local var_15_11 = var_15_9.roads[var_15_8]

			var_15_11 = var_15_11 or 0
			roads[var_15_8] = var_15_11 + 1
			var_15_9.num_roads = var_15_9.num_roads + 1
		end

		var_15_5.main_path_index = num

		if not (var_15_5.marker_type == "break" or var_15_5.marker_type ~= "crossroad_break") then
			num = num + 1
			num_3 = num_3 + 1

			if num_3 < 2 then
				return "If using breaks in main-path, then each sub-path needs at least 2 path markers. Check path marker with order -> " .. tostring(var_15_5.order)
			end

			num_3 = 0
		else
			num_3 = num_3 + 1
		end

		printf("\t\tmarker: %d,\torder: %d,\tmain_path_index: %d,\tcrossroads: %s %s", i, var_15_5.order, var_15_5.main_path_index, var_15_5.crossroads_id, var_15_5.road_id)
	end

	if num_3 < 2 then
		return "If using breaks in main-path, then each sub-path needs at least 2 path markers. Last path marker is lonely!"
	end

	self.crossroads = tbl
	self.num_crossroads = num_2
	self.path_markers = arg_15_2
	self.start = arg_15_2[1].pos
	self.finish = arg_15_2[#arg_15_2].pos

	self:start_main_path_generation(num)

	return "success", arg_15_2
end

LevelAnalysis.start_main_path_generation = function (self, arg_17_1)
	-- function 17
	print("[LevelAnalysis] start_main_path_generation")

	self.stitching_path = true

	local nav_world = self.nav_world
	local path_markers = self.path_markers

	self.astar_list = {}
	self.main_paths = {}

	local tbl = {
		bot_ladders = 20,
		ledges_with_fence = 20,
		jumps = 20,
		ledges = 20,
		bot_jumps = 20,
		bot_drops = 20
	}
	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table)

	self.nav_cost_map_cost_table = create_tag_cost_table

	local var_17_4 = GwNavTraverseLogic.create(nav_world, create_tag_cost_table)

	self.traverse_logic = var_17_4
	self.navtag_layer_cost_table = GwNavTagLayerCostTable.create()

	self:initialize_cost_table(self.navtag_layer_cost_table, tbl)
	GwNavTraverseLogic.set_navtag_layer_cost_table(var_17_4, self.navtag_layer_cost_table)

	local num = 1
	local num_2 = 1

	for i = 1, #path_markers - 1 do
		local unbox = path_markers[i].pos:unbox()
		local unbox_2 = path_markers[i + 1].pos:unbox()

		if not (path_markers[i].marker_type == "break" or path_markers[i].marker_type ~= "crossroad_break") then
			num_2 = 1
		else
			self.astar_list[num] = {
				GwNavAStar.create(),
				num_2,
				path_markers[i].main_path_index,
				i
			}

			GwNavAStar.start(self.astar_list[num][1], nav_world, unbox, unbox_2, var_17_4)

			num = num + 1
			num_2 = num_2 + 1
		end
	end

	for j = 1, arg_17_1 do
		self.main_paths[j] = {
			path_length = 0,
			nodes = {},
			astar_paths = {},
			path_markers = {}
		}
	end

	printf("[LevelAnalysis] main path generation - found %d main paths, total of %d sub-paths.", arg_17_1, #self.astar_list)
end

LevelAnalysis.initialize_cost_table = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	for i, v in ipairs(LAYER_ID_MAPPING) do
		local var_18_0 = arg_18_2[v]

		if not var_18_0 then
			if var_18_0 == 0 then
				GwNavTagLayerCostTable.forbid_layer(arg_18_1, i)
			else
				GwNavTagLayerCostTable.allow_layer(arg_18_1, i)
				GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_18_1, i, var_18_0)
			end
		end
	end
end

LevelAnalysis.boxify_pos_array = function (self)
	-- function 19
	for i = 1, #self do
		self[i] = Vector3Box(self[i])
	end
end

LevelAnalysis.boxify_table_pos_array = function (self)
	-- function 20
	local tbl = {}

	for i = 1, #self do
		local var_20_1 = self[i]

		tbl[i] = Vector3Box(var_20_1[1], var_20_1[2], var_20_1[3])
	end

	return tbl
end

LevelAnalysis.update_main_path_generation = function (self)
	-- function 21
	local processing_finished = GwNavAStar.processing_finished
	local path_found = GwNavAStar.path_found
	local node_count = GwNavAStar.node_count
	local node_at_index = GwNavAStar.node_at_index
	local path_cost = GwNavAStar.path_cost
	local path_distance = GwNavAStar.path_distance
	local destroy = GwNavAStar.destroy
	local astar_list = self.astar_list
	local count = #astar_list
	local main_paths = self.main_paths
	local num = 1

	while num <= count do
		local var_21_11 = astar_list[num][1]

		if not processing_finished(var_21_11) then
			if not path_found(var_21_11) then
				local var_21_12 = node_count(var_21_11)

				print("[LevelAnalysis] Found path! node-count:", var_21_12)

				local tbl = {}

				for i = 1, var_21_12 do
					tbl[i] = node_at_index(var_21_11, i)
				end

				LevelAnalysis.boxify_pos_array(tbl)

				local var_21_14 = path_cost(var_21_11)
				local var_21_15 = path_distance(var_21_11)
				local var_21_16 = astar_list[num][3]
				local var_21_17 = main_paths[var_21_16]
				local var_21_18 = astar_list[num][2]
				local var_21_19 = astar_list[num][4]

				var_21_17.astar_paths[var_21_18] = {
					var_21_15,
					var_21_14,
					tbl,
					var_21_16,
					var_21_19
				}

				destroy(var_21_11)

				astar_list[num] = astar_list[count]
				astar_list[count] = nil
				count = count - 1

				if count == 0 then
					print("[LevelAnalysis] main path generation - all sub paths generated")

					local num_2 = 0

					for j = 1, #main_paths do
						local var_21_21 = main_paths[j]
						local astar_paths = var_21_21.astar_paths
						local nodes = var_21_21.nodes

						for k = 1, #astar_paths do
							local var_21_24 = astar_paths[k]
							local var_21_25 = var_21_24[1]
							local var_21_26 = var_21_24[3]
							local num_3 = #nodes + 1
							local var_21_28 = num_3

							for l = 1, #var_21_26 - 1 do
								nodes[num_3] = var_21_26[l]
								num_3 = num_3 + 1
							end

							var_21_21.path_length = var_21_21.path_length + var_21_25

							local var_21_29 = var_21_24[5]
							local var_21_30 = self.path_markers[var_21_29]

							var_21_21.path_markers[var_21_28] = var_21_30

							local crossroads_id = var_21_30.crossroads_id

							if not crossroads_id then
								fassert(not var_21_21.crossroads_id and var_21_21.crossroads_id == crossroads_id, "If using crossroads, all path-markers in the same main-path must be have the same crossroads id")

								var_21_21.crossroads_id = crossroads_id
								var_21_21.road_id = var_21_30.road_id
							end
						end

						var_21_21.dist_from_start = num_2
						num_2 = num_2 + var_21_21.path_length

						local var_21_32 = astar_paths[#astar_paths][3]

						nodes[#nodes + 1] = var_21_32[#var_21_32]
					end

					self.total_main_path_length = num_2

					MainPathSpawningGenerator.inject_travel_dists(main_paths)

					self.stitching_path = false
					self.boss_event_list = {}

					if not (not CurrentBossSettings and CurrentBossSettings.disabled or self.using_editor) then
						self:generate_boss_paths()
					end

					return "done"
				end
			else
				local var_21_33 = astar_list[num][4]
				local order = self.path_markers[var_21_33].order
				local format = string.format("[LevelAnalysis] Level fail: No path found between path-markers with order %s and the next. Cannot create main path. No bosses will spawn.", tostring(order))

				if not Debug then
					Debug.sticky_text(format, "delay", 20)
				end

				print(format)

				self.stitching_path = false

				return "fail", format
			end
		else
			num = num + 1
		end
	end
end

LevelAnalysis.calc_dists_to_start = function (self)
	-- function 22
	local main_paths = self.main_paths
	local num = 0

	for i = 1, #main_paths do
		local var_22_2 = main_paths[i]

		var_22_2.dist_from_start = num
		num = num + var_22_2.path_length
	end

	return num
end

LevelAnalysis.boss_gizmo_spawned = function (self, arg_23_1)
	-- function 23
	local get_data = Unit.get_data(arg_23_1, "travel_dist")
	local var_23_1 = tonumber(Unit.get_data(arg_23_1, "map_section"))

	if not (not self._skip_to_map_section and not (var_23_1 < self._skip_to_map_section)) then
		return
	end

	local override_spawners = self.override_spawners
	local get_data_2 = Unit.get_data(arg_23_1, "event_encampment")

	if not (not get_data_2 and not (get_data_2 > 0)) then
		local var_23_4 = override_spawners[var_23_1]

		if not var_23_4 then
			var_23_4 = {}
			override_spawners[var_23_1] = var_23_4
		end

		if not EncampmentTemplates[get_data_2] then
			var_23_4[#var_23_4 + 1] = {
				arg_23_1,
				get_data,
				var_23_1,
				get_data_2
			}
			self.num_override_spawners = self.num_override_spawners + 1
		end
	end

	local terror_spawners = self.terror_spawners

	for k, v in pairs(terror_spawners) do
		if not Unit.get_data(arg_23_1, k) then
			local spawners = v.spawners

			spawners[#spawners + 1] = {
				arg_23_1,
				get_data,
				var_23_1
			}
		end
	end
end

LevelAnalysis.generic_ai_node_spawned = function (self, arg_24_1)
	-- function 24
	local generic_ai_node_units = self.generic_ai_node_units
	local get_data = Unit.get_data(arg_24_1, "id")
	local var_24_2 = generic_ai_node_units[get_data]

	if not var_24_2 then
		var_24_2 = {}
		generic_ai_node_units[get_data] = var_24_2
	end

	var_24_2[#var_24_2 + 1] = arg_24_1
end

LevelAnalysis.group_spawners = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	table.sort(arg_25_1, function (self, arg_26_1)
		-- function 26
		return self[3] < arg_26_1[3]
	end)

	local num = 0
	local tbl = {}

	for i = 1, #arg_25_1 do
		local var_25_2 = arg_25_1[i]
		local var_25_3 = var_25_2[1]
		local var_25_4 = var_25_2[2]
		local var_25_5 = var_25_2[3]
		local var_25_6 = var_25_2[4]

		if var_25_5 ~= num then
			if num < var_25_5 then
				arg_25_2[var_25_5] = i
			elseif var_25_5 < num then
				-- Nothing
			end
		end

		num = var_25_5
	end

	arg_25_2[num + 1] = #arg_25_1 + 1

	local var_25_7 = num

	for j = 1, var_25_7 do
		if not arg_25_2[j] then
			for k = j + 1, var_25_7 do
				local var_25_8 = arg_25_2[k]

				if not (not var_25_8 and arg_25_2[j]) then
					arg_25_2[j] = var_25_8
				end
			end

			for l = j - 1, 1, -1 do
				local var_25_9 = arg_25_2[l]

				if not (not var_25_9 and arg_25_2[j]) then
					arg_25_2[j] = var_25_9
				end
			end
		end
	end

	for i4 = 1, var_25_7 do
		local var_25_10 = arg_25_2[i4]

		if not var_25_10 then
			table.dump(arg_25_2, "LEVEL_SECTIONS ERROR-----------------------", 3)
			error()
		end

		local var_25_11 = arg_25_1[var_25_10][1]
		local local_position = Unit.local_position(var_25_11, 0)
		local closest_pos_at_main_path, var_25_14, var_25_15, var_25_16, var_25_17 = MainPathUtils.closest_pos_at_main_path(nil, local_position)
		local get_zone_segment_from_travel_dist, var_25_19, var_25_20 = Managers.state.conflict.spawn_zone_baker:get_zone_segment_from_travel_dist(var_25_14)

		tbl[i4] = var_25_20.conflict_setting
	end

	return var_25_7, tbl
end

LevelAnalysis.boxify_waypoint_table = function (arg_27_0, arg_27_1)
	-- function 27
	local tbl = {}

	for i = 1, #arg_27_1 do
		local var_27_1 = arg_27_1[i]

		tbl[i] = Vector3Box(var_27_1[1], var_27_1[2], var_27_1[3])
	end

	return tbl
end

LevelAnalysis.print_boss_waypoints = function (self)
	-- function 28
	local boss_waypoints = self.boss_waypoints

	for i = 1, #boss_waypoints do
		local var_28_1 = boss_waypoints[i]

		print("Section:", i)

		for j = 1, #var_28_1 do
			local var_28_2 = var_28_1[j]

			print(string.format("BossWaypoint section: %q, #wp %q travel-dist: %.1f", i, j, var_28_2.travel_dist))
		end
	end
end

LevelAnalysis.get_boss_spline_travel_distance = function (arg_29_0, arg_29_1)
	-- function 29
	local var_29_0

	if not arg_29_1.main_path_connector then
		local main_path_connector = arg_29_1.main_path_connector
		local var_29_2 = Vector3(main_path_connector[1], main_path_connector[2], main_path_connector[3])
		local closest_pos_at_main_path, var_29_4 = MainPathUtils.closest_pos_at_main_path(nil, var_29_2)

		var_29_0 = var_29_4

		print("MAIN PATH CONNECTOR ", var_29_0)
	else
		local var_29_5 = arg_29_1.waypoints[1]
		local var_29_6 = Vector3(var_29_5[1], var_29_5[2], var_29_5[3])
		local closest_pos_at_main_path_2, var_29_8 = MainPathUtils.closest_pos_at_main_path(nil, var_29_6)

		var_29_0 = var_29_8

		print("NORMAL PATROL MAIN PATH ", var_29_0)
	end

	table.dump(arg_29_1)

	return var_29_0
end

LevelAnalysis.get_possible_events = function (self)
	-- function 30
	local tbl = {}
	local boss_waypoints = self.boss_waypoints

	for i, v in ipairs(boss_waypoints) do
		for i_2, v_2 in ipairs(v) do
			local get_boss_spline_travel_distance = self:get_boss_spline_travel_distance(v_2)

			tbl[#tbl + 1] = {
				kind = "event_patrol",
				travel_dist = get_boss_spline_travel_distance,
				waypoints_table = v_2
			}
		end
	end

	local spawners = self.terror_spawners.event_boss.spawners

	for i_3, v_3 in ipairs(spawners) do
		local local_position = Unit.local_position(v_3[1], 0)
		local closest_pos_at_main_path, var_30_6, var_30_7, var_30_8, var_30_9 = MainPathUtils.closest_pos_at_main_path(nil, local_position)

		tbl[#tbl + 1] = {
			kind = "event_boss",
			travel_dist = var_30_6,
			spawner = v_3
		}
	end

	table.sort(tbl, function (self, arg_31_1)
		-- function 31
		return self.travel_dist < arg_31_1.travel_dist
	end)

	return tbl
end

LevelAnalysis.pick_boss_spline = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local boss_waypoints = self.boss_waypoints

	if not boss_waypoints then
		return false, "no boss waypoints table, you need to regenerate boss waypoints in editor!"
	end

	local var_32_1 = boss_waypoints[arg_32_1]

	if not var_32_1 then
		return false, string.format("no section waypoints for section %d - You need to add boss waypoints or set boss_spawning_method to nil in level_settings. Or set boss_events = { max_events_of_this_kind = { event_patrol = 0 }, } in level settings.", arg_32_1)
	end

	local travel_dist = var_32_1[1].travel_dist
	local num = arg_32_3 + arg_32_2

	num = not (travel_dist < num) or not num or travel_dist

	local var_32_4

	for i = 1, #var_32_1 do
		if num <= var_32_1[i].travel_dist then
			var_32_4 = i

			break
		end
	end

	local var_32_5

	if not var_32_4 then
		printf("[LevelAnalysis] waypoint is too close to the last section's waypoint (map section=%d) -> using fallback (last waypoint in section)", arg_32_1)

		var_32_4 = #var_32_1
	end

	local var_32_6 = var_32_1[self:_random(var_32_4, #var_32_1)]
	local boxify_waypoint_table = self:boxify_waypoint_table(var_32_6.waypoints)
	local tbl = {
		spline_type = "patrol",
		event_kind = "event_spline_patrol",
		spline_id = var_32_6.id,
		spline_way_points = boxify_waypoint_table,
		one_directional = var_32_6.one_directional
	}
	local get_boss_spline_travel_distance = self:get_boss_spline_travel_distance(var_32_6)

	return true, var_32_5, boxify_waypoint_table[1], tbl, get_boss_spline_travel_distance
end

LevelAnalysis.spawn_all_boss_spline_patrols = function (self, arg_33_1)
	-- function 33
	local boss_waypoints = self.boss_waypoints

	if not boss_waypoints then
		print("No boss_waypoints found in level!")

		return false
	end

	print("SPAWN BOSS SPLINES")

	for i = 1, #boss_waypoints do
		local var_33_1 = boss_waypoints[i]

		for j = 1, #var_33_1 do
			local var_33_2 = var_33_1[j]

			if not (not arg_33_1 and var_33_2.id ~= arg_33_1) then
				local boxify_waypoint_table = self:boxify_waypoint_table(var_33_2.waypoints)
				local tbl = {
					spline_type = "patrol",
					event_kind = "event_spline_patrol",
					spline_id = var_33_2.id,
					spline_way_points = boxify_waypoint_table
				}

				self.enemy_recycler:add_main_path_terror_event(boxify_waypoint_table[1], "boss_event_spline_patrol", 45, tbl)
				print("INJECTING BOSS SPLINE ID", var_33_2.id)

				local unbox = boxify_waypoint_table[1]:unbox()
				local closest_pos_at_main_path, var_33_7, var_33_8, var_33_9, var_33_10 = MainPathUtils.closest_pos_at_main_path(nil, unbox)
				local point_on_mainpath, var_33_12 = MainPathUtils.point_on_mainpath(nil, var_33_7 - 45)

				QuickDrawerStay:line(unbox, unbox + Vector3(0, 0, 15), Color(125, 255, 0))
				QuickDrawerStay:sphere(unbox, 5, Colors.get("purple"))
				QuickDrawerStay:line(unbox, point_on_mainpath, Color(125, 255, 0))
				QuickDrawerStay:sphere(point_on_mainpath, 5, Colors.get("pink"))
			end
		end
	end
end

LevelAnalysis.inject_all_bosses_into_main_path = function (self)
	-- function 34
	if not self.boss_waypoints then
		return false
	end

	print("SPAWN BOSS SPLINES")

	local str = "event_boss"
	local spawners = self.terror_spawners[str].spawners

	table.clear(self.enemy_recycler.main_path_events)

	for i = 1, #spawners do
		local var_34_2 = spawners[i]
		local local_position = Unit.local_position(var_34_2[1], 0)
		local var_34_4 = Vector3Box(local_position)
		local tbl = {
			event_kind = "event_boss"
		}

		self.enemy_recycler:add_main_path_terror_event(var_34_4, "boss_event_rat_ogre", 45, tbl)

		local closest_pos_at_main_path, var_34_7, var_34_8, var_34_9, var_34_10 = MainPathUtils.closest_pos_at_main_path(nil, var_34_4:unbox())
		local point_on_mainpath, var_34_12 = MainPathUtils.point_on_mainpath(nil, var_34_7 - 45)

		QuickDrawerStay:line(local_position, local_position + Vector3(0, 0, 15), Color(125, 255, 0))
		QuickDrawerStay:sphere(local_position, 5, Colors.get("purple"))
		QuickDrawerStay:line(local_position, point_on_mainpath, Color(125, 255, 0))
		QuickDrawerStay:sphere(point_on_mainpath, 5, Colors.get("pink"))
	end

	self.enemy_recycler.current_main_path_event_id = 1

	local var_34_13 = self.enemy_recycler.main_path_events[1][1]

	self.enemy_recycler.current_main_path_event_activation_dist = var_34_13
end

LevelAnalysis.inject_playable_boss_into_main_path = function (self)
	-- function 35
	if not self.boss_waypoints then
		return false
	end

	print("SPAWN BOSS SPLINES")

	local str = "event_boss"
	local spawners = self.terror_spawners[str].spawners

	table.clear(self.enemy_recycler.main_path_events)

	for i = 1, #spawners do
		local var_35_2 = spawners[i]
		local local_position = Unit.local_position(var_35_2[1], 0)
		local var_35_4 = Vector3Box(local_position)
		local tbl = {
			event_kind = "event_boss"
		}

		self.enemy_recycler:add_main_path_terror_event(var_35_4, "playable_boss_rat_ogre", 45, tbl)

		local closest_pos_at_main_path, var_35_7, var_35_8, var_35_9, var_35_10 = MainPathUtils.closest_pos_at_main_path(nil, var_35_4:unbox())
		local point_on_mainpath, var_35_12 = MainPathUtils.point_on_mainpath(nil, var_35_7 - 45)

		QuickDrawerStay:line(local_position, local_position + Vector3(0, 0, 15), Color(125, 255, 0))
		QuickDrawerStay:sphere(local_position, 5, Colors.get("purple"))
		QuickDrawerStay:line(local_position, point_on_mainpath, Color(125, 255, 0))
		QuickDrawerStay:sphere(point_on_mainpath, 5, Colors.get("pink"))
	end

	self.enemy_recycler.current_main_path_event_id = 1

	local var_35_13 = self.enemy_recycler.main_path_events[1][1]

	self.enemy_recycler.current_main_path_event_activation_dist = var_35_13
end

LevelAnalysis._give_events = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	-- function 36
	local num = 0
	local num_2 = 10
	local var_36_2
	local var_36_3
	local _skip_to_map_section = self._skip_to_map_section

	_skip_to_map_section = _skip_to_map_section or 1

	for i = _skip_to_map_section, #arg_36_5 do
		local var_36_5
		local var_36_6
		local var_36_7
		local var_36_8 = arg_36_3[i]
		local var_36_9
		local var_36_10
		local var_36_11 = arg_36_5[i].boss[arg_36_6]

		if not (var_36_8 == "event_boss" or var_36_8 ~= "event_patrol") then
			local var_36_12 = var_36_11.event_lookup[var_36_8]

			var_36_9 = var_36_12[self:_random(#var_36_12)]

			local var_36_13
			local var_36_14
			local var_36_15

			if var_36_8 == "event_patrol" then
				local pick_boss_spline, var_36_17, var_36_18

				pick_boss_spline, var_36_17, var_36_5, var_36_7, var_36_18 = self:pick_boss_spline(i, num_2, num)

				fassert(pick_boss_spline, "[LevelAnalysis] Failed finding patrol spline! [reason=%s]", var_36_17)
				print(" ----> using boss spline path!")

				num = var_36_18
				var_36_10 = var_36_18
			else
				local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("playable_boss_terror_events")

				if not mechanism_setting_for_title then
					local alloc_table = FrameTable.alloc_table()

					for k, v in pairs(mechanism_setting_for_title) do
						if not PlayerUtils.get_career_override(k) then
							table.append(alloc_table, v)
						end
					end

					if not table.is_empty(alloc_table) then
						var_36_9 = table.random(alloc_table)
					end
				end

				print(" ----> using boss gizmo!")

				local var_36_21 = arg_36_2[var_36_8]
				local level_sections = var_36_21.level_sections
				local spawners = var_36_21.spawners
				local var_36_24 = level_sections[i]
				local num_3 = level_sections[i + 1] - 1

				fassert(var_36_24 <= num_3, "Level Error: Too few boss-gizmo spawners of type '%s' in section %d: start-index: %d, end-index: %d,", var_36_8, i, tostring(var_36_24), tostring(num_3))

				local var_36_26 = spawners[var_36_24][2]
				local var_36_27 = spawners[num_3][2]
				local num_4 = num_2 - (var_36_26 - num)

				print(string.format("[LevelAnalysis] section: %d, start-index: %d, end-index: %d, forbidden-dist: %.1f start-travel-dist: %.1f, end-travel-dist: %.1f spawn_distance %.1f", i, var_36_24, num_3, num_4, var_36_26, var_36_27, num))

				if num_4 > 0 then
					local num_5 = var_36_26 + num_4
					local var_36_30

					for l = var_36_24, num_3 do
						local var_36_31 = spawners[l][2]

						if num_5 <= var_36_31 then
							var_36_30 = l

							break
						else
							print("[LevelAnalysis] \t\t--> since forbidden dist, skipping spawner ", l, " at distance,", var_36_31)
						end
					end

					if not var_36_30 then
						print("[LevelAnalysis] \t\t--> found new spawner ", var_36_30, " at distance,", spawners[var_36_30][2], " passing forbidden dist:", num_5)

						var_36_24 = var_36_30
					else
						print(string.format("[LevelAnalysis] failed to find spawner - too few spawners in section %d, forbidden-dist %.1f from: %.1f to: %.1f", i, num_4, num_5, var_36_27))
						print("[LevelAnalysis] \t\t--> fallback -> using main-path spawning for section", i, num_5, var_36_27)

						local _random_float_interval = self:_random_float_interval(num_5, var_36_27)
						local point_on_mainpath = MainPathUtils.point_on_mainpath(arg_36_1, _random_float_interval)

						if not point_on_mainpath then
							num = _random_float_interval
							var_36_5 = Vector3Box(point_on_mainpath)
							var_36_7 = {
								event_kind = var_36_8
							}
						else
							print("[LevelAnalysis] \t\t--> fallback 2 -> pick any spawner in segment (MIGHT GET BOSSES VERY CLOSE TO EACHOTHER)", i)

							var_36_24 = level_sections[i]
						end
					end
				end

				if not var_36_5 then
					local var_36_34 = spawners[self:_random(var_36_24, num_3)]
					local local_position = Unit.local_position(var_36_34[1], 0)

					var_36_5 = Vector3Box(local_position)

					local var_36_36 = var_36_34[1]

					num = var_36_34[2]
					var_36_7 = {
						gizmo_unit = var_36_36,
						event_kind = var_36_8
					}
				end
			end
		elseif var_36_8 == "encampment" then
			var_36_9 = "boss_event_encampment"

			print("pick section:", i)

			local var_36_37 = self.override_spawners[i]
			local var_36_38 = var_36_37[self:_random(1, #var_36_37)]
			local var_36_39 = var_36_38[1]
			local var_36_40 = var_36_38[4]
			local var_36_41 = EncampmentTemplates[var_36_40]

			var_36_5 = Vector3Box(Unit.local_position(var_36_39, 0))
			num = var_36_38[2]

			local _random = self:_random(1, #var_36_41.unit_compositions)

			var_36_7 = {
				encampment_id = var_36_40,
				unit_compositions_id = _random,
				gizmo_unit = var_36_39,
				event_kind = var_36_8
			}
		else
			var_36_9 = "nothing"

			local event_boss = arg_36_2.event_boss
			local level_sections_2 = event_boss.level_sections
			local spawners_2 = event_boss.spawners
			local var_36_46 = level_sections_2[i]
			local num_6 = level_sections_2[i + 1] - 1
			local floor = math.floor((var_36_46 + num_6) / 2)
			local var_36_49 = spawners_2[math.clamp(floor, var_36_46, level_sections_2[i + 1])]

			var_36_5 = Vector3Box(Unit.local_position(var_36_49[1], 0))

			local var_36_50 = var_36_49[1]

			num = var_36_49[2]
		end

		if var_36_8 ~= "nothing" then
			if not var_36_11.terror_events_using_packs then
				self.enemy_recycler:add_terror_event_in_area(var_36_5, var_36_9, var_36_7)
			else
				local flag = var_36_8 ~= "event_boss" or Managers.mechanism:mechanism_setting_for_title("override_boss_activation_distance") or 45
				local var_36_52

				if not var_36_10 then
					var_36_52 = var_36_10 - flag
				end

				self.enemy_recycler:add_main_path_terror_event(var_36_5, var_36_9, flag, var_36_7, var_36_52)
			end
		end

		local debug_color

		if not var_36_11 then
			debug_color = var_36_11.debug_color

			if not debug_color then
				-- Nothing
			end
		end

		debug_color = "deep_pink"

		::label_36_0::

		arg_36_4[#arg_36_4 + 1] = {
			var_36_5,
			var_36_9,
			num,
			debug_color
		}
	end
end

LevelAnalysis._override_generated_event_list = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local override_spawners = self.override_spawners

	if self.num_override_spawners <= 0 then
		return
	end

	local tbl = {}

	for i = 1, #arg_37_2 do
		local chance_of_encampment = arg_37_2[i].boss[arg_37_3].chance_of_encampment

		if not (not override_spawners[i] and not (chance_of_encampment > self:_random())) then
			tbl[#tbl + 1] = i
		end
	end

	if #tbl <= 0 then
		return
	end

	local var_37_3 = tbl[self:_random(1, #tbl)]

	print("[LevelAnalysis] Overriding section ", var_37_3, " with an encampment")

	arg_37_1[var_37_3] = "encampment"
end

LevelAnalysis._generate_event_name_list = function (self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	print("[LevelAnalysis] Terror events added:")

	local tbl = {}
	local tbl_2 = {}
	local num = -1

	for i = 1, #arg_38_1 do
		local boss = arg_38_1[i].boss

		if not boss.disabled then
			tbl[i] = "nothing"
		else
			local events = boss[arg_38_3].events
			local count = #events
			local _random = self:_random(1, count)

			while not (_random ~= num or not (count >= 2)) do
				_random = self:_random(1, count)
			end

			local var_38_7 = events[_random]
			local var_38_8 = tbl_2[var_38_7]

			if not var_38_8 then
				var_38_8 = var_38_8 + 1
			else
				var_38_8 = 1
			end

			tbl_2[var_38_7] = var_38_8

			if not arg_38_2 then
				local var_38_9 = arg_38_2[var_38_7]

				if not (not var_38_9 and not (var_38_9 < var_38_8)) then
					var_38_7 = "nothing"
				end
			end

			tbl[i] = var_38_7

			if var_38_7 == events[_random] then
				printf("[LevelAnalysis] %d -->Added boss/special event: %s", i, var_38_7)
			else
				printf("[LevelAnalysis] %d\t-->Added boss/special event: %s (, %s -> removed due to too many.)", i, var_38_7, events[_random])
			end

			num = _random
		end
	end

	return tbl
end

LevelAnalysis._hand_placed_terror_creation = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local var_39_0
	local var_39_1
	local terror_spawners = self.terror_spawners
	local var_39_3
	local var_39_4

	for k, v in pairs(terror_spawners) do
		print("[LevelAnalysis] grouping spawners for ", k)

		local group_spawners

		group_spawners, var_39_1 = self:group_spawners(v.spawners, v.level_sections)

		if not (not var_39_3 and group_spawners == var_39_3) then
			error("Not all sectors has boss event gizmos in level for  " .. (not (group_spawners < var_39_3) or not k or var_39_4))
		end

		var_39_3 = group_spawners
		var_39_4 = k

		print("[LevelAnalysis] ")
	end

	local var_39_6 = self.level_settings[arg_39_3]
	local max_events_of_this_kind

	if not var_39_6 then
		max_events_of_this_kind = var_39_6.max_events_of_this_kind

		if not max_events_of_this_kind then
			-- Nothing
		end
	end

	max_events_of_this_kind = {
		event_boss = 2
	}

	::label_39_0::

	local _generate_event_name_list = self:_generate_event_name_list(var_39_1, max_events_of_this_kind, arg_39_3)

	self:_override_generated_event_list(_generate_event_name_list, var_39_1, arg_39_3)

	local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("always_spawn_a_boss")
	local mechanism_setting_for_title_2 = Managers.mechanism:mechanism_setting_for_title("num_bosses_to_spawn")
	local mechanism_setting_for_title_3 = Managers.mechanism:mechanism_setting_for_title("spawn_boss_every_section")

	if mechanism_setting_for_title or not mechanism_setting_for_title_2 then
		_generate_event_name_list = self:_add_boss_to_generated_list(_generate_event_name_list, mechanism_setting_for_title_2)
	end

	if not mechanism_setting_for_title_3 then
		for i, v_2 in ipairs(_generate_event_name_list) do
			_generate_event_name_list[i] = "event_boss"
		end
	end

	self:_give_events(arg_39_1, self.terror_spawners, _generate_event_name_list, arg_39_2, var_39_1, arg_39_3)
end

LevelAnalysis._automatic_terror_creation = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	-- function 40
	arg_40_3[#arg_40_3 + 1] = {
		Vector3Box(0, 0, 0),
		"safe-dist",
		arg_40_6,
		"deep_pink"
	}

	local var_40_0 = arg_40_2
	local num = (var_40_0 - arg_40_6) / arg_40_5
	local floor = math.floor(num)
	local num_2 = num % 1
	local flag

	flag = not (num_2 >= self:_random()) or not 1 or 0

	local num_3 = floor + flag

	print("[LevelAnalysis] num_event_places_f:", num, ", num_event_places:", floor, ", trailing_event_fraction:", num_2, ", num_events:", num_3)
	print("[LevelAnalysis] Level path distance:", var_40_0)

	if num_3 <= 0 then
		return
	end

	local num_4 = 100
	local num_5 = 0
	local tbl = {}
	local tbl_2 = {}
	local var_40_10
	local var_40_11 = arg_40_6

	for i = 1, num_3 do
		local var_40_12 = var_40_11

		var_40_11 = var_40_12 + arg_40_5
		var_40_11 = math.clamp(var_40_11, 0, var_40_0)

		local num_6 = num_4 - (var_40_11 - num_5)

		print("[LevelAnalysis] path_dist1:", var_40_12, ", path_dist2:", var_40_11, " forbidden_dist:", num_6)

		if num_6 > 0 then
			var_40_12 = var_40_12 + num_6
		end

		if var_40_11 < var_40_12 then
			print("[LevelAnalysis] skipping event - not enough space left in this segment")

			break
		end

		var_40_11 = math.clamp(var_40_11, 0, var_40_0)

		local _random_float_interval = self:_random_float_interval(var_40_12, var_40_11)

		print("[LevelAnalysis] wanted_distance:", _random_float_interval)

		tbl[i] = _random_float_interval
		num_5 = _random_float_interval

		local get_zone_segment_from_travel_dist, var_40_16, var_40_17 = Managers.state.conflict.spawn_zone_baker:get_zone_segment_from_travel_dist(_random_float_interval)

		tbl_2[i] = var_40_17.conflict_setting
	end

	local var_40_18 = self.level_settings[arg_40_4]
	local max_events_of_this_kind

	if not var_40_18 then
		max_events_of_this_kind = var_40_18.max_events_of_this_kind

		if not max_events_of_this_kind then
			-- Nothing
		end
	end

	max_events_of_this_kind = {
		event_boss = 2
	}

	::label_40_0::

	local _generate_event_name_list = self:_generate_event_name_list(tbl_2, max_events_of_this_kind, arg_40_4)

	for j = 1, #_generate_event_name_list do
		local var_40_21 = tbl[j]
		local point_on_mainpath = MainPathUtils.point_on_mainpath(arg_40_1, var_40_21)
		local var_40_23 = Vector3Box(point_on_mainpath)
		local str = "nothing"
		local var_40_25 = _generate_event_name_list[j]
		local str_2 = "deep_pink"

		if var_40_25 ~= "nothing" then
			local var_40_27 = tbl_2[j].boss[arg_40_4]

			str_2 = var_40_27.debug_color

			local tbl_3 = {}
			local var_40_29 = var_40_27.event_lookup[var_40_25]

			str = var_40_29[self:_random(#var_40_29)]

			if not var_40_27.terror_events_using_packs then
				self.enemy_recycler:add_terror_event_in_area(var_40_23, str, tbl_3)
			else
				self.enemy_recycler:add_main_path_terror_event(var_40_23, str, 45, tbl_3)
			end
		end

		arg_40_3[#arg_40_3 + 1] = {
			var_40_23,
			str,
			var_40_21,
			str_2
		}
	end
end

LevelAnalysis.debug_spawn_boss_from_closest_spawner_to_player = function (self, arg_41_1)
	-- function 41
	local var_41_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS[1]
	local huge = math.huge
	local var_41_2
	local saved_terror_spawners = self.saved_terror_spawners

	if not saved_terror_spawners then
		print("debug_spawn_boss_from_closest_spawner_to_player - no spawners found")

		return
	end

	print("debug_spawn_boss_from_closest_spawner_to_player")

	local spawners = saved_terror_spawners.event_boss.spawners

	for i = 1, #spawners do
		local var_41_5 = spawners[i]
		local local_position = Unit.local_position(var_41_5[1], 0)
		local distance = Vector3.distance(var_41_0, local_position)

		if distance < huge then
			huge = distance
			var_41_2 = local_position
		end

		QuickDrawer:sphere(local_position, 1.5, Color(100, 200, 10))
	end

	if not var_41_2 then
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

LevelAnalysis.generate_boss_paths = function (self)
	-- function 42
	self.boss_event_list = {}
	self.total_main_path_dist = self:calc_dists_to_start()

	local level_settings = self.level_settings

	printf("[LevelAnalysis] Generating boss paths for level: %s", level_settings.level_id)
	printf("[LevelAnalysis] This level has a total main-path length of %.3f meters.", self.total_main_path_dist)

	local boss_spawning_method = level_settings.boss_spawning_method

	if boss_spawning_method == "hand_placed" then
		self:_hand_placed_terror_creation(self.main_paths, self.boss_event_list, "boss_events")
	elseif boss_spawning_method == "bypassed" then
		-- Nothing
	else
		local boss_events = level_settings.boss_events
		local recurring_distance

		if not boss_events then
			recurring_distance = boss_events.recurring_distance

			if not recurring_distance then
				-- Nothing
			end
		end

		recurring_distance = 300

		do
			local safe_dist
		end

		::label_42_0::

		if not boss_events then
			safe_dist = boss_events.safe_dist

			if not safe_dist then
				-- Nothing
			end
		end

		safe_dist = 150

		::label_42_1::

		self:_automatic_terror_creation(self.main_paths, self.total_main_path_dist, self.boss_event_list, "boss_events", recurring_distance, safe_dist)
	end

	local rare_events = level_settings.rare_events

	if not (not rare_events and not rare_events and rare_events.disabled) then
		local recurring_distance_2

		if not rare_events then
			recurring_distance_2 = rare_events.recurring_distance

			if not recurring_distance_2 then
				-- Nothing
			end
		end

		recurring_distance_2 = 1500

		do
			local safe_dist_2
		end

		::label_42_2::

		if not rare_events then
			safe_dist_2 = rare_events.safe_dist

			if not safe_dist_2 then
				-- Nothing
			end
		end

		safe_dist_2 = 50

		::label_42_3::

		self:_automatic_terror_creation(self.main_paths, self.total_main_path_dist, self.boss_event_list, "rare_events", recurring_distance_2, safe_dist_2)
	end
end

LevelAnalysis.get_main_paths = function (self)
	-- function 43
	return self.main_paths
end

LevelAnalysis.get_crossroads = function (self)
	-- function 44
	return self.crossroads
end

local function fn(self, arg_45_1)
	-- function 45
	for i = 1, #self do
		local var_45_0 = self[i]
		local id = var_45_0.id

		if not id then
			arg_45_1[id] = var_45_0
		end
	end
end

LevelAnalysis._make_waypoint_lookup = function (self)
	-- function 46
	self.waypoint_lookup_table = {}

	if not self.event_waypoints then
		fn(self.event_waypoints, self.waypoint_lookup_table)
	end

	if not self.patrol_waypoints then
		fn(self.patrol_waypoints, self.waypoint_lookup_table)
	end

	if not self.boss_waypoints then
		for k, v in pairs(self.boss_waypoints) do
			fn(v, self.waypoint_lookup_table)
		end
	end
end

LevelAnalysis._remove_short_routes = function (arg_47_0, arg_47_1, arg_47_2)
	-- function 47
	if not arg_47_1 then
		return
	end

	local distance = Vector3.distance

	for i = #arg_47_1, 1, -1 do
		local var_47_1 = arg_47_1[i]
		local waypoints = var_47_1.waypoints
		local num = 0
		local var_47_4 = waypoints[1]
		local var_47_5 = Vector3(var_47_4[1], var_47_4[2], var_47_4[3])
		local var_47_6

		for j = 2, #waypoints do
			local var_47_7 = waypoints[j]
			local var_47_8 = Vector3(var_47_7[1], var_47_7[2], var_47_7[3])

			num = num + distance(var_47_5, var_47_8)

			if num > 15 then
				break
			end

			var_47_5 = var_47_8
		end

		if num <= 15 then
			print("Removing patrol of type: '" .. arg_47_2 .. "', called: '" .. var_47_1.id .. "' because it is too short: " .. num .. "m, which is less then 15m.")
			table.remove(arg_47_1, i)
		end
	end
end

LevelAnalysis.store_patrol_waypoints = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	if not arg_48_1 then
		for i = 1, #arg_48_1 do
			self:_remove_short_routes(arg_48_1[i], "boss")

			if not (not self._skip_to_map_section and not (i < self._skip_to_map_section)) then
				table.clear(arg_48_1[i])
			end
		end
	end

	self:_remove_short_routes(arg_48_2, "roaming")
	self:_remove_short_routes(arg_48_3, "event")

	self.used_roaming_waypoints = {}
	self.boss_waypoints = arg_48_1
	self.patrol_waypoints = arg_48_2

	local system = Managers.state.entity:system("ai_group_system")

	if not arg_48_3 then
		self.event_waypoints = arg_48_3

		system:add_ready_splines(self.event_waypoints, "event")
	end

	self:_make_waypoint_lookup()
	system:add_ready_splines(self.patrol_waypoints, "roaming")
end

LevelAnalysis.draw_patrol_route = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local var_49_0 = Vector3(0, 0, 1)
	local waypoints = arg_49_1.waypoints
	local var_49_2 = waypoints[1]
	local num = Vector3(var_49_2[1], var_49_2[2], var_49_2[3]) + var_49_0

	arg_49_2:sphere(num, 0.5, arg_49_3)

	local var_49_4

	for i = 2, #waypoints do
		local var_49_5 = waypoints[i]
		local num_2 = Vector3(var_49_5[1], var_49_5[2], var_49_5[3]) + var_49_0

		arg_49_2:sphere(num_2, 0.5, arg_49_3)
		arg_49_2:line(num, num_2, arg_49_3)

		num = num_2
	end
end

LevelAnalysis.draw_patrol_routes = function (self)
	-- function 50
	local QuickDrawerStay = QuickDrawerStay
	local tbl = {
		Color(0, 255, 40),
		Color(0, 75, 255),
		Color(200, 25, 40),
		Color(255, 0, 255),
		Color(0, 0, 255),
		Color(0, 200, 0),
		Color(220, 200, 0)
	}
	local boss_waypoints = self.boss_waypoints

	if not boss_waypoints then
		for i = 1, #boss_waypoints do
			local var_50_3 = boss_waypoints[i]
			local var_50_4 = tbl[i]

			for j = 1, #var_50_3 do
				local var_50_5 = var_50_3[j]

				self:draw_patrol_route(var_50_5, QuickDrawerStay, var_50_4)
			end
		end
	end

	local var_50_6 = Color(0, 220, 200)
	local patrol_waypoints = self.patrol_waypoints

	if not patrol_waypoints then
		for k = 1, #patrol_waypoints do
			local var_50_8 = patrol_waypoints[k]

			self:draw_patrol_route(var_50_8, QuickDrawerStay, var_50_6)
		end
	end

	local var_50_9 = Color(100, 100, 0)
	local event_waypoints = self.event_waypoints

	if not event_waypoints then
		for l = 1, #event_waypoints do
			local var_50_11 = event_waypoints[l]

			self:draw_patrol_route(var_50_11, QuickDrawerStay, var_50_9)
		end
	end
end

LevelAnalysis.draw_patrol_start_position = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	-- function 51
	local var_51_0 = Vector3(0, 0, 1)
	local var_51_1 = arg_51_1.waypoints[1]
	local num = Vector3(var_51_1[1], var_51_1[2], var_51_1[3]) + var_51_0

	arg_51_2:sphere(num, 1, arg_51_3)
	arg_51_2:line(num, num + Vector3(0, 0, 50), Colors.get("red"))
	table.dump(arg_51_1)

	local var_51_3

	if not arg_51_1.one_directional then
		var_51_3 = "Patrol " .. arg_51_1.id .. " one_directional " .. " MS: " .. arg_51_4
	else
		var_51_3 = "Patrol " .. arg_51_1.id .. " MS: " .. arg_51_4
	end

	local var_51_4

	if not arg_51_1.main_path_connector then
		local var_51_5 = Vector3(arg_51_1.main_path_connector[1], arg_51_1.main_path_connector[2], arg_51_1.main_path_connector[3])

		arg_51_2:sphere(var_51_5, 1, Colors.get("lime"))
		print("Found main path connector")

		var_51_4 = var_51_5
	end

	Managers.state.debug_text:output_world_text(var_51_3, 0.5, num + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))

	local var_51_6

	if not var_51_4 then
		local closest_pos_at_main_path, var_51_8 = MainPathUtils.closest_pos_at_main_path(nil, var_51_4)

		arg_51_2:sphere(closest_pos_at_main_path, 1, Colors.get("cyan"))

		local str = "" .. arg_51_1.id .. " using main path connection "

		Managers.state.debug_text:output_world_text(str, 0.5, closest_pos_at_main_path + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))
		arg_51_2:line(num, closest_pos_at_main_path, Colors.get("cyan"))

		var_51_6 = var_51_8

		print("Main path connector travel dist ", var_51_6)
	else
		local closest_pos_at_main_path_2, var_51_11 = MainPathUtils.closest_pos_at_main_path(nil, num)

		arg_51_2:sphere(closest_pos_at_main_path_2, 1, Colors.get("cyan"))

		local str_2 = "" .. arg_51_1.id .. " connection "

		Managers.state.debug_text:output_world_text(str_2, 0.5, closest_pos_at_main_path_2 + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))
		arg_51_2:line(num, closest_pos_at_main_path_2, Colors.get("cyan"))

		var_51_6 = var_51_11
	end

	local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, var_51_6 - 45)

	if not point_on_mainpath then
		arg_51_2:line(num, point_on_mainpath, Colors.get("yellow"))
		arg_51_2:sphere(point_on_mainpath, 1, arg_51_3)

		local str_3 = "" .. arg_51_1.id .. " trigger "

		Managers.state.debug_text:output_world_text(str_3, 0.4, point_on_mainpath + Vector3(0, 0, 1), nil, "patrol_start_position_debug", Vector3(255, 255, 0))
	end
end

LevelAnalysis.draw_patrol_start_positions = function (self)
	-- function 52
	local QuickDrawerStay = QuickDrawerStay
	local get = Colors.get("purple")
	local boss_waypoints = self.boss_waypoints

	Managers.state.debug_text:clear_world_text("patrol_start_position_debug")

	if not boss_waypoints then
		for i = 1, #boss_waypoints do
			local var_52_3 = boss_waypoints[i]

			for j = 1, #var_52_3 do
				local var_52_4 = var_52_3[j]

				self:draw_patrol_start_position(var_52_4, QuickDrawerStay, get, i)
			end
		end
	end
end

LevelAnalysis.debug_get_closest_boss_patrol_spawn = function (self, arg_53_1)
	-- function 53
	local boss_waypoints = self.boss_waypoints
	local var_53_1
	local huge = math.huge

	if not boss_waypoints then
		for i = 1, #boss_waypoints do
			local var_53_3 = boss_waypoints[i]

			for j = 1, #var_53_3 do
				local var_53_4 = var_53_3[j]
				local var_53_5 = Vector3(0, 0, 1)
				local var_53_6 = var_53_4.waypoints[1]
				local num = Vector3(var_53_6[1], var_53_6[2], var_53_6[3]) + var_53_5
				local distance = Vector3.distance(arg_53_1, num)

				if distance < huge then
					var_53_1 = var_53_4
					huge = distance
				end
			end
		end
	end

	local boxify_waypoint_table = self:boxify_waypoint_table(var_53_1.waypoints)

	return var_53_1, boxify_waypoint_table
end

LevelAnalysis.get_waypoint_spline = function (self, arg_54_1)
	-- function 54
	local waypoint_lookup_table = self.waypoint_lookup_table

	waypoint_lookup_table = not waypoint_lookup_table and self.waypoint_lookup_table[arg_54_1]

	if not waypoint_lookup_table then
		local waypoints = waypoint_lookup_table.waypoints
		local var_54_2 = waypoints[1]
		local var_54_3 = Vector3(var_54_2[1], var_54_2[2], var_54_2[3])

		if not waypoint_lookup_table.one_directional then
			print("Getting waypoint spline, is one one_directional")
		end

		return waypoint_lookup_table, waypoints, var_54_3, waypoint_lookup_table.one_directional
	end
end

LevelAnalysis.get_closest_waypoint_spline = function (self, arg_55_1)
	-- function 55
	if not self.waypoint_lookup_table then
		return
	end

	local waypoint_lookup_table = self.waypoint_lookup_table

	if not waypoint_lookup_table then
		printf("Missing patrol waypoints")

		return
	end

	local huge = math.huge
	local var_55_2

	for k, v in pairs(waypoint_lookup_table) do
		local var_55_3 = v.waypoints[1]
		local var_55_4 = Vector3(var_55_3[1], var_55_3[2], var_55_3[3])
		local distance = Vector3.distance(arg_55_1, var_55_4)

		if distance < huge then
			var_55_2 = k
			huge = distance
		end
	end

	if not var_55_2 then
		local var_55_6 = waypoint_lookup_table[var_55_2]
		local boxify_table_pos_array = LevelAnalysis.boxify_table_pos_array(var_55_6.waypoints)

		return var_55_2, boxify_table_pos_array, boxify_table_pos_array[1]:unbox()
	end

	print("Closest")

	return nil
end

local to_elements = Vector3.to_elements
local set_xyz = Vector3.set_xyz
local temp_count = Script.temp_count
local set_temp_count = Script.set_temp_count
local closest_point_on_line = Geometry.closest_point_on_line
local distance_squared = Vector3.distance_squared

LevelAnalysis.get_closest_pos_to_waypoint_list = function (arg_56_0, arg_56_1, arg_56_2)
	-- function 56
	local var_56_0 = Vector3(0, 0, 0)
	local huge = math.huge
	local var_56_2 = Vector3(unpack(arg_56_1[1]))
	local var_56_3, var_56_4, var_56_5 = temp_count()

	for i = 2, #arg_56_1 do
		local var_56_6 = Vector3(unpack(arg_56_1[i]))
		local var_56_7 = closest_point_on_line(arg_56_2, var_56_2, var_56_6)
		local var_56_8 = distance_squared(arg_56_2, var_56_7)

		if var_56_8 < huge then
			huge = var_56_8

			set_xyz(var_56_0, to_elements(var_56_7))
		end

		var_56_2 = var_56_6
	end

	set_temp_count(var_56_3, var_56_4, var_56_5)

	return var_56_0
end

LevelAnalysis.get_closest_roaming_spline = function (self, arg_57_1, arg_57_2)
	-- function 57
	local var_57_0
	local var_57_1
	local var_57_2
	local var_57_3
	local num = 30
	local distance = Vector3.distance
	local used_roaming_waypoints = self.used_roaming_waypoints
	local var_57_7
	local patrol_waypoints = self.patrol_waypoints

	for i = 1, #patrol_waypoints do
		if not used_roaming_waypoints[i] then
			local var_57_9 = patrol_waypoints[i]
			local get_closest_pos_to_waypoint_list

			if not arg_57_2 then
				get_closest_pos_to_waypoint_list = self:get_closest_pos_to_waypoint_list(var_57_9.waypoints, arg_57_1)

				if not get_closest_pos_to_waypoint_list then
					-- Nothing
				end
			end

			get_closest_pos_to_waypoint_list = var_57_9.waypoints[1]

			::label_57_0::

			local var_57_11 = Vector3(get_closest_pos_to_waypoint_list[1], get_closest_pos_to_waypoint_list[2], get_closest_pos_to_waypoint_list[3])
			local var_57_12 = distance(arg_57_1, var_57_11)

			if var_57_12 < num then
				num = var_57_12
				var_57_0 = var_57_9.id
				var_57_1 = var_57_9
				var_57_7 = i
				var_57_2 = var_57_11
			end
		end
	end

	if not var_57_0 then
		used_roaming_waypoints[var_57_7] = true
	end

	return var_57_0, var_57_1, var_57_2
end

LevelAnalysis.store_main_paths = function (self, arg_58_1)
	-- function 58
	self.main_paths = arg_58_1

	local collapse_main_paths, var_58_1, var_58_2, var_58_3, var_58_4 = MainPathUtils.collapse_main_paths(arg_58_1)
	local var_58_5 = var_58_1[#var_58_1]

	self.main_path_data = {
		collapsed_path = collapse_main_paths,
		collapsed_travel_dists = var_58_1,
		breaks_lookup = var_58_3,
		breaks_order = var_58_4,
		total_dist = var_58_5
	}
end

LevelAnalysis.remove_crossroads_extra_path_branches = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6)
	-- function 59
	arg_59_1 = arg_59_1 or self.main_paths
	arg_59_2 = arg_59_2 or self.crossroads

	local starting_seed = self.starting_seed
	local chosen_crossroads = self.chosen_crossroads
	local remove_crossroads_extra_path_branches, var_59_3, var_59_4 = MainPathSpawningGenerator.remove_crossroads_extra_path_branches(arg_59_2, chosen_crossroads, arg_59_1, arg_59_4, arg_59_5, arg_59_6, starting_seed)

	if not remove_crossroads_extra_path_branches then
		self:remove_terror_spawners_due_to_crossroads(var_59_4)
		Managers.state.entity:system("pickup_system"):remove_pickups_due_to_crossroads(var_59_4, arg_59_3)
		Managers.state.game_mode:remove_respawn_units_due_to_crossroads(var_59_4, arg_59_3)

		return true, var_59_3
	else
		return false, arg_59_5
	end
end

LevelAnalysis.remove_terror_spawners_due_to_crossroads = function (self, arg_60_1)
	-- function 60
	local tbl = {}
	local terror_spawners = self.terror_spawners
	local count = #arg_60_1

	for k, v in pairs(terror_spawners) do
		table.clear(tbl)

		local spawners = v.spawners

		for k_2 = 1, #spawners do
			local var_60_4 = spawners[k_2][2]

			for l = 1, count do
				local var_60_5 = arg_60_1[l]

				if not (not (var_60_4 > var_60_5[1]) or not (var_60_4 < var_60_5[2])) then
					tbl[#tbl + 1] = k_2

					break
				end
			end
		end

		for i4 = #tbl, 1, -1 do
			table.remove(spawners, tbl[i4])
		end
	end

	local boss_waypoints = self.boss_waypoints

	if not boss_waypoints then
		return false, "no boss waypoints table, you need to regenerate boss waypoints in editor!"
	end

	table.clear(tbl)

	for i5 = 1, #boss_waypoints do
		local var_60_7 = boss_waypoints[i5]

		for i6 = 1, #var_60_7 do
			local var_60_8 = var_60_7[i6]
			local travel_dist = var_60_8.travel_dist

			for i7 = 1, count do
				local var_60_10 = arg_60_1[i7]

				if not (not (travel_dist > var_60_10[1]) or not (travel_dist < var_60_10[2])) then
					tbl[#tbl + 1] = var_60_8.id

					break
				end
			end
		end

		for i8 = 1, #tbl do
			local var_60_11 = tbl[i8]

			for i9 = 1, #var_60_7 do
				if var_60_7[i9].id == var_60_11 then
					table.remove(var_60_7, i9)

					break
				end
			end
		end

		table.dump(var_60_7)
	end
end

LevelAnalysis.brute_force_calc_zone_distances = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	for i = 1, arg_61_2 do
		local var_61_0 = arg_61_1[i]
		local sub = var_61_0.sub

		if not sub[1] then
			local var_61_2 = arg_61_3[sub[1][1]]
			local closest_pos_at_main_path, var_61_4, var_61_5, var_61_6, var_61_7 = EngineOptimized.closest_pos_at_main_path(Vector3(var_61_2[1], var_61_2[2], var_61_2[3]))

			var_61_0.old_travel_dist = var_61_0.travel_dist
			var_61_0.travel_dist = var_61_4
		end
	end
end

LevelAnalysis.store_path_markers = function (self, arg_62_1)
	-- function 62
	self.path_markers = arg_62_1
	self.start = arg_62_1[1].pos
	self.finish = arg_62_1[#arg_62_1].pos
end

LevelAnalysis.main_path = function (self, arg_63_1)
	-- function 63
	local var_63_0 = self.main_paths[arg_63_1]

	return var_63_0.nodes, var_63_0.path_length
end

LevelAnalysis.get_path_point = function (self, arg_64_1, arg_64_2)
	-- function 64
	local num = 0
	local num_2 = arg_64_2 * arg_64_1
	local length = Vector3.length

	for i = 1, #self - 1 do
		local unbox = self[i]:unbox()
		local num_3 = self[i + 1]:unbox() - unbox
		local var_64_5 = length(num_3)

		num = num + var_64_5

		if num_2 < num then
			return unbox + num_3 * ((var_64_5 - (num - num_2)) / var_64_5), i
		end
	end

	return self[#self]:unbox(), #self
end

LevelAnalysis.reset_debug = function (self)
	-- function 65
	Managers.state.debug_text:clear_world_text("boss_spawning")

	self.used_roaming_waypoints = {}
end

LevelAnalysis.debug = function (self, arg_66_1)
	-- function 66
	local debug_text = Managers.state.debug_text

	debug_text:clear_world_text("boss")

	if not (true or self._debug_boss_spawning) then
		local terror_spawners = self.terror_spawners
		local num = 0

		for k, v in pairs(terror_spawners) do
			local var_66_3 = Vector3(0, 0, 22 + num)
			local spawners = v.spawners

			for k_2 = 1, #spawners do
				local var_66_5 = spawners[k_2]
				local var_66_6 = var_66_5[1]
				local var_66_7 = var_66_5[3]
				local local_position = Unit.local_position(var_66_6, 0)
				local num_2 = local_position + var_66_3
				local var_66_10 = Colors.distinct_colors_lookup[(var_66_7 + 3) % 10]
				local var_66_11 = Color(var_66_10[1], var_66_10[2], var_66_10[3])

				QuickDrawerStay:line(local_position, num_2, var_66_11)
				debug_text:output_world_text(k, 0.5, num_2, nil, "boss_spawning", Vector3(var_66_10[1], var_66_10[2], var_66_10[3]), "player_1")

				local var_66_12 = var_66_5[2]
				local point_on_mainpath = MainPathUtils.point_on_mainpath(self.main_paths, var_66_12)

				QuickDrawerStay:line(num_2, point_on_mainpath, var_66_11)
			end

			num = num + 0.5
		end

		self._debug_boss_spawning = true
	end

	if not self.path_markers then
		for l = 1, #self.path_markers do
			local unbox = self.path_markers[l].pos:unbox()

			if not (self.path_markers[l].marker_type == "break" or self.path_markers[l].marker_type ~= "crossroad_break") then
				QuickDrawer:cylinder(unbox, unbox + Vector3(0, 0, 8), 0.6, Color(255, 194, 13, 17), 16)
				QuickDrawer:sphere(unbox + Vector3(0, 0, 8), 0.4, Color(255, 194, 13, 17))
			else
				QuickDrawer:cylinder(unbox, unbox + Vector3(0, 0, 8), 0.8, Color(255, 244, 183, 7), 16)
			end
		end
	end

	for i4 = 1, #self.main_paths do
		local var_66_15 = self.main_paths[i4]
		local nodes = var_66_15.nodes
		local path_length = var_66_15.path_length

		if not (not nodes and not (#nodes > 0)) then
			local unbox_2 = nodes[1]:unbox()

			for i5 = 1, #nodes do
				local unbox_3 = nodes[i5]:unbox()

				QuickDrawer:sphere(unbox_3 + Vector3(0, 0, 1.5), 0.4, Color(255, 44, 143, 7))
				QuickDrawer:line(unbox_3 + Vector3(0, 0, 1.5), unbox_2 + Vector3(0, 0, 1.5), Color(255, 44, 143, 7))

				unbox_2 = unbox_3
			end

			local var_66_20
			local var_66_21

			if not self.boss_event_list then
				for i6 = 1, #self.boss_event_list do
					local var_66_22 = self.boss_event_list[i6]
					local unbox_4 = var_66_22[1]:unbox()
					local var_66_24 = var_66_22[2]
					local num_3 = unbox_4 + Vector3(0, 0, 10)
					local var_66_26 = var_66_22[4]
					local get = Colors.get(var_66_26)

					QuickDrawer:cylinder(unbox_4, num_3, 0.5, get, 10)
					QuickDrawer:sphere(num_3, 2, get)

					local var_66_28 = Colors.color_definitions[var_66_26]

					debug_text:output_world_text(var_66_24, 0.5, num_3, nil, "boss", Vector3(var_66_28[2], var_66_28[3], var_66_28[4]), "player_1")
				end
			end

			local num_4 = arg_66_1 % 5 / 5
			local get_path_point = LevelAnalysis.get_path_point(nodes, path_length, num_4)

			QuickDrawer:sphere(get_path_point + Vector3(0, 0, 1.5), 1.366, Color(255, 244, 183, 7))
		end
	end
end

LevelAnalysis.update = function (self, arg_67_1)
	-- function 67
	if not self.stitching_path then
		self:update_main_path_generation()
	end
end

LevelAnalysis.get_main_and_sub_zone_index_from_pos = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
	-- function 68
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(arg_68_0, arg_68_3)

	if not get_seed_triangle then
		local temp_count, var_68_2, var_68_3 = Script.temp_count()
		local get_triangle_vertices, var_68_5, var_68_6 = GwNavTraversal.get_triangle_vertices(arg_68_0, get_seed_triangle)
		local num = (get_triangle_vertices + var_68_5 + var_68_6) / 3
		local num_2 = num.x * 0.0001 + num.y + num.z * 10000

		Script.set_temp_count(temp_count, var_68_2, var_68_3)

		local var_68_9 = arg_68_2[num_2]
		local var_68_10 = arg_68_4[var_68_9]

		print("get_main_and_sub_zone_index_from_pos", arg_68_3, num_2, var_68_9, var_68_10)

		if not var_68_10 then
			local floor = math.floor(var_68_10 / 10000)
			local num_3 = var_68_10 % 10000

			return arg_68_1[floor], floor, num_3
		end
	end
end

LevelAnalysis.get_zone_from_unique_id = function (arg_69_0, arg_69_1, arg_69_2)
	-- function 69
	for i = 1, #arg_69_1 do
		local var_69_0 = arg_69_1[i]

		if var_69_0.unique_zone_id == arg_69_2 then
			return var_69_0
		end
	end
end

LevelAnalysis.get_zone_segment_from_travel_dist = function (arg_70_0, arg_70_1, arg_70_2)
	-- function 70
	local var_70_0 = arg_70_2

	for i = 1, var_70_0 do
		if arg_70_0 < arg_70_1[i].travel_dist - 5 then
			local num

			if i > 1 then
				num = i - 1

				if not num then
					-- Nothing
				end
			end

			num = i

			::label_70_0::

			local var_70_2 = arg_70_1[num]

			return num, var_70_2
		end
	end

	return var_70_0, arg_70_1[var_70_0]
end

LevelAnalysis.setup_unreachable_processing = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	-- function 71
	local tbl = {
		investigated_points = 0,
		num_points_started = 0,
		running_astar_list = {},
		free_astar_list = {},
		remove_list = {},
		main_paths = arg_71_1,
		nav_world = arg_71_0,
		point_list = arg_71_2
	}
	local max_concurrent_astars

	if not arg_71_3 then
		max_concurrent_astars = arg_71_3.max_concurrent_astars

		if not max_concurrent_astars then
			-- Nothing
		end
	end

	max_concurrent_astars = 25

	::label_71_0::

	tbl.max_running_astars = max_concurrent_astars
	tbl.delete_failed_points = not arg_71_3 and arg_71_3.delete_failed_points
	tbl.get_pos_func = not arg_71_3 and arg_71_3.get_pos_func
	tbl.get_pos_func2 = not arg_71_3 and arg_71_3.get_pos_func2
	tbl.path_found_func = not arg_71_3 and arg_71_3.path_found_func
	tbl.path_not_found_func = not arg_71_3 and arg_71_3.path_not_found_func

	local traverse_logic

	if not arg_71_3 then
		traverse_logic = arg_71_3.traverse_logic

		if not traverse_logic then
			-- Nothing
		end
	end

	traverse_logic = GwNavTraverseLogic.create(arg_71_0)

	::label_71_1::

	tbl.traverse_logic = traverse_logic
	tbl.line_object = not arg_71_3 and arg_71_3.line_object
	tbl.fail_color = not arg_71_3 and arg_71_3.fail_color
	tbl.ok_color = not arg_71_3 and arg_71_3.ok_color
	tbl.translate_vec = not arg_71_3 and arg_71_3.translate_vec

	return tbl
end

LevelAnalysis.process_unreachable = function (self)
	-- function 72
	local point_list = self.point_list
	local delete_failed_points = self.delete_failed_points
	local path_found_func = self.path_found_func

	path_found_func = path_found_func or function ()
		-- function 73
		return
	end

	local path_not_found_func = self.path_not_found_func

	path_not_found_func = path_not_found_func or function ()
		-- function 74
		return
	end

	local get_pos_func = self.get_pos_func

	get_pos_func = get_pos_func or function (self, arg_75_1)
		-- function 75
		return self[arg_75_1]:unbox()
	end

	local get_pos_func2 = self.get_pos_func2

	get_pos_func2 = get_pos_func2 or function ()
		-- function 76
		return
	end

	local max_running_astars = self.max_running_astars
	local running_astar_list = self.running_astar_list
	local free_astar_list = self.free_astar_list
	local remove_list = self.remove_list
	local num = #running_astar_list + #free_astar_list
	local num_points_started = self.num_points_started
	local count = #point_list
	local line_object = self.line_object
	local var_72_14

	if not self.fail_color then
		var_72_14 = Color(unpack(self.fail_color))

		if not var_72_14 then
			-- Nothing
		end
	end

	var_72_14 = Color(255, 0, 0)

	do
		local var_72_15
	end

	::label_72_0::

	if not self.ok_color then
		var_72_15 = Color(unpack(self.ok_color))

		if not var_72_15 then
			-- Nothing
		end
	end

	var_72_15 = Color(255, 255, 255)

	do
		local var_72_16
	end

	::label_72_1::

	if not self.translate_vec then
		var_72_16 = Vector3(unpack(self.translate_vec))

		if not var_72_16 then
			-- Nothing
		end
	end

	var_72_16 = Vector3(0, 0, 0)

	::label_72_2::

	Debug.text("Processing points: %d, %d/%d, astars: free %d running %d", self.num_points_started, self.investigated_points, count, #free_astar_list, #running_astar_list)
	printf("[LevelAnalysis] Processing points: %d, %d/%d, astars: free %d running %d", self.num_points_started, self.investigated_points, count, #free_astar_list, #running_astar_list)

	if count <= self.investigated_points then
		print("[LevelAnalysis] -->processing done!")

		if not delete_failed_points then
			if #remove_list > 0 then
				print("[LevelAnalysis] -->removing bad points:")
				table.sort(remove_list)

				for i = #remove_list, 1, -1 do
					local var_72_17 = remove_list[i]

					point_list[var_72_17] = nil

					print("[LevelAnalysis] \tpoint", var_72_17, "removed")
				end
			else
				print("[LevelAnalysis] --> no bad points were found!")
			end
		end

		print("[LevelAnalysis] --> clearing up free_astars:", #free_astar_list)

		local destroy = GwNavAStar.destroy

		for j = 1, #free_astar_list do
			destroy(free_astar_list[j].astar)
		end

		print("[LevelAnalysis] -->clearing up running_astars:", #running_astar_list)

		for k = 1, #running_astar_list do
			local astar = running_astar_list[k].astar

			destroy(astar)
		end

		print("[LevelAnalysis] -->bye!")

		return true
	end

	local traverse_logic = self.traverse_logic
	local num_2 = 0
	local var_72_22

	if max_running_astars > #running_astar_list - #free_astar_list then
		local start = GwNavAStar.start

		while not (not (num_points_started < count) or not (num_2 < max_running_astars)) do
			local var_72_24

			if #free_astar_list > 0 then
				var_72_24 = free_astar_list[#free_astar_list]
				free_astar_list[#free_astar_list] = nil
				var_72_22 = var_72_24.astar
				var_72_24.point_index = num_points_started + 1
				running_astar_list[#running_astar_list + 1] = var_72_24
			elseif num < max_running_astars then
				num_2 = num_2 + 1
				var_72_22 = GwNavAStar.create()
				num = num + 1
				var_72_24 = {
					astar = var_72_22,
					point_index = num_points_started + 1
				}
				running_astar_list[num_2] = var_72_24
			else
				break
			end

			local var_72_25 = get_pos_func(point_list, num_points_started + 1)
			local var_72_26 = get_pos_func2(point_list, num_points_started + 1)

			var_72_26 = var_72_26 or MainPathUtils.closest_pos_at_main_path_lua(self.main_paths, var_72_25)
			var_72_24.goal_pos_boxed = Vector3Box(var_72_26)
			num_points_started = num_points_started + 1

			fassert(var_72_26, "No main-path pos found")
			start(var_72_22, self.nav_world, var_72_25, var_72_26, traverse_logic)
		end
	end

	self.num_points_started = num_points_started

	local num_3 = 1
	local count_2 = #running_astar_list
	local processing_finished = GwNavAStar.processing_finished
	local path_found = GwNavAStar.path_found
	local node_at_index = GwNavAStar.node_at_index
	local node_count = GwNavAStar.node_count

	while num_3 <= count_2 do
		local var_72_33 = running_astar_list[num_3]
		local astar_2 = var_72_33.astar

		if not processing_finished(astar_2) then
			self.investigated_points = self.investigated_points + 1

			if not path_found(astar_2) then
				if not line_object then
					local temp_count, var_72_36, var_72_37 = Script.temp_count()
					local var_72_38 = node_at_index(astar_2, 1)
					local num_4 = Vector3(0, 0, 0.2) + var_72_16

					for l = 2, node_count(astar_2) do
						local var_72_40 = node_at_index(astar_2, l)

						line_object:line(var_72_38 + num_4, var_72_40 + num_4, var_72_15)

						var_72_38 = var_72_40
					end

					Script.set_temp_count(temp_count, var_72_36, var_72_37)
				end

				printf("[LevelAnalysis] \tpoint: %d ok! (%d/%d)", var_72_33.point_index, self.investigated_points, count)
				path_found_func(point_list, var_72_33.point_index, var_72_33)
			else
				if not line_object then
					local num_5 = Vector3(0, 0, 0.2) + var_72_16
					local var_72_42 = get_pos_func(point_list, var_72_33.point_index)
					local closest_pos_at_main_path_lua = MainPathUtils.closest_pos_at_main_path_lua(self.main_paths, var_72_42)

					line_object:line(var_72_42 + num_5, closest_pos_at_main_path_lua + num_5, var_72_14)
					line_object:sphere(var_72_42 + num_5, 0.2, var_72_14)
					line_object:sphere(closest_pos_at_main_path_lua + num_5, 0.2, var_72_14)
				end

				printf("[LevelAnalysis] \tpoint: %d failed! (%d/%d)", var_72_33.point_index, self.investigated_points, count)
				path_not_found_func(point_list, var_72_33.point_index)

				if not delete_failed_points then
					remove_list[#remove_list + 1] = var_72_33.point_index
				end
			end

			free_astar_list[#free_astar_list + 1] = var_72_33
			running_astar_list[num_3] = running_astar_list[count_2]
			running_astar_list[count_2] = nil
			count_2 = count_2 - 1
		else
			num_3 = num_3 + 1
		end
	end
end

LevelAnalysis.setup_main_path_breaks_check = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	-- function 77
	local tbl = {
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
	local nodes_to_check = tbl.nodes_to_check
	local optional_failed_messages = tbl.optional_failed_messages
	local count = #arg_77_1

	for i = count, 1, -1 do
		local var_77_4 = arg_77_1[i]
		local nodes = var_77_4.nodes
		local var_77_6 = nodes[1]

		for j = i - 1, 1, -1 do
			local var_77_7 = arg_77_1[j]
			local nodes_2 = var_77_7.nodes
			local var_77_9 = nodes_2[#nodes_2]
			local crossroads_id = var_77_4.crossroads_id

			crossroads_id = crossroads_id or var_77_7.crossroads_id

			local flag = not crossroads_id and MainPathSpawningGenerator.main_path_has_marker_type(arg_77_3, j, "crossroad_break")
			local flag_2 = var_77_4.crossroads_id == var_77_7.crossroads_id
			local flag_3 = var_77_4.road_id == var_77_7.road_id

			nodes_to_check[#nodes_to_check + 1] = {
				from_node_box = var_77_6,
				to_node_box = var_77_9,
				from_main_path_index = i,
				to_main_path_index = j,
				is_crossroad = crossroads_id,
				has_crossroad_break = flag,
				shares_crossroad_id = flag_2,
				shares_road_id = flag_3
			}
		end

		if not MainPathSpawningGenerator.main_path_has_marker_type(arg_77_3, i, "crossroad_break") then
			local var_77_14 = nodes[#nodes]
			local crossroads_id_2 = var_77_4.crossroads_id

			if not crossroads_id_2 then
				for k = i + 1, count do
					local var_77_16 = arg_77_1[k]
					local var_77_17 = var_77_16.nodes[1]
					local crossroads_id_3 = var_77_16.crossroads_id

					if not (not crossroads_id_3 and crossroads_id_3 ~= crossroads_id_2) then
						nodes_to_check[#nodes_to_check + 1] = {
							crossroad_break_check = true,
							from_node_box = var_77_14,
							to_node_box = var_77_17,
							from_main_path_index = i,
							to_main_path_index = k
						}

						print("Checking crossroad break on a crossroad between " .. i .. " to " .. k)

						break
					end
				end
			else
				local var_77_19
				local tbl_2 = {}

				for l = i + 1, count do
					local var_77_21 = arg_77_1[l]
					local var_77_22 = var_77_21.nodes[1]
					local crossroads_id_4 = var_77_21.crossroads_id
					local road_id = var_77_21.road_id

					if not crossroads_id_4 then
						var_77_19 = var_77_19 or crossroads_id_4

						if not (crossroads_id_4 ~= var_77_19 or tbl_2[road_id]) then
							nodes_to_check[#nodes_to_check + 1] = {
								crossroad_break_check = true,
								from_node_box = var_77_14,
								to_node_box = var_77_22,
								from_main_path_index = i,
								to_main_path_index = l
							}
							tbl_2[road_id] = true

							print("Checking crossroad break between " .. i .. " to " .. l)
						end
					else
						if not var_77_19 then
							print("There is no crossroad after crossroad break " .. i)

							optional_failed_messages[#optional_failed_messages + 1] = string.format("Error! There is not a crossroad after crossroad break at main path %d at position %s ", i, tostring(var_77_22:unbox()))
						end

						break
					end
				end
			end
		end
	end

	return tbl
end

LevelAnalysis.process_main_path_breaks_check = function (self)
	-- function 78
	local nav_world = self.nav_world
	local traverse_logic = self.traverse_logic
	local running_astar_list = self.running_astar_list
	local free_astar_list = self.free_astar_list
	local nodes_to_check = self.nodes_to_check
	local max_running_astars = self.max_running_astars
	local drawer = self.drawer
	local failed_main_path_breaks = self.failed_main_path_breaks
	local optional_failed_messages = self.optional_failed_messages
	local create = GwNavAStar.create
	local start = GwNavAStar.start
	local processing_finished = GwNavAStar.processing_finished
	local path_found = GwNavAStar.path_found
	local node_count = GwNavAStar.node_count
	local node_at_index = GwNavAStar.node_at_index
	local destroy = GwNavAStar.destroy

	while not (not (#nodes_to_check > 0) or not (max_running_astars > #running_astar_list)) do
		local count = #nodes_to_check
		local var_78_17 = nodes_to_check[count]

		nodes_to_check[count] = nil

		local var_78_18

		if #free_astar_list > 0 then
			var_78_18 = free_astar_list[#free_astar_list]
			free_astar_list[#free_astar_list] = nil
		else
			var_78_18 = {
				astar = create()
			}
		end

		local astar = var_78_18.astar
		local unbox = var_78_17.from_node_box:unbox()
		local unbox_2 = var_78_17.to_node_box:unbox()

		var_78_18.from_main_path_index = var_78_17.from_main_path_index
		var_78_18.to_main_path_index = var_78_17.to_main_path_index
		var_78_18.from_node_box = var_78_17.from_node_box
		var_78_18.to_node_box = var_78_17.to_node_box
		var_78_18.is_crossroad = var_78_17.is_crossroad
		var_78_18.has_crossroad_break = var_78_17.has_crossroad_break
		var_78_18.shares_crossroad_id = var_78_17.shares_crossroad_id
		var_78_18.shares_road_id = var_78_17.shares_road_id
		var_78_18.crossroad_break_check = var_78_17.crossroad_break_check

		start(astar, nav_world, unbox, unbox_2, traverse_logic)

		running_astar_list[#running_astar_list + 1] = var_78_18
	end

	local num = 1
	local count_2 = #running_astar_list

	while num <= count_2 do
		local var_78_24 = running_astar_list[num]
		local astar_2 = var_78_24.astar

		if not processing_finished(astar_2) then
			local from_main_path_index = var_78_24.from_main_path_index
			local to_main_path_index = var_78_24.to_main_path_index
			local from_node_box = var_78_24.from_node_box
			local to_node_box = var_78_24.to_node_box
			local crossroad_break_check = var_78_24.crossroad_break_check

			if not path_found(astar_2) then
				local temp_count, var_78_32, var_78_33 = Script.temp_count()
				local get = Colors.get("red")
				local num_2 = Vector3.up() * 0.25
				local num_3 = Vector3.up() * 25
				local var_78_37 = node_count(astar_2)

				for i = 2, var_78_37 do
					local num_4 = node_at_index(astar_2, i - 1) + num_2
					local num_5 = node_at_index(astar_2, i) + num_2

					drawer:sphere(num_4, 0.25, get)
					drawer:line(num_4, num_5, get)

					if i == 2 then
						drawer:line(num_4, num_4 + num_3, get)
					end

					if i == var_78_37 then
						drawer:sphere(num_5, 0.25, get)
						drawer:line(num_5, num_5 + num_3, get)
					end
				end

				Script.set_temp_count(temp_count, var_78_32, var_78_33)

				local is_crossroad = var_78_24.is_crossroad
				local has_crossroad_break = var_78_24.has_crossroad_break
				local shares_crossroad_id = var_78_24.shares_crossroad_id
				local shares_road_id = var_78_24.shares_road_id

				if not crossroad_break_check then
					printf("[LevelAnalysis] Found path from crossroad break between main_path_index %d and %d (start=%s end=%s). But that's ok since it will be stitched", from_main_path_index, to_main_path_index, tostring(from_node_box:unbox()), tostring(to_node_box:unbox()))
				elseif (not is_crossroad and has_crossroad_break or not shares_crossroad_id) and not shares_road_id then
					local var_78_44 = failed_main_path_breaks[from_main_path_index]

					var_78_44 = var_78_44 or {}
					var_78_44[to_main_path_index] = {
						node = to_node_box,
						is_crossroad = is_crossroad
					}
					failed_main_path_breaks[from_main_path_index] = var_78_44

					printf("[LevelAnalysis] Error! Path exist between main_path_index %d and %d (start=%s end=%s)!", from_main_path_index, to_main_path_index, tostring(from_node_box:unbox()), tostring(to_node_box:unbox()))
				elseif shares_road_id or not shares_crossroad_id then
					printf("[LevelAnalysis] Path exist between main_path_index %d and %d (start=%s end=%s), but it is between two diffrent roads in the same crossroad that wont exist together.", from_main_path_index, to_main_path_index, tostring(from_node_box:unbox()), tostring(to_node_box:unbox()))
				end
			elseif not crossroad_break_check then
				local var_78_45 = failed_main_path_breaks[from_main_path_index]

				var_78_45 = var_78_45 or {}
				var_78_45[to_main_path_index] = {
					node = to_node_box,
					optional_failed_messages = optional_failed_messages
				}
				failed_main_path_breaks[from_main_path_index] = var_78_45

				printf("[LevelAnalysis] Could not find path to mainpath after crossroad break %d and %d (start=%s end=%s), make sure crossroad breaks can be stitched to either a crossroad or another mainpath.", from_main_path_index, to_main_path_index, tostring(from_node_box:unbox()), tostring(to_node_box:unbox()))
			else
				printf("[LevelAnalysis] Break between main_path_index %d and %d seems good (start=%s end=%s).", from_main_path_index, to_main_path_index, tostring(from_node_box:unbox()), tostring(to_node_box:unbox()))
			end

			free_astar_list[#free_astar_list + 1] = var_78_24
			running_astar_list[num] = running_astar_list[count_2]
			running_astar_list[count_2] = nil
			count_2 = count_2 - 1
		else
			num = num + 1
		end
	end

	if not (#nodes_to_check ~= 0 or #running_astar_list ~= 0) then
		local count_3 = #free_astar_list

		for j = 1, count_3 do
			local astar_3 = free_astar_list[j].astar

			destroy(astar_3)

			free_astar_list[j] = nil
		end

		local var_78_48

		for k, v in pairs(failed_main_path_breaks) do
			if var_78_48 == nil then
				var_78_48 = "Found player path(s) between the main path indexes listed below. Either remove main path break or the path that allows the player to traverse back."
			end

			for k_2, v_2 in pairs(v) do
				local node = v_2.node
				local str = ""

				if not v_2.is_crossroad then
					str = "\nNote: Breaks in this crossroad path needs to be changed to crossroad_break."
				end

				var_78_48 = string.format("%s\n%d -> %d:\t%s %s", var_78_48, k, k_2, tostring(node:unbox()), str)
			end
		end

		if not optional_failed_messages then
			for i6 = 1, #optional_failed_messages do
				local var_78_51 = optional_failed_messages[i6]

				var_78_48 = "\n" .. var_78_48 .. var_78_51
			end
		end

		printf("[LevelAnalysis] Main Path Break Check Done!")

		return true, var_78_48
	else
		return false
	end
end

LevelAnalysis.check_splines_integrity = function (self)
	-- function 79
	print("----> Checking splines integrity START:")

	local system = Managers.state.entity:system("ai_group_system")
	local normal = PatrolFormationSettings.storm_vermin_two_column.normal
	local patrol_waypoints = self.patrol_waypoints

	for i = 1, #patrol_waypoints do
		local var_79_3 = patrol_waypoints[i]
		local astar_points = var_79_3.astar_points
		local id = var_79_3.id
		local flag = false
		local unbox, var_79_8 = astar_points[1]:unbox()

		for j = 2, #astar_points do
			local unbox_2 = astar_points[j]:unbox()

			if Vector3.distance_squared(unbox, unbox_2) > 0.01 then
				unbox = unbox_2
			else
				unbox = unbox_2
				flag = true

				print("SPLINE HAS FAULTY POINTS:", j, id, unbox, unbox_2, Vector3.distance(unbox, unbox_2))
			end
		end

		if not flag then
			print("Faulty spline - ", id, ", points:")

			for k = 1, #astar_points do
				print(k, astar_points[k]:unbox())
			end

			print("")
		end

		local spline_start_position = system:spline_start_position(id)
		local create_formation_data = system:create_formation_data(spline_start_position, normal, id)
	end

	print("----> Checking splines integrity ENDS.")
end

LevelAnalysis._add_boss_to_generated_list = function (arg_80_0, arg_80_1, arg_80_2)
	-- function 80
	local flag = false
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(arg_80_1) do
		if v == "event_boss" then
			flag = true
			tbl[#tbl + 1] = i
		else
			tbl_2[#tbl_2 + 1] = i
		end
	end

	if not (not flag and arg_80_2) then
		return arg_80_1
	elseif arg_80_2 > #tbl then
		local count = #tbl_2

		for k = 1, count do
			local random = math.random(1, #tbl_2)

			if not random then
				local var_80_5 = tbl_2[random]

				if not var_80_5 then
					arg_80_1[var_80_5] = "event_boss"
					flag = true

					table.swap_delete(tbl_2, random)
				end
			end
		end

		return arg_80_1
	end

	if not flag then
		arg_80_1[math.random(1, #arg_80_1)] = "event_boss"
	end

	return arg_80_1
end
