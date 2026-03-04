-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_true_flight_locomotion_extension.lua

require("scripts/unit_extensions/weapons/projectiles/true_flight_utility")

ProjectileTrueFlightLocomotionExtension = class(ProjectileTrueFlightLocomotionExtension)

function ProjectileTrueFlightLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = arg_1_3.gravity_settings or "default"
	local var_1_2 = arg_1_3.initial_position
	local var_1_3 = arg_1_3.true_flight_template_name

	assert(var_1_3, "no true_flight_template")

	arg_1_0.true_flight_template_name = var_1_3

	local var_1_4 = TrueFlightTemplates[var_1_3]

	arg_1_0.true_flight_template = var_1_4

	local var_1_5 = Managers.time:time("game")

	arg_1_0.t = var_1_5 - (arg_1_3.fast_forward_time or 0)
	arg_1_0.target_unit = arg_1_3.target_unit
	arg_1_0.target_node = var_1_4.initial_target_node or "c_head"
	arg_1_0.unit = arg_1_2
	arg_1_0.world = var_1_0
	arg_1_0.gravity_settings = var_1_1
	arg_1_0.gravity = ProjectileGravitySettings[var_1_1]
	arg_1_0.velocity = Vector3Box()
	arg_1_0.speed = arg_1_3.speed
	arg_1_0.initial_position_boxed = Vector3Box(var_1_2)

	local var_1_6 = Managers.state.side.side_by_unit

	arg_1_0.side = var_1_6[arg_1_2] or var_1_6[arg_1_3.owner_unit]
	arg_1_0.target_broadphase_categories = var_1_4.dont_target_friendly and arg_1_0.side and arg_1_0.side.enemy_broadphase_categories or nil
	arg_1_0.trajectory_template_name = arg_1_3.trajectory_template_name

	assert(arg_1_0.trajectory_template_name)

	arg_1_0.raycast_timer = 0
	arg_1_0.target_vector = arg_1_3.target_vector
	arg_1_0.current_direction = Vector3Box(arg_1_0.target_vector)
	arg_1_0.current_rotation = QuaternionBox(Quaternion.look(arg_1_0.target_vector))
	arg_1_0.target_vector = Vector3.normalize(Vector3.flat(arg_1_0.target_vector))
	arg_1_0.target_vector_boxed = Vector3Box(arg_1_0.target_vector)
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.is_husk = not not arg_1_3.is_husk
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.radians = math.degrees_to_radians(arg_1_3.angle)
	arg_1_0.stopped = false
	arg_1_0.moved = false
	arg_1_0.spawn_time = var_1_5
	arg_1_0.death_time = arg_1_3.life_time or math.huge
	arg_1_0.on_target_time = 0
	arg_1_0.height_offset = arg_1_3.height_offset or 0

	if var_1_4.target_tracking_check_func then
		arg_1_0._update_towards_target_func = arg_1_0[var_1_4.target_tracking_check_func]
	else
		arg_1_0._update_towards_target_func = arg_1_0.update_towards_target
	end

	arg_1_0._legitimate_target_func = var_1_4.legitimate_target_func and arg_1_0[var_1_4.legitimate_target_func] or arg_1_0.legitimate_target
	arg_1_0._keep_target_on_miss_check_func = var_1_4.keep_target_on_miss_check_func and arg_1_0[var_1_4.keep_target_on_miss_check_func] or arg_1_0.legitimate_never
	arg_1_0._valid_target_dot = var_1_4.valid_target_dot or 0.75
	arg_1_0._retarget_broadphase_offset = var_1_4.retarget_broadphase_offset or 10
	arg_1_0._dont_target_patrols = var_1_4.dont_target_patrols
	arg_1_0._lerp_modifier_func = var_1_4.lerp_modifier_func or function(arg_2_0)
		return arg_2_0 < 5 and 1 or 5 / arg_2_0
	end
	arg_1_0.target_players = var_1_4.target_players

	if var_1_4.find_target_func then
		arg_1_0._find_target_func = arg_1_0[var_1_4.find_target_func]
	else
		arg_1_0._find_target_func = arg_1_0.find_broadphase_target
	end

	if arg_1_3.position_target then
		arg_1_0.position_target = Vector3Box(arg_1_3.position_target)
	end

	if var_1_4.init_func then
		local var_1_7 = math.random_seed()

		arg_1_0._custom_data = {}

		var_1_4.init_func(arg_1_2, var_1_4, var_1_7, arg_1_0._custom_data)
	end

	arg_1_0._current_position = Vector3Box(POSITION_LOOKUP[arg_1_2])

	Unit.set_local_position(arg_1_2, 0, var_1_2)

	arg_1_0.hit_units = {}
