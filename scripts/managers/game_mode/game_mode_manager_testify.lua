-- chunkname: @scripts/managers/game_mode/game_mode_manager_testify.lua

return {
	game_mode_start_round = function(arg_1_0)
		arg_1_0:round_started()

		arg_1_0:game_mode().pre_round_start_timer = 0
	end,
	wait_for_game_mode = function(arg_2_0, arg_2_1)
		if arg_2_1 ~= arg_2_0:game_mode_key() then
			return Testify.RETRY
		end
	end,
	wait_for_game_mode_state = function(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_1.game_mode
		local var_3_1 = arg_3_1.state
		local var_3_2 = arg_3_0:game_mode_key()

		if var_3_0 and var_3_0 ~= var_3_2 then
			return Testify.RETRY
		end

		local var_3_3 = arg_3_0:game_mode()

		if not var_3_3 then
			return Testify.RETRY
		end

		if var_3_3:game_mode_state() ~= var_3_1 then
			return Testify.RETRY
		end
	end,
	wait_for_transition_state = function(arg_4_0, arg_4_1)
		if arg_4_0:wanted_transition() ~= arg_4_1 then
			return Testify.RETRY
		end
	end
}
