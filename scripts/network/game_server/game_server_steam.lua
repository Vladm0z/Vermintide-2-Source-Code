-- chunkname: @scripts/network/game_server/game_server_steam.lua

GameServerInternal = GameServerInternal or {}
GameServerInternal.lobby_data_version = 2

GameServerInternal.init_server = function (arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.config_file_name
	local var_1_1 = arg_1_0.project_hash
	local var_1_2 = GameServerAux.create_network_hash(var_1_0, var_1_1)
	local var_1_3 = {
		dedicated = true,
		server_version = "1.0.0.0",
		steam_port = arg_1_0.steam_port,
		game_description = var_1_2,
		gamedir = Managers.mechanism:server_universe(),
		ip_address = arg_1_0.ip_address,
		map = arg_1_0.map,
		max_players = arg_1_0.max_members,
		query_port = arg_1_0.query_port,
		server_name = arg_1_1,
		server_port = arg_1_0.server_port
	}

	table.dump(var_1_3, "server settings")

	local var_1_4 = true
	local var_1_5 = Network.init_steam_server(var_1_0, var_1_3, var_1_4)

	GameSettingsDevelopment.set_ignored_rpc_logs()
	cprintf("Appid: %s", SteamGameServer.app_id())

	return var_1_5
end

GameServerInternal.ping = function (arg_2_0)
	return Network.ping(arg_2_0)
end

GameServerInternal.shutdown_server = function (arg_3_0)
	Network.shutdown_steam_server(arg_3_0)
end

GameServerInternal.server_id = function (arg_4_0)
	return SteamGameServer.id(arg_4_0)
end

GameServerInternal.set_level_name = function (arg_5_0, arg_5_1)
	SteamGameServer.set_map(arg_5_0, arg_5_1)
end

GameServerInternal.run_callbacks = function (arg_6_0, arg_6_1)
	SteamGameServer.run_callbacks(arg_6_0, arg_6_1)
end

GameServerInternal.remove_member = function (arg_7_0, arg_7_1)
	SteamGameServer.remove_member(arg_7_0, arg_7_1)
end

GameServerInternal.user_name = function (arg_8_0, arg_8_1)
	return SteamGameServer.name(arg_8_0, arg_8_1)
end

GameServerInternal.set_max_members = function (arg_9_0, arg_9_1)
	SteamGameServer.set_max_members(arg_9_0, arg_9_1)
end

if DEDICATED_SERVER then
	GameServerInternal.open_channel = function (arg_10_0, arg_10_1)
		local var_10_0 = SteamGameServer.open_channel(arg_10_0, arg_10_1)

		print("GameServerInternal.open_channel game_server: %s, to peer: %s channel: %s", arg_10_0, arg_10_1, var_10_0)

		return var_10_0
	end

	GameServerInternal.close_channel = function (arg_11_0, arg_11_1)
		print("GameServerInternal.close_channel game_server: %s, channel: %s", arg_11_0, arg_11_1)
		SteamGameServer.close_channel(arg_11_0, arg_11_1)
	end
end
