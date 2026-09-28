-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_tentacle.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local unit_alive = Unit.alive
local Profiler = Profiler

local function nop()
	-- function 1
	return
end

BTSelector_chaos_tentacle = class(BTSelector_chaos_tentacle, BTNode)
BTSelector_chaos_tentacle.name = "BTSelector_chaos_tentacle"

BTSelector_chaos_tentacle.init = function (self, ...)
	-- function 2
	BTSelector_chaos_tentacle.super.init(self, ...)

	self._children = {}
end

BTSelector_chaos_tentacle.leave = function (self, unit, blackboard, t, reason)
	-- function 3
	self:set_running_child(unit, blackboard, t, nil, reason)
end

BTSelector_chaos_tentacle.run = function (self, unit, blackboard, t, dt)
	-- function 4
	local Profiler_start, Profiler_stop = Profiler.start, Profiler.stop
	local child_running = self:current_running_child(blackboard)
	local children = self._children

	do
		local node_spawn = children[1]
		local condition_result = blackboard.spawn

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_spawn, "aborted")

			local result, evaluate = node_spawn:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_spawn == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_attack = children[2]
		local var_4_0 = unit_alive(blackboard.target_unit)

		if var_4_0 then
			-- Nothing
		end

		var_4_0 = not blackboard.tentacle_satisfied

		local condition_result = var_4_0

		::label_4_0::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_attack, "aborted")

			local result, evaluate = node_attack:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_attack == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	local node_idle = children[3]

	self:set_running_child(unit, blackboard, t, node_idle, "aborted")

	local result, evaluate = node_idle:run(unit, blackboard, t, dt)

	if result ~= "running" then
		self:set_running_child(unit, blackboard, t, nil, result)
	end

	if result ~= "failed" then
		return result, evaluate
	end
end

BTSelector_chaos_tentacle.add_child = function (self, node)
	-- function 5
	self._children[#self._children + 1] = node
end
