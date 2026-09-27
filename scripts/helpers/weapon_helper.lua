-- chunkname: @scripts/helpers/weapon_helper.lua

require("scripts/helpers/effect_helper")

local WeaponHelper = WeaponHelper

WeaponHelper = WeaponHelper or {}
WeaponHelper = WeaponHelper

local POSITION_LOOKUP = POSITION_LOOKUP

WeaponHelper.wanted_projectile_angle = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local length = Vector3.length(Vector3.flat(arg_1_1))

	if length <= 0 then
		return
	end

	local z = arg_1_1.z
	local var_1_2 = arg_1_2
	local var_1_3 = arg_1_3
	local num = var_1_3 * var_1_3
	local num_2 = num * num - var_1_2 * (var_1_2 * length * length + 2 * z * num)

	fassert(var_1_2 ~= 0, "Asking for projectile angle with gravity 0, this will cause division by 0.")

	if num_2 < 0 then
		return
	end

	local sqrt = math.sqrt(num_2)
	local atan = math.atan((num - sqrt) / (var_1_2 * length))
	local atan_2 = math.atan((num + sqrt) / (var_1_2 * length))

	return atan, atan_2, length
end

WeaponHelper.wanted_projectile_speed = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local length = Vector3.length(Vector3.flat(arg_2_1))
	local z = arg_2_1.z
	local abs = math.abs(arg_2_2)
	local num = 2 * (length * math.tan(arg_2_3) - z)

	fassert(num ~= 0, "Denominator is 0.")

	local abs_2 = math.abs(abs / num)

	if abs_2 >= 0 then
		return length / math.cos(arg_2_3) * math.sqrt(abs_2), length
	end
end

WeaponHelper.speed_to_hit_moving_target = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0 = arg_3_1
	local var_3_1 = arg_3_1
	local cos = math.cos(arg_3_2)

	for i = 1, 10 do
		local num = var_3_0 - arg_3_0
		local wanted_projectile_speed, var_3_5 = WeaponHelper:wanted_projectile_speed(num, arg_3_4, arg_3_2)

		var_3_0 = arg_3_1 + var_3_5 / (wanted_projectile_speed * cos) * arg_3_3

		if arg_3_5 >= Vector3.length(var_3_0 - var_3_1) then
			return wanted_projectile_speed, var_3_0
		end

		var_3_1 = var_3_0
	end
end

WeaponHelper.angle_to_hit_moving_target = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local num = 0
	local var_4_1
	local num_2 = 0.01

	assert(arg_4_4 > 0, "Can't solve for <=0 gravity, use different projectile template")

	local var_4_3 = arg_4_1
	local length = Vector3.length(Vector3.flat(var_4_3 - self))
	local var_4_5 = length

	for i = 1, 10 do
		local num_3 = var_4_3.z - self.z
		local num_4 = arg_4_2^2

		if length < num_2 then
			return 0, var_4_3
		end

		local num_5 = num_4^2 - arg_4_4 * (arg_4_4 * length^2 + 2 * num_3 * num_4)

		if num_5 <= 0 then
			return nil, var_4_3
		end

		local sqrt = math.sqrt(num_5)
		local atan = math.atan((num_4 + sqrt) / (arg_4_4 * length))
		local atan_2 = math.atan((num_4 - sqrt) / (arg_4_4 * length))

		var_4_1 = not arg_4_6 and math.max(atan, atan_2) and math.min(atan, atan_2)
		var_4_3 = arg_4_1 + length / (arg_4_2 * math.cos(var_4_1)) * arg_4_3
		length = Vector3.length(Vector3.flat(var_4_3 - self))

		if arg_4_5 >= math.abs(var_4_5 - length) then
			return var_4_1, var_4_3
		end

		var_4_5 = length
	end

	return var_4_1, var_4_3
end

