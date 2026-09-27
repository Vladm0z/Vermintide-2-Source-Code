-- chunkname: @scripts/managers/backend_playfab/backend_interface_weaves_playfab.lua

require("scripts/settings/weaves/weave_loadout/weave_loadout_settings")
require("scripts/settings/equipment/power_level_settings")
require("scripts/helpers/weave_utils")

BackendInterfaceWeavesPlayFab = class(BackendInterfaceWeavesPlayFab)

local tbl = {
	slot_pose = "items",
	slot_hat = "items",
	slot_skin = "items",
	slot_frame = "items",
	slot_melee = "weaves",
	slot_ranged = "weaves"
}

local function fn(arg_1_0)
	-- function 1
	local PowerLevelFromMagicLevel = PowerLevelFromMagicLevel

	return math.min(math.ceil(math.clamp(arg_1_0 * PowerLevelFromMagicLevel.amulet_power_level_per_magic_level, 0, PowerLevelFromMagicLevel.power_level_per_magic_level)), PowerLevelFromMagicLevel.max_power_level)
end

BackendInterfaceWeavesPlayFab.init = function (self, arg_2_1)
	-- function 2
	self._backend_mirror = arg_2_1
	self._dirty_loadouts = {}

	local get_weaves_progression_settings = arg_2_1:get_weaves_progression_settings()

	self:_validate_backend_progression_settings(get_weaves_progression_settings)

	self._progression_settings = get_weaves_progression_settings
	self._forge_level = arg_2_1:get_read_only_data("weaves_forge_level")
	self._loadouts = self:_parse_loadouts()
	self._career_progress = self:_parse_career_progress()

	local get_all_inventory_items = arg_2_1:get_all_inventory_items()

	for k, v in pairs(get_all_inventory_items) do
		if not v.magic_level then
			v.power_level = WeaveUtils.magic_level_to_power_level(v.magic_level)
		end
	end

	local tbl_2 = {}

	for k_2, v_2 in pairs(tbl) do
		if v_2 == "weaves" then
			tbl_2[k_2] = true
		end
	end

	self._valid_loadout_slots = tbl_2

	if not script_data.disable_weave_loadout then
		Managers.backend:add_loadout_interface_override("weave", tbl)
	end

	if not script_data.disable_weave_talents then
		Managers.backend:add_talents_interface_override("weave", "weaves")
	end

	Managers.backend:set_total_power_level_interface_for_game_mode("weave", "weaves")

	self._last_id = 0
	self._player_entry = {}
	self._requesting_leaderboard = 0
	self._leaderboard_entries = {}
	self._leaderboard_player_rank_error = false
	self._leaderboard_request_error = false
end

BackendInterfaceWeavesPlayFab._validate_backend_progression_settings = function (arg_3_0, arg_3_1)
	-- function 3
	for k, v in pairs(WeaveLoadoutSettings) do
		for i, v_2 in ipairs(v.properties) do
			local var_3_0 = arg_3_1.properties[v_2]

			if not (not var_3_0 and not var_3_0.mastery_costs and var_3_0.required_forge_level) then
				Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for property %q in weave_progression_settings", v_2)
			end
		end

		for i_2, v_3 in ipairs(v.traits) do
			local var_3_1 = arg_3_1.traits[v_3]

			if not (not var_3_1 and not var_3_1.mastery_cost and var_3_1.required_forge_level) then
				Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for trait %q in weave_progression_settings", v_3)
			end
		end

		for i_3, v_4 in ipairs(v.talent_tree) do
			for i_4, v_5 in ipairs(v_4) do
				local var_3_2 = arg_3_1.talents[v_5]

				if not (not var_3_2 and var_3_2.mastery_cost) then
					Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for talent %q in weave_progression_settings", v_5)
				end
			end
		end
	end

	for k_2, v_6 in pairs(ItemMasterList) do
		local rarity = v_6.rarity
		local slot_type = v_6.slot_type

		if not (not rarity and (rarity ~= "magic" or not slot_type or slot_type == "melee" or slot_type == "ranged") and arg_3_1.items[k_2]) then
			Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for item %q in weave_progression_settings", k_2)
		end
	end
end

BackendInterfaceWeavesPlayFab._parse_loadouts = function (self)
	-- function 4
	local tbl = {}

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			if not v.excluded_from_weave_loadouts then
				local is_dlc_unlocked = v.is_dlc_unlocked()

				if is_dlc_unlocked == nil or not is_dlc_unlocked then
					local get_read_only_data = self._backend_mirror:get_read_only_data("weaves_loadout_" .. k)
					local flag = not get_read_only_data and cjson.decode(get_read_only_data)

					tbl[k] = flag

					self:_validate_loadout(k, flag)
				end
			else
				Application.warning("[BackendInterfaceWeavesPlayFab] Career %q excluded from weaves", k)
			end
		end
	end

	for k_2, v_2 in pairs(tbl) do
		for k_3, v_3 in pairs(v_2.item_loadouts) do
			self:_update_item_custom_data(k_3, v_3)
		end
	end

	return tbl
end

