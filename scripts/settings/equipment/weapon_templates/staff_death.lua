-- chunkname: @scripts/settings/equipment/weapon_templates/staff_death.lua

local var_0_0 = {}
local var_0_1 = {
	apply_recoil = true,
	is_spell = true,
	charge_value = "light_attack",
	kind = "charged_projectile",
	fire_time = 0.18,
	fire_sound_on_husk = false,
	do_not_validate_with_hold = true,
	aim_assist_max_ramp_multiplier = 0.8,
	aim_assist_ramp_decay_delay = 0.3,
	hit_effect = "fireball_impact",
	overcharge_type = "fireball_basic",
	alert_sound_range_fire = 12,
	fire_sound_event = "weapon_sienna_necro_staff_cast_projectile",
	speed = 5000,
	chain_sound_event = "weapon_sienna_necro_staff_projectile_chain",
	aim_assist_ramp_multiplier = 0.4,
	alert_sound_range_hit = 2,
	total_time = 1.4,
	buff_data = {
		{
			start_time = 0.1,
			external_multiplier = 0.8,
			end_time = 0.4,
			buff_name = "planted_fast_decrease_movement"
		}
	},
	recoil_settings = {
		horizontal_climb = -0.15,
		restore_duration = 0.8,
		vertical_climb = 0.05,
		climb_duration = 0.1,
		climb_function = math.easeInCubic,
		restore_function = math.ease_out_quad
	},
	enter_function = function (arg_1_0, arg_1_1)
		arg_1_1:clear_input_buffer()

		return arg_1_1:reset_release_input()
	end,
	projectile_info = Projectiles.bw_necromancy_staff,
	impact_data = {
		damage_profile = "death_staff_curse"
	},
	timed_data = {
		life_time = 1.5
	},
	chain_hit_settings = {
		chain_distance = 5,
		chain_delay = 0.5,
		target_selection_delay = 0.15,
		damage_profile = "death_staff_curse",
		max_chain_count = 2
	}
}

