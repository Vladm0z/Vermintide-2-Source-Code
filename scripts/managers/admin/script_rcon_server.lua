-- chunkname: @scripts/managers/admin/script_rcon_server.lua

ScriptRconServer = class(ScriptRconServer)

local function var_0_0(arg_1_0, ...)
	local var_1_0 = string.format(arg_1_0, ...)

	cprintf("[RCON] %s", var_1_0)
end

function ScriptRconServer.init(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_1 then
		var_0_0("Failed to start")

		arg_2_0._enabled = false
	end

	arg_2_0._port = arg_2_1.port or 27018
	arg_2_0._password = arg_2_1.rcon_password

	if RConServer.start(arg_2_0._port, arg_2_0._password) then
		var_0_0("Running on port %d.", arg_2_0._port)
		var_0_0("You need to open TCP port %d for incoming traffic to make the server configurable outside the LAN", arg_2_0._port)

		arg_2_0._dedicated_server_commands = arg_2_2
		arg_2_0._clients = {}
		arg_2_0._enabled = true
	else
		arg_2_0._enabled = false

		var_0_0("Failed to start")
	end
end

function ScriptRconServer.destroy(arg_3_0)
	if arg_3_0._enabled then
		RConServer.stop()
	end
end

function ScriptRconServer.update(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._enabled then
		RConServer.update(arg_4_1, arg_4_0)
	end
end

function ScriptRconServer.rcon_connect(arg_5_0, arg_5_1, arg_5_2)
	fassert(arg_5_0._clients[arg_5_1] == nil, "Tried to connect duplicate RCON client")
	var_0_0("Client '%s' connected", arg_5_1)

	arg_5_0._clients[arg_5_1] = arg_5_2

	return true
end

function ScriptRconServer.rcon_command(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._clients[arg_6_1] then
		var_0_0("Unauthorized")

		return "Unauthorized"
	end

	local var_6_0, var_6_1 = arg_6_0._dedicated_server_commands:execute_command(arg_6_2)

	return var_6_1
end

function ScriptRconServer.rcon_disconnect(arg_7_0, arg_7_1)
	fassert(arg_7_0._clients[arg_7_1] ~= nil, "Tried to disconnect duplicate RCON client")
	var_0_0("Client '%s' disconnected", arg_7_1)

	arg_7_0._clients[arg_7_1] = nil
end
