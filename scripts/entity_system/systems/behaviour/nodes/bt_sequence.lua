-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_sequence.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSequence = class(BTSequence, BTNode)

BTSequence.init = function (self, ...)
	-- function 1
	BTSequence.super.init(self, ...)

	self._children = {}
end

BTSequence.name = "BTSequence"

BTSequence.leave = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self:set_running_child(arg_2_1, arg_2_2, arg_2_3, nil, "aborted")

	arg_2_2.node_data[self._identifier] = nil
end

BTSequence.run = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local flag = arg_3_2.node_data[self._identifier] or 1
	local count = #self._children

	for i = flag, count do
		local var_3_2 = self._children[i]

		if not var_3_2:condition(arg_3_2) then
			self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, "failed")

			return "failed"
		end

		self:set_running_child(arg_3_1, arg_3_2, arg_3_3, var_3_2, "aborted")

		local run = var_3_2:run(arg_3_1, arg_3_2, arg_3_3, arg_3_4)

		if run == "running" then
			arg_3_2.node_data[self._identifier] = i

			return run
		else
			self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, run)

			if run == "failed" then
				return "failed"
			end
		end
	end

	assert(self:current_running_child(arg_3_2) == nil)

	return "done"
end

BTSequence.add_child = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._children[#arg_4_0._children + 1] = arg_4_1
end