BackendInterfaceWeavesPlayFab._validate_loadout = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _dirty_loadouts = self._dirty_loadouts

	if not arg_5_2.properties then
		local var_5_1 = WeavePropertiesByCareer[arg_5_1]

		for k, v in pairs(arg_5_2.properties) do
			if not var_5_1[k] then
				print("[BackendInterfaceWeavesPlayFab] Loadout property not found in local settings, removing it from the loadout!", arg_5_1, k)

				arg_5_2.properties[k] = nil
				_dirty_loadouts[arg_5_1] = true
			end
		end
	end

	if not arg_5_2.traits then
		local var_5_2 = WeaveTraitsByCareer[arg_5_1]

		for k_2, v_2 in pairs(arg_5_2.traits) do
			if not var_5_2[k_2] then
				print("[BackendInterfaceWeavesPlayFab] Loadout trait not found in local settings, removing it from the loadout!", arg_5_1, k_2)

				arg_5_2.traits[k_2] = nil
				_dirty_loadouts[arg_5_1] = true
			end
		end
	end

	if not arg_5_2.talents then
		local var_5_3 = WeaveTalentsByCareer[arg_5_1]

		for k_3, v_3 in pairs(arg_5_2.talents) do
			if not var_5_3[k_3] then
				print("[BackendInterfaceWeavesPlayFab] Loadout talent not found in local settings, removing it from the loadout!", arg_5_1, k_3)

				arg_5_2.talents[k_3] = nil
				_dirty_loadouts[arg_5_1] = true
			end
		end
	end

	if not arg_5_2.item_loadouts then
		local get_all_inventory_items = self._backend_mirror:get_all_inventory_items()

		for k_4, v_4 in pairs(arg_5_2.item_loadouts) do
			local var_5_5 = get_all_inventory_items[k_4]

			if not (not var_5_5 and var_5_5.rarity == "magic") then
				print("[BackendInterfaceWeavesPlayFab] Loadout weapon not found in local settings, removing it from the loadout!", arg_5_1, k_4)

				arg_5_2.item_loadouts[k_4] = nil
			else
				self:_validate_loadout(arg_5_1, v_4)
			end
		end
	end
end

BackendInterfaceWeavesPlayFab._parse_career_progress = function (self)
	-- function 6
	local get_read_only_data = self._backend_mirror:get_read_only_data("weaves_career_progress")

	return (cjson.decode(get_read_only_data))
end

BackendInterfaceWeavesPlayFab._new_id = function (self)
	-- function 7
	local num

	if not self._last_id then
		num = self._last_id + 1

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_7_0::

	self._last_id = num

	return self._last_id
end

BackendInterfaceWeavesPlayFab._create_leaderboard_entry = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not arg_8_1 then
		return {
			score = "-",
			name = "-",
			weave = "-",
			ranking = "-",
			local_player = false
		}
	end

	local num = arg_8_1.Position + 1
	local Profile = arg_8_1.Profile
	local LinkedAccounts = Profile.LinkedAccounts
	local var_8_3
	local var_8_4
	local var_8_5

	for i = 1, #LinkedAccounts do
		local var_8_6 = LinkedAccounts[i]

		if var_8_6.Platform == "Steam" then
			var_8_3 = var_8_6.Username
			var_8_5 = var_8_6.PlatformUserId
		elseif var_8_6.Platform == "XBoxLive" then
			var_8_3 = var_8_6.Username
			var_8_5 = var_8_6.PlatformUserId
		elseif var_8_6.Platform == "PSN" then
			var_8_3 = var_8_6.Username
			var_8_5 = var_8_6.PlatformUserId
		end
	end

	local convert_weave_score, var_8_8, var_8_9 = BackendUtils.convert_weave_score(arg_8_1.StatValue)
	local flag = Profile.PlayerId == self._backend_mirror:get_playfab_id()

	if not (var_8_8 ~= arg_8_3 or convert_weave_score ~= arg_8_2) then
		var_8_4 = ""
	end

	return {
		name = var_8_3,
		career_name = var_8_9,
		ranking = var_8_4 or num,
		real_ranking = num,
		weave = convert_weave_score,
		score = var_8_8,
		local_player = flag,
		platform_user_id = var_8_5
	}
end

BackendInterfaceWeavesPlayFab._get_magic_inventory_item = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self._backend_mirror:get_all_inventory_items()[arg_9_1]

	fassert(var_9_0, "[BackendInterfaceWeavesPlayFab] Item %q doesn't exist", tostring(arg_9_1))
	fassert(var_9_0.rarity == "magic", "[BackendInterfaceWeavesPlayFab] Item %q is not magic", tostring(arg_9_1))

	return var_9_0
end

