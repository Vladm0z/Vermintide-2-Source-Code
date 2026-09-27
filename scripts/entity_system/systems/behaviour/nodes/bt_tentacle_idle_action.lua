-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleIdleAction = class(BTTentacleIdleAction, BTNode)

BTTentacleIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTTentacleIdleAction.super.init(arg_1_0, ...)
end

BTTentacleIdleAction.name = "BTTentacleIdleAction"

BTTentacleIdleAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local next_attack_time = arg_2_2.next_attack_time

	next_attack_time = next_attack_time or arg_2_3 + 0.5
	arg_2_2.next_attack_time = next_attack_time
end

BTTentacleIdleAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

BTTentacleIdleAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local tentacle_data = arg_4_2.tentacle_data
	local current_length = tentacle_data.current_length

	if current_length > 0 then
		local breed = arg_4_2.breed

		tentacle_data.current_length = tentacle_data.current_length - arg_4_4 * breed.fail_retract_speed

		arg_4_2.tentacle_spline_extension:set_reach_dist(current_length)
	end

	local current_unit = arg_4_2.current_unit

	current_unit = current_unit or arg_4_2.target_unit

	if not Unit.alive(current_unit) then
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
