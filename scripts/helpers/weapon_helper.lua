-- chunkname: @scripts/helpers/weapon_helper.lua

require("scripts/helpers/effect_helper")

WeaponHelper = WeaponHelper or {}

local var_0_0 = POSITION_LOOKUP

function WeaponHelper.wanted_projectile_angle(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = Vector3.length(Vector3.flat(arg_1_1))

	if var_1_0 <= 0 then
		return
	end

	local var_1_1 = arg_1_1.z
	local var_1_2 = arg_1_2
	local var_1_3 = arg_1_3
	local var_1_4 = var_1_3 * var_1_3
	local var_1_5 = var_1_4 * var_1_4 - var_1_2 * (var_1_2 * var_1_0 * var_1_0 + 2 * var_1_1 * var_1_4)

	fassert(var_1_2 ~= 0, "Asking for projectile angle with gravity 0, this will cause division by 0.")

	if var_1_5 < 0 then
		return
	end

	local var_1_6 = math.sqrt(var_1_5)
	local var_1_7 = math.atan((var_1_4 - var_1_6) / (var_1_2 * var_1_0))
	local var_1_8 = math.atan((var_1_4 + var_1_6) / (var_1_2 * var_1_0))

	return var_1_7, var_1_8, var_1_0
end

function WeaponHelper.wanted_projectile_speed(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Vector3.length(Vector3.flat(arg_2_1))
	local var_2_1 = arg_2_1.z
	local var_2_2 = math.abs(arg_2_2)
	local var_2_3 = 2 * (var_2_0 * math.tan(arg_2_3) - var_2_1)

	fassert(var_2_3 ~= 0, "Denominator is 0.")

	local var_2_4 = math.abs(var_2_2 / var_2_3)

	if var_2_4 >= 0 then
		return var_2_0 / math.cos(arg_2_3) * math.sqrt(var_2_4), var_2_0
	end
end

function WeaponHelper.speed_to_hit_moving_target(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_1
	local var_3_1 = arg_3_1
	local var_3_2 = math.cos(arg_3_2)

	for iter_3_0 = 1, 10 do
		local var_3_3 = var_3_0 - arg_3_0
		local var_3_4, var_3_5 = WeaponHelper:wanted_projectile_speed(var_3_3, arg_3_4, arg_3_2)

		var_3_0 = arg_3_1 + var_3_5 / (var_3_4 * var_3_2) * arg_3_3

		if arg_3_5 >= Vector3.length(var_3_0 - var_3_1) then
			return var_3_4, var_3_0
		end

		var_3_1 = var_3_0
	end
end

function WeaponHelper.angle_to_hit_moving_target(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = 0
	local var_4_1
	local var_4_2 = 0.01

	assert(arg_4_4 > 0, "Can't solve for <=0 gravity, use different projectile template")

	local var_4_3 = arg_4_1
	local var_4_4 = Vector3.length(Vector3.flat(var_4_3 - arg_4_0))
	local var_4_5 = var_4_4

	for iter_4_0 = 1, 10 do
		local var_4_6 = var_4_3.z - arg_4_0.z
		local var_4_7 = arg_4_2^2

		if var_4_4 < var_4_2 then
			return 0, var_4_3
		end

		local var_4_8 = var_4_7^2 - arg_4_4 * (arg_4_4 * var_4_4^2 + 2 * var_4_6 * var_4_7)

		if var_4_8 <= 0 then
			return nil, var_4_3
		end

		local var_4_9 = math.sqrt(var_4_8)
		local var_4_10 = math.atan((var_4_7 + var_4_9) / (arg_4_4 * var_4_4))
		local var_4_11 = math.atan((var_4_7 - var_4_9) / (arg_4_4 * var_4_4))

		var_4_1 = arg_4_6 and math.max(var_4_10, var_4_11) or math.min(var_4_10, var_4_11)
		var_4_3 = arg_4_1 + var_4_4 / (arg_4_2 * math.cos(var_4_1)) * arg_4_3
		var_4_4 = Vector3.length(Vector3.flat(var_4_3 - arg_4_0))

		if arg_4_5 >= math.abs(var_4_5 - var_4_4) then
			return var_4_1, var_4_3
		end

		var_4_5 = var_4_4
	end

	return var_4_1, var_4_3
end

function WeaponHelper.test_angled_trajectory(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9)
	table.clear(arg_5_6)

	local var_5_0 = arg_5_2 - arg_5_1
	local var_5_1
	local var_5_2
	local var_5_3

	if arg_5_5 then
		arg_5_4, var_5_1 = WeaponHelper:wanted_projectile_speed(var_5_0, -arg_5_3, arg_5_5)
	elseif arg_5_4 then
		local var_5_4, var_5_5, var_5_6 = WeaponHelper:wanted_projectile_angle(var_5_0, -arg_5_3, arg_5_4)

		var_5_1 = var_5_6

		local var_5_7 = var_5_5

		arg_5_5 = var_5_4 or var_5_7
	end

	if arg_5_5 and arg_5_4 then
		local var_5_8 = Vector3.normalize(Vector3.flat(var_5_0))
		local var_5_9 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_5_8, Vector3.up()), arg_5_5), var_5_8) * arg_5_4
		local var_5_10 = math.cos(arg_5_5) * arg_5_4
		local var_5_11 = math.sin(arg_5_5) * arg_5_4
		local var_5_12 = var_5_1 / Vector3.length(Vector3(var_5_9.x, var_5_9.y, 0))

		arg_5_7 = arg_5_7 or 4

		local var_5_13 = 0
		local var_5_14 = var_5_12 / arg_5_7
		local var_5_15 = Vector3(arg_5_1.x, arg_5_1.y, arg_5_1.z)
		local var_5_16

		arg_5_6[1] = arg_5_1

		for iter_5_0 = 1, arg_5_7 do
			local var_5_17 = var_5_12 * (iter_5_0 / arg_5_7)
			local var_5_18 = var_5_10 * var_5_17
			local var_5_19 = var_5_11 * var_5_17 + 0.5 * arg_5_3 * var_5_17^2
			local var_5_20 = arg_5_1 + var_5_8 * var_5_18

			var_5_20.z = var_5_20.z + var_5_19

			if not arg_5_9 then
				local var_5_21 = var_5_20 - var_5_15
				local var_5_22, var_5_23, var_5_24, var_5_25, var_5_26 = PhysicsWorld.immediate_raycast(arg_5_0, var_5_15, var_5_21, Vector3.length(var_5_21), "closest", "collision_filter", arg_5_8 or "filter_ai_mover")

				if var_5_22 then
					if iter_5_0 == arg_5_7 then
						local var_5_27 = Actor.unit(var_5_26)

						if var_0_0[var_5_27] then
							return true, var_5_9, var_5_12
						end
					end

					return false
				end
			end

			var_5_15 = Vector3(var_5_20.x, var_5_20.y, var_5_20.z)
			arg_5_6[iter_5_0 + 1] = var_5_15
		end

		return true, var_5_9, var_5_12, arg_5_5
	end
end

function WeaponHelper.ray_segmented_test(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1[1] + arg_6_2
	local var_6_1 = #arg_6_1

	for iter_6_0 = 2, var_6_1 do
		local var_6_2 = arg_6_1[iter_6_0] + arg_6_2
		local var_6_3 = var_6_2 - var_6_0

		if Vector3.length(var_6_3) < 0.001 then
			local var_6_4 = math.random()
		end

		local var_6_5, var_6_6, var_6_7, var_6_8, var_6_9 = PhysicsWorld.immediate_raycast(arg_6_0, var_6_0, var_6_3, Vector3.length(var_6_3), "closest", "collision_filter", "filter_ai_mover")

		if script_data.debug_ai_movement then
			QuickDrawerStay:line(var_6_0, var_6_2, Colors.get_indexed(iter_6_0))
		end

		if var_6_5 then
			if iter_6_0 == var_6_1 then
				local var_6_10 = Actor.unit(var_6_9)

				if var_0_0[var_6_10] then
					return true
				end
			end

			return false
		end

		var_6_0 = var_6_2
	end

	return true
end

function WeaponHelper.multi_ray_test(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = PhysicsWorld.immediate_raycast

	if script_data.debug_ai_movement then
		QuickDrawerStay:line(arg_7_1, arg_7_2, Color(100, 255, 0))
	end

	local var_7_1 = arg_7_2 - arg_7_1
	local var_7_2 = Vector3.length(var_7_1)
	local var_7_3, var_7_4, var_7_5, var_7_6, var_7_7 = var_7_0(arg_7_0, arg_7_1, var_7_1, var_7_2, "closest", "collision_filter", "filter_ai_mover")

	if var_7_3 then
		local var_7_8 = Actor.unit(var_7_7)

		if not var_0_0[var_7_8] then
			return false
		end
	end

	local var_7_9 = Vector3.cross(Vector3.normalize(arg_7_2 - arg_7_1), Vector3.up()) * 1

	for iter_7_0 = 1, #arg_7_3, 2 do
		local var_7_10 = arg_7_3[iter_7_0]
		local var_7_11 = arg_7_3[iter_7_0 + 1]
		local var_7_12 = var_7_10 * var_7_9 + var_7_11 * Vector3.up()
		local var_7_13 = arg_7_1 + var_7_12
		local var_7_14 = arg_7_2 + var_7_12
		local var_7_15, var_7_16, var_7_17, var_7_18, var_7_19 = var_7_0(arg_7_0, var_7_13, var_7_1, var_7_2, "closest", "collision_filter", "filter_ai_mover")

		if script_data.debug_ai_movement then
			QuickDrawerStay:line(var_7_13, var_7_14, Colors.get_indexed(iter_7_0))
		end

		if var_7_15 then
			local var_7_20 = Actor.unit(var_7_19)

			if not var_0_0[var_7_20] then
				return false
			end
		end
	end

	return true
end

function WeaponHelper.draw_ball_at_time(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = arg_8_6 * arg_8_4
	local var_8_1 = arg_8_6 * arg_8_5 + 0.5 * arg_8_3 * arg_8_6^2
	local var_8_2 = arg_8_1 + arg_8_2 * var_8_0

	var_8_2.z = var_8_2.z + var_8_1

	QuickDrawer:sphere(var_8_2, 0.3, arg_8_7 or Colors.get_indexed(66))

	return var_8_2
end

function WeaponHelper.calculate_trajectory(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = Managers.state.debug:drawer({
		mode = "retained",
		name = "trajectory_vectors"
	})

	var_9_0:reset()

	local var_9_1 = arg_9_3 - arg_9_2
	local var_9_2 = Vector3.normalize(Vector3.flat(var_9_1))
	local var_9_3 = 30 + math.random(30)
	local var_9_4 = math.degrees_to_radians(var_9_3)
	local var_9_5
	local var_9_6 = math.round(WeaponHelper:wanted_projectile_speed(var_9_1, arg_9_4, var_9_4) * 100, 0)

	if var_9_6 <= arg_9_5 then
		var_9_5 = WeaponHelper:_trajectory_hits_target(arg_9_1, var_9_4, var_9_6 / 100, arg_9_4, arg_9_2, arg_9_3, var_9_2, var_9_0)
	end

	if not var_9_5 then
		for iter_9_0 = 0, 4 do
			var_9_3 = 30 + 10 * iter_9_0

			local var_9_7 = math.degrees_to_radians(var_9_3)

			var_9_6 = math.round(WeaponHelper:wanted_projectile_speed(var_9_1, arg_9_4, var_9_7) * 100, 0)

			if var_9_6 <= arg_9_5 then
				var_9_5 = WeaponHelper:_trajectory_hits_target(arg_9_1, var_9_7, var_9_6 / 100, arg_9_4, arg_9_2, arg_9_3, var_9_2, var_9_0)
			end

			if var_9_5 then
				break
			end
		end
	end

	return var_9_5, var_9_3, var_9_6
end

function WeaponHelper._trajectory_hits_target(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8)
	local var_10_0 = {}
	local var_10_1 = World.get_data(arg_10_1, "physics_world")

	for iter_10_0 = 0, 5, 0.5 do
		var_10_0[#var_10_0 + 1] = WeaponHelper:position_on_trajectory(arg_10_5, arg_10_7, arg_10_3, arg_10_2, arg_10_4, iter_10_0)

		if Development.parameter("ai_debug_trajectory_raycast") then
			arg_10_8:sphere(var_10_0[#var_10_0], 0.1, Color(255, 255, 255, 255))
		end

		if iter_10_0 > 0 then
			local var_10_2 = var_10_0[#var_10_0] - var_10_0[#var_10_0 - 1]
			local var_10_3 = Vector3.normalize(var_10_2)
			local var_10_4 = Vector3.length(var_10_2)
			local var_10_5, var_10_6, var_10_7, var_10_8, var_10_9 = PhysicsWorld.immediate_raycast(var_10_1, var_10_0[#var_10_0 - 1], var_10_2, var_10_4, "closest", "collision_filter", "filter_enemy_ray_projectile")

			if Development.parameter("ai_debug_trajectory_raycast") then
				arg_10_8:vector(var_10_0[#var_10_0 - 1], var_10_2, Color(255, 255, 255, 255))
			end

			if var_10_5 then
				local var_10_10 = DamageUtils.is_player_unit(Actor.unit(var_10_9))
				local var_10_11 = Vector3.distance_squared(arg_10_6, var_10_6)
				local var_10_12 = var_10_11 < 0.04 or var_10_11 < 1 and var_10_10

				if Development.parameter("ai_debug_trajectory_raycast") then
					WeaponHelper:debug_draw_trajectory_hit(var_10_6, var_10_12, arg_10_8)
				end

				return var_10_12
			end
		end
	end

	return false
end

function WeaponHelper.position_on_trajectory(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	local var_11_0 = arg_11_3 * arg_11_6 * math.cos(arg_11_4)
	local var_11_1 = arg_11_3 * arg_11_6 * math.sin(arg_11_4) + 0.5 * arg_11_5 * arg_11_6^2
	local var_11_2 = arg_11_1 + arg_11_2 * var_11_0

	var_11_2.z = var_11_2.z + var_11_1

	return var_11_2
end

function WeaponHelper.debug_draw_trajectory_hit(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_2 and Color(255, 74, 247, 115) or Color(255, 245, 108, 49)

	arg_12_3:sphere(arg_12_1, 0.1, var_12_0)
end

local var_0_1 = 30
local var_0_2 = 10
local var_0_3 = 0.0001

function WeaponHelper.ground_target(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = var_0_2 / var_0_1
	local var_13_1 = arg_13_3
	local var_13_2 = Vector3(0, 0, 0.1)

	for iter_13_0 = 1, var_0_1 do
		local var_13_3 = var_13_1 + arg_13_4 * var_13_0
		local var_13_4 = var_13_3 - var_13_1
		local var_13_5 = Vector3.normalize(var_13_4)
		local var_13_6 = Vector3.length(var_13_4)
		local var_13_7, var_13_8, var_13_9, var_13_10, var_13_11 = PhysicsWorld.immediate_raycast(arg_13_1, var_13_1, var_13_5, var_13_6, "closest", "collision_filter", arg_13_6)

		if var_13_7 then
			local var_13_12 = true
			local var_13_13 = Vector3.dot(var_13_10, Vector3.up()) < 0.95

			if not var_13_13 then
				local var_13_14, var_13_15 = Unit.mover_fits_at(arg_13_2, "standing", var_13_8 + var_13_2, 1)

				if var_13_14 then
					var_13_8 = var_13_15
				else
					var_13_12 = false
				end
			end

			if var_13_13 or not var_13_12 then
				local var_13_16 = Vector3.length(Vector3.flat(arg_13_4))

				for iter_13_1 = 1, var_0_1 do
					local var_13_17 = iter_13_1 == 1 and 0.5 or 1
					local var_13_18 = var_13_16 <= var_0_3 and 0 or var_13_17 / var_13_16
					local var_13_19

					if var_13_18 > 0 then
						var_13_19 = var_13_8 - arg_13_4 * var_13_18 - arg_13_5 * (var_13_18 * var_13_18 * 0.5)
					else
						var_13_19 = arg_13_3
					end

					local var_13_20, var_13_21, var_13_22, var_13_23, var_13_24 = PhysicsWorld.immediate_raycast(arg_13_1, var_13_19, Vector3.down(), 10, "closest", "collision_filter", arg_13_6)

					if var_13_20 then
						local var_13_25, var_13_26 = Unit.mover_fits_at(arg_13_2, "standing", var_13_21 + var_13_2, 1)

						if var_13_25 then
							local var_13_27 = var_13_26

							return true, var_13_27
						else
							var_13_8 = var_13_19
						end
					end
				end
			end

			return true, var_13_8
		end

		arg_13_4 = arg_13_4 + arg_13_5 * var_13_0
		var_13_1 = var_13_3
	end

	return false, var_13_1
end

function WeaponHelper.ballistic_raycast(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8)
	local var_14_0 = arg_14_3 / arg_14_2

	for iter_14_0 = 1, arg_14_2 do
		local var_14_1 = arg_14_4 + arg_14_5 * var_14_0
		local var_14_2 = var_14_1 - arg_14_4
		local var_14_3 = Vector3.normalize(var_14_2)
		local var_14_4 = Vector3.length(var_14_2)
		local var_14_5, var_14_6, var_14_7, var_14_8, var_14_9 = PhysicsWorld.immediate_raycast(arg_14_1, arg_14_4, var_14_3, var_14_4, "closest", "collision_filter", arg_14_7)

		if var_14_6 then
			return var_14_5, var_14_6, var_14_7, var_14_8, var_14_9
		end

		arg_14_5 = arg_14_5 + arg_14_6 * var_14_0
		arg_14_4 = var_14_1
	end

	return false, arg_14_4
end

function WeaponHelper.look_at_enemy_or_static_position(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	local var_15_0, var_15_1, var_15_2 = PhysicsWorld.immediate_raycast(arg_15_1, arg_15_2, arg_15_3, arg_15_6, "closest", "collision_filter", "filter_player_ray_projectile_static_only")
	local var_15_3 = var_15_2 or arg_15_6
	local var_15_4 = arg_15_2 + arg_15_3 * var_15_3 / 2
	local var_15_5 = var_15_3 / 2

	PhysicsWorld.prepare_actors_for_overlap(arg_15_1, var_15_4, var_15_5 * var_15_5)

	local var_15_6 = PhysicsWorld.linear_sphere_sweep(arg_15_1, arg_15_2 + arg_15_3 * (arg_15_5 / 2), arg_15_2 + arg_15_3 * var_15_3, arg_15_5, 100, "types", "both", "collision_filter", "filter_player_ray_projectile", "report_initial_overlap")
	local var_15_7 = Managers.state.side
	local var_15_8 = var_15_7.side_by_unit
	local var_15_9 = var_15_6 and #var_15_6 or 0
	local var_15_10

	for iter_15_0 = 1, var_15_9 do
		local var_15_11 = var_15_6[iter_15_0]
		local var_15_12 = var_15_11.actor

		if var_15_12 then
			local var_15_13 = Actor.unit(var_15_12)

			if ScriptUnit.has_extension(var_15_13, "health_system") then
				local var_15_14 = var_15_8[var_15_13]

				if not arg_15_4 or not var_15_14 or var_15_7:is_enemy_by_side(arg_15_4, var_15_14) then
					local var_15_15 = Actor.node(var_15_12)
					local var_15_16 = AiUtils.unit_breed(var_15_13)
					local var_15_17 = var_15_16 and var_15_16.hit_zones_lookup[var_15_15]

					if not var_15_17 or var_15_17.name ~= "afro" then
						var_15_10 = var_15_11.position

						break
					end
				end
			end
		end
	end

	return var_15_10 or var_15_1 or arg_15_2 + arg_15_3 * arg_15_6
end