BackendInterfaceWeavesPlayFab._update_item_custom_data = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _get_magic_inventory_item = self:_get_magic_inventory_item(arg_10_1)
	local _progression_settings = self._progression_settings

	if not arg_10_2.properties then
		if not _get_magic_inventory_item.properties then
			table.clear(_get_magic_inventory_item.properties)
		else
			_get_magic_inventory_item.properties = {}
		end

		for k, v in pairs(arg_10_2.properties) do
			local num = #v / #self:get_property_mastery_costs(k)

			_get_magic_inventory_item.properties[k] = num
		end
	else
		_get_magic_inventory_item.properties = nil
	end

	if not arg_10_2.traits then
		if not _get_magic_inventory_item.traits then
			table.clear(_get_magic_inventory_item.traits)
		else
			_get_magic_inventory_item.traits = {}
		end

		for k_2, v_2 in pairs(arg_10_2.traits) do
			_get_magic_inventory_item.traits[#_get_magic_inventory_item.traits + 1] = k_2
		end
	else
		_get_magic_inventory_item.traits = nil
	end
end

BackendInterfaceWeavesPlayFab._get_loadout_mastery_cost = function (self, arg_11_1)
	-- function 11
	local num = 0
	local _progression_settings = self._progression_settings

	if not arg_11_1.properties then
		for k, v in pairs(arg_11_1.properties) do
			local get_property_mastery_costs = self:get_property_mastery_costs(k)

			for k_2 = 1, #v do
				num = num + get_property_mastery_costs[k_2]
			end
		end
	end

	if not arg_11_1.traits then
		for k_3, v_2 in pairs(arg_11_1.traits) do
			num = num + self:get_trait_mastery_cost(k_3)
		end
	end

	if not arg_11_1.talents then
		for k_4, v_3 in pairs(arg_11_1.talents) do
			num = num + self:get_talent_mastery_cost(k_4)
		end
	end

	return num
end

BackendInterfaceWeavesPlayFab.ready = function (arg_12_0)
	-- function 12
	return true
end

BackendInterfaceWeavesPlayFab.submit_scores = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local human_players = Managers.player:human_players()
	local tbl = {}

	for k, v in pairs(human_players) do
		local platform_id = v:platform_id()

		if not IS_XB1 then
			platform_id = Application.hex64_to_dec(platform_id)
		end

		local career_name = v:career_name()

		tbl[platform_id] = BackendUtils.calculate_weave_score(arg_13_1, arg_13_2, career_name)
	end

	local tbl_2 = {
		FunctionName = "submitWeaveScore",
		FunctionParameter = {
			scores_by_platform_id = tbl,
			num_players = arg_13_3
		}
	}
	local var_13_5 = callback(self, "submit_weave_score_request_cb")

	self._backend_mirror:request_queue():enqueue(tbl_2, var_13_5, true)
end

BackendInterfaceWeavesPlayFab.submit_weave_score_request_cb = function (arg_14_0)
	-- function 14
	return
end

BackendInterfaceWeavesPlayFab.request_player_rank = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local tbl = {
		MaxResultsCount = 1,
		StatisticName = arg_15_1,
		ProfileConstraints = {
			ShowLinkedAccounts = true
		}
	}

	if not IS_XB1 then
		tbl.XboxToken = Managers.account:get_xsts_token()
	end

	local var_15_1 = callback(self, "player_rank_request_cb")
	local var_15_2 = callback(self, "player_rank_request_failed_cb", arg_15_3)
	local request_queue = self._backend_mirror:request_queue()
	local flag

	flag = arg_15_2 ~= "friends" or not "GetFriendLeaderboardAroundPlayer" or "GetLeaderboardAroundPlayer"

	request_queue:enqueue_api_request(flag, tbl, var_15_1, var_15_2)

	self._requesting_leaderboard = self._requesting_leaderboard + 1
end

BackendInterfaceWeavesPlayFab.player_rank_request_cb = function (self, arg_16_1)
	-- function 16
	local var_16_0 = arg_16_1.Leaderboard[1]

	if (not var_16_0 and var_16_0.StatValue) == 0 then
		var_16_0 = nil
	end

	self._player_entry, self._requesting_leaderboard = self:_create_leaderboard_entry(var_16_0), self._requesting_leaderboard - 1
	self._leaderboard_player_rank_error = false
end

BackendInterfaceWeavesPlayFab.request_leaderboard_around_player = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local tbl = {
		MaxResultsCount = arg_17_3 or 1,
		StatisticName = arg_17_1,
		ProfileConstraints = {
			ShowLinkedAccounts = true
		}
	}

	if not IS_XB1 then
		tbl.XboxToken = Managers.account:get_xsts_token()
	end

	local var_17_1 = callback(self, "request_leaderboard_around_player_cb")
	local var_17_2 = callback(self, "request_leaderboard_failed_cb", arg_17_4)
	local request_queue = self._backend_mirror:request_queue()
	local flag

	flag = arg_17_2 ~= "friends" or not "GetFriendLeaderboardAroundPlayer" or "GetLeaderboardAroundPlayer"

	request_queue:enqueue_api_request(flag, tbl, var_17_1, var_17_2)

	self._requesting_leaderboard = self._requesting_leaderboard + 1
	self._leaderboard_request_error = false
end

BackendInterfaceWeavesPlayFab.request_leaderboard_around_player_cb = function (self, arg_18_1)
	-- function 18
	local Leaderboard = arg_18_1.Leaderboard

	table.clear(self._leaderboard_entries)

	local num = 1

	for i = 1, #Leaderboard do
		local var_18_2 = Leaderboard[i]
		local var_18_3

		if var_18_2.StatValue ~= 0 then
			local flag = not (num > 1) or self._leaderboard_entries[num - 1].score
			local flag_2 = not (num > 1) or self._leaderboard_entries[num - 1].weave
			local _create_leaderboard_entry = self:_create_leaderboard_entry(var_18_2, flag_2, flag)

			self._leaderboard_entries[num] = _create_leaderboard_entry
			num = num + 1
		end

		if var_18_2.Profile.PlayerId == self._backend_mirror:get_playfab_id() then
			self._player_entry = var_18_3
		end
	end

	self._requesting_leaderboard = self._requesting_leaderboard - 1
end

BackendInterfaceWeavesPlayFab.get_player_entry = function (self)
	-- function 19
	return self._player_entry
end

BackendInterfaceWeavesPlayFab.request_leaderboard = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local tbl = {
		MaxResultsCount = 100,
		StatisticName = arg_20_1,
		ProfileConstraints = {
			ShowLinkedAccounts = true
		},
		StartPosition = arg_20_2
	}

	if not IS_XB1 then
		tbl.XboxToken = Managers.account:get_xsts_token()
	end

	local var_20_1 = callback(self, "leaderboard_request_cb")
	local var_20_2 = callback(self, "request_leaderboard_failed_cb", arg_20_4)
	local request_queue = self._backend_mirror:request_queue()
	local flag

	flag = arg_20_3 ~= "friends" or not "GetFriendLeaderboard" or "GetLeaderboard"

	request_queue:enqueue_api_request(flag, tbl, var_20_1, var_20_2)

	self._requesting_leaderboard = self._requesting_leaderboard + 1
end

BackendInterfaceWeavesPlayFab.leaderboard_request_cb = function (self, arg_21_1)
	-- function 21
	local Leaderboard = arg_21_1.Leaderboard

	table.clear(self._leaderboard_entries)

	for i = 1, #Leaderboard do
		local var_21_1 = Leaderboard[i]
		local flag = not (i > 1) or self._leaderboard_entries[i - 1].score
		local flag_2 = not (i > 1) or self._leaderboard_entries[i - 1].weave
		local _create_leaderboard_entry = self:_create_leaderboard_entry(var_21_1, flag_2, flag)

		self._leaderboard_entries[i] = _create_leaderboard_entry
	end

	self._requesting_leaderboard = self._requesting_leaderboard - 1
	self._leaderboard_request_error = false
end

BackendInterfaceWeavesPlayFab.is_requesting_leaderboard = function (self)
	-- function 22
	return self._requesting_leaderboard > 0
end

BackendInterfaceWeavesPlayFab.get_leaderboard_entries = function (self)
	-- function 23
	return self._leaderboard_entries
end

BackendInterfaceWeavesPlayFab.has_leaderboard_request_failed = function (self)
	-- function 24
	local _leaderboard_player_rank_error = self._leaderboard_player_rank_error

	_leaderboard_player_rank_error = _leaderboard_player_rank_error or self._leaderboard_request_error

	return _leaderboard_player_rank_error
end

BackendInterfaceWeavesPlayFab.player_rank_request_failed_cb = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	self._requesting_leaderboard = self._requesting_leaderboard - 1
	self._leaderboard_player_rank_error = true
	self._player_entry = self:_create_leaderboard_entry(nil)

	if not arg_25_1 then
		arg_25_1(arg_25_2)
	end

	arg_25_3()
end

BackendInterfaceWeavesPlayFab.request_leaderboard_failed_cb = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	self._requesting_leaderboard = self._requesting_leaderboard - 1
	self._leaderboard_request_error = true

	table.clear(self._leaderboard_entries)

	if not arg_26_1 then
		arg_26_1(arg_26_2)
	end

	arg_26_3()
end

BackendInterfaceWeavesPlayFab.get_mastery = function (self, arg_27_1, arg_27_2)
	-- function 27
	local WeaveMasterySettings = WeaveMasterySettings
	local var_27_1 = self._loadouts[arg_27_1]
	local var_27_2

	if not arg_27_2 then
		var_27_1 = var_27_1.item_loadouts[arg_27_2]

		local get_item_magic_level = self:get_item_magic_level(arg_27_2)

		var_27_2 = (get_item_magic_level - 1) * WeaveMasterySettings.item_mastery_per_magic_level

		if get_item_magic_level >= self:max_magic_level() then
			var_27_2 = get_item_magic_level * WeaveMasterySettings.item_mastery_per_magic_level
		end
	else
		local get_career_magic_level = self:get_career_magic_level(arg_27_1)

		var_27_2 = (get_career_magic_level - 1) * WeaveMasterySettings.career_mastery_per_magic_level

		if get_career_magic_level >= self:max_magic_level() then
			var_27_2 = get_career_magic_level * WeaveMasterySettings.career_mastery_per_magic_level
		end
	end

	local _get_loadout_mastery_cost

	if not var_27_1 then
		_get_loadout_mastery_cost = self:_get_loadout_mastery_cost(var_27_1)

		if not _get_loadout_mastery_cost then
			-- Nothing
		end
	end

	_get_loadout_mastery_cost = 0

	::label_27_0::

	local num = var_27_2 - _get_loadout_mastery_cost

	return var_27_2, num
end

BackendInterfaceWeavesPlayFab.get_essence = function (self)
	-- function 28
	return self._backend_mirror:get_essence()
end

BackendInterfaceWeavesPlayFab.get_total_essence = function (self)
	-- function 29
	return self._backend_mirror:get_total_essence()
end

BackendInterfaceWeavesPlayFab.get_maximum_essence = function (self)
	-- function 30
	return self._backend_mirror:get_maximum_essence()
end

BackendInterfaceWeavesPlayFab.get_average_power_level = function (self, arg_31_1)
	-- function 31
	local var_31_0 = self._loadouts[arg_31_1]
	local num = self:_get_magic_inventory_item(var_31_0.slot_melee).power_level + self:_get_magic_inventory_item(var_31_0.slot_ranged).power_level
	local get_career_power_level = self:get_career_power_level(arg_31_1)
	local ceil = math.ceil(num * 0.5)

	if not get_career_power_level then
		ceil = ceil + get_career_power_level
	end

	return ceil
end

BackendInterfaceWeavesPlayFab.get_total_magic_level = function (self, arg_32_1)
	-- function 32
	local get_career_magic_level = self:get_career_magic_level(arg_32_1)
	local var_32_1 = self._loadouts[arg_32_1]

	return get_career_magic_level + self:get_item_magic_level(var_32_1.slot_melee) + self:get_item_magic_level(var_32_1.slot_ranged)
end

BackendInterfaceWeavesPlayFab.max_magic_level = function (self)
	-- function 33
	return #self._progression_settings.magic_levels
end

BackendInterfaceWeavesPlayFab.get_career_power_level = function (self, arg_34_1)
	-- function 34
	local get_career_magic_level = self:get_career_magic_level(arg_34_1)
	local var_34_1 = fn(get_career_magic_level)

	if var_34_1 == 0 then
		return nil
	end

	return var_34_1
end

BackendInterfaceWeavesPlayFab.get_career_magic_level = function (self, arg_35_1)
	-- function 35
	return self._career_progress[arg_35_1].magic_level
end

BackendInterfaceWeavesPlayFab.career_upgrade_cost = function (self, arg_36_1, arg_36_2)
	-- function 36
	local get_career_magic_level = self:get_career_magic_level(arg_36_2)
	local clamp = math.clamp(get_career_magic_level + arg_36_1, 1, self:max_magic_level())

	if clamp == get_career_magic_level then
		return nil, nil
	end

	local num = 0

	for i = get_career_magic_level + 1, clamp do
		num = num + self._progression_settings.magic_levels[i].essence_cost
	end

	return num, clamp
end

BackendInterfaceWeavesPlayFab.upgrade_career_magic_level = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local career_upgrade_cost, var_37_1 = self:career_upgrade_cost(arg_37_1, arg_37_2)

	if not career_upgrade_cost then
		arg_37_3(false)

		return
	end

	local tbl = {
		FunctionName = "upgradeCareerMagicLevel",
		FunctionParameter = {
			career_name = arg_37_2,
			new_magic_level = var_37_1,
			cost = career_upgrade_cost
		}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "upgrade_career_magic_level_cb", arg_37_3), true)
