-- chunkname: @scripts/helpers/navigation_utils.lua

NavigationUtils = NavigationUtils or {}

NavigationUtils.create_exclusive_box_obstacle_from_unit_data = function (arg_1_0, arg_1_1)
	local var_1_0 = true
	local var_1_1 = Color(255, 255, 0, 0)
	local var_1_2 = false
	local var_1_3 = 0
	local var_1_4 = false
	local var_1_5 = 0
	local var_1_6 = Unit.get_data(arg_1_1, "navtag_volume", "mesh_name")
	local var_1_7 = Unit.has_data(arg_1_1, "navtag_volume", "padding_x") and Unit.get_data(arg_1_1, "navtag_volume", "padding_x") or 0
	local var_1_8 = Unit.has_data(arg_1_1, "navtag_volume", "padding_y") and Unit.get_data(arg_1_1, "navtag_volume", "padding_y") or 0
	local var_1_9 = Unit.has_data(arg_1_1, "navtag_volume", "padding_z") and Unit.get_data(arg_1_1, "navtag_volume", "padding_z") or 0

	return NavigationUtils.create_exclusive_box_obstacle_from_mesh(arg_1_0, arg_1_1, var_1_0, var_1_1, var_1_2, var_1_3, var_1_4, var_1_5, var_1_6, var_1_7, var_1_8, var_1_9)
end

NavigationUtils.create_exclusive_box_obstacle_from_mesh = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9, arg_2_10, arg_2_11)
	local var_2_0 = Unit.mesh(arg_2_1, arg_2_8)
	local var_2_1 = Vector3(arg_2_9, arg_2_10, arg_2_11)
	local var_2_2, var_2_3 = Mesh.box(var_2_0)
	local var_2_4 = var_2_3 + var_2_1
	local var_2_5 = Mesh.world_pose(var_2_0)
	local var_2_6 = Matrix4x4.translation(var_2_5)
	local var_2_7 = Vector3(0, 0, 0)

	return GwNavBoxObstacle.create(arg_2_0, var_2_6, var_2_7, var_2_4, arg_2_2, arg_2_3, arg_2_5, arg_2_7), var_2_5
end

NavigationUtils.debug_draw_nav_mesh = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	GwNavWorld.build_database_visual_representation(arg_3_0)

	local var_3_0 = GwNavWorld.database_tile_count(arg_3_0)

	for iter_3_0 = 1, var_3_0 do
		local var_3_1 = GwNavWorld.database_tile_triangle_count(arg_3_0, iter_3_0)

		for iter_3_1 = 1, var_3_1 do
			local var_3_2, var_3_3, var_3_4 = Script.temp_count()
			local var_3_5, var_3_6, var_3_7, var_3_8 = GwNavWorld.database_triangle(arg_3_0, iter_3_0, iter_3_1)

			if var_3_5 then
				LineObject.add_line(arg_3_4, var_3_8, var_3_5, var_3_6)
				LineObject.add_line(arg_3_4, var_3_8, var_3_6, var_3_7)
				LineObject.add_line(arg_3_4, var_3_8, var_3_7, var_3_5)
			end

			Script.set_temp_count(var_3_2, var_3_3, var_3_4)
		end
	end

	if arg_3_1 then
		local var_3_9 = Colors.get("yellow")

		for iter_3_2 = 1, arg_3_2 do
			local var_3_10 = arg_3_1[iter_3_2]

			if var_3_10 then
				local var_3_11 = var_3_10.cost_map
				local var_3_12 = GwNavCostMap.get_debug_triangle_count(var_3_11)

				for iter_3_3 = 1, var_3_12 do
					local var_3_13, var_3_14, var_3_15 = Script.temp_count()
					local var_3_16, var_3_17, var_3_18 = GwNavCostMap.get_debug_triangle(var_3_11, iter_3_3)

					if var_3_16 then
						LineObject.add_line(arg_3_4, var_3_9, var_3_16, var_3_17)
						LineObject.add_line(arg_3_4, var_3_9, var_3_17, var_3_18)
						LineObject.add_line(arg_3_4, var_3_9, var_3_18, var_3_16)
					end

					Script.set_temp_count(var_3_13, var_3_14, var_3_15)
				end
			end
		end
	end

	LineObject.dispatch(arg_3_3, arg_3_4)
	LineObject.reset(arg_3_4)
