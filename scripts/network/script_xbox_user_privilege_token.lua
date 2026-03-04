-- chunkname: @scripts/network/script_xbox_user_privilege_token.lua

ScriptXboxUserPrivilegeToken = class(ScriptXboxUserPrivilegeToken)

ScriptXboxUserPrivilegeToken.init = function (arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._result = {}
end

ScriptXboxUserPrivilegeToken.update = function (arg_2_0)
	local var_2_0, var_2_1, var_2_2, var_2_3 = UserPrivilege.status(arg_2_0._token)

	arg_2_0._result.in_progress = var_2_0
	arg_2_0._result.done = var_2_1
	arg_2_0._result.error = var_2_2
	arg_2_0._result.status_code = var_2_3
end

ScriptXboxUserPrivilegeToken.info = function (arg_3_0)
	local var_3_0 = {}

	if arg_3_0._result.error then
		var_3_0.error = arg_3_0._result.error
		var_3_0.status_code = arg_3_0._result.status_code
	else
		var_3_0.status_code = arg_3_0._result.status_code
	end

	return var_3_0
end

ScriptXboxUserPrivilegeToken.done = function (arg_4_0)
	return arg_4_0._result.done
end

ScriptXboxUserPrivilegeToken.close = function (arg_5_0)
	UserPrivilege.release(arg_5_0._token)
end
