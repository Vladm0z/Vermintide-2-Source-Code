-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_globadier_suicide_stagger_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTGlobadierSuicideStaggerAction = class(BTGlobadierSuicideStaggerAction, BTNode)
BTGlobadierSuicideStaggerAction.name = "BTGlobadierSuicideStaggerAction"

BTGlobadierSuicideStaggerAction.init = function (self, ...)
	-- function 1
	BTGlobadierSuicideStaggerAction.super.init(self, ...)
end

BTGlobadierSuicideStaggerAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local damage_type = "kinetic"
	local damage_direction = Vector3(0, 0, -1)

	AiUtils.kill_unit(unit, nil, nil, damage_type, damage_direction)
end

BTGlobadierSuicideStaggerAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	return
end

BTGlobadierSuicideStaggerAction.run = function (self, unit, blackboard, t, dt)
	-- function 4
	return "done"
end
