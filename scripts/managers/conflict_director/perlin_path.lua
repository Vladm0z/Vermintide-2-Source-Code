-- chunkname: @scripts/managers/conflict_director/perlin_path.lua

local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0, var_1_1 = Math.next_random(arg_1_0 + arg_1_1)
	local var_1_2, var_1_3 = Math.next_random(var_1_0)

	return var_1_3 * 2 - 1
end

local function var_0_1(arg_2_0, arg_2_1)
	return var_0_0(arg_2_0, arg_2_1) / 2 + var_0_0(arg_2_0 - 1, arg_2_1) / 4 + var_0_0(arg_2_0 + 1, arg_2_1) / 4
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0 = math.floor(arg_3_0)
	local var_3_1 = arg_3_0 - var_3_0
	local var_3_2 = var_0_1(var_3_0, arg_3_1)
	local var_3_3 = var_0_1(var_3_0 + 1, arg_3_1)

	return math.lerp(var_3_2, var_3_3, var_3_1)
end

PerlinPath = {}

function PerlinPath.make_perlin_path(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = 0
	local var_4_1 = {}

	for iter_4_0 = arg_4_0, arg_4_1 do
		local var_4_2 = {}
		local var_4_3 = arg_4_2^iter_4_0
		local var_4_4 = 0
		local var_4_5 = 1 / iter_4_0

		for iter_4_1 = 0, iter_4_0 do
			local var_4_6, var_4_7 = Math.next_random(var_4_4 + arg_4_3)
			local var_4_8, var_4_9 = Math.next_random(var_4_6)

			var_4_2[iter_4_1] = {
				var_4_4,
				var_4_9 * var_4_3
			}
			var_4_4 = var_4_4 + var_4_5
			arg_4_3 = var_4_6
		end

		var_4_1[iter_4_0 - arg_4_0 + 1] = var_4_2
	end

	return var_4_1
end

local var_0_3 = 1345600
local var_0_4 = 25

function PerlinPath.make_easy_path(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {}
	local var_5_1 = arg_5_2 / var_0_4
	local var_5_2 = arg_5_2 / math.floor(var_5_1)
	local var_5_3 = 0

	for iter_5_0 = 1, var_5_1 do
		local var_5_4 = LevelAnalysis.get_path_point(arg_5_1, arg_5_2, iter_5_0 / var_5_1)

		var_5_0[#var_5_0 + 1] = Vector3Box(var_5_4)
	end

	return PerlinPath.fill_spawns(arg_5_0, var_5_0, arg_5_2)
end

local var_0_5 = Vector3.distance_squared

function PerlinPath.fill_spawns(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = {}
	local var_6_1
	local var_6_2 = 0
	local var_6_3 = {}
	local var_6_4 = {}
	local var_6_5 = {}

	for iter_6_0 = 1, #arg_6_1 do
		local var_6_6 = arg_6_1[iter_6_0]:unbox()
		local var_6_7 = GwNavTraversal.get_seed_triangle(arg_6_0, var_6_6)

		if var_6_7 then
			var_6_2 = var_6_2 + 1
			var_6_3[var_6_2] = var_6_7
			var_6_4[var_6_2] = var_6_6

			local var_6_8, var_6_9, var_6_10 = Script.temp_count()
			local var_6_11, var_6_12, var_6_13 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_7)
			local var_6_14 = (var_6_11 + var_6_12 + var_6_13) / 3
			local var_6_15 = var_6_14.x * 0.0001 + var_6_14.y + var_6_14.z * 10000

			var_6_5[var_6_2] = Vector3.length(Vector3.cross(var_6_12 - var_6_11, var_6_13 - var_6_11)) / 2

			Script.set_temp_count(var_6_8, var_6_9, var_6_10)

			var_6_0[var_6_15] = var_6_2
		end
	end

	local var_6_16 = 0

	while var_6_16 < var_6_2 do
		var_6_16 = var_6_16 + 1

		local var_6_17 = var_6_3[var_6_16]
		local var_6_18, var_6_19, var_6_20 = Script.temp_count()
		local var_6_21, var_6_22, var_6_23 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_17)
		local var_6_24 = (var_6_21 + var_6_22 + var_6_23) / 3
		local var_6_25 = var_6_0[var_6_24.x * 0.0001 + var_6_24.y + var_6_24.z * 10000]

		var_6_5[var_6_25] = var_6_5[var_6_25] + Vector3.length(Vector3.cross(var_6_22 - var_6_21, var_6_23 - var_6_21)) / 2

		Script.set_temp_count(var_6_18, var_6_19, var_6_20)

		local var_6_26 = var_6_4[var_6_25 - 1]
		local var_6_27 = var_6_4[var_6_25]
		local var_6_28 = var_6_4[var_6_25 + 1]
		local var_6_29 = {
			GwNavTraversal.get_neighboring_triangles(var_6_17)
		}

		for iter_6_1 = 1, #var_6_29 do
			local var_6_30 = var_6_29[iter_6_1]
			local var_6_31, var_6_32, var_6_33 = Script.temp_count()
			local var_6_34, var_6_35, var_6_36 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_30)
			local var_6_37 = var_6_36
			local var_6_38 = var_6_35
			local var_6_39 = (var_6_34 + var_6_38 + var_6_37) / 3
			local var_6_40 = var_6_39.x * 0.0001 + var_6_39.y + var_6_39.z * 10000

			if not var_6_0[var_6_40] then
				local var_6_41, var_6_42, var_6_43 = GwNavTraversal.get_triangle_vertices(arg_6_0, var_6_30)
				local var_6_44 = var_6_26 and var_0_5(var_6_26, var_6_39) or math.huge
				local var_6_45 = var_6_27 and var_0_5(var_6_27, var_6_39) or math.huge
				local var_6_46 = var_6_28 and var_0_5(var_6_28, var_6_39) or math.huge
				local var_6_47

				if var_6_44 < var_6_45 then
					if var_6_46 and var_6_44 < var_6_46 then
						if var_6_44 < var_0_3 then
							var_6_47 = var_6_25 - 1
						else
							var_6_47 = 1
						end
					elseif var_6_46 < var_0_3 then
						var_6_47 = var_6_25 + 1
					else
						var_6_47 = 1
					end
				elseif var_6_45 < var_6_46 then
					if var_6_45 < var_0_3 then
						var_6_47 = var_6_25
					else
						var_6_47 = 1
					end
				elseif var_6_46 < var_0_3 then
					var_6_47 = var_6_25 + 1
				else
					var_6_47 = 1
				end

				var_6_2 = var_6_2 + 1
				var_6_3[var_6_2] = var_6_30
				var_6_0[var_6_40] = var_6_47
			end

			Script.set_temp_count(var_6_31, var_6_32, var_6_33)
		end
	end

	for iter_6_2 = 1, #var_6_5 do
		print("area " .. iter_6_2 .. ") " .. var_6_5[iter_6_2])
	end

	print("DONE!", #var_6_3)

	return var_6_3, var_6_0, var_6_5
end

function PerlinPath.populate_spawns(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	return
end

function PerlinPath.draw_debug_spawns(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = #arg_8_2

	for iter_8_0 = 1, var_8_0 do
		local var_8_1 = arg_8_2[iter_8_0]
		local var_8_2, var_8_3, var_8_4 = Script.temp_count()
		local var_8_5 = Vector3(0, 0, 0.1)
		local var_8_6, var_8_7, var_8_8 = GwNavTraversal.get_triangle_vertices(arg_8_0, var_8_1)
		local var_8_9 = (var_8_6 + var_8_7 + var_8_8) / 3
		local var_8_10 = var_8_9.x * 0.0001 + var_8_9.y + var_8_9.z * 10000

		Gui.triangle(arg_8_1, var_8_6 + var_8_5, var_8_7 + var_8_5, var_8_8 + var_8_5, 2, Colors.get_indexed((12 + arg_8_3[var_8_10]) % 32 + 1))
		Script.set_temp_count(var_8_2, var_8_3, var_8_4)
	end
end

function PerlinPath.make_path(arg_9_0, arg_9_1)
	local var_9_0 = 1 / arg_9_1
	local var_9_1 = 0

	for iter_9_0 = start_oktave, end_oktave do
		var_9_1 = var_9_1 + var_9_0
	end
end

function PerlinPath.normalize_path(arg_10_0, arg_10_1)
	local var_10_0 = 0
	local var_10_1 = #arg_10_0 - 1

	for iter_10_0 = 1, var_10_1 do
		var_10_0 = var_10_0 + (arg_10_0[iter_10_0][2] + arg_10_0[iter_10_0 + 1][2]) * 0.5
	end

	return arg_10_1 / (var_10_0 / var_10_1)
end
