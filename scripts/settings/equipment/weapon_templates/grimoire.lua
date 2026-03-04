-- chunkname: @scripts/settings/equipment/weapon_templates/grimoire.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				kind = "melee_start",
				weapon_action_hand = "left",
				total_time = math.huge,
				allowed_chain_actions = {
					{
						sub_action = "dummy_action",
						start_time = 0,
						action = "action_one",
						end_time = 0.4,
						input = "action_one_release"
					},
					{
						sub_action = "action_throw",
						start_time = 0.5,
						action = "action_one",
						auto_chain = true
					}
				}
			},
			dummy_action = {
				kind = "dummy",
				weapon_action_hand = "left",
				total_time = 0,
				allowed_chain_actions = {}
			},
			action_throw = {
				kind = "throw_grimoire",
				ammo_usage = 1,
				anim_end_event = "attack_finished",
				anim_event = "attack_throw",
				weapon_action_hand = "left",
				total_time = 0.7,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
				end,
				allowed_chain_actions = {}
			}
		},
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left
	},
	ammo_data = {
		ammo_hand = "left",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0
	}
}

var_0_0.left_hand_unit = "units/weapons/player/wpn_grimoire_01/wpn_grimoire_01"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_0.wield_anim = "to_first_aid"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_0.load_state_machine = false
var_0_0.gui_texture = "icons_placeholder_melee_01"
var_0_0.is_grimoire = true
var_0_0.max_fatigue_points = 1
var_0_0.dodge_count = 3
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
var_0_0.attack_meta_data = {
	tap_attack = {
		arc = 0,
		max_range = math.huge
	},
	hold_attack = {
		arc = 0,
		max_range = math.huge,
		attack_chain = {
			start_sub_action_name = "default",
			start_action_name = "action_one",
			transitions = {
				action_one = {
					default = {
						wanted_sub_action_name = "action_throw",
						wanted_action_name = "action_one",
						bot_wait_input = "hold_attack",
						bot_wanted_input = "hold_attack"
					}
				}
			}
		}
	}
}

WeaponUtils.add_bot_meta_data_chain_actions(var_0_0.actions, var_0_0.attack_meta_data.hold_attack.attack_chain.transitions)

local var_0_1 = table.clone(var_0_0)

var_0_1.left_hand_unit = "units/weapons/player/wpn_side_objective_tome/wpn_side_objective_tome_01"
var_0_1.actions = {
	action_one = {
		default = {
			kind = "dummy",
			weapon_action_hand = "left",
			total_time = 0,
			allowed_chain_actions = {}
		}
	},
	action_two = {
		default = {
			kind = "dummy",
			weapon_action_hand = "left",
			total_time = 0,
			allowed_chain_actions = {}
		}
	},
	action_inspect = ActionTemplates.action_inspect_left,
	action_wield = ActionTemplates.wield_left
}
var_0_1.pickup_data = {
	pickup_name = "tome"
}

local var_0_2 = table.clone(var_0_0)
local var_0_3 = table.clone(var_0_1)
local var_0_4 = table.clone(ActionTemplates.action_inspect)

var_0_4.action_inspect_hold.anim_event = "inspect_start_2"
var_0_2.actions.action_inspect = var_0_4
var_0_3.actions.action_inspect = var_0_4

local var_0_5 = table.clone(var_0_0)

var_0_5.is_grimoire = false
var_0_5.is_not_droppable = true
var_0_5.left_hand_unit = "units/weapons/player/pup_ritual_site_01/wpn_ritual_site_01"
var_0_5.actions = {
	action_one = {
		default = {
			kind = "melee_start",
			weapon_action_hand = "left",
			total_time = math.huge,
			allowed_chain_actions = {
				{
					sub_action = "dummy_action",
					start_time = 0,
					action = "action_one",
					end_time = 0.4,
					input = "action_one_release"
				},
				{
					sub_action = "action_throw",
					start_time = 0.5,
					action = "action_one",
					auto_chain = true
				}
			}
		},
		dummy_action = {
			kind = "dummy",
			weapon_action_hand = "left",
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_throw = {
			kind = "throw_geheimnisnacht_2021",
			ammo_usage = 1,
			anim_end_event = "attack_finished",
			anim_event = "attack_throw",
			weapon_action_hand = "left",
			total_time = 1.6,
			anim_end_event_condition_func = function (arg_2_0, arg_2_1)
				return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
			end,
			allowed_chain_actions = {}
		}
	},
	action_two = {
		default = {
			minimum_hold_time = 0.3,
			anim_end_event = "inspect_end",
			cooldown = 0.15,
			weapon_action_hand = "either",
			can_abort_reload = false,
			kind = "inspect_geheimnisnacht_2021",
			hold_input = "action_two_hold",
			anim_event = "inspect_start",
			condition_func = function (arg_3_0, arg_3_1)
				return Managers.input:is_device_active("gamepad")
			end,
			anim_end_event_condition_func = function (arg_4_0, arg_4_1)
				return arg_4_1 ~= "new_interupting_action"
			end,
			total_time = math.huge,
			allowed_chain_actions = {},
			weapon_sway_settings = {
				recentering_lerp_speed = 0,
				lerp_speed = 10,
				sway_range = 1,
				camera_look_sensitivity = 1,
				look_sensitivity = 1.5
			}
		}
	},
	action_inspect = table.clone(ActionTemplates.action_inspect),
	action_wield = ActionTemplates.wield_left
}
var_0_5.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_5.wield_anim = "to_ritual_skull"
var_0_5.wield_anim_3p = "to_ritual_skull"
var_0_5.state_machine = "units/beings/player/first_person_base/state_machines/misc/ritual_skull"
var_0_5.load_state_machine = false
var_0_5.wield_anim_career = {
	bw_necromancer = "to_ritual_skull_immune",
	wh_priest = "to_ritual_skull_immune",
	we_thornsister = "to_ritual_skull_immune",
	es_questingknight = "to_ritual_skull_immune",
	dr_slayer = "to_ritual_skull_immune"
}
var_0_5.wield_anim_career_3p = {
	bw_necromancer = "to_ritual_skull",
	wh_priest = "to_ritual_skull",
	we_thornsister = "to_ritual_skull",
	es_questingknight = "to_ritual_skull",
	dr_slayer = "to_ritual_skull"
}
var_0_5.actions.action_inspect.action_inspect_hold.kind = "inspect_geheimnisnacht_2021"

return {
	wpn_grimoire_01 = table.clone(var_0_2),
	wpn_side_objective_tome_01 = table.clone(var_0_3),
	wpn_geheimnisnacht_2021_side_objective = table.clone(var_0_5)
}
