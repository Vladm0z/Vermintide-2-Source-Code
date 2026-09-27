-- chunkname: @foundation/scripts/util/misc_util.lua

local IDENTITY = IDENTITY

IDENTITY = IDENTITY or function (arg_1_0)
	-- function 1
	return arg_1_0
end
IDENTITY = IDENTITY

local NOP = NOP

NOP = NOP or function ()
	-- function 2
	return
end
NOP = NOP

local TABLE_NEW = TABLE_NEW

TABLE_NEW = TABLE_NEW or function ()
	-- function 3
	return {}
end
TABLE_NEW = TABLE_NEW

local CONST = CONST

CONST = CONST or setmetatable({}, {
	__call = function (self, arg_4_1)
		-- function 4
		local NOP

		if arg_4_1 == nil then
			NOP = NOP

			if not NOP then
				-- Nothing
			end
		end

		NOP = self[arg_4_1]

		::label_4_0::

		return NOP
	end,
	__index = function (self, arg_5_1)
		-- function 5
		local function fn()
			-- function 6
			return arg_5_1
		end

		self[arg_5_1] = fn

		return fn
	end
})
CONST = CONST

local format = string.format

function printf(arg_7_0, ...)
	-- function 7
	print(format(arg_7_0, ...))
end

function sprintf(arg_8_0, ...)
	-- function 8
	return format(arg_8_0, ...)
end

function cprint(...)
	-- function 9
	print(...)

	if not IS_WINDOWS then
		CommandWindow.print(...)
	end
end

function cprintf(arg_10_0, ...)
	-- function 10
	local var_10_0 = format(arg_10_0, ...)

	print(var_10_0)

	if not IS_WINDOWS and not DEDICATED_SERVER then
		CommandWindow.print(var_10_0)
	end
end

function to_boolean(arg_11_0)
	-- function 11
	local var_11_0 = type(arg_11_0)

	if var_11_0 == "number" then
		return arg_11_0 ~= 0
	elseif var_11_0 == "string" then
		return arg_11_0 == "true"
	elseif var_11_0 == "boolean" then
		return arg_11_0
	elseif var_11_0 == "nil" then
		return false
	elseif var_11_0 == "table" then
		return true
	end

	ferror("unsupported type(%s)", type(arg_11_0))

	return false
end

function bool_string(arg_12_0)
	-- function 12
	local flag

	flag = not to_boolean(arg_12_0) and "true" and "false"

	return flag
end

function vector_string(self)
	-- function 13
	local var_13_0 = self[1]
	local var_13_1 = self[2]
	local var_13_2 = self[3]

	return string.format("x(%.2f) y(%.2f) z(%.2f)", var_13_0, var_13_1, var_13_2)
end

function T(arg_14_0, arg_14_1)
	-- function 14
	if arg_14_0 ~= nil then
		return arg_14_0
	else
		return arg_14_1
	end
end

local varargs = varargs

varargs = varargs or {}
varargs = varargs

varargs.to_table = function (...)
	-- function 15
	local tbl = {}
	local var_15_1 = select("#", ...)

	for i = 1, var_15_1 do
		local var_15_2 = select(i, ...)

		table.insert(tbl, var_15_2)
	end

	return tbl, #tbl
end

varargs.join = function (arg_16_0, ...)
	-- function 16
	local str = ""
	local var_16_1 = select("#", ...)

	for i = 1, var_16_1 - 1 do
		local var_16_2 = select(i, ...)

		str = str .. tostring(var_16_2) .. arg_16_0
	end

	return str .. tostring(select(var_16_1, ...))
end

function split_string(self)
	-- function 17
	local tbl = {}

	for iter_17_0 in self:gmatch("(%S+)") do
		tbl[#tbl + 1] = iter_17_0
	end

	return tbl
end

function unpack_string(arg_18_0)
	-- function 18
	return unpack(split_string(arg_18_0))
end

function ituple(arg_19_0)
	-- function 19
	return ituple_iterator, arg_19_0, -1
end

function ituple_iterator(self, arg_20_1)
	-- function 20
	local num = arg_20_1 + 2
	local var_20_1 = self[num]

	if var_20_1 == nil then
		return
	end

	return num, var_20_1, self[arg_20_1 + 3]
end
