-- chunkname: @scripts/utils/perlin_noise.lua

PerlinNoise = class(PerlinNoise)

PerlinNoise.init = function (arg_1_0, arg_1_1)
	arg_1_0._n = 256
	arg_1_0._permutations = {}
	arg_1_0._gradients = {}
	arg_1_0.world = arg_1_1
	arg_1_0.world_gui = World.create_world_gui(arg_1_1, Matrix4x4.identity(), 1, 1, "material", "materials/fonts/gw_fonts")
	arg_1_0._line_object = World.create_line_object(arg_1_1, false)

	arg_1_0:setup()
end

local var_0_0 = {
	{
		30,
		30,
		30
	},
	{
		45,
		45,
		45
	},
	{
		60,
		60,
		60
	},
	{
		85,
		85,
		85
	},
	{
		100,
		100,
		100
	},
	{
		115,
		115,
		115
	},
	{
		130,
		130,
		130
	},
	{
		145,
		145,
		145
	},
	{
		160,
		160,
		160
	},
	{
		175,
		175,
		175
	},
	{
		190,
		190,
		190
	},
	{
		205,
		205,
		205
	},
	{
		220,
		220,
		220
	},
	{
		235,
		235,
		235
	},
	{
		255,
		255,
		255
	}
}

PerlinNoise.draw_height = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = Managers.state.debug:drawer({
		mode = "lel",
		name = "perlin noise"
	})
	local var_2_1 = (math.clamp(arg_2_1 * 100, -15, 15) + 15) / 2
	local var_2_2 = math.floor(var_2_1)

	if var_2_2 == 0 then
		var_2_2 = 1
	end

	local var_2_3 = var_0_0[var_2_2]

	var_2_0:sphere(Vector3(arg_2_2, arg_2_3, arg_2_4 + 0.5), arg_2_5 or 0.35, Color(var_2_3[1], var_2_3[2], var_2_3[3]))
end

