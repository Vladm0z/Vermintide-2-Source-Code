-- chunkname: @scripts/helpers/item_helper.lua

require("scripts/settings/equipment/item_master_list")
local_require("scripts/settings/equipment/attachments")
local_require("scripts/settings/equipment/cosmetics")

ItemHelper = ItemHelper or {}

local var_0_0 = {
	melee = Weapons,
	ranged = Weapons,
	trinket = Attachments,
	ring = Attachments,
	necklace = Attachments,
	hat = Attachments,
	skin = Cosmetics,
	frame = Cosmetics,
	color_tint = Cosmetics,
	weapon_pose = Cosmetics,
	chips = Cosmetics
}
local var_0_1 = {
	speed = 2,
	range = 5,
	damage = 1,
	targets = 3,
	stagger = 4
}
local var_0_2 = {
	burn = "item_compare_burn",
	range = "item_compare_range",
	armor_penetration = "item_compare_armor_penetration",
	damage = "item_compare_damage",
	head_shot = "item_compare_head_shot",
	poison = "item_compare_poison",
	speed = "item_compare_attack_speed",
	targets = "item_compare_targets",
	stagger = "item_compare_stagger"
}

ItemHelper.get_template_by_item_name = function (arg_1_0)
	local var_1_0 = ItemMasterList[arg_1_0]

	fassert(var_1_0, "Requested template for item %s which does not exist.", arg_1_0)

	local var_1_1 = var_1_0.slot_type
	local var_1_2 = var_1_0.template

	var_1_2 = var_1_0.temporary_template or var_1_2

	local var_1_3 = var_0_0[var_1_1]
	local var_1_4

	if var_1_3 == Weapons then
		var_1_4 = WeaponUtils.get_weapon_template(var_1_2)
	elseif var_1_1 == "frame" then
		var_1_4 = CosmeticUtils.generate_frame_template(arg_1_0)
	else
		var_1_4 = var_0_0[var_1_1][var_1_2]
	end

	fassert(var_1_4, "No template by name %s found for item_data %s.", var_1_2, arg_1_0)

	return var_1_4
end

ItemHelper.get_slot_type = function (arg_2_0)
	local var_2_0 = #InventorySettings.slots

	for iter_2_0 = 1, var_2_0 do
		local var_2_1 = InventorySettings[iter_2_0]

		if var_2_1.name == arg_2_0 then
			return var_2_1.type
		end
	end

	fassert(false, "no slot in InventorySettings.slots with name: ", arg_2_0)
end

