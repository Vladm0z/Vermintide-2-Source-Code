-- chunkname: @scripts/managers/backend_playfab/backend_interface_quests_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceQuestsPlayfab = class(BackendInterfaceQuestsPlayfab)

BackendInterfaceQuestsPlayfab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._quests = {}
	self._last_id = 0
	self._refresh_requests = {}
	self._quest_reward_requests = {}
	self._quests_updating = false
	self._quest_timer = 0
	self._event_quest_update_times = {}

	self:_refresh()
end

BackendInterfaceQuestsPlayfab._refresh = function (self)
	-- function 2
	local _talents = self._talents
	local get_quest_data = self._backend_mirror:get_quest_data()

	self._quests.daily = get_quest_data.current_daily_quests
	self._quests.event = get_quest_data.current_event_quests

	local tbl = {}

	for k, v in pairs(get_quest_data.current_weekly_quests) do
		local clone = table.clone(v)

		if not v.difficulty then
			clone.name = v.name .. "_" .. v.difficulty
		else
			clone.name = v.name
		end

		tbl[k] = clone
	end

	self._quests.weekly = tbl
	self._refresh_available = get_quest_data.daily_quest_refresh_available
	self._daily_quest_update_time = math.ceil(get_quest_data.daily_quest_update_time / 1000)

	local weekly_quest_update_time = get_quest_data.weekly_quest_update_time

	if weekly_quest_update_time ~= nil then
		self._weekly_quest_update_time = math.ceil(weekly_quest_update_time / 1000)
	end

	for k_2, v_2 in pairs(self._quests.event) do
		if v_2.end_time ~= nil then
			self._event_quest_update_times[k_2] = math.ceil(v_2.end_time / 1000)
		end
	end

	self._dirty = false
end

BackendInterfaceQuestsPlayfab.ready = function (arg_3_0)
	-- function 3
	return true
end

BackendInterfaceQuestsPlayfab._new_id = function (self)
	-- function 4
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceQuestsPlayfab.make_dirty = function (self)
	-- function 5
	self._dirty = true
end

BackendInterfaceQuestsPlayfab.update_quests = function (self, arg_6_1)
	-- function 6
	if not self._quests_updating then
		return
	end

	local flag = false

	if self:get_daily_quest_update_time() <= 0 then
		flag = true
	end

	local get_weekly_quest_update_time = self:get_weekly_quest_update_time()

	if not (not get_weekly_quest_update_time and not (get_weekly_quest_update_time <= 0)) then
		flag = true
	end

	for k, v in pairs(self._quests.event) do
		local get_time_left_on_event_quest = self:get_time_left_on_event_quest(k)

		if not (not get_time_left_on_event_quest and not (get_time_left_on_event_quest <= 0)) then
			flag = true

			break
		end
	end

	if not flag then
		local tbl = {
			FunctionName = "getQuests"
		}
		local var_6_4 = callback(self, "get_quests_cb")

		self._backend_mirror:request_queue():enqueue(tbl, var_6_4, false)

		self._quests_updated_cb = arg_6_1
		self._quests_updating = true
	end
end

BackendInterfaceQuestsPlayfab.update = function (self, arg_7_1)
	-- function 7
	self._quest_timer = self._quest_timer + arg_7_1
end

BackendInterfaceQuestsPlayfab.get_quests_cb = function (self, arg_8_1)
	-- function 8
	local _backend_mirror = self._backend_mirror
	local FunctionResult = arg_8_1.FunctionResult
	local current_daily_quests = FunctionResult.current_daily_quests
	local daily_quest_refresh_available = FunctionResult.daily_quest_refresh_available
	local daily_quest_update_time = FunctionResult.daily_quest_update_time
	local current_weekly_quests = FunctionResult.current_weekly_quests
	local weekly_quest_update_time = FunctionResult.weekly_quest_update_time
	local current_event_quests = FunctionResult.current_event_quests

	_backend_mirror:set_quest_data("current_daily_quests", current_daily_quests)
	_backend_mirror:set_quest_data("daily_quest_refresh_available", to_boolean(daily_quest_refresh_available))
	_backend_mirror:set_quest_data("daily_quest_update_time", tonumber(daily_quest_update_time))
	_backend_mirror:set_quest_data("current_weekly_quests", current_weekly_quests)
	_backend_mirror:set_quest_data("weekly_quest_update_time", tonumber(weekly_quest_update_time))
	_backend_mirror:set_quest_data("current_event_quests", current_event_quests)

	self._quests_updating = false
	self._dirty = true
	self._quest_timer = 0

	if not self._quests_updated_cb then
		self._quests_updated_cb()

		self._quests_updated_cb = nil
	end
