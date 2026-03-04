-- chunkname: @scripts/settings/dlcs/morris/deus_generic_terror_events.lua

require("scripts/settings/dlcs/morris/deus_terror_event_tags")

local var_0_0 = require("scripts/utils/stagger_types")
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = 4
local var_0_4 = 5
local var_0_5 = 6
local var_0_6 = 8
local var_0_7 = 16
local var_0_8
local var_0_9 = TerrorEventUtils.add_enhancements_for_difficulty

local function var_0_10(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_1.special and not arg_1_1.boss and not arg_1_1.cannot_be_aggroed then
		local var_1_0 = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(arg_1_0, var_1_0)
	end

	Managers.state.entity:system("buff_system"):add_buff(arg_1_0, "cursed_chest_objective_unit", arg_1_0)

	if BLACKBOARDS[arg_1_0] then
		local var_1_1 = "Play_normal_spawn_stinger"

		if arg_1_1.special or arg_1_1.boss then
			var_1_1 = "Play_special_spawn_stinger"
		end

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_1_1, arg_1_0)
	end
end

local function var_0_11(arg_2_0, arg_2_1, arg_2_2)
	Managers.state.entity:system("buff_system"):add_buff(arg_2_0, "objective_unit", arg_2_0)
	var_0_10(arg_2_0, arg_2_1, arg_2_2)
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

local var_0_12 = 2
local var_0_13 = 4
local var_0_14 = 4
local var_0_15 = 8
local var_0_16 = 15
local var_0_17 = 20
local var_0_18 = 5
local var_0_19 = 7
local var_0_20 = 9
local var_0_21 = {
	default = 1,
	special = 1.2,
	elite = 1.2,
	boss = 2
}
local var_0_22 = "units/decals/deus_decal_aoe_cursedchest_01"

local function var_0_23(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.decal_map or {}

	arg_3_0.decal_map = var_3_0

	local var_3_1 = Breeds[arg_3_3]
	local var_3_2

	if var_3_1.boss then
		var_3_2 = var_0_21.boss
	elseif var_3_1.special then
		var_3_2 = var_0_21.special
	elseif var_3_1.elite then
		var_3_2 = var_0_21.elite
	else
		var_3_2 = var_0_21.default
	end

	local var_3_3 = arg_3_2:unbox()
	local var_3_4
	local var_3_5
	local var_3_6 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_3_3)
	local var_3_7 = var_3_2

	Matrix4x4.set_scale(var_3_6, Vector3(var_3_7, var_3_7, var_3_7))

	local var_3_8

	var_3_0[arg_3_2], var_3_8 = Managers.state.unit_spawner:spawn_network_unit(var_0_22, "network_synched_dummy_unit", nil, var_3_6)
end

