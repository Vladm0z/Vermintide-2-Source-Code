-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleIdleAction = class(BTTentacleIdleAction, BTNode)

BTTentacleIdleAction.init = function (self, ...)
	-- function 1
	BTTentacleIdleAction.super.init(self, ...)
end

BTTentacleIdleAction.name = "BTTentacleIdleAction"

BTTentacleIdleAction.enter = function (self, unit, blackboard, t)
	-- function 2
	blackboard.next_attack_time = not not blackboard.next_attack_time
end

BTTentacleIdleAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	return
end

BTTentacleIdleAction.run = function (self, unit, blackboard, t, dt, bt_name)
	-- function 4
	local data = blackboard.tentacle_data
	local current_length = data.current_length

	if current_length > 0 then
		local breed = blackboard.breed

		data.current_length = data.current_length - dt * breed.fail_retract_speed

		local tentacle_extension = blackboard.tentacle_spline_extension

		tentacle_extension:set_reach_dist(current_length)
	end

	local target_unit = not not blackboard.current_unit

	if not Unit.alive(target_unit) then
		return "running"
	end

	if t < blackboard.next_attack_time then
		return "running"
	end

	if blackboard.target_dist < 20 then
		blackboard.tentacle_satisfied = false

		return "done"
	else
		blackboard.next_attack_time = t + 1 + math.random()
	end

	return "running"
end
