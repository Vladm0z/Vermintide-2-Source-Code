-- chunkname: @core/gwnav/lua/safe_require.lua

local var_0_0 = 0
local var_0_1 = {}
local var_0_2

function safe_require(arg_1_0)
	if var_0_1[arg_1_0] == nil then
		var_0_2 = arg_1_0
		required_module = require(arg_1_0)

		if var_0_2 ~= nil then
			print_warning("`safe_require` called on unguarded file '" .. arg_1_0 .. "', falling back to `require` i.e. looping `require` calls will raise errors")

			var_0_2 = nil

			return required_module
		end

		var_0_1[arg_1_0] = required_module
	elseif var_0_0 == 1 then
		require(arg_1_0)
	end

	return var_0_1[arg_1_0]
end

function safe_require_guard()
	local var_2_0 = {}

	if var_0_2 == nil then
		print_warning("`safe_require` should be used for modules using `safe_require_guard`, otherwise looping `require` calls will raise errors")

		return var_2_0
	end

	var_0_1[var_0_2] = var_2_0
	var_0_2 = nil

	return var_2_0
end

function set_safe_require_error_level(arg_3_0)
	var_0_0 = arg_3_0
end
