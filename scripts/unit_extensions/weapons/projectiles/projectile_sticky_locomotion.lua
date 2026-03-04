-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_sticky_locomotion.lua

require("scripts/helpers/network_utils")

ProjectileStickyLocomotion = class(ProjectileStickyLocomotion)

ProjectileStickyLocomotion.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.spawn_time = Managers.time:time("game")
	arg_1_0.time_lived = 0
	arg_1_0.stop_time = 0
	arg_1_0.stopped = arg_1_3.stopped
	arg_1_0.moved = false
	arg_1_0.extension_init_data = arg_1_3
	arg_1_0.is_husk = not not arg_1_3.is_husk
	arg_1_0.rotation_offset = arg_1_3.rotation_offset
	arg_1_0.speed = arg_1_3.speed
	arg_1_0.target_vector = arg_1_3.target_vector
	arg_1_0.target_unit = arg_1_3.target_unit

	arg_1_0:_init_from_seed(arg_1_3.seed)

	local var_1_0 = arg_1_3.initial_position

	arg_1_0._last_position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	arg_1_0.position_boxed = Vector3Box(POSITION_LOOKUP[arg_1_2])
	arg_1_0._rotation = QuaternionBox(Unit.world_rotation(arg_1_2, 0))
	arg_1_0.velocity = Vector3Box()
	arg_1_0.target_vector_boxed = Vector3Box(arg_1_0.target_vector)
	arg_1_0.initial_position_boxed = Vector3Box(var_1_0)
	arg_1_0._target_unit_id = NetworkConstants.invalid_game_object_id

	if arg_1_0.stopped then
		if ALIVE[arg_1_0.target_unit] then
			arg_1_0:stick_to_unit(arg_1_0.target_unit)
		else
			arg_1_0:stick_to_position(var_1_0)
		end
	end
end

