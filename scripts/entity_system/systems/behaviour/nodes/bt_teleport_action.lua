-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_teleport_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTeleportAction = class(BTTeleportAction, BTNode)

BTTeleportAction.init = function (arg_1_0, ...)
	-- function 1
	BTTeleportAction.super.init(arg_1_0, ...)
end

BTTeleportAction.name = "BTTeleportAction"

BTTeleportAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local next_smart_object_data = arg_2_2.next_smart_object_data
	local unbox = next_smart_object_data.entrance_pos:unbox()
	local unbox_2 = next_smart_object_data.exit_pos:unbox()

	arg_2_2.smart_object_data = next_smart_object_data.smart_object_data
	arg_2_2.teleport_position = Vector3Box(unbox_2)
	arg_2_2.entrance_position = Vector3Box(unbox)
end

BTTeleportAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.teleport_position = nil
	arg_3_2.entrance_position = nil
	arg_3_2.teleport_timeout = nil

	local navigation_extension = arg_3_2.navigation_extension

	if not navigation_extension:is_using_smart_object() then
		local use_smart_object = navigation_extension:use_smart_object(false)
	end
end

BTTeleportAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if arg_4_2.smart_object_data ~= arg_4_2.next_smart_object_data.smart_object_data then
		return "failed"
	end

	local navigation_extension = arg_4_2.navigation_extension
	local locomotion_extension = arg_4_2.locomotion_extension
	local var_4_2 = POSITION_LOOKUP[arg_4_1]
	local num = arg_4_2.entrance_position:unbox() - var_4_2
	local normalize = Vector3.normalize(navigation_extension:desired_velocity())

	if not (not (Vector3.length(Vector3.flat(normalize)) < 0.05) or not (Vector3.dot(normalize, Vector3.normalize(num)) > 0.99)) then
		local teleport_timeout = arg_4_2.teleport_timeout

		teleport_timeout = teleport_timeout or arg_4_3 + 0.3
		arg_4_2.teleport_timeout = teleport_timeout
	else
		arg_4_2.teleport_timeout = nil
	end

	if not ((num.x + num.y + num.z < 1 or not arg_4_2.teleport_timeout) and not (arg_4_3 > arg_4_2.teleport_timeout)) then
		local unbox = arg_4_2.teleport_position:unbox()

		navigation_extension:set_navbot_position(unbox)
		locomotion_extension:teleport_to(unbox)
		locomotion_extension:set_wanted_velocity(Vector3.zero())

		return "done"
	else
		return "running"
	end
end
