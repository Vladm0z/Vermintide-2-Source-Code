-- chunkname: @foundation/scripts/util/error.lua

local function fn(arg_1_0, ...)
	-- function 1
	local tbl = {}

	for i = 1, select("#", ...) do
		tbl[i] = tostring(select(i, ...))
	end

	return string.format(arg_1_0, unpack(tbl))
end

Application.warning = function (...)
	-- function 2
	print_warning(fn(...))
end

Application.error = function (...)
	-- function 3
	if not Crashify and not script_data.testify then
		Crashify.print_exception("Lua", fn(...))
	else
		print_error(fn(...))
	end
end

function fassert(arg_4_0, arg_4_1, ...)
	-- function 4
	if not arg_4_0 then
		local var_4_0 = fn(arg_4_1, ...)

		assert(false, var_4_0)
	end
end

function ferror(arg_5_0, ...)
	-- function 5
	local var_5_0 = fn(arg_5_0, ...)

	error(var_5_0)
end
