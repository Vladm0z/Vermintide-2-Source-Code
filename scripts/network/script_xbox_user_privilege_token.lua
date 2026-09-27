-- chunkname: @scripts/network/script_xbox_user_privilege_token.lua

ScriptXboxUserPrivilegeToken = class(ScriptXboxUserPrivilegeToken)

ScriptXboxUserPrivilegeToken.init = function (self, arg_1_1)
	-- function 1
	self._token = arg_1_1
	self._result = {}
end

ScriptXboxUserPrivilegeToken.update = function (self)
	-- function 2
	local status, var_2_1, var_2_2, var_2_3 = UserPrivilege.status(self._token)

	self._result.in_progress = status
	self._result.done = var_2_1
	self._result.error = var_2_2
	self._result.status_code = var_2_3
end

ScriptXboxUserPrivilegeToken.info = function (self)
	-- function 3
	local tbl = {}

	if not self._result.error then
		tbl.error = self._result.error
		tbl.status_code = self._result.status_code
	else
		tbl.status_code = self._result.status_code
	end

	return tbl
end

ScriptXboxUserPrivilegeToken.done = function (self)
	-- function 4
	return self._result.done
end

ScriptXboxUserPrivilegeToken.close = function (self)
	-- function 5
	UserPrivilege.release(self._token)
end
