-- chunkname: @scripts/managers/camera/cameras/offset_camera.lua

require("scripts/managers/camera/cameras/base_camera")

OffsetCamera = class(OffsetCamera, BaseCamera)

function OffsetCamera.init(arg_1_0, arg_1_1)
	BaseCamera.init(arg_1_0, arg_1_1)

	arg_1_0._offset_position = Vector3(0, 0, 0)
end

function OffsetCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
end

function OffsetCamera.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_4.offset_position or Vector3(0, 0, 0)
	local var_3_1 = var_3_0.x * Quaternion.right(arg_3_3)
	local var_3_2 = var_3_0.y * Quaternion.forward(arg_3_3)
	local var_3_3 = var_3_0.z * Quaternion.up(arg_3_3)

	arg_3_2 = arg_3_2 + var_3_1 + var_3_2 + var_3_3

	BaseCamera.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end
