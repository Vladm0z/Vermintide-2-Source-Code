-- chunkname: @scripts/managers/network/lobby_setup.lua

local var_0_0 = {
	max_members = 4,
	project_hash = "bulldozer",
	config_file_name = "global",
	map = "None",
	lobby_port = LEVEL_EDITOR_TEST and GameSettingsDevelopment.editor_lobby_port or GameSettingsDevelopment.network_port,
	ip_address = Network.default_network_address()
}

LobbySetup = LobbySetup or {}
LobbySetup._lobby_port_increment = 0

function LobbySetup.network_hash()
	local var_1_0 = var_0_0.config_file_name
	local var_1_1 = var_0_0.project_hash
	local var_1_2 = true

	return LobbyAux.create_network_hash(var_1_0, var_1_1, var_1_2, var_1_2)
end

function LobbySetup.network_options()
	fassert(LobbySetup._network_options, "Network options has not been set up yet.")

	return LobbySetup._network_options
end

function LobbySetup.setup_network_options(arg_3_0)
	printf("[LobbySetup] Setting up network options")

	local var_3_0 = script_data.start_port_range

	printf("[start_port_range]: %s", var_3_0)

	if var_3_0 then
		local var_3_1 = tonumber(var_3_0)

		var_0_0.server_port = var_3_1
		var_0_0.query_port = var_3_1 + 1
		var_0_0.steam_port = var_3_1 + 2
		var_0_0.rcon_port = var_3_1 + 3
	else
		printf("server_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.server_port, script_data.settings.server_port, Managers.mechanism:mechanism_setting("server_port"))
		printf("query_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.query_port, script_data.settings.query_port, Managers.mechanism:mechanism_setting("query_port"))
		printf("steam_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.steam_port, script_data.settings.steam_port, Managers.mechanism:mechanism_setting("steam_port"))
		printf("rcon_port -> cmd-line: %s, settings.ini: %s, mechanism-settings: %s ", script_data.rcon_port, script_data.settings.rcon_port, Managers.mechanism:mechanism_setting("rcon_port"))

		local var_3_2 = script_data.server_port or script_data.settings.server_port or Managers.mechanism:mechanism_setting("server_port")
		local var_3_3 = script_data.query_port or script_data.settings.query_port or Managers.mechanism:mechanism_setting("query_port")
		local var_3_4 = script_data.steam_port or script_data.settings.steam_port or Managers.mechanism:mechanism_setting("steam_port")
		local var_3_5 = script_data.rcon_port or script_data.settings.rcon_port or Managers.mechanism:mechanism_setting("rcon_port")

		if arg_3_0 and BUILD ~= "release" then
			LobbySetup._lobby_port_increment = LobbySetup._lobby_port_increment + 1
		end

		if not IS_WINDOWS and not IS_LINUX then
			var_3_2 = var_0_0.lobby_port
		end

		var_0_0.server_port = var_3_2 + LobbySetup._lobby_port_increment
		var_0_0.query_port = var_3_3
		var_0_0.steam_port = var_3_4
		var_0_0.rcon_port = var_3_5
	end

	local var_3_6 = Managers.mechanism:max_instance_members()

	var_0_0.max_members = var_3_6

	printf("All ports: server_port %s query_port: %s, steam_port: %s, rcon_port: %s ", var_0_0.server_port, var_0_0.query_port, var_0_0.steam_port, var_0_0.rcon_port)

	LobbySetup._network_options = var_0_0

	print("LobbySetup:setup_network_options server_port:", var_0_0.server_port)
end

function LobbySetup.update_network_options_max_members()
	var_0_0.max_members = Managers.mechanism:max_instance_members()
end
