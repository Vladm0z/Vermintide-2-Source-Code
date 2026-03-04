-- chunkname: @scripts/settings/mutators/mutator_nurgle_storm.lua

return {
	description = "description_nurgle_storm",
	display_name = "display_name_nurgle_storm",
	icon = "mutator_icon_nurgle_storm",
	server_start_function = function (arg_1_0, arg_1_1)
		arg_1_1.spawn_nurgle_storm_at = Managers.time:time("game") + 30
		arg_1_1.vortex_template_name = "nurgle_storm_mutator"
		arg_1_1.vortex_template = VortexTemplates[arg_1_1.vortex_template_name]
		arg_1_1.inner_decal_unit_name = "units/decals/decal_vortex_circle_inner"
		arg_1_1.outer_decal_unit_name = "units/decals/decal_vortex_circle_outer"
		arg_1_1.storm_spawn_position = Vector3Box()
		arg_1_1.offset_spawn_distance = 20
		arg_1_1.delay_between_spawns = 5
		arg_1_1.unchecked_positions = {}
		arg_1_1.astar = GwNavAStar.create()
	end,
	server_pre_update_function = function (arg_2_0, arg_2_1)
		if Network.game_session() == nil or global_is_inside_inn then
			return
		end

		local var_2_0 = Managers.time:time("game")
		local var_2_1 = table.size(arg_2_1.unchecked_positions) > 0

		if arg_2_1.summoning_vortex_t and var_2_0 > arg_2_1.summoning_vortex_t and not ALIVE[arg_2_1.summoned_vortex_unit] then
			arg_2_1.template.spawn_storm(arg_2_1)
		elseif ALIVE[arg_2_1.summoned_vortex_unit] then
			arg_2_1.spawn_nurgle_storm_at = var_2_0 + arg_2_1.delay_between_spawns
		elseif var_2_0 > arg_2_1.spawn_nurgle_storm_at and not var_2_1 then
			local var_2_2 = Managers.state.conflict
			local var_2_3 = var_2_2.main_path_info
			local var_2_4 = math.random() > 0.5
			local var_2_5 = var_2_4 and var_2_3.ahead_unit or var_2_3.behind_unit

			if var_2_5 then
				local var_2_6 = Managers.state.entity:system("ai_system"):nav_world()
				local var_2_7 = arg_2_1.offset_spawn_distance
				local var_2_8 = var_2_2.main_path_player_info[var_2_5].travel_dist
				local var_2_9 = math.max(var_2_8 + var_2_7 * (var_2_4 and 1 or -1), 0)
				local var_2_10 = MainPathUtils.point_on_mainpath(nil, var_2_9)
				local var_2_11 = var_2_10 and LocomotionUtils.pos_on_mesh(var_2_6, var_2_10, 1, 1)
				local var_2_12 = POSITION_LOOKUP[var_2_5]
				local var_2_13 = var_2_10 and LocomotionUtils.pos_on_mesh(var_2_6, var_2_12, 1, 1)

				if not var_2_11 and var_2_10 then
					local var_2_14 = GwNavQueries.inside_position_from_outside_position(var_2_6, var_2_10, 6, 6, 8, 0.5)

					if var_2_14 then
						var_2_11 = var_2_14
					end
				end

				if not var_2_13 and var_2_12 then
					local var_2_15 = GwNavQueries.inside_position_from_outside_position(var_2_6, var_2_12, 6, 6, 8, 0.5)

					if var_2_15 then
						var_2_13 = var_2_15
					end
				end

				if var_2_11 and var_2_13 then
					local var_2_16 = var_2_8 + var_2_7 * 2 * (var_2_4 and -1 or 1)
					local var_2_17 = MainPathUtils.point_on_mainpath(nil, var_2_16)

					arg_2_1.unchecked_positions.storm_spawn_position = Vector3Box(var_2_11)
					arg_2_1.unchecked_positions.directed_wander_position = Vector3Box(var_2_17)
					arg_2_1.unchecked_positions.backup_storm_spawn_position = Vector3Box(var_2_13)

					local var_2_18 = Managers.state.bot_nav_transition:traverse_logic()

					GwNavAStar.start_with_propagation_box(arg_2_1.astar, var_2_6, var_2_11, var_2_17, 30, var_2_18)
				end
			else
				arg_2_1.spawn_nurgle_storm_at = var_2_0 + 1
			end
		end

		if var_2_1 and GwNavAStar.processing_finished(arg_2_1.astar) then
			local var_2_19 = arg_2_1.unchecked_positions
			local var_2_20 = arg_2_1.template

			if GwNavAStar.path_found(arg_2_1.astar) then
				var_2_20.prepare_spawning_storm(arg_2_1, var_2_19.storm_spawn_position, var_2_19.directed_wander_position)
			else
				var_2_20.prepare_spawning_storm(arg_2_1, var_2_19.backup_storm_spawn_position, var_2_19.backup_storm_spawn_position)
			end

			table.clear(arg_2_1.unchecked_positions)
		end
	end,
	prepare_spawning_storm = function (arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = arg_3_0.vortex_template
		local var_3_1 = 2
		local var_3_2 = math.min(var_3_1 / var_3_0.full_inner_radius, 1)
		local var_3_3 = arg_3_0.inner_decal_unit_name
		local var_3_4
		local var_3_5 = arg_3_1:unbox()

		if var_3_3 then
			local var_3_6 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_3_5)
			local var_3_7 = math.max(var_3_0.min_inner_radius, var_3_2 * var_3_0.full_inner_radius)

			Matrix4x4.set_scale(var_3_6, Vector3(var_3_7, var_3_7, var_3_7))

			var_3_4 = Managers.state.unit_spawner:spawn_network_unit(var_3_3, "network_synched_dummy_unit", nil, var_3_6)
		end

		local var_3_8 = arg_3_0.outer_decal_unit_name
		local var_3_9

		if var_3_8 then
			local var_3_10 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_3_5)
			local var_3_11 = math.max(var_3_0.min_outer_radius, var_3_2 * var_3_0.full_outer_radius)

			Matrix4x4.set_scale(var_3_10, Vector3(var_3_11, var_3_11, var_3_11))

			var_3_9 = Managers.state.unit_spawner:spawn_network_unit(var_3_8, "network_synched_dummy_unit", nil, var_3_10)
		end

		local var_3_12 = Managers.time:time("game")

		arg_3_0.summoning_vortex_inner_decal_unit = var_3_4
		arg_3_0.summoning_vortex_outer_decal_unit = var_3_9
		arg_3_0.summoning_vortex_t = var_3_12 + 2.5
		arg_3_0.storm_spawn_position = arg_3_1
		arg_3_0.spawn_nurgle_storm_at = var_3_12 + 5
		arg_3_0.directed_wander_position_boxed = arg_3_2
	end,
	spawn_storm = function (arg_4_0)
		local var_4_0 = arg_4_0.vortex_template.breed_name
		local var_4_1 = Breeds[var_4_0]
		local var_4_2 = "vortex"
		local var_4_3 = {
			prepare_func = function (arg_5_0, arg_5_1)
				arg_5_1.ai_supplementary_system = {
					vortex_template_name = arg_4_0.vortex_template_name,
					inner_decal_unit = arg_4_0.summoning_vortex_inner_decal_unit,
					outer_decal_unit = arg_4_0.summoning_vortex_outer_decal_unit
				}
			end,
			spawned_func = function (arg_6_0, arg_6_1, arg_6_2)
				arg_4_0.summoned_vortex_unit = arg_6_0
				BLACKBOARDS[arg_6_0].directed_wander_position_boxed = arg_4_0.directed_wander_position_boxed
			end
		}
		local var_4_4 = arg_4_0.storm_spawn_position

		Managers.state.conflict:spawn_queued_unit(var_4_1, var_4_4, QuaternionBox(Quaternion.identity()), var_4_2, nil, nil, var_4_3)

		arg_4_0.summoning_vortex_t = nil
	end,
	server_stop_function = function (arg_7_0, arg_7_1)
		GwNavAStar.destroy(arg_7_1.astar)
	end
}
