-- chunkname: @foundation/scripts/util/testify.lua

require("foundation/scripts/util/table")
require("scripts/tests/testify_expect")

local tbl = {
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

local print = print
local decode = cjson.decode
local encode = cjson.encode
local resume = coroutine.resume
local yield = coroutine.yield
local format = string.format
local dump = table.dump
local keys = table.keys
local merge_varargs = table.merge_varargs
local pack = table.pack
local size = table.size
local tostring = tostring
local unpack = unpack

Testify.init = function (self)
	-- function 1
	self._requests = {}
	self._responses = {}
end

Testify.ready = function (self)
	-- function 2
	printf("[Testify] Ready!")
	self:_signal(tbl.ready)
end

Testify.ready_signal_received = function (self)
	-- function 3
	self._ready_signal_received = true
end

Testify.reply = function (self, arg_4_1)
	-- function 4
	self:_signal(tbl.reply, arg_4_1)
end

Testify.run_case = function (self, arg_5_1)
	-- function 5
	self:init()

	self._test_case = coroutine.create(arg_5_1)
end

Testify.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not (not script_data.testify and self._ready_signal_received) then
		self:_signal(tbl.ready, nil, false)
	end

	if not (not Development.parameter("testify_time_scale") and self._time_scaled) then
		self:_set_time_scale()
	end

	if not self._test_case then
		self.expect:update()

		local var_6_0, var_6_1, var_6_2 = resume(self._test_case, arg_6_1, arg_6_2)

		if not var_6_0 then
			error(debug.traceback(self._test_case, var_6_1))
		elseif coroutine.status(self._test_case) == "dead" then
			self._test_case = nil

			if var_6_2 == true then
				self:_signal(tbl.end_suite)
			end

			self:_signal(tbl.reply, var_6_1)
		end
	end
end

Testify.make_request = function (self, arg_7_1, ...)
	-- function 7
	local var_7_0, var_7_1 = pack(...)

	var_7_0.length = var_7_1

	self:_print("Requesting %s", arg_7_1)

	self._requests[arg_7_1] = var_7_0
	self._responses[arg_7_1] = nil

	return self:_wait_for_response(arg_7_1)
end

Testify.make_request_to_runner = function (self, arg_8_1, ...)
	-- function 8
	local var_8_0 = pack(...)

	self:_print("Requesting %s to the Testify Runner", arg_8_1)

	self._requests[arg_8_1] = var_8_0
	self._responses[arg_8_1] = nil

	local tbl_2 = {
		name = arg_8_1,
		parameters = var_8_0
	}

	self:_signal(tbl.request, encode(tbl_2))

	return self:_wait_for_response(arg_8_1)
end

Testify._wait_for_response = function (self, arg_9_1)
	-- function 9
	self:_print("Waiting for response %s", arg_9_1)

	while true do
		yield()

		local var_9_0 = self._responses[arg_9_1]

		if not var_9_0 then
			local length = var_9_0.length

			return unpack(var_9_0, 1, length)
		end
	end
end

Testify.poll_requests_through_handler = function (self, arg_10_1, ...)
	-- function 10
	local RETRY = Testify.RETRY

	for k, v in pairs(arg_10_1) do
		local poll_request, var_10_2 = self:poll_request(k)

		if not poll_request then
			local var_10_3, var_10_4 = pack(...)
			local var_10_5, var_10_6 = merge_varargs(var_10_3, var_10_4, unpack(poll_request))
			local var_10_7, var_10_8 = pack(v(unpack(var_10_5, 1, var_10_6)))

			if var_10_7[1] ~= RETRY then
				self:respond_to_request(k, var_10_7, var_10_8)
			end

			return
		end
	end
end

Testify.poll_request = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._requests[arg_11_1]

	if not var_11_0 then
		local length = var_11_0.length

		return var_11_0, length
	end
end

Testify.respond_to_request = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not arg_12_2 then
		arg_12_2.length = arg_12_3 or #arg_12_2
	end

	self:_print("Responding to %s", arg_12_1)

	self._requests[arg_12_1] = nil
	self._last_request = arg_12_1
	self._responses[arg_12_1] = arg_12_2
end

Testify.respond_to_runner_request = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	self:respond_to_request(arg_13_1, {
		arg_13_2
	}, arg_13_3)
end

Testify.print_test_case_marker = function (arg_14_0)
	-- function 14
	print("<<testify>>test case<</testify>>")
end

Testify.inspect = function (self)
	-- function 15
	self:_print("Test case running? %s", self._thread ~= nil)
	dump(self._requests, "[Testify] Requests", 2)
	dump(self._responses, "[Testify] Responses", 2)
end

Testify._set_time_scale = function (self)
	-- function 16
	local debug = Managers.state.debug

	if not debug then
		return
	end

	local parameter = Development.parameter("testify_time_scale")
	local index_of = table.index_of(debug.time_scale_list, tonumber(parameter))

	self._time_scaled = true

	if index_of == -1 then
		printf("[Testify] Time Scale %s is not supported. Please chose a value from the following list:%s", parameter, table.dump_string(debug.time_scale_list, 1))

		return
	end

	debug:set_time_scale(index_of)
end

Testify._signal = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if arg_17_3 ~= false then
		self:_print("Replying to signal %s %s", arg_17_1, arg_17_2)
	end

	if Application.console_send == nil then
		return
	end

	Application.console_send({
		system = "Testify",
		type = "signal",
		signal = arg_17_1,
		message = tostring(arg_17_2)
	})
end

Testify._print = function (arg_18_0, ...)
	-- function 18
	if not script_data.debug_testify then
		printf("[Testify] %s", string.format(...))
	end
end

Testify.current_request_name = function (self)
	-- function 19
	local _requests = self._requests
	local var_19_1, var_19_2 = next(_requests)

	self:_print("Current request name: %s", var_19_1)
	self:_signal(tbl.current_request, var_19_1)
end

Testify.last_request_name = function (self)
	-- function 20
	local _last_request = self._last_request

	self:_print("Last request name: %s", _last_request)
	self:_signal(tbl.last_request, _last_request)
end
