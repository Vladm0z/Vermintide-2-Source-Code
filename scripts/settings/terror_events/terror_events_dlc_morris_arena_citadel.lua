-- chunkname: @scripts/settings/terror_events/terror_events_dlc_morris_arena_citadel.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.add_enhancements_for_difficulty
local var_0_2 = var_0_0.HARDER
local var_0_3 = var_0_0.HARDEST
local var_0_4 = {
	citadel_arena_a1 = {
		{
			"inject_event",
			event_name = "citadel_arena_a1_start"
		},
		{
			"inject_event",
			event_name = "citadel_arena_a1_sequence"
		},
		{
			"inject_event",
			event_name = "citadel_arena_a1_end"
		}
	},
	citadel_arena_a1_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_a1_skaven",
				"deus_citadel_arena_a1_chaos"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_a1_skaven",
				"deus_citadel_arena_a1_beastmen"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_a1_chaos",
				"deus_citadel_arena_a1_beastmen"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	citadel_arena_a1_start = {
		{
			"set_master_event_running",
			name = "citadel_arena_a1"
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
			name = "terror_mb1"
		}
	},
	citadel_arena_a1_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_1_0)
				return arg_1_0.boss <= 0 and arg_1_0.main <= 0 and arg_1_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "citadel_arena_a1_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_citadel_arena_a1_skaven = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_ledge",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_manual",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_a1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_2_0)
				return arg_2_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "morris_elite_medium_skaven"
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
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_a1_chaos = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_4_0)
				return arg_4_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_5_0)
				return arg_5_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_a1_beastmen = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_6_0)
				return arg_6_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "morris_elite_medium_beastmen"
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
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a1",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		}
	},
	citadel_arena_a2 = {
		{
			"inject_event",
			event_name = "citadel_arena_a2_start"
		},
		{
			"inject_event",
			event_name = "citadel_arena_a2_sequence"
		},
		{
			"inject_event",
			event_name = "citadel_arena_a2_end"
		}
	},
	citadel_arena_a2_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_a2_skaven",
				"deus_citadel_arena_a2_chaos"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_a2_skaven",
				"deus_citadel_arena_a2_beastmen"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_a2_chaos",
				"deus_citadel_arena_a2_beastmen"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	citadel_arena_a2_start = {
		{
			"set_master_event_running",
			name = "citadel_arena_a2"
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
			name = "terror_mb1"
		}
	},
	citadel_arena_a2_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_8_0)
				return arg_8_0.boss <= 0 and arg_8_0.main <= 0 and arg_8_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "citadel_arena_a2_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_citadel_arena_a2_skaven = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_ledge",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_manual",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_manual",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 1,
			difficulty_requirement = var_0_2
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_a2_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_2
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
			spawner_id = "arena_citadel_a2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_10_0)
				return arg_10_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_a2_chaos = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_11_0)
				return arg_11_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
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
				return arg_12_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_a2_beastmen = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_13_0)
				return arg_13_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "morris_elite_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_14_0)
				return arg_14_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_a2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		}
	},
	citadel_arena_b1 = {
		{
			"inject_event",
			event_name = "citadel_arena_b1_start"
		},
		{
			"inject_event",
			event_name = "citadel_arena_b1_sequence"
		},
		{
			"inject_event",
			event_name = "citadel_arena_b1_end"
		}
	},
	citadel_arena_b1_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_b1_chaos",
				"deus_citadel_arena_b1_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_b1_beastmen",
				"deus_citadel_arena_b1_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_b1_beastmen",
				"deus_citadel_arena_b1_chaos"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	citadel_arena_b1_start = {
		{
			"set_master_event_running",
			name = "citadel_arena_b1"
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
			name = "terror_mb1"
		}
	},
	citadel_arena_b1_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_15_0)
				return arg_15_0.boss <= 0 and arg_15_0.main <= 0 and arg_15_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "citadel_arena_b1_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_citadel_arena_b1_skaven = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_16_0)
				return arg_16_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_ledge",
			composition_type = "event_small"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_17_0)
				return arg_17_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_ledge",
			composition_type = "event_small"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_b1_chaos = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_18_0)
				return arg_18_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_chaos"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_19_0)
				return arg_19_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_chaos"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_b1_beastmen = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b1_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_20_0)
				return arg_20_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_beastmen"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_21_0)
				return arg_21_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1",
			composition_type = "morris_small_beastmen"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b1_manual",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		}
	},
	citadel_arena_b2 = {
		{
			"inject_event",
			event_name = "citadel_arena_b2_start"
		},
		{
			"inject_event",
			event_name = "citadel_arena_b2_sequence"
		},
		{
			"inject_event",
			event_name = "citadel_arena_b2_end"
		}
	},
	citadel_arena_b2_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_b2_chaos",
				"deus_citadel_arena_b2_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_b2_beastmen",
				"deus_citadel_arena_b2_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_citadel_arena_b2_beastmen",
				"deus_citadel_arena_b2_chaos"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	citadel_arena_b2_start = {
		{
			"set_master_event_running",
			name = "citadel_arena_b2"
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
			name = "terror_mb1"
		}
	},
	citadel_arena_b2_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_22_0)
				return arg_22_0.boss <= 0 and arg_22_0.main <= 0 and arg_22_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "citadel_arena_b2_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_citadel_arena_b2_skaven = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_ledge",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_manual",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_b2_manual",
			spawn_counter_category = "main",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_23_0)
				return arg_23_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_24_0)
				return arg_24_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2_ledge",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_b2_chaos = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_25_0)
				return arg_25_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_26_0)
				return arg_26_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		}
	},
	deus_citadel_arena_b2_beastmen = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_27_0)
				return arg_27_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "morris_elite_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_28_0)
				return arg_28_0.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_b2",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		}
	},
	arena_citadel_terror = {
		{
			"inject_event",
			event_name = "arena_citadel_terror_start"
		},
		{
			"inject_event",
			event_name = "arena_citadel_terror_sequence"
		},
		{
			"inject_event",
			event_name = "arena_citadel_terror_end"
		}
	},
	arena_citadel_terror_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_arena_citadel_terror_skaven_chaos",
				"deus_arena_citadel_terror_chaos_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_arena_citadel_terror_skaven_beastmen",
				"deus_arena_citadel_terror_beastmen_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_arena_citadel_terror_chaos_beastmen",
				"deus_arena_citadel_terror_beastmen_chaos"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_citadel_terror_start = {
		{
			"set_master_event_running",
			name = "arena_citadel_terror"
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
			name = "terror_mb3"
		}
	},
	arena_citadel_terror_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_29_0)
				return arg_29_0.boss <= 0 and arg_29_0.main <= 0 and arg_29_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_arena_citadel_terror_skaven_chaos = {
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_skaven_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_chaos_wave_2"
			}
		}
	},
	deus_arena_citadel_terror_skaven_beastmen = {
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_skaven_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_beastmen_wave_2"
			}
		}
	},
	deus_arena_citadel_terror_chaos_skaven = {
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_chaos_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_skaven_wave_2"
			}
		}
	},
	deus_arena_citadel_terror_chaos_beastmen = {
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_chaos_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_beastmen_wave_2"
			}
		}
	},
	deus_arena_citadel_terror_beastmen_skaven = {
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_beastmen_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_skaven_wave_2"
			}
		}
	},
	deus_arena_citadel_terror_beastmen_chaos = {
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_beastmen_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_citadel_terror_chaos_wave_2"
			}
		}
	},
	arena_citadel_terror_skaven_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_skaven_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_citadel_final_ledge",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_30_0)
				return arg_30_0.main < 15
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_citadel_final_ledge",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_31_0)
				return arg_31_0.main < 30
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_32_0)
				return arg_32_0.main < 10
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_final_manual",
			spawn_counter_category = "boss",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend"
			},
			pre_spawn_func = var_0_1
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_33_0)
				return arg_33_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_34_0)
				return arg_34_0.main < 10
			end
		}
	},
	arena_citadel_terror_skaven_wave_2 = {
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_skaven_special"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_ledge",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (arg_35_0)
				return arg_35_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_ledge",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_36_0)
				return arg_36_0.boss < 1
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_final_manual",
			spawn_counter_category = "boss",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend"
			},
			pre_spawn_func = var_0_1
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (arg_37_0)
				return arg_37_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_38_0)
				return arg_38_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_ledge",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_39_0)
				return arg_39_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_40_0)
				return arg_40_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "morris_elite_medium_skaven"
		},
		{
			"delay",
			duration = 5
		}
	},
	arena_citadel_terror_chaos_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_chaos_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_41_0)
				return arg_41_0.main < 15
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_42_0)
				return arg_42_0.main < 30
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_43_0)
				return arg_43_0.main < 10
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_final_manual",
			spawn_counter_category = "boss",
			breed_name = {
				"chaos_troll",
				"chaos_spawn"
			},
			pre_spawn_func = var_0_1
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_44_0)
				return arg_44_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_45_0)
				return arg_45_0.main < 10
			end
		}
	},
	arena_citadel_terror_chaos_wave_2 = {
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_chaos_special"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (arg_46_0)
				return arg_46_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_47_0)
				return arg_47_0.boss < 1
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_citadel_final_manual",
			spawn_counter_category = "boss",
			breed_name = {
				"chaos_troll",
				"chaos_spawn"
			},
			pre_spawn_func = var_0_1
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (arg_48_0)
				return arg_48_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_49_0)
				return arg_49_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_50_0)
				return arg_50_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "morris_elite_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_51_0)
				return arg_51_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 5
		}
	},
	arena_citadel_terror_beastmen_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_beastmen_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_52_0)
				return arg_52_0.main < 15
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			limit_spawners = 2,
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_53_0)
				return arg_53_0.main < 30
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_54_0)
				return arg_54_0.main < 10
			end
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "arena_citadel_final_manual",
			spawn_counter_category = "boss",
			pre_spawn_func = var_0_1
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_55_0)
				return arg_55_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_56_0)
				return arg_56_0.main < 10
			end
		}
	},
	arena_citadel_terror_beastmen_wave_2 = {
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_beastmen_special"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (arg_57_0)
				return arg_57_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_58_0)
				return arg_58_0.boss < 1
			end
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "arena_citadel_final_manual",
			spawn_counter_category = "boss",
			pre_spawn_func = var_0_1
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (arg_59_0)
				return arg_59_0.boss < 1
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final_platform",
			composition_type = "morris_elite_medium_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_60_0)
				return arg_60_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "event_medium_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_61_0)
				return arg_61_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "morris_elite_medium_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_62_0)
				return arg_62_0.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_citadel_final",
			composition_type = "bestigors"
		},
		{
			"delay",
			duration = 5
		}
	},
	arena_citadel_terror_skaven_special = {
		{
			"set_master_event_running",
			name = "arena_citadel_terror"
		},
		{
			"spawn_special",
			spawn_counter_category = "special",
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
			"spawn_special",
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
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_63_0)
				return arg_63_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_specials_done"
		}
	},
	arena_citadel_terror_chaos_special = {
		{
			"set_master_event_running",
			name = "arena_citadel_terror"
		},
		{
			"spawn_special",
			spawn_counter_category = "special",
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
			"spawn_special",
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
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (arg_64_0)
				return arg_64_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_specials_done"
		}
	},
	arena_citadel_terror_beastmen_special = {
		{
			"set_master_event_running",
			name = "arena_citadel_terror"
		},
		{
			"spawn_special",
			spawn_counter_category = "special",
			breed_name = "beastmen_standard_bearer",
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
			condition = function (arg_65_0)
				return arg_65_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_citadel_terror_specials_done"
		}
	}
}

return {
	var_0_4
}
