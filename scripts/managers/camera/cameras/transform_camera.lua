-- chunkname: @scripts/managers/camera/cameras/transform_camera.lua

require("scripts/managers/camera/cameras/base_camera")

TransformCamera = class(TransformCamera, BaseCamera)

TransformCamera.init = function (self, arg_1_1)
	-- function 1
	BaseCamera.init(self, arg_1_1)

	self._offset_position = Vector3(0, 0, 0)
end

TransformCamera.parse_parameters = function (self, arg_2_1, arg_2_2)
	-- function 2
	BaseCamera.parse_parameters(self, arg_2_1, arg_2_2)

	if not arg_2_1.offset_position then
		self._offset_position = arg_2_1.offset_position
	end
end

TransformCamera.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local _offset_position = self._offset_position
	local num = _offset_position.x * Quaternion.right(arg_3_3)
	local num_2 = _offset_position.y * Quaternion.forward(arg_3_3)
	local num_3 = _offset_position.z * Quaternion.up(arg_3_3)

	arg_3_2 = arg_3_2 + num + num_2 + num_3

	BaseCamera.update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end
