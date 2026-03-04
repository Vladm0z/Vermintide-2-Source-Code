-- chunkname: @scripts/managers/irc/script_irc_token.lua

ScriptIrcToken = class(ScriptIrcToken)

ScriptIrcToken.init = function (arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._result = {}
	arg_1_0._done = false
end

ScriptIrcToken.update = function (arg_2_0)
	local var_2_0, var_2_1 = Irc.connect_async_status(arg_2_0._token)

	arg_2_0._done = var_2_0
	arg_2_0._result = var_2_1
end

ScriptIrcToken.info = function (arg_3_0)
	local var_3_0 = {}

	if arg_3_0._done then
		var_3_0.result = arg_3_0._result
	end

	return var_3_0
end

ScriptIrcToken.done = function (arg_4_0)
	return arg_4_0._done
end

ScriptIrcToken.close = function (arg_5_0)
	Irc.release_token(arg_5_0._token)
end
