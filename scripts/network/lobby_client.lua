-- chunkname: @scripts/network/lobby_client.lua

require("scripts/network/lobby_aux")

LobbyClient = class(LobbyClient)

LobbyClient.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.lobby = arg_1_3 or LobbyInternal.join_lobby(arg_1_2)
	arg_1_0.stored_lobby_data = arg_1_2

	local var_1_0 = arg_1_1.config_file_name
	local var_1_1 = arg_1_1.project_hash

	arg_1_0.network_hash = LobbyAux.create_network_hash(var_1_0, var_1_1)
	arg_1_0.peer_id = Network.peer_id()
	arg_1_0._host_peer_id = nil
	arg_1_0._host_channel_id = nil
	arg_1_0.is_host = false

	if HAS_STEAM then
		arg_1_0:set_steam_lobby_reconnectable(true)
	end

	mm_printf("LobbyClient Created")
end

LobbyClient.destroy = function (arg_2_0)
	local var_2_0 = arg_2_0._host_peer_id
	local var_2_1 = arg_2_0._host_channel_id

	if var_2_1 then
		printf("LobbyClient close server channel %s to %s", tostring(var_2_1), var_2_0)
		LobbyInternal.close_channel(arg_2_0.lobby, var_2_1)

		PEER_ID_TO_CHANNEL[var_2_0] = nil
		CHANNEL_TO_PEER_ID[var_2_1] = nil
	end

	mm_printf("LobbyClient Destroyed")

	arg_2_0._host_peer_id = nil
	arg_2_0._host_channel_id = nil

	LobbyInternal.leave_lobby(arg_2_0.lobby)

	arg_2_0.lobby_members = nil
	arg_2_0.lobby = nil
	arg_2_0.has_sent_join = false

	GarbageLeakDetector.register_object(arg_2_0, "Lobby Client")
end

LobbyClient.update = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.lobby
	local var_3_1 = var_3_0:lobby_host()
	local var_3_2 = var_3_0.state(var_3_0)
	local var_3_3 = arg_3_0.state

	if var_3_2 ~= var_3_3 then
		printf("[LobbyClient] Changed state from %s to %s", tostring(var_3_3), var_3_2)

		arg_3_0.state = var_3_2

		if var_3_2 == LobbyState.JOINED then
			arg_3_0.lobby_members = arg_3_0.lobby_members or LobbyMembers:new(var_3_0, arg_3_0.client)

			Managers.party:set_leader(var_3_1)

			arg_3_0._look_for_host = true
			arg_3_0._reconnecting_to_lobby = nil
			arg_3_0._try_reconnecting = nil
			arg_3_0._reconnect_times = nil

			Managers.account:update_presence()
			print("[LobbyClient] connected to lobby, id:", arg_3_0.stored_lobby_data.id)
		end

		if var_3_3 == LobbyState.JOINED then
			Managers.party:set_leader(nil)

			if arg_3_0.lobby_members then
				arg_3_0.lobby_members:clear()

				arg_3_0.has_sent_join = false
			end
		end

		if arg_3_0._reconnecting_to_lobby and var_3_2 == LobbyState.FAILED then
			arg_3_0._reconnecting_to_lobby = false
			arg_3_0._try_reconnecting = not arg_3_0._reconnect_times or arg_3_0._reconnect_times < 10
		end
	end

	if arg_3_0._look_for_host then
		local var_3_4 = var_3_0:lobby_host()

		printf("====== Looking for host: %s", tostring(var_3_4))

		if var_3_4 ~= nil then
			local var_3_5 = LobbyInternal.open_channel(var_3_0, var_3_4)

			arg_3_0._host_peer_id = var_3_4
			arg_3_0._host_channel_id = var_3_5
			PEER_ID_TO_CHANNEL[var_3_4] = var_3_5
			CHANNEL_TO_PEER_ID[var_3_5] = var_3_4

			printf("Connected to host: %s, using channel: %d", var_3_4, var_3_5)

			arg_3_0._look_for_host = nil
		end
	end

	if arg_3_0.lobby_members then
		arg_3_0.lobby_members:update()

		local var_3_6 = arg_3_0.peer_id
		local var_3_7 = arg_3_0.lobby_members:get_members_left()

		for iter_3_0 = 1, #var_3_7 do
			local var_3_8 = var_3_7[iter_3_0]

			if var_3_8 == var_3_6 then
				arg_3_0._lost_connection_to_lobby = true
				arg_3_0._try_reconnecting = var_3_8 == var_3_6

				print("[LobbyClient] Lost connection to the lobby")
			end
		end
	end

	if HAS_STEAM and arg_3_0._lobby_reconnectable_on_disconnect and arg_3_0:lost_connection_to_lobby() and not arg_3_0._reconnecting_to_lobby and arg_3_0._try_reconnecting then
		print("[LobbyClient] Attempting to rejoin lobby", arg_3_0.stored_lobby_data.id, "Retries:", arg_3_0._reconnect_times or 0)

		local var_3_9 = arg_3_0._host_peer_id
		local var_3_10 = arg_3_0._host_channel_id

		if var_3_10 then
			printf("LobbyClient close server channel %s to %s", tostring(var_3_10), var_3_9)
			LobbyInternal.close_channel(arg_3_0.lobby, var_3_10)

			PEER_ID_TO_CHANNEL[var_3_9] = nil
			CHANNEL_TO_PEER_ID[var_3_10] = nil
		end

		LobbyInternal.leave_lobby(arg_3_0.lobby)

		arg_3_0.lobby = LobbyInternal.join_lobby(arg_3_0.stored_lobby_data)
		arg_3_0.state = nil

		if arg_3_0.lobby_members then
			arg_3_0.lobby_members:clear()

			arg_3_0.has_sent_join = false
		end

		arg_3_0._reconnect_times = (arg_3_0._reconnect_times or 0) + 1
		arg_3_0._reconnecting_to_lobby = true
		arg_3_0._try_reconnecting = false
	end
