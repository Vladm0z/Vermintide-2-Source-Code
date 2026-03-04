-- chunkname: @scripts/managers/debug/updator.lua

Updator = class(Updator)

function Updator.init(arg_1_0)
	arg_1_0._updator_autoindex = 1
	arg_1_0._updators = {}
end

local function var_0_0(arg_2_0)
	return string.format("[Updator] Error: %s\n%s", arg_2_0, Script.callstack())
end

function Updator.update(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_0._updators) do
		local var_3_0, var_3_1 = xpcall(iter_3_1, var_0_0, arg_3_1)

		if not var_3_0 then
			arg_3_0._updators[iter_3_0] = nil

			print_error(var_3_1)
			printf("[Updator] Warning: updator %q threw an error and has been detached", iter_3_0)
		end
	end
end

function Updator.add(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_2 then
		arg_4_2 = arg_4_0._updator_index
		arg_4_0._updator_index = arg_4_2 + 1
	end

	if not arg_4_0._updators[arg_4_2] then
		printf("[Updator] Warning: replaced updator at index %q", arg_4_2)
	end

	arg_4_0._updators[arg_4_2] = arg_4_1

	return arg_4_2
end

function Updator.remove(arg_5_0, arg_5_1)
	if not arg_5_0._updators[arg_5_1] then
		printf("[Updator] Warning: tried to remove updator at index %q, but there was none", arg_5_1)
	end

	arg_5_0._updators[arg_5_1] = nil
end

function Updator.has(arg_6_0, arg_6_1)
	return not not arg_6_0._updators[arg_6_1]
end

function Updator.clear(arg_7_0)
	table.clear(arg_7_0._updators)
end
