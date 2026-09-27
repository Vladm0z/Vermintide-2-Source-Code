-- chunkname: @scripts/managers/conflict_director/perlin_path.lua

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local next_random, var_1_1 = Math.next_random(arg_1_0 + arg_1_1)
	local next_random_2, var_1_3 = Math.next_random(next_random)

	return var_1_3 * 2 - 1
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	return fn(arg_2_0, arg_2_1) / 2 + fn(arg_2_0 - 1, arg_2_1) / 4 + fn(arg_2_0 + 1, arg_2_1) / 4
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local floor = math.floor(arg_3_0)
	local num = arg_3_0 - floor
	local var_3_2 = fn_2(floor, arg_3_1)
	local var_3_3 = fn_2(floor + 1, arg_3_1)

	return math.lerp(var_3_2, var_3_3, num)
end

PerlinPath = {}

PerlinPath.make_perlin_path = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local num = 0
	local tbl = {}

	for i = arg_4_0, arg_4_1 do
		local tbl_2 = {}
		local num_2 = arg_4_2^i
		local num_3 = 0
		local num_4 = 1 / i

		for j = 0, i do
			local next_random, var_4_7 = Math.next_random(num_3 + arg_4_3)
			local next_random_2, var_4_9 = Math.next_random(next_random)

			tbl_2[j] = {
				num_3,
				var_4_9 * num_2
			}
			num_3 = num_3 + num_4
			arg_4_3 = next_random
		end

		tbl[i - arg_4_0 + 1] = tbl_2
	end

	return tbl
end

local num = 1345600
local num_2 = 25

