-- chunkname: @scripts/managers/presence/script_presence_token.lua

ScriptPresenceToken = class(ScriptPresenceToken)

ScriptPresenceToken.init = function (self, arg_1_1)
	-- function 1
	self._token = arg_1_1
	self._result = {}
	self._done = false
end

ScriptPresenceToken.update = function (self)
	-- function 2
	local status, var_2_1, var_2_2 = Presence.status(self._token)

	self._done = status
	self._presence = var_2_1
	self._error_code = var_2_2
end

ScriptPresenceToken.info = function (self)
	-- function 3
	local tbl = {}

	if not self._error_code then
		tbl.error_code = self._error_code
	elseif not self._presence then
		tbl.presence = self._presence
	end

	return tbl
end

ScriptPresenceToken.done = function (self)
	-- function 4
	return self._done
end

ScriptPresenceToken.close = function (self)
	-- function 5
	Presence.close(self._token)
end
