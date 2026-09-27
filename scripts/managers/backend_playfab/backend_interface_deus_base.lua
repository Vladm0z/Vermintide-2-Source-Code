-- chunkname: @scripts/managers/backend_playfab/backend_interface_deus_base.lua

require("scripts/settings/dlcs/morris/deus_meta_progression_settings")

BackendInterfaceDeusBase = class(BackendInterfaceDeusBase)

local tbl = {
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

	local tbl_2 = {}

	for k, v in pairs(tbl) do
		if v == "deus" then
			tbl_2[k] = true
		end
	end

	self._valid_loadout_slots = tbl_2

	Managers.backend:get_interface("items"):configure_game_mode_specific_items("deus", self._extra_deus_inventory)
	Managers.backend:get_interface("items"):configure_game_mode_specific_items("map_deus", self._extra_deus_inventory)
	Managers.backend:add_loadout_interface_override("deus", tbl)
	Managers.backend:add_loadout_interface_override("map_deus", tbl)
	Managers.backend:set_total_power_level_interface_for_game_mode("deus", "deus")
	Managers.backend:set_total_power_level_interface_for_game_mode("map_deus", "deus")
	Managers.backend:add_talents_interface_override("deus", "deus")
	Managers.backend:add_talents_interface_override("map_deus", "deus")
end

BackendInterfaceDeusBase.set_deus_loadout = function (self, arg_2_1)
	-- function 2
	self._loadouts = arg_2_1
end

BackendInterfaceDeusBase.set_deus_bot_loadout = function (self, arg_3_1)
	-- function 3
	self._bot_loadouts = arg_3_1
end

BackendInterfaceDeusBase.reset_deus_inventory = function (self)
	-- function 4
	self._loadouts = nil
	self._bot_loadouts = nil

	table.clear(self._extra_deus_inventory)
end

BackendInterfaceDeusBase.ready = function (arg_5_0)
	-- function 5
	return true
end

BackendInterfaceDeusBase.has_loadout_item_id = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = self._loadouts[arg_6_1]

	for k, v in pairs(var_6_0) do
		if v == arg_6_2 then
			return true
		end
	end
end

local uuid

if not IS_PS4 then
	uuid = math.uuid

	if not uuid then
		-- Nothing
	end
end

uuid = Application.guid

::label_0_0::

BackendInterfaceDeusBase.refresh_deus_weapons_in_items_backend = function (arg_7_0)
	-- function 7
	Managers.backend:get_interface("items"):refresh_game_mode_specific_items()
end

BackendInterfaceDeusBase.get_talent_tree = function (arg_8_0, arg_8_1)
	-- function 8
	return nil
end

BackendInterfaceDeusBase.get_talents = function (arg_9_0, arg_9_1)
	-- function 9
	return nil
end

BackendInterfaceDeusBase.get_talent_ids = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self._talent_ids[arg_10_1]
	local clone

	if not var_10_0 then
		clone = table.clone(var_10_0)

		if not clone then
			-- Nothing
		end
	end

	clone = {}

	::label_10_0::

	return clone
end

BackendInterfaceDeusBase.set_deus_talent_ids = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_0._talent_ids[arg_11_1] = arg_11_2
end

BackendInterfaceDeusBase.grant_deus_weapon = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_1.backend_id = arg_12_1.data.item_type .. uuid()
	arg_12_0._extra_deus_inventory[arg_12_1.backend_id] = arg_12_1

	return arg_12_1.backend_id
end

BackendInterfaceDeusBase.get_loadout_item_id = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	fassert(self._valid_loadout_slots[arg_13_2], "[BackendInterfaceDeusBase] Loadout in slot %q shouldn't be fetched from the deus interface", tostring(arg_13_2))

	local _bot_loadouts

	if not arg_13_3 then
		_bot_loadouts = self._bot_loadouts

		if not _bot_loadouts then
			-- Nothing
		end
	end

	_bot_loadouts = self._loadouts

	::label_13_0::

	return _bot_loadouts[arg_13_1][arg_13_2]
end

BackendInterfaceDeusBase.set_loadout_item = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	fassert(self._valid_loadout_slots[arg_14_3], "[BackendInterfaceDeusBase] Loadout in slot %q shouldn't be set in the deus interface", tostring(arg_14_3))

	if not arg_14_1 then
		fassert(self._extra_deus_inventory[arg_14_1], "[BackendInterfaceDeusBase] Item %q doesn't exist", tostring(arg_14_1))
	end

	local var_14_0 = self._loadouts[arg_14_2]

	if var_14_0[arg_14_3] ~= arg_14_1 then
		var_14_0[arg_14_3] = arg_14_1
	end
end

BackendInterfaceDeusBase.get_loadout_item = function (self, arg_15_1)
	-- function 15
	return self._extra_deus_inventory[arg_15_1]
end

BackendInterfaceDeusBase.get_total_power_level = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self._loadouts[arg_16_2]
	local flag = not var_16_0 and var_16_0.slot_melee
	local flag_2 = not var_16_0 and var_16_0.slot_ranged
	local num = 0
	local num_2 = 0

	if not flag then
		num = num + self._extra_deus_inventory[flag].power_level
		num_2 = num_2 + 1
	end

	if not flag_2 then
		num = num + self._extra_deus_inventory[flag_2].power_level
		num_2 = num_2 + 1
	end

	local num_3

	if num_2 > 0 then
		num_3 = num / num_2

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = 0

	::label_16_0::

	return num_3 + PowerLevelFromLevelSettings.starting_power_level
end

BackendInterfaceDeusBase.get_rolled_over_soft_currency = function (arg_17_0)
	-- function 17
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.deus_run_started = function (arg_18_0)
	-- function 18
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.get_journey_cycle = function (arg_19_0)
	-- function 19
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.refresh_belakor_cycle = function (arg_20_0)
	-- function 20
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.has_loaded_belakor_data = function (arg_21_0)
	-- function 21
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.set_has_loaded_belakor_data = function (arg_22_0, arg_22_1)
	-- function 22
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase._generate_journey_cycle = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local num = arg_23_3 % #DeusJourneyCycleGods
	local tbl = {}

	for k, v in pairs(AvailableJourneyOrder) do
		local num_2 = (num + (k - 1)) % #DeusJourneyCycleGods

		tbl[v] = {
			dominant_god = DeusJourneyCycleGods[num_2 + 1]
		}
	end

	return {
		remaining_time = arg_23_2,
		time_of_update = arg_23_1,
		journey_data = tbl
	}
end

BackendInterfaceDeusBase._generate_belakor_curse_cycle = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.debug_clear_meta_progression = function (self)
	-- function 25
	self:_debug_clear_meta_progression()
	Managers.backend:commit()
end

BackendInterfaceDeusBase.write_player_event = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	ferror("must be implemented by subclass")
end
