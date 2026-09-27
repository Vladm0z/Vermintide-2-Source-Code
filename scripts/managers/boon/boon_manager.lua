-- chunkname: @scripts/managers/boon/boon_manager.lua

require("scripts/managers/challenges/in_game_challenge_rewards")

BoonManager = class(BoonManager)

local function fn(arg_1_0)
	-- function 1
	return true
end

local function fn_2(self, arg_2_1)
	-- function 2
	if not (not arg_2_1 and self) then
		return self
	end

	for i = #self, 1, -1 do
		if table.index_of(arg_2_1, self[i]) == -1 then
			table.swap_delete(self, i)
		end
	end

	return self
end

BoonManager.init = function (self)
	-- function 3
	self._network_event_delegate = nil
	self._boons = {}
	self._spawned_players_queue = {}
	self._unique_id = 0
end

BoonManager.destroy = function (self)
	-- function 4
	self:unregister_rpcs()
end

local tbl = {}

BoonManager.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _spawned_players_queue = self._spawned_players_queue
	local count = #_spawned_players_queue
	local _boons = self._boons

	for i = 1, count do
		tbl[1] = _spawned_players_queue[i]

		for j = 1, #_boons do
			self:_activate_boon(_boons[j], tbl)
		end
	end

	table.clear_array(_spawned_players_queue, count)
end

