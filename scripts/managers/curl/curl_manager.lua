-- chunkname: @scripts/managers/curl/curl_manager.lua

CurlManager = class(CurlManager)

local var_0_0 = {
	[0] = "info_text",
	"info_header_in",
	"info_header_out",
	"info_data_in",
	"info_data_out",
	"info_ssl_data_in",
	"info_ssl_data_out"
}

local function var_0_1(arg_1_0, arg_1_1)
	printf("[CURL] %s: %s", var_0_0[arg_1_0], arg_1_1)
end

CurlManager.init = function (arg_2_0)
	arg_2_0._curl = lcurl.stingray_init()
	arg_2_0._multi = arg_2_0._curl.multi()
	arg_2_0._requests = {}
end

CurlManager.destroy = function (arg_3_0)
	local var_3_0 = os.time() + 10

	while arg_3_0:_num_requests() > 0 do
		arg_3_0:update(false)

		if var_3_0 < os.time() then
			print("Not all curl requests were successfully handled")

			break
		end
	end

	for iter_3_0, iter_3_1 in pairs(arg_3_0._requests) do
		iter_3_0:close()
	end
end

local var_0_2 = {}

var_0_2.__index = var_0_2

var_0_2.new = function ()
	local var_4_0 = setmetatable({}, var_0_2)

	var_4_0.headers = {}

	return var_4_0
end

var_0_2.OnResponse = function (arg_5_0, arg_5_1)
	arg_5_0.data = arg_5_0.data and arg_5_0.data .. arg_5_1 or arg_5_1
end

var_0_2.OnHeader = function (arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = arg_6_1:match("([^:]+):%s+([^:]+)")

	if var_6_0 ~= nil then
		arg_6_0.headers[var_6_0] = string.gsub(var_6_1, "\r\n", "")
	end
end

CurlManager.update = function (arg_7_0, arg_7_1)
	DeadlockStack.pause()

	if arg_7_0._multi:perform() > 0 then
		arg_7_0._multi:wait(0)
	end

	DeadlockStack.unpause()

	local var_7_0, var_7_1, var_7_2 = arg_7_0._multi:info_read()

	if var_7_0 ~= 0 then
		local var_7_3 = arg_7_0._requests[var_7_0]

		if var_7_3 ~= nil then
			if arg_7_1 and var_7_3.cb then
				local var_7_4 = var_7_0:getinfo(arg_7_0._curl.INFO_RESPONSE_CODE)

				if var_7_1 then
					var_7_3.cb(true, var_7_4, var_7_3.headers, var_7_3.data, var_7_3.userdata)
				else
					Application.warning("Curl Manager Error, Code: %s, Url: %s, Name: %s", tostring(var_7_4), var_7_3.url, tostring(var_7_2:name()))
					var_7_3.cb(false, var_7_4, {}, var_7_2:name(), var_7_3.userdata)
				end
			end

			arg_7_0._requests[var_7_0] = nil
		end

		var_7_0:close()
	end
end

CurlManager._num_requests = function (arg_8_0)
	return table.size(arg_8_0._requests)
end

CurlManager.add_request = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = arg_9_0._curl.easy()

	var_9_0:setopt_url(arg_9_2)
	var_9_0:setopt_customrequest(arg_9_1)

	if arg_9_4 ~= nil then
		if type(arg_9_4) == "table" then
			var_9_0:setopt_httpheader(arg_9_4)
		else
			var_9_0:setopt_httpheader({
				arg_9_4
			})
		end
	end

	if arg_9_7 ~= nil then
		for iter_9_0, iter_9_1 in pairs(arg_9_7) do
			var_9_0:setopt(iter_9_0, iter_9_1)
		end
	end

	if arg_9_3 ~= nil then
		var_9_0:setopt_postfields(arg_9_3)
	end

	local var_9_1 = var_0_2.new()

	var_9_1.cb = arg_9_5
	var_9_1.userdata = arg_9_6
	var_9_1.url = arg_9_2

	local var_9_2 = callback(var_9_1, "OnResponse")
	local var_9_3 = callback(var_9_1, "OnHeader")

	var_9_0:setopt_writefunction(var_9_2)
	var_9_0:setopt_headerfunction(var_9_3)
	arg_9_0._multi:add_handle(var_9_0)

	arg_9_0._requests[var_9_0] = var_9_1
end

CurlManager.get = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	arg_10_0:add_request("GET", arg_10_1, nil, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
end

CurlManager.post = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	arg_11_0:add_request("POST", arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
end

CurlManager.put = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	arg_12_0:add_request("PUT", arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
end

CurlManager.delete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	arg_13_0:add_request("DELETE", arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
end

CurlManager.patch = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	arg_14_0:add_request("PATCH", arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
end

local function var_0_3(arg_15_0)
	local var_15_0 = false

	return function ()
		if var_15_0 == false then
			var_15_0 = true

			return arg_15_0
		end
	end
end

CurlManager.upload = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0._curl.easy()

	var_17_0:setopt_url(arg_17_1)
	var_17_0:setopt_upload(true)
	var_17_0:setopt_readfunction(var_0_3(arg_17_2))

	local var_17_1 = var_0_2.new()

	var_17_1.cb = arg_17_3

	arg_17_0._multi:add_handle(var_17_0)

	arg_17_0._requests[var_17_0] = var_17_1
end
