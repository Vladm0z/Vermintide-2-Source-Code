-- chunkname: @scripts/misc/script_retrieve_app_ticket_token.lua

ScriptReceiveAppTicketToken = class(ScriptReceiveAppTicketToken)

ScriptReceiveAppTicketToken.init = function (self)
	-- function 1
	self._done = false
	self._error = true
end

ScriptReceiveAppTicketToken.update = function (self)
	-- function 2
	local poll_encrypted_app_ticket = Steam.poll_encrypted_app_ticket()

	if not poll_encrypted_app_ticket then
		self._encrypted_app_ticket = string.tohex(poll_encrypted_app_ticket)
		self._done = true
		self._error = false
	end
end

ScriptReceiveAppTicketToken.info = function (self)
	-- function 3
	return {
		encrypted_app_ticket = self._encrypted_app_ticket,
		error = self._error
	}
end

ScriptReceiveAppTicketToken.done = function (self)
	-- function 4
	return self._done
end

ScriptReceiveAppTicketToken.close = function (arg_5_0)
	-- function 5
	return
end
