-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_follow_player_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFollowPlayerAction = class(BTFollowPlayerAction, BTNode)

BTFollowPlayerAction.init = function (self, ...)
	-- function 1
	BTFollowPlayerAction.super.init(self, ...)
end

BTFollowPlayerAction.name = "BTFollowPlayerAction"

BTFollowPlayerAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local locomotion = blackboard.locomotion_extension

	locomotion:enter_state_combat(blackboard, t)
end

BTFollowPlayerAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	return
end

BTFollowPlayerAction.run = function (self, unit, blackboard, t)
	-- function 4
	if not Unit.alive(blackboard.target_unit) then
		return
	end

	return self
end

BTFollowPlayerAction.exit_running = function (self, unit, blackboard, t)
	-- function 5
	local locomotion = blackboard.locomotion_extension

	locomotion:enter_state_onground(blackboard, t)
end
