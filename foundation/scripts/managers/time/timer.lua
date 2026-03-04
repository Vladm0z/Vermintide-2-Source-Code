-- chunkname: @foundation/scripts/managers/time/timer.lua

Timer = class(Timer)

Timer.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._t = arg_1_3 or 0
	arg_1_0._dt = 0
	arg_1_0._name = arg_1_1
	arg_1_0._active = true
	arg_1_0._local_scale = 1
	arg_1_0._global_scale = 1
	arg_1_0._parent = arg_1_2
	arg_1_0._children = {}
end

Timer.update = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._local_scale

	arg_2_1 = math.max(arg_2_1 * var_2_0, 1e-06)
	arg_2_2 = arg_2_2 * var_2_0

	for iter_2_0, iter_2_1 in pairs(arg_2_0._children) do
		if iter_2_1:active() then
			iter_2_1:update(arg_2_1, arg_2_2)
		end
	end

	arg_2_0._dt = arg_2_1
	arg_2_0._t = arg_2_0._t + arg_2_1
	arg_2_0._global_scale = arg_2_2
end

Timer.name = function (arg_3_0)
	return arg_3_0._name
end

Timer.set_time = function (arg_4_0, arg_4_1)
	arg_4_0._t = arg_4_1
end

Timer.time = function (arg_5_0)
	return arg_5_0._t
end

Timer.time_and_delta = function (arg_6_0)
	return arg_6_0._t, arg_6_0._dt
end

Timer.active = function (arg_7_0)
	return arg_7_0._active
end

Timer.set_active = function (arg_8_0, arg_8_1)
	arg_8_0._active = arg_8_1
end

Timer.set_local_scale = function (arg_9_0, arg_9_1)
	arg_9_0._local_scale = arg_9_1
end

Timer.local_scale = function (arg_10_0)
	return arg_10_0._local_scale
end

Timer.global_scale = function (arg_11_0)
	return arg_11_0._global_scale
end

Timer.add_child = function (arg_12_0, arg_12_1)
	arg_12_0._children[arg_12_1:name()] = arg_12_1
end

Timer.remove_child = function (arg_13_0, arg_13_1)
	arg_13_0._children[arg_13_1:name()] = nil
end

Timer.children = function (arg_14_0)
	return arg_14_0._children
end

Timer.parent = function (arg_15_0)
	return arg_15_0._parent
end

Timer.destroy = function (arg_16_0)
	arg_16_0._parent = nil
	arg_16_0._children = nil
end

Timer.delta_time = function (arg_17_0)
	return arg_17_0._dt
end
