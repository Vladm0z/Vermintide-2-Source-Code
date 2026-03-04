-- chunkname: @foundation/scripts/util/stack.lua

Stack = class(Stack)

Stack.init = function (arg_1_0)
	arg_1_0._stack = {}
end

Stack.push = function (arg_2_0, arg_2_1)
	table.insert(arg_2_0._stack, arg_2_1)
end

Stack.pop = function (arg_3_0)
	return table.remove(arg_3_0._stack)
end

Stack.top = function (arg_4_0)
	return arg_4_0._stack[#arg_4_0._stack]
end

Stack.size = function (arg_5_0)
	return #arg_5_0._stack
end

Stack.clear = function (arg_6_0)
	arg_6_0._stack = {}
end
