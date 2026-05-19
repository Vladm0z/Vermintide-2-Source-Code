-- chunkname: @scripts/settings/equipment/weapon_templates/kerillian_waywatcher_career_skill_piercing_shot.lua

local var_0_0 = 1
local var_0_1 = 4
local var_0_2 = 2
local var_0_3 = table.clone(ActionTemplates.wield)
local var_0_4 = var_0_3.default
local var_0_5 = type(var_0_4.pre_action_anim_event) == "table" and table.clone(var_0_4.pre_action_anim_event) or {
	var_0_4.pre_action_anim_event
}

table.insert(var_0_5, 1, "waywatcher_trueflight_ability_cancel")
table.insert(var_0_5, 2, "ability_finished")

var_0_4.pre_action_anim_event = var_0_5

local var_0_6 = {
	actions = {
		action_career_hold = {
			default = {
				aim_time = 0,
				default_zoom = "zoom_in_trueflight",
				anim_end_event = "ability_finished",
				kind = "career_aim",
				weapon_action_hand = "left",
				uninterruptible = true,
				anim_event = "waywatcher_trueflight_ability_charge",
				anim_end_event_condition_func = function(arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				num_projectiles = var_0_0,
				buffed_zoom_thresholds = {
					"zoom_in_trueflight",
					"zoom_in"
				},
				zoom_condition_function = function()
					return true
				end,
				unzoom_condition_function = function(arg_3_0)
					return arg_3_0 ~= "new_interupting_action"
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
						start_time = 0.25,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "default",
						start_time = 0.25,
						action = "action_career_release",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "hold",
						start_time = 0.83,
						action = "action_career_hold",
						auto_chain = true
					}
				}
			},
			hold = {
				aim_time = 0,
				default_zoom = "zoom_in_trueflight",
				anim_end_event = "ability_finished",
				kind = "career_aim",
				weapon_action_hand = "left",
				uninterruptible = true,
				anim_event = "waywatcher_trueflight_ability_hold",
				anim_end_event_condition_func = function(arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				num_projectiles = var_0_0,
				buffed_zoom_thresholds = {
					"zoom_in_trueflight",
					"zoom_in"
				},
				zoom_condition_function = function()
					return true
				end,
				unzoom_condition_function = function(arg_6_0)
					return arg_6_0 ~= "new_interupting_action"
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
						start_time = 0,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					}
				}
			}
		},
		action_career_release = {
			default = {
				fire_sound_event = "player_combat_weapon_bow_fire_light_homing",
				weapon_action_hand = "left",
				sphere_sweep_length = 50,
				multi_projectile_spread = 0.1,
				sphere_sweep_dot_threshold = 0.75,
				ammo_usage = 0,
				kind = "career_we_three_piercing",
				aim_assist_ramp_multiplier = 0.4,
				aim_assist_max_ramp_multiplier = 0.8,
				aim_assist_ramp_decay_delay = 0.3,
				anim_end_event = "ability_finished",
				fire_time = 0,
				single_target = true,
				career_skill = true,
				speed = 12000,
				sphere_sweep_max_nr_of_results = 100,
				anim_event = "waywatcher_trueflight_ability_shoot",
				apply_recoil = true,
				extra_fire_sound_event = "Play_career_ability_waywatcher_shot",
				hit_effect = "kerillian_ability_trueflight_arrow_impact",
				sphere_sweep_radius = 2,
				charge_value = "light_attack",
				no_extra_shots = false,
				uninterruptible = true,
				ignore_shield_hit = true,
				total_time = 0.28,
				anim_end_event_condition_func = function(arg_7_0, arg_7_1)
					return arg_7_1 ~= "new_interupting_action"
				end,
				unzoom_condition_function = function(arg_8_0)
					return arg_8_0 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {},
				num_projectiles = var_0_0,
				projectile_info = Projectiles.kerillian_ability_true_flight_piercing,
				impact_data = {
					max_bounces = 2,
					depth = 0.1,
					bounce_on_level_units = true,
					targets = 1,
					damage_profile = "arrow_sniper_ability_piercing",
					wall_nail = true,
					link = true,
					depth_offset = -0.6
				},
				alert_sound_range_fire = var_0_1,
				alert_sound_range_hit = var_0_2,
				recoil_settings = {
					horizontal_climb = -0.5,
					restore_duration = 0.2,
					vertical_climb = -1.5,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			}
		},
		action_two = {
			default = {
				kind = "career_dummy",
				anim_end_event = "ability_finished",
				anim_event = "waywatcher_trueflight_ability_cancel",
				weapon_action_hand = "left",
				total_time = 0.35,
				anim_end_event_condition_func = function(arg_9_0, arg_9_1)
					return arg_9_1 ~= "new_interupting_action"
				end,
				unzoom_condition_function = function(arg_10_0)
					return arg_10_0 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = var_0_3
	},
	ammo_data = {
		ammo_immediately_available = true,
		ammo_unit = "units/weapons/player/wpn_we_quiver_t1/wpn_we_arrow_t1",
		ammo_per_reload = 1,
		ammo_per_clip = 1,
		ammo_hand = "left",
		ammo_unit_3p = "units/weapons/player/wpn_we_quiver_t1/wpn_we_arrow_t1_3p",
		reload_time = 0.4,
		max_ammo = math.huge,
		ammo_unit_attachment_node_linking = AttachmentNodeLinking.arrow
	},
	attack_meta_data = {
		aim_at_node = "j_head",
		charge_shot_delay = 0.1,
		always_charge_before_firing = true,
		charged_attack_action_name = "default",
		can_charge_shot = true,
		ignore_enemies_for_obstruction_charged = false,
		base_action_name = "action_career_release",
		aim_at_node_charged = "j_head",
		ignore_allies_for_obstruction = true,
		minimum_charge_time = 0.84,
		ignore_allies_for_obstruction_charged = true,
		charge_when_obstructed = true,
		ignore_enemies_for_obstruction = false
	}
}

var_0_6.default_spread_template = "longbow"
var_0_6.slot_to_use = "slot_ranged"
var_0_6.left_hand_unit = "units/weapons/player/wpn_we_bow_01_t1/wpn_we_bow_01_t1"
var_0_6.display_unit = "units/weapons/weapon_display/display_bow"
var_0_6.left_hand_attachment_node_linking = AttachmentNodeLinking.bow
var_0_6.wield_anim = "to_longbow"
var_0_6.wield_anim_no_ammo = "to_longbow_noammo"
var_0_6.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_waywatcher"
var_0_6.load_state_machine = false
var_0_6.crosshair_style = "projectile"
var_0_6.no_ammo_reload_event = "reload"
var_0_6.buff_type = "RANGED_ABILITY"
var_0_6.weapon_type = "LONGBOW_TRUEFLIGHT"
var_0_6.dodge_count = 3
var_0_6.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_6.aim_assist_settings = {
	max_range = 50,
	no_aim_input_multiplier = 0,
	always_auto_aim = true,
	base_multiplier = 0,
	target_node = "j_neck",
	effective_max_range = 30,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}
var_0_6.wwise_dep_left_hand = {
	"wwise/bow"
}
var_0_6.compare_statistics = {
	attacks = {
		light_attack = {
			speed = 0.6,
			range = 0.6,
			damage = 0.5,
			targets = 0.2,
			stagger = 0.4
		},
		heavy_attack = {
			speed = 0.4,
			range = 0.8,
			damage = 0.75,
			targets = 0.4,
			stagger = 0.6
		}
	},
	perks = {
		light_attack = {
			"head_shot",
			"armor_penetration"
		},
		heavy_attack = {
			"head_shot",
			"armor_penetration"
		}
	}
}

return {
	kerillian_waywatcher_career_skill_weapon_piercing_shot = table.clone(var_0_6)
}
