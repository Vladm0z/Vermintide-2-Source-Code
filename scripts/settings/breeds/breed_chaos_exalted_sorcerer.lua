-- chunkname: @scripts/settings/breeds/breed_chaos_exalted_sorcerer.lua

local var_0_0 = require("scripts/utils/stagger_types")
local var_0_1 = {
	detection_radius = 9999999,
	show_health_bar = true,
	walk_speed = 0.65,
	race = "chaos",
	headshot_coop_stamina_fatigue_type = "headshot_special",
	server_controlled_health_bar = true,
	behavior = "chaos_exalted_sorcerer",
	has_inventory = true,
	height = 2.4,
	armored_on_no_damage = true,
	bot_hitbox_radius_approximation = 0.8,
	lord_damage_reduction = true,
	aoe_radius = 0.7,
	animation_sync_rpc = "rpc_sync_anim_state_7",
	unit_template = "ai_unit_chaos_exalted_sorcerer",
	death_reaction = "ai_default",
	ai_strength = 10,
	ai_toughness = 10,
	minion_detection_radius = 10,
	bone_lod_level = 1,
	wield_inventory_on_spawn = true,
	max_vortex_units = 3,
	default_inventory_template = "chaos_exalted_sorcerer",
	threat_value = 8,
	dialogue_source_name = "chaos_exalted_sorcerer",
	flingable = true,
	radius = 1,
	boss = true,
	disable_second_hit_ragdoll = true,
	proximity_system_check = true,
	poison_resistance = 100,
	armor_category = 3,
	smart_targeting_width = 0.3,
	is_bot_aid_threat = true,
	initial_is_passive = false,
	boost_curve_multiplier_override = 1.8,
	target_selection = "pick_boss_sorcerer_target",
	run_speed = 0.65,
	awards_positive_reinforcement_message = true,
	exchange_order = 2,
	combat_music_state = "champion_chaos_exalted_sorcerer",
	hit_reaction = "ai_default",
	smart_targeting_outer_width = 0.7,
	hit_effect_template = "HitEffectsChaosExaltedSorcerer",
	smart_targeting_height_multiplier = 2.2,
	max_chain_stagger_time = 2,
	smart_object_template = "special",
	perception = "perception_all_seeing_boss",
	player_locomotion_constrain_radius = 0.7,
	far_off_despawn_immunity = true,
	is_of_interest_func = "is_of_interest_boss_sorcerer",
	vortexable = false,
	base_unit = "units/beings/enemies/chaos_sorcerer_boss/chr_chaos_sorcerer_boss",
	aoe_height = 2.1,
	infighting = InfightingSettings.boss,
	size_variation_range = {
		1.27,
		1.27
	},
	max_health = BreedTweaks.max_health.exalted_sorcerer,
	bloodlust_health = BreedTweaks.bloodlust_health.monster,
	stagger_modifier_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
		if not arg_1_4.unit then
			return arg_1_0, arg_1_1, arg_1_2
		end

		if arg_1_4.stagger_count >= var_0_0.heavy then
			arg_1_0 = var_0_0.none
			arg_1_4.stagger_ignore_anim_cb = true
		else
			arg_1_4.stagger_ignore_anim_cb = false
		end

		return arg_1_0, arg_1_1, arg_1_2
	end,
	status_effect_settings = {
		category = "medium",
		ignored_statuses = table.set({
			StatusEffectNames.burning_warpfire,
			StatusEffectNames.poisoned
		})
	},
	debug_color = {
		255,
		200,
		200,
		0
	},
	run_on_spawn = AiBreedSnippets.on_chaos_exalted_sorcerer_spawn,
	run_on_update = AiBreedSnippets.on_chaos_exalted_sorcerer_update,
	run_on_death = AiBreedSnippets.on_chaos_exalted_sorcerer_death,
	run_on_despawn = AiBreedSnippets.on_chaos_exalted_sorcerer_despawn,
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
				"c_hips",
				"c_spine",
				"c_spine1",
				"c_leftshoulder",
				"c_rightshoulder"
			},
			push_actors = {
				"j_spine1"
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
				"j_spine1"
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
				"j_spine1"
			}
		},
		left_leg = {
			prio = 3,
			actors = {
				"c_leftupleg",
				"c_leftleg",
				"c_leftfoot",
				"c_lefttoebase"
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
				"c_rightfoot",
				"c_righttoebase"
			},
			push_actors = {
				"j_leftfoot",
				"j_rightfoot",
				"j_hips"
			}
		},
		full = {
			prio = 4,
			actors = {}
		},
		afro = {
			prio = 5,
			actors = {
				"h_afro"
			}
		}
	},
	allowed_layers = {
		planks = 1.5,
		ledges = 5,
		bot_ratling_gun_fire = 10,
		jumps = 5,
		destructible_wall = 0,
		temporary_wall = 2,
		ledges_with_fence = 5,
		doors = 1.5,
		teleporters = 5,
		bot_poison_wind = 2,
		fire_grenade = 10
	},
	difficulty_kill_achievements = {
		"kill_chaos_exalted_sorcerer_difficulty_rank",
		"kill_chaos_exalted_sorcerer_scorpion_hardest"
	},
	custom_death_enter_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		if not Unit.alive(arg_2_1) then
			return
		end

		QuestSettings.check_killed_lord_as_last_player_standing(arg_2_1)
	end
}

