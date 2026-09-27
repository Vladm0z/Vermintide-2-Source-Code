-- chunkname: @foundation/scripts/util/datacounter.lua

DataCounter = {}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if not arg_1_1[arg_1_0] then
		return 0, 0
	end

	arg_1_1[arg_1_0] = true

	local type = type
	local num = 0
	local num_2 = 0

	for k, v in pairs(arg_1_0) do
		local var_1_3 = type(k)
		local var_1_4 = type(v)

		if var_1_3 == "table" then
			local var_1_5, var_1_6 = fn(k, arg_1_1, arg_1_2 + 1)

			num = num + var_1_5 + 1
			num_2 = num_2 + var_1_6

			local str = ""

			for k_2 = 1, arg_1_2 do
				str = str .. "\t"
			end

			printf(str .. "%s[%6d, %6d]", tostring(k), var_1_5, var_1_6)
		end

		if var_1_4 == "table" then
			local var_1_8, var_1_9 = fn(v, arg_1_1, arg_1_2 + 1)

			num = num + var_1_8 + 1
			num_2 = num_2 + var_1_9

			local str_2 = ""

			for l = 1, arg_1_2 do
				str_2 = str_2 .. "\t"
			end

			printf(str_2 .. "%s[%6d, %6d]", tostring(k), var_1_8, var_1_9)
		else
			num_2 = num_2 + 1
		end
	end

	return num, num_2
end

DataCounter.analyze_table = function (arg_2_0, arg_2_1, ...)
	-- function 2
	local tbl = {}

	for i = 1, select("#", ...) do
		local var_2_1 = select(i, ...)

		if not var_2_1 then
			tbl[var_2_1] = true
		end
	end

	print(arg_2_1)

	local var_2_2, var_2_3 = fn(arg_2_0, tbl, 1)

	printf("Analyzed table %q with %d table counts and value counts of %d", arg_2_1 or "unknown", var_2_2, var_2_3)
end
