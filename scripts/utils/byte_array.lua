-- chunkname: @scripts/utils/byte_array.lua

local var_0_0

var_0_0 = {
	write_int32 = function(arg_1_0, arg_1_1, arg_1_2)
		fassert(arg_1_1 <= 2147483647 and arg_1_1 >= -2147483648 and arg_1_1 % 1 == 0, "number %f has to be within the 32bit signed range", arg_1_1)

		arg_1_2 = arg_1_2 or #arg_1_0 + 1
		arg_1_1 = bit.tobit(arg_1_1)

		local var_1_0 = bit.band(arg_1_1, 255)
		local var_1_1 = bit.rshift(bit.band(arg_1_1, 65280), 8)
		local var_1_2 = bit.rshift(bit.band(arg_1_1, 16711680), 16)
		local var_1_3 = bit.rshift(bit.band(arg_1_1, 4278190080), 24)

		arg_1_0[arg_1_2] = var_1_0
		arg_1_2 = arg_1_2 + 1
		arg_1_0[arg_1_2] = var_1_1
		arg_1_2 = arg_1_2 + 1
		arg_1_0[arg_1_2] = var_1_2
		arg_1_2 = arg_1_2 + 1
		arg_1_0[arg_1_2] = var_1_3
		arg_1_2 = arg_1_2 + 1

		return arg_1_0, arg_1_2
	end,
	read_int32 = function(arg_2_0, arg_2_1)
		arg_2_1 = arg_2_1 or 1

		local var_2_0 = arg_2_0[arg_2_1]

		arg_2_1 = arg_2_1 + 1

		local var_2_1 = bit.lshift(arg_2_0[arg_2_1], 8)

		arg_2_1 = arg_2_1 + 1

		local var_2_2 = bit.lshift(arg_2_0[arg_2_1], 16)

		arg_2_1 = arg_2_1 + 1

		local var_2_3 = bit.lshift(arg_2_0[arg_2_1], 24)

		arg_2_1 = arg_2_1 + 1

		return bit.bor(var_2_0, var_2_1, var_2_2, var_2_3), arg_2_1
	end,
	write_uint8 = function(arg_3_0, arg_3_1, arg_3_2)
		fassert(arg_3_1 % 1 == 0, "number %f must be an integer", arg_3_1)
		fassert(arg_3_1 >= 0 and arg_3_1 <= 255, "number %d has to be within the 8bit unsigned range", arg_3_1)

		arg_3_2 = arg_3_2 or #arg_3_0 + 1
		arg_3_0[arg_3_2] = arg_3_1

		return arg_3_0, arg_3_2 + 1
	end,
	read_uint8 = function(arg_4_0, arg_4_1)
		return arg_4_0[arg_4_1 or 1], arg_4_1 + 1
	end,
	pack_uint8 = function(arg_5_0, arg_5_1, arg_5_2)
		arg_5_2 = arg_5_2 or 1
		arg_5_0 = arg_5_0 or 0
		arg_5_0 = bit.bor(arg_5_0, bit.lshift(arg_5_1, (arg_5_2 - 1) * 8))

		return arg_5_0, arg_5_2 + 1
	end,
	unpack_uint8 = function(arg_6_0, arg_6_1)
		arg_6_1 = arg_6_1 or 1

		local var_6_0 = bit.rshift(arg_6_0, (arg_6_1 - 1) * 8)

		return bit.band(var_6_0, 255), arg_6_1 + 1
	end,
	pack_uint16 = function(arg_7_0, arg_7_1, arg_7_2)
		arg_7_2 = arg_7_2 or 1
		arg_7_0 = arg_7_0 or 0
		arg_7_0 = bit.bor(arg_7_0, bit.lshift(arg_7_1, (arg_7_2 - 1) * 16))

		return arg_7_0, arg_7_2 + 1
	end,
	unpack_uint16 = function(arg_8_0, arg_8_1)
		arg_8_1 = arg_8_1 or 1

		fassert(arg_8_1 >= 1 and arg_8_1 <= 2, "unpacking uint16 out of bounds")

		local var_8_0 = bit.rshift(arg_8_0, (arg_8_1 - 1) * 16)

		return bit.band(var_8_0, 65535), arg_8_1 + 1
	end,
	write_uint16 = function(arg_9_0, arg_9_1, arg_9_2)
		fassert(arg_9_1 % 1 == 0, "number %f must be an integer", arg_9_1)
		fassert(arg_9_1 >= 0 and arg_9_1 <= 65535, "number %d has to be within the 8bit unsigned range", arg_9_1)

		arg_9_2 = arg_9_2 or 1
		arg_9_0[arg_9_2] = var_0_0.unpack_uint8(arg_9_1, 1)
		arg_9_2 = arg_9_2 + 1
		arg_9_0[arg_9_2] = var_0_0.unpack_uint8(arg_9_1, 2)
		arg_9_2 = arg_9_2 + 1

		return arg_9_0, arg_9_2
	end,
	read_uint16 = function(arg_10_0, arg_10_1)
		arg_10_1 = arg_10_1 or 1

		local var_10_0 = var_0_0.pack_uint8(0, arg_10_0[arg_10_1], 1)

		arg_10_1 = arg_10_1 + 1

		local var_10_1 = var_0_0.pack_uint8(0, arg_10_0[arg_10_1], 2)

		arg_10_1 = arg_10_1 + 1

		return bit.bor(var_10_0, var_10_1), arg_10_1
	end,
	write_hash = function(arg_11_0, arg_11_1, arg_11_2)
		arg_11_2 = arg_11_2 or #arg_11_0 + 1

		for iter_11_0 = 1, 16, 2 do
			arg_11_0[arg_11_2] = tonumber(arg_11_1:sub(iter_11_0, iter_11_0 + 1), 16)
			arg_11_2 = arg_11_2 + 1
		end

		return arg_11_0, arg_11_2
	end,
	read_hash = function(arg_12_0, arg_12_1)
		return string.format("%02x%02x%02x%02x%02x%02x%02x%02x", arg_12_0[arg_12_1], arg_12_0[arg_12_1 + 1], arg_12_0[arg_12_1 + 2], arg_12_0[arg_12_1 + 3], arg_12_0[arg_12_1 + 4], arg_12_0[arg_12_1 + 5], arg_12_0[arg_12_1 + 6], arg_12_0[arg_12_1 + 7]), arg_12_1 + 8
	end,
	read_string = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		arg_13_1 = arg_13_1 or 1
		arg_13_2 = arg_13_2 or #arg_13_0
		arg_13_3 = arg_13_3 or {}

		for iter_13_0 = arg_13_1, arg_13_2 do
			arg_13_3[iter_13_0] = string.char(arg_13_0[iter_13_0])
		end

		return table.concat(arg_13_3, "", 1, arg_13_2), arg_13_2 + 1
	end,
	write_string = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		arg_14_2 = arg_14_2 or 1
		arg_14_3 = arg_14_3 or 1
		arg_14_4 = arg_14_4 or #arg_14_1

		for iter_14_0 = arg_14_3, arg_14_4 do
			arg_14_0[arg_14_2 + iter_14_0 - 1] = string.byte(arg_14_1, iter_14_0)
		end

		return arg_14_0, arg_14_4 + 1
	end
}

return var_0_0
