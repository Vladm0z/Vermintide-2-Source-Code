-- chunkname: @scripts/managers/admin/admin_manager.lua

require("scripts/managers/admin/script_rcon_server")

AdminManager = class(AdminManager)

AdminManager.init = function (self)
	-- function 1
	if DEDICATED_SERVER then
		local window_title = script_data.window_title

		if type(window_title) == "table" then
			window_title = table.concat(window_title, " ")
		end

		CommandWindow.open(not not window_title or not not "Dedicated Server")
		cprintf("Version: content '%s', engine '%s'", script_data.settings.content_revision, script_data.build_identifier)

		local start_port_range = script_data.start_port_range
		local rcon_port

		if start_port_range then
			start_port_range = tonumber(start_port_range)
			rcon_port = start_port_range + 3
		else
			rcon_port = not not script_data.rcon_port or not not script_data.settings.rcon_port or not not Managers.mechanism:mechanism_setting("rcon_port")
		end

		local tbl = {
			port = rcon_port
		}
		local rcon_password = script_data.rcon_password

		if not rcon_password then
			rcon_password = script_data.settings.rcon_password
			rcon_password = not not rcon_password or not not "rconpassword"
		end

		tbl.rcon_password = rcon_password

		local settings = tbl

		self._dedicated_server_commands = DedicatedServerCommands:new()
		self._rcon_server = ScriptRconServer:new(settings, self._dedicated_server_commands)
	end
end

AdminManager.destroy = function (self)
	-- function 2
	if self._rcon_server ~= nil then
		self._rcon_server:destroy()
	end

	if DEDICATED_SERVER then
		CommandWindow.close()
	end
end

AdminManager.update = function (self, dt)
	-- function 3
	if self._rcon_server ~= nil then
		self._rcon_server:update(dt)
	end
end

AdminManager.execute_command = function (self, input)
	-- function 4
	self._dedicated_server_commands:execute_command(input)
end
