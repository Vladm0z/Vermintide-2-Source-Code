-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_warpfire_thrower_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTWarpfireThrowerShootAction = class(BTWarpfireThrowerShootAction, BTNode)

BTWarpfireThrowerShootAction.init = function (arg_1_0, ...)
	BTWarpfireThrowerShootAction.super.init(arg_1_0, ...)
end

BTWarpfireThrowerShootAction.name = "BTWarpfireThrowerShootAction"

local var_0_1 = {}

BTWarpfireThrowerShootAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.attack_finished = false

	local var_2_0 = arg_2_2.world

	arg_2_2.physics_world = arg_2_2.physics_world or World.get_data(var_2_0, "physics_world")

	local var_2_1 = arg_2_2.attack_pattern_data or {}

	arg_2_2.attack_pattern_data = var_2_1

	local var_2_2 = arg_2_2.breed.default_inventory_template

	var_2_1.warpfire_gun_unit = ScriptUnit.extension(arg_2_1, "ai_inventory_system"):get_unit(var_2_2)
	var_2_1.state = "align"

	local var_2_3 = Unit.local_rotation(arg_2_1, 0)
	local var_2_4 = Quaternion.forward(var_2_3)

	var_2_1.shoot_direction_box = Vector3Box(var_2_4)

	arg_2_2.navigation_extension:stop()
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	var_2_1.constraint_target = var_2_1.constraint_target or Unit.animation_find_constraint_target(arg_2_1, "aim_target")

	local var_2_5 = arg_2_2.target_unit

	arg_2_0:_start_align_towards_target(arg_2_1, arg_2_2, var_2_1, var_2_5)

	arg_2_2.move_state = "attacking"
	arg_2_2.attack_aborted = false
	arg_2_2.line_of_sight_raycast_timer = arg_2_3 + 0.5
	arg_2_2.close_attack_cooldown = 0

	local var_2_6 = arg_2_2.warpfire_data or {}

	arg_2_2.warpfire_data = var_2_6
	var_2_6.is_firing = false

	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_2_1, var_2_5, "warpfire_thrower_fire")
end

BTWarpfireThrowerShootAction._init_attack = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = POSITION_LOOKUP[arg_3_2]
	local var_3_1

	if var_3_0 then
		local var_3_2 = POSITION_LOOKUP[arg_3_1]
		local var_3_3 = arg_3_4.minimum_length

		var_3_1 = Vector3.distance_squared(var_3_2, var_3_0) > var_3_3^2
	else
		var_3_1 = false
	end

	return var_3_1
end

BTWarpfireThrowerShootAction._abort_shooting = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_2.blob_extension:stop_placing_blobs(arg_4_1)

	arg_4_2.is_firing = false
end

BTWarpfireThrowerShootAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_2.warpfire_data

	if var_5_0.is_firing then
		arg_5_0:_abort_shooting(arg_5_3, var_5_0)
	end

	Managers.state.network:anim_event(arg_5_1, "attack_shoot_end")

	local var_5_1 = arg_5_2.target_unit

	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_5_1, var_5_1, "warpfire_thrower_fire")

	arg_5_2.action = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.anim_cb_attack_shoot_random_shot = nil
	arg_5_2.create_bot_threat_at_t = nil

	for iter_5_0, iter_5_1 in pairs(var_0_1) do
		var_0_1[iter_5_0] = nil
	end
end

