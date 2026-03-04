-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_nurgling_wait_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterNurglingWaitAction = class(BTCritterNurglingWaitAction, BTNode)

BTCritterNurglingWaitAction.init = function (arg_1_0, ...)
	BTCritterNurglingWaitAction.super.init(arg_1_0, ...)
end

BTCritterNurglingWaitAction.name = "BTCritterNurglingWaitAction"

BTCritterNurglingWaitAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.exit_wait_time = arg_2_3 + Math.random_range(var_2_0.wait_time_min, var_2_0.wait_time_max)

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:start_idle_animation(arg_2_1, arg_2_2)

		arg_2_2.move_state = "idle"
	end
end

BTCritterNurglingWaitAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.exit_wait_time = nil
end

BTCritterNurglingWaitAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 > arg_4_2.exit_wait_time then
		return "done"
	end

	return "running"
end

BTCritterNurglingWaitAction.start_idle_animation = function (arg_5_0, arg_5_1, arg_5_2)
	Managers.state.network:anim_event(arg_5_1, "idle")

	arg_5_2.move_state = "idle"
end
