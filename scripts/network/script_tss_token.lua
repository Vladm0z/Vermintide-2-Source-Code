-- chunkname: @scripts/network/script_tss_token.lua

ScriptTssToken = class(ScriptTssToken)

ScriptTssToken.init = function (self, arg_1_1)
	-- function 1
	self._token = arg_1_1
	self._done = false
	self._result = nil
end

ScriptTssToken.update = function (self)
	-- function 2
	local _token = self._token
	local has_result = Tss.has_result(_token)

	if not Tss.has_result(_token) then
		local get_result, var_2_3 = Tss.get_result(_token)

		self._done = get_result
		self._result = var_2_3
	end
end

ScriptTssToken.info = function (self)
	-- function 3
	return {
		result = self._result
	}
end

ScriptTssToken.done = function (self)
	-- function 4
	return self._done
end

ScriptTssToken.close = function (self)
	-- function 5
	Tus.free(self._token)
end
