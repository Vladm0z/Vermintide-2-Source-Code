-- chunkname: @scripts/managers/curl/curl_manager.lua

CurlManager = class(CurlManager)

local curl_info_types = {
	[0] = "info_text",
	"info_header_in",
	"info_header_out",
	"info_data_in",
	"info_data_out",
	"info_ssl_data_in",
	"info_ssl_data_out"
}

local function debug_output(type, data)
	-- function 1
	printf("[CURL] %s: %s", curl_info_types[type], data)
end

CurlManager.init = function (self)
	-- function 2
	self._curl = lcurl.stingray_init()
	self._multi = self._curl.multi()
	self._requests = {}
end

CurlManager.destroy = function (self)
	-- function 3
	local timeout_at = os.time() + 10

	while self:_num_requests() > 0 do
		self:update(false)

		if timeout_at < os.time() then
			print("Not all curl requests were successfully handled")

			break
		end
	end

	for handle, request in pairs(self._requests) do
		handle:close()
	end
end

local Request = {}

Request.__index = Request

Request.new = function ()
	-- function 4
	local self = setmetatable({}, Request)

	self.headers = {}

	return self
end

Request.OnResponse = function (self, data)
	-- function 5
	self.data = self.data and self.data .. data or not self.data and data
end

Request.OnHeader = function (self, data)
	-- function 6
	local k, v = data:match("([^:]+):%s+([^:]+)")

	if k ~= nil then
		self.headers[k] = string.gsub(v, "\r\n", "")
	end
end

CurlManager.update = function (self, handle_callbacks)
	-- function 7
	DeadlockStack.pause()

	if self._multi:perform() > 0 then
		self._multi:wait(0)
	end

	DeadlockStack.unpause()

	local handle, ok, err = self._multi:info_read()

	if handle ~= 0 then
		local request = self._requests[handle]

		if request ~= nil then
			if handle_callbacks and request.cb then
				local code = handle:getinfo(self._curl.INFO_RESPONSE_CODE)

				if ok then
					request.cb(true, code, request.headers, request.data, request.userdata)
				else
					Application.warning("Curl Manager Error, Code: %s, Url: %s, Name: %s", tostring(code), request.url, tostring(err:name()))
					request.cb(false, code, {}, err:name(), request.userdata)
				end
			end

			self._requests[handle] = nil
		end

		handle:close()
	end
end

CurlManager._num_requests = function (self)
	-- function 8
	return table.size(self._requests)
end

CurlManager.add_request = function (self, request_type, url, body, headers, user_cb, userdata, options)
	-- function 9
	local easy = self._curl.easy()

	easy:setopt_url(url)
	easy:setopt_customrequest(request_type)

	if headers ~= nil then
		if type(headers) == "table" then
			easy:setopt_httpheader(headers)
		else
			easy:setopt_httpheader({
				headers
			})
		end
	end

	if options ~= nil then
		for k, v in pairs(options) do
			easy:setopt(k, v)
		end
	end

	if body ~= nil then
		easy:setopt_postfields(body)
	end

	local request = Request.new()

	request.cb = user_cb
	request.userdata = userdata
	request.url = url

	local response_cb = callback(request, "OnResponse")
	local header_cb = callback(request, "OnHeader")

	easy:setopt_writefunction(response_cb)
	easy:setopt_headerfunction(header_cb)
	self._multi:add_handle(easy)

	self._requests[easy] = request
end

CurlManager.get = function (self, url, headers, request_cb, userdata, options)
	-- function 10
	self:add_request("GET", url, nil, headers, request_cb, userdata, options)
end

CurlManager.post = function (self, url, body, headers, request_cb, userdata, options)
	-- function 11
	self:add_request("POST", url, body, headers, request_cb, userdata, options)
end

CurlManager.put = function (self, url, body, headers, request_cb, userdata, options)
	-- function 12
	self:add_request("PUT", url, body, headers, request_cb, userdata, options)
end

CurlManager.delete = function (self, url, body, headers, request_cb, userdata, options)
	-- function 13
	self:add_request("DELETE", url, body, headers, request_cb, userdata, options)
end

CurlManager.patch = function (self, url, body, headers, request_cb, userdata, options)
	-- function 14
	self:add_request("PATCH", url, body, headers, request_cb, userdata, options)
end

local function create_read_function(data)
	-- function 15
	local sent = false

	return function ()
		-- function 16
		if sent == false then
			sent = true

			return data
		end
	end
end

CurlManager.upload = function (self, url, data, cb)
	-- function 17
	local easy = self._curl.easy()

	easy:setopt_url(url)
	easy:setopt_upload(true)
	easy:setopt_readfunction(create_read_function(data))

	local request = Request.new()

	request.cb = cb

	self._multi:add_handle(easy)

	self._requests[easy] = request
end
