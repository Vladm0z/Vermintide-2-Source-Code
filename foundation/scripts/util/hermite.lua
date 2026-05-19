-- chunkname: @foundation/scripts/util/hermite.lua

Hermite = Hermite or {}

function Hermite.calc_point(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_0 * arg_1_0
	local var_1_1 = var_1_0 * arg_1_0
	local var_1_2 = var_1_1 + var_1_1
	local var_1_3 = var_1_0 + var_1_0
	local var_1_4 = var_1_3 + var_1_0
	local var_1_5 = var_1_2 - var_1_4 + 1
	local var_1_6 = var_1_4 - var_1_2
	local var_1_7 = var_1_1 - var_1_3 + arg_1_0
	local var_1_8 = var_1_1 - var_1_0
	local var_1_9 = Vector3.length(arg_1_3 - arg_1_2)
	local var_1_10 = Vector3.normalize(arg_1_3 - arg_1_1) * var_1_9
	local var_1_11 = Vector3.normalize(arg_1_4 - arg_1_2) * var_1_9

	return arg_1_2 * var_1_5 + arg_1_3 * var_1_6 + var_1_10 * var_1_7 + var_1_11 * var_1_8
end

function Hermite.calc_tangent(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_0 * arg_2_0
	local var_2_1 = 6 * var_2_0 - 6 * arg_2_0
	local var_2_2 = 6 * arg_2_0 - 6 * var_2_0
	local var_2_3 = 3 * var_2_0 - 4 * arg_2_0 + 1
	local var_2_4 = 3 * var_2_0 - 2 * arg_2_0
	local var_2_5 = Vector3.length(arg_2_3 - arg_2_2)
	local var_2_6 = Vector3.normalize(arg_2_3 - arg_2_1) * var_2_5
	local var_2_7 = Vector3.normalize(arg_2_4 - arg_2_2) * var_2_5

	return arg_2_2 * var_2_1 + arg_2_3 * var_2_2 + var_2_6 * var_2_3 + var_2_7 * var_2_4
end

function Hermite.draw(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	arg_3_0 = arg_3_0 or 20

	local var_3_0 = 1 / arg_3_0
	local var_3_1 = 0
	local var_3_2 = Hermite.calc_point(var_3_1, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

	for iter_3_0 = 0, arg_3_0 do
		local var_3_3 = var_3_0 * iter_3_0
		local var_3_4 = Hermite.calc_point(var_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

		arg_3_1:line(var_3_2, var_3_4, arg_3_3)

		if arg_3_2 then
			local var_3_5 = Hermite.calc_tangent(var_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

			arg_3_1:vector(var_3_4, var_3_5 * arg_3_2, arg_3_3)
		end

		var_3_2 = var_3_4
	end
end

function Hermite.length(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = 0
	local var_4_1 = arg_4_2

	for iter_4_0 = 1, arg_4_0 - 1 do
		local var_4_2 = Hermite.calc_point(iter_4_0 / arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		var_4_0 = var_4_0 + Vector3.length(var_4_2 - var_4_1)
		var_4_1 = var_4_2
	end

	return var_4_0 + Vector3.length(arg_4_3 - var_4_1)
end

function Hermite.next_index(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 + 1

	return arg_5_0[var_5_0 + 1] and var_5_0 or nil
end

function Hermite.spline_points(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0[arg_6_1]
	local var_6_1 = arg_6_0[arg_6_1 + 1]
	local var_6_2 = arg_6_0[arg_6_1 - 1] or 2 * var_6_0 - var_6_1
	local var_6_3 = arg_6_0[arg_6_1 + 2] or 2 * var_6_1 - var_6_0

	return var_6_2, var_6_0, var_6_1, var_6_3
end
