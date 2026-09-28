-- chunkname: @scripts/managers/camera/cameras/scalable_transform_camera.lua

require("scripts/managers/camera/cameras/transform_camera")

ScalableTransformCamera = class(ScalableTransformCamera, TransformCamera)

ScalableTransformCamera.parse_parameters = function (self, camera_settings, parent_node)
	-- function 1
	ScalableTransformCamera.super.parse_parameters(self, camera_settings, parent_node)

	self._scale_function = camera_settings.scale_function
	self._scale_variable = camera_settings.scale_variable

	local vertical_fov = camera_settings.vertical_fov

	vertical_fov = not not vertical_fov and not not (camera_settings.vertical_fov * math.pi / 180)
	self._max_fov = vertical_fov
end

ScalableTransformCamera.update = function (self, dt, position, rotation, data)
	-- function 2
	local var_2_0 = data[self._scale_variable]

	if not var_2_0 then
		-- Nothing
	end

	var_2_0 = 1

	local scale = var_2_0

	::label_2_0::

	local scale_value = self._scale_function(scale)
	local offset_position = self._offset_position
	local offset_x = offset_position.x * scale_value * Quaternion.right(rotation)
	local offset_y = offset_position.y * scale_value * Quaternion.forward(rotation)
	local offset_z = offset_position.z * scale_value * Quaternion.up(rotation)

	position = position + offset_x + offset_y + offset_z

	local fov = self._max_fov

	if fov then
		local parent_fov = self._parent_node:vertical_fov()

		self._vertical_fov = parent_fov + (fov - parent_fov) * scale_value
		self._settings_vertical_fov = self._vertical_fov
	end

	ScalableTransformCamera.super.super.update(self, dt, position, rotation, data)
end
