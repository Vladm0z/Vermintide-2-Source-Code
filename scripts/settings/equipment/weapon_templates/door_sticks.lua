-- chunkname: @scripts/settings/equipment/weapon_templates/door_sticks.lua

local var_0_0 = 2
local var_0_1 = {
	actions = {
		action_one = {
			default = {
				throw_time = 0.36,
				ammo_usage = 1,
				kind = "throw",
				block_pickup = true,
				speed = 4,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 1.08,
				allowed_chain_actions = {},
				angular_velocity = {
					0,
					11,
					0
				},
				throw_offset = {
					0.2,
					0,
					0
				},
				projectile_info = {
					use_dynamic_collision = false,
					collision_filter = "n/a",
					projectile_unit_template_name = "pickup_projectile_unit",
					pickup_name = "door_stick",
					drop_on_player_destroyed = true,
					projectile_unit_name = "units/gameplay/timed_door_base_02/pup_timed_door_stick"
				}
			}
		},
		action_two = {
			default = {
				damage_window_start = 0.05,
				anim_end_event = "attack_finished",
				outer_push_angle = 180,
				kind = "push_stagger",
				attack_template = "basic_sweep_push",
				damage_profile_outer = "light_push",
				push_angle = 100,
				hit_effect = "melee_hit_slashing",
				damage_window_end = 0.2,
				charge_value = "action_push",
				weapon_action_hand = "right",
				anim_event = "attack_push",
				damage_profile_inner = "medium_push",
				total_time = 0.8,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_one",
						end_time = 0.7,
						input = "action_one"
					}
				},
				push_radius = var_0_0,
				condition_func = function (arg_2_0, arg_2_1)
					return not ScriptUnit.extension(arg_2_0, "status_system"):fatigued()
				end
			}
		},
		action_dropped = {
			default = {
				throw_time = 0.36,
				ammo_usage = 1,
				kind = "throw",
				block_pickup = true,
				speed = 4,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 1.08,
				allowed_chain_actions = {},
				angular_velocity = {
					0,
					11,
					0
				},
				throw_offset = {
					0.2,
					0,
					0
				},
				projectile_info = {
					use_dynamic_collision = false,
					collision_filter = "n/a",
					projectile_unit_template_name = "pickup_projectile_unit",
					pickup_name = "door_stick",
					drop_on_player_destroyed = true,
					projectile_unit_name = "units/gameplay/timed_door_base_02/pup_timed_door_stick"
				}
			}
		},
		action_wield = ActionTemplates.wield
	},
	ammo_data = {
		ammo_hand = "right",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0
	},
	pickup_data = {
		pickup_name = "door_stick"
	}
}

var_0_1.right_hand_unit = "units/gameplay/timed_door_base_02/wpn_timed_door_stick"
var_0_1.right_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right
var_0_1.display_unit = "units/weapons/weapon_display/display_1h_weapon"
var_0_1.wield_anim = "to_1h_sword"
var_0_1.wield_anim_3p = "to_1h_sword"
var_0_1.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_1.load_state_machine = false
var_0_1.block_wielding = true
var_0_1.third_person_extension_template = "prop_unit"
var_0_1.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local var_0_2 = table.clone(var_0_1)

var_0_2.right_hand_unit = "units/gameplay/timed_door_base_02/wpn_timed_door_stick"

return {
	door_stick = var_0_2
}
