-- chunkname: @scripts/settings/equipment/weapon_templates/dr_deus_01.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				unhide_ammo_on_infinite_ammo = true,
				attack_template = "bolt_sniper",
				alert_sound_range_fire = 4,
				kind = "grenade_thrower",
				anim_event_no_ammo_left = "attack_shoot_last",
				alert_sound_range_hit = 10,
				charge_value = "arrow_hit",
				reload_when_out_of_ammo = true,
				aim_assist_max_ramp_multiplier = 1,
				hit_effect = "arrow_impact",
				anim_event_last_ammo = "attack_shoot_last",
				aim_assist_ramp_decay_delay = 0.1,
				ranged_attack = true,
				apply_recoil = true,
				ammo_usage = 1,
				fire_time = 0,
				weapon_action_hand = "left",
				anim_event_infinite_ammo_1p = "attack_shoot_no_reload",
				speed = 2500,
				active_reload_time = 0.25,
				aim_assist_ramp_multiplier = 0.3,
				anim_event = "attack_shoot",
				total_time = 1.2,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 1,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				angular_velocity = {
					10,
					0,
					0
				},
				projectile_info = Projectiles.dr_deus_01,
				impact_data = {
					damage_profile = "dr_deus_01",
					targets = 1,
					aoe = ExplosionTemplates.dr_deus_01
				},
				timed_data = {
					life_time = 3,
					aoe = ExplosionTemplates.dr_deus_01
				},
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.1,
					vertical_climb = 2,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			},
			push = {
				damage_window_start = 0.05,
				push_radius = 3,
				anim_end_event = "attack_finished",
				outer_push_angle = 180,
				kind = "push_stagger",
				no_damage_impact_sound_event = "slashing_hit_armour",
				attack_template = "basic_sweep_push",
				damage_profile_outer = "light_push",
				weapon_action_hand = "left",
				push_angle = 100,
				hit_effect = "melee_hit_hammers_1h",
				damage_window_end = 0.2,
				impact_sound_event = "slashing_hit",
				charge_value = "action_push",
				dedicated_target_range = 2,
				anim_event = "attack_push",
				damage_profile_inner = "medium_push",
				total_time = 0.5,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
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
						start_time = 0.5,
						action = "action_one",
						release_required = "action_two_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 1,
						action = "action_two",
						input = "action_two_hold"
					}
				},
				chain_condition_func = function (arg_2_0, arg_2_1)
					return not ScriptUnit.extension(arg_2_0, "status_system"):fatigued()
				end
			}
		},
		action_two = {
			default = {
				cooldown = 0.15,
				minimum_hold_time = 0.2,
				anim_end_event = "parry_finished",
				kind = "block",
				weapon_action_hand = "left",
				reload_when_out_of_ammo = true,
				hold_input = "action_two_hold",
				anim_event = "parry_pose",
				anim_end_event_condition_func = function (arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				enter_function = function (arg_4_0, arg_4_1, arg_4_2)
					return arg_4_1:reset_release_input_with_delay(arg_4_2)
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
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					}
				},
				reload_when_out_of_ammo_condition_func = function (arg_5_0, arg_5_1)
					return arg_5_1 ~= "new_interupting_action" and arg_5_1 ~= "stunned"
				end
			}
		},
		weapon_reload = ActionTemplates.reload,
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left,
		action_instant_grenade_throw = ActionTemplates.instant_equip_grenade,
		action_instant_heal_self = ActionTemplates.instant_equip_and_heal_self,
		action_instant_heal_other = ActionTemplates.instant_equip_and_heal_other,
		action_instant_drink_potion = ActionTemplates.instant_equip_and_drink_potion,
		action_instant_equip_tome = ActionTemplates.instant_equip_tome,
		action_instant_equip_grimoire = ActionTemplates.instant_equip_grimoire,
		action_instant_equip_grenade = ActionTemplates.instant_equip_grenade_only,
		action_instant_equip_healing_draught = ActionTemplates.instant_equip_and_drink_healing_draught
	},
	ammo_data = {
		max_ammo = 7,
		ammo_per_reload = 1,
		ammo_per_clip = 1,
		play_reload_anim_on_wield_reload = true,
		has_wield_reload_anim = false,
		ammo_hand = "left",
		destroy_when_out_of_ammo = false,
		reload_on_ammo_pickup = true,
		reload_time = 3,
		ammo_unit_attachment_node_linking = AttachmentNodeLinking.dr_deus_01_projectile
	},
	attack_meta_data = {
		max_range = 20,
		aim_at_node = "j_spine1",
		can_charge_shot = false,
		ignore_enemies_for_obstruction = false,
		aim_data = {
			min_radius_pseudo_random_c = 0.3021,
			max_radius_pseudo_random_c = 0.0557,
			min_radius = math.pi / 72,
			max_radius = math.pi / 16
		},
		aim_data_charged = {
			min_radius_pseudo_random_c = 0.0557,
			max_radius_pseudo_random_c = 0.01475,
			min_radius = math.pi / 72,
			max_radius = math.pi / 16
		},
		effective_against = bit.bor(BreedCategory.Berserker, BreedCategory.Armored, BreedCategory.Special, BreedCategory.Shielded, BreedCategory.SuperArmor, BreedCategory.Boss)
	},
	aim_assist_settings = {
		max_range = 50,
		no_aim_input_multiplier = 0.3,
		always_auto_aim = true,
		base_multiplier = 0.1,
		target_node = "j_neck",
		effective_max_range = 40,
		breed_scalars = {
			skaven_storm_vermin = 1.2,
			skaven_clan_rat = 1,
			skaven_slave = 1
		}
	}
}
local var_0_1 = var_0_0.actions.action_one.default

