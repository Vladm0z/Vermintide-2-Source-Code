-- chunkname: @scripts/settings/mutators/mutator_challenge_test.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local var_0_0 = {
	reward = "deus_power_up_quest_test_reward_01",
	type = "kill_elites",
	category = "deus_mutator",
	amount = {
		1,
		7,
		7,
		10,
		10,
		15,
		15,
		15
	}
}

return {
	server_start_function = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = Managers.venture.challenge
		local var_1_1 = Managers.state.difficulty:get_difficulty()
		local var_1_2 = DifficultySettings[var_1_1].rank
		local var_1_3 = var_0_0.reward
		local var_1_4 = false
		local var_1_5 = var_0_0.category
		local var_1_6 = Managers.player:local_player():unique_id()
		local var_1_7 = false

		arg_1_1.challenge = var_1_0:add_challenge(var_0_0.type, var_1_4, var_1_5, var_1_3, var_1_6, var_0_0.amount[var_1_2], var_1_7)
	end,
	server_stop_function = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = arg_2_1.challenge

		if var_2_0 then
			Managers.venture.challenge:remove_challenge(var_2_0)
		end
	end
}