BTWarpfireThrowerShootAction.run = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_2.attack_aborted then
		return "failed"
	end

	local var_6_0 = arg_6_2.action
	local var_6_1 = arg_6_2.target_unit
	local var_6_2 = arg_6_2.warpfire_data
	local var_6_3 = arg_6_2.attack_pattern_data

	if var_6_3.state == "align" then
		local var_6_4 = arg_6_2.old_target_unit

		if not var_6_4 or var_6_1 ~= var_6_4 then
			arg_6_0:_start_align_towards_target(arg_6_1, arg_6_2, var_6_3, var_6_1)

			arg_6_2.old_target_unit = var_6_1
		end

		if arg_6_0:_update_align_towards_target(arg_6_1, arg_6_2, var_6_3, var_6_1, arg_6_4) then
			arg_6_0:_end_align_towards_target(arg_6_1, var_6_2, var_6_3, arg_6_2, arg_6_3)

			local var_6_5 = var_6_0.bot_threat_start_time

			if var_6_5 then
				arg_6_2.create_bot_threat_at_t = arg_6_3 + var_6_5
			end
		end

		return "running"
	elseif var_6_3.state == "ready" then
		local var_6_6 = arg_6_2.create_bot_threat_at_t

		if var_6_6 and var_6_6 < arg_6_3 then
			arg_6_0:_create_bot_aoe_threat(arg_6_1, var_6_0)

			arg_6_2.create_bot_threat_at_t = nil
		end

		if arg_6_2.anim_cb_attack_shoot_random_shot then
			if arg_6_3 < var_6_2.stop_firing_t then
				if not var_6_2.is_firing then
					if arg_6_0:_init_attack(arg_6_1, var_6_1, arg_6_2, var_6_0) then
						arg_6_0:_attack_fire(arg_6_1, var_6_2, var_6_0, arg_6_2, arg_6_3)

						arg_6_2.warpfire_face_timer = arg_6_3 + arg_6_2.target_dist * 0.08

						local var_6_7 = POSITION_LOOKUP[arg_6_1]
						local var_6_8 = Vector3.flat(POSITION_LOOKUP[var_6_1] - var_6_7)
						local var_6_9 = Vector3.normalize(var_6_8)
						local var_6_10 = Vector3.flat(Quaternion.forward(Unit.local_rotation(arg_6_1, 0)))
						local var_6_11 = Vector3.normalize(var_6_10)
						local var_6_12 = Vector3.dot(var_6_9, var_6_11)

						if var_6_12 < 0 then
							arg_6_2.warpfire_face_timer = arg_6_2.warpfire_face_timer + math.abs(var_6_12)
						end
					else
						return "done"
					end
				else
					if arg_6_0:_close_range_attack_check(arg_6_2, var_6_0, arg_6_3) and arg_6_2.warpfire_face_timer and arg_6_3 > arg_6_2.warpfire_face_timer then
						arg_6_0:_close_range_attack(arg_6_1, var_6_3, arg_6_2, var_6_0, arg_6_3)
					end

					local var_6_13, var_6_14 = arg_6_0:_aim_at_target(arg_6_1, var_6_1, var_6_3, arg_6_2, var_6_0, arg_6_3, arg_6_4)

					if var_6_14 then
						arg_6_2.warpfire_face_timer = arg_6_3 + arg_6_2.target_dist * 0.08
					end

					if var_6_13 then
						return "done"
					end

					arg_6_0:_move_warpfire_blob(arg_6_1, var_6_2, arg_6_2, var_6_0, arg_6_4)

					return "running"
				end
			else
				return "done"
			end
		end
	end

	return "running"
end

BTWarpfireThrowerShootAction._move_warpfire_blob = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_2.blob_unit
	local var_7_1 = POSITION_LOOKUP[var_7_0]

	if var_7_0 and var_7_1 then
		local var_7_2 = arg_7_3.target_unit
		local var_7_3 = arg_7_3.target_dist
		local var_7_4 = POSITION_LOOKUP[var_7_2]
		local var_7_5
		local var_7_6
		local var_7_7 = arg_7_4.close_attack_range
		local var_7_8 = arg_7_4.warpfire_follow_target_speed

		if var_7_7 < var_7_3 then
			var_7_5 = math.min(arg_7_5 * var_7_8, 1)
			var_7_6 = var_7_4
		else
			var_7_5 = math.min(arg_7_5 * var_7_8 * 6, 1)

			local var_7_9 = POSITION_LOOKUP[arg_7_1]

			var_7_6 = var_7_9 + Vector3.normalize(var_7_4 - var_7_9) * var_7_7
		end

		local var_7_10 = Vector3.lerp(var_7_1, var_7_6, var_7_5)

		Unit.set_local_position(var_7_0, 0, var_7_10)
	end
end

BTWarpfireThrowerShootAction._end_align_towards_target = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_3.state = "ready"
	arg_8_3.shoot_direction_start = nil
	arg_8_3.current_aim_rotation = QuaternionBox(Quaternion.look(arg_8_3.shoot_direction_box:unbox(), Vector3.up()))
	arg_8_2.stop_firing_t = arg_8_5 + arg_8_4.action.firing_time

	Managers.state.network:anim_event(arg_8_1, "attack_shoot_start")

	arg_8_4.close_attack_cooldown = 0
