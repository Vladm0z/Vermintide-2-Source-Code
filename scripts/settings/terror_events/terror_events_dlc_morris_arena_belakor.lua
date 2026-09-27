-- chunkname: @scripts/settings/terror_events/terror_events_dlc_morris_arena_belakor.lua

local scripts_settings_terror_events_terror_event_utils = require("scripts/settings/terror_events/terror_event_utils")
local HARDEST = scripts_settings_terror_events_terror_event_utils.HARDEST
local num = 8
local num_2 = 16
local num_3 = 2
local num_4 = 4
local num_5 = 4
local num_6 = 9
local num_7 = 9
local num_8 = 9
local num_9 = 4
local num_10 = 4
local tbl = {
	default = 1,
	special = 1.2,
	elite = 1.2,
	boss = 2
}
local str = "units/decals/deus_decal_aoe_cursedchest_01"
local str_2 = "fx/cursed_chest_spawn_01_portal"

local function fn(self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local decal_map = self.decal_map

	decal_map = decal_map or {}
	self.decal_map = decal_map

	local var_1_1 = Breeds[arg_1_3]
	local var_1_2

	if not var_1_1.boss then
		var_1_2 = tbl.boss
	elseif not var_1_1.special then
		var_1_2 = tbl.special
	elseif not var_1_1.elite then
		var_1_2 = tbl.elite
	else
		var_1_2 = tbl.default
	end

	local unbox = arg_1_2:unbox()
	local var_1_4
	local var_1_5
	local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
	local var_1_7 = var_1_2

	Matrix4x4.set_scale(from_quaternion_position, Vector3(var_1_7, var_1_7, var_1_7))

	local spawn_network_unit, var_1_9 = Managers.state.unit_spawner:spawn_network_unit(str, "network_synched_dummy_unit", nil, from_quaternion_position)
	local var_1_10 = str_2
	local var_1_11 = Vector3(0, 0, 0)
	local identity = Quaternion.identity()
	local flag = true
	local num = 0

	Managers.state.event:trigger("event_play_particle_effect", var_1_10, spawn_network_unit, num, var_1_11, identity, flag)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_play_particle_effect", NetworkLookup.effects[var_1_10], var_1_9, num, var_1_11, identity, flag)

	decal_map[arg_1_2] = spawn_network_unit
end

local function fn_2(self, arg_2_1, arg_2_2)
	-- function 2
	local decal_map = self.decal_map
	local flag = not decal_map and decal_map[arg_2_2]

	if not flag then
		Managers.state.unit_spawner:mark_for_deletion(flag)

		decal_map[arg_2_2] = nil
	end
end

local tbl_2 = {
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
			duration = num
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
			duration = num
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
			duration = num
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
			duration = num
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 3
				return self.main < 10
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
			duration = num
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
			duration = num
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
			duration = num
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
			duration = num
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 4
				return self.main < 10
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
			duration = num
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
			duration = num
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
			duration = num
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
			duration = num
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 5
				return self.main < 10
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
			condition = function (self)
				-- function 6
				return not (self.boss <= 0) or not (self.main <= 0) or self.elite <= 0
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
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 7
				return self.special < 1
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
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 8
				return self.special < 1
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
			condition = function (self)
				-- function 9
				return self.special < 1
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
			duration = num_2
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
			duration = num_2
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
			duration = num_2
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
			duration = num_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 10
				return self.main < 10
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
			duration = num_2
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
			duration = num_2
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
			duration = num_2
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
			duration = num_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 11
				return self.main < 10
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
			duration = num_2
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
			duration = num_2
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
			duration = num_2
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
			duration = num_2
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 12
				return self.main < 10
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
			duration = num_3
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 13
				return self.cursed_chest_enemies <= 4
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 14
				return self.cursed_chest_enemies <= 4
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 15
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 16
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_vermin_shielded = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 17
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_9 * 0.5,
			max_distance = num_6 + num_9 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 18
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 19
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_plague_monks = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 20
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 21
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 22
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 23
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_warpfire_thrower = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 24
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 25
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 26
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 27
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 28
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 29
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 30
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_ratling_gunner = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 31
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 32
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 33
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 34
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 35
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 36
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 37
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_poison_wind_globadier = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 38
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 39
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 40
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 41
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 42
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 43
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 44
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_rat_ogre = {
		{
			"delay",
			duration = num_3
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_rat_ogre",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5,
			pre_spawn_func = scripts_settings_terror_events_terror_event_utils.add_enhancements_for_difficulty
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 45
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 46
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_skaven_stormfiend = {
		{
			"delay",
			duration = num_3
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_stormfiend",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5,
			pre_spawn_func = scripts_settings_terror_events_terror_event_utils.add_enhancements_for_difficulty
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 47
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 48
				return self.cursed_chest_enemies <= 0
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
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 49
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 50
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 51
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 52
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_berzerker = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 53
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 54
				return self.cursed_chest_enemies <= 5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 55
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 56
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_warrior = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 57
				return self.cursed_chest_enemies <= 4
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 58
				return self.cursed_chest_enemies <= 4
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 59
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 60
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_vortex_sorcerer = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 61
				return self.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (self)
				-- function 62
				return self.cursed_chest_elites <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 63
				return self.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (self)
				-- function 64
				return self.cursed_chest_elites <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 65
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 66
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_corruptor_sorcerer = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 67
				return self.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (self)
				-- function 68
				return self.cursed_chest_elites <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 69
				return self.cursed_chest_enemies <= 6
			end
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (self)
				-- function 70
				return self.cursed_chest_elites <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 71
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 72
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_troll = {
		{
			"delay",
			duration = num_3
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_troll",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5,
			pre_spawn_func = scripts_settings_terror_events_terror_event_utils.add_enhancements_for_difficulty
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 73
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 74
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_chaos_spawn = {
		{
			"delay",
			duration = num_3
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_spawn",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5,
			pre_spawn_func = scripts_settings_terror_events_terror_event_utils.add_enhancements_for_difficulty
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 75
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 76
				return self.cursed_chest_enemies <= 0
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
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 77
				return self.cursed_chest_enemies <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 78
				return self.cursed_chest_enemies <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 79
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 80
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_horde_bearer = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 81
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 82
				return self.cursed_chest_enemies <= 10
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 83
				return self.cursed_chest_elites <= 2
			end
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 84
				return self.cursed_chest_enemies <= 10
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 85
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 86
				return self.cursed_chest_elites <= 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 87
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_ungor_archer = {
		{
			"delay",
			duration = num_3
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (self)
				-- function 88
				return self.cursed_chest_enemies <= 0
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 10,
			condition = function (self)
				-- function 89
				return self.cursed_chest_enemies <= 0
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
			min_distance = num_7 - num_10 * 0.5,
			max_distance = num_7 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 90
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 91
				return self.cursed_chest_enemies <= 0
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 92
				return self.cursed_chest_enemies <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = num_4
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 93
				return self.cursed_chest_enemies <= 2
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 94
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 95
				return self.cursed_chest_enemies <= 0
			end
		}
	},
	arena_belakor_around_statue_spawns_beastmen_minotaur = {
		{
			"delay",
			duration = num_3
		},
		{
			"spawn_around_origin_unit",
			breed_name = "beastmen_minotaur",
			spawn_counter_category = "cursed_chest_enemies",
			min_distance = num_8 - num_10 * 0.5,
			max_distance = num_8 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5,
			pre_spawn_func = scripts_settings_terror_events_terror_event_utils.add_enhancements_for_difficulty
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
			min_distance = num_6 - num_10 * 0.5,
			max_distance = num_6 + num_10 * 0.5,
			pre_spawn_unit_func = fn,
			post_spawn_unit_func = fn_2,
			spawn_delay = num_5
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 96
				return self.cursed_chest_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 120,
			condition = function (self)
				-- function 97
				return self.cursed_chest_enemies <= 0
			end
		}
	}
}

return {
	tbl_2
}
