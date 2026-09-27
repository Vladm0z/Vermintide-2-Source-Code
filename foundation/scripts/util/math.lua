-- chunkname: @foundation/scripts/util/math.lua

local math = math
local sqrt = math.sqrt
local cos = math.cos
local sin = math.sin
local random = math.random
local max = math.max
local abs = math.abs
local acos = math.acos
local pi = math.pi

math.epsilon = 0.001
math.tau = 2 * pi
math.half_pi = 0.5 * pi
math.inverse_sqrt_2 = 1 / sqrt(2)
math.degrees_to_radians = math.rad
math.radians_to_degrees = math.deg

math.sign = function (arg_1_0)
	-- function 1
	if arg_1_0 > 0 then
		return 1
	elseif arg_1_0 < 0 then
		return -1
	else
		return 0
	end
end

math.clamp = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if arg_2_2 < arg_2_0 then
		return arg_2_2
	elseif arg_2_0 < arg_2_1 then
		return arg_2_1
	else
		return arg_2_0
	end
end

math.clamp01 = function (arg_3_0)
	-- function 3
	if arg_3_0 > 1 then
		return 1
	elseif arg_3_0 < 0 then
		return 0
	else
		return arg_3_0
	end
end

local clamp = math.clamp

math.normalize = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return (arg_4_0 - arg_4_1) / (arg_4_2 - arg_4_1)
end

math.lerp = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return arg_5_0 * (1 - arg_5_2) + arg_5_1 * arg_5_2
end

local lerp = math.lerp

math.lerp_clamped = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return lerp(arg_6_0, arg_6_1, math.clamp01(arg_6_2))
end

math.inv_lerp = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return (arg_7_2 - arg_7_0) / (arg_7_1 - arg_7_0)
end

math.inv_lerp_clamped = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_2 = not (arg_8_0 < arg_8_1) or not math.clamp(arg_8_2, arg_8_0, arg_8_1) or math.clamp(arg_8_2, arg_8_1, arg_8_0)

	return math.inv_lerp(arg_8_0, arg_8_1, arg_8_2)
end

math.remap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	return (arg_9_4 - arg_9_0) / (arg_9_1 - arg_9_0) * (arg_9_3 - arg_9_2) + arg_9_2
end

math.remap_clamped = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	return math.clamp01((arg_10_4 - arg_10_0) / (arg_10_1 - arg_10_0)) * (arg_10_3 - arg_10_2) + arg_10_2
end

math.radian_lerp = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local num = pi * 2

	return arg_11_0 + arg_11_2 * (((arg_11_1 - arg_11_0) % num + pi) % num - pi)
end

math.angle_lerp = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return arg_12_0 + (((arg_12_1 - arg_12_0) % 360 + 540) % 360 - 180) * arg_12_2
end

math.sirp = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local num = 0.5 + 0.5 * cos((1 + arg_13_2) * pi)

	return lerp(arg_13_0, arg_13_1, num)
end

math.auto_lerp = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local num = (arg_14_4 - arg_14_0) / (arg_14_1 - arg_14_0)

	return math.clamp(lerp(arg_14_2, arg_14_3, num), arg_14_2, arg_14_3)
end

math.round_with_precision = function (arg_15_0, arg_15_1)
	-- function 15
	local num = 10^(arg_15_1 or 0)

	return math.floor(arg_15_0 * num + 0.5) / num
end

math.round = function (arg_16_0)
	-- function 16
	return math.floor(arg_16_0 + 0.5)
end

math.round_to_closest_multiple = function (arg_17_0, arg_17_1)
	-- function 17
	arg_17_1 = arg_17_1 or 1

	local num = arg_17_0 % arg_17_1

	if num <= arg_17_1 / 2 then
		return arg_17_0 - num
	end

	return arg_17_0 + arg_17_1 - num
end

math.smoothstep = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	fassert(arg_18_1 ~= arg_18_2, "Division by zero.")

	local var_18_0 = clamp((arg_18_0 - arg_18_1) / (arg_18_2 - arg_18_1), 0, 1)

	return var_18_0 * var_18_0 * var_18_0 * (var_18_0 * (var_18_0 * 6 - 15) + 10)
end

Math.random_range = function (arg_19_0, arg_19_1)
	-- function 19
	return arg_19_0 + random() * (arg_19_1 - arg_19_0)
end

math.next_random_range = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local next_random, var_20_1 = Math.next_random(arg_20_0)

	return next_random, arg_20_1 + var_20_1 * (arg_20_2 - arg_20_1)
