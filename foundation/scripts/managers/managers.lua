-- chunkname: @foundation/scripts/managers/managers.lua

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.network_debug then
		printf("[Managers] " .. arg_1_0, ...)
	end
end

local flag = BUILD == "dev" or BUILD == "debug"
local tbl = {
	"global",
	"venture",
	"state"
}
local Managers = Managers

Managers = Managers or {
	state = {},
	venture = {}
}
Managers = Managers

local ManagersCreationOrder = ManagersCreationOrder

ManagersCreationOrder = ManagersCreationOrder or {
	global = {},
	state = {},
	venture = {}
}
ManagersCreationOrder = ManagersCreationOrder

local function fn_2(arg_2_0)
	-- function 2
	fn("Destroying manager group: %s", arg_2_0)

	local Managers

	if arg_2_0 == "global" then
		Managers = Managers

		if not Managers then
			-- Nothing
		end
	end

	Managers = Managers[arg_2_0]

	::label_2_0::

	local var_2_1 = ManagersCreationOrder[arg_2_0]

	table.reverse(var_2_1)

	for i, v in ipairs(var_2_1) do
		local var_2_2 = Managers[v]

		if not (not var_2_2 and type(var_2_2.destroy) ~= "function") then
			var_2_2:destroy()
		end

		Managers[v] = nil
		var_2_1[i] = nil
	end
end

local function fn_3(arg_3_0)
	-- function 3
	return 1, #arg_3_0, 1
end

local function fn_4(arg_4_0)
	-- function 4
	return #arg_4_0, 1, -1
end

local function fn_5(arg_5_0, arg_5_1, ...)
	-- function 5
	fn("Calling function on all managers:", arg_5_0, "inverse_order:", arg_5_1)

	local var_5_0

	if not arg_5_1 then
		var_5_0 = fn_4

		if not var_5_0 then
			-- Nothing
		end
	end

	var_5_0 = fn_3

	::label_5_0::

	local var_5_1, var_5_2, var_5_3 = var_5_0(tbl)

	for i = var_5_1, var_5_2, var_5_3 do
		local var_5_4 = tbl[i]
		local Managers

		if var_5_4 == "global" then
			Managers = Managers

			if not Managers then
				-- Nothing
			end
		end

		Managers = Managers[var_5_4]

		::label_5_1::

		local var_5_6 = ManagersCreationOrder[var_5_4]
		local var_5_7, var_5_8, var_5_9 = var_5_0(var_5_6)

		for j = var_5_7, var_5_8, var_5_9 do
			local var_5_10 = Managers[var_5_6[j]]

			if not var_5_10 and not var_5_10[arg_5_0] then
				var_5_10[arg_5_0](var_5_10, ...)
			end
		end
	end
end

Managers.destroy = function (arg_6_0)
	-- function 6
	for i = #tbl, 1, -1 do
		fn_2(tbl[i])
	end
end

Managers.state.destroy = function (arg_7_0)
	-- function 7
	fn_2("state")
end

Managers.venture.destroy = function (arg_8_0)
	-- function 8
	fn_2("venture")
end

Managers.on_round_start = function (arg_9_0, ...)
	-- function 9
	fn_5("on_round_start", false, ...)
end

Managers.on_round_end = function (arg_10_0, ...)
	-- function 10
	fn_5("on_round_end", true, ...)
end

Managers.on_venture_start = function (arg_11_0, ...)
	-- function 11
	fn_5("on_venture_start", false, ...)
end

Managers.on_venture_end = function (arg_12_0, ...)
	-- function 12
	fn_5("on_venture_end", true, ...)
end

local tbl_2 = {
	__newindex = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		rawset(ManagersCreationOrder.global, #ManagersCreationOrder.global + 1, arg_13_1)
		rawset(arg_13_0, arg_13_1, arg_13_2)

		if not arg_13_2 and not flag then
			local str = arg_13_1 .. "_update"
			local var_13_1 = getmetatable(arg_13_2)

			if not var_13_1 then
				arg_13_2.update = function (...)
					-- function 14
					local update, var_14_1, var_14_2 = var_13_1.update(...)

					return update, var_14_1, var_14_2
				end
			end
		end
	end,
	__tostring = function (arg_15_0)
		-- function 15
		local str = "\n"

		for k, v in pairs(arg_15_0) do
			if not (type(v) ~= "table" or k == "state" or k == "venture") then
				str = str .. "\t" .. k .. "\n"
			end
		end

		return str
	end
}
local tbl_3 = {
	__newindex = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		rawset(ManagersCreationOrder.venture, #ManagersCreationOrder.venture + 1, arg_16_1)
		rawset(arg_16_0, arg_16_1, arg_16_2)

		if not arg_16_2 and not flag then
			local str = arg_16_1 .. "_update"
			local var_16_1 = getmetatable(arg_16_2)

			arg_16_2.update = function (...)
				-- function 17
				local update, var_17_1, var_17_2 = var_16_1.update(...)

				return update, var_17_1, var_17_2
			end
		end
	end,
	__tostring = function (arg_18_0)
		-- function 18
		local str = "\n"

		for k, v in pairs(arg_18_0) do
			if type(v) == "table" then
				str = str .. "\t" .. k .. "\n"
			end
		end

		return str
	end
}
local tbl_4 = {
	__newindex = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		rawset(ManagersCreationOrder.state, #ManagersCreationOrder.state + 1, arg_19_1)
		rawset(arg_19_0, arg_19_1, arg_19_2)

		if not arg_19_2 and not flag then
			local str = arg_19_1 .. "_update"
			local var_19_1 = getmetatable(arg_19_2)

			arg_19_2.update = function (...)
				-- function 20
				local update, var_20_1, var_20_2 = var_19_1.update(...)

				return update, var_20_1, var_20_2
			end
		end
	end,
	__tostring = function (arg_21_0)
		-- function 21
		local str = "\n"

		for k, v in pairs(arg_21_0) do
			if type(v) == "table" then
				str = str .. "\t" .. k .. "\n"
			end
		end

		return str
	end
}

setmetatable(Managers, tbl_2)
setmetatable(Managers.venture, tbl_3)
setmetatable(Managers.state, tbl_4)