end

LobbyClient.set_steam_lobby_reconnectable = function (arg_4_0, arg_4_1)
	print(arg_4_1 and "Enabled" or "Disabled", "live steam lobby reconnecting")

	arg_4_0._lobby_reconnectable_on_disconnect = arg_4_1
end

LobbyClient.get_stored_lobby_data = function (arg_5_0)
	return arg_5_0.stored_lobby_data
end

LobbyClient.update_user_names = function (arg_6_0)
	if IS_PS4 then
		arg_6_0.lobby:update_user_names()
	end
end

LobbyClient.members = function (arg_7_0)
	return arg_7_0.lobby_members
end

LobbyClient.invite_target = function (arg_8_0)
	return arg_8_0.lobby
end

LobbyClient.is_dedicated_server = function (arg_9_0)
	return false
end

LobbyClient.lobby_host = function (arg_10_0)
	return arg_10_0._host_peer_id
end

LobbyClient.lobby_data = function (arg_11_0, arg_11_1)
	return arg_11_0.lobby:data(arg_11_1)
end

LobbyClient.has_user_name = function (arg_12_0, arg_12_1)
	return arg_12_0.lobby:user_name(arg_12_1) ~= nil
end

LobbyClient.user_name = function (arg_13_0, arg_13_1)
	if HAS_STEAM then
		return string.gsub(Steam.user_name(), "%c", "")
	elseif IS_PS4 then
		return string.gsub(arg_13_0.lobby:user_name(arg_13_1), "%c", "")
	else
		return arg_13_1
	end
end

LobbyClient.is_joined = function (arg_14_0)
	return arg_14_0.state == LobbyState.JOINED
end

LobbyClient.failed = function (arg_15_0)
	return arg_15_0.state == LobbyState.FAILED
end

LobbyClient.id = function (arg_16_0)
	return LobbyInternal.lobby_id and LobbyInternal.lobby_id(arg_16_0.lobby) or "no_id"
end

LobbyClient.attempting_reconnect = function (arg_17_0)
	return arg_17_0._reconnecting_to_lobby or arg_17_0._try_reconnecting
end

LobbyClient._free_lobby = function (arg_18_0)
	if arg_18_0.lobby ~= nil then
		LobbyInternal.leave_lobby(arg_18_0.lobby)

		arg_18_0.lobby = nil
	end
end

LobbyClient.lost_connection_to_lobby = function (arg_19_0)
	return LobbyInternal.is_orphaned(arg_19_0.lobby) or arg_19_0._lost_connection_to_lobby
end

LobbyClient.game_session_host = function (arg_20_0)
	return LobbyInternal.game_session_host(arg_20_0.lobby)
end
