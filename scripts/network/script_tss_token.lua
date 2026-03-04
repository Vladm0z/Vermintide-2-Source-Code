-- chunkname: @scripts/network/script_tss_token.lua

ScriptTssToken = class(ScriptTssToken)

ScriptTssToken.init = function (arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._done = false
	arg_1_0._result = nil
end

ScriptTssToken.update = function (arg_2_0)
	local var_2_0 = arg_2_0._token
	local var_2_1 = Tss.has_result(var_2_0)

	if Tss.has_result(var_2_0) then
		local var_2_2, var_2_3 = Tss.get_result(var_2_0)

		arg_2_0._done = var_2_2
		arg_2_0._result = var_2_3
	end
end

ScriptTssToken.info = function (arg_3_0)
	return {
		result = arg_3_0._result
	}
end

ScriptTssToken.done = function (arg_4_0)
	return arg_4_0._done
end

ScriptTssToken.close = function (arg_5_0)
	Tus.free(arg_5_0._token)
end
