-- chunkname: @scripts/settings/equipment/weapon_templates/1h_swords_flaming_spell.lua

local var_0_0 = 2
local var_0_1 = 1.9
local var_0_2 = {
	actions = {
		action_one = {
			default = {
				aim_assist_ramp_decay_delay = 0.1,
				anim_end_event = "attack_finished",
				kind = "melee_start",
				attack_hold_input = "action_one_hold",
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_ramp_multiplier = 0.1,
				anim_event = "attack_swing_charge_right",
				anim_end_event_condition_func = function(arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
				end,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.65,
						buff_name = "planted_charging_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "light_attack_left",
						start_time = 0,
						action = "action_one",
						end_time = 0.3,
						input = "action_one_release"
					},
					{
						sub_action = "heavy_attack_spell",
						start_time = 0.7,
						action = "action_one",
						input = "action_one_release"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						start_time = 0.3,
						blocker = true,
						end_time = 1.2,
						input = "action_one_hold"
					},
					{
						sub_action = "heavy_attack_spell",
						start_time = 1.2,
						action = "action_one",
						auto_chain = true
					}
				}
			},
			default_right = {
				aim_assist_ramp_decay_delay = 0.1,
				anim_end_event = "attack_finished",
				kind = "melee_start",
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_ramp_multiplier = 0.1,
				anim_event = "attack_swing_charge",
				anim_end_event_condition_func = function(arg_2_0, arg_2_1)
					return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
				end,
				total_time = math.huge,
				anim_time_scale = var_0_1 * 1.25,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.65,
						buff_name = "planted_charging_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "light_attack_right",
						start_time = 0,
						action = "action_one",
						end_time = 0.3,
						input = "action_one_release"
					},
					{
						sub_action = "heavy_attack_left",
						start_time = 0.7,
						action = "action_one",
						input = "action_one_release"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						start_time = 0.3,
						blocker = true,
						end_time = 1.4,
						input = "action_one_hold"
					},
					{
						sub_action = "heavy_attack_left",
						start_time = 1.2,
						action = "action_one",
						auto_chain = true
					}
				}
			},
			default_left = {
				aim_assist_ramp_decay_delay = 0.1,
				anim_end_event = "attack_finished",
				kind = "melee_start",
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_ramp_multiplier = 0.1,
				anim_event = "attack_swing_charge",
				anim_end_event_condition_func = function(arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action" and arg_3_1 ~= "action_complete"
				end,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.65,
						buff_name = "planted_charging_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "light_attack_stab",
						start_time = 0,
						action = "action_one",
						end_time = 0.3,
						input = "action_one_release"
					},
					{
						sub_action = "heavy_attack_left",
						start_time = 0.7,
						action = "action_one",
						input = "action_one_release"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						start_time = 0.3,
						blocker = true,
						end_time = 1,
						input = "action_one_hold"
					},
					{
						sub_action = "heavy_attack_left",
						start_time = 0.8,
						action = "action_one",
						auto_chain = true
					}
				}
			},
			heavy_attack_left = {
				damage_window_start = 0.15,
				range_mod = 1.2,
				kind = "sweep",
				first_person_hit_anim = "shake_hit",
				no_damage_impact_sound_event = "fire_hit_armour",
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				damage_profile = "medium_burning_tank",
				hit_effect = "melee_hit_sword_1h",
				damage_window_end = 0.27,
				impact_sound_event = "fire_hit",
				charge_value = "heavy_attack",
				anim_end_event = "attack_finished",
				dedicated_target_range = 2,
				uninterruptible = true,
				anim_event = "attack_swing_heavy",
				hit_stop_anim = "attack_hit",
				total_time = 2.25,
				anim_end_event_condition_func = function(arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action" and arg_4_1 ~= "action_complete"
				end,
				anim_time_scale = var_0_1 * 1.25,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 1.25,
						end_time = 0.25,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_one",
						release_required = "action_one_hold",
						end_time = 1.05,
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_one",
						release_required = "action_one_hold",
						end_time = 1.05,
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 1,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					}
				},
				enter_function = function(arg_5_0, arg_5_1)
					return arg_5_1:reset_release_input()
				end
			},
			heavy_attack_spell = {
				push_radius = 2.5,
				forward_offset = 1.5,
				kind = "shield_slam",
				no_damage_impact_sound_event = "fire_hit_armour",
				damage_profile = "dagger_burning_slam",
				armor_impact_sound_event = "fire_hit_armour",
				hit_time = 0.35,
				aim_assist_ramp_multiplier = 0.2,
				hit_effect = "melee_hit_hammers_2h",
				aim_assist_max_ramp_multiplier = 0.4,
				aim_assist_ramp_decay_delay = 0.1,
				additional_critical_strike_chance = 0,
				impact_sound_event = "fire_hit",
				charge_value = "heavy_attack",
				anim_end_event = "attack_finished",
				damage_profile_aoe = "dagger_burning_slam_aoe",
				dedicated_target_range = 2,
				aoe_damage = true,
				uninterruptible = true,
				anim_event = "attack_swing_right_spell",
				total_time = 1.5,
				anim_end_event_condition_func = function(arg_6_0, arg_6_1)
					return arg_6_1 ~= "new_interupting_action" and arg_6_1 ~= "action_complete"
				end,
				anim_time_scale = var_0_1 * 1.1,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 1.1,
						end_time = 0.2,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default_right",
						start_time = 0.65,
						action = "action_one",
						release_required = "action_one_hold",
						end_time = 1.25,
						input = "action_one"
					},
					{
						sub_action = "default_right",
						start_time = 0.65,
						action = "action_one",
						release_required = "action_one_hold",
						end_time = 1.25,
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 1,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.55,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					}
				},
				enter_function = function(arg_7_0, arg_7_1)
					return arg_7_1:reset_release_input()
				end,
				critical_strike = {}
			},
			light_attack_left = {
				damage_window_start = 0.38,
				range_mod = 1.15,
				kind = "sweep",
				first_person_hit_anim = "shake_hit",
				no_damage_impact_sound_event = "fire_hit_armour",
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				damage_profile = "light_slashing_linesman",
				hit_effect = "melee_hit_sword_1h",
				damage_window_end = 0.52,
				impact_sound_event = "fire_hit",
				charge_value = "light_attack",
				anim_end_event = "attack_finished",
				dedicated_target_range = 2.5,
				anim_event = "attack_swing_left",
				hit_stop_anim = "attack_hit",
				total_time = 2.1,
				anim_end_event_condition_func = function(arg_8_0, arg_8_1)
					return arg_8_1 ~= "new_interupting_action" and arg_8_1 ~= "action_complete"
				end,
				anim_time_scale = var_0_1 * 1.25,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.7,
						end_time = 0.5,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default_right",
						start_time = 0.6,
						action = "action_one",
						end_time = 1.2,
						input = "action_one"
					},
					{
						sub_action = "default_right",
						start_time = 0.6,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					}
				}
			},
			light_attack_right = {
				damage_window_start = 0.38,
				range_mod = 1.15,
				kind = "sweep",
				first_person_hit_anim = "shake_hit",
				no_damage_impact_sound_event = "fire_hit_armour",
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				damage_profile = "light_slashing_linesman",
				hit_effect = "melee_hit_sword_1h",
				damage_window_end = 0.5,
				impact_sound_event = "fire_hit",
				charge_value = "light_attack",
				anim_end_event = "attack_finished",
				dedicated_target_range = 2.5,
				anim_event = "attack_swing_right_diagonal",
				hit_stop_anim = "attack_hit",
				total_time = 1,
				anim_end_event_condition_func = function(arg_9_0, arg_9_1)
					return arg_9_1 ~= "new_interupting_action" and arg_9_1 ~= "action_complete"
				end,
				anim_time_scale = var_0_1 * 1.05,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.7,
						end_time = 0.5,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default_left",
						start_time = 0.5,
						action = "action_one",
						end_time = 1.2,
						input = "action_one"
					},
					{
						sub_action = "default_left",
						start_time = 0.5,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					}
				}
			},
			light_attack_stab = {
				damage_window_start = 0.25,
				range_mod = 1.2,
				kind = "sweep",
				first_person_hit_anim = "shake_hit",
				no_damage_impact_sound_event = "fire_hit_armour",
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				damage_profile = "light_slashing_smiter_stab",
				hit_effect = "melee_hit_sword_1h",
				damage_window_end = 0.4,
				impact_sound_event = "fire_hit",
				charge_value = "light_attack",
				anim_end_event = "attack_finished",
				dedicated_target_range = 2.5,
				anim_event = "attack_swing_stab",
				hit_stop_anim = "attack_hit",
				total_time = 2.1,
				anim_end_event_condition_func = function(arg_10_0, arg_10_1)
					return arg_10_1 ~= "new_interupting_action" and arg_10_1 ~= "action_complete"
				end,
				anim_time_scale = var_0_1 * 1.25,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.7,
						end_time = 0.5,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_one",
						end_time = 1.2,
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.55,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					}
				}
			},
			light_attack_bopp = {
				damage_window_start = 0.38,
				range_mod = 1.15,
				kind = "sweep",
				first_person_hit_anim = "shake_hit",
				no_damage_impact_sound_event = "slashing_hit_armour",
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				damage_profile = "light_slashing_linesman",
				hit_effect = "melee_hit_sword_1h",
				damage_window_end = 0.5,
				impact_sound_event = "slashing_hit",
				charge_value = "light_attack",
				anim_end_event = "attack_finished",
				dedicated_target_range = 2.5,
				anim_event = "attack_swing_left_diagonal",
				hit_stop_anim = "attack_hit",
				total_time = 2.1,
				anim_end_event_condition_func = function(arg_11_0, arg_11_1)
					return arg_11_1 ~= "new_interupting_action" and arg_11_1 ~= "action_complete"
				end,
				anim_time_scale = var_0_1 * 1.4,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.7,
						end_time = 0.5,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_one",
						release_required = "action_one_hold",
						end_time = 1.2,
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_wield",
						input = "action_wield"
					}
				},
				enter_function = function(arg_12_0, arg_12_1)
					return arg_12_1:reset_release_input()
				end
			},
			push = {
				damage_window_start = 0.05,
				anim_end_event = "attack_finished",
				outer_push_angle = 180,
				kind = "push_stagger",
				damage_profile_outer = "light_push",
				weapon_action_hand = "right",
				push_angle = 100,
				hit_effect = "melee_hit_sword_1h",
				damage_window_end = 0.2,
				impact_sound_event = "slashing_hit",
				charge_value = "action_push",
				no_damage_impact_sound_event = "slashing_hit_armour",
				dedicated_target_range = 2,
				anim_event = "attack_push",
				damage_profile_inner = "medium_push",
				total_time = 0.8,
				anim_end_event_condition_func = function(arg_13_0, arg_13_1)
					return arg_13_1 ~= "new_interupting_action" and arg_13_1 ~= "action_complete"
				end,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 1.25,
						end_time = 0.2,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.3,
						action = "action_one",
						release_required = "action_two_hold",
						doubleclick_window = 0,
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.3,
						action = "action_one",
						release_required = "action_two_hold",
						doubleclick_window = 0,
						input = "action_one_hold"
					},
					{
						sub_action = "light_attack_bopp",
						start_time = 0.2,
						action = "action_one",
						doubleclick_window = 0,
						end_time = 0.8,
						input = "action_one_hold",
						hold_required = {
							"action_two_hold",
							"action_one_hold"
						}
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_two",
						send_buffer = true,
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					}
				},
				push_radius = var_0_0,
				chain_condition_func = function(arg_14_0, arg_14_1)
					return not ScriptUnit.extension(arg_14_0, "status_system"):fatigued()
				end
			}
		},
		action_two = {
			default = {
				cooldown = 0.15,
				minimum_hold_time = 0.2,
				anim_end_event = "parry_finished",
				kind = "block",
				hold_input = "action_two_hold",
				anim_event = "parry_pose",
				anim_end_event_condition_func = function(arg_15_0, arg_15_1)
					return arg_15_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				enter_function = function(arg_16_0, arg_16_1, arg_16_2)
					return arg_16_1:reset_release_input_with_delay(arg_16_2)
				end,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.8,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "push",
						start_time = 0.2,
						action = "action_one",
						doubleclick_window = 0,
						input = "action_one",
						hold_required = {
							"action_two_hold"
						}
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_one",
						release_required = "action_two_hold",
						doubleclick_window = 0,
						input = "action_one"
					}
				}
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	}
}

