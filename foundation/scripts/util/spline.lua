-- chunkname: @foundation/scripts/util/spline.lua

Spline = class(Spline)

function Spline.calc_point(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1 * arg_1_1
	local var_1_1 = var_1_0 * arg_1_1
	local var_1_2 = var_1_1 + var_1_1
	local var_1_3 = var_1_0 + var_1_0
	local var_1_4 = var_1_3 + var_1_0
	local var_1_5 = var_1_2 - var_1_4 + 1
	local var_1_6 = var_1_4 - var_1_2
	local var_1_7 = var_1_1 - var_1_3 + arg_1_1
	local var_1_8 = var_1_1 - var_1_0

	return Vector3.from_table(arg_1_0._P1) * var_1_5 + Vector3.from_table(arg_1_0._P2) * var_1_6 + Vector3.from_table(arg_1_0._T1) * var_1_7 + Vector3.from_table(arg_1_0._T2) * var_1_8
end

function Spline.calc_tangent(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1 * arg_2_1
	local var_2_1 = 6 * var_2_0 - 6 * arg_2_1
	local var_2_2 = 6 * arg_2_1 - 6 * var_2_0
	local var_2_3 = 3 * var_2_0 - 4 * arg_2_1 + 1
	local var_2_4 = 3 * var_2_0 - 2 * arg_2_1

	return Vector3.from_table(arg_2_0._P1) * var_2_1 + Vector3.from_table(arg_2_0._P2) * var_2_2 + Vector3.from_table(arg_2_0._T1) * var_2_3 + Vector3.from_table(arg_2_0._T2) * var_2_4
end

function Spline.set_points(arg_3_0, arg_3_1)
	local var_3_0 = Vector3.from_table(arg_3_1[1])
	local var_3_1 = Vector3.from_table(arg_3_1[2])
	local var_3_2 = Vector3.from_table(arg_3_1[3])
	local var_3_3 = Vector3.from_table(arg_3_1[4])
	local var_3_4 = Vector3.length(var_3_1 - var_3_2)
	local var_3_5 = Vector3.normalize(var_3_2 - var_3_0) * var_3_4

	arg_3_0._T1 = Vector3.as_table(var_3_5)

	local var_3_6 = Vector3.normalize(var_3_3 - var_3_1) * var_3_4

	arg_3_0._T2 = Vector3.as_table(var_3_6)
	arg_3_0._P1 = table.clone(Vector3.as_table(arg_3_1[2]))
	arg_3_0._P2 = table.clone(Vector3.as_table(arg_3_1[3]))
end

function Spline.draw(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2 = arg_4_2 or 20

	local var_4_0 = 1 / arg_4_2
	local var_4_1 = 0
	local var_4_2 = arg_4_0:calc_point(var_4_1)

	while var_4_1 < 1 do
		var_4_1 = var_4_1 + var_4_0

		local var_4_3 = arg_4_0:calc_point(var_4_1)

		arg_4_1:line(var_4_2, var_4_3)

		var_4_2 = var_4_3
	end
end

function Spline.length(arg_5_0, arg_5_1)
	local var_5_0 = 0
	local var_5_1 = Vector3.from_table(arg_5_0._P1)

	for iter_5_0 = 1, arg_5_1 do
		local var_5_2 = arg_5_0:calc_point(iter_5_0 / arg_5_1)

		var_5_0 = var_5_0 + Vector3.length(var_5_2 - var_5_1)
		var_5_1 = var_5_2
	end

	return var_5_0
end

function Spline.tangent(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or 0.01

	local var_6_0 = math.max(arg_6_1 - arg_6_2, 0)
	local var_6_1 = math.min(arg_6_1 + arg_6_2, 1)
	local var_6_2 = arg_6_0:calc_point(var_6_0)
	local var_6_3 = arg_6_0:calc_point(var_6_1)

	return Vector3.normalize(var_6_3 - var_6_2)
end

function Spline.set_points_manual_tangents(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_0._T1 = arg_7_1 and Vector3.as_table(arg_7_1) or arg_7_0._T1
	arg_7_0._T2 = arg_7_2 and Vector3.as_table(arg_7_2) or arg_7_0._T2
	arg_7_0._P1 = arg_7_3 and Vector3.as_table(arg_7_3) or arg_7_0._P1
	arg_7_0._P2 = arg_7_4 and Vector3.as_table(arg_7_4) or arg_7_0._P2
end

function Spline.set_points_with_rotation_tangents(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0._P1 = table.clone(Vector3.as_table(arg_8_1[1]))
	arg_8_0._P2 = table.clone(Vector3.as_table(arg_8_1[2]))

	local var_8_0 = Vector3.length(Vector3.from_table(arg_8_1[1]) - Vector3.from_table(arg_8_1[2]))

	arg_8_0._T1 = Vector3.as_table(Vector3.from_table(arg_8_2) * var_8_0)
	arg_8_0._T2 = Vector3.as_table(Vector3.from_table(arg_8_3) * var_8_0)
end

function Spline.set_points_manual_start_tangent(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = Vector3.length(arg_9_2 - arg_9_3)

	arg_9_0._T1 = Vector3.as_table(arg_9_1 * var_9_0)
	arg_9_0._T2 = Vector3.as_table(Vector3.normalize(arg_9_4 - arg_9_2) * var_9_0)
	arg_9_0._P1 = Vector3.as_table(arg_9_2)
	arg_9_0._P2 = Vector3.as_table(arg_9_3)
end

function Spline.set_points_manual_end_tangent(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = Vector3.length(arg_10_2 - arg_10_3)

	arg_10_0._T1 = Vector3.as_table(Vector3.normalize(arg_10_3 - arg_10_1) * var_10_0)
	arg_10_0._T2 = Vector3.as_table(arg_10_4 * var_10_0)
	arg_10_0._P1 = Vector3.as_table(arg_10_2)
	arg_10_0._P2 = Vector3.as_table(arg_10_3)
end

function Spline.debug_print(arg_11_0)
	return
end

function Spline.p1(arg_12_0)
	return arg_12_0._P1
end

function Spline.p2(arg_13_0)
	return arg_13_0._P2
end

function Spline.t1(arg_14_0)
	return arg_14_0._T1
end

function Spline.t2(arg_15_0)
	return arg_15_0._T2
end