end

math.point_is_inside_2d_box = function (self, arg_21_1, arg_21_2)
	-- function 21
	return not (self[1] > arg_21_1[1]) or not (self[1] < arg_21_1[1] + arg_21_2[1]) or not (self[2] > arg_21_1[2]) or self[2] < arg_21_1[2] + arg_21_2[2]
end

math.box_overlap_box = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	return not (self[1] + arg_22_1[1] >= arg_22_2[1]) or not (arg_22_2[1] + arg_22_3[1] >= self[1]) or not (self[2] + arg_22_1[2] >= arg_22_2[2]) or arg_22_2[2] + arg_22_3[2] >= self[2]
end

math.point_is_inside_aabb = function (self, arg_23_1, arg_23_2)
	-- function 23
	return self[1] < arg_23_1[1] - arg_23_2[1] or self[1] > arg_23_1[1] + arg_23_2[1] or self[2] < arg_23_1[2] - arg_23_2[2] or self[2] > arg_23_1[2] + arg_23_2[2] or self[3] < arg_23_1[3] - arg_23_2[3] or not (self[3] > arg_23_1[3] + arg_23_2[3])
end

math.point_is_inside_box = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local inverse = Matrix4x4.inverse(arg_24_1)
	local transform = Matrix4x4.transform(inverse, arg_24_0)

	return math.point_is_inside_aabb(transform, Vector3.zero(), arg_24_2)
end

math.point_is_inside_oobb = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local inverse = Matrix4x4.inverse(arg_25_1)
	local transform = Matrix4x4.transform(inverse, arg_25_0)

	if not (not (transform.x > -arg_25_2[1]) or not (transform.x < arg_25_2[1]) or not (transform.y > -arg_25_2[2]) or not (transform.y < arg_25_2[2]) or not (transform.z > -arg_25_2[3]) or not (transform.z < arg_25_2[3])) then
		return true
	else
		return false
	end
end

math.point_is_inside_2d_triangle = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local num = arg_26_1 - arg_26_0
	local num_2 = arg_26_2 - arg_26_0
	local num_3 = arg_26_3 - arg_26_0
	local cross = Vector3.cross(num, num_2)
	local cross_2 = Vector3.cross(num_2, num_3)

	if Vector3.dot(cross, cross_2) < 0 then
		return false
	end

	local cross_3 = Vector3.cross(num_3, num)
	local flag = not (Vector3.dot(cross, cross) > Vector3.dot(cross_2, cross_2)) or not cross or cross_2
	local dot = Vector3.dot(flag, cross_3)

	if dot < 0 then
		return false
	elseif dot > 0 then
		return true
	else
		local min = Vector3.min(num, Vector3.min(num_2, num_3))
		local max = Vector3.max(num, Vector3.max(num_2, num_3))

		return not (min.x <= 0) or not (min.y <= 0) or not (max.x >= 0) or max.y >= 0
	end
end

math.point_is_inside_view = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local forward = Quaternion.forward(arg_27_2)
	local normalize = Vector3.normalize(arg_27_0 - arg_27_1)
	local dot = Vector3.dot(normalize, forward)

	if not (dot > 0) then
		local right = Quaternion.right(arg_27_2)
		local up = Quaternion.up(arg_27_2)
		local dot_2 = Vector3.dot(normalize, right)
		local var_27_6 = dot
		local dot_3 = Vector3.dot(normalize, up)
		local var_27_8 = var_27_6
		local var_27_9 = sqrt(dot_2 * dot_2 + var_27_6 * var_27_6)

		if var_27_9 == 0 then
			return false
		end

		local num = var_27_8 / var_27_9

		if math.acos(num) <= arg_27_4 / 2 then
			local num_2 = var_27_9 / sqrt(var_27_9 * var_27_9 + dot_3 * dot_3)

			if math.acos(num_2) <= arg_27_3 / 2 then
				return true
			end

			return false
		end
	end

	return false
end

math.point_is_inside_cylinder = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local var_28_0 = self[3]
	local var_28_1 = arg_28_1[3]

	if not (var_28_0 > var_28_1 + arg_28_4 or not (var_28_0 < var_28_1 - arg_28_4)) then
		return false
	end

	local var_28_2 = self[1]
	local var_28_3 = self[2]
	local var_28_4 = arg_28_1[1]
	local var_28_5 = arg_28_1[2]
	local num = (var_28_2 - var_28_4)^2 + (var_28_3 - var_28_5)^2

	return not (arg_28_2 < num) or num < arg_28_3^2
