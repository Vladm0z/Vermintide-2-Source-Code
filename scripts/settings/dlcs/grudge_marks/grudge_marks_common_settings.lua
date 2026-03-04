-- chunkname: @scripts/settings/dlcs/grudge_marks/grudge_marks_common_settings.lua

local var_0_0 = DLCSettings.grudge_marks

var_0_0.challenge_categories = {}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_grudge_marks"
}
var_0_0.statistics_lookup = {
	"grudge_mark_kills_we_thornsister",
	"grudge_mark_kills_we_shade",
	"grudge_mark_kills_bw_adept",
	"grudge_mark_kills_wh_captain",
	"grudge_mark_kills_wh_priest",
	"grudge_mark_kills_dr_ranger",
	"grudge_mark_kills_wh_bountyhunter",
	"grudge_mark_kills_es_questingknight",
	"grudge_mark_kills_we_maidenguard",
	"grudge_mark_kills_dr_ironbreaker",
	"grudge_mark_kills_es_knight",
	"grudge_mark_kills_dr_engineer",
	"grudge_mark_kills_es_huntsman",
	"grudge_mark_kills_dr_slayer",
	"grudge_mark_kills_es_mercenary",
	"grudge_mark_kills_bw_scholar",
	"grudge_mark_kills_bw_unchained"
}
var_0_0.anim_lookup = {}
var_0_0.effects = {
	"fx/grudge_marks_shadow_step",
	"fx/grudge_marks_illusionist"
}
var_0_0.unlock_settings = {}
var_0_0.material_effect_mappings_file_names = {
	"scripts/settings/material_effect_mappings_grudge_marks"
}
var_0_0.explosion_templates = {
	grudge_mark_shockwave = {
		explosion = {
			radius = 4.5,
			ai_friendly_fire = true,
			max_damage_radius = 4.5,
			catapult_players = true,
			sound_event_name = "Play_mutator_ticking_bomb_explosion",
			fatigue_type = "blocked_attack",
			alert_enemies_radius = 15,
			catapult_force_z = 3,
			catapult_blocked_multiplier = 0.2,
			catapult_force = 7.5,
			alert_enemies = true,
			damage_profile = "ai_shockwave",
			ignore_attacker_unit = true,
			effect_name = "fx/chr_kruber_shockwave",
			difficulty_power_level = {
				easy = {
					power_level_glance = 100,
					power_level = 200
				},
				normal = {
					power_level_glance = 100,
					power_level = 100
				},
				hard = {
					power_level_glance = 200,
					power_level = 200
				},
				harder = {
					power_level_glance = 300,
					power_level = 300
				},
				hardest = {
					power_level_glance = 400,
					power_level = 400
				},
				cataclysm = {
					power_level_glance = 300,
					power_level = 600
				},
				cataclysm_2 = {
					power_level_glance = 400,
					power_level = 800
				},
				cataclysm_3 = {
					power_level_glance = 500,
					power_level = 1000
				},
				versus_base = {
					power_level_glance = 200,
					power_level = 200
				}
			}
		}
	},
	grudge_mark_termite_shockwave = {
		explosion = {
			radius = 10,
			ai_friendly_fire = true,
			max_damage_radius = 10,
			catapult_players = true,
			sound_event_name = "Play_mutator_ticking_bomb_explosion",
			fatigue_type = "blocked_attack",
			alert_enemies_radius = 15,
			catapult_force_z = 3,
			catapult_blocked_multiplier = 0.2,
			catapult_force = 7.5,
			alert_enemies = true,
			damage_profile = "ai_shockwave",
			ignore_attacker_unit = true,
			effect_name = "fx/chr_kruber_shockwave",
			difficulty_power_level = {
				easy = {
					power_level_glance = 100,
					power_level = 200
				},
				normal = {
					power_level_glance = 100,
					power_level = 100
				},
				hard = {
					power_level_glance = 200,
					power_level = 200
				},
				harder = {
					power_level_glance = 300,
					power_level = 300
				},
				hardest = {
					power_level_glance = 400,
					power_level = 400
				},
				cataclysm = {
					power_level_glance = 300,
					power_level = 600
				},
				cataclysm_2 = {
					power_level_glance = 400,
					power_level = 800
				},
				cataclysm_3 = {
					power_level_glance = 500,
					power_level = 1000
				},
				versus_base = {
					power_level_glance = 200,
					power_level = 200
				}
			}
		}
	}
}
