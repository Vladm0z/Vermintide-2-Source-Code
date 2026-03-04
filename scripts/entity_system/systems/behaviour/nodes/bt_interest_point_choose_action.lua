-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_interest_point_choose_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInterestPointChooseAction = class(BTInterestPointChooseAction, BTNode)
BTInterestPointChooseAction.name = "BTInterestPointChooseAction"

function BTInterestPointChooseAction.init(arg_1_0, ...)
	BTInterestPointChooseAction.super.init(arg_1_0, ...)
end

function BTInterestPointChooseAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.system_api.ai_interest_point_system

	if arg_2_2.ip_request_id == nil then
		if arg_2_2.ip_root_pos == nil then
			arg_2_2.ip_root_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
		end

		local var_2_1 = arg_2_0._tree_node.action_data
		local var_2_2 = arg_2_2.ip_root_pos:unbox()
		local var_2_3 = 0
		local var_2_4 = var_2_1.max_range

		arg_2_2.ip_request_id = var_2_0.start_async_claim_request(arg_2_1, var_2_2, var_2_3, var_2_4)
	end
end

function BTInterestPointChooseAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if (arg_3_4 == "failed" or arg_3_4 == "aborted") and HEALTH_ALIVE[arg_3_1] then
		arg_3_2.system_api.ai_interest_point_system.release_claim(arg_3_2.ip_request_id, arg_3_1)

		arg_3_2.ip_request_id = nil
		arg_3_2.ignore_interest_points = true
	end
end

function BTInterestPointChooseAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.ip_request_id
	local var_4_1 = arg_4_2.system_api.ai_interest_point_system.get_claim(var_4_0)

	if var_4_1.result == nil then
		return "running"
	elseif var_4_1.result == "failed" then
		return "failed"
	else
		return "done"
	end
end
