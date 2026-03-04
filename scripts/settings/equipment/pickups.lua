-- chunkname: @scripts/settings/equipment/pickups.lua

require("scripts/entity_system/systems/buff/buff_sync_type")

Pickups = Pickups or {}
Pickups.healing = Pickups.healing or {}
Pickups.healing.first_aid_kit = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_healthkit",
	item_description = "healthkit_first_aid_kit_01",
	spawn_weighting = 0.5,
	debug_pickup_category = "consumables",
	dupable = true,
	pickup_sound_event = "pickup_medkit",
	item_name = "healthkit_first_aid_kit_01",
	unit_name = "units/weapons/player/pup_first_aid/pup_first_aid",
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "healthkit_first_aid_kit_01"
}
Pickups.healing.healing_draught = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_healthkit",
	item_description = "healthkit_first_aid_kit_01",
	spawn_weighting = 0.5,
	debug_pickup_category = "consumables",
	dupable = true,
	pickup_sound_event = "pickup_medkit",
	item_name = "potion_healing_draught_01",
	unit_name = "units/weapons/player/pup_potion_01/pup_potion_healing_01",
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "potion_healing_draught_01"
}
Pickups.potions = Pickups.potions or {}
Pickups.potions.damage_boost_potion = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_potion",
	item_description = "potion_damage_boost_01",
	spawn_weighting = 0.2,
	debug_pickup_category = "consumables",
	dupable = true,
	pickup_sound_event = "pickup_potion",
	item_name = "potion_damage_boost_01",
	unit_name = "units/weapons/player/pup_potion_01/pup_potion_strenght_01",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "potion_damage_boost_01"
}
Pickups.potions.speed_boost_potion = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_potion",
	item_description = "potion_speed_boost_01",
	spawn_weighting = 0.2,
	debug_pickup_category = "consumables",
	dupable = true,
	pickup_sound_event = "pickup_potion",
	item_name = "potion_speed_boost_01",
	unit_name = "units/weapons/player/pup_potion_01/pup_potion_speed_01",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "potion_speed_boost_01"
}
Pickups.potions.cooldown_reduction_potion = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_potion",
	item_description = "potion_cooldown_reduction_01",
	spawn_weighting = 0.2,
	debug_pickup_category = "consumables",
	dupable = true,
	pickup_sound_event = "pickup_potion",
	item_name = "potion_cooldown_reduction_01",
	unit_name = "units/weapons/player/pup_potion_01/pup_potion_extra_01",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "potion_cooldown_reduction_01"
}
Pickups.level_events = Pickups.level_events or {}
Pickups.level_events.grain_sack = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "grain_sack",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "grain_sack",
	unit_name = "units/weapons/player/pup_sacks/pup_sacks_01",
	unit_template_name = "pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "grain_sack"
}
Pickups.level_events.door_stick = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "door_stick",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "door_stick",
	unit_name = "units/gameplay/timed_door_base_02/pup_timed_door_stick",
	unit_template_name = "pickup_unit",
	wield_on_pickup = true,
	hud_description = "door_stick"
}
Pickups.level_events.training_dummy_bob = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "dummy_description",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "training_dummy_bob",
	unit_name = "units/gameplay/training_dummy/training_dummy_bob",
	unit_template_name = "ai_unit_training_dummy_bob",
	wield_on_pickup = true,
	hud_description = "dummy_description",
	spawn_override_func = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = Breeds.training_dummy
		local var_1_1 = {
			side_id = 2,
			prepare_func = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				arg_2_1.projectile_locomotion_system = arg_1_1.projectile_locomotion_system
				arg_2_1.pickup_system = arg_1_1.pickup_system
			end,
			spawned_func = function(arg_3_0, arg_3_1, arg_3_2)
				Managers.state.entity:system("ai_system"):set_attribute(arg_3_0, "armor", "training_dummy", false)
			end
		}
		local var_1_2, var_1_3 = Managers.state.conflict:spawn_unit_immediate(var_1_0, arg_1_2, arg_1_3, "pickup", nil, nil, var_1_1)

		return var_1_2, var_1_3
	end
}
Pickups.level_events.training_dummy_armored_bob = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "dummy_description",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "training_dummy_armored_bob",
	unit_name = "units/gameplay/training_dummy/training_dummy_bob",
	unit_template_name = "ai_unit_training_dummy_bob",
	wield_on_pickup = true,
	hud_description = "dummy_description",
	spawn_override_func = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = Breeds.training_dummy
		local var_4_1 = {
			side_id = 2,
			prepare_func = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				arg_5_1.projectile_locomotion_system = arg_4_1.projectile_locomotion_system
				arg_5_1.pickup_system = arg_4_1.pickup_system
			end,
			spawned_func = function(arg_6_0, arg_6_1, arg_6_2)
				Managers.state.entity:system("ai_system"):set_attribute(arg_6_0, "armor", "training_dummy", true)
			end
		}
		local var_4_2, var_4_3 = Managers.state.conflict:spawn_unit_immediate(var_4_0, arg_4_2, arg_4_3, "pickup", nil, nil, var_4_1)

		return var_4_2, var_4_3
	end
}
Pickups.level_events.torch = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "interaction_torch",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	teleport_time = 3.5,
	slot_name = "slot_level_event",
	item_name = "torch",
	unit_name = "units/weapons/player/pup_torch/pup_torch",
	unit_template_name = "pickup_torch_unit_init",
	wield_on_pickup = true,
	hud_description = "interaction_torch",
	on_pick_up_func = function(arg_7_0, arg_7_1, arg_7_2)
		if arg_7_2 then
			LevelHelper:flow_event(arg_7_0, "lua_torch_picked_up")
		end
	end
}
Pickups.level_events.mutator_torch = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "interaction_torch",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	teleport_time = 3.5,
	slot_name = "slot_level_event",
	item_name = "mutator_torch",
	unit_name = "units/weapons/player/pup_torch/pup_torch",
	unit_template_name = "pickup_torch_unit",
	wield_on_pickup = true,
	hud_description = "interaction_torch",
	on_pick_up_func = function(arg_8_0, arg_8_1, arg_8_2)
		if arg_8_2 then
			LevelHelper:flow_event(arg_8_0, "lua_torch_picked_up")
		end
	end
}
Pickups.level_events.shadow_torch = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "interaction_torch",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	teleport_time = 1000,
	slot_name = "slot_level_event",
	item_name = "shadow_torch",
	unit_name = "units/weapons/player/pup_shadow_torch/pup_shadow_torch",
	unit_template_name = "pickup_torch_unit_init",
	wield_on_pickup = true,
	hud_description = "interaction_torch",
	on_pick_up_func = function(arg_9_0, arg_9_1, arg_9_2)
		if arg_9_2 then
			LevelHelper:flow_event(arg_9_0, "lua_torch_picked_up")
		end
	end
}
Pickups.level_events.explosive_barrel = {
	only_once = true,
	individual_pickup = false,
	type = "explosive_inventory_item",
	item_description = "explosive_barrel",
	spawn_weighting = 1,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "explosive_barrel",
	unit_name = "units/weapons/player/pup_explosive_barrel/pup_explosive_barrel_01",
	additional_data_func = "explosive_barrel",
	unit_template_name = "explosive_pickup_projectile_unit",
	wield_on_pickup = true,
	hud_description = "explosive_barrel"
}
Pickups.level_events.whale_oil_barrel = {
	only_once = true,
	individual_pickup = false,
	type = "explosive_inventory_item",
	item_description = "explosive_barrel",
	spawn_weighting = 1,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "whale_oil_barrel",
	unit_name = "units/weapons/player/pup_whale_oil_barrel/pup_whale_oil_barrel_01",
	additional_data_func = "explosive_barrel",
	unit_template_name = "explosive_pickup_projectile_unit",
	wield_on_pickup = true,
	hud_description = "explosive_barrel"
}
Pickups.level_events.lamp_oil = {
	only_once = true,
	individual_pickup = false,
	type = "explosive_inventory_item",
	item_description = "lamp_oil",
	spawn_weighting = 1,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "lamp_oil",
	unit_name = "units/weapons/player/pup_oil_jug_01/pup_oil_jug_01",
	additional_data_func = "explosive_barrel",
	unit_template_name = "explosive_pickup_projectile_unit",
	wield_on_pickup = true,
	hud_description = "lamp_oil"
}
Pickups.level_events.explosive_barrel_objective = {
	only_once = true,
	individual_pickup = false,
	type = "explosive_inventory_item",
	item_description = "explosive_barrel_objective",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "explosive_barrel_objective",
	unit_name = "units/weapons/player/pup_explosive_barrel/pup_gun_powder_barrel_01",
	additional_data_func = "explosive_barrel",
	unit_template_name = "explosive_pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "explosive_barrel_objective"
}
Pickups.level_events.beer_barrel = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "beer_barrel",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "beer_barrel",
	unit_name = "units/weapons/player/pup_explosive_barrel/pup_explosive_barrel_01",
	unit_template_name = "pickup_unit",
	wield_on_pickup = true,
	hud_description = "beer_barrel"
}
Pickups.level_events.magic_barrel = {
	only_once = true,
	individual_pickup = false,
	type = "explosive_inventory_item",
	item_description = "magic_barrel",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "magic_barrel",
	unit_name = "units/weapons/player/pup_magic_barrel/pup_magic_barrel_01",
	additional_data_func = "explosive_barrel",
	unit_template_name = "explosive_pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "magic_barrel"
}
Pickups.level_events.wizards_barrel = {
	only_once = true,
	individual_pickup = false,
	type = "explosive_inventory_item",
	item_description = "wizards_barrel",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wizards_barrel",
	unit_name = "units/weapons/player/pup_wizards_barrel_01/pup_wizards_barrel_01",
	additional_data_func = "wizards_barrel",
	unit_template_name = "explosive_pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "wizards_barrel",
	on_pick_up_func = function(arg_10_0, arg_10_1, arg_10_2)
		Managers.state.event:trigger("set_tower_skulls_target", arg_10_1)

		if arg_10_2 then
			AIGroupTemplates.ethereal_skulls.try_spawn_group("picked_up", arg_10_1)
		end
	end
}
Pickups.level_events.grimoire = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_potion",
	item_description = "grimoire",
	spawn_weighting = 1,
	debug_pickup_category = "special",
	pickup_sound_event = "pickup_medkit",
	type = "inventory_item",
	item_name = "wpn_grimoire_01",
	unit_name = "units/weapons/player/pup_grimoire_01/pup_grimoire_01",
	local_pickup_sound = true,
	hud_description = "grimoire"
}
Pickups.level_events.tome = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_healthkit",
	item_description = "tome",
	spawn_weighting = 1,
	debug_pickup_category = "special",
	pickup_sound_event = "pickup_medkit",
	type = "inventory_item",
	item_name = "wpn_side_objective_tome_01",
	unit_name = "units/weapons/player/pup_side_objective_tome/pup_side_objective_tome_01",
	local_pickup_sound = true,
	hud_description = "tome"
}
Pickups.level_events.cannon_ball = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "cannon_ball",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_cannon_ball_01",
	unit_name = "units/weapons/player/pup_cannon_ball_01/pup_cannon_ball_01",
	unit_template_name = "pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "cannon_ball"
}
Pickups.level_events.trail_cog = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "cog_wheel",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_trail_cog",
	unit_name = "units/weapons/player/wpn_trail_cog_02/pup_trail_cog_02",
	unit_template_name = "pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "cog_wheel"
}
Pickups.level_events.gargoyle_head = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "gargoyle_head",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_gargoyle_head",
	unit_name = "units/weapons/player/pup_gargoyle_head/pup_gargoyle_head_01",
	unit_template_name = "pickup_projectile_unit",
	wield_on_pickup = true,
	hud_description = "gargoyle_head"
}
Pickups.level_events.gargoyle_head_vs = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "gargoyle_head",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_gargoyle_head",
	unit_name = "units/weapons/player/pup_gargoyle_head/pup_gargoyle_head_01",
	unit_template_name = "pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "gargoyle_head"
}
Pickups.level_events.waystone_piece = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "interaction_waystone_piece",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_waystone_piece",
	unit_name = "units/weapons/player/pup_waystone_piece_01/pup_waystone_piece_01",
	unit_template_name = "pickup_projectile_unit",
	wield_on_pickup = true,
	hud_description = "interaction_waystone_piece"
}
Pickups.level_events.magic_crystal = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "magic_crystal",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_magic_crystal",
	unit_name = "units/weapons/player/pup_magic_crystal/pup_magic_crystal",
	unit_template_name = "pickup_projectile_unit_limited",
	wield_on_pickup = true,
	hud_description = "magic_crystal"
}
Pickups.level_events.shadow_gargoyle_head = {
	only_once = true,
	individual_pickup = false,
	type = "inventory_item",
	item_description = "gargoyle_head",
	spawn_weighting = 1e-06,
	debug_pickup_category = "level_event",
	slot_name = "slot_level_event",
	item_name = "wpn_shadow_gargoyle_head",
	unit_name = "units/weapons/player/pup_shadow_gargoyle_head/pup_shadow_gargoyle_head_01",
	unit_template_name = "pickup_projectile_unit",
	wield_on_pickup = true,
	hud_description = "gargoyle_head"
}
Pickups.ammo = Pickups.ammo or {}
Pickups.ammo.all_ammo = {
	only_once = false,
	individual_pickup = false,
	type = "ammo",
	spawn_weighting = 1,
	debug_pickup_category = "consumables",
	unit_name = "units/weapons/player/pup_ammo_box/pup_ammo_box",
	unit_template_name = "pickup_unit",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "interaction_ammunition_crate",
	pickup_sound_event_func = function(arg_11_0, arg_11_1, arg_11_2)
		return ScriptUnit.extension(arg_11_0, "inventory_system"):has_full_ammo() and "pickup_ammo_full" or "pickup_ammo"
	end,
	can_interact_func = function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = ScriptUnit.has_extension(arg_12_0, "inventory_system")

		if not var_12_0 then
			return false
		end

		local var_12_1 = var_12_0:has_ammo_consuming_weapon_equipped()
		local var_12_2 = var_12_0:has_ammo_consuming_weapon_equipped("throwing_axe")
		local var_12_3 = var_12_0:has_infinite_ammo()

		if not var_12_2 then
			return var_12_1 and not var_12_3
		end

		return true
	end
}
Pickups.ammo.all_ammo_small = {
	only_once = true,
	individual_pickup = false,
	spawn_weighting = 2,
	type = "ammo",
	pickup_sound_event = "pickup_ammo",
	debug_pickup_category = "consumables",
	unit_name = "units/weapons/player/pup_ammo_box/pup_ammo_box_limited",
	unit_template_name = "pickup_unit",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "interaction_ammunition",
	can_interact_func = function(arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = ScriptUnit.has_extension(arg_13_0, "inventory_system")

		if not var_13_0 then
			return false
		end

		local var_13_1 = var_13_0:has_ammo_consuming_weapon_equipped()
		local var_13_2 = var_13_0:has_ammo_consuming_weapon_equipped("throwing_axe")
		local var_13_3 = var_13_0:has_infinite_ammo()

		return var_13_1 and not var_13_2 and not var_13_3
	end
}
Pickups.ammo.ammo_ranger = {
	only_once = true,
	ranger_ammo = true,
	individual_pickup = false,
	type = "ammo",
	spawn_weighting = 1e-06,
	refill_percentage = 0.1,
	pickup_sound_event = "pickup_ammo",
	debug_pickup_category = "consumables",
	unit_name = "units/weapons/player/pup_ammo_box/pup_ammo_box_limited",
	unit_template_name = "pickup_unit",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "interaction_ranger_ammunition",
	can_interact_func = function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = ScriptUnit.has_extension(arg_14_0, "inventory_system")

		if not var_14_0 then
			return false
		end

		local var_14_1 = var_14_0:has_ammo_consuming_weapon_equipped()
		local var_14_2 = var_14_0:has_ammo_consuming_weapon_equipped("throwing_axe")
		local var_14_3 = var_14_0:has_infinite_ammo()

		return var_14_1 and not var_14_2 and not var_14_3
	end
}
Pickups.ammo.ammo_ranger_improved = {
	only_once = true,
	ranger_ammo = true,
	individual_pickup = false,
	type = "ammo",
	spawn_weighting = 1e-06,
	refill_percentage = 0.3,
	pickup_sound_event = "pickup_ammo",
	debug_pickup_category = "consumables",
	unit_name = "units/weapons/player/pup_ammo_box/pup_ammo_box_limited",
	unit_template_name = "pickup_unit",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "interaction_ranger_ammunition_improved",
	can_interact_func = function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = ScriptUnit.has_extension(arg_15_0, "inventory_system")

		if not var_15_0 then
			return false
		end

		local var_15_1 = var_15_0:has_ammo_consuming_weapon_equipped()
		local var_15_2 = var_15_0:has_ammo_consuming_weapon_equipped("throwing_axe")
		local var_15_3 = var_15_0:has_infinite_ammo()

		return var_15_1 and not var_15_2 and not var_15_3
	end
}
Pickups.grenades = Pickups.grenades or {}
Pickups.grenades.frag_grenade_t1 = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_grenade",
	item_description = "grenade_frag",
	spawn_weighting = 0.8,
	debug_pickup_category = "grenades",
	dupable = true,
	pickup_sound_event = "pickup_grenade",
	item_name = "grenade_frag_01",
	unit_name = "units/weapons/player/pup_grenades/pup_grenade_01_t1",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "grenade_frag"
}
Pickups.grenades.fire_grenade_t1 = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_grenade",
	type = "inventory_item",
	spawn_weighting = 0.8,
	debug_pickup_category = "grenades",
	dupable = true,
	pickup_sound_event = "pickup_grenade",
	item_name = "grenade_fire_01",
	unit_name = "units/weapons/player/pup_grenades/pup_grenade_03_t1",
	bots_mule_pickup = true,
	item_description = "grenade_fire",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "grenade_fire"
}
Pickups.improved_grenades = Pickups.improved_grenades or {}
Pickups.improved_grenades.frag_grenade_t2 = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_grenade",
	item_description = "grenade_frag",
	spawn_weighting = 0.2,
	debug_pickup_category = "grenades",
	dupable = true,
	pickup_sound_event = "pickup_grenade",
	item_name = "grenade_frag_02",
	unit_name = "units/weapons/player/pup_grenades/pup_grenade_01_t2",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "grenade_frag"
}
Pickups.improved_grenades.fire_grenade_t2 = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_grenade",
	item_description = "grenade_fire",
	spawn_weighting = 0.2,
	debug_pickup_category = "grenades",
	dupable = true,
	pickup_sound_event = "pickup_grenade",
	item_name = "grenade_fire_02",
	unit_name = "units/weapons/player/pup_grenades/pup_grenade_03_t2",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "grenade_fire"
}
Pickups.grenades.engineer_grenade_t1 = {
	only_once = true,
	individual_pickup = false,
	slot_name = "slot_grenade",
	item_description = "grenade_frag",
	spawn_weighting = 0.8,
	debug_pickup_category = "grenades",
	dupable = true,
	pickup_sound_event = "pickup_grenade",
	item_name = "grenade_engineer",
	unit_name = "units/weapons/player/pup_grenades/pup_grenade_01_t1",
	bots_mule_pickup = true,
	type = "inventory_item",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "grenade_frag"
}
Pickups.special = {}
Pickups.special.loot_die = {
	only_once = true,
	individual_pickup = false,
	mission_name = "bonus_dice_hidden_mission",
	type = "loot_die",
	pickup_sound_event = "hud_pickup_loot_die",
	debug_pickup_category = "special",
	spawn_weighting = 1,
	unit_name = "units/props/dice_bowl/pup_loot_die",
	local_pickup_sound = false,
	hud_description = "interaction_loot_dice",
	can_spawn_func = function(arg_16_0, arg_16_1)
		if arg_16_1 then
			return true
		end

		if not arg_16_0 then
			return true
		end

		return arg_16_0.dice_keeper:num_bonus_dice_spawned() < 2
	end
}
Pickups.special.bardin_survival_ale = {
	consumable_item = true,
	type = "inventory_item",
	pickup_sound_event = "pickup_potion",
	debug_pickup_category = "consumables",
	bots_mule_pickup = true,
	spawn_weighting = 1e-06,
	slot_name = "slot_level_event",
	unit_name = "units/weapons/player/pup_ale/pup_ale",
	hud_description = "interaction_beer",
	only_once = true,
	item_description = "interaction_beer",
	item_name = "wpn_bardin_survival_ale",
	wield_on_pickup = true,
	local_pickup_sound = true,
	action_on_wield = {
		action = "action_one",
		sub_action = "default"
	},
	on_pick_up_func = function(arg_17_0, arg_17_1, arg_17_2)
		ScriptUnit.extension(arg_17_1, "buff_system"):add_buff("intoxication_base")
	end,
	can_interact_func = function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = ScriptUnit.extension(arg_18_0, "buff_system")
		local var_18_1 = var_18_0:has_buff_type("beer_bottle_pickup_cooldown")
		local var_18_2 = var_18_0:has_buff_perk("falling_down")

		return not var_18_1 and not var_18_2
	end
}
Pickups.special.necromancer_ripped_soul = {
	unit_template_name = "orb_pickup_unit",
	type = "orb_pickup_unit",
	pickup_sound = "Play_career_necro_ability_soul_rip_orb_pickup",
	debug_pickup_category = "orbs",
	local_only = true,
	item_name = "health_orb",
	unit_name = "units/beings/player/bright_wizard_necromancer/talents/ripped_soul",
	pickup_radius = 0.3,
	granted_buff = "sienna_necromancer_4_2_soul_rip_stack",
	spawn_weighting = 1e-06,
	buff_sync_type = BuffSyncType.Local,
	can_pickup_orb = function(arg_19_0, arg_19_1)
		local var_19_0 = ScriptUnit.has_extension(arg_19_1, "career_system")

		if var_19_0 and var_19_0:career_name() == "bw_necromancer" then
			return true
		end
	end,
	orb_offset = {
		0,
		0,
		0.32
	},
	hover_settings = {
		amplitude = 0.3,
		frequency = 0.4
	},
	magnetic_settings = {
		time_to_max_speed = 0.5,
		radius = 3.5,
		max_speed = 6.5
	}
}

