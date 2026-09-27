-- chunkname: @scripts/managers/camera/transitions/camera_transition_generic.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionGeneric = class(CameraTransitionGeneric, CameraTransitionBase)

CameraTransitionGeneric.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	CameraTransitionBase.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)

	self._transition_func = arg_1_5.transition_func
	self._parameter = arg_1_5.parameter
end

CameraTransitionGeneric.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	CameraTransitionBase.update(self, arg_2_1, arg_2_3)

	local var_2_0 = self._node_2[self._parameter](self._node_2)
	local _duration = self._duration
	local _speed = self._speed
	local var_2_3
	local var_2_4

	if not _speed and not _duration then
		assert(false, "CameraTransitionGeneric:update() transition has defined both speed and duration, only one can be allowed at once")
	elseif not _speed then
		local num = var_2_0 - arg_2_2
		local num_2 = self._time * _speed

		if num < num_2 then
			var_2_3 = var_2_0
			var_2_4 = true
		else
			var_2_3 = arg_2_2 + num_2
		end
	elseif not _duration then
		local num_3 = self._time / _duration
		local min = math.min(num_3, 1)

		if not self._transition_func then
			min = self._transition_func(min)
		end

		var_2_3 = arg_2_2 * (1 - min) + var_2_0 * min
		var_2_4 = _duration < self._time
	end

	return var_2_3, var_2_4
end
