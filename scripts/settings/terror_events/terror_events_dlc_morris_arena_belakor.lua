-- chunkname: @scripts/settings/terror_events/terror_events_dlc_morris_arena_belakor.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.HARDEST
local var_0_2 = 8
local var_0_3 = 16
local var_0_4 = 2
local var_0_5 = 4
local var_0_6 = 4
local var_0_7 = 9
local var_0_8 = 9
local var_0_9 = 9
local var_0_10 = 4
local var_0_11 = 4
local var_0_12 = {
	default = 1,
	special = 1.2,
	elite = 1.2,
	boss = 2
}
local var_0_13 = "units/decals/deus_decal_aoe_cursedchest_01"
local var_0_14 = "fx/cursed_chest_spawn_01_portal"

local function var_0_15(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_0.decal_map or {}

	arg_1_0.decal_map = var_1_0

	local var_1_1 = Breeds[arg_1_3]
	local var_1_2

	if var_1_1.boss then
		var_1_2 = var_0_12.boss
	elseif var_1_1.special then
		var_1_2 = var_0_12.special
	elseif var_1_1.elite then
		var_1_2 = var_0_12.elite
	else
		var_1_2 = var_0_12.default
	end

	local var_1_3 = arg_1_2:unbox()
	local var_1_4
	local var_1_5
	local var_1_6 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_1_3)
	local var_1_7 = var_1_2

	Matrix4x4.set_scale(var_1_6, Vector3(var_1_7, var_1_7, var_1_7))

	local var_1_8, var_1_9 = Managers.state.unit_spawner:spawn_network_unit(var_0_13, "network_synched_dummy_unit", nil, var_1_6)
	local var_1_10 = var_0_14
	local var_1_11 = Vector3(0, 0, 0)
	local var_1_12 = Quaternion.identity()
	local var_1_13 = true
	local var_1_14 = 0

	Managers.state.event:trigger("event_play_particle_effect", var_1_10, var_1_8, var_1_14, var_1_11, var_1_12, var_1_13)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_play_particle_effect", NetworkLookup.effects[var_1_10], var_1_9, var_1_14, var_1_11, var_1_12, var_1_13)

	var_1_0[arg_1_2] = var_1_8
end

