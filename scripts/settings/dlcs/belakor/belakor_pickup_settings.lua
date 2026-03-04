-- chunkname: @scripts/settings/dlcs/belakor/belakor_pickup_settings.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

local var_0_0 = DLCSettings.belakor

local function var_0_1(arg_1_0, arg_1_1)
	if Managers.mechanism:current_mechanism_name() == "deus" then
		local var_1_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

		if not var_1_0 then
			return false
		end

		local var_1_1 = Managers.state.game_mode

		if var_1_1 and var_1_1:has_mutator("curse_shadow_homing_skulls") then
			return true
		end

		local var_1_2 = var_1_0:get_current_node()

		return var_1_2.theme == "belakor" or var_1_2.base_level == "arena_belakor"
	else
		return false
	end
end

local function var_0_2(arg_2_0, arg_2_1)
	if Managers.mechanism:current_mechanism_name() == "deus" then
		local var_2_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

		if not var_2_0 then
			return false
		end

		return var_2_0:can_spawn_belakor_locus()
	else
		return false
	end
end

local function var_0_3(arg_3_0, arg_3_1)
	local var_3_0 = ScriptUnit.extension(arg_3_1, "buff_system")
	local var_3_1 = arg_3_0.buff_name_for_check or arg_3_0.granted_buff
	local var_3_2 = var_3_0:has_buff_type(var_3_1)
	local var_3_3 = var_3_0:has_buff_type(var_3_1 .. "_increased")

	return not (var_3_2 or var_3_3)
end

local function var_0_4(arg_4_0, arg_4_1)
	return ScriptUnit.extension(arg_4_1, "career_system"):current_ability_cooldown_percentage() > 0
end

var_0_0.pickups = {
	orb = {
		test_orb_01 = {
			item_name = "test_orb_01",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "orb_test_buff_01"
		},
		health_orb = {
			item_name = "health_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "health_orb",
			can_pickup_orb = function (arg_5_0, arg_5_1)
				local var_5_0 = ScriptUnit.extension(arg_5_1, "health_system")

				if var_5_0:get_max_health() > var_5_0:current_health() then
					return true
				end
			end
		},
		static_charge = {
			item_name = "static_charge",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "static_charge",
			can_pickup_orb = var_0_3
		},
		friendly_murderer_potion_orb = {
			item_name = "friendly_murderer_potion",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "friendly_murderer_potion",
			can_pickup_orb = var_0_3
		},
		hold_my_beer_potion_orb = {
			item_name = "hold_my_beer_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "hold_my_beer_potion",
			can_pickup_orb = var_0_3
		},
		killer_in_the_shadows_potion_orb = {
			item_name = "killer_in_the_shadows_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "killer_in_the_shadows_potion",
			can_pickup_orb = var_0_3
		},
		liquid_bravado_potion_orb = {
			item_name = "liquid_bravado_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "liquid_bravado_potion",
			can_pickup_orb = var_0_3
		},
		moot_milk_potion_orb = {
			item_name = "moot_milk_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "moot_milk_potion",
			can_pickup_orb = var_0_3
		},
		pockets_full_of_bombs_potion_orb = {
			item_name = "pockets_full_of_bombs_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "pockets_full_of_bombs_potion",
			can_pickup_orb = var_0_3
		},
		poison_proof_potion_orb = {
			item_name = "poison_proof_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "poison_proof_potion",
			can_pickup_orb = var_0_3
		},
		vampiric_draught_potion_orb = {
			item_name = "vampiric_draught_potion_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "vampiric_draught_potion",
			can_pickup_orb = var_0_3
		},
		damage_boost_potion_orb = {
			granted_buff = "damage_boost_potion",
			unit_template_name = "orb_pickup_unit",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			item_name = "damage_boost_potion_orb",
			buff_name_for_check = "potion_armor_penetration_buff",
			can_pickup_orb = var_0_3
		},
		speed_boost_potion_orb = {
			granted_buff = "speed_boost_potion",
			unit_template_name = "orb_pickup_unit",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			item_name = "speed_boost_potion_orb",
			buff_name_for_check = "potion_movement_buff",
			can_pickup_orb = var_0_3
		},
		cooldown_reduction_potion_orb = {
			granted_buff = "cooldown_reduction_potion",
			unit_template_name = "orb_pickup_unit",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			item_name = "cooldown_reduction_potion_orb",
			buff_name_for_check = "potion_cooldown_reduction_buff",
			can_pickup_orb = var_0_3
		},
		protection_orb = {
			item_name = "protection_orb",
			unit_name = "units/props/deus_orb/deus_orb_01",
			type = "orb_pickup_unit",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			granted_buff = "protection_orb",
			can_pickup_orb = var_0_3
		},
		ability_cooldown_reduction_orb = {
			type = "orb_pickup_unit",
			unit_name = "units/props/deus_orb/deus_orb_01",
			granted_buff = "ability_cooldown_reduction_orb",
			unit_template_name = "orb_pickup_unit",
			spawn_weighting = 1e-06,
			debug_pickup_category = "orbs",
			can_pickup_orb = var_0_4
		}
	},
	deus_02 = {
		deus_02 = {
			type = "deus_02",
			item_description = "deus_belakor_locus_item_desc",
			spawn_weighting = 1e-06,
			debug_pickup_category = "deus",
			item_name = "deus_belakor_locus",
			unit_name = "units/props/blk/blk_locus_01",
			unit_template_name = "deus_belakor_locus",
			hud_description = "deus_belakor_locus_hud_desc",
			can_spawn_func = var_0_2,
			additional_data = {
				pickup_system = {
					pickup_name = "deus_02"
				},
				death_system = {
					death_reaction_template = "level_object",
					is_husk = true
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "level_object"
				}
			},
			additional_data_husk = {
				pickup_system = {
					pickup_name = "deus_02"
				},
				death_system = {
					death_reaction_template = "level_object",
					is_husk = true
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "level_object"
				}
			}
		}
	},
	deus_04 = {
		deus_04 = {
			type = "deus_04",
			unit_name = "units/props/blk/blk_curse_shadow_homing_skulls_spawner_01",
			unit_template_name = "shadow_homing_skulls_spawner",
			spawn_weighting = 1e-06,
			debug_pickup_category = "deus",
			can_spawn_func = var_0_1
		}
	},
	belakor_crystal = {
		belakor_crystal = {
			only_once = true,
			individual_pickup = false,
			item_name = "belakor_crystal",
			type = "inventory_item",
			spawn_weighting = 1e-06,
			debug_pickup_category = "deus",
			item_description = "belakor_crystal_item_desc",
			slot_name = "slot_level_event",
			unit_name = "units/weapons/player/pup_belakor_crystal/pup_belakor_crystal",
			unit_template_name = "belakor_crystal",
			wield_on_pickup = true,
			hud_description = "belakor_crystal_hud_desc"
		}
	}
}
