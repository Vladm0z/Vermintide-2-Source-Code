-- chunkname: @scripts/managers/camera/cameras/rotation_camera.lua

require("scripts/managers/camera/cameras/base_camera")

RotationCamera = class(RotationCamera, BaseCamera)

function RotationCamera.init(arg_1_0, ...)
	RotationCamera.super.init(arg_1_0, ...)

	arg_1_0._offset_pitch = 0
	arg_1_0._offset_yaw = 0
end

local var_0_0 = 0.005555555555555556

function RotationCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)

	if arg_2_1.offset_pitch then
		arg_2_0._offset_pitch = math.pi * arg_2_1.offset_pitch * var_0_0
	end

	if arg_2_1.offset_yaw then
		arg_2_0._offset_yaw = math.pi * arg_2_1.offset_yaw * var_0_0
	end
end

function RotationCamera.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Quaternion(Vector3.up(), arg_3_0._offset_yaw)
	local var_3_1 = Quaternion(Vector3.right(), arg_3_0._offset_pitch)
	local var_3_2 = Quaternion.multiply(Quaternion.multiply(arg_3_3, var_3_1), var_3_0)

	BaseCamera.update(arg_3_0, arg_3_1, arg_3_2, var_3_2, arg_3_4)
end
