-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_smash_door_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSmashDoorAction = class(BTSmashDoorAction, BTNode)
BTSmashDoorAction.StateInit = class(BTSmashDoorAction.StateInit)
BTSmashDoorAction.StateMovingToSmartObjectEntrance = class(BTSmashDoorAction.StateMovingToSmartObjectEntrance)
BTSmashDoorAction.StateAttacking = class(BTSmashDoorAction.StateAttacking)
BTSmashDoorAction.StateOpening = class(BTSmashDoorAction.StateOpening)
BTSmashDoorAction.StateMovingToSmartObjectExit = class(BTSmashDoorAction.StateMovingToSmartObjectExit)
BTSmashDoorAction.StateExitingSmartObject = class(BTSmashDoorAction.StateExitingSmartObject)

local function var_0_0(arg_1_0)
	if type(arg_1_0) == "table" then
		return arg_1_0[Math.random(1, #arg_1_0)]
	else
		return arg_1_0
	end
end

BTSmashDoorAction.init = function (arg_2_0, ...)
	BTSmashDoorAction.super.init(arg_2_0, ...)
end

BTSmashDoorAction.name = "BTSmashDoorAction"

BTSmashDoorAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data
	local var_3_1 = arg_3_2.next_smart_object_data
	local var_3_2 = var_3_1.smart_object_data.unit

	arg_3_2.action = var_3_0
	arg_3_2.is_smashing_door = nil
	arg_3_2.is_opening_door = nil
	arg_3_2.active_node = BTSmashDoorAction
	arg_3_2.attacks_done = 0
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.smash_door = arg_3_2.smash_door or {}
	arg_3_2.smash_door.done = false
	arg_3_2.smash_door.frames_to_done = nil
	arg_3_2.smash_door.failed = false
	arg_3_2.smash_door.target_unit = var_3_2

	local var_3_3 = {
		unit = arg_3_1,
		blackboard = arg_3_2,
		action = var_3_0,
		entrance_pos = var_3_1.entrance_pos,
		exit_pos = var_3_1.exit_pos,
		exit_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(var_3_1.exit_pos:unbox() - var_3_1.entrance_pos:unbox()))),
		start_t = arg_3_3
	}

	arg_3_2.smash_door.state_machine = StateMachine:new(arg_3_0, BTSmashDoorAction.StateInit, var_3_3)

	local var_3_4 = var_3_0.rotation_speed or 10
	local var_3_5 = arg_3_2.locomotion_extension

	var_3_5:set_affected_by_gravity(false)
	var_3_5:set_movement_type("snap_to_navmesh")
	var_3_5:set_rotation_speed(var_3_4)

	arg_3_2.spawn_to_running = nil
end

BTSmashDoorAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_5 then
		local var_4_0 = arg_4_2.locomotion_extension

		var_4_0:set_affected_by_gravity(true)
		var_4_0:set_movement_type("snap_to_navmesh")
	end

	local var_4_1 = arg_4_2.navigation_extension

	var_4_1:set_enabled(true)

	if var_4_1:is_using_smart_object() and not var_4_1:use_smart_object(false) then
		local var_4_2 = arg_4_2.smash_door.target_unit

		if ALIVE[var_4_2] then
			ScriptUnit.extension(var_4_2, "door_system"):register_breed_failed_leaving_smart_object(arg_4_1)
		end
	end

	arg_4_2.action = nil
	arg_4_2.is_smart_objecting = nil
	arg_4_2.is_smashing_door = nil
	arg_4_2.is_opening_door = nil
	arg_4_2.smash_door.target_unit = nil
end

BTSmashDoorAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not Unit.alive(arg_5_2.smash_door.target_unit) then
		return "failed"
	end

	if arg_5_2.attack_aborted then
		return "failed"
	end

	if arg_5_2.smash_door.failed then
		return "failed"
	end

	if arg_5_2.smash_door.done then
		local var_5_0 = arg_5_2.smash_door.frames_to_done or 2

		if var_5_0 == 0 then
			return "done"
		end

		arg_5_2.smash_door.frames_to_done = var_5_0 - 1
	end

	arg_5_2.smash_door.state_machine:update(arg_5_4, arg_5_3)

	return "running"
end

BTSmashDoorAction.StateInit.on_enter = function (arg_6_0, arg_6_1)
	arg_6_0.blackboard = arg_6_1.blackboard
	arg_6_0.unit = arg_6_1.unit
	arg_6_0.entrance_pos = arg_6_1.entrance_pos
