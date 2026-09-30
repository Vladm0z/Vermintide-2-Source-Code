-- chunkname: @scripts/managers/backend_playfab/backend_interface_deus_base.lua

require("scripts/settings/dlcs/morris/deus_meta_progression_settings")

BackendInterfaceDeusBase = class(BackendInterfaceDeusBase)

local LOADOUT_INTERFACE_OVERRIDES = {
	slot_pose = "items",
	slot_hat = "items",
	slot_skin = "items",
	slot_frame = "items",
	slot_melee = "deus",
	slot_ranged = "deus"
}

BackendInterfaceDeusBase.init = function (self)
	-- function 1
	self._extra_deus_inventory = {}
	self._loadouts = {}
	self._talent_ids = {}
	self._bot_loadouts = {}

	local valid_loadout_slots = {}

	for slot_name, interface_name in pairs(LOADOUT_INTERFACE_OVERRIDES) do
		if interface_name == "deus" then
			valid_loadout_slots[slot_name] = true
		end
	end

	self._valid_loadout_slots = valid_loadout_slots

	Managers.backend:get_interface("items"):configure_game_mode_specific_items("deus", self._extra_deus_inventory)
	Managers.backend:get_interface("items"):configure_game_mode_specific_items("map_deus", self._extra_deus_inventory)
	Managers.backend:add_loadout_interface_override("deus", LOADOUT_INTERFACE_OVERRIDES)
	Managers.backend:add_loadout_interface_override("map_deus", LOADOUT_INTERFACE_OVERRIDES)
	Managers.backend:set_total_power_level_interface_for_game_mode("deus", "deus")
	Managers.backend:set_total_power_level_interface_for_game_mode("map_deus", "deus")
	Managers.backend:add_talents_interface_override("deus", "deus")
	Managers.backend:add_talents_interface_override("map_deus", "deus")
end

BackendInterfaceDeusBase.set_deus_loadout = function (self, loadout)
	-- function 2
	self._loadouts = loadout
end

BackendInterfaceDeusBase.set_deus_bot_loadout = function (self, bot_loadout)
	-- function 3
	self._bot_loadouts = bot_loadout
end

BackendInterfaceDeusBase.reset_deus_inventory = function (self)
	-- function 4
	self._loadouts = nil
	self._bot_loadouts = nil

	table.clear(self._extra_deus_inventory)
end

BackendInterfaceDeusBase.ready = function (self)
	-- function 5
	return true
end

BackendInterfaceDeusBase.has_loadout_item_id = function (self, career_name, item_id)
	-- function 6
	local loadout = self._loadouts[career_name]

	for slot_name, id in pairs(loadout) do
		if id == item_id then
			return true
		end
	end
end

local guid = IS_PS4 and math.uuid or not IS_PS4 and Application.guid

BackendInterfaceDeusBase.refresh_deus_weapons_in_items_backend = function (self)
	-- function 7
	Managers.backend:get_interface("items"):refresh_game_mode_specific_items()
end

BackendInterfaceDeusBase.get_talent_tree = function (self, career_name)
	-- function 8
	return nil
end

BackendInterfaceDeusBase.get_talents = function (self, career_name)
	-- function 9
	return nil
end

BackendInterfaceDeusBase.get_talent_ids = function (self, career_name)
	-- function 10
	local talent_ids = self._talent_ids[career_name]

	return talent_ids and table.clone(talent_ids) or not talent_ids and {}
end

BackendInterfaceDeusBase.set_deus_talent_ids = function (self, career_name, talent_ids)
	-- function 11
	self._talent_ids[career_name] = talent_ids
end

BackendInterfaceDeusBase.grant_deus_weapon = function (self, item)
	-- function 12
	item.backend_id = item.data.item_type .. guid()
	self._extra_deus_inventory[item.backend_id] = item

	return item.backend_id
end

BackendInterfaceDeusBase.get_loadout_item_id = function (self, career_name, slot_name, is_bot)
	-- function 13
	fassert(self._valid_loadout_slots[slot_name], "[BackendInterfaceDeusBase] Loadout in slot %q shouldn't be fetched from the deus interface", tostring(slot_name))

	local loadouts = is_bot and self._bot_loadouts or not is_bot and self._loadouts
	local loadout = loadouts[career_name]
	local item_backend_id = loadout[slot_name]

	return item_backend_id
end

BackendInterfaceDeusBase.set_loadout_item = function (self, item_backend_id, career_name, slot_name)
	-- function 14
	fassert(self._valid_loadout_slots[slot_name], "[BackendInterfaceDeusBase] Loadout in slot %q shouldn't be set in the deus interface", tostring(slot_name))

	if item_backend_id then
		fassert(self._extra_deus_inventory[item_backend_id], "[BackendInterfaceDeusBase] Item %q doesn't exist", tostring(item_backend_id))
	end

	local loadout = self._loadouts[career_name]

	if loadout[slot_name] ~= item_backend_id then
		loadout[slot_name] = item_backend_id
	end
end

BackendInterfaceDeusBase.get_loadout_item = function (self, item_backend_id)
	-- function 15
	return self._extra_deus_inventory[item_backend_id]
end

BackendInterfaceDeusBase.get_total_power_level = function (self, profile_name, career_name)
	-- function 16
	local loadouts = self._loadouts[career_name]
	local melee_weapon_id = loadouts and loadouts.slot_melee
	local ranged_weapon_id = loadouts and loadouts.slot_ranged
	local sum = 0
	local count = 0

	if melee_weapon_id then
		sum = sum + self._extra_deus_inventory[melee_weapon_id].power_level
		count = count + 1
	end

	if ranged_weapon_id then
		sum = sum + self._extra_deus_inventory[ranged_weapon_id].power_level
		count = count + 1
	end

	local item_average_power_level = count > 0 and sum / count or not (count > 0) and 0

	return item_average_power_level + PowerLevelFromLevelSettings.starting_power_level
end

BackendInterfaceDeusBase.get_rolled_over_soft_currency = function (self)
	-- function 17
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.deus_run_started = function (self)
	-- function 18
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.get_journey_cycle = function (self)
	-- function 19
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.refresh_belakor_cycle = function (self)
	-- function 20
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.has_loaded_belakor_data = function (self)
	-- function 21
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.set_has_loaded_belakor_data = function (self, value)
	-- function 22
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase._generate_journey_cycle = function (self, current_time, remaining_time, cycle)
	-- function 23
	local dominant_god_base_index = cycle % #DeusJourneyCycleGods
	local journey_data = {}

	for i, journey_name in pairs(AvailableJourneyOrder) do
		local dominant_god_index = (dominant_god_base_index + (i - 1)) % #DeusJourneyCycleGods

		journey_data[journey_name] = {
			dominant_god = DeusJourneyCycleGods[dominant_god_index + 1]
		}
	end

	return {
		remaining_time = remaining_time,
		time_of_update = current_time,
		journey_data = journey_data
	}
end

BackendInterfaceDeusBase._generate_belakor_curse_cycle = function (self, current_time, remaining_time, cycle)
	-- function 24
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.debug_clear_meta_progression = function (self)
	-- function 25
	self:_debug_clear_meta_progression()
	Managers.backend:commit()
end

BackendInterfaceDeusBase.write_player_event = function (self, event_name, data)
	-- function 26
	ferror("must be implemented by subclass")
end
