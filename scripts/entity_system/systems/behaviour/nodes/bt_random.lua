-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_random.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRandom = class(BTRandom, BTNode)
BTRandom.name = "BTRandom"

BTRandom.init = function (self, ...)
	-- function 1
	BTRandom.super.init(self, ...)

	self._children = {}
end

BTRandom.ready = function (self, arg_2_1)
	-- function 2
	local tbl = {}

	for i = 1, #self._children do
		tbl[i] = self._children[i]._tree_node.weight
	end

	self.prob, self.alias = LoadedDice.create(tbl, false)
end

BTRandom.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local roll = LoadedDice.roll(self.prob, self.alias)

	arg_3_2.node_data[self._identifier] = roll
end

BTRandom.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil)

	arg_4_2.node_data[self._identifier] = nil
end

BTRandom.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local current_running_child = self:current_running_child(arg_5_2)

	if not current_running_child then
		if not current_running_child:condition(arg_5_2) then
			return "failed"
		end

		return (current_running_child:run(arg_5_1, arg_5_2, arg_5_3, arg_5_4))
	end

	local var_5_1 = arg_5_2.node_data[self._identifier]
	local count = #self._children

	for i = 1, count do
		local num = (i + var_5_1 - 2) % count + 1
		local var_5_4 = self._children[num]

		if not var_5_4:condition(arg_5_2) then
			self:set_running_child(arg_5_1, arg_5_2, arg_5_3, var_5_4)

			return (var_5_4:run(arg_5_1, arg_5_2, arg_5_3, arg_5_4))
		end
	end

	return "failed"
end

BTRandom.add_child = function (arg_6_0, arg_6_1)
	-- function 6
	arg_6_0._children[#arg_6_0._children + 1] = arg_6_1
end
