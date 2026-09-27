-- chunkname: @scripts/settings/terror_events/terror_events_dlc_wizards_tower.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local num_spawned_enemies = scripts_settings_terror_events_terror_event_utils.num_spawned_enemies
local HARD = scripts_settings_terror_events_terror_event_utils.HARD
local HARDER = scripts_settings_terror_events_terror_event_utils.HARDER
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local CATACLYSM = scripts_settings_terror_events_terror_event_utils.CATACLYSM
local tbl = {
	wt_end_event_intro_wave = {
		"wt_end_event_intro_wave_a",
		1,
		"wt_end_event_intro_wave_b",
		1,
		"wt_end_event_intro_wave_c",
		1
	},
	wt_end_event_wave_01 = {
		"wt_end_event_wave_01_a",
		1,
		"wt_end_event_wave_01_b",
		1,
		"wt_end_event_wave_01_c",
		1
	},
	wt_end_event_wave_02 = {
		"wt_end_event_wave_02_a",
		1,
		"wt_end_event_wave_02_b",
		1,
		"wt_end_event_wave_02_c",
		1
	},
	wt_end_event_wave_03 = {
		"wt_end_event_wave_03_a",
		1,
		"wt_end_event_wave_03_b",
		1,
		"wt_end_event_wave_03_c",
		1
	},
	wt_end_event_wave_04 = {
		"wt_end_event_wave_04_a",
		1,
		"wt_end_event_wave_04_b",
		1,
		"wt_end_event_wave_04_c",
		1
	},
	wt_end_event_specials = {
		"wt_end_event_specials_01",
		1,
		"wt_end_event_specials_02",
		1,
		"wt_end_event_specials_03",
		1,
		"wt_end_event_specials_04",
		1,
		"wt_end_event_specials_05",
		1
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local var_1_0 = BLACKBOARDS[arg_1_0]

	if not var_1_0 then
		var_1_0.high_ground_opportunity = true
		var_1_0.spawning_finished = true
		var_1_0.instant_spawn = true

		local var_1_1 = POSITION_LOOKUP[arg_1_0]
		local forward = Quaternion.forward(Unit.local_rotation(arg_1_0, 0))
		local num = var_1_1 + forward * 5 + Vector3.down()

		var_1_0.jump_data = {
			enemy_spine_node = 0,
			instant_jump = true,
			delay_jump_start = false,
			segment_list = {},
			jump_target_pos = Vector3Box(num),
			jump_velocity_boxed = Vector3Box(forward * 5),
			total_distance = Vector3.distance(num, var_1_1)
		}
	end
end

local tbl_2 = {
	wt_disable_pacing = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		}
	},
	wt_enable_pacing = {
		{
			"control_hordes",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	},
	painting_jumper_spawn_001 = {
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "painting_jumper_spawn_001",
			optional_data = {
				spawned_func = fn
			}
		}
	},
	painting_jumper_spawn_002 = {
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "painting_jumper_spawn_002",
			optional_data = {
				spawned_func = fn
			}
		}
	},
	painting_jumper_spawn_003 = {
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "painting_jumper_spawn_003",
			optional_data = {
				spawned_func = fn
			}
		}
	},
	wt_library_event = {
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
			"delay",
			duration = 5
		},
		{
			"set_master_event_running",
			name = "wt_library"
		},
		{
			"flow_event",
			flow_event_name = "wt_library_starting"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners_side",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_2_0)
				-- function 2
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_3_0)
				-- function 3
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"flow_event",
			flow_event_name = "wt_library_event_pause_a"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_4_0)
				-- function 4
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners_side",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_5_0)
				-- function 5
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_alt_objectives"
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_6_0)
				-- function 6
				return count_event_breed("skaven_slave") < 4
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"flow_event",
			flow_event_name = "wt_library_event_pause_b"
		},
		{
			"delay",
			duration = 10
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "library_spawners_side",
			composition_type = "event_smaller"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_7_0)
				-- function 7
				return count_event_breed("skaven_slave") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "library_spawners",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_8_0)
				-- function 8
				return count_event_breed("skaven_slave") < 4
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn",
			{
				2,
				4
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_9_0)
				-- function 9
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"flow_event",
			flow_event_name = "wt_library_event_pause_c"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners_side",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_10_0)
				-- function 10
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "library_spawners_side",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "library_spawners_side",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "library_spawners",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_11_0)
				-- function 11
				return count_event_breed("skaven_slave") < 4
			end
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_12_0)
				-- function 12
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"flow_event",
			flow_event_name = "wt_library_event_done"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"stop_master_event"
		}
	},
	wt_library_boss4 = {
		{
			"spawn_at_raw",
			spawner_id = "library_manual_4",
			breed_name = "skaven_ratling_gunner"
		}
	},
	wt_library_boss2 = {
		{
			"spawn_at_raw",
			spawner_id = "library_manual_2",
			breed_name = "skaven_pack_master"
		}
	},
	wt_library_boss3 = {
		{
			"spawn_at_raw",
			spawner_id = "library_manual_3",
			breed_name = "skaven_poison_wind_globadier"
		}
	},
	wt_library_boss1 = {
		{
			"set_master_event_running",
			name = "wt_library_boss1"
		},
		{
			"spawn_at_raw",
			spawner_id = "library_manual_1",
			breed_name = "skaven_stormfiend"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_13_0)
				-- function 13
				return count_event_breed("skaven_stormfiend") < 1
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "wt_library_boss_dead"
		}
	},
	wt_dining_boss = {
		{
			"spawn_at_raw",
			"skaven_stormfiend",
			"chaos_troll",
			"chaos_spawn",
			spawner_id = "dining_manual",
			breed_name = "skaven_rat_ogre"
		}
	},
	wt_end_event_intro_wave_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_intro_wave"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_14_0)
				-- function 14
				return not (count_event_breed("skaven_clan_rat") < 2) or not (count_event_breed("skaven_slave") < 4) or not (count_event_breed("chaos_marauder") < 2) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_intro_wave_done"
		}
	},
	wt_end_event_intro_wave_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_intro_wave"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_15_0)
				-- function 15
				return not (count_event_breed("chaos_marauder") < 3) or not (count_event_breed("chaos_fanatic") < 3) or count_event_breed("chaos_raider") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_intro_wave_done"
		}
	},
	wt_end_event_intro_wave_c = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_intro_wave"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_16_0)
				-- function 16
				return not (count_event_breed("skaven_clan_rat") < 2) or count_event_breed("skaven_slave") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_intro_wave_done"
		}
	},
	wt_end_event_wave_01_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_01"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_17_0)
				-- function 17
				return num_spawned_enemies() < 15
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_01_done"
		}
	},
	wt_end_event_wave_01_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_01"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "wt_end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_18_0)
				-- function 18
				return num_spawned_enemies() < 15
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_01_done"
		}
	},
	wt_end_event_wave_01_c = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_01"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "chaos_warriors_small",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_19_0)
				-- function 19
				return count_event_breed("chaos_warrior") < 1
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_01_done"
		}
	},
	wt_end_event_wave_02_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_20_0)
				-- function 20
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_02_done"
		}
	},
	wt_end_event_wave_02_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "event_medium_shield"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_21_0)
				-- function 21
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_02_done"
		}
	},
	wt_end_event_wave_02_c = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "event_medium"
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			spawner_id = "wt_end_event",
			amount = 1
		},
		{
			"spawn_special",
			breed_name = "chaos_vortex_sorcerer",
			spawner_id = "wt_end_event",
			amount = 1
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_22_0)
				-- function 22
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_02_done"
		}
	},
	wt_end_event_wave_03_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "wt_end_event",
			composition_type = "chaos_warriors_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_23_0)
				-- function 23
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_03_done"
		}
	},
	wt_end_event_wave_03_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "wt_end_event",
			composition_type = "storm_vermin_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_24_0)
				-- function 24
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_03_done"
		}
	},
	wt_end_event_wave_03_c = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "crawl_end_event_chaos_small"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "wt_end_event",
			composition_type = "chaos_raiders_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "wt_end_event",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_25_0)
				-- function 25
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_03_done"
		}
	},
	wt_end_event_wave_04_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_04"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_26_0)
				-- function 26
				return num_spawned_enemies() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wtr_end_event",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wtr_end_event",
			composition_type = "chaos_shields"
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_04_repeat"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_27_0)
				-- function 27
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_04_done"
		}
	},
	wt_end_event_wave_04_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_04"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_28_0)
				-- function 28
				return num_spawned_enemies() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wtr_end_event",
			composition_type = "event_medium_chaos"
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_04_repeat"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_29_0)
				-- function 29
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_04_done"
		}
	},
	wt_end_event_wave_04_c = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"set_master_event_running",
			name = "wt_end_event_wave_04"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wt_end_event",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_30_0)
				-- function 30
				return num_spawned_enemies() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wtr_end_event",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "wtr_end_event",
			composition_type = "storm_vermin_shields_small"
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_04_repeat"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_31_0)
				-- function 31
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_wave_04_done"
		}
	},
	wt_end_event_constant = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 20
		},
		{
			"set_master_event_running",
			name = "wt_end_event_constant"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "wt_end_event_pool",
			composition_type = "event_small_fanatics"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 15,
			condition = function (arg_32_0)
				-- function 32
				return count_event_breed("chaos_fanatic") < 15
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_constant_done"
		}
	},
	wt_end_warriors = {
		{
			"set_master_event_running",
			name = "end_warriors"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_warriors_recruit",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "end_event_warriors_veteran",
			difficulty_requirement = HARD
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "end_event_warriors_champion",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "end_event_warriors_legend",
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "end_event_warriors_cataclysm",
			difficulty_requirement = CATACLYSM
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "end_event_warriors_cataclysm_02",
			difficulty_requirement = CATACLYSM
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 240,
			condition = function (arg_33_0)
				-- function 33
				return count_event_breed("chaos_warrior") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "end_warriors_dead"
		}
	},
	wt_end_event_specials_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "wt_end_event_specials"
		},
		{
			"spawn_special",
			breed_name = "skaven_gutter_runner",
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 1,
				normal = 1
			}
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			amount = 1,
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_34_0)
				-- function 34
				return not (count_event_breed("skaven_gutter_runner") < 1) or count_event_breed("skaven_pack_master") < 1
			end
		},
		{
			"delay",
			duration = 42
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_specials_done"
		}
	},
	wt_end_event_specials_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "wt_end_event_specials"
		},
		{
			"spawn_special",
			breed_name = "skaven_warpfire_thrower",
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 1,
				normal = 1
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_35_0)
				-- function 35
				return not (count_event_breed("skaven_warpfire_thrower") < 1) or count_event_breed("skaven_gutter_runner") < 1
			end
		},
		{
			"delay",
			duration = 42
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_specials_done"
		}
	},
	wt_end_event_specials_03 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "wt_end_event_specials"
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 1,
				normal = 1
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_36_0)
				-- function 36
				return not (count_event_breed("skaven_ratling_gunner") < 1) or count_event_breed("skaven_pack_master") < 1
			end
		},
		{
			"delay",
			duration = 42
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_specials_done"
		}
	},
	wt_end_event_specials_04 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "wt_end_event_specials"
		},
		{
			"spawn_special",
			breed_name = "chaos_corruptor_sorcerer",
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
			duration = 10
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_37_0)
				-- function 37
				return count_event_breed("chaos_corruptor_sorcerer") < 1
			end
		},
		{
			"delay",
			duration = 42
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_specials_done"
		}
	},
	wt_end_event_specials_05 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "wt_end_event_specials"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_38_0)
				-- function 38
				return count_event_breed("chaos_vortex_sorcerer") < 1
			end
		},
		{
			"delay",
			duration = 42
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_specials_done"
		}
	},
	wt_end_event_boss = {
		{
			"set_master_event_running",
			name = "wt_end_event_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "event_minotaur",
			breed_name = "chaos_spawn"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_39_0)
				-- function 39
				return count_event_breed("chaos_spawn") < 1
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_boss_dead"
		}
	},
	wt_dining_sorcerers = {
		{
			"spawn_at_raw",
			spawner_id = "sorcerer_1",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "sorcerer_2",
			breed_name = "chaos_vortex_sorcerer"
		}
	},
	wt_end_event_skeletons = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "wt_end_event_skeletons"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 12,
			spawner_id = "wt_end_event_skeletons",
			composition_type = "wt_end_event_skeletons_01"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_40_0)
				-- function 40
				return not (count_event_breed("ethereal_skeleton_with_hammer") < 3) or count_event_breed("ethereal_skeleton_with_shield") < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_skeletons_done"
		}
	},
	wt_end_event_skeletons_end = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "wt_end_event_skeletons_end"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 12,
			spawner_id = "wt_end_event_skeletons",
			composition_type = "wt_end_event_skeletons_01"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_41_0)
				-- function 41
				return not (count_event_breed("ethereal_skeleton_with_hammer") < 3) or count_event_breed("ethereal_skeleton_with_shield") < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "wt_end_event_skeletons_end_done"
		}
	}
}

return {
	tbl_2,
	tbl
}
