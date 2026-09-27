-- chunkname: @scripts/settings/dlcs/morris/deus_generic_terror_events.lua

require("scripts/settings/dlcs/morris/deus_terror_event_tags")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")
local num = 2
local num_2 = 3
local num_3 = 4
local num_4 = 5
local num_5 = 6
local num_6 = 8
local num_7 = 16
local var_0_8
local add_enhancements_for_difficulty = TerrorEventUtils.add_enhancements_for_difficulty

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if not (arg_1_1.special or arg_1_1.boss or arg_1_1.cannot_be_aggroed) then
		local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(arg_1_0, get_random_alive_hero)
	end

	Managers.state.entity:system("buff_system"):add_buff(arg_1_0, "cursed_chest_objective_unit", arg_1_0)

	if not BLACKBOARDS[arg_1_0] then
		local str = "Play_normal_spawn_stinger"

		if arg_1_1.special or not arg_1_1.boss then
			str = "Play_special_spawn_stinger"
		end

		Managers.state.entity:system("audio_system"):play_audio_unit_event(str, arg_1_0)
	end
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	Managers.state.entity:system("buff_system"):add_buff(arg_2_0, "objective_unit", arg_2_0)
	fn(arg_2_0, arg_2_1, arg_2_2)
end

GenericTerrorEvents.cursed_chest_prototype = {
	{
		"set_master_event_running",
		name = "cursed_chest_prototype"
	},
	{
		"inject_event",
		event_name_list = {
			"cursed_chest_challenge_faction_skaven",
			"cursed_chest_challenge_faction_chaos",
			"cursed_chest_challenge_faction_chaos"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"cursed_chest_challenge_faction_skaven",
			"cursed_chest_challenge_faction_beastmen",
			"cursed_chest_challenge_faction_beastmen"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"cursed_chest_challenge_faction_chaos",
			"cursed_chest_challenge_faction_beastmen"
		},
		faction_requirement_list = {
			"chaos",
			"beastmen"
		}
	}
}

local num_8 = 2
local num_9 = 4
local num_10 = 4
local num_11 = 8
local num_12 = 15
local num_13 = 20
local num_14 = 5
local num_15 = 7
local num_16 = 9
local tbl = {
	default = 1,
	special = 1.2,
	elite = 1.2,
	boss = 2
}
local str = "units/decals/deus_decal_aoe_cursedchest_01"

