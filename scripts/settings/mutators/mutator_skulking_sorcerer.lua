-- chunkname: @scripts/settings/mutators/mutator_skulking_sorcerer.lua

return {
	description = "description_skulking_sorcerer",
	display_name = "display_name_skulking_sorcerer",
	icon = "mutator_icon_skulking_sorcerer",
	server_start_function = function (arg_1_0, arg_1_1)
		arg_1_1.breed_name = "chaos_mutator_sorcerer"

		arg_1_1.cb_mutator_sorcerer_spawned = function (arg_2_0, arg_2_1, arg_2_2)
			arg_2_2.mutator_data.sorcerer_unit = arg_2_0
			arg_2_2.mutator_data.has_spawned_mutator_sorcerer = true
		end

		arg_1_1.wanted_spawn_distance_behind = 0
		arg_1_1.respawn_times = {
			8,
			15
		}
		arg_1_1.initial_spawn_time = 45
		arg_1_1.despawn_distance_sq = 3600
		arg_1_1.wanted_respawn_main_path_distance = {
			35,
			45
		}
	end,
	server_players_left_safe_zone = function (arg_3_0, arg_3_1)
		arg_3_1.has_left_safe_zone = true
		arg_3_1.is_initial_spawn = true
		arg_3_1.initial_spawn_time = 5
	end,
	server_update_function = function (arg_4_0, arg_4_1)
		if not arg_4_1.has_left_safe_zone then
			return
		end

		local var_4_0 = Managers.time:time("game")
		local var_4_1 = Managers.state.conflict
		local var_4_2 = arg_4_1.breed_name

		if not arg_4_1.spawn_queue_id then
			if not arg_4_1.has_wanted_position then
				local var_4_3 = MainPathUtils.point_on_mainpath(nil, arg_4_1.wanted_spawn_distance_behind)

				arg_4_1.wanted_position = Vector3Box(var_4_3)

				local var_4_4 = math.random(arg_4_1.respawn_times[1], arg_4_1.respawn_times[2])

				arg_4_1.spawn_at_time = arg_4_1.is_initial_spawn and var_4_0 + arg_4_1.initial_spawn_time or var_4_0 + var_4_4
				arg_4_1.has_wanted_position = true
				arg_4_1.is_initial_spawn = nil
			elseif var_4_0 > arg_4_1.spawn_at_time then
				local var_4_5 = Breeds[var_4_2]
				local var_4_6 = "misc"
				local var_4_7 = {
					spawned_func = arg_4_1.cb_mutator_sorcerer_spawned,
					mutator_data = arg_4_1
				}

				arg_4_1.spawn_queue_id = var_4_1:spawn_queued_unit(var_4_5, arg_4_1.wanted_position, QuaternionBox(Quaternion.identity()), var_4_6, nil, nil, var_4_7)
			end
		elseif arg_4_1.has_spawned_mutator_sorcerer then
			if HEALTH_ALIVE[arg_4_1.sorcerer_unit] then
				local var_4_8 = BLACKBOARDS[arg_4_1.sorcerer_unit]

				if var_4_8.closest_enemy_dist_sq and var_4_8.closest_enemy_dist_sq >= arg_4_1.despawn_distance_sq then
					var_4_1:destroy_unit(arg_4_1.sorcerer_unit, var_4_8, "debug")

					arg_4_1.sorcerer_unit = nil
					arg_4_1.spawn_queue_id = nil
					arg_4_1.has_spawned_mutator_sorcerer = false
					arg_4_1.has_wanted_position = false

					local var_4_9 = math.random(arg_4_1.wanted_respawn_main_path_distance[1], arg_4_1.wanted_respawn_main_path_distance[2])

					arg_4_1.wanted_spawn_distance_behind = math.max(var_4_1.main_path_info.ahead_travel_dist - var_4_9, 0)
				end
			else
				arg_4_1.sorcerer_unit = nil
				arg_4_1.spawn_queue_id = nil
				arg_4_1.has_spawned_mutator_sorcerer = false
				arg_4_1.has_wanted_position = false

				local var_4_10 = math.random(arg_4_1.wanted_respawn_main_path_distance[1], arg_4_1.wanted_respawn_main_path_distance[2])

				arg_4_1.wanted_spawn_distance_behind = math.max(var_4_1.main_path_info.ahead_travel_dist - var_4_10, 0)
			end
		end
	end
}
