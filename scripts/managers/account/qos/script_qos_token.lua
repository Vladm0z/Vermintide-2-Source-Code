-- chunkname: @scripts/managers/account/qos/script_qos_token.lua

ScriptQoSToken = class(ScriptQoSToken)

ScriptQoSToken.init = function (arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._result = {}
	arg_1_0._done = false
end

ScriptQoSToken.update = function (arg_2_0)
	local var_2_0, var_2_1, var_2_2, var_2_3 = QoS.status(arg_2_0._token)

	arg_2_0._done = var_2_1
	arg_2_0._result_code = var_2_3
end

ScriptQoSToken.info = function (arg_3_0)
	local var_3_0 = {}
	local var_3_1 = bit.band(arg_3_0._result_code, QoS.UP_FAILED) > 0
	local var_3_2 = bit.band(arg_3_0._result_code, QoS.DOWN_FAILED) > 0

	var_3_0.up_failed = var_3_1
	var_3_0.down_failed = var_3_2

	if var_3_1 or var_3_2 then
		local var_3_3 = "Your"
		local var_3_4 = var_3_1 and " upload bandwidth " or ""
		local var_3_5 = var_3_2 and " download bandwidth " or ""

		var_3_0.error = var_3_3 .. var_3_4 .. (var_3_1 and var_3_2 and "and" or "") .. var_3_5 .. (var_3_1 and var_3_2 and "are too low" or "is too low")
	end

	return var_3_0
end

ScriptQoSToken.done = function (arg_4_0)
	return arg_4_0._done
end

ScriptQoSToken.close = function (arg_5_0)
	QoS.release(arg_5_0._token)
end
