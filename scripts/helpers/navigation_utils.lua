-- chunkname: @scripts/helpers/navigation_utils.lua

local NavigationUtils = NavigationUtils

NavigationUtils = NavigationUtils or {}
NavigationUtils = NavigationUtils

NavigationUtils.create_exclusive_box_obstacle_from_unit_data = function (arg_1_0, arg_1_1)
	-- function 1
	local flag = true
	local var_1_1 = Color(255, 255, 0, 0)
	local flag_2 = false
	local num = 0
	local flag_3 = false
	local num_2 = 0
	local get_data = Unit.get_data(arg_1_1, "navtag_volume", "mesh_name")
	local get_data_2

	if not Unit.has_data(arg_1_1, "navtag_volume", "padding_x") then
		get_data_2 = Unit.get_data(arg_1_1, "navtag_volume", "padding_x")

		if not get_data_2 then
			-- Nothing
		end
	end

	get_data_2 = 0

	do
		local get_data_3
	end

	::label_1_0::

	if not Unit.has_data(arg_1_1, "navtag_volume", "padding_y") then
		get_data_3 = Unit.get_data(arg_1_1, "navtag_volume", "padding_y")

		if not get_data_3 then
			-- Nothing
		end
	end

	get_data_3 = 0

	do
		local get_data_4
	end

	::label_1_1::

	if not Unit.has_data(arg_1_1, "navtag_volume", "padding_z") then
		get_data_4 = Unit.get_data(arg_1_1, "navtag_volume", "padding_z")

		if not get_data_4 then
			-- Nothing
		end
	end

	get_data_4 = 0

	::label_1_2::

	return NavigationUtils.create_exclusive_box_obstacle_from_mesh(arg_1_0, arg_1_1, flag, var_1_1, flag_2, num, flag_3, num_2, get_data, get_data_2, get_data_3, get_data_4)
end

NavigationUtils.create_exclusive_box_obstacle_from_mesh = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9, arg_2_10, arg_2_11)
	-- function 2
	local mesh = Unit.mesh(arg_2_1, arg_2_8)
	local var_2_1 = Vector3(arg_2_9, arg_2_10, arg_2_11)
	local box, var_2_3 = Mesh.box(mesh)
	local num = var_2_3 + var_2_1
	local world_pose = Mesh.world_pose(mesh)
	local translation = Matrix4x4.translation(world_pose)
	local var_2_7 = Vector3(0, 0, 0)

	return GwNavBoxObstacle.create(arg_2_0, translation, var_2_7, num, arg_2_2, arg_2_3, arg_2_5, arg_2_7), world_pose
end

NavigationUtils.debug_draw_nav_mesh = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	GwNavWorld.build_database_visual_representation(arg_3_0)

	local database_tile_count = GwNavWorld.database_tile_count(arg_3_0)

	for i = 1, database_tile_count do
		local database_tile_triangle_count = GwNavWorld.database_tile_triangle_count(arg_3_0, i)

		for j = 1, database_tile_triangle_count do
			local temp_count, var_3_3, var_3_4 = Script.temp_count()
			local database_triangle, var_3_6, var_3_7, var_3_8 = GwNavWorld.database_triangle(arg_3_0, i, j)

			if not database_triangle then
				LineObject.add_line(arg_3_4, var_3_8, database_triangle, var_3_6)
				LineObject.add_line(arg_3_4, var_3_8, var_3_6, var_3_7)
				LineObject.add_line(arg_3_4, var_3_8, var_3_7, database_triangle)
			end

			Script.set_temp_count(temp_count, var_3_3, var_3_4)
		end
	end

	if not arg_3_1 then
		local get = Colors.get("yellow")

		for k = 1, arg_3_2 do
			local var_3_10 = arg_3_1[k]

			if not var_3_10 then
				local cost_map = var_3_10.cost_map
				local get_debug_triangle_count = GwNavCostMap.get_debug_triangle_count(cost_map)

				for l = 1, get_debug_triangle_count do
					local temp_count_2, var_3_14, var_3_15 = Script.temp_count()
					local get_debug_triangle, var_3_17, var_3_18 = GwNavCostMap.get_debug_triangle(cost_map, l)

					if not get_debug_triangle then
						LineObject.add_line(arg_3_4, get, get_debug_triangle, var_3_17)
						LineObject.add_line(arg_3_4, get, var_3_17, var_3_18)
						LineObject.add_line(arg_3_4, get, var_3_18, get_debug_triangle)
					end

					Script.set_temp_count(temp_count_2, var_3_14, var_3_15)
				end
			end
		end
	end

	LineObject.dispatch(arg_3_3, arg_3_4)
	LineObject.reset(arg_3_4)
