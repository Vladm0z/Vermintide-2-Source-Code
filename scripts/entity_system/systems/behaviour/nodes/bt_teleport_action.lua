-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_teleport_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTeleportAction = class(BTTeleportAction, BTNode)

function BTTeleportAction.init(arg_1_0, ...)
	BTTeleportAction.super.init(arg_1_0, ...)
end

BTTeleportAction.name = "BTTeleportAction"

function BTTeleportAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local var_2_1 = arg_2_2.next_smart_object_data
	local var_2_2 = var_2_1.entrance_pos:unbox()
	local var_2_3 = var_2_1.exit_pos:unbox()

	arg_2_2.smart_object_data = var_2_1.smart_object_data
	arg_2_2.teleport_position = Vector3Box(var_2_3)
	arg_2_2.entrance_position = Vector3Box(var_2_2)
end

function BTTeleportAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.teleport_position = nil
	arg_3_2.entrance_position = nil
	arg_3_2.teleport_timeout = nil

	local var_3_0 = arg_3_2.navigation_extension

	if var_3_0:is_using_smart_object() then
		local var_3_1 = var_3_0:use_smart_object(false)
	end
end

function BTTeleportAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.smart_object_data ~= arg_4_2.next_smart_object_data.smart_object_data then
		return "failed"
	end

	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = arg_4_2.locomotion_extension
	local var_4_2 = POSITION_LOOKUP[arg_4_1]
	local var_4_3 = arg_4_2.entrance_position:unbox() - var_4_2
	local var_4_4 = Vector3.normalize(var_4_0:desired_velocity())

	if Vector3.length(Vector3.flat(var_4_4)) < 0.05 and Vector3.dot(var_4_4, Vector3.normalize(var_4_3)) > 0.99 then
		arg_4_2.teleport_timeout = arg_4_2.teleport_timeout or arg_4_3 + 0.3
	else
		arg_4_2.teleport_timeout = nil
	end

	if var_4_3.x + var_4_3.y + var_4_3.z < 1 or arg_4_2.teleport_timeout and arg_4_3 > arg_4_2.teleport_timeout then
		local var_4_5 = arg_4_2.teleport_position:unbox()

		var_4_0:set_navbot_position(var_4_5)
		var_4_1:teleport_to(var_4_5)
		var_4_1:set_wanted_velocity(Vector3.zero())

		return "done"
	else
		return "running"
	end
end
