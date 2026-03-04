-- chunkname: @scripts/utils/navigation_group_manager.lua

require("foundation/scripts/util/math")
require("scripts/utils/navigation_group")

NavigationGroupManager = class(NavigationGroupManager)

local var_0_0 = 20

NavigationGroupManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._navigation_groups = {}
	arg_1_0._registered_polygons = {}
	arg_1_0._world = nil
	arg_1_0._level = nil
	arg_1_0.nav_world = nil
	arg_1_0._groups_max_radius = 20
	arg_1_0._finish_point = nil
	arg_1_0._num_groups = 0
	arg_1_0._printing_groups = false
	arg_1_0._numb = 0
	arg_1_0._using_editor = arg_1_1
end

NavigationGroupManager.setup = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._world = arg_2_1
	arg_2_0.nav_world = arg_2_2
	arg_2_0.operational = true
end

NavigationGroupManager.form_groups = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	print("Forming navigation groups")
	assert(arg_3_2 ~= nil, "Got nil for finish_point")

	local var_3_0 = os.clock()

	arg_3_0._groups_max_radius = arg_3_1 or arg_3_0._groups_max_radius
	arg_3_0._finish_point = arg_3_2

	local var_3_1 = arg_3_0.nav_world
	local var_3_2 = arg_3_3

	if not arg_3_3 then
		local var_3_3 = Managers.state.game_mode:level_key()

		var_3_2 = LevelSettings[var_3_3].level_name
	end

	if LevelResource.nested_level_count(var_3_2) > 0 then
		var_3_2 = LevelResource.nested_level_resource_name(var_3_2, 0)
	end

	local var_3_4 = LevelResource.unit_indices(var_3_2, "core/gwnav/units/seedpoint/seedpoint")

	arg_3_0._num_groups = 0

	local var_3_5 = GwNavTraversal.get_seed_triangle(var_3_1, arg_3_2:unbox())
	local var_3_6 = {}
	local var_3_7 = {}

	arg_3_0._in_group_queue_pos = 0
	arg_3_0._rejected_queue_pos = 0
	var_3_6[#var_3_6 + 1] = var_3_5
	arg_3_0._iter_count = -999999

	arg_3_0:assign_group(nil, var_3_6, var_3_7)

	local var_3_8 = os.clock()

	print("NavigationGroupManager -> calulation time A:", var_3_8 - var_3_0)

	for iter_3_0, iter_3_1 in ipairs(var_3_4) do
		local var_3_9 = LevelResource.unit_position(var_3_2, iter_3_1)
		local var_3_10 = GwNavTraversal.get_seed_triangle(var_3_1, var_3_9)
		local var_3_11 = {}
		local var_3_12 = {}

		arg_3_0._in_group_queue_pos = 0
		arg_3_0._rejected_queue_pos = 0
		var_3_11[#var_3_11 + 1] = var_3_10

		arg_3_0:assign_group(nil, var_3_11, var_3_12)
	end

	local var_3_13 = os.clock()

	print("NavigationGroupManager -> calulation time B:", var_3_13 - var_3_8)
	print("number of nav groups: ", arg_3_0._num_groups)
	arg_3_0:refine_groups()
	print("number of refined nav groups : ", arg_3_0._num_groups)
	arg_3_0:calc_distances_from_finish_for_all(var_3_6)

	if not arg_3_0._using_editor then
		arg_3_0:make_sure_group_centers_are_on_mesh()
		arg_3_0:knit_groups_with_ledges()
	end

	print("NavigationGroupManager -> calulation time C:", os.clock() - var_3_13)
end

NavigationGroupManager.form_groups_start = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	print("NavigationGroupManager -> form_groups_start")
	assert(arg_4_2 ~= nil, "Got nil for finish_point")

	arg_4_0._groups_max_radius = arg_4_1 or arg_4_0._groups_max_radius
	arg_4_0._finish_point = arg_4_2

	local var_4_0 = arg_4_0.nav_world
	local var_4_1 = arg_4_3

	if not arg_4_3 then
		local var_4_2 = Managers.state.game_mode:level_key()

		var_4_1 = LevelSettings[var_4_2].level_name
	end

	if LevelResource.nested_level_count(var_4_1) > 0 then
		var_4_1 = LevelResource.nested_level_resource_name(var_4_1, 0)
	end

	arg_4_0._seedpoint_unit_indices = LevelResource.unit_indices(var_4_1, "core/gwnav/units/seedpoint/seedpoint")
	arg_4_0._level_name = var_4_1
	arg_4_0._num_groups = 0

	local var_4_3 = GwNavTraversal.get_seed_triangle(var_4_0, arg_4_2:unbox())
	local var_4_4 = {}
	local var_4_5 = {}

	arg_4_0._in_group_queue_pos = 0
	arg_4_0._rejected_queue_pos = 0
	var_4_4[#var_4_4 + 1] = var_4_3
	arg_4_0._current_group = nil
	arg_4_0._in_group_queue = var_4_4
	arg_4_0._rejected_queue = var_4_5
	arg_4_0._backup_group_queue = var_4_4
	arg_4_0.form_groups_running = true
	arg_4_0._sum_iter_count = 0
	arg_4_0._spawn_point_index = 0

	arg_4_0:form_groups_update()
end

local var_0_1 = IS_WINDOWS and 1000 or 400

NavigationGroupManager.form_groups_update = function (arg_5_0)
	print("NavigationGroupManager -> form_groups_update")
	Debug.text("NavigationGroupManager: %d ", arg_5_0._sum_iter_count)

	local var_5_0 = os.clock()

	arg_5_0._iter_count = 0

	local var_5_1 = false

	arg_5_0.form_groups_running = true

	while arg_5_0._iter_count < var_0_1 do
		local var_5_2, var_5_3, var_5_4 = arg_5_0:assign_group(arg_5_0._current_group, arg_5_0._in_group_queue, arg_5_0._rejected_queue)
		local var_5_5 = not var_5_3

		arg_5_0._sum_iter_count = arg_5_0._sum_iter_count + arg_5_0._iter_count

		print("\t\tworking on group -> count:", arg_5_0._iter_count)

		if var_5_5 then
			arg_5_0._spawn_point_index = arg_5_0._spawn_point_index + 1

			local var_5_6 = arg_5_0._seedpoint_unit_indices[arg_5_0._spawn_point_index]

			if var_5_6 then
				print("\t\tpop next seed point")

				local var_5_7 = LevelResource.unit_position(arg_5_0._level_name, var_5_6)
				local var_5_8 = GwNavTraversal.get_seed_triangle(arg_5_0.nav_world, var_5_7)

				arg_5_0._in_group_queue = {}
				arg_5_0._rejected_queue = {}
				arg_5_0._current_group = nil
				arg_5_0._in_group_queue_pos = 0
				arg_5_0._rejected_queue_pos = 0
				arg_5_0._in_group_queue[#arg_5_0._in_group_queue + 1] = var_5_8
				arg_5_0._iter_count = 0
			else
				arg_5_0:form_groups_end()

				arg_5_0.form_groups_running = false
				var_5_1 = true

				break
			end
		else
			arg_5_0._current_group = var_5_2
			arg_5_0._in_group_queue = var_5_3
			arg_5_0._rejected_queue = var_5_4
		end
	end

	print("\t-> time:", os.clock() - var_5_0, "sum:", arg_5_0._sum_iter_count)

	return var_5_1
end

NavigationGroupManager.form_groups_end = function (arg_6_0)
	local var_6_0 = os.clock()

	print("\t-> number of nav groups: ", arg_6_0._num_groups)
	arg_6_0:refine_groups()
	print("\t-> number of refined nav groups : ", arg_6_0._num_groups)
	arg_6_0:calc_distances_from_finish_for_all(arg_6_0._backup_group_queue)

	if not arg_6_0._using_editor then
		arg_6_0:make_sure_group_centers_are_on_mesh()
		arg_6_0:knit_groups_with_ledges()
	end

	print("NavigationGroupManager -> form_groups_end time:", os.clock() - var_6_0)
end

NavigationGroupManager._breadth_first_fill_main_path_index = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {
		starting_nav_group = true
	}
	local var_7_1 = {
		arg_7_2
	}
	local var_7_2 = 1
	local var_7_3 = #var_7_1 + 1

	while var_7_2 < var_7_3 do
		local var_7_4 = var_7_1[var_7_2]

		if var_7_4:get_main_path_index() == nil then
			var_7_4:set_main_path_index(arg_7_1)

			local var_7_5 = var_7_4:get_group_neighbours()
			local var_7_6 = var_7_4:get_group_ledge_neighbours()

			for iter_7_0, iter_7_1 in pairs(var_7_5) do
				if not var_7_0[iter_7_0] and not var_7_6[iter_7_0] then
					var_7_0[iter_7_0] = true
					var_7_1[var_7_3] = iter_7_0
					var_7_3 = var_7_3 + 1
				end
			end
		end

		var_7_2 = var_7_2 + 1
	end
end

NavigationGroupManager.assign_main_path_indexes = function (arg_8_0, arg_8_1)
	local var_8_0 = os.clock()
	local var_8_1 = Script.set_temp_count
	local var_8_2 = Script.temp_count

	for iter_8_0 = 1, #arg_8_1 do
		local var_8_3 = arg_8_1[iter_8_0].nodes

		for iter_8_1 = 1, #var_8_3 do
			local var_8_4, var_8_5, var_8_6 = var_8_2()
			local var_8_7 = var_8_3[iter_8_1]:unbox()
			local var_8_8 = arg_8_0:get_group_from_position(var_8_7)

			if var_8_8 then
				arg_8_0:_breadth_first_fill_main_path_index(iter_8_0, var_8_8)

				break
			end

			var_8_1(var_8_4, var_8_5, var_8_6)
		end
	end

	print("NavigationGroupManager -> assign_main_path_indexes time:", os.clock() - var_8_0)
end

NavigationGroupManager.assign_group = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0, var_9_1, var_9_2 = Script.temp_count()

	arg_9_0._iter_count = arg_9_0._iter_count + 1

	local var_9_3, var_9_4, var_9_5 = arg_9_0:next_poly_in_queue(arg_9_2, arg_9_3)

	var_9_5 = var_9_5 or not arg_9_1

	if not var_9_3 then
		return
	end

	if var_9_5 then
		arg_9_1 = arg_9_0:create_group(arg_9_0.nav_world, var_9_4, var_9_3)
		arg_9_2 = arg_9_0:add_neighbours_to_queue(var_9_3, arg_9_1, arg_9_2)
	elseif arg_9_0:in_range(var_9_3, arg_9_1) then
		if var_9_4 ~= arg_9_1:get_group_center_poly() then
			arg_9_0:join_group(var_9_3, var_9_4, arg_9_1)
		else
			arg_9_0._registered_polygons[var_9_4] = arg_9_1
		end

		arg_9_2 = arg_9_0:add_neighbours_to_queue(var_9_3, arg_9_1, arg_9_2)
	else
		arg_9_3[#arg_9_3 + 1] = var_9_3
	end

	Script.set_temp_count(var_9_0, var_9_1, var_9_2)

	if arg_9_0._iter_count > var_0_1 then
		return arg_9_1, arg_9_2, arg_9_3
	end

	return arg_9_0:assign_group(arg_9_1, arg_9_2, arg_9_3)
end

NavigationGroupManager.next_poly_in_queue = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._in_group_queue_pos = arg_10_0._in_group_queue_pos + 1

	local var_10_0 = arg_10_1[arg_10_0._in_group_queue_pos]
	local var_10_1, var_10_2 = arg_10_0:poly_is_valid(var_10_0)
	local var_10_3 = false

	if not var_10_1 then
		arg_10_0._in_group_queue_pos = arg_10_0._in_group_queue_pos - 1
		var_10_3 = true

		repeat
			arg_10_0._rejected_queue_pos = arg_10_0._rejected_queue_pos + 1
			var_10_0 = arg_10_2[arg_10_0._rejected_queue_pos]

			local var_10_4

			var_10_4, var_10_2 = arg_10_0:poly_is_valid(var_10_0)

			if var_10_4 == nil then
				arg_10_0._rejected_queue_pos = arg_10_0._rejected_queue_pos - 1

				return false, false
			end
		until var_10_4
	end

	if var_10_3 then
		arg_10_0:unmark_polys(arg_10_2)
	end

	return var_10_0, var_10_2, var_10_3
end

NavigationGroupManager.poly_is_valid = function (arg_11_0, arg_11_1)
	local var_11_0 = false
	local var_11_1 = false

	if arg_11_1 then
		var_11_0 = arg_11_0:get_poly_hash(arg_11_1)

		if arg_11_0._registered_polygons[var_11_0] == nil or arg_11_0._registered_polygons[var_11_0] == true then
			var_11_1 = true
		end
	else
		return nil, nil
	end

	return var_11_1, var_11_0
end

NavigationGroupManager.unmark_polys = function (arg_12_0, arg_12_1)
	for iter_12_0 = arg_12_0._rejected_queue_pos, #arg_12_1 do
		local var_12_0 = arg_12_1[iter_12_0]
		local var_12_1 = arg_12_0:get_poly_hash(var_12_0)

		if arg_12_0._registered_polygons[var_12_1] == true then
			arg_12_0._registered_polygons[var_12_1] = nil
		end
	end
end

NavigationGroupManager.add_neighbours_to_queue = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0:get_neighbours(arg_13_1)
	local var_13_1 = arg_13_0:get_poly_hash(arg_13_1)

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		local var_13_2 = arg_13_0:get_poly_hash(iter_13_1)
		local var_13_3 = arg_13_0._registered_polygons[var_13_2]

		if var_13_3 == nil then
			arg_13_3[#arg_13_3 + 1] = iter_13_1
			arg_13_0._registered_polygons[var_13_2] = true
		elseif var_13_3 ~= true and arg_13_2 ~= var_13_3 then
			arg_13_2:add_neighbour_group(var_13_3)
			var_13_3:add_neighbour_group(arg_13_2)
		end
	end

	return arg_13_3
end

NavigationGroupManager.refine_groups = function (arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0._navigation_groups) do
		local var_14_0 = iter_14_0:get_group_area()
		local var_14_1 = iter_14_0:get_group_neighbours()
		local var_14_2 = table.size(var_14_1)

		if var_14_0 < var_0_0 and var_14_2 > 0 then
			local var_14_3 = iter_14_0:get_group_polygons()
			local var_14_4 = arg_14_0:find_smallest_neighbour_group(iter_14_0)
			local var_14_5, var_14_6, var_14_7 = Script.temp_count()

			for iter_14_2, iter_14_3 in pairs(var_14_3) do
				local var_14_8 = arg_14_0:get_poly_hash(iter_14_3)

				arg_14_0:join_group(iter_14_3, var_14_8, var_14_4)
			end

			Script.set_temp_count(var_14_5, var_14_6, var_14_7)

			for iter_14_4, iter_14_5 in pairs(var_14_1) do
				iter_14_4:remove_neighbour_group(iter_14_0)

				if iter_14_4 ~= var_14_4 then
					iter_14_4:add_neighbour_group(var_14_4)
					var_14_4:add_neighbour_group(iter_14_4)
				end
			end

			arg_14_0._navigation_groups[iter_14_0] = nil
			arg_14_0._num_groups = arg_14_0._num_groups - 1

			iter_14_0:destroy(arg_14_0._world)

			iter_14_0 = nil
		end
	end
end

local function var_0_2(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0, var_15_1 = GwNavQueries.triangle_from_position(arg_15_0, arg_15_1, arg_15_2, arg_15_3)

	if var_15_0 then
		arg_15_1.z = var_15_1

		return arg_15_1
	end
end

NavigationGroupManager.make_sure_group_centers_are_on_mesh = function (arg_16_0)
	for iter_16_0, iter_16_1 in pairs(arg_16_0._navigation_groups) do
		local var_16_0 = iter_16_0._group_center:unbox()
		local var_16_1, var_16_2 = GwNavQueries.triangle_from_position(arg_16_0.nav_world, var_16_0, 1, 1)

		if not var_16_1 then
			var_16_1, var_16_2 = GwNavQueries.triangle_from_position(arg_16_0.nav_world, var_16_0, 2.5, 2.5)
		end

		if not var_16_1 then
			var_16_1, var_16_2 = GwNavQueries.triangle_from_position(arg_16_0.nav_world, var_16_0, 5, 5)
		end

		if var_16_1 then
			var_16_0.z = var_16_2

			iter_16_0._group_center:store(var_16_0)
		else
			local var_16_3 = GwNavTraversal.get_seed_triangle(arg_16_0.nav_world, var_16_0)

			if var_16_3 then
				local var_16_4, var_16_5, var_16_6 = GwNavTraversal.get_triangle_vertices(arg_16_0.nav_world, var_16_3)
				local var_16_7 = (var_16_4 + var_16_5 + var_16_6) / 3

				iter_16_0._group_center:store(var_16_7)
			else
				local var_16_8 = GwNavQueries.inside_position_from_outside_position(arg_16_0.nav_world, var_16_0 + Vector3(0, 0, 2), 0, 4, 4, 0.1)

				if var_16_8 then
					iter_16_0._group_center:store(var_16_8)
				end
			end
		end
	end
end

NavigationGroupManager.find_smallest_neighbour_group = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1:get_group_neighbours()
	local var_17_1 = next(var_17_0, nil)
	local var_17_2 = var_17_1:get_group_area()

	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		local var_17_3 = iter_17_0:get_group_area()

		if var_17_3 < var_17_2 then
			var_17_1 = iter_17_0
			var_17_2 = var_17_3
		end
	end

	return var_17_1
end

NavigationGroupManager.calc_distances_from_finish_for_all = function (arg_18_0, arg_18_1)
	local var_18_0, var_18_1, var_18_2 = Script.temp_count()
	local var_18_3 = GwNavTraversal.get_seed_triangle(arg_18_0.nav_world, arg_18_0._finish_point:unbox())
	local var_18_4 = arg_18_0:get_poly_hash(var_18_3)

	for iter_18_0, iter_18_1 in ipairs(arg_18_1) do
		repeat
			Script.set_temp_count(var_18_0, var_18_1, var_18_2)

			local var_18_5 = arg_18_0:get_poly_hash(iter_18_1)
			local var_18_6 = arg_18_0._registered_polygons[var_18_5]
			local var_18_7 = false

			if var_18_6:get_distance_from_finish() ~= math.huge then
				break
			end

			if var_18_6 == arg_18_0._registered_polygons[var_18_4] then
				var_18_7 = true
			end

			local var_18_8 = arg_18_0:calc_distance_from_finish(var_18_6, var_18_7)

			var_18_6:set_distance_from_finish(var_18_8)
		until true
	end
end

NavigationGroupManager.get_neighbours = function (arg_19_0, arg_19_1)
	return {
		GwNavTraversal.get_neighboring_triangles(arg_19_1)
	}
end

NavigationGroupManager.create_group = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0:calc_polygon_center(arg_20_3)
	local var_20_1 = arg_20_0:calc_polygon_area(arg_20_3)

	arg_20_0._num_groups = arg_20_0._num_groups + 1

	local var_20_2 = NavigationGroup:new(arg_20_0.nav_world, arg_20_2, arg_20_3, var_20_0, var_20_1, arg_20_0._num_groups)

	arg_20_0._navigation_groups[var_20_2] = true
	arg_20_0._registered_polygons[arg_20_2] = var_20_2

	return var_20_2
end

NavigationGroupManager.join_group = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0:calc_polygon_area(arg_21_1)
	local var_21_1 = arg_21_0:calc_polygon_center(arg_21_1)

	arg_21_3:add_polygon(arg_21_1, var_21_1, var_21_0, arg_21_0.nav_world)

	arg_21_0._registered_polygons[arg_21_2] = arg_21_3
end

NavigationGroupManager.in_range = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0:calc_polygon_center(arg_22_1) - arg_22_2:get_group_center():unbox()

	return Vector3.length(var_22_0) <= arg_22_0._groups_max_radius and math.abs(var_22_0.z) < 2.5
end

NavigationGroupManager.calc_distance_from_finish = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = math.huge
	local var_23_1 = arg_23_1:get_group_center()

	if arg_23_2 then
		var_23_0 = Vector3.distance(var_23_1:unbox(), arg_23_0._finish_point:unbox())
	else
		local var_23_2 = arg_23_1:get_group_neighbours()
		local var_23_3 = next(var_23_2, nil)

		if not var_23_3 then
			return var_23_0
		end

		for iter_23_0, iter_23_1 in pairs(var_23_2) do
			local var_23_4 = iter_23_0:get_distance_from_finish()

			if var_23_4 < var_23_0 then
				var_23_0 = var_23_4
				var_23_3 = iter_23_0
			end
		end

		var_23_0 = var_23_0 + Vector3.distance(var_23_1:unbox(), var_23_3:get_group_center():unbox())
	end

	return var_23_0
end

NavigationGroupManager.calc_polygon_center = function (arg_24_0, arg_24_1)
	local var_24_0, var_24_1, var_24_2 = GwNavTraversal.get_triangle_vertices(arg_24_0.nav_world, arg_24_1)

	return (var_24_0 + var_24_1 + var_24_2) / 3
end

NavigationGroupManager.calc_polygon_area = function (arg_25_0, arg_25_1)
	local var_25_0, var_25_1, var_25_2 = arg_25_0:get_polygon_sides(arg_25_1)
	local var_25_3 = (var_25_0 + var_25_1 + var_25_2) / 2

	return (math.sqrt(var_25_3 * (var_25_3 - var_25_0) * (var_25_3 - var_25_1) * (var_25_3 - var_25_2)))
end

NavigationGroupManager.get_polygon_sides = function (arg_26_0, arg_26_1)
	local var_26_0, var_26_1, var_26_2 = GwNavTraversal.get_triangle_vertices(arg_26_0.nav_world, arg_26_1)
	local var_26_3
	local var_26_4
	local var_26_5
	local var_26_6 = Vector3.distance(var_26_0, var_26_1)
	local var_26_7 = Vector3.distance(var_26_0, var_26_2)
	local var_26_8 = Vector3.distance(var_26_1, var_26_2)

	return var_26_6, var_26_7, var_26_8
end

NavigationGroupManager.destroy = function (arg_27_0, arg_27_1)
	arg_27_0:destroy_gui(arg_27_1)

	for iter_27_0, iter_27_1 in pairs(arg_27_0._navigation_groups) do
		iter_27_0:destroy(arg_27_1)

		iter_27_0 = nil
	end

	arg_27_0.operational = nil
	arg_27_0._navigation_groups = {}
	arg_27_0._registered_polygons = {}
end

NavigationGroupManager.get_group_from_position = function (arg_28_0, arg_28_1)
	local var_28_0 = GwNavTraversal.get_seed_triangle(arg_28_0.nav_world, arg_28_1)

	if not var_28_0 then
		return
	end

	return (arg_28_0:get_polygon_group(var_28_0))
end

NavigationGroupManager.get_polygon_group = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0:get_poly_hash(arg_29_1)
	local var_29_1 = arg_29_0._registered_polygons[var_29_0]

	if var_29_1 then
		return var_29_1
	end

	return (arg_29_0:breadth_first_search_neighbours(arg_29_1))
end

NavigationGroupManager.draw_tri = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_2 = arg_30_2 or 0.1

	local var_30_0, var_30_1, var_30_2 = GwNavTraversal.get_triangle_vertices(arg_30_0.nav_world, arg_30_1)
	local var_30_3 = var_30_0 + Vector3(0, 0, arg_30_2)
	local var_30_4 = var_30_1 + Vector3(0, 0, arg_30_2)
	local var_30_5 = var_30_2 + Vector3(0, 0, arg_30_2)

	QuickDrawerStay:line(var_30_3, var_30_4, arg_30_3)
	QuickDrawerStay:line(var_30_4, var_30_5, arg_30_3)
	QuickDrawerStay:line(var_30_5, var_30_3, arg_30_3)
end

local var_0_3 = {}
local var_0_4 = {}
local var_0_5 = {}

NavigationGroupManager.breadth_first_search_neighbours = function (arg_31_0, arg_31_1)
	table.clear(var_0_5)
	table.clear(var_0_4)

	local var_31_0 = 1
	local var_31_1 = var_0_3
	local var_31_2 = 1
	local var_31_3 = 1

	var_31_1[1] = arg_31_1

	local var_31_4 = arg_31_0:get_poly_hash(arg_31_1)

	var_0_5[var_31_4] = true

	while var_31_2 <= var_31_3 do
		local var_31_5 = var_31_1[var_31_2]
		local var_31_6 = arg_31_0:get_poly_hash(var_31_5)

		var_31_2 = var_31_2 + 1
		var_31_0 = var_31_0 + 1

		local var_31_7 = arg_31_0._registered_polygons[var_31_6]

		if var_31_7 then
			for iter_31_0, iter_31_1 in pairs(var_0_4) do
				arg_31_0:join_group(iter_31_1, iter_31_0, var_31_7)
			end

			return var_31_7
		end

		var_0_4[var_31_6] = var_31_5

		local var_31_8 = {
			GwNavTraversal.get_neighboring_triangles(var_31_5)
		}

		for iter_31_2 = 1, #var_31_8 do
			local var_31_9, var_31_10, var_31_11 = Script.temp_count()
			local var_31_12 = var_31_8[iter_31_2]
			local var_31_13 = arg_31_0:get_poly_hash(var_31_12)

			if not var_0_5[var_31_13] then
				var_31_3 = var_31_3 + 1
				var_31_1[var_31_3] = var_31_12
				var_0_5[var_31_13] = true
			end

			Script.set_temp_count(var_31_9, var_31_10, var_31_11)
		end

		if var_31_0 > 1000 then
			local var_31_14, var_31_15, var_31_16 = GwNavTraversal.get_triangle_vertices(arg_31_0.nav_world, arg_31_1)

			print("WARNING navigation group patching failed. Triangle at:", var_31_14)

			break
		end
	end
end

NavigationGroupManager.get_group_polygons = function (arg_32_0, arg_32_1)
	return arg_32_0:get_polygon_group(arg_32_1):get_group_polygons()
end

NavigationGroupManager.get_group_center = function (arg_33_0, arg_33_1)
	return arg_33_0:get_polygon_group(arg_33_1):get_group_center()
end

NavigationGroupManager.get_poly_hash = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0:calc_polygon_center(arg_34_1)

	return var_34_0.x * 0.0001 + var_34_0.y + var_34_0.z * 10000
end

NavigationGroupManager.get_group_centers = function (arg_35_0, arg_35_1)
	local var_35_0, var_35_1, var_35_2 = Script.temp_count()

	for iter_35_0, iter_35_1 in pairs(arg_35_0._navigation_groups) do
		local var_35_3 = iter_35_0:get_group_center()

		table.insert(arg_35_1, var_35_3)
	end

	Script.set_temp_count(var_35_0, var_35_1, var_35_2)

	return arg_35_1
end

NavigationGroupManager.get_group_polygons_centers = function (arg_36_0, arg_36_1)
	for iter_36_0, iter_36_1 in pairs(arg_36_0._navigation_groups) do
		local var_36_0, var_36_1, var_36_2 = Script.temp_count()

		arg_36_1 = iter_36_0:get_group_polygons_centers(arg_36_1)

		Script.set_temp_count(var_36_0, var_36_1, var_36_2)
	end

	return arg_36_1
end

NavigationGroupManager.print_groups = function (arg_37_0, arg_37_1, arg_37_2)
	local var_37_0, var_37_1, var_37_2 = Script.temp_count()
	local var_37_3 = not not script_data.debug_navigation_group_manager

	if var_37_3 == arg_37_0._printing_groups then
		return
	end

	if var_37_3 then
		arg_37_0._line_object = arg_37_0._line_object or World.create_line_object(arg_37_0._world, false)
		arg_37_0._drawer = arg_37_0._drawer or Managers.state.debug:drawer({
			mode = "perm",
			name = "nav_group"
		})
		arg_37_0._debug_world_gui = World.create_world_gui(arg_37_1, Matrix4x4.identity(), 1, 1, "material", "materials/fonts/gw_fonts")

		local var_37_4 = arg_37_0._debug_world_gui
		local var_37_5, var_37_6, var_37_7 = Script.temp_count()

		for iter_37_0, iter_37_1 in pairs(arg_37_0._navigation_groups) do
			iter_37_0:print_group(arg_37_1, arg_37_2, arg_37_0._line_object, arg_37_0._drawer, var_37_4)
		end

		Script.set_temp_count(var_37_5, var_37_6, var_37_7)
	else
		arg_37_0:destroy_gui(arg_37_1)
	end

	arg_37_0._printing_groups = var_37_3

	Script.set_temp_count(var_37_0, var_37_1, var_37_2)

	if arg_37_0._line_object then
		LineObject.dispatch(arg_37_1, arg_37_0._line_object)
	end
end

NavigationGroupManager.destroy_gui = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._line_object

	if not var_38_0 then
		return
	end

	arg_38_0._drawer:reset()
	LineObject.reset(var_38_0)
	LineObject.dispatch(arg_38_1, var_38_0)
	World.destroy_line_object(arg_38_1, var_38_0)

	arg_38_0._line_object = nil

	World.destroy_gui(arg_38_1, arg_38_0._debug_world_gui)
end

NavigationGroupManager.a_star_cached = function (arg_39_0, arg_39_1, arg_39_2)
	return LuaAStar.a_star_cached(arg_39_0._navigation_groups, arg_39_1, arg_39_2)
end

NavigationGroupManager.a_star_cached_between_positions = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = GwNavTraversal.get_seed_triangle(arg_40_0.nav_world, arg_40_1)
	local var_40_1 = GwNavTraversal.get_seed_triangle(arg_40_0.nav_world, arg_40_2)

	if not var_40_0 or not var_40_1 then
		return false
	end

	local var_40_2 = arg_40_0:get_polygon_group(var_40_0)
	local var_40_3 = arg_40_0:get_polygon_group(var_40_1)

	if not var_40_2 or not var_40_3 then
		print("CACHED ASTAR FAIL")

		return false
	end

	return LuaAStar.a_star_cached(arg_40_0._navigation_groups, var_40_2, var_40_3)
end

NavigationGroupManager.draw_group_path = function (arg_41_0, arg_41_1)
	local var_41_0 = Color(255, 200, 255, 10)
	local var_41_1 = arg_41_1[1]._group_center:unbox()
	local var_41_2

	for iter_41_0 = 2, #arg_41_1 do
		local var_41_3 = arg_41_1[iter_41_0]._group_center:unbox()

		QuickDrawerStay:line(var_41_1, var_41_3, var_41_0)

		var_41_1 = var_41_3
	end
end

NavigationGroupManager.draw_group_connections = function (arg_42_0)
	local var_42_0 = Color(255, 255, 128, 128)
	local var_42_1 = Vector3(0, 0, 1)

	for iter_42_0, iter_42_1 in pairs(arg_42_0._navigation_groups) do
		for iter_42_2, iter_42_3 in pairs(iter_42_0._group_neighbours) do
			local var_42_2 = iter_42_0._group_center:unbox() + var_42_1
			local var_42_3 = iter_42_2._group_center:unbox() + var_42_1
			local var_42_4 = Vector3.normalize(var_42_3 - var_42_2)
			local var_42_5 = Vector3.cross(var_42_4, Vector3.up()) / 2
			local var_42_6 = string.format("dist=%.1f", Vector3.length(var_42_3 - var_42_2))

			Debug.world_sticky_text((var_42_3 + var_42_2) * 0.5, var_42_6, "red")
			QuickDrawerStay:line(var_42_2, var_42_3, var_42_0)

			local var_42_7 = var_42_3 - var_42_4

			QuickDrawerStay:line(var_42_7, var_42_7 - var_42_4 * 0.45 + var_42_5, var_42_0)
			QuickDrawerStay:line(var_42_7, var_42_7 - var_42_4 * 0.45 - var_42_5, var_42_0)
		end
	end
end

NavigationGroupManager.knit_groups_with_ledges = function (arg_43_0)
	local var_43_0 = Managers.state.entity:system("nav_graph_system").smart_objects

	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		for iter_43_2 = 1, #iter_43_1 do
			local var_43_1 = iter_43_1[iter_43_2]

			if not var_43_1.smart_object_type then
				local var_43_2 = "ledges"
			end

			local var_43_3 = Vector3Aux.unbox(var_43_1.pos1)
			local var_43_4 = arg_43_0:get_group_from_position(var_43_3)

			if var_43_4 then
				local var_43_5 = Vector3Aux.unbox(var_43_1.pos2)
				local var_43_6 = arg_43_0:get_group_from_position(var_43_5)

				if var_43_6 and var_43_4 ~= var_43_6 then
					if not var_43_4._group_neighbours[var_43_6] then
						var_43_4:add_neighbour_group(var_43_6, true)
					end

					if var_43_1.data.is_bidirectional and not var_43_6._group_neighbours[var_43_4] then
						var_43_6:add_neighbour_group(var_43_4, true)
					end
				end
			end
		end
	end
end

local function var_0_6(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = (arg_44_0 + arg_44_1 + arg_44_2) / 3

	return var_44_0.x * 0.0001 + var_44_0.y + var_44_0.z * 10000
end

NavigationGroupManager.breadth_first_search_all_triangles = function (arg_45_0, arg_45_1)
	local var_45_0 = os.clock()
	local var_45_1 = arg_45_0.nav_world
	local var_45_2 = arg_45_1 or GwNavTraversal.get_seed_triangle(var_45_1, arg_45_0._finish_point:unbox())

	if var_45_2 == nil then
		return
	end

	local var_45_3 = 1
	local var_45_4 = 0
	local var_45_5 = 0
	local var_45_6 = GwNavTraversal.are_triangles_equal
	local var_45_7 = GwNavTraversal.get_neighboring_triangles
	local var_45_8 = GwNavTraversal.get_triangle_vertices
	local var_45_9 = var_0_6(var_45_8(var_45_1, var_45_2))
	local var_45_10 = {
		var_45_2
	}
	local var_45_11 = {
		source_tri_hash = var_45_5
	}

	while var_45_4 < var_45_3 do
		var_45_4 = var_45_4 + 1

		local var_45_12 = var_45_10[var_45_4]
		local var_45_13 = {
			var_45_7(var_45_12)
		}

		for iter_45_0 = 1, #var_45_13 do
			local var_45_14 = var_45_13[iter_45_0]

			if var_45_14 then
				local var_45_15, var_45_16, var_45_17 = var_45_8(var_45_1, var_45_14)
				local var_45_18 = (var_45_15 + var_45_16 + var_45_17) / 3
				local var_45_19 = var_45_18.x * 0.0001 + var_45_18.y + var_45_18.z * 10000

				if not var_45_11[var_45_19] then
					var_45_3 = var_45_3 + 1
					var_45_10[var_45_3] = var_45_14
					var_45_11[var_45_19] = var_45_5
					var_45_5 = var_45_5 + 1
				end
			end
		end
	end

	local var_45_20 = os.clock()

	print("NavigationGroupManager -> traverse all triangles time:", var_45_20 - var_45_0, "Num triangles:", var_45_3)

	return var_45_11
end
