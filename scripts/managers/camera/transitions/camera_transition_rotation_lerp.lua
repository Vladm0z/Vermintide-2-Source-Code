-- chunkname: @scripts/managers/camera/transitions/camera_transition_rotation_lerp.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionRotationLerp = class(CameraTransitionRotationLerp, CameraTransitionBase)

CameraTransitionRotationLerp.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	CameraTransitionBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)

	arg_1_0._freeze_node_1 = arg_1_5.freeze_start_node

	if arg_1_0._freeze_node_1 then
		local var_1_0 = arg_1_1:rotation()

		arg_1_0._node_1_rot_table = QuaternionBox(var_1_0)
	end
end

CameraTransitionRotationLerp.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	CameraTransitionBase.update(arg_2_0, arg_2_1, arg_2_3)

	local var_2_0 = arg_2_0._freeze_node_1 and arg_2_0._node_1_rot_table:unbox() or arg_2_2
	local var_2_1 = arg_2_0._node_2:rotation()
	local var_2_2 = arg_2_0._duration
	local var_2_3 = arg_2_0._time / arg_2_0._duration
	local var_2_4 = var_2_3 >= 1

	return Quaternion.lerp(var_2_0, var_2_1, math.min(var_2_3, 1)), var_2_4
end
