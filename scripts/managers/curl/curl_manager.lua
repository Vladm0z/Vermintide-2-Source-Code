-- chunkname: @scripts/managers/curl/curl_manager.lua

CurlManager = class(CurlManager)

local tbl = {
	[0] = "info_text",
	"info_header_in",
	"info_header_out",
	"info_data_in",
	"info_data_out",
	"info_ssl_data_in",
	"info_ssl_data_out"
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	printf("[CURL] %s: %s", tbl[arg_1_0], arg_1_1)
end

CurlManager.init = function (self)
	-- function 2
	self._curl = lcurl.stingray_init()
	self._multi = self._curl.multi()
	self._requests = {}
end

CurlManager.destroy = function (self)
	-- function 3
	local num = os.time() + 10

	while self:_num_requests() > 0 do
		self:update(false)

		if num < os.time() then
			print("Not all curl requests were successfully handled")

			break
		end
	end

	for k, v in pairs(self._requests) do
		k:close()
	end
end

local tbl_2 = {}

tbl_2.__index = tbl_2

tbl_2.new = function ()
	-- function 4
	local var_4_0 = setmetatable({}, tbl_2)

	var_4_0.headers = {}

	return var_4_0
end

tbl_2.OnResponse = function (self, arg_5_1)
	-- function 5
	local str

	if not self.data then
		str = self.data .. arg_5_1

		if not str then
			-- Nothing
		end
	end

	str = arg_5_1

	::label_5_0::

	self.data = str
end

tbl_2.OnHeader = function (arg_6_0, arg_6_1)
	-- function 6
	local match, var_6_1 = arg_6_1:match("([^:]+):%s+([^:]+)")

	if match ~= nil then
		arg_6_0.headers[match] = string.gsub(var_6_1, "\r\n", "")
	end
end

CurlManager.update = function (self, arg_7_1)
	-- function 7
	DeadlockStack.pause()

	if self._multi:perform() > 0 then
		self._multi:wait(0)
	end

	DeadlockStack.unpause()

	local info_read, var_7_1, var_7_2 = self._multi:info_read()

	if info_read ~= 0 then
		local var_7_3 = self._requests[info_read]

		if var_7_3 ~= nil then
			if not arg_7_1 and not var_7_3.cb then
				local getinfo = info_read:getinfo(self._curl.INFO_RESPONSE_CODE)

				if not var_7_1 then
					var_7_3.cb(true, getinfo, var_7_3.headers, var_7_3.data, var_7_3.userdata)
				else
					Application.warning("Curl Manager Error, Code: %s, Url: %s, Name: %s", tostring(getinfo), var_7_3.url, tostring(var_7_2:name()))
					var_7_3.cb(false, getinfo, {}, var_7_2:name(), var_7_3.userdata)
				end
			end

			self._requests[info_read] = nil
		end

		info_read:close()
	end
end

CurlManager._num_requests = function (self)
	-- function 8
	return table.size(self._requests)
end

CurlManager.add_request = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local easy = self._curl.easy()

	easy:setopt_url(arg_9_2)
	easy:setopt_customrequest(arg_9_1)

	if arg_9_4 ~= nil then
		if type(arg_9_4) == "table" then
			easy:setopt_httpheader(arg_9_4)
		else
			easy:setopt_httpheader({
				arg_9_4
			})
		end
	end

	if arg_9_7 ~= nil then
		for k, v in pairs(arg_9_7) do
			easy:setopt(k, v)
		end
	end

	if arg_9_3 ~= nil then
		easy:setopt_postfields(arg_9_3)
	end

	local var_9_1 = tbl_2.new()

	var_9_1.cb = arg_9_5
	var_9_1.userdata = arg_9_6
	var_9_1.url = arg_9_2

	local var_9_2 = callback(var_9_1, "OnResponse")
	local var_9_3 = callback(var_9_1, "OnHeader")

	easy:setopt_writefunction(var_9_2)
	easy:setopt_headerfunction(var_9_3)
	self._multi:add_handle(easy)

	self._requests[easy] = var_9_1
end

CurlManager.get = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	self:add_request("GET", arg_10_1, nil, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
end

CurlManager.post = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	self:add_request("POST", arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
end

CurlManager.put = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	self:add_request("PUT", arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
end

CurlManager.delete = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	self:add_request("DELETE", arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
end

CurlManager.patch = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	self:add_request("PATCH", arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
end

local function fn_2(arg_15_0)
	-- function 15
	local flag = false

	return function ()
		-- function 16
		if flag == false then
			flag = true

			return arg_15_0
		end
	end
end

CurlManager.upload = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local easy = self._curl.easy()

	easy:setopt_url(arg_17_1)
	easy:setopt_upload(true)
	easy:setopt_readfunction(fn_2(arg_17_2))

	local var_17_1 = tbl_2.new()

	var_17_1.cb = arg_17_3

	self._multi:add_handle(easy)

	self._requests[easy] = var_17_1
end