end

BTWarpfireThrowerShootAction._start_align_towards_target = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_3.state = "align"
	arg_9_3.align_speed = 0
	arg_9_3.current_aim_rotation = nil
	arg_9_2.anim_cb_attack_shoot_random_shot = nil

	local var_9_0 = arg_9_2.action
	local var_9_1, var_9_2, var_9_3 = arg_9_0:_calculate_wanted_target_position(arg_9_1, arg_9_4)
	local var_9_4 = Vector3.normalize(Vector3.flat(var_9_1 - var_9_3))
	local var_9_5 = Unit.world_rotation(arg_9_1, 0)
	local var_9_6 = Quaternion.forward(var_9_5)
	local var_9_7 = Quaternion.right(var_9_5)
	local var_9_8 = arg_9_0:_calculate_align_animation(var_9_7, var_9_6, var_9_4, var_9_0.attack_anims, var_9_3)

	Managers.state.network:anim_event(arg_9_1, var_9_8)
end

local var_0_2 = math.pi
local var_0_3 = var_0_2 * 2
local var_0_4 = var_0_2 * 24
local var_0_5 = var_0_2 * 6
local var_0_6 = var_0_2 / 32
local var_0_7 = 0.7

BTWarpfireThrowerShootAction._remaining_angle = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Quaternion.forward(arg_10_1)
	local var_10_1 = Quaternion.forward(arg_10_2)
	local var_10_2 = math.atan2(var_10_0.y, var_10_0.x)
	local var_10_3 = math.atan2(var_10_1.y, var_10_1.x)
	local var_10_4 = var_0_2
	local var_10_5 = var_10_4 * 2

	return ((var_10_3 - var_10_2) % var_10_5 + var_10_4) % var_10_5 - var_10_4
end

BTWarpfireThrowerShootAction._angle_to_speed = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 > 0 then
		return arg_11_1
	else
		return -arg_11_1
	end
end

BTWarpfireThrowerShootAction._update_align_towards_target = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0, var_12_1, var_12_2 = arg_12_0:_calculate_wanted_target_position(arg_12_1, arg_12_4)
	local var_12_3 = arg_12_2.action
	local var_12_4 = Unit.local_rotation(arg_12_1, 0)
	local var_12_5 = arg_12_0:_remaining_angle(var_12_4, var_12_1)
	local var_12_6 = arg_12_0:_angle_to_speed(var_12_3.rotation_speed, var_12_5)
	local var_12_7 = arg_12_3.align_speed

	if var_12_6 == 0 and var_12_7 > 0 then
		var_12_7 = math.max(var_12_7 - var_0_5 * arg_12_5, 0)
	elseif var_12_6 == 0 and var_12_7 < 0 then
		var_12_7 = math.min(var_12_7 + var_0_5 * arg_12_5, 0)
	elseif var_12_7 < var_12_6 and var_12_6 > 0 then
		var_12_7 = math.min(var_12_7 + var_0_4 * arg_12_5, var_12_6)
	elseif var_12_6 < var_12_7 and var_12_6 < 0 then
		var_12_7 = math.max(var_12_7 - var_0_4 * arg_12_5, var_12_6)
	elseif var_12_7 < var_12_6 and var_12_6 < 0 then
		var_12_7 = math.min(var_12_7 + var_0_5 * arg_12_5, var_12_6)
	else
		var_12_7 = math.max(var_12_7 - var_0_4 * arg_12_5, var_12_6)
	end

	arg_12_3.align_speed = var_12_7

	local var_12_8 = var_12_7 * arg_12_5
	local var_12_9 = Quaternion.multiply(var_12_4, Quaternion(Vector3.up(), var_12_8))

	arg_12_2.locomotion_extension:set_wanted_rotation(var_12_9)

	local var_12_10 = math.min(arg_12_5 * 3, 1)
	local var_12_11 = Vector3.lerp(arg_12_3.shoot_direction_box:unbox(), Quaternion.forward(var_12_9), var_12_10)

	arg_12_3.shoot_direction_box:store(var_12_11)

	return math.abs(var_12_5) < var_0_6