end

BackendInterfaceQuestsPlayfab.delete = function (arg_9_0)
	-- function 9
	return
end

BackendInterfaceQuestsPlayfab.get_quests = function (self)
	-- function 10
	if not self._dirty then
		self:_refresh()
	end

	return self._quests
end

BackendInterfaceQuestsPlayfab.get_daily_quest_update_time = function (self)
	-- function 11
	if not self._dirty then
		self:_refresh()
	end

	return self._daily_quest_update_time - self._quest_timer
end

BackendInterfaceQuestsPlayfab.get_weekly_quest_update_time = function (self)
	-- function 12
	if not self._dirty then
		self:_refresh()
	end

	if not self._weekly_quest_update_time then
		return nil
	end

	return self._weekly_quest_update_time - self._quest_timer
end

BackendInterfaceQuestsPlayfab.get_time_left_on_event_quest = function (self, arg_13_1)
	-- function 13
	if not self._dirty then
		self:_refresh()
	end

	if not self._event_quest_update_times[arg_13_1] then
		return nil
	end

	return self._event_quest_update_times[arg_13_1] - self._quest_timer
end

BackendInterfaceQuestsPlayfab.can_refresh_daily_quest = function (self)
	-- function 14
	if not self._dirty then
		self:_refresh()
	end

	return self._refresh_available
end

BackendInterfaceQuestsPlayfab.refresh_daily_quest = function (self, arg_15_1)
	-- function 15
	local _new_id = self:_new_id()
	local tbl = {
		FunctionName = "refreshQuest",
		FunctionParameter = {
			quest_key = arg_15_1
		}
	}
	local var_15_2 = callback(self, "refresh_quest_cb", _new_id, arg_15_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_15_2, false)

	return _new_id
end

BackendInterfaceQuestsPlayfab.refresh_quest_cb = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local _backend_mirror = self._backend_mirror
	local FunctionResult = arg_16_3.FunctionResult

	if FunctionResult == "refresh_unavailable" then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE)

		self._refresh_requests[arg_16_1] = {}

		return
	end

	local current_daily_quests = FunctionResult.current_daily_quests
	local daily_quest_refresh_available = FunctionResult.daily_quest_refresh_available

	_backend_mirror:set_quest_data("current_daily_quests", current_daily_quests)
	_backend_mirror:set_quest_data("daily_quest_refresh_available", to_boolean(daily_quest_refresh_available))

	self._refresh_requests[arg_16_1] = {
		quest_key = arg_16_2
	}
	self._dirty = true
end

BackendInterfaceQuestsPlayfab.is_quest_refreshed = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self._refresh_requests[arg_17_1]

	if not var_17_0 then
		return true, var_17_0.quest_key
	end

	return false
end

BackendInterfaceQuestsPlayfab.can_claim_quest_rewards = function (self, arg_18_1)
	-- function 18
	local get_quests = self:get_quests()
	local daily = self._quests.daily
	local weekly = self._quests.weekly
	local event = self._quests.event

	if daily[arg_18_1] or weekly[arg_18_1] or not event[arg_18_1] then
		return true
	end

	return false
end