WeaponHelper.test_angled_trajectory = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9)
	-- function 5
	table.clear(arg_5_6)

	local num = arg_5_2 - arg_5_1
	local var_5_1
	local var_5_2
	local var_5_3

	if not arg_5_5 then
		arg_5_4, var_5_1 = WeaponHelper:wanted_projectile_speed(num, -arg_5_3, arg_5_5)
	elseif not arg_5_4 then
		local wanted_projectile_angle, var_5_5, var_5_6 = WeaponHelper:wanted_projectile_angle(num, -arg_5_3, arg_5_4)

		var_5_1 = var_5_6

		local var_5_7 = var_5_5

		arg_5_5 = wanted_projectile_angle or var_5_7
	end

	if not arg_5_5 and not arg_5_4 then
		local normalize = Vector3.normalize(Vector3.flat(num))
		local num_2 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(normalize, Vector3.up()), arg_5_5), normalize) * arg_5_4
		local num_3 = math.cos(arg_5_5) * arg_5_4
		local num_4 = math.sin(arg_5_5) * arg_5_4
		local num_5 = var_5_1 / Vector3.length(Vector3(num_2.x, num_2.y, 0))

		arg_5_7 = arg_5_7 or 4

		local num_6 = 0
		local num_7 = num_5 / arg_5_7
		local var_5_15 = Vector3(arg_5_1.x, arg_5_1.y, arg_5_1.z)
		local var_5_16

		arg_5_6[1] = arg_5_1

		for i = 1, arg_5_7 do
			local num_8 = num_5 * (i / arg_5_7)
			local num_9 = num_3 * num_8
			local num_10 = num_4 * num_8 + 0.5 * arg_5_3 * num_8^2
			local num_11 = arg_5_1 + normalize * num_9

			num_11.z = num_11.z + num_10

			if not arg_5_9 then
				local num_12 = num_11 - var_5_15
				local immediate_raycast, var_5_23, var_5_24, var_5_25, var_5_26 = PhysicsWorld.immediate_raycast(arg_5_0, var_5_15, num_12, Vector3.length(num_12), "closest", "collision_filter", arg_5_8 or "filter_ai_mover")

				if not immediate_raycast then
					if i == arg_5_7 then
						local unit = Actor.unit(var_5_26)

						if not POSITION_LOOKUP[unit] then
							return true, num_2, num_5
						end
					end

					return false
				end
			end

			var_5_15 = Vector3(num_11.x, num_11.y, num_11.z)
			arg_5_6[i + 1] = var_5_15
		end

		return true, num_2, num_5, arg_5_5
	end
end

WeaponHelper.ray_segmented_test = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local num = arg_6_1[1] + arg_6_2
	local count = #arg_6_1

	for i = 2, count do
		local num_2 = arg_6_1[i] + arg_6_2
		local num_3 = num_2 - num

		if Vector3.length(num_3) < 0.001 then
			local random = math.random()
		end

		local immediate_raycast, var_6_6, var_6_7, var_6_8, var_6_9 = PhysicsWorld.immediate_raycast(arg_6_0, num, num_3, Vector3.length(num_3), "closest", "collision_filter", "filter_ai_mover")

		if not script_data.debug_ai_movement then
			QuickDrawerStay:line(num, num_2, Colors.get_indexed(i))
		end

		if not immediate_raycast then
			if i == count then
				local unit = Actor.unit(var_6_9)

				if not POSITION_LOOKUP[unit] then
					return true
				end
			end

			return false
		end

		num = num_2
	end

	return true
end

WeaponHelper.multi_ray_test = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local immediate_raycast = PhysicsWorld.immediate_raycast

	if not script_data.debug_ai_movement then
		QuickDrawerStay:line(arg_7_1, arg_7_2, Color(100, 255, 0))
	end

	local num = arg_7_2 - arg_7_1
	local length = Vector3.length(num)
	local var_7_3, var_7_4, var_7_5, var_7_6, var_7_7 = immediate_raycast(arg_7_0, arg_7_1, num, length, "closest", "collision_filter", "filter_ai_mover")

	if not var_7_3 then
		local unit = Actor.unit(var_7_7)

		if not POSITION_LOOKUP[unit] then
			return false
		end
	end

	local num_2 = Vector3.cross(Vector3.normalize(arg_7_2 - arg_7_1), Vector3.up()) * 1

	for i = 1, #arg_7_3, 2 do
		local var_7_10 = arg_7_3[i]
		local var_7_11 = arg_7_3[i + 1]
		local num_3 = var_7_10 * num_2 + var_7_11 * Vector3.up()
		local num_4 = arg_7_1 + num_3
		local num_5 = arg_7_2 + num_3
		local var_7_15, var_7_16, var_7_17, var_7_18, var_7_19 = immediate_raycast(arg_7_0, num_4, num, length, "closest", "collision_filter", "filter_ai_mover")

		if not script_data.debug_ai_movement then
			QuickDrawerStay:line(num_4, num_5, Colors.get_indexed(i))
		end

		if not var_7_15 then
			local unit_2 = Actor.unit(var_7_19)

			if not POSITION_LOOKUP[unit_2] then
				return false
			end
		end
	end

	return true
end

