-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dummy_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDummyIdleAction = class(BTDummyIdleAction, BTNode)

function BTDummyIdleAction.init(arg_1_0, ...)
	BTDummyIdleAction.super.init(arg_1_0, ...)
end

BTDummyIdleAction.name = "BTDummyIdleAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTDummyIdleAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Managers.state.network
	local var_3_1 = "idle"
	local var_3_2 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_2

	if var_3_2 and var_3_2.idle_animation then
		var_3_1 = var_0_0(var_3_2.idle_animation)
	end

	if arg_3_2.move_state ~= "idle" and not var_3_2.no_anim then
		var_3_0:anim_event(arg_3_1, var_3_1)

		arg_3_2.move_state = "idle"
	end
end

function BTDummyIdleAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	return
end

local var_0_1 = Unit.alive

function BTDummyIdleAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	return "running"
end