var_0_0.actions = {
	action_one = {
		default = table.merge({
			anim_event = "chain_attack",
			weapon_action_hand = "left",
			allowed_chain_actions = {
				{
					sub_action = "default_02",
					start_time = 0.7,
					action = "action_one",
					hold_allowed = true,
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_two",
					hold_allowed = true,
					input = "action_two"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.4,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			start_offset = {
				min = {
					0,
					0,
					0
				},
				max = {
					0,
					0,
					0
				}
			},
			curve_offset = {
				min = {
					0.5,
					0,
					0
				},
				max = {
					0,
					0,
					0
				}
			},
			fire_pos_rot = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = Unit.node(arg_2_1, "j_leftweaponattach")
				local var_2_1 = Unit.world_position(arg_2_1, var_2_0)
				local var_2_2 = Unit.local_position(arg_2_1, 0)
				local var_2_3 = World.physics_world(arg_2_4)
				local var_2_4 = Quaternion.forward(Unit.local_rotation(arg_2_1, 0))
				local var_2_5 = Managers.state.side.side_by_unit[arg_2_3]
				local var_2_6 = WeaponHelper:look_at_enemy_or_static_position(var_2_3, var_2_2, var_2_4, var_2_5, 0.15, 100)
				local var_2_7 = Quaternion.look(var_2_6 - var_2_1, Vector3.up())

				return var_2_1, var_2_7
			end
		}, var_0_1),
		default_02 = table.merge({
			anim_event = "chain_attack_02",
			weapon_action_hand = "right",
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.7,
					action = "action_one",
					hold_allowed = true,
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_two",
					hold_allowed = true,
					input = "action_two"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.4,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			start_offset = {
				min = {
					0,
					0,
					0
				},
				max = {
					0,
					0,
					0
				}
			},
			curve_offset = {
				min = {
					-0.5,
					0,
					0
				},
				max = {
					0,
					0,
					0
				}
			},
			fire_pos_rot = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = World.physics_world(arg_3_4)
				local var_3_1 = Unit.world_position(arg_3_2, 0)
				local var_3_2 = Unit.local_position(arg_3_1, 0)
				local var_3_3 = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
				local var_3_4 = Managers.state.side.side_by_unit[arg_3_3]
				local var_3_5 = WeaponHelper:look_at_enemy_or_static_position(var_3_0, var_3_2, var_3_3, var_3_4, 0.15, 100)
				local var_3_6 = Quaternion.look(var_3_5 - var_3_1, Vector3.up())

				return var_3_1, var_3_6
			end
		}, var_0_1),
		soul_rip = {
			lethal_fx_name = "fx/wpnfx_staff_death/rip_soul",
			anim_end_event = "soul_rip_exit",
			is_spell = true,
			last_damage_step_fx_name = "fx/wpnfx_staff_death/rip_burst",
			kind = "damage_target",
			fire_at_gaze_setting = "tobii_fire_at_gaze_fireball",
			target_node = "torso",
			charge_sound_stop_event = "Stop_weapon_necro_staff_suck",
			weapon_action_hand = "left",
			last_damage_step_sound_event = "Play_weapon_necro_staff_suck_pop",
			head_fx_name = "fx/wpnfx_staff_death/rip_temp_directional",
			charge_fx_name = "fx/wpnfx_staff_death/rip_channel",
			weapon_fx_name = "fx/wpnfx_staff_death/rip_temp_directional",
			hold_input = "action_one_hold",
			anim_event = "soul_rip_attack",
			charge_sound_name = "Play_weapon_necro_staff_suck",
			total_time = math.huge,
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.4,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.6,
					action = "action_one",
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.4,
					action = "action_two",
					input = "action_two"
				},
				{
					sub_action = "default",
					start_time = 0.2,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			buff_data = {
				{
					start_time = 0,
					external_multiplier = 0.6,
					buff_name = "planted_fast_decrease_movement"
				}
			},
			enter_function = function (arg_4_0, arg_4_1)
				arg_4_1:clear_input_buffer()

				return arg_4_1:reset_release_input()
			end,
			damage_steps = {
				{
					repeat_count = 4,
					damage_profile = "staff_suck_damage",
					start_delay = 0.25,
					repeat_delay = 0.2,
					overcharge_amount = 1
				},
				{
					repeat_count = 1,
					damage_profile = "soul_rip",
					proc_buffs = true,
					start_delay = 0.5,
					repeat_delay = 0,
					can_crit = true,
					overcharge_amount = 10
				}
			},
			force_action_on_complete = {
				action_name = "action_one",
				sub_action_name = "soul_rip_cooldown"
			},
			chain_condition_func = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				if arg_5_3 then
					local var_5_0 = arg_5_3:get_current_action()

					return var_5_0 and ALIVE[var_5_0.target]
				end

				return false
			end
		},
		soul_rip_cooldown = {
			anim_event = "soul_rip_pop",
			anim_end_event = "soul_rip_exit",
			kind = "dummy",
			total_time = 1.5,
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.2,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.52,
					action = "action_one",
					hold_allowed = true,
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.48,
					action = "action_two",
					hold_allowed = true,
					input = "action_two"
				},
				{
					sub_action = "default",
					start_time = 0,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			enter_function = function (arg_6_0, arg_6_1)
				arg_6_1:clear_input_buffer()

				return arg_6_1:reset_release_input()
			end
		}
	},
	action_two = {
		default = {
			hold_input = "action_two_hold",
			default_zoom = "zoom_in_trueflight",
			weapon_action_hand = "left",
			kind = "true_flight_bow_aim",
			num_projectiles = 1,
			aim_sticky_target_size = 1,
			aim_obstructed_by_walls = true,
			overcharge_interval = 0.3,
			target_break_size = 5,
			aim_time = 0,
			ignore_bosses = false,
			minimum_hold_time = 0.2,
			charge_sound_name = "Play_weapon_necro_staff_target",
			overcharge_type = "charging",
			anim_end_event = "soul_rip_exit",
			aim_sticky_time = 0,
			not_wield_previous = true,
			uninterruptible = true,
			anim_event = "soul_rip_start",
			allow_hold_toggle = true,
			anim_end_event_condition_func = function (arg_7_0, arg_7_1)
				return arg_7_1 ~= "new_interupting_action"
			end,
			total_time = math.huge,
			buff_data = {
				{
					start_time = 0,
					external_multiplier = 0.7,
					buff_name = "planted_fast_decrease_movement"
				}
			},
			zoom_thresholds = {
				"zoom_in_trueflight",
				"zoom_in"
			},
			zoom_condition_function = function ()
				return true
			end,
			prioritized_breeds = {
				skaven_ratling_gunner = 1,
				chaos_raider = 1,
				beastmen_standard_bearer = 1,
				beastmen_bestigor = 1,
				skaven_poison_wind_globadier = 1,
				skaven_warpfire_thrower = 1,
				skaven_plague_monk = 1,
				skaven_gutter_runner = 1,
				chaos_berzerker = 1,
				chaos_vortex_sorcerer = 1,
				skaven_pack_master = 1,
				chaos_warrior = 1,
				chaos_tether_sorcerer = 1,
				chaos_corruptor_sorcerer = 1,
				skaven_storm_vermin_commander = 1,
				skaven_storm_vermin = 1,
				skaven_storm_vermin_with_shield = 1
			},
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.2,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.2,
					action = "weapon_reload",
					input = "weapon_reload"
				},
				{
					sub_action = "soul_rip",
					start_time = 0.2,
					action = "action_one",
					input = "action_one"
				},
				{
					sub_action = "soul_rip",
					start_time = 0.2,
					action = "action_one",
					input = "action_one_hold"
				}
			}
		}
	},
	weapon_reload = {
		default = {
			charge_sound_stop_event = "stop_player_combat_weapon_staff_cooldown",
			hold_input = "weapon_reload_hold",
			charge_effect_material_variable_name = "intensity",
			kind = "charge",
			charge_sound_parameter_name = "drakegun_charge_fire",
			do_not_validate_with_hold = true,
			charge_effect_material_name = "Fire",
			minimum_hold_time = 0.5,
			vent_overcharge = true,
			anim_end_event = "cooldown_end",
			charge_sound_switch = "projectile_charge_sound",
			charge_time = 3,
			uninterruptible = true,
			anim_event = "cooldown_start",
			charge_sound_name = "player_combat_weapon_staff_cooldown",
			anim_end_event_condition_func = function (arg_9_0, arg_9_1)
				return arg_9_1 ~= "new_interupting_action"
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
			enter_function = function (arg_10_0, arg_10_1)
				arg_10_1:reset_release_input()
				arg_10_1:clear_input_buffer()
			end,
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.2,
					action = "action_wield",
					input = "action_wield"
				}
			},
			condition_func = function (arg_11_0, arg_11_1)
				return ScriptUnit.extension(arg_11_0, "overcharge_system"):get_overcharge_value() ~= 0
			end,
			chain_condition_func = function (arg_12_0, arg_12_1)
				return ScriptUnit.extension(arg_12_0, "overcharge_system"):get_overcharge_value() ~= 0
			end
		}
	},
	action_inspect = ActionTemplates.action_inspect,
	action_wield = ActionTemplates.wield
}
var_0_0.default_spread_template = "spear"
var_0_0.overcharge_data = {
	explosion_template = "overcharge_explosion_brw",
	overcharge_threshold = 10,
	hit_overcharge_threshold_sound = "ui_special_attack_ready",
	time_until_overcharge_decreases = 0.5,
	overcharge_value_decrease_rate = 1
}
var_0_0.attack_meta_data = {
	max_range = 50,
	charged_attack_action_name = "shoot_charged",
	can_charge_shot = true,
	minimum_charge_time = 0.21,
	fire_input = "fire_hold",
	aim_at_node = "j_head",
	obstruction_fuzzyness_range_charged = 6,
	charge_when_outside_max_range_charged = false,
	aim_at_node_charged = "j_spine1",
	max_range_charged = 6,
	ignore_enemies_for_obstruction_charged = false,
	charge_when_obstructed = true,
	ignore_enemies_for_obstruction = false,
	obstruction_fuzzyness_range = 1,
	aim_data = {
		min_radius_pseudo_random_c = 0.94737,
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
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Berserker, BreedCategory.Special, BreedCategory.Armored)
}
var_0_0.aim_assist_settings = {
	max_range = 50,
	no_aim_input_multiplier = 0,
	always_auto_aim = true,
	base_multiplier = 0,
	target_node = "j_spine1",
	effective_max_range = 30,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}
