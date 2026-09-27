-- chunkname: @scripts/settings/terror_events/terror_events_dlc_reikwald_river.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")

local function fn(arg_1_0)
	-- function 1
	return Managers.state.conflict:count_units_by_breed_during_event(arg_1_0)
end

local function fn_2(arg_2_0)
	-- function 2
	return Managers.state.conflict:count_units_by_breed(arg_2_0)
end

local function fn_3()
	-- function 3
	return #Managers.state.conflict:spawned_enemies()
end

local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local tbl = {
	reikwald_river_pacing_off = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_hordes",
			enable = true
		}
	},
	reikwald_river_pacing_on = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	},
	reikwald_river_enable_special_pacing = {
		{
			"control_specials",
			enable = true
		}
	},
	reikwald_river_disable_special_pacing = {
		{
			"control_specials",
			enable = false
		}
	},
	reikwald_river_enable_hordes_pacing = {
		{
			"control_hordes",
			enable = true
		}
	},
	reikwald_river_disable_hordes_pacing = {
		{
			"control_hordes",
			enable = false
		}
	},
	reikwald_river_plaza_01 = {
		{
			"delay",
			duration = 5
		}
	},
	reikwald_river_troll = {
		{
			"set_master_event_running",
			name = "river_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_boss",
			breed_name = "chaos_troll"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_4_0)
				-- function 4
				return fn_2("chaos_troll") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_troll_done"
		}
	},
	reikwald_river_troll_flush = {
		{
			"set_master_event_running",
			name = "river_troll_flush"
		},
		{
			"event_horde",
			spawner_id = "troll_cave_flush",
			composition_type = "plaza_wave_2_04"
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_troll_flush_done"
		}
	},
	reikwald_river_barrel_ambush_01 = {
		{
			"set_master_event_running",
			name = "barrel_ambush"
		},
		{
			"event_horde",
			spawner_id = "rescue_ship_ambush",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "rescue_ship_ambush",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "rescue_ship_ambush",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_5_0)
				-- function 5
				return not (fn("skaven_clan_rat") < 5) or fn("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "barrel_ambush_done"
		}
	},
	reikwald_river_swamp = {
		{
			"set_master_event_running",
			name = "warcamp_swamp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "chaos_shields"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = num_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_6_0)
				-- function 6
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or fn("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "warcamp_swamp_event_r",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10,
			difficulty_requirement = num_3
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			},
			difficulty_requirement = num_4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = num_3
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = num_3
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			},
			difficulty_requirement = num_4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_7_0)
				-- function 7
				return not (fn("chaos_berzerker") < 2) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or fn("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = num_4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = num_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_r",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			},
			difficulty_requirement = num_4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_8_0)
				-- function 8
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or fn("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_r",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = num_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_9_0)
				-- function 9
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or fn("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_r",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "warcamp_swamp_event_r",
			composition_type = "chaos_shields"
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_10_0)
				-- function 10
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or fn("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "warcamp_swamp_event_r",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "warcamp_swamp_event_l",
			composition_type = "chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_11_0)
				-- function 11
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or fn("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_swamp_done"
		}
	},
	reikwald_river_sea_battle_chaos_01 = {
		{
			"set_master_event_running",
			name = "chaos_ship_1"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_bulwark",
			spawner_id = "chaos_ship_01",
			difficulty_requirement = num_4
		},
		{
			"event_horde",
			spawner_id = "chaos_ship_01",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 3,
			difficulty_requirement = num_3
		},
		{
			"event_horde",
			spawner_id = "chaos_ship_01",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_12_0)
				-- function 12
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or not (fn("chaos_marauder_with_shield") < 2) or fn("chaos_fanatic") < 4
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_chaos_01_done"
		}
	},
	reikwald_river_sea_battle_landside_01 = {
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
			spawner_id = "sea_battle_landside_raw_01",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "sea_battle_landside_raw_01",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "sea_battle_landside_raw_01",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "sea_battle_landside_raw_01",
			breed_name = "skaven_poison_wind_globadier"
		}
	},
	reikwald_river_sea_battle_right_01 = {
		{
			"event_horde",
			spawner_id = "sea_battle_right_01",
			composition_type = "event_medium"
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
				return not (fn("skaven_clan_rat") < 4) or fn("skaven_slave") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_right_01",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_14_0)
				-- function 14
				return not (fn("skaven_clan_rat") < 2) or fn("skaven_slave") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_right_01_done"
		}
	},
	reikwald_river_sea_battle_left_01 = {
		{
			"event_horde",
			spawner_id = "sea_battle_left_01",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_15_0)
				-- function 15
				return not (fn("skaven_clan_rat") < 4) or fn("skaven_slave") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_left_01",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_16_0)
				-- function 16
				return not (fn("skaven_clan_rat") < 2) or fn("skaven_slave") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_left_01_done"
		}
	},
	reikwald_river_sea_battle_right_02 = {
		{
			"event_horde",
			spawner_id = "sea_battle_right_02",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "sea_battle_right_02",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_17_0)
				-- function 17
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_right_02",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_18_0)
				-- function 18
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_right_02_done"
		}
	},
	reikwald_river_sea_battle_left_02 = {
		{
			"event_horde",
			spawner_id = "sea_battle_left_02",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "sea_battle_left_02",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_19_0)
				-- function 19
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_left_02",
			composition_type = "event_large"
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_left_02_done"
		}
	},
	reikwald_river_sea_battle_right_03 = {
		{
			"event_horde",
			spawner_id = "sea_battle_right_03",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "sea_battle_right_03",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_20_0)
				-- function 20
				return fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_right_03",
			composition_type = "event_extra_spice_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_21_0)
				-- function 21
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_right_03",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_22_0)
				-- function 22
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_right_03_done"
		}
	},
	reikwald_river_sea_battle_left_03 = {
		{
			"event_horde",
			spawner_id = "sea_battle_left_03",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "sea_battle_left_03",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_23_0)
				-- function 23
				return fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_left_03",
			composition_type = "event_extra_spice_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_24_0)
				-- function 24
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_left_03",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_25_0)
				-- function 25
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_left_03_done"
		}
	},
	reikwald_river_sea_battle_front_03 = {
		{
			"event_horde",
			spawner_id = "sea_battle_front_03",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_26_0)
				-- function 26
				return not (fn("skaven_clan_rat") < 2) or fn("skaven_slave") < 2
			end
		},
		{
			"event_horde",
			spawner_id = "sea_battle_front_03",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_27_0)
				-- function 27
				return not (fn("skaven_clan_rat") < 4) or fn("skaven_slave") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_sea_battle_front_03_done"
		}
	},
	reikwald_river_sea_battle_replace_left_01 = {
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_01_clan_01",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_01_clan_02",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_01_clan_03",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_01_clan_04",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_01_captain",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	reikwald_river_sea_battle_replace_right_01 = {
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_01_clan_01",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_01_clan_02",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_01_clan_03",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_01_clan_04",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_01_captain",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	reikwald_river_sea_battle_replace_left_02 = {
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_02_clan_01",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_02_clan_02",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_02_clan_03",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_02_clan_04",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_02_captain",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	reikwald_river_sea_battle_replace_right_02 = {
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_02_clan_01",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_02_clan_02",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_02_clan_03",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_02_clan_04",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_02_captain",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	reikwald_river_sea_battle_replace_left_03 = {
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_03_clan_01",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_03_clan_02",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_03_clan_03",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_03_clan_04",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_left_03_captain",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	reikwald_river_sea_battle_replace_right_03 = {
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_03_clan_01",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_03_clan_02",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_03_clan_03",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_03_clan_04",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "raw_skaven_ship_right_03_captain",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	reikwald_river_chaos_sword_01 = {
		{
			"set_master_event_running",
			name = "chaos_sword"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 50
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "chaos_sword",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 3,
			difficulty_requirement = num_3
		},
		{
			"event_horde",
			spawner_id = "chaos_sword",
			composition_type = "chaos_warriors",
			difficulty_requirement = num_3
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
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or not (fn("chaos_marauder_with_shield") < 2) or fn("chaos_fanatic") < 4
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_chaos_sword_done"
		}
	},
	reikwald_river_shore_crash_01 = {
		{
			"set_master_event_running",
			name = "survive_beach_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "shore_crash_01",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "shore_crash_01",
			composition_type = "event_large"
		}
	},
	reikwald_river_gauntlet_01 = {
		{
			"set_master_event_running",
			name = "survive_beach_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "gauntlet_01_front",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "gauntlet_01",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_29_0)
				-- function 29
				return not (fn("skaven_clan_rat") < 5) or fn("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			spawner_id = "gauntlet_01",
			composition_type = "event_extra_spice_small"
		}
	},
	reikwald_river_gauntlet_02 = {
		{
			"set_master_event_running",
			name = "survive_beach_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "gauntlet_02",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "gauntlet_02",
			composition_type = "event_large"
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
				return not (fn("skaven_clan_rat") < 5) or fn("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			spawner_id = "gauntlet_02",
			composition_type = "event_extra_spice_small"
		}
	},
	reikwald_river_gauntlet_03 = {
		{
			"set_master_event_running",
			name = "survive_beach_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "gauntlet_03",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "gauntlet_03",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_31_0)
				-- function 31
				return not (fn("skaven_clan_rat") < 5) or fn("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			spawner_id = "gauntlet_03",
			composition_type = "event_extra_spice_small"
		}
	},
	reikwald_river_survive_beach_01 = {
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
			name = "survive_beach_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"flow_event",
			flow_event_name = "survive_beach_crescendo_starting"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "survive_beach_01",
			composition_type = "event_large"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "survive_beach_01",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_32_0)
				-- function 32
				return not (fn("skaven_clan_rat") < 10) or fn("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
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
			difficulty_requirement = num_3
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_33_0)
				-- function 33
				return not (fn("skaven_clan_rat") < 10) or fn("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "survive_beach_01",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "survive_beach_01",
			composition_type = "storm_vermin_shields_small"
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
			},
			difficulty_requirement = num_4
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "survive_beach_01",
			composition_type = "plague_monks_medium",
			difficulty_requirement = num_4
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_34_0)
				-- function 34
				return not (fn("skaven_clan_rat") < 10) or fn("skaven_storm_vermin_commander") < 4
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
			difficulty_requirement = num_3
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = num_4
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "survive_beach_01",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_35_0)
				-- function 35
				return not (fn("skaven_clan_rat") < 7) or fn("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_extra_spice_large"
		},
		{
			"spawn_special",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = num_3
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "survive_beach_01",
			composition_type = "plague_monks_medium",
			difficulty_requirement = num_4
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_36_0)
				-- function 36
				return not (fn("skaven_clan_rat") < 10) or not (fn("skaven_storm_vermin_commander") < 4) or fn("skaven_plague_monk") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "survive_beach_01",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "survive_beach_01",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_37_0)
				-- function 37
				return fn("skaven_slave") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "survive_beach_event_done"
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
	reikwald_river_survive_chaos_01 = {
		{
			"set_master_event_running",
			name = "chaos_beach_1"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 50
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "beach_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 3,
			difficulty_requirement = num_3
		},
		{
			"event_horde",
			spawner_id = "beach_chaos",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_38_0)
				-- function 38
				return not (fn("chaos_berzerker") < 3) or not (fn("chaos_raider") < 3) or not (fn("chaos_marauder") < 3) or not (fn("chaos_marauder_with_shield") < 2) or fn("chaos_fanatic") < 4
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "beach_chaos",
			composition_type = "event_small_fanatics"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_beach_chaos_01_done"
		}
	},
	reikwald_river_survive_chaos_spice_01 = {
		{
			"set_master_event_running",
			name = "chaos_beach_spice_1"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 50
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "beach_chaos",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "beach_chaos",
			composition_type = "chaos_warriors_small"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_39_0)
				-- function 39
				return not (fn("chaos_raider") < 2) or not (fn("chaos_marauder") < 2) or fn("chaos_warrior") < 1
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_beach_chaos_spice_01_done"
		}
	},
	reikwald_river_survive_ambush_01 = {
		{
			"set_master_event_running",
			name = "survive_ambush"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 50
		},
		{
			"event_horde",
			spawner_id = "rescue_ship_ambush",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "rescue_ship_ambush",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "rescue_ship_ambush",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_40_0)
				-- function 40
				return not (fn("skaven_clan_rat") < 5) or fn("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "survive_ambush_done"
		}
	},
	reikwald_river_doombringer_01 = {
		{
			"set_master_event_running",
			name = "reikwald_river_doombringer_01"
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_41_0)
				-- function 41
				return fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "doombringer_wreck",
			composition_type = "event_extra_spice_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_42_0)
				-- function 42
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_43_0)
				-- function 43
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_doombringer_01_done"
		}
	},
	reikwald_river_doombringer_02 = {
		{
			"set_master_event_running",
			name = "reikwald_river_doombringer_02"
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_44_0)
				-- function 44
				return fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "doombringer_wreck",
			composition_type = "event_extra_spice_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_45_0)
				-- function 45
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_46_0)
				-- function 46
				return not (fn("skaven_clan_rat") < 4) or not (fn("skaven_slave") < 4) or fn("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_doombringer_02_done"
		}
	},
	reikwald_river_doombringer_03 = {
		{
			"set_master_event_running",
			name = "reikwald_river_doombringer_03"
		},
		{
			"event_horde",
			spawner_id = "finale_floor",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_47_0)
				-- function 47
				return not (fn("skaven_clan_rat") < 2) or fn("skaven_slave") < 2
			end
		},
		{
			"event_horde",
			spawner_id = "doombringer_wreck",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_48_0)
				-- function 48
				return not (fn("skaven_clan_rat") < 4) or fn("skaven_slave") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_doombringer_03_done"
		}
	},
	reikwald_river_hooks = {
		{
			"set_master_event_running",
			name = "reikwald_river_hooks"
		},
		{
			"event_horde",
			spawner_id = "ship_sides",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_49_0)
				-- function 49
				return not (fn("skaven_clan_rat") < 2) or fn("skaven_slave") < 2
			end
		},
		{
			"event_horde",
			spawner_id = "ship_sides",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "doombringer_specials",
			composition_type = "crater_detour"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_50_0)
				-- function 50
				return not (fn("skaven_clan_rat") < 4) or fn("skaven_slave") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "reikwald_river_hooks_done"
		}
	}
}

return {
	tbl
}
