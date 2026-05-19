-- chunkname: @foundation/scripts/util/error.lua

local function var_0_0(arg_1_0, ...)
	local var_1_0 = {}

	for iter_1_0 = 1, select("#", ...) do
		var_1_0[iter_1_0] = tostring(select(iter_1_0, ...))
	end

	return string.format(arg_1_0, unpack(var_1_0))
end

function Application.warning(...)
	print_warning(var_0_0(...))
end

function Application.error(...)
	if Crashify and script_data.testify then
		Crashify.print_exception("Lua", var_0_0(...))
	else
		print_error(var_0_0(...))
	end
end

function fassert(arg_4_0, arg_4_1, ...)
	if not arg_4_0 then
		local var_4_0 = var_0_0(arg_4_1, ...)

		assert(false, var_4_0)
	end
end

function ferror(arg_5_0, ...)
	local var_5_0 = var_0_0(arg_5_0, ...)

	error(var_5_0)
end
