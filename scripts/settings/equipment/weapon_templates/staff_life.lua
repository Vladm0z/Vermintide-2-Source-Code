-- chunkname: @scripts/settings/equipment/weapon_templates/staff_life.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = {}
local var_0_2 = 0.9

var_0_1.actions = {
	action_one = {
		default = {
			ammo_usage = 0,
			num_projectiles_per_shot = 1,
			extra_shot_delay = 0.08,
			kind = "rail_gun",
			weapon_action_hand = "left",
			ranged_attack = true,
			aim_assist_max_ramp_multiplier = 0.8,
			roll_crit_once = true,
			burst_shot_delay = 0.08,
			spread_pitch = 0.8,
			aim_assist_ramp_decay_delay = 0.3,
			bullseye = false,
			apply_recoil = true,
			anim_end_event = "attack_finished",
			fire_time = 0.01,
			speed = 9000,
			aim_assist_ramp_multiplier = 0.4,
			anim_event = "attack_shoot",
			reload_when_out_of_ammo = false,
			is_spell = true,
			num_layers_spread = 1,
			hit_effect = "life_impact",
			num_shots = 4,
			overcharge_type = "life_staff_light",
			apply_shot_cost_once = true,
			total_time = 1.4,
			anim_end_event_condition_func = function(arg_1_0, arg_1_1)
				return arg_1_1 ~= "new_interupting_action"
			end,
			anim_time_scale = var_0_2,
			enter_function = function(arg_2_0, arg_2_1)
				arg_2_1:reset_release_input()
				arg_2_1:clear_input_buffer()
			end,
			buff_data = {
				{
					start_time = 0.02,
					external_multiplier = 0.25,
					end_time = 0.3,
					buff_name = "planted_charging_decrease_movement"
				}
			},
			allowed_chain_actions = {
				{
					sub_action = "default_chain",
					start_time = 0.7,
					action = "action_one",
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.35,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_two",
					input = "action_two"
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
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			controller_effects = {
				start = {
					effect_type = "rumble",
					params = {
						rumble_effect = "light_swing"
					}
				},
				fire = {
					effect_type = "rumble",
					params = {
						rumble_effect = "handgun_fire"
					}
				}
			},
			on_shoot_particle_fx = {
				node_name = "j_righthandindex3",
				effect = "fx/lifestaff_launch_projectile"
			},
			projectile_info = Projectiles.lifestaff_light,
			impact_data = {
				wall_nail = true,
				depth = 0.1,
				targets = 1,
				damage_profile = "burst_thorn",
				link = true,
				depth_offset = 0.05
			},
			condition_func = function(arg_3_0, arg_3_1)
				return ScriptUnit.extension(arg_3_0, "overcharge_system"):are_you_locked_out() == false
			end,
			recoil_settings = {
				horizontal_climb = 0,
				restore_duration = 0.6,
				vertical_climb = 0.5,
				climb_duration = 0.1,
				climb_function = math.easeInCubic,
				restore_function = math.ease_out_quad
			}
		},
		default_chain = {
			ammo_usage = 0,
			num_projectiles_per_shot = 1,
			extra_shot_delay = 0.08,
			kind = "rail_gun",
			weapon_action_hand = "left",
			ranged_attack = true,
			aim_assist_max_ramp_multiplier = 0.8,
			roll_crit_once = true,
			burst_shot_delay = 0.08,
			spread_pitch = 0.8,
			aim_assist_ramp_decay_delay = 0.3,
			apply_recoil = true,
			bullseye = false,
			anim_end_event = "attack_finished",
			fire_time = 0.01,
			speed = 9000,
			aim_assist_ramp_multiplier = 0.4,
			anim_event = "attack_shoot_last",
			reload_when_out_of_ammo = false,
			is_spell = true,
			num_layers_spread = 1,
			hit_effect = "life_impact",
			num_shots = 4,
			overcharge_type = "life_staff_light",
			apply_shot_cost_once = true,
			total_time = 1.4,
			anim_end_event_condition_func = function(arg_4_0, arg_4_1)
				return arg_4_1 ~= "new_interupting_action"
			end,
			anim_time_scale = var_0_2,
			enter_function = function(arg_5_0, arg_5_1)
				arg_5_1:reset_release_input()
				arg_5_1:clear_input_buffer()
			end,
			buff_data = {
				{
					start_time = 0.02,
					external_multiplier = 0.25,
					end_time = 0.3,
					buff_name = "planted_charging_decrease_movement"
				}
			},
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.7,
					action = "action_one",
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.35,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_two",
					input = "action_two"
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
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			controller_effects = {
				start = {
					effect_type = "rumble",
					params = {
						rumble_effect = "light_swing"
					}
				},
				fire = {
					effect_type = "rumble",
					params = {
						rumble_effect = "handgun_fire"
					}
				}
			},
			on_shoot_particle_fx = {
				node_name = "j_righthandindex3",
				effect = "fx/lifestaff_launch_projectile"
			},
			projectile_info = Projectiles.lifestaff_light,
			impact_data = {
				wall_nail = true,
				depth = 0.1,
				targets = 1,
				damage_profile = "burst_thorn",
				link = true,
				depth_offset = 0.05
			},
			recoil_settings = {
				horizontal_climb = 0,
				restore_duration = 0.6,
				vertical_climb = 0.5,
				climb_duration = 0.1,
				climb_function = math.easeInCubic,
				restore_function = math.ease_out_quad
			}
		},
		cast_vortex = {
			damage_window_start = 0.1,
			fire_at_gaze_setting = "tobii_fire_at_gaze_geiser",
			kind = "spirit_storm",
			anim_end_event = "attack_finished",
			overcharge_amount = 10,
			is_spell = true,
			damage_profile = "spirit_storm",
			alert_enemies = true,
			damage_window_end = 0,
			alert_sound_range_fire = 12,
			weapon_action_hand = "left",
			fire_time = 0,
			fire_sound_on_husk = true,
			anim_event = "attack_shoot_fireball_charged",
			player_target_buff = "staff_life_player_target_cooldown",
			total_time = 1,
			buff_data = {
				{
					start_time = 0,
					external_multiplier = 0.75,
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
					start_time = 0.6,
					action = "action_one",
					release_required = "action_two_hold",
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
			enter_function = function(arg_6_0, arg_6_1)
				arg_6_1:reset_release_input()
				arg_6_1:clear_input_buffer()
			end
		}
	},
	action_two = {
		default = {
			hold_input = "action_two_hold",
			default_zoom = "zoom_in_trueflight",
			not_wield_previous = true,
			kind = "career_true_flight_aim",
			anim_end_event = "attack_finished",
			aim_time = 0,
			allow_hold_toggle = true,
			aim_obstructed_by_walls = true,
			aim_sticky_target_size = 1,
			minimum_hold_time = 0.2,
			ignore_bosses = true,
			weapon_action_hand = "left",
			aim_sticky_time = 0,
			num_projectiles = 1,
			uninterruptible = true,
			anim_event = "attack_charge_fireball",
			anim_end_event_condition_func = function(arg_7_0, arg_7_1)
				return arg_7_1 ~= "new_interupting_action"
			end,
			total_time = math.huge,
			can_target_players = function(arg_8_0)
				if ScriptUnit.has_extension(arg_8_0, "buff_system"):has_buff_perk(var_0_0.sister_no_player_lift) then
					return false
				end

				return true
			end,
			enter_function = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				arg_9_3:change_synced_state("targeting", true)
			end,
			finish_function = function(arg_10_0, arg_10_1, arg_10_2)
				arg_10_2:change_synced_state(nil, true)
			end,
			zoom_thresholds = {
				"zoom_in_trueflight",
				"zoom_in"
			},
			zoom_condition_function = function()
				return true
			end,
			prioritized_breeds = {
				chaos_vortex_sorcerer = 1,
				chaos_raider = 1,
				chaos_berzerker = 1,
				beastmen_bestigor = 1,
				skaven_poison_wind_globadier = 1,
				skaven_warpfire_thrower = 1,
				beastmen_standard_bearer = 1,
				skaven_gutter_runner = 1,
				skaven_ratling_gunner = 1,
				skaven_plague_monk = 1,
				skaven_pack_master = 1,
				chaos_bulwark = 1,
				chaos_warrior = 1,
				chaos_tether_sorcerer = 1,
				chaos_corruptor_sorcerer = 1,
				skaven_storm_vermin_commander = 1,
				skaven_storm_vermin = 1,
				skaven_storm_vermin_with_shield = 1
			},
			ignored_breeds = table.set({
				"chaos_greed_pinata"
			}),
			condition_func = function(arg_12_0, arg_12_1)
				if ScriptUnit.extension(arg_12_0, "overcharge_system"):are_you_locked_out() ~= false then
					return false
				end

				return true
			end,
			chain_condition_func = function(arg_13_0, arg_13_1)
				if ScriptUnit.extension(arg_13_0, "overcharge_system"):are_you_locked_out() ~= false then
					return false
				end

				return true
			end,
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
					sub_action = "cast_vortex",
					start_time = 0.2,
					action = "action_one",
					input = "action_one"
				}
			}
		}
	},
	weapon_reload = {
		default = {
			charge_sound_stop_event = "Stop_weapon_life_staff_cooldown_loop",
			weapon_action_hand = "left",
			uninterruptible = true,
			charge_effect_material_variable_name = "intensity",
			kind = "charge",
			anim_end_event = "cooldown_end",
			do_not_validate_with_hold = true,
			charge_effect_material_name = "Fire",
			minimum_hold_time = 0.5,
			vent_overcharge = true,
			charge_time = 3,
			hold_input = "weapon_reload_hold",
			anim_event = "cooldown_start",
			charge_sound_name = "Play_weapon_life_staff_cooldown_loop",
			anim_end_event_condition_func = function(arg_14_0, arg_14_1)
				return arg_14_1 ~= "new_interupting_action"
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
			enter_function = function(arg_15_0, arg_15_1)
				arg_15_1:reset_release_input()
				arg_15_1:clear_input_buffer()
			end,
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.2,
					action = "action_wield",
					input = "action_wield"
				}
			},
			condition_func = function(arg_16_0, arg_16_1)
				local var_16_0 = ScriptUnit.extension(arg_16_0, "overcharge_system")

				if var_16_0:get_overcharge_value() == 0 then
					return false
				end

				if var_16_0:are_you_locked_out() ~= false then
					return false
				end

				if ScriptUnit.extension(arg_16_0, "buff_system"):apply_buffs_to_value(1, "vent_speed") <= 0 then
					return false
				end

				return true
			end,
			chain_condition_func = function(arg_17_0, arg_17_1)
				local var_17_0 = ScriptUnit.extension(arg_17_0, "overcharge_system")

				if var_17_0:get_overcharge_value() == 0 then
					return false
				end

				if var_17_0:are_you_locked_out() ~= false then
					return false
				end

				if ScriptUnit.extension(arg_17_0, "buff_system"):apply_buffs_to_value(1, "vent_speed") <= 0 then
					return false
				end

				return true
			end
		}
	},
	action_inspect = table.clone(ActionTemplates.action_inspect),
	action_wield = ActionTemplates.wield
}

