-- chunkname: @scripts/utils/navigation_group.lua

NavigationGroup = class(NavigationGroup)

NavigationGroup.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self._center_poly = arg_1_2
	self._area = 0
	self._group_center = Vector3Box(arg_1_4)
	self._distance_from_finish = math.huge
	self._group_number = arg_1_6
	self._group_polygons = {}
	self._group_size = 0
	self._group_neighbours = {}
	self._group_ledge_neighbours = {}
	self._main_path_index = nil

	self:add_polygon(arg_1_3, arg_1_4, arg_1_5, arg_1_1)
end

NavigationGroup.make_string_of_group = function (self, arg_2_1)
	-- function 2
	arg_2_1 = arg_2_1 .. "{neighbours={"

	for k, v in pairs(self._group_neighbours) do
		local _group_number = k._group_number

		arg_2_1 = arg_2_1 .. _group_number .. ","
	end

	arg_2_1 = arg_2_1 .. "}, group_polygons={"

	for k_2, v_2 in pairs(self._group_polygons) do
		arg_2_1 = arg_2_1 .. "[\"" .. k_2 .. "\"]=" .. tostring(v_2) .. ",\n"
	end

	arg_2_1 = arg_2_1 .. "}, dist_from_finish=" .. self._distance_from_finish .. ", "

	return arg_2_1
end

NavigationGroup.add_polygon = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local get_poly_hash = self:get_poly_hash(arg_3_1, arg_3_4)

	self._group_polygons[get_poly_hash] = arg_3_1
	self._group_size = self._group_size + 1
	self._area = self._area + arg_3_3

	if arg_3_2 ~= nil then
		self:calculate_group_center(arg_3_2, get_poly_hash, arg_3_4)
	end
end

NavigationGroup.add_neighbour_group = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	arg_4_0._group_neighbours[arg_4_1] = true

	if not arg_4_2 then
		arg_4_0._group_ledge_neighbours[arg_4_1] = true
	end
end

NavigationGroup.remove_neighbour_group = function (self, arg_5_1)
	-- function 5
	self._group_neighbours[arg_5_1] = nil

	if not self._group_ledge_neighbours[arg_5_1] then
		self._group_ledge_neighbours[arg_5_1] = nil
	end
end

NavigationGroup.set_main_path_index = function (self, arg_6_1)
	-- function 6
	self._main_path_index = arg_6_1
end

NavigationGroup.set_distance_from_finish = function (self, arg_7_1)
	-- function 7
	self._distance_from_finish = arg_7_1
end

NavigationGroup.get_group_neighbours = function (self)
	-- function 8
	return self._group_neighbours
end

NavigationGroup.get_group_ledge_neighbours = function (self)
	-- function 9
	return self._group_ledge_neighbours
end

NavigationGroup.get_main_path_index = function (self)
	-- function 10
	return self._main_path_index
end

NavigationGroup.calculate_group_center = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local _group_size = self._group_size
	local unbox = self._group_center:unbox()
	local num = ((_group_size - 1) * unbox + arg_11_1) / _group_size
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(arg_11_3, num)
	local flag = not get_seed_triangle and self:get_poly_hash(get_seed_triangle, arg_11_3)

	if not flag then
		local temp_count, var_11_6, var_11_7 = Script.temp_count()

		if not self._group_polygons[flag] then
			num, flag = self:breadth_first_find_nearest_group_triangle(get_seed_triangle, arg_11_3)

			if num == nil then
				print("Fallback: Will use", arg_11_1, "as center for nav group", self._group_number)

				num, flag = arg_11_1, arg_11_2
			end
		end

		self._group_center:store(num)

		self._center_poly = flag

		Script.set_temp_count(temp_count, var_11_6, var_11_7)
	end
end

NavigationGroup.get_group_polygons_centers = function (self, arg_12_1, arg_12_2)
	-- function 12
	error("not used?")

	local var_12_0

	for k, v in pairs(self._group_polygons) do
		local temp_count, var_12_2, var_12_3 = Script.temp_count()
		local calc_polygon_center = self:calc_polygon_center(v, arg_12_2)

		table.insert(arg_12_1, Vector3Box(calc_polygon_center))
		Script.set_temp_count(temp_count, var_12_2, var_12_3)
	end

	return arg_12_1
end

NavigationGroup.get_poly_center_from_hash = function (self, arg_13_1)
	-- function 13
	return self._group_polygons[arg_13_1]
end

NavigationGroup.get_group_center_poly = function (self)
	-- function 14
	return self._center_poly
end

NavigationGroup.get_group_center = function (self)
	-- function 15
	return self._group_center
end

NavigationGroup.get_group_area = function (self)
	-- function 16
	return self._area
end

NavigationGroup.get_group_polygons = function (self)
	-- function 17
	return self._group_polygons
end

NavigationGroup.get_group_size = function (self)
	-- function 18
	return self._group_size
end

NavigationGroup.get_distance_from_finish = function (self)
	-- function 19
	return self._distance_from_finish
end

NavigationGroup.destroy = function (self)
	-- function 20
	self._group_neighbours = {}
	self._group_polygons = {}
	self._group_size = 0
end

