-- chunkname: @scripts/network/game_server/game_server_aux.lua

GameServerAux = {}

GameServerAux.create_network_hash = function (config_file_name, project_hash)
	-- function 1
	return LobbyAux.create_network_hash(config_file_name, project_hash)
end

GameServerAux.verify_lobby_data = function (lobby)
	-- function 2
	return true
end
