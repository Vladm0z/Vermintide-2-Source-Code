-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_move_to_ranged_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMoveToRangedPositionAction = class(BTMoveToRangedPositionAction, BTNode)

function BTMoveToRangedPositionAction.init(arg_1_0, ...)
	BTMoveToRangedPositionAction.super.init(arg_1_0, ...)
end

BTMoveToRangedPositionAction.name = "BTMoveToRangedPositionAction"

function BTMoveToRangedPositionAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.move_state = "moving"

	local var_2_1 = arg_2_2.navigation_extension
	local var_2_2 = var_2_0.move_animation

	Managers.state.network:anim_event(arg_2_1, var_2_2)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_2_1, false)

	arg_2_2.next_t_to_evaluate = arg_2_3 + 0.5

	local var_2_3 = var_2_1._nav_bot

	GwNavBot.set_use_avoidance(var_2_3, true)
end

function BTMoveToRangedPositionAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.ranged_position = nil
	arg_3_2.action = nil
	arg_3_2.next_t_to_evaluate = nil

	local var_3_0 = arg_3_2.navigation_extension._nav_bot

	GwNavBot.set_use_avoidance(var_3_0, false)
end

function BTMoveToRangedPositionAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not Unit.alive(arg_4_2.target_unit) then
		return "done"
	end

	local var_4_0 = arg_4_2.ranged_position:unbox()

	if Vector3.distance(POSITION_LOOKUP[arg_4_1], var_4_0) < 1.5 then
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

		return "done"
	end

	if arg_4_3 > arg_4_2.next_t_to_evaluate then
		arg_4_2.next_t_to_evaluate = arg_4_3 + Math.random_range(1.2, 2)

		return "running", "evaluate"
	end

	return "running"
end
