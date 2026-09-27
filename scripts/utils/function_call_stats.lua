-- chunkname: @scripts/utils/function_call_stats.lua

local tbl = {}
local num = 0
local tbl_2 = {}

local function fn(arg_1_0)
	-- function 1
	local getinfo = debug.getinfo(2)

	if not getinfo then
		num = num + 1

		local var_1_1 = tostring(getinfo.name)
		local currentline = getinfo.currentline
		local var_1_3

		if currentline ~= -1 then
			var_1_3 = getinfo.short_src .. ":" .. tostring(currentline) .. " " .. var_1_1 .. "()"
		else
			var_1_3 = getinfo.short_src .. " " .. var_1_1 .. "()"
		end

		local var_1_4 = tbl[var_1_3]

		if not var_1_4 then
			var_1_4 = #tbl + 1
			tbl[var_1_4] = var_1_3
			tbl[var_1_3] = var_1_4
			tbl_2[var_1_4] = {
				num = 1,
				position = var_1_3
			}
		end

		tbl_2[var_1_4].num = tbl_2[var_1_4].num + 1
	end
end

local function fn_2(self, arg_2_1)
	-- function 2
	return self.num > arg_2_1.num
end

function start_function_call_collection()
	-- function 3
	debug.sethook(fn, "c")
end

function end_function_call_collection()
	-- function 4
	if num > 0 then
		debug.sethook()
		print("Counter", num)
		table.sort(tbl_2, fn_2)

		for i = 1, 100 do
			local var_4_0 = tbl_2[i]

			if not var_4_0 then
				break
			end

			print(var_4_0.num, var_4_0.position)
		end

		tbl = {}
		num = 0
		tbl_2 = {}
	end
end
