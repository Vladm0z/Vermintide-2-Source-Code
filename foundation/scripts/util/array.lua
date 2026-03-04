-- chunkname: @foundation/scripts/util/array.lua

local function var_0_0()
	return {
		{},
		0
	}
end

local function var_0_1(arg_2_0)
	return arg_2_0[1], arg_2_0[2]
end

local function var_0_2(arg_3_0)
	return arg_3_0[1]
end

local function var_0_3(arg_4_0)
	return arg_4_0[2]
end

local function var_0_4(arg_5_0)
	local var_5_0, var_5_1 = var_0_1(arg_5_0)
	local var_5_2 = {}
	local var_5_3 = {
		var_5_2,
		var_5_1
	}

	for iter_5_0 = 1, var_5_1 do
		var_5_2[iter_5_0] = var_5_0[iter_5_0]
	end

	return var_5_3
end

local function var_0_5(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0[1]
	local var_6_1 = arg_6_0[2]

	while var_6_1 < arg_6_1 do
		var_6_1 = var_6_1 + 1
		var_6_0[var_6_1] = nil
	end

	while arg_6_1 < var_6_1 do
		var_6_0[var_6_1] = nil
		var_6_1 = var_6_1 - 1
	end

	arg_6_0[2] = arg_6_1
end

local function var_0_6(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0[1]
	local var_7_1 = arg_7_0[2]

	arg_7_0[2] = arg_7_1

	while var_7_1 < arg_7_1 do
		var_7_1 = var_7_1 + 1
		var_7_0[var_7_1] = nil
	end
end

local function var_0_7(arg_8_0, arg_8_1)
	arg_8_0[2] = arg_8_1
end

local function var_0_8(arg_9_0)
	var_0_7(arg_9_0, 0)
end

local function var_0_9(arg_10_0)
	return arg_10_0[2] == 0
end

local function var_0_10(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0[1]
	local var_11_1 = arg_11_0[2]

	var_11_0[arg_11_1] = var_11_0[var_11_1]
	var_11_0[var_11_1] = nil
	arg_11_0[2] = var_11_1 - 1
end

local function var_0_11(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0[1]
	local var_12_1 = arg_12_0[2]

	for iter_12_0 = arg_12_1, var_12_1 - 1 do
		var_12_0[iter_12_0] = var_12_0[iter_12_0 + 1]
	end

	var_12_0[var_12_1] = nil
	arg_12_0[2] = var_12_1 - 1
end

local function var_0_12(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0[1]
	local var_13_1 = arg_13_0[2]
	local var_13_2

	for iter_13_0 = 1, var_13_1 do
		if var_13_0[iter_13_0] == arg_13_1 then
			var_13_2 = iter_13_0

			break
		end
	end

	return var_13_2
end

local function var_0_13(arg_14_0, arg_14_1)
	local var_14_0 = var_0_12(arg_14_0, arg_14_1)

	if not var_14_0 then
		return nil
	end

	var_0_10(arg_14_0, var_14_0)

	return var_14_0
end

local function var_0_14(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0[1]
	local var_15_1 = arg_15_0[2]
	local var_15_2 = var_15_0[arg_15_1]

	var_15_0[arg_15_1] = var_15_0[var_15_1]
	var_15_0[var_15_1] = nil
	arg_15_0[2] = var_15_1 - 1

	return var_15_2, arg_15_1
end

local function var_0_15(arg_16_0, arg_16_1)
	local var_16_0 = var_0_12(arg_16_0, arg_16_1)

	if not var_16_0 then
		return
	end

	return var_0_14(arg_16_0, var_16_0)
end

local function var_0_16(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0[1]
	local var_17_1 = arg_17_0[2]
	local var_17_2 = var_17_0[arg_17_1]

	for iter_17_0 = arg_17_1, var_17_1 - 1 do
		var_17_0[iter_17_0] = var_17_0[iter_17_0 + 1]
	end

	var_17_0[var_17_1] = nil
	arg_17_0[2] = var_17_1 - 1

	return var_17_2, arg_17_1
end

local function var_0_17(arg_18_0, arg_18_1)
	local var_18_0 = var_0_12(arg_18_0, arg_18_1)

	if not var_18_0 then
		return nil
	end

	var_0_11(arg_18_0, var_18_0)

	return var_18_0
end

local function var_0_18(arg_19_0, arg_19_1)
	local var_19_0 = var_0_12(arg_19_0, arg_19_1)

	if not var_19_0 then
		return
	end

	return var_0_16(arg_19_0, var_19_0)
end

local function var_0_19(arg_20_0)
	local var_20_0 = arg_20_0[1]
	local var_20_1 = arg_20_0[2]

	assert(var_20_1 > 0)

	local var_20_2 = var_20_0[var_20_1]

	var_20_0[var_20_1] = nil
	arg_20_0[2] = var_20_1 - 1

	return var_20_2, var_20_1
end

local function var_0_20(arg_21_0)
	local var_21_0 = arg_21_0[1]
	local var_21_1 = arg_21_0[2]

	assert(var_21_1 > 0)

	var_21_0[var_21_1] = nil
	arg_21_0[2] = var_21_1 - 1
end

local function var_0_21(arg_22_0, arg_22_1, ...)
	local var_22_0 = arg_22_0[1]
	local var_22_1 = arg_22_0[2] + 1

	var_22_0[var_22_1] = arg_22_1
	arg_22_0[2] = var_22_1
end

local function var_0_22(arg_23_0, arg_23_1, arg_23_2, ...)
	local var_23_0 = arg_23_0[1]
	local var_23_1 = arg_23_0[2]

	var_23_0[var_23_1 + 1] = arg_23_1
	var_23_0[var_23_1 + 2] = arg_23_2
	arg_23_0[2] = var_23_1 + 2
end

local function var_0_23(arg_24_0, arg_24_1, arg_24_2, arg_24_3, ...)
	local var_24_0 = arg_24_0[1]
	local var_24_1 = arg_24_0[2]

	var_24_0[var_24_1 + 1] = arg_24_1
	var_24_0[var_24_1 + 2] = arg_24_2
	var_24_0[var_24_1 + 3] = arg_24_3
	arg_24_0[2] = var_24_1 + 3
end

local function var_0_24(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, ...)
	local var_25_0 = arg_25_0[1]
	local var_25_1 = arg_25_0[2]

	var_25_0[var_25_1 + 1] = arg_25_1
	var_25_0[var_25_1 + 2] = arg_25_2
	var_25_0[var_25_1 + 3] = arg_25_3
	var_25_0[var_25_1 + 4] = arg_25_4
	arg_25_0[2] = var_25_1 + 4
end

local function var_0_25(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, ...)
	local var_26_0 = arg_26_0[1]
	local var_26_1 = arg_26_0[2]

	var_26_0[var_26_1 + 1] = arg_26_1
	var_26_0[var_26_1 + 2] = arg_26_2
	var_26_0[var_26_1 + 3] = arg_26_3
	var_26_0[var_26_1 + 4] = arg_26_4
	var_26_0[var_26_1 + 5] = arg_26_5
	arg_26_0[2] = var_26_1 + 5
end

local function var_0_26(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, ...)
	local var_27_0 = arg_27_0[1]
	local var_27_1 = arg_27_0[2]

	var_27_0[var_27_1 + 1] = arg_27_1
	var_27_0[var_27_1 + 2] = arg_27_2
	var_27_0[var_27_1 + 3] = arg_27_3
	var_27_0[var_27_1 + 4] = arg_27_4
	var_27_0[var_27_1 + 5] = arg_27_5
	var_27_0[var_27_1 + 6] = arg_27_6
	arg_27_0[2] = var_27_1 + 6
end

local function var_0_27(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, ...)
	local var_28_0 = arg_28_0[1]
	local var_28_1 = arg_28_0[2]

	var_28_0[var_28_1 + 1] = arg_28_1
	var_28_0[var_28_1 + 2] = arg_28_2
	var_28_0[var_28_1 + 3] = arg_28_3
	var_28_0[var_28_1 + 4] = arg_28_4
	var_28_0[var_28_1 + 5] = arg_28_5
	var_28_0[var_28_1 + 6] = arg_28_6
	var_28_0[var_28_1 + 7] = arg_28_7
	arg_28_0[2] = var_28_1 + 7
end

local function var_0_28(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, ...)
	local var_29_0 = arg_29_0[1]
	local var_29_1 = arg_29_0[2]

	var_29_0[var_29_1 + 1] = arg_29_1
	var_29_0[var_29_1 + 2] = arg_29_2
	var_29_0[var_29_1 + 3] = arg_29_3
	var_29_0[var_29_1 + 4] = arg_29_4
	var_29_0[var_29_1 + 5] = arg_29_5
	var_29_0[var_29_1 + 6] = arg_29_6
	var_29_0[var_29_1 + 7] = arg_29_7
	var_29_0[var_29_1 + 8] = arg_29_8
	arg_29_0[2] = var_29_1 + 8
end

local function var_0_29(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9, ...)
	local var_30_0 = arg_30_0[1]
	local var_30_1 = arg_30_0[2]

	var_30_0[var_30_1 + 1] = arg_30_1
	var_30_0[var_30_1 + 2] = arg_30_2
	var_30_0[var_30_1 + 3] = arg_30_3
	var_30_0[var_30_1 + 4] = arg_30_4
	var_30_0[var_30_1 + 5] = arg_30_5
	var_30_0[var_30_1 + 6] = arg_30_6
	var_30_0[var_30_1 + 7] = arg_30_7
	var_30_0[var_30_1 + 8] = arg_30_8
	var_30_0[var_30_1 + 9] = arg_30_9
	arg_30_0[2] = var_30_1 + 9
end

local function var_0_30(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, ...)
	local var_31_0 = arg_31_0[1]
	local var_31_1 = arg_31_0[2]

	var_31_0[var_31_1 + 1] = arg_31_1
	var_31_0[var_31_1 + 2] = arg_31_2
	var_31_0[var_31_1 + 3] = arg_31_3
	var_31_0[var_31_1 + 4] = arg_31_4
	var_31_0[var_31_1 + 5] = arg_31_5
	var_31_0[var_31_1 + 6] = arg_31_6
	var_31_0[var_31_1 + 7] = arg_31_7
	var_31_0[var_31_1 + 8] = arg_31_8
	var_31_0[var_31_1 + 9] = arg_31_9
	var_31_0[var_31_1 + 10] = arg_31_10
	arg_31_0[2] = var_31_1 + 10
end

local function var_0_31(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8, arg_32_9, arg_32_10, arg_32_11, ...)
	local var_32_0 = arg_32_0[1]
	local var_32_1 = arg_32_0[2]

	var_32_0[var_32_1 + 1] = arg_32_1
	var_32_0[var_32_1 + 2] = arg_32_2
	var_32_0[var_32_1 + 3] = arg_32_3
	var_32_0[var_32_1 + 4] = arg_32_4
	var_32_0[var_32_1 + 5] = arg_32_5
	var_32_0[var_32_1 + 6] = arg_32_6
	var_32_0[var_32_1 + 7] = arg_32_7
	var_32_0[var_32_1 + 8] = arg_32_8
	var_32_0[var_32_1 + 9] = arg_32_9
	var_32_0[var_32_1 + 10] = arg_32_10
	var_32_0[var_32_1 + 11] = arg_32_11
	arg_32_0[2] = var_32_1 + 11
end

local function var_0_32(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10, arg_33_11, arg_33_12, ...)
	local var_33_0 = arg_33_0[1]
	local var_33_1 = arg_33_0[2]

	var_33_0[var_33_1 + 1] = arg_33_1
	var_33_0[var_33_1 + 2] = arg_33_2
	var_33_0[var_33_1 + 3] = arg_33_3
	var_33_0[var_33_1 + 4] = arg_33_4
	var_33_0[var_33_1 + 5] = arg_33_5
	var_33_0[var_33_1 + 6] = arg_33_6
	var_33_0[var_33_1 + 7] = arg_33_7
	var_33_0[var_33_1 + 8] = arg_33_8
	var_33_0[var_33_1 + 9] = arg_33_9
	var_33_0[var_33_1 + 10] = arg_33_10
	var_33_0[var_33_1 + 11] = arg_33_11
	var_33_0[var_33_1 + 12] = arg_33_12
	arg_33_0[2] = var_33_1 + 12
end

local function var_0_33(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9, arg_34_10, arg_34_11, arg_34_12, arg_34_13, ...)
	local var_34_0 = arg_34_0[1]
	local var_34_1 = arg_34_0[2]

	var_34_0[var_34_1 + 1] = arg_34_1
	var_34_0[var_34_1 + 2] = arg_34_2
	var_34_0[var_34_1 + 3] = arg_34_3
	var_34_0[var_34_1 + 4] = arg_34_4
	var_34_0[var_34_1 + 5] = arg_34_5
	var_34_0[var_34_1 + 6] = arg_34_6
	var_34_0[var_34_1 + 7] = arg_34_7
	var_34_0[var_34_1 + 8] = arg_34_8
	var_34_0[var_34_1 + 9] = arg_34_9
	var_34_0[var_34_1 + 10] = arg_34_10
	var_34_0[var_34_1 + 11] = arg_34_11
	var_34_0[var_34_1 + 12] = arg_34_12
	var_34_0[var_34_1 + 13] = arg_34_13
	arg_34_0[2] = var_34_1 + 13
end

local function var_0_34(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8, arg_35_9, arg_35_10, arg_35_11, arg_35_12, arg_35_13, arg_35_14, ...)
	local var_35_0 = arg_35_0[1]
	local var_35_1 = arg_35_0[2]

	var_35_0[var_35_1 + 1] = arg_35_1
	var_35_0[var_35_1 + 2] = arg_35_2
	var_35_0[var_35_1 + 3] = arg_35_3
	var_35_0[var_35_1 + 4] = arg_35_4
	var_35_0[var_35_1 + 5] = arg_35_5
	var_35_0[var_35_1 + 6] = arg_35_6
	var_35_0[var_35_1 + 7] = arg_35_7
	var_35_0[var_35_1 + 8] = arg_35_8
	var_35_0[var_35_1 + 9] = arg_35_9
	var_35_0[var_35_1 + 10] = arg_35_10
	var_35_0[var_35_1 + 11] = arg_35_11
	var_35_0[var_35_1 + 12] = arg_35_12
	var_35_0[var_35_1 + 13] = arg_35_13
	var_35_0[var_35_1 + 14] = arg_35_14
	arg_35_0[2] = var_35_1 + 14
end

local function var_0_35(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_11, arg_36_12, arg_36_13, arg_36_14, arg_36_15, ...)
	local var_36_0 = arg_36_0[1]
	local var_36_1 = arg_36_0[2]

	var_36_0[var_36_1 + 1] = arg_36_1
	var_36_0[var_36_1 + 2] = arg_36_2
	var_36_0[var_36_1 + 3] = arg_36_3
	var_36_0[var_36_1 + 4] = arg_36_4
	var_36_0[var_36_1 + 5] = arg_36_5
	var_36_0[var_36_1 + 6] = arg_36_6
	var_36_0[var_36_1 + 7] = arg_36_7
	var_36_0[var_36_1 + 8] = arg_36_8
	var_36_0[var_36_1 + 9] = arg_36_9
	var_36_0[var_36_1 + 10] = arg_36_10
	var_36_0[var_36_1 + 11] = arg_36_11
	var_36_0[var_36_1 + 12] = arg_36_12
	var_36_0[var_36_1 + 13] = arg_36_13
	var_36_0[var_36_1 + 14] = arg_36_14
	var_36_0[var_36_1 + 15] = arg_36_15
	arg_36_0[2] = var_36_1 + 15
end

local function var_0_36(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12, arg_37_13, arg_37_14, arg_37_15, arg_37_16, ...)
	local var_37_0 = arg_37_0[1]
	local var_37_1 = arg_37_0[2]

	var_37_0[var_37_1 + 1] = arg_37_1
	var_37_0[var_37_1 + 2] = arg_37_2
	var_37_0[var_37_1 + 3] = arg_37_3
	var_37_0[var_37_1 + 4] = arg_37_4
	var_37_0[var_37_1 + 5] = arg_37_5
	var_37_0[var_37_1 + 6] = arg_37_6
	var_37_0[var_37_1 + 7] = arg_37_7
	var_37_0[var_37_1 + 8] = arg_37_8
	var_37_0[var_37_1 + 9] = arg_37_9
	var_37_0[var_37_1 + 10] = arg_37_10
	var_37_0[var_37_1 + 11] = arg_37_11
	var_37_0[var_37_1 + 12] = arg_37_12
	var_37_0[var_37_1 + 13] = arg_37_13
	var_37_0[var_37_1 + 14] = arg_37_14
	var_37_0[var_37_1 + 15] = arg_37_15
	var_37_0[var_37_1 + 16] = arg_37_16
	arg_37_0[2] = var_37_1 + 16
end

local var_0_37 = {
	function (arg_38_0, arg_38_1)
		local var_38_0 = arg_38_0[1]
		local var_38_1 = arg_38_0[2]

		var_38_0[var_38_1 + 1] = arg_38_1[1]
		arg_38_0[2] = var_38_1 + 1
	end,
	function (arg_39_0, arg_39_1)
		local var_39_0 = arg_39_0[1]
		local var_39_1 = arg_39_0[2]

		var_39_0[var_39_1 + 1] = arg_39_1[1]
		var_39_0[var_39_1 + 2] = arg_39_1[2]
		arg_39_0[2] = var_39_1 + 2
	end,
	function (arg_40_0, arg_40_1)
		local var_40_0 = arg_40_0[1]
		local var_40_1 = arg_40_0[2]

		var_40_0[var_40_1 + 1] = arg_40_1[1]
		var_40_0[var_40_1 + 2] = arg_40_1[2]
		var_40_0[var_40_1 + 3] = arg_40_1[3]
		arg_40_0[2] = var_40_1 + 3
	end,
	function (arg_41_0, arg_41_1)
		local var_41_0 = arg_41_0[1]
		local var_41_1 = arg_41_0[2]

		var_41_0[var_41_1 + 1] = arg_41_1[1]
		var_41_0[var_41_1 + 2] = arg_41_1[2]
		var_41_0[var_41_1 + 3] = arg_41_1[3]
		var_41_0[var_41_1 + 4] = arg_41_1[4]
		arg_41_0[2] = var_41_1 + 4
	end,
	function (arg_42_0, arg_42_1)
		local var_42_0 = arg_42_0[1]
		local var_42_1 = arg_42_0[2]

		var_42_0[var_42_1 + 1] = arg_42_1[1]
		var_42_0[var_42_1 + 2] = arg_42_1[2]
		var_42_0[var_42_1 + 3] = arg_42_1[3]
		var_42_0[var_42_1 + 4] = arg_42_1[4]
		var_42_0[var_42_1 + 5] = arg_42_1[5]
		arg_42_0[2] = var_42_1 + 5
	end,
	function (arg_43_0, arg_43_1)
		local var_43_0 = arg_43_0[1]
		local var_43_1 = arg_43_0[2]

		var_43_0[var_43_1 + 1] = arg_43_1[1]
		var_43_0[var_43_1 + 2] = arg_43_1[2]
		var_43_0[var_43_1 + 3] = arg_43_1[3]
		var_43_0[var_43_1 + 4] = arg_43_1[4]
		var_43_0[var_43_1 + 5] = arg_43_1[5]
		var_43_0[var_43_1 + 6] = arg_43_1[6]
		arg_43_0[2] = var_43_1 + 6
	end,
	function (arg_44_0, arg_44_1)
		local var_44_0 = arg_44_0[1]
		local var_44_1 = arg_44_0[2]

		var_44_0[var_44_1 + 1] = arg_44_1[1]
		var_44_0[var_44_1 + 2] = arg_44_1[2]
		var_44_0[var_44_1 + 3] = arg_44_1[3]
		var_44_0[var_44_1 + 4] = arg_44_1[4]
		var_44_0[var_44_1 + 5] = arg_44_1[5]
		var_44_0[var_44_1 + 6] = arg_44_1[6]
		var_44_0[var_44_1 + 7] = arg_44_1[7]
		arg_44_0[2] = var_44_1 + 7
	end,
	function (arg_45_0, arg_45_1)
		local var_45_0 = arg_45_0[1]
		local var_45_1 = arg_45_0[2]

		var_45_0[var_45_1 + 1] = arg_45_1[1]
		var_45_0[var_45_1 + 2] = arg_45_1[2]
		var_45_0[var_45_1 + 3] = arg_45_1[3]
		var_45_0[var_45_1 + 4] = arg_45_1[4]
		var_45_0[var_45_1 + 5] = arg_45_1[5]
		var_45_0[var_45_1 + 6] = arg_45_1[6]
		var_45_0[var_45_1 + 7] = arg_45_1[7]
		var_45_0[var_45_1 + 8] = arg_45_1[8]
		arg_45_0[2] = var_45_1 + 8
	end
}

local function var_0_38(arg_46_0, arg_46_1, arg_46_2)
	if var_0_37[arg_46_2] then
		f(arg_46_0, arg_46_1)
	else
		for iter_46_0 = 1, arg_46_2 do
			var_0_21(arg_46_0, arg_46_1[iter_46_0])
		end
	end
end

local function var_0_39(arg_47_0)
	return arg_47_0[1][arg_47_0[2]]
end

local function var_0_40(arg_48_0)
	return arg_48_0[1][1]
end

local function var_0_41(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0[1]
	local var_49_1 = arg_49_0[2]
	local var_49_2 = 1

	while var_49_2 <= var_49_1 do
		if not arg_49_1(var_49_0[var_49_2]) then
			var_49_0[var_49_2] = var_49_0[var_49_1]
			var_49_0[var_49_1] = nil
			var_49_1 = var_49_1 - 1
		else
			var_49_2 = var_49_2 + 1
		end
	end

	local var_49_3 = arg_49_0[2] - var_49_1

	arg_49_0[2] = var_49_1

	return var_49_3
end

local function var_0_42(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0[1]
	local var_50_1 = arg_50_0[2]

	for iter_50_0 = var_50_1, arg_50_2, -1 do
		var_50_0[iter_50_0 + 1] = var_50_0[iter_50_0]
	end

	var_50_0[arg_50_2] = arg_50_1
	arg_50_0[2] = var_50_1 + 1
end

local function var_0_43(arg_51_0, arg_51_1)
	return arg_51_0 < arg_51_1
end

local function var_0_44(arg_52_0, arg_52_1, arg_52_2)
	arg_52_2 = arg_52_2 or var_0_43

	local var_52_0 = arg_52_0[1]
	local var_52_1 = arg_52_0[2]

	for iter_52_0 = 1, var_52_1 do
		if arg_52_2(arg_52_1, var_52_0[iter_52_0]) then
			var_0_42(arg_52_0, arg_52_1, iter_52_0)

			return iter_52_0
		end
	end

	local var_52_2 = var_52_1 + 1

	var_52_0[var_52_2] = arg_52_1
	arg_52_0[2] = var_52_2

	return var_52_2
end

local var_0_45 = math.floor

local function var_0_46(arg_53_0, arg_53_1, arg_53_2)
	arg_53_2 = arg_53_2 or var_0_43

	local var_53_0 = arg_53_0[1]
	local var_53_1, var_53_2 = arg_53_0[2], 1
	local var_53_3 = 1
	local var_53_4 = 0

	while var_53_2 <= var_53_1 do
		var_53_3 = var_0_45((var_53_2 + var_53_1) / 2)

		if arg_53_2(arg_53_1, var_53_0[var_53_3]) then
			var_53_1, var_53_4 = var_53_3 - 1, 0
		else
			var_53_2, var_53_4 = var_53_3 + 1, 1
		end
	end

	local var_53_5 = var_53_3 + var_53_4

	var_0_42(arg_53_0, arg_53_1, var_53_5)

	return var_53_5
end

local var_0_47 = {
	new = var_0_0,
	items = var_0_2,
	num_items = var_0_3,
	data = var_0_1,
	item_index = var_0_12,
	empty = var_0_9,
	resize = var_0_5,
	resize_grow_only = var_0_6,
	set_size = var_0_7,
	set_empty = var_0_8,
	pop_index = var_0_10,
	pop_index_value = var_0_14,
	pop_item = var_0_13,
	pop_item_value = var_0_15,
	pop_index_ordered = var_0_11,
	pop_item_ordered = var_0_17,
	pop_item_value_ordered = var_0_18,
	pop_back = var_0_19,
	erase_back = var_0_20,
	push_back = var_0_21,
	push_back2 = var_0_22,
	push_back3 = var_0_23,
	push_back4 = var_0_24,
	push_back5 = var_0_25,
	push_back6 = var_0_26,
	push_back7 = var_0_27,
	push_back8 = var_0_28,
	push_back9 = var_0_29,
	push_back10 = var_0_30,
	push_back11 = var_0_31,
	push_back12 = var_0_32,
	push_back13 = var_0_33,
	push_back14 = var_0_34,
	push_back15 = var_0_35,
	push_back16 = var_0_36,
	push_back_table = var_0_38,
	insert_at = var_0_42,
	insert_sorted = var_0_44,
	binary_insert = var_0_46,
	front = var_0_40,
	back = var_0_39,
	filter = var_0_41
}

pdArray = var_0_47

return var_0_47
