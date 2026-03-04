-- chunkname: @scripts/utils/sha256.lua

local var_0_0 = 4294967296
local var_0_1 = var_0_0 - 1

local function var_0_2(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = setmetatable({}, var_1_0)

	function var_1_0.__index(arg_2_0, arg_2_1)
		local var_2_0 = arg_1_0(arg_2_1)

		var_1_1[arg_2_1] = var_2_0

		return var_2_0
	end

	return var_1_1
end

local function var_0_3(arg_3_0, arg_3_1)
	return function(arg_4_0, arg_4_1)
		local var_4_0 = 0
		local var_4_1 = 1

		while arg_4_0 ~= 0 and arg_4_1 ~= 0 do
			local var_4_2 = arg_4_0 % arg_3_1
			local var_4_3 = arg_4_1 % arg_3_1

			var_4_0 = var_4_0 + arg_3_0[var_4_2][var_4_3] * var_4_1
			arg_4_0 = (arg_4_0 - var_4_2) / arg_3_1
			arg_4_1 = (arg_4_1 - var_4_3) / arg_3_1
			var_4_1 = var_4_1 * arg_3_1
		end

		return var_4_0 + (arg_4_0 + arg_4_1) * var_4_1
	end
end

local var_0_4 = (function(arg_5_0)
	local var_5_0 = var_0_3(arg_5_0, 2)
	local var_5_1 = var_0_2(function(arg_6_0)
		return var_0_2(function(arg_7_0)
			return var_5_0(arg_6_0, arg_7_0)
		end)
	end)

	return var_0_3(var_5_1, 2^(arg_5_0.n or 1))
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

local function var_0_5(arg_8_0, arg_8_1, arg_8_2, ...)
	local var_8_0

	if arg_8_1 then
		arg_8_0 = arg_8_0 % var_0_0
		arg_8_1 = arg_8_1 % var_0_0

		local var_8_1 = var_0_4(arg_8_0, arg_8_1)

		if arg_8_2 then
			var_8_1 = var_0_5(var_8_1, arg_8_2, ...)
		end

		return var_8_1
	elseif arg_8_0 then
		return arg_8_0 % var_0_0
	else
		return 0
	end
end

local function var_0_6(arg_9_0, arg_9_1, arg_9_2, ...)
	local var_9_0

	if arg_9_1 then
		arg_9_0 = arg_9_0 % var_0_0
		arg_9_1 = arg_9_1 % var_0_0

		local var_9_1 = (arg_9_0 + arg_9_1 - var_0_4(arg_9_0, arg_9_1)) / 2

		if arg_9_2 then
			var_9_1 = bit32_band(var_9_1, arg_9_2, ...)
		end

		return var_9_1
	elseif arg_9_0 then
		return arg_9_0 % var_0_0
	else
		return var_0_1
	end
end

local function var_0_7(arg_10_0)
	return (-1 - arg_10_0) % var_0_0
end

local function var_0_8(arg_11_0, arg_11_1)
	if arg_11_1 < 0 then
		return lshift(arg_11_0, -arg_11_1)
	end

	return math.floor(arg_11_0 % 4294967296 / 2^arg_11_1)
end

local function var_0_9(arg_12_0, arg_12_1)
	if arg_12_1 > 31 or arg_12_1 < -31 then
		return 0
	end

	return var_0_8(arg_12_0 % var_0_0, arg_12_1)
end

local function var_0_10(arg_13_0, arg_13_1)
	if arg_13_1 < 0 then
		return var_0_9(arg_13_0, -arg_13_1)
	end

	return arg_13_0 * 2^arg_13_1 % 4294967296
end

local function var_0_11(arg_14_0, arg_14_1)
	arg_14_0 = arg_14_0 % var_0_0
	arg_14_1 = arg_14_1 % 32

	local var_14_0 = var_0_6(arg_14_0, 2^arg_14_1 - 1)

	return var_0_9(arg_14_0, arg_14_1) + var_0_10(var_14_0, 32 - arg_14_1)
end

local var_0_12 = {
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

local function var_0_13(arg_15_0)
	return (string.gsub(arg_15_0, ".", function(arg_16_0)
		return string.format("%02x", string.byte(arg_16_0))
	end))
end

local function var_0_14(arg_17_0, arg_17_1)
	local var_17_0 = ""

	for iter_17_0 = 1, arg_17_1 do
		local var_17_1 = arg_17_0 % 256

		var_17_0 = string.char(var_17_1) .. var_17_0
		arg_17_0 = (arg_17_0 - var_17_1) / 256
	end

	return var_17_0
end

local function var_0_15(arg_18_0, arg_18_1)
	local var_18_0 = 0

	for iter_18_0 = arg_18_1, arg_18_1 + 3 do
		var_18_0 = var_18_0 * 256 + string.byte(arg_18_0, iter_18_0)
	end

	return var_18_0
end

local function var_0_16(arg_19_0, arg_19_1)
	local var_19_0 = 64 - (arg_19_1 + 9) % 64

	arg_19_1 = var_0_14(8 * arg_19_1, 8)
	arg_19_0 = arg_19_0 .. "€" .. string.rep("\x00", var_19_0) .. arg_19_1

	assert(#arg_19_0 % 64 == 0)

	return arg_19_0
end

local function var_0_17(arg_20_0)
	arg_20_0[1] = 1779033703
	arg_20_0[2] = 3144134277
	arg_20_0[3] = 1013904242
	arg_20_0[4] = 2773480762
	arg_20_0[5] = 1359893119
	arg_20_0[6] = 2600822924
	arg_20_0[7] = 528734635
	arg_20_0[8] = 1541459225

	return arg_20_0
end

local function var_0_18(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {}

	for iter_21_0 = 1, 16 do
		var_21_0[iter_21_0] = var_0_15(arg_21_0, arg_21_1 + (iter_21_0 - 1) * 4)
	end

	for iter_21_1 = 17, 64 do
		local var_21_1 = var_21_0[iter_21_1 - 15]
		local var_21_2 = var_0_5(var_0_11(var_21_1, 7), var_0_11(var_21_1, 18), var_0_9(var_21_1, 3))
		local var_21_3 = var_21_0[iter_21_1 - 2]

		var_21_0[iter_21_1] = var_21_0[iter_21_1 - 16] + var_21_2 + var_21_0[iter_21_1 - 7] + var_0_5(var_0_11(var_21_3, 17), var_0_11(var_21_3, 19), var_0_9(var_21_3, 10))
	end

	local var_21_4 = arg_21_2[1]
	local var_21_5 = arg_21_2[2]
	local var_21_6 = arg_21_2[3]
	local var_21_7 = arg_21_2[4]
	local var_21_8 = arg_21_2[5]
	local var_21_9 = arg_21_2[6]
	local var_21_10 = arg_21_2[7]
	local var_21_11 = arg_21_2[8]

	for iter_21_2 = 1, 64 do
		local var_21_12 = var_0_5(var_0_11(var_21_4, 2), var_0_11(var_21_4, 13), var_0_11(var_21_4, 22)) + var_0_5(var_0_6(var_21_4, var_21_5), var_0_6(var_21_4, var_21_6), var_0_6(var_21_5, var_21_6))
		local var_21_13 = var_0_5(var_0_11(var_21_8, 6), var_0_11(var_21_8, 11), var_0_11(var_21_8, 25))
		local var_21_14 = var_0_5(var_0_6(var_21_8, var_21_9), var_0_6(var_0_7(var_21_8), var_21_10))
		local var_21_15 = var_21_11 + var_21_13 + var_21_14 + var_0_12[iter_21_2] + var_21_0[iter_21_2]

		var_21_11, var_21_10, var_21_9, var_21_8, var_21_7, var_21_6, var_21_5, var_21_4 = var_21_10, var_21_9, var_21_8, var_21_7 + var_21_15, var_21_6, var_21_5, var_21_4, var_21_15 + var_21_12
	end

	arg_21_2[1] = var_0_6(arg_21_2[1] + var_21_4)
	arg_21_2[2] = var_0_6(arg_21_2[2] + var_21_5)
	arg_21_2[3] = var_0_6(arg_21_2[3] + var_21_6)
	arg_21_2[4] = var_0_6(arg_21_2[4] + var_21_7)
	arg_21_2[5] = var_0_6(arg_21_2[5] + var_21_8)
	arg_21_2[6] = var_0_6(arg_21_2[6] + var_21_9)
	arg_21_2[7] = var_0_6(arg_21_2[7] + var_21_10)
	arg_21_2[8] = var_0_6(arg_21_2[8] + var_21_11)
end

function sha256(arg_22_0)
	arg_22_0 = var_0_16(arg_22_0, #arg_22_0)

	local var_22_0 = var_0_17({})

	for iter_22_0 = 1, #arg_22_0, 64 do
		var_0_18(arg_22_0, iter_22_0, var_22_0)
	end

	return var_0_13(var_0_14(var_22_0[1], 4) .. var_0_14(var_22_0[2], 4) .. var_0_14(var_22_0[3], 4) .. var_0_14(var_22_0[4], 4) .. var_0_14(var_22_0[5], 4) .. var_0_14(var_22_0[6], 4) .. var_0_14(var_22_0[7], 4) .. var_0_14(var_22_0[8], 4))
end
