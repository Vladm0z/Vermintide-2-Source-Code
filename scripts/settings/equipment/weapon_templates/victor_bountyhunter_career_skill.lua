-- chunkname: @scripts/settings/equipment/weapon_templates/victor_bountyhunter_career_skill.lua

local var_0_0 = {
	actions = {
		action_career_hold = {
			default = {
				anim_end_event = "ability_finished",
				kind = "career_dummy",
				uninterruptible = true,
				anim_event = "bounty_hunter_ability_draw",
				weapon_action_hand = "left",
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
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
						start_time = 0.35,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "default",
						start_time = 0.35,
						action = "action_career_release",
						input = "action_career_not_hold"
					},
					{
						sub_action = "hold",
						start_time = 0.42,
						action = "action_career_hold",
						auto_chain = true
					}
				}
			},
			hold = {
				anim_end_event = "ability_finished",
				kind = "career_dummy",
				uninterruptible = true,
				anim_event = "bounty_hunter_ability_hold",
				weapon_action_hand = "left",
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					return arg_2_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
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
					}
				}
			}
		},
		action_career_release = {
			default = {
				damage_window_start = 0.1,
				ray_against_large_hitbox = true,
				charge_value = "projectile",
				shot_count = 10,
				headshot_multiplier = 2,
				damage_profile = "shot_shotgun_ability",
				kind = "career_wh_two",
				weapon_action_hand = "left",
				alert_sound_range_hit = 2,
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_auto_hit_chance = 0.5,
				aim_assist_ramp_decay_delay = 0.2,
				aoe_radius = 2.5,
				fire_time_upper = 0,
				anim_time_scale = 1,
				damage_window_end = 0,
				range = 100,
				anim_end_event = "ability_finished",
				fire_time_lower = 0,
				speed = 16000,
				shotgun_spread_template = "bounty_hunter_shotgun",
				aim_assist_ramp_multiplier = 0.1,
				anim_event = "bounty_hunter_ability_shoot",
				railgun_spread_template = "bounty_hunter_handgun",
				aoe_time = 0.175,
				hit_effect = "shotgun_bullet_impact",
				alert_sound_range_fire = 12,
				damage_profile_aoe = "shield_slam_aoe",
				uninterruptible = true,
				ignore_shield_hit = true,
				total_time = 0.66,
				anim_end_event_condition_func = function (arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {},
				hit_mass_count = LINESMAN_HIT_MASS_COUNT,
				projectile_info = Projectiles.victor_bounty_hunter,
				impact_data = {
					damage_profile = "shot_sniper_ability"
				}
			}
		},
		action_two = {
			default = {
				kind = "career_dummy",
				weapon_action_hand = "left",
				anim_end_event = "ability_finished",
				anim_event = "bounty_hunter_ability_cancel",
				total_time = 0.47,
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	},
	attack_meta_data = {
		aim_at_node = "j_head",
		charge_shot_delay = 0.1,
		always_charge_before_firing = true,
		charged_attack_action_name = "default",
		can_charge_shot = true,
		ignore_enemies_for_obstruction_charged = true,
		base_action_name = "action_career_release",
		aim_at_node_charged = "j_head",
		ignore_allies_for_obstruction = true,
		minimum_charge_time = 0.38,
		ignore_allies_for_obstruction_charged = true,
		charge_when_obstructed = true,
		ignore_enemies_for_obstruction = true
	}
}

var_0_0.default_spread_template = "bounty_hunter_handgun"
var_0_0.left_hand_unit = "units/weapons/player/wpn_emp_shotgun/pn_emp_shotgunw"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.bounty_hunter_handgun
var_0_0.display_unit = "units/weapons/weapon_display/display_pistols"
var_0_0.wield_anim = "bounty_hunter_ability_draw"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_bountyhunter"
var_0_0.load_state_machine = false
var_0_0.crosshair_style = "default"
var_0_0.gui_texture = "hud_weapon_icon_repeating_handgun"
var_0_0.buff_type = "RANGED_ABILITY"
var_0_0.weapon_type = "HANDGUN"
var_0_0.dodge_count = 3
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.1
	}
}
var_0_0.aim_assist_settings = {
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
var_0_0.wwise_dep_left_hand = {
	"wwise/rakegun"
}

local var_0_1 = table.clone(var_0_0)

var_0_1.actions.action_career_release.default.impact_data.damage_profile = "shot_sniper_ability_vs"
var_0_1.actions.action_career_release.default.damage_profile = "shot_shotgun_ability"

return {
	victor_bountyhunter_career_skill_weapon = table.clone(var_0_0),
	victor_bountyhunter_career_skill_weapon_vs = table.clone(var_0_1)
}
