-- chunkname: @scripts/managers/conflict_director/weave_spawner.lua

require("scripts/settings/weave_spawning_settings")

WeaveSpawner = class(WeaveSpawner)

function WeaveSpawner.init(arg_1_0, arg_1_1)
	arg_1_0.main_path_spawning_index = 1
	arg_1_0.started_trickle = false
	arg_1_0.players_has_left_safe_zone = false
end

function WeaveSpawner.players_left_safe_zone(arg_2_0)
	arg_2_0.players_has_left_safe_zone = true
end

local var_0_0 = true

function WeaveSpawner.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3.spawning_settings

	if not var_3_0 or var_3_0.disabled then
		return
	end

	local var_3_1 = var_3_0.terror_event_trickle
	local var_3_2 = var_3_0.main_path_spawning

	arg_3_0:_update_terror_event_trickle(arg_3_1, arg_3_2, var_3_1)
	arg_3_0:_update_main_path_spawning(arg_3_1, arg_3_2, var_3_2)
end

function WeaveSpawner.start_terror_event_from_template(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.original_seed

	Managers.state.conflict:start_terror_event_from_template(arg_4_1, arg_4_2, var_4_0)
end

function WeaveSpawner._update_terror_event_trickle(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.players_has_left_safe_zone and not arg_5_0.started_trickle and arg_5_3 and arg_5_0.conflict_director_setup_done and Managers.matchmaking:are_all_players_spawned() then
		arg_5_0.started_trickle = true

		TerrorEventMixer.start_event(arg_5_3)
	end
end

function WeaveSpawner._update_main_path_spawning(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0.players_has_left_safe_zone and arg_6_0.conflict_director_setup_done then
		local var_6_0 = arg_6_0.main_path_spawning_index
		local var_6_1 = arg_6_3 and arg_6_3[var_6_0]

		if var_6_1 then
			local var_6_2 = Managers.state.conflict
			local var_6_3 = var_6_2.level_analysis.main_path_data
			local var_6_4 = var_6_2.main_path_info.ahead_travel_dist
			local var_6_5 = var_6_3.total_dist
			local var_6_6 = var_6_4 / var_6_5 * 100
			local var_6_7 = var_6_1.percentage
			local var_6_8 = var_6_1.terror_event_name

			if var_6_7 <= var_6_6 then
				local var_6_9 = var_6_5 * (var_6_7 * 0.01)
				local var_6_10 = var_6_1.percentage_spawn_offset
				local var_6_11 = 0

				if var_6_10 then
					var_6_11 = var_6_5 * (var_6_10 * 0.01)
				end

				local var_6_12 = {
					main_path_trigger_distance = var_6_9 + var_6_11,
					seed = arg_6_0.original_seed
				}

				TerrorEventMixer.start_event(var_6_8, var_6_12)

				arg_6_0.main_path_spawning_index = arg_6_0.main_path_spawning_index + 1
			end
		end
	end
end

function WeaveSpawner.set_seed(arg_7_0, arg_7_1)
	fassert(arg_7_1 and type(arg_7_1) == "number", "Bad seed input!")

	arg_7_0.seed = arg_7_1
	arg_7_0.original_seed = arg_7_1
end

function WeaveSpawner._random(arg_8_0, ...)
	fassert(arg_8_0.seed, "No seed set for weave spawning!")

	local var_8_0, var_8_1 = Math.next_random(arg_8_0.seed, ...)

	arg_8_0.seed = var_8_0

	return var_8_1
end

function WeaveSpawner.get_hidden_spawn_pos_from_position_seeded(arg_9_0, arg_9_1)
	fassert(arg_9_1 ~= nil, "Need to supply position when triggering get_hidden_spawn_pos_from_position_seeded")

	local var_9_0 = Managers.state.conflict
	local var_9_1 = var_9_0._world
	local var_9_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS
	local var_9_3 = Vector3(0, 0, 1)
	local var_9_4 = 30
	local var_9_5 = 10
	local var_9_6 = 10
	local var_9_7 = not World.umbra_available(var_9_1)
	local var_9_8

	for iter_9_0 = 1, var_9_6 do
		local var_9_9

		for iter_9_1 = 1, var_9_6 do
			local var_9_10 = Vector3(var_9_4 + (arg_9_0:_random() - 0.5) * var_9_5, 0, 1)
			local var_9_11 = arg_9_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(arg_9_0:_random(1, 360))), var_9_10)
			local var_9_12 = ConflictUtils.find_center_tri(var_9_0.nav_world, var_9_11)

			if var_9_12 then
				var_9_9 = var_9_12
			end
		end

		if var_9_9 then
			local var_9_13 = true

			for iter_9_2 = 1, #var_9_2 do
				local var_9_14 = var_9_2[iter_9_2]

				if var_9_7 or World.umbra_has_line_of_sight(var_9_1, var_9_9 + var_9_3, var_9_14 + var_9_3) then
					var_9_13 = false

					break
				end
			end

			if var_9_13 then
				var_9_8 = var_9_9
			end
		end
	end

	if not var_9_8 then
		return
	end

	return var_9_8
end
