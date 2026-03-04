-- chunkname: @scripts/settings/dlcs/wizards/wizards_common_settings_part_2.lua

local var_0_0 = DLCSettings.wizards_part_2

var_0_0.entity_extensions = {
	"scripts/unit_extensions/wizards/ward_extension",
	"scripts/unit_extensions/wizards/shockwave_spell_extension"
}
var_0_0.entity_system_params = {
	ward_extension = {
		system_class_name = "WardSystem",
		system_name = "ward_system",
		extension_list = {
			"WardExtension"
		}
	},
	shockwave_spell_extension = {
		system_class_name = "ExtensionSystemBase",
		system_name = "shockwave_spell_extension",
		extension_list = {
			"ShockwaveSpellExtension"
		}
	}
}
var_0_0.systems = {
	"scripts/entity_system/systems/ward/ward_system"
}
var_0_0.unit_extension_templates = {
	"scripts/settings/dlcs/wizards/wizards_extension_templates_part_2"
}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_wizards_part_2"
}
var_0_0.statistics_lookup = {
	"tower_skulls",
	"tower_wall_illusions",
	"tower_invisible_bridge",
	"tower_enable_guardian_of_lustria",
	"tower_note_puzzle",
	"tower_created_all_potions",
	"tower_time_challenge"
}
var_0_0.network_go_types = {
	"pickup_projectile_wizards_barrel"
}
var_0_0.husk_lookup = {}
var_0_0.projectile_units = {
	vfx_scripted_projectile_unit = {
		dummy_linker_unit_name = "units/weapons/projectile/end_fight_tower/magic_missile_tower",
		transient_package_loader_ignore = true,
		projectile_unit_name = "units/weapons/projectile/end_fight_tower/magic_missile_tower"
	},
	sofia_vfx_scripted_projectile_unit = {
		dummy_linker_unit_name = "units/weapons/projectile/end_fight_tower/sofia_magic_missile_tower",
		transient_package_loader_ignore = true,
		projectile_unit_name = "units/weapons/projectile/end_fight_tower/sofia_magic_missile_tower"
	},
	olesya_vfx_scripted_projectile_unit = {
		dummy_linker_unit_name = "units/weapons/projectile/end_fight_tower/olesya_magic_missile_tower",
		transient_package_loader_ignore = true,
		projectile_unit_name = "units/weapons/projectile/end_fight_tower/olesya_magic_missile_tower"
	}
}
var_0_0.projectiles = {
	vfx_scripted_projectile_unit = {
		projectile_units_template = "vfx_scripted_projectile_unit",
		radius = 0.2,
		linear_dampening = 0,
		angle = 0,
		only_one_impact = true,
		gravity_settings = "gaze_fireball",
		projectile_unit_template_name = "vfx_scripted_projectile_unit",
		impact_template_name = "vfx_impact",
		impact_collision_filter = "filter_physics_projectile"
	}
}
var_0_0.effects = {
	"fx/ethereal_skulls_teleport_01"
}
var_0_0.unlock_settings = {
	wizards_part_2 = {
		class = "AlwaysUnlocked"
	}
}
var_0_0.unlock_settings_xb1 = {
	wizards_part_2 = {
		class = "AlwaysUnlocked"
	}
}
var_0_0.unlock_settings_ps4 = {
	CUSA13595_00 = {
		wizards_part_2 = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		wizards_part_2 = {
			class = "AlwaysUnlocked"
		}
	}
}
var_0_0.game_object_initializers = {
	vfx_scripted_projectile_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = ScriptUnit.extension(arg_1_0, "projectile_locomotion_system")
		local var_1_1 = var_1_0.angle
		local var_1_2 = var_1_0.target_vector
		local var_1_3 = var_1_0.initial_position_boxed:unbox()
		local var_1_4 = var_1_0.speed
		local var_1_5 = var_1_0.gravity_settings
		local var_1_6 = var_1_0.trajectory_template_name
		local var_1_7 = var_1_0.rotation_speed
		local var_1_8 = -(var_1_0.t - Managers.time:time("game"))
		local var_1_9 = "filter_environment_overlap"
		local var_1_10 = ScriptUnit.extension(arg_1_0, "projectile_system").impact_template_name

		return {
			sphere_radius = 0.5,
			only_one_impact = true,
			go_type = NetworkLookup.go_types.vfx_scripted_projectile_unit,
			husk_unit = NetworkLookup.husks[arg_1_1],
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			angle = var_1_1,
			initial_position = var_1_3,
			target_vector = var_1_2,
			speed = var_1_4,
			gravity_settings = NetworkLookup.projectile_gravity_settings[var_1_5],
			trajectory_template_name = NetworkLookup.projectile_templates[var_1_6],
			debug_pos = Unit.local_position(arg_1_0, 0),
			fast_forward_time = var_1_8,
			impact_template_name = NetworkLookup.projectile_templates[var_1_10],
			collision_filter = var_1_9
		}
	end
}
var_0_0.game_object_extractors = {
	vfx_scripted_projectile_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = GameSession.game_object_field(arg_2_0, arg_2_1, "angle")
		local var_2_1 = GameSession.game_object_field(arg_2_0, arg_2_1, "target_vector")
		local var_2_2 = GameSession.game_object_field(arg_2_0, arg_2_1, "initial_position")
		local var_2_3 = GameSession.game_object_field(arg_2_0, arg_2_1, "speed")
		local var_2_4 = GameSession.game_object_field(arg_2_0, arg_2_1, "gravity_settings")
		local var_2_5 = GameSession.game_object_field(arg_2_0, arg_2_1, "trajectory_template_name")
		local var_2_6 = Managers.time:time("game")
		local var_2_7 = GameSession.game_object_field(arg_2_0, arg_2_1, "fast_forward_time")
		local var_2_8 = GameSession.game_object_field(arg_2_0, arg_2_1, "impact_template_name")
		local var_2_9 = "filter_environment_overlap"
		local var_2_10 = {
			projectile_locomotion_system = {
				is_husk = true,
				angle = var_2_0,
				speed = var_2_3,
				target_vector = var_2_1,
				initial_position = var_2_2,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_2_4],
				trajectory_template_name = NetworkLookup.projectile_templates[var_2_5],
				fast_forward_time = var_2_7
			},
			projectile_impact_system = {
				only_one_impact = true,
				sphere_radius = 0.5,
				collision_filter = var_2_9
			},
			projectile_system = {
				impact_template_name = NetworkLookup.projectile_templates[var_2_8],
				time_initialized = var_2_6
			}
		}

		return "vfx_scripted_projectile_unit", var_2_10
	end
}
var_0_0.ai_group_templates = {
	destructible_defenders = {
		setup_group = function (arg_3_0, arg_3_1, arg_3_2)
			return
		end,
		init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			return
		end,
		update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			return
		end,
		destroy = function (arg_6_0, arg_6_1, arg_6_2)
			return
		end,
		set_group_aggressive = function (arg_7_0, arg_7_1)
			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_7_0, AIGroupTemplates.destructible_defenders.set_unit_aggressive, arg_7_1)
		end,
		set_unit_aggressive = function (arg_8_0, arg_8_1, arg_8_2)
			if not ALIVE[arg_8_0] then
				return
			end

			local var_8_0 = BLACKBOARDS[arg_8_0]

			if arg_8_2 then
				ScriptUnit.extension(arg_8_0, "ai_system"):enemy_aggro(nil, arg_8_2)
			end

			AiUtils.activate_unit(var_8_0)

			var_8_0.defend = false
		end
	},
	ethereal_skulls = {
		try_spawn_group = function (arg_9_0, arg_9_1)
			local var_9_0 = AIGroupTemplates.ethereal_skulls
			local var_9_1 = var_9_0.last_state

			if arg_9_0 ~= "picked_up" or var_9_1 ~= "spawned" then
				return
			end

			var_9_0.last_state = arg_9_0

			if not var_9_0.group_size then
				local var_9_2 = Managers.state.difficulty:get_difficulty_index()

				var_9_0.group_size = DLCSettings.wizards_part_2.ethereal_skull_settings.num_spawned_per_difficulty[var_9_2]
			end

			local var_9_3 = var_9_0.group_id
			local var_9_4 = var_9_0.group_size
			local var_9_5 = Managers.state.entity:system("ai_group_system"):get_ai_group(var_9_3)

			if not var_9_3 or not var_9_5 then
				var_9_0.create_group(var_9_0, arg_9_0, arg_9_1, var_9_4)

				return
			end

			local var_9_6 = var_9_4 - table.size(var_9_5.members)

			if var_9_6 > 0 then
				var_9_5.num_spawned_members = var_9_5.num_spawned_members - var_9_6

				var_9_0.add_group_members(arg_9_0, arg_9_1, var_9_3, var_9_4, var_9_6)
			end
		end,
		create_group = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			local var_10_0 = Managers.state.entity:system("ai_group_system"):generate_group_id()

			arg_10_0.group_id = var_10_0

			arg_10_0.add_group_members(arg_10_1, arg_10_2, var_10_0, arg_10_3, arg_10_3)
		end,
		init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			return
		end,
		update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			return
		end,
		destroy = function (arg_13_0, arg_13_1, arg_13_2)
			return
		end,
		add_group_members = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			local var_14_0 = Vector3(20.5, 76.7, 155.5)
			local var_14_1 = {
				sofia_unit_pos = Vector3Box(var_14_0),
				target = arg_14_1,
				prepare_func = function (arg_15_0, arg_15_1)
					local var_15_0 = false

					arg_15_0.modify_extension_init_data(arg_15_0, var_15_0, arg_15_1)
				end,
				spawned_func = function (arg_16_0, arg_16_1, arg_16_2)
					local var_16_0 = BLACKBOARDS[arg_16_0]

					if var_16_0 then
						var_16_0.sofia_unit_pos = arg_16_2.sofia_unit_pos
						var_16_0.target = arg_16_2.target
					end
				end
			}
			local var_14_2 = {
				template = "ethereal_skulls",
				id = arg_14_2,
				size = arg_14_3
			}
			local var_14_3 = Vector3.up()
			local var_14_4 = Vector3.right()
			local var_14_5 = Quaternion.identity()
			local var_14_6 = Vector3(0, 0, 3)
			local var_14_7 = 3
			local var_14_8 = math.pi * 2 / arg_14_4

			for iter_14_0 = 1, arg_14_4 do
				local var_14_9 = var_14_0 + (Quaternion.rotate(Quaternion(var_14_3, var_14_8 * iter_14_0), var_14_4) * var_14_7 + var_14_6)

				var_14_6.z = var_14_6.z + 0.3

				local var_14_10 = "fx/ethereal_skulls_teleport_01"

				if var_14_10 then
					local var_14_11 = NetworkLookup.effects[var_14_10]
					local var_14_12 = 0
					local var_14_13 = Quaternion.identity()

					Managers.state.network:rpc_play_particle_effect(nil, var_14_11, NetworkConstants.invalid_game_object_id, var_14_12, var_14_9, var_14_13, false)
				end

				Managers.state.conflict:spawn_queued_unit(Breeds.tower_homing_skull, Vector3Box(var_14_9), QuaternionBox(var_14_5), nil, "spawn_idle", nil, var_14_1, var_14_2)
			end
		end
	}
}
