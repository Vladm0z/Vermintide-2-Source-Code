-- chunkname: @scripts/managers/network/lobby_setup.lua

local tbl = {
	max_members = 4,
	project_hash = "bulldozer",
	config_file_name = "global",
	map = "None"
}
local editor_lobby_port

if not LEVEL_EDITOR_TEST then
	editor_lobby_port = GameSettingsDevelopment.editor_lobby_port

	if not editor_lobby_port then
		-- Nothing
	end
end

editor_lobby_port = GameSettingsDevelopment.network_port

::label_0_0::

tbl.lobby_port = editor_lobby_port
tbl.ip_address = Network.default_network_address()

local LobbySetup = LobbySetup

LobbySetup = LobbySetup or {}
LobbySetup = LobbySetup
LobbySetup._lobby_port_increment = 0

LobbySetup.network_hash = function ()
	-- function 1
	local config_file_name = tbl.config_file_name
	local project_hash = tbl.project_hash
	local flag = true

	return LobbyAux.create_network_hash(config_file_name, project_hash, flag, flag)
end

LobbySetup.network_options = function ()
	-- function 2
	fassert(LobbySetup._network_options, "Network options has not been set up yet.")

	return LobbySetup._network_options
end

LobbySetup.setup_network_options = function (arg_3_0)
	-- function 3
	printf("[LobbySetup] Setting up network options")

	local start_port_range = script_data.start_port_range

	printf("[start_port_range]: %s", start_port_range)

	if not start_port_range then
		local var_3_1 = tonumber(start_port_range)

		tbl.server_port = var_3_1
		tbl.query_port = var_3_1 + 1
		tbl.steam_port = var_3_1 + 2
		tbl.rcon_port = var_3_1 + 3
	else
		printf("server_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.server_port, script_data.settings.server_port, Managers.mechanism:mechanism_setting("server_port"))
		printf("query_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.query_port, script_data.settings.query_port, Managers.mechanism:mechanism_setting("query_port"))
		printf("steam_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.steam_port, script_data.settings.steam_port, Managers.mechanism:mechanism_setting("steam_port"))
		printf("rcon_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.rcon_port, script_data.settings.rcon_port, Managers.mechanism:mechanism_setting("rcon_port"))

		local server_port = script_data.server_port

		if not server_port then
			server_port = script_data.settings.server_port
			server_port = server_port or Managers.mechanism:mechanism_setting("server_port")
		end

		local query_port = script_data.query_port

		if not query_port then
			query_port = script_data.settings.query_port
			query_port = query_port or Managers.mechanism:mechanism_setting("query_port")
		end

		local steam_port = script_data.steam_port

		if not steam_port then
			steam_port = script_data.settings.steam_port
			steam_port = steam_port or Managers.mechanism:mechanism_setting("steam_port")
		end

		local rcon_port = script_data.rcon_port

		if not rcon_port then
			rcon_port = script_data.settings.rcon_port
			rcon_port = rcon_port or Managers.mechanism:mechanism_setting("rcon_port")
		end

		if not (not arg_3_0 and BUILD == "release") then
			LobbySetup._lobby_port_increment = LobbySetup._lobby_port_increment + 1
		end

		if not (IS_WINDOWS or IS_LINUX) then
			server_port = tbl.lobby_port
		end

		tbl.server_port = server_port + LobbySetup._lobby_port_increment
		tbl.query_port = query_port
		tbl.steam_port = steam_port
		tbl.rcon_port = rcon_port
	end

	local max_instance_members = Managers.mechanism:max_instance_members()

	tbl.max_members = max_instance_members

	printf("All ports: server_port %s query_port: %s, steam_port: %s, rcon_port: %s ", tbl.server_port, tbl.query_port, tbl.steam_port, tbl.rcon_port)

	LobbySetup._network_options = tbl

	print("LobbySetup:setup_network_options server_port:", tbl.server_port)
end

LobbySetup.update_network_options_max_members = function ()
	-- function 4
	tbl.max_members = Managers.mechanism:max_instance_members()
end