WeaponHelper.draw_ball_at_time = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	-- function 8
	local num = arg_8_6 * arg_8_4
	local num_2 = arg_8_6 * arg_8_5 + 0.5 * arg_8_3 * arg_8_6^2
	local num_3 = arg_8_1 + arg_8_2 * num

	num_3.z = num_3.z + num_2

	QuickDrawer:sphere(num_3, 0.3, arg_8_7 or Colors.get_indexed(66))

	return num_3
end

WeaponHelper.calculate_trajectory = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "trajectory_vectors"
	})

	drawer:reset()

	local num = arg_9_3 - arg_9_2
	local normalize = Vector3.normalize(Vector3.flat(num))
	local num_2 = 30 + math.random(30)
	local degrees_to_radians = math.degrees_to_radians(num_2)
	local var_9_5
	local round = math.round(WeaponHelper:wanted_projectile_speed(num, arg_9_4, degrees_to_radians) * 100, 0)

	if round <= arg_9_5 then
		var_9_5 = WeaponHelper:_trajectory_hits_target(arg_9_1, degrees_to_radians, round / 100, arg_9_4, arg_9_2, arg_9_3, normalize, drawer)
	end

	if not var_9_5 then
		for i = 0, 4 do
			num_2 = 30 + 10 * i

			local degrees_to_radians_2 = math.degrees_to_radians(num_2)

			round = math.round(WeaponHelper:wanted_projectile_speed(num, arg_9_4, degrees_to_radians_2) * 100, 0)

			if round <= arg_9_5 then
				var_9_5 = WeaponHelper:_trajectory_hits_target(arg_9_1, degrees_to_radians_2, round / 100, arg_9_4, arg_9_2, arg_9_3, normalize, drawer)
			end

			if not var_9_5 then
				break
			end
		end
	end

	return var_9_5, num_2, round
end