end

local tbl_2 = {
	"dr_ranger",
	"dr_slayer",
	"dr_ironbreaker",
	"dr_engineer",
	"we_waywatcher",
	"we_shade",
	"we_maidenguard",
	"es_huntsman",
	"es_mercenary",
	"es_knight",
	"es_questingknight",
	"bw_adept",
	"bw_scholar",
	"bw_unchained",
	"wh_captain",
	"wh_bountyhunter",
	"wh_zealot",
	"we_thornsister",
	"wh_priest",
	"bw_necromancer"
}

BackendInterfaceWeavesPlayFab.upgrade_career_magic_level_cb = function (self, arg_38_1, arg_38_2)
	-- function 38
	local FunctionResult = arg_38_2.FunctionResult
	local error_message = FunctionResult.error_message

	if not error_message then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when upgrading career magic level: ", tostring(error_message))

		if not arg_38_1 then
			arg_38_1(false)
		end

		return
	end

	local career_name = FunctionResult.career_name
	local new_magic_level = FunctionResult.new_magic_level
	local new_essence = FunctionResult.new_essence

	if not FunctionResult.upgrade_all_career_magic_levels then
		for i = 1, #tbl_2 do
			local var_38_5 = tbl_2[i]
			local var_38_6 = self._career_progress[var_38_5]

			if not var_38_6 then
				var_38_6.magic_level = new_magic_level
			end
		end
	else
		local var_38_7 = self._career_progress[career_name]

		if not var_38_7 then
			var_38_7.magic_level = new_magic_level
		end
	end

	self._backend_mirror:set_essence(new_essence)

	if not arg_38_1 then
		arg_38_1(true)
	end