local function fn_3(self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local decal_map = self.decal_map

	decal_map = decal_map or {}
	self.decal_map = decal_map

	local var_3_1 = Breeds[arg_3_3]
	local var_3_2

	if not var_3_1.boss then
		var_3_2 = tbl.boss
	elseif not var_3_1.special then
		var_3_2 = tbl.special
	elseif not var_3_1.elite then
		var_3_2 = tbl.elite
	else
		var_3_2 = tbl.default
	end

	local unbox = arg_3_2:unbox()
	local var_3_4
	local var_3_5
	local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
	local var_3_7 = var_3_2

	Matrix4x4.set_scale(from_quaternion_position, Vector3(var_3_7, var_3_7, var_3_7))

	local var_3_8

	decal_map[arg_3_2], var_3_8 = Managers.state.unit_spawner:spawn_network_unit(str, "network_synched_dummy_unit", nil, from_quaternion_position)
end

local function fn_4(self, arg_4_1, arg_4_2)
	-- function 4
	local decal_map = self.decal_map
	local flag = not decal_map and decal_map[arg_4_2]

	if not flag then
		Unit.flow_event(flag, "despawned")

		local go_id = Managers.state.unit_storage:go_id(flag)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_event", go_id, NetworkLookup.flow_events.despawned)

		decal_map[arg_4_2] = nil
	end
end

local num_17 = 2.5
local num_18 = 3.5
local num_19 = 1
local num_20 = 1
local num_21 = 1
local num_22 = 0.5
local num_23 = 8
local num_24 = 64
local num_25 = 192
local tbl_2 = {
	"idle_pray_01",
	"idle_pray_02",
	"idle_pray_03",
	"idle_pray_04",
	"idle_pray_05"
}

GenericTerrorEvents.cursed_chest_challenge_faction_skaven = {
	{
		"one_of",
		{
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_vermin_shielded"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_stormvermin"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_plague_monks"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_ELITES
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_warpfire_thrower"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_ratling_gunner"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_poison_wind_globadier"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_rat_ogre"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_stormfiend"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_double_monster"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_MONSTERS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_vermin_shielded"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_stormvermin"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_plague_monks"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_warpfire_thrower"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_ratling_gunner"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_poison_wind_globadier"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_rat_ogre"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_stormfiend"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_double_monster"
					}
				}
			}
		}
	}
}
GenericTerrorEvents.cursed_chest_challenge_stormvermin = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_stormvermin"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_storm_vermin_commander",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 9,
			hard = 7,
			harder = 8,
			cataclysm = 10,
			normal = 6
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 5
			return self.cursed_chest_enemies <= 4
		end
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_storm_vermin_commander",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 9,
			hard = 7,
			harder = 8,
			cataclysm = 10,
			normal = 6
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 6
			return self.cursed_chest_enemies <= 4
		end
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_storm_vermin_commander",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 9,
			hard = 7,
			harder = 8,
			cataclysm = 10,
			normal = 6
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 7
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 8
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_stormvermin"
	}
}
GenericTerrorEvents.cursed_chest_challenge_vermin_shielded = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_vermin_shielded"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_storm_vermin_with_shield",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 5,
			harder = 6,
			cataclysm = 8,
			normal = 4
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_clan_rat_with_shield",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 7,
			harder = 6,
			cataclysm = 4,
			normal = 8
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 9
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_storm_vermin_with_shield",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 5,
			harder = 6,
			cataclysm = 8,
			normal = 4
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_clan_rat_with_shield",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 7,
			harder = 6,
			cataclysm = 4,
			normal = 8
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_14 * 0.5,
		max_distance = num_11 + num_14 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 10
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 11
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_vermin_shielded"
	}
}
GenericTerrorEvents.cursed_chest_challenge_plague_monks = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_plague_monks"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_plague_monk",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 5,
			harder = 6,
			cataclysm = 8,
			normal = 4
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_clan_rat",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 10,
			harder = 9,
			cataclysm = 6,
			normal = 12
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 12
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"spawn_around_origin_unit",
		spawn_counter_category = "cursed_chest_enemies",
		breed_name = "skaven_plague_monk",
		distance_to_players = 3,
		difficulty_amount = {
			hardest = 7,
			hard = 5,
			harder = 6,
			cataclysm = 8,
			normal = 4
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_clan_rat",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 10,
			harder = 9,
			cataclysm = 6,
			normal = 12
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 13
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_plague_monk",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 5,
			harder = 6,
			cataclysm = 8,
			normal = 4
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_clan_rat",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 10,
			harder = 9,
			cataclysm = 6,
			normal = 12
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 14
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 15
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_plague_monks"
	}
}
GenericTerrorEvents.cursed_chest_challenge_skaven_warpfire_thrower = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_skaven_warpfire_thrower"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_warpfire_thrower",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 16
			return self.cursed_chest_elites <= 2
		end
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
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_warpfire_thrower",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 18
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 19
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_warpfire_thrower",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 20
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 21
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 22
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_skaven_warpfire_thrower"
	}
}
GenericTerrorEvents.cursed_chest_challenge_skaven_ratling_gunner = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_skaven_ratling_gunner"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_ratling_gunner",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 23
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 24
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_ratling_gunner",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 25
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 26
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_ratling_gunner",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 27
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 28
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 29
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_skaven_ratling_gunner"
	}
}
GenericTerrorEvents.cursed_chest_challenge_skaven_poison_wind_globadier = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_skaven_poison_wind_globadier"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_poison_wind_globadier",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 30
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 31
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_poison_wind_globadier",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 32
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 33
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_poison_wind_globadier",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 34
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 35
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 36
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_skaven_poison_wind_globadier"
	}
}
GenericTerrorEvents.cursed_chest_challenge_skaven_rat_ogre = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_skaven_rat_ogre"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_rat_ogre",
		spawn_counter_category = "cursed_chest_enemies",
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 37
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 38
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_skaven_rat_ogre"
	}
}
GenericTerrorEvents.cursed_chest_challenge_skaven_stormfiend = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_skaven_stormfiend"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "skaven_stormfiend",
		spawn_counter_category = "cursed_chest_enemies",
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 39
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 40
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_skaven_stormfiend"
	}
}
GenericTerrorEvents.cursed_chest_challenge_double_monster = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_double_monster"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		spawn_counter_category = "cursed_chest_enemies",
		breed_name = {
			"skaven_rat_ogre",
			"skaven_stormfiend",
			"chaos_troll",
			"chaos_spawn"
		},
		optional_data = {
			max_health_modifier = 0.5,
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
	},
	{
		"delay",
		duration = 1
	},
	{
		"spawn_around_origin_unit",
		spawn_counter_category = "cursed_chest_enemies",
		breed_name = {
			"skaven_rat_ogre",
			"skaven_stormfiend",
			"chaos_troll",
			"chaos_spawn"
		},
		optional_data = {
			max_health_modifier = 0.5,
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 41
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 42
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_double_monster"
	}
}
GenericTerrorEvents.cursed_chest_challenge_faction_chaos = {
	{
		"one_of",
		{
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_raider"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_berzerker"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_warrior"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_bulwark"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_ELITES
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_warpfire_thrower"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_ratling_gunner"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_poison_wind_globadier"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS,
					DeusTerrorEventTags.NO_SORCERERS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_vortex_sorcerer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_corruptor_sorcerer"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_troll"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_spawn"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_MONSTERS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_raider"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_berzerker"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_warrior"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_bulwark"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_warpfire_thrower"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_ratling_gunner"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_skaven_poison_wind_globadier"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_troll"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_spawn"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.NO_SORCERERS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_raider"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_berzerker"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_warrior"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_bulwark"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_vortex_sorcerer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_corruptor_sorcerer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_troll"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_chaos_spawn"
					}
				}
			}
		}
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_raider = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_raider"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_raider",
		spawn_delay = 4,
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 4,
			harder = 5,
			cataclysm = 7,
			normal = 3
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_delay = 4,
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 8,
			harder = 7,
			cataclysm = 5,
			normal = 9
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 43
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_raider",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 4,
			harder = 5,
			cataclysm = 7,
			normal = 3
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 8,
			harder = 7,
			cataclysm = 5,
			normal = 9
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 44
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_raider",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 4,
			harder = 5,
			cataclysm = 7,
			normal = 3
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 8,
			harder = 7,
			cataclysm = 5,
			normal = 9
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_raider"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_berzerker = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_berzerker"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_berzerker",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 4,
			harder = 5,
			cataclysm = 7,
			normal = 3
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 8,
			harder = 7,
			cataclysm = 5,
			normal = 9
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 47
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_berzerker",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 4,
			harder = 5,
			cataclysm = 7,
			normal = 3
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 8,
			harder = 7,
			cataclysm = 5,
			normal = 9
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 48
			return self.cursed_chest_enemies <= 5
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_berzerker",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 4,
			harder = 5,
			cataclysm = 7,
			normal = 3
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 6,
			hard = 8,
			harder = 7,
			cataclysm = 5,
			normal = 9
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 49
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 50
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_berzerker"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_warrior = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_warrior"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_warrior",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 3,
			harder = 4,
			cataclysm = 6,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 9,
			harder = 8,
			cataclysm = 6,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 51
			return self.cursed_chest_enemies <= 4
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_warrior",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 3,
			harder = 4,
			cataclysm = 6,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 9,
			harder = 8,
			cataclysm = 6,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 52
			return self.cursed_chest_enemies <= 4
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_warrior",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 3,
			harder = 4,
			cataclysm = 6,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 9,
			harder = 8,
			cataclysm = 6,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 53
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 54
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_warrior"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_bulwark = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_bulwark"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_bulwark",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 3,
			harder = 4,
			cataclysm = 6,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 9,
			harder = 8,
			cataclysm = 6,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 55
			return self.cursed_chest_enemies <= 4
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_bulwark",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 3,
			harder = 4,
			cataclysm = 6,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 9,
			harder = 8,
			cataclysm = 6,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 56
			return self.cursed_chest_enemies <= 4
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_bulwark",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 3,
			harder = 4,
			cataclysm = 6,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_marauder",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 7,
			hard = 9,
			harder = 8,
			cataclysm = 6,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 57
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 58
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_bulwark"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_vortex_sorcerer = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_vortex_sorcerer"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 59
			return self.cursed_chest_enemies <= 6
		end
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function (self)
			-- function 60
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
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
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 63
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 64
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_vortex_sorcerer"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_corruptor_sorcerer = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_corruptor_sorcerer"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 65
			return self.cursed_chest_enemies <= 6
		end
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function (self)
			-- function 66
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
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
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 69
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 70
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_corruptor_sorcerer"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_troll = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_troll"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_troll",
		spawn_counter_category = "cursed_chest_enemies",
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 10
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
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
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_troll"
	}
}
GenericTerrorEvents.cursed_chest_challenge_chaos_spawn = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_chaos_spawn"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "chaos_spawn",
		spawn_counter_category = "cursed_chest_enemies",
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_chaos_spawn"
	}
}
GenericTerrorEvents.cursed_chest_challenge_faction_beastmen = {
	{
		"one_of",
		{
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_ungor_archer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_bestigor"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_ELITES
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_bestigor_bearer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_horde_bearer"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_minotaur"
					}
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_MONSTERS
				}
			},
			{
				"inject_event",
				weighted_event_names = {
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_bestigor_bearer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_horde_bearer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_ungor_archer"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_bestigor"
					},
					{
						weight = 3,
						event_name = "cursed_chest_challenge_beastmen_minotaur"
					}
				}
			}
		}
	}
}
GenericTerrorEvents.cursed_chest_challenge_beastmen_bestigor_bearer = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_beastmen_bestigor_bearer"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_bestigor",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 5,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 75
			return self.cursed_chest_enemies <= 2
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_bestigor",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 4,
			hard = 3,
			harder = 3,
			cataclysm = 5,
			normal = 2
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 76
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 77
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_beastmen_bestigor_bearer"
	}
}
GenericTerrorEvents.cursed_chest_challenge_beastmen_horde_bearer = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_beastmen_horde_bearer"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_standard_bearer",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 1
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 78
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 79
			return self.cursed_chest_enemies <= 10
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_standard_bearer",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 1
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 80
			return self.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 81
			return self.cursed_chest_enemies <= 10
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_standard_bearer",
		spawn_counter_category = "cursed_chest_elites",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 1
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 82
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 83
			return self.cursed_chest_elites <= 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 84
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_beastmen_horde_bearer"
	}
}
GenericTerrorEvents.cursed_chest_challenge_beastmen_ungor_archer = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_beastmen_ungor_archer"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_ungor_archer",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 18,
			hard = 12,
			harder = 14,
			cataclysm = 20,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function (self)
			-- function 85
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_ungor_archer",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 18,
			hard = 12,
			harder = 14,
			cataclysm = 20,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function (self)
			-- function 86
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_ungor_archer",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 18,
			hard = 12,
			harder = 14,
			cataclysm = 20,
			normal = 10
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_12 - num_15 * 0.5,
		max_distance = num_12 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 87
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 88
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_beastmen_ungor_archer"
	}
}
GenericTerrorEvents.cursed_chest_challenge_beastmen_bestigor = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_beastmen_bestigor"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_gor",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 7,
			harder = 6,
			cataclysm = 4,
			normal = 8
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 89
			return self.cursed_chest_enemies <= 2
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_gor",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 7,
			harder = 6,
			cataclysm = 4,
			normal = 8
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = num_9
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 90
			return self.cursed_chest_enemies <= 2
		end
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_gor",
		spawn_counter_category = "cursed_chest_enemies",
		difficulty_amount = {
			hardest = 5,
			hard = 7,
			harder = 6,
			cataclysm = 4,
			normal = 8
		},
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 91
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 92
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_beastmen_bestigor"
	}
}
GenericTerrorEvents.cursed_chest_challenge_beastmen_minotaur = {
	{
		"start_mission",
		mission_name = "cursed_chest_challenge_beastmen_minotaur"
	},
	{
		"delay",
		duration = num_8
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"spawn_around_origin_unit",
		breed_name = "beastmen_minotaur",
		spawn_counter_category = "cursed_chest_enemies",
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_13 - num_15 * 0.5,
		max_distance = num_13 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10,
		pre_spawn_func = add_enhancements_for_difficulty
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
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = fn
		},
		min_distance = num_11 - num_15 * 0.5,
		max_distance = num_11 + num_15 * 0.5,
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		spawn_delay = num_10
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 93
			return self.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 94
			return self.cursed_chest_enemies <= 0
		end
	},
	{
		"end_mission",
		mission_name = "cursed_chest_challenge_beastmen_minotaur"
	}
}
GenericTerrorEvents.cursed_chest_challenge_test = {
	{
		"set_master_event_running",
		name = "cursed_chest_prototype"
	},
	{
		"event_horde",
		spawn_counter_category = "cursed_chest_enemies",
		composition_type = "cursed_chest_challenge_test",
		optional_data = {
			spawned_func = function (arg_95_0, arg_95_1, arg_95_2)
				-- function 95
				Managers.state.entity:system("buff_system"):add_buff(arg_95_0, "objective_unit", arg_95_0)
			end
		}
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
		duration = 60,
		condition = function (self)
			-- function 97
			return self.cursed_chest_enemies <= 0
		end
	}
}

