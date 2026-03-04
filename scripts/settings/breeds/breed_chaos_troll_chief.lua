-- chunkname: @scripts/settings/breeds/breed_chaos_troll_chief.lua

local var_0_0 = require("scripts/utils/stagger_types")
local var_0_1 = 1.5
local var_0_2 = {
	ahead_dist = 1.5,
	push_width = 1.25,
	push_forward_offset = 1.5,
	push_stagger_distance = 1,
	player_pushed_speed = 7,
	push_stagger_impact = {
		var_0_0.medium,
		var_0_0.medium,
		var_0_0.none,
		var_0_0.none
	},
	push_stagger_duration = {
		1.5,
		1,
		0,
		0
	}
}
local var_0_3 = {
	ahead_dist = 2.5,
	push_width = 1.25,
	push_forward_offset = 1.5,
	push_stagger_distance = 1,
	player_pushed_speed = 9,
	push_stagger_impact = {
		var_0_0.medium,
		var_0_0.medium,
		var_0_0.none,
		var_0_0.none
	},
	push_stagger_duration = {
		1.5,
		1,
		0,
		0
	}
}
local var_0_4 = BotConstants and BotConstants.default.DEFAULT_BOT_THREAT_DIFFICULTY_DATA
local var_0_5 = {
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
	poison_resistance = 100,
	panic_close_detection_radius_sq = 9,
	height = 3,
	boss = true,
	hit_mass_count = 50,
	patrol_active_perception = "perception_rat_ogre",
	animation_movement_template = "chaos_troll",
	race = "chaos",
	stagger_threshold_medium = 1,
	ai_strength = 10,
	death_reaction = "ai_default",
	armor_category = 3,
	stagger_threshold_heavy = 1,
	stagger_threshold_explosion = 1,
	regen_pulse_interval = 2,
	target_selection_angry = "pick_chaos_troll_target_with_weights",
	exchange_order = 1,
	use_big_boy_turning = true,
	use_navigation_path_splines = true,
	downed_pulse_interval = 1,
	distance_sq_can_detect_target = 2025,
	is_bot_aid_threat = true,
	perception_continuous = "perception_continuous_chaos_troll",
	behavior = "troll_chief",
	bots_should_flank = true,
	bot_hitbox_radius_approximation = 1,
	boost_curve_multiplier_override = 1.8,
	downed_pulse_intensity = 0.2,
	far_vomit = "troll_chief_vomit",
	has_inventory = true,
	combat_music_state = "troll",
	run_speed = 5.25,
	awards_positive_reinforcement_message = true,
	headshot_coop_stamina_fatigue_type = "headshot_special",
	threat_value = 32,
	trigger_dialogue_on_target_switch = true,
	show_health_bar = true,
	aim_template = "chaos_warrior",
	near_vomit = "troll_chief_vomit_near",
	passive_in_patrol_start_anim = "move_fwd",
	reach_distance = 4.2,
	navigation_spline_distance_to_borders = 1,
	stagger_threshold_light = 1,
	reflect_regen_reduction_in_hp_bar = true,
	no_stagger_duration = false,
	hit_reaction = "ai_default",
	bone_lod_level = 0,
	passive_in_patrol = true,
	patrol_passive_target_selection = "patrol_passive_target_selection",
	smart_object_template = "chaos_troll",
	keep_weapon_on_death = false,
	hit_effect_template = "HitEffectsChaosTroll",
	bot_opportunity_target_melee_range_while_ranged = 5,
	unit_template = "ai_unit_chaos_troll",
	catch_up_speed = 10,
	has_running_attack = true,
	dialogue_target_switch_event = "enemy_target_changed",
	perception = "perception_rat_ogre",
	player_locomotion_constrain_radius = 1.5,
	husk_hit_reaction_cooldown = 1,
	dialogue_target_switch_attack_tag = "chaos_troll_target_changed",
	distance_sq_idle_auto_detect_target = 49,
	far_off_despawn_immunity = true,
	patrol_passive_perception = "perception_rat_ogre",
	boss_damage_reduction = true,
	base_unit = "units/beings/enemies/chaos_troll_chief/chr_chaos_troll_chief",
	aoe_height = 2.4,
	displace_players_data = var_0_2,
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
		1 * var_0_1,
		1 * var_0_1
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
	custom_health_bar_name = function (arg_1_0, arg_1_1)
		local var_1_0 = ScriptUnit.has_extension(arg_1_0, "health_system")

		if not var_1_0 then
			return
		end

		local var_1_1 = ScriptUnit.extension(arg_1_0, "buff_system")
		local var_1_2 = Managers.time:time("game")

		if var_1_0.state == "down" then
			local var_1_3 = var_1_1:get_buff_type("troll_chief_downed_regen")

			if var_1_3 then
				local var_1_4 = var_1_2 - var_1_3.start_time
				local var_1_5 = AiUtils.downed_duration(BreedActions.chaos_troll_chief.downed) - var_1_4
				local var_1_6 = Localize("chaos_troll_chief_regenerating")

				if var_1_5 > 0 then
					return string.format("%s: %d", var_1_6, var_1_5)
				end
			end
		end

		local var_1_7 = var_1_1:get_buff_type("troll_chief_on_downed_wounded")

		if var_1_7 then
			local var_1_8 = var_1_2 - var_1_7.start_time
			local var_1_9 = var_1_7.duration - var_1_8
			local var_1_10 = Localize("chaos_troll_chief_raging")

			if var_1_9 > 0 then
				return string.format("%s: %d", var_1_10, var_1_9)
			end
		end

		if var_1_1:num_buff_stacks("sorcerer_tether_buff_invulnerability") > 0 then
			return string.format("%s (%s)", Localize(arg_1_1), Localize("chaos_troll_chief_protected"))
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
		local var_2_0 = BLACKBOARDS[arg_2_0]

		if not Unit.alive(arg_2_1) then
			return
		end

		QuestSettings.check_chaos_troll_killed_without_regen(var_2_0, arg_2_1)
		QuestSettings.check_chaos_troll_killed_without_bile_damage(var_2_0, arg_2_1)
	end
}

