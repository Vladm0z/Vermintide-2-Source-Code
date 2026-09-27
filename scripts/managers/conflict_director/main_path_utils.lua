-- chunkname: @scripts/managers/conflict_director/main_path_utils.lua

MainPathUtils = {}

local distance_squared = Vector3.distance_squared
local Geometry = Geometry
local distance = Vector3.distance

MainPathUtils.total_path_dist = function ()
	-- function 1
	return EngineOptimized.main_path_total_length()
end

MainPathUtils.closest_pos_at_main_path = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0
	local var_2_1

	if not arg_2_2 then
		local breaks_order = Managers.state.conflict.level_analysis.main_path_data.breaks_order

		var_2_0 = arg_2_2 ~= 1 or not 1 or breaks_order[arg_2_2 - 1] + 1
		var_2_1 = breaks_order[arg_2_2]
	end

	return EngineOptimized.closest_pos_at_main_path(arg_2_1, var_2_0, var_2_1)
end

MainPathUtils.closest_pos_at_main_path_lua = function (self, arg_3_1, arg_3_2)
	-- function 3
	local huge = math.huge
	local var_3_1
	local var_3_2
	local var_3_3 = Vector3(0, 0, 0)
	local flag = false
	local num = 0
	local num_2 = 0

	arg_3_1 = arg_3_1 or self[1].nodes[1]:unbox()

	local set_xyz = Vector3.set_xyz
	local to_elements = Vector3.to_elements
	local closest_point_on_line = Geometry.closest_point_on_line
	local set_temp_count = Script.set_temp_count
	local temp_count = Script.temp_count
	local flag_2 = arg_3_2 or 1
	local flag_3 = arg_3_2 or #self

	for i = flag_2, flag_3 do
		local var_3_14 = self[i]
		local nodes = var_3_14.nodes

		num_2 = num_2 + var_3_14.path_length

		for j = 1, #nodes - 1 do
			local var_3_16, var_3_17, var_3_18 = temp_count()
			local unbox = nodes[j]:unbox()
			local unbox_2 = nodes[j + 1]:unbox()
			local var_3_21 = closest_point_on_line(arg_3_1, unbox, unbox_2)
			local var_3_22 = distance_squared(arg_3_1, var_3_21)

			if var_3_22 < huge then
				huge = var_3_22
				var_3_1 = i
				var_3_2 = j
				flag = true

				set_xyz(var_3_3, to_elements(var_3_21))
			end

			set_temp_count(var_3_16, var_3_17, var_3_18)
		end
	end

	local var_3_23
	local var_3_24

	if not flag then
		local var_3_25 = self[var_3_1]
		local unbox_3 = var_3_25.nodes[var_3_2]:unbox()

		num = not var_3_25.travel_dist and var_3_25.travel_dist[var_3_2] + Vector3.distance(var_3_3, unbox_3) and 0
		var_3_23 = num / num_2
	else
		var_3_3 = nil
	end

	return var_3_3, num, num_2, var_3_23, var_3_1, var_3_2
end