end

BTWarpfireThrowerShootAction._close_range_attack_check = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	return arg_13_1.target_dist < arg_13_2.close_attack_range and arg_13_3 > arg_13_1.close_attack_cooldown
end

BTWarpfireThrowerShootAction._close_range_attack = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_4.muzzle_node
	local var_14_1 = arg_14_2.warpfire_gun_unit
	local var_14_2 = Unit.node(var_14_1, var_14_0)
	local var_14_3 = Unit.world_position(var_14_1, var_14_2)
	local var_14_4 = POSITION_LOOKUP[arg_14_3.target_unit]
	local var_14_5 = Vector3.flat(var_14_4 - var_14_3)
	local var_14_6 = Vector3.length(var_14_5)
	local var_14_7 = arg_14_2.warpfire_gun_unit
	local var_14_8 = Vector3.flat(Quaternion.forward(Unit.world_rotation(var_14_7, var_14_2)))
	local var_14_9 = Vector3.normalize(var_14_8)
	local var_14_10 = var_14_3 + var_14_9 * arg_14_4.close_attack_range
	local var_14_11 = var_14_3 - var_14_9 * 0.5
	local var_14_12 = arg_14_3.physics_world
	local var_14_13 = arg_14_4.hit_radius
	local var_14_14 = 10
	local var_14_15 = PhysicsWorld.linear_sphere_sweep(var_14_12, var_14_11, var_14_10, var_14_13, var_14_14, "collision_filter", "filter_character_trigger", "report_initial_overlap")
	local var_14_16 = Managers.state.entity:system("buff_system")

	if var_14_15 then
		local var_14_17 = #var_14_15

		for iter_14_0 = 1, var_14_17 do
			local var_14_18 = var_14_15[iter_14_0].actor
			local var_14_19 = Actor.unit(var_14_18)

			if var_14_19 ~= arg_14_1 then
				local var_14_20 = DamageUtils.is_enemy(arg_14_3.target_unit, var_14_19)
				local var_14_21 = DamageUtils.is_player_unit(var_14_19)

				if (var_14_20 or var_14_21) and ScriptUnit.has_extension(var_14_19, "buff_system") then
					local var_14_22 = arg_14_4.buff_name

					if var_14_20 and not var_0_1[var_14_19] and HEALTH_ALIVE[var_14_19] then
						local var_14_23 = arg_14_4.ai_push_data
						local var_14_24 = var_14_23.stagger_impact
						local var_14_25 = var_14_23.stagger_duration
						local var_14_26 = var_14_23.stagger_distance
						local var_14_27, var_14_28 = DamageUtils.calculate_stagger(var_14_24, var_14_25, var_14_19, arg_14_1)
						local var_14_29 = POSITION_LOOKUP[var_14_19]
						local var_14_30 = Vector3.normalize(var_14_29 - var_14_11)
						local var_14_31 = BLACKBOARDS[var_14_19]

						if var_14_27 > var_0_0.none then
							AiUtils.stagger(var_14_19, var_14_31, arg_14_1, var_14_30, var_14_26, var_14_27, var_14_28, nil, arg_14_5)
						end

						var_0_1[var_14_19] = true
					end

					if var_14_21 then
						local var_14_32 = ScriptUnit.has_extension(arg_14_3.target_unit, "status_system")
						local var_14_33 = ScriptUnit.has_extension(arg_14_3.target_unit, "buff_system"):has_buff_perk("power_block")
						local var_14_34, var_14_35 = var_14_32:is_blocking()
						local var_14_36 = Vector3.normalize(var_14_5)
						local var_14_37 = Vector3.dot(var_14_36, var_14_9)
						local var_14_38 = var_14_37 > 0.99 or var_14_6 < arg_14_4.aim_rotation_override_distance and var_14_37 > 0.55

						if var_14_38 and var_14_33 and var_14_34 and var_14_35 then
							var_14_38 = not DamageUtils.check_ranged_block(arg_14_1, var_14_19, "blocked_berzerker")
						end

						if var_14_38 then
							var_14_16:add_buff(var_14_19, var_14_22, arg_14_1)
						end
					elseif HEALTH_ALIVE[var_14_19] then
						var_14_16:add_buff(var_14_19, var_14_22, arg_14_1)
					end
				end
			end
		end
	end

	arg_14_3.close_attack_cooldown = arg_14_5 + arg_14_4.close_attack_cooldown
