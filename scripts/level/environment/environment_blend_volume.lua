-- chunkname: @scripts/level/environment/environment_blend_volume.lua

EnvironmentBlendVolume = class(EnvironmentBlendVolume)

EnvironmentBlendVolume.init = function (self, data)
	-- function 1
	self._volume_name = data.volume_name
	self._environment = data.environment
	self._always_inside = data.always_inside
	self._level = data.level
	self._level_key = data.level_key
	self._viewport = data.viewport
	self._player = data.player
	self._value = 0

	local blend_time = data.blend_time

	blend_time = not not blend_time or not not 2
	self._blend_time = blend_time
	self._current_timer = 0
	self._enabled = true
	self._is_inside = false

	local tbl = {
		self._environment
	}
	local flag

	flag = (data.override_sun_snap or not "sun_direction") and not not nil
	tbl[2] = flag
	self._override_values = tbl
	self._data = data

	Managers.state.event:register(self, "enable_environment_volume", "event_enable_environment_volume")
	Managers.state.event:register(self, "force_blend_environment_volume", "event_force_blend_environment_volume")
end

EnvironmentBlendVolume.particle_light_intensity = function (self)
	-- function 2
	return self._data.particle_light_intensity
end

EnvironmentBlendVolume.event_force_blend_environment_volume = function (self)
	-- function 3
	if self._enabled then
		self._force_blend = true
	end
end

EnvironmentBlendVolume.event_enable_environment_volume = function (self, volume_name, enable)
	-- function 4
	if self._volume_name == volume_name then
		self._enabled = enable
	end
end

EnvironmentBlendVolume.environment = function (self)
	-- function 5
	return self._environment
end

EnvironmentBlendVolume.level_key = function (self)
	-- function 6
	return self._level_key
end

EnvironmentBlendVolume.value = function (self)
	-- function 7
	return self._value
end

EnvironmentBlendVolume.is_inside = function (self)
	-- function 8
	return self._is_inside
end

EnvironmentBlendVolume.override_settings = function (self)
	-- function 9
	return self._override_values
end

EnvironmentBlendVolume.update = function (self, dt)
	-- function 10
	if self._enabled and self._always_inside then
		self._value = 1
		self._current_timer = 1

		return
	end

	local camera = ScriptViewport.camera(self._viewport)
	local volume_name = self._data.volume_name

	self._is_inside = false

	if self._enabled then
		if self._data.is_sphere then
			local camera_pos = ScriptCamera.position(camera)
			local volume_pos = self._data.sphere_pos:unbox()

			self._is_inside = Vector3.distance_squared(camera_pos, volume_pos) < self._data.sphere_radius * self._data.sphere_radius
		else
			self._is_inside = Level.is_point_inside_volume(self._level, self._volume_name, ScriptCamera.position(camera))
		end
	end

	local num

	if self._is_inside then
		num = 1

		goto label_10_0
	end

	num = -1

	local target = num

	::label_10_0::

	if self._blend_time <= 0 or self._force_blend then
		local flag

		flag = (not self._is_inside or not 1) and not not 0
		self._current_timer = flag
		self._force_blend = false
	else
		self._current_timer = math.clamp(self._current_timer + 1 / self._blend_time * (dt * target), 0, 1)
	end

	self._value = math.smoothstep(self._current_timer, 0, 1)
end

EnvironmentBlendVolume.destroy = function (self)
	-- function 11
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:unregister("enable_environment_volume", self)
		event_manager:unregister("force_blend_environment_volume", self)
	end
end
