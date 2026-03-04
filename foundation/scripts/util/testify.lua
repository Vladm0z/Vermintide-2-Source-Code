-- chunkname: @foundation/scripts/util/testify.lua

require("foundation/scripts/util/table")
require("scripts/tests/testify_expect")

local var_0_0 = {
	current_request = "current_request",
	request = "request",
	reply = "reply",
	ready = "ready",
	end_suite = "end_suite",
	last_request = "last_request"
}

Testify = {
	_requests = {},
	_responses = {},
	RETRY = newproxy(false),
	expect = TestifyExpect:new()
}

local var_0_1 = print
local var_0_2 = cjson.decode
local var_0_3 = cjson.encode
local var_0_4 = coroutine.resume
local var_0_5 = coroutine.yield
local var_0_6 = string.format
local var_0_7 = table.dump
local var_0_8 = table.keys
local var_0_9 = table.merge_varargs
local var_0_10 = table.pack
local var_0_11 = table.size
local var_0_12 = tostring
local var_0_13 = unpack

function Testify.init(arg_1_0)
	arg_1_0._requests = {}
	arg_1_0._responses = {}
end

function Testify.ready(arg_2_0)
	printf("[Testify] Ready!")
	arg_2_0:_signal(var_0_0.ready)
end

function Testify.ready_signal_received(arg_3_0)
	arg_3_0._ready_signal_received = true
end

function Testify.reply(arg_4_0, arg_4_1)
	arg_4_0:_signal(var_0_0.reply, arg_4_1)
end

function Testify.run_case(arg_5_0, arg_5_1)
	arg_5_0:init()

	arg_5_0._test_case = coroutine.create(arg_5_1)
end

function Testify.update(arg_6_0, arg_6_1, arg_6_2)
	if script_data.testify and not arg_6_0._ready_signal_received then
		arg_6_0:_signal(var_0_0.ready, nil, false)
	end

	if Development.parameter("testify_time_scale") and not arg_6_0._time_scaled then
		arg_6_0:_set_time_scale()
	end

	if arg_6_0._test_case then
		arg_6_0.expect:update()

		local var_6_0, var_6_1, var_6_2 = var_0_4(arg_6_0._test_case, arg_6_1, arg_6_2)

		if not var_6_0 then
			error(debug.traceback(arg_6_0._test_case, var_6_1))
		elseif coroutine.status(arg_6_0._test_case) == "dead" then
			arg_6_0._test_case = nil

			if var_6_2 == true then
				arg_6_0:_signal(var_0_0.end_suite)
			end

			arg_6_0:_signal(var_0_0.reply, var_6_1)
		end
	end
end

function Testify.make_request(arg_7_0, arg_7_1, ...)
	local var_7_0, var_7_1 = var_0_10(...)

	var_7_0.length = var_7_1

	arg_7_0:_print("Requesting %s", arg_7_1)

	arg_7_0._requests[arg_7_1] = var_7_0
	arg_7_0._responses[arg_7_1] = nil

	return arg_7_0:_wait_for_response(arg_7_1)
end

function Testify.make_request_to_runner(arg_8_0, arg_8_1, ...)
	local var_8_0 = var_0_10(...)

	arg_8_0:_print("Requesting %s to the Testify Runner", arg_8_1)

	arg_8_0._requests[arg_8_1] = var_8_0
	arg_8_0._responses[arg_8_1] = nil

	local var_8_1 = {
		name = arg_8_1,
		parameters = var_8_0
	}

	arg_8_0:_signal(var_0_0.request, var_0_3(var_8_1))

	return arg_8_0:_wait_for_response(arg_8_1)
end

function Testify._wait_for_response(arg_9_0, arg_9_1)
	arg_9_0:_print("Waiting for response %s", arg_9_1)

	while true do
		var_0_5()

		local var_9_0 = arg_9_0._responses[arg_9_1]

		if var_9_0 then
			local var_9_1 = var_9_0.length

			return var_0_13(var_9_0, 1, var_9_1)
		end
	end
end

function Testify.poll_requests_through_handler(arg_10_0, arg_10_1, ...)
	local var_10_0 = Testify.RETRY

	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		local var_10_1, var_10_2 = arg_10_0:poll_request(iter_10_0)

		if var_10_1 then
			local var_10_3, var_10_4 = var_0_10(...)
			local var_10_5, var_10_6 = var_0_9(var_10_3, var_10_4, var_0_13(var_10_1))
			local var_10_7, var_10_8 = var_0_10(iter_10_1(var_0_13(var_10_5, 1, var_10_6)))

			if var_10_7[1] ~= var_10_0 then
				arg_10_0:respond_to_request(iter_10_0, var_10_7, var_10_8)
			end

			return
		end
	end
end

function Testify.poll_request(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._requests[arg_11_1]

	if var_11_0 then
		local var_11_1 = var_11_0.length

		return var_11_0, var_11_1
	end
end

function Testify.respond_to_request(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_2 then
		arg_12_2.length = arg_12_3 or #arg_12_2
	end

	arg_12_0:_print("Responding to %s", arg_12_1)

	arg_12_0._requests[arg_12_1] = nil
	arg_12_0._last_request = arg_12_1
	arg_12_0._responses[arg_12_1] = arg_12_2
end

function Testify.respond_to_runner_request(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0:respond_to_request(arg_13_1, {
		arg_13_2
	}, arg_13_3)
end

function Testify.print_test_case_marker(arg_14_0)
	var_0_1("<<testify>>test case<</testify>>")
end

function Testify.inspect(arg_15_0)
	arg_15_0:_print("Test case running? %s", arg_15_0._thread ~= nil)
	var_0_7(arg_15_0._requests, "[Testify] Requests", 2)
	var_0_7(arg_15_0._responses, "[Testify] Responses", 2)
end

function Testify._set_time_scale(arg_16_0)
	local var_16_0 = Managers.state.debug

	if not var_16_0 then
		return
	end

	local var_16_1 = Development.parameter("testify_time_scale")
	local var_16_2 = table.index_of(var_16_0.time_scale_list, tonumber(var_16_1))

	arg_16_0._time_scaled = true

	if var_16_2 == -1 then
		printf("[Testify] Time Scale %s is not supported. Please chose a value from the following list:%s", var_16_1, table.dump_string(var_16_0.time_scale_list, 1))

		return
	end

	var_16_0:set_time_scale(var_16_2)
end

function Testify._signal(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if arg_17_3 ~= false then
		arg_17_0:_print("Replying to signal %s %s", arg_17_1, arg_17_2)
	end

	if Application.console_send == nil then
		return
	end

	Application.console_send({
		system = "Testify",
		type = "signal",
		signal = arg_17_1,
		message = var_0_12(arg_17_2)
	})
end

function Testify._print(arg_18_0, ...)
	if script_data.debug_testify then
		printf("[Testify] %s", string.format(...))
	end
end

function Testify.current_request_name(arg_19_0)
	local var_19_0 = arg_19_0._requests
	local var_19_1, var_19_2 = next(var_19_0)

	arg_19_0:_print("Current request name: %s", var_19_1)
	arg_19_0:_signal(var_0_0.current_request, var_19_1)
end

function Testify.last_request_name(arg_20_0)
	local var_20_0 = arg_20_0._last_request

	arg_20_0:_print("Last request name: %s", var_20_0)
	arg_20_0:_signal(var_0_0.last_request, var_20_0)
end
