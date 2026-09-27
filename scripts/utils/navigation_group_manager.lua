-- chunkname: @scripts/utils/navigation_group_manager.lua

require("foundation/scripts/util/math")
require("scripts/utils/navigation_group")

NavigationGroupManager = class(NavigationGroupManager)

local num = 20

NavigationGroupManager.init = function (self, arg_1_1)
	-- function 1
	self._navigation_groups = {}
	self._registered_polygons = {}
	self._world = nil
	self._level = nil
	self.nav_world = nil
	self._groups_max_radius = 20
	self._finish_point = nil
	self._num_groups = 0
	self._printing_groups = false
	self._numb = 0
	self._using_editor = arg_1_1
end

NavigationGroupManager.setup = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._world = arg_2_1
	self.nav_world = arg_2_2
	self.operational = true
end

NavigationGroupManager.form_groups = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	print("Forming navigation groups")
	assert(arg_3_2 ~= nil, "Got nil for finish_point")

	local clock = os.clock()

	self._groups_max_radius = arg_3_1 or self._groups_max_radius
	self._finish_point = arg_3_2

	local nav_world = self.nav_world
	local var_3_2 = arg_3_3

	if not arg_3_3 then
		local level_key = Managers.state.game_mode:level_key()

		var_3_2 = LevelSettings[level_key].level_name
	end

	if LevelResource.nested_level_count(var_3_2) > 0 then
		var_3_2 = LevelResource.nested_level_resource_name(var_3_2, 0)
	end

	local unit_indices = LevelResource.unit_indices(var_3_2, "core/gwnav/units/seedpoint/seedpoint")

	self._num_groups = 0

	local get_seed_triangle = GwNavTraversal.get_seed_triangle(nav_world, arg_3_2:unbox())
	local tbl = {}
	local tbl_2 = {}

	self._in_group_queue_pos = 0
	self._rejected_queue_pos = 0
	tbl[#tbl + 1] = get_seed_triangle
	self._iter_count = -999999

	self:assign_group(nil, tbl, tbl_2)

	local clock_2 = os.clock()

	print("NavigationGroupManager -> calulation time A:", clock_2 - clock)

	for i, v in ipairs(unit_indices) do
		local unit_position = LevelResource.unit_position(var_3_2, v)
		local get_seed_triangle_2 = GwNavTraversal.get_seed_triangle(nav_world, unit_position)
		local tbl_3 = {}
		local tbl_4 = {}

		self._in_group_queue_pos = 0
		self._rejected_queue_pos = 0
		tbl_3[#tbl_3 + 1] = get_seed_triangle_2

		self:assign_group(nil, tbl_3, tbl_4)
	end

	local clock_3 = os.clock()

	print("NavigationGroupManager -> calulation time B:", clock_3 - clock_2)
	print("number of nav groups: ", self._num_groups)
	self:refine_groups()
	print("number of refined nav groups : ", self._num_groups)
	self:calc_distances_from_finish_for_all(tbl)

	if not self._using_editor then
		self:make_sure_group_centers_are_on_mesh()
		self:knit_groups_with_ledges()
	end

	print("NavigationGroupManager -> calulation time C:", os.clock() - clock_3)
end

NavigationGroupManager.form_groups_start = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	print("NavigationGroupManager -> form_groups_start")
	assert(arg_4_2 ~= nil, "Got nil for finish_point")

	self._groups_max_radius = arg_4_1 or self._groups_max_radius
	self._finish_point = arg_4_2

	local nav_world = self.nav_world
	local var_4_1 = arg_4_3

	if not arg_4_3 then
		local level_key = Managers.state.game_mode:level_key()

		var_4_1 = LevelSettings[level_key].level_name
	end

	if LevelResource.nested_level_count(var_4_1) > 0 then
		var_4_1 = LevelResource.nested_level_resource_name(var_4_1, 0)
	end

	self._seedpoint_unit_indices = LevelResource.unit_indices(var_4_1, "core/gwnav/units/seedpoint/seedpoint")
	self._level_name = var_4_1
	self._num_groups = 0

	local get_seed_triangle = GwNavTraversal.get_seed_triangle(nav_world, arg_4_2:unbox())
	local tbl = {}
	local tbl_2 = {}

	self._in_group_queue_pos = 0
	self._rejected_queue_pos = 0
	tbl[#tbl + 1] = get_seed_triangle
	self._current_group = nil
	self._in_group_queue = tbl
	self._rejected_queue = tbl_2
	self._backup_group_queue = tbl
	self.form_groups_running = true
	self._sum_iter_count = 0
	self._spawn_point_index = 0

	self:form_groups_update()
end

local flag

flag = not IS_WINDOWS and 1000 and 400

NavigationGroupManager.form_groups_update = function (self)
	-- function 5
	print("NavigationGroupManager -> form_groups_update")
	Debug.text("NavigationGroupManager: %d ", self._sum_iter_count)

	local clock = os.clock()

	self._iter_count = 0

	local flag_2 = false

	self.form_groups_running = true

	while self._iter_count < flag do
		local assign_group, var_5_3, var_5_4 = self:assign_group(self._current_group, self._in_group_queue, self._rejected_queue)
		local flag_3 = not var_5_3

		self._sum_iter_count = self._sum_iter_count + self._iter_count

		print("\t\tworking on group -> count:", self._iter_count)

		if not flag_3 then
			self._spawn_point_index = self._spawn_point_index + 1

			local var_5_6 = self._seedpoint_unit_indices[self._spawn_point_index]

			if not var_5_6 then
				print("\t\tpop next seed point")

				local unit_position = LevelResource.unit_position(self._level_name, var_5_6)
				local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, unit_position)

				self._in_group_queue = {}
				self._rejected_queue = {}
				self._current_group = nil
				self._in_group_queue_pos = 0
				self._rejected_queue_pos = 0
				self._in_group_queue[#self._in_group_queue + 1] = get_seed_triangle
				self._iter_count = 0
			else
				self:form_groups_end()

				self.form_groups_running = false
				flag_2 = true

				break
			end
		else
			self._current_group = assign_group
			self._in_group_queue = var_5_3
			self._rejected_queue = var_5_4
		end
	end

	print("\t-> time:", os.clock() - clock, "sum:", self._sum_iter_count)

	return flag_2
end

NavigationGroupManager.form_groups_end = function (self)
	-- function 6
	local clock = os.clock()

	print("\t-> number of nav groups: ", self._num_groups)
	self:refine_groups()
	print("\t-> number of refined nav groups : ", self._num_groups)
	self:calc_distances_from_finish_for_all(self._backup_group_queue)

	if not self._using_editor then
		self:make_sure_group_centers_are_on_mesh()
		self:knit_groups_with_ledges()
	end

	print("NavigationGroupManager -> form_groups_end time:", os.clock() - clock)
end

NavigationGroupManager._breadth_first_fill_main_path_index = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local tbl = {
		starting_nav_group = true
	}
	local tbl_2 = {
		arg_7_2
	}
	local num = 1
	local num_2 = #tbl_2 + 1

	while num < num_2 do
		local var_7_4 = tbl_2[num]

		if var_7_4:get_main_path_index() == nil then
			var_7_4:set_main_path_index(arg_7_1)

			local get_group_neighbours = var_7_4:get_group_neighbours()
			local get_group_ledge_neighbours = var_7_4:get_group_ledge_neighbours()

			for k, v in pairs(get_group_neighbours) do
				if not (tbl[k] or get_group_ledge_neighbours[k]) then
					tbl[k] = true
					tbl_2[num_2] = k
					num_2 = num_2 + 1
				end
			end
		end

		num = num + 1
	end
end

NavigationGroupManager.assign_main_path_indexes = function (self, arg_8_1)
	-- function 8
	local clock = os.clock()
	local set_temp_count = Script.set_temp_count
	local temp_count = Script.temp_count

	for i = 1, #arg_8_1 do
		local nodes = arg_8_1[i].nodes

		for j = 1, #nodes do
			local var_8_4, var_8_5, var_8_6 = temp_count()
			local unbox = nodes[j]:unbox()
			local get_group_from_position = self:get_group_from_position(unbox)

			if not get_group_from_position then
				self:_breadth_first_fill_main_path_index(i, get_group_from_position)

				break
			end

			set_temp_count(var_8_4, var_8_5, var_8_6)
		end
	end

	print("NavigationGroupManager -> assign_main_path_indexes time:", os.clock() - clock)
end

NavigationGroupManager.assign_group = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local temp_count, var_9_1, var_9_2 = Script.temp_count()

	self._iter_count = self._iter_count + 1

	local next_poly_in_queue, var_9_4, var_9_5 = self:next_poly_in_queue(arg_9_2, arg_9_3)

	var_9_5 = var_9_5 or not arg_9_1

	if not next_poly_in_queue then
		return
	end

	if not var_9_5 then
		arg_9_1 = self:create_group(self.nav_world, var_9_4, next_poly_in_queue)
		arg_9_2 = self:add_neighbours_to_queue(next_poly_in_queue, arg_9_1, arg_9_2)
	elseif not self:in_range(next_poly_in_queue, arg_9_1) then
		if var_9_4 ~= arg_9_1:get_group_center_poly() then
			self:join_group(next_poly_in_queue, var_9_4, arg_9_1)
		else
			self._registered_polygons[var_9_4] = arg_9_1
		end

		arg_9_2 = self:add_neighbours_to_queue(next_poly_in_queue, arg_9_1, arg_9_2)
	else
		arg_9_3[#arg_9_3 + 1] = next_poly_in_queue
	end

	Script.set_temp_count(temp_count, var_9_1, var_9_2)

	if self._iter_count > flag then
		return arg_9_1, arg_9_2, arg_9_3
	end

	return self:assign_group(arg_9_1, arg_9_2, arg_9_3)
end

NavigationGroupManager.next_poly_in_queue = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._in_group_queue_pos = self._in_group_queue_pos + 1

	local var_10_0 = arg_10_1[self._in_group_queue_pos]
	local poly_is_valid, var_10_2 = self:poly_is_valid(var_10_0)
	local flag = false

	if not poly_is_valid then
		self._in_group_queue_pos = self._in_group_queue_pos - 1
		flag = true

		repeat
			self._rejected_queue_pos = self._rejected_queue_pos + 1
			var_10_0 = arg_10_2[self._rejected_queue_pos]

			local poly_is_valid_2

			poly_is_valid_2, var_10_2 = self:poly_is_valid(var_10_0)

			if poly_is_valid_2 == nil then
				self._rejected_queue_pos = self._rejected_queue_pos - 1

				return false, false
			end
		until not poly_is_valid_2
	end

	if not flag then
		self:unmark_polys(arg_10_2)
	end

	return var_10_0, var_10_2, flag
end

NavigationGroupManager.poly_is_valid = function (self, arg_11_1)
	-- function 11
	local flag = false
	local flag_2 = false

	if not arg_11_1 then
		flag = self:get_poly_hash(arg_11_1)

		if not (self._registered_polygons[flag] == nil or self._registered_polygons[flag] ~= true) then
			flag_2 = true
		end
	else
		return nil, nil
	end

	return flag_2, flag
end

NavigationGroupManager.unmark_polys = function (self, arg_12_1)
	-- function 12
	for i = self._rejected_queue_pos, #arg_12_1 do
		local var_12_0 = arg_12_1[i]
		local get_poly_hash = self:get_poly_hash(var_12_0)

		if self._registered_polygons[get_poly_hash] == true then
			self._registered_polygons[get_poly_hash] = nil
		end
	end
end

NavigationGroupManager.add_neighbours_to_queue = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local get_neighbours = self:get_neighbours(arg_13_1)
	local get_poly_hash = self:get_poly_hash(arg_13_1)

	for i, v in ipairs(get_neighbours) do
		local get_poly_hash_2 = self:get_poly_hash(v)
		local var_13_3 = self._registered_polygons[get_poly_hash_2]

		if var_13_3 == nil then
			arg_13_3[#arg_13_3 + 1] = v
			self._registered_polygons[get_poly_hash_2] = true
		elseif not (var_13_3 == true or arg_13_2 == var_13_3) then
			arg_13_2:add_neighbour_group(var_13_3)
			var_13_3:add_neighbour_group(arg_13_2)
		end
	end

	return arg_13_3
end

NavigationGroupManager.refine_groups = function (self)
	-- function 14
	for k, v in pairs(self._navigation_groups) do
		local get_group_area = k:get_group_area()
		local get_group_neighbours = k:get_group_neighbours()
		local size = table.size(get_group_neighbours)

		if not (not (get_group_area < num) or not (size > 0)) then
			local get_group_polygons = k:get_group_polygons()
			local find_smallest_neighbour_group = self:find_smallest_neighbour_group(k)
			local temp_count, var_14_6, var_14_7 = Script.temp_count()

			for k_2, v_2 in pairs(get_group_polygons) do
				local get_poly_hash = self:get_poly_hash(v_2)

				self:join_group(v_2, get_poly_hash, find_smallest_neighbour_group)
			end

			Script.set_temp_count(temp_count, var_14_6, var_14_7)

			for k_3, v_3 in pairs(get_group_neighbours) do
				k_3:remove_neighbour_group(k)

				if k_3 ~= find_smallest_neighbour_group then
					k_3:add_neighbour_group(find_smallest_neighbour_group)
					find_smallest_neighbour_group:add_neighbour_group(k_3)
				end
			end

			self._navigation_groups[k] = nil
			self._num_groups = self._num_groups - 1

			k:destroy(self._world)

			k = nil
		end
	end
end

local function fn(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local triangle_from_position, var_15_1 = GwNavQueries.triangle_from_position(arg_15_0, arg_15_1, arg_15_2, arg_15_3)

	if not triangle_from_position then
		arg_15_1.z = var_15_1

		return arg_15_1
	end
end

NavigationGroupManager.make_sure_group_centers_are_on_mesh = function (self)
	-- function 16
	for k, v in pairs(self._navigation_groups) do
		local unbox = k._group_center:unbox()
		local triangle_from_position, var_16_2 = GwNavQueries.triangle_from_position(self.nav_world, unbox, 1, 1)

		if not triangle_from_position then
			triangle_from_position, var_16_2 = GwNavQueries.triangle_from_position(self.nav_world, unbox, 2.5, 2.5)
		end

		if not triangle_from_position then
			triangle_from_position, var_16_2 = GwNavQueries.triangle_from_position(self.nav_world, unbox, 5, 5)
		end

		if not triangle_from_position then
			unbox.z = var_16_2

			k._group_center:store(unbox)
		else
			local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, unbox)

			if not get_seed_triangle then
				local get_triangle_vertices, var_16_5, var_16_6 = GwNavTraversal.get_triangle_vertices(self.nav_world, get_seed_triangle)
				local num = (get_triangle_vertices + var_16_5 + var_16_6) / 3

				k._group_center:store(num)
			else
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(self.nav_world, unbox + Vector3(0, 0, 2), 0, 4, 4, 0.1)

				if not inside_position_from_outside_position then
					k._group_center:store(inside_position_from_outside_position)
				end
			end
		end
	end
end

NavigationGroupManager.find_smallest_neighbour_group = function (arg_17_0, arg_17_1)
	-- function 17
	local get_group_neighbours = arg_17_1:get_group_neighbours()
	local var_17_1 = next(get_group_neighbours, nil)
	local get_group_area = var_17_1:get_group_area()

	for k, v in pairs(get_group_neighbours) do
		local get_group_area_2 = k:get_group_area()

		if get_group_area_2 < get_group_area then
			var_17_1 = k
			get_group_area = get_group_area_2
		end
	end

	return var_17_1
end

NavigationGroupManager.calc_distances_from_finish_for_all = function (self, arg_18_1)
	-- function 18
	local temp_count, var_18_1, var_18_2 = Script.temp_count()
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, self._finish_point:unbox())
	local get_poly_hash = self:get_poly_hash(get_seed_triangle)

	for i, v in ipairs(arg_18_1) do
		repeat
			Script.set_temp_count(temp_count, var_18_1, var_18_2)

			local get_poly_hash_2 = self:get_poly_hash(v)
			local var_18_6 = self._registered_polygons[get_poly_hash_2]
			local flag = false

			if var_18_6:get_distance_from_finish() ~= math.huge then
				break
			end

			if var_18_6 == self._registered_polygons[get_poly_hash] then
				flag = true
			end

			local calc_distance_from_finish = self:calc_distance_from_finish(var_18_6, flag)

			var_18_6:set_distance_from_finish(calc_distance_from_finish)
		until true
	end
end

NavigationGroupManager.get_neighbours = function (arg_19_0, arg_19_1)
	-- function 19
	return {
		GwNavTraversal.get_neighboring_triangles(arg_19_1)
	}
end

NavigationGroupManager.create_group = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local calc_polygon_center = self:calc_polygon_center(arg_20_3)
	local calc_polygon_area = self:calc_polygon_area(arg_20_3)

	self._num_groups = self._num_groups + 1

	local var_20_2 = NavigationGroup:new(self.nav_world, arg_20_2, arg_20_3, calc_polygon_center, calc_polygon_area, self._num_groups)

	self._navigation_groups[var_20_2] = true
	self._registered_polygons[arg_20_2] = var_20_2

	return var_20_2
end

NavigationGroupManager.join_group = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local calc_polygon_area = self:calc_polygon_area(arg_21_1)
	local calc_polygon_center = self:calc_polygon_center(arg_21_1)

	arg_21_3:add_polygon(arg_21_1, calc_polygon_center, calc_polygon_area, self.nav_world)

	self._registered_polygons[arg_21_2] = arg_21_3
end

NavigationGroupManager.in_range = function (self, arg_22_1, arg_22_2)
	-- function 22
	local num = self:calc_polygon_center(arg_22_1) - arg_22_2:get_group_center():unbox()

	return not (Vector3.length(num) <= self._groups_max_radius) or math.abs(num.z) < 2.5
end

NavigationGroupManager.calc_distance_from_finish = function (self, arg_23_1, arg_23_2)
	-- function 23
	local huge = math.huge
	local get_group_center = arg_23_1:get_group_center()

	if not arg_23_2 then
		huge = Vector3.distance(get_group_center:unbox(), self._finish_point:unbox())
	else
		local get_group_neighbours = arg_23_1:get_group_neighbours()
		local var_23_3 = next(get_group_neighbours, nil)

		if not var_23_3 then
			return huge
		end

		for k, v in pairs(get_group_neighbours) do
			local get_distance_from_finish = k:get_distance_from_finish()

			if get_distance_from_finish < huge then
				huge = get_distance_from_finish
				var_23_3 = k
			end
		end

		huge = huge + Vector3.distance(get_group_center:unbox(), var_23_3:get_group_center():unbox())
	end

	return huge
end

NavigationGroupManager.calc_polygon_center = function (self, arg_24_1)
	-- function 24
	local get_triangle_vertices, var_24_1, var_24_2 = GwNavTraversal.get_triangle_vertices(self.nav_world, arg_24_1)

	return (get_triangle_vertices + var_24_1 + var_24_2) / 3
end

NavigationGroupManager.calc_polygon_area = function (self, arg_25_1)
	-- function 25
	local get_polygon_sides, var_25_1, var_25_2 = self:get_polygon_sides(arg_25_1)
	local num = (get_polygon_sides + var_25_1 + var_25_2) / 2

	return (math.sqrt(num * (num - get_polygon_sides) * (num - var_25_1) * (num - var_25_2)))
end

NavigationGroupManager.get_polygon_sides = function (self, arg_26_1)
	-- function 26
	local get_triangle_vertices, var_26_1, var_26_2 = GwNavTraversal.get_triangle_vertices(self.nav_world, arg_26_1)
	local var_26_3
	local var_26_4
	local var_26_5
	local distance = Vector3.distance(get_triangle_vertices, var_26_1)
	local distance_2 = Vector3.distance(get_triangle_vertices, var_26_2)
	local distance_3 = Vector3.distance(var_26_1, var_26_2)

	return distance, distance_2, distance_3
end

NavigationGroupManager.destroy = function (self, arg_27_1)
	-- function 27
	self:destroy_gui(arg_27_1)

	for k, v in pairs(self._navigation_groups) do
		k:destroy(arg_27_1)

		k = nil
	end

	self.operational = nil
	self._navigation_groups = {}
	self._registered_polygons = {}
end

NavigationGroupManager.get_group_from_position = function (self, arg_28_1)
	-- function 28
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, arg_28_1)

	if not get_seed_triangle then
		return
	end

	return (self:get_polygon_group(get_seed_triangle))
end

NavigationGroupManager.get_polygon_group = function (self, arg_29_1, arg_29_2)
	-- function 29
	local get_poly_hash = self:get_poly_hash(arg_29_1)
	local var_29_1 = self._registered_polygons[get_poly_hash]

	if not var_29_1 then
		return var_29_1
	end

	return (self:breadth_first_search_neighbours(arg_29_1))
end

NavigationGroupManager.draw_tri = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	arg_30_2 = arg_30_2 or 0.1

	local get_triangle_vertices, var_30_1, var_30_2 = GwNavTraversal.get_triangle_vertices(self.nav_world, arg_30_1)
	local num = get_triangle_vertices + Vector3(0, 0, arg_30_2)
	local num_2 = var_30_1 + Vector3(0, 0, arg_30_2)
	local num_3 = var_30_2 + Vector3(0, 0, arg_30_2)

	QuickDrawerStay:line(num, num_2, arg_30_3)
	QuickDrawerStay:line(num_2, num_3, arg_30_3)
	QuickDrawerStay:line(num_3, num, arg_30_3)
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}

NavigationGroupManager.breadth_first_search_neighbours = function (self, arg_31_1)
	-- function 31
	table.clear(tbl_3)
	table.clear(tbl_2)

	local num = 1
	local var_31_1 = tbl
	local num_2 = 1
	local num_3 = 1

	var_31_1[1] = arg_31_1

	local get_poly_hash = self:get_poly_hash(arg_31_1)

	tbl_3[get_poly_hash] = true

	while num_2 <= num_3 do
		local var_31_5 = var_31_1[num_2]
		local get_poly_hash_2 = self:get_poly_hash(var_31_5)

		num_2 = num_2 + 1
		num = num + 1

		local var_31_7 = self._registered_polygons[get_poly_hash_2]

		if not var_31_7 then
			for k, v in pairs(tbl_2) do
				self:join_group(v, k, var_31_7)
			end

			return var_31_7
		end

		tbl_2[get_poly_hash_2] = var_31_5

		local tbl_4 = {
			GwNavTraversal.get_neighboring_triangles(var_31_5)
		}

		for k_2 = 1, #tbl_4 do
			local temp_count, var_31_10, var_31_11 = Script.temp_count()
			local var_31_12 = tbl_4[k_2]
			local get_poly_hash_3 = self:get_poly_hash(var_31_12)

			if not tbl_3[get_poly_hash_3] then
				num_3 = num_3 + 1
				var_31_1[num_3] = var_31_12
				tbl_3[get_poly_hash_3] = true
			end

			Script.set_temp_count(temp_count, var_31_10, var_31_11)
		end

		if num > 1000 then
			local get_triangle_vertices, var_31_15, var_31_16 = GwNavTraversal.get_triangle_vertices(self.nav_world, arg_31_1)

			print("WARNING navigation group patching failed. Triangle at:", get_triangle_vertices)

			break
		end
	end
end

NavigationGroupManager.get_group_polygons = function (self, arg_32_1)
	-- function 32
	return self:get_polygon_group(arg_32_1):get_group_polygons()
end

NavigationGroupManager.get_group_center = function (self, arg_33_1)
	-- function 33
	return self:get_polygon_group(arg_33_1):get_group_center()
end

NavigationGroupManager.get_poly_hash = function (self, arg_34_1)
	-- function 34
	local calc_polygon_center = self:calc_polygon_center(arg_34_1)

	return calc_polygon_center.x * 0.0001 + calc_polygon_center.y + calc_polygon_center.z * 10000
end

NavigationGroupManager.get_group_centers = function (self, arg_35_1)
	-- function 35
	local temp_count, var_35_1, var_35_2 = Script.temp_count()

	for k, v in pairs(self._navigation_groups) do
		local get_group_center = k:get_group_center()

		table.insert(arg_35_1, get_group_center)
	end

	Script.set_temp_count(temp_count, var_35_1, var_35_2)

	return arg_35_1
end

NavigationGroupManager.get_group_polygons_centers = function (self, arg_36_1)
	-- function 36
	for k, v in pairs(self._navigation_groups) do
		local temp_count, var_36_1, var_36_2 = Script.temp_count()

		arg_36_1 = k:get_group_polygons_centers(arg_36_1)

		Script.set_temp_count(temp_count, var_36_1, var_36_2)
	end

	return arg_36_1
end

NavigationGroupManager.print_groups = function (self, arg_37_1, arg_37_2)
	-- function 37
	local temp_count, var_37_1, var_37_2 = Script.temp_count()
	local flag = not not script_data.debug_navigation_group_manager

	if flag == self._printing_groups then
		return
	end

	if not flag then
		local _line_object = self._line_object

		_line_object = _line_object or World.create_line_object(self._world, false)
		self._line_object = _line_object

		local _drawer = self._drawer

		_drawer = _drawer or Managers.state.debug:drawer({
			mode = "perm",
			name = "nav_group"
		})
		self._drawer = _drawer
		self._debug_world_gui = World.create_world_gui(arg_37_1, Matrix4x4.identity(), 1, 1, "material", "materials/fonts/gw_fonts")

		local _debug_world_gui = self._debug_world_gui
		local temp_count_2, var_37_8, var_37_9 = Script.temp_count()

		for k, v in pairs(self._navigation_groups) do
			k:print_group(arg_37_1, arg_37_2, self._line_object, self._drawer, _debug_world_gui)
		end

		Script.set_temp_count(temp_count_2, var_37_8, var_37_9)
	else
		self:destroy_gui(arg_37_1)
	end

	self._printing_groups = flag

	Script.set_temp_count(temp_count, var_37_1, var_37_2)

	if not self._line_object then
		LineObject.dispatch(arg_37_1, self._line_object)
	end
end

NavigationGroupManager.destroy_gui = function (self, arg_38_1)
	-- function 38
	local _line_object = self._line_object

	if not _line_object then
		return
	end

	self._drawer:reset()
	LineObject.reset(_line_object)
	LineObject.dispatch(arg_38_1, _line_object)
	World.destroy_line_object(arg_38_1, _line_object)

	self._line_object = nil

	World.destroy_gui(arg_38_1, self._debug_world_gui)
end

NavigationGroupManager.a_star_cached = function (self, arg_39_1, arg_39_2)
	-- function 39
	return LuaAStar.a_star_cached(self._navigation_groups, arg_39_1, arg_39_2)
end

NavigationGroupManager.a_star_cached_between_positions = function (self, arg_40_1, arg_40_2)
	-- function 40
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, arg_40_1)
	local get_seed_triangle_2 = GwNavTraversal.get_seed_triangle(self.nav_world, arg_40_2)

	if not (not get_seed_triangle and get_seed_triangle_2) then
		return false
	end

	local get_polygon_group = self:get_polygon_group(get_seed_triangle)
	local get_polygon_group_2 = self:get_polygon_group(get_seed_triangle_2)

	if not (not get_polygon_group and get_polygon_group_2) then
		print("CACHED ASTAR FAIL")

		return false
	end

	return LuaAStar.a_star_cached(self._navigation_groups, get_polygon_group, get_polygon_group_2)
end

NavigationGroupManager.draw_group_path = function (arg_41_0, arg_41_1)
	-- function 41
	local var_41_0 = Color(255, 200, 255, 10)
	local unbox = arg_41_1[1]._group_center:unbox()
	local var_41_2

	for i = 2, #arg_41_1 do
		local unbox_2 = arg_41_1[i]._group_center:unbox()

		QuickDrawerStay:line(unbox, unbox_2, var_41_0)

		unbox = unbox_2
	end
end

NavigationGroupManager.draw_group_connections = function (self)
	-- function 42
	local var_42_0 = Color(255, 255, 128, 128)
	local var_42_1 = Vector3(0, 0, 1)

	for k, v in pairs(self._navigation_groups) do
		for k_2, v_2 in pairs(k._group_neighbours) do
			local num = k._group_center:unbox() + var_42_1
			local num_2 = k_2._group_center:unbox() + var_42_1
			local normalize = Vector3.normalize(num_2 - num)
			local num_3 = Vector3.cross(normalize, Vector3.up()) / 2
			local format = string.format("dist=%.1f", Vector3.length(num_2 - num))

			Debug.world_sticky_text((num_2 + num) * 0.5, format, "red")
			QuickDrawerStay:line(num, num_2, var_42_0)

			local num_4 = num_2 - normalize

			QuickDrawerStay:line(num_4, num_4 - normalize * 0.45 + num_3, var_42_0)
			QuickDrawerStay:line(num_4, num_4 - normalize * 0.45 - num_3, var_42_0)
		end
	end
end

NavigationGroupManager.knit_groups_with_ledges = function (self)
	-- function 43
	local smart_objects = Managers.state.entity:system("nav_graph_system").smart_objects

	for k, v in pairs(smart_objects) do
		for k_2 = 1, #v do
			local var_43_1 = v[k_2]

			if not var_43_1.smart_object_type then
				local str = "ledges"
			end

			local unbox = Vector3Aux.unbox(var_43_1.pos1)
			local get_group_from_position = self:get_group_from_position(unbox)

			if not get_group_from_position then
				local unbox_2 = Vector3Aux.unbox(var_43_1.pos2)
				local get_group_from_position_2 = self:get_group_from_position(unbox_2)

				if not (not get_group_from_position_2 and get_group_from_position == get_group_from_position_2) then
					if not get_group_from_position._group_neighbours[get_group_from_position_2] then
						get_group_from_position:add_neighbour_group(get_group_from_position_2, true)
					end

					if not (not var_43_1.data.is_bidirectional and get_group_from_position_2._group_neighbours[get_group_from_position]) then
						get_group_from_position_2:add_neighbour_group(get_group_from_position, true)
					end
				end
			end
		end
	end
end

local function fn_2(arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	local num = (arg_44_0 + arg_44_1 + arg_44_2) / 3

	return num.x * 0.0001 + num.y + num.z * 10000
end

NavigationGroupManager.breadth_first_search_all_triangles = function (self, arg_45_1)
	-- function 45
	local clock = os.clock()
	local nav_world = self.nav_world
	local flag = arg_45_1 or GwNavTraversal.get_seed_triangle(nav_world, self._finish_point:unbox())

	if flag == nil then
		return
	end

	local num = 1
	local num_2 = 0
	local num_3 = 0
	local are_triangles_equal = GwNavTraversal.are_triangles_equal
	local get_neighboring_triangles = GwNavTraversal.get_neighboring_triangles
	local get_triangle_vertices = GwNavTraversal.get_triangle_vertices
	local var_45_9 = fn_2(get_triangle_vertices(nav_world, flag))
	local tbl = {
		flag
	}
	local tbl_2 = {
		source_tri_hash = num_3
	}

	while num_2 < num do
		num_2 = num_2 + 1

		local var_45_12 = tbl[num_2]
		local tbl_3 = {
			get_neighboring_triangles(var_45_12)
		}

		for i = 1, #tbl_3 do
			local var_45_14 = tbl_3[i]

			if not var_45_14 then
				local var_45_15, var_45_16, var_45_17 = get_triangle_vertices(nav_world, var_45_14)
				local num_4 = (var_45_15 + var_45_16 + var_45_17) / 3
				local num_5 = num_4.x * 0.0001 + num_4.y + num_4.z * 10000

				if not tbl_2[num_5] then
					num = num + 1
					tbl[num] = var_45_14
					tbl_2[num_5] = num_3
					num_3 = num_3 + 1
				end
			end
		end
	end

	local clock_2 = os.clock()

	print("NavigationGroupManager -> traverse all triangles time:", clock_2 - clock, "Num triangles:", num)

	return tbl_2
end
