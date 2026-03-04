-- chunkname: @scripts/managers/camera/transitions/camera_transition_position_linear.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionPositionLinear = class(CameraTransitionPositionLinear, CameraTransitionBase)

CameraTransitionPositionLinear.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	CameraTransitionBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)

	arg_1_0._freeze_node_1 = arg_1_5.freeze_start_node

	if arg_1_0._freeze_node_1 then
		local var_1_0 = arg_1_1:position()

		arg_1_0._node_1_pos_table = Vector3Box(var_1_0)
	end

	arg_1_0._transition_func = arg_1_5.transition_func
end

CameraTransitionPositionLinear.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	CameraTransitionBase.update(arg_2_0, arg_2_1, arg_2_3)

	local var_2_0 = arg_2_0._freeze_node_1 and arg_2_0._node_1_pos_table:unbox() or arg_2_2
	local var_2_1 = arg_2_0._node_2:position()
	local var_2_2 = arg_2_0._duration
	local var_2_3 = arg_2_0._speed
	local var_2_4 = arg_2_0._time
	local var_2_5
	local var_2_6

	if var_2_3 and var_2_2 then
		assert(false, "CameraTransitionPositionLinear:update() transition has defined both speed and duration, only one can be allowed at once")
	elseif var_2_3 then
		local var_2_7 = var_2_1 - var_2_0
		local var_2_8 = Vector3.length(var_2_7)
		local var_2_9 = var_2_4 * var_2_3

		if var_2_8 <= var_2_9 then
			var_2_5 = var_2_1
			var_2_6 = true
		else
			var_2_5 = var_2_0 + Vector3.normalize(var_2_7) * var_2_9
		end
	elseif var_2_2 then
		assert(var_2_2 > 0, "CameraTransitionPositionLinear has a zero duration")

		local var_2_10 = var_2_4 / var_2_2
		local var_2_11 = math.min(var_2_10, 1)

		if arg_2_0._transition_func then
			var_2_11 = arg_2_0._transition_func(var_2_11)
		end

		var_2_5 = var_2_0 * (1 - var_2_11) + var_2_1 * var_2_11
		var_2_6 = var_2_2 < var_2_4
	end

	assert(Vector3.is_valid(var_2_5), "Interpolated position is not valid.")

	return var_2_5, var_2_6
end
