-- chunkname: @scripts/managers/backend_playfab/backend_interface_loot_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceLootPlayfab = class(BackendInterfaceLootPlayfab)

BackendInterfaceLootPlayfab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._last_id = 0
	self._loot_requests = {}
	self._reward_poll_id = false
end

BackendInterfaceLootPlayfab.ready = function (arg_2_0)
	-- function 2
	return true
end

BackendInterfaceLootPlayfab.update = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

BackendInterfaceLootPlayfab._new_id = function (self)
	-- function 4
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceLootPlayfab.open_loot_chest = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local _new_id = self:_new_id()
	local tbl = {
		hero_name = arg_5_1,
		playfab_id = arg_5_2,
		id = _new_id,
		amount = arg_5_4 or 1,
		game_mode_key = arg_5_3
	}
	local tbl_2 = {
		FunctionName = "generateLootChestRewards",
		FunctionParameter = tbl
	}
	local var_5_3 = callback(self, "loot_chest_rewards_request_cb", tbl)

	self._backend_mirror:request_queue():enqueue(tbl_2, var_5_3, true)

	return _new_id
end

BackendInterfaceLootPlayfab.loot_chest_rewards_request_cb = function (self, arg_6_1, arg_6_2)
	-- function 6
	local FunctionResult = arg_6_2.FunctionResult
	local items = FunctionResult.items
	local unlocked_weapon_skins = FunctionResult.unlocked_weapon_skins
	local new_weapon_skin_rewards = FunctionResult.new_weapon_skin_rewards
	local new_cosmetics = FunctionResult.new_cosmetics
	local new_unlocked_weapon_poses = FunctionResult.new_unlocked_weapon_poses
	local updated_statistics = FunctionResult.updated_statistics
	local consumed_chest = FunctionResult.consumed_chest
	local flag = not consumed_chest and consumed_chest.ItemInstanceId
	local flag_2 = not consumed_chest and consumed_chest.RemainingUses
	local count = #items
	local tbl = {}
	local _backend_mirror = self._backend_mirror

	for i = 1, count do
		local var_6_13 = items[i]
		local ItemInstanceId = var_6_13.ItemInstanceId
		local add_item = _backend_mirror:add_item(ItemInstanceId, var_6_13)

		tbl[#tbl + 1] = add_item or ItemInstanceId
	end

	if not flag then
		if flag_2 > 0 then
			_backend_mirror:update_item_field(flag, "RemainingUses", flag_2)
		else
			_backend_mirror:remove_item(flag)
		end
	end

	if not unlocked_weapon_skins then
		for j = 1, #unlocked_weapon_skins do
			_backend_mirror:add_unlocked_weapon_skin(unlocked_weapon_skins[j])
		end
	end

	if not new_weapon_skin_rewards then
		local get_unlocked_weapon_skins = _backend_mirror:get_unlocked_weapon_skins()

		for k = 1, #new_weapon_skin_rewards do
			local var_6_17 = get_unlocked_weapon_skins[new_weapon_skin_rewards[k]]

			if not var_6_17 then
				tbl[#tbl + 1] = var_6_17
			end
		end
	end

	if not new_cosmetics then
		for l = 1, #new_cosmetics do
			local add_item_2 = _backend_mirror:add_item(nil, {
				ItemId = new_cosmetics[l]
			})

			if not add_item_2 then
				tbl[#tbl + 1] = add_item_2
			end
		end
	end

	if not new_unlocked_weapon_poses then
		for i4 = 1, #new_unlocked_weapon_poses do
			local add_item_3 = _backend_mirror:add_item(nil, {
				ItemId = new_unlocked_weapon_poses[i4]
			})

			if not add_item_3 then
				tbl[#tbl + 1] = add_item_3
			end
		end
	end

	if not updated_statistics then
		local player = Managers.player

		player = not player and Managers.player:local_player_safe()

		local statistics_db = Managers.player:statistics_db()

		if not (not player and statistics_db) then
			print("[BackendInterfaceLootPlayfab] Could not get statistics_db, skipping updating statistics...")
		else
			local stats_id = player:stats_id()

			for k_2, v in pairs(updated_statistics) do
				if not statistics_db.statistics[stats_id][k_2] then
					Application.warning("[BackendInterfaceLootPlayfab] updated_statistics " .. k_2 .. " doesn't exist.")
				else
					statistics_db:set_stat(stats_id, k_2, v)
				end
			end
		end
	end

	local chest_inventory = FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	local id = arg_6_1.id

	self._loot_requests[id] = tbl
end

BackendInterfaceLootPlayfab.generate_end_of_level_loot = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12, arg_7_13, arg_7_14, arg_7_15)
	-- function 7
	local _new_id = self:_new_id()
	local _get_remote_player_network_ids_and_characters = self:_get_remote_player_network_ids_and_characters()

	if not arg_7_15.deus_soft_currency then
		self._backend_mirror:predict_deus_rolled_over_soft_currency(arg_7_15.deus_soft_currency)
	end

	local tbl = {
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
		id = _new_id,
		remote_player_ids_and_characters = _get_remote_player_network_ids_and_characters,
		game_mode_key = arg_7_13,
		game_time = arg_7_14,
		end_of_level_rewards_arguments = arg_7_15
	}
	local tbl_2 = {
		FunctionName = "generateEndOfLevelLoot",
		FunctionParameter = tbl
	}
	local var_7_4 = callback(self, "end_of_level_loot_request_cb", tbl)

	self._backend_mirror:request_queue():enqueue(tbl_2, var_7_4, true)

	return _new_id
end

BackendInterfaceLootPlayfab.end_of_level_loot_request_cb = function (self, arg_8_1, arg_8_2)
	-- function 8
	Managers.telemetry_events:end_of_game_rewards(arg_8_2.FunctionResult)

	local FunctionResult = arg_8_2.FunctionResult
	local id = arg_8_1.id
	local Experience = FunctionResult.Experience
	local ExperiencePool = FunctionResult.ExperiencePool
	local RecentQuickplayGames = FunctionResult.RecentQuickplayGames
	local total_essence = FunctionResult.total_essence
	local vs_profile_data = FunctionResult.vs_profile_data
	local ScoreBreakdown = FunctionResult.ScoreBreakdown
	local ItemsGranted = FunctionResult.ItemsGranted

	ItemsGranted = ItemsGranted or FunctionResult.Result

	local ItemRewards = FunctionResult.ItemRewards

	ItemRewards = ItemRewards or FunctionResult.Rewards

	local CurrencyGranted = FunctionResult.CurrencyGranted
	local currencyRewards = FunctionResult.currencyRewards
	local EssenceRewards = FunctionResult.EssenceRewards
	local cosmetic_rewards = FunctionResult.cosmetic_rewards
	local weapon_skin_rewards = FunctionResult.weapon_skin_rewards
	local keep_decoration_rewards = FunctionResult.keep_decoration_rewards
	local experience_rewards = FunctionResult.experience_rewards
	local weekly_event_rewards = FunctionResult.weekly_event_rewards
	local ItemsRevoked = FunctionResult.ItemsRevoked
	local ConsumedDeedResult = FunctionResult.ConsumedDeedResult
	local count = #ItemsGranted
	local win_tracks_progress = FunctionResult.win_tracks_progress
	local tbl = {}
	local _backend_mirror = self._backend_mirror

	for k, v in pairs(ItemRewards) do
		local var_8_24
		local var_8_25

		for k_2 = 1, count do
			var_8_25 = ItemsGranted[k_2]

			if v.ItemId == var_8_25.ItemId then
				var_8_24 = var_8_25.ItemInstanceId

				break
			end
		end

		tbl[k] = {
			backend_id = var_8_24
		}

		if k == "chest" then
			tbl[k].score_breakdown = ScoreBreakdown
		end

		_backend_mirror:add_item(var_8_24, var_8_25)
	end

	if not cosmetic_rewards then
		for k_3, v_2 in pairs(cosmetic_rewards) do
			local add_item = _backend_mirror:add_item(nil, {
				ItemId = v_2
			})

			if not add_item then
				tbl[k_3] = {
					backend_id = add_item
				}
			end
		end
	end

	if not weapon_skin_rewards then
		for k_4, v_3 in pairs(weapon_skin_rewards) do
			local add_item_2 = _backend_mirror:add_item(nil, {
				ItemId = v_3
			})

			if not add_item_2 then
				tbl[k_4] = {
					backend_id = add_item_2
				}
			end
		end
	end

	if not keep_decoration_rewards then
		for k_5, v_4 in pairs(keep_decoration_rewards) do
			_backend_mirror:add_keep_decoration(v_4)

			tbl[k_5] = {
				type = "keep_decoration_painting",
				keep_decoration_name = v_4
			}
		end
	end

	if not experience_rewards then
		for k_6, v_5 in pairs(experience_rewards) do
			tbl[k_6] = {
				amount = v_5
			}
		end
	end

	local chest_inventory = arg_8_2.FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	if not ItemsRevoked then
		for i11 = 1, #ItemsRevoked do
			local ItemInstanceId = ItemsRevoked[i11].ItemInstanceId

			_backend_mirror:remove_item(ItemInstanceId)
		end
	elseif not ConsumedDeedResult then
		local ItemInstanceId_2 = ConsumedDeedResult.ItemInstanceId

		_backend_mirror:remove_item(ItemInstanceId_2)
	end

	local hero_name = arg_8_1.hero_name
	local str = hero_name .. "_experience"

	_backend_mirror:set_read_only_data(str, Experience, true)

	local str_2 = "win_tracks_progress"

	self._backend_mirror:set_read_only_data(str_2, cjson.encode(win_tracks_progress), true)

	if not weekly_event_rewards then
		_backend_mirror:set_read_only_data("weekly_event_rewards", cjson.encode(weekly_event_rewards), true)
	end

	if not ExperiencePool then
		local str_3 = hero_name .. "_experience_pool"

		_backend_mirror:set_read_only_data(str_3, ExperiencePool, true)
	end

	if not RecentQuickplayGames then
		_backend_mirror:set_read_only_data("recent_quickplay_games", RecentQuickplayGames, true)
	end

	if not vs_profile_data then
		_backend_mirror:set_read_only_data("vs_profile_data", vs_profile_data, true)
	end

	if not CurrencyGranted then
		for k_7, v_6 in pairs(CurrencyGranted) do
			if k_7 == "ES" then
				tbl.essence = v_6

				_backend_mirror:set_essence(v_6.new_total)
			elseif k_7 == "SM" then
				tbl.shillings = v_6

				Managers.backend:get_interface("peddler"):set_chips(k_7, v_6.new_total)
			elseif k_7 == "VS" then
				tbl.versus_currency = v_6

				Managers.backend:get_interface("peddler"):set_chips(k_7, v_6.new_total)
			else
				fassert(false, string.format("currency '%s' not supported", k_7))
			end
		end
	elseif not (not EssenceRewards and not (#EssenceRewards > 0)) then
		tbl.essence = EssenceRewards

		local new_total = EssenceRewards[#EssenceRewards].new_total

		_backend_mirror:set_essence(new_total)
	end

	if not currencyRewards then
		for k_8, v_7 in pairs(currencyRewards) do
			tbl[k_8] = v_7
		end
	end

	_backend_mirror:set_total_essence(total_essence)
	_backend_mirror:handle_deus_result(arg_8_2)
	Managers.backend:dirtify_interfaces()

	self._loot_requests[id] = tbl
end

BackendInterfaceLootPlayfab._get_remote_player_network_ids_and_characters = function (arg_9_0)
	-- function 9
	local tbl = {}

	if IS_WINDOWS or not IS_LINUX then
		if not rawget(_G, "Steam") then
			local human_players = Managers.player:human_players()

			for k, v in pairs(human_players) do
				if not v.remote then
					local network_id = v:network_id()
					local profile_index = v:profile_index()
					local career_index = v:career_index()
					local playfab_name = SPProfiles[profile_index].careers[career_index].playfab_name

					tbl[Steam.id_hex_to_dec(network_id)] = playfab_name
				end
			end
		end
	elseif not IS_XB1 then
		local human_players_2 = Managers.player:human_players()

		for k_2, v_2 in pairs(human_players_2) do
			if not v_2.remote then
				local network_id_2 = v_2:network_id()
				local profile_index_2 = v_2:profile_index()
				local career_index_2 = v_2:career_index()
				local playfab_name_2 = SPProfiles[profile_index_2].careers[career_index_2].playfab_name

				tbl[v_2:platform_id()] = playfab_name_2
			end
		end
	elseif not IS_PS4 then
		local human_players_3 = Managers.player:human_players()

		for k_3, v_3 in pairs(human_players_3) do
			if not v_3.remote then
				local network_id_3 = v_3:network_id()
				local profile_index_3 = v_3:profile_index()
				local career_index_3 = v_3:career_index()
				local playfab_name_3 = SPProfiles[profile_index_3].careers[career_index_3].playfab_name
				local platform_id = v_3:platform_id()

				tbl[Application.hex64_to_dec(network_id_3)] = playfab_name_3
			end
		end
	end

	return tbl
end

BackendInterfaceLootPlayfab.get_achievement_rewards = function (self, arg_10_1)
	-- function 10
	local get_achievement_rewards = self._backend_mirror:get_achievement_rewards()
	local var_10_1 = get_achievement_rewards[arg_10_1]

	var_10_1 = not var_10_1 and get_achievement_rewards[arg_10_1][1]

	return var_10_1
end

BackendInterfaceLootPlayfab.achievement_rewards_claimed = function (self, arg_11_1)
	-- function 11
	return self._backend_mirror:get_claimed_achievements()[arg_11_1]
end

BackendInterfaceLootPlayfab.can_claim_achievement_rewards = function (self, arg_12_1)
	-- function 12
	if not self._backend_mirror:get_claimed_achievements()[arg_12_1] then
		return true
	end

	return false
end

BackendInterfaceLootPlayfab.claim_achievement_rewards = function (self, arg_13_1, arg_13_2)
	-- function 13
	self._reward_poll_id = true

	local tbl = {
		achievement_id = arg_13_1,
		id = arg_13_2
	}
	local tbl_2 = {
		FunctionName = "generateAchievementRewards",
		FunctionParameter = tbl
	}
	local var_13_2 = callback(self, "achievement_rewards_request_cb", tbl)

	self._backend_mirror:request_queue():enqueue(tbl_2, var_13_2, true)
end

BackendInterfaceLootPlayfab.achievement_rewards_request_cb = function (self, arg_14_1, arg_14_2)
	-- function 14
	local FunctionResult = arg_14_2.FunctionResult
	local id = arg_14_1.id

	if not FunctionResult then
		Managers.backend:playfab_api_error(arg_14_2)

		return
	elseif not FunctionResult.error_message then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED)

		self._loot_requests[id] = {}

		return
	end

	local items = FunctionResult.items
	local achievement_id = FunctionResult.achievement_id
	local currency_added = FunctionResult.currency_added
	local chips = FunctionResult.chips
	local _backend_mirror = self._backend_mirror
	local tbl = {}

	if not items then
		for i = 1, #items do
			local var_14_8 = items[i]
			local ItemInstanceId = var_14_8.ItemInstanceId
			local UsesIncrementedBy = var_14_8.UsesIncrementedBy

			UsesIncrementedBy = UsesIncrementedBy or 1

			_backend_mirror:add_item(ItemInstanceId, var_14_8)

			tbl[#tbl + 1] = {
				type = "item",
				backend_id = ItemInstanceId,
				amount = UsesIncrementedBy
			}
		end
	end

	local new_keep_decorations = FunctionResult.new_keep_decorations

	if not new_keep_decorations then
		for j = 1, #new_keep_decorations do
			local var_14_12 = new_keep_decorations[j]

			_backend_mirror:add_keep_decoration(var_14_12)

			tbl[#tbl + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_14_12
			}
		end
	end

	local new_weapon_skins = FunctionResult.new_weapon_skins

	if not new_weapon_skins then
		for k = 1, #new_weapon_skins do
			local var_14_14 = new_weapon_skins[k]

			_backend_mirror:add_unlocked_weapon_skin(var_14_14)

			tbl[#tbl + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_14_14
			}
		end
	end

	local new_cosmetics = FunctionResult.new_cosmetics

	if not new_cosmetics then
		local ItemMasterList = ItemMasterList

		for l = 1, #new_cosmetics do
			local var_14_17 = new_cosmetics[l]
			local var_14_18 = rawget(ItemMasterList, var_14_17)
			local add_item = _backend_mirror:add_item(nil, {
				ItemId = var_14_17
			})

			if not add_item then
				tbl[#tbl + 1] = {
					type = var_14_18.slot_type,
					backend_id = add_item
				}
			end
		end
	end

	local tbl_2 = {}

	if not currency_added then
		for k_2, v in pairs(currency_added) do
			tbl[#tbl + 1] = {
				type = "currency",
				currency_code = k_2,
				amount = v
			}
		end
	end

	if not chips then
		local get_interface = Managers.backend:get_interface("peddler")

		if not get_interface then
			for k_3, v_2 in pairs(chips) do
				get_interface:set_chips(k_3, v_2)
			end
		end
	end

	local chest_inventory = FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	local achievement_reward_levels = FunctionResult.achievement_reward_levels

	if not achievement_reward_levels then
		_backend_mirror:set_read_only_data("achievement_reward_levels", achievement_reward_levels, true)
	end

	_backend_mirror:set_achievement_claimed(achievement_id)

	self._loot_requests[id] = tbl
	self._reward_poll_id = nil

	Managers.backend:dirtify_interfaces()
end

BackendInterfaceLootPlayfab.can_claim_all_achievement_rewards = function (self, arg_15_1)
	-- function 15
	local tbl = {}
	local tbl_2 = {}
	local get_claimed_achievements = self._backend_mirror:get_claimed_achievements()

	for i = 0, #arg_15_1 do
		local var_15_3 = arg_15_1[i]

		if not get_claimed_achievements[var_15_3] then
			table.insert(tbl, var_15_3)
		else
			table.insert(tbl_2, var_15_3)
		end
	end

	if not table.is_empty(tbl) then
		return false, nil, tbl_2
	else
		return true, tbl, tbl_2
	end
end

local num = 150

BackendInterfaceLootPlayfab.claim_multiple_achievement_rewards = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	self._reward_poll_id = true
	arg_16_3 = arg_16_3 or 1
	arg_16_4 = arg_16_4 or num

	local tbl = {}
	local count = #arg_16_1
	local var_16_2 = arg_16_2
	local var_16_3
	local var_16_4 = num

	if arg_16_3 > 1 then
		var_16_3 = table.slice(arg_16_1, arg_16_3, count)
	else
		var_16_3 = arg_16_1
	end

	if #var_16_3 <= num then
		var_16_4 = #var_16_3
	end

	for i = 1, var_16_4 do
		local var_16_5 = var_16_3[i]
		local tbl_2 = {
			achievement_id = var_16_5
		}

		tbl[#tbl + 1] = tbl_2
	end

	local tbl_3 = {
		FunctionName = "generateAchievementRewards",
		FunctionParameter = {
			achievement_ids = tbl,
			id = var_16_2
		}
	}
	local var_16_8 = callback(self, "claim_multiple_achievement_rewards_request_cb", tbl, var_16_2, arg_16_3, arg_16_4, arg_16_1)

	self._backend_mirror:request_queue():enqueue(tbl_3, var_16_8, true)
end

BackendInterfaceLootPlayfab.claim_multiple_achievement_rewards_request_cb = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	-- function 17
	print("[BackendInterfaceLootPlayfab]:claim_all_achievement_rewards_request_cb: Firing!")

	local FunctionResult = arg_17_6.FunctionResult
	local var_17_1 = arg_17_2
	local var_17_2 = arg_17_5

	if not FunctionResult then
		Managers.backend:playfab_api_error(arg_17_6)

		return
	elseif FunctionResult == "reward_claimed" then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED)

		self._loot_requests[var_17_1] = {}

		return
	end

	if self._loot_requests[var_17_1] == nil then
		self._loot_requests[var_17_1] = {}
	end

	local items = FunctionResult.items
	local achievement_id = FunctionResult.achievement_id
	local currency_added = FunctionResult.currency_added
	local chips = FunctionResult.chips
	local _backend_mirror = self._backend_mirror
	local tbl = {}

	if not items then
		for i = 1, #items do
			local var_17_9 = items[i]
			local ItemInstanceId = var_17_9.ItemInstanceId
			local UsesIncrementedBy = var_17_9.UsesIncrementedBy

			UsesIncrementedBy = UsesIncrementedBy or 1

			_backend_mirror:add_item(ItemInstanceId, var_17_9)

			tbl[#tbl + 1] = {
				type = "item",
				backend_id = ItemInstanceId,
				amount = UsesIncrementedBy
			}
		end
	end

	local new_keep_decorations = FunctionResult.new_keep_decorations

	if not new_keep_decorations then
		for j = 1, #new_keep_decorations do
			local var_17_13 = new_keep_decorations[j]

			_backend_mirror:add_keep_decoration(var_17_13)

			tbl[#tbl + 1] = {
				type = "keep_decoration_painting",
				keep_decoration_name = var_17_13
			}
		end
	end

	local new_weapon_skins = FunctionResult.new_weapon_skins

	if not new_weapon_skins then
		for k = 1, #new_weapon_skins do
			local var_17_15 = new_weapon_skins[k]

			_backend_mirror:add_unlocked_weapon_skin(var_17_15)

			tbl[#tbl + 1] = {
				type = "weapon_skin",
				weapon_skin_name = var_17_15
			}
		end
	end

	local new_cosmetics = FunctionResult.new_cosmetics

	if not new_cosmetics then
		local ItemMasterList = ItemMasterList

		for l = 1, #new_cosmetics do
			local var_17_18 = new_cosmetics[l]
			local var_17_19 = rawget(ItemMasterList, var_17_18)
			local add_item = _backend_mirror:add_item(nil, {
				ItemId = var_17_18
			})

			if not add_item then
				tbl[#tbl + 1] = {
					type = var_17_19.slot_type,
					backend_id = add_item
				}
			end
		end
	end

	local tbl_2 = {}

	if not currency_added then
		for k_2, v in pairs(currency_added) do
			tbl[#tbl + 1] = {
				type = "currency",
				currency_code = k_2,
				amount = v
			}
		end
	end

	if not chips then
		local get_interface = Managers.backend:get_interface("peddler")

		if not get_interface then
			for k_3, v_2 in pairs(chips) do
				get_interface:set_chips(k_3, v_2)
			end
		end
	end

	local chest_inventory = FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	local achievement_reward_levels = FunctionResult.achievement_reward_levels

	if not achievement_reward_levels then
		_backend_mirror:set_read_only_data("achievement_reward_levels", achievement_reward_levels, true)
	end

	if not achievement_id then
		for i8 = 1, #achievement_id do
			local achievement_id_2 = achievement_id[i8].achievement_id

			_backend_mirror:set_achievement_claimed(achievement_id_2)
		end

		for i9 = 1, #tbl do
			table.insert(self._loot_requests[var_17_1], tbl[i9])
		end
	else
		local requested_achievement_ids = FunctionResult.requested_achievement_ids

		requested_achievement_ids = requested_achievement_ids or {}

		table.dump(requested_achievement_ids)
		Crashify.print_exception("Failed to claim multiple challenges")
	end

	if arg_17_4 < #var_17_2 then
		local num_2 = arg_17_3 + num
		local num_3 = arg_17_4 + num

		self:claim_multiple_achievement_rewards(var_17_2, var_17_1, num_2, num_3)
	else
		self._reward_poll_id = nil

		Managers.backend:dirtify_interfaces()
	end
end

BackendInterfaceLootPlayfab.polling_reward = function (self)
	-- function 18
	return self._reward_poll_id
end

BackendInterfaceLootPlayfab.is_loot_generated = function (self, arg_19_1)
	-- function 19
	if not self._loot_requests[arg_19_1] then
		return true
	end

	return false
end

BackendInterfaceLootPlayfab.get_loot = function (self, arg_20_1)
	-- function 20
	return self._loot_requests[arg_20_1]
end

BackendInterfaceLootPlayfab.generate_reward_loot_id = function (self)
	-- function 21
	return self:_new_id()
end

BackendInterfaceLootPlayfab.get_power_level_settings = function (self)
	-- function 22
	return self._backend_mirror:get_power_level_settings()
end

BackendInterfaceLootPlayfab.debug_override_power_level_settings = function (self, arg_23_1)
	-- function 23
	self._backend_mirror:debug_override_power_level_settings(arg_23_1)
end

BackendInterfaceLootPlayfab.get_rarity_tables = function (self)
	-- function 24
	return self._backend_mirror:get_rarity_tables()
end

BackendInterfaceLootPlayfab.get_formatted_rarity_tables = function (self)
	-- function 25
	return self._backend_mirror:get_formatted_rarity_tables()
end

BackendInterfaceLootPlayfab.get_highest_chest_level = function (self, arg_26_1)
	-- function 26
	local var_26_0
	local var_26_1 = cjson.decode(self._backend_mirror:get_read_only_data("chest_inventory"))[arg_26_1]

	if not var_26_1 then
		for k, v in pairs(var_26_1) do
			if v > 0 then
				local var_26_2 = string.split(k, "_")[2]

				var_26_0 = math.max(var_26_0 or 0, var_26_2)
			end
		end
	end

	return var_26_0
end
