-- chunkname: @scripts/utils/sha256.lua

local num = 4294967296
local num_2 = num - 1

local function fn(arg_1_0)
	-- function 1
	local tbl = {}
	local var_1_1 = setmetatable({}, tbl)

	tbl.__index = function (arg_2_0, arg_2_1)
		-- function 2
		local var_2_0 = arg_1_0(arg_2_1)

		var_1_1[arg_2_1] = var_2_0

		return var_2_0
	end

	return var_1_1
end

local function fn_2(arg_3_0, arg_3_1)
	-- function 3
	return function (arg_4_0, arg_4_1)
		-- function 4
		local num = 0
		local num_2 = 1

		while not (arg_4_0 == 0 or arg_4_1 == 0) do
			local num_3 = arg_4_0 % arg_3_1
			local num_4 = arg_4_1 % arg_3_1

			num = num + arg_3_0[num_3][num_4] * num_2
			arg_4_0 = (arg_4_0 - num_3) / arg_3_1
			arg_4_1 = (arg_4_1 - num_4) / arg_3_1
			num_2 = num_2 * arg_3_1
		end

		return num + (arg_4_0 + arg_4_1) * num_2
	end
end

local var_0_4 = (function (self)
	-- function 5
	local var_5_0 = fn_2(self, 2)
	local var_5_1, var_5_2 = fn(function (arg_6_0)
		-- function 6
		return fn(function (arg_7_0)
			-- function 7
			return var_5_0(arg_6_0, arg_7_0)
		end)
	end), fn_2
	local n = self.n

	n = n or 1

	return var_5_2(var_5_1, 2^n)
end)({
	[0] = {
		[0] = 0,
		1
	},
	{
		[0] = 1,
		0
	},
	n = 4
})

local function fn_3(arg_8_0, arg_8_1, arg_8_2, ...)
	-- function 8
	local var_8_0

	if not arg_8_1 then
		arg_8_0 = arg_8_0 % num
		arg_8_1 = arg_8_1 % num

		local var_8_1 = var_0_4(arg_8_0, arg_8_1)

		if not arg_8_2 then
			var_8_1 = fn_3(var_8_1, arg_8_2, ...)
		end

		return var_8_1
	elseif not arg_8_0 then
		return arg_8_0 % num
	else
		return 0
	end
end

local function fn_4(arg_9_0, arg_9_1, arg_9_2, ...)
	-- function 9
	local var_9_0

	if not arg_9_1 then
		arg_9_0 = arg_9_0 % num
		arg_9_1 = arg_9_1 % num

		local num_3 = (arg_9_0 + arg_9_1 - var_0_4(arg_9_0, arg_9_1)) / 2

		if not arg_9_2 then
			num_3 = bit32_band(num_3, arg_9_2, ...)
		end

		return num_3
	elseif not arg_9_0 then
		return arg_9_0 % num
	else
		return num_2
	end
end

local function fn_5(arg_10_0)
	-- function 10
	return (-1 - arg_10_0) % num
end

local function fn_6(arg_11_0, arg_11_1)
	-- function 11
	if arg_11_1 < 0 then
		return lshift(arg_11_0, -arg_11_1)
	end

	return math.floor(arg_11_0 % 4294967296 / 2^arg_11_1)
end

local function fn_7(arg_12_0, arg_12_1)
	-- function 12
	if not (arg_12_1 > 31 or not (arg_12_1 < -31)) then
		return 0
	end

	return fn_6(arg_12_0 % num, arg_12_1)
end

local function fn_8(arg_13_0, arg_13_1)
	-- function 13
	if arg_13_1 < 0 then
		return fn_7(arg_13_0, -arg_13_1)
	end

	return arg_13_0 * 2^arg_13_1 % 4294967296
end

local function fn_9(arg_14_0, arg_14_1)
	-- function 14
	arg_14_0 = arg_14_0 % num
	arg_14_1 = arg_14_1 % 32

	local var_14_0 = fn_4(arg_14_0, 2^arg_14_1 - 1)

	return fn_7(arg_14_0, arg_14_1) + fn_8(var_14_0, 32 - arg_14_1)
end

local tbl = {
	1116352408,
	1899447441,
	3049323471,
	3921009573,
	961987163,
	1508970993,
	2453635748,
	2870763221,
	3624381080,
	310598401,
	607225278,
	1426881987,
	1925078388,
	2162078206,
	2614888103,
	3248222580,
	3835390401,
	4022224774,
	264347078,
	604807628,
	770255983,
	1249150122,
	1555081692,
	1996064986,
	2554220882,
	2821834349,
	2952996808,
	3210313671,
	3336571891,
	3584528711,
	113926993,
	338241895,
	666307205,
	773529912,
	1294757372,
	1396182291,
	1695183700,
	1986661051,
	2177026350,
	2456956037,
	2730485921,
	2820302411,
	3259730800,
	3345764771,
	3516065817,
	3600352804,
	4094571909,
	275423344,
	430227734,
	506948616,
	659060556,
	883997877,
	958139571,
	1322822218,
	1537002063,
	1747873779,
	1955562222,
	2024104815,
	2227730452,
	2361852424,
	2428436474,
	2756734187,
	3204031479,
	3329325298
}