end

math.cartesian_to_polar = function (arg_29_0, arg_29_1)
	-- function 29
	fassert(arg_29_0 == 0 or arg_29_1 ~= 0, "Can't convert a zero vector to polar coordinates")

	local var_29_0 = sqrt(arg_29_0 * arg_29_0 + arg_29_1 * arg_29_1)
	local num = math.atan(arg_29_1 / arg_29_0) * (180 / math.pi)

	if arg_29_0 < 0 then
		num = num + 180
	elseif arg_29_1 < 0 then
		num = num + 360
	end

	return var_29_0, num
end

math.circular_to_square_coordinates = function (self)
	-- function 30
	local x = self.x
	local y = self.y
	local num = x * x - y * y
	local num_2 = 4 * math.inverse_sqrt_2
	local num_3 = x * num_2
	local num_4 = y * num_2

	return Vector2(0.5 * (sqrt(max(2 + num_3 + num, 0)) - sqrt(max(2 - num_3 + num, 0))), 0.5 * (sqrt(max(2 + num_4 - num, 0)) - sqrt(max(2 - num_4 - num, 0))))
end

math.polar_to_cartesian = function (arg_31_0, arg_31_1)
	-- function 31
	local num = arg_31_1 * (pi / 180)

	return arg_31_0 * cos(num), arg_31_0 * sin(num)
end

math.catmullrom = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	return 0.5 * (2 * arg_32_2 + (-arg_32_1 + arg_32_3) * arg_32_0 + (2 * arg_32_1 - 5 * arg_32_2 + 4 * arg_32_3 - arg_32_4) * arg_32_0 * arg_32_0 + (-arg_32_1 + 3 * arg_32_2 - 3 * arg_32_3 + arg_32_4) * arg_32_0 * arg_32_0 * arg_32_0)
end

math.closest_position = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	if Vector3.distance_squared(arg_33_0, arg_33_1) <= Vector3.distance_squared(arg_33_0, arg_33_2) then
		return arg_33_1
	else
		return arg_33_2
	end
end

math.dot2D = function (self, arg_34_1)
	-- function 34
	return self.x * arg_34_1.x + self.y * arg_34_1.y
end

local Geometry = Geometry

Geometry = Geometry or {}
Geometry = Geometry

Geometry.ccw = function (self, arg_35_1, arg_35_2)
	-- function 35
	return (arg_35_1.x - self.x) * (arg_35_2.y - self.y) > (arg_35_1.y - self.y) * (arg_35_2.x - self.x)
end

local function fn(self, arg_36_1)
	-- function 36
	return self.x < arg_36_1.x
end

local ccw = Geometry.ccw
local dot2D = math.dot2D

Geometry.convex_hull = function (self, arg_37_1)
	-- function 37
	local count = #self

	if count == 0 then
		return arg_37_1, 0
	end

	table.sort(self, fn)

	local num = 0

	for i = 1, count do
		local var_37_2 = self[i]

		while not (not (num >= 2) or ccw(arg_37_1[num - 1], arg_37_1[num], var_37_2)) do
			num = num - 1
		end

		num = num + 1
		arg_37_1[num] = var_37_2
	end

	local num_2 = num + 1

	for j = count, 1, -1 do
		local var_37_4 = self[j]

		while not (not (num_2 <= num) or ccw(arg_37_1[num - 1], arg_37_1[num], var_37_4)) do
			num = num - 1
		end

		num = num + 1
		arg_37_1[num] = var_37_4
	end

	local num_3 = num - 1

	return arg_37_1, num_3
end

Geometry.convex_hull_tracking = function (self, arg_38_1, arg_38_2)
	-- function 38
	local count = #self

	if count == 0 then
		return arg_38_1, 0
	end

	table.sort(self, fn)

	local num = 0

	for i = 1, count do
		local var_38_2 = self[i]

		while not (not (num >= 2) or ccw(arg_38_1[num - 1], arg_38_1[num], var_38_2)) do
			num = num - 1
		end

		num = num + 1
		arg_38_1[num] = var_38_2
		arg_38_2[num] = i
	end

	local num_2 = num + 1

	for j = count, 1, -1 do
		local var_38_4 = self[j]

		while not (not (num_2 <= num) or ccw(arg_38_1[num - 1], arg_38_1[num], var_38_4)) do
			num = num - 1
		end

		num = num + 1
		arg_38_1[num] = var_38_4
		arg_38_2[num] = j
	end

	local num_3 = num - 1

	return arg_38_1, num_3, arg_38_2
