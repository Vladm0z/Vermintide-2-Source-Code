-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_nil_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNilAction = class(BTNilAction, BTNode)

BTNilAction.init = function (self, ...)
	-- function 1
	BTNilAction.super.init(self, ...)
end

BTNilAction.name = "BTNilAction"

BTNilAction.enter = function (self)
	-- function 2
	return
end

BTNilAction.leave = function (self)
	-- function 3
	return
end

BTNilAction.run = function (self, unit, blackboard, t, dt, bt_name)
	-- function 4
	return "running"
end
