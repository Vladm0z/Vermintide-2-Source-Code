-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ethereal_skull_take_off_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTEtherealSkullTakeOffAction = class(BTEtherealSkullTakeOffAction, BTNode)

BTEtherealSkullTakeOffAction.init = function (self, ...)
	-- function 1
	BTEtherealSkullTakeOffAction.super.init(self, ...)
end

BTEtherealSkullTakeOffAction.name = "BTEtherealSkullTakeOffAction"

BTEtherealSkullTakeOffAction.enter = function (self)
	-- function 2
	self._duration = 2
end

BTEtherealSkullTakeOffAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	return
end

BTEtherealSkullTakeOffAction.run = function (self, unit, blackboard, t, dt, bt_name)
	-- function 4
	if not blackboard.take_off_duration then
		blackboard.take_off_duration = t + 2
	end

	if t < blackboard.take_off_duration then
		return "done"
	end

	return "running"
end
