-- chunkname: @scripts/level/environment/environment_blend_time.lua

EnvironmentBlendTime = class(EnvironmentBlendTime)

EnvironmentBlendTime.init = function (self, arg_1_1)
	-- function 1
	self._environment = arg_1_1.environment
	self._blend_function = arg_1_1.blend_function
	self._lerp_in_speed = arg_1_1.lerp_in_speed
	self._lerp_out_speed = arg_1_1.lerp_out_speed
	self._lerp_speed = self._lerp_in_speed

	fassert(self._lerp_speed, self._environment)

	self._value = 0
	self._target_value = 0

	Managers.state.event:register(self, "force_blend_environment_volume", "event_force_blend_environment_volume")
end

EnvironmentBlendTime.event_force_blend_environment_volume = function (self)
	-- function 2
	self._force_blend = true
end

EnvironmentBlendTime.environment = function (self)
	-- function 3
	return self._environment
end

EnvironmentBlendTime.value = function (self)
	-- function 4
	return self._value
end

EnvironmentBlendTime.update = function (self, arg_5_1)
	-- function 5
	if not self._blend_function(self._environment) then
		self._target_value = 1
		self._lerp_speed = self._lerp_in_speed
	else
		self._target_value = 0
		self._lerp_speed = self._lerp_out_speed
	end

	if not self._force_blend then
		self._value = self._target_value
		self._force_blend = false
	else
		self._value = math.lerp(self._value, self._target_value, self._lerp_speed * arg_5_1)
	end
end

EnvironmentBlendTime.destroy = function (arg_6_0)
	-- function 6
	local event = Managers.state.event

	if not event then
		event:unregister("force_blend_environment_volume", arg_6_0)
	end
end