function var_0_1.actions.action_inspect.default.condition_func(arg_18_0, arg_18_1)
	if not ActionTemplates.action_inspect.default.condition_func(arg_18_0, arg_18_1) then
		return false
	end

	return ScriptUnit.extension(arg_18_0, "overcharge_system"):are_you_locked_out() == false
end

var_0_1.default_spread_template = "spear"
var_0_1.overcharge_data = {
	explosion_template = "overcharge_explosion_brw",
	overcharge_warning_critical_sound_event = "weapon_life_staff_overcharge_warning_critical",
	overcharge_warning_med_sound_event = "weapon_life_staff_overcharge_warning_medium",
	time_until_overcharge_decreases = 0.5,
	hit_overcharge_threshold_sound = "ui_special_attack_ready",
	overcharge_value_decrease_rate = 1,
	overcharge_warning_high_sound_event = "weapon_life_staff_overcharge_warning_high",
	overcharge_threshold = 10
}
var_0_1.attack_meta_data = {
	max_range = 30,
	max_range_charged = 50,
	can_charge_shot = true,
	charge_when_outside_max_range_charged = false,
	ignore_hitting_allies_charged = true,
	ignore_disabled_enemies_charged = true,
	aim_at_node = "j_head",
	obstruction_fuzzyness_range_charged = 6,
	aim_at_node_charged = "j_spine1",
	ignore_enemies_for_obstruction_charged = true,
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
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Berserker, BreedCategory.Armored),
	effective_against_charged = bit.bor(BreedCategory.Armored, BreedCategory.Special, BreedCategory.Shielded, BreedCategory.SuperArmor)
}
var_0_1.aim_assist_settings = {
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
var_0_1.jump_anim_enabled_1p = true
left_hand_unit = "units/weapons/player/wpn_we_life_staff_01/wpn_we_life_staff_01"
var_0_1.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_1.display_unit = "units/weapons/weapon_display/display_staff"
var_0_1.wield_anim = "to_life_staff"
var_0_1.state_machine = "units/beings/player/first_person_base/state_machines/ranged/life_staff"
var_0_1.crosshair_style = "arrows"
var_0_1.buff_type = "RANGED"
var_0_1.weapon_type = "LIFE_STAFF"
var_0_1.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_1.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 2,
		[DamageTypes.CLEAVE] = 2,
		[DamageTypes.SPEED] = 6,
		[DamageTypes.STAGGER] = 0,
		[DamageTypes.DAMAGE] = 4
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 0,
		[DamageTypes.CLEAVE] = 0,
		[DamageTypes.SPEED] = 5,
		[DamageTypes.STAGGER] = 7,
		[DamageTypes.DAMAGE] = 0
	}
}
var_0_1.tooltip_keywords = {
	"weapon_keyword_sniper",
	"weapon_keyword_crowd_control",
	"weapon_keyword_rapid_fire"
}
var_0_1.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one"
	}
}
var_0_1.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one"
	}
}

