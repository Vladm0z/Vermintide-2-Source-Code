-- chunkname: @scripts/settings/equipment/weapon_templates/bardin_engineer_career_skill.lua

local var_0_0 = 0.75
local var_0_1 = 1
local var_0_2 = 0.5
local var_0_3 = 0.15
local var_0_4 = 4
local var_0_5 = 12
local var_0_6 = 1.5
local var_0_7 = 0.2
local var_0_8 = 2
local var_0_9 = "engineer_ability_shot_armor_pierce"
local var_0_10 = 2
local var_0_11 = 3.6
local var_0_12 = 1.5
local var_0_13 = 0.2
local var_0_14 = 0.34
local var_0_15 = 0.67
local var_0_16 = 0.0015
local var_0_17 = 0.002
local var_0_18 = 0.006
local var_0_19 = 0.16666666666666666
local var_0_20 = 0.3333333333333333

local function var_0_21(arg_1_0, arg_1_1)
	local var_1_0, var_1_1 = ScriptUnit.extension(arg_1_0, "career_system"):current_ability_cooldown(1)

	return var_1_1 - var_1_0 >= var_0_1 * var_0_0
end

local function var_0_22(arg_2_0, arg_2_1)
	local var_2_0, var_2_1 = ScriptUnit.extension(arg_2_0, "career_system"):current_ability_cooldown(1)

	return var_2_1 - var_2_0 >= var_0_1 * var_0_8
end

