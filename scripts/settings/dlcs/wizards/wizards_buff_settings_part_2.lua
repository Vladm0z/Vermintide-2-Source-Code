-- chunkname: @scripts/settings/dlcs/wizards/wizards_buff_settings_part_2.lua

local var_0_0 = DLCSettings.wizards_part_2
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

var_0_0.buff_templates = {
	wall_slow_debuff = {
		buffs = {
			{
				name = "grudge_mark_crippling_blow_debuff_flow_event",
				flow_event = "sfx_vce_struggle",
				max_stacks = 1,
				duration = 3,
				apply_buff_func = "first_person_flow_event"
			},
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_slow_run",
				icon = "buff_wall_slow_icon",
				priority_buff = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				debuff = true,
				max_stacks = 1,
				duration = 3,
				path_to_movement_setting_to_modify = {
					"move_speed"
				},
				sfx = {
					activation_sound = "enemy_grudge_crippling_hit"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_slow_crouch",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 3,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_slow_walk",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 3,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_jump_debuff",
				duration = 3,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				multiplier = 0.5,
				name = "grudge_mark_crippling_blow_dodge_speed_debuff",
				duration = 3,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				multiplier = 0.5,
				name = "grudge_mark_crippling_blow_dodge_distance_debuff",
				duration = 3,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	ethereal_skull_debuff = {
		buffs = {
			{
				name = "ethereal_skull_debuff",
				apply_buff_func = "apply_one_from_list",
				buff_list = {
					"ethereal_skull_debuff_delayed_stun_effect"
				}
			}
		}
	},
	ethereal_skull_debuff_delayed_stun = {
		buffs = {
			{
				buff_to_add = "ethereal_skull_debuff_delayed_stun_effect",
				name = "ethereal_skull_debuff_delayed_stun",
				is_cooldown = true,
				icon = "deus_curse_slaanesh_01",
				continuous_effect = "fx/screenspace_darkness_flash",
				remove_buff_func = "add_buff",
				priority_buff = true,
				debuff = true,
				max_stacks = 1,
				duration = 3
			}
		}
	},
	ethereal_skull_debuff_delayed_stun_effect = {
		buffs = {
			{
				max_stacks = 1,
				name = "ethereal_skull_debuff_delayed_stun_effect",
				duration = 1
			},
			{
				particle_fx = "fx/skull_trap_ethereal",
				name = "ethereal_skull_debuff_particle",
				offset_rotation_y = 90,
				duration = 1,
				remove_buff_func = "remove_attach_particle",
				apply_buff_func = "apply_attach_particle"
			}
		}
	},
	ethereal_skull_debuff_delayed_banish = {
		buffs = {
			{
				icon = "twitch_icon_vanishing_act",
				name = "ethereal_skull_debuff_delayed_banish",
				continuous_effect = "fx/screenspace_inside_plague_vortex",
				max_stacks = 1,
				duration = 3,
				priority_buff = true,
				debuff = true,
				perks = {
					var_0_1.invulnerable
				}
			},
			{
				max_stacks = 1,
				name = "ethereal_skull_debuff_delayed_banish_stun",
				duration = 3,
				perks = {
					var_0_1.overpowered
				}
			}
		}
	}
}
var_0_0.buff_function_templates = {}
var_0_0.explosion_templates = {
	ethereal_skull_explosion = {
		explosion = {
			allow_friendly_fire_override = true,
			radius = 1,
			always_stagger_ai = true,
			buff_to_apply = "ethereal_skull_debuff",
			max_damage_radius_min = 0.5,
			attack_template = "drakegun",
			max_damage_radius_max = 1,
			alert_enemies = false,
			damage_profile = "homing_skull_explosion",
			power_level = 500,
			effect_name = "fx/ethereal_skulls_explosion",
			immune_breeds = {
				chaos_zombie = true,
				skaven_grey_seer = true,
				skaven_stormfiend = true
			}
		}
	},
	ethereal_skull_impact = {
		server_hit_func = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
			local var_1_0 = Unit.local_position(arg_1_0, 0)
			local var_1_1 = Managers.world:world("level_world")

			arg_1_5 = ExplosionUtils.get_template("ethereal_skull_explosion")

			DamageUtils.create_explosion(var_1_1, arg_1_0, var_1_0, Quaternion.identity(), arg_1_5, 1, arg_1_1, true, false, arg_1_2, false)

			local var_1_2 = Managers.state.network:game_object_or_level_id(arg_1_0)
			local var_1_3 = NetworkLookup.explosion_templates[arg_1_5.name]
			local var_1_4 = NetworkLookup.damage_sources[arg_1_1]

			Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_1_2, false, var_1_0, Quaternion.identity(), var_1_3, 1, var_1_4, 0, false, var_1_2)
			AiUtils.kill_unit(arg_1_0, nil, nil, "undefined", nil)
		end
	}
}
