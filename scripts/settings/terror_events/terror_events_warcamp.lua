-- chunkname: @scripts/settings/terror_events/terror_events_warcamp.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local count_event_breed = scripts_settings_terror_events_terror_event_utils.count_event_breed
local HARDER = scripts_settings_terror_events_terror_event_utils.HARDER
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local tbl = {
	generic_disable_specials = GenericTerrorEvents.generic_disable_specials,
	generic_enable_specials = GenericTerrorEvents.generic_enable_specials,
	generic_disable_pacing = GenericTerrorEvents.generic_disable_pacing,
	generic_enable_pacing = GenericTerrorEvents.generic_enable_pacing,
	warcamp_payload = {
		{
			"set_master_event_running",
			name = "warcamp_payload"
		},
		{
			"control_pacing",
			enable = false
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
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "chaos_shields"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_1_0)
				-- function 1
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10,
			difficulty_requirement = HARDER
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			},
			difficulty_requirement = HARDEST
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = HARDER
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			},
			difficulty_requirement = HARDEST
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_2_0)
				-- function 2
				return not (count_event_breed("chaos_berzerker") < 2) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = HARDEST
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = HARDER
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			},
			difficulty_requirement = HARDEST
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_3_0)
				-- function 3
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_4_0)
				-- function 4
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "chaos_shields"
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_5_0)
				-- function 5
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_6_0)
				-- function 6
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "warcamp_payload"
		}
	},
	warcamp_chaos_boss = {
		{
			"set_master_event_running",
			name = "warcamp_chaos_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "warcamp_chaos_boss",
			breed_name = "chaos_exalted_champion_warcamp"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_7_0)
				-- function 7
				return count_event_breed("chaos_exalted_champion_warcamp") == 1
			end
		},
		{
			"continue_when",
			condition = function (arg_8_0)
				-- function 8
				return count_event_breed("chaos_exalted_champion_warcamp") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "warcamp_chaos_boss_dead"
		},
		{
			"control_pacing",
			enable = true
		}
	},
	warcamp_door_guard = {
		{
			"disable_kick"
		},
		{
			"spawn_at_raw",
			spawner_id = "wc_shield_dude_1",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "wc_shield_dude_2",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "wc_sword_dude_1",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "wc_sword_dude_2",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "wc_2h_dude_1",
			breed_name = "chaos_raider"
		}
	},
	warcamp_camp = {
		{
			"set_master_event_running",
			name = "warcamp_camp"
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
			limit_spawners = 2,
			spawner_id = "camp_event",
			composition_type = "warcamp_inside_camp"
		},
		{
			"delay",
			duration = 3,
			difficulty_requirement = HARDER
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "camp_event",
			composition_type = "event_chaos_extra_spice_small",
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_9_0)
				-- function 9
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or not (count_event_breed("chaos_marauder_with_shield") < 2) or count_event_breed("chaos_fanatic") < 4
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "camp_event",
			composition_type = "event_small_chaos"
		},
		{
			"flow_event",
			flow_event_name = "warcamp_camp_restart"
		}
	},
	warcamp_load_chaos_exalted_champion = {
		{
			"force_load_breed_package",
			breed_name = "chaos_exalted_champion_warcamp"
		}
	},
	warcamp_arena_chase = {
		{
			"set_master_event_running",
			name = "warcamp_chase"
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
			limit_spawners = 2,
			spawner_id = "arena_chase",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"control_specials",
			enable = false
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_10_0)
				-- function 10
				return not (count_event_breed("chaos_berzerker") < 3) or not (count_event_breed("chaos_raider") < 3) or not (count_event_breed("chaos_marauder") < 3) or count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "warcamp_chase_restart"
		}
	}
}

return {
	tbl
}
