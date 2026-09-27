-- chunkname: @foundation/scripts/util/vector3.lua

Vector3.flat = function (self)
	-- function 1
	return Vector3(self[1], self[2], 0)
end

Vector3.step = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local num = arg_2_1 - arg_2_0

	if arg_2_2 > Vector3.length(num) then
		return arg_2_1, true
	else
		return arg_2_0 + Vector3.normalize(num) * arg_2_2, false
	end
end

Vector3.smoothstep = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local smoothstep = math.smoothstep(arg_3_0, 0, 1)

	return Vector3.lerp(arg_3_1, arg_3_2, smoothstep)
end

Vector3.flat_angle = function (self, arg_4_1)
	-- function 4
	local atan2 = math.atan2(self.y, self.x)

	return (math.atan2(arg_4_1.y, arg_4_1.x) - atan2 + math.pi) % (2 * math.pi) - math.pi
end

Vector3.clamp = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local to_elements, var_5_1, var_5_2 = Vector3.to_elements(arg_5_0)
	local clamp = math.clamp

	return Vector3(clamp(to_elements, arg_5_1, arg_5_2), clamp(var_5_1, arg_5_1, arg_5_2), clamp(var_5_2, arg_5_1, arg_5_2))
end

Vector3.clamp_3d = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local to_elements, var_6_1, var_6_2 = Vector3.to_elements(arg_6_0)

	return Vector3(math.clamp(to_elements, arg_6_1[1], arg_6_2[1]), math.clamp(var_6_1, arg_6_1[2], arg_6_2[2]), math.clamp(var_6_2, arg_6_1[3], arg_6_2[3]))
end

Vector3.invalid_vector = function ()
	-- function 7
	return Vector3(math.huge, math.huge, math.huge)
end

Vector3.copy = function (arg_8_0)
	-- function 8
	local to_elements, var_8_1, var_8_2 = Vector3.to_elements(arg_8_0)

	return Vector3(to_elements, var_8_1, var_8_2)
end

Vector3.deprecated_copy = function (self)
	-- function 9
	return Vector3(self[1], self[2], self[3])
end

Vector3.project_on_plane = function (arg_10_0, arg_10_1)
	-- function 10
	return arg_10_0 - Vector3.dot(arg_10_0, arg_10_1) * arg_10_1
end

Vector3.reflect = function (arg_11_0, arg_11_1)
	-- function 11
	return arg_11_0 - 2 * Vector3.dot(arg_11_0, arg_11_1) * arg_11_1
end

Vector3.rotate = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	arg_12_2 = arg_12_2 or Vector3.up()

	return Quaternion.rotate(Quaternion.axis_angle(arg_12_2, arg_12_1), arg_12_0)
end

local Vector3Aux = Vector3Aux

Vector3Aux = Vector3Aux or {}
Vector3Aux = Vector3Aux

Vector3Aux.box = function (self, arg_13_1)
	-- function 13
	self = self or {}
	self[1], self[2], self[3] = Vector3.to_elements(arg_13_1)

	return self
end

Vector3Aux.unbox = function (self)
	-- function 14
	return Vector3(self[1], self[2], self[3])
end
