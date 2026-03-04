-- chunkname: @scripts/managers/conflict_director/main_path_utils.lua

MainPathUtils = {}

local var_0_0 = Vector3.distance_squared
local var_0_1 = Geometry
local var_0_2 = Vector3.distance

MainPathUtils.total_path_dist = function ()
	return EngineOptimized.main_path_total_length()
end

MainPathUtils.closest_pos_at_main_path = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0
	local var_2_1

	if arg_2_2 then
		local var_2_2 = Managers.state.conflict.level_analysis.main_path_data.breaks_order

		var_2_0 = arg_2_2 == 1 and 1 or var_2_2[arg_2_2 - 1] + 1
		var_2_1 = var_2_2[arg_2_2]
	end

	return EngineOptimized.closest_pos_at_main_path(arg_2_1, var_2_0, var_2_1)
end

MainPathUtils.closest_pos_at_main_path_lua = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = math.huge
	local var_3_1
	local var_3_2
	local var_3_3 = Vector3(0, 0, 0)
	local var_3_4 = false
	local var_3_5 = 0
	local var_3_6 = 0

	arg_3_1 = arg_3_1 or arg_3_0[1].nodes[1]:unbox()

	local var_3_7 = Vector3.set_xyz
	local var_3_8 = Vector3.to_elements
	local var_3_9 = var_0_1.closest_point_on_line
	local var_3_10 = Script.set_temp_count
	local var_3_11 = Script.temp_count
	local var_3_12 = arg_3_2 or 1
	local var_3_13 = arg_3_2 or #arg_3_0

	for iter_3_0 = var_3_12, var_3_13 do
		local var_3_14 = arg_3_0[iter_3_0]
		local var_3_15 = var_3_14.nodes

		var_3_6 = var_3_6 + var_3_14.path_length

		for iter_3_1 = 1, #var_3_15 - 1 do
			local var_3_16, var_3_17, var_3_18 = var_3_11()
			local var_3_19 = var_3_15[iter_3_1]:unbox()
			local var_3_20 = var_3_15[iter_3_1 + 1]:unbox()
			local var_3_21 = var_3_9(arg_3_1, var_3_19, var_3_20)
			local var_3_22 = var_0_0(arg_3_1, var_3_21)

			if var_3_22 < var_3_0 then
				var_3_0 = var_3_22
				var_3_1 = iter_3_0
				var_3_2 = iter_3_1
				var_3_4 = true

				var_3_7(var_3_3, var_3_8(var_3_21))
			end

			var_3_10(var_3_16, var_3_17, var_3_18)
		end
	end

	local var_3_23
	local var_3_24

	if var_3_4 then
		local var_3_25 = arg_3_0[var_3_1]
		local var_3_26 = var_3_25.nodes[var_3_2]:unbox()

		var_3_5 = var_3_25.travel_dist and var_3_25.travel_dist[var_3_2] + Vector3.distance(var_3_3, var_3_26) or 0
		var_3_23 = var_3_5 / var_3_6
	else
		var_3_3 = nil
	end

	return var_3_3, var_3_5, var_3_6, var_3_23, var_3_1, var_3_2
end

