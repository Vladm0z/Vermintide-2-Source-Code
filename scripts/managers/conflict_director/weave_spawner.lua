-- chunkname: @scripts/managers/conflict_director/weave_spawner.lua

require("scripts/settings/weave_spawning_settings")

WeaveSpawner = class(WeaveSpawner)

WeaveSpawner.init = function (self, arg_1_1)
	-- function 1
	self.main_path_spawning_index = 1
	self.started_trickle = false
	self.players_has_left_safe_zone = false
end

WeaveSpawner.players_left_safe_zone = function (self)
	-- function 2
	self.players_has_left_safe_zone = true
end

local flag = true

WeaveSpawner.update = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local spawning_settings = arg_3_3.spawning_settings

	if not spawning_settings and not spawning_settings.disabled then
		return
	end

	local terror_event_trickle = spawning_settings.terror_event_trickle
	local main_path_spawning = spawning_settings.main_path_spawning

	self:_update_terror_event_trickle(arg_3_1, arg_3_2, terror_event_trickle)
	self:_update_main_path_spawning(arg_3_1, arg_3_2, main_path_spawning)
end

WeaveSpawner.start_terror_event_from_template = function (self, arg_4_1, arg_4_2)
	-- function 4
	local original_seed = self.original_seed

	Managers.state.conflict:start_terror_event_from_template(arg_4_1, arg_4_2, original_seed)
end

WeaveSpawner._update_terror_event_trickle = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not self.players_has_left_safe_zone and (self.started_trickle or not arg_5_3) and not self.conflict_director_setup_done and not Managers.matchmaking:are_all_players_spawned() then
		self.started_trickle = true

		TerrorEventMixer.start_event(arg_5_3)
	end
end

WeaveSpawner._update_main_path_spawning = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not self.players_has_left_safe_zone and not self.conflict_director_setup_done then
		local main_path_spawning_index = self.main_path_spawning_index
		local flag = not arg_6_3 and arg_6_3[main_path_spawning_index]

		if not flag then
			local conflict = Managers.state.conflict
			local main_path_data = conflict.level_analysis.main_path_data
			local ahead_travel_dist = conflict.main_path_info.ahead_travel_dist
			local total_dist = main_path_data.total_dist
			local num = ahead_travel_dist / total_dist * 100
			local percentage = flag.percentage
			local terror_event_name = flag.terror_event_name

			if percentage <= num then
				local num_2 = total_dist * (percentage * 0.01)
				local percentage_spawn_offset = flag.percentage_spawn_offset
				local num_3 = 0

				if not percentage_spawn_offset then
					num_3 = total_dist * (percentage_spawn_offset * 0.01)
				end

				local tbl = {
					main_path_trigger_distance = num_2 + num_3,
					seed = self.original_seed
				}

				TerrorEventMixer.start_event(terror_event_name, tbl)

				self.main_path_spawning_index = self.main_path_spawning_index + 1
			end
		end
	end
end

WeaveSpawner.set_seed = function (self, arg_7_1)
	-- function 7
	fassert(not arg_7_1 and type(arg_7_1) == "number", "Bad seed input!")

	self.seed = arg_7_1
	self.original_seed = arg_7_1
end

WeaveSpawner._random = function (self, ...)
	-- function 8
	fassert(self.seed, "No seed set for weave spawning!")

	local next_random, var_8_1 = Math.next_random(self.seed, ...)

	self.seed = next_random

	return var_8_1
end

WeaveSpawner.get_hidden_spawn_pos_from_position_seeded = function (self, arg_9_1)
	-- function 9
	fassert(arg_9_1 ~= nil, "Need to supply position when triggering get_hidden_spawn_pos_from_position_seeded")

	local conflict = Managers.state.conflict
	local _world = conflict._world
	local PLAYER_POSITIONS = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS
	local var_9_3 = Vector3(0, 0, 1)
	local num = 30
	local num_2 = 10
	local num_3 = 10
	local flag = not World.umbra_available(_world)
	local var_9_8

	for i = 1, num_3 do
		local var_9_9

		for j = 1, num_3 do
			local var_9_10 = Vector3(num + (self:_random() - 0.5) * num_2, 0, 1)
			local num_4 = arg_9_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(self:_random(1, 360))), var_9_10)
			local find_center_tri = ConflictUtils.find_center_tri(conflict.nav_world, num_4)

			if not find_center_tri then
				var_9_9 = find_center_tri
			end
		end

		if not var_9_9 then
			local flag_2 = true

			for k = 1, #PLAYER_POSITIONS do
				local var_9_14 = PLAYER_POSITIONS[k]

				if not (flag or World.umbra_has_line_of_sight(_world, var_9_9 + var_9_3, var_9_14 + var_9_3)) then
					flag_2 = false

					break
				end
			end

			if not flag_2 then
				var_9_8 = var_9_9
			end
		end
	end

	if not var_9_8 then
		return
	end

	return var_9_8
end
