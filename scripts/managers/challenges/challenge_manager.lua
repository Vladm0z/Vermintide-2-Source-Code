-- chunkname: @scripts/managers/challenges/challenge_manager.lua

require("scripts/managers/challenges/in_game_challenge")
require("scripts/managers/challenges/in_game_challenge_templates")
require("scripts/managers/challenges/in_game_challenge_rewards")

ChallengeManager = class(ChallengeManager)

local num = 255

ChallengeManager.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._statistics_db = arg_1_1
	self._is_server = arg_1_2
	self._all_challenges = {}
	self._completed_challenges = {}

	if not arg_1_2 then
		local var_1_0 = num
		local new_array = Script.new_array(num)

		for i = 1, var_1_0 do
			new_array[i] = i
		end

		self._free_ids = new_array
	end
end

ChallengeManager.destroy = function (self)
	-- function 2
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		_all_challenges[i]:cancel()
	end

	table.clear(self._all_challenges)
	table.clear(self._completed_challenges)
	self:unregister_rpcs()
end

ChallengeManager.on_round_start = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:register_rpcs(arg_3_1)

	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		_all_challenges[i]:on_round_start()
	end
end

ChallengeManager.on_round_end = function (self)
	-- function 4
	if not self._is_server then
		local _all_challenges = self._all_challenges

		for i = 1, #_all_challenges do
			_all_challenges[i]:cancel()
		end

		table.clear(self._all_challenges)
	else
		local _all_challenges_2 = self._all_challenges

		for j = 1, #_all_challenges_2 do
			_all_challenges_2[j]:on_round_end()
		end
	end

	self:unregister_rpcs()
end

