-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_interest_point_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInterestPointApproachAction = class(BTInterestPointApproachAction, BTNode)
BTInterestPointApproachAction.name = "BTInterestPointApproachAction"

BTInterestPointApproachAction.init = function (arg_1_0, ...)
	-- function 1
	BTInterestPointApproachAction.super.init(arg_1_0, ...)
end

BTInterestPointApproachAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local point = arg_2_2.system_api.ai_interest_point_system.get_claim(arg_2_2.ip_request_id).point
	local unbox = Vector3Aux.unbox(point.position)
	local breed = arg_2_2.breed
	local allowed_layers = breed.allowed_layers
	local navigation_extension = arg_2_2.navigation_extension

	navigation_extension:allow_layer("doors", false)
	navigation_extension:allow_layer("planks", false)
	navigation_extension:set_layer_cost("jumps", 2 * allowed_layers.jumps)
	navigation_extension:set_layer_cost("ledges", 2 * allowed_layers.ledges)
	navigation_extension:set_layer_cost("ledges_with_fence", 2 * allowed_layers.ledges_with_fence)
	navigation_extension:move_to(unbox)
	navigation_extension:set_max_speed(breed.passive_walk_speed)

	arg_2_2.ip_state = "moving_to_target"
	arg_2_2.ip_target_position = point.position
	arg_2_2.ip_target_rotation = point.rotation

	local group_blackboard = arg_2_2.group_blackboard

	group_blackboard.rats_currently_moving_to_ip = group_blackboard.rats_currently_moving_to_ip + 1

	Managers.state.network:anim_event(arg_2_1, "move_fwd")

	arg_2_2.move_state = "moving"
end

BTInterestPointApproachAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.ip_state = nil
	arg_3_2.ip_target_position = nil
	arg_3_2.ip_target_rotation = nil

	local allowed_layers = arg_3_2.breed.allowed_layers
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:allow_layer("doors", true)
	navigation_extension:allow_layer("planks", true)
	navigation_extension:set_layer_cost("jumps", allowed_layers.jumps)
	navigation_extension:set_layer_cost("ledges", allowed_layers.ledges)
	navigation_extension:set_layer_cost("ledges_with_fence", allowed_layers.ledges_with_fence)
	navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_3_4 == "failed" then
		if not HEALTH_ALIVE[arg_3_1] then
			arg_3_2.system_api.ai_interest_point_system.release_claim(arg_3_2.ip_request_id)

			arg_3_2.ip_request_id = nil
		end
	elseif arg_3_4 == "aborted" then
		-- Nothing
	end

	local group_blackboard = arg_3_2.group_blackboard

	group_blackboard.rats_currently_moving_to_ip = group_blackboard.rats_currently_moving_to_ip - 1
end

BTInterestPointApproachAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not script_data.ai_interest_point_debug then
		Debug.text("BTInterestPointApproachAction state = %s", arg_4_2.ip_state)
		QuickDrawer:circle(arg_4_2.ip_root_pos:unbox(), 20, Vector3.up())
	end

	local navigation_extension = arg_4_2.navigation_extension

	if arg_4_2.ip_state ~= "moving_to_target" or not navigation_extension:has_reached_destination() then
		navigation_extension:set_enabled(false)

		arg_4_2.ip_state = "adjusting_to_target"
	end

	if arg_4_2.ip_state == "adjusting_to_target" then
		local locomotion_extension = arg_4_2.locomotion_extension
		local unbox = arg_4_2.ip_target_rotation:unbox()
		local unbox_2 = Vector3Aux.unbox(arg_4_2.ip_target_position)
		local var_4_4 = POSITION_LOOKUP[arg_4_1]

		if Vector3.distance_squared(var_4_4, unbox_2) < 0.0625 then
			locomotion_extension:teleport_to(unbox_2, unbox)
			locomotion_extension:set_wanted_velocity(Vector3.zero())

			return "done"
		else
			local normalize = Vector3.normalize(unbox_2 - var_4_4)

			locomotion_extension:set_wanted_velocity(normalize * 2)
			locomotion_extension:set_wanted_rotation(unbox)
		end
	end

	return "running"
end
