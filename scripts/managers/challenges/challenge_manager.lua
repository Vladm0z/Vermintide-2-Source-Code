-- chunkname: @scripts/managers/challenges/challenge_manager.lua

require("scripts/managers/challenges/in_game_challenge")
require("scripts/managers/challenges/in_game_challenge_templates")
require("scripts/managers/challenges/in_game_challenge_rewards")

ChallengeManager = class(ChallengeManager)

local var_0_0 = 255

function ChallengeManager.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._statistics_db = arg_1_1
	arg_1_0._is_server = arg_1_2
	arg_1_0._all_challenges = {}
	arg_1_0._completed_challenges = {}

	if arg_1_2 then
		local var_1_0 = var_0_0
		local var_1_1 = Script.new_array(var_0_0)

		for iter_1_0 = 1, var_1_0 do
			var_1_1[iter_1_0] = iter_1_0
		end

		arg_1_0._free_ids = var_1_1
	end
end

function ChallengeManager.destroy(arg_2_0)
	local var_2_0 = arg_2_0._all_challenges

	for iter_2_0 = 1, #var_2_0 do
		var_2_0[iter_2_0]:cancel()
	end

	table.clear(arg_2_0._all_challenges)
	table.clear(arg_2_0._completed_challenges)
	arg_2_0:unregister_rpcs()
end