end

BackendInterfaceWeavesPlayFab.get_item_magic_level = function (self, arg_39_1)
	-- function 39
	return self:_get_magic_inventory_item(arg_39_1).magic_level
end

BackendInterfaceWeavesPlayFab.get_item_power_level = function (self, arg_40_1)
	-- function 40
	local get_item_magic_level = self:get_item_magic_level(arg_40_1)

	return (WeaveUtils.magic_level_to_power_level(get_item_magic_level))
end

BackendInterfaceWeavesPlayFab.magic_item_upgrade_cost = function (self, arg_41_1, arg_41_2)
	-- function 41
	local get_item_magic_level = self:get_item_magic_level(arg_41_2)
	local clamp = math.clamp(get_item_magic_level + arg_41_1, 1, self:max_magic_level())

	if clamp == get_item_magic_level then
		return nil, nil
	end

	local num = 0

	for i = get_item_magic_level + 1, clamp do
		num = num + self._progression_settings.magic_levels[i].essence_cost
	end

	return num, clamp
end

BackendInterfaceWeavesPlayFab.upgrade_item_magic_level = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local magic_item_upgrade_cost, var_42_1 = self:magic_item_upgrade_cost(arg_42_1, arg_42_2)

	if not magic_item_upgrade_cost then
		arg_42_3(false)

		return
	end

	local tbl = {
		FunctionName = "upgradeItemMagicLevel",
		FunctionParameter = {
			item_backend_id = arg_42_2,
			new_magic_level = var_42_1,
			cost = magic_item_upgrade_cost
		}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "upgrade_item_magic_level_cb", arg_42_3), true)
end

BackendInterfaceWeavesPlayFab.upgrade_item_magic_level_cb = function (self, arg_43_1, arg_43_2)
	-- function 43
	local FunctionResult = arg_43_2.FunctionResult
	local error_message = FunctionResult.error_message

	if not error_message then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when upgrading item magic level: ", tostring(error_message))

		if not arg_43_1 then
			arg_43_1(false)
		end

		return
	end

	local item_id = FunctionResult.item_id
	local essence_cost = FunctionResult.essence_cost
	local item_backend_id = FunctionResult.item_backend_id
	local new_magic_level = FunctionResult.new_magic_level
	local new_essence = FunctionResult.new_essence

	Managers.telemetry_events:magic_item_level_upgraded(item_id, essence_cost, new_magic_level)

	local _backend_mirror = self._backend_mirror

	_backend_mirror:update_item_field(item_backend_id, "magic_level", new_magic_level)

	local magic_level_to_power_level = WeaveUtils.magic_level_to_power_level(new_magic_level)

	_backend_mirror:update_item_field(item_backend_id, "power_level", magic_level_to_power_level)
	_backend_mirror:set_essence(new_essence)

	if not arg_43_1 then
		arg_43_1(true)
	end
