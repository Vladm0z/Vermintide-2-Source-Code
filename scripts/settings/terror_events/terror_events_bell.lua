-- chunkname: @scripts/settings/terror_events/terror_events_bell.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.HARDER
local var_0_3 = var_0_0.HARDEST
local var_0_4 = var_0_0.CATACLYSM
local var_0_5 = {
	canyon_bell_event = {
		{
			"set_master_event_running",
			name = "canyon_bell_event"
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "canyon_bell_event_horde",
			composition_type = "event_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_medium",
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "canyon_bell_event_horde",
			composition_type = "event_small"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner"
			},
			difficulty_requirement = var_0_3
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "canyon_bell_event",
			composition_type = "plague_monks_small",
			difficulty_requirement = var_0_4
		},
		{
			"continue_when",
			duration = 100,
			condition = function (arg_1_0)
				return var_0_1("skaven_slave") < 5 and var_0_1("skaven_clan_rat") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "canyon_bell_event_done"
		}
	},
	canyon_ogre_boss = {
		{
			"spawn_at_raw",
			spawner_id = "canyon_ogre_boss",
			breed_name = "skaven_rat_ogre"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner"
			},
			difficulty_requirement = var_0_4
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_medium",
			difficulty_requirement = var_0_4
		}
	},
	canyon_escape_event = {
		{
			"set_master_event_running",
			name = "canyon_escape_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "canyon_escape_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_2_0)
				return var_0_1("skaven_slave") < 5 and var_0_1("skaven_clan_rat") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "canyon_escape_event_done"
		}
	},
	canyon_escape_event_start = {
		{
			"set_time_challenge",
			time_challenge_name = "bell_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "bell_speed_event_cata"
		}
	},
	canyon_escape_event_completion_check = {
		{
			"has_completed_time_challenge",
			time_challenge_name = "bell_speed_event"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "bell_speed_event_cata"
		}
	}
}

return {
	var_0_5
}
