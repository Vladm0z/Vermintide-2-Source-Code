-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_marauder_tutorial.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local unit_alive = Unit.alive
local Profiler = Profiler

local function nop()
	-- function 1
	return
end

BTSelector_marauder_tutorial = class(BTSelector_marauder_tutorial, BTNode)
BTSelector_marauder_tutorial.name = "BTSelector_marauder_tutorial"

BTSelector_marauder_tutorial.init = function (self, ...)
	-- function 2
	BTSelector_marauder_tutorial.super.init(self, ...)

	self._children = {}
end

BTSelector_marauder_tutorial.leave = function (self, unit, blackboard, t, reason)
	-- function 3
	self:set_running_child(unit, blackboard, t, nil, reason)
end

BTSelector_marauder_tutorial.run = function (self, unit, blackboard, t, dt)
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
		local node_falling = children[2]
		local is_falling = blackboard.is_falling

		if not is_falling then
			-- Nothing
		end

		if blackboard.fall_state == nil then
			is_falling = false

			goto label_4_0
		end

		is_falling = true

		local condition_result = is_falling

		::label_4_0::

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
		local node_stagger = children[3]
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
		local node_blocked = children[4]
		local condition_result = blackboard.blocked

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_blocked, "aborted")

			local result, evaluate = node_blocked:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_blocked == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_smartobject = children[5]
		local condition_result
		local next_smart_object_data = blackboard.next_smart_object_data
		local smartobject_is_next = next_smart_object_data.next_smart_object_id ~= nil

		if not smartobject_is_next then
			condition_result = false
		end

		local is_smart_objecting = blackboard.is_smart_objecting
		local nav_graph_system = Managers.state.entity:system("nav_graph_system")
		local smart_object_data = next_smart_object_data.smart_object_data

		if smart_object_data then
			-- Nothing
		end

		smart_object_data = next_smart_object_data.smart_object_data.unit

		local smart_object_unit = smart_object_data

		::label_4_1::

		local has_nav_graph_extension, nav_graph_enabled = nav_graph_system:has_nav_graph(smart_object_unit)

		if has_nav_graph_extension and not nav_graph_enabled and not is_smart_objecting and condition_result == nil then
			condition_result = false
		end

		local is_in_smartobject_range = blackboard.is_in_smartobject_range
		local moving_state = blackboard.move_state == "moving"

		if condition_result == nil then
			condition_result = (not is_in_smartobject_range or not moving_state) and not not is_smart_objecting
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
		local node_hesitate = children[6]
		local var_4_2 = unit_alive(blackboard.target_unit)

		if var_4_2 then
			-- Nothing
		end

		var_4_2 = blackboard.is_alerted

		if var_4_2 then
			-- Nothing
		end

		if blackboard.confirmed_player_sighting then
			var_4_2 = blackboard.hesitating

			if false then
				var_4_2 = false
			end

			goto label_4_2
		end

		var_4_2 = true

		local alerted = var_4_2

		::label_4_2::

		local is_taunted = unit_alive(blackboard.taunt_unit)
		local taunt_hesitate = not not is_taunted and not blackboard.taunt_hesitate_finished and not not not blackboard.no_taunt_hesitate
		local condition_result = not not alerted or not not taunt_hesitate

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_hesitate, "aborted")

			local result, evaluate = node_hesitate:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_hesitate == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_in_combat = children[7]
		local var_4_3 = unit_alive(blackboard.target_unit)

		if var_4_3 then
			-- Nothing
		end

		var_4_3 = blackboard.confirmed_player_sighting

		local condition_result = var_4_3

		::label_4_3::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_in_combat, "aborted")

			local result, evaluate = node_in_combat:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_in_combat == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_alerted = children[8]
		local var_4_4 = unit_alive(blackboard.target_unit)

		if var_4_4 then
			-- Nothing
		end

		var_4_4 = not blackboard.confirmed_player_sighting

		local condition_result = var_4_4

		::label_4_4::

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_alerted, "aborted")

			local result, evaluate = node_alerted:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_alerted == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_move_to_goal = children[9]
		local condition_result = blackboard.goal_destination ~= nil

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_move_to_goal, "aborted")

			local result, evaluate = node_move_to_goal:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_move_to_goal == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_idle = children[10]
		local condition_result = not unit_alive(blackboard.target_unit)

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_idle, "aborted")

			local result, evaluate = node_idle:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_idle == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	local node_fallback_idle = children[11]

	self:set_running_child(unit, blackboard, t, node_fallback_idle, "aborted")

	local result, evaluate = node_fallback_idle:run(unit, blackboard, t, dt)

	if result ~= "running" then
		self:set_running_child(unit, blackboard, t, nil, result)
	end

	if result ~= "failed" then
		return result, evaluate
	end
end

BTSelector_marauder_tutorial.add_child = function (self, node)
	-- function 5
	self._children[#self._children + 1] = node
end
