-- chunkname: @scripts/managers/account/script_web_api_psn.lua

ScriptWebApiPsn = class(ScriptWebApiPsn)

local WebApi = WebApi
local tbl = {
	[WebApi.GET] = "GET",
	[WebApi.PUT] = "PUT",
	[WebApi.POST] = "POST",
	[WebApi.DELETE] = "DELETE"
}

ScriptWebApiPsn.init = function (self)
	-- function 1
	self._requests = {}
end

ScriptWebApiPsn.destroy = function (self)
	-- function 2
	local _requests = self._requests

	for i = #_requests, 1, -1 do
		local var_2_1 = _requests[i]

		WebApi.free(var_2_1.id)
	end

	self._requests = nil
end

ScriptWebApiPsn.update = function (self, arg_3_1)
	-- function 3
	local _requests = self._requests

	for i = #_requests, 1, -1 do
		local id = _requests[i].id
		local status = WebApi.status(id)

		if status == WebApi.COMPLETED then
			self:_handle_request_response(i, true)
		elseif status == WebApi.ERROR then
			self:_handle_request_response(i, false)
		end
	end
end

ScriptWebApiPsn._handle_request_response = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self._requests[arg_4_1]
	local id = var_4_0.id
	local response_callback = var_4_0.response_callback
	local response_format = var_4_0.response_format

	response_format = response_format or WebApi.TABLE

	if not arg_4_2 then
		if not script_data.debug_psn then
			printf("[ScriptWebApiPsn] Completed Request: %q", var_4_0.debug_text)
		end

		if not response_callback then
			local request_result = WebApi.request_result(id, response_format)

			response_callback(request_result)
		end
	else
		if not script_data.debug_psn then
			printf("[ScriptWebApiPsn] Failed Request: %q", var_4_0.debug_text)
		end

		if not response_callback then
			response_callback(nil)
		end
	end

	WebApi.free(id)
	table.remove(self._requests, arg_4_1)
end

ScriptWebApiPsn.send_request = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	-- function 5
	if arg_5_1 == nil then
		return
	end

	local send_request = WebApi.send_request(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)

	arg_5_0._requests[#arg_5_0._requests + 1] = {
		id = send_request,
		response_callback = arg_5_6,
		response_format = arg_5_7,
		debug_text = string.format("%s %s", tbl[arg_5_4], arg_5_3)
	}
end

ScriptWebApiPsn.send_request_create_session = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	local send_request_create_session = WebApi.send_request_create_session(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)

	arg_6_0._requests[#arg_6_0._requests + 1] = {
		debug_text = "POST /v1/sessions",
		id = send_request_create_session,
		response_callback = arg_6_6
	}
end

ScriptWebApiPsn.send_request_session_invitation = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local send_request_session_invitation = WebApi.send_request_session_invitation(arg_7_1, arg_7_2, arg_7_3)

	arg_7_0._requests[#arg_7_0._requests + 1] = {
		id = send_request_session_invitation,
		debug_text = string.format("POST /v1/sessions/%s/invitations", arg_7_3)
	}
end