ItemHelper.mark_sign_in_reward_as_new = function (arg_3_0, arg_3_1)
	local var_3_0 = PlayerData.new_sign_in_rewards or {}
	local var_3_1 = var_3_0[arg_3_0]

	if not var_3_1 then
		var_3_1 = {}
		var_3_0[arg_3_0] = var_3_1
	end

	var_3_1[#var_3_1 + 1] = arg_3_1
	PlayerData.new_sign_in_rewards = var_3_0

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.unmark_sign_in_reward_as_new = function (arg_4_0)
	local var_4_0 = PlayerData.new_sign_in_rewards

	fassert(var_4_0, "Tried to unmark sign-in reward as new but the save data wasn't found")

	local var_4_1 = var_4_0[arg_4_0]

	if var_4_1 then
		for iter_4_0, iter_4_1 in ipairs(var_4_1) do
			ItemHelper.unmark_backend_id_as_new(iter_4_1, true)
		end
	end

	var_4_0[arg_4_0] = nil

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.has_new_sign_in_reward = function (arg_5_0)
	if arg_5_0 then
		return PlayerData.new_sign_in_rewards[arg_5_0] and true or false
	else
		return next(PlayerData.new_sign_in_rewards) ~= nil
	end
end

ItemHelper.mark_backend_id_as_new = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.backend:get_interface("items")
	local var_6_1 = (arg_6_1 or var_6_0:get_item_from_id(arg_6_0)).data
	local var_6_2 = var_6_1.slot_type
	local var_6_3 = var_6_1.can_wield
	local var_6_4 = PlayerData.new_item_ids or {}

	var_6_4[arg_6_0] = true

	local var_6_5 = CareerSettings
	local var_6_6 = PlayerData.new_item_ids_by_career or {}

	for iter_6_0, iter_6_1 in ipairs(var_6_3) do
		local var_6_7 = var_6_6[iter_6_1] or {}
		local var_6_8 = var_6_7[var_6_2] or {}

		var_6_8[arg_6_0] = true
		var_6_7[var_6_2] = var_6_8
		var_6_6[iter_6_1] = var_6_7
	end

	PlayerData.new_item_ids = var_6_4
	PlayerData.new_item_ids_by_career = var_6_6

	if arg_6_2 then
		return
	end

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.unmark_backend_id_as_new = function (arg_7_0, arg_7_1)
	local var_7_0 = PlayerData.new_item_ids
	local var_7_1 = PlayerData.new_item_ids_by_career

	assert(var_7_0, "Requested to unmark item backend id %d without any save data.", arg_7_0)

	var_7_0[arg_7_0] = nil

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		for iter_7_2, iter_7_3 in pairs(iter_7_1) do
			for iter_7_4, iter_7_5 in pairs(iter_7_3) do
				if iter_7_4 == arg_7_0 then
					iter_7_3[arg_7_0] = nil

					break
				end
			end
		end
	end

	if not arg_7_1 then
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ItemHelper.get_new_backend_ids = function ()
	return PlayerData.new_item_ids
end

ItemHelper.is_new_backend_id = function (arg_9_0)
	local var_9_0 = PlayerData.new_item_ids

	return var_9_0 and var_9_0[arg_9_0]
end

ItemHelper.has_new_backend_ids_by_career_name_and_slot_type = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = PlayerData.new_item_ids_by_career

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if arg_10_0 == iter_10_0 then
			for iter_10_2, iter_10_3 in pairs(iter_10_1) do
				if arg_10_1 == iter_10_2 then
					for iter_10_4, iter_10_5 in pairs(iter_10_3) do
						if iter_10_5 then
							if arg_10_2 then
								local var_10_1 = BackendUtils.get_item_from_masterlist(iter_10_4)

								if var_10_1 then
									if not arg_10_2[var_10_1.rarity] then
										return true
									end
								else
									ItemHelper.unmark_backend_id_as_new(iter_10_4)
								end
							else
								return true
							end
						end
					end
				end
			end
		end
	end

	return false
end

ItemHelper.has_new_backend_ids_by_slot_type = function (arg_11_0, arg_11_1)
	local var_11_0 = PlayerData.new_item_ids_by_career

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1) do
			if arg_11_0 == iter_11_2 then
				for iter_11_4, iter_11_5 in pairs(iter_11_3) do
					if iter_11_5 then
						if arg_11_1 then
							local var_11_1 = BackendUtils.get_item_from_masterlist(iter_11_4)

							if var_11_1 then
								if not arg_11_1[var_11_1.rarity] then
									return true
								end
							else
								ItemHelper.unmark_backend_id_as_new(iter_11_4)
							end
						else
							return true
						end
					end
				end
			end
		end
	end

	return false
end

ItemHelper.has_new_backend_ids_by_career_name = function (arg_12_0, arg_12_1)
	local var_12_0 = PlayerData.new_item_ids_by_career

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if arg_12_0 == iter_12_0 then
			for iter_12_2, iter_12_3 in pairs(iter_12_1) do
				for iter_12_4, iter_12_5 in pairs(iter_12_3) do
					if iter_12_5 then
						if arg_12_1 then
							local var_12_1 = BackendUtils.get_item_from_masterlist(iter_12_4)

							if var_12_1 then
								if not arg_12_1[var_12_1.rarity] then
									return true
								end
							else
								ItemHelper.unmark_backend_id_as_new(iter_12_4)
							end
						else
							return true
						end
					end
				end
			end
		end
	end

	return false
end

ItemHelper.retrieve_weapon_item_statistics = function (arg_13_0, arg_13_1)
	local var_13_0 = {}
	local var_13_1 = {}
	local var_13_2 = BackendUtils.get_item_template(arg_13_0, arg_13_1).compare_statistics
	local var_13_3 = var_13_2 and var_13_2.attacks
	local var_13_4

	var_13_4 = var_13_2 and var_13_2.perks

	if var_13_3 then
		local var_13_5 = var_13_3.light_attack
		local var_13_6 = var_13_3.heavy_attack

		ItemHelper._retrieve_weapon_attack_data(var_13_5, var_13_0)
		ItemHelper._retrieve_weapon_attack_data(var_13_6, var_13_0)
	end

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		var_13_1[var_0_1[iter_13_0]] = iter_13_1
	end

	return var_13_1
end

ItemHelper._retrieve_weapon_attack_data = function (arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_0) do
		local var_14_0 = var_0_2[iter_14_0]
		local var_14_1 = arg_14_1[iter_14_0] or {}

		var_14_1[#var_14_1 + 1] = {
			key = iter_14_0,
			title = Localize(var_14_0),
			value = iter_14_1
		}
		arg_14_1[iter_14_0] = var_14_1
	end
