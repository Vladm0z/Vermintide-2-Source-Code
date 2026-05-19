-- chunkname: @scripts/settings/spawn_unit_templates_vs.lua

local var_0_0 = {
	troll_puke = {
		spawn_func = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			arg_1_2 = QuaternionBox(arg_1_2)
			arg_1_1 = Vector3Box(arg_1_1)

			local function var_1_0()
				local var_2_0 = Quaternion.forward(arg_1_2:unbox())
				local var_2_1 = {
					area_damage_system = {
						flow_dir = var_2_0,
						liquid_template = arg_1_3 == 1 and "vs_bile_troll_vomit_near" or "vs_bile_troll_vomit",
						source_unit = arg_1_0
					}
				}
				local var_2_2 = "units/hub_elements/empty"
				local var_2_3 = Managers.state.unit_spawner:spawn_network_unit(var_2_2, "liquid_aoe_unit", var_2_1, arg_1_1:unbox())

				ScriptUnit.extension(var_2_3, "area_damage_system"):ready()
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_1_0)
		end
	},
	vortex = {
		spawn_func = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = BLACKBOARDS[arg_3_0]

			if not var_3_0 then
				var_3_0 = {}
				BLACKBOARDS[arg_3_0] = var_3_0
			end

			var_3_0.world = var_3_0.world or Managers.state.conflict._world

			local var_3_1 = Managers.time:time("game")
			local var_3_2 = 0
			local var_3_3 = BreedActions.chaos_vortex_sorcerer.spawn_vortex

			var_3_0.action = var_3_3

			if not var_3_0.vortex_data then
				local var_3_4 = "carousel"

				BTChaosSorcererSkulkApproachAction.initialize_vortex_data(nil, var_3_0, var_3_4)
			end

			local var_3_5 = var_3_0.vortex_data

			var_3_5.vortex_spawn_pos:store(arg_3_1)

			var_3_5.vortex_spawn_radius = 10
			var_3_5.spawn_timer = var_3_1 + 25

			local var_3_6 = var_3_5.vortex_template
			local var_3_7 = var_3_5.vortex_spawn_pos:unbox()
			local var_3_8 = var_3_5.vortex_spawn_radius
			local var_3_9 = math.min(var_3_8 / var_3_6.full_inner_radius, 1)

			if arg_3_3 == 0 then
				local var_3_10 = var_3_3.inner_decal_unit_name

				if var_3_10 then
					local var_3_11 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_3_7)
					local var_3_12 = math.max(var_3_6.min_inner_radius, var_3_9 * var_3_6.full_inner_radius)

					Matrix4x4.set_scale(var_3_11, Vector3(var_3_12, var_3_12, var_3_12))

					var_3_5.inner_decal_unit = Managers.state.unit_spawner:spawn_network_unit(var_3_10, "network_synched_dummy_unit", nil, var_3_11)
				end

				local var_3_13 = var_3_3.outer_decal_unit_name

				if var_3_13 then
					local var_3_14 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_3_7)
					local var_3_15 = math.max(var_3_6.min_outer_radius, var_3_9 * var_3_6.full_outer_radius)

					Matrix4x4.set_scale(var_3_14, Vector3(var_3_15, var_3_15, var_3_15))

					var_3_5.outer_decal_unit = Managers.state.unit_spawner:spawn_network_unit(var_3_13, "network_synched_dummy_unit", nil, var_3_14)
				end
			end

			BTChaosSorcererSummoningAction._spawn_vortex(nil, arg_3_0, var_3_0, var_3_1, var_3_2, arg_3_1, var_3_0.vortex_data)
		end
	},
	vortex_dummy_missile = {
		spawn_func = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			local var_4_0 = BLACKBOARDS[arg_4_0]

			if not var_4_0 then
				var_4_0 = {}
				BLACKBOARDS[arg_4_0] = var_4_0
			end

			var_4_0.world = var_4_0.world or Managers.state.conflict._world
			var_4_0.vortex_data = var_4_0.vortex_data or {}

			local var_4_1 = var_4_0.vortex_data

			var_4_1.extra_time = 2
			var_4_1.max_height = 10
			var_4_1.num_dummy_missiles = 0

			local var_4_2 = BreedActions.chaos_vortex_sorcerer.spawn_vortex
			local var_4_3 = var_4_1.summon_position and var_4_1.summon_position:unbox() or POSITION_LOOKUP[arg_4_0]
			local var_4_4 = Quaternion.forward(arg_4_2)

			return BTChaosSorcererSummoningAction._launch_vortex_dummy_missile(nil, arg_4_0, var_4_2, var_4_1, arg_4_1, var_4_3, var_4_4)
		end
	}
}

table.merge_recursive(SpawnUnitTemplates, var_0_0)
