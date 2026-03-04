-- chunkname: @scripts/settings/dlcs/morris/morris_potion_settings.lua

local var_0_0 = DLCSettings.morris.pickups.deus_potions

local function var_0_1(arg_1_0)
	local var_1_0 = {
		actions = {
			action_one = {
				default = {
					damage_window_start = 0.05,
					anim_end_event = "attack_finished",
					ammo_usage = 1,
					kind = "buff",
					damage_window_end = 0.2,
					weapon_action_hand = "left",
					block_pickup = true,
					uninterruptible = true,
					anim_event = "attack_heal",
					total_time = 1.3,
					anim_end_event_condition_func = function (arg_2_0, arg_2_1)
						return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
					end,
					condition_func = function (arg_3_0)
						local var_3_0 = ScriptUnit.extension(arg_3_0, "buff_system")
						local var_3_1 = var_3_0:has_buff_type(arg_1_0 .. "_potion")
						local var_3_2 = var_3_0:has_buff_type(arg_1_0 .. "_potion_increased")

						return not (var_3_1 or var_3_2)
					end,
					allowed_chain_actions = {},
					buff_template = arg_1_0 .. "_potion"
				}
			},
			action_two = {
				default = ActionTemplates.give_item_on_defend
			},
			action_instant_drink_potion = {
				default = {
					kind = "dummy",
					weapon_action_hand = "left",
					total_time = 0,
					allowed_chain_actions = {}
				},
				instant_drink = {
					damage_window_end = 0.2,
					ammo_usage = 1,
					anim_end_event = "attack_finished",
					kind = "buff",
					damage_window_start = 0.05,
					weapon_action_hand = "left",
					interaction_priority = 2,
					block_pickup = true,
					uninterruptible = true,
					anim_event = "attack_heal",
					auto_validate_on_gamepad = true,
					total_time = 1.3,
					anim_end_event_condition_func = function (arg_4_0, arg_4_1)
						return arg_4_1 ~= "new_interupting_action" and arg_4_1 ~= "action_complete"
					end,
					allowed_chain_actions = {},
					buff_template = arg_1_0 .. "_potion",
					condition_func = function (arg_5_0)
						return true
					end
				}
			},
			action_instant_give_item = ActionTemplates.instant_give_item,
			action_inspect = ActionTemplates.action_inspect_left,
			action_career_skill = ActionTemplates.career_skill_dummy,
			action_wield = ActionTemplates.wield_left,
			action_instant_grenade_throw = ActionTemplates.instant_grenade_throw,
			action_instant_heal_self = ActionTemplates.instant_equip_and_heal_self
		},
		ammo_data = {
			ammo_hand = "left",
			destroy_when_out_of_ammo = true,
			max_ammo = 1,
			ammo_per_clip = 1,
			reload_time = 0,
			ignore_ammo_pickup = true
		}
	}

	var_1_0.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
	var_1_0.left_hand_attachment_node_linking = AttachmentNodeLinking.potion
	var_1_0.wield_anim = "to_potion"
	var_1_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
	var_1_0.load_state_machine = false
	var_1_0.gui_texture = "hud_consumable_icon_potion"
	var_1_0.max_fatigue_points = 4
	var_1_0.can_give_other = true
	var_1_0.buffs = {
		change_dodge_distance = {
			external_optional_multiplier = 1
		},
		change_dodge_speed = {
			external_optional_multiplier = 1
		}
	}
	var_1_0.pickup_data = {
		pickup_name = arg_1_0 .. "_potion"
	}
	var_1_0.material_settings_name = var_0_0[arg_1_0 .. "_potion"].material_settings_name

	return var_1_0
end

return {
	liquid_bravado_potion = var_0_1("liquid_bravado"),
	vampiric_draught_potion = var_0_1("vampiric_draught"),
	moot_milk_potion = var_0_1("moot_milk"),
	friendly_murderer_potion = var_0_1("friendly_murderer"),
	killer_in_the_shadows_potion = var_0_1("killer_in_the_shadows"),
	pockets_full_of_bombs_potion = var_0_1("pockets_full_of_bombs"),
	hold_my_beer_potion = var_0_1("hold_my_beer"),
	poison_proof_potion = var_0_1("poison_proof")
}
