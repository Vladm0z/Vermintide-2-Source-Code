-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_selector.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSelector = class(BTSelector, BTNode)

BTSelector.init = function (self, ...)
	-- function 1
	BTSelector.super.init(self, ...)

	self._children = {}
end

BTSelector.name = "BTSelector"

BTSelector.leave = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	self:set_running_child(arg_2_1, arg_2_2, arg_2_3, nil, arg_2_4)
end

BTSelector.run = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local current_running_child = self:current_running_child(arg_3_2)

	for i, v in ipairs(self._children) do
		if not v:condition(arg_3_2) then
			self:set_running_child(arg_3_1, arg_3_2, arg_3_3, v, "aborted")

			local run, var_3_2 = v:run(arg_3_1, arg_3_2, arg_3_3, arg_3_4)

			if run ~= "running" then
				self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, run)
			end

			if run ~= "failed" then
				return run, var_3_2
			end
		elseif v == current_running_child then
			self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, "failed")
		end
	end

	if not (not script_data.debug_behaviour_trees and script_data.debug_unit ~= arg_3_1) then
		print("BTSelector fail: ", self:id())
	end

	fassert(self:current_running_child(arg_3_2) == nil)

	return "failed"
end

BTSelector.add_child = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._children[#arg_4_0._children + 1] = arg_4_1
end
