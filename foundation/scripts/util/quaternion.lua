-- chunkname: @foundation/scripts/util/quaternion.lua

function Quaternion.yaw(arg_1_0)
	local var_1_0, var_1_1, var_1_2, var_1_3 = Quaternion.to_elements(arg_1_0)

	return math.atan2(2 * (var_1_0 * var_1_1 + var_1_3 * var_1_2), var_1_3 * var_1_3 + var_1_0 * var_1_0 - var_1_1 * var_1_1 - var_1_2 * var_1_2)
end

function Quaternion.pitch(arg_2_0)
	local var_2_0, var_2_1, var_2_2, var_2_3 = Quaternion.to_elements(arg_2_0)

	return math.atan2(2 * (var_2_1 * var_2_2 + var_2_3 * var_2_0), var_2_3 * var_2_3 - var_2_0 * var_2_0 - var_2_1 * var_2_1 + var_2_2 * var_2_2)
end

function Quaternion.roll(arg_3_0)
	local var_3_0, var_3_1, var_3_2, var_3_3 = Quaternion.to_elements(arg_3_0)

	return math.asin(-2 * (var_3_0 * var_3_2 - var_3_3 * var_3_1))
end

function Quaternion.flat_no_roll(arg_4_0)
	return Quaternion.axis_angle(Vector3.up(), Quaternion.yaw(arg_4_0))
end
