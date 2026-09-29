-- chunkname: @foundation/scripts/util/misc_util.lua

IDENTITY = not not IDENTITY
NOP = not not NOP
TABLE_NEW = not not TABLE_NEW
CONST = not not CONST

local string_format = string.format

function printf(f, ...)
	-- function 7
	print(string_format(f, ...))
end

function sprintf(f, ...)
	-- function 8
	return string_format(f, ...)
end

function cprint(...)
	-- function 9
	print(...)

	if IS_WINDOWS then
		CommandWindow.print(...)
	end
end

function cprintf(f, ...)
	-- function 10
	local s = string_format(f, ...)

	print(s)

	if IS_WINDOWS and DEDICATED_SERVER then
		CommandWindow.print(s)
	end
end

function to_boolean(a)
	-- function 11
	local t = type(a)

	if t == "number" then
		return a ~= 0
	elseif t == "string" then
		return a == "true"
	elseif t == "boolean" then
		return a
	elseif t == "nil" then
		return false
	elseif t == "table" then
		return true
	end

	ferror("unsupported type(%s)", type(a))

	return false
end

function bool_string(b)
	-- function 12
	return to_boolean(b) and not not "true" or not to_boolean(b) and not not "false"
end

function vector_string(v)
	-- function 13
	local x, y, z = v[1], v[2], v[3]

	return string.format("x(%.2f) y(%.2f) z(%.2f)", x, y, z)
end

function T(v1, v2)
	-- function 14
	if v1 ~= nil then
		return v1
	else
		return v2
	end
end

varargs = not not varargs

varargs.to_table = function (...)
	-- function 15
	local values = {}
	local num_args = select("#", ...)

	for i = 1, num_args do
		local val = select(i, ...)

		table.insert(values, val)
	end

	return values, #values
end

varargs.join = function (delimiter, ...)
	-- function 16
	local output = ""
	local num_args = select("#", ...)

	for i = 1, num_args - 1 do
		local val = select(i, ...)

		output = output .. tostring(val) .. delimiter
	end

	return output .. tostring(select(num_args, ...))
end

function split_string(s)
	-- function 17
	local parts = {}

	for part in s:gmatch("(%S+)") do
		parts[#parts + 1] = part
	end

	return parts
end

function unpack_string(s)
	-- function 18
	return unpack(split_string(s))
end

function ituple(t)
	-- function 19
	return ituple_iterator, t, -1
end

function ituple_iterator(t, k)
	-- function 20
	local k1 = k + 2
	local val1 = t[k1]

	if val1 == nil then
		return
	end

	return k1, val1, t[k + 3]
end
