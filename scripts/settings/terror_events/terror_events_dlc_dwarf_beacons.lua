-- chunkname: @scripts/settings/terror_events/terror_events_dlc_dwarf_beacons.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local HARD = scripts_settings_terror_events_terror_event_utils.HARD
local HARDER = scripts_settings_terror_events_terror_event_utils.HARDER
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local tbl = {
	dwarf_disable_pacing = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		}
	},
	dwarf_enable_pacing = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	},
	dwarf_beacons_gate_part1 = {
		{
			"set_master_event_running",
			name = "beacons_gate"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
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
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_2_0)
				-- function 2
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
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
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_4_0)
				-- function 4
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_5_0)
				-- function 5
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_otherside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_6_0)
				-- function 6
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_7_0)
				-- function 7
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_otherside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_8_0)
				-- function 8
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_otherside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_9_0)
				-- function 9
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		}
	},
	dwarf_beacons_gate_part2 = {
		{
			"set_master_event_running",
			name = "beacons_gate"
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
			spawner_id = "gate_otherside",
			composition_type = "event_large"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_10_0)
				-- function 10
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_otherside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_11_0)
				-- function 11
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_12_0)
				-- function 12
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_13_0)
				-- function 13
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"control_pacing",
			enable = true
		}
	},
	dwarf_beacons_gate_part3 = {
		{
			"set_master_event_running",
			name = "beacons_gate"
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
			spawner_id = "gate_otherside",
			composition_type = "event_large"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_14_0)
				-- function 14
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_otherside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_15_0)
				-- function 15
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_16_0)
				-- function 16
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "gate_currentside",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_17_0)
				-- function 17
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"control_pacing",
			enable = true
		}
	},
	dwarf_beacons_beacon = {
		{
			"set_master_event_running",
			name = "beacons_beacon"
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
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_18_0)
				-- function 18
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				1,
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_19_0)
				-- function 19
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"spawn",
			{
				1
			},
			breed_name = "skaven_ratling_gunner"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_20_0)
				-- function 20
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_21_0)
				-- function 21
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_22_0)
				-- function 22
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_23_0)
				-- function 23
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"spawn",
			{
				1,
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_24_0)
				-- function 24
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_25_0)
				-- function 25
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_26_0)
				-- function 26
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_27_0)
				-- function 27
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_28_0)
				-- function 28
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_29_0)
				-- function 29
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_30_0)
				-- function 30
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_31_0)
				-- function 31
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_32_0)
				-- function 32
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_33_0)
				-- function 33
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		}
	},
	dwarf_beacons_skaven_horde = {
		{
			"set_master_event_running",
			name = "beacons_skaven_horde"
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
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARD
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "beacon",
			composition_type = "event_extra_spice_medium",
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 8,
			difficulty_requirement = HARDEST
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_34_0)
				-- function 34
				return not (count_event_breed("skaven_slave") < 10) or count_event_breed("skaven_clan_rat") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "beacon",
			composition_type = "event_extra_spice_medium",
			difficulty_requirement = HARDER
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARD
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 8,
			difficulty_requirement = HARDER
		},
		{
			"continue_when",
			duration = 120,
			condition = function (arg_35_0)
				-- function 35
				return not (count_event_breed("skaven_slave") < 10) or count_event_breed("skaven_clan_rat") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "beacon",
			composition_type = "plague_monks_small",
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10,
			difficulty_requirement = HARDEST
		},
		{
			"flow_event",
			flow_event_name = "beacons_skaven_horde_done"
		}
	},
	dwarf_beacons_barrier = {
		{
			"set_master_event_running",
			name = "beacons_barrier"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "beacon_barrier",
			composition_type = "event_small"
		}
	},
	dwarf_beacons_horde_fleeing = {
		{
			"set_master_event_running",
			name = "beacon_horde_fleeing"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "beacon_horde_fleeing",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_36_0)
				-- function 36
				return not (count_event_breed("skaven_clan_rat") < 5) or count_event_breed("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "beacon_horde_small_done"
		}
	}
}

return {
	tbl
}
