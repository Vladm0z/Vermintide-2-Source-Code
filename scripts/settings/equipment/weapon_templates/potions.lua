-- chunkname: @scripts/settings/equipment/weapon_templates/potions.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				damage_window_start = 0.05,
				ammo_usage = 1,
				anim_end_event = "attack_finished",
				kind = "buff",
				buff_template = "damage_boost_potion",
				damage_window_end = 0.2,
				weapon_action_hand = "left",
				block_pickup = true,
				uninterruptible = true,
				anim_event = "attack_heal",
				total_time = 1.3,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
				end,
				allowed_chain_actions = {}
			}
		},
		action_two = {
			default = ActionTemplates.give_item_on_defend
		},
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left,
		action_instant_give_item = ActionTemplates.instant_give_item
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

var_0_0.left_hand_unit = "units/weapons/player/wpn_potion/wpn_potion"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.potion
var_0_0.wield_anim = "to_potion"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_0.load_state_machine = false
var_0_0.gui_texture = "hud_consumable_icon_potion"
var_0_0.max_fatigue_points = 4
var_0_0.can_give_other = true
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local var_0_1 = table.clone(var_0_0)

var_0_1.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
var_0_1.actions.action_one.default.buff_template = "damage_boost_potion"
var_0_1.gui_texture = "hud_consumable_icon_potion"
var_0_1.pickup_data = {
	pickup_name = "damage_boost_potion"
}

local var_0_2 = table.clone(var_0_0)

var_0_2.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
var_0_2.actions.action_one.default.buff_template = "speed_boost_potion"
var_0_2.gui_texture = "hud_consumable_icon_potion"
var_0_2.pickup_data = {
	pickup_name = "speed_boost_potion"
}

local var_0_3 = table.clone(var_0_0)

var_0_3.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
var_0_3.actions.action_one.default.buff_template = "invulnerability_potion"
var_0_3.gui_texture = "hud_consumable_icon_potion"
var_0_3.pickup_data = {
	pickup_name = "invulnerability_potion"
}

local var_0_4 = table.clone(var_0_0)

var_0_4.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
var_0_4.actions.action_one.default.buff_template = "cooldown_reduction_potion"
var_0_4.gui_texture = "hud_consumable_icon_potion"
var_0_4.pickup_data = {
	pickup_name = "cooldown_reduction_potion"
}

return {
	damage_boost_potion = var_0_1,
	speed_boost_potion = var_0_2,
	invulnerability_potion = var_0_3,
	cooldown_reduction_potion = var_0_4
}
