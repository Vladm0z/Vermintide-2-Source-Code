-- chunkname: @foundation/scripts/util/spline_curve.lua

require("foundation/scripts/util/bezier")
require("foundation/scripts/util/hermite")

SplineCurve = class(SplineCurve)

SplineCurve.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, ...)
	-- function 1
	self._t = 0
	self._name = arg_1_4

	local var_1_0 = rawget(_G, arg_1_2)

	self._spline_class = var_1_0

	local tbl = {}

	if not arg_1_6 then
		self._splines = arg_1_6
	else
		self:_build_splines(tbl, arg_1_1, var_1_0)

		self._splines = tbl
	end

	self._movement = rawget(_G, arg_1_3):new(self, tbl, var_1_0, arg_1_5, arg_1_6, ...)
end

SplineCurve.splines = function (self)
	-- function 2
	return self._splines
end

SplineCurve.name = function (self)
	-- function 3
	return self._name
end

SplineCurve.recalc_splines = function (self, arg_4_1)
	-- function 4
	self:_build_splines(self._splines, arg_4_1, self._spline_class, 1)
	self._movement:recalc_splines()
end

SplineCurve._build_splines = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local num = 1
	local num_2 = 1

	while not num do
		local tbl = {
			arg_5_3.spline_points(arg_5_2, num)
		}

		for i, v in ipairs(tbl) do
			tbl[i] = Vector3Box(v)
		end

		arg_5_1[num_2] = {
			points = tbl
		}
		num = arg_5_3.next_index(arg_5_2, num)
		num_2 = num_2 + 1
	end

	self._num_points = #arg_5_2 - 1
end

function unpack_unbox(self, arg_6_1)
	-- function 6
	arg_6_1 = arg_6_1 or 1

	local var_6_0 = self[arg_6_1]

	if not var_6_0 then
		return nil
	end

	return var_6_0:unbox(), unpack_unbox(self, arg_6_1 + 1)
end

SplineCurve.draw = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local _spline_class = self._spline_class

	for i, v in ipairs(self._splines) do
		if i > self._num_points then
			return
		end

		local points = v.points

		_spline_class.draw(arg_7_1, arg_7_2, arg_7_3, arg_7_4, unpack_unbox(points))
	end
end

SplineCurve.length = function (self, arg_8_1)
	-- function 8
	local _spline_class = self._spline_class
	local num = 0

	for i, v in ipairs(self._splines) do
		if i > self._num_points then
			break
		end

		local points = v.points

		num = num + _spline_class.length(arg_8_1, unpack_unbox(points))
	end

	return num
end

SplineCurve.get_travel_dist_to_spline_point = function (self, arg_9_1)
	-- function 9
	local _splines = self._splines
	local _spline_class = self._spline_class
	local num = 0

	for i = 1, arg_9_1 do
		num = num + _splines[i].length
	end

	return num
end