end

NavigationUtils.get_closest_index_on_spline = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0:splines()
	local var_4_1 = math.huge
	local var_4_2
	local var_4_3 = 1
	local var_4_4 = Vector3.distance_squared
	local var_4_5 = #var_4_0

	for iter_4_0 = 1, var_4_5 do
		local var_4_6 = var_4_0[iter_4_0].points[2]:unbox()
		local var_4_7 = var_4_4(arg_4_1, var_4_6)

		if var_4_7 < var_4_1 then
			var_4_1 = var_4_7
			var_4_2 = var_4_6
			var_4_3 = iter_4_0
		end
	end

	return var_4_3, var_4_2
end

NavigationUtils.get_position_on_interpolated_spline = function (arg_5_0, arg_5_1)
	local var_5_0 = Vector3.distance_squared
	local var_5_1 = arg_5_0:splines()
	local var_5_2 = #var_5_1
	local var_5_3 = math.huge
	local var_5_4
	local var_5_5

	for iter_5_0 = 1, var_5_2 do
		local var_5_6 = var_5_1[iter_5_0].subdivisions
		local var_5_7 = #var_5_6

		for iter_5_1 = 1, var_5_7 do
			local var_5_8 = var_5_6[iter_5_1].points[2]:unbox()
			local var_5_9 = var_5_0(arg_5_1, var_5_8)

			if var_5_9 < var_5_3 then
				var_5_3 = var_5_9
				var_5_4 = iter_5_0
				var_5_5 = iter_5_1
			end
		end
	end

	local var_5_10 = var_5_1[var_5_4].subdivisions
	local var_5_11 = var_5_10[var_5_5]
	local var_5_12 = var_5_11.points[2]:unbox()
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
		var_5_15 = var_5_10[var_5_13]
		var_5_16 = var_5_15.points[2]:unbox()
	elseif var_5_4 > 1 then
		var_5_14 = var_5_4 - 1

		local var_5_21 = var_5_1[var_5_14].subdivisions

		var_5_13 = #var_5_21
		var_5_15 = var_5_21[var_5_13]
		var_5_16 = var_5_15.points[2]:unbox()
	end

	if var_5_5 < #var_5_10 then
		var_5_17 = var_5_10[var_5_5 + 1].points[2]:unbox()
	elseif var_5_4 < var_5_2 then
		var_5_17 = var_5_1[var_5_4 + 1].subdivisions[1].points[2]:unbox()
	else
		local var_5_22 = var_5_1[var_5_2].points

		var_5_17 = var_5_22[#var_5_22]:unbox()
	end

	if var_5_16 then
		local var_5_23 = arg_5_1 - var_5_16
		local var_5_24 = Vector3.normalize(var_5_12 - var_5_16)
		local var_5_25 = var_5_15.length
		local var_5_26 = Vector3.dot(var_5_23, var_5_24)

		if var_5_26 >= 0 and var_5_26 <= var_5_25 then
			var_5_20 = var_5_26 / var_5_25
		elseif var_5_17 == nil then
			var_5_20 = math.clamp(var_5_26, 0, 1)
		end
	end

	if var_5_20 then
		var_5_18 = var_5_14 or var_5_4
		var_5_19 = var_5_13
	else
		local var_5_27 = arg_5_1 - var_5_12
		local var_5_28 = Vector3.normalize(var_5_17 - var_5_12)
		local var_5_29 = var_5_11.length
		local var_5_30 = Vector3.dot(var_5_27, var_5_28)

		if var_5_30 >= 0 and var_5_30 <= var_5_29 then
			var_5_20 = var_5_30 / var_5_29
		else
			var_5_20 = math.clamp(var_5_30, 0, 1)
		end

		var_5_18 = var_5_4
		var_5_19 = var_5_5
	end

	return var_5_18, var_5_19, var_5_20
end
