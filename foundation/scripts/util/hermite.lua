-- chunkname: @foundation/scripts/util/hermite.lua

local Hermite = Hermite

Hermite = Hermite or {}
Hermite = Hermite

Hermite.calc_point = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local num = arg_1_0 * arg_1_0
	local num_2 = num * arg_1_0
	local num_3 = num_2 + num_2
	local num_4 = num + num
	local num_5 = num_4 + num
	local num_6 = num_3 - num_5 + 1
	local num_7 = num_5 - num_3
	local num_8 = num_2 - num_4 + arg_1_0
	local num_9 = num_2 - num
	local length = Vector3.length(arg_1_3 - arg_1_2)
	local num_10 = Vector3.normalize(arg_1_3 - arg_1_1) * length
	local num_11 = Vector3.normalize(arg_1_4 - arg_1_2) * length

	return arg_1_2 * num_6 + arg_1_3 * num_7 + num_10 * num_8 + num_11 * num_9
end

Hermite.calc_tangent = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local num = arg_2_0 * arg_2_0
	local num_2 = 6 * num - 6 * arg_2_0
	local num_3 = 6 * arg_2_0 - 6 * num
	local num_4 = 3 * num - 4 * arg_2_0 + 1
	local num_5 = 3 * num - 2 * arg_2_0
	local length = Vector3.length(arg_2_3 - arg_2_2)
	local num_6 = Vector3.normalize(arg_2_3 - arg_2_1) * length
	local num_7 = Vector3.normalize(arg_2_4 - arg_2_2) * length

	return arg_2_2 * num_2 + arg_2_3 * num_3 + num_6 * num_4 + num_7 * num_5
end

Hermite.draw = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	arg_3_0 = arg_3_0 or 20

	local num = 1 / arg_3_0
	local num_2 = 0
	local calc_point = Hermite.calc_point(num_2, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

	for i = 0, arg_3_0 do
		local num_3 = num * i
		local calc_point_2 = Hermite.calc_point(num_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

		arg_3_1:line(calc_point, calc_point_2, arg_3_3)

		if not arg_3_2 then
			local calc_tangent = Hermite.calc_tangent(num_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

			arg_3_1:vector(calc_point_2, calc_tangent * arg_3_2, arg_3_3)
		end

		calc_point = calc_point_2
	end
end

Hermite.length = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local num = 0
	local var_4_1 = arg_4_2

	for i = 1, arg_4_0 - 1 do
		local calc_point = Hermite.calc_point(i / arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		num = num + Vector3.length(calc_point - var_4_1)
		var_4_1 = calc_point
	end

	return num + Vector3.length(arg_4_3 - var_4_1)
end

Hermite.next_index = function (self, arg_5_1)
	-- function 5
	local num = arg_5_1 + 1

	return not self[num + 1] and num and nil
end

Hermite.spline_points = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self[arg_6_1]
	local var_6_1 = self[arg_6_1 + 1]
	local var_6_2 = self[arg_6_1 - 1]

	var_6_2 = var_6_2 or 2 * var_6_0 - var_6_1

	local var_6_3 = self[arg_6_1 + 2]

	var_6_3 = var_6_3 or 2 * var_6_1 - var_6_0

	return var_6_2, var_6_0, var_6_1, var_6_3
end
