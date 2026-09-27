-- chunkname: @scripts/settings/terror_events/terror_events_mines.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local tbl = {
	mines_end_event_loop_02 = {
		"mines_end_event_loop_02_chaos",
		1,
		"mines_end_event_loop_02_skaven",
		1
	},
	mines_end_event_specials = {
		"mines_end_event_specials_01",
		1,
		"mines_end_event_specials_02",
		1,
		"mines_end_event_specials_03",
		1
	}
}
local tbl_2 = {
	mines_enable_carry_bots = {
		{
			"enable_bots_in_carry_event"
		}
	},
	mines_disable_carry_bots = {
		{
			"disable_bots_in_carry_event"
		}
	},
	mines_end_event_start = {
		{
			"control_pacing",
			enable = false
		},
		{
			"disable_kick"
		},
		{
			"control_specials",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		}
	},
	mines_end_event_first_wave = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_1_0)
				-- function 1
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_first_wave_done"
		}
	},
	mines_end_event_loop = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_2_0)
				-- function 2
				return not (count_event_breed("chaos_marauder") < 2) or not (count_event_breed("chaos_marauder_with_shield") < 2) or count_event_breed("chaos_berzerker") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "plague_monks_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_3_0)
				-- function 3
				return not (count_event_breed("skaven_plague_monk") < 2) or not (count_event_breed("skaven_clan_rat") < 4) or not (count_event_breed("skaven_slave") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_loop_done"
		}
	},
	mines_end_event_loop_02_chaos = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_4_0)
				-- function 4
				return not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_5_0)
				-- function 5
				return not (count_event_breed("chaos_marauder") < 2) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_loop_02_done"
		}
	},
	mines_end_event_loop_02_skaven = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_6_0)
				-- function 6
				return not (count_event_breed("skaven_clan_rat") < 5) or not (count_event_breed("skaven_slave") < 5) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_7_0)
				-- function 7
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_loop_02_done"
		}
	},
	mines_end_event_specials_01 = {
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
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
			breed_name = "skaven_warpfire_thrower",
			amount = 1,
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 180,
			condition = function (arg_8_0)
				-- function 8
				return not (count_event_breed("skaven_poison_wind_globadier") < 1) or count_event_breed("skaven_warpfire_thrower") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_specials_done"
		}
	},
	mines_end_event_specials_02 = {
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			amount = 1,
			difficulty_requirement = HARDEST
		},
		{
			"spawn_special",
			breed_name = "chaos_corruptor_sorcerer",
			amount = 1,
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 180,
			condition = function (arg_9_0)
				-- function 9
				return not (count_event_breed("skaven_warpfire_thrower") < 1) or count_event_breed("skaven_pack_master") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_specials_done"
		}
	},
	mines_end_event_specials_03 = {
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
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
			amount = 1,
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 180,
			condition = function (arg_10_0)
				-- function 10
				return not (count_event_breed("skaven_ratling_gunner") < 1) or count_event_breed("skaven_pack_master") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_specials_done"
		}
	},
	mines_end_event_stop = {
		{
			"stop_event",
			stop_event_name = "mines_end_event_loop"
		},
		{
			"stop_event",
			stop_event_name = "mines_end_event_loop_02"
		},
		{
			"control_specials",
			enable = true
		}
	},
	mines_end_event_intro_trolls = {
		{
			"force_load_breed_package",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_09",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_10",
			breed_name = "chaos_dummy_troll"
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_intro_trolls_done"
		}
	},
	mines_end_event_trolls = {
		{
			"force_load_breed_package",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_01",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_02",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_03",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_04",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_05",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_06",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_07",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_08",
			breed_name = "chaos_dummy_troll"
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_trolls_done"
		}
	},
	mines_troll_boss = {
		{
			"spawn_at_raw",
			spawner_id = "troll_boss",
			breed_name = "chaos_troll"
		},
		{
			"set_time_challenge",
			time_challenge_name = "mines_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "mines_speed_event_cata"
		},
		{
			"continue_when",
			duration = 10000,
			condition = function (arg_11_0)
				-- function 11
				return count_event_breed("chaos_troll") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_troll_boss_done"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "mines_speed_event"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "mines_speed_event_cata"
		}
	},
	mines_end_event_escape = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "escape",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_12_0)
				-- function 12
				return not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "escape",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_13_0)
				-- function 13
				return not (count_event_breed("skaven_clan_rat") < 4) or not (count_event_breed("skaven_slave") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_escape_done"
		}
	}
}

return {
	tbl_2,
	tbl
}