end

Geometry.concave_hull = function (self, arg_39_1)
	-- function 39
	local count = #self

	if count == 0 then
		return arg_39_1, 0
	end

	table.sort(self, fn)

	local num = 0

	for i = 1, count do
		local var_39_2 = self[i]

		while not (not (num >= 2) or ccw(arg_39_1[num - 1], arg_39_1[num], var_39_2) or dot2D(arg_39_1[num] - arg_39_1[num - 1], var_39_2 - arg_39_1[num]) > 0.1) do
			num = num - 1
		end

		num = num + 1
		arg_39_1[num] = var_39_2
	end

	local var_39_3 = num
	local num_2 = num + 1

	for j = count, 1, -1 do
		local var_39_5 = self[j]

		while not (not (num_2 <= num) or ccw(arg_39_1[num - 1], arg_39_1[num], var_39_5) or dot2D(arg_39_1[num] - arg_39_1[num - 1], var_39_5 - arg_39_1[num]) > 0.1) do
			num = num - 1
		end

		num = num + 1
		arg_39_1[num] = var_39_5
	end

	local num_3 = num - 1

	return arg_39_1, num_3, var_39_3
end

Geometry.is_point_inside_triangle = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local num = arg_40_1 - arg_40_0
	local num_2 = arg_40_2 - arg_40_0
	local num_3 = arg_40_3 - arg_40_0
	local cross = Vector3.cross(num, num_2)
	local cross_2 = Vector3.cross(num_2, num_3)

	if Vector3.dot(cross, cross_2) < 0 then
		return false
	end

	local cross_3 = Vector3.cross(num_3, num)
	local flag = not (Vector3.dot(cross, cross) > Vector3.dot(cross_2, cross_2)) or not cross or cross_2
	local dot = Vector3.dot(flag, cross_3)

	if dot < 0 then
		return false
	elseif dot > 0 then
		return true
	else
		local min = Vector3.min(num, Vector3.min(num_2, num_3))
		local max = Vector3.max(num, Vector3.max(num_2, num_3))

		return not (min.x <= 0) or not (min.y <= 0) or not (min.z <= 0) or not (max.x >= 0) or not (max.y >= 0) or max.z >= 0
	end
end

local Vector3 = Vector3

Vector3 = not Vector3 and Vector3.dot

Geometry.closest_point_on_line = function (arg_41_0, arg_41_1, arg_41_2)
	-- function 41
	local num = arg_41_0 - arg_41_1
	local num_2 = arg_41_2 - arg_41_1
	local var_41_2 = Vector3(num, num_2)

	if var_41_2 <= 0 then
		return arg_41_1
	end

	local var_41_3 = Vector3(num_2, num_2)

	if var_41_3 <= var_41_2 then
		return arg_41_2
	end

	return arg_41_1 + var_41_2 / var_41_3 * num_2
end

Geometry.closest_point_on_line = EngineOptimized.closest_point_on_line

Geometry.closest_point_on_polyline = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local distance_squared = Vector3.distance_squared
	local closest_point_on_line = Geometry.closest_point_on_line

	arg_42_2 = arg_42_2 or 1
	arg_42_3 = arg_42_3 or #arg_42_1

	local huge = math.huge
	local var_42_3
	local var_42_4

	for i = arg_42_2, arg_42_3 - 1 do
		local var_42_5 = arg_42_1[i]
		local var_42_6 = arg_42_1[i + 1]
		local var_42_7 = closest_point_on_line(arg_42_0, var_42_5, var_42_6)
		local var_42_8 = distance_squared(var_42_7, arg_42_0)

		if var_42_8 < huge then
			huge = var_42_8
			var_42_3 = var_42_7
			var_42_4 = i
		end
	end

	return var_42_3, var_42_4
end

local Intersect = Intersect

Intersect = Intersect or {}
Intersect = Intersect

Intersect.ray_line = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local line_line, var_43_1 = Intersect.line_line(arg_43_0, arg_43_0 + arg_43_1, arg_43_2, arg_43_3)

	if line_line == nil then
		return nil, nil
	elseif line_line < 0 then
		return nil, nil
	else
		return line_line, var_43_1
	end
end

