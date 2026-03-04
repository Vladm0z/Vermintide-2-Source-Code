-- chunkname: @scripts/managers/camera/cameras/object_link_camera.lua

require("scripts/managers/camera/cameras/base_camera")

ObjectLinkCamera = class(ObjectLinkCamera, BaseCamera)

ObjectLinkCamera.init = function (arg_1_0, arg_1_1)
	BaseCamera.init(arg_1_0, arg_1_1)

	arg_1_0._curve_params = {}
end

ObjectLinkCamera.parse_parameters = function (arg_2_0, arg_2_1, arg_2_2)
	ObjectLinkCamera.super.parse_parameters(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0._object_name = arg_2_1.root_object_name
	arg_2_0._curve_data_parameter_name = arg_2_1.animation_curve_parameter_name
end

ObjectLinkCamera.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0
	local var_3_1
	local var_3_2 = arg_3_0._root_unit
	local var_3_3 = Unit.node(var_3_2, arg_3_0._object_name)
	local var_3_4 = Unit.world_position(var_3_2, var_3_3)
	local var_3_5 = Unit.world_rotation(var_3_2, var_3_3)
	local var_3_6 = arg_3_4[arg_3_0._curve_data_parameter_name]

	table.clear(arg_3_0._curve_params)

	if var_3_6 then
		arg_3_0._environment_params = arg_3_0._environment_params or {}

		table.clear(arg_3_0._environment_params)

		for iter_3_0, iter_3_1 in ipairs(var_3_6.camera_parameters) do
			local var_3_7 = AnimationCurves.sample(var_3_6.resource, arg_3_0._object_name, iter_3_1, var_3_6.t, var_3_6.use_step_sampling)

			arg_3_0._curve_params[iter_3_1] = var_3_7
		end

		for iter_3_2, iter_3_3 in pairs(var_3_6.environment_parameters) do
			arg_3_0._environment_params[iter_3_3] = AnimationCurves.sample(var_3_6.resource, arg_3_0._object_name, iter_3_3, var_3_6.t, var_3_6.use_step_sampling)
		end
	else
		arg_3_0._environment_params = nil
	end

	BaseCamera.update(arg_3_0, arg_3_1, var_3_4, var_3_5, arg_3_4)
end

ObjectLinkCamera.near_range = function (arg_4_0)
	return arg_4_0._curve_params.near_clip or ObjectLinkCamera.super.near_range(arg_4_0)
end

ObjectLinkCamera.far_range = function (arg_5_0)
	return arg_5_0._curve_params.far_clip or ObjectLinkCamera.super.far_range(arg_5_0)
end

ObjectLinkCamera.fade_to_black = function (arg_6_0)
	return arg_6_0._curve_params.fade_to_black or ObjectLinkCamera.super.fade_to_black(arg_6_0)
end

ObjectLinkCamera.vertical_fov = function (arg_7_0)
	local var_7_0 = arg_7_0._curve_params.yfov

	return var_7_0 and var_7_0 * (math.pi / 180) or ObjectLinkCamera.super.vertical_fov(arg_7_0)
end
