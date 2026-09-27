-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_stormfiend_demo.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_stormfiend_demo = class(BTSelector_stormfiend_demo, BTNode)
BTSelector_stormfiend_demo.name = "BTSelector_stormfiend_demo"

BTSelector_stormfiend_demo.init = function (self, ...)
	-- function 2
	BTSelector_stormfiend_demo.super.init(self, ...)

	self._children = {}
end

BTSelector_stormfiend_demo.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_stormfiend_demo.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if not arg_4_2.keep_target then
		var_4_8 = false
	end

	if var_4_8 == nil then
		var_4_8 = BTConditions.at_smartobject(arg_4_2)
	end

	if not var_4_8 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local run_2, var_4_10 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_10
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_11 = _children[3]
	local var_4_12

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_12 = true
		end
	end

	if not var_4_12 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_11, "aborted")

		local run_3, var_4_14 = var_4_11:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_3 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
		end

		if run_3 ~= "failed" then
			return run_3, var_4_14
		end
	elseif var_4_11 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_15 = _children[4]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_15, "aborted")

		local run_4, var_4_17 = var_4_15:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_4 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
		end

		if run_4 ~= "failed" then
			return run_4, var_4_17
		end
	elseif var_4_15 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_18 = _children[5]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_18, "aborted")

	local run_5, var_4_20 = var_4_18:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_5 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
	end

	if run_5 ~= "failed" then
		return run_5, var_4_20
	end
end

BTSelector_stormfiend_demo.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
