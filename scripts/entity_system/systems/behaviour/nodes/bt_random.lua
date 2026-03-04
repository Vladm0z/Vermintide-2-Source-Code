-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_random.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRandom = class(BTRandom, BTNode)
BTRandom.name = "BTRandom"

function BTRandom.init(arg_1_0, ...)
	BTRandom.super.init(arg_1_0, ...)

	arg_1_0._children = {}
end

function BTRandom.ready(arg_2_0, arg_2_1)
	local var_2_0 = {}

	for iter_2_0 = 1, #arg_2_0._children do
		var_2_0[iter_2_0] = arg_2_0._children[iter_2_0]._tree_node.weight
	end

	arg_2_0.prob, arg_2_0.alias = LoadedDice.create(var_2_0, false)
end

function BTRandom.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = LoadedDice.roll(arg_3_0.prob, arg_3_0.alias)

	arg_3_2.node_data[arg_3_0._identifier] = var_3_0
end

function BTRandom.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil)

	arg_4_2.node_data[arg_4_0._identifier] = nil
end

function BTRandom.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0:current_running_child(arg_5_2)

	if var_5_0 then
		if not var_5_0:condition(arg_5_2) then
			return "failed"
		end

		return (var_5_0:run(arg_5_1, arg_5_2, arg_5_3, arg_5_4))
	end

	local var_5_1 = arg_5_2.node_data[arg_5_0._identifier]
	local var_5_2 = #arg_5_0._children

	for iter_5_0 = 1, var_5_2 do
		local var_5_3 = (iter_5_0 + var_5_1 - 2) % var_5_2 + 1
		local var_5_4 = arg_5_0._children[var_5_3]

		if var_5_4:condition(arg_5_2) then
			arg_5_0:set_running_child(arg_5_1, arg_5_2, arg_5_3, var_5_4)

			return (var_5_4:run(arg_5_1, arg_5_2, arg_5_3, arg_5_4))
		end
	end

	return "failed"
end

function BTRandom.add_child(arg_6_0, arg_6_1)
	arg_6_0._children[#arg_6_0._children + 1] = arg_6_1
end
