-- chunkname: @foundation/scripts/managers/time/time_manager.lua

require("foundation/scripts/managers/time/timer")

TimeManager = class(TimeManager)

TimeManager.init = function (self)
	-- function 1
	self._timers = {
		main = Timer:new("main", nil)
	}
	self._dt_stack = {}
	self._dt_stack_max_size = 10
	self._dt_stack_index = 0
	self._mean_dt = 0
	self._global_time_scale = 1
	self._lerp_global_time_scale = false

	self:register_timer("ui", "main", Application.time_since_launch())
end

TimeManager.register_timer = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local _timers = self._timers

	fassert(_timers[arg_2_1] == nil, "[TimeManager] Tried to add already registered timer %q", arg_2_1)
	fassert(_timers[arg_2_2], "[TimeManager] Not allowed to add timer with unregistered parent %q", arg_2_2)

	local var_2_1 = _timers[arg_2_2]
	local var_2_2 = Timer:new(arg_2_1, var_2_1, arg_2_3)

	var_2_1:add_child(var_2_2)

	_timers[arg_2_1] = var_2_2
end

TimeManager.unregister_timer = function (self, arg_3_1)
	-- function 3
	local var_3_0 = self._timers[arg_3_1]

	fassert(var_3_0, "[TimeManager] Tried to remove unregistered timer %q", arg_3_1)
	fassert(table.size(var_3_0:children()) == 0, "[TimeManager] Not allowed to remove timer %q with children", arg_3_1)

	local parent = var_3_0:parent()

	if not parent then
		parent:remove_child(var_3_0)
	end

	var_3_0:destroy()

	self._timers[arg_3_1] = nil
end

TimeManager.has_timer = function (self, arg_4_1)
	-- function 4
	local flag

	flag = not self._timers[arg_4_1] and true and false

	return flag
end

TimeManager.update = function (self, arg_5_1)
	-- function 5
	local main = self._timers.main

	if not main:active() then
		main:update(arg_5_1, 1)
	end

	if not self._lerp_global_time_scale then
		self:_update_global_time_scale_lerp(arg_5_1)
	end

	if not script_data.honduras_demo then
		self:_update_demo_timer(arg_5_1)
	end

	self:_update_mean_dt(arg_5_1)
end

TimeManager._update_demo_timer = function (self, arg_6_1)
	-- function 6
	local _demo_timer = self._demo_timer

	_demo_timer = _demo_timer or DemoSettings.demo_idle_timer
	self._demo_timer = _demo_timer - arg_6_1

	local input = Managers.input

	input = not input and Managers.input:get_most_recent_device()

	if not input then
		return
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = false

	for i = 0, input.num_axes() - 1 do
		if not is_device_active then
			if not (not IS_PS4 and not (i < 3) and Vector3.length(input.axis(i)) == 0) then
				flag = true

				break
			end
		elseif not (Vector3.length(input.axis(i)) == 0 or input.axis_name(i) == "cursor") then
			flag = true

			break
		end
	end

	if input.any_pressed() or not flag then
		self._demo_timer = DemoSettings.demo_idle_timer
		self._demo_idle_timer_failed = false
	elseif self._demo_timer <= 0 then
		self._demo_idle_timer_failed = true
	end
end

TimeManager.get_demo_transition = function (self)
	-- function 7
	local _demo_idle_timer_failed = self._demo_idle_timer_failed

	_demo_idle_timer_failed = not _demo_idle_timer_failed and "return_to_demo_title_screen"

	return _demo_idle_timer_failed
end

TimeManager._update_mean_dt = function (self, arg_8_1)
	-- function 8
	local _dt_stack = self._dt_stack

	self._dt_stack_index = self._dt_stack_index % self._dt_stack_max_size + 1
	_dt_stack[self._dt_stack_index] = arg_8_1

	local num = 0

	for i, v in ipairs(_dt_stack) do
		num = num + v
	end

	self._mean_dt = num / #_dt_stack
end

TimeManager.mean_dt = function (self)
	-- function 9
	return self._mean_dt
end

TimeManager.set_time = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._timers[arg_10_1]:set_time(arg_10_2)
end

TimeManager.time = function (self, arg_11_1)
	-- function 11
	if not self._timers[arg_11_1] then
		return self._timers[arg_11_1]:time()
	end
end

TimeManager.time_and_delta = function (self, arg_12_1)
	-- function 12
	if not self._timers[arg_12_1] then
		return self._timers[arg_12_1]:time_and_delta()
	end
end

TimeManager.active = function (self, arg_13_1)
	-- function 13
	return self._timers[arg_13_1]:active()
end

TimeManager.set_active = function (self, arg_14_1, arg_14_2)
	-- function 14
	self._timers[arg_14_1]:set_active(arg_14_2)
end

TimeManager.set_local_scale = function (self, arg_15_1, arg_15_2)
	-- function 15
	fassert(arg_15_1 ~= "main", "[TimeManager] Not allowed to set scale in main timer")
	self._timers[arg_15_1]:set_local_scale(arg_15_2)
end

TimeManager.local_scale = function (self, arg_16_1)
	-- function 16
	return self._timers[arg_16_1]:local_scale()
end

TimeManager.global_scale = function (self, arg_17_1)
	-- function 17
	return self._timers[arg_17_1]:global_scale()
end

TimeManager.set_global_time_scale = function (self, arg_18_1)
	-- function 18
	self._global_time_scale = arg_18_1
	self._lerp_global_time_scale = false
end

TimeManager.set_global_time_scale_lerp = function (self, arg_19_1, arg_19_2)
	-- function 19
	self._global_time_scale_lerp_start = self._global_time_scale
	self._global_time_scale_lerp_end = arg_19_1
	self._global_time_scale_lerp_progress = 0
	self._global_time_scale_lerp_increment = 1 / arg_19_2
	self._lerp_global_time_scale = true
end

TimeManager._update_global_time_scale_lerp = function (self, arg_20_1)
	-- function 20
	local _global_time_scale_lerp_start = self._global_time_scale_lerp_start
	local _global_time_scale_lerp_end = self._global_time_scale_lerp_end
	local _global_time_scale_lerp_progress = self._global_time_scale_lerp_progress
	local _global_time_scale_lerp_increment = self._global_time_scale_lerp_increment
	local clamp = math.clamp(_global_time_scale_lerp_progress + arg_20_1 * _global_time_scale_lerp_increment, 0, 1)

	self._global_time_scale = math.lerp(_global_time_scale_lerp_start, _global_time_scale_lerp_end, clamp)
	self._global_time_scale_lerp_progress = clamp

	if clamp >= 1 then
		self._lerp_global_time_scale = false
	end
end

TimeManager.scaled_delta_time = function (self, arg_21_1)
	-- function 21
	return math.max(arg_21_1 * self._global_time_scale, 1e-06)
end

TimeManager.destroy = function (self)
	-- function 22
	for k, v in pairs(self._timers) do
		v:destroy()
	end

	self._timers = nil
end