MainPathUtils.collapse_main_paths = function (self)
	-- function 4
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local num = 1

	for i = 1, #self do
		local var_4_6 = self[i]
		local nodes = var_4_6.nodes
		local travel_dist = var_4_6.travel_dist
		local num_2 = num + #nodes - 1

		if i < #self then
			tbl_3[num_2] = 0
		end

		tbl_4[i] = num_2

		for j = 1, #nodes do
			tbl[num] = nodes[j]
			tbl_2[num] = travel_dist[j]
			tbl_5[num] = i
			num = num + 1
		end
	end

	for k, v in pairs(tbl_3) do
		tbl_3[k] = (tbl_2[k] + tbl_2[k + 1]) / 2
	end

	EngineOptimized.register_main_path(tbl, tbl_2, tbl_5, #self)

	return tbl, tbl_2, tbl_5, tbl_3, tbl_4
end

MainPathUtils.point_on_mainpath = function (arg_5_0, arg_5_1)
	-- function 5
	return EngineOptimized.point_on_mainpath(arg_5_1)
end

MainPathUtils.point_on_mainpath_lua = function (self, arg_6_1)
	-- function 6
	if arg_6_1 < 0 then
		return self[1].nodes[1]:unbox(), 1
	end

	local num = 0
	local get_path_point = LevelAnalysis.get_path_point

	for i = 1, #self do
		local var_6_2 = self[i]

		num = num + var_6_2.path_length

		if arg_6_1 <= num then
			local num_2 = (arg_6_1 - (num - var_6_2.path_length)) / var_6_2.path_length
			local var_6_4, var_6_5 = get_path_point(var_6_2.nodes, var_6_2.path_length, num_2)

			return var_6_4, i, var_6_5
		end
	end

	local count = #self
	local nodes = self[count].nodes

	return nodes[#nodes]:unbox(), count
end

MainPathUtils.zone_segment_on_mainpath = function (arg_7_0, arg_7_1)
	-- function 7
	local closest_pos_at_main_path, var_7_1, var_7_2 = MainPathUtils.closest_pos_at_main_path(arg_7_0, arg_7_1)

	return (math.floor((var_7_1 + 5) / 10))
end

function moll()
	-- function 8
	local point_on_mainpath = EngineOptimized.point_on_mainpath(0)
	local closest_pos_at_main_path, var_8_2, var_8_3, var_8_4, var_8_5 = EngineOptimized.closest_pos_at_main_path(point_on_mainpath)
	local var_8_6 = var_8_5
	local main_path_next_break, var_8_8, var_8_9 = EngineOptimized.main_path_next_break(var_8_6)

	while not var_8_8 do
		print("MAINPATH: ", var_8_6, main_path_next_break, var_8_8, var_8_9)

		local point_on_mainpath_2 = EngineOptimized.point_on_mainpath(var_8_2 + 1)
		local closest_pos_at_main_path_2, var_8_12, var_8_13, var_8_14

		closest_pos_at_main_path_2, var_8_2, var_8_12, var_8_13, var_8_14 = EngineOptimized.closest_pos_at_main_path(point_on_mainpath_2)

		QuickDrawerStay:sphere(closest_pos_at_main_path_2, 3, Color(0, 0, 255))

		if var_8_14 ~= var_8_6 then
			local main_path_next_break_2, var_8_16, var_8_17 = EngineOptimized.main_path_next_break(var_8_14)

			var_8_6 = var_8_14
		else
			break
		end
	end
end

local tbl = {
	0,
	1,
	-1,
	5,
	-5,
	20,
	-20
}
local count = #tbl

MainPathUtils.closest_pos_at_collapsed_main_path = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	arg_9_4 = arg_9_4 or 1

	local count_2 = #self
	local num = count_2 - 1
	local clamp = math.clamp
	local huge = math.huge
	local var_9_4 = Vector3(0, 0, 0)
	local flag = false
	local var_9_6 = arg_9_1[count_2]

	arg_9_3 = arg_9_3 or self[1]:unbox()

	local set_xyz = Vector3.set_xyz
	local to_elements = Vector3.to_elements
	local closest_point_on_line = Geometry.closest_point_on_line

	for i = 1, count do
		local num_2 = arg_9_4 + tbl[i]
		local var_9_11 = clamp(num_2, 1, num)
		local unbox = self[var_9_11]:unbox()
		local unbox_2 = self[var_9_11 + 1]:unbox()
		local var_9_14 = closest_point_on_line(arg_9_3, unbox, unbox_2)
		local var_9_15 = distance_squared(arg_9_3, var_9_14)

		if var_9_15 < huge then
			huge = var_9_15
			flag = var_9_11

			set_xyz(var_9_4, to_elements(var_9_14))
		end
	end

	local var_9_16
	local var_9_17
	local num_3 = 0

	if not flag then
		local unbox_3 = self[flag]:unbox()
		local var_9_20 = arg_9_1[flag]

		num_3 = var_9_20 + distance(var_9_4, unbox_3)

		local var_9_21 = arg_9_2[flag]

		if not (not var_9_21 and not (var_9_20 < num_3)) then
			if var_9_21 < num_3 then
				num_3 = arg_9_1[flag + 1]
				var_9_4 = self[flag + 1]:unbox()
			else
				num_3 = var_9_20
				var_9_4 = unbox_3
			end
		end

		var_9_16 = num_3 / var_9_6
	else
		var_9_4 = nil
	end

	return var_9_4, num_3, var_9_16, flag
end

MainPathUtils.resolve_node_in_door = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	if ScriptUnit.has_extension(arg_10_2, "nav_graph_system") == nil then
		return arg_10_1
	end

	local system = Managers.state.entity:system("nav_graph_system")
	local get_smart_object_id = system:get_smart_object_id(arg_10_2)
	local get_smart_objects = system:get_smart_objects(get_smart_object_id)

	for k, v in pairs(get_smart_objects) do
		local unbox = Vector3Aux.unbox(v.pos1)
		local unbox_2 = Vector3Aux.unbox(v.pos2)

		if Vector3.distance_squared(arg_10_1, unbox) < Vector3.distance_squared(arg_10_1, unbox_2) then
			arg_10_1 = unbox
		else
			arg_10_1 = unbox_2
		end

		local triangle_from_position, var_10_6 = GwNavQueries.triangle_from_position(arg_10_0, arg_10_1, 1.5, 1.5)

		if not triangle_from_position then
			arg_10_1.z = var_10_6

			break
		end

		arg_10_1 = nil

		break
	end

	return arg_10_1
end

local num = 1.5

MainPathUtils.node_list_from_main_paths = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local system = Managers.state.entity:system("door_system")
	local tbl_5 = {}

	for i = 1, #arg_11_1 do
		local nodes = arg_11_1[i].nodes

		for j = 1, #nodes do
			local var_11_7 = nodes[j]

			tbl[#tbl + 1] = var_11_7

			if not (i == 1 or j ~= 1) then
				tbl_4[var_11_7] = true
			elseif not (i == #arg_11_1 or j ~= #nodes) then
				tbl_3[var_11_7] = true
			end

			if not arg_11_2 then
				local var_11_8 = nodes[j + 1]

				if not var_11_8 then
					local num_2 = var_11_8:unbox() - var_11_7:unbox()
					local length = Vector3.length(num_2)

					if arg_11_2 < length then
						local normalize = Vector3.normalize(num_2)
						local floor = math.floor(length / arg_11_2)

						for k = 1, floor do
							local num_3 = var_11_7:unbox() + normalize * k * arg_11_2

							if system:get_doors(num_3, num, tbl_5) > 0 then
								local var_11_14 = tbl_5[1]

								num_3 = MainPathUtils.resolve_node_in_door(arg_11_0, num_3, var_11_14)
							else
								local triangle_from_position, var_11_16 = GwNavQueries.triangle_from_position(arg_11_0, num_3, 1.5, 1.5)

								if not triangle_from_position then
									num_3.z = var_11_16
								else
									num_3 = nil
								end
							end

							if not num_3 then
								local var_11_17 = Vector3Box(num_3)

								tbl[#tbl + 1] = var_11_17
							end
						end
					end
				end
			end
		end
	end

	if not arg_11_3 then
		for l = 1, #arg_11_3 do
			local var_11_18 = arg_11_3[l]
			local unbox = var_11_18.position:unbox()
			local closest_pos_at_main_path_lua, var_11_21, var_11_22, var_11_23, var_11_24, var_11_25 = MainPathUtils.closest_pos_at_main_path_lua({
				{
					path_length = 1,
					nodes = tbl
				}
			}, unbox)

			if not (not closest_pos_at_main_path_lua and not (distance_squared(closest_pos_at_main_path_lua, unbox) <= var_11_18.radius_sq)) then
				local var_11_26 = tbl[var_11_25]

				tbl_3[tbl[var_11_25]] = true
				tbl_4[tbl[var_11_25 + 1]] = true
			end
		end
	end

	for i4 = #tbl, 1, -1 do
		tbl_2[#tbl_2 + 1] = tbl[i4]
	end

	return tbl, tbl_2, tbl_3, tbl_4
end

MainPathUtils.closest_node_in_node_list = function (self, arg_12_1)
	-- function 12
	local huge = math.huge
	local var_12_1

	for i = 1, #self do
		local unbox = self[i]:unbox()
		local var_12_3 = distance_squared(arg_12_1, unbox)

		if var_12_3 < huge then
			huge = var_12_3
			var_12_1 = i
		end
	end

	return var_12_1
end

MainPathUtils.ray_along_node_list = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local flag

	flag = arg_13_3 ~= -1 or not 1 or #arg_13_1

	local num = 0

	for i = arg_13_2, flag, arg_13_3 do
		local var_13_2 = arg_13_1[i + arg_13_3]

		if not var_13_2 then
			return num
		end

		local unbox = arg_13_1[i]:unbox()
		local unbox_2 = var_13_2:unbox()
		local raycast, var_13_6 = GwNavQueries.raycast(arg_13_0, unbox, unbox_2)

		if not raycast then
			num = num + Vector3.length(unbox_2 - unbox)

			if arg_13_4 <= num then
				return arg_13_4
			end
		else
			num = num + Vector3.length(var_13_6 - unbox)

			if arg_13_4 <= num then
				return arg_13_4
			else
				return num
			end
		end
	end
end

MainPathUtils.find_equidistant_points_in_node_list = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local var_14_0 = arg_14_1
	local num = 1
	local num_2 = 0

	while true do
		local var_14_3 = self[var_14_0 + arg_14_2]

		if not var_14_3 then
			return arg_14_5
		end

		local unbox = self[var_14_0]:unbox()
		local num_3 = var_14_3:unbox() - unbox
		local length = Vector3.length(num_3)
		local normalize = Vector3.normalize(num_3)
		local ceil = math.ceil((length - num_2) / arg_14_3)

		for i = 0, ceil - 1 do
			arg_14_5[num] = {
				unbox + normalize * (num_2 + i * arg_14_3),
				normalize * arg_14_2,
				var_14_0
			}
			num = num + 1

			if not (not arg_14_4 and not (arg_14_4 < num)) then
				return arg_14_5
			end
		end

		local num_4 = length - (ceil - 1) * arg_14_3

		num_2 = num_2 + arg_14_3 - num_4
		var_14_0 = var_14_0 + arg_14_2
	end
end

MainPathUtils.get_main_path_point_between_players = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0
	local var_15_1
	local num

	if not arg_15_1.ahead_unit then
		var_15_0 = 0
		num = 0
	else
		var_15_0 = arg_15_2[arg_15_1.ahead_unit].travel_dist
		num = arg_15_2[arg_15_1.behind_unit].travel_dist
	end

	local num_2 = num + (var_15_0 - num) * 0.5
	local clamp = math.clamp(num_2, 0, MainPathUtils.total_path_dist() - 0.1)
	local point_on_mainpath, var_15_6 = MainPathUtils.point_on_mainpath(self, clamp)
	local var_15_7 = self[var_15_6]
	local closest_node_in_node_list = MainPathUtils.closest_node_in_node_list(var_15_7.nodes, point_on_mainpath)
	local var_15_9 = var_15_7.nodes[closest_node_in_node_list]
	local var_15_10 = var_15_7.nodes[closest_node_in_node_list + 1]
	local var_15_11 = var_15_7.nodes[closest_node_in_node_list - 1]
	local var_15_12

	if not var_15_10 then
		var_15_12 = var_15_10:unbox() - var_15_9:unbox()
	elseif not var_15_11 then
		var_15_12 = var_15_9:unbox() - var_15_11:unbox()
	end

	local look

	if not var_15_12 then
		look = Quaternion.look(var_15_12)

		if not look then
			-- Nothing
		end
	end

	look = Quaternion.identity()

	::label_15_0::

	return Vector3Box(point_on_mainpath), QuaternionBox(look)
end
