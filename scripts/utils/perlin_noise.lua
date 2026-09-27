-- chunkname: @scripts/utils/perlin_noise.lua

PerlinNoise = class(PerlinNoise)

PerlinNoise.init = function (self, arg_1_1)
	-- function 1
	self._n = 256
	self._permutations = {}
	self._gradients = {}
	self.world = arg_1_1
	self.world_gui = World.create_world_gui(arg_1_1, Matrix4x4.identity(), 1, 1, "material", "materials/fonts/gw_fonts")
	self._line_object = World.create_line_object(arg_1_1, false)

	self:setup()
end

local tbl = {
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
	-- function 2
	local drawer = Managers.state.debug:drawer({
		mode = "lel",
		name = "perlin noise"
	})
	local num = (math.clamp(arg_2_1 * 100, -15, 15) + 15) / 2
	local floor = math.floor(num)

	if floor == 0 then
		floor = 1
	end

	local var_2_3 = tbl[floor]

	drawer:sphere(Vector3(arg_2_2, arg_2_3, arg_2_4 + 0.5), arg_2_5 or 0.35, Color(var_2_3[1], var_2_3[2], var_2_3[3]))
end

PerlinNoise.filter_list_using_noise = function (self, arg_3_1, arg_3_2)
	-- function 3
	local temp_count, var_3_1, var_3_2 = Script.temp_count()
	local num = 0
	local num_2 = 0

	for i = #arg_3_1, 1, -1 do
		local unbox = arg_3_1[i]:unbox()
		local x = unbox.x
		local y = unbox.y
		local get_height = self:get_height(x, y)
		local var_3_9

		if get_height < arg_3_2 then
			arg_3_1[i] = arg_3_1[#arg_3_1]
			arg_3_1[#arg_3_1] = nil
		else
			var_3_9 = 0.8
		end

		if not script_data.debug_perlin_noise_spawning then
			self:draw_height(get_height, x, y, unbox.z, var_3_9)
		end

		if get_height < num then
			num = get_height
		elseif num_2 <= get_height then
			num_2 = get_height
		end

		Script.set_temp_count(temp_count, var_3_1, var_3_2)
	end

	print("Lowest and highest heights are", num, num_2)

	return arg_3_1
end

PerlinNoise.normalize = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0
	local sqrt = math.sqrt(arg_4_1 * arg_4_1 + arg_4_2 * arg_4_2)

	assert(sqrt ~= 0, "dividing by zero is not recommended")

	arg_4_1 = arg_4_1 / sqrt
	arg_4_2 = arg_4_2 / sqrt

	return arg_4_1, arg_4_2
end

PerlinNoise.setup = function (self)
	-- function 5
	for i = 1, self._n do
		self._permutations[i] = i
		self._gradients[i] = {
			false,
			false
		}

		local flag = true

		repeat
			for j = 1, 2 do
				self._gradients[i][j] = Math.random(-10, 10) * 0.1
				flag = not flag and self._gradients[i][j] == 0
			end
		until not flag

		self._gradients[i][1], self._gradients[i][2] = self:normalize(self._gradients[i][1], self._gradients[i][2])
	end

	local var_5_1
	local var_5_2

	for k = self._n, 1, -1 do
		local var_5_3 = self._permutations[k]
		local random = Math.random(self._n)

		self._permutations[k] = self._permutations[random]
		self._permutations[random] = var_5_3
	end

	for l = 1, self._n + 2 do
		self._permutations[self._n + l] = self._permutations[l]
		self._gradients[self._n + l] = {
			false,
			false
		}

		for i4 = 1, 2 do
			self._gradients[self._n + l][i4] = self._gradients[l][i4]
		end
	end
end

PerlinNoise.get_height = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = arg_6_1
	local var_6_1 = arg_6_2
	local num = arg_6_1 + 4096
	local num_2 = arg_6_2 + 4096
	local num_3 = math.floor(num) % self._n
	local num_4 = (num_3 + 1) % self._n
	local num_5 = math.floor(num_2) % self._n
	local num_6 = (num_5 + 1) % self._n

	if num_3 == 0 then
		num_3 = 1
	end

	if num_5 == 0 then
		num_5 = 1
	end

	if num_4 == 0 then
		num_4 = 1
	end

	if num_6 == 0 then
		num_6 = 1
	end

	local num_7 = num - math.floor(num)
	local num_8 = num_7 - 1
	local num_9 = num_2 - math.floor(num_2)
	local num_10 = num_9 - 1
	local var_6_12 = self._permutations[num_3]
	local var_6_13 = self._permutations[num_4]
	local var_6_14 = self._permutations[var_6_12 + num_5]
	local var_6_15 = self._permutations[var_6_13 + num_5]
	local var_6_16 = self._permutations[var_6_12 + num_6]
	local var_6_17 = self._permutations[var_6_13 + num_6]
	local getSCurve = self:getSCurve(num_7)
	local getSCurve_2 = self:getSCurve(num_9)
	local var_6_20
	local var_6_21
	local var_6_22
	local var_6_23
	local var_6_24
	local var_6_25 = self._gradients[var_6_14]
	local at2 = self:at2(var_6_25, num_7, num_9)
	local var_6_27 = self._gradients[var_6_15]
	local at2_2 = self:at2(var_6_27, num_8, num_9)
	local var_6_29 = self._gradients[var_6_16]
	local at2_3 = self:at2(var_6_29, num_7, num_10)
	local var_6_31 = self._gradients[var_6_17]
	local at2_4 = self:at2(var_6_31, num_8, num_10)
	local lerp = math.lerp(at2, at2_2, getSCurve)
	local lerp_2 = math.lerp(at2_3, at2_4, getSCurve)

	return (math.lerp(lerp, lerp_2, getSCurve_2))
end

PerlinNoise.at2 = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	return arg_7_1[1] * arg_7_2 + arg_7_1[2] * arg_7_3
end

PerlinNoise.getSCurve = function (arg_8_0, arg_8_1)
	-- function 8
	return 6 * arg_8_1^5 - 15 * arg_8_1^4 + 10 * arg_8_1^3
end

PerlinNoise.simulate_points = function (self)
	-- function 9
	local drawer = Managers.state.debug:drawer({
		mode = "lel",
		name = "perlin noise"
	})
	local world_gui = self.world_gui
	local identity = Matrix4x4.identity()
	local num = 0.1
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local num_2 = 0
	local num_3 = 0

	for i = self._lowest_point.x, self._highest_point.x do
		local var_9_8 = i

		i = i + Math.random(-1, 1) / 10

		for j = self._lowest_point.y, self._highest_point.y do
			local var_9_9 = j

			j = j + Math.random(-1, 1) / 10

			local get_height = self:get_height(i, j)

			if get_height < num_2 then
				num_2 = get_height
			elseif num_3 < get_height then
				num_3 = get_height
			end

			local num_4 = (math.clamp(get_height * 100, -15, 15) + 15) / 2
			local floor = math.floor(num_4)

			if floor == 0 then
				floor = 1
			end

			print(floor)

			local var_9_13 = tbl[floor]

			j = var_9_9

			drawer:sphere(Vector3(var_9_8, var_9_9, 100), 0.5, Color(var_9_13[1], var_9_13[2], var_9_13[3]))
		end

		i = var_9_8
	end

	print("lowest and highest", num_2, num_3)
end
