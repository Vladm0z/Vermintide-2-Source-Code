-- chunkname: @scripts/settings/equipment/weapon_templates/potions.lua

local tbl = {
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
					-- function 1
					return arg_1_1 == "new_interupting_action" or arg_1_1 ~= "action_complete"
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

tbl.left_hand_unit = "units/weapons/player/wpn_potion/wpn_potion"
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.potion
tbl.wield_anim = "to_potion"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/common"
tbl.load_state_machine = false
tbl.gui_texture = "hud_consumable_icon_potion"
tbl.max_fatigue_points = 4
tbl.can_give_other = true
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local clone = table.clone(tbl)

clone.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
clone.actions.action_one.default.buff_template = "damage_boost_potion"
clone.gui_texture = "hud_consumable_icon_potion"
clone.pickup_data = {
	pickup_name = "damage_boost_potion"
}

local clone_2 = table.clone(tbl)

clone_2.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
clone_2.actions.action_one.default.buff_template = "speed_boost_potion"
clone_2.gui_texture = "hud_consumable_icon_potion"
clone_2.pickup_data = {
	pickup_name = "speed_boost_potion"
}

local clone_3 = table.clone(tbl)

clone_3.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
clone_3.actions.action_one.default.buff_template = "invulnerability_potion"
clone_3.gui_texture = "hud_consumable_icon_potion"
clone_3.pickup_data = {
	pickup_name = "invulnerability_potion"
}

local clone_4 = table.clone(tbl)

clone_4.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
clone_4.actions.action_one.default.buff_template = "cooldown_reduction_potion"
clone_4.gui_texture = "hud_consumable_icon_potion"
clone_4.pickup_data = {
	pickup_name = "cooldown_reduction_potion"
}

return {
	damage_boost_potion = clone,
	speed_boost_potion = clone_2,
	invulnerability_potion = clone_3,
	cooldown_reduction_potion = clone_4
}
