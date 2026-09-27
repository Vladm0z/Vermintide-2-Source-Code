-- chunkname: @scripts/settings/breeds/breed_chaos_troll_chief.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")
local num = 1.5
local tbl = {
	ahead_dist = 1.5,
	push_width = 1.25,
	push_forward_offset = 1.5,
	push_stagger_distance = 1,
	player_pushed_speed = 7,
	push_stagger_impact = {
		scripts_utils_stagger_types.medium,
		scripts_utils_stagger_types.medium,
		scripts_utils_stagger_types.none,
		scripts_utils_stagger_types.none
	},
	push_stagger_duration = {
		1.5,
		1,
		0,
		0
	}
}
local tbl_2 = {
	ahead_dist = 2.5,
	push_width = 1.25,
	push_forward_offset = 1.5,
	push_stagger_distance = 1,
	player_pushed_speed = 9,
	push_stagger_impact = {
		scripts_utils_stagger_types.medium,
		scripts_utils_stagger_types.medium,
		scripts_utils_stagger_types.none,
		scripts_utils_stagger_types.none
	},
	push_stagger_duration = {
		1.5,
		1,
		0,
		0
	}
}
local BotConstants = BotConstants

BotConstants = not BotConstants and BotConstants.default.DEFAULT_BOT_THREAT_DIFFICULTY_DATA

