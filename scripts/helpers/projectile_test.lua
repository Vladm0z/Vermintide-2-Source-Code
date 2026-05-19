-- chunkname: @scripts/helpers/projectile_test.lua

ProjectileTest = ProjectileTest or {}

local var_0_0 = POSITION_LOOKUP
local var_0_1 = {}

function ProjectileTest.add_simulated_projectile(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0
	local var_1_1
	local var_1_2

	if arg_1_2 then
		local var_1_3, var_1_4 = WeaponHelper.angle_to_hit_moving_target(arg_1_0, arg_1_1, arg_1_2, arg_1_4, arg_1_5, 0.1)

		if var_1_3 then
			local var_1_5 = var_1_4 - arg_1_0
			local var_1_6 = Vector3.normalize(Vector3.flat(var_1_5))
			local var_1_7 = math.cos(var_1_3) * arg_1_2
			local var_1_8 = math.sin(var_1_3) * arg_1_2

			var_0_1[#var_0_1 + 1] = {
				type = "known_speed",
				last_dot = 0,
				t = 0,
				last_pos = Vector3Box(arg_1_0),
				p1 = Vector3Box(arg_1_0),
				p2 = Vector3Box(var_1_4),
				x_vel_0 = var_1_7,
				y_vel_0 = var_1_8,
				vec_flat = Vector3Box(var_1_6),
				gravity = arg_1_5
			}
		end
	elseif arg_1_3 then
		local var_1_9, var_1_10 = WeaponHelper.speed_to_hit_moving_target(arg_1_0, arg_1_1, arg_1_3, arg_1_4, arg_1_5, 0.1)

		if var_1_9 then
			local var_1_11 = var_1_10 - arg_1_0
			local var_1_12 = Vector3.normalize(Vector3.flat(var_1_11))
			local var_1_13 = math.cos(arg_1_3) * var_1_9
			local var_1_14 = math.sin(arg_1_3) * var_1_9

			var_0_1[#var_0_1 + 1] = {
				type = "known_angle",
				last_dot = 0,
				t = 0,
				last_pos = Vector3Box(arg_1_0),
				p1 = Vector3Box(arg_1_0),
				p2 = Vector3Box(var_1_10),
				x_vel_0 = var_1_13,
				y_vel_0 = var_1_14,
				vec_flat = Vector3Box(var_1_12),
				gravity = arg_1_5
			}
		end
	end
end

function ProjectileTest.simulate_projectiles(arg_2_0, arg_2_1)
	Debug.text("PROJECTILES:%d", #var_0_1)

	local var_2_0 = false

	for iter_2_0 = 1, #var_0_1 do
		local var_2_1 = var_0_1[iter_2_0]
		local var_2_2 = var_2_1.type == "known_angle" and Color(180, 180, 0) or Color(80, 180, 70)
		local var_2_3 = var_2_1.p2:unbox()
		local var_2_4 = var_2_1.last_pos:unbox()
		local var_2_5 = WeaponHelper.draw_ball_at_time(arg_2_0, var_2_1.p1:unbox(), var_2_1.vec_flat:unbox(), -var_2_1.gravity, var_2_1.x_vel_0, var_2_1.y_vel_0, var_2_1.t, var_2_2)
		local var_2_6 = Vector3.normalize(var_2_5 - var_2_4)
		local var_2_7 = Vector3.normalize(var_2_3 - var_2_5)
		local var_2_8 = Vector3.dot(var_2_6, var_2_7)

		QuickDrawer:line(var_2_5, var_2_3, var_2_2)

		if var_2_8 * var_2_1.last_dot < 0 or var_2_1.t > 10 then
			if Vector3.distance(var_2_5, var_2_3) > 1 then
				QuickDrawer:sphere(var_2_1.p2:unbox(), 0.24, var_2_2)
			else
				QuickDrawer:sphere(var_2_1.p2:unbox(), 0.2, Color(240, 40, 40))
			end

			var_2_1.destroy = true
			var_2_0 = true
		else
			QuickDrawer:sphere(var_2_1.p2:unbox(), 0.14, var_2_2)
		end

		var_2_1.last_pos:store(var_2_5)

		var_2_1.last_dot = var_2_8
		var_2_1.t = var_2_1.t + arg_2_1
	end

	if var_2_0 then
		for iter_2_1 = #var_0_1, 1, -1 do
			if var_0_1[iter_2_1].destroy then
				var_0_1[iter_2_1] = var_0_1[#var_0_1]
				var_0_1[#var_0_1] = nil
			end
		end
	end
end

local var_0_2 = 0

function ProjectileTest.run_projectile_test(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = 9.82
	local var_3_1 = World.get_data(arg_3_0, "physics_world")
	local var_3_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS[1]
	local var_3_3 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local var_3_4 = ScriptUnit.extension(var_3_3[1], "locomotion_system").velocity_current:unbox()
	local var_3_5 = Vector3(0, 0, 0)
	local var_3_6 = 30
	local var_3_7 = math.pi / 4
	local var_3_8 = 0.01

	QuickDrawer:sphere(var_3_5, 0.5, Color(200, 30, 30))
	ProjectileTest.simulate_projectiles(var_3_1, arg_3_2)

	if arg_3_1 > var_0_2 then
		if math.floor(var_0_2) % 2 == 0 then
			ProjectileTest.add_simulated_projectile(var_3_5, var_3_2, nil, var_3_7, var_3_4, var_3_0)
		else
			ProjectileTest.add_simulated_projectile(var_3_5, var_3_2, var_3_6, nil, var_3_4, var_3_0)
		end

		var_0_2 = arg_3_1 + 0.25
	end

	local var_3_9, var_3_10 = WeaponHelper.angle_to_hit_moving_target(var_3_5, var_3_2, var_3_6, var_3_4, var_3_0, var_3_8)

	if var_3_9 then
		QuickDrawer:sphere(var_3_10, 0.5, Color(80, 180, 70))
	end

	local var_3_11, var_3_12 = WeaponHelper.speed_to_hit_moving_target(var_3_5, var_3_2, var_3_7, var_3_4, var_3_0, var_3_8)

	if var_3_11 then
		QuickDrawer:sphere(var_3_12, 0.5, Color(180, 180, 0))
	end
end

function ProjectileTest.trajectory_test(arg_4_0, arg_4_1)
	for iter_4_0 = 20, 35 do
		local var_4_0 = Vector3(0, 0, 0)
		local var_4_1 = Vector3(iter_4_0, 0, 0) - var_4_0
		local var_4_2 = 9.82
		local var_4_3 = WeaponHelper.wanted_projectile_angle(nil, var_4_1, var_4_2, arg_4_0)
		local var_4_4 = math.radians_to_degrees(var_4_3)
		local var_4_5 = WeaponHelper.wanted_projectile_speed(nil, var_4_1, var_4_2, math.degrees_to_radians(arg_4_1))

		print(sprintf("Distance: %.1f  1) speed: %.1f and angle: %.1f OR speed: %.1f and angle: %.1f", iter_4_0, arg_4_0, var_4_4, var_4_5, arg_4_1))
	end
end

function ProjectileTest.draw_projectile_trajectory(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = 0.016666666666666666
	local var_5_1 = arg_5_1 - arg_5_0
	local var_5_2

	var_5_2 = arg_5_0.z > arg_5_1.z

	local var_5_3, var_5_4 = WeaponHelper:wanted_projectile_angle(var_5_1, arg_5_2, arg_5_3)
	local var_5_5 = var_5_3 or var_5_4

	QuickDrawer:sphere(arg_5_0, 0.05, Color(255, 0, 128, 0))
	QuickDrawer:sphere(arg_5_1, 0.05, Color(255, 0, 0, 128))

	if var_5_5 then
		local var_5_6 = Vector3.normalize(Vector3.flat(var_5_1))
		local var_5_7 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_5_6, Vector3.up()), var_5_5), var_5_6) * arg_5_3
		local var_5_8 = arg_5_0 + Vector3(0, 0, 0.5)
		local var_5_9 = arg_5_0 + Vector3(0, 0, 0.15)
		local var_5_10 = GameSettingsDevelopment.debug_unit_colors
		local var_5_11 = 1
		local var_5_12 = var_5_7 * var_5_0

		while var_5_11 < 1000 do
			var_5_12 = var_5_12 - Vector3(0, 0, arg_5_2 * var_5_0 * var_5_0)
			var_5_9 = var_5_9 + var_5_12

			local var_5_13 = var_5_10[(var_5_11 - 1) % #var_5_10 + 1]

			QuickDrawer:line(var_5_8, var_5_9, Color(255, var_5_13[1], var_5_13[2], var_5_13[3]))

			local var_5_14 = var_5_9 - var_5_8
			local var_5_15 = arg_5_1 - var_5_9

			if Vector3.dot(var_5_14, var_5_15) < -0.9 then
				break
			end

			var_5_8 = var_5_9
			var_5_11 = var_5_11 + 1
		end
	end
end
