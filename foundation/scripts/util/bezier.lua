-- chunkname: @foundation/scripts/util/bezier.lua

Bezier = Bezier or {}

function Bezier.calc_point(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = 1 - arg_1_0

	return var_1_0^3 * arg_1_1 + 3 * var_1_0^2 * arg_1_0 * arg_1_2 + 3 * var_1_0 * arg_1_0^2 * arg_1_3 + arg_1_0^3 * arg_1_4
end

function Bezier.calc_tangent(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	return (Vector3.normalize(-3 * (arg_2_1 * (arg_2_0 - 1)^2 + arg_2_2 * (-3 * arg_2_0^2 + 4 * arg_2_0 - 1) + arg_2_0 * (3 * arg_2_3 * arg_2_0 - 2 * arg_2_3 - arg_2_4 * arg_2_0))))
end

function Bezier.draw(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	arg_3_0 = arg_3_0 or 20

	local var_3_0 = 1 / arg_3_0
	local var_3_1 = 0
	local var_3_2 = Bezier.calc_point(var_3_1, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

	for iter_3_0 = 0, arg_3_0 do
		local var_3_3 = var_3_0 * iter_3_0
		local var_3_4 = Bezier.calc_point(var_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

		arg_3_1:line(var_3_2, var_3_4, arg_3_3)

		if arg_3_2 then
			local var_3_5 = Bezier.calc_tangent(var_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

			arg_3_1:vector(var_3_4, var_3_5 * arg_3_2, arg_3_3)
		end

		var_3_2 = var_3_4
	end
end

function Bezier.length(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = 0
	local var_4_1 = arg_4_1

	for iter_4_0 = 1, arg_4_0 - 1 do
		local var_4_2 = Bezier.calc_point(iter_4_0 / arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		var_4_0 = var_4_0 + Vector3.length(var_4_2 - var_4_1)
		var_4_1 = var_4_2
	end

	return var_4_0 + Vector3.length(arg_4_4 - var_4_1)
end

function Bezier.next_index(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 + 3

	return arg_5_0[var_5_0 + 3] and var_5_0 or nil
end

function Bezier.spline_points(arg_6_0, arg_6_1)
	return arg_6_0[arg_6_1], arg_6_0[arg_6_1 + 1], arg_6_0[arg_6_1 + 2], arg_6_0[arg_6_1 + 3]
end
