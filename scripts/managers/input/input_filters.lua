-- chunkname: @scripts/managers/input/input_filters.lua

local InputFilters = InputFilters

InputFilters = InputFilters or {}
InputFilters = InputFilters

local function fn(self, arg_1_1)
	-- function 1
	if arg_1_1 > Vector3.length(self) then
		self.x = 0
		self.y = 0
		self.z = 0
	end
end

InputFilters.virtual_axis = {
	init = function (arg_2_0)
		-- function 2
		return table.clone(arg_2_0)
	end,
	update = function (self, arg_3_1)
		-- function 3
		local input_mappings = self.input_mappings
		local get = arg_3_1:get(input_mappings.right)
		local get_2 = arg_3_1:get(input_mappings.left)
		local get_3 = arg_3_1:get(input_mappings.forward)
		local get_4 = arg_3_1:get(input_mappings.back)
		local up = input_mappings.up
		local get_5

		if not up then
			get_5 = arg_3_1:get(up)

			if not get_5 then
				-- Nothing
			end
		end

		get_5 = 0

		::label_3_0::

		local down = input_mappings.down
		local get_6

		if not down then
			get_6 = arg_3_1:get(down)

			if not get_6 then
				-- Nothing
			end
		end

		get_6 = 0

		::label_3_1::

		return (Vector3(get - get_2, get_3 - get_4, get_5 - get_6))
	end,
	edit_types = {
		{
			"up",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"down",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"left",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"right",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"forward",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"back",
			"keymap",
			"soft_button",
			"input_mappings"
		}
	}
}
InputFilters.scale_vector3 = {
	init = function (arg_4_0)
		-- function 4
		return table.clone(arg_4_0)
	end,
	update = function (self, arg_5_1)
		-- function 5
		local get = arg_5_1:get(self.input_mapping)
		local var_5_1 = fn
		local var_5_2 = get
		local input_threshold = self.input_threshold

		input_threshold = input_threshold or 0

		var_5_1(var_5_2, input_threshold)

		return get * self.multiplier
	end,
	edit_types = {
		{
			"multiplier",
			"number"
		}
	}
}
InputFilters.scale_vector3_xy = {
	init = function (arg_6_0)
		-- function 6
		return table.clone(arg_6_0)
	end,
	update = function (self, arg_7_1)
		-- function 7
		local get = arg_7_1:get(self.input_mapping)
		local var_7_1 = fn
		local var_7_2 = get
		local input_threshold = self.input_threshold

		input_threshold = input_threshold or 0

		var_7_1(var_7_2, input_threshold)

		local num = get.x * self.multiplier_x
		local num_2 = get.y * self.multiplier_y
		local z = get.z

		return Vector3(num, num_2, z)
	end,
	edit_types = {
		{
			"multiplier_x",
			"number"
		},
		{
			"multiplier_y",
			"number"
		}
	}
}
InputFilters.scale_vector3_xy_accelerated_x = {
	init = function (arg_8_0)
		-- function 8
		local clone = table.clone(arg_8_0)

		clone.input_x = 0
		clone.input_x_t = 0
		clone.input_x_turnaround_t = 0

		local min_multiplier_x = clone.min_multiplier_x

		min_multiplier_x = min_multiplier_x or clone.multiplier_x * 0.25
		clone.min_multiplier_x = min_multiplier_x

		return clone
	end,
	update = function (self, arg_9_1)
		-- function 9
		local get = arg_9_1:get(self.input_mapping)
		local var_9_1 = fn
		local var_9_2 = get
		local input_threshold = self.input_threshold

		input_threshold = input_threshold or 0

		var_9_1(var_9_2, input_threshold)

		local time_since_launch = Application.time_since_launch()

		if not (not self.turnaround_threshold and not (math.abs(get.x) >= self.turnaround_threshold) or math.sign(get.x) == self.input_x_turnaround) then
			self.input_x_turnaround = math.sign(get.x)
			self.input_x_turnaround_t = time_since_launch
		elseif not (not (math.abs(get.x) >= self.threshold) or math.sign(get.x) == self.input_x) then
			self.input_x = math.sign(get.x)
			self.input_x_t = time_since_launch
		elseif not (not (math.abs(get.x) < self.threshold) or not (Vector3.length(get) < self.threshold)) then
			self.input_x_t = time_since_launch
		end

		if math.abs(get.x) < 0.1 then
			self.input_x = 0
		end

		if not (not self.turnaround_threshold and not (math.abs(get.x) < self.turnaround_threshold)) then
			self.input_x_turnaround = 0
		end

		local var_9_5
		local num = time_since_launch - self.input_x_t
		local num_2 = time_since_launch - self.input_x_turnaround_t

		if math.abs(get.x) > 0.75 then
			get.y = get.y * (1 - (math.abs(get.x) - 0.75) / 0.25)
		end

		if not Application.user_setting("enable_gamepad_acceleration") then
			var_9_5 = get.x * self.min_multiplier_x * Managers.time._mean_dt
		elseif not (not self.turnaround_threshold and not (num_2 >= self.acceleration_delay + self.turnaround_delay) or not (math.abs(get.x) >= self.turnaround_threshold)) then
			local clamp = math.clamp(num - (self.acceleration_delay + self.turnaround_delay) / self.turnaround_time_ref, 0, 1)

			var_9_5 = get.x * math.lerp(self.min_multiplier_x, self.turnaround_multiplier_x, math.pow(clamp, self.turnaround_power_of)) * Managers.time._mean_dt
		elseif num >= self.acceleration_delay then
			local clamp_2 = math.clamp((num - self.acceleration_delay) / self.accelerate_time_ref, 0, 1)

			var_9_5 = get.x * math.lerp(self.min_multiplier_x, self.multiplier_x, math.pow(clamp_2, self.power_of)) * Managers.time._mean_dt
		else
			var_9_5 = get.x * self.min_multiplier_x * Managers.time._mean_dt
		end

		local multiplier_y = self.multiplier_y

		if (get.y == 0 or not self.multiplier_return_y) and not self.angle_to_slow_down_inside and not Application.user_setting("enable_gamepad_acceleration") then
			local viewport_name = Managers.player:local_player().viewport_name
			local world = Managers.world:world("level_world")
			local viewport = ScriptWorld.viewport(world, viewport_name)
			local camera = ScriptViewport.camera(viewport)
			local rotation = ScriptCamera.rotation(camera)
			local forward = Quaternion.forward(rotation)
			local flat = Vector3.flat(forward)
			local dot = Vector3.dot(forward, flat)
			local acos = math.acos(math.clamp(dot, -1, 1))
			local flag = math.atan2(forward.z - flat.z, forward.y - flat.y) > 0
			local flag_2 = get.y < 0

			if not (not flag and flag_2 and not not flag or not flag_2) then
				local angle_to_slow_down_inside = self.angle_to_slow_down_inside
				local clamp_3 = math.clamp(acos / angle_to_slow_down_inside, 0, 1)

				multiplier_y = math.lerp(self.multiplier_y, self.multiplier_return_y, clamp_3)
			end
		end

		local num_3 = get.y * multiplier_y * Managers.time._mean_dt
		local z = get.z

		return Vector3(var_9_5, num_3, z)
	end,
	edit_types = {
		{
			"multiplier_x",
			"number"
		},
		{
			"multiplier_y",
			"number"
		}
	}
}
InputFilters.scale_vector3_xy_accelerated_x_inverted = {
	init = function (arg_10_0)
		-- function 10
		local clone = table.clone(arg_10_0)

		clone.input_x = 0
		clone.input_x_t = 0

		local min_multiplier_x = clone.min_multiplier_x

		min_multiplier_x = min_multiplier_x or clone.multiplier_x * 0.25
		clone.min_multiplier_x = min_multiplier_x
		clone.input_x_turnaround_t = 0

		return clone
	end,
	update = function (self, arg_11_1)
		-- function 11
		local get = arg_11_1:get(self.input_mapping)
		local var_11_1 = fn
		local var_11_2 = get
		local input_threshold = self.input_threshold

		input_threshold = input_threshold or 0

		var_11_1(var_11_2, input_threshold)

		local time_since_launch = Application.time_since_launch()

		if not (not self.turnaround_threshold and not (math.abs(get.x) >= self.turnaround_threshold) or math.sign(get.x) == self.input_x_turnaround) then
			self.input_x_turnaround = math.sign(get.x)
			self.input_x_turnaround_t = time_since_launch
		elseif not (not (math.abs(get.x) >= self.threshold) or math.sign(get.x) == self.input_x) then
			self.input_x = math.sign(get.x)
			self.input_x_t = time_since_launch
		elseif not (not (math.abs(get.x) < self.threshold) or not (Vector3.length(get) < self.threshold)) then
			self.input_x_t = time_since_launch
		end

		if math.abs(get.x) < 0.1 then
			self.input_x = 0
		end

		if not (not self.turnaround_threshold and not (math.abs(get.x) < self.turnaround_threshold)) then
			self.input_x_turnaround = 0
		end

		local var_11_5
		local num = time_since_launch - self.input_x_t
		local num_2 = time_since_launch - self.input_x_turnaround_t

		if not Application.user_setting("enable_gamepad_acceleration") then
			var_11_5 = get.x * self.min_multiplier_x * Managers.time._mean_dt
		elseif not (not self.turnaround_threshold and not (num_2 >= self.acceleration_delay + self.turnaround_delay) or not (math.abs(get.x) >= self.turnaround_threshold)) then
			local clamp = math.clamp(num - (self.acceleration_delay + self.turnaround_delay) / self.turnaround_time_ref, 0, 1)

			var_11_5 = get.x * math.lerp(self.min_multiplier_x, self.turnaround_multiplier_x, math.pow(clamp, self.turnaround_power_of)) * Managers.time._mean_dt
		elseif num >= self.acceleration_delay then
			local clamp_2 = math.clamp((num - self.acceleration_delay) / self.accelerate_time_ref, 0, 1)

			var_11_5 = get.x * math.lerp(self.min_multiplier_x, self.multiplier_x, math.pow(clamp_2, self.power_of)) * Managers.time._mean_dt
		else
			var_11_5 = get.x * self.min_multiplier_x * Managers.time._mean_dt
		end

		local num_3 = -get.y * self.multiplier_y * Managers.time._mean_dt
		local z = get.z

		return Vector3(var_11_5, num_3, z)
	end,
	edit_types = {
		{
			"multiplier_x",
			"number"
		},
		{
			"multiplier_y",
			"number"
		}
	}
}
InputFilters.scale_vector3_invert_y = {
	init = function (arg_12_0)
		-- function 12
		return table.clone(arg_12_0)
	end,
	update = function (self, arg_13_1)
		-- function 13
		local var_13_0 = Vector3(Vector3.to_elements(arg_13_1:get(self.input_mapping)))
		local var_13_1 = fn
		local var_13_2 = var_13_0
		local input_threshold = self.input_threshold

		input_threshold = input_threshold or 0

		var_13_1(var_13_2, input_threshold)

		var_13_0.y = -var_13_0.y

		return var_13_0 * self.multiplier
	end,
	edit_types = {
		{
			"multiplier",
			"number"
		}
	}
}
InputFilters.gamepad_cursor = {
	init = function (arg_14_0)
		-- function 14
		local clone = table.clone(arg_14_0)
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local inv_scale = RESOLUTION_LOOKUP.inv_scale
		local num = res_w * inv_scale
		local num_2 = res_h * inv_scale

		clone.pos_x = num * 0.5
		clone.pos_y = num_2 * 0.5
		clone.frame_index = GLOBAL_FRAME_INDEX
		clone.input_x = 0
		clone.input_x_t = 0
		clone.input_x_turnaround_t = 0

		local min_multiplier_x = clone.min_multiplier_x

		min_multiplier_x = min_multiplier_x or clone.multiplier_x * 0.25
		clone.min_multiplier_x = min_multiplier_x
		clone.input_y = 0
		clone.input_y_t = 0
		clone.input_y_turnaround_t = 0

		local min_multiplier_y = clone.min_multiplier_y

		min_multiplier_y = min_multiplier_y or clone.multiplier_y * 0.25
		clone.min_multiplier_y = min_multiplier_y
		clone.hover_multiplier = clone.hover_multiplier

		return clone
	end,
	update = function (self, arg_15_1)
		-- function 15
		if not (not (GLOBAL_FRAME_INDEX > self.frame_index) or arg_15_1:is_blocked()) then
			local input = Managers.input

			if not input:gamepad_cursor_active() then
				return nil
			end

			local var_15_1 = Vector3(Vector3.to_elements(arg_15_1:get(self.input_mapping)))
			local var_15_2 = fn
			local var_15_3 = var_15_1
			local input_threshold = self.input_threshold

			input_threshold = input_threshold or 0

			var_15_2(var_15_3, input_threshold)

			local _mean_dt = Managers.time._mean_dt
			local time_since_launch = Application.time_since_launch()
			local var_15_7
			local var_15_8

			if not input:is_hovering() then
				var_15_7 = var_15_1.x * self.multiplier_x * _mean_dt * self.hover_multiplier
				var_15_8 = var_15_1.y * self.multiplier_y * _mean_dt * self.hover_multiplier
				self.input_start_time = nil
			else
				local num = 0

				if (math.abs(var_15_1.x) + math.abs(var_15_1.y)) * 0.5 < self.acceleration_threshold then
					self.input_start_time = nil
				elseif not self.input_start_time then
					num = time_since_launch - self.input_start_time
				else
					self.input_start_time = time_since_launch
				end

				local clamp = math.clamp((num - self.acceleration_delay) / self.accelerate_time_ref, 0, 1)
				local lerp = math.lerp(self.min_multiplier_x, self.multiplier_x, clamp)

				var_15_7 = var_15_1.x * lerp * _mean_dt

				local lerp_2 = math.lerp(self.min_multiplier_y, self.multiplier_y, clamp)

				var_15_8 = var_15_1.y * lerp_2 * _mean_dt
			end

			local get_gamepad_cursor_pos, var_15_14 = input:get_gamepad_cursor_pos()

			self.pos_x = get_gamepad_cursor_pos or self.pos_x
			self.pos_y = var_15_14 or self.pos_y

			local res_w = RESOLUTION_LOOKUP.res_w
			local res_h = RESOLUTION_LOOKUP.res_h
			local inv_scale = RESOLUTION_LOOKUP.inv_scale
			local num_2 = res_w * inv_scale
			local num_3 = res_h * inv_scale
			local num_4 = 0.03333333333333333
			local num_5 = self.pos_x + var_15_7 * num_4 * self.multiplier
			local num_6 = self.pos_y + var_15_8 * num_4 * self.multiplier

			self.pos_x = (not (num_2 < num_5) or not num_2 or not (num_5 < 0)) and (0 or num_5)
			self.pos_y = (not (num_3 < num_6) or not num_3 or not (num_6 < 0)) and (0 or num_6)
			self.frame_index = GLOBAL_FRAME_INDEX
		end

		return Vector3(self.pos_x, self.pos_y, 0)
	end,
	edit_types = {
		{
			"multiplier",
			"number"
		}
	}
}
InputFilters.threshhold = {
	init = function (arg_16_0)
		-- function 16
		return table.clone(arg_16_0)
	end,
	update = function (self, arg_17_1)
		-- function 17
		if arg_17_1:get(self.input_mapping) >= self.threshhold then
			return false
		else
			return true
		end
	end
}
InputFilters.move_filter = {
	init = function (self)
		-- function 18
		local clone = table.clone(self)
		local var_18_1 = Vector3(unpack(self.axis))
		local normalize = Vector3.normalize(var_18_1)

		clone.axis = Vector3Box(normalize)

		return clone
	end,
	update = function (self, arg_19_1)
		-- function 19
		for k, v in pairs(self.input_mappings) do
			if not arg_19_1:get(v) then
				return true
			end
		end

		local unbox = self.axis:unbox()

		for k_2, v_2 in pairs(self.axis_mappings) do
			local get = arg_19_1:get(v_2)

			if not (not get and not (Vector3.dot(get, unbox) >= self.threshold)) then
				if not self.axis_pressed then
					return false
				else
					self.axis_pressed = not self.hold

					return true
				end
			else
				self.axis_pressed = false
			end
		end

		return false
	end
}
InputFilters.move_filter_continuous = {
	init = function (self)
		-- function 20
		local clone = table.clone(self)
		local var_20_1 = Vector3(unpack(self.axis))
		local normalize = Vector3.normalize(var_20_1)

		clone.axis = Vector3Box(normalize)
		clone.cooldown = 0
		clone.cooldown_speed_multiplier = 1

		return clone
	end,
	update = function (self, arg_21_1)
		-- function 21
		local mean_dt = Managers.time:mean_dt()

		self.cooldown = math.max(self.cooldown - mean_dt, 0)

		local flag = self.cooldown > 0
		local flag_2 = false

		for k, v in pairs(self.input_mappings) do
			if not arg_21_1:get(v) then
				flag_2 = true
			end
		end

		local flag_3 = false
		local unbox = self.axis:unbox()

		for k_2, v_2 in pairs(self.axis_mappings) do
			local get = arg_21_1:get(v_2)

			if not (not get and not (Vector3.dot(get, unbox) >= self.threshold)) then
				flag_3 = true
			end
		end

		if not flag and flag_2 and not flag_3 then
			local menu_min_speed_multiplier = GamepadSettings.menu_min_speed_multiplier
			local menu_speed_multiplier_decrease = GamepadSettings.menu_speed_multiplier_decrease

			self.cooldown_speed_multiplier = math.max(self.cooldown_speed_multiplier - menu_speed_multiplier_decrease * mean_dt, menu_min_speed_multiplier)
		end

		if not (flag_2 or flag_3) then
			self.cooldown_speed_multiplier = 1
			self.cooldown = 0
		end

		if flag or flag_2 or not flag_3 then
			self.cooldown = GamepadSettings.menu_cooldown * self.cooldown_speed_multiplier

			return true
		end

		return false
	end
}
InputFilters["or"] = {
	init = function (arg_22_0)
		-- function 22
		return table.clone(arg_22_0)
	end,
	update = function (self, arg_23_1)
		-- function 23
		for k, v in pairs(self.input_mappings) do
			if not arg_23_1:get(v) then
				return true
			end
		end
	end
}
InputFilters["and"] = {
	init = function (arg_24_0)
		-- function 24
		return table.clone(arg_24_0)
	end,
	update = function (self, arg_25_1)
		-- function 25
		local var_25_0

		for k, v in pairs(self.input_mappings) do
			if not arg_25_1:get(v) then
				var_25_0 = false
			elseif var_25_0 == nil then
				var_25_0 = true
			end
		end

		return var_25_0
	end
}
InputFilters.multiple_and = {
	init = function (arg_26_0)
		-- function 26
		return table.clone(arg_26_0)
	end,
	update = function (self, arg_27_1)
		-- function 27
		for i, v in ipairs(self.input_mappings) do
			local var_27_0

			for k, v_2 in pairs(v) do
				if not arg_27_1:get(v_2) then
					var_27_0 = false
				elseif var_27_0 == nil then
					var_27_0 = true
				end
			end

			if not var_27_0 then
				return var_27_0
			end
		end

		return false
	end
}
InputFilters.sub = {
	init = function (arg_28_0)
		-- function 28
		return table.clone(arg_28_0)
	end,
	update = function (self, arg_29_1)
		-- function 29
		local num = 0
		local var_29_1

		for k, v in pairs(self.input_mappings) do
			local get = arg_29_1:get(v)

			if not var_29_1 then
				num = var_29_1 - get
				var_29_1 = num
			else
				var_29_1 = get
			end
		end

		return num
	end
}
InputFilters.delayed_and = {
	init = function (arg_30_0)
		-- function 30
		local clone = table.clone(arg_30_0)

		clone.timer = 0
		clone.pressed = {}

		return clone
	end,
	update = function (self, arg_31_1)
		-- function 31
		local var_31_0
		local var_31_1

		for k, v in pairs(self.input_mappings) do
			if not arg_31_1:get(v) then
				var_31_0 = false
			elseif var_31_0 == nil then
				var_31_0 = true
				self.pressed[v] = true
				var_31_1 = true
			else
				self.pressed[v] = true
				var_31_1 = true
			end
		end

		if not var_31_0 then
			return var_31_0
		end

		local time_since_launch = Application.time_since_launch()

		if not var_31_1 then
			self.timer = time_since_launch + self.max_delay
		end

		if time_since_launch < self.timer then
			var_31_0 = nil

			for k_2, v_2 in pairs(self.input_mappings) do
				if not self.pressed[v_2] then
					var_31_0 = false
				elseif var_31_0 == nil then
					var_31_0 = true
				end
			end
		else
			table.clear(self.pressed)
		end

		return var_31_0
	end
}
InputFilters.exclusive_and = {
	init = function (arg_32_0)
		-- function 32
		return table.clone(arg_32_0)
	end,
	update = function (self, arg_33_1)
		-- function 33
		local var_33_0

		for k, v in pairs(self.input_mappings) do
			if not arg_33_1:get(v) then
				var_33_0 = false
			elseif var_33_0 == nil then
				var_33_0 = true
			end
		end

		for k_2, v_2 in pairs(self.exclusive_input_mappings) do
			if not arg_33_1:get(v_2) then
				var_33_0 = false

				break
			end
		end

		return var_33_0
	end
}
InputFilters.axis_check = {
	init = function (arg_34_0)
		-- function 34
		local clone = table.clone(arg_34_0)
		local axis = clone.axis

		clone.axis = Vector3Box(Vector3(axis[1], axis[2], axis[3]))

		return clone
	end,
	update = function (self, arg_35_1)
		-- function 35
		local axis_requirement = self.axis_requirement
		local get = arg_35_1:get(self.input_mapping)

		if not get then
			return false
		end

		return axis_requirement <= Vector3.dot(self.axis:unbox(), get)
	end
}
InputFilters["not"] = {
	init = function (arg_36_0)
		-- function 36
		return table.clone(arg_36_0)
	end,
	update = function (self, arg_37_1)
		-- function 37
		for k, v in pairs(self.input_mappings) do
			if not arg_37_1:get(v) then
				return true
			end
		end
	end
}
