-- chunkname: @scripts/network/game_server/game_server_steam.lua

local GameServerInternal = GameServerInternal

GameServerInternal = not not GameServerInternal or not not {}
GameServerInternal = GameServerInternal
GameServerInternal.lobby_data_version = 2

GameServerInternal.init_server = function (network_options, server_name)
	-- function 1
	local config_file_name = network_options.config_file_name
	local project_hash = network_options.project_hash
	local network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)
	local settings = {
		dedicated = true,
		server_version = "1.0.0.0",
		steam_port = network_options.steam_port,
		game_description = network_hash,
		gamedir = Managers.mechanism:server_universe(),
		ip_address = network_options.ip_address,
		map = network_options.map,
		max_players = network_options.max_members,
		query_port = network_options.query_port,
		server_name = server_name,
		server_port = network_options.server_port
	}

	table.dump(settings, "server settings")

	local use_eac = true
	local server = Network.init_steam_server(config_file_name, settings, use_eac)

	GameSettingsDevelopment.set_ignored_rpc_logs()
	cprintf("Appid: %s", SteamGameServer.app_id())

	return server
end

GameServerInternal.ping = function (peer_id)
	-- function 2
	return Network.ping(peer_id)
end

GameServerInternal.shutdown_server = function (game_server)
	-- function 3
	Network.shutdown_steam_server(game_server)
end

GameServerInternal.server_id = function (game_server)
	-- function 4
	return SteamGameServer.id(game_server)
end

GameServerInternal.set_level_name = function (game_server, name)
	-- function 5
	SteamGameServer.set_map(game_server, name)
end

GameServerInternal.run_callbacks = function (game_server, callback_object)
	-- function 6
	SteamGameServer.run_callbacks(game_server, callback_object)
end

GameServerInternal.remove_member = function (game_server, peer_id)
	-- function 7
	SteamGameServer.remove_member(game_server, peer_id)
end

GameServerInternal.user_name = function (game_server, peer_id)
	-- function 8
	return SteamGameServer.name(game_server, peer_id)
end

GameServerInternal.set_max_members = function (game_server, new_max_members)
	-- function 9
	SteamGameServer.set_max_members(game_server, new_max_members)
end

if DEDICATED_SERVER then
	GameServerInternal.open_channel = function (game_server, peer)
		-- function 10
		local channel_id = SteamGameServer.open_channel(game_server, peer)

		print("GameServerInternal.open_channel game_server: %s, to peer: %s channel: %s", game_server, peer, channel_id)

		return channel_id
	end

	GameServerInternal.close_channel = function (game_server, channel)
		-- function 11
		print("GameServerInternal.close_channel game_server: %s, channel: %s", game_server, channel)
		SteamGameServer.close_channel(game_server, channel)
	end
end
