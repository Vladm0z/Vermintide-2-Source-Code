-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_helper.lua

local EnemyCharacterStateHelper = EnemyCharacterStateHelper

EnemyCharacterStateHelper = EnemyCharacterStateHelper or {}
EnemyCharacterStateHelper = EnemyCharacterStateHelper

local EnemyCharacterStateHelper_2 = EnemyCharacterStateHelper

EnemyCharacterStateHelper_2.get_enemies_in_line_of_sight = function (arg_1_0, arg_1_1, arg_1_2, ...)
	-- function 1
	local var_1_0 = POSITION_LOOKUP[arg_1_1]
	local world_rotation = Unit.world_rotation(arg_1_1, 0)
	local normalize = Vector3.normalize(Quaternion.forward(world_rotation))
	local get_data = Unit.get_data(arg_1_0, "breed")
	local var_1_4

	if get_data.name == "vs_packmaster" then
		return EnemyCharacterStateHelper_2._check_within_line_of_sight_packmaster(arg_1_0, arg_1_1, var_1_0, world_rotation, normalize, arg_1_2, ...)
	elseif get_data.name == "vs_ratling_gunner" then
		return EnemyCharacterStateHelper_2._check_within_line_of_sight_ratling_gunner(arg_1_0, arg_1_1, var_1_0, world_rotation, normalize, arg_1_2, ...)
	elseif get_data.name == "vs_warpfire_thrower" then
		return EnemyCharacterStateHelper_2._check_within_line_of_sight_warpfire_thrower(arg_1_0, arg_1_1, var_1_0, world_rotation, normalize, arg_1_2, ...)
	elseif get_data.name == "vs_gutter_runner" then
		return EnemyCharacterStateHelper_2._check_within_line_of_sight_gutter_runner(arg_1_0, arg_1_1, var_1_0, world_rotation, normalize, arg_1_2, ...)
	elseif get_data.name == "vs_poison_wind_globadier" then
		return EnemyCharacterStateHelper_2._check_within_impact_globadier(arg_1_0, arg_1_1, var_1_0, world_rotation, normalize, arg_1_2, ...)
	end
end

EnemyCharacterStateHelper_2._check_within_line_of_sight_packmaster = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_2_0].ENEMY_PLAYER_AND_BOT_UNITS
	local vs_packmaster = PlayerBreeds.vs_packmaster
	local grab_hook_range = vs_packmaster.grab_hook_range
	local grab_hook_cone_dot = vs_packmaster.grab_hook_cone_dot
	local var_2_4
	local num = 0
	local num_2 = 0

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		repeat
			local has_extension = ScriptUnit.has_extension(v, "status_system")

			if not has_extension and not has_extension:is_disabled() then
				break
			end

			if not Unit.has_node(v, "j_claw_attach") then
				break
			end

			local _check_within_cone, var_2_9, var_2_10 = EnemyCharacterStateHelper_2._check_within_cone(arg_2_2, arg_2_4, v, grab_hook_range, grab_hook_cone_dot)

			if not _check_within_cone then
				break
			end

			if not PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_2_5, arg_2_0, v) then
				break
			end

			if num_2 <= var_2_9 then
				num_2 = var_2_9
				var_2_4 = v
				num = var_2_10
			end
		until true
	end

	return var_2_4, num
end

EnemyCharacterStateHelper_2._check_within_cone = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local world_position = Unit.world_position(arg_3_2, Unit.node(arg_3_2, "j_claw_attach"))
	local normalize = Vector3.normalize(world_position - arg_3_0)
	local dot = Vector3.dot(arg_3_1, normalize)
	local distance = Vector3.distance(world_position, arg_3_0)
	local flag = distance < arg_3_3

	if (not (arg_3_4 <= dot) or not flag) and not EnemyCharacterStateHelper_2.is_infront_player(arg_3_0, arg_3_1, world_position) then
		return true, dot, distance
	end
end

EnemyCharacterStateHelper_2.is_infront_player = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local normalize = Vector3.normalize(arg_4_2 - arg_4_0)

	if Vector3.dot(normalize, arg_4_1) > 0 then
		return true
	end
end