Intersect.ray_box = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	if not Math.point_in_box(arg_44_0, arg_44_2, arg_44_3) then
		return 0
	end

	local ray_box_intersection = Math.ray_box_intersection(arg_44_0, arg_44_1, arg_44_2, arg_44_3)

	if not (ray_box_intersection < 0) then
		return nil
	end

	return ray_box_intersection
end

Intersect.line_line = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	local num = arg_45_1 - arg_45_0
	local num_2 = arg_45_3 - arg_45_2
	local dot = Vector3.dot(num, num)
	local dot_2 = Vector3.dot(num_2, num_2)
	local dot_3 = Vector3.dot(num, num_2)
	local num_3 = dot * dot_2 - dot_3 * dot_3

	if num_3 < 0.001 then
		return nil, nil
	end

	local num_4 = arg_45_0 - arg_45_2
	local dot_4 = Vector3.dot(num, num_4)
	local dot_5 = Vector3.dot(num_2, num_4)
	local num_5 = (dot_3 * dot_5 - dot_4 * dot_2) / num_3
	local num_6 = (dot * dot_5 - dot_3 * dot_4) / num_3

	return num_5, num_6
end

Intersect.ray_segment = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local ray_line, var_46_1 = Intersect.ray_line(arg_46_0, arg_46_1, arg_46_2, arg_46_3)

	if not (ray_line == nil) then
		return nil
	end

	if not (not (var_46_1 >= 0) or var_46_1 <= 1) then
		return ray_line, var_46_1
	else
		return nil, nil
	end
end

Intersect.ray_circle = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local num = arg_47_0 - arg_47_2
	local to_elements, var_47_2 = Vector3.to_elements(num)
	local to_elements_2, var_47_4 = Vector3.to_elements(arg_47_1)
	local num_2 = (to_elements_2 * to_elements_2 + var_47_4 * var_47_4) * 2
	local num_3 = 2 * (to_elements_2 * to_elements + var_47_4 * var_47_2)
	local num_4 = to_elements * to_elements + var_47_2 * var_47_2 - arg_47_3 * arg_47_3
	local num_5 = num_3 * num_3 - 2 * num_2 * num_4

	if num_5 < 0 then
		return nil
	end

	local sqrt = math.sqrt(num_5)
	local num_6 = (-num_3 + sqrt) / num_2
	local var_47_11 = Vector3(to_elements_2 * num_6, var_47_4 * num_6, 0)
	local num_7 = arg_47_0 + var_47_11

	if sqrt < math.epsilon then
		return num_7, num_7, var_47_11, var_47_11
	end

	local num_8 = (-num_3 - sqrt) / num_2
	local var_47_14 = Vector3(to_elements_2 * num_8, var_47_4 * num_8, 0)
	local num_9 = arg_47_0 + var_47_14

	return num_7, num_9, var_47_11, var_47_14
end

math.ease_exp = function (arg_48_0)
	-- function 48
	if arg_48_0 < 0.5 then
		return 0.5 * 2^(20 * (arg_48_0 - 0.5))
	end

	return 1 - 0.5 * 2^(20 * (0.5 - arg_48_0))
end

math.ease_in_exp = function (arg_49_0)
	-- function 49
	return 2^(10 * (arg_49_0 - 1))
end

math.ease_out_exp = function (arg_50_0)
	-- function 50
	return 1 - 2^(-10 * arg_50_0)
end

math.ease_out_sine = function (arg_51_0)
	-- function 51
	return math.sin(arg_51_0 * math.half_pi)
end

math.easeCubic = function (arg_52_0)
	-- function 52
	arg_52_0 = arg_52_0 * 2

	if arg_52_0 < 1 then
		return 0.5 * arg_52_0 * arg_52_0 * arg_52_0
	end

	arg_52_0 = arg_52_0 - 2

	return 0.5 * arg_52_0 * arg_52_0 * arg_52_0 + 1
end

math.linear = function (arg_53_0)
	-- function 53
	return arg_53_0
end

math.linear_inv = function (arg_54_0)
	-- function 54
	return arg_54_0
end

math.easeInCubic = function (arg_55_0)
	-- function 55
	return arg_55_0 * arg_55_0 * arg_55_0
end

math.easeOutCubic = function (arg_56_0)
	-- function 56
	arg_56_0 = arg_56_0 - 1

	return arg_56_0 * arg_56_0 * arg_56_0 + 1
end

math.easeOutCubicInv = function (arg_57_0)
	-- function 57
	return 1 - math.pow(1 - arg_57_0, 0.3333333333333333)
end

