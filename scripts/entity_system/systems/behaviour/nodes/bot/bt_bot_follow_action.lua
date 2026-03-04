-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotFollowAction = class(BTBotFollowAction, BTNode)

function BTBotFollowAction.init(arg_1_0, ...)
	BTBotFollowAction.super.init(arg_1_0, ...)
end

BTBotFollowAction.name = "BTBotFollowAction"

function BTBotFollowAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.has_teleported = false

	local var_2_0 = arg_2_0._tree_node.action_data.goal_selection

	arg_2_2.follow.goal_selection_func = var_2_0
	arg_2_2.follow.needs_target_position_refresh = true
end

function BTBotFollowAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.follow.goal_selection_func = nil
end

function BTBotFollowAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	return "running", "evaluate"
end
