-- chunkname: @scripts/managers/admin/admin_manager.lua

require("scripts/managers/admin/script_rcon_server")

AdminManager = class(AdminManager)

AdminManager.init = function (self)
	-- function 1
	if not DEDICATED_SERVER then
		local window_title = script_data.window_title

		if type(window_title) == "table" then
			window_title = table.concat(window_title, " ")
		end

		CommandWindow.open(window_title or "Dedicated Server")
		cprintf("Version: content '%s', engine '%s'", script_data.settings.content_revision, script_data.build_identifier)

		local start_port_range = script_data.start_port_range
		local var_1_2

		if not start_port_range then
			var_1_2 = tonumber(start_port_range) + 3
		else
			var_1_2 = script_data.rcon_port or script_data.settings.rcon_port or Managers.mechanism:mechanism_setting("rcon_port")
		end

		local tbl = {
			port = var_1_2
		}
		local rcon_password = script_data.rcon_password

		if not rcon_password then
			rcon_password = script_data.settings.rcon_password
			rcon_password = rcon_password or "rconpassword"
		end

		tbl.rcon_password = rcon_password
		self._dedicated_server_commands = DedicatedServerCommands:new()
		self._rcon_server = ScriptRconServer:new(tbl, self._dedicated_server_commands)
	end
end

AdminManager.destroy = function (self)
	-- function 2
	if self._rcon_server ~= nil then
		self._rcon_server:destroy()
	end

	if not DEDICATED_SERVER then
		CommandWindow.close()
	end
end

AdminManager.update = function (self, arg_3_1)
	-- function 3
	if self._rcon_server ~= nil then
		self._rcon_server:update(arg_3_1)
	end
end

AdminManager.execute_command = function (self, arg_4_1)
	-- function 4
	self._dedicated_server_commands:execute_command(arg_4_1)
end