PerlinPath.make_easy_path = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local tbl = {}
	local num = arg_5_2 / num_2
	local num_3 = arg_5_2 / math.floor(num)
	local num_4 = 0

	for i = 1, num do
		local get_path_point = LevelAnalysis.get_path_point(arg_5_1, arg_5_2, i / num)

		tbl[#tbl + 1] = Vector3Box(get_path_point)
	end

	return PerlinPath.fill_spawns(arg_5_0, tbl, arg_5_2)
end

local distance_squared = Vector3.distance_squared

PerlinPath.fill_spawns = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local tbl = {}
	local var_6_1
	local num_2 = 0
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for i = 1, #arg_6_1 do
		local unbox = arg_6_1[i]:unbox()
		local get_seed_triangle = GwNavTraversal.get_seed_triangle(arg_6_0, unbox)

		if not get_seed_triangle then
			num_2 = num_2 + 1
			tbl_2[num_2] = get_seed_triangle
			tbl_3[num_2] = unbox

			local temp_count, var_6_9, var_6_10 = Script.temp_count()
			local get_triangle_vertices, var_6_12, var_6_13 = GwNavTraversal.get_triangle_vertices(arg_6_0, get_seed_triangle)
			local num_3 = (get_triangle_vertices + var_6_12 + var_6_13) / 3
			local num_4 = num_3.x * 0.0001 + num_3.y + num_3.z * 10000

			tbl_4[num_2] = Vector3.length(Vector3.cross(var_6_12 - get_triangle_vertices, var_6_13 - get_triangle_vertices)) / 2

			Script.set_temp_count(temp_count, var_6_9, var_6_10)

			tbl[num_4] = num_2
		end
	end

	local num_5 = 0

	while num_5 < num_2 do
		num_5 = num_5 + 1

		local var_6_17 = tbl_2[num_5]
		local temp_count_2, var_6_19, var_6_20 = Script.temp_count()
		local get_triangle_vertices_2, var_6_22, var_6_23 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_17)
		local num_6 = (get_triangle_vertices_2 + var_6_22 + var_6_23) / 3
		local var_6_25 = tbl[num_6.x * 0.0001 + num_6.y + num_6.z * 10000]

		tbl_4[var_6_25] = tbl_4[var_6_25] + Vector3.length(Vector3.cross(var_6_22 - get_triangle_vertices_2, var_6_23 - get_triangle_vertices_2)) / 2

		Script.set_temp_count(temp_count_2, var_6_19, var_6_20)

		local var_6_26 = tbl_3[var_6_25 - 1]
		local var_6_27 = tbl_3[var_6_25]
		local var_6_28 = tbl_3[var_6_25 + 1]
		local tbl_5 = {
			GwNavTraversal.get_neighboring_triangles(var_6_17)
		}

		for j = 1, #tbl_5 do
			local var_6_30 = tbl_5[j]
			local temp_count_3, var_6_32, var_6_33 = Script.temp_count()
			local get_triangle_vertices_3, var_6_35, var_6_36 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_30)
			local var_6_37 = var_6_36
			local var_6_38 = var_6_35
			local num_7 = (get_triangle_vertices_3 + var_6_38 + var_6_37) / 3
			local num_8 = num_7.x * 0.0001 + num_7.y + num_7.z * 10000

			if not tbl[num_8] then
				local get_triangle_vertices_4, var_6_42, var_6_43 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_30)
				local var_6_44

				if not var_6_26 then
					var_6_44 = distance_squared(var_6_26, num_7)

					if not var_6_44 then
						-- Nothing
					end
				end

				var_6_44 = math.huge

				do
					local var_6_45
				end

				::label_6_0::

				if not var_6_27 then
					var_6_45 = distance_squared(var_6_27, num_7)

					if not var_6_45 then
						-- Nothing
					end
				end

				var_6_45 = math.huge

				do
					local var_6_46
				end

				::label_6_1::

				if not var_6_28 then
					var_6_46 = distance_squared(var_6_28, num_7)

					if not var_6_46 then
						-- Nothing
					end
				end

				var_6_46 = math.huge

				::label_6_2::

				local var_6_47

				if var_6_44 < var_6_45 then
					if not (not var_6_46 and not (var_6_44 < var_6_46)) then
						if var_6_44 < num then
							var_6_47 = var_6_25 - 1
						else
							var_6_47 = 1
						end
					elseif var_6_46 < num then
						var_6_47 = var_6_25 + 1
					else
						var_6_47 = 1
					end
				elseif var_6_45 < var_6_46 then
					if var_6_45 < num then
						var_6_47 = var_6_25
					else
						var_6_47 = 1
					end
				elseif var_6_46 < num then
					var_6_47 = var_6_25 + 1
				else
					var_6_47 = 1
				end

				num_2 = num_2 + 1
				tbl_2[num_2] = var_6_30
				tbl[num_8] = var_6_47
			end

			Script.set_temp_count(temp_count_3, var_6_32, var_6_33)
		end
	end

	for k = 1, #tbl_4 do
		print("area " .. k .. ") " .. tbl_4[k])
	end

	print("DONE!", #tbl_2)

	return tbl_2, tbl, tbl_4
end

PerlinPath.populate_spawns = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	return
end

PerlinPath.draw_debug_spawns = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local count = #arg_8_2

	for i = 1, count do
		local var_8_1 = arg_8_2[i]
		local temp_count, var_8_3, var_8_4 = Script.temp_count()
		local var_8_5 = Vector3(0, 0, 0.1)
		local get_triangle_vertices, var_8_7, var_8_8 = GwNavTraversal.get_triangle_vertices(arg_8_0, var_8_1)
		local num = (get_triangle_vertices + var_8_7 + var_8_8) / 3
		local num_2 = num.x * 0.0001 + num.y + num.z * 10000

		Gui.triangle(arg_8_1, get_triangle_vertices + var_8_5, var_8_7 + var_8_5, var_8_8 + var_8_5, 2, Colors.get_indexed((12 + arg_8_3[num_2]) % 32 + 1))
		Script.set_temp_count(temp_count, var_8_3, var_8_4)
	end
end

PerlinPath.make_path = function (arg_9_0, arg_9_1)
	-- function 9
	local num = 1 / arg_9_1
	local num_2 = 0

	for i = start_oktave, end_oktave do
		num_2 = num_2 + num
	end
end

PerlinPath.normalize_path = function (self, arg_10_1)
	-- function 10
	local num = 0
	local num_2 = #self - 1

	for i = 1, num_2 do
		num = num + (self[i][2] + self[i + 1][2]) * 0.5
	end

	return arg_10_1 / (num / num_2)
end
