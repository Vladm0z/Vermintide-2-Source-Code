-- chunkname: @scripts/managers/camera/transitions/camera_transition_fov_linear.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionFOVLinear = class(CameraTransitionFOVLinear, CameraTransitionBase)

CameraTransitionFOVLinear.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	CameraTransitionBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
end

CameraTransitionFOVLinear.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	CameraTransitionBase.update(arg_2_0, arg_2_1, arg_2_3)

	local var_2_0 = arg_2_2
	local var_2_1 = arg_2_0._node_2:vertical_fov()
	local var_2_2 = arg_2_0._duration
	local var_2_3 = arg_2_0._speed
	local var_2_4 = var_2_1 - var_2_0
	local var_2_5

	if var_2_2 then
		var_2_5 = var_2_4 / var_2_2
	else
		var_2_5 = var_2_3
	end

	local var_2_6 = var_2_0 + arg_2_0._time * var_2_5
	local var_2_7 = var_2_0 < var_2_1 and var_2_1 <= var_2_6 or var_2_1 < var_2_0 and var_2_6 <= var_2_1 or var_2_0 == var_2_1

	if var_2_7 then
		var_2_6 = var_2_1
	end

	return var_2_6, var_2_7
end
