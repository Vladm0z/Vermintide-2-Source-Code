-- chunkname: @scripts/network/network_event_delegate.lua

NetworkEventDelegate = class(NetworkEventDelegate)

local var_0_0 = getmetatable(NetworkEventDelegate)

local function var_0_1()
	return
end

local function var_0_2()
	return false
end

NetworkEventDelegate.init = function (arg_3_0)
	arg_3_0._registered_objects = {}

	local var_3_0 = {
		__index = function (arg_4_0, arg_4_1)
			if arg_4_1 == "approve_channel" then
				return var_0_2
			end

			visual_assert(false, "RPC not registered %q", arg_4_1)
			printf("RPC not registered %q", arg_4_1)

			return var_0_1
		end
	}

	arg_3_0.event_table = setmetatable({}, var_3_0)
	arg_3_0._return_objects = {}
end

NetworkEventDelegate.register = function (arg_5_0, arg_5_1, ...)
	for iter_5_0 = 1, select("#", ...) do
		local var_5_0 = select(iter_5_0, ...)

		fassert(arg_5_1[var_5_0], "[NetworkEventDelegate]: No callback function with name %q specified in passed object", var_5_0)

		arg_5_0._registered_objects[var_5_0] = arg_5_0._registered_objects[var_5_0] or {}
		arg_5_0._registered_objects[var_5_0][#arg_5_0._registered_objects[var_5_0] + 1] = arg_5_1

		if rawget(arg_5_0.event_table, var_5_0) == nil then
			local function var_5_1(arg_6_0, ...)
				local var_6_0 = arg_5_0._registered_objects[var_5_0]
				local var_6_1 = #var_6_0

				for iter_6_0 = 1, var_6_1 do
					local var_6_2 = var_6_0[iter_6_0]

					var_6_2[var_5_0](var_6_2, ...)
				end
			end

			arg_5_0.event_table[var_5_0] = var_5_1
		end
	end
end

NetworkEventDelegate.register_with_return = function (arg_7_0, arg_7_1, arg_7_2)
	fassert(arg_7_1[arg_7_2], "[NetworkEventDelegate]: No callback function with name %q specified in passed object", arg_7_2)
	fassert(arg_7_0._return_objects[arg_7_2] == nil, "[NetworkEventDelegate]: Can only register one of these", arg_7_2)

	arg_7_0._return_objects[arg_7_2] = arg_7_1

	if rawget(arg_7_0.event_table, arg_7_2) == nil then
		local function var_7_0(arg_8_0, ...)
			local var_8_0 = arg_7_0._return_objects[arg_7_2]

			return var_8_0[arg_7_2](var_8_0, ...)
		end

		arg_7_0.event_table[arg_7_2] = var_7_0
	end
end

NetworkEventDelegate.unregister = function (arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._registered_objects) do
		local var_9_0 = #iter_9_1
		local var_9_1

		for iter_9_2 = var_9_0, 1, -1 do
			if arg_9_1 == iter_9_1[iter_9_2] then
				table.remove(iter_9_1, iter_9_2)

				var_9_1 = true
			end
		end

		if #iter_9_1 == 0 and var_9_1 then
			assert(rawget(arg_9_0.event_table, iter_9_0))

			arg_9_0.event_table[iter_9_0] = nil
		end
	end

	for iter_9_3, iter_9_4 in pairs(arg_9_0._return_objects) do
		if arg_9_1 == iter_9_4 then
			arg_9_0._return_objects[iter_9_3] = nil
		end
	end
end

NetworkEventDelegate.unregister_callback = function (arg_10_0, arg_10_1)
	arg_10_0._registered_objects[arg_10_1] = nil
end

NetworkEventDelegate._cleanup = function (arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._registered_objects) do
		local var_11_0 = #iter_11_1

		fassert(var_11_0 == 0, "[NetworkEventDelegate]: Object(s) not unregistered at cleanup for callback_name: %q", iter_11_0)

		arg_11_0.event_table[iter_11_0] = nil
	end

	arg_11_0._registered_objects = nil
end

NetworkEventDelegate.destroy = function (arg_12_0)
	arg_12_0:_cleanup()

	arg_12_0.event_table = nil

	GarbageLeakDetector.register_object(arg_12_0, "NetworkEventDelegate")
end
