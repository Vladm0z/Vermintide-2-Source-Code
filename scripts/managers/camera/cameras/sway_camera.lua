-- chunkname: @scripts/managers/camera/cameras/sway_camera.lua

require("scripts/managers/camera/cameras/base_camera")

SwayCamera = class(SwayCamera, BaseCamera)

SwayCamera.init = function (arg_1_0, arg_1_1)
	-- function 1
	BaseCamera.init(arg_1_0, arg_1_1)
end

SwayCamera.parse_parameters = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
end

SwayCamera.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local unbox = arg_3_4.final_rotation:unbox()
	local multiply = Quaternion.multiply(arg_3_3, unbox)

	BaseCamera.update(arg_3_0, arg_3_1, arg_3_2, multiply, arg_3_4)
end
