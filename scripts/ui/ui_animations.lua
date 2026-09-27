-- chunkname: @scripts/ui/ui_animations.lua

require("scripts/utils/varargs")

local UIAnimation = UIAnimation

UIAnimation = UIAnimation or {
	catmullrom = {
		num_args = 8,
		num_data = 1,
		init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
			-- function 1
			if not arg_1_1 then
				self[arg_1_1] = arg_1_4 * arg_1_2
			else
				local num = arg_1_4 * arg_1_2

				for i = 1, #self do
					self[i] = num
				end
			end

			return 0
		end,
		update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
			-- function 2
			arg_2_9 = arg_2_9 + arg_2_0

			local min = math.min(arg_2_9 / arg_2_8, 1)
			local num = math.catmullrom(min, arg_2_4, arg_2_5, arg_2_6, arg_2_7) * arg_2_3

			if not arg_2_2 then
				arg_2_1[arg_2_2] = num
			else
				for i = 1, #arg_2_1 do
					arg_2_1[i] = num
				end
			end

			return arg_2_9 <= arg_2_8, arg_2_9
		end
	},
	size_offset_scale = {
		num_args = 9,
		num_data = 1,
		init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
			-- function 3
			local num = arg_3_5 * arg_3_3
			local num_2 = (arg_3_3 - num) * 0.5

			if not arg_3_2 then
				self[arg_3_2] = num
				arg_3_1[arg_3_2] = num_2
			else
				for i = 1, #self do
					self[i] = num
					arg_3_1[i] = num_2
				end
			end

			return 0
		end,
		update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
			-- function 4
			arg_4_10 = arg_4_10 + arg_4_0

			local min = math.min(arg_4_10 / arg_4_9, 1)
			local num = math.catmullrom(min, arg_4_5, arg_4_6, arg_4_7, arg_4_8) * arg_4_4
			local num_2 = (arg_4_4 - num) * 0.5

			if not arg_4_3 then
				arg_4_1[arg_4_3] = num
				arg_4_2[i] = num_2
			else
				for i = 1, #arg_4_1 do
					arg_4_1[i] = num
					arg_4_2[i] = num_2
				end
			end

			return arg_4_10 <= arg_4_9, arg_4_10
		end
	},
	pulse_animation = {
		num_args = 5,
		num_data = 1,
		init = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			-- function 5
			self[arg_5_1] = arg_5_2

			return 0
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
			-- function 6
			arg_6_6 = arg_6_6 + arg_6_0

			local sin = math.sin(arg_6_6 * arg_6_5)

			arg_6_1[arg_6_2] = arg_6_3 + sin * sin * (arg_6_4 - arg_6_3)

			return true, arg_6_6
		end
	},
	pulse_animation2 = {
		num_args = 4,
		num_data = 1,
		init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			-- function 7
			return 0
		end,
		update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			-- function 8
			arg_8_5 = arg_8_5 + arg_8_0

			local sin = math.sin(arg_8_5 * arg_8_4)

			for k, v in pairs(arg_8_1) do
				local num = arg_8_2[k] + sin * sin * (arg_8_3[k] - arg_8_2[k])

				arg_8_1[k] = math.floor(num)
			end

			return true, arg_8_5
		end
	},
	pulse_animation3 = {
		num_args = 6,
		num_data = 1,
		init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
			-- function 9
			return 0
		end,
		update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
			-- function 10
			arg_10_7 = arg_10_7 + arg_10_0 * arg_10_5

			local flag = arg_10_7 <= arg_10_6 * arg_10_5
			local var_10_1

			if not flag then
				var_10_1 = math.sirp(arg_10_3, arg_10_4, arg_10_7)
			else
				var_10_1 = arg_10_3
			end

			arg_10_1[arg_10_2] = var_10_1

			return flag, arg_10_7
		end
	},
	text_flash = {
		num_args = 6,
		num_data = 1,
		init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
			-- function 11
			return 0
		end,
		update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
			-- function 12
			arg_12_7 = arg_12_7 + arg_12_0 * arg_12_5

			local flag = arg_12_7 <= arg_12_6 * arg_12_5
			local var_12_1

			if not flag then
				var_12_1 = math.sirp(arg_12_3, arg_12_4, arg_12_7)
			else
				var_12_1 = arg_12_3
			end

			for i = 2, #arg_12_1 do
				arg_12_1[i] = var_12_1
			end

			return flag, arg_12_7
		end
	},
	update_function_by_time = {
		num_args = 6,
		num_data = 1,
		init = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			-- function 13
			self[arg_13_1] = arg_13_2

			return 0
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
			-- function 14
			arg_14_7 = arg_14_7 + arg_14_0
			arg_14_1[arg_14_2] = arg_14_3 + arg_14_6(arg_14_7) * (arg_14_4 - arg_14_3)

			return true, arg_14_7
		end
	},
	linear_scale2 = {
		num_args = 6,
		num_data = 1,
		init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
			-- function 15
			return 0
		end,
		update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
			-- function 16
			arg_16_7 = arg_16_7 + arg_16_0

			local num = arg_16_7 / arg_16_6

			arg_16_1[1] = (arg_16_4 - arg_16_2) * num + arg_16_2
			arg_16_1[2] = (arg_16_5 - arg_16_3) * num + arg_16_3

			return arg_16_7 <= arg_16_6, arg_16_7
		end
	},
	linear_scale_color = {
		num_args = 8,
		num_data = 1,
		init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
			-- function 17
			return 0
		end,
		update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9)
			-- function 18
			arg_18_9 = arg_18_9 + arg_18_0

			local min = math.min(1, arg_18_9 / arg_18_8)

			arg_18_1[2] = (arg_18_5 - arg_18_2) * min + arg_18_2
			arg_18_1[3] = (arg_18_6 - arg_18_3) * min + arg_18_3
			arg_18_1[4] = (arg_18_7 - arg_18_4) * min + arg_18_4

			return arg_18_9 <= arg_18_8, arg_18_9
		end
	},
	function_by_time = {
		num_args = 6,
		num_data = 1,
		init = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			-- function 19
			self[arg_19_1] = arg_19_2

			return 0
		end,
		update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7)
			-- function 20
			arg_20_7 = arg_20_7 + arg_20_0

			local min = math.min(1, arg_20_7 / arg_20_5)

			arg_20_1[arg_20_2] = arg_20_3 + arg_20_6(min) * (arg_20_4 - arg_20_3)

			return arg_20_7 <= arg_20_5, arg_20_7
		end
	},
	function_by_time_with_offset = {
		num_args = 7,
		num_data = 1,
		init = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			-- function 21
			self[arg_21_1] = arg_21_2

			return 0
		end,
		update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
			-- function 22
			arg_22_8 = arg_22_8 + arg_22_0

			local min = math.min(1, arg_22_8 / arg_22_5)

			arg_22_1[arg_22_2] = arg_22_3 + arg_22_7(min, arg_22_6) * (arg_22_4 - arg_22_3)

			return arg_22_8 <= arg_22_5, arg_22_8
		end
	},
	linear_scale = {
		num_args = 5,
		num_data = 1,
		init = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
			-- function 23
			self[arg_23_1] = arg_23_2

			return 0
		end,
		update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			-- function 24
			arg_24_6 = arg_24_6 + arg_24_0

			local min = math.min(1, arg_24_6 / arg_24_5)

			arg_24_1[arg_24_2] = (arg_24_4 - arg_24_3) * min + arg_24_3

			return arg_24_6 <= arg_24_5, arg_24_6
		end
	},
	wait = {
		num_args = 1,
		num_data = 1,
		init = function (arg_25_0)
			-- function 25
			return 0
		end,
		update = function (arg_26_0, arg_26_1, arg_26_2)
			-- function 26
			arg_26_2 = arg_26_2 + arg_26_0

			return arg_26_2 <= arg_26_1, arg_26_2
		end
	},
	set_visible = {
		num_args = 1,
		num_data = 0,
		init = function ()
			-- function 27
			return
		end,
		update = function (arg_28_0, arg_28_1)
			-- function 28
			arg_28_1.visible = true

			return false
		end
	},
	set_invisible = {
		num_args = 1,
		num_data = 0,
		init = function ()
			-- function 29
			return
		end,
		update = function (arg_30_0, arg_30_1)
			-- function 30
			arg_30_1.visible = false

			return false
		end
	},
	picture_sequence = {
		num_args = 4,
		num_data = 2,
		init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			-- function 31
			local num = arg_31_3 / #arg_31_2

			return 0, num
		end,
		update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
			-- function 32
			arg_32_5 = math.min(arg_32_5 + arg_32_0, arg_32_4)

			local var_32_0 = arg_32_3[math.floor(arg_32_5 / arg_32_6) + 1]

			var_32_0 = var_32_0 or arg_32_3[#arg_32_3]
			arg_32_1[arg_32_2] = var_32_0

			return arg_32_5 < arg_32_4, arg_32_5, arg_32_6
		end
	},
	timestep_setter_tables = {
		num_args = 4,
		num_data = 1,
		init = function ()
			-- function 33
			return 0
		end,
		update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
			-- function 34
			arg_34_5 = arg_34_5 + arg_34_0

			local var_34_0

			for i, v in ipairs(arg_34_3) do
				if arg_34_5 < v then
					var_34_0 = i

					break
				end
			end

			arg_34_1[arg_34_2] = arg_34_4[var_34_0 or #arg_34_4]

			local flag

			flag = not var_34_0 and true and false

			return flag, arg_34_5
		end
	}
}
UIAnimation = UIAnimation

UIAnimation.init = function (...)
	-- function 35
	local tbl = {}
	local tbl_2 = {
		current_index = 1,
		data_array = tbl
	}
	local var_35_2 = select("#", ...)
	local num = 0
	local num_2 = 0

	while num < var_35_2 do
		num = num + 1

		local var_35_5 = select(num, ...)
		local num_args = var_35_5.num_args

		tbl[num_2 + 1] = var_35_5

		for i = 1, num_args do
			tbl[num_2 + 1 + i] = select(num + i, ...)
		end

		num_2 = num_2 + 1 + num_args + var_35_5.num_data
		num = num + num_args
	end

	local num_args_2 = tbl[1].num_args
	local num_data = tbl[1].num_data
	local var_35_9 = pack_index[num_data]
	local var_35_10 = unpack_index[num_args_2]

	var_35_9(tbl, 2 + num_args_2, tbl[1].init(var_35_10(tbl, 2)))

	return tbl_2
end

local function fn(...)
	-- function 36
	Application.error("########### ANIMATION ERROR ###########")

	local var_36_0 = select("#", ...)

	for i = 1, var_36_0 do
		local var_36_1 = select(i, ...)

		Application.error(string.format("Variable %d: %s", i, tostring(var_36_1)))
	end

	Application.error("########### ANIMATION ERROR END ###########")
	print(debug.traceback())
end

UIAnimation.init_debug = function (...)
	-- function 37
	local tbl = {}
	local tbl_2 = {
		current_index = 1,
		data_array = tbl
	}
	local var_37_2 = select("#", ...)
	local num = 0
	local num_2 = 0

	while num < var_37_2 do
		num = num + 1

		local var_37_5 = select(num, ...)

		if not (not var_37_5 and type(var_37_5) == "table") then
			fn(...)

			return nil
		end

		local num_args = var_37_5.num_args

		tbl[num_2 + 1] = var_37_5

		for i = 1, num_args do
			tbl[num_2 + 1 + i] = select(num + i, ...)
		end

		num_2 = num_2 + 1 + num_args + var_37_5.num_data
		num = num + num_args
	end

	local num_args_2 = tbl[1].num_args
	local num_data = tbl[1].num_data
	local var_37_9 = pack_index[num_data]
	local var_37_10 = unpack_index[num_args_2]

	var_37_9(tbl, 2 + num_args_2, tbl[1].init(var_37_10(tbl, 2)))

	return tbl_2
end

local function fn_2(arg_38_0, arg_38_1, arg_38_2, arg_38_3, ...)
	-- function 38
	pack_index[arg_38_0](arg_38_1, arg_38_2, ...)

	return arg_38_3
end

UIAnimation.update = function (self, arg_39_1)
	-- function 39
	local current_index = self.current_index
	local data_array = self.data_array
	local var_39_2 = data_array[current_index]

	if not var_39_2 then
		local num_args = var_39_2.num_args
		local num_data = var_39_2.num_data

		if not fn_2(num_data, data_array, current_index + num_args + 1, var_39_2.update(arg_39_1, unpack_index[num_args + num_data](data_array, current_index + 1))) then
			local num = current_index + num_args + num_data + 1

			self.current_index = num

			local var_39_6 = data_array[num]

			if not var_39_6 then
				local var_39_7 = pack_index[var_39_6.num_data]
				local var_39_8 = unpack_index[var_39_6.num_args]

				var_39_7(data_array, num + 1 + var_39_6.num_args, var_39_6.init(var_39_8(data_array, num + 1)))
			end
		end
	end
end

UIAnimation.completed = function (self)
	-- function 40
	return self.current_index >= #self.data_array
end
