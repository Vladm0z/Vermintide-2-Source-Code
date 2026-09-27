-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_corruptor_sorcerer.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_chaos_corruptor_sorcerer = class(BTSelector_chaos_corruptor_sorcerer, BTNode)
BTSelector_chaos_corruptor_sorcerer.name = "BTSelector_chaos_corruptor_sorcerer"

BTSelector_chaos_corruptor_sorcerer.init = function (self, ...)
	-- function 2
	BTSelector_chaos_corruptor_sorcerer.super.init(self, ...)

	self._children = {}
end

BTSelector_chaos_corruptor_sorcerer.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_chaos_corruptor_sorcerer.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local start = Profiler.start
	local stop = Profiler.stop
	local current_running_child = self:current_running_child(arg_4_2)
	local _children = self._children
	local var_4_4 = _children[1]

	if not arg_4_2.spawn then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_4, "aborted")

		local run, var_4_6 = var_4_4:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run)
		end

		if run ~= "failed" then
			return run, var_4_6
		end
	elseif var_4_4 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_7 = _children[2]

	if not arg_4_2.in_vortex then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local run_2, var_4_9 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_9
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_10 = _children[3]
	local is_falling = arg_4_2.is_falling

	is_falling = is_falling or arg_4_2.fall_state ~= nil

	if not is_falling then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_10, "aborted")

		local run_3, var_4_13 = var_4_10:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_3 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
		end

		if run_3 ~= "failed" then
			return run_3, var_4_13
		end
	elseif var_4_10 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_14 = _children[4]
	local var_4_15

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_15 = true
		end
	end

	if not var_4_15 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_14, "aborted")

		local run_4, var_4_17 = var_4_14:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_4 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
		end

		if run_4 ~= "failed" then
			return run_4, var_4_17
		end
	elseif var_4_14 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_18 = _children[5]
	local var_4_19
	local next_smart_object_data = arg_4_2.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		var_4_19 = false
	end

	local is_smart_objecting = arg_4_2.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_4_25 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_4_25 or is_smart_objecting or var_4_19 ~= nil) then
		var_4_19 = false
	end

	local is_in_smartobject_range = arg_4_2.is_in_smartobject_range
	local flag = arg_4_2.move_state == "moving"

	if var_4_19 == nil then
		var_4_19 = not is_in_smartobject_range and flag and is_smart_objecting
	end

	if not var_4_19 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_18, "aborted")

		local run_5, var_4_29 = var_4_18:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_5 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
		end

		if run_5 ~= "failed" then
			return run_5, var_4_29
		end
	elseif var_4_18 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_30 = _children[6]

	if not arg_4_2.quick_teleport then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_30, "aborted")

		local run_6, var_4_32 = var_4_30:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_6 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
		end

		if run_6 ~= "failed" then
			return run_6, var_4_32
		end
	elseif var_4_30 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_33 = _children[7]
	local ready_to_summon = arg_4_2.ready_to_summon

	if not ready_to_summon then
		ready_to_summon = arg_4_2.summoning
		ready_to_summon = ready_to_summon or Unit.alive(arg_4_2.target_unit)
	end

	if not ready_to_summon then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_33, "aborted")

		local run_7, var_4_36 = var_4_33:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_7 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_7)
		end

		if run_7 ~= "failed" then
			return run_7, var_4_36
		end
	elseif var_4_33 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_37 = _children[8]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_37, "aborted")

		local run_8, var_4_39 = var_4_37:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_39
		end
	elseif var_4_37 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_40 = _children[9]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_40, "aborted")

	local run_9, var_4_42 = var_4_40:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_9 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
	end

	if run_9 ~= "failed" then
		return run_9, var_4_42
	end
end

BTSelector_chaos_corruptor_sorcerer.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