local tbl_3 = {
	detection_radius = 9999999,
	target_selection = "pick_rat_ogre_target_idle",
	walk_speed = 4,
	big_boy_turning_dot = 0.4,
	radius = 2,
	patrol_detection_radius = 10,
	patrol_active_target_selection = "pick_rat_ogre_target_with_weights",
	regen_taken_damage_pause_time = 2,
	always_look_at_target = true,
	use_avoidance = false,
	animation_sync_rpc = "rpc_sync_anim_state_6",
	aoe_radius = 1,
	is_always_spawnable = true,
	ai_toughness = 10,
	scale_death_push = 1,
	proximity_system_check = true,
	regen_pulse_intensity = 0.05,
	initial_is_passive = false,
	ignore_nav_propagation_box = true,
	slot_template = "boss",
	bot_opportunity_target_melee_range = 7,
	wield_inventory_on_spawn = true,
	default_inventory_template = "chaos_troll_chief",
	stagger_resistance = 100,
	use_aggro = true,
	minion_detection_radius = 10,
	boss_staggers = true,
	lord_damage_reduction = true,
	panic_close_detection_radius_sq = 9,
	height = 3,
	poison_resistance = 100,
	boss = true,
	hit_mass_count = 50,
	patrol_active_perception = "perception_rat_ogre",
	animation_movement_template = "chaos_troll",
	race = "chaos",
	ai_strength = 10,
	death_reaction = "ai_default",
	armor_category = 3,
	stagger_threshold_medium = 1,
	stagger_threshold_heavy = 1,
	stagger_threshold_explosion = 1,
	regen_pulse_interval = 2,
	target_selection_angry = "pick_chaos_troll_target_with_weights",
	use_big_boy_turning = true,
	use_navigation_path_splines = true,
	exchange_order = 1,
	distance_sq_can_detect_target = 2025,
	downed_pulse_interval = 1,
	perception_continuous = "perception_continuous_chaos_troll",
	behavior = "troll_chief",
	bot_opportunity_target_melee_range_while_ranged = 5,
	bots_should_flank = true,
	boost_curve_multiplier_override = 1.8,
	downed_pulse_intensity = 0.2,
	bot_hitbox_radius_approximation = 1,
	far_vomit = "troll_chief_vomit",
	has_inventory = true,
	run_speed = 5.25,
	awards_positive_reinforcement_message = true,
	trigger_dialogue_on_target_switch = true,
	headshot_coop_stamina_fatigue_type = "headshot_special",
	threat_value = 32,
	combat_music_state = "troll",
	aim_template = "chaos_warrior",
	near_vomit = "troll_chief_vomit_near",
	passive_in_patrol_start_anim = "move_fwd",
	reach_distance = 4.2,
	navigation_spline_distance_to_borders = 1,
	stagger_threshold_light = 1,
	show_health_bar = true,
	reflect_regen_reduction_in_hp_bar = true,
	keep_weapon_on_death = false,
	hit_reaction = "ai_default",
	passive_in_patrol = true,
	patrol_passive_target_selection = "patrol_passive_target_selection",
	bone_lod_level = 0,
	is_bot_aid_threat = true,
	hit_effect_template = "HitEffectsChaosTroll",
	unit_template = "ai_unit_chaos_troll",
	catch_up_speed = 10,
	smart_object_template = "chaos_troll",
	has_running_attack = true,
	dialogue_target_switch_event = "enemy_target_changed",
	no_stagger_duration = false,
	perception = "perception_rat_ogre",
	player_locomotion_constrain_radius = 1.5,
	husk_hit_reaction_cooldown = 1,
	dialogue_target_switch_attack_tag = "chaos_troll_target_changed",
	distance_sq_idle_auto_detect_target = 49,
	far_off_despawn_immunity = true,
	patrol_passive_perception = "perception_rat_ogre",
	base_unit = "units/beings/enemies/chaos_troll_chief/chr_chaos_troll_chief",
	aoe_height = 2.4,
	displace_players_data = tbl,
	infighting = InfightingSettings.boss,
	perception_weights = {
		target_catapulted_mul = 2,
		target_stickyness_bonus_b = 10,
		targeted_by_other_special = -10,
		target_staggered_you_bonus = 100,
		target_stickyness_duration_b = 5,
		aggro_decay_per_sec = 4,
		target_outside_navmesh_mul = 0.5,
		old_target_aggro_mul = 0.5,
		target_is_in_vomit_multiplier = 10,
		target_disabled_aggro_mul = 0,
		target_stickyness_duration_a = 3,
		max_distance = 10,
		target_stickyness_bonus_a = 50,
		distance_weight = 10,
		target_disabled_mul = 0
	},
	size_variation_range = {
		1 * num,
		1 * num
	},
	max_health = BreedTweaks.max_health.chaos_troll_chief,
	bloodlust_health = BreedTweaks.bloodlust_health.monster,
	stagger_duration = {
		0,
		0,
		0,
		0,
		0,
		2.5,
		0,
		1
	},
	max_health_regen_per_sec = {
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2
	},
	max_health_regen_time = {
		12,
		12,
		10,
		8,
		6,
		4,
		3,
		2
	},
	bot_melee_aim_node = {
		"j_leftleg",
		"j_rightleg",
		"j_hips",
		"j_head"
	},
	status_effect_settings = {
		category = "large",
		ignored_statuses = table.set({
			StatusEffectNames.burning_warpfire
		})
	},
	boss_health_ui_boss_phase_func = function (arg_1_0)
		-- function 1
		local has_extension = ScriptUnit.has_extension(arg_1_0, "health_system")

		if not has_extension then
			return
		end

		local extension = ScriptUnit.extension(arg_1_0, "buff_system")
		local time = Managers.time:time("game")
		local get_buff_type = extension:get_buff_type("troll_chief_downed_regen")

		if not (not get_buff_type and has_extension.state ~= "down") then
			local num = time - get_buff_type.start_time
			local num_2 = AiUtils.downed_duration(BreedActions.chaos_troll_chief.downed) - num

			if num_2 > 0 then
				return "chaos_troll_chief_regenerating", num_2
			end
		end

		local get_buff_type_2 = extension:get_buff_type("troll_chief_on_downed_wounded")

		if not get_buff_type_2 then
			local num_3 = time - get_buff_type_2.start_time
			local num_4 = get_buff_type_2.duration - num_3

			if num_4 > 0 then
				return "chaos_troll_chief_raging", num_4
			end
		end

		if extension:num_buff_stacks("sorcerer_tether_buff_invulnerability") > 0 then
			return "chaos_troll_chief_protected", nil
		end
	end,
	debug_color = {
		255,
		20,
		20,
		20
	},
	run_on_spawn = AiBreedSnippets.on_chaos_troll_chief_spawn,
	run_on_update = AiBreedSnippets.on_chaos_troll_chief_update,
	run_on_death = AiBreedSnippets.on_chaos_troll_chief_death,
	run_on_despawn = AiBreedSnippets.on_chaos_troll_chief_despawn,
	blackboard_init_data = {
		ladder_distance = math.huge
	},
	hitzone_multiplier_types = {
		head = "headshot"
	},
	hit_zones = {
		head = {
			prio = 1,
			actors = {
				"c_head"
			},
			push_actors = {
				"j_head",
				"j_spine1"
			}
		},
		neck = {
			prio = 1,
			actors = {
				"c_neck"
			},
			push_actors = {
				"j_head",
				"j_spine1"
			}
		},
		torso = {
			prio = 2,
			actors = {
				"c_spine",
				"c_spine1",
				"c_hips",
				"c_leftshoulder",
				"c_rightshoulder"
			},
			push_actors = {
				"j_spine1",
				"j_hips"
			}
		},
		left_arm = {
			prio = 3,
			actors = {
				"c_leftarm",
				"c_leftforearm",
				"c_lefthand"
			},
			push_actors = {
				"j_leftarm",
				"j_leftforearm",
				"j_lefthand"
			}
		},
		right_arm = {
			prio = 3,
			actors = {
				"c_rightarm",
				"c_rightforearm",
				"c_righthand"
			},
			push_actors = {
				"j_rightarm",
				"j_rightforearm",
				"j_righthand"
			}
		},
		left_leg = {
			prio = 3,
			actors = {
				"c_leftupleg",
				"c_leftleg",
				"c_leftfoot"
			},
			push_actors = {
				"j_leftupleg",
				"j_leftleg",
				"j_leftfoot"
			}
		},
		right_leg = {
			prio = 3,
			actors = {
				"c_rightupleg",
				"c_rightleg",
				"c_rightfoot"
			},
			push_actors = {
				"j_rightupleg",
				"j_rightleg",
				"j_rightfoot"
			}
		},
		full = {
			prio = 4,
			actors = {}
		},
		afro = {
			prio = 5,
			actors = {
				"afro"
			}
		}
	},
	allowed_layers = {
		ledges = 1.5,
		ledges_with_fence = 1.5,
		big_boy_destructible = 1.5,
		jumps = 1.5,
		destructible_wall = 0,
		temporary_wall = 0,
		bot_ratling_gun_fire = 15,
		doors = 1.5,
		teleporters = 5,
		planks = 1.5,
		fire_grenade = 15
	},
	nav_cost_map_allowed_layers = {
		plague_wave = 1,
		troll_bile = 1,
		lamp_oil_fire = 15,
		warpfire_thrower_warpfire = 1,
		vortex_near = 1,
		stormfiend_warpfire = 1,
		vortex_danger_zone = 1
	},
	custom_death_enter_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		-- function 2
		local var_2_0 = BLACKBOARDS[arg_2_0]

		if not Unit.alive(arg_2_1) then
			return
		end

		QuestSettings.check_chaos_troll_killed_without_regen(var_2_0, arg_2_1)
		QuestSettings.check_chaos_troll_killed_without_bile_damage(var_2_0, arg_2_1)
	end
}

