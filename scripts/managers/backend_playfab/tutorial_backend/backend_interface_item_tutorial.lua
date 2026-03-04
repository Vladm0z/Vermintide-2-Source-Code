-- chunkname: @scripts/managers/backend_playfab/tutorial_backend/backend_interface_item_tutorial.lua

BackendInterfaceItemTutorial = class(BackendInterfaceItemTutorial)

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceItemTutorial.init = function (arg_1_0, arg_1_1)
	arg_1_0._loadouts = {}
	arg_1_0._items = {}
	arg_1_0._backend_mirror = arg_1_1

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
	"slot_frame"
}

BackendInterfaceItemTutorial._refresh = function (arg_2_0)
	arg_2_0:_refresh_items()
	arg_2_0:_refresh_loadouts()

	arg_2_0._dirty = false
end

BackendInterfaceItemTutorial._refresh_items = function (arg_3_0)
	arg_3_0._items = {
		{
			key = "es_longbow_tutorial",
			rarity = "default",
			power_level = 10,
			backend_id = 1,
			data = ItemMasterList.es_longbow_tutorial
		},
		{
			key = "es_2h_hammer_tutorial",
			rarity = "default",
			power_level = 10,
			backend_id = 2,
			data = ItemMasterList.es_2h_hammer_tutorial
		},
		{
			key = "skin_es_knight",
			backend_id = 3,
			rarity = "default",
			data = ItemMasterList.skin_es_knight
		},
		{
			key = "knight_hat_0000",
			backend_id = 4,
			rarity = "default",
			data = ItemMasterList.knight_hat_0000
		},
		{
			key = "dr_crossbow",
			rarity = "default",
			power_level = 10,
			backend_id = 5,
			data = ItemMasterList.dr_crossbow
		},
		{
			key = "dr_1h_axe",
			rarity = "default",
			power_level = 10,
			backend_id = 6,
			data = ItemMasterList.dr_1h_axe
		},
		{
			key = "skin_dr_ranger",
			backend_id = 7,
			rarity = "default",
			data = ItemMasterList.skin_dr_ranger
		},
		{
			key = "ranger_hat_0000",
			backend_id = 8,
			rarity = "default",
			data = ItemMasterList.ranger_hat_0000
		},
		{
			key = "we_longbow",
			rarity = "default",
			power_level = 10,
			backend_id = 9,
			data = ItemMasterList.we_longbow
		},
		{
			key = "we_dual_wield_daggers",
			rarity = "default",
			power_level = 10,
			backend_id = 10,
			data = ItemMasterList.we_dual_wield_daggers
		},
		{
			key = "skin_ww_waywatcher",
			backend_id = 11,
			rarity = "default",
			data = ItemMasterList.skin_ww_waywatcher
		},
		{
			key = "waywatcher_hat_0000",
			backend_id = 12,
			rarity = "default",
			data = ItemMasterList.waywatcher_hat_0000
		},
		{
			key = "bw_skullstaff_fireball",
			rarity = "default",
			power_level = 10,
			backend_id = 13,
			data = ItemMasterList.bw_skullstaff_fireball
		},
		{
			key = "bw_1h_mace",
			rarity = "default",
			power_level = 10,
			backend_id = 14,
			data = ItemMasterList.bw_1h_mace
		},
		{
			key = "skin_bw_adept",
			backend_id = 15,
			rarity = "default",
			data = ItemMasterList.skin_bw_adept
		},
		{
			key = "adept_hat_0000",
			backend_id = 16,
			rarity = "default",
			data = ItemMasterList.adept_hat_0000
		}
	}
end

