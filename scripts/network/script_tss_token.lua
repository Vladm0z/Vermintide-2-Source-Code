-- chunkname: @scripts/network/script_tss_token.lua

ScriptTssToken = class(ScriptTssToken)

ScriptTssToken.init = function (self, token)
	-- function 1
	self._token = token
	self._done = false
	self._result = nil
end

ScriptTssToken.update = function (self)
	-- function 2
	local token = self._token
	local done = Tss.has_result(token)

	if Tss.has_result(token) then
		local done, result = Tss.get_result(token)

		self._done = done
		self._result = result
	end
end

ScriptTssToken.info = function (self)
	-- function 3
	local info = {}

	info.result = self._result

	return info
end

ScriptTssToken.done = function (self)
	-- function 4
	return self._done
end

ScriptTssToken.close = function (self)
	-- function 5
	Tus.free(self._token)
end
