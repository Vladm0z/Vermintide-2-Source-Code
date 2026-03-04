-- chunkname: @scripts/managers/camera/cameras/scalable_transform_camera.lua

require("scripts/managers/camera/cameras/transform_camera")

ScalableTransformCamera = class(ScalableTransformCamera, TransformCamera)

ScalableTransformCamera.parse_parameters = function (arg_1_0, arg_1_1, arg_1_2)
	ScalableTransformCamera.super.parse_parameters(arg_1_0, arg_1_1, arg_1_2)

	arg_1_0._scale_function = arg_1_1.scale_function
	arg_1_0._scale_variable = arg_1_1.scale_variable
	arg_1_0._max_fov = arg_1_1.vertical_fov and arg_1_1.vertical_fov * math.pi / 180
end

ScalableTransformCamera.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_4[arg_2_0._scale_variable] or 1
	local var_2_1 = arg_2_0._scale_function(var_2_0)
	local var_2_2 = arg_2_0._offset_position
	local var_2_3 = var_2_2.x * var_2_1 * Quaternion.right(arg_2_3)
	local var_2_4 = var_2_2.y * var_2_1 * Quaternion.forward(arg_2_3)
	local var_2_5 = var_2_2.z * var_2_1 * Quaternion.up(arg_2_3)

	arg_2_2 = arg_2_2 + var_2_3 + var_2_4 + var_2_5

	local var_2_6 = arg_2_0._max_fov

	if var_2_6 then
		local var_2_7 = arg_2_0._parent_node:vertical_fov()

		arg_2_0._vertical_fov = var_2_7 + (var_2_6 - var_2_7) * var_2_1
		arg_2_0._settings_vertical_fov = arg_2_0._vertical_fov
	end

	ScalableTransformCamera.super.super.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
end