end

BTWarpfireThrowerShootAction._aim_at_target = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	local var_15_0, var_15_1, var_15_2, var_15_3 = arg_15_0:_calculate_wanted_target_position(arg_15_1, arg_15_2)
	local var_15_4 = ScriptUnit.has_extension(arg_15_4.target_unit, "status_system")
	local var_15_5 = var_15_4 and var_15_4:get_is_dodging()
	local var_15_6 = arg_15_5.aim_rotation_override_distance
	local var_15_7 = arg_15_5.aim_rotation_override_speed_multiplier
	local var_15_8 = arg_15_5.aim_rotation_dodge_multipler
	local var_15_9 = POSITION_LOOKUP[arg_15_1]
	local var_15_10 = var_15_9 + Vector3(0, 0, var_0_7)
	local var_15_11 = var_15_0 - var_15_10
	local var_15_12 = Quaternion.look(var_15_11, Vector3.up())
	local var_15_13 = arg_15_3.current_aim_rotation:unbox()
	local var_15_14 = Vector3.distance(var_15_9, var_15_3)
	local var_15_15 = var_15_14 < var_15_6 and var_15_7 or var_15_5 and var_15_8 or math.max(1 - var_15_14 / arg_15_5.close_attack_range, 0.1)
	local var_15_16 = arg_15_5.radial_speed_upper_body_shooting * math.min(var_15_15, var_15_7)
	local var_15_17 = arg_15_0:_rotate_from_to(var_15_13, var_15_12, var_15_16, arg_15_7)
	local var_15_18 = var_15_10 + Quaternion.forward(var_15_17) * Vector3.length(var_15_11)

	arg_15_3.current_aim_rotation:store(var_15_17)

	local var_15_19 = Unit.local_rotation(arg_15_1, 0)
	local var_15_20 = arg_15_0:_rotate_from_to(var_15_19, var_15_1, arg_15_5.radial_speed_feet_shooting, arg_15_7)

	arg_15_4.locomotion_extension:set_wanted_rotation(var_15_20)
	arg_15_3.shoot_direction_box:store(var_15_18 - var_15_10)

	local var_15_21 = arg_15_4.physics_world

	PhysicsWorld.prepare_actors_for_raycast(var_15_21, var_15_10, Vector3.normalize(var_15_18 - var_15_10), arg_15_5.spread)

	local var_15_22 = false

	if arg_15_4.target_dist > arg_15_5.target_switch_distance then
		var_15_22 = true
	elseif arg_15_6 > arg_15_4.line_of_sight_raycast_timer then
		local var_15_23 = "filter_ai_line_of_sight_check"
		local var_15_24 = var_15_3 - var_15_9
		local var_15_25, var_15_26 = PhysicsWorld.immediate_raycast(var_15_21, var_15_9 + Vector3.up(), Vector3.normalize(var_15_24), Vector3.length(var_15_24), "closest", "collision_filter", var_15_23)

		if var_15_25 then
			var_15_22 = true
		end

		arg_15_4.line_of_sight_raycast_timer = arg_15_6 + 0.5
	end

	local var_15_27 = false

	if arg_15_4.old_target_unit ~= arg_15_2 then
		var_15_27 = true
		arg_15_4.old_target_unit = arg_15_2
	end

	return var_15_22, var_15_27
end

BTWarpfireThrowerShootAction._rotate_from_to = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = Quaternion.dot(arg_16_2, arg_16_1)
	local var_16_1 = 2 * math.acos(math.clamp(var_16_0, -1, 1))
	local var_16_2 = arg_16_3 * arg_16_4
	local var_16_3 = var_16_1 == 0 and 1 or math.min(var_16_2 / var_16_1, 1)
	local var_16_4 = math.abs((var_16_1 % var_0_3 + var_0_2) % var_0_3 - var_0_2)

	return Quaternion.lerp(arg_16_1, arg_16_2, var_16_3), math.max(var_16_4 - var_16_2, 0)
