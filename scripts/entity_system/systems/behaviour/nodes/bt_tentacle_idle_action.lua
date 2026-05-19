-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleIdleAction = class(BTTentacleIdleAction, BTNode)

function BTTentacleIdleAction.init(arg_1_0, ...)
	BTTentacleIdleAction.super.init(arg_1_0, ...)
end

BTTentacleIdleAction.name = "BTTentacleIdleAction"

function BTTentacleIdleAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.next_attack_time = arg_2_2.next_attack_time or arg_2_3 + 0.5
end

function BTTentacleIdleAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function BTTentacleIdleAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_2.tentacle_data
	local var_4_1 = var_4_0.current_length

	if var_4_1 > 0 then
		local var_4_2 = arg_4_2.breed

		var_4_0.current_length = var_4_0.current_length - arg_4_4 * var_4_2.fail_retract_speed

		arg_4_2.tentacle_spline_extension:set_reach_dist(var_4_1)
	end

	local var_4_3 = arg_4_2.current_unit or arg_4_2.target_unit

	if not Unit.alive(var_4_3) then
		return "running"
	end

	if arg_4_3 < arg_4_2.next_attack_time then
		return "running"
	end

	if arg_4_2.target_dist < 20 then
		arg_4_2.tentacle_satisfied = false

		return "done"
	else
		arg_4_2.next_attack_time = arg_4_3 + 1 + math.random()
	end

	return "running"
end
