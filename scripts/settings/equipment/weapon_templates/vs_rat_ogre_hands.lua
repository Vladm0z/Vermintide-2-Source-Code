-- chunkname: @scripts/settings/equipment/weapon_templates/vs_rat_ogre_hands.lua

local var_0_0 = "dark_pact_action_one"
local var_0_1 = "dark_pact_action_one_release"
local var_0_2 = "dark_pact_action_one_hold"
local var_0_3 = 2
local var_0_4 = 0.9
local var_0_5 = {}
local var_0_6 = {
	charge = {
		{
			start_time = 0,
			external_multiplier = 0.2,
			buff_name = "planted_decrease_movement"
		}
	},
	light_attack = {
		{
			start_time = 0,
			external_multiplier = 0.8,
			end_time = 0.6,
			buff_name = "planted_decrease_movement"
		},
		{
			start_time = 1.3,
			buff_name = "planted_return_to_normal_walk_movement"
		}
	},
	heavy_attack = {
		{
			start_time = 0,
			external_multiplier = 1,
			end_time = 0.3,
			buff_name = "planted_fast_decrease_movement"
		},
		{
			start_time = 0.3,
			external_multiplier = 0.4,
			end_time = 0.6,
			buff_name = "planted_decrease_movement"
		},
		{
			start_time = 0.6,
			external_multiplier = 0.001,
			end_time = 1,
			buff_name = "planted_decrease_movement"
		},
		{
			start_time = 1,
			buff_name = "planted_return_to_normal_walk_movement"
		},
		{
			start_time = 0,
			external_value = 0.1,
			end_time = 0.8,
			buff_name = "set_rotation_limit"
		},
		{
			start_time = 0,
			external_multiplier = 0.5,
			end_time = 0.8,
			buff_name = "planted_decrease_rotation_speed"
		},
		{
			start_time = 0.8,
			external_multiplier = 0.75,
			end_time = 1,
			buff_name = "planted_decrease_rotation_speed"
		}
	}
}
local var_0_7 = {
	frenzy = {
		catapult_players = false,
		catapult = false,
		player_knockback_speed = 9,
		player_knockback_speed_blocked = 9
	},
	slam = {
		catapult_players = false,
		catapult = false,
		player_knockback_speed = 10,
		player_knockback_speed_blocked = 14
	}
}