WeaponHelper._trajectory_hits_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8)
	-- function 10
	local tbl = {}
	local get_data = World.get_data(arg_10_1, "physics_world")

	for i = 0, 5, 0.5 do
		tbl[#tbl + 1] = WeaponHelper:position_on_trajectory(arg_10_5, arg_10_7, arg_10_3, arg_10_2, arg_10_4, i)

		if not Development.parameter("ai_debug_trajectory_raycast") then
			arg_10_8:sphere(tbl[#tbl], 0.1, Color(255, 255, 255, 255))
		end

		if i > 0 then
			local num = tbl[#tbl] - tbl[#tbl - 1]
			local normalize = Vector3.normalize(num)
			local length = Vector3.length(num)
			local immediate_raycast, var_10_6, var_10_7, var_10_8, var_10_9 = PhysicsWorld.immediate_raycast(get_data, tbl[#tbl - 1], num, length, "closest", "collision_filter", "filter_enemy_ray_projectile")

			if not Development.parameter("ai_debug_trajectory_raycast") then
				arg_10_8:vector(tbl[#tbl - 1], num, Color(255, 255, 255, 255))
			end

			if not immediate_raycast then
				local is_player_unit = DamageUtils.is_player_unit(Actor.unit(var_10_9))
				local distance_squared = Vector3.distance_squared(arg_10_6, var_10_6)
				local flag = distance_squared < 0.04 or not (distance_squared < 1) or is_player_unit

				if not Development.parameter("ai_debug_trajectory_raycast") then
					WeaponHelper:debug_draw_trajectory_hit(var_10_6, flag, arg_10_8)
				end

				return flag
			end
		end
	end

	return false
end

WeaponHelper.position_on_trajectory = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	local num = arg_11_3 * arg_11_6 * math.cos(arg_11_4)
	local num_2 = arg_11_3 * arg_11_6 * math.sin(arg_11_4) + 0.5 * arg_11_5 * arg_11_6^2
	local num_3 = arg_11_1 + arg_11_2 * num

	num_3.z = num_3.z + num_2

	return num_3
end

WeaponHelper.debug_draw_trajectory_hit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0

	if not arg_12_2 then
		var_12_0 = Color(255, 74, 247, 115)

		if not var_12_0 then
			-- Nothing
		end
	end

	var_12_0 = Color(255, 245, 108, 49)

	::label_12_0::

	arg_12_3:sphere(arg_12_1, 0.1, var_12_0)
end

local num = 30
local num_2 = 10
local num_3 = 0.0001

WeaponHelper.ground_target = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local num_4 = num_2 / num
	local var_13_1 = arg_13_3
	local var_13_2 = Vector3(0, 0, 0.1)

	for i = 1, num do
		local num_5 = var_13_1 + arg_13_4 * num_4
		local num_6 = num_5 - var_13_1
		local normalize = Vector3.normalize(num_6)
		local length = Vector3.length(num_6)
		local immediate_raycast, var_13_8, var_13_9, var_13_10, var_13_11 = PhysicsWorld.immediate_raycast(arg_13_1, var_13_1, normalize, length, "closest", "collision_filter", arg_13_6)

		if not immediate_raycast then
			local flag = true
			local flag_2 = Vector3.dot(var_13_10, Vector3.up()) < 0.95

			if not flag_2 then
				local mover_fits_at, var_13_15 = Unit.mover_fits_at(arg_13_2, "standing", var_13_8 + var_13_2, 1)

				if not mover_fits_at then
					var_13_8 = var_13_15
				else
					flag = false
				end
			end

			if not (flag_2 or flag) then
				local length_2 = Vector3.length(Vector3.flat(arg_13_4))

				for j = 1, num do
					local flag_3

					flag_3 = j ~= 1 or not 0.5 or 1

					local flag_4

					flag_4 = not (length_2 <= num_3) or not 0 or flag_3 / length_2

					local var_13_19

					if flag_4 > 0 then
						var_13_19 = var_13_8 - arg_13_4 * flag_4 - arg_13_5 * (flag_4 * flag_4 * 0.5)
					else
						var_13_19 = arg_13_3
					end

					local immediate_raycast_2, var_13_21, var_13_22, var_13_23, var_13_24 = PhysicsWorld.immediate_raycast(arg_13_1, var_13_19, Vector3.down(), 10, "closest", "collision_filter", arg_13_6)

					if not immediate_raycast_2 then
						local mover_fits_at_2, var_13_26 = Unit.mover_fits_at(arg_13_2, "standing", var_13_21 + var_13_2, 1)

						if not mover_fits_at_2 then
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

		arg_13_4 = arg_13_4 + arg_13_5 * num_4
		var_13_1 = num_5
	end

	return false, var_13_1
end

WeaponHelper.ballistic_raycast = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8)
	-- function 14
	local num = arg_14_3 / arg_14_2

	for i = 1, arg_14_2 do
		local num_2 = arg_14_4 + arg_14_5 * num
		local num_3 = num_2 - arg_14_4
		local normalize = Vector3.normalize(num_3)
		local length = Vector3.length(num_3)
		local immediate_raycast, var_14_6, var_14_7, var_14_8, var_14_9 = PhysicsWorld.immediate_raycast(arg_14_1, arg_14_4, normalize, length, "closest", "collision_filter", arg_14_7)

		if not var_14_6 then
			return immediate_raycast, var_14_6, var_14_7, var_14_8, var_14_9
		end

		arg_14_5 = arg_14_5 + arg_14_6 * num
		arg_14_4 = num_2
	end

	return false, arg_14_4
end

WeaponHelper.look_at_enemy_or_static_position = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	-- function 15
	local immediate_raycast, var_15_1, var_15_2 = PhysicsWorld.immediate_raycast(arg_15_1, arg_15_2, arg_15_3, arg_15_6, "closest", "collision_filter", "filter_player_ray_projectile_static_only")
	local flag = var_15_2 or arg_15_6
	local num = arg_15_2 + arg_15_3 * flag / 2
	local num_2 = flag / 2

	PhysicsWorld.prepare_actors_for_overlap(arg_15_1, num, num_2 * num_2)

	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(arg_15_1, arg_15_2 + arg_15_3 * (arg_15_5 / 2), arg_15_2 + arg_15_3 * flag, arg_15_5, 100, "types", "both", "collision_filter", "filter_player_ray_projectile", "report_initial_overlap")
	local side = Managers.state.side
	local side_by_unit = side.side_by_unit
	local count

	if not linear_sphere_sweep then
		count = #linear_sphere_sweep

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_15_0::

	local var_15_10

	for i = 1, count do
		local var_15_11 = linear_sphere_sweep[i]
		local actor = var_15_11.actor

		if not actor then
			local unit = Actor.unit(actor)

			if not ScriptUnit.has_extension(unit, "health_system") then
				local var_15_14 = side_by_unit[unit]

				if not arg_15_4 and not var_15_14 and not side:is_enemy_by_side(arg_15_4, var_15_14) then
					local node = Actor.node(actor)
					local unit_breed = AiUtils.unit_breed(unit)
					local flag_2 = not unit_breed and unit_breed.hit_zones_lookup[node]

					if not (not flag_2 and flag_2.name == "afro") then
						var_15_10 = var_15_11.position

						break
					end
				end
			end
		end
	end

	return var_15_10 or var_15_1 or arg_15_2 + arg_15_3 * arg_15_6
end
