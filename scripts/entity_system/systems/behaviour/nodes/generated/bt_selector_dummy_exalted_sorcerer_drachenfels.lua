-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_dummy_exalted_sorcerer_drachenfels.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_dummy_exalted_sorcerer_drachenfels = class(BTSelector_dummy_exalted_sorcerer_drachenfels, BTNode)
BTSelector_dummy_exalted_sorcerer_drachenfels.name = "BTSelector_dummy_exalted_sorcerer_drachenfels"

BTSelector_dummy_exalted_sorcerer_drachenfels.init = function (self, ...)
	-- function 2
	BTSelector_dummy_exalted_sorcerer_drachenfels.super.init(self, ...)

	self._children = {}
end

BTSelector_dummy_exalted_sorcerer_drachenfels.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_dummy_exalted_sorcerer_drachenfels.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if not not arg_4_2.anim_cb_escape_finished then
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

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_10, "aborted")

	local run_3, var_4_12 = var_4_10:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_3 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
	end

	if run_3 ~= "failed" then
		return run_3, var_4_12
	end
end

BTSelector_dummy_exalted_sorcerer_drachenfels.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
