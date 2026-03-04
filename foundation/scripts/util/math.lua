-- chunkname: @foundation/scripts/util/math.lua

local var_0_0 = math
local var_0_1 = var_0_0.sqrt
local var_0_2 = var_0_0.cos
local var_0_3 = var_0_0.sin
local var_0_4 = var_0_0.random
local var_0_5 = var_0_0.max
local var_0_6 = var_0_0.abs
local var_0_7 = var_0_0.acos
local var_0_8 = var_0_0.pi

var_0_0.epsilon = 0.001
var_0_0.tau = 2 * var_0_8
var_0_0.half_pi = 0.5 * var_0_8
var_0_0.inverse_sqrt_2 = 1 / var_0_1(2)
var_0_0.degrees_to_radians = var_0_0.rad
var_0_0.radians_to_degrees = var_0_0.deg

var_0_0.sign = function (arg_1_0)
	if arg_1_0 > 0 then
		return 1
	elseif arg_1_0 < 0 then
		return -1
	else
		return 0
	end
end

var_0_0.clamp = function (arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 < arg_2_0 then
		return arg_2_2
	elseif arg_2_0 < arg_2_1 then
		return arg_2_1
	else
		return arg_2_0
	end
end

var_0_0.clamp01 = function (arg_3_0)
	if arg_3_0 > 1 then
		return 1
	elseif arg_3_0 < 0 then
		return 0
	else
		return arg_3_0
	end
end

local var_0_9 = var_0_0.clamp

var_0_0.normalize = function (arg_4_0, arg_4_1, arg_4_2)
	return (arg_4_0 - arg_4_1) / (arg_4_2 - arg_4_1)
end

var_0_0.lerp = function (arg_5_0, arg_5_1, arg_5_2)
	return arg_5_0 * (1 - arg_5_2) + arg_5_1 * arg_5_2
end

local var_0_10 = var_0_0.lerp

var_0_0.lerp_clamped = function (arg_6_0, arg_6_1, arg_6_2)
	return var_0_10(arg_6_0, arg_6_1, var_0_0.clamp01(arg_6_2))
end

var_0_0.inv_lerp = function (arg_7_0, arg_7_1, arg_7_2)
	return (arg_7_2 - arg_7_0) / (arg_7_1 - arg_7_0)
end

var_0_0.inv_lerp_clamped = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_0 < arg_8_1 and var_0_0.clamp(arg_8_2, arg_8_0, arg_8_1) or var_0_0.clamp(arg_8_2, arg_8_1, arg_8_0)

	return var_0_0.inv_lerp(arg_8_0, arg_8_1, arg_8_2)
end

var_0_0.remap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	return (arg_9_4 - arg_9_0) / (arg_9_1 - arg_9_0) * (arg_9_3 - arg_9_2) + arg_9_2
end

var_0_0.remap_clamped = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	return var_0_0.clamp01((arg_10_4 - arg_10_0) / (arg_10_1 - arg_10_0)) * (arg_10_3 - arg_10_2) + arg_10_2
end

var_0_0.radian_lerp = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = var_0_8 * 2

	return arg_11_0 + arg_11_2 * (((arg_11_1 - arg_11_0) % var_11_0 + var_0_8) % var_11_0 - var_0_8)
end

var_0_0.angle_lerp = function (arg_12_0, arg_12_1, arg_12_2)
	return arg_12_0 + (((arg_12_1 - arg_12_0) % 360 + 540) % 360 - 180) * arg_12_2
end

var_0_0.sirp = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = 0.5 + 0.5 * var_0_2((1 + arg_13_2) * var_0_8)

	return var_0_10(arg_13_0, arg_13_1, var_13_0)
end

var_0_0.auto_lerp = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = (arg_14_4 - arg_14_0) / (arg_14_1 - arg_14_0)

	return var_0_0.clamp(var_0_10(arg_14_2, arg_14_3, var_14_0), arg_14_2, arg_14_3)
end

var_0_0.round_with_precision = function (arg_15_0, arg_15_1)
	local var_15_0 = 10^(arg_15_1 or 0)

	return var_0_0.floor(arg_15_0 * var_15_0 + 0.5) / var_15_0
end

var_0_0.round = function (arg_16_0)
	return var_0_0.floor(arg_16_0 + 0.5)
end

var_0_0.round_to_closest_multiple = function (arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or 1

	local var_17_0 = arg_17_0 % arg_17_1

	if var_17_0 <= arg_17_1 / 2 then
		return arg_17_0 - var_17_0
	end

	return arg_17_0 + arg_17_1 - var_17_0
end

var_0_0.smoothstep = function (arg_18_0, arg_18_1, arg_18_2)
	fassert(arg_18_1 ~= arg_18_2, "Division by zero.")

	local var_18_0 = var_0_9((arg_18_0 - arg_18_1) / (arg_18_2 - arg_18_1), 0, 1)

	return var_18_0 * var_18_0 * var_18_0 * (var_18_0 * (var_18_0 * 6 - 15) + 10)
end

Math.random_range = function (arg_19_0, arg_19_1)
	return arg_19_0 + var_0_4() * (arg_19_1 - arg_19_0)
end

var_0_0.next_random_range = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0, var_20_1 = Math.next_random(arg_20_0)

	return var_20_0, arg_20_1 + var_20_1 * (arg_20_2 - arg_20_1)
end

var_0_0.point_is_inside_2d_box = function (arg_21_0, arg_21_1, arg_21_2)
	return arg_21_0[1] > arg_21_1[1] and arg_21_0[1] < arg_21_1[1] + arg_21_2[1] and arg_21_0[2] > arg_21_1[2] and arg_21_0[2] < arg_21_1[2] + arg_21_2[2]
end

var_0_0.box_overlap_box = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	return arg_22_0[1] + arg_22_1[1] >= arg_22_2[1] and arg_22_2[1] + arg_22_3[1] >= arg_22_0[1] and arg_22_0[2] + arg_22_1[2] >= arg_22_2[2] and arg_22_2[2] + arg_22_3[2] >= arg_22_0[2]
end

var_0_0.point_is_inside_aabb = function (arg_23_0, arg_23_1, arg_23_2)
	return not (arg_23_0[1] < arg_23_1[1] - arg_23_2[1]) and not (arg_23_0[1] > arg_23_1[1] + arg_23_2[1]) and not (arg_23_0[2] < arg_23_1[2] - arg_23_2[2]) and not (arg_23_0[2] > arg_23_1[2] + arg_23_2[2]) and not (arg_23_0[3] < arg_23_1[3] - arg_23_2[3]) and not (arg_23_0[3] > arg_23_1[3] + arg_23_2[3])
end

var_0_0.point_is_inside_box = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = Matrix4x4.inverse(arg_24_1)
	local var_24_1 = Matrix4x4.transform(var_24_0, arg_24_0)

	return var_0_0.point_is_inside_aabb(var_24_1, Vector3.zero(), arg_24_2)
end

var_0_0.point_is_inside_oobb = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = Matrix4x4.inverse(arg_25_1)
	local var_25_1 = Matrix4x4.transform(var_25_0, arg_25_0)

	if var_25_1.x > -arg_25_2[1] and var_25_1.x < arg_25_2[1] and var_25_1.y > -arg_25_2[2] and var_25_1.y < arg_25_2[2] and var_25_1.z > -arg_25_2[3] and var_25_1.z < arg_25_2[3] then
		return true
	else
		return false
	end
end

var_0_0.point_is_inside_2d_triangle = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_1 - arg_26_0
	local var_26_1 = arg_26_2 - arg_26_0
	local var_26_2 = arg_26_3 - arg_26_0
	local var_26_3 = Vector3.cross(var_26_0, var_26_1)
	local var_26_4 = Vector3.cross(var_26_1, var_26_2)

	if Vector3.dot(var_26_3, var_26_4) < 0 then
		return false
	end

	local var_26_5 = Vector3.cross(var_26_2, var_26_0)
	local var_26_6 = Vector3.dot(var_26_3, var_26_3) > Vector3.dot(var_26_4, var_26_4) and var_26_3 or var_26_4
	local var_26_7 = Vector3.dot(var_26_6, var_26_5)

	if var_26_7 < 0 then
		return false
	elseif var_26_7 > 0 then
		return true
	else
		local var_26_8 = Vector3.min(var_26_0, Vector3.min(var_26_1, var_26_2))
		local var_26_9 = Vector3.max(var_26_0, Vector3.max(var_26_1, var_26_2))

		return var_26_8.x <= 0 and var_26_8.y <= 0 and var_26_9.x >= 0 and var_26_9.y >= 0
	end
end

var_0_0.point_is_inside_view = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = Quaternion.forward(arg_27_2)
	local var_27_1 = Vector3.normalize(arg_27_0 - arg_27_1)
	local var_27_2 = Vector3.dot(var_27_1, var_27_0)

	if var_27_2 > 0 then
		local var_27_3 = Quaternion.right(arg_27_2)
		local var_27_4 = Quaternion.up(arg_27_2)
		local var_27_5 = Vector3.dot(var_27_1, var_27_3)
		local var_27_6 = var_27_2
		local var_27_7 = Vector3.dot(var_27_1, var_27_4)
		local var_27_8 = var_27_6
		local var_27_9 = var_0_1(var_27_5 * var_27_5 + var_27_6 * var_27_6)

		if var_27_9 == 0 then
			return false
		end

		local var_27_10 = var_27_8 / var_27_9

		if var_0_0.acos(var_27_10) <= arg_27_4 / 2 then
			local var_27_11 = var_27_9 / var_0_1(var_27_9 * var_27_9 + var_27_7 * var_27_7)

			if var_0_0.acos(var_27_11) <= arg_27_3 / 2 then
				return true
			end

			return false
		end
	end

	return false
end

var_0_0.point_is_inside_cylinder = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_0[3]
	local var_28_1 = arg_28_1[3]

	if var_28_0 > var_28_1 + arg_28_4 or var_28_0 < var_28_1 - arg_28_4 then
		return false
	end

	local var_28_2 = arg_28_0[1]
	local var_28_3 = arg_28_0[2]
	local var_28_4 = arg_28_1[1]
	local var_28_5 = arg_28_1[2]
	local var_28_6 = (var_28_2 - var_28_4)^2 + (var_28_3 - var_28_5)^2

	return arg_28_2 < var_28_6 and var_28_6 < arg_28_3^2
end

var_0_0.cartesian_to_polar = function (arg_29_0, arg_29_1)
	fassert(arg_29_0 ~= 0 and arg_29_1 ~= 0, "Can't convert a zero vector to polar coordinates")

	local var_29_0 = var_0_1(arg_29_0 * arg_29_0 + arg_29_1 * arg_29_1)
	local var_29_1 = var_0_0.atan(arg_29_1 / arg_29_0) * (180 / var_0_0.pi)

	if arg_29_0 < 0 then
		var_29_1 = var_29_1 + 180
	elseif arg_29_1 < 0 then
		var_29_1 = var_29_1 + 360
	end

	return var_29_0, var_29_1
end

var_0_0.circular_to_square_coordinates = function (arg_30_0)
	local var_30_0 = arg_30_0.x
	local var_30_1 = arg_30_0.y
	local var_30_2 = var_30_0 * var_30_0 - var_30_1 * var_30_1
	local var_30_3 = 4 * var_0_0.inverse_sqrt_2
	local var_30_4 = var_30_0 * var_30_3
	local var_30_5 = var_30_1 * var_30_3

	return Vector2(0.5 * (var_0_1(var_0_5(2 + var_30_4 + var_30_2, 0)) - var_0_1(var_0_5(2 - var_30_4 + var_30_2, 0))), 0.5 * (var_0_1(var_0_5(2 + var_30_5 - var_30_2, 0)) - var_0_1(var_0_5(2 - var_30_5 - var_30_2, 0))))
end

var_0_0.polar_to_cartesian = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1 * (var_0_8 / 180)

	return arg_31_0 * var_0_2(var_31_0), arg_31_0 * var_0_3(var_31_0)
end

var_0_0.catmullrom = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	return 0.5 * (2 * arg_32_2 + (-arg_32_1 + arg_32_3) * arg_32_0 + (2 * arg_32_1 - 5 * arg_32_2 + 4 * arg_32_3 - arg_32_4) * arg_32_0 * arg_32_0 + (-arg_32_1 + 3 * arg_32_2 - 3 * arg_32_3 + arg_32_4) * arg_32_0 * arg_32_0 * arg_32_0)
end

var_0_0.closest_position = function (arg_33_0, arg_33_1, arg_33_2)
	if Vector3.distance_squared(arg_33_0, arg_33_1) <= Vector3.distance_squared(arg_33_0, arg_33_2) then
		return arg_33_1
	else
		return arg_33_2
	end
end

var_0_0.dot2D = function (arg_34_0, arg_34_1)
	return arg_34_0.x * arg_34_1.x + arg_34_0.y * arg_34_1.y
end

Geometry = Geometry or {}

Geometry.ccw = function (arg_35_0, arg_35_1, arg_35_2)
	return (arg_35_1.x - arg_35_0.x) * (arg_35_2.y - arg_35_0.y) > (arg_35_1.y - arg_35_0.y) * (arg_35_2.x - arg_35_0.x)
end

local function var_0_11(arg_36_0, arg_36_1)
	return arg_36_0.x < arg_36_1.x
end

local var_0_12 = Geometry.ccw
local var_0_13 = var_0_0.dot2D

Geometry.convex_hull = function (arg_37_0, arg_37_1)
	local var_37_0 = #arg_37_0

	if var_37_0 == 0 then
		return arg_37_1, 0
	end

	table.sort(arg_37_0, var_0_11)

	local var_37_1 = 0

	for iter_37_0 = 1, var_37_0 do
		local var_37_2 = arg_37_0[iter_37_0]

		while var_37_1 >= 2 and not var_0_12(arg_37_1[var_37_1 - 1], arg_37_1[var_37_1], var_37_2) do
			var_37_1 = var_37_1 - 1
		end

		var_37_1 = var_37_1 + 1
		arg_37_1[var_37_1] = var_37_2
	end

	local var_37_3 = var_37_1 + 1

	for iter_37_1 = var_37_0, 1, -1 do
		local var_37_4 = arg_37_0[iter_37_1]

		while var_37_3 <= var_37_1 and not var_0_12(arg_37_1[var_37_1 - 1], arg_37_1[var_37_1], var_37_4) do
			var_37_1 = var_37_1 - 1
		end

		var_37_1 = var_37_1 + 1
		arg_37_1[var_37_1] = var_37_4
	end

	local var_37_5 = var_37_1 - 1

	return arg_37_1, var_37_5
end

Geometry.convex_hull_tracking = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = #arg_38_0

	if var_38_0 == 0 then
		return arg_38_1, 0
	end

	table.sort(arg_38_0, var_0_11)

	local var_38_1 = 0

	for iter_38_0 = 1, var_38_0 do
		local var_38_2 = arg_38_0[iter_38_0]

		while var_38_1 >= 2 and not var_0_12(arg_38_1[var_38_1 - 1], arg_38_1[var_38_1], var_38_2) do
			var_38_1 = var_38_1 - 1
		end

		var_38_1 = var_38_1 + 1
		arg_38_1[var_38_1] = var_38_2
		arg_38_2[var_38_1] = iter_38_0
	end

	local var_38_3 = var_38_1 + 1

	for iter_38_1 = var_38_0, 1, -1 do
		local var_38_4 = arg_38_0[iter_38_1]

		while var_38_3 <= var_38_1 and not var_0_12(arg_38_1[var_38_1 - 1], arg_38_1[var_38_1], var_38_4) do
			var_38_1 = var_38_1 - 1
		end

		var_38_1 = var_38_1 + 1
		arg_38_1[var_38_1] = var_38_4
		arg_38_2[var_38_1] = iter_38_1
	end

	local var_38_5 = var_38_1 - 1

	return arg_38_1, var_38_5, arg_38_2
end

Geometry.concave_hull = function (arg_39_0, arg_39_1)
	local var_39_0 = #arg_39_0

	if var_39_0 == 0 then
		return arg_39_1, 0
	end

	table.sort(arg_39_0, var_0_11)

	local var_39_1 = 0

	for iter_39_0 = 1, var_39_0 do
		local var_39_2 = arg_39_0[iter_39_0]

		while var_39_1 >= 2 and not var_0_12(arg_39_1[var_39_1 - 1], arg_39_1[var_39_1], var_39_2) and not (var_0_13(arg_39_1[var_39_1] - arg_39_1[var_39_1 - 1], var_39_2 - arg_39_1[var_39_1]) > 0.1) do
			var_39_1 = var_39_1 - 1
		end

		var_39_1 = var_39_1 + 1
		arg_39_1[var_39_1] = var_39_2
	end

	local var_39_3 = var_39_1
	local var_39_4 = var_39_1 + 1

	for iter_39_1 = var_39_0, 1, -1 do
		local var_39_5 = arg_39_0[iter_39_1]

		while var_39_4 <= var_39_1 and not var_0_12(arg_39_1[var_39_1 - 1], arg_39_1[var_39_1], var_39_5) and not (var_0_13(arg_39_1[var_39_1] - arg_39_1[var_39_1 - 1], var_39_5 - arg_39_1[var_39_1]) > 0.1) do
			var_39_1 = var_39_1 - 1
		end

		var_39_1 = var_39_1 + 1
		arg_39_1[var_39_1] = var_39_5
	end

	local var_39_6 = var_39_1 - 1

	return arg_39_1, var_39_6, var_39_3
end

Geometry.is_point_inside_triangle = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_1 - arg_40_0
	local var_40_1 = arg_40_2 - arg_40_0
	local var_40_2 = arg_40_3 - arg_40_0
	local var_40_3 = Vector3.cross(var_40_0, var_40_1)
	local var_40_4 = Vector3.cross(var_40_1, var_40_2)

	if Vector3.dot(var_40_3, var_40_4) < 0 then
		return false
	end

	local var_40_5 = Vector3.cross(var_40_2, var_40_0)
	local var_40_6 = Vector3.dot(var_40_3, var_40_3) > Vector3.dot(var_40_4, var_40_4) and var_40_3 or var_40_4
	local var_40_7 = Vector3.dot(var_40_6, var_40_5)

	if var_40_7 < 0 then
		return false
	elseif var_40_7 > 0 then
		return true
	else
		local var_40_8 = Vector3.min(var_40_0, Vector3.min(var_40_1, var_40_2))
		local var_40_9 = Vector3.max(var_40_0, Vector3.max(var_40_1, var_40_2))

		return var_40_8.x <= 0 and var_40_8.y <= 0 and var_40_8.z <= 0 and var_40_9.x >= 0 and var_40_9.y >= 0 and var_40_9.z >= 0
	end
end

local var_0_14 = Vector3 and Vector3.dot

Geometry.closest_point_on_line = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0 - arg_41_1
	local var_41_1 = arg_41_2 - arg_41_1
	local var_41_2 = var_0_14(var_41_0, var_41_1)

	if var_41_2 <= 0 then
		return arg_41_1
	end

	local var_41_3 = var_0_14(var_41_1, var_41_1)

	if var_41_3 <= var_41_2 then
		return arg_41_2
	end

	return arg_41_1 + var_41_2 / var_41_3 * var_41_1
end

Geometry.closest_point_on_line = EngineOptimized.closest_point_on_line

Geometry.closest_point_on_polyline = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = Vector3.distance_squared
	local var_42_1 = Geometry.closest_point_on_line

	arg_42_2 = arg_42_2 or 1
	arg_42_3 = arg_42_3 or #arg_42_1

	local var_42_2 = var_0_0.huge
	local var_42_3
	local var_42_4

	for iter_42_0 = arg_42_2, arg_42_3 - 1 do
		local var_42_5 = arg_42_1[iter_42_0]
		local var_42_6 = arg_42_1[iter_42_0 + 1]
		local var_42_7 = var_42_1(arg_42_0, var_42_5, var_42_6)
		local var_42_8 = var_42_0(var_42_7, arg_42_0)

		if var_42_8 < var_42_2 then
			var_42_2 = var_42_8
			var_42_3 = var_42_7
			var_42_4 = iter_42_0
		end
	end

	return var_42_3, var_42_4
end

Intersect = Intersect or {}

Intersect.ray_line = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0, var_43_1 = Intersect.line_line(arg_43_0, arg_43_0 + arg_43_1, arg_43_2, arg_43_3)

	if var_43_0 == nil then
		return nil, nil
	elseif var_43_0 < 0 then
		return nil, nil
	else
		return var_43_0, var_43_1
	end
end

Intersect.ray_box = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if Math.point_in_box(arg_44_0, arg_44_2, arg_44_3) then
		return 0
	end

	local var_44_0 = Math.ray_box_intersection(arg_44_0, arg_44_1, arg_44_2, arg_44_3)

	if var_44_0 < 0 then
		return nil
	end

	return var_44_0
end

Intersect.line_line = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = arg_45_1 - arg_45_0
	local var_45_1 = arg_45_3 - arg_45_2
	local var_45_2 = Vector3.dot(var_45_0, var_45_0)
	local var_45_3 = Vector3.dot(var_45_1, var_45_1)
	local var_45_4 = Vector3.dot(var_45_0, var_45_1)
	local var_45_5 = var_45_2 * var_45_3 - var_45_4 * var_45_4

	if var_45_5 < 0.001 then
		return nil, nil
	end

	local var_45_6 = arg_45_0 - arg_45_2
	local var_45_7 = Vector3.dot(var_45_0, var_45_6)
	local var_45_8 = Vector3.dot(var_45_1, var_45_6)
	local var_45_9 = (var_45_4 * var_45_8 - var_45_7 * var_45_3) / var_45_5
	local var_45_10 = (var_45_2 * var_45_8 - var_45_4 * var_45_7) / var_45_5

	return var_45_9, var_45_10
end

Intersect.ray_segment = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0, var_46_1 = Intersect.ray_line(arg_46_0, arg_46_1, arg_46_2, arg_46_3)

	if var_46_0 == nil then
		return nil
	end

	if var_46_1 >= 0 and var_46_1 <= 1 then
		return var_46_0, var_46_1
	else
		return nil, nil
	end
end

Intersect.ray_circle = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_0 - arg_47_2
	local var_47_1, var_47_2 = Vector3.to_elements(var_47_0)
	local var_47_3, var_47_4 = Vector3.to_elements(arg_47_1)
	local var_47_5 = (var_47_3 * var_47_3 + var_47_4 * var_47_4) * 2
	local var_47_6 = 2 * (var_47_3 * var_47_1 + var_47_4 * var_47_2)
	local var_47_7 = var_47_1 * var_47_1 + var_47_2 * var_47_2 - arg_47_3 * arg_47_3
	local var_47_8 = var_47_6 * var_47_6 - 2 * var_47_5 * var_47_7

	if var_47_8 < 0 then
		return nil
	end

	local var_47_9 = var_0_0.sqrt(var_47_8)
	local var_47_10 = (-var_47_6 + var_47_9) / var_47_5
	local var_47_11 = Vector3(var_47_3 * var_47_10, var_47_4 * var_47_10, 0)
	local var_47_12 = arg_47_0 + var_47_11

	if var_47_9 < var_0_0.epsilon then
		return var_47_12, var_47_12, var_47_11, var_47_11
	end

	local var_47_13 = (-var_47_6 - var_47_9) / var_47_5
	local var_47_14 = Vector3(var_47_3 * var_47_13, var_47_4 * var_47_13, 0)
	local var_47_15 = arg_47_0 + var_47_14

	return var_47_12, var_47_15, var_47_11, var_47_14
end

var_0_0.ease_exp = function (arg_48_0)
	if arg_48_0 < 0.5 then
		return 0.5 * 2^(20 * (arg_48_0 - 0.5))
	end

	return 1 - 0.5 * 2^(20 * (0.5 - arg_48_0))
end

var_0_0.ease_in_exp = function (arg_49_0)
	return 2^(10 * (arg_49_0 - 1))
end

var_0_0.ease_out_exp = function (arg_50_0)
	return 1 - 2^(-10 * arg_50_0)
end

var_0_0.ease_out_sine = function (arg_51_0)
	return var_0_0.sin(arg_51_0 * var_0_0.half_pi)
end

var_0_0.easeCubic = function (arg_52_0)
	arg_52_0 = arg_52_0 * 2

	if arg_52_0 < 1 then
		return 0.5 * arg_52_0 * arg_52_0 * arg_52_0
	end

	arg_52_0 = arg_52_0 - 2

	return 0.5 * arg_52_0 * arg_52_0 * arg_52_0 + 1
end

var_0_0.linear = function (arg_53_0)
	return arg_53_0
end

var_0_0.linear_inv = function (arg_54_0)
	return arg_54_0
end

var_0_0.easeInCubic = function (arg_55_0)
	return arg_55_0 * arg_55_0 * arg_55_0
end

var_0_0.easeOutCubic = function (arg_56_0)
	arg_56_0 = arg_56_0 - 1

	return arg_56_0 * arg_56_0 * arg_56_0 + 1
end

var_0_0.easeOutCubicInv = function (arg_57_0)
	return 1 - var_0_0.pow(1 - arg_57_0, 0.3333333333333333)
end

var_0_0.ease_out_quad = function (arg_58_0)
	return -1 * arg_58_0 * (arg_58_0 - 2)
end

var_0_0.ease_in_quart = function (arg_59_0)
	return arg_59_0 * arg_59_0 * arg_59_0 * arg_59_0
end

var_0_0.ease_out_quart = function (arg_60_0)
	return 1 - var_0_0.pow(1 - arg_60_0, 4)
end

var_0_0.ease_out_quart_inv = function (arg_61_0)
	return var_0_0.pow(-arg_61_0 + 1, 0.25) + 1
end

var_0_0.ease_in_out_quart = function (arg_62_0)
	return arg_62_0 < 0.5 and 8 * arg_62_0 * arg_62_0 * arg_62_0 * arg_62_0 or 1 - (-2 * arg_62_0 + 2)^4 / 2
end

local var_0_15 = var_0_0.easeCubic

var_0_0.ease_pulse = function (arg_63_0)
	if arg_63_0 < 0.5 then
		return var_0_15(2 * arg_63_0)
	else
		return var_0_15(2 - 2 * arg_63_0)
	end
end

var_0_0.ease_in_circ = function (arg_64_0)
	return 1 - var_0_0.sqrt(1 - arg_64_0^2)
end

var_0_0.ease_out_circ = function (arg_65_0)
	return var_0_0.sqrt(1 - (arg_65_0 - 1)^2)
end

var_0_0.ease_in_back = function (arg_66_0)
	local var_66_0 = 1.70158

	return (var_66_0 + 1) * arg_66_0 * arg_66_0 * arg_66_0 - var_66_0 * arg_66_0 * arg_66_0
end

var_0_0.ease_out_back = function (arg_67_0)
	c1 = 1.70158
	c3 = c1 + 1

	return 1 + c3 * (arg_67_0 - 1)^3 + c1 * (arg_67_0 - 1)^2
end

var_0_0.ease_in_out_back = function (arg_68_0)
	local var_68_0 = 1.70158
	local var_68_1 = var_68_0 * 1.525

	return arg_68_0 < 0.5 and (2 * arg_68_0)^2 * ((var_68_1 + 1) * 2 * arg_68_0 - var_68_1) / 2 or ((2 * arg_68_0 - 2)^2 * ((var_68_1 + 1) * (arg_68_0 * 2 - 2) + var_68_1) + 2) / 2
end

var_0_0.easeOutQuint = function (arg_69_0)
	return 1 - (1 - arg_69_0)^5
end

var_0_0.easeInQuint = function (arg_70_0)
	return arg_70_0 * arg_70_0 * arg_70_0 * arg_70_0 * arg_70_0
end

var_0_0.bounce = function (arg_71_0)
	return var_0_0.abs(var_0_3(var_0_0.tau * (arg_71_0 + 1) * (arg_71_0 + 1)) * (1 - arg_71_0))
end

var_0_0.ease_out_elastic = function (arg_72_0)
	local var_72_0 = 0
	local var_72_1 = 1

	if arg_72_0 == 0 then
		return 0
	end

	if arg_72_0 == 1 then
		return 1
	end

	if var_72_0 == 0 then
		var_72_0 = 0.3
	end

	local var_72_2

	if var_72_1 < 1 then
		var_72_1 = 1
		var_72_2 = var_72_0 / 4
	else
		var_72_2 = var_72_0 / (2 * var_0_0.pi) * var_0_0.asin(1 / var_72_1)
	end

	return var_72_1 * 2^(-10 * arg_72_0) * var_0_3((arg_72_0 * 1 - var_72_2) * (2 * var_0_0.pi) / var_72_0) + 1
end

var_0_0.easeInOutCubic = function (arg_73_0)
	return arg_73_0 < 0.5 and 4 * arg_73_0 * arg_73_0 * arg_73_0 or 1 - var_0_0.pow(-2 * arg_73_0 + 2, 3) / 2
end

var_0_0.rand_utf8_string = function (arg_74_0, arg_74_1)
	fassert(arg_74_0 > 0, "String length passed to math.rand_string has to be greater than 0")

	arg_74_1 = arg_74_1 or {
		"\"",
		"'",
		"\\",
		" "
	}

	local var_74_0 = {}

	for iter_74_0 = 1, arg_74_0 do
		local var_74_1

		while not var_74_1 or table.contains(arg_74_1, var_74_1) do
			var_74_1 = string.char(var_0_4(32, 126))
		end

		var_74_0[iter_74_0] = var_74_1
	end

	return table.concat(var_74_0)
end

var_0_0.uuid = function ()
	local var_75_0 = var_0_4

	return string.format("%08x-%04x-4%03x-%x%03x-%012x", var_75_0(0, 4294967295), var_75_0(0, 65535), var_75_0(0, 4095), var_75_0(0, 11), var_75_0(0, 4095), var_75_0(0, 281474976710655))
end

var_0_0.get_uniformly_random_point_inside_sector = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	local var_76_0 = arg_76_0 * arg_76_0
	local var_76_1 = arg_76_1 * arg_76_1
	local var_76_2 = arg_76_2 + (arg_76_3 - arg_76_2) * var_0_4()
	local var_76_3 = var_0_1(var_76_0 + (var_76_1 - var_76_0) * var_0_4())

	return var_76_3 * var_0_3(var_76_2), var_76_3 * var_0_2(var_76_2)
end

var_0_0.get_uniformly_random_point_inside_sector_seeded = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	local var_77_0 = arg_77_1 * arg_77_1
	local var_77_1 = arg_77_2 * arg_77_2
	local var_77_2
	local var_77_3
	local var_77_4

	arg_77_0, var_77_4 = Math.next_random(arg_77_0)

	local var_77_5

	arg_77_0, var_77_5 = Math.next_random(arg_77_0)

	local var_77_6 = arg_77_3 + (arg_77_4 - arg_77_3) * var_77_4
	local var_77_7 = var_0_0.sqrt(var_77_0 + (var_77_1 - var_77_0) * var_77_5)
	local var_77_8 = var_77_7 * var_0_0.sin(var_77_6)
	local var_77_9 = var_77_7 * var_0_0.cos(var_77_6)

	return arg_77_0, var_77_8, var_77_9
end

var_0_0.get_random_point_inside_box_seeded = function (arg_78_0, arg_78_1, arg_78_2)
	local var_78_0
	local var_78_1
	local var_78_2
	local var_78_3
	local var_78_4
	local var_78_5
	local var_78_6

	arg_78_0, var_78_6 = Math.next_random(arg_78_0)

	local var_78_7

	arg_78_0, var_78_7 = Math.next_random(arg_78_0)

	local var_78_8

	arg_78_0, var_78_8 = Math.next_random(arg_78_0)

	local var_78_9 = var_0_0.lerp(-arg_78_2[1], arg_78_2[1], var_78_6)
	local var_78_10 = var_0_0.lerp(-arg_78_2[2], arg_78_2[2], var_78_7)
	local var_78_11 = var_0_0.lerp(-arg_78_2[3], arg_78_2[3], var_78_8)
	local var_78_12 = Matrix4x4.transform(arg_78_1, Vector3(var_78_9, var_78_10, var_78_11))

	return arg_78_0, var_78_12
end

var_0_0.random_seed = function ()
	return Math.random(2147483647)
end

var_0_0.distance_2d = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
	return ((arg_80_2 - arg_80_0)^2 + (arg_80_3 - arg_80_1)^2)^0.5
end

var_0_0.diststance_3d = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5)
	return ((arg_81_3 - arg_81_0)^2 + (arg_81_4 - arg_81_1)^2 + (arg_81_5 - arg_81_2)^2)^0.5
end

var_0_0.angle = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	return var_0_0.atan2(arg_82_3 - arg_82_1, arg_82_2 - arg_82_0)
end

var_0_0.index_wrapper = function (arg_83_0, arg_83_1)
	return (arg_83_0 - 1) % arg_83_1 + 1
end

var_0_0.wrap_index_between = function (arg_84_0, arg_84_1, arg_84_2)
	if arg_84_2 < arg_84_1 then
		arg_84_1, arg_84_2 = arg_84_2, arg_84_1
	end

	local var_84_0 = arg_84_2 - arg_84_1

	return arg_84_1 + (arg_84_0 - arg_84_1) % (var_84_0 + 1)
end

var_0_0.stride_index = function (arg_85_0, arg_85_1, arg_85_2)
	arg_85_2 = arg_85_2 or 1

	return (arg_85_0 - 1) * arg_85_1 + 1 + (arg_85_2 - 1)
end

var_0_0.value_inside_range = function (arg_86_0, arg_86_1, arg_86_2)
	return arg_86_1 <= arg_86_0 and arg_86_0 <= arg_86_2
end

var_0_0.quat_angle = function (arg_87_0, arg_87_1)
	local var_87_0 = var_0_6(Quaternion.dot(arg_87_0, arg_87_1))
	local var_87_1 = 0

	if var_87_0 < 1 then
		var_87_1 = 2 * var_0_7(var_87_0)
	end

	return var_87_1
end

local function var_0_16(arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5, arg_88_6, arg_88_7)
	local var_88_0 = 0.8

	for iter_88_0 = 1, arg_88_1 do
		local var_88_1 = arg_88_0[iter_88_0]
		local var_88_2 = Vector3.flat(var_88_1 - arg_88_4)
		local var_88_3 = Vector3.dot(var_88_2, arg_88_3)
		local var_88_4 = var_0_0.floor(var_88_3 / var_88_0 + 0.5) * var_88_0
		local var_88_5 = arg_88_5[var_88_4]

		if not var_88_5 then
			var_88_5 = FrameTable.alloc_table()
			arg_88_5[var_88_4] = var_88_5
			arg_88_6[#arg_88_6 + 1] = var_88_4
		end

		arg_88_7[iter_88_0] = Vector3.dot(var_88_2, arg_88_2)
		var_88_5[#var_88_5 + 1] = iter_88_0
	end
end

local function var_0_17(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5)
	local var_89_0 = #arg_89_1
	local var_89_1 = #arg_89_4
	local var_89_2 = var_89_0 <= var_89_1 and var_89_0 or var_89_1

	for iter_89_0 = 1, var_89_2 do
		local var_89_3 = arg_89_0[arg_89_1[iter_89_0]]
		local var_89_4 = arg_89_3[arg_89_4[iter_89_0]]

		if not var_89_3 or not var_89_4 then
			local var_89_5 = var_89_3 and arg_89_0 or arg_89_3
			local var_89_6 = var_89_3 and arg_89_1 or arg_89_4
			local var_89_7 = var_89_3 and arg_89_2 or arg_89_5

			for iter_89_1 = iter_89_0, #var_89_6 do
				local var_89_8 = var_89_5[var_89_6[iter_89_1]]

				table.sort(var_89_8, function (arg_90_0, arg_90_1)
					return var_89_7[arg_90_0] > var_89_7[arg_90_1]
				end)
			end

			break
		end

		local var_89_9 = #var_89_3
		local var_89_10 = #var_89_4
		local var_89_11 = var_89_9
		local var_89_12 = var_89_10
		local var_89_13
		local var_89_14
		local var_89_15
		local var_89_16

		if var_89_9 <= var_89_10 then
			var_89_13 = var_89_3
			var_89_14 = arg_89_0
			var_89_15 = arg_89_1
			var_89_16 = arg_89_2
		else
			var_89_11, var_89_12 = var_89_12, var_89_11
			var_89_13 = var_89_4
			var_89_14 = arg_89_3
			var_89_15 = arg_89_4
			var_89_16 = arg_89_5
		end

		while var_89_11 < var_89_12 do
			local var_89_17 = var_89_14[var_89_15[iter_89_0 + 1]]
			local var_89_18 = #var_89_17

			if var_89_12 >= var_89_11 + var_89_18 then
				for iter_89_2 = 1, var_89_18 do
					var_89_11 = var_89_11 + 1
					var_89_13[var_89_11] = var_89_17[iter_89_2]
				end

				table.remove(var_89_15, iter_89_0 + 1)
			else
				table.sort(var_89_17, function (arg_91_0, arg_91_1)
					return var_89_16[arg_91_0] > var_89_16[arg_91_1]
				end)

				for iter_89_3 = var_89_18, var_89_18 - (var_89_12 - var_89_11) + 1, -1 do
					var_89_11 = var_89_11 + 1
					var_89_13[var_89_11] = var_89_17[iter_89_3]
					var_89_17[iter_89_3] = nil
				end
			end
		end

		table.sort(var_89_3, function (arg_92_0, arg_92_1)
			return arg_89_2[arg_92_0] > arg_89_2[arg_92_1]
		end)
		table.sort(var_89_4, function (arg_93_0, arg_93_1)
			return arg_89_5[arg_93_0] > arg_89_5[arg_93_1]
		end)
	end
end

var_0_0.distributed_point_matching = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0 = var_0_0.min(#arg_94_0, #arg_94_1)

	if var_94_0 <= 0 then
		return
	end

	local var_94_1 = Vector3.zero()
	local var_94_2 = Vector3.zero()

	for iter_94_0 = 1, var_94_0 do
		var_94_1 = var_94_1 + arg_94_0[iter_94_0]
		var_94_2 = var_94_2 + arg_94_1[iter_94_0]
	end

	local var_94_3 = var_94_1 / var_94_0
	local var_94_4 = var_94_2 / var_94_0
	local var_94_5 = Vector3.normalize(Vector3.flat(var_94_4 - var_94_3))
	local var_94_6 = Vector3.cross(var_94_5, Vector3.up())

	if arg_94_3 then
		var_94_5, var_94_6 = var_94_6, var_94_5
	end

	local var_94_7 = FrameTable.alloc_table()
	local var_94_8 = FrameTable.alloc_table()
	local var_94_9 = FrameTable.alloc_table()

	var_0_16(arg_94_0, var_94_0, var_94_5, var_94_6, var_94_3, var_94_7, var_94_8, var_94_9)
	table.sort(var_94_8)

	local var_94_10 = FrameTable.alloc_table()
	local var_94_11 = FrameTable.alloc_table()
	local var_94_12 = FrameTable.alloc_table()

	var_0_16(arg_94_1, var_94_0, var_94_5, var_94_6, var_94_4, var_94_10, var_94_11, var_94_12)
	table.sort(var_94_11)
	var_0_17(var_94_7, var_94_8, var_94_9, var_94_10, var_94_11, var_94_12)

	local var_94_13 = #var_94_8

	for iter_94_1 = 1, var_94_13 do
		local var_94_14 = var_94_7[var_94_8[iter_94_1]]
		local var_94_15 = var_94_10[var_94_11[iter_94_1]]
		local var_94_16 = #var_94_14

		for iter_94_2 = 1, var_94_16 do
			arg_94_2[var_94_14[iter_94_2]] = var_94_15[iter_94_2]
		end
	end

	return var_94_0
end