local function fn_10(arg_15_0)
	-- function 15
	return (string.gsub(arg_15_0, ".", function (arg_16_0)
		-- function 16
		return string.format("%02x", string.byte(arg_16_0))
	end))
end

local function fn_11(arg_17_0, arg_17_1)
	-- function 17
	local str = ""

	for i = 1, arg_17_1 do
		local num = arg_17_0 % 256

		str = string.char(num) .. str
		arg_17_0 = (arg_17_0 - num) / 256
	end

	return str
end

local function fn_12(arg_18_0, arg_18_1)
	-- function 18
	local num = 0

	for i = arg_18_1, arg_18_1 + 3 do
		num = num * 256 + string.byte(arg_18_0, i)
	end

	return num
end

local function fn_13(arg_19_0, arg_19_1)
	-- function 19
	local num = 64 - (arg_19_1 + 9) % 64

	arg_19_1 = fn_11(8 * arg_19_1, 8)
	arg_19_0 = arg_19_0 .. "€" .. string.rep("\x00", num) .. arg_19_1

	assert(#arg_19_0 % 64 == 0)

	return arg_19_0
end

local function fn_14(self)
	-- function 20
	self[1] = 1779033703
	self[2] = 3144134277
	self[3] = 1013904242
	self[4] = 2773480762
	self[5] = 1359893119
	self[6] = 2600822924
	self[7] = 528734635
	self[8] = 1541459225

	return self
end

local function fn_15(arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local tbl_2 = {}

	for i = 1, 16 do
		tbl_2[i] = fn_12(arg_21_0, arg_21_1 + (i - 1) * 4)
	end

	for j = 17, 64 do
		local var_21_1 = tbl_2[j - 15]
		local var_21_2 = fn_3(fn_9(var_21_1, 7), fn_9(var_21_1, 18), fn_7(var_21_1, 3))
		local var_21_3 = tbl_2[j - 2]

		tbl_2[j] = tbl_2[j - 16] + var_21_2 + tbl_2[j - 7] + fn_3(fn_9(var_21_3, 17), fn_9(var_21_3, 19), fn_7(var_21_3, 10))
	end

	local var_21_4 = arg_21_2[1]
	local var_21_5 = arg_21_2[2]
	local var_21_6 = arg_21_2[3]
	local var_21_7 = arg_21_2[4]
	local var_21_8 = arg_21_2[5]
	local var_21_9 = arg_21_2[6]
	local var_21_10 = arg_21_2[7]
	local var_21_11 = arg_21_2[8]

	for k = 1, 64 do
		local num = fn_3(fn_9(var_21_4, 2), fn_9(var_21_4, 13), fn_9(var_21_4, 22)) + fn_3(fn_4(var_21_4, var_21_5), fn_4(var_21_4, var_21_6), fn_4(var_21_5, var_21_6))
		local var_21_13 = fn_3(fn_9(var_21_8, 6), fn_9(var_21_8, 11), fn_9(var_21_8, 25))
		local var_21_14 = fn_3(fn_4(var_21_8, var_21_9), fn_4(fn_5(var_21_8), var_21_10))
		local num_2 = var_21_11 + var_21_13 + var_21_14 + tbl[k] + tbl_2[k]

		var_21_11, var_21_10, var_21_9, var_21_8, var_21_7, var_21_6, var_21_5, var_21_4 = var_21_10, var_21_9, var_21_8, var_21_7 + num_2, var_21_6, var_21_5, var_21_4, num_2 + num
	end

	arg_21_2[1] = fn_4(arg_21_2[1] + var_21_4)
	arg_21_2[2] = fn_4(arg_21_2[2] + var_21_5)
	arg_21_2[3] = fn_4(arg_21_2[3] + var_21_6)
	arg_21_2[4] = fn_4(arg_21_2[4] + var_21_7)
	arg_21_2[5] = fn_4(arg_21_2[5] + var_21_8)
	arg_21_2[6] = fn_4(arg_21_2[6] + var_21_9)
	arg_21_2[7] = fn_4(arg_21_2[7] + var_21_10)
	arg_21_2[8] = fn_4(arg_21_2[8] + var_21_11)
end

function sha256(arg_22_0)
	-- function 22
	arg_22_0 = fn_13(arg_22_0, #arg_22_0)

	local var_22_0 = fn_14({})

	for i = 1, #arg_22_0, 64 do
		fn_15(arg_22_0, i, var_22_0)
	end

	return fn_10(fn_11(var_22_0[1], 4) .. fn_11(var_22_0[2], 4) .. fn_11(var_22_0[3], 4) .. fn_11(var_22_0[4], 4) .. fn_11(var_22_0[5], 4) .. fn_11(var_22_0[6], 4) .. fn_11(var_22_0[7], 4) .. fn_11(var_22_0[8], 4))
end
