-- chunkname: @scripts/settings/terror_events/terror_events_dlc_castle.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local HARD = scripts_settings_terror_events_terror_event_utils.HARD
local HARDER = scripts_settings_terror_events_terror_event_utils.HARDER
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local CATACLYSM = scripts_settings_terror_events_terror_event_utils.CATACLYSM
local tbl = {
	end_event_statuette_guards = {
		"end_event_statuette_guards_01",
		1,
		"end_event_statuette_guards_02",
		1,
		"end_event_statuette_guards_03",
		1,
		"end_event_statuette_guards_04",
		1
	}
}
local tbl_2 = {
	dlc_castle_control_pacing_disabled = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		}
	},
	dlc_castle_control_pacing_enabled = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	},
	castle_catacombs_welcome_committee = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "catacombs_welcome_committee",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_1_0)
				-- function 1
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "catacombs_special_welcome",
			composition_type = "chaos_warriors"
		}
	},
	castle_dining_hall_guards = {
		{
			"set_master_event_running",
			name = "dining_hall"
		},
		{
			"spawn_at_raw",
			spawner_id = "dining_hall_spawner_recruit",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_veteran",
			difficulty_requirement = HARD
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_champion",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_legend",
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_cataclysm",
			difficulty_requirement = CATACLYSM
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_cataclysm_02",
			difficulty_requirement = CATACLYSM
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 240,
			condition = function (arg_2_0)
				-- function 2
				return count_event_breed("chaos_warrior") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "castle_dining_hall_all_chaos_warriors_dead"
		}
	},
	castle_inner_sanctum_extra_spice_loop = {
		{
			"set_master_event_running",
			name = "inner_sanctum"
		},
		{
			"event_horde",
			spawner_id = "inner_sanctum",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_3_0)
				-- function 3
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = {
				10,
				12
			}
		},
		{
			"flow_event",
			flow_event_name = "castle_inner_sanctum_extra_spice_loop_restart"
		}
	},
	castle_inner_sanctum_stop_pacing = {
		{
			"control_pacing",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		}
	},
	castle_inner_sanctum_event_loop = {
		{
			"set_master_event_running",
			name = "inner_sanctum"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "inner_sanctum",
			composition_type = "event_smaller"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
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
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				8,
				10
			}
		},
		{
			"flow_event",
			flow_event_name = "castle_inner_sanctum_event_loop_restart"
		}
	},
	castle_inner_sanctum_stop_event = {
		{
			"stop_event",
			stop_event_name = "castle_inner_sanctum_event_loop"
		},
		{
			"stop_event",
			stop_event_name = "castle_inner_sanctum_extra_spice_loop"
		},
		{
			"disable_bots_in_carry_event"
		}
	},
	castle_chaos_boss = {
		{
			"control_pacing",
			enable = false
		},
		{
			"set_master_event_running",
			name = "castle_chaos_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "castle_chaos_boss",
			breed_name = "chaos_exalted_sorcerer_drachenfels"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_5_0)
				-- function 5
				return count_event_breed("chaos_exalted_sorcerer_drachenfels") == 1
			end
		},
		{
			"flow_event",
			flow_event_name = "castle_chaos_boss_spawn"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_6_0)
				-- function 6
				return count_event_breed("chaos_exalted_sorcerer_drachenfels") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "castle_chaos_boss_dead"
		}
	},
	castle_catacombs_end_event_start = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"disable_kick"
		}
	},
	castle_catacombs_end_event_loop = {
		{
			"set_master_event_running",
			name = "escape_catacombs"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "escape_catacombs",
			composition_type = "event_small"
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
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "castle_catacombs_end_event_loop_done"
		}
	},
	castle_catacombs_end_event_loop_extra_spice = {
		{
			"set_master_event_running",
			name = "escape_catacombs"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape_spice",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_8_0)
				-- function 8
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "castle_catacombs_end_event_loop_extra_spice_done"
		}
	},
	end_event_statuette_guards_01 = {
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard3",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	end_event_statuette_guards_02 = {
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard3",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	end_event_statuette_guards_03 = {
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard3",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	end_event_statuette_guards_04 = {
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette1_guard3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette2_guard3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "end_event_statuette3_guard3",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	castle_inner_sanctum_statuette_extra = {
		{
			"set_master_event_running",
			name = "inner_sanctum"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "inner_sanctum",
			composition_type = "event_smaller"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "castle_inner_sanctum_statuette_extra_done"
		}
	}
}

return {
	tbl_2,
	tbl
}
