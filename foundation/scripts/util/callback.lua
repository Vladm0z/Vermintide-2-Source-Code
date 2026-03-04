-- chunkname: @foundation/scripts/util/callback.lua

local var_0_0 = 5

function callback(...)
	local var_1_0 = select(1, ...)

	if type(var_1_0) == "table" then
		local var_1_1 = var_1_0
		local var_1_2 = select(2, ...)
		local var_1_3 = select("#", ...) - 2

		fassert(type(var_1_1[var_1_2]) == "function", "No function found %q on supplied object", var_1_2)
		fassert(var_1_3 <= var_0_0, "A maximum of %d arguments can be provided", var_0_0)

		if var_1_3 == 0 then
			return function (...)
				return var_1_1[var_1_2](var_1_1, ...)
			end
		elseif var_1_3 == 1 then
			local var_1_4 = select(3, ...)

			return function (...)
				return var_1_1[var_1_2](var_1_1, var_1_4, ...)
			end
		elseif var_1_3 == 2 then
			local var_1_5, var_1_6 = select(3, ...)

			return function (...)
				return var_1_1[var_1_2](var_1_1, var_1_5, var_1_6, ...)
			end
		elseif var_1_3 == 3 then
			local var_1_7, var_1_8, var_1_9 = select(3, ...)

			return function (...)
				return var_1_1[var_1_2](var_1_1, var_1_7, var_1_8, var_1_9, ...)
			end
		elseif var_1_3 == 4 then
			local var_1_10, var_1_11, var_1_12, var_1_13 = select(3, ...)

			return function (...)
				return var_1_1[var_1_2](var_1_1, var_1_10, var_1_11, var_1_12, var_1_13, ...)
			end
		elseif var_1_3 == 5 then
			local var_1_14, var_1_15, var_1_16, var_1_17, var_1_18 = select(3, ...)

			return function (...)
				return var_1_1[var_1_2](var_1_1, var_1_14, var_1_15, var_1_16, var_1_17, var_1_18, ...)
			end
		end
	elseif type(var_1_0) == "function" then
		local var_1_19 = var_1_0
		local var_1_20 = select("#", ...) - 1

		fassert(var_1_20 <= var_0_0, "A maximum of %d arguments can be provided", var_0_0)

		if var_1_20 == 0 then
			return function (...)
				return var_1_19(...)
			end
		elseif var_1_20 == 1 then
			local var_1_21 = select(2, ...)

			return function (...)
				return var_1_19(var_1_21, ...)
			end
		elseif var_1_20 == 2 then
			local var_1_22, var_1_23 = select(2, ...)

			return function (...)
				return var_1_19(var_1_22, var_1_23, ...)
			end
		elseif var_1_20 == 3 then
			local var_1_24, var_1_25, var_1_26 = select(2, ...)

			return function (...)
				return var_1_19(var_1_24, var_1_25, var_1_26, ...)
			end
		elseif var_1_20 == 4 then
			local var_1_27, var_1_28, var_1_29, var_1_30 = select(2, ...)

			return function (...)
				return var_1_19(var_1_27, var_1_28, var_1_29, var_1_30, ...)
			end
		elseif var_1_20 == 5 then
			local var_1_31, var_1_32, var_1_33, var_1_34, var_1_35 = select(2, ...)

			return function (...)
				return var_1_19(var_1_31, var_1_32, var_1_33, var_1_34, var_1_35, ...)
			end
		end
	else
		ferror("callback(...) incorrectly called")
	end
end
