-- chunkname: @scripts/helpers/item_helper.lua

require("scripts/settings/equipment/item_master_list")
local_require("scripts/settings/equipment/attachments")
local_require("scripts/settings/equipment/cosmetics")

local ItemHelper = ItemHelper

ItemHelper = ItemHelper or {}
ItemHelper = ItemHelper

local tbl = {
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
local tbl_2 = {
	speed = 2,
	range = 5,
	damage = 1,
	targets = 3,
	stagger = 4
}
local tbl_3 = {
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
	-- function 1
	local var_1_0 = ItemMasterList[arg_1_0]

	fassert(var_1_0, "Requested template for item %s which does not exist.", arg_1_0)

	local slot_type = var_1_0.slot_type
	local template = var_1_0.template

	template = var_1_0.temporary_template or template

	local var_1_3 = tbl[slot_type]
	local var_1_4

	if var_1_3 == Weapons then
		var_1_4 = WeaponUtils.get_weapon_template(template)
	elseif slot_type == "frame" then
		var_1_4 = CosmeticUtils.generate_frame_template(arg_1_0)
	else
		var_1_4 = tbl[slot_type][template]
	end

	fassert(var_1_4, "No template by name %s found for item_data %s.", template, arg_1_0)

	return var_1_4
end

ItemHelper.get_slot_type = function (arg_2_0)
	-- function 2
	local count = #InventorySettings.slots

	for i = 1, count do
		local var_2_1 = InventorySettings[i]

		if var_2_1.name == arg_2_0 then
			return var_2_1.type
		end
	end

	fassert(false, "no slot in InventorySettings.slots with name: ", arg_2_0)
end

ItemHelper.mark_sign_in_reward_as_new = function (arg_3_0, arg_3_1)
	-- function 3
	local new_sign_in_rewards = PlayerData.new_sign_in_rewards

	new_sign_in_rewards = new_sign_in_rewards or {}

	local var_3_1 = new_sign_in_rewards[arg_3_0]

	if not var_3_1 then
		var_3_1 = {}
		new_sign_in_rewards[arg_3_0] = var_3_1
	end

	var_3_1[#var_3_1 + 1] = arg_3_1
	PlayerData.new_sign_in_rewards = new_sign_in_rewards

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.unmark_sign_in_reward_as_new = function (arg_4_0)
	-- function 4
	local new_sign_in_rewards = PlayerData.new_sign_in_rewards

	fassert(new_sign_in_rewards, "Tried to unmark sign-in reward as new but the save data wasn't found")

	local var_4_1 = new_sign_in_rewards[arg_4_0]

	if not var_4_1 then
		for i, v in ipairs(var_4_1) do
			ItemHelper.unmark_backend_id_as_new(v, true)
		end
	end

	new_sign_in_rewards[arg_4_0] = nil

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.has_new_sign_in_reward = function (arg_5_0)
	-- function 5
	if not arg_5_0 then
		local flag

		flag = not PlayerData.new_sign_in_rewards[arg_5_0] and true and false

		return flag
	else
		return next(PlayerData.new_sign_in_rewards) ~= nil
	end
end

ItemHelper.mark_backend_id_as_new = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local get_interface = Managers.backend:get_interface("items")
	local data = (arg_6_1 or get_interface:get_item_from_id(arg_6_0)).data
	local slot_type = data.slot_type
	local can_wield = data.can_wield
	local new_item_ids = PlayerData.new_item_ids

	new_item_ids = new_item_ids or {}
	new_item_ids[arg_6_0] = true

	local CareerSettings = CareerSettings
	local new_item_ids_by_career = PlayerData.new_item_ids_by_career

	new_item_ids_by_career = new_item_ids_by_career or {}

	for i, v in ipairs(can_wield) do
		local var_6_7 = new_item_ids_by_career[v]

		var_6_7 = var_6_7 or {}

		local var_6_8 = var_6_7[slot_type]

		var_6_8 = var_6_8 or {}
		var_6_8[arg_6_0] = true
		var_6_7[slot_type] = var_6_8
		new_item_ids_by_career[v] = var_6_7
	end

	PlayerData.new_item_ids = new_item_ids
	PlayerData.new_item_ids_by_career = new_item_ids_by_career

	if not arg_6_2 then
		return
	end

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.unmark_backend_id_as_new = function (arg_7_0, arg_7_1)
	-- function 7
	local new_item_ids = PlayerData.new_item_ids
	local new_item_ids_by_career = PlayerData.new_item_ids_by_career

	assert(new_item_ids, "Requested to unmark item backend id %d without any save data.", arg_7_0)

	new_item_ids[arg_7_0] = nil

	for k, v in pairs(new_item_ids_by_career) do
		for k_2, v_2 in pairs(v) do
			for k_3, v_3 in pairs(v_2) do
				if k_3 == arg_7_0 then
					v_2[arg_7_0] = nil

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
	-- function 8
	return PlayerData.new_item_ids
end

ItemHelper.is_new_backend_id = function (arg_9_0)
	-- function 9
	local new_item_ids = PlayerData.new_item_ids

	return not new_item_ids and new_item_ids[arg_9_0]
end

ItemHelper.has_new_backend_ids_by_career_name_and_slot_type = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local new_item_ids_by_career = PlayerData.new_item_ids_by_career

	for k, v in pairs(new_item_ids_by_career) do
		if arg_10_0 == k then
			for k_2, v_2 in pairs(v) do
				if arg_10_1 == k_2 then
					for k_3, v_3 in pairs(v_2) do
						if not v_3 then
							if not arg_10_2 then
								local get_item_from_masterlist = BackendUtils.get_item_from_masterlist(k_3)

								if not get_item_from_masterlist then
									if not arg_10_2[get_item_from_masterlist.rarity] then
										return true
									end
								else
									ItemHelper.unmark_backend_id_as_new(k_3)
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
	-- function 11
	local new_item_ids_by_career = PlayerData.new_item_ids_by_career

	for k, v in pairs(new_item_ids_by_career) do
		for k_2, v_2 in pairs(v) do
			if arg_11_0 == k_2 then
				for k_3, v_3 in pairs(v_2) do
					if not v_3 then
						if not arg_11_1 then
							local get_item_from_masterlist = BackendUtils.get_item_from_masterlist(k_3)

							if not get_item_from_masterlist then
								if not arg_11_1[get_item_from_masterlist.rarity] then
									return true
								end
							else
								ItemHelper.unmark_backend_id_as_new(k_3)
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
	-- function 12
	local new_item_ids_by_career = PlayerData.new_item_ids_by_career

	for k, v in pairs(new_item_ids_by_career) do
		if arg_12_0 == k then
			for k_2, v_2 in pairs(v) do
				for k_3, v_3 in pairs(v_2) do
					if not v_3 then
						if not arg_12_1 then
							local get_item_from_masterlist = BackendUtils.get_item_from_masterlist(k_3)

							if not get_item_from_masterlist then
								if not arg_12_1[get_item_from_masterlist.rarity] then
									return true
								end
							else
								ItemHelper.unmark_backend_id_as_new(k_3)
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
	-- function 13
	local tbl = {}
	local tbl_3 = {}
	local compare_statistics = BackendUtils.get_item_template(arg_13_0, arg_13_1).compare_statistics
	local flag = not compare_statistics and compare_statistics.attacks
	local flag_2

	flag_2 = not compare_statistics and compare_statistics.perks

	if not flag then
		local light_attack = flag.light_attack
		local heavy_attack = flag.heavy_attack

		ItemHelper._retrieve_weapon_attack_data(light_attack, tbl)
		ItemHelper._retrieve_weapon_attack_data(heavy_attack, tbl)
	end

	for k, v in pairs(tbl) do
		tbl_3[tbl_2[k]] = v
	end

	return tbl_3
end

ItemHelper._retrieve_weapon_attack_data = function (arg_14_0, arg_14_1)
	-- function 14
	for k, v in pairs(arg_14_0) do
		local var_14_0 = tbl_3[k]
		local var_14_1 = arg_14_1[k]

		var_14_1 = var_14_1 or {}
		var_14_1[#var_14_1 + 1] = {
			key = k,
			title = Localize(var_14_0),
			value = v
		}
		arg_14_1[k] = var_14_1
	end
end

ItemHelper.weapon_stat_order_by_type = function (arg_15_0)
	-- function 15
	return tbl_2[arg_15_0]
end

ItemHelper.on_inventory_item_added = function (self)
	-- function 16
	if self.data.slot_type == ItemType.LOOT_CHEST then
		local world = Managers.world

		if not world:has_world("level_world") then
			local world_2 = world:world("level_world")

			LevelHelper:flow_event(world_2, "local_player_received_loot_chest")
		end
	end
end

ItemHelper.mark_backend_id_as_favorite = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	arg_17_1 = arg_17_1 or Managers.backend:get_interface("items"):get_item_from_id(arg_17_0)

	local data = arg_17_1.data
	local slot_type = data.slot_type
	local can_wield = data.can_wield
	local var_17_3

	if not CosmeticUtils.is_cosmetic_item(slot_type) then
		var_17_3 = arg_17_1.ItemId
	else
		var_17_3 = arg_17_0
	end

	local favorite_item_ids = PlayerData.favorite_item_ids

	favorite_item_ids = favorite_item_ids or {}
	favorite_item_ids[var_17_3] = true

	local CareerSettings = CareerSettings
	local favorite_item_ids_by_career = PlayerData.favorite_item_ids_by_career

	favorite_item_ids_by_career = favorite_item_ids_by_career or {}

	for i, v in ipairs(can_wield) do
		local var_17_7 = favorite_item_ids_by_career[v]

		var_17_7 = var_17_7 or {}

		local var_17_8 = var_17_7[slot_type]

		var_17_8 = var_17_8 or {}
		var_17_8[var_17_3] = true
		var_17_7[slot_type] = var_17_8
		favorite_item_ids_by_career[v] = var_17_7
	end

	PlayerData.favorite_item_ids = favorite_item_ids
	PlayerData.favorite_item_ids_by_career = favorite_item_ids_by_career

	if not arg_17_2 then
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ItemHelper.unmark_backend_id_as_favorite = function (arg_18_0, arg_18_1)
	-- function 18
	if not arg_18_1 then
		local get_interface = Managers.backend:get_interface("items")

		if not get_interface then
			return
		end

		arg_18_1 = get_interface:get_item_from_id(arg_18_0)
	end

	local var_18_1

	if not arg_18_1 then
		local slot_type = arg_18_1.data.slot_type

		if not CosmeticUtils.is_cosmetic_item(slot_type) then
			var_18_1 = arg_18_1.ItemId
		else
			var_18_1 = arg_18_0
		end
	else
		var_18_1 = arg_18_0
	end

	local favorite_item_ids = PlayerData.favorite_item_ids
	local favorite_item_ids_by_career = PlayerData.favorite_item_ids_by_career

	assert(favorite_item_ids, "Requested to unmark item backend id %d without any save data.", var_18_1)

	favorite_item_ids[var_18_1] = nil

	for k, v in pairs(favorite_item_ids_by_career) do
		for k_2, v_2 in pairs(v) do
			for k_3, v_3 in pairs(v_2) do
				if k_3 == var_18_1 then
					v_2[var_18_1] = nil

					break
				end
			end
		end
	end
end

ItemHelper.get_favorite_backend_ids = function ()
	-- function 19
	return PlayerData.favorite_item_ids
end

ItemHelper.is_favorite_backend_id = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_1 = arg_20_1 or Managers.backend:get_interface("items"):get_item_from_id(arg_20_0)

	local slot_type = arg_20_1.data.slot_type
	local var_20_1

	if not CosmeticUtils.is_cosmetic_item(slot_type) then
		var_20_1 = arg_20_1.ItemId
	else
		var_20_1 = arg_20_0
	end

	local favorite_item_ids = PlayerData.favorite_item_ids

	return not favorite_item_ids and favorite_item_ids[var_20_1]
end

ItemHelper.is_equiped_backend_id = function (arg_21_0, arg_21_1)
	-- function 21
	local equipped_by = Managers.backend:get_interface("items"):equipped_by(arg_21_0)
	local count = #equipped_by

	return (not (count > 0) or not arg_21_1) and table.contains(equipped_by, arg_21_1), equipped_by, count
end

ItemHelper.get_equipped_slots = function (arg_22_0, arg_22_1)
	-- function 22
	local tbl = {}
	local num = 0
	local var_22_2 = Managers.backend:get_interface("items"):get_loadout()[arg_22_1]

	if not var_22_2 then
		for k, v in pairs(var_22_2) do
			if arg_22_0 == v then
				num = num + 1
				tbl[num] = k
			end
		end
	end

	return tbl, num
end

ItemHelper.mark_keep_decoration_as_new = function (arg_23_0)
	-- function 23
	local new_keep_decoration_ids = PlayerData.new_keep_decoration_ids

	new_keep_decoration_ids = new_keep_decoration_ids or {}
	new_keep_decoration_ids[arg_23_0] = true
	PlayerData.new_keep_decoration_ids = new_keep_decoration_ids

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.unmark_keep_decoration_as_new = function (arg_24_0)
	-- function 24
	PlayerData.new_keep_decoration_ids[arg_24_0] = nil

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

ItemHelper.get_new_keep_decoration_ids = function ()
	-- function 25
	return PlayerData.new_keep_decoration_ids
end

ItemHelper.is_new_keep_decoration_id = function (arg_26_0)
	-- function 26
	local new_keep_decoration_ids = PlayerData.new_keep_decoration_ids

	return not new_keep_decoration_ids and new_keep_decoration_ids[arg_26_0]
end

ItemHelper.tab_conversions = {
	dlc = "dlc",
	weapon_skin = "cosmetics",
	hat = "cosmetics",
	bundle = "bundles",
	featured = "featured",
	skin = "cosmetics"
}

local tab_conversions = ItemHelper.tab_conversions
local tbl_4 = {
	skin = true,
	weapon_skin = true,
	hat = true
}

ItemHelper.create_tab_unseen_item_stars = function (self)
	-- function 27
	local menu_options = StoreLayoutConfig.menu_options

	for i = 1, #menu_options do
		self[menu_options[i]] = 0
	end

	local get_peddler_stock = Managers.backend:get_interface("peddler"):get_peddler_stock()
	local seen_shop_items = PlayerData.seen_shop_items

	for k, v in pairs(get_peddler_stock) do
		local data = v.data

		if not seen_shop_items[v.key] then
			local item_type = data.item_type
			local var_27_5 = tab_conversions[item_type]

			if self[var_27_5] ~= nil then
				self[var_27_5] = self[var_27_5] + 1
			end
		end
	end

	for k_2, v_2 in pairs(StoreDlcSettingsByName) do
		if not (seen_shop_items[k_2] or self.dlc == nil) then
			self.dlc = self.dlc + 1
		end
	end
end

ItemHelper.update_featured_unseen = function (self, arg_28_1)
	-- function 28
	local seen_shop_items = PlayerData.seen_shop_items

	arg_28_1.featured = 0

	for i = 1, #self do
		if not (seen_shop_items[self[i].key] or arg_28_1.featured == nil) then
			arg_28_1.featured = arg_28_1.featured + 1
		end
	end
end

ItemHelper.set_shop_item_seen = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local seen_shop_items = PlayerData.seen_shop_items

	if not seen_shop_items[arg_29_0] then
		seen_shop_items[arg_29_0] = true

		local var_29_1 = tab_conversions[arg_29_1]

		if arg_29_2[var_29_1] ~= nil then
			arg_29_2[var_29_1] = arg_29_2[var_29_1] - 1
		end

		if not (not arg_29_3 and arg_29_2[arg_29_3] == nil) then
			arg_29_2[arg_29_3] = arg_29_2[arg_29_3] - 1
		end
	end
end

ItemHelper.set_all_shop_item_seen = function (self)
	-- function 30
	local get_peddler_stock = Managers.backend:get_interface("peddler"):get_peddler_stock()
	local seen_shop_items = PlayerData.seen_shop_items

	for k, v in pairs(get_peddler_stock) do
		seen_shop_items[v.data.key] = true
	end

	for k_2, v_2 in pairs(StoreDlcSettingsByName) do
		seen_shop_items[k_2] = true
	end

	for k_3, v_3 in pairs(self) do
		self[k_3] = 0
	end

	PlayerData.store_new_items = false

	if not Managers.state.event then
		Managers.state.event:trigger("set_all_shop_item_seen")
	end
end

ItemHelper.has_unseen_shop_items = function ()
	-- function 31
	local get_peddler_stock = Managers.backend:get_interface("peddler"):get_peddler_stock()
	local seen_shop_items = PlayerData.seen_shop_items

	for k, v in pairs(get_peddler_stock) do
		if not seen_shop_items[v.data.key] then
			return true
		end
	end

	for k_2, v_2 in pairs(StoreDlcSettingsByName) do
		if not seen_shop_items[k_2] then
			return true
		end
	end

	return false
end

local tbl_5 = {
	weapon_pose = true,
	weapon_skin = true,
	hat = true,
	chips = true,
	frame = true,
	skin = true
}

ItemHelper.is_fake_item = function (arg_32_0)
	-- function 32
	return tbl_5[arg_32_0]
end