function ChallengeManager.on_round_start(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:register_rpcs(arg_3_1)

	local var_3_0 = arg_3_0._all_challenges

	for iter_3_0 = 1, #var_3_0 do
		var_3_0[iter_3_0]:on_round_start()
	end
end

function ChallengeManager.on_round_end(arg_4_0)
	if not arg_4_0._is_server then
		local var_4_0 = arg_4_0._all_challenges

		for iter_4_0 = 1, #var_4_0 do
			var_4_0[iter_4_0]:cancel()
		end

		table.clear(arg_4_0._all_challenges)
	else
		local var_4_1 = arg_4_0._all_challenges

		for iter_4_1 = 1, #var_4_1 do
			var_4_1[iter_4_1]:on_round_end()
		end
	end

	arg_4_0:unregister_rpcs()
end

function ChallengeManager.update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._all_challenges

	for iter_5_0 = #var_5_0, 1, -1 do
		local var_5_1 = var_5_0[iter_5_0]

		if var_5_1:pending_cleanup() then
			if var_5_1:is_repeatable() and var_5_1:get_result() ~= InGameChallengeResult.Canceled then
				var_5_1:reset(true)
			else
				if arg_5_0._is_server then
					table.insert(arg_5_0._free_ids, var_5_1:get_unique_id())
				end

				table.swap_delete(var_5_0, iter_5_0)
			end
		elseif var_5_1:has_ended() then
			if var_5_1:get_result() == InGameChallengeResult.Completed then
				arg_5_0._completed_challenges[#arg_5_0._completed_challenges + 1] = var_5_1

				Managers.state.event:trigger("on_challenge_completed", var_5_1:get_category(), var_5_1:get_challenge_name())
			end

			var_5_1:mark_for_cleanup()
		end

		if arg_5_0._is_server and var_5_1:needs_sync(true) then
			local var_5_2 = var_5_1:get_unique_id()
			local var_5_3 = var_5_1:get_progress()
			local var_5_4 = var_5_1:get_status().my_index
			local var_5_5 = var_5_1:get_result().my_index

			Managers.state.network.network_transmit:send_rpc_clients("rpc_server_update_ingame_challenge", var_5_2, var_5_3, var_5_4, var_5_5)
		end
	end
end

function ChallengeManager.add_challenge(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	if arg_6_0._is_server then
		local var_6_0 = arg_6_0:reserve_free_unique_id()
		local var_6_1 = InGameChallenge:new(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_0._is_server, arg_6_6, var_6_0, arg_6_7)

		var_6_1:start()
		table.insert(arg_6_0._all_challenges, var_6_1)

		local var_6_2 = NetworkLookup.challenges[arg_6_1]
		local var_6_3 = NetworkLookup.challenge_categories[arg_6_3]
		local var_6_4 = NetworkLookup.challenge_rewards[arg_6_4]
		local var_6_5, var_6_6 = PlayerUtils.split_unique_player_id(arg_6_5)
		local var_6_7, var_6_8 = var_6_1:get_progress()

		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_add_ingame_challenge", var_6_0, var_6_2, arg_6_2, var_6_3, var_6_4, var_6_5, var_6_6, var_6_8)

		return var_6_1
	end
end

function ChallengeManager.remove_challenge(arg_7_0, arg_7_1)
	if arg_7_0._is_server and arg_7_1 then
		arg_7_1:cancel()
	end
end

function ChallengeManager.get_challenge_from_unique_id(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._all_challenges

	for iter_8_0 = 1, #var_8_0 do
		if var_8_0[iter_8_0]:get_unique_id() == arg_8_1 then
			return var_8_0[iter_8_0]
		end
	end

	return nil
end

local var_0_1 = {}

function ChallengeManager.remove_filtered_challenges(arg_9_0, arg_9_1, arg_9_2)
	table.clear(var_0_1)

	local var_9_0 = arg_9_0._all_challenges
	local var_9_1 = arg_9_0._completed_challenges

	for iter_9_0 = 1, #var_9_0 do
		local var_9_2 = var_9_0[iter_9_0]
		local var_9_3 = not arg_9_1 or var_9_2:get_category() == arg_9_1

		var_9_3 = var_9_3 and (not arg_9_2 or var_9_2:belongs_to(arg_9_2))

		if var_9_3 then
			var_0_1[#var_0_1 + 1] = var_9_2
		end
	end

	for iter_9_1 = 1, #var_9_1 do
		local var_9_4 = var_9_1[iter_9_1]
		local var_9_5 = not arg_9_1 or var_9_4:get_category() == arg_9_1

		var_9_5 = var_9_5 and (not arg_9_2 or var_9_4:belongs_to(arg_9_2))

		if var_9_5 then
			var_0_1[#var_0_1 + 1] = var_9_4
		end
	end

	for iter_9_2, iter_9_3 in ipairs(var_0_1) do
		local var_9_6 = table.index_of(var_9_0, iter_9_3)
		local var_9_7 = table.index_of(var_9_1, iter_9_3)

		if var_9_7 then
			table.swap_delete(var_9_1, var_9_7)
		end

		arg_9_0:_cancel_challenge_instant(iter_9_3)
	end
end

function ChallengeManager.get_all_challenges(arg_10_0)
	return arg_10_0._all_challenges
end

function ChallengeManager.get_challenges_filtered(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	fassert(arg_11_1, "Missing mandatory table (array) argument 'results'")

	local var_11_0 = arg_11_0._all_challenges
	local var_11_1 = #arg_11_1

	for iter_11_0 = 1, #var_11_0 do
		local var_11_2 = var_11_0[iter_11_0]
		local var_11_3 = not arg_11_2 or var_11_2:get_category() == arg_11_2

		var_11_3 = var_11_3 and (not arg_11_3 or var_11_2:belongs_to(arg_11_3))

		if var_11_3 then
			var_11_1 = var_11_1 + 1
			arg_11_1[var_11_1] = var_11_2
		end
	end

	return arg_11_1, var_11_1
end

function ChallengeManager.get_all_completed_challenges(arg_12_0)
	return arg_12_0._completed_challenges
end

function ChallengeManager.get_completed_challenges_filtered(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	fassert(arg_13_1, "Missing mandatory table (array) argument 'results'")

	local var_13_0 = arg_13_0._completed_challenges
	local var_13_1 = #arg_13_1

	for iter_13_0 = 1, #var_13_0 do
		local var_13_2 = var_13_0[iter_13_0]
		local var_13_3 = not arg_13_2 or var_13_2:get_category() == arg_13_2

		var_13_3 = var_13_3 and (not arg_13_3 or var_13_2:belongs_to(arg_13_3))

		if var_13_3 then
			var_13_1 = var_13_1 + 1
			arg_13_1[var_13_1] = var_13_2
		end
	end

	return arg_13_1, var_13_1
end

function ChallengeManager.on_player_joined_party(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = PlayerUtils.unique_player_id(arg_14_1, arg_14_2)
	local var_14_1 = arg_14_0._all_challenges

	for iter_14_0 = 1, #var_14_1 do
		local var_14_2 = var_14_1[iter_14_0]

		if var_14_2:belongs_to(var_14_0) and var_14_2:auto_resume() then
			var_14_2:set_paused(false)
		end
	end
end

function ChallengeManager.on_player_left_party(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = PlayerUtils.unique_player_id(arg_15_1, arg_15_2)
	local var_15_1 = arg_15_0._all_challenges

	for iter_15_0 = 1, #var_15_1 do
		local var_15_2 = var_15_1[iter_15_0]

		if var_15_2:belongs_to(var_15_0) then
			var_15_2:set_paused(true)
		end
	end
end

function ChallengeManager.profile_changed(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = PlayerUtils.unique_player_id(arg_16_1, arg_16_2)
	local var_16_1 = SPProfiles[arg_16_3].affiliation
	local var_16_2 = arg_16_0._all_challenges

	for iter_16_0 = 1, #var_16_2 do
		local var_16_3 = var_16_2[iter_16_0]

		if var_16_3:belongs_to(var_16_0) then
			local var_16_4 = var_16_1 ~= "heroes"

			var_16_3:set_paused(var_16_4)
		end
	end
end

function ChallengeManager.on_bot_added(arg_17_0, arg_17_1)
	arg_17_0:player_entered_game_session(arg_17_1:network_id(), arg_17_1:local_player_id())
end

function ChallengeManager.on_bot_removed(arg_18_0, arg_18_1)
	arg_18_0:player_left_game_session(arg_18_1:network_id(), arg_18_1:local_player_id())
end

local var_0_2 = 5

function ChallengeManager.reserve_free_unique_id(arg_19_0)
	local var_19_0 = arg_19_0._free_ids
	local var_19_1 = #var_19_0

	if var_19_1 == 0 then
		var_19_1 = arg_19_0:_cleanup_orphanated_challenge_ids(var_0_2)
	end

	fassert(var_19_1 > 0, "Ran out of unique ids, %i / %i (leak or too many challenges?)", #arg_19_0._all_challenges, var_0_0)

	local var_19_2 = var_19_0[1]

	table.swap_delete(var_19_0, 1)

	return var_19_2
end

function ChallengeManager._cleanup_orphanated_challenge_ids(arg_20_0, arg_20_1)
	local var_20_0 = {}
	local var_20_1 = 0
	local var_20_2 = arg_20_0._all_challenges

	for iter_20_0 = 1, #var_20_2 do
		local var_20_3 = var_20_2[iter_20_0]

		if var_20_3.paused_t then
			var_20_1 = var_20_1 + 1
			var_20_0[var_20_1] = var_20_3
		end
	end

	if var_20_1 > 0 then
		if arg_20_1 < var_20_1 then
			table.sort(var_20_0, function(arg_21_0, arg_21_1)
				return arg_21_0.paused_t < arg_21_1.paused_t
			end)
		end

		local var_20_4 = math.min(arg_20_1, var_20_1)

		for iter_20_1 = 1, var_20_4 do
			local var_20_5 = var_20_0[iter_20_1]

			arg_20_0:_cancel_challenge_instant(var_20_5)
		end

		return var_20_4
	end

	return 0
end

function ChallengeManager._cancel_challenge_instant(arg_22_0, arg_22_1)
	arg_22_1:cancel()

	local var_22_0 = arg_22_1:get_unique_id()

	Managers.state.network.network_transmit:send_rpc_clients("rpc_server_remove_ingame_challenge", var_22_0)
	table.insert(arg_22_0._free_ids, arg_22_1:get_unique_id())

	local var_22_1 = arg_22_0._all_challenges
	local var_22_2 = table.index_of(var_22_1, arg_22_1)

	table.swap_delete(var_22_1, var_22_2)
end

local var_0_3 = {
	"rpc_server_add_ingame_challenge",
	"rpc_server_remove_ingame_challenge",
	"rpc_server_update_ingame_challenge",
	"rpc_server_hot_join_sync_ingame_challenge"
}

function ChallengeManager.register_rpcs(arg_23_0, arg_23_1)
	if not arg_23_0._network_event_delegate then
		arg_23_0._network_event_delegate = arg_23_1

		arg_23_1:register(arg_23_0, unpack(var_0_3))
	end
end

function ChallengeManager.unregister_rpcs(arg_24_0)
	if arg_24_0._network_event_delegate then
		arg_24_0._network_event_delegate:unregister(arg_24_0)

		arg_24_0._network_event_delegate = nil
	end
end

function ChallengeManager.hot_join_sync(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._all_challenges

	for iter_25_0 = 1, #var_25_0 do
		local var_25_1 = var_25_0[iter_25_0]
		local var_25_2 = var_25_1:get_unique_id()
		local var_25_3 = var_25_1:get_challenge_name()
		local var_25_4 = NetworkLookup.challenges[var_25_3]
		local var_25_5 = var_25_1:is_repeatable()
		local var_25_6 = var_25_1:get_category()
		local var_25_7 = NetworkLookup.challenge_categories[var_25_6]
		local var_25_8 = var_25_1:get_reward_name()
		local var_25_9 = NetworkLookup.challenge_rewards[var_25_8]
		local var_25_10 = var_25_1:get_owner_unique_id()
		local var_25_11, var_25_12 = PlayerUtils.split_unique_player_id(var_25_10)
		local var_25_13, var_25_14 = var_25_1:get_progress()
		local var_25_15 = var_25_1:get_status().my_index
		local var_25_16 = var_25_1:get_result().my_index

		Managers.state.network.network_transmit:send_rpc("rpc_server_hot_join_sync_ingame_challenge", arg_25_1, var_25_2, var_25_4, var_25_5, var_25_7, var_25_9, var_25_11, var_25_12, var_25_13, var_25_14, var_25_15, var_25_16)
	end
end

function ChallengeManager.rpc_server_add_ingame_challenge(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	local var_26_0 = NetworkLookup.challenges[arg_26_3]
	local var_26_1 = NetworkLookup.challenge_categories[arg_26_5]
	local var_26_2 = NetworkLookup.challenge_rewards[arg_26_6]
	local var_26_3 = PlayerUtils.unique_player_id(arg_26_7, arg_26_8)
	local var_26_4 = InGameChallenge:new(var_26_0, arg_26_4, var_26_1, var_26_2, var_26_3, arg_26_0._is_server, arg_26_9, arg_26_2, false)

	var_26_4:start()
	table.insert(arg_26_0._all_challenges, var_26_4)
end

function ChallengeManager.rpc_server_remove_ingame_challenge(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0:get_challenge_from_unique_id(arg_27_2)

	if var_27_0 then
		var_27_0:cancel()

		local var_27_1 = arg_27_0._all_challenges
		local var_27_2 = table.index_of(var_27_1, var_27_0)

		table.swap_delete(var_27_1, var_27_2)
	end
end

function ChallengeManager.rpc_server_update_ingame_challenge(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_0:get_challenge_from_unique_id(arg_28_2)

	if var_28_0 then
		var_28_0:client_update(arg_28_3, arg_28_4, arg_28_5)
	end
end

function ChallengeManager.rpc_server_hot_join_sync_ingame_challenge(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_10, arg_29_11, arg_29_12)
	local var_29_0 = NetworkLookup.challenges[arg_29_3]
	local var_29_1 = NetworkLookup.challenge_categories[arg_29_5]
	local var_29_2 = NetworkLookup.challenge_rewards[arg_29_6]
	local var_29_3 = PlayerUtils.unique_player_id(arg_29_7, arg_29_8)
	local var_29_4 = InGameChallenge:new(var_29_0, arg_29_4, var_29_1, var_29_2, var_29_3, arg_29_0._is_server, arg_29_10, arg_29_2, false)

	var_29_4:start()
	var_29_4:client_update(arg_29_9, arg_29_11, arg_29_12)
	table.insert(arg_29_0._all_challenges, var_29_4)
end