ProjectileStickyLocomotion._init_from_seed = function (arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or 0
	arg_2_0._seed = arg_2_1
	arg_2_0._spin_dir = 1 - bit.band(arg_2_1, 128) / 64
	arg_2_1, arg_2_0._wobble_min = math.next_random_range(arg_2_1, 0, 0)
	arg_2_1, arg_2_0._wobble_max = math.next_random_range(arg_2_1, 0.3, 0.5)
	arg_2_1, arg_2_0._wobble_speed = math.next_random_range(arg_2_1, 3, 6)
	arg_2_1, arg_2_0._wobble_vertical_mult = math.next_random_range(arg_2_1, 0.7, 1)
	arg_2_1, arg_2_0._wobble_horizontal_mult = math.next_random_range(arg_2_1, 1, 1.2)
	arg_2_1, arg_2_0._wobble_stabiliztion_speed = math.next_random_range(arg_2_1, 0.5, 0.5)
end

ProjectileStickyLocomotion.destroy = function (arg_3_0)
	return
end

ProjectileStickyLocomotion.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0.moved = false

	local var_4_0 = arg_4_5 - arg_4_0.spawn_time

	arg_4_0.time_lived = var_4_0

	local var_4_1
	local var_4_2

	if arg_4_0.stopped and arg_4_0.stop_time then
		local var_4_3 = arg_4_5 - arg_4_0.stop_time
		local var_4_4 = arg_4_0.target_unit
		local var_4_5 = POSITION_LOOKUP[var_4_4]

		if var_4_5 then
			local var_4_6 = arg_4_0._hit_unit_radius * 12 / arg_4_0.speed
			local var_4_7 = arg_4_0._impact_offset:unbox()
			local var_4_8 = var_4_5 + Vector3(0, 0, arg_4_0._hit_unit_height)

			if var_4_3 < var_4_6 then
				local var_4_9 = arg_4_0.initial_position_boxed:unbox()
				local var_4_10 = var_4_8 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_4_0), var_4_7)
				local var_4_11 = var_4_8 + var_4_7
				local var_4_12 = var_4_10 + var_4_7
				local var_4_13 = var_4_3 / var_4_6

				var_4_1 = Bezier.calc_point(var_4_13, var_4_9, var_4_11, var_4_12, var_4_10)
			else
				var_4_1 = var_4_8 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_4_0), var_4_7)
			end
		else
			local var_4_14 = 0.5
			local var_4_15 = arg_4_0._impact_offset:unbox()
			local var_4_16 = Vector3.cross(var_4_15, Vector3.up())
			local var_4_17 = arg_4_0.initial_position_boxed:unbox()
			local var_4_18 = var_4_17 + Vector3.up() * (0.1 + math.sin(var_4_0) * 0.1) + var_4_15 * (math.sin(var_4_0 * 1.4) * 0.1) + var_4_16 * (math.sin(var_4_0 * 1.8) * 0.1)

			if var_4_3 < var_4_14 then
				local var_4_19 = math.easeOutCubic(var_4_3 / var_4_14)

				var_4_1 = Vector3.lerp(var_4_17, var_4_18, var_4_19)
				var_4_2 = Quaternion.lerp(Quaternion.look(arg_4_0.target_vector_boxed:unbox()), Quaternion.look(var_4_15), var_4_19)
			else
				var_4_1 = var_4_18
				var_4_2 = Quaternion.look(var_4_15)
			end
		end
	else
		local var_4_20 = arg_4_0.target_vector_boxed:unbox()
		local var_4_21 = var_4_20 * arg_4_0.speed * var_4_0
		local var_4_22 = arg_4_0.speed * 0.1
		local var_4_23 = math.easeCubic(math.clamp(var_4_0 * arg_4_0._wobble_stabiliztion_speed * var_4_22, 0, 1))
		local var_4_24 = math.clamp(var_4_23 * 250, 0, 1)
		local var_4_25 = math.lerp(arg_4_0._wobble_max, arg_4_0._wobble_min, var_4_23) * var_4_24
		local var_4_26 = var_4_25 * arg_4_0._wobble_vertical_mult
		local var_4_27 = var_4_25 * arg_4_0._wobble_horizontal_mult
		local var_4_28 = arg_4_0._wobble_speed * arg_4_0._spin_dir
		local var_4_29 = Vector3(math.sin(var_4_0 * var_4_28 - math.rad(115)) * var_4_27, 0, math.cos(var_4_0 * var_4_28 - math.rad(115)) * var_4_26)
		local var_4_30 = Quaternion.rotate(Quaternion.look(var_4_20), var_4_29)

		var_4_1 = arg_4_0.initial_position_boxed:unbox() + var_4_21 + var_4_30
	end

	if not NetworkUtils.network_safe_position(var_4_1) then
		arg_4_0:stop()

		if not arg_4_0.is_husk then
			Managers.state.unit_spawner:mark_for_deletion(arg_4_0.unit)
		end

		return
	end

	local var_4_31 = arg_4_0.position_boxed:unbox()
	local var_4_32 = var_4_1 - var_4_31

	if Vector3.length_squared(var_4_32) <= 1e-06 then
		return
	end

	var_4_2 = var_4_2 or Quaternion.look(var_4_32)

	Unit.set_local_position(arg_4_1, 0, var_4_1)
	Unit.set_local_rotation(arg_4_1, 0, var_4_2)
	arg_4_0._last_position:store(var_4_31)
	arg_4_0.position_boxed:store(var_4_1)
	arg_4_0.velocity:store(var_4_32)
	arg_4_0._rotation:store(var_4_2)

	arg_4_0.moved = true
end

ProjectileStickyLocomotion.moved_this_frame = function (arg_5_0)
	return arg_5_0.moved
end

ProjectileStickyLocomotion.current_velocity = function (arg_6_0)
	return arg_6_0.velocity:unbox()
end

ProjectileStickyLocomotion.current_position = function (arg_7_0)
	return arg_7_0.position_boxed:unbox()
end

ProjectileStickyLocomotion.current_rotation = function (arg_8_0)
	return arg_8_0._rotation:unbox()
end

ProjectileStickyLocomotion.last_position = function (arg_9_0)
	return arg_9_0._last_position:unbox()
end

