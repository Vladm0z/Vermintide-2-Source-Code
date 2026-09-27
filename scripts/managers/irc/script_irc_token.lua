-- chunkname: @scripts/managers/irc/script_irc_token.lua

ScriptIrcToken = class(ScriptIrcToken)

ScriptIrcToken.init = function (self, arg_1_1)
	-- function 1
	self._token = arg_1_1
	self._result = {}
	self._done = false
end

ScriptIrcToken.update = function (self)
	-- function 2
	local connect_async_status, var_2_1 = Irc.connect_async_status(self._token)

	self._done = connect_async_status
	self._result = var_2_1
end

ScriptIrcToken.info = function (self)
	-- function 3
	local tbl = {}

	if not self._done then
		tbl.result = self._result
	end

	return tbl
end

ScriptIrcToken.done = function (self)
	-- function 4
	return self._done
end

ScriptIrcToken.close = function (self)
	-- function 5
	Irc.release_token(self._token)
end
