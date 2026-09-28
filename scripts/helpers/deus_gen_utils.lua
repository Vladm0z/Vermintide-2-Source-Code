-- chunkname: @scripts/helpers/deus_gen_utils.lua

local DeusGenUtils = DeusGenUtils

DeusGenUtils = not not DeusGenUtils or not not {}
DeusGenUtils = DeusGenUtils

DeusGenUtils.create_random_generator = function (seed)
	-- function 1
	return function (first_bound, second_bound)
		-- function 2
		local val

		if first_bound then
			seed, val = Math.next_random(seed, first_bound, second_bound)
		else
			seed, val = Math.next_random(seed)
		end

		return val, seed
	end
end
