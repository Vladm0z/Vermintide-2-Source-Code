-- chunkname: @scripts/settings/terror_events/terror_events_military_pvp.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.HARDER
local var_0_3 = {
	military_end_event_survival_01 = {
		"military_end_event_survival_01_back",
		1,
		"military_end_event_survival_01_right",
		1
	},
	military_end_event_survival_02 = {
		"military_end_event_survival_02_right",
		5,
		"military_end_event_survival_02_left",
		5,
		"military_end_event_survival_02_middle",
		3,
		"military_end_event_survival_02_back",
		5
	},
	military_end_event_survival_03 = {
		"military_end_event_survival_03_right",
		5,
		"military_end_event_survival_03_left",
		5,
		"military_end_event_survival_03_middle",
		3,
		"military_end_event_survival_03_back",
		5
	},
	military_end_event_survival_04 = {
		"military_end_event_survival_04_right",
		5,
		"military_end_event_survival_04_left",
		5,
		"military_end_event_survival_04_middle",
		3,
		"military_end_event_survival_04_back",
		5
	},
	military_end_event_survival_05 = {
		"military_end_event_survival_05_right",
		5,
		"military_end_event_survival_05_left",
		5,
		"military_end_event_survival_05_middle",
		3,
		"military_end_event_survival_05_back",
		5
	}
}
local var_0_4 = {
	military_pvp_pacing_off = {
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
	military_pvp_pacing_on = {
		{
			"control_hordes",
			enable = true
		},
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		}
	},
	military_courtyard_event_start = {
		{
			"control_hordes",
			enable = false
		}
	},
	military_courtyard_event = {
		{
			"control_hordes",
			enable = false
		},
		{
			"set_master_event_running",
			name = "military_courtyard"
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
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_1_0)
				return var_0_1("chaos_marauder") < 5 and var_0_1("chaos_fanatic") < 6 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_2_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_3_0)
				return var_0_1("skaven_plague_monk") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_4_0)
				return var_0_1("chaos_marauder") < 5 and var_0_1("chaos_fanatic") < 6 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_5_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_done"
		}
	},
	military_courtyard_event_end = {
		{
			"control_pacing",
			enable = true
		}
	},
	military_temple_guards = {
		{
			"disable_kick"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards02",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards05",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards06",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards07",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards09",
			breed_name = "chaos_warrior"
		}
	},
	military_end_event_disable_pacing = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		}
	},
	military_end_event_survival_start = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"disable_kick"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "end_event_start",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "end_event_start",
			composition_type = "storm_vermin_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_6_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_start_done"
		}
	},
	military_end_event_survival_01_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_7_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2 and var_0_1("chaos_fanatic") < 4 and var_0_1("chaos_warrior") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_01_done"
		}
	},
	military_end_event_survival_01_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_8_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2 and var_0_1("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_01_done"
		}
	},
	military_end_event_survival_02_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_9_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2 and var_0_1("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	},
	military_end_event_survival_02_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "chaos_warriors_small",
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_10_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2 and var_0_1("chaos_fanatic") < 4 and var_0_1("chaos_warrior") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	},
	military_end_event_survival_02_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_11_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2 and var_0_1("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	},
	military_end_event_survival_02_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_12_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2 and var_0_1("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	},
	military_end_event_survival_03_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_13_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	},
	military_end_event_survival_03_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_14_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	},
	military_end_event_survival_03_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_middle",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_15_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	},
	military_end_event_survival_03_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_16_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	},
	military_end_event_survival_04_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_17_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("chaos_berzerker") < 2 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	},
	military_end_event_survival_04_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_18_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("chaos_berzerker") < 2 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	},
	military_end_event_survival_04_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_middle",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_19_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("chaos_berzerker") < 2 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	},
	military_end_event_survival_04_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_20_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("chaos_berzerker") < 2 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	},
	military_end_event_survival_05_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_left",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left_hidden",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_21_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("skaven_plague_monk") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	},
	military_end_event_survival_05_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_right",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_22_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("skaven_plague_monk") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	},
	military_end_event_survival_05_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_middle",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_23_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("skaven_plague_monk") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	},
	military_end_event_survival_05_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_back",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_24_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 6 and var_0_1("skaven_storm_vermin_commander") < 2 and var_0_1("skaven_plague_monk") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	},
	military_end_event_survival_06_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_25_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_06_done"
		}
	},
	military_end_event_survival_06_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_26_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_06_done"
		}
	},
	military_end_event_survival_06_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_27_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 5 and var_0_1("skaven_storm_vermin_commander") < 1 and var_0_1("chaos_marauder") < 2 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_06_done"
		}
	},
	military_end_event_survival_escape = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_start",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_28_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_escape_done"
		}
	},
	military_benchmark_cut_1 = {
		{
			"run_benchmark_func",
			func_name = "recycler_spawn_at",
			duration = 2,
			position = {
				122.242,
				120.009,
				-13.67
			}
		}
	},
	military_benchmark_cut_2 = {
		{
			"run_benchmark_func",
			func_name = "recycler_spawn_at",
			duration = 2,
			position = {
				134.609,
				72.881,
				-11.826
			}
		}
	},
	military_benchmark_cut_3 = {
		{
			"run_benchmark_func",
			func_name = "recycler_spawn_at",
			duration = 2,
			position = {
				149.89,
				26.701,
				59.579
			}
		}
	},
	military_benchmark_cut_4 = {
		{
			"run_benchmark_func",
			func_name = "recycler_spawn_at",
			duration = 2,
			position = {
				96.911,
				46.139,
				67.782
			}
		}
	},
	military_benchmark_cut_5 = {
		{
			"run_benchmark_func",
			func_name = "recycler_spawn_at",
			duration = 2,
			position = {
				-78.803,
				-76.952,
				66.482
			}
		}
	},
	military_benchmark_cut_6 = {
		{
			"run_benchmark_func",
			func_name = "recycler_spawn_at",
			duration = 2,
			position = {
				-131.688,
				-85.017,
				66.583
			}
		}
	},
	military_benchmark_troll_sound = {
		{
			"run_benchmark_func",
			func_name = "story_troll_sound"
		}
	},
	military_benchmark_1 = {
		{
			"run_benchmark_func",
			portal_id = "benchmark_fight1",
			func_name = "story_teleport_party"
		},
		{
			"delay",
			duration = 0.3
		},
		{
			"event_horde",
			spawner_id = "benchmark_1_2",
			composition_type = "ai_benchmark_cycle_stormvermin"
		},
		{
			"delay",
			duration = 0.2
		},
		{
			"event_horde",
			spawner_id = "benchmark_1_3",
			composition_type = "ai_benchmark_cycle_chaos_berzerker"
		},
		{
			"delay",
			duration = 0.2
		},
		{
			"event_horde",
			spawner_id = "courtyard",
			composition_type = "ai_benchmark_cycle_slaves"
		},
		{
			"delay",
			duration = 30
		},
		{
			"run_benchmark_func",
			radius_squared = 900,
			func_name = "story_destroy_close_units"
		},
		{
			"run_benchmark_func",
			portal_id = "Start",
			func_name = "story_teleport_party"
		}
	},
	military_benchmark_2 = {
		{
			"run_benchmark_func",
			portal_id = "benchmark_fight2",
			func_name = "story_teleport_party"
		},
		{
			"event_horde",
			spawner_id = "benchmark_2_2",
			composition_type = "ai_benchmark_cycle_plague_monks"
		},
		{
			"delay",
			duration = 0.5
		},
		{
			"delay",
			duration = 0.5
		},
		{
			"event_horde",
			spawner_id = "benchmark_2_3",
			composition_type = "ai_benchmark_cycle_chaos_marauder"
		},
		{
			"delay",
			duration = 0.5
		},
		{
			"event_horde",
			spawner_id = "benchmark_2_4",
			composition_type = "ai_benchmark_cycle_slaves"
		},
		{
			"delay",
			duration = 30
		},
		{
			"run_benchmark_func",
			radius_squared = 900,
			func_name = "story_destroy_close_units"
		},
		{
			"run_benchmark_func",
			portal_id = "Start",
			func_name = "story_teleport_party"
		}
	},
	military_benchmark_troll = {
		{
			"run_benchmark_func",
			ai_node_id = "benchmark_troll",
			func_name = "story_spawn_and_animate_troll"
		}
	},
	military_benchmark_end = {
		{
			"run_benchmark_func",
			func_name = "story_end_benchmark"
		}
	}
}

return {
	var_0_4,
	var_0_3
}
