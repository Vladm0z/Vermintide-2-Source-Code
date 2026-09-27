-- chunkname: @scripts/managers/camera/cameras/object_link_camera.lua

require("scripts/managers/camera/cameras/base_camera")

ObjectLinkCamera = class(ObjectLinkCamera, BaseCamera)

ObjectLinkCamera.init = function (self, arg_1_1)
	-- function 1
	BaseCamera.init(self, arg_1_1)

	self._curve_params = {}
end

ObjectLinkCamera.parse_parameters = function (self, arg_2_1, arg_2_2)
	-- function 2
	ObjectLinkCamera.super.parse_parameters(self, arg_2_1, arg_2_2)

	self._object_name = arg_2_1.root_object_name
	self._curve_data_parameter_name = arg_2_1.animation_curve_parameter_name
end

ObjectLinkCamera.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0
	local var_3_1
	local _root_unit = self._root_unit
	local node = Unit.node(_root_unit, self._object_name)
	local world_position = Unit.world_position(_root_unit, node)
	local world_rotation = Unit.world_rotation(_root_unit, node)
	local var_3_6 = arg_3_4[self._curve_data_parameter_name]

	table.clear(self._curve_params)

	if not var_3_6 then
		local _environment_params = self._environment_params

		_environment_params = _environment_params or {}
		self._environment_params = _environment_params

		table.clear(self._environment_params)

		for i, v in ipairs(var_3_6.camera_parameters) do
			local sample = AnimationCurves.sample(var_3_6.resource, self._object_name, v, var_3_6.t, var_3_6.use_step_sampling)

			self._curve_params[v] = sample
		end

		for k, v_2 in pairs(var_3_6.environment_parameters) do
			self._environment_params[v_2] = AnimationCurves.sample(var_3_6.resource, self._object_name, v_2, var_3_6.t, var_3_6.use_step_sampling)
		end
	else
		self._environment_params = nil
	end

	BaseCamera.update(self, arg_3_1, world_position, world_rotation, arg_3_4)
end

ObjectLinkCamera.near_range = function (self)
	-- function 4
	return self._curve_params.near_clip or ObjectLinkCamera.super.near_range(self)
end

ObjectLinkCamera.far_range = function (self)
	-- function 5
	return self._curve_params.far_clip or ObjectLinkCamera.super.far_range(self)
end

ObjectLinkCamera.fade_to_black = function (self)
	-- function 6
	local fade_to_black = self._curve_params.fade_to_black

	fade_to_black = fade_to_black or ObjectLinkCamera.super.fade_to_black(self)

	return fade_to_black
end

ObjectLinkCamera.vertical_fov = function (self)
	-- function 7
	local yfov = self._curve_params.yfov
	local num

	if not yfov then
		num = yfov * (math.pi / 180)

		if not num then
			-- Nothing
		end
	end

	num = ObjectLinkCamera.super.vertical_fov(self)

	::label_7_0::

	return num
end