end

ItemHelper.weapon_stat_order_by_type = function (arg_15_0)
	return var_0_1[arg_15_0]
end

ItemHelper.on_inventory_item_added = function (arg_16_0)
	if arg_16_0.data.slot_type == ItemType.LOOT_CHEST then
		local var_16_0 = Managers.world

		if var_16_0:has_world("level_world") then
			local var_16_1 = var_16_0:world("level_world")

			LevelHelper:flow_event(var_16_1, "local_player_received_loot_chest")
		end
	end
end

ItemHelper.mark_backend_id_as_favorite = function (arg_17_0, arg_17_1, arg_17_2)
	arg_17_1 = arg_17_1 or Managers.backend:get_interface("items"):get_item_from_id(arg_17_0)

	local var_17_0 = arg_17_1.data
	local var_17_1 = var_17_0.slot_type
	local var_17_2 = var_17_0.can_wield
	local var_17_3

	if CosmeticUtils.is_cosmetic_item(var_17_1) then
		var_17_3 = arg_17_1.ItemId
	else
		var_17_3 = arg_17_0
	end

	local var_17_4 = PlayerData.favorite_item_ids or {}

	var_17_4[var_17_3] = true

	local var_17_5 = CareerSettings
	local var_17_6 = PlayerData.favorite_item_ids_by_career or {}

	for iter_17_0, iter_17_1 in ipairs(var_17_2) do
		local var_17_7 = var_17_6[iter_17_1] or {}
		local var_17_8 = var_17_7[var_17_1] or {}

		var_17_8[var_17_3] = true
		var_17_7[var_17_1] = var_17_8
		var_17_6[iter_17_1] = var_17_7
	end

	PlayerData.favorite_item_ids = var_17_4
	PlayerData.favorite_item_ids_by_career = var_17_6

	if arg_17_2 then
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ItemHelper.unmark_backend_id_as_favorite = function (arg_18_0, arg_18_1)
	if not arg_18_1 then
		local var_18_0 = Managers.backend:get_interface("items")

		if not var_18_0 then
			return
		end

		arg_18_1 = var_18_0:get_item_from_id(arg_18_0)
	end

	local var_18_1

	if arg_18_1 then
		local var_18_2 = arg_18_1.data.slot_type

		if CosmeticUtils.is_cosmetic_item(var_18_2) then
			var_18_1 = arg_18_1.ItemId
		else
			var_18_1 = arg_18_0
		end
	else
		var_18_1 = arg_18_0
	end

	local var_18_3 = PlayerData.favorite_item_ids
	local var_18_4 = PlayerData.favorite_item_ids_by_career

	assert(var_18_3, "Requested to unmark item backend id %d without any save data.", var_18_1)

	var_18_3[var_18_1] = nil

	for iter_18_0, iter_18_1 in pairs(var_18_4) do
		for iter_18_2, iter_18_3 in pairs(iter_18_1) do
			for iter_18_4, iter_18_5 in pairs(iter_18_3) do
				if iter_18_4 == var_18_1 then
					iter_18_3[var_18_1] = nil

					break
				end
			end
		end
	end
end

ItemHelper.get_favorite_backend_ids = function ()
	return PlayerData.favorite_item_ids
end

