-- chunkname: @scripts/managers/account/script_web_api_psn.lua

ScriptWebApiPsn = class(ScriptWebApiPsn)

local var_0_0 = WebApi
local var_0_1 = {
	[var_0_0.GET] = "GET",
	[var_0_0.PUT] = "PUT",
	[var_0_0.POST] = "POST",
	[var_0_0.DELETE] = "DELETE"
}

function ScriptWebApiPsn.init(arg_1_0)
	arg_1_0._requests = {}
end

function ScriptWebApiPsn.destroy(arg_2_0)
	local var_2_0 = arg_2_0._requests

	for iter_2_0 = #var_2_0, 1, -1 do
		local var_2_1 = var_2_0[iter_2_0]

		var_0_0.free(var_2_1.id)
	end

	arg_2_0._requests = nil
end

function ScriptWebApiPsn.update(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._requests

	for iter_3_0 = #var_3_0, 1, -1 do
		local var_3_1 = var_3_0[iter_3_0].id
		local var_3_2 = var_0_0.status(var_3_1)

		if var_3_2 == var_0_0.COMPLETED then
			arg_3_0:_handle_request_response(iter_3_0, true)
		elseif var_3_2 == var_0_0.ERROR then
			arg_3_0:_handle_request_response(iter_3_0, false)
		end
	end
end

function ScriptWebApiPsn._handle_request_response(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._requests[arg_4_1]
	local var_4_1 = var_4_0.id
	local var_4_2 = var_4_0.response_callback
	local var_4_3 = var_4_0.response_format or var_0_0.TABLE

	if arg_4_2 then
		if script_data.debug_psn then
			printf("[ScriptWebApiPsn] Completed Request: %q", var_4_0.debug_text)
		end

		if var_4_2 then
			local var_4_4 = var_0_0.request_result(var_4_1, var_4_3)

			var_4_2(var_4_4)
		end
	else
		if script_data.debug_psn then
			printf("[ScriptWebApiPsn] Failed Request: %q", var_4_0.debug_text)
		end

		if var_4_2 then
			var_4_2(nil)
		end
	end

	var_0_0.free(var_4_1)
	table.remove(arg_4_0._requests, arg_4_1)
end

function ScriptWebApiPsn.send_request(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	if arg_5_1 == nil then
		return
	end

	local var_5_0 = var_0_0.send_request(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)

	arg_5_0._requests[#arg_5_0._requests + 1] = {
		id = var_5_0,
		response_callback = arg_5_6,
		response_format = arg_5_7,
		debug_text = string.format("%s %s", var_0_1[arg_5_4], arg_5_3)
	}
end

function ScriptWebApiPsn.send_request_create_session(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = var_0_0.send_request_create_session(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)

	arg_6_0._requests[#arg_6_0._requests + 1] = {
		debug_text = "POST /v1/sessions",
		id = var_6_0,
		response_callback = arg_6_6
	}
end

function ScriptWebApiPsn.send_request_session_invitation(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = var_0_0.send_request_session_invitation(arg_7_1, arg_7_2, arg_7_3)

	arg_7_0._requests[#arg_7_0._requests + 1] = {
		id = var_7_0,
		debug_text = string.format("POST /v1/sessions/%s/invitations", arg_7_3)
	}
end
