-- chunkname: @scripts/level/environment/environment_blend_time.lua

EnvironmentBlendTime = class(EnvironmentBlendTime)

EnvironmentBlendTime.init = function (arg_1_0, arg_1_1)
	arg_1_0._environment = arg_1_1.environment
	arg_1_0._blend_function = arg_1_1.blend_function
	arg_1_0._lerp_in_speed = arg_1_1.lerp_in_speed
	arg_1_0._lerp_out_speed = arg_1_1.lerp_out_speed
	arg_1_0._lerp_speed = arg_1_0._lerp_in_speed

	fassert(arg_1_0._lerp_speed, arg_1_0._environment)

	arg_1_0._value = 0
	arg_1_0._target_value = 0

	Managers.state.event:register(arg_1_0, "force_blend_environment_volume", "event_force_blend_environment_volume")
end

EnvironmentBlendTime.event_force_blend_environment_volume = function (arg_2_0)
	arg_2_0._force_blend = true
end

EnvironmentBlendTime.environment = function (arg_3_0)
	return arg_3_0._environment
end

EnvironmentBlendTime.value = function (arg_4_0)
	return arg_4_0._value
end

EnvironmentBlendTime.update = function (arg_5_0, arg_5_1)
	if arg_5_0._blend_function(arg_5_0._environment) then
		arg_5_0._target_value = 1
		arg_5_0._lerp_speed = arg_5_0._lerp_in_speed
	else
		arg_5_0._target_value = 0
		arg_5_0._lerp_speed = arg_5_0._lerp_out_speed
	end

	if arg_5_0._force_blend then
		arg_5_0._value = arg_5_0._target_value
		arg_5_0._force_blend = false
	else
		arg_5_0._value = math.lerp(arg_5_0._value, arg_5_0._target_value, arg_5_0._lerp_speed * arg_5_1)
	end
end

EnvironmentBlendTime.destroy = function (arg_6_0)
	local var_6_0 = Managers.state.event

	if var_6_0 then
		var_6_0:unregister("force_blend_environment_volume", arg_6_0)
	end
end
