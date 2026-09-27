-- chunkname: @scripts/managers/camera/cameras/scalable_transform_camera.lua

require("scripts/managers/camera/cameras/transform_camera")

ScalableTransformCamera = class(ScalableTransformCamera, TransformCamera)

ScalableTransformCamera.parse_parameters = function (self, arg_1_1, arg_1_2)
	-- function 1
	ScalableTransformCamera.super.parse_parameters(self, arg_1_1, arg_1_2)

	self._scale_function = arg_1_1.scale_function
	self._scale_variable = arg_1_1.scale_variable

	local vertical_fov = arg_1_1.vertical_fov

	vertical_fov = not vertical_fov and arg_1_1.vertical_fov * math.pi / 180
	self._max_fov = vertical_fov
end

ScalableTransformCamera.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local var_2_0 = arg_2_4[self._scale_variable]

	var_2_0 = var_2_0 or 1

	local _scale_function = self._scale_function(var_2_0)
	local _offset_position = self._offset_position
	local num = _offset_position.x * _scale_function * Quaternion.right(arg_2_3)
	local num_2 = _offset_position.y * _scale_function * Quaternion.forward(arg_2_3)
	local num_3 = _offset_position.z * _scale_function * Quaternion.up(arg_2_3)

	arg_2_2 = arg_2_2 + num + num_2 + num_3

	local _max_fov = self._max_fov

	if not _max_fov then
		local vertical_fov = self._parent_node:vertical_fov()

		self._vertical_fov = vertical_fov + (_max_fov - vertical_fov) * _scale_function
		self._settings_vertical_fov = self._vertical_fov
	end

	ScalableTransformCamera.super.super.update(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
end
