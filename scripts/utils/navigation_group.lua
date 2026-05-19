-- chunkname: @scripts/utils/navigation_group.lua

NavigationGroup = class(NavigationGroup)

function NavigationGroup.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0._center_poly = arg_1_2
	arg_1_0._area = 0
	arg_1_0._group_center = Vector3Box(arg_1_4)
	arg_1_0._distance_from_finish = math.huge
	arg_1_0._group_number = arg_1_6
	arg_1_0._group_polygons = {}
	arg_1_0._group_size = 0
	arg_1_0._group_neighbours = {}
	arg_1_0._group_ledge_neighbours = {}
	arg_1_0._main_path_index = nil

	arg_1_0:add_polygon(arg_1_3, arg_1_4, arg_1_5, arg_1_1)
end

function NavigationGroup.make_string_of_group(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 .. "{neighbours={"

	for iter_2_0, iter_2_1 in pairs(arg_2_0._group_neighbours) do
		local var_2_0 = iter_2_0._group_number

		arg_2_1 = arg_2_1 .. var_2_0 .. ","
	end

	arg_2_1 = arg_2_1 .. "}, group_polygons={"

	for iter_2_2, iter_2_3 in pairs(arg_2_0._group_polygons) do
		arg_2_1 = arg_2_1 .. "[\"" .. iter_2_2 .. "\"]=" .. tostring(iter_2_3) .. ",\n"
	end

	arg_2_1 = arg_2_1 .. "}, dist_from_finish=" .. arg_2_0._distance_from_finish .. ", "

	return arg_2_1
end

function NavigationGroup.add_polygon(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0:get_poly_hash(arg_3_1, arg_3_4)

	arg_3_0._group_polygons[var_3_0] = arg_3_1
	arg_3_0._group_size = arg_3_0._group_size + 1
	arg_3_0._area = arg_3_0._area + arg_3_3

	if arg_3_2 ~= nil then
		arg_3_0:calculate_group_center(arg_3_2, var_3_0, arg_3_4)
	end
end

function NavigationGroup.add_neighbour_group(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._group_neighbours[arg_4_1] = true

	if arg_4_2 then
		arg_4_0._group_ledge_neighbours[arg_4_1] = true
	end
end

function NavigationGroup.remove_neighbour_group(arg_5_0, arg_5_1)
	arg_5_0._group_neighbours[arg_5_1] = nil

	if arg_5_0._group_ledge_neighbours[arg_5_1] then
		arg_5_0._group_ledge_neighbours[arg_5_1] = nil
	end
end

function NavigationGroup.set_main_path_index(arg_6_0, arg_6_1)
	arg_6_0._main_path_index = arg_6_1
end

function NavigationGroup.set_distance_from_finish(arg_7_0, arg_7_1)
	arg_7_0._distance_from_finish = arg_7_1
end

function NavigationGroup.get_group_neighbours(arg_8_0)
	return arg_8_0._group_neighbours
end

function NavigationGroup.get_group_ledge_neighbours(arg_9_0)
	return arg_9_0._group_ledge_neighbours
end

function NavigationGroup.get_main_path_index(arg_10_0)
	return arg_10_0._main_path_index
end

function NavigationGroup.calculate_group_center(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0._group_size
	local var_11_1 = arg_11_0._group_center:unbox()
	local var_11_2 = ((var_11_0 - 1) * var_11_1 + arg_11_1) / var_11_0
	local var_11_3 = GwNavTraversal.get_seed_triangle(arg_11_3, var_11_2)
	local var_11_4 = var_11_3 and arg_11_0:get_poly_hash(var_11_3, arg_11_3)

	if var_11_4 then
		local var_11_5, var_11_6, var_11_7 = Script.temp_count()

		if not arg_11_0._group_polygons[var_11_4] then
			var_11_2, var_11_4 = arg_11_0:breadth_first_find_nearest_group_triangle(var_11_3, arg_11_3)

			if var_11_2 == nil then
				print("Fallback: Will use", arg_11_1, "as center for nav group", arg_11_0._group_number)

				var_11_2, var_11_4 = arg_11_1, arg_11_2
			end
		end

		arg_11_0._group_center:store(var_11_2)

		arg_11_0._center_poly = var_11_4

		Script.set_temp_count(var_11_5, var_11_6, var_11_7)
	end
end

function NavigationGroup.get_group_polygons_centers(arg_12_0, arg_12_1, arg_12_2)
	error("not used?")

	local var_12_0

	for iter_12_0, iter_12_1 in pairs(arg_12_0._group_polygons) do
		local var_12_1, var_12_2, var_12_3 = Script.temp_count()
		local var_12_4 = arg_12_0:calc_polygon_center(iter_12_1, arg_12_2)

		table.insert(arg_12_1, Vector3Box(var_12_4))
		Script.set_temp_count(var_12_1, var_12_2, var_12_3)
	end

	return arg_12_1
end

function NavigationGroup.get_poly_center_from_hash(arg_13_0, arg_13_1)
	return arg_13_0._group_polygons[arg_13_1]
end

function NavigationGroup.get_group_center_poly(arg_14_0)
	return arg_14_0._center_poly
end

function NavigationGroup.get_group_center(arg_15_0)
	return arg_15_0._group_center
end

function NavigationGroup.get_group_area(arg_16_0)
	return arg_16_0._area
end

function NavigationGroup.get_group_polygons(arg_17_0)
	return arg_17_0._group_polygons
end

function NavigationGroup.get_group_size(arg_18_0)
	return arg_18_0._group_size
end

function NavigationGroup.get_distance_from_finish(arg_19_0)
	return arg_19_0._distance_from_finish
end

function NavigationGroup.destroy(arg_20_0)
	arg_20_0._group_neighbours = {}
	arg_20_0._group_polygons = {}
	arg_20_0._group_size = 0
end

function NavigationGroup.calc_polygon_center(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0, var_21_1, var_21_2 = GwNavTraversal.get_triangle_vertices(arg_21_2, arg_21_1)

	return (var_21_0 + var_21_1 + var_21_2) / 3
end

function NavigationGroup.get_poly_hash(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0, var_22_1, var_22_2 = Script.temp_count()
	local var_22_3 = arg_22_0:calc_polygon_center(arg_22_1, arg_22_2)
	local var_22_4 = var_22_3.x * 0.0001 + var_22_3.y + var_22_3.z * 10000

	Script.set_temp_count(var_22_0, var_22_1, var_22_2)

	return var_22_4
end

local var_0_0 = 1000

function NavigationGroup.breadth_first_find_nearest_group_triangle(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = FrameTable.alloc_table()
	local var_23_1 = FrameTable.alloc_table()
	local var_23_2 = 1
	local var_23_3 = 1

	var_23_1[1] = arg_23_1
	var_23_0[arg_23_0:get_poly_hash(arg_23_1, arg_23_2)] = true

	local var_23_4 = arg_23_0._group_polygons

	while var_23_2 <= var_23_3 do
		local var_23_5 = var_23_1[var_23_2]
		local var_23_6 = arg_23_0:get_poly_hash(var_23_5, arg_23_2)

		var_23_2 = var_23_2 + 1

		if var_23_4[var_23_6] then
			return arg_23_0:calc_polygon_center(var_23_5, arg_23_2), var_23_6
		end

		local var_23_7 = {
			GwNavTraversal.get_neighboring_triangles(var_23_5)
		}

		for iter_23_0 = 1, #var_23_7 do
			local var_23_8, var_23_9, var_23_10 = Script.temp_count()
			local var_23_11 = var_23_7[iter_23_0]
			local var_23_12 = arg_23_0:get_poly_hash(var_23_11, arg_23_2)

			if not var_23_0[var_23_12] then
				var_23_3 = var_23_3 + 1
				var_23_1[var_23_3] = var_23_11
				var_23_0[var_23_12] = true
			end

			Script.set_temp_count(var_23_8, var_23_9, var_23_10)
		end

		if var_23_2 > var_0_0 then
			local var_23_13, var_23_14, var_23_15 = GwNavTraversal.get_triangle_vertices(arg_23_2, arg_23_1)

			print("WARNING: Navigation Group Breadth First Search failed. Triangle at:", var_23_13)

			return nil, nil
		end
	end
end

function NavigationGroup.print_group(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = math.random(0, 255)
	local var_24_1 = math.random(0, 255)
	local var_24_2 = math.random(0, 255)
	local var_24_3 = Color(var_24_0, var_24_1, var_24_2)

	print("Group", arg_24_0._group_number, "has neighbours:")

	for iter_24_0, iter_24_1 in pairs(arg_24_0._group_neighbours) do
		print(iter_24_0._group_number, arg_24_0._group_ledge_neighbours[iter_24_0] and "connected_by_ledge" or "")
	end

	for iter_24_2, iter_24_3 in pairs(arg_24_0._group_polygons) do
		arg_24_0:draw_poly_lines(iter_24_3, var_24_3, arg_24_2, arg_24_3, arg_24_5)
	end

	local var_24_4 = Matrix4x4.identity()
	local var_24_5 = 1.2
	local var_24_6 = "materials/fonts/arial"
	local var_24_7 = "arial"
	local var_24_8 = arg_24_0._group_center:unbox()
	local var_24_9 = Vector3(var_24_8[1], var_24_8[3], var_24_8[2])

	arg_24_4:sphere(var_24_8, 0.07, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "C", var_24_6, var_24_5, var_24_7, var_24_4, var_24_9, 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "C", var_24_6, var_24_5 + 0.1, var_24_7, var_24_4, var_24_9 - Vector3(0.05, 0, 0), 2, Color(0, 0, 0))
	Gui.text_3d(arg_24_5, "id=" .. arg_24_0._group_number, var_24_6, var_24_5 - 0.8, var_24_7, var_24_4, var_24_9 + Vector3(0, 2, 0), 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "dist=" .. arg_24_0._distance_from_finish, var_24_6, var_24_5 - 0.8, var_24_7, var_24_4, var_24_9 + Vector3(0, 1.5, 0), 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "area=" .. arg_24_0._area, var_24_6, var_24_5 - 0.8, var_24_7, var_24_4, var_24_9 + Vector3(0, 1, 0), 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "main_path_index=" .. (arg_24_0._main_path_index or "nil"), var_24_6, var_24_5 - 0.8, var_24_7, var_24_4, var_24_9 + Vector3(0, 0.5, 0), 3, Color(255, 255, 255))
end

function NavigationGroup.draw_poly_lines(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0, var_25_1, var_25_2 = Script.temp_count()
	local var_25_3, var_25_4, var_25_5 = GwNavTraversal.get_triangle_vertices(arg_25_3, arg_25_1)
	local var_25_6 = var_25_3 + Vector3(0, 0, 0.1)
	local var_25_7 = var_25_4 + Vector3(0, 0, 0.1)
	local var_25_8 = var_25_5 + Vector3(0, 0, 0.1)

	LineObject.add_line(arg_25_4, arg_25_2, var_25_6, var_25_7)
	LineObject.add_line(arg_25_4, arg_25_2, var_25_6, var_25_8)
	LineObject.add_line(arg_25_4, arg_25_2, var_25_7, var_25_8)
	Script.set_temp_count(var_25_0, var_25_1, var_25_2)
end
