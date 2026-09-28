-- chunkname: @scripts/managers/network/lobby_setup.lua

local tbl = {
	max_members = 4,
	project_hash = "bulldozer",
	config_file_name = "global",
	map = "None"
}
local editor_lobby_port

if LEVEL_EDITOR_TEST then
	editor_lobby_port = GameSettingsDevelopment.editor_lobby_port

	if not editor_lobby_port then
		-- Nothing
	end
end

editor_lobby_port = GameSettingsDevelopment.network_port

::label_0_0::

tbl.lobby_port = editor_lobby_port
tbl.ip_address = Network.default_network_address()

local network_options = tbl
local LobbySetup = LobbySetup

LobbySetup = not not LobbySetup or not not {}
LobbySetup = LobbySetup
LobbySetup._lobby_port_increment = 0

LobbySetup.network_hash = function ()
	-- function 1
	local config_file_name = network_options.config_file_name
	local project_hash = network_options.project_hash
	local disable_print = true

	return LobbyAux.create_network_hash(config_file_name, project_hash, disable_print, disable_print)
end

LobbySetup.network_options = function ()
	-- function 2
	fassert(LobbySetup._network_options, "Network options has not been set up yet.")

	return LobbySetup._network_options
end

LobbySetup.setup_network_options = function (increment_lobby_port)
	-- function 3
	printf("[LobbySetup] Setting up network options")

	local start_port_range = script_data.start_port_range

	printf("[start_port_range]: %s", start_port_range)

	if start_port_range then
		start_port_range = tonumber(start_port_range)
		network_options.server_port = start_port_range
		network_options.query_port = start_port_range + 1
		network_options.steam_port = start_port_range + 2
		network_options.rcon_port = start_port_range + 3
	else
		printf("server_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.server_port, script_data.settings.server_port, Managers.mechanism:mechanism_setting("server_port"))
		printf("query_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.query_port, script_data.settings.query_port, Managers.mechanism:mechanism_setting("query_port"))
		printf("steam_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.steam_port, script_data.settings.steam_port, Managers.mechanism:mechanism_setting("steam_port"))
		printf("rcon_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.rcon_port, script_data.settings.rcon_port, Managers.mechanism:mechanism_setting("rcon_port"))

		local server_port_2 = script_data.server_port

		if not server_port_2 then
			-- Nothing
		end

		server_port_2 = script_data.settings.server_port

		if not server_port_2 then
			-- Nothing
		end

		server_port_2 = Managers.mechanism:mechanism_setting("server_port")

		local server_port = server_port_2

		::label_3_0::

		local query_port_2 = script_data.query_port

		if not query_port_2 then
			-- Nothing
		end

		query_port_2 = script_data.settings.query_port

		if not query_port_2 then
			-- Nothing
		end

		query_port_2 = Managers.mechanism:mechanism_setting("query_port")

		local query_port = query_port_2

		::label_3_1::

		local steam_port_2 = script_data.steam_port

		if not steam_port_2 then
			-- Nothing
		end

		steam_port_2 = script_data.settings.steam_port

		if not steam_port_2 then
			-- Nothing
		end

		steam_port_2 = Managers.mechanism:mechanism_setting("steam_port")

		local steam_port = steam_port_2

		::label_3_2::

		local rcon_port_2 = script_data.rcon_port

		if not rcon_port_2 then
			-- Nothing
		end

		rcon_port_2 = script_data.settings.rcon_port

		if not rcon_port_2 then
			-- Nothing
		end

		rcon_port_2 = Managers.mechanism:mechanism_setting("rcon_port")

		local rcon_port = rcon_port_2

		::label_3_3::

		if increment_lobby_port and BUILD ~= "release" then
			LobbySetup._lobby_port_increment = LobbySetup._lobby_port_increment + 1
		end

		if not IS_WINDOWS and not IS_LINUX then
			server_port = network_options.lobby_port
		end

		network_options.server_port = server_port + LobbySetup._lobby_port_increment
		network_options.query_port = query_port
		network_options.steam_port = steam_port
		network_options.rcon_port = rcon_port
	end

	local max_members = Managers.mechanism:max_instance_members()

	network_options.max_members = max_members

	printf("All ports: server_port %s query_port: %s, steam_port: %s, rcon_port: %s ", network_options.server_port, network_options.query_port, network_options.steam_port, network_options.rcon_port)

	LobbySetup._network_options = network_options

	print("LobbySetup:setup_network_options server_port:", network_options.server_port)
end

LobbySetup.update_network_options_max_members = function ()
	-- function 4
	network_options.max_members = Managers.mechanism:max_instance_members()
end
