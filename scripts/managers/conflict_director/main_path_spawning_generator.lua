-- chunkname: @scripts/managers/conflict_director/main_path_spawning_generator.lua

require("foundation/scripts/util/error")

MainPathSpawningGenerator = {}

MainPathSpawningGenerator._remove_zones_due_to_crossroads = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = FrameTable.alloc_table()
	local var_1_1 = #arg_1_2

	for iter_1_0 = 1, arg_1_1 do
		local var_1_2 = arg_1_0[iter_1_0]
		local var_1_3 = var_1_2.travel_dist

		fassert(var_1_2.type ~= "island", "Zones badly stored")

		for iter_1_1 = 1, var_1_1 do
			local var_1_4 = arg_1_2[iter_1_1]

			if var_1_3 > var_1_4[1] and var_1_3 < var_1_4[2] then
				var_1_0[#var_1_0 + 1] = iter_1_0

				break
			end
		end
	end

	for iter_1_2 = #var_1_0, 1, -1 do
		table.remove(arg_1_0, var_1_0[iter_1_2])
	end

	arg_1_1 = arg_1_1 - #var_1_0

	return arg_1_1
end

MainPathSpawningGenerator.inject_travel_dists = function (arg_2_0, arg_2_1)
	print("[MainPathSpawningGenerator] Injecting travel distances")

	local var_2_0 = Vector3.distance
	local var_2_1 = arg_2_0[1]

	if not var_2_1.travel_dist or arg_2_1 then
		local var_2_2 = 0
		local var_2_3 = var_2_1.nodes[1]:unbox()

		for iter_2_0 = 1, #arg_2_0 do
			local var_2_4 = arg_2_0[iter_2_0]
			local var_2_5 = var_2_4.nodes
			local var_2_6 = var_2_5[1]:unbox()

			var_2_2 = var_2_2 + var_2_0(var_2_3, var_2_6)

			local var_2_7 = {
				var_2_2
			}

			for iter_2_1 = 2, #var_2_5 do
				var_2_3 = var_2_5[iter_2_1 - 1]:unbox()
				var_2_6 = var_2_5[iter_2_1]:unbox()
				var_2_2 = var_2_2 + var_2_0(var_2_3, var_2_6)
				var_2_7[iter_2_1] = var_2_2
			end

			var_2_3 = var_2_6
			var_2_4.travel_dist = var_2_7
		end
	end
end

MainPathSpawningGenerator.main_path_has_marker_type = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0

	for iter_3_0 = 1, #arg_3_0 do
		local var_3_1 = arg_3_0[iter_3_0]
		local var_3_2 = var_3_1.main_path_index
		local var_3_3 = var_3_1.marker_type

		if var_3_2 == arg_3_1 and var_3_3 == arg_3_2 then
			var_3_0 = true

			break
		end
	end

	return var_3_0
end

MainPathSpawningGenerator.load_spawn_zone_data = function (arg_4_0)
	local var_4_0 = require(arg_4_0)
	local var_4_1 = var_4_0.path_markers

	for iter_4_0 = 1, #var_4_1 do
		local var_4_2 = var_4_1[iter_4_0]
		local var_4_3 = var_4_2.pos

		var_4_2.pos = Vector3Box(var_4_3[1], var_4_3[2], var_4_3[3])
	end

	return var_4_0
end

MainPathSpawningGenerator.generate_crossroad_path_choices = function (arg_5_0, arg_5_1)
	if not arg_5_0 or not next(arg_5_0) then
		return nil
	end

	local var_5_0
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		local var_5_2, var_5_3 = Math.next_random(arg_5_1, 1, #iter_5_1.roads)

		var_5_1[iter_5_0], arg_5_1 = var_5_3, var_5_2
	end

	return var_5_1
end

MainPathSpawningGenerator.remove_crossroads_extra_path_branches = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	if not arg_6_0 or not next(arg_6_0) then
		print("[MainPathSpawningGenerator] This levels contains no crossroads")

		return
	end

	local var_6_0 = FrameTable.alloc_table()
	local var_6_1 = FrameTable.alloc_table()
	local var_6_2 = FrameTable.alloc_table()

	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		local var_6_3 = arg_6_0[iter_6_0]

		printf("[MainPathSpawningGenerator] Using path: %d at crossroad: %s. (1/%d paths).", iter_6_1, iter_6_0, #var_6_3.roads)

		for iter_6_2 = #arg_6_2, 1, -1 do
			local var_6_4 = arg_6_2[iter_6_2]

			if var_6_4.crossroads_id == iter_6_0 and var_6_4.road_id == iter_6_1 then
				var_6_2[iter_6_2] = true
				var_6_1[#var_6_1 + 1] = iter_6_2

				printf("[MainPathSpawningGenerator]\t\t->preparing to stitch road: %d that has main path index: %d ", var_6_4.road_id, iter_6_2)
			end
		end

		for iter_6_3 = 1, #arg_6_2 do
			local var_6_5 = arg_6_2[iter_6_3]

			if var_6_5.crossroads_id == iter_6_0 and var_6_5.road_id ~= iter_6_1 then
				printf("[MainPathSpawningGenerator]\t\t->removing road: %d from crossroad: %s with main path index: %d", var_6_5.road_id, var_6_5.crossroads_id, iter_6_3)

				var_6_0[#var_6_0 + 1] = iter_6_3
			end
		end
	end

	local var_6_6 = FrameTable.alloc_table()

	for iter_6_4 = #var_6_1, 1, -1 do
		repeat
			var_6_6[#var_6_6 + 1] = {}

			local var_6_7 = var_6_6[#var_6_6]
			local var_6_8 = var_6_1[iter_6_4]
			local var_6_9 = var_6_8 - 1

			for iter_6_5 = #var_6_0, 1, -1 do
				if var_6_9 == var_6_0[iter_6_5] then
					var_6_9 = var_6_9 - 1
				end
			end

			local var_6_10 = MainPathSpawningGenerator.main_path_has_marker_type(arg_6_5, var_6_9, "break")

			if not var_6_10 then
				var_6_7[#var_6_7 + 1] = var_6_9
				var_6_7[#var_6_7 + 1] = var_6_8
			end

			if MainPathSpawningGenerator.main_path_has_marker_type(arg_6_5, var_6_8, "break") then
				break
			end

			local var_6_11 = var_6_8 + 1

			for iter_6_6 = 1, #var_6_0 do
				if var_6_11 == var_6_0[iter_6_6] then
					var_6_11 = var_6_11 + 1
				end
			end

			if var_6_10 then
				var_6_7[#var_6_7 + 1] = var_6_8
			end

			if not var_6_2[var_6_11] then
				var_6_7[#var_6_7 + 1] = var_6_11
			end
		until true
	end

	for iter_6_7 = 1, #var_6_6 do
		repeat
			local var_6_12 = var_6_6[iter_6_7]

			if #var_6_12 <= 1 then
				break
			end

			local var_6_13 = arg_6_2[var_6_12[1]].nodes

			for iter_6_8 = 2, #var_6_12 do
				local var_6_14 = var_6_12[iter_6_8]
				local var_6_15 = arg_6_2[var_6_14].nodes

				for iter_6_9 = 1, #var_6_15 do
					local var_6_16 = var_6_15[iter_6_9]

					var_6_13[#var_6_13 + 1] = var_6_16
				end

				printf("[MainPathSpawningGenerator] Stitched and removed main path index: %d", var_6_14)

				var_6_0[#var_6_0 + 1] = var_6_14
			end
		until true
	end

	table.sort(var_6_0, function (arg_7_0, arg_7_1)
		return arg_7_0 < arg_7_1
	end)

	local var_6_17 = {}

	for iter_6_10 = #var_6_0, 1, -1 do
		local var_6_18 = var_6_0[iter_6_10]
		local var_6_19 = arg_6_2[var_6_18].travel_dist

		if not var_6_2[var_6_18] then
			var_6_17[#var_6_17 + 1] = {
				var_6_19[1],
				var_6_19[#var_6_19]
			}
		end

		table.remove(arg_6_2, var_6_18)
	end

	arg_6_4 = MainPathSpawningGenerator._remove_zones_due_to_crossroads(arg_6_3, arg_6_4, var_6_17)

	return true, arg_6_4, var_6_17
end

MainPathSpawningGenerator.generate_great_cycles = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = 0
	local var_8_1 = {}
	local var_8_2 = {}
	local var_8_3 = arg_8_0.pack_spawning
	local var_8_4 = var_8_3.roaming_set
	local var_8_5 = Managers.state.conflict.enemy_package_loader:random_director_list()
	local var_8_6 = 1

	MainPathSpawningGenerator.process_conflict_directors_zones(arg_8_0.name, arg_8_2, arg_8_4, arg_8_6)

	local var_8_7 = {}
	local var_8_8 = arg_8_0.name

	for iter_8_0 = 1, arg_8_4 do
		local var_8_9 = arg_8_2[iter_8_0]
		local var_8_10 = false

		if var_8_9.mutators then
			local var_8_11 = {}

			for iter_8_1 in string.gmatch(var_8_9.mutators, "([^[%s,]+)%s*,?%s*") do
				var_8_11[#var_8_11 + 1] = iter_8_1
			end

			if #var_8_11 ~= #var_8_7 then
				table.sort(var_8_11)

				var_8_7 = var_8_11
				var_8_10 = true
			else
				table.sort(var_8_11)

				for iter_8_2, iter_8_3 in ipairs(var_8_11) do
					if iter_8_3 ~= var_8_7[iter_8_2] then
						var_8_7 = var_8_11
						var_8_10 = true

						break
					end
				end
			end
		elseif #var_8_7 > 0 then
			var_8_7 = {}
			var_8_10 = true
		end

		local var_8_12 = false
		local var_8_13 = var_8_9.roaming_set

		if var_8_13 then
			if var_8_13 == "random" then
				var_8_13 = var_8_5[var_8_6].name
				var_8_6 = var_8_6 + 1
			end

			arg_8_0 = ConflictDirectors[var_8_13]
			var_8_8 = arg_8_0.name
			var_8_12 = true
		end

		if var_8_10 or var_8_12 then
			local var_8_14 = arg_8_0.pack_spawning

			if var_8_14 then
				var_8_3 = MutatorHandler.tweak_pack_spawning_settings(var_8_7, arg_8_1, var_8_8, var_8_14)
			end
		end

		local var_8_15 = {}
		local var_8_16 = var_8_9.sub_areas[1]
		local var_8_17 = var_8_3.roaming_set.breed_packs
		local var_8_18 = {
			total_area = 0,
			nodes = var_8_9.sub[1],
			area = var_8_9.sub_areas[1],
			outer = var_8_15,
			pack_type = var_8_17,
			pack_spawning_setting = var_8_3,
			conflict_setting = arg_8_0,
			unique_zone_id = var_8_9.unique_zone_id,
			mutators = var_8_7
		}

		for iter_8_4 = 2, #var_8_9.sub do
			local var_8_19 = var_8_9.sub_areas[iter_8_4]

			var_8_16 = var_8_16 + (var_8_19 or 0)
			var_8_15[#var_8_15 + 1] = {
				nodes = var_8_9.sub[iter_8_4],
				area = var_8_19
			}
		end

		var_8_18.total_area = var_8_16
		var_8_0 = var_8_0 + var_8_9.sub_zone_length
		var_8_1[#var_8_1 + 1] = var_8_18
		arg_8_3[iter_8_0] = var_8_18

		if arg_8_5 <= var_8_0 or iter_8_0 == arg_8_4 then
			var_8_2[#var_8_2 + 1] = {
				zones = var_8_1,
				length = var_8_0
			}
			var_8_0 = var_8_0 - arg_8_5
			var_8_1 = {}
		end
	end

	return var_8_2
end

MainPathSpawningGenerator.process_conflict_directors_zones = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = {}
	local var_9_1 = 0

	if arg_9_2 > 0 then
		if arg_9_1[1].roaming_set == nil then
			var_9_0[arg_9_0] = true
		end

		for iter_9_0 = 1, arg_9_2 do
			local var_9_2 = arg_9_1[iter_9_0]
			local var_9_3 = var_9_2.roaming_set

			if var_9_3 then
				local var_9_4 = string.split_deprecated(var_9_3, "/")
				local var_9_5
				local var_9_6

				arg_9_3, var_9_6 = Math.next_random(arg_9_3, 1, #var_9_4)

				local var_9_7 = var_9_4[var_9_6]

				var_9_2.roaming_set = var_9_7

				if var_9_7 == "random" then
					var_9_1 = var_9_1 + 1
				else
					var_9_0[var_9_7] = true
				end
			end
		end
	else
		var_9_0[arg_9_0] = true
	end

	return var_9_0, var_9_1, arg_9_3
end
