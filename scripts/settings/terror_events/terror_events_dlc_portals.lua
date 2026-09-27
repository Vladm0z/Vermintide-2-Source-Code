-- chunkname: @scripts/settings/terror_events/terror_events_dlc_portals.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local HARDER = scripts_settings_terror_events_terror_event_utils.HARDER
local tbl = {
	dlc_portals_end_event = {
		"dlc_portals_end_event_a",
		1,
		"dlc_portals_end_event_b",
		1
	}
}
local tbl_2 = {
	dlc_portals_control_pacing_disabled = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		}
	},
	dlc_portals_control_pacing_enabled = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	},
	dlc_portals_temple_inside = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_temple_inside"
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
			spawner_id = "portals_temple_inside",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 6
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
			flow_event_name = "dlc_portals_temple_inside_done"
		}
	},
	dlc_portals_temple_inside_specials = {
		{
			"event_horde",
			spawner_id = "portals_temple_inside_specials",
			composition_type = "plague_monks_small"
		}
	},
	dlc_portals_temple_yard = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_temple_yard"
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
			spawner_id = "portals_temple_yard",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			spawner_id = "portals_temple_yard",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"event_horde",
			spawner_id = "portals_temple_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "portals_temple_yard",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_2_0)
				-- function 2
				return not (count_event_breed("chaos_marauder") < 3) or not (count_event_breed("chaos_fanatic") < 3) or count_event_breed("chaos_raider") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_temple_yard_done"
		}
	},
	dlc_portals_temple_yard_exit = {
		{
			"spawn_at_raw",
			spawner_id = "portals_temple_yard_exit",
			breed_name = "skaven_ratling_gunner"
		}
	},
	dlc_portals_end_event_a = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
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
			spawner_id = "portals_end_event_skaven",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_ratling_gunner"
			}
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 2,
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			spawner_id = "portals_end_event_skaven",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_3_0)
				-- function 3
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	},
	dlc_portals_end_event_b = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
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
			spawner_id = "portals_end_event",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 7
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner"
			},
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_4_0)
				-- function 4
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	},
	dlc_portals_end_event_c = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
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
			spawner_id = "portals_end_event_skaven",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			spawner_id = "portals_end_event",
			composition_type = "plague_monks_medium"
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			},
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			spawner_id = "portals_end_event_skaven",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_5_0)
				-- function 5
				return not (count_event_breed("skaven_clan_rat") < 5) or not (count_event_breed("skaven_slave") < 5) or count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	},
	dlc_portals_end_event_d = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
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
			spawner_id = "portals_end_event",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			spawner_id = "portals_end_event",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "portals_end_event",
			composition_type = "plague_monks_small",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_6_0)
				-- function 6
				return not (count_event_breed("chaos_marauder") < 3) or not (count_event_breed("chaos_fanatic") < 3) or count_event_breed("chaos_raider") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	},
	dlc_portals_end_event_guards = {
		{
			"event_horde",
			spawner_id = "portals_end_event_guards",
			composition_type = "chaos_warriors"
		}
	},
	dlc_portals_end_escape_specials = {
		{
			"event_horde",
			spawner_id = "portals_end_escape_specials",
			composition_type = "plague_monks_medium"
		}
	},
	dlc_portals_end_escape_a = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_escape"
		},
		{
			"disable_kick"
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
			spawner_id = "portals_end_event_skaven",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_skaven",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			breed_name = "skaven_warpfire_thrower",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
			difficulty_requirement = HARDER
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_skaven",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_7_0)
				-- function 7
				return not (count_event_breed("skaven_clan_rat") < 5) or not (count_event_breed("skaven_slave") < 5) or count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"delay",
			duration = {
				1,
				4
			}
		},
		{
			"flow_event",
			flow_event_name = "portals_end_escape_done"
		}
	},
	dlc_portals_end_escape_b = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_escape"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_special",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_8_0)
				-- function 8
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "event_small_chaos"
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
			difficulty_requirement = HARDER
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_9_0)
				-- function 9
				return not (count_event_breed("chaos_marauder") < 3) or not (count_event_breed("chaos_fanatic") < 3) or count_event_breed("chaos_raider") < 2
			end
		},
		{
			"delay",
			duration = {
				1,
				4
			}
		},
		{
			"flow_event",
			flow_event_name = "portals_end_escape_done"
		}
	},
	dlc_portals_end_escape_yard = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_escape_yard"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_10_0)
				-- function 10
				return not (count_event_breed("chaos_marauder") < 4) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_11_0)
				-- function 11
				return not (count_event_breed("chaos_marauder") < 3) or not (count_event_breed("chaos_fanatic") < 3) or count_event_breed("chaos_raider") < 2
			end
		},
		{
			"delay",
			duration = {
				10,
				15
			}
		},
		{
			"flow_event",
			flow_event_name = "portals_end_escape_yard_done"
		}
	},
	dlc_portals_grapes_challenge = {
		{
			"set_master_event_running",
			name = "dlc_portals_grapes_challenge"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"spawn_at_raw",
			spawner_id = "portals_grapes_challenge_01",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "portals_grapes_challenge_02",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "portals_grapes_challenge_03",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "portals_grapes_challenge_04",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_12_0)
				-- function 12
				return count_event_breed("chaos_vortex_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_grapes_challenge_done"
		},
		{
			"control_pacing",
			enable = true
		}
	},
	dlc_portals_portal_challenge_01 = {
		{
			"set_master_event_running",
			name = "dlc_portals_portal_challenge_01"
		},
		{
			"disable_kick"
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
			"spawn_special",
			amount = 2,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "portals_portal_challenge_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			amount = 3,
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			spawner_id = "portals_portal_challenge_01",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			spawner_id = "portals_portal_challenge_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			condition = function (arg_13_0)
				-- function 13
				return not (count_event_breed("skaven_clan_rat") < 1) or not (count_event_breed("skaven_slave") < 1) or not (count_event_breed("skaven_pack_master") < 1) or count_event_breed("skaven_poison_wind_globadier") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_portal_challenge_01_done"
		},
		{
			"control_pacing",
			enable = true
		}
	},
	dlc_portals_portal_challenge_02_horde = {
		{
			"set_master_event_running",
			name = "dlc_portals_portal_challenge_02_horde"
		},
		{
			"disable_kick"
		},
		{
			"event_horde",
			spawner_id = "portals_portal_challenge_02_horde",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_14_0)
				-- function 14
				return count_event_breed("skaven_rat_ogre") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_portal_challenge_02_horde_done"
		}
	},
	dlc_portals_portal_challenge_02 = {
		{
			"set_master_event_running",
			name = "dlc_portals_portal_challenge_02"
		},
		{
			"disable_kick"
		},
		{
			"spawn_at_raw",
			spawner_id = "portals_portal_challenge_02",
			breed_name = "skaven_rat_ogre"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_15_0)
				-- function 15
				return count_event_breed("skaven_rat_ogre") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_portal_challenge_02_done"
		}
	},
	dlc_portals_a = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_a"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_a",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_a",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_16_0)
				-- function 16
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 8
			end
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
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			condition = function (arg_17_0)
				-- function 17
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_a",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			condition = function (arg_18_0)
				-- function 18
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_a",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			condition = function (arg_19_0)
				-- function 19
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_a",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			condition = function (arg_20_0)
				-- function 20
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_a",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "portals_terror_event_a_complete"
		}
	},
	dlc_portals_b = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_b"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_21_0)
				-- function 21
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 8
			end
		},
		{
			"delay",
			duration = 10
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
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"flow_event",
			flow_event_name = "event_portal_b_spawn_ogre"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			condition = function (arg_22_0)
				-- function 22
				return count_event_breed("skaven_rat_ogre") < 1
			end
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_23_0)
				-- function 23
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_24_0)
				-- function 24
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_25_0)
				-- function 25
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_26_0)
				-- function 26
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_27_0)
				-- function 27
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_28_0)
				-- function 28
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_29_0)
				-- function 29
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_30_0)
				-- function 30
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_31_0)
				-- function 31
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_32_0)
				-- function 32
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_33_0)
				-- function 33
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_34_0)
				-- function 34
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_35_0)
				-- function 35
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_b",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_36_0)
				-- function 36
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"flow_event",
			flow_event_name = "portals_terror_event_b_complete"
		}
	},
	dlc_portals_c = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_c"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_37_0)
				-- function 37
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 2
			end
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
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "event_portal_c_spawn_ogre"
		},
		{
			"continue_when",
			condition = function (arg_38_0)
				-- function 38
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
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
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_39_0)
				-- function 39
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
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
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_40_0)
				-- function 40
				return count_event_breed("skaven_rat_ogre") < 1
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_41_0)
				-- function 41
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_42_0)
				-- function 42
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when",
			condition = function (arg_43_0)
				-- function 43
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_44_0)
				-- function 44
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_45_0)
				-- function 45
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_46_0)
				-- function 46
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			condition = function (arg_47_0)
				-- function 47
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_48_0)
				-- function 48
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_49_0)
				-- function 49
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_50_0)
				-- function 50
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_51_0)
				-- function 51
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_52_0)
				-- function 52
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_53_0)
				-- function 53
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_54_0)
				-- function 54
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_55_0)
				-- function 55
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_56_0)
				-- function 56
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_57_0)
				-- function 57
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_58_0)
				-- function 58
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_59_0)
				-- function 59
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_60_0)
				-- function 60
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_61_0)
				-- function 61
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_62_0)
				-- function 62
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_63_0)
				-- function 63
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_64_0)
				-- function 64
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_65_0)
				-- function 65
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_66_0)
				-- function 66
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_67_0)
				-- function 67
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_68_0)
				-- function 68
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_69_0)
				-- function 69
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_1",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_70_0)
				-- function 70
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "spawner_portal_c_2",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_71_0)
				-- function 71
				return not (count_event_breed("skaven_clan_rat") < 6) or not (count_event_breed("skaven_storm_vermin_commander") < 2) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "portals_terror_event_c_complete"
		}
	},
	dlc_portals_guards_cliff = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_1",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dlc_portals_guards_portal_a = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_8",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dlc_portals_guards_camp_a = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_7",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dlc_portals_guards_portal_b = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_2",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dlc_portals_guards_camp_b = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_4",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_6",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dlc_portals_guards_portal_c = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_stormvermin_guard_5",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dlc_portals_b_ogre = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_portal_b",
			breed_name = "skaven_rat_ogre"
		}
	},
	dlc_portals_c_ogre = {
		{
			"spawn_at_raw",
			spawner_id = "spawner_manual_event_portal_c_2",
			breed_name = "skaven_rat_ogre"
		}
	}
}

return {
	tbl_2,
	tbl
}
