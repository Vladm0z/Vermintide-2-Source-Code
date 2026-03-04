-- chunkname: @scripts/settings/equipment/weapon_templates/drakegun.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				particle_effect_flames = "fx/wpnfx_flamethrower_1p_01",
				anim_event = "attack_shoot",
				fire_sound_on_husk = true,
				fire_time = 0.1,
				kind = "flamethrower",
				no_headshot_sound = true,
				area_damage = true,
				stop_fire_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot",
				alert_sound_range_fire = 12,
				overcharge_interval = 0.2,
				alert_sound_range_hit = 2,
				damage_profile = "flamethrower_spray",
				damage_interval = 0.2,
				dot_check = 0.97,
				hit_zone_override = "torso",
				minimum_hold_time = 2,
				damage_window_end = 0,
				damage_window_start = 0.1,
				anim_end_event = "attack_finished",
				fire_sound_event = "Play_player_combat_weapon_drakegun_flamethrower_shoot",
				fire_stop_time = 0.3,
				fx_node = "fx_muzzle",
				particle_effect_flames_3p = "fx/wpnfx_flamethrower_01",
				hit_effect = "flamethrower",
				spray_range = 7,
				ranged_attack = true,
				overcharge_type = "spear_3",
				charge_value = "light_attack",
				hold_input = "action_one_hold",
				particle_effect_impact = "fx/wpnfx_flamethrower_hit_01",
				total_time = 1.3,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.5,
						end_time = 0.25,
						buff_name = "planted_fast_decrease_movement"
					},
					{
						start_time = 0.25,
						external_multiplier = 1,
						buff_name = "planted_charging_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.9,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 1.1,
						action = "action_one",
						release_required = "action_one_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 1.5,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.9,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function (arg_1_0, arg_1_1)
					arg_1_1:clear_input_buffer()

					return arg_1_1:reset_release_input()
				end
			},
			shoot_charged = {
				particle_effect_flames = "fx/wpnfx_flamethrower_1p_01",
				stop_fire_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot",
				charge_value = "light_attack",
				kind = "flamethrower",
				alert_sound_range_hit = 2,
				ranged_attack = true,
				area_damage = true,
				charge_fuel_time_multiplier = 5,
				overcharge_interval = 0.25,
				particle_effect_flames_3p = "fx/wpnfx_flamethrower_01",
				damage_interval = 0.25,
				hit_effect = "flamethrower",
				no_headshot_sound = true,
				minimum_hold_time = 0.75,
				damage_window_end = 0,
				overcharge_type = "drakegun_charging",
				alert_sound_range_fire = 12,
				fire_time = 0.15,
				fire_sound_on_husk = true,
				fire_sound_event = "Play_player_combat_weapon_drakegun_flamethrower_shoot_charged",
				initial_damage_profile = "flamethrower_initial",
				anim_event = "attack_shoot_charged",
				anim_end_event = "attack_finished",
				damage_window_start = 0.1,
				hold_input = "action_one_hold",
				damage_profile = "flamethrower",
				fx_node = "fx_muzzle",
				particle_effect_impact = "fx/wpnfx_flamethrower_hit_01",
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.25,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.7,
						action = "action_two",
						release_required = "action_two_hold",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.3,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function (arg_2_0, arg_2_1)
					arg_2_1:clear_input_buffer()

					return arg_2_1:reset_release_input()
				end
			}
		},
		action_two = {
			default = {
				charge_sound_stop_event = "player_combat_weapon_drakegun_charge_down",
				anim_end_event = "attack_finished",
				charge_ready_sound_event = "weapon_drakegun_charge_ready",
				charge_effect_material_variable_name = "intensity",
				kind = "charge",
				remove_overcharge_on_interrupt = true,
				overcharge_interval = 0.2,
				charge_effect_material_name = "Fire",
				minimum_hold_time = 0.2,
				overcharge_type = "flamethrower",
				charge_sound_switch = "projectile_charge_sound",
				charge_time = 2,
				hold_input = "action_two_hold",
				anim_event = "attack_charge",
				charge_sound_name = "player_combat_weapon_drakegun_charge",
				anim_end_event_condition_func = function (arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.9,
						end_time = 0.3,
						buff_name = "planted_fast_decrease_movement"
					},
					{
						start_time = 0.3,
						external_multiplier = 0.8,
						end_time = 0.7,
						buff_name = "planted_fast_decrease_movement"
					},
					{
						start_time = 0.7,
						external_multiplier = 1,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "shoot_charged",
						start_time = 0.45,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				}
			}
		},
		weapon_reload = {
			default = {
				charge_sound_stop_event = "stop_weapon_drakegun_cooldown_loop",
				anim_end_event = "cooldown_end",
				uninterruptible = true,
				kind = "charge",
				do_not_validate_with_hold = true,
				minimum_hold_time = 0.5,
				vent_overcharge = true,
				charge_time = 3,
				hold_input = "weapon_reload_hold",
				anim_event = "cooldown_start",
				charge_sound_name = "weapon_drakegun_cooldown_loop",
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.2,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = function (arg_5_0, arg_5_1)
					return ScriptUnit.extension(arg_5_0, "overcharge_system"):get_overcharge_value() ~= 0
				end,
				chain_condition_func = function (arg_6_0, arg_6_1)
					return ScriptUnit.extension(arg_6_0, "overcharge_system"):get_overcharge_value() ~= 0
				end
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	},
	overcharge_data = {
		overcharge_value_decrease_rate = 1,
		overcharge_warning_critical_sound_event = "drakegun_overcharge_warning_critical",
		max_value = 30,
		time_until_overcharge_decreases = 0.5,
		overcharge_warning_low_sound_event = "drakegun_overcharge_warning_low",
		overcharge_threshold = 10,
		overcharge_warning_high_sound_event = "drakegun_overcharge_warning_high",
		explosion_template = "overcharge_explosion_dwarf",
		overcharge_warning_med_sound_event = "drakegun_overcharge_warning_med",
		hit_overcharge_threshold_sound = "ui_special_attack_ready"
	}
}

