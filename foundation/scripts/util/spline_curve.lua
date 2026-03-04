-- chunkname: @foundation/scripts/util/spline_curve.lua

require("foundation/scripts/util/bezier")
require("foundation/scripts/util/hermite")

SplineCurve = class(SplineCurve)

SplineCurve.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, ...)
	arg_1_0._t = 0
	arg_1_0._name = arg_1_4

	local var_1_0 = rawget(_G, arg_1_2)

	arg_1_0._spline_class = var_1_0

	local var_1_1 = {}

	if arg_1_6 then
		arg_1_0._splines = arg_1_6
	else
		arg_1_0:_build_splines(var_1_1, arg_1_1, var_1_0)

		arg_1_0._splines = var_1_1
	end

	arg_1_0._movement = rawget(_G, arg_1_3):new(arg_1_0, var_1_1, var_1_0, arg_1_5, arg_1_6, ...)
end

SplineCurve.splines = function (arg_2_0)
	return arg_2_0._splines
end

SplineCurve.name = function (arg_3_0)
	return arg_3_0._name
end

SplineCurve.recalc_splines = function (arg_4_0, arg_4_1)
	arg_4_0:_build_splines(arg_4_0._splines, arg_4_1, arg_4_0._spline_class, 1)
	arg_4_0._movement:recalc_splines()
end

SplineCurve._build_splines = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = 1
	local var_5_1 = 1

	while var_5_0 do
		local var_5_2 = {
			arg_5_3.spline_points(arg_5_2, var_5_0)
		}

		for iter_5_0, iter_5_1 in ipairs(var_5_2) do
			var_5_2[iter_5_0] = Vector3Box(iter_5_1)
		end

		arg_5_1[var_5_1] = {
			points = var_5_2
		}
		var_5_0 = arg_5_3.next_index(arg_5_2, var_5_0)
		var_5_1 = var_5_1 + 1
	end

	arg_5_0._num_points = #arg_5_2 - 1
end

