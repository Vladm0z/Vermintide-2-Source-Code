-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_transported_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTransportedAction = class(BTTransportedAction, BTNode)

BTTransportedAction.init = function (arg_1_0, ...)
	BTTransportedAction.super.init(arg_1_0, ...)
end

BTTransportedAction.name = "BTTransportedAction"

BTTransportedAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_2.action = arg_2_0._tree_node.action_data

	local var_2_0 = arg_2_2.navigation_extension
	local var_2_1 = arg_2_2.locomotion_extension

	var_2_1:set_wanted_velocity(Vector3.zero())
	var_2_1:set_movement_type("script_driven")
	var_2_0:set_enabled(false)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false, false, false, true)

	local var_2_2 = arg_2_2.is_transported
	local var_2_3 = arg_2_2.transport_slot_id
	local var_2_4 = var_2_2:get_ai_slot(var_2_3)

	var_2_0:set_navbot_position(var_2_4)
	var_2_1:teleport_to(var_2_4)

	local var_2_5 = "idle"

	Managers.state.network:anim_event(arg_2_1, var_2_5)

	arg_2_2.move_state = "idle"
end

BTTransportedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_2.navigation_extension
	local var_3_1 = arg_3_2.locomotion_extension
	local var_3_2 = POSITION_LOOKUP[arg_3_1] or Unit.local_position(arg_3_1, 0)

	var_3_1:teleport_to(var_3_2)
	var_3_0:set_navbot_position(var_3_2)
	var_3_0:set_enabled(true)
	var_3_0:reset_destination(var_3_2)
	var_3_1:set_movement_type("snap_to_navmesh")
	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
end

BTTransportedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	return "running"
end
