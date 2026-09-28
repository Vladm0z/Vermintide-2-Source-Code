-- chunkname: @scripts/managers/camera/cameras/object_link_camera.lua

require("scripts/managers/camera/cameras/base_camera")

ObjectLinkCamera = class(ObjectLinkCamera, BaseCamera)

ObjectLinkCamera.init = function (self, root_node)
	-- function 1
	BaseCamera.init(self, root_node)

	self._curve_params = {}
end

ObjectLinkCamera.parse_parameters = function (self, camera_settings, parent_node)
	-- function 2
	ObjectLinkCamera.super.parse_parameters(self, camera_settings, parent_node)

	self._object_name = camera_settings.root_object_name
	self._curve_data_parameter_name = camera_settings.animation_curve_parameter_name
end

ObjectLinkCamera.update = function (self, dt, position, rotation, data)
	-- function 3
	local new_position, new_rotation
	local root_unit = self._root_unit
	local root_object = Unit.node(root_unit, self._object_name)

	new_position = Unit.world_position(root_unit, root_object)
	new_rotation = Unit.world_rotation(root_unit, root_object)

	local curve_data = data[self._curve_data_parameter_name]

	table.clear(self._curve_params)

	if curve_data then
		local _environment_params = self._environment_params

		_environment_params = not not _environment_params or not not {}
		self._environment_params = _environment_params

		table.clear(self._environment_params)

		for _, param in ipairs(curve_data.camera_parameters) do
			local param_value = AnimationCurves.sample(curve_data.resource, self._object_name, param, curve_data.t, curve_data.use_step_sampling)

			self._curve_params[param] = param_value
		end

		for _, param in pairs(curve_data.environment_parameters) do
			self._environment_params[param] = AnimationCurves.sample(curve_data.resource, self._object_name, param, curve_data.t, curve_data.use_step_sampling)
		end
	else
		self._environment_params = nil
	end

	BaseCamera.update(self, dt, new_position, new_rotation, data)
end

ObjectLinkCamera.near_range = function (self)
	-- function 4
	local near_clip = self._curve_params.near_clip

	return not not near_clip or not not ObjectLinkCamera.super.near_range(self)
end

ObjectLinkCamera.far_range = function (self)
	-- function 5
	local far_clip = self._curve_params.far_clip

	return not not far_clip or not not ObjectLinkCamera.super.far_range(self)
end

ObjectLinkCamera.fade_to_black = function (self)
	-- function 6
	local fade_to_black = self._curve_params.fade_to_black

	fade_to_black = not not fade_to_black or not not ObjectLinkCamera.super.fade_to_black(self)

	return fade_to_black
end

ObjectLinkCamera.vertical_fov = function (self)
	-- function 7
	local yfov = self._curve_params.yfov
	local num

	if yfov then
		num = yfov * (math.pi / 180)

		if not num then
			-- Nothing
		end
	end

	num = ObjectLinkCamera.super.vertical_fov(self)

	::label_7_0::

	return num
end