var_0_0.overcharge_data.critical_overcharge_margin = var_0_0.overcharge_data.max_value * 0.03
var_0_0.attack_meta_data = {
	max_range = 15,
	obstruction_fuzzyness_range_charged = 1,
	always_charge_before_firing = false,
	charged_attack_action_name = "shoot_charged",
	aim_at_node = "j_spine1",
	can_charge_shot = true,
	minimum_charge_time = 0.1,
	charge_when_obstructed = false,
	charge_when_outside_max_range = false,
	obstruction_fuzzyness_range = 1,
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Berserker, BreedCategory.Shielded, BreedCategory.Armored, BreedCategory.Special)
}
var_0_0.default_spread_template = "drakegun"
var_0_0.right_hand_unit = ""
var_0_0.right_hand_attachment_node_linking = AttachmentNodeLinking.drakegun
var_0_0.display_unit = "units/weapons/weapon_display/display_drakegun"
var_0_0.wield_anim = "to_drakegun"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/ranged/drakegun"
var_0_0.crosshair_style = "circle"
var_0_0.buff_type = "RANGED"
var_0_0.weapon_type = "DRAKEFIRE"
var_0_0.dodge_count = 1
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 0.85
	},
	change_dodge_speed = {
		external_optional_multiplier = 0.85
	}
}
var_0_0.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 2,
		[DamageTypes.CLEAVE] = 5,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 5,
		[DamageTypes.DAMAGE] = 1
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 1,
		[DamageTypes.CLEAVE] = 6,
		[DamageTypes.SPEED] = 1,
		[DamageTypes.STAGGER] = 0,
		[DamageTypes.DAMAGE] = 2
	}
}
var_0_0.tooltip_keywords = {
	"weapon_keyword_crowd_control",
	"weapon_keyword_close_range",
	"weapon_keyword_overheat"
}
var_0_0.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "shoot_charged"
	}
}
var_0_0.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "shoot_charged"
	}
}
var_0_0.wwise_dep_right_hand = {
	"wwise/drakegun",
	"wwise/flamethrower"
}

local var_0_1 = table.clone(var_0_0)

var_0_1.actions.action_one.default.damage_profile = "flamethrower_spray_vs"
var_0_1.actions.action_one.default.overcharge_type = "spear_2"
var_0_1.actions.action_one.shoot_charged.damage_profile = "flamethrower_vs"
var_0_1.actions.action_one.shoot_charged.initial_damage_profile = "flamethrower_initial_vs"

return {
	drakegun_template_1 = table.clone(var_0_0),
	drakegun_template_1_vs = table.clone(var_0_1)
}
