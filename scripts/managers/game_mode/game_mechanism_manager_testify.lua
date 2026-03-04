-- chunkname: @scripts/managers/game_mode/game_mechanism_manager_testify.lua

return {
	request_vote = function (arg_1_0, arg_1_1)
		arg_1_0:request_vote(arg_1_1)
	end,
	versus_get_num_sets = function (arg_2_0, arg_2_1)
		if arg_2_0:current_mechanism_name() ~= "versus" then
			return Testify.RETRY
		end

		local var_2_0 = arg_2_0:game_mechanism():num_sets()

		if var_2_0 < 1 then
			return Testify.RETRY
		end

		return var_2_0
	end
}
