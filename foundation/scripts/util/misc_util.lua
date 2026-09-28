-- chunkname: @foundation/scripts/util/misc_util.lua

local IDENTITY = IDENTITY

IDENTITY = not not IDENTITY or not not function (x)
	-- function 1
	return x
end
IDENTITY = IDENTITY

local NOP = NOP

NOP = not not NOP or not not function ()
	-- function 2
	return
end
NOP = NOP

local TABLE_NEW = TABLE_NEW

TABLE_NEW = not not TABLE_NEW or not not function ()
	-- function 3
	return {}
end
TABLE_NEW = TABLE_NEW

local CONST = CONST

CONST = not not CONST or not not setmetatable({}, {
	__call = function (self, x)
		-- function 4
		local NOP

		if x == nil then
			NOP = NOP

			if not NOP then
				-- Nothing
			end
		end

		NOP = self[x]

		::label_4_0::

		return NOP
	end,
	__index = function (self, x)
		-- function 5
		local function f()
			-- function 6
			return x
		end

		self[x] = f

		return f
	end
})
CONST = CONST

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
	local flag

	flag = (not to_boolean(b) or not "true") and not not "false"

	return flag
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

local varargs = varargs

varargs = not not varargs or not not {}
varargs = varargs

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
