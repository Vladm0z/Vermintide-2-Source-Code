-- chunkname: @foundation/scripts/managers/time/time_manager.lua

require("foundation/scripts/managers/time/timer")

TimeManager = class(TimeManager)

TimeManager.init = function (arg_1_0)
	arg_1_0._timers = {
		main = Timer:new("main", nil)
	}
	arg_1_0._dt_stack = {}
	arg_1_0._dt_stack_max_size = 10
	arg_1_0._dt_stack_index = 0
	arg_1_0._mean_dt = 0
	arg_1_0._global_time_scale = 1
	arg_1_0._lerp_global_time_scale = false

	arg_1_0:register_timer("ui", "main", Application.time_since_launch())
end

TimeManager.register_timer = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._timers

	fassert(var_2_0[arg_2_1] == nil, "[TimeManager] Tried to add already registered timer %q", arg_2_1)
	fassert(var_2_0[arg_2_2], "[TimeManager] Not allowed to add timer with unregistered parent %q", arg_2_2)

	local var_2_1 = var_2_0[arg_2_2]
	local var_2_2 = Timer:new(arg_2_1, var_2_1, arg_2_3)

	var_2_1:add_child(var_2_2)

	var_2_0[arg_2_1] = var_2_2
end

TimeManager.unregister_timer = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._timers[arg_3_1]

	fassert(var_3_0, "[TimeManager] Tried to remove unregistered timer %q", arg_3_1)
	fassert(table.size(var_3_0:children()) == 0, "[TimeManager] Not allowed to remove timer %q with children", arg_3_1)

	local var_3_1 = var_3_0:parent()

	if var_3_1 then
		var_3_1:remove_child(var_3_0)
	end

	var_3_0:destroy()

	arg_3_0._timers[arg_3_1] = nil
end

TimeManager.has_timer = function (arg_4_0, arg_4_1)
	return arg_4_0._timers[arg_4_1] and true or false
end

TimeManager.update = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._timers.main

	if var_5_0:active() then
		var_5_0:update(arg_5_1, 1)
	end

	if arg_5_0._lerp_global_time_scale then
		arg_5_0:_update_global_time_scale_lerp(arg_5_1)
	end

	if script_data.honduras_demo then
		arg_5_0:_update_demo_timer(arg_5_1)
	end

	arg_5_0:_update_mean_dt(arg_5_1)
end

TimeManager._update_demo_timer = function (arg_6_0, arg_6_1)
	arg_6_0._demo_timer = (arg_6_0._demo_timer or DemoSettings.demo_idle_timer) - arg_6_1

	local var_6_0 = Managers.input and Managers.input:get_most_recent_device()

	if not var_6_0 then
		return
	end

	local var_6_1 = Managers.input:is_device_active("gamepad")
	local var_6_2 = false

	for iter_6_0 = 0, var_6_0.num_axes() - 1 do
		if var_6_1 then
			if (not IS_PS4 or iter_6_0 < 3) and Vector3.length(var_6_0.axis(iter_6_0)) ~= 0 then
				var_6_2 = true

				break
			end
		elseif Vector3.length(var_6_0.axis(iter_6_0)) ~= 0 and var_6_0.axis_name(iter_6_0) ~= "cursor" then
			var_6_2 = true

			break
		end
	end

	if var_6_0.any_pressed() or var_6_2 then
		arg_6_0._demo_timer = DemoSettings.demo_idle_timer
		arg_6_0._demo_idle_timer_failed = false
	elseif arg_6_0._demo_timer <= 0 then
		arg_6_0._demo_idle_timer_failed = true
	end
end

TimeManager.get_demo_transition = function (arg_7_0)
	return arg_7_0._demo_idle_timer_failed and "return_to_demo_title_screen"
end

TimeManager._update_mean_dt = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._dt_stack

	arg_8_0._dt_stack_index = arg_8_0._dt_stack_index % arg_8_0._dt_stack_max_size + 1
	var_8_0[arg_8_0._dt_stack_index] = arg_8_1

	local var_8_1 = 0

	for iter_8_0, iter_8_1 in ipairs(var_8_0) do
		var_8_1 = var_8_1 + iter_8_1
	end

	arg_8_0._mean_dt = var_8_1 / #var_8_0
end

TimeManager.mean_dt = function (arg_9_0)
	return arg_9_0._mean_dt
end

TimeManager.set_time = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._timers[arg_10_1]:set_time(arg_10_2)
end

TimeManager.time = function (arg_11_0, arg_11_1)
	if arg_11_0._timers[arg_11_1] then
		return arg_11_0._timers[arg_11_1]:time()
	end
end

TimeManager.time_and_delta = function (arg_12_0, arg_12_1)
	if arg_12_0._timers[arg_12_1] then
		return arg_12_0._timers[arg_12_1]:time_and_delta()
	end
end

TimeManager.active = function (arg_13_0, arg_13_1)
	return arg_13_0._timers[arg_13_1]:active()
end

TimeManager.set_active = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._timers[arg_14_1]:set_active(arg_14_2)
end

TimeManager.set_local_scale = function (arg_15_0, arg_15_1, arg_15_2)
	fassert(arg_15_1 ~= "main", "[TimeManager] Not allowed to set scale in main timer")
	arg_15_0._timers[arg_15_1]:set_local_scale(arg_15_2)
end

TimeManager.local_scale = function (arg_16_0, arg_16_1)
	return arg_16_0._timers[arg_16_1]:local_scale()
end

TimeManager.global_scale = function (arg_17_0, arg_17_1)
	return arg_17_0._timers[arg_17_1]:global_scale()
end

TimeManager.set_global_time_scale = function (arg_18_0, arg_18_1)
	arg_18_0._global_time_scale = arg_18_1
	arg_18_0._lerp_global_time_scale = false
end

TimeManager.set_global_time_scale_lerp = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._global_time_scale_lerp_start = arg_19_0._global_time_scale
	arg_19_0._global_time_scale_lerp_end = arg_19_1
	arg_19_0._global_time_scale_lerp_progress = 0
	arg_19_0._global_time_scale_lerp_increment = 1 / arg_19_2
	arg_19_0._lerp_global_time_scale = true
end

TimeManager._update_global_time_scale_lerp = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._global_time_scale_lerp_start
	local var_20_1 = arg_20_0._global_time_scale_lerp_end
	local var_20_2 = arg_20_0._global_time_scale_lerp_progress
	local var_20_3 = arg_20_0._global_time_scale_lerp_increment
	local var_20_4 = math.clamp(var_20_2 + arg_20_1 * var_20_3, 0, 1)

	arg_20_0._global_time_scale = math.lerp(var_20_0, var_20_1, var_20_4)
	arg_20_0._global_time_scale_lerp_progress = var_20_4

	if var_20_4 >= 1 then
		arg_20_0._lerp_global_time_scale = false
	end
end

TimeManager.scaled_delta_time = function (arg_21_0, arg_21_1)
	return math.max(arg_21_1 * arg_21_0._global_time_scale, 1e-06)
end

TimeManager.destroy = function (arg_22_0)
	for iter_22_0, iter_22_1 in pairs(arg_22_0._timers) do
		iter_22_1:destroy()
	end

	arg_22_0._timers = nil
end
