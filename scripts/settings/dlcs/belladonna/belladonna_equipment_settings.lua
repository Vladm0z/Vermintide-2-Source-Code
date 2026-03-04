-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_equipment_settings.lua

local var_0_0 = DLCSettings.belladonna

local function var_0_1(arg_1_0)
	return arg_1_0 * 0.0174532925
end

var_0_0.light_weight_projectiles = {
	ungor_archer = {
		projectile_speed = 35,
		hit_effect = "arrow_impact",
		projectile_max_range = 50,
		impact_push_speed = 3,
		light_weight_projectile_effect = "ungor_arrow",
		damage_profile = "ungor_archer_arrow",
		spread = var_0_1(0.05),
		dodge_spread = var_0_1(4),
		first_shot_spread = var_0_1(8),
		miss_spread = var_0_1(4),
		attack_power_level = {
			20,
			40,
			70,
			100,
			150,
			250,
			250,
			250,
			40
		},
		first_person_hit_flow_events = {
			"arrow_left",
			"arrow_right",
			"arrow_center"
		},
		projectile_linker = {
			depth = 0.1,
			unit = "units/weapons/enemy/wpn_bm_ungor_set_01/wpn_bm_ungor_arrow_01_3p",
			depth_offset = -0.6
		}
	}
}
var_0_0.light_weight_projectile_effects = {
	ungor_arrow = {
		vfx = {
			{
				particle_name = "fx/ungor_arrow",
				kill_policy = "destroy"
			},
			{
				particle_name = "fx/ungor_arrow_flash"
			}
		},
		sfx = {
			{
				looping_sound_event_name = "Play_enemy_weapon_ungor_archer_arrow_start",
				looping_sound_stop_event_name = "Stop_enemy_weapon_ungor_archer_arrow_start"
			}
		}
	}
}
var_0_0.damage_profile_template_files_names = {
	"scripts/settings/equipment/damage_profile_templates_scorpion"
}
var_0_0.explosion_templates = {
	standard_bearer_explosion = {
		explosion = {
			radius = 7,
			alert_enemies_radius = 20,
			max_damage_radius = 4,
			catapult_players = true,
			player_push_speed = 10,
			catapult_force = 7,
			attack_template = "loot_rat_explosion",
			alert_enemies = false,
			damage_profile = "standard_bearer_explosion",
			effect_name = "fx/chr_beastmen_standard_bearer_start_01",
			difficulty_power_level = {
				easy = {
					power_level_glance = 800,
					power_level = 800
				},
				normal = {
					power_level_glance = 800,
					power_level = 800
				},
				hard = {
					power_level_glance = 800,
					power_level = 800
				},
				harder = {
					power_level_glance = 800,
					power_level = 800
				},
				hardest = {
					power_level_glance = 800,
					power_level = 800
				},
				cataclysm = {
					power_level_glance = 800,
					power_level = 800
				},
				cataclysm_2 = {
					power_level_glance = 800,
					power_level = 800
				},
				cataclysm_3 = {
					power_level_glance = 800,
					power_level = 800
				},
				versus_base = {
					power_level_glance = 800,
					power_level = 800
				}
			},
			camera_effect = {
				near_distance = 5,
				near_scale = 1,
				shake_name = "frag_grenade_explosion",
				far_scale = 0.25,
				far_distance = 30
			},
			immune_breeds = {
				beastmen_standard_bearer = true
			}
		}
	},
	standard_death_explosion = {
		explosion = {
			radius = 4,
			alert_enemies_radius = 10,
			max_damage_radius = 3,
			player_push_speed = 10,
			attack_template = "loot_rat_explosion",
			alert_enemies = false,
			damage_profile = "standard_death_explosion",
			effect_name = "fx/chr_beastmen_standard_bearer_end_01",
			difficulty_power_level = {
				easy = {
					power_level_glance = 800,
					power_level = 800
				},
				normal = {
					power_level_glance = 800,
					power_level = 800
				},
				hard = {
					power_level_glance = 800,
					power_level = 800
				},
				harder = {
					power_level_glance = 800,
					power_level = 800
				},
				hardest = {
					power_level_glance = 800,
					power_level = 800
				},
				cataclysm = {
					power_level_glance = 800,
					power_level = 800
				},
				cataclysm_2 = {
					power_level_glance = 800,
					power_level = 800
				},
				cataclysm_3 = {
					power_level_glance = 800,
					power_level = 800
				},
				versus_base = {
					power_level_glance = 800,
					power_level = 800
				}
			},
			camera_effect = {
				near_distance = 5,
				near_scale = 1,
				shake_name = "frag_grenade_explosion",
				far_scale = 0.25,
				far_distance = 30
			}
		}
	}
}
