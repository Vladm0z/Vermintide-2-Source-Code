-- chunkname: @foundation/scripts/util/callback.lua

local num = 5

function callback(...)
	-- function 1
	local var_1_0 = select(1, ...)

	if type(var_1_0) == "table" then
		local var_1_1 = var_1_0
		local var_1_2 = select(2, ...)
		local num_2 = select("#", ...) - 2

		fassert(type(var_1_1[var_1_2]) == "function", "No function found %q on supplied object", var_1_2)
		fassert(num_2 <= num, "A maximum of %d arguments can be provided", num)

		if num_2 == 0 then
			return function (...)
				-- function 2
				return var_1_1[var_1_2](var_1_1, ...)
			end
		elseif num_2 == 1 then
			local var_1_4 = select(3, ...)

			return function (...)
				-- function 3
				return var_1_1[var_1_2](var_1_1, var_1_4, ...)
			end
		elseif num_2 == 2 then
			local var_1_5, var_1_6 = select(3, ...)

			return function (...)
				-- function 4
				return var_1_1[var_1_2](var_1_1, var_1_5, var_1_6, ...)
			end
		elseif num_2 == 3 then
			local var_1_7, var_1_8, var_1_9 = select(3, ...)

			return function (...)
				-- function 5
				return var_1_1[var_1_2](var_1_1, var_1_7, var_1_8, var_1_9, ...)
			end
		elseif num_2 == 4 then
			local var_1_10, var_1_11, var_1_12, var_1_13 = select(3, ...)

			return function (...)
				-- function 6
				return var_1_1[var_1_2](var_1_1, var_1_10, var_1_11, var_1_12, var_1_13, ...)
			end
		elseif num_2 == 5 then
			local var_1_14, var_1_15, var_1_16, var_1_17, var_1_18 = select(3, ...)

			return function (...)
				-- function 7
				return var_1_1[var_1_2](var_1_1, var_1_14, var_1_15, var_1_16, var_1_17, var_1_18, ...)
			end
		end
	elseif type(var_1_0) == "function" then
		local var_1_19 = var_1_0
		local num_3 = select("#", ...) - 1

		fassert(num_3 <= num, "A maximum of %d arguments can be provided", num)

		if num_3 == 0 then
			return function (...)
				-- function 8
				return var_1_19(...)
			end
		elseif num_3 == 1 then
			local var_1_21 = select(2, ...)

			return function (...)
				-- function 9
				return var_1_19(var_1_21, ...)
			end
		elseif num_3 == 2 then
			local var_1_22, var_1_23 = select(2, ...)

			return function (...)
				-- function 10
				return var_1_19(var_1_22, var_1_23, ...)
			end
		elseif num_3 == 3 then
			local var_1_24, var_1_25, var_1_26 = select(2, ...)

			return function (...)
				-- function 11
				return var_1_19(var_1_24, var_1_25, var_1_26, ...)
			end
		elseif num_3 == 4 then
			local var_1_27, var_1_28, var_1_29, var_1_30 = select(2, ...)

			return function (...)
				-- function 12
				return var_1_19(var_1_27, var_1_28, var_1_29, var_1_30, ...)
			end
		elseif num_3 == 5 then
			local var_1_31, var_1_32, var_1_33, var_1_34, var_1_35 = select(2, ...)

			return function (...)
				-- function 13
				return var_1_19(var_1_31, var_1_32, var_1_33, var_1_34, var_1_35, ...)
			end
		end
	else
		ferror("callback(...) incorrectly called")
	end
end