function var_0_1.on_wield(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not arg_19_3 then
		return
	end

	arg_19_0:change_synced_state("wielding", true)
end

local var_0_3 = {
	"ep_r_index",
	"ep_r_middle",
	"ep_r_ring",
	"ep_r_pinky",
	"ep_r_thumb"
}

local function var_0_4(arg_20_0, arg_20_1)
	if arg_20_0.particle_ids then
		table.clear(arg_20_0.particle_ids)
	else
		arg_20_0.particle_ids = {}
	end

	if not arg_20_0.nodes then
		arg_20_0.nodes = {}

		local var_20_0 = ScriptUnit.has_extension(arg_20_1, "first_person_system")

		if var_20_0 then
			local var_20_1 = var_20_0:get_first_person_mesh_unit()

			for iter_20_0 = 1, #var_0_3 do
				local var_20_2 = var_0_3[iter_20_0]

				arg_20_0.nodes[var_20_2] = Unit.node(var_20_1, var_20_2)
			end
		end
	end
end

var_0_1.synced_states = {
	wielding = {
		enter = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
			if not arg_21_4 then
				return
			end

			var_0_4(arg_21_3, arg_21_1)

			local var_21_0 = ScriptUnit.extension(arg_21_1, "first_person_system"):get_first_person_mesh_unit()

			for iter_21_0 = 1, #var_0_3 do
				local var_21_1 = arg_21_3.nodes[var_0_3[iter_21_0]]

				arg_21_3.particle_ids[var_21_1] = ScriptWorld.create_particles_linked(arg_21_5, "fx/magic_thorn_sister_finger_trail", var_21_0, var_21_1, "destroy")
			end

			arg_21_3.timer = 0.7
		end,
		update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
			if not arg_22_3.timer then
				return
			end

			arg_22_3.timer = arg_22_3.timer - arg_22_6

			if arg_22_3.timer < 0 then
				arg_22_7:change_synced_state(nil, true)
			end
		end,
		leave = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7)
			if not arg_23_4 then
				return
			end

			for iter_23_0 in pairs(arg_23_3.particle_ids) do
				local var_23_0 = arg_23_3.particle_ids[iter_23_0]

				World.stop_spawning_particles(arg_23_5, var_23_0)
			end
		end
	},
	targeting = {
		enter = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
			if not arg_24_4 then
				return
			end

			var_0_4(arg_24_3, arg_24_1)

			local var_24_0 = ScriptUnit.extension(arg_24_1, "first_person_system"):get_first_person_mesh_unit()

			for iter_24_0 = 1, #var_0_3 do
				local var_24_1 = arg_24_3.nodes[var_0_3[iter_24_0]]

				arg_24_3.particle_ids[var_24_1] = ScriptWorld.create_particles_linked(arg_24_5, "fx/magic_thorn_sister_finger_trail", var_24_0, var_24_1, "destroy")
			end
		end,
		update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			return
		end,
		leave = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7)
			if not arg_26_4 then
				return
			end

			for iter_26_0 in pairs(arg_26_3.particle_ids) do
				local var_26_0 = arg_26_3.particle_ids[iter_26_0]

				World.stop_spawning_particles(arg_26_5, var_26_0)
			end
		end
	}
}

local var_0_5 = table.clone(var_0_1)

var_0_5.actions.action_one.default.impact_data.damage_profile = "burst_thorn_vs"
var_0_5.actions.action_one.default_chain.impact_data.damage_profile = "burst_thorn_vs"

return {
	staff_life = table.clone(var_0_1),
	staff_life_vs = table.clone(var_0_5)
}
