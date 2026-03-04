-- chunkname: @foundation/scripts/util/garbage_leak_detector.lua

GarbageLeakDetector = GarbageLeakDetector or {
	enabled = false,
	object_callstack_map = setmetatable({}, {
		__mode = "k"
	})
}

GarbageLeakDetector.register_object = function (arg_1_0, arg_1_1)
	return
end

local var_0_0

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = 1

	while true do
		local var_2_1, var_2_2 = debug.getupvalue(arg_2_0, var_2_0)

		if var_2_1 == nil then
			break
		end

		if var_2_1 == arg_2_1 then
			arg_2_2[arg_2_3] = string.format("> upvalue key [value %s]", tostring(var_2_2))

			printf("Found leak at path: %s", table.concat(arg_2_2))
		else
			arg_2_2[arg_2_3] = string.format("> upval name %q", tostring(var_2_1))

			var_0_0(var_2_1, arg_2_1, arg_2_2, arg_2_3 + 1)
		end

		if var_2_2 == arg_2_1 then
			arg_2_2[arg_2_3] = string.format("> upvalue %q", tostring(var_2_1))

			printf("Found leak at path: %s", table.concat(arg_2_2))
		else
			arg_2_2[arg_2_3] = string.format("> upval %q", tostring(var_2_1))

			var_0_0(var_2_2, arg_2_1, arg_2_2, arg_2_3 + 1)
		end

		arg_2_2[arg_2_3] = nil
		var_2_0 = var_2_0 + 1
	end
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		arg_3_2[arg_3_3] = string.format("> key %s", tostring(iter_3_0))

		if iter_3_0 == arg_3_1 then
			printf("Found leak at path: %s", table.concat(arg_3_2))
		else
			var_0_0(iter_3_0, arg_3_1, arg_3_2, arg_3_3 + 1)
		end

		arg_3_2[arg_3_3] = string.format("> %s", tostring(iter_3_0))

		if iter_3_1 == arg_3_1 then
			printf("Found leak at path: %s", table.concat(arg_3_2))
		else
			var_0_0(iter_3_1, arg_3_1, arg_3_2, arg_3_3 + 1)
		end

		local var_3_0 = debug.getmetatable(arg_3_0)

		if var_3_0 then
			arg_3_2[arg_3_3] = string.format("> metatable %s", tostring(var_3_0))

			if var_3_0 == arg_3_1 then
				printf("Found leak at path: %s", table.concat(arg_3_2))
			else
				var_0_0(var_3_0, arg_3_1, arg_3_2, arg_3_3 + 1)
			end
		end

		arg_3_2[arg_3_3] = nil
	end
end

local var_0_3

function var_0_0(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_0 == arg_4_1 then
		printf("Found leak at path: %s", table.concat(arg_4_2))
	end

	local var_4_0 = type(arg_4_0)

	if var_4_0 == "function" then
		if var_0_3[arg_4_0] then
			return
		end

		var_0_3[arg_4_0] = true
		arg_4_2[arg_4_3] = "> function"

		var_0_1(arg_4_0, arg_4_1, arg_4_2, arg_4_3 + 1)

		arg_4_2[arg_4_3] = nil
	elseif var_4_0 == "table" then
		if var_0_3[arg_4_0] then
			return
		end

		var_0_3[arg_4_0] = true
		arg_4_2[arg_4_3] = "> table "

		var_0_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3 + 1)

		arg_4_2[arg_4_3] = nil
	else
		local var_4_1 = getmetatable(arg_4_0)

		if var_4_1 and not var_0_3[var_4_1] then
			arg_4_2[arg_4_3] = string.format("> %s metatable", tostring(arg_4_0))

			var_0_0(var_4_1, arg_4_1, arg_4_2, arg_4_3 + 1)

			arg_4_2[arg_4_3] = nil
		end
	end
end

local function var_0_4(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = 3

	while true do
		local var_5_1 = debug.getinfo(var_5_0)

		if not var_5_1 then
			break
		end

		arg_5_1[arg_5_2] = string.format("Stack function %s [%d]", var_5_1.name or "UNKNOWN", var_5_0)

		local var_5_2 = var_5_1.func

		if var_5_2 then
			var_0_0(var_5_2, arg_5_0, arg_5_1, arg_5_2 + 1)
		end

		local var_5_3 = 1

		while true do
			local var_5_4, var_5_5 = debug.getlocal(var_5_0, var_5_3)

			if not var_5_4 then
				break
			end

			arg_5_1[arg_5_2 + 1] = string.format("> Stack variable %s:%q [name]", tostring(var_5_4), tostring(var_5_5))

			var_0_0(var_5_4, arg_5_0, arg_5_1, arg_5_2 + 2)

			arg_5_1[arg_5_2 + 1] = string.format("> Stack variable %s:%q [value]", tostring(var_5_4), tostring(var_5_5))

			var_0_0(var_5_5, arg_5_0, arg_5_1, arg_5_2 + 2)

			arg_5_1[arg_5_2 + 1] = nil
			var_5_3 = var_5_3 + 1
		end

		var_5_0 = var_5_0 + 1
		arg_5_1[arg_5_2] = nil
	end
end

local var_0_5

GarbageLeakDetector.run_leak_detection = function (arg_6_0)
	return
end
