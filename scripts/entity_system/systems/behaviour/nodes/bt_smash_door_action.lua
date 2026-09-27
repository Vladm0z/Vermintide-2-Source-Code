-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_smash_door_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSmashDoorAction = class(BTSmashDoorAction, BTNode)
BTSmashDoorAction.StateInit = class(BTSmashDoorAction.StateInit)
BTSmashDoorAction.StateMovingToSmartObjectEntrance = class(BTSmashDoorAction.StateMovingToSmartObjectEntrance)
BTSmashDoorAction.StateAttacking = class(BTSmashDoorAction.StateAttacking)
BTSmashDoorAction.StateOpening = class(BTSmashDoorAction.StateOpening)
BTSmashDoorAction.StateMovingToSmartObjectExit = class(BTSmashDoorAction.StateMovingToSmartObjectExit)
BTSmashDoorAction.StateExitingSmartObject = class(BTSmashDoorAction.StateExitingSmartObject)

local function fn(self)
	-- function 1
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTSmashDoorAction.init = function (arg_2_0, ...)
	-- function 2
	BTSmashDoorAction.super.init(arg_2_0, ...)
end

BTSmashDoorAction.name = "BTSmashDoorAction"

BTSmashDoorAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data
	local next_smart_object_data = arg_3_2.next_smart_object_data
	local unit = next_smart_object_data.smart_object_data.unit

	arg_3_2.action = action_data
	arg_3_2.is_smashing_door = nil
	arg_3_2.is_opening_door = nil
	arg_3_2.active_node = BTSmashDoorAction
	arg_3_2.attacks_done = 0
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false

	local smash_door = arg_3_2.smash_door

	smash_door = smash_door or {}
	arg_3_2.smash_door = smash_door
	arg_3_2.smash_door.done = false
	arg_3_2.smash_door.frames_to_done = nil
	arg_3_2.smash_door.failed = false
	arg_3_2.smash_door.target_unit = unit

	local tbl = {
		unit = arg_3_1,
		blackboard = arg_3_2,
		action = action_data,
		entrance_pos = next_smart_object_data.entrance_pos,
		exit_pos = next_smart_object_data.exit_pos,
		exit_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(next_smart_object_data.exit_pos:unbox() - next_smart_object_data.entrance_pos:unbox()))),
		start_t = arg_3_3
	}

	arg_3_2.smash_door.state_machine = StateMachine:new(self, BTSmashDoorAction.StateInit, tbl)

	local rotation_speed = action_data.rotation_speed

	rotation_speed = rotation_speed or 10

	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_rotation_speed(rotation_speed)

	arg_3_2.spawn_to_running = nil
end

BTSmashDoorAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not arg_4_5 then
		local locomotion_extension = arg_4_2.locomotion_extension

		locomotion_extension:set_affected_by_gravity(true)
		locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)

	if not (not navigation_extension:is_using_smart_object() and navigation_extension:use_smart_object(false)) then
		local target_unit = arg_4_2.smash_door.target_unit

		if not ALIVE[target_unit] then
			ScriptUnit.extension(target_unit, "door_system"):register_breed_failed_leaving_smart_object(arg_4_1)
		end
	end

	arg_4_2.action = nil
	arg_4_2.is_smart_objecting = nil
	arg_4_2.is_smashing_door = nil
	arg_4_2.is_opening_door = nil
	arg_4_2.smash_door.target_unit = nil
end

BTSmashDoorAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not Unit.alive(arg_5_2.smash_door.target_unit) then
		return "failed"
	end

	if not arg_5_2.attack_aborted then
		return "failed"
	end

	if not arg_5_2.smash_door.failed then
		return "failed"
	end

	if not arg_5_2.smash_door.done then
		local frames_to_done = arg_5_2.smash_door.frames_to_done

		frames_to_done = frames_to_done or 2

		if frames_to_done == 0 then
			return "done"
		end

		arg_5_2.smash_door.frames_to_done = frames_to_done - 1
	end

	arg_5_2.smash_door.state_machine:update(arg_5_4, arg_5_3)

	return "running"