local function var_0_24(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.decal_map
	local var_4_1 = var_4_0 and var_4_0[arg_4_2]

	if var_4_1 then
		Unit.flow_event(var_4_1, "despawned")

		local var_4_2 = Managers.state.unit_storage:go_id(var_4_1)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_event", var_4_2, NetworkLookup.flow_events.despawned)

		var_4_0[arg_4_2] = nil
	end
end

local var_0_25 = 2.5
local var_0_26 = 3.5
local var_0_27 = 1
local var_0_28 = 1
local var_0_29 = 1
local var_0_30 = 0.5
local var_0_31 = 8
local var_0_32 = 64
local var_0_33 = 192
local var_0_34 = {
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_5_0)
			return arg_5_0.cursed_chest_enemies <= 4
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_6_0)
			return arg_6_0.cursed_chest_enemies <= 4
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_7_0)
			return arg_7_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_8_0)
			return arg_8_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_9_0)
			return arg_9_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_18 * 0.5,
		max_distance = var_0_15 + var_0_18 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_10_0)
			return arg_10_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_11_0)
			return arg_11_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_12_0)
			return arg_12_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger"
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_13_0)
			return arg_13_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_14_0)
			return arg_14_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_15_0)
			return arg_15_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_16_0)
			return arg_16_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_17_0)
			return arg_17_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_18_0)
			return arg_18_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_19_0)
			return arg_19_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_20_0)
			return arg_20_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_21_0)
			return arg_21_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_22_0)
			return arg_22_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_23_0)
			return arg_23_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_24_0)
			return arg_24_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_25_0)
			return arg_25_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_26_0)
			return arg_26_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_27_0)
			return arg_27_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_28_0)
			return arg_28_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_29_0)
			return arg_29_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_30_0)
			return arg_30_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_31_0)
			return arg_31_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_32_0)
			return arg_32_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_33_0)
			return arg_33_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_34_0)
			return arg_34_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_35_0)
			return arg_35_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_36_0)
			return arg_36_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_37_0)
			return arg_37_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_38_0)
			return arg_38_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_39_0)
			return arg_39_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_40_0)
			return arg_40_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_41_0)
			return arg_41_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_42_0)
			return arg_42_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_43_0)
			return arg_43_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_44_0)
			return arg_44_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_47_0)
			return arg_47_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_48_0)
			return arg_48_0.cursed_chest_enemies <= 5
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_49_0)
			return arg_49_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_50_0)
			return arg_50_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_51_0)
			return arg_51_0.cursed_chest_enemies <= 4
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_52_0)
			return arg_52_0.cursed_chest_enemies <= 4
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_53_0)
			return arg_53_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_54_0)
			return arg_54_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_55_0)
			return arg_55_0.cursed_chest_enemies <= 4
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_56_0)
			return arg_56_0.cursed_chest_enemies <= 4
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_57_0)
			return arg_57_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_58_0)
			return arg_58_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_59_0)
			return arg_59_0.cursed_chest_enemies <= 6
		end
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function(arg_60_0)
			return arg_60_0.cursed_chest_elites <= 2
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_63_0)
			return arg_63_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_64_0)
			return arg_64_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_65_0)
			return arg_65_0.cursed_chest_enemies <= 6
		end
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function(arg_66_0)
			return arg_66_0.cursed_chest_elites <= 2
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_69_0)
			return arg_69_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_70_0)
			return arg_70_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_75_0)
			return arg_75_0.cursed_chest_enemies <= 2
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_76_0)
			return arg_76_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_77_0)
			return arg_77_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_78_0)
			return arg_78_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_79_0)
			return arg_79_0.cursed_chest_enemies <= 10
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_80_0)
			return arg_80_0.cursed_chest_elites <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_81_0)
			return arg_81_0.cursed_chest_enemies <= 10
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_82_0)
			return arg_82_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_83_0)
			return arg_83_0.cursed_chest_elites <= 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_84_0)
			return arg_84_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function(arg_85_0)
			return arg_85_0.cursed_chest_enemies <= 0
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 10,
		condition = function(arg_86_0)
			return arg_86_0.cursed_chest_enemies <= 0
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
			spawned_func = var_0_10
		},
		min_distance = var_0_16 - var_0_19 * 0.5,
		max_distance = var_0_16 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_87_0)
			return arg_87_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_88_0)
			return arg_88_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_89_0)
			return arg_89_0.cursed_chest_enemies <= 2
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = var_0_13
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_90_0)
			return arg_90_0.cursed_chest_enemies <= 2
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_91_0)
			return arg_91_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_92_0)
			return arg_92_0.cursed_chest_enemies <= 0
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
		duration = var_0_12
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
			spawned_func = var_0_10
		},
		min_distance = var_0_17 - var_0_19 * 0.5,
		max_distance = var_0_17 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14,
		pre_spawn_func = var_0_9
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
			spawned_func = var_0_10
		},
		min_distance = var_0_15 - var_0_19 * 0.5,
		max_distance = var_0_15 + var_0_19 * 0.5,
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		spawn_delay = var_0_14
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_93_0)
			return arg_93_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_94_0)
			return arg_94_0.cursed_chest_enemies <= 0
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
			spawned_func = function(arg_95_0, arg_95_1, arg_95_2)
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
		condition = function(arg_96_0)
			return arg_96_0.cursed_chest_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_97_0)
			return arg_97_0.cursed_chest_enemies <= 0
		end
	}
}

