-- chunkname: @scripts/managers/camera/cameras/aim_camera.lua

require("scripts/managers/camera/cameras/base_camera")

AimCamera = class(AimCamera, BaseCamera)

AimCamera.init = function (arg_1_0, arg_1_1)
	BaseCamera.init(arg_1_0, arg_1_1)

	arg_1_0._root_node = arg_1_1
end

AimCamera.parse_parameters = function (arg_2_0, arg_2_1, arg_2_2)
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
end

AimCamera.set_root_unit = function (arg_3_0, arg_3_1, arg_3_2)
	BaseCamera.set_root_unit(arg_3_0, arg_3_1, arg_3_2)
end

AimCamera.set_root_rotation = function (arg_4_0, arg_4_1)
	BaseCamera.set_root_rotation(arg_4_0, arg_4_1)
end

AimCamera.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0._root_node
	local var_5_1 = var_5_0:aim_pitch()
	local var_5_2 = var_5_0:aim_yaw()
	local var_5_3 = Quaternion(Vector3(1, 0, 0), var_5_1)
	local var_5_4 = Quaternion(Vector3(0, 0, 1), var_5_2 - math.pi * 0.5)
	local var_5_5 = Quaternion.multiply(var_5_4, var_5_3)

	BaseCamera.update(arg_5_0, arg_5_1, arg_5_2, var_5_5, arg_5_4)
end
