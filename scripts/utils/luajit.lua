-- chunkname: @scripts/utils/luajit.lua

local var_0_0, var_0_1 = pcall(require, "ffi")
local var_0_2, var_0_3 = pcall(require, "jit.util")

if not (not IS_WINDOWS and not var_0_0 and var_0_2) then
	return
end

local C = var_0_1.C
local bit = bit
local debug = debug
local math = math
local string = string
local pairs = pairs
local tonumber = tonumber
local type = type
local LuaJIT = LuaJIT

LuaJIT = LuaJIT or {}
LuaJIT = LuaJIT

var_0_1.cdef("int QueryPerformanceFrequency(long long*);\nint QueryPerformanceCounter(long long*);\n")

local var_0_13 = var_0_1.new("long long[1]")
local var_0_14 = var_0_1.new("long long[1]")

C.QueryPerformanceFrequency(var_0_13)

LuaJIT.clock = function ()
	-- function 1
	C.QueryPerformanceCounter(var_0_14)

	return var_0_13[0] * var_0_14[0]
end

LuaJIT.clock_diff = function (arg_2_0, arg_2_1)
	-- function 2
	return tonumber(arg_2_0 - arg_2_1)
end

local function fn(arg_3_0, arg_3_1)
	-- function 3
	local match = string.match(string.format("%p", arg_3_1), "0x(%x+)")

	assert(match, "invalid pointer")

	return var_0_1.cast(arg_3_0, tonumber(match, 16))
end

local tbl = {}

LuaJIT.tvalue = function (arg_4_0)
	-- function 4
	tbl[0] = arg_4_0

	local var_4_0 = fn("uint32_t*", tbl)

	return var_0_1.cast("int64_t*", var_4_0[2])[0]
end

local tbl_2 = {
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

LuaJIT.itype = function (arg_5_0)
	-- function 5
	local tvalue = LuaJIT.tvalue(arg_5_0)
	local var_5_1 = tonumber(bit.arshift(tvalue, 32))
	local bnot = bit.bnot(var_5_1)

	if var_5_1 % 4294967296 <= 4294901759 then
		bnot = 13
	elseif bit.arshift(var_5_1, 15) == -2 then
		bnot = 3
	end

	assert(tbl_2[bnot])

	return tbl_2[bnot], bnot
end

LuaJIT.table_size = function (arg_6_0)
	-- function 6
	local var_6_0 = fn("uint32_t*", arg_6_0)

	return var_6_0[6], var_6_0[7]
end

local function fn_2(self, arg_7_1, arg_7_2)
	-- function 7
	arg_7_2 = arg_7_2 or type(arg_7_1)

	if not (arg_7_2 == "nil" or arg_7_2 == "boolean" or arg_7_2 ~= "number") then
		return 0
	elseif not self then
		if not self[arg_7_1] then
			return self[arg_7_1]
		end

		self[arg_7_1] = 0
	end

	if arg_7_2 == "string" then
		if arg_7_1 == "" then
			return 0
		end

		return 17 + #arg_7_1
	elseif arg_7_2 == "table" then
		local table_size, var_7_1 = LuaJIT.table_size(arg_7_1)
		local num = 32 + 8 * table_size + 24 * var_7_1

		if not self then
			for iter_7_0, iter_7_1 in pairs(arg_7_1) do
				num = num + fn_2(self, iter_7_0) + fn_2(self, iter_7_1)
			end
		end

		return num
	elseif arg_7_2 == "function" then
		local funcinfo = var_0_3.funcinfo(arg_7_1)
		local upvalues = funcinfo.upvalues
		local num_2 = 0

		if not funcinfo.addr then
			num_2 = 28 + 8 * math.max(1, upvalues)
		else
			num_2 = 20 + 4 * math.max(1, upvalues)
		end

		if not self then
			num_2 = num_2 + fn_2(self, funcinfo.proto)

			local var_7_6 = fn("uint32_t*", arg_7_1)

			for k = 1, upvalues do
				local var_7_7 = var_7_6[5 + k]
				local getupvalue, var_7_9 = debug.getupvalue(arg_7_1, k)

				num_2 = num_2 + 24 + fn_2(self, var_7_7, "upval") + fn_2(self, var_7_9)
			end
		end

		return num_2
	elseif arg_7_2 == "proto" then
		local var_7_10 = fn("uint32_t*", arg_7_1)[8]

		if not self then
			for l = -var_0_3.funcinfo(arg_7_1).gcconsts, -1 do
				local funck = var_0_3.funck(arg_7_1, l)

				var_7_10 = var_7_10 + fn_2(self, funck)
			end
		end

		return var_7_10
	elseif arg_7_2 == "upval" then
		return 24
	elseif arg_7_2 == "userdata" then
		if LuaJIT.itype(arg_7_1) == "lightud" then
			return 0
		end

		return 16 + fn("uint32_t*", arg_7_1)[-3]
	elseif arg_7_2 == "cdata" then
		return 8
	elseif arg_7_2 == "thread" then
		return 60
	elseif arg_7_2 == "trace" then
		error("NYI: trace")
	end

	error("Unknown type: " .. arg_7_2)
end

LuaJIT.bytes = function (arg_8_0, arg_8_1)
	-- function 8
	return fn_2(not not arg_8_1 or {}, arg_8_0)
end

LuaJIT.bytes_ex = function (arg_9_0, arg_9_1)
	-- function 9
	return fn_2(arg_9_1, arg_9_0)
end
