-- chunkname: @foundation/scripts/managers/time/timer.lua

Timer = class(Timer)

Timer.init = function (self, name, parent, start_time)
	-- function 1
	self._t = not not start_time or not not 0
	self._dt = 0
	self._name = name
	self._active = true
	self._local_scale = 1
	self._global_scale = 1
	self._parent = parent
	self._children = {}
end

Timer.update = function (self, dt, global_scale)
	-- function 2
	local local_scale = self._local_scale

	dt = math.max(dt * local_scale, 1e-06)
	global_scale = global_scale * local_scale

	for name, child in pairs(self._children) do
		if child:active() then
			child:update(dt, global_scale)
		end
	end

	self._dt = dt
	self._t = self._t + dt
	self._global_scale = global_scale
end

Timer.name = function (self)
	-- function 3
	return self._name
end

Timer.set_time = function (self, time)
	-- function 4
	self._t = time
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

Timer.set_active = function (self, active)
	-- function 8
	self._active = active
end

Timer.set_local_scale = function (self, scale)
	-- function 9
	self._local_scale = scale
end

Timer.local_scale = function (self)
	-- function 10
	return self._local_scale
end

Timer.global_scale = function (self)
	-- function 11
	return self._global_scale
end

Timer.add_child = function (self, timer)
	-- function 12
	self._children[timer:name()] = timer
end

Timer.remove_child = function (self, timer)
	-- function 13
	self._children[timer:name()] = nil
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
