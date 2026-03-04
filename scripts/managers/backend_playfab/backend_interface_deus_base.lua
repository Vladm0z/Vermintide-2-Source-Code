-- chunkname: @scripts/managers/backend_playfab/backend_interface_deus_base.lua

require("scripts/settings/dlcs/morris/deus_meta_progression_settings")

BackendInterfaceDeusBase = class(BackendInterfaceDeusBase)

local var_0_0 = {
	slot_pose = "items",
	slot_hat = "items",
	slot_skin = "items",
	slot_frame = "items",
	slot_melee = "deus",
	slot_ranged = "deus"
}

BackendInterfaceDeusBase.init = function (arg_1_0)
	arg_1_0._extra_deus_inventory = {}
	arg_1_0._loadouts = {}
	arg_1_0._talent_ids = {}
	arg_1_0._bot_loadouts = {}

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		if iter_1_1 == "deus" then
			var_1_0[iter_1_0] = true
		end
	end

	arg_1_0._valid_loadout_slots = var_1_0

	Managers.backend:get_interface("items"):configure_game_mode_specific_items("deus", arg_1_0._extra_deus_inventory)
	Managers.backend:get_interface("items"):configure_game_mode_specific_items("map_deus", arg_1_0._extra_deus_inventory)
	Managers.backend:add_loadout_interface_override("deus", var_0_0)
	Managers.backend:add_loadout_interface_override("map_deus", var_0_0)
	Managers.backend:set_total_power_level_interface_for_game_mode("deus", "deus")
	Managers.backend:set_total_power_level_interface_for_game_mode("map_deus", "deus")
	Managers.backend:add_talents_interface_override("deus", "deus")
	Managers.backend:add_talents_interface_override("map_deus", "deus")
end

BackendInterfaceDeusBase.set_deus_loadout = function (arg_2_0, arg_2_1)
	arg_2_0._loadouts = arg_2_1
end

BackendInterfaceDeusBase.set_deus_bot_loadout = function (arg_3_0, arg_3_1)
	arg_3_0._bot_loadouts = arg_3_1
end

BackendInterfaceDeusBase.reset_deus_inventory = function (arg_4_0)
	arg_4_0._loadouts = nil
	arg_4_0._bot_loadouts = nil

	table.clear(arg_4_0._extra_deus_inventory)
end

BackendInterfaceDeusBase.ready = function (arg_5_0)
	return true
end

BackendInterfaceDeusBase.has_loadout_item_id = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._loadouts[arg_6_1]

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1 == arg_6_2 then
			return true
		end
	end
end

local var_0_1 = IS_PS4 and math.uuid or Application.guid

BackendInterfaceDeusBase.refresh_deus_weapons_in_items_backend = function (arg_7_0)
	Managers.backend:get_interface("items"):refresh_game_mode_specific_items()
end

BackendInterfaceDeusBase.get_talent_tree = function (arg_8_0, arg_8_1)
	return nil
end

BackendInterfaceDeusBase.get_talents = function (arg_9_0, arg_9_1)
	return nil
end

BackendInterfaceDeusBase.get_talent_ids = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._talent_ids[arg_10_1]

	return var_10_0 and table.clone(var_10_0) or {}
end

BackendInterfaceDeusBase.set_deus_talent_ids = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._talent_ids[arg_11_1] = arg_11_2
end

BackendInterfaceDeusBase.grant_deus_weapon = function (arg_12_0, arg_12_1)
	arg_12_1.backend_id = arg_12_1.data.item_type .. var_0_1()
	arg_12_0._extra_deus_inventory[arg_12_1.backend_id] = arg_12_1

	return arg_12_1.backend_id
end

BackendInterfaceDeusBase.get_loadout_item_id = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	fassert(arg_13_0._valid_loadout_slots[arg_13_2], "[BackendInterfaceDeusBase] Loadout in slot %q shouldn't be fetched from the deus interface", tostring(arg_13_2))

	return (arg_13_3 and arg_13_0._bot_loadouts or arg_13_0._loadouts)[arg_13_1][arg_13_2]
end

BackendInterfaceDeusBase.set_loadout_item = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	fassert(arg_14_0._valid_loadout_slots[arg_14_3], "[BackendInterfaceDeusBase] Loadout in slot %q shouldn't be set in the deus interface", tostring(arg_14_3))

	if arg_14_1 then
		fassert(arg_14_0._extra_deus_inventory[arg_14_1], "[BackendInterfaceDeusBase] Item %q doesn't exist", tostring(arg_14_1))
	end

	local var_14_0 = arg_14_0._loadouts[arg_14_2]

	if var_14_0[arg_14_3] ~= arg_14_1 then
		var_14_0[arg_14_3] = arg_14_1
	end
end

BackendInterfaceDeusBase.get_loadout_item = function (arg_15_0, arg_15_1)
	return arg_15_0._extra_deus_inventory[arg_15_1]
end

BackendInterfaceDeusBase.get_total_power_level = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._loadouts[arg_16_2]
	local var_16_1 = var_16_0 and var_16_0.slot_melee
	local var_16_2 = var_16_0 and var_16_0.slot_ranged
	local var_16_3 = 0
	local var_16_4 = 0

	if var_16_1 then
		var_16_3 = var_16_3 + arg_16_0._extra_deus_inventory[var_16_1].power_level
		var_16_4 = var_16_4 + 1
	end

	if var_16_2 then
		var_16_3 = var_16_3 + arg_16_0._extra_deus_inventory[var_16_2].power_level
		var_16_4 = var_16_4 + 1
	end

	return (var_16_4 > 0 and var_16_3 / var_16_4 or 0) + PowerLevelFromLevelSettings.starting_power_level
end

BackendInterfaceDeusBase.get_rolled_over_soft_currency = function (arg_17_0)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.deus_run_started = function (arg_18_0)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.get_journey_cycle = function (arg_19_0)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.refresh_belakor_cycle = function (arg_20_0)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.has_loaded_belakor_data = function (arg_21_0)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.set_has_loaded_belakor_data = function (arg_22_0, arg_22_1)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase._generate_journey_cycle = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_3 % #DeusJourneyCycleGods
	local var_23_1 = {}

	for iter_23_0, iter_23_1 in pairs(AvailableJourneyOrder) do
		local var_23_2 = (var_23_0 + (iter_23_0 - 1)) % #DeusJourneyCycleGods

		var_23_1[iter_23_1] = {
			dominant_god = DeusJourneyCycleGods[var_23_2 + 1]
		}
	end

	return {
		remaining_time = arg_23_2,
		time_of_update = arg_23_1,
		journey_data = var_23_1
	}
end

BackendInterfaceDeusBase._generate_belakor_curse_cycle = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	ferror("must be implemented by subclass")
end

BackendInterfaceDeusBase.debug_clear_meta_progression = function (arg_25_0)
	arg_25_0:_debug_clear_meta_progression()
	Managers.backend:commit()
end

BackendInterfaceDeusBase.write_player_event = function (arg_26_0, arg_26_1, arg_26_2)
	ferror("must be implemented by subclass")
end
