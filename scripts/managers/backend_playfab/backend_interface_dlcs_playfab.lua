-- chunkname: @scripts/managers/backend_playfab/backend_interface_dlcs_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceDLCsPlayfab = class(BackendInterfaceDLCsPlayfab)

function BackendInterfaceDLCsPlayfab.init(arg_1_0, arg_1_1)
	arg_1_0.is_local = false
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._last_id = 0
	arg_1_0._updating_dlc_ownership = false
	arg_1_0._owned_dlcs = arg_1_1:get_owned_dlcs()
	arg_1_0._platform_dlcs = arg_1_1:get_platform_dlcs()
end

function BackendInterfaceDLCsPlayfab.ready(arg_2_0)
	return true
end

function BackendInterfaceDLCsPlayfab.update(arg_3_0, arg_3_1)
	return
end

function BackendInterfaceDLCsPlayfab._new_id(arg_4_0)
	arg_4_0._last_id = arg_4_0._last_id + 1

	return arg_4_0._last_id
end

function BackendInterfaceDLCsPlayfab.update_dlc_ownership(arg_5_0)
	local var_5_0 = Managers.unlock:get_installed_dlcs()
	local var_5_1 = cjson.encode(var_5_0)
	local var_5_2 = {
		FunctionName = "updateDLCOwnership",
		FunctionParameter = {
			installed_dlcs = var_5_1
		}
	}
	local var_5_3 = callback(arg_5_0, "_update_owned_dlcs_cb")

	arg_5_0._backend_mirror:request_queue():enqueue(var_5_2, var_5_3, false)

	arg_5_0._updating_dlc_ownership = true
end

