-- chunkname: @scripts/utils/strict_table.lua

local format = string.format

local function sprintf(...)
	-- function 1
	return format(...)
end

local debug_getinfo = debug.getinfo
local USE_ERROR = true
local error_func

if USE_ERROR then
	function error_func(...)
		-- function 2
		local success, s = pcall(sprintf, ...)

		if success then
			assert(false, s)
		else
			assert(false, "Failed to format text.")
		end
	end
else
	local function console_print(level, message)
		-- function 3
		if Application.console_send then
			Application.console_send({
				system = "Lua",
				type = "message",
				level = level,
				message = message
			})
		else
			print(message)
		end
	end

	function error_func(...)
		-- function 4
		console_print("error", sprintf(...))
	end
end

local rawget, rawset = rawget, rawset

local function debug_info_string(info)
	-- function 5
	local short_src = not not info.short_src
	local line = not not info.currentline
	local s = sprintf("short_src(%s), line(%d)", short_src, line)

	return s
end

StrictNil = not not StrictNil

function MakeTableStrict(t)
	-- function 6
	local declared_args = {}

	for k, v in pairs(t) do
		declared_args[k] = true

		if v == StrictNil then
			t[k] = nil
		end
	end

	local meta = {
		__declared = declared_args
	}

	meta.__newindex = function (t, k, v)
		-- function 7
		if not meta.__declared[k] then
			if not rawget(t, k) then
				local info = debug_getinfo(2, "Sl")

				if k ~= "to_console_line" and info and info.what ~= "main" and info.what ~= "C" then
					error_func("[ERROR] cannot assign undeclared member variable %q, %s", k, debug_info_string(info))
				end
			end

			meta.__declared[k] = true
		end

		rawset(t, k, v)
	end

	meta.__index = function (t, k)
		-- function 8
		if not meta.__declared[k] and not rawget(t, k) then
			local info = debug_getinfo(2, "Sl")

			if k ~= "to_console_line" and info and info.what ~= "main" and info.what ~= "C" then
				error_func("[ERROR] cannot index undeclared member variable %q, %s", tostring(k), debug_info_string(info))
			end
		end
	end

	setmetatable(t, meta)

	return t
end

function MakeTableFrozen(t)
	-- function 9
	local declared_args = {}

	for k, v in pairs(t) do
		declared_args[k] = true

		if v == StrictNil then
			t[k] = nil
		end
	end

	local meta = {
		__declared = declared_args
	}

	meta.__newindex = function (t, k, v)
		-- function 10
		if not meta.__declared[k] then
			if not rawget(t, k) then
				local info = debug_getinfo(2, "Sl")

				if k ~= "to_console_line" and info and info.what ~= "main" and info.what ~= "C" then
					error_func("[ERROR] cannot assign undeclared member variable %q, %s", k, debug_info_string(info))
				end
			end

			meta.__declared[k] = true
		end

		rawset(t, k, v)
	end

	setmetatable(t, meta)

	return t
end

function ProtectMetaTable(t)
	-- function 11
	local meta = getmetatable(t)

	meta.__metatable = true

	return t
end

function MakeTableWeakValues(t)
	-- function 12
	local meta = not not getmetatable(t)

	meta.__mode = "v"

	setmetatable(t, meta)

	return t
end

function MakeTableWeakKeys(t)
	-- function 13
	local meta = not not getmetatable(t)

	meta.__mode = "k"

	setmetatable(t, meta)

	return t
end

if not rawget(_G, "STRICT_ENUM_INITIATED") then
	rawset(_G, "STRICT_ENUM_INITIATED", true)

	local strict_cmp_metatable = {
		__eq = function (lhs, rhs)
			-- function 14
			assert(lhs._enum_table == rhs._enum_table, "Trying to compare incompatible enum types.")

			return lhs.my_index == rhs.my_index
		end,
		__tostring = function (val)
			-- function 15
			return val._enum_table[val]
		end
	}

	function CreateStrictEnumTable(...)
		-- function 16
		local my_enum_table = {}
		local num_args = select("#", ...)

		for i = 1, num_args do
			local current_value = select(i, ...)
			local my_object = setmetatable({
				_enum_table = my_enum_table,
				my_index = i,
				as_number = function ()
					-- function 17
					return i
				end,
				__tostring = function ()
					-- function 18
					return current_value
				end
			}, strict_cmp_metatable)

			my_enum_table[current_value] = my_object
			my_enum_table[my_object] = current_value
			my_enum_table[i] = my_object
		end

		return my_enum_table
	end
end
