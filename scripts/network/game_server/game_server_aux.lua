-- chunkname: @scripts/network/game_server/game_server_aux.lua

GameServerAux = {}

function GameServerAux.create_network_hash(arg_1_0, arg_1_1)
	return LobbyAux.create_network_hash(arg_1_0, arg_1_1)
end

function GameServerAux.verify_lobby_data(arg_2_0)
	return true
end
