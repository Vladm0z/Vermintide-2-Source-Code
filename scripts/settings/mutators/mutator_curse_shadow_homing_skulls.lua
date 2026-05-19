-- chunkname: @scripts/settings/mutators/mutator_curse_shadow_homing_skulls.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

script_data.shadow_homing_skulls_debug = false

local var_0_0 = printf

local function var_0_1(...)
	local var_1_0 = sprintf(...)

	var_0_0("[MutatorCurseShadowHomingSkulls] %s", var_1_0)
end

local function var_0_2(...)
	if script_data.belakor_shooters_debug then
		local var_2_0 = sprintf(...)

		var_0_0("[MutatorCurseShadowHomingSkulls] %s", var_2_0)
	end
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {}
	local var_3_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for iter_3_0 = 1, #var_3_1 do
		local var_3_2 = var_3_1[iter_3_0]

		var_3_0[#var_3_0 + 1] = POSITION_LOOKUP[var_3_2]
	end

	return (ConflictUtils.find_visible_positions_in_sphere_around_player(arg_3_0, arg_3_2, arg_3_1, BelakorBalancing.homing_skulls_radius, BelakorBalancing.homing_skulls_min_pitch, BelakorBalancing.homing_skulls_max_pitch, BelakorBalancing.homing_skulls_pitch_delta, 0, 2 * math.pi, BelakorBalancing.homing_skulls_yaw_delta, var_3_0, BelakorBalancing.homing_skulls_radius, BelakorBalancing.homing_skulls_distance_between_skulls, BelakorBalancing.homing_skulls_min_distance_above_ground))
end

local var_0_4 = {
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
	server_start_function = function(arg_4_0, arg_4_1)
		arg_4_1.conflict_director = Managers.state.conflict
		arg_4_1.physics_world = World.physics_world(arg_4_0.world)
		arg_4_1.state = var_0_4.WAITING_TO_SPAWN
	end,
	server_players_left_safe_zone = function(arg_5_0, arg_5_1)
		arg_5_1.started = true
	end,
	server_pre_update_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if Managers.state.unit_spawner.game_session == nil or global_is_inside_inn then
			return
		end

		if not arg_6_1.started then
			return
		end

		local var_6_0 = arg_6_1.state
		local var_6_1 = arg_6_1.conflict_director
		local var_6_2 = var_6_1.pacing:horde_population() < 1 and var_6_1.pacing:get_state() ~= "pacing_frozen"

		if var_6_0 == var_0_4.WAITING_TO_SPAWN then
			if not arg_6_1.next_spawn_t then
				arg_6_1.next_spawn_t = arg_6_3 + Math.random_range(BelakorBalancing.homing_skulls_min_time_between_spawns, BelakorBalancing.homing_skulls_max_time_between_spawns)
				arg_6_1.state = var_0_4.WAITING_TO_SPAWN
			end

			if not arg_6_1.next_spawn_t or arg_6_3 > arg_6_1.next_spawn_t then
				arg_6_1.state = var_0_4.SPAWNING
			elseif var_6_2 then
				arg_6_1.state = var_0_4.DISABLED
			end
		elseif var_6_0 == var_0_4.DISABLED then
			if not var_6_2 then
				arg_6_1.next_spawn_t = arg_6_3 + Math.random_range(BelakorBalancing.homing_skulls_min_time_between_spawns, BelakorBalancing.homing_skulls_max_time_between_spawns)
				arg_6_1.state = var_0_4.WAITING_TO_SPAWN
			end
		elseif var_6_0 == var_0_4.SPAWNING then
			local var_6_3 = PlayerUtils.get_random_alive_hero()

			if not var_6_3 then
				arg_6_1.next_spawn_t = arg_6_3 + BelakorBalancing.homing_skulls_retry_time_on_spawn_failure
				arg_6_1.state = var_0_4.WAITING_TO_SPAWN
			else
				local var_6_4 = arg_6_1.physics_world
				local var_6_5 = BelakorBalancing.homing_skulls_maximum_count
				local var_6_6 = var_0_3(var_6_4, var_6_3, var_6_5)

				if var_6_6 and #var_6_6 >= BelakorBalancing.homing_skulls_minimum_count then
					for iter_6_0 = 1, #var_6_6 do
						local var_6_7 = var_6_6[iter_6_0]
						local var_6_8 = false
						local var_6_9 = Quaternion.identity()
						local var_6_10 = "mutator"
						local var_6_11 = "deus_04"

						Managers.state.entity:system("pickup_system"):spawn_pickup(var_6_11, var_6_7, var_6_9, var_6_8, var_6_10)
					end

					Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_curse_shadow_skulls_spawn")

					arg_6_1.next_spawn_t = arg_6_3 + Math.random_range(BelakorBalancing.homing_skulls_min_time_between_spawns, BelakorBalancing.homing_skulls_max_time_between_spawns)
					arg_6_1.state = var_0_4.WAITING_TO_SPAWN
				else
					arg_6_1.next_spawn_t = arg_6_3 + BelakorBalancing.homing_skulls_retry_time_on_spawn_failure
					arg_6_1.state = var_0_4.WAITING_TO_SPAWN
				end
			end
		end

		if script_data.shadow_homing_skulls_debug then
			Debug.text("homing skulls state state: %s - %s", arg_6_1.state, arg_6_1.next_spawn_t and arg_6_1.next_spawn_t - arg_6_3 or 0)
		end
	end,
	server_player_hit_function = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		return
	end
}