math.ease_out_quad = function (arg_58_0)
	-- function 58
	return -1 * arg_58_0 * (arg_58_0 - 2)
end

math.ease_in_quart = function (arg_59_0)
	-- function 59
	return arg_59_0 * arg_59_0 * arg_59_0 * arg_59_0
end

math.ease_out_quart = function (arg_60_0)
	-- function 60
	return 1 - math.pow(1 - arg_60_0, 4)
end

math.ease_out_quart_inv = function (arg_61_0)
	-- function 61
	return math.pow(-arg_61_0 + 1, 0.25) + 1
end

math.ease_in_out_quart = function (arg_62_0)
	-- function 62
	local num

	if arg_62_0 < 0.5 then
		num = 8 * arg_62_0 * arg_62_0 * arg_62_0 * arg_62_0

		if not num then
			-- Nothing
		end
	end

	num = 1 - (-2 * arg_62_0 + 2)^4 / 2

	::label_62_0::

	return num
end

local easeCubic = math.easeCubic

math.ease_pulse = function (arg_63_0)
	-- function 63
	if arg_63_0 < 0.5 then
		return easeCubic(2 * arg_63_0)
	else
		return easeCubic(2 - 2 * arg_63_0)
	end
end

math.ease_in_circ = function (arg_64_0)
	-- function 64
	return 1 - math.sqrt(1 - arg_64_0^2)
end

math.ease_out_circ = function (arg_65_0)
	-- function 65
	return math.sqrt(1 - (arg_65_0 - 1)^2)
end

math.ease_in_back = function (arg_66_0)
	-- function 66
	local num = 1.70158

	return (num + 1) * arg_66_0 * arg_66_0 * arg_66_0 - num * arg_66_0 * arg_66_0
end

math.ease_out_back = function (arg_67_0)
	-- function 67
	c1 = 1.70158
	c3 = c1 + 1

	return 1 + c3 * (arg_67_0 - 1)^3 + c1 * (arg_67_0 - 1)^2
end

math.ease_in_out_back = function (arg_68_0)
	-- function 68
	local num = 1.70158
	local num_2 = num * 1.525
	local num_3

	if arg_68_0 < 0.5 then
		num_3 = (2 * arg_68_0)^2 * ((num_2 + 1) * 2 * arg_68_0 - num_2) / 2

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = ((2 * arg_68_0 - 2)^2 * ((num_2 + 1) * (arg_68_0 * 2 - 2) + num_2) + 2) / 2

	::label_68_0::

	return num_3
end

math.easeOutQuint = function (arg_69_0)
	-- function 69
	return 1 - (1 - arg_69_0)^5
end

math.easeInQuint = function (arg_70_0)
	-- function 70
	return arg_70_0 * arg_70_0 * arg_70_0 * arg_70_0 * arg_70_0
end

math.bounce = function (arg_71_0)
	-- function 71
	return math.abs(sin(math.tau * (arg_71_0 + 1) * (arg_71_0 + 1)) * (1 - arg_71_0))
end

math.ease_out_elastic = function (arg_72_0)
	-- function 72
	local num = 0
	local num_2 = 1

	if arg_72_0 == 0 then
		return 0
	end

	if arg_72_0 == 1 then
		return 1
	end

	if num == 0 then
		num = 0.3
	end

	local var_72_2

	if num_2 < 1 then
		num_2 = 1
		var_72_2 = num / 4
	else
		var_72_2 = num / (2 * math.pi) * math.asin(1 / num_2)
	end

	return num_2 * 2^(-10 * arg_72_0) * sin((arg_72_0 * 1 - var_72_2) * (2 * math.pi) / num) + 1
end

math.easeInOutCubic = function (arg_73_0)
	-- function 73
	local num

	if arg_73_0 < 0.5 then
		num = 4 * arg_73_0 * arg_73_0 * arg_73_0

		if not num then
			-- Nothing
		end
	end

	num = 1 - math.pow(-2 * arg_73_0 + 2, 3) / 2

	::label_73_0::

	return num
end

math.rand_utf8_string = function (arg_74_0, arg_74_1)
	-- function 74
	fassert(arg_74_0 > 0, "String length passed to math.rand_string has to be greater than 0")

	arg_74_1 = arg_74_1 or {
		"\"",
		"'",
		"\\",
		" "
	}

	local tbl = {}

	for i = 1, arg_74_0 do
		local var_74_1

		while not var_74_1 and not table.contains(arg_74_1, var_74_1) do
			var_74_1 = string.char(random(32, 126))
		end

		tbl[i] = var_74_1
	end

	return table.concat(tbl)
