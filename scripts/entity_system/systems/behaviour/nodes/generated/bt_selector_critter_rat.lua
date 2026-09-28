-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_critter_rat.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local unit_alive = Unit.alive
local Profiler = Profiler

local function nop()
	-- function 1
	return
end

BTSelector_critter_rat = class(BTSelector_critter_rat, BTNode)
BTSelector_critter_rat.name = "BTSelector_critter_rat"

BTSelector_critter_rat.init = function (self, ...)
	-- function 2
	BTSelector_critter_rat.super.init(self, ...)

	self._children = {}
end

BTSelector_critter_rat.leave = function (self, unit, blackboard, t, reason)
	-- function 3
	self:set_running_child(unit, blackboard, t, nil, reason)
end

BTSelector_critter_rat.run = function (self, unit, blackboard, t, dt)
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
		local node_in_vortex = children[2]
		local condition_result = blackboard.in_vortex

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_in_vortex, "aborted")

			local result, evaluate = node_in_vortex:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_in_vortex == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_under_door = children[3]
		local at_smartobject = BTConditions.at_smartobject(blackboard)

		if at_smartobject then
			-- Nothing
		end

		at_smartobject = BTConditions.at_door_smartobject(blackboard)

		local condition_result = at_smartobject

		::label_4_0::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_under_door, "aborted")

			local result, evaluate = node_under_door:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_under_door == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_flee_sequence = children[4]
		local var_4_1 = unit_alive(blackboard.target_unit)

		if not var_4_1 then
			-- Nothing
		end

		var_4_1 = blackboard.is_fleeing

		local condition_result = var_4_1

		::label_4_1::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_flee_sequence, "aborted")

			local result, evaluate = node_flee_sequence:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_flee_sequence == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	local node_idle = children[5]

	self:set_running_child(unit, blackboard, t, node_idle, "aborted")

	local result, evaluate = node_idle:run(unit, blackboard, t, dt)

	if result ~= "running" then
		self:set_running_child(unit, blackboard, t, nil, result)
	end

	if result ~= "failed" then
		return result, evaluate
	end
end

BTSelector_critter_rat.add_child = function (self, node)
	-- function 5
	self._children[#self._children + 1] = node
end
