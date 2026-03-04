-- chunkname: @scripts/settings/equipment/weapon_templates/grenades.lua

local var_0_0 = weapon_template_frag or {}

var_0_0.actions = {
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
			anim_end_event_condition_func = function (arg_1_0, arg_1_1)
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
			anim_end_event_condition_func = function (arg_2_0, arg_2_1)
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
	action_inspect = ActionTemplates.action_inspect,
	action_wield = ActionTemplates.wield,
	action_instant_give_item = ActionTemplates.instant_give_item
}
var_0_0.ammo_data = {
	ammo_hand = "right",
	destroy_when_out_of_ammo = true,
	max_ammo = 1,
	ammo_per_clip = 1,
	reload_time = 0,
	ignore_ammo_pickup = true
}
var_0_0.pickup_data = {
	pickup_name = "impact_grenade"
}
var_0_0.right_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_01_t1"
var_0_0.right_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right
var_0_0.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_lighter_01_t1"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_0.wield_anim = "to_grenade"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_0.load_state_machine = false
var_0_0.gui_texture = "hud_consumable_icon_grenade"
var_0_0.crosshair_style = "default"
var_0_0.max_fatigue_points = 4
var_0_0.dodge_distance = 1
var_0_0.dodge_speed = 1
var_0_0.dodge_count = 3
var_0_0.can_give_other = true
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local var_0_1 = weapon_template_fire_dot or {}

var_0_1.actions = {
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
			anim_end_event_condition_func = function (arg_3_0, arg_3_1)
				return arg_3_1 ~= "new_interupting_action" and arg_3_1 ~= "action_complete"
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
			alert_sound_range_hit = 10,
			fire_time = 0.3,
			is_impact_type = false,
			block_pickup = true,
			throw_time = 0.13,
			ammo_usage = 1,
			forced_charge_level = 1,
			speed = 2000,
			throw_offset_length_in_target_direction = 0.1,
			anim_event = "attack_throw",
			total_time = 0.5,
			anim_end_event_condition_func = function (arg_4_0, arg_4_1)
				return arg_4_1 ~= "new_interupting_action" and arg_4_1 ~= "action_complete"
			end,
			throw_offset = Vector3Box(0, 0, 0.1),
			allowed_chain_actions = {},
			projectile_info = Projectiles.grenade_fire,
			impact_data = {
				grenade = true,
				targets = 1,
				aoe = ExplosionTemplates.fire_grenade
			},
			timed_data = {
				life_time = 15,
				aoe = ExplosionTemplates.fire_grenade
			},
			angular_velocity = {
				0,
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
	action_inspect = ActionTemplates.action_inspect,
	action_wield = ActionTemplates.wield,
	action_instant_give_item = ActionTemplates.instant_give_item
}
var_0_1.ammo_data = {
	ammo_hand = "right",
	destroy_when_out_of_ammo = true,
	max_ammo = 1,
	ammo_per_clip = 1,
	reload_time = 0
}
var_0_1.pickup_data = {
	pickup_name = "dot_grenade"
}
var_0_1.right_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_01_t1"
var_0_1.right_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right
var_0_1.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_lighter_01_t1"
var_0_1.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_1.wield_anim = "to_fire_dot_grenade"
var_0_1.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_1.load_state_machine = false
var_0_1.gui_texture = "hud_consumable_icon_grenade"
var_0_1.crosshair_style = "default"
var_0_1.max_fatigue_points = 4
var_0_1.can_give_other = true
var_0_1.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local var_0_2 = table.clone(var_0_0)

var_0_2.left_hand_unit = var_0_0.left_hand_unit
var_0_2.wield_anim = var_0_0.wield_anim
var_0_2.right_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_01_t1"
var_0_2.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_lighter_01_t1"
var_0_2.pickup_data.pickup_name = "frag_grenade_t1"

local var_0_3 = table.clone(var_0_0)

var_0_3.left_hand_unit = var_0_0.left_hand_unit
var_0_3.wield_anim = var_0_0.wield_anim
var_0_3.right_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t2/wpn_emp_grenade_01_t2"
var_0_3.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t2/wpn_emp_grenade_lighter_01_t2"
var_0_3.pickup_data.pickup_name = "frag_grenade_t2"

local var_0_4 = table.clone(var_0_0)

var_0_4.right_hand_unit = "units/weapons/player/wpn_shadow_flare/wpn_shadow_flare"
var_0_4.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t2/wpn_emp_grenade_lighter_01_t2"
var_0_4.actions.action_one.throw.impact_data.aoe = ExplosionTemplates.shadow_flare
var_0_4.actions.action_one.throw.timed_data.aoe = ExplosionTemplates.shadow_flare
var_0_4.pickup_data = nil

local var_0_5 = table.clone(var_0_1)

var_0_5.left_hand_unit = var_0_1.left_hand_unit
var_0_5.wield_anim = var_0_1.wield_anim
var_0_5.right_hand_unit = "units/weapons/player/wpn_emp_grenade_03_t1/wpn_emp_grenade_03_t1"
var_0_5.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_lighter_01_t1"
var_0_5.pickup_data.pickup_name = "fire_grenade_t1"
var_0_5.actions.action_one.throw.projectile_info = Projectiles.grenade_fire

local var_0_6 = table.clone(var_0_1)

var_0_6.left_hand_unit = var_0_1.left_hand_unit
var_0_6.wield_anim = var_0_1.wield_anim
var_0_6.right_hand_unit = "units/weapons/player/wpn_emp_grenade_03_t2/wpn_emp_grenade_03_t2"
var_0_6.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t2/wpn_emp_grenade_lighter_01_t2"
var_0_6.pickup_data.pickup_name = "fire_grenade_t2"
var_0_6.actions.action_one.throw.projectile_info = Projectiles.grenade_fire

local var_0_7 = table.clone(var_0_0)

var_0_7.actions.action_one.throw.impact_data.aoe = ExplosionTemplates.engineer_grenade
var_0_7.actions.action_one.throw.timed_data.aoe = ExplosionTemplates.engineer_grenade
var_0_7.left_hand_unit = var_0_0.left_hand_unit
var_0_7.wield_anim = var_0_0.wield_anim
var_0_7.right_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_01_t1"
var_0_7.left_hand_unit = "units/weapons/player/wpn_emp_grenade_01_t1/wpn_emp_grenade_lighter_01_t1"
var_0_7.pickup_data.pickup_name = "engineer_grenade_t1"

return {
	grenade = table.clone(var_0_0),
	frag_grenade_t1 = var_0_2,
	frag_grenade_t2 = var_0_3,
	fire_grenade_t1 = var_0_5,
	fire_grenade_t2 = var_0_6,
	shadow_flare = var_0_4,
	engineer_grenade_t1 = var_0_7
}
