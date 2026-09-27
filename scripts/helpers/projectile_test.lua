-- chunkname: @scripts/helpers/projectile_test.lua

local ProjectileTest = ProjectileTest

ProjectileTest = ProjectileTest or {}
ProjectileTest = ProjectileTest

local POSITION_LOOKUP = POSITION_LOOKUP
local tbl = {}

ProjectileTest.add_simulated_projectile = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local var_1_0
	local var_1_1
	local var_1_2

	if not arg_1_2 then
		local angle_to_hit_moving_target, var_1_4 = WeaponHelper.angle_to_hit_moving_target(arg_1_0, arg_1_1, arg_1_2, arg_1_4, arg_1_5, 0.1)

		if not angle_to_hit_moving_target then
			local num = var_1_4 - arg_1_0
			local normalize = Vector3.normalize(Vector3.flat(num))
			local num_2 = math.cos(angle_to_hit_moving_target) * arg_1_2
			local num_3 = math.sin(angle_to_hit_moving_target) * arg_1_2

			tbl[#tbl + 1] = {
				type = "known_speed",
				last_dot = 0,
				t = 0,
				last_pos = Vector3Box(arg_1_0),
				p1 = Vector3Box(arg_1_0),
				p2 = Vector3Box(var_1_4),
				x_vel_0 = num_2,
				y_vel_0 = num_3,
				vec_flat = Vector3Box(normalize),
				gravity = arg_1_5
			}
		end
	elseif not arg_1_3 then
		local speed_to_hit_moving_target, var_1_10 = WeaponHelper.speed_to_hit_moving_target(arg_1_0, arg_1_1, arg_1_3, arg_1_4, arg_1_5, 0.1)

		if not speed_to_hit_moving_target then
			local num_4 = var_1_10 - arg_1_0
			local normalize_2 = Vector3.normalize(Vector3.flat(num_4))
			local num_5 = math.cos(arg_1_3) * speed_to_hit_moving_target
			local num_6 = math.sin(arg_1_3) * speed_to_hit_moving_target

			tbl[#tbl + 1] = {
				type = "known_angle",
				last_dot = 0,
				t = 0,
				last_pos = Vector3Box(arg_1_0),
				p1 = Vector3Box(arg_1_0),
				p2 = Vector3Box(var_1_10),
				x_vel_0 = num_5,
				y_vel_0 = num_6,
				vec_flat = Vector3Box(normalize_2),
				gravity = arg_1_5
			}
		end
	end
end