end

BTSmashDoorAction.StateInit.on_enter = function (self, arg_6_1)
	-- function 6
	self.blackboard = arg_6_1.blackboard
	self.unit = arg_6_1.unit
	self.entrance_pos = arg_6_1.entrance_pos
end

BTSmashDoorAction.StateInit.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local blackboard = self.blackboard

	if not blackboard.is_in_smartobject_range then
		blackboard.locomotion_extension:set_wanted_velocity(Vector3.zero())

		local navigation_extension = blackboard.navigation_extension

		navigation_extension:set_enabled(false)

		if not navigation_extension:use_smart_object(true) then
			blackboard.is_smart_objecting = true
			blackboard.is_smashing_door = true

			return BTSmashDoorAction.StateMovingToSmartObjectEntrance
		else
			print("BTSmashDoorAction - Failing to use smart object")

			blackboard.smash_door.failed = true
		end
	end
end

BTSmashDoorAction.StateMovingToSmartObjectEntrance.on_enter = function (self, arg_8_1)
	-- function 8
	self.blackboard = arg_8_1.blackboard
	self.unit = arg_8_1.unit
	self.target_unit = arg_8_1.blackboard.smash_door.target_unit
	self.entrance_pos = arg_8_1.entrance_pos
	self.exit_lookat_direction = arg_8_1.exit_lookat_direction

	if not arg_8_1.action.move_anim then
		Managers.state.network:anim_event(arg_8_1.unit, arg_8_1.action.move_anim)
	end
end

BTSmashDoorAction.StateMovingToSmartObjectEntrance.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local unit = self.unit
	local blackboard = self.blackboard
	local action = blackboard.action
	local var_9_3 = POSITION_LOOKUP[unit]
	local num = self.entrance_pos:unbox() - var_9_3
	local length_squared = Vector3.length_squared(num)
	local door_attack_distance = action.door_attack_distance

	door_attack_distance = door_attack_distance or 0.1

	if length_squared > door_attack_distance^2 then
		local unbox = self.exit_lookat_direction:unbox()
		local normalize = Vector3.normalize(num)
		local locomotion_extension = blackboard.locomotion_extension
		local move_speed = action.move_speed

		move_speed = move_speed or blackboard.breed.walk_speed

		locomotion_extension:set_wanted_velocity(normalize * move_speed)
		locomotion_extension:set_wanted_rotation(Quaternion.look(unbox))
	else
		local preferred_door_action = blackboard.preferred_door_action

		if not (not preferred_door_action and preferred_door_action ~= "open") then
			local target_unit = self.target_unit

			if ScriptUnit.extension(target_unit, "door_system").num_attackers == 0 then
				return BTSmashDoorAction.StateOpening
			end
		end

		return BTSmashDoorAction.StateAttacking
	end
end

BTSmashDoorAction.StateOpening.on_enter = function (self, arg_10_1)
	-- function 10
	local blackboard = arg_10_1.blackboard
	local unit = arg_10_1.unit
	local action = arg_10_1.action
	local target_unit = blackboard.smash_door.target_unit

	self.blackboard = blackboard
	self.unit = unit
	self.action = action
	self.target_unit = target_unit

	local locomotion_extension = blackboard.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())

	local rotation_towards_unit = LocomotionUtils.rotation_towards_unit(unit, target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit)
end

BTSmashDoorAction.StateOpening.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	local blackboard = self.blackboard
	local target_unit = self.target_unit

	if not HEALTH_ALIVE[target_unit] then
		return BTSmashDoorAction.StateMovingToSmartObjectExit
	end

	local extension = ScriptUnit.extension(target_unit, "door_system")

	if not (not extension:is_open() and extension:is_opening()) then
		return BTSmashDoorAction.StateMovingToSmartObjectExit
	elseif not extension:is_open() then
		local unit = self.unit

		extension:interacted_with(unit)

		blackboard.is_opening_door = true
	end
end

