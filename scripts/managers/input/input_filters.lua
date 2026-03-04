-- chunkname: @scripts/managers/input/input_filters.lua

InputFilters = InputFilters or {}

local function var_0_0(arg_1_0, arg_1_1)
	if arg_1_1 > Vector3.length(arg_1_0) then
		arg_1_0.x = 0
		arg_1_0.y = 0
		arg_1_0.z = 0
	end
end

InputFilters.virtual_axis = {
	init = function (arg_2_0)
		return table.clone(arg_2_0)
	end,
	update = function (arg_3_0, arg_3_1)
		local var_3_0 = arg_3_0.input_mappings
		local var_3_1 = arg_3_1:get(var_3_0.right)
		local var_3_2 = arg_3_1:get(var_3_0.left)
		local var_3_3 = arg_3_1:get(var_3_0.forward)
		local var_3_4 = arg_3_1:get(var_3_0.back)
		local var_3_5 = var_3_0.up
		local var_3_6 = var_3_5 and arg_3_1:get(var_3_5) or 0
		local var_3_7 = var_3_0.down
		local var_3_8 = var_3_7 and arg_3_1:get(var_3_7) or 0

		return (Vector3(var_3_1 - var_3_2, var_3_3 - var_3_4, var_3_6 - var_3_8))
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
		return table.clone(arg_4_0)
	end,
	update = function (arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1:get(arg_5_0.input_mapping)

		var_0_0(var_5_0, arg_5_0.input_threshold or 0)

		return var_5_0 * arg_5_0.multiplier
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
		return table.clone(arg_6_0)
	end,
	update = function (arg_7_0, arg_7_1)
		local var_7_0 = arg_7_1:get(arg_7_0.input_mapping)

		var_0_0(var_7_0, arg_7_0.input_threshold or 0)

		local var_7_1 = var_7_0.x * arg_7_0.multiplier_x
		local var_7_2 = var_7_0.y * arg_7_0.multiplier_y
		local var_7_3 = var_7_0.z

		return Vector3(var_7_1, var_7_2, var_7_3)
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
		local var_8_0 = table.clone(arg_8_0)

		var_8_0.input_x = 0
		var_8_0.input_x_t = 0
		var_8_0.input_x_turnaround_t = 0
		var_8_0.min_multiplier_x = var_8_0.min_multiplier_x or var_8_0.multiplier_x * 0.25

		return var_8_0
	end,
	update = function (arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1:get(arg_9_0.input_mapping)

		var_0_0(var_9_0, arg_9_0.input_threshold or 0)

		local var_9_1 = Application.time_since_launch()

		if arg_9_0.turnaround_threshold and math.abs(var_9_0.x) >= arg_9_0.turnaround_threshold and math.sign(var_9_0.x) ~= arg_9_0.input_x_turnaround then
			arg_9_0.input_x_turnaround = math.sign(var_9_0.x)
			arg_9_0.input_x_turnaround_t = var_9_1
		elseif math.abs(var_9_0.x) >= arg_9_0.threshold and math.sign(var_9_0.x) ~= arg_9_0.input_x then
			arg_9_0.input_x = math.sign(var_9_0.x)
			arg_9_0.input_x_t = var_9_1
		elseif math.abs(var_9_0.x) < arg_9_0.threshold and Vector3.length(var_9_0) < arg_9_0.threshold then
			arg_9_0.input_x_t = var_9_1
		end

		if math.abs(var_9_0.x) < 0.1 then
			arg_9_0.input_x = 0
		end

		if arg_9_0.turnaround_threshold and math.abs(var_9_0.x) < arg_9_0.turnaround_threshold then
			arg_9_0.input_x_turnaround = 0
		end

		local var_9_2
		local var_9_3 = var_9_1 - arg_9_0.input_x_t
		local var_9_4 = var_9_1 - arg_9_0.input_x_turnaround_t

		if math.abs(var_9_0.x) > 0.75 then
			var_9_0.y = var_9_0.y * (1 - (math.abs(var_9_0.x) - 0.75) / 0.25)
		end

		if not Application.user_setting("enable_gamepad_acceleration") then
			var_9_2 = var_9_0.x * arg_9_0.min_multiplier_x * Managers.time._mean_dt
		elseif arg_9_0.turnaround_threshold and var_9_4 >= arg_9_0.acceleration_delay + arg_9_0.turnaround_delay and math.abs(var_9_0.x) >= arg_9_0.turnaround_threshold then
			local var_9_5 = math.clamp(var_9_3 - (arg_9_0.acceleration_delay + arg_9_0.turnaround_delay) / arg_9_0.turnaround_time_ref, 0, 1)

			var_9_2 = var_9_0.x * math.lerp(arg_9_0.min_multiplier_x, arg_9_0.turnaround_multiplier_x, math.pow(var_9_5, arg_9_0.turnaround_power_of)) * Managers.time._mean_dt
		elseif var_9_3 >= arg_9_0.acceleration_delay then
			local var_9_6 = math.clamp((var_9_3 - arg_9_0.acceleration_delay) / arg_9_0.accelerate_time_ref, 0, 1)

			var_9_2 = var_9_0.x * math.lerp(arg_9_0.min_multiplier_x, arg_9_0.multiplier_x, math.pow(var_9_6, arg_9_0.power_of)) * Managers.time._mean_dt
		else
			var_9_2 = var_9_0.x * arg_9_0.min_multiplier_x * Managers.time._mean_dt
		end

		local var_9_7 = arg_9_0.multiplier_y

		if var_9_0.y ~= 0 and arg_9_0.multiplier_return_y and arg_9_0.angle_to_slow_down_inside and Application.user_setting("enable_gamepad_acceleration") then
			local var_9_8 = Managers.player:local_player().viewport_name
			local var_9_9 = Managers.world:world("level_world")
			local var_9_10 = ScriptWorld.viewport(var_9_9, var_9_8)
			local var_9_11 = ScriptViewport.camera(var_9_10)
			local var_9_12 = ScriptCamera.rotation(var_9_11)
			local var_9_13 = Quaternion.forward(var_9_12)
			local var_9_14 = Vector3.flat(var_9_13)
			local var_9_15 = Vector3.dot(var_9_13, var_9_14)
			local var_9_16 = math.acos(math.clamp(var_9_15, -1, 1))
			local var_9_17 = math.atan2(var_9_13.z - var_9_14.z, var_9_13.y - var_9_14.y) > 0
			local var_9_18 = var_9_0.y < 0

			if var_9_17 and var_9_18 or not var_9_17 and not var_9_18 then
				local var_9_19 = arg_9_0.angle_to_slow_down_inside
				local var_9_20 = math.clamp(var_9_16 / var_9_19, 0, 1)

				var_9_7 = math.lerp(arg_9_0.multiplier_y, arg_9_0.multiplier_return_y, var_9_20)
			end
		end

		local var_9_21 = var_9_0.y * var_9_7 * Managers.time._mean_dt
		local var_9_22 = var_9_0.z

		return Vector3(var_9_2, var_9_21, var_9_22)
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
		local var_10_0 = table.clone(arg_10_0)

		var_10_0.input_x = 0
		var_10_0.input_x_t = 0
		var_10_0.min_multiplier_x = var_10_0.min_multiplier_x or var_10_0.multiplier_x * 0.25
		var_10_0.input_x_turnaround_t = 0

		return var_10_0
	end,
	update = function (arg_11_0, arg_11_1)
		local var_11_0 = arg_11_1:get(arg_11_0.input_mapping)

		var_0_0(var_11_0, arg_11_0.input_threshold or 0)

		local var_11_1 = Application.time_since_launch()

		if arg_11_0.turnaround_threshold and math.abs(var_11_0.x) >= arg_11_0.turnaround_threshold and math.sign(var_11_0.x) ~= arg_11_0.input_x_turnaround then
			arg_11_0.input_x_turnaround = math.sign(var_11_0.x)
			arg_11_0.input_x_turnaround_t = var_11_1
		elseif math.abs(var_11_0.x) >= arg_11_0.threshold and math.sign(var_11_0.x) ~= arg_11_0.input_x then
			arg_11_0.input_x = math.sign(var_11_0.x)
			arg_11_0.input_x_t = var_11_1
		elseif math.abs(var_11_0.x) < arg_11_0.threshold and Vector3.length(var_11_0) < arg_11_0.threshold then
			arg_11_0.input_x_t = var_11_1
		end

		if math.abs(var_11_0.x) < 0.1 then
			arg_11_0.input_x = 0
		end

		if arg_11_0.turnaround_threshold and math.abs(var_11_0.x) < arg_11_0.turnaround_threshold then
			arg_11_0.input_x_turnaround = 0
		end

		local var_11_2
		local var_11_3 = var_11_1 - arg_11_0.input_x_t
		local var_11_4 = var_11_1 - arg_11_0.input_x_turnaround_t

		if not Application.user_setting("enable_gamepad_acceleration") then
			var_11_2 = var_11_0.x * arg_11_0.min_multiplier_x * Managers.time._mean_dt
		elseif arg_11_0.turnaround_threshold and var_11_4 >= arg_11_0.acceleration_delay + arg_11_0.turnaround_delay and math.abs(var_11_0.x) >= arg_11_0.turnaround_threshold then
			local var_11_5 = math.clamp(var_11_3 - (arg_11_0.acceleration_delay + arg_11_0.turnaround_delay) / arg_11_0.turnaround_time_ref, 0, 1)

			var_11_2 = var_11_0.x * math.lerp(arg_11_0.min_multiplier_x, arg_11_0.turnaround_multiplier_x, math.pow(var_11_5, arg_11_0.turnaround_power_of)) * Managers.time._mean_dt
		elseif var_11_3 >= arg_11_0.acceleration_delay then
			local var_11_6 = math.clamp((var_11_3 - arg_11_0.acceleration_delay) / arg_11_0.accelerate_time_ref, 0, 1)

			var_11_2 = var_11_0.x * math.lerp(arg_11_0.min_multiplier_x, arg_11_0.multiplier_x, math.pow(var_11_6, arg_11_0.power_of)) * Managers.time._mean_dt
		else
			var_11_2 = var_11_0.x * arg_11_0.min_multiplier_x * Managers.time._mean_dt
		end

		local var_11_7 = -var_11_0.y * arg_11_0.multiplier_y * Managers.time._mean_dt
		local var_11_8 = var_11_0.z

		return Vector3(var_11_2, var_11_7, var_11_8)
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
		return table.clone(arg_12_0)
	end,
	update = function (arg_13_0, arg_13_1)
		local var_13_0 = Vector3(Vector3.to_elements(arg_13_1:get(arg_13_0.input_mapping)))

		var_0_0(var_13_0, arg_13_0.input_threshold or 0)

		var_13_0.y = -var_13_0.y

		return var_13_0 * arg_13_0.multiplier
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
		local var_14_0 = table.clone(arg_14_0)
		local var_14_1 = RESOLUTION_LOOKUP.res_w
		local var_14_2 = RESOLUTION_LOOKUP.res_h
		local var_14_3 = RESOLUTION_LOOKUP.inv_scale
		local var_14_4 = var_14_1 * var_14_3
		local var_14_5 = var_14_2 * var_14_3

		var_14_0.pos_x = var_14_4 * 0.5
		var_14_0.pos_y = var_14_5 * 0.5
		var_14_0.frame_index = GLOBAL_FRAME_INDEX
		var_14_0.input_x = 0
		var_14_0.input_x_t = 0
		var_14_0.input_x_turnaround_t = 0
		var_14_0.min_multiplier_x = var_14_0.min_multiplier_x or var_14_0.multiplier_x * 0.25
		var_14_0.input_y = 0
		var_14_0.input_y_t = 0
		var_14_0.input_y_turnaround_t = 0
		var_14_0.min_multiplier_y = var_14_0.min_multiplier_y or var_14_0.multiplier_y * 0.25
		var_14_0.hover_multiplier = var_14_0.hover_multiplier

		return var_14_0
	end,
	update = function (arg_15_0, arg_15_1)
		if GLOBAL_FRAME_INDEX > arg_15_0.frame_index and not arg_15_1:is_blocked() then
			local var_15_0 = Managers.input

			if not var_15_0:gamepad_cursor_active() then
				return nil
			end

			local var_15_1 = Vector3(Vector3.to_elements(arg_15_1:get(arg_15_0.input_mapping)))

			var_0_0(var_15_1, arg_15_0.input_threshold or 0)

			local var_15_2 = Managers.time._mean_dt
			local var_15_3 = Application.time_since_launch()
			local var_15_4
			local var_15_5

			if var_15_0:is_hovering() then
				var_15_4 = var_15_1.x * arg_15_0.multiplier_x * var_15_2 * arg_15_0.hover_multiplier
				var_15_5 = var_15_1.y * arg_15_0.multiplier_y * var_15_2 * arg_15_0.hover_multiplier
				arg_15_0.input_start_time = nil
			else
				local var_15_6 = 0

				if (math.abs(var_15_1.x) + math.abs(var_15_1.y)) * 0.5 < arg_15_0.acceleration_threshold then
					arg_15_0.input_start_time = nil
				elseif arg_15_0.input_start_time then
					var_15_6 = var_15_3 - arg_15_0.input_start_time
				else
					arg_15_0.input_start_time = var_15_3
				end

				local var_15_7 = math.clamp((var_15_6 - arg_15_0.acceleration_delay) / arg_15_0.accelerate_time_ref, 0, 1)
				local var_15_8 = math.lerp(arg_15_0.min_multiplier_x, arg_15_0.multiplier_x, var_15_7)

				var_15_4 = var_15_1.x * var_15_8 * var_15_2

				local var_15_9 = math.lerp(arg_15_0.min_multiplier_y, arg_15_0.multiplier_y, var_15_7)

				var_15_5 = var_15_1.y * var_15_9 * var_15_2
			end

			local var_15_10, var_15_11 = var_15_0:get_gamepad_cursor_pos()

			arg_15_0.pos_x = var_15_10 or arg_15_0.pos_x
			arg_15_0.pos_y = var_15_11 or arg_15_0.pos_y

			local var_15_12 = RESOLUTION_LOOKUP.res_w
			local var_15_13 = RESOLUTION_LOOKUP.res_h
			local var_15_14 = RESOLUTION_LOOKUP.inv_scale
			local var_15_15 = var_15_12 * var_15_14
			local var_15_16 = var_15_13 * var_15_14
			local var_15_17 = 0.03333333333333333
			local var_15_18 = arg_15_0.pos_x + var_15_4 * var_15_17 * arg_15_0.multiplier
			local var_15_19 = arg_15_0.pos_y + var_15_5 * var_15_17 * arg_15_0.multiplier

			arg_15_0.pos_x = var_15_15 < var_15_18 and var_15_15 or var_15_18 < 0 and 0 or var_15_18
			arg_15_0.pos_y = var_15_16 < var_15_19 and var_15_16 or var_15_19 < 0 and 0 or var_15_19
			arg_15_0.frame_index = GLOBAL_FRAME_INDEX
		end

		return Vector3(arg_15_0.pos_x, arg_15_0.pos_y, 0)
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
		return table.clone(arg_16_0)
	end,
	update = function (arg_17_0, arg_17_1)
		if arg_17_1:get(arg_17_0.input_mapping) >= arg_17_0.threshhold then
			return false
		else
			return true
		end
	end
}
InputFilters.move_filter = {
	init = function (arg_18_0)
		local var_18_0 = table.clone(arg_18_0)
		local var_18_1 = Vector3(unpack(arg_18_0.axis))
		local var_18_2 = Vector3.normalize(var_18_1)

		var_18_0.axis = Vector3Box(var_18_2)

		return var_18_0
	end,
	update = function (arg_19_0, arg_19_1)
		for iter_19_0, iter_19_1 in pairs(arg_19_0.input_mappings) do
			if arg_19_1:get(iter_19_1) then
				return true
			end
		end

		local var_19_0 = arg_19_0.axis:unbox()

		for iter_19_2, iter_19_3 in pairs(arg_19_0.axis_mappings) do
			local var_19_1 = arg_19_1:get(iter_19_3)

			if var_19_1 and Vector3.dot(var_19_1, var_19_0) >= arg_19_0.threshold then
				if arg_19_0.axis_pressed then
					return false
				else
					arg_19_0.axis_pressed = not arg_19_0.hold

					return true
				end
			else
				arg_19_0.axis_pressed = false
			end
		end

		return false
	end
}
InputFilters.move_filter_continuous = {
	init = function (arg_20_0)
		local var_20_0 = table.clone(arg_20_0)
		local var_20_1 = Vector3(unpack(arg_20_0.axis))
		local var_20_2 = Vector3.normalize(var_20_1)

		var_20_0.axis = Vector3Box(var_20_2)
		var_20_0.cooldown = 0
		var_20_0.cooldown_speed_multiplier = 1

		return var_20_0
	end,
	update = function (arg_21_0, arg_21_1)
		local var_21_0 = Managers.time:mean_dt()

		arg_21_0.cooldown = math.max(arg_21_0.cooldown - var_21_0, 0)

		local var_21_1 = arg_21_0.cooldown > 0
		local var_21_2 = false

		for iter_21_0, iter_21_1 in pairs(arg_21_0.input_mappings) do
			if arg_21_1:get(iter_21_1) then
				var_21_2 = true
			end
		end

		local var_21_3 = false
		local var_21_4 = arg_21_0.axis:unbox()

		for iter_21_2, iter_21_3 in pairs(arg_21_0.axis_mappings) do
			local var_21_5 = arg_21_1:get(iter_21_3)

			if var_21_5 and Vector3.dot(var_21_5, var_21_4) >= arg_21_0.threshold then
				var_21_3 = true
			end
		end

		if var_21_1 and (var_21_2 or var_21_3) then
			local var_21_6 = GamepadSettings.menu_min_speed_multiplier
			local var_21_7 = GamepadSettings.menu_speed_multiplier_decrease

			arg_21_0.cooldown_speed_multiplier = math.max(arg_21_0.cooldown_speed_multiplier - var_21_7 * var_21_0, var_21_6)
		end

		if not var_21_2 and not var_21_3 then
			arg_21_0.cooldown_speed_multiplier = 1
			arg_21_0.cooldown = 0
		end

		if not var_21_1 and (var_21_2 or var_21_3) then
			arg_21_0.cooldown = GamepadSettings.menu_cooldown * arg_21_0.cooldown_speed_multiplier

			return true
		end

		return false
	end
}
InputFilters["or"] = {
	init = function (arg_22_0)
		return table.clone(arg_22_0)
	end,
	update = function (arg_23_0, arg_23_1)
		for iter_23_0, iter_23_1 in pairs(arg_23_0.input_mappings) do
			if arg_23_1:get(iter_23_1) then
				return true
			end
		end
	end
}
InputFilters["and"] = {
	init = function (arg_24_0)
		return table.clone(arg_24_0)
	end,
	update = function (arg_25_0, arg_25_1)
		local var_25_0

		for iter_25_0, iter_25_1 in pairs(arg_25_0.input_mappings) do
			if not arg_25_1:get(iter_25_1) then
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
		return table.clone(arg_26_0)
	end,
	update = function (arg_27_0, arg_27_1)
		for iter_27_0, iter_27_1 in ipairs(arg_27_0.input_mappings) do
			local var_27_0

			for iter_27_2, iter_27_3 in pairs(iter_27_1) do
				if not arg_27_1:get(iter_27_3) then
					var_27_0 = false
				elseif var_27_0 == nil then
					var_27_0 = true
				end
			end

			if var_27_0 then
				return var_27_0
			end
		end

		return false
	end
}
InputFilters.sub = {
	init = function (arg_28_0)
		return table.clone(arg_28_0)
	end,
	update = function (arg_29_0, arg_29_1)
		local var_29_0 = 0
		local var_29_1

		for iter_29_0, iter_29_1 in pairs(arg_29_0.input_mappings) do
			local var_29_2 = arg_29_1:get(iter_29_1)

			if var_29_1 then
				var_29_0 = var_29_1 - var_29_2
				var_29_1 = var_29_0
			else
				var_29_1 = var_29_2
			end
		end

		return var_29_0
	end
}
InputFilters.delayed_and = {
	init = function (arg_30_0)
		local var_30_0 = table.clone(arg_30_0)

		var_30_0.timer = 0
		var_30_0.pressed = {}

		return var_30_0
	end,
	update = function (arg_31_0, arg_31_1)
		local var_31_0
		local var_31_1

		for iter_31_0, iter_31_1 in pairs(arg_31_0.input_mappings) do
			if not arg_31_1:get(iter_31_1) then
				var_31_0 = false
			elseif var_31_0 == nil then
				var_31_0 = true
				arg_31_0.pressed[iter_31_1] = true
				var_31_1 = true
			else
				arg_31_0.pressed[iter_31_1] = true
				var_31_1 = true
			end
		end

		if var_31_0 then
			return var_31_0
		end

		local var_31_2 = Application.time_since_launch()

		if var_31_1 then
			arg_31_0.timer = var_31_2 + arg_31_0.max_delay
		end

		if var_31_2 < arg_31_0.timer then
			var_31_0 = nil

			for iter_31_2, iter_31_3 in pairs(arg_31_0.input_mappings) do
				if not arg_31_0.pressed[iter_31_3] then
					var_31_0 = false
				elseif var_31_0 == nil then
					var_31_0 = true
				end
			end
		else
			table.clear(arg_31_0.pressed)
		end

		return var_31_0
	end
}
InputFilters.exclusive_and = {
	init = function (arg_32_0)
		return table.clone(arg_32_0)
	end,
	update = function (arg_33_0, arg_33_1)
		local var_33_0

		for iter_33_0, iter_33_1 in pairs(arg_33_0.input_mappings) do
			if not arg_33_1:get(iter_33_1) then
				var_33_0 = false
			elseif var_33_0 == nil then
				var_33_0 = true
			end
		end

		for iter_33_2, iter_33_3 in pairs(arg_33_0.exclusive_input_mappings) do
			if arg_33_1:get(iter_33_3) then
				var_33_0 = false

				break
			end
		end

		return var_33_0
	end
}
InputFilters.axis_check = {
	init = function (arg_34_0)
		local var_34_0 = table.clone(arg_34_0)
		local var_34_1 = var_34_0.axis

		var_34_0.axis = Vector3Box(Vector3(var_34_1[1], var_34_1[2], var_34_1[3]))

		return var_34_0
	end,
	update = function (arg_35_0, arg_35_1)
		local var_35_0 = arg_35_0.axis_requirement
		local var_35_1 = arg_35_1:get(arg_35_0.input_mapping)

		if not var_35_1 then
			return false
		end

		return var_35_0 <= Vector3.dot(arg_35_0.axis:unbox(), var_35_1)
	end
}
InputFilters["not"] = {
	init = function (arg_36_0)
		return table.clone(arg_36_0)
	end,
	update = function (arg_37_0, arg_37_1)
		for iter_37_0, iter_37_1 in pairs(arg_37_0.input_mappings) do
			if not arg_37_1:get(iter_37_1) then
				return true
			end
		end
	end
}
