-- chunkname: @scripts/managers/debug/updator.lua

Updator = class(Updator)

Updator.init = function (self)
	-- function 1
	self._updator_autoindex = 1
	self._updators = {}
end

local function fn(arg_2_0)
	-- function 2
	return string.format("[Updator] Error: %s\n%s", arg_2_0, Script.callstack())
end

Updator.update = function (self, arg_3_1)
	-- function 3
	for k, v in pairs(self._updators) do
		local var_3_0, var_3_1 = xpcall(v, fn, arg_3_1)

		if not var_3_0 then
			self._updators[k] = nil

			print_error(var_3_1)
			printf("[Updator] Warning: updator %q threw an error and has been detached", k)
		end
	end
end

Updator.add = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not arg_4_2 then
		arg_4_2 = self._updator_index
		self._updator_index = arg_4_2 + 1
	end

	if not self._updators[arg_4_2] then
		printf("[Updator] Warning: replaced updator at index %q", arg_4_2)
	end

	self._updators[arg_4_2] = arg_4_1

	return arg_4_2
end

Updator.remove = function (self, arg_5_1)
	-- function 5
	if not self._updators[arg_5_1] then
		printf("[Updator] Warning: tried to remove updator at index %q, but there was none", arg_5_1)
	end

	self._updators[arg_5_1] = nil
end

Updator.has = function (self, arg_6_1)
	-- function 6
	return not not self._updators[arg_6_1]
end

Updator.clear = function (self)
	-- function 7
	table.clear(self._updators)
end
