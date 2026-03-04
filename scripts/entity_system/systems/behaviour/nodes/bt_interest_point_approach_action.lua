-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_interest_point_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInterestPointApproachAction = class(BTInterestPointApproachAction, BTNode)
BTInterestPointApproachAction.name = "BTInterestPointApproachAction"

function BTInterestPointApproachAction.init(arg_1_0, ...)
	BTInterestPointApproachAction.super.init(arg_1_0, ...)
end

function BTInterestPointApproachAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.system_api.ai_interest_point_system.get_claim(arg_2_2.ip_request_id).point
	local var_2_1 = Vector3Aux.unbox(var_2_0.position)
	local var_2_2 = arg_2_2.breed
	local var_2_3 = var_2_2.allowed_layers
	local var_2_4 = arg_2_2.navigation_extension

	var_2_4:allow_layer("doors", false)
	var_2_4:allow_layer("planks", false)
	var_2_4:set_layer_cost("jumps", 2 * var_2_3.jumps)
	var_2_4:set_layer_cost("ledges", 2 * var_2_3.ledges)
	var_2_4:set_layer_cost("ledges_with_fence", 2 * var_2_3.ledges_with_fence)
	var_2_4:move_to(var_2_1)
	var_2_4:set_max_speed(var_2_2.passive_walk_speed)

	arg_2_2.ip_state = "moving_to_target"
	arg_2_2.ip_target_position = var_2_0.position
	arg_2_2.ip_target_rotation = var_2_0.rotation

	local var_2_5 = arg_2_2.group_blackboard

	var_2_5.rats_currently_moving_to_ip = var_2_5.rats_currently_moving_to_ip + 1

	Managers.state.network:anim_event(arg_2_1, "move_fwd")

	arg_2_2.move_state = "moving"
end

function BTInterestPointApproachAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.ip_state = nil
	arg_3_2.ip_target_position = nil
	arg_3_2.ip_target_rotation = nil

	local var_3_0 = arg_3_2.breed.allowed_layers
	local var_3_1 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local var_3_2 = arg_3_2.navigation_extension

	var_3_2:allow_layer("doors", true)
	var_3_2:allow_layer("planks", true)
	var_3_2:set_layer_cost("jumps", var_3_0.jumps)
	var_3_2:set_layer_cost("ledges", var_3_0.ledges)
	var_3_2:set_layer_cost("ledges_with_fence", var_3_0.ledges_with_fence)
	var_3_2:set_max_speed(var_3_1)

	if arg_3_4 == "failed" then
		if HEALTH_ALIVE[arg_3_1] then
			arg_3_2.system_api.ai_interest_point_system.release_claim(arg_3_2.ip_request_id)

			arg_3_2.ip_request_id = nil
		end
	elseif arg_3_4 == "aborted" then
		-- block empty
	end

	local var_3_3 = arg_3_2.group_blackboard

	var_3_3.rats_currently_moving_to_ip = var_3_3.rats_currently_moving_to_ip - 1
end

function BTInterestPointApproachAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if script_data.ai_interest_point_debug then
		Debug.text("BTInterestPointApproachAction state = %s", arg_4_2.ip_state)
		QuickDrawer:circle(arg_4_2.ip_root_pos:unbox(), 20, Vector3.up())
	end

	local var_4_0 = arg_4_2.navigation_extension

	if arg_4_2.ip_state == "moving_to_target" and var_4_0:has_reached_destination() then
		var_4_0:set_enabled(false)

		arg_4_2.ip_state = "adjusting_to_target"
	end

	if arg_4_2.ip_state == "adjusting_to_target" then
		local var_4_1 = arg_4_2.locomotion_extension
		local var_4_2 = arg_4_2.ip_target_rotation:unbox()
		local var_4_3 = Vector3Aux.unbox(arg_4_2.ip_target_position)
		local var_4_4 = POSITION_LOOKUP[arg_4_1]

		if Vector3.distance_squared(var_4_4, var_4_3) < 0.0625 then
			var_4_1:teleport_to(var_4_3, var_4_2)
			var_4_1:set_wanted_velocity(Vector3.zero())

			return "done"
		else
			local var_4_5 = Vector3.normalize(var_4_3 - var_4_4)

			var_4_1:set_wanted_velocity(var_4_5 * 2)
			var_4_1:set_wanted_rotation(var_4_2)
		end
	end

	return "running"
end