local var_0_23 = {
	actions = {
		action_one = {
			default = {
				total_time_secondary = 1.75,
				anim_event_secondary = "reload",
				kind = "career_dummy",
				anim_event = "attack_charge",
				total_time = 1.4,
				allowed_chain_actions = {
					{
						sub_action = "spin",
						start_time = 0,
						action = "action_one",
						hold_allowed = true,
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				condition_func = var_0_21,
				enter_function = function (arg_3_0, arg_3_1)
					arg_3_1:clear_input_buffer()

					return arg_3_1:reset_release_input()
				end
			},
			spin = {
				charge_sound_stop_event = "Stop_player_engineer_engine_loop",
				anim_end_event = "attack_finished",
				fp_speed_anim_variable = "barrel_spin_speed",
				visual_spinup_min = 0,
				kind = "career_dr_four_spin",
				override_visual_spinup = true,
				charge_sound_name = "Play_player_engineer_engine_charge",
				windup_max = 0,
				initial_windup = 0,
				visual_spinup_max = 0.3,
				charge_sound_husk_name = "Play_player_engineer_engine_charge_husk",
				windup_speed = 0,
				audio_loop_id = "engineer_weapon_spin",
				hold_input = "action_one_hold",
				anim_event = "attack_charge",
				charge_sound_husk_stop_event = "Stop_player_engineer_engine_loop_husk",
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action"
				end,
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				total_time = var_0_2 + 0.25,
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
						sub_action = "fire",
						action = "action_one",
						hold_allowed = true,
						input = "action_one",
						start_time = var_0_2
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					}
				},
				condition_func = var_0_21,
				enter_function = function (arg_5_0, arg_5_1)
					arg_5_1:clear_input_buffer()

					return arg_5_1:reset_release_input()
				end,
				visual_spinup_time = var_0_2 / 3
			},
			fire = {
				kind = "action_selector",
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				conditional_actions = {
					{
						sub_action = "armor_pierce_fire",
						condition = function (arg_6_0, arg_6_1)
							return arg_6_0 and arg_6_0:has_talent("bardin_engineer_armor_piercing_ability")
						end
					}
				},
				default_action = {
					sub_action = "base_fire"
				},
				condition_func = var_0_21,
				chain_condition_func = var_0_21
			},
			base_fire = {
				anim_event = "attack_shoot_charged",
				use_ability_as_ammo = true,
				fire_sound_event = "Play_player_engineer_shooting_burst",
				kind = "career_dr_four",
				shot_count = 1,
				action_priority = 0,
				damage_profile = "engineer_ability_shot",
				anim_end_event = "attack_finished",
				anim_event_secondary = "reload",
				charge_value = "bullet_hit",
				total_time_secondary = 1.75,
				apply_recoil = true,
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				aim_assist_ramp_multiplier = 0.1,
				aim_assist_max_ramp_multiplier = 0.3,
				fire_time = 0,
				aim_assist_auto_hit_chance = 0.5,
				aim_assist_ramp_decay_delay = 0.2,
				critical_hit_effect = "bullet_critical_impact",
				alert_sound_range_hit = 1.5,
				reload_when_out_of_ammo = true,
				continuous_buff_check = true,
				num_layers_spread = 1,
				hit_effect = "bullet_impact",
				ranged_attack = true,
				alert_sound_range_fire = 10,
				hold_input = "action_one_hold",
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
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
						sub_action = "charged",
						start_time = 0,
						action = "action_two",
						hold_allowed = true,
						release_required = "action_one_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						action = "action_wield",
						input = "action_wield",
						start_time = var_0_3
					}
				},
				enter_function = function (arg_7_0, arg_7_1)
					arg_7_1:clear_input_buffer()

					return arg_7_1:reset_release_input()
				end,
				visual_heat_generation = var_0_16,
				base_anim_speed = var_0_19,
				initial_rounds_per_second = var_0_4,
				max_rps = var_0_5,
				rps_loss_per_second = var_0_6,
				rps_gain_per_shot = var_0_7,
				ammo_usage = var_0_0,
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.25,
					vertical_climb = 0.8,
					climb_duration = 0.1,
					climb_function = math.ease_out_quad,
					restore_function = math.ease_out_quad
				},
				critical_strike = {}
			}
		},
		action_two = {
			default = {
				charge_sound_stop_event = "Stop_player_engineer_engine_loop",
				anim_end_event = "attack_finished",
				visual_spinup_min = 0.4,
				kind = "career_dr_four_spin",
				charge_sound_husk_stop_event = "Stop_player_engineer_engine_loop_husk",
				override_visual_spinup = true,
				windup_max = 0,
				initial_windup = 0,
				visual_spinup_time = 0.3,
				visual_spinup_max = 0.5,
				charge_sound_husk_name = "Play_player_engineer_engine_loop_husk",
				windup_speed = 0,
				audio_loop_id = "engineer_weapon_spin",
				hold_input = "action_two_hold",
				anim_event = "attack_charge_loop",
				charge_sound_name = "Play_player_engineer_engine_charge",
				anim_end_event_condition_func = function (arg_8_0, arg_8_1)
					return arg_8_1 ~= "new_interupting_action"
				end,
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
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
						sub_action = "charged",
						action = "action_two",
						hold_allowed = true,
						input = "action_two",
						start_time = var_0_2
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = var_0_21,
				chain_condition_func = var_0_21,
				enter_function = function (arg_9_0, arg_9_1)
					arg_9_1:clear_input_buffer()

					return arg_9_1:reset_release_input()
				end
			},
			charged = {
				kind = "career_dr_four_spin",
				anim_end_event = "attack_finished",
				action_priority = 0,
				windup_max = 1,
				initial_windup = 0,
				hold_input = "action_two_hold",
				anim_event = "attack_charge_end",
				windup_speed = 0.2,
				anim_end_event_condition_func = function (arg_10_0, arg_10_1)
					return arg_10_1 ~= "new_interupting_action"
				end,
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
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
						sub_action = "fire",
						action = "action_one",
						hold_allowed = true,
						input = "action_one",
						start_time = var_0_3
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = var_0_21,
				chain_condition_func = var_0_21,
				enter_function = function (arg_11_0, arg_11_1)
					arg_11_1:clear_input_buffer()

					return arg_11_1:reset_release_input()
				end
			}
		},
		weapon_reload = {
			default = {
				charge_sound_stop_event = "Stop_player_engineer_steam_loop",
				stop_at_max = true,
				anim_end_event = "cooldown_end",
				kind = "career_dr_four_charge",
				hold_input = "weapon_reload_hold",
				do_not_validate_with_hold = false,
				charge_sound_husk_stop_event = "Stop_player_engineer_steam_loop_husk",
				charge_sound_husk_name = "Play_player_engineer_steam_loop_husk",
				minimum_hold_time = 0.5,
				charge_time = 3,
				uninterruptible = true,
				anim_event = "cooldown_start",
				charge_sound_name = "Play_player_engineer_steam_loop",
				anim_end_event_condition_func = function (arg_12_0, arg_12_1)
					return arg_12_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				buff_data = {},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = function (arg_13_0, arg_13_1)
					local var_13_0 = ScriptUnit.has_extension(arg_13_0, "career_system")

					return not ScriptUnit.has_extension(arg_13_0, "buff_system"):has_buff_type("bardin_engineer_pump_max_exhaustion_buff")
				end,
				chain_condition_func = function (arg_14_0, arg_14_1)
					local var_14_0 = ScriptUnit.has_extension(arg_14_0, "career_system")

					return not ScriptUnit.has_extension(arg_14_0, "buff_system"):has_buff_type("bardin_engineer_pump_max_exhaustion_buff")
				end,
				initial_charge_delay = var_0_14,
				ability_charge_interval = var_0_15
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	}
}
local var_0_24 = table.shallow_copy(var_0_23.actions.action_one.base_fire)

var_0_23.actions.action_one.fast_fire = var_0_24

local var_0_25 = table.shallow_copy(var_0_23.actions.action_one.base_fire)

