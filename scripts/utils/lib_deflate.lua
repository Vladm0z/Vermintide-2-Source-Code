-- chunkname: @scripts/utils/lib_deflate.lua

local var_0_0
local str = "1.0.2-release"
local str_2 = "LibDeflate"
local num = 3
local str_3 = "LibDeflate " .. str .. " Copyright (C) 2018-2020 Haoqian He." .. " Licensed under the zlib License"
local tbl = {
	_VERSION = str,
	_MAJOR = str_2,
	_MINOR = num,
	_COPYRIGHT = str_3
}
local assert = assert
local error = error
local pairs = pairs
local byte = string.byte
local char = string.char
local sub = string.sub
local concat = table.concat
local sort = table.sort
local tostring = tostring
local type = type
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}
local tbl_7 = {}
local tbl_8 = {}
local tbl_9 = {}
local tbl_10 = {}
local tbl_11 = {
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
local tbl_12 = {
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
local tbl_13 = {
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
local tbl_14 = {
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
local tbl_15 = {
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

for i = 0, 255 do
	tbl_3[i] = char(i)
end

local num_2 = 1

for j = 0, 32 do
	tbl_2[j] = num_2
	num_2 = num_2 * 2
end

for k = 1, 9 do
	tbl_4[k] = {}

	for l = 0, tbl_2[k + 1] - 1 do
		local num_3 = 0
		local var_0_40 = l

		for i4 = 1, k do
			local num_4 = num_3 - num_3 % 2
			local flag

			flag = num_3 % 2 == 1 or var_0_40 % 2 == 1 or 1 or 0
			num_3 = num_4 + flag
			var_0_40 = (var_0_40 - var_0_40 % 2) / 2
			num_3 = num_3 * 2
		end

		tbl_4[k][l] = (num_3 - num_3 % 2) / 2
	end
end

local num_5 = 18
local num_6 = 16
local num_7 = 265
local num_8 = 1

for i5 = 3, 258 do
	if i5 <= 10 then
		tbl_5[i5] = i5 + 254
		tbl_7[i5] = 0
	elseif i5 == 258 then
		tbl_5[i5] = 285
		tbl_7[i5] = 0
	else
		if num_5 < i5 then
			num_5 = num_5 + num_6
			num_6 = num_6 * 2
			num_7 = num_7 + 4
			num_8 = num_8 + 1
		end

		local num_9 = i5 - num_5 - 1 + num_6 / 2

		tbl_5[i5] = (num_9 - num_9 % (num_6 / 8)) / (num_6 / 8) + num_7
		tbl_7[i5] = num_8
		tbl_6[i5] = num_9 % (num_6 / 8)
	end
end

tbl_8[1] = 0
tbl_8[2] = 1
tbl_10[1] = 0
tbl_10[2] = 0

local num_10 = 3
local num_11 = 4
local num_12 = 2
local num_13 = 0

for i6 = 3, 256 do
	if num_11 < i6 then
		num_10 = num_10 * 2
		num_11 = num_11 * 2
		num_12 = num_12 + 2
		num_13 = num_13 + 1
	end

	tbl_8[i6] = not (i6 <= num_10) or not num_12 or num_12 + 1

	local flag_2

	flag_2 = not (num_13 < 0) or not 0 or num_13
	tbl_10[i6] = flag_2

	if num_11 >= 8 then
		tbl_9[i6] = (i6 - num_11 / 2 - 1) % (num_11 / 4)
	end
end

tbl.Adler32 = function (arg_1_0, arg_1_1)
	-- function 1
	if type(arg_1_1) ~= "string" then
		error(("Usage: LibDeflate:Adler32(str):" .. " 'str' - string expected got '%s'."):format(type(arg_1_1)), 2)
	end

	local count = #arg_1_1
	local num = 1
	local num_2 = 1
	local num_3 = 0

	while num <= count - 15 do
		local var_1_4, var_1_5, var_1_6, var_1_7, var_1_8, var_1_9, var_1_10, var_1_11, var_1_12, var_1_13, var_1_14, var_1_15, var_1_16, var_1_17, var_1_18, var_1_19 = byte(arg_1_1, num, num + 15)

		num_3 = (num_3 + 16 * num_2 + 16 * var_1_4 + 15 * var_1_5 + 14 * var_1_6 + 13 * var_1_7 + 12 * var_1_8 + 11 * var_1_9 + 10 * var_1_10 + 9 * var_1_11 + 8 * var_1_12 + 7 * var_1_13 + 6 * var_1_14 + 5 * var_1_15 + 4 * var_1_16 + 3 * var_1_17 + 2 * var_1_18 + var_1_19) % 65521
		num_2 = (num_2 + var_1_4 + var_1_5 + var_1_6 + var_1_7 + var_1_8 + var_1_9 + var_1_10 + var_1_11 + var_1_12 + var_1_13 + var_1_14 + var_1_15 + var_1_16 + var_1_17 + var_1_18 + var_1_19) % 65521
		num = num + 16
	end

	while num <= count do
		num_2 = (num_2 + byte(arg_1_1, num, num)) % 65521
		num_3 = (num_3 + num_2) % 65521
		num = num + 1
	end

	return (num_3 * 65536 + num_2) % 4294967296
end

local function fn(arg_2_0, arg_2_1)
	-- function 2
	return arg_2_0 % 4294967296 == arg_2_1 % 4294967296
end

tbl.CreateDictionary = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if type(arg_3_1) ~= "string" then
		error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'str' - string expected got '%s'."):format(type(arg_3_1)), 2)
	end

	if type(arg_3_2) ~= "number" then
		error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'strlen' - number expected got '%s'."):format(type(arg_3_2)), 2)
	end

	if type(arg_3_3) ~= "number" then
		error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'adler32' - number expected got '%s'."):format(type(arg_3_3)), 2)
	end

	if arg_3_2 ~= #arg_3_1 then
		error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'strlen' does not match the actual length of 'str'." .. " 'strlen': %u, '#str': %u ." .. " Please check if 'str' is modified unintentionally."):format(arg_3_2, #arg_3_1))
	end

	if arg_3_2 == 0 then
		error("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'str' - Empty string is not allowed.", 2)
	end

	if arg_3_2 > 32768 then
		error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'str' - string longer than 32768 bytes is not allowed." .. " Got %d bytes."):format(arg_3_2), 2)
	end

	local Adler32 = self:Adler32(arg_3_1)

	if not fn(arg_3_3, Adler32) then
		error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32):" .. " 'adler32' does not match the actual adler32 of 'str'." .. " 'adler32': %u, 'Adler32(str)': %u ." .. " Please check if 'str' is modified unintentionally."):format(arg_3_3, Adler32))
	end

	local tbl = {
		adler32 = arg_3_3,
		hash_tables = {},
		string_table = {},
		strlen = arg_3_2
	}
	local string_table = tbl.string_table
	local hash_tables = tbl.hash_tables

	string_table[1] = byte(arg_3_1, 1, 1)
	string_table[2] = byte(arg_3_1, 2, 2)

	if arg_3_2 >= 3 then
		local num = 1
		local num_2 = string_table[1] * 256 + string_table[2]

		while num <= arg_3_2 - 2 - 3 do
			local var_3_6, var_3_7, var_3_8, var_3_9 = byte(arg_3_1, num + 2, num + 5)

			string_table[num + 2] = var_3_6
			string_table[num + 3] = var_3_7
			string_table[num + 4] = var_3_8
			string_table[num + 5] = var_3_9
			num_2 = (num_2 * 256 + var_3_6) % 16777216

			local var_3_10 = hash_tables[num_2]

			if not var_3_10 then
				var_3_10 = {}
				hash_tables[num_2] = var_3_10
			end

			var_3_10[#var_3_10 + 1] = num - arg_3_2
			num = num + 1
			num_2 = (num_2 * 256 + var_3_7) % 16777216

			local var_3_11 = hash_tables[num_2]

			if not var_3_11 then
				var_3_11 = {}
				hash_tables[num_2] = var_3_11
			end

			var_3_11[#var_3_11 + 1] = num - arg_3_2
			num = num + 1
			num_2 = (num_2 * 256 + var_3_8) % 16777216

			local var_3_12 = hash_tables[num_2]

			if not var_3_12 then
				var_3_12 = {}
				hash_tables[num_2] = var_3_12
			end

			var_3_12[#var_3_12 + 1] = num - arg_3_2
			num = num + 1
			num_2 = (num_2 * 256 + var_3_9) % 16777216

			local var_3_13 = hash_tables[num_2]

			if not var_3_13 then
				var_3_13 = {}
				hash_tables[num_2] = var_3_13
			end

			var_3_13[#var_3_13 + 1] = num - arg_3_2
			num = num + 1
		end

		while num <= arg_3_2 - 2 do
			local var_3_14 = byte(arg_3_1, num + 2)

			string_table[num + 2] = var_3_14
			num_2 = (num_2 * 256 + var_3_14) % 16777216

			local var_3_15 = hash_tables[num_2]

			if not var_3_15 then
				var_3_15 = {}
				hash_tables[num_2] = var_3_15
			end

			var_3_15[#var_3_15 + 1] = num - arg_3_2
			num = num + 1
		end
	end

	return tbl
end

local function fn_2(self)
	-- function 4
	if type(self) ~= "table" then
		return false, ("'dictionary' - table expected got '%s'."):format(type(self))
	end

	if not (type(self.adler32) ~= "number" or type(self.string_table) ~= "table" or type(self.strlen) ~= "number" or self.strlen <= 0 or self.strlen > 32768 or self.strlen ~= #self.string_table or type(self.hash_tables) == "table") then
		return false, ("'dictionary' - corrupted dictionary."):format(type(self))
	end

	return true, ""
end

local tbl_16 = {
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

local function fn_3(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if type(arg_5_0) ~= "string" then
		return false, ("'str' - string expected got '%s'."):format(type(arg_5_0))
	end

	if not arg_5_1 then
		local var_5_0, var_5_1 = fn_2(arg_5_2)

		if not var_5_0 then
			return false, var_5_1
		end
	end

	if not arg_5_3 then
		local var_5_2 = type(arg_5_4)

		if not (var_5_2 == "nil" or var_5_2 == "table") then
			return false, ("'configs' - nil or table expected got '%s'."):format(type(arg_5_4))
		end

		if var_5_2 == "table" then
			for iter_5_0, iter_5_1 in pairs(arg_5_4) do
				if not (iter_5_0 == "level" or iter_5_0 == "strategy") then
					return false, ("'configs' - unsupported table key in the configs: '%s'."):format(iter_5_0)
				elseif not (iter_5_0 ~= "level" or tbl_16[iter_5_1]) then
					return false, ("'configs' - unsupported 'level': %s."):format(tostring(iter_5_1))
				elseif not (iter_5_0 ~= "strategy" or iter_5_1 == "fixed" or iter_5_1 == "huffman_only" or iter_5_1 == "dynamic") then
					return false, ("'configs' - unsupported 'strategy': '%s'."):format(tostring(iter_5_1))
				end
			end
		end
	end

	return true, ""
end

local num_14 = 0
local num_15 = 1
local num_16 = 2
local num_17 = 3

local function fn_4()
	-- function 6
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local tbl = {}
	local tbl_4 = {}

	local function fn(arg_7_0, arg_7_1)
		-- function 7
		num_2 = num_2 + arg_7_0 * tbl_2[num_3]
		num_3 = num_3 + arg_7_1
		num_4 = num_4 + arg_7_1

		if num_3 >= 32 then
			num = num + 1
			tbl[num] = tbl_3[num_2 % 256] .. tbl_3[(num_2 - num_2 % 256) / 256 % 256] .. tbl_3[(num_2 - num_2 % 65536) / 65536 % 256] .. tbl_3[(num_2 - num_2 % 16777216) / 16777216 % 256]

			local var_7_0 = tbl_2[32 - num_3 + arg_7_1]

			num_2 = (arg_7_0 - arg_7_0 % var_7_0) / var_7_0
			num_3 = num_3 - 32
		end
	end

	local function fn_2(arg_8_0)
		-- function 8
		for i = 1, num_3, 8 do
			num = num + 1
			tbl[num] = char(num_2 % 256)
			num_2 = (num_2 - num_2 % 256) / 256
		end

		num_3 = 0
		num = num + 1
		tbl[num] = arg_8_0
		num_4 = num_4 + #arg_8_0 * 8
	end

	local function fn_3(arg_9_0)
		-- function 9
		if arg_9_0 == num_17 then
			return num_4
		end

		if not (arg_9_0 == num_15 or arg_9_0 ~= num_16) then
			local num_5 = (8 - num_3 % 8) % 8

			if num_3 > 0 then
				num_2 = num_2 - tbl_2[num_3] + tbl_2[num_3 + num_5]

				for i = 1, num_3, 8 do
					num = num + 1
					tbl[num] = tbl_3[num_2 % 256]
					num_2 = (num_2 - num_2 % 256) / 256
				end

				num_2 = 0
				num_3 = 0
			end

			if arg_9_0 == num_16 then
				num_4 = num_4 + num_5

				return num_4
			end
		end

		local var_9_1 = concat(tbl)

		tbl = {}
		num = 0
		tbl_4[#tbl_4 + 1] = var_9_1

		if arg_9_0 == num_14 then
			return num_4
		else
			return num_4, concat(tbl_4)
		end
	end

	return fn, fn_2, fn_3
end

local function fn_5(self, arg_10_1, arg_10_2)
	-- function 10
	arg_10_2 = arg_10_2 + 1
	self[arg_10_2] = arg_10_1

	local var_10_0 = arg_10_1[1]
	local var_10_1 = arg_10_2
	local num = (var_10_1 - var_10_1 % 2) / 2

	while not (not (num >= 1) or not (var_10_0 < self[num][1])) do
		self[var_10_1], self[num] = self[num], arg_10_1
		var_10_1 = num
		num = (num - num % 2) / 2
	end
end

local function fn_6(self, arg_11_1)
	-- function 11
	local var_11_0 = self[1]
	local var_11_1 = self[arg_11_1]
	local var_11_2 = var_11_1[1]

	self[1] = var_11_1
	self[arg_11_1] = var_11_0
	arg_11_1 = arg_11_1 - 1

	local num = 1
	local num_2 = num * 2
	local num_3 = num_2 + 1

	while num_2 <= arg_11_1 do
		local var_11_6 = self[num_2]

		if not (not (num_3 <= arg_11_1) or not (self[num_3][1] < var_11_6[1])) then
			local var_11_7 = self[num_3]

			if var_11_2 > var_11_7[1] then
				self[num_3] = var_11_1
				self[num] = var_11_7
				num = num_3
				num_2 = num * 2
				num_3 = num_2 + 1
			else
				break
			end
		elseif var_11_2 > var_11_6[1] then
			self[num_2] = var_11_1
			self[num] = var_11_6
			num = num_2
			num_2 = num * 2
			num_3 = num_2 + 1
		else
			break
		end
	end

	return var_11_0
end

local function fn_7(self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local num = 0
	local tbl = {}
	local tbl_2 = {}

	for i = 1, arg_12_3 do
		local var_12_3 = self[i - 1]

		var_12_3 = var_12_3 or 0
		num = (num + var_12_3) * 2
		tbl[i] = num
	end

	for j = 0, arg_12_2 do
		local var_12_4 = arg_12_1[j]

		if not var_12_4 then
			local var_12_5 = tbl[var_12_4]

			tbl[var_12_4] = var_12_5 + 1

			if var_12_4 <= 9 then
				tbl_2[j] = tbl_4[var_12_4][var_12_5]
			else
				local num_2 = 0

				for k = 1, var_12_4 do
					local num_3 = num_2 - num_2 % 2
					local flag

					flag = num_2 % 2 == 1 or var_12_5 % 2 == 1 or 1 or 0
					num_2 = num_3 + flag
					var_12_5 = (var_12_5 - var_12_5 % 2) / 2
					num_2 = num_2 * 2
				end

				tbl_2[j] = (num_2 - num_2 % 2) / 2
			end
		end
	end

	return tbl_2
end

local function fn_8(self, arg_13_1)
	-- function 13
	return self[1] < arg_13_1[1] or self[1] ~= arg_13_1[1] or self[2] < arg_13_1[2]
end

local function fn_9(arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0
	local num = -1
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local num_2 = 0

	for iter_14_0, iter_14_1 in pairs(arg_14_0) do
		num_2 = num_2 + 1
		tbl[num_2] = {
			iter_14_1,
			iter_14_0
		}
	end

	if num_2 == 0 then
		return {}, {}, -1
	elseif num_2 == 1 then
		local var_14_8 = tbl[1][2]

		tbl_3[var_14_8] = 1
		tbl_4[var_14_8] = 0

		return tbl_3, tbl_4, var_14_8
	else
		sort(tbl, fn_8)

		local var_14_9 = num_2

		for k = 1, var_14_9 do
			tbl_2[k] = tbl[k]
		end

		while var_14_9 > 1 do
			local var_14_10 = fn_6(tbl_2, var_14_9)

			var_14_9 = var_14_9 - 1

			local var_14_11 = fn_6(tbl_2, var_14_9)

			var_14_9 = var_14_9 - 1

			local tbl_6 = {
				var_14_10[1] + var_14_11[1],
				-1,
				var_14_10,
				var_14_11
			}

			fn_5(tbl_2, tbl_6, var_14_9)

			var_14_9 = var_14_9 + 1
		end

		local num_3 = 0
		local tbl_7 = {
			tbl_2[1],
			0,
			0,
			0
		}
		local num_4 = 1
		local num_5 = 1

		tbl_2[1][1] = 0

		while num_5 <= num_4 do
			local var_14_17 = tbl_7[num_5]
			local var_14_18 = var_14_17[1]
			local var_14_19 = var_14_17[2]
			local var_14_20 = var_14_17[3]
			local var_14_21 = var_14_17[4]

			if not var_14_20 then
				num_4 = num_4 + 1
				tbl_7[num_4] = var_14_20
				var_14_20[1] = var_14_18 + 1
			end

			if not var_14_21 then
				num_4 = num_4 + 1
				tbl_7[num_4] = var_14_21
				var_14_21[1] = var_14_18 + 1
			end

			num_5 = num_5 + 1

			if arg_14_1 < var_14_18 then
				num_3 = num_3 + 1
				var_14_18 = arg_14_1
			end

			if var_14_19 >= 0 then
				tbl_3[var_14_19] = var_14_18
				num = not (num < var_14_19) or not var_14_19 or num

				local var_14_22 = tbl_5[var_14_18]

				var_14_22 = var_14_22 or 0
				tbl_5[var_14_18] = var_14_22 + 1
			end
		end

		if num_3 > 0 then
			repeat
				local num_6 = arg_14_1 - 1

				::label_14_0::

				local var_14_24 = tbl_5[num_6]

				var_14_24 = var_14_24 or 0

				if var_14_24 == 0 then
					repeat
						num_6 = num_6 - 1

						goto label_14_0
					until true
				end

				tbl_5[num_6] = tbl_5[num_6] - 1

				local num_7 = num_6 + 1
				local var_14_26 = tbl_5[num_6 + 1]

				var_14_26 = var_14_26 or 0
				tbl_5[num_7] = var_14_26 + 2
				tbl_5[arg_14_1] = tbl_5[arg_14_1] - 1
				num_3 = num_3 - 2
			until num_3 <= 0

			local num_8 = 1

			for l = arg_14_1, 1, -1 do
				local var_14_28 = tbl_5[l]

				var_14_28 = var_14_28 or 0

				while var_14_28 > 0 do
					tbl_3[tbl[num_8][2]] = l
					var_14_28 = var_14_28 - 1
					num_8 = num_8 + 1
				end
			end
		end

		local var_14_29 = fn_7(tbl_5, tbl_3, arg_14_2, arg_14_1)

		return tbl_3, var_14_29, num
	end
end

local function fn_10(self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local num = 0
	local tbl = {}
	local tbl_2 = {}
	local num_2 = 0
	local tbl_3 = {}
	local var_15_5
	local num_3 = 0

	arg_15_3 = not (arg_15_3 < 0) or not 0 or arg_15_3

	local num_4 = arg_15_1 + arg_15_3 + 1

	for i = 0, num_4 + 1 do
		local var_15_8

		if i <= arg_15_1 then
			var_15_8 = self[i]

			if not var_15_8 then
				var_15_8 = 0
			end
		elseif i <= num_4 then
			var_15_8 = arg_15_2[i - arg_15_1 - 1]

			if not var_15_8 then
				var_15_8 = 0
			end
		else
			var_15_8 = nil
		end

		if var_15_8 == var_15_5 then
			num_3 = num_3 + 1

			if not (var_15_8 == 0 or num_3 ~= 6) then
				num = num + 1
				tbl[num] = 16
				num_2 = num_2 + 1
				tbl_3[num_2] = 3

				local var_15_9 = tbl_2[16]

				var_15_9 = var_15_9 or 0
				tbl_2[16] = var_15_9 + 1
				num_3 = 0
			elseif not (var_15_8 ~= 0 or num_3 ~= 138) then
				num = num + 1
				tbl[num] = 18
				num_2 = num_2 + 1
				tbl_3[num_2] = 127

				local var_15_10 = tbl_2[18]

				var_15_10 = var_15_10 or 0
				tbl_2[18] = var_15_10 + 1
				num_3 = 0
			end
		else
			if num_3 == 1 then
				num = num + 1
				tbl[num] = var_15_5

				local var_15_11 = tbl_2[var_15_5]

				var_15_11 = var_15_11 or 0
				tbl_2[var_15_5] = var_15_11 + 1
			elseif num_3 == 2 then
				num = num + 1
				tbl[num] = var_15_5
				num = num + 1
				tbl[num] = var_15_5

				local var_15_12 = tbl_2[var_15_5]

				var_15_12 = var_15_12 or 0
				tbl_2[var_15_5] = var_15_12 + 2
			elseif num_3 >= 3 then
				num = num + 1

				local flag

				flag = (var_15_5 == 0 or not 16 or not (num_3 <= 10)) and (not 17 or 18)
				tbl[num] = flag

				local var_15_14 = tbl_2[flag]

				var_15_14 = var_15_14 or 0
				tbl_2[flag] = var_15_14 + 1
				num_2 = num_2 + 1

				local num_5

				if num_3 <= 10 then
					num_5 = num_3 - 3

					if not num_5 then
						-- Nothing
					end
				end

				num_5 = num_3 - 11

				::label_15_0::

				tbl_3[num_2] = num_5
			end

			var_15_5 = var_15_8

			if not (not var_15_8 and var_15_8 == 0) then
				num = num + 1
				tbl[num] = var_15_8

				local var_15_16 = tbl_2[var_15_8]

				var_15_16 = var_15_16 or 0
				tbl_2[var_15_8] = var_15_16 + 1
				num_3 = 0
			else
				num_3 = 1
			end
		end
	end

	return tbl, tbl_3, tbl_2
end

local function fn_11(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local num = arg_16_2 - arg_16_4

	while num <= arg_16_3 - 15 - arg_16_4 do
		arg_16_1[num], arg_16_1[num + 1], arg_16_1[num + 2], arg_16_1[num + 3], arg_16_1[num + 4], arg_16_1[num + 5], arg_16_1[num + 6], arg_16_1[num + 7], arg_16_1[num + 8], arg_16_1[num + 9], arg_16_1[num + 10], arg_16_1[num + 11], arg_16_1[num + 12], arg_16_1[num + 13], arg_16_1[num + 14], arg_16_1[num + 15] = byte(arg_16_0, num + arg_16_4, num + 15 + arg_16_4)
		num = num + 16
	end

	while num <= arg_16_3 - arg_16_4 do
		arg_16_1[num] = byte(arg_16_0, num + arg_16_4, num + arg_16_4)
		num = num + 1
	end

	return arg_16_1
end

local function fn_12(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	-- function 17
	local var_17_0 = tbl_16[arg_17_0]
	local var_17_1 = var_17_0[1]
	local var_17_2 = var_17_0[2]
	local var_17_3 = var_17_0[3]
	local var_17_4 = var_17_0[4]
	local var_17_5 = var_17_0[5]
	local flag = var_17_1 or not var_17_3 or 2147483646
	local num = var_17_5 - var_17_5 % 4 / 4
	local var_17_8
	local var_17_9
	local var_17_10
	local num_2 = 0

	if not arg_17_6 then
		var_17_9 = arg_17_6.hash_tables
		var_17_10 = arg_17_6.string_table
		num_2 = arg_17_6.strlen

		assert(arg_17_3 == 1)

		if not (not (arg_17_3 <= arg_17_4) or not (num_2 >= 2)) then
			local num_3 = var_17_10[num_2 - 1] * 65536 + var_17_10[num_2] * 256 + arg_17_1[1]
			local var_17_13 = arg_17_2[num_3]

			if not var_17_13 then
				var_17_13 = {}
				arg_17_2[num_3] = var_17_13
			end

			var_17_13[#var_17_13 + 1] = -1
		end

		if not (not (arg_17_4 >= arg_17_3 + 1) or not (num_2 >= 1)) then
			local num_4 = var_17_10[num_2] * 65536 + arg_17_1[1] * 256 + arg_17_1[2]
			local var_17_15 = arg_17_2[num_4]

			if not var_17_15 then
				var_17_15 = {}
				arg_17_2[num_4] = var_17_15
			end

			var_17_15[#var_17_15 + 1] = 0
		end
	end

	local num_5 = num_2 + 3
	local var_17_17 = arg_17_1[arg_17_3 - arg_17_5]

	var_17_17 = var_17_17 or 0

	local num_6 = var_17_17 * 256
	local var_17_19 = arg_17_1[arg_17_3 + 1 - arg_17_5]

	var_17_19 = var_17_19 or 0

	local num_7 = num_6 + var_17_19
	local tbl = {}
	local num_8 = 0
	local tbl_2 = {}
	local tbl_3 = {}
	local num_9 = 0
	local tbl_4 = {}
	local tbl_11 = {}
	local num_10 = 0
	local tbl_12 = {}
	local num_11 = 0
	local flag_2 = false
	local var_17_32
	local var_17_33
	local num_12 = 0
	local num_13 = 0
	local var_17_36 = arg_17_3
	local flag_3

	flag_3 = not var_17_1 and 1 and 0

	local num_14 = arg_17_4 + flag_3

	while var_17_36 <= num_14 do
		local num_15 = var_17_36 - arg_17_5
		local num_16 = arg_17_5 - 3
		local var_17_41 = num_12
		local var_17_42 = num_13

		num_12 = 0

		local num_17 = num_7 * 256
		local var_17_44 = arg_17_1[num_15 + 2]

		var_17_44 = var_17_44 or 0
		num_7 = (num_17 + var_17_44) % 16777216

		local var_17_45
		local var_17_46
		local var_17_47 = arg_17_2[num_7]
		local var_17_48

		if not var_17_47 then
			var_17_48 = 0
			var_17_47 = {}
			arg_17_2[num_7] = var_17_47

			if not var_17_9 then
				var_17_46 = var_17_9[num_7]
				var_17_45 = not var_17_46 and #var_17_46 and 0
			else
				var_17_45 = 0
			end
		else
			var_17_48 = #var_17_47
			var_17_46 = var_17_47
			var_17_45 = var_17_48
		end

		if var_17_36 <= arg_17_4 then
			var_17_47[var_17_48 + 1] = var_17_36
		end

		if not (not (var_17_45 > 0) or not (arg_17_4 >= var_17_36 + 2) or not var_17_1 or not (var_17_41 < var_17_3)) then
			local flag_4 = not var_17_1 and var_17_2 <= var_17_41 and num and var_17_5
			local num_18 = arg_17_4 - var_17_36

			num_18 = not (num_18 >= 257) or not 257 or num_18

			local num_19 = num_18 + num_15
			local num_20 = num_15 + 3

			while not (not (var_17_45 >= 1) or not (flag_4 > 0)) do
				local var_17_53 = var_17_46[var_17_45]

				if var_17_36 - var_17_53 > 32768 then
					break
				end

				if var_17_53 < var_17_36 then
					local var_17_54 = num_20

					if var_17_53 >= -257 then
						local num_21 = var_17_53 - num_16

						while not (not (var_17_54 <= num_19) or arg_17_1[num_21] ~= arg_17_1[var_17_54]) do
							var_17_54 = var_17_54 + 1
							num_21 = num_21 + 1
						end
					else
						local num_22 = num_5 + var_17_53

						while not (not (var_17_54 <= num_19) or var_17_10[num_22] ~= arg_17_1[var_17_54]) do
							var_17_54 = var_17_54 + 1
							num_22 = num_22 + 1
						end
					end

					local num_23 = var_17_54 - num_15

					if num_12 < num_23 then
						num_12 = num_23
						num_13 = var_17_36 - var_17_53
					end

					if var_17_4 <= num_12 then
						break
					end
				end

				var_17_45 = var_17_45 - 1
				flag_4 = flag_4 - 1

				if var_17_45 ~= 0 or not (var_17_53 > 0) or not var_17_9 then
					var_17_46 = var_17_9[num_7]
					var_17_45 = not var_17_46 and #var_17_46 and 0
				end
			end
		end

		if not var_17_1 then
			var_17_41, var_17_42 = num_12, num_13
		end

		if not (not var_17_1 and flag_2 and var_17_41 > 3 or var_17_41 ~= 3 and var_17_42 < 4096 and not (num_12 <= var_17_41)) then
			local var_17_58 = tbl_5[var_17_41]
			local var_17_59 = tbl_7[var_17_41]
			local var_17_60
			local var_17_61
			local var_17_62

			if var_17_42 <= 256 then
				var_17_60 = tbl_8[var_17_42]
				var_17_62 = tbl_9[var_17_42]
				var_17_61 = tbl_10[var_17_42]
			else
				var_17_60 = 16
				var_17_61 = 7

				local num_24 = 384
				local num_25 = 512

				while true do
					if var_17_42 <= num_24 then
						var_17_62 = (var_17_42 - num_25 / 2 - 1) % (num_25 / 4)

						break
					elseif var_17_42 <= num_25 then
						var_17_62 = (var_17_42 - num_25 / 2 - 1) % (num_25 / 4)
						var_17_60 = var_17_60 + 1

						break
					else
						var_17_60 = var_17_60 + 2
						var_17_61 = var_17_61 + 1
						num_24 = num_24 * 2
						num_25 = num_25 * 2
					end
				end
			end

			num_8 = num_8 + 1
			tbl[num_8] = var_17_58

			local var_17_65 = tbl_2[var_17_58]

			var_17_65 = var_17_65 or 0
			tbl_2[var_17_58] = var_17_65 + 1
			num_9 = num_9 + 1
			tbl_3[num_9] = var_17_60

			local var_17_66 = tbl_4[var_17_60]

			var_17_66 = var_17_66 or 0
			tbl_4[var_17_60] = var_17_66 + 1

			if var_17_59 > 0 then
				tbl_11[num_10], num_10 = tbl_6[var_17_41], num_10 + 1
			end

			if var_17_61 > 0 then
				num_11 = num_11 + 1
				tbl_12[num_11] = var_17_62
			end

			local num_26 = var_17_36 + 1
			local num_27 = var_17_36 + var_17_41
			local flag_5

			flag_5 = not var_17_1 and 2 and 1

			for i = num_26, num_27 - flag_5 do
				local num_28 = num_7 * 256
				local var_17_71 = arg_17_1[i - arg_17_5 + 2]

				var_17_71 = var_17_71 or 0
				num_7 = (num_28 + var_17_71) % 16777216

				if var_17_41 <= flag then
					local var_17_72 = arg_17_2[num_7]

					if not var_17_72 then
						var_17_72 = {}
						arg_17_2[num_7] = var_17_72
					end

					var_17_72[#var_17_72 + 1] = i
				end
			end

			local num_29 = var_17_36 + var_17_41
			local flag_6

			flag_6 = not var_17_1 and 1 and 0
			var_17_36 = num_29 - flag_6
			flag_2 = false
		elseif not var_17_1 and not flag_2 then
			local num_30

			if not var_17_1 then
				num_30 = num_15 - 1

				if not num_30 then
					-- Nothing
				end
			end

			num_30 = num_15

			::label_17_0::

			local var_17_76 = arg_17_1[num_30]

			num_8 = num_8 + 1
			tbl[num_8] = var_17_76

			local var_17_77 = tbl_2[var_17_76]

			var_17_77 = var_17_77 or 0
			tbl_2[var_17_76] = var_17_77 + 1
			var_17_36 = var_17_36 + 1
		else
			flag_2 = true
			var_17_36 = var_17_36 + 1
		end
	end

	tbl[num_8 + 1] = 256

	local num_31 = 256
	local var_17_79 = tbl_2[256]

	var_17_79 = var_17_79 or 0
	tbl_2[num_31] = var_17_79 + 1

	return tbl, tbl_11, tbl_2, tbl_3, tbl_12, tbl_4
end

local function fn_13(arg_18_0, arg_18_1)
	-- function 18
	local var_18_0, var_18_1, var_18_2 = fn_9(arg_18_0, 15, 285)
	local var_18_3, var_18_4, var_18_5 = fn_9(arg_18_1, 15, 29)
	local var_18_6, var_18_7, var_18_8 = fn_10(var_18_0, var_18_2, var_18_3, var_18_5)
	local var_18_9, var_18_10 = fn_9(var_18_8, 7, 18)
	local num = 0

	for i = 1, 19 do
		local var_18_12 = var_18_9[tbl_15[i]]

		var_18_12 = var_18_12 or 0

		if var_18_12 ~= 0 then
			num = i
		end
	end

	local num_2 = num - 4
	local num_3 = var_18_2 + 1 - 257
	local num_4 = var_18_5 + 1 - 1

	if num_4 < 0 then
		num_4 = 0
	end

	return num_3, num_4, num_2, var_18_9, var_18_10, var_18_6, var_18_7, var_18_0, var_18_1, var_18_3, var_18_4
end

local function fn_14(self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	-- function 19
	local num = 17 + (arg_19_2 + 4) * 3

	for i = 1, #arg_19_4 do
		local var_19_1 = arg_19_4[i]

		num = num + arg_19_3[var_19_1]

		if var_19_1 >= 16 then
			local flag

			flag = (var_19_1 ~= 16 or not 2 or var_19_1 ~= 17) and (not 3 or 7)
			num = num + flag
		end
	end

	local num_2 = 0

	for j = 1, #self do
		local var_19_4 = self[j]

		num = num + arg_19_5[var_19_4]

		if var_19_4 > 256 then
			num_2 = num_2 + 1

			if not (not (var_19_4 > 264) or not (var_19_4 < 285)) then
				num = num + tbl_12[var_19_4 - 256]
			end

			local var_19_5 = arg_19_1[num_2]

			num = num + arg_19_6[var_19_5]

			if var_19_5 > 3 then
				num = num + ((var_19_5 - var_19_5 % 2) / 2 - 1)
			end
		end
	end

	return num
end

local function fn_15(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9, arg_20_10, arg_20_11, arg_20_12, arg_20_13, arg_20_14, arg_20_15, arg_20_16)
	-- function 20
	local var_20_0 = arg_20_0
	local flag

	flag = not arg_20_1 and 1 and 0

	var_20_0(flag, 1)
	arg_20_0(2, 2)
	arg_20_0(arg_20_6, 5)
	arg_20_0(arg_20_7, 5)
	arg_20_0(arg_20_8, 4)

	for i = 1, arg_20_8 + 4 do
		local var_20_2 = arg_20_9[tbl_15[i]]

		var_20_2 = var_20_2 or 0

		arg_20_0(var_20_2, 3)
	end

	local num = 1

	for j = 1, #arg_20_11 do
		local var_20_4 = arg_20_11[j]

		arg_20_0(arg_20_10[var_20_4], arg_20_9[var_20_4])

		if var_20_4 >= 16 then
			local var_20_5, var_20_6 = arg_20_12[num], arg_20_0
			local flag_2

			flag_2 = (var_20_4 ~= 16 or not 2 or var_20_4 ~= 17) and (not 3 or 7)

			var_20_6(var_20_5, flag_2)

			num = num + 1
		end
	end

	local num_2 = 0
	local num_3 = 0
	local num_4 = 0

	for k = 1, #arg_20_2 do
		local var_20_11 = arg_20_2[k]
		local var_20_12 = arg_20_14[var_20_11]
		local var_20_13 = arg_20_13[var_20_11]

		arg_20_0(var_20_12, var_20_13)

		if var_20_11 > 256 then
			num_2 = num_2 + 1

			if not (not (var_20_11 > 264) or not (var_20_11 < 285)) then
				num_3 = num_3 + 1

				local var_20_14 = arg_20_3[num_3]
				local var_20_15 = tbl_12[var_20_11 - 256]

				arg_20_0(var_20_14, var_20_15)
			end

			local var_20_16 = arg_20_4[num_2]
			local var_20_17 = arg_20_16[var_20_16]
			local var_20_18 = arg_20_15[var_20_16]

			arg_20_0(var_20_17, var_20_18)

			if var_20_16 > 3 then
				num_4 = num_4 + 1

				local var_20_19 = arg_20_5[num_4]
				local num_5 = (var_20_16 - var_20_16 % 2) / 2 - 1

				arg_20_0(var_20_19, num_5)
			end
		end
	end
end

local function fn_16(self, arg_21_1)
	-- function 21
	local num = 3
	local num_2 = 0

	for i = 1, #self do
		local var_21_2 = self[i]

		num = num + var_0_32[var_21_2]

		if var_21_2 > 256 then
			num_2 = num_2 + 1

			if not (not (var_21_2 > 264) or not (var_21_2 < 285)) then
				num = num + tbl_12[var_21_2 - 256]
			end

			local var_21_3 = arg_21_1[num_2]

			num = num + 5

			if var_21_3 > 3 then
				num = num + ((var_21_3 - var_21_3 % 2) / 2 - 1)
			end
		end
	end

	return num
end

local function fn_17(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local var_22_0 = arg_22_0
	local flag

	flag = not arg_22_1 and 1 and 0

	var_22_0(flag, 1)
	arg_22_0(1, 2)

	local num = 0
	local num_2 = 0
	local num_3 = 0

	for i = 1, #arg_22_2 do
		local var_22_5 = arg_22_2[i]
		local var_22_6 = var_0_30[var_22_5]
		local var_22_7 = var_0_32[var_22_5]

		arg_22_0(var_22_6, var_22_7)

		if var_22_5 > 256 then
			num = num + 1

			if not (not (var_22_5 > 264) or not (var_22_5 < 285)) then
				num_2 = num_2 + 1

				local var_22_8 = arg_22_3[num_2]
				local var_22_9 = tbl_12[var_22_5 - 256]

				arg_22_0(var_22_8, var_22_9)
			end

			local var_22_10 = arg_22_4[num]
			local var_22_11 = var_0_34[var_22_10]

			arg_22_0(var_22_11, 5)

			if var_22_10 > 3 then
				num_3 = num_3 + 1

				local var_22_12 = arg_22_5[num_3]
				local num_4 = (var_22_10 - var_22_10 % 2) / 2 - 1

				arg_22_0(var_22_12, num_4)
			end
		end
	end
end

local function fn_18(arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	assert(arg_23_1 - arg_23_0 + 1 <= 65535)

	local num = 3

	arg_23_2 = arg_23_2 + 3

	return num + (8 - arg_23_2 % 8) % 8 + 32 + (arg_23_1 - arg_23_0 + 1) * 8
end

local function fn_19(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	assert(arg_24_5 - arg_24_4 + 1 <= 65535)

	local var_24_0 = arg_24_0
	local flag

	flag = not arg_24_2 and 1 and 0

	var_24_0(flag, 1)
	arg_24_0(0, 2)

	arg_24_6 = arg_24_6 + 3

	local num = (8 - arg_24_6 % 8) % 8

	if num > 0 then
		arg_24_0(tbl_2[num] - 1, num)
	end

	local num_2 = arg_24_5 - arg_24_4 + 1

	arg_24_0(num_2, 16)

	local num_3 = 255 - num_2 % 256 + (255 - (num_2 - num_2 % 256) / 256) * 256

	arg_24_0(num_3, 16)
	arg_24_1(arg_24_3:sub(arg_24_4, arg_24_5))
end

local function fn_20(self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local tbl = {}
	local tbl_2 = {}
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5
	local var_25_6 = arg_25_3(num_17)
	local count = #arg_25_4
	local var_25_8
	local var_25_9
	local var_25_10

	if not self then
		if not self.level then
			var_25_9 = self.level
		end

		if not self.strategy then
			var_25_10 = self.strategy
		end
	end

	var_25_9 = (var_25_9 or not (count < 2048) or not 7 or not (count > 65536)) and (not 3 or 5)

	while not var_25_2 do
		local num

		if not var_25_3 then
			var_25_3 = 1
			var_25_4 = 65535
			num = 0
		else
			var_25_3 = var_25_4 + 1
			var_25_4 = var_25_4 + 32768
			num = var_25_3 - 32768 - 1
		end

		if count <= var_25_4 then
			var_25_4 = count
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
			fn_11(arg_25_4, tbl, var_25_3, var_25_4 + 3, num)

			if var_25_3 ~= 1 or not arg_25_5 then
				local string_table = arg_25_5.string_table
				local strlen = arg_25_5.strlen
				local num_2 = 0
				local flag

				flag = not (-strlen + 1 < -257) or not -257 or -strlen + 1

				for i = num_2, flag, -1 do
					tbl[i] = string_table[strlen + i]
				end
			end

			if var_25_10 == "huffman_only" then
				var_25_12 = {}

				fn_11(arg_25_4, var_25_12, var_25_3, var_25_4, var_25_3 - 1)

				var_25_13 = {}
				var_25_14 = {}
				var_25_12[var_25_4 - var_25_3 + 2] = 256

				for j = 1, var_25_4 - var_25_3 + 2 do
					local var_25_36 = var_25_12[j]
					local var_25_37 = var_25_14[var_25_36]

					var_25_37 = var_25_37 or 0
					var_25_14[var_25_36] = var_25_37 + 1
				end

				var_25_15 = {}
				var_25_16 = {}
				var_25_17 = {}
			else
				var_25_12, var_25_13, var_25_14, var_25_15, var_25_16, var_25_17 = fn_12(var_25_9, tbl, tbl_2, var_25_3, var_25_4, num, arg_25_5)
			end

			var_25_18, var_25_19, var_25_20, var_25_21, var_25_22, var_25_23, var_25_24, var_25_25, var_25_26, var_25_27, var_25_28 = fn_13(var_25_14, var_25_17)
			var_25_29 = fn_14(var_25_12, var_25_15, var_25_20, var_25_21, var_25_23, var_25_25, var_25_27)
			var_25_30 = fn_16(var_25_12, var_25_15)
		end

		local var_25_38 = fn_18(var_25_3, var_25_4, var_25_6)
		local var_25_39 = var_25_38

		var_25_39 = not var_25_30 and var_25_30 < var_25_39 and var_25_30 and var_25_39
		var_25_39 = not var_25_29 and var_25_29 < var_25_39 and var_25_29 and var_25_39

		if not (var_25_9 == 0 or var_25_10 == "fixed" or var_25_10 == "dynamic" or var_25_38 ~= var_25_39) then
			fn_19(arg_25_1, arg_25_2, var_25_2, arg_25_4, var_25_3, var_25_4, var_25_6)

			var_25_6 = var_25_6 + var_25_38
		elseif not (var_25_10 == "dynamic" or var_25_10 == "fixed" or var_25_30 ~= var_25_39) then
			fn_17(arg_25_1, var_25_2, var_25_12, var_25_13, var_25_15, var_25_16)

			var_25_6 = var_25_6 + var_25_30
		elseif not (var_25_10 == "dynamic" or var_25_29 ~= var_25_39) then
			fn_15(arg_25_1, var_25_2, var_25_12, var_25_13, var_25_15, var_25_16, var_25_18, var_25_19, var_25_20, var_25_21, var_25_22, var_25_23, var_25_24, var_25_25, var_25_26, var_25_27, var_25_28)

			var_25_6 = var_25_6 + var_25_29
		end

		if not var_25_2 then
			var_25_5 = arg_25_3(num_17)
		else
			var_25_5 = arg_25_3(num_14)
		end

		assert(var_25_5 == var_25_6)

		if not var_25_2 then
			local var_25_40

			if not (not arg_25_5 and var_25_3 ~= 1) then
				local num_3 = 0

				while not tbl[num_3] do
					tbl[num_3] = nil
					num_3 = num_3 - 1
				end
			end

			arg_25_5 = nil

			local num_4 = 1

			for k = var_25_4 - 32767, var_25_4 do
				tbl[num_4] = tbl[k - num]
				num_4 = num_4 + 1
			end

			for iter_25_3, iter_25_4 in pairs(tbl_2) do
				local count_2 = #iter_25_4

				if not (not (count_2 > 0) or not (var_25_4 + 1 - iter_25_4[1] > 32768)) then
					if count_2 == 1 then
						tbl_2[iter_25_3] = nil
					else
						local tbl_3 = {}
						local num_5 = 0

						for i5 = 2, count_2 do
							local var_25_46 = iter_25_4[i5]

							if var_25_4 + 1 - var_25_46 <= 32768 then
								num_5 = num_5 + 1
								tbl_3[num_5] = var_25_46
							end
						end

						tbl_2[iter_25_3] = tbl_3
					end
				end
			end
		end
	end
end

local function fn_21(arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local var_26_0, var_26_1, var_26_2 = fn_4()

	fn_20(arg_26_2, var_26_0, var_26_1, var_26_2, arg_26_0, arg_26_1)

	local var_26_3, var_26_4 = var_26_2(num_15)
	local num = (8 - var_26_3 % 8) % 8

	return var_26_4, num
end

local function fn_22(arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0, var_27_1, var_27_2 = fn_4()
	local num = 8
	local num_2 = 7
	local num_3 = num_2 * 16 + num

	var_27_0(num_3, 8)

	local flag

	flag = not arg_27_1 and 1 and 0

	local num_4 = 2
	local num_5 = num_4 * 64 + flag * 32
	local num_6 = num_5 + (31 - (num_3 * 256 + num_5) % 31)

	var_27_0(num_6, 8)

	if flag == 1 then
		local adler32 = arg_27_1.adler32
		local num_7 = adler32 % 256
		local num_8 = (adler32 - num_7) / 256
		local num_9 = num_8 % 256
		local num_10 = (num_8 - num_9) / 256
		local num_11 = num_10 % 256
		local num_12 = (num_10 - num_11) / 256 % 256

		var_27_0(num_12, 8)
		var_27_0(num_11, 8)
		var_27_0(num_9, 8)
		var_27_0(num_7, 8)
	end

	fn_20(arg_27_2, var_27_0, var_27_1, var_27_2, arg_27_0, arg_27_1)
	var_27_2(num_16)

	local Adler32 = tbl:Adler32(arg_27_0)
	local num_13 = Adler32 % 256
	local num_14 = (Adler32 - num_13) / 256
	local num_17 = num_14 % 256
	local num_18 = (num_14 - num_17) / 256
	local num_19 = num_18 % 256
	local num_20 = (num_18 - num_19) / 256 % 256

	var_27_0(num_20, 8)
	var_27_0(num_19, 8)
	var_27_0(num_17, 8)
	var_27_0(num_13, 8)

	local var_27_24, var_27_25 = var_27_2(num_15)
	local num_21 = (8 - var_27_24 % 8) % 8

	return var_27_25, num_21
end

tbl.CompressDeflate = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local var_28_0, var_28_1 = fn_3(arg_28_1, false, nil, true, arg_28_2)

	if not var_28_0 then
		error("Usage: LibDeflate:CompressDeflate(str, configs): " .. var_28_1, 2)
	end

	return fn_21(arg_28_1, nil, arg_28_2)
end

tbl.CompressDeflateWithDict = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local var_29_0, var_29_1 = fn_3(arg_29_1, true, arg_29_2, true, arg_29_3)

	if not var_29_0 then
		error("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. var_29_1, 2)
	end

	return fn_21(arg_29_1, arg_29_2, arg_29_3)
end

tbl.CompressZlib = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	local var_30_0, var_30_1 = fn_3(arg_30_1, false, nil, true, arg_30_2)

	if not var_30_0 then
		error("Usage: LibDeflate:CompressZlib(str, configs): " .. var_30_1, 2)
	end

	return fn_22(arg_30_1, nil, arg_30_2)
end

tbl.CompressZlibWithDict = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local var_31_0, var_31_1 = fn_3(arg_31_1, true, arg_31_2, true, arg_31_3)

	if not var_31_0 then
		error("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. var_31_1, 2)
	end

	return fn_22(arg_31_1, arg_31_2, arg_31_3)
end

local function fn_23(arg_32_0)
	-- function 32
	local var_32_0 = arg_32_0
	local count = #arg_32_0
	local num = 1
	local num_2 = 0
	local num_3 = 0

	local function fn(arg_33_0)
		-- function 33
		local var_33_0 = tbl_2[arg_33_0]
		local var_33_1

		if arg_33_0 <= num_2 then
			var_33_1 = num_3 % var_33_0
			num_3 = (num_3 - var_33_1) / var_33_0
			num_2 = num_2 - arg_33_0
		else
			local var_33_2 = tbl_2[num_2]
			local var_33_3, var_33_4, var_33_5, var_33_6 = byte(var_32_0, num, num + 3)

			num_3 = num_3 + ((var_33_3 or 0) + (var_33_4 or 0) * 256 + (var_33_5 or 0) * 65536 + (var_33_6 or 0) * 16777216) * var_33_2
			num = num + 4
			num_2 = num_2 + 32 - arg_33_0
			var_33_1 = num_3 % var_33_0
			num_3 = (num_3 - var_33_1) / var_33_0
		end

		return var_33_1
	end

	local function fn_2(arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		assert(num_2 % 8 == 0)

		local num_4

		if arg_34_0 > num_2 / 8 then
			num_4 = num_2 / 8

			if not num_4 then
				-- Nothing
			end
		end

		num_4 = arg_34_0

		::label_34_0::

		for i = 1, num_4 do
			local num_5 = num_3 % 256

			arg_34_2 = arg_34_2 + 1
			arg_34_1[arg_34_2] = char(num_5)
			num_3 = (num_3 - num_5) / 256
		end

		num_2 = num_2 - num_4 * 8
		arg_34_0 = arg_34_0 - num_4

		if (count - num - arg_34_0 + 1) * 8 + num_2 < 0 then
			return -1
		end

		for j = num, num + arg_34_0 - 1 do
			arg_34_2 = arg_34_2 + 1
			arg_34_1[arg_34_2] = sub(var_32_0, j, j)
		end

		num = num + arg_34_0

		return arg_34_2
	end

	local function fn_3(self, arg_35_1, arg_35_2)
		-- function 35
		local num_4 = 0
		local num_5 = 0
		local num_6 = 0
		local var_35_3

		if arg_35_2 > 0 then
			if not (num_2 < 15) or not var_32_0 then
				local var_35_4 = tbl_2[num_2]
				local var_35_5, var_35_6, var_35_7, var_35_8 = byte(var_32_0, num, num + 3)

				num_3 = num_3 + ((var_35_5 or 0) + (var_35_6 or 0) * 256 + (var_35_7 or 0) * 65536 + (var_35_8 or 0) * 16777216) * var_35_4
				num = num + 4
				num_2 = num_2 + 32
			end

			local var_35_9 = tbl_2[arg_35_2]

			num_2 = num_2 - arg_35_2
			num_4 = num_3 % var_35_9
			num_3 = (num_3 - num_4) / var_35_9
			num_4 = tbl_4[arg_35_2][num_4]

			local var_35_10 = self[arg_35_2]

			if num_4 < var_35_10 then
				return arg_35_1[num_4]
			end

			num_6 = var_35_10
			num_5 = var_35_10 * 2
			num_4 = num_4 * 2
		end

		for i = arg_35_2 + 1, 15 do
			local var_35_11
			local num_7 = num_3 % 2

			num_3 = (num_3 - num_7) / 2
			num_2 = num_2 - 1
			num_4 = num_7 ~= 1 or not (num_4 + 1 - num_4 % 2) or num_4

			local flag = self[i] or 0
			local num_8 = num_4 - num_5

			if num_8 < flag then
				return arg_35_1[num_6 + num_8]
			end

			num_6 = num_6 + flag
			num_5 = num_5 + flag
			num_5 = num_5 * 2
			num_4 = num_4 * 2
		end

		return -10
	end

	local function fn_4()
		-- function 36
		return (count - num + 1) * 8 + num_2
	end

	local function fn_5()
		-- function 37
		local num = num_2 % 8
		local var_37_1 = tbl_2[num]

		num_2 = num_2 - num
		num_3 = (num_3 - num_3 % var_37_1) / var_37_1
	end

	return fn, fn_2, fn_3, fn_4, fn_5
end

local function fn_24(arg_38_0, arg_38_1)
	-- function 38
	local var_38_0, var_38_1, var_38_2, var_38_3, var_38_4 = fn_23(arg_38_0)

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

local function fn_25(self, arg_39_1, arg_39_2)
	-- function 39
	local tbl = {}
	local var_39_1 = arg_39_2

	for i = 0, arg_39_1 do
		local var_39_2 = self[i]

		var_39_2 = var_39_2 or 0
		var_39_1 = not (var_39_2 > 0) or not (var_39_2 < var_39_1) or not var_39_2 or var_39_1

		local var_39_3 = tbl[var_39_2]

		var_39_3 = var_39_3 or 0
		tbl[var_39_2] = var_39_3 + 1
	end

	if tbl[0] == arg_39_1 + 1 then
		return 0, tbl, {}, 0
	end

	local num = 1

	for j = 1, arg_39_2 do
		num = num * 2

		local var_39_5 = tbl[j]

		var_39_5 = var_39_5 or 0
		num = num - var_39_5

		if num < 0 then
			return num
		end
	end

	local tbl_2 = {}

	tbl_2[1] = 0

	for k = 1, arg_39_2 - 1 do
		local num_2 = k + 1
		local var_39_8 = tbl_2[k]
		local var_39_9 = tbl[k]

		var_39_9 = var_39_9 or 0
		tbl_2[num_2] = var_39_8 + var_39_9
	end

	local tbl_3 = {}

	for l = 0, arg_39_1 do
		local var_39_11 = self[l]

		var_39_11 = var_39_11 or 0

		if var_39_11 ~= 0 then
			tbl_3[tbl_2[var_39_11]] = l
			tbl_2[var_39_11] = tbl_2[var_39_11] + 1
		end
	end

	return num, tbl, tbl_3, var_39_1
end

local function fn_26(self, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	-- function 40
	local buffer = self.buffer
	local buffer_size = self.buffer_size
	local ReadBits = self.ReadBits
	local Decode = self.Decode
	local ReaderBitlenLeft = self.ReaderBitlenLeft
	local result_buffer = self.result_buffer
	local dictionary = self.dictionary
	local var_40_7
	local var_40_8
	local num = 1

	if not (not dictionary and buffer[0]) then
		var_40_7 = dictionary.string_table
		var_40_8 = dictionary.strlen
		num = -var_40_8 + 1

		local num_2 = 0
		local flag

		flag = not (-var_40_8 + 1 < -257) or not -257 or -var_40_8 + 1

		for i = num_2, flag, -1 do
			buffer[i] = tbl_3[var_40_7[var_40_8 + i]]
		end
	end

	repeat
		local var_40_12 = Decode(arg_40_1, arg_40_2, arg_40_3)

		if not (var_40_12 < 0 or not (var_40_12 > 285)) then
			return -10
		elseif var_40_12 < 256 then
			buffer_size = buffer_size + 1
			buffer[buffer_size] = tbl_3[var_40_12]
		elseif var_40_12 > 256 then
			var_40_12 = var_40_12 - 256

			local var_40_13 = tbl_11[var_40_12]

			var_40_13 = not (var_40_12 >= 8) or not (var_40_13 + ReadBits(tbl_12[var_40_12])) or var_40_13
			var_40_12 = Decode(arg_40_4, arg_40_5, arg_40_6)

			if not (var_40_12 < 0 or not (var_40_12 > 29)) then
				return -10
			end

			local var_40_14 = tbl_13[var_40_12]

			var_40_14 = not (var_40_14 > 4) or not (var_40_14 + ReadBits(tbl_14[var_40_12])) or var_40_14

			local num_3 = buffer_size - var_40_14 + 1

			if num_3 < num then
				return -11
			end

			if num_3 >= -257 then
				for j = 1, var_40_13 do
					buffer_size = buffer_size + 1
					buffer[buffer_size] = buffer[num_3]
					num_3 = num_3 + 1
				end
			else
				local num_4 = var_40_8 + num_3

				for k = 1, var_40_13 do
					buffer_size = buffer_size + 1
					buffer[buffer_size] = tbl_3[var_40_7[num_4]]
					num_4 = num_4 + 1
				end
			end
		end

		if ReaderBitlenLeft() < 0 then
			return 2
		end

		if buffer_size >= 65536 then
			result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768)

			for l = 32769, buffer_size do
				buffer[l - 32768] = buffer[l]
			end

			buffer_size = buffer_size - 32768
			buffer[buffer_size + 1] = nil
		end
	until var_40_12 == 256

	self.buffer_size = buffer_size

	return 0
end

local function fn_27(self)
	-- function 41
	local buffer = self.buffer
	local buffer_size = self.buffer_size
	local ReadBits = self.ReadBits
	local ReadBytes = self.ReadBytes
	local ReaderBitlenLeft = self.ReaderBitlenLeft
	local SkipToByteBoundary = self.SkipToByteBoundary
	local result_buffer = self.result_buffer

	SkipToByteBoundary()

	local var_41_7 = ReadBits(16)

	if ReaderBitlenLeft() < 0 then
		return 2
	end

	local var_41_8 = ReadBits(16)

	if ReaderBitlenLeft() < 0 then
		return 2
	end

	if var_41_7 % 256 + var_41_8 % 256 ~= 255 then
		return -2
	end

	if (var_41_7 - var_41_7 % 256) / 256 + (var_41_8 - var_41_8 % 256) / 256 ~= 255 then
		return -2
	end

	local var_41_9 = ReadBytes(var_41_7, buffer, buffer_size)

	if var_41_9 < 0 then
		return 2
	end

	if var_41_9 >= 65536 then
		result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768)

		for i = 32769, var_41_9 do
			buffer[i - 32768] = buffer[i]
		end

		var_41_9 = var_41_9 - 32768
		buffer[var_41_9 + 1] = nil
	end

	self.buffer_size = var_41_9

	return 0
end

local function fn_28(arg_42_0)
	-- function 42
	return fn_26(arg_42_0, var_0_33, var_0_31, 7, var_0_37, var_0_35, 5)
end

local function fn_29(self)
	-- function 43
	local ReadBits = self.ReadBits
	local Decode = self.Decode
	local num = ReadBits(5) + 257
	local num_2 = ReadBits(5) + 1
	local num_3 = ReadBits(4) + 4

	if not (num > 286 or not (num_2 > 30)) then
		return -3
	end

	local tbl = {}

	for i = 1, num_3 do
		tbl[tbl_15[i]] = ReadBits(3)
	end

	local var_43_6, var_43_7, var_43_8, var_43_9 = fn_25(tbl, 18, 7)

	if var_43_6 ~= 0 then
		return -4
	end

	local tbl_2 = {}
	local tbl_3 = {}
	local num_4 = 0

	while num_4 < num + num_2 do
		local var_43_13
		local var_43_14
		local var_43_15 = Decode(var_43_7, var_43_8, var_43_9)

		if var_43_15 < 0 then
			return var_43_15
		elseif var_43_15 < 16 then
			if num_4 < num then
				tbl_2[num_4] = var_43_15
			else
				tbl_3[num_4 - num] = var_43_15
			end

			num_4 = num_4 + 1
		else
			local num_5 = 0

			if var_43_15 == 16 then
				if num_4 == 0 then
					return -5
				end

				if num > num_4 - 1 then
					num_5 = tbl_2[num_4 - 1]
				else
					num_5 = tbl_3[num_4 - num - 1]
				end

				var_43_15 = 3 + ReadBits(2)
			elseif var_43_15 == 17 then
				var_43_15 = 3 + ReadBits(3)
			else
				var_43_15 = 11 + ReadBits(7)
			end

			if num_4 + var_43_15 > num + num_2 then
				return -6
			end

			while var_43_15 > 0 do
				var_43_15 = var_43_15 - 1

				if num_4 < num then
					tbl_2[num_4] = num_5
				else
					tbl_3[num_4 - num] = num_5
				end

				num_4 = num_4 + 1
			end
		end
	end

	local var_43_17 = tbl_2[256]

	var_43_17 = var_43_17 or 0

	if var_43_17 == 0 then
		return -9
	end

	local var_43_18, var_43_19, var_43_20, var_43_21 = fn_25(tbl_2, num - 1, 15)

	if var_43_18 ~= 0 then
		if not (var_43_18 < 0) then
			local var_43_22 = var_43_19[0]

			var_43_22 = var_43_22 or 0

			local var_43_23 = var_43_19[1]

			var_43_23 = var_43_23 or 0

			if num ~= var_43_22 + var_43_23 then
				-- Nothing
			end
		end

		return -7
	end

	::label_43_0::

	local var_43_24, var_43_25, var_43_26, var_43_27 = fn_25(tbl_3, num_2 - 1, 15)

	if var_43_24 ~= 0 then
		if not (var_43_24 < 0) then
			local var_43_28 = var_43_25[0]

			var_43_28 = var_43_28 or 0

			local var_43_29 = var_43_25[1]

			var_43_29 = var_43_29 or 0

			if num_2 ~= var_43_28 + var_43_29 then
				-- Nothing
			end
		end

		return -8
	end

	::label_43_1::

	return fn_26(self, var_43_19, var_43_20, var_43_21, var_43_25, var_43_26, var_43_27)
end

local function fn_30(self)
	-- function 44
	local ReadBits = self.ReadBits
	local var_44_1

	while not var_44_1 do
		var_44_1 = ReadBits(1) == 1

		local var_44_2 = ReadBits(2)
		local var_44_3

		if var_44_2 == 0 then
			var_44_3 = fn_27(self)
		elseif var_44_2 == 1 then
			var_44_3 = fn_28(self)
		elseif var_44_2 == 2 then
			var_44_3 = fn_29(self)
		else
			return nil, -1
		end

		if var_44_3 ~= 0 then
			return nil, var_44_3
		end
	end

	self.result_buffer[#self.result_buffer + 1] = concat(self.buffer, "", 1, self.buffer_size)

	return (concat(self.result_buffer))
end

local function fn_31(arg_45_0, arg_45_1)
	-- function 45
	local var_45_0 = fn_24(arg_45_0, arg_45_1)
	local var_45_1, var_45_2 = fn_30(var_45_0)

	if not var_45_1 then
		return nil, var_45_2
	end

	local ReaderBitlenLeft = var_45_0.ReaderBitlenLeft()
	local num = (ReaderBitlenLeft - ReaderBitlenLeft % 8) / 8

	return var_45_1, num
end

tbl.DecompressDeflate = function (arg_46_0, arg_46_1)
	-- function 46
	local var_46_0, var_46_1 = fn_3(arg_46_1)

	if not var_46_0 then
		error("Usage: LibDeflate:DecompressDeflate(str): " .. var_46_1, 2)
	end

	return fn_31(arg_46_1)
end

var_0_32 = {}

for i7 = 0, 143 do
	var_0_32[i7] = 8
end

for i8 = 144, 255 do
	var_0_32[i8] = 9
end

for i9 = 256, 279 do
	var_0_32[i9] = 7
end

for i10 = 280, 287 do
	var_0_32[i10] = 8
end

local tbl_17 = {}

for i11 = 0, 31 do
	tbl_17[i11] = 5
end

local var_0_90
local var_0_91

var_0_91, var_0_33, var_0_31 = fn_25(var_0_32, 287, 9)

assert(var_0_91 == 0)

local var_0_92

var_0_92, var_0_37, var_0_35 = fn_25(tbl_17, 31, 5)

assert(var_0_92 == 0)

var_0_30 = fn_7(var_0_33, var_0_32, 287, 9)
var_0_34 = fn_7(var_0_37, tbl_17, 31, 5)

return tbl
