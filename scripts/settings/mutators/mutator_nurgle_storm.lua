-- chunkname: @scripts/settings/mutators/mutator_nurgle_storm.lua

return {
	description = "description_nurgle_storm",
	display_name = "display_name_nurgle_storm",
	icon = "mutator_icon_nurgle_storm",
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
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
		-- function 2
		if Network.game_session() == nil or not global_is_inside_inn then
			return
		end

		local time = Managers.time:time("game")
		local flag = table.size(arg_2_1.unchecked_positions) > 0

		if not (not arg_2_1.summoning_vortex_t and not (time > arg_2_1.summoning_vortex_t) or ALIVE[arg_2_1.summoned_vortex_unit]) then
			arg_2_1.template.spawn_storm(arg_2_1)
		elseif not ALIVE[arg_2_1.summoned_vortex_unit] then
			arg_2_1.spawn_nurgle_storm_at = time + arg_2_1.delay_between_spawns
		elseif not (not (time > arg_2_1.spawn_nurgle_storm_at) or flag) then
			local conflict = Managers.state.conflict
			local main_path_info = conflict.main_path_info
			local flag_2 = math.random() > 0.5
			local ahead_unit

			if not flag_2 then
				ahead_unit = main_path_info.ahead_unit

				if not ahead_unit then
					-- Nothing
				end
			end

			ahead_unit = main_path_info.behind_unit

			::label_2_0::

			if not ahead_unit then
				local nav_world = Managers.state.entity:system("ai_system"):nav_world()
				local offset_spawn_distance = arg_2_1.offset_spawn_distance
				local travel_dist = conflict.main_path_player_info[ahead_unit].travel_dist
				local max = math.max
				local flag_3

				flag_3 = not flag_2 and 1 and -1

				local var_2_11 = max(travel_dist + offset_spawn_distance * flag_3, 0)
				local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, var_2_11)
				local flag_4 = not point_on_mainpath and LocomotionUtils.pos_on_mesh(nav_world, point_on_mainpath, 1, 1)
				local var_2_14 = POSITION_LOOKUP[ahead_unit]
				local flag_5 = not point_on_mainpath and LocomotionUtils.pos_on_mesh(nav_world, var_2_14, 1, 1)

				if flag_4 or not point_on_mainpath then
					local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, point_on_mainpath, 6, 6, 8, 0.5)

					if not inside_position_from_outside_position then
						flag_4 = inside_position_from_outside_position
					end
				end

				if flag_5 or not var_2_14 then
					local inside_position_from_outside_position_2 = GwNavQueries.inside_position_from_outside_position(nav_world, var_2_14, 6, 6, 8, 0.5)

					if not inside_position_from_outside_position_2 then
						flag_5 = inside_position_from_outside_position_2
					end
				end

				if not flag_4 and not flag_5 then
					local num = offset_spawn_distance * 2
					local flag_6

					flag_6 = not flag_2 and -1 and 1

					local num_2 = travel_dist + num * flag_6
					local point_on_mainpath_2 = MainPathUtils.point_on_mainpath(nil, num_2)

					arg_2_1.unchecked_positions.storm_spawn_position = Vector3Box(flag_4)
					arg_2_1.unchecked_positions.directed_wander_position = Vector3Box(point_on_mainpath_2)
					arg_2_1.unchecked_positions.backup_storm_spawn_position = Vector3Box(flag_5)

					local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()

					GwNavAStar.start_with_propagation_box(arg_2_1.astar, nav_world, flag_4, point_on_mainpath_2, 30, traverse_logic)
				end
			else
				arg_2_1.spawn_nurgle_storm_at = time + 1
			end
		end

		if not flag and not GwNavAStar.processing_finished(arg_2_1.astar) then
			local unchecked_positions = arg_2_1.unchecked_positions
			local template = arg_2_1.template

			if not GwNavAStar.path_found(arg_2_1.astar) then
				template.prepare_spawning_storm(arg_2_1, unchecked_positions.storm_spawn_position, unchecked_positions.directed_wander_position)
			else
				template.prepare_spawning_storm(arg_2_1, unchecked_positions.backup_storm_spawn_position, unchecked_positions.backup_storm_spawn_position)
			end

			table.clear(arg_2_1.unchecked_positions)
		end
	end,
	prepare_spawning_storm = function (self, arg_3_1, arg_3_2)
		-- function 3
		local vortex_template = self.vortex_template
		local num = 2
		local min = math.min(num / vortex_template.full_inner_radius, 1)
		local inner_decal_unit_name = self.inner_decal_unit_name
		local var_3_4
		local unbox = arg_3_1:unbox()

		if not inner_decal_unit_name then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
			local max = math.max(vortex_template.min_inner_radius, min * vortex_template.full_inner_radius)

			Matrix4x4.set_scale(from_quaternion_position, Vector3(max, max, max))

			var_3_4 = Managers.state.unit_spawner:spawn_network_unit(inner_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position)
		end

		local outer_decal_unit_name = self.outer_decal_unit_name
		local var_3_9

		if not outer_decal_unit_name then
			local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
			local max_2 = math.max(vortex_template.min_outer_radius, min * vortex_template.full_outer_radius)

			Matrix4x4.set_scale(from_quaternion_position_2, Vector3(max_2, max_2, max_2))

			var_3_9 = Managers.state.unit_spawner:spawn_network_unit(outer_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position_2)
		end

		local time = Managers.time:time("game")

		self.summoning_vortex_inner_decal_unit = var_3_4
		self.summoning_vortex_outer_decal_unit = var_3_9
		self.summoning_vortex_t = time + 2.5
		self.storm_spawn_position = arg_3_1
		self.spawn_nurgle_storm_at = time + 5
		self.directed_wander_position_boxed = arg_3_2
	end,
	spawn_storm = function (self)
		-- function 4
		local breed_name = self.vortex_template.breed_name
		local var_4_1 = Breeds[breed_name]
		local str = "vortex"
		local tbl = {
			prepare_func = function (arg_5_0, arg_5_1)
				-- function 5
				arg_5_1.ai_supplementary_system = {
					vortex_template_name = self.vortex_template_name,
					inner_decal_unit = self.summoning_vortex_inner_decal_unit,
					outer_decal_unit = self.summoning_vortex_outer_decal_unit
				}
			end,
			spawned_func = function (arg_6_0, arg_6_1, arg_6_2)
				-- function 6
				self.summoned_vortex_unit = arg_6_0
				BLACKBOARDS[arg_6_0].directed_wander_position_boxed = self.directed_wander_position_boxed
			end
		}
		local storm_spawn_position = self.storm_spawn_position

		Managers.state.conflict:spawn_queued_unit(var_4_1, storm_spawn_position, QuaternionBox(Quaternion.identity()), str, nil, nil, tbl)

		self.summoning_vortex_t = nil
	end,
	server_stop_function = function (arg_7_0, arg_7_1)
		-- function 7
		GwNavAStar.destroy(arg_7_1.astar)
	end
}
