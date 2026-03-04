-- chunkname: @scripts/utils/function_call_stats.lua

local var_0_0 = {}
local var_0_1 = 0
local var_0_2 = {}

local function var_0_3(arg_1_0)
	local var_1_0 = debug.getinfo(2)

	if var_1_0 then
		var_0_1 = var_0_1 + 1

		local var_1_1 = tostring(var_1_0.name)
		local var_1_2 = var_1_0.currentline
		local var_1_3

		if var_1_2 ~= -1 then
			var_1_3 = var_1_0.short_src .. ":" .. tostring(var_1_2) .. " " .. var_1_1 .. "()"
		else
			var_1_3 = var_1_0.short_src .. " " .. var_1_1 .. "()"
		end

		local var_1_4 = var_0_0[var_1_3]

		if not var_1_4 then
			var_1_4 = #var_0_0 + 1
			var_0_0[var_1_4] = var_1_3
			var_0_0[var_1_3] = var_1_4
			var_0_2[var_1_4] = {
				num = 1,
				position = var_1_3
			}
		end

		var_0_2[var_1_4].num = var_0_2[var_1_4].num + 1
	end
end

local function var_0_4(arg_2_0, arg_2_1)
	return arg_2_0.num > arg_2_1.num
end

function start_function_call_collection()
	debug.sethook(var_0_3, "c")
end

function end_function_call_collection()
	if var_0_1 > 0 then
		debug.sethook()
		print("Counter", var_0_1)
		table.sort(var_0_2, var_0_4)

		for iter_4_0 = 1, 100 do
			local var_4_0 = var_0_2[iter_4_0]

			if not var_4_0 then
				break
			end

			print(var_4_0.num, var_4_0.position)
		end

		var_0_0 = {}
		var_0_1 = 0
		var_0_2 = {}
	end
end
