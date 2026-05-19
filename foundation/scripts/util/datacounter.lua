-- chunkname: @foundation/scripts/util/datacounter.lua

DataCounter = {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1[arg_1_0] then
		return 0, 0
	end

	arg_1_1[arg_1_0] = true

	local var_1_0 = type
	local var_1_1 = 0
	local var_1_2 = 0

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		local var_1_3 = var_1_0(iter_1_0)
		local var_1_4 = var_1_0(iter_1_1)

		if var_1_3 == "table" then
			local var_1_5, var_1_6 = var_0_0(iter_1_0, arg_1_1, arg_1_2 + 1)

			var_1_1 = var_1_1 + var_1_5 + 1
			var_1_2 = var_1_2 + var_1_6

			local var_1_7 = ""

			for iter_1_2 = 1, arg_1_2 do
				var_1_7 = var_1_7 .. "\t"
			end

			printf(var_1_7 .. "%s[%6d, %6d]", tostring(iter_1_0), var_1_5, var_1_6)
		end

		if var_1_4 == "table" then
			local var_1_8, var_1_9 = var_0_0(iter_1_1, arg_1_1, arg_1_2 + 1)

			var_1_1 = var_1_1 + var_1_8 + 1
			var_1_2 = var_1_2 + var_1_9

			local var_1_10 = ""

			for iter_1_3 = 1, arg_1_2 do
				var_1_10 = var_1_10 .. "\t"
			end

			printf(var_1_10 .. "%s[%6d, %6d]", tostring(iter_1_0), var_1_8, var_1_9)
		else
			var_1_2 = var_1_2 + 1
		end
	end

	return var_1_1, var_1_2
end

function DataCounter.analyze_table(arg_2_0, arg_2_1, ...)
	local var_2_0 = {}

	for iter_2_0 = 1, select("#", ...) do
		local var_2_1 = select(iter_2_0, ...)

		if var_2_1 then
			var_2_0[var_2_1] = true
		end
	end

	print(arg_2_1)

	local var_2_2, var_2_3 = var_0_0(arg_2_0, var_2_0, 1)

	printf("Analyzed table %q with %d table counts and value counts of %d", arg_2_1 or "unknown", var_2_2, var_2_3)
end
