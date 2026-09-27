-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_spawn_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleSpawnAction = class(BTTentacleSpawnAction, BTNode)

BTTentacleSpawnAction.init = function (arg_1_0, ...)
	-- function 1
	BTTentacleSpawnAction.super.init(arg_1_0, ...)
end

BTTentacleSpawnAction.name = "BTTentacleSpawnAction"

BTTentacleSpawnAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	if not action_data and not action_data.duration then
		arg_2_2.spawn_finished_t = arg_2_3 + action_data.duration
	end

	local network = Managers.state.network

	if not action_data and not action_data.animation then
		network:anim_event(arg_2_1, action_data.animation)
	end
end

BTTentacleSpawnAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.spawn = false
end

BTTentacleSpawnAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local action = arg_4_2.action

	if not action and not action.duration then
		if arg_4_3 > arg_4_2.spawn_finished_t then
			arg_4_2.spawn_finished_t = nil

			return "done"
		end

		return "running"
	else
		return "done"
	end
end