local tbl_3 = {
	{
		crippling = true,
		intangible = true,
		frenzy = true
	},
	{
		regenerating = true,
		periodic_curse = true,
		unstaggerable = true
	},
	{
		crushing = true,
		ranged_immune = true,
		vampiric = true
	}
}
local tbl_4 = {
	"shadow_curse_sc1_spawn",
	"shadow_curse_sc2_spawn",
	"shadow_curse_sc3_spawn"
}

local function fn_5(arg_98_0, arg_98_1)
	-- function 98
	return {
		{
			"play_stinger",
			stinger_name = "Play_wave_start_spawn_stinger_small"
		},
		{
			"inject_event",
			event_name_list = {
				"belakor_locus_wave_one_one",
				"belakor_locus_wave_one_two",
				"belakor_locus_wave_one_three"
			},
			faction_requirement_list = {}
		},
		{
			"continue_when_spawned_count",
			duration = 4,
			condition = function (self)
				-- function 99
				return self.belakor_totem_enemies < 1
			end
		},
		{
			"inject_event",
			event_name_list = {
				"belakor_locus_wave_two_one",
				"belakor_locus_wave_two_two",
				"belakor_locus_wave_two_three"
			},
			faction_requirement_list = {}
		},
		{
			"continue_when_spawned_count",
			duration = 4,
			condition = function (self)
				-- function 100
				return self.belakor_totem_enemies < 1
			end
		},
		{
			"spawn_around_origin_unit",
			face_nearest_player_of_side = "heroes",
			check_line_of_sight = true,
			spawn_counter_category = "belakor_altar_enemies",
			breed_name = "shadow_lieutenant",
			difficulty_amount = {
				hardest = 1,
				hard = 1,
				harder = 1,
				cataclysm = 1,
				normal = 1
			},
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = function (arg_101_0, arg_101_1, arg_101_2)
					-- function 101
					if not (arg_101_1.special or arg_101_1.boss or arg_101_1.cannot_be_aggroed) then
						local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

						AiUtils.aggro_unit_of_enemy(arg_101_0, get_random_alive_hero)
					end

					Managers.state.entity:system("buff_system"):add_buff(arg_101_0, "belakor_shadow_lieutenant", arg_101_0)

					local var_101_1 = BLACKBOARDS[arg_101_0]

					if not var_101_1 then
						local world = var_101_1.world
						local str = "shadow_lieutenant_spawn"

						WwiseUtils.trigger_unit_event(world, str, arg_101_0, 0)
					end

					local var_101_4 = tbl_4[arg_98_0]

					if not var_101_4 then
						local extension_input = ScriptUnit.extension_input(arg_101_0, "dialogue_system")
						local alloc_table = FrameTable.alloc_table()

						extension_input:trigger_dialogue_event(var_101_4, alloc_table)
					end
				end
			},
			spawn_failed_func = function (arg_102_0)
				-- function 102
				BelakorBalancing.spawn_crystal_func(arg_102_0)
			end,
			min_distance = num_17,
			max_distance = num_18,
			row_distance = num_22,
			above_max = num_19,
			below_max = num_20,
			distance_to_enemies = num_21,
			circle_subdivision = num_24,
			tries = num_25,
			pre_spawn_unit_func = fn_3,
			post_spawn_unit_func = fn_4,
			spawn_delay = num_10,
			pre_spawn_func = function (self, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
				-- function 103
				self = self or {}

				if not arg_98_1 then
					self.enhancements = {
						BreedEnhancements.base
					}
				end

				local var_103_0 = tbl_3[arg_98_0]
				local num = 2

				for i = 1, num do
					if not (not var_103_0 and table.is_empty(var_103_0)) then
						local tbl = {}

						for k, v in pairs(BreedEnhancements) do
							if not var_103_0[k] then
								table.insert(tbl, v)
							end
						end

						if #tbl > 0 then
							local var_103_3 = tbl[Math.random(1, #tbl)]

							table.insert(self.enhancements, var_103_3)
						end
					end
				end

				return self
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function (self)
				-- function 104
				return self.belakor_altar_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function (self)
				-- function 105
				return self.belakor_altar_enemies <= 0
			end
		}
	}
end

GenericTerrorEvents.belakor_shadow_lieutenant_spawn = fn_5(-1, true)
GenericTerrorEvents.belakor_altar_shadow_lieutenant_spawn_01 = fn_5(1, true)
GenericTerrorEvents.belakor_altar_shadow_lieutenant_spawn_02 = fn_5(2, true)
GenericTerrorEvents.belakor_altar_shadow_lieutenant_spawn_03 = fn_5(3, true)
GenericTerrorEvents.belakor_altar_cultists_spawn = {
	{
		"spawn_around_origin_unit",
		face_unit = true,
		group_template = "deus_belakor_locus_cultists",
		check_line_of_sight = true,
		spawn_counter_category = "belakor_altar_enemies",
		breed_spawn_table_per_difficulty = {
			default = {
				"skaven_plague_monk",
				"skaven_clan_rat",
				"skaven_plague_monk",
				"skaven_clan_rat",
				"skaven_plague_monk",
				"skaven_clan_rat"
			}
		},
		optional_data = {
			far_off_despawn_immunity = true,
			prevent_killed_enemy_dialogue = true,
			ignore_breed_limits = true,
			spawned_func = function (arg_106_0, arg_106_1, arg_106_2)
				-- function 106
				ScriptUnit.extension(arg_106_0, "ai_system"):set_perception("perception_regular", "pick_closest_target_with_spillover_wakeup_group")

				local var_106_0 = BLACKBOARDS[arg_106_0]

				if not var_106_0 then
					var_106_0.ignore_interest_points = true
					var_106_0.only_trust_your_own_eyes = true

					Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_106_0)
				end

				Managers.state.entity:system("buff_system"):add_buff(arg_106_0, "belakor_cultists_buff", arg_106_0)
			end
		},
		min_distance = num_17,
		max_distance = num_18,
		row_distance = num_22,
		circle_subdivision = num_23,
		distance_to_enemies = num_21,
		above_max = num_19,
		below_max = num_20,
		pre_spawn_func = function (self, arg_107_1, arg_107_2, arg_107_3, arg_107_4)
			-- function 107
			self = self or {}
			self.idle_animation = tbl_2[math.random(#tbl_2)]

			return self
		end
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 108
			return self.belakor_altar_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 109
			return self.belakor_altar_enemies <= 0
		end
	}
}

local function fn_6(arg_110_0)
	-- function 110
	return {
		"spawn_around_origin_unit",
		max_distance = 4,
		min_distance = 2,
		distance_to_enemies = 2,
		circle_subdivision = 3,
		row_distance = 0.5,
		spawn_delay = 1.7,
		spawn_counter_category = "belakor_totem_enemies",
		breed_spawn_table_per_difficulty = arg_110_0,
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = function (arg_111_0, arg_111_1, arg_111_2)
				-- function 111
				if not (arg_111_1.special or arg_111_1.boss or arg_111_1.cannot_be_aggroed) then
					local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

					AiUtils.aggro_unit_of_enemy(arg_111_0, get_random_alive_hero)

					if not BLACKBOARDS[arg_111_0] then
						Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_111_0)
					end
				end
			end
		},
		pre_spawn_unit_func = fn_3,
		post_spawn_unit_func = fn_4,
		above_max = num_19,
		below_max = num_20
	}
end

local totem_spawn_cooldown = BelakorBalancing.totem_spawn_cooldown

GenericTerrorEvents.belakor_easy_totem_spawns = {
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_skaven_slaves",
			"belakor_totem_stormvermin",
			"belakor_totem_clan_rat_with_shield",
			"belakor_totem_clan_rats",
			"belakor_totem_chaos_fanatics",
			"belakor_totem_chaos_marauders",
			"belakor_totem_chaos_raider"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_skaven_slaves",
			"belakor_totem_stormvermin",
			"belakor_totem_clan_rat_with_shield",
			"belakor_totem_clan_rats",
			"belakor_totem_beastmen_ungor",
			"belakor_totem_beastmen_gor",
			"belakor_totem_beastmen_archers"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	}
}
GenericTerrorEvents.belakor_hard_totem_spawns = {
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_plague_monk",
			"belakor_totem_stormvermin",
			"belakor_totem_stormvermin_shield",
			"belakor_totem_chaos_raider",
			"belakor_totem_chaos_warriors",
			"belakor_totem_chaos_berzerkers"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_plague_monk",
			"belakor_totem_stormvermin",
			"belakor_totem_stormvermin_shield",
			"belakor_totem_beastmen_archers",
			"belakor_totem_beastmen_bestigor"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	}
}
GenericTerrorEvents.belakor_totem_panic_spawns = {
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_skaven_panic_storm_vermin",
			"belakor_totem_skaven_panic_plague_monk",
			"belakor_totem_skaven_shield",
			"belakor_totem_chaos_panic_berzerkers",
			"belakor_totem_chaos_panic_raiders",
			"belakor_totem_chaos_panic_chaos_warrior"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_skaven_panic_storm_vermin",
			"belakor_totem_skaven_panic_plague_monk",
			"belakor_totem_skaven_shield",
			"belakor_totem_beastmen_panic_bestigor",
			"belakor_totem_beastmen_panic_ungors",
			"belakor_totem_beastmen_panic_archers"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	}
}
GenericTerrorEvents.belakor_arena_totem_spawns = {
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_plague_monk",
			"belakor_totem_stormvermin",
			"belakor_totem_stormvermin_shield",
			"belakor_totem_clan_rat_with_shield",
			"belakor_totem_clan_rats",
			"belakor_totem_chaos_fanatics",
			"belakor_totem_chaos_marauders",
			"belakor_totem_chaos_raider",
			"belakor_totem_chaos_warriors",
			"belakor_totem_chaos_berzerkers"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"belakor_totem_plague_monk",
			"belakor_totem_stormvermin",
			"belakor_totem_stormvermin_shield",
			"belakor_totem_clan_rat_with_shield",
			"belakor_totem_clan_rats",
			"belakor_totem_beastmen_ungor",
			"belakor_totem_beastmen_gor",
			"belakor_totem_beastmen_archers",
			"belakor_totem_beastmen_bestigor"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 112
			return self.belakor_totem_enemies < 1
		end
	}
}
GenericTerrorEvents.belakor_totem_plague_monk = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_plague_monk",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_stormvermin = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_storm_vermin_commander",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_stormvermin_shield = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_storm_vermin_with_shield",
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_clan_rat_with_shield = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_clan_rats = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_clan_rat",
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_skaven_slaves = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_slave",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_skaven_panic_storm_vermin = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_storm_vermin_commander",
			"skaven_storm_vermin_commander",
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_skaven_panic_plague_monk = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_plague_monk",
			"skaven_storm_vermin_commander",
			"skaven_slave",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_skaven_shield = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_fanatics = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_marauders = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_raider = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_raider",
			"chaos_raider"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_warriors = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_warrior",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_berzerkers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_berzerker",
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_panic_berzerkers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_berzerker",
			"chaos_berzerker",
			"chaos_fanatic",
			"chaos_fanatic"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_panic_raiders = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_raider",
			"chaos_raider",
			"chaos_fanatic",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_chaos_panic_chaos_warrior = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_warrior",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_one_one = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_raider",
			"chaos_raider",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_one_two = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_storm_vermin_commander",
			"skaven_storm_vermin_commander",
			"skaven_clan_rat",
			"skaven_clan_rat",
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_one_three = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_raider",
			"skaven_storm_vermin_with_shield",
			"skaven_clan_rat",
			"skaven_clan_rat",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_two_one = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"chaos_berzerker",
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic",
			"chaos_fanatic"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_two_two = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_plague_monk",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_two_three = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_plague_monk",
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_locus_wave_two_three = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"skaven_plague_monk",
			"skaven_plague_monk"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_ungor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_ungor",
			"beastmen_ungor",
			"beastmen_ungor",
			"beastmen_ungor",
			"beastmen_ungor"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_gor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_gor",
			"beastmen_gor",
			"beastmen_gor"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_archers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_ungor_archer",
			"beastmen_ungor_archer",
			"beastmen_ungor_archer"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_bestigor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_bestigor",
			"beastmen_gor",
			"beastmen_gor"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_panic_bestigor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_bestigor",
			"beastmen_bestigor"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_panic_ungors = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_ungor",
			"beastmen_ungor",
			"beastmen_ungor",
			"beastmen_ungor",
			"beastmen_ungor"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}