var_0_0.default_loaded_projectile_settings = {
	drop_multiplier = 0.02,
	speed = var_0_1.speed,
	gravity = ProjectileGravitySettings[var_0_1.projectile_info.gravity_settings]
}
var_0_0.default_spread_template = "crossbow"
var_0_0.spread_lerp_speed = 6
var_0_0.left_hand_unit = ""
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.dr_deus_01
var_0_0.display_unit = "units/weapons/weapon_display/display_trollhammer"
var_0_0.wield_anim = "to_dr_deus_01_loaded"
var_0_0.wield_anim_no_ammo = "to_dr_deus_01_noammo"
var_0_0.wield_anim_not_loaded = "to_dr_deus_01"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/ranged/dr_deus_01"
var_0_0.crosshair_style = "projectile"
var_0_0.reload_event = "reload"
var_0_0.buff_type = "RANGED"
var_0_0.weapon_type = "dr_deus_01"
var_0_0.default_projectile_action = var_0_0.actions.action_one.default
var_0_0.max_fatigue_points = 6
var_0_0.dodge_count = 1
var_0_0.block_angle = 90
var_0_0.outer_block_angle = 360
var_0_0.block_fatigue_point_multiplier = 0.5
var_0_0.outer_block_fatigue_point_multiplier = 2
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_0.wwise_dep_left_hand = {
	"wwise/dr_deus_01"
}
var_0_0.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 7,
		[DamageTypes.CLEAVE] = 7,
		[DamageTypes.SPEED] = 0,
		[DamageTypes.STAGGER] = 7,
		[DamageTypes.DAMAGE] = 7
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 0,
		[DamageTypes.CLEAVE] = 7,
		[DamageTypes.SPEED] = 1,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 0
	}
}
var_0_0.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_crowd_control",
	"weapon_keyword_piercing_bolts"
}
var_0_0.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	}
}
var_0_0.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	push = {
		action_name = "action_one",
		sub_action_name = "push"
	}
}

local var_0_2 = table.clone(var_0_0)

var_0_2.actions.action_one.default.impact_data.damage_profile = "dr_deus_01_vs"

return {
	dr_deus_01_template_1 = table.clone(var_0_0),
	dr_deus_01_template_1_vs = table.clone(var_0_2)
}
