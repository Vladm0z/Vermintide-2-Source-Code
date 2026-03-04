-- chunkname: @scripts/settings/terror_events/terror_events_dlc_morris_arena_cave.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.HARDEST
local var_0_2 = var_0_0.add_enhancements_for_difficulty
local var_0_3 = {
	arena_cave_terror = {
		{
			"inject_event",
			event_name = "arena_cave_terror_start"
		},
		{
			"inject_event",
			event_name = "arena_cave_terror_sequence"
		},
		{
			"inject_event",
			event_name = "arena_cave_terror_end"
		}
	},
	arena_cave_terror_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_arena_cave_terror_skaven_chaos",
				"deus_arena_cave_terror_chaos_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_arena_cave_terror_skaven_beastmen",
				"deus_arena_cave_terror_beastmen_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_arena_cave_terror_chaos_beastmen",
				"deus_arena_cave_terror_beastmen_chaos"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_cave_terror_start = {
		{
			"set_master_event_running",
			name = "arena_cave_terror"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_wwise_override_state",
			name = "terror_mb2"
		}
	},
	arena_cave_terror_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_1_0)
				return arg_1_0.boss <= 0 and arg_1_0.main <= 0 and arg_1_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_arena_cave_terror_skaven_chaos = {
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_skaven_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_chaos_wave_2"
			}
		}
	},
	deus_arena_cave_terror_skaven_beastmen = {
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_skaven_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_beastmen_wave_2"
			}
		}
	},
	deus_arena_cave_terror_chaos_skaven = {
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_chaos_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_skaven_wave_2"
			}
		}
	},
	deus_arena_cave_terror_chaos_beastmen = {
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_chaos_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_beastmen_wave_2"
			}
		}
	},
	deus_arena_cave_terror_beastmen_skaven = {
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_beastmen_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_skaven_wave_2"
			}
		}
	},
	deus_arena_cave_terror_beastmen_chaos = {
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_beastmen_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_cave_terror_chaos_wave_2"
			}
		}
	},
	arena_cave_terror_skaven_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_skaven_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_cave_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_2_0)
				return arg_2_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_3_0)
				return arg_3_0.main < 8
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_4_0)
				return arg_4_0.elite < 4
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_cave_event",
			spawn_counter_category = "boss",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend"
			},
			pre_spawn_func = var_0_2
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_5_0)
				return arg_5_0.boss < 1
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_6_0)
				return arg_6_0.main < 10
			end
		}
	},
	arena_cave_terror_skaven_wave_2 = {
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_7_0)
				return arg_7_0.main < 8
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_8_0)
				return arg_8_0.elite < 4
			end
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		}
	},
	arena_cave_terror_chaos_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_chaos_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_cave_event",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_9_0)
				return arg_9_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_10_0)
				return arg_10_0.main < 10
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_cave_event",
			spawn_counter_category = "boss",
			breed_name = {
				"chaos_troll",
				"chaos_spawn"
			},
			pre_spawn_func = var_0_2
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_11_0)
				return arg_11_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_cave_event",
			composition_type = "morris_small_chaos"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_cave_event",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_12_0)
				return arg_12_0.main < 10
			end
		}
	},
	arena_cave_terror_chaos_wave_2 = {
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_13_0)
				return arg_13_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_14_0)
				return arg_14_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 10
		}
	},
	arena_cave_terror_beastmen_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_beastmen_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_medium_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_cave_event",
			composition_type = "bestigors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_15_0)
				return arg_15_0.elite < 3
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_16_0)
				return arg_16_0.main < 10
			end
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "arena_cave_event",
			spawn_counter_category = "boss",
			pre_spawn_func = var_0_2
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "event_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "ungor_archers"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_17_0)
				return arg_17_0.boss < 1
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_18_0)
				return arg_18_0.main < 10
			end
		}
	},
	arena_cave_terror_beastmen_wave_2 = {
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "ungor_archers"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_19_0)
				return arg_19_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "bestigors"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_cave_event",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_20_0)
				return arg_20_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "ungor_archers"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 1,
			spawner_id = "arena_cave_event",
			composition_type = "bestigors"
		},
		{
			"delay",
			duration = 10
		}
	},
	arena_cave_terror_skaven_special = {
		{
			"set_master_event_running",
			name = "arena_cave_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			spawner_id = "arena_cave_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_ratling_gunner"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_cave_event",
			spawn_counter_category = "special",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_ratling_gunner"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_1
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_21_0)
				return arg_21_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_specials_done"
		}
	},
	arena_cave_terror_chaos_special = {
		{
			"set_master_event_running",
			name = "arena_cave_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			spawner_id = "arena_cave_event",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_cave_event",
			spawn_counter_category = "special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_1
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_22_0)
				return arg_22_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_specials_done"
		}
	},
	arena_cave_terror_beastmen_special = {
		{
			"set_master_event_running",
			name = "arena_cave_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			breed_name = "beastmen_standard_bearer",
			spawner_id = "arena_cave_event",
			difficulty_amount = {
				hardest = 3,
				hard = 1,
				harder = 2,
				cataclysm = 4,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_23_0)
				return arg_23_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_cave_terror_specials_done"
		}
	}
}

return {
	var_0_3
}
