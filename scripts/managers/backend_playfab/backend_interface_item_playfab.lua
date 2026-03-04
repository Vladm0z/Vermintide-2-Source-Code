-- chunkname: @scripts/managers/backend_playfab/backend_interface_item_playfab.lua

BackendInterfaceItemPlayfab = class(BackendInterfaceItemPlayfab)

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceItemPlayfab.init = function (arg_1_0, arg_1_1)
	arg_1_0._loadouts = {}
	arg_1_0._items = {}
	arg_1_0._game_mode_specific_items = {}
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._career_loadouts = {}
	arg_1_0._default_loadouts = {}
	arg_1_0._default_loadout_overrides = {}
	arg_1_0._selected_career_custom_loadouts = {}
	arg_1_0._bot_loadouts = {}
	arg_1_0._dirty_weapon_pose_skins = {}
	arg_1_0._last_id = 0
	arg_1_0._delete_deeds_request = {}
	arg_1_0._is_deleting_deeds = false

	arg_1_0:_refresh()
end

local var_0_1 = {
	"slot_ranged",
	"slot_melee",
	"slot_skin",
	"slot_hat",
	"slot_necklace",
	"slot_ring",
	"slot_trinket_1",
	"slot_frame",
	"slot_pose"
}

BackendInterfaceItemPlayfab._refresh = function (arg_2_0)
	if not DEDICATED_SERVER then
		arg_2_0:_refresh_career_loadouts()
		arg_2_0:_refresh_default_loadouts()
		arg_2_0:_setup_default_overrides()
	end

	arg_2_0:_refresh_items()
	arg_2_0:_refresh_loadouts()

	if not DEDICATED_SERVER then
		arg_2_0:refresh_bot_loadouts()
	end

	arg_2_0._dirty = false

	arg_2_0:_unmark_favorites()
end

BackendInterfaceItemPlayfab._refresh_items = function (arg_3_0)
	local var_3_0 = arg_3_0._backend_mirror
	local var_3_1 = var_3_0:get_all_inventory_items()
	local var_3_2 = var_3_0:get_unlocked_weapon_skins()
	local var_3_3 = var_3_0:get_unlocked_cosmetics()

	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		if not iter_3_1.bypass_skin_ownership_check and iter_3_1.skin and not var_3_2[iter_3_1.skin] then
			iter_3_1.skin = nil
		end
	end

	if arg_3_0._active_game_mode_specific_items then
		arg_3_0._items = table.clone(var_3_1)

		for iter_3_2, iter_3_3 in pairs(arg_3_0._active_game_mode_specific_items) do
			arg_3_0._items[iter_3_2] = iter_3_3
		end
	else
		arg_3_0._items = var_3_1
	end

	arg_3_0._fake_items = var_3_0:get_all_fake_inventory_items()

	local var_3_4 = ItemHelper.get_new_backend_ids()

	if var_3_4 then
		for iter_3_4, iter_3_5 in pairs(var_3_4) do
			if not var_3_1[iter_3_4] then
				ItemHelper.unmark_backend_id_as_new(iter_3_4, true)
			end
		end

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

BackendInterfaceItemPlayfab._unmark_favorites = function (arg_4_0)
	local var_4_0 = ItemHelper.get_favorite_backend_ids()

	if var_4_0 then
		local var_4_1 = arg_4_0._items

		for iter_4_0, iter_4_1 in pairs(var_4_0) do
			if not var_4_1[iter_4_0] and not arg_4_0:get_backend_id_from_cosmetic_item(iter_4_0) then
				ItemHelper.unmark_backend_id_as_favorite(iter_4_0)
			end
		end
	end
end

BackendInterfaceItemPlayfab._refresh_loadouts = function (arg_5_0)
	local var_5_0 = arg_5_0._loadouts
	local var_5_1 = arg_5_0._backend_mirror

	for iter_5_0, iter_5_1 in pairs(CareerSettings) do
		if iter_5_1.playfab_name then
			for iter_5_2 = 1, #var_0_1 do
				local var_5_2 = var_0_1[iter_5_2]
				local var_5_3 = var_5_1:get_character_data(iter_5_0, var_5_2)

				var_5_0[iter_5_0] = var_5_0[iter_5_0] or {}
				var_5_0[iter_5_0][var_5_2] = var_5_3
			end
		end
	end