local var_0_35 = {
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
local var_0_36 = {
	"shadow_curse_sc1_spawn",
	"shadow_curse_sc2_spawn",
	"shadow_curse_sc3_spawn"
}

local function var_0_37(arg_98_0, arg_98_1)
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
			condition = function(arg_99_0)
				return arg_99_0.belakor_totem_enemies < 1
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
			condition = function(arg_100_0)
				return arg_100_0.belakor_totem_enemies < 1
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
				spawned_func = function(arg_101_0, arg_101_1, arg_101_2)
					if not arg_101_1.special and not arg_101_1.boss and not arg_101_1.cannot_be_aggroed then
						local var_101_0 = PlayerUtils.get_random_alive_hero()

						AiUtils.aggro_unit_of_enemy(arg_101_0, var_101_0)
					end

					Managers.state.entity:system("buff_system"):add_buff(arg_101_0, "belakor_shadow_lieutenant", arg_101_0)

					local var_101_1 = BLACKBOARDS[arg_101_0]

					if var_101_1 then
						local var_101_2 = var_101_1.world
						local var_101_3 = "shadow_lieutenant_spawn"

						WwiseUtils.trigger_unit_event(var_101_2, var_101_3, arg_101_0, 0)
					end

					local var_101_4 = var_0_36[arg_98_0]

					if var_101_4 then
						local var_101_5 = ScriptUnit.extension_input(arg_101_0, "dialogue_system")
						local var_101_6 = FrameTable.alloc_table()

						var_101_5:trigger_dialogue_event(var_101_4, var_101_6)
					end
				end
			},
			spawn_failed_func = function(arg_102_0)
				BelakorBalancing.spawn_crystal_func(arg_102_0)
			end,
			min_distance = var_0_25,
			max_distance = var_0_26,
			row_distance = var_0_30,
			above_max = var_0_27,
			below_max = var_0_28,
			distance_to_enemies = var_0_29,
			circle_subdivision = var_0_32,
			tries = var_0_33,
			pre_spawn_unit_func = var_0_23,
			post_spawn_unit_func = var_0_24,
			spawn_delay = var_0_14,
			pre_spawn_func = function(arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
				arg_103_0 = arg_103_0 or {}

				if arg_98_1 then
					arg_103_0.enhancements = {
						BreedEnhancements.base
					}
				end

				local var_103_0 = var_0_35[arg_98_0]
				local var_103_1 = 2

				for iter_103_0 = 1, var_103_1 do
					if var_103_0 and not table.is_empty(var_103_0) then
						local var_103_2 = {}

						for iter_103_1, iter_103_2 in pairs(BreedEnhancements) do
							if var_103_0[iter_103_1] then
								table.insert(var_103_2, iter_103_2)
							end
						end

						if #var_103_2 > 0 then
							local var_103_3 = var_103_2[Math.random(1, #var_103_2)]

							table.insert(arg_103_0.enhancements, var_103_3)
						end
					end
				end

				return arg_103_0
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when_spawned_count",
			duration = 20,
			condition = function(arg_104_0)
				return arg_104_0.belakor_altar_enemies > 0
			end
		},
		{
			"continue_when_spawned_count",
			duration = 60,
			condition = function(arg_105_0)
				return arg_105_0.belakor_altar_enemies <= 0
			end
		}
	}
end

GenericTerrorEvents.belakor_shadow_lieutenant_spawn = var_0_37(-1, true)
GenericTerrorEvents.belakor_altar_shadow_lieutenant_spawn_01 = var_0_37(1, true)
GenericTerrorEvents.belakor_altar_shadow_lieutenant_spawn_02 = var_0_37(2, true)
GenericTerrorEvents.belakor_altar_shadow_lieutenant_spawn_03 = var_0_37(3, true)
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
			spawned_func = function(arg_106_0, arg_106_1, arg_106_2)
				ScriptUnit.extension(arg_106_0, "ai_system"):set_perception("perception_regular", "pick_closest_target_with_spillover_wakeup_group")

				local var_106_0 = BLACKBOARDS[arg_106_0]

				if var_106_0 then
					var_106_0.ignore_interest_points = true
					var_106_0.only_trust_your_own_eyes = true

					Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_106_0)
				end

				Managers.state.entity:system("buff_system"):add_buff(arg_106_0, "belakor_cultists_buff", arg_106_0)
			end
		},
		min_distance = var_0_25,
		max_distance = var_0_26,
		row_distance = var_0_30,
		circle_subdivision = var_0_31,
		distance_to_enemies = var_0_29,
		above_max = var_0_27,
		below_max = var_0_28,
		pre_spawn_func = function(arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4)
			arg_107_0 = arg_107_0 or {}
			arg_107_0.idle_animation = var_0_34[math.random(#var_0_34)]

			return arg_107_0
		end
	},
	{
		"delay",
		duration = 1
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_108_0)
			return arg_108_0.belakor_altar_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_109_0)
			return arg_109_0.belakor_altar_enemies <= 0
		end
	}
}

local function var_0_38(arg_110_0)
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
			spawned_func = function(arg_111_0, arg_111_1, arg_111_2)
				if not arg_111_1.special and not arg_111_1.boss and not arg_111_1.cannot_be_aggroed then
					local var_111_0 = PlayerUtils.get_random_alive_hero()

					AiUtils.aggro_unit_of_enemy(arg_111_0, var_111_0)

					if BLACKBOARDS[arg_111_0] then
						Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_111_0)
					end
				end
			end
		},
		pre_spawn_unit_func = var_0_23,
		post_spawn_unit_func = var_0_24,
		above_max = var_0_27,
		below_max = var_0_28
	}
end

