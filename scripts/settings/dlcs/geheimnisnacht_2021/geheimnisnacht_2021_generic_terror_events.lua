-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_generic_terror_events.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	Managers.state.entity:system("buff_system"):add_buff(arg_1_0, "geheimnisnacht_2021_event_cultist_buff", arg_1_0)
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = {
		"shockwave",
		"ignore_death_aura"
	}
	local var_2_1 = "elite_base"
	local var_2_2 = var_2_0[math.random(1, #var_2_0)]
	local var_2_3 = arg_2_0.enhancements or {}

	var_2_3[#var_2_3 + 1] = BreedEnhancements[var_2_1]
	var_2_3[#var_2_3 + 1] = BreedEnhancements[var_2_2]
	arg_2_0.enhancements = var_2_3

	return arg_2_0
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

GenericTerrorEvents.geheimnisnacht_2021_event = {
	{
		"set_master_event_running",
		name = "geheimnisnacht_2021_event"
	},
	{
		"spawn",
		{
			1,
			1
		},
		breed_name = "chaos_warrior",
		pre_spawn_func = var_0_1,
		optional_data = {
			spawn_chance = 1,
			spawned_func = AiUtils.magic_entrance_optional_spawned_func,
			prepare_func = var_0_2
		}
	},
	{
		"one_of",
		{
			{
				"inject_event",
				event_name_list = {
					"geheimnisnacht_2021_event_faction_skaven"
				},
				faction_requirement_list = {
					"skaven"
				}
			},
			{
				"inject_event",
				event_name_list = {
					"geheimnisnacht_2021_event_faction_chaos"
				},
				faction_requirement_list = {
					"chaos"
				}
			},
			{
				"inject_event",
				event_name_list = {
					"geheimnisnacht_2021_event_faction_beastmen"
				},
				faction_requirement_list = {
					"beastmen"
				}
			}
		}
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_faction_skaven = {
	{
		"one_of",
		{
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_skaven_slaves"
					},
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_skaven_shields"
					},
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_skaven_big_shields"
					}
				}
			}
		}
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_skaven_slaves = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_large",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "storm_vermin_small",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_4_0)
			return arg_4_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_5_0)
			return arg_5_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_skaven_shields = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_medium_shield",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_extra_spice_small",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_6_0)
			return arg_6_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_7_0)
			return arg_7_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_skaven_big_shields = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_medium",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "storm_vermin_shields_small",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_8_0)
			return arg_8_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_9_0)
			return arg_9_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_faction_chaos = {
	{
		"one_of",
		{
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_chaos_fanatics"
					},
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_chaos_spice"
					},
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_chaos_berzerkers"
					}
				}
			}
		}
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_chaos_fanatics = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_large_chaos",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_10_0)
			return arg_10_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_11_0)
			return arg_11_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_chaos_spice = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_medium_chaos",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_chaos_extra_spice_small",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_12_0)
			return arg_12_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_13_0)
			return arg_13_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_chaos_berzerkers = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_medium_chaos",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "chaos_berzerkers_small",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_14_0)
			return arg_14_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_15_0)
			return arg_15_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_faction_beastmen = {
	{
		"one_of",
		{
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "geheimnisnacht_2021_event_beastmen_ungor"
					}
				}
			}
		}
	}
}
GenericTerrorEvents.geheimnisnacht_2021_event_beastmen_ungor = {
	{
		"start_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	},
	{
		"play_stinger",
		stinger_name = "Play_event_stinger_geheimnisnacht_ritual_broken"
	},
	{
		"delay",
		duration = 0.5
	},
	{
		"event_horde",
		spawn_counter_category = "geheimnisnacht_2021",
		composition_type = "event_large_beastmen",
		optional_data = {
			spawned_func = var_0_0
		}
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_16_0)
			return arg_16_0.geheimnisnacht_2021 > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_17_0)
			return arg_17_0.geheimnisnacht_2021 <= 0
		end
	},
	{
		"end_mission",
		mission_name = "mission_geheimnisnacht_2021_event"
	}
}