GenericTerrorEvents.belakor_totem_beastmen_panic_archers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	fn_6({
		default = {
			"beastmen_ungor_archer",
			"beastmen_ungor_archer",
			"beastmen_ungor_archer",
			"beastmen_ungor_archer"
		}
	}),
	{
		"delay",
		duration = totem_spawn_cooldown
	}
}

local function fn_7(arg_113_0)
	-- function 113
	return {
		"spawn_around_origin_unit",
		max_distance = 3,
		min_distance = 2,
		distance_to_enemies = 2,
		circle_subdivision = 3,
		spawn_delay = 0.25,
		spawn_counter_category = "grey_wings_enemies",
		breed_spawn_table_per_difficulty = arg_113_0,
		optional_data = {
			prevent_killed_enemy_dialogue = true,
			spawned_func = function (arg_114_0, arg_114_1, arg_114_2)
				-- function 114
				Managers.state.entity:system("buff_system"):add_buff(arg_114_0, "belakor_grey_wings", arg_114_0)

				local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

				if not arg_114_1.cannot_be_aggroed then
					AiUtils.aggro_unit_of_enemy(arg_114_0, get_random_alive_hero)
				end
			end
		},
		pre_spawn_unit_func = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
			-- function 115
			local str = "fx/blk_grey_wings_spawn_01"
			local var_115_1 = NetworkLookup.effects[str]
			local num = 0
			local identity = Quaternion.identity()

			Managers.state.network:rpc_play_particle_effect(nil, var_115_1, NetworkConstants.invalid_game_object_id, num, arg_115_2:unbox(), identity, false)
		end
	}
end

GenericTerrorEvents.grey_wings_plague_monks = {
	fn_7({
		default = {
			"skaven_plague_monk",
			"skaven_plague_monk",
			"skaven_plague_monk"
		}
	}),
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 116
			return self.grey_wings_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 117
			return self.grey_wings_enemies <= 0
		end
	}
}
GenericTerrorEvents.grey_wings_berserkers = {
	fn_7({
		default = {
			"chaos_berzerker",
			"chaos_berzerker",
			"chaos_berzerker"
		}
	}),
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 118
			return self.grey_wings_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 119
			return self.grey_wings_enemies <= 0
		end
	}
}
GenericTerrorEvents.grey_wings_bestigors = {
	fn_7({
		default = {
			"beastmen_bestigor",
			"beastmen_bestigor",
			"beastmen_bestigor"
		}
	}),
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 120
			return self.grey_wings_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 121
			return self.grey_wings_enemies <= 0
		end
	}
}
GenericTerrorEvents.grey_wings_spawns = {
	{
		"inject_event",
		event_name_list = {
			"grey_wings_plague_monks"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"grey_wings_plague_monks"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	}
}

local function fn_8(arg_122_0, arg_122_1, arg_122_2)
	-- function 122
	if not (arg_122_1.special or arg_122_1.boss or arg_122_1.cannot_be_aggroed) then
		local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(arg_122_0, get_random_alive_hero)
	end

	local str = "fx/grudge_marks_shadow_step"
	local var_122_2 = NetworkLookup.effects[str]
	local num = 0

	Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_122_2, NetworkConstants.invalid_game_object_id, num, POSITION_LOOKUP[arg_122_0], false)

	local var_122_4 = BLACKBOARDS[arg_122_0]

	if not var_122_4 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_122_0)

		local forward = Quaternion.forward(Quaternion.axis_angle(Vector3.up(), math.pi * 2 * math.random()))
		local num_2 = 0.5
		local medium = scripts_utils_stagger_types.medium
		local num_3 = 0.5
		local time = Managers.time:time("game")

		AiUtils.stagger(arg_122_0, var_122_4, arg_122_0, forward, num_2, medium, num_3, nil, time)
	end
end

local tbl_5 = {
	"spawn_around_origin_unit_staggered",
	max_distance = 5,
	spawn_counter_category = "grudge_mark_commander_enemies",
	min_distance = 2,
	optional_data = {
		prevent_killed_enemy_dialogue = true,
		spawned_func = fn_8
	},
	staggered_spawn_batch_size = {
		1,
		2
	},
	staggered_spawn_delay = {
		0.25,
		0.5
	}
}

