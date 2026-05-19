-- chunkname: @scripts/managers/backend_playfab/backend_interface_loot_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceLootPlayfab = class(BackendInterfaceLootPlayfab)

function BackendInterfaceLootPlayfab.init(arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._last_id = 0
	arg_1_0._loot_requests = {}
	arg_1_0._reward_poll_id = false
end

function BackendInterfaceLootPlayfab.ready(arg_2_0)
	return true
end

function BackendInterfaceLootPlayfab.update(arg_3_0, arg_3_1)
	return
end

function BackendInterfaceLootPlayfab._new_id(arg_4_0)
	arg_4_0._last_id = arg_4_0._last_id + 1

	return arg_4_0._last_id
end

function BackendInterfaceLootPlayfab.open_loot_chest(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0:_new_id()
	local var_5_1 = {
		hero_name = arg_5_1,
		playfab_id = arg_5_2,
		id = var_5_0,
		amount = arg_5_4 or 1,
		game_mode_key = arg_5_3
	}
	local var_5_2 = {
		FunctionName = "generateLootChestRewards",
		FunctionParameter = var_5_1
	}
	local var_5_3 = callback(arg_5_0, "loot_chest_rewards_request_cb", var_5_1)

	arg_5_0._backend_mirror:request_queue():enqueue(var_5_2, var_5_3, true)

	return var_5_0
end

function BackendInterfaceLootPlayfab.loot_chest_rewards_request_cb(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.FunctionResult
	local var_6_1 = var_6_0.items
	local var_6_2 = var_6_0.unlocked_weapon_skins
	local var_6_3 = var_6_0.new_weapon_skin_rewards
	local var_6_4 = var_6_0.new_cosmetics
	local var_6_5 = var_6_0.new_unlocked_weapon_poses
	local var_6_6 = var_6_0.updated_statistics
	local var_6_7 = var_6_0.consumed_chest
	local var_6_8 = var_6_7 and var_6_7.ItemInstanceId
	local var_6_9 = var_6_7 and var_6_7.RemainingUses
	local var_6_10 = #var_6_1
	local var_6_11 = {}
	local var_6_12 = arg_6_0._backend_mirror

	for iter_6_0 = 1, var_6_10 do
		local var_6_13 = var_6_1[iter_6_0]
		local var_6_14 = var_6_13.ItemInstanceId
		local var_6_15 = var_6_12:add_item(var_6_14, var_6_13)

		var_6_11[#var_6_11 + 1] = var_6_15 or var_6_14
	end

	if var_6_8 then
		if var_6_9 > 0 then
			var_6_12:update_item_field(var_6_8, "RemainingUses", var_6_9)
		else
			var_6_12:remove_item(var_6_8)
		end
	end

	if var_6_2 then
		for iter_6_1 = 1, #var_6_2 do
			var_6_12:add_unlocked_weapon_skin(var_6_2[iter_6_1])
		end
	end

	if var_6_3 then
		local var_6_16 = var_6_12:get_unlocked_weapon_skins()

		for iter_6_2 = 1, #var_6_3 do
			local var_6_17 = var_6_16[var_6_3[iter_6_2]]

			if var_6_17 then
				var_6_11[#var_6_11 + 1] = var_6_17
			end
		end
	end

	if var_6_4 then
		for iter_6_3 = 1, #var_6_4 do
			local var_6_18 = var_6_12:add_item(nil, {
				ItemId = var_6_4[iter_6_3]
			})

			if var_6_18 then
				var_6_11[#var_6_11 + 1] = var_6_18
			end
		end
	end

	if var_6_5 then
		for iter_6_4 = 1, #var_6_5 do
			local var_6_19 = var_6_12:add_item(nil, {
				ItemId = var_6_5[iter_6_4]
			})

			if var_6_19 then
				var_6_11[#var_6_11 + 1] = var_6_19
			end
		end
	end

	if var_6_6 then
		local var_6_20 = Managers.player and Managers.player:local_player_safe()
		local var_6_21 = Managers.player:statistics_db()

		if not var_6_20 or not var_6_21 then
			print("[BackendInterfaceLootPlayfab] Could not get statistics_db, skipping updating statistics...")
		else
			local var_6_22 = var_6_20:stats_id()

			for iter_6_5, iter_6_6 in pairs(var_6_6) do
				if not var_6_21.statistics[var_6_22][iter_6_5] then
					Application.warning("[BackendInterfaceLootPlayfab] updated_statistics " .. iter_6_5 .. " doesn't exist.")
				else
					var_6_21:set_stat(var_6_22, iter_6_5, iter_6_6)
				end
			end
		end
	end

	local var_6_23 = var_6_0.chest_inventory

	if var_6_23 then
		var_6_12:set_read_only_data("chest_inventory", var_6_23, true)
	end

	local var_6_24 = arg_6_1.id

	arg_6_0._loot_requests[var_6_24] = var_6_11
end

function BackendInterfaceLootPlayfab.generate_end_of_level_loot(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12, arg_7_13, arg_7_14, arg_7_15)
	local var_7_0 = arg_7_0:_new_id()
	local var_7_1 = arg_7_0:_get_remote_player_network_ids_and_characters()

	if arg_7_15.deus_soft_currency then
		arg_7_0._backend_mirror:predict_deus_rolled_over_soft_currency(arg_7_15.deus_soft_currency)
	end

	local var_7_2 = {
		won = arg_7_1,
		quick_play_bonus = arg_7_2,
		difficulty = arg_7_3,
		level_name = arg_7_4,
		loot_profile_name = arg_7_10,
		start_experience = arg_7_6,
		end_experience = arg_7_7,
		vs_start_experience = arg_7_8,
		vs_end_experience = arg_7_9,
		hero_name = arg_7_5,
		deed_item_name = arg_7_11,
		deed_backend_id = arg_7_12,
		id = var_7_0,
		remote_player_ids_and_characters = var_7_1,
		game_mode_key = arg_7_13,
		game_time = arg_7_14,
		end_of_level_rewards_arguments = arg_7_15
	}
	local var_7_3 = {
		FunctionName = "generateEndOfLevelLoot",
		FunctionParameter = var_7_2
	}
	local var_7_4 = callback(arg_7_0, "end_of_level_loot_request_cb", var_7_2)

	arg_7_0._backend_mirror:request_queue():enqueue(var_7_3, var_7_4, true)

	return var_7_0
end

function BackendInterfaceLootPlayfab.end_of_level_loot_request_cb(arg_8_0, arg_8_1, arg_8_2)
	Managers.telemetry_events:end_of_game_rewards(arg_8_2.FunctionResult)

	local var_8_0 = arg_8_2.FunctionResult
	local var_8_1 = arg_8_1.id
	local var_8_2 = var_8_0.Experience
	local var_8_3 = var_8_0.ExperiencePool
	local var_8_4 = var_8_0.RecentQuickplayGames
	local var_8_5 = var_8_0.total_essence
	local var_8_6 = var_8_0.vs_profile_data
	local var_8_7 = var_8_0.ScoreBreakdown
	local var_8_8 = var_8_0.ItemsGranted or var_8_0.Result
	local var_8_9 = var_8_0.ItemRewards or var_8_0.Rewards
	local var_8_10 = var_8_0.CurrencyGranted
	local var_8_11 = var_8_0.currencyRewards
	local var_8_12 = var_8_0.EssenceRewards
	local var_8_13 = var_8_0.cosmetic_rewards
	local var_8_14 = var_8_0.weapon_skin_rewards
	local var_8_15 = var_8_0.keep_decoration_rewards
	local var_8_16 = var_8_0.experience_rewards
	local var_8_17 = var_8_0.weekly_event_rewards
	local var_8_18 = var_8_0.ItemsRevoked
	local var_8_19 = var_8_0.ConsumedDeedResult
	local var_8_20 = #var_8_8
	local var_8_21 = var_8_0.win_tracks_progress
	local var_8_22 = {}
	local var_8_23 = arg_8_0._backend_mirror

	for iter_8_0, iter_8_1 in pairs(var_8_9) do
		local var_8_24
		local var_8_25

		for iter_8_2 = 1, var_8_20 do
			var_8_25 = var_8_8[iter_8_2]

			if iter_8_1.ItemId == var_8_25.ItemId then
				var_8_24 = var_8_25.ItemInstanceId

				break
			end
		end

		var_8_22[iter_8_0] = {
			backend_id = var_8_24
		}

		if iter_8_0 == "chest" then
			var_8_22[iter_8_0].score_breakdown = var_8_7
		end

		var_8_23:add_item(var_8_24, var_8_25)
	end

	if var_8_13 then
		for iter_8_3, iter_8_4 in pairs(var_8_13) do
			local var_8_26 = var_8_23:add_item(nil, {
				ItemId = iter_8_4
			})

			if var_8_26 then
				var_8_22[iter_8_3] = {
					backend_id = var_8_26
				}
			end
		end
	end

	if var_8_14 then
		for iter_8_5, iter_8_6 in pairs(var_8_14) do
			local var_8_27 = var_8_23:add_item(nil, {
				ItemId = iter_8_6
			})

			if var_8_27 then
				var_8_22[iter_8_5] = {
					backend_id = var_8_27
				}
			end
		end
	end

	if var_8_15 then
		for iter_8_7, iter_8_8 in pairs(var_8_15) do
			var_8_23:add_keep_decoration(iter_8_8)

			var_8_22[iter_8_7] = {
				type = "keep_decoration_painting",
				keep_decoration_name = iter_8_8
			}
		end
	end

	if var_8_16 then
		for iter_8_9, iter_8_10 in pairs(var_8_16) do
			var_8_22[iter_8_9] = {
				amount = iter_8_10
			}
		end
	end

	local var_8_28 = arg_8_2.FunctionResult.chest_inventory

	if var_8_28 then
		var_8_23:set_read_only_data("chest_inventory", var_8_28, true)
	end

	if var_8_18 then
		for iter_8_11 = 1, #var_8_18 do
			local var_8_29 = var_8_18[iter_8_11].ItemInstanceId

			var_8_23:remove_item(var_8_29)
		end
	elseif var_8_19 then
		local var_8_30 = var_8_19.ItemInstanceId

		var_8_23:remove_item(var_8_30)
	end

	local var_8_31 = arg_8_1.hero_name
	local var_8_32 = var_8_31 .. "_experience"

	var_8_23:set_read_only_data(var_8_32, var_8_2, true)

	local var_8_33 = "win_tracks_progress"

	arg_8_0._backend_mirror:set_read_only_data(var_8_33, cjson.encode(var_8_21), true)

	if var_8_17 then
		var_8_23:set_read_only_data("weekly_event_rewards", cjson.encode(var_8_17), true)
	end

	if var_8_3 then
		local var_8_34 = var_8_31 .. "_experience_pool"

		var_8_23:set_read_only_data(var_8_34, var_8_3, true)
	end

	if var_8_4 then
		var_8_23:set_read_only_data("recent_quickplay_games", var_8_4, true)
	end

	if var_8_6 then
		var_8_23:set_read_only_data("vs_profile_data", var_8_6, true)
	end

	if var_8_10 then
		for iter_8_12, iter_8_13 in pairs(var_8_10) do
			if iter_8_12 == "ES" then
				var_8_22.essence = iter_8_13

				var_8_23:set_essence(iter_8_13.new_total)
			elseif iter_8_12 == "SM" then
				var_8_22.shillings = iter_8_13

				Managers.backend:get_interface("peddler"):set_chips(iter_8_12, iter_8_13.new_total)
			elseif iter_8_12 == "VS" then
				var_8_22.versus_currency = iter_8_13

				Managers.backend:get_interface("peddler"):set_chips(iter_8_12, iter_8_13.new_total)
			else
				fassert(false, string.format("currency '%s' not supported", iter_8_12))
			end
		end
	elseif var_8_12 and #var_8_12 > 0 then
		var_8_22.essence = var_8_12

		local var_8_35 = var_8_12[#var_8_12].new_total

		var_8_23:set_essence(var_8_35)
	end

	if var_8_11 then
		for iter_8_14, iter_8_15 in pairs(var_8_11) do
			var_8_22[iter_8_14] = iter_8_15
		end
	end

	var_8_23:set_total_essence(var_8_5)
	var_8_23:handle_deus_result(arg_8_2)
	Managers.backend:dirtify_interfaces()

	arg_8_0._loot_requests[var_8_1] = var_8_22
end

function BackendInterfaceLootPlayfab._get_remote_player_network_ids_and_characters(arg_9_0)
	local var_9_0 = {}

	if IS_WINDOWS or IS_LINUX then
		if rawget(_G, "Steam") then
			local var_9_1 = Managers.player:human_players()

			for iter_9_0, iter_9_1 in pairs(var_9_1) do
				if iter_9_1.remote then
					local var_9_2 = iter_9_1:network_id()
					local var_9_3 = iter_9_1:profile_index()
					local var_9_4 = iter_9_1:career_index()
					local var_9_5 = SPProfiles[var_9_3].careers[var_9_4].playfab_name

					var_9_0[Steam.id_hex_to_dec(var_9_2)] = var_9_5
				end
			end
		end
	elseif IS_XB1 then
		local var_9_6 = Managers.player:human_players()

		for iter_9_2, iter_9_3 in pairs(var_9_6) do
			if iter_9_3.remote then
				local var_9_7 = iter_9_3:network_id()
				local var_9_8 = iter_9_3:profile_index()
				local var_9_9 = iter_9_3:career_index()
				local var_9_10 = SPProfiles[var_9_8].careers[var_9_9].playfab_name

				var_9_0[iter_9_3:platform_id()] = var_9_10
			end
		end
	elseif IS_PS4 then
		local var_9_11 = Managers.player:human_players()

		for iter_9_4, iter_9_5 in pairs(var_9_11) do
			if iter_9_5.remote then
				local var_9_12 = iter_9_5:network_id()
				local var_9_13 = iter_9_5:profile_index()
				local var_9_14 = iter_9_5:career_index()
				local var_9_15 = SPProfiles[var_9_13].careers[var_9_14].playfab_name
				local var_9_16 = iter_9_5:platform_id()

				var_9_0[Application.hex64_to_dec(var_9_12)] = var_9_15
			end
		end
	end

	return var_9_0
end

function BackendInterfaceLootPlayfab.get_achievement_rewards(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._backend_mirror:get_achievement_rewards()

	return var_10_0[arg_10_1] and var_10_0[arg_10_1][1]
end

function BackendInterfaceLootPlayfab.achievement_rewards_claimed(arg_11_0, arg_11_1)
	return arg_11_0._backend_mirror:get_claimed_achievements()[arg_11_1]
end

function BackendInterfaceLootPlayfab.can_claim_achievement_rewards(arg_12_0, arg_12_1)
	if not arg_12_0._backend_mirror:get_claimed_achievements()[arg_12_1] then
		return true
	end

	return false
end

function BackendInterfaceLootPlayfab.claim_achievement_rewards(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._reward_poll_id = true

	local var_13_0 = {
		achievement_id = arg_13_1,
		id = arg_13_2
	}
	local var_13_1 = {
		FunctionName = "generateAchievementRewards",
		FunctionParameter = var_13_0
	}
	local var_13_2 = callback(arg_13_0, "achievement_rewards_request_cb", var_13_0)

	arg_13_0._backend_mirror:request_queue():enqueue(var_13_1, var_13_2, true)
end

function BackendInterfaceLootPlayfab.achievement_rewards_request_cb(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2.FunctionResult
	local var_14_1 = arg_14_1.id

	if not var_14_0 then
		Managers.backend:playfab_api_error(arg_14_2)

		return
	elseif var_14_0.error_message then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED)

		arg_14_0._loot_requests[var_14_1] = {}

		return
	end

	local var_14_2 = var_14_0.items
	local var_14_3 = var_14_0.achievement_id
	local var_14_4 = var_14_0.currency_added
	local var_14_5 = var_14_0.chips
	local var_14_6 = arg_14_0._backend_mirror
	local var_14_7 = {}

	if var_14_2 then
		for iter_14_0 = 1, #var_14_2 do
			local var_14_8 = var_14_2[iter_14_0]
			local var_14_9 = var_14_8.ItemInstanceId
			local var_14_10 = var_14_8.UsesIncrementedBy or 1

			var_14_6:add_item(var_14_9, var_14_8)

			var_14_7[#var_14_7 + 1] = {
				type = "item",
				backend_id = var_14_9,
				amount = var_14_10
			}
		end
	end

	local var_14_11 = var_14_0.new_keep_decorations

	if var_14_11 then
		for iter_14_1 = 1, #var_14_11 do
			local var_14_12 = var_14_11[iter_14_1]

			var_14_6:add_keep_decoration(var_14_12)

			var_14_7[#var_14_7 + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_14_12
			}
		end
	end

	local var_14_13 = var_14_0.new_weapon_skins

	if var_14_13 then
		for iter_14_2 = 1, #var_14_13 do
			local var_14_14 = var_14_13[iter_14_2]

			var_14_6:add_unlocked_weapon_skin(var_14_14)

			var_14_7[#var_14_7 + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_14_14
			}
		end
	end

	local var_14_15 = var_14_0.new_cosmetics

	if var_14_15 then
		local var_14_16 = ItemMasterList

		for iter_14_3 = 1, #var_14_15 do
			local var_14_17 = var_14_15[iter_14_3]
			local var_14_18 = rawget(var_14_16, var_14_17)
			local var_14_19 = var_14_6:add_item(nil, {
				ItemId = var_14_17
			})

			if var_14_19 then
				var_14_7[#var_14_7 + 1] = {
					type = var_14_18.slot_type,
					backend_id = var_14_19
				}
			end
		end
	end

	local var_14_20 = {}

	if var_14_4 then
		for iter_14_4, iter_14_5 in pairs(var_14_4) do
			var_14_7[#var_14_7 + 1] = {
				type = "currency",
				currency_code = iter_14_4,
				amount = iter_14_5
			}
		end
	end

	if var_14_5 then
		local var_14_21 = Managers.backend:get_interface("peddler")

		if var_14_21 then
			for iter_14_6, iter_14_7 in pairs(var_14_5) do
				var_14_21:set_chips(iter_14_6, iter_14_7)
			end
		end
	end

	local var_14_22 = var_14_0.chest_inventory

	if var_14_22 then
		var_14_6:set_read_only_data("chest_inventory", var_14_22, true)
	end

	local var_14_23 = var_14_0.achievement_reward_levels

	if var_14_23 then
		var_14_6:set_read_only_data("achievement_reward_levels", var_14_23, true)
	end

	var_14_6:set_achievement_claimed(var_14_3)

	arg_14_0._loot_requests[var_14_1] = var_14_7
	arg_14_0._reward_poll_id = nil

	Managers.backend:dirtify_interfaces()
end

function BackendInterfaceLootPlayfab.can_claim_all_achievement_rewards(arg_15_0, arg_15_1)
	local var_15_0 = {}
	local var_15_1 = {}
	local var_15_2 = arg_15_0._backend_mirror:get_claimed_achievements()

	for iter_15_0 = 0, #arg_15_1 do
		local var_15_3 = arg_15_1[iter_15_0]

		if not var_15_2[var_15_3] then
			table.insert(var_15_0, var_15_3)
		else
			table.insert(var_15_1, var_15_3)
		end
	end

	if table.is_empty(var_15_0) then
		return false, nil, var_15_1
	else
		return true, var_15_0, var_15_1
	end
end

local var_0_1 = 150

function BackendInterfaceLootPlayfab.claim_multiple_achievement_rewards(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_0._reward_poll_id = true
	arg_16_3 = arg_16_3 or 1
	arg_16_4 = arg_16_4 or var_0_1

	local var_16_0 = {}
	local var_16_1 = #arg_16_1
	local var_16_2 = arg_16_2
	local var_16_3
	local var_16_4 = var_0_1

	if arg_16_3 > 1 then
		var_16_3 = table.slice(arg_16_1, arg_16_3, var_16_1)
	else
		var_16_3 = arg_16_1
	end

	if #var_16_3 <= var_0_1 then
		var_16_4 = #var_16_3
	end

	for iter_16_0 = 1, var_16_4 do
		local var_16_5 = var_16_3[iter_16_0]
		local var_16_6 = {
			achievement_id = var_16_5
		}

		var_16_0[#var_16_0 + 1] = var_16_6
	end

	local var_16_7 = {
		FunctionName = "generateAchievementRewards",
		FunctionParameter = {
			achievement_ids = var_16_0,
			id = var_16_2
		}
	}
	local var_16_8 = callback(arg_16_0, "claim_multiple_achievement_rewards_request_cb", var_16_0, var_16_2, arg_16_3, arg_16_4, arg_16_1)

	arg_16_0._backend_mirror:request_queue():enqueue(var_16_7, var_16_8, true)
end

function BackendInterfaceLootPlayfab.claim_multiple_achievement_rewards_request_cb(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	print("[BackendInterfaceLootPlayfab]:claim_all_achievement_rewards_request_cb: Firing!")

	local var_17_0 = arg_17_6.FunctionResult
	local var_17_1 = arg_17_2
	local var_17_2 = arg_17_5

	if not var_17_0 then
		Managers.backend:playfab_api_error(arg_17_6)

		return
	elseif var_17_0 == "reward_claimed" then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED)

		arg_17_0._loot_requests[var_17_1] = {}

		return
	end

	if arg_17_0._loot_requests[var_17_1] == nil then
		arg_17_0._loot_requests[var_17_1] = {}
	end

	local var_17_3 = var_17_0.items
	local var_17_4 = var_17_0.achievement_id
	local var_17_5 = var_17_0.currency_added
	local var_17_6 = var_17_0.chips
	local var_17_7 = arg_17_0._backend_mirror
	local var_17_8 = {}

	if var_17_3 then
		for iter_17_0 = 1, #var_17_3 do
			local var_17_9 = var_17_3[iter_17_0]
			local var_17_10 = var_17_9.ItemInstanceId
			local var_17_11 = var_17_9.UsesIncrementedBy or 1

			var_17_7:add_item(var_17_10, var_17_9)

			var_17_8[#var_17_8 + 1] = {
				type = "item",
				backend_id = var_17_10,
				amount = var_17_11
			}
		end
	end

	local var_17_12 = var_17_0.new_keep_decorations

	if var_17_12 then
		for iter_17_1 = 1, #var_17_12 do
			local var_17_13 = var_17_12[iter_17_1]

			var_17_7:add_keep_decoration(var_17_13)

			var_17_8[#var_17_8 + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_17_13
			}
		end
	end

	local var_17_14 = var_17_0.new_weapon_skins

	if var_17_14 then
		for iter_17_2 = 1, #var_17_14 do
			local var_17_15 = var_17_14[iter_17_2]

			var_17_7:add_unlocked_weapon_skin(var_17_15)

			var_17_8[#var_17_8 + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_17_15
			}
		end
	end

	local var_17_16 = var_17_0.new_cosmetics

	if var_17_16 then
		local var_17_17 = ItemMasterList

		for iter_17_3 = 1, #var_17_16 do
			local var_17_18 = var_17_16[iter_17_3]
			local var_17_19 = rawget(var_17_17, var_17_18)
			local var_17_20 = var_17_7:add_item(nil, {
				ItemId = var_17_18
			})

			if var_17_20 then
				var_17_8[#var_17_8 + 1] = {
					type = var_17_19.slot_type,
					backend_id = var_17_20
				}
			end
		end
	end

	local var_17_21 = {}

	if var_17_5 then
		for iter_17_4, iter_17_5 in pairs(var_17_5) do
			var_17_8[#var_17_8 + 1] = {
				type = "currency",
				currency_code = iter_17_4,
				amount = iter_17_5
			}
		end
	end

	if var_17_6 then
		local var_17_22 = Managers.backend:get_interface("peddler")

		if var_17_22 then
			for iter_17_6, iter_17_7 in pairs(var_17_6) do
				var_17_22:set_chips(iter_17_6, iter_17_7)
			end
		end
	end

	local var_17_23 = var_17_0.chest_inventory

	if var_17_23 then
		var_17_7:set_read_only_data("chest_inventory", var_17_23, true)
	end

	local var_17_24 = var_17_0.achievement_reward_levels

	if var_17_24 then
		var_17_7:set_read_only_data("achievement_reward_levels", var_17_24, true)
	end

	if var_17_4 then
		for iter_17_8 = 1, #var_17_4 do
			local var_17_25 = var_17_4[iter_17_8].achievement_id

			var_17_7:set_achievement_claimed(var_17_25)
		end

		for iter_17_9 = 1, #var_17_8 do
			table.insert(arg_17_0._loot_requests[var_17_1], var_17_8[iter_17_9])
		end
	else
		local var_17_26 = var_17_0.requested_achievement_ids or {}

		table.dump(var_17_26)
		Crashify.print_exception("Failed to claim multiple challenges")
	end

	if arg_17_4 < #var_17_2 then
		local var_17_27 = arg_17_3 + var_0_1
		local var_17_28 = arg_17_4 + var_0_1

		arg_17_0:claim_multiple_achievement_rewards(var_17_2, var_17_1, var_17_27, var_17_28)
	else
		arg_17_0._reward_poll_id = nil

		Managers.backend:dirtify_interfaces()
	end
end

function BackendInterfaceLootPlayfab.polling_reward(arg_18_0)
	return arg_18_0._reward_poll_id
end

function BackendInterfaceLootPlayfab.is_loot_generated(arg_19_0, arg_19_1)
	if arg_19_0._loot_requests[arg_19_1] then
		return true
	end

	return false
end

function BackendInterfaceLootPlayfab.get_loot(arg_20_0, arg_20_1)
	return arg_20_0._loot_requests[arg_20_1]
end

function BackendInterfaceLootPlayfab.generate_reward_loot_id(arg_21_0)
	return arg_21_0:_new_id()
end

function BackendInterfaceLootPlayfab.get_power_level_settings(arg_22_0)
	return arg_22_0._backend_mirror:get_power_level_settings()
end

function BackendInterfaceLootPlayfab.debug_override_power_level_settings(arg_23_0, arg_23_1)
	arg_23_0._backend_mirror:debug_override_power_level_settings(arg_23_1)
end

function BackendInterfaceLootPlayfab.get_rarity_tables(arg_24_0)
	return arg_24_0._backend_mirror:get_rarity_tables()
end

function BackendInterfaceLootPlayfab.get_formatted_rarity_tables(arg_25_0)
	return arg_25_0._backend_mirror:get_formatted_rarity_tables()
end

function BackendInterfaceLootPlayfab.get_highest_chest_level(arg_26_0, arg_26_1)
	local var_26_0
	local var_26_1 = cjson.decode(arg_26_0._backend_mirror:get_read_only_data("chest_inventory"))[arg_26_1]

	if var_26_1 then
		for iter_26_0, iter_26_1 in pairs(var_26_1) do
			if iter_26_1 > 0 then
				local var_26_2 = string.split(iter_26_0, "_")[2]

				var_26_0 = math.max(var_26_0 or 0, var_26_2)
			end
		end
	end

	return var_26_0
end
