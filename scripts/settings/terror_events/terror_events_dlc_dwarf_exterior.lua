-- chunkname: @scripts/settings/terror_events/terror_events_dlc_dwarf_exterior.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local spawned_during_event = scripts_settings_terror_events_terror_event_utils.spawned_during_event
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local CATACLYSM = scripts_settings_terror_events_terror_event_utils.CATACLYSM
local tbl = {
	dwarf_exterior_disable_pacing = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		}
	},
	dwarf_exterior_enable_pacing = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
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
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_medium"
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
				-- function 1
				return spawned_during_event() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large"
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
				-- function 2
				return spawned_during_event() < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "storm_vermin_small",
			difficulty_requirement = CATACLYSM
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
			spawner_id = "courtyard_hidden",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_3_0)
				-- function 3
				return not (count_event_breed("skaven_plague_monk") < 2) or not (count_event_breed("skaven_poison_wind_globadier") < 1) or not (count_event_breed("chaos_corruptor_sorcerer") < 1) or count_event_breed("skaven_warpfire_thrower") < 1
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_large"
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
			duration = 100,
			condition = function (arg_4_0)
				-- function 4
				return spawned_during_event() < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_5_0)
				-- function 5
				return spawned_during_event() < 6
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
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_6_0)
				-- function 6
				return spawned_during_event() < 8
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
			condition = function (arg_7_0)
				-- function 7
				return spawned_during_event() < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "chaos_warriors",
			difficulty_requirement = CATACLYSM
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
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_8_0)
				-- function 8
				return not (count_event_breed("skaven_plague_monk") < 2) or not (count_event_breed("skaven_poison_wind_globadier") < 1) or not (count_event_breed("chaos_corruptor_sorcerer") < 1) or not (count_event_breed("chaos_vortex_sorcerer") < 1) or count_event_breed("skaven_warpfire_thrower") < 1
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_9_0)
				-- function 9
				return spawned_during_event() < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_large"
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
			duration = 100,
			condition = function (arg_10_0)
				-- function 10
				return spawned_during_event() < 6
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
		},
		{
			"control_specials",
			enable = true
		}
	},
	dwarf_exterior_courtyard_event_specials_01 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_11_0)
				-- function 11
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 3,
				normal = 1
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = HARDEST
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			amount = 1,
			difficulty_requirement = CATACLYSM
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_12_0)
				-- function 12
				return count_event_breed("skaven_poison_wind_globadier") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	},
	dwarf_exterior_courtyard_event_specials_02 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_13_0)
				-- function 13
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "chaos_vortex_sorcerer",
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
			breed_name = "chaos_corruptor_sorcerer",
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
			breed_name = {
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = HARDEST
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
				return not (count_event_breed("chaos_corruptor_sorcerer") < 1) or count_event_breed("chaos_vortex_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	},
	dwarf_exterior_courtyard_event_specials_03 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_15_0)
				-- function 15
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "chaos_vortex_sorcerer",
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 3,
				normal = 1
			}
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			amount = 1,
			difficulty_requirement = HARDEST
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			amount = 1,
			difficulty_requirement = CATACLYSM
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_16_0)
				-- function 16
				return count_event_breed("chaos_vortex_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	},
	dwarf_exterior_courtyard_event_specials_04 = {
		{
			"continue_when",
			duration = 100,
			condition = function (arg_17_0)
				-- function 17
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_warpfire_thrower",
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
			breed_name = "skaven_pack_master",
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_ratling_gunner"
			},
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_18_0)
				-- function 18
				return not (count_event_breed("skaven_warpfire_thrower") < 1) or count_event_breed("skaven_pack_master") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	},
	dwarf_exterior_courtyard_event_specials_05 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_19_0)
				-- function 19
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
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
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_20_0)
				-- function 20
				return not (count_event_breed("skaven_ratling_gunner") < 1) or count_event_breed("skaven_poison_wind_globadier") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
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
	dwarf_exterior_end_event_survival_globadiers = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_globadiers_done"
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
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "end_event_survival",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_21_0)
				-- function 21
				return not (count_event_breed("skaven_clan_rat") < 7) or not (count_event_breed("skaven_slave") < 8) or count_event_breed("skaven_storm_vermin_commander") < 2
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
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_medium"
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
				return not (count_event_breed("skaven_clan_rat") < 7) or not (count_event_breed("skaven_slave") < 8) or count_event_breed("skaven_storm_vermin_commander") < 2
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
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_medium"
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
				return not (count_event_breed("skaven_clan_rat") < 3) or not (count_event_breed("skaven_slave") < 3) or count_event_breed("skaven_storm_vermin_commander") < 1
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
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_24_0)
				-- function 24
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_slave") < 5
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
			composition_type = "event_medium"
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
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_slave") < 5
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
	dwarf_exterior_end_event_sound = {},
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
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
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
				return not (count_event_breed("skaven_clan_rat") < 4) or count_event_breed("skaven_slave") < 5
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
	tbl
}
