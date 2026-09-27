-- chunkname: @foundation/scripts/util/array.lua

local function fn()
	-- function 1
	return {
		{},
		0
	}
end

local function fn_2(self)
	-- function 2
	return self[1], self[2]
end

local function fn_3(self)
	-- function 3
	return self[1]
end

local function fn_4(self)
	-- function 4
	return self[2]
end

local function fn_5(arg_5_0)
	-- function 5
	local var_5_0, var_5_1 = fn_2(arg_5_0)
	local tbl = {}
	local tbl_2 = {
		tbl,
		var_5_1
	}

	for i = 1, var_5_1 do
		tbl[i] = var_5_0[i]
	end

	return tbl_2
end

local function fn_6(self, arg_6_1)
	-- function 6
	local var_6_0 = self[1]
	local var_6_1 = self[2]

	while var_6_1 < arg_6_1 do
		var_6_1 = var_6_1 + 1
		var_6_0[var_6_1] = nil
	end

	while arg_6_1 < var_6_1 do
		var_6_0[var_6_1] = nil
		var_6_1 = var_6_1 - 1
	end

	self[2] = arg_6_1
end

local function fn_7(self, arg_7_1)
	-- function 7
	local var_7_0 = self[1]
	local var_7_1 = self[2]

	self[2] = arg_7_1

	while var_7_1 < arg_7_1 do
		var_7_1 = var_7_1 + 1
		var_7_0[var_7_1] = nil
	end
end

local function fn_8(self, arg_8_1)
	-- function 8
	self[2] = arg_8_1
end

local function fn_9(arg_9_0)
	-- function 9
	fn_8(arg_9_0, 0)
end

local function fn_10(self)
	-- function 10
	return self[2] == 0
end

local function fn_11(self, arg_11_1)
	-- function 11
	local var_11_0 = self[1]
	local var_11_1 = self[2]

	var_11_0[arg_11_1] = var_11_0[var_11_1]
	var_11_0[var_11_1] = nil
	self[2] = var_11_1 - 1
end

local function fn_12(self, arg_12_1)
	-- function 12
	local var_12_0 = self[1]
	local var_12_1 = self[2]

	for i = arg_12_1, var_12_1 - 1 do
		var_12_0[i] = var_12_0[i + 1]
	end

	var_12_0[var_12_1] = nil
	self[2] = var_12_1 - 1
end

local function fn_13(self, arg_13_1)
	-- function 13
	local var_13_0 = self[1]
	local var_13_1 = self[2]
	local var_13_2

	for i = 1, var_13_1 do
		if var_13_0[i] == arg_13_1 then
			var_13_2 = i

			break
		end
	end

	return var_13_2
end

local function fn_14(arg_14_0, arg_14_1)
	-- function 14
	local var_14_0 = fn_13(arg_14_0, arg_14_1)

	if not var_14_0 then
		return nil
	end

	fn_11(arg_14_0, var_14_0)

	return var_14_0
end

local function fn_15(self, arg_15_1)
	-- function 15
	local var_15_0 = self[1]
	local var_15_1 = self[2]
	local var_15_2 = var_15_0[arg_15_1]

	var_15_0[arg_15_1] = var_15_0[var_15_1]
	var_15_0[var_15_1] = nil
	self[2] = var_15_1 - 1

	return var_15_2, arg_15_1
end

local function fn_16(arg_16_0, arg_16_1)
	-- function 16
	local var_16_0 = fn_13(arg_16_0, arg_16_1)

	if not var_16_0 then
		return
	end

	return fn_15(arg_16_0, var_16_0)
end

local function fn_17(self, arg_17_1)
	-- function 17
	local var_17_0 = self[1]
	local var_17_1 = self[2]
	local var_17_2 = var_17_0[arg_17_1]

	for i = arg_17_1, var_17_1 - 1 do
		var_17_0[i] = var_17_0[i + 1]
	end

	var_17_0[var_17_1] = nil
	self[2] = var_17_1 - 1

	return var_17_2, arg_17_1
end

local function fn_18(arg_18_0, arg_18_1)
	-- function 18
	local var_18_0 = fn_13(arg_18_0, arg_18_1)

	if not var_18_0 then
		return nil
	end

	fn_12(arg_18_0, var_18_0)

	return var_18_0
end

local function fn_19(arg_19_0, arg_19_1)
	-- function 19
	local var_19_0 = fn_13(arg_19_0, arg_19_1)

	if not var_19_0 then
		return
	end

	return fn_17(arg_19_0, var_19_0)
end

local function fn_20(self)
	-- function 20
	local var_20_0 = self[1]
	local var_20_1 = self[2]

	assert(var_20_1 > 0)

	local var_20_2 = var_20_0[var_20_1]

	var_20_0[var_20_1] = nil
	self[2] = var_20_1 - 1

	return var_20_2, var_20_1