end

local var_0_2 = {}

BackendInterfaceItemPlayfab.refresh_bot_loadouts = function (arg_6_0)
	arg_6_0._bot_loadouts = table.clone(arg_6_0._loadouts)

	local var_6_0 = arg_6_0._bot_loadouts
	local var_6_1 = arg_6_0._backend_mirror
	local var_6_2 = (PlayerData.loadout_selection or var_0_2).bot_equipment or var_0_2
	local var_6_3 = Managers.mechanism:current_mechanism_name()
	local var_6_4 = InventorySettings.bot_loadout_allowed_mechanisms[var_6_3]

	for iter_6_0, iter_6_1 in pairs(CareerSettings) do
		if iter_6_1.playfab_name then
			local var_6_5 = var_6_4 and var_6_2[iter_6_0]

			if var_6_5 then
				if not var_6_1:has_loadout(iter_6_0, var_6_5) then
					var_6_2[iter_6_0] = nil
					var_6_5 = nil
				end

				for iter_6_2 = 1, #var_0_1 do
					local var_6_6 = var_0_1[iter_6_2]
					local var_6_7 = var_6_1:get_character_data(iter_6_0, var_6_6, var_6_5)

					var_6_0[iter_6_0] = var_6_0[iter_6_0] or {}
					var_6_0[iter_6_0][var_6_6] = var_6_7
				end
			end
		end
	end

	print("[BackendInterfaceItemPlayfab] Refreshing bot loadout")
end

BackendInterfaceItemPlayfab._refresh_career_loadouts = function (arg_7_0)
	local var_7_0 = arg_7_0._career_loadouts
	local var_7_1 = arg_7_0._backend_mirror

	table.clear(var_7_0)

	for iter_7_0, iter_7_1 in pairs(CareerSettings) do
		if iter_7_1.playfab_name then
			var_7_0[iter_7_0] = var_7_0[iter_7_0] or {}

			local var_7_2 = var_7_0[iter_7_0]
			local var_7_3, var_7_4 = var_7_1:get_career_loadouts(iter_7_0)

			arg_7_0._selected_career_custom_loadouts[iter_7_0] = var_7_3

			if var_7_4 then
				for iter_7_2 = 1, #var_7_4 do
					var_7_2[iter_7_2] = var_7_2[iter_7_2] or {}

					local var_7_5 = var_7_2[iter_7_2]
					local var_7_6 = var_7_4[iter_7_2]

					for iter_7_3 = 1, #var_0_1 do
						local var_7_7 = var_0_1[iter_7_3]

						var_7_5[var_7_7] = var_7_6[var_7_7]
					end
				end
			end
		end
	end
end

BackendInterfaceItemPlayfab._refresh_default_loadouts = function (arg_8_0)
	local var_8_0 = arg_8_0._default_loadouts
	local var_8_1 = arg_8_0._backend_mirror

	table.clear(var_8_0)

	for iter_8_0, iter_8_1 in pairs(CareerSettings) do
		if iter_8_1.playfab_name then
			var_8_0[iter_8_0] = var_8_0[iter_8_0] or {}

			local var_8_2 = var_8_0[iter_8_0]
			local var_8_3 = var_8_1:get_default_loadouts(iter_8_0)

			if var_8_3 then
				for iter_8_2 = 1, #var_8_3 do
					var_8_2[iter_8_2] = var_8_2[iter_8_2] or {}

					local var_8_4 = var_8_2[iter_8_2]
					local var_8_5 = var_8_3[iter_8_2]

					for iter_8_3 = 1, #var_0_1 do
						local var_8_6 = var_0_1[iter_8_3]

						var_8_4[var_8_6] = var_8_5[var_8_6]
					end
				end
			end
		end
	end
end

BackendInterfaceItemPlayfab._setup_default_overrides = function (arg_9_0)
	local var_9_0 = Managers.mechanism:current_mechanism_name()
	local var_9_1 = PlayerData.loadout_selection and PlayerData.loadout_selection[var_9_0] or {}

	table.clear(arg_9_0._default_loadout_overrides)

	if not var_9_1 then
		return
	end

	local var_9_2 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()

	if not var_9_2 or not InventorySettings.default_loadout_allowed_game_modes[var_9_2] then
		return
	end

	for iter_9_0, iter_9_1 in pairs(CareerSettings) do
		local var_9_3 = var_9_1[iter_9_0] or 1

		if var_9_3 and InventorySettings.loadouts[var_9_3].loadout_type == "default" then
			arg_9_0:set_default_override(iter_9_0, var_9_3)
		end
	end
