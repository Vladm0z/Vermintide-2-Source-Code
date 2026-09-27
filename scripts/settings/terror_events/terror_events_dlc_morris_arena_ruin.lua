-- chunkname: @scripts/settings/terror_events/terror_events_dlc_morris_arena_ruin.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local add_enhancements_for_difficulty = scripts_settings_terror_events_terror_event_utils.add_enhancements_for_difficulty
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local tbl = {
	arena_ruin_terror = {
		{
			"inject_event",
			event_name = "arena_ruin_terror_start"
		},
		{
			"inject_event",
			event_name = "arena_ruin_terror_sequence"
		},
		{
			"inject_event",
			event_name = "arena_ruin_terror_end"
		}
	},
	arena_ruin_terror_sequence = {
		{
			"inject_event",
			event_name_list = {
				"deus_arena_ruin_terror_skaven_chaos",
				"deus_arena_ruin_terror_chaos_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_arena_ruin_terror_skaven_beastmen",
				"deus_arena_ruin_terror_beastmen_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"deus_arena_ruin_terror_chaos_beastmen",
				"deus_arena_ruin_terror_beastmen_chaos"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_ruin_terror_start = {
		{
			"set_master_event_running",
			name = "arena_ruin_terror"
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
	arena_ruin_terror_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 1
				return not (self.boss <= 0) or not (self.main <= 0) or self.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "false"
		}
	},
	deus_arena_ruin_terror_skaven_chaos = {
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_skaven_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_chaos_wave_2"
			}
		}
	},
	deus_arena_ruin_terror_skaven_beastmen = {
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_skaven_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_beastmen_wave_2"
			}
		}
	},
	deus_arena_ruin_terror_chaos_skaven = {
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_chaos_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_skaven_wave_2"
			}
		}
	},
	deus_arena_ruin_terror_chaos_beastmen = {
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_chaos_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_beastmen_wave_2"
			}
		}
	},
	deus_arena_ruin_terror_beastmen_skaven = {
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_beastmen_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_skaven_wave_2"
			}
		}
	},
	deus_arena_ruin_terror_beastmen_chaos = {
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_beastmen_wave_1"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_ruin_terror_chaos_wave_2"
			}
		}
	},
	arena_ruin_terror_skaven_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_skaven_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 2
				return self.main < 10
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_ruin_terror_special",
			spawn_counter_category = "boss",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend"
			},
			pre_spawn_func = add_enhancements_for_difficulty
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 3
				return self.boss < 1
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 4
				return self.main < 10
			end
		}
	},
	arena_ruin_terror_skaven_wave_2 = {
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_large",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 5
				return self.main < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawn_counter_category = "elite",
			composition_type = "storm_vermin_medium",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 6
				return self.elite < 4
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 7
				return self.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		}
	},
	arena_ruin_terror_chaos_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_chaos_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 8
				return self.main < 8
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawn_counter_category = "main",
			composition_type = "event_chaos_extra_spice_medium",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 9
				return self.main < 10
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "arena_ruin_terror_special",
			spawn_counter_category = "boss",
			breed_name = {
				"chaos_troll",
				"chaos_spawn"
			},
			pre_spawn_func = add_enhancements_for_difficulty
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde",
			composition_type = "morris_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 10
				return self.boss < 1
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "elite",
			composition_type = "morris_elite_medium_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			spawner_id = "arena_ruin_terror_horde2",
			composition_type = "morris_small_chaos"
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 11
				return self.elite < 4
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 12
				return self.main < 10
			end
		}
	},
	arena_ruin_terror_chaos_wave_2 = {
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawn_counter_category = "elite",
			composition_type = "morris_elite_medium_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "morris_small_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 13
				return self.elite < 4
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 14
				return self.main < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "morris_small_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "elite",
			composition_type = "morris_elite_medium_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "morris_small_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 15
				return self.elite < 4
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 16
				return self.main < 10
			end
		},
		{
			"event_horde",
			spawn_counter_category = "main",
			composition_type = "morris_small_chaos",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"event_horde",
			spawn_counter_category = "elite",
			composition_type = "chaos_warriors",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		}
	},
	arena_ruin_terror_beastmen_wave_1 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_beastmen_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_large_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawn_counter_category = "main",
			composition_type = "morris_small_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "elite",
			composition_type = "bestigors",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 17
				return self.elite < 4
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 18
				return self.main < 10
			end
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "arena_ruin_terror_special",
			spawn_counter_category = "boss",
			pre_spawn_func = add_enhancements_for_difficulty
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawn_counter_category = "main",
			composition_type = "morris_small_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawn_counter_category = "elite",
			composition_type = "morris_elite_medium_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "morris_small_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 19
				return self.boss < 1
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 20
				return self.elite < 4
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 21
				return self.main < 10
			end
		}
	},
	arena_ruin_terror_beastmen_wave_2 = {
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawn_counter_category = "main",
			composition_type = "ungor_archers",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 22
				return self.main < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "morris_small_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 23
				return self.main < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawn_counter_category = "elite",
			composition_type = "morris_elite_medium_beastmen",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "elite",
			composition_type = "bestigors",
			spawner_ids = {
				"arena_ruin_terror_horde",
				"arena_ruin_terror_horde2"
			}
		},
		{
			"delay",
			duration = 10
		}
	},
	arena_ruin_terror_skaven_special = {
		{
			"set_master_event_running",
			name = "arena_ruin_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			spawner_id = "arena_ruin_terror_special",
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
			spawner_id = "arena_ruin_terror_special",
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
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 24
				return self.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_specials_done"
		}
	},
	arena_ruin_terror_chaos_special = {
		{
			"set_master_event_running",
			name = "arena_ruin_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			spawner_id = "arena_ruin_terror_special",
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
			spawner_id = "arena_ruin_terror_special",
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
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 25
				return self.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_specials_done"
		}
	},
	arena_ruin_terror_beastmen_special = {
		{
			"set_master_event_running",
			name = "arena_ruin_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			breed_name = "beastmen_standard_bearer",
			spawner_id = "arena_ruin_terror_special",
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
			condition = function (self)
				-- function 26
				return self.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_ruin_terror_specials_done"
		}
	}
}

return {
	tbl
}
