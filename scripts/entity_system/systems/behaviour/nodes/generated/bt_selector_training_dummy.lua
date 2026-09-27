-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_training_dummy.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_training_dummy = class(BTSelector_training_dummy, BTNode)
BTSelector_training_dummy.name = "BTSelector_training_dummy"

BTSelector_training_dummy.init = function (self, ...)
	-- function 2
	BTSelector_training_dummy.super.init(self, ...)

	self._children = {}
end

BTSelector_training_dummy.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_training_dummy.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local start = Profiler.start
	local stop = Profiler.stop
	local current_running_child = self:current_running_child(arg_4_2)
	local _children = self._children
	local var_4_4 = _children[1]
	local var_4_5

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_5 = true
		end
	end

	if not var_4_5 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_4, "aborted")

		local run, var_4_7 = var_4_4:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run)
		end

		if run ~= "failed" then
			return run, var_4_7
		end
	elseif var_4_4 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_8 = _children[2]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_8, "aborted")

	local run_2, var_4_10 = var_4_8:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_2 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
	end

	if run_2 ~= "failed" then
		return run_2, var_4_10
	end
end

BTSelector_training_dummy.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