end

BackendInterfaceItemPlayfab.set_loadout_index = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._backend_mirror:set_loadout_index(arg_10_1, arg_10_2)
	Managers.telemetry_events:loadout_equipped()
end

BackendInterfaceItemPlayfab.add_loadout = function (arg_11_0, arg_11_1)
	arg_11_0._backend_mirror:add_loadout(arg_11_1)

	local var_11_0 = arg_11_0:get_career_loadouts(arg_11_1)

	Managers.telemetry_events:loadout_created(#var_11_0, InventorySettings.MAX_NUM_CUSTOM_LOADOUTS)
end

BackendInterfaceItemPlayfab.delete_loadout = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._backend_mirror:delete_loadout(arg_12_1, arg_12_2)

	local var_12_0 = arg_12_0:get_career_loadouts(arg_12_1)

	Managers.telemetry_events:loadout_deleted(#var_12_0, InventorySettings.MAX_NUM_CUSTOM_LOADOUTS)
end

BackendInterfaceItemPlayfab.set_default_override = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._default_loadouts[arg_13_1]

	arg_13_0._default_loadout_overrides[arg_13_1] = var_13_0 and var_13_0[arg_13_2]
end

BackendInterfaceItemPlayfab.get_default_override = function (arg_14_0, arg_14_1)
	return arg_14_0._default_loadout_overrides[arg_14_1]
end

BackendInterfaceItemPlayfab.ready = function (arg_15_0)
	if arg_15_0._items then
		return true
	end

	return false
end

BackendInterfaceItemPlayfab.type = function (arg_16_0)
	return "backend"
end

BackendInterfaceItemPlayfab.update = function (arg_17_0)
	return
end

BackendInterfaceItemPlayfab.refresh_entities = function (arg_18_0)
	return
end

BackendInterfaceItemPlayfab.check_for_errors = function (arg_19_0)
	return
end

BackendInterfaceItemPlayfab.num_current_item_server_requests = function (arg_20_0)
	return 0
end

BackendInterfaceItemPlayfab.set_properties_serialized = function (arg_21_0, arg_21_1, arg_21_2)
	return
end

BackendInterfaceItemPlayfab.get_traits = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0:get_item_from_id(arg_22_1)

	if var_22_0 then
		return var_22_0.traits
	end

	return nil
end

BackendInterfaceItemPlayfab.set_runes = function (arg_23_0, arg_23_1, arg_23_2)
	return
end

BackendInterfaceItemPlayfab.get_runes = function (arg_24_0, arg_24_1)
	return
end

BackendInterfaceItemPlayfab.socket_rune = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	return
end

BackendInterfaceItemPlayfab.get_skin = function (arg_26_0, arg_26_1)
	return arg_26_0:get_item_from_id(arg_26_1).skin
end

BackendInterfaceItemPlayfab.get_item_masterlist_data = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0:get_item_from_id(arg_27_1)

	if var_27_0 then
		return var_27_0.data
	end
end

BackendInterfaceItemPlayfab.get_item_amount = function (arg_28_0, arg_28_1)
	return arg_28_0:get_item_from_id(arg_28_1).RemainingUses or 1
end

BackendInterfaceItemPlayfab.get_item_power_level = function (arg_29_0, arg_29_1)
	return arg_29_0:get_item_from_id(arg_29_1).power_level
end

BackendInterfaceItemPlayfab.get_item_rarity = function (arg_30_0, arg_30_1)
	return arg_30_0:get_item_from_id(arg_30_1).rarity
end

BackendInterfaceItemPlayfab.get_key = function (arg_31_0, arg_31_1)
	return arg_31_0:get_item_from_id(arg_31_1).key
end

BackendInterfaceItemPlayfab.get_item_from_id = function (arg_32_0, arg_32_1)
	return arg_32_0:get_all_backend_items()[arg_32_1]
end

BackendInterfaceItemPlayfab.get_backend_id_from_cosmetic_item = function (arg_33_0, arg_33_1)
	return arg_33_0._backend_mirror:get_unlocked_cosmetics()[arg_33_1]
end

BackendInterfaceItemPlayfab.get_item_from_key = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0:get_all_backend_items()

	for iter_34_0, iter_34_1 in pairs(var_34_0) do
		if iter_34_1.key == arg_34_1 then
			return iter_34_1
		end
	end
end

BackendInterfaceItemPlayfab.get_weapon_skin_from_skin_key = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0:get_all_fake_backend_items()

	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		if iter_35_1.skin == arg_35_1 then
			return iter_35_0, iter_35_1
		end
	end
end

BackendInterfaceItemPlayfab.free_inventory_slots = function (arg_36_0)
	local var_36_0 = arg_36_0:get_all_backend_items()
	local var_36_1 = 0
	local var_36_2 = ItemHelper.is_fake_item

	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		if not var_36_2(iter_36_1.data.item_type) then
			var_36_1 = var_36_1 + 1
		end
	end

	return UISettings.max_inventory_items - var_36_1
end

BackendInterfaceItemPlayfab.get_all_backend_items = function (arg_37_0)
	if arg_37_0._dirty then
		arg_37_0:_refresh()
	end

	return arg_37_0._items
end

BackendInterfaceItemPlayfab.get_all_fake_backend_items = function (arg_38_0)
	if arg_38_0._dirty then
		arg_38_0:_refresh()
	end

	return arg_38_0._fake_items
end

BackendInterfaceItemPlayfab.get_loadout = function (arg_39_0)
	if arg_39_0._dirty then
		arg_39_0:_refresh()
	end

	local var_39_0 = table.clone(arg_39_0._loadouts)

	for iter_39_0, iter_39_1 in pairs(arg_39_0._default_loadout_overrides) do
		var_39_0[iter_39_0] = iter_39_1
	end

	return var_39_0
end

BackendInterfaceItemPlayfab.get_bot_loadout = function (arg_40_0)
	if arg_40_0._dirty then
		arg_40_0:_refresh()
	end

	return arg_40_0._bot_loadouts
end

BackendInterfaceItemPlayfab.get_career_loadouts = function (arg_41_0, arg_41_1)
	if arg_41_0._dirty then
		arg_41_0:_refresh()
	end

	return arg_41_0._career_loadouts[arg_41_1]
end

BackendInterfaceItemPlayfab.get_selected_career_loadout = function (arg_42_0, arg_42_1)
	if arg_42_0._dirty then
		arg_42_0:_refresh()
	end

	return arg_42_0._selected_career_custom_loadouts[arg_42_1]
end

BackendInterfaceItemPlayfab.get_default_loadouts = function (arg_43_0, arg_43_1)
	if arg_43_0._dirty then
		arg_43_0:_refresh()
	end

	return arg_43_0._default_loadouts[arg_43_1]
end

BackendInterfaceItemPlayfab.get_loadout_by_career_name = function (arg_44_0, arg_44_1, arg_44_2)
	if arg_44_0._dirty then
		arg_44_0:_refresh()
	end

	local var_44_0 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()
	local var_44_1 = InventorySettings.bot_loadout_allowed_game_modes[var_44_0]
	local var_44_2 = InventorySettings.default_loadout_allowed_game_modes[var_44_0]
	local var_44_3 = var_44_1 and arg_44_0:get_bot_loadout()
	local var_44_4 = var_44_1 and var_44_3[arg_44_1]
	local var_44_5 = var_44_2 and arg_44_0:get_default_loadouts(arg_44_1)
	local var_44_6 = var_44_2 and var_44_5 and var_44_5[1]
	local var_44_7 = arg_44_0:get_loadout()[arg_44_1]

	return var_44_1 and arg_44_2 and var_44_4 or arg_44_2 and var_44_2 and var_44_6 or var_44_7
end

BackendInterfaceItemPlayfab.get_loadout_item_id = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()
	local var_45_1 = InventorySettings.bot_loadout_allowed_game_modes[var_45_0]
	local var_45_2 = InventorySettings.default_loadout_allowed_game_modes[var_45_0]
	local var_45_3 = var_45_1 and arg_45_0:get_bot_loadout()
	local var_45_4 = var_45_1 and var_45_3[arg_45_1]
	local var_45_5 = var_45_2 and arg_45_0:get_default_loadouts(arg_45_1)
	local var_45_6 = var_45_2 and var_45_5 and var_45_5[1]
	local var_45_7 = arg_45_0:get_loadout()[arg_45_1]
	local var_45_8 = var_45_1 and arg_45_3 and not table.is_empty(var_45_4) and var_45_4 or arg_45_3 and var_45_2 and var_45_6 or var_45_7
	local var_45_9 = var_45_8 and var_45_8[arg_45_2]

	if CosmeticUtils.is_cosmetic_slot(arg_45_2) and var_45_9 then
		return arg_45_0._backend_mirror:get_unlocked_cosmetics()[var_45_9]
	elseif arg_45_2 == "slot_pose" and var_45_9 then
		local var_45_10 = ItemMasterList[var_45_9].parent
		local var_45_11 = arg_45_0:get_unlocked_weapon_poses()

		return var_45_11[var_45_10] and var_45_11[var_45_10][var_45_9]
	end

	return var_45_8 and var_45_8[arg_45_2]
end

BackendInterfaceItemPlayfab.get_unlocked_weapon_poses = function (arg_46_0)
	return arg_46_0._backend_mirror:get_unlocked_weapon_poses()
end

BackendInterfaceItemPlayfab.get_dirty_weapon_pose_data = function (arg_47_0)
	return {
		equipped_weapon_pose_skin = arg_47_0._dirty_weapon_pose_skins
	}
end

BackendInterfaceItemPlayfab.clear_dirty_weapon_pose_data = function (arg_48_0)
	table.clear(arg_48_0._dirty_weapon_pose_skins)
end

BackendInterfaceItemPlayfab.get_equipped_weapon_pose_skins = function (arg_49_0)
	return arg_49_0._backend_mirror:get_equipped_weapon_pose_skins()
end

BackendInterfaceItemPlayfab.get_equipped_weapon_pose_skin = function (arg_50_0, arg_50_1)
	return arg_50_0._backend_mirror:get_equipped_weapon_pose_skin(arg_50_1)
end

BackendInterfaceItemPlayfab.get_weapon_pose_from_pose_key = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0:get_all_fake_backend_items()

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if iter_51_1.item_type == "weapon_pose" then
			return iter_51_0, iter_51_1
		end
	end
end

BackendInterfaceItemPlayfab.get_backend_id_from_unlocked_weapon_poses = function (arg_52_0, arg_52_1)
	local var_52_0 = ItemMasterList[arg_52_1].parent
	local var_52_1 = arg_52_0:get_unlocked_weapon_poses()[var_52_0]

	return var_52_1 and var_52_1[arg_52_1]
end

BackendInterfaceItemPlayfab.set_weapon_pose_skin = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	if arg_53_2 then
		local var_53_0 = arg_53_0._backend_mirror:get_equipped_weapon_pose_skins()[arg_53_1]

		if arg_53_0:get_weapon_skin_from_skin_key(var_53_0) ~= arg_53_2 then
			local var_53_1 = arg_53_0:get_item_from_id(arg_53_2).skin

			arg_53_0._dirty_weapon_pose_skins[arg_53_1] = var_53_1

			arg_53_0._backend_mirror:set_weapon_pose_skin(arg_53_1, var_53_1)
		end
	end
end

BackendInterfaceItemPlayfab.get_cosmetic_loadout = function (arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()
	local var_54_1 = InventorySettings.bot_loadout_allowed_game_modes[var_54_0]
	local var_54_2 = InventorySettings.default_loadout_allowed_game_modes[var_54_0]
	local var_54_3 = var_54_1 and arg_54_0:get_bot_loadout()
	local var_54_4 = var_54_1 and var_54_3[arg_54_1]
	local var_54_5 = var_54_2 and arg_54_0:get_default_loadouts(arg_54_1)
	local var_54_6 = var_54_2 and var_54_5 and var_54_5[1]
	local var_54_7 = arg_54_0:get_loadout()[arg_54_1]
	local var_54_8 = var_54_1 and arg_54_2 and var_54_4 or arg_54_2 and var_54_2 and var_54_6 or var_54_7

	return var_54_8.slot_hat, var_54_8.slot_skin, var_54_8.slot_frame
end

BackendInterfaceItemPlayfab.get_item_name = function (arg_55_0, arg_55_1)
	return arg_55_0:get_all_backend_items()[arg_55_1].key
end

local var_0_3 = {}

BackendInterfaceItemPlayfab.get_filtered_items = function (arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = arg_56_0:get_all_backend_items()

	return (Managers.backend:get_interface("common"):filter_items(var_56_0, arg_56_1, arg_56_2 or var_0_3))
end

BackendInterfaceItemPlayfab.set_loadout_item = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0 = arg_57_0:get_all_backend_items()
	local var_57_1

	if arg_57_1 then
		var_57_1 = var_57_0[arg_57_1]

		fassert(var_57_1, "Trying to equip item that doesn't exist %d", arg_57_1 or "nil")
	end

	if not var_57_1 then
		print("[BackendInterfaceItemPlayfab] Attempted to equip weapon that doesn't exist:", arg_57_1, arg_57_2, arg_57_3)

		return false
	end

	if var_57_1.rarity == "magic" then
		print("[BackendInterfaceItemPlayfab] Attempted to equip magic weapon in adventure:", arg_57_1, arg_57_2, arg_57_3)

		return false
	end

	if CosmeticUtils.is_cosmetic_slot(arg_57_3) then
		arg_57_1 = var_57_1.override_id or var_57_1.ItemId
	end

	if arg_57_3 == "slot_pose" then
		arg_57_1 = var_57_1.override_id or var_57_1.ItemId
	end

	arg_57_0._backend_mirror:set_character_data(arg_57_2, arg_57_3, arg_57_1, nil, arg_57_4)

	arg_57_0._dirty = true

	return true
end

BackendInterfaceItemPlayfab.add_steam_items = function (arg_58_0, arg_58_1)
	arg_58_0._backend_mirror:add_steam_items(arg_58_1)
	arg_58_0:_refresh_items()
end

local var_0_4 = {
	weapon_pose = true,
	weapon_skin = true,
	item = true,
	loot_chest = true,
	keep_decoration_painting = true
}

BackendInterfaceItemPlayfab.get_unseen_item_rewards = function (arg_59_0)
	local var_59_0 = arg_59_0._backend_mirror:get_user_data("unseen_rewards")

	if not var_59_0 then
		return nil
	end

	local var_59_1 = cjson.decode(var_59_0)
	local var_59_2
	local var_59_3 = 1

	while var_59_3 <= #var_59_1 do
		local var_59_4 = var_59_1[var_59_3]
		local var_59_5 = var_59_4.reward_type

		if var_0_4[var_59_5] or CosmeticUtils.is_cosmetic_item(var_59_5) then
			var_59_2 = var_59_2 or {}
			var_59_2[#var_59_2 + 1] = var_59_4

			table.remove(var_59_1, var_59_3)
		else
			var_59_3 = var_59_3 + 1
		end
	end

	if var_59_2 then
		arg_59_0._backend_mirror:set_user_data("unseen_rewards", cjson.encode(var_59_1))
	end

	return var_59_2
end

BackendInterfaceItemPlayfab.remove_item = function (arg_60_0, arg_60_1, arg_60_2)
	return
end

BackendInterfaceItemPlayfab.award_item = function (arg_61_0, arg_61_1)
	return
end

BackendInterfaceItemPlayfab.data_server_script = function (arg_62_0, arg_62_1, ...)
	return
end

BackendInterfaceItemPlayfab.upgrades_failed_game = function (arg_63_0, arg_63_1, arg_63_2)
	return
end

BackendInterfaceItemPlayfab.poll_upgrades_failed_game = function (arg_64_0)
	return
end

BackendInterfaceItemPlayfab.generate_item_server_loot = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6)
	return
end

BackendInterfaceItemPlayfab.check_for_loot = function (arg_66_0)
	return
end

BackendInterfaceItemPlayfab.equipped_by = function (arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0:get_loadout()
	local var_67_1 = {}

	for iter_67_0, iter_67_1 in pairs(var_67_0) do
		for iter_67_2, iter_67_3 in pairs(iter_67_1) do
			if arg_67_1 == iter_67_3 then
				table.insert(var_67_1, iter_67_0)
			end
		end
	end

	return var_67_1
end

local var_0_5 = {}

BackendInterfaceItemPlayfab.equipped_by_loadout = function (arg_68_0, arg_68_1)
	local var_68_0 = arg_68_0._career_loadouts

	table.clear(var_0_5)

	for iter_68_0, iter_68_1 in pairs(var_68_0) do
		for iter_68_2, iter_68_3 in ipairs(iter_68_1) do
			for iter_68_4, iter_68_5 in pairs(iter_68_3) do
				if arg_68_1 == iter_68_5 then
					var_0_5[iter_68_0] = var_0_5[iter_68_0] or {}
					var_0_5[iter_68_0][#var_0_5[iter_68_0] + 1] = iter_68_2
				end
			end
		end

		if var_0_5[iter_68_0] then
			var_0_5[iter_68_0].num_loadouts = #iter_68_1
		end
	end

	return var_0_5
end

BackendInterfaceItemPlayfab.is_equipped_by_any_loadout = function (arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0._career_loadouts
	local var_69_1 = {}

	for iter_69_0, iter_69_1 in pairs(var_69_0) do
		for iter_69_2, iter_69_3 in ipairs(iter_69_1) do
			for iter_69_4, iter_69_5 in pairs(iter_69_3) do
				if arg_69_1 == iter_69_5 then
					table.insert(var_69_1, iter_69_0 .. "_" .. iter_69_2)
				end
			end
		end
	end

	return var_69_1
end

BackendInterfaceItemPlayfab.is_equipped = function (arg_70_0, arg_70_1, arg_70_2)
	return
end

BackendInterfaceItemPlayfab.set_data_server_queue = function (arg_71_0, arg_71_1)
	return
end

BackendInterfaceItemPlayfab.make_dirty = function (arg_72_0)
	arg_72_0._dirty = true
end

BackendInterfaceItemPlayfab.has_item = function (arg_73_0, arg_73_1)
	local var_73_0 = arg_73_0:get_all_backend_items()

	for iter_73_0, iter_73_1 in pairs(var_73_0) do
		if arg_73_1 == iter_73_1.key then
			return true
		end
	end

	return false
end

BackendInterfaceItemPlayfab.has_weapon_illusion = function (arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0:get_all_fake_backend_items()

	for iter_74_0, iter_74_1 in pairs(var_74_0) do
		if arg_74_1 == iter_74_1.skin then
			return true
		end
	end

	return false
end

BackendInterfaceItemPlayfab.has_bundle_contents = function (arg_75_0, arg_75_1)
	if not arg_75_1 then
		return false, false, nil
	end

	local var_75_0 = true
	local var_75_1 = false
	local var_75_2 = {}

	for iter_75_0 = 1, #arg_75_1 do
		local var_75_3 = arg_75_1[iter_75_0]
		local var_75_4 = SteamitemdefidToMasterList[var_75_3]
		local var_75_5 = ItemMasterList[var_75_4].required_dlc

		if var_75_5 and not Managers.unlock:is_dlc_unlocked(var_75_5) and not table.find(var_75_2, var_75_5) then
			var_75_2[#var_75_2 + 1] = var_75_5
		end

		if arg_75_0:has_item(var_75_4) or arg_75_0:has_weapon_illusion(var_75_4) then
			var_75_1 = true
		else
			var_75_0 = false
		end
	end

	return var_75_0, var_75_1, var_75_2
end

BackendInterfaceItemPlayfab.get_item_template = function (arg_76_0, arg_76_1, arg_76_2)
	local var_76_0 = arg_76_1.temporary_template or arg_76_1.template
	local var_76_1 = WeaponUtils.get_weapon_template(var_76_0)

	if var_76_1 then
		return var_76_1
	end

	local var_76_2 = Attachments[var_76_0]

	if var_76_2 then
		return var_76_2
	end

	local var_76_3 = Cosmetics[var_76_0]

	if var_76_3 then
		return var_76_3
	end

	fassert(false, "no item_template for item: " .. arg_76_1.key .. ", template name = " .. var_76_0)
end

BackendInterfaceItemPlayfab.sum_best_power_levels = function (arg_77_0)
	local var_77_0 = script_data.sum_of_best_power_levels_override

	if var_77_0 then
		return var_77_0
	else
		return arg_77_0._backend_mirror.sum_best_power_levels
	end
end

BackendInterfaceItemPlayfab.configure_game_mode_specific_items = function (arg_78_0, arg_78_1, arg_78_2)
	arg_78_0._game_mode_specific_items[arg_78_1] = arg_78_2
end

BackendInterfaceItemPlayfab.set_game_mode_specific_items = function (arg_79_0, arg_79_1)
	arg_79_0._active_game_mode_specific_items = arg_79_0._game_mode_specific_items[arg_79_1]

	arg_79_0:make_dirty()
end

BackendInterfaceItemPlayfab.refresh_game_mode_specific_items = function (arg_80_0)
	arg_80_0:make_dirty()
end

local var_0_6 = 300

BackendInterfaceItemPlayfab.delete_marked_deeds = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	arg_81_0._is_deleting_deeds = true
	arg_81_2 = arg_81_2 or 1
	arg_81_3 = arg_81_3 or var_0_6

	local var_81_0 = arg_81_0:_new_id()
	local var_81_1
	local var_81_2 = #arg_81_1

	if arg_81_2 > 1 then
		var_81_1 = table.slice(arg_81_1, arg_81_2, var_81_2)
	else
		var_81_1 = arg_81_1
	end

	local var_81_3 = table.map(var_81_1, function (arg_82_0)
		return {
			ItemInstanceId = arg_82_0.ItemInstanceId
		}
	end)

	if arg_81_3 < var_81_2 then
		for iter_81_0 = var_0_6 + 1, var_81_2 do
			var_81_3[iter_81_0] = nil
		end
	end

	local var_81_4 = {
		FunctionName = "deleteMarkedDeeds",
		FunctionParameter = {
			marked_deeds_list = var_81_3
		}
	}
	local var_81_5 = {
		marked_deeds_list = var_81_3,
		id = var_81_0
	}
	local var_81_6 = callback(arg_81_0, "delete_marked_deeds_request_cb", var_81_5, arg_81_3, arg_81_2, arg_81_1)

	arg_81_0._backend_mirror:request_queue():enqueue(var_81_4, var_81_6, true)
end

BackendInterfaceItemPlayfab.delete_marked_deeds_request_cb = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4, arg_83_5)
	local var_83_0 = arg_83_5.FunctionResult
	local var_83_1 = var_83_0.item_revokes
	local var_83_2 = arg_83_0._backend_mirror

	if not var_83_0 then
		Managers.backend:playfab_api_error(arg_83_5)

		return
	elseif var_83_0.error_message == "no_items_received" then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_REMOVE_DEEDS_NO_ITEMS_RECEIVED)

		return
	end

	if var_83_1 then
		for iter_83_0 = 1, #var_83_1 do
			local var_83_3 = var_83_1[iter_83_0].ItemInstanceId

			var_83_2:remove_item(var_83_3)
		end
	end

	if arg_83_2 < #arg_83_4 then
		local var_83_4 = arg_83_3 + var_0_6
		local var_83_5 = arg_83_2 + var_0_6

		arg_83_0:delete_marked_deeds(arg_83_4, var_83_4, var_83_5)
	else
		arg_83_0._is_deleting_deeds = false

		Managers.backend:dirtify_interfaces()
	end
end

BackendInterfaceItemPlayfab.is_deleting_deeds = function (arg_84_0)
	return arg_84_0._is_deleting_deeds
end

BackendInterfaceItemPlayfab._new_id = function (arg_85_0)
	arg_85_0._last_id = arg_85_0._last_id + 1

	return arg_85_0._last_id
end

BackendInterfaceItemPlayfab.can_delete_deeds = function (arg_86_0, arg_86_1, arg_86_2)
	if #arg_86_1 == #arg_86_2 then
		return true, arg_86_1, arg_86_2
	end

	local var_86_0 = {}
	local var_86_1 = {}
	local var_86_2 = arg_86_1

	for iter_86_0, iter_86_1 in ipairs(arg_86_2) do
		local var_86_3 = table.index_of(var_86_2, iter_86_1)

		if var_86_3 ~= -1 then
			table.insert(var_86_1, iter_86_1)
			table.swap_delete(var_86_2, var_86_3)
		end
	end

	if table.is_empty(var_86_1) then
		return false, var_86_2, nil
	end

	return true, var_86_2, var_86_1
end
