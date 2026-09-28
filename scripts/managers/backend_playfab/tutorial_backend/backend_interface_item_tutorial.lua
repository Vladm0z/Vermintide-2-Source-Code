-- chunkname: @scripts/managers/backend_playfab/tutorial_backend/backend_interface_item_tutorial.lua

BackendInterfaceItemTutorial = class(BackendInterfaceItemTutorial)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceItemTutorial.init = function (self, backend_mirror)
	-- function 1
	self._loadouts = {}
	self._items = {}
	self._backend_mirror = backend_mirror

	self:_refresh()
end

local loadout_slots = {
	"slot_ranged",
	"slot_melee",
	"slot_skin",
	"slot_hat",
	"slot_necklace",
	"slot_ring",
	"slot_trinket_1",
	"slot_frame"
}

BackendInterfaceItemTutorial._refresh = function (self)
	-- function 2
	self:_refresh_items()
	self:_refresh_loadouts()

	self._dirty = false
end

BackendInterfaceItemTutorial._refresh_items = function (self)
	-- function 3
	self._items = {
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

BackendInterfaceItemTutorial._refresh_loadouts = function (self)
	-- function 4
	self._loadouts = {
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

BackendInterfaceItemTutorial.ready = function (self)
	-- function 5
	if self._items then
		return true
	end

	return false
end

BackendInterfaceItemTutorial.type = function (self)
	-- function 6
	return "backend"
end

BackendInterfaceItemTutorial.update = function (self)
	-- function 7
	return
end

BackendInterfaceItemTutorial.refresh_entities = function (self)
	-- function 8
	return
end

BackendInterfaceItemTutorial.check_for_errors = function (self)
	-- function 9
	return
end

BackendInterfaceItemTutorial.num_current_item_server_requests = function (self)
	-- function 10
	return 0
end

BackendInterfaceItemTutorial.set_properties_serialized = function (self, backend_id, properties)
	-- function 11
	return
end

BackendInterfaceItemTutorial.get_traits = function (self, backend_id)
	-- function 12
	local item = self:get_item_from_id(backend_id)

	if item then
		local traits = item.traits

		return traits
	end

	return nil
end

BackendInterfaceItemTutorial.set_runes = function (self, backend_id, runes)
	-- function 13
	return
end

BackendInterfaceItemTutorial.get_runes = function (self, backend_id)
	-- function 14
	return
end

BackendInterfaceItemTutorial.socket_rune = function (self, backend_id, rune_to_insert, rune_index)
	-- function 15
	return
end

BackendInterfaceItemTutorial.get_skin = function (self)
	-- function 16
	return nil
end

BackendInterfaceItemTutorial.get_item_masterlist_data = function (self, backend_id)
	-- function 17
	local item = self:get_item_from_id(backend_id)

	if item then
		return item.data
	end
end

BackendInterfaceItemTutorial.get_item_amount = function (self, backend_id)
	-- function 18
	local item = self:get_item_from_id(backend_id)
	local RemainingUses = item.RemainingUses

	RemainingUses = not not RemainingUses or not not 1

	return RemainingUses
end

BackendInterfaceItemTutorial.get_item_power_level = function (self, backend_id)
	-- function 19
	local item = self:get_item_from_id(backend_id)
	local power_level = item.power_level

	return power_level
end

BackendInterfaceItemTutorial.get_item_rarity = function (self, backend_id)
	-- function 20
	local item = self:get_item_from_id(backend_id)
	local rarity = item.rarity

	return rarity
end

BackendInterfaceItemTutorial.get_key = function (self, backend_id)
	-- function 21
	local item = self:get_item_from_id(backend_id)

	return item.key
end

BackendInterfaceItemTutorial.get_item_from_id = function (self, backend_id)
	-- function 22
	local items = self:get_all_backend_items()
	local item = items[backend_id]

	return item
end

BackendInterfaceItemTutorial.get_item_from_key = function (self, item_key)
	-- function 23
	local items = self:get_all_backend_items()

	for _, item in pairs(items) do
		if item.key == item_key then
			return item
		end
	end
end

BackendInterfaceItemTutorial.get_all_backend_items = function (self)
	-- function 24
	if self._dirty then
		self:_refresh()
	end

	return self._items
end

BackendInterfaceItemTutorial.get_loadout = function (self)
	-- function 25
	if self._dirty then
		self:_refresh()
	end

	return self._loadouts
end

BackendInterfaceItemTutorial.get_loadout_by_career_name = function (self, career_name)
	-- function 26
	if self._dirty then
		self:_refresh()
	end

	return self._loadouts[career_name]
end

BackendInterfaceItemTutorial.get_loadout_item_id = function (self, career_name, slot_name)
	-- function 27
	local loadouts = self:get_loadout()

	return loadouts[career_name][slot_name]
end

local empty_params = {}

BackendInterfaceItemTutorial.get_filtered_items = function (self, filter, params)
	-- function 28
	local all_items = self:get_all_backend_items()
	local backend_common = Managers.backend:get_interface("common")
	local items = backend_common:filter_items(all_items, filter, not not params or not not empty_params)

	return items
end

BackendInterfaceItemTutorial.set_loadout_item = function (self, item_id, career_name, slot_name)
	-- function 29
	local all_items = self:get_all_backend_items()

	if item_id then
		fassert(all_items[item_id], "Trying to equip item that doesn't exist %d", not not item_id or not not "nil")
	end

	self._backend_mirror:set_character_data(career_name, slot_name, item_id)

	self._dirty = true
end

BackendInterfaceItemTutorial.remove_item = function (self, backend_id, ignore_equipped)
	-- function 30
	return
end

BackendInterfaceItemTutorial.award_item = function (self, item_key)
	-- function 31
	return
end

BackendInterfaceItemTutorial.data_server_script = function (self, script_name, ...)
	-- function 32
	return
end

BackendInterfaceItemTutorial.upgrades_failed_game = function (self, level_start, level_end)
	-- function 33
	return
end

BackendInterfaceItemTutorial.poll_upgrades_failed_game = function (self)
	-- function 34
	return
end

BackendInterfaceItemTutorial.generate_item_server_loot = function (self, dice, difficulty, start_level, end_level, hero_name, dlc_name)
	-- function 35
	return
end

BackendInterfaceItemTutorial.check_for_loot = function (self)
	-- function 36
	return
end

BackendInterfaceItemTutorial.equipped_by = function (self, backend_id)
	-- function 37
	local loadouts = self._loadouts
	local equipped_careers = {}

	for career_name, items_by_slot in pairs(loadouts) do
		for slot_name, item_id in pairs(items_by_slot) do
			if backend_id == item_id then
				table.insert(equipped_careers, career_name)
			end
		end
	end

	return equipped_careers
end

BackendInterfaceItemTutorial.is_equipped = function (self, backend_id, profile_name)
	-- function 38
	return
end

BackendInterfaceItemTutorial.set_data_server_queue = function (self, queue)
	-- function 39
	return
end

BackendInterfaceItemTutorial.make_dirty = function (self)
	-- function 40
	self._dirty = true
end

BackendInterfaceItemTutorial.has_item = function (self, item_key)
	-- function 41
	local items = self:get_all_backend_items()

	for backend_id, item in pairs(items) do
		if item_key == item.key then
			return true
		end
	end

	return false
end

BackendInterfaceItemTutorial.get_item_template = function (self, item_data, backend_id)
	-- function 42
	local temporary_template = item_data.temporary_template

	if not temporary_template then
		-- Nothing
	end

	temporary_template = item_data.template

	local template_name = temporary_template

	::label_42_0::

	local item_template = WeaponUtils.get_weapon_template(template_name)

	if item_template then
		return item_template
	end

	item_template = Attachments[template_name]

	if item_template then
		return item_template
	end

	item_template = Cosmetics[template_name]

	if item_template then
		return item_template
	end

	fassert(false, "no item_template for item: " .. item_data.key .. ", template name = " .. template_name)
end

BackendInterfaceItemTutorial.sum_best_power_levels = function (self)
	-- function 43
	return 10
end

BackendInterfaceItemTutorial.configure_game_mode_specific_items = function (self, game_mode, items)
	-- function 44
	return
end

BackendInterfaceItemTutorial.set_game_mode_specific_items = function (self, game_mode)
	-- function 45
	return
end

local WEAPON_POSE_DATA = {
	equipped_weapon_pose_skin = {}
}

BackendInterfaceItemTutorial.get_dirty_weapon_pose_data = function (self)
	-- function 46
	return WEAPON_POSE_DATA
end

local UNLOCKED_WEAPON_POSES = {}

BackendInterfaceItemTutorial.get_unlocked_weapon_poses = function (self)
	-- function 47
	return UNLOCKED_WEAPON_POSES
end

local EQUIPPED_WEAPON_POSES = {}

BackendInterfaceItemTutorial.get_equipped_weapon_pose_skins = function (self)
	-- function 48
	return EQUIPPED_WEAPON_POSES
end

BackendInterfaceItemTutorial.get_equipped_weapon_pose_skin = function (self, parent_item_name)
	-- function 49
	return nil
end
