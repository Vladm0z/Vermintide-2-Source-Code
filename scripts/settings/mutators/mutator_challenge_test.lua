-- chunkname: @scripts/settings/mutators/mutator_challenge_test.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local tbl = {
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
		-- function 1
		local challenge = Managers.venture.challenge
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local rank = DifficultySettings[get_difficulty].rank
		local reward = tbl.reward
		local flag = false
		local category = tbl.category
		local unique_id = Managers.player:local_player():unique_id()
		local flag_2 = false

		arg_1_1.challenge = challenge:add_challenge(tbl.type, flag, category, reward, unique_id, tbl.amount[rank], flag_2)
	end,
	server_stop_function = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		local challenge = arg_2_1.challenge

		if not challenge then
			Managers.venture.challenge:remove_challenge(challenge)
		end
	end
}
