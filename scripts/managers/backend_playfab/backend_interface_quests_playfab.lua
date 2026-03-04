-- chunkname: @scripts/managers/backend_playfab/backend_interface_quests_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceQuestsPlayfab = class(BackendInterfaceQuestsPlayfab)

BackendInterfaceQuestsPlayfab.init = function (arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._quests = {}
	arg_1_0._last_id = 0
	arg_1_0._refresh_requests = {}
	arg_1_0._quest_reward_requests = {}
	arg_1_0._quests_updating = false
	arg_1_0._quest_timer = 0
	arg_1_0._event_quest_update_times = {}

	arg_1_0:_refresh()
end

BackendInterfaceQuestsPlayfab._refresh = function (arg_2_0)
	local var_2_0 = arg_2_0._talents
	local var_2_1 = arg_2_0._backend_mirror:get_quest_data()

	arg_2_0._quests.daily = var_2_1.current_daily_quests
	arg_2_0._quests.event = var_2_1.current_event_quests

	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_1.current_weekly_quests) do
		local var_2_3 = table.clone(iter_2_1)

		if iter_2_1.difficulty then
			var_2_3.name = iter_2_1.name .. "_" .. iter_2_1.difficulty
		else
			var_2_3.name = iter_2_1.name
		end

		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._quests.weekly = var_2_2
	arg_2_0._refresh_available = var_2_1.daily_quest_refresh_available
	arg_2_0._daily_quest_update_time = math.ceil(var_2_1.daily_quest_update_time / 1000)

	local var_2_4 = var_2_1.weekly_quest_update_time

	if var_2_4 ~= nil then
		arg_2_0._weekly_quest_update_time = math.ceil(var_2_4 / 1000)
	end

	for iter_2_2, iter_2_3 in pairs(arg_2_0._quests.event) do
		if iter_2_3.end_time ~= nil then
			arg_2_0._event_quest_update_times[iter_2_2] = math.ceil(iter_2_3.end_time / 1000)
		end
	end

	arg_2_0._dirty = false
end

BackendInterfaceQuestsPlayfab.ready = function (arg_3_0)
	return true
end

BackendInterfaceQuestsPlayfab._new_id = function (arg_4_0)
	arg_4_0._last_id = arg_4_0._last_id + 1

	return arg_4_0._last_id
end

BackendInterfaceQuestsPlayfab.make_dirty = function (arg_5_0)
	arg_5_0._dirty = true
end

BackendInterfaceQuestsPlayfab.update_quests = function (arg_6_0, arg_6_1)
	if arg_6_0._quests_updating then
		return
	end

	local var_6_0 = false

	if arg_6_0:get_daily_quest_update_time() <= 0 then
		var_6_0 = true
	end

	local var_6_1 = arg_6_0:get_weekly_quest_update_time()

	if var_6_1 and var_6_1 <= 0 then
		var_6_0 = true
	end

	for iter_6_0, iter_6_1 in pairs(arg_6_0._quests.event) do
		local var_6_2 = arg_6_0:get_time_left_on_event_quest(iter_6_0)

		if var_6_2 and var_6_2 <= 0 then
			var_6_0 = true

			break
		end
	end

	if var_6_0 then
		local var_6_3 = {
			FunctionName = "getQuests"
		}
		local var_6_4 = callback(arg_6_0, "get_quests_cb")

		arg_6_0._backend_mirror:request_queue():enqueue(var_6_3, var_6_4, false)

		arg_6_0._quests_updated_cb = arg_6_1
		arg_6_0._quests_updating = true
	end
end

BackendInterfaceQuestsPlayfab.update = function (arg_7_0, arg_7_1)
	arg_7_0._quest_timer = arg_7_0._quest_timer + arg_7_1
end