ItemHelper.is_favorite_backend_id = function (arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or Managers.backend:get_interface("items"):get_item_from_id(arg_20_0)

	local var_20_0 = arg_20_1.data.slot_type
	local var_20_1

	if CosmeticUtils.is_cosmetic_item(var_20_0) then
		var_20_1 = arg_20_1.ItemId
	else
		var_20_1 = arg_20_0
	end

	local var_20_2 = PlayerData.favorite_item_ids

	return var_20_2 and var_20_2[var_20_1]
end

ItemHelper.is_equiped_backend_id = function (arg_21_0, arg_21_1)
	local var_21_0 = Managers.backend:get_interface("items"):equipped_by(arg_21_0)
	local var_21_1 = #var_21_0

	return var_21_1 > 0 and (not arg_21_1 or table.contains(var_21_0, arg_21_1)), var_21_0, var_21_1
end

ItemHelper.get_equipped_slots = function (arg_22_0, arg_22_1)
	local var_22_0 = {}
	local var_22_1 = 0
	local var_22_2 = Managers.backend:get_interface("items"):get_loadout()[arg_22_1]

	if var_22_2 then
		for iter_22_0, iter_22_1 in pairs(var_22_2) do
			if arg_22_0 == iter_22_1 then
				var_22_1 = var_22_1 + 1
				var_22_0[var_22_1] = iter_22_0
			end
		end
	end

	return var_22_0, var_22_1
end

ItemHelper.mark_keep_decoration_as_new = function (arg_23_0)
	local var_23_0 = PlayerData.new_keep_decoration_ids or {}

	var_23_0[arg_23_0] = true
	PlayerData.new_keep_decoration_ids = var_23_0

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.unmark_keep_decoration_as_new = function (arg_24_0)
	PlayerData.new_keep_decoration_ids[arg_24_0] = nil

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.get_new_keep_decoration_ids = function ()
	return PlayerData.new_keep_decoration_ids
end

ItemHelper.is_new_keep_decoration_id = function (arg_26_0)
	local var_26_0 = PlayerData.new_keep_decoration_ids

	return var_26_0 and var_26_0[arg_26_0]
end

ItemHelper.tab_conversions = {
	dlc = "dlc",
	weapon_skin = "cosmetics",
	hat = "cosmetics",
	bundle = "bundles",
	featured = "featured",
	skin = "cosmetics"
}

local var_0_3 = ItemHelper.tab_conversions
local var_0_4 = {
	skin = true,
	weapon_skin = true,
	hat = true
}

ItemHelper.create_tab_unseen_item_stars = function (arg_27_0)
	local var_27_0 = StoreLayoutConfig.menu_options

	for iter_27_0 = 1, #var_27_0 do
		arg_27_0[var_27_0[iter_27_0]] = 0
	end

	local var_27_1 = Managers.backend:get_interface("peddler"):get_peddler_stock()
	local var_27_2 = PlayerData.seen_shop_items

	for iter_27_1, iter_27_2 in pairs(var_27_1) do
		local var_27_3 = iter_27_2.data

		if not var_27_2[iter_27_2.key] then
			local var_27_4 = var_27_3.item_type
			local var_27_5 = var_0_3[var_27_4]

			if arg_27_0[var_27_5] ~= nil then
				arg_27_0[var_27_5] = arg_27_0[var_27_5] + 1
			end
		end
	end

	for iter_27_3, iter_27_4 in pairs(StoreDlcSettingsByName) do
		if not var_27_2[iter_27_3] and arg_27_0.dlc ~= nil then
			arg_27_0.dlc = arg_27_0.dlc + 1
		end
	end
end

ItemHelper.update_featured_unseen = function (arg_28_0, arg_28_1)
	local var_28_0 = PlayerData.seen_shop_items

	arg_28_1.featured = 0

	for iter_28_0 = 1, #arg_28_0 do
		if not var_28_0[arg_28_0[iter_28_0].key] and arg_28_1.featured ~= nil then
			arg_28_1.featured = arg_28_1.featured + 1
		end
	end
end

ItemHelper.set_shop_item_seen = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = PlayerData.seen_shop_items

	if not var_29_0[arg_29_0] then
		var_29_0[arg_29_0] = true

		local var_29_1 = var_0_3[arg_29_1]

		if arg_29_2[var_29_1] ~= nil then
			arg_29_2[var_29_1] = arg_29_2[var_29_1] - 1
		end

		if arg_29_3 and arg_29_2[arg_29_3] ~= nil then
			arg_29_2[arg_29_3] = arg_29_2[arg_29_3] - 1
		end
	end
end

ItemHelper.set_all_shop_item_seen = function (arg_30_0)
	local var_30_0 = Managers.backend:get_interface("peddler"):get_peddler_stock()
	local var_30_1 = PlayerData.seen_shop_items

	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		var_30_1[iter_30_1.data.key] = true
	end

	for iter_30_2, iter_30_3 in pairs(StoreDlcSettingsByName) do
		var_30_1[iter_30_2] = true
	end

	for iter_30_4, iter_30_5 in pairs(arg_30_0) do
		arg_30_0[iter_30_4] = 0
	end

	PlayerData.store_new_items = false

	if Managers.state.event then
		Managers.state.event:trigger("set_all_shop_item_seen")
	end
end

ItemHelper.has_unseen_shop_items = function ()
	local var_31_0 = Managers.backend:get_interface("peddler"):get_peddler_stock()
	local var_31_1 = PlayerData.seen_shop_items

	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		if not var_31_1[iter_31_1.data.key] then
			return true
		end
	end

	for iter_31_2, iter_31_3 in pairs(StoreDlcSettingsByName) do
		if not var_31_1[iter_31_2] then
			return true
		end
	end

	return false
end

local var_0_5 = {
	weapon_pose = true,
	weapon_skin = true,
	hat = true,
	chips = true,
	frame = true,
	skin = true
}

ItemHelper.is_fake_item = function (arg_32_0)
	return var_0_5[arg_32_0]
end