end

local function fn_21(self)
	-- function 21
	local var_21_0 = self[1]
	local var_21_1 = self[2]

	assert(var_21_1 > 0)

	var_21_0[var_21_1] = nil
	self[2] = var_21_1 - 1
end

local function fn_22(self, arg_22_1, ...)
	-- function 22
	local var_22_0 = self[1]
	local num = self[2] + 1

	var_22_0[num] = arg_22_1
	self[2] = num
end

local function fn_23(self, arg_23_1, arg_23_2, ...)
	-- function 23
	local var_23_0 = self[1]
	local var_23_1 = self[2]

	var_23_0[var_23_1 + 1] = arg_23_1
	var_23_0[var_23_1 + 2] = arg_23_2
	self[2] = var_23_1 + 2
end

local function fn_24(self, arg_24_1, arg_24_2, arg_24_3, ...)
	-- function 24
	local var_24_0 = self[1]
	local var_24_1 = self[2]

	var_24_0[var_24_1 + 1] = arg_24_1
	var_24_0[var_24_1 + 2] = arg_24_2
	var_24_0[var_24_1 + 3] = arg_24_3
	self[2] = var_24_1 + 3
end

local function fn_25(self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, ...)
	-- function 25
	local var_25_0 = self[1]
	local var_25_1 = self[2]

	var_25_0[var_25_1 + 1] = arg_25_1
	var_25_0[var_25_1 + 2] = arg_25_2
	var_25_0[var_25_1 + 3] = arg_25_3
	var_25_0[var_25_1 + 4] = arg_25_4
	self[2] = var_25_1 + 4
end

local function fn_26(self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, ...)
	-- function 26
	local var_26_0 = self[1]
	local var_26_1 = self[2]

	var_26_0[var_26_1 + 1] = arg_26_1
	var_26_0[var_26_1 + 2] = arg_26_2
	var_26_0[var_26_1 + 3] = arg_26_3
	var_26_0[var_26_1 + 4] = arg_26_4
	var_26_0[var_26_1 + 5] = arg_26_5
	self[2] = var_26_1 + 5
end

local function fn_27(self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, ...)
	-- function 27
	local var_27_0 = self[1]
	local var_27_1 = self[2]

	var_27_0[var_27_1 + 1] = arg_27_1
	var_27_0[var_27_1 + 2] = arg_27_2
	var_27_0[var_27_1 + 3] = arg_27_3
	var_27_0[var_27_1 + 4] = arg_27_4
	var_27_0[var_27_1 + 5] = arg_27_5
	var_27_0[var_27_1 + 6] = arg_27_6
	self[2] = var_27_1 + 6
end

local function fn_28(self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, ...)
	-- function 28
	local var_28_0 = self[1]
	local var_28_1 = self[2]

	var_28_0[var_28_1 + 1] = arg_28_1
	var_28_0[var_28_1 + 2] = arg_28_2
	var_28_0[var_28_1 + 3] = arg_28_3
	var_28_0[var_28_1 + 4] = arg_28_4
	var_28_0[var_28_1 + 5] = arg_28_5
	var_28_0[var_28_1 + 6] = arg_28_6
	var_28_0[var_28_1 + 7] = arg_28_7
	self[2] = var_28_1 + 7
end

local function fn_29(self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, ...)
	-- function 29
	local var_29_0 = self[1]
	local var_29_1 = self[2]

	var_29_0[var_29_1 + 1] = arg_29_1
	var_29_0[var_29_1 + 2] = arg_29_2
	var_29_0[var_29_1 + 3] = arg_29_3
	var_29_0[var_29_1 + 4] = arg_29_4
	var_29_0[var_29_1 + 5] = arg_29_5
	var_29_0[var_29_1 + 6] = arg_29_6
	var_29_0[var_29_1 + 7] = arg_29_7
	var_29_0[var_29_1 + 8] = arg_29_8
	self[2] = var_29_1 + 8
end

local function fn_30(self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9, ...)
	-- function 30
	local var_30_0 = self[1]
	local var_30_1 = self[2]

	var_30_0[var_30_1 + 1] = arg_30_1
	var_30_0[var_30_1 + 2] = arg_30_2
	var_30_0[var_30_1 + 3] = arg_30_3
	var_30_0[var_30_1 + 4] = arg_30_4
	var_30_0[var_30_1 + 5] = arg_30_5
	var_30_0[var_30_1 + 6] = arg_30_6
	var_30_0[var_30_1 + 7] = arg_30_7
	var_30_0[var_30_1 + 8] = arg_30_8
	var_30_0[var_30_1 + 9] = arg_30_9
	self[2] = var_30_1 + 9
end