EnemyCharacterStateHelper_2._check_within_line_of_sight_ratling_gunner = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_5_0].ENEMY_PLAYER_AND_BOT_UNITS
	local num = LightWeightProjectiles.ratling_gunner_vs.spread * 2
	local tbl = {}

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		repeat
			local world_position = Unit.world_position(v, Unit.node(v, "c_spine"))
			local normalize = Vector3.normalize(world_position - arg_5_2)
			local dot = Vector3.dot(arg_5_4, normalize)

			if num < math.acos(dot) then
				break
			end

			local distance = Vector3.distance(world_position, arg_5_2)
			local immediate_raycast, var_5_8, var_5_9, var_5_10, var_5_11 = PhysicsWorld.immediate_raycast(arg_5_5, arg_5_2, normalize, distance, "closest", "collision_filter", "filter_husk_in_line_of_sight")

			if not immediate_raycast then
				break
			end

			tbl[#tbl + 1] = {
				unit = v,
				distance = distance
			}
		until true
	end

	return not (#tbl > 0) or tbl
end

EnemyCharacterStateHelper_2._check_within_line_of_sight_warpfire_thrower = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local vs_warpfire_thrower = PlayerBreeds.vs_warpfire_thrower
	local warpfire_data = BLACKBOARDS[arg_6_0].warpfire_data
	local num = warpfire_data.attack_range / 2
	local hit_radius = warpfire_data.hit_radius
	local shoot_warpfire_close_attack_dot = vs_warpfire_thrower.shoot_warpfire_close_attack_dot
	local var_6_5 = Vector3(hit_radius, num, hit_radius)
	local num_2 = arg_6_2 + arg_6_4 * num
	local num_3 = 0.5
	local str = "filter_character_trigger"

	PhysicsWorld.prepare_actors_for_overlap(arg_6_5, num_2, math.max(num, hit_radius))

	local immediate_overlap, var_6_10 = PhysicsWorld.immediate_overlap(arg_6_5, "position", num_2, "rotation", arg_6_3, "size", var_6_5, "shape", "oobb", "types", "dynamics", "collision_filter", str)
	local tbl = {}
	local tbl_2 = {}

	for i = 1, var_6_10 do
		local var_6_13 = immediate_overlap[i]
		local unit = Actor.unit(var_6_13)
		local flag = unit == arg_6_0 or Unit.alive(unit)
		local flag_2 = not tbl_2[unit]

		if not flag and not flag_2 then
			tbl_2[unit] = true

			local is_enemy = DamageUtils.is_enemy(arg_6_0, unit)
			local is_player_unit = DamageUtils.is_player_unit(unit)
			local flag_3 = is_enemy or is_player_unit
			local has_extension = ScriptUnit.has_extension(unit, "status_system")

			if not flag_3 and not has_extension and not is_enemy then
				local get_data = Unit.get_data(unit, "breed")
				local calculate_aoe_size, var_6_23 = DamageUtils.calculate_aoe_size(unit, get_data)
				local var_6_24 = Vector3(0, 0, var_6_23 / 2)
				local rotate = Quaternion.rotate(arg_6_3, Vector3(calculate_aoe_size * num_3, 0, 0))
				local num_4 = POSITION_LOOKUP[unit] + Vector3(0, 0, var_6_23 / 2 + 0.1)
				local num_5 = num_4 - arg_6_2
				local max = math.max(Vector3.length(num_5), 0.0001)
				local divide = Vector3.divide(num_5, max)

				if shoot_warpfire_close_attack_dot < Vector3.dot(divide, arg_6_4) then
					local is_boss_in_los = PerceptionUtils.is_boss_in_los(arg_6_0, arg_6_2, num_4, arg_6_5)
					local flag_4 = not not is_boss_in_los or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, num_4, arg_6_5, "filter_ai_line_of_sight_check")

					if is_boss_in_los or not is_player_unit then
						flag_4 = flag_4 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, num_4 + rotate, arg_6_5, "filter_ai_line_of_sight_check")
						flag_4 = flag_4 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, num_4 - rotate, arg_6_5, "filter_ai_line_of_sight_check")
						flag_4 = flag_4 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, num_4 + var_6_24, arg_6_5, "filter_ai_line_of_sight_check")
						flag_4 = flag_4 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, num_4 - var_6_24, arg_6_5, "filter_ai_line_of_sight_check")
					end

					if not flag_4 then
						tbl[#tbl + 1] = {
							unit = unit,
							distance = max
						}
					end
				end
			end
		end
	end

	return not (#tbl > 0) or tbl
end

EnemyCharacterStateHelper_2._check_within_line_of_sight_gutter_runner = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local vs_gutter_runner = PlayerBreeds.vs_gutter_runner
	local pounce_speed = vs_gutter_runner.pounce_speed
	local pounce_upwards_amount = vs_gutter_runner.pounce_upwards_amount
	local num = 0.2
	local str = "filter_melee_sweep"
	local mean_dt = Managers.time:mean_dt()
	local num_2 = Vector3.normalize(arg_7_4 + Vector3(0, 0, pounce_upwards_amount)) * pounce_speed
	local var_7_7 = arg_7_2
	local var_7_8 = var_7_7
	local var_7_9
	local var_7_10
	local num_3 = 0.05

	PhysicsWorld.prepare_actors_for_overlap(arg_7_5, var_7_7, pounce_speed)

	for i = num_3, 5, num_3 do
		num_2.z = num_2.z - vs_gutter_runner.pounce_gravity * i
		var_7_7 = var_7_7 + Vector3.multiply(num_2, i)

		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(arg_7_5, var_7_8, var_7_7, num, 10, "collision_filter", str)

		if not linear_sphere_sweep then
			local flag = false

			for j = 1, #linear_sphere_sweep do
				local var_7_14 = linear_sphere_sweep[j]
				local unit = Actor.unit(var_7_14.actor)

				if unit ~= arg_7_0 then
					flag = true

					if not DamageUtils.is_enemy(arg_7_0, unit) and not BLACKBOARDS[unit] then
						local world_position = Unit.world_position(unit, Unit.node(unit, "c_spine"))

						var_7_10 = Vector3.distance(arg_7_2, world_position)
						var_7_9 = unit

						break
					end
				end
			end

			if not flag then
				break
			end
		end

		var_7_8 = var_7_7
		num = math.lerp(num_3, vs_gutter_runner.pounce_hit_radius, num_3 * 2.5)
	end

	return not var_7_9 and {
		{
			unit = var_7_9,
			distance = var_7_10
		}
	}
end

EnemyCharacterStateHelper_2._check_within_impact_globadier = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	local globe_throw_aoe_radius = PlayerBreeds.vs_poison_wind_globadier.globe_throw_aoe_radius
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = Managers.state.side.side_by_unit[arg_8_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local tbl = {}
	local POSITION_LOOKUP = POSITION_LOOKUP

	for k, v in pairs(VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS) do
		local var_8_4 = POSITION_LOOKUP[k]
		local distance = Vector3.distance(var_8_4, arg_8_6)

		if distance <= globe_throw_aoe_radius then
			tbl[#tbl + 1] = {
				unit = k,
				distance = distance
			}
		end
	end

	return not (#tbl > 0) or tbl
end
