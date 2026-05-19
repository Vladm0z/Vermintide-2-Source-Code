-- chunkname: @core/gwnav/lua/runtime/navclass.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()

function var_0_0.NavClass(arg_1_0, arg_1_1)
	arg_1_0 = arg_1_0 or {}

	if next(arg_1_0) == nil then
		local var_1_0 = {
			__call = function(arg_2_0, ...)
				local var_2_0 = {}

				setmetatable(var_2_0, arg_1_0)

				if var_2_0.init then
					var_2_0:init(...)
				end

				return var_2_0
			end
		}

		setmetatable(arg_1_0, var_1_0)
	end

	if arg_1_1 then
		for iter_1_0, iter_1_1 in pairs(arg_1_1) do
			arg_1_0[iter_1_0] = iter_1_1
		end
	end

	arg_1_0.Super = arg_1_1
	arg_1_0.__index = arg_1_0

	return arg_1_0
end

return var_0_0.NavClass
