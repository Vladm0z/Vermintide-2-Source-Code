-- chunkname: @foundation/scripts/util/error.lua

local function format_error_message(message, ...)
	-- function 1
	local args = {}

	for i = 1, select("#", ...) do
		args[i] = tostring(select(i, ...))
	end

	return string.format(message, unpack(args))
end

Application.warning = function (...)
	-- function 2
	print_warning(format_error_message(...))
end

Application.error = function (...)
	-- function 3
	if Crashify and script_data.testify then
		Crashify.print_exception("Lua", format_error_message(...))
	else
		print_error(format_error_message(...))
	end
end

function fassert(condition, message, ...)
	-- function 4
	if not condition then
		local message = format_error_message(message, ...)

		assert(false, message)
	end
end

function ferror(message, ...)
	-- function 5
	local message = format_error_message(message, ...)

	error(message)
end
