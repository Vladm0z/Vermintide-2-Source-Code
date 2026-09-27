-- chunkname: @foundation/scripts/managers/time/timer.lua

Timer = class(Timer)

Timer.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._t = arg_1_3 or 0
	self._dt = 0
	self._name = arg_1_1
	self._active = true
	self._local_scale = 1
	self._global_scale = 1
	self._parent = arg_1_2
	self._children = {}
end

Timer.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	local _local_scale = self._local_scale

	arg_2_1 = math.max(arg_2_1 * _local_scale, 1e-06)
	arg_2_2 = arg_2_2 * _local_scale

	for k, v in pairs(self._children) do
		if not v:active() then
			v:update(arg_2_1, arg_2_2)
		end
	end

	self._dt = arg_2_1
	self._t = self._t + arg_2_1
	self._global_scale = arg_2_2
end

Timer.name = function (self)
	-- function 3
	return self._name
end

Timer.set_time = function (self, arg_4_1)
	-- function 4
	self._t = arg_4_1
end

Timer.time = function (self)
	-- function 5
	return self._t
end

Timer.time_and_delta = function (self)
	-- function 6
	return self._t, self._dt
end

Timer.active = function (self)
	-- function 7
	return self._active
end

Timer.set_active = function (self, arg_8_1)
	-- function 8
	self._active = arg_8_1
end

Timer.set_local_scale = function (self, arg_9_1)
	-- function 9
	self._local_scale = arg_9_1
end

Timer.local_scale = function (self)
	-- function 10
	return self._local_scale
end

Timer.global_scale = function (self)
	-- function 11
	return self._global_scale
end

Timer.add_child = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_0._children[arg_12_1:name()] = arg_12_1
end

Timer.remove_child = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_0._children[arg_13_1:name()] = nil
end

Timer.children = function (self)
	-- function 14
	return self._children
end

Timer.parent = function (self)
	-- function 15
	return self._parent
end

Timer.destroy = function (self)
	-- function 16
	self._parent = nil
	self._children = nil
end

Timer.delta_time = function (self)
	-- function 17
	return self._dt
end
