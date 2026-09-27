-- chunkname: @foundation/scripts/debug/table_trap.lua

local table_trap = table_trap

table_trap = table_trap or {}
table_trap = table_trap

table_trap.print = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	print(table_trap._trap_information(arg_1_0, arg_1_1, arg_1_2))
end

table_trap.callstack = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	print(table_trap._trap_information(arg_2_0, arg_2_1, arg_2_2) .. "\n" .. Script.callstack())
end

table_trap.crash = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	print(table_trap._trap_information(arg_3_0, arg_3_1, arg_3_2))
	error("Table trap crash")
end

table_trap.noop = function ()
	-- function 4
	return
end

table_trap.trap_key = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if arg_5_2 == nil then
		arg_5_2 = table_trap.noop
	end

	if arg_5_3 == nil then
		arg_5_3 = table_trap.noop
	end

	local tbl = {}
	local var_5_1 = getmetatable(self)

	setmetatable(self, nil)

	for k, v in pairs(self) do
		tbl[k] = v
		self[k] = nil
	end

	setmetatable(tbl, var_5_1)

	local tbl_2 = {}

	table_trap._add_forwarding_metafunctions(tbl_2, tbl)

	tbl_2.__index = function (arg_6_0, arg_6_1)
		-- function 6
		local var_6_0 = tbl[arg_6_1]

		if arg_6_1 == arg_5_1 then
			arg_5_2("read", arg_6_1, var_6_0)
		end

		return var_6_0
	end

	tbl_2.__newindex = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if arg_7_1 == arg_5_1 then
			arg_5_3("write", arg_7_1, arg_7_2)
		end

		tbl[arg_7_1] = arg_7_2
	end

	setmetatable(self, tbl_2)
end

table_trap.trap_keys = function (self, arg_8_1, arg_8_2)
	-- function 8
	if arg_8_1 == nil then
		arg_8_1 = table_trap.noop
	end

	if arg_8_2 == nil then
		arg_8_2 = table_trap.noop
	end

	local tbl = {}
	local var_8_1 = getmetatable(self)

	setmetatable(self, nil)

	for k, v in pairs(self) do
		tbl[k] = v
		self[k] = nil
	end

	setmetatable(tbl, var_8_1)

	local tbl_2 = {}

	table_trap._add_forwarding_metafunctions(tbl_2, tbl)

	tbl_2.__index = function (arg_9_0, arg_9_1)
		-- function 9
		local var_9_0 = tbl[arg_9_1]

		arg_8_1("read", arg_9_1, var_9_0)

		return var_9_0
	end

	tbl_2.__newindex = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		arg_8_2("write", arg_10_1, arg_10_2)

		tbl[arg_10_1] = arg_10_2
	end

	setmetatable(self, tbl_2)
end

table_trap._trap_information = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_0 == "read" then
		return string.format("Trap %s '%s':'%s'", arg_11_0, tostring(arg_11_1), tostring(arg_11_2))
	elseif arg_11_0 == "write" then
		return string.format("Trap %s '%s'='%s'", arg_11_0, tostring(arg_11_1), tostring(arg_11_2))
	end
end

table_trap._add_forwarding_metafunctions = function (self, arg_12_1)
	-- function 12
	self.__unm = function (arg_13_0)
		-- function 13
		return -arg_12_1
	end

	self.__add = function (arg_14_0, arg_14_1)
		-- function 14
		local _replace_with_data_if_metatable_matches, var_14_1 = table_trap._replace_with_data_if_metatable_matches(arg_14_0, arg_14_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches + var_14_1
	end

	self.__sub = function (arg_15_0, arg_15_1)
		-- function 15
		local _replace_with_data_if_metatable_matches, var_15_1 = table_trap._replace_with_data_if_metatable_matches(arg_15_0, arg_15_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches - var_15_1
	end

	self.__mul = function (arg_16_0, arg_16_1)
		-- function 16
		local _replace_with_data_if_metatable_matches, var_16_1 = table_trap._replace_with_data_if_metatable_matches(arg_16_0, arg_16_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches * var_16_1
	end

	self.__div = function (arg_17_0, arg_17_1)
		-- function 17
		local _replace_with_data_if_metatable_matches, var_17_1 = table_trap._replace_with_data_if_metatable_matches(arg_17_0, arg_17_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches / var_17_1
	end

	self.__mod = function (arg_18_0, arg_18_1)
		-- function 18
		local _replace_with_data_if_metatable_matches, var_18_1 = table_trap._replace_with_data_if_metatable_matches(arg_18_0, arg_18_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches % var_18_1
	end

	self.__pow = function (arg_19_0, arg_19_1)
		-- function 19
		local _replace_with_data_if_metatable_matches, var_19_1 = table_trap._replace_with_data_if_metatable_matches(arg_19_0, arg_19_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches^var_19_1
	end

	self.__concat = function (arg_20_0, arg_20_1)
		-- function 20
		local _replace_with_data_if_metatable_matches, var_20_1 = table_trap._replace_with_data_if_metatable_matches(arg_20_0, arg_20_1, self, arg_12_1)

		return _replace_with_data_if_metatable_matches .. var_20_1
	end

	self.__eq = function (arg_21_0, arg_21_1)
		-- function 21
		assert(false)
	end

	self.__lt = function (arg_22_0, arg_22_1)
		-- function 22
		assert(false)
	end

	self.__le = function (arg_23_0, arg_23_1)
		-- function 23
		assert(false)
	end

	self.__len = function (arg_24_0)
		-- function 24
		return #arg_12_1
	end

	self.__call = function (arg_25_0, ...)
		-- function 25
		arg_12_1(arg_25_0, ...)
	end

	self.__tostring = function (arg_26_0)
		-- function 26
		return tostring(arg_12_1)
	end
end

table_trap._replace_with_data_if_metatable_matches = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local var_27_0
	local var_27_1

	if getmetatable(arg_27_0) == arg_27_2 then
		var_27_0 = arg_27_3
	else
		var_27_0 = arg_27_0
	end

	if getmetatable(arg_27_1) == arg_27_2 then
		var_27_1 = arg_27_3
	else
		var_27_1 = arg_27_1
	end

	return var_27_0, var_27_1
end
