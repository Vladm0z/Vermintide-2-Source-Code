-- chunkname: @scripts/level/environment/environment_blend_volume.lua

EnvironmentBlendVolume = class(EnvironmentBlendVolume)

EnvironmentBlendVolume.init = function (self, arg_1_1)
	-- function 1
	self._volume_name = arg_1_1.volume_name
	self._environment = arg_1_1.environment
	self._always_inside = arg_1_1.always_inside
	self._level = arg_1_1.level
	self._level_key = arg_1_1.level_key
	self._viewport = arg_1_1.viewport
	self._player = arg_1_1.player
	self._value = 0

	local blend_time = arg_1_1.blend_time

	blend_time = blend_time or 2
	self._blend_time = blend_time
	self._current_timer = 0
	self._enabled = true
	self._is_inside = false

	local tbl = {
		self._environment
	}
	local flag

	flag = arg_1_1.override_sun_snap or not "sun_direction" or nil
	tbl[2] = flag
	self._override_values = tbl
	self._data = arg_1_1

	Managers.state.event:register(self, "enable_environment_volume", "event_enable_environment_volume")
	Managers.state.event:register(self, "force_blend_environment_volume", "event_force_blend_environment_volume")
end

EnvironmentBlendVolume.particle_light_intensity = function (self)
	-- function 2
	return self._data.particle_light_intensity
end

EnvironmentBlendVolume.event_force_blend_environment_volume = function (self)
	-- function 3
	if not self._enabled then
		self._force_blend = true
	end
end

EnvironmentBlendVolume.event_enable_environment_volume = function (self, arg_4_1, arg_4_2)
	-- function 4
	if self._volume_name == arg_4_1 then
		self._enabled = arg_4_2
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

EnvironmentBlendVolume.update = function (self, arg_10_1)
	-- function 10
	if not self._enabled and not self._always_inside then
		self._value = 1
		self._current_timer = 1

		return
	end

	local camera = ScriptViewport.camera(self._viewport)
	local volume_name = self._data.volume_name

	self._is_inside = false

	if not self._enabled then
		if not self._data.is_sphere then
			local position = ScriptCamera.position(camera)
			local unbox = self._data.sphere_pos:unbox()

			self._is_inside = Vector3.distance_squared(position, unbox) < self._data.sphere_radius * self._data.sphere_radius
		else
			self._is_inside = Level.is_point_inside_volume(self._level, self._volume_name, ScriptCamera.position(camera))
		end
	end

	local flag

	flag = not self._is_inside and 1 and -1

	if self._blend_time <= 0 or not self._force_blend then
		local flag_2

		flag_2 = not self._is_inside and 1 and 0
		self._current_timer = flag_2
		self._force_blend = false
	else
		self._current_timer = math.clamp(self._current_timer + 1 / self._blend_time * (arg_10_1 * flag), 0, 1)
	end

	self._value = math.smoothstep(self._current_timer, 0, 1)
end

EnvironmentBlendVolume.destroy = function (arg_11_0)
	-- function 11
	local event = Managers.state.event

	if not event then
		event:unregister("enable_environment_volume", arg_11_0)
		event:unregister("force_blend_environment_volume", arg_11_0)
	end
end
