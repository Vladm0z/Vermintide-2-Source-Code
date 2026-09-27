-- chunkname: @scripts/settings/dlcs/belakor/belakor_common_settings.lua

local belakor = DLCSettings.belakor

belakor.additional_system_extensions = {
	pickup_system = {
		{
			require = "scripts/unit_extensions/pickups/orb_pickup_unit_extension",
			class = "OrbPickupUnitExtension"
		}
	}
}
belakor.pickup_system_extension_update = {
	"OrbPickupUnitExtension"
}
belakor.unit_extension_templates = {
	"scripts/settings/dlcs/belakor/belakor_extension_templates"
}
belakor.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_belakor"
}
belakor.anim_lookup = {
	"spawn_chaos_champion_01",
	"spawn_chaos_champion_02",
	"spawn_chaos_champion_03",
	"spawn_chaos_champion_04",
	"spawn_chaos_champion_05",
	"insert_locus_crystal"
}
belakor.husk_lookup = {
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
belakor.game_object_initializers = {
	orb_pickup_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local extension = ScriptUnit.extension(arg_1_0, "pickup_system")
		local pickup_name = extension.pickup_name
		local has_physics = extension.has_physics
		local spawn_type = extension.spawn_type
		local get_orb_flight_target_position = extension:get_orb_flight_target_position()
		local tbl = {
			go_type = NetworkLookup.go_types.orb_pickup_unit,
			husk_unit = NetworkLookup.husks[arg_1_1],
			pickup_name = NetworkLookup.pickup_names[pickup_name],
			has_physics = has_physics,
			spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			orb_flight_target_position = not get_orb_flight_target_position and get_orb_flight_target_position:unbox()
		}
		local flag

		flag = not get_orb_flight_target_position and true and false
		tbl.flight_enabled = flag

		return tbl
	end,
	shadow_dagger_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local extension = ScriptUnit.extension(arg_2_0, "projectile_locomotion_system")
		local angle = extension.angle
		local speed = extension.speed
		local gravity_settings = extension.gravity_settings
		local target_vector = extension.target_vector
		local unbox = extension.initial_position_boxed:unbox()
		local trajectory_template_name = extension.trajectory_template_name
		local rotation_speed = extension.rotation_speed
		local rotate_around_forward = extension.rotate_around_forward
		local start_paused_for_time = extension.start_paused_for_time
		local extension_2 = ScriptUnit.extension(arg_2_0, "projectile_impact_system")
		local collision_filter = extension_2.collision_filter
		local sphere_radius = extension_2.sphere_radius
		local only_one_impact = extension_2.only_one_impact
		local owner_unit = extension_2.owner_unit
		local extension_3 = ScriptUnit.extension(arg_2_0, "projectile_system")
		local impact_template_name = extension_3.impact_template_name
		local damage_source = extension_3.damage_source
		local network = Managers.state.network

		return {
			go_type = NetworkLookup.go_types.shadow_dagger_unit,
			husk_unit = NetworkLookup.husks[arg_2_1],
			angle = angle,
			speed = speed,
			gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
			initial_position = unbox,
			target_vector = target_vector,
			trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
			owner_unit = network:unit_game_object_id(owner_unit),
			rotate_around_forward = rotate_around_forward,
			rotation_speed = rotation_speed,
			start_paused_for_time = start_paused_for_time,
			collision_filter = NetworkLookup.collision_filters[collision_filter],
			sphere_radius = sphere_radius,
			only_one_impact = only_one_impact,
			impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
			damage_source_id = NetworkLookup.damage_sources[damage_source]
		}
	end,
	shadow_skull_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		local get_data = Unit.get_data(arg_3_0, "breed")
		local side_id = Managers.state.side.side_by_unit[arg_3_0].side_id
		local get_max_health = ScriptUnit.has_extension(arg_3_0, "health_system"):get_max_health()

		return {
			go_type = NetworkLookup.go_types.shadow_skull_unit,
			position = Unit.local_position(arg_3_0, 0),
			rotation = Unit.local_rotation(arg_3_0, 0),
			husk_unit = NetworkLookup.husks[arg_3_1],
			health = get_max_health,
			breed_name = NetworkLookup.breeds[get_data.name],
			bt_action_name = NetworkLookup.bt_action_names["n/a"],
			side_id = side_id
		}
	end,
	arena_belakor_big_statue_health = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local has_extension = ScriptUnit.has_extension(arg_4_0, "health_system")

		return {
			go_type = NetworkLookup.go_types.arena_belakor_big_statue_health,
			husk_unit = NetworkLookup.husks[arg_4_1],
			position = Unit.local_position(arg_4_0, 0),
			rotation = Unit.local_rotation(arg_4_0, 0),
			health = has_extension:get_max_health()
		}
	end,
	deus_belakor_locus = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		return {
			go_type = NetworkLookup.go_types.deus_belakor_locus,
			husk_unit = NetworkLookup.husks[arg_5_1],
			position = Unit.local_position(arg_5_0, 0),
			rotation = Unit.local_rotation(arg_5_0, 0)
		}
	end,
	belakor_crystal = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local extension = ScriptUnit.extension(arg_6_0, "pickup_system")
		local pickup_name = extension.pickup_name
		local has_physics = extension.has_physics
		local spawn_type = extension.spawn_type

		return {
			go_type = NetworkLookup.go_types.belakor_crystal,
			husk_unit = NetworkLookup.husks[arg_6_1],
			position = Unit.local_position(arg_6_0, 0),
			rotation = Unit.local_rotation(arg_6_0, 0),
			debug_pos = Unit.local_position(arg_6_0, 0),
			pickup_name = NetworkLookup.pickup_names[pickup_name],
			has_physics = has_physics,
			spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
		}
	end,
	belakor_crystal_throw = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		local extension = ScriptUnit.extension(arg_7_0, "projectile_locomotion_system")
		local network_position = extension.network_position
		local network_rotation = extension.network_rotation
		local network_velocity = extension.network_velocity
		local network_angular_velocity = extension.network_angular_velocity
		local extension_2 = ScriptUnit.extension(arg_7_0, "pickup_system")
		local pickup_name = extension_2.pickup_name
		local has_physics = extension_2.has_physics
		local spawn_type = extension_2.spawn_type

		return {
			go_type = NetworkLookup.go_types.belakor_crystal_throw,
			husk_unit = NetworkLookup.husks[arg_7_1],
			position = Unit.local_position(arg_7_0, 0),
			rotation = Unit.local_rotation(arg_7_0, 0),
			network_position = network_position,
			network_rotation = network_rotation,
			network_velocity = network_velocity,
			network_angular_velocity = network_angular_velocity,
			debug_pos = Unit.local_position(arg_7_0, 0),
			pickup_name = NetworkLookup.pickup_names[pickup_name],
			has_physics = has_physics,
			spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
		}
	end,
	belakor_totem = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		local get_data = Unit.get_data(arg_8_0, "breed")
		local side_id = Managers.state.side.side_by_unit[arg_8_0].side_id
		local has_extension = ScriptUnit.has_extension(arg_8_0, "health_system")

		return {
			go_type = NetworkLookup.go_types.belakor_totem,
			husk_unit = NetworkLookup.husks[arg_8_1],
			position = Unit.local_position(arg_8_0, 0),
			rotation = Unit.local_rotation(arg_8_0, 0),
			health = has_extension:get_max_health(),
			breed_name = NetworkLookup.breeds[get_data.name],
			bt_action_name = NetworkLookup.bt_action_names["n/a"],
			side_id = side_id
		}
	end,
	shadow_homing_skulls_spawner = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		return {
			go_type = NetworkLookup.go_types.shadow_homing_skulls_spawner,
			husk_unit = NetworkLookup.husks[arg_9_1],
			position = Unit.local_position(arg_9_0, 0),
			rotation = Unit.local_rotation(arg_9_0, 0)
		}
	end,
	belakor_crystal_socket = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		return {
			go_type = NetworkLookup.go_types.belakor_crystal_socket,
			husk_unit = NetworkLookup.husks[arg_10_1],
			position = Unit.local_position(arg_10_0, 0),
			rotation = Unit.local_rotation(arg_10_0, 0)
		}
	end
}
belakor.game_object_extractors = {
	orb_pickup_unit = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		local game_object_field = GameSession.game_object_field(arg_11_0, arg_11_1, "pickup_name")
		local game_object_field_2 = GameSession.game_object_field(arg_11_0, arg_11_1, "has_physics")
		local game_object_field_3 = GameSession.game_object_field(arg_11_0, arg_11_1, "spawn_type")
		local game_object_field_4 = GameSession.game_object_field(arg_11_0, arg_11_1, "orb_flight_target_position")
		local game_object_field_5 = GameSession.game_object_field(arg_11_0, arg_11_1, "flight_enabled")
		local tbl = {
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[game_object_field],
				has_physics = game_object_field_2,
				spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3],
				orb_flight_target_position = not game_object_field_4 and Vector3Box(game_object_field_4),
				flight_enabled = game_object_field_5
			}
		}

		return "orb_pickup_unit", tbl
	end,
	shadow_dagger_unit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		local game_object_field = GameSession.game_object_field(arg_12_0, arg_12_1, "angle")
		local game_object_field_2 = GameSession.game_object_field(arg_12_0, arg_12_1, "speed")
		local game_object_field_3 = GameSession.game_object_field(arg_12_0, arg_12_1, "gravity_settings")
		local game_object_field_4 = GameSession.game_object_field(arg_12_0, arg_12_1, "target_vector")
		local game_object_field_5 = GameSession.game_object_field(arg_12_0, arg_12_1, "initial_position")
		local game_object_field_6 = GameSession.game_object_field(arg_12_0, arg_12_1, "trajectory_template_name")
		local game_object_field_7 = GameSession.game_object_field(arg_12_0, arg_12_1, "owner_unit")
		local game_object_field_8 = GameSession.game_object_field(arg_12_0, arg_12_1, "rotation_speed")
		local game_object_field_9 = GameSession.game_object_field(arg_12_0, arg_12_1, "rotate_around_forward")
		local game_object_field_10 = GameSession.game_object_field(arg_12_0, arg_12_1, "start_paused_for_time")
		local game_object_field_11 = GameSession.game_object_field(arg_12_0, arg_12_1, "only_one_impact")
		local game_object_field_12 = GameSession.game_object_field(arg_12_0, arg_12_1, "sphere_radius")
		local game_object_field_13 = GameSession.game_object_field(arg_12_0, arg_12_1, "collision_filter")
		local game_object_field_14 = GameSession.game_object_field(arg_12_0, arg_12_1, "impact_template_name")
		local game_object_field_15 = GameSession.game_object_field(arg_12_0, arg_12_1, "damage_source_id")
		local unit = Managers.state.unit_storage:unit(game_object_field_7)
		local tbl = {
			projectile_locomotion_system = {
				is_husk = true,
				angle = game_object_field,
				speed = game_object_field_2,
				gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_3],
				target_vector = game_object_field_4,
				initial_position = game_object_field_5,
				trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_6],
				rotation_speed = game_object_field_8,
				rotate_around_forward = game_object_field_9,
				start_paused_for_time = game_object_field_10
			},
			projectile_impact_system = {
				collision_filter = NetworkLookup.collision_filters[game_object_field_13],
				only_one_impact = game_object_field_11,
				sphere_radius = game_object_field_12,
				owner_unit = unit
			},
			projectile_system = {
				impact_template_name = NetworkLookup.projectile_templates[game_object_field_14],
				owner_unit = unit,
				damage_source = NetworkLookup.damage_sources[game_object_field_15]
			},
			locomotion_system = {}
		}

		return "shadow_dagger_unit", tbl
	end,
	shadow_skull_unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		-- function 13
		local game_object_field = GameSession.game_object_field(arg_13_0, arg_13_1, "breed_name")
		local game_object_field_2 = GameSession.game_object_field(arg_13_0, arg_13_1, "side_id")
		local game_object_field_3 = GameSession.game_object_field(arg_13_0, arg_13_1, "health")
		local var_13_3 = NetworkLookup.breeds[game_object_field]
		local var_13_4 = Breeds[var_13_3]

		Unit.set_data(arg_13_3, "breed", var_13_4)

		local tbl = {
			ai_system = {
				go_id = arg_13_1,
				game = arg_13_0,
				side_id = game_object_field_2
			},
			health_system = {
				health = game_object_field_3
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
		local flag = true

		var_13_4.modify_extension_init_data(var_13_4, flag, tbl)

		return var_13_4.unit_template, tbl
	end,
	arena_belakor_big_statue_health = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		local game_object_field = GameSession.game_object_field(arg_14_0, arg_14_1, "health")
		local str = "arena_belakor_big_statue_health"
		local tbl = {
			health_system = {
				health = game_object_field
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

		return str, tbl
	end,
	deus_belakor_locus = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		-- function 15
		local str = "deus_belakor_locus"
		local deus_02 = AllPickups.deus_02
		local tbl = {}

		table.merge_recursive(tbl, deus_02.additional_data_husk)

		return str, tbl
	end,
	belakor_crystal = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		local game_object_field = GameSession.game_object_field(arg_16_0, arg_16_1, "pickup_name")
		local game_object_field_2 = GameSession.game_object_field(arg_16_0, arg_16_1, "has_physics")
		local game_object_field_3 = GameSession.game_object_field(arg_16_0, arg_16_1, "spawn_type")
		local tbl = {
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[game_object_field],
				has_physics = game_object_field_2,
				spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3]
			}
		}

		return "belakor_crystal", tbl
	end,
	belakor_crystal_throw = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		-- function 17
		local game_object_field = GameSession.game_object_field(arg_17_0, arg_17_1, "network_position")
		local game_object_field_2 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_rotation")
		local game_object_field_3 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_velocity")
		local game_object_field_4 = GameSession.game_object_field(arg_17_0, arg_17_1, "network_angular_velocity")
		local game_object_field_5 = GameSession.game_object_field(arg_17_0, arg_17_1, "pickup_name")
		local game_object_field_6 = GameSession.game_object_field(arg_17_0, arg_17_1, "has_physics")
		local game_object_field_7 = GameSession.game_object_field(arg_17_0, arg_17_1, "spawn_type")
		local tbl = {
			projectile_locomotion_system = {
				network_position = game_object_field,
				network_rotation = game_object_field_2,
				network_velocity = game_object_field_3,
				network_angular_velocity = game_object_field_4
			},
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[game_object_field_5],
				has_physics = game_object_field_6,
				spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
			}
		}

		return "belakor_crystal_throw", tbl
	end,
	belakor_totem = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		-- function 18
		local game_object_field = GameSession.game_object_field(arg_18_0, arg_18_1, "breed_name")
		local game_object_field_2 = GameSession.game_object_field(arg_18_0, arg_18_1, "side_id")
		local game_object_field_3 = GameSession.game_object_field(arg_18_0, arg_18_1, "health")
		local var_18_3 = NetworkLookup.breeds[game_object_field]
		local var_18_4 = Breeds[var_18_3]

		Unit.set_data(arg_18_3, "breed", var_18_4)

		local tbl = {
			ai_system = {
				go_id = arg_18_1,
				game = arg_18_0,
				side_id = game_object_field_2
			},
			health_system = {
				health = game_object_field_3
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
		local flag = true

		var_18_4.modify_extension_init_data(var_18_4, flag, tbl)

		return var_18_4.unit_template, tbl
	end,
	shadow_homing_skulls_spawner = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		-- function 19
		local tbl = {}

		return "shadow_homing_skulls_spawner", tbl
	end,
	belakor_crystal_socket = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		-- function 20
		local tbl = {}

		return "belakor_crystal_socket", tbl
	end
}
belakor.game_object_templates = {
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
belakor.entity_extensions = {
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
belakor.systems = {
	"scripts/entity_system/systems/orb/orb_system"
}
belakor.entity_system_params = {
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
belakor.network_damage_sources = {
	"tiny_explosive_barrel"
}
belakor.network_go_types = {
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
belakor.mutators = {
	"challenge_test",
	"arena_belakor_script",
	"curse_belakors_shadows",
	"curse_shadow_daggers",
	"curse_shadow_homing_skulls",
	"curse_belakor_totems",
	"curse_grey_wings"
}
belakor.effects = {
	"fx/cursed_chest_spawn_01_portal",
	"fx/blk_grey_wings_01",
	"fx/blk_grey_wings_spawn_01",
	"fx/blk_grey_wings_teleport_01",
	"fx/blk_grey_wings_teleport_direction_01",
	"fx/trail_locus"
}
belakor.dialogue_event_data_lookup = {
	"belakor_crystal"
}
belakor.ai_group_templates = {
	deus_belakor_locus_cultists = {
		setup_group = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			-- function 21
			arg_21_2.idle = true
		end,
		init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			-- function 22
			return
		end,
		update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			-- function 23
			return
		end,
		destroy = function (arg_24_0, arg_24_1, arg_24_2)
			-- function 24
			Managers.state.event:trigger("deus_belakor_locus_cultists_killed", arg_24_2.id)
		end,
		wake_up_group = function (self, arg_25_1)
			-- function 25
			self.idle = false

			Managers.state.event:trigger("deus_belakor_locus_cultists_aggroed", self.id)
			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(self, AIGroupTemplates.deus_belakor_locus_cultists.wake_up_unit, arg_25_1)
		end,
		wake_up_unit = function (arg_26_0, arg_26_1, arg_26_2)
			-- function 26
			Managers.state.network:anim_event(arg_26_0, "idle")

			local extension = ScriptUnit.extension(arg_26_0, "ai_system")

			extension:enemy_aggro(nil, arg_26_2)

			local _breed = extension._breed

			extension:set_perception(_breed.perception, _breed.target_selection)

			local var_26_2 = BLACKBOARDS[arg_26_0]

			var_26_2.ignore_interest_points = false
			var_26_2.only_trust_your_own_eyes = false

			local optional_spawn_data = var_26_2.optional_spawn_data

			if not optional_spawn_data then
				optional_spawn_data.idle_animation = nil
			end
		end
	}
}
belakor.death_reactions = {
	"scripts/settings/dlcs/belakor/belakor_death_reactions"
}
belakor.interactions = {
	"deus_belakor_locus_pre_crystal",
	"deus_belakor_locus_with_crystal"
}
belakor.interactions_filenames = {
	"scripts/settings/dlcs/belakor/belakor_interactions"
}
belakor.hit_effects = {
	"scripts/settings/hit_effects/hit_effects_shadow_totem",
	"scripts/settings/hit_effects/hit_effects_shadow_skull"
}
