-- chunkname: @scripts/managers/camera/cameras/aim_camera.lua

require("scripts/managers/camera/cameras/base_camera")

AimCamera = class(AimCamera, BaseCamera)

AimCamera.init = function (self, root_node)
	-- function 1
	BaseCamera.init(self, root_node)

	self._root_node = root_node
end

AimCamera.parse_parameters = function (self, camera_settings, parent_node)
	-- function 2
	BaseCamera.parse_parameters(self, camera_settings, parent_node)
end

AimCamera.set_root_unit = function (self, unit, object)
	-- function 3
	BaseCamera.set_root_unit(self, unit, object)
end

AimCamera.set_root_rotation = function (self, rotation)
	-- function 4
	BaseCamera.set_root_rotation(self, rotation)
end

AimCamera.update = function (self, dt, position, rotation, data)
	-- function 5
	local root_node = self._root_node
	local aim_pitch = root_node:aim_pitch()
	local aim_yaw = root_node:aim_yaw()
	local rotation_pitch = Quaternion(Vector3(1, 0, 0), aim_pitch)
	local rotation_yaw = Quaternion(Vector3(0, 0, 1), aim_yaw - math.pi * 0.5)
	local new_rotation = Quaternion.multiply(rotation_yaw, rotation_pitch)

	BaseCamera.update(self, dt, position, new_rotation, data)
end
