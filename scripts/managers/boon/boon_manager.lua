-- chunkname: @scripts/managers/boon/boon_manager.lua

require("scripts/managers/challenges/in_game_challenge_rewards")

BoonManager = class(BoonManager)

local function var_0_0(arg_1_0)
	return true
end

local function var_0_1(arg_2_0, arg_2_1)
	if not arg_2_1 or not arg_2_0 then
		return arg_2_0
	end

	for iter_2_0 = #arg_2_0, 1, -1 do
		if table.index_of(arg_2_1, arg_2_0[iter_2_0]) == -1 then
			table.swap_delete(arg_2_0, iter_2_0)
		end
	end

	return arg_2_0
end

BoonManager.init = function (arg_3_0)
	arg_3_0._network_event_delegate = nil
	arg_3_0._boons = {}
	arg_3_0._spawned_players_queue = {}
	arg_3_0._unique_id = 0
end

BoonManager.destroy = function (arg_4_0)
	arg_4_0:unregister_rpcs()
end

local var_0_2 = {}

BoonManager.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._spawned_players_queue
	local var_5_1 = #var_5_0
	local var_5_2 = arg_5_0._boons

	for iter_5_0 = 1, var_5_1 do
		var_0_2[1] = var_5_0[iter_5_0]

		for iter_5_1 = 1, #var_5_2 do
			arg_5_0:_activate_boon(var_5_2[iter_5_1], var_0_2)
		end
	end

	table.clear_array(var_5_0, var_5_1)
end

