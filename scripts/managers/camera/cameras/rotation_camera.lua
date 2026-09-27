-- chunkname: @scripts/managers/camera/cameras/rotation_camera.lua

require("scripts/managers/camera/cameras/base_camera")

RotationCamera = class(RotationCamera, BaseCamera)

RotationCamera.init = function (self, ...)
	-- function 1
	RotationCamera.super.init(self, ...)

	self._offset_pitch = 0
	self._offset_yaw = 0
end

local num = 0.005555555555555556

RotationCamera.parse_parameters = function (self, arg_2_1, arg_2_2)
	-- function 2
	BaseCamera.parse_parameters(self, arg_2_1, arg_2_2)

	if not arg_2_1.offset_pitch then
		self._offset_pitch = math.pi * arg_2_1.offset_pitch * num
	end

	if not arg_2_1.offset_yaw then
		self._offset_yaw = math.pi * arg_2_1.offset_yaw * num
	end
end

RotationCamera.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0 = Quaternion(Vector3.up(), self._offset_yaw)
	local var_3_1 = Quaternion(Vector3.right(), self._offset_pitch)
	local multiply = Quaternion.multiply(Quaternion.multiply(arg_3_3, var_3_1), var_3_0)

	BaseCamera.update(self, arg_3_1, arg_3_2, multiply, arg_3_4)
end
