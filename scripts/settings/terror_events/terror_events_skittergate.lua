-- chunkname: @scripts/settings/terror_events/terror_events_skittergate.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.count_breed
local var_0_3 = {
	skittergate_pacing_off = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		}
	},
	skittergate_pacing_on = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	},
	skittergate_spawn_guards = {
		{
			"spawn_at_raw",
			spawner_id = "gate_guard_01",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "gate_guard_02",
			breed_name = "skaven_storm_vermin_commander"
		}
	},
	skittergate_chaos_boss = {
		{
			"set_master_event_running",
			name = "skittergate_chaos_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_chaos_boss",
			breed_name = "chaos_exalted_champion_norsca"
		},
		{
			"continue_when",
			condition = function(arg_1_0)
				return var_0_1("chaos_exalted_champion_norsca") == 1
			end
		},
		{
			"continue_when",
			condition = function(arg_2_0)
				return var_0_1("chaos_exalted_champion_norsca") < 1
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function(arg_3_0)
				return var_0_1("chaos_exalted_champion_norsca") < 1 and var_0_1("chaos_spawn_exalted_champion_norsca") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "skittergate_chaos_boss_killed"
		}
	},
	skittergate_gatekeeper_marauders = {
		{
			"spawn_at_raw",
			spawner_id = "skittergate_gatekeeper_marauder_01",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_gatekeeper_marauder_02",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_gatekeeper_marauder_03",
			breed_name = "chaos_marauder_with_shield"
		}
	},
	skittergate_terror_event_02 = {
		{
			"set_master_event_running",
			name = "skittergate_terror_event_02"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "terror_event_02",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "terror_event_02",
			composition_type = "event_medium"
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
			"continue_when",
			duration = 120,
			condition = function(arg_4_0)
				return var_0_1("skaven_clan_rat") < 5 and var_0_1("skaven_slave") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "skittergate_terror_event_02_done"
		}
	},
	skittergate_rasknitt_boss = {
		{
			"disable_kick"
		},
		{
			"set_master_event_running",
			name = "skittergate_rasknitt_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_rasknitt_boss",
			breed_name = "skaven_grey_seer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			condition = function(arg_5_0)
				return var_0_1("skaven_stormfiend_boss") == 1
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function(arg_6_0)
				return var_0_2("skaven_stormfiend_boss") < 1
			end
		},
		{
			"set_time_challenge",
			time_challenge_name = "skittergate_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "skittergate_speed_event_cata"
		},
		{
			"continue_when",
			condition = function(arg_7_0)
				return var_0_2("skaven_grey_seer") < 1
			end
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "skittergate_speed_event"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "skittergate_speed_event_cata"
		},
		{
			"flow_event",
			flow_event_name = "skittergate_rasknitt_boss_killed"
		}
	},
	skittergate_crumble_escape_01 = {
		{
			"set_master_event_running",
			name = "skittergate_crumble_escape_01"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "skittergate_crumble_escape_01",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "skittergate_crumble_escape_01_done"
		}
	}
}

return {
	var_0_3
}