Breeds.chaos_troll_chief = table.create_copy(Breeds.chaos_troll_chief, var_0_5)

local var_0_6 = {
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
local var_0_7 = {
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
		difficulty_attack_intensity = var_0_6,
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
				range = 2.75 * var_0_1,
				height = 2.5 * var_0_1,
				push_units_in_the_way = var_0_2,
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
				range = 2.75 * var_0_1,
				height = 2.5 * var_0_1,
				push_units_in_the_way = var_0_3,
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
		difficulty_attack_intensity = var_0_6,
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
						var_0_0.explosion,
						var_0_0.heavy,
						var_0_0.none,
						var_0_0.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = var_0_4,
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
		difficulty_attack_intensity = var_0_6,
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
				range = 0.7 * var_0_1,
				height = 0.8 * var_0_1 * 2,
				width = 0.8 * var_0_1,
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
						var_0_0.explosion,
						var_0_0.heavy,
						var_0_0.none,
						var_0_0.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = var_0_4,
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
				range = 0.7 * var_0_1,
				height = 0.9 * var_0_1 * 2,
				width = 1.1 * var_0_1,
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
						var_0_0.explosion,
						var_0_0.heavy,
						var_0_0.none,
						var_0_0.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = var_0_4,
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
		difficulty_attack_intensity = var_0_6,
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
				range = 0.8 * var_0_1,
				height = 0.8 * var_0_1 * 2,
				width = 1.1 * var_0_1,
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
						var_0_0.explosion,
						var_0_0.heavy,
						var_0_0.none,
						var_0_0.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = var_0_4,
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
				range = 1 * var_0_1,
				height = 0.9 * var_0_1 * 2,
				width = 1.4 * var_0_1,
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
						var_0_0.explosion,
						var_0_0.heavy,
						var_0_0.none,
						var_0_0.none
					},
					stagger_duration = {
						4.5,
						1,
						0,
						0
					}
				},
				bot_threat_difficulty_data = var_0_4,
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
		difficulty_attack_intensity = var_0_6,
		considerations = UtilityConsiderations.troll_chief_vomit,
		attack_anims = {
			ranged_vomit = "attack_vomit_high",
			near_vomit = "attack_vomit"
		},
		bot_threat_difficulty_data = var_0_4,
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
			75
		},
		downed_chunk_events = {
			[{
				1,
				2
			}] = {
				start = function (arg_3_0, arg_3_1, arg_3_2)
					local var_3_0 = {}

					arg_3_1.chunk_event_socket_handles = var_3_0
					arg_3_1.chunk_event_socket_units = {}
					arg_3_1.chunk_event_fused_units = {}
					arg_3_1.phase_one_buffs = arg_3_1.phase_one_buffs or {}

					local var_3_1 = Managers.state.difficulty:get_difficulty()
					local var_3_2 = {
						hardest = 4,
						hard = 3,
						harder = 3,
						default = 4,
						cataclysm = 4,
						normal = 2
					}
					local var_3_3 = var_3_2[var_3_1] or var_3_2.default
					local var_3_4 = 1.75
					local var_3_5 = 2
					local var_3_6 = "units/gameplay/explosive_oil_jug_socket_01"
					local var_3_7 = Unit.local_position(arg_3_0, 0)
					local var_3_8 = Unit.local_rotation(arg_3_0, 0)
					local var_3_9 = Quaternion.right(var_3_8)
					local var_3_10 = Quaternion.forward(var_3_8)
					local var_3_11 = var_3_7 - var_3_9 * var_3_4
					local var_3_12 = var_3_7 + var_3_9 * var_3_4
					local var_3_13 = var_3_7 + var_3_10 * var_3_4
					local var_3_14 = var_3_7 - var_3_10 * var_3_4
					local var_3_15 = {}
					local var_3_16 = Managers.state.entity:system("ai_system"):nav_world()
					local var_3_17 = math.ceil(var_3_3 * 0.5)

					for iter_3_0 = 1, var_3_17 do
						local var_3_18 = var_3_17 > 1 and var_3_5 / ((var_3_17 - 1) * 0.5) or 0
						local var_3_19 = (iter_3_0 - 1 - (var_3_17 - 1) * 0.5) * var_3_18 * 0.5
						local var_3_20 = LocomotionUtils.pos_on_mesh(var_3_16, var_3_11 + var_3_10 * var_3_19, 1, 1)

						if var_3_20 then
							var_3_0[#var_3_0 + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(var_3_6, "explosive_barrel_socket", var_3_15, var_3_20)
						else
							var_3_3 = var_3_3 + 1
						end
					end

					local var_3_21 = var_3_3 - var_3_17

					for iter_3_1 = 1, var_3_21 do
						local var_3_22 = var_3_21 > 1 and var_3_5 / ((var_3_21 - 1) * 0.5) or 0
						local var_3_23 = (iter_3_1 - 1 - (var_3_21 - 1) * 0.5) * var_3_22 * 0.5
						local var_3_24 = LocomotionUtils.pos_on_mesh(var_3_16, var_3_12 + var_3_10 * var_3_23, 1, 1)

						if var_3_24 then
							var_3_0[#var_3_0 + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(var_3_6, "explosive_barrel_socket", var_3_15, var_3_24)
						else
							var_3_3 = var_3_3 + 1
						end
					end

					local var_3_25 = var_3_3 - var_3_17 - var_3_21

					for iter_3_2 = 1, var_3_25 do
						local var_3_26 = var_3_25 > 1 and var_3_5 / ((var_3_25 - 1) * 0.5) or 0
						local var_3_27 = (iter_3_2 - 1 - (var_3_25 - 1) * 0.5) * var_3_26 * 0.5
						local var_3_28 = LocomotionUtils.pos_on_mesh(var_3_16, var_3_13 + var_3_9 * var_3_27, 1, 1)

						if var_3_28 then
							var_3_0[#var_3_0 + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(var_3_6, "explosive_barrel_socket", var_3_15, var_3_28)
						else
							var_3_3 = var_3_3 + 1
						end
					end

					local var_3_29 = var_3_3 - var_3_17 - var_3_21 - var_3_25

					for iter_3_3 = 1, var_3_29 do
						local var_3_30 = var_3_29 > 1 and var_3_5 / ((var_3_29 - 1) * 0.5) or 0
						local var_3_31 = (iter_3_3 - 1 - (var_3_29 - 1) * 0.5) * var_3_30 * 0.5
						local var_3_32 = LocomotionUtils.pos_on_mesh(var_3_16, var_3_14 + var_3_9 * var_3_31, 1, 1)

						if var_3_32 then
							var_3_0[#var_3_0 + 1] = Managers.state.unit_spawner:queue_spawn_network_unit(var_3_6, "explosive_barrel_socket", var_3_15, var_3_32)
						end
					end

					local var_3_33 = #var_3_0

					local function var_3_34()
						local var_4_0 = {
							tutorial_system = {
								always_show = true
							}
						}
						local var_4_1 = Managers.state.entity:system("pickup_system")
						local var_4_2 = var_4_1.triggered_pickup_spawners.boss_barrel_spawn

						if var_4_2 then
							var_4_2 = table.shallow_copy(var_4_2)

							table.shuffle(var_4_2)
						end

						local var_4_3 = var_4_2 and #var_4_2

						for iter_4_0 = 1, var_3_33 do
							local var_4_4 = var_4_2 and Unit.local_position(var_4_2[math.index_wrapper(iter_4_0, var_4_3)], 0) or Unit.local_position(arg_3_0, 0)

							if var_4_4 then
								local var_4_5 = Quaternion.axis_angle(Vector3.up(), math.random() * math.tau)
								local var_4_6 = Quaternion.multiply(Quaternion.axis_angle(Vector3.right(), math.random() * math.tau), var_4_5)
								local var_4_7 = Quaternion.multiply(Quaternion.axis_angle(Vector3.forward(), math.random() * math.tau), var_4_6)
								local var_4_8 = var_4_1:spawn_pickup("lamp_oil", var_4_4, var_4_7, false, "triggered", nil, "explosive_pickup_projectile_unit", var_4_0)

								ScriptUnit.extension(var_4_8, "tutorial_system"):set_active(true)
							end
						end
					end

					Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_3_34)
				end,
				update = function (arg_5_0, arg_5_1, arg_5_2)
					local var_5_0 = 2
					local var_5_1 = ScriptUnit.extension(arg_5_0, "health_system"):chunk_size()
					local var_5_2 = BuffTemplates.troll_chief_barrel_exploded.buffs[1].total_part_of_chunk
					local var_5_3 = #arg_5_1.chunk_event_socket_units
					local var_5_4 = var_5_1 / var_5_3 * var_5_2
					local var_5_5 = arg_5_1.chunk_event_socket_handles
					local var_5_6 = arg_5_1.chunk_event_socket_units

					for iter_5_0 = #var_5_5, 1, -1 do
						local var_5_7 = Managers.state.unit_spawner:try_claim_async_unit(var_5_5[iter_5_0])

						if var_5_7 then
							var_5_6[#var_5_6 + 1] = var_5_7

							table.swap_delete(var_5_5, iter_5_0)

							local var_5_8 = #var_5_6 + #var_5_5
							local var_5_9 = BuffTemplates.troll_chief_phase_one_damage_reduction.buffs[1].total_multiplier / var_5_8
							local var_5_10 = Managers.state.entity:system("buff_system")

							arg_5_1.phase_one_buffs[var_5_7] = var_5_10:add_buff_synced(arg_5_0, "troll_chief_phase_one_damage_reduction", BuffSyncType.All, {
								external_optional_multiplier = var_5_9
							})
						end
					end

					local var_5_11 = arg_5_1.chunk_event_fused_units

					for iter_5_1 = 1, #var_5_6 do
						local var_5_12 = var_5_6[iter_5_1]
						local var_5_13 = ScriptUnit.extension(var_5_12, "objective_socket_system")

						if not var_5_11[var_5_12] then
							if var_5_13:socket_from_id(1).open == false then
								Unit.flow_event(var_5_6[iter_5_1], "fuse_light")

								var_5_11[var_5_12] = arg_5_2 + var_5_0
							end
						elseif arg_5_2 > var_5_11[var_5_12] then
							local function var_5_14()
								if var_5_11[var_5_12] and HEALTH_ALIVE[arg_5_0] then
									Unit.flow_event(var_5_6[iter_5_1], "force_explode")

									local var_6_0 = ScriptUnit.extension(arg_5_0, "buff_system")
									local var_6_1 = arg_5_1.phase_one_buffs[var_5_12]

									var_6_0:remove_buff(var_6_1)

									arg_5_1.phase_one_buffs[var_5_12] = nil

									DamageUtils.add_damage_network(arg_5_0, arg_5_0, var_5_4, "torso", "forced", nil, Vector3(0, 0, 1), "life_tap", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
									Managers.state.entity:system("buff_system"):add_buff_synced(arg_5_0, "troll_chief_barrel_exploded", BuffSyncType.All, {
										external_optional_multiplier = -1 / var_5_3
									})
								end
							end

							Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_5_14)

							var_5_11[var_5_12] = math.huge
						end
					end
				end,
				before_down_end = function (arg_7_0, arg_7_1)
					local var_7_0 = ScriptUnit.extension(arg_7_0, "health_system"):chunk_size()
					local var_7_1 = BuffTemplates.troll_chief_barrel_exploded.buffs[1].total_part_of_chunk
					local var_7_2 = #arg_7_1.chunk_event_socket_units
					local var_7_3 = var_7_0 / var_7_2 * var_7_1
					local var_7_4 = ScriptUnit.extension(arg_7_0, "buff_system")

					for iter_7_0, iter_7_1 in pairs(arg_7_1.phase_one_buffs) do
						var_7_4:remove_buff(iter_7_1)

						arg_7_1.phase_one_buffs[iter_7_0] = nil
					end

					local var_7_5 = arg_7_1.chunk_event_fused_units

					for iter_7_2, iter_7_3 in pairs(var_7_5) do
						if iter_7_3 ~= math.huge then
							Unit.flow_event(iter_7_2, "force_explode")
							DamageUtils.add_damage_network(arg_7_0, arg_7_0, var_7_3, "torso", "life_tap", nil, Vector3(0, 0, 1), "debug", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
							Managers.state.entity:system("buff_system"):add_buff_synced(arg_7_0, "troll_chief_barrel_exploded", BuffSyncType.All, {
								external_optional_multiplier = -1 / var_7_2
							})
						end
					end
				end,
				finish = function (arg_8_0, arg_8_1, arg_8_2)
					local var_8_0 = arg_8_1.chunk_event_socket_handles

					for iter_8_0 = 1, #var_8_0 do
						Managers.state.unit_spawner:remove_queued_network_unit(var_8_0[iter_8_0])

						var_8_0[iter_8_0] = nil
					end

					local var_8_1 = arg_8_1.chunk_event_socket_units

					for iter_8_1 = 1, #var_8_1 do
						Managers.state.unit_spawner:mark_for_deletion(var_8_1[iter_8_1])

						var_8_1[iter_8_1] = nil
					end

					local var_8_2 = Managers.state.entity:get_entities("ObjectiveUnitExtension")

					for iter_8_2, iter_8_3 in pairs(var_8_2) do
						if not AiUtils.unit_breed(iter_8_2) and iter_8_3.active then
							iter_8_3:set_active(false)

							iter_8_3.proxy_active = false
						end
					end

					local var_8_3, var_8_4, var_8_5, var_8_6, var_8_7 = ScriptUnit.extension(arg_8_0, "health_system"):respawn_thresholds()

					if var_8_7 ~= arg_8_2 then
						local var_8_8 = Managers.state.entity:system("buff_system")
						local var_8_9 = ScriptUnit.extension(arg_8_0, "buff_system"):get_stacking_buff("troll_chief_barrel_exploded")

						if var_8_9 then
							for iter_8_4 = #var_8_9, 1, -1 do
								var_8_8:remove_buff_synced(arg_8_0, var_8_9[iter_8_4].id)
							end
						end

						local var_8_10 = "boss_arena_alcove_" .. string.pad_left(tostring(arg_8_2), 2, "0") .. "_open"

						LevelHelper:flow_event(arg_8_1.world, var_8_10)
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
					if ScriptUnit.extension(arg_9_0, "buff_system"):get_buff_type("troll_chief_on_downed_wounded") then
						arg_9_1.wizards_delay = nil

						return false
					end

					arg_9_1.wizards_delay = arg_9_1.wizards_delay or arg_9_3 + 1.5

					if arg_9_3 > arg_9_1.wizards_delay then
						return true
					end

					return false
				end,
				start = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
					local var_10_0 = Managers.state.difficulty:get_difficulty()
					local var_10_1 = {
						hardest = 4,
						hard = 2,
						harder = 3,
						default = 4,
						cataclysm = 4,
						normal = 1
					}
					local var_10_2 = var_10_1[var_10_0] or var_10_1.default
					local var_10_3 = Managers.state.entity:system("spawner_system"):get_raw_spawner_units("boss_sorcerer")

					if var_10_3 then
						var_10_3 = table.shallow_copy(var_10_3)

						table.shuffle(var_10_3)
					end

					local var_10_4 = var_10_3 and #var_10_3
					local var_10_5 = Managers.state.entity:system("buff_system")
					local var_10_6 = {
						far_off_despawn_immunity = true,
						spawned_func = function (arg_11_0, arg_11_1, arg_11_2)
							local var_11_0 = {
								attacker_unit = arg_11_0
							}

							var_10_5:add_buff_synced(arg_10_0, "sorcerer_tether_buff_invulnerability", BuffSyncType.All, var_11_0)

							local var_11_1 = ScriptUnit.extension(arg_11_0, "tutorial_system")

							var_11_1:set_active(true)
							var_11_1:set_always_show(true)
						end
					}
					local var_10_7 = Breeds.chaos_tether_sorcerer

					for iter_10_0 = 1, var_10_2 do
						local var_10_8 = var_10_3 and Unit.local_position(var_10_3[math.index_wrapper(iter_10_0, var_10_4)], 0) or Unit.local_position(arg_10_0, 0)

						Managers.state.conflict:spawn_queued_unit(var_10_7, Vector3Box(var_10_8), QuaternionBox(Quaternion.identity()), nil, nil, "terror_event", var_10_6)
					end

					Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_dwarf_fest_boss_sorcerer_shield_spawn")
				end,
				finish = function (arg_12_0, arg_12_1)
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

BreedActions.chaos_troll_chief = table.create_copy(BreedActions.chaos_troll_chief, var_0_7)
