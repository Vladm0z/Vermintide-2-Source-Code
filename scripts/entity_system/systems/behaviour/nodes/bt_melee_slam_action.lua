-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_melee_slam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMeleeSlamAction = class(BTMeleeSlamAction, BTNode)

function BTMeleeSlamAction.init(arg_1_0, ...)
	BTMeleeSlamAction.super.init(arg_1_0, ...)
end

BTMeleeSlamAction.name = "BTMeleeSlamAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTMeleeSlamAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTMeleeSlamAction

	arg_3_0:init_attack(arg_3_1, arg_3_2, var_3_0, arg_3_3)

	arg_3_2.attack_cooldown = arg_3_3 + var_3_0.cooldown
	arg_3_2.anim_locked = arg_3_3 + var_3_0.attack_time
	arg_3_2.move_state = "attacking"
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.keep_target = true
	arg_3_2.rotate_towards_target = true

	Managers.state.conflict:freeze_intensity_decay(15)

	local var_3_1 = arg_3_2.target_unit

	AiUtils.add_attack_intensity(var_3_1, var_3_0, arg_3_2)
end

function BTMeleeSlamAction.init_attack(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0, var_4_1 = LocomotionUtils.get_attack_anim(arg_4_1, arg_4_2, arg_4_3.attack_anims)

	var_4_1 = var_4_1 or arg_4_3.anim_driven or false
	arg_4_2.attack_anim_driven = var_4_1

	LocomotionUtils.set_animation_driven_movement(arg_4_1, var_4_1, false, false)

	if var_4_1 then
		arg_4_2.locomotion_extension:use_lerp_rotation(false)
	else
		arg_4_2.navigation_extension:stop()
	end

	local var_4_2 = var_0_0(var_4_0 or arg_4_3.attack_anim)

	Managers.state.network:anim_event(arg_4_1, var_4_2)

	local var_4_3 = arg_4_2.target_unit

	arg_4_2.attacking_target = var_4_3
	arg_4_2.attack_started_at_t = arg_4_4

	local var_4_4 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, var_4_3)

	arg_4_2.attack_rotation = QuaternionBox(var_4_4)

	local var_4_5 = arg_4_3.bot_threats and (arg_4_3.bot_threats[var_4_2] or arg_4_3.bot_threats[1] and arg_4_3.bot_threats)

	if var_4_5 then
		local var_4_6 = 1

		arg_4_2.create_bot_threat_at_t = arg_4_4 + var_4_5[var_4_6].start_time
		arg_4_2.current_bot_threat_index = var_4_6
		arg_4_2.bot_threats_data = var_4_5
	end
end

