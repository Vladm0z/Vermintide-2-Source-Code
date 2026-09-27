-- chunkname: @scripts/settings/dlcs/morris/morris_pickups_settings.lua

local morris = DLCSettings.morris

local function fn(arg_1_0, arg_1_1)
	-- function 1
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return false
	end

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local var_1_1 = LevelSettings[get_current_level_keys]

	if not (not var_1_1 and var_1_1.hub_level) then
		return false
	end

	return true
end

morris.pickups = {
	deus_weapon_chest = {
		deus_weapon_chest = {
			type = "deus_weapon_chest",
			item_description = "deus_weapon_chest_item_desc",
			spawn_weighting = 1e-06,
			debug_pickup_category = "deus",
			item_name = "deus_weapon_chest",
			unit_name = "units/props/inn/deus/deus_chest_01",
			unit_template_name = "deus_weapon_chest",
			hud_description = "deus_weapon_chest_hud_desc",
			can_spawn_func = fn
		}
	},
	deus_soft_currency = {
		deus_soft_currency = {
			only_once = true,
			slot_name = "infinite_slot",
			item_description = "deus_soft_currency_item_desc",
			spawn_weighting = 1,
			debug_pickup_category = "deus",
			type = "deus_soft_currency",
			item_name = "deus_soft_currency",
			unit_name = "units/props/deus_pickups/deus_loot_pyramide_01",
			unit_template_name = "pickup_unit",
			hud_description = "deus_soft_currency_item_desc",
			disallow_bot_pickup = true,
			on_pick_up_func = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				local game_mode = Managers.state.game_mode:game_mode()

				if not game_mode.on_picked_up_soft_currency then
					game_mode:on_picked_up_soft_currency(arg_2_3, arg_2_1)
				end

				local local_player = Managers.player:local_player()

				Managers.state.event:trigger("player_pickup_deus_soft_currency", local_player)
			end,
			can_spawn_func = fn
		}
	},
	deus_cursed_chest = {
		deus_cursed_chest = {
			type = "deus_cursed_chest",
			item_description = "deus_cursed_chest_item_desc",
			spawn_weighting = 1e-06,
			debug_pickup_category = "deus",
			item_name = "deus_cursed_chest",
			unit_name = "units/props/inn/deus/deus_cursed_chest",
			unit_template_name = "deus_cursed_chest",
			hud_description = "deus_cursed_chest_hud_desc",
			can_spawn_func = fn
		}
	},
	level_events = {
		deus_relic_01 = {
			only_once = true,
			individual_pickup = false,
			type = "inventory_item",
			item_description = "deus_relic_01_hud_desc",
			spawn_weighting = 1e-06,
			debug_pickup_category = "level_event",
			slot_name = "slot_level_event",
			item_name = "wpn_deus_relic_01",
			unit_name = "units/weapons/player/pup_deus_relic_01/pup_deus_relic_01",
			unit_template_name = "deus_relic",
			wield_on_pickup = true,
			hud_description = "deus_relic_01_hud_desc",
			can_spawn_func = fn
		},
		deus_rally_flag = {
			only_once = true,
			individual_pickup = false,
			slot_name = "slot_healthkit",
			item_description = "deus_rally_flag_01_item_desc",
			spawn_weighting = 0.2,
			debug_pickup_category = "level_event",
			dupable = true,
			item_name = "deus_rally_flag",
			unit_name = "units/weapons/player/pup_deus_folded_rally_flag_01/pup_deus_folded_rally_flag_01",
			bots_mule_pickup = true,
			type = "inventory_item",
			consumable_item = false,
			local_pickup_sound = true,
			hud_description = "deus_rally_flag_01_hud_desc",
			pickup_sound_event = "pickup_medkit",
			can_spawn_func = fn
		},
		tiny_explosive_barrel = {
			only_once = true,
			individual_pickup = false,
			type = "explosive_inventory_item",
			item_description = "explosive_barrel",
			spawn_weighting = 1,
			debug_pickup_category = "level_event",
			slot_name = "slot_level_event",
			item_name = "explosive_barrel",
			unit_name = "units/weapons/player/pup_explosive_barrel/pup_tiny_explosive_barrel_01",
			additional_data_func = "explosive_barrel",
			unit_template_name = "explosive_pickup_projectile_unit",
			wield_on_pickup = true,
			hud_description = "explosive_barrel"
		}
	},
	deus_potions = {
		liquid_bravado_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "liquid_bravado_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_liquid_bravado_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_liquid_bravado_01_item_desc",
			dupable = true,
			item_name = "potion_liquid_bravado_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		vampiric_draught_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "vampiric_draught_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_vampiric_draught_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_vampiric_draught_01_item_desc",
			dupable = true,
			item_name = "potion_vampiric_draught_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		moot_milk_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "moot_milk_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_moot_milk_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_moot_milk_01_item_desc",
			dupable = true,
			item_name = "potion_moot_milk_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		friendly_murderer_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "friendly_murderer_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_friendly_murderer_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_friendly_murderer_01_item_desc",
			dupable = true,
			item_name = "potion_friendly_murderer_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		killer_in_the_shadows_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "killer_in_the_shadows_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_killer_in_the_shadows_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_killer_in_the_shadows_01_item_desc",
			dupable = true,
			item_name = "potion_killer_in_the_shadows_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		pockets_full_of_bombs_potion = {
			spawn_weighting = 0.1,
			only_once = true,
			material_settings_name = "pockets_full_of_bombs_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_pockets_full_of_bombs_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_pockets_full_of_bombs_01_item_desc",
			dupable = true,
			item_name = "potion_pockets_full_of_bombs_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		hold_my_beer_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "hold_my_beer_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_hold_my_beer_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_hold_my_beer_01_item_desc",
			dupable = true,
			item_name = "potion_hold_my_beer_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		},
		poison_proof_potion = {
			spawn_weighting = 0.2,
			only_once = true,
			material_settings_name = "poison_proof_potion",
			type = "inventory_item",
			pickup_sound_event = "pickup_potion",
			debug_pickup_category = "consumables",
			slot_name = "slot_potion",
			unit_name = "units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
			hud_description = "potion_poison_proof_01_hud_desc",
			bots_mule_pickup = true,
			individual_pickup = false,
			item_description = "potion_poison_proof_01_item_desc",
			dupable = true,
			item_name = "potion_poison_proof_01",
			consumable_item = true,
			local_pickup_sound = true,
			can_spawn_func = fn
		}
	},
	grenades = {
		holy_hand_grenade = {
			only_once = true,
			individual_pickup = false,
			slot_name = "slot_grenade",
			item_description = "holy_hand_grenade_desc",
			spawn_weighting = 0.8,
			debug_pickup_category = "grenades",
			dupable = true,
			pickup_sound_event = "pickup_grenade",
			item_name = "holy_hand_grenade",
			unit_name = "units/weapons/player/pup_grenades/pup_holy_hand_grenade_01_t1",
			bots_mule_pickup = true,
			type = "inventory_item",
			consumable_item = true,
			local_pickup_sound = true,
			hud_description = "holy_hand_grenade_desc"
		}
	}
}
morris.pickup_system_extension_update = {
	"DeusChestExtension"
}
morris.loot_rat_pickups = {
	deus = {
		first_aid_kit = 6,
		all_ammo_small = 6,
		deus_soft_currency = 6,
		fire_grenade_t2 = 2,
		frag_grenade_t2 = 2,
		healing_draught = 6
	}
}
morris.bardin_scavenger_custom_potions = {
	deus = {}
}

local num = 1
local deus = morris.loot_rat_pickups.deus
local deus_2 = morris.bardin_scavenger_custom_potions.deus

for k, v in pairs(morris.pickups.deus_potions) do
	deus[k] = num
	deus_2[#deus_2 + 1] = k
end
