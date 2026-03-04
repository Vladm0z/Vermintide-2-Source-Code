-- chunkname: @scripts/settings/terror_events/terror_events_ussingen.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.HARDER
local var_0_3 = var_0_0.HARDEST
local var_0_4 = var_0_0.CATACLYSM
local var_0_5 = {
	ussingen_payload_event_loop = {
		"ussingen_payload_event_loop_01",
		1,
		"ussingen_payload_event_loop_02",
		1,
		"ussingen_payload_event_loop_03",
		1,
		"ussingen_payload_event_loop_04",
		1
	}
}
local var_0_6 = {
	generic_disable_pacing = GenericTerrorEvents.generic_disable_pacing,
	ussingen_gate_guards = {
		{
			"spawn_at_raw",
			spawner_id = "gate_spawner_1",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			spawner_id = "gate_spawner_2",
			breed_name = "chaos_warrior"
		}
	},
	ussingen_gate_open_event = {
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
			spawner_id = "ussingen_gate_open",
			composition_type = "event_ussingen_gate_group"
		},
		{
			"delay",
			duration = 15
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	},
	ussingen_payload_event_01 = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "ussingen_payload_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_start",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 8,
			difficulty_requirement = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_small_chaos",
			difficulty_requirement = var_0_2
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_1_0)
				return var_0_1("chaos_fanatic") < 7 and var_0_1("chaos_raider") < 5 and var_0_1("chaos_marauder") < 8 and var_0_1("chaos_marauder_with_shield") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_01_done"
		}
	},
	ussingen_payload_event_loop_01 = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_small_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 6,
			difficulty_requirement = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_medium_chaos",
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_2_0)
				return var_0_1("chaos_fanatic") < 6 and var_0_1("chaos_raider") < 6 and var_0_1("chaos_marauder") < 6 and var_0_1("chaos_marauder_with_shield") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	},
	ussingen_payload_event_loop_02 = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = var_0_2
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_3_0)
				return var_0_1("chaos_fanatic") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			spawner_id = "ussingen_payload_square",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_4_0)
				return var_0_1("chaos_fanatic") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	},
	ussingen_payload_event_loop_03 = {
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = var_0_2
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_5_0)
				return var_0_1("chaos_fanatic") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	},
	ussingen_payload_event_loop_04 = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_pack_master",
				"skaven_ratling_gunner"
			},
			difficulty_requirement = var_0_2
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_6_0)
				return var_0_1("chaos_fanatic") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_7_0)
				return var_0_1("chaos_fanatic") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	},
	ussingen_payload_event_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "ussingen_payload_event"
		},
		{
			"event_horde",
			spawner_id = "ussingen_payload_square",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = var_0_2
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_8_0)
				return var_0_1("chaos_berzerker") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "ussingen_payload_square",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "ussingen_payload_square",
			composition_type = "chaos_warriors_small",
			difficulty_requirement = var_0_2
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_02_done"
		}
	},
	ussingen_payload_event_03 = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"event_horde",
			spawner_id = "ussingen_mansion_garden_payload",
			composition_type = "event_medium"
		}
	},
	ussingen_escape = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "ussingen_escape"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "ussingen_escape_event",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_9_0)
				return var_0_1("chaos_berzerker") < 3 and var_0_1("chaos_raider") < 3 and var_0_1("chaos_marauder") < 3 and var_0_1("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "ussingen_escape_restart"
		}
	}
}

return {
	var_0_6,
	var_0_5
}