end

BackendInterfaceWeavesPlayFab.magic_item_cost = function (self, arg_44_1)
	-- function 44
	local var_44_0 = self._progression_settings.items[arg_44_1]

	return not var_44_0 and var_44_0.essence_cost
end

BackendInterfaceWeavesPlayFab.buy_magic_item = function (self, arg_45_1, arg_45_2)
	-- function 45
	local magic_item_cost = self:magic_item_cost(arg_45_1)

	if not magic_item_cost then
		arg_45_2(false)

		return
	end

	local tbl = {
		FunctionName = "buyMagicItem",
		FunctionParameter = {
			item_id = arg_45_1,
			cost = magic_item_cost
		}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "buy_magic_item_cb", arg_45_2), true)
end

BackendInterfaceWeavesPlayFab.buy_magic_item_cb = function (self, arg_46_1, arg_46_2)
	-- function 46
	local FunctionResult = arg_46_2.FunctionResult
	local error_message = FunctionResult.error_message

	if not error_message then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when buying magic item: ", tostring(error_message))

		if not arg_46_1 then
			arg_46_1(false)
		end

		return
	end

	local item_grant_results = FunctionResult.item_grant_results
	local new_essence = FunctionResult.new_essence
	local new_weapon_skins = FunctionResult.new_weapon_skins
	local _backend_mirror = self._backend_mirror

	for i = 1, #item_grant_results do
		local var_46_6 = item_grant_results[i]
		local ItemInstanceId = var_46_6.ItemInstanceId

		_backend_mirror:add_item(ItemInstanceId, var_46_6)

		var_46_6.power_level = WeaveUtils.magic_level_to_power_level(var_46_6.CustomData.magic_level)
	end

	_backend_mirror:set_essence(new_essence)

	if not new_weapon_skins then
		for j = 1, #new_weapon_skins do
			local var_46_8 = new_weapon_skins[j]

			_backend_mirror:add_unlocked_weapon_skin(var_46_8)
		end
	end

	if not arg_46_1 then
		arg_46_1(true)
	end
end

BackendInterfaceWeavesPlayFab.get_forge_level = function (self)
	-- function 47
	return self._forge_level
end

BackendInterfaceWeavesPlayFab.forge_max_level = function (self)
	-- function 48
	return #self._progression_settings.forge_levels
end

BackendInterfaceWeavesPlayFab.forge_magic_level_cap = function (self)
	-- function 49
	local _forge_level = self._forge_level

	return self._progression_settings.forge_levels[_forge_level].magic_level_cap
end

BackendInterfaceWeavesPlayFab.forge_upgrade_cost = function (self, arg_50_1)
	-- function 50
	local _forge_level = self._forge_level
	local clamp = math.clamp(_forge_level + arg_50_1, 1, self:forge_max_level())

	if clamp == _forge_level then
		return nil, nil
	end

	local num = 0

	for i = _forge_level + 1, clamp do
		num = num + self._progression_settings.forge_levels[i].essence_cost
	end

	return num, clamp
end

BackendInterfaceWeavesPlayFab.upgrade_forge = function (self, arg_51_1, arg_51_2)
	-- function 51
	local forge_upgrade_cost, var_51_1 = self:forge_upgrade_cost(arg_51_1)

	if not forge_upgrade_cost then
		arg_51_2(false)

		return
	end

	local tbl = {
		FunctionName = "upgradeWeaveForge",
		FunctionParameter = {
			new_forge_level = var_51_1,
			cost = forge_upgrade_cost
		}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "upgrade_forge_cb", arg_51_2), true)
end

BackendInterfaceWeavesPlayFab.upgrade_forge_cb = function (self, arg_52_1, arg_52_2)
	-- function 52
	local FunctionResult = arg_52_2.FunctionResult
	local error_message = FunctionResult.error_message

	if not error_message then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when upgrading the forge: ", tostring(error_message))

		if not arg_52_1 then
			arg_52_1(false)
		end

		return
	end

	local new_essence

	self._forge_level, new_essence = FunctionResult.new_forge_level, FunctionResult.new_essence

	self._backend_mirror:set_essence(new_essence)

	if not arg_52_1 then
		arg_52_1(true)
	end
end

BackendInterfaceWeavesPlayFab.get_property_mastery_costs = function (self, arg_53_1)
	-- function 53
	return self._progression_settings.properties[arg_53_1].mastery_costs
end

BackendInterfaceWeavesPlayFab.get_property_required_forge_level = function (self, arg_54_1)
	-- function 54
	return self._progression_settings.properties[arg_54_1].required_forge_level
end

