-- chunkname: @scripts/settings/breeds/breed_chaos_bulwark.lua

local var_0_0 = {
	ranged_medium = 5,
	heavy = 3,
	weak = 1,
	shield_open_stagger = 11,
	explosion = 6,
	medium = 2,
	none = 0,
	pulling = 9,
	ranged_weak = 4,
	shield_block_stagger = 10,
	weakspot = 8
}
local var_0_1 = {
	ahead_dist = 1.5,
	push_width = 1.25,
	push_forward_offset = 1.5,
	push_stagger_distance = 1,
	player_pushed_speed = 4,
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
local var_0_2 = {
	shield_burning_block_sound = "Play_weapon_fire_torch_metal_shield_hit",
	push_sound_event = "Play_generic_pushed_impact_large_armour",
	walk_speed = 2,
	big_boy_turning_dot = 0.4,
	bot_hitbox_radius_approximation = 0.8,
	ignore_targets_outside_detection_radius = true,
	patrol_active_target_selection = "storm_patrol_death_squad_target_selection",
	no_stagger_duration = false,
	use_regular_horde_spawning = true,
	has_running_attack = true,
	use_big_boy_turning = true,
	aoe_radius = 0.4,
	aoe_height = 1.7,
	play_hit_reacts_when_blocking = true,
	debug_spawn_category = "Roaming",
	race = "chaos",
	hit_mass_count = 30,
	has_inventory = true,
	height = 2.25,
	bone_lod_level = 0,
	patrol_detection_radius = 10,
	attack_general_sound_event = "Play_breed_triggered_sound",
	default_inventory_template = "chaos_bulwark",
	dialogue_source_name = "chaos_bulwark",
	stagger_recover_time = 1,
	shield_blunt_block_sound = "blunt_hit_shield_metal",
	primary_armor_category = 6,
	panic_close_detection_radius_sq = 9,
	death_reaction = "ai_default",
	use_slot_type = "large",
	exchange_order = 2,
	unbreakable_shield = true,
	patrol_active_perception = "perception_regular_update_aggro",
	play_ranged_hit_reacts = true,
	perception_previous_attacker_stickyness_value = 0,
	disable_crowd_dispersion = true,
	use_avoidance = false,
	ai_strength = 6,
	poison_resistance = 100,
	target_selection = "pick_rat_ogre_target_with_weights",
	controllable = true,
	shield_health = 3,
	shield_slashing_block_sound = "slashing_hit_shield_metal",
	threat_value = 12,
	target_stickyness_modifier = -10,
	detection_radius = 12,
	block_stamina = 1,
	attack_player_sound_event = "Play_breed_triggered_sound",
	block_stagger_mod = 0.5,
	awards_positive_reinforcement_message = true,
	aim_template = "chaos_warrior",
	stagger_threshold_light = 1,
	block_stagger_mod_2 = 0.75,
	smart_targeting_outer_width = 1,
	hit_effect_template = "HitEffectsChaosBulwark",
	unit_template = "ai_unit_chaos_bulwark",
	smart_object_template = "chaos_warrior",
	no_stagger_damage_reduction = true,
	perception = "perception_regular_update_aggro",
	use_backstab_vo = true,
	patrol_passive_perception = "perception_regular",
	vortexable = false,
	base_unit = "units/beings/enemies/chaos_warrior_bulwark/chr_chaos_warrior_bulwark",
	enter_walk_distance = 10,
	elite = true,
	is_bot_threat = true,
	lerp_alerted_into_follow_speed = 1.2,
	always_look_at_target = true,
	animation_sync_rpc = "rpc_sync_anim_state_7",
	stagger_count_reset_time = 5,
	is_always_spawnable = true,
	slot_template = "chaos_large_elite",
	stagger_resistance = 5,
	radius = 1,
	friends_alert_range = 10,
	proximity_system_check = true,
	armor_category = 2,
	backstab_player_sound_event = "Play_enemy_vce_ecws_attack_player_back",
	death_sound_event = "Play_enemy_vce_ecws_die",
	use_navigation_path_splines = true,
	smart_targeting_width = 0.2,
	is_bot_aid_threat = true,
	behavior = "chaos_bulwark",
	bots_should_flank = true,
	shield_user = true,
	bot_melee_aim_node = "j_spine1",
	sync_full_rotation = false,
	run_speed = 4.8,
	ai_toughness = 5,
	blocking_hit_effect = "fx/chr_chaos_warrior_bulwark_shield_impact",
	hit_reaction = "chaos_bulwark",
	passive_in_patrol = true,
	patrol_passive_target_selection = "patrol_passive_target_selection",
	smart_targeting_height_multiplier = 3,
	horde_behavior = "chaos_bulwark",
	use_predicted_damage_in_stagger_calculation = true,
	leave_walk_distance = 10.1,
	headshot_coop_stamina_fatigue_type = "headshot_special",
	player_locomotion_constrain_radius = 0.7,
	weapon_reach = 2,
	trigger_dialogue_on_target_switch = true,
	shield_stab_block_sound = "stab_hit_shield_metal",
	displace_players_data = var_0_1,
	infighting = InfightingSettings.large,
	shield_opening_event = {
		"idle_shield_down",
		"idle_shield_down_2"
	},
	stagger_regen_rate = {
		[1] = 1,
		[2] = 0.1
	},
	hit_reactions = {
		bwd = "hit_reaction_backward",
		strong_right = "hit_reaction_open_right",
		strong_left = "hit_reaction_open_left",
		strong_fwd = "hit_reaction_open_fwd",
		fwd = "hit_reaction_forward",
		strong_bwd = "hit_reaction_open_bwd",
		left = "hit_reaction_left",
		right = "hit_reaction_right"
	},
	stagger_modifiers = {
		default = 1,
		heavy_attack = 1,
		ranged_attack = 0.5,
		light_attack = 1
	},
	perception_exceptions = {
		poison_well = true,
		wizard_destructible = true
	},
	perception_weights = {
		target_catapulted_mul = 0.5,
		target_stickyness_bonus_b = 10,
		targeted_by_other_special = -10,
		target_stickyness_duration_a = 5,
		target_stickyness_duration_b = 20,
		aggro_decay_per_sec = 1,
		target_outside_navmesh_mul = 0.5,
		old_target_aggro_mul = 1,
		target_disabled_aggro_mul = 0,
		max_distance = 50,
		target_stickyness_bonus_a = 50,
		distance_weight = 100,
		target_disabled_mul = 0.15
	},
	size_variation_range = {
		1,
		1
	},
	max_health = BreedTweaks.max_health.chaos_bulwark,
	bloodlust_health = BreedTweaks.bloodlust_health.chaos_bulwark,
	stagger_reduction = BreedTweaks.stagger_reduction.warrior,
	diff_stagger_resist = BreedTweaks.diff_stagger_resist.warrior,
	stagger_duration = BreedTweaks.stagger_duration.warrior,
	status_effect_settings = {
		category = "medium",
		ignored_statuses = table.set({
			StatusEffectNames.burning_warpfire
		})
	},
	debug_color = {
		255,
		200,
		0,
		170
	},
	run_on_spawn = AiBreedSnippets.on_chaos_warrior_spawn,
	run_on_update = AiBreedSnippets.on_chaos_warrior_update,
	hit_reaction_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		return arg_1_1.hit_reactions.bwd
	end,
	handle_stagger_anim_cb = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = arg_2_1.stagger_level
		local var_2_1 = false

		if arg_2_2 == "anim_cb_stagger_light_finished" and var_2_0 == var_0_0.shield_block_stagger then
			var_2_1 = true
		elseif arg_2_2 == "anim_cb_stagger_medium_finished" and var_2_0 == var_0_0.shield_open_stagger then
			var_2_1 = true
		elseif arg_2_2 == "anim_cb_stagger_heavy_finished" then
			var_2_1 = true
		end

		arg_2_1.stagger_anim_done = var_2_1
	end,
	stagger_modifier_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
		local var_3_0 = arg_3_6 and arg_3_6.damage_profile

		arg_3_4.latest_hit_charge_value = arg_3_6 and arg_3_6.is_ranged and "ranged_attack" or var_3_0 and var_3_0.charge_value

		local var_3_1 = Managers.time:time("game")

		if arg_3_3 == "weakspot" then
			arg_3_4.weakspot_hit = true
			arg_3_0 = 8
		elseif arg_3_4.stagger_recover_time and var_3_1 < arg_3_4.stagger_recover_time then
			return var_0_0.none, 0, 0, true
		end

		arg_3_4.spawn_exit_time = nil

		return arg_3_0, arg_3_1, arg_3_2
	end,
	stagger_difficulty_tweak_index = {
		{
			shield_block_threshold = 2,
			shield_open_stagger_threshold = 6,
			stagger_regen_rate = {
				1,
				0.1
			}
		},
		{
			shield_block_threshold = 2,
			shield_open_stagger_threshold = 8,
			stagger_regen_rate = {
				1,
				0.1
			}
		},
		{
			shield_block_threshold = 2,
			shield_open_stagger_threshold = 10,
			stagger_regen_rate = {
				1.5,
				0.5
			}
		},
		{
			shield_block_threshold = 3,
			shield_open_stagger_threshold = 10,
			stagger_regen_rate = {
				1.5,
				0.5
			}
		},
		{
			shield_block_threshold = 3,
			shield_open_stagger_threshold = 12,
			stagger_regen_rate = {
				2,
				1
			}
		},
		{
			shield_block_threshold = 4,
			shield_open_stagger_threshold = 12,
			stagger_regen_rate = {
				2,
				1
			}
		},
		{
			shield_block_threshold = 4,
			shield_open_stagger_threshold = 12,
			stagger_regen_rate = {
				2,
				1
			}
		},
		{
			shield_block_threshold = 4,
			shield_open_stagger_threshold = 12,
			stagger_regen_rate = {
				2,
				1
			}
		},
		{
			shield_block_threshold = 2,
			shield_open_stagger_threshold = 6,
			stagger_regen_rate = {
				1,
				0.1
			}
		}
	},
	before_stagger_enter_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		local var_4_0 = ScriptUnit.extension(arg_4_0, "ai_shield_system")
		local var_4_1 = Managers.time:time("game")
		local var_4_2 = arg_4_1.breed
		local var_4_3 = var_4_2.stagger_modifiers[arg_4_1.latest_hit_charge_value] or var_4_2.stagger_modifiers.default

		arg_4_1.stagger_level = arg_4_1.stagger_level or var_0_0.none

		local var_4_4 = Managers.state.difficulty:get_difficulty_rank()
		local var_4_5 = var_4_2.stagger_difficulty_tweak_index[var_4_4]
		local var_4_6 = var_4_5.shield_open_stagger_threshold
		local var_4_7 = var_4_5.shield_block_threshold
		local var_4_8 = var_4_5.stagger_regen_rate
		local var_4_9

		if arg_4_1.weakspot_hit and not arg_4_1.weakspot_exploded and not var_4_0.is_blocking then
			var_4_9 = true
			arg_4_1.weakspot_exploded = true
		end

		arg_4_5 = arg_4_5 or 0.1

		local var_4_10 = {
			0,
			10
		}
		local var_4_11 = (arg_4_4 + (arg_4_5 - var_4_10[1]) / (var_4_10[2] - var_4_10[1])) * var_4_3
		local var_4_12 = math.lerp(var_4_8[1], var_4_8[2], (arg_4_1.cached_stagger or 0.1) / var_4_6)
		local var_4_13 = math.clamp(var_4_1 - (arg_4_1.shield_regen_time_stamp or var_4_1), 0, math.huge) * var_4_12

		arg_4_1.stagger = math.clamp((arg_4_1.cached_stagger or 0) - var_4_13, 0, math.huge) + var_4_11
		arg_4_1.shield_regen_time_stamp = var_4_1

		local var_4_14 = var_4_7 <= var_4_11
		local var_4_15 = var_4_6 <= arg_4_1.stagger

		arg_4_1.override_stagger = arg_4_1.max_stagger_reached and not var_4_9

		if arg_4_1.stagger_level == var_0_0.shield_open_stagger or var_4_9 then
			arg_4_1.stagger_level = var_0_0.heavy
		elseif var_4_15 then
			arg_4_1.stagger_level = var_0_0.shield_open_stagger
		elseif var_4_14 then
			arg_4_1.stagger_level = var_0_0.shield_block_stagger
		else
			arg_4_1.override_stagger = true
		end

		if arg_4_1.override_stagger then
			arg_4_1.staggering_id = arg_4_1.stagger
		else
			arg_4_1.stagger_activated = true
		end

		arg_4_1.cached_stagger = arg_4_1.stagger

		if not arg_4_1.max_stagger_reached and arg_4_1.stagger_level ~= var_0_0.heavy then
			var_4_0:play_shield_hit_sfx(arg_4_1.stagger_level == var_0_0.shield_open_stagger, arg_4_1.cached_stagger, var_4_6)
		end
	end,
	hitzone_multiplier_types = {
		head = "headshot",
		neck = "headshot",
		weakspot = "weakspot"
	},
	hitzone_primary_armor_categories = {
		head = {
			attack = 6,
			impact = 2
		},
		neck = {
			attack = 6,
			impact = 2
		}
	},
	hit_zones = {
		head = {
			prio = 1,
			actors = {
				"c_head"
			},
			push_actors = {
				"j_head",
				"j_neck",
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
				"j_neck",
				"j_spine1"
			}
		},
		torso = {
			prio = 2,
			actors = {
				"c_spine",
				"c_hips"
			},
			push_actors = {
				"j_neck",
				"j_spine1",
				"j_hips"
			}
		},
		left_arm = {
			prio = 3,
			actors = {
				"c_leftarm",
				"c_leftforearm",
				"c_lefthand",
				"c_leftshoulder"
			},
			push_actors = {
				"j_spine1",
				"j_leftshoulder",
				"j_leftarm"
			}
		},
		right_arm = {
			prio = 3,
			actors = {
				"c_rightarm",
				"c_rightforearm",
				"c_righthand",
				"c_rightshoulder"
			},
			push_actors = {
				"j_spine1",
				"j_rightshoulder",
				"j_rightarm"
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
				"j_leftfoot",
				"j_rightfoot",
				"j_hips"
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
				"j_leftfoot",
				"j_rightfoot",
				"j_hips"
			}
		},
		weakspot = {
			prio = 1,
			actors = {
				"c_weakpoint"
			},
			push_actors = {
				"j_spine1"
			}
		},
		full = {
			prio = 4,
			actors = {}
		},
		afro = {
			prio = 5,
			actors = {
				"c_afro"
			}
		}
	},
	hitbox_ragdoll_translation = {
		c_spine = "j_spine1",
		c_head = "j_head",
		c_leftforearm = "j_leftforearm",
		c_rightfoot = "j_rightfoot",
		c_lefthand = "j_lefthand",
		c_rightleg = "j_rightleg",
		c_leftfoot = "j_leftfoot",
		c_neck = "j_neck",
		c_leftleg = "j_leftleg",
		c_leftupleg = "j_leftupleg",
		c_rightarm = "j_rightarm",
		c_rightupleg = "j_rightupleg",
		c_leftarm = "j_leftarm",
		c_rightforearm = "j_rightforearm",
		c_hips = "j_hips",
		c_righthand = "j_righthand"
	},
	ragdoll_actor_thickness = {
		j_rightfoot = 0.2,
		j_spine1 = 0.3,
		j_leftarm = 0.2,
		j_leftforearm = 0.2,
		j_leftleg = 0.2,
		j_leftshoulder = 0.3,
		j_righthand = 0.2,
		j_leftupleg = 0.2,
		j_rightshoulder = 0.3,
		j_rightarm = 0.2,
		j_hips = 0.3,
		j_rightleg = 0.2,
		j_leftfoot = 0.2,
		j_rightupleg = 0.2,
		j_head = 0.3,
		j_neck = 0.3,
		j_lefthand = 0.2,
		j_rightforearm = 0.2
	},
	networked_animation_variables = {
		{
			anims = {
				"attack_run"
			},
			variables = {
				moving_attack_fwd_speed = {
					move_speed_variable_lerp_speed = 4,
					animation_move_speed_config = {
						{
							value = 4,
							distance = 3.5
						},
						{
							value = 3,
							distance = 3
						},
						{
							value = 2,
							distance = 2.5
						},
						{
							value = 1,
							distance = 2
						},
						{
							value = 0,
							distance = 0
						}
					}
				}
			}
		}
	}
}

Breeds.chaos_bulwark = table.create_copy(Breeds.chaos_bulwark, var_0_2)

local var_0_3 = {
	normal = {
		easy = {
			normal = 3
		},
		normal = {
			normal = 3
		},
		hard = {
			normal = 3
		},
		harder = {
			normal = 3
		},
		hardest = {
			normal = 3
		},
		cataclysm = {
			normal = 3
		},
		cataclysm_2 = {
			normal = 3
		},
		cataclysm_3 = {
			normal = 3
		},
		versus_base = {
			normal = 3
		}
	},
	sweep = {
		easy = {
			normal = 2,
			sweep = 4
		},
		normal = {
			normal = 2,
			sweep = 4
		},
		hard = {
			normal = 2,
			sweep = 4
		},
		harder = {
			normal = 2,
			sweep = 4
		},
		hardest = {
			normal = 2,
			sweep = 4
		},
		cataclysm = {
			normal = 2,
			sweep = 4
		},
		cataclysm_2 = {
			normal = 2,
			sweep = 4
		},
		cataclysm_3 = {
			normal = 2,
			sweep = 4
		},
		versus_base = {
			normal = 2,
			sweep = 4
		}
	},
	push = {
		easy = {
			push = 1.5
		},
		normal = {
			push = 1.5
		},
		hard = {
			push = 1.5
		},
		harder = {
			push = 1.5
		},
		hardest = {
			push = 1.5
		},
		cataclysm = {
			push = 1.5
		},
		cataclysm_2 = {
			push = 1.5
		},
		cataclysm_3 = {
			push = 1.5
		},
		versus_base = {
			push = 1.5
		}
	},
	running = {
		easy = {
			running = 4.5
		},
		normal = {
			running = 4.5
		},
		hard = {
			running = 4.5
		},
		harder = {
			running = 4.5
		},
		hardest = {
			running = 4.5
		},
		cataclysm = {
			running = 4.5
		},
		cataclysm_2 = {
			running = 4.5
		},
		cataclysm_3 = {
			running = 4.5
		},
		versus_base = {
			running = 4.5
		}
	}
}
local var_0_4 = {
	idle = {
		idle = {
			"idle",
			"idle_2"
		},
		idle_combat = {
			"idle_defence"
		}
	},
	alerted = {
		no_hesitation = true,
		override_time_alerted = 0.2,
		start_anims_name = {
			bwd = "alerted_bwd",
			fwd = "alerted_fwd",
			left = "alerted_left",
			right = "alerted_right"
		},
		start_anims_data = {
			alerted_fwd = {},
			alerted_bwd = {
				dir = -1,
				rad = math.pi
			},
			alerted_left = {
				dir = 1,
				rad = math.pi / 2
			},
			alerted_right = {
				dir = -1,
				rad = math.pi / 2
			}
		}
	},
	follow = {
		ignore_target_velocity = true,
		action_weight = 1,
		considerations = UtilityConsiderations.chaos_bulwark_follow,
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
		}
	},
	special_attack_sweep = {
		range = 2.5,
		offset_forward = 0.5,
		player_push_speed = 5,
		push = true,
		no_block_stagger = true,
		step_attack_target_speed_away_override = 0.6,
		damage = 15,
		knocked_down_attack_threshold = 0.6,
		attack_intensity_type = "sweep",
		action_weight = 1,
		player_push_speed_blocked = 7.5,
		width = 1,
		height = 1,
		rotation_time = 1,
		hit_react_type = "medium",
		blocked_anim = "blocked",
		bot_threat_start_time = 0.4,
		damage_type = "cutting",
		offset_up = 0,
		step_attack_target_speed_away = 0.2,
		bot_threat_duration = 0.7,
		reset_attack_animation_speed = 1.2,
		step_attack_distance = 0.2,
		bot_threat_start_time_step = 0.5,
		step_attack_distance_override = 0.7,
		difficulty_attack_intensity = var_0_3,
		considerations = UtilityConsiderations.chaos_bulwark_sweep_attack,
		attack_anim = {
			"attack_sweep_01",
			"attack_sweep_02",
			"attack_sweep_03",
			"attack_sweep_04"
		},
		knocked_down_attack_anim = {
			"attack_downed"
		},
		reset_attack_animations = {
			"attack_right_reset"
		},
		difficulty_damage = BreedTweaks.difficulty_damage.elite_attack,
		fatigue_type = BreedTweaks.fatigue_types.elite_sweep.normal_attack,
		ignore_staggers = {
			false,
			false,
			false,
			true,
			true,
			false,
			false,
			false
		},
		attack_finished_duration = BreedTweaks.attack_finished_duration.chaos_elite
	},
	special_attack_quick = {
		step_attack_distance = 0.2,
		height = 1,
		reset_attack_animation_speed = 1.3,
		push = true,
		player_push_speed = 10,
		rotation_time = 0.75,
		hit_react_type = "heavy",
		range = 3,
		step_attack_target_speed_away = 0.2,
		no_block_stagger = true,
		offset_forward = 0,
		damage_type = "blunt",
		offset_up = 0,
		step_attack_target_speed_away_override = 0.6,
		damage = 0,
		fatigue_type = "bulwark_shield_bash",
		knocked_down_attack_threshold = 0.6,
		attack_intensity_type = "normal",
		action_weight = 1,
		player_push_speed_blocked = 8,
		step_attack_distance_override = 0.7,
		width = 0.4,
		difficulty_attack_intensity = var_0_3,
		considerations = UtilityConsiderations.chaos_bulwark_push_attack,
		attack_anim = {
			"attack_quick_01"
		},
		knocked_down_attack_anim = {
			"attack_downed"
		},
		step_attack_anim = {
			"attack_push"
		},
		difficulty_damage = BreedTweaks.difficulty_damage.elite_shield_push,
		ignore_staggers = {
			true,
			false,
			false,
			true,
			true,
			false,
			false,
			false
		},
		attack_finished_duration = BreedTweaks.attack_finished_duration.chaos_elite
	},
	running_attack_right = {
		damage = 20,
		cooldown = 1,
		target_running_velocity_threshold = 0,
		attack_intensity_type = "running",
		action_weight = 1,
		difficulty_attack_intensity = var_0_3,
		considerations = UtilityConsiderations.chaos_bulwark_running_attack,
		difficulty_damage = BreedTweaks.difficulty_damage.elite_attack,
		fatigue_type = BreedTweaks.fatigue_types.elite_sweep.running_attack,
		attacks = {
			{
				height = 1,
				offset_forward = 0.5,
				movement_speed = "run_speed",
				blend_time = 0.2,
				catapult_player = true,
				rotation_time = 1.5,
				anim_driven = true,
				player_push_speed = 6,
				hit_multiple_targets = true,
				bot_threat_start_time = 0.5,
				hit_only_players = false,
				player_push_speed_blocked_z = 2,
				ignore_targets_behind = true,
				offset_up = 0.5,
				player_push_speed_z = 2,
				freeze_intensity_decay_time = -1,
				range = 2.5,
				lock_attack_time = 2.1,
				bot_threat_duration = 0.7,
				reset_attack_animation_speed = 1.3,
				rotation_speed = 9,
				player_push_speed_blocked = 6,
				width = 1,
				attack_anim = {
					"attack_run"
				},
				attack_time = math.huge,
				ignore_staggers = {
					false,
					false,
					false,
					true,
					false,
					false,
					false,
					false
				},
				attack_finished_duration = BreedTweaks.attack_finished_duration.chaos_elite
			}
		}
	},
	running_attack_charging = {
		fatigue_type = "bulwark_shield_bash",
		damage_type = "blunt",
		damage = 0,
		cooldown = 1,
		target_running_velocity_threshold = 0,
		attack_intensity_type = "running",
		action_weight = 1,
		no_block_stagger = true,
		difficulty_attack_intensity = var_0_3,
		considerations = UtilityConsiderations.chaos_bulwark_running_attack_charging,
		difficulty_damage = BreedTweaks.difficulty_damage.elite_shield_push,
		attacks = {
			{
				bot_threat_duration = 0.7,
				offset_forward = 0.5,
				height = 1,
				blend_time = 0.2,
				catapult_player = true,
				rotation_time = 1.5,
				anim_driven = true,
				hit_multiple_targets = true,
				hit_only_players = false,
				bot_threat_start_time = 0.5,
				ignore_targets_behind = true,
				player_push_speed_blocked_z = 1,
				freeze_intensity_decay_time = -1,
				offset_up = 0.5,
				player_push_speed_z = 1,
				range = 2,
				lock_attack_time = 2.1,
				player_push_speed = 16,
				reset_attack_animation_speed = 1.3,
				movement_speed = "run_speed",
				player_push_speed_blocked = 12,
				width = 1,
				attack_anim = {
					"attack_push_run_01"
				},
				attack_time = math.huge,
				ignore_staggers = {
					true,
					true,
					true,
					true,
					false,
					false,
					false,
					false
				},
				attack_finished_duration = BreedTweaks.attack_finished_duration.chaos_elite
			}
		}
	},
	push_attack = {
		damage = 0,
		hit_react_type = "heavy",
		fatigue_type = "bulwark_shield_bash",
		attack_intensity_type = "push",
		action_weight = 1,
		impact_push_speed = 11,
		damage_type = "blunt",
		unblockable = true,
		max_impact_push_speed = 9,
		difficulty_attack_intensity = var_0_3,
		considerations = UtilityConsiderations.chaos_bulwark_push_attack,
		attack_anim = {
			"attack_push"
		},
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			false,
			false,
			false
		},
		attack_finished_duration = BreedTweaks.attack_finished_duration.chaos_elite
	},
	smash_door = {
		unblockable = true,
		damage = 3,
		damage_type = "cutting",
		move_anim = "move_fwd",
		attack_anim = {
			"attack_blocker",
			"attack_blocker_2"
		}
	},
	blocked = {
		blocked_anims = {
			"blocked"
		},
		difficulty_duration = BreedTweaks.blocked_duration.chaos_elite
	},
	stagger = {
		custom_enter_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			assert(ScriptUnit.has_extension(arg_5_0, "ai_shield_system"), "chaos bulwark dont have ai_shield_user_extension")

			local var_5_0 = ScriptUnit.extension(arg_5_0, "ai_shield_system")
			local var_5_1 = arg_5_1.breed
			local var_5_2 = arg_5_1.stagger
			local var_5_3 = "idle_shield_down"
			local var_5_4 = Quaternion.forward(Unit.local_rotation(arg_5_0, 0))
			local var_5_5 = Quaternion.look(var_5_4)
			local var_5_6
			local var_5_7

			if arg_5_1.stagger_level == var_0_0.shield_block_stagger then
				var_5_7 = arg_5_1.stagger_time + math.max(0.5, var_5_2 * 0.3) * var_5_1.block_stagger_mod
				var_5_6 = arg_5_3.stagger_anims[var_0_0.shield_block_stagger]

				arg_5_1.stagger_direction:store(var_5_4)
				var_5_0:set_is_blocking(true)
			elseif arg_5_1.stagger_level == var_0_0.shield_open_stagger then
				var_5_7 = arg_5_1.stagger_time + var_5_2 * 0.3 * var_5_1.block_stagger_mod_2
				var_5_6 = arg_5_3.stagger_anims[var_0_0.shield_open_stagger]

				arg_5_1.stagger_direction:store(var_5_4)

				arg_5_1.reset_after_stagger = true

				var_5_0:set_is_blocking(false)
			else
				var_5_6 = arg_5_3.stagger_anims[arg_5_1.stagger_type]
				var_5_7 = arg_5_1.stagger_time + var_5_2 * 0.5 * var_5_1.block_stagger_mod_2
				var_5_5 = nil
				arg_5_1.max_stagger_reached = true
				arg_5_1.reset_after_stagger = true

				var_5_0:set_is_blocking(false)
			end

			arg_5_1.stagger_time = var_5_7

			return var_5_6, var_5_3, var_5_3, var_5_5
		end,
		stagger_anims = {
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
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
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04"
				}
			},
			{
				fwd = {
					"stagger_shield_block_01",
					"stagger_shield_block_02",
					"stagger_shield_block_03",
					"stagger_shield_block_04",
					"stagger_shield_block_05"
				},
				bwd = {
					"stagger_shield_block_01",
					"stagger_shield_block_02",
					"stagger_shield_block_03",
					"stagger_shield_block_04",
					"stagger_shield_block_05"
				},
				left = {
					"stagger_shield_block_left"
				},
				right = {
					"stagger_shield_block_right"
				},
				dwn = {
					"stagger_shield_block_01",
					"stagger_shield_block_02",
					"stagger_shield_block_03",
					"stagger_shield_block_04",
					"stagger_shield_block_05"
				}
			},
			{
				fwd = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05"
				},
				bwd = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05"
				},
				left = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05"
				},
				right = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05"
				},
				dwn = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05"
				}
			}
		}
	}
}

BreedActions.chaos_bulwark = table.create_copy(BreedActions.chaos_bulwark, var_0_4)
