-- chunkname: @scripts/managers/backend_playfab/playfab_mirror_base.lua

require("scripts/managers/backend_playfab/playfab_request_queue")
require("scripts/helpers/weave_utils")

local var_0_0 = require("PlayFab.PlayFabClientApi")
local var_0_1 = {
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
local var_0_2 = {
	string = true,
	boolean = true,
	number = true
}
local var_0_3 = 80
local var_0_4 = 5
local var_0_5 = IS_PS4 and math.uuid or Application.guid

PlayFabMirrorBase = class(PlayFabMirrorBase)

local function var_0_6(arg_1_0, ...)
	printf("[PlayFabMirrorBase] " .. arg_1_0, ...)
end

local function var_0_7(arg_2_0, arg_2_1, ...)
	if not arg_2_0 then
		Crashify.print_exception("PlayFabMirrorBase", arg_2_1, ...)
	end
end

PlayFabMirrorBase.init = function (arg_3_0, arg_3_1)
	arg_3_0._num_items_to_load = 0
	arg_3_0._stats = {}
	arg_3_0._unlocked_dlcs = {}
	arg_3_0._commits = {}
	arg_3_0._commit_current_id = nil
	arg_3_0._last_id = 0
	arg_3_0._queued_commit = {}
	arg_3_0._request_queue = PlayFabRequestQueue:new()
	arg_3_0._quest_data = {}
	arg_3_0._fake_inventory_items = {}
	arg_3_0._unlocked_cosmetics = {}
	arg_3_0._unlocked_weapon_poses = {}
	arg_3_0._equipped_weapon_pose_skins = {}
	arg_3_0._filtered_data = arg_3_0:_init_filtered_data()
	arg_3_0._best_power_levels = nil
	arg_3_0.sum_best_power_levels = nil
	arg_3_0._belakor_data_loaded = false
	arg_3_0._playfab_id = arg_3_1.PlayFabId

	local var_3_0 = arg_3_1.InfoResultPayload
	local var_3_1 = var_3_0.UserReadOnlyData or {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		local var_3_3 = iter_3_1.Value
		local var_3_4 = type(var_3_3)

		var_0_7(var_0_2[var_3_4], "Tried to set initial read_only_data's '%s'. Got value '%s' ('%s')", iter_3_0, tostring(var_3_3), var_3_4)

		if tonumber(var_3_3) then
			var_3_3 = tonumber(var_3_3)
		elseif var_3_3 == "true" or var_3_3 == "false" then
			var_3_3 = to_boolean(var_3_3)
		end

		var_3_2[iter_3_0] = var_3_3
	end

	arg_3_0._read_only_data = var_3_2
	arg_3_0._read_only_data_mirror = table.clone(var_3_2)

	local var_3_5 = var_3_0.TitleData or {}

	arg_3_0._title_data = {}

	for iter_3_2, iter_3_3 in pairs(var_3_5) do
		arg_3_0:set_title_data(iter_3_2, iter_3_3)
	end

	local var_3_6 = var_3_0.UserData or {}
	local var_3_7 = {}

	for iter_3_4, iter_3_5 in pairs(var_3_6) do
		local var_3_8 = iter_3_5.Value

		if var_3_8 then
			if tonumber(var_3_8) then
				var_3_8 = tonumber(var_3_8)
			elseif var_3_8 == "true" or var_3_8 == "false" then
				var_3_8 = to_boolean(var_3_8)
			end

			var_3_7[iter_3_4] = var_3_8
		end
	end

	arg_3_0._user_data = var_3_7
	arg_3_0._user_data_mirror = table.clone(arg_3_0._user_data)
	arg_3_0._commit_limit_timer = var_0_3
	arg_3_0._commit_limit_total = 1

	arg_3_0:_verify_account_data()
end

PlayFabMirrorBase._init_filtered_data = function (arg_4_0)
	local var_4_0 = {}

	for iter_4_0 in pairs(Managers.unlock:get_dlcs()) do
		var_4_0[iter_4_0] = {}
	end

	return var_4_0
end

PlayFabMirrorBase._register_dlc_filtered_data = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0._filtered_data[arg_5_1][arg_5_2] = arg_5_3 or true
end

PlayFabMirrorBase._grant_filtered_data = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._filtered_data[arg_6_1]

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1 == true then
			iter_6_1 = nil
		end

		var_6_0[iter_6_0] = nil

		local var_6_1 = not table.is_empty(var_6_0)

		arg_6_0:add_item(iter_6_1, iter_6_0, var_6_1)
	end

	table.clear(arg_6_0._filtered_data[arg_6_1])
end

PlayFabMirrorBase._parse_claimed_achievements = function (arg_7_0)
	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = arg_7_0:get_read_only_data("claimed_achievements")

	if var_7_2 then
		var_7_0 = string.split_deprecated(var_7_2, ",")
	end

	for iter_7_0 = 1, #var_7_0 do
		var_7_1[var_7_0[iter_7_0]] = true
	end

	return var_7_1
end

PlayFabMirrorBase._parse_claimed_event_quests = function (arg_8_0)
	local var_8_0 = {}
	local var_8_1 = arg_8_0:get_read_only_data("claimed_event_quests")

	if var_8_1 then
		local var_8_2 = string.split_deprecated(var_8_1, ",")

		for iter_8_0 = 1, #var_8_2 do
			var_8_0[var_8_2[iter_8_0]] = true
		end
	end

	return var_8_0
end

PlayFabMirrorBase._parse_unlocked_weapon_skins = function (arg_9_0)
	local var_9_0 = {}
	local var_9_1 = arg_9_0:get_read_only_data("unlocked_weapon_skins")
	local var_9_2 = Managers.unlock
	local var_9_3 = arg_9_0._unlocked_weapon_skins or {}

	if var_9_1 then
		local var_9_4 = cjson.decode(var_9_1)

		if var_9_4 then
			for iter_9_0 = 1, #var_9_4 do
				local var_9_5 = var_9_4[iter_9_0]
				local var_9_6 = rawget(ItemMasterList, var_9_5)
				local var_9_7 = var_9_6 and var_9_6.required_dlc

				if not var_9_7 then
					var_9_0[var_9_5] = var_9_3[var_9_5] or true
				elseif not var_9_2:dlc_exists(var_9_7) then
					var_0_7(false, "Tried to check if unexisting DLC was unlocked %s", var_9_7)

					var_9_0[var_9_5] = true
				elseif var_9_2:is_dlc_unlocked(var_9_7) then
					var_9_0[var_9_5] = true
				else
					arg_9_0:_register_dlc_filtered_data(var_9_7, {
						ItemId = var_9_5
					}, var_9_3[var_9_5])
				end
			end
		else
			var_0_7(false, "Failed to decode unlocked_weapon_skins_string %s", var_9_1)
		end
	end

	return var_9_0
end

PlayFabMirrorBase._parse_unlocked_weapon_poses = function (arg_10_0)
	local var_10_0 = {}
	local var_10_1 = arg_10_0:get_read_only_data("unlocked_weapon_poses")
	local var_10_2 = Managers.unlock
	local var_10_3 = arg_10_0._unlocked_weapon_poses or {}

	if var_10_1 then
		local var_10_4 = cjson.decode(var_10_1)

		if var_10_4 then
			for iter_10_0, iter_10_1 in ipairs(var_10_4) do
				local var_10_5 = rawget(ItemMasterList, iter_10_1)
				local var_10_6 = var_10_5 and var_10_5.required_dlc
				local var_10_7 = var_10_5.parent

				if not var_10_5 then
					var_0_7(false, "%q doesn't exist in the ItemMasterList", iter_10_1)
				elseif not var_10_7 then
					var_0_7(false, "%q doesn't have a prent", iter_10_1)
				elseif not var_10_6 then
					var_10_0[var_10_7] = var_10_0[var_10_7] or {}
					var_10_0[var_10_7][iter_10_1] = true
				elseif not var_10_2:dlc_exists(var_10_6) then
					var_0_7(false, "Tried to check if unexisting DLC was unlocked %s", var_10_6)

					var_10_0[var_10_7] = var_10_0[var_10_7] or {}
					var_10_0[var_10_7][iter_10_1] = true
				elseif var_10_2:is_dlc_unlocked(var_10_6) then
					var_10_0[var_10_7] = var_10_0[var_10_7] or {}
					var_10_0[var_10_7][iter_10_1] = true
				else
					arg_10_0:_register_dlc_filtered_data(var_10_6, {
						ItemId = iter_10_1
					}, var_10_3[var_10_7] and var_10_3[var_10_7][iter_10_1])
				end
			end
		else
			var_0_7(false, "Failed to decode unlocked_weapon_poses_string %s", var_10_1)
		end
	end

	return var_10_0
end

PlayFabMirrorBase._parse_equipped_weapon_pose_skins = function (arg_11_0)
	local var_11_0 = {}
	local var_11_1 = arg_11_0:get_read_only_data("equipped_weapon_pose_skins")

	if not arg_11_0._equipped_weapon_pose_skins then
		local var_11_2 = {}
	end

	if var_11_1 then
		local var_11_3 = cjson.decode(var_11_1)

		if var_11_3 then
			var_11_0 = var_11_3
		else
			var_0_7(false, "Failed to decode equipped_weapon_pose_skins_string %s", var_11_1)
		end
	end

	return var_11_0
end

PlayFabMirrorBase._parse_unlocked_cosmetics = function (arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or arg_12_0:get_read_only_data("unlocked_cosmetics")

	local var_12_0 = {}
	local var_12_1 = Managers.unlock
	local var_12_2 = arg_12_0._unlocked_cosmetics or {}

	if arg_12_1 then
		local var_12_3 = cjson.decode(arg_12_1)

		if var_12_3 then
			for iter_12_0, iter_12_1 in pairs(var_12_3) do
				for iter_12_2 = 1, #iter_12_1 do
					local var_12_4 = iter_12_1[iter_12_2]
					local var_12_5 = rawget(ItemMasterList, var_12_4)
					local var_12_6 = var_12_5 and var_12_5.required_dlc

					if not var_12_6 then
						var_12_0[var_12_4] = var_12_2[var_12_4] or true
					elseif not var_12_1:dlc_exists(var_12_6) then
						var_0_7(false, "Tried to check if unexisting DLC was unlocked %s", var_12_6)

						var_12_0[var_12_4] = true
					elseif var_12_1:is_dlc_unlocked(var_12_6) then
						var_12_0[var_12_4] = true
					else
						arg_12_0:_register_dlc_filtered_data(var_12_6, {
							ItemId = var_12_4
						}, var_12_2[var_12_4])
					end
				end
			end
		else
			var_0_7(false, "Failed to decode unlocked_cosmetics_string %s", arg_12_1)
		end
	end

	return var_12_0
end

PlayFabMirrorBase._parse_claimed_console_dlc_rewards = function (arg_13_0)
	local var_13_0 = {}
	local var_13_1 = arg_13_0:get_read_only_data("claimed_console_dlc_rewards")

	if var_13_1 then
		local var_13_2 = cjson.decode(var_13_1)

		for iter_13_0, iter_13_1 in pairs(var_13_2) do
			var_13_0[iter_13_0] = true
		end
	end

	return var_13_0
end

PlayFabMirrorBase._verify_account_data = function (arg_14_0)
	if DEDICATED_SERVER then
		return
	end

	local var_14_0 = {
		FunctionName = "verifyAccountData"
	}
	local var_14_1 = callback(arg_14_0, "verify_account_data_cb")

	arg_14_0._request_queue:enqueue(var_14_0, var_14_1)

	arg_14_0._num_items_to_load = arg_14_0._num_items_to_load + 1
end

PlayFabMirrorBase.verify_account_data_cb = function (arg_15_0, arg_15_1)
	arg_15_0._num_items_to_load = arg_15_0._num_items_to_load - 1

	arg_15_0:_migrate_characters()
end

PlayFabMirrorBase._migrate_characters = function (arg_16_0)
	local var_16_0 = arg_16_0:get_read_only_data("characters_data")

	if not var_16_0 or var_16_0 == "{}" or var_16_0 == "" or type(var_16_0) == "table" and table.is_empty(var_16_0) then
		local var_16_1 = {
			FunctionName = "migrateCharacters",
			FunctionParameter = {}
		}
		local var_16_2 = callback(arg_16_0, "migrate_characters_cb")

		arg_16_0._request_queue:enqueue(var_16_1, var_16_2)

		arg_16_0._num_items_to_load = arg_16_0._num_items_to_load + 1

		return
	end

	arg_16_0:_migrate_cosmetics()
end

PlayFabMirrorBase.migrate_characters_cb = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.FunctionResult
	local var_17_1 = var_17_0.success
	local var_17_2 = var_17_0.characters_data

	if var_17_2 then
		arg_17_0:set_read_only_data("characters_data", var_17_2, true)
	end

	arg_17_0._num_items_to_load = arg_17_0._num_items_to_load - 1

	arg_17_0:_migrate_cosmetics()
end

PlayFabMirrorBase._migrate_cosmetics = function (arg_18_0)
	if DEDICATED_SERVER then
		return
	end

	local var_18_0 = {
		FunctionName = "migrateCosmetics"
	}
	local var_18_1 = callback(arg_18_0, "migrate_cosmetics_request_cb")

	arg_18_0._request_queue:enqueue(var_18_0, var_18_1)

	arg_18_0._num_items_to_load = arg_18_0._num_items_to_load + 1
end

PlayFabMirrorBase.migrate_cosmetics_request_cb = function (arg_19_0, arg_19_1)
	arg_19_0._num_items_to_load = arg_19_0._num_items_to_load - 1

	local var_19_0 = arg_19_1.FunctionResult
	local var_19_1 = var_19_0.unlocked_cosmetics
	local var_19_2 = var_19_0.characters_data

	if var_19_1 then
		arg_19_0:set_read_only_data("unlocked_cosmetics", var_19_1, true)
	end

	if var_19_2 then
		arg_19_0:set_read_only_data("characters_data", var_19_2, true)
	end

	arg_19_0:_update_dlc_ownership()
end

PlayFabMirrorBase._update_dlc_ownership = function (arg_20_0)
	if DEDICATED_SERVER then
		return
	end

	local var_20_0 = Managers.unlock:get_installed_dlcs()
	local var_20_1 = cjson.encode(var_20_0)
	local var_20_2 = {
		FunctionName = "updateDLCOwnership",
		FunctionParameter = {
			installed_dlcs = var_20_1
		}
	}
	local var_20_3 = callback(arg_20_0, "dlc_ownership_request_cb")

	arg_20_0._request_queue:enqueue(var_20_2, var_20_3)

	arg_20_0._num_items_to_load = arg_20_0._num_items_to_load + 1
	arg_20_0._unlocked_dlcs = var_20_0
end

PlayFabMirrorBase.dlc_unlocked_at_signin = function (arg_21_0, arg_21_1)
	return table.find(arg_21_0._unlocked_dlcs, arg_21_1) ~= false
end

PlayFabMirrorBase.dlc_ownership_request_cb = function (arg_22_0, arg_22_1)
	arg_22_0._num_items_to_load = arg_22_0._num_items_to_load - 1

	local var_22_0 = arg_22_1.FunctionResult

	arg_22_0._owner_dlcs_cb_data = table.shallow_copy(var_22_0)

	if script_data["eac-untrusted"] then
		arg_22_0:_handle_owned_dlcs_data()
		arg_22_0:_request_best_power_levels()
	else
		arg_22_0:_execute_dlc_specific_logic()
	end
end

PlayFabMirrorBase._handle_owned_dlcs_data = function (arg_23_0)
	local var_23_0 = arg_23_0._owner_dlcs_cb_data

	arg_23_0._owner_dlcs_cb_data = nil

	local var_23_1 = var_23_0.owned_dlcs
	local var_23_2 = var_23_0.platform_dlcs
	local var_23_3 = var_23_0.excluded_dlcs
	local var_23_4 = var_23_0.new_dlcs
	local var_23_5 = var_23_0.revoked_dlcs

	arg_23_0._owned_dlcs = var_23_1 or {}
	arg_23_0._platform_dlcs = var_23_2

	Managers.unlock:set_excluded_dlcs(var_23_3)
	arg_23_0:update_owned_dlcs(false)

	if HAS_STEAM then
		arg_23_0:handle_new_dlcs(var_23_4)
	end

	if var_23_5 and #var_23_5 > 0 then
		local var_23_6 = var_23_0.unlocked_keep_decorations

		if var_23_6 then
			arg_23_0:set_read_only_data("unlocked_keep_decorations", var_23_6, true)
		end

		local var_23_7 = var_23_0.unlocked_cosmetics

		if var_23_7 then
			arg_23_0:set_read_only_data("unlocked_cosmetics", var_23_7, true)
		end

		local var_23_8 = var_23_0.unlocked_weapon_skins

		if var_23_7 then
			arg_23_0:set_read_only_data("unlocked_weapon_skins", var_23_8, true)
		end
	end

	arg_23_0._claimed_achievements = arg_23_0:_parse_claimed_achievements()
	arg_23_0._claimed_event_quests = arg_23_0:_parse_claimed_event_quests()
	arg_23_0._unlocked_weapon_skins = arg_23_0:_parse_unlocked_weapon_skins()
	arg_23_0._unlocked_cosmetics = arg_23_0:_parse_unlocked_cosmetics()
	arg_23_0._unlocked_weapon_poses = arg_23_0:_parse_unlocked_weapon_poses()
	arg_23_0._equipped_weapon_pose_skins = arg_23_0:_parse_equipped_weapon_pose_skins()

	local var_23_9 = arg_23_0:get_read_only_data("unlocked_keep_decorations") or "{}"

	arg_23_0._unlocked_keep_decorations = cjson.decode(var_23_9)

	if IS_CONSOLE then
		arg_23_0._claimed_console_dlc_rewards = arg_23_0:_parse_claimed_console_dlc_rewards()
	end

	arg_23_0:update_filtered_dlc_data()
end

PlayFabMirrorBase._execute_dlc_specific_logic = function (arg_24_0)
	local var_24_0 = {
		FunctionName = "executeDLCLogic",
		FunctionParameter = {}
	}
	local var_24_1 = callback(arg_24_0, "execute_dlc_logic_request_cb")

	arg_24_0._request_queue:enqueue(var_24_0, var_24_1, true)

	arg_24_0._num_items_to_load = arg_24_0._num_items_to_load + 1
end

local function var_0_8(arg_25_0)
	return ItemMasterList[arg_25_0]
end

PlayFabMirrorBase._sync_unseen_rewards = function (arg_26_0, arg_26_1)
	if not arg_26_1 then
		return
	end

	local var_26_0 = {}

	for iter_26_0 = 1, #arg_26_1 do
		local var_26_1 = arg_26_1[iter_26_0]
		local var_26_2 = var_26_1.ItemType
		local var_26_3 = var_26_1.ItemId

		if var_26_2 == "keep_decoration_painting" then
			local var_26_4 = {
				reward_type = "keep_decoration_painting",
				rewarded_from = var_26_1.Data.rewarded_from,
				keep_decoration_name = var_26_3
			}

			var_26_0[#var_26_0 + 1] = var_26_4

			arg_26_0:add_keep_decoration(var_26_3)
		elseif CosmeticUtils.is_cosmetic_item(var_26_2) then
			local var_26_5 = arg_26_0:add_item(nil, {
				ItemId = var_26_3
			})

			if var_26_5 then
				local var_26_6 = {
					reward_type = var_26_2,
					backend_id = var_26_5,
					rewarded_from = var_26_1.Data.rewarded_from,
					item_type = var_26_2,
					item_id = var_26_3
				}

				var_26_0[#var_26_0 + 1] = var_26_6
			end
		else
			local var_26_7 = var_0_8(var_26_3)
			local var_26_8 = var_26_1.CustomData
			local var_26_9 = var_26_8 and var_26_8.rewarded_from

			if var_26_7 and var_26_9 then
				if var_26_7.bundle then
					local var_26_10 = var_26_7.bundle.BundledVirtualCurrencies

					for iter_26_1, iter_26_2 in pairs(var_26_10) do
						local var_26_11 = {
							reward_type = "currency",
							currency_type = iter_26_1,
							currency_amount = iter_26_2,
							rewarded_from = var_26_9
						}

						var_26_0[#var_26_0 + 1] = var_26_11
					end
				else
					local var_26_12 = var_26_1.ItemInstanceId

					if var_26_9 then
						local var_26_13 = var_26_7.item_type
						local var_26_14 = {
							reward_type = "item",
							backend_id = var_26_12,
							rewarded_from = var_26_9,
							item_type = var_26_13,
							item_id = var_26_3
						}

						var_26_0[#var_26_0 + 1] = var_26_14
					end

					ItemHelper.mark_backend_id_as_new(var_26_12, {
						data = var_26_7
					})
				end
			end
		end
	end

	arg_26_0:_apply_unseen_rewards(var_26_0)
end

PlayFabMirrorBase._apply_unseen_rewards = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0:get_user_data("unseen_rewards")
	local var_27_1

	var_27_1 = var_27_0 and cjson.decode(var_27_0) or {}

	table.append(var_27_1, arg_27_1)
	arg_27_0:set_user_data("unseen_rewards", cjson.encode(var_27_1))
end

PlayFabMirrorBase.execute_dlc_logic_request_cb = function (arg_28_0, arg_28_1)
	arg_28_0._num_items_to_load = arg_28_0._num_items_to_load - 1

	arg_28_0:_handle_owned_dlcs_data()

	local var_28_0 = arg_28_1.FunctionResult

	if var_28_0 then
		local var_28_1 = var_28_0.missing_dlc_info

		if var_28_1 then
			local var_28_2 = var_28_1.presentation_text_localized and Localize(var_28_1.presentation_text_localized) or var_28_1.presentation_text
			local var_28_3 = var_28_1.presentation_title_localized and Localize(var_28_1.presentation_title_localized) or var_28_1.presentation_title
			local var_28_4

			if var_28_1.presentation_url_button then
				var_28_4 = {
					text = var_28_1.presentation_url_button.text_localized and Localize(var_28_1.presentation_url_button.text_localized) or var_28_1.presentation_url_button.text,
					url = var_28_1.presentation_url_button.url
				}
			end

			Managers.backend:missing_required_dlc_error(var_28_2, var_28_3, var_28_4)

			return
		end

		arg_28_0:_sync_unseen_rewards(var_28_0.item_grant_results)
	end

	arg_28_0:_request_best_power_levels()
end

PlayFabMirrorBase._request_best_power_levels = function (arg_29_0)
	local var_29_0 = {
		FunctionName = "bestPowerLevels",
		FunctionParameter = {}
	}
	local var_29_1 = callback(arg_29_0, "best_power_levels_request_cb")

	arg_29_0._request_queue:enqueue(var_29_0, var_29_1)

	arg_29_0._num_items_to_load = arg_29_0._num_items_to_load + 1
end

PlayFabMirrorBase.best_power_levels_request_cb = function (arg_30_0, arg_30_1)
	arg_30_0._num_items_to_load = arg_30_0._num_items_to_load - 1

	local var_30_0 = arg_30_1.FunctionResult.best_power_levels

	arg_30_0._best_power_levels = var_30_0

	local var_30_1 = 0

	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		var_30_1 = var_30_1 + iter_30_1
	end

	arg_30_0.sum_best_power_levels = var_30_1

	arg_30_0:_request_signin_reward()
end

PlayFabMirrorBase._request_signin_reward = function (arg_31_0)
	local var_31_0 = {
		FunctionName = "signInRewards",
		FunctionParameter = {}
	}
	local var_31_1 = callback(arg_31_0, "sign_in_reward_request_cb")

	arg_31_0._request_queue:enqueue(var_31_0, var_31_1)

	arg_31_0._num_items_to_load = arg_31_0._num_items_to_load + 1
end

PlayFabMirrorBase.sign_in_reward_request_cb = function (arg_32_0, arg_32_1)
	arg_32_0._num_items_to_load = arg_32_0._num_items_to_load - 1

	local var_32_0 = arg_32_1.FunctionResult.rewards

	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		local var_32_1 = iter_32_1.ItemGrantResults

		if var_32_1 then
			for iter_32_2, iter_32_3 in ipairs(var_32_1) do
				if iter_32_3.Result == true then
					local var_32_2 = iter_32_3.ItemInstanceId

					if iter_32_0 and var_32_2 then
						ItemHelper.mark_sign_in_reward_as_new(iter_32_0, var_32_2)
					end
				end
			end
		end

		local var_32_3 = iter_32_1.unlocked_keep_decorations

		if var_32_3 then
			for iter_32_4, iter_32_5 in ipairs(var_32_3) do
				arg_32_0:add_keep_decoration(iter_32_5)
			end
		end

		local var_32_4 = iter_32_1.unlocked_cosmetics

		if var_32_4 then
			for iter_32_6 = 1, #var_32_4 do
				arg_32_0:add_item(nil, {
					ItemId = var_32_4[iter_32_6]
				})
			end
		end

		local var_32_5 = iter_32_1.unlocked_weapon_skins

		if var_32_5 then
			for iter_32_7 = 1, #var_32_5 do
				arg_32_0:add_unlocked_weapon_skin(var_32_5[iter_32_7])
			end
		end

		local var_32_6 = iter_32_1.unlocked_weapon_poses

		if var_32_6 then
			for iter_32_8 = 1, #var_32_6 do
				arg_32_0:add_unlocked_weapon_pose(var_32_6[iter_32_8])
			end
		end
	end

	arg_32_0:_request_quests()
end

PlayFabMirrorBase._request_quests = function (arg_33_0)
	local var_33_0 = {
		FunctionName = "getQuests",
		FunctionParameter = {}
	}
	local var_33_1 = callback(arg_33_0, "get_quests_cb")

	arg_33_0._request_queue:enqueue(var_33_0, var_33_1)

	arg_33_0._num_items_to_load = arg_33_0._num_items_to_load + 1
end

PlayFabMirrorBase.get_quests_cb = function (arg_34_0, arg_34_1)
	arg_34_0._num_items_to_load = arg_34_0._num_items_to_load - 1

	local var_34_0 = arg_34_1.FunctionResult
	local var_34_1 = var_34_0.current_daily_quests
	local var_34_2 = var_34_0.daily_quest_refresh_available
	local var_34_3 = var_34_0.daily_quest_update_time
	local var_34_4 = var_34_0.current_event_quests
	local var_34_5 = var_34_0.current_weekly_quests
	local var_34_6 = var_34_0.weekly_quest_update_time

	arg_34_0:set_quest_data("current_daily_quests", var_34_1)
	arg_34_0:set_quest_data("daily_quest_refresh_available", to_boolean(var_34_2))
	arg_34_0:set_quest_data("daily_quest_update_time", tonumber(var_34_3))
	arg_34_0:set_quest_data("current_event_quests", var_34_4)
	arg_34_0:set_quest_data("current_weekly_quests", var_34_5)
	arg_34_0:set_quest_data("weekly_quest_update_time", var_34_6)
	arg_34_0:_get_weekly_event_rewards()
end

PlayFabMirrorBase._get_weekly_event_rewards = function (arg_35_0)
	local var_35_0 = {
		FunctionName = "getWeeklyEventRewards",
		FunctionParameter = {}
	}
	local var_35_1 = callback(arg_35_0, "get_weekly_event_rewards_cb")

	arg_35_0._request_queue:enqueue(var_35_0, var_35_1)

	arg_35_0._num_items_to_load = arg_35_0._num_items_to_load + 1
end

PlayFabMirrorBase.get_weekly_event_rewards_cb = function (arg_36_0, arg_36_1)
	arg_36_0._num_items_to_load = arg_36_0._num_items_to_load - 1

	local var_36_0 = arg_36_1.FunctionResult.data

	if var_36_0 then
		arg_36_0:set_read_only_data("weekly_event_rewards", cjson.encode(var_36_0), true)
	end

	arg_36_0:_request_fix_inventory_data_1()
end

PlayFabMirrorBase._request_fix_inventory_data_1 = function (arg_37_0)
	local var_37_0 = {
		FunctionName = "fixInventoryData1",
		FunctionParameter = {}
	}
	local var_37_1 = callback(arg_37_0, "fix_inventory_data_1_request_cb")

	arg_37_0._request_queue:enqueue(var_37_0, var_37_1)

	arg_37_0._num_items_to_load = arg_37_0._num_items_to_load + 1
end

PlayFabMirrorBase.fix_inventory_data_1_request_cb = function (arg_38_0, arg_38_1)
	arg_38_0._num_items_to_load = arg_38_0._num_items_to_load - 1

	local var_38_0 = arg_38_1.FunctionResult
	local var_38_1 = var_38_0 and var_38_0.updated_xp_data
	local var_38_2 = var_38_0 and var_38_0.new_read_only_data

	if var_38_1 then
		for iter_38_0, iter_38_1 in pairs(var_38_1) do
			arg_38_0:set_read_only_data(iter_38_0, iter_38_1, true)
		end
	end

	if var_38_2 then
		for iter_38_2, iter_38_3 in pairs(var_38_2) do
			arg_38_0:set_read_only_data(iter_38_2, iter_38_3, true)

			if iter_38_2 == "unlocked_weapon_skins" then
				arg_38_0._unlocked_weapon_skins = arg_38_0:_parse_unlocked_weapon_skins()
			elseif iter_38_2 == "unlocked_cosmetics" then
				arg_38_0._unlocked_cosmetics = arg_38_0:_parse_unlocked_cosmetics()
			elseif iter_38_2 == "unlocked_weapon_poses" then
				arg_38_0._unlocked_weapon_poses = arg_38_0:_parse_unlocked_weapon_poses()
			end
		end
	end

	arg_38_0:_request_fix_inventory_data_2()
end

PlayFabMirrorBase._request_fix_inventory_data_2 = function (arg_39_0)
	local var_39_0 = {
		FunctionName = "fixInventoryData2",
		FunctionParameter = {}
	}
	local var_39_1 = callback(arg_39_0, "fix_inventory_data_2_request_cb")

	arg_39_0._request_queue:enqueue(var_39_0, var_39_1)

	arg_39_0._num_items_to_load = arg_39_0._num_items_to_load + 1
end

PlayFabMirrorBase.fix_inventory_data_2_request_cb = function (arg_40_0, arg_40_1)
	arg_40_0._num_items_to_load = arg_40_0._num_items_to_load - 1

	local var_40_0 = arg_40_1.FunctionResult
	local var_40_1 = var_40_0 and var_40_0.new_magic_level

	if var_40_1 then
		local var_40_2 = arg_40_0:get_read_only_data("weaves_career_progress")
		local var_40_3 = cjson.decode(var_40_2)

		for iter_40_0 = 1, #var_0_1 do
			local var_40_4 = var_0_1[iter_40_0]

			if var_40_3[var_40_4] then
				var_40_3[var_40_4].magic_level = var_40_1
			end
		end

		arg_40_0:set_read_only_data("weaves_career_progress", cjson.encode(var_40_3), true)
	end

	arg_40_0:_handle_fix_data_ids()
end

PlayFabMirrorBase._handle_fix_data_ids = function (arg_41_0)
	local var_41_0 = {
		FunctionName = "handleFixDataIds",
		FunctionParameter = {}
	}
	local var_41_1 = callback(arg_41_0, "handle_fix_data_ids_request_cb")

	arg_41_0._request_queue:enqueue(var_41_0, var_41_1)

	arg_41_0._num_items_to_load = arg_41_0._num_items_to_load + 1
end

PlayFabMirrorBase.handle_fix_data_ids_request_cb = function (arg_42_0, arg_42_1)
	arg_42_0._num_items_to_load = arg_42_0._num_items_to_load - 1

	local var_42_0 = arg_42_1.FunctionResult
	local var_42_1
	local var_42_2

	if var_42_0.done ~= nil then
		var_42_1 = var_42_0.done
		var_42_2 = var_42_0.data
	else
		var_42_1 = true
		var_42_2 = var_42_0
	end

	local var_42_3 = var_42_2.new_user_read_only_data

	if var_42_3 then
		for iter_42_0, iter_42_1 in pairs(var_42_3) do
			if type(iter_42_1) == "table" then
				local var_42_4 = cjson.encode(iter_42_1)

				arg_42_0:set_read_only_data(iter_42_0, var_42_4, true)
			elseif iter_42_1 == "true" then
				arg_42_0:set_read_only_data(iter_42_0, true, true)
			elseif iter_42_1 == "false" then
				arg_42_0:set_read_only_data(iter_42_0, false, true)
			else
				arg_42_0:set_read_only_data(iter_42_0, tonumber(iter_42_1) or iter_42_1, true)
			end
		end
	end

	local var_42_5 = var_42_2.new_user_data

	if var_42_5 then
		for iter_42_2, iter_42_3 in pairs(var_42_5) do
			if type(iter_42_3) == "table" then
				local var_42_6 = cjson.encode(iter_42_3)

				arg_42_0:set_user_data(iter_42_2, var_42_6, true)
			elseif iter_42_3 == "true" then
				arg_42_0:set_user_data(iter_42_2, true, true)
			elseif iter_42_3 == "false" then
				arg_42_0:set_user_data(iter_42_2, false, true)
			else
				arg_42_0:set_user_data(iter_42_2, tonumber(iter_42_3) or iter_42_3, true)
			end
		end
	end

	local var_42_7 = var_42_2.new_cosmetics

	if var_42_7 then
		for iter_42_4 = 1, #var_42_7 do
			arg_42_0:add_item(nil, {
				ItemId = var_42_7[iter_42_4]
			})
		end
	end

	local var_42_8 = var_42_2.new_weapon_poses

	if var_42_8 then
		for iter_42_5 = 1, #var_42_8 do
			arg_42_0:add_item(nil, {
				ItemId = var_42_8[iter_42_5]
			})
		end
	end

	local var_42_9 = var_42_2.new_weapon_skins

	if var_42_9 then
		for iter_42_6 = 1, #var_42_9 do
			local var_42_10 = var_42_9[iter_42_6]

			arg_42_0:add_unlocked_weapon_skin(var_42_10)
		end
	end

	local var_42_11 = var_42_2.new_items

	if var_42_11 then
		for iter_42_7 = 1, #var_42_11 do
			local var_42_12 = var_42_11[iter_42_7]

			arg_42_0:add_item(var_42_12.ItemInstanceId, var_42_12)
		end
	end

	local var_42_13 = var_42_2.removed_items

	if var_42_13 then
		for iter_42_8 = 1, #var_42_13 do
			local var_42_14 = var_42_13[iter_42_8]

			arg_42_0:remove_item(var_42_14.ItemInstanceId)
		end
	end

	local var_42_15 = var_42_2.modified_items

	if var_42_15 then
		for iter_42_9 = 1, #var_42_15 do
			local var_42_16 = var_42_15[iter_42_9]

			if arg_42_0._inventory_items and arg_42_0._inventory_items[var_42_16.ItemInstanceId] then
				arg_42_0:update_item(var_42_16.ItemInstanceId, var_42_16)
			else
				arg_42_0:add_item(var_42_16.ItemInstanceId, var_42_16, false, true)
			end
		end
	end

	if not var_42_1 then
		arg_42_0:_handle_fix_data_ids()
	else
		arg_42_0:_fix_excess_bogenhafen_chests()
	end
end

PlayFabMirrorBase._fix_excess_bogenhafen_chests = function (arg_43_0)
	local var_43_0 = {
		FunctionName = "removeExcessBogenhafenChests",
		FunctionParameter = {}
	}
	local var_43_1 = callback(arg_43_0, "_fix_excess_bogenhafen_chests_cb")

	arg_43_0._request_queue:enqueue(var_43_0, var_43_1)

	arg_43_0._num_items_to_load = arg_43_0._num_items_to_load + 1
end

PlayFabMirrorBase._fix_excess_bogenhafen_chests_cb = function (arg_44_0)
	arg_44_0._num_items_to_load = arg_44_0._num_items_to_load - 1

	arg_44_0:_fix_excess_duplicate_bogenhafen_cosmetics()
end

PlayFabMirrorBase._fix_excess_duplicate_bogenhafen_cosmetics = function (arg_45_0)
	local var_45_0 = {
		FunctionName = "removeDuplicateBogenhafenCosmetics",
		FunctionParameter = {}
	}
	local var_45_1 = callback(arg_45_0, "_fix_excess_duplicate_bogenhafen_cosmetics_cb")

	arg_45_0._request_queue:enqueue(var_45_0, var_45_1)

	arg_45_0._num_items_to_load = arg_45_0._num_items_to_load + 1
end

PlayFabMirrorBase._fix_excess_duplicate_bogenhafen_cosmetics_cb = function (arg_46_0)
	arg_46_0._num_items_to_load = arg_46_0._num_items_to_load - 1

	arg_46_0:_request_read_only_data()
end

PlayFabMirrorBase._request_read_only_data = function (arg_47_0)
	local var_47_0 = {
		FunctionName = "getReadOnlyData",
		FunctionParameter = {}
	}
	local var_47_1 = callback(arg_47_0, "read_only_data_request_cb")

	arg_47_0._request_queue:enqueue(var_47_0, var_47_1)

	arg_47_0._num_items_to_load = arg_47_0._num_items_to_load + 1
end

PlayFabMirrorBase.read_only_data_request_cb = function (arg_48_0, arg_48_1)
	arg_48_0._num_items_to_load = arg_48_0._num_items_to_load - 1

	local var_48_0 = arg_48_1.FunctionResult
	local var_48_1 = var_48_0.achievement_rewards

	arg_48_0._achievement_rewards = cjson.decode(var_48_1)

	local var_48_2 = var_48_0.weaves_progression_settings

	arg_48_0._weaves_progression_settings = var_48_2 and cjson.decode(var_48_2) or {}

	local var_48_3 = var_48_0.power_level_data

	arg_48_0._power_level_data = var_48_3 and cjson.decode(var_48_3) or {}

	local var_48_4 = var_48_0.rarity_tables

	arg_48_0._rarity_tables = var_48_4 and cjson.decode(var_48_4) or {}

	arg_48_0:_generate_formatted_rarity_tables(arg_48_0._rarity_tables)
	arg_48_0:_request_user_data()
end

PlayFabMirrorBase._request_user_data = function (arg_49_0)
	local var_49_0 = {}
	local var_49_1 = callback(arg_49_0, "user_data_request_cb")

	arg_49_0._request_queue:enqueue_api_request("GetUserData", var_49_0, var_49_1)

	arg_49_0._num_items_to_load = arg_49_0._num_items_to_load + 1
end

PlayFabMirrorBase.user_data_request_cb = function (arg_50_0, arg_50_1)
	arg_50_0._num_items_to_load = arg_50_0._num_items_to_load - 1

	for iter_50_0, iter_50_1 in pairs(arg_50_1.Data) do
		if iter_50_0 == "unseen_rewards" then
			local var_50_0 = cjson.decode(iter_50_1.Value)
			local var_50_1 = arg_50_0:get_user_data("unseen_rewards")
			local var_50_2 = var_50_1 and cjson.decode(var_50_1) or {}
			local var_50_3 = ItemHelper.is_fake_item

			for iter_50_2 = 1, #var_50_0 do
				local var_50_4 = var_50_0[iter_50_2]

				if var_50_3(var_50_4.reward_type) then
					if not table.find_by_key(var_50_2, "item_id", var_50_4.item_id) then
						var_50_2[#var_50_2 + 1] = var_50_4
					end
				elseif not table.find_by_key(var_50_2, "backend_id", var_50_4.backend_id) then
					var_50_2[#var_50_2 + 1] = var_50_4
				end
			end

			arg_50_0:set_user_data(iter_50_0, cjson.encode(var_50_2))
		else
			arg_50_0:set_user_data(iter_50_0, iter_50_1.Value, true)
		end
	end

	arg_50_0:_request_twitch_app_access_token()
end

PlayFabMirrorBase._request_twitch_app_access_token = function (arg_51_0)
	local var_51_0 = {
		FunctionName = "getTwitchAccessToken",
		FunctionParameter = {}
	}
	local var_51_1 = callback(arg_51_0, "_request_twitch_app_access_token_cb")

	arg_51_0._request_queue:enqueue(var_51_0, var_51_1)

	arg_51_0._num_items_to_load = arg_51_0._num_items_to_load + 1
end

PlayFabMirrorBase._request_twitch_app_access_token_cb = function (arg_52_0, arg_52_1)
	arg_52_0._num_items_to_load = arg_52_0._num_items_to_load - 1
	arg_52_0._twitch_app_access_token = false

	local var_52_0 = arg_52_1.FunctionResult

	if var_52_0.success then
		arg_52_0._twitch_app_access_token = var_52_0.access_token
	end

	arg_52_0:_weaves_player_setup()
end

PlayFabMirrorBase.get_twitch_app_access_token = function (arg_53_0)
	return arg_53_0._twitch_app_access_token
end

PlayFabMirrorBase._weaves_player_setup = function (arg_54_0)
	local var_54_0 = {
		FunctionName = "weavesPlayerSetup",
		FunctionParameter = {}
	}
	local var_54_1 = callback(arg_54_0, "weaves_player_setup_request_cb")

	arg_54_0._request_queue:enqueue(var_54_0, var_54_1)

	arg_54_0._num_items_to_load = arg_54_0._num_items_to_load + 1
end

PlayFabMirrorBase.weaves_player_setup_request_cb = function (arg_55_0, arg_55_1)
	arg_55_0._num_items_to_load = arg_55_0._num_items_to_load - 1

	local var_55_0 = arg_55_1.FunctionResult
	local var_55_1 = var_55_0.created
	local var_55_2 = var_55_0.essence
	local var_55_3 = var_55_0.total_essence
	local var_55_4 = var_55_0.maximum_essence

	if var_55_1 then
		local var_55_5 = var_55_0.new_user_data

		for iter_55_0, iter_55_1 in pairs(var_55_5) do
			arg_55_0:set_read_only_data(iter_55_0, iter_55_1, true)
		end
	end

	arg_55_0:set_essence(var_55_2)
	arg_55_0:set_total_essence(var_55_3)
	arg_55_0:set_maximum_essence(var_55_4)
	arg_55_0:_fix_total_collected_essence()
end

PlayFabMirrorBase._fix_total_collected_essence = function (arg_56_0)
	local var_56_0 = {
		FunctionName = "fixTotalCollectedEssence",
		FunctionParameter = {}
	}
	local var_56_1 = callback(arg_56_0, "fix_total_collected_essence_cb")

	arg_56_0._request_queue:enqueue(var_56_0, var_56_1)

	arg_56_0._num_items_to_load = arg_56_0._num_items_to_load + 1
end

PlayFabMirrorBase.fix_total_collected_essence_cb = function (arg_57_0, arg_57_1)
	arg_57_0._num_items_to_load = arg_57_0._num_items_to_load - 1

	local var_57_0 = arg_57_1.FunctionResult.total_essence

	if var_57_0 then
		arg_57_0:set_total_essence(var_57_0)
	end

	if DLCSettings.win_tracks then
		arg_57_0:_request_win_tracks()
	elseif DLCSettings.morris then
		arg_57_0:_deus_player_setup()
		arg_57_0:_deus_setup_belakor_data()
	else
		arg_57_0:_set_up_additional_account_data()
	end
end

PlayFabMirrorBase._request_win_tracks = function (arg_58_0)
	local var_58_0 = {
		FunctionName = "winTracksSetup",
		FunctionParameter = {}
	}
	local var_58_1 = callback(arg_58_0, "win_tracks_request_cb")

	arg_58_0._request_queue:enqueue(var_58_0, var_58_1)

	arg_58_0._num_items_to_load = arg_58_0._num_items_to_load + 1
end

PlayFabMirrorBase.win_tracks_request_cb = function (arg_59_0, arg_59_1)
	arg_59_0._num_items_to_load = arg_59_0._num_items_to_load - 1

	local var_59_0 = arg_59_1.FunctionResult
	local var_59_1 = var_59_0.new_read_only_data

	for iter_59_0, iter_59_1 in pairs(var_59_1) do
		local var_59_2 = cjson.encode(iter_59_1)

		arg_59_0:set_read_only_data(iter_59_0, var_59_2, true)
	end

	arg_59_0._win_tracks = var_59_0.win_tracks
	arg_59_0._current_win_track_id = var_59_0.new_read_only_data.win_tracks_progress.current_win_track_id

	if DLCSettings.morris then
		arg_59_0:_deus_player_setup()
		arg_59_0:_deus_setup_belakor_data()
	else
		arg_59_0:_set_up_additional_account_data()
	end
end

PlayFabMirrorBase.get_win_tracks = function (arg_60_0)
	return arg_60_0._win_tracks
end

PlayFabMirrorBase._deus_player_setup = function (arg_61_0)
	local var_61_0 = {
		FunctionName = "deusPlayerSetup",
		FunctionParameter = {}
	}
	local var_61_1 = callback(arg_61_0, "deus_player_setup_request_cb")

	arg_61_0._request_queue:enqueue(var_61_0, var_61_1)

	arg_61_0._num_items_to_load = arg_61_0._num_items_to_load + 1
end

PlayFabMirrorBase.deus_player_setup_request_cb = function (arg_62_0, arg_62_1)
	arg_62_0._num_items_to_load = arg_62_0._num_items_to_load - 1

	arg_62_0:handle_deus_result(arg_62_1)
	arg_62_0:_set_up_additional_account_data()
end

PlayFabMirrorBase.deus_refresh_belakor_data = function (arg_63_0)
	arg_63_0:_deus_setup_belakor_data()
end

PlayFabMirrorBase.has_loaded_belakor_data = function (arg_64_0)
	return arg_64_0._belakor_data_loaded
end

PlayFabMirrorBase.set_has_loaded_belakor_data = function (arg_65_0, arg_65_1)
	arg_65_0._belakor_data_loaded = arg_65_1
end

PlayFabMirrorBase._deus_setup_belakor_data = function (arg_66_0)
	local var_66_0 = {
		FunctionName = "deusSetBelakorCurse",
		FunctionParameter = {}
	}
	local var_66_1 = callback(arg_66_0, "deus_setup_belakor_data_request_cb")

	arg_66_0._request_queue:enqueue(var_66_0, var_66_1)

	arg_66_0._belakor_data_loaded = false
end

PlayFabMirrorBase.deus_setup_belakor_data_request_cb = function (arg_67_0, arg_67_1)
	arg_67_0._belakor_data_loaded = true

	local var_67_0 = arg_67_1.FunctionResult.deus_belakor_curse_data

	if var_67_0 then
		local var_67_1 = Managers.time:time("main")

		arg_67_0._deus_belakor_curse_data = {
			time_of_update = var_67_1,
			span = var_67_0.span_ms / 1000,
			remaining_time = var_67_0.remaining_time_ms / 1000,
			cycle_count = var_67_0.cycle_count
		}
	end
end

PlayFabMirrorBase._set_up_additional_account_data = function (arg_68_0, arg_68_1)
	local var_68_0 = {
		FunctionName = "additionalAccountDataSetUp",
		FunctionParameter = {
			steps_completed = arg_68_1
		}
	}
	local var_68_1 = callback(arg_68_0, "additional_data_setup_request_cb")

	arg_68_0._request_queue:enqueue(var_68_0, var_68_1)

	arg_68_0._num_items_to_load = arg_68_0._num_items_to_load + 1
end

PlayFabMirrorBase.additional_data_setup_request_cb = function (arg_69_0, arg_69_1)
	arg_69_0._num_items_to_load = arg_69_0._num_items_to_load - 1

	local var_69_0 = arg_69_1.FunctionResult
	local var_69_1 = var_69_0.new_user_read_only_data
	local var_69_2 = var_69_0.new_currencies

	if var_69_1 then
		for iter_69_0, iter_69_1 in pairs(var_69_1) do
			arg_69_0:set_read_only_data(iter_69_0, iter_69_1, true)
		end
	end

	if var_69_2 then
		local var_69_3 = DLCSettings.store.currency_ui_settings
		local var_69_4 = Managers.backend:get_interface("peddler")

		for iter_69_2, iter_69_3 in pairs(var_69_2) do
			if iter_69_2 == "ES" then
				arg_69_0:set_essence(arg_69_0._essence + iter_69_3)
			elseif var_69_3[iter_69_2] ~= nil and var_69_4 then
				local var_69_5 = var_69_4:get_chips(iter_69_2)

				var_69_4:set_chips(iter_69_2, var_69_5 + iter_69_3)
			end
		end
	end

	local var_69_6 = var_69_0.steps_completed

	if var_69_6 then
		arg_69_0:_set_up_additional_account_data(var_69_6)
	else
		arg_69_0:_request_user_inventory()
	end
end

PlayFabMirrorBase._request_user_inventory = function (arg_70_0)
	local var_70_0 = {}
	local var_70_1 = callback(arg_70_0, "inventory_request_cb")

	arg_70_0._request_queue:enqueue_api_request("GetUserInventory", var_70_0, var_70_1)

	arg_70_0._num_items_to_load = arg_70_0._num_items_to_load + 1
end

PlayFabMirrorBase.inventory_request_cb = function (arg_71_0, arg_71_1)
	arg_71_0._num_items_to_load = arg_71_0._num_items_to_load - 1

	local var_71_0 = arg_71_1.Inventory
	local var_71_1 = Managers.unlock

	if arg_71_0._inventory_items then
		table.clear(arg_71_0._inventory_items)
	else
		arg_71_0._inventory_items = {}
	end

	for iter_71_0 = 1, #var_71_0 do
		local var_71_2 = var_71_0[iter_71_0]

		if not var_71_2.BundleContents then
			if var_71_2.ItemId and not rawget(ItemMasterList, var_71_2.ItemId) then
				Crashify.print_exception("PlayFabMirrorBase", "ItemMasterList has no item %q", var_71_2.ItemId)
			else
				local var_71_3 = var_71_2.ItemInstanceId

				arg_71_0:_update_data(var_71_2, var_71_3)

				local var_71_4 = false
				local var_71_5 = var_71_2.data.item_type

				if var_71_5 == "weapon_skin" or CosmeticUtils.is_cosmetic_item(var_71_5) then
					var_71_4 = true
				end

				local var_71_6 = ItemMasterList[var_71_2.ItemId].required_dlc

				if var_71_6 and not var_71_1:is_dlc_unlocked(var_71_6) then
					var_71_4 = true

					arg_71_0:_register_dlc_filtered_data(var_71_6, var_71_2, var_71_3)
				end

				if not var_71_4 then
					arg_71_0._inventory_items[var_71_3] = var_71_2
				end
			end
		end
	end

	local var_71_7 = arg_71_0:get_unlocked_weapon_skins() or {}
	local var_71_8 = arg_71_0:get_unlocked_cosmetics() or {}
	local var_71_9 = arg_71_0:get_unlocked_weapon_poses() or {}

	arg_71_0:_create_fake_inventory_items(var_71_7, "weapon_skins")
	arg_71_0:_create_fake_inventory_items(var_71_8, "cosmetics")
	arg_71_0:_create_fake_inventory_items(var_71_9, "weapon_poses")

	if HAS_STEAM then
		arg_71_0:_request_steam_user_inventory()
	else
		arg_71_0:request_characters()
	end
end

PlayFabMirrorBase.update_filtered_dlc_data = function (arg_72_0)
	local var_72_0 = Managers.unlock

	for iter_72_0 in pairs(arg_72_0._filtered_data) do
		if var_72_0:is_dlc_unlocked(iter_72_0) then
			arg_72_0:_grant_filtered_data(iter_72_0)
		end
	end
end

PlayFabMirrorBase._request_steam_user_inventory = function (arg_73_0)
	var_0_6("steam item server: requesting user inventory")

	arg_73_0._num_items_to_load = arg_73_0._num_items_to_load + 1

	local function var_73_0(arg_74_0, arg_74_1)
		if arg_74_1 then
			var_0_6("_request_steam_user_inventory got results")
		else
			var_0_6("_request_steam_user_inventory got no results")
		end

		local var_74_0 = true
		local var_74_1 = true

		arg_73_0:_cb_steam_user_inventory(arg_74_0, arg_74_1, var_74_0, var_74_1)
	end

	Managers.steam:request_user_inventory(var_73_0)
end

PlayFabMirrorBase.delete_playfab_characters_cb = function (arg_75_0, arg_75_1)
	arg_75_0._num_items_to_load = arg_75_0._num_items_to_load - 1

	arg_75_0:request_characters()
end

PlayFabMirrorBase.add_steam_items = function (arg_76_0, arg_76_1)
	local var_76_0 = 1

	arg_76_0._num_items_to_load = arg_76_0._num_items_to_load + 1

	local var_76_1 = false

	arg_76_0:_cb_steam_user_inventory(var_76_0, arg_76_1, false, var_76_1)
end

PlayFabMirrorBase._cb_steam_user_inventory = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	arg_77_0._num_items_to_load = arg_77_0._num_items_to_load - 1

	if arg_77_1 == 1 then
		var_0_6("-> retrieval of steam user inventory, SUCCESS")

		for iter_77_0 = 1, #arg_77_2, 4 do
			local var_77_0 = arg_77_2[iter_77_0]
			local var_77_1 = arg_77_2[iter_77_0 + 1]
			local var_77_2 = arg_77_2[iter_77_0 + 2]
			local var_77_3 = arg_77_2[iter_77_0 + 3]
			local var_77_4 = SteamitemdefidToMasterList[var_77_0]

			if var_77_4 then
				local var_77_5 = var_77_1
				local var_77_6 = {
					ItemId = var_77_4,
					ItemInstanceId = var_77_5
				}
				local var_77_7 = ItemMasterList[var_77_4]

				if (var_77_7.slot_type == "melee" or var_77_7.slot_type == "ranged") and (not var_77_6.CustomData or not var_77_6.CustomData.power_level) then
					var_77_6.CustomData = {
						power_level = 5,
						rarity = var_77_7.rarity or "default"
					}
				end

				arg_77_0:add_item(var_77_5, var_77_6, true, arg_77_4)
				var_0_6("Steam Item: %q, %q, %q, %q, %q", var_77_4, var_77_0, var_77_1, var_77_2, var_77_3)
			end
		end
	else
		var_0_6("ERROR could not retrieve get steam user inventory. result-code: %q", arg_77_1)
	end

	if arg_77_3 then
		arg_77_0:request_characters()
	end
end

PlayFabMirrorBase._set_inital_career_data = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
	if not arg_78_3 then
		return
	end

	local var_78_0 = arg_78_0._career_data[arg_78_1]
	local var_78_1 = arg_78_0._career_data_mirror[arg_78_1]
	local var_78_2 = {}

	table.clear(var_78_0)
	table.clear(var_78_1)

	for iter_78_0 = 1, #arg_78_2 do
		local var_78_3 = arg_78_2[iter_78_0]
		local var_78_4 = {}

		for iter_78_1 = 1, #arg_78_3 do
			local var_78_5 = arg_78_3[iter_78_1]
			local var_78_6 = var_78_3[var_78_5]
			local var_78_7 = type(var_78_6) == "table" and var_78_6.Value or var_78_6

			if not var_78_7 then
				var_78_4[var_78_5] = true
			elseif CosmeticUtils.is_cosmetic_slot(var_78_5) then
				if not arg_78_0._unlocked_cosmetics[var_78_7] then
					var_78_4[var_78_5] = true
				end
			elseif var_78_5 == "slot_pose" then
				local var_78_8 = ItemMasterList[var_78_7].parent

				if not (arg_78_0._unlocked_weapon_poses[var_78_8] and arg_78_0._unlocked_weapon_poses[var_78_8][var_78_7]) then
					var_78_4[var_78_5] = true
				end
			else
				local var_78_9 = arg_78_0._inventory_items[var_78_7]

				if var_78_9 then
					if Managers.mechanism:current_mechanism_name() == "versus" then
						local var_78_10 = var_78_9.CustomData

						if (var_78_10 and var_78_10.rarity) ~= "default" then
							var_78_4[var_78_5] = true
						end
					end
				else
					var_78_4[var_78_5] = true
				end
			end
		end

		arg_78_0:_verify_items_are_usable(var_78_4, var_78_3, arg_78_1, arg_78_3)

		local var_78_11 = {}
		local var_78_12 = {}

		for iter_78_2, iter_78_3 in pairs(var_78_3) do
			local var_78_13 = type(iter_78_3) == "table" and iter_78_3.Value or iter_78_3

			var_78_11[iter_78_2] = var_78_13
			var_78_12[iter_78_2] = var_78_13
		end

		var_78_0[iter_78_0] = var_78_11
		var_78_1[iter_78_0] = var_78_12

		if table.size(var_78_4) > 0 then
			var_78_2[tostring(iter_78_0)] = var_78_4
		end
	end

	if table.size(var_78_2) > 0 then
		return var_78_2
	end
end

PlayFabMirrorBase._verify_items_are_usable = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
	local var_79_0 = CareerSettings[arg_79_3]

	if not var_79_0 then
		var_0_6("Tried to verify items of career that doesn't exist: %q", arg_79_3)

		return
	end

	local var_79_1 = var_79_0.item_slot_types_by_slot_name

	for iter_79_0 = 1, #arg_79_4 do
		local var_79_2 = arg_79_4[iter_79_0]

		if not arg_79_1[var_79_2] then
			local var_79_3 = arg_79_2[var_79_2]
			local var_79_4 = type(var_79_3) == "table" and var_79_3.Value or var_79_3

			if var_79_4 then
				local var_79_5 = arg_79_0._inventory_items[var_79_4]

				if CosmeticUtils.is_cosmetic_slot(var_79_2) then
					local var_79_6 = arg_79_0._unlocked_cosmetics[var_79_4]

					if var_79_6 then
						var_79_5 = arg_79_0._inventory_items[var_79_6]
					end
				end

				if var_79_2 == "slot_pose" then
					local var_79_7 = ItemMasterList[var_79_4].parent
					local var_79_8 = arg_79_0._unlocked_weapon_poses[var_79_7][var_79_4]

					if var_79_8 then
						var_79_5 = arg_79_0._inventory_items[var_79_8]
					end
				end

				if var_79_5 then
					local var_79_9 = var_79_5.data
					local var_79_10 = var_79_9.can_wield

					if not table.contains(var_79_10, arg_79_3) then
						arg_79_1[var_79_2] = true
					end

					local var_79_11 = var_79_1[var_79_2]
					local var_79_12 = var_79_9.slot_type
					local var_79_13 = var_79_9.rarity

					if not table.contains(var_79_11, var_79_12) or var_79_13 == "magic" then
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
	local var_80_0 = arg_80_1.CustomData

	if var_80_0 then
		local var_80_1 = var_80_0.properties

		if var_80_1 then
			arg_80_1.properties = cjson.decode(var_80_1)
		end

		local var_80_2 = var_80_0.traits

		if var_80_2 then
			arg_80_1.traits = cjson.decode(var_80_2)
		end

		local var_80_3 = var_80_0.power_level

		if var_80_3 then
			arg_80_1.power_level = tonumber(var_80_3)
		end

		local var_80_4 = var_80_0.rarity

		if var_80_4 then
			arg_80_1.rarity = var_80_4
		end

		local var_80_5 = var_80_0.skin

		if var_80_5 then
			arg_80_1.skin = var_80_5
		end

		local var_80_6 = var_80_0.level_key

		if var_80_6 then
			arg_80_1.level_key = var_80_6
		end

		local var_80_7 = var_80_0.difficulty

		if var_80_7 then
			arg_80_1.difficulty = var_80_7
		end

		local var_80_8 = var_80_0.magic_level

		if var_80_8 then
			arg_80_1.magic_level = tonumber(var_80_8)
			arg_80_1.power_level = WeaveUtils.magic_level_to_power_level(arg_80_1.magic_level)
		end
	end

	local var_80_9 = arg_80_1.ItemId
	local var_80_10 = ItemMasterList[var_80_9]

	if not arg_80_1.rarity then
		arg_80_1.rarity = var_80_10.rarity
	end

	arg_80_1.backend_id = arg_80_2
	arg_80_1.key = var_80_9
	arg_80_1.data = var_80_10
end

PlayFabMirrorBase.ready = function (arg_81_0)
	return arg_81_0._inventory_items and arg_81_0._num_items_to_load == 0
end

PlayFabMirrorBase.current_api_call = function (arg_82_0)
	if not arg_82_0._request_queue then
		return
	end

	return arg_82_0._request_queue:current_api_call()
end

PlayFabMirrorBase.update = function (arg_83_0, arg_83_1, arg_83_2)
	local var_83_0
	local var_83_1

	if arg_83_0._request_queue_error then
		return
	else
		local var_83_2

		var_83_0, var_83_2 = arg_83_0._request_queue:update(arg_83_1, arg_83_2)
	end

	if var_83_0 then
		arg_83_0._request_queue_error = var_83_0

		if var_83_0 == "request_timed_out" then
			Managers.backend:request_timeout()
		end

		return
	end

	if arg_83_0._commit_current_id then
		arg_83_0:_check_current_commit()
	end

	local var_83_3 = arg_83_0._queued_commit

	if var_83_3.active then
		var_83_3.timer = var_83_3.timer - arg_83_1

		if var_83_3.timer <= 0 and not arg_83_0._commit_current_id and not Managers.account:user_detached() and LobbyInternal.network_initialized() then
			arg_83_0:_commit_internal(var_83_3.id, var_83_3.commit_complete_callbacks)
		end
	end

	arg_83_0._commit_limit_timer = arg_83_0._commit_limit_timer - arg_83_1

	if arg_83_0._commit_limit_timer <= 0 then
		arg_83_0._commit_limit_timer = var_0_3
		arg_83_0._commit_limit_total = math.max(arg_83_0._commit_limit_total - 1, 1)
	end
end

PlayFabMirrorBase._check_current_commit = function (arg_84_0)
	local var_84_0 = arg_84_0:_commit_status()

	if var_84_0 ~= "waiting" then
		local var_84_1 = arg_84_0._commit_current_id
		local var_84_2 = arg_84_0._commits[var_84_1]

		var_0_6("commit result %q, %q", var_84_0, var_84_1)

		arg_84_0._commit_current_id = nil

		if var_84_0 == "commit_error" then
			arg_84_0._commit_error = true
		else
			Managers.backend:dirtify_interfaces()
		end

		if var_84_2.commit_complete_callbacks then
			for iter_84_0 = 1, #var_84_2.commit_complete_callbacks do
				var_84_2.commit_complete_callbacks[iter_84_0](var_84_0)
			end
		end

		arg_84_0._commits[var_84_1] = nil
	end
end

PlayFabMirrorBase._commit_status = function (arg_85_0)
	local var_85_0 = arg_85_0._commit_current_id

	fassert(var_85_0, "Querying status for commit_current_id %s", tostring(var_85_0))

	local var_85_1 = arg_85_0._commits[var_85_0]

	fassert(var_85_1, "No commit with id %d", var_85_0)

	if var_85_1.status == "commit_error" then
		return "commit_error"
	elseif var_85_1.num_updates == var_85_1.updates_to_make and not var_85_1.wait_for_stats and not var_85_1.wait_for_weave_user_data and not var_85_1.wait_for_keep_decorations and not var_85_1.wait_for_user_data and not var_85_1.wait_for_read_only_data and not var_85_1.wait_for_win_tracks_data and not var_85_1.wait_for_gotwf_data and not var_85_1.wait_for_weapon_pose_skin_data then
		if IS_CONSOLE and not Managers.account:offline_mode() then
			PlayfabBackendSaveDataUtils.store_online_data(arg_85_0)
		end

		return "success"
	end

	return var_85_1.status
end

PlayFabMirrorBase.get_current_commit_id = function (arg_86_0)
	return arg_86_0._commit_current_id
end

PlayFabMirrorBase.have_queued_commit = function (arg_87_0)
	return not table.is_empty(arg_87_0._queued_commit)
end

PlayFabMirrorBase.request_queue = function (arg_88_0)
	return arg_88_0._request_queue
end

PlayFabMirrorBase.get_playfab_id = function (arg_89_0)
	return arg_89_0._playfab_id
end

PlayFabMirrorBase.get_character_data = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	local var_90_0 = arg_90_0._career_data
	local var_90_1 = arg_90_3 or arg_90_0._career_loadouts[arg_90_1]
	local var_90_2 = var_90_0[arg_90_1] and var_90_0[arg_90_1][var_90_1]

	if var_90_2 ~= nil then
		return var_90_2[arg_90_2]
	end

	return nil
end

PlayFabMirrorBase.has_loadout = function (arg_91_0, arg_91_1, arg_91_2)
	local var_91_0 = arg_91_0._career_data

	return (var_91_0[arg_91_1] and var_91_0[arg_91_1][arg_91_2]) ~= nil
end

PlayFabMirrorBase.set_character_data = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
	local var_92_0 = arg_92_0._career_data[arg_92_1]
	local var_92_1 = arg_92_5 or arg_92_0._career_loadouts[arg_92_1]

	var_92_0[var_92_1][arg_92_2] = arg_92_3

	if arg_92_4 then
		arg_92_0._career_data_mirror[arg_92_1][var_92_1][arg_92_2] = arg_92_3
	end

	local var_92_2 = PROFILES_BY_CAREER_NAMES[arg_92_1].display_name

	arg_92_0:set_career_read_only_data(var_92_2, arg_92_2, arg_92_3, arg_92_1, arg_92_4, var_92_1)
end

PlayFabMirrorBase.get_career_loadouts = function (arg_93_0, arg_93_1)
	if not arg_93_1 then
		return nil
	end

	local var_93_0 = arg_93_0._career_data[arg_93_1]

	return arg_93_0._career_loadouts[arg_93_1], var_93_0
end

PlayFabMirrorBase.get_default_loadouts = function (arg_94_0, arg_94_1)
	local var_94_0 = Managers.mechanism:current_mechanism_name()

	if not arg_94_1 or not var_94_0 then
		return nil
	end

	return (arg_94_0._character_default_loadouts[var_94_0] or arg_94_0._character_default_loadouts.adventure)[arg_94_1]
end

PlayFabMirrorBase.set_loadout_index = function (arg_95_0, arg_95_1, arg_95_2)
	if not arg_95_1 or not arg_95_2 then
		return
	end

	if arg_95_0._career_data[arg_95_1][arg_95_2] then
		arg_95_0._career_loadouts[arg_95_1] = arg_95_2

		local var_95_0 = PROFILES_BY_CAREER_NAMES[arg_95_1]
		local var_95_1 = var_95_0.index
		local var_95_2 = var_95_0.display_name
		local var_95_3 = career_index_from_name(var_95_1, arg_95_1)
		local var_95_4 = arg_95_0._characters_data

		var_95_4[var_95_2].loadouts[var_95_3] = arg_95_2

		local var_95_5 = cjson.encode(var_95_4)

		arg_95_0:set_read_only_data(arg_95_0._characters_data_key, var_95_5, false)
		Managers.backend:dirtify_interfaces()
	end
end

PlayFabMirrorBase.delete_loadout = function (arg_96_0, arg_96_1, arg_96_2)
	if not arg_96_1 or not arg_96_2 then
		return
	end

	local var_96_0, var_96_1 = arg_96_0:get_career_loadouts(arg_96_1)

	if arg_96_2 > #var_96_1 then
		return
	end

	if #var_96_1 == 1 then
		return
	end

	local var_96_2 = PROFILES_BY_CAREER_NAMES[arg_96_1]
	local var_96_3 = var_96_2.index
	local var_96_4 = var_96_2.display_name
	local var_96_5 = career_index_from_name(var_96_3, arg_96_1)
	local var_96_6 = arg_96_0._characters_data
	local var_96_7 = var_96_6[var_96_4]
	local var_96_8 = var_96_7.careers[arg_96_1]

	table.remove(var_96_8, arg_96_2)
	table.remove(var_96_1, arg_96_2)

	if arg_96_2 == var_96_0 then
		arg_96_0._career_loadouts[arg_96_1] = 1
		var_96_7.loadouts[var_96_5] = 1
	else
		local var_96_9 = math.clamp(var_96_0, 1, #var_96_1)

		arg_96_0._career_loadouts[arg_96_1] = var_96_9
		var_96_7.loadouts[var_96_5] = var_96_9
	end

	local var_96_10 = cjson.encode(var_96_6)

	arg_96_0:set_read_only_data(arg_96_0._characters_data_key, var_96_10, false)
	Managers.backend:dirtify_interfaces()
end

PlayFabMirrorBase.add_loadout = function (arg_97_0, arg_97_1)
	if not arg_97_1 then
		return
	end

	local var_97_0, var_97_1 = arg_97_0:get_career_loadouts(arg_97_1)
	local var_97_2 = var_97_1[var_97_0]

	if #var_97_1 < InventorySettings.MAX_NUM_CUSTOM_LOADOUTS then
		local var_97_3 = PROFILES_BY_CAREER_NAMES[arg_97_1]
		local var_97_4 = var_97_3.index
		local var_97_5 = var_97_3.display_name
		local var_97_6 = career_index_from_name(var_97_4, arg_97_1)
		local var_97_7 = var_97_0 + 1
		local var_97_8 = table.clone(var_97_2)

		var_97_1[#var_97_1 + 1] = var_97_8
		arg_97_0._career_loadouts[arg_97_1] = var_97_7

		local var_97_9 = arg_97_0._characters_data
		local var_97_10 = var_97_9[var_97_5]
		local var_97_11 = var_97_10.careers[arg_97_1]

		var_97_11[#var_97_11 + 1] = table.clone(var_97_8)
		var_97_10.loadouts[var_97_6] = var_97_7

		local var_97_12 = cjson.encode(var_97_9)

		arg_97_0:set_read_only_data(arg_97_0._characters_data_key, var_97_12, false)
		Managers.backend:dirtify_interfaces()
	end
end

PlayFabMirrorBase.get_title_data = function (arg_98_0)
	return arg_98_0._title_data
end

PlayFabMirrorBase.set_title_data = function (arg_99_0, arg_99_1, arg_99_2)
	if tonumber(arg_99_2) then
		arg_99_2 = tonumber(arg_99_2)
	end

	arg_99_0._title_data[arg_99_1] = arg_99_2
end

PlayFabMirrorBase.get_user_data = function (arg_100_0, arg_100_1)
	return arg_100_0._user_data[arg_100_1]
end

PlayFabMirrorBase.set_user_data = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	arg_101_0._user_data[arg_101_1] = arg_101_2

	if arg_101_3 then
		if type(arg_101_2) == "table" then
			arg_101_0._user_data_mirror[arg_101_1] = table.clone(arg_101_2)
		else
			arg_101_0._user_data_mirror[arg_101_1] = arg_101_2
		end
	end
end

PlayFabMirrorBase.log_player_exit = function (arg_102_0, arg_102_1)
	local var_102_0 = {
		FunctionName = "logPlayerExit",
		FunctionParameter = {}
	}
	local var_102_1 = callback(arg_102_0, "log_player_exit_cb", arg_102_1)
	local var_102_2 = arg_102_0._request_queue:enqueue(var_102_0, var_102_1, false)
end

PlayFabMirrorBase.log_player_exit_cb = function (arg_103_0, arg_103_1, arg_103_2)
	arg_103_1(arg_103_2)
end

PlayFabMirrorBase._commit_user_data = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
	table.clear(arg_104_1)

	for iter_104_0, iter_104_1 in pairs(arg_104_0._user_data) do
		if arg_104_0._user_data_mirror[iter_104_0] ~= iter_104_1 then
			arg_104_1[iter_104_0] = iter_104_1
		end
	end

	if not table.is_empty(arg_104_1) then
		local var_104_0 = {
			Data = arg_104_1
		}

		arg_104_0._user_data_mirror = table.clone(arg_104_0._user_data)

		local var_104_1 = callback(arg_104_0, "update_user_data_cb", arg_104_3)

		var_0_0.UpdateUserData(var_104_0, var_104_1)

		arg_104_0._num_items_to_load = arg_104_0._num_items_to_load + 1
		arg_104_2.status = "waiting"
		arg_104_2.wait_for_user_data = true
	end
end

PlayFabMirrorBase.update_user_data_cb = function (arg_105_0, arg_105_1, arg_105_2)
	arg_105_0._num_items_to_load = arg_105_0._num_items_to_load - 1
	arg_105_0._commits[arg_105_1].wait_for_user_data = false
end

PlayFabMirrorBase.get_read_only_data = function (arg_106_0, arg_106_1)
	local var_106_0 = arg_106_0._read_only_data[arg_106_1]
	local var_106_1 = type(var_106_0)

	var_0_7(var_106_0 == nil or var_0_2[var_106_1], "Tried to get read_only_data's '%s'. Got value '%s' ('%s')", arg_106_1, tostring(var_106_0), var_106_1)

	return var_106_0
end

PlayFabMirrorBase.set_read_only_data = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
	if not arg_107_3 and rawget(_G, "debug_characters_data_unsafe_write") and (arg_107_1 == "characters_data" or arg_107_1 == "vs_characters_data") then
		print("[PlayfabMirrorBase] Overwriting character data while it is unsafe to do so")
		Crashify.print_exception("[PlayfabMirrorBase]", "Unsafe write to readonly data")
	end

	local var_107_0 = type(arg_107_2)

	var_0_7(var_0_2[var_107_0], "Tried to set read_only_data's '%s' to value '%s' ('%s')", arg_107_1, tostring(arg_107_2), var_107_0)

	arg_107_0._read_only_data[arg_107_1] = arg_107_2

	if arg_107_3 then
		if var_107_0 == "table" then
			arg_107_0._read_only_data_mirror[arg_107_1] = table.clone(arg_107_2)
		else
			arg_107_0._read_only_data_mirror[arg_107_1] = arg_107_2
		end
	end
end

PlayFabMirrorBase.merge_read_only_data = function (arg_108_0, arg_108_1, arg_108_2)
	for iter_108_0, iter_108_1 in pairs(arg_108_1) do
		local var_108_0 = type(iter_108_1)

		var_0_7(var_0_2[var_108_0], "Tried to merge read_only_data's '%s' with value '%s' ('%s')", iter_108_0, tostring(iter_108_1), var_108_0)
	end

	table.merge_recursive(arg_108_0._read_only_data, arg_108_1)

	if arg_108_2 then
		table.merge_recursive(arg_108_0._read_only_data_mirror, arg_108_1)
	end
end

PlayFabMirrorBase.get_all_inventory_items = function (arg_109_0)
	return arg_109_0._inventory_items
end

PlayFabMirrorBase.get_all_fake_inventory_items = function (arg_110_0)
	return arg_110_0._fake_inventory_items
end

PlayFabMirrorBase.get_stats = function (arg_111_0)
	return arg_111_0._stats
end

PlayFabMirrorBase.set_stats = function (arg_112_0, arg_112_1)
	arg_112_0._stats = arg_112_1
end

PlayFabMirrorBase.get_claimed_achievements = function (arg_113_0)
	return arg_113_0._claimed_achievements
end

PlayFabMirrorBase.get_claimed_event_quests = function (arg_114_0)
	return arg_114_0._claimed_event_quests
end

PlayFabMirrorBase.add_claimed_event_quest = function (arg_115_0, arg_115_1)
	arg_115_0._claimed_event_quests[arg_115_1] = true
end

PlayFabMirrorBase.add_claimed_multiple_event_quests = function (arg_116_0, arg_116_1)
	for iter_116_0 = 1, #arg_116_1 do
		local var_116_0 = arg_116_1[iter_116_0]

		arg_116_0._claimed_event_quests[var_116_0] = true
	end
end

PlayFabMirrorBase.get_achievement_rewards = function (arg_117_0)
	return arg_117_0._achievement_rewards
end

PlayFabMirrorBase.get_weaves_progression_settings = function (arg_118_0)
	return arg_118_0._weaves_progression_settings
end

PlayFabMirrorBase.get_unlocked_weapon_skins = function (arg_119_0)
	return arg_119_0._unlocked_weapon_skins
end

PlayFabMirrorBase.get_unlocked_cosmetics = function (arg_120_0)
	return arg_120_0._unlocked_cosmetics
end

PlayFabMirrorBase.get_unlocked_weapon_poses = function (arg_121_0)
	return arg_121_0._unlocked_weapon_poses
end

PlayFabMirrorBase.get_equipped_weapon_pose_skins = function (arg_122_0)
	return arg_122_0._equipped_weapon_pose_skins
end

PlayFabMirrorBase.get_equipped_weapon_pose_skin = function (arg_123_0, arg_123_1)
	return arg_123_0._equipped_weapon_pose_skins[arg_123_1]
end

PlayFabMirrorBase.set_weapon_pose_skin = function (arg_124_0, arg_124_1, arg_124_2)
	arg_124_0._equipped_weapon_pose_skins[arg_124_1] = arg_124_2
end

PlayFabMirrorBase.get_unlocked_keep_decorations = function (arg_125_0)
	return arg_125_0._unlocked_keep_decorations
end

PlayFabMirrorBase.get_owned_dlcs = function (arg_126_0)
	return arg_126_0._owned_dlcs
end

PlayFabMirrorBase.get_platform_dlcs = function (arg_127_0)
	return arg_127_0._platform_dlcs
end

PlayFabMirrorBase.set_owned_dlcs = function (arg_128_0, arg_128_1)
	arg_128_0._owned_dlcs = arg_128_1
end

PlayFabMirrorBase.set_platform_dlcs = function (arg_129_0, arg_129_1)
	arg_129_0._platform_dlcs = arg_129_1
end

PlayFabMirrorBase.add_keep_decoration = function (arg_130_0, arg_130_1)
	arg_130_0._unlocked_keep_decorations[#arg_130_0._unlocked_keep_decorations + 1] = arg_130_1

	ItemHelper.mark_keep_decoration_as_new(arg_130_1)
end

local var_0_9 = {}

PlayFabMirrorBase._create_fake_inventory_items = function (arg_131_0, arg_131_1, arg_131_2)
	table.clear(var_0_9)

	local var_131_0

	if arg_131_2 == "weapon_skins" then
		var_131_0 = arg_131_0._unlocked_weapon_skins

		local var_131_1 = WeaponSkins

		for iter_131_0, iter_131_1 in pairs(arg_131_1) do
			local var_131_2, var_131_3 = var_131_1.matching_weapon_skin_item_key(iter_131_0)

			if var_131_2 and rawget(ItemMasterList, var_131_2) then
				if var_131_3 and var_131_3 == "bogenhafen" then
					var_131_3 = "unique"
				end

				var_0_9[#var_0_9 + 1] = {
					ItemId = var_131_2,
					ItemInstanceId = type(iter_131_1) == "string" and iter_131_1 or var_0_5(),
					CustomData = {
						skin = iter_131_0,
						rarity = var_131_3
					}
				}
			else
				var_131_0[iter_131_0] = nil
			end
		end
	elseif arg_131_2 == "cosmetics" then
		var_131_0 = arg_131_0._unlocked_cosmetics

		for iter_131_2, iter_131_3 in pairs(arg_131_1) do
			local var_131_4 = rawget(ItemMasterList, iter_131_2)

			if var_131_4 then
				local var_131_5 = var_131_0[iter_131_2]
				local var_131_6
				local var_131_7

				if type(var_131_5) == "string" then
					var_131_6 = var_131_5
				elseif type(iter_131_3) == "string" then
					var_131_6 = iter_131_3

					if var_131_4.steam_itemdefid ~= nil then
						var_131_7 = var_131_6
					end
				else
					var_131_6 = var_0_5()
				end

				var_0_9[#var_0_9 + 1] = {
					ItemId = iter_131_2,
					ItemInstanceId = var_131_6,
					override_id = var_131_7
				}
			else
				var_131_0[iter_131_2] = nil
			end
		end
	elseif arg_131_2 == "weapon_poses" then
		var_131_0 = arg_131_0._unlocked_weapon_poses

		for iter_131_4, iter_131_5 in pairs(arg_131_1) do
			for iter_131_6, iter_131_7 in pairs(iter_131_5) do
				local var_131_8 = rawget(ItemMasterList, iter_131_6)

				if var_131_8 then
					local var_131_9 = var_131_8.parent
					local var_131_10 = var_131_0[var_131_9] and var_131_0[var_131_9][iter_131_6]
					local var_131_11

					if type(var_131_10) == "string" then
						var_131_11 = var_131_10
					else
						var_131_11 = var_0_5()
					end

					var_0_9[#var_0_9 + 1] = {
						ItemId = iter_131_6,
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

	if not arg_131_0._inventory_items then
		arg_131_0._inventory_items = {}
	end

	local var_131_12 = {}

	for iter_131_8 = 1, #var_0_9 do
		local var_131_13 = var_0_9[iter_131_8]
		local var_131_14 = var_131_13.ItemInstanceId
		local var_131_15 = var_131_13.override_id or var_131_13.CustomData and var_131_13.CustomData.skin or var_131_13.ItemId

		if arg_131_2 == "weapon_poses" then
			local var_131_16 = var_131_13.ItemId

			var_131_0[ItemMasterList[var_131_16].parent][var_131_16] = var_131_14
		else
			var_131_0[var_131_15] = var_131_14
		end

		arg_131_0:_update_data(var_131_13, var_131_14)

		arg_131_0._inventory_items[var_131_14] = var_131_13
		arg_131_0._fake_inventory_items[var_131_14] = var_131_13
		var_131_12[#var_131_12 + 1] = var_131_14
	end

	return var_131_12
end

PlayFabMirrorBase.set_achievement_claimed = function (arg_132_0, arg_132_1)
	arg_132_0._claimed_achievements[arg_132_1] = true
end

PlayFabMirrorBase.get_claimed_console_dlc_rewards = function (arg_133_0)
	return arg_133_0._claimed_console_dlc_rewards
end

PlayFabMirrorBase.set_console_dlc_reward_claimed = function (arg_134_0, arg_134_1, arg_134_2)
	arg_134_0._claimed_console_dlc_rewards[arg_134_1] = arg_134_2 and true or nil
end

PlayFabMirrorBase.get_quest_data = function (arg_135_0)
	return arg_135_0._quest_data
end

PlayFabMirrorBase.set_quest_data = function (arg_136_0, arg_136_1, arg_136_2)
	arg_136_0._quest_data[arg_136_1] = arg_136_2
end

PlayFabMirrorBase.check_for_errors = function (arg_137_0)
	return
end

local var_0_10 = {
	ranged = "best_ranged_pl",
	ring = "best_ring_pl",
	necklace = "best_necklace_pl",
	trinket = "best_trinket_pl",
	melee = "best_melee_pl"
}

PlayFabMirrorBase._re_evaluate_best_power_level = function (arg_138_0, arg_138_1)
	local var_138_0 = arg_138_1.power_level

	if not var_138_0 then
		return
	end

	local var_138_1 = arg_138_1.data.slot_type
	local var_138_2 = var_0_10[var_138_1]

	if not var_138_2 then
		return
	end

	local var_138_3 = arg_138_0._best_power_levels

	if var_138_0 > var_138_3[var_138_2] then
		var_138_3[var_138_2] = var_138_0

		local var_138_4 = 0

		for iter_138_0, iter_138_1 in pairs(var_138_3) do
			var_138_4 = var_138_4 + iter_138_1
		end

		arg_138_0.sum_best_power_levels = var_138_4
	end
end

PlayFabMirrorBase._add_new_weapon_skin = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3)
	local var_139_0
	local var_139_1 = arg_139_3 or arg_139_1.ItemId

	if not arg_139_2 and Managers.account:offline_mode() then
		local var_139_2 = arg_139_0:add_unlocked_weapon_skin(var_139_1, arg_139_1.ItemInstanceId)

		var_139_0 = var_139_2 and var_139_2[1]
	else
		local var_139_3 = arg_139_0:add_unlocked_weapon_skin(var_139_1)

		var_139_0 = var_139_3 and var_139_3[1]
	end

	return var_139_0
end

PlayFabMirrorBase.add_item = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3, arg_140_4)
	if not arg_140_0._inventory_items then
		arg_140_0._inventory_items = {}
	end

	if WeaponSkins.skins[arg_140_2.ItemId] then
		return arg_140_0:_add_new_weapon_skin(arg_140_2)
	else
		local var_140_0 = ItemMasterList[arg_140_2.ItemId]

		if CosmeticUtils.is_cosmetic_item(var_140_0.slot_type) then
			arg_140_1 = arg_140_0:add_unlocked_cosmetic(arg_140_2.ItemId, arg_140_1)

			if not arg_140_4 then
				ItemHelper.mark_backend_id_as_new(arg_140_1, arg_140_0._inventory_items[arg_140_1], arg_140_3)
			end

			return arg_140_1
		end

		if CosmeticUtils.is_weapon_pose(var_140_0) then
			arg_140_1 = arg_140_0:add_unlocked_weapon_pose(arg_140_2.ItemId, arg_140_1)

			if not arg_140_4 then
				ItemHelper.mark_backend_id_as_new(arg_140_1, arg_140_0._inventory_items[arg_140_1], arg_140_3)
			end

			return arg_140_1
		end

		arg_140_0._inventory_items[arg_140_1] = arg_140_2

		arg_140_0:_update_data(arg_140_2, arg_140_1)

		if not arg_140_4 then
			ItemHelper.mark_backend_id_as_new(arg_140_1, arg_140_2, arg_140_3)
		end

		arg_140_0:_re_evaluate_best_power_level(arg_140_2)
		ItemHelper.on_inventory_item_added(arg_140_2)

		local var_140_1 = arg_140_2.CustomData and arg_140_2.CustomData.skin

		if var_140_1 and WeaponSkins.skins[var_140_1] then
			local var_140_2 = arg_140_0:get_unlocked_weapon_skins()

			arg_140_0:_add_new_weapon_skin(arg_140_2, true, var_140_1)
		end
	end
end

PlayFabMirrorBase.remove_item = function (arg_141_0, arg_141_1)
	local var_141_0 = arg_141_0._inventory_items

	if ItemHelper.is_new_backend_id(arg_141_1) then
		ItemHelper.unmark_backend_id_as_new(arg_141_1)
	end

	var_141_0[arg_141_1] = nil
end

PlayFabMirrorBase.update_item_field = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3)
	local var_142_0 = arg_142_0._inventory_items[arg_142_1]

	fassert(var_142_0[arg_142_2], "Trying to update a field on an item in playfab_mirror_base.lua that does not exist on the item")

	var_142_0[arg_142_2] = arg_142_3
end

PlayFabMirrorBase.update_item = function (arg_143_0, arg_143_1, arg_143_2)
	local var_143_0 = arg_143_0._inventory_items

	fassert(var_143_0[arg_143_1], "Trying to update an item that does not exist with backend ID %s", arg_143_1)

	var_143_0[arg_143_1] = arg_143_2

	arg_143_0:_update_data(arg_143_2, arg_143_1)
end

PlayFabMirrorBase.add_unlocked_weapon_skin = function (arg_144_0, arg_144_1, arg_144_2)
	if arg_144_0._unlocked_weapon_skins then
		local var_144_0 = arg_144_0._unlocked_weapon_skins[arg_144_1]

		if var_144_0 then
			return {
				var_144_0
			}
		end

		arg_144_0._unlocked_weapon_skins[arg_144_1] = true

		return arg_144_0:_create_fake_inventory_items({
			[arg_144_1] = arg_144_2 or true
		}, "weapon_skins")
	else
		var_0_7(false, "Tried to add_unlocked_weapon_skin '%s' before unlocked_weapon_skins was created", arg_144_1)
	end
end

PlayFabMirrorBase.add_unlocked_cosmetic = function (arg_145_0, arg_145_1, arg_145_2)
	if arg_145_0._unlocked_cosmetics then
		local var_145_0 = arg_145_0:_create_fake_inventory_items({
			[arg_145_1] = arg_145_2 or true
		}, "cosmetics")

		if #var_145_0 > 0 then
			arg_145_0._unlocked_cosmetics[arg_145_1] = var_145_0[1]

			return var_145_0[1]
		end
	else
		var_0_7(false, "Tried to add_unlocked_cosmetics '%s' before unlocked_cosmetics was created", arg_145_1)
	end
end

PlayFabMirrorBase.add_unlocked_weapon_pose = function (arg_146_0, arg_146_1, arg_146_2)
	if arg_146_0._unlocked_weapon_poses then
		local var_146_0 = arg_146_0:_create_fake_inventory_items({
			[arg_146_1] = arg_146_2 or true
		}, "cosmetics")

		if #var_146_0 > 0 then
			local var_146_1 = ItemMasterList[arg_146_1].parent

			arg_146_0._unlocked_weapon_poses[var_146_1] = arg_146_0._unlocked_weapon_poses[var_146_1] or {}
			arg_146_0._unlocked_weapon_poses[var_146_1][arg_146_1] = var_146_0[1]

			return var_146_0[1]
		end
	else
		var_0_7(false, "Tried to add_unlocked_weapon_pose '%s' before unlocked_weapon_poses was created", arg_146_1)
	end
end

PlayFabMirrorBase.set_essence = function (arg_147_0, arg_147_1)
	arg_147_0._essence = arg_147_1
end

PlayFabMirrorBase.get_essence = function (arg_148_0)
	return arg_148_0._essence
end

PlayFabMirrorBase.set_total_essence = function (arg_149_0, arg_149_1)
	arg_149_0._total_essence = arg_149_1
end

PlayFabMirrorBase.get_total_essence = function (arg_150_0)
	return arg_150_0._total_essence
end

PlayFabMirrorBase.set_maximum_essence = function (arg_151_0, arg_151_1)
	arg_151_0._maximum_essence = arg_151_1
end

PlayFabMirrorBase.get_maximum_essence = function (arg_152_0)
	return arg_152_0._maximum_essence
end

PlayFabMirrorBase.get_deus_rolled_over_soft_currency = function (arg_153_0)
	return arg_153_0._deus_rolled_over_soft_currency or 0
end

PlayFabMirrorBase.get_deus_journey_cycle_data = function (arg_154_0)
	return arg_154_0._deus_journey_cycle_data
end

PlayFabMirrorBase.get_deus_belakor_curse_data = function (arg_155_0)
	return arg_155_0._deus_belakor_curse_data
end

PlayFabMirrorBase.handle_deus_result = function (arg_156_0, arg_156_1)
	local var_156_0 = arg_156_1.FunctionResult
	local var_156_1 = var_156_0.deus_journey_cycle_data
	local var_156_2 = var_156_0.deus_rolled_over_soft_currency

	if var_156_2 then
		arg_156_0._deus_rolled_over_soft_currency = var_156_2
	end

	if var_156_1 then
		local var_156_3 = Managers.time:time("main")

		arg_156_0._deus_journey_cycle_data = {
			span = var_156_1.span_ms / 1000,
			remaining_time = var_156_1.remaining_time_ms / 1000,
			cycle_count = var_156_1.cycle_count,
			time_of_update = var_156_3
		}
	end
end

PlayFabMirrorBase.predict_deus_rolled_over_soft_currency = function (arg_157_0, arg_157_1)
	local var_157_0 = math.ceil(arg_157_1 * DeusRollOverSettings.roll_over)

	arg_157_0._deus_rolled_over_soft_currency = math.clamp(var_157_0, 0, DeusRollOverSettings.max)
end

PlayFabMirrorBase.predict_deus_run_started = function (arg_158_0)
	arg_158_0._deus_rolled_over_soft_currency = 0
end

PlayFabMirrorBase.predict_debug_clear_deus_meta_progression = function (arg_159_0, arg_159_1)
	arg_159_0._deus_rolled_over_soft_currency = 0
end

local function var_0_11(arg_160_0, arg_160_1)
	if not arg_160_1 then
		return
	end

	arg_160_0.commit_complete_callbacks = arg_160_0.commit_complete_callbacks or {}
	arg_160_0.commit_complete_callbacks[#arg_160_0.commit_complete_callbacks + 1] = arg_160_1

	return arg_160_0.commit_complete_callbacks
end

PlayFabMirrorBase.commit = function (arg_161_0, arg_161_1, arg_161_2)
	local var_161_0 = arg_161_0._queued_commit
	local var_161_1

	if arg_161_1 then
		if arg_161_0._commit_current_id then
			var_0_6("Unable to skip queue: commit already in progress")

			var_161_1 = arg_161_0:_queue_commit(arg_161_2)
		elseif not rawget(_G, "LobbyInternal") or not LobbyInternal.network_initialized() then
			var_0_6("Unable to skip queue: Network not initialized")

			var_161_1 = arg_161_0:_queue_commit(arg_161_2)
		elseif var_161_0.active then
			local var_161_2 = var_161_0.id

			var_0_6("Force commit: Override existing queue %q", var_161_2)
			var_0_11(var_161_0, arg_161_2)
			arg_161_0:_commit_internal(var_161_2, var_161_0.commit_complete_callbacks)
		else
			var_0_6("Force commit")
			var_0_11(var_161_0, arg_161_2)

			var_161_1 = arg_161_0:_commit_internal(nil, var_161_0.commit_complete_callbacks)
		end
	elseif not var_161_0.active then
		if arg_161_2 then
			var_0_11(var_161_0, arg_161_2)
		end

		var_161_1 = arg_161_0:_queue_commit(arg_161_2, var_161_0.commit_complete_callbacks)
	elseif arg_161_2 then
		var_0_11(var_161_0, arg_161_2)
	end

	if var_161_1 then
		arg_161_0._commit_limit_total = arg_161_0._commit_limit_total + 1
	end

	return var_161_1 or var_161_0.id
end

PlayFabMirrorBase._new_id = function (arg_162_0)
	arg_162_0._last_id = arg_162_0._last_id + 1

	return arg_162_0._last_id
end

PlayFabMirrorBase._queue_commit = function (arg_163_0, arg_163_1)
	local var_163_0 = arg_163_0._queued_commit
	local var_163_1

	var_163_0.timer, var_163_1 = arg_163_0._commit_limit_total * var_0_4, arg_163_0:_new_id()
	var_163_0.id = var_163_1
	var_163_0.active = true

	var_0_11(var_163_0, arg_163_1)

	return var_163_1
end

local var_0_12 = 25000

local function var_0_13(arg_164_0)
	local var_164_0 = 0
	local var_164_1

	for iter_164_0, iter_164_1 in pairs(arg_164_0) do
		local var_164_2 = #cjson.encode(iter_164_1)

		assert(var_164_2 <= var_0_12, "Exceeding max size")

		if var_164_0 + var_164_2 > var_0_12 then
			var_164_1 = var_164_1 or {}
			var_164_1[iter_164_0] = iter_164_1
			arg_164_0[iter_164_0] = nil
		else
			var_164_0 = var_164_0 + var_164_2
		end
	end

	return arg_164_0, var_164_1
end

local var_0_14 = {}

PlayFabMirrorBase._commit_internal = function (arg_165_0, arg_165_1, arg_165_2)
	var_0_6("_commit_internal %q", arg_165_1)

	local var_165_0 = arg_165_1 or arg_165_0:_new_id()
	local var_165_1 = {
		num_updates = 0,
		status = "success",
		updates_to_make = 0,
		commit_complete_callbacks = arg_165_2,
		request_queue_ids = {},
		current_characters_data_key = arg_165_0._characters_data_key
	}

	table.clear(arg_165_0._queued_commit)

	arg_165_0._commit_current_id = var_165_0

	local var_165_2 = Managers.backend:get_interface("statistics")

	if Managers.level_transition_handler:in_hub_level() then
		var_165_2:save()
	end

	local var_165_3, var_165_4 = var_165_2:get_stat_save_request()

	if var_165_3 and not script_data["eac-untrusted"] then
		local var_165_5 = callback(arg_165_0, "save_statistics_cb", var_165_0, var_165_4)
		local var_165_6 = arg_165_0._request_queue:enqueue(var_165_3, var_165_5, true)

		arg_165_0._num_items_to_load = arg_165_0._num_items_to_load + 1

		var_165_2:clear_saved_stats()

		var_165_1.status = "waiting"
		var_165_1.wait_for_stats = true
		var_165_1.request_queue_ids[#var_165_1.request_queue_ids + 1] = var_165_6
	end

	if not script_data["eac-untrusted"] then
		local var_165_7 = Managers.backend:get_interface("weaves"):get_dirty_user_data()

		if var_165_7 then
			local var_165_8 = {
				FunctionName = "updateWeaveUserData",
				FunctionParameter = var_165_7
			}
			local var_165_9 = arg_165_0._request_queue:enqueue(var_165_8, callback(arg_165_0, "update_weave_user_data_cb", var_165_0), true)

			arg_165_0._num_items_to_load = arg_165_0._num_items_to_load + 1
			var_165_1.status = "waiting"
			var_165_1.wait_for_weave_user_data = true
			var_165_1.request_queue_ids[#var_165_1.request_queue_ids + 1] = var_165_9
		end
	end

	if not script_data["eac-untrusted"] then
		local var_165_10 = Managers.backend:get_interface("items"):get_dirty_weapon_pose_data()

		if not table.is_empty(var_165_10.equipped_weapon_pose_skin) then
			local var_165_11 = {
				FunctionName = "updateEquippedWeaponPoseSkins",
				FunctionParameter = var_165_10
			}
			local var_165_12 = arg_165_0._request_queue:enqueue(var_165_11, callback(arg_165_0, "update_equipped_weapon_pose_skins_cb", var_165_0), true)

			arg_165_0._num_items_to_load = arg_165_0._num_items_to_load + 1
			var_165_1.status = "waiting"
			var_165_1.wait_for_weapon_pose_skin_data = true
			var_165_1.request_queue_ids[#var_165_1.request_queue_ids + 1] = var_165_12
		end
	end

	table.clear(var_0_14)

	local var_165_13 = arg_165_0._read_only_data_mirror
	local var_165_14 = Managers.backend:get_interface("keep_decorations"):get_keep_decorations_json()

	if var_165_14 ~= var_165_13.keep_decorations then
		var_0_14.keep_decorations = var_165_14
	end

	local var_165_15, var_165_16, var_165_17 = arg_165_0:_check_career_data(arg_165_0._career_data, arg_165_0._career_data_mirror)
	local var_165_18

	if var_165_15 then
		local var_165_19, var_165_20 = var_0_13(var_165_17)

		var_0_14[arg_165_0._characters_data_key] = cjson.encode(var_165_19)
		var_165_18 = var_165_20
	end

	if not table.is_empty(var_0_14) then
		local var_165_21 = {
			FunctionName = "updateHeroAttributes",
			FunctionParameter = {
				hero_attributes = var_0_14
			}
		}
		local var_165_22 = callback(arg_165_0, "update_read_only_data_request_cb", var_165_0, var_165_18)
		local var_165_23 = arg_165_0._request_queue:enqueue(var_165_21, var_165_22, false)

		arg_165_0._num_items_to_load = arg_165_0._num_items_to_load + 1
		var_165_1.status = "waiting"
		var_165_1.wait_for_read_only_data = true
		var_165_1.request_queue_ids[#var_165_1.request_queue_ids + 1] = var_165_23
	end

	arg_165_0:_commit_user_data(var_0_14, var_165_1, var_165_0)

	arg_165_0._commits[var_165_0] = var_165_1

	return var_165_0
end

PlayFabMirrorBase.update_current_win_track_cb = function (arg_166_0, arg_166_1, arg_166_2)
	arg_166_0._num_items_to_load = arg_166_0._num_items_to_load - 1

	local var_166_0 = arg_166_0._commits[arg_166_1]
	local var_166_1 = arg_166_2.FunctionResult.new_read_only_data

	for iter_166_0, iter_166_1 in pairs(var_166_1) do
		local var_166_2 = cjson.encode(iter_166_1)

		arg_166_0:set_read_only_data(iter_166_0, var_166_2, true)
	end

	var_166_0.wait_for_win_tracks_data = false
end

PlayFabMirrorBase.update_current_gotwf_cb = function (arg_167_0, arg_167_1, arg_167_2)
	arg_167_0._num_items_to_load = arg_167_0._num_items_to_load - 1

	local var_167_0 = arg_167_0._commits[arg_167_1]
	local var_167_1 = arg_167_2.FunctionResult.new_read_only_data

	for iter_167_0, iter_167_1 in pairs(var_167_1) do
		local var_167_2 = cjson.encode(iter_167_1)

		arg_167_0:set_read_only_data(iter_167_0, var_167_2, true)
	end

	var_167_0.wait_for_gotwf_data = false
end

PlayFabMirrorBase.update_read_only_data_request_cb = function (arg_168_0, arg_168_1, arg_168_2, arg_168_3)
	arg_168_0._num_items_to_load = arg_168_0._num_items_to_load - 1

	local var_168_0 = arg_168_0._commits[arg_168_1]
	local var_168_1 = arg_168_3.FunctionResult.hero_attributes

	if var_168_0.current_characters_data_key ~= arg_168_0._characters_data_key then
		Crashify.print_exception("PlayFabMirrorBase", "characters_data_key is not the same as when the request was sent. previous: %s, current: %s", var_168_0.current_characters_data_key, arg_168_0._characters_data_key)

		return
	end

	for iter_168_0, iter_168_1 in pairs(var_168_1) do
		local var_168_2 = tonumber(iter_168_1)

		arg_168_0:set_read_only_data(iter_168_0, var_168_2 or iter_168_1, true)
	end

	local var_168_3 = var_168_1[arg_168_0._characters_data_key]

	if var_168_3 then
		arg_168_0._characters_data_mirror = cjson.decode(var_168_3)

		for iter_168_2, iter_168_3 in pairs(arg_168_0._characters_data_mirror) do
			table.merge_recursive(arg_168_0._career_data_mirror, iter_168_3.careers)

			for iter_168_4, iter_168_5 in pairs(iter_168_3.careers) do
				local var_168_4 = arg_168_0._career_data_mirror[iter_168_4]
				local var_168_5 = iter_168_3.careers[iter_168_4]

				if #var_168_5 < #var_168_4 then
					for iter_168_6 = #var_168_4, 1, -1 do
						if not var_168_5[iter_168_6] then
							arg_168_0._career_data_mirror[iter_168_4][iter_168_6] = nil
						end
					end
				end
			end
		end
	end

	if arg_168_2 then
		local var_168_6, var_168_7 = var_0_13(arg_168_2)
		local var_168_8 = {
			[arg_168_0._characters_data_key] = cjson.encode(var_168_6)
		}

		arg_168_2 = var_168_7

		local var_168_9 = {
			FunctionName = "updateHeroAttributes",
			FunctionParameter = {
				hero_attributes = var_168_8
			}
		}
		local var_168_10 = callback(arg_168_0, "update_read_only_data_request_cb", arg_168_1, arg_168_2)
		local var_168_11 = arg_168_0._request_queue:enqueue(var_168_9, var_168_10, false)

		arg_168_0._num_items_to_load = arg_168_0._num_items_to_load + 1
		var_168_0.status = "waiting"
		var_168_0.request_queue_ids[#var_168_0.request_queue_ids + 1] = var_168_11
	else
		var_168_0.wait_for_read_only_data = false
	end
end

PlayFabMirrorBase.save_statistics_cb = function (arg_169_0, arg_169_1, arg_169_2, arg_169_3)
	arg_169_0._num_items_to_load = arg_169_0._num_items_to_load - 1

	local var_169_0 = arg_169_0._commits[arg_169_1]
	local var_169_1 = Managers.backend:get_interface("statistics")

	if arg_169_2 then
		var_169_1:clear_dirty_flags(arg_169_2)
	end

	local var_169_2 = arg_169_3.FunctionResult
	local var_169_3 = var_169_2 and var_169_2.achievement_reward_levels

	if var_169_3 then
		arg_169_0:set_read_only_data("achievement_reward_levels", var_169_3, true)
	end

	var_169_0.wait_for_stats = false
end

PlayFabMirrorBase.update_weave_user_data_cb = function (arg_170_0, arg_170_1, arg_170_2)
	arg_170_0._num_items_to_load = arg_170_0._num_items_to_load - 1

	local var_170_0 = arg_170_0._commits[arg_170_1]

	var_170_0.wait_for_weave_user_data = false

	if var_170_0.current_characters_data_key ~= arg_170_0._characters_data_key then
		Crashify.print_exception("PlayFabMirrorBase", "characters_data_key is not the same as when the request was sent. previous: %s, current: %s", var_170_0.current_characters_data_key, arg_170_0._characters_data_key)
	end

	Managers.backend:get_interface("weaves"):clear_dirty_user_data()

	local var_170_1 = arg_170_2.FunctionResult.new_read_only_data

	if var_170_1 then
		for iter_170_0, iter_170_1 in pairs(var_170_1) do
			arg_170_0:set_read_only_data(iter_170_0, iter_170_1, true)
		end
	end
end

PlayFabMirrorBase.update_equipped_weapon_pose_skins_cb = function (arg_171_0, arg_171_1, arg_171_2)
	arg_171_0._num_items_to_load = arg_171_0._num_items_to_load - 1
	arg_171_0._commits[arg_171_1].wait_for_weapon_pose_skin_data = false

	Managers.backend:get_interface("items"):clear_dirty_weapon_pose_data()

	local var_171_0 = arg_171_2.FunctionResult.equipped_weapon_pose_skins

	if var_171_0 then
		arg_171_0:set_read_only_data("equipped_weapon_pose_skins", cjson.encode(var_171_0), true)
	end

	arg_171_0:_parse_equipped_weapon_pose_skins()
end

PlayFabMirrorBase.save_keep_decorations_cb = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3)
	arg_172_0._commits[arg_172_1].wait_for_keep_decorations = false
end

PlayFabMirrorBase.wait_for_shutdown = function (arg_173_0, arg_173_1)
	return
end

PlayFabMirrorBase.destroy = function (arg_174_0)
	return
end

PlayFabMirrorBase._get_eac_response = function (arg_175_0, arg_175_1)
	local var_175_0 = 0
	local var_175_1 = ""

	while arg_175_1[tostring(var_175_0)] do
		var_175_1 = var_175_1 .. string.char(arg_175_1[tostring(var_175_0)])
		var_175_0 = var_175_0 + 1
	end

	local var_175_2 = Managers.eac:challenge_response(var_175_1)
	local var_175_3

	if var_175_2 then
		local var_175_4 = 1

		var_175_3 = {}

		while string.byte(var_175_2, var_175_4, var_175_4) do
			local var_175_5 = string.byte(var_175_2, var_175_4, var_175_4)

			var_175_3[tostring(var_175_4 - 1)] = var_175_5
			var_175_4 = var_175_4 + 1
		end
	end

	return var_175_2, var_175_3
end

PlayFabMirrorBase._verify_dlc_careers = function (arg_176_0)
	local var_176_0 = {
		FunctionName = "verifyDlcCareers",
		FunctionParameter = {}
	}
	local var_176_1 = callback(arg_176_0, "verify_dlc_careers_cb")

	arg_176_0._request_queue:enqueue(var_176_0, var_176_1)

	arg_176_0._num_items_to_load = arg_176_0._num_items_to_load + 1
end

PlayFabMirrorBase.verify_dlc_careers_cb = function (arg_177_0, arg_177_1)
	local var_177_0 = arg_177_1.FunctionResult

	if var_177_0.careers_added then
		local var_177_1 = var_177_0.data

		arg_177_0:merge_read_only_data(var_177_1, true)
	end

	arg_177_0._num_items_to_load = arg_177_0._num_items_to_load - 1

	arg_177_0:_setup_careers()
end

PlayFabMirrorBase._setup_careers = function (arg_178_0)
	local var_178_0 = arg_178_0:get_read_only_data(arg_178_0._characters_data_key)
	local var_178_1 = cjson.decode(var_178_0)

	arg_178_0._career_data = {}
	arg_178_0._career_data_mirror = {}
	arg_178_0._career_loadouts = {}
	arg_178_0._career_lookup = {}

	local var_178_2 = {}
	local var_178_3
	local var_178_4 = {
		talents = true
	}
	local var_178_5 = {}

	for iter_178_0, iter_178_1 in pairs(var_178_1) do
		local var_178_6 = FindProfileIndex(iter_178_0)

		if var_178_6 then
			local var_178_7 = SPProfiles[var_178_6]
			local var_178_8 = var_178_5[var_178_7.affiliation]

			if not var_178_8 and arg_178_0._verify_slot_keys_per_affiliation[var_178_7.affiliation] then
				local var_178_9 = table.clone(arg_178_0._verify_slot_keys_per_affiliation[var_178_7.affiliation])

				for iter_178_2 = #var_178_9, 1, -1 do
					if var_178_4[var_178_9[iter_178_2]] then
						table.remove(var_178_9, iter_178_2)
					end
				end

				var_178_5[var_178_7.affiliation] = var_178_9
				var_178_8 = var_178_9
			end

			if var_178_8 then
				local var_178_10 = iter_178_1.loadouts

				for iter_178_3, iter_178_4 in pairs(iter_178_1.careers) do
					if CareerSettings[iter_178_3] then
						arg_178_0._career_data[iter_178_3] = {}
						arg_178_0._career_data_mirror[iter_178_3] = {}

						local var_178_11 = PROFILES_BY_CAREER_NAMES[iter_178_3].index
						local var_178_12 = career_index_from_name(var_178_11, iter_178_3)

						arg_178_0._career_loadouts[iter_178_3] = var_178_10 and var_178_10[var_178_12] or 1

						local var_178_13 = arg_178_0:_set_inital_career_data(iter_178_3, iter_178_4, var_178_8)

						if var_178_13 then
							var_178_2[iter_178_3] = var_178_13

							var_0_6("Broken item slots for career: %q", iter_178_3)
							table.dump(var_178_13, "BROKEN_SLOTS", 2)
						end
					end
				end
			end
		end
	end

	if table.is_empty(var_178_2) then
		rawset(_G, "debug_characters_data_unsafe_write", nil)

		arg_178_0._characters_data = var_178_1
		arg_178_0._characters_data_mirror = table.clone(var_178_1)

		if DEDICATED_SERVER then
			arg_178_0:unequip_disabled_items()
		else
			arg_178_0:_verify_default_gear()
		end
	else
		arg_178_0:_fix_career_data(var_178_2)
	end
end

PlayFabMirrorBase._verify_default_gear = function (arg_179_0)
	local var_179_0 = {
		FunctionName = "verifyDefaultLoadouts",
		FunctionParameter = {
			slots_to_verify = arg_179_0._verify_slot_keys_per_affiliation.heroes
		}
	}
	local var_179_1 = callback(arg_179_0, "verify_default_loadouts_request_cb")

	arg_179_0._request_queue:enqueue(var_179_0, var_179_1)

	arg_179_0._num_items_to_load = arg_179_0._num_items_to_load + 1
end

PlayFabMirrorBase.verify_default_loadouts_request_cb = function (arg_180_0, arg_180_1)
	arg_180_0._num_items_to_load = arg_180_0._num_items_to_load - 1

	local var_180_0 = arg_180_1.FunctionResult
	local var_180_1 = var_180_0.character_default_loadouts
	local var_180_2 = var_180_0.vs_character_default_loadouts

	if var_180_1 then
		arg_180_0:set_read_only_data("character_default_loadouts", cjson.encode(var_180_1), true)
	end

	if var_180_2 then
		arg_180_0:set_read_only_data("vs_character_default_loadouts", cjson.encode(var_180_2), true)
	end

	arg_180_0._character_default_loadouts = {}
	arg_180_0._character_default_loadouts.adventure = var_180_1
	arg_180_0._character_default_loadouts.versus = var_180_2

	if Managers.mechanism:current_mechanism_name() == "adventure" then
		arg_180_0:_check_weaves_loadout()
	else
		arg_180_0:unequip_disabled_items()
	end
end

PlayFabMirrorBase._fix_career_data = function (arg_181_0, arg_181_1, arg_181_2, arg_181_3)
	local var_181_0 = {
		FunctionName = "fixCareerData",
		FunctionParameter = {
			broken_slots = arg_181_1,
			mechanism = arg_181_2 and arg_181_2 or Managers.mechanism:current_mechanism_name()
		}
	}
	local var_181_1 = callback(arg_181_0, arg_181_3 or "fix_career_data_request_cb")

	arg_181_0._request_queue:enqueue(var_181_0, var_181_1)

	arg_181_0._num_items_to_load = arg_181_0._num_items_to_load + 1
end

PlayFabMirrorBase.fix_career_data_request_cb = function (arg_182_0, arg_182_1)
	arg_182_0.broken_slots_data = nil
	arg_182_0._num_items_to_load = arg_182_0._num_items_to_load - 1

	local var_182_0 = arg_182_1.FunctionResult
	local var_182_1 = var_182_0.character_starting_gear
	local var_182_2 = arg_182_0._career_data
	local var_182_3 = arg_182_0._career_data_mirror

	arg_182_0._characters_data = var_182_1
	arg_182_0._characters_data_mirror = table.clone(var_182_1)

	for iter_182_0, iter_182_1 in pairs(var_182_1) do
		local var_182_4 = arg_182_0._characters_data_mirror[iter_182_0]
		local var_182_5 = iter_182_1.careers
		local var_182_6 = var_182_4 and var_182_4.careers

		table.merge_recursive(var_182_2, var_182_5)
		table.merge_recursive(var_182_3, var_182_6)
	end

	arg_182_0:set_read_only_data(arg_182_0._characters_data_key, cjson.encode(var_182_1), true)

	if var_182_0.num_items_granted > 0 then
		local var_182_7 = var_182_0.unlocked_weapon_skins

		if var_182_7 then
			arg_182_0:set_read_only_data("unlocked_weapon_skins", var_182_7, true)

			arg_182_0._unlocked_weapon_skins = arg_182_0:_parse_unlocked_weapon_skins()
		end

		local var_182_8 = var_182_0.unlocked_cosmetics

		if var_182_8 then
			arg_182_0:set_read_only_data("unlocked_cosmetics", var_182_8, true)

			arg_182_0._unlocked_cosmetics = arg_182_0:_parse_unlocked_cosmetics()
		end

		local var_182_9 = var_182_0.unlocked_weapon_poses

		if var_182_9 then
			arg_182_0:set_read_only_data("unlocked_weapon_poses", var_182_9, true)

			arg_182_0._unlocked_weapon_poses = arg_182_0:_parse_unlocked_weapon_poses()
		end

		arg_182_0:_request_user_inventory()
	else
		arg_182_0:_verify_default_gear()
	end
end

PlayFabMirrorBase.unequip_disabled_items = function (arg_183_0)
	local var_183_0 = Managers.mechanism:mechanism_setting_for_title("override_item_availability")

	if not var_183_0 or table.is_empty(var_183_0) then
		return
	end

	local var_183_1 = PROFILES_BY_CAREER_NAMES
	local var_183_2 = arg_183_0._inventory_items
	local var_183_3 = table.contains
	local var_183_4 = Managers.mechanism:current_mechanism_name()

	var_183_4 = var_183_4 == "versus" and var_183_4 or nil

	for iter_183_0, iter_183_1 in pairs(arg_183_0._career_data) do
		local var_183_5 = var_183_1[iter_183_0]

		if var_183_5 then
			local var_183_6 = arg_183_0._verify_slot_keys_per_affiliation[var_183_5.affiliation]

			if var_183_6 then
				local var_183_7 = CareerSettings[iter_183_0]

				for iter_183_2, iter_183_3 in pairs(iter_183_1) do
					if var_183_3(var_183_6, iter_183_2) then
						local var_183_8 = var_183_2[iter_183_3]

						if var_183_8 and var_183_0[var_183_8.ItemId] == false then
							local var_183_9 = arg_183_0:_find_valid_item_for_slot(var_183_0, var_183_7, iter_183_2, iter_183_0, var_183_4)

							if var_183_9 then
								arg_183_0:set_character_data(iter_183_0, iter_183_2, var_183_9, true)
							end
						end
					end
				end
			end
		end
	end
end

PlayFabMirrorBase._find_valid_item_for_slot = function (arg_184_0, arg_184_1, arg_184_2, arg_184_3, arg_184_4, arg_184_5)
	local var_184_0 = ItemMasterList
	local var_184_1 = table.contains
	local var_184_2 = {}

	for iter_184_0, iter_184_1 in pairs(arg_184_0._inventory_items) do
		if arg_184_1[iter_184_1.ItemId] ~= false then
			local var_184_3 = var_184_0[iter_184_1.ItemId]
			local var_184_4 = var_184_1(arg_184_2.item_slot_types_by_slot_name[arg_184_3], var_184_3.slot_type)
			local var_184_5 = var_184_3.can_wield

			if var_184_4 and var_184_5 and var_184_1(var_184_5, arg_184_4) and (not arg_184_5 or var_184_1(var_184_3.mechanisms or var_184_2, arg_184_5)) then
				return iter_184_0, iter_184_1
			end
		end
	end
end

PlayFabMirrorBase._check_career_data = function (arg_185_0, arg_185_1, arg_185_2)
	local var_185_0 = arg_185_0._characters_data
	local var_185_1 = arg_185_0._characters_data_mirror
	local var_185_2 = false
	local var_185_3 = {}
	local var_185_4 = {
		"careers",
		"loadouts",
		"experience",
		"experience_pool",
		"prestige"
	}

	for iter_185_0, iter_185_1 in pairs(var_185_0) do
		local var_185_5 = var_185_1[iter_185_0]

		if var_185_5 and (not table.compare(iter_185_1, var_185_5, var_185_4) or table.size(iter_185_1) ~= table.size(var_185_5)) then
			var_0_6("[CheckCareerData] Found profile data changes: %s", iter_185_0)

			var_185_2 = true

			local var_185_6 = var_185_3[iter_185_0] or {
				careers = {}
			}

			var_185_6.selected_career = iter_185_1.career
			var_185_6.selected_bot_career = iter_185_1.bot_career
			var_185_3[iter_185_0] = var_185_6
		end
	end

	for iter_185_2, iter_185_3 in pairs(var_185_0) do
		local var_185_7 = iter_185_3.loadouts
		local var_185_8 = var_185_1[iter_185_2]

		if var_185_8 then
			local var_185_9 = var_185_8.loadouts

			if var_185_9 then
				if not table.compare(var_185_7, var_185_9) then
					var_0_6("[CheckCareerData] Found selected loadout changes for profile: %s", iter_185_2)

					var_185_2 = true

					local var_185_10 = var_185_3[iter_185_2] or {
						careers = {}
					}

					var_185_10.selected_loadouts = var_185_7
					var_185_3[iter_185_2] = var_185_10
				end
			else
				var_0_6("[CheckCareerData] Missing selected loadout data for profile: %s", iter_185_2)

				var_185_2 = true
			end
		else
			var_0_6("[CheckCareerData] Missing profile data: %s", iter_185_2)

			var_185_2 = true
		end
	end

	for iter_185_4, iter_185_5 in pairs(arg_185_1) do
		local var_185_11 = arg_185_2[iter_185_4]
		local var_185_12 = PROFILES_BY_CAREER_NAMES[iter_185_4]

		if var_185_12 then
			local var_185_13 = arg_185_0._verify_slot_keys_per_affiliation[var_185_12.affiliation]

			if var_185_13 then
				for iter_185_6 = 1, #iter_185_5 do
					local var_185_14 = iter_185_5[iter_185_6]
					local var_185_15 = var_185_11[iter_185_6]

					if var_185_15 then
						for iter_185_7, iter_185_8 in pairs(var_185_13) do
							local var_185_16 = var_185_14[iter_185_8]

							if var_185_16 ~= var_185_15[iter_185_8] then
								for iter_185_9, iter_185_10 in pairs(var_185_0) do
									if iter_185_10.careers[iter_185_4] then
										local var_185_17 = iter_185_10.careers[iter_185_4][iter_185_6]

										if var_185_17 then
											var_185_17[iter_185_8] = var_185_16
										end

										break
									end
								end

								var_0_6("[CheckCareerData] Found changes in loadout %d for career: %s in slot %s", iter_185_6, iter_185_4, iter_185_8)

								var_185_2 = true

								local var_185_18 = var_185_3[var_185_12.display_name] or {
									careers = {}
								}
								local var_185_19 = var_185_18.careers[iter_185_4] or {
									loadouts = {},
									deleted_loadouts = {}
								}

								var_185_18.careers[iter_185_4] = var_185_19
								var_185_19.loadouts[tostring(iter_185_6)] = var_185_14
								var_185_3[var_185_12.display_name] = var_185_18
							end
						end
					else
						var_0_6("[CheckCareerData] Missing/new loadout for career: %s", iter_185_4)

						var_185_2 = true

						local var_185_20 = var_185_3[var_185_12.display_name] or {
							careers = {}
						}
						local var_185_21 = var_185_20.careers[iter_185_4] or {
							loadouts = {},
							deleted_loadouts = {}
						}

						var_185_20.careers[iter_185_4] = var_185_21
						var_185_21.loadouts[tostring(iter_185_6)] = var_185_14
						var_185_3[var_185_12.display_name] = var_185_20
					end
				end
			else
				Application.warning(string.format("Missing slots to verify for %q", iter_185_4))
			end
		end
	end

	for iter_185_11, iter_185_12 in pairs(arg_185_2) do
		local var_185_22 = arg_185_1[iter_185_11]

		if not var_185_22 then
			local var_185_23 = {}
			local var_185_24

			local function var_185_25(arg_186_0, arg_186_1)
				local var_186_0 = tostring(arg_186_0)
				local var_186_1 = var_185_23[var_186_0]

				if var_186_1 then
					var_0_6("%s and %s share the same table address. Verify if these should be clones instead!", arg_186_1, var_186_1)
				else
					var_185_23[var_186_0] = arg_186_1
				end

				for iter_186_0, iter_186_1 in pairs(arg_186_0) do
					if type(iter_186_1) == "table" then
						var_185_25(iter_186_1, string.format("%s-%s", arg_186_1, iter_186_0))
					end
				end
			end

			var_0_6("[CheckCareerData] You will crash now. That's sad :(")
			table.dump(arg_185_0._career_data, "PlayfabMirrorBase_career_data", 5)
			table.dump(arg_185_0._career_data_mirror, "PlayfabMirrorBase._career_data_mirror", 5)
			table.dump(arg_185_0._career_loadouts, "PlayfabMirrorBase._career_loadouts", 5)
			table.dump(arg_185_0._career_lookup, "PlayfabMirrorBase._career_lookup", 5)
			table.dump(arg_185_0._character_default_loadouts, "PlayfabMirrorBase._character_default_loadouts", 5)
			table.dump(arg_185_0._characters_data, "PlayfabMirrorBase._characters_data", 5)
			table.dump(arg_185_0._characters_data_mirror, "PlayfabMirrorBase._characters_data_mirror", 5)
			var_0_6("PlayfabMirrorBase._read_only_data.characters_data: %s", arg_185_0._read_only_data.characters_data)
			var_0_6("PlayfabMirrorBase._read_only_data.vs_characters_data: %s", arg_185_0._read_only_data.vs_characters_data)
			var_0_6("PlayfabMirrorBase._read_only_data.character_default_loadouts: %s", arg_185_0._read_only_data.character_default_loadouts)
			var_0_6("PlayfabMirrorBase._read_only_data.vs_character_default_loadouts: %s", arg_185_0._read_only_data.vs_character_default_loadouts)
			var_0_6("PlayfabMirrorBase._read_only_data_mirror.characters_data: %s", arg_185_0._read_only_data_mirror.characters_data)
			var_0_6("PlayfabMirrorBase._read_only_data_mirror.vs_characters_data: %s", arg_185_0._read_only_data_mirror.vs_characters_data)
			var_0_6("PlayfabMirrorBase._read_only_data_mirror.character_default_loadouts: %s", arg_185_0._read_only_data_mirror.character_default_loadouts)
			var_0_6("PlayfabMirrorBase._read_only_data_mirror.vs_character_default_loadouts: %s", arg_185_0._read_only_data_mirror.vs_character_default_loadouts)
			var_185_25(arg_185_0._career_data, "_career_data")
			var_185_25(arg_185_0._career_data_mirror, "_career_data_mirror")
			var_185_25(arg_185_0._career_loadouts, "_career_loadouts")
			var_185_25(arg_185_0._career_lookup, "_career_lookup")
			var_185_25(arg_185_0._character_default_loadouts, "_character_default_loadouts")
			var_185_25(arg_185_0._characters_data, "_characters_data")
			var_185_25(arg_185_0._characters_data_mirror, "_characters_data_mirror")
		end

		local var_185_26 = PROFILES_BY_CAREER_NAMES[iter_185_11]

		if var_185_26 then
			for iter_185_13 = 1, #iter_185_12 do
				if not var_185_22[iter_185_13] then
					var_0_6("[CheckCareerData] Missing/deleted loadout for career: %s", iter_185_11)

					var_185_2 = true

					local var_185_27 = var_185_3[var_185_26.display_name] or {
						careers = {}
					}
					local var_185_28 = var_185_27.careers[iter_185_11] or {
						loadouts = {},
						deleted_loadouts = {}
					}

					var_185_27.careers[iter_185_11] = var_185_28
					var_185_28.deleted_loadouts[#var_185_28.deleted_loadouts + 1] = iter_185_13
					var_185_3[var_185_26.display_name] = var_185_27
				end
			end
		end
	end

	var_185_2 = var_185_2 or Managers.account:offline_mode()

	return var_185_2, var_185_0, var_185_3
end

PlayFabMirrorBase.set_career_read_only_data = function (arg_187_0, arg_187_1, arg_187_2, arg_187_3, arg_187_4, arg_187_5, arg_187_6)
	local var_187_0 = arg_187_0._characters_data

	arg_187_6 = arg_187_4 and (arg_187_6 or arg_187_0._career_loadouts[arg_187_4])
	;(arg_187_4 and var_187_0[arg_187_1].careers[arg_187_4][arg_187_6] or var_187_0[arg_187_1])[arg_187_2] = arg_187_3

	if arg_187_5 then
		local var_187_1 = arg_187_0._characters_data_mirror
		local var_187_2 = arg_187_4 and var_187_1[arg_187_1].careers[arg_187_4][arg_187_6] or var_187_1[arg_187_1]

		if type(arg_187_3) == "table" then
			var_187_2[arg_187_2] = table.clone(arg_187_3)
		else
			var_187_2[arg_187_2] = arg_187_3
		end
	end

	local var_187_3 = cjson.encode(var_187_0)

	arg_187_0:set_read_only_data(arg_187_0._characters_data_key, var_187_3, arg_187_5)
end

PlayFabMirrorBase.get_characters_data = function (arg_188_0)
	return arg_188_0._characters_data
end

PlayFabMirrorBase.update_owned_dlcs = function (arg_189_0, arg_189_1)
	if IS_CONSOLE then
		return
	end

	local var_189_0 = Managers.unlock:get_dlcs()

	for iter_189_0, iter_189_1 in pairs(var_189_0) do
		if iter_189_1.set_owned then
			local var_189_1 = table.contains(arg_189_0._owned_dlcs, iter_189_0)

			iter_189_1:set_owned(var_189_1, arg_189_1)
		end
	end

	for iter_189_2, iter_189_3 in pairs(var_189_0) do
		if iter_189_3.check_all_children_dlc_owned then
			iter_189_3:check_all_children_dlc_owned()
		end
	end
end

PlayFabMirrorBase.handle_new_dlcs = function (arg_190_0, arg_190_1)
	SaveData.new_dlcs_unlocks = SaveData.new_dlcs_unlocks or {}

	if arg_190_1 then
		for iter_190_0 = 1, #arg_190_1 do
			local var_190_0 = arg_190_1[iter_190_0]

			if not SaveData.new_dlcs_unlocks[var_190_0] then
				SaveData.new_dlcs_unlocks[var_190_0] = true
			end
		end

		Managers.save:auto_save(SaveFileName, SaveData)
	end
end

PlayFabMirrorBase._snippet_clear_inventory = function (arg_191_0)
	local function var_191_0(arg_192_0)
		local var_192_0 = {
			slot_necklace = true,
			slot_hat = true,
			slot_trinket_1 = true,
			slot_skin = true,
			slot_frame = true,
			slot_melee = true,
			slot_ring = true,
			slot_ranged = true
		}
		local var_192_1 = PROFILES_BY_CAREER_NAMES
		local var_192_2 = {}

		for iter_192_0, iter_192_1 in pairs(var_192_1) do
			if iter_192_1.affiliation == "heroes" then
				var_192_2[iter_192_0] = var_192_0
			end
		end

		arg_191_0:_fix_career_data(var_192_2, "adventure")
	end

	arg_191_0._request_queue[#arg_191_0._request_queue + 1] = {
		eac_check = false,
		func = "devClearInventory",
		args = {
			exclude_types = {}
		},
		success_cb = var_191_0
	}
end

PlayFabMirrorBase.snippet_clear_inventory = function (arg_193_0)
	arg_193_0:_snippet_clear_inventory()
end

PlayFabMirrorBase.set_twitch_app_access_token = function (arg_194_0, arg_194_1)
	arg_194_0._twitch_app_access_token = arg_194_1
end

PlayFabMirrorBase.get_power_level_settings = function (arg_195_0)
	return arg_195_0._power_level_data
end

PlayFabMirrorBase.debug_override_power_level_settings = function (arg_196_0, arg_196_1)
	arg_196_0._power_level_data = arg_196_1
end

PlayFabMirrorBase.get_rarity_tables = function (arg_197_0)
	return arg_197_0._rarity_tables
end

PlayFabMirrorBase.get_formatted_rarity_tables = function (arg_198_0)
	return arg_198_0._formatted_rarity_tables
end

PlayFabMirrorBase._generate_formatted_rarity_tables = function (arg_199_0, arg_199_1)
	arg_199_0._formatted_rarity_tables = {}

	for iter_199_0, iter_199_1 in pairs(arg_199_1) do
		arg_199_0._formatted_rarity_tables[iter_199_0] = {}

		local var_199_0 = {}
		local var_199_1 = 0
		local var_199_2 = 0

		for iter_199_2, iter_199_3 in pairs(iter_199_1) do
			var_199_2 = var_199_2 + iter_199_3

			local var_199_3
			local var_199_4

			if iter_199_3 < 1 then
				var_199_3 = iter_199_3
				var_199_4 = math.ceil(iter_199_3)
			else
				var_199_3 = math.round(iter_199_3)
				var_199_4 = var_199_3
			end

			arg_199_0._formatted_rarity_tables[iter_199_0][iter_199_2] = var_199_3
			var_199_1 = var_199_1 + var_199_4
			var_199_0[#var_199_0 + 1] = {
				key = iter_199_2,
				chance = iter_199_3,
				idx = #var_199_0 + 1
			}
		end

		table.sort(var_199_0, function (arg_200_0, arg_200_1)
			return arg_200_0.chance % 1 < arg_200_1.chance % 1
		end)

		if var_199_1 > 100 then
			for iter_199_4 = 1, #var_199_0 do
				local var_199_5 = var_199_0[iter_199_4]

				if var_199_5.chance > 1 and var_199_5.chance % 1 >= 0.5 then
					arg_199_0._formatted_rarity_tables[iter_199_0][var_199_5.key] = arg_199_0._formatted_rarity_tables[iter_199_0][var_199_5.key] - 1
					var_199_1 = var_199_1 - 1

					if var_199_1 == 100 then
						break
					end
				end
			end
		elseif var_199_1 < 100 then
			for iter_199_5 = #var_199_0, 1, -1 do
				local var_199_6 = var_199_0[iter_199_5]

				if var_199_6.chance > 1 and var_199_6.chance % 1 < 0.5 then
					arg_199_0._formatted_rarity_tables[iter_199_0][var_199_6.key] = arg_199_0._formatted_rarity_tables[iter_199_0][var_199_6.key] + 1
					var_199_1 = var_199_1 + 1

					if var_199_1 == 100 then
						break
					end
				end
			end
		end
	end
end