BoonManager.add_boon = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _unique_id = self._unique_id

	self._unique_id = _unique_id + 1

	local tbl = {
		active = true,
		owner = arg_6_1,
		reward_id = arg_6_2,
		consume_type = arg_6_3,
		consume_value = arg_6_4,
		unique_id = _unique_id,
		reward_data = {},
		reactivation_rule = arg_6_5
	}

	if not (not fn(tbl) and self:_has_been_consumed(tbl)) then
		self:_activate_boon(tbl)

		if not self:_has_been_consumed(tbl) then
			self._boons[#self._boons + 1] = tbl
		end
	end
end

BoonManager._activate_boon = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get = MechanismOverrides.get(InGameChallengeRewards[arg_7_1.reward_id])

	if not get and not arg_7_1.active then
		local var_7_1 = fn_2(InGameChallengeRewardTargets[get.target](arg_7_1.owner), arg_7_2)

		if not var_7_1 then
			local count = #var_7_1

			if count > 0 then
				if arg_7_1.consume_type == "charges" then
					local min = math.min(count, arg_7_1.consume_value)

					for i = min, arg_7_1.consume_value, -1 do
						var_7_1[i] = nil
					end

					arg_7_1.consume_value = arg_7_1.consume_value - min

					if not self:_has_been_consumed(arg_7_1) then
						self:remove_boon(arg_7_1.unique_id)
					end
				end

				local var_7_4 = InGameChallengeRewardTypes[get.type](get, var_7_1, arg_7_1.owner)

				if not var_7_4 then
					table.merge(arg_7_1.reward_data, var_7_4)
				end
			end
		end
	end
end

BoonManager._deactivate_boon = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local get = MechanismOverrides.get(InGameChallengeRewards[arg_8_1.reward_id])

	if not get and not arg_8_1.reward_data then
		local var_8_1 = fn_2(InGameChallengeRewardTargets[get.target](arg_8_1.owner), arg_8_2)

		if not (not var_8_1 and not (#var_8_1 > 0)) then
			local var_8_2 = InGameChallengeRewardRevokeTypes[get.type]

			if not var_8_2 then
				var_8_2(get, var_8_1, arg_8_1.owner, arg_8_1.reward_data)

				arg_8_1.reward_data = {}
			end
		end
	end
end

BoonManager._activate_player_boons = function (self, arg_9_1, arg_9_2)
	-- function 9
	local unique_player_id = PlayerUtils.unique_player_id(arg_9_1, arg_9_2)
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_player_unique_id(unique_player_id).PLAYER_AND_BOT_UNITS
	local _boons = self._boons

	for i = 1, #_boons do
		local var_9_3 = _boons[i]

		if var_9_3.owner ~= unique_player_id or not (not var_9_3.reactivation_rule and var_9_3.reactivation_rule(unique_player_id)) then
			_boons[i].active = true

			self:_activate_boon(_boons[i], PLAYER_AND_BOT_UNITS)
		end
	end
end

BoonManager._deactivate_player_boons = function (self, arg_10_1, arg_10_2)
	-- function 10
	local unique_player_id = PlayerUtils.unique_player_id(arg_10_1, arg_10_2)
	local get_party_from_player_id = Managers.party:get_party_from_player_id(arg_10_1, arg_10_2)
	local flag = not get_party_from_player_id and Managers.state.side.side_by_party[get_party_from_player_id]
	local flag_2 = not flag and flag.PLAYER_AND_BOT_UNITS
	local _boons = self._boons

	for i = 1, #_boons do
		if _boons[i].owner == unique_player_id then
			self:_deactivate_boon(_boons[i], flag_2)

			_boons[i].active = false
		end
	end
end

BoonManager._has_been_consumed = function (arg_11_0, arg_11_1)
	-- function 11
	if arg_11_1.consume_type == "time" then
		return false
	else
		return arg_11_1.consume_value <= 0
	end
end

BoonManager.remove_boon = function (self, arg_12_1)
	-- function 12
	local _boons = self._boons

	for i = 1, #_boons do
		if _boons[i].unique_id == arg_12_1 then
			table.swap_delete(_boons, i)

			return
		end
	end
end

BoonManager.on_round_start = function (self, arg_13_1, arg_13_2)
	-- function 13
	arg_13_2:register(self, "new_player_unit", "on_player_spawned")
	arg_13_2:register(self, "on_player_joined_party", "on_player_joined_party")
	arg_13_2:register(self, "on_player_left_party", "on_player_left_party")
	arg_13_2:register(self, "on_clean_up_server_controlled_buffs", "on_clean_up_server_controlled_buffs")
	arg_13_2:register(self, "on_bot_added", "on_bot_added")
	arg_13_2:register(self, "on_bot_removed", "on_bot_removed")
	self:register_rpcs(arg_13_1)
end

BoonManager.on_round_end = function (self)
	-- function 14
	self:unregister_rpcs()
	table.clear_array(self._spawned_players_queue, #self._spawned_players_queue)

	local event = Managers.state.event

	event:unregister("on_clean_up_server_controlled_buffs", self)
	event:unregister("on_player_left_party", self)
	event:unregister("on_player_joined_party", self)
	event:unregister("new_player_unit", self)
	event:unregister("on_bot_added", self)
	event:unregister("on_bot_removed", self)

	local _boons = self._boons

	for i = #_boons, 1, -1 do
		local var_14_2 = _boons[i]

		if var_14_2.consume_type == "round" then
			var_14_2.consume_value = var_14_2.consume_value - 1
		end

		if not self:_has_been_consumed(var_14_2) then
			table.swap_delete(_boons, i)
		end
	end
end

BoonManager.on_venture_start = function (arg_15_0)
	-- function 15
	return
end

BoonManager.on_venture_end = function (self)
	-- function 16
	local _boons = self._boons

	for i = #_boons, 1, -1 do
		local var_16_1 = _boons[i]

		if var_16_1.consume_type == "venture" then
			var_16_1.consume_value = var_16_1.consume_value - 1
		end

		if not self:_has_been_consumed(var_16_1) then
			table.swap_delete(_boons, i)
		end
	end
end

BoonManager.on_player_spawned = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	arg_17_0._spawned_players_queue[#arg_17_0._spawned_players_queue + 1] = arg_17_2
end

BoonManager.on_player_joined_party = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	self:_activate_player_boons(arg_18_1, arg_18_2)
end

BoonManager.on_player_left_party = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	self:_deactivate_player_boons(arg_19_1, arg_19_2)
end

BoonManager.on_bot_added = function (self, arg_20_1)
	-- function 20
	self:_activate_player_boons(arg_20_1:network_id(), arg_20_1:local_player_id())
end

BoonManager.on_bot_removed = function (self, arg_21_1)
	-- function 21
	self:_deactivate_player_boons(arg_21_1:network_id(), arg_21_1:local_player_id())
end

BoonManager.on_clean_up_server_controlled_buffs = function (self, arg_22_1)
	-- function 22
	local _boons = self._boons

	for i = 1, #_boons do
		local var_22_1 = _boons[i]
		local get = MechanismOverrides.get(InGameChallengeRewards[var_22_1.reward_id])

		if not get and get.type ~= "buff" or not get.server_controlled then
			var_22_1.reward_data[arg_22_1] = nil
		end
	end
end

local tbl_2 = {}

BoonManager.register_rpcs = function (arg_23_0, arg_23_1)
	-- function 23
	return
end

BoonManager.unregister_rpcs = function (arg_24_0)
	-- function 24
	return
end