var_0_0.right_hand_unit = "units/weapons/player/wpn_brw_skullstaff/wpn_brw_skullstaff"
var_0_0.right_hand_attachment_node_linking = AttachmentNodeLinking.spear_staff
var_0_0.left_hand_unit = "units/weapons/player/wpn_invisible_weapon"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.necro_skull
var_0_0.display_unit = "units/weapons/weapon_display/display_staff"
var_0_0.wield_anim = "to_necro_staff"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/ranged/necro_staff"
var_0_0.crosshair_style = "arrows"
var_0_0.buff_type = "RANGED"
var_0_0.weapon_type = "FIRE_STAFF"
var_0_0.destroy_indexed_projectiles = true
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_0.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 2,
		[DamageTypes.CLEAVE] = 3,
		[DamageTypes.SPEED] = 4,
		[DamageTypes.STAGGER] = 5,
		[DamageTypes.DAMAGE] = 2
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 7,
		[DamageTypes.CLEAVE] = 1,
		[DamageTypes.SPEED] = 2,
		[DamageTypes.STAGGER] = 4,
		[DamageTypes.DAMAGE] = 7
	}
}
var_0_0.tooltip_keywords = {
	"weapon_keyword_sniper",
	"weapon_keyword_crowd_control",
	"weapon_keyword_damage_over_time"
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
	"wwise/staff",
	"wwise/flamethrower"
}

local var_0_2 = table.clone(var_0_0)

var_0_2.actions.action_one.soul_rip.damage_steps = {
	{
		repeat_count = 4,
		damage_profile = "staff_suck_damage_vs",
		start_delay = 0.25,
		repeat_delay = 0.2,
		overcharge_amount = 1
	},
	{
		repeat_count = 1,
		start_delay = 0.5,
		repeat_delay = 0,
		proc_buffs = true,
		damage_profile = "soul_rip_vs",
		overcharge_amount_player_target = 35,
		can_crit = true,
		overcharge_amount = 10
	}
}

return {
	staff_death = table.clone(var_0_0),
	staff_death_vs = table.clone(var_0_2)
}
