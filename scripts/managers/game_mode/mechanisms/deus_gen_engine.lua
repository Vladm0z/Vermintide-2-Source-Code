-- chunkname: @scripts/managers/game_mode/mechanisms/deus_gen_engine.lua

local function var_0_0(arg_1_0)
	for iter_1_0 = #arg_1_0, 1, -1 do
		local var_1_0 = arg_1_0[iter_1_0]

		if var_1_0._next_action_generators then
			for iter_1_1, iter_1_2 in pairs(var_1_0._next_actions) do
				if not iter_1_2 then
					local var_1_1 = var_1_0._next_action_generators[iter_1_1]()

					var_1_1._parent = var_1_0
					var_1_0._next_actions[iter_1_1] = var_1_1

					return var_1_1
				end
			end
		end
	end
end

local function var_0_1(arg_2_0)
	if not arg_2_0._parent then
		return
	end

	for iter_2_0, iter_2_1 in pairs(arg_2_0._parent._next_actions) do
		if iter_2_1 == arg_2_0 then
			arg_2_0._parent._next_actions[iter_2_0] = false
		end
	end
end

local function var_0_2(arg_3_0, arg_3_1)
	arg_3_0._next_action_generators = arg_3_1

	if arg_3_1 then
		arg_3_0._next_actions = {}

		for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
			arg_3_0._next_actions[iter_3_0] = false
		end
	end
end

DeusGenEngine = {
	get_generator = function(arg_4_0, arg_4_1)
		local var_4_0 = false

		return function()
			if #arg_4_0 > 0 then
				local var_5_0 = arg_4_0[#arg_4_0]

				if arg_4_1 then
					arg_4_1(arg_4_0, var_5_0)
				end

				local var_5_1
				local var_5_2

				if not var_4_0 then
					var_5_1, var_5_2 = var_5_0.run()
				else
					var_5_1, var_5_2 = var_5_0.retry()
				end

				if var_5_1 then
					var_4_0 = false

					var_0_2(var_5_0, var_5_2)

					local var_5_3 = var_0_0(arg_4_0)

					if var_5_3 then
						arg_4_0[#arg_4_0 + 1] = var_5_3
					else
						return true
					end
				else
					var_4_0 = true

					var_0_1(var_5_0)

					arg_4_0[#arg_4_0] = nil
				end

				return false
			else
				return true, "Gen Failed"
			end
		end
	end
}
