-- chunkname: @scripts/utils/lib_deflate.lua

local var_0_0
local var_0_1 = "1.0.2-release"
local var_0_2 = "LibDeflate"
local var_0_3 = 3
local var_0_4 = "LibDeflate " .. var_0_1 .. " Copyright (C) 2018-2020 Haoqian He." .. " Licensed under the zlib License"
local var_0_5 = {
	_VERSION = var_0_1,
	_MAJOR = var_0_2,
	_MINOR = var_0_3,
	_COPYRIGHT = var_0_4
}
local var_0_6 = assert
local var_0_7 = error
local var_0_8 = pairs
local var_0_9 = string.byte
local var_0_10 = string.char
local var_0_11 = string.sub
local var_0_12 = table.concat
local var_0_13 = table.sort
local var_0_14 = tostring
local var_0_15 = type
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}
local var_0_19 = {}
local var_0_20 = {}
local var_0_21 = {}
local var_0_22 = {}
local var_0_23 = {}
local var_0_24 = {}
local var_0_25 = {
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	13,
	15,
	17,
	19,
	23,
	27,
	31,
	35,
	43,
	51,
	59,
	67,
	83,
	99,
	115,
	131,
	163,
	195,
	227,
	258
}
local var_0_26 = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	1,
	1,
	1,
	1,
	2,
	2,
	2,
	2,
	3,
	3,
	3,
	3,
	4,
	4,
	4,
	4,
	5,
	5,
	5,
	5,
	0
}
local var_0_27 = {
	[0] = 1,
	2,
	3,
	4,
	5,
	7,
	9,
	13,
	17,
	25,
	33,
	49,
	65,
	97,
	129,
	193,
	257,
	385,
	513,
	769,
	1025,
	1537,
	2049,
	3073,
	4097,
	6145,
	8193,
	12289,
	16385,
	24577
}
local var_0_28 = {
	[0] = 0,
	0,
	0,
	0,
	1,
	1,
	2,
	2,
	3,
	3,
	4,
	4,
	5,
	5,
	6,
	6,
	7,
	7,
	8,
	8,
	9,
	9,
	10,
	10,
	11,
	11,
	12,
	12,
	13,
	13
}
local var_0_29 = {
	16,
	17,
	18,
	0,
	8,
	7,
	9,
	6,
	10,
	5,
	11,
	4,
	12,
	3,
	13,
	2,
	14,
	1,
	15
}
local var_0_30
local var_0_31
local var_0_32
local var_0_33
local var_0_34
local var_0_35
local var_0_36
local var_0_37

for iter_0_0 = 0, 255 do
	var_0_17[iter_0_0] = var_0_10(iter_0_0)
end

local var_0_38 = 1

for iter_0_1 = 0, 32 do
	var_0_16[iter_0_1] = var_0_38
	var_0_38 = var_0_38 * 2
end

for iter_0_2 = 1, 9 do
	var_0_18[iter_0_2] = {}

	for iter_0_3 = 0, var_0_16[iter_0_2 + 1] - 1 do
		local var_0_39 = 0
		local var_0_40 = iter_0_3

		for iter_0_4 = 1, iter_0_2 do
			var_0_39 = var_0_39 - var_0_39 % 2 + ((var_0_39 % 2 == 1 or var_0_40 % 2 == 1) and 1 or 0)
			var_0_40 = (var_0_40 - var_0_40 % 2) / 2
			var_0_39 = var_0_39 * 2
		end

		var_0_18[iter_0_2][iter_0_3] = (var_0_39 - var_0_39 % 2) / 2
	end
end

local var_0_41 = 18
local var_0_42 = 16
local var_0_43 = 265
local var_0_44 = 1

for iter_0_5 = 3, 258 do
	if iter_0_5 <= 10 then
		var_0_19[iter_0_5] = iter_0_5 + 254
		var_0_21[iter_0_5] = 0
	elseif iter_0_5 == 258 then
		var_0_19[iter_0_5] = 285
		var_0_21[iter_0_5] = 0
	else
		if var_0_41 < iter_0_5 then
			var_0_41 = var_0_41 + var_0_42
			var_0_42 = var_0_42 * 2
			var_0_43 = var_0_43 + 4
			var_0_44 = var_0_44 + 1
		end

		local var_0_45 = iter_0_5 - var_0_41 - 1 + var_0_42 / 2

		var_0_19[iter_0_5] = (var_0_45 - var_0_45 % (var_0_42 / 8)) / (var_0_42 / 8) + var_0_43
		var_0_21[iter_0_5] = var_0_44
		var_0_20[iter_0_5] = var_0_45 % (var_0_42 / 8)
	end
end

var_0_22[1] = 0
var_0_22[2] = 1
var_0_24[1] = 0
var_0_24[2] = 0

local var_0_46 = 3
local var_0_47 = 4
local var_0_48 = 2
local var_0_49 = 0

for iter_0_6 = 3, 256 do
	if var_0_47 < iter_0_6 then
		var_0_46 = var_0_46 * 2
		var_0_47 = var_0_47 * 2
		var_0_48 = var_0_48 + 2
		var_0_49 = var_0_49 + 1
	end

	var_0_22[iter_0_6] = iter_0_6 <= var_0_46 and var_0_48 or var_0_48 + 1
	var_0_24[iter_0_6] = var_0_49 < 0 and 0 or var_0_49

	if var_0_47 >= 8 then
		var_0_23[iter_0_6] = (iter_0_6 - var_0_47 / 2 - 1) % (var_0_47 / 4)
	end
end

var_0_5.Adler32 = function (arg_1_0, arg_1_1)
	if var_0_15(arg_1_1) ~= "string" then
		var_0_7(("Usage: LibDeflate:Adler32(str):" .. " 'str' - string expected got '%s'."):format(var_0_15(arg_1_1)), 2)
	end

	local var_1_0 = #arg_1_1
	local var_1_1 = 1
	local var_1_2 = 1
	local var_1_3 = 0

	while var_1_1 <= var_1_0 - 15 do
		local var_1_4, var_1_5, var_1_6, var_1_7, var_1_8, var_1_9, var_1_10, var_1_11, var_1_12, var_1_13, var_1_14, var_1_15, var_1_16, var_1_17, var_1_18, var_1_19 = var_0_9(arg_1_1, var_1_1, var_1_1 + 15)

		var_1_3 = (var_1_3 + 16 * var_1_2 + 16 * var_1_4 + 15 * var_1_5 + 14 * var_1_6 + 13 * var_1_7 + 12 * var_1_8 + 11 * var_1_9 + 10 * var_1_10 + 9 * var_1_11 + 8 * var_1_12 + 7 * var_1_13 + 6 * var_1_14 + 5 * var_1_15 + 4 * var_1_16 + 3 * var_1_17 + 2 * var_1_18 + var_1_19) % 65521
		var_1_2 = (var_1_2 + var_1_4 + var_1_5 + var_1_6 + var_1_7 + var_1_8 + var_1_9 + var_1_10 + var_1_11 + var_1_12 + var_1_13 + var_1_14 + var_1_15 + var_1_16 + var_1_17 + var_1_18 + var_1_19) % 65521
		var_1_1 = var_1_1 + 16
	end

	while var_1_1 <= var_1_0 do
		var_1_2 = (var_1_2 + var_0_9(arg_1_1, var_1_1, var_1_1)) % 65521
		var_1_3 = (var_1_3 + var_1_2) % 65521
		var_1_1 = var_1_1 + 1
	end

	return (var_1_3 * 65536 + var_1_2) % 4294967296
end

local function var_0_50(arg_2_0, arg_2_1)
	return arg_2_0 % 4294967296 == arg_2_1 % 4294967296
end