MainPathUtils.collapse_main_paths = function (arg_4_0)
	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = {}
	local var_4_4 = {}
	local var_4_5 = 1

	for iter_4_0 = 1, #arg_4_0 do
		local var_4_6 = arg_4_0[iter_4_0]
		local var_4_7 = var_4_6.nodes
		local var_4_8 = var_4_6.travel_dist
		local var_4_9 = var_4_5 + #var_4_7 - 1

		if iter_4_0 < #arg_4_0 then
			var_4_2[var_4_9] = 0
		end

		var_4_3[iter_4_0] = var_4_9

		for iter_4_1 = 1, #var_4_7 do
			var_4_0[var_4_5] = var_4_7[iter_4_1]
			var_4_1[var_4_5] = var_4_8[iter_4_1]
			var_4_4[var_4_5] = iter_4_0
			var_4_5 = var_4_5 + 1
		end
	end

	for iter_4_2, iter_4_3 in pairs(var_4_2) do
		var_4_2[iter_4_2] = (var_4_1[iter_4_2] + var_4_1[iter_4_2 + 1]) / 2
	end

	EngineOptimized.register_main_path(var_4_0, var_4_1, var_4_4, #arg_4_0)

	return var_4_0, var_4_1, var_4_4, var_4_2, var_4_3
end

MainPathUtils.point_on_mainpath = function (arg_5_0, arg_5_1)
	return EngineOptimized.point_on_mainpath(arg_5_1)
end

MainPathUtils.point_on_mainpath_lua = function (arg_6_0, arg_6_1)
	if arg_6_1 < 0 then
		return arg_6_0[1].nodes[1]:unbox(), 1
	end

	local var_6_0 = 0
	local var_6_1 = LevelAnalysis.get_path_point

	for iter_6_0 = 1, #arg_6_0 do
		local var_6_2 = arg_6_0[iter_6_0]

		var_6_0 = var_6_0 + var_6_2.path_length

		if arg_6_1 <= var_6_0 then
			local var_6_3 = (arg_6_1 - (var_6_0 - var_6_2.path_length)) / var_6_2.path_length
			local var_6_4, var_6_5 = var_6_1(var_6_2.nodes, var_6_2.path_length, var_6_3)

			return var_6_4, iter_6_0, var_6_5
		end
	end

	local var_6_6 = #arg_6_0
	local var_6_7 = arg_6_0[var_6_6].nodes

	return var_6_7[#var_6_7]:unbox(), var_6_6
end

MainPathUtils.zone_segment_on_mainpath = function (arg_7_0, arg_7_1)
	local var_7_0, var_7_1, var_7_2 = MainPathUtils.closest_pos_at_main_path(arg_7_0, arg_7_1)

	return (math.floor((var_7_1 + 5) / 10))
end

function moll()
	local var_8_0 = EngineOptimized.point_on_mainpath(0)
	local var_8_1, var_8_2, var_8_3, var_8_4, var_8_5 = EngineOptimized.closest_pos_at_main_path(var_8_0)
	local var_8_6 = var_8_5
	local var_8_7, var_8_8, var_8_9 = EngineOptimized.main_path_next_break(var_8_6)

	while var_8_8 do
		print("MAINPATH: ", var_8_6, var_8_7, var_8_8, var_8_9)

		local var_8_10 = EngineOptimized.point_on_mainpath(var_8_2 + 1)
		local var_8_11, var_8_12, var_8_13, var_8_14

		var_8_11, var_8_2, var_8_12, var_8_13, var_8_14 = EngineOptimized.closest_pos_at_main_path(var_8_10)

		QuickDrawerStay:sphere(var_8_11, 3, Color(0, 0, 255))

		if var_8_14 ~= var_8_6 then
			local var_8_15, var_8_16, var_8_17 = EngineOptimized.main_path_next_break(var_8_14)

			var_8_6 = var_8_14
		else
			break
		end
	end
end

local var_0_3 = {
	0,
	1,
	-1,
	5,
	-5,
	20,
	-20
}
local var_0_4 = #var_0_3

MainPathUtils.closest_pos_at_collapsed_main_path = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_4 = arg_9_4 or 1

	local var_9_0 = #arg_9_0
	local var_9_1 = var_9_0 - 1
	local var_9_2 = math.clamp
	local var_9_3 = math.huge
	local var_9_4 = Vector3(0, 0, 0)
	local var_9_5 = false
	local var_9_6 = arg_9_1[var_9_0]

	arg_9_3 = arg_9_3 or arg_9_0[1]:unbox()

	local var_9_7 = Vector3.set_xyz
	local var_9_8 = Vector3.to_elements
	local var_9_9 = var_0_1.closest_point_on_line

	for iter_9_0 = 1, var_0_4 do
		local var_9_10 = arg_9_4 + var_0_3[iter_9_0]
		local var_9_11 = var_9_2(var_9_10, 1, var_9_1)
		local var_9_12 = arg_9_0[var_9_11]:unbox()
		local var_9_13 = arg_9_0[var_9_11 + 1]:unbox()
		local var_9_14 = var_9_9(arg_9_3, var_9_12, var_9_13)
		local var_9_15 = var_0_0(arg_9_3, var_9_14)

		if var_9_15 < var_9_3 then
			var_9_3 = var_9_15
			var_9_5 = var_9_11

			var_9_7(var_9_4, var_9_8(var_9_14))
		end
	end

	local var_9_16
	local var_9_17
	local var_9_18 = 0

	if var_9_5 then
		local var_9_19 = arg_9_0[var_9_5]:unbox()
		local var_9_20 = arg_9_1[var_9_5]

		var_9_18 = var_9_20 + var_0_2(var_9_4, var_9_19)

		local var_9_21 = arg_9_2[var_9_5]

		if var_9_21 and var_9_20 < var_9_18 then
			if var_9_21 < var_9_18 then
				var_9_18 = arg_9_1[var_9_5 + 1]
				var_9_4 = arg_9_0[var_9_5 + 1]:unbox()
			else
				var_9_18 = var_9_20
				var_9_4 = var_9_19
			end
		end

		var_9_16 = var_9_18 / var_9_6
	else
		var_9_4 = nil
	end

	return var_9_4, var_9_18, var_9_16, var_9_5
end

MainPathUtils.resolve_node_in_door = function (arg_10_0, arg_10_1, arg_10_2)
	if ScriptUnit.has_extension(arg_10_2, "nav_graph_system") == nil then
		return arg_10_1
	end

	local var_10_0 = Managers.state.entity:system("nav_graph_system")
	local var_10_1 = var_10_0:get_smart_object_id(arg_10_2)
	local var_10_2 = var_10_0:get_smart_objects(var_10_1)

	for iter_10_0, iter_10_1 in pairs(var_10_2) do
		local var_10_3 = Vector3Aux.unbox(iter_10_1.pos1)
		local var_10_4 = Vector3Aux.unbox(iter_10_1.pos2)

		if Vector3.distance_squared(arg_10_1, var_10_3) < Vector3.distance_squared(arg_10_1, var_10_4) then
			arg_10_1 = var_10_3
		else
			arg_10_1 = var_10_4
		end

		local var_10_5, var_10_6 = GwNavQueries.triangle_from_position(arg_10_0, arg_10_1, 1.5, 1.5)

		if var_10_5 then
			arg_10_1.z = var_10_6

			break
		end

		arg_10_1 = nil

		break
	end

	return arg_10_1
end

local var_0_5 = 1.5

MainPathUtils.node_list_from_main_paths = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = {}
	local var_11_1 = {}
	local var_11_2 = {}
	local var_11_3 = {}
	local var_11_4 = Managers.state.entity:system("door_system")
	local var_11_5 = {}

	for iter_11_0 = 1, #arg_11_1 do
		local var_11_6 = arg_11_1[iter_11_0].nodes

		for iter_11_1 = 1, #var_11_6 do
			local var_11_7 = var_11_6[iter_11_1]

			var_11_0[#var_11_0 + 1] = var_11_7

			if iter_11_0 ~= 1 and iter_11_1 == 1 then
				var_11_3[var_11_7] = true
			elseif iter_11_0 ~= #arg_11_1 and iter_11_1 == #var_11_6 then
				var_11_2[var_11_7] = true
			end

			if arg_11_2 then
				local var_11_8 = var_11_6[iter_11_1 + 1]

				if var_11_8 then
					local var_11_9 = var_11_8:unbox() - var_11_7:unbox()
					local var_11_10 = Vector3.length(var_11_9)

					if arg_11_2 < var_11_10 then
						local var_11_11 = Vector3.normalize(var_11_9)
						local var_11_12 = math.floor(var_11_10 / arg_11_2)

						for iter_11_2 = 1, var_11_12 do
							local var_11_13 = var_11_7:unbox() + var_11_11 * iter_11_2 * arg_11_2

							if var_11_4:get_doors(var_11_13, var_0_5, var_11_5) > 0 then
								local var_11_14 = var_11_5[1]

								var_11_13 = MainPathUtils.resolve_node_in_door(arg_11_0, var_11_13, var_11_14)
							else
								local var_11_15, var_11_16 = GwNavQueries.triangle_from_position(arg_11_0, var_11_13, 1.5, 1.5)

								if var_11_15 then
									var_11_13.z = var_11_16
								else
									var_11_13 = nil
								end
							end

							if var_11_13 then
								local var_11_17 = Vector3Box(var_11_13)

								var_11_0[#var_11_0 + 1] = var_11_17
							end
						end
					end
				end
			end
		end
	end

	if arg_11_3 then
		for iter_11_3 = 1, #arg_11_3 do
			local var_11_18 = arg_11_3[iter_11_3]
			local var_11_19 = var_11_18.position:unbox()
			local var_11_20, var_11_21, var_11_22, var_11_23, var_11_24, var_11_25 = MainPathUtils.closest_pos_at_main_path_lua({
				{
					path_length = 1,
					nodes = var_11_0
				}
			}, var_11_19)

			if var_11_20 and var_0_0(var_11_20, var_11_19) <= var_11_18.radius_sq then
				local var_11_26 = var_11_0[var_11_25]

				var_11_2[var_11_0[var_11_25]] = true
				var_11_3[var_11_0[var_11_25 + 1]] = true
			end
		end
	end

	for iter_11_4 = #var_11_0, 1, -1 do
		var_11_1[#var_11_1 + 1] = var_11_0[iter_11_4]
	end

	return var_11_0, var_11_1, var_11_2, var_11_3
end

MainPathUtils.closest_node_in_node_list = function (arg_12_0, arg_12_1)
	local var_12_0 = math.huge
	local var_12_1

	for iter_12_0 = 1, #arg_12_0 do
		local var_12_2 = arg_12_0[iter_12_0]:unbox()
		local var_12_3 = var_0_0(arg_12_1, var_12_2)

		if var_12_3 < var_12_0 then
			var_12_0 = var_12_3
			var_12_1 = iter_12_0
		end
	end

	return var_12_1
end

MainPathUtils.ray_along_node_list = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_3 == -1 and 1 or #arg_13_1
	local var_13_1 = 0

	for iter_13_0 = arg_13_2, var_13_0, arg_13_3 do
		local var_13_2 = arg_13_1[iter_13_0 + arg_13_3]

		if not var_13_2 then
			return var_13_1
		end

		local var_13_3 = arg_13_1[iter_13_0]:unbox()
		local var_13_4 = var_13_2:unbox()
		local var_13_5, var_13_6 = GwNavQueries.raycast(arg_13_0, var_13_3, var_13_4)

		if var_13_5 then
			var_13_1 = var_13_1 + Vector3.length(var_13_4 - var_13_3)

			if arg_13_4 <= var_13_1 then
				return arg_13_4
			end
		else
			var_13_1 = var_13_1 + Vector3.length(var_13_6 - var_13_3)

			if arg_13_4 <= var_13_1 then
				return arg_13_4
			else
				return var_13_1
			end
		end
	end
end

MainPathUtils.find_equidistant_points_in_node_list = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_1
	local var_14_1 = 1
	local var_14_2 = 0

	while true do
		local var_14_3 = arg_14_0[var_14_0 + arg_14_2]

		if not var_14_3 then
			return arg_14_5
		end

		local var_14_4 = arg_14_0[var_14_0]:unbox()
		local var_14_5 = var_14_3:unbox() - var_14_4
		local var_14_6 = Vector3.length(var_14_5)
		local var_14_7 = Vector3.normalize(var_14_5)
		local var_14_8 = math.ceil((var_14_6 - var_14_2) / arg_14_3)

		for iter_14_0 = 0, var_14_8 - 1 do
			arg_14_5[var_14_1] = {
				var_14_4 + var_14_7 * (var_14_2 + iter_14_0 * arg_14_3),
				var_14_7 * arg_14_2,
				var_14_0
			}
			var_14_1 = var_14_1 + 1

			if arg_14_4 and arg_14_4 < var_14_1 then
				return arg_14_5
			end
		end

		local var_14_9 = var_14_6 - (var_14_8 - 1) * arg_14_3

		var_14_2 = var_14_2 + arg_14_3 - var_14_9
		var_14_0 = var_14_0 + arg_14_2
	end
end

MainPathUtils.get_main_path_point_between_players = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0
	local var_15_1
	local var_15_2

	if not arg_15_1.ahead_unit then
		var_15_0 = 0
		var_15_2 = 0
	else
		var_15_0 = arg_15_2[arg_15_1.ahead_unit].travel_dist
		var_15_2 = arg_15_2[arg_15_1.behind_unit].travel_dist
	end

	local var_15_3 = var_15_2 + (var_15_0 - var_15_2) * 0.5
	local var_15_4 = math.clamp(var_15_3, 0, MainPathUtils.total_path_dist() - 0.1)
	local var_15_5, var_15_6 = MainPathUtils.point_on_mainpath(arg_15_0, var_15_4)
	local var_15_7 = arg_15_0[var_15_6]
	local var_15_8 = MainPathUtils.closest_node_in_node_list(var_15_7.nodes, var_15_5)
	local var_15_9 = var_15_7.nodes[var_15_8]
	local var_15_10 = var_15_7.nodes[var_15_8 + 1]
	local var_15_11 = var_15_7.nodes[var_15_8 - 1]
	local var_15_12

	if var_15_10 then
		var_15_12 = var_15_10:unbox() - var_15_9:unbox()
	elseif var_15_11 then
		var_15_12 = var_15_9:unbox() - var_15_11:unbox()
	end

	local var_15_13 = var_15_12 and Quaternion.look(var_15_12) or Quaternion.identity()

	return Vector3Box(var_15_5), QuaternionBox(var_15_13)
end
