-- chunkname: @scripts/utils/byte_array.lua

local var_0_0

var_0_0 = {
	write_int32 = function (self, arg_1_1, arg_1_2)
		-- function 1
		fassert(not (arg_1_1 <= 2147483647) or not (arg_1_1 >= -2147483648) or arg_1_1 % 1 == 0, "number %f has to be within the 32bit signed range", arg_1_1)

		arg_1_2 = arg_1_2 or #self + 1
		arg_1_1 = bit.tobit(arg_1_1)

		local band = bit.band(arg_1_1, 255)
		local rshift = bit.rshift(bit.band(arg_1_1, 65280), 8)
		local rshift_2 = bit.rshift(bit.band(arg_1_1, 16711680), 16)
		local rshift_3 = bit.rshift(bit.band(arg_1_1, 4278190080), 24)

		self[arg_1_2] = band
		arg_1_2 = arg_1_2 + 1
		self[arg_1_2] = rshift
		arg_1_2 = arg_1_2 + 1
		self[arg_1_2] = rshift_2
		arg_1_2 = arg_1_2 + 1
		self[arg_1_2] = rshift_3
		arg_1_2 = arg_1_2 + 1

		return self, arg_1_2
	end,
	read_int32 = function (self, arg_2_1)
		-- function 2
		arg_2_1 = arg_2_1 or 1

		local var_2_0 = self[arg_2_1]

		arg_2_1 = arg_2_1 + 1

		local lshift = bit.lshift(self[arg_2_1], 8)

		arg_2_1 = arg_2_1 + 1

		local lshift_2 = bit.lshift(self[arg_2_1], 16)

		arg_2_1 = arg_2_1 + 1

		local lshift_3 = bit.lshift(self[arg_2_1], 24)

		arg_2_1 = arg_2_1 + 1

		return bit.bor(var_2_0, lshift, lshift_2, lshift_3), arg_2_1
	end,
	write_uint8 = function (self, arg_3_1, arg_3_2)
		-- function 3
		fassert(arg_3_1 % 1 == 0, "number %f must be an integer", arg_3_1)
		fassert(not (arg_3_1 >= 0) or arg_3_1 <= 255, "number %d has to be within the 8bit unsigned range", arg_3_1)

		arg_3_2 = arg_3_2 or #self + 1
		self[arg_3_2] = arg_3_1

		return self, arg_3_2 + 1
	end,
	read_uint8 = function (self, arg_4_1)
		-- function 4
		return self[arg_4_1 or 1], arg_4_1 + 1
	end,
	pack_uint8 = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		arg_5_2 = arg_5_2 or 1
		arg_5_0 = arg_5_0 or 0
		arg_5_0 = bit.bor(arg_5_0, bit.lshift(arg_5_1, (arg_5_2 - 1) * 8))

		return arg_5_0, arg_5_2 + 1
	end,
	unpack_uint8 = function (arg_6_0, arg_6_1)
		-- function 6
		arg_6_1 = arg_6_1 or 1

		local rshift = bit.rshift(arg_6_0, (arg_6_1 - 1) * 8)

		return bit.band(rshift, 255), arg_6_1 + 1
	end,
	pack_uint16 = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		arg_7_2 = arg_7_2 or 1
		arg_7_0 = arg_7_0 or 0
		arg_7_0 = bit.bor(arg_7_0, bit.lshift(arg_7_1, (arg_7_2 - 1) * 16))

		return arg_7_0, arg_7_2 + 1
	end,
	unpack_uint16 = function (arg_8_0, arg_8_1)
		-- function 8
		arg_8_1 = arg_8_1 or 1

		fassert(not (arg_8_1 >= 1) or arg_8_1 <= 2, "unpacking uint16 out of bounds")

		local rshift = bit.rshift(arg_8_0, (arg_8_1 - 1) * 16)

		return bit.band(rshift, 65535), arg_8_1 + 1
	end,
	write_uint16 = function (self, arg_9_1, arg_9_2)
		-- function 9
		fassert(arg_9_1 % 1 == 0, "number %f must be an integer", arg_9_1)
		fassert(not (arg_9_1 >= 0) or arg_9_1 <= 65535, "number %d has to be within the 8bit unsigned range", arg_9_1)

		arg_9_2 = arg_9_2 or 1
		self[arg_9_2] = var_0_0.unpack_uint8(arg_9_1, 1)
		arg_9_2 = arg_9_2 + 1
		self[arg_9_2] = var_0_0.unpack_uint8(arg_9_1, 2)
		arg_9_2 = arg_9_2 + 1

		return self, arg_9_2
	end,
	read_uint16 = function (self, arg_10_1)
		-- function 10
		arg_10_1 = arg_10_1 or 1

		local pack_uint8 = var_0_0.pack_uint8(0, self[arg_10_1], 1)

		arg_10_1 = arg_10_1 + 1

		local pack_uint8_2 = var_0_0.pack_uint8(0, self[arg_10_1], 2)

		arg_10_1 = arg_10_1 + 1

		return bit.bor(pack_uint8, pack_uint8_2), arg_10_1
	end,
	write_hash = function (self, arg_11_1, arg_11_2)
		-- function 11
		arg_11_2 = arg_11_2 or #self + 1

		for i = 1, 16, 2 do
			self[arg_11_2] = tonumber(arg_11_1:sub(i, i + 1), 16)
			arg_11_2 = arg_11_2 + 1
		end

		return self, arg_11_2
	end,
	read_hash = function (self, arg_12_1)
		-- function 12
		return string.format("%02x%02x%02x%02x%02x%02x%02x%02x", self[arg_12_1], self[arg_12_1 + 1], self[arg_12_1 + 2], self[arg_12_1 + 3], self[arg_12_1 + 4], self[arg_12_1 + 5], self[arg_12_1 + 6], self[arg_12_1 + 7]), arg_12_1 + 8
	end,
	read_string = function (self, arg_13_1, arg_13_2, arg_13_3)
		-- function 13
		arg_13_1 = arg_13_1 or 1
		arg_13_2 = arg_13_2 or #self
		arg_13_3 = arg_13_3 or {}

		for i = arg_13_1, arg_13_2 do
			arg_13_3[i] = string.char(self[i])
		end

		return table.concat(arg_13_3, "", 1, arg_13_2), arg_13_2 + 1
	end,
	write_string = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		arg_14_2 = arg_14_2 or 1
		arg_14_3 = arg_14_3 or 1
		arg_14_4 = arg_14_4 or #arg_14_1

		for i = arg_14_3, arg_14_4 do
			self[arg_14_2 + i - 1] = string.byte(arg_14_1, i)
		end

		return self, arg_14_4 + 1
	end
}

return var_0_0