ProjectileStickyLocomotion.stop = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0.is_husk then
		return
	end

	local var_10_0 = ScriptUnit.has_extension(arg_10_1, "ai_system")

	if var_10_0 then
		arg_10_0:stick_to_unit(arg_10_1)
	else
		arg_10_0:stick_to_position(arg_10_0:current_position(), arg_10_3)
	end

	local var_10_1 = Managers.state.network
	local var_10_2 = var_10_1:game()

	if var_10_2 then
		local var_10_3 = Managers.state.unit_storage
		local var_10_4 = var_10_3:go_id(arg_10_0.unit)
		local var_10_5 = arg_10_0.initial_position_boxed:unbox()
		local var_10_6 = var_10_0 and var_10_3:go_id(arg_10_1)

		if var_10_6 then
			GameSession.set_game_object_field(var_10_2, var_10_4, "target_unit", var_10_6)

			if arg_10_0.is_server then
				var_10_1.network_transmit:send_rpc_clients("rpc_projectile_stick_unit", var_10_4, var_10_6)
			else
				var_10_1.network_transmit:send_rpc_server("rpc_projectile_stick_unit", var_10_4, var_10_6)
			end
		elseif arg_10_0.is_server then
			var_10_1.network_transmit:send_rpc_clients("rpc_projectile_stick_position", var_10_4, var_10_5)
		else
			var_10_1.network_transmit:send_rpc_server("rpc_projectile_stick_position", var_10_4, var_10_5)
		end

		GameSession.set_game_object_field(var_10_2, var_10_4, "initial_position", var_10_5)
		GameSession.set_game_object_field(var_10_2, var_10_4, "stopped", true)
	end
end

ProjectileStickyLocomotion.stick_to_unit = function (arg_11_0, arg_11_1)
	arg_11_0.stopped = true
	arg_11_0.stop_time = Managers.time:time("game")

	arg_11_0.initial_position_boxed:store(arg_11_0:current_position())

	arg_11_0.target_unit = arg_11_1

	local var_11_0 = ScriptUnit.has_extension(arg_11_1, "ai_system")

	if var_11_0 then
		local var_11_1 = var_11_0._breed
		local var_11_2 = var_11_1.radius or 1

		arg_11_0._hit_unit_radius = var_11_2
		arg_11_0._hit_unit_height = var_11_1.aoe_height and var_11_1.aoe_height / 2 or 1
		arg_11_0._impact_offset = Vector3Box(Vector3.normalize(Vector3.flat(arg_11_0.target_vector_boxed:unbox()) * var_11_2))

		Unit.flow_event(arg_11_0.unit, "stopped")
	else
		arg_11_0:stick_to_position(arg_11_0:current_position())
	end
end

ProjectileStickyLocomotion.stick_to_position = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.stopped = true
	arg_12_0.stop_time = Managers.time:time("game")

	local var_12_0 = arg_12_1

	if arg_12_2 then
		var_12_0 = var_12_0 + arg_12_2 * 0.1
	end

	arg_12_0.position_boxed:store(var_12_0)
	arg_12_0.initial_position_boxed:store(var_12_0)

	arg_12_0.target_unit = nil
	arg_12_0._impact_offset = Vector3Box(Vector3.normalize(Vector3.flat(arg_12_0.target_vector_boxed:unbox())))

	Unit.flow_event(arg_12_0.unit, "stopped")
end

ProjectileStickyLocomotion.has_stopped = function (arg_13_0)
	return arg_13_0.stopped
end

ProjectileStickyLocomotion.hot_join_sync = function (arg_14_0, arg_14_1)
	local var_14_0 = PEER_ID_TO_CHANNEL[arg_14_1]

	if ALIVE[arg_14_0.unit] then
		local var_14_1 = Managers.state.unit_storage:go_id(arg_14_0.unit)
		local var_14_2 = Managers.time:time("game") - arg_14_0.stop_time

		RPC.rpc_hot_join_sync_projectile_sticky(var_14_0, var_14_1, arg_14_0.time_lived, var_14_2)
	end
end

ProjectileStickyLocomotion.hot_join_sync_projectile_sticky = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = Managers.time:time("game")

	arg_15_0.spawn_time = var_15_0 - arg_15_1
	arg_15_0.stop_time = var_15_0 - arg_15_2
	arg_15_0.time_lived = arg_15_1
end