local var_0_39 = BelakorBalancing.totem_spawn_cooldown

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
		condition = function(arg_112_0)
			return arg_112_0.belakor_totem_enemies < 1
		end
	}
}
GenericTerrorEvents.belakor_totem_plague_monk = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_plague_monk",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_stormvermin = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_storm_vermin_commander",
			"skaven_slave",
			"skaven_slave",
			"skaven_slave"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_stormvermin_shield = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_storm_vermin_with_shield",
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_clan_rat_with_shield = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_clan_rats = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_clan_rat",
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_skaven_slaves = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_skaven_panic_storm_vermin = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_storm_vermin_commander",
			"skaven_storm_vermin_commander",
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_skaven_panic_plague_monk = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_plague_monk",
			"skaven_storm_vermin_commander",
			"skaven_slave",
			"skaven_clan_rat"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_skaven_shield = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_fanatics = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_marauders = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_raider = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"chaos_raider",
			"chaos_raider"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_warriors = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"chaos_warrior",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_berzerkers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_panic_berzerkers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"chaos_berzerker",
			"chaos_berzerker",
			"chaos_fanatic",
			"chaos_fanatic"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_panic_raiders = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"chaos_raider",
			"chaos_raider",
			"chaos_fanatic",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_chaos_panic_chaos_warrior = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"chaos_warrior",
			"chaos_marauder",
			"chaos_marauder"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_one_one = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_one_two = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_one_three = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_two_one = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_two_two = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_two_three = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_plague_monk",
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield",
			"skaven_clan_rat_with_shield"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_locus_wave_two_three = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"skaven_plague_monk",
			"skaven_plague_monk"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_ungor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_gor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"beastmen_gor",
			"beastmen_gor",
			"beastmen_gor"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_archers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"beastmen_ungor_archer",
			"beastmen_ungor_archer",
			"beastmen_ungor_archer"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_bestigor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"beastmen_bestigor",
			"beastmen_gor",
			"beastmen_gor"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_panic_bestigor = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"beastmen_bestigor",
			"beastmen_bestigor"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_panic_ungors = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
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
		duration = var_0_39
	}
}
GenericTerrorEvents.belakor_totem_beastmen_panic_archers = {
	{
		"play_stinger",
		stinger_name = "Play_wave_start_spawn_stinger_small",
		use_origin_unit_position = true
	},
	var_0_38({
		default = {
			"beastmen_ungor_archer",
			"beastmen_ungor_archer",
			"beastmen_ungor_archer",
			"beastmen_ungor_archer"
		}
	}),
	{
		"delay",
		duration = var_0_39
	}
}

local function var_0_40(arg_113_0)
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
			spawned_func = function(arg_114_0, arg_114_1, arg_114_2)
				Managers.state.entity:system("buff_system"):add_buff(arg_114_0, "belakor_grey_wings", arg_114_0)

				local var_114_0 = PlayerUtils.get_random_alive_hero()

				if not arg_114_1.cannot_be_aggroed then
					AiUtils.aggro_unit_of_enemy(arg_114_0, var_114_0)
				end
			end
		},
		pre_spawn_unit_func = function(arg_115_0, arg_115_1, arg_115_2, arg_115_3)
			local var_115_0 = "fx/blk_grey_wings_spawn_01"
			local var_115_1 = NetworkLookup.effects[var_115_0]
			local var_115_2 = 0
			local var_115_3 = Quaternion.identity()

			Managers.state.network:rpc_play_particle_effect(nil, var_115_1, NetworkConstants.invalid_game_object_id, var_115_2, arg_115_2:unbox(), var_115_3, false)
		end
	}
end

GenericTerrorEvents.grey_wings_plague_monks = {
	var_0_40({
		default = {
			"skaven_plague_monk",
			"skaven_plague_monk",
			"skaven_plague_monk"
		}
	}),
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_116_0)
			return arg_116_0.grey_wings_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_117_0)
			return arg_117_0.grey_wings_enemies <= 0
		end
	}
}
GenericTerrorEvents.grey_wings_berserkers = {
	var_0_40({
		default = {
			"chaos_berzerker",
			"chaos_berzerker",
			"chaos_berzerker"
		}
	}),
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_118_0)
			return arg_118_0.grey_wings_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_119_0)
			return arg_119_0.grey_wings_enemies <= 0
		end
	}
}
GenericTerrorEvents.grey_wings_bestigors = {
	var_0_40({
		default = {
			"beastmen_bestigor",
			"beastmen_bestigor",
			"beastmen_bestigor"
		}
	}),
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_120_0)
			return arg_120_0.grey_wings_enemies > 0
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_121_0)
			return arg_121_0.grey_wings_enemies <= 0
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

local function var_0_41(arg_122_0, arg_122_1, arg_122_2)
	if not arg_122_1.special and not arg_122_1.boss and not arg_122_1.cannot_be_aggroed then
		local var_122_0 = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(arg_122_0, var_122_0)
	end

	local var_122_1 = "fx/grudge_marks_shadow_step"
	local var_122_2 = NetworkLookup.effects[var_122_1]
	local var_122_3 = 0

	Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_122_2, NetworkConstants.invalid_game_object_id, var_122_3, POSITION_LOOKUP[arg_122_0], false)

	local var_122_4 = BLACKBOARDS[arg_122_0]

	if var_122_4 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_122_0)

		local var_122_5 = Quaternion.forward(Quaternion.axis_angle(Vector3.up(), math.pi * 2 * math.random()))
		local var_122_6 = 0.5
		local var_122_7 = var_0_0.medium
		local var_122_8 = 0.5
		local var_122_9 = Managers.time:time("game")

		AiUtils.stagger(arg_122_0, var_122_4, arg_122_0, var_122_5, var_122_6, var_122_7, var_122_8, nil, var_122_9)
	end
end