end

BTSmashDoorAction.StateInit.update = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.blackboard

	if var_7_0.is_in_smartobject_range then
		var_7_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

		local var_7_1 = var_7_0.navigation_extension

		var_7_1:set_enabled(false)

		if var_7_1:use_smart_object(true) then
			var_7_0.is_smart_objecting = true
			var_7_0.is_smashing_door = true

			return BTSmashDoorAction.StateMovingToSmartObjectEntrance
		else
			print("BTSmashDoorAction - Failing to use smart object")

			var_7_0.smash_door.failed = true
		end
	end
end

BTSmashDoorAction.StateMovingToSmartObjectEntrance.on_enter = function (arg_8_0, arg_8_1)
	arg_8_0.blackboard = arg_8_1.blackboard
	arg_8_0.unit = arg_8_1.unit
	arg_8_0.target_unit = arg_8_1.blackboard.smash_door.target_unit
	arg_8_0.entrance_pos = arg_8_1.entrance_pos
	arg_8_0.exit_lookat_direction = arg_8_1.exit_lookat_direction

	if arg_8_1.action.move_anim then
		Managers.state.network:anim_event(arg_8_1.unit, arg_8_1.action.move_anim)
	end
end

BTSmashDoorAction.StateMovingToSmartObjectEntrance.update = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.unit
	local var_9_1 = arg_9_0.blackboard
	local var_9_2 = var_9_1.action
	local var_9_3 = POSITION_LOOKUP[var_9_0]
	local var_9_4 = arg_9_0.entrance_pos:unbox() - var_9_3

	if Vector3.length_squared(var_9_4) > (var_9_2.door_attack_distance or 0.1)^2 then
		local var_9_5 = arg_9_0.exit_lookat_direction:unbox()
		local var_9_6 = Vector3.normalize(var_9_4)
		local var_9_7 = var_9_1.locomotion_extension
		local var_9_8 = var_9_2.move_speed or var_9_1.breed.walk_speed

		var_9_7:set_wanted_velocity(var_9_6 * var_9_8)
		var_9_7:set_wanted_rotation(Quaternion.look(var_9_5))
	else
		local var_9_9 = var_9_1.preferred_door_action

		if var_9_9 and var_9_9 == "open" then
			local var_9_10 = arg_9_0.target_unit

			if ScriptUnit.extension(var_9_10, "door_system").num_attackers == 0 then
				return BTSmashDoorAction.StateOpening
			end
		end

		return BTSmashDoorAction.StateAttacking
	end
end

BTSmashDoorAction.StateOpening.on_enter = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.blackboard
	local var_10_1 = arg_10_1.unit
	local var_10_2 = arg_10_1.action
	local var_10_3 = var_10_0.smash_door.target_unit

	arg_10_0.blackboard = var_10_0
	arg_10_0.unit = var_10_1
	arg_10_0.action = var_10_2
	arg_10_0.target_unit = var_10_3

	local var_10_4 = var_10_0.locomotion_extension

	var_10_4:set_wanted_velocity(Vector3.zero())

	local var_10_5 = LocomotionUtils.rotation_towards_unit(var_10_1, var_10_3)

	var_10_4:set_wanted_rotation(var_10_5)
end

BTSmashDoorAction.StateOpening.update = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.blackboard
	local var_11_1 = arg_11_0.target_unit

	if not HEALTH_ALIVE[var_11_1] then
		return BTSmashDoorAction.StateMovingToSmartObjectExit
	end

	local var_11_2 = ScriptUnit.extension(var_11_1, "door_system")

	if var_11_2:is_open() and not var_11_2:is_opening() then
		return BTSmashDoorAction.StateMovingToSmartObjectExit
	elseif not var_11_2:is_open() then
		local var_11_3 = arg_11_0.unit

		var_11_2:interacted_with(var_11_3)

		var_11_0.is_opening_door = true
	end
end

BTSmashDoorAction.StateAttacking.on_enter = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.blackboard.smash_door.target_unit
	local var_12_1 = arg_12_1.blackboard

	arg_12_0.blackboard = var_12_1
	arg_12_0.unit = arg_12_1.unit
	arg_12_0.action = arg_12_1.action
	arg_12_0.target_unit = var_12_0
	arg_12_0.start_t = arg_12_1.start_t

	var_12_1.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_12_2 = ScriptUnit.extension(var_12_0, "door_system")

	var_12_2.num_attackers = var_12_2.num_attackers + 1

	arg_12_0:attack()
