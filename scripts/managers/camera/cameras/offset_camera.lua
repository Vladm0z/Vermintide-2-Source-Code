-- chunkname: @scripts/managers/camera/cameras/offset_camera.lua

require("scripts/managers/camera/cameras/base_camera")

OffsetCamera = class(OffsetCamera, BaseCamera)

OffsetCamera.init = function (self, root_node)
	-- function 1
	BaseCamera.init(self, root_node)

	self._offset_position = Vector3(0, 0, 0)
end

OffsetCamera.parse_parameters = function (self, camera_settings, parent_node)
	-- function 2
	BaseCamera.parse_parameters(self, camera_settings, parent_node)
end

OffsetCamera.update = function (self, dt, position, rotation, data)
	-- function 3
	local offset_position_2 = data.offset_position

	if not offset_position_2 then
		-- Nothing
	end

	offset_position_2 = Vector3(0, 0, 0)

	local offset_position = offset_position_2

	::label_3_0::

	local offset_x = offset_position.x * Quaternion.right(rotation)
	local offset_y = offset_position.y * Quaternion.forward(rotation)
	local offset_z = offset_position.z * Quaternion.up(rotation)

	position = position + offset_x + offset_y + offset_z

	BaseCamera.update(self, dt, position, rotation, data)
end