var_0_25.damage_profile = var_0_9
var_0_25.visual_heat_generation = var_0_17
var_0_25.base_anim_speed = var_0_20
var_0_25.ammo_usage = var_0_8
var_0_25.initial_rounds_per_second = var_0_10
var_0_25.max_rps = var_0_11
var_0_25.rps_loss_per_second = var_0_12
var_0_25.rps_gain_per_shot = var_0_13
var_0_25.fire_sound_event = "Play_player_engineer_shooting_armor_piercing"
var_0_23.actions.action_one.armor_pierce_fire = var_0_25
var_0_23.attack_meta_data = {
	max_range = 25,
	aim_at_node = "j_spine1",
	keep_distance = 6.5,
	fire_input = "fire_hold",
	ignore_enemies_for_obstruction = false,
	stop_fire_delay = 0.3,
	aim_data = {
		min_radius_pseudo_random_c = 1,
		max_radius_pseudo_random_c = 0.3021,
		min_radius = math.pi / 72,
		max_radius = math.pi / 16
	},
	hold_fire_condition = function (arg_15_0, arg_15_1)
		return true
	end,
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Shielded, BreedCategory.Boss, BreedCategory.Berserker, BreedCategory.Special)
}
var_0_23.default_spread_template = "sparks"
var_0_23.right_hand_unit = ""
var_0_23.right_hand_attachment_node_linking = AttachmentNodeLinking.rotary_gun
var_0_23.display_unit = "units/weapons/weapon_display/display_drakegun"
var_0_23.wield_anim = "to_engineer_career_skill"
var_0_23.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_engineer"
var_0_23.load_state_machine = false
var_0_23.crosshair_style = "default"
var_0_23.buff_type = "RANGED"
var_0_23.weapon_type = "BRACE_OF_PISTOLS"
var_0_23.dodge_count = 1
var_0_23.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.1
	}
}
var_0_23.aim_assist_settings = {
	max_range = 22,
	no_aim_input_multiplier = 0,
	aim_at_node = "j_spine",
	always_auto_aim = true,
	base_multiplier = 0.15,
	effective_max_range = 10,
	breed_scalars = {
		skaven_storm_vermin = 0.25,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}
var_0_23.particle_fx = {
	heat_shimmer = {
		{
			orphaned_policy = "destroy",
			effect = "fx/wpnfx_engineer_heat_shimmer",
			third_person = false,
			link_target = "right_weapon",
			first_person = true,
			link_node = "fx_muzzle",
			destroy_policy = "stop_spawning"
		}
	}
}
var_0_23.particle_fx_lookup = table.mirror_array_inplace(table.keys(var_0_23.particle_fx))
var_0_23.visual_heat_cooldown_speed = var_0_18
var_0_23.custom_data = {
	windup = 0,
	windup_loss_per_second = (var_0_5 - var_0_4) / var_0_6
}

var_0_23.update = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0:get_custom_data("windup") - arg_16_0:get_custom_data("windup_loss_per_second") * arg_16_1

	arg_16_0:set_custom_data("windup", var_16_0)
end

local var_0_26 = table.clone(var_0_23)

var_0_26.wield_anim = "to_engineer_career_skill_special"
var_0_26.actions.action_one.default.condition_func = var_0_22
var_0_26.actions.action_one.default.chain_condition_func = var_0_22
var_0_26.actions.action_one.spin.condition_func = var_0_22
var_0_26.actions.action_one.spin.chain_condition_func = var_0_22
var_0_26.actions.action_one.fire.condition_func = var_0_22
var_0_26.actions.action_one.fire.chain_condition_func = var_0_22
var_0_26.actions.action_two.default.condition_func = var_0_22
var_0_26.actions.action_two.default.chain_condition_func = var_0_22
var_0_26.actions.action_two.charged.condition_func = var_0_22
var_0_26.actions.action_two.charged.chain_condition_func = var_0_22
var_0_26.attack_meta_data = {
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Shielded, BreedCategory.Boss, BreedCategory.Berserker, BreedCategory.Special, BreedCategory.Armored)
}
var_0_23.custom_data = {
	windup = 0,
	windup_loss_per_second = (var_0_11 - var_0_10) / var_0_12
}

local var_0_27 = table.clone(var_0_23)

var_0_27.actions.action_one.base_fire.damage_profile = "engineer_ability_shot_vs"
armor_piercing_template_vs = table.clone(var_0_26)

return {
	bardin_engineer_career_skill_weapon = table.clone(var_0_23),
	bardin_engineer_career_skill_weapon_special = var_0_26,
	bardin_engineer_career_skill_weapon_vs = table.clone(var_0_27),
	bardin_engineer_career_skill_weapon_special_vs = armor_piercing_template_vs
}
