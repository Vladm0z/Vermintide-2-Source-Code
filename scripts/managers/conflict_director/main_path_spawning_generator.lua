-- chunkname: @scripts/managers/conflict_director/main_path_spawning_generator.lua

require("foundation/scripts/util/error")

MainPathSpawningGenerator = {}

MainPathSpawningGenerator._remove_zones_due_to_crossroads = function (self, arg_1_1, arg_1_2)
	-- function 1
	local alloc_table = FrameTable.alloc_table()
	local count = #arg_1_2

	for i = 1, arg_1_1 do
		local var_1_2 = self[i]
		local travel_dist = var_1_2.travel_dist

		fassert(var_1_2.type ~= "island", "Zones badly stored")

		for j = 1, count do
			local var_1_4 = arg_1_2[j]

			if not (not (travel_dist > var_1_4[1]) or not (travel_dist < var_1_4[2])) then
				alloc_table[#alloc_table + 1] = i

				break
			end
		end
	end

	for k = #alloc_table, 1, -1 do
		table.remove(self, alloc_table[k])
	end

	arg_1_1 = arg_1_1 - #alloc_table

	return arg_1_1
end

MainPathSpawningGenerator.inject_travel_dists = function (self, arg_2_1)
	-- function 2
	print("[MainPathSpawningGenerator] Injecting travel distances")

	local distance = Vector3.distance
	local var_2_1 = self[1]

	if not var_2_1.travel_dist and not arg_2_1 then
		local num = 0
		local unbox = var_2_1.nodes[1]:unbox()

		for i = 1, #self do
			local var_2_4 = self[i]
			local nodes = var_2_4.nodes
			local unbox_2 = nodes[1]:unbox()

			num = num + distance(unbox, unbox_2)

			local tbl = {
				num
			}

			for j = 2, #nodes do
				unbox = nodes[j - 1]:unbox()
				unbox_2 = nodes[j]:unbox()
				num = num + distance(unbox, unbox_2)
				tbl[j] = num
			end

			unbox = unbox_2
			var_2_4.travel_dist = tbl
		end
	end
end

MainPathSpawningGenerator.main_path_has_marker_type = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0

	for i = 1, #self do
		local var_3_1 = self[i]
		local main_path_index = var_3_1.main_path_index
		local marker_type = var_3_1.marker_type

		if not (main_path_index ~= arg_3_1 or marker_type ~= arg_3_2) then
			var_3_0 = true

			break
		end
	end

	return var_3_0
end

MainPathSpawningGenerator.load_spawn_zone_data = function (arg_4_0)
	-- function 4
	local var_4_0 = require(arg_4_0)
	local path_markers = var_4_0.path_markers

	for i = 1, #path_markers do
		local var_4_2 = path_markers[i]
		local pos = var_4_2.pos

		var_4_2.pos = Vector3Box(pos[1], pos[2], pos[3])
	end

	return var_4_0
end

MainPathSpawningGenerator.generate_crossroad_path_choices = function (arg_5_0, arg_5_1)
	-- function 5
	if not (not arg_5_0 and next(arg_5_0)) then
		return nil
	end

	local var_5_0
	local tbl = {}

	for k, v in pairs(arg_5_0) do
		local next_random, var_5_3 = Math.next_random(arg_5_1, 1, #v.roads)

		tbl[k], arg_5_1 = var_5_3, next_random
	end

	return tbl
end

MainPathSpawningGenerator.remove_crossroads_extra_path_branches = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	if not (not self and next(self)) then
		print("[MainPathSpawningGenerator] This levels contains no crossroads")

		return
	end

	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()
	local alloc_table_3 = FrameTable.alloc_table()

	for k, v in pairs(arg_6_1) do
		local var_6_3 = self[k]

		printf("[MainPathSpawningGenerator] Using path: %d at crossroad: %s. (1/%d paths).", v, k, #var_6_3.roads)

		for k_2 = #arg_6_2, 1, -1 do
			local var_6_4 = arg_6_2[k_2]

			if not (var_6_4.crossroads_id ~= k or var_6_4.road_id ~= v) then
				alloc_table_3[k_2] = true
				alloc_table_2[#alloc_table_2 + 1] = k_2

				printf("[MainPathSpawningGenerator]\t\t->preparing to stitch road: %d that has main path index: %d ", var_6_4.road_id, k_2)
			end
		end

		for l = 1, #arg_6_2 do
			local var_6_5 = arg_6_2[l]

			if not (var_6_5.crossroads_id ~= k or var_6_5.road_id == v) then
				printf("[MainPathSpawningGenerator]\t\t->removing road: %d from crossroad: %s with main path index: %d", var_6_5.road_id, var_6_5.crossroads_id, l)

				alloc_table[#alloc_table + 1] = l
			end
		end
	end

	local alloc_table_4 = FrameTable.alloc_table()

	for i4 = #alloc_table_2, 1, -1 do
		repeat
			alloc_table_4[#alloc_table_4 + 1] = {}

			local var_6_7 = alloc_table_4[#alloc_table_4]
			local var_6_8 = alloc_table_2[i4]
			local num = var_6_8 - 1

			for i5 = #alloc_table, 1, -1 do
				if num == alloc_table[i5] then
					num = num - 1
				end
			end

			local main_path_has_marker_type = MainPathSpawningGenerator.main_path_has_marker_type(arg_6_5, num, "break")

			if not main_path_has_marker_type then
				var_6_7[#var_6_7 + 1] = num
				var_6_7[#var_6_7 + 1] = var_6_8
			end

			if not MainPathSpawningGenerator.main_path_has_marker_type(arg_6_5, var_6_8, "break") then
				break
			end

			local num_2 = var_6_8 + 1

			for i6 = 1, #alloc_table do
				if num_2 == alloc_table[i6] then
					num_2 = num_2 + 1
				end
			end

			if not main_path_has_marker_type then
				var_6_7[#var_6_7 + 1] = var_6_8
			end

			if not alloc_table_3[num_2] then
				var_6_7[#var_6_7 + 1] = num_2
			end
		until true
	end

	for i7 = 1, #alloc_table_4 do
		repeat
			local var_6_12 = alloc_table_4[i7]

			if #var_6_12 <= 1 then
				break
			end

			local nodes = arg_6_2[var_6_12[1]].nodes

			for i8 = 2, #var_6_12 do
				local var_6_14 = var_6_12[i8]
				local nodes_2 = arg_6_2[var_6_14].nodes

				for i9 = 1, #nodes_2 do
					local var_6_16 = nodes_2[i9]

					nodes[#nodes + 1] = var_6_16
				end

				printf("[MainPathSpawningGenerator] Stitched and removed main path index: %d", var_6_14)

				alloc_table[#alloc_table + 1] = var_6_14
			end
		until true
	end

	table.sort(alloc_table, function (arg_7_0, arg_7_1)
		-- function 7
		return arg_7_0 < arg_7_1
	end)

	local tbl = {}

	for i10 = #alloc_table, 1, -1 do
		local var_6_18 = alloc_table[i10]
		local travel_dist = arg_6_2[var_6_18].travel_dist

		if not alloc_table_3[var_6_18] then
			tbl[#tbl + 1] = {
				travel_dist[1],
				travel_dist[#travel_dist]
			}
		end

		table.remove(arg_6_2, var_6_18)
	end

	arg_6_4 = MainPathSpawningGenerator._remove_zones_due_to_crossroads(arg_6_3, arg_6_4, tbl)

	return true, arg_6_4, tbl
end

MainPathSpawningGenerator.generate_great_cycles = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	local num = 0
	local tbl = {}
	local tbl_2 = {}
	local pack_spawning = self.pack_spawning
	local roaming_set = pack_spawning.roaming_set
	local random_director_list = Managers.state.conflict.enemy_package_loader:random_director_list()
	local num_2 = 1

	MainPathSpawningGenerator.process_conflict_directors_zones(self.name, arg_8_2, arg_8_4, arg_8_6)

	local tbl_3 = {}
	local name = self.name

	for i = 1, arg_8_4 do
		local var_8_9 = arg_8_2[i]
		local flag = false

		if not var_8_9.mutators then
			local tbl_4 = {}

			for iter_8_1 in string.gmatch(var_8_9.mutators, "([^[%s,]+)%s*,?%s*") do
				tbl_4[#tbl_4 + 1] = iter_8_1
			end

			if #tbl_4 ~= #tbl_3 then
				table.sort(tbl_4)

				tbl_3 = tbl_4
				flag = true
			else
				table.sort(tbl_4)

				for i_2, v in ipairs(tbl_4) do
					if v ~= tbl_3[i_2] then
						tbl_3 = tbl_4
						flag = true

						break
					end
				end
			end
		elseif #tbl_3 > 0 then
			tbl_3 = {}
			flag = true
		end

		local flag_2 = false
		local roaming_set_2 = var_8_9.roaming_set

		if not roaming_set_2 then
			if roaming_set_2 == "random" then
				roaming_set_2 = random_director_list[num_2].name
				num_2 = num_2 + 1
			end

			self = ConflictDirectors[roaming_set_2]
			name = self.name
			flag_2 = true
		end

		if flag or not flag_2 then
			local pack_spawning_2 = self.pack_spawning

			if not pack_spawning_2 then
				pack_spawning = MutatorHandler.tweak_pack_spawning_settings(tbl_3, arg_8_1, name, pack_spawning_2)
			end
		end

		local tbl_5 = {}
		local var_8_16 = var_8_9.sub_areas[1]
		local breed_packs = pack_spawning.roaming_set.breed_packs
		local tbl_6 = {
			total_area = 0,
			nodes = var_8_9.sub[1],
			area = var_8_9.sub_areas[1],
			outer = tbl_5,
			pack_type = breed_packs,
			pack_spawning_setting = pack_spawning,
			conflict_setting = self,
			unique_zone_id = var_8_9.unique_zone_id,
			mutators = tbl_3
		}

		for i4 = 2, #var_8_9.sub do
			local var_8_19 = var_8_9.sub_areas[i4]

			var_8_16 = var_8_16 + (var_8_19 or 0)
			tbl_5[#tbl_5 + 1] = {
				nodes = var_8_9.sub[i4],
				area = var_8_19
			}
		end

		tbl_6.total_area = var_8_16
		num = num + var_8_9.sub_zone_length
		tbl[#tbl + 1] = tbl_6
		arg_8_3[i] = tbl_6

		if not (arg_8_5 <= num or i ~= arg_8_4) then
			tbl_2[#tbl_2 + 1] = {
				zones = tbl,
				length = num
			}
			num = num - arg_8_5
			tbl = {}
		end
	end

	return tbl_2
end

MainPathSpawningGenerator.process_conflict_directors_zones = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local tbl = {}
	local num = 0

	if arg_9_2 > 0 then
		if arg_9_1[1].roaming_set == nil then
			tbl[arg_9_0] = true
		end

		for i = 1, arg_9_2 do
			local var_9_2 = arg_9_1[i]
			local roaming_set = var_9_2.roaming_set

			if not roaming_set then
				local split_deprecated = string.split_deprecated(roaming_set, "/")
				local var_9_5
				local var_9_6

				arg_9_3, var_9_6 = Math.next_random(arg_9_3, 1, #split_deprecated)

				local var_9_7 = split_deprecated[var_9_6]

				var_9_2.roaming_set = var_9_7

				if var_9_7 == "random" then
					num = num + 1
				else
					tbl[var_9_7] = true
				end
			end
		end
	else
		tbl[arg_9_0] = true
	end

	return tbl, num, arg_9_3
end
