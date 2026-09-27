-- chunkname: @scripts/managers/backend_playfab/playfab_mirror_base.lua

require("scripts/managers/backend_playfab/playfab_request_queue")
require("scripts/helpers/weave_utils")

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")
local tbl = {
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
local tbl_2 = {
	string = true,
	boolean = true,
	number = true
}
local num = 80
local num_2 = 5
local uuid

if not IS_PS4 then
	uuid = math.uuid

	if not uuid then
		-- Nothing
	end
end

uuid = Application.guid

::label_0_0::

PlayFabMirrorBase = class(PlayFabMirrorBase)

local function fn(arg_1_0, ...)
	-- function 1
	printf("[PlayFabMirrorBase] " .. arg_1_0, ...)
end

local function fn_2(arg_2_0, arg_2_1, ...)
	-- function 2
	if not arg_2_0 then
		Crashify.print_exception("PlayFabMirrorBase", arg_2_1, ...)
	end
end

PlayFabMirrorBase.init = function (self, arg_3_1)
	-- function 3
	self._num_items_to_load = 0
	self._stats = {}
	self._unlocked_dlcs = {}
	self._commits = {}
	self._commit_current_id = nil
	self._last_id = 0
	self._queued_commit = {}
	self._request_queue = PlayFabRequestQueue:new()
	self._quest_data = {}
	self._fake_inventory_items = {}
	self._unlocked_cosmetics = {}
	self._unlocked_weapon_poses = {}
	self._equipped_weapon_pose_skins = {}
	self._filtered_data = self:_init_filtered_data()
	self._best_power_levels = nil
	self.sum_best_power_levels = nil
	self._belakor_data_loaded = false
	self._playfab_id = arg_3_1.PlayFabId

	local InfoResultPayload = arg_3_1.InfoResultPayload
	local UserReadOnlyData = InfoResultPayload.UserReadOnlyData

	UserReadOnlyData = UserReadOnlyData or {}

	local tbl = {}

	for k, v in pairs(UserReadOnlyData) do
		local Value = v.Value
		local var_3_4 = type(Value)

		fn_2(tbl_2[var_3_4], "Tried to set initial read_only_data's '%s'. Got value '%s' ('%s')", k, tostring(Value), var_3_4)

		if not tonumber(Value) then
			Value = tonumber(Value)
		elseif not (Value == "true" or Value ~= "false") then
			Value = to_boolean(Value)
		end

		tbl[k] = Value
	end

	self._read_only_data = tbl
	self._read_only_data_mirror = table.clone(tbl)

	local TitleData = InfoResultPayload.TitleData

	TitleData = TitleData or {}
	self._title_data = {}

	for k_2, v_2 in pairs(TitleData) do
		self:set_title_data(k_2, v_2)
	end

	local UserData = InfoResultPayload.UserData

	UserData = UserData or {}

	local tbl_3 = {}

	for k_3, v_3 in pairs(UserData) do
		local Value_2 = v_3.Value

		if not Value_2 then
			if not tonumber(Value_2) then
				Value_2 = tonumber(Value_2)
			elseif not (Value_2 == "true" or Value_2 ~= "false") then
				Value_2 = to_boolean(Value_2)
			end

			tbl_3[k_3] = Value_2
		end
	end

	self._user_data = tbl_3
	self._user_data_mirror = table.clone(self._user_data)
	self._commit_limit_timer = num
	self._commit_limit_total = 1

	self:_verify_account_data()
end

PlayFabMirrorBase._init_filtered_data = function (arg_4_0)
	-- function 4
	local tbl = {}

	for k in pairs(Managers.unlock:get_dlcs()) do
		tbl[k] = {}
	end

	return tbl
end

PlayFabMirrorBase._register_dlc_filtered_data = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_0._filtered_data[arg_5_1][arg_5_2] = arg_5_3 or true
end

PlayFabMirrorBase._grant_filtered_data = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self._filtered_data[arg_6_1]

	for k, v in pairs(var_6_0) do
		if v == true then
			v = nil
		end

		var_6_0[k] = nil

		local flag = not table.is_empty(var_6_0)

		self:add_item(v, k, flag)
	end

	table.clear(self._filtered_data[arg_6_1])
end

PlayFabMirrorBase._parse_claimed_achievements = function (self)
	-- function 7
	local tbl = {}
	local tbl_2 = {}
	local get_read_only_data = self:get_read_only_data("claimed_achievements")

	if not get_read_only_data then
		tbl = string.split_deprecated(get_read_only_data, ",")
	end

	for i = 1, #tbl do
		tbl_2[tbl[i]] = true
	end

	return tbl_2
end

PlayFabMirrorBase._parse_claimed_event_quests = function (self)
	-- function 8
	local tbl = {}
	local get_read_only_data = self:get_read_only_data("claimed_event_quests")

	if not get_read_only_data then
		local split_deprecated = string.split_deprecated(get_read_only_data, ",")

		for i = 1, #split_deprecated do
			tbl[split_deprecated[i]] = true
		end
	end

	return tbl
end

PlayFabMirrorBase._parse_unlocked_weapon_skins = function (self)
	-- function 9
	local tbl = {}
	local get_read_only_data = self:get_read_only_data("unlocked_weapon_skins")
	local unlock = Managers.unlock
	local _unlocked_weapon_skins = self._unlocked_weapon_skins

	_unlocked_weapon_skins = _unlocked_weapon_skins or {}

	if not get_read_only_data then
		local decode = cjson.decode(get_read_only_data)

		if not decode then
			for i = 1, #decode do
				local var_9_5 = decode[i]
				local var_9_6 = rawget(ItemMasterList, var_9_5)
				local flag = not var_9_6 and var_9_6.required_dlc

				if not flag then
					local var_9_8 = _unlocked_weapon_skins[var_9_5]

					var_9_8 = var_9_8 or true
					tbl[var_9_5] = var_9_8
				elseif not unlock:dlc_exists(flag) then
					fn_2(false, "Tried to check if unexisting DLC was unlocked %s", flag)

					tbl[var_9_5] = true
				elseif not unlock:is_dlc_unlocked(flag) then
					tbl[var_9_5] = true
				else
					self:_register_dlc_filtered_data(flag, {
						ItemId = var_9_5
					}, _unlocked_weapon_skins[var_9_5])
				end
			end
		else
			fn_2(false, "Failed to decode unlocked_weapon_skins_string %s", get_read_only_data)
		end
	end

	return tbl
end

PlayFabMirrorBase._parse_unlocked_weapon_poses = function (self)
	-- function 10
	local tbl = {}
	local get_read_only_data = self:get_read_only_data("unlocked_weapon_poses")
	local unlock = Managers.unlock
	local _unlocked_weapon_poses = self._unlocked_weapon_poses

	_unlocked_weapon_poses = _unlocked_weapon_poses or {}

	if not get_read_only_data then
		local decode = cjson.decode(get_read_only_data)

		if not decode then
			for i, v in ipairs(decode) do
				local var_10_5 = rawget(ItemMasterList, v)
				local flag = not var_10_5 and var_10_5.required_dlc
				local parent = var_10_5.parent

				if not var_10_5 then
					fn_2(false, "%q doesn't exist in the ItemMasterList", v)
				elseif not parent then
					fn_2(false, "%q doesn't have a prent", v)
				elseif not flag then
					local var_10_8 = tbl[parent]

					var_10_8 = var_10_8 or {}
					tbl[parent] = var_10_8
					tbl[parent][v] = true
				elseif not unlock:dlc_exists(flag) then
					fn_2(false, "Tried to check if unexisting DLC was unlocked %s", flag)

					local var_10_9 = tbl[parent]

					var_10_9 = var_10_9 or {}
					tbl[parent] = var_10_9
					tbl[parent][v] = true
				elseif not unlock:is_dlc_unlocked(flag) then
					local var_10_10 = tbl[parent]

					var_10_10 = var_10_10 or {}
					tbl[parent] = var_10_10
					tbl[parent][v] = true
				else
					local var_10_11 = self
					local _register_dlc_filtered_data = self._register_dlc_filtered_data
					local var_10_13 = flag
					local tbl_2 = {
						ItemId = v
					}
					local var_10_15 = _unlocked_weapon_poses[parent]

					var_10_15 = not var_10_15 and _unlocked_weapon_poses[parent][v]

					_register_dlc_filtered_data(var_10_11, var_10_13, tbl_2, var_10_15)
				end
			end
		else
			fn_2(false, "Failed to decode unlocked_weapon_poses_string %s", get_read_only_data)
		end
	end

	return tbl
end

PlayFabMirrorBase._parse_equipped_weapon_pose_skins = function (self)
	-- function 11
	local tbl = {}
	local get_read_only_data = self:get_read_only_data("equipped_weapon_pose_skins")

	if not self._equipped_weapon_pose_skins then
		local tbl_2 = {}
	end

	if not get_read_only_data then
		local decode = cjson.decode(get_read_only_data)

		if not decode then
			tbl = decode
		else
			fn_2(false, "Failed to decode equipped_weapon_pose_skins_string %s", get_read_only_data)
		end
	end

	return tbl
end

PlayFabMirrorBase._parse_unlocked_cosmetics = function (self, arg_12_1)
	-- function 12
	arg_12_1 = arg_12_1 or self:get_read_only_data("unlocked_cosmetics")

	local tbl = {}
	local unlock = Managers.unlock
	local _unlocked_cosmetics = self._unlocked_cosmetics

	_unlocked_cosmetics = _unlocked_cosmetics or {}

	if not arg_12_1 then
		local decode = cjson.decode(arg_12_1)

		if not decode then
			for k, v in pairs(decode) do
				for k_2 = 1, #v do
					local var_12_4 = v[k_2]
					local var_12_5 = rawget(ItemMasterList, var_12_4)
					local flag = not var_12_5 and var_12_5.required_dlc

					if not flag then
						local var_12_7 = _unlocked_cosmetics[var_12_4]

						var_12_7 = var_12_7 or true
						tbl[var_12_4] = var_12_7
					elseif not unlock:dlc_exists(flag) then
						fn_2(false, "Tried to check if unexisting DLC was unlocked %s", flag)

						tbl[var_12_4] = true
					elseif not unlock:is_dlc_unlocked(flag) then
						tbl[var_12_4] = true
					else
						self:_register_dlc_filtered_data(flag, {
							ItemId = var_12_4
						}, _unlocked_cosmetics[var_12_4])
					end
				end
			end
		else
			fn_2(false, "Failed to decode unlocked_cosmetics_string %s", arg_12_1)
		end
	end

	return tbl
end

PlayFabMirrorBase._parse_claimed_console_dlc_rewards = function (self)
	-- function 13
	local tbl = {}
	local get_read_only_data = self:get_read_only_data("claimed_console_dlc_rewards")

	if not get_read_only_data then
		local decode = cjson.decode(get_read_only_data)

		for k, v in pairs(decode) do
			tbl[k] = true
		end
	end

	return tbl
end

PlayFabMirrorBase._verify_account_data = function (self)
	-- function 14
	if not DEDICATED_SERVER then
		return
	end

	local tbl = {
		FunctionName = "verifyAccountData"
	}
	local var_14_1 = callback(self, "verify_account_data_cb")

	self._request_queue:enqueue(tbl, var_14_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.verify_account_data_cb = function (self, arg_15_1)
	-- function 15
	self._num_items_to_load = self._num_items_to_load - 1

	self:_migrate_characters()
end

PlayFabMirrorBase._migrate_characters = function (self)
	-- function 16
	local get_read_only_data = self:get_read_only_data("characters_data")

	if not get_read_only_data and get_read_only_data == "{}" or get_read_only_data == "" or type(get_read_only_data) ~= "table" or not table.is_empty(get_read_only_data) then
		local tbl = {
			FunctionName = "migrateCharacters",
			FunctionParameter = {}
		}
		local var_16_2 = callback(self, "migrate_characters_cb")

		self._request_queue:enqueue(tbl, var_16_2)

		self._num_items_to_load = self._num_items_to_load + 1

		return
	end

	self:_migrate_cosmetics()
end

PlayFabMirrorBase.migrate_characters_cb = function (self, arg_17_1)
	-- function 17
	local FunctionResult = arg_17_1.FunctionResult
	local success = FunctionResult.success
	local characters_data = FunctionResult.characters_data

	if not characters_data then
		self:set_read_only_data("characters_data", characters_data, true)
	end

	self._num_items_to_load = self._num_items_to_load - 1

	self:_migrate_cosmetics()
end

PlayFabMirrorBase._migrate_cosmetics = function (self)
	-- function 18
	if not DEDICATED_SERVER then
		return
	end

	local tbl = {
		FunctionName = "migrateCosmetics"
	}
	local var_18_1 = callback(self, "migrate_cosmetics_request_cb")

	self._request_queue:enqueue(tbl, var_18_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.migrate_cosmetics_request_cb = function (self, arg_19_1)
	-- function 19
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_19_1.FunctionResult
	local unlocked_cosmetics = FunctionResult.unlocked_cosmetics
	local characters_data = FunctionResult.characters_data

	if not unlocked_cosmetics then
		self:set_read_only_data("unlocked_cosmetics", unlocked_cosmetics, true)
	end

	if not characters_data then
		self:set_read_only_data("characters_data", characters_data, true)
	end

	self:_update_dlc_ownership()
end

PlayFabMirrorBase._update_dlc_ownership = function (self)
	-- function 20
	if not DEDICATED_SERVER then
		return
	end

	local get_installed_dlcs = Managers.unlock:get_installed_dlcs()
	local encode = cjson.encode(get_installed_dlcs)
	local tbl = {
		FunctionName = "updateDLCOwnership",
		FunctionParameter = {
			installed_dlcs = encode
		}
	}
	local var_20_3 = callback(self, "dlc_ownership_request_cb")

	self._request_queue:enqueue(tbl, var_20_3)

	self._num_items_to_load = self._num_items_to_load + 1
	self._unlocked_dlcs = get_installed_dlcs
end

PlayFabMirrorBase.dlc_unlocked_at_signin = function (self, arg_21_1)
	-- function 21
	return table.find(self._unlocked_dlcs, arg_21_1) ~= false
end

PlayFabMirrorBase.dlc_ownership_request_cb = function (self, arg_22_1)
	-- function 22
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_22_1.FunctionResult

	self._owner_dlcs_cb_data = table.shallow_copy(FunctionResult)

	if not GameSettingsDevelopment.read_only_backend then
		self:_handle_owned_dlcs_data()
		self:_request_best_power_levels()
	else
		self:_execute_dlc_specific_logic()
	end
end

PlayFabMirrorBase._handle_owned_dlcs_data = function (self)
	-- function 23
	local _owner_dlcs_cb_data = self._owner_dlcs_cb_data

	self._owner_dlcs_cb_data = nil

	local owned_dlcs = _owner_dlcs_cb_data.owned_dlcs
	local platform_dlcs = _owner_dlcs_cb_data.platform_dlcs
	local excluded_dlcs = _owner_dlcs_cb_data.excluded_dlcs
	local new_dlcs = _owner_dlcs_cb_data.new_dlcs
	local revoked_dlcs = _owner_dlcs_cb_data.revoked_dlcs

	self._owned_dlcs = owned_dlcs or {}
	self._platform_dlcs = platform_dlcs

	Managers.unlock:set_excluded_dlcs(excluded_dlcs)
	self:update_owned_dlcs(false)

	if not HAS_STEAM then
		self:handle_new_dlcs(new_dlcs)
	end

	if not (not revoked_dlcs and not (#revoked_dlcs > 0)) then
		local unlocked_keep_decorations = _owner_dlcs_cb_data.unlocked_keep_decorations

		if not unlocked_keep_decorations then
			self:set_read_only_data("unlocked_keep_decorations", unlocked_keep_decorations, true)
		end

		local unlocked_cosmetics = _owner_dlcs_cb_data.unlocked_cosmetics

		if not unlocked_cosmetics then
			self:set_read_only_data("unlocked_cosmetics", unlocked_cosmetics, true)
		end

		local unlocked_weapon_skins = _owner_dlcs_cb_data.unlocked_weapon_skins

		if not unlocked_cosmetics then
			self:set_read_only_data("unlocked_weapon_skins", unlocked_weapon_skins, true)
		end
	end

	self._claimed_achievements = self:_parse_claimed_achievements()
	self._claimed_event_quests = self:_parse_claimed_event_quests()
	self._unlocked_weapon_skins = self:_parse_unlocked_weapon_skins()
	self._unlocked_cosmetics = self:_parse_unlocked_cosmetics()
	self._unlocked_weapon_poses = self:_parse_unlocked_weapon_poses()
	self._equipped_weapon_pose_skins = self:_parse_equipped_weapon_pose_skins()

	local get_read_only_data = self:get_read_only_data("unlocked_keep_decorations")

	get_read_only_data = get_read_only_data or "{}"
	self._unlocked_keep_decorations = cjson.decode(get_read_only_data)

	if not IS_CONSOLE then
		self._claimed_console_dlc_rewards = self:_parse_claimed_console_dlc_rewards()
	end

	self:update_filtered_dlc_data()
end

PlayFabMirrorBase._execute_dlc_specific_logic = function (self)
	-- function 24
	local tbl = {
		FunctionName = "executeDLCLogic",
		FunctionParameter = {}
	}
	local var_24_1 = callback(self, "execute_dlc_logic_request_cb")

	self._request_queue:enqueue(tbl, var_24_1, true)

	self._num_items_to_load = self._num_items_to_load + 1
end

local function fn_3(arg_25_0)
	-- function 25
	return ItemMasterList[arg_25_0]
end

PlayFabMirrorBase._sync_unseen_rewards = function (self, arg_26_1)
	-- function 26
	if not arg_26_1 then
		return
	end

	local tbl = {}

	for i = 1, #arg_26_1 do
		local var_26_1 = arg_26_1[i]
		local ItemType = var_26_1.ItemType
		local ItemId = var_26_1.ItemId

		if ItemType == "keep_decoration_painting" then
			local tbl_2 = {
				reward_type = "keep_decoration_painting",
				rewarded_from = var_26_1.Data.rewarded_from,
				keep_decoration_name = ItemId
			}

			tbl[#tbl + 1] = tbl_2

			self:add_keep_decoration(ItemId)
		elseif not CosmeticUtils.is_cosmetic_item(ItemType) then
			local add_item = self:add_item(nil, {
				ItemId = ItemId
			})

			if not add_item then
				local tbl_3 = {
					reward_type = ItemType,
					backend_id = add_item,
					rewarded_from = var_26_1.Data.rewarded_from,
					item_type = ItemType,
					item_id = ItemId
				}

				tbl[#tbl + 1] = tbl_3
			end
		else
			local var_26_7 = fn_3(ItemId)
			local CustomData = var_26_1.CustomData
			local flag = not CustomData and CustomData.rewarded_from

			if not var_26_7 and not flag then
				if not var_26_7.bundle then
					local BundledVirtualCurrencies = var_26_7.bundle.BundledVirtualCurrencies

					for k, v in pairs(BundledVirtualCurrencies) do
						local tbl_4 = {
							reward_type = "currency",
							currency_type = k,
							currency_amount = v,
							rewarded_from = flag
						}

						tbl[#tbl + 1] = tbl_4
					end
				else
					local ItemInstanceId = var_26_1.ItemInstanceId

					if not flag then
						local item_type = var_26_7.item_type
						local tbl_5 = {
							reward_type = "item",
							backend_id = ItemInstanceId,
							rewarded_from = flag,
							item_type = item_type,
							item_id = ItemId
						}

						tbl[#tbl + 1] = tbl_5
					end

					ItemHelper.mark_backend_id_as_new(ItemInstanceId, {
						data = var_26_7
					})
				end
			end
		end
	end

	self:_apply_unseen_rewards(tbl)
end

PlayFabMirrorBase._apply_unseen_rewards = function (self, arg_27_1)
	-- function 27
	local get_user_data = self:get_user_data("unseen_rewards")
	local flag

	flag = not get_user_data and cjson.decode(get_user_data) and {}

	table.append(flag, arg_27_1)
	self:set_user_data("unseen_rewards", cjson.encode(flag))
end

PlayFabMirrorBase.execute_dlc_logic_request_cb = function (self, arg_28_1)
	-- function 28
	self._num_items_to_load = self._num_items_to_load - 1

	self:_handle_owned_dlcs_data()

	local FunctionResult = arg_28_1.FunctionResult

	if not FunctionResult then
		local missing_dlc_info = FunctionResult.missing_dlc_info

		if not missing_dlc_info then
			local var_28_2

			if not missing_dlc_info.presentation_text_localized then
				var_28_2 = Localize(missing_dlc_info.presentation_text_localized)

				if not var_28_2 then
					-- Nothing
				end
			end

			var_28_2 = missing_dlc_info.presentation_text

			do
				local var_28_3
			end

			::label_28_0::

			if not missing_dlc_info.presentation_title_localized then
				var_28_3 = Localize(missing_dlc_info.presentation_title_localized)

				if not var_28_3 then
					-- Nothing
				end
			end

			var_28_3 = missing_dlc_info.presentation_title

			::label_28_1::

			local var_28_4

			if not missing_dlc_info.presentation_url_button then
				local tbl = {}
				local var_28_6

				if not missing_dlc_info.presentation_url_button.text_localized then
					var_28_6 = Localize(missing_dlc_info.presentation_url_button.text_localized)

					if not var_28_6 then
						-- Nothing
					end
				end

				var_28_6 = missing_dlc_info.presentation_url_button.text

				::label_28_2::

				tbl.text = var_28_6
				tbl.url = missing_dlc_info.presentation_url_button.url
				var_28_4 = tbl
			end

			Managers.backend:missing_required_dlc_error(var_28_2, var_28_3, var_28_4)

			return
		end

		self:_sync_unseen_rewards(FunctionResult.item_grant_results)
	end

	self:_request_best_power_levels()
end

PlayFabMirrorBase._request_best_power_levels = function (self)
	-- function 29
	local tbl = {
		FunctionName = "bestPowerLevels",
		FunctionParameter = {}
	}
	local var_29_1 = callback(self, "best_power_levels_request_cb")

	self._request_queue:enqueue(tbl, var_29_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.best_power_levels_request_cb = function (self, arg_30_1)
	-- function 30
	self._num_items_to_load = self._num_items_to_load - 1

	local best_power_levels = arg_30_1.FunctionResult.best_power_levels

	self._best_power_levels = best_power_levels

	local num = 0

	for k, v in pairs(best_power_levels) do
		num = num + v
	end

	self.sum_best_power_levels = num

	self:_request_signin_reward()
end

PlayFabMirrorBase._request_signin_reward = function (self)
	-- function 31
	local tbl = {
		FunctionName = "signInRewards",
		FunctionParameter = {}
	}
	local var_31_1 = callback(self, "sign_in_reward_request_cb")

	self._request_queue:enqueue(tbl, var_31_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.sign_in_reward_request_cb = function (self, arg_32_1)
	-- function 32
	self._num_items_to_load = self._num_items_to_load - 1

	local rewards = arg_32_1.FunctionResult.rewards

	for k, v in pairs(rewards) do
		local ItemGrantResults = v.ItemGrantResults

		if not ItemGrantResults then
			for i, v_2 in ipairs(ItemGrantResults) do
				if v_2.Result == true then
					local ItemInstanceId = v_2.ItemInstanceId

					if not k and not ItemInstanceId then
						ItemHelper.mark_sign_in_reward_as_new(k, ItemInstanceId)
					end
				end
			end
		end

		local unlocked_keep_decorations = v.unlocked_keep_decorations

		if not unlocked_keep_decorations then
			for i_2, v_3 in ipairs(unlocked_keep_decorations) do
				self:add_keep_decoration(v_3)
			end
		end

		local unlocked_cosmetics = v.unlocked_cosmetics

		if not unlocked_cosmetics then
			for i6 = 1, #unlocked_cosmetics do
				self:add_item(nil, {
					ItemId = unlocked_cosmetics[i6]
				})
			end
		end

		local unlocked_weapon_skins = v.unlocked_weapon_skins

		if not unlocked_weapon_skins then
			for i7 = 1, #unlocked_weapon_skins do
				self:add_unlocked_weapon_skin(unlocked_weapon_skins[i7])
			end
		end

		local unlocked_weapon_poses = v.unlocked_weapon_poses

		if not unlocked_weapon_poses then
			for i8 = 1, #unlocked_weapon_poses do
				self:add_unlocked_weapon_pose(unlocked_weapon_poses[i8])
			end
		end
	end

	self:_request_quests()
end

PlayFabMirrorBase._request_quests = function (self)
	-- function 33
	local tbl = {
		FunctionName = "getQuests",
		FunctionParameter = {}
	}
	local var_33_1 = callback(self, "get_quests_cb")

	self._request_queue:enqueue(tbl, var_33_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.get_quests_cb = function (self, arg_34_1)
	-- function 34
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_34_1.FunctionResult
	local current_daily_quests = FunctionResult.current_daily_quests
	local daily_quest_refresh_available = FunctionResult.daily_quest_refresh_available
	local daily_quest_update_time = FunctionResult.daily_quest_update_time
	local current_event_quests = FunctionResult.current_event_quests
	local current_weekly_quests = FunctionResult.current_weekly_quests
	local weekly_quest_update_time = FunctionResult.weekly_quest_update_time

	self:set_quest_data("current_daily_quests", current_daily_quests)
	self:set_quest_data("daily_quest_refresh_available", to_boolean(daily_quest_refresh_available))
	self:set_quest_data("daily_quest_update_time", tonumber(daily_quest_update_time))
	self:set_quest_data("current_event_quests", current_event_quests)
	self:set_quest_data("current_weekly_quests", current_weekly_quests)
	self:set_quest_data("weekly_quest_update_time", weekly_quest_update_time)
	self:_get_weekly_event_rewards()
end

PlayFabMirrorBase._get_weekly_event_rewards = function (self)
	-- function 35
	local tbl = {
		FunctionName = "getWeeklyEventRewards",
		FunctionParameter = {}
	}
	local var_35_1 = callback(self, "get_weekly_event_rewards_cb")

	self._request_queue:enqueue(tbl, var_35_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.get_weekly_event_rewards_cb = function (self, arg_36_1)
	-- function 36
	self._num_items_to_load = self._num_items_to_load - 1

	local data = arg_36_1.FunctionResult.data

	if not data then
		self:set_read_only_data("weekly_event_rewards", cjson.encode(data), true)
	end

	self:_request_fix_inventory_data_1()
end

PlayFabMirrorBase._request_fix_inventory_data_1 = function (self)
	-- function 37
	local tbl = {
		FunctionName = "fixInventoryData1",
		FunctionParameter = {}
	}
	local var_37_1 = callback(self, "fix_inventory_data_1_request_cb")

	self._request_queue:enqueue(tbl, var_37_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.fix_inventory_data_1_request_cb = function (self, arg_38_1)
	-- function 38
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_38_1.FunctionResult
	local flag = not FunctionResult and FunctionResult.updated_xp_data
	local flag_2 = not FunctionResult and FunctionResult.new_read_only_data

	if not flag then
		for k, v in pairs(flag) do
			self:set_read_only_data(k, v, true)
		end
	end

	if not flag_2 then
		for k_2, v_2 in pairs(flag_2) do
			self:set_read_only_data(k_2, v_2, true)

			if k_2 == "unlocked_weapon_skins" then
				self._unlocked_weapon_skins = self:_parse_unlocked_weapon_skins()
			elseif k_2 == "unlocked_cosmetics" then
				self._unlocked_cosmetics = self:_parse_unlocked_cosmetics()
			elseif k_2 == "unlocked_weapon_poses" then
				self._unlocked_weapon_poses = self:_parse_unlocked_weapon_poses()
			end
		end
	end

	self:_request_fix_inventory_data_2()
end

PlayFabMirrorBase._request_fix_inventory_data_2 = function (self)
	-- function 39
	local tbl = {
		FunctionName = "fixInventoryData2",
		FunctionParameter = {}
	}
	local var_39_1 = callback(self, "fix_inventory_data_2_request_cb")

	self._request_queue:enqueue(tbl, var_39_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.fix_inventory_data_2_request_cb = function (self, arg_40_1)
	-- function 40
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_40_1.FunctionResult
	local flag = not FunctionResult and FunctionResult.new_magic_level

	if not flag then
		local get_read_only_data = self:get_read_only_data("weaves_career_progress")
		local decode = cjson.decode(get_read_only_data)

		for i = 1, #tbl do
			local var_40_4 = tbl[i]

			if not decode[var_40_4] then
				decode[var_40_4].magic_level = flag
			end
		end

		self:set_read_only_data("weaves_career_progress", cjson.encode(decode), true)
	end

	self:_handle_fix_data_ids()
end

PlayFabMirrorBase._handle_fix_data_ids = function (self)
	-- function 41
	local tbl = {
		FunctionName = "handleFixDataIds",
		FunctionParameter = {}
	}
	local var_41_1 = callback(self, "handle_fix_data_ids_request_cb")

	self._request_queue:enqueue(tbl, var_41_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.handle_fix_data_ids_request_cb = function (self, arg_42_1)
	-- function 42
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_42_1.FunctionResult
	local var_42_1
	local var_42_2

	if FunctionResult.done ~= nil then
		var_42_1 = FunctionResult.done
		var_42_2 = FunctionResult.data
	else
		var_42_1 = true
		var_42_2 = FunctionResult
	end

	local new_user_read_only_data = var_42_2.new_user_read_only_data

	if not new_user_read_only_data then
		for k, v in pairs(new_user_read_only_data) do
			if type(v) == "table" then
				local encode = cjson.encode(v)

				self:set_read_only_data(k, encode, true)
			elseif v == "true" then
				self:set_read_only_data(k, true, true)
			elseif v == "false" then
				self:set_read_only_data(k, false, true)
			else
				local var_42_5 = self
				local set_read_only_data = self.set_read_only_data
				local var_42_7 = k
				local var_42_8 = tonumber(v)

				var_42_8 = var_42_8 or v

				set_read_only_data(var_42_5, var_42_7, var_42_8, true)
			end
		end
	end

	local new_user_data = var_42_2.new_user_data

	if not new_user_data then
		for k_2, v_2 in pairs(new_user_data) do
			if type(v_2) == "table" then
				local encode_2 = cjson.encode(v_2)

				self:set_user_data(k_2, encode_2, true)
			elseif v_2 == "true" then
				self:set_user_data(k_2, true, true)
			elseif v_2 == "false" then
				self:set_user_data(k_2, false, true)
			else
				local var_42_11 = self
				local set_user_data = self.set_user_data
				local var_42_13 = k_2
				local var_42_14 = tonumber(v_2)

				var_42_14 = var_42_14 or v_2

				set_user_data(var_42_11, var_42_13, var_42_14, true)
			end
		end
	end

	local new_cosmetics = var_42_2.new_cosmetics

	if not new_cosmetics then
		for i4 = 1, #new_cosmetics do
			self:add_item(nil, {
				ItemId = new_cosmetics[i4]
			})
		end
	end

	local new_weapon_poses = var_42_2.new_weapon_poses

	if not new_weapon_poses then
		for i5 = 1, #new_weapon_poses do
			self:add_item(nil, {
				ItemId = new_weapon_poses[i5]
			})
		end
	end

	local new_weapon_skins = var_42_2.new_weapon_skins

	if not new_weapon_skins then
		for i6 = 1, #new_weapon_skins do
			local var_42_18 = new_weapon_skins[i6]

			self:add_unlocked_weapon_skin(var_42_18)
		end
	end

	local new_items = var_42_2.new_items

	if not new_items then
		for i7 = 1, #new_items do
			local var_42_20 = new_items[i7]

			self:add_item(var_42_20.ItemInstanceId, var_42_20)
		end
	end

	local removed_items = var_42_2.removed_items

	if not removed_items then
		for i8 = 1, #removed_items do
			local var_42_22 = removed_items[i8]

			self:remove_item(var_42_22.ItemInstanceId)
		end
	end

	local modified_items = var_42_2.modified_items

	if not modified_items then
		for i9 = 1, #modified_items do
			local var_42_24 = modified_items[i9]

			if not self._inventory_items and not self._inventory_items[var_42_24.ItemInstanceId] then
				self:update_item(var_42_24.ItemInstanceId, var_42_24)
			else
				self:add_item(var_42_24.ItemInstanceId, var_42_24, false, true)
			end
		end
	end

	if not var_42_1 then
		self:_handle_fix_data_ids()
	else
		self:_fix_excess_bogenhafen_chests()
	end
end

PlayFabMirrorBase._fix_excess_bogenhafen_chests = function (self)
	-- function 43
	local tbl = {
		FunctionName = "removeExcessBogenhafenChests",
		FunctionParameter = {}
	}
	local var_43_1 = callback(self, "_fix_excess_bogenhafen_chests_cb")

	self._request_queue:enqueue(tbl, var_43_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase._fix_excess_bogenhafen_chests_cb = function (self)
	-- function 44
	self._num_items_to_load = self._num_items_to_load - 1

	self:_fix_excess_duplicate_bogenhafen_cosmetics()
end

PlayFabMirrorBase._fix_excess_duplicate_bogenhafen_cosmetics = function (self)
	-- function 45
	local tbl = {
		FunctionName = "removeDuplicateBogenhafenCosmetics",
		FunctionParameter = {}
	}
	local var_45_1 = callback(self, "_fix_excess_duplicate_bogenhafen_cosmetics_cb")

	self._request_queue:enqueue(tbl, var_45_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase._fix_excess_duplicate_bogenhafen_cosmetics_cb = function (self)
	-- function 46
	self._num_items_to_load = self._num_items_to_load - 1

	self:_request_read_only_data()
end

PlayFabMirrorBase._request_read_only_data = function (self)
	-- function 47
	local tbl = {
		FunctionName = "getReadOnlyData",
		FunctionParameter = {}
	}
	local var_47_1 = callback(self, "read_only_data_request_cb")

	self._request_queue:enqueue(tbl, var_47_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.read_only_data_request_cb = function (self, arg_48_1)
	-- function 48
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_48_1.FunctionResult
	local achievement_rewards = FunctionResult.achievement_rewards

	self._achievement_rewards = cjson.decode(achievement_rewards)

	local weaves_progression_settings = FunctionResult.weaves_progression_settings
	local decode

	if not weaves_progression_settings then
		decode = cjson.decode(weaves_progression_settings)

		if not decode then
			-- Nothing
		end
	end

	decode = {}

	::label_48_0::

	self._weaves_progression_settings = decode

	local power_level_data = FunctionResult.power_level_data
	local decode_2

	if not power_level_data then
		decode_2 = cjson.decode(power_level_data)

		if not decode_2 then
			-- Nothing
		end
	end

	decode_2 = {}

	::label_48_1::

	self._power_level_data = decode_2

	local rarity_tables = FunctionResult.rarity_tables
	local decode_3

	if not rarity_tables then
		decode_3 = cjson.decode(rarity_tables)

		if not decode_3 then
			-- Nothing
		end
	end

	decode_3 = {}

	::label_48_2::

	self._rarity_tables = decode_3

	self:_generate_formatted_rarity_tables(self._rarity_tables)
	self:_request_user_data()
end

PlayFabMirrorBase._request_user_data = function (self)
	-- function 49
	local tbl = {}
	local var_49_1 = callback(self, "user_data_request_cb")

	self._request_queue:enqueue_api_request("GetUserData", tbl, var_49_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.user_data_request_cb = function (self, arg_50_1)
	-- function 50
	self._num_items_to_load = self._num_items_to_load - 1

	for k, v in pairs(arg_50_1.Data) do
		if k == "unseen_rewards" then
			local decode = cjson.decode(v.Value)
			local get_user_data = self:get_user_data("unseen_rewards")
			local decode_2

			if not get_user_data then
				decode_2 = cjson.decode(get_user_data)

				if not decode_2 then
					-- Nothing
				end
			end

			decode_2 = {}

			::label_50_0::

			local is_fake_item = ItemHelper.is_fake_item

			for k_2 = 1, #decode do
				local var_50_4 = decode[k_2]

				if not is_fake_item(var_50_4.reward_type) then
					if not table.find_by_key(decode_2, "item_id", var_50_4.item_id) then
						decode_2[#decode_2 + 1] = var_50_4
					end
				elseif not table.find_by_key(decode_2, "backend_id", var_50_4.backend_id) then
					decode_2[#decode_2 + 1] = var_50_4
				end
			end

			self:set_user_data(k, cjson.encode(decode_2))
		else
			self:set_user_data(k, v.Value, true)
		end
	end

	self:_request_twitch_app_access_token()
end

PlayFabMirrorBase._request_twitch_app_access_token = function (self)
	-- function 51
	local tbl = {
		FunctionName = "getTwitchAccessToken",
		FunctionParameter = {}
	}
	local var_51_1 = callback(self, "_request_twitch_app_access_token_cb")

	self._request_queue:enqueue(tbl, var_51_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase._request_twitch_app_access_token_cb = function (self, arg_52_1)
	-- function 52
	self._num_items_to_load = self._num_items_to_load - 1
	self._twitch_app_access_token = false

	local FunctionResult = arg_52_1.FunctionResult

	if not FunctionResult.success then
		self._twitch_app_access_token = FunctionResult.access_token
	end

	self:_weaves_player_setup()
end

PlayFabMirrorBase.get_twitch_app_access_token = function (self)
	-- function 53
	return self._twitch_app_access_token
end

PlayFabMirrorBase._weaves_player_setup = function (self)
	-- function 54
	local tbl = {
		FunctionName = "weavesPlayerSetup",
		FunctionParameter = {}
	}
	local var_54_1 = callback(self, "weaves_player_setup_request_cb")

	self._request_queue:enqueue(tbl, var_54_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.weaves_player_setup_request_cb = function (self, arg_55_1)
	-- function 55
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_55_1.FunctionResult
	local created = FunctionResult.created
	local essence = FunctionResult.essence
	local total_essence = FunctionResult.total_essence
	local maximum_essence = FunctionResult.maximum_essence

	if not created then
		local new_user_data = FunctionResult.new_user_data

		for k, v in pairs(new_user_data) do
			self:set_read_only_data(k, v, true)
		end
	end

	self:set_essence(essence)
	self:set_total_essence(total_essence)
	self:set_maximum_essence(maximum_essence)
	self:_fix_total_collected_essence()
end

PlayFabMirrorBase._fix_total_collected_essence = function (self)
	-- function 56
	local tbl = {
		FunctionName = "fixTotalCollectedEssence",
		FunctionParameter = {}
	}
	local var_56_1 = callback(self, "fix_total_collected_essence_cb")

	self._request_queue:enqueue(tbl, var_56_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.fix_total_collected_essence_cb = function (self, arg_57_1)
	-- function 57
	self._num_items_to_load = self._num_items_to_load - 1

	local total_essence = arg_57_1.FunctionResult.total_essence

	if not total_essence then
		self:set_total_essence(total_essence)
	end

	if not DLCSettings.win_tracks then
		self:_request_win_tracks()
	elseif not DLCSettings.morris then
		self:_deus_player_setup()
		self:_deus_setup_belakor_data()
	else
		self:_set_up_additional_account_data()
	end
end

PlayFabMirrorBase._request_win_tracks = function (self)
	-- function 58
	local tbl = {
		FunctionName = "winTracksSetup",
		FunctionParameter = {}
	}
	local var_58_1 = callback(self, "win_tracks_request_cb")

	self._request_queue:enqueue(tbl, var_58_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.win_tracks_request_cb = function (self, arg_59_1)
	-- function 59
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_59_1.FunctionResult
	local new_read_only_data = FunctionResult.new_read_only_data

	for k, v in pairs(new_read_only_data) do
		local encode = cjson.encode(v)

		self:set_read_only_data(k, encode, true)
	end

	self._win_tracks = FunctionResult.win_tracks
	self._current_win_track_id = FunctionResult.new_read_only_data.win_tracks_progress.current_win_track_id

	if not DLCSettings.morris then
		self:_deus_player_setup()
		self:_deus_setup_belakor_data()
	else
		self:_set_up_additional_account_data()
	end
end

PlayFabMirrorBase.get_win_tracks = function (self)
	-- function 60
	return self._win_tracks
end

PlayFabMirrorBase._deus_player_setup = function (self)
	-- function 61
	local tbl = {
		FunctionName = "deusPlayerSetup",
		FunctionParameter = {}
	}
	local var_61_1 = callback(self, "deus_player_setup_request_cb")

	self._request_queue:enqueue(tbl, var_61_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.deus_player_setup_request_cb = function (self, arg_62_1)
	-- function 62
	self._num_items_to_load = self._num_items_to_load - 1

	self:handle_deus_result(arg_62_1)
	self:_set_up_additional_account_data()
end

PlayFabMirrorBase.deus_refresh_belakor_data = function (self)
	-- function 63
	self:_deus_setup_belakor_data()
end

PlayFabMirrorBase.has_loaded_belakor_data = function (self)
	-- function 64
	return self._belakor_data_loaded
end

PlayFabMirrorBase.set_has_loaded_belakor_data = function (self, arg_65_1)
	-- function 65
	self._belakor_data_loaded = arg_65_1
end

PlayFabMirrorBase._deus_setup_belakor_data = function (self)
	-- function 66
	local tbl = {
		FunctionName = "deusSetBelakorCurse",
		FunctionParameter = {}
	}
	local var_66_1 = callback(self, "deus_setup_belakor_data_request_cb")

	self._request_queue:enqueue(tbl, var_66_1)

	self._belakor_data_loaded = false
end

PlayFabMirrorBase.deus_setup_belakor_data_request_cb = function (self, arg_67_1)
	-- function 67
	self._belakor_data_loaded = true

	local deus_belakor_curse_data = arg_67_1.FunctionResult.deus_belakor_curse_data

	if not deus_belakor_curse_data then
		local time = Managers.time:time("main")

		self._deus_belakor_curse_data = {
			time_of_update = time,
			span = deus_belakor_curse_data.span_ms / 1000,
			remaining_time = deus_belakor_curse_data.remaining_time_ms / 1000,
			cycle_count = deus_belakor_curse_data.cycle_count
		}
	end
end

PlayFabMirrorBase._set_up_additional_account_data = function (self, arg_68_1)
	-- function 68
	local tbl = {
		FunctionName = "additionalAccountDataSetUp",
		FunctionParameter = {
			steps_completed = arg_68_1
		}
	}
	local var_68_1 = callback(self, "additional_data_setup_request_cb")

	self._request_queue:enqueue(tbl, var_68_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.additional_data_setup_request_cb = function (self, arg_69_1)
	-- function 69
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_69_1.FunctionResult
	local new_user_read_only_data = FunctionResult.new_user_read_only_data
	local new_currencies = FunctionResult.new_currencies

	if not new_user_read_only_data then
		for k, v in pairs(new_user_read_only_data) do
			self:set_read_only_data(k, v, true)
		end
	end

	if not new_currencies then
		local currency_ui_settings = DLCSettings.store.currency_ui_settings
		local get_interface = Managers.backend:get_interface("peddler")

		for k_2, v_2 in pairs(new_currencies) do
			if k_2 == "ES" then
				self:set_essence(self._essence + v_2)
			elseif currency_ui_settings[k_2] == nil or not get_interface then
				local get_chips = get_interface:get_chips(k_2)

				get_interface:set_chips(k_2, get_chips + v_2)
			end
		end
	end

	local steps_completed = FunctionResult.steps_completed

	if not steps_completed then
		self:_set_up_additional_account_data(steps_completed)
	else
		self:_request_user_inventory()
	end
end

PlayFabMirrorBase._request_user_inventory = function (self)
	-- function 70
	local tbl = {}
	local var_70_1 = callback(self, "inventory_request_cb")

	self._request_queue:enqueue_api_request("GetUserInventory", tbl, var_70_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.inventory_request_cb = function (self, arg_71_1)
	-- function 71
	self._num_items_to_load = self._num_items_to_load - 1

	local Inventory = arg_71_1.Inventory
	local unlock = Managers.unlock

	if not self._inventory_items then
		table.clear(self._inventory_items)
	else
		self._inventory_items = {}
	end

	for i = 1, #Inventory do
		local var_71_2 = Inventory[i]

		if not var_71_2.BundleContents then
			if not (not var_71_2.ItemId and rawget(ItemMasterList, var_71_2.ItemId)) then
				Crashify.print_exception("PlayFabMirrorBase", "ItemMasterList has no item %q", var_71_2.ItemId)
			else
				local ItemInstanceId = var_71_2.ItemInstanceId

				self:_update_data(var_71_2, ItemInstanceId)

				local flag = false
				local item_type = var_71_2.data.item_type

				if item_type == "weapon_skin" or not CosmeticUtils.is_cosmetic_item(item_type) then
					flag = true
				end

				local required_dlc = ItemMasterList[var_71_2.ItemId].required_dlc

				if not (not required_dlc and unlock:is_dlc_unlocked(required_dlc)) then
					flag = true

					self:_register_dlc_filtered_data(required_dlc, var_71_2, ItemInstanceId)
				end

				if not flag then
					self._inventory_items[ItemInstanceId] = var_71_2
				end
			end
		end
	end

	local get_unlocked_weapon_skins = self:get_unlocked_weapon_skins()

	get_unlocked_weapon_skins = get_unlocked_weapon_skins or {}

	local get_unlocked_cosmetics = self:get_unlocked_cosmetics()

	get_unlocked_cosmetics = get_unlocked_cosmetics or {}

	local get_unlocked_weapon_poses = self:get_unlocked_weapon_poses()

	get_unlocked_weapon_poses = get_unlocked_weapon_poses or {}

	self:_create_fake_inventory_items(get_unlocked_weapon_skins, "weapon_skins")
	self:_create_fake_inventory_items(get_unlocked_cosmetics, "cosmetics")
	self:_create_fake_inventory_items(get_unlocked_weapon_poses, "weapon_poses")

	if not HAS_STEAM then
		self:_request_steam_user_inventory()
	else
		self:request_characters()
	end
end

PlayFabMirrorBase.update_filtered_dlc_data = function (self)
	-- function 72
	local unlock = Managers.unlock

	for k in pairs(self._filtered_data) do
		if not unlock:is_dlc_unlocked(k) then
			self:_grant_filtered_data(k)
		end
	end
end

PlayFabMirrorBase._request_steam_user_inventory = function (self)
	-- function 73
	fn("steam item server: requesting user inventory")

	self._num_items_to_load = self._num_items_to_load + 1

	local function fn_2(arg_74_0, arg_74_1)
		-- function 74
		if not arg_74_1 then
			fn("_request_steam_user_inventory got results")
		else
			fn("_request_steam_user_inventory got no results")
		end

		local flag = true
		local flag_2 = true

		self:_cb_steam_user_inventory(arg_74_0, arg_74_1, flag, flag_2)
	end

	Managers.steam:request_user_inventory(fn_2)
end

PlayFabMirrorBase.delete_playfab_characters_cb = function (self, arg_75_1)
	-- function 75
	self._num_items_to_load = self._num_items_to_load - 1

	self:request_characters()
end

PlayFabMirrorBase.add_steam_items = function (self, arg_76_1)
	-- function 76
	local num = 1

	self._num_items_to_load = self._num_items_to_load + 1

	local flag = false

	self:_cb_steam_user_inventory(num, arg_76_1, false, flag)
end

PlayFabMirrorBase._cb_steam_user_inventory = function (self, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	-- function 77
	self._num_items_to_load = self._num_items_to_load - 1

	if arg_77_1 == 1 then
		fn("-> retrieval of steam user inventory, SUCCESS")

		for i = 1, #arg_77_2, 4 do
			local var_77_0 = arg_77_2[i]
			local var_77_1 = arg_77_2[i + 1]
			local var_77_2 = arg_77_2[i + 2]
			local var_77_3 = arg_77_2[i + 3]
			local var_77_4 = SteamitemdefidToMasterList[var_77_0]

			if not var_77_4 then
				local var_77_5 = var_77_1
				local tbl = {
					ItemId = var_77_4,
					ItemInstanceId = var_77_5
				}
				local var_77_7 = ItemMasterList[var_77_4]

				if not ((var_77_7.slot_type == "melee" or var_77_7.slot_type == "ranged") and not tbl.CustomData and tbl.CustomData.power_level) then
					local tbl_2 = {
						power_level = 5
					}
					local rarity = var_77_7.rarity

					rarity = rarity or "default"
					tbl_2.rarity = rarity
					tbl.CustomData = tbl_2
				end

				self:add_item(var_77_5, tbl, true, arg_77_4)
				fn("Steam Item: %q, %q, %q, %q, %q", var_77_4, var_77_0, var_77_1, var_77_2, var_77_3)
			end
		end
	else
		fn("ERROR could not retrieve get steam user inventory. result-code: %q", arg_77_1)
	end

	if not arg_77_3 then
		self:request_characters()
	end
end

PlayFabMirrorBase._set_inital_career_data = function (self, arg_78_1, arg_78_2, arg_78_3)
	-- function 78
	if not arg_78_3 then
		return
	end

	local var_78_0 = self._career_data[arg_78_1]
	local var_78_1 = self._career_data_mirror[arg_78_1]
	local tbl = {}

	table.clear(var_78_0)
	table.clear(var_78_1)

	for i = 1, #arg_78_2 do
		local var_78_3 = arg_78_2[i]
		local tbl_2 = {}

		for j = 1, #arg_78_3 do
			local var_78_5 = arg_78_3[j]
			local var_78_6 = var_78_3[var_78_5]
			local Value

			if type(var_78_6) == "table" then
				Value = var_78_6.Value

				if not Value then
					-- Nothing
				end
			end

			Value = var_78_6

			::label_78_0::

			if not Value then
				tbl_2[var_78_5] = true
			elseif not CosmeticUtils.is_cosmetic_slot(var_78_5) then
				if not self._unlocked_cosmetics[Value] then
					tbl_2[var_78_5] = true
				end
			elseif var_78_5 == "slot_pose" then
				local parent = ItemMasterList[Value].parent
				local var_78_9 = self._unlocked_weapon_poses[parent]

				var_78_9 = not var_78_9 and self._unlocked_weapon_poses[parent][Value]

				if not var_78_9 then
					tbl_2[var_78_5] = true
				end
			else
				local var_78_10 = self._inventory_items[Value]

				if not var_78_10 then
					if Managers.mechanism:current_mechanism_name() == "versus" then
						local CustomData = var_78_10.CustomData

						if (not CustomData and CustomData.rarity) ~= "default" then
							tbl_2[var_78_5] = true
						end
					end
				else
					tbl_2[var_78_5] = true
				end
			end
		end

		self:_verify_items_are_usable(tbl_2, var_78_3, arg_78_1, arg_78_3)

		local tbl_3 = {}
		local tbl_4 = {}

		for k, v in pairs(var_78_3) do
			local Value_2

			if type(v) == "table" then
				Value_2 = v.Value

				if not Value_2 then
					-- Nothing
				end
			end

			Value_2 = v

			::label_78_1::

			tbl_3[k] = Value_2
			tbl_4[k] = Value_2
		end

		var_78_0[i] = tbl_3
		var_78_1[i] = tbl_4

		if table.size(tbl_2) > 0 then
			tbl[tostring(i)] = tbl_2
		end
	end

	if table.size(tbl) > 0 then
		return tbl
	end
end

PlayFabMirrorBase._verify_items_are_usable = function (self, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
	-- function 79
	local var_79_0 = CareerSettings[arg_79_3]

	if not var_79_0 then
		fn("Tried to verify items of career that doesn't exist: %q", arg_79_3)

		return
	end

	local item_slot_types_by_slot_name = var_79_0.item_slot_types_by_slot_name

	for i = 1, #arg_79_4 do
		local var_79_2 = arg_79_4[i]

		if not arg_79_1[var_79_2] then
			local var_79_3 = arg_79_2[var_79_2]
			local Value

			if type(var_79_3) == "table" then
				Value = var_79_3.Value

				if not Value then
					-- Nothing
				end
			end

			Value = var_79_3

			::label_79_0::

			if not Value then
				local var_79_5 = self._inventory_items[Value]

				if not CosmeticUtils.is_cosmetic_slot(var_79_2) then
					local var_79_6 = self._unlocked_cosmetics[Value]

					if not var_79_6 then
						var_79_5 = self._inventory_items[var_79_6]
					end
				end

				if var_79_2 == "slot_pose" then
					local parent = ItemMasterList[Value].parent
					local var_79_8 = self._unlocked_weapon_poses[parent][Value]

					if not var_79_8 then
						var_79_5 = self._inventory_items[var_79_8]
					end
				end

				if not var_79_5 then
					local data = var_79_5.data
					local can_wield = data.can_wield

					if not table.contains(can_wield, arg_79_3) then
						arg_79_1[var_79_2] = true
					end

					local var_79_11 = item_slot_types_by_slot_name[var_79_2]
					local slot_type = data.slot_type
					local rarity = data.rarity

					if not (not table.contains(var_79_11, slot_type) and rarity ~= "magic") then
						arg_79_1[var_79_2] = true
					end
				else
					arg_79_1[var_79_2] = true
				end
			end
		end
	end
end

PlayFabMirrorBase._update_data = function (arg_80_0, arg_80_1, arg_80_2)
	-- function 80
	local CustomData = arg_80_1.CustomData

	if not CustomData then
		local properties = CustomData.properties

		if not properties then
			arg_80_1.properties = cjson.decode(properties)
		end

		local traits = CustomData.traits

		if not traits then
			arg_80_1.traits = cjson.decode(traits)
		end

		local power_level = CustomData.power_level

		if not power_level then
			arg_80_1.power_level = tonumber(power_level)
		end

		local rarity = CustomData.rarity

		if not rarity then
			arg_80_1.rarity = rarity
		end

		local skin = CustomData.skin

		if not skin then
			arg_80_1.skin = skin
		end

		local level_key = CustomData.level_key

		if not level_key then
			arg_80_1.level_key = level_key
		end

		local difficulty = CustomData.difficulty

		if not difficulty then
			arg_80_1.difficulty = difficulty
		end

		local magic_level = CustomData.magic_level

		if not magic_level then
			arg_80_1.magic_level = tonumber(magic_level)
			arg_80_1.power_level = WeaveUtils.magic_level_to_power_level(arg_80_1.magic_level)
		end
	end

	local ItemId = arg_80_1.ItemId
	local var_80_10 = ItemMasterList[ItemId]

	if not arg_80_1.rarity then
		arg_80_1.rarity = var_80_10.rarity
	end

	arg_80_1.backend_id = arg_80_2
	arg_80_1.key = ItemId
	arg_80_1.data = var_80_10
end

PlayFabMirrorBase.ready = function (self)
	-- function 81
	local _inventory_items = self._inventory_items

	_inventory_items = not _inventory_items and self._num_items_to_load == 0

	return _inventory_items
end

PlayFabMirrorBase.current_api_call = function (self)
	-- function 82
	if not self._request_queue then
		return
	end

	return self._request_queue:current_api_call()
end

PlayFabMirrorBase.update = function (self, arg_83_1, arg_83_2)
	-- function 83
	local var_83_0
	local var_83_1

	if not self._request_queue_error then
		return
	else
		local var_83_2

		var_83_0, var_83_2 = self._request_queue:update(arg_83_1, arg_83_2)
	end

	if not var_83_0 then
		self._request_queue_error = var_83_0

		if var_83_0 == "request_timed_out" then
			Managers.backend:request_timeout()
		end

		return
	end

	if not self._commit_current_id then
		self:_check_current_commit()
	end

	local _queued_commit = self._queued_commit

	if not _queued_commit.active then
		_queued_commit.timer = _queued_commit.timer - arg_83_1

		if not (_queued_commit.timer <= 0) or self._commit_current_id or Managers.account:user_detached() or not LobbyInternal.network_initialized() then
			self:_commit_internal(_queued_commit.id, _queued_commit.commit_complete_callbacks)
		end
	end

	self._commit_limit_timer = self._commit_limit_timer - arg_83_1

	if self._commit_limit_timer <= 0 then
		self._commit_limit_timer = num
		self._commit_limit_total = math.max(self._commit_limit_total - 1, 1)
	end
end

PlayFabMirrorBase._check_current_commit = function (self)
	-- function 84
	local _commit_status = self:_commit_status()

	if _commit_status ~= "waiting" then
		local _commit_current_id = self._commit_current_id
		local var_84_2 = self._commits[_commit_current_id]

		fn("commit result %q, %q", _commit_status, _commit_current_id)

		self._commit_current_id = nil

		if _commit_status == "commit_error" then
			self._commit_error = true
		else
			Managers.backend:dirtify_interfaces()
		end

		if not var_84_2.commit_complete_callbacks then
			for i = 1, #var_84_2.commit_complete_callbacks do
				var_84_2.commit_complete_callbacks[i](_commit_status)
			end
		end

		self._commits[_commit_current_id] = nil
	end
end

PlayFabMirrorBase._commit_status = function (self)
	-- function 85
	local _commit_current_id = self._commit_current_id

	fassert(_commit_current_id, "Querying status for commit_current_id %s", tostring(_commit_current_id))

	local var_85_1 = self._commits[_commit_current_id]

	fassert(var_85_1, "No commit with id %d", _commit_current_id)

	if var_85_1.status == "commit_error" then
		return "commit_error"
	elseif not (var_85_1.num_updates ~= var_85_1.updates_to_make or var_85_1.wait_for_stats or var_85_1.wait_for_weave_user_data or var_85_1.wait_for_keep_decorations or var_85_1.wait_for_user_data or var_85_1.wait_for_read_only_data or var_85_1.wait_for_win_tracks_data or var_85_1.wait_for_gotwf_data or var_85_1.wait_for_weapon_pose_skin_data) then
		if Managers.account:offline_mode() or not IS_CONSOLE then
			PlayfabBackendSaveDataUtils.store_online_data(self)
		end

		return "success"
	end

	return var_85_1.status
end

PlayFabMirrorBase.get_current_commit_id = function (self)
	-- function 86
	return self._commit_current_id
end

PlayFabMirrorBase.have_queued_commit = function (self)
	-- function 87
	return not table.is_empty(self._queued_commit)
end

PlayFabMirrorBase.request_queue = function (self)
	-- function 88
	return self._request_queue
end

PlayFabMirrorBase.get_playfab_id = function (self)
	-- function 89
	return self._playfab_id
end

PlayFabMirrorBase.get_character_data = function (self, arg_90_1, arg_90_2, arg_90_3)
	-- function 90
	local _career_data = self._career_data
	local flag = arg_90_3 or self._career_loadouts[arg_90_1]
	local var_90_2 = _career_data[arg_90_1]

	var_90_2 = not var_90_2 and _career_data[arg_90_1][flag]

	if var_90_2 ~= nil then
		return var_90_2[arg_90_2]
	end

	return nil
end

PlayFabMirrorBase.has_loadout = function (self, arg_91_1, arg_91_2)
	-- function 91
	local _career_data = self._career_data
	local var_91_1 = _career_data[arg_91_1]

	var_91_1 = not var_91_1 and _career_data[arg_91_1][arg_91_2]

	return var_91_1 ~= nil
end

PlayFabMirrorBase.set_character_data = function (self, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
	-- function 92
	local var_92_0 = self._career_data[arg_92_1]
	local flag = arg_92_5 or self._career_loadouts[arg_92_1]

	var_92_0[flag][arg_92_2] = arg_92_3

	if not arg_92_4 then
		self._career_data_mirror[arg_92_1][flag][arg_92_2] = arg_92_3
	end

	local display_name = PROFILES_BY_CAREER_NAMES[arg_92_1].display_name

	self:set_career_read_only_data(display_name, arg_92_2, arg_92_3, arg_92_1, arg_92_4, flag)
end

PlayFabMirrorBase.get_career_loadouts = function (self, arg_93_1)
	-- function 93
	if not arg_93_1 then
		return nil
	end

	local var_93_0 = self._career_data[arg_93_1]

	return self._career_loadouts[arg_93_1], var_93_0
end

PlayFabMirrorBase.get_default_loadouts = function (self, arg_94_1)
	-- function 94
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if not (not arg_94_1 and current_mechanism_name) then
		return nil
	end

	local var_94_1 = self._character_default_loadouts[current_mechanism_name]

	var_94_1 = var_94_1 or self._character_default_loadouts.adventure

	return var_94_1[arg_94_1]
end

PlayFabMirrorBase.set_loadout_index = function (self, arg_95_1, arg_95_2)
	-- function 95
	if not (not arg_95_1 and arg_95_2) then
		return
	end

	if not self._career_data[arg_95_1][arg_95_2] then
		self._career_loadouts[arg_95_1] = arg_95_2

		local var_95_0 = PROFILES_BY_CAREER_NAMES[arg_95_1]
		local index = var_95_0.index
		local display_name = var_95_0.display_name
		local var_95_3 = career_index_from_name(index, arg_95_1)
		local _characters_data = self._characters_data

		_characters_data[display_name].loadouts[var_95_3] = arg_95_2

		local encode = cjson.encode(_characters_data)

		self:set_read_only_data(self._characters_data_key, encode, false)
		Managers.backend:dirtify_interfaces()
	end
end

PlayFabMirrorBase.delete_loadout = function (self, arg_96_1, arg_96_2)
	-- function 96
	if not (not arg_96_1 and arg_96_2) then
		return
	end

	local get_career_loadouts, var_96_1 = self:get_career_loadouts(arg_96_1)

	if arg_96_2 > #var_96_1 then
		return
	end

	if #var_96_1 == 1 then
		return
	end

	local var_96_2 = PROFILES_BY_CAREER_NAMES[arg_96_1]
	local index = var_96_2.index
	local display_name = var_96_2.display_name
	local var_96_5 = career_index_from_name(index, arg_96_1)
	local _characters_data = self._characters_data
	local var_96_7 = _characters_data[display_name]
	local var_96_8 = var_96_7.careers[arg_96_1]

	table.remove(var_96_8, arg_96_2)
	table.remove(var_96_1, arg_96_2)

	if arg_96_2 == get_career_loadouts then
		self._career_loadouts[arg_96_1] = 1
		var_96_7.loadouts[var_96_5] = 1
	else
		local clamp = math.clamp(get_career_loadouts, 1, #var_96_1)

		self._career_loadouts[arg_96_1] = clamp
		var_96_7.loadouts[var_96_5] = clamp
	end

	local encode = cjson.encode(_characters_data)

	self:set_read_only_data(self._characters_data_key, encode, false)
	Managers.backend:dirtify_interfaces()
end

PlayFabMirrorBase.add_loadout = function (self, arg_97_1)
	-- function 97
	if not arg_97_1 then
		return
	end

	local get_career_loadouts, var_97_1 = self:get_career_loadouts(arg_97_1)
	local var_97_2 = var_97_1[get_career_loadouts]

	if #var_97_1 < InventorySettings.MAX_NUM_CUSTOM_LOADOUTS then
		local var_97_3 = PROFILES_BY_CAREER_NAMES[arg_97_1]
		local index = var_97_3.index
		local display_name = var_97_3.display_name
		local var_97_6 = career_index_from_name(index, arg_97_1)
		local num = get_career_loadouts + 1
		local clone = table.clone(var_97_2)

		var_97_1[#var_97_1 + 1] = clone
		self._career_loadouts[arg_97_1] = num

		local _characters_data = self._characters_data
		local var_97_10 = _characters_data[display_name]
		local var_97_11 = var_97_10.careers[arg_97_1]

		var_97_11[#var_97_11 + 1] = table.clone(clone)
		var_97_10.loadouts[var_97_6] = num

		local encode = cjson.encode(_characters_data)

		self:set_read_only_data(self._characters_data_key, encode, false)
		Managers.backend:dirtify_interfaces()
	end
end

PlayFabMirrorBase.get_title_data = function (self)
	-- function 98
	return self._title_data
end

PlayFabMirrorBase.set_title_data = function (arg_99_0, arg_99_1, arg_99_2)
	-- function 99
	if not tonumber(arg_99_2) then
		arg_99_2 = tonumber(arg_99_2)
	end

	arg_99_0._title_data[arg_99_1] = arg_99_2
end

PlayFabMirrorBase.get_user_data = function (self, arg_100_1)
	-- function 100
	return self._user_data[arg_100_1]
end

PlayFabMirrorBase.set_user_data = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	-- function 101
	arg_101_0._user_data[arg_101_1] = arg_101_2

	if not arg_101_3 then
		if type(arg_101_2) == "table" then
			arg_101_0._user_data_mirror[arg_101_1] = table.clone(arg_101_2)
		else
			arg_101_0._user_data_mirror[arg_101_1] = arg_101_2
		end
	end
end

PlayFabMirrorBase.log_player_exit = function (self, arg_102_1)
	-- function 102
	local tbl = {
		FunctionName = "logPlayerExit",
		FunctionParameter = {}
	}
	local var_102_1 = callback(self, "log_player_exit_cb", arg_102_1)
	local enqueue = self._request_queue:enqueue(tbl, var_102_1, false)
end

PlayFabMirrorBase.log_player_exit_cb = function (arg_103_0, arg_103_1, arg_103_2)
	-- function 103
	arg_103_1(arg_103_2)
end

PlayFabMirrorBase._commit_user_data = function (self, arg_104_1, arg_104_2, arg_104_3)
	-- function 104
	table.clear(arg_104_1)

	for k, v in pairs(self._user_data) do
		if self._user_data_mirror[k] ~= v then
			arg_104_1[k] = v
		end
	end

	if not table.is_empty(arg_104_1) then
		local tbl = {
			Data = arg_104_1
		}

		self._user_data_mirror = table.clone(self._user_data)

		local var_104_1 = callback(self, "update_user_data_cb", arg_104_3)

		PlayFabClientApi.UpdateUserData(tbl, var_104_1)

		self._num_items_to_load = self._num_items_to_load + 1
		arg_104_2.status = "waiting"
		arg_104_2.wait_for_user_data = true
	end
end

PlayFabMirrorBase.update_user_data_cb = function (self, arg_105_1, arg_105_2)
	-- function 105
	self._num_items_to_load = self._num_items_to_load - 1
	self._commits[arg_105_1].wait_for_user_data = false
end

PlayFabMirrorBase.get_read_only_data = function (self, arg_106_1)
	-- function 106
	local var_106_0 = self._read_only_data[arg_106_1]
	local var_106_1 = type(var_106_0)

	fn_2(var_106_0 == nil or tbl_2[var_106_1], "Tried to get read_only_data's '%s'. Got value '%s' ('%s')", arg_106_1, tostring(var_106_0), var_106_1)

	return var_106_0
end

PlayFabMirrorBase.set_read_only_data = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
	-- function 107
	if not ((arg_107_3 or not rawget(_G, "debug_characters_data_unsafe_write")) and arg_107_1 == "characters_data" or arg_107_1 ~= "vs_characters_data") then
		print("[PlayfabMirrorBase] Overwriting character data while it is unsafe to do so")
		Crashify.print_exception("[PlayfabMirrorBase]", "Unsafe write to readonly data")
	end

	local var_107_0 = type(arg_107_2)

	fn_2(tbl_2[var_107_0], "Tried to set read_only_data's '%s' to value '%s' ('%s')", arg_107_1, tostring(arg_107_2), var_107_0)

	arg_107_0._read_only_data[arg_107_1] = arg_107_2

	if not arg_107_3 then
		if var_107_0 == "table" then
			arg_107_0._read_only_data_mirror[arg_107_1] = table.clone(arg_107_2)
		else
			arg_107_0._read_only_data_mirror[arg_107_1] = arg_107_2
		end
	end
end

PlayFabMirrorBase.merge_read_only_data = function (self, arg_108_1, arg_108_2)
	-- function 108
	for k, v in pairs(arg_108_1) do
		local var_108_0 = type(v)

		fn_2(tbl_2[var_108_0], "Tried to merge read_only_data's '%s' with value '%s' ('%s')", k, tostring(v), var_108_0)
	end

	table.merge_recursive(self._read_only_data, arg_108_1)

	if not arg_108_2 then
		table.merge_recursive(self._read_only_data_mirror, arg_108_1)
	end
end

PlayFabMirrorBase.get_all_inventory_items = function (self)
	-- function 109
	return self._inventory_items
end

PlayFabMirrorBase.get_all_fake_inventory_items = function (self)
	-- function 110
	return self._fake_inventory_items
end

PlayFabMirrorBase.get_stats = function (self)
	-- function 111
	return self._stats
end

PlayFabMirrorBase.set_stats = function (self, arg_112_1)
	-- function 112
	self._stats = arg_112_1
end

PlayFabMirrorBase.get_claimed_achievements = function (self)
	-- function 113
	return self._claimed_achievements
end

PlayFabMirrorBase.get_claimed_event_quests = function (self)
	-- function 114
	return self._claimed_event_quests
end

PlayFabMirrorBase.add_claimed_event_quest = function (arg_115_0, arg_115_1)
	-- function 115
	arg_115_0._claimed_event_quests[arg_115_1] = true
end

PlayFabMirrorBase.add_claimed_multiple_event_quests = function (arg_116_0, arg_116_1)
	-- function 116
	for i = 1, #arg_116_1 do
		local var_116_0 = arg_116_1[i]

		arg_116_0._claimed_event_quests[var_116_0] = true
	end
end

PlayFabMirrorBase.get_achievement_rewards = function (self)
	-- function 117
	return self._achievement_rewards
end

PlayFabMirrorBase.get_weaves_progression_settings = function (self)
	-- function 118
	return self._weaves_progression_settings
end

PlayFabMirrorBase.get_unlocked_weapon_skins = function (self)
	-- function 119
	return self._unlocked_weapon_skins
end

PlayFabMirrorBase.get_unlocked_cosmetics = function (self)
	-- function 120
	return self._unlocked_cosmetics
end

PlayFabMirrorBase.get_unlocked_weapon_poses = function (self)
	-- function 121
	return self._unlocked_weapon_poses
end

PlayFabMirrorBase.get_equipped_weapon_pose_skins = function (self)
	-- function 122
	return self._equipped_weapon_pose_skins
end

PlayFabMirrorBase.get_equipped_weapon_pose_skin = function (self, arg_123_1)
	-- function 123
	return self._equipped_weapon_pose_skins[arg_123_1]
end

PlayFabMirrorBase.set_weapon_pose_skin = function (arg_124_0, arg_124_1, arg_124_2)
	-- function 124
	arg_124_0._equipped_weapon_pose_skins[arg_124_1] = arg_124_2
end

PlayFabMirrorBase.get_unlocked_keep_decorations = function (self)
	-- function 125
	return self._unlocked_keep_decorations
end

PlayFabMirrorBase.get_owned_dlcs = function (self)
	-- function 126
	return self._owned_dlcs
end

PlayFabMirrorBase.get_platform_dlcs = function (self)
	-- function 127
	return self._platform_dlcs
end

PlayFabMirrorBase.set_owned_dlcs = function (self, arg_128_1)
	-- function 128
	self._owned_dlcs = arg_128_1
end

PlayFabMirrorBase.set_platform_dlcs = function (self, arg_129_1)
	-- function 129
	self._platform_dlcs = arg_129_1
end

PlayFabMirrorBase.add_keep_decoration = function (arg_130_0, arg_130_1)
	-- function 130
	arg_130_0._unlocked_keep_decorations[#arg_130_0._unlocked_keep_decorations + 1] = arg_130_1

	ItemHelper.mark_keep_decoration_as_new(arg_130_1)
end

local tbl_3 = {}

PlayFabMirrorBase._create_fake_inventory_items = function (self, arg_131_1, arg_131_2)
	-- function 131
	table.clear(tbl_3)

	local var_131_0

	if arg_131_2 == "weapon_skins" then
		var_131_0 = self._unlocked_weapon_skins

		local WeaponSkins = WeaponSkins

		for k, v in pairs(arg_131_1) do
			local matching_weapon_skin_item_key, var_131_3 = WeaponSkins.matching_weapon_skin_item_key(k)

			if not matching_weapon_skin_item_key and not rawget(ItemMasterList, matching_weapon_skin_item_key) then
				if not (not var_131_3 and var_131_3 ~= "bogenhafen") then
					var_131_3 = "unique"
				end

				tbl_3[#tbl_3 + 1] = {
					ItemId = matching_weapon_skin_item_key,
					ItemInstanceId = type(v) ~= "string" or not v or uuid(),
					CustomData = {
						skin = k,
						rarity = var_131_3
					}
				}
			else
				var_131_0[k] = nil
			end
		end
	elseif arg_131_2 == "cosmetics" then
		var_131_0 = self._unlocked_cosmetics

		for k_2, v_2 in pairs(arg_131_1) do
			local var_131_4 = rawget(ItemMasterList, k_2)

			if not var_131_4 then
				local var_131_5 = var_131_0[k_2]
				local var_131_6
				local var_131_7

				if type(var_131_5) == "string" then
					var_131_6 = var_131_5
				elseif type(v_2) == "string" then
					var_131_6 = v_2

					if var_131_4.steam_itemdefid ~= nil then
						var_131_7 = var_131_6
					end
				else
					var_131_6 = uuid()
				end

				tbl_3[#tbl_3 + 1] = {
					ItemId = k_2,
					ItemInstanceId = var_131_6,
					override_id = var_131_7
				}
			else
				var_131_0[k_2] = nil
			end
		end
	elseif arg_131_2 == "weapon_poses" then
		var_131_0 = self._unlocked_weapon_poses

		for k_3, v_3 in pairs(arg_131_1) do
			for k_4, v_4 in pairs(v_3) do
				local var_131_8 = rawget(ItemMasterList, k_4)

				if not var_131_8 then
					local parent = var_131_8.parent
					local var_131_10 = var_131_0[parent]

					var_131_10 = not var_131_10 and var_131_0[parent][k_4]

					local var_131_11

					if type(var_131_10) == "string" then
						var_131_11 = var_131_10
					else
						var_131_11 = uuid()
					end

					tbl_3[#tbl_3 + 1] = {
						ItemId = k_4,
						ItemInstanceId = var_131_11
					}
				else
					var_131_0[var_131_0] = nil
				end
			end
		end
	else
		fassert(false, "Invalid items_typs: %q", arg_131_2)
	end

	if not self._inventory_items then
		self._inventory_items = {}
	end

	local tbl = {}

	for i8 = 1, #tbl_3 do
		local var_131_13 = tbl_3[i8]
		local ItemInstanceId = var_131_13.ItemInstanceId
		local override_id = var_131_13.override_id

		if not override_id then
			if not var_131_13.CustomData then
				override_id = var_131_13.CustomData.skin

				if not override_id then
					-- Nothing
				end
			end

			override_id = var_131_13.ItemId
		end

		::label_131_0::

		if arg_131_2 == "weapon_poses" then
			local ItemId = var_131_13.ItemId

			var_131_0[ItemMasterList[ItemId].parent][ItemId] = ItemInstanceId
		else
			var_131_0[override_id] = ItemInstanceId
		end

		self:_update_data(var_131_13, ItemInstanceId)

		self._inventory_items[ItemInstanceId] = var_131_13
		self._fake_inventory_items[ItemInstanceId] = var_131_13
		tbl[#tbl + 1] = ItemInstanceId
	end

	return tbl
end

PlayFabMirrorBase.set_achievement_claimed = function (arg_132_0, arg_132_1)
	-- function 132
	arg_132_0._claimed_achievements[arg_132_1] = true
end

PlayFabMirrorBase.get_claimed_console_dlc_rewards = function (self)
	-- function 133
	return self._claimed_console_dlc_rewards
end

PlayFabMirrorBase.set_console_dlc_reward_claimed = function (self, arg_134_1, arg_134_2)
	-- function 134
	local _claimed_console_dlc_rewards = self._claimed_console_dlc_rewards
	local flag

	flag = not arg_134_2 and true and nil
	_claimed_console_dlc_rewards[arg_134_1] = flag
end

PlayFabMirrorBase.get_quest_data = function (self)
	-- function 135
	return self._quest_data
end

PlayFabMirrorBase.set_quest_data = function (arg_136_0, arg_136_1, arg_136_2)
	-- function 136
	arg_136_0._quest_data[arg_136_1] = arg_136_2
end

PlayFabMirrorBase.check_for_errors = function (arg_137_0)
	-- function 137
	return
end

local tbl_4 = {
	ranged = "best_ranged_pl",
	ring = "best_ring_pl",
	necklace = "best_necklace_pl",
	trinket = "best_trinket_pl",
	melee = "best_melee_pl"
}

PlayFabMirrorBase._re_evaluate_best_power_level = function (self, arg_138_1)
	-- function 138
	local power_level = arg_138_1.power_level

	if not power_level then
		return
	end

	local slot_type = arg_138_1.data.slot_type
	local var_138_2 = tbl_4[slot_type]

	if not var_138_2 then
		return
	end

	local _best_power_levels = self._best_power_levels

	if power_level > _best_power_levels[var_138_2] then
		_best_power_levels[var_138_2] = power_level

		local num = 0

		for k, v in pairs(_best_power_levels) do
			num = num + v
		end

		self.sum_best_power_levels = num
	end
end

PlayFabMirrorBase._add_new_weapon_skin = function (self, arg_139_1, arg_139_2, arg_139_3)
	-- function 139
	local var_139_0
	local flag = arg_139_3 or arg_139_1.ItemId

	if not (not not arg_139_2 or Managers.account:offline_mode()) then
		local add_unlocked_weapon_skin = self:add_unlocked_weapon_skin(flag, arg_139_1.ItemInstanceId)

		var_139_0 = not add_unlocked_weapon_skin and add_unlocked_weapon_skin[1]
	else
		local add_unlocked_weapon_skin_2 = self:add_unlocked_weapon_skin(flag)

		var_139_0 = not add_unlocked_weapon_skin_2 and add_unlocked_weapon_skin_2[1]
	end

	return var_139_0
end

PlayFabMirrorBase.add_item = function (self, arg_140_1, arg_140_2, arg_140_3, arg_140_4)
	-- function 140
	if not self._inventory_items then
		self._inventory_items = {}
	end

	if not WeaponSkins.skins[arg_140_2.ItemId] then
		return self:_add_new_weapon_skin(arg_140_2)
	else
		local var_140_0 = ItemMasterList[arg_140_2.ItemId]

		if not CosmeticUtils.is_cosmetic_item(var_140_0.slot_type) then
			arg_140_1 = self:add_unlocked_cosmetic(arg_140_2.ItemId, arg_140_1)

			if not arg_140_4 then
				ItemHelper.mark_backend_id_as_new(arg_140_1, self._inventory_items[arg_140_1], arg_140_3)
			end

			return arg_140_1
		end

		if not CosmeticUtils.is_weapon_pose(var_140_0) then
			arg_140_1 = self:add_unlocked_weapon_pose(arg_140_2.ItemId, arg_140_1)

			if not arg_140_4 then
				ItemHelper.mark_backend_id_as_new(arg_140_1, self._inventory_items[arg_140_1], arg_140_3)
			end

			return arg_140_1
		end

		self._inventory_items[arg_140_1] = arg_140_2

		self:_update_data(arg_140_2, arg_140_1)

		if not arg_140_4 then
			ItemHelper.mark_backend_id_as_new(arg_140_1, arg_140_2, arg_140_3)
		end

		self:_re_evaluate_best_power_level(arg_140_2)
		ItemHelper.on_inventory_item_added(arg_140_2)

		local CustomData = arg_140_2.CustomData

		CustomData = not CustomData and arg_140_2.CustomData.skin

		if not CustomData and not WeaponSkins.skins[CustomData] then
			local get_unlocked_weapon_skins = self:get_unlocked_weapon_skins()

			self:_add_new_weapon_skin(arg_140_2, true, CustomData)
		end
	end
end

PlayFabMirrorBase.remove_item = function (self, arg_141_1)
	-- function 141
	local _inventory_items = self._inventory_items

	if not ItemHelper.is_new_backend_id(arg_141_1) then
		ItemHelper.unmark_backend_id_as_new(arg_141_1)
	end

	_inventory_items[arg_141_1] = nil
end

PlayFabMirrorBase.update_item_field = function (self, arg_142_1, arg_142_2, arg_142_3)
	-- function 142
	local var_142_0 = self._inventory_items[arg_142_1]

	fassert(var_142_0[arg_142_2], "Trying to update a field on an item in playfab_mirror_base.lua that does not exist on the item")

	var_142_0[arg_142_2] = arg_142_3
end

PlayFabMirrorBase.update_item = function (self, arg_143_1, arg_143_2)
	-- function 143
	local _inventory_items = self._inventory_items

	fassert(_inventory_items[arg_143_1], "Trying to update an item that does not exist with backend ID %s", arg_143_1)

	_inventory_items[arg_143_1] = arg_143_2

	self:_update_data(arg_143_2, arg_143_1)
end

PlayFabMirrorBase.add_unlocked_weapon_skin = function (self, arg_144_1, arg_144_2)
	-- function 144
	if not self._unlocked_weapon_skins then
		local var_144_0 = self._unlocked_weapon_skins[arg_144_1]

		if not var_144_0 then
			return {
				var_144_0
			}
		end

		self._unlocked_weapon_skins[arg_144_1] = true

		return self:_create_fake_inventory_items({
			[arg_144_1] = arg_144_2 or true
		}, "weapon_skins")
	else
		fn_2(false, "Tried to add_unlocked_weapon_skin '%s' before unlocked_weapon_skins was created", arg_144_1)
	end
end

PlayFabMirrorBase.add_unlocked_cosmetic = function (self, arg_145_1, arg_145_2)
	-- function 145
	if not self._unlocked_cosmetics then
		local _create_fake_inventory_items = self:_create_fake_inventory_items({
			[arg_145_1] = arg_145_2 or true
		}, "cosmetics")

		if #_create_fake_inventory_items > 0 then
			self._unlocked_cosmetics[arg_145_1] = _create_fake_inventory_items[1]

			return _create_fake_inventory_items[1]
		end
	else
		fn_2(false, "Tried to add_unlocked_cosmetics '%s' before unlocked_cosmetics was created", arg_145_1)
	end
end

PlayFabMirrorBase.add_unlocked_weapon_pose = function (self, arg_146_1, arg_146_2)
	-- function 146
	if not self._unlocked_weapon_poses then
		local _create_fake_inventory_items = self:_create_fake_inventory_items({
			[arg_146_1] = arg_146_2 or true
		}, "cosmetics")

		if #_create_fake_inventory_items > 0 then
			local parent = ItemMasterList[arg_146_1].parent
			local _unlocked_weapon_poses = self._unlocked_weapon_poses
			local var_146_3 = self._unlocked_weapon_poses[parent]

			var_146_3 = var_146_3 or {}
			_unlocked_weapon_poses[parent] = var_146_3
			self._unlocked_weapon_poses[parent][arg_146_1] = _create_fake_inventory_items[1]

			return _create_fake_inventory_items[1]
		end
	else
		fn_2(false, "Tried to add_unlocked_weapon_pose '%s' before unlocked_weapon_poses was created", arg_146_1)
	end
end

PlayFabMirrorBase.set_essence = function (self, arg_147_1)
	-- function 147
	self._essence = arg_147_1
end

PlayFabMirrorBase.get_essence = function (self)
	-- function 148
	return self._essence
end

PlayFabMirrorBase.set_total_essence = function (self, arg_149_1)
	-- function 149
	self._total_essence = arg_149_1
end

PlayFabMirrorBase.get_total_essence = function (self)
	-- function 150
	return self._total_essence
end

PlayFabMirrorBase.set_maximum_essence = function (self, arg_151_1)
	-- function 151
	self._maximum_essence = arg_151_1
end

PlayFabMirrorBase.get_maximum_essence = function (self)
	-- function 152
	return self._maximum_essence
end

PlayFabMirrorBase.get_deus_rolled_over_soft_currency = function (self)
	-- function 153
	local _deus_rolled_over_soft_currency = self._deus_rolled_over_soft_currency

	_deus_rolled_over_soft_currency = _deus_rolled_over_soft_currency or 0

	return _deus_rolled_over_soft_currency
end

PlayFabMirrorBase.get_deus_journey_cycle_data = function (self)
	-- function 154
	return self._deus_journey_cycle_data
end

PlayFabMirrorBase.get_deus_belakor_curse_data = function (self)
	-- function 155
	return self._deus_belakor_curse_data
end

PlayFabMirrorBase.handle_deus_result = function (self, arg_156_1)
	-- function 156
	local FunctionResult = arg_156_1.FunctionResult
	local deus_journey_cycle_data = FunctionResult.deus_journey_cycle_data
	local deus_rolled_over_soft_currency = FunctionResult.deus_rolled_over_soft_currency

	if not deus_rolled_over_soft_currency then
		self._deus_rolled_over_soft_currency = deus_rolled_over_soft_currency
	end

	if not deus_journey_cycle_data then
		local time = Managers.time:time("main")

		self._deus_journey_cycle_data = {
			span = deus_journey_cycle_data.span_ms / 1000,
			remaining_time = deus_journey_cycle_data.remaining_time_ms / 1000,
			cycle_count = deus_journey_cycle_data.cycle_count,
			time_of_update = time
		}
	end
end

PlayFabMirrorBase.predict_deus_rolled_over_soft_currency = function (self, arg_157_1)
	-- function 157
	local ceil = math.ceil(arg_157_1 * DeusRollOverSettings.roll_over)

	self._deus_rolled_over_soft_currency = math.clamp(ceil, 0, DeusRollOverSettings.max)
end

PlayFabMirrorBase.predict_deus_run_started = function (self)
	-- function 158
	self._deus_rolled_over_soft_currency = 0
end

PlayFabMirrorBase.predict_debug_clear_deus_meta_progression = function (self, arg_159_1)
	-- function 159
	self._deus_rolled_over_soft_currency = 0
end

local function fn_4(self, arg_160_1)
	-- function 160
	if not arg_160_1 then
		return
	end

	local commit_complete_callbacks = self.commit_complete_callbacks

	commit_complete_callbacks = commit_complete_callbacks or {}
	self.commit_complete_callbacks = commit_complete_callbacks
	self.commit_complete_callbacks[#self.commit_complete_callbacks + 1] = arg_160_1

	return self.commit_complete_callbacks
end

PlayFabMirrorBase.commit = function (self, arg_161_1, arg_161_2)
	-- function 161
	local _queued_commit = self._queued_commit
	local var_161_1

	if not arg_161_1 then
		if not self._commit_current_id then
			fn("Unable to skip queue: commit already in progress")

			var_161_1 = self:_queue_commit(arg_161_2)
		elseif not (not rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized()) then
			fn("Unable to skip queue: Network not initialized")

			var_161_1 = self:_queue_commit(arg_161_2)
		elseif not _queued_commit.active then
			local id = _queued_commit.id

			fn("Force commit: Override existing queue %q", id)
			fn_4(_queued_commit, arg_161_2)
			self:_commit_internal(id, _queued_commit.commit_complete_callbacks)
		else
			fn("Force commit")
			fn_4(_queued_commit, arg_161_2)

			var_161_1 = self:_commit_internal(nil, _queued_commit.commit_complete_callbacks)
		end
	elseif not _queued_commit.active then
		if not arg_161_2 then
			fn_4(_queued_commit, arg_161_2)
		end

		var_161_1 = self:_queue_commit(arg_161_2, _queued_commit.commit_complete_callbacks)
	elseif not arg_161_2 then
		fn_4(_queued_commit, arg_161_2)
	end

	if not var_161_1 then
		self._commit_limit_total = self._commit_limit_total + 1
	end

	return var_161_1 or _queued_commit.id
end

PlayFabMirrorBase._new_id = function (self)
	-- function 162
	self._last_id = self._last_id + 1

	return self._last_id
end

PlayFabMirrorBase._queue_commit = function (self, arg_163_1)
	-- function 163
	local _queued_commit = self._queued_commit
	local _new_id

	_queued_commit.timer, _new_id = self._commit_limit_total * num_2, self:_new_id()
	_queued_commit.id = _new_id
	_queued_commit.active = true

	fn_4(_queued_commit, arg_163_1)

	return _new_id
end

local num_3 = 25000

local function fn_5(self)
	-- function 164
	local num = 0
	local var_164_1

	for k, v in pairs(self) do
		local count = #cjson.encode(v)

		assert(count <= num_3, "Exceeding max size")

		if num + count > num_3 then
			var_164_1 = var_164_1 or {}
			var_164_1[k] = v
			self[k] = nil
		else
			num = num + count
		end
	end

	return self, var_164_1
end

local tbl_5 = {}

PlayFabMirrorBase._commit_internal = function (self, arg_165_1, arg_165_2)
	-- function 165
	fn("_commit_internal %q", arg_165_1)

	local flag = arg_165_1 or self:_new_id()
	local tbl = {
		num_updates = 0,
		status = "success",
		updates_to_make = 0,
		commit_complete_callbacks = arg_165_2,
		request_queue_ids = {},
		current_characters_data_key = self._characters_data_key
	}

	table.clear(self._queued_commit)

	self._commit_current_id = flag

	local get_interface = Managers.backend:get_interface("statistics")

	if not Managers.level_transition_handler:in_hub_level() then
		get_interface:save()
	end

	local get_stat_save_request, var_165_4 = get_interface:get_stat_save_request()

	if not (not get_stat_save_request and GameSettingsDevelopment.read_only_backend) then
		local var_165_5 = callback(self, "save_statistics_cb", flag, var_165_4)
		local enqueue = self._request_queue:enqueue(get_stat_save_request, var_165_5, true)

		self._num_items_to_load = self._num_items_to_load + 1

		get_interface:clear_saved_stats()

		tbl.status = "waiting"
		tbl.wait_for_stats = true
		tbl.request_queue_ids[#tbl.request_queue_ids + 1] = enqueue
	end

	if not GameSettingsDevelopment.read_only_backend then
		local get_dirty_user_data = Managers.backend:get_interface("weaves"):get_dirty_user_data()

		if not get_dirty_user_data then
			local tbl_2 = {
				FunctionName = "updateWeaveUserData",
				FunctionParameter = get_dirty_user_data
			}
			local enqueue_2 = self._request_queue:enqueue(tbl_2, callback(self, "update_weave_user_data_cb", flag), true)

			self._num_items_to_load = self._num_items_to_load + 1
			tbl.status = "waiting"
			tbl.wait_for_weave_user_data = true
			tbl.request_queue_ids[#tbl.request_queue_ids + 1] = enqueue_2
		end
	end

	if not GameSettingsDevelopment.read_only_backend then
		local get_dirty_weapon_pose_data = Managers.backend:get_interface("items"):get_dirty_weapon_pose_data()

		if not table.is_empty(get_dirty_weapon_pose_data.equipped_weapon_pose_skin) then
			local tbl_3 = {
				FunctionName = "updateEquippedWeaponPoseSkins",
				FunctionParameter = get_dirty_weapon_pose_data
			}
			local enqueue_3 = self._request_queue:enqueue(tbl_3, callback(self, "update_equipped_weapon_pose_skins_cb", flag), true)

			self._num_items_to_load = self._num_items_to_load + 1
			tbl.status = "waiting"
			tbl.wait_for_weapon_pose_skin_data = true
			tbl.request_queue_ids[#tbl.request_queue_ids + 1] = enqueue_3
		end
	end

	table.clear(tbl_5)

	local _read_only_data_mirror = self._read_only_data_mirror
	local get_keep_decorations_json = Managers.backend:get_interface("keep_decorations"):get_keep_decorations_json()

	if get_keep_decorations_json ~= _read_only_data_mirror.keep_decorations then
		tbl_5.keep_decorations = get_keep_decorations_json
	end

	local _check_career_data, var_165_16, var_165_17 = self:_check_career_data(self._career_data, self._career_data_mirror)
	local var_165_18

	if not _check_career_data then
		local var_165_19, var_165_20 = fn_5(var_165_17)

		tbl_5[self._characters_data_key] = cjson.encode(var_165_19)
		var_165_18 = var_165_20
	end

	if not table.is_empty(tbl_5) then
		local tbl_4 = {
			FunctionName = "updateHeroAttributes",
			FunctionParameter = {
				hero_attributes = tbl_5
			}
		}
		local var_165_22 = callback(self, "update_read_only_data_request_cb", flag, var_165_18)
		local enqueue_4 = self._request_queue:enqueue(tbl_4, var_165_22, false)

		self._num_items_to_load = self._num_items_to_load + 1
		tbl.status = "waiting"
		tbl.wait_for_read_only_data = true
		tbl.request_queue_ids[#tbl.request_queue_ids + 1] = enqueue_4
	end

	self:_commit_user_data(tbl_5, tbl, flag)

	self._commits[flag] = tbl

	return flag
end

PlayFabMirrorBase.update_current_win_track_cb = function (self, arg_166_1, arg_166_2)
	-- function 166
	self._num_items_to_load = self._num_items_to_load - 1

	local var_166_0 = self._commits[arg_166_1]
	local new_read_only_data = arg_166_2.FunctionResult.new_read_only_data

	for k, v in pairs(new_read_only_data) do
		local encode = cjson.encode(v)

		self:set_read_only_data(k, encode, true)
	end

	var_166_0.wait_for_win_tracks_data = false
end

PlayFabMirrorBase.update_current_gotwf_cb = function (self, arg_167_1, arg_167_2)
	-- function 167
	self._num_items_to_load = self._num_items_to_load - 1

	local var_167_0 = self._commits[arg_167_1]
	local new_read_only_data = arg_167_2.FunctionResult.new_read_only_data

	for k, v in pairs(new_read_only_data) do
		local encode = cjson.encode(v)

		self:set_read_only_data(k, encode, true)
	end

	var_167_0.wait_for_gotwf_data = false
end

PlayFabMirrorBase.update_read_only_data_request_cb = function (self, arg_168_1, arg_168_2, arg_168_3)
	-- function 168
	self._num_items_to_load = self._num_items_to_load - 1

	local var_168_0 = self._commits[arg_168_1]
	local hero_attributes = arg_168_3.FunctionResult.hero_attributes

	if var_168_0.current_characters_data_key ~= self._characters_data_key then
		Crashify.print_exception("PlayFabMirrorBase", "characters_data_key is not the same as when the request was sent. previous: %s, current: %s", var_168_0.current_characters_data_key, self._characters_data_key)

		return
	end

	for k, v in pairs(hero_attributes) do
		local var_168_2 = tonumber(v)

		self:set_read_only_data(k, var_168_2 or v, true)
	end

	local var_168_3 = hero_attributes[self._characters_data_key]

	if not var_168_3 then
		self._characters_data_mirror = cjson.decode(var_168_3)

		for k_2, v_2 in pairs(self._characters_data_mirror) do
			table.merge_recursive(self._career_data_mirror, v_2.careers)

			for k_3, v_3 in pairs(v_2.careers) do
				local var_168_4 = self._career_data_mirror[k_3]
				local var_168_5 = v_2.careers[k_3]

				if #var_168_5 < #var_168_4 then
					for i6 = #var_168_4, 1, -1 do
						if not var_168_5[i6] then
							self._career_data_mirror[k_3][i6] = nil
						end
					end
				end
			end
		end
	end

	if not arg_168_2 then
		local var_168_6, var_168_7 = fn_5(arg_168_2)
		local tbl = {
			[self._characters_data_key] = cjson.encode(var_168_6)
		}

		arg_168_2 = var_168_7

		local tbl_2 = {
			FunctionName = "updateHeroAttributes",
			FunctionParameter = {
				hero_attributes = tbl
			}
		}
		local var_168_10 = callback(self, "update_read_only_data_request_cb", arg_168_1, arg_168_2)
		local enqueue = self._request_queue:enqueue(tbl_2, var_168_10, false)

		self._num_items_to_load = self._num_items_to_load + 1
		var_168_0.status = "waiting"
		var_168_0.request_queue_ids[#var_168_0.request_queue_ids + 1] = enqueue
	else
		var_168_0.wait_for_read_only_data = false
	end
end

PlayFabMirrorBase.save_statistics_cb = function (self, arg_169_1, arg_169_2, arg_169_3)
	-- function 169
	self._num_items_to_load = self._num_items_to_load - 1

	local var_169_0 = self._commits[arg_169_1]
	local get_interface = Managers.backend:get_interface("statistics")

	if not arg_169_2 then
		get_interface:clear_dirty_flags(arg_169_2)
	end

	local FunctionResult = arg_169_3.FunctionResult
	local flag = not FunctionResult and FunctionResult.achievement_reward_levels

	if not flag then
		self:set_read_only_data("achievement_reward_levels", flag, true)
	end

	var_169_0.wait_for_stats = false
end

PlayFabMirrorBase.update_weave_user_data_cb = function (self, arg_170_1, arg_170_2)
	-- function 170
	self._num_items_to_load = self._num_items_to_load - 1

	local var_170_0 = self._commits[arg_170_1]

	var_170_0.wait_for_weave_user_data = false

	if var_170_0.current_characters_data_key ~= self._characters_data_key then
		Crashify.print_exception("PlayFabMirrorBase", "characters_data_key is not the same as when the request was sent. previous: %s, current: %s", var_170_0.current_characters_data_key, self._characters_data_key)
	end

	Managers.backend:get_interface("weaves"):clear_dirty_user_data()

	local new_read_only_data = arg_170_2.FunctionResult.new_read_only_data

	if not new_read_only_data then
		for k, v in pairs(new_read_only_data) do
			self:set_read_only_data(k, v, true)
		end
	end
end

PlayFabMirrorBase.update_equipped_weapon_pose_skins_cb = function (self, arg_171_1, arg_171_2)
	-- function 171
	self._num_items_to_load = self._num_items_to_load - 1
	self._commits[arg_171_1].wait_for_weapon_pose_skin_data = false

	Managers.backend:get_interface("items"):clear_dirty_weapon_pose_data()

	local equipped_weapon_pose_skins = arg_171_2.FunctionResult.equipped_weapon_pose_skins

	if not equipped_weapon_pose_skins then
		self:set_read_only_data("equipped_weapon_pose_skins", cjson.encode(equipped_weapon_pose_skins), true)
	end

	self:_parse_equipped_weapon_pose_skins()
end

PlayFabMirrorBase.save_keep_decorations_cb = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3)
	-- function 172
	arg_172_0._commits[arg_172_1].wait_for_keep_decorations = false
end

PlayFabMirrorBase.wait_for_shutdown = function (arg_173_0, arg_173_1)
	-- function 173
	return
end

PlayFabMirrorBase.destroy = function (arg_174_0)
	-- function 174
	return
end

PlayFabMirrorBase._get_eac_response = function (arg_175_0, arg_175_1)
	-- function 175
	local num = 0
	local str = ""

	while not arg_175_1[tostring(num)] do
		str = str .. string.char(arg_175_1[tostring(num)])
		num = num + 1
	end

	local challenge_response = Managers.eac:challenge_response(str)
	local var_175_3

	if not challenge_response then
		local num_2 = 1

		var_175_3 = {}

		while not string.byte(challenge_response, num_2, num_2) do
			local byte = string.byte(challenge_response, num_2, num_2)

			var_175_3[tostring(num_2 - 1)] = byte
			num_2 = num_2 + 1
		end
	end

	return challenge_response, var_175_3
end

PlayFabMirrorBase._verify_dlc_careers = function (self)
	-- function 176
	local tbl = {
		FunctionName = "verifyDlcCareers",
		FunctionParameter = {}
	}
	local var_176_1 = callback(self, "verify_dlc_careers_cb")

	self._request_queue:enqueue(tbl, var_176_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.verify_dlc_careers_cb = function (self, arg_177_1)
	-- function 177
	local FunctionResult = arg_177_1.FunctionResult

	if not FunctionResult.careers_added then
		local data = FunctionResult.data

		self:merge_read_only_data(data, true)
	end

	self._num_items_to_load = self._num_items_to_load - 1

	self:_setup_careers()
end

PlayFabMirrorBase._setup_careers = function (self)
	-- function 178
	local get_read_only_data = self:get_read_only_data(self._characters_data_key)
	local decode = cjson.decode(get_read_only_data)

	self._career_data = {}
	self._career_data_mirror = {}
	self._career_loadouts = {}
	self._career_lookup = {}

	local tbl = {}
	local var_178_3
	local tbl_2 = {
		talents = true
	}
	local tbl_3 = {}

	for k, v in pairs(decode) do
		local var_178_6 = FindProfileIndex(k)

		if not var_178_6 then
			local var_178_7 = SPProfiles[var_178_6]
			local var_178_8 = tbl_3[var_178_7.affiliation]

			if var_178_8 or not self._verify_slot_keys_per_affiliation[var_178_7.affiliation] then
				local clone = table.clone(self._verify_slot_keys_per_affiliation[var_178_7.affiliation])

				for k_2 = #clone, 1, -1 do
					if not tbl_2[clone[k_2]] then
						table.remove(clone, k_2)
					end
				end

				tbl_3[var_178_7.affiliation] = clone
				var_178_8 = clone
			end

			if not var_178_8 then
				local loadouts = v.loadouts

				for k_3, v_2 in pairs(v.careers) do
					if not CareerSettings[k_3] then
						self._career_data[k_3] = {}
						self._career_data_mirror[k_3] = {}

						local index = PROFILES_BY_CAREER_NAMES[k_3].index
						local var_178_12 = career_index_from_name(index, k_3)
						local _career_loadouts = self._career_loadouts
						local var_178_14

						if not loadouts then
							var_178_14 = loadouts[var_178_12]

							if not var_178_14 then
								-- Nothing
							end
						end

						var_178_14 = 1

						::label_178_0::

						_career_loadouts[k_3] = var_178_14

						local _set_inital_career_data = self:_set_inital_career_data(k_3, v_2, var_178_8)

						if not _set_inital_career_data then
							tbl[k_3] = _set_inital_career_data

							fn("Broken item slots for career: %q", k_3)
							table.dump(_set_inital_career_data, "BROKEN_SLOTS", 2)
						end
					end
				end
			end
		end
	end

	if not table.is_empty(tbl) then
		rawset(_G, "debug_characters_data_unsafe_write", nil)

		self._characters_data = decode
		self._characters_data_mirror = table.clone(decode)

		if not DEDICATED_SERVER then
			self:unequip_disabled_items()
		else
			self:_verify_default_gear()
		end
	else
		self:_fix_career_data(tbl)
	end
end

PlayFabMirrorBase._verify_default_gear = function (self)
	-- function 179
	local tbl = {
		FunctionName = "verifyDefaultLoadouts",
		FunctionParameter = {
			slots_to_verify = self._verify_slot_keys_per_affiliation.heroes
		}
	}
	local var_179_1 = callback(self, "verify_default_loadouts_request_cb")

	self._request_queue:enqueue(tbl, var_179_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.verify_default_loadouts_request_cb = function (self, arg_180_1)
	-- function 180
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_180_1.FunctionResult
	local character_default_loadouts = FunctionResult.character_default_loadouts
	local vs_character_default_loadouts = FunctionResult.vs_character_default_loadouts

	if not character_default_loadouts then
		self:set_read_only_data("character_default_loadouts", cjson.encode(character_default_loadouts), true)
	end

	if not vs_character_default_loadouts then
		self:set_read_only_data("vs_character_default_loadouts", cjson.encode(vs_character_default_loadouts), true)
	end

	self._character_default_loadouts = {}
	self._character_default_loadouts.adventure = character_default_loadouts
	self._character_default_loadouts.versus = vs_character_default_loadouts

	if Managers.mechanism:current_mechanism_name() == "adventure" then
		self:_check_weaves_loadout()
	else
		self:unequip_disabled_items()
	end
end

PlayFabMirrorBase._fix_career_data = function (self, arg_181_1, arg_181_2, arg_181_3)
	-- function 181
	local tbl = {
		FunctionName = "fixCareerData",
		FunctionParameter = {
			broken_slots = arg_181_1,
			mechanism = not arg_181_2 and arg_181_2 and Managers.mechanism:current_mechanism_name()
		}
	}
	local var_181_1 = callback(self, arg_181_3 or "fix_career_data_request_cb")

	self._request_queue:enqueue(tbl, var_181_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorBase.fix_career_data_request_cb = function (self, arg_182_1)
	-- function 182
	self.broken_slots_data = nil
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_182_1.FunctionResult
	local character_starting_gear = FunctionResult.character_starting_gear
	local _career_data = self._career_data
	local _career_data_mirror = self._career_data_mirror

	self._characters_data = character_starting_gear
	self._characters_data_mirror = table.clone(character_starting_gear)

	for k, v in pairs(character_starting_gear) do
		local var_182_4 = self._characters_data_mirror[k]
		local careers = v.careers
		local flag = not var_182_4 and var_182_4.careers

		table.merge_recursive(_career_data, careers)
		table.merge_recursive(_career_data_mirror, flag)
	end

	self:set_read_only_data(self._characters_data_key, cjson.encode(character_starting_gear), true)

	if FunctionResult.num_items_granted > 0 then
		local unlocked_weapon_skins = FunctionResult.unlocked_weapon_skins

		if not unlocked_weapon_skins then
			self:set_read_only_data("unlocked_weapon_skins", unlocked_weapon_skins, true)

			self._unlocked_weapon_skins = self:_parse_unlocked_weapon_skins()
		end

		local unlocked_cosmetics = FunctionResult.unlocked_cosmetics

		if not unlocked_cosmetics then
			self:set_read_only_data("unlocked_cosmetics", unlocked_cosmetics, true)

			self._unlocked_cosmetics = self:_parse_unlocked_cosmetics()
		end

		local unlocked_weapon_poses = FunctionResult.unlocked_weapon_poses

		if not unlocked_weapon_poses then
			self:set_read_only_data("unlocked_weapon_poses", unlocked_weapon_poses, true)

			self._unlocked_weapon_poses = self:_parse_unlocked_weapon_poses()
		end

		self:_request_user_inventory()
	else
		self:_verify_default_gear()
	end
end

PlayFabMirrorBase.unequip_disabled_items = function (self)
	-- function 183
	local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_item_availability")

	if not mechanism_setting_for_title and not table.is_empty(mechanism_setting_for_title) then
		return
	end

	local PROFILES_BY_CAREER_NAMES = PROFILES_BY_CAREER_NAMES
	local _inventory_items = self._inventory_items
	local contains = table.contains
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	current_mechanism_name = current_mechanism_name ~= "versus" or not current_mechanism_name or nil

	for k, v in pairs(self._career_data) do
		local var_183_5 = PROFILES_BY_CAREER_NAMES[k]

		if not var_183_5 then
			local var_183_6 = self._verify_slot_keys_per_affiliation[var_183_5.affiliation]

			if not var_183_6 then
				local var_183_7 = CareerSettings[k]

				for k_2, v_2 in pairs(v) do
					if not contains(var_183_6, k_2) then
						local var_183_8 = _inventory_items[v_2]

						if not (not var_183_8 and mechanism_setting_for_title[var_183_8.ItemId] ~= false) then
							local _find_valid_item_for_slot = self:_find_valid_item_for_slot(mechanism_setting_for_title, var_183_7, k_2, k, current_mechanism_name)

							if not _find_valid_item_for_slot then
								self:set_character_data(k, k_2, _find_valid_item_for_slot, true)
							end
						end
					end
				end
			end
		end
	end
end

PlayFabMirrorBase._find_valid_item_for_slot = function (self, arg_184_1, arg_184_2, arg_184_3, arg_184_4, arg_184_5)
	-- function 184
	local ItemMasterList = ItemMasterList
	local contains = table.contains
	local tbl = {}

	for k, v in pairs(self._inventory_items) do
		if arg_184_1[v.ItemId] ~= false then
			local var_184_3 = ItemMasterList[v.ItemId]
			local var_184_4 = contains(arg_184_2.item_slot_types_by_slot_name[arg_184_3], var_184_3.slot_type)
			local can_wield = var_184_3.can_wield

			if not var_184_4 and not can_wield and not contains(can_wield, arg_184_4) then
				local var_184_8

				if not arg_184_5 then
					local var_184_6 = contains
					local mechanisms = var_184_3.mechanisms

					mechanisms = mechanisms or tbl
					var_184_8 = var_184_6(mechanisms, arg_184_5)

					if false then
						var_184_8 = false
					end
				else
					var_184_8 = true
				end

				if not var_184_8 then
					return k, v
				end
			end
		end
	end
end

PlayFabMirrorBase._check_career_data = function (self, arg_185_1, arg_185_2)
	-- function 185
	local _characters_data = self._characters_data
	local _characters_data_mirror = self._characters_data_mirror
	local flag = false
	local tbl = {}
	local tbl_2 = {
		"careers",
		"loadouts",
		"experience",
		"experience_pool",
		"prestige"
	}

	for k, v in pairs(_characters_data) do
		local var_185_5 = _characters_data_mirror[k]

		if not var_185_5 then
			local flag_2 = not table.compare(v, var_185_5, tbl_2)

			flag_2 = flag_2 or table.size(v) ~= table.size(var_185_5)

			if not flag_2 then
				fn("[CheckCareerData] Found profile data changes: %s", k)

				flag = true

				local var_185_7 = tbl[k]

				var_185_7 = var_185_7 or {
					careers = {}
				}
				var_185_7.selected_career = v.career
				var_185_7.selected_bot_career = v.bot_career
				tbl[k] = var_185_7
			end
		end
	end

	for k_2, v_2 in pairs(_characters_data) do
		local loadouts = v_2.loadouts
		local var_185_9 = _characters_data_mirror[k_2]

		if not var_185_9 then
			local loadouts_2 = var_185_9.loadouts

			if not loadouts_2 then
				if not not table.compare(loadouts, loadouts_2) then
					fn("[CheckCareerData] Found selected loadout changes for profile: %s", k_2)

					flag = true

					local var_185_11 = tbl[k_2]

					var_185_11 = var_185_11 or {
						careers = {}
					}
					var_185_11.selected_loadouts = loadouts
					tbl[k_2] = var_185_11
				end
			else
				fn("[CheckCareerData] Missing selected loadout data for profile: %s", k_2)

				flag = true
			end
		else
			fn("[CheckCareerData] Missing profile data: %s", k_2)

			flag = true
		end
	end

	for k_3, v_3 in pairs(arg_185_1) do
		local var_185_12 = arg_185_2[k_3]
		local var_185_13 = PROFILES_BY_CAREER_NAMES[k_3]

		if not var_185_13 then
			local var_185_14 = self._verify_slot_keys_per_affiliation[var_185_13.affiliation]

			if not var_185_14 then
				for i6 = 1, #v_3 do
					local var_185_15 = v_3[i6]
					local var_185_16 = var_185_12[i6]

					if not var_185_16 then
						for k_4, v_4 in pairs(var_185_14) do
							local var_185_17 = var_185_15[v_4]

							if var_185_17 ~= var_185_16[v_4] then
								for k_5, v_5 in pairs(_characters_data) do
									if not v_5.careers[k_3] then
										local var_185_18 = v_5.careers[k_3][i6]

										if not var_185_18 then
											var_185_18[v_4] = var_185_17
										end

										break
									end
								end

								fn("[CheckCareerData] Found changes in loadout %d for career: %s in slot %s", i6, k_3, v_4)

								flag = true

								local var_185_19 = tbl[var_185_13.display_name]

								var_185_19 = var_185_19 or {
									careers = {}
								}

								local var_185_20 = var_185_19.careers[k_3]

								var_185_20 = var_185_20 or {
									loadouts = {},
									deleted_loadouts = {}
								}
								var_185_19.careers[k_3] = var_185_20
								var_185_20.loadouts[tostring(i6)] = var_185_15
								tbl[var_185_13.display_name] = var_185_19
							end
						end
					else
						fn("[CheckCareerData] Missing/new loadout for career: %s", k_3)

						flag = true

						local var_185_21 = tbl[var_185_13.display_name]

						var_185_21 = var_185_21 or {
							careers = {}
						}

						local var_185_22 = var_185_21.careers[k_3]

						var_185_22 = var_185_22 or {
							loadouts = {},
							deleted_loadouts = {}
						}
						var_185_21.careers[k_3] = var_185_22
						var_185_22.loadouts[tostring(i6)] = var_185_15
						tbl[var_185_13.display_name] = var_185_21
					end
				end
			else
				Application.warning(string.format("Missing slots to verify for %q", k_3))
			end
		end
	end

	for k_6, v_6 in pairs(arg_185_2) do
		local var_185_23 = arg_185_1[k_6]

		if not var_185_23 then
			local tbl_3 = {}
			local var_185_25

			local function fn_2(arg_186_0, arg_186_1)
				-- function 186
				local var_186_0 = tostring(arg_186_0)
				local var_186_1 = tbl_3[var_186_0]

				if not var_186_1 then
					fn("%s and %s share the same table address. Verify if these should be clones instead!", arg_186_1, var_186_1)
				else
					tbl_3[var_186_0] = arg_186_1
				end

				for k, v in pairs(arg_186_0) do
					if type(v) == "table" then
						fn_2(v, string.format("%s-%s", arg_186_1, k))
					end
				end
			end

			fn("[CheckCareerData] You will crash now. That's sad :(")
			table.dump(self._career_data, "PlayfabMirrorBase_career_data", 5)
			table.dump(self._career_data_mirror, "PlayfabMirrorBase._career_data_mirror", 5)
			table.dump(self._career_loadouts, "PlayfabMirrorBase._career_loadouts", 5)
			table.dump(self._career_lookup, "PlayfabMirrorBase._career_lookup", 5)
			table.dump(self._character_default_loadouts, "PlayfabMirrorBase._character_default_loadouts", 5)
			table.dump(self._characters_data, "PlayfabMirrorBase._characters_data", 5)
			table.dump(self._characters_data_mirror, "PlayfabMirrorBase._characters_data_mirror", 5)
			fn("PlayfabMirrorBase._read_only_data.characters_data: %s", self._read_only_data.characters_data)
			fn("PlayfabMirrorBase._read_only_data.vs_characters_data: %s", self._read_only_data.vs_characters_data)
			fn("PlayfabMirrorBase._read_only_data.character_default_loadouts: %s", self._read_only_data.character_default_loadouts)
			fn("PlayfabMirrorBase._read_only_data.vs_character_default_loadouts: %s", self._read_only_data.vs_character_default_loadouts)
			fn("PlayfabMirrorBase._read_only_data_mirror.characters_data: %s", self._read_only_data_mirror.characters_data)
			fn("PlayfabMirrorBase._read_only_data_mirror.vs_characters_data: %s", self._read_only_data_mirror.vs_characters_data)
			fn("PlayfabMirrorBase._read_only_data_mirror.character_default_loadouts: %s", self._read_only_data_mirror.character_default_loadouts)
			fn("PlayfabMirrorBase._read_only_data_mirror.vs_character_default_loadouts: %s", self._read_only_data_mirror.vs_character_default_loadouts)
			fn_2(self._career_data, "_career_data")
			fn_2(self._career_data_mirror, "_career_data_mirror")
			fn_2(self._career_loadouts, "_career_loadouts")
			fn_2(self._career_lookup, "_career_lookup")
			fn_2(self._character_default_loadouts, "_character_default_loadouts")
			fn_2(self._characters_data, "_characters_data")
			fn_2(self._characters_data_mirror, "_characters_data_mirror")
		end

		local var_185_27 = PROFILES_BY_CAREER_NAMES[k_6]

		if not var_185_27 then
			for i13 = 1, #v_6 do
				if not var_185_23[i13] then
					fn("[CheckCareerData] Missing/deleted loadout for career: %s", k_6)

					flag = true

					local var_185_28 = tbl[var_185_27.display_name]

					var_185_28 = var_185_28 or {
						careers = {}
					}

					local var_185_29 = var_185_28.careers[k_6]

					var_185_29 = var_185_29 or {
						loadouts = {},
						deleted_loadouts = {}
					}
					var_185_28.careers[k_6] = var_185_29
					var_185_29.deleted_loadouts[#var_185_29.deleted_loadouts + 1] = i13
					tbl[var_185_27.display_name] = var_185_28
				end
			end
		end
	end

	flag = flag or Managers.account:offline_mode()

	return flag, _characters_data, tbl
end

PlayFabMirrorBase.set_career_read_only_data = function (self, arg_187_1, arg_187_2, arg_187_3, arg_187_4, arg_187_5, arg_187_6)
	-- function 187
	local _characters_data = self._characters_data

	arg_187_6 = not arg_187_4 and arg_187_6 and self._career_loadouts[arg_187_4]

	local var_187_1

	if not arg_187_4 then
		var_187_1 = _characters_data[arg_187_1].careers[arg_187_4][arg_187_6]

		if not var_187_1 then
			-- Nothing
		end
	end

	var_187_1 = _characters_data[arg_187_1]

	::label_187_0::

	var_187_1[arg_187_2] = arg_187_3

	if not arg_187_5 then
		local _characters_data_mirror = self._characters_data_mirror
		local var_187_3

		if not arg_187_4 then
			var_187_3 = _characters_data_mirror[arg_187_1].careers[arg_187_4][arg_187_6]

			if not var_187_3 then
				-- Nothing
			end
		end

		var_187_3 = _characters_data_mirror[arg_187_1]

		::label_187_1::

		if type(arg_187_3) == "table" then
			var_187_3[arg_187_2] = table.clone(arg_187_3)
		else
			var_187_3[arg_187_2] = arg_187_3
		end
	end

	local encode = cjson.encode(_characters_data)

	self:set_read_only_data(self._characters_data_key, encode, arg_187_5)
end

PlayFabMirrorBase.get_characters_data = function (self)
	-- function 188
	return self._characters_data
end

PlayFabMirrorBase.update_owned_dlcs = function (self, arg_189_1)
	-- function 189
	if not IS_CONSOLE then
		return
	end

	local get_dlcs = Managers.unlock:get_dlcs()

	for k, v in pairs(get_dlcs) do
		if not v.set_owned then
			local contains = table.contains(self._owned_dlcs, k)

			v:set_owned(contains, arg_189_1)
		end
	end

	for k_2, v_2 in pairs(get_dlcs) do
		if not v_2.check_all_children_dlc_owned then
			v_2:check_all_children_dlc_owned()
		end
	end
end

PlayFabMirrorBase.handle_new_dlcs = function (arg_190_0, arg_190_1)
	-- function 190
	local SaveData = SaveData
	local new_dlcs_unlocks = SaveData.new_dlcs_unlocks

	new_dlcs_unlocks = new_dlcs_unlocks or {}
	SaveData.new_dlcs_unlocks = new_dlcs_unlocks

	if not arg_190_1 then
		for i = 1, #arg_190_1 do
			local var_190_2 = arg_190_1[i]

			if not SaveData.new_dlcs_unlocks[var_190_2] then
				SaveData.new_dlcs_unlocks[var_190_2] = true
			end
		end

		Managers.save:auto_save(SaveFileName, SaveData)
	end
end

PlayFabMirrorBase._snippet_clear_inventory = function (arg_191_0)
	-- function 191
	local function fn(arg_192_0)
		-- function 192
		local tbl = {
			slot_necklace = true,
			slot_hat = true,
			slot_trinket_1 = true,
			slot_skin = true,
			slot_frame = true,
			slot_melee = true,
			slot_ring = true,
			slot_ranged = true
		}
		local PROFILES_BY_CAREER_NAMES = PROFILES_BY_CAREER_NAMES
		local tbl_2 = {}

		for k, v in pairs(PROFILES_BY_CAREER_NAMES) do
			if v.affiliation == "heroes" then
				tbl_2[k] = tbl
			end
		end

		arg_191_0:_fix_career_data(tbl_2, "adventure")
	end

	arg_191_0._request_queue[#arg_191_0._request_queue + 1] = {
		eac_check = false,
		func = "devClearInventory",
		args = {
			exclude_types = {}
		},
		success_cb = fn
	}
end

PlayFabMirrorBase.snippet_clear_inventory = function (self)
	-- function 193
	self:_snippet_clear_inventory()
end

PlayFabMirrorBase.set_twitch_app_access_token = function (self, arg_194_1)
	-- function 194
	self._twitch_app_access_token = arg_194_1
end

PlayFabMirrorBase.get_power_level_settings = function (self)
	-- function 195
	return self._power_level_data
end

PlayFabMirrorBase.debug_override_power_level_settings = function (self, arg_196_1)
	-- function 196
	self._power_level_data = arg_196_1
end

PlayFabMirrorBase.get_rarity_tables = function (self)
	-- function 197
	return self._rarity_tables
end

PlayFabMirrorBase.get_formatted_rarity_tables = function (self)
	-- function 198
	return self._formatted_rarity_tables
end

PlayFabMirrorBase._generate_formatted_rarity_tables = function (self, arg_199_1)
	-- function 199
	self._formatted_rarity_tables = {}

	for k, v in pairs(arg_199_1) do
		self._formatted_rarity_tables[k] = {}

		local tbl = {}
		local num = 0
		local num_2 = 0

		for k_2, v_2 in pairs(v) do
			num_2 = num_2 + v_2

			local var_199_3
			local var_199_4

			if v_2 < 1 then
				var_199_3 = v_2
				var_199_4 = math.ceil(v_2)
			else
				var_199_3 = math.round(v_2)
				var_199_4 = var_199_3
			end

			self._formatted_rarity_tables[k][k_2] = var_199_3
			num = num + var_199_4
			tbl[#tbl + 1] = {
				key = k_2,
				chance = v_2,
				idx = #tbl + 1
			}
		end

		table.sort(tbl, function (self, arg_200_1)
			-- function 200
			return self.chance % 1 < arg_200_1.chance % 1
		end)

		if num > 100 then
			for i4 = 1, #tbl do
				local var_199_5 = tbl[i4]

				if not (not (var_199_5.chance > 1) or not (var_199_5.chance % 1 >= 0.5)) then
					self._formatted_rarity_tables[k][var_199_5.key] = self._formatted_rarity_tables[k][var_199_5.key] - 1
					num = num - 1

					if num == 100 then
						break
					end
				end
			end
		elseif num < 100 then
			for i5 = #tbl, 1, -1 do
				local var_199_6 = tbl[i5]

				if not (not (var_199_6.chance > 1) or not (var_199_6.chance % 1 < 0.5)) then
					self._formatted_rarity_tables[k][var_199_6.key] = self._formatted_rarity_tables[k][var_199_6.key] + 1
					num = num + 1

					if num == 100 then
						break
					end
				end
			end
		end
	end
end