BackendInterfaceItemTutorial._refresh_loadouts = function (arg_4_0)
	arg_4_0._loadouts = {
		empire_soldier_tutorial = {
			slot_skin = 3,
			slot_melee = 2,
			slot_hat = 4,
			slot_ranged = 1
		},
		dr_ranger = {
			slot_skin = 7,
			slot_melee = 6,
			slot_hat = 8,
			slot_ranged = 5
		},
		we_waywatcher = {
			slot_skin = 11,
			slot_melee = 10,
			slot_hat = 12,
			slot_ranged = 9
		},
		bw_adept = {
			slot_skin = 15,
			slot_melee = 14,
			slot_hat = 16,
			slot_ranged = 13
		}
	}
end

BackendInterfaceItemTutorial.ready = function (arg_5_0)
	if arg_5_0._items then
		return true
	end

	return false
end

BackendInterfaceItemTutorial.type = function (arg_6_0)
	return "backend"
end

BackendInterfaceItemTutorial.update = function (arg_7_0)
	return
end

BackendInterfaceItemTutorial.refresh_entities = function (arg_8_0)
	return
end

BackendInterfaceItemTutorial.check_for_errors = function (arg_9_0)
	return
end

BackendInterfaceItemTutorial.num_current_item_server_requests = function (arg_10_0)
	return 0
end

BackendInterfaceItemTutorial.set_properties_serialized = function (arg_11_0, arg_11_1, arg_11_2)
	return
end

BackendInterfaceItemTutorial.get_traits = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:get_item_from_id(arg_12_1)

	if var_12_0 then
		return var_12_0.traits
	end

	return nil
end

BackendInterfaceItemTutorial.set_runes = function (arg_13_0, arg_13_1, arg_13_2)
	return
end

BackendInterfaceItemTutorial.get_runes = function (arg_14_0, arg_14_1)
	return
end

BackendInterfaceItemTutorial.socket_rune = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	return
end

BackendInterfaceItemTutorial.get_skin = function (arg_16_0)
	return nil
end

BackendInterfaceItemTutorial.get_item_masterlist_data = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0:get_item_from_id(arg_17_1)

	if var_17_0 then
		return var_17_0.data
	end
end

BackendInterfaceItemTutorial.get_item_amount = function (arg_18_0, arg_18_1)
	return arg_18_0:get_item_from_id(arg_18_1).RemainingUses or 1
end

BackendInterfaceItemTutorial.get_item_power_level = function (arg_19_0, arg_19_1)
	return arg_19_0:get_item_from_id(arg_19_1).power_level
end

BackendInterfaceItemTutorial.get_item_rarity = function (arg_20_0, arg_20_1)
	return arg_20_0:get_item_from_id(arg_20_1).rarity
end

BackendInterfaceItemTutorial.get_key = function (arg_21_0, arg_21_1)
	return arg_21_0:get_item_from_id(arg_21_1).key
end

BackendInterfaceItemTutorial.get_item_from_id = function (arg_22_0, arg_22_1)
	return arg_22_0:get_all_backend_items()[arg_22_1]
end

BackendInterfaceItemTutorial.get_item_from_key = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:get_all_backend_items()

	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		if iter_23_1.key == arg_23_1 then
			return iter_23_1
		end
	end
end

BackendInterfaceItemTutorial.get_all_backend_items = function (arg_24_0)
	if arg_24_0._dirty then
		arg_24_0:_refresh()
	end

	return arg_24_0._items
end

BackendInterfaceItemTutorial.get_loadout = function (arg_25_0)
	if arg_25_0._dirty then
		arg_25_0:_refresh()
	end

	return arg_25_0._loadouts
end

BackendInterfaceItemTutorial.get_loadout_by_career_name = function (arg_26_0, arg_26_1)
	if arg_26_0._dirty then
		arg_26_0:_refresh()
	end

	return arg_26_0._loadouts[arg_26_1]
end

BackendInterfaceItemTutorial.get_loadout_item_id = function (arg_27_0, arg_27_1, arg_27_2)
	return arg_27_0:get_loadout()[arg_27_1][arg_27_2]
end

local var_0_2 = {}

