-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_greed_pinata.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_chaos_greed_pinata = class(BTSelector_chaos_greed_pinata, BTNode)
BTSelector_chaos_greed_pinata.name = "BTSelector_chaos_greed_pinata"

BTSelector_chaos_greed_pinata.init = function (self, ...)
	-- function 2
	BTSelector_chaos_greed_pinata.super.init(self, ...)

	self._children = {}
end

BTSelector_chaos_greed_pinata.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_chaos_greed_pinata.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local var_4_8
	local next_smart_object_data = arg_4_2.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		var_4_8 = false
	end

	local is_smart_objecting = arg_4_2.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_4_14 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_4_14 or is_smart_objecting or var_4_8 ~= nil) then
		var_4_8 = false
	end

	local is_in_smartobject_range = arg_4_2.is_in_smartobject_range
	local flag = arg_4_2.move_state == "moving"

	if var_4_8 == nil then
		var_4_8 = not is_in_smartobject_range and flag and is_smart_objecting
	end

	if not var_4_8 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local run_2, var_4_18 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_18
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_19 = _children[3]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_19, "aborted")

	local run_3, var_4_21 = var_4_19:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_3 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
	end

	if run_3 ~= "failed" then
		return run_3, var_4_21
	end

	local var_4_22 = _children[4]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_22, "aborted")

	local run_4, var_4_24 = var_4_22:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_4 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
	end

	if run_4 ~= "failed" then
		return run_4, var_4_24
	end
end

BTSelector_chaos_greed_pinata.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