var_0_5.CreateDictionary = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if var_0_15(arg_3_1) ~= "string" then
		var_0_7(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'str' - string expected got '%s'."):format(var_0_15(arg_3_1)), 2)
	end

	if var_0_15(arg_3_2) ~= "number" then
		var_0_7(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'strlen' - number expected got '%s'."):format(var_0_15(arg_3_2)), 2)
	end

	if var_0_15(arg_3_3) ~= "number" then
		var_0_7(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'adler32' - number expected got '%s'."):format(var_0_15(arg_3_3)), 2)
	end

	if arg_3_2 ~= #arg_3_1 then
		var_0_7(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'strlen' does not match the actual length of 'str'." .. " 'strlen': %u, '#str': %u ." .. " Please check if 'str' is modified unintentionally."):format(arg_3_2, #arg_3_1))
	end

	if arg_3_2 == 0 then
		var_0_7("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'str' - Empty string is not allowed.", 2)
	end

	if arg_3_2 > 32768 then
		var_0_7(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'str' - string longer than 32768 bytes is not allowed." .. " Got %d bytes."):format(arg_3_2), 2)
	end

	local var_3_0 = arg_3_0:Adler32(arg_3_1)

	if not var_0_50(arg_3_3, var_3_0) then
		var_0_7(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'adler32' does not match the actual adler32 of 'str'." .. " 'adler32': %u, 'Adler32(str)': %u ." .. " Please check if 'str' is modified unintentionally."):format(arg_3_3, var_3_0))
	end

	local var_3_1 = {
		adler32 = arg_3_3,
		hash_tables = {},
		string_table = {},
		strlen = arg_3_2
	}
	local var_3_2 = var_3_1.string_table
	local var_3_3 = var_3_1.hash_tables

	var_3_2[1] = var_0_9(arg_3_1, 1, 1)
	var_3_2[2] = var_0_9(arg_3_1, 2, 2)

	if arg_3_2 >= 3 then
		local var_3_4 = 1
		local var_3_5 = var_3_2[1] * 256 + var_3_2[2]

		while var_3_4 <= arg_3_2 - 2 - 3 do
			local var_3_6, var_3_7, var_3_8, var_3_9 = var_0_9(arg_3_1, var_3_4 + 2, var_3_4 + 5)

			var_3_2[var_3_4 + 2] = var_3_6
			var_3_2[var_3_4 + 3] = var_3_7
			var_3_2[var_3_4 + 4] = var_3_8
			var_3_2[var_3_4 + 5] = var_3_9
			var_3_5 = (var_3_5 * 256 + var_3_6) % 16777216

			local var_3_10 = var_3_3[var_3_5]

			if not var_3_10 then
				var_3_10 = {}
				var_3_3[var_3_5] = var_3_10
			end

			var_3_10[#var_3_10 + 1] = var_3_4 - arg_3_2
			var_3_4 = var_3_4 + 1
			var_3_5 = (var_3_5 * 256 + var_3_7) % 16777216

			local var_3_11 = var_3_3[var_3_5]

			if not var_3_11 then
				var_3_11 = {}
				var_3_3[var_3_5] = var_3_11
			end

			var_3_11[#var_3_11 + 1] = var_3_4 - arg_3_2
			var_3_4 = var_3_4 + 1
			var_3_5 = (var_3_5 * 256 + var_3_8) % 16777216

			local var_3_12 = var_3_3[var_3_5]

			if not var_3_12 then
				var_3_12 = {}
				var_3_3[var_3_5] = var_3_12
			end

			var_3_12[#var_3_12 + 1] = var_3_4 - arg_3_2
			var_3_4 = var_3_4 + 1
			var_3_5 = (var_3_5 * 256 + var_3_9) % 16777216

			local var_3_13 = var_3_3[var_3_5]

			if not var_3_13 then
				var_3_13 = {}
				var_3_3[var_3_5] = var_3_13
			end

			var_3_13[#var_3_13 + 1] = var_3_4 - arg_3_2
			var_3_4 = var_3_4 + 1
		end

		while var_3_4 <= arg_3_2 - 2 do
			local var_3_14 = var_0_9(arg_3_1, var_3_4 + 2)

			var_3_2[var_3_4 + 2] = var_3_14
			var_3_5 = (var_3_5 * 256 + var_3_14) % 16777216

			local var_3_15 = var_3_3[var_3_5]

			if not var_3_15 then
				var_3_15 = {}
				var_3_3[var_3_5] = var_3_15
			end

			var_3_15[#var_3_15 + 1] = var_3_4 - arg_3_2
			var_3_4 = var_3_4 + 1
		end
	end

	return var_3_1
end

local function var_0_51(arg_4_0)
	if var_0_15(arg_4_0) ~= "table" then
		return false, ("'dictionary' - table expected got '%s'."):format(var_0_15(arg_4_0))
	end

	if var_0_15(arg_4_0.adler32) ~= "number" or var_0_15(arg_4_0.string_table) ~= "table" or var_0_15(arg_4_0.strlen) ~= "number" or arg_4_0.strlen <= 0 or arg_4_0.strlen > 32768 or arg_4_0.strlen ~= #arg_4_0.string_table or var_0_15(arg_4_0.hash_tables) ~= "table" then
		return false, ("'dictionary' - corrupted dictionary."):format(var_0_15(arg_4_0))
	end

	return true, ""
end

local var_0_52 = {
	[0] = {
		false,
		nil,
		0,
		0,
		0
	},
	{
		false,
		nil,
		4,
		8,
		4
	},
	{
		false,
		nil,
		5,
		18,
		8
	},
	{
		false,
		nil,
		6,
		32,
		32
	},
	{
		true,
		4,
		4,
		16,
		16
	},
	{
		true,
		8,
		16,
		32,
		32
	},
	{
		true,
		8,
		16,
		128,
		128
	},
	{
		true,
		8,
		32,
		128,
		256
	},
	{
		true,
		32,
		128,
		258,
		1024
	},
	{
		true,
		32,
		258,
		258,
		4096
	}
}

local function var_0_53(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if var_0_15(arg_5_0) ~= "string" then
		return false, ("'str' - string expected got '%s'."):format(var_0_15(arg_5_0))
	end

	if arg_5_1 then
		local var_5_0, var_5_1 = var_0_51(arg_5_2)

		if not var_5_0 then
			return false, var_5_1
		end
	end

	if arg_5_3 then
		local var_5_2 = var_0_15(arg_5_4)

		if var_5_2 ~= "nil" and var_5_2 ~= "table" then
			return false, ("'configs' - nil or table expected got '%s'."):format(var_0_15(arg_5_4))
		end

		if var_5_2 == "table" then
			for iter_5_0, iter_5_1 in var_0_8(arg_5_4) do
				if iter_5_0 ~= "level" and iter_5_0 ~= "strategy" then
					return false, ("'configs' - unsupported table key in the configs: '%s'."):format(iter_5_0)
				elseif iter_5_0 == "level" and not var_0_52[iter_5_1] then
					return false, ("'configs' - unsupported 'level': %s."):format(var_0_14(iter_5_1))
				elseif iter_5_0 == "strategy" and iter_5_1 ~= "fixed" and iter_5_1 ~= "huffman_only" and iter_5_1 ~= "dynamic" then
					return false, ("'configs' - unsupported 'strategy': '%s'."):format(var_0_14(iter_5_1))
				end
			end
		end
	end

	return true, ""
end

local var_0_54 = 0
local var_0_55 = 1
local var_0_56 = 2
local var_0_57 = 3

local function var_0_58()
	local var_6_0 = 0
	local var_6_1 = 0
	local var_6_2 = 0
	local var_6_3 = 0
	local var_6_4 = {}
	local var_6_5 = {}

	local function var_6_6(arg_7_0, arg_7_1)
		var_6_1 = var_6_1 + arg_7_0 * var_0_16[var_6_2]
		var_6_2 = var_6_2 + arg_7_1
		var_6_3 = var_6_3 + arg_7_1

		if var_6_2 >= 32 then
			var_6_0 = var_6_0 + 1
			var_6_4[var_6_0] = var_0_17[var_6_1 % 256] .. var_0_17[(var_6_1 - var_6_1 % 256) / 256 % 256] .. var_0_17[(var_6_1 - var_6_1 % 65536) / 65536 % 256] .. var_0_17[(var_6_1 - var_6_1 % 16777216) / 16777216 % 256]

			local var_7_0 = var_0_16[32 - var_6_2 + arg_7_1]

			var_6_1 = (arg_7_0 - arg_7_0 % var_7_0) / var_7_0
			var_6_2 = var_6_2 - 32
		end
	end

	local function var_6_7(arg_8_0)
		for iter_8_0 = 1, var_6_2, 8 do
			var_6_0 = var_6_0 + 1
			var_6_4[var_6_0] = var_0_10(var_6_1 % 256)
			var_6_1 = (var_6_1 - var_6_1 % 256) / 256
		end

		var_6_2 = 0
		var_6_0 = var_6_0 + 1
		var_6_4[var_6_0] = arg_8_0
		var_6_3 = var_6_3 + #arg_8_0 * 8
	end

	local function var_6_8(arg_9_0)
		if arg_9_0 == var_0_57 then
			return var_6_3
		end

		if arg_9_0 == var_0_55 or arg_9_0 == var_0_56 then
			local var_9_0 = (8 - var_6_2 % 8) % 8

			if var_6_2 > 0 then
				var_6_1 = var_6_1 - var_0_16[var_6_2] + var_0_16[var_6_2 + var_9_0]

				for iter_9_0 = 1, var_6_2, 8 do
					var_6_0 = var_6_0 + 1
					var_6_4[var_6_0] = var_0_17[var_6_1 % 256]
					var_6_1 = (var_6_1 - var_6_1 % 256) / 256
				end

				var_6_1 = 0
				var_6_2 = 0
			end

			if arg_9_0 == var_0_56 then
				var_6_3 = var_6_3 + var_9_0

				return var_6_3
			end
		end

		local var_9_1 = var_0_12(var_6_4)

		var_6_4 = {}
		var_6_0 = 0
		var_6_5[#var_6_5 + 1] = var_9_1

		if arg_9_0 == var_0_54 then
			return var_6_3
		else
			return var_6_3, var_0_12(var_6_5)
		end
	end

	return var_6_6, var_6_7, var_6_8
end

local function var_0_59(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 + 1
	arg_10_0[arg_10_2] = arg_10_1

	local var_10_0 = arg_10_1[1]
	local var_10_1 = arg_10_2
	local var_10_2 = (var_10_1 - var_10_1 % 2) / 2

	while var_10_2 >= 1 and var_10_0 < arg_10_0[var_10_2][1] do
		arg_10_0[var_10_1], arg_10_0[var_10_2] = arg_10_0[var_10_2], arg_10_1
		var_10_1 = var_10_2
		var_10_2 = (var_10_2 - var_10_2 % 2) / 2
	end
end

local function var_0_60(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0[1]
	local var_11_1 = arg_11_0[arg_11_1]
	local var_11_2 = var_11_1[1]

	arg_11_0[1] = var_11_1
	arg_11_0[arg_11_1] = var_11_0
	arg_11_1 = arg_11_1 - 1

	local var_11_3 = 1
	local var_11_4 = var_11_3 * 2
	local var_11_5 = var_11_4 + 1

	while var_11_4 <= arg_11_1 do
		local var_11_6 = arg_11_0[var_11_4]

		if var_11_5 <= arg_11_1 and arg_11_0[var_11_5][1] < var_11_6[1] then
			local var_11_7 = arg_11_0[var_11_5]

			if var_11_2 > var_11_7[1] then
				arg_11_0[var_11_5] = var_11_1
				arg_11_0[var_11_3] = var_11_7
				var_11_3 = var_11_5
				var_11_4 = var_11_3 * 2
				var_11_5 = var_11_4 + 1
			else
				break
			end
		elseif var_11_2 > var_11_6[1] then
			arg_11_0[var_11_4] = var_11_1
			arg_11_0[var_11_3] = var_11_6
			var_11_3 = var_11_4
			var_11_4 = var_11_3 * 2
			var_11_5 = var_11_4 + 1
		else
			break
		end
	end

	return var_11_0
end

local function var_0_61(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = 0
	local var_12_1 = {}
	local var_12_2 = {}

	for iter_12_0 = 1, arg_12_3 do
		var_12_0 = (var_12_0 + (arg_12_0[iter_12_0 - 1] or 0)) * 2
		var_12_1[iter_12_0] = var_12_0
	end

	for iter_12_1 = 0, arg_12_2 do
		local var_12_3 = arg_12_1[iter_12_1]

		if var_12_3 then
			local var_12_4 = var_12_1[var_12_3]

			var_12_1[var_12_3] = var_12_4 + 1

			if var_12_3 <= 9 then
				var_12_2[iter_12_1] = var_0_18[var_12_3][var_12_4]
			else
				local var_12_5 = 0

				for iter_12_2 = 1, var_12_3 do
					var_12_5 = var_12_5 - var_12_5 % 2 + ((var_12_5 % 2 == 1 or var_12_4 % 2 == 1) and 1 or 0)
					var_12_4 = (var_12_4 - var_12_4 % 2) / 2
					var_12_5 = var_12_5 * 2
				end

				var_12_2[iter_12_1] = (var_12_5 - var_12_5 % 2) / 2
			end
		end
	end

	return var_12_2
end

local function var_0_62(arg_13_0, arg_13_1)
	return arg_13_0[1] < arg_13_1[1] or arg_13_0[1] == arg_13_1[1] and arg_13_0[2] < arg_13_1[2]
end

local function var_0_63(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0
	local var_14_1 = -1
	local var_14_2 = {}
	local var_14_3 = {}
	local var_14_4 = {}
	local var_14_5 = {}
	local var_14_6 = {}
	local var_14_7 = 0

	for iter_14_0, iter_14_1 in var_0_8(arg_14_0) do
		var_14_7 = var_14_7 + 1
		var_14_2[var_14_7] = {
			iter_14_1,
			iter_14_0
		}
	end

	if var_14_7 == 0 then
		return {}, {}, -1
	elseif var_14_7 == 1 then
		local var_14_8 = var_14_2[1][2]

		var_14_4[var_14_8] = 1
		var_14_5[var_14_8] = 0

		return var_14_4, var_14_5, var_14_8
	else
		var_0_13(var_14_2, var_0_62)

		local var_14_9 = var_14_7

		for iter_14_2 = 1, var_14_9 do
			var_14_3[iter_14_2] = var_14_2[iter_14_2]
		end

		while var_14_9 > 1 do
			local var_14_10 = var_0_60(var_14_3, var_14_9)

			var_14_9 = var_14_9 - 1

			local var_14_11 = var_0_60(var_14_3, var_14_9)

			var_14_9 = var_14_9 - 1

			local var_14_12 = {
				var_14_10[1] + var_14_11[1],
				-1,
				var_14_10,
				var_14_11
			}

			var_0_59(var_14_3, var_14_12, var_14_9)

			var_14_9 = var_14_9 + 1
		end

		local var_14_13 = 0
		local var_14_14 = {
			var_14_3[1],
			0,
			0,
			0
		}
		local var_14_15 = 1
		local var_14_16 = 1

		var_14_3[1][1] = 0

		while var_14_16 <= var_14_15 do
			local var_14_17 = var_14_14[var_14_16]
			local var_14_18 = var_14_17[1]
			local var_14_19 = var_14_17[2]
			local var_14_20 = var_14_17[3]
			local var_14_21 = var_14_17[4]

			if var_14_20 then
				var_14_15 = var_14_15 + 1
				var_14_14[var_14_15] = var_14_20
				var_14_20[1] = var_14_18 + 1
			end

			if var_14_21 then
				var_14_15 = var_14_15 + 1
				var_14_14[var_14_15] = var_14_21
				var_14_21[1] = var_14_18 + 1
			end

			var_14_16 = var_14_16 + 1

			if arg_14_1 < var_14_18 then
				var_14_13 = var_14_13 + 1
				var_14_18 = arg_14_1
			end

			if var_14_19 >= 0 then
				var_14_4[var_14_19] = var_14_18
				var_14_1 = var_14_1 < var_14_19 and var_14_19 or var_14_1
				var_14_6[var_14_18] = (var_14_6[var_14_18] or 0) + 1
			end
		end

		if var_14_13 > 0 then
			repeat
				local var_14_22 = arg_14_1 - 1

				while (var_14_6[var_14_22] or 0) == 0 do
					var_14_22 = var_14_22 - 1
				end

				var_14_6[var_14_22] = var_14_6[var_14_22] - 1
				var_14_6[var_14_22 + 1] = (var_14_6[var_14_22 + 1] or 0) + 2
				var_14_6[arg_14_1] = var_14_6[arg_14_1] - 1
				var_14_13 = var_14_13 - 2
			until var_14_13 <= 0

			local var_14_23 = 1

			for iter_14_3 = arg_14_1, 1, -1 do
				local var_14_24 = var_14_6[iter_14_3] or 0

				while var_14_24 > 0 do
					var_14_4[var_14_2[var_14_23][2]] = iter_14_3
					var_14_24 = var_14_24 - 1
					var_14_23 = var_14_23 + 1
				end
			end
		end

		local var_14_25 = var_0_61(var_14_6, var_14_4, arg_14_2, arg_14_1)

		return var_14_4, var_14_25, var_14_1
	end
end

local function var_0_64(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = 0
	local var_15_1 = {}
	local var_15_2 = {}
	local var_15_3 = 0
	local var_15_4 = {}
	local var_15_5
	local var_15_6 = 0

	arg_15_3 = arg_15_3 < 0 and 0 or arg_15_3

	local var_15_7 = arg_15_1 + arg_15_3 + 1

	for iter_15_0 = 0, var_15_7 + 1 do
		local var_15_8 = iter_15_0 <= arg_15_1 and (arg_15_0[iter_15_0] or 0) or iter_15_0 <= var_15_7 and (arg_15_2[iter_15_0 - arg_15_1 - 1] or 0) or nil

		if var_15_8 == var_15_5 then
			var_15_6 = var_15_6 + 1

			if var_15_8 ~= 0 and var_15_6 == 6 then
				var_15_0 = var_15_0 + 1
				var_15_1[var_15_0] = 16
				var_15_3 = var_15_3 + 1
				var_15_4[var_15_3] = 3
				var_15_2[16] = (var_15_2[16] or 0) + 1
				var_15_6 = 0
			elseif var_15_8 == 0 and var_15_6 == 138 then
				var_15_0 = var_15_0 + 1
				var_15_1[var_15_0] = 18
				var_15_3 = var_15_3 + 1
				var_15_4[var_15_3] = 127
				var_15_2[18] = (var_15_2[18] or 0) + 1
				var_15_6 = 0
			end
		else
			if var_15_6 == 1 then
				var_15_0 = var_15_0 + 1
				var_15_1[var_15_0] = var_15_5
				var_15_2[var_15_5] = (var_15_2[var_15_5] or 0) + 1
			elseif var_15_6 == 2 then
				var_15_0 = var_15_0 + 1
				var_15_1[var_15_0] = var_15_5
				var_15_0 = var_15_0 + 1
				var_15_1[var_15_0] = var_15_5
				var_15_2[var_15_5] = (var_15_2[var_15_5] or 0) + 2
			elseif var_15_6 >= 3 then
				var_15_0 = var_15_0 + 1

				local var_15_9 = var_15_5 ~= 0 and 16 or var_15_6 <= 10 and 17 or 18

				var_15_1[var_15_0] = var_15_9
				var_15_2[var_15_9] = (var_15_2[var_15_9] or 0) + 1
				var_15_3 = var_15_3 + 1
				var_15_4[var_15_3] = var_15_6 <= 10 and var_15_6 - 3 or var_15_6 - 11
			end

			var_15_5 = var_15_8

			if var_15_8 and var_15_8 ~= 0 then
				var_15_0 = var_15_0 + 1
				var_15_1[var_15_0] = var_15_8
				var_15_2[var_15_8] = (var_15_2[var_15_8] or 0) + 1
				var_15_6 = 0
			else
				var_15_6 = 1
			end
		end
	end

	return var_15_1, var_15_4, var_15_2
end

local function var_0_65(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_2 - arg_16_4

	while var_16_0 <= arg_16_3 - 15 - arg_16_4 do
		arg_16_1[var_16_0], arg_16_1[var_16_0 + 1], arg_16_1[var_16_0 + 2], arg_16_1[var_16_0 + 3], arg_16_1[var_16_0 + 4], arg_16_1[var_16_0 + 5], arg_16_1[var_16_0 + 6], arg_16_1[var_16_0 + 7], arg_16_1[var_16_0 + 8], arg_16_1[var_16_0 + 9], arg_16_1[var_16_0 + 10], arg_16_1[var_16_0 + 11], arg_16_1[var_16_0 + 12], arg_16_1[var_16_0 + 13], arg_16_1[var_16_0 + 14], arg_16_1[var_16_0 + 15] = var_0_9(arg_16_0, var_16_0 + arg_16_4, var_16_0 + 15 + arg_16_4)
		var_16_0 = var_16_0 + 16
	end

	while var_16_0 <= arg_16_3 - arg_16_4 do
		arg_16_1[var_16_0] = var_0_9(arg_16_0, var_16_0 + arg_16_4, var_16_0 + arg_16_4)
		var_16_0 = var_16_0 + 1
	end

	return arg_16_1
end

local function var_0_66(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	local var_17_0 = var_0_52[arg_17_0]
	local var_17_1 = var_17_0[1]
	local var_17_2 = var_17_0[2]
	local var_17_3 = var_17_0[3]
	local var_17_4 = var_17_0[4]
	local var_17_5 = var_17_0[5]
	local var_17_6 = not var_17_1 and var_17_3 or 2147483646
	local var_17_7 = var_17_5 - var_17_5 % 4 / 4
	local var_17_8
	local var_17_9
	local var_17_10
	local var_17_11 = 0

	if arg_17_6 then
		var_17_9 = arg_17_6.hash_tables
		var_17_10 = arg_17_6.string_table
		var_17_11 = arg_17_6.strlen

		var_0_6(arg_17_3 == 1)

		if arg_17_3 <= arg_17_4 and var_17_11 >= 2 then
			local var_17_12 = var_17_10[var_17_11 - 1] * 65536 + var_17_10[var_17_11] * 256 + arg_17_1[1]
			local var_17_13 = arg_17_2[var_17_12]

			if not var_17_13 then
				var_17_13 = {}
				arg_17_2[var_17_12] = var_17_13
			end

			var_17_13[#var_17_13 + 1] = -1
		end

		if arg_17_4 >= arg_17_3 + 1 and var_17_11 >= 1 then
			local var_17_14 = var_17_10[var_17_11] * 65536 + arg_17_1[1] * 256 + arg_17_1[2]
			local var_17_15 = arg_17_2[var_17_14]

			if not var_17_15 then
				var_17_15 = {}
				arg_17_2[var_17_14] = var_17_15
			end

			var_17_15[#var_17_15 + 1] = 0
		end
	end

	local var_17_16 = var_17_11 + 3
	local var_17_17 = (arg_17_1[arg_17_3 - arg_17_5] or 0) * 256 + (arg_17_1[arg_17_3 + 1 - arg_17_5] or 0)
	local var_17_18 = {}
	local var_17_19 = 0
	local var_17_20 = {}
	local var_17_21 = {}
	local var_17_22 = 0
	local var_17_23 = {}
	local var_17_24 = {}
	local var_17_25 = 0
	local var_17_26 = {}
	local var_17_27 = 0
	local var_17_28 = false
	local var_17_29
	local var_17_30
	local var_17_31 = 0
	local var_17_32 = 0
	local var_17_33 = arg_17_3
	local var_17_34 = arg_17_4 + (var_17_1 and 1 or 0)

	while var_17_33 <= var_17_34 do
		local var_17_35 = var_17_33 - arg_17_5
		local var_17_36 = arg_17_5 - 3
		local var_17_37 = var_17_31
		local var_17_38 = var_17_32

		var_17_31 = 0
		var_17_17 = (var_17_17 * 256 + (arg_17_1[var_17_35 + 2] or 0)) % 16777216

		local var_17_39
		local var_17_40
		local var_17_41 = arg_17_2[var_17_17]
		local var_17_42

		if not var_17_41 then
			var_17_42 = 0
			var_17_41 = {}
			arg_17_2[var_17_17] = var_17_41

			if var_17_9 then
				var_17_40 = var_17_9[var_17_17]
				var_17_39 = var_17_40 and #var_17_40 or 0
			else
				var_17_39 = 0
			end
		else
			var_17_42 = #var_17_41
			var_17_40 = var_17_41
			var_17_39 = var_17_42
		end

		if var_17_33 <= arg_17_4 then
			var_17_41[var_17_42 + 1] = var_17_33
		end

		if var_17_39 > 0 and arg_17_4 >= var_17_33 + 2 and (not var_17_1 or var_17_37 < var_17_3) then
			local var_17_43 = var_17_1 and var_17_2 <= var_17_37 and var_17_7 or var_17_5
			local var_17_44 = arg_17_4 - var_17_33

			var_17_44 = var_17_44 >= 257 and 257 or var_17_44

			local var_17_45 = var_17_44 + var_17_35
			local var_17_46 = var_17_35 + 3

			while var_17_39 >= 1 and var_17_43 > 0 do
				local var_17_47 = var_17_40[var_17_39]

				if var_17_33 - var_17_47 > 32768 then
					break
				end

				if var_17_47 < var_17_33 then
					local var_17_48 = var_17_46

					if var_17_47 >= -257 then
						local var_17_49 = var_17_47 - var_17_36

						while var_17_48 <= var_17_45 and arg_17_1[var_17_49] == arg_17_1[var_17_48] do
							var_17_48 = var_17_48 + 1
							var_17_49 = var_17_49 + 1
						end
					else
						local var_17_50 = var_17_16 + var_17_47

						while var_17_48 <= var_17_45 and var_17_10[var_17_50] == arg_17_1[var_17_48] do
							var_17_48 = var_17_48 + 1
							var_17_50 = var_17_50 + 1
						end
					end

					local var_17_51 = var_17_48 - var_17_35

					if var_17_31 < var_17_51 then
						var_17_31 = var_17_51
						var_17_32 = var_17_33 - var_17_47
					end

					if var_17_4 <= var_17_31 then
						break
					end
				end

				var_17_39 = var_17_39 - 1
				var_17_43 = var_17_43 - 1

				if var_17_39 == 0 and var_17_47 > 0 and var_17_9 then
					var_17_40 = var_17_9[var_17_17]
					var_17_39 = var_17_40 and #var_17_40 or 0
				end
			end
		end

		if not var_17_1 then
			var_17_37, var_17_38 = var_17_31, var_17_32
		end

		if (not var_17_1 or var_17_28) and (var_17_37 > 3 or var_17_37 == 3 and var_17_38 < 4096) and var_17_31 <= var_17_37 then
			local var_17_52 = var_0_19[var_17_37]
			local var_17_53 = var_0_21[var_17_37]
			local var_17_54
			local var_17_55
			local var_17_56

			if var_17_38 <= 256 then
				var_17_54 = var_0_22[var_17_38]
				var_17_56 = var_0_23[var_17_38]
				var_17_55 = var_0_24[var_17_38]
			else
				var_17_54 = 16
				var_17_55 = 7

				local var_17_57 = 384
				local var_17_58 = 512

				while true do
					if var_17_38 <= var_17_57 then
						var_17_56 = (var_17_38 - var_17_58 / 2 - 1) % (var_17_58 / 4)

						break
					elseif var_17_38 <= var_17_58 then
						var_17_56 = (var_17_38 - var_17_58 / 2 - 1) % (var_17_58 / 4)
						var_17_54 = var_17_54 + 1

						break
					else
						var_17_54 = var_17_54 + 2
						var_17_55 = var_17_55 + 1
						var_17_57 = var_17_57 * 2
						var_17_58 = var_17_58 * 2
					end
				end
			end

			var_17_19 = var_17_19 + 1
			var_17_18[var_17_19] = var_17_52
			var_17_20[var_17_52] = (var_17_20[var_17_52] or 0) + 1
			var_17_22 = var_17_22 + 1
			var_17_21[var_17_22] = var_17_54
			var_17_23[var_17_54] = (var_17_23[var_17_54] or 0) + 1

			if var_17_53 > 0 then
				var_17_24[var_17_25], var_17_25 = var_0_20[var_17_37], var_17_25 + 1
			end

			if var_17_55 > 0 then
				var_17_27 = var_17_27 + 1
				var_17_26[var_17_27] = var_17_56
			end

			for iter_17_0 = var_17_33 + 1, var_17_33 + var_17_37 - (var_17_1 and 2 or 1) do
				var_17_17 = (var_17_17 * 256 + (arg_17_1[iter_17_0 - arg_17_5 + 2] or 0)) % 16777216

				if var_17_37 <= var_17_6 then
					local var_17_59 = arg_17_2[var_17_17]

					if not var_17_59 then
						var_17_59 = {}
						arg_17_2[var_17_17] = var_17_59
					end

					var_17_59[#var_17_59 + 1] = iter_17_0
				end
			end

			var_17_33 = var_17_33 + var_17_37 - (var_17_1 and 1 or 0)
			var_17_28 = false
		elseif not var_17_1 or var_17_28 then
			local var_17_60 = arg_17_1[var_17_1 and var_17_35 - 1 or var_17_35]

			var_17_19 = var_17_19 + 1
			var_17_18[var_17_19] = var_17_60
			var_17_20[var_17_60] = (var_17_20[var_17_60] or 0) + 1
			var_17_33 = var_17_33 + 1
		else
			var_17_28 = true
			var_17_33 = var_17_33 + 1
		end
	end

	var_17_18[var_17_19 + 1] = 256
	var_17_20[256] = (var_17_20[256] or 0) + 1

	return var_17_18, var_17_24, var_17_20, var_17_21, var_17_26, var_17_23
end

local function var_0_67(arg_18_0, arg_18_1)
	local var_18_0, var_18_1, var_18_2 = var_0_63(arg_18_0, 15, 285)
	local var_18_3, var_18_4, var_18_5 = var_0_63(arg_18_1, 15, 29)
	local var_18_6, var_18_7, var_18_8 = var_0_64(var_18_0, var_18_2, var_18_3, var_18_5)
	local var_18_9, var_18_10 = var_0_63(var_18_8, 7, 18)
	local var_18_11 = 0

	for iter_18_0 = 1, 19 do
		if (var_18_9[var_0_29[iter_18_0]] or 0) ~= 0 then
			var_18_11 = iter_18_0
		end
	end

	local var_18_12 = var_18_11 - 4
	local var_18_13 = var_18_2 + 1 - 257
	local var_18_14 = var_18_5 + 1 - 1

	if var_18_14 < 0 then
		var_18_14 = 0
	end

	return var_18_13, var_18_14, var_18_12, var_18_9, var_18_10, var_18_6, var_18_7, var_18_0, var_18_1, var_18_3, var_18_4
end

local function var_0_68(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0 = 17 + (arg_19_2 + 4) * 3

	for iter_19_0 = 1, #arg_19_4 do
		local var_19_1 = arg_19_4[iter_19_0]

		var_19_0 = var_19_0 + arg_19_3[var_19_1]

		if var_19_1 >= 16 then
			var_19_0 = var_19_0 + (var_19_1 == 16 and 2 or var_19_1 == 17 and 3 or 7)
		end
	end

	local var_19_2 = 0

	for iter_19_1 = 1, #arg_19_0 do
		local var_19_3 = arg_19_0[iter_19_1]

		var_19_0 = var_19_0 + arg_19_5[var_19_3]

		if var_19_3 > 256 then
			var_19_2 = var_19_2 + 1

			if var_19_3 > 264 and var_19_3 < 285 then
				var_19_0 = var_19_0 + var_0_26[var_19_3 - 256]
			end

			local var_19_4 = arg_19_1[var_19_2]

			var_19_0 = var_19_0 + arg_19_6[var_19_4]

			if var_19_4 > 3 then
				var_19_0 = var_19_0 + ((var_19_4 - var_19_4 % 2) / 2 - 1)
			end
		end
	end

	return var_19_0
end

local function var_0_69(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9, arg_20_10, arg_20_11, arg_20_12, arg_20_13, arg_20_14, arg_20_15, arg_20_16)
	arg_20_0(arg_20_1 and 1 or 0, 1)
	arg_20_0(2, 2)
	arg_20_0(arg_20_6, 5)
	arg_20_0(arg_20_7, 5)
	arg_20_0(arg_20_8, 4)

	for iter_20_0 = 1, arg_20_8 + 4 do
		local var_20_0 = arg_20_9[var_0_29[iter_20_0]] or 0

		arg_20_0(var_20_0, 3)
	end

	local var_20_1 = 1

	for iter_20_1 = 1, #arg_20_11 do
		local var_20_2 = arg_20_11[iter_20_1]

		arg_20_0(arg_20_10[var_20_2], arg_20_9[var_20_2])

		if var_20_2 >= 16 then
			local var_20_3 = arg_20_12[var_20_1]

			arg_20_0(var_20_3, var_20_2 == 16 and 2 or var_20_2 == 17 and 3 or 7)

			var_20_1 = var_20_1 + 1
		end
	end

	local var_20_4 = 0
	local var_20_5 = 0
	local var_20_6 = 0

	for iter_20_2 = 1, #arg_20_2 do
		local var_20_7 = arg_20_2[iter_20_2]
		local var_20_8 = arg_20_14[var_20_7]
		local var_20_9 = arg_20_13[var_20_7]

		arg_20_0(var_20_8, var_20_9)

		if var_20_7 > 256 then
			var_20_4 = var_20_4 + 1

			if var_20_7 > 264 and var_20_7 < 285 then
				var_20_5 = var_20_5 + 1

				local var_20_10 = arg_20_3[var_20_5]
				local var_20_11 = var_0_26[var_20_7 - 256]

				arg_20_0(var_20_10, var_20_11)
			end

			local var_20_12 = arg_20_4[var_20_4]
			local var_20_13 = arg_20_16[var_20_12]
			local var_20_14 = arg_20_15[var_20_12]

			arg_20_0(var_20_13, var_20_14)

			if var_20_12 > 3 then
				var_20_6 = var_20_6 + 1

				local var_20_15 = arg_20_5[var_20_6]
				local var_20_16 = (var_20_12 - var_20_12 % 2) / 2 - 1

				arg_20_0(var_20_15, var_20_16)
			end
		end
	end
end

local function var_0_70(arg_21_0, arg_21_1)
	local var_21_0 = 3
	local var_21_1 = 0

	for iter_21_0 = 1, #arg_21_0 do
		local var_21_2 = arg_21_0[iter_21_0]

		var_21_0 = var_21_0 + var_0_32[var_21_2]

		if var_21_2 > 256 then
			var_21_1 = var_21_1 + 1

			if var_21_2 > 264 and var_21_2 < 285 then
				var_21_0 = var_21_0 + var_0_26[var_21_2 - 256]
			end

			local var_21_3 = arg_21_1[var_21_1]

			var_21_0 = var_21_0 + 5

			if var_21_3 > 3 then
				var_21_0 = var_21_0 + ((var_21_3 - var_21_3 % 2) / 2 - 1)
			end
		end
	end

	return var_21_0
end

local function var_0_71(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	arg_22_0(arg_22_1 and 1 or 0, 1)
	arg_22_0(1, 2)

	local var_22_0 = 0
	local var_22_1 = 0
	local var_22_2 = 0

	for iter_22_0 = 1, #arg_22_2 do
		local var_22_3 = arg_22_2[iter_22_0]
		local var_22_4 = var_0_30[var_22_3]
		local var_22_5 = var_0_32[var_22_3]

		arg_22_0(var_22_4, var_22_5)

		if var_22_3 > 256 then
			var_22_0 = var_22_0 + 1

			if var_22_3 > 264 and var_22_3 < 285 then
				var_22_1 = var_22_1 + 1

				local var_22_6 = arg_22_3[var_22_1]
				local var_22_7 = var_0_26[var_22_3 - 256]

				arg_22_0(var_22_6, var_22_7)
			end

			local var_22_8 = arg_22_4[var_22_0]
			local var_22_9 = var_0_34[var_22_8]

			arg_22_0(var_22_9, 5)

			if var_22_8 > 3 then
				var_22_2 = var_22_2 + 1

				local var_22_10 = arg_22_5[var_22_2]
				local var_22_11 = (var_22_8 - var_22_8 % 2) / 2 - 1

				arg_22_0(var_22_10, var_22_11)
			end
		end
	end
end

local function var_0_72(arg_23_0, arg_23_1, arg_23_2)
	var_0_6(arg_23_1 - arg_23_0 + 1 <= 65535)

	local var_23_0 = 3

	arg_23_2 = arg_23_2 + 3

	return var_23_0 + (8 - arg_23_2 % 8) % 8 + 32 + (arg_23_1 - arg_23_0 + 1) * 8
end

local function var_0_73(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	var_0_6(arg_24_5 - arg_24_4 + 1 <= 65535)
	arg_24_0(arg_24_2 and 1 or 0, 1)
	arg_24_0(0, 2)

	arg_24_6 = arg_24_6 + 3

	local var_24_0 = (8 - arg_24_6 % 8) % 8

	if var_24_0 > 0 then
		arg_24_0(var_0_16[var_24_0] - 1, var_24_0)
	end

	local var_24_1 = arg_24_5 - arg_24_4 + 1

	arg_24_0(var_24_1, 16)

	local var_24_2 = 255 - var_24_1 % 256 + (255 - (var_24_1 - var_24_1 % 256) / 256) * 256

	arg_24_0(var_24_2, 16)
	arg_24_1(arg_24_3:sub(arg_24_4, arg_24_5))
end

local function var_0_74(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = {}
	local var_25_1 = {}
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5
	local var_25_6 = arg_25_3(var_0_57)
	local var_25_7 = #arg_25_4
	local var_25_8
	local var_25_9
	local var_25_10

	if arg_25_0 then
		if arg_25_0.level then
			var_25_9 = arg_25_0.level
		end

		if arg_25_0.strategy then
			var_25_10 = arg_25_0.strategy
		end
	end

	var_25_9 = var_25_9 or var_25_7 < 2048 and 7 or var_25_7 > 65536 and 3 or 5

	while not var_25_2 do
		local var_25_11

		if not var_25_3 then
			var_25_3 = 1
			var_25_4 = 65535
			var_25_11 = 0
		else
			var_25_3 = var_25_4 + 1
			var_25_4 = var_25_4 + 32768
			var_25_11 = var_25_3 - 32768 - 1
		end

		if var_25_7 <= var_25_4 then
			var_25_4 = var_25_7
			var_25_2 = true
		else
			var_25_2 = false
		end

		local var_25_12
		local var_25_13
		local var_25_14
		local var_25_15
		local var_25_16
		local var_25_17
		local var_25_18
		local var_25_19
		local var_25_20
		local var_25_21
		local var_25_22
		local var_25_23
		local var_25_24
		local var_25_25
		local var_25_26
		local var_25_27
		local var_25_28
		local var_25_29
		local var_25_30
		local var_25_31

		if var_25_9 ~= 0 then
			var_0_65(arg_25_4, var_25_0, var_25_3, var_25_4 + 3, var_25_11)

			if var_25_3 == 1 and arg_25_5 then
				local var_25_32 = arg_25_5.string_table
				local var_25_33 = arg_25_5.strlen

				for iter_25_0 = 0, -var_25_33 + 1 < -257 and -257 or -var_25_33 + 1, -1 do
					var_25_0[iter_25_0] = var_25_32[var_25_33 + iter_25_0]
				end
			end

			if var_25_10 == "huffman_only" then
				var_25_12 = {}

				var_0_65(arg_25_4, var_25_12, var_25_3, var_25_4, var_25_3 - 1)

				var_25_13 = {}
				var_25_14 = {}
				var_25_12[var_25_4 - var_25_3 + 2] = 256

				for iter_25_1 = 1, var_25_4 - var_25_3 + 2 do
					local var_25_34 = var_25_12[iter_25_1]

					var_25_14[var_25_34] = (var_25_14[var_25_34] or 0) + 1
				end

				var_25_15 = {}
				var_25_16 = {}
				var_25_17 = {}
			else
				var_25_12, var_25_13, var_25_14, var_25_15, var_25_16, var_25_17 = var_0_66(var_25_9, var_25_0, var_25_1, var_25_3, var_25_4, var_25_11, arg_25_5)
			end

			var_25_18, var_25_19, var_25_20, var_25_21, var_25_22, var_25_23, var_25_24, var_25_25, var_25_26, var_25_27, var_25_28 = var_0_67(var_25_14, var_25_17)
			var_25_29 = var_0_68(var_25_12, var_25_15, var_25_20, var_25_21, var_25_23, var_25_25, var_25_27)
			var_25_30 = var_0_70(var_25_12, var_25_15)
		end

		local var_25_35 = var_0_72(var_25_3, var_25_4, var_25_6)
		local var_25_36 = var_25_35

		var_25_36 = var_25_30 and var_25_30 < var_25_36 and var_25_30 or var_25_36
		var_25_36 = var_25_29 and var_25_29 < var_25_36 and var_25_29 or var_25_36

		if var_25_9 == 0 or var_25_10 ~= "fixed" and var_25_10 ~= "dynamic" and var_25_35 == var_25_36 then
			var_0_73(arg_25_1, arg_25_2, var_25_2, arg_25_4, var_25_3, var_25_4, var_25_6)

			var_25_6 = var_25_6 + var_25_35
		elseif var_25_10 ~= "dynamic" and (var_25_10 == "fixed" or var_25_30 == var_25_36) then
			var_0_71(arg_25_1, var_25_2, var_25_12, var_25_13, var_25_15, var_25_16)

			var_25_6 = var_25_6 + var_25_30
		elseif var_25_10 == "dynamic" or var_25_29 == var_25_36 then
			var_0_69(arg_25_1, var_25_2, var_25_12, var_25_13, var_25_15, var_25_16, var_25_18, var_25_19, var_25_20, var_25_21, var_25_22, var_25_23, var_25_24, var_25_25, var_25_26, var_25_27, var_25_28)

			var_25_6 = var_25_6 + var_25_29
		end

		if var_25_2 then
			var_25_5 = arg_25_3(var_0_57)
		else
			var_25_5 = arg_25_3(var_0_54)
		end

		var_0_6(var_25_5 == var_25_6)

		if not var_25_2 then
			local var_25_37

			if arg_25_5 and var_25_3 == 1 then
				local var_25_38 = 0

				while var_25_0[var_25_38] do
					var_25_0[var_25_38] = nil
					var_25_38 = var_25_38 - 1
				end
			end

			arg_25_5 = nil

			local var_25_39 = 1

			for iter_25_2 = var_25_4 - 32767, var_25_4 do
				var_25_0[var_25_39] = var_25_0[iter_25_2 - var_25_11]
				var_25_39 = var_25_39 + 1
			end

			for iter_25_3, iter_25_4 in var_0_8(var_25_1) do
				local var_25_40 = #iter_25_4

				if var_25_40 > 0 and var_25_4 + 1 - iter_25_4[1] > 32768 then
					if var_25_40 == 1 then
						var_25_1[iter_25_3] = nil
					else
						local var_25_41 = {}
						local var_25_42 = 0

						for iter_25_5 = 2, var_25_40 do
							local var_25_43 = iter_25_4[iter_25_5]

							if var_25_4 + 1 - var_25_43 <= 32768 then
								var_25_42 = var_25_42 + 1
								var_25_41[var_25_42] = var_25_43
							end
						end

						var_25_1[iter_25_3] = var_25_41
					end
				end
			end
		end
	end
end

local function var_0_75(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0, var_26_1, var_26_2 = var_0_58()

	var_0_74(arg_26_2, var_26_0, var_26_1, var_26_2, arg_26_0, arg_26_1)

	local var_26_3, var_26_4 = var_26_2(var_0_55)
	local var_26_5 = (8 - var_26_3 % 8) % 8

	return var_26_4, var_26_5
end

local function var_0_76(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0, var_27_1, var_27_2 = var_0_58()
	local var_27_3 = 8
	local var_27_4 = 7
	local var_27_5 = var_27_4 * 16 + var_27_3

	var_27_0(var_27_5, 8)

	local var_27_6 = arg_27_1 and 1 or 0
	local var_27_7 = 2
	local var_27_8 = var_27_7 * 64 + var_27_6 * 32
	local var_27_9 = var_27_8 + (31 - (var_27_5 * 256 + var_27_8) % 31)

	var_27_0(var_27_9, 8)

	if var_27_6 == 1 then
		local var_27_10 = arg_27_1.adler32
		local var_27_11 = var_27_10 % 256
		local var_27_12 = (var_27_10 - var_27_11) / 256
		local var_27_13 = var_27_12 % 256
		local var_27_14 = (var_27_12 - var_27_13) / 256
		local var_27_15 = var_27_14 % 256
		local var_27_16 = (var_27_14 - var_27_15) / 256 % 256

		var_27_0(var_27_16, 8)
		var_27_0(var_27_15, 8)
		var_27_0(var_27_13, 8)
		var_27_0(var_27_11, 8)
	end

	var_0_74(arg_27_2, var_27_0, var_27_1, var_27_2, arg_27_0, arg_27_1)
	var_27_2(var_0_56)

	local var_27_17 = var_0_5:Adler32(arg_27_0)
	local var_27_18 = var_27_17 % 256
	local var_27_19 = (var_27_17 - var_27_18) / 256
	local var_27_20 = var_27_19 % 256
	local var_27_21 = (var_27_19 - var_27_20) / 256
	local var_27_22 = var_27_21 % 256
	local var_27_23 = (var_27_21 - var_27_22) / 256 % 256

	var_27_0(var_27_23, 8)
	var_27_0(var_27_22, 8)
	var_27_0(var_27_20, 8)
	var_27_0(var_27_18, 8)

	local var_27_24, var_27_25 = var_27_2(var_0_55)
	local var_27_26 = (8 - var_27_24 % 8) % 8

	return var_27_25, var_27_26
end

var_0_5.CompressDeflate = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0, var_28_1 = var_0_53(arg_28_1, false, nil, true, arg_28_2)

	if not var_28_0 then
		var_0_7("Usage: LibDeflate:CompressDeflate(str, configs): " .. var_28_1, 2)
	end

	return var_0_75(arg_28_1, nil, arg_28_2)
end

var_0_5.CompressDeflateWithDict = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0, var_29_1 = var_0_53(arg_29_1, true, arg_29_2, true, arg_29_3)

	if not var_29_0 then
		var_0_7("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. var_29_1, 2)
	end

	return var_0_75(arg_29_1, arg_29_2, arg_29_3)
end

var_0_5.CompressZlib = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0, var_30_1 = var_0_53(arg_30_1, false, nil, true, arg_30_2)

	if not var_30_0 then
		var_0_7("Usage: LibDeflate:CompressZlib(str, configs): " .. var_30_1, 2)
	end

	return var_0_76(arg_30_1, nil, arg_30_2)
end

var_0_5.CompressZlibWithDict = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0, var_31_1 = var_0_53(arg_31_1, true, arg_31_2, true, arg_31_3)

	if not var_31_0 then
		var_0_7("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. var_31_1, 2)
	end

	return var_0_76(arg_31_1, arg_31_2, arg_31_3)
end

local function var_0_77(arg_32_0)
	local var_32_0 = arg_32_0
	local var_32_1 = #arg_32_0
	local var_32_2 = 1
	local var_32_3 = 0
	local var_32_4 = 0

	local function var_32_5(arg_33_0)
		local var_33_0 = var_0_16[arg_33_0]
		local var_33_1

		if arg_33_0 <= var_32_3 then
			var_33_1 = var_32_4 % var_33_0
			var_32_4 = (var_32_4 - var_33_1) / var_33_0
			var_32_3 = var_32_3 - arg_33_0
		else
			local var_33_2 = var_0_16[var_32_3]
			local var_33_3, var_33_4, var_33_5, var_33_6 = var_0_9(var_32_0, var_32_2, var_32_2 + 3)

			var_32_4 = var_32_4 + ((var_33_3 or 0) + (var_33_4 or 0) * 256 + (var_33_5 or 0) * 65536 + (var_33_6 or 0) * 16777216) * var_33_2
			var_32_2 = var_32_2 + 4
			var_32_3 = var_32_3 + 32 - arg_33_0
			var_33_1 = var_32_4 % var_33_0
			var_32_4 = (var_32_4 - var_33_1) / var_33_0
		end

		return var_33_1
	end

	local function var_32_6(arg_34_0, arg_34_1, arg_34_2)
		var_0_6(var_32_3 % 8 == 0)

		local var_34_0 = arg_34_0 > var_32_3 / 8 and var_32_3 / 8 or arg_34_0

		for iter_34_0 = 1, var_34_0 do
			local var_34_1 = var_32_4 % 256

			arg_34_2 = arg_34_2 + 1
			arg_34_1[arg_34_2] = var_0_10(var_34_1)
			var_32_4 = (var_32_4 - var_34_1) / 256
		end

		var_32_3 = var_32_3 - var_34_0 * 8
		arg_34_0 = arg_34_0 - var_34_0

		if (var_32_1 - var_32_2 - arg_34_0 + 1) * 8 + var_32_3 < 0 then
			return -1
		end

		for iter_34_1 = var_32_2, var_32_2 + arg_34_0 - 1 do
			arg_34_2 = arg_34_2 + 1
			arg_34_1[arg_34_2] = var_0_11(var_32_0, iter_34_1, iter_34_1)
		end

		var_32_2 = var_32_2 + arg_34_0

		return arg_34_2
	end

	local function var_32_7(arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = 0
		local var_35_1 = 0
		local var_35_2 = 0
		local var_35_3

		if arg_35_2 > 0 then
			if var_32_3 < 15 and var_32_0 then
				local var_35_4 = var_0_16[var_32_3]
				local var_35_5, var_35_6, var_35_7, var_35_8 = var_0_9(var_32_0, var_32_2, var_32_2 + 3)

				var_32_4 = var_32_4 + ((var_35_5 or 0) + (var_35_6 or 0) * 256 + (var_35_7 or 0) * 65536 + (var_35_8 or 0) * 16777216) * var_35_4
				var_32_2 = var_32_2 + 4
				var_32_3 = var_32_3 + 32
			end

			local var_35_9 = var_0_16[arg_35_2]

			var_32_3 = var_32_3 - arg_35_2
			var_35_0 = var_32_4 % var_35_9
			var_32_4 = (var_32_4 - var_35_0) / var_35_9
			var_35_0 = var_0_18[arg_35_2][var_35_0]

			local var_35_10 = arg_35_0[arg_35_2]

			if var_35_0 < var_35_10 then
				return arg_35_1[var_35_0]
			end

			var_35_2 = var_35_10
			var_35_1 = var_35_10 * 2
			var_35_0 = var_35_0 * 2
		end

		for iter_35_0 = arg_35_2 + 1, 15 do
			local var_35_11
			local var_35_12 = var_32_4 % 2

			var_32_4 = (var_32_4 - var_35_12) / 2
			var_32_3 = var_32_3 - 1
			var_35_0 = var_35_12 == 1 and var_35_0 + 1 - var_35_0 % 2 or var_35_0

			local var_35_13 = arg_35_0[iter_35_0] or 0
			local var_35_14 = var_35_0 - var_35_1

			if var_35_14 < var_35_13 then
				return arg_35_1[var_35_2 + var_35_14]
			end

			var_35_2 = var_35_2 + var_35_13
			var_35_1 = var_35_1 + var_35_13
			var_35_1 = var_35_1 * 2
			var_35_0 = var_35_0 * 2
		end

		return -10
	end

	local function var_32_8()
		return (var_32_1 - var_32_2 + 1) * 8 + var_32_3
	end

	local function var_32_9()
		local var_37_0 = var_32_3 % 8
		local var_37_1 = var_0_16[var_37_0]

		var_32_3 = var_32_3 - var_37_0
		var_32_4 = (var_32_4 - var_32_4 % var_37_1) / var_37_1
	end

	return var_32_5, var_32_6, var_32_7, var_32_8, var_32_9
end

local function var_0_78(arg_38_0, arg_38_1)
	local var_38_0, var_38_1, var_38_2, var_38_3, var_38_4 = var_0_77(arg_38_0)

	return {
		buffer_size = 0,
		ReadBits = var_38_0,
		ReadBytes = var_38_1,
		Decode = var_38_2,
		ReaderBitlenLeft = var_38_3,
		SkipToByteBoundary = var_38_4,
		buffer = {},
		result_buffer = {},
		dictionary = arg_38_1
	}
end

local function var_0_79(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = {}
	local var_39_1 = arg_39_2

	for iter_39_0 = 0, arg_39_1 do
		local var_39_2 = arg_39_0[iter_39_0] or 0

		var_39_1 = var_39_2 > 0 and var_39_2 < var_39_1 and var_39_2 or var_39_1
		var_39_0[var_39_2] = (var_39_0[var_39_2] or 0) + 1
	end

	if var_39_0[0] == arg_39_1 + 1 then
		return 0, var_39_0, {}, 0
	end

	local var_39_3 = 1

	for iter_39_1 = 1, arg_39_2 do
		var_39_3 = var_39_3 * 2
		var_39_3 = var_39_3 - (var_39_0[iter_39_1] or 0)

		if var_39_3 < 0 then
			return var_39_3
		end
	end

	local var_39_4 = {}

	var_39_4[1] = 0

	for iter_39_2 = 1, arg_39_2 - 1 do
		var_39_4[iter_39_2 + 1] = var_39_4[iter_39_2] + (var_39_0[iter_39_2] or 0)
	end

	local var_39_5 = {}

	for iter_39_3 = 0, arg_39_1 do
		local var_39_6 = arg_39_0[iter_39_3] or 0

		if var_39_6 ~= 0 then
			var_39_5[var_39_4[var_39_6]] = iter_39_3
			var_39_4[var_39_6] = var_39_4[var_39_6] + 1
		end
	end

	return var_39_3, var_39_0, var_39_5, var_39_1
end

local function var_0_80(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	local var_40_0 = arg_40_0.buffer
	local var_40_1 = arg_40_0.buffer_size
	local var_40_2 = arg_40_0.ReadBits
	local var_40_3 = arg_40_0.Decode
	local var_40_4 = arg_40_0.ReaderBitlenLeft
	local var_40_5 = arg_40_0.result_buffer
	local var_40_6 = arg_40_0.dictionary
	local var_40_7
	local var_40_8
	local var_40_9 = 1

	if var_40_6 and not var_40_0[0] then
		var_40_7 = var_40_6.string_table
		var_40_8 = var_40_6.strlen
		var_40_9 = -var_40_8 + 1

		for iter_40_0 = 0, -var_40_8 + 1 < -257 and -257 or -var_40_8 + 1, -1 do
			var_40_0[iter_40_0] = var_0_17[var_40_7[var_40_8 + iter_40_0]]
		end
	end

	repeat
		local var_40_10 = var_40_3(arg_40_1, arg_40_2, arg_40_3)

		if var_40_10 < 0 or var_40_10 > 285 then
			return -10
		elseif var_40_10 < 256 then
			var_40_1 = var_40_1 + 1
			var_40_0[var_40_1] = var_0_17[var_40_10]
		elseif var_40_10 > 256 then
			var_40_10 = var_40_10 - 256

			local var_40_11 = var_0_25[var_40_10]

			var_40_11 = var_40_10 >= 8 and var_40_11 + var_40_2(var_0_26[var_40_10]) or var_40_11
			var_40_10 = var_40_3(arg_40_4, arg_40_5, arg_40_6)

			if var_40_10 < 0 or var_40_10 > 29 then
				return -10
			end

			local var_40_12 = var_0_27[var_40_10]

			var_40_12 = var_40_12 > 4 and var_40_12 + var_40_2(var_0_28[var_40_10]) or var_40_12

			local var_40_13 = var_40_1 - var_40_12 + 1

			if var_40_13 < var_40_9 then
				return -11
			end

			if var_40_13 >= -257 then
				for iter_40_1 = 1, var_40_11 do
					var_40_1 = var_40_1 + 1
					var_40_0[var_40_1] = var_40_0[var_40_13]
					var_40_13 = var_40_13 + 1
				end
			else
				local var_40_14 = var_40_8 + var_40_13

				for iter_40_2 = 1, var_40_11 do
					var_40_1 = var_40_1 + 1
					var_40_0[var_40_1] = var_0_17[var_40_7[var_40_14]]
					var_40_14 = var_40_14 + 1
				end
			end
		end

		if var_40_4() < 0 then
			return 2
		end

		if var_40_1 >= 65536 then
			var_40_5[#var_40_5 + 1] = var_0_12(var_40_0, "", 1, 32768)

			for iter_40_3 = 32769, var_40_1 do
				var_40_0[iter_40_3 - 32768] = var_40_0[iter_40_3]
			end

			var_40_1 = var_40_1 - 32768
			var_40_0[var_40_1 + 1] = nil
		end
	until var_40_10 == 256

	arg_40_0.buffer_size = var_40_1

	return 0
end

local function var_0_81(arg_41_0)
	local var_41_0 = arg_41_0.buffer
	local var_41_1 = arg_41_0.buffer_size
	local var_41_2 = arg_41_0.ReadBits
	local var_41_3 = arg_41_0.ReadBytes
	local var_41_4 = arg_41_0.ReaderBitlenLeft
	local var_41_5 = arg_41_0.SkipToByteBoundary
	local var_41_6 = arg_41_0.result_buffer

	var_41_5()

	local var_41_7 = var_41_2(16)

	if var_41_4() < 0 then
		return 2
	end

	local var_41_8 = var_41_2(16)

	if var_41_4() < 0 then
		return 2
	end

	if var_41_7 % 256 + var_41_8 % 256 ~= 255 then
		return -2
	end

	if (var_41_7 - var_41_7 % 256) / 256 + (var_41_8 - var_41_8 % 256) / 256 ~= 255 then
		return -2
	end

	local var_41_9 = var_41_3(var_41_7, var_41_0, var_41_1)

	if var_41_9 < 0 then
		return 2
	end

	if var_41_9 >= 65536 then
		var_41_6[#var_41_6 + 1] = var_0_12(var_41_0, "", 1, 32768)

		for iter_41_0 = 32769, var_41_9 do
			var_41_0[iter_41_0 - 32768] = var_41_0[iter_41_0]
		end

		var_41_9 = var_41_9 - 32768
		var_41_0[var_41_9 + 1] = nil
	end

	arg_41_0.buffer_size = var_41_9

	return 0
end

local function var_0_82(arg_42_0)
	return var_0_80(arg_42_0, var_0_33, var_0_31, 7, var_0_37, var_0_35, 5)
end

local function var_0_83(arg_43_0)
	local var_43_0 = arg_43_0.ReadBits
	local var_43_1 = arg_43_0.Decode
	local var_43_2 = var_43_0(5) + 257
	local var_43_3 = var_43_0(5) + 1
	local var_43_4 = var_43_0(4) + 4

	if var_43_2 > 286 or var_43_3 > 30 then
		return -3
	end

	local var_43_5 = {}

	for iter_43_0 = 1, var_43_4 do
		var_43_5[var_0_29[iter_43_0]] = var_43_0(3)
	end

	local var_43_6, var_43_7, var_43_8, var_43_9 = var_0_79(var_43_5, 18, 7)

	if var_43_6 ~= 0 then
		return -4
	end

	local var_43_10 = {}
	local var_43_11 = {}
	local var_43_12 = 0

	while var_43_12 < var_43_2 + var_43_3 do
		local var_43_13
		local var_43_14
		local var_43_15 = var_43_1(var_43_7, var_43_8, var_43_9)

		if var_43_15 < 0 then
			return var_43_15
		elseif var_43_15 < 16 then
			if var_43_12 < var_43_2 then
				var_43_10[var_43_12] = var_43_15
			else
				var_43_11[var_43_12 - var_43_2] = var_43_15
			end

			var_43_12 = var_43_12 + 1
		else
			local var_43_16 = 0

			if var_43_15 == 16 then
				if var_43_12 == 0 then
					return -5
				end

				if var_43_2 > var_43_12 - 1 then
					var_43_16 = var_43_10[var_43_12 - 1]
				else
					var_43_16 = var_43_11[var_43_12 - var_43_2 - 1]
				end

				var_43_15 = 3 + var_43_0(2)
			elseif var_43_15 == 17 then
				var_43_15 = 3 + var_43_0(3)
			else
				var_43_15 = 11 + var_43_0(7)
			end

			if var_43_12 + var_43_15 > var_43_2 + var_43_3 then
				return -6
			end

			while var_43_15 > 0 do
				var_43_15 = var_43_15 - 1

				if var_43_12 < var_43_2 then
					var_43_10[var_43_12] = var_43_16
				else
					var_43_11[var_43_12 - var_43_2] = var_43_16
				end

				var_43_12 = var_43_12 + 1
			end
		end
	end

	if (var_43_10[256] or 0) == 0 then
		return -9
	end

	local var_43_17, var_43_18, var_43_19, var_43_20 = var_0_79(var_43_10, var_43_2 - 1, 15)

	if var_43_17 ~= 0 and (var_43_17 < 0 or var_43_2 ~= (var_43_18[0] or 0) + (var_43_18[1] or 0)) then
		return -7
	end

	local var_43_21, var_43_22, var_43_23, var_43_24 = var_0_79(var_43_11, var_43_3 - 1, 15)

	if var_43_21 ~= 0 and (var_43_21 < 0 or var_43_3 ~= (var_43_22[0] or 0) + (var_43_22[1] or 0)) then
		return -8
	end

	return var_0_80(arg_43_0, var_43_18, var_43_19, var_43_20, var_43_22, var_43_23, var_43_24)
end

local function var_0_84(arg_44_0)
	local var_44_0 = arg_44_0.ReadBits
	local var_44_1

	while not var_44_1 do
		var_44_1 = var_44_0(1) == 1

		local var_44_2 = var_44_0(2)
		local var_44_3

		if var_44_2 == 0 then
			var_44_3 = var_0_81(arg_44_0)
		elseif var_44_2 == 1 then
			var_44_3 = var_0_82(arg_44_0)
		elseif var_44_2 == 2 then
			var_44_3 = var_0_83(arg_44_0)
		else
			return nil, -1
		end

		if var_44_3 ~= 0 then
			return nil, var_44_3
		end
	end

	arg_44_0.result_buffer[#arg_44_0.result_buffer + 1] = var_0_12(arg_44_0.buffer, "", 1, arg_44_0.buffer_size)

	return (var_0_12(arg_44_0.result_buffer))
end

local function var_0_85(arg_45_0, arg_45_1)
	local var_45_0 = var_0_78(arg_45_0, arg_45_1)
	local var_45_1, var_45_2 = var_0_84(var_45_0)

	if not var_45_1 then
		return nil, var_45_2
	end

	local var_45_3 = var_45_0.ReaderBitlenLeft()
	local var_45_4 = (var_45_3 - var_45_3 % 8) / 8

	return var_45_1, var_45_4
end

var_0_5.DecompressDeflate = function (arg_46_0, arg_46_1)
	local var_46_0, var_46_1 = var_0_53(arg_46_1)

	if not var_46_0 then
		var_0_7("Usage: LibDeflate:DecompressDeflate(str): " .. var_46_1, 2)
	end

	return var_0_85(arg_46_1)
end

var_0_32 = {}

for iter_0_7 = 0, 143 do
	var_0_32[iter_0_7] = 8
end

for iter_0_8 = 144, 255 do
	var_0_32[iter_0_8] = 9
end

for iter_0_9 = 256, 279 do
	var_0_32[iter_0_9] = 7
end

for iter_0_10 = 280, 287 do
	var_0_32[iter_0_10] = 8
end

local var_0_86 = {}

for iter_0_11 = 0, 31 do
	var_0_86[iter_0_11] = 5
end

local var_0_87
local var_0_88

var_0_88, var_0_33, var_0_31 = var_0_79(var_0_32, 287, 9)

var_0_6(var_0_88 == 0)

local var_0_89

var_0_89, var_0_37, var_0_35 = var_0_79(var_0_86, 31, 5)

var_0_6(var_0_89 == 0)

var_0_30 = var_0_61(var_0_33, var_0_32, 287, 9)
var_0_34 = var_0_61(var_0_37, var_0_86, 31, 5)

return var_0_5