BackendInterfaceQuestsPlayfab.get_quests_cb = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._backend_mirror
	local var_8_1 = arg_8_1.FunctionResult
	local var_8_2 = var_8_1.current_daily_quests
	local var_8_3 = var_8_1.daily_quest_refresh_available
	local var_8_4 = var_8_1.daily_quest_update_time
	local var_8_5 = var_8_1.current_weekly_quests
	local var_8_6 = var_8_1.weekly_quest_update_time
	local var_8_7 = var_8_1.current_event_quests

	var_8_0:set_quest_data("current_daily_quests", var_8_2)
	var_8_0:set_quest_data("daily_quest_refresh_available", to_boolean(var_8_3))
	var_8_0:set_quest_data("daily_quest_update_time", tonumber(var_8_4))
	var_8_0:set_quest_data("current_weekly_quests", var_8_5)
	var_8_0:set_quest_data("weekly_quest_update_time", tonumber(var_8_6))
	var_8_0:set_quest_data("current_event_quests", var_8_7)

	arg_8_0._quests_updating = false
	arg_8_0._dirty = true
	arg_8_0._quest_timer = 0

	if arg_8_0._quests_updated_cb then
		arg_8_0._quests_updated_cb()

		arg_8_0._quests_updated_cb = nil
	end
end

BackendInterfaceQuestsPlayfab.delete = function (arg_9_0)
	return
end

BackendInterfaceQuestsPlayfab.get_quests = function (arg_10_0)
	if arg_10_0._dirty then
		arg_10_0:_refresh()
	end

	return arg_10_0._quests
end

BackendInterfaceQuestsPlayfab.get_daily_quest_update_time = function (arg_11_0)
	if arg_11_0._dirty then
		arg_11_0:_refresh()
	end

	return arg_11_0._daily_quest_update_time - arg_11_0._quest_timer
end

BackendInterfaceQuestsPlayfab.get_weekly_quest_update_time = function (arg_12_0)
	if arg_12_0._dirty then
		arg_12_0:_refresh()
	end

	if not arg_12_0._weekly_quest_update_time then
		return nil
	end

	return arg_12_0._weekly_quest_update_time - arg_12_0._quest_timer
end

BackendInterfaceQuestsPlayfab.get_time_left_on_event_quest = function (arg_13_0, arg_13_1)
	if arg_13_0._dirty then
		arg_13_0:_refresh()
	end

	if not arg_13_0._event_quest_update_times[arg_13_1] then
		return nil
	end

	return arg_13_0._event_quest_update_times[arg_13_1] - arg_13_0._quest_timer
end

BackendInterfaceQuestsPlayfab.can_refresh_daily_quest = function (arg_14_0)
	if arg_14_0._dirty then
		arg_14_0:_refresh()
	end

	return arg_14_0._refresh_available
end

BackendInterfaceQuestsPlayfab.refresh_daily_quest = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:_new_id()
	local var_15_1 = {
		FunctionName = "refreshQuest",
		FunctionParameter = {
			quest_key = arg_15_1
		}
	}
	local var_15_2 = callback(arg_15_0, "refresh_quest_cb", var_15_0, arg_15_1)

	arg_15_0._backend_mirror:request_queue():enqueue(var_15_1, var_15_2, false)

	return var_15_0
end

BackendInterfaceQuestsPlayfab.refresh_quest_cb = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0._backend_mirror
	local var_16_1 = arg_16_3.FunctionResult

	if var_16_1 == "refresh_unavailable" then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE)

		arg_16_0._refresh_requests[arg_16_1] = {}

		return
	end

	local var_16_2 = var_16_1.current_daily_quests
	local var_16_3 = var_16_1.daily_quest_refresh_available

	var_16_0:set_quest_data("current_daily_quests", var_16_2)
	var_16_0:set_quest_data("daily_quest_refresh_available", to_boolean(var_16_3))

	arg_16_0._refresh_requests[arg_16_1] = {
		quest_key = arg_16_2
	}
	arg_16_0._dirty = true
end

BackendInterfaceQuestsPlayfab.is_quest_refreshed = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._refresh_requests[arg_17_1]

	if var_17_0 then
		return true, var_17_0.quest_key
	end

	return false
end

