-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_spawn_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleSpawnAction = class(BTTentacleSpawnAction, BTNode)

function BTTentacleSpawnAction.init(arg_1_0, ...)
	BTTentacleSpawnAction.super.init(arg_1_0, ...)
end

BTTentacleSpawnAction.name = "BTTentacleSpawnAction"

function BTTentacleSpawnAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	if var_2_0 and var_2_0.duration then
		arg_2_2.spawn_finished_t = arg_2_3 + var_2_0.duration
	end

	local var_2_1 = Managers.state.network

	if var_2_0 and var_2_0.animation then
		var_2_1:anim_event(arg_2_1, var_2_0.animation)
	end
end

function BTTentacleSpawnAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.spawn = false
end

function BTTentacleSpawnAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.action

	if var_4_0 and var_4_0.duration then
		if arg_4_3 > arg_4_2.spawn_finished_t then
			arg_4_2.spawn_finished_t = nil

			return "done"
		end

		return "running"
	else
		return "done"
	end
end
