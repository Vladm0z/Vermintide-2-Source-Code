-- chunkname: @scripts/managers/camera/cameras/sway_camera.lua

require("scripts/managers/camera/cameras/base_camera")

SwayCamera = class(SwayCamera, BaseCamera)

function SwayCamera.init(arg_1_0, arg_1_1)
	BaseCamera.init(arg_1_0, arg_1_1)
end

function SwayCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
end

function SwayCamera.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_4.final_rotation:unbox()
	local var_3_1 = Quaternion.multiply(arg_3_3, var_3_0)

	BaseCamera.update(arg_3_0, arg_3_1, arg_3_2, var_3_1, arg_3_4)
end
