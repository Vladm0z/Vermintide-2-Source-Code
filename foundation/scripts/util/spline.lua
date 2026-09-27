-- chunkname: @foundation/scripts/util/spline.lua

Spline = class(Spline)

Spline.calc_point = function (self, arg_1_1)
	-- function 1
	local num = arg_1_1 * arg_1_1
	local num_2 = num * arg_1_1
	local num_3 = num_2 + num_2
	local num_4 = num + num
	local num_5 = num_4 + num
	local num_6 = num_3 - num_5 + 1
	local num_7 = num_5 - num_3
	local num_8 = num_2 - num_4 + arg_1_1
	local num_9 = num_2 - num

	return Vector3.from_table(self._P1) * num_6 + Vector3.from_table(self._P2) * num_7 + Vector3.from_table(self._T1) * num_8 + Vector3.from_table(self._T2) * num_9
end

Spline.calc_tangent = function (self, arg_2_1)
	-- function 2
	local num = arg_2_1 * arg_2_1
	local num_2 = 6 * num - 6 * arg_2_1
	local num_3 = 6 * arg_2_1 - 6 * num
	local num_4 = 3 * num - 4 * arg_2_1 + 1
	local num_5 = 3 * num - 2 * arg_2_1

	return Vector3.from_table(self._P1) * num_2 + Vector3.from_table(self._P2) * num_3 + Vector3.from_table(self._T1) * num_4 + Vector3.from_table(self._T2) * num_5
end

Spline.set_points = function (self, arg_3_1)
	-- function 3
	local from_table = Vector3.from_table(arg_3_1[1])
	local from_table_2 = Vector3.from_table(arg_3_1[2])
	local from_table_3 = Vector3.from_table(arg_3_1[3])
	local from_table_4 = Vector3.from_table(arg_3_1[4])
	local length = Vector3.length(from_table_2 - from_table_3)
	local num = Vector3.normalize(from_table_3 - from_table) * length

	self._T1 = Vector3.as_table(num)

	local num_2 = Vector3.normalize(from_table_4 - from_table_2) * length

	self._T2 = Vector3.as_table(num_2)
	self._P1 = table.clone(Vector3.as_table(arg_3_1[2]))
	self._P2 = table.clone(Vector3.as_table(arg_3_1[3]))
end

Spline.draw = function (self, arg_4_1, arg_4_2)
	-- function 4
	arg_4_2 = arg_4_2 or 20

	local num = 1 / arg_4_2
	local num_2 = 0
	local calc_point = self:calc_point(num_2)

	while num_2 < 1 do
		num_2 = num_2 + num

		local calc_point_2 = self:calc_point(num_2)

		arg_4_1:line(calc_point, calc_point_2)

		calc_point = calc_point_2
	end
end

Spline.length = function (self, arg_5_1)
	-- function 5
	local num = 0
	local from_table = Vector3.from_table(self._P1)

	for i = 1, arg_5_1 do
		local calc_point = self:calc_point(i / arg_5_1)

		num = num + Vector3.length(calc_point - from_table)
		from_table = calc_point
	end

	return num
end

Spline.tangent = function (self, arg_6_1, arg_6_2)
	-- function 6
	arg_6_2 = arg_6_2 or 0.01

	local max = math.max(arg_6_1 - arg_6_2, 0)
	local min = math.min(arg_6_1 + arg_6_2, 1)
	local calc_point = self:calc_point(max)
	local calc_point_2 = self:calc_point(min)

	return Vector3.normalize(calc_point_2 - calc_point)
end

Spline.set_points_manual_tangents = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local as_table

	if not arg_7_1 then
		as_table = Vector3.as_table(arg_7_1)

		if not as_table then
			-- Nothing
		end
	end

	as_table = self._T1

	::label_7_0::

	self._T1 = as_table

	local as_table_2

	if not arg_7_2 then
		as_table_2 = Vector3.as_table(arg_7_2)

		if not as_table_2 then
			-- Nothing
		end
	end

	as_table_2 = self._T2

	::label_7_1::

	self._T2 = as_table_2

	local as_table_3

	if not arg_7_3 then
		as_table_3 = Vector3.as_table(arg_7_3)

		if not as_table_3 then
			-- Nothing
		end
	end

	as_table_3 = self._P1

	::label_7_2::

	self._P1 = as_table_3

	local as_table_4

	if not arg_7_4 then
		as_table_4 = Vector3.as_table(arg_7_4)

		if not as_table_4 then
			-- Nothing
		end
	end

	as_table_4 = self._P2

	::label_7_3::

	self._P2 = as_table_4
end

Spline.set_points_with_rotation_tangents = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self._P1 = table.clone(Vector3.as_table(arg_8_1[1]))
	self._P2 = table.clone(Vector3.as_table(arg_8_1[2]))

	local length = Vector3.length(Vector3.from_table(arg_8_1[1]) - Vector3.from_table(arg_8_1[2]))

	self._T1 = Vector3.as_table(Vector3.from_table(arg_8_2) * length)
	self._T2 = Vector3.as_table(Vector3.from_table(arg_8_3) * length)
end

Spline.set_points_manual_start_tangent = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local length = Vector3.length(arg_9_2 - arg_9_3)

	self._T1 = Vector3.as_table(arg_9_1 * length)
	self._T2 = Vector3.as_table(Vector3.normalize(arg_9_4 - arg_9_2) * length)
	self._P1 = Vector3.as_table(arg_9_2)
	self._P2 = Vector3.as_table(arg_9_3)
end

Spline.set_points_manual_end_tangent = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local length = Vector3.length(arg_10_2 - arg_10_3)

	self._T1 = Vector3.as_table(Vector3.normalize(arg_10_3 - arg_10_1) * length)
	self._T2 = Vector3.as_table(arg_10_4 * length)
	self._P1 = Vector3.as_table(arg_10_2)
	self._P2 = Vector3.as_table(arg_10_3)
end

Spline.debug_print = function (arg_11_0)
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
