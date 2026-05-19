-- chunkname: @scripts/utils/luajit.lua

local var_0_0, var_0_1 = pcall(require, "ffi")
local var_0_2, var_0_3 = pcall(require, "jit.util")

if not IS_WINDOWS or not var_0_0 or not var_0_2 then
	return
end

local var_0_4 = var_0_1.C
local var_0_5 = bit
local var_0_6 = debug
local var_0_7 = math
local var_0_8 = string
local var_0_9 = pairs
local var_0_10 = tonumber
local var_0_11 = type

LuaJIT = LuaJIT or {}

var_0_1.cdef("int QueryPerformanceFrequency(long long*);\nint QueryPerformanceCounter(long long*);\n")

local var_0_12 = var_0_1.new("long long[1]")
local var_0_13 = var_0_1.new("long long[1]")

var_0_4.QueryPerformanceFrequency(var_0_12)

function LuaJIT.clock()
	var_0_4.QueryPerformanceCounter(var_0_13)

	return var_0_12[0] * var_0_13[0]
end

function LuaJIT.clock_diff(arg_2_0, arg_2_1)
	return var_0_10(arg_2_0 - arg_2_1)
end

local function var_0_14(arg_3_0, arg_3_1)
	local var_3_0 = var_0_8.match(var_0_8.format("%p", arg_3_1), "0x(%x+)")

	assert(var_3_0, "invalid pointer")

	return var_0_1.cast(arg_3_0, var_0_10(var_3_0, 16))
end

local var_0_15 = {}

function LuaJIT.tvalue(arg_4_0)
	var_0_15[0] = arg_4_0

	local var_4_0 = var_0_14("uint32_t*", var_0_15)

	return var_0_1.cast("int64_t*", var_4_0[2])[0]
end

local var_0_16 = {
	[0] = "nil",
	"false",
	"true",
	"lightud",
	"str",
	"upval",
	"thread",
	"proto",
	"func",
	"trace",
	"cdata",
	"tab",
	"udata",
	"numx"
}

function LuaJIT.itype(arg_5_0)
	local var_5_0 = LuaJIT.tvalue(arg_5_0)
	local var_5_1 = var_0_10(var_0_5.arshift(var_5_0, 32))
	local var_5_2 = var_0_5.bnot(var_5_1)

	if var_5_1 % 4294967296 <= 4294901759 then
		var_5_2 = 13
	elseif var_0_5.arshift(var_5_1, 15) == -2 then
		var_5_2 = 3
	end

	assert(var_0_16[var_5_2])

	return var_0_16[var_5_2], var_5_2
end

function LuaJIT.table_size(arg_6_0)
	local var_6_0 = var_0_14("uint32_t*", arg_6_0)

	return var_6_0[6], var_6_0[7]
end

local function var_0_17(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or var_0_11(arg_7_1)

	if arg_7_2 == "nil" or arg_7_2 == "boolean" or arg_7_2 == "number" then
		return 0
	elseif arg_7_0 then
		if arg_7_0[arg_7_1] then
			return arg_7_0[arg_7_1]
		end

		arg_7_0[arg_7_1] = 0
	end

	if arg_7_2 == "string" then
		if arg_7_1 == "" then
			return 0
		end

		return 17 + #arg_7_1
	elseif arg_7_2 == "table" then
		local var_7_0, var_7_1 = LuaJIT.table_size(arg_7_1)
		local var_7_2 = 32 + 8 * var_7_0 + 24 * var_7_1

		if arg_7_0 then
			for iter_7_0, iter_7_1 in var_0_9(arg_7_1) do
				var_7_2 = var_7_2 + var_0_17(arg_7_0, iter_7_0) + var_0_17(arg_7_0, iter_7_1)
			end
		end

		return var_7_2
	elseif arg_7_2 == "function" then
		local var_7_3 = var_0_3.funcinfo(arg_7_1)
		local var_7_4 = var_7_3.upvalues
		local var_7_5 = 0

		if var_7_3.addr then
			var_7_5 = 28 + 8 * var_0_7.max(1, var_7_4)
		else
			var_7_5 = 20 + 4 * var_0_7.max(1, var_7_4)
		end

		if arg_7_0 then
			var_7_5 = var_7_5 + var_0_17(arg_7_0, var_7_3.proto)

			local var_7_6 = var_0_14("uint32_t*", arg_7_1)

			for iter_7_2 = 1, var_7_4 do
				local var_7_7 = var_7_6[5 + iter_7_2]
				local var_7_8, var_7_9 = var_0_6.getupvalue(arg_7_1, iter_7_2)

				var_7_5 = var_7_5 + 24 + var_0_17(arg_7_0, var_7_7, "upval") + var_0_17(arg_7_0, var_7_9)
			end
		end

		return var_7_5
	elseif arg_7_2 == "proto" then
		local var_7_10 = var_0_14("uint32_t*", arg_7_1)[8]

		if arg_7_0 then
			for iter_7_3 = -var_0_3.funcinfo(arg_7_1).gcconsts, -1 do
				local var_7_11 = var_0_3.funck(arg_7_1, iter_7_3)

				var_7_10 = var_7_10 + var_0_17(arg_7_0, var_7_11)
			end
		end

		return var_7_10
	elseif arg_7_2 == "upval" then
		return 24
	elseif arg_7_2 == "userdata" then
		if LuaJIT.itype(arg_7_1) == "lightud" then
			return 0
		end

		return 16 + var_0_14("uint32_t*", arg_7_1)[-3]
	elseif arg_7_2 == "cdata" then
		return 8
	elseif arg_7_2 == "thread" then
		return 60
	elseif arg_7_2 == "trace" then
		error("NYI: trace")
	end

	error("Unknown type: " .. arg_7_2)
end

function LuaJIT.bytes(arg_8_0, arg_8_1)
	return var_0_17(not arg_8_1 and {}, arg_8_0)
end

function LuaJIT.bytes_ex(arg_9_0, arg_9_1)
	return var_0_17(arg_9_1, arg_9_0)
end