local function fn_31(self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, ...)
	-- function 31
	local var_31_0 = self[1]
	local var_31_1 = self[2]

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
	self[2] = var_31_1 + 10
end

local function fn_32(self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8, arg_32_9, arg_32_10, arg_32_11, ...)
	-- function 32
	local var_32_0 = self[1]
	local var_32_1 = self[2]

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
	self[2] = var_32_1 + 11
end

local function fn_33(self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10, arg_33_11, arg_33_12, ...)
	-- function 33
	local var_33_0 = self[1]
	local var_33_1 = self[2]

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
	self[2] = var_33_1 + 12
end

local function fn_34(self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9, arg_34_10, arg_34_11, arg_34_12, arg_34_13, ...)
	-- function 34
	local var_34_0 = self[1]
	local var_34_1 = self[2]

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
	self[2] = var_34_1 + 13
end

local function fn_35(self, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8, arg_35_9, arg_35_10, arg_35_11, arg_35_12, arg_35_13, arg_35_14, ...)
	-- function 35
	local var_35_0 = self[1]
	local var_35_1 = self[2]

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
	self[2] = var_35_1 + 14
end

local function fn_36(self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_11, arg_36_12, arg_36_13, arg_36_14, arg_36_15, ...)
	-- function 36
	local var_36_0 = self[1]
	local var_36_1 = self[2]

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
	self[2] = var_36_1 + 15
end

local function fn_37(self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12, arg_37_13, arg_37_14, arg_37_15, arg_37_16, ...)
	-- function 37
	local var_37_0 = self[1]
	local var_37_1 = self[2]

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
	self[2] = var_37_1 + 16
end

local tbl = {
	function (self, arg_38_1)
		-- function 38
		local var_38_0 = self[1]
		local var_38_1 = self[2]

		var_38_0[var_38_1 + 1] = arg_38_1[1]
		self[2] = var_38_1 + 1
	end,
	function (self, arg_39_1)
		-- function 39
		local var_39_0 = self[1]
		local var_39_1 = self[2]

		var_39_0[var_39_1 + 1] = arg_39_1[1]
		var_39_0[var_39_1 + 2] = arg_39_1[2]
		self[2] = var_39_1 + 2
	end,
	function (self, arg_40_1)
		-- function 40
		local var_40_0 = self[1]
		local var_40_1 = self[2]

		var_40_0[var_40_1 + 1] = arg_40_1[1]
		var_40_0[var_40_1 + 2] = arg_40_1[2]
		var_40_0[var_40_1 + 3] = arg_40_1[3]
		self[2] = var_40_1 + 3
	end,
	function (self, arg_41_1)
		-- function 41
		local var_41_0 = self[1]
		local var_41_1 = self[2]

		var_41_0[var_41_1 + 1] = arg_41_1[1]
		var_41_0[var_41_1 + 2] = arg_41_1[2]
		var_41_0[var_41_1 + 3] = arg_41_1[3]
		var_41_0[var_41_1 + 4] = arg_41_1[4]
		self[2] = var_41_1 + 4
	end,
	function (self, arg_42_1)
		-- function 42
		local var_42_0 = self[1]
		local var_42_1 = self[2]

		var_42_0[var_42_1 + 1] = arg_42_1[1]
		var_42_0[var_42_1 + 2] = arg_42_1[2]
		var_42_0[var_42_1 + 3] = arg_42_1[3]
		var_42_0[var_42_1 + 4] = arg_42_1[4]
		var_42_0[var_42_1 + 5] = arg_42_1[5]
		self[2] = var_42_1 + 5
	end,
	function (self, arg_43_1)
		-- function 43
		local var_43_0 = self[1]
		local var_43_1 = self[2]

		var_43_0[var_43_1 + 1] = arg_43_1[1]
		var_43_0[var_43_1 + 2] = arg_43_1[2]
		var_43_0[var_43_1 + 3] = arg_43_1[3]
		var_43_0[var_43_1 + 4] = arg_43_1[4]
		var_43_0[var_43_1 + 5] = arg_43_1[5]
		var_43_0[var_43_1 + 6] = arg_43_1[6]
		self[2] = var_43_1 + 6
	end,
	function (self, arg_44_1)
		-- function 44
		local var_44_0 = self[1]
		local var_44_1 = self[2]

		var_44_0[var_44_1 + 1] = arg_44_1[1]
		var_44_0[var_44_1 + 2] = arg_44_1[2]
		var_44_0[var_44_1 + 3] = arg_44_1[3]
		var_44_0[var_44_1 + 4] = arg_44_1[4]
		var_44_0[var_44_1 + 5] = arg_44_1[5]
		var_44_0[var_44_1 + 6] = arg_44_1[6]
		var_44_0[var_44_1 + 7] = arg_44_1[7]
		self[2] = var_44_1 + 7
	end,
	function (self, arg_45_1)
		-- function 45
		local var_45_0 = self[1]
		local var_45_1 = self[2]

		var_45_0[var_45_1 + 1] = arg_45_1[1]
		var_45_0[var_45_1 + 2] = arg_45_1[2]
		var_45_0[var_45_1 + 3] = arg_45_1[3]
		var_45_0[var_45_1 + 4] = arg_45_1[4]
		var_45_0[var_45_1 + 5] = arg_45_1[5]
		var_45_0[var_45_1 + 6] = arg_45_1[6]
		var_45_0[var_45_1 + 7] = arg_45_1[7]
		var_45_0[var_45_1 + 8] = arg_45_1[8]
		self[2] = var_45_1 + 8
	end
}

