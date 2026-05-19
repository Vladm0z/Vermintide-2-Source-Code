-- chunkname: @foundation/scripts/util/vector3.lua

function Vector3.flat(arg_1_0)
	return Vector3(arg_1_0[1], arg_1_0[2], 0)
end

function Vector3.step(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1 - arg_2_0

	if arg_2_2 > Vector3.length(var_2_0) then
		return arg_2_1, true
	else
		return arg_2_0 + Vector3.normalize(var_2_0) * arg_2_2, false
	end
end

function Vector3.smoothstep(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = math.smoothstep(arg_3_0, 0, 1)

	return Vector3.lerp(arg_3_1, arg_3_2, var_3_0)
end

function Vector3.flat_angle(arg_4_0, arg_4_1)
	local var_4_0 = math.atan2(arg_4_0.y, arg_4_0.x)

	return (math.atan2(arg_4_1.y, arg_4_1.x) - var_4_0 + math.pi) % (2 * math.pi) - math.pi
end

function Vector3.clamp(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0, var_5_1, var_5_2 = Vector3.to_elements(arg_5_0)
	local var_5_3 = math.clamp

	return Vector3(var_5_3(var_5_0, arg_5_1, arg_5_2), var_5_3(var_5_1, arg_5_1, arg_5_2), var_5_3(var_5_2, arg_5_1, arg_5_2))
end

function Vector3.clamp_3d(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0, var_6_1, var_6_2 = Vector3.to_elements(arg_6_0)

	return Vector3(math.clamp(var_6_0, arg_6_1[1], arg_6_2[1]), math.clamp(var_6_1, arg_6_1[2], arg_6_2[2]), math.clamp(var_6_2, arg_6_1[3], arg_6_2[3]))
end

function Vector3.invalid_vector()
	return Vector3(math.huge, math.huge, math.huge)
end

function Vector3.copy(arg_8_0)
	local var_8_0, var_8_1, var_8_2 = Vector3.to_elements(arg_8_0)

	return Vector3(var_8_0, var_8_1, var_8_2)
end

function Vector3.deprecated_copy(arg_9_0)
	return Vector3(arg_9_0[1], arg_9_0[2], arg_9_0[3])
end

function Vector3.project_on_plane(arg_10_0, arg_10_1)
	return arg_10_0 - Vector3.dot(arg_10_0, arg_10_1) * arg_10_1
end

function Vector3.reflect(arg_11_0, arg_11_1)
	return arg_11_0 - 2 * Vector3.dot(arg_11_0, arg_11_1) * arg_11_1
end

function Vector3.rotate(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = arg_12_2 or Vector3.up()

	return Quaternion.rotate(Quaternion.axis_angle(arg_12_2, arg_12_1), arg_12_0)
end

Vector3Aux = Vector3Aux or {}

function Vector3Aux.box(arg_13_0, arg_13_1)
	arg_13_0 = arg_13_0 or {}
	arg_13_0[1], arg_13_0[2], arg_13_0[3] = Vector3.to_elements(arg_13_1)

	return arg_13_0
end

function Vector3Aux.unbox(arg_14_0)
	return Vector3(arg_14_0[1], arg_14_0[2], arg_14_0[3])
end
