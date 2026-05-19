-- chunkname: @scripts/network/game_server/game_server_client.lua

require("scripts/network/game_server/game_server_aux")

GameServerLobbyClient = class(GameServerLobbyClient)

local function var_0_0(arg_1_0, ...)
	local var_1_0 = arg_1_0.format(arg_1_0, ...)

	printf("[GameServerLobbyClient]: %s", var_1_0)
end

function GameServerLobbyClient.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	var_0_0("Joining lobby on address %s", arg_2_2.server_info.ip_port)

	arg_2_0._game_server_info = arg_2_2.server_info
	arg_2_0.peer_id = Network.peer_id()

	if arg_2_4 then
		arg_2_0._game_server_lobby = GameServerInternal.reserve_server(arg_2_0._game_server_info, arg_2_3, arg_2_4)
	else
		arg_2_0._game_server_lobby = GameServerInternal.join_server(arg_2_0._game_server_info, arg_2_3)
	end

	arg_2_0._game_server_lobby_data = arg_2_2

	local var_2_0 = arg_2_1.config_file_name
	local var_2_1 = arg_2_1.project_hash

	arg_2_0._network_hash = GameServerAux.create_network_hash(var_2_0, var_2_1)
	arg_2_0.lobby = arg_2_0._game_server_lobby
	arg_2_0.network_hash = arg_2_0._network_hash
	arg_2_0._is_party_host = not Managers.state.network or Managers.state.network.is_server
	arg_2_0._advertising_playing = true
	arg_2_0.is_host = false
end

function GameServerLobbyClient.lobby_host(arg_3_0)
	return GameServerInternal.lobby_host(arg_3_0._game_server_lobby)
end

function GameServerLobbyClient.destroy(arg_4_0)
	var_0_0("Destroying Game Server Client, leaving server...")

	local var_4_0 = GameServerInternal.lobby_host(arg_4_0._game_server_lobby)
	local var_4_1 = PEER_ID_TO_CHANNEL[var_4_0]

	printf("closing channel %s", tostring(var_4_1))

	if var_4_1 then
		GameServerInternal.close_channel(arg_4_0._game_server_lobby, var_4_1)

		PEER_ID_TO_CHANNEL[var_4_0] = nil
		CHANNEL_TO_PEER_ID[var_4_1] = nil

		if Managers.mechanism:dedicated_server_peer_id() == var_4_0 then
			Managers.mechanism:reset_dedicated_server_peer_id()
		end
	end

	arg_4_0:stop_advertise_playing()
	GameServerInternal.leave_server(arg_4_0._game_server_lobby)

	arg_4_0._members = nil
	arg_4_0._game_server_lobby = nil
	arg_4_0._game_server_lobby_data = nil

	GarbageLeakDetector.register_object(arg_4_0, "Game Server Client")
end

function GameServerLobbyClient.update(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._game_server_lobby
	local var_5_1 = var_5_0:state()
	local var_5_2 = arg_5_0._state

	if var_5_1 ~= var_5_2 then
		var_0_0("Changing state from %s to %s", var_5_2, var_5_1)

		arg_5_0._state = var_5_1

		if var_5_1 == "failed" then
			local var_5_3 = Managers.backend and Managers.backend:get_interface("versus")

			if var_5_3 then
				local var_5_4 = var_5_3:get_matchmaking_session_id()

				if var_5_4 then
					local var_5_5 = arg_5_0._game_server_info.ip_port or "MISSING"

					Crashify.print_exception("GameServerLobbyClient", "State changed from %s to %s for flexmatch server. matchmaking_session_id: %s | ip_port: %s", var_5_2, var_5_1, var_5_4 or "MISSING", var_5_5)
				end
			end
		elseif var_5_1 == "reserved" then
			local var_5_6 = GameServerInternal.lobby_host(var_5_0)
			local var_5_7 = GameServerInternal.open_channel(var_5_0, var_5_6)

			print("[GameServerLobbyClient] Party host open channel to server", var_5_6)

			PEER_ID_TO_CHANNEL[var_5_6] = var_5_7
			CHANNEL_TO_PEER_ID[var_5_7] = var_5_6
		elseif var_5_1 == "joined" then
			local var_5_8 = GameServerInternal.lobby_host(var_5_0)

			if not PEER_ID_TO_CHANNEL[var_5_8] then
				if arg_5_0._is_party_host then
					print("[GameServerLobbyClient] Party host open channel to server without reserving", var_5_8)
				else
					print("[GameServerLobbyClient] Party client open channel to server", var_5_8)
				end

				local var_5_9 = GameServerInternal.open_channel(var_5_0, var_5_8)

				PEER_ID_TO_CHANNEL[var_5_8] = var_5_9
				CHANNEL_TO_PEER_ID[var_5_9] = var_5_8
			end

			arg_5_0._members = arg_5_0._members or LobbyMembers:new(var_5_0)
		end

		if var_5_2 == "joined" and arg_5_0._members then
			arg_5_0._members:clear()
		end
	end

	if arg_5_0._members then
		arg_5_0._members:update()
	end
end

function GameServerLobbyClient.claim_reserved(arg_6_0)
	GameServerInternal.claim_reserved(arg_6_0._game_server_lobby)
end

function GameServerLobbyClient.advertise_playing(arg_7_0)
	Presence.advertise_playing(arg_7_0._game_server_info.ip_port)

	arg_7_0._advertising_playing = true
end

function GameServerLobbyClient.stop_advertise_playing(arg_8_0, arg_8_1)
	if not arg_8_0._advertising_playing then
		return
	end

	Presence.stop_advertise_playing()

	arg_8_0._advertising_playing = false
end

function GameServerLobbyClient.state(arg_9_0)
	return arg_9_0._state
end

function GameServerLobbyClient.members(arg_10_0)
	return arg_10_0._members
end

function GameServerLobbyClient.invite_target(arg_11_0)
	return arg_11_0._game_server_info.ip_port
end

function GameServerLobbyClient.is_dedicated_server(arg_12_0)
	return true
end

function GameServerLobbyClient.lobby_host(arg_13_0)
	return GameServerInternal.lobby_host(arg_13_0._game_server_lobby)
end

function GameServerLobbyClient.lobby_data(arg_14_0, arg_14_1)
	return arg_14_0._game_server_lobby:data(arg_14_1)
end

function GameServerLobbyClient.get_stored_lobby_data(arg_15_0)
	return arg_15_0._game_server_lobby_data
end

function GameServerLobbyClient.ip_address(arg_16_0)
	return arg_16_0._game_server_info.ip_port
end

function GameServerLobbyClient.is_joined(arg_17_0)
	return arg_17_0._state == "joined"
end

function GameServerLobbyClient.failed(arg_18_0)
	return arg_18_0._state == "failed"
end

function GameServerLobbyClient.id(arg_19_0)
	return GameServerInternal.lobby_id and GameServerInternal.lobby_id(arg_19_0._game_server_lobby) or "no_id"
end

function GameServerLobbyClient.request_data(arg_20_0)
	arg_20_0._game_server_lobby:request_data()
end

function GameServerLobbyClient.attempting_reconnect(arg_21_0)
	return false
end

function GameServerLobbyClient.lost_connection_to_lobby(arg_22_0)
	return false
end