BackendInterfaceWeavesPlayFab.set_loadout_property = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local var_55_0 = WeavePropertiesByCareer[arg_55_1][arg_55_2]

	fassert(var_55_0, "[BackendInterfaceWeavesPlayFab] Property %q not found for %q", arg_55_2, arg_55_1)

	local var_55_1 = self._loadouts[arg_55_1]

	if not arg_55_4 then
		local var_55_2 = var_55_1.item_loadouts[arg_55_4]

		if not var_55_2 then
			var_55_2 = {
				properties = {},
				traits = {}
			}
			var_55_1.item_loadouts[arg_55_4] = var_55_2
		end

		var_55_1 = var_55_2
	end

	local var_55_3 = var_55_1.properties[arg_55_2]

	if not var_55_3 then
		var_55_3 = {}
		var_55_1.properties[arg_55_2] = var_55_3
	end

	for k, v in pairs(var_55_1.properties) do
		if not table.contains(v, arg_55_3) then
			return
		end
	end

	local get_property_mastery_costs = self:get_property_mastery_costs(arg_55_2)

	if #var_55_3 == #get_property_mastery_costs then
		return
	end

	var_55_3[#var_55_3 + 1] = arg_55_3

	if not arg_55_4 then
		self:_update_item_custom_data(arg_55_4, var_55_1)
	end

	self._dirty_loadouts[arg_55_1] = true
end

BackendInterfaceWeavesPlayFab.remove_loadout_property = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	local var_56_0 = self._loadouts[arg_56_1]

	if not arg_56_4 then
		var_56_0 = var_56_0.item_loadouts[arg_56_4]
	end

	local var_56_1 = var_56_0.properties[arg_56_2]
	local find = table.find(var_56_1, arg_56_3)

	table.remove(var_56_1, find)

	if #var_56_1 == 0 then
		var_56_0.properties[arg_56_2] = nil
	end

	if not arg_56_4 then
		self:_update_item_custom_data(arg_56_4, var_56_0)
	end

	self._dirty_loadouts[arg_56_1] = true
end

BackendInterfaceWeavesPlayFab.get_loadout_properties = function (self, arg_57_1, arg_57_2)
	-- function 57
	local var_57_0 = self._loadouts[arg_57_1]
	local var_57_1

	if not arg_57_2 then
		local var_57_2 = var_57_0.item_loadouts[arg_57_2]

		var_57_1 = not var_57_2 and var_57_2.properties and {}
	else
		var_57_1 = var_57_0.properties
	end

	return var_57_1
end

BackendInterfaceWeavesPlayFab.get_trait_mastery_cost = function (self, arg_58_1)
	-- function 58
	return self._progression_settings.traits[arg_58_1].mastery_cost
end

BackendInterfaceWeavesPlayFab.get_trait_required_forge_level = function (self, arg_59_1)
	-- function 59
	return self._progression_settings.traits[arg_59_1].required_forge_level
end

BackendInterfaceWeavesPlayFab.set_loadout_trait = function (self, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	-- function 60
	local var_60_0 = WeaveTraitsByCareer[arg_60_1][arg_60_2]

	fassert(var_60_0, "[BackendInterfaceWeavesPlayFab] Trait %q not allowed for %q", arg_60_2, arg_60_1)

	local var_60_1 = self._loadouts[arg_60_1]

	if not arg_60_4 then
		local var_60_2 = var_60_1.item_loadouts[arg_60_4]

		if not var_60_2 then
			var_60_2 = {
				properties = {},
				traits = {}
			}
			var_60_1.item_loadouts[arg_60_4] = var_60_2
		end

		var_60_1 = var_60_2
	end

	if not var_60_1.traits[arg_60_2] then
		return
	end

	for k, v in pairs(var_60_1.traits) do
		if v == arg_60_3 then
			return
		end
	end

	var_60_1.traits[arg_60_2] = arg_60_3

	if not arg_60_4 then
		self:_update_item_custom_data(arg_60_4, var_60_1)
	end

	self._dirty_loadouts[arg_60_1] = true
end

BackendInterfaceWeavesPlayFab.remove_loadout_trait = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local var_61_0 = self._loadouts[arg_61_1]

	if not arg_61_3 then
		var_61_0 = var_61_0.item_loadouts[arg_61_3]
	end

	var_61_0.traits[arg_61_2] = nil

	if not arg_61_3 then
		self:_update_item_custom_data(arg_61_3, var_61_0)
	end

	self._dirty_loadouts[arg_61_1] = true
end

BackendInterfaceWeavesPlayFab.get_loadout_traits = function (self, arg_62_1, arg_62_2)
	-- function 62
	local var_62_0 = self._loadouts[arg_62_1]
	local var_62_1

	if not arg_62_2 then
		local var_62_2 = var_62_0.item_loadouts[arg_62_2]

		var_62_1 = not var_62_2 and var_62_2.traits and {}
	else
		var_62_1 = var_62_0.traits
	end

	return var_62_1
end

BackendInterfaceWeavesPlayFab.apply_career_item_loadouts = function (self, arg_63_1)
	-- function 63
	if not arg_63_1 then
		local var_63_0 = self._loadouts[arg_63_1]
		local flag = not var_63_0 and var_63_0.item_loadouts

		if not flag then
			local slot_melee = var_63_0.slot_melee

			if not slot_melee then
				local var_63_3 = flag[slot_melee]

				var_63_3 = var_63_3 or {}

				self:_update_item_custom_data(slot_melee, var_63_3)
			end

			local slot_ranged = var_63_0.slot_ranged

			if not slot_ranged then
				local var_63_5 = flag[slot_ranged]

				var_63_5 = var_63_5 or {}

				self:_update_item_custom_data(slot_ranged, var_63_5)
			end
		end
	end
end

BackendInterfaceWeavesPlayFab.get_talent_mastery_cost = function (self, arg_64_1)
	-- function 64
	return self._progression_settings.talents[arg_64_1].mastery_cost
end

BackendInterfaceWeavesPlayFab.get_talent_required_forge_level = function (self, arg_65_1)
	-- function 65
	return self._progression_settings.talents[arg_65_1].required_forge_level
end

BackendInterfaceWeavesPlayFab.set_loadout_talent = function (self, arg_66_1, arg_66_2, arg_66_3)
	-- function 66
	local var_66_0 = WeaveTalentsByCareer[arg_66_1][arg_66_2]

	fassert(var_66_0, "[BackendInterfaceWeavesPlayFab] Talent %q not allowed for %q", arg_66_2, arg_66_1)

	local tree_row = var_66_0.tree_row
	local talents = self._loadouts[arg_66_1].talents

	if not talents[arg_66_2] then
		return
	end

	for k, v in pairs(talents) do
		if v == arg_66_3 then
			return
		end

		if tree_row == WeaveTalentsByCareer[arg_66_1][k].tree_row then
			return
		end
	end

	talents[arg_66_2] = arg_66_3
	self._dirty_loadouts[arg_66_1] = true
end

BackendInterfaceWeavesPlayFab.remove_loadout_talent = function (self, arg_67_1, arg_67_2)
	-- function 67
	local talents = self._loadouts[arg_67_1].talents

	fassert(talents[arg_67_2], "[BackendInterfaceWeavesPlayFab] Talent %q not found in loadout for %q", arg_67_2, arg_67_1)

	talents[arg_67_2] = nil
	self._dirty_loadouts[arg_67_1] = true
end

BackendInterfaceWeavesPlayFab.get_loadout_talents = function (self, arg_68_1)
	-- function 68
	return self._loadouts[arg_68_1].talents
end

BackendInterfaceWeavesPlayFab.get_talent_ids = function (self, arg_69_1)
	-- function 69
	local get_talent_tree = self:get_talent_tree(arg_69_1)
	local tbl = {}
	local get_talents = self:get_talents(arg_69_1)

	if not get_talents then
		for i = 1, #get_talents do
			local var_69_3 = get_talents[i]

			if var_69_3 ~= 0 then
				local var_69_4 = get_talent_tree[i][var_69_3]
				local var_69_5 = TalentIDLookup[var_69_4]

				if not var_69_5 and not var_69_5.talent_id then
					tbl[#tbl + 1] = var_69_5.talent_id
				end
			end
		end
	end

	return tbl
end

BackendInterfaceWeavesPlayFab.get_talent_tree = function (arg_70_0, arg_70_1)
	-- function 70
	local var_70_0 = WeaveLoadoutSettings[arg_70_1]

	return not var_70_0 and var_70_0.talent_tree
end

local tbl_3 = {}

BackendInterfaceWeavesPlayFab.get_talents = function (self, arg_71_1)
	-- function 71
	local talents = self._loadouts[arg_71_1].talents
	local get_talent_tree = self:get_talent_tree(arg_71_1)

	table.clear(tbl_3)

	for i = 1, #get_talent_tree do
		tbl_3[i] = 0
	end

	for k, v in pairs(talents) do
		local var_71_2 = WeaveTalentsByCareer[arg_71_1][k]
		local tree_row = var_71_2.tree_row
		local tree_column = var_71_2.tree_column

		tbl_3[tree_row] = tree_column
	end

	return tbl_3
end

BackendInterfaceWeavesPlayFab.get_total_power_level = function (self, arg_72_1, arg_72_2)
	-- function 72
	return self:get_average_power_level(arg_72_2)
end

BackendInterfaceWeavesPlayFab.has_loadout_item_id = function (self, arg_73_1, arg_73_2)
	-- function 73
	local var_73_0 = self._loadouts[arg_73_1]

	for k, v in pairs(var_73_0) do
		if v == arg_73_2 then
			return true
		end
	end
end

BackendInterfaceWeavesPlayFab.get_loadout_item_id = function (self, arg_74_1, arg_74_2)
	-- function 74
	fassert(self._valid_loadout_slots[arg_74_2], "[BackendInterfaceWeavesPlayFab] Loadout in slot %q shouldn't be fetched from the weaves interface", tostring(arg_74_2))

	return self._loadouts[arg_74_1][arg_74_2]
end

BackendInterfaceWeavesPlayFab.set_loadout_item = function (self, arg_75_1, arg_75_2, arg_75_3)
	-- function 75
	fassert(self._valid_loadout_slots[arg_75_3], "[BackendInterfaceWeavesPlayFab] Loadout in slot %q shouldn't be set in the weaves interface", tostring(arg_75_3))

	local get_all_inventory_items = self._backend_mirror:get_all_inventory_items()
	local var_75_1

	if not arg_75_1 then
		var_75_1 = get_all_inventory_items[arg_75_1]

		fassert(var_75_1, "[BackendInterfaceWeavesPlayFab] Item %q doesn't exist", tostring(arg_75_1))
	end

	if not var_75_1 then
		print("[BackendInterfaceWeavesPlayFab] Attempted to equip weapon that doesn't exist:", arg_75_1, arg_75_2, arg_75_3)

		return false
	end

	if var_75_1.rarity ~= "magic" then
		print("[BackendInterfaceWeavesPlayFab] Attempted to equip non magic weapon in weaves:", arg_75_1, arg_75_2, arg_75_3)

		return false
	end

	local var_75_2 = self._loadouts[arg_75_2]

	if var_75_2[arg_75_3] ~= arg_75_1 then
		var_75_2[arg_75_3] = arg_75_1
		self._dirty_loadouts[arg_75_2] = true
	end

	return true
end

BackendInterfaceWeavesPlayFab.get_dirty_user_data = function (self)
	-- function 76
	local flag = false
	local tbl = {}
	local _dirty_loadouts = self._dirty_loadouts
	local _loadouts = self._loadouts

	for k, v in pairs(_dirty_loadouts) do
		flag = true

		local loadouts = tbl.loadouts

		loadouts = loadouts or {}
		tbl.loadouts = loadouts
		tbl.loadouts[k] = table.clone(_loadouts[k])
	end

	if not flag then
		return tbl
	end
end

BackendInterfaceWeavesPlayFab.clear_dirty_user_data = function (self)
	-- function 77
	table.clear(self._dirty_loadouts)
end