if script_data then
	script_data.lorebook_enabled = script_data.lorebook_enabled or Development.parameter("lorebook_enabled")
end

Pickups.lorebook_pages = {}
Pickups.lorebook_pages.lorebook_page = {
	only_once = false,
	spawn_weighting = 1,
	hide_on_pickup = true,
	type = "lorebook_page",
	pickup_sound_event = "Play_hud_lorebook_unlock_page",
	debug_pickup_category = "special",
	unit_name = "units/weapons/player/pup_lore_page/pup_lore_page_01",
	hud_description = "interaction_lorebook_page",
	hide_func = function(arg_20_0)
		local var_20_0 = Managers.state.game_mode:level_key()
		local var_20_1 = LorebookCollectablePages[var_20_0]

		fassert(var_20_1, "Trying to a pick up a lorebook page on a level where pages can not be unlocked")

		local var_20_2 = #var_20_1
		local var_20_3 = Managers.player:local_player():stats_id()
		local var_20_4 = true

		for iter_20_0 = 1, var_20_2 do
			local var_20_5 = var_20_1[iter_20_0]
			local var_20_6 = LorebookCategoryLookup[var_20_5]

			if not arg_20_0:get_persistent_array_stat(var_20_3, "lorebook_unlocks", var_20_6) then
				var_20_4 = false

				break
			end
		end

		return var_20_4
	end,
	can_spawn_func = function(arg_21_0, arg_21_1)
		if arg_21_1 then
			return true
		end

		if not script_data.lorebook_enabled then
			return false
		end

		local var_21_0 = Managers.state.game_mode:level_key()

		if LorebookCollectablePages[var_21_0] then
			return true
		end

		return false
	end
}
Pickups.painting_scrap = {}
Pickups.painting_scrap.painting_scrap = {
	only_once = true,
	individual_pickup = true,
	hide_on_pickup = true,
	type = "painting_scrap",
	pickup_sound_event = "hud_pickup_painting_piece",
	debug_pickup_category = "special",
	spawn_weighting = 1,
	unit_name = "units/weapons/player/pup_painting/pup_painting_scraps",
	local_pickup_sound = true,
	hud_description = "ravaged_art",
	can_spawn_func = function(arg_22_0, arg_22_1)
		return true
	end
}

