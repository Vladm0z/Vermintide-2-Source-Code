-- chunkname: @foundation/scripts/debug/table_trap.lua

table_trap = table_trap or {}

function table_trap.print(arg_1_0, arg_1_1, arg_1_2)
	print(table_trap._trap_information(arg_1_0, arg_1_1, arg_1_2))
end

function table_trap.callstack(arg_2_0, arg_2_1, arg_2_2)
	print(table_trap._trap_information(arg_2_0, arg_2_1, arg_2_2) .. "\n" .. Script.callstack())
end

function table_trap.crash(arg_3_0, arg_3_1, arg_3_2)
	print(table_trap._trap_information(arg_3_0, arg_3_1, arg_3_2))
	error("Table trap crash")
end

function table_trap.noop()
	return
end

function table_trap.trap_key(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_2 == nil then
		arg_5_2 = table_trap.noop
	end

	if arg_5_3 == nil then
		arg_5_3 = table_trap.noop
	end

	local var_5_0 = {}
	local var_5_1 = getmetatable(arg_5_0)

	setmetatable(arg_5_0, nil)

	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		var_5_0[iter_5_0] = iter_5_1
		arg_5_0[iter_5_0] = nil
	end

	setmetatable(var_5_0, var_5_1)

	local var_5_2 = {}

	table_trap._add_forwarding_metafunctions(var_5_2, var_5_0)

	function var_5_2.__index(arg_6_0, arg_6_1)
		local var_6_0 = var_5_0[arg_6_1]

		if arg_6_1 == arg_5_1 then
			arg_5_2("read", arg_6_1, var_6_0)
		end

		return var_6_0
	end

	function var_5_2.__newindex(arg_7_0, arg_7_1, arg_7_2)
		if arg_7_1 == arg_5_1 then
			arg_5_3("write", arg_7_1, arg_7_2)
		end

		var_5_0[arg_7_1] = arg_7_2
	end

	setmetatable(arg_5_0, var_5_2)
end

function table_trap.trap_keys(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == nil then
		arg_8_1 = table_trap.noop
	end

	if arg_8_2 == nil then
		arg_8_2 = table_trap.noop
	end

	local var_8_0 = {}
	local var_8_1 = getmetatable(arg_8_0)

	setmetatable(arg_8_0, nil)

	for iter_8_0, iter_8_1 in pairs(arg_8_0) do
		var_8_0[iter_8_0] = iter_8_1
		arg_8_0[iter_8_0] = nil
	end

	setmetatable(var_8_0, var_8_1)

	local var_8_2 = {}

	table_trap._add_forwarding_metafunctions(var_8_2, var_8_0)

	function var_8_2.__index(arg_9_0, arg_9_1)
		local var_9_0 = var_8_0[arg_9_1]

		arg_8_1("read", arg_9_1, var_9_0)

		return var_9_0
	end

	function var_8_2.__newindex(arg_10_0, arg_10_1, arg_10_2)
		arg_8_2("write", arg_10_1, arg_10_2)

		var_8_0[arg_10_1] = arg_10_2
	end

	setmetatable(arg_8_0, var_8_2)
end

function table_trap._trap_information(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0 == "read" then
		return string.format("Trap %s '%s':'%s'", arg_11_0, tostring(arg_11_1), tostring(arg_11_2))
	elseif arg_11_0 == "write" then
		return string.format("Trap %s '%s'='%s'", arg_11_0, tostring(arg_11_1), tostring(arg_11_2))
	end
end

function table_trap._add_forwarding_metafunctions(arg_12_0, arg_12_1)
	function arg_12_0.__unm(arg_13_0)
		return -arg_12_1
	end

	function arg_12_0.__add(arg_14_0, arg_14_1)
		local var_14_0, var_14_1 = table_trap._replace_with_data_if_metatable_matches(arg_14_0, arg_14_1, arg_12_0, arg_12_1)

		return var_14_0 + var_14_1
	end

	function arg_12_0.__sub(arg_15_0, arg_15_1)
		local var_15_0, var_15_1 = table_trap._replace_with_data_if_metatable_matches(arg_15_0, arg_15_1, arg_12_0, arg_12_1)

		return var_15_0 - var_15_1
	end

	function arg_12_0.__mul(arg_16_0, arg_16_1)
		local var_16_0, var_16_1 = table_trap._replace_with_data_if_metatable_matches(arg_16_0, arg_16_1, arg_12_0, arg_12_1)

		return var_16_0 * var_16_1
	end

	function arg_12_0.__div(arg_17_0, arg_17_1)
		local var_17_0, var_17_1 = table_trap._replace_with_data_if_metatable_matches(arg_17_0, arg_17_1, arg_12_0, arg_12_1)

		return var_17_0 / var_17_1
	end

	function arg_12_0.__mod(arg_18_0, arg_18_1)
		local var_18_0, var_18_1 = table_trap._replace_with_data_if_metatable_matches(arg_18_0, arg_18_1, arg_12_0, arg_12_1)

		return var_18_0 % var_18_1
	end

	function arg_12_0.__pow(arg_19_0, arg_19_1)
		local var_19_0, var_19_1 = table_trap._replace_with_data_if_metatable_matches(arg_19_0, arg_19_1, arg_12_0, arg_12_1)

		return var_19_0^var_19_1
	end

	function arg_12_0.__concat(arg_20_0, arg_20_1)
		local var_20_0, var_20_1 = table_trap._replace_with_data_if_metatable_matches(arg_20_0, arg_20_1, arg_12_0, arg_12_1)

		return var_20_0 .. var_20_1
	end

	function arg_12_0.__eq(arg_21_0, arg_21_1)
		assert(false)
	end

	function arg_12_0.__lt(arg_22_0, arg_22_1)
		assert(false)
	end

	function arg_12_0.__le(arg_23_0, arg_23_1)
		assert(false)
	end

	function arg_12_0.__len(arg_24_0)
		return #arg_12_1
	end

	function arg_12_0.__call(arg_25_0, ...)
		arg_12_1(arg_25_0, ...)
	end

	function arg_12_0.__tostring(arg_26_0)
		return tostring(arg_12_1)
	end
end

function table_trap._replace_with_data_if_metatable_matches(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
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
