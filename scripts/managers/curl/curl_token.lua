-- chunkname: @scripts/managers/curl/curl_token.lua

CurlToken = class(CurlToken)

CurlToken.init = function (self, arg_1_1)
	-- function 1
	self._token = arg_1_1
	self._info = {}

	if not arg_1_1 then
		self._info.done = true
		self._info.error = "Not a valid token"
	end
end

CurlToken.info = function (self)
	-- function 2
	return self._info
end

CurlToken.update = function (self)
	-- function 3
	if not self._token then
		self._info = Curl.progress(self._token)
	end
end

CurlToken.done = function (self)
	-- function 4
	return self._info.done
end

CurlToken.close = function (self)
	-- function 5
	if not self._token then
		Curl.close(self._token)
	end
end