PerlinNoise.filter_list_using_noise = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0, var_3_1, var_3_2 = Script.temp_count()
	local var_3_3 = 0
	local var_3_4 = 0

	for iter_3_0 = #arg_3_1, 1, -1 do
		local var_3_5 = arg_3_1[iter_3_0]:unbox()
		local var_3_6 = var_3_5.x
		local var_3_7 = var_3_5.y
		local var_3_8 = arg_3_0:get_height(var_3_6, var_3_7)
		local var_3_9

		if var_3_8 < arg_3_2 then
			arg_3_1[iter_3_0] = arg_3_1[#arg_3_1]
			arg_3_1[#arg_3_1] = nil
		else
			var_3_9 = 0.8
		end

		if script_data.debug_perlin_noise_spawning then
			arg_3_0:draw_height(var_3_8, var_3_6, var_3_7, var_3_5.z, var_3_9)
		end

		if var_3_8 < var_3_3 then
			var_3_3 = var_3_8
		elseif var_3_4 <= var_3_8 then
			var_3_4 = var_3_8
		end

		Script.set_temp_count(var_3_0, var_3_1, var_3_2)
	end

	print("Lowest and highest heights are", var_3_3, var_3_4)

	return arg_3_1
end

PerlinNoise.normalize = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0
	local var_4_1 = math.sqrt(arg_4_1 * arg_4_1 + arg_4_2 * arg_4_2)

	assert(var_4_1 ~= 0, "dividing by zero is not recommended")

	arg_4_1 = arg_4_1 / var_4_1
	arg_4_2 = arg_4_2 / var_4_1

	return arg_4_1, arg_4_2
end

PerlinNoise.setup = function (arg_5_0)
	for iter_5_0 = 1, arg_5_0._n do
		arg_5_0._permutations[iter_5_0] = iter_5_0
		arg_5_0._gradients[iter_5_0] = {
			false,
			false
		}

		local var_5_0 = true

		repeat
			for iter_5_1 = 1, 2 do
				arg_5_0._gradients[iter_5_0][iter_5_1] = Math.random(-10, 10) * 0.1
				var_5_0 = var_5_0 and arg_5_0._gradients[iter_5_0][iter_5_1] == 0
			end
		until not var_5_0

		arg_5_0._gradients[iter_5_0][1], arg_5_0._gradients[iter_5_0][2] = arg_5_0:normalize(arg_5_0._gradients[iter_5_0][1], arg_5_0._gradients[iter_5_0][2])
	end

	local var_5_1
	local var_5_2

	for iter_5_2 = arg_5_0._n, 1, -1 do
		local var_5_3 = arg_5_0._permutations[iter_5_2]
		local var_5_4 = Math.random(arg_5_0._n)

		arg_5_0._permutations[iter_5_2] = arg_5_0._permutations[var_5_4]
		arg_5_0._permutations[var_5_4] = var_5_3
	end

	for iter_5_3 = 1, arg_5_0._n + 2 do
		arg_5_0._permutations[arg_5_0._n + iter_5_3] = arg_5_0._permutations[iter_5_3]
		arg_5_0._gradients[arg_5_0._n + iter_5_3] = {
			false,
			false
		}

		for iter_5_4 = 1, 2 do
			arg_5_0._gradients[arg_5_0._n + iter_5_3][iter_5_4] = arg_5_0._gradients[iter_5_3][iter_5_4]
		end
	end
end

PerlinNoise.get_height = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1
	local var_6_1 = arg_6_2
	local var_6_2 = arg_6_1 + 4096
	local var_6_3 = arg_6_2 + 4096
	local var_6_4 = math.floor(var_6_2) % arg_6_0._n
	local var_6_5 = (var_6_4 + 1) % arg_6_0._n
	local var_6_6 = math.floor(var_6_3) % arg_6_0._n
	local var_6_7 = (var_6_6 + 1) % arg_6_0._n

	if var_6_4 == 0 then
		var_6_4 = 1
	end

	if var_6_6 == 0 then
		var_6_6 = 1
	end

	if var_6_5 == 0 then
		var_6_5 = 1
	end

	if var_6_7 == 0 then
		var_6_7 = 1
	end

	local var_6_8 = var_6_2 - math.floor(var_6_2)
	local var_6_9 = var_6_8 - 1
	local var_6_10 = var_6_3 - math.floor(var_6_3)
	local var_6_11 = var_6_10 - 1
	local var_6_12 = arg_6_0._permutations[var_6_4]
	local var_6_13 = arg_6_0._permutations[var_6_5]
	local var_6_14 = arg_6_0._permutations[var_6_12 + var_6_6]
	local var_6_15 = arg_6_0._permutations[var_6_13 + var_6_6]
	local var_6_16 = arg_6_0._permutations[var_6_12 + var_6_7]
	local var_6_17 = arg_6_0._permutations[var_6_13 + var_6_7]
	local var_6_18 = arg_6_0:getSCurve(var_6_8)
	local var_6_19 = arg_6_0:getSCurve(var_6_10)
	local var_6_20
	local var_6_21
	local var_6_22
	local var_6_23
	local var_6_24
	local var_6_25 = arg_6_0._gradients[var_6_14]
	local var_6_26 = arg_6_0:at2(var_6_25, var_6_8, var_6_10)
	local var_6_27 = arg_6_0._gradients[var_6_15]
	local var_6_28 = arg_6_0:at2(var_6_27, var_6_9, var_6_10)
	local var_6_29 = arg_6_0._gradients[var_6_16]
	local var_6_30 = arg_6_0:at2(var_6_29, var_6_8, var_6_11)
	local var_6_31 = arg_6_0._gradients[var_6_17]
	local var_6_32 = arg_6_0:at2(var_6_31, var_6_9, var_6_11)
	local var_6_33 = math.lerp(var_6_26, var_6_28, var_6_18)
	local var_6_34 = math.lerp(var_6_30, var_6_32, var_6_18)

	return (math.lerp(var_6_33, var_6_34, var_6_19))
end

PerlinNoise.at2 = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	return arg_7_1[1] * arg_7_2 + arg_7_1[2] * arg_7_3
end

PerlinNoise.getSCurve = function (arg_8_0, arg_8_1)
	return 6 * arg_8_1^5 - 15 * arg_8_1^4 + 10 * arg_8_1^3
end

PerlinNoise.simulate_points = function (arg_9_0)
	local var_9_0 = Managers.state.debug:drawer({
		mode = "lel",
		name = "perlin noise"
	})
	local var_9_1 = arg_9_0.world_gui
	local var_9_2 = Matrix4x4.identity()
	local var_9_3 = 0.1
	local var_9_4 = "arial"
	local var_9_5 = "materials/fonts/" .. var_9_4
	local var_9_6 = 0
	local var_9_7 = 0

	for iter_9_0 = arg_9_0._lowest_point.x, arg_9_0._highest_point.x do
		local var_9_8 = iter_9_0

		iter_9_0 = iter_9_0 + Math.random(-1, 1) / 10

		for iter_9_1 = arg_9_0._lowest_point.y, arg_9_0._highest_point.y do
			local var_9_9 = iter_9_1

			iter_9_1 = iter_9_1 + Math.random(-1, 1) / 10

			local var_9_10 = arg_9_0:get_height(iter_9_0, iter_9_1)

			if var_9_10 < var_9_6 then
				var_9_6 = var_9_10
			elseif var_9_7 < var_9_10 then
				var_9_7 = var_9_10
			end

			local var_9_11 = (math.clamp(var_9_10 * 100, -15, 15) + 15) / 2
			local var_9_12 = math.floor(var_9_11)

			if var_9_12 == 0 then
				var_9_12 = 1
			end

			print(var_9_12)

			local var_9_13 = var_0_0[var_9_12]

			iter_9_1 = var_9_9

			var_9_0:sphere(Vector3(var_9_8, var_9_9, 100), 0.5, Color(var_9_13[1], var_9_13[2], var_9_13[3]))
		end

		iter_9_0 = var_9_8
	end

	print("lowest and highest", var_9_6, var_9_7)
end
