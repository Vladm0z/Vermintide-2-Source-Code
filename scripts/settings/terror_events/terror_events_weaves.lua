-- chunkname: @scripts/settings/terror_events/terror_events_weaves.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.num_spawned_enemies
local var_0_3 = var_0_0.num_spawned_enemies_during_event
local var_0_4 = var_0_0.HARD
local var_0_5 = var_0_0.HARDER
local var_0_6 = var_0_0.HARDEST
local var_0_7 = var_0_0.CATACLYSM
local var_0_8 = var_0_0.CATACLYSM2
local var_0_9 = var_0_0.CATACLYSM3
local var_0_10 = {
	skaven = {
		stinger_sound_event = "enemy_horde_stinger",
		music_states = {
			horde = "horde"
		}
	},
	chaos = {
		stinger_sound_event = "enemy_horde_chaos_stinger",
		music_states = {
			pre_ambush = "pre_ambush_chaos",
			horde = "horde_chaos"
		}
	},
	beastmen = {
		stinger_sound_event = "enemy_horde_beastmen_stinger",
		music_states = {
			pre_ambush = "pre_ambush_beastmen",
			horde = "horde_beastmen"
		}
	}
}
local var_0_11 = {
	boss_01 = {
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_life_boss_event_1"
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_chaos_large"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_1_0)
				return var_0_2() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_2_0)
				return var_0_2() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_spice_elite_skaven"
		},
		{
			"continue_when",
			condition = function (arg_3_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	boss_04 = {
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_boss_event_1"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_4_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	boss_05 = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_5_0)
				return var_0_2() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_spice_berzerker_skaven"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_stormfiend"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_6_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	boss_06 = {
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_boss_event_2"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_7_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	metal_bosses = {
		{
			"set_master_event_running",
			name = "metal_bosses"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_trickle_chaos_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_8_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_trickle_chaos_berzerkers"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_9_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_stormfiend"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			condition = function (arg_10_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	metal_bosses_2 = {
		{
			"set_master_event_running",
			name = "metal_bosses_2"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_11_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_storm_vermin_shields_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_boss_skaven_armour"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_12_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_minotaur"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_13_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	metal_bosses_3 = {
		{
			"set_master_event_running",
			name = "metal_bosses_3"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_14_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_storm_vermin_shields_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_extra_spice_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_15_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_16_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	heaven_bosses = {
		{
			"set_master_event_running",
			name = "heaven_bosses"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"continue_when",
			condition = function (arg_17_0)
				return var_0_2() < 4
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"continue_when",
			condition = function (arg_18_0)
				return var_0_2() < 4
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_spawn"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"continue_when",
			condition = function (arg_19_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	fire_bosses = {
		{
			"set_master_event_running",
			name = "fire_bosses"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"continue_when",
			condition = function (arg_20_0)
				return var_0_2() < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_storm_skaven"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_stormfiend"
		},
		{
			"continue_when",
			condition = function (arg_21_0)
				return var_0_2() < 5
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_boss_skaven_armour"
		},
		{
			"continue_when",
			condition = function (arg_22_0)
				return var_0_2() < 5
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"continue_when",
			condition = function (arg_23_0)
				return var_0_2() < 5
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"continue_when",
			condition = function (arg_24_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	chaos_bosses = {
		{
			"set_master_event_running",
			name = "chaos_bosses"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_spice_elite_chaos"
		},
		{
			"continue_when",
			condition = function (arg_25_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_26_0)
				return var_0_2() < 1
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_spice_elite_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors_small"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_27_0)
				return var_0_3() < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_chaos"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_spice_elite_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_28_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	boss_blasters = {
		{
			"set_master_event_running",
			name = "boss_blasters"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_29_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"continue_when",
			condition = function (arg_30_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"continue_when",
			condition = function (arg_31_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_32_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_33_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_34_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_rat_ogre"
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_explosive_horde_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_35_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	chaos_swarm_event = {
		{
			"set_master_event_running",
			name = "chaos_swarm_event"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_36_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_37_0)
				return var_0_2() < 3
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_38_0)
				return var_0_2() < 4
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_39_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_40_0)
				return var_0_2() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_chaos"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_spawn"
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_41_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	skaven_swarm_event = {
		{
			"set_master_event_running",
			name = "skaven_swarm_event"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_42_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_spice_elite_skaven"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_pack_master"
		},
		{
			"continue_when",
			condition = function (arg_43_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_boss_skaven_armour"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_boss_skaven_armour"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"continue_when",
			condition = function (arg_44_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_trickle_skaven_armour"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_45_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_pack_master"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_spice_berzerker_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_trickle_skaven_armour"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_46_0)
				return var_0_3() < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_stormfiend"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_47_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	swarms_2_bosses_event = {
		{
			"set_master_event_running",
			name = "swarms_2_bosses_event"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_48_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_troll"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 45,
			condition = function (arg_49_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_rat_ogre"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_pack_master"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_shield"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_shield"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_50_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	swarms_2_chaos_bosses_event = {
		{
			"set_master_event_running",
			name = "swarms_2_chaos_bosses_event"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_chaos_large"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_chaos_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_51_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_troll"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_chaos_large"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_chaos_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 45,
			condition = function (arg_52_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_raiders_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "chaos_spawn"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_raiders_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_chaos_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_chaos_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_53_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	swarms_2_beastmen_bosses_event = {
		{
			"set_master_event_running",
			name = "swarms_2_beastmen_bosses_event"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_beastmen_large"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_beastmen_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_54_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_beastmen_large"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_beastmen_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_bestigor"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 45,
			condition = function (arg_55_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_bestigor"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_beastmen_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_beastmen_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_56_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	skaven_swarm_heavens_intro = {
		{
			"set_master_event_running",
			name = "skaven_swarm_heavens_intro"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_pack_master"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "manual1",
			difficulty_requirement = var_0_5
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "manual3",
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "manual2",
			difficulty_requirement = var_0_4
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "manual1",
			difficulty_requirement = var_0_8
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "manual3",
			difficulty_requirement = var_0_9
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_57_0)
				return var_0_2() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_rat_ogre"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 45,
			condition = function (arg_58_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_stormfiend"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "manual1",
			difficulty_requirement = var_0_6
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "manual3",
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "manual1",
			difficulty_requirement = var_0_8
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "manual3",
			difficulty_requirement = var_0_9
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_59_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	beastmen_bosses_heavens_outro = {
		{
			"set_master_event_running",
			name = "beastmen_bosses_heavens_outro"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_minotaur"
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "manual1",
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "manual1",
			difficulty_requirement = var_0_9
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large_beastmen",
			difficulty_requirement = var_0_8
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers",
			difficulty_requirement = var_0_5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers",
			difficulty_requirement = var_0_5
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_60_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	beastmen_bosses_bestigors = {
		{
			"set_master_event_running",
			name = "beastmen_bosses_heavens_outro"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_minotaur"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "manual1",
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "manual1",
			difficulty_requirement = var_0_9
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large_beastmen",
			difficulty_requirement = var_0_8
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers",
			difficulty_requirement = var_0_5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers",
			difficulty_requirement = var_0_5
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_61_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	beastmen_charge_event = {
		{
			"set_master_event_running",
			name = "beastmen_charge_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_62_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium_beastmen"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"continue_when",
			condition = function (arg_63_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_64_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_65_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_66_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_67_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_68_0)
				return var_0_3() < 4
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_69_0)
				return var_0_3() < 1
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_70_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	beastmen_charge_event_short = {
		{
			"set_master_event_running",
			name = "beastmen_charge_event_short"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_ungor_archers"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_71_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_beastmen"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"continue_when",
			condition = function (arg_72_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_bestigors_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_73_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_74_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_75_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_bestigors_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_76_0)
				return var_0_3() < 9
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_77_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	warriors_and_ratling_gunners = {
		{
			"set_master_event_running",
			name = "warriors_and_ratling_gunners"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_78_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"continue_when",
			condition = function (arg_79_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_80_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_81_0)
				return var_0_3() < 2
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_82_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_83_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	eshin_swarm = {
		{
			"set_master_event_running",
			name = "eshin_swarm"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			condition = function (arg_84_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "skaven_gutter_runner"
		},
		{
			"continue_when",
			condition = function (arg_85_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium"
		},
		{
			"continue_when",
			condition = function (arg_86_0)
				return var_0_2() < 1
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_87_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium_shield"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_storm_vermin_shields_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_88_0)
				return var_0_2() < 1
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "skaven_stormfiend"
		},
		{
			"delay",
			duration = 7
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_medium_shield"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_89_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	buffed_beast_bosses = {
		{
			"set_master_event_running",
			name = "buffed_beast_bosses"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_horde_beastmen_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_90_0)
				return var_0_2() < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_horde_beastmen_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_ungor_archers"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual2",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual3",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual4",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "manual1",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (arg_91_0)
				return var_0_2() < 1
			end
		},
		{
			"complete_weave"
		}
	},
	objective_storm_vermin_small_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_storm_vermin_small"
		},
		{
			"continue_when",
			condition = function (arg_92_0)
				return var_0_2() < 1
			end
		}
	},
	objective_extra_spice_small_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "event_extra_spice_small"
		},
		{
			"continue_when",
			condition = function (arg_93_0)
				return var_0_2() < 1
			end
		}
	},
	objective_small_chaos_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"continue_when",
			condition = function (arg_94_0)
				return var_0_2() < 1
			end
		}
	},
	objective_chaos_berzerkers_small_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"continue_when",
			condition = function (arg_95_0)
				return var_0_2() < 1
			end
		}
	},
	objective_small_skaven_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_small"
		},
		{
			"continue_when",
			condition = function (arg_96_0)
				return var_0_2() < 1
			end
		}
	},
	objective_plague_monks_small_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_plague_monks_small"
		},
		{
			"continue_when",
			condition = function (arg_97_0)
				return var_0_2() < 1
			end
		}
	},
	objective_large_beastmen_event = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large_beastmen"
		},
		{
			"continue_when",
			condition = function (arg_98_0)
				return var_0_2() < 1
			end
		}
	},
	capture_point_1_event_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_99_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_100_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_101_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_102_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_1_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_1_event_small_no_chaos = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1_event_small_no_chaos"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_103_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_104_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_105_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_106_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_1_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_1_event_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_107_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_108_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_109_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_110_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_111_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_shields_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_112_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_113_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_1_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_1_event_medium_no_chaos = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1_event_medium_no_chaos"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_114_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_115_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_116_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_117_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_118_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_shields_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_119_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_120_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_1_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_1_event_large = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_121_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_122_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_123_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_124_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_125_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_shields_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_126_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_127_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_128_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_129_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_130_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_131_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_1_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_1_event_large_skaven = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1_event_large_skaven"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_132_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_133_0)
				return var_0_3() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_134_0)
				return var_0_3() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_135_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_event_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_136_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_storm_vermin_shields_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_137_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_138_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_139_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_140_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_003_skaven",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_141_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_1_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_2_event = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_2"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_142_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_143_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_144_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_145_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_146_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_chaos_shields"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_147_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_148_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_149_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_150_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_151_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_2",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_152_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_2_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_1_chaos = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_1_chaos"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_153_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_154_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_event_small_chaos"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_155_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_156_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_157_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_158_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_159_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_160_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_161_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_162_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_1_chaos",
			composition_type = "weave_chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_163_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_2_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_3_event = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_3"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_164_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_165_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_166_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_167_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_168_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_169_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_170_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_171_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_172_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_storm_vermin_shields_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_173_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_174_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_3_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_3_event_no_chaos = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_3_event_no_chaos"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_175_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_176_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_177_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_178_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_179_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_180_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_181_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_182_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_183_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_storm_vermin_shields_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_184_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_3",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_185_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_3_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_4_event = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_4"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_186_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_4",
			composition_type = "weave_horde_beastmen_small"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_187_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_4",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_188_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_4",
			composition_type = "weave_horde_beastmen_large"
		},
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_189_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_4",
			composition_type = "weave_horde_beastmen_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_190_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_4_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_6_boss_event_skaven = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_6_boss_event_skaven"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_191_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_6_skaven",
			breed_name = "skaven_stormfiend"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_6_skaven",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_192_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_6_skaven",
			composition_type = "weave_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_193_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_6_skaven",
			composition_type = "weave_event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_194_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_6_skaven",
			composition_type = "weave_event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_195_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_3_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	capture_point_specials_raid = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_specials_raid"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_196_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_specials_raid",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_specials_raid",
			composition_type = "weave_horde_skaven_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_197_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_specials_raid",
			breed_name = "skaven_gutter_runner"
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_specials_raid",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_specials_raid",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_198_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_specials_raid",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_specials_raid",
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_specials_raid",
			composition_type = "weave_horde_skaven_large"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_199_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_specials_raid",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_200_0)
				return var_0_3() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_3_done"
		}
	},
	objective_specials_raid = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "objective_specials_raid"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_201_0)
				return var_0_3() < 3
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
			"spawn_at_raw",
			spawner_id = "objective_specials_raid",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "objective_specials_raid",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "objective_specials_raid",
			composition_type = "weave_horde_skaven_small"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_202_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "objective_specials_raid",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "objective_specials_raid",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_203_0)
				return var_0_3() < 3
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "objective_specials_raid",
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_204_0)
				return var_0_3() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_3_done"
		}
	},
	capture_point_event_beastmen = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "capture_point_event_beastmen"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_205_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_horde_beastmen_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_event_beastmen",
			breed_name = "beastmen_minotaur"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_206_0)
				return var_0_3() < 5
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "capture_point_event_beastmen",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_horde_beastmen_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_207_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_horde_beastmen_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_208_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_209_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_horde_beastmen_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "capture_point_event_beastmen",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_210_0)
				return var_0_3() < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "capture_point_event_beastmen_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	objective_event_beastmen = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "objective_event_beastmen"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_211_0)
				return var_0_3() < 3
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "objective_event_beastmen",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "objective_event_beastmen",
			composition_type = "weave_horde_beastmen_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_212_0)
				return var_0_3() < 3
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "objective_event_beastmen",
			breed_name = "beastmen_standard_bearer"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "objective_event_beastmen",
			composition_type = "weave_horde_beastmen_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_213_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "objective_event_beastmen",
			composition_type = "weave_horde_beastmen_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_214_0)
				return var_0_3() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "objective_event_beastmen",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (arg_215_0)
				return var_0_3() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "objective_event_beastmen_done"
		},
		{
			"delay",
			duration = 10
		}
	},
	weave_spot_event_special_mixed = {
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_216_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_special_mixed_done"
		}
	},
	weave_spot_event_special_skaven = {
		{
			"spawn_weave_special_event",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_217_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_special_skaven_done"
		}
	},
	weave_spot_event_chaos_warriors = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "weave_spot_event_chaos_warriors",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "weave_spot_event_chaos_warriors",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_218_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_chaos_warriors_done"
		},
		{
			"delay",
			duration = 3
		}
	},
	weave_spot_event_skaven_specials_small = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_skaven_specials_small",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_skaven_specials_small",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_219_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_skaven_specials_small_done"
		},
		{
			"delay",
			duration = 3
		}
	},
	weave_spot_event_skaven_specials_medium = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_skaven_specials_medium",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_skaven_specials_medium",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_220_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_skaven_specials_small_done"
		},
		{
			"delay",
			duration = 3
		}
	},
	weave_spot_event_beastmen_splice = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "weave_spot_event_beastmen_splice",
			composition_type = "weave_spice_elite_beastmen"
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_221_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_beastmen_splice_done"
		},
		{
			"delay",
			duration = 3
		}
	},
	weave_spot_event_boss_rat_ogre = {
		{
			"delay",
			duration = 10.25
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_rat_ogre_spawn",
			breed_name = {
				"skaven_rat_ogre"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_222_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_rat_ogre_dead"
		}
	},
	weave_spot_event_boss_stormfiend = {
		{
			"delay",
			duration = 10.25
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_stormfiend_spawn",
			breed_name = {
				"skaven_stormfiend"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_223_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_stormfiend_dead"
		}
	},
	weave_spot_event_boss_chaos_spawn = {
		{
			"delay",
			duration = 10.25
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_chaos_spawn_spawn",
			breed_name = {
				"chaos_spawn"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_224_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_chaos_spawn_dead"
		}
	},
	weave_spot_event_boss_minotaur = {
		{
			"delay",
			duration = 10.25
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_minotaur_spawn",
			breed_name = {
				"beastmen_minotaur"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_225_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_minotaur_dead"
		}
	},
	weave_spot_event_skaven_gutter_runner = {
		{
			"delay",
			duration = 10.25
		},
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_skaven_gutter_runner_spawn",
			breed_name = {
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_226_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_skaven_gutter_runner_dead"
		}
	},
	weave_spot_event_boss_chaos_troll = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_chaos_troll_spawn",
			breed_name = {
				"chaos_troll"
			}
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_227_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_chaos_troll_dead"
		}
	},
	weave_spot_event_boss_rat_ogre_nodelay = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_rat_ogre_nodelay",
			breed_name = {
				"skaven_rat_ogre"
			}
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_228_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_rat_ogre_nodelay_dead"
		}
	},
	weave_spot_event_boss_minotaur_nodelay = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_minotaur_nodelay",
			breed_name = {
				"beastmen_minotaur"
			}
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_229_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_minotaur_nodelay_dead"
		}
	},
	weave_spot_event_boss_stormfiend_nodelay = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_stormfiend_nodelay",
			breed_name = {
				"skaven_stormfiend"
			}
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_230_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_stormfiend_nodelay_dead"
		}
	},
	weave_spot_event_boss_chaos_spawn_nodelay = {
		{
			"spawn_at_raw",
			spawner_id = "weave_spot_event_boss_chaos_spawn_nodelay",
			breed_name = {
				"chaos_spawn"
			}
		},
		{
			"continue_when",
			duration = 90,
			condition = function (arg_231_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "weave_spot_event_boss_chaos_spawn_nodelay_dead"
		}
	},
	skaven_main_path_event_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_small",
			sound_settings = var_0_10.skaven
		}
	},
	mixed_main_path_event_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		}
	},
	mixed_main_path_event_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		}
	},
	mixed_main_path_event_03 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner"
			}
		}
	},
	mixed_main_path_event_04 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower"
			}
		}
	},
	mixed_main_path_event_05 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		}
	},
	skaven_main_path_event_horde_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_small",
			sound_settings = var_0_10.skaven
		}
	},
	skaven_main_path_event_horde_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_medium",
			sound_settings = var_0_10.skaven
		}
	},
	skaven_main_path_event_horde_large = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_large",
			sound_settings = var_0_10.skaven
		}
	},
	chaos_main_path_event_horde_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_horde_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_medium",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_horde_large = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_large",
			sound_settings = var_0_10.chaos
		}
	},
	beastmen_skaven_main_path_event_horde_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_beastmen_skaven_small",
			sound_settings = var_0_10.chaos
		}
	},
	beastmen_main_path_event_horde_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_beastmen_small",
			sound_settings = var_0_10.chaos
		}
	},
	beastmen_main_path_event_horde_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_beastmen_medium",
			sound_settings = var_0_10.chaos
		}
	},
	beastmen_main_path_event_horde_large = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_beastmen_large",
			sound_settings = var_0_10.chaos
		}
	},
	skaven_main_path_event_elite_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_skaven",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_elite_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	beastmen_main_path_event_elite_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_beastmen",
			sound_settings = var_0_10.chaos
		}
	},
	skaven_main_path_event_horde_elite_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_skaven",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_horde_elite_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	beastmen_main_path_event_horde_elite_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_beastmen_small",
			sound_settings = var_0_10.chaos
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_beastmen",
			sound_settings = var_0_10.chaos
		}
	},
	skaven_main_path_event_berzerker_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_berzerker_skaven",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_berzerker_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_berzerker_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	skaven_main_path_event_horde_berzerker_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_berzerker_skaven",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_horde_berzerker_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_chaos_small",
			sound_settings = var_0_10.skaven
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_berzerker_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	chaos_main_path_event_armored_skaven = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"ambush_horde",
			composition_type = "weave_boss_skaven_armour",
			sound_settings = var_0_10.skaven
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_skaven",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_event_special_small = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_special_small_beasts = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_special_medium = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_special_large = {
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_special_chaos_disruptors = {
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_special_standard_bearer = {
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_special_chaos = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_standard_skaven_small_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_small_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_small_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_small_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_232_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_small_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_small_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_233_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_234_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_medium_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_medium_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_medium_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_medium_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_235_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_medium_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_medium_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_236_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_smaller",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_237_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_large_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_large_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_large_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_large_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_238_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_skaven_large_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_skaven_large_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_239_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_240_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_chaos_small_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_small_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_small_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_small_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_241_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_small_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_small_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_242_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_243_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_medium_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_medium_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_medium_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_medium_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_244_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_medium_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_medium_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_245_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_246_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_large_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_large_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_large_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_large_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_247_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_chaos_large_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_chaos_large_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_248_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_249_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_beastmen_small_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_small_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_small_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_small_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_250_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_small_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_small_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_251_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_252_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_medium_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_medium_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_medium_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_medium_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_253_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_medium_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_medium_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_254_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_255_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_large_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_large_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_large_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_large_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_256_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_beastmen_large_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_beastmen_large_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_257_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_258_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_mixed_small_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_mixed_small_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_259_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_260_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_standard_mixed_medium_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_mixed_medium_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small",
			sound_settings = var_0_10.skaven
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_261_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_standard_mixed_medium_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_mixed_medium_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_262_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_263_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_mixed_large_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_mixed_large_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium_beastmen",
			sound_settings = var_0_10.beastmen
		},
		{
			"ambush_horde",
			composition_type = "weave_event_small_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_264_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_standard_mixed_large_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_standard_mixed_large_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (arg_265_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (arg_266_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_large_beastmen",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_theme_berzerkers_skaven_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_berzerkers_skaven_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_plague_monks_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_berzerkers_skaven_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_berzerkers_skaven_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_plague_monks_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_267_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_plague_monks_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_berzerkers_skaven_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_berzerkers_skaven_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_plague_monks_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_268_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_plague_monks_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_269_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_plague_monks_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_shields_skaven_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_shields_skaven_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_shields_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_shields_skaven_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_shields_skaven_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_shields_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_270_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_shields_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_shields_skaven_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_shields_skaven_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_shields_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_271_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_shields_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_272_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_shields_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_armored_skaven_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_skaven_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_armored_skaven_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_skaven_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_273_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_small",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_armored_skaven_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_skaven_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_274_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_275_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_storm_vermin_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_theme_vanilla_chaos_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_vanilla_chaos_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_raiders_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_vanilla_chaos_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_vanilla_chaos_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_raiders_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_276_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_raiders_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_vanilla_chaos_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_vanilla_chaos_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_raiders_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_277_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_raiders_medium",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_278_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_raiders_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_berzerkers_chaos_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_berzerkers_chaos_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_berzerkers_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_berzerkers_chaos_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_berzerkers_chaos_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_berzerkers_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_279_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_berzerkers_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_berzerkers_chaos_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_berzerkers_chaos_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_berzerkers_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_280_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_berzerkers_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_281_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_berzerkers_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_shields_chaos_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_shields_chaos_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_shields",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_shields_chaos_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_shields_chaos_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_shields",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 35,
			condition = function (arg_282_0)
				return var_0_3() < 2
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_shields",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_shields_chaos_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_shields_chaos_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_shields",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 35,
			condition = function (arg_283_0)
				return var_0_3() < 2
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_shields",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 35,
			condition = function (arg_284_0)
				return var_0_3() < 2
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_shields",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_armored_chaos_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_chaos_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_armored_chaos_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_chaos_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_285_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors_small",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_armored_chaos_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_chaos_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_286_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 25,
			condition = function (arg_287_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors",
			sound_settings = var_0_10.chaos
		}
	},
	main_path_theme_armored_beastmen_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_beastmen_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_bestigors",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_theme_armored_beastmen_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_beastmen_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_bestigors_small",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_288_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_bestigors",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_theme_armored_beastmen_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_armored_beastmen_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_bestigors_small",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_289_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_bestigors",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_290_0)
				return var_0_3() < 1
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_bestigors",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_theme_archers_beastmen_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_archers_beastmen_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_ungor_archers",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_theme_archers_beastmen_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_archers_beastmen_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_ungor_archers",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_291_0)
				return var_0_3() < 2
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_ungor_archers",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_theme_archers_beastmen_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_theme_archers_beastmen_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_ungor_archers",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (arg_292_0)
				return var_0_3() < 2
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_ungor_archers",
			sound_settings = var_0_10.beastmen
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_293_0)
				return var_0_3() < 2
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_ungor_archers",
			sound_settings = var_0_10.beastmen
		}
	},
	main_path_specials_aoe_skaven_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_aoe_skaven_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_aoe_skaven_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_6
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_4
		}
	},
	main_path_specials_disablers_skaven_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_pure_skaven_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_skaven_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_disablers_pure_skaven_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_disablers_skaven_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_pure_skaven_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_ranged_skaven_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_ranged_skaven_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_ranged_skaven_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_aoe_chaos_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_aoe_chaos_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_aoe_pure_chaos_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_aoe_chaos_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_aoe_pure_chaos_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_5
		}
	},
	main_path_specials_disablers_chaos_short = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_chaos_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_disablers_chaos_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_pure_chaos_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		}
	},
	main_path_specials_buff_beastmen_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_buff_beastmen_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_9
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_buff_beastmen_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_9
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_9
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_standard_bearer"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_aoe_mixed_short = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_aoe_mixed_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_aoe_mixed_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_6
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_mixed_short = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_mixed_medium = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		}
	},
	main_path_specials_disablers_mixed_long = {
		{
			"delay",
			duration = 5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_4
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_6
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_5
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_specials_disablers_mixed_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_disablers_skaven_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_aoe_mixed_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_aoe_skaven_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_poison_wind_globadier"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_ranged_skaven_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 2,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_random_mixed_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_specials_chaos_short_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_7
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_8
		},
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_requirement = var_0_9
		}
	},
	main_path_event_boss_beastmen_minotaur_cata = {
		{
			"spawn_weave_special",
			amount = 1,
			breed_name = {
				"beastmen_minotaur"
			},
			difficulty_requirement = var_0_7
		}
	},
	main_path_event_boss_stormfiend = {
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"skaven_stormfiend"
			}
		}
	},
	main_path_event_boss_chaos_spawn = {
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"chaos_spawn"
			}
		}
	},
	main_path_event_boss_chaos_troll = {
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"chaos_troll"
			}
		}
	},
	main_path_event_boss_skaven_rat_ogre = {
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"skaven_rat_ogre"
			}
		}
	},
	main_path_event_boss_beastmen_minotaur = {
		{
			"spawn_weave_special",
			1,
			breed_name = {
				"beastmen_minotaur"
			}
		}
	},
	main_path_horde_skaven_short = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_horde_skaven_short"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_horde_skaven_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_horde_skaven_medium"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_294_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	main_path_horde_skaven_long = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "main_path_horde_skaven_long"
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_295_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (arg_296_0)
				return var_0_3() < 3
			end
		},
		{
			"ambush_horde",
			composition_type = "weave_event_medium",
			sound_settings = var_0_10.skaven
		}
	},
	trickle_event_skaven_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 40
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"start_event",
			start_event_name = "trickle_event_skaven_small"
		}
	},
	trickle_event_skaven_medium = {},
	trickle_event_skaven_large = {},
	trickle_event_chaos_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 40
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_chaos_small"
		}
	},
	trickle_event_chaos_medium = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 40
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_medium",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_chaos_medium"
		}
	},
	trickle_event_chaos_large = {},
	trickle_event_beastmen_small = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 40
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_beastmen_small",
			sound_settings = var_0_10.beastmen
		},
		{
			"start_event",
			start_event_name = "trickle_event_beastmen_small"
		}
	},
	trickle_event_beastmen_medium = {},
	trickle_event_beastmen_large = {},
	trickle_event_mixed_small = {},
	trickle_event_mixed_medium = {},
	trickle_event_mixed_large = {},
	trickle_event_mixed_small_slow = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_armour",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_berzerkers",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_mixed_small_slow"
		}
	},
	trickle_event_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_armour",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_berzerkers",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_01"
		}
	},
	trickle_event_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_armour",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_beastmen_small",
			sound_settings = var_0_10.beastmen
		},
		{
			"start_event",
			start_event_name = "trickle_event_02"
		}
	},
	trickle_event_03 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_berzerker_skaven",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_horde_skaven_large",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_beastmen_small",
			sound_settings = var_0_10.beastmen
		},
		{
			"start_event",
			start_event_name = "trickle_event_03"
		}
	},
	trickle_event_04 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_skaven_small",
			sound_settings = var_0_10.skaven
		},
		{
			"start_event",
			start_event_name = "trickle_event_04"
		}
	},
	trickle_event_05 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_berzerkers",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_05"
		}
	},
	trickle_event_specials = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_small",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_berzerkers",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_specials"
		}
	},
	trickle_event_06 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 30
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_berzerkers",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_06"
		}
	},
	trickle_event_06_slow = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_spice_elite_chaos",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_trickle_chaos_berzerkers",
			sound_settings = var_0_10.chaos
		},
		{
			"start_event",
			start_event_name = "trickle_event_06_slow"
		}
	},
	trickle_event_armour = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 90
		},
		{
			"ambush_horde",
			composition_type = "weave_chaos_warriors",
			sound_settings = var_0_10.chaos
		},
		{
			"delay",
			duration = 90
		},
		{
			"ambush_horde",
			composition_type = "weave_boss_skaven_armour",
			sound_settings = var_0_10.skaven
		},
		{
			"start_event",
			start_event_name = "trickle_event_armour"
		}
	},
	trickle_event_explosive_rats = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 60
		},
		{
			"ambush_horde",
			composition_type = "weave_explosive_horde_medium",
			sound_settings = var_0_10.skaven
		},
		{
			"start_event",
			start_event_name = "trickle_event_explosive_rats"
		}
	},
	void_arena_event_dual_spawn = {
		{
			"set_master_event_running",
			name = "void_arena_boss"
		},
		{
			"spawn",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend",
				"chaos_troll",
				"chaos_spawn"
			}
		},
		{
			"spawn",
			breed_name = {
				"skaven_rat_ogre",
				"skaven_stormfiend",
				"chaos_troll",
				"chaos_spawn"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (arg_297_0)
				return var_0_1("skaven_rat_ogre") < 1 and var_0_1("skaven_stormfiend") < 1 and var_0_1("chaos_troll") < 1 and var_0_1("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "void_arena_boss_dead"
		}
	},
	arena_fight_1 = {
		{
			"set_master_event_running",
			name = "arena_fight_1"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_298_0)
				return var_0_2() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_299_0)
				return var_0_2() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_300_0)
				return var_0_2() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_301_0)
				return var_0_2() < 2
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_chaos_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_302_0)
				return var_0_2() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "arena_fight1",
			composition_type = "weave_event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_303_0)
				return var_0_2() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "arena_fight2",
			composition_type = "weave_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (arg_304_0)
				return var_0_2() < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_fight_1_done"
		},
		{
			"delay",
			duration = 10
		}
	}
}

return {
	var_0_11
}
