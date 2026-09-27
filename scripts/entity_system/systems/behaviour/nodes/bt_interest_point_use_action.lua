-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_interest_point_use_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInterestPointUseAction = class(BTInterestPointUseAction, BTNode)

BTInterestPointUseAction.init = function (arg_1_0, ...)
	-- function 1
	BTInterestPointUseAction.super.init(arg_1_0, ...)
end

BTInterestPointUseAction.name = "BTInterestPointUseAction"

BTInterestPointUseAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local get_claim = arg_2_2.system_api.ai_interest_point_system.get_claim(arg_2_2.ip_request_id)
	local point = get_claim.point
	local animations = point.animations
	local animations_n = point.animations_n
	local var_2_4 = animations[math.random(1, animations_n)]

	Managers.state.network:anim_event(arg_2_1, var_2_4)

	arg_2_2.move_state = "idle"

	local duration = get_claim.point_extension.duration

	if not (not duration and not (duration > 0)) then
		arg_2_2.ip_end_time = arg_2_3 + duration * (0.8 + math.random() * 0.4)
	end

	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_2_2.navigation_extension:set_enabled(false)
end

BTInterestPointUseAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local ai_interest_point_system = arg_3_2.system_api.ai_interest_point_system

	if not HEALTH_ALIVE[arg_3_1] then
		ai_interest_point_system.release_claim(arg_3_2.ip_request_id)

		arg_3_2.ip_request_id = nil
	end

	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.ip_end_time = nil

	if arg_3_2.ip_next_request_id == nil or not HEALTH_ALIVE[arg_3_1] then
		if arg_3_4 == "aborted" then
			ai_interest_point_system.release_claim(arg_3_2.ip_next_request_id, arg_3_1)

			arg_3_2.ip_next_request_id = nil
		else
			arg_3_2.ip_request_id = arg_3_2.ip_next_request_id
		end

		arg_3_2.ip_next_request_id = nil
	end
end

BTInterestPointUseAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not script_data.ai_interest_point_debug then
		Debug.text("BTInterestPointApproachAction state = %s", arg_4_2.ip_state)
		QuickDrawer:circle(arg_4_2.ip_root_pos:unbox(), 10, Vector3.up())
	end

	if not (arg_4_2.ip_end_time == nil or not (arg_4_3 >= arg_4_2.ip_end_time)) then
		if arg_4_2.group_blackboard.rats_currently_moving_to_ip > InterestPointSettings.max_rats_currently_moving_to_ip then
			arg_4_2.ip_end_time = arg_4_3 + 1 + math.random() * 2

			return "running"
		end

		local ai_interest_point_system = arg_4_2.system_api.ai_interest_point_system

		if arg_4_2.ip_next_request_id == nil then
			local action_data = self._tree_node.action_data

			arg_4_2.ip_next_request_id = ai_interest_point_system.start_async_claim_request(arg_4_1, arg_4_2.ip_root_pos:unbox(), action_data.min_range, action_data.max_range, arg_4_2.ip_request_id)
		else
			local get_claim = ai_interest_point_system.get_claim(arg_4_2.ip_next_request_id)

			if get_claim.result == "success" then
				return "done"
			elseif get_claim.result == "failed" then
				local get_claim_2 = ai_interest_point_system.get_claim(arg_4_2.ip_request_id)
				local num = 0.8 + math.random() * 0.4
				local num_2 = get_claim_2.point_extension.duration * num

				arg_4_2.ip_end_time = arg_4_2.ip_end_time + num_2

				ai_interest_point_system.release_claim(arg_4_2.ip_next_request_id)

				arg_4_2.ip_next_request_id = nil
			end
		end
	end

	return "running"
end
