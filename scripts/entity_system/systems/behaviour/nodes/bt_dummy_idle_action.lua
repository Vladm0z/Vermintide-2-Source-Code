-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dummy_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDummyIdleAction = class(BTDummyIdleAction, BTNode)

BTDummyIdleAction.init = function (self, ...)
	-- function 1
	BTDummyIdleAction.super.init(self, ...)
end

BTDummyIdleAction.name = "BTDummyIdleAction"

local function randomize(event)
	-- function 2
	if type(event) == "table" then
		return event[Math.random(1, #event)]
	else
		return event
	end
end

BTDummyIdleAction.enter = function (self, unit, blackboard, t)
	-- function 3
	local network_manager = Managers.state.network
	local animation = "idle"
	local action = self._tree_node.action_data

	blackboard.action = action

	if action and action.idle_animation then
		animation = randomize(action.idle_animation)
	end

	if blackboard.move_state ~= "idle" and not action.no_anim then
		network_manager:anim_event(unit, animation)

		blackboard.move_state = "idle"
	end
end

BTDummyIdleAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 4
	return
end

local Unit_alive = Unit.alive

BTDummyIdleAction.run = function (self, unit, blackboard, t, dt)
	-- function 5
	return "running"
end