SplineCurve.get_point_at_distance = function (self, arg_10_1)
	-- function 10
	local _splines = self._splines
	local _spline_class = self._spline_class
	local num = 0

	for i = 1, #_splines do
		if i > self._num_points then
			break
		end

		local var_10_3 = _splines[i]
		local length = var_10_3.length

		if arg_10_1 < num + length then
			local num_2 = (arg_10_1 - num) / length
			local points = var_10_3.points
			local unbox = points[1]:unbox()
			local unbox_2 = points[2]:unbox()
			local unbox_3 = points[3]:unbox()
			local unbox_4 = points[4]:unbox()
			local calc_point = _spline_class.calc_point(num_2, unbox, unbox_2, unbox_3, unbox_4)
			local calc_tangent = _spline_class.calc_tangent(num_2, unbox, unbox_2, unbox_3, unbox_4)

			return calc_point, calc_tangent
		end

		num = num + length
	end

	local points_2 = _splines[#_splines].points

	return points_2[3]:unbox(), _spline_class.calc_tangent(1, points_2[1]:unbox(), points_2[2]:unbox(), points_2[3]:unbox(), points_2[4]:unbox()), true
end

SplineCurve.movement = function (self)
	-- function 11
	return self._movement
end

SplineCurve.update = function (self, arg_12_1)
	-- function 12
	self._movement:update(arg_12_1)
end

SplineMovementMetered = class(SplineMovementMetered)

SplineMovementMetered.init = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	self._splines = arg_13_2
	self._spline_curve = arg_13_1
	self._spline_class = arg_13_3
	self._speed = 0
	self._current_spline_index = 1
	self._t = 0

	self:_set_spline_lengths(arg_13_2, arg_13_3)
end

SplineMovementMetered.recalc_splines = function (self)
	-- function 14
	self:_set_spline_lengths(self._splines, self._spline_class)
end

SplineMovementMetered._set_spline_lengths = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	arg_15_3 = arg_15_3 or 10

	for i, v in ipairs(arg_15_1) do
		local points = v.points

		v.length = arg_15_2.length(arg_15_3, unpack_unbox(points))

		fassert(v.length > 0, "[SplineMovementMetered] Spline %n in curve %s has length 0.", i, self._spline_curve:name())
	end
end

SplineMovementMetered.draw = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local current_position = self:current_position()

	arg_16_1:sphere(current_position, arg_16_2 or 1, arg_16_3)
end

SplineMovementMetered.current_position = function (self)
	-- function 17
	return self._spline_class.calc_point(self._t, unpack_unbox(self:_current_spline().points))
end

SplineMovementMetered._current_spline = function (self)
	-- function 18
	return self._splines[self._current_spline_index]
end

SplineMovementMetered.update = function (self, arg_19_1)
	-- function 19
	self:move(arg_19_1 * self._speed)
end

SplineMovementMetered.move = function (self, arg_20_1)
	-- function 20
	local length = self:_current_spline().length
	local num = self._t + arg_20_1 / length

	if not (not (num > 1) or self._current_spline_index ~= #self._splines) then
		self._t = 1

		return
	elseif num > 1 then
		self._current_spline_index = self._current_spline_index + 1
		self._t = 0

		local num_2 = arg_20_1 - (num - 1) * length

		return self:move(num_2)
	elseif not (not (num < 0) or self._current_spline_index ~= 1) then
		self._t = 0

		return
	elseif num < 0 then
		self._current_spline_index = self._current_spline_index - 1
		self._t = 1

		local num_3 = arg_20_1 - num * length

		return self:move(num_3)
	else
		self._t = num

		return
	end
end

SplineMovementHermiteInterpolatedMetered = class(SplineMovementHermiteInterpolatedMetered)

SplineMovementHermiteInterpolatedMetered.init = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	self._splines = arg_21_5 or arg_21_2
	self._spline_curve = arg_21_1
	self._spline_class = arg_21_3
	self._speed = 0
	self._current_spline_index = 1
	self._t = 0
	self._current_subdivision_index = 1
	self._current_spline_curve_distance = 0

	if not arg_21_5 then
		self:_build_subdivisions(arg_21_4, arg_21_2, arg_21_3)
	end
end

SplineMovementHermiteInterpolatedMetered.recalc_splines = function (self)
	-- function 22
	self:_set_spline_lengths(self._splines, self._spline_class)
end

SplineMovementHermiteInterpolatedMetered._build_subdivisions = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local calc_point = arg_23_3.calc_point(0, unpack_unbox(arg_23_2[1].points))
	local tbl = {
		[0] = calc_point
	}

	for i, v in ipairs(arg_23_2) do
		for k = 1, arg_23_1 do
			local calc_point_2 = arg_23_3.calc_point(k / arg_23_1, unpack_unbox(v.points))

			tbl[#tbl + 1] = calc_point_2
		end
	end

	tbl[-1] = calc_point
	tbl[#tbl + 1] = tbl[#tbl]

	for i_2, v_2 in ipairs(arg_23_2) do
		local tbl_2 = {}
		local num = (i_2 - 1) * arg_23_1

		v_2.length = 0

		for i5 = 1, arg_23_1 do
			local tbl_3 = {}
			local var_23_6 = tbl[num - 1]
			local var_23_7 = tbl[num]
			local var_23_8 = tbl[num + 1]
			local var_23_9 = tbl[num + 2]

			tbl_3.points = {
				Vector3Box(var_23_6),
				Vector3Box(var_23_7),
				Vector3Box(var_23_8),
				Vector3Box(var_23_9)
			}

			local temp_count, var_23_11, var_23_12 = Script.temp_count()

			tbl_3.length = Hermite.length(10, var_23_6, var_23_7, var_23_8, var_23_9)

			Script.set_temp_count(temp_count, var_23_11, var_23_12)

			num = num + 1
			tbl_2[#tbl_2 + 1] = tbl_3
			v_2.length = v_2.length + tbl_3.length
		end

		v_2.subdivisions = tbl_2
	end
end

SplineMovementHermiteInterpolatedMetered._set_spline_lengths = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	arg_24_3 = arg_24_3 or 10

	for i, v in ipairs(arg_24_1) do
		local points = v.points

		v.length = arg_24_2.length(arg_24_3, unpack_unbox(points))

		fassert(v.length > 0, "[SplineMovementHermiteInterpolatedMetered] Spline %n in curve %s has length 0.", i, self._spline_curve:name())
	end
end

SplineMovementHermiteInterpolatedMetered.draw = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local current_position = self:current_position()

	arg_25_1:sphere(current_position, arg_25_2 or 1, arg_25_3)
end

SplineMovementHermiteInterpolatedMetered.draw_subdivisions = function (self, arg_26_1, arg_26_2)
	-- function 26
	for i, v in ipairs(self._splines) do
		for i_2, v_2 in ipairs(v.subdivisions) do
			Hermite.draw(10, arg_26_1, Color(255, 0, 0), nil, unpack_unbox(v_2.points))
		end
	end
end

SplineMovementHermiteInterpolatedMetered.current_position = function (self)
	-- function 27
	local _current_spline_subdivision = self:_current_spline_subdivision()

	return Hermite.calc_point(self._t, unpack_unbox(_current_spline_subdivision.points))
end

SplineMovementHermiteInterpolatedMetered.current_tangent_direction = function (self)
	-- function 28
	local _current_spline_subdivision = self:_current_spline_subdivision()

	return Hermite.calc_tangent(self._t, unpack_unbox(_current_spline_subdivision.points))
end

SplineMovementHermiteInterpolatedMetered._current_spline = function (self)
	-- function 29
	return self._splines[self._current_spline_index]
end

SplineMovementHermiteInterpolatedMetered.update = function (self, arg_30_1)
	-- function 30
	return (self:move(arg_30_1 * self._speed))
end

SplineMovementHermiteInterpolatedMetered.distance = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	-- function 31
	local num = 0
	local _splines = self._splines

	if arg_31_4 < arg_31_1 then
		local var_31_2 = _splines[arg_31_1]

		num = num - arg_31_3 * var_31_2.subdivisions[arg_31_2].length

		local subdivisions = var_31_2.subdivisions

		for i = 1, arg_31_2 - 1 do
			num = num - subdivisions[i].length
		end

		for j = arg_31_4 + 1, arg_31_1 - 1 do
			num = num - _splines[j].length
		end

		local subdivisions_2 = _splines[arg_31_4].subdivisions

		for k = arg_31_5 + 1, #subdivisions_2 do
			num = num - subdivisions_2[k].length
		end

		num = num - (1 - arg_31_6) * subdivisions_2[arg_31_5].length
	elseif arg_31_1 < arg_31_4 then
		local subdivisions_3 = _splines[arg_31_1].subdivisions

		num = num + (1 - arg_31_3) * subdivisions_3[arg_31_2].length

		for l = arg_31_2 + 1, #subdivisions_3 do
			num = num + subdivisions_3[l].length
		end

		for i4 = arg_31_1 + 1, arg_31_4 - 1 do
			num = num + _splines[i4].length
		end

		local subdivisions_4 = _splines[arg_31_4].subdivisions

		for i5 = 1, arg_31_5 - 1 do
			num = num + subdivisions_4[i5].length
		end

		num = num + arg_31_6 * subdivisions_4[arg_31_5].length
	elseif not (arg_31_1 ~= arg_31_4 or not (arg_31_2 < arg_31_5)) then
		local subdivisions_5 = _splines[arg_31_1].subdivisions

		num = num + (1 - arg_31_3) * subdivisions_5[arg_31_2].length

		for i6 = arg_31_2 + 1, arg_31_5 - 1 do
			num = num + subdivisions_5[i6].length
		end

		num = num + arg_31_6 * subdivisions_5[arg_31_5].length
	elseif not (arg_31_1 ~= arg_31_4 or not (arg_31_5 < arg_31_2)) then
		local subdivisions_6 = _splines[arg_31_1].subdivisions

		num = num - arg_31_3 * subdivisions_6[arg_31_2].length

		for i7 = arg_31_5 + 1, arg_31_2 - 1 do
			num = num - subdivisions_6[i7].length
		end

		num = num - (1 - arg_31_6) * subdivisions_6[arg_31_5].length
	else
		num = (arg_31_6 - arg_31_3) * _splines[arg_31_1].subdivisions[arg_31_2].length
	end

	return num
end

SplineMovementHermiteInterpolatedMetered.set_speed = function (self, arg_32_1)
	-- function 32
	self._speed = arg_32_1
end

SplineMovementHermiteInterpolatedMetered.speed = function (self)
	-- function 33
	return self._speed
end

SplineMovementHermiteInterpolatedMetered._current_spline_subdivision = function (self)
	-- function 34
	return self:_current_spline().subdivisions[self._current_subdivision_index]
end

SplineMovementHermiteInterpolatedMetered.move = function (self, arg_35_1)
	-- function 35
	local _current_spline = self:_current_spline()
	local length = self:_current_spline_subdivision().length
	local num = self._t + arg_35_1 / length

	if not (not (num >= 1) or self._current_spline_index ~= #self._splines or self._current_subdivision_index ~= #_current_spline.subdivisions) then
		self._t = 1

		local num_2 = arg_35_1 - (num - 1) * length

		self._current_spline_curve_distance = self._current_spline_curve_distance + num_2

		return "end"
	elseif num > 1 then
		self._current_subdivision_index = self._current_subdivision_index + 1

		if self._current_subdivision_index > #_current_spline.subdivisions then
			self._current_subdivision_index = 1
			self._current_spline_index = self._current_spline_index + 1
		end

		self._t = 0

		local num_3 = (num - 1) * length
		local num_4 = arg_35_1 - num_3

		self._current_spline_curve_distance = self._current_spline_curve_distance + num_4

		return self:move(num_3)
	elseif not (not (num <= 0) or self._current_spline_index ~= 1 or self._current_subdivision_index ~= 1) then
		self._t = 0
		self._current_spline_curve_distance = 0

		return "start"
	elseif num < 0 then
		self._current_subdivision_index = self._current_subdivision_index - 1

		if self._current_subdivision_index == 0 then
			self._current_spline_index = self._current_spline_index - 1
			self._current_subdivision_index = #self:_current_spline().subdivisions
		end

		self._t = 1

		local num_5 = num * length
		local num_6 = arg_35_1 - num_5

		self._current_spline_curve_distance = self._current_spline_curve_distance + num_6

		return self:move(num_5)
	else
		self._t = num
		self._current_spline_curve_distance = self._current_spline_curve_distance + arg_35_1

		return "moving"
	end
end

SplineMovementHermiteInterpolatedMetered.reset_to_start = function (self)
	-- function 36
	self._current_spline_index = 1
	self._current_subdivision_index = 1
	self._t = 0
	self._current_spline_curve_distance = 0
end

SplineMovementHermiteInterpolatedMetered.reset_to_end = function (self)
	-- function 37
	local _current_spline = self:_current_spline()

	self._current_spline_index = #self._splines
	self._current_subdivision_index = #_current_spline.subdivisions
	self._t = 1

	local num = 1
	local num_2 = 1
	local num_3 = 0
	local _current_spline_index = self._current_spline_index
	local _current_subdivision_index = self._current_subdivision_index
	local _t = self._t

	self._current_spline_curve_distance = self:distance(num, num_2, num_3, _current_spline_index, _current_subdivision_index, _t)
end

SplineMovementHermiteInterpolatedMetered.set_spline_index = function (self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	self._current_spline_index = arg_38_1
	self._current_subdivision_index = arg_38_2
	self._t = arg_38_3

	local num = 1
	local num_2 = 1
	local num_3 = 0

	self._current_spline_curve_distance = self:distance(num, num_2, num_3, arg_38_1, arg_38_2, arg_38_3)
end

SplineMovementHermiteInterpolatedMetered.current_spline_index = function (self)
	-- function 39
	return self._current_spline_index
end

SplineMovementHermiteInterpolatedMetered.current_subdivision_index = function (self)
	-- function 40
	return self._current_subdivision_index
end

SplineMovementHermiteInterpolatedMetered.current_t = function (self)
	-- function 41
	return self._t
end

SplineMovementHermiteInterpolatedMetered.current_spline_curve_distance = function (self)
	-- function 42
	return self._current_spline_curve_distance
end
