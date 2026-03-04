-- chunkname: @scripts/network/game_server/game_server_aux.lua

GameServerAux = {}

GameServerAux.create_network_hash = function (arg_1_0, arg_1_1)
	return LobbyAux.create_network_hash(arg_1_0, arg_1_1)
end

GameServerAux.verify_lobby_data = function (arg_2_0)
	return true
end
