-- chunkname: @scripts/settings/terror_events/terror_events_dlc_wizards_trail.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.spawned_during_event
local var_0_3 = var_0_0.HARDEST
local var_0_4 = {
	trail_disable_pacing_mid = {
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		}
	},
	trail_enable_pacing_mid = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	},
	trail_disable_pacing_light = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		}
	},
	trail_enable_pacing_light = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	},
	trail_drawbridge_wallbreaker = {
		{
			"spawn_at_raw",
			spawner_id = "drawbridge_wall_breaker_01",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "drawbridge_wall_breaker_02",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			}
		}
	},
	trail_grim_path_ambush = {
		{
			"spawn_at_raw",
			spawner_id = "path_ambush_spawner_01",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "path_ambush_spawner_02",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_1_0)
				return var_0_1("skaven_poison_wind_globadier", "skaven_ratling_gunner", "skaven_warpfire_thrower") < 2
			end
		},
		{
			"delay",
			duration = 3
		}
	},
	trail_mid_event_recons = {
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_recons_special_02",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "trail_mid_event_recons_done"
		}
	},
	trail_mid_event_01 = {
		{
			"set_master_event_running",
			name = "trail_mid_event_01"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_01",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "storm_vermin_shields_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_2_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_roof",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_3_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "plague_monks_small"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_02",
			breed_name = {
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
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_extra_spice_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_02",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_4_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_03",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_roof",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 15
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 60
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_01",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_03",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_5_0)
				return var_0_2() < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_mid_event_01_done"
		}
	},
	trail_mid_event_04 = {
		{
			"set_master_event_running",
			name = "trail_mid_event_04"
		},
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "storm_vermin_shields_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_04_special",
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_04_boss",
			breed_name = {
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
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_6_0)
				return var_0_2() < 8
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_04_special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "event_extra_spice_medium"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function(arg_7_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_mid_event_04_done"
		}
	},
	trail_intro_disable_pacing_end = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		}
	},
	trail_end_event_first_wave = {
		{
			"set_master_event_running",
			name = "trail_end_event_first_wave"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_8_0)
				return var_0_2() < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_9_0)
				return var_0_2() < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_10_0)
				return var_0_2() < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_first_wave_done"
		}
	},
	trail_end_event_01 = {
		{
			"set_master_event_running",
			name = "trail_end_event_01"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_4",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_11_0)
				return var_0_2() < 8
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_end_event_boss",
			breed_name = {
				"chaos_spawn",
				"chaos_troll",
				"skaven_stormfiend"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_12_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_4",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_13_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_01_done"
		}
	},
	trail_end_event_urn_guards_01 = {
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_01",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_01",
			composition_type = "chaos_shields"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_01",
			composition_type = "chaos_raiders_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function(arg_14_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_urn_guards_01_done"
		}
	},
	trail_end_event_urn_guards_02 = {
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_02",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_02",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_end_event_urn_02",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function(arg_15_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_urn_guards_02_done"
		}
	},
	trail_end_event_urn_guards_03 = {
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "event_small_fanatics"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "chaos_raiders_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function(arg_16_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_urn_guards_03_done"
		}
	},
	trail_end_event_03 = {
		{
			"set_master_event_running",
			name = "trail_end_event_03"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function(arg_17_0)
				return var_0_2() < 8
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_02",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 45
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_18_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_3",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 60
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_19_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function(arg_20_0)
				return var_0_2() < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_03_done"
		}
	},
	trail_end_event_torch_hunter = {
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = var_0_3
		}
	},
	trail_enable_pacing_end_run = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		}
	}
}

return {
	var_0_4
}
