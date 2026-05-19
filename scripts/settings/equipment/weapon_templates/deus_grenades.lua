-- chunkname: @scripts/settings/equipment/weapon_templates/deus_grenades.lua

local var_0_0 = {
	crosshair_style = "default",
	max_fatigue_points = 4,
	left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_lighter_01_t1",
	gui_texture = "hud_consumable_icon_grenade",
	dodge_distance = 1,
	wield_anim = "to_grenade",
	load_state_machine = false,
	dodge_count = 3,
	right_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_01_t1",
	dodge_speed = 1,
	state_machine = "units/beings/player/first_person_base/state_machines/common",
	can_give_other = true,
	actions = {
		action_one = {
			default = {
				charge_sound_stop_event = "stop_player_combat_weapon_grenade_ignite_loop",
				ammo_usage = 1,
				anim_end_event = "attack_finished",
				kind = "charge",
				minimum_hold_time = 1.1,
				charge_sound_name = "player_combat_weapon_grenade_ignite_loop",
				charge_time = 1,
				explode_time = 3.5,
				block_pickup = true,
				uninterruptible = true,
				anim_event = "grenade_charge",
				anim_end_event_condition_func = function(arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
				end,
				total_time = math.huge,
				allowed_chain_actions = {
					{
						sub_action = "throw",
						start_time = 1,
						action = "action_one",
						input = "action_one_release"
					},
					{
						sub_action = "cancel",
						start_time = 0.55,
						action = "action_one",
						input = "action_two"
					},
					{
						start_time = 0,
						blocker = true,
						input = "action_one_hold"
					},
					{
						sub_action = "throw",
						start_time = 1.1,
						action = "action_one",
						auto_chain = true
					}
				}
			},
			cancel = {
				anim_event = "grenade_charge_cancel",
				block_pickup = true,
				kind = "dummy",
				total_time = 1.25,
				allowed_chain_actions = {}
			},
			throw = {
				uninterruptible = true,
				anim_end_event = "attack_finished",
				hide_weapon_after_fire = true,
				kind = "charged_projectile",
				is_impact_type = true,
				block_pickup = true,
				alert_sound_range_hit = 10,
				fire_time = 0.3,
				throw_time = 0.13,
				throw_up_this_much_in_target_direction = 0.15,
				ammo_usage = 1,
				forced_charge_level = 1,
				speed = 1750,
				throw_offset_length_in_target_direction = 0.1,
				anim_event = "attack_throw",
				total_time = 0.5,
				anim_end_event_condition_func = function(arg_2_0, arg_2_1)
					return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
				end,
				throw_offset = Vector3Box(0, 0, 0.9),
				allowed_chain_actions = {},
				projectile_info = Projectiles.grenade,
				impact_data = {
					grenade = true,
					targets = 1,
					aoe = ExplosionTemplates.grenade
				},
				timed_data = {
					life_time = 3,
					aoe = ExplosionTemplates.grenade
				},
				angular_velocity = {
					10,
					0,
					0
				}
			}
		},
		action_two = {
			default = {
				kind = "dummy",
				weapon_action_hand = "left",
				total_time = 0,
				allowed_chain_actions = {}
			},
			give_item = ActionTemplates.give_item_on_defend
		},
		action_instant_throw_grenade = {
			default = {
				kind = "dummy",
				weapon_action_hand = "left",
				total_time = 0,
				allowed_chain_actions = {}
			},
			instant_throw = {
				uninterruptible = true,
				anim_end_event = "attack_finished",
				hide_weapon_after_fire = true,
				kind = "charged_projectile",
				throw_time = 0.13,
				is_impact_type = true,
				block_pickup = true,
				alert_sound_range_hit = 10,
				fire_time = 0,
				auto_validate_on_gamepad = true,
				throw_up_this_much_in_target_direction = 0.15,
				ammo_usage = 1,
				forced_charge_level = 1,
				speed = 1750,
				throw_offset_length_in_target_direction = 0.1,
				anim_event = "attack_throw",
				total_time = 0.5,
				anim_end_event_condition_func = function(arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action" and arg_3_1 ~= "action_complete"
				end,
				condition_func = function(arg_4_0)
					return true
				end,
				throw_offset = Vector3Box(0, 0, 0.9),
				allowed_chain_actions = {},
				projectile_info = Projectiles.grenade,
				impact_data = {
					grenade = true,
					targets = 1,
					aoe = ExplosionTemplates.grenade
				},
				timed_data = {
					life_time = 3,
					aoe = ExplosionTemplates.grenade
				},
				angular_velocity = {
					10,
					0,
					0
				}
			}
		},
		action_instant_give_item = ActionTemplates.instant_give_item,
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield,
		action_instant_grenade_throw = ActionTemplates.instant_grenade_throw,
		action_instant_heal_self = ActionTemplates.instant_equip_and_heal_self,
		action_instant_heal_other = ActionTemplates.instant_equip_and_heal_other,
		action_instant_drink_potion = ActionTemplates.instant_equip_and_drink_potion,
		action_instant_equip_tome = ActionTemplates.instant_equip_tome,
		action_instant_equip_grimoire = ActionTemplates.instant_equip_grimoire,
		action_instant_equip_grenade = ActionTemplates.instant_equip_grenade_only,
		action_instant_equip_healing_draught = ActionTemplates.instant_equip_and_drink_healing_draught
	},
	ammo_data = {
		ammo_hand = "right",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0,
		ignore_ammo_pickup = true
	},
	pickup_data = {
		pickup_name = "impact_grenade"
	},
	right_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right,
	left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left,
	buffs = {
		change_dodge_distance = {
			external_optional_multiplier = 1
		},
		change_dodge_speed = {
			external_optional_multiplier = 1
		}
	}
}
local var_0_1 = table.clone(var_0_0)

var_0_1.actions.action_one.throw = {
	uninterruptible = true,
	anim_end_event = "attack_finished",
	hide_weapon_after_fire = true,
	kind = "charged_projectile",
	throw_up_this_much_in_target_direction = 0.15,
	is_impact_type = true,
	block_pickup = true,
	alert_sound_range_hit = 40,
	fire_time = 0.3,
	hit_effect = "grenade_bounce",
	throw_time = 0.13,
	ammo_usage = 1,
	forced_charge_level = 1,
	speed = 1750,
	throw_offset_length_in_target_direction = 0.1,
	anim_event = "attack_throw",
	total_time = 0.5,
	anim_end_event_condition_func = function(arg_5_0, arg_5_1)
		return arg_5_1 ~= "new_interupting_action" and arg_5_1 ~= "action_complete"
	end,
	enter_function = function(arg_6_0, arg_6_1)
		local var_6_0 = ScriptUnit.extension_input(arg_6_0, "dialogue_system")
		local var_6_1 = FrameTable.alloc_table()

		var_6_0:trigger_networked_dialogue_event("on_holy_grenade", var_6_1)
	end,
	throw_offset = Vector3Box(0, 0, 0.9),
	allowed_chain_actions = {},
	projectile_info = Projectiles.holy_hand_grenade,
	impact_data = {
		grenade = true,
		no_stop_on_friendly_fire = true
	},
	timed_data = {
		activate_life_time_on_impact = true,
		life_time = 5,
		grenade = true,
		aoe = ExplosionTemplates.holy_hand_grenade
	},
	angular_velocity = {
		10,
		0,
		0
	}
}
var_0_1.left_hand_unit = var_0_0.left_hand_unit
var_0_1.wield_anim = var_0_0.wield_anim
var_0_1.right_hand_unit = "units/weapons/player/wpn_emp_holy_hand_grenade_01_t1/wpn_emp_holy_hand_grenade_01_t1"
var_0_1.left_hand_unit = "units/weapons/player/wpn_emp_holy_hand_grenade_01_t1/wpn_emp_holy_hand_grenade_lighter_01_t1"
var_0_1.pickup_data.pickup_name = "holy_hand_grenade"

return {
	holy_hand_grenade = var_0_1
}