BackendInterfaceQuestsPlayfab.can_claim_multiple_quest_rewards = function (self, arg_19_1)
	-- function 19
	local daily = self._quests.daily
	local weekly = self._quests.weekly
	local event = self._quests.event
	local tbl = {}

	for i = 1, #arg_19_1 do
		local var_19_4 = arg_19_1[i]

		if daily[var_19_4] or weekly[var_19_4] or not event[var_19_4] then
			tbl[#tbl + 1] = var_19_4
		end
	end

	if not table.is_empty(tbl) then
		return true, tbl
	end

	return false, nil
end

BackendInterfaceQuestsPlayfab.claim_quest_rewards = function (self, arg_20_1)
	-- function 20
	local _new_id = self:_new_id()
	local tbl = {
		quest_key = arg_20_1,
		id = _new_id
	}
	local tbl_2 = {
		FunctionName = "generateQuestRewards",
		FunctionParameter = tbl
	}
	local var_20_3 = callback(self, "quest_rewards_request_cb", tbl)

	self._backend_mirror:request_queue():enqueue(tbl_2, var_20_3, true)

	return _new_id
end

BackendInterfaceQuestsPlayfab.quest_rewards_request_cb = function (self, arg_21_1, arg_21_2)
	-- function 21
	local FunctionResult = arg_21_2.FunctionResult

	if not FunctionResult then
		Managers.backend:playfab_api_error(arg_21_2)

		return
	end

	local id = arg_21_1.id
	local items = FunctionResult.items
	local chips = FunctionResult.chips
	local currency_added = FunctionResult.currency_added
	local _backend_mirror = self._backend_mirror
	local tbl = {
		quest_key = arg_21_1.quest_key,
		loot = {}
	}
	local loot = tbl.loot

	if not items then
		for i = 1, #items do
			local var_21_8 = items[i]
			local ItemInstanceId = var_21_8.ItemInstanceId
			local UsesIncrementedBy = var_21_8.UsesIncrementedBy

			UsesIncrementedBy = UsesIncrementedBy or 1

			_backend_mirror:add_item(ItemInstanceId, var_21_8)

			loot[i] = {
				type = "item",
				backend_id = ItemInstanceId,
				amount = UsesIncrementedBy
			}
		end
	end

	local new_keep_decorations = FunctionResult.new_keep_decorations

	if not new_keep_decorations then
		for j = 1, #new_keep_decorations do
			local var_21_12 = new_keep_decorations[j]

			_backend_mirror:add_keep_decoration(var_21_12)

			loot[#loot + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_21_12
			}
		end
	end

	local new_weapon_skins = FunctionResult.new_weapon_skins

	if not new_weapon_skins then
		for k = 1, #new_weapon_skins do
			local var_21_14 = new_weapon_skins[k]

			_backend_mirror:add_unlocked_weapon_skin(var_21_14)

			loot[#loot + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_21_14
			}
		end
	end

	local new_cosmetics = FunctionResult.new_cosmetics

	if not new_cosmetics then
		local ItemMasterList = ItemMasterList

		for l = 1, #new_cosmetics do
			local var_21_17 = new_cosmetics[l]
			local add_item = _backend_mirror:add_item(nil, {
				ItemId = var_21_17
			})

			if not add_item then
				local var_21_19 = ItemMasterList[var_21_17]

				loot[#loot + 1] = {
					amount = 1,
					type = var_21_19.slot_type,
					backend_id = add_item
				}
			end
		end
	end

	local tbl_2 = {}

	if not currency_added then
		for i_2, v in ipairs(currency_added) do
			local code = v.code
			local amount = v.amount
			local var_21_23 = tbl_2[code]

			tbl_2[code] = not var_21_23 and var_21_23 and 0 + amount
			loot[#loot + 1] = {
				type = "currency",
				currency_code = code,
				amount = amount
			}
		end
	end

	if not chips then
		local get_interface = Managers.backend:get_interface("peddler")

		if not get_interface then
			for k_2, v_2 in pairs(chips) do
				get_interface:set_chips(k_2, v_2)
			end
		end
	end

	local chest_inventory = FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	local var_21_26
	local var_21_27

	if not FunctionResult.quest_name then
		var_21_26 = FunctionResult.quest_name
		var_21_27 = FunctionResult.quest_type
	else
		local tbl_3 = {
			"current_daily_quests",
			"current_event_quests",
			"current_weekly_quests"
		}
		local tbl_4 = {
			current_event_quests = "event",
			current_weekly_quests = "weekly",
			current_daily_quests = "daily"
		}
		local get_quest_data = _backend_mirror:get_quest_data()

		for i8 = 1, #tbl_3 do
			local var_21_31 = tbl_3[i8]
			local var_21_32 = get_quest_data[var_21_31][arg_21_1.quest_key]

			if not var_21_32 then
				var_21_26 = var_21_32.name
				var_21_27 = tbl_4[var_21_31]

				break
			end
		end
	end

	if var_21_27 == "event" then
		_backend_mirror:add_claimed_event_quest(var_21_26)
	end

	local current_daily_quests = FunctionResult.current_daily_quests

	current_daily_quests = current_daily_quests or {}

	local current_weekly_quests = FunctionResult.current_weekly_quests

	current_weekly_quests = current_weekly_quests or {}

	local current_event_quests = FunctionResult.current_event_quests

	current_event_quests = current_event_quests or {}

	_backend_mirror:set_quest_data("current_daily_quests", current_daily_quests)
	_backend_mirror:set_quest_data("current_weekly_quests", current_weekly_quests)
	_backend_mirror:set_quest_data("current_event_quests", current_event_quests)

	local player = Managers.player

	player = not player and Managers.player:local_player()

	local statistics_db = Managers.player:statistics_db()

	if not (not player and statistics_db) then
		Application.warning("[BackendInterfaceQuestsPlayfab] Could not get statistics_db, skipping updating statistics...")
	else
		local stats_id = player:stats_id()
		local get_quests = self:get_quests()
		local daily = get_quests.daily
		local weekly = get_quests.weekly

		for k_3, v_3 in pairs(daily) do
			if k_3 == arg_21_1.quest_key then
				statistics_db:increment_stat(stats_id, "completed_daily_quests")

				break
			end
		end

		for k_4, v_4 in pairs(weekly) do
			if k_4 == arg_21_1.quest_key then
				statistics_db:increment_stat(stats_id, "completed_weekly_quests")

				break
			end
		end
	end

	self._quest_reward_requests[id] = tbl
	self._dirty = true
end

BackendInterfaceQuestsPlayfab.claim_multiple_quest_rewards = function (self, arg_22_1)
	-- function 22
	local tbl = {}
	local _new_id = self:_new_id()

	for i = 1, #arg_22_1 do
		local var_22_2 = arg_22_1[i]
		local tbl_2 = {
			quest_key = var_22_2
		}

		tbl[#tbl + 1] = tbl_2
	end

	local tbl_3 = {
		FunctionName = "generateQuestRewards",
		FunctionParameter = {
			quest_data = tbl,
			id = _new_id
		}
	}
	local var_22_5 = callback(self, "claim_multiple_quest_rewards_request_cb", tbl, _new_id)

	self._backend_mirror:request_queue():enqueue(tbl_3, var_22_5, true)

	return _new_id
end

BackendInterfaceQuestsPlayfab.claim_multiple_quest_rewards_request_cb = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local FunctionResult = arg_23_3.FunctionResult

	if not FunctionResult then
		Managers.backend:playfab_api_error(arg_23_3)

		return
	end

	local var_23_1 = arg_23_2
	local items = FunctionResult.items
	local chips = FunctionResult.chips
	local currency_added = FunctionResult.currency_added
	local _backend_mirror = self._backend_mirror
	local quest_data_names = FunctionResult.quest_data_names
	local tbl = {}

	for i = 1, #arg_23_1 do
		tbl[#tbl + 1] = arg_23_1[i].quest_key
	end

	local tbl_2 = {
		quest_key = tbl,
		loot = {}
	}
	local loot = tbl_2.loot

	if not items then
		for j = 1, #items do
			local var_23_10 = items[j]
			local ItemInstanceId = var_23_10.ItemInstanceId
			local UsesIncrementedBy = var_23_10.UsesIncrementedBy

			UsesIncrementedBy = UsesIncrementedBy or 1

			_backend_mirror:add_item(ItemInstanceId, var_23_10)

			loot[j] = {
				type = "item",
				backend_id = ItemInstanceId,
				amount = UsesIncrementedBy
			}
		end
	end

	local new_keep_decorations = FunctionResult.new_keep_decorations

	if not new_keep_decorations then
		for k = 1, #new_keep_decorations do
			local var_23_14 = new_keep_decorations[k]

			_backend_mirror:add_keep_decoration(var_23_14)

			loot[#loot + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_23_14
			}
		end
	end

	local new_weapon_skins = FunctionResult.new_weapon_skins

	if not new_weapon_skins then
		for l = 1, #new_weapon_skins do
			local var_23_16 = new_weapon_skins[l]

			_backend_mirror:add_unlocked_weapon_skin(var_23_16)

			loot[#loot + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_23_16
			}
		end
	end

	local new_cosmetics = FunctionResult.new_cosmetics

	if not new_cosmetics then
		local ItemMasterList = ItemMasterList

		for i4 = 1, #new_cosmetics do
			local var_23_19 = new_cosmetics[i4]
			local add_item = _backend_mirror:add_item(nil, {
				ItemId = var_23_19
			})

			if not add_item then
				local var_23_21 = ItemMasterList[var_23_19]

				loot[#loot + 1] = {
					amount = 1,
					type = var_23_21.slot_type,
					backend_id = add_item
				}
			end
		end
	end

	local tbl_3 = {}

	if not currency_added then
		for i_2, v in ipairs(currency_added) do
			local code = v.code
			local amount = v.amount
			local var_23_25 = tbl_3[code]

			tbl_3[code] = not var_23_25 and var_23_25 and 0 + amount
			loot[#loot + 1] = {
				type = "currency",
				currency_code = code,
				amount = amount
			}
		end
	end

	if not chips then
		local get_interface = Managers.backend:get_interface("peddler")

		if not get_interface then
			for k_2, v_2 in pairs(chips) do
				get_interface:set_chips(k_2, v_2)
			end
		end
	end

	local chest_inventory = FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	local tbl_4 = {}
	local var_23_29

	if not quest_data_names then
		for i9 = 1, #quest_data_names do
			tbl_4[#tbl_4 + 1] = quest_data_names[i9]
		end

		var_23_29 = FunctionResult.quest_type
	else
		local tbl_5 = {
			"current_daily_quests",
			"current_event_quests",
			"current_weekly_quests"
		}
		local tbl_6 = {
			current_event_quests = "event",
			current_weekly_quests = "weekly",
			current_daily_quests = "daily"
		}
		local get_quest_data = _backend_mirror:get_quest_data()

		for i10 = 1, #arg_23_1 do
			for i11 = 1, #tbl_5 do
				local var_23_33 = tbl_5[i11]
				local var_23_34 = get_quest_data[var_23_33][arg_23_1[i10].quest_key]

				if not var_23_34 then
					tbl_4[#tbl_4 + 1] = var_23_34.name
					var_23_29 = var_23_29 or tbl_6[var_23_33]
				end
			end
		end
	end

	if var_23_29 == "event" then
		_backend_mirror:add_claimed_multiple_event_quests(tbl_4)
	end

	local current_daily_quests = FunctionResult.current_daily_quests
	local current_weekly_quests = FunctionResult.current_weekly_quests
	local current_event_quests = FunctionResult.current_event_quests

	_backend_mirror:set_quest_data("current_daily_quests", current_daily_quests)
	_backend_mirror:set_quest_data("current_weekly_quests", current_weekly_quests)
	_backend_mirror:set_quest_data("current_event_quests", current_event_quests)

	local player = Managers.player

	player = not player and Managers.player:local_player()

	local statistics_db = Managers.player:statistics_db()

	if not (not player and statistics_db) then
		Application.warning("[BackendInterfaceQuestsPlayfab] Could not get statistics_db, skipping updating statistics...")
	else
		local stats_id = player:stats_id()
		local get_quests = self:get_quests()
		local daily = get_quests.daily
		local weekly = get_quests.weekly

		for i12 = 1, #arg_23_1 do
			for k_3, v_3 in pairs(daily) do
				if k_3 == arg_23_1[i12].quest_key then
					statistics_db:increment_stat(stats_id, "completed_daily_quests")

					break
				end
			end

			for k_4, v_4 in pairs(weekly) do
				if k_4 == arg_23_1[i12].quest_key then
					statistics_db:increment_stat(stats_id, "completed_weekly_quests")

					break
				end
			end
		end
	end

	self._quest_reward_requests[var_23_1] = tbl_2
	self._dirty = true
end

BackendInterfaceQuestsPlayfab.get_quest_key = function (self, arg_24_1)
	-- function 24
	local get_quests = self:get_quests()
	local daily = get_quests.daily
	local weekly = get_quests.weekly
	local event = get_quests.event

	for k, v in pairs(daily) do
		if v.name == arg_24_1 then
			return k
		end
	end

	for k_2, v_2 in pairs(weekly) do
		if v_2.name == arg_24_1 then
			return k_2
		end
	end

	for k_3, v_3 in pairs(event) do
		if v_3.name == arg_24_1 then
			return k_3
		end
	end

	return nil
end

BackendInterfaceQuestsPlayfab.get_quest_by_key = function (self, arg_25_1)
	-- function 25
	local get_quests = self:get_quests()
	local daily = get_quests.daily
	local weekly = get_quests.weekly
	local event = get_quests.event

	for k, v in pairs(daily) do
		if arg_25_1 == k then
			return v
		end
	end

	for k_2, v_2 in pairs(weekly) do
		if arg_25_1 == k_2 then
			return v_2
		end
	end

	for k_3, v_3 in pairs(event) do
		if arg_25_1 == k_3 then
			return v_3
		end
	end

	return nil
end

BackendInterfaceQuestsPlayfab.quest_rewards_generated = function (self, arg_26_1)
	-- function 26
	if not self._quest_reward_requests[arg_26_1] then
		return true
	end

	return false
end

BackendInterfaceQuestsPlayfab.get_quest_rewards = function (self, arg_27_1)
	-- function 27
	return self._quest_reward_requests[arg_27_1]
end

BackendInterfaceQuestsPlayfab.get_claimed_event_quests = function (self)
	-- function 28
	return self._backend_mirror:get_claimed_event_quests()
end
