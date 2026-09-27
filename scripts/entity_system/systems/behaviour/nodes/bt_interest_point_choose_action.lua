-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_interest_point_choose_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInterestPointChooseAction = class(BTInterestPointChooseAction, BTNode)
BTInterestPointChooseAction.name = "BTInterestPointChooseAction"

BTInterestPointChooseAction.init = function (arg_1_0, ...)
	-- function 1
	BTInterestPointChooseAction.super.init(arg_1_0, ...)
end

BTInterestPointChooseAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local ai_interest_point_system = arg_2_2.system_api.ai_interest_point_system

	if arg_2_2.ip_request_id == nil then
		if arg_2_2.ip_root_pos == nil then
			arg_2_2.ip_root_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
		end

		local action_data = self._tree_node.action_data
		local unbox = arg_2_2.ip_root_pos:unbox()
		local num = 0
		local max_range = action_data.max_range

		arg_2_2.ip_request_id = ai_interest_point_system.start_async_claim_request(arg_2_1, unbox, num, max_range)
	end
end

BTInterestPointChooseAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 == "failed" or arg_3_4 == "aborted" or not HEALTH_ALIVE[arg_3_1] then
		arg_3_2.system_api.ai_interest_point_system.release_claim(arg_3_2.ip_request_id, arg_3_1)

		arg_3_2.ip_request_id = nil
		arg_3_2.ignore_interest_points = true
	end
end

BTInterestPointChooseAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local ip_request_id = arg_4_2.ip_request_id
	local get_claim = arg_4_2.system_api.ai_interest_point_system.get_claim(ip_request_id)

	if get_claim.result == nil then
		return "running"
	elseif get_claim.result == "failed" then
		return "failed"
	else
		return "done"
	end
end
