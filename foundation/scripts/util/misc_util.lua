-- chunkname: @foundation/scripts/util/misc_util.lua

IDENTITY = IDENTITY or function(arg_1_0)
	return arg_1_0
end
NOP = NOP or function()
	return
end
TABLE_NEW = TABLE_NEW or function()
	return {}
end
CONST = CONST or setmetatable({}, {
	__call = function(arg_4_0, arg_4_1)
		return arg_4_1 == nil and NOP or arg_4_0[arg_4_1]
	end,
	__index = function(arg_5_0, arg_5_1)
		local function var_5_0()
			return arg_5_1
		end

		arg_5_0[arg_5_1] = var_5_0

		return var_5_0
	end
})

local var_0_0 = string.format

function printf(arg_7_0, ...)
	print(var_0_0(arg_7_0, ...))
end

function sprintf(arg_8_0, ...)
	return var_0_0(arg_8_0, ...)
end

function cprint(...)
	print(...)

	if IS_WINDOWS then
		CommandWindow.print(...)
	end
end

function cprintf(arg_10_0, ...)
	local var_10_0 = var_0_0(arg_10_0, ...)

	print(var_10_0)

	if IS_WINDOWS and DEDICATED_SERVER then
		CommandWindow.print(var_10_0)
	end
end

function to_boolean(arg_11_0)
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
	return to_boolean(arg_12_0) and "true" or "false"
end

function vector_string(arg_13_0)
	local var_13_0 = arg_13_0[1]
	local var_13_1 = arg_13_0[2]
	local var_13_2 = arg_13_0[3]

	return string.format("x(%.2f) y(%.2f) z(%.2f)", var_13_0, var_13_1, var_13_2)
end

function T(arg_14_0, arg_14_1)
	if arg_14_0 ~= nil then
		return arg_14_0
	else
		return arg_14_1
	end
end

varargs = varargs or {}

function varargs.to_table(...)
	local var_15_0 = {}
	local var_15_1 = select("#", ...)

	for iter_15_0 = 1, var_15_1 do
		local var_15_2 = select(iter_15_0, ...)

		table.insert(var_15_0, var_15_2)
	end

	return var_15_0, #var_15_0
end

function varargs.join(arg_16_0, ...)
	local var_16_0 = ""
	local var_16_1 = select("#", ...)

	for iter_16_0 = 1, var_16_1 - 1 do
		local var_16_2 = select(iter_16_0, ...)

		var_16_0 = var_16_0 .. tostring(var_16_2) .. arg_16_0
	end

	return var_16_0 .. tostring(select(var_16_1, ...))
end

function split_string(arg_17_0)
	local var_17_0 = {}

	for iter_17_0 in arg_17_0:gmatch("(%S+)") do
		var_17_0[#var_17_0 + 1] = iter_17_0
	end

	return var_17_0
end

function unpack_string(arg_18_0)
	return unpack(split_string(arg_18_0))
end

function ituple(arg_19_0)
	return ituple_iterator, arg_19_0, -1
end

function ituple_iterator(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1 + 2
	local var_20_1 = arg_20_0[var_20_0]

	if var_20_1 == nil then
		return
	end

	return var_20_0, var_20_1, arg_20_0[arg_20_1 + 3]
end