ProjectileTest.simulate_projectiles = function (arg_2_0, arg_2_1)
	-- function 2
	Debug.text("PROJECTILES:%d", #tbl)

	local flag = false

	for i = 1, #tbl do
		local var_2_1 = tbl[i]
		local var_2_2

		if var_2_1.type == "known_angle" then
			var_2_2 = Color(180, 180, 0)

			if not var_2_2 then
				-- Nothing
			end
		end

		var_2_2 = Color(80, 180, 70)

		::label_2_0::

		local unbox = var_2_1.p2:unbox()
		local unbox_2 = var_2_1.last_pos:unbox()
		local draw_ball_at_time = WeaponHelper.draw_ball_at_time(arg_2_0, var_2_1.p1:unbox(), var_2_1.vec_flat:unbox(), -var_2_1.gravity, var_2_1.x_vel_0, var_2_1.y_vel_0, var_2_1.t, var_2_2)
		local normalize = Vector3.normalize(draw_ball_at_time - unbox_2)
		local normalize_2 = Vector3.normalize(unbox - draw_ball_at_time)
		local dot = Vector3.dot(normalize, normalize_2)

		QuickDrawer:line(draw_ball_at_time, unbox, var_2_2)

		if not (dot * var_2_1.last_dot < 0 or not (var_2_1.t > 10)) then
			if Vector3.distance(draw_ball_at_time, unbox) > 1 then
				QuickDrawer:sphere(var_2_1.p2:unbox(), 0.24, var_2_2)
			else
				QuickDrawer:sphere(var_2_1.p2:unbox(), 0.2, Color(240, 40, 40))
			end

			var_2_1.destroy = true
			flag = true
		else
			QuickDrawer:sphere(var_2_1.p2:unbox(), 0.14, var_2_2)
		end

		var_2_1.last_pos:store(draw_ball_at_time)

		var_2_1.last_dot = dot
		var_2_1.t = var_2_1.t + arg_2_1
	end

	if not flag then
		for j = #tbl, 1, -1 do
			if not tbl[j].destroy then
				tbl[j] = tbl[#tbl]
				tbl[#tbl] = nil
			end
		end
	end
end

local num = 0

ProjectileTest.run_projectile_test = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local num_2 = 9.82
	local get_data = World.get_data(arg_3_0, "physics_world")
	local var_3_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS[1]
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local unbox = ScriptUnit.extension(PLAYER_UNITS[1], "locomotion_system").velocity_current:unbox()
	local var_3_5 = Vector3(0, 0, 0)
	local num_3 = 30
	local num_4 = math.pi / 4
	local num_5 = 0.01

	QuickDrawer:sphere(var_3_5, 0.5, Color(200, 30, 30))
	ProjectileTest.simulate_projectiles(get_data, arg_3_2)

	if arg_3_1 > num then
		if not (math.floor(num) % 2 == 0) then
			ProjectileTest.add_simulated_projectile(var_3_5, var_3_2, nil, num_4, unbox, num_2)
		else
			ProjectileTest.add_simulated_projectile(var_3_5, var_3_2, num_3, nil, unbox, num_2)
		end

		num = arg_3_1 + 0.25
	end

	local angle_to_hit_moving_target, var_3_10 = WeaponHelper.angle_to_hit_moving_target(var_3_5, var_3_2, num_3, unbox, num_2, num_5)

	if not angle_to_hit_moving_target then
		QuickDrawer:sphere(var_3_10, 0.5, Color(80, 180, 70))
	end

	local speed_to_hit_moving_target, var_3_12 = WeaponHelper.speed_to_hit_moving_target(var_3_5, var_3_2, num_4, unbox, num_2, num_5)

	if not speed_to_hit_moving_target then
		QuickDrawer:sphere(var_3_12, 0.5, Color(180, 180, 0))
	end
end

ProjectileTest.trajectory_test = function (arg_4_0, arg_4_1)
	-- function 4
	for i = 20, 35 do
		local var_4_0 = Vector3(0, 0, 0)
		local num = Vector3(i, 0, 0) - var_4_0
		local num_2 = 9.82
		local wanted_projectile_angle = WeaponHelper.wanted_projectile_angle(nil, num, num_2, arg_4_0)
		local radians_to_degrees = math.radians_to_degrees(wanted_projectile_angle)
		local wanted_projectile_speed = WeaponHelper.wanted_projectile_speed(nil, num, num_2, math.degrees_to_radians(arg_4_1))

		print(sprintf("Distance: %.1f  1) speed: %.1f and angle: %.1f OR speed: %.1f and angle: %.1f", i, arg_4_0, radians_to_degrees, wanted_projectile_speed, arg_4_1))
	end
end

ProjectileTest.draw_projectile_trajectory = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local num = 0.016666666666666666
	local num_2 = arg_5_1 - self
	local flag

	flag = self.z > arg_5_1.z

	local wanted_projectile_angle, var_5_4 = WeaponHelper:wanted_projectile_angle(num_2, arg_5_2, arg_5_3)
	local flag_2 = wanted_projectile_angle or var_5_4

	QuickDrawer:sphere(self, 0.05, Color(255, 0, 128, 0))
	QuickDrawer:sphere(arg_5_1, 0.05, Color(255, 0, 0, 128))

	if not flag_2 then
		local normalize = Vector3.normalize(Vector3.flat(num_2))
		local num_3 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(normalize, Vector3.up()), flag_2), normalize) * arg_5_3
		local num_4 = self + Vector3(0, 0, 0.5)
		local num_5 = self + Vector3(0, 0, 0.15)
		local debug_unit_colors = GameSettingsDevelopment.debug_unit_colors
		local num_6 = 1
		local num_7 = num_3 * num

		while num_6 < 1000 do
			num_7 = num_7 - Vector3(0, 0, arg_5_2 * num * num)
			num_5 = num_5 + num_7

			local var_5_13 = debug_unit_colors[(num_6 - 1) % #debug_unit_colors + 1]

			QuickDrawer:line(num_4, num_5, Color(255, var_5_13[1], var_5_13[2], var_5_13[3]))

			local num_8 = num_5 - num_4
			local num_9 = arg_5_1 - num_5

			if Vector3.dot(num_8, num_9) < -0.9 then
				break
			end

			num_4 = num_5
			num_6 = num_6 + 1
		end
	end
end
