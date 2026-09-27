-- chunkname: @scripts/managers/camera/transitions/camera_transition_base.lua

CameraTransitionBase = class(CameraTransitionBase)

CameraTransitionBase.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._node_1 = arg_1_1
	self._node_2 = arg_1_2
	self._duration = arg_1_3
	self._speed = arg_1_4
	self._start_time = Managers.time:time("game")
	self._time = 0
end

CameraTransitionBase.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_2 then
		self._time = Managers.time:time("game") - self._start_time
	end
end
