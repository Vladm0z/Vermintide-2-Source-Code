-- chunkname: @scripts/managers/camera/cameras/offset_camera.lua

require("scripts/managers/camera/cameras/base_camera")

OffsetCamera = class(OffsetCamera, BaseCamera)

OffsetCamera.init = function (self, arg_1_1)
	-- function 1
	BaseCamera.init(self, arg_1_1)

	self._offset_position = Vector3(0, 0, 0)
end

OffsetCamera.parse_parameters = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
end

OffsetCamera.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local offset_position = arg_3_4.offset_position

	offset_position = offset_position or Vector3(0, 0, 0)

	local num = offset_position.x * Quaternion.right(arg_3_3)
	local num_2 = offset_position.y * Quaternion.forward(arg_3_3)
	local num_3 = offset_position.z * Quaternion.up(arg_3_3)

	arg_3_2 = arg_3_2 + num + num_2 + num_3

	BaseCamera.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end
