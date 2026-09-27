-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dummy_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDummyIdleAction = class(BTDummyIdleAction, BTNode)

BTDummyIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTDummyIdleAction.super.init(arg_1_0, ...)
end

BTDummyIdleAction.name = "BTDummyIdleAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTDummyIdleAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local network = Managers.state.network
	local str = "idle"
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data

	if not action_data and not action_data.idle_animation then
		str = fn(action_data.idle_animation)
	end

	if not (arg_3_2.move_state == "idle" or action_data.no_anim) then
		network:anim_event(arg_3_1, str)

		arg_3_2.move_state = "idle"
	end
end

BTDummyIdleAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	return
end

local alive = Unit.alive

BTDummyIdleAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	return "running"
end