var_0_5.actions = {
	[var_0_0] = {
		default = {
			disallow_ghost_mode = true,
			anim_end_event = "attack_finished",
			kind = "melee_start",
			uninterruptible = true,
			anim_event = "attack_ogre_slam_charge",
			anim_end_event_condition_func = function(arg_1_0, arg_1_1)
				return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
			end,
			condition_func = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				local var_2_0 = ScriptUnit.has_extension(arg_2_0, "ghost_mode_system"):is_in_ghost_mode()
				local var_2_1 = ScriptUnit.has_extension(arg_2_0, "career_system"):get_activated_ability_data(1)

				if var_2_1.is_priming then
					arg_2_1:clear_input_buffer()
					arg_2_1:reset_release_input()
				end

				return not var_2_0 and not var_2_1.is_priming
			end,
			total_time = math.huge,
			anim_time_scale = var_0_4 * 1.15,
			attack_hold_input = var_0_2,
			buff_data = var_0_6.charge,
			allowed_chain_actions = {
				{
					sub_action = "attack_swing_right",
					start_time = 0,
					end_time = 0.4,
					input = var_0_1,
					action = var_0_0
				},
				{
					sub_action = "attack_slam",
					start_time = 0.8,
					input = var_0_1,
					action = var_0_0
				},
				{
					start_time = 0.4,
					blocker = true,
					end_time = 1.5,
					input = var_0_2
				},
				{
					sub_action = "attack_slam",
					start_time = 1.5,
					auto_chain = true,
					action = var_0_0
				},
				{
					sub_action = "default",
					start_time = 0,
					action = "action_wield",
					input = "action_wield"
				}
			}
		},
		default_2 = {
			disallow_ghost_mode = true,
			anim_end_event = "attack_finished",
			kind = "melee_start",
			uninterruptible = true,
			anim_event = "attack_ogre_slam_charge",
			anim_end_event_condition_func = function(arg_3_0, arg_3_1)
				return arg_3_1 ~= "new_interupting_action" and arg_3_1 ~= "action_complete"
			end,
			total_time = math.huge,
			anim_time_scale = var_0_4 * 1.15,
			attack_hold_input = var_0_2,
			buff_data = var_0_6.charge,
			allowed_chain_actions = {
				{
					sub_action = "attack_swing_left",
					start_time = 0,
					end_time = 0.4,
					input = var_0_1,
					action = var_0_0
				},
				{
					sub_action = "attack_slam",
					start_time = 0.8,
					input = var_0_1,
					action = var_0_0
				},
				{
					start_time = 0.4,
					blocker = true,
					end_time = 1.5,
					input = var_0_2
				},
				{
					sub_action = "attack_slam",
					start_time = 1.5,
					auto_chain = true,
					action = var_0_0
				},
				{
					sub_action = "default",
					start_time = 0,
					action = "action_wield",
					input = "action_wield"
				}
			}
		},
		attack_swing_right = {
			damage_window_start = 0.59,
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_anim = "shake_hit",
			range_mod = 1.2,
			width_mod = 50,
			hit_effect = "vs_rat_ogre_light",
			weapon_action_hand = "right",
			no_damage_impact_sound_event = "blunt_hit_armour",
			damage_profile = "rat_ogre_light_1",
			use_precision_sweep = false,
			damage_window_end = 0.7,
			impact_sound_event = "blunt_hit",
			aim_assist_ramp_multiplier = 0.4,
			disallow_ghost_mode = true,
			aim_assist_max_ramp_multiplier = 0.8,
			aim_assist_ramp_decay_delay = 0,
			dedicated_target_range = 2,
			uninterruptible = true,
			anim_event = "attack_swing_right",
			total_time = 2.17,
			anim_end_event_condition_func = function(arg_4_0, arg_4_1)
				return arg_4_1 ~= "new_interupting_action" and arg_4_1 ~= "action_complete"
			end,
			buff_data = var_0_6.light_attack,
			anim_time_scale = var_0_4 * 1.15,
			sweep_rotation_offset = {
				roll = math.pi * 0.5
			},
			knockback_data = var_0_7.frenzy,
			allowed_chain_actions = {
				{
					sub_action = "default_2",
					start_time = 0.8,
					end_time = 1.8,
					input = var_0_0,
					action = var_0_0
				},
				{
					sub_action = "default",
					start_time = 1.8,
					input = var_0_2,
					action = var_0_0
				}
			}
		},
		attack_swing_left = {
			damage_window_start = 0.85,
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_anim = "shake_hit",
			range_mod = 1.2,
			width_mod = 50,
			hit_effect = "vs_rat_ogre_light",
			weapon_action_hand = "left",
			no_damage_impact_sound_event = "blunt_hit_armour",
			additional_critical_strike_chance = 0.1,
			use_precision_sweep = false,
			damage_window_end = 1,
			impact_sound_event = "blunt_hit",
			charge_value = "action_push",
			disallow_ghost_mode = true,
			damage_profile = "rat_ogre_light_2",
			dedicated_target_range = 2,
			uninterruptible = true,
			anim_event = "attack_swing_left",
			total_time = 2.17,
			anim_end_event_condition_func = function(arg_5_0, arg_5_1)
				return arg_5_1 ~= "new_interupting_action" and arg_5_1 ~= "action_complete"
			end,
			buff_data = var_0_6.light_attack,
			anim_time_scale = var_0_4 * 1.15,
			sweep_rotation_offset = {
				roll = math.pi * 0.5
			},
			knockback_data = var_0_7.frenzy,
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 1.4,
					input = var_0_0,
					action = var_0_0
				},
				{
					sub_action = "default",
					start_time = 1.4,
					input = var_0_2,
					action = var_0_0,
					release_required = var_0_2
				}
			}
		},
		attack_slam = {
			damage_window_start = 0.1,
			range_mod = 0.85,
			disallow_ghost_mode = true,
			kind = "sweep",
			first_person_hit_anim = "shake_hit",
			width_mod = 100,
			hit_stop_anim = "attack_hit",
			hit_effect = "vs_rat_ogre_heavy",
			weapon_action_hand = "both",
			no_damage_impact_sound_event = "blunt_hit_armour",
			damage_window_end = 0.225,
			impact_sound_event = "blunt_hit",
			anim_end_event = "attack_finished",
			additional_critical_strike_chance = 0.1,
			use_precision_sweep = false,
			damage_profile_right = "rat_ogre_slam_right",
			dedicated_target_range = 2,
			damage_profile_left = "rat_ogre_slam_left",
			uninterruptible = true,
			anim_event = "attack_slam",
			height_mod = 5,
			total_time = 1.33,
			anim_end_event_condition_func = function(arg_6_0, arg_6_1)
				return arg_6_1 ~= "new_interupting_action" and arg_6_1 ~= "action_complete"
			end,
			anim_time_scale = var_0_4 * 1.15,
			lunge_settings = {
				initial_speed = 20,
				duration = 0.32,
				falloff_to_speed = 5
			},
			sweep_rotation_offset = {
				roll = math.pi * 0.5
			},
			knockback_data = var_0_7.slam,
			buff_data = var_0_6.heavy_attack,
			allowed_chain_actions = {},
			enter_function = function(arg_7_0, arg_7_1)
				return arg_7_1:reset_release_input()
			end
		}
	},
	action_inspect = ActionTemplates.action_inspect,
	action_wield = ActionTemplates.wield
}
var_0_5.weapon_sway_settings = {
	camera_look_sensitivity = 1,
	sway_range = 1,
	recetner_dampening = 1,
	look_sensitivity = 0.5,
	recenter_max_vel = 5,
	recenter_acc = 5,
	lerp_speed = math.huge
}
var_0_5.left_hand_unit = "units/weapons/player/wpn_invisible_weapon"
var_0_5.right_hand_unit = "units/weapons/player/wpn_invisible_weapon"
var_0_5.right_hand_attachment_node_linking = AttachmentNodeLinking.vs_rat_ogre_hands.right
var_0_5.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_rat_ogre_hands.left
var_0_5.display_unit = "units/weapons/weapon_display/display_1h_axes"
var_0_5.wield_anim = "to_1h_axe"
var_0_5.buff_type = "MELEE_1H"
var_0_5.weapon_type = "AXE_1H"
var_0_5.max_fatigue_points = 6
var_0_5.buffs = {}
var_0_5.attack_meta_data = {
	tap_attack = {
		arc = 0
	},
	hold_attack = {
		arc = 0
	}
}
var_0_5.aim_assist_settings = {
	max_range = 5,
	no_aim_input_multiplier = 0,
	vertical_only = true,
	base_multiplier = 0,
	effective_max_range = 4,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 0.5,
		skaven_slave = 0.5
	}
}
var_0_5.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 4,
		[DamageTypes.CLEAVE] = 1,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 5
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 0,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 4
	}
}
var_0_5.tooltip_keywords = {}
var_0_5.tooltip_compare = {
	light = {
		sub_action_name = "light_attack_left",
		action_name = var_0_0
	},
	heavy = {
		sub_action_name = "heavy_attack_left",
		action_name = var_0_0
	}
}
var_0_5.tooltip_detail = {
	light = {
		sub_action_name = "default",
		action_name = var_0_0
	},
	heavy = {
		sub_action_name = "default",
		action_name = var_0_0
	}
}
var_0_5.wwise_dep_right_hand = {
	"wwise/one_handed_axes"
}

return {
	vs_rat_ogre_hands = var_0_5
}
