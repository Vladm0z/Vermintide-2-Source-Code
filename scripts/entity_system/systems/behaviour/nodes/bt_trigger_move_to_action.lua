-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_trigger_move_to_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTriggerMoveToAction = class(BTTriggerMoveToAction, BTNode)

function BTTriggerMoveToAction.init(arg_1_0, ...)
	BTTriggerMoveToAction.super.init(arg_1_0, ...)
end

BTTriggerMoveToAction.name = "BTTriggerMoveToAction"

function BTTriggerMoveToAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.trigger_index = arg_2_2.trigger_index or 0

	arg_2_2.navigation_extension:set_enabled(false)

	arg_2_2.skulk_pos = nil
	arg_2_2.skulk_around_dir = nil
end

function BTTriggerMoveToAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)
end

function BTTriggerMoveToAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_2.trigger_index = (arg_4_2.trigger_index + 1) % 8

	local var_4_0 = arg_4_2.trigger_index
	local var_4_1 = math.degrees_to_radians(arg_4_2.trigger_index * 360 / 8)
	local var_4_2 = Vector3(math.sin(var_4_1), math.cos(var_4_1), 0)
	local var_4_3 = POSITION_LOOKUP[arg_4_1]
	local var_4_4 = var_4_3 + var_4_2 * 1

	if not GwNavQueries.raycango(arg_4_2.nav_world, var_4_3, var_4_4, arg_4_2.navigation_extension._traverse_logic) then
		return "running"
	elseif not arg_4_2.trigger_wait then
		arg_4_2.trigger_time = arg_4_3 + 2

		arg_4_2.navigation_extension:move_to(var_4_4)

		arg_4_2.trigger_wait = true
	else
		arg_4_2.navigation_extension:move_to(var_4_3)

		arg_4_2.trigger_wait = nil

		return "done"
	end
end
