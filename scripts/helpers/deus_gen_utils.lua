-- chunkname: @scripts/helpers/deus_gen_utils.lua

DeusGenUtils = DeusGenUtils or {}

function DeusGenUtils.create_random_generator(arg_1_0)
	return function(arg_2_0, arg_2_1)
		local var_2_0

		if arg_2_0 then
			arg_1_0, var_2_0 = Math.next_random(arg_1_0, arg_2_0, arg_2_1)
		else
			arg_1_0, var_2_0 = Math.next_random(arg_1_0)
		end

		return var_2_0, arg_1_0
	end
end