function BackendInterfaceDLCsPlayfab._update_owned_dlcs_cb(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.FunctionResult
	local var_6_1 = var_6_0.new_dlcs
	local var_6_2 = var_6_0.revoked_dlcs
	local var_6_3 = not script_data["eac-untrusted"] and (not var_6_1 or not var_6_2 or #var_6_1 > 0 or #var_6_2 > 0)

	arg_6_0._owner_dlcs_cb_data = table.shallow_copy(var_6_0)
	arg_6_0._owner_dlcs_cb_data.dlcs_dirty = HAS_STEAM and var_6_3

	if var_6_3 then
		arg_6_0:_execute_dlc_specific_logic()
	else
		arg_6_0:_handle_owned_dlcs_data()

		arg_6_0._updating_dlc_ownership = false
	end
end

function BackendInterfaceDLCsPlayfab._handle_owned_dlcs_data(arg_7_0)
	local var_7_0 = arg_7_0._owner_dlcs_cb_data
	local var_7_1 = var_7_0.owned_dlcs
	local var_7_2 = var_7_0.platform_dlcs
	local var_7_3 = var_7_0.excluded_dlcs
	local var_7_4 = var_7_0.new_dlcs
	local var_7_5 = var_7_0.revoked_dlcs

	arg_7_0._owned_dlcs = var_7_1 or {}
	arg_7_0._platform_dlcs = var_7_2

	Managers.unlock:set_excluded_dlcs(var_7_3)
	arg_7_0._backend_mirror:set_owned_dlcs(var_7_1)
	arg_7_0._backend_mirror:set_platform_dlcs(var_7_2)
	print("Finished Updating Owned DLCS")
	table.dump(arg_7_0._owned_dlcs, nil, 2)
	arg_7_0._backend_mirror:update_owned_dlcs(true)

	if var_7_5 and #var_7_5 > 0 then
		local var_7_6 = var_7_0.unlocked_keep_decorations

		if var_7_6 then
			arg_7_0._backend_mirror:set_read_only_data("unlocked_keep_decorations", var_7_6, true)
		end

		local var_7_7 = var_7_0.unlocked_cosmetics

		if var_7_7 then
			arg_7_0._backend_mirror:set_read_only_data("unlocked_cosmetics", var_7_7, true)
		end

		local var_7_8 = var_7_0.unlocked_weapon_skins

		if var_7_8 then
			arg_7_0._backend_mirror:set_read_only_data("unlocked_weapon_skins", var_7_8, true)
		end
	end

	arg_7_0._backend_mirror:update_filtered_dlc_data()

	if var_7_0.dlcs_dirty then
		arg_7_0._backend_mirror:handle_new_dlcs(var_7_4)
	end
end

function BackendInterfaceDLCsPlayfab._execute_dlc_specific_logic(arg_8_0)
	local var_8_0 = {
		FunctionName = "executeDLCLogic",
		FunctionParameter = {}
	}
	local var_8_1 = callback(arg_8_0, "_execute_dlc_logic_cb")

	arg_8_0._backend_mirror:request_queue():enqueue(var_8_0, var_8_1, true)
end

function BackendInterfaceDLCsPlayfab._execute_dlc_logic_cb(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.FunctionResult.item_grant_results

	arg_9_0:_handle_owned_dlcs_data()

	local var_9_1 = arg_9_0._backend_mirror:get_user_data("unseen_rewards")
	local var_9_2

	var_9_2 = var_9_1 and cjson.decode(var_9_1) or {}

	for iter_9_0 = 1, #var_9_0 do
		local var_9_3 = var_9_0[iter_9_0]
		local var_9_4 = var_9_3.ItemId
		local var_9_5 = var_9_3.ItemType

		if var_9_5 == "keep_decoration_painting" then
			local var_9_6 = {
				reward_type = "keep_decoration_painting",
				rewarded_from = var_9_3.Data.rewarded_from,
				keep_decoration_name = var_9_4
			}

			var_9_2[#var_9_2 + 1] = var_9_6

			arg_9_0._backend_mirror:add_keep_decoration(var_9_4)
		elseif CosmeticUtils.is_cosmetic_item(var_9_5) then
			local var_9_7 = arg_9_0._backend_mirror:add_item(nil, {
				ItemId = var_9_4
			})

			if var_9_7 then
				local var_9_8 = {
					reward_type = var_9_5,
					backend_id = var_9_7,
					rewarded_from = var_9_3.Data.rewarded_from,
					item_type = var_9_5,
					item_id = var_9_4
				}

				var_9_2[#var_9_2 + 1] = var_9_8
			end
		else
			local var_9_9 = ItemMasterList[var_9_4]
			local var_9_10 = var_9_3.CustomData.rewarded_from

			if var_9_9.bundle then
				local var_9_11 = var_9_9.bundle.BundledVirtualCurrencies

				for iter_9_1, iter_9_2 in pairs(var_9_11) do
					if var_9_10 then
						local var_9_12 = {
							reward_type = "currency",
							currency_type = iter_9_1,
							currency_amount = iter_9_2,
							rewarded_from = var_9_10
						}

						var_9_2[#var_9_2 + 1] = var_9_12
					end

					if iter_9_1 == "SM" then
						local var_9_13 = Managers.backend:get_interface("peddler")
						local var_9_14 = var_9_13:get_chips("SM")

						var_9_13:set_chips(iter_9_1, var_9_14 + iter_9_2)
					end
				end
			else
				local var_9_15 = var_9_3.ItemInstanceId

				if var_9_10 then
					local var_9_16 = ItemMasterList[var_9_3.ItemId].item_type
					local var_9_17 = {
						reward_type = "item",
						backend_id = var_9_15,
						rewarded_from = var_9_10,
						item_type = var_9_16,
						item_id = var_9_4
					}

					var_9_2[#var_9_2 + 1] = var_9_17
				end

				arg_9_0._backend_mirror:add_item(var_9_15, var_9_3)
			end
		end
	end

	arg_9_0._backend_mirror:set_user_data("unseen_rewards", cjson.encode(var_9_2))
	print("Finished Getting New DLC Rewards")
	print("New Rewards:")
	table.dump(var_9_2, "unseen_rewards", 5)

	arg_9_0._updating_dlc_ownership = false
end

function BackendInterfaceDLCsPlayfab.get_owned_dlcs(arg_10_0)
	return arg_10_0._owned_dlcs
end

function BackendInterfaceDLCsPlayfab.get_platform_dlcs(arg_11_0)
	return arg_11_0._platform_dlcs
end

function BackendInterfaceDLCsPlayfab.updating_dlc_ownership(arg_12_0)
	return arg_12_0._updating_dlc_ownership
end

function BackendInterfaceDLCsPlayfab.is_unreleased_career(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._backend_mirror:get_title_data().unreleased_careers

	if var_13_0 and string.find(var_13_0, arg_13_1) then
		return true
	end

	return false
end