local function var_0_16(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.decal_map
	local var_2_1 = var_2_0 and var_2_0[arg_2_2]

	if var_2_1 then
		Managers.state.unit_spawner:mark_for_deletion(var_2_1)

		var_2_0[arg_2_2] = nil
	end
end

local var_0_17 = {
	arena_belakor_terror_phase_1 = {
		{
			"inject_event",
			event_name = "arena_belakor_terror_phase_1_start"
		},
		{
			"inject_event",
			event_name = "arena_belakor_terror_phase_1_sequence"
		}
	},
	arena_belakor_terror_phase_1_start = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_wwise_override_state",
			name = "terror_mb4"
		}
	},
	arena_belakor_terror_phase_1_sequence = {
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_phase_1_skaven",
				"arena_belakor_terror_phase_1_chaos"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_phase_1_beastmen",
				"arena_belakor_terror_phase_1_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_phase_1_chaos",
				"arena_belakor_terror_phase_1_beastmen"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_belakor_terror_phase_1_skaven = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_skaven_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_3_0)
				return arg_3_0.main < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_phase_1_done"
		}
	},
	arena_belakor_terror_phase_1_chaos = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_chaos_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_chaos",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_chaos",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_chaos",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_chaos",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_4_0)
				return arg_4_0.main < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_phase_1_done"
		}
	},
	arena_belakor_terror_phase_1_beastmen = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_beastmen_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_beastmen",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_beastmen",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_beastmen",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_small_beastmen",
			spawner_ids = {
				"terror_event_a",
				"terror_event_b"
			}
		},
		{
			"delay",
			duration = var_0_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_5_0)
				return arg_5_0.main < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_phase_1_done"
		}
	},
	arena_belakor_terror_end = {
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_6_0)
				return arg_6_0.boss <= 0 and arg_6_0.main <= 0 and arg_6_0.elite <= 0
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"set_wwise_override_state",
			name = "terror_mb4"
		}
	},
	arena_belakor_terror_specials = {
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_skaven_specials",
				"arena_belakor_terror_chaos_specials"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_skaven_specials",
				"arena_belakor_terror_beastmen_specials"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_chaos_specials",
				"arena_belakor_terror_beastmen_specials"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_belakor_terror_skaven_specials = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			spawner_id = "arena_belakor_specials",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_ratling_gunner"
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
			"spawn_at_raw",
			spawner_id = "arena_belakor_specials",
			spawn_counter_category = "special",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_ratling_gunner"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_1
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_7_0)
				return arg_7_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_specials_done"
		}
	},
	arena_belakor_terror_chaos_specials = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			spawner_id = "arena_belakor_specials",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
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
			"spawn_at_raw",
			spawner_id = "arena_belakor_specials",
			spawn_counter_category = "special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			},
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 2,
				cataclysm = 2,
				normal = 1
			},
			difficulty_requirement = var_0_1
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_8_0)
				return arg_8_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_specials_done"
		}
	},
	arena_belakor_terror_beastmen_specials = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"spawn_at_raw",
			spawn_counter_category = "special",
			breed_name = "beastmen_standard_bearer",
			spawner_id = "arena_belakor_specials",
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
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_9_0)
				return arg_9_0.special < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_specials_done"
		}
	},
	arena_belakor_terror_phase_2 = {
		{
			"inject_event",
			event_name = "arena_belakor_terror_phase_2_start"
		},
		{
			"inject_event",
			event_name = "arena_belakor_terror_phase_2_sequence"
		}
	},
	arena_belakor_terror_phase_2_start = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_wwise_override_state",
			name = "terror_mb4"
		}
	},
	arena_belakor_terror_phase_2_sequence = {
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_phase_2_skaven",
				"arena_belakor_terror_phase_2_chaos"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_phase_2_beastmen",
				"arena_belakor_terror_phase_2_skaven"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_terror_phase_2_chaos",
				"arena_belakor_terror_phase_2_beastmen"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_belakor_terror_phase_2_skaven = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_skaven_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_10_0)
				return arg_10_0.main < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_phase_2_done"
		}
	},
	arena_belakor_terror_phase_2_chaos = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_chaos_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_chaos",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_chaos",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_chaos",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_chaos",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_11_0)
				return arg_11_0.main < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_phase_2_done"
		}
	},
	arena_belakor_terror_phase_2_beastmen = {
		{
			"set_master_event_running",
			name = "arena_belakor_terror"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_beastmen_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_beastmen",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_beastmen",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_beastmen",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawn_counter_category = "main",
			composition_type = "event_medium_beastmen",
			spawner_ids = {
				"terror_event_c"
			}
		},
		{
			"delay",
			duration = var_0_3
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_12_0)
				return arg_12_0.main < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "arena_belakor_terror_phase_2_done"
		}
	},
	arena_belakor_around_statue_spawns = {
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_around_statue_spawns_faction_skaven",
				"arena_belakor_around_statue_spawns_faction_chaos",
				"arena_belakor_around_statue_spawns_faction_chaos"
			},
			faction_requirement_list = {
				"skaven",
				"chaos"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_around_statue_spawns_faction_skaven",
				"arena_belakor_around_statue_spawns_faction_beastmen",
				"arena_belakor_around_statue_spawns_faction_beastmen"
			},
			faction_requirement_list = {
				"skaven",
				"beastmen"
			}
		},
		{
			"inject_event",
			event_name_list = {
				"arena_belakor_around_statue_spawns_faction_chaos",
				"arena_belakor_around_statue_spawns_faction_beastmen"
			},
			faction_requirement_list = {
				"chaos",
				"beastmen"
			}
		}
	},
	arena_belakor_around_statue_spawns_faction_skaven = {
		{
			"one_of",
			{
				{
					"inject_event",
					weighted_event_names = {
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_vermin_shielded"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_stormvermin"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_plague_monks"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_skaven_warpfire_thrower"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_skaven_ratling_gunner"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_skaven_poison_wind_globadier"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_skaven_rat_ogre"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_skaven_stormfiend"
						}
					}
				}
			}
		}
	},
	arena_belakor_around_statue_spawns_stormvermin = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 7,
				hard = 5,
				harder = 6,
				cataclysm = 8,
				normal = 4
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_13_0)
				return arg_13_0.cursed_chest_enemies <= 4
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 7,
				hard = 5,
				harder = 6,
				cataclysm = 8,
				normal = 4
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_14_0)
				return arg_14_0.cursed_chest_enemies <= 4
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 7,
				hard = 5,
				harder = 6,
				cataclysm = 8,
				normal = 4
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_15_0)
				return arg_15_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_16_0)
				return arg_16_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_vermin_shielded = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 4,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 7,
				harder = 7,
				cataclysm = 8,
				normal = 6
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_17_0)
				return arg_17_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 4,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 7,
				harder = 7,
				cataclysm = 8,
				normal = 6
			},
			min_distance = var_0_7 - var_0_10 * 0.5,
			max_distance = var_0_7 + var_0_10 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_18_0)
				return arg_18_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_19_0)
				return arg_19_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_plague_monks = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_plague_monk",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 3,
				cataclysm = 5,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 10,
				hard = 7,
				harder = 9,
				cataclysm = 12,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_20_0)
				return arg_20_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_plague_monk",
			distance_to_players = 3,
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 3,
				cataclysm = 5,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 10,
				hard = 7,
				harder = 9,
				cataclysm = 12,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_21_0)
				return arg_21_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_plague_monk",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 3,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 10,
				hard = 7,
				harder = 9,
				cataclysm = 12,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_22_0)
				return arg_22_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_23_0)
				return arg_23_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_warpfire_thrower = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_24_0)
				return arg_24_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_25_0)
				return arg_25_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_26_0)
				return arg_26_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_27_0)
				return arg_27_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_28_0)
				return arg_28_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_29_0)
				return arg_29_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_30_0)
				return arg_30_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_ratling_gunner = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_ratling_gunner",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_31_0)
				return arg_31_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_32_0)
				return arg_32_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_ratling_gunner",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_33_0)
				return arg_33_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_34_0)
				return arg_34_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_ratling_gunner",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_35_0)
				return arg_35_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_36_0)
				return arg_36_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_37_0)
				return arg_37_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_poison_wind_globadier = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_poison_wind_globadier",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_38_0)
				return arg_38_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_39_0)
				return arg_39_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_poison_wind_globadier",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_40_0)
				return arg_40_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_41_0)
				return arg_41_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_poison_wind_globadier",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 2
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_42_0)
				return arg_42_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_43_0)
				return arg_43_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_44_0)
				return arg_44_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_rat_ogre = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_rat_ogre",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6,
			pre_spawn_func = var_0_0.add_enhancements_for_difficulty
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_45_0)
				return arg_45_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_46_0)
				return arg_46_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_stormfiend = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_stormfiend",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6,
			pre_spawn_func = var_0_0.add_enhancements_for_difficulty
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_clan_rat",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 16,
				hard = 12,
				harder = 14,
				cataclysm = 18,
				normal = 10
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_47_0)
				return arg_47_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_48_0)
				return arg_48_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_faction_chaos = {
		{
			"one_of",
			{
				{
					"inject_event",
					weighted_event_names = {
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_raider"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_berzerker"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_warrior"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_vortex_sorcerer"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_corruptor_sorcerer"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_troll"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_chaos_spawn"
						}
					}
				}
			}
		}
	},
	arena_belakor_around_statue_spawns_chaos_raider = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_raider",
			spawn_delay = 4,
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 4,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_delay = 4,
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 7,
				harder = 7,
				cataclysm = 8,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_49_0)
				return arg_49_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_raider",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 4,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 7,
				harder = 7,
				cataclysm = 8,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_50_0)
				return arg_50_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_raider",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 4,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 7,
				harder = 7,
				cataclysm = 8,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_51_0)
				return arg_51_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_52_0)
				return arg_52_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_berzerker = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_berzerker",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 7,
				hard = 5,
				harder = 6,
				cataclysm = 8,
				normal = 5
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_53_0)
				return arg_53_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_berzerker",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 7,
				hard = 5,
				harder = 6,
				cataclysm = 8,
				normal = 5
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_54_0)
				return arg_54_0.cursed_chest_enemies <= 5
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_berzerker",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 7,
				hard = 5,
				harder = 6,
				cataclysm = 8,
				normal = 5
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_55_0)
				return arg_55_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_56_0)
				return arg_56_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_warrior = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_warrior",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_57_0)
				return arg_57_0.cursed_chest_enemies <= 4
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_warrior",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 6,
				harder = 7,
				cataclysm = 10,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_58_0)
				return arg_58_0.cursed_chest_enemies <= 4
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_warrior",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 8,
				hard = 6,
				harder = 7,
				cataclysm = 10,
				normal = 6
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_59_0)
				return arg_59_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_60_0)
				return arg_60_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_vortex_sorcerer = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_vortex_sorcerer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			},
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_61_0)
				return arg_61_0.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function(arg_62_0)
				return arg_62_0.cursed_chest_elites <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_vortex_sorcerer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			},
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_63_0)
				return arg_63_0.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function(arg_64_0)
				return arg_64_0.cursed_chest_elites <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_vortex_sorcerer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			},
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_65_0)
				return arg_65_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_66_0)
				return arg_66_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_corruptor_sorcerer = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_corruptor_sorcerer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			},
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_67_0)
				return arg_67_0.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function(arg_68_0)
				return arg_68_0.cursed_chest_elites <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_corruptor_sorcerer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			},
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_69_0)
				return arg_69_0.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function(arg_70_0)
				return arg_70_0.cursed_chest_elites <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_corruptor_sorcerer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 2
			},
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_71_0)
				return arg_71_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_72_0)
				return arg_72_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_troll = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_troll",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6,
			pre_spawn_func = var_0_0.add_enhancements_for_difficulty
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 10,
				harder = 12,
				cataclysm = 16,
				normal = 8
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_fanatic",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 10,
				harder = 12,
				cataclysm = 16,
				normal = 8
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_73_0)
				return arg_73_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_74_0)
				return arg_74_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_spawn = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_spawn",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6,
			pre_spawn_func = var_0_0.add_enhancements_for_difficulty
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_marauder",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 10,
				harder = 12,
				cataclysm = 16,
				normal = 8
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_75_0)
				return arg_75_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_76_0)
				return arg_76_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_faction_beastmen = {
		{
			"one_of",
			{
				{
					"inject_event",
					weighted_event_names = {
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_beastmen_bestigor_bearer"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_beastmen_horde_bearer"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_beastmen_ungor_archer"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_beastmen_bestigor"
						},
						{
							weight = 3,
							event_name = "arena_belakor_around_statue_spawns_beastmen_minotaur"
						}
					}
				}
			}
		}
	},
	arena_belakor_around_statue_spawns_beastmen_bestigor_bearer = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_bestigor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_standard_bearer",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 1
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_77_0)
				return arg_77_0.cursed_chest_enemies <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_bestigor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 3,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_standard_bearer",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 1
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_78_0)
				return arg_78_0.cursed_chest_enemies <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_bestigor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 3,
				harder = 4,
				cataclysm = 6,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_standard_bearer",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 3,
				hard = 2,
				harder = 2,
				cataclysm = 3,
				normal = 1
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_79_0)
				return arg_79_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_80_0)
				return arg_80_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_horde_bearer = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_standard_bearer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_81_0)
				return arg_81_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_82_0)
				return arg_82_0.cursed_chest_enemies <= 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_standard_bearer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_83_0)
				return arg_83_0.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_84_0)
				return arg_84_0.cursed_chest_enemies <= 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_standard_bearer",
			spawn_counter_category = "cursed_chest_elites",
			difficulty_amount = {
				hardest = 2,
				hard = 2,
				harder = 2,
				cataclysm = 2,
				normal = 1
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_85_0)
				return arg_85_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_86_0)
				return arg_86_0.cursed_chest_elites <= 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_87_0)
				return arg_87_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_ungor_archer = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor_archer",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 12,
				harder = 12,
				cataclysm = 16,
				normal = 10
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function(arg_88_0)
				return arg_88_0.cursed_chest_enemies <= 0
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor_archer",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 12,
				harder = 12,
				cataclysm = 16,
				normal = 10
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function(arg_89_0)
				return arg_89_0.cursed_chest_enemies <= 0
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor_archer",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 12,
				harder = 12,
				cataclysm = 16,
				normal = 10
			},
			min_distance = var_0_8 - var_0_11 * 0.5,
			max_distance = var_0_8 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_ungor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 38,
				hard = 32,
				harder = 34,
				cataclysm = 40,
				normal = 30
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_90_0)
				return arg_90_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_91_0)
				return arg_91_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_bestigor = {
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_bestigor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 4,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_gor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 5,
				harder = 5,
				cataclysm = 5,
				normal = 5
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_92_0)
				return arg_92_0.cursed_chest_enemies <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_bestigor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 4,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_gor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 5,
				harder = 5,
				cataclysm = 5,
				normal = 5
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = var_0_5
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_93_0)
				return arg_93_0.cursed_chest_enemies <= 2
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_bestigor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 4,
				hard = 3,
				harder = 4,
				cataclysm = 4,
				normal = 2
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_gor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 5,
				hard = 5,
				harder = 5,
				cataclysm = 5,
				normal = 5
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_94_0)
				return arg_94_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_95_0)
				return arg_95_0.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_minotaur = {
		{
			"delay",
			duration = var_0_4
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_minotaur",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = var_0_9 - var_0_11 * 0.5,
			max_distance = var_0_9 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6,
			pre_spawn_func = var_0_0.add_enhancements_for_difficulty
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_gor",
			spawn_counter_category = "cursed_chest_enemies",
			difficulty_amount = {
				hardest = 14,
				hard = 10,
				harder = 12,
				cataclysm = 16,
				normal = 8
			},
			min_distance = var_0_7 - var_0_11 * 0.5,
			max_distance = var_0_7 + var_0_11 * 0.5,
			pre_spawn_unit_func = var_0_15,
			post_spawn_unit_func = var_0_16,
			spawn_delay = var_0_6
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_96_0)
				return arg_96_0.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function(arg_97_0)
				return arg_97_0.cursed_chest_enemies <= 0
			end
		}
	}
}

return {
	var_0_17
}
