-- chunkname: @scripts/managers/admin/script_rcon_server.lua

ScriptRconServer = class(ScriptRconServer)

local function fn(arg_1_0, ...)
	-- function 1
	local format = string.format(arg_1_0, ...)

	cprintf("[RCON] %s", format)
end

ScriptRconServer.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_1 then
		fn("Failed to start")

		self._enabled = false
	end

	local port = arg_2_1.port

	port = port or 27018
	self._port = port
	self._password = arg_2_1.rcon_password

	if not RConServer.start(self._port, self._password) then
		fn("Running on port %d.", self._port)
		fn("You need to open TCP port %d for incoming traffic to make the server configurable outside the LAN", self._port)

		self._dedicated_server_commands = arg_2_2
		self._clients = {}
		self._enabled = true
	else
		self._enabled = false

		fn("Failed to start")
	end
end

ScriptRconServer.destroy = function (self)
	-- function 3
	if not self._enabled then
		RConServer.stop()
	end
end

ScriptRconServer.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._enabled then
		RConServer.update(arg_4_1, self)
	end
end

ScriptRconServer.rcon_connect = function (self, arg_5_1, arg_5_2)
	-- function 5
	fassert(self._clients[arg_5_1] == nil, "Tried to connect duplicate RCON client")
	fn("Client '%s' connected", arg_5_1)

	self._clients[arg_5_1] = arg_5_2

	return true
end

ScriptRconServer.rcon_command = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._clients[arg_6_1] then
		fn("Unauthorized")

		return "Unauthorized"
	end

	local execute_command, var_6_1 = self._dedicated_server_commands:execute_command(arg_6_2)

	return var_6_1
end

ScriptRconServer.rcon_disconnect = function (self, arg_7_1)
	-- function 7
	fassert(self._clients[arg_7_1] ~= nil, "Tried to disconnect duplicate RCON client")
	fn("Client '%s' disconnected", arg_7_1)

	self._clients[arg_7_1] = nil
end
