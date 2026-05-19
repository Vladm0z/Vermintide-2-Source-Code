-- chunkname: @scripts/network/script_ps_restriction_token.lua

ScriptPSRestrictionToken = class(ScriptPSRestrictionToken)

function ScriptPSRestrictionToken.init(arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._done = false
end

function ScriptPSRestrictionToken.update(arg_2_0)
	local var_2_0 = NpCheck.status(arg_2_0._token)

	if var_2_0 == NpCheck.COMPLETED or var_2_0 == NpCheck.ERROR then
		arg_2_0._done = true
	end
end

function ScriptPSRestrictionToken.info(arg_3_0)
	local var_3_0 = {}

	if NpCheck.status(arg_3_0._token) == NpCheck.ERROR then
		var_3_0.error = NpCheck.error_code(arg_3_0._token)
	else
		var_3_0.result = NpCheck.result(arg_3_0._token)
	end

	var_3_0.token = arg_3_0._token

	return var_3_0
end

function ScriptPSRestrictionToken.done(arg_4_0)
	return arg_4_0._done
end

function ScriptPSRestrictionToken.close(arg_5_0)
	NpCheck.free(arg_5_0._token)
end
