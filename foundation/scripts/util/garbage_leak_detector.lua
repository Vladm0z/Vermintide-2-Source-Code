-- chunkname: @foundation/scripts/util/garbage_leak_detector.lua

local GarbageLeakDetector = GarbageLeakDetector

GarbageLeakDetector = GarbageLeakDetector or {
	enabled = false,
	object_callstack_map = setmetatable({}, {
		__mode = "k"
	})
}
GarbageLeakDetector = GarbageLeakDetector

GarbageLeakDetector.register_object = function (arg_1_0, arg_1_1)
	-- function 1
	return
end

local var_0_1

local function fn(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local num = 1

	while true do
		local getupvalue, var_2_2 = debug.getupvalue(arg_2_0, num)

		if getupvalue == nil then
			break
		end

		if getupvalue == arg_2_1 then
			arg_2_2[arg_2_3] = string.format("> upvalue key [value %s]", tostring(var_2_2))

			printf("Found leak at path: %s", table.concat(arg_2_2))
		else
			arg_2_2[arg_2_3] = string.format("> upval name %q", tostring(getupvalue))

			var_0_1(getupvalue, arg_2_1, arg_2_2, arg_2_3 + 1)
		end

		if var_2_2 == arg_2_1 then
			arg_2_2[arg_2_3] = string.format("> upvalue %q", tostring(getupvalue))

			printf("Found leak at path: %s", table.concat(arg_2_2))
		else
			arg_2_2[arg_2_3] = string.format("> upval %q", tostring(getupvalue))

			var_0_1(var_2_2, arg_2_1, arg_2_2, arg_2_3 + 1)
		end

		arg_2_2[arg_2_3] = nil
		num = num + 1
	end
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	for k, v in pairs(arg_3_0) do
		arg_3_2[arg_3_3] = string.format("> key %s", tostring(k))

		if k == arg_3_1 then
			printf("Found leak at path: %s", table.concat(arg_3_2))
		else
			var_0_1(k, arg_3_1, arg_3_2, arg_3_3 + 1)
		end

		arg_3_2[arg_3_3] = string.format("> %s", tostring(k))

		if v == arg_3_1 then
			printf("Found leak at path: %s", table.concat(arg_3_2))
		else
			var_0_1(v, arg_3_1, arg_3_2, arg_3_3 + 1)
		end

		local getmetatable = debug.getmetatable(arg_3_0)

		if not getmetatable then
			arg_3_2[arg_3_3] = string.format("> metatable %s", tostring(getmetatable))

			if getmetatable == arg_3_1 then
				printf("Found leak at path: %s", table.concat(arg_3_2))
			else
				var_0_1(getmetatable, arg_3_1, arg_3_2, arg_3_3 + 1)
			end
		end

		arg_3_2[arg_3_3] = nil
	end
end

local var_0_4

function var_0_1(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_0 == arg_4_1 then
		printf("Found leak at path: %s", table.concat(arg_4_2))
	end

	local var_4_0 = type(arg_4_0)

	if var_4_0 == "function" then
		if not var_0_4[arg_4_0] then
			return
		end

		var_0_4[arg_4_0] = true
		arg_4_2[arg_4_3] = "> function"

		fn(arg_4_0, arg_4_1, arg_4_2, arg_4_3 + 1)

		arg_4_2[arg_4_3] = nil
	elseif var_4_0 == "table" then
		if not var_0_4[arg_4_0] then
			return
		end

		var_0_4[arg_4_0] = true
		arg_4_2[arg_4_3] = "> table "

		fn_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3 + 1)

		arg_4_2[arg_4_3] = nil
	else
		local var_4_1 = getmetatable(arg_4_0)

		if not (not var_4_1 and var_0_4[var_4_1]) then
			arg_4_2[arg_4_3] = string.format("> %s metatable", tostring(arg_4_0))

			var_0_1(var_4_1, arg_4_1, arg_4_2, arg_4_3 + 1)

			arg_4_2[arg_4_3] = nil
		end
	end
end

local function fn_3(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local num = 3

	while true do
		local getinfo = debug.getinfo(num)

		if not getinfo then
			break
		end

		local format = string.format
		local str = "Stack function %s [%d]"
		local name = getinfo.name

		name = name or "UNKNOWN"
		arg_5_1[arg_5_2] = format(str, name, num)

		local func = getinfo.func

		if not func then
			var_0_1(func, arg_5_0, arg_5_1, arg_5_2 + 1)
		end

		local num_2 = 1

		while true do
			local getlocal, var_5_8 = debug.getlocal(num, num_2)

			if not getlocal then
				break
			end

			arg_5_1[arg_5_2 + 1] = string.format("> Stack variable %s:%q [name]", tostring(getlocal), tostring(var_5_8))

			var_0_1(getlocal, arg_5_0, arg_5_1, arg_5_2 + 2)

			arg_5_1[arg_5_2 + 1] = string.format("> Stack variable %s:%q [value]", tostring(getlocal), tostring(var_5_8))

			var_0_1(var_5_8, arg_5_0, arg_5_1, arg_5_2 + 2)

			arg_5_1[arg_5_2 + 1] = nil
			num_2 = num_2 + 1
		end

		num = num + 1
		arg_5_1[arg_5_2] = nil
	end
end

local var_0_6

GarbageLeakDetector.run_leak_detection = function (arg_6_0)
	-- function 6
	return
end
