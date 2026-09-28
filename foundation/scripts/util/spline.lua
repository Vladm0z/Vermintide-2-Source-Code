-- chunkname: @foundation/scripts/util/spline.lua

Spline = class(Spline)

Spline.calc_point = function (self, t)
	-- function 1
	local t2 = t * t
	local t3 = t2 * t
	local two_t3 = t3 + t3
	local two_t2 = t2 + t2
	local three_t2 = two_t2 + t2
	local h1 = two_t3 - three_t2 + 1
	local h2 = three_t2 - two_t3
	local h3 = t3 - two_t2 + t
	local h4 = t3 - t2
	local res = Vector3.from_table(self._P1) * h1

	res = res + Vector3.from_table(self._P2) * h2
	res = res + Vector3.from_table(self._T1) * h3
	res = res + Vector3.from_table(self._T2) * h4

	return res
end

Spline.calc_tangent = function (self, t)
	-- function 2
	local t2 = t * t
	local dh1 = 6 * t2 - 6 * t
	local dh2 = 6 * t - 6 * t2
	local dh3 = 3 * t2 - 4 * t + 1
	local dh4 = 3 * t2 - 2 * t
	local res = Vector3.from_table(self._P1) * dh1 + Vector3.from_table(self._P2) * dh2 + Vector3.from_table(self._T1) * dh3 + Vector3.from_table(self._T2) * dh4

	return res
end

Spline.set_points = function (self, points)
	-- function 3
	local p1 = Vector3.from_table(points[1])
	local p2 = Vector3.from_table(points[2])
	local p3 = Vector3.from_table(points[3])
	local p4 = Vector3.from_table(points[4])
	local length = Vector3.length(p2 - p3)
	local temp = Vector3.normalize(p3 - p1)

	temp = temp * length
	self._T1 = Vector3.as_table(temp)
	temp = Vector3.normalize(p4 - p2)
	temp = temp * length
	self._T2 = Vector3.as_table(temp)
	self._P1 = table.clone(Vector3.as_table(points[2]))
	self._P2 = table.clone(Vector3.as_table(points[3]))
end

Spline.draw = function (self, drawer, segments)
	-- function 4
	segments = not not segments or not not 20

	local segment_increment = 1 / segments
	local t = 0
	local point_a = self:calc_point(t)

	while t < 1 do
		t = t + segment_increment

		local point_b = self:calc_point(t)

		drawer:line(point_a, point_b)

		point_a = point_b
	end
end

Spline.length = function (self, segments)
	-- function 5
	local length = 0
	local last_point = Vector3.from_table(self._P1)

	for fraction = 1, segments do
		local point = self:calc_point(fraction / segments)

		length = length + Vector3.length(point - last_point)
		last_point = point
	end

	return length
end

Spline.tangent = function (self, t, segment_size)
	-- function 6
	segment_size = not not segment_size or not not 0.01

	local min_t = math.max(t - segment_size, 0)
	local max_t = math.min(t + segment_size, 1)
	local min_v = self:calc_point(min_t)
	local max_v = self:calc_point(max_t)

	return Vector3.normalize(max_v - min_v)
end

Spline.set_points_manual_tangents = function (self, t1, t2, p1, p2)
	-- function 7
	local as_table

	if t1 then
		as_table = Vector3.as_table(t1)

		if not as_table then
			-- Nothing
		end
	end

	as_table = self._T1

	::label_7_0::

	self._T1 = as_table

	local as_table_2

	if t2 then
		as_table_2 = Vector3.as_table(t2)

		if not as_table_2 then
			-- Nothing
		end
	end

	as_table_2 = self._T2

	::label_7_1::

	self._T2 = as_table_2

	local as_table_3

	if p1 then
		as_table_3 = Vector3.as_table(p1)

		if not as_table_3 then
			-- Nothing
		end
	end

	as_table_3 = self._P1

	::label_7_2::

	self._P1 = as_table_3

	local as_table_4

	if p2 then
		as_table_4 = Vector3.as_table(p2)

		if not as_table_4 then
			-- Nothing
		end
	end

	as_table_4 = self._P2

	::label_7_3::

	self._P2 = as_table_4
end

Spline.set_points_with_rotation_tangents = function (self, points, rotation_t1, rotation_t2)
	-- function 8
	self._P1 = table.clone(Vector3.as_table(points[1]))
	self._P2 = table.clone(Vector3.as_table(points[2]))

	local length = Vector3.length(Vector3.from_table(points[1]) - Vector3.from_table(points[2]))

	self._T1 = Vector3.as_table(Vector3.from_table(rotation_t1) * length)
	self._T2 = Vector3.as_table(Vector3.from_table(rotation_t2) * length)
end

Spline.set_points_manual_start_tangent = function (self, t1, p2, p3, p4)
	-- function 9
	local length = Vector3.length(p2 - p3)

	self._T1 = Vector3.as_table(t1 * length)
	self._T2 = Vector3.as_table(Vector3.normalize(p4 - p2) * length)
	self._P1 = Vector3.as_table(p2)
	self._P2 = Vector3.as_table(p3)
end

Spline.set_points_manual_end_tangent = function (self, p1, p2, p3, t2)
	-- function 10
	local length = Vector3.length(p2 - p3)

	self._T1 = Vector3.as_table(Vector3.normalize(p3 - p1) * length)
	self._T2 = Vector3.as_table(t2 * length)
	self._P1 = Vector3.as_table(p2)
	self._P2 = Vector3.as_table(p3)
end

Spline.debug_print = function (self)
	-- function 11
	return
end

Spline.p1 = function (self)
	-- function 12
	return self._P1
end

Spline.p2 = function (self)
	-- function 13
	return self._P2
end

Spline.t1 = function (self)
	-- function 14
	return self._T1
end

Spline.t2 = function (self)
	-- function 15
	return self._T2
end
