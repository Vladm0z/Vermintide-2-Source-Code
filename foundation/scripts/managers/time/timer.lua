-- chunkname: @foundation/scripts/managers/time/timer.lua

Timer = class(Timer)

function Timer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._t = arg_1_3 or 0
	arg_1_0._dt = 0
	arg_1_0._name = arg_1_1
	arg_1_0._active = true
	arg_1_0._local_scale = 1
	arg_1_0._global_scale = 1
	arg_1_0._parent = arg_1_2
	arg_1_0._children = {}
end

function Timer.update(arg_2_0, arg_2_1, arg_2_2)
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

function Timer.name(arg_3_0)
	return arg_3_0._name
end

function Timer.set_time(arg_4_0, arg_4_1)
	arg_4_0._t = arg_4_1
end

function Timer.time(arg_5_0)
	return arg_5_0._t
end

function Timer.time_and_delta(arg_6_0)
	return arg_6_0._t, arg_6_0._dt
end

function Timer.active(arg_7_0)
	return arg_7_0._active
end

function Timer.set_active(arg_8_0, arg_8_1)
	arg_8_0._active = arg_8_1
end

function Timer.set_local_scale(arg_9_0, arg_9_1)
	arg_9_0._local_scale = arg_9_1
end

function Timer.local_scale(arg_10_0)
	return arg_10_0._local_scale
end

function Timer.global_scale(arg_11_0)
	return arg_11_0._global_scale
end

function Timer.add_child(arg_12_0, arg_12_1)
	arg_12_0._children[arg_12_1:name()] = arg_12_1
end

function Timer.remove_child(arg_13_0, arg_13_1)
	arg_13_0._children[arg_13_1:name()] = nil
end

function Timer.children(arg_14_0)
	return arg_14_0._children
end

function Timer.parent(arg_15_0)
	return arg_15_0._parent
end

function Timer.destroy(arg_16_0)
	arg_16_0._parent = nil
	arg_16_0._children = nil
end

function Timer.delta_time(arg_17_0)
	return arg_17_0._dt
end
