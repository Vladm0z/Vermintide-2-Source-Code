-- chunkname: @scripts/managers/difficulty/difficulty_manager.lua

require("scripts/settings/difficulty_settings")

DifficultyManager = class(DifficultyManager)

function DifficultyManager.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.world = arg_1_1
	arg_1_0.is_server = arg_1_2
	arg_1_0.network_event_delegate = arg_1_3
	arg_1_0._lobby = arg_1_4

	arg_1_3:register(arg_1_0, "rpc_set_difficulty")

	arg_1_0.difficulty = nil
	arg_1_0.fallback_difficulty = nil
	arg_1_0.difficulty_setting = nil
	arg_1_0.difficulty_tweak = 0
end

function DifficultyManager.set_difficulty(arg_2_0, arg_2_1, arg_2_2)
	fassert(arg_2_2 and arg_2_2 >= -10 and arg_2_2 <= 10, "tweak must be a number from -10 to 10")

	if arg_2_1 == "versus_base" then
		arg_2_2 = 0
	end

	arg_2_0.difficulty = arg_2_1
	arg_2_0.difficulty_setting = DifficultySettings[arg_2_1]
	arg_2_0.difficulty_rank = arg_2_0.difficulty_setting.rank
	arg_2_0.fallback_difficulty = arg_2_0.difficulty_setting.fallback_difficulty
	arg_2_0.difficulty_tweak = arg_2_2

	SET_BREED_DIFFICULTY(arg_2_1)

	if arg_2_0.is_server then
		local var_2_0 = arg_2_0._lobby:get_stored_lobby_data()

		var_2_0.difficulty = arg_2_1
		var_2_0.difficulty_tweak = arg_2_2

		arg_2_0._lobby:set_lobby_data(var_2_0)

		local var_2_1 = Managers.state.network

		if var_2_1 then
			local var_2_2 = var_2_1.network_transmit
			local var_2_3 = NetworkLookup.difficulties[arg_2_0.difficulty]

			var_2_2:send_rpc_clients("rpc_set_difficulty", var_2_3, arg_2_2, false)
		end
	end
end

function DifficultyManager.get_default_difficulties(arg_3_0)
	return DefaultDifficulties, DefaultStartingDifficulty
end

function DifficultyManager.get_difficulty(arg_4_0)
	return arg_4_0.difficulty, arg_4_0.difficulty_tweak
end

function DifficultyManager.get_difficulty_rank(arg_5_0)
	return arg_5_0.difficulty_rank, arg_5_0.difficulty_tweak
end

function DifficultyManager.get_difficulty_settings(arg_6_0)
	return arg_6_0.difficulty_setting
end

function DifficultyManager.get_difficulty_value_from_table(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.difficulty
	local var_7_1 = arg_7_1[var_7_0]

	if var_7_1 then
		return var_7_1
	end

	return arg_7_1[DifficultySettings[var_7_0].fallback_difficulty]
end

function DifficultyManager.get_difficulty_index(arg_8_0)
	return table.index_of(DefaultDifficulties, arg_8_0.difficulty)
end

function DifficultyManager.hot_join_sync(arg_9_0, arg_9_1)
	local var_9_0 = Managers.state.network.network_transmit
	local var_9_1 = NetworkLookup.difficulties[arg_9_0.difficulty]

	var_9_0:send_rpc("rpc_set_difficulty", arg_9_1, var_9_1, arg_9_0.difficulty_tweak, true)
end

function DifficultyManager.destroy(arg_10_0)
	arg_10_0.network_event_delegate:unregister(arg_10_0)
end

function DifficultyManager.rpc_set_difficulty(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = NetworkLookup.difficulties[arg_11_2]

	arg_11_0:set_difficulty(var_11_0, arg_11_3)

	if arg_11_4 then
		Managers.state.event:trigger("difficulty_synced")
	end
end

local var_0_0 = {}

function DifficultyManager.players_below_required_power_level(arg_12_0, arg_12_1)
	table.clear(var_0_0)

	local var_12_0 = DifficultySettings[arg_12_0].required_power_level

	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		if iter_12_1:sync_data_active() and var_12_0 > iter_12_1:get_data("best_aquired_power_level") then
			var_0_0[#var_0_0 + 1] = iter_12_1
		end
	end

	return var_0_0
end

local var_0_1 = {}

function DifficultyManager.players_locked_difficulty_rank(arg_13_0, arg_13_1)
	table.clear(var_0_1)

	local var_13_0 = DifficultySettings[arg_13_0]

	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		if iter_13_1:sync_data_active() then
			local var_13_1 = iter_13_1:get_data("highest_unlocked_difficulty")
			local var_13_2 = NetworkLookup.difficulties[var_13_1]

			if DifficultySettings[var_13_2].rank < var_13_0.rank then
				var_0_1[#var_0_1 + 1] = iter_13_1
			end
		end
	end

	return var_0_1
end
