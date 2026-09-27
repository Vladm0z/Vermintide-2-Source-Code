-- chunkname: @scripts/helpers/deus_gen_utils.lua

local DeusGenUtils = DeusGenUtils

DeusGenUtils = DeusGenUtils or {}
DeusGenUtils = DeusGenUtils

DeusGenUtils.create_random_generator = function (arg_1_0)
	-- function 1
	return function (arg_2_0, arg_2_1)
		-- function 2
		local var_2_0

		if not arg_2_0 then
			arg_1_0, var_2_0 = Math.next_random(arg_1_0, arg_2_0, arg_2_1)
		else
			arg_1_0, var_2_0 = Math.next_random(arg_1_0)
		end

		return var_2_0, arg_1_0
	end
end
