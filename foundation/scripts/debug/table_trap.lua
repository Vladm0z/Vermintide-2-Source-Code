-- chunkname: @foundation/scripts/debug/table_trap.lua

table_trap = not not table_trap

table_trap.print = function (operation, key, value)
	-- function 1
	print(table_trap._trap_information(operation, key, value))
end

table_trap.callstack = function (operation, key, value)
	-- function 2
	print(table_trap._trap_information(operation, key, value) .. "\n" .. Script.callstack())
end

table_trap.crash = function (operation, key, value)
	-- function 3
	print(table_trap._trap_information(operation, key, value))
	error("Table trap crash")
end

table_trap.noop = function ()
	-- function 4
	return
end

table_trap.trap_key = function (table_to_debug, key_to_inspect, read_func, write_func)
	-- function 5
	if read_func == nil then
		read_func = table_trap.noop
	end

	if write_func == nil then
		write_func = table_trap.noop
	end

	local data_table = {}
	local old_metatable = getmetatable(table_to_debug)

	setmetatable(table_to_debug, nil)

	for k, v in pairs(table_to_debug) do
		data_table[k] = v
		table_to_debug[k] = nil
	end

	setmetatable(data_table, old_metatable)

	local new_metatable = {}

	table_trap._add_forwarding_metafunctions(new_metatable, data_table)

	new_metatable.__index = function (t, key)
		-- function 6
		local value = data_table[key]

		if key == key_to_inspect then
			read_func("read", key, value)
		end

		return value
	end

	new_metatable.__newindex = function (t, key, value)
		-- function 7
		if key == key_to_inspect then
			write_func("write", key, value)
		end

		data_table[key] = value
	end

	setmetatable(table_to_debug, new_metatable)
end

table_trap.trap_keys = function (table_to_debug, read_func, write_func)
	-- function 8
	if read_func == nil then
		read_func = table_trap.noop
	end

	if write_func == nil then
		write_func = table_trap.noop
	end

	local data_table = {}
	local old_metatable = getmetatable(table_to_debug)

	setmetatable(table_to_debug, nil)

	for k, v in pairs(table_to_debug) do
		data_table[k] = v
		table_to_debug[k] = nil
	end

	setmetatable(data_table, old_metatable)

	local new_metatable = {}

	table_trap._add_forwarding_metafunctions(new_metatable, data_table)

	new_metatable.__index = function (t, key)
		-- function 9
		local value = data_table[key]

		read_func("read", key, value)

		return value
	end

	new_metatable.__newindex = function (t, key, value)
		-- function 10
		write_func("write", key, value)

		data_table[key] = value
	end

	setmetatable(table_to_debug, new_metatable)
end

table_trap._trap_information = function (operation, key, value)
	-- function 11
	if operation == "read" then
		return string.format("Trap %s '%s':'%s'", operation, tostring(key), tostring(value))
	elseif operation == "write" then
		return string.format("Trap %s '%s'='%s'", operation, tostring(key), tostring(value))
	end
end

table_trap._add_forwarding_metafunctions = function (metatable, data_table)
	-- function 12
	metatable.__unm = function (t)
		-- function 13
		return -data_table
	end

	metatable.__add = function (lhs, rhs)
		-- function 14
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a + b
	end

	metatable.__sub = function (lhs, rhs)
		-- function 15
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a - b
	end

	metatable.__mul = function (lhs, rhs)
		-- function 16
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a * b
	end

	metatable.__div = function (lhs, rhs)
		-- function 17
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a / b
	end

	metatable.__mod = function (lhs, rhs)
		-- function 18
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a % b
	end

	metatable.__pow = function (lhs, rhs)
		-- function 19
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a^b
	end

	metatable.__concat = function (lhs, rhs)
		-- function 20
		local a, b = table_trap._replace_with_data_if_metatable_matches(lhs, rhs, metatable, data_table)

		return a .. b
	end

	metatable.__eq = function (lhs, rhs)
		-- function 21
		assert(false)
	end

	metatable.__lt = function (lhs, rhs)
		-- function 22
		assert(false)
	end

	metatable.__le = function (lhs, rhs)
		-- function 23
		assert(false)
	end

	metatable.__len = function (t)
		-- function 24
		return #data_table
	end

	metatable.__call = function (f, ...)
		-- function 25
		data_table(f, ...)
	end

	metatable.__tostring = function (s)
		-- function 26
		return tostring(data_table)
	end
end

table_trap._replace_with_data_if_metatable_matches = function (lhs, rhs, metatable, data)
	-- function 27
	local redir_lhs, redir_rhs

	if getmetatable(lhs) == metatable then
		redir_lhs = data
	else
		redir_lhs = lhs
	end

	if getmetatable(rhs) == metatable then
		redir_rhs = data
	else
		redir_rhs = rhs
	end

	return redir_lhs, redir_rhs
end
