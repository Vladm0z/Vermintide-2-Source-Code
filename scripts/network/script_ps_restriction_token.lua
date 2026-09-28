-- chunkname: @scripts/network/script_ps_restriction_token.lua

ScriptPSRestrictionToken = class(ScriptPSRestrictionToken)

ScriptPSRestrictionToken.init = function (self, token)
	-- function 1
	self._token = token
	self._done = false
end

ScriptPSRestrictionToken.update = function (self)
	-- function 2
	local status = NpCheck.status(self._token)

	if status == NpCheck.COMPLETED or status == NpCheck.ERROR then
		self._done = true
	end
end

ScriptPSRestrictionToken.info = function (self)
	-- function 3
	local info = {}
	local status = NpCheck.status(self._token)

	if status == NpCheck.ERROR then
		info.error = NpCheck.error_code(self._token)
	else
		info.result = NpCheck.result(self._token)
	end

	info.token = self._token

	return info
end

ScriptPSRestrictionToken.done = function (self)
	-- function 4
	return self._done
end

ScriptPSRestrictionToken.close = function (self)
	-- function 5
	NpCheck.free(self._token)
end
