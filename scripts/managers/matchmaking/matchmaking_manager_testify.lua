-- chunkname: @scripts/managers/matchmaking/matchmaking_manager_testify.lua

return {
	wait_for_matchmaking_state = function(arg_1_0, arg_1_1)
		if arg_1_0:state().NAME ~= arg_1_1 then
			return Testify.RETRY
		end
	end,
	wait_for_matchmaking_substate = function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_1.state
		local var_2_1 = arg_2_1.substate

		if var_2_0 and arg_2_0:state().NAME ~= var_2_0 then
			return Testify.RETRY
		end

		if arg_2_0:state()._state ~= var_2_1 then
			return Testify.RETRY
		end
	end
}
