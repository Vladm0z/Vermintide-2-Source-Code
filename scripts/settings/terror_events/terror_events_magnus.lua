-- chunkname: @scripts/settings/terror_events/terror_events_magnus.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local count_breed = scripts_settings_terror_events_terror_event_utils.count_breed
local HARDER = scripts_settings_terror_events_terror_event_utils.HARDER
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local tbl = {
	magnus_door = {
		"magnus_door_a",
		1,
		"magnus_door_b",
		1
	}
}
local tbl_2 = {
	magnus_door_event_guards = {
		{
			"spawn_at_raw",
			spawner_id = "magnus_door_event_guards_01",
			breed_name = "chaos_warrior"
		}
	},
	magnus_gutter_runner_treasure = {
		{
			"spawn_special",
			breed_name = "skaven_gutter_runner",
			amount = {
				1,
				2
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_gutterrunner_stinger"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "gutter_runner_treasure_restart"
		}
	},
	magnus_door_a = {
		{
			"enable_bots_in_carry_event"
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
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_special",
			{
				2,
				3
			},
			spawner_id = "magnus_door_event_specials",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_1_0)
				-- function 1
				return not (count_breed("skaven_clan_rat") < 4) or count_breed("skaven_slave") < 4
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_special",
			spawner_id = "magnus_door_event_specials",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_2_0)
				-- function 2
				return not (count_breed("chaos_marauder") < 3) or count_breed("chaos_fanatic") < 3
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_3_0)
				-- function 3
				return not (count_breed("skaven_clan_rat") < 4) or count_breed("skaven_slave") < 3
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_4_0)
				-- function 4
				return not (count_breed("skaven_clan_rat") < 3) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_special",
			"skaven_plague_monk",
			{
				1,
				3
			},
			spawner_id = "magnus_door_event_specials",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_5_0)
				-- function 5
				return count_breed("chaos_marauder") < 4
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_6_0)
				-- function 6
				return not (count_breed("skaven_clan_rat") < 3) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_7_0)
				-- function 7
				return not (count_breed("chaos_marauder") < 4) or count_breed("chaos_fanatic") < 3
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			spawner_id = "magnus_door_event_specials",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			amount = {
				1,
				2
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_8_0)
				-- function 8
				return not (count_breed("skaven_clan_rat") < 4) or count_breed("skaven_slave") < 4
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_9_0)
				-- function 9
				return not (count_breed("skaven_clan_rat") < 3) or count_breed("skaven_slave") < 3
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			spawner_id = "magnus_door_event_specials",
			amount = {
				1,
				2
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_10_0)
				-- function 10
				return not (count_breed("chaos_marauder") < 3) or count_breed("chaos_fanatic") < 3
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_11_0)
				-- function 11
				return not (count_breed("skaven_clan_rat") < 3) or count_breed("skaven_slave") < 3
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_12_0)
				-- function 12
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		}
	},
	magnus_door_b = {
		{
			"enable_bots_in_carry_event"
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
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_special",
			spawner_id = "magnus_door_event_specials",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_13_0)
				-- function 13
				return count_breed("chaos_marauder") < 3
			end
		},
		{
			"spawn_special",
			"skaven_plague_monk",
			{
				2,
				3
			},
			spawner_id = "magnus_door_event_specials",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_14_0)
				-- function 14
				return not (count_breed("skaven_clan_rat") < 4) or count_breed("skaven_slave") < 4
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_15_0)
				-- function 15
				return count_breed("chaos_marauder") < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_16_0)
				-- function 16
				return not (count_breed("skaven_clan_rat") < 3) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			"skaven_warpfire_thrower",
			breed_name = "skaven_ratling_gunner",
			spawner_id = "magnus_door_event_specials",
			amount = {
				1,
				2
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_17_0)
				-- function 17
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_18_0)
				-- function 18
				return not (count_breed("skaven_clan_rat") < 3) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_19_0)
				-- function 19
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			spawner_id = "magnus_door_event_specials",
			amount = {
				1,
				2
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_20_0)
				-- function 20
				return not (count_breed("chaos_marauder") < 2) or count_breed("chaos_fanatic") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_21_0)
				-- function 21
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			{
				1,
				2
			},
			spawner_id = "magnus_door_event_specials",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_22_0)
				-- function 22
				return count_breed("chaos_marauder") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (arg_23_0)
				-- function 23
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		}
	},
	magnus_end_horde = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "magnus_end_horde_a",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_24_0)
				-- function 24
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			spawner_id = "magnus_end_horde_a",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_25_0)
				-- function 25
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		},
		{
			"delay",
			duration = 9
		},
		{
			"event_horde",
			spawner_id = "magnus_end_horde_a",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_26_0)
				-- function 26
				return not (count_breed("skaven_clan_rat") < 2) or count_breed("skaven_slave") < 2
			end
		}
	},
	magnus_door_event_stop = {
		{
			"stop_event",
			stop_event_name = "magnus_door_a"
		},
		{
			"stop_event",
			stop_event_name = "magnus_door_b"
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		},
		{
			"disable_bots_in_carry_event"
		}
	},
	magnus_end_event = {
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
			name = "magnus_end_event"
		},
		{
			"flow_event",
			flow_event_name = "magnus_horn_crescendo_starting"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn_first",
			composition_type = "event_large"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_27_0)
				-- function 27
				return not (count_event_breed("skaven_clan_rat") < 10) or count_event_breed("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "magnus_end_event_first_wave_killed"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"disable_kick"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARDER
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_28_0)
				-- function 28
				return not (count_event_breed("skaven_clan_rat") < 10) or count_event_breed("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "magnus_tower_chaos",
			composition_type = "chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_29_0)
				-- function 29
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_marauder_with_shield") < 5
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_ratling_gunner"
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "magnus_tower_horn",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_30_0)
				-- function 30
				return not (count_event_breed("skaven_clan_rat") < 10) or count_event_breed("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"control_specials",
			enable = true
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = HARDER
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = HARDEST
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_31_0)
				-- function 31
				return not (count_event_breed("skaven_clan_rat") < 7) or count_event_breed("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"spawn_special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 1
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_32_0)
				-- function 32
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 6
			end
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_chaos_extra_spice_medium",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_33_0)
				-- function 33
				return not (count_event_breed("chaos_warrior") < 2) or count_event_breed("chaos_raider") < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_34_0)
				-- function 34
				return not (count_event_breed("skaven_clan_rat") < 10) or not (count_event_breed("skaven_storm_vermin_commander") < 4) or count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_horn",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_35_0)
				-- function 35
				return count_event_breed("skaven_slave") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "magnus_horn_event_done"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_pacing",
			enable = true
		}
	},
	magnus_disable_pacing = {
		{
			"control_pacing",
			enable = false
		}
	}
}

return {
	tbl_2,
	tbl
}