local function fn_38(arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	if not tbl[arg_46_2] then
		f(arg_46_0, arg_46_1)
	else
		for i = 1, arg_46_2 do
			fn_22(arg_46_0, arg_46_1[i])
		end
	end
end

local function fn_39(self)
	-- function 47
	return self[1][self[2]]
end

local function fn_40(self)
	-- function 48
	return self[1][1]
end

local function fn_41(self, arg_49_1)
	-- function 49
	local var_49_0 = self[1]
	local var_49_1 = self[2]
	local num = 1

	while num <= var_49_1 do
		if not arg_49_1(var_49_0[num]) then
			var_49_0[num] = var_49_0[var_49_1]
			var_49_0[var_49_1] = nil
			var_49_1 = var_49_1 - 1
		else
			num = num + 1
		end
	end

	local num_2 = self[2] - var_49_1

	self[2] = var_49_1

	return num_2
end

local function fn_42(self, arg_50_1, arg_50_2)
	-- function 50
	local var_50_0 = self[1]
	local var_50_1 = self[2]

	for i = var_50_1, arg_50_2, -1 do
		var_50_0[i + 1] = var_50_0[i]
	end

	var_50_0[arg_50_2] = arg_50_1
	self[2] = var_50_1 + 1
end

local function fn_43(arg_51_0, arg_51_1)
	-- function 51
	return arg_51_0 < arg_51_1
end

local function fn_44(self, arg_52_1, arg_52_2)
	-- function 52
	arg_52_2 = arg_52_2 or fn_43

	local var_52_0 = self[1]
	local var_52_1 = self[2]

	for i = 1, var_52_1 do
		if not arg_52_2(arg_52_1, var_52_0[i]) then
			fn_42(self, arg_52_1, i)

			return i
		end
	end

	local num = var_52_1 + 1

	var_52_0[num] = arg_52_1
	self[2] = num

	return num
end

local floor = math.floor

local function fn_45(self, arg_53_1, arg_53_2)
	-- function 53
	arg_53_2 = arg_53_2 or fn_43

	local var_53_0 = self[1]
	local var_53_1, num = self[2], 1
	local num_2 = 1
	local num_3 = 0

	while num <= var_53_1 do
		num_2 = floor((num + var_53_1) / 2)

		if not arg_53_2(arg_53_1, var_53_0[num_2]) then
			var_53_1, num_3 = num_2 - 1, 0
		else
			num, num_3 = num_2 + 1, 1
		end
	end

	local num_4 = num_2 + num_3

	fn_42(self, arg_53_1, num_4)

	return num_4
end

local tbl_2 = {
	new = fn,
	items = fn_3,
	num_items = fn_4,
	data = fn_2,
	item_index = fn_13,
	empty = fn_10,
	resize = fn_6,
	resize_grow_only = fn_7,
	set_size = fn_8,
	set_empty = fn_9,
	pop_index = fn_11,
	pop_index_value = fn_15,
	pop_item = fn_14,
	pop_item_value = fn_16,
	pop_index_ordered = fn_12,
	pop_item_ordered = fn_18,
	pop_item_value_ordered = fn_19,
	pop_back = fn_20,
	erase_back = fn_21,
	push_back = fn_22,
	push_back2 = fn_23,
	push_back3 = fn_24,
	push_back4 = fn_25,
	push_back5 = fn_26,
	push_back6 = fn_27,
	push_back7 = fn_28,
	push_back8 = fn_29,
	push_back9 = fn_30,
	push_back10 = fn_31,
	push_back11 = fn_32,
	push_back12 = fn_33,
	push_back13 = fn_34,
	push_back14 = fn_35,
	push_back15 = fn_36,
	push_back16 = fn_37,
	push_back_table = fn_38,
	insert_at = fn_42,
	insert_sorted = fn_44,
	binary_insert = fn_45,
	front = fn_40,
	back = fn_39,
	filter = fn_41
}

pdArray = tbl_2

return tbl_2
