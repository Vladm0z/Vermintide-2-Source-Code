-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pack_master.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local unit_alive = Unit.alive
local Profiler = Profiler

local function nop()
	-- function 1
	return
end

BTSelector_pack_master = class(BTSelector_pack_master, BTNode)
BTSelector_pack_master.name = "BTSelector_pack_master"

BTSelector_pack_master.init = function (self, ...)
	-- function 2
	BTSelector_pack_master.super.init(self, ...)

	self._children = {}
end

BTSelector_pack_master.leave = function (self, unit, blackboard, t, reason)
	-- function 3
	self:set_running_child(unit, blackboard, t, nil, reason)
end

BTSelector_pack_master.run = function (self, unit, blackboard, t, dt)
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
		local node_falling = children[3]
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
		local node_stagger = children[4]
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
		local node_get_new_hook = children[6]
		local condition_result = blackboard.needs_hook

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_get_new_hook, "aborted")

			local result, evaluate = node_get_new_hook:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_get_new_hook == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_enemy_spotted = children[7]
		local condition_result = unit_alive(blackboard.target_unit)

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_enemy_spotted, "aborted")

			local result, evaluate = node_enemy_spotted:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_enemy_spotted == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_escorting_ogre = children[8]
		local condition_result = blackboard.escorting_rat_ogre

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_escorting_ogre, "aborted")

			local result, evaluate = node_escorting_ogre:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_escorting_ogre == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	do
		local node_trigger_move_to = children[9]
		local t = Managers.time:time("game")
		local trigger_time_2 = blackboard.trigger_time

		if not trigger_time_2 then
			-- Nothing
		end

		trigger_time_2 = 0

		local trigger_time = trigger_time_2

		::label_4_2::

		local condition_result = trigger_time < t and not not unit_alive(blackboard.target_unit)

		if condition_result then
			self:set_running_child(unit, blackboard, t, node_trigger_move_to, "aborted")

			local result, evaluate = node_trigger_move_to:run(unit, blackboard, t, dt)

			if result ~= "running" then
				self:set_running_child(unit, blackboard, t, nil, result)
			end

			if result ~= "failed" then
				return result, evaluate
			end
		elseif node_trigger_move_to == child_running then
			self:set_running_child(unit, blackboard, t, nil, "failed")
		end
	end

	local node_idle = children[10]

	self:set_running_child(unit, blackboard, t, node_idle, "aborted")

	local result, evaluate = node_idle:run(unit, blackboard, t, dt)

	if result ~= "running" then
		self:set_running_child(unit, blackboard, t, nil, result)
	end

	if result ~= "failed" then
		return result, evaluate
	end
end

BTSelector_pack_master.add_child = function (self, node)
	-- function 5
	self._children[#self._children + 1] = node
end