BackendInterfaceQuestsPlayfab.can_claim_quest_rewards = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:get_quests()
	local var_18_1 = arg_18_0._quests.daily
	local var_18_2 = arg_18_0._quests.weekly
	local var_18_3 = arg_18_0._quests.event

	if var_18_1[arg_18_1] or var_18_2[arg_18_1] or var_18_3[arg_18_1] then
		return true
	end

	return false
end

BackendInterfaceQuestsPlayfab.can_claim_multiple_quest_rewards = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._quests.daily
	local var_19_1 = arg_19_0._quests.weekly
	local var_19_2 = arg_19_0._quests.event
	local var_19_3 = {}

	for iter_19_0 = 1, #arg_19_1 do
		local var_19_4 = arg_19_1[iter_19_0]

		if var_19_0[var_19_4] or var_19_1[var_19_4] or var_19_2[var_19_4] then
			var_19_3[#var_19_3 + 1] = var_19_4
		end
	end

	if not table.is_empty(var_19_3) then
		return true, var_19_3
	end

	return false, nil
end

BackendInterfaceQuestsPlayfab.claim_quest_rewards = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:_new_id()
	local var_20_1 = {
		quest_key = arg_20_1,
		id = var_20_0
	}
	local var_20_2 = {
		FunctionName = "generateQuestRewards",
		FunctionParameter = var_20_1
	}
	local var_20_3 = callback(arg_20_0, "quest_rewards_request_cb", var_20_1)

	arg_20_0._backend_mirror:request_queue():enqueue(var_20_2, var_20_3, true)

	return var_20_0
end

BackendInterfaceQuestsPlayfab.quest_rewards_request_cb = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_2.FunctionResult

	if not var_21_0 then
		Managers.backend:playfab_api_error(arg_21_2)

		return
	end

	local var_21_1 = arg_21_1.id
	local var_21_2 = var_21_0.items
	local var_21_3 = var_21_0.chips
	local var_21_4 = var_21_0.currency_added
	local var_21_5 = arg_21_0._backend_mirror
	local var_21_6 = {
		quest_key = arg_21_1.quest_key,
		loot = {}
	}
	local var_21_7 = var_21_6.loot

	if var_21_2 then
		for iter_21_0 = 1, #var_21_2 do
			local var_21_8 = var_21_2[iter_21_0]
			local var_21_9 = var_21_8.ItemInstanceId
			local var_21_10 = var_21_8.UsesIncrementedBy or 1

			var_21_5:add_item(var_21_9, var_21_8)

			var_21_7[iter_21_0] = {
				type = "item",
				backend_id = var_21_9,
				amount = var_21_10
			}
		end
	end

	local var_21_11 = var_21_0.new_keep_decorations

	if var_21_11 then
		for iter_21_1 = 1, #var_21_11 do
			local var_21_12 = var_21_11[iter_21_1]

			var_21_5:add_keep_decoration(var_21_12)

			var_21_7[#var_21_7 + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_21_12
			}
		end
	end

	local var_21_13 = var_21_0.new_weapon_skins

	if var_21_13 then
		for iter_21_2 = 1, #var_21_13 do
			local var_21_14 = var_21_13[iter_21_2]

			var_21_5:add_unlocked_weapon_skin(var_21_14)

			var_21_7[#var_21_7 + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_21_14
			}
		end
	end

	local var_21_15 = var_21_0.new_cosmetics

	if var_21_15 then
		local var_21_16 = ItemMasterList

		for iter_21_3 = 1, #var_21_15 do
			local var_21_17 = var_21_15[iter_21_3]
			local var_21_18 = var_21_5:add_item(nil, {
				ItemId = var_21_17
			})

			if var_21_18 then
				local var_21_19 = var_21_16[var_21_17]

				var_21_7[#var_21_7 + 1] = {
					amount = 1,
					type = var_21_19.slot_type,
					backend_id = var_21_18
				}
			end
		end
	end

	local var_21_20 = {}

	if var_21_4 then
		for iter_21_4, iter_21_5 in ipairs(var_21_4) do
			local var_21_21 = iter_21_5.code
			local var_21_22 = iter_21_5.amount
			local var_21_23 = var_21_20[var_21_21]

			var_21_20[var_21_21] = var_21_23 and var_21_23 or 0 + var_21_22
			var_21_7[#var_21_7 + 1] = {
				type = "currency",
				currency_code = var_21_21,
				amount = var_21_22
			}
		end
	end

	if var_21_3 then
		local var_21_24 = Managers.backend:get_interface("peddler")

		if var_21_24 then
			for iter_21_6, iter_21_7 in pairs(var_21_3) do
				var_21_24:set_chips(iter_21_6, iter_21_7)
			end
		end
	end

	local var_21_25 = var_21_0.chest_inventory

	if var_21_25 then
		var_21_5:set_read_only_data("chest_inventory", var_21_25, true)
	end

	local var_21_26
	local var_21_27

	if var_21_0.quest_name then
		var_21_26 = var_21_0.quest_name
		var_21_27 = var_21_0.quest_type
	else
		local var_21_28 = {
			"current_daily_quests",
			"current_event_quests",
			"current_weekly_quests"
		}
		local var_21_29 = {
			current_event_quests = "event",
			current_weekly_quests = "weekly",
			current_daily_quests = "daily"
		}
		local var_21_30 = var_21_5:get_quest_data()

		for iter_21_8 = 1, #var_21_28 do
			local var_21_31 = var_21_28[iter_21_8]
			local var_21_32 = var_21_30[var_21_31][arg_21_1.quest_key]

			if var_21_32 then
				var_21_26 = var_21_32.name
				var_21_27 = var_21_29[var_21_31]

				break
			end
		end
	end

	if var_21_27 == "event" then
		var_21_5:add_claimed_event_quest(var_21_26)
	end

	local var_21_33 = var_21_0.current_daily_quests or {}
	local var_21_34 = var_21_0.current_weekly_quests or {}
	local var_21_35 = var_21_0.current_event_quests or {}

	var_21_5:set_quest_data("current_daily_quests", var_21_33)
	var_21_5:set_quest_data("current_weekly_quests", var_21_34)
	var_21_5:set_quest_data("current_event_quests", var_21_35)

	local var_21_36 = Managers.player and Managers.player:local_player()
	local var_21_37 = Managers.player:statistics_db()

	if not var_21_36 or not var_21_37 then
		Application.warning("[BackendInterfaceQuestsPlayfab] Could not get statistics_db, skipping updating statistics...")
	else
		local var_21_38 = var_21_36:stats_id()
		local var_21_39 = arg_21_0:get_quests()
		local var_21_40 = var_21_39.daily
		local var_21_41 = var_21_39.weekly

		for iter_21_9, iter_21_10 in pairs(var_21_40) do
			if iter_21_9 == arg_21_1.quest_key then
				var_21_37:increment_stat(var_21_38, "completed_daily_quests")

				break
			end
		end

		for iter_21_11, iter_21_12 in pairs(var_21_41) do
			if iter_21_11 == arg_21_1.quest_key then
				var_21_37:increment_stat(var_21_38, "completed_weekly_quests")

				break
			end
		end
	end

	arg_21_0._quest_reward_requests[var_21_1] = var_21_6
	arg_21_0._dirty = true
end

BackendInterfaceQuestsPlayfab.claim_multiple_quest_rewards = function (arg_22_0, arg_22_1)
	local var_22_0 = {}
	local var_22_1 = arg_22_0:_new_id()

	for iter_22_0 = 1, #arg_22_1 do
		local var_22_2 = arg_22_1[iter_22_0]
		local var_22_3 = {
			quest_key = var_22_2
		}

		var_22_0[#var_22_0 + 1] = var_22_3
	end

	local var_22_4 = {
		FunctionName = "generateQuestRewards",
		FunctionParameter = {
			quest_data = var_22_0,
			id = var_22_1
		}
	}
	local var_22_5 = callback(arg_22_0, "claim_multiple_quest_rewards_request_cb", var_22_0, var_22_1)

	arg_22_0._backend_mirror:request_queue():enqueue(var_22_4, var_22_5, true)

	return var_22_1
end

BackendInterfaceQuestsPlayfab.claim_multiple_quest_rewards_request_cb = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_3.FunctionResult

	if not var_23_0 then
		Managers.backend:playfab_api_error(arg_23_3)

		return
	end

	local var_23_1 = arg_23_2
	local var_23_2 = var_23_0.items
	local var_23_3 = var_23_0.chips
	local var_23_4 = var_23_0.currency_added
	local var_23_5 = arg_23_0._backend_mirror
	local var_23_6 = var_23_0.quest_data_names
	local var_23_7 = {}

	for iter_23_0 = 1, #arg_23_1 do
		var_23_7[#var_23_7 + 1] = arg_23_1[iter_23_0].quest_key
	end

	local var_23_8 = {
		quest_key = var_23_7,
		loot = {}
	}
	local var_23_9 = var_23_8.loot

	if var_23_2 then
		for iter_23_1 = 1, #var_23_2 do
			local var_23_10 = var_23_2[iter_23_1]
			local var_23_11 = var_23_10.ItemInstanceId
			local var_23_12 = var_23_10.UsesIncrementedBy or 1

			var_23_5:add_item(var_23_11, var_23_10)

			var_23_9[iter_23_1] = {
				type = "item",
				backend_id = var_23_11,
				amount = var_23_12
			}
		end
	end

	local var_23_13 = var_23_0.new_keep_decorations

	if var_23_13 then
		for iter_23_2 = 1, #var_23_13 do
			local var_23_14 = var_23_13[iter_23_2]

			var_23_5:add_keep_decoration(var_23_14)

			var_23_9[#var_23_9 + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_23_14
			}
		end
	end

	local var_23_15 = var_23_0.new_weapon_skins

	if var_23_15 then
		for iter_23_3 = 1, #var_23_15 do
			local var_23_16 = var_23_15[iter_23_3]

			var_23_5:add_unlocked_weapon_skin(var_23_16)

			var_23_9[#var_23_9 + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_23_16
			}
		end
	end

	local var_23_17 = var_23_0.new_cosmetics

	if var_23_17 then
		local var_23_18 = ItemMasterList

		for iter_23_4 = 1, #var_23_17 do
			local var_23_19 = var_23_17[iter_23_4]
			local var_23_20 = var_23_5:add_item(nil, {
				ItemId = var_23_19
			})

			if var_23_20 then
				local var_23_21 = var_23_18[var_23_19]

				var_23_9[#var_23_9 + 1] = {
					amount = 1,
					type = var_23_21.slot_type,
					backend_id = var_23_20
				}
			end
		end
	end

	local var_23_22 = {}

	if var_23_4 then
		for iter_23_5, iter_23_6 in ipairs(var_23_4) do
			local var_23_23 = iter_23_6.code
			local var_23_24 = iter_23_6.amount
			local var_23_25 = var_23_22[var_23_23]

			var_23_22[var_23_23] = var_23_25 and var_23_25 or 0 + var_23_24
			var_23_9[#var_23_9 + 1] = {
				type = "currency",
				currency_code = var_23_23,
				amount = var_23_24
			}
		end
	end

	if var_23_3 then
		local var_23_26 = Managers.backend:get_interface("peddler")

		if var_23_26 then
			for iter_23_7, iter_23_8 in pairs(var_23_3) do
				var_23_26:set_chips(iter_23_7, iter_23_8)
			end
		end
	end

	local var_23_27 = var_23_0.chest_inventory

	if var_23_27 then
		var_23_5:set_read_only_data("chest_inventory", var_23_27, true)
	end

	local var_23_28 = {}
	local var_23_29

	if var_23_6 then
		for iter_23_9 = 1, #var_23_6 do
			var_23_28[#var_23_28 + 1] = var_23_6[iter_23_9]
		end

		var_23_29 = var_23_0.quest_type
	else
		local var_23_30 = {
			"current_daily_quests",
			"current_event_quests",
			"current_weekly_quests"
		}
		local var_23_31 = {
			current_event_quests = "event",
			current_weekly_quests = "weekly",
			current_daily_quests = "daily"
		}
		local var_23_32 = var_23_5:get_quest_data()

		for iter_23_10 = 1, #arg_23_1 do
			for iter_23_11 = 1, #var_23_30 do
				local var_23_33 = var_23_30[iter_23_11]
				local var_23_34 = var_23_32[var_23_33][arg_23_1[iter_23_10].quest_key]

				if var_23_34 then
					var_23_28[#var_23_28 + 1] = var_23_34.name
					var_23_29 = var_23_29 or var_23_31[var_23_33]
				end
			end
		end
	end

	if var_23_29 == "event" then
		var_23_5:add_claimed_multiple_event_quests(var_23_28)
	end

	local var_23_35 = var_23_0.current_daily_quests
	local var_23_36 = var_23_0.current_weekly_quests
	local var_23_37 = var_23_0.current_event_quests

	var_23_5:set_quest_data("current_daily_quests", var_23_35)
	var_23_5:set_quest_data("current_weekly_quests", var_23_36)
	var_23_5:set_quest_data("current_event_quests", var_23_37)

	local var_23_38 = Managers.player and Managers.player:local_player()
	local var_23_39 = Managers.player:statistics_db()

	if not var_23_38 or not var_23_39 then
		Application.warning("[BackendInterfaceQuestsPlayfab] Could not get statistics_db, skipping updating statistics...")
	else
		local var_23_40 = var_23_38:stats_id()
		local var_23_41 = arg_23_0:get_quests()
		local var_23_42 = var_23_41.daily
		local var_23_43 = var_23_41.weekly

		for iter_23_12 = 1, #arg_23_1 do
			for iter_23_13, iter_23_14 in pairs(var_23_42) do
				if iter_23_13 == arg_23_1[iter_23_12].quest_key then
					var_23_39:increment_stat(var_23_40, "completed_daily_quests")

					break
				end
			end

			for iter_23_15, iter_23_16 in pairs(var_23_43) do
				if iter_23_15 == arg_23_1[iter_23_12].quest_key then
					var_23_39:increment_stat(var_23_40, "completed_weekly_quests")

					break
				end
			end
		end
	end

	arg_23_0._quest_reward_requests[var_23_1] = var_23_8
	arg_23_0._dirty = true
end

BackendInterfaceQuestsPlayfab.get_quest_key = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0:get_quests()
	local var_24_1 = var_24_0.daily
	local var_24_2 = var_24_0.weekly
	local var_24_3 = var_24_0.event

	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		if iter_24_1.name == arg_24_1 then
			return iter_24_0
		end
	end

	for iter_24_2, iter_24_3 in pairs(var_24_2) do
		if iter_24_3.name == arg_24_1 then
			return iter_24_2
		end
	end

	for iter_24_4, iter_24_5 in pairs(var_24_3) do
		if iter_24_5.name == arg_24_1 then
			return iter_24_4
		end
	end

	return nil
end

BackendInterfaceQuestsPlayfab.get_quest_by_key = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:get_quests()
	local var_25_1 = var_25_0.daily
	local var_25_2 = var_25_0.weekly
	local var_25_3 = var_25_0.event

	for iter_25_0, iter_25_1 in pairs(var_25_1) do
		if arg_25_1 == iter_25_0 then
			return iter_25_1
		end
	end

	for iter_25_2, iter_25_3 in pairs(var_25_2) do
		if arg_25_1 == iter_25_2 then
			return iter_25_3
		end
	end

	for iter_25_4, iter_25_5 in pairs(var_25_3) do
		if arg_25_1 == iter_25_4 then
			return iter_25_5
		end
	end

	return nil
end

BackendInterfaceQuestsPlayfab.quest_rewards_generated = function (arg_26_0, arg_26_1)
	if arg_26_0._quest_reward_requests[arg_26_1] then
		return true
	end

	return false
end

BackendInterfaceQuestsPlayfab.get_quest_rewards = function (arg_27_0, arg_27_1)
	return arg_27_0._quest_reward_requests[arg_27_1]
end

BackendInterfaceQuestsPlayfab.get_claimed_event_quests = function (arg_28_0)
	return arg_28_0._backend_mirror:get_claimed_event_quests()
end
