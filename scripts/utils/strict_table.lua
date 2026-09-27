-- chunkname: @scripts/utils/strict_table.lua

local format = string.format

local function fn(...)
	-- function 1
	return format(...)
end

local getinfo = debug.getinfo
local flag = true
local var_0_4

if not flag then
	function var_0_4(...)
		-- function 2
		local var_2_0, var_2_1 = pcall(fn, ...)

		if not var_2_0 then
			assert(false, var_2_1)
		else
			assert(false, "Failed to format text.")
		end
	end
else
	local function fn_2(arg_3_0, arg_3_1)
		-- function 3
		if not Application.console_send then
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
		-- function 4
		fn_2("error", fn(...))
	end
end

local rawget = rawget
local rawset = rawset

local function fn_3(self)
	-- function 5
	local short_src = self.short_src

	short_src = short_src or ""

	local currentline = self.currentline

	currentline = currentline or -1

	return (fn("short_src(%s), line(%d)", short_src, currentline))
end

local StrictNil = StrictNil

StrictNil = StrictNil or {}
StrictNil = StrictNil

function MakeTableStrict(self)
	-- function 6
	local tbl = {}

	for k, v in pairs(self) do
		tbl[k] = true

		if v == StrictNil then
			self[k] = nil
		end
	end

	local tbl_2 = {
		__declared = tbl
	}

	tbl_2.__newindex = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if not tbl_2.__declared[arg_7_1] then
			if not rawget(arg_7_0, arg_7_1) then
				local var_7_0 = getinfo(2, "Sl")

				if not (arg_7_1 == "to_console_line" or not var_7_0 and var_7_0.what == "main" or var_7_0.what == "C") then
					var_0_4("[ERROR] cannot assign undeclared member variable %q, %s", arg_7_1, fn_3(var_7_0))
				end
			end

			tbl_2.__declared[arg_7_1] = true
		end

		rawset(arg_7_0, arg_7_1, arg_7_2)
	end

	tbl_2.__index = function (arg_8_0, arg_8_1)
		-- function 8
		if not (tbl_2.__declared[arg_8_1] or rawget(arg_8_0, arg_8_1)) then
			local var_8_0 = getinfo(2, "Sl")

			if not (arg_8_1 == "to_console_line" or not var_8_0 and var_8_0.what == "main" or var_8_0.what == "C") then
				var_0_4("[ERROR] cannot index undeclared member variable %q, %s", tostring(arg_8_1), fn_3(var_8_0))
			end
		end
	end

	setmetatable(self, tbl_2)

	return self
end

function MakeTableFrozen(self)
	-- function 9
	local tbl = {}

	for k, v in pairs(self) do
		tbl[k] = true

		if v == StrictNil then
			self[k] = nil
		end
	end

	local tbl_2 = {
		__declared = tbl
	}

	tbl_2.__newindex = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		if not tbl_2.__declared[arg_10_1] then
			if not rawget(arg_10_0, arg_10_1) then
				local var_10_0 = getinfo(2, "Sl")

				if not (arg_10_1 == "to_console_line" or not var_10_0 and var_10_0.what == "main" or var_10_0.what == "C") then
					var_0_4("[ERROR] cannot assign undeclared member variable %q, %s", arg_10_1, fn_3(var_10_0))
				end
			end

			tbl_2.__declared[arg_10_1] = true
		end

		rawset(arg_10_0, arg_10_1, arg_10_2)
	end

	setmetatable(self, tbl_2)

	return self
end

function ProtectMetaTable(arg_11_0)
	-- function 11
	getmetatable(arg_11_0).__metatable = true

	return arg_11_0
end

function MakeTableWeakValues(arg_12_0)
	-- function 12
	local var_12_0 = getmetatable(arg_12_0)

	var_12_0 = var_12_0 or {}
	var_12_0.__mode = "v"

	setmetatable(arg_12_0, var_12_0)

	return arg_12_0
end

function MakeTableWeakKeys(arg_13_0)
	-- function 13
	local var_13_0 = getmetatable(arg_13_0)

	var_13_0 = var_13_0 or {}
	var_13_0.__mode = "k"

	setmetatable(arg_13_0, var_13_0)

	return arg_13_0
end

if not rawget(_G, "STRICT_ENUM_INITIATED") then
	rawset(_G, "STRICT_ENUM_INITIATED", true)

	local tbl = {
		__eq = function (self, arg_14_1)
			-- function 14
			assert(self._enum_table == arg_14_1._enum_table, "Trying to compare incompatible enum types.")

			return self.my_index == arg_14_1.my_index
		end,
		__tostring = function (self)
			-- function 15
			return self._enum_table[self]
		end
	}

	function CreateStrictEnumTable(...)
		-- function 16
		local tbl_2 = {}
		local var_16_1 = select("#", ...)

		for i = 1, var_16_1 do
			local var_16_2 = select(i, ...)
			local var_16_3 = setmetatable({
				_enum_table = tbl_2,
				my_index = i,
				as_number = function ()
					-- function 17
					return i
				end,
				__tostring = function ()
					-- function 18
					return var_16_2
				end
			}, tbl)

			tbl_2[var_16_2] = var_16_3
			tbl_2[var_16_3] = var_16_2
			tbl_2[i] = var_16_3
		end

		return tbl_2
	end
end