NavigationGroup.calc_polygon_center = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local get_triangle_vertices, var_21_1, var_21_2 = GwNavTraversal.get_triangle_vertices(arg_21_2, arg_21_1)

	return (get_triangle_vertices + var_21_1 + var_21_2) / 3
end

NavigationGroup.get_poly_hash = function (self, arg_22_1, arg_22_2)
	-- function 22
	local temp_count, var_22_1, var_22_2 = Script.temp_count()
	local calc_polygon_center = self:calc_polygon_center(arg_22_1, arg_22_2)
	local num = calc_polygon_center.x * 0.0001 + calc_polygon_center.y + calc_polygon_center.z * 10000

	Script.set_temp_count(temp_count, var_22_1, var_22_2)

	return num
end

local num = 1000

NavigationGroup.breadth_first_find_nearest_group_triangle = function (self, arg_23_1, arg_23_2)
	-- function 23
	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()
	local num_2 = 1
	local num_3 = 1

	alloc_table_2[1] = arg_23_1
	alloc_table[self:get_poly_hash(arg_23_1, arg_23_2)] = true

	local _group_polygons = self._group_polygons

	while num_2 <= num_3 do
		local var_23_5 = alloc_table_2[num_2]
		local get_poly_hash = self:get_poly_hash(var_23_5, arg_23_2)

		num_2 = num_2 + 1

		if not _group_polygons[get_poly_hash] then
			return self:calc_polygon_center(var_23_5, arg_23_2), get_poly_hash
		end

		local tbl = {
			GwNavTraversal.get_neighboring_triangles(var_23_5)
		}

		for i = 1, #tbl do
			local temp_count, var_23_9, var_23_10 = Script.temp_count()
			local var_23_11 = tbl[i]
			local get_poly_hash_2 = self:get_poly_hash(var_23_11, arg_23_2)

			if not alloc_table[get_poly_hash_2] then
				num_3 = num_3 + 1
				alloc_table_2[num_3] = var_23_11
				alloc_table[get_poly_hash_2] = true
			end

			Script.set_temp_count(temp_count, var_23_9, var_23_10)
		end

		if num_2 > num then
			local get_triangle_vertices, var_23_14, var_23_15 = GwNavTraversal.get_triangle_vertices(arg_23_2, arg_23_1)

			print("WARNING: Navigation Group Breadth First Search failed. Triangle at:", get_triangle_vertices)

			return nil, nil
		end
	end
end

NavigationGroup.print_group = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local random = math.random(0, 255)
	local random_2 = math.random(0, 255)
	local random_3 = math.random(0, 255)
	local var_24_3 = Color(random, random_2, random_3)

	print("Group", self._group_number, "has neighbours:")

	for k, v in pairs(self._group_neighbours) do
		local print = print
		local _group_number = k._group_number
		local flag

		flag = not self._group_ledge_neighbours[k] and "connected_by_ledge" and ""

		print(_group_number, flag)
	end

	for k_2, v_2 in pairs(self._group_polygons) do
		self:draw_poly_lines(v_2, var_24_3, arg_24_2, arg_24_3, arg_24_5)
	end

	local identity = Matrix4x4.identity()
	local num = 1.2
	local str = "materials/fonts/arial"
	local str_2 = "arial"
	local unbox = self._group_center:unbox()
	local var_24_12 = Vector3(unbox[1], unbox[3], unbox[2])

	arg_24_4:sphere(unbox, 0.07, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "C", str, num, str_2, identity, var_24_12, 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "C", str, num + 0.1, str_2, identity, var_24_12 - Vector3(0.05, 0, 0), 2, Color(0, 0, 0))
	Gui.text_3d(arg_24_5, "id=" .. self._group_number, str, num - 0.8, str_2, identity, var_24_12 + Vector3(0, 2, 0), 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "dist=" .. self._distance_from_finish, str, num - 0.8, str_2, identity, var_24_12 + Vector3(0, 1.5, 0), 3, Color(255, 255, 255))
	Gui.text_3d(arg_24_5, "area=" .. self._area, str, num - 0.8, str_2, identity, var_24_12 + Vector3(0, 1, 0), 3, Color(255, 255, 255))

	local text_3d = Gui.text_3d
	local var_24_14 = arg_24_5
	local str_3 = "main_path_index="
	local _main_path_index = self._main_path_index

	_main_path_index = _main_path_index or "nil"

	text_3d(var_24_14, str_3 .. _main_path_index, str, num - 0.8, str_2, identity, var_24_12 + Vector3(0, 0.5, 0), 3, Color(255, 255, 255))
end

NavigationGroup.draw_poly_lines = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local temp_count, var_25_1, var_25_2 = Script.temp_count()
	local get_triangle_vertices, var_25_4, var_25_5 = GwNavTraversal.get_triangle_vertices(arg_25_3, arg_25_1)
	local num = get_triangle_vertices + Vector3(0, 0, 0.1)
	local num_2 = var_25_4 + Vector3(0, 0, 0.1)
	local num_3 = var_25_5 + Vector3(0, 0, 0.1)

	LineObject.add_line(arg_25_4, arg_25_2, num, num_2)
	LineObject.add_line(arg_25_4, arg_25_2, num, num_3)
	LineObject.add_line(arg_25_4, arg_25_2, num_2, num_3)
	Script.set_temp_count(temp_count, var_25_1, var_25_2)
end
