-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_gutter_runner.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local unit_alive = Unit.alive
local Profiler = Profiler

local function nop()
	-- function 1
	return
end

BTSelector_gutter_runner = class(BTSelector_gutter_runner, BTNode)
BTSelector_gutter_runner.name = "BTSelector_gutter_runner"

BTSelector_gutter_runner.init = function (self, ...)
	-- function 2
	BTSelector_gutter_runner.super.init(self, ...)

	self._children = {}
end

BTSelector_gutter_runner.leave = function (self, unit, blackboard, t, reason)
	-- function 3
	self:set_running_child(unit, blackboard, t, nil, reason)
end

BTSelector_gutter_runner.run = function (self, unit, blackboard, t, dt)
	-- function 4
	local Profiler_start, Profiler_stop = Profiler.start, Profiler.stop
	local child_running = self:current_running_child(blackboard)
	local children = self._children

	do
		local node_falling = children[1]
		local is_falling

		if not blackboard.high_ground_opportunity and not blackboard.pouncing_target then
			is_falling = blackboard.is_falling

			if not is_falling then
				-- Nothing
			end

			if blackboard.fall_state == nil then
				-- Nothing
			end
		end

		is_falling = false

		goto label_4_1

		::label_4_0::

		is_falling = true

		local condition_result = is_falling

		::label_4_1::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_falling, "aborted")

			local result, evaluate = node_falling:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_falling == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_stagger = children[2]
		local condition_result

		if blackboard.stagger then
			if blackboard.stagger_prohibited then
				blackboard.stagger = false
			else
				condition_result = true
			end
		end

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_stagger, "aborted")

			local result, evaluate = node_stagger:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_stagger == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_spawn = children[3]
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
		local node_in_vortex = children[4]
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
		local node_smartobject = children[5]
		local condition_result

		if blackboard.jump_data then
			condition_result = false
		end

		if condition_result == nil then
			condition_result = BTConditions.at_smartobject(blackboard)
		end

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_smartobject, "aborted")

			local result, evaluate = node_smartobject:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_smartobject == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_ninja_vanish = children[6]
		local condition_result = blackboard.ninja_vanish

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_ninja_vanish, "aborted")

			local result, evaluate = node_ninja_vanish:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_ninja_vanish == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_quick_jump = children[7]
		local condition_result = blackboard.high_ground_opportunity

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_quick_jump, "aborted")

			local result, evaluate = node_quick_jump:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_quick_jump == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_approach_target = children[8]
		local t = Managers.time:time("game")
		local pounce_timer_is_finished = t > blackboard.initial_pounce_timer
		local comitted_to_target

		if not blackboard.target_unit then
			comitted_to_target = blackboard.comitted_to_target

			if comitted_to_target then
				-- Nothing
			end
		end

		comitted_to_target = pounce_timer_is_finished

		local condition_result = comitted_to_target

		::label_4_2::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_approach_target, "aborted")

			local result, evaluate = node_approach_target:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_approach_target == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_skulking = children[9]
		local condition_result = unit_alive(blackboard.target_unit)

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_skulking, "aborted")

			local result, evaluate = node_skulking:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_skulking == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_abide = children[10]
		local condition_result = blackboard.secondary_target

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_abide, "aborted")

			local result, evaluate = node_abide:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_abide == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	local node_idle = children[11]

	self:set_running_child(unit, blackboard, t, node_idle, "aborted")

	local result, evaluate = node_idle:run(unit, blackboard, t, dt)

	if result ~= "running" then
		self:set_running_child(unit, blackboard, t, nil, result)
	end

	if result ~= "failed" then
		return result, evaluate
	end
end

BTSelector_gutter_runner.add_child = function (self, node)
	-- function 5
	self._children[#self._children + 1] = node
end
