-- chunkname: @scripts/managers/camera/cameras/aim_camera.lua

require("scripts/managers/camera/cameras/base_camera")

AimCamera = class(AimCamera, BaseCamera)

AimCamera.init = function (self, arg_1_1)
	-- function 1
	BaseCamera.init(self, arg_1_1)

	self._root_node = arg_1_1
end

AimCamera.parse_parameters = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
end

AimCamera.set_root_unit = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	BaseCamera.set_root_unit(arg_3_0, arg_3_1, arg_3_2)
end

AimCamera.set_root_rotation = function (arg_4_0, arg_4_1)
	-- function 4
	BaseCamera.set_root_rotation(arg_4_0, arg_4_1)
end

AimCamera.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local _root_node = self._root_node
	local aim_pitch = _root_node:aim_pitch()
	local aim_yaw = _root_node:aim_yaw()
	local var_5_3 = Quaternion(Vector3(1, 0, 0), aim_pitch)
	local var_5_4 = Quaternion(Vector3(0, 0, 1), aim_yaw - math.pi * 0.5)
	local multiply = Quaternion.multiply(var_5_4, var_5_3)

	BaseCamera.update(self, arg_5_1, arg_5_2, multiply, arg_5_4)
end
