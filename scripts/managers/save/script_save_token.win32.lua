-- chunkname: @scripts/managers/save/script_save_token.win32.lua

ScriptSaveToken = class(ScriptSaveToken)

ScriptSaveToken.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._adapter = arg_1_1
	self._token = arg_1_2
	self._info = {}
end

ScriptSaveToken.update = function (self)
	-- function 2
	self._info = self._adapter.progress(self._token)
end

ScriptSaveToken.info = function (self)
	-- function 3
	return self._info
end

ScriptSaveToken.done = function (self)
	-- function 4
	return self._info.done
end

ScriptSaveToken.close = function (self)
	-- function 5
	self._adapter.close(self._token)
end
