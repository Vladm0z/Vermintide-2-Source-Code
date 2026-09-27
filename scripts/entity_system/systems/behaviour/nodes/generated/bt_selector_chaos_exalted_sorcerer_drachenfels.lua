-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_exalted_sorcerer_drachenfels.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_chaos_exalted_sorcerer_drachenfels = class(BTSelector_chaos_exalted_sorcerer_drachenfels, BTNode)
BTSelector_chaos_exalted_sorcerer_drachenfels.name = "BTSelector_chaos_exalted_sorcerer_drachenfels"

BTSelector_chaos_exalted_sorcerer_drachenfels.init = function (self, ...)
	-- function 2
	BTSelector_chaos_exalted_sorcerer_drachenfels.super.init(self, ...)

	self._children = {}
end

BTSelector_chaos_exalted_sorcerer_drachenfels.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_chaos_exalted_sorcerer_drachenfels.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local time = Managers.time:time("game")
	local intro_timer = arg_4_2.intro_timer

	intro_timer = not intro_timer and time < arg_4_2.intro_timer

	if not intro_timer then
		self:set_running_child(arg_4_1, arg_4_2, time, var_4_7, "aborted")

		local run_2, var_4_11 = var_4_7:run(arg_4_1, arg_4_2, time, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, time, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_11
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, time, nil, "failed")
	end

	local var_4_12 = _children[3]
	local var_4_13
	local next_smart_object_data = arg_4_2.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		var_4_13 = false
	end

	local is_smart_objecting = arg_4_2.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_4_19 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_4_19 or is_smart_objecting or var_4_13 ~= nil) then
		var_4_13 = false
	end

	local is_in_smartobject_range = arg_4_2.is_in_smartobject_range
	local flag = arg_4_2.move_state == "moving"

	if var_4_13 == nil then
		var_4_13 = not is_in_smartobject_range and flag and is_smart_objecting
	end

	if not var_4_13 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_12, "aborted")

		local run_3, var_4_23 = var_4_12:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_3 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
		end

		if run_3 ~= "failed" then
			return run_3, var_4_23
		end
	elseif var_4_12 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_24 = _children[4]

	if not (arg_4_2.mode ~= "defensive" or not arg_4_2.is_summoning) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_24, "aborted")

		local run_4, var_4_26 = var_4_24:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_4 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
		end

		if run_4 ~= "failed" then
			return run_4, var_4_26
		end
	elseif var_4_24 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_27 = _children[5]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_27, "aborted")

		local run_5, var_4_29 = var_4_27:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_5 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
		end

		if run_5 ~= "failed" then
			return run_5, var_4_29
		end
	elseif var_4_27 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_30 = _children[6]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_30, "aborted")

	local run_6, var_4_32 = var_4_30:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_6 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
	end

	if run_6 ~= "failed" then
		return run_6, var_4_32
	end
end

BTSelector_chaos_exalted_sorcerer_drachenfels.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