end

BTWarpfireThrowerShootAction._calculate_wanted_target_position = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Unit.world_position(arg_17_1, Unit.node(arg_17_1, "c_spine"))
	local var_17_1 = POSITION_LOOKUP[arg_17_2] + Vector3.up()
	local var_17_2 = var_17_0 + (var_17_1 - var_17_0) * 0.5
	local var_17_3 = Vector3.length(var_17_1 - var_17_0)

	var_17_2.z = var_17_2.z + var_17_3 * 0.01

	if var_17_3 < 2 then
		var_17_2 = var_17_1
	end

	local var_17_4 = LocomotionUtils.look_at_position_flat(arg_17_1, var_17_2)

	return var_17_2, var_17_4, var_17_0, var_17_1
end

BTWarpfireThrowerShootAction._calculate_align_animation = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = Vector3.dot(arg_18_1, arg_18_3)
	local var_18_1 = Vector3.dot(arg_18_2, arg_18_3)
	local var_18_2 = math.abs(var_18_0)
	local var_18_3 = math.abs(var_18_1)
	local var_18_4
	local var_18_5 = var_18_3 < var_18_2

	if var_18_5 and var_18_0 > 0.5 then
		var_18_4 = arg_18_4.right
	elseif var_18_5 and var_18_0 < -0.5 then
		var_18_4 = arg_18_4.left
	elseif var_18_1 > 0 then
		var_18_4 = arg_18_4.fwd
	else
		var_18_4 = arg_18_4.bwd
	end

	return var_18_4
end

BTWarpfireThrowerShootAction._attack_fire = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	arg_19_0:_create_warpfire_blob(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)

	arg_19_2.is_firing = true
	arg_19_4.has_fired = true
end

BTWarpfireThrowerShootAction._create_warpfire_blob = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_4.attack_pattern_data
	local var_20_1 = arg_20_4.warpfire_data
	local var_20_2 = var_20_0.warpfire_gun_unit
	local var_20_3 = arg_20_4.target_unit
	local var_20_4 = POSITION_LOOKUP[var_20_3]
	local var_20_5 = POSITION_LOOKUP[arg_20_1]
	local var_20_6 = {
		area_damage_system = {
			damage_blob_template_name = "warpfire",
			source_unit = arg_20_1
		}
	}
	local var_20_7 = "units/hub_elements/empty"
	local var_20_8 = Managers.state.unit_spawner:spawn_network_unit(var_20_7, "damage_blob_unit", var_20_6, var_20_4)
	local var_20_9 = ScriptUnit.extension(var_20_8, "area_damage_system")

	var_20_1.blob_unit = var_20_8
	var_20_1.blob_extension = var_20_9

	local var_20_10 = Vector3.length(var_20_4 - var_20_5) / 10

	var_20_9:start_placing_blobs(var_20_10, arg_20_5)
end

BTWarpfireThrowerShootAction._calculate_cylinder_collision = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_1.bot_threat_radius
	local var_21_1 = arg_21_1.bot_threat_height
	local var_21_2 = arg_21_1.bot_threat_offset_up
	local var_21_3 = arg_21_1.bot_threat_offset_forward
	local var_21_4 = var_21_1 * 0.5
	local var_21_5 = Vector3(0, var_21_0, var_21_4)
	local var_21_6 = Quaternion.forward(arg_21_3)
	local var_21_7 = Quaternion.up(arg_21_3)

	return arg_21_2 + var_21_6 * var_21_3 + var_21_7 * (var_21_4 + var_21_2), var_21_5
end

BTWarpfireThrowerShootAction._create_bot_aoe_threat = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = POSITION_LOOKUP[arg_22_1]
	local var_22_1 = Unit.local_rotation(arg_22_1, 0)
	local var_22_2 = arg_22_2.bot_threat_duration
	local var_22_3 = Managers.state.entity:system("ai_bot_group_system")
	local var_22_4, var_22_5 = arg_22_0:_calculate_cylinder_collision(arg_22_2, var_22_0, var_22_1)

	var_22_3:aoe_threat_created(var_22_4, "cylinder", var_22_5, nil, var_22_2, "Warpfire Shoot")
end
