-- chunkname: @foundation/scripts/util/callback.lua

local MAX_ARGS = 5

function callback(...)
	-- function 1
	local arg1 = select(1, ...)

	if type(arg1) == "table" then
		local object = arg1
		local func_name = select(2, ...)
		local num_args = select("#", ...) - 2

		fassert(type(object[func_name]) == "function", "No function found %q on supplied object", func_name)
		fassert(num_args <= MAX_ARGS, "A maximum of %d arguments can be provided", MAX_ARGS)

		if num_args == 0 then
			return function (...)
				-- function 2
				return object[func_name](object, ...)
			end
		elseif num_args == 1 then
			local arg1 = select(3, ...)

			return function (...)
				-- function 3
				return object[func_name](object, arg1, ...)
			end
		elseif num_args == 2 then
			local arg1, arg2 = select(3, ...)

			return function (...)
				-- function 4
				return object[func_name](object, arg1, arg2, ...)
			end
		elseif num_args == 3 then
			local arg1, arg2, arg3 = select(3, ...)

			return function (...)
				-- function 5
				return object[func_name](object, arg1, arg2, arg3, ...)
			end
		elseif num_args == 4 then
			local arg1, arg2, arg3, arg4 = select(3, ...)

			return function (...)
				-- function 6
				return object[func_name](object, arg1, arg2, arg3, arg4, ...)
			end
		elseif num_args == 5 then
			local arg1, arg2, arg3, arg4, arg5 = select(3, ...)

			return function (...)
				-- function 7
				return object[func_name](object, arg1, arg2, arg3, arg4, arg5, ...)
			end
		end
	elseif type(arg1) == "function" then
		local func = arg1
		local num_args = select("#", ...) - 1

		fassert(num_args <= MAX_ARGS, "A maximum of %d arguments can be provided", MAX_ARGS)

		if num_args == 0 then
			return function (...)
				-- function 8
				return func(...)
			end
		elseif num_args == 1 then
			local arg1 = select(2, ...)

			return function (...)
				-- function 9
				return func(arg1, ...)
			end
		elseif num_args == 2 then
			local arg1, arg2 = select(2, ...)

			return function (...)
				-- function 10
				return func(arg1, arg2, ...)
			end
		elseif num_args == 3 then
			local arg1, arg2, arg3 = select(2, ...)

			return function (...)
				-- function 11
				return func(arg1, arg2, arg3, ...)
			end
		elseif num_args == 4 then
			local arg1, arg2, arg3, arg4 = select(2, ...)

			return function (...)
				-- function 12
				return func(arg1, arg2, arg3, arg4, ...)
			end
		elseif num_args == 5 then
			local arg1, arg2, arg3, arg4, arg5 = select(2, ...)

			return function (...)
				-- function 13
				return func(arg1, arg2, arg3, arg4, arg5, ...)
			end
		end
	else
		ferror("callback(...) incorrectly called")
	end
end
