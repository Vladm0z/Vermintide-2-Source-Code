-- chunkname: @scripts/settings/mutators/mutator_skulking_sorcerer.lua

return {
	description = "description_skulking_sorcerer",
	display_name = "display_name_skulking_sorcerer",
	icon = "mutator_icon_skulking_sorcerer",
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.breed_name = "chaos_mutator_sorcerer"

		arg_1_1.cb_mutator_sorcerer_spawned = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
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
		-- function 3
		arg_3_1.has_left_safe_zone = true
		arg_3_1.is_initial_spawn = true
		arg_3_1.initial_spawn_time = 5
	end,
	server_update_function = function (arg_4_0, arg_4_1)
		-- function 4
		if not arg_4_1.has_left_safe_zone then
			return
		end

		local time = Managers.time:time("game")
		local conflict = Managers.state.conflict
		local breed_name = arg_4_1.breed_name

		if not arg_4_1.spawn_queue_id then
			if not arg_4_1.has_wanted_position then
				local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, arg_4_1.wanted_spawn_distance_behind)

				arg_4_1.wanted_position = Vector3Box(point_on_mainpath)

				local random = math.random(arg_4_1.respawn_times[1], arg_4_1.respawn_times[2])
				local num

				if not arg_4_1.is_initial_spawn then
					num = time + arg_4_1.initial_spawn_time

					if not num then
						-- Nothing
					end
				end

				num = time + random

				::label_4_0::

				arg_4_1.spawn_at_time = num
				arg_4_1.has_wanted_position = true
				arg_4_1.is_initial_spawn = nil
			elseif time > arg_4_1.spawn_at_time then
				local var_4_6 = Breeds[breed_name]
				local str = "misc"
				local tbl = {
					spawned_func = arg_4_1.cb_mutator_sorcerer_spawned,
					mutator_data = arg_4_1
				}

				arg_4_1.spawn_queue_id = conflict:spawn_queued_unit(var_4_6, arg_4_1.wanted_position, QuaternionBox(Quaternion.identity()), str, nil, nil, tbl)
			end
		elseif not arg_4_1.has_spawned_mutator_sorcerer then
			if not HEALTH_ALIVE[arg_4_1.sorcerer_unit] then
				local var_4_9 = BLACKBOARDS[arg_4_1.sorcerer_unit]

				if not (not var_4_9.closest_enemy_dist_sq and not (var_4_9.closest_enemy_dist_sq >= arg_4_1.despawn_distance_sq)) then
					conflict:destroy_unit(arg_4_1.sorcerer_unit, var_4_9, "debug")

					arg_4_1.sorcerer_unit = nil
					arg_4_1.spawn_queue_id = nil
					arg_4_1.has_spawned_mutator_sorcerer = false
					arg_4_1.has_wanted_position = false

					local random_2 = math.random(arg_4_1.wanted_respawn_main_path_distance[1], arg_4_1.wanted_respawn_main_path_distance[2])

					arg_4_1.wanted_spawn_distance_behind = math.max(conflict.main_path_info.ahead_travel_dist - random_2, 0)
				end
			else
				arg_4_1.sorcerer_unit = nil
				arg_4_1.spawn_queue_id = nil
				arg_4_1.has_spawned_mutator_sorcerer = false
				arg_4_1.has_wanted_position = false

				local random_3 = math.random(arg_4_1.wanted_respawn_main_path_distance[1], arg_4_1.wanted_respawn_main_path_distance[2])

				arg_4_1.wanted_spawn_distance_behind = math.max(conflict.main_path_info.ahead_travel_dist - random_3, 0)
			end
		end
	end
}