BoonManager.add_boon = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._unique_id

	arg_6_0._unique_id = var_6_0 + 1

	local var_6_1 = {
		active = true,
		owner = arg_6_1,
		reward_id = arg_6_2,
		consume_type = arg_6_3,
		consume_value = arg_6_4,
		unique_id = var_6_0,
		reward_data = {},
		reactivation_rule = arg_6_5
	}

	if var_0_0(var_6_1) and not arg_6_0:_has_been_consumed(var_6_1) then
		arg_6_0:_activate_boon(var_6_1)

		if not arg_6_0:_has_been_consumed(var_6_1) then
			arg_6_0._boons[#arg_6_0._boons + 1] = var_6_1
		end
	end
end

BoonManager._activate_boon = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = MechanismOverrides.get(InGameChallengeRewards[arg_7_1.reward_id])

	if var_7_0 and arg_7_1.active then
		local var_7_1 = var_0_1(InGameChallengeRewardTargets[var_7_0.target](arg_7_1.owner), arg_7_2)

		if var_7_1 then
			local var_7_2 = #var_7_1

			if var_7_2 > 0 then
				if arg_7_1.consume_type == "charges" then
					local var_7_3 = math.min(var_7_2, arg_7_1.consume_value)

					for iter_7_0 = var_7_3, arg_7_1.consume_value, -1 do
						var_7_1[iter_7_0] = nil
					end

					arg_7_1.consume_value = arg_7_1.consume_value - var_7_3

					if arg_7_0:_has_been_consumed(arg_7_1) then
						arg_7_0:remove_boon(arg_7_1.unique_id)
					end
				end

				local var_7_4 = InGameChallengeRewardTypes[var_7_0.type](var_7_0, var_7_1, arg_7_1.owner)

				if var_7_4 then
					table.merge(arg_7_1.reward_data, var_7_4)
				end
			end
		end
	end
end

BoonManager._deactivate_boon = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = MechanismOverrides.get(InGameChallengeRewards[arg_8_1.reward_id])

	if var_8_0 and arg_8_1.reward_data then
		local var_8_1 = var_0_1(InGameChallengeRewardTargets[var_8_0.target](arg_8_1.owner), arg_8_2)

		if var_8_1 and #var_8_1 > 0 then
			local var_8_2 = InGameChallengeRewardRevokeTypes[var_8_0.type]

			if var_8_2 then
				var_8_2(var_8_0, var_8_1, arg_8_1.owner, arg_8_1.reward_data)

				arg_8_1.reward_data = {}
			end
		end
	end
end

BoonManager._activate_player_boons = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = PlayerUtils.unique_player_id(arg_9_1, arg_9_2)
	local var_9_1 = Managers.state.side:get_side_from_player_unique_id(var_9_0).PLAYER_AND_BOT_UNITS
	local var_9_2 = arg_9_0._boons

	for iter_9_0 = 1, #var_9_2 do
		local var_9_3 = var_9_2[iter_9_0]

		if var_9_3.owner == var_9_0 and (not var_9_3.reactivation_rule or var_9_3.reactivation_rule(var_9_0)) then
			var_9_2[iter_9_0].active = true

			arg_9_0:_activate_boon(var_9_2[iter_9_0], var_9_1)
		end
	end
end

BoonManager._deactivate_player_boons = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = PlayerUtils.unique_player_id(arg_10_1, arg_10_2)
	local var_10_1 = Managers.party:get_party_from_player_id(arg_10_1, arg_10_2)
	local var_10_2 = var_10_1 and Managers.state.side.side_by_party[var_10_1]
	local var_10_3 = var_10_2 and var_10_2.PLAYER_AND_BOT_UNITS
	local var_10_4 = arg_10_0._boons

	for iter_10_0 = 1, #var_10_4 do
		if var_10_4[iter_10_0].owner == var_10_0 then
			arg_10_0:_deactivate_boon(var_10_4[iter_10_0], var_10_3)

			var_10_4[iter_10_0].active = false
		end
	end
end

BoonManager._has_been_consumed = function (arg_11_0, arg_11_1)
	if arg_11_1.consume_type == "time" then
		return false
	else
		return arg_11_1.consume_value <= 0
	end
end

BoonManager.remove_boon = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._boons

	for iter_12_0 = 1, #var_12_0 do
		if var_12_0[iter_12_0].unique_id == arg_12_1 then
			table.swap_delete(var_12_0, iter_12_0)

			return
		end
	end
end

BoonManager.on_round_start = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_2:register(arg_13_0, "new_player_unit", "on_player_spawned")
	arg_13_2:register(arg_13_0, "on_player_joined_party", "on_player_joined_party")
	arg_13_2:register(arg_13_0, "on_player_left_party", "on_player_left_party")
	arg_13_2:register(arg_13_0, "on_clean_up_server_controlled_buffs", "on_clean_up_server_controlled_buffs")
	arg_13_2:register(arg_13_0, "on_bot_added", "on_bot_added")
	arg_13_2:register(arg_13_0, "on_bot_removed", "on_bot_removed")
	arg_13_0:register_rpcs(arg_13_1)
end

BoonManager.on_round_end = function (arg_14_0)
	arg_14_0:unregister_rpcs()
	table.clear_array(arg_14_0._spawned_players_queue, #arg_14_0._spawned_players_queue)

	local var_14_0 = Managers.state.event

	var_14_0:unregister("on_clean_up_server_controlled_buffs", arg_14_0)
	var_14_0:unregister("on_player_left_party", arg_14_0)
	var_14_0:unregister("on_player_joined_party", arg_14_0)
	var_14_0:unregister("new_player_unit", arg_14_0)
	var_14_0:unregister("on_bot_added", arg_14_0)
	var_14_0:unregister("on_bot_removed", arg_14_0)

	local var_14_1 = arg_14_0._boons

	for iter_14_0 = #var_14_1, 1, -1 do
		local var_14_2 = var_14_1[iter_14_0]

		if var_14_2.consume_type == "round" then
			var_14_2.consume_value = var_14_2.consume_value - 1
		end

		if arg_14_0:_has_been_consumed(var_14_2) then
			table.swap_delete(var_14_1, iter_14_0)
		end
	end
end

BoonManager.on_venture_start = function (arg_15_0)
	return
end

BoonManager.on_venture_end = function (arg_16_0)
	local var_16_0 = arg_16_0._boons

	for iter_16_0 = #var_16_0, 1, -1 do
		local var_16_1 = var_16_0[iter_16_0]

		if var_16_1.consume_type == "venture" then
			var_16_1.consume_value = var_16_1.consume_value - 1
		end

		if arg_16_0:_has_been_consumed(var_16_1) then
			table.swap_delete(var_16_0, iter_16_0)
		end
	end
end

BoonManager.on_player_spawned = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0._spawned_players_queue[#arg_17_0._spawned_players_queue + 1] = arg_17_2
end

BoonManager.on_player_joined_party = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	arg_18_0:_activate_player_boons(arg_18_1, arg_18_2)
end

BoonManager.on_player_left_party = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	arg_19_0:_deactivate_player_boons(arg_19_1, arg_19_2)
end

BoonManager.on_bot_added = function (arg_20_0, arg_20_1)
	arg_20_0:_activate_player_boons(arg_20_1:network_id(), arg_20_1:local_player_id())
end

BoonManager.on_bot_removed = function (arg_21_0, arg_21_1)
	arg_21_0:_deactivate_player_boons(arg_21_1:network_id(), arg_21_1:local_player_id())
end

BoonManager.on_clean_up_server_controlled_buffs = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._boons

	for iter_22_0 = 1, #var_22_0 do
		local var_22_1 = var_22_0[iter_22_0]
		local var_22_2 = MechanismOverrides.get(InGameChallengeRewards[var_22_1.reward_id])

		if var_22_2 and var_22_2.type == "buff" and var_22_2.server_controlled then
			var_22_1.reward_data[arg_22_1] = nil
		end
	end
end

local var_0_3 = {}

BoonManager.register_rpcs = function (arg_23_0, arg_23_1)
	return
end

BoonManager.unregister_rpcs = function (arg_24_0)
	return
end
