-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_helper.lua

EnemyCharacterStateHelper = EnemyCharacterStateHelper or {}

local var_0_0 = EnemyCharacterStateHelper

var_0_0.get_enemies_in_line_of_sight = function (arg_1_0, arg_1_1, arg_1_2, ...)
	local var_1_0 = POSITION_LOOKUP[arg_1_1]
	local var_1_1 = Unit.world_rotation(arg_1_1, 0)
	local var_1_2 = Vector3.normalize(Quaternion.forward(var_1_1))
	local var_1_3 = Unit.get_data(arg_1_0, "breed")
	local var_1_4

	if var_1_3.name == "vs_packmaster" then
		return var_0_0._check_within_line_of_sight_packmaster(arg_1_0, arg_1_1, var_1_0, var_1_1, var_1_2, arg_1_2, ...)
	elseif var_1_3.name == "vs_ratling_gunner" then
		return var_0_0._check_within_line_of_sight_ratling_gunner(arg_1_0, arg_1_1, var_1_0, var_1_1, var_1_2, arg_1_2, ...)
	elseif var_1_3.name == "vs_warpfire_thrower" then
		return var_0_0._check_within_line_of_sight_warpfire_thrower(arg_1_0, arg_1_1, var_1_0, var_1_1, var_1_2, arg_1_2, ...)
	elseif var_1_3.name == "vs_gutter_runner" then
		return var_0_0._check_within_line_of_sight_gutter_runner(arg_1_0, arg_1_1, var_1_0, var_1_1, var_1_2, arg_1_2, ...)
	elseif var_1_3.name == "vs_poison_wind_globadier" then
		return var_0_0._check_within_impact_globadier(arg_1_0, arg_1_1, var_1_0, var_1_1, var_1_2, arg_1_2, ...)
	end
end

var_0_0._check_within_line_of_sight_packmaster = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = Managers.state.side.side_by_unit[arg_2_0].ENEMY_PLAYER_AND_BOT_UNITS
	local var_2_1 = PlayerBreeds.vs_packmaster
	local var_2_2 = var_2_1.grab_hook_range
	local var_2_3 = var_2_1.grab_hook_cone_dot
	local var_2_4
	local var_2_5 = 0
	local var_2_6 = 0

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		repeat
			local var_2_7 = ScriptUnit.has_extension(iter_2_1, "status_system")

			if not var_2_7 or var_2_7:is_disabled() then
				break
			end

			if not Unit.has_node(iter_2_1, "j_claw_attach") then
				break
			end

			local var_2_8, var_2_9, var_2_10 = var_0_0._check_within_cone(arg_2_2, arg_2_4, iter_2_1, var_2_2, var_2_3)

			if not var_2_8 then
				break
			end

			if not PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_2_5, arg_2_0, iter_2_1) then
				break
			end

			if var_2_6 <= var_2_9 then
				var_2_6 = var_2_9
				var_2_4 = iter_2_1
				var_2_5 = var_2_10
			end
		until true
	end

	return var_2_4, var_2_5
end

var_0_0._check_within_cone = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Unit.world_position(arg_3_2, Unit.node(arg_3_2, "j_claw_attach"))
	local var_3_1 = Vector3.normalize(var_3_0 - arg_3_0)
	local var_3_2 = Vector3.dot(arg_3_1, var_3_1)
	local var_3_3 = Vector3.distance(var_3_0, arg_3_0)
	local var_3_4 = var_3_3 < arg_3_3

	if arg_3_4 <= var_3_2 and var_3_4 and var_0_0.is_infront_player(arg_3_0, arg_3_1, var_3_0) then
		return true, var_3_2, var_3_3
	end
end

var_0_0.is_infront_player = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = Vector3.normalize(arg_4_2 - arg_4_0)

	if Vector3.dot(var_4_0, arg_4_1) > 0 then
		return true
	end
end

