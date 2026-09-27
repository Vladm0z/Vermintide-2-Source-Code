-- chunkname: @core/gwnav/lua/safe_require.lua

local num = 0
local tbl = {}
local var_0_2

function safe_require(arg_1_0)
	-- function 1
	if tbl[arg_1_0] == nil then
		var_0_2 = arg_1_0
		required_module = require(arg_1_0)

		if var_0_2 ~= nil then
			print_warning("`safe_require` called on unguarded file '" .. arg_1_0 .. "', falling back to `require` i.e. looping `require` calls will raise errors")

			var_0_2 = nil

			return required_module
		end

		tbl[arg_1_0] = required_module
	elseif num == 1 then
		require(arg_1_0)
	end

	return tbl[arg_1_0]
end

function safe_require_guard()
	-- function 2
	local tbl_2 = {}

	if var_0_2 == nil then
		print_warning("`safe_require` should be used for modules using `safe_require_guard`, otherwise looping `require` calls will raise errors")

		return tbl_2
	end

	tbl[var_0_2] = tbl_2
	var_0_2 = nil

	return tbl_2
end

function set_safe_require_error_level(arg_3_0)
	-- function 3
	num = arg_3_0
end