end

math.uuid = function ()
	-- function 75
	local var_75_0 = random

	return string.format("%08x-%04x-4%03x-%x%03x-%012x", var_75_0(0, 4294967295), var_75_0(0, 65535), var_75_0(0, 4095), var_75_0(0, 11), var_75_0(0, 4095), var_75_0(0, 281474976710655))
end

math.get_uniformly_random_point_inside_sector = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	-- function 76
	local num = arg_76_0 * arg_76_0
	local num_2 = arg_76_1 * arg_76_1
	local num_3 = arg_76_2 + (arg_76_3 - arg_76_2) * random()
	local var_76_3 = sqrt(num + (num_2 - num) * random())

	return var_76_3 * sin(num_3), var_76_3 * cos(num_3)
end

math.get_uniformly_random_point_inside_sector_seeded = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	-- function 77
	local num = arg_77_1 * arg_77_1
	local num_2 = arg_77_2 * arg_77_2
	local var_77_2
	local var_77_3
	local var_77_4

	arg_77_0, var_77_4 = Math.next_random(arg_77_0)

	local var_77_5

	arg_77_0, var_77_5 = Math.next_random(arg_77_0)

	local num_3 = arg_77_3 + (arg_77_4 - arg_77_3) * var_77_4
	local sqrt = math.sqrt(num + (num_2 - num) * var_77_5)
	local num_4 = sqrt * math.sin(num_3)
	local num_5 = sqrt * math.cos(num_3)

	return arg_77_0, num_4, num_5
end

math.get_random_point_inside_box_seeded = function (arg_78_0, arg_78_1, arg_78_2)
	-- function 78
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

	local lerp = math.lerp(-arg_78_2[1], arg_78_2[1], var_78_6)
	local lerp_2 = math.lerp(-arg_78_2[2], arg_78_2[2], var_78_7)
	local lerp_3 = math.lerp(-arg_78_2[3], arg_78_2[3], var_78_8)
	local transform = Matrix4x4.transform(arg_78_1, Vector3(lerp, lerp_2, lerp_3))

	return arg_78_0, transform
end

math.random_seed = function ()
	-- function 79
	return Math.random(2147483647)
end

math.distance_2d = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
	-- function 80
	return ((arg_80_2 - arg_80_0)^2 + (arg_80_3 - arg_80_1)^2)^0.5
end

math.diststance_3d = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5)
	-- function 81
	return ((arg_81_3 - arg_81_0)^2 + (arg_81_4 - arg_81_1)^2 + (arg_81_5 - arg_81_2)^2)^0.5
end

math.angle = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	-- function 82
	return math.atan2(arg_82_3 - arg_82_1, arg_82_2 - arg_82_0)
end

math.index_wrapper = function (arg_83_0, arg_83_1)
	-- function 83
	return (arg_83_0 - 1) % arg_83_1 + 1
end

math.wrap_index_between = function (arg_84_0, arg_84_1, arg_84_2)
	-- function 84
	if arg_84_2 < arg_84_1 then
		arg_84_1, arg_84_2 = arg_84_2, arg_84_1
	end

	local num = arg_84_2 - arg_84_1

	return arg_84_1 + (arg_84_0 - arg_84_1) % (num + 1)
end

math.stride_index = function (arg_85_0, arg_85_1, arg_85_2)
	-- function 85
	arg_85_2 = arg_85_2 or 1

	return (arg_85_0 - 1) * arg_85_1 + 1 + (arg_85_2 - 1)
end

math.value_inside_range = function (arg_86_0, arg_86_1, arg_86_2)
	-- function 86
	return not (arg_86_1 <= arg_86_0) or arg_86_0 <= arg_86_2
end

math.quat_angle = function (arg_87_0, arg_87_1)
	-- function 87
	local var_87_0 = abs(Quaternion.dot(arg_87_0, arg_87_1))
	local num = 0

	if var_87_0 < 1 then
		num = 2 * acos(var_87_0)
	end

	return num
end