var_0_2.right_hand_unit = "units/weapons/player/wpn_empire_short_sword/wpn_empire_short_sword"
var_0_2.right_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right
var_0_2.display_unit = "units/weapons/weapon_display/display_1h_weapon"
var_0_2.wield_anim = "to_1h_weapon_spells"
var_0_2.state_machine = "units/beings/player/first_person_base/state_machines/melee/1h_weapon_spells"
var_0_2.buff_type = "MELEE_1H"
var_0_2.weapon_type = "SWORD_1H"
var_0_2.max_fatigue_points = 6
var_0_2.dodge_count = 3
var_0_2.block_angle = 90
var_0_2.outer_block_angle = 360
var_0_2.block_fatigue_point_multiplier = 0.5
var_0_2.outer_block_fatigue_point_multiplier = 2
var_0_2.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
var_0_2.attack_meta_data = {
	tap_attack = {
		arc = 1
	},
	hold_attack = {
		arc = 2
	}
}
var_0_2.aim_assist_settings = {
	max_range = 5,
	no_aim_input_multiplier = 0,
	base_multiplier = 0.025,
	effective_max_range = 3,
	breed_scalars = {
		skaven_storm_vermin = 0.25,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}
var_0_2.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 1,
		[DamageTypes.CLEAVE] = 4,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 0,
		[DamageTypes.DAMAGE] = 2
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 2,
		[DamageTypes.CLEAVE] = 7,
		[DamageTypes.SPEED] = 2,
		[DamageTypes.STAGGER] = 4,
		[DamageTypes.DAMAGE] = 2
	}
}
var_0_2.tooltip_keywords = {
	"weapon_keyword_wide_sweeps",
	"weapon_keyword_crowd_control",
	"weapon_keyword_damage_over_time"
}
var_0_2.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "light_attack_left"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "heavy_attack_spell"
	}
}
var_0_2.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	push = {
		action_name = "action_one",
		sub_action_name = "push"
	}
}
var_0_2.wwise_dep_right_hand = {
	"wwise/one_handed_swords"
}

return {
	flaming_sword_spell_template_1 = var_0_2
}
