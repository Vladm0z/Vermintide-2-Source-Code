-- chunkname: @scripts/settings/terror_events/terror_events_farmlands.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.HARDER
local var_0_3 = var_0_0.HARDEST
local var_0_4 = {
	farmlands_rat_ogre = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend",
				"chaos_troll",
				"chaos_spawn"
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (arg_1_0)
				return var_0_1("skaven_rat_ogre") == 1 or var_0_1("skaven_stormfiend") == 1 or var_0_1("chaos_troll") == 1 or var_0_1("chaos_spawn") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"continue_when",
			condition = function (arg_2_0)
				return var_0_1("skaven_rat_ogre") < 1 and var_0_1("skaven_stormfiend") < 1 and var_0_1("chaos_troll") < 1 and var_0_1("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	},
	farmlands_storm_fiend = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "skaven_stormfiend"
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (arg_3_0)
				return var_0_1("skaven_stormfiend") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"continue_when",
			condition = function (arg_4_0)
				return var_0_1("skaven_stormfiend") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	},
	farmlands_chaos_troll = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "chaos_troll"
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (arg_5_0)
				return var_0_1("chaos_troll") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"continue_when",
			condition = function (arg_6_0)
				return var_0_1("chaos_troll") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	},
	farmlands_chaos_spawn = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "chaos_spawn"
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (arg_7_0)
				return var_0_1("chaos_spawn") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"continue_when",
			condition = function (arg_8_0)
				return var_0_1("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	},
	farmlands_minotaur_spawn = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (arg_9_0)
				return var_0_1("beastmen_minotaur") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"continue_when",
			condition = function (arg_10_0)
				return var_0_1("beastmen_minotaur") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	},
	farmlands_spawn_guards = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"spawn_at_raw",
			spawner_id = "wall_guard_01",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "wall_guard_02",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "wall_guard_03",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "windmill_guard",
			breed_name = "chaos_warrior"
		}
	},
	farmlands_prisoner_event_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"disable_kick"
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
			"set_master_event_running",
			name = "farmlands_prisoner_event_01"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "square_front",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "event_small_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_11_0)
				return var_0_1("chaos_marauder") < 3
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_12_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			spawner_id = "hay_barn_back",
			composition_type = "event_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_13_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		}
	},
	farmlands_hay_barn_bridge_guards = {
		{
			"spawn_at_raw",
			spawner_id = "hay_barn_bridge_guards",
			breed_name = "chaos_warrior"
		},
		{
			"set_time_challenge",
			time_challenge_name = "farmlands_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "farmlands_speed_event_cata"
		}
	},
	farmlands_prisoner_event_hay_barn = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
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
			"disable_kick"
		},
		{
			"set_master_event_running",
			name = "farmlands_prisoner_event_hay_barn"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"spawn_at_raw",
			spawner_id = "hay_barn_guards",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "hay_barn_manual_spawns",
			breed_name = "chaos_marauder"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_cellar_invis",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "hay_barn_front_invis",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "hay_barn_interior",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
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
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_14_0)
				return var_0_1("chaos_marauder") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_15_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			composition_type = "event_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_16_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 4
			end
		},
		{
			"event_horde",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_17_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			composition_type = "event_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_18_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		}
	},
	farmlands_prisoner_event_upper_square = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"disable_kick"
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
			"set_master_event_running",
			name = "farmlands_prisoner_event_upper_square"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			},
			difficulty_requirement = var_0_2
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_19_0)
				return var_0_1("chaos_marauder") < 3
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_20_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_21_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		}
	},
	farmlands_saw_mill_guards = {
		{
			"spawn_at_raw",
			spawner_id = "saw_mill_guards",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		}
	},
	farmlands_prisoner_event_sawmill_door = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
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
			"set_master_event_running",
			name = "farmlands_prisoner_event_sawmill_door"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "event_medium"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_22_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		}
	},
	farmlands_prisoner_event_sawmill = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
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
			"set_master_event_running",
			name = "farmlands_prisoner_event_sawmill"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "event_small_chaos"
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
				"skaven_gutter_runner"
			},
			difficulty_requirement = var_0_2
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_23_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_3
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_24_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_25_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_26_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_27_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		}
	},
	farmlands_gate_open_event_challenge = {
		{
			"has_completed_time_challenge",
			time_challenge_name = "farmlands_speed_event"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "farmlands_speed_event_cata"
		}
	},
	farmlands_gate_open_event_horde = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_2
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}
}

return {
	var_0_4
}
