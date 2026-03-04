-- chunkname: @scripts/managers/camera/transitions/camera_transition_generic.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionGeneric = class(CameraTransitionGeneric, CameraTransitionBase)

CameraTransitionGeneric.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	CameraTransitionBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)

	arg_1_0._transition_func = arg_1_5.transition_func
	arg_1_0._parameter = arg_1_5.parameter
end

CameraTransitionGeneric.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	CameraTransitionBase.update(arg_2_0, arg_2_1, arg_2_3)

	local var_2_0 = arg_2_0._node_2[arg_2_0._parameter](arg_2_0._node_2)
	local var_2_1 = arg_2_0._duration
	local var_2_2 = arg_2_0._speed
	local var_2_3
	local var_2_4

	if var_2_2 and var_2_1 then
		assert(false, "CameraTransitionGeneric:update() transition has defined both speed and duration, only one can be allowed at once")
	elseif var_2_2 then
		local var_2_5 = var_2_0 - arg_2_2
		local var_2_6 = arg_2_0._time * var_2_2

		if var_2_5 < var_2_6 then
			var_2_3 = var_2_0
			var_2_4 = true
		else
			var_2_3 = arg_2_2 + var_2_6
		end
	elseif var_2_1 then
		local var_2_7 = arg_2_0._time / var_2_1
		local var_2_8 = math.min(var_2_7, 1)

		if arg_2_0._transition_func then
			var_2_8 = arg_2_0._transition_func(var_2_8)
		end

		var_2_3 = arg_2_2 * (1 - var_2_8) + var_2_0 * var_2_8
		var_2_4 = var_2_1 < arg_2_0._time
	end

	return var_2_3, var_2_4
end
