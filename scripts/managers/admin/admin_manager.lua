-- chunkname: @scripts/managers/admin/admin_manager.lua

require("scripts/managers/admin/script_rcon_server")

AdminManager = class(AdminManager)

AdminManager.init = function (arg_1_0)
	if DEDICATED_SERVER then
		local var_1_0 = script_data.window_title

		if type(var_1_0) == "table" then
			var_1_0 = table.concat(var_1_0, " ")
		end

		CommandWindow.open(var_1_0 or "Dedicated Server")
		cprintf("Version: content '%s', engine '%s'", script_data.settings.content_revision, script_data.build_identifier)

		local var_1_1 = script_data.start_port_range
		local var_1_2

		if var_1_1 then
			var_1_2 = tonumber(var_1_1) + 3
		else
			var_1_2 = script_data.rcon_port or script_data.settings.rcon_port or Managers.mechanism:mechanism_setting("rcon_port")
		end

		local var_1_3 = {
			port = var_1_2,
			rcon_password = script_data.rcon_password or script_data.settings.rcon_password or "rconpassword"
		}

		arg_1_0._dedicated_server_commands = DedicatedServerCommands:new()
		arg_1_0._rcon_server = ScriptRconServer:new(var_1_3, arg_1_0._dedicated_server_commands)
	end
end

AdminManager.destroy = function (arg_2_0)
	if arg_2_0._rcon_server ~= nil then
		arg_2_0._rcon_server:destroy()
	end

	if DEDICATED_SERVER then
		CommandWindow.close()
	end
end

AdminManager.update = function (arg_3_0, arg_3_1)
	if arg_3_0._rcon_server ~= nil then
		arg_3_0._rcon_server:update(arg_3_1)
	end
end

AdminManager.execute_command = function (arg_4_0, arg_4_1)
	arg_4_0._dedicated_server_commands:execute_command(arg_4_1)
end