end

NavigationUtils.get_closest_index_on_spline = function (self, arg_4_1)
	-- function 4
	local splines = self:splines()
	local huge = math.huge
	local var_4_2
	local num = 1
	local distance_squared = Vector3.distance_squared
	local count = #splines

	for i = 1, count do
		local unbox = splines[i].points[2]:unbox()
		local var_4_7 = distance_squared(arg_4_1, unbox)

		if var_4_7 < huge then
			huge = var_4_7
			var_4_2 = unbox
			num = i
		end
	end

	return num, var_4_2
end

NavigationUtils.get_position_on_interpolated_spline = function (self, arg_5_1)
	-- function 5
	local distance_squared = Vector3.distance_squared
	local splines = self:splines()
	local count = #splines
	local huge = math.huge
	local var_5_4
	local var_5_5

	for i = 1, count do
		local subdivisions = splines[i].subdivisions
		local count_2 = #subdivisions

		for j = 1, count_2 do
			local unbox = subdivisions[j].points[2]:unbox()
			local var_5_9 = distance_squared(arg_5_1, unbox)

			if var_5_9 < huge then
				huge = var_5_9
				var_5_4 = i
				var_5_5 = j
			end
		end
	end

	local subdivisions_2 = splines[var_5_4].subdivisions
	local var_5_11 = subdivisions_2[var_5_5]
	local unbox_2 = var_5_11.points[2]:unbox()
	local var_5_13
	local var_5_14
	local var_5_15
	local var_5_16
	local var_5_17
	local var_5_18
	local var_5_19
	local var_5_20

	if var_5_5 > 1 then
		var_5_13 = var_5_5 - 1
		var_5_15 = subdivisions_2[var_5_13]
		var_5_16 = var_5_15.points[2]:unbox()
	elseif var_5_4 > 1 then
		var_5_14 = var_5_4 - 1

		local subdivisions_3 = splines[var_5_14].subdivisions

		var_5_13 = #subdivisions_3
		var_5_15 = subdivisions_3[var_5_13]
		var_5_16 = var_5_15.points[2]:unbox()
	end

	if var_5_5 < #subdivisions_2 then
		var_5_17 = subdivisions_2[var_5_5 + 1].points[2]:unbox()
	elseif var_5_4 < count then
		var_5_17 = splines[var_5_4 + 1].subdivisions[1].points[2]:unbox()
	else
		local points = splines[count].points

		var_5_17 = points[#points]:unbox()
	end

	if not var_5_16 then
		local num = arg_5_1 - var_5_16
		local normalize = Vector3.normalize(unbox_2 - var_5_16)
		local length = var_5_15.length
		local dot = Vector3.dot(num, normalize)

		if not (not (dot >= 0) or not (dot <= length)) then
			var_5_20 = dot / length
		elseif var_5_17 == nil then
			var_5_20 = math.clamp(dot, 0, 1)
		end
	end

	if not var_5_20 then
		var_5_18 = var_5_14 or var_5_4
		var_5_19 = var_5_13
	else
		local num_2 = arg_5_1 - unbox_2
		local normalize_2 = Vector3.normalize(var_5_17 - unbox_2)
		local length_2 = var_5_11.length
		local dot_2 = Vector3.dot(num_2, normalize_2)

		if not (not (dot_2 >= 0) or not (dot_2 <= length_2)) then
			var_5_20 = dot_2 / length_2
		else
			var_5_20 = math.clamp(dot_2, 0, 1)
		end

		var_5_18 = var_5_4
		var_5_19 = var_5_5
	end

	return var_5_18, var_5_19, var_5_20
end
