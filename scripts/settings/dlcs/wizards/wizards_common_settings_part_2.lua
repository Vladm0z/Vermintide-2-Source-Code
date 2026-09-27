-- chunkname: @scripts/settings/dlcs/wizards/wizards_common_settings_part_2.lua

local wizards_part_2 = DLCSettings.wizards_part_2

wizards_part_2.entity_extensions = {
	"scripts/unit_extensions/wizards/ward_extension",
	"scripts/unit_extensions/wizards/shockwave_spell_extension"
}
wizards_part_2.entity_system_params = {
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
wizards_part_2.systems = {
	"scripts/entity_system/systems/ward/ward_system"
}
wizards_part_2.unit_extension_templates = {
	"scripts/settings/dlcs/wizards/wizards_extension_templates_part_2"
}
wizards_part_2.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_wizards_part_2"
}
wizards_part_2.statistics_lookup = {
	"tower_skulls",
	"tower_wall_illusions",
	"tower_invisible_bridge",
	"tower_enable_guardian_of_lustria",
	"tower_note_puzzle",
	"tower_created_all_potions",
	"tower_time_challenge"
}
wizards_part_2.network_go_types = {
	"pickup_projectile_wizards_barrel"
}
wizards_part_2.husk_lookup = {}
wizards_part_2.projectile_units = {
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
wizards_part_2.projectiles = {
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
wizards_part_2.effects = {
	"fx/ethereal_skulls_teleport_01"
}
wizards_part_2.unlock_settings = {
	wizards_part_2 = {
		class = "AlwaysUnlocked"
	}
}
wizards_part_2.unlock_settings_xb1 = {
	wizards_part_2 = {
		class = "AlwaysUnlocked"
	}
}
wizards_part_2.unlock_settings_ps4 = {
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
wizards_part_2.game_object_initializers = {
	vfx_scripted_projectile_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local extension = ScriptUnit.extension(arg_1_0, "projectile_locomotion_system")
		local angle = extension.angle
		local target_vector = extension.target_vector
		local unbox = extension.initial_position_boxed:unbox()
		local speed = extension.speed
		local gravity_settings = extension.gravity_settings
		local trajectory_template_name = extension.trajectory_template_name
		local rotation_speed = extension.rotation_speed
		local num = -(extension.t - Managers.time:time("game"))
		local str = "filter_environment_overlap"
		local impact_template_name = ScriptUnit.extension(arg_1_0, "projectile_system").impact_template_name

		return {
			sphere_radius = 0.5,
			only_one_impact = true,
			go_type = NetworkLookup.go_types.vfx_scripted_projectile_unit,
			husk_unit = NetworkLookup.husks[arg_1_1],
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			angle = angle,
			initial_position = unbox,
			target_vector = target_vector,
			speed = speed,
			gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
			trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
			debug_pos = Unit.local_position(arg_1_0, 0),
			fast_forward_time = num,
			impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
			collision_filter = str
		}
	end
}
wizards_part_2.game_object_extractors = {
	vfx_scripted_projectile_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local game_object_field = GameSession.game_object_field(arg_2_0, arg_2_1, "angle")
		local game_object_field_2 = GameSession.game_object_field(arg_2_0, arg_2_1, "target_vector")
		local game_object_field_3 = GameSession.game_object_field(arg_2_0, arg_2_1, "initial_position")
		local game_object_field_4 = GameSession.game_object_field(arg_2_0, arg_2_1, "speed")
		local game_object_field_5 = GameSession.game_object_field(arg_2_0, arg_2_1, "gravity_settings")
		local game_object_field_6 = GameSession.game_object_field(arg_2_0, arg_2_1, "trajectory_template_name")
		local time = Managers.time:time("game")
		local game_object_field_7 = GameSession.game_object_field(arg_2_0, arg_2_1, "fast_forward_time")
		local game_object_field_8 = GameSession.game_object_field(arg_2_0, arg_2_1, "impact_template_name")
		local str = "filter_environment_overlap"
		local tbl = {
			projectile_locomotion_system = {
				is_husk = true,
				angle = game_object_field,
				speed = game_object_field_4,
				target_vector = game_object_field_2,
				initial_position = game_object_field_3,
				gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_5],
				trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_6],
				fast_forward_time = game_object_field_7
			},
			projectile_impact_system = {
				only_one_impact = true,
				sphere_radius = 0.5,
				collision_filter = str
			},
			projectile_system = {
				impact_template_name = NetworkLookup.projectile_templates[game_object_field_8],
				time_initialized = time
			}
		}

		return "vfx_scripted_projectile_unit", tbl
	end
}
wizards_part_2.ai_group_templates = {
	destructible_defenders = {
		setup_group = function (arg_3_0, arg_3_1, arg_3_2)
			-- function 3
			return
		end,
		init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			return
		end,
		update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			return
		end,
		destroy = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			return
		end,
		set_group_aggressive = function (arg_7_0, arg_7_1)
			-- function 7
			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_7_0, AIGroupTemplates.destructible_defenders.set_unit_aggressive, arg_7_1)
		end,
		set_unit_aggressive = function (arg_8_0, arg_8_1, arg_8_2)
			-- function 8
			if not ALIVE[arg_8_0] then
				return
			end

			local var_8_0 = BLACKBOARDS[arg_8_0]

			if not arg_8_2 then
				ScriptUnit.extension(arg_8_0, "ai_system"):enemy_aggro(nil, arg_8_2)
			end

			AiUtils.activate_unit(var_8_0)

			var_8_0.defend = false
		end
	},
	ethereal_skulls = {
		try_spawn_group = function (arg_9_0, arg_9_1)
			-- function 9
			local ethereal_skulls = AIGroupTemplates.ethereal_skulls
			local last_state = ethereal_skulls.last_state

			if not (arg_9_0 ~= "picked_up" or last_state == "spawned") then
				return
			end

			ethereal_skulls.last_state = arg_9_0

			if not ethereal_skulls.group_size then
				local get_difficulty_index = Managers.state.difficulty:get_difficulty_index()

				ethereal_skulls.group_size = DLCSettings.wizards_part_2.ethereal_skull_settings.num_spawned_per_difficulty[get_difficulty_index]
			end

			local group_id = ethereal_skulls.group_id
			local group_size = ethereal_skulls.group_size
			local get_ai_group = Managers.state.entity:system("ai_group_system"):get_ai_group(group_id)

			if not (not group_id and get_ai_group) then
				ethereal_skulls.create_group(ethereal_skulls, arg_9_0, arg_9_1, group_size)

				return
			end

			local num = group_size - table.size(get_ai_group.members)

			if num > 0 then
				get_ai_group.num_spawned_members = get_ai_group.num_spawned_members - num

				ethereal_skulls.add_group_members(arg_9_0, arg_9_1, group_id, group_size, num)
			end
		end,
		create_group = function (self, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			local generate_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()

			self.group_id = generate_group_id

			self.add_group_members(arg_10_1, arg_10_2, generate_group_id, arg_10_3, arg_10_3)
		end,
		init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			-- function 11
			return
		end,
		update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			return
		end,
		destroy = function (arg_13_0, arg_13_1, arg_13_2)
			-- function 13
			return
		end,
		add_group_members = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			-- function 14
			local var_14_0 = Vector3(20.5, 76.7, 155.5)
			local tbl = {
				sofia_unit_pos = Vector3Box(var_14_0),
				target = arg_14_1,
				prepare_func = function (self, arg_15_1)
					-- function 15
					local flag = false

					self.modify_extension_init_data(self, flag, arg_15_1)
				end,
				spawned_func = function (arg_16_0, arg_16_1, arg_16_2)
					-- function 16
					local var_16_0 = BLACKBOARDS[arg_16_0]

					if not var_16_0 then
						var_16_0.sofia_unit_pos = arg_16_2.sofia_unit_pos
						var_16_0.target = arg_16_2.target
					end
				end
			}
			local tbl_2 = {
				template = "ethereal_skulls",
				id = arg_14_2,
				size = arg_14_3
			}
			local up = Vector3.up()
			local right = Vector3.right()
			local identity = Quaternion.identity()
			local var_14_6 = Vector3(0, 0, 3)
			local num = 3
			local num_2 = math.pi * 2 / arg_14_4

			for i = 1, arg_14_4 do
				local num_3 = var_14_0 + (Quaternion.rotate(Quaternion(up, num_2 * i), right) * num + var_14_6)

				var_14_6.z = var_14_6.z + 0.3

				local str = "fx/ethereal_skulls_teleport_01"

				if not str then
					local var_14_11 = NetworkLookup.effects[str]
					local num_4 = 0
					local identity_2 = Quaternion.identity()

					Managers.state.network:rpc_play_particle_effect(nil, var_14_11, NetworkConstants.invalid_game_object_id, num_4, num_3, identity_2, false)
				end

				Managers.state.conflict:spawn_queued_unit(Breeds.tower_homing_skull, Vector3Box(num_3), QuaternionBox(identity), nil, "spawn_idle", nil, tbl, tbl_2)
			end
		end
	}
}
