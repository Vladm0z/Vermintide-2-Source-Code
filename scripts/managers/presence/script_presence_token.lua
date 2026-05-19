-- chunkname: @scripts/managers/presence/script_presence_token.lua

ScriptPresenceToken = class(ScriptPresenceToken)

function ScriptPresenceToken.init(arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._result = {}
	arg_1_0._done = false
end

function ScriptPresenceToken.update(arg_2_0)
	local var_2_0, var_2_1, var_2_2 = Presence.status(arg_2_0._token)

	arg_2_0._done = var_2_0
	arg_2_0._presence = var_2_1
	arg_2_0._error_code = var_2_2
end

function ScriptPresenceToken.info(arg_3_0)
	local var_3_0 = {}

	if arg_3_0._error_code then
		var_3_0.error_code = arg_3_0._error_code
	elseif arg_3_0._presence then
		var_3_0.presence = arg_3_0._presence
	end

	return var_3_0
end

function ScriptPresenceToken.done(arg_4_0)
	return arg_4_0._done
end

function ScriptPresenceToken.close(arg_5_0)
	Presence.close(arg_5_0._token)
end
