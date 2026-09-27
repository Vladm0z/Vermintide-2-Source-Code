-- chunkname: @scripts/managers/camera/transitions/camera_transition_position_linear.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionPositionLinear = class(CameraTransitionPositionLinear, CameraTransitionBase)

CameraTransitionPositionLinear.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	CameraTransitionBase.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)

	self._freeze_node_1 = arg_1_5.freeze_start_node

	if not self._freeze_node_1 then
		local position = arg_1_1:position()

		self._node_1_pos_table = Vector3Box(position)
	end

	self._transition_func = arg_1_5.transition_func
end

CameraTransitionPositionLinear.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	CameraTransitionBase.update(self, arg_2_1, arg_2_3)

	local unbox

	if not self._freeze_node_1 then
		unbox = self._node_1_pos_table:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = arg_2_2

	::label_2_0::

	local position = self._node_2:position()
	local _duration = self._duration
	local _speed = self._speed
	local _time = self._time
	local var_2_5
	local var_2_6

	if not _speed and not _duration then
		assert(false, "CameraTransitionPositionLinear:update() transition has defined both speed and duration, only one can be allowed at once")
	elseif not _speed then
		local num = position - unbox
		local length = Vector3.length(num)
		local num_2 = _time * _speed

		if length <= num_2 then
			var_2_5 = position
			var_2_6 = true
		else
			var_2_5 = unbox + Vector3.normalize(num) * num_2
		end
	elseif not _duration then
		assert(_duration > 0, "CameraTransitionPositionLinear has a zero duration")

		local num_3 = _time / _duration
		local min = math.min(num_3, 1)

		if not self._transition_func then
			min = self._transition_func(min)
		end

		var_2_5 = unbox * (1 - min) + position * min
		var_2_6 = _duration < _time
	end

	assert(Vector3.is_valid(var_2_5), "Interpolated position is not valid.")

	return var_2_5, var_2_6
end
