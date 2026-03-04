-- chunkname: @scripts/settings/equipment/weapon_templates/beer_bottle.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				anim_event = "drink",
				anim_end_event = "attack_finished",
				ammo_usage = 1,
				kind = "one_time_consumable",
				weapon_action_hand = "right",
				block_pickup = true,
				uninterruptible = true,
				buff_template = "increase_intoxication_level",
				total_time = 1.9,
				anim_end_event_condition_func = function(arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
				end,
				allowed_chain_actions = {}
			}
		},
		action_dropped = {
			default = {
				alert_sound_range_hit = 10,
				anim_end_event = "attack_finished",
				kind = "throw",
				velocity_multiplier = 1,
				throw_time = 0.35,
				ammo_usage = 1,
				weapon_action_hand = "left",
				block_pickup = true,
				speed = 5,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 0.7,
				anim_end_event_condition_func = function(arg_2_0, arg_2_1)
					return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
				end,
				allowed_chain_actions = {},
				angular_velocity = {
					0,
					-5,
					0
				},
				throw_offset = {
					0.25,
					1.2,
					0
				},
				projectile_info = {
					projectile_unit_template_name = "pickup_unit",
					pickup_name = "beer_bottle",
					drop_on_player_destroyed = true,
					projectile_unit_name = "units/weapons/player/pup_ale/pup_ale"
				}
			}
		},
		action_wield = ActionTemplates.wield_and_use
	},
	ammo_data = {
		ammo_hand = "right",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0,
		ignore_ammo_pickup = true
	}
}

var_0_0.right_hand_unit = "units/weapons/player/wpn_ale/wpn_ale"
var_0_0.right_hand_attachment_node_linking = AttachmentNodeLinking.potion_right
var_0_0.wield_anim = "to_potion"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_0.load_state_machine = false
var_0_0.gui_texture = "hud_consumable_icon_potion"
var_0_0.gui_texture = "hud_consumable_icon_potion"
var_0_0.pickup_data = {
	pickup_name = "beer_bottle"
}
var_0_0.max_fatigue_points = 4
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

return {
	beer_bottle = table.clone(var_0_0)
}
