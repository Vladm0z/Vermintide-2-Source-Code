-- chunkname: @scripts/settings/equipment/weapon_templates/sienna_scholar_career_skill.lua

local var_0_0 = 1
local var_0_1 = {
	actions = {
		action_career_hold = {
			default = {
				charge_sound_stop_event = "Stop_weapon_ability_pyromancer_skull_spawn",
				default_zoom = "zoom_in_trueflight",
				anim_end_event = "ability_finished",
				kind = "career_true_flight_aim",
				aim_time = 0,
				anim_event = "scholar_burning_head_ability_charge",
				charge_sound_husk_name = "Play_weapon_ability_pyromancer_skull_spawn_husk",
				charge_sound_husk_stop_event = "Stop_weapon_ability_pyromancer_skull_spawn_husk",
				weapon_action_hand = "left",
				init_flow_event = "burning_head_init",
				uninterruptible = true,
				aim_obstructed_by_walls = true,
				charge_sound_name = "Play_weapon_ability_pyromancer_skull_spawn",
				anim_end_event_condition_func = function(arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				num_projectiles = var_0_0,
				zoom_thresholds = {
					"zoom_in_trueflight",
					"zoom_in"
				},
				zoom_condition_function = function()
					return true
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.1,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "default",
						start_time = 0.1,
						action = "action_career_release",
						input = "action_career_not_hold"
					}
				}
			}
		},
		action_career_release = {
			default = {
				damage_window_start = 0.1,
				charge_value = "light_attack",
				fire_sound_event = "Play_weapon_ability_pyromancer_skull_shoot",
				alert_sound_range_hit = 20,
				sphere_sweep_length = 50,
				kind = "career_bw_one",
				sphere_sweep_dot_threshold = 0.5,
				true_flight_template = "active_ability_sienna_scholar",
				alert_sound_range_fire = 12,
				weapon_action_hand = "left",
				damage_window_end = 0,
				anim_end_event = "ability_finished",
				fire_time = 0.2,
				speed = 3500,
				sphere_sweep_max_nr_of_results = 100,
				anim_event = "scholar_burning_head_ability_shoot",
				reload_time = 2.5,
				apply_recoil = true,
				reset_aim_on_attack = true,
				default_zoom = "zoom_in_trueflight",
				spread_template_override = "spear",
				hit_effect = "sienna_scholar_career_ability",
				sphere_sweep_radius = 2,
				ammo_usage = 0,
				no_headshot_sound = true,
				fire_sound_on_husk = true,
				uninterruptible = true,
				ignore_shield_hit = true,
				total_time = 1,
				anim_end_event_condition_func = function(arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {},
				num_projectiles = var_0_0,
				zoom_thresholds = {
					"zoom_in_trueflight",
					"zoom_in"
				},
				zoom_condition_function = function()
					return true
				end,
				hit_mass_count = LINESMAN_HIT_MASS_COUNT,
				projectile_info = Projectiles.burning_head,
				impact_data = {
					max_bounces = 8,
					damage_profile = "fire_spear_trueflight",
					bounce_on_level_units = true
				},
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.2,
					vertical_climb = -1,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			}
		},
		action_two = {
			default = {
				kind = "career_dummy",
				weapon_action_hand = "left",
				anim_end_event = "ability_finished",
				anim_event = "scholar_burning_head_ability_cancel",
				total_time = 0.65,
				anim_end_event_condition_func = function(arg_5_0, arg_5_1)
					return arg_5_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	},
	ammo_data = {
		ammo_immediately_available = true,
		ammo_per_reload = 1,
		ammo_per_clip = 1,
		reload_time = 0,
		ammo_hand = "left",
		max_ammo = math.huge,
		ammo_unit_attachment_node_linking = AttachmentNodeLinking.burning_head
	},
	attack_meta_data = {
		aim_at_node = "j_spine1",
		charge_shot_delay = 0.1,
		always_charge_before_firing = true,
		charged_attack_action_name = "default",
		can_charge_shot = true,
		ignore_enemies_for_obstruction_charged = false,
		base_action_name = "action_career_release",
		aim_at_node_charged = "j_head",
		ignore_allies_for_obstruction = true,
		minimum_charge_time = 0.55,
		ignore_allies_for_obstruction_charged = true,
		charge_when_obstructed = true,
		ignore_enemies_for_obstruction = false
	}
}

var_0_1.default_spread_template = "sparks"
var_0_1.left_hand_unit = "units/weapons/player/wpn_invisible_weapon"
var_0_1.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_1.display_unit = "units/weapons/weapon_display/display_staff"
var_0_1.wield_anim = "to_staff"
var_0_1.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_scholar"
var_0_1.load_state_machine = false
var_0_1.crosshair_style = "default"
var_0_1.buff_type = "RANGED_ABILITY"
var_0_1.weapon_type = "FIRE_STAFF"
var_0_1.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_1.aim_assist_settings = {
	max_range = 22,
	no_aim_input_multiplier = 0,
	aim_at_node = "j_neck",
	can_charge_shot = true,
	base_multiplier = 0.15,
	aim_at_node_charged = "j_spine",
	effective_max_range = 10,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}

return {
	sienna_scholar_career_skill_weapon = table.clone(var_0_1)
}
