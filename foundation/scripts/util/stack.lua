-- chunkname: @foundation/scripts/util/stack.lua

Stack = class(Stack)

function Stack.init(arg_1_0)
	arg_1_0._stack = {}
end

function Stack.push(arg_2_0, arg_2_1)
	table.insert(arg_2_0._stack, arg_2_1)
end

function Stack.pop(arg_3_0)
	return table.remove(arg_3_0._stack)
end

function Stack.top(arg_4_0)
	return arg_4_0._stack[#arg_4_0._stack]
end

function Stack.size(arg_5_0)
	return #arg_5_0._stack
end

function Stack.clear(arg_6_0)
	arg_6_0._stack = {}
end
