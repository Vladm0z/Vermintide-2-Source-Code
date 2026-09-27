-- chunkname: @scripts/managers/camera/transitions/camera_transition_fov_linear.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionFOVLinear = class(CameraTransitionFOVLinear, CameraTransitionBase)

CameraTransitionFOVLinear.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	CameraTransitionBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
end

CameraTransitionFOVLinear.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	CameraTransitionBase.update(self, arg_2_1, arg_2_3)

	local var_2_0 = arg_2_2
	local vertical_fov = self._node_2:vertical_fov()
	local _duration = self._duration
	local _speed = self._speed
	local num = vertical_fov - var_2_0
	local var_2_5

	if not _duration then
		var_2_5 = num / _duration
	else
		var_2_5 = _speed
	end

	local num_2 = var_2_0 + self._time * var_2_5
	local flag = (not (var_2_0 < vertical_fov) or not (vertical_fov <= num_2) or not (vertical_fov < var_2_0)) and not (num_2 <= vertical_fov) and var_2_0 == vertical_fov

	if not flag then
		num_2 = vertical_fov
	end

	return num_2, flag
end