function BTMeleeSlamAction.leave(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_2.attack_anim_driven and not arg_5_5 then
		local var_5_0 = arg_5_2.locomotion_extension

		LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
		var_5_0:use_lerp_rotation(true)
	end

	arg_5_2.attack_anim_driven = nil
	arg_5_2.action = nil
	arg_5_2.active_node = nil
	arg_5_2.attack_rotation = nil
	arg_5_2.attacking_target = nil
	arg_5_2.attack_started_at_t = nil
	arg_5_2.keep_target = nil
	arg_5_2.create_bot_threat_at_t = nil
	arg_5_2.current_bot_threat_index = nil
	arg_5_2.bot_threats_data = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.rotate_towards_target = nil
end

function BTMeleeSlamAction._calculate_collision(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.height
	local var_6_1 = arg_6_2 + arg_6_3 * arg_6_1.forward_offset + Vector3(0, 0, var_6_0 * 0.5)
	local var_6_2 = Vector3(arg_6_1.radius, var_6_0, arg_6_1.radius)
	local var_6_3 = Quaternion.look(Vector3.up(), Vector3.up())

	return var_6_1, var_6_3, var_6_2
end

function BTMeleeSlamAction._calculate_cylinder_collision(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.radius or arg_7_1.radius
	local var_7_1 = arg_7_2.height or arg_7_1.height
	local var_7_2 = arg_7_2.offset_forward or arg_7_1.forward_offset
	local var_7_3 = var_7_1 * 0.5
	local var_7_4 = Vector3(0, var_7_0, var_7_3)
	local var_7_5 = Quaternion.forward(arg_7_4)
	local var_7_6 = Quaternion.up(arg_7_4)
	local var_7_7 = arg_7_3 + var_7_5 * var_7_2 + var_7_6 * var_7_3
	local var_7_8 = Quaternion.look(var_7_6, Vector3.up())

	return var_7_7, var_7_8, var_7_4
end

function BTMeleeSlamAction._create_bot_aoe_threat(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_4.duration
	local var_8_1 = POSITION_LOOKUP[arg_8_1]
	local var_8_2 = Managers.state.entity:system("ai_bot_group_system")
	local var_8_3, var_8_4, var_8_5 = arg_8_0:_calculate_cylinder_collision(arg_8_3, arg_8_4, var_8_1, arg_8_2)

	var_8_2:aoe_threat_created(var_8_3, "cylinder", var_8_5, nil, var_8_0, "Melee Slam")
end

function BTMeleeSlamAction.anim_cb_damage(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2.is_illusion then
		arg_9_2.rotate_towards_target = false

		return
	end

	local var_9_0 = arg_9_2.world
	local var_9_1 = World.get_data(var_9_0, "physics_world")
	local var_9_2 = arg_9_2.action
	local var_9_3 = Quaternion.forward(Unit.local_rotation(arg_9_1, 0))
	local var_9_4 = POSITION_LOOKUP[arg_9_1]
	local var_9_5, var_9_6, var_9_7 = arg_9_0:_calculate_collision(var_9_2, var_9_4, var_9_3)
	local var_9_8 = var_9_7.y - var_9_7.x > 0 and "capsule" or "sphere"

	PhysicsWorld.prepare_actors_for_overlap(var_9_1, var_9_5, math.max(var_9_2.radius, var_9_2.height))

	local var_9_9, var_9_10 = PhysicsWorld.immediate_overlap(var_9_1, "shape", var_9_8, "position", var_9_5, "rotation", var_9_6, "size", var_9_7, "types", "both", "collision_filter", "filter_rat_ogre_melee_slam")
	local var_9_11 = Managers.time:time("game")
	local var_9_12 = FrameTable.alloc_table()

	for iter_9_0 = 1, var_9_10 do
		local var_9_13 = var_9_9[iter_9_0]
		local var_9_14 = Actor.unit(var_9_13)

		if var_9_14 ~= arg_9_1 and not var_9_12[var_9_14] then
			local var_9_15
			local var_9_16 = ScriptUnit.has_extension(var_9_14, "status_system")

			if var_9_16 then
				local var_9_17
				local var_9_18 = Vector3.flat(POSITION_LOOKUP[var_9_14] - var_9_5)

				if var_9_16.is_dodging and Vector3.length_squared(var_9_18) > var_9_2.dodge_mitigation_radius_squared then
					var_9_17 = true
				end

				if not var_9_17 then
					local var_9_19 = var_9_2.attack_directions and var_9_2.attack_directions[arg_9_2.attack_anim]

					if var_9_16:is_disabled() then
						var_9_15 = var_9_2.damage
					elseif DamageUtils.check_ranged_block(arg_9_1, var_9_14, var_9_2.shield_blocked_fatigue_type or "shield_blocked_slam") then
						local var_9_20 = var_9_2.player_push_speed_blocked * Vector3.normalize(POSITION_LOOKUP[var_9_14] - var_9_4)

						ScriptUnit.extension(var_9_14, "locomotion_system"):add_external_velocity(var_9_20)
					elseif DamageUtils.check_block(arg_9_1, var_9_14, var_9_2.fatigue_type, var_9_19) then
						local var_9_21 = var_9_2.player_push_speed_blocked * Vector3.normalize(POSITION_LOOKUP[var_9_14] - var_9_4)

						ScriptUnit.extension(var_9_14, "locomotion_system"):add_external_velocity(var_9_21)

						var_9_15 = var_9_2.blocked_damage
					else
						var_9_15 = var_9_2.damage
					end
				end

				if var_9_2.hit_player_func and var_9_15 then
					var_9_2.hit_player_func(arg_9_1, arg_9_2, var_9_14, var_9_15)
				end
			elseif Unit.has_data(var_9_14, "breed") then
				local var_9_22 = Vector3.flat(POSITION_LOOKUP[var_9_14] - var_9_4)
				local var_9_23

				if Vector3.length_squared(var_9_22) < 0.0001 then
					var_9_23 = var_9_3
				else
					var_9_23 = Vector3.normalize(var_9_22)
				end

				AiUtils.stagger_target(arg_9_1, var_9_14, var_9_2.stagger_distance, var_9_2.stagger_impact, var_9_23, var_9_11)

				var_9_15 = var_9_2.damage

				if BLACKBOARDS[var_9_14].is_illusion then
					var_9_15 = nil
				end
			elseif ScriptUnit.has_extension(var_9_14, "ladder_system") then
				ScriptUnit.extension(var_9_14, "ladder_system"):shake()
			end

			if var_9_15 then
				AiUtils.damage_target(var_9_14, arg_9_1, var_9_2, var_9_15)
			end

			var_9_12[var_9_14] = true
		end
	end

	arg_9_2.rotate_towards_target = false
end

function BTMeleeSlamAction.run(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.attacking_target

	if arg_10_2.attack_finished or not Unit.alive(var_10_0) or arg_10_2.attack_aborted then
		return "done"
	end

	if arg_10_3 < arg_10_2.anim_locked then
		if not arg_10_2.attack_anim_driven and arg_10_2.rotate_towards_target then
			local var_10_1 = arg_10_2.locomotion_extension
			local var_10_2 = LocomotionUtils.rotation_towards_unit_flat(arg_10_1, var_10_0)

			var_10_1:set_wanted_rotation(var_10_2)
			arg_10_2.attack_rotation:store(var_10_2)
		end

		local var_10_3 = arg_10_2.create_bot_threat_at_t

		if var_10_3 and var_10_3 < arg_10_3 then
			local var_10_4 = arg_10_2.attack_rotation:unbox()
			local var_10_5 = arg_10_2.action
			local var_10_6 = arg_10_2.bot_threats_data
			local var_10_7 = arg_10_2.current_bot_threat_index
			local var_10_8 = var_10_6[var_10_7]

			arg_10_0:_create_bot_aoe_threat(arg_10_1, var_10_4, var_10_5, var_10_8)

			local var_10_9 = var_10_7 + 1
			local var_10_10 = var_10_6[var_10_9]

			if var_10_10 then
				arg_10_2.create_bot_threat_at_t = arg_10_2.attack_started_at_t + var_10_10.start_time
				arg_10_2.current_bot_threat_index = var_10_9
			else
				arg_10_2.create_bot_threat_at_t = nil
				arg_10_2.current_bot_threat_index = nil
			end
		end

		return "running"
	end

	return "done"
end
