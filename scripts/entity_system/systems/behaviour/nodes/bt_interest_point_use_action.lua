-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_interest_point_use_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInterestPointUseAction = class(BTInterestPointUseAction, BTNode)

function BTInterestPointUseAction.init(arg_1_0, ...)
	BTInterestPointUseAction.super.init(arg_1_0, ...)
end

BTInterestPointUseAction.name = "BTInterestPointUseAction"

function BTInterestPointUseAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.system_api.ai_interest_point_system.get_claim(arg_2_2.ip_request_id)
	local var_2_1 = var_2_0.point
	local var_2_2 = var_2_1.animations
	local var_2_3 = var_2_1.animations_n
	local var_2_4 = var_2_2[math.random(1, var_2_3)]

	Managers.state.network:anim_event(arg_2_1, var_2_4)

	arg_2_2.move_state = "idle"

	local var_2_5 = var_2_0.point_extension.duration

	if var_2_5 and var_2_5 > 0 then
		arg_2_2.ip_end_time = arg_2_3 + var_2_5 * (0.8 + math.random() * 0.4)
	end

	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_2_2.navigation_extension:set_enabled(false)
end

function BTInterestPointUseAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_2.system_api.ai_interest_point_system

	if HEALTH_ALIVE[arg_3_1] then
		var_3_0.release_claim(arg_3_2.ip_request_id)

		arg_3_2.ip_request_id = nil
	end

	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.ip_end_time = nil

	if arg_3_2.ip_next_request_id ~= nil and HEALTH_ALIVE[arg_3_1] then
		if arg_3_4 == "aborted" then
			var_3_0.release_claim(arg_3_2.ip_next_request_id, arg_3_1)

			arg_3_2.ip_next_request_id = nil
		else
			arg_3_2.ip_request_id = arg_3_2.ip_next_request_id
		end

		arg_3_2.ip_next_request_id = nil
	end
end

function BTInterestPointUseAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if script_data.ai_interest_point_debug then
		Debug.text("BTInterestPointApproachAction state = %s", arg_4_2.ip_state)
		QuickDrawer:circle(arg_4_2.ip_root_pos:unbox(), 10, Vector3.up())
	end

	if arg_4_2.ip_end_time ~= nil and arg_4_3 >= arg_4_2.ip_end_time then
		if arg_4_2.group_blackboard.rats_currently_moving_to_ip > InterestPointSettings.max_rats_currently_moving_to_ip then
			arg_4_2.ip_end_time = arg_4_3 + 1 + math.random() * 2

			return "running"
		end

		local var_4_0 = arg_4_2.system_api.ai_interest_point_system

		if arg_4_2.ip_next_request_id == nil then
			local var_4_1 = arg_4_0._tree_node.action_data

			arg_4_2.ip_next_request_id = var_4_0.start_async_claim_request(arg_4_1, arg_4_2.ip_root_pos:unbox(), var_4_1.min_range, var_4_1.max_range, arg_4_2.ip_request_id)
		else
			local var_4_2 = var_4_0.get_claim(arg_4_2.ip_next_request_id)

			if var_4_2.result == "success" then
				return "done"
			elseif var_4_2.result == "failed" then
				local var_4_3 = var_4_0.get_claim(arg_4_2.ip_request_id)
				local var_4_4 = 0.8 + math.random() * 0.4
				local var_4_5 = var_4_3.point_extension.duration * var_4_4

				arg_4_2.ip_end_time = arg_4_2.ip_end_time + var_4_5

				var_4_0.release_claim(arg_4_2.ip_next_request_id)

				arg_4_2.ip_next_request_id = nil
			end
		end
	end

	return "running"
end