function unpack_unbox(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or 1

	local var_6_0 = arg_6_0[arg_6_1]

	if not var_6_0 then
		return nil
	end

	return var_6_0:unbox(), unpack_unbox(arg_6_0, arg_6_1 + 1)
end

SplineCurve.draw = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_0._spline_class

	for iter_7_0, iter_7_1 in ipairs(arg_7_0._splines) do
		if iter_7_0 > arg_7_0._num_points then
			return
		end

		local var_7_1 = iter_7_1.points

		var_7_0.draw(arg_7_1, arg_7_2, arg_7_3, arg_7_4, unpack_unbox(var_7_1))
	end
end

SplineCurve.length = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._spline_class
	local var_8_1 = 0

	for iter_8_0, iter_8_1 in ipairs(arg_8_0._splines) do
		if iter_8_0 > arg_8_0._num_points then
			break
		end

		local var_8_2 = iter_8_1.points

		var_8_1 = var_8_1 + var_8_0.length(arg_8_1, unpack_unbox(var_8_2))
	end

	return var_8_1
end

SplineCurve.get_travel_dist_to_spline_point = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._splines
	local var_9_1 = arg_9_0._spline_class
	local var_9_2 = 0

	for iter_9_0 = 1, arg_9_1 do
		var_9_2 = var_9_2 + var_9_0[iter_9_0].length
	end

	return var_9_2
end

SplineCurve.get_point_at_distance = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._splines
	local var_10_1 = arg_10_0._spline_class
	local var_10_2 = 0

	for iter_10_0 = 1, #var_10_0 do
		if iter_10_0 > arg_10_0._num_points then
			break
		end

		local var_10_3 = var_10_0[iter_10_0]
		local var_10_4 = var_10_3.length

		if arg_10_1 < var_10_2 + var_10_4 then
			local var_10_5 = (arg_10_1 - var_10_2) / var_10_4
			local var_10_6 = var_10_3.points
			local var_10_7 = var_10_6[1]:unbox()
			local var_10_8 = var_10_6[2]:unbox()
			local var_10_9 = var_10_6[3]:unbox()
			local var_10_10 = var_10_6[4]:unbox()
			local var_10_11 = var_10_1.calc_point(var_10_5, var_10_7, var_10_8, var_10_9, var_10_10)
			local var_10_12 = var_10_1.calc_tangent(var_10_5, var_10_7, var_10_8, var_10_9, var_10_10)

			return var_10_11, var_10_12
		end

		var_10_2 = var_10_2 + var_10_4
	end

	local var_10_13 = var_10_0[#var_10_0].points

	return var_10_13[3]:unbox(), var_10_1.calc_tangent(1, var_10_13[1]:unbox(), var_10_13[2]:unbox(), var_10_13[3]:unbox(), var_10_13[4]:unbox()), true
end

SplineCurve.movement = function (arg_11_0)
	return arg_11_0._movement
end

SplineCurve.update = function (arg_12_0, arg_12_1)
	arg_12_0._movement:update(arg_12_1)
end

SplineMovementMetered = class(SplineMovementMetered)

SplineMovementMetered.init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0._splines = arg_13_2
	arg_13_0._spline_curve = arg_13_1
	arg_13_0._spline_class = arg_13_3
	arg_13_0._speed = 0
	arg_13_0._current_spline_index = 1
	arg_13_0._t = 0

	arg_13_0:_set_spline_lengths(arg_13_2, arg_13_3)
end

SplineMovementMetered.recalc_splines = function (arg_14_0)
	arg_14_0:_set_spline_lengths(arg_14_0._splines, arg_14_0._spline_class)
end

SplineMovementMetered._set_spline_lengths = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_3 = arg_15_3 or 10

	for iter_15_0, iter_15_1 in ipairs(arg_15_1) do
		local var_15_0 = iter_15_1.points

		iter_15_1.length = arg_15_2.length(arg_15_3, unpack_unbox(var_15_0))

		fassert(iter_15_1.length > 0, "[SplineMovementMetered] Spline %n in curve %s has length 0.", iter_15_0, arg_15_0._spline_curve:name())
	end
end

SplineMovementMetered.draw = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0:current_position()

	arg_16_1:sphere(var_16_0, arg_16_2 or 1, arg_16_3)
end

SplineMovementMetered.current_position = function (arg_17_0)
	return arg_17_0._spline_class.calc_point(arg_17_0._t, unpack_unbox(arg_17_0:_current_spline().points))
end

SplineMovementMetered._current_spline = function (arg_18_0)
	return arg_18_0._splines[arg_18_0._current_spline_index]
end

SplineMovementMetered.update = function (arg_19_0, arg_19_1)
	arg_19_0:move(arg_19_1 * arg_19_0._speed)
end

SplineMovementMetered.move = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:_current_spline().length
	local var_20_1 = arg_20_0._t + arg_20_1 / var_20_0

	if var_20_1 > 1 and arg_20_0._current_spline_index == #arg_20_0._splines then
		arg_20_0._t = 1

		return
	elseif var_20_1 > 1 then
		arg_20_0._current_spline_index = arg_20_0._current_spline_index + 1
		arg_20_0._t = 0

		local var_20_2 = arg_20_1 - (var_20_1 - 1) * var_20_0

		return arg_20_0:move(var_20_2)
	elseif var_20_1 < 0 and arg_20_0._current_spline_index == 1 then
		arg_20_0._t = 0

		return
	elseif var_20_1 < 0 then
		arg_20_0._current_spline_index = arg_20_0._current_spline_index - 1
		arg_20_0._t = 1

		local var_20_3 = arg_20_1 - var_20_1 * var_20_0

		return arg_20_0:move(var_20_3)
	else
		arg_20_0._t = var_20_1

		return
	end
end

SplineMovementHermiteInterpolatedMetered = class(SplineMovementHermiteInterpolatedMetered)

SplineMovementHermiteInterpolatedMetered.init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	arg_21_0._splines = arg_21_5 or arg_21_2
	arg_21_0._spline_curve = arg_21_1
	arg_21_0._spline_class = arg_21_3
	arg_21_0._speed = 0
	arg_21_0._current_spline_index = 1
	arg_21_0._t = 0
	arg_21_0._current_subdivision_index = 1
	arg_21_0._current_spline_curve_distance = 0

	if not arg_21_5 then
		arg_21_0:_build_subdivisions(arg_21_4, arg_21_2, arg_21_3)
	end
end

SplineMovementHermiteInterpolatedMetered.recalc_splines = function (arg_22_0)
	arg_22_0:_set_spline_lengths(arg_22_0._splines, arg_22_0._spline_class)
end

SplineMovementHermiteInterpolatedMetered._build_subdivisions = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_3.calc_point(0, unpack_unbox(arg_23_2[1].points))
	local var_23_1 = {
		[0] = var_23_0
	}

	for iter_23_0, iter_23_1 in ipairs(arg_23_2) do
		for iter_23_2 = 1, arg_23_1 do
			local var_23_2 = arg_23_3.calc_point(iter_23_2 / arg_23_1, unpack_unbox(iter_23_1.points))

			var_23_1[#var_23_1 + 1] = var_23_2
		end
	end

	var_23_1[-1] = var_23_0
	var_23_1[#var_23_1 + 1] = var_23_1[#var_23_1]

	for iter_23_3, iter_23_4 in ipairs(arg_23_2) do
		local var_23_3 = {}
		local var_23_4 = (iter_23_3 - 1) * arg_23_1

		iter_23_4.length = 0

		for iter_23_5 = 1, arg_23_1 do
			local var_23_5 = {}
			local var_23_6 = var_23_1[var_23_4 - 1]
			local var_23_7 = var_23_1[var_23_4]
			local var_23_8 = var_23_1[var_23_4 + 1]
			local var_23_9 = var_23_1[var_23_4 + 2]

			var_23_5.points = {
				Vector3Box(var_23_6),
				Vector3Box(var_23_7),
				Vector3Box(var_23_8),
				Vector3Box(var_23_9)
			}

			local var_23_10, var_23_11, var_23_12 = Script.temp_count()

			var_23_5.length = Hermite.length(10, var_23_6, var_23_7, var_23_8, var_23_9)

			Script.set_temp_count(var_23_10, var_23_11, var_23_12)

			var_23_4 = var_23_4 + 1
			var_23_3[#var_23_3 + 1] = var_23_5
			iter_23_4.length = iter_23_4.length + var_23_5.length
		end

		iter_23_4.subdivisions = var_23_3
	end
end

SplineMovementHermiteInterpolatedMetered._set_spline_lengths = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_3 = arg_24_3 or 10

	for iter_24_0, iter_24_1 in ipairs(arg_24_1) do
		local var_24_0 = iter_24_1.points

		iter_24_1.length = arg_24_2.length(arg_24_3, unpack_unbox(var_24_0))

		fassert(iter_24_1.length > 0, "[SplineMovementHermiteInterpolatedMetered] Spline %n in curve %s has length 0.", iter_24_0, arg_24_0._spline_curve:name())
	end
end

SplineMovementHermiteInterpolatedMetered.draw = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_0:current_position()

	arg_25_1:sphere(var_25_0, arg_25_2 or 1, arg_25_3)
end

SplineMovementHermiteInterpolatedMetered.draw_subdivisions = function (arg_26_0, arg_26_1, arg_26_2)
	for iter_26_0, iter_26_1 in ipairs(arg_26_0._splines) do
		for iter_26_2, iter_26_3 in ipairs(iter_26_1.subdivisions) do
			Hermite.draw(10, arg_26_1, Color(255, 0, 0), nil, unpack_unbox(iter_26_3.points))
		end
	end
end

SplineMovementHermiteInterpolatedMetered.current_position = function (arg_27_0)
	local var_27_0 = arg_27_0:_current_spline_subdivision()

	return Hermite.calc_point(arg_27_0._t, unpack_unbox(var_27_0.points))
end

SplineMovementHermiteInterpolatedMetered.current_tangent_direction = function (arg_28_0)
	local var_28_0 = arg_28_0:_current_spline_subdivision()

	return Hermite.calc_tangent(arg_28_0._t, unpack_unbox(var_28_0.points))
end

SplineMovementHermiteInterpolatedMetered._current_spline = function (arg_29_0)
	return arg_29_0._splines[arg_29_0._current_spline_index]
end

SplineMovementHermiteInterpolatedMetered.update = function (arg_30_0, arg_30_1)
	return (arg_30_0:move(arg_30_1 * arg_30_0._speed))
end

SplineMovementHermiteInterpolatedMetered.distance = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	local var_31_0 = 0
	local var_31_1 = arg_31_0._splines

	if arg_31_4 < arg_31_1 then
		local var_31_2 = var_31_1[arg_31_1]

		var_31_0 = var_31_0 - arg_31_3 * var_31_2.subdivisions[arg_31_2].length

		local var_31_3 = var_31_2.subdivisions

		for iter_31_0 = 1, arg_31_2 - 1 do
			var_31_0 = var_31_0 - var_31_3[iter_31_0].length
		end

		for iter_31_1 = arg_31_4 + 1, arg_31_1 - 1 do
			var_31_0 = var_31_0 - var_31_1[iter_31_1].length
		end

		local var_31_4 = var_31_1[arg_31_4].subdivisions

		for iter_31_2 = arg_31_5 + 1, #var_31_4 do
			var_31_0 = var_31_0 - var_31_4[iter_31_2].length
		end

		var_31_0 = var_31_0 - (1 - arg_31_6) * var_31_4[arg_31_5].length
	elseif arg_31_1 < arg_31_4 then
		local var_31_5 = var_31_1[arg_31_1].subdivisions

		var_31_0 = var_31_0 + (1 - arg_31_3) * var_31_5[arg_31_2].length

		for iter_31_3 = arg_31_2 + 1, #var_31_5 do
			var_31_0 = var_31_0 + var_31_5[iter_31_3].length
		end

		for iter_31_4 = arg_31_1 + 1, arg_31_4 - 1 do
			var_31_0 = var_31_0 + var_31_1[iter_31_4].length
		end

		local var_31_6 = var_31_1[arg_31_4].subdivisions

		for iter_31_5 = 1, arg_31_5 - 1 do
			var_31_0 = var_31_0 + var_31_6[iter_31_5].length
		end

		var_31_0 = var_31_0 + arg_31_6 * var_31_6[arg_31_5].length
	elseif arg_31_1 == arg_31_4 and arg_31_2 < arg_31_5 then
		local var_31_7 = var_31_1[arg_31_1].subdivisions

		var_31_0 = var_31_0 + (1 - arg_31_3) * var_31_7[arg_31_2].length

		for iter_31_6 = arg_31_2 + 1, arg_31_5 - 1 do
			var_31_0 = var_31_0 + var_31_7[iter_31_6].length
		end

		var_31_0 = var_31_0 + arg_31_6 * var_31_7[arg_31_5].length
	elseif arg_31_1 == arg_31_4 and arg_31_5 < arg_31_2 then
		local var_31_8 = var_31_1[arg_31_1].subdivisions

		var_31_0 = var_31_0 - arg_31_3 * var_31_8[arg_31_2].length

		for iter_31_7 = arg_31_5 + 1, arg_31_2 - 1 do
			var_31_0 = var_31_0 - var_31_8[iter_31_7].length
		end

		var_31_0 = var_31_0 - (1 - arg_31_6) * var_31_8[arg_31_5].length
	else
		var_31_0 = (arg_31_6 - arg_31_3) * var_31_1[arg_31_1].subdivisions[arg_31_2].length
	end

	return var_31_0
end

SplineMovementHermiteInterpolatedMetered.set_speed = function (arg_32_0, arg_32_1)
	arg_32_0._speed = arg_32_1
end

SplineMovementHermiteInterpolatedMetered.speed = function (arg_33_0)
	return arg_33_0._speed
end

SplineMovementHermiteInterpolatedMetered._current_spline_subdivision = function (arg_34_0)
	return arg_34_0:_current_spline().subdivisions[arg_34_0._current_subdivision_index]
end

SplineMovementHermiteInterpolatedMetered.move = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0:_current_spline()
	local var_35_1 = arg_35_0:_current_spline_subdivision().length
	local var_35_2 = arg_35_0._t + arg_35_1 / var_35_1

	if var_35_2 >= 1 and arg_35_0._current_spline_index == #arg_35_0._splines and arg_35_0._current_subdivision_index == #var_35_0.subdivisions then
		arg_35_0._t = 1

		local var_35_3 = arg_35_1 - (var_35_2 - 1) * var_35_1

		arg_35_0._current_spline_curve_distance = arg_35_0._current_spline_curve_distance + var_35_3

		return "end"
	elseif var_35_2 > 1 then
		arg_35_0._current_subdivision_index = arg_35_0._current_subdivision_index + 1

		if arg_35_0._current_subdivision_index > #var_35_0.subdivisions then
			arg_35_0._current_subdivision_index = 1
			arg_35_0._current_spline_index = arg_35_0._current_spline_index + 1
		end

		arg_35_0._t = 0

		local var_35_4 = (var_35_2 - 1) * var_35_1
		local var_35_5 = arg_35_1 - var_35_4

		arg_35_0._current_spline_curve_distance = arg_35_0._current_spline_curve_distance + var_35_5

		return arg_35_0:move(var_35_4)
	elseif var_35_2 <= 0 and arg_35_0._current_spline_index == 1 and arg_35_0._current_subdivision_index == 1 then
		arg_35_0._t = 0
		arg_35_0._current_spline_curve_distance = 0

		return "start"
	elseif var_35_2 < 0 then
		arg_35_0._current_subdivision_index = arg_35_0._current_subdivision_index - 1

		if arg_35_0._current_subdivision_index == 0 then
			arg_35_0._current_spline_index = arg_35_0._current_spline_index - 1
			arg_35_0._current_subdivision_index = #arg_35_0:_current_spline().subdivisions
		end

		arg_35_0._t = 1

		local var_35_6 = var_35_2 * var_35_1
		local var_35_7 = arg_35_1 - var_35_6

		arg_35_0._current_spline_curve_distance = arg_35_0._current_spline_curve_distance + var_35_7

		return arg_35_0:move(var_35_6)
	else
		arg_35_0._t = var_35_2
		arg_35_0._current_spline_curve_distance = arg_35_0._current_spline_curve_distance + arg_35_1

		return "moving"
	end
end

SplineMovementHermiteInterpolatedMetered.reset_to_start = function (arg_36_0)
	arg_36_0._current_spline_index = 1
	arg_36_0._current_subdivision_index = 1
	arg_36_0._t = 0
	arg_36_0._current_spline_curve_distance = 0
end

SplineMovementHermiteInterpolatedMetered.reset_to_end = function (arg_37_0)
	local var_37_0 = arg_37_0:_current_spline()

	arg_37_0._current_spline_index = #arg_37_0._splines
	arg_37_0._current_subdivision_index = #var_37_0.subdivisions
	arg_37_0._t = 1

	local var_37_1 = 1
	local var_37_2 = 1
	local var_37_3 = 0
	local var_37_4 = arg_37_0._current_spline_index
	local var_37_5 = arg_37_0._current_subdivision_index
	local var_37_6 = arg_37_0._t

	arg_37_0._current_spline_curve_distance = arg_37_0:distance(var_37_1, var_37_2, var_37_3, var_37_4, var_37_5, var_37_6)
end

SplineMovementHermiteInterpolatedMetered.set_spline_index = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	arg_38_0._current_spline_index = arg_38_1
	arg_38_0._current_subdivision_index = arg_38_2
	arg_38_0._t = arg_38_3

	local var_38_0 = 1
	local var_38_1 = 1
	local var_38_2 = 0

	arg_38_0._current_spline_curve_distance = arg_38_0:distance(var_38_0, var_38_1, var_38_2, arg_38_1, arg_38_2, arg_38_3)
end

SplineMovementHermiteInterpolatedMetered.current_spline_index = function (arg_39_0)
	return arg_39_0._current_spline_index
end

SplineMovementHermiteInterpolatedMetered.current_subdivision_index = function (arg_40_0)
	return arg_40_0._current_subdivision_index
end

SplineMovementHermiteInterpolatedMetered.current_t = function (arg_41_0)
	return arg_41_0._t
end

SplineMovementHermiteInterpolatedMetered.current_spline_curve_distance = function (arg_42_0)
	return arg_42_0._current_spline_curve_distance
end