end

BTSmashDoorAction.StateAttacking.update = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.blackboard
	local var_13_1 = arg_13_0.target_unit
	local var_13_2 = ScriptUnit.extension(var_13_1, "door_system")

	if not HEALTH_ALIVE[var_13_1] or var_13_2:is_open() and not var_13_2:is_opening() then
		if var_13_2.move_to_exit_when_opened then
			return BTSmashDoorAction.StateMovingToSmartObjectExit
		else
			var_13_0.smash_door.done = true
		end
	end

	if var_13_0.attack_finished then
		arg_13_0:attack()

		if var_13_2.ai_attack_re_eval_time and arg_13_2 > var_13_2.ai_attack_re_eval_time + arg_13_0.start_t then
			var_13_0.attack_aborted = true
		end
	end
end

BTSmashDoorAction.StateAttacking.on_exit = function (arg_14_0)
	local var_14_0 = arg_14_0.target_unit
	local var_14_1 = ScriptUnit.extension(var_14_0, "door_system")

	var_14_1.num_attackers = var_14_1.num_attackers - 1
end

BTSmashDoorAction.StateAttacking.attack = function (arg_15_0)
	local var_15_0 = arg_15_0.target_unit
	local var_15_1 = arg_15_0.unit
	local var_15_2 = arg_15_0.blackboard
	local var_15_3 = arg_15_0.action
	local var_15_4 = LocomotionUtils.rotation_towards_unit(var_15_1, var_15_0)

	var_15_2.locomotion_extension:set_wanted_rotation(var_15_4)

	if var_15_3.attack_anim then
		local var_15_5 = var_0_0(var_15_3.attack_anim)

		Managers.state.network:anim_event(var_15_1, var_15_5)

		var_15_2.attack_finished = false
	else
		AiUtils.kill_unit(var_15_2.smash_door.target_unit, var_15_1)

		var_15_2.attack_finished = true
	end
end

BTSmashDoorAction.StateMovingToSmartObjectExit.on_enter = function (arg_16_0, arg_16_1)
	arg_16_0.blackboard = arg_16_1.blackboard
	arg_16_0.unit = arg_16_1.unit
	arg_16_0.exit_pos = arg_16_1.exit_pos
	arg_16_0.exit_lookat_direction = arg_16_1.exit_lookat_direction

	if arg_16_1.action.move_anim then
		Managers.state.network:anim_event(arg_16_1.unit, arg_16_1.action.move_anim)
	end
end

BTSmashDoorAction.StateMovingToSmartObjectExit.update = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.unit
	local var_17_1 = arg_17_0.blackboard
	local var_17_2 = POSITION_LOOKUP[var_17_0]
	local var_17_3 = arg_17_0.exit_pos:unbox()
	local var_17_4 = Vector3.flat(var_17_3 - var_17_2)

	if Vector3.length_squared(var_17_4) > 0.010000000000000002 then
		local var_17_5 = arg_17_0.exit_lookat_direction:unbox()
		local var_17_6 = Vector3.normalize(var_17_4)
		local var_17_7 = var_17_1.locomotion_extension
		local var_17_8 = var_17_1.action.move_speed or var_17_1.breed.walk_speed

		var_17_7:set_wanted_velocity(var_17_6 * var_17_8)
		var_17_7:set_wanted_rotation(Quaternion.look(var_17_5))
	else
		var_17_1.smash_door.done = true
	end
end

BTSmashDoorAction.anim_cb_damage = function (arg_18_0, arg_18_1, arg_18_2)
	if arg_18_2.smash_door.target_unit then
		local var_18_0 = arg_18_2.action

		AiUtils.damage_target(arg_18_2.smash_door.target_unit, arg_18_1, var_18_0, var_18_0.damage)
	end
end

BTSmashDoorAction.anim_cb_attack_overlap_done = function (arg_19_0, arg_19_1, arg_19_2)
	if arg_19_2.smash_door.target_unit then
		local var_19_0 = arg_19_2.action

		AiUtils.damage_target(arg_19_2.smash_door.target_unit, arg_19_1, var_19_0, var_19_0.damage)
	end
end
