-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_hoist_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterHoistAction = class(BTPackMasterHoistAction, BTNode)

BTPackMasterHoistAction.init = function (arg_1_0, ...)
	BTPackMasterHoistAction.super.init(arg_1_0, ...)
end

BTPackMasterHoistAction.name = "BTPackMasterHoistAction"

BTPackMasterHoistAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.hosting_end_time = arg_2_3 + var_2_0.hoist_anim_length

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_hoisting", arg_2_2.drag_target_unit, true, arg_2_1)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, false, false)
	AiUtils.show_polearm(arg_2_1, false)
end

BTPackMasterHoistAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 == "done" then
		arg_3_2.needs_hook = true

		AiUtils.show_polearm(arg_3_1, false)
	else
		if Unit.alive(arg_3_2.drag_target_unit) then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_hoisting", arg_3_2.drag_target_unit, false, arg_3_1)
		end

		AiUtils.show_polearm(arg_3_1, true)

		arg_3_2.target_unit = nil
	end

	arg_3_2.drag_target_unit = nil
	arg_3_2.attack_cooldown = arg_3_3 + arg_3_2.action.cooldown

	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end
end

BTPackMasterHoistAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.drag_target_unit

	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, var_4_0) and not ScriptUnit.extension(var_4_0, "status_system"):is_knocked_down() then
		return "failed"
	end

	if arg_4_3 > arg_4_2.hosting_end_time then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_hanging", var_4_0, true, arg_4_1)

		return "done"
	end

	return "running"
end