GenericTerrorEvents.grudge_mark_commander_terror_event_skaven_storm = {
	table.merge({
		breed_name = "skaven_storm_vermin_commander",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 2
		}
	}, tbl_5),
	table.merge({
		breed_name = "skaven_clan_rat",
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 2
		}
	}, tbl_5)
}
GenericTerrorEvents.grudge_mark_commander_terror_event_skaven_storm_shield = {
	table.merge({
		breed_name = "skaven_storm_vermin_with_shield",
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	}, tbl_5),
	table.merge({
		breed_name = "skaven_clan_rat_with_shield",
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 3,
			cataclysm = 3,
			normal = 2
		}
	}, tbl_5)
}
GenericTerrorEvents.grudge_mark_commander_terror_event_skaven = {
	{
		"inject_event",
		weighted_event_names = {
			{
				weight = 3,
				event_name = "grudge_mark_commander_terror_event_skaven_storm"
			},
			{
				weight = 3,
				event_name = "grudge_mark_commander_terror_event_skaven_storm_shield"
			}
		}
	}
}
GenericTerrorEvents.grudge_mark_commander_terror_event_chaos_raiders = {
	table.merge({
		breed_name = "chaos_raider",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 1
		}
	}, tbl_5),
	table.merge({
		breed_name = "chaos_marauder",
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 2
		}
	}, tbl_5)
}
GenericTerrorEvents.grudge_mark_commander_terror_event_chaos_warriors = {
	table.merge({
		breed_name = "chaos_warrior",
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 1,
			normal = 1
		}
	}, tbl_5),
	table.merge({
		breed_name = "chaos_marauder",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 4,
			normal = 2
		}
	}, tbl_5)
}
GenericTerrorEvents.grudge_mark_commander_terror_event_chaos = {
	{
		"inject_event",
		weighted_event_names = {
			{
				weight = 3,
				event_name = "grudge_mark_commander_terror_event_chaos_raiders"
			},
			{
				weight = 3,
				event_name = "grudge_mark_commander_terror_event_chaos_warriors"
			}
		}
	}
}
GenericTerrorEvents.grudge_mark_commander_terror_event_beastmen_bestigors = {
	table.merge({
		breed_name = "beastmen_bestigor",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 1
		}
	}, tbl_5)
}
GenericTerrorEvents.grudge_mark_commander_terror_event_beastmen_double_action = {
	table.merge({
		breed_name = "beastmen_bestigor",
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 2,
			cataclysm = 2,
			normal = 1
		}
	}, tbl_5),
	table.merge({
		breed_name = "beastmen_gor",
		difficulty_amount = {
			hardest = 3,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		}
	}, tbl_5)
}
GenericTerrorEvents.grudge_mark_commander_terror_event_beastmen = {
	{
		"inject_event",
		weighted_event_names = {
			{
				weight = 3,
				event_name = "grudge_mark_commander_terror_event_beastmen_bestigors"
			},
			{
				weight = 3,
				event_name = "grudge_mark_commander_terror_event_beastmen_double_action"
			}
		}
	}
}
GenericTerrorEvents.deus_generic_terror_event_with_interception_and_escape = {
	{
		"inject_event",
		event_name = "deus_generic_terror_event_start"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_with_interception_sequence"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_end"
	},
	{
		"activate_mutator",
		name = "escape"
	}
}
GenericTerrorEvents.deus_generic_terror_event = {
	{
		"inject_event",
		event_name = "deus_generic_terror_event_start"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_sequence"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_end"
	}
}
GenericTerrorEvents.deus_generic_terror_event_small = {
	{
		"inject_event",
		event_name = "deus_generic_terror_event_start_no_wwise"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_sequence_small"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_end"
	}
}
GenericTerrorEvents.deus_generic_terror_event_long = {
	{
		"inject_event",
		event_name = "deus_generic_terror_event_start"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_sequence_long"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_end"
	}
}
GenericTerrorEvents.deus_generic_terror_event_with_door = {
	{
		"inject_event",
		event_name = "deus_generic_terror_event_start"
	},
	{
		"flow_event",
		flow_event_name = "deus_generic_terror_event_close_door"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_sequence"
	},
	{
		"flow_event",
		flow_event_name = "deus_generic_terror_event_open_door"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_end"
	}
}
GenericTerrorEvents.deus_generic_terror_event_with_interception = {
	{
		"inject_event",
		event_name = "deus_generic_terror_event_start"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_with_interception_sequence"
	},
	{
		"inject_event",
		event_name = "deus_generic_terror_event_end"
	}
}
GenericTerrorEvents.deus_generic_terror_event_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_stinger_and_sequence",
			"deus_chaos_stinger_and_sequence",
			"deus_chaos_stinger_and_sequence"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_stinger_and_sequence",
			"deus_beastmen_stinger_and_sequence",
			"deus_beastmen_stinger_and_sequence"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_stinger_and_sequence",
			"deus_beastmen_stinger_and_sequence"
		},
		faction_requirement_list = {
			"chaos",
			"beastmen"
		}
	}
}
GenericTerrorEvents.deus_generic_terror_event_sequence_small = {
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_stinger_and_sequence_small",
			"deus_chaos_stinger_and_sequence_small",
			"deus_chaos_stinger_and_sequence_small"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_stinger_and_sequence_small",
			"deus_beastmen_stinger_and_sequence_small",
			"deus_beastmen_stinger_and_sequence_small"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_stinger_and_sequence_small",
			"deus_beastmen_stinger_and_sequence_small"
		},
		faction_requirement_list = {
			"chaos",
			"beastmen"
		}
	}
}
GenericTerrorEvents.deus_generic_terror_event_sequence_long = {
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_stinger_and_sequence_long",
			"deus_chaos_stinger_and_sequence_long",
			"deus_chaos_stinger_and_sequence_long"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_stinger_and_sequence_long",
			"deus_beastmen_stinger_and_sequence_long",
			"deus_beastmen_stinger_and_sequence_long"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_stinger_and_sequence_long",
			"deus_beastmen_stinger_and_sequence_long"
		},
		faction_requirement_list = {
			"chaos",
			"beastmen"
		}
	}
}
GenericTerrorEvents.deus_generic_terror_event_with_interception_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_generic_terror_event_skaven_with_interception_sequence",
			"deus_generic_terror_event_chaos_with_interception_sequence",
			"deus_generic_terror_event_chaos_with_interception_sequence"
		},
		faction_requirement_list = {
			"skaven",
			"chaos"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_generic_terror_event_skaven_with_interception_sequence",
			"deus_generic_terror_event_beastmen_with_interception_sequence",
			"deus_generic_terror_event_beastmen_with_interception_sequence"
		},
		faction_requirement_list = {
			"skaven",
			"beastmen"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_generic_terror_event_chaos_with_interception_sequence",
			"deus_generic_terror_event_beastmen_with_interception_sequence"
		},
		faction_requirement_list = {
			"chaos",
			"beastmen"
		}
	}
}
GenericTerrorEvents.deus_generic_terror_event_skaven_with_interception_sequence = {
	{
		"inject_event",
		event_name = "deus_skaven_interception_sequence"
	},
	{
		"inject_event",
		event_name = "deus_skaven_sequence"
	}
}
GenericTerrorEvents.deus_generic_terror_event_chaos_with_interception_sequence = {
	{
		"inject_event",
		event_name = "deus_chaos_interception_sequence"
	},
	{
		"inject_event",
		event_name = "deus_chaos_sequence"
	}
}
GenericTerrorEvents.deus_generic_terror_event_beastmen_with_interception_sequence = {
	{
		"inject_event",
		event_name = "deus_beastmen_interception_sequence"
	},
	{
		"inject_event",
		event_name = "deus_skaven_sequence"
	}
}
GenericTerrorEvents.deus_generic_terror_event_start = {
	{
		"set_master_event_running",
		name = "deus_generic_terror_event"
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
		"freeze_story_trigger",
		freeze = true
	},
	{
		"set_wwise_override_state",
		name = "terror_mb1"
	}
}
GenericTerrorEvents.deus_generic_terror_event_start_no_wwise = {
	{
		"set_master_event_running",
		name = "deus_generic_terror_event"
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
		"freeze_story_trigger",
		freeze = true
	},
	{
		"set_freeze_condition",
		max_active_enemies = 100
	}
}
GenericTerrorEvents.deus_generic_terror_event_end = {
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 123
			return not (self.boss <= 0) or not (self.main <= 0) or self.elite <= 0
		end
	},
	{
		"flow_event",
		flow_event_name = "deus_generic_terror_event_done"
	},
	{
		"flow_event",
		flow_event_name = "deus_generic_terror_event_done2"
	},
	{
		"control_pacing",
		enable = true
	},
	{
		"control_specials",
		enable = true
	},
	{
		"set_wwise_override_state",
		name = "false"
	},
	{
		"disable_bots_in_carry_event"
	},
	{
		"freeze_story_trigger",
		freeze = false
	}
}
GenericTerrorEvents.deus_generic_terror_event_escape = {
	{
		"activate_mutator",
		name = "escape"
	}
}
GenericTerrorEvents.deus_skaven_stinger_and_sequence = {
	{
		"inject_event",
		event_name = "deus_skaven_stinger"
	},
	{
		"inject_event",
		event_name = "deus_skaven_sequence"
	}
}
GenericTerrorEvents.deus_chaos_stinger_and_sequence = {
	{
		"inject_event",
		event_name = "deus_chaos_stinger"
	},
	{
		"inject_event",
		event_name = "deus_chaos_sequence"
	}
}
GenericTerrorEvents.deus_beastmen_stinger_and_sequence = {
	{
		"inject_event",
		event_name = "deus_beastmen_stinger"
	},
	{
		"inject_event",
		event_name = "deus_beastmen_sequence"
	}
}
GenericTerrorEvents.deus_skaven_stinger_and_sequence_small = {
	{
		"inject_event",
		event_name = "deus_skaven_stinger"
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	}
}
GenericTerrorEvents.deus_chaos_stinger_and_sequence_small = {
	{
		"inject_event",
		event_name = "deus_chaos_stinger"
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	}
}
GenericTerrorEvents.deus_beastmen_stinger_and_sequence_small = {
	{
		"inject_event",
		event_name = "deus_beastmen_stinger"
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	}
}
GenericTerrorEvents.deus_skaven_stinger_and_sequence_long = {
	{
		"inject_event",
		event_name = "deus_skaven_stinger"
	},
	{
		"inject_event",
		event_name = "deus_skaven_sequence"
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	}
}
GenericTerrorEvents.deus_chaos_stinger_and_sequence_long = {
	{
		"inject_event",
		event_name = "deus_chaos_stinger"
	},
	{
		"inject_event",
		event_name = "deus_chaos_sequence"
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	}
}
GenericTerrorEvents.deus_beastmen_stinger_and_sequence_long = {
	{
		"inject_event",
		event_name = "deus_beastmen_stinger"
	},
	{
		"inject_event",
		event_name = "deus_beastmen_sequence"
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	}
}
GenericTerrorEvents.deus_skaven_interception_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_interception_wave_a",
			"deus_skaven_interception_wave_b",
			"deus_skaven_interception_wave_c"
		}
	}
}
GenericTerrorEvents.deus_chaos_interception_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_interception_wave_a",
			"deus_chaos_interception_wave_b",
			"deus_chaos_interception_wave_c"
		}
	}
}
GenericTerrorEvents.deus_beastmen_interception_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_interception_wave_a",
			"deus_beastmen_interception_wave_b",
			"deus_beastmen_interception_wave_c"
		}
	}
}
GenericTerrorEvents.deus_skaven_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_skaven_wave_1a",
			"deus_skaven_wave_1b",
			"deus_skaven_wave_1c",
			"deus_skaven_wave_1d"
		}
	},
	{
		"one_of",
		{
			{
				"inject_event",
				event_name_list = {
					"deus_skaven_wave_2a",
					"deus_skaven_wave_2b",
					"deus_skaven_wave_2e"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_MONSTERS
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_skaven_wave_2c",
					"deus_skaven_wave_2d",
					"deus_skaven_wave_2f"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_skaven_wave_2c",
					"deus_skaven_wave_2d",
					"deus_skaven_wave_2f"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_ELITES
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_skaven_wave_2a",
					"deus_skaven_wave_2b",
					"deus_skaven_wave_2c",
					"deus_skaven_wave_2d",
					"deus_skaven_wave_2e",
					"deus_skaven_wave_2f"
				}
			}
		}
	}
}
GenericTerrorEvents.deus_chaos_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_chaos_wave_1a",
			"deus_chaos_wave_1b",
			"deus_chaos_wave_1c",
			"deus_chaos_wave_1d"
		}
	},
	{
		"one_of",
		{
			{
				"inject_event",
				event_name_list = {
					"deus_chaos_wave_2a",
					"deus_chaos_wave_2c"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_MONSTERS
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_chaos_wave_2c",
					"deus_chaos_wave_2d"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_chaos_wave_2b",
					"deus_chaos_wave_2d"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_ELITES
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_chaos_wave_2a",
					"deus_chaos_wave_2b",
					"deus_chaos_wave_2c",
					"deus_chaos_wave_2d"
				}
			}
		}
	}
}
GenericTerrorEvents.deus_beastmen_sequence = {
	{
		"inject_event",
		event_name_list = {
			"deus_beastmen_wave_1a",
			"deus_beastmen_wave_1b",
			"deus_beastmen_wave_1c",
			"deus_beastmen_wave_1d"
		}
	},
	{
		"one_of",
		{
			{
				"inject_event",
				event_name_list = {
					"deus_beastmen_wave_2a",
					"deus_beastmen_wave_2b"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_MONSTERS
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_beastmen_wave_2a",
					"deus_beastmen_wave_2c"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_SPECIALS
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_beastmen_wave_2c"
				},
				tag_requirement_list = {
					DeusTerrorEventTags.MORE_ELITES
				}
			},
			{
				"inject_event",
				event_name_list = {
					"deus_beastmen_wave_2a",
					"deus_beastmen_wave_2b",
					"deus_beastmen_wave_2c"
				}
			}
		}
	}
}
GenericTerrorEvents.deus_skaven_stinger = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_stinger"
	}
}
GenericTerrorEvents.deus_chaos_stinger = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_chaos_stinger"
	}
}
GenericTerrorEvents.deus_beastmen_stinger = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_beastmen_stinger"
	}
}
GenericTerrorEvents.deus_skaven_wave_1a = {
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 124
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 125
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 126
			return self.boss <= 0
		end,
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 127
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 128
			return self.main < 15
		end
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_pack_master",
			"skaven_gutter_runner"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 129
			return self.boss <= 0
		end,
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 130
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_pack_master",
			"skaven_gutter_runner"
		},
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 131
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 132
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_1b = {
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 133
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 134
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 135
			return self.boss <= 0
		end,
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 136
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "event_extra_spice_medium",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 137
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 100,
		condition = function (self)
			-- function 138
			return self.main < 30
		end
	},
	{
		"spawn_at_raw",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_gutter_runner",
			"skaven_poison_wind_globadier",
			"skaven_pack_master",
			"skaven_ratling_gunner"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 139
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 100,
		condition = function (self)
			-- function 140
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_1c = {
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 141
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 142
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 143
			return self.boss <= 0
		end,
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 144
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 145
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "plague_monks_medium",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 146
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_gutter_runner"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 147
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "plague_monks_medium",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 148
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_1d = {
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 149
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 150
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 151
			return self.boss <= 0
		end,
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 152
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 153
			return self.main < 15
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "event_large"
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 154
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_1a = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 155
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 156
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 157
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 158
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 159
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_chaos_extra_spice_medium",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 160
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 161
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 162
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_1b = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 163
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 164
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 165
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 166
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 167
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_chaos_shields_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 168
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "chaos_warriors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 169
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 170
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 171
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_1c = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 172
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 173
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 174
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 175
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 176
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "event_small_fanatics"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "event_small_fanatics"
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 177
			return self.boss <= 0
		end,
		duration = num_7
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "event_small_fanatics"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "event_small_fanatics"
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 178
			return self.boss <= 0
		end,
		duration = num_7
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "event_small_fanatics"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "event_small_fanatics"
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 179
			return self.boss <= 0
		end,
		duration = num_7
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "event_small_fanatics"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "event_small_fanatics"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 180
			return self.boss <= 0
		end,
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 181
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_1d = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 182
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 183
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 184
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 185
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 186
			return self.main < 15
		end
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 187
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 188
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 189
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 190
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 191
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_1a = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 192
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 193
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 194
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 195
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 196
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 197
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "bestigors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 198
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "ungor_archers",
		limit_spawners = 1,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 199
			return self.boss <= 0
		end,
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 200
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_1b = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 201
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 202
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 203
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 204
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 205
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 206
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "bestigors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 207
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "ungor_archers",
		limit_spawners = 1,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 208
			return self.boss <= 0
		end,
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 209
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_1c = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 210
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 211
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 212
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 213
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 214
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 215
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = "beastmen_standard_bearer"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 216
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = "beastmen_standard_bearer"
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "bestigors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 217
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 218
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 219
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_1d = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 220
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 221
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 222
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 223
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 224
			return self.main < 15
		end
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 225
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 226
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 227
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 228
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 229
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_2a = {
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
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 230
			return self.main < 10
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 231
			return self.boss > 0
		end
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 232
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 233
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		breed_name = {
			"skaven_gutter_runner",
			"skaven_pack_master"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 234
			return self.boss <= 0
		end,
		duration = num_6
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 235
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 236
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 237
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_2b = {
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
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 238
			return self.main < 4
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 239
			return self.boss > 0
		end
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 240
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_ratling_gunner"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 241
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 242
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_ratling_gunner"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 243
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 244
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_2c = {
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
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 245
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "elite",
		composition_type = "morris_storm_vermin_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		breed_name = {
			"skaven_gutter_runner",
			"skaven_pack_master"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 246
			return self.elite < 5
		end
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "morris_storm_vermin_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 247
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_2d = {
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
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_ratling_gunner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 4,
			hard = 2,
			harder = 3,
			cataclysm = 5,
			normal = 2
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 248
			return self.special < 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 249
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "morris_storm_vermin_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_ratling_gunner"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 250
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_2e = {
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
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 251
			return self.main < 10
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 252
			return self.boss > 0
		end
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
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 253
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		limit_spawners = 1,
		spawner_id = "terror_event_a",
		composition_type = "morris_plague_monk_medium"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 254
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 255
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 256
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_wave_2f = {
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
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "event_small",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 257
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "morris_storm_vermin_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 258
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_plague_monk_medium",
		limit_spawners = 1,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 259
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "elite",
		spawner_id = "terror_event_a",
		composition_type = "storm_vermin_shields_medium"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_ratling_gunner",
			"skaven_gutter_runner",
			"skaven_pack_master"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 260
			return not (self.main < 10) or self.elite < 5
		end
	},
	{
		"event_horde",
		minimum_difficulty_tweak = 0,
		spawn_counter_category = "elite",
		spawner_id = "terror_event_b",
		composition_type = "storm_vermin_shields_medium"
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"spawn_at_raw",
		minimum_difficulty_tweak = 0,
		spawner_id = "terror_event_special_b",
		breed_name = {
			"skaven_warpfire_thrower",
			"skaven_poison_wind_globadier",
			"skaven_ratling_gunner",
			"skaven_gutter_runner",
			"skaven_pack_master"
		},
		difficulty_amount = {
			hardest = 3,
			hard = 1,
			harder = 2,
			cataclysm = 4,
			normal = 1
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 261
			return not (self.main < 10) or self.elite < 5
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_2a = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 262
			return self.main < 10
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		spawner_id = "terror_event_monster",
		breed_name = {
			"chaos_troll",
			"chaos_spawn"
		}
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 263
			return self.boss > 0
		end
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 264
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 265
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 266
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 267
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_2b = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 268
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "event_chaos_extra_spice_medium",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 1,
		spawn_counter_category = "main",
		composition_type = "chaos_raiders_medium",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 269
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		minimum_difficulty_tweak = 0,
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 270
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_chaos_shields_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "chaos_warriors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		minimum_difficulty_tweak = 0,
		composition_type = "chaos_warriors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 271
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_2c = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 272
			return self.main < 10
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		spawner_id = "terror_event_monster",
		breed_name = {
			"chaos_troll",
			"chaos_spawn"
		}
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 273
			return self.boss > 0
		end
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 274
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 275
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 276
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 277
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 278
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 279
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 280
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_chaos_wave_2d = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 281
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "elite",
		limit_spawners = 1,
		spawner_id = "terror_event_a",
		composition_type = "chaos_raiders_medium"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		limit_spawners = 2,
		spawner_id = "terror_event_a",
		composition_type = "morris_small_chaos"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		limit_spawners = 2,
		spawner_id = "terror_event_a",
		composition_type = "morris_small_chaos"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 282
			return self.elite < 3
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "chaos_raiders_medium",
		limit_spawners = 1,
		minimum_difficulty_tweak = 0
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "morris_small_chaos",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 283
			return self.main < 10
		end
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_chaos_shields_large",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "elite",
		minimum_difficulty_tweak = 0,
		composition_type = "chaos_warriors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 284
			return self.elite <= 2
		end
	},
	{
		"event_horde",
		spawn_counter_category = "elite",
		composition_type = "chaos_warriors",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		}
	},
	{
		"delay",
		duration = num_6,
		difficulty_requirement = num_3
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_amount = {
			hardest = 1,
			hard = 1,
			harder = 1,
			cataclysm = 2,
			normal = 1
		},
		difficulty_requirement = num_3
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function (self)
			-- function 285
			return self.elite <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 286
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_2a = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 287
			return self.main < 10
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		breed_name = "beastmen_minotaur",
		spawner_id = "terror_event_monster"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 288
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 289
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = "beastmen_standard_bearer"
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		limit_spawners = 2,
		spawner_id = "terror_event_a",
		composition_type = "morris_small_beastmen"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 290
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 291
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_2b = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "boss",
		breed_name = "beastmen_minotaur",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function (self)
			-- function 292
			return self.boss > 0
		end
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 293
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 294
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 295
			return self.main < 10
		end
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 296
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function (self)
			-- function 297
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function (self)
			-- function 298
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "end_event_crater_small"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 299
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 300
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_beastmen_wave_2c = {
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = -5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = -5,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 5,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 5,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 301
			return self.main < 10
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 302
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "ungor_archers"
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"event_horde",
		spawn_counter_category = "elite",
		spawner_id = "terror_event_a",
		composition_type = "bestigors"
	},
	{
		"continue_when_spawned_count",
		s,
		duration = 120,
		condition = function (self)
			-- function 303
			return self.elite > 0
		end
	},
	{
		"continue_when_spawned_count",
		s,
		duration = 120,
		condition = function (self)
			-- function 304
			return self.elite <= 1
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 305
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"event_horde",
		limit_spawners = 2,
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		composition_type = "morris_small_beastmen",
		limit_spawners = 2,
		minimum_difficulty_tweak = 0,
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function (self)
			-- function 306
			return self.boss <= 0
		end,
		duration = num_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = "beastmen_standard_bearer"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "bestigors"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"spawn_at_raw",
		breed_name = "beastmen_standard_bearer",
		spawner_id = "terror_event_special_b",
		minimum_difficulty_tweak = 0
	},
	{
		"delay",
		minimum_difficulty_tweak = 0,
		duration = num_6
	},
	{
		"event_horde",
		minimum_difficulty_tweak = 0,
		spawn_counter_category = "main",
		spawner_id = "terror_event_b",
		composition_type = "bestigors"
	},
	{
		"delay",
		duration = num_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function (self)
			-- function 307
			return self.main < 10
		end
	}
}
GenericTerrorEvents.deus_skaven_interception_wave_a = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "event_medium"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_skaven_interception_wave_b = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "event_small"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "plague_monks_small"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_skaven_interception_wave_c = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "event_extra_spice_medium"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_chaos_interception_wave_a = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_chaos_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "event_medium_chaos"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_chaos_interception_wave_b = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_chaos_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "chaos_berzerkers_medium"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "morris_small_chaos"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_chaos_interception_wave_c = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_chaos_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "chaos_shields"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "morris_small_chaos"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_beastmen_interception_wave_a = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_beastmen_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "event_medium_beastmen"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_beastmen_interception_wave_b = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_beastmen_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "morris_small_beastmen"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "bestigors"
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_beastmen_interception_wave_c = {
	{
		"play_stinger",
		stinger_name = "enemy_horde_beastmen_stinger"
	},
	{
		"event_horde",
		spawner_id = "terror_event_interception",
		composition_type = "morris_small_beastmen"
	},
	{
		"event_horde",
		composition_type = "ungor_archers",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_6
	}
}
GenericTerrorEvents.deus_TEST_ALL_BREED = {
	{
		"control_pacing",
		enable = false
	},
	{
		"control_specials",
		enable = false
	},
	{
		"inject_event",
		event_name = "deus_TEST_skaven"
	},
	{
		"inject_event",
		event_name = "deus_TEST_chaos"
	},
	{
		"inject_event",
		event_name = "deus_TEST_beastmen"
	},
	{
		"inject_event",
		event_name = "deus_TEST_special"
	},
	{
		"inject_event",
		event_name = "deus_TEST_monster"
	},
	{
		"control_pacing",
		enable = true
	},
	{
		"control_specials",
		enable = true
	}
}
GenericTerrorEvents.deus_TEST_monster_and_special = {
	{
		"control_pacing",
		enable = false
	},
	{
		"control_specials",
		enable = false
	},
	{
		"inject_event",
		event_name = "deus_TEST_monster"
	},
	{
		"inject_event",
		event_name = "deus_TEST_special"
	},
	{
		"control_pacing",
		enable = true
	},
	{
		"control_specials",
		enable = true
	}
}
GenericTerrorEvents.deus_TEST_roamers = {
	{
		"control_pacing",
		enable = false
	},
	{
		"control_specials",
		enable = false
	},
	{
		"inject_event",
		event_name = "deus_TEST_skaven"
	},
	{
		"inject_event",
		event_name = "deus_TEST_chaos"
	},
	{
		"inject_event",
		event_name = "deus_TEST_beastmen"
	},
	{
		"control_pacing",
		enable = true
	},
	{
		"control_specials",
		enable = true
	}
}
GenericTerrorEvents.deus_TEST_small_skaven_encounter = {
	{
		"event_horde",
		spawn_counter_category = "skaven_slave",
		composition_type = "morris_TEST_small_skaven_encounter",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 308
			return self.skaven_slave <= 0
		end
	}
}
GenericTerrorEvents.deus_TEST_skaven = {
	{
		"event_horde",
		spawn_counter_category = "skaven_slave",
		composition_type = "morris_TEST_skaven_slave",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 309
			return self.skaven_slave <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_clan_rat",
		composition_type = "morris_TEST_skaven_clan_rat",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 310
			return self.skaven_clan_rat <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_clan_rat_with_shield",
		composition_type = "morris_TEST_skaven_clan_rat_with_shield",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 311
			return self.skaven_clan_rat_with_shield <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_plague_monk",
		composition_type = "morris_TEST_skaven_plague_monk",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 312
			return self.skaven_plague_monk <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_storm_vermin",
		composition_type = "morris_TEST_skaven_storm_vermin",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 313
			return self.skaven_storm_vermin <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_storm_vermin_commander",
		composition_type = "morris_TEST_skaven_storm_vermin_commander",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 314
			return self.skaven_storm_vermin_commander <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_storm_vermin_with_shield",
		composition_type = "morris_TEST_skaven_storm_vermin_with_shield",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 315
			return self.skaven_storm_vermin_with_shield <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "skaven_explosive_loot_rat",
		composition_type = "morris_TEST_skaven_explosive_loot_rat",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 316
			return self.skaven_explosive_loot_rat <= 0
		end
	}
}
GenericTerrorEvents.deus_TEST_chaos = {
	{
		"event_horde",
		spawn_counter_category = "chaos_fanatic",
		composition_type = "morris_TEST_chaos_fanatic",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 317
			return self.chaos_fanatic <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "chaos_marauder",
		composition_type = "morris_TEST_chaos_marauder",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 318
			return self.chaos_marauder <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "chaos_marauder_with_shield",
		composition_type = "morris_TEST_chaos_marauder_with_shield",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 319
			return self.chaos_marauder_with_shield <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "chaos_berzerker",
		composition_type = "morris_TEST_chaos_berzerker",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 320
			return self.chaos_berzerker <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "chaos_raider",
		composition_type = "morris_TEST_chaos_raider",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 321
			return self.chaos_raider <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "chaos_warrior",
		composition_type = "morris_TEST_chaos_warrior",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 322
			return self.chaos_warrior <= 0
		end
	}
}
GenericTerrorEvents.deus_TEST_beastmen = {
	{
		"event_horde",
		spawn_counter_category = "beastmen_ungor",
		composition_type = "morris_TEST_beastmen_ungor",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 323
			return self.beastmen_ungor <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "beastmen_gor",
		composition_type = "morris_TEST_beastmen_gor",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 324
			return self.beastmen_gor <= 0
		end
	},
	{
		"event_horde",
		spawn_counter_category = "beastmen_bestigor",
		composition_type = "morris_TEST_beastmen_bestigor",
		spawner_ids = {
			"terror_event_a",
			"terror_event_b"
		}
	},
	{
		"delay",
		duration = num_7
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 325
			return self.beastmen_bestigor <= 0
		end
	}
}
GenericTerrorEvents.deus_TEST_special = {
	{
		"spawn_at_raw",
		breed_name = "skaven_gutter_runner",
		spawn_counter_category = "skaven_gutter_runner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 326
			return self.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 327
			return self.skaven_gutter_runner <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_gutter_runner",
		spawn_counter_category = "skaven_gutter_runner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 328
			return self.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 329
			return self.skaven_gutter_runner <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_gutter_runner",
		spawn_counter_category = "skaven_gutter_runner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 330
			return self.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 331
			return self.skaven_gutter_runner <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_gutter_runner",
		spawn_counter_category = "skaven_gutter_runner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 332
			return self.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 333
			return self.skaven_gutter_runner <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_gutter_runner",
		spawn_counter_category = "skaven_gutter_runner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 334
			return self.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 335
			return self.skaven_gutter_runner <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_warpfire_thrower",
		spawn_counter_category = "skaven_warpfire_thrower",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 10,
			hard = 10,
			harder = 10,
			cataclysm = 10,
			normal = 10
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 336
			return self.skaven_warpfire_thrower > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 337
			return self.skaven_warpfire_thrower <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_poison_wind_globadier",
		spawn_counter_category = "skaven_poison_wind_globadier",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 10,
			hard = 10,
			harder = 10,
			cataclysm = 10,
			normal = 10
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 338
			return self.skaven_poison_wind_globadier > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 339
			return self.skaven_poison_wind_globadier <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "skaven_ratling_gunner",
		spawn_counter_category = "skaven_ratling_gunner",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 10,
			hard = 10,
			harder = 10,
			cataclysm = 10,
			normal = 10
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 340
			return self.skaven_ratling_gunner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 341
			return self.skaven_ratling_gunner <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "chaos_corruptor_sorcerer",
		spawn_counter_category = "chaos_corruptor_sorcerer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 342
			return self.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 343
			return self.chaos_corruptor_sorcerer <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "chaos_corruptor_sorcerer",
		spawn_counter_category = "chaos_corruptor_sorcerer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 344
			return self.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 345
			return self.chaos_corruptor_sorcerer <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "chaos_corruptor_sorcerer",
		spawn_counter_category = "chaos_corruptor_sorcerer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 346
			return self.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 347
			return self.chaos_corruptor_sorcerer <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "chaos_corruptor_sorcerer",
		spawn_counter_category = "chaos_corruptor_sorcerer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 348
			return self.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 349
			return self.chaos_corruptor_sorcerer <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "chaos_corruptor_sorcerer",
		spawn_counter_category = "chaos_corruptor_sorcerer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 2,
			normal = 2
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 350
			return self.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 351
			return self.chaos_corruptor_sorcerer <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "chaos_vortex_sorcerer",
		spawn_counter_category = "chaos_vortex_sorcerer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 10,
			hard = 10,
			harder = 10,
			cataclysm = 10,
			normal = 10
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 352
			return self.chaos_vortex_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 353
			return self.chaos_vortex_sorcerer <= 0
		end
	},
	{
		"spawn_at_raw",
		breed_name = "beastmen_standard_bearer",
		spawn_counter_category = "beastmen_standard_bearer",
		spawner_ids = {
			"terror_event_special_a",
			"terror_event_special_b"
		},
		difficulty_amount = {
			hardest = 10,
			hard = 10,
			harder = 10,
			cataclysm = 10,
			normal = 10
		}
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 354
			return self.beastmen_standard_bearer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 355
			return self.beastmen_standard_bearer <= 0
		end
	}
}
GenericTerrorEvents.deus_TEST_monster = {
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 356
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 357
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 358
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 359
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 360
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 361
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 362
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 363
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 364
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 365
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 366
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 367
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 368
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 369
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 370
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 371
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 372
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 373
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_rat_ogre",
		breed_name = "skaven_rat_ogre",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 374
			return self.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 375
			return self.skaven_rat_ogre <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 376
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 377
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 378
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 379
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 380
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 381
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 382
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 383
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 384
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 385
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 386
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 387
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 388
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 389
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 390
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 391
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 392
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 393
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "skaven_stormfiend",
		breed_name = "skaven_stormfiend",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 394
			return self.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 395
			return self.skaven_stormfiend <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 396
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 397
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 398
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 399
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 400
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 401
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 402
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 403
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 404
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 405
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 406
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 407
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 408
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 409
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 410
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 411
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 412
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 413
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_troll",
		breed_name = "chaos_troll",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 414
			return self.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 415
			return self.chaos_troll <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 416
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 417
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 418
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 419
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 420
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 421
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 422
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 423
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 424
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 425
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 426
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 427
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 428
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 429
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 430
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 431
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 432
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 433
			return self.chaos_spawn <= 0
		end
	},
	{
		"spawn_at_raw",
		spawn_counter_category = "chaos_spawn",
		breed_name = "chaos_spawn",
		spawner_id = "terror_event_monster"
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 434
			return self.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function (self)
			-- function 435
			return self.chaos_spawn <= 0
		end
	}
}
