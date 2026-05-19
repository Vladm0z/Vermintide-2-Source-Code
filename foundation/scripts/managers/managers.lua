-- chunkname: @foundation/scripts/managers/managers.lua

local function var_0_0(arg_1_0, ...)
	if script_data.network_debug then
		printf("[Managers] " .. arg_1_0, ...)
	end
end

local var_0_1 = BUILD == "dev" or BUILD == "debug"
local var_0_2 = {
	"global",
	"venture",
	"state"
}

Managers = Managers or {
	state = {},
	venture = {}
}
ManagersCreationOrder = ManagersCreationOrder or {
	global = {},
	state = {},
	venture = {}
}

local function var_0_3(arg_2_0)
	var_0_0("Destroying manager group: %s", arg_2_0)

	local var_2_0 = arg_2_0 == "global" and Managers or Managers[arg_2_0]
	local var_2_1 = ManagersCreationOrder[arg_2_0]

	table.reverse(var_2_1)

	for iter_2_0, iter_2_1 in ipairs(var_2_1) do
		local var_2_2 = var_2_0[iter_2_1]

		if var_2_2 and type(var_2_2.destroy) == "function" then
			var_2_2:destroy()
		end

		var_2_0[iter_2_1] = nil
		var_2_1[iter_2_0] = nil
	end
end

local function var_0_4(arg_3_0)
	return 1, #arg_3_0, 1
end

local function var_0_5(arg_4_0)
	return #arg_4_0, 1, -1
end

local function var_0_6(arg_5_0, arg_5_1, ...)
	var_0_0("Calling function on all managers:", arg_5_0, "inverse_order:", arg_5_1)

	local var_5_0 = arg_5_1 and var_0_5 or var_0_4
	local var_5_1, var_5_2, var_5_3 = var_5_0(var_0_2)

	for iter_5_0 = var_5_1, var_5_2, var_5_3 do
		local var_5_4 = var_0_2[iter_5_0]
		local var_5_5 = var_5_4 == "global" and Managers or Managers[var_5_4]
		local var_5_6 = ManagersCreationOrder[var_5_4]
		local var_5_7, var_5_8, var_5_9 = var_5_0(var_5_6)

		for iter_5_1 = var_5_7, var_5_8, var_5_9 do
			local var_5_10 = var_5_5[var_5_6[iter_5_1]]

			if var_5_10 and var_5_10[arg_5_0] then
				var_5_10[arg_5_0](var_5_10, ...)
			end
		end
	end
end

function Managers.destroy(arg_6_0)
	for iter_6_0 = #var_0_2, 1, -1 do
		var_0_3(var_0_2[iter_6_0])
	end
end

function Managers.state.destroy(arg_7_0)
	var_0_3("state")
end

function Managers.venture.destroy(arg_8_0)
	var_0_3("venture")
end

function Managers.on_round_start(arg_9_0, ...)
	var_0_6("on_round_start", false, ...)
end

function Managers.on_round_end(arg_10_0, ...)
	var_0_6("on_round_end", true, ...)
end

function Managers.on_venture_start(arg_11_0, ...)
	var_0_6("on_venture_start", false, ...)
end

function Managers.on_venture_end(arg_12_0, ...)
	var_0_6("on_venture_end", true, ...)
end

local var_0_7 = {
	__newindex = function(arg_13_0, arg_13_1, arg_13_2)
		rawset(ManagersCreationOrder.global, #ManagersCreationOrder.global + 1, arg_13_1)
		rawset(arg_13_0, arg_13_1, arg_13_2)

		if arg_13_2 and var_0_1 then
			local var_13_0 = arg_13_1 .. "_update"
			local var_13_1 = getmetatable(arg_13_2)

			if var_13_1 then
				function arg_13_2.update(...)
					local var_14_0, var_14_1, var_14_2 = var_13_1.update(...)

					return var_14_0, var_14_1, var_14_2
				end
			end
		end
	end,
	__tostring = function(arg_15_0)
		local var_15_0 = "\n"

		for iter_15_0, iter_15_1 in pairs(arg_15_0) do
			if type(iter_15_1) == "table" and iter_15_0 ~= "state" and iter_15_0 ~= "venture" then
				var_15_0 = var_15_0 .. "\t" .. iter_15_0 .. "\n"
			end
		end

		return var_15_0
	end
}
local var_0_8 = {
	__newindex = function(arg_16_0, arg_16_1, arg_16_2)
		rawset(ManagersCreationOrder.venture, #ManagersCreationOrder.venture + 1, arg_16_1)
		rawset(arg_16_0, arg_16_1, arg_16_2)

		if arg_16_2 and var_0_1 then
			local var_16_0 = arg_16_1 .. "_update"
			local var_16_1 = getmetatable(arg_16_2)

			function arg_16_2.update(...)
				local var_17_0, var_17_1, var_17_2 = var_16_1.update(...)

				return var_17_0, var_17_1, var_17_2
			end
		end
	end,
	__tostring = function(arg_18_0)
		local var_18_0 = "\n"

		for iter_18_0, iter_18_1 in pairs(arg_18_0) do
			if type(iter_18_1) == "table" then
				var_18_0 = var_18_0 .. "\t" .. iter_18_0 .. "\n"
			end
		end

		return var_18_0
	end
}
local var_0_9 = {
	__newindex = function(arg_19_0, arg_19_1, arg_19_2)
		rawset(ManagersCreationOrder.state, #ManagersCreationOrder.state + 1, arg_19_1)
		rawset(arg_19_0, arg_19_1, arg_19_2)

		if arg_19_2 and var_0_1 then
			local var_19_0 = arg_19_1 .. "_update"
			local var_19_1 = getmetatable(arg_19_2)

			function arg_19_2.update(...)
				local var_20_0, var_20_1, var_20_2 = var_19_1.update(...)

				return var_20_0, var_20_1, var_20_2
			end
		end
	end,
	__tostring = function(arg_21_0)
		local var_21_0 = "\n"

		for iter_21_0, iter_21_1 in pairs(arg_21_0) do
			if type(iter_21_1) == "table" then
				var_21_0 = var_21_0 .. "\t" .. iter_21_0 .. "\n"
			end
		end

		return var_21_0
	end
}

setmetatable(Managers, var_0_7)
setmetatable(Managers.venture, var_0_8)
setmetatable(Managers.state, var_0_9)
