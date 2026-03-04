-- chunkname: @scripts/settings/dlcs/belakor/belakor_common_settings.lua

local var_0_0 = DLCSettings.belakor

var_0_0.additional_system_extensions = {
	pickup_system = {
		{
			require = "scripts/unit_extensions/pickups/orb_pickup_unit_extension",
			class = "OrbPickupUnitExtension"
		}
	}
}
var_0_0.pickup_system_extension_update = {
	"OrbPickupUnitExtension"
}
var_0_0.unit_extension_templates = {
	"scripts/settings/dlcs/belakor/belakor_extension_templates"
}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_belakor"
}
var_0_0.anim_lookup = {
	"spawn_chaos_champion_01",
	"spawn_chaos_champion_02",
	"spawn_chaos_champion_03",
	"spawn_chaos_champion_04",
	"spawn_chaos_champion_05",
	"insert_locus_crystal"
}
var_0_0.husk_lookup = {
	"units/props/deus_orb/deus_orb_01",
	"units/props/blk/blk_curse_shadow_dagger_01",
	"units/props/blk/blk_curse_shadow_homing_skull_01",
	"units/props/blk/blk_curse_shadow_dagger_spawner_01",
	"units/props/blk/blk_curse_shadow_homing_skulls_spawner_01",
	"units/weapons/player/pup_belakor_crystal/pup_belakor_crystal",
	"units/props/blk/blk_locus_01",
	"units/props/blk/blk_totem_01",
	"units/beings/enemies/blk_shadow_lieutenant/chr_blk_shadow_lieutenant",
	"units/gameplay/belakor_crystal_socket_01"
}
var_0_0.game_object_initializers = {
	orb_pickup_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = ScriptUnit.extension(arg_1_0, "pickup_system")
		local var_1_1 = var_1_0.pickup_name
		local var_1_2 = var_1_0.has_physics
		local var_1_3 = var_1_0.spawn_type
		local var_1_4 = var_1_0:get_orb_flight_target_position()

		return {
			go_type = NetworkLookup.go_types.orb_pickup_unit,
			husk_unit = NetworkLookup.husks[arg_1_1],
			pickup_name = NetworkLookup.pickup_names[var_1_1],
			has_physics = var_1_2,
			spawn_type = NetworkLookup.pickup_spawn_types[var_1_3],
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			orb_flight_target_position = var_1_4 and var_1_4:unbox(),
			flight_enabled = var_1_4 and true or false
		}
	end,
	shadow_dagger_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = ScriptUnit.extension(arg_2_0, "projectile_locomotion_system")
		local var_2_1 = var_2_0.angle
		local var_2_2 = var_2_0.speed
		local var_2_3 = var_2_0.gravity_settings
		local var_2_4 = var_2_0.target_vector
		local var_2_5 = var_2_0.initial_position_boxed:unbox()
		local var_2_6 = var_2_0.trajectory_template_name
		local var_2_7 = var_2_0.rotation_speed
		local var_2_8 = var_2_0.rotate_around_forward
		local var_2_9 = var_2_0.start_paused_for_time
		local var_2_10 = ScriptUnit.extension(arg_2_0, "projectile_impact_system")
		local var_2_11 = var_2_10.collision_filter
		local var_2_12 = var_2_10.sphere_radius
		local var_2_13 = var_2_10.only_one_impact
		local var_2_14 = var_2_10.owner_unit
		local var_2_15 = ScriptUnit.extension(arg_2_0, "projectile_system")
		local var_2_16 = var_2_15.impact_template_name
		local var_2_17 = var_2_15.damage_source
		local var_2_18 = Managers.state.network

		return {
			go_type = NetworkLookup.go_types.shadow_dagger_unit,
			husk_unit = NetworkLookup.husks[arg_2_1],
			angle = var_2_1,
			speed = var_2_2,
			gravity_settings = NetworkLookup.projectile_gravity_settings[var_2_3],
			initial_position = var_2_5,
			target_vector = var_2_4,
			trajectory_template_name = NetworkLookup.projectile_templates[var_2_6],
			owner_unit = var_2_18:unit_game_object_id(var_2_14),
			rotate_around_forward = var_2_8,
			rotation_speed = var_2_7,
			start_paused_for_time = var_2_9,
			collision_filter = NetworkLookup.collision_filters[var_2_11],
			sphere_radius = var_2_12,
			only_one_impact = var_2_13,
			impact_template_name = NetworkLookup.projectile_templates[var_2_16],
			damage_source_id = NetworkLookup.damage_sources[var_2_17]
		}
	end,
	shadow_skull_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		local var_3_0 = Unit.get_data(arg_3_0, "breed")
		local var_3_1 = Managers.state.side.side_by_unit[arg_3_0].side_id
		local var_3_2 = ScriptUnit.has_extension(arg_3_0, "health_system"):get_max_health()

		return {
			go_type = NetworkLookup.go_types.shadow_skull_unit,
			position = Unit.local_position(arg_3_0, 0),
			rotation = Unit.local_rotation(arg_3_0, 0),
			husk_unit = NetworkLookup.husks[arg_3_1],
			health = var_3_2,
			breed_name = NetworkLookup.breeds[var_3_0.name],
			bt_action_name = NetworkLookup.bt_action_names["n/a"],
			side_id = var_3_1
		}
	end,
	arena_belakor_big_statue_health = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = ScriptUnit.has_extension(arg_4_0, "health_system")

		return {
			go_type = NetworkLookup.go_types.arena_belakor_big_statue_health,
			husk_unit = NetworkLookup.husks[arg_4_1],
			position = Unit.local_position(arg_4_0, 0),
			rotation = Unit.local_rotation(arg_4_0, 0),
			health = var_4_0:get_max_health()
		}
	end,
	deus_belakor_locus = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		return {
			go_type = NetworkLookup.go_types.deus_belakor_locus,
			husk_unit = NetworkLookup.husks[arg_5_1],
			position = Unit.local_position(arg_5_0, 0),
			rotation = Unit.local_rotation(arg_5_0, 0)
		}
	end,
	belakor_crystal = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = ScriptUnit.extension(arg_6_0, "pickup_system")
		local var_6_1 = var_6_0.pickup_name
		local var_6_2 = var_6_0.has_physics
		local var_6_3 = var_6_0.spawn_type

		return {
			go_type = NetworkLookup.go_types.belakor_crystal,
			husk_unit = NetworkLookup.husks[arg_6_1],
			position = Unit.local_position(arg_6_0, 0),
			rotation = Unit.local_rotation(arg_6_0, 0),
			debug_pos = Unit.local_position(arg_6_0, 0),
			pickup_name = NetworkLookup.pickup_names[var_6_1],
			has_physics = var_6_2,
			spawn_type = NetworkLookup.pickup_spawn_types[var_6_3]
		}
	end,
	belakor_crystal_throw = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		local var_7_0 = ScriptUnit.extension(arg_7_0, "projectile_locomotion_system")
		local var_7_1 = var_7_0.network_position
		local var_7_2 = var_7_0.network_rotation
		local var_7_3 = var_7_0.network_velocity
		local var_7_4 = var_7_0.network_angular_velocity
		local var_7_5 = ScriptUnit.extension(arg_7_0, "pickup_system")
		local var_7_6 = var_7_5.pickup_name
		local var_7_7 = var_7_5.has_physics
		local var_7_8 = var_7_5.spawn_type

		return {
			go_type = NetworkLookup.go_types.belakor_crystal_throw,
			husk_unit = NetworkLookup.husks[arg_7_1],
			position = Unit.local_position(arg_7_0, 0),
			rotation = Unit.local_rotation(arg_7_0, 0),
			network_position = var_7_1,
			network_rotation = var_7_2,
			network_velocity = var_7_3,
			network_angular_velocity = var_7_4,
			debug_pos = Unit.local_position(arg_7_0, 0),
			pickup_name = NetworkLookup.pickup_names[var_7_6],
			has_physics = var_7_7,
			spawn_type = NetworkLookup.pickup_spawn_types[var_7_8]
		}
	end,
	belakor_totem = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		local var_8_0 = Unit.get_data(arg_8_0, "breed")
		local var_8_1 = Managers.state.side.side_by_unit[arg_8_0].side_id
		local var_8_2 = ScriptUnit.has_extension(arg_8_0, "health_system")

		return {
			go_type = NetworkLookup.go_types.belakor_totem,
			husk_unit = NetworkLookup.husks[arg_8_1],
			position = Unit.local_position(arg_8_0, 0),
			rotation = Unit.local_rotation(arg_8_0, 0),
			health = var_8_2:get_max_health(),
			breed_name = NetworkLookup.breeds[var_8_0.name],
			bt_action_name = NetworkLookup.bt_action_names["n/a"],
			side_id = var_8_1
		}
	end,
	shadow_homing_skulls_spawner = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		return {
			go_type = NetworkLookup.go_types.shadow_homing_skulls_spawner,
			husk_unit = NetworkLookup.husks[arg_9_1],
			position = Unit.local_position(arg_9_0, 0),
			rotation = Unit.local_rotation(arg_9_0, 0)
		}
	end,
	belakor_crystal_socket = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		return {
			go_type = NetworkLookup.go_types.belakor_crystal_socket,
			husk_unit = NetworkLookup.husks[arg_10_1],
			position = Unit.local_position(arg_10_0, 0),
			rotation = Unit.local_rotation(arg_10_0, 0)
		}
	end
}
var_0_0.game_object_extractors = {
	orb_pickup_unit = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		local var_11_0 = GameSession.game_object_field(arg_11_0, arg_11_1, "pickup_name")
		local var_11_1 = GameSession.game_object_field(arg_11_0, arg_11_1, "has_physics")
		local var_11_2 = GameSession.game_object_field(arg_11_0, arg_11_1, "spawn_type")
		local var_11_3 = GameSession.game_object_field(arg_11_0, arg_11_1, "orb_flight_target_position")
		local var_11_4 = GameSession.game_object_field(arg_11_0, arg_11_1, "flight_enabled")
		local var_11_5 = {
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[var_11_0],
				has_physics = var_11_1,
				spawn_type = NetworkLookup.pickup_spawn_types[var_11_2],
				orb_flight_target_position = var_11_3 and Vector3Box(var_11_3),
				flight_enabled = var_11_4
			}
		}

		return "orb_pickup_unit", var_11_5
	end,
	shadow_dagger_unit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		local var_12_0 = GameSession.game_object_field(arg_12_0, arg_12_1, "angle")
		local var_12_1 = GameSession.game_object_field(arg_12_0, arg_12_1, "speed")
		local var_12_2 = GameSession.game_object_field(arg_12_0, arg_12_1, "gravity_settings")
		local var_12_3 = GameSession.game_object_field(arg_12_0, arg_12_1, "target_vector")
		local var_12_4 = GameSession.game_object_field(arg_12_0, arg_12_1, "initial_position")
		local var_12_5 = GameSession.game_object_field(arg_12_0, arg_12_1, "trajectory_template_name")
		local var_12_6 = GameSession.game_object_field(arg_12_0, arg_12_1, "owner_unit")
		local var_12_7 = GameSession.game_object_field(arg_12_0, arg_12_1, "rotation_speed")
		local var_12_8 = GameSession.game_object_field(arg_12_0, arg_12_1, "rotate_around_forward")
		local var_12_9 = GameSession.game_object_field(arg_12_0, arg_12_1, "start_paused_for_time")
		local var_12_10 = GameSession.game_object_field(arg_12_0, arg_12_1, "only_one_impact")
		local var_12_11 = GameSession.game_object_field(arg_12_0, arg_12_1, "sphere_radius")
		local var_12_12 = GameSession.game_object_field(arg_12_0, arg_12_1, "collision_filter")
		local var_12_13 = GameSession.game_object_field(arg_12_0, arg_12_1, "impact_template_name")
		local var_12_14 = GameSession.game_object_field(arg_12_0, arg_12_1, "damage_source_id")
		local var_12_15 = Managers.state.unit_storage:unit(var_12_6)
		local var_12_16 = {
			projectile_locomotion_system = {
				is_husk = true,
				angle = var_12_0,
				speed = var_12_1,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_12_2],
				target_vector = var_12_3,
				initial_position = var_12_4,
				trajectory_template_name = NetworkLookup.projectile_templates[var_12_5],
				rotation_speed = var_12_7,
				rotate_around_forward = var_12_8,
				start_paused_for_time = var_12_9
			},
			projectile_impact_system = {
				collision_filter = NetworkLookup.collision_filters[var_12_12],
				only_one_impact = var_12_10,
				sphere_radius = var_12_11,
				owner_unit = var_12_15
			},
			projectile_system = {
				impact_template_name = NetworkLookup.projectile_templates[var_12_13],
				owner_unit = var_12_15,
				damage_source = NetworkLookup.damage_sources[var_12_14]
			},
			locomotion_system = {}
		}

		return "shadow_dagger_unit", var_12_16
	end,
	shadow_skull_unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		local var_13_0 = GameSession.game_object_field(arg_13_0, arg_13_1, "breed_name")
		local var_13_1 = GameSession.game_object_field(arg_13_0, arg_13_1, "side_id")
		local var_13_2 = GameSession.game_object_field(arg_13_0, arg_13_1, "health")
		local var_13_3 = NetworkLookup.breeds[var_13_0]
		local var_13_4 = Breeds[var_13_3]

		Unit.set_data(arg_13_3, "breed", var_13_4)

		local var_13_5 = {
			ai_system = {
				go_id = arg_13_1,
				game = arg_13_0,
				side_id = var_13_1
			},
			health_system = {
				health = var_13_2
			},
			death_system = {
				is_husk = true,
				death_reaction_template = var_13_4.death_reaction,
				disable_second_hit_ragdoll = var_13_4.disable_second_hit_ragdoll
			},
			hit_reaction_system = {
				is_husk = true,
				hit_reaction_template = var_13_4.hit_reaction,
				hit_effect_template = var_13_4.hit_effect_template
			},
			dialogue_system = {
				faction = "enemy",
				breed_name = var_13_3
			},
			proximity_system = {
				breed = var_13_4
			},
			projectile_locomotion_system = {
				is_husk = true
			}
		}
		local var_13_6 = true

		var_13_4.modify_extension_init_data(var_13_4, var_13_6, var_13_5)

		return var_13_4.unit_template, var_13_5
	end,
	arena_belakor_big_statue_health = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		local var_14_0 = GameSession.game_object_field(arg_14_0, arg_14_1, "health")
		local var_14_1 = "arena_belakor_big_statue_health"
		local var_14_2 = {
			health_system = {
				health = var_14_0
			},
			death_system = {
				death_reaction_template = "level_object",
				is_husk = true
			},
			hit_reaction_system = {
				is_husk = true,
				hit_reaction_template = "level_object"
			}
		}

		return var_14_1, var_14_2
	end,
	deus_belakor_locus = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		local var_15_0 = "deus_belakor_locus"
		local var_15_1 = AllPickups.deus_02
		local var_15_2 = {}

		table.merge_recursive(var_15_2, var_15_1.additional_data_husk)

		return var_15_0, var_15_2
	end,
	belakor_crystal = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		local var_16_0 = GameSession.game_object_field(arg_16_0, arg_16_1, "pickup_name")
		local var_16_1 = GameSession.game_object_field(arg_16_0, arg_16_1, "has_physics")
		local var_16_2 = GameSession.game_object_field(arg_16_0, arg_16_1, "spawn_type")
		local var_16_3 = {
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[var_16_0],
				has_physics = var_16_1,
				spawn_type = NetworkLookup.pickup_spawn_types[var_16_2]
			}
		}

		return "belakor_crystal", var_16_3
	end,
	belakor_crystal_throw = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		local var_17_0 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_position")
		local var_17_1 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_rotation")
		local var_17_2 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_velocity")
		local var_17_3 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_angular_velocity")
		local var_17_4 = GameSession.game_object_field(arg_17_0, arg_17_1, "pickup_name")
		local var_17_5 = GameSession.game_object_field(arg_17_0, arg_17_1, "has_physics")
		local var_17_6 = GameSession.game_object_field(arg_17_0, arg_17_1, "spawn_type")
		local var_17_7 = {
			projectile_locomotion_system = {
				network_position = var_17_0,
				network_rotation = var_17_1,
				network_velocity = var_17_2,
				network_angular_velocity = var_17_3
			},
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[var_17_4],
				has_physics = var_17_5,
				spawn_type = NetworkLookup.pickup_spawn_types[var_17_6]
			}
		}

		return "belakor_crystal_throw", var_17_7
	end,
	belakor_totem = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		local var_18_0 = GameSession.game_object_field(arg_18_0, arg_18_1, "breed_name")
		local var_18_1 = GameSession.game_object_field(arg_18_0, arg_18_1, "side_id")
		local var_18_2 = GameSession.game_object_field(arg_18_0, arg_18_1, "health")
		local var_18_3 = NetworkLookup.breeds[var_18_0]
		local var_18_4 = Breeds[var_18_3]

		Unit.set_data(arg_18_3, "breed", var_18_4)

		local var_18_5 = {
			ai_system = {
				go_id = arg_18_1,
				game = arg_18_0,
				side_id = var_18_1
			},
			health_system = {
				health = var_18_2
			},
			death_system = {
				is_husk = true
			},
			hit_reaction_system = {
				is_husk = true
			},
			dialogue_system = {
				faction = "enemy",
				breed_name = var_18_3
			},
			proximity_system = {
				breed = var_18_4
			}
		}
		local var_18_6 = true

		var_18_4.modify_extension_init_data(var_18_4, var_18_6, var_18_5)

		return var_18_4.unit_template, var_18_5
	end,
	shadow_homing_skulls_spawner = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		local var_19_0 = {}

		return "shadow_homing_skulls_spawner", var_19_0
	end,
	belakor_crystal_socket = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		local var_20_0 = {}

		return "belakor_crystal_socket", var_20_0
	end
}
var_0_0.game_object_templates = {
	orb_pickup_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	shadow_dagger_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	shadow_skull_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	arena_belakor_big_statue_health = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = false,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	deus_belakor_locus = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	belakor_crystal = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	belakor_crystal_throw = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	belakor_totem = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	shadow_homing_skulls_spawner = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	belakor_crystal_socket = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	}
}
var_0_0.entity_extensions = {
	"scripts/unit_extensions/ai_supplementary/shadow_dagger_spawner_extension",
	"scripts/unit_extensions/ai_supplementary/shadow_homing_skulls_spawner_extension",
	"scripts/unit_extensions/ai_supplementary/shadow_dagger_extension",
	"scripts/unit_extensions/deus/deus_belakor_locus_extension",
	"scripts/unit_extensions/deus/deus_arena_belakor_big_statue_extension",
	"scripts/unit_extensions/deus/deus_belakor_crystal_extension",
	"scripts/unit_extensions/deus/deus_belakor_totem_extension",
	"scripts/unit_extensions/deus/deus_belakor_statue_socket_extension",
	"scripts/unit_extensions/generic/kill_volume_handler_extension"
}
var_0_0.systems = {
	"scripts/entity_system/systems/orb/orb_system"
}
var_0_0.entity_system_params = {
	shadow_homing_skulls_spawner_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "shadow_homing_skulls_spawner_system",
		extension_list = {
			"ShadowHomingSkullsSpawnerExtension"
		}
	},
	shadow_dagger_spawner_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "shadow_dagger_spawner_system",
		extension_list = {
			"ShadowDaggerSpawnerExtension"
		}
	},
	shadow_dagger_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "shadow_dagger_system",
		extension_list = {
			"ShadowDaggerExtension"
		}
	},
	deus_belakor_locus_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_belakor_locus_system",
		extension_list = {
			"DeusBelakorLocusExtension"
		}
	},
	deus_belakor_crystal_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_belakor_crystal_system",
		extension_list = {
			"DeusBelakorCrystalExtension"
		}
	},
	deus_arena_belakor_big_statue_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_arena_belakor_big_statue_system",
		extension_list = {
			"DeusArenaBelakorBigStatueExtension"
		}
	},
	deus_belakor_totem_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_belakor_totem_system",
		extension_list = {
			"DeusBelakorTotemExtension"
		}
	},
	deus_belakor_statue_socket_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_belakor_statue_socket_system",
		extension_list = {
			"DeusBelakorStatueSocketExtension"
		}
	},
	orb_system = {
		system_class_name = "OrbSystem",
		system_name = "orb_system",
		extension_list = {}
	},
	kill_volume_handler_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "kill_volume_handler_system",
		extension_list = {
			"KillVolumeHandlerExtension"
		}
	}
}
var_0_0.network_damage_sources = {
	"tiny_explosive_barrel"
}
var_0_0.network_go_types = {
	"orb_pickup_unit",
	"shadow_dagger_spawner",
	"shadow_dagger_unit",
	"arena_belakor_big_statue_health",
	"deus_belakor_locus",
	"belakor_crystal",
	"belakor_crystal_throw",
	"belakor_totem",
	"shadow_homing_skulls_spawner",
	"shadow_skull_unit",
	"belakor_crystal_socket"
}
var_0_0.mutators = {
	"challenge_test",
	"arena_belakor_script",
	"curse_belakors_shadows",
	"curse_shadow_daggers",
	"curse_shadow_homing_skulls",
	"curse_belakor_totems",
	"curse_grey_wings"
}
var_0_0.effects = {
	"fx/cursed_chest_spawn_01_portal",
	"fx/blk_grey_wings_01",
	"fx/blk_grey_wings_spawn_01",
	"fx/blk_grey_wings_teleport_01",
	"fx/blk_grey_wings_teleport_direction_01",
	"fx/trail_locus"
}
var_0_0.dialogue_event_data_lookup = {
	"belakor_crystal"
}
var_0_0.ai_group_templates = {
	deus_belakor_locus_cultists = {
		setup_group = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			arg_21_2.idle = true
		end,
		init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			return
		end,
		update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			return
		end,
		destroy = function (arg_24_0, arg_24_1, arg_24_2)
			Managers.state.event:trigger("deus_belakor_locus_cultists_killed", arg_24_2.id)
		end,
		wake_up_group = function (arg_25_0, arg_25_1)
			arg_25_0.idle = false

			Managers.state.event:trigger("deus_belakor_locus_cultists_aggroed", arg_25_0.id)
			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_25_0, AIGroupTemplates.deus_belakor_locus_cultists.wake_up_unit, arg_25_1)
		end,
		wake_up_unit = function (arg_26_0, arg_26_1, arg_26_2)
			Managers.state.network:anim_event(arg_26_0, "idle")

			local var_26_0 = ScriptUnit.extension(arg_26_0, "ai_system")

			var_26_0:enemy_aggro(nil, arg_26_2)

			local var_26_1 = var_26_0._breed

			var_26_0:set_perception(var_26_1.perception, var_26_1.target_selection)

			local var_26_2 = BLACKBOARDS[arg_26_0]

			var_26_2.ignore_interest_points = false
			var_26_2.only_trust_your_own_eyes = false

			local var_26_3 = var_26_2.optional_spawn_data

			if var_26_3 then
				var_26_3.idle_animation = nil
			end
		end
	}
}
var_0_0.death_reactions = {
	"scripts/settings/dlcs/belakor/belakor_death_reactions"
}
var_0_0.interactions = {
	"deus_belakor_locus_pre_crystal",
	"deus_belakor_locus_with_crystal"
}
var_0_0.interactions_filenames = {
	"scripts/settings/dlcs/belakor/belakor_interactions"
}
var_0_0.hit_effects = {
	"scripts/settings/hit_effects/hit_effects_shadow_totem",
	"scripts/settings/hit_effects/hit_effects_shadow_skull"
}