var_0_0._check_within_line_of_sight_ratling_gunner = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = Managers.state.side.side_by_unit[arg_5_0].ENEMY_PLAYER_AND_BOT_UNITS
	local var_5_1 = LightWeightProjectiles.ratling_gunner_vs.spread * 2
	local var_5_2 = {}

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		repeat
			local var_5_3 = Unit.world_position(iter_5_1, Unit.node(iter_5_1, "c_spine"))
			local var_5_4 = Vector3.normalize(var_5_3 - arg_5_2)
			local var_5_5 = Vector3.dot(arg_5_4, var_5_4)

			if var_5_1 < math.acos(var_5_5) then
				break
			end

			local var_5_6 = Vector3.distance(var_5_3, arg_5_2)
			local var_5_7, var_5_8, var_5_9, var_5_10, var_5_11 = PhysicsWorld.immediate_raycast(arg_5_5, arg_5_2, var_5_4, var_5_6, "closest", "collision_filter", "filter_husk_in_line_of_sight")

			if var_5_7 then
				break
			end

			var_5_2[#var_5_2 + 1] = {
				unit = iter_5_1,
				distance = var_5_6
			}
		until true
	end

	return #var_5_2 > 0 and var_5_2
end

var_0_0._check_within_line_of_sight_warpfire_thrower = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = PlayerBreeds.vs_warpfire_thrower
	local var_6_1 = BLACKBOARDS[arg_6_0].warpfire_data
	local var_6_2 = var_6_1.attack_range / 2
	local var_6_3 = var_6_1.hit_radius
	local var_6_4 = var_6_0.shoot_warpfire_close_attack_dot
	local var_6_5 = Vector3(var_6_3, var_6_2, var_6_3)
	local var_6_6 = arg_6_2 + arg_6_4 * var_6_2
	local var_6_7 = 0.5
	local var_6_8 = "filter_character_trigger"

	PhysicsWorld.prepare_actors_for_overlap(arg_6_5, var_6_6, math.max(var_6_2, var_6_3))

	local var_6_9, var_6_10 = PhysicsWorld.immediate_overlap(arg_6_5, "position", var_6_6, "rotation", arg_6_3, "size", var_6_5, "shape", "oobb", "types", "dynamics", "collision_filter", var_6_8)
	local var_6_11 = {}
	local var_6_12 = {}

	for iter_6_0 = 1, var_6_10 do
		local var_6_13 = var_6_9[iter_6_0]
		local var_6_14 = Actor.unit(var_6_13)
		local var_6_15 = var_6_14 ~= arg_6_0 and Unit.alive(var_6_14)
		local var_6_16 = not var_6_12[var_6_14]

		if var_6_15 and var_6_16 then
			var_6_12[var_6_14] = true

			local var_6_17 = DamageUtils.is_enemy(arg_6_0, var_6_14)
			local var_6_18 = DamageUtils.is_player_unit(var_6_14)
			local var_6_19 = var_6_17 or var_6_18
			local var_6_20 = ScriptUnit.has_extension(var_6_14, "status_system")

			if var_6_19 and var_6_20 and var_6_17 then
				local var_6_21 = Unit.get_data(var_6_14, "breed")
				local var_6_22, var_6_23 = DamageUtils.calculate_aoe_size(var_6_14, var_6_21)
				local var_6_24 = Vector3(0, 0, var_6_23 / 2)
				local var_6_25 = Quaternion.rotate(arg_6_3, Vector3(var_6_22 * var_6_7, 0, 0))
				local var_6_26 = POSITION_LOOKUP[var_6_14] + Vector3(0, 0, var_6_23 / 2 + 0.1)
				local var_6_27 = var_6_26 - arg_6_2
				local var_6_28 = math.max(Vector3.length(var_6_27), 0.0001)
				local var_6_29 = Vector3.divide(var_6_27, var_6_28)

				if var_6_4 < Vector3.dot(var_6_29, arg_6_4) then
					local var_6_30 = PerceptionUtils.is_boss_in_los(arg_6_0, arg_6_2, var_6_26, arg_6_5)
					local var_6_31 = not var_6_30 and PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, var_6_26, arg_6_5, "filter_ai_line_of_sight_check")

					if not var_6_30 and var_6_18 then
						var_6_31 = var_6_31 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, var_6_26 + var_6_25, arg_6_5, "filter_ai_line_of_sight_check")
						var_6_31 = var_6_31 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, var_6_26 - var_6_25, arg_6_5, "filter_ai_line_of_sight_check")
						var_6_31 = var_6_31 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, var_6_26 + var_6_24, arg_6_5, "filter_ai_line_of_sight_check")
						var_6_31 = var_6_31 or PerceptionUtils.is_position_in_line_of_sight(arg_6_0, arg_6_2, var_6_26 - var_6_24, arg_6_5, "filter_ai_line_of_sight_check")
					end

					if var_6_31 then
						var_6_11[#var_6_11 + 1] = {
							unit = var_6_14,
							distance = var_6_28
						}
					end
				end
			end
		end
	end

	return #var_6_11 > 0 and var_6_11