local function fn_2(self, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5, arg_88_6, arg_88_7)
	-- function 88
	local num = 0.8

	for i = 1, arg_88_1 do
		local var_88_1 = self[i]
		local flat = Vector3.flat(var_88_1 - arg_88_4)
		local dot = Vector3.dot(flat, arg_88_3)
		local num_2 = math.floor(dot / num + 0.5) * num
		local var_88_5 = arg_88_5[num_2]

		if not var_88_5 then
			var_88_5 = FrameTable.alloc_table()
			arg_88_5[num_2] = var_88_5
			arg_88_6[#arg_88_6 + 1] = num_2
		end

		arg_88_7[i] = Vector3.dot(flat, arg_88_2)
		var_88_5[#var_88_5 + 1] = i
	end
end

local function fn_3(self, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5)
	-- function 89
	local count = #arg_89_1
	local count_2 = #arg_89_4
	local flag = not (count <= count_2) or not count or count_2

	for i = 1, flag do
		local var_89_3 = self[arg_89_1[i]]
		local var_89_4 = arg_89_3[arg_89_4[i]]

		if not (not var_89_3 and var_89_4) then
			local flag_2 = not var_89_3 and self and arg_89_3
			local flag_3 = not var_89_3 and arg_89_1 and arg_89_4
			local flag_4 = not var_89_3 and arg_89_2 and arg_89_5

			for j = i, #flag_3 do
				local var_89_8 = flag_2[flag_3[j]]

				table.sort(var_89_8, function (arg_90_0, arg_90_1)
					-- function 90
					return flag_4[arg_90_0] > flag_4[arg_90_1]
				end)
			end

			break
		end

		local count_3 = #var_89_3
		local count_4 = #var_89_4
		local var_89_11 = count_3
		local var_89_12 = count_4
		local var_89_13
		local var_89_14
		local var_89_15
		local var_89_16

		if count_3 <= count_4 then
			var_89_13 = var_89_3
			var_89_14 = self
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
			local var_89_17 = var_89_14[var_89_15[i + 1]]
			local count_5 = #var_89_17

			if var_89_12 >= var_89_11 + count_5 then
				for k = 1, count_5 do
					var_89_11 = var_89_11 + 1
					var_89_13[var_89_11] = var_89_17[k]
				end

				table.remove(var_89_15, i + 1)
			else
				table.sort(var_89_17, function (arg_91_0, arg_91_1)
					-- function 91
					return var_89_16[arg_91_0] > var_89_16[arg_91_1]
				end)

				for l = count_5, count_5 - (var_89_12 - var_89_11) + 1, -1 do
					var_89_11 = var_89_11 + 1
					var_89_13[var_89_11] = var_89_17[l]
					var_89_17[l] = nil
				end
			end
		end

		table.sort(var_89_3, function (arg_92_0, arg_92_1)
			-- function 92
			return arg_89_2[arg_92_0] > arg_89_2[arg_92_1]
		end)
		table.sort(var_89_4, function (arg_93_0, arg_93_1)
			-- function 93
			return arg_89_5[arg_93_0] > arg_89_5[arg_93_1]
		end)
	end
end

math.distributed_point_matching = function (self, arg_94_1, arg_94_2, arg_94_3)
	-- function 94
	local min = math.min(#self, #arg_94_1)

	if min <= 0 then
		return
	end

	local zero = Vector3.zero()
	local zero_2 = Vector3.zero()

	for i = 1, min do
		zero = zero + self[i]
		zero_2 = zero_2 + arg_94_1[i]
	end

	local num = zero / min
	local num_2 = zero_2 / min
	local normalize = Vector3.normalize(Vector3.flat(num_2 - num))
	local cross = Vector3.cross(normalize, Vector3.up())

	if not arg_94_3 then
		normalize, cross = cross, normalize
	end

	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()
	local alloc_table_3 = FrameTable.alloc_table()

	fn_2(self, min, normalize, cross, num, alloc_table, alloc_table_2, alloc_table_3)
	table.sort(alloc_table_2)

	local alloc_table_4 = FrameTable.alloc_table()
	local alloc_table_5 = FrameTable.alloc_table()
	local alloc_table_6 = FrameTable.alloc_table()

	fn_2(arg_94_1, min, normalize, cross, num_2, alloc_table_4, alloc_table_5, alloc_table_6)
	table.sort(alloc_table_5)
	fn_3(alloc_table, alloc_table_2, alloc_table_3, alloc_table_4, alloc_table_5, alloc_table_6)

	local count = #alloc_table_2

	for j = 1, count do
		local var_94_14 = alloc_table[alloc_table_2[j]]
		local var_94_15 = alloc_table_4[alloc_table_5[j]]
		local count_2 = #var_94_14

		for k = 1, count_2 do
			arg_94_2[var_94_14[k]] = var_94_15[k]
		end
	end

	return min
end
