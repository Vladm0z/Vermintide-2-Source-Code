-- chunkname: @scripts/entity_system/systems/ghost_mode/ghost_mode_utils.lua

GhostModeUtils = GhostModeUtils or {}

function GhostModeUtils.in_line_of_sight_of_enemies(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = POSITION_LOOKUP[arg_1_0]
	local var_1_1 = Vector3(0, 0, 1)
	local var_1_2 = #arg_1_1

	for iter_1_0 = 1, var_1_2 do
		local var_1_3 = arg_1_1[iter_1_0]

		if PerceptionUtils.is_position_in_line_of_sight(nil, var_1_0 + var_1_1, var_1_3 + var_1_1, arg_1_2) then
			return true
		end
	end

	return false
end

function GhostModeUtils.in_range_of_enemies(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_2_1 = false
	local var_2_2 = arg_2_2 and GameModeSettings.versus.boss_minimum_spawn_distance or GameModeSettings.versus.dark_pact_minimum_spawn_distance
	local var_2_3 = GameModeSettings.versus.dark_pact_minimum_spawn_distance_vertical
	local var_2_4 = arg_2_2 and "boss_spawn_range_distance" or "special_spawn_range_distance"
	local var_2_5, var_2_6, var_2_7 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", var_2_4)

	if var_2_5 and var_2_7 then
		var_2_2 = var_2_6
		var_2_3 = math.clamp(0, GameModeSettings.versus.dark_pact_minimum_spawn_distance_vertical, var_2_2)
	end

	local var_2_8 = var_2_2^2

	for iter_2_0 = 1, #var_2_0 do
		local var_2_9 = var_2_0[iter_2_0] - arg_2_0

		if var_2_3 > math.abs(var_2_9[3]) and var_2_8 > Vector3.length_squared(Vector3.flat(var_2_9)) then
			var_2_1 = true

			break
		end
	end

	return var_2_1
end

function GhostModeUtils.in_safe_zone(arg_3_0)
	local var_3_0
	local var_3_1 = LevelHelper:current_level(Managers.world:world("level_world"))
	local var_3_2 = "versus_activator"

	if Level.has_volume(var_3_1, var_3_2) then
		local var_3_3 = POSITION_LOOKUP[arg_3_0]

		var_3_0 = Level.is_point_inside_volume(var_3_1, var_3_2, var_3_3)
	end

	return var_3_0
end

function GhostModeUtils.pact_sworn_round_started(arg_4_0)
	local var_4_0, var_4_1 = Managers.state.game_mode:is_round_started()

	if not var_4_0 then
		return false
	end

	local var_4_2 = GameModeSettings.versus.round_start_pact_sworn_spawn_delay
	local var_4_3 = Managers.state.side.side_by_unit[arg_4_0]

	if var_4_3 then
		local var_4_4 = false
		local var_4_5 = var_4_3.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_4_0 = 1, #var_4_5 do
			local var_4_6 = var_4_5[iter_4_0]

			if not GhostModeUtils.in_safe_zone(var_4_6) then
				var_4_4 = true

				break
			end
		end

		if var_4_4 then
			var_4_2 = GameModeSettings.versus.round_start_heroes_left_safe_zone_spawn_delay
		end
	end

	return var_4_2 < var_4_1
end

function GhostModeUtils.enemy_players_using_transport(arg_5_0)
	local var_5_0 = Managers.state.side.side_by_unit[arg_5_0].ENEMY_PLAYER_UNITS

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		if HEALTH_ALIVE[iter_5_1] then
			local var_5_1 = ScriptUnit.extension(arg_5_0, "status_system")

			if not var_5_1:is_disabled() and var_5_1:is_using_transport() then
				return true
			end
		end
	end

	return false
end

function GhostModeUtils.far_enough_to_enter_ghost_mode(arg_6_0)
	local var_6_0 = POSITION_LOOKUP[arg_6_0]
	local var_6_1 = GameModeSettings.versus.dark_pact_catch_up_distance
	local var_6_2, var_6_3, var_6_4 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "catch_up_with_heroes")

	if var_6_4 then
		var_6_1 = var_6_3
	end

	local var_6_5 = Managers.state.side.side_by_unit[arg_6_0].ENEMY_PLAYER_AND_BOT_UNITS

	for iter_6_0 = 1, #var_6_5 do
		local var_6_6 = var_6_5[iter_6_0]
		local var_6_7 = ScriptUnit.has_extension(var_6_6, "status_system")

		if not var_6_7 or not var_6_7:is_disabled() then
			local var_6_8 = POSITION_LOOKUP[var_6_6]

			if var_6_1 > Vector3.distance(var_6_8, var_6_0) then
				return false
			end
		end
	end

	return true
end
