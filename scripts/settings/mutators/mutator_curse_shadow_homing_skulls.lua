-- chunkname: @scripts/settings/mutators/mutator_curse_shadow_homing_skulls.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

script_data.shadow_homing_skulls_debug = false

local printf = printf

local function fn(...)
	-- function 1
	local var_1_0 = sprintf(...)

	printf("[MutatorCurseShadowHomingSkulls] %s", var_1_0)
end

local function fn_2(...)
	-- function 2
	if not script_data.belakor_shooters_debug then
		local var_2_0 = sprintf(...)

		printf("[MutatorCurseShadowHomingSkulls] %s", var_2_0)
	end
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local tbl = {}
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local var_3_2 = PLAYER_AND_BOT_UNITS[i]

		tbl[#tbl + 1] = POSITION_LOOKUP[var_3_2]
	end

	return (ConflictUtils.find_visible_positions_in_sphere_around_player(arg_3_0, arg_3_2, arg_3_1, BelakorBalancing.homing_skulls_radius, BelakorBalancing.homing_skulls_min_pitch, BelakorBalancing.homing_skulls_max_pitch, BelakorBalancing.homing_skulls_pitch_delta, 0, 2 * math.pi, BelakorBalancing.homing_skulls_yaw_delta, tbl, BelakorBalancing.homing_skulls_radius, BelakorBalancing.homing_skulls_distance_between_skulls, BelakorBalancing.homing_skulls_min_distance_above_ground))
end

local tbl = {
	WAITING_TO_SPAWN = "WAITING_TO_SPAWN",
	DISABLED = "DISABLED",
	SPAWNING = "SPAWNING"
}

return {
	description = "curse_shadow_homing_skulls_desc",
	display_name = "curse_shadow_homing_skulls_name",
	icon = "deus_curse_belakor_01",
	packages = {
		"resource_packages/mutators/mutator_curse_shadow_homing_skulls"
	},
	server_start_function = function (self, arg_4_1)
		-- function 4
		arg_4_1.conflict_director = Managers.state.conflict
		arg_4_1.physics_world = World.physics_world(self.world)
		arg_4_1.state = tbl.WAITING_TO_SPAWN
	end,
	server_players_left_safe_zone = function (arg_5_0, arg_5_1)
		-- function 5
		arg_5_1.started = true
	end,
	server_pre_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if Managers.state.unit_spawner.game_session == nil or not global_is_inside_inn then
			return
		end

		if not arg_6_1.started then
			return
		end

		local state = arg_6_1.state
		local conflict_director = arg_6_1.conflict_director
		local flag = not (conflict_director.pacing:horde_population() < 1) or conflict_director.pacing:get_state() ~= "pacing_frozen"

		if state == tbl.WAITING_TO_SPAWN then
			if not arg_6_1.next_spawn_t then
				arg_6_1.next_spawn_t = arg_6_3 + Math.random_range(BelakorBalancing.homing_skulls_min_time_between_spawns, BelakorBalancing.homing_skulls_max_time_between_spawns)
				arg_6_1.state = tbl.WAITING_TO_SPAWN
			end

			if not (not arg_6_1.next_spawn_t and not (arg_6_3 > arg_6_1.next_spawn_t)) then
				arg_6_1.state = tbl.SPAWNING
			elseif not flag then
				arg_6_1.state = tbl.DISABLED
			end
		elseif state == tbl.DISABLED then
			if not flag then
				arg_6_1.next_spawn_t = arg_6_3 + Math.random_range(BelakorBalancing.homing_skulls_min_time_between_spawns, BelakorBalancing.homing_skulls_max_time_between_spawns)
				arg_6_1.state = tbl.WAITING_TO_SPAWN
			end
		elseif state == tbl.SPAWNING then
			local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

			if not get_random_alive_hero then
				arg_6_1.next_spawn_t = arg_6_3 + BelakorBalancing.homing_skulls_retry_time_on_spawn_failure
				arg_6_1.state = tbl.WAITING_TO_SPAWN
			else
				local physics_world = arg_6_1.physics_world
				local homing_skulls_maximum_count = BelakorBalancing.homing_skulls_maximum_count
				local var_6_6 = fn_3(physics_world, get_random_alive_hero, homing_skulls_maximum_count)

				if not (not var_6_6 and not (#var_6_6 >= BelakorBalancing.homing_skulls_minimum_count)) then
					for i = 1, #var_6_6 do
						local var_6_7 = var_6_6[i]
						local flag_2 = false
						local identity = Quaternion.identity()
						local str = "mutator"
						local str_2 = "deus_04"

						Managers.state.entity:system("pickup_system"):spawn_pickup(str_2, var_6_7, identity, flag_2, str)
					end

					Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_curse_shadow_skulls_spawn")

					arg_6_1.next_spawn_t = arg_6_3 + Math.random_range(BelakorBalancing.homing_skulls_min_time_between_spawns, BelakorBalancing.homing_skulls_max_time_between_spawns)
					arg_6_1.state = tbl.WAITING_TO_SPAWN
				else
					arg_6_1.next_spawn_t = arg_6_3 + BelakorBalancing.homing_skulls_retry_time_on_spawn_failure
					arg_6_1.state = tbl.WAITING_TO_SPAWN
				end
			end
		end

		if not script_data.shadow_homing_skulls_debug then
			local text = Debug.text
			local str_3 = "homing skulls state state: %s - %s"
			local state_2 = arg_6_1.state
			local num

			if not arg_6_1.next_spawn_t then
				num = arg_6_1.next_spawn_t - arg_6_3

				if not num then
					-- Nothing
				end
			end

			num = 0

			::label_6_0::

			text(str_3, state_2, num)
		end
	end,
	server_player_hit_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		return
	end
}
