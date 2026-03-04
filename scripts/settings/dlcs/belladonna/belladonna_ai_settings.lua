-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_ai_settings.lua

local var_0_0 = DLCSettings.belladonna

var_0_0.breeds = {
	"scripts/settings/breeds/breed_beastmen_gor",
	"scripts/settings/breeds/breed_beastmen_ungor",
	"scripts/settings/breeds/breed_beastmen_ungor_archer",
	"scripts/settings/breeds/breed_beastmen_bestigor",
	"scripts/settings/breeds/breed_beastmen_standard_bearer"
}
var_0_0.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_gor",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_ungor",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_ungor_archer",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_bestigor",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_standard_bearer",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_beastmen_dummy"
}
var_0_0.behaviour_tree_nodes = {
	"scripts/entity_system/systems/behaviour/nodes/bt_charge_attack_action",
	"scripts/entity_system/systems/behaviour/nodes/bt_fire_projectile_action",
	"scripts/entity_system/systems/behaviour/nodes/bt_pick_up_standard_action",
	"scripts/entity_system/systems/behaviour/nodes/bt_place_standard_action",
	"scripts/entity_system/systems/behaviour/nodes/bt_defend_standard_action"
}
var_0_0.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_gor_behavior",
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_ungor_behavior",
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_ungor_archer_behavior",
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_bestigor_behavior",
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_standard_bearer_behavior",
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_dummy_behavior"
}
var_0_0.health_extension_files = {
	"scripts/unit_extensions/health/beastmen_standard_health_extension"
}
var_0_0.health_extensions = {
	"BeastmenStandardHealthExtension"
}
var_0_0.enemy_package_loader_breed_categories = {
	specials = {
		"beastmen_standard_bearer"
	}
}
var_0_0.alias_to_breed = {
	beastmen_ungor_dummy = "beastmen_ungor",
	beastmen_bestigor_dummy = "beastmen_bestigor",
	beastmen_gor_dummy = "beastmen_gor",
	beastmen_standard_bearer_crater = "beastmen_standard_bearer"
}
var_0_0.opt_lookup_breed_names = {
	beastmen_ungor = "beastmen_ungor_opt",
	beastmen_gor = "beastmen_gor_opt",
	beastmen_ungor_archer = "beastmen_ungor_archer_opt"
}
var_0_0.ai_breed_snippets_file_names = {
	"scripts/settings/dlcs/belladonna/belladonna_ai_breed_snippets"
}
var_0_0.animation_movement_templates_file_names = {
	"scripts/settings/dlcs/belladonna/belladonna_animation_movement_templates"
}
var_0_0.slot_templates_file_names = {
	"scripts/settings/dlcs/belladonna/belladonna_slot_templates"
}
var_0_0.utility_considerations_file_names = {
	"scripts/settings/dlcs/belladonna/belladonna_utility_considerations"
}
var_0_0.aim_templates_file_names = {
	"scripts/settings/dlcs/belladonna/belladonna_aim_templates"
}
var_0_0.network_sound_events = {
	"Play_enemy_beastmen_standar_chanting_loop",
	"Stop_enemy_beastmen_standar_chanting_loop",
	"Play_enemy_minotaur_charge_attack_miss",
	"Play_enemy_bestigor_charge_attack_miss",
	"Play_boss_aggro_enter"
}
var_0_0.anim_lookup = {
	"stagger_fwd_cheer_1",
	"stagger_fwd_cheer_2",
	"stagger_fwd_cheer_3",
	"stagger_fwd_cheer_4",
	"stagger_fwd_cheer_5",
	"start_charge",
	"charge_loop",
	"charge_impact",
	"charge_pre_lunge",
	"charge_lunge_short",
	"charge_lunge_medium",
	"charge_lunge_far",
	"charge_blocked",
	"charge_cancel",
	"stagger_left_charge",
	"stagger_right_charge",
	"stagger_bwd_charge",
	"attack_1h",
	"attack_1h_2",
	"attack_1h_3",
	"attack_headbutt",
	"attack_headbutt_2",
	"attack_move_hit",
	"to_standard_bearer",
	"place_standard",
	"pick_up_standard",
	"aim",
	"shoot",
	"attack_step",
	"attack_step_2",
	"attack_step_head",
	"attack_punch"
}

local var_0_1 = {
	sounds = {
		PLAYER_SPOTTED = "beastmen_patrol_player_spotted",
		FORMING = "beastmen_patrol_forming",
		FOLEY = "beastmen_patrol_foley",
		FORMATED = "beastmen_patrol_formated",
		FORMATE = "beastmen_patrol_formate",
		CHARGE = "beastmen_patrol_charge",
		VOICE = "beastmen_patrol_voice"
	},
	offsets = {
		ANCHOR_OFFSET = {
			x = 1.4,
			y = 0.6
		}
	},
	speeds = {
		FAST_WALK_SPEED = 2.6,
		MEDIUM_WALK_SPEED = 2.35,
		WALK_SPEED = 2.12,
		SPLINE_SPEED = 2.22,
		SLOW_SPLINE_SPEED = 0.1
	}
}

var_0_0.patrol_formation_settings = {
	default_beastmen_settings = var_0_1
}
var_0_0.patrol_formations = {
	beastmen_standard = {
		settings = var_0_1,
		normal = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			}
		},
		hard = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			}
		},
		harder = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			}
		},
		hardest = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			}
		},
		cataclysm = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			}
		}
	},
	beastmen_archers = {
		settings = var_0_1,
		normal = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			}
		},
		hard = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_bestigor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastman_ungor",
				"beastman_ungor"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			}
		},
		harder = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			}
		},
		hardest = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			}
		},
		cataclysm = {
			{
				"beastmen_standard_bearer"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_gor",
				"beastmen_gor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_bestigor",
				"beastmen_bestigor"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			},
			{
				"beastmen_ungor_archer",
				"beastmen_ungor_archer",
				"beastmen_ungor_archer"
			}
		}
	}
}
