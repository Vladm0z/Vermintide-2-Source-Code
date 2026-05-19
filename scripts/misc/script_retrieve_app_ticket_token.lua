-- chunkname: @scripts/misc/script_retrieve_app_ticket_token.lua

ScriptReceiveAppTicketToken = class(ScriptReceiveAppTicketToken)

function ScriptReceiveAppTicketToken.init(arg_1_0)
	arg_1_0._done = false
	arg_1_0._error = true
end

function ScriptReceiveAppTicketToken.update(arg_2_0)
	local var_2_0 = Steam.poll_encrypted_app_ticket()

	if var_2_0 then
		arg_2_0._encrypted_app_ticket = string.tohex(var_2_0)
		arg_2_0._done = true
		arg_2_0._error = false
	end
end

function ScriptReceiveAppTicketToken.info(arg_3_0)
	return {
		encrypted_app_ticket = arg_3_0._encrypted_app_ticket,
		error = arg_3_0._error
	}
end

function ScriptReceiveAppTicketToken.done(arg_4_0)
	return arg_4_0._done
end

function ScriptReceiveAppTicketToken.close(arg_5_0)
	return
end
