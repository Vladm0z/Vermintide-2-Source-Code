-- chunkname: @foundation/scripts/util/bezier.lua

local Bezier = Bezier

Bezier = Bezier or {}
Bezier = Bezier

Bezier.calc_point = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local num = 1 - arg_1_0

	return num^3 * arg_1_1 + 3 * num^2 * arg_1_0 * arg_1_2 + 3 * num * arg_1_0^2 * arg_1_3 + arg_1_0^3 * arg_1_4
end

Bezier.calc_tangent = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	return (Vector3.normalize(-3 * (arg_2_1 * (arg_2_0 - 1)^2 + arg_2_2 * (-3 * arg_2_0^2 + 4 * arg_2_0 - 1) + arg_2_0 * (3 * arg_2_3 * arg_2_0 - 2 * arg_2_3 - arg_2_4 * arg_2_0))))
end

Bezier.draw = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	arg_3_0 = arg_3_0 or 20

	local num = 1 / arg_3_0
	local num_2 = 0
	local calc_point = Bezier.calc_point(num_2, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

	for i = 0, arg_3_0 do
		local num_3 = num * i
		local calc_point_2 = Bezier.calc_point(num_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

		arg_3_1:line(calc_point, calc_point_2, arg_3_3)

		if not arg_3_2 then
			local calc_tangent = Bezier.calc_tangent(num_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)

			arg_3_1:vector(calc_point_2, calc_tangent * arg_3_2, arg_3_3)
		end

		calc_point = calc_point_2
	end
end

Bezier.length = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local num = 0
	local var_4_1 = arg_4_1

	for i = 1, arg_4_0 - 1 do
		local calc_point = Bezier.calc_point(i / arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		num = num + Vector3.length(calc_point - var_4_1)
		var_4_1 = calc_point
	end

	return num + Vector3.length(arg_4_4 - var_4_1)
end

Bezier.next_index = function (self, arg_5_1)
	-- function 5
	local num = arg_5_1 + 3

	return not self[num + 3] and num and nil
end

Bezier.spline_points = function (self, arg_6_1)
	-- function 6
	return self[arg_6_1], self[arg_6_1 + 1], self[arg_6_1 + 2], self[arg_6_1 + 3]
end
