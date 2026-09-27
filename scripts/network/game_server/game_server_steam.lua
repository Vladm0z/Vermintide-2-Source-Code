-- chunkname: @scripts/network/game_server/game_server_steam.lua

local GameServerInternal = GameServerInternal

GameServerInternal = GameServerInternal or {}
GameServerInternal = GameServerInternal
GameServerInternal.lobby_data_version = 2

GameServerInternal.init_server = function (self, arg_1_1)
	-- function 1
	local config_file_name = self.config_file_name
	local project_hash = self.project_hash
	local create_network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)
	local tbl = {
		dedicated = true,
		server_version = "1.0.0.0",
		steam_port = self.steam_port,
		game_description = create_network_hash,
		gamedir = Managers.mechanism:server_universe(),
		ip_address = self.ip_address,
		map = self.map,
		max_players = self.max_members,
		query_port = self.query_port,
		server_name = arg_1_1,
		server_port = self.server_port
	}

	table.dump(tbl, "server settings")

	local flag = true
	local init_steam_server = Network.init_steam_server(config_file_name, tbl, flag)

	GameSettingsDevelopment.set_ignored_rpc_logs()
	cprintf("Appid: %s", SteamGameServer.app_id())

	return init_steam_server
end

GameServerInternal.ping = function (arg_2_0)
	-- function 2
	return Network.ping(arg_2_0)
end

GameServerInternal.shutdown_server = function (arg_3_0)
	-- function 3
	Network.shutdown_steam_server(arg_3_0)
end

GameServerInternal.server_id = function (arg_4_0)
	-- function 4
	return SteamGameServer.id(arg_4_0)
end

GameServerInternal.set_level_name = function (arg_5_0, arg_5_1)
	-- function 5
	SteamGameServer.set_map(arg_5_0, arg_5_1)
end

GameServerInternal.run_callbacks = function (arg_6_0, arg_6_1)
	-- function 6
	SteamGameServer.run_callbacks(arg_6_0, arg_6_1)
end

GameServerInternal.remove_member = function (arg_7_0, arg_7_1)
	-- function 7
	SteamGameServer.remove_member(arg_7_0, arg_7_1)
end

GameServerInternal.user_name = function (arg_8_0, arg_8_1)
	-- function 8
	return SteamGameServer.name(arg_8_0, arg_8_1)
end

GameServerInternal.set_max_members = function (arg_9_0, arg_9_1)
	-- function 9
	SteamGameServer.set_max_members(arg_9_0, arg_9_1)
end

if not DEDICATED_SERVER then
	GameServerInternal.open_channel = function (arg_10_0, arg_10_1)
		-- function 10
		local open_channel = SteamGameServer.open_channel(arg_10_0, arg_10_1)

		print("GameServerInternal.open_channel game_server: %s, to peer: %s channel: %s", arg_10_0, arg_10_1, open_channel)

		return open_channel
	end

	GameServerInternal.close_channel = function (arg_11_0, arg_11_1)
		-- function 11
		print("GameServerInternal.close_channel game_server: %s, channel: %s", arg_11_0, arg_11_1)
		SteamGameServer.close_channel(arg_11_0, arg_11_1)
	end
end