end

local function var_0_0(arg_3_0, arg_3_1)
	local var_3_0 = BLACKBOARDS[arg_3_0]
	local var_3_1 = var_3_0 and var_3_0.breed
	local var_3_2 = Unit.has_node(arg_3_0, arg_3_1) and Unit.node(arg_3_0, arg_3_1) or 0

	if var_3_1 and var_3_1.target_head_node then
		return Unit.world_position(arg_3_0, var_3_2)
	else
		return Unit.world_position(arg_3_0, var_3_2)
	end
end

local function var_0_1(arg_4_0)
	local var_4_0 = NetworkConstants.position.min
	local var_4_1 = NetworkConstants.position.max

	for iter_4_0 = 1, 3 do
		local var_4_2 = arg_4_0[iter_4_0]

		if var_4_2 < var_4_0 or var_4_1 < var_4_2 then
			print("[ProjectileTrueFlightLocomotionExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

function ProjectileTrueFlightLocomotionExtension._do_forced_impact(arg_5_0, arg_5_1, arg_5_2)
	ScriptUnit.extension(arg_5_1, "projectile_system"):force_impact(arg_5_1, Unit.local_position(arg_5_1, 0))

	local var_5_0 = arg_5_0.network_manager
	local var_5_1 = var_5_0:unit_game_object_id(arg_5_1)

	var_5_0.network_transmit:send_rpc_clients("rpc_generic_impact_projectile_force_impact", var_5_1, arg_5_2)
end

function ProjectileTrueFlightLocomotionExtension.bounce(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Vector3.normalize(Vector3.reflect(arg_6_2, arg_6_3))
	local var_6_1 = arg_6_1 - arg_6_2 * 0.25 + arg_6_3 * 0.1
	local var_6_2 = Quaternion.look(var_6_0)

	arg_6_0.t = Managers.time:time("game")

	arg_6_0.target_vector_boxed:store(var_6_0)
	arg_6_0.initial_position_boxed:store(var_6_1)

	arg_6_0.radians = math.degrees_to_radians(ActionUtils.pitch_from_rotation(var_6_2))

	arg_6_0._current_position:store(var_6_1)
	arg_6_0:_unit_set_position_rotation(arg_6_0.unit, var_6_1, var_6_2)
end

function ProjectileTrueFlightLocomotionExtension.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_0.dt = arg_7_5 - arg_7_0.t
	arg_7_0.t = arg_7_5
	arg_7_0.moved = false

	if arg_7_0.stopped then
		return
	end

	if arg_7_0.is_husk then
		local var_7_0 = Managers.state.network:game()
		local var_7_1 = Managers.state.unit_storage:go_id(arg_7_1)

		if var_7_0 and var_7_1 then
			local var_7_2 = GameSession.game_object_field(var_7_0, var_7_1, "position")
			local var_7_3 = GameSession.game_object_field(var_7_0, var_7_1, "rotation")

			arg_7_0:_unit_set_position_rotation(arg_7_1, var_7_2, var_7_3)
		end

		return
	end

	arg_7_0.on_target_time = arg_7_0.on_target_time + arg_7_3

	local var_7_4 = arg_7_0._current_position:unbox()

	if arg_7_0.on_target_time > arg_7_0.death_time then
		arg_7_0:_do_forced_impact(arg_7_1, var_7_4)
	end

	local var_7_5 = TrueFlightTemplates[arg_7_0.true_flight_template_name]
	local var_7_6 = arg_7_0.target_unit
	local var_7_7, var_7_8 = arg_7_0:_check_target_valid(var_7_6, var_7_4, var_7_5)
	local var_7_9

	if not var_7_7 then
		local var_7_10 = (var_7_5.max_on_target_time or 0.75) > arg_7_0.on_target_time
		local var_7_11, var_7_12 = arg_7_0:update_seeking_target(var_7_4, arg_7_3, arg_7_5, var_7_10)

		var_7_9 = var_7_11
		arg_7_0.target_unit = var_7_12
		var_7_7, var_7_8 = arg_7_0:_check_target_valid(var_7_12, var_7_4, var_7_5)
	end

	local var_7_13

	if var_7_8 then
		var_7_9, var_7_13 = arg_7_0._update_towards_target_func(arg_7_0, var_7_4, arg_7_5, arg_7_3)
	elseif var_7_7 then
		local var_7_14, var_7_15 = arg_7_0:update_seeking_target(var_7_4, arg_7_3, arg_7_5, false)

		var_7_9 = var_7_14
	end

	if not var_0_1(var_7_9) then
		arg_7_0:stop()
		Managers.state.unit_spawner:mark_for_deletion(arg_7_0.unit)

		return
	end

	local var_7_16 = var_7_9 - var_7_4

	if Vector3.length(var_7_16) <= 0.001 then
		return
	end

	if script_data.debug_projectiles then
		QuickDrawerStay:line(var_7_4, var_7_9, Color(255, 255, 255, 0))
	end

	local var_7_17 = Vector3.normalize(var_7_16)
	local var_7_18 = var_7_13 or Quaternion.look(var_7_17)

	arg_7_0:_unit_set_position_rotation(arg_7_1, var_7_9, var_7_18)

	local var_7_19 = Managers.state.network:game()
	local var_7_20 = Managers.state.unit_storage:go_id(arg_7_1)

	if var_7_19 and var_7_20 then
		GameSession.set_game_object_field(var_7_19, var_7_20, "position", var_7_9)
		GameSession.set_game_object_field(var_7_19, var_7_20, "rotation", var_7_18)
	end

	arg_7_0._current_position:store(var_7_9)
	arg_7_0.velocity:store(var_7_16)
	arg_7_0.current_direction:store(var_7_17)
	arg_7_0.current_rotation:store(var_7_18)

	arg_7_0.t = arg_7_5

	arg_7_0.target_vector_boxed:store(Vector3.normalize(Vector3.flat(var_7_17)))
	arg_7_0.initial_position_boxed:store(var_7_9)

	arg_7_0.radians = math.degrees_to_radians(ActionUtils.pitch_from_rotation(var_7_18))
	arg_7_0.moved = true
end

function ProjectileTrueFlightLocomotionExtension._check_target_valid(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = false
	local var_8_1 = false

	if arg_8_0.position_target then
		var_8_0 = true
	elseif HEALTH_ALIVE[arg_8_1] and not arg_8_0.hit_units[arg_8_1] then
		if arg_8_0._dont_target_patrols and AiUtils.is_part_of_patrol(arg_8_1) and not AiUtils.is_aggroed(arg_8_1) then
			return var_8_1, var_8_0
		end

		var_8_1 = true

		if arg_8_0._legitimate_target_func(arg_8_0, arg_8_1, arg_8_2) then
			var_8_0 = true
		elseif arg_8_3.retarget_on_miss then
			var_8_1 = arg_8_0._keep_target_on_miss_check_func(arg_8_0, arg_8_1, arg_8_2)
		end
	end

	return var_8_1, var_8_0
end

function ProjectileTrueFlightLocomotionExtension.set_projectile_state(arg_9_0, arg_9_1)
	if arg_9_1 ~= arg_9_0.projectile_state_id then
		local var_9_0 = not arg_9_0.is_husk
		local var_9_1 = arg_9_0.unit

		TrueFlightTemplates[arg_9_0.true_flight_template_name].template_state_func(arg_9_0, var_9_1, arg_9_1, var_9_0)

		if var_9_0 then
			local var_9_2 = arg_9_0.network_manager
			local var_9_3 = var_9_2:unit_game_object_id(var_9_1)

			var_9_2.network_transmit:send_rpc_clients("rpc_set_projectile_state", var_9_3, arg_9_1)
		end

		arg_9_0.projectile_state_id = arg_9_1
	else
		print("WARNING: projectile trying to be put in the same state multiple times", arg_9_0.unit, arg_9_1)
	end
end

function ProjectileTrueFlightLocomotionExtension.update_towards_slow_bomb_target(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0.target_unit
	local var_10_1 = arg_10_0.unit
	local var_10_2 = arg_10_0.current_direction:unbox()
	local var_10_3 = TrueFlightTemplates[arg_10_0.true_flight_template_name]
	local var_10_4 = var_10_3.speed_multiplier
	local var_10_5 = Unit.world_position(var_10_0, Unit.node(var_10_0, "c_spine")) - arg_10_1
	local var_10_6 = Vector3.length(var_10_5)
	local var_10_7 = Vector3.normalize(var_10_5)
	local var_10_8 = Quaternion.look(var_10_2)
	local var_10_9 = Quaternion.look(var_10_7)

	if arg_10_0._slow_bomb_triggered then
		local var_10_10 = var_10_3.triggered_speed_mult

		return arg_10_1 + var_10_2 * arg_10_0.speed * var_10_4 * var_10_10 * arg_10_3
	elseif var_10_6 < var_10_3.trigger_dist then
		arg_10_0._slow_bomb_triggered = true

		Unit.flow_event(var_10_1, "lua_projectile_triggered")

		local var_10_11 = arg_10_0.network_manager
		local var_10_12 = var_10_11:unit_game_object_id(var_10_1)

		var_10_11.network_transmit:send_rpc_clients("rpc_set_projectile_state", var_10_12, 1)
	end

	local var_10_13 = math.clamp(var_10_6 < 10 and 1 or var_10_6 / 10, 0, 3)
	local var_10_14 = arg_10_0.speed * var_10_4 * var_10_13
	local var_10_15 = arg_10_0._lerp_modifier_func(var_10_6)
	local var_10_16 = var_10_15 * var_10_15 * (math.min(arg_10_0.on_target_time, 0.25) / 0.25)
	local var_10_17 = math.min(arg_10_3 * var_10_16 * 100, 0.75)
	local var_10_18 = Quaternion.lerp(var_10_8, var_10_9, var_10_17)

	return arg_10_1 + Quaternion.forward(var_10_18) * var_10_14 * arg_10_3
end

function ProjectileTrueFlightLocomotionExtension.update_towards_strike_missile_target(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0.target_unit
	local var_11_1 = arg_11_0.current_direction:unbox()
	local var_11_2 = TrueFlightTemplates[arg_11_0.true_flight_template_name]
	local var_11_3 = var_11_2.speed_multiplier
	local var_11_4 = Unit.world_position(var_11_0, Unit.node(var_11_0, "c_spine")) - arg_11_1
	local var_11_5 = Vector3.length(var_11_4)
	local var_11_6 = Vector3.normalize(var_11_4)
	local var_11_7 = arg_11_0.unit

	if arg_11_0._missile_triggered then
		if arg_11_0._missile_striking then
			local var_11_8 = var_11_2.triggered_speed_mult

			return arg_11_1 + var_11_1 * arg_11_0.speed * var_11_3 * var_11_8 * arg_11_3
		else
			if arg_11_2 > arg_11_0._missile_lingering then
				arg_11_0._missile_striking = true

				if var_11_2.create_bot_threat then
					local var_11_9 = HEALTH_ALIVE[arg_11_0.owner_unit] and BLACKBOARDS[arg_11_0.owner_unit]

					if var_11_9 and not var_11_9.created_missile_bot_threat then
						var_11_9.missile_bot_threat_unit = var_11_0
						var_11_9.created_missile_bot_threat = true
					end
				end

				Unit.flow_event(var_11_7, "lua_projectile_striking")

				local var_11_10 = arg_11_0.network_manager
				local var_11_11 = var_11_10:unit_game_object_id(var_11_7)

				var_11_10.network_transmit:send_rpc_clients("rpc_set_projectile_state", var_11_11, 2)
			end

			local var_11_12 = 0.1

			return arg_11_1 + var_11_1 * arg_11_0.speed * var_11_3 * var_11_12 * arg_11_3
		end
	elseif Vector3.dot(var_11_1, var_11_6) > 0.999 or arg_11_0.on_target_time > 2 then
		arg_11_0._missile_triggered = true
		arg_11_0._missile_lingering = arg_11_2 + var_11_2.lingering_duration

		Unit.flow_event(var_11_7, "lua_projectile_triggered")

		local var_11_13 = arg_11_0.network_manager
		local var_11_14 = var_11_13:unit_game_object_id(var_11_7)

		var_11_13.network_transmit:send_rpc_clients("rpc_set_projectile_state", var_11_14, 1)
	end

	local var_11_15 = Quaternion.look(var_11_1)
	local var_11_16 = Quaternion.look(var_11_6)

	arg_11_0.speed = arg_11_0.speed - 5 * arg_11_3

	local var_11_17 = arg_11_0.speed * var_11_3
	local var_11_18 = arg_11_0._lerp_modifier_func(var_11_5)
	local var_11_19 = var_11_18 * var_11_18 * (math.min(arg_11_0.on_target_time, 0.5) / 0.5)
	local var_11_20 = math.min(arg_11_3 * var_11_19 * 100, 0.75)
	local var_11_21 = Quaternion.lerp(var_11_15, var_11_16, var_11_20)

	return arg_11_1 + Quaternion.forward(var_11_21) * var_11_17 * arg_11_3
end

function ProjectileTrueFlightLocomotionExtension.update_towards_position_target(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.current_direction:unbox()
	local var_12_1 = TrueFlightTemplates[arg_12_0.true_flight_template_name].speed_multiplier
	local var_12_2 = arg_12_0.position_target:unbox()
	local var_12_3 = var_12_2 - arg_12_1
	local var_12_4 = Vector3.length(var_12_3)
	local var_12_5 = Vector3.normalize(var_12_3)
	local var_12_6 = Quaternion.look(var_12_0)
	local var_12_7 = Quaternion.look(var_12_5)
	local var_12_8 = arg_12_0.height_offset + math.max(arg_12_1.z - var_12_2.z, 0)
	local var_12_9 = arg_12_0._lerp_modifier_func(var_12_4, var_12_8, arg_12_2)
	local var_12_10 = var_12_9 * var_12_9 * (math.min(arg_12_0.on_target_time, 0.25) / 0.25)
	local var_12_11 = math.min(arg_12_3 * var_12_10 * 100, 0.75)
	local var_12_12 = Quaternion.lerp(var_12_6, var_12_7, var_12_11)

	return arg_12_1 + Quaternion.forward(var_12_12) * (arg_12_0.speed * var_12_1) * arg_12_3
end

function ProjectileTrueFlightLocomotionExtension.update_towards_target(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.target_unit
	local var_13_1 = arg_13_0.current_direction:unbox()
	local var_13_2 = TrueFlightTemplates[arg_13_0.true_flight_template_name]
	local var_13_3 = var_13_2.speed_multiplier
	local var_13_4 = var_0_0(var_13_0, arg_13_0.target_node)
	local var_13_5 = var_13_4 - arg_13_1
	local var_13_6 = Vector3.length(var_13_5)
	local var_13_7 = arg_13_0.speed * var_13_3

	if var_13_6 < var_13_7 * arg_13_3 then
		return var_13_4
	end

	local var_13_8 = Vector3.normalize(var_13_5)
	local var_13_9 = Quaternion.look(var_13_1)
	local var_13_10 = Quaternion.look(var_13_8)
	local var_13_11 = arg_13_0.height_offset + math.max(arg_13_1.z - var_13_4.z, 0)
	local var_13_12 = arg_13_0._lerp_modifier_func(var_13_6, var_13_11, arg_13_2)
	local var_13_13 = var_13_12 * var_13_12 * (math.min(arg_13_0.on_target_time, 0.25) / 0.25)
	local var_13_14 = math.min(arg_13_3 * var_13_13 * 100, 0.75)
	local var_13_15 = Quaternion.lerp(var_13_9, var_13_10, var_13_14)
	local var_13_16 = arg_13_1 + Quaternion.forward(var_13_15) * var_13_7 * arg_13_3
	local var_13_17 = var_13_2.create_bot_threat

	if arg_13_0.target_players and var_13_17 then
		arg_13_0:update_bot_threat(var_13_0, var_13_6)
	end

	return var_13_16
end

function ProjectileTrueFlightLocomotionExtension.update_seeking_target(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = TrueFlightTemplates[arg_14_0.true_flight_template_name]
	local var_14_1 = var_14_0.speed_multiplier
	local var_14_2 = arg_14_0.dt
	local var_14_3 = arg_14_0.speed * var_14_1
	local var_14_4 = arg_14_0.radians
	local var_14_5 = arg_14_0.gravity
	local var_14_6 = Vector3Box.unbox(arg_14_0.target_vector_boxed)
	local var_14_7 = Vector3Box.unbox(arg_14_0.initial_position_boxed)
	local var_14_8 = arg_14_0.trajectory_template_name
	local var_14_9 = arg_14_0.is_husk
	local var_14_10 = ProjectileTemplates.get_trajectory_template(var_14_8, var_14_9).update(var_14_3, var_14_4, var_14_5, var_14_7, var_14_6, var_14_2)
	local var_14_11 = arg_14_4 and arg_14_0:find_new_target(arg_14_1, var_14_0, arg_14_3, var_14_2)

	return var_14_10, var_14_11
end

function ProjectileTrueFlightLocomotionExtension.find_new_target(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if arg_15_3 > arg_15_0.raycast_timer then
		arg_15_0.raycast_timer = arg_15_3 + arg_15_2.time_between_raycasts

		return (arg_15_0._find_target_func(arg_15_0, arg_15_1, arg_15_2))
	end
end

function ProjectileTrueFlightLocomotionExtension.find_player_target(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	local var_16_1 = arg_16_0.side

	if var_16_1 then
		var_16_0 = var_16_1.ENEMY_PLAYER_UNITS
	else
		var_16_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	end

	local var_16_2 = #var_16_0

	if var_16_2 > 0 then
		local var_16_3 = Math.random(1, var_16_2)

		for iter_16_0 = var_16_3, var_16_3 + var_16_2 do
			local var_16_4 = var_16_0[(iter_16_0 - 1) % var_16_2 + 1]

			if HEALTH_ALIVE[var_16_4] and not arg_16_0.hit_units[var_16_4] and arg_16_0:_check_target_valid(var_16_4, arg_16_1, arg_16_2) then
				return var_16_4
			end
		end
	end
end

local var_0_2 = {}

function ProjectileTrueFlightLocomotionExtension.find_broadphase_target(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = TrueFlightTemplates[arg_17_0.true_flight_template_name].broadphase_radius
	local var_17_1 = arg_17_0.target_broadphase_categories

	table.clear(var_0_2)

	local var_17_2

	if arg_17_0.target_position then
		var_17_2 = AiUtils.broadphase_query(arg_17_0.target_position:unbox(), var_17_0, var_0_2, var_17_1)
	else
		local var_17_3 = arg_17_0.current_direction:unbox()

		var_17_2 = AiUtils.broadphase_query(arg_17_1 + var_17_3 * arg_17_0._retarget_broadphase_offset, var_17_0, var_0_2, var_17_1)

		if var_17_2 <= 0 then
			var_17_2 = AiUtils.broadphase_query(arg_17_1 + var_17_3 * 2 * arg_17_0._retarget_broadphase_offset, var_17_0 * 2, var_0_2, var_17_1)
		end
	end

	if var_17_2 > 0 then
		table.shuffle(var_0_2)

		for iter_17_0 = 1, var_17_2 do
			local var_17_4 = var_0_2[iter_17_0]

			if ScriptUnit.has_extension(var_17_4, "health_system") and HEALTH_ALIVE[var_17_4] and not arg_17_0.hit_units[var_17_4] and arg_17_0:_check_target_valid(var_17_4, arg_17_1, arg_17_2) then
				return var_17_4
			end
		end
	end

	return nil
end

function ProjectileTrueFlightLocomotionExtension.find_closest_highest_value_target(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = TrueFlightTemplates[arg_18_0.true_flight_template_name]
	local var_18_1 = var_18_0.broadphase_radius
	local var_18_2 = arg_18_0.target_broadphase_categories
	local var_18_3 = var_18_0.forward_search_distance_to_find_target

	table.clear(var_0_2)

	local var_18_4

	if arg_18_0.target_position then
		var_18_4 = AiUtils.broadphase_query(arg_18_0.target_position:unbox(), var_18_1, var_0_2, var_18_2)
	else
		local var_18_5 = arg_18_0.current_direction:unbox()

		var_18_4 = AiUtils.broadphase_query(arg_18_1 + var_18_5 * var_18_3, var_18_1, var_0_2, var_18_2)

		if var_18_4 <= 0 then
			var_18_4 = AiUtils.broadphase_query(arg_18_1 + var_18_5 * var_18_3 * 2, var_18_1 * 2, var_0_2, var_18_2)
		end
	end

	if var_18_4 > 0 then
		local var_18_6 = 1

		while var_18_6 <= var_18_4 do
			local var_18_7 = var_0_2[var_18_6]
			local var_18_8 = Unit.get_data(var_18_7, "breed")

			if not var_18_8 or var_18_8.no_autoaim or not ScriptUnit.has_extension(var_18_7, "health_system") or not HEALTH_ALIVE[var_18_7] or arg_18_0.hit_units[var_18_7] or not arg_18_0:_check_target_valid(var_18_7, arg_18_1, arg_18_2) then
				table.swap_delete(var_0_2, var_18_6)

				var_18_4 = var_18_4 - 1
			else
				var_18_6 = var_18_6 + 1
			end
		end

		TrueFlightUtility.sort_prioritize_specials(var_0_2)

		return var_0_2[1]
	end

	return nil
end

function ProjectileTrueFlightLocomotionExtension.legitimate_always(arg_19_0, arg_19_1, arg_19_2)
	return true
end

function ProjectileTrueFlightLocomotionExtension.legitimate_never(arg_20_0, arg_20_1, arg_20_2)
	return false
end

function ProjectileTrueFlightLocomotionExtension.legitimate_only_dot_check(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = Unit.has_node(arg_21_1, "c_spine") and Unit.node(arg_21_1, "c_spine") or 0
	local var_21_1 = Unit.world_position(arg_21_1, var_21_0)
	local var_21_2 = arg_21_0.current_direction:unbox()
	local var_21_3 = var_21_1 - arg_21_2
	local var_21_4 = Vector3.normalize(var_21_3)

	if Vector3.dot(var_21_2, var_21_4) > -arg_21_0._valid_target_dot then
		return true
	else
		arg_21_0.target_unit = nil
	end
end

function ProjectileTrueFlightLocomotionExtension.legitimate_target(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = var_0_0(arg_22_1, "c_head")
	local var_22_1 = arg_22_0.current_direction:unbox()
	local var_22_2 = var_22_0 - arg_22_2

	if Vector3.length_squared(var_22_2) < math.epsilon then
		return true
	end

	local var_22_3 = Vector3.normalize(var_22_2)

	if Vector3.dot(var_22_1, var_22_3) > -arg_22_0._valid_target_dot then
		local var_22_4 = World.get_data(arg_22_0.world, "physics_world")
		local var_22_5 = PhysicsWorld.immediate_raycast_actors(var_22_4, arg_22_2, var_22_3, 10000, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local var_22_6 = 4

		if var_22_5 then
			for iter_22_0, iter_22_1 in pairs(var_22_5) do
				local var_22_7 = iter_22_1[var_22_6]
				local var_22_8 = Actor.unit(var_22_7)

				if var_22_8 ~= arg_22_0.owner_unit then
					if Unit.get_data(var_22_8, "breed") then
						if var_22_8 == arg_22_1 then
							return true
						end
					elseif var_22_7 ~= Unit.actor(var_22_8, "c_afro") then
						return false
					end
				end
			end
		end
	else
		arg_22_0.target_unit = nil
	end

	return false
end

function ProjectileTrueFlightLocomotionExtension.legitimate_target_keep_target(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = var_0_0(arg_23_1, "c_head")
	local var_23_1 = arg_23_0.current_direction:unbox()
	local var_23_2 = var_23_0 - arg_23_2

	if Vector3.length_squared(var_23_2) == 0 then
		return true
	end

	local var_23_3 = Vector3.normalize(var_23_2)

	if Vector3.dot(var_23_1, var_23_3) > -arg_23_0._valid_target_dot and Vector3.length_squared(var_23_3) > 0 then
		local var_23_4 = World.get_data(arg_23_0.world, "physics_world")
		local var_23_5 = PhysicsWorld.immediate_raycast_actors(var_23_4, arg_23_2, var_23_3, 10000, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local var_23_6 = 4

		if var_23_5 then
			for iter_23_0, iter_23_1 in pairs(var_23_5) do
				local var_23_7 = iter_23_1[var_23_6]
				local var_23_8 = Actor.unit(var_23_7)

				if var_23_8 ~= arg_23_0.owner_unit then
					if Unit.get_data(var_23_8, "breed") then
						if var_23_8 == arg_23_1 then
							return true
						end
					elseif var_23_7 ~= Unit.actor(var_23_8, "c_afro") then
						return false
					end
				end
			end
		end
	end

	return false
end

function ProjectileTrueFlightLocomotionExtension.legitimate_player_target(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.target_node
	local var_24_1 = Unit.has_node(arg_24_1, var_24_0) and Unit.node(arg_24_1, var_24_0) or 0
	local var_24_2 = Unit.world_position(arg_24_1, var_24_1)
	local var_24_3 = arg_24_0.current_direction:unbox()
	local var_24_4 = var_24_2 - arg_24_2

	if Vector3.length_squared(var_24_4) == 0 then
		return true
	end

	local var_24_5 = Vector3.normalize(var_24_4)

	if Vector3.dot(var_24_3, var_24_5) > -0.99 then
		local var_24_6 = World.get_data(arg_24_0.world, "physics_world")
		local var_24_7 = PhysicsWorld.immediate_raycast_actors(var_24_6, arg_24_2, var_24_5, 10000, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local var_24_8 = 4

		if var_24_7 then
			for iter_24_0, iter_24_1 in pairs(var_24_7) do
				local var_24_9 = iter_24_1[var_24_8]
				local var_24_10 = Actor.unit(var_24_9)

				if var_24_10 ~= arg_24_0.owner_unit then
					if VALID_PLAYERS_AND_BOTS[var_24_10] then
						if var_24_10 == arg_24_1 then
							return true
						end
					elseif var_24_9 ~= Unit.actor(var_24_10, "c_afro") then
						return false
					end
				end
			end
		end
	else
		arg_24_0.target_unit = nil
	end

	return false
end

function ProjectileTrueFlightLocomotionExtension._unit_set_position_rotation(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0.true_flight_template.update_unit_position then
		arg_25_0.true_flight_template.update_unit_position(arg_25_1, arg_25_2, arg_25_3, arg_25_0._custom_data, arg_25_0)
	else
		Unit.set_local_rotation(arg_25_1, 0, arg_25_3)
		Unit.set_local_position(arg_25_1, 0, arg_25_2)
	end
end

function ProjectileTrueFlightLocomotionExtension.moved_this_frame(arg_26_0)
	return arg_26_0.moved
end

function ProjectileTrueFlightLocomotionExtension.current_velocity(arg_27_0)
	return arg_27_0.velocity:unbox()
end

function ProjectileTrueFlightLocomotionExtension.current_position(arg_28_0)
	return arg_28_0._current_position:unbox()
end

function ProjectileTrueFlightLocomotionExtension.destroy(arg_29_0)
	if arg_29_0.true_flight_template.create_bot_threat then
		local var_29_0 = HEALTH_ALIVE[arg_29_0.owner_unit] and BLACKBOARDS[arg_29_0.owner_unit]

		if var_29_0 then
			var_29_0.created_missile_bot_threat = nil
		end
	end

	arg_29_0.hit_units = nil
end

function ProjectileTrueFlightLocomotionExtension.notify_hit_enemy(arg_30_0, arg_30_1)
	arg_30_0.hit_units[arg_30_1] = true
	arg_30_0.raycast_timer = 0
end

function ProjectileTrueFlightLocomotionExtension.update_bot_threat(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_2 < arg_31_0.true_flight_template.bot_threat_at_distance then
		local var_31_0 = HEALTH_ALIVE[arg_31_0.owner_unit] and BLACKBOARDS[arg_31_0.owner_unit]

		if var_31_0 and not var_31_0.created_missile_bot_threat then
			var_31_0.missile_bot_threat_unit = arg_31_1
			var_31_0.created_missile_bot_threat = true
		end
	end
end

function ProjectileTrueFlightLocomotionExtension.stop(arg_32_0)
	if arg_32_0.true_flight_template.update_after_impact then
		return
	end

	arg_32_0.stopped = true
end