DLCUtils.merge("pickups", Pickups, true)

LootRatPickups = {
	default = {
		lorebook_page = 4,
		speed_boost_potion = 1,
		fire_grenade_t2 = 1,
		boss_loot = 4,
		frag_grenade_t2 = 1,
		healing_draught = 2,
		first_aid_kit = 3,
		damage_boost_potion = 1,
		cooldown_reduction_potion = 1
	},
	versus = {
		first_aid_kit = 3,
		damage_boost_potion = 1,
		frag_grenade_t2 = 1,
		fire_grenade_t2 = 1,
		speed_boost_potion = 1,
		cooldown_reduction_potion = 1,
		healing_draught = 2
	}
}
BardinScavengerCustomPotions = {}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_0 = iter_0_1.loot_rat_pickups

	if var_0_0 then
		table.merge(LootRatPickups, var_0_0)
	end

	local var_0_1 = iter_0_1.bardin_scavenger_custom_potions

	if var_0_1 then
		table.merge(BardinScavengerCustomPotions, var_0_1)
	end
end

for iter_0_2, iter_0_3 in pairs(LootRatPickups) do
	local var_0_2 = 0

	for iter_0_4, iter_0_5 in pairs(iter_0_3) do
		var_0_2 = var_0_2 + iter_0_5
	end

	for iter_0_6, iter_0_7 in pairs(iter_0_3) do
		iter_0_3[iter_0_6] = iter_0_7 / var_0_2
	end
end

NearPickupSpawnChance = NearPickupSpawnChance or {
	grenades = 0.5,
	healing = 0.7,
	potions = 0.3
}
AllPickups = {}

for iter_0_8, iter_0_9 in pairs(Pickups) do
	local var_0_3 = 0

	for iter_0_10, iter_0_11 in pairs(iter_0_9) do
		var_0_3 = var_0_3 + iter_0_11.spawn_weighting
	end

	for iter_0_12, iter_0_13 in pairs(iter_0_9) do
		iter_0_13.spawn_weighting = iter_0_13.spawn_weighting / var_0_3
		iter_0_13.pickup_name = iter_0_12
		AllPickups[iter_0_12] = iter_0_13
	end

	NearPickupSpawnChance[iter_0_8] = NearPickupSpawnChance[iter_0_8] or 0
end
