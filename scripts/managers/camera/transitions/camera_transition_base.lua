-- chunkname: @scripts/managers/camera/transitions/camera_transition_base.lua

CameraTransitionBase = class(CameraTransitionBase)

CameraTransitionBase.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._node_1 = arg_1_1
	arg_1_0._node_2 = arg_1_2
	arg_1_0._duration = arg_1_3
	arg_1_0._speed = arg_1_4
	arg_1_0._start_time = Managers.time:time("game")
	arg_1_0._time = 0
end

CameraTransitionBase.update = function (arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 then
		arg_2_0._time = Managers.time:time("game") - arg_2_0._start_time
	end
end