BTSmashDoorAction.StateAttacking.on_enter = function (self, arg_12_1)
	-- function 12
	local target_unit = arg_12_1.blackboard.smash_door.target_unit
	local blackboard = arg_12_1.blackboard

	self.blackboard = blackboard
	self.unit = arg_12_1.unit
	self.action = arg_12_1.action
	self.target_unit = target_unit
	self.start_t = arg_12_1.start_t

	blackboard.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local extension = ScriptUnit.extension(target_unit, "door_system")

	extension.num_attackers = extension.num_attackers + 1

	self:attack()
end

BTSmashDoorAction.StateAttacking.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local blackboard = self.blackboard
	local target_unit = self.target_unit
	local extension = ScriptUnit.extension(target_unit, "door_system")

	if not (not HEALTH_ALIVE[target_unit] and not extension:is_open() and extension:is_opening()) then
		if not extension.move_to_exit_when_opened then
			return BTSmashDoorAction.StateMovingToSmartObjectExit
		else
			blackboard.smash_door.done = true
		end
	end

	if not blackboard.attack_finished then
		self:attack()

		if not (not extension.ai_attack_re_eval_time and not (arg_13_2 > extension.ai_attack_re_eval_time + self.start_t)) then
			blackboard.attack_aborted = true
		end
	end
end

BTSmashDoorAction.StateAttacking.on_exit = function (self)
	-- function 14
	local target_unit = self.target_unit
	local extension = ScriptUnit.extension(target_unit, "door_system")

	extension.num_attackers = extension.num_attackers - 1
end

BTSmashDoorAction.StateAttacking.attack = function (self)
	-- function 15
	local target_unit = self.target_unit
	local unit = self.unit
	local blackboard = self.blackboard
	local action = self.action
	local rotation_towards_unit = LocomotionUtils.rotation_towards_unit(unit, target_unit)

	blackboard.locomotion_extension:set_wanted_rotation(rotation_towards_unit)

	if not action.attack_anim then
		local var_15_5 = fn(action.attack_anim)

		Managers.state.network:anim_event(unit, var_15_5)

		blackboard.attack_finished = false
	else
		AiUtils.kill_unit(blackboard.smash_door.target_unit, unit)

		blackboard.attack_finished = true
	end
end

BTSmashDoorAction.StateMovingToSmartObjectExit.on_enter = function (self, arg_16_1)
	-- function 16
	self.blackboard = arg_16_1.blackboard
	self.unit = arg_16_1.unit
	self.exit_pos = arg_16_1.exit_pos
	self.exit_lookat_direction = arg_16_1.exit_lookat_direction

	if not arg_16_1.action.move_anim then
		Managers.state.network:anim_event(arg_16_1.unit, arg_16_1.action.move_anim)
	end
end

BTSmashDoorAction.StateMovingToSmartObjectExit.update = function (self, arg_17_1, arg_17_2)
	-- function 17
	local unit = self.unit
	local blackboard = self.blackboard
	local var_17_2 = POSITION_LOOKUP[unit]
	local unbox = self.exit_pos:unbox()
	local flat = Vector3.flat(unbox - var_17_2)

	if Vector3.length_squared(flat) > 0.010000000000000002 then
		local unbox_2 = self.exit_lookat_direction:unbox()
		local normalize = Vector3.normalize(flat)
		local locomotion_extension = blackboard.locomotion_extension
		local move_speed = blackboard.action.move_speed

		move_speed = move_speed or blackboard.breed.walk_speed

		locomotion_extension:set_wanted_velocity(normalize * move_speed)
		locomotion_extension:set_wanted_rotation(Quaternion.look(unbox_2))
	else
		blackboard.smash_door.done = true
	end
end

BTSmashDoorAction.anim_cb_damage = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	if not arg_18_2.smash_door.target_unit then
		local action = arg_18_2.action

		AiUtils.damage_target(arg_18_2.smash_door.target_unit, arg_18_1, action, action.damage)
	end
end

BTSmashDoorAction.anim_cb_attack_overlap_done = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	if not arg_19_2.smash_door.target_unit then
		local action = arg_19_2.action

		AiUtils.damage_target(arg_19_2.smash_door.target_unit, arg_19_1, action, action.damage)
	end
end
