-- chunkname: @scripts/ui/ui_animations.lua

require("scripts/utils/varargs")

UIAnimation = UIAnimation or {
	catmullrom = {
		num_args = 8,
		num_data = 1,
		init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
			if arg_1_1 then
				arg_1_0[arg_1_1] = arg_1_4 * arg_1_2
			else
				local var_1_0 = arg_1_4 * arg_1_2

				for iter_1_0 = 1, #arg_1_0 do
					arg_1_0[iter_1_0] = var_1_0
				end
			end

			return 0
		end,
		update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
			arg_2_9 = arg_2_9 + arg_2_0

			local var_2_0 = math.min(arg_2_9 / arg_2_8, 1)
			local var_2_1 = math.catmullrom(var_2_0, arg_2_4, arg_2_5, arg_2_6, arg_2_7) * arg_2_3

			if arg_2_2 then
				arg_2_1[arg_2_2] = var_2_1
			else
				for iter_2_0 = 1, #arg_2_1 do
					arg_2_1[iter_2_0] = var_2_1
				end
			end

			return arg_2_9 <= arg_2_8, arg_2_9
		end
	},
	size_offset_scale = {
		num_args = 9,
		num_data = 1,
		init = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
			local var_3_0 = arg_3_5 * arg_3_3
			local var_3_1 = (arg_3_3 - var_3_0) * 0.5

			if arg_3_2 then
				arg_3_0[arg_3_2] = var_3_0
				arg_3_1[arg_3_2] = var_3_1
			else
				for iter_3_0 = 1, #arg_3_0 do
					arg_3_0[iter_3_0] = var_3_0
					arg_3_1[iter_3_0] = var_3_1
				end
			end

			return 0
		end,
		update = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
			arg_4_10 = arg_4_10 + arg_4_0

			local var_4_0 = math.min(arg_4_10 / arg_4_9, 1)
			local var_4_1 = math.catmullrom(var_4_0, arg_4_5, arg_4_6, arg_4_7, arg_4_8) * arg_4_4
			local var_4_2 = (arg_4_4 - var_4_1) * 0.5

			if arg_4_3 then
				arg_4_1[arg_4_3] = var_4_1
				arg_4_2[i] = var_4_2
			else
				for iter_4_0 = 1, #arg_4_1 do
					arg_4_1[iter_4_0] = var_4_1
					arg_4_2[iter_4_0] = var_4_2
				end
			end

			return arg_4_10 <= arg_4_9, arg_4_10
		end
	},
	pulse_animation = {
		num_args = 5,
		num_data = 1,
		init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			arg_5_0[arg_5_1] = arg_5_2

			return 0
		end,
		update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
			arg_6_6 = arg_6_6 + arg_6_0

			local var_6_0 = math.sin(arg_6_6 * arg_6_5)

			arg_6_1[arg_6_2] = arg_6_3 + var_6_0 * var_6_0 * (arg_6_4 - arg_6_3)

			return true, arg_6_6
		end
	},
	pulse_animation2 = {
		num_args = 4,
		num_data = 1,
		init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			return 0
		end,
		update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			arg_8_5 = arg_8_5 + arg_8_0

			local var_8_0 = math.sin(arg_8_5 * arg_8_4)

			for iter_8_0, iter_8_1 in pairs(arg_8_1) do
				local var_8_1 = arg_8_2[iter_8_0] + var_8_0 * var_8_0 * (arg_8_3[iter_8_0] - arg_8_2[iter_8_0])

				arg_8_1[iter_8_0] = math.floor(var_8_1)
			end

			return true, arg_8_5
		end
	},
	pulse_animation3 = {
		num_args = 6,
		num_data = 1,
		init = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
			return 0
		end,
		update = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
			arg_10_7 = arg_10_7 + arg_10_0 * arg_10_5

			local var_10_0 = arg_10_7 <= arg_10_6 * arg_10_5
			local var_10_1

			if var_10_0 then
				var_10_1 = math.sirp(arg_10_3, arg_10_4, arg_10_7)
			else
				var_10_1 = arg_10_3
			end

			arg_10_1[arg_10_2] = var_10_1

			return var_10_0, arg_10_7
		end
	},
	text_flash = {
		num_args = 6,
		num_data = 1,
		init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
			return 0
		end,
		update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
			arg_12_7 = arg_12_7 + arg_12_0 * arg_12_5

			local var_12_0 = arg_12_7 <= arg_12_6 * arg_12_5
			local var_12_1

			if var_12_0 then
				var_12_1 = math.sirp(arg_12_3, arg_12_4, arg_12_7)
			else
				var_12_1 = arg_12_3
			end

			for iter_12_0 = 2, #arg_12_1 do
				arg_12_1[iter_12_0] = var_12_1
			end

			return var_12_0, arg_12_7
		end
	},
	update_function_by_time = {
		num_args = 6,
		num_data = 1,
		init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			arg_13_0[arg_13_1] = arg_13_2

			return 0
		end,
		update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
			arg_14_7 = arg_14_7 + arg_14_0
			arg_14_1[arg_14_2] = arg_14_3 + arg_14_6(arg_14_7) * (arg_14_4 - arg_14_3)

			return true, arg_14_7
		end
	},
	linear_scale2 = {
		num_args = 6,
		num_data = 1,
		init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
			return 0
		end,
		update = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
			arg_16_7 = arg_16_7 + arg_16_0

			local var_16_0 = arg_16_7 / arg_16_6

			arg_16_1[1] = (arg_16_4 - arg_16_2) * var_16_0 + arg_16_2
			arg_16_1[2] = (arg_16_5 - arg_16_3) * var_16_0 + arg_16_3

			return arg_16_7 <= arg_16_6, arg_16_7
		end
	},
	linear_scale_color = {
		num_args = 8,
		num_data = 1,
		init = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
			return 0
		end,
		update = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9)
			arg_18_9 = arg_18_9 + arg_18_0

			local var_18_0 = math.min(1, arg_18_9 / arg_18_8)

			arg_18_1[2] = (arg_18_5 - arg_18_2) * var_18_0 + arg_18_2
			arg_18_1[3] = (arg_18_6 - arg_18_3) * var_18_0 + arg_18_3
			arg_18_1[4] = (arg_18_7 - arg_18_4) * var_18_0 + arg_18_4

			return arg_18_9 <= arg_18_8, arg_18_9
		end
	},
	function_by_time = {
		num_args = 6,
		num_data = 1,
		init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			arg_19_0[arg_19_1] = arg_19_2

			return 0
		end,
		update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7)
			arg_20_7 = arg_20_7 + arg_20_0

			local var_20_0 = math.min(1, arg_20_7 / arg_20_5)

			arg_20_1[arg_20_2] = arg_20_3 + arg_20_6(var_20_0) * (arg_20_4 - arg_20_3)

			return arg_20_7 <= arg_20_5, arg_20_7
		end
	},
	function_by_time_with_offset = {
		num_args = 7,
		num_data = 1,
		init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			arg_21_0[arg_21_1] = arg_21_2

			return 0
		end,
		update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
			arg_22_8 = arg_22_8 + arg_22_0

			local var_22_0 = math.min(1, arg_22_8 / arg_22_5)

			arg_22_1[arg_22_2] = arg_22_3 + arg_22_7(var_22_0, arg_22_6) * (arg_22_4 - arg_22_3)

			return arg_22_8 <= arg_22_5, arg_22_8
		end
	},
	linear_scale = {
		num_args = 5,
		num_data = 1,
		init = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
			arg_23_0[arg_23_1] = arg_23_2

			return 0
		end,
		update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			arg_24_6 = arg_24_6 + arg_24_0

			local var_24_0 = math.min(1, arg_24_6 / arg_24_5)

			arg_24_1[arg_24_2] = (arg_24_4 - arg_24_3) * var_24_0 + arg_24_3

			return arg_24_6 <= arg_24_5, arg_24_6
		end
	},
	wait = {
		num_args = 1,
		num_data = 1,
		init = function(arg_25_0)
			return 0
		end,
		update = function(arg_26_0, arg_26_1, arg_26_2)
			arg_26_2 = arg_26_2 + arg_26_0

			return arg_26_2 <= arg_26_1, arg_26_2
		end
	},
	set_visible = {
		num_args = 1,
		num_data = 0,
		init = function()
			return
		end,
		update = function(arg_28_0, arg_28_1)
			arg_28_1.visible = true

			return false
		end
	},
	set_invisible = {
		num_args = 1,
		num_data = 0,
		init = function()
			return
		end,
		update = function(arg_30_0, arg_30_1)
			arg_30_1.visible = false

			return false
		end
	},
	picture_sequence = {
		num_args = 4,
		num_data = 2,
		init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			local var_31_0 = arg_31_3 / #arg_31_2

			return 0, var_31_0
		end,
		update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
			arg_32_5 = math.min(arg_32_5 + arg_32_0, arg_32_4)
			arg_32_1[arg_32_2] = arg_32_3[math.floor(arg_32_5 / arg_32_6) + 1] or arg_32_3[#arg_32_3]

			return arg_32_5 < arg_32_4, arg_32_5, arg_32_6
		end
	},
	timestep_setter_tables = {
		num_args = 4,
		num_data = 1,
		init = function()
			return 0
		end,
		update = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
			arg_34_5 = arg_34_5 + arg_34_0

			local var_34_0

			for iter_34_0, iter_34_1 in ipairs(arg_34_3) do
				if arg_34_5 < iter_34_1 then
					var_34_0 = iter_34_0

					break
				end
			end

			arg_34_1[arg_34_2] = arg_34_4[var_34_0 or #arg_34_4]

			return var_34_0 and true or false, arg_34_5
		end
	}
}

function UIAnimation.init(...)
	local var_35_0 = {}
	local var_35_1 = {
		current_index = 1,
		data_array = var_35_0
	}
	local var_35_2 = select("#", ...)
	local var_35_3 = 0
	local var_35_4 = 0

	while var_35_3 < var_35_2 do
		var_35_3 = var_35_3 + 1

		local var_35_5 = select(var_35_3, ...)
		local var_35_6 = var_35_5.num_args

		var_35_0[var_35_4 + 1] = var_35_5

		for iter_35_0 = 1, var_35_6 do
			var_35_0[var_35_4 + 1 + iter_35_0] = select(var_35_3 + iter_35_0, ...)
		end

		var_35_4 = var_35_4 + 1 + var_35_6 + var_35_5.num_data
		var_35_3 = var_35_3 + var_35_6
	end

	local var_35_7 = var_35_0[1].num_args
	local var_35_8 = var_35_0[1].num_data
	local var_35_9 = pack_index[var_35_8]
	local var_35_10 = unpack_index[var_35_7]

	var_35_9(var_35_0, 2 + var_35_7, var_35_0[1].init(var_35_10(var_35_0, 2)))

	return var_35_1
end

local function var_0_0(...)
	Application.error("########### ANIMATION ERROR ###########")

	local var_36_0 = select("#", ...)

	for iter_36_0 = 1, var_36_0 do
		local var_36_1 = select(iter_36_0, ...)

		Application.error(string.format("Variable %d: %s", iter_36_0, tostring(var_36_1)))
	end

	Application.error("########### ANIMATION ERROR END ###########")
	print(debug.traceback())
end

function UIAnimation.init_debug(...)
	local var_37_0 = {}
	local var_37_1 = {
		current_index = 1,
		data_array = var_37_0
	}
	local var_37_2 = select("#", ...)
	local var_37_3 = 0
	local var_37_4 = 0

	while var_37_3 < var_37_2 do
		var_37_3 = var_37_3 + 1

		local var_37_5 = select(var_37_3, ...)

		if not var_37_5 or type(var_37_5) ~= "table" then
			var_0_0(...)

			return nil
		end

		local var_37_6 = var_37_5.num_args

		var_37_0[var_37_4 + 1] = var_37_5

		for iter_37_0 = 1, var_37_6 do
			var_37_0[var_37_4 + 1 + iter_37_0] = select(var_37_3 + iter_37_0, ...)
		end

		var_37_4 = var_37_4 + 1 + var_37_6 + var_37_5.num_data
		var_37_3 = var_37_3 + var_37_6
	end

	local var_37_7 = var_37_0[1].num_args
	local var_37_8 = var_37_0[1].num_data
	local var_37_9 = pack_index[var_37_8]
	local var_37_10 = unpack_index[var_37_7]

	var_37_9(var_37_0, 2 + var_37_7, var_37_0[1].init(var_37_10(var_37_0, 2)))

	return var_37_1
end

local function var_0_1(arg_38_0, arg_38_1, arg_38_2, arg_38_3, ...)
	pack_index[arg_38_0](arg_38_1, arg_38_2, ...)

	return arg_38_3
end

function UIAnimation.update(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.current_index
	local var_39_1 = arg_39_0.data_array
	local var_39_2 = var_39_1[var_39_0]

	if var_39_2 then
		local var_39_3 = var_39_2.num_args
		local var_39_4 = var_39_2.num_data

		if not var_0_1(var_39_4, var_39_1, var_39_0 + var_39_3 + 1, var_39_2.update(arg_39_1, unpack_index[var_39_3 + var_39_4](var_39_1, var_39_0 + 1))) then
			local var_39_5 = var_39_0 + var_39_3 + var_39_4 + 1

			arg_39_0.current_index = var_39_5

			local var_39_6 = var_39_1[var_39_5]

			if var_39_6 then
				local var_39_7 = pack_index[var_39_6.num_data]
				local var_39_8 = unpack_index[var_39_6.num_args]

				var_39_7(var_39_1, var_39_5 + 1 + var_39_6.num_args, var_39_6.init(var_39_8(var_39_1, var_39_5 + 1)))
			end
		end
	end
end

function UIAnimation.completed(arg_40_0)
	return arg_40_0.current_index >= #arg_40_0.data_array
end