Breeds.chaos_exalted_sorcerer = table.create_copy(Breeds.chaos_exalted_sorcerer, var_0_1)

local var_0_2 = 4
local var_0_3 = 12
local var_0_4 = 2 * math.pi / ((var_0_3 + 1) * 0.5)
local var_0_5 = {
	skulking = {
		third_wave_max_distance = 7,
		third_wave_min_distance = 1,
		close_distance = 7,
		sorcerer_type = "exalted",
		move_animation = "move_fwd",
		min_cast_vortex_distance = 0,
		search_func_name = "update_portal_search",
		max_cast_vortex_distance = 75,
		teleport_closer_range = 5,
		far_away_from_target_sq = 400,
		max_player_vortex_distance = 15,
		vortex_spawn_timer = 3,
		preferred_distance = 10,
		part_hp_lost_to_teleport = 0.01,
		min_player_vortex_distance = 0,
		vortex_check_timer = 2,
		vanish_timer = 8,
		min_wave_distance = 13,
		vanish_countdown = 7.5,
		max_wave_distance = 25,
		teleport_cooldown = {
			7,
			10
		},
		missile_spawn_offset = {
			0.1281,
			1.1719,
			1.3749
		},
		available_spells = {
			"vortex",
			"plague_wave",
			"magic_missile",
			"seeking_bomb_missile"
		},
		after_casting_delay = {
			hardest = 0,
			normal = 3,
			hard = 1.5,
			harder = 0.5,
			cataclysm = 1.5,
			easy = 4,
			versus_base = 3,
			cataclysm_3 = 0,
			cataclysm_2 = 0.5
		}
	},
	spawn_boss_vortex = {
		cleanup_func_name = "_clean_up_vortex_summoning",
		vortex_template_name = "boss_sorcerer",
		link_decal_units_to_vortex = true,
		spawn_func_name = "_spawn_boss_vortex",
		outer_decal_unit_name = "units/decals/decal_vortex_circle_outer",
		attack_anim = "attack_staff",
		inner_decal_unit_name = "units/decals/decal_vortex_circle_inner",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	spawn_flower_wave = {
		spawn_func_name = "spawn_plague_waves_in_patterns",
		max_wave_to_target_dist = 5,
		damage_wave_template = "pattern_plague_wave",
		pattern_repetitions = 1,
		init_func_name = "init_summon_plague_wave_sequence",
		update_func_name = "update_sequenced_plague_wave_spawning",
		duration_between_waves = 0.1,
		ignore_attack_finished = true,
		range = 8,
		spawner_set_id = "sorcerer_boss_center",
		attack_anim = "attack_wave_summon_start",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		},
		num_waves = var_0_3,
		spawn_rot_func = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = Unit.local_rotation(arg_3_2, 0)
			local var_3_1 = arg_3_1.random_flower_angles and arg_3_1.random_flower_angles[arg_3_1.wave_counter] or var_0_4 * arg_3_1.wave_counter
			local var_3_2 = Quaternion(Vector3.up(), var_3_1)

			return (Quaternion.multiply(var_3_0, var_3_2))
		end,
		sequence_init_func = function (arg_4_0, arg_4_1)
			local var_4_0 = {}
			local var_4_1 = math.random()

			for iter_4_0 = 1, var_0_3 do
				var_4_1 = var_4_1 + var_0_4
				var_4_0[iter_4_0] = var_4_1
			end

			table.shuffle(var_4_0)

			arg_4_1.random_flower_angles = var_4_0
		end
	},
	spawn_multiple_wave = {
		spawn_func_name = "spawn_plague_waves_in_patterns",
		max_wave_to_target_dist = 5,
		damage_wave_template = "plague_wave",
		init_func_name = "init_summon_plague_wave",
		pattern_repetitions = 3,
		attack_anim = "attack_wave_summon_start",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		},
		spawn_rot_func = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			local var_5_0 = Unit.local_rotation(arg_5_0, 0)
			local var_5_1 = (arg_5_3 - 2) * 0.3
			local var_5_2 = Quaternion(Vector3.up(), var_5_1)

			return (Quaternion.multiply(var_5_0, var_5_2))
		end,
		goal_pos_func = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
			local var_6_0, var_6_1 = GwNavQueries.raycast(arg_6_1.nav_world, arg_6_4, arg_6_5)

			if var_6_1 then
				return var_6_1
			end
		end
	},
	cast_missile = {
		volley_delay = 0.3,
		volleys = 2,
		cast_anim = "attack_shoot_hand",
		nav_tag_volume_layer = "bot_poison_wind",
		create_nav_tag_volume = true,
		launch_angle = 1,
		damage_type = "poison",
		duration = 8,
		face_target_while_casting = true,
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		},
		missile_spawn_offset = {
			0.1281,
			1.1719,
			1.3749
		},
		init_spell_func = function (arg_7_0)
			arg_7_0.current_spell = arg_7_0.sorcerer_strike_missile_data
		end,
		get_throw_position_func = function (arg_8_0, arg_8_1, arg_8_2)
			local var_8_0 = ScriptUnit.has_extension(arg_8_0, "ai_inventory_system").inventory_item_units[1]
			local var_8_1 = Unit.world_position(var_8_0, Unit.node(var_8_0, "j_skull_2_parent"))
			local var_8_2 = Vector3.normalize(arg_8_2 - var_8_1)

			return var_8_1, var_8_2
		end
	},
	cast_seeking_bomb_missile = {
		cast_anim = "attack_shoot_staff",
		volleys = 1,
		create_nav_tag_volume = true,
		nav_tag_volume_layer = "bot_poison_wind",
		volley_delay = 0.3,
		damage_type = "poison",
		duration = 8,
		face_target_while_casting = true,
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		},
		radius = var_0_2,
		initial_radius = var_0_2 * 0.6,
		missile_spawn_offset = {
			0.1281,
			1.1719,
			1.3749
		}
	},
	quick_teleport = {
		teleport_effect = "fx/chr_chaos_sorcerer_teleport",
		radius = 4,
		push_close_players = true,
		push_speed = 10,
		catapult_players = true,
		push_speed_z = 6,
		teleport_effect_trail = "fx/chr_chaos_sorcerer_teleport_direction",
		teleport_end_anim = "teleport_end",
		teleport_start_anim = "teleport_start",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	defensive_magic_missile = {
		create_nav_tag_volume = true,
		cast_anim = "attack_shoot_hand",
		nav_tag_volume_layer = "bot_poison_wind",
		launch_angle = 1,
		damage_type = "poison",
		duration = 8,
		face_target_while_casting = true,
		volleys = 2,
		volley_delay = 0.3,
		action_weight = 1,
		considerations = UtilityConsiderations.defensive_magic_missile,
		radius = var_0_2,
		initial_radius = var_0_2 * 0.6,
		missile_spawn_offset = {
			0.1281,
			1.1719,
			1.3749
		},
		init_spell_func = function (arg_9_0)
			arg_9_0.current_spell = arg_9_0.sorcerer_strike_missile_data
		end,
		get_throw_position_func = function (arg_10_0, arg_10_1, arg_10_2)
			local var_10_0 = ScriptUnit.has_extension(arg_10_0, "ai_inventory_system").inventory_item_units[1]
			local var_10_1 = Unit.world_position(var_10_0, Unit.node(var_10_0, "j_skull_2_parent"))
			local var_10_2 = Vector3.normalize(arg_10_2 - var_10_1)

			return var_10_1, var_10_2
		end,
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	defensive_seeking_bomb = {
		create_nav_tag_volume = true,
		volleys = 1,
		damage_type = "poison",
		nav_tag_volume_layer = "bot_poison_wind",
		volley_delay = 0.3,
		action_weight = 1,
		cast_anim = "attack_shoot_staff",
		duration = 8,
		face_target_while_casting = true,
		considerations = UtilityConsiderations.defensive_seeking_bomb,
		missile_spawn_offset = {
			0.1281,
			1.1719,
			1.3749
		},
		init_spell_func = function (arg_11_0)
			arg_11_0.current_spell = arg_11_0.seeking_bomb_missile_data
		end,
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	intro_idle = {
		duration = 21,
		animation = "intro_lord",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	defensive_idle = {
		animation = "idle_guard",
		duration = 3,
		action_weight = 1,
		considerations = UtilityConsiderations.defensive_sorcerer_idle,
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	defensive_escape_teleport = {
		teleport_effect = "fx/chr_chaos_sorcerer_teleport",
		teleport_end_anim = "teleport_end",
		teleport_effect_trail = "fx/chr_chaos_sorcerer_teleport_direction",
		teleport_start_anim = "teleport_start",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		},
		teleport_pos_func = function (arg_12_0, arg_12_1)
			local var_12_0 = ConflictUtils.get_random_spawner_with_id("sorcerer_boss", arg_12_1.defensive_spawner)

			arg_12_1.defensive_spawner = var_12_0

			return Unit.local_position(var_12_0, 0)
		end
	},
	defensive_teleport = {
		teleport_effect = "fx/chr_chaos_sorcerer_teleport",
		teleport_end_anim = "teleport_end",
		teleport_effect_trail = "fx/chr_chaos_sorcerer_teleport_direction",
		teleport_start_anim = "teleport_start",
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	spawn_allies = {
		stinger_name = "enemy_horde_chaos_stinger",
		stay_still = true,
		terror_event_id = "sorcerer_boss_minion",
		duration = 5,
		find_spawn_points = false,
		animation = "idle_guard",
		difficulty_spawn = {
			hardest = "sorcerer_boss_event_defensive",
			normal = "sorcerer_boss_event_defensive",
			hard = "sorcerer_boss_event_defensive",
			harder = "sorcerer_boss_event_defensive",
			cataclysm = "sorcerer_boss_event_defensive",
			easy = "sorcerer_boss_event_defensive",
			versus_base = "sorcerer_boss_event_defensive",
			cataclysm_3 = "sorcerer_boss_event_defensive",
			cataclysm_2 = "sorcerer_boss_event_defensive"
		},
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	spawn_allies_horde = {
		stay_still = true,
		terror_event_id = "sorcerer_boss_minion",
		duration = 1,
		find_spawn_points = false,
		animation = "idle_guard",
		difficulty_spawn = {
			hardest = "sorcerer_extra_spawn",
			normal = "sorcerer_extra_spawn",
			hard = "sorcerer_extra_spawn",
			harder = "sorcerer_extra_spawn",
			cataclysm = "sorcerer_extra_spawn",
			easy = "sorcerer_extra_spawn",
			versus_base = "sorcerer_extra_spawn",
			cataclysm_3 = "sorcerer_extra_spawn",
			cataclysm_2 = "sorcerer_extra_spawn"
		},
		ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			true
		}
	},
	stagger = {
		custom_enter_function = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			arg_13_1.stagger_ignore_anim_cb = true

			return arg_13_3.stagger_anims[arg_13_1.stagger_type], "idle"
		end,
		stagger_anims = {
			{
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				right = {
					"stagger_left_light"
				},
				left = {
					"stagger_right_light"
				}
			},
			{
				fwd = {
					"stagger_fwd"
				},
				bwd = {
					"stagger_bwd"
				},
				right = {
					"stagger_left"
				},
				left = {
					"stagger_right"
				}
			},
			{
				fwd = {
					"stagger_fwd"
				},
				bwd = {
					"stagger_bwd"
				},
				right = {
					"stagger_left"
				},
				left = {
					"stagger_right"
				}
			},
			{
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				right = {
					"stagger_left_light"
				},
				left = {
					"stagger_right_light"
				}
			},
			{
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				right = {
					"stagger_left_light"
				},
				left = {
					"stagger_right_light"
				}
			},
			{
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				right = {
					"stagger_left_exp"
				},
				left = {
					"stagger_right_exp"
				}
			},
			{
				fwd = {
					"stagger_fwd"
				},
				bwd = {
					"stagger_bwd"
				},
				right = {
					"stagger_left"
				},
				left = {
					"stagger_right"
				}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {
					"stagger_fwd"
				},
				bwd = {
					"stagger_bwd"
				},
				right = {
					"stagger_left"
				},
				left = {
					"stagger_right"
				}
			}
		}
	}
}

local function var_0_6(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = table.clone(arg_14_1)

	var_14_0.considerations = UtilityConsiderations[arg_14_0]
	var_14_0.action_weight = 1
	var_14_0.available_spells = {
		arg_14_2
	}

	return var_14_0
end

var_0_5.vortex_skulking = var_0_6("vortex_skulking", var_0_5.skulking, "vortex")
var_0_5.vortex_skulking.search_func_name = "_update_vortex_search"
var_0_5.tentacle_skulking = var_0_6("tentacle_skulking", var_0_5.skulking, "tentacle")
var_0_5.plague_wave_skulking = var_0_6("exalted_plague_wave_skulking", var_0_5.skulking, "plague_wave")
var_0_5.magic_missile_skulking = var_0_6("magic_missile_skulking", var_0_5.skulking, "magic_missile")
var_0_5.seeking_bomb_missile_skulking = var_0_6("seeking_bomb_missile_skulking", var_0_5.skulking, "seeking_bomb_missile")
BreedActions.chaos_exalted_sorcerer = table.create_copy(BreedActions.chaos_exalted_sorcerer, var_0_5)