BackendInterfaceItemTutorial.get_filtered_items = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0:get_all_backend_items()

	return (Managers.backend:get_interface("common"):filter_items(var_28_0, arg_28_1, arg_28_2 or var_0_2))
end

BackendInterfaceItemTutorial.set_loadout_item = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0:get_all_backend_items()

	if arg_29_1 then
		fassert(var_29_0[arg_29_1], "Trying to equip item that doesn't exist %d", arg_29_1 or "nil")
	end

	arg_29_0._backend_mirror:set_character_data(arg_29_2, arg_29_3, arg_29_1)

	arg_29_0._dirty = true
end

BackendInterfaceItemTutorial.remove_item = function (arg_30_0, arg_30_1, arg_30_2)
	return
end

BackendInterfaceItemTutorial.award_item = function (arg_31_0, arg_31_1)
	return
end

BackendInterfaceItemTutorial.data_server_script = function (arg_32_0, arg_32_1, ...)
	return
end

BackendInterfaceItemTutorial.upgrades_failed_game = function (arg_33_0, arg_33_1, arg_33_2)
	return
end

BackendInterfaceItemTutorial.poll_upgrades_failed_game = function (arg_34_0)
	return
end

BackendInterfaceItemTutorial.generate_item_server_loot = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
	return
end

BackendInterfaceItemTutorial.check_for_loot = function (arg_36_0)
	return
end

BackendInterfaceItemTutorial.equipped_by = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._loadouts
	local var_37_1 = {}

	for iter_37_0, iter_37_1 in pairs(var_37_0) do
		for iter_37_2, iter_37_3 in pairs(iter_37_1) do
			if arg_37_1 == iter_37_3 then
				table.insert(var_37_1, iter_37_0)
			end
		end
	end

	return var_37_1
end

BackendInterfaceItemTutorial.is_equipped = function (arg_38_0, arg_38_1, arg_38_2)
	return
end

BackendInterfaceItemTutorial.set_data_server_queue = function (arg_39_0, arg_39_1)
	return
end

BackendInterfaceItemTutorial.make_dirty = function (arg_40_0)
	arg_40_0._dirty = true
end

BackendInterfaceItemTutorial.has_item = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0:get_all_backend_items()

	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		if arg_41_1 == iter_41_1.key then
			return true
		end
	end

	return false
end

BackendInterfaceItemTutorial.get_item_template = function (arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_1.temporary_template or arg_42_1.template
	local var_42_1 = WeaponUtils.get_weapon_template(var_42_0)

	if var_42_1 then
		return var_42_1
	end

	local var_42_2 = Attachments[var_42_0]

	if var_42_2 then
		return var_42_2
	end

	local var_42_3 = Cosmetics[var_42_0]

	if var_42_3 then
		return var_42_3
	end

	fassert(false, "no item_template for item: " .. arg_42_1.key .. ", template name = " .. var_42_0)
end

BackendInterfaceItemTutorial.sum_best_power_levels = function (arg_43_0)
	return 10
end

BackendInterfaceItemTutorial.configure_game_mode_specific_items = function (arg_44_0, arg_44_1, arg_44_2)
	return
end

BackendInterfaceItemTutorial.set_game_mode_specific_items = function (arg_45_0, arg_45_1)
	return
end

local var_0_3 = {
	equipped_weapon_pose_skin = {}
}

BackendInterfaceItemTutorial.get_dirty_weapon_pose_data = function (arg_46_0)
	return var_0_3
end

local var_0_4 = {}

BackendInterfaceItemTutorial.get_unlocked_weapon_poses = function (arg_47_0)
	return var_0_4
end

local var_0_5 = {}

BackendInterfaceItemTutorial.get_equipped_weapon_pose_skins = function (arg_48_0)
	return var_0_5
end

BackendInterfaceItemTutorial.get_equipped_weapon_pose_skin = function (arg_49_0, arg_49_1)
	return nil
end
