-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterAttackAction = class(BTPackMasterAttackAction, BTNode)

BTPackMasterAttackAction.init = function (arg_1_0, ...)
	BTPackMasterAttackAction.super.init(arg_1_0, ...)
end

BTPackMasterAttackAction.name = "BTPackMasterAttackAction"

BTPackMasterAttackAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.active_node = BTPackMasterAttackAction
	arg_2_2.attacks_done = 0
	arg_2_2.attack_aborted = nil
	arg_2_2.attack_success = nil
	arg_2_2.drag_target_unit = arg_2_2.target_unit
	arg_2_2.target_unit_status_extension = ScriptUnit.has_extension(arg_2_2.target_unit, "status_system") or nil

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTPackMasterAttackAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)

	if arg_3_4 ~= "done" then
		arg_3_2.packmaster_target_group = nil

		if arg_3_2.attack_success and Unit.alive(arg_3_2.drag_target_unit) then
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

BTPackMasterAttackAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, arg_4_2.target_unit) then
		return "failed"
	end

	if arg_4_2.attack_aborted then
		Managers.state.network:anim_event(arg_4_1, "idle")

		return "failed"
	end

	if arg_4_2.attack_success then
		return "done"
	end

	arg_4_0:attack(arg_4_1, arg_4_3, arg_4_4, arg_4_2)

	return "running"
end

BTPackMasterAttackAction.attack = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_4.action
	local var_5_1 = arg_5_4.locomotion_extension

	if arg_5_4.move_state ~= "attacking" then
		arg_5_4.move_state = "attacking"

		var_5_1:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, true)
		Managers.state.network:anim_event(arg_5_1, var_5_0.attack_anim)

		arg_5_4.attack_time_ends = arg_5_2 + var_5_0.attack_anim_duration
		arg_5_4.create_bot_threat_at = arg_5_2 + var_5_0.bot_threat_start_time
	end

	local var_5_2 = LocomotionUtils.rotation_towards_unit(arg_5_1, arg_5_4.target_unit)

	var_5_1:set_wanted_rotation(var_5_2)

	if arg_5_4.create_bot_threat_at and arg_5_2 > arg_5_4.create_bot_threat_at then
		arg_5_0:create_bot_threat(arg_5_1, arg_5_4, arg_5_2)

		arg_5_4.create_bot_threat_at = nil
	end

	if not arg_5_4.attack_time_ends or arg_5_2 > arg_5_4.attack_time_ends then
		arg_5_4.attack_aborted = true
	end
end

BTPackMasterAttackAction.attack_success = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_2.active_node and arg_6_2.active_node == BTPackMasterAttackAction then
		local var_6_0 = arg_6_2.target_unit
		local var_6_1 = arg_6_2.target_unit_status_extension

		if var_6_1 and (var_6_1:get_is_dodging() or var_6_1:is_invisible()) then
			local var_6_2 = POSITION_LOOKUP[arg_6_1]
			local var_6_3 = POSITION_LOOKUP[var_6_0]
			local var_6_4 = Vector3.normalize(Vector3.flat(var_6_3 - var_6_2))
			local var_6_5 = Quaternion.forward(Unit.local_rotation(arg_6_1, 0))
			local var_6_6 = Vector3.dot(var_6_4, var_6_5)
			local var_6_7 = math.acos(var_6_6)
			local var_6_8 = Vector3.distance_squared(var_6_2, var_6_3)

			if math.radians_to_degrees(var_6_7) <= arg_6_2.action.dodge_angle and var_6_8 < arg_6_2.action.dodge_distance * arg_6_2.action.dodge_distance then
				arg_6_2.attack_success = PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_6_2.physics_world, arg_6_1, var_6_0)
			else
				arg_6_2.attack_success = false

				QuestSettings.check_pack_master_dodge(var_6_0)
			end
		else
			arg_6_2.attack_success = PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_6_2.physics_world, arg_6_1, var_6_0)
		end

		local var_6_9 = ScriptUnit.has_extension(arg_6_2.target_unit, "first_person_system")

		if arg_6_2.attack_success and var_6_9 then
			var_6_9:animation_event("shake_get_hit")
		end
	end
end

BTPackMasterAttackAction.create_bot_threat = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = ScriptUnit.has_extension(arg_7_2.target_unit, "first_person_system")

	if var_7_0 then
		local var_7_1 = var_7_0:current_position()
		local var_7_2 = var_7_0:current_rotation()
		local var_7_3 = Vector3.normalize(var_7_1 - POSITION_LOOKUP[arg_7_1])
		local var_7_4 = Quaternion.forward(var_7_2)
		local var_7_5 = Vector3.dot(var_7_4, var_7_3)

		if not (var_7_5 >= 0.55 and var_7_5 <= 1) then
			local var_7_6 = arg_7_2.action
			local var_7_7 = POSITION_LOOKUP[arg_7_1]
			local var_7_8 = POSITION_LOOKUP[arg_7_2.target_unit] - var_7_7
			local var_7_9 = Vector3.length(var_7_8)
			local var_7_10 = var_7_6.dodge_distance
			local var_7_11, var_7_12, var_7_13 = AiUtils.calculate_oobb(var_7_9 + 2, var_7_7, Quaternion.look(var_7_8), 2, var_7_10)
			local var_7_14 = arg_7_2.attack_time_ends - arg_7_3

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_7_11, "oobb", var_7_13, var_7_12, var_7_14, "Packmaster")
		end
	end
end
