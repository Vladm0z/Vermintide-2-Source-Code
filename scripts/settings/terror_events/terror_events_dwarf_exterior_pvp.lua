-- chunkname: @scripts/settings/terror_events/terror_events_dwarf_exterior_pvp.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.spawned_during_event
local var_0_3 = {
	dwarf_exterior_disable_pacing = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		}
	},
	dwarf_exterior_enable_pacing = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	},
	dwarf_exterior_courtyard_event_start = {
		{
			"control_hordes",
			enable = false
		}
	},
	dwarf_exterior_courtyard_event_01 = {
		{
			"control_hordes",
			enable = false
		},
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_1_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_2_0)
				return var_0_2() < 10
			end
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
			spawner_id = "courtyard_hidden",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_3_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_done"
		}
	},
	dwarf_exterior_courtyard_event_02 = {
		{
			"control_hordes",
			enable = false
		},
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_4_0)
				return var_0_2() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_small"
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
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_5_0)
				return var_0_2() < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_6_0)
				return var_0_2() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_done"
		}
	},
	dwarf_exterior_courtyard_event_end = {
		{
			"control_pacing",
			enable = true
		}
	},
	dwarf_exterior_temple_guards = {
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
	dwarf_exterior_chamber_guards = {
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards01",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards02",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards03",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards04",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dwarf_exterior_escape_guards = {
		{
			"spawn_at_raw",
			spawner_id = "escape_guards01",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards02",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards03",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards04",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards05",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards06",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	dwarf_exterior_end_event_survival_01 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_survival",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "end_event_survival",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_7_0)
				return var_0_1("skaven_clan_rat") < 7 and var_0_1("skaven_slave") < 8 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_01_done"
		}
	},
	dwarf_exterior_end_event_survival_02 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_survival",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_8_0)
				return var_0_1("skaven_clan_rat") < 7 and var_0_1("skaven_slave") < 8 and var_0_1("skaven_storm_vermin_commander") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_02_done"
		}
	},
	dwarf_exterior_end_event_survival_end = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_survival",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_9_0)
				return var_0_1("skaven_clan_rat") < 3 and var_0_1("skaven_slave") < 3 and var_0_1("skaven_storm_vermin_commander") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_end_done"
		}
	},
	dwarf_exterior_end_event_survival_stop = {
		{
			"stop_event",
			stop_event_name = "dwarf_exterior_end_event_survival_01"
		},
		{
			"stop_event",
			stop_event_name = "dwarf_exterior_end_event_survival_02"
		},
		{
			"stop_event",
			stop_event_name = "dwarf_exterior_end_event_survival_end"
		}
	},
	dwarf_exterior_end_event_escape = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_escape"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_10_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_escape_done"
		}
	},
	dwarf_exterior_end_event_escape_02 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_escape"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_11_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_escape_02_done"
		}
	},
	dwarf_exterior_end_event_start = {
		{
			"control_pacing",
			enable = false
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		}
	},
	dwarf_exterior_end_event_invasion = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_invasion"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_12_0)
				return var_0_1("skaven_clan_rat") < 4 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_invasion_done"
		}
	},
	dwarf_water_boss = {
		{
			"spawn_at_raw",
			"skaven_stormfiend",
			"chaos_troll",
			"chaos_spawn",
			spawner_id = "lake_manual",
			breed_name = "skaven_rat_ogre"
		}
	},
	dwarf_exterior_end_event_guards = {
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_01",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_01b",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_02",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_02b",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_03",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_03b",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_04",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_04b",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_05",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_05b",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_06",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_06b",
			breed_name = "skaven_storm_vermin_commander"
		}
	}
}

return {
	var_0_3
}