ChallengeManager.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _all_challenges = self._all_challenges

	for i = #_all_challenges, 1, -1 do
		local var_5_1 = _all_challenges[i]

		if not var_5_1:pending_cleanup() then
			if not (not var_5_1:is_repeatable() and var_5_1:get_result() == InGameChallengeResult.Canceled) then
				var_5_1:reset(true)
			else
				if not self._is_server then
					table.insert(self._free_ids, var_5_1:get_unique_id())
				end

				table.swap_delete(_all_challenges, i)
			end
		elseif not var_5_1:has_ended() then
			if var_5_1:get_result() == InGameChallengeResult.Completed then
				self._completed_challenges[#self._completed_challenges + 1] = var_5_1

				Managers.state.event:trigger("on_challenge_completed", var_5_1:get_category(), var_5_1:get_challenge_name())
			end

			var_5_1:mark_for_cleanup()
		end

		if not self._is_server and not var_5_1:needs_sync(true) then
			local get_unique_id = var_5_1:get_unique_id()
			local get_progress = var_5_1:get_progress()
			local my_index = var_5_1:get_status().my_index
			local my_index_2 = var_5_1:get_result().my_index

			Managers.state.network.network_transmit:send_rpc_clients("rpc_server_update_ingame_challenge", get_unique_id, get_progress, my_index, my_index_2)
		end
	end
end

ChallengeManager.add_challenge = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	if not self._is_server then
		local reserve_free_unique_id = self:reserve_free_unique_id()
		local var_6_1 = InGameChallenge:new(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, self._is_server, arg_6_6, reserve_free_unique_id, arg_6_7)

		var_6_1:start()
		table.insert(self._all_challenges, var_6_1)

		local var_6_2 = NetworkLookup.challenges[arg_6_1]
		local var_6_3 = NetworkLookup.challenge_categories[arg_6_3]
		local var_6_4 = NetworkLookup.challenge_rewards[arg_6_4]
		local split_unique_player_id, var_6_6 = PlayerUtils.split_unique_player_id(arg_6_5)
		local get_progress, var_6_8 = var_6_1:get_progress()

		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_add_ingame_challenge", reserve_free_unique_id, var_6_2, arg_6_2, var_6_3, var_6_4, split_unique_player_id, var_6_6, var_6_8)

		return var_6_1
	end
end

ChallengeManager.remove_challenge = function (self, arg_7_1)
	-- function 7
	if not self._is_server and not arg_7_1 then
		arg_7_1:cancel()
	end
end

ChallengeManager.get_challenge_from_unique_id = function (self, arg_8_1)
	-- function 8
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		if _all_challenges[i]:get_unique_id() == arg_8_1 then
			return _all_challenges[i]
		end
	end

	return nil
end

local tbl = {}

ChallengeManager.remove_filtered_challenges = function (self, arg_9_1, arg_9_2)
	-- function 9
	table.clear(tbl)

	local _all_challenges = self._all_challenges
	local _completed_challenges = self._completed_challenges

	for i = 1, #_all_challenges do
		local var_9_2 = _all_challenges[i]
		local flag = not arg_9_1 and var_9_2:get_category() == arg_9_1

		flag = not flag and not arg_9_2 and var_9_2:belongs_to(arg_9_2)

		if not flag then
			tbl[#tbl + 1] = var_9_2
		end
	end

	for j = 1, #_completed_challenges do
		local var_9_4 = _completed_challenges[j]
		local flag_2 = not arg_9_1 and var_9_4:get_category() == arg_9_1

		flag_2 = not flag_2 and not arg_9_2 and var_9_4:belongs_to(arg_9_2)

		if not flag_2 then
			tbl[#tbl + 1] = var_9_4
		end
	end

	for i_2, v in ipairs(tbl) do
		local index_of = table.index_of(_all_challenges, v)
		local index_of_2 = table.index_of(_completed_challenges, v)

		if not index_of_2 then
			table.swap_delete(_completed_challenges, index_of_2)
		end

		self:_cancel_challenge_instant(v)
	end
end

ChallengeManager.get_all_challenges = function (self)
	-- function 10
	return self._all_challenges
end

ChallengeManager.get_challenges_filtered = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	fassert(arg_11_1, "Missing mandatory table (array) argument 'results'")

	local _all_challenges = self._all_challenges
	local count = #arg_11_1

	for i = 1, #_all_challenges do
		local var_11_2 = _all_challenges[i]
		local flag = not arg_11_2 and var_11_2:get_category() == arg_11_2

		flag = not flag and not arg_11_3 and var_11_2:belongs_to(arg_11_3)

		if not flag then
			count = count + 1
			arg_11_1[count] = var_11_2
		end
	end

	return arg_11_1, count
end

ChallengeManager.get_all_completed_challenges = function (self)
	-- function 12
	return self._completed_challenges
end

ChallengeManager.get_completed_challenges_filtered = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	fassert(arg_13_1, "Missing mandatory table (array) argument 'results'")

	local _completed_challenges = self._completed_challenges
	local count = #arg_13_1

	for i = 1, #_completed_challenges do
		local var_13_2 = _completed_challenges[i]
		local flag = not arg_13_2 and var_13_2:get_category() == arg_13_2

		flag = not flag and not arg_13_3 and var_13_2:belongs_to(arg_13_3)

		if not flag then
			count = count + 1
			arg_13_1[count] = var_13_2
		end
	end

	return arg_13_1, count
end

ChallengeManager.on_player_joined_party = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local unique_player_id = PlayerUtils.unique_player_id(arg_14_1, arg_14_2)
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		local var_14_2 = _all_challenges[i]

		if not var_14_2:belongs_to(unique_player_id) and not var_14_2:auto_resume() then
			var_14_2:set_paused(false)
		end
	end
end

ChallengeManager.on_player_left_party = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local unique_player_id = PlayerUtils.unique_player_id(arg_15_1, arg_15_2)
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		local var_15_2 = _all_challenges[i]

		if not var_15_2:belongs_to(unique_player_id) then
			var_15_2:set_paused(true)
		end
	end
end

ChallengeManager.profile_changed = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local unique_player_id = PlayerUtils.unique_player_id(arg_16_1, arg_16_2)
	local affiliation = SPProfiles[arg_16_3].affiliation
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		local var_16_3 = _all_challenges[i]

		if not var_16_3:belongs_to(unique_player_id) then
			local flag = affiliation ~= "heroes"

			var_16_3:set_paused(flag)
		end
	end
end

ChallengeManager.on_bot_added = function (self, arg_17_1)
	-- function 17
	self:player_entered_game_session(arg_17_1:network_id(), arg_17_1:local_player_id())
end

ChallengeManager.on_bot_removed = function (self, arg_18_1)
	-- function 18
	self:player_left_game_session(arg_18_1:network_id(), arg_18_1:local_player_id())
end

local num_2 = 5

ChallengeManager.reserve_free_unique_id = function (self)
	-- function 19
	local _free_ids = self._free_ids
	local count = #_free_ids

	if count == 0 then
		count = self:_cleanup_orphanated_challenge_ids(num_2)
	end

	fassert(count > 0, "Ran out of unique ids, %i / %i (leak or too many challenges?)", #self._all_challenges, num)

	local var_19_2 = _free_ids[1]

	table.swap_delete(_free_ids, 1)

	return var_19_2
end

ChallengeManager._cleanup_orphanated_challenge_ids = function (self, arg_20_1)
	-- function 20
	local tbl = {}
	local num = 0
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		local var_20_3 = _all_challenges[i]

		if not var_20_3.paused_t then
			num = num + 1
			tbl[num] = var_20_3
		end
	end

	if num > 0 then
		if arg_20_1 < num then
			table.sort(tbl, function (self, arg_21_1)
				-- function 21
				return self.paused_t < arg_21_1.paused_t
			end)
		end

		local min = math.min(arg_20_1, num)

		for j = 1, min do
			local var_20_5 = tbl[j]

			self:_cancel_challenge_instant(var_20_5)
		end

		return min
	end

	return 0
end

ChallengeManager._cancel_challenge_instant = function (self, arg_22_1)
	-- function 22
	arg_22_1:cancel()

	local get_unique_id = arg_22_1:get_unique_id()

	Managers.state.network.network_transmit:send_rpc_clients("rpc_server_remove_ingame_challenge", get_unique_id)
	table.insert(self._free_ids, arg_22_1:get_unique_id())

	local _all_challenges = self._all_challenges
	local index_of = table.index_of(_all_challenges, arg_22_1)

	table.swap_delete(_all_challenges, index_of)
end

local tbl_2 = {
	"rpc_server_add_ingame_challenge",
	"rpc_server_remove_ingame_challenge",
	"rpc_server_update_ingame_challenge",
	"rpc_server_hot_join_sync_ingame_challenge"
}

ChallengeManager.register_rpcs = function (self, arg_23_1)
	-- function 23
	if not self._network_event_delegate then
		self._network_event_delegate = arg_23_1

		arg_23_1:register(self, unpack(tbl_2))
	end
end

ChallengeManager.unregister_rpcs = function (self)
	-- function 24
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

ChallengeManager.hot_join_sync = function (self, arg_25_1)
	-- function 25
	local _all_challenges = self._all_challenges

	for i = 1, #_all_challenges do
		local var_25_1 = _all_challenges[i]
		local get_unique_id = var_25_1:get_unique_id()
		local get_challenge_name = var_25_1:get_challenge_name()
		local var_25_4 = NetworkLookup.challenges[get_challenge_name]
		local is_repeatable = var_25_1:is_repeatable()
		local get_category = var_25_1:get_category()
		local var_25_7 = NetworkLookup.challenge_categories[get_category]
		local get_reward_name = var_25_1:get_reward_name()
		local var_25_9 = NetworkLookup.challenge_rewards[get_reward_name]
		local get_owner_unique_id = var_25_1:get_owner_unique_id()
		local split_unique_player_id, var_25_12 = PlayerUtils.split_unique_player_id(get_owner_unique_id)
		local get_progress, var_25_14 = var_25_1:get_progress()
		local my_index = var_25_1:get_status().my_index
		local my_index_2 = var_25_1:get_result().my_index

		Managers.state.network.network_transmit:send_rpc("rpc_server_hot_join_sync_ingame_challenge", arg_25_1, get_unique_id, var_25_4, is_repeatable, var_25_7, var_25_9, split_unique_player_id, var_25_12, get_progress, var_25_14, my_index, my_index_2)
	end
end

ChallengeManager.rpc_server_add_ingame_challenge = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	-- function 26
	local var_26_0 = NetworkLookup.challenges[arg_26_3]
	local var_26_1 = NetworkLookup.challenge_categories[arg_26_5]
	local var_26_2 = NetworkLookup.challenge_rewards[arg_26_6]
	local unique_player_id = PlayerUtils.unique_player_id(arg_26_7, arg_26_8)
	local var_26_4 = InGameChallenge:new(var_26_0, arg_26_4, var_26_1, var_26_2, unique_player_id, self._is_server, arg_26_9, arg_26_2, false)

	var_26_4:start()
	table.insert(self._all_challenges, var_26_4)
end

ChallengeManager.rpc_server_remove_ingame_challenge = function (self, arg_27_1, arg_27_2)
	-- function 27
	local get_challenge_from_unique_id = self:get_challenge_from_unique_id(arg_27_2)

	if not get_challenge_from_unique_id then
		get_challenge_from_unique_id:cancel()

		local _all_challenges = self._all_challenges
		local index_of = table.index_of(_all_challenges, get_challenge_from_unique_id)

		table.swap_delete(_all_challenges, index_of)
	end
end

ChallengeManager.rpc_server_update_ingame_challenge = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	local get_challenge_from_unique_id = self:get_challenge_from_unique_id(arg_28_2)

	if not get_challenge_from_unique_id then
		get_challenge_from_unique_id:client_update(arg_28_3, arg_28_4, arg_28_5)
	end
end

ChallengeManager.rpc_server_hot_join_sync_ingame_challenge = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_10, arg_29_11, arg_29_12)
	-- function 29
	local var_29_0 = NetworkLookup.challenges[arg_29_3]
	local var_29_1 = NetworkLookup.challenge_categories[arg_29_5]
	local var_29_2 = NetworkLookup.challenge_rewards[arg_29_6]
	local unique_player_id = PlayerUtils.unique_player_id(arg_29_7, arg_29_8)
	local var_29_4 = InGameChallenge:new(var_29_0, arg_29_4, var_29_1, var_29_2, unique_player_id, self._is_server, arg_29_10, arg_29_2, false)

	var_29_4:start()
	var_29_4:client_update(arg_29_9, arg_29_11, arg_29_12)
	table.insert(self._all_challenges, var_29_4)
end
