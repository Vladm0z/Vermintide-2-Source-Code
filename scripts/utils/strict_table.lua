-- chunkname: @scripts/utils/strict_table.lua

local var_0_0 = string.format

local function var_0_1(...)
	return var_0_0(...)
end

local var_0_2 = debug.getinfo
local var_0_3 = true
local var_0_4

if var_0_3 then
	function var_0_4(...)
		local var_2_0, var_2_1 = pcall(var_0_1, ...)

		if var_2_0 then
			assert(false, var_2_1)
		else
			assert(false, "Failed to format text.")
		end
	end
else
	local function var_0_5(arg_3_0, arg_3_1)
		if Application.console_send then
			Application.console_send({
				system = "Lua",
				type = "message",
				level = arg_3_0,
				message = arg_3_1
			})
		else
			print(arg_3_1)
		end
	end

	function var_0_4(...)
		var_0_5("error", var_0_1(...))
	end
end

local var_0_6 = rawget
local var_0_7 = rawset

local function var_0_8(arg_5_0)
	local var_5_0 = arg_5_0.short_src or ""
	local var_5_1 = arg_5_0.currentline or -1

	return (var_0_1("short_src(%s), line(%d)", var_5_0, var_5_1))
end

StrictNil = StrictNil or {}

function MakeTableStrict(arg_6_0)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		var_6_0[iter_6_0] = true

		if iter_6_1 == StrictNil then
			arg_6_0[iter_6_0] = nil
		end
	end

	local var_6_1 = {
		__declared = var_6_0
	}

	var_6_1.__newindex = function (arg_7_0, arg_7_1, arg_7_2)
		if not var_6_1.__declared[arg_7_1] then
			if not var_0_6(arg_7_0, arg_7_1) then
				local var_7_0 = var_0_2(2, "Sl")

				if arg_7_1 ~= "to_console_line" and var_7_0 and var_7_0.what ~= "main" and var_7_0.what ~= "C" then
					var_0_4("[ERROR] cannot assign undeclared member variable %q, %s", arg_7_1, var_0_8(var_7_0))
				end
			end

			var_6_1.__declared[arg_7_1] = true
		end

		var_0_7(arg_7_0, arg_7_1, arg_7_2)
	end

	var_6_1.__index = function (arg_8_0, arg_8_1)
		if not var_6_1.__declared[arg_8_1] and not var_0_6(arg_8_0, arg_8_1) then
			local var_8_0 = var_0_2(2, "Sl")

			if arg_8_1 ~= "to_console_line" and var_8_0 and var_8_0.what ~= "main" and var_8_0.what ~= "C" then
				var_0_4("[ERROR] cannot index undeclared member variable %q, %s", tostring(arg_8_1), var_0_8(var_8_0))
			end
		end
	end

	setmetatable(arg_6_0, var_6_1)

	return arg_6_0
end

function MakeTableFrozen(arg_9_0)
	local var_9_0 = {}

	for iter_9_0, iter_9_1 in pairs(arg_9_0) do
		var_9_0[iter_9_0] = true

		if iter_9_1 == StrictNil then
			arg_9_0[iter_9_0] = nil
		end
	end

	local var_9_1 = {
		__declared = var_9_0
	}

	var_9_1.__newindex = function (arg_10_0, arg_10_1, arg_10_2)
		if not var_9_1.__declared[arg_10_1] then
			if not var_0_6(arg_10_0, arg_10_1) then
				local var_10_0 = var_0_2(2, "Sl")

				if arg_10_1 ~= "to_console_line" and var_10_0 and var_10_0.what ~= "main" and var_10_0.what ~= "C" then
					var_0_4("[ERROR] cannot assign undeclared member variable %q, %s", arg_10_1, var_0_8(var_10_0))
				end
			end

			var_9_1.__declared[arg_10_1] = true
		end

		var_0_7(arg_10_0, arg_10_1, arg_10_2)
	end

	setmetatable(arg_9_0, var_9_1)

	return arg_9_0
end

function ProtectMetaTable(arg_11_0)
	getmetatable(arg_11_0).__metatable = true

	return arg_11_0
end

function MakeTableWeakValues(arg_12_0)
	local var_12_0 = getmetatable(arg_12_0) or {}

	var_12_0.__mode = "v"

	setmetatable(arg_12_0, var_12_0)

	return arg_12_0
end

function MakeTableWeakKeys(arg_13_0)
	local var_13_0 = getmetatable(arg_13_0) or {}

	var_13_0.__mode = "k"

	setmetatable(arg_13_0, var_13_0)

	return arg_13_0
end

if not var_0_6(_G, "STRICT_ENUM_INITIATED") then
	var_0_7(_G, "STRICT_ENUM_INITIATED", true)

	local var_0_9 = {
		__eq = function (arg_14_0, arg_14_1)
			assert(arg_14_0._enum_table == arg_14_1._enum_table, "Trying to compare incompatible enum types.")

			return arg_14_0.my_index == arg_14_1.my_index
		end,
		__tostring = function (arg_15_0)
			return arg_15_0._enum_table[arg_15_0]
		end
	}

	function CreateStrictEnumTable(...)
		local var_16_0 = {}
		local var_16_1 = select("#", ...)

		for iter_16_0 = 1, var_16_1 do
			local var_16_2 = select(iter_16_0, ...)
			local var_16_3 = setmetatable({
				_enum_table = var_16_0,
				my_index = iter_16_0,
				as_number = function ()
					return iter_16_0
				end,
				__tostring = function ()
					return var_16_2
				end
			}, var_0_9)

			var_16_0[var_16_2] = var_16_3
			var_16_0[var_16_3] = var_16_2
			var_16_0[iter_16_0] = var_16_3
		end

		return var_16_0
	end
end