Breeds.chaos_troll_chief = table.create_copy(Breeds.chaos_troll_chief, tbl_3)

local tbl_4 = {
	cleave = {
		easy = {
			running = 2,
			normal = 5
		},
		normal = {
			running = 2,
			normal = 5
		},
		hard = {
			running = 2,
			normal = 5
		},
		harder = {
			running = 2,
			normal = 5
		},
		hardest = {
			running = 2,
			normal = 5
		},
		cataclysm = {
			running = 2,
			normal = 5
		},
		cataclysm_2 = {
			running = 2,
			normal = 5
		},
		cataclysm_3 = {
			running = 2,
			normal = 5
		},
		versus_base = {
			running = 2,
			normal = 5
		}
	},
	sweep = {
		easy = {
			running = 2,
			normal = 5
		},
		normal = {
			running = 2,
			normal = 5
		},
		hard = {
			running = 2,
			normal = 5
		},
		harder = {
			running = 2,
			normal = 5
		},
		hardest = {
			running = 2,
			normal = 5
		},
		cataclysm = {
			running = 2,
			normal = 5
		},
		cataclysm_2 = {
			running = 2,
			normal = 5
		},
		cataclysm_3 = {
			running = 2,
			normal = 5
		},
		versus_base = {
			running = 2,
			normal = 5
		}
	},
	shove = {
		easy = {
			normal = 1
		},
		normal = {
			normal = 1
		},
		hard = {
			normal = 1
		},
		harder = {
			normal = 1
		},
		hardest = {
			normal = 1
		},
		cataclysm = {
			normal = 1
		},
		cataclysm_2 = {
			normal = 1
		},
		cataclysm_3 = {
			normal = 1
		},
		versus_base = {
			normal = 1
		}
	},
	vomit = {
		easy = {
			running = 0.5,
			normal = 3
		},
		normal = {
			running = 0.5,
			normal = 3
		},
		hard = {
			running = 0.5,
			normal = 3
		},
		harder = {
			running = 0.5,
			normal = 3
		},
		hardest = {
			running = 0.5,
			normal = 3
		},
		cataclysm = {
			running = 0.5,
			normal = 3
		},
		cataclysm_2 = {
			running = 0.5,
			normal = 3
		},
		cataclysm_3 = {
			running = 0.5,
			normal = 3
		},
		versus_base = {
			running = 0.5,
			normal = 3
		}
	}
}
local tbl_5 = {
	follow = {
		follow_target_function_name = "_follow_target_rat_ogre",
		override_move_speed = 4.25,
		move_anim = "move_start_fwd",
		action_weight = 1,
		considerations = UtilityConsiderations.troll_follow,
		start_anims_name = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right"
		},
		start_anims_data = {
			move_start_fwd = {},
			move_start_bwd = {
				dir = -1,
				rad = math.pi
			},
			move_start_left = {
				dir = 1,
				rad = math.pi / 2
			},
			move_start_right = {
				dir = -1,
				rad = math.pi / 2
			}
		},
		init_blackboard = {
			chasing_timer = -10
		}
	},
	follow_crouching = {
		follow_target_function_name = "_follow_target_rat_ogre",
		move_anim = "move_start_fwd",
		action_weight = 1,
		override_move_speed = 4,
		crouching = true,
		considerations = UtilityConsiderations.troll_follow,
		start_anims_name = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right"
		},
		start_anims_data = {
			move_start_fwd = {},
			move_start_bwd = {
				dir = -1,
				rad = math.pi
			},
			move_start_left = {
				dir = 1,
				rad = math.pi / 2
			},
			move_start_right = {
				dir = -1,
				rad = math.pi / 2
			}
		},
		init_blackboard = {
			chasing_timer = -10
		}
	},
	smash_door = {
		unblockable = true,
		name = "smash_door",
		damage = 25,
		damage_type = "cutting",
		move_anim = "move_start_fwd",
		attack_anim = "smash_door",
		door_attack_distance = 2
	},
	attack_cleave = {
		blocked_damage = 15,
		damage = 30,
		fatigue_type = "chaos_cleave",
		allow_friendly_fire = true,
		target_running_velocity_threshold = 1,
		attack_intensity_type = "cleave",
		action_weight = 1,
		damage_type = "cutting",
		target_running_distance_threshold = 4.5,
		difficulty_attack_intensity = tbl_4,
		considerations = UtilityConsiderations.troll_chief_cleave,
		attacks = {
			{
				offset_forward = 1.1,
				ignores_dodging = true,
				rotation_time = 1.7,
				anim_driven = false,
				offset_up = 0,
				player_push_speed = 8,
				damage_done_time = 1.5333333333333334,
				hit_multiple_targets = true,
				player_push_speed_blocked = 8,
				attack_time = 2.6666666666666665,
				width = 1.75,
				multi_attack_anims = {
					fwd = "attack_cleave",
					left = "attack_cleave_left",
					right = "attack_cleave_right"
				},
				multi_anims_data = {
					attack_cleave = {},
					attack_cleave_left = {
						dir = 1,
						rad = math.pi / 2
					},
					attack_cleave_right = {
						dir = -1,
						rad = math.pi / 2
					}
				},
				attack_anim = {
					"attack_cleave"
				},
				range = 2.75 * num,
				height = 2.5 * num,
				push_units_in_the_way = tbl,
				bot_threats = {
					{
						duration = 0.6666666666666666,
						start_time = 0.8333333333333334
					}
				}
			}
		},
		running_attacks = {
			{
				offset_forward = 1,
				rotation_speed = 8,
				ignores_dodging = false,
				rotation_time = 2.2,
				anim_driven = true,
				offset_up = 0,
				player_push_speed = 8,
				damage_done_time = 1.4333333333333333,
				hit_multiple_targets = true,
				player_push_speed_blocked = 8,
				attack_time = 2.6666666666666665,
				width = 1.75,
				attack_anim = {
					"attack_move_cleave"
				},
				range = 2.75 * num,
				height = 2.5 * num,
				push_units_in_the_way = tbl_2,
				bot_threats = {
					{
						duration = 0.6666666666666666,
						start_time = 0.9
					}
				}
			}
		},
		difficulty_damage = BreedTweaks.difficulty_damage.boss_slam_attack,
		blocked_difficulty_damage = BreedTweaks.difficulty_damage.boss_slam_attack_blocked,
		ignore_staggers = {
			true,
			false,
			false,
			true,
			true,
			false
		}
	},
	attack_crouch_sweep = {
		fatigue_type = "ogre_shove",
		damage_type = "cutting",
		damage = 8,
		cooldown = -1,
		allow_friendly_fire = true,
		attack_intensity_type = "sweep",
		action_weight = 1,
		difficulty_attack_intensity = tbl_4,
		considerations = UtilityConsiderations.attack_crouch_sweep,
		attacks = {
			{
				anim_driven = false,
				height = 2,
				hit_only_players = false,
				ignore_targets_behind = true,
				ignores_dodging = true,
				rotation_time = 1,
				freeze_intensity_decay_time = 15,
				catapult_player = true,
				offset_forward = 0,
				player_push_speed_blocked_z = 4,
				offset_up = 0,
				player_push_speed_z = 4,
				range = 2,
				player_push_speed = 16,
				damage_done_time = 1.3333333333333333,
				hit_multiple_targets = true,
				player_push_speed_blocked = 12.8,
				attack_time = 2.3333333333333335,
				width = 0.4,
				attack_anim = {
					"attack_sweep",
					"attack_shove"
				},
				continious_overlap = {
					attack_sweep = {
						base_node_name = "j_leftforearm",
						tip_node_name = "j_lefthand",
						start_time = 0.6666666666666666
					},
					attack_shove = {
						base_node_name = "j_rightforearm",
						tip_node_name = "j_righthand",
						start_time = 0.6666666666666666
					}
				},
				push_ai = {
					stagger_distance = 3,
					stagger_impact = {
						scripts_utils_stagger_types.explosion,
						scripts_utils_stagger_types.heavy,
						scripts_utils_stagger_types.none,
						scripts_utils_stagger_types.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = BotConstants,
				bot_threats = {
					{
						collision_type = "cylinder",
						offset_forward = 0,
						radius = 3.5,
						height = 3.5,
						offset_right = 0,
						offset_up = 0,
						duration = 0.7333333333333333,
						start_time = 0.6
					}
				}
			}
		},
		difficulty_damage = BreedTweaks.difficulty_damage.boss_slam_attack,
		ignore_staggers = {
			true,
			false,
			false,
			true,
			true,
			false
		}
	},
	melee_shove = {
		fatigue_type = "ogre_shove",
		damage = 8,
		damage_type = "cutting",
		allow_friendly_fire = true,
		target_running_velocity_threshold = 0.75,
		attack_intensity_type = "shove",
		action_weight = 1,
		ignore_ai_damage = true,
		self_running_speed_threshold = 2,
		target_running_distance_threshold = 4,
		difficulty_attack_intensity = tbl_4,
		considerations = UtilityConsiderations.troll_chief_melee_shove,
		attacks = {
			{
				rotation_speed = 7,
				hit_only_players = false,
				catapult_player = true,
				ignores_dodging = false,
				rotation_time = 0.6,
				freeze_intensity_decay_time = 15,
				anim_driven = false,
				offset_forward = 0.5,
				player_push_speed_blocked_z = 4,
				offset_up = 0.5,
				player_push_speed_z = 4,
				ignore_targets_behind = true,
				player_push_speed = 16,
				hit_multiple_targets = true,
				player_push_speed_blocked = 12.8,
				attack_time = 1.6666666666666667,
				attack_anim = {
					"attack_shove"
				},
				damage_done_time = {
					attack_shove = 0.9
				},
				range = 0.7 * num,
				height = 0.8 * num * 2,
				width = 0.8 * num,
				continious_overlap = {
					attack_shove = {
						base_node_name = "j_rightforearm",
						tip_node_name = "j_righthand",
						start_time = 0.7
					}
				},
				push_ai = {
					stagger_distance = 3,
					stagger_impact = {
						scripts_utils_stagger_types.explosion,
						scripts_utils_stagger_types.heavy,
						scripts_utils_stagger_types.none,
						scripts_utils_stagger_types.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = BotConstants,
				bot_threats = {
					{
						collision_type = "cylinder",
						offset_forward = 0.5,
						radius = 4,
						height = 3.5,
						offset_right = 0.25,
						offset_up = 0.5,
						duration = 0.9333333333333333,
						start_time = 0.16666666666666666
					}
				}
			}
		},
		running_attacks = {
			{
				rotation_speed = 1.5,
				hit_only_players = false,
				catapult_player = true,
				ignores_dodging = false,
				rotation_time = 1,
				freeze_intensity_decay_time = 15,
				anim_driven = true,
				offset_forward = 1.2,
				player_push_speed_blocked_z = 4,
				offset_up = 0.5,
				player_push_speed_z = 4,
				ignore_targets_behind = true,
				player_push_speed = 16,
				hit_multiple_targets = true,
				player_push_speed_blocked = 12.8,
				attack_time = 2,
				attack_anim = {
					"attack_pounce"
				},
				damage_done_time = {
					attack_pounce = 1.0333333333333334
				},
				range = 0.7 * num,
				height = 0.9 * num * 2,
				width = 1.1 * num,
				continious_overlap = {
					attack_pounce = {
						base_node_name = "j_rightforearm",
						tip_node_name = "j_righthand",
						start_time = 0.6
					}
				},
				push_ai = {
					stagger_distance = 3,
					stagger_impact = {
						scripts_utils_stagger_types.explosion,
						scripts_utils_stagger_types.heavy,
						scripts_utils_stagger_types.none,
						scripts_utils_stagger_types.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = BotConstants,
				bot_threats = {
					{
						collision_type = "cylinder",
						offset_forward = 5,
						radius = 3,
						height = 3.7,
						offset_right = 0,
						offset_up = 0,
						duration = 0.9333333333333333,
						start_time = 0.16666666666666666
					}
				}
			}
		},
		difficulty_damage = BreedTweaks.difficulty_damage.boss_slam_attack
	},
	melee_sweep = {
		target_running_velocity_threshold = 0.75,
		fatigue_type = "ogre_shove",
		damage_type = "cutting",
		target_running_distance_threshold = 4,
		damage = 8,
		allow_friendly_fire = true,
		attack_intensity_type = "sweep",
		action_weight = 1,
		blocked_damage = 2,
		ignore_ai_damage = true,
		self_running_speed_threshold = 2,
		difficulty_attack_intensity = tbl_4,
		considerations = UtilityConsiderations.troll_chief_melee_sweep,
		attacks = {
			{
				rotation_speed = 7,
				hit_only_players = false,
				catapult_player = true,
				ignores_dodging = true,
				rotation_time = 0.6,
				freeze_intensity_decay_time = 15,
				anim_driven = false,
				offset_forward = 1,
				player_push_speed_blocked_z = 4,
				offset_up = 0.5,
				player_push_speed_z = 4,
				ignore_targets_behind = true,
				player_push_speed = 16,
				hit_multiple_targets = true,
				player_push_speed_blocked = 12.8,
				attack_time = 1.6666666666666667,
				attack_anim = {
					"attack_sweep"
				},
				damage_done_time = {
					attack_sweep = 1
				},
				range = 0.8 * num,
				height = 0.8 * num * 2,
				width = 1.1 * num,
				continious_overlap = {
					attack_sweep = {
						base_node_name = "j_leftforearm",
						tip_node_name = "j_lefthand",
						start_time = 0.6666666666666666
					}
				},
				push_ai = {
					stagger_distance = 3,
					stagger_impact = {
						scripts_utils_stagger_types.explosion,
						scripts_utils_stagger_types.heavy,
						scripts_utils_stagger_types.none,
						scripts_utils_stagger_types.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = BotConstants,
				bot_threats = {
					{
						collision_type = "cylinder",
						offset_forward = 0,
						radius = 5,
						height = 3.5,
						offset_right = -0.5,
						offset_up = 0,
						duration = 0.9333333333333333,
						start_time = 0.16666666666666666
					}
				}
			}
		},
		running_attacks = {
			{
				rotation_speed = 12,
				hit_only_players = false,
				catapult_player = true,
				ignores_dodging = false,
				rotation_time = 1,
				freeze_intensity_decay_time = 15,
				anim_driven = true,
				offset_forward = 1.8,
				player_push_speed_blocked_z = 4,
				offset_up = 0.3,
				player_push_speed_z = 4,
				ignore_targets_behind = true,
				player_push_speed = 16,
				hit_multiple_targets = true,
				player_push_speed_blocked = 12.8,
				attack_time = 2,
				attack_anim = {
					"attack_move_sweep"
				},
				damage_done_time = {
					attack_move_sweep = 1
				},
				range = 1 * num,
				height = 0.9 * num * 2,
				width = 1.4 * num,
				continious_overlap = {
					attack_move_sweep = {
						base_node_name = "j_leftforearm",
						tip_node_name = "j_lefthand",
						start_time = 0.6666666666666666
					}
				},
				push_ai = {
					stagger_distance = 3,
					stagger_impact = {
						scripts_utils_stagger_types.explosion,
						scripts_utils_stagger_types.heavy,
						scripts_utils_stagger_types.none,
						scripts_utils_stagger_types.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = BotConstants,
				bot_threats = {
					{
						collision_type = "cylinder",
						offset_forward = 4,
						radius = 5,
						height = 3.7,
						offset_right = 0,
						offset_up = 0,
						duration = 0.9333333333333333,
						start_time = 0.16666666666666666
					}
				}
			}
		},
		difficulty_damage = BreedTweaks.difficulty_damage.boss_slam_attack,
		blocked_difficulty_damage = BreedTweaks.difficulty_damage.boss_slam_attack_blocked
	},
	vomit = {
		firing_time = 0.77,
		rotation_time = 0.8,
		attack_intensity_type = "vomit",
		action_weight = 1,
		near_vomit_distance = 25,
		attack_time = 2.5,
		difficulty_attack_intensity = tbl_4,
		considerations = UtilityConsiderations.troll_chief_vomit,
		attack_anims = {
			ranged_vomit = "attack_vomit_high",
			near_vomit = "attack_vomit"
		},
		bot_threat_difficulty_data = BotConstants,
		bot_threats = {
			{
				height = 3,
				range = 8,
				offset_forward = 1,
				duration = 1,
				offset_up = 0,
				width = 2.5,
				start_time = 0.7333333333333333
			}
		}
	},
	target_rage = {
		rage_time = 0.75,
		start_anims_name = {
			bwd = "change_target_bwd",
			fwd = "change_target_fwd",
			left = "change_target_left",
			right = "change_target_right"
		},
		start_anims_data = {
			change_target_fwd = {},
			change_target_bwd = {
				dir = -1,
				rad = math.pi
			},
			change_target_left = {
				dir = 1,
				rad = math.pi / 2
			},
			change_target_right = {
				dir = -1,
				rad = math.pi / 2
			}
		}
	},
	target_unreachable = {
		move_anim = "move_start_fwd"
	},
	climb = {
		catapult_players = {
			speed = 7,
			radius = 2,
			collision_filter = "filter_player_hit_box_check",
			angle = math.pi / 6
		}
	},
	downed_sequence = {
		action_weight = 20
	},
	downed = {
		rage_explosion_template = "troll_chief_rage_explosion",
		rage_buff_on_wounded = "troll_chief_on_downed_wounded",
		respawn_hp_chunk_percent = 0,
		min_downed_duration = 3,
		freeze_healing = true,
		standup_anim_duration = 5,
		reset_duration = 0,
		reset_health_on_fail = true,
		buff_during_stand_up = "troll_chief_healing_immune",
		remove_leaving_buff_on_enter = true,
		downed_buff = "troll_chief_downed",
		reduce_hp_permanently = true,
		fixed_hp_chunks = 3,
		puke_on_downed = false,
		downed_duration = {
			120,
			120,
			90,
			75,
			75,
			75,
			75,
			75
		},
		downed_chunk_events = {
			[{
				1,
				2
			}] = {
				start = function (arg_3_0, arg_3_1, arg_3_2)
					-- function 3
					local tbl = {}

					arg_3_1.chunk_event_socket_handles = tbl
					arg_3_1.chunk_event_socket_units = {}
					arg_3_1.chunk_event_fused_units = {}

					local phase_one_buffs = arg_3_1.phase_one_buffs

					phase_one_buffs = phase_one_buffs or {}
					arg_3_1.phase_one_buffs = phase_one_buffs

					local get_difficulty = Managers.state.difficulty:get_difficulty()
					local tbl_2 = {
						hardest = 4,
						hard = 3,
						harder = 3,
						default = 4,
						cataclysm = 4,
						normal = 2
					}
					local var_3_4 = tbl_2[get_difficulty]

					var_3_4 = var_3_4 or tbl_2.default

					local num = 1.75
					local num_2 = 2
					local str = "units/gameplay/explosive_oil_jug_socket_01"
					local local_position = Unit.local_position(arg_3_0, 0)
					local local_rotation = Unit.local_rotation(arg_3_0, 0)
					local right = Quaternion.right(local_rotation)
					local forward = Quaternion.forward(local_rotation)
					local num_3 = local_position - right * num
					local num_4 = local_position + right * num
					local num_5 = local_position + forward * num
					local num_6 = local_position - forward * num
					local tbl_3 = {}
					local nav_world = Managers.state.entity:system("ai_system"):nav_world()
					local ceil = math.ceil(var_3_4 * 0.5)

					for i = 1, ceil do
						local num_7

						if ceil > 1 then
							num_7 = num_2 / ((ceil - 1) * 0.5)

							if not num_7 then
								-- Nothing
							end
						end

						num_7 = 0

						::label_3_0::

						local num_8 = (i - 1 - (ceil - 1) * 0.5) * num_7 * 0.5
						local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, num_3 + forward * num_8, 1, 1)

						if not pos_on_mesh then
							tbl[#tbl + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(str, "explosive_barrel_socket", tbl_3, pos_on_mesh)
						else
							var_3_4 = var_3_4 + 1
						end
					end

					local num_9 = var_3_4 - ceil

					for j = 1, num_9 do
						local num_10

						if num_9 > 1 then
							num_10 = num_2 / ((num_9 - 1) * 0.5)

							if not num_10 then
								-- Nothing
							end
						end

						num_10 = 0

						::label_3_1::

						local num_11 = (j - 1 - (num_9 - 1) * 0.5) * num_10 * 0.5
						local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, num_4 + forward * num_11, 1, 1)

						if not pos_on_mesh_2 then
							tbl[#tbl + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(str, "explosive_barrel_socket", tbl_3, pos_on_mesh_2)
						else
							var_3_4 = var_3_4 + 1
						end
					end

					local num_12 = var_3_4 - ceil - num_9

					for k = 1, num_12 do
						local num_13

						if num_12 > 1 then
							num_13 = num_2 / ((num_12 - 1) * 0.5)

							if not num_13 then
								-- Nothing
							end
						end

						num_13 = 0

						::label_3_2::

						local num_14 = (k - 1 - (num_12 - 1) * 0.5) * num_13 * 0.5
						local pos_on_mesh_3 = LocomotionUtils.pos_on_mesh(nav_world, num_5 + right * num_14, 1, 1)

						if not pos_on_mesh_3 then
							tbl[#tbl + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(str, "explosive_barrel_socket", tbl_3, pos_on_mesh_3)
						else
							var_3_4 = var_3_4 + 1
						end
					end

					local num_15 = var_3_4 - ceil - num_9 - num_12

					for l = 1, num_15 do
						local num_16

						if num_15 > 1 then
							num_16 = num_2 / ((num_15 - 1) * 0.5)

							if not num_16 then
								-- Nothing
							end
						end

						num_16 = 0

						::label_3_3::

						local num_17 = (l - 1 - (num_15 - 1) * 0.5) * num_16 * 0.5
						local pos_on_mesh_4 = LocomotionUtils.pos_on_mesh(nav_world, num_6 + right * num_17, 1, 1)

						if not pos_on_mesh_4 then
							tbl[#tbl + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(str, "explosive_barrel_socket", tbl_3, pos_on_mesh_4)
						end
					end

					local count = #tbl

					local function fn()
						-- function 4
						local tbl = {
							tutorial_system = {
								always_show = true
							}
						}
						local system = Managers.state.entity:system("pickup_system")
						local boss_barrel_spawn = system.triggered_pickup_spawners.boss_barrel_spawn

						if not boss_barrel_spawn then
							boss_barrel_spawn = table.shallow_copy(boss_barrel_spawn)

							table.shuffle(boss_barrel_spawn)
						end

						local flag = not boss_barrel_spawn and #boss_barrel_spawn

						for i = 1, count do
							local local_position

							if not boss_barrel_spawn then
								local_position = Unit.local_position(boss_barrel_spawn[math.index_wrapper(i, flag)], 0)

								if not local_position then
									-- Nothing
								end
							end

							local_position = Unit.local_position(arg_3_0, 0)

							::label_4_0::

							if not local_position then
								local axis_angle = Quaternion.axis_angle(Vector3.up(), math.random() * math.tau)
								local multiply = Quaternion.multiply(Quaternion.axis_angle(Vector3.right(), math.random() * math.tau), axis_angle)
								local multiply_2 = Quaternion.multiply(Quaternion.axis_angle(Vector3.forward(), math.random() * math.tau), multiply)
								local spawn_pickup = system:spawn_pickup("lamp_oil", local_position, multiply_2, false, "triggered", nil, "explosive_pickup_projectile_unit", tbl)

								ScriptUnit.extension(spawn_pickup, "tutorial_system"):set_active(true)
							end
						end
					end

					Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)
				end,
				update = function (arg_5_0, arg_5_1, arg_5_2)
					-- function 5
					local num = 2
					local chunk_size = ScriptUnit.extension(arg_5_0, "health_system"):chunk_size()
					local total_part_of_chunk = BuffTemplates.troll_chief_barrel_exploded.buffs[1].total_part_of_chunk
					local count = #arg_5_1.chunk_event_socket_units
					local num_2 = chunk_size / count * total_part_of_chunk
					local chunk_event_socket_handles = arg_5_1.chunk_event_socket_handles
					local chunk_event_socket_units = arg_5_1.chunk_event_socket_units

					for i = #chunk_event_socket_handles, 1, -1 do
						local try_claim_async_unit = Managers.state.unit_spawner:try_claim_async_unit(chunk_event_socket_handles[i])

						if not try_claim_async_unit then
							chunk_event_socket_units[#chunk_event_socket_units + 1] = try_claim_async_unit

							table.swap_delete(chunk_event_socket_handles, i)

							local num_3 = #chunk_event_socket_units + #chunk_event_socket_handles
							local num_4 = BuffTemplates.troll_chief_phase_one_damage_reduction.buffs[1].total_multiplier / num_3
							local system = Managers.state.entity:system("buff_system")

							arg_5_1.phase_one_buffs[try_claim_async_unit] = system:add_buff_synced(arg_5_0, "troll_chief_phase_one_damage_reduction", BuffSyncType.All, {
								external_optional_multiplier = num_4
							})
						end
					end

					local chunk_event_fused_units = arg_5_1.chunk_event_fused_units

					for j = 1, #chunk_event_socket_units do
						local var_5_12 = chunk_event_socket_units[j]
						local extension = ScriptUnit.extension(var_5_12, "objective_socket_system")

						if not chunk_event_fused_units[var_5_12] then
							if extension:socket_from_id(1).open == false then
								Unit.flow_event(chunk_event_socket_units[j], "fuse_light")

								chunk_event_fused_units[var_5_12] = arg_5_2 + num
							end
						elseif arg_5_2 > chunk_event_fused_units[var_5_12] then
							local function fn()
								-- function 6
								if not chunk_event_fused_units[var_5_12] and not HEALTH_ALIVE[arg_5_0] then
									Unit.flow_event(chunk_event_socket_units[j], "force_explode")

									local extension = ScriptUnit.extension(arg_5_0, "buff_system")
									local var_6_1 = arg_5_1.phase_one_buffs[var_5_12]

									extension:remove_buff(var_6_1)

									arg_5_1.phase_one_buffs[var_5_12] = nil

									DamageUtils.add_damage_network(arg_5_0, arg_5_0, num_2, "torso", "forced", nil, Vector3(0, 0, 1), "life_tap", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
									Managers.state.entity:system("buff_system"):add_buff_synced(arg_5_0, "troll_chief_barrel_exploded", BuffSyncType.All, {
										external_optional_multiplier = -1 / count
									})
								end
							end

							Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)

							chunk_event_fused_units[var_5_12] = math.huge
						end
					end
				end,
				before_down_end = function (arg_7_0, arg_7_1)
					-- function 7
					local chunk_size = ScriptUnit.extension(arg_7_0, "health_system"):chunk_size()
					local total_part_of_chunk = BuffTemplates.troll_chief_barrel_exploded.buffs[1].total_part_of_chunk
					local count = #arg_7_1.chunk_event_socket_units
					local num = chunk_size / count * total_part_of_chunk
					local extension = ScriptUnit.extension(arg_7_0, "buff_system")

					for k, v in pairs(arg_7_1.phase_one_buffs) do
						extension:remove_buff(v)

						arg_7_1.phase_one_buffs[k] = nil
					end

					local chunk_event_fused_units = arg_7_1.chunk_event_fused_units

					for k_2, v_2 in pairs(chunk_event_fused_units) do
						if v_2 ~= math.huge then
							Unit.flow_event(k_2, "force_explode")
							DamageUtils.add_damage_network(arg_7_0, arg_7_0, num, "torso", "life_tap", nil, Vector3(0, 0, 1), "debug", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
							Managers.state.entity:system("buff_system"):add_buff_synced(arg_7_0, "troll_chief_barrel_exploded", BuffSyncType.All, {
								external_optional_multiplier = -1 / count
							})
						end
					end
				end,
				finish = function (arg_8_0, arg_8_1, arg_8_2)
					-- function 8
					local chunk_event_socket_handles = arg_8_1.chunk_event_socket_handles

					for i = 1, #chunk_event_socket_handles do
						Managers.state.unit_spawner:remove_queued_network_unit(chunk_event_socket_handles[i])

						chunk_event_socket_handles[i] = nil
					end

					local chunk_event_socket_units = arg_8_1.chunk_event_socket_units

					for j = 1, #chunk_event_socket_units do
						Managers.state.unit_spawner:mark_for_deletion(chunk_event_socket_units[j])

						chunk_event_socket_units[j] = nil
					end

					local get_entities = Managers.state.entity:get_entities("ObjectiveUnitExtension")

					for k, v in pairs(get_entities) do
						if AiUtils.unit_breed(k) or not v.active then
							v:set_active(false)

							v.proxy_active = false
						end
					end

					local respawn_thresholds, var_8_4, var_8_5, var_8_6, var_8_7 = ScriptUnit.extension(arg_8_0, "health_system"):respawn_thresholds()

					if var_8_7 ~= arg_8_2 then
						local system = Managers.state.entity:system("buff_system")
						local get_stacking_buff = ScriptUnit.extension(arg_8_0, "buff_system"):get_stacking_buff("troll_chief_barrel_exploded")

						if not get_stacking_buff then
							for i4 = #get_stacking_buff, 1, -1 do
								system:remove_buff_synced(arg_8_0, get_stacking_buff[i4].id)
							end
						end

						local str = "boss_arena_alcove_" .. string.pad_left(tostring(arg_8_2), 2, "0") .. "_open"

						LevelHelper:flow_event(arg_8_1.world, str)
					end

					table.clear(arg_8_1.chunk_event_fused_units)
				end
			}
		},
		upped_chunk_events = {
			[{
				2,
				3
			}] = {
				condition_func = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
					-- function 9
					if not ScriptUnit.extension(arg_9_0, "buff_system"):get_buff_type("troll_chief_on_downed_wounded") then
						arg_9_1.wizards_delay = nil

						return false
					end

					local wizards_delay = arg_9_1.wizards_delay

					wizards_delay = wizards_delay or arg_9_3 + 1.5
					arg_9_1.wizards_delay = wizards_delay

					if arg_9_3 > arg_9_1.wizards_delay then
						return true
					end

					return false
				end,
				start = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
					-- function 10
					local get_difficulty = Managers.state.difficulty:get_difficulty()
					local tbl = {
						hardest = 4,
						hard = 2,
						harder = 3,
						default = 4,
						cataclysm = 4,
						normal = 1
					}
					local var_10_2 = tbl[get_difficulty]

					var_10_2 = var_10_2 or tbl.default

					local get_raw_spawner_units = Managers.state.entity:system("spawner_system"):get_raw_spawner_units("boss_sorcerer")

					if not get_raw_spawner_units then
						get_raw_spawner_units = table.shallow_copy(get_raw_spawner_units)

						table.shuffle(get_raw_spawner_units)
					end

					local flag = not get_raw_spawner_units and #get_raw_spawner_units
					local system = Managers.state.entity:system("buff_system")
					local tbl_2 = {
						far_off_despawn_immunity = true,
						spawned_func = function (arg_11_0, arg_11_1, arg_11_2)
							-- function 11
							local tbl = {
								attacker_unit = arg_11_0
							}

							system:add_buff_synced(arg_10_0, "sorcerer_tether_buff_invulnerability", BuffSyncType.All, tbl)

							local extension = ScriptUnit.extension(arg_11_0, "tutorial_system")

							extension:set_active(true)
							extension:set_always_show(true)
						end
					}
					local chaos_tether_sorcerer = Breeds.chaos_tether_sorcerer

					for i = 1, var_10_2 do
						local local_position

						if not get_raw_spawner_units then
							local_position = Unit.local_position(get_raw_spawner_units[math.index_wrapper(i, flag)], 0)

							if not local_position then
								-- Nothing
							end
						end

						local_position = Unit.local_position(arg_10_0, 0)

						::label_10_0::

						Managers.state.conflict:spawn_queued_unit(chaos_tether_sorcerer, Vector3Box(local_position), QuaternionBox(Quaternion.identity()), nil, nil, "terror_event", tbl_2)
					end

					Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_dwarf_fest_boss_sorcerer_shield_spawn")
				end,
				finish = function (arg_12_0, arg_12_1)
					-- function 12
					arg_12_1.wizards_delay = nil
				end
			}
		}
	},
	spawn_allies_defensive = {
		stinger_name = "enemy_horde_chaos_stinger",
		spawn_group = "default",
		stay_still = true,
		duration = 0,
		find_spawn_points = false,
		phase_spawn = {
			"troll_chief_defensive_1",
			"troll_chief_defensive_2",
			"troll_chief_defensive_2"
		}
	},
	spawn_allies_rage = {
		stinger_name = "enemy_horde_chaos_stinger",
		spawn_group = "default",
		stay_still = true,
		duration = 0,
		find_spawn_points = false,
		phase_spawn = {
			"troll_chief_rage_1",
			"troll_chief_rage_1",
			"troll_chief_rage_2"
		}
	},
	stagger = {
		scale_animation_speeds = true,
		stagger_animation_scale = 1,
		override_mover_move_distance = 2,
		stagger_anims = {
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			}
		}
	}
}

BreedActions.chaos_troll_chief = table.create_copy(BreedActions.chaos_troll_chief, tbl_5)