end

var_0_0._check_within_line_of_sight_gutter_runner = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = PlayerBreeds.vs_gutter_runner
	local var_7_1 = var_7_0.pounce_speed
	local var_7_2 = var_7_0.pounce_upwards_amount
	local var_7_3 = 0.2
	local var_7_4 = "filter_melee_sweep"
	local var_7_5 = Managers.time:mean_dt()
	local var_7_6 = Vector3.normalize(arg_7_4 + Vector3(0, 0, var_7_2)) * var_7_1
	local var_7_7 = arg_7_2
	local var_7_8 = var_7_7
	local var_7_9
	local var_7_10
	local var_7_11 = 0.05

	PhysicsWorld.prepare_actors_for_overlap(arg_7_5, var_7_7, var_7_1)

	for iter_7_0 = var_7_11, 5, var_7_11 do
		var_7_6.z = var_7_6.z - var_7_0.pounce_gravity * iter_7_0
		var_7_7 = var_7_7 + Vector3.multiply(var_7_6, iter_7_0)

		local var_7_12 = PhysicsWorld.linear_sphere_sweep(arg_7_5, var_7_8, var_7_7, var_7_3, 10, "collision_filter", var_7_4)

		if var_7_12 then
			local var_7_13 = false

			for iter_7_1 = 1, #var_7_12 do
				local var_7_14 = var_7_12[iter_7_1]
				local var_7_15 = Actor.unit(var_7_14.actor)

				if var_7_15 ~= arg_7_0 then
					var_7_13 = true

					if DamageUtils.is_enemy(arg_7_0, var_7_15) and BLACKBOARDS[var_7_15] then
						local var_7_16 = Unit.world_position(var_7_15, Unit.node(var_7_15, "c_spine"))

						var_7_10 = Vector3.distance(arg_7_2, var_7_16)
						var_7_9 = var_7_15

						break
					end
				end
			end

			if var_7_13 then
				break
			end
		end

		var_7_8 = var_7_7
		var_7_3 = math.lerp(var_7_11, var_7_0.pounce_hit_radius, var_7_11 * 2.5)
	end

	return var_7_9 and {
		{
			unit = var_7_9,
			distance = var_7_10
		}
	}
end

var_0_0._check_within_impact_globadier = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = PlayerBreeds.vs_poison_wind_globadier.globe_throw_aoe_radius
	local var_8_1 = Managers.state.side.side_by_unit[arg_8_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_8_2 = {}
	local var_8_3 = POSITION_LOOKUP

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		local var_8_4 = var_8_3[iter_8_0]
		local var_8_5 = Vector3.distance(var_8_4, arg_8_6)

		if var_8_5 <= var_8_0 then
			var_8_2[#var_8_2 + 1] = {
				unit = iter_8_0,
				distance = var_8_5
			}
		end
	end

	return #var_8_2 > 0 and var_8_2
end
