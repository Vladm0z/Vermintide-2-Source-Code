-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_follow_player_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFollowPlayerAction = class(BTFollowPlayerAction, BTNode)

BTFollowPlayerAction.init = function (arg_1_0, ...)
	BTFollowPlayerAction.super.init(arg_1_0, ...)
end

BTFollowPlayerAction.name = "BTFollowPlayerAction"

BTFollowPlayerAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.locomotion_extension:enter_state_combat(arg_2_2, arg_2_3)
end

BTFollowPlayerAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

BTFollowPlayerAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not Unit.alive(arg_4_2.target_unit) then
		return
	end

	return arg_4_0
end

BTFollowPlayerAction.exit_running = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_2.locomotion_extension:enter_state_onground(arg_5_2, arg_5_3)
end
