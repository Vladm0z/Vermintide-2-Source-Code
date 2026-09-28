-- chunkname: @scripts/settings/terror_events/terror_events_dlc_dwarf_beacons.lua

local TerrorEventUtils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = TerrorEventUtils.count_event_breed
local HARD = TerrorEventUtils.HARD
local HARDER = TerrorEventUtils.HARDER
local HARDEST = TerrorEventUtils.HARDEST
local terror_event_blueprints = {
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
			condition = function (t)
				-- function 1
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 2
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 3
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 4
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 5
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 6
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 7
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 8
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 9
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 10
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 11
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 12
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 13
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 14
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 15
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 16
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 17
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 18
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 19
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 20
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 21
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 22
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 23
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 24
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 25
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 26
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 27
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 28
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 29
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 30
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 31
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 32
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 33
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
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
			condition = function (t)
				-- function 34
				return count_event_breed("skaven_slave") < 10 and count_event_breed("skaven_clan_rat") < 10
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
			condition = function (t)
				-- function 35
				return count_event_breed("skaven_slave") < 10 and count_event_breed("skaven_clan_rat") < 10
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
			condition = function (t)
				-- function 36
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "beacon_horde_small_done"
		}
	}
}

return {
	terror_event_blueprints
}
