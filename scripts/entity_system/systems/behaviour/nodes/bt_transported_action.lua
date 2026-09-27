-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_transported_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTransportedAction = class(BTTransportedAction, BTNode)

BTTransportedAction.init = function (arg_1_0, ...)
	-- function 1
	BTTransportedAction.super.init(arg_1_0, ...)
end

BTTransportedAction.name = "BTTransportedAction"

BTTransportedAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local navigation_extension = arg_2_2.navigation_extension
	local locomotion_extension = arg_2_2.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:set_movement_type("script_driven")
	navigation_extension:set_enabled(false)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false, false, false, true)

	local is_transported = arg_2_2.is_transported
	local transport_slot_id = arg_2_2.transport_slot_id
	local get_ai_slot = is_transported:get_ai_slot(transport_slot_id)

	navigation_extension:set_navbot_position(get_ai_slot)
	locomotion_extension:teleport_to(get_ai_slot)

	local str = "idle"

	Managers.state.network:anim_event(arg_2_1, str)

	arg_2_2.move_state = "idle"
end

BTTransportedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local navigation_extension = arg_3_2.navigation_extension
	local locomotion_extension = arg_3_2.locomotion_extension
	local var_3_2 = POSITION_LOOKUP[arg_3_1]

	var_3_2 = var_3_2 or Unit.local_position(arg_3_1, 0)

	locomotion_extension:teleport_to(var_3_2)
	navigation_extension:set_navbot_position(var_3_2)
	navigation_extension:set_enabled(true)
	navigation_extension:reset_destination(var_3_2)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
end

BTTransportedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	return "running"
end
