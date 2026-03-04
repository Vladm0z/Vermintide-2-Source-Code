-- chunkname: @scripts/level/environment/environment_blend_volume.lua

EnvironmentBlendVolume = class(EnvironmentBlendVolume)

EnvironmentBlendVolume.init = function (arg_1_0, arg_1_1)
	arg_1_0._volume_name = arg_1_1.volume_name
	arg_1_0._environment = arg_1_1.environment
	arg_1_0._always_inside = arg_1_1.always_inside
	arg_1_0._level = arg_1_1.level
	arg_1_0._level_key = arg_1_1.level_key
	arg_1_0._viewport = arg_1_1.viewport
	arg_1_0._player = arg_1_1.player
	arg_1_0._value = 0
	arg_1_0._blend_time = arg_1_1.blend_time or 2
	arg_1_0._current_timer = 0
	arg_1_0._enabled = true
	arg_1_0._is_inside = false
	arg_1_0._override_values = {
		arg_1_0._environment,
		not arg_1_1.override_sun_snap and "sun_direction" or nil
	}
	arg_1_0._data = arg_1_1

	Managers.state.event:register(arg_1_0, "enable_environment_volume", "event_enable_environment_volume")
	Managers.state.event:register(arg_1_0, "force_blend_environment_volume", "event_force_blend_environment_volume")
end

EnvironmentBlendVolume.particle_light_intensity = function (arg_2_0)
	return arg_2_0._data.particle_light_intensity
end

EnvironmentBlendVolume.event_force_blend_environment_volume = function (arg_3_0)
	if arg_3_0._enabled then
		arg_3_0._force_blend = true
	end
end

EnvironmentBlendVolume.event_enable_environment_volume = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._volume_name == arg_4_1 then
		arg_4_0._enabled = arg_4_2
	end
end

EnvironmentBlendVolume.environment = function (arg_5_0)
	return arg_5_0._environment
end

EnvironmentBlendVolume.level_key = function (arg_6_0)
	return arg_6_0._level_key
end

EnvironmentBlendVolume.value = function (arg_7_0)
	return arg_7_0._value
end

EnvironmentBlendVolume.is_inside = function (arg_8_0)
	return arg_8_0._is_inside
end

EnvironmentBlendVolume.override_settings = function (arg_9_0)
	return arg_9_0._override_values
end

EnvironmentBlendVolume.update = function (arg_10_0, arg_10_1)
	if arg_10_0._enabled and arg_10_0._always_inside then
		arg_10_0._value = 1
		arg_10_0._current_timer = 1

		return
	end

	local var_10_0 = ScriptViewport.camera(arg_10_0._viewport)
	local var_10_1 = arg_10_0._data.volume_name

	arg_10_0._is_inside = false

	if arg_10_0._enabled then
		if arg_10_0._data.is_sphere then
			local var_10_2 = ScriptCamera.position(var_10_0)
			local var_10_3 = arg_10_0._data.sphere_pos:unbox()

			arg_10_0._is_inside = Vector3.distance_squared(var_10_2, var_10_3) < arg_10_0._data.sphere_radius * arg_10_0._data.sphere_radius
		else
			arg_10_0._is_inside = Level.is_point_inside_volume(arg_10_0._level, arg_10_0._volume_name, ScriptCamera.position(var_10_0))
		end
	end

	local var_10_4 = arg_10_0._is_inside and 1 or -1

	if arg_10_0._blend_time <= 0 or arg_10_0._force_blend then
		arg_10_0._current_timer = arg_10_0._is_inside and 1 or 0
		arg_10_0._force_blend = false
	else
		arg_10_0._current_timer = math.clamp(arg_10_0._current_timer + 1 / arg_10_0._blend_time * (arg_10_1 * var_10_4), 0, 1)
	end

	arg_10_0._value = math.smoothstep(arg_10_0._current_timer, 0, 1)
end

EnvironmentBlendVolume.destroy = function (arg_11_0)
	local var_11_0 = Managers.state.event

	if var_11_0 then
		var_11_0:unregister("enable_environment_volume", arg_11_0)
		var_11_0:unregister("force_blend_environment_volume", arg_11_0)
	end
end