local var_0_42 = {
	"spawn_around_origin_unit_staggered",
	max_distance = 5,
	spawn_counter_category = "grudge_mark_commander_enemies",
	min_distance = 2,
	optional_data = {
		prevent_killed_enemy_dialogue = true,
		spawned_func = var_0_41
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
	}, var_0_42),
	table.merge({
		breed_name = "skaven_clan_rat",
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 2
		}
	}, var_0_42)
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
	}, var_0_42),
	table.merge({
		breed_name = "skaven_clan_rat_with_shield",
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 3,
			cataclysm = 3,
			normal = 2
		}
	}, var_0_42)
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
	}, var_0_42),
	table.merge({
		breed_name = "chaos_marauder",
		difficulty_amount = {
			hardest = 2,
			hard = 2,
			harder = 2,
			cataclysm = 3,
			normal = 2
		}
	}, var_0_42)
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
	}, var_0_42),
	table.merge({
		breed_name = "chaos_marauder",
		difficulty_amount = {
			hardest = 3,
			hard = 2,
			harder = 2,
			cataclysm = 4,
			normal = 2
		}
	}, var_0_42)
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
	}, var_0_42)
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
	}, var_0_42),
	table.merge({
		breed_name = "beastmen_gor",
		difficulty_amount = {
			hardest = 3,
			hard = 3,
			harder = 3,
			cataclysm = 4,
			normal = 2
		}
	}, var_0_42)
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
		condition = function(arg_123_0)
			return arg_123_0.boss <= 0 and arg_123_0.main <= 0 and arg_123_0.elite <= 0
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_124_0)
			return arg_124_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_125_0)
			return arg_125_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_126_0)
			return arg_126_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_127_0)
			return arg_127_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_128_0)
			return arg_128_0.main < 15
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_129_0)
			return arg_129_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_130_0)
			return arg_130_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
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
		condition = function(arg_131_0)
			return arg_131_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_132_0)
			return arg_132_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_133_0)
			return arg_133_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_134_0)
			return arg_134_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_135_0)
			return arg_135_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_136_0)
			return arg_136_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_137_0)
			return arg_137_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 100,
		condition = function(arg_138_0)
			return arg_138_0.main < 30
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_139_0)
			return arg_139_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 100,
		condition = function(arg_140_0)
			return arg_140_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_141_0)
			return arg_141_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_142_0)
			return arg_142_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_143_0)
			return arg_143_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_144_0)
			return arg_144_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_145_0)
			return arg_145_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_146_0)
			return arg_146_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_147_0)
			return arg_147_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_148_0)
			return arg_148_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_149_0)
			return arg_149_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_150_0)
			return arg_150_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_151_0)
			return arg_151_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_152_0)
			return arg_152_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_153_0)
			return arg_153_0.main < 15
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_154_0)
			return arg_154_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_155_0)
			return arg_155_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_156_0)
			return arg_156_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_157_0)
			return arg_157_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_158_0)
			return arg_158_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_159_0)
			return arg_159_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_160_0)
			return arg_160_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6,
		difficulty_requirement = var_0_3
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_161_0)
			return arg_161_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_162_0)
			return arg_162_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_163_0)
			return arg_163_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_164_0)
			return arg_164_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_165_0)
			return arg_165_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_166_0)
			return arg_166_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_167_0)
			return arg_167_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_168_0)
			return arg_168_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_169_0)
			return arg_169_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_b",
		breed_name = {
			"chaos_vortex_sorcerer",
			"chaos_corruptor_sorcerer"
		},
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_6,
		difficulty_requirement = var_0_3
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_170_0)
			return arg_170_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_171_0)
			return arg_171_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_172_0)
			return arg_172_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_173_0)
			return arg_173_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_174_0)
			return arg_174_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_175_0)
			return arg_175_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_176_0)
			return arg_176_0.main < 10
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_177_0)
			return arg_177_0.boss <= 0
		end,
		duration = var_0_7
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_178_0)
			return arg_178_0.boss <= 0
		end,
		duration = var_0_7
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_179_0)
			return arg_179_0.boss <= 0
		end,
		duration = var_0_7
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_180_0)
			return arg_180_0.boss <= 0
		end,
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_181_0)
			return arg_181_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_182_0)
			return arg_182_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_183_0)
			return arg_183_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_184_0)
			return arg_184_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_185_0)
			return arg_185_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_186_0)
			return arg_186_0.main < 15
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_187_0)
			return arg_187_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_188_0)
			return arg_188_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_189_0)
			return arg_189_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_190_0)
			return arg_190_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_191_0)
			return arg_191_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_192_0)
			return arg_192_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_193_0)
			return arg_193_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_194_0)
			return arg_194_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_195_0)
			return arg_195_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_196_0)
			return arg_196_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_197_0)
			return arg_197_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_198_0)
			return arg_198_0.boss <= 0
		end,
		duration = var_0_6
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
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_6,
		difficulty_requirement = var_0_3
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_199_0)
			return arg_199_0.boss <= 0
		end,
		duration = var_0_6,
		difficulty_requirement = var_0_3
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_200_0)
			return arg_200_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_201_0)
			return arg_201_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_202_0)
			return arg_202_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_203_0)
			return arg_203_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_204_0)
			return arg_204_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_205_0)
			return arg_205_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_206_0)
			return arg_206_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_207_0)
			return arg_207_0.boss <= 0
		end,
		duration = var_0_6
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
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_6,
		difficulty_requirement = var_0_3
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_208_0)
			return arg_208_0.boss <= 0
		end,
		duration = var_0_6,
		difficulty_requirement = var_0_3
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_209_0)
			return arg_209_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_210_0)
			return arg_210_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_211_0)
			return arg_211_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_212_0)
			return arg_212_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_213_0)
			return arg_213_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_214_0)
			return arg_214_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_215_0)
			return arg_215_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_216_0)
			return arg_216_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_217_0)
			return arg_217_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_218_0)
			return arg_218_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_219_0)
			return arg_219_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_220_0)
			return arg_220_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_221_0)
			return arg_221_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_222_0)
			return arg_222_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_223_0)
			return arg_223_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_224_0)
			return arg_224_0.main < 15
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_225_0)
			return arg_225_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_226_0)
			return arg_226_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_227_0)
			return arg_227_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_228_0)
			return arg_228_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_229_0)
			return arg_229_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_230_0)
			return arg_230_0.main < 10
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
		condition = function(arg_231_0)
			return arg_231_0.boss > 0
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_232_0)
			return arg_232_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_233_0)
			return arg_233_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_234_0)
			return arg_234_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_235_0)
			return arg_235_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_236_0)
			return arg_236_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_237_0)
			return arg_237_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_238_0)
			return arg_238_0.main < 4
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
		condition = function(arg_239_0)
			return arg_239_0.boss > 0
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_240_0)
			return arg_240_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_241_0)
			return arg_241_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_242_0)
			return arg_242_0.boss <= 0
		end,
		duration = var_0_6
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
		condition = function(arg_243_0)
			return arg_243_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_244_0)
			return arg_244_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_245_0)
			return arg_245_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_246_0)
			return arg_246_0.elite < 5
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_247_0)
			return arg_247_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_248_0)
			return arg_248_0.special < 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_249_0)
			return arg_249_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_250_0)
			return arg_250_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_251_0)
			return arg_251_0.main < 10
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
		condition = function(arg_252_0)
			return arg_252_0.boss > 0
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_253_0)
			return arg_253_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_254_0)
			return arg_254_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_255_0)
			return arg_255_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_256_0)
			return arg_256_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_257_0)
			return arg_257_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_258_0)
			return arg_258_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_259_0)
			return arg_259_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_260_0)
			return arg_260_0.main < 10 and arg_260_0.elite < 5
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_261_0)
			return arg_261_0.main < 10 and arg_261_0.elite < 5
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_262_0)
			return arg_262_0.main < 10
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
		condition = function(arg_263_0)
			return arg_263_0.boss > 0
		end
	},
	{
		"delay",
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_264_0)
			return arg_264_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_265_0)
			return arg_265_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_266_0)
			return arg_266_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_267_0)
			return arg_267_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_268_0)
			return arg_268_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_269_0)
			return arg_269_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_270_0)
			return arg_270_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_271_0)
			return arg_271_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_272_0)
			return arg_272_0.main < 10
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
		condition = function(arg_273_0)
			return arg_273_0.boss > 0
		end
	},
	{
		"delay",
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_274_0)
			return arg_274_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_275_0)
			return arg_275_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6,
		difficulty_requirement = var_0_3
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
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_276_0)
			return arg_276_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_277_0)
			return arg_277_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_278_0)
			return arg_278_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6,
		difficulty_requirement = var_0_3
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
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_279_0)
			return arg_279_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_280_0)
			return arg_280_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_281_0)
			return arg_281_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_282_0)
			return arg_282_0.elite < 3
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
		duration = var_0_6
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
		duration = var_0_6,
		difficulty_requirement = var_0_3
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
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_283_0)
			return arg_283_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 120,
		condition = function(arg_284_0)
			return arg_284_0.elite <= 2
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
		duration = var_0_6
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
		duration = var_0_6,
		difficulty_requirement = var_0_3
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
		difficulty_requirement = var_0_3
	},
	{
		"delay",
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		duration = 20,
		condition = function(arg_285_0)
			return arg_285_0.elite <= 2
		end
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_286_0)
			return arg_286_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_287_0)
			return arg_287_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_288_0)
			return arg_288_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_289_0)
			return arg_289_0.boss <= 0
		end,
		duration = var_0_6
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
		condition = function(arg_290_0)
			return arg_290_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_291_0)
			return arg_291_0.main < 10
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
		duration = var_0_6
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
		condition = function(arg_292_0)
			return arg_292_0.boss > 0
		end
	},
	{
		"delay",
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_293_0)
			return arg_293_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_294_0)
			return arg_294_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_295_0)
			return arg_295_0.main < 10
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_296_0)
			return arg_296_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = -5,
		condition = function(arg_297_0)
			return arg_297_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 5,
		condition = function(arg_298_0)
			return arg_298_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "end_event_crater_small"
	},
	{
		"delay",
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_299_0)
			return arg_299_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_300_0)
			return arg_300_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_301_0)
			return arg_301_0.main < 10
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_302_0)
			return arg_302_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
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
		condition = function(arg_303_0)
			return arg_303_0.elite > 0
		end
	},
	{
		"continue_when_spawned_count",
		s,
		duration = 120,
		condition = function(arg_304_0)
			return arg_304_0.elite <= 1
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_305_0)
			return arg_305_0.boss <= 0
		end,
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		minimum_difficulty_tweak = 0,
		condition = function(arg_306_0)
			return arg_306_0.boss <= 0
		end,
		duration = var_0_6
	},
	{
		"spawn_at_raw",
		spawner_id = "terror_event_special_a",
		breed_name = "beastmen_standard_bearer"
	},
	{
		"delay",
		duration = var_0_6
	},
	{
		"event_horde",
		spawn_counter_category = "main",
		spawner_id = "terror_event_a",
		composition_type = "bestigors"
	},
	{
		"delay",
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
	},
	{
		"continue_when_spawned_count",
		duration = 60,
		condition = function(arg_307_0)
			return arg_307_0.main < 10
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_6
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_308_0)
			return arg_308_0.skaven_slave <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_309_0)
			return arg_309_0.skaven_slave <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_310_0)
			return arg_310_0.skaven_clan_rat <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_311_0)
			return arg_311_0.skaven_clan_rat_with_shield <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_312_0)
			return arg_312_0.skaven_plague_monk <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_313_0)
			return arg_313_0.skaven_storm_vermin <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_314_0)
			return arg_314_0.skaven_storm_vermin_commander <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_315_0)
			return arg_315_0.skaven_storm_vermin_with_shield <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_316_0)
			return arg_316_0.skaven_explosive_loot_rat <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_317_0)
			return arg_317_0.chaos_fanatic <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_318_0)
			return arg_318_0.chaos_marauder <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_319_0)
			return arg_319_0.chaos_marauder_with_shield <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_320_0)
			return arg_320_0.chaos_berzerker <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_321_0)
			return arg_321_0.chaos_raider <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_322_0)
			return arg_322_0.chaos_warrior <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_323_0)
			return arg_323_0.beastmen_ungor <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_324_0)
			return arg_324_0.beastmen_gor <= 0
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
		duration = var_0_7
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_325_0)
			return arg_325_0.beastmen_bestigor <= 0
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
		condition = function(arg_326_0)
			return arg_326_0.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_327_0)
			return arg_327_0.skaven_gutter_runner <= 0
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
		condition = function(arg_328_0)
			return arg_328_0.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_329_0)
			return arg_329_0.skaven_gutter_runner <= 0
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
		condition = function(arg_330_0)
			return arg_330_0.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_331_0)
			return arg_331_0.skaven_gutter_runner <= 0
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
		condition = function(arg_332_0)
			return arg_332_0.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_333_0)
			return arg_333_0.skaven_gutter_runner <= 0
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
		condition = function(arg_334_0)
			return arg_334_0.skaven_gutter_runner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_335_0)
			return arg_335_0.skaven_gutter_runner <= 0
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
		condition = function(arg_336_0)
			return arg_336_0.skaven_warpfire_thrower > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_337_0)
			return arg_337_0.skaven_warpfire_thrower <= 0
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
		condition = function(arg_338_0)
			return arg_338_0.skaven_poison_wind_globadier > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_339_0)
			return arg_339_0.skaven_poison_wind_globadier <= 0
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
		condition = function(arg_340_0)
			return arg_340_0.skaven_ratling_gunner > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_341_0)
			return arg_341_0.skaven_ratling_gunner <= 0
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
		condition = function(arg_342_0)
			return arg_342_0.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_343_0)
			return arg_343_0.chaos_corruptor_sorcerer <= 0
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
		condition = function(arg_344_0)
			return arg_344_0.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_345_0)
			return arg_345_0.chaos_corruptor_sorcerer <= 0
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
		condition = function(arg_346_0)
			return arg_346_0.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_347_0)
			return arg_347_0.chaos_corruptor_sorcerer <= 0
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
		condition = function(arg_348_0)
			return arg_348_0.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_349_0)
			return arg_349_0.chaos_corruptor_sorcerer <= 0
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
		condition = function(arg_350_0)
			return arg_350_0.chaos_corruptor_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_351_0)
			return arg_351_0.chaos_corruptor_sorcerer <= 0
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
		condition = function(arg_352_0)
			return arg_352_0.chaos_vortex_sorcerer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_353_0)
			return arg_353_0.chaos_vortex_sorcerer <= 0
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
		condition = function(arg_354_0)
			return arg_354_0.beastmen_standard_bearer > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_355_0)
			return arg_355_0.beastmen_standard_bearer <= 0
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
		condition = function(arg_356_0)
			return arg_356_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_357_0)
			return arg_357_0.skaven_rat_ogre <= 0
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
		condition = function(arg_358_0)
			return arg_358_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_359_0)
			return arg_359_0.skaven_rat_ogre <= 0
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
		condition = function(arg_360_0)
			return arg_360_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_361_0)
			return arg_361_0.skaven_rat_ogre <= 0
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
		condition = function(arg_362_0)
			return arg_362_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_363_0)
			return arg_363_0.skaven_rat_ogre <= 0
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
		condition = function(arg_364_0)
			return arg_364_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_365_0)
			return arg_365_0.skaven_rat_ogre <= 0
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
		condition = function(arg_366_0)
			return arg_366_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_367_0)
			return arg_367_0.skaven_rat_ogre <= 0
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
		condition = function(arg_368_0)
			return arg_368_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_369_0)
			return arg_369_0.skaven_rat_ogre <= 0
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
		condition = function(arg_370_0)
			return arg_370_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_371_0)
			return arg_371_0.skaven_rat_ogre <= 0
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
		condition = function(arg_372_0)
			return arg_372_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_373_0)
			return arg_373_0.skaven_rat_ogre <= 0
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
		condition = function(arg_374_0)
			return arg_374_0.skaven_rat_ogre > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_375_0)
			return arg_375_0.skaven_rat_ogre <= 0
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
		condition = function(arg_376_0)
			return arg_376_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_377_0)
			return arg_377_0.skaven_stormfiend <= 0
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
		condition = function(arg_378_0)
			return arg_378_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_379_0)
			return arg_379_0.skaven_stormfiend <= 0
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
		condition = function(arg_380_0)
			return arg_380_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_381_0)
			return arg_381_0.skaven_stormfiend <= 0
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
		condition = function(arg_382_0)
			return arg_382_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_383_0)
			return arg_383_0.skaven_stormfiend <= 0
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
		condition = function(arg_384_0)
			return arg_384_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_385_0)
			return arg_385_0.skaven_stormfiend <= 0
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
		condition = function(arg_386_0)
			return arg_386_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_387_0)
			return arg_387_0.skaven_stormfiend <= 0
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
		condition = function(arg_388_0)
			return arg_388_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_389_0)
			return arg_389_0.skaven_stormfiend <= 0
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
		condition = function(arg_390_0)
			return arg_390_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_391_0)
			return arg_391_0.skaven_stormfiend <= 0
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
		condition = function(arg_392_0)
			return arg_392_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_393_0)
			return arg_393_0.skaven_stormfiend <= 0
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
		condition = function(arg_394_0)
			return arg_394_0.skaven_stormfiend > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_395_0)
			return arg_395_0.skaven_stormfiend <= 0
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
		condition = function(arg_396_0)
			return arg_396_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_397_0)
			return arg_397_0.chaos_troll <= 0
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
		condition = function(arg_398_0)
			return arg_398_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_399_0)
			return arg_399_0.chaos_troll <= 0
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
		condition = function(arg_400_0)
			return arg_400_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_401_0)
			return arg_401_0.chaos_troll <= 0
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
		condition = function(arg_402_0)
			return arg_402_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_403_0)
			return arg_403_0.chaos_troll <= 0
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
		condition = function(arg_404_0)
			return arg_404_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_405_0)
			return arg_405_0.chaos_troll <= 0
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
		condition = function(arg_406_0)
			return arg_406_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_407_0)
			return arg_407_0.chaos_troll <= 0
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
		condition = function(arg_408_0)
			return arg_408_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_409_0)
			return arg_409_0.chaos_troll <= 0
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
		condition = function(arg_410_0)
			return arg_410_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_411_0)
			return arg_411_0.chaos_troll <= 0
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
		condition = function(arg_412_0)
			return arg_412_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_413_0)
			return arg_413_0.chaos_troll <= 0
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
		condition = function(arg_414_0)
			return arg_414_0.chaos_troll > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_415_0)
			return arg_415_0.chaos_troll <= 0
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
		condition = function(arg_416_0)
			return arg_416_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_417_0)
			return arg_417_0.chaos_spawn <= 0
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
		condition = function(arg_418_0)
			return arg_418_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_419_0)
			return arg_419_0.chaos_spawn <= 0
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
		condition = function(arg_420_0)
			return arg_420_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_421_0)
			return arg_421_0.chaos_spawn <= 0
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
		condition = function(arg_422_0)
			return arg_422_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_423_0)
			return arg_423_0.chaos_spawn <= 0
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
		condition = function(arg_424_0)
			return arg_424_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_425_0)
			return arg_425_0.chaos_spawn <= 0
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
		condition = function(arg_426_0)
			return arg_426_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_427_0)
			return arg_427_0.chaos_spawn <= 0
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
		condition = function(arg_428_0)
			return arg_428_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_429_0)
			return arg_429_0.chaos_spawn <= 0
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
		condition = function(arg_430_0)
			return arg_430_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_431_0)
			return arg_431_0.chaos_spawn <= 0
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
		condition = function(arg_432_0)
			return arg_432_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_433_0)
			return arg_433_0.chaos_spawn <= 0
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
		condition = function(arg_434_0)
			return arg_434_0.chaos_spawn > 0
		end
	},
	{
		"continue_when_spawned_count",
		condition = function(arg_435_0)
			return arg_435_0.chaos_spawn <= 0
		end
	}
}
