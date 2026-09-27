-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterAttackAction = class(BTPackMasterAttackAction, BTNode)

BTPackMasterAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTPackMasterAttackAction.super.init(arg_1_0, ...)
end

BTPackMasterAttackAction.name = "BTPackMasterAttackAction"

BTPackMasterAttackAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.active_node = BTPackMasterAttackAction
	arg_2_2.attacks_done = 0
	arg_2_2.attack_aborted = nil
	arg_2_2.attack_success = nil
	arg_2_2.drag_target_unit = arg_2_2.target_unit

	local has_extension = ScriptUnit.has_extension(arg_2_2.target_unit, "status_system")

	has_extension = has_extension or nil
	arg_2_2.target_unit_status_extension = has_extension

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTPackMasterAttackAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)

	if arg_3_4 ~= "done" then
		arg_3_2.packmaster_target_group = nil

		if not arg_3_2.attack_success and not Unit.alive(arg_3_2.drag_target_unit) then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_3_2.drag_target_unit, false, arg_3_1)
			print("Packmaster weird case")
		end

		arg_3_2.target_unit = nil
		arg_3_2.drag_target_unit = nil

		if not arg_3_5 then
			LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
		end
	end

	arg_3_2.target_unit_status_extension = nil
	arg_3_2.active_node = nil
	arg_3_2.attack_aborted = nil
	arg_3_2.attack_finished = nil
	arg_3_2.attack_success = nil
	arg_3_2.attack_time_ends = nil
	arg_3_2.attack_cooldown = arg_3_3 + arg_3_2.action.cooldown
	arg_3_2.action = nil
	arg_3_2.create_bot_threat_at = nil
end

BTPackMasterAttackAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, arg_4_2.target_unit) then
		return "failed"
	end

	if not arg_4_2.attack_aborted then
		Managers.state.network:anim_event(arg_4_1, "idle")

		return "failed"
	end

	if not arg_4_2.attack_success then
		return "done"
	end

	self:attack(arg_4_1, arg_4_3, arg_4_4, arg_4_2)

	return "running"
end

BTPackMasterAttackAction.attack = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local action = arg_5_4.action
	local locomotion_extension = arg_5_4.locomotion_extension

	if arg_5_4.move_state ~= "attacking" then
		arg_5_4.move_state = "attacking"

		locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, true)
		Managers.state.network:anim_event(arg_5_1, action.attack_anim)

		arg_5_4.attack_time_ends = arg_5_2 + action.attack_anim_duration
		arg_5_4.create_bot_threat_at = arg_5_2 + action.bot_threat_start_time
	end

	local rotation_towards_unit = LocomotionUtils.rotation_towards_unit(arg_5_1, arg_5_4.target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit)

	if not (not arg_5_4.create_bot_threat_at and not (arg_5_2 > arg_5_4.create_bot_threat_at)) then
		self:create_bot_threat(arg_5_1, arg_5_4, arg_5_2)

		arg_5_4.create_bot_threat_at = nil
	end

	if not (not arg_5_4.attack_time_ends and not (arg_5_2 > arg_5_4.attack_time_ends)) then
		arg_5_4.attack_aborted = true
	end
end

BTPackMasterAttackAction.attack_success = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not (not arg_6_2.active_node and arg_6_2.active_node ~= BTPackMasterAttackAction) then
		local target_unit = arg_6_2.target_unit
		local target_unit_status_extension = arg_6_2.target_unit_status_extension

		if not target_unit_status_extension and target_unit_status_extension:get_is_dodging() and not target_unit_status_extension:is_invisible() then
			local var_6_2 = POSITION_LOOKUP[arg_6_1]
			local var_6_3 = POSITION_LOOKUP[target_unit]
			local normalize = Vector3.normalize(Vector3.flat(var_6_3 - var_6_2))
			local forward = Quaternion.forward(Unit.local_rotation(arg_6_1, 0))
			local dot = Vector3.dot(normalize, forward)
			local acos = math.acos(dot)
			local distance_squared = Vector3.distance_squared(var_6_2, var_6_3)

			if not (not (math.radians_to_degrees(acos) <= arg_6_2.action.dodge_angle) or not (distance_squared < arg_6_2.action.dodge_distance * arg_6_2.action.dodge_distance)) then
				arg_6_2.attack_success = PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_6_2.physics_world, arg_6_1, target_unit)
			else
				arg_6_2.attack_success = false

				QuestSettings.check_pack_master_dodge(target_unit)
			end
		else
			arg_6_2.attack_success = PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_6_2.physics_world, arg_6_1, target_unit)
		end

		local has_extension = ScriptUnit.has_extension(arg_6_2.target_unit, "first_person_system")

		if not arg_6_2.attack_success and not has_extension then
			has_extension:animation_event("shake_get_hit")
		end
	end
end

BTPackMasterAttackAction.create_bot_threat = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local has_extension = ScriptUnit.has_extension(arg_7_2.target_unit, "first_person_system")

	if not has_extension then
		local current_position = has_extension:current_position()
		local current_rotation = has_extension:current_rotation()
		local normalize = Vector3.normalize(current_position - POSITION_LOOKUP[arg_7_1])
		local forward = Quaternion.forward(current_rotation)
		local dot = Vector3.dot(forward, normalize)

		if not (not (dot >= 0.55) or dot <= 1) then
			local action = arg_7_2.action
			local var_7_7 = POSITION_LOOKUP[arg_7_1]
			local num = POSITION_LOOKUP[arg_7_2.target_unit] - var_7_7
			local length = Vector3.length(num)
			local dodge_distance = action.dodge_distance
			local calculate_oobb, var_7_12, var_7_13 = AiUtils.calculate_oobb(length + 2, var_7_7, Quaternion.look(num), 2, dodge_distance)
			local num_2 = arg_7_2.attack_time_ends - arg_7_3

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(calculate_oobb, "oobb", var_7_13, var_7_12, num_2, "Packmaster")
		end
	end
end
