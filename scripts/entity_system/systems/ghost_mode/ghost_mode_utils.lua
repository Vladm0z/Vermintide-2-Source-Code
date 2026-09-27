-- chunkname: @scripts/entity_system/systems/ghost_mode/ghost_mode_utils.lua

local GhostModeUtils = GhostModeUtils

GhostModeUtils = GhostModeUtils or {}
GhostModeUtils = GhostModeUtils

GhostModeUtils.in_line_of_sight_of_enemies = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local var_1_0 = POSITION_LOOKUP[arg_1_0]
	local var_1_1 = Vector3(0, 0, 1)
	local count = #arg_1_1

	for i = 1, count do
		local var_1_3 = arg_1_1[i]

		if not PerceptionUtils.is_position_in_line_of_sight(nil, var_1_0 + var_1_1, var_1_3 + var_1_1, arg_1_2) then
			return true
		end
	end

	return false
end

GhostModeUtils.in_range_of_enemies = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_2_1.ENEMY_PLAYER_AND_BOT_POSITIONS
	local flag = false
	local boss_minimum_spawn_distance

	if not arg_2_2 then
		boss_minimum_spawn_distance = GameModeSettings.versus.boss_minimum_spawn_distance

		if not boss_minimum_spawn_distance then
			-- Nothing
		end
	end

	boss_minimum_spawn_distance = GameModeSettings.versus.dark_pact_minimum_spawn_distance

	::label_2_0::

	local dark_pact_minimum_spawn_distance_vertical = GameModeSettings.versus.dark_pact_minimum_spawn_distance_vertical
	local flag_2

	flag_2 = not arg_2_2 and "boss_spawn_range_distance" and "special_spawn_range_distance"

	local mechanism_try_call, var_2_6, var_2_7 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", flag_2)

	if not mechanism_try_call and not var_2_7 then
		boss_minimum_spawn_distance = var_2_6
		dark_pact_minimum_spawn_distance_vertical = math.clamp(0, GameModeSettings.versus.dark_pact_minimum_spawn_distance_vertical, boss_minimum_spawn_distance)
	end

	local num = boss_minimum_spawn_distance^2

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local num_2 = ENEMY_PLAYER_AND_BOT_POSITIONS[i] - arg_2_0

		if not (not (dark_pact_minimum_spawn_distance_vertical > math.abs(num_2[3])) or not (num > Vector3.length_squared(Vector3.flat(num_2)))) then
			flag = true

			break
		end
	end

	return flag
end

GhostModeUtils.in_safe_zone = function (arg_3_0)
	-- function 3
	local var_3_0
	local current_level = LevelHelper:current_level(Managers.world:world("level_world"))
	local str = "versus_activator"

	if not Level.has_volume(current_level, str) then
		local var_3_3 = POSITION_LOOKUP[arg_3_0]

		var_3_0 = Level.is_point_inside_volume(current_level, str, var_3_3)
	end

	return var_3_0
end

GhostModeUtils.pact_sworn_round_started = function (arg_4_0)
	-- function 4
	local is_round_started, var_4_1 = Managers.state.game_mode:is_round_started()

	if not is_round_started then
		return false
	end

	local round_start_pact_sworn_spawn_delay = GameModeSettings.versus.round_start_pact_sworn_spawn_delay
	local var_4_3 = Managers.state.side.side_by_unit[arg_4_0]

	if not var_4_3 then
		local flag = false
		local ENEMY_PLAYER_AND_BOT_UNITS = var_4_3.ENEMY_PLAYER_AND_BOT_UNITS

		for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_4_6 = ENEMY_PLAYER_AND_BOT_UNITS[i]

			if not GhostModeUtils.in_safe_zone(var_4_6) then
				flag = true

				break
			end
		end

		if not flag then
			round_start_pact_sworn_spawn_delay = GameModeSettings.versus.round_start_heroes_left_safe_zone_spawn_delay
		end
	end

	return round_start_pact_sworn_spawn_delay < var_4_1
end

GhostModeUtils.enemy_players_using_transport = function (arg_5_0)
	-- function 5
	local ENEMY_PLAYER_UNITS = Managers.state.side.side_by_unit[arg_5_0].ENEMY_PLAYER_UNITS

	for i, v in ipairs(ENEMY_PLAYER_UNITS) do
		if not HEALTH_ALIVE[v] then
			local extension = ScriptUnit.extension(arg_5_0, "status_system")

			if extension:is_disabled() or not extension:is_using_transport() then
				return true
			end
		end
	end

	return false
end

GhostModeUtils.far_enough_to_enter_ghost_mode = function (arg_6_0)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_0]
	local dark_pact_catch_up_distance = GameModeSettings.versus.dark_pact_catch_up_distance
	local mechanism_try_call, var_6_3, var_6_4 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "catch_up_with_heroes")

	if not var_6_4 then
		dark_pact_catch_up_distance = var_6_3
	end

	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_6_0].ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_6_6 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local has_extension = ScriptUnit.has_extension(var_6_6, "status_system")

		if not (not has_extension and has_extension:is_disabled()) then
			local var_6_8 = POSITION_LOOKUP[var_6_6]

			if dark_pact_catch_up_distance > Vector3.distance(var_6_8, var_6_0) then
				return false
			end
		end
	end

	return true
end
