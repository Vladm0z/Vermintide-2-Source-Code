-- chunkname: @scripts/managers/matchmaking/matchmaking_state_reserve_slots_player_hosted.lua

MatchmakingStateReserveSlotsPlayerHosted = class(MatchmakingStateReserveSlotsPlayerHosted)
MatchmakingStateReserveSlotsPlayerHosted.NAME = "MatchmakingStateReserveSlotsPlayerHosted"

function MatchmakingStateReserveSlotsPlayerHosted.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_options = arg_1_1.network_options
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._state = "waiting_to_join_lobby"
end

function MatchmakingStateReserveSlotsPlayerHosted.destroy(arg_2_0)
	if arg_2_0._password_request ~= nil then
		arg_2_0._password_request:destroy()

		arg_2_0._password_request = nil
	end
end

function MatchmakingStateReserveSlotsPlayerHosted.on_enter(arg_3_0, arg_3_1)
	arg_3_0._state_context = arg_3_1
	arg_3_0._search_config = arg_3_1.search_config
	arg_3_0._reservation_reply = nil
	arg_3_0._connected_to_server = false
	arg_3_0._connect_timeout = nil
	arg_3_0._current_lobby = Managers.state.network:lobby()
	arg_3_0._joined_peers = {}

	local var_3_0 = arg_3_1.join_lobby_data

	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:make_lobby(LobbyClient, "matchmaking_join_lobby", "MatchmakingStateReserveSlotsPlayerHosted (on_enter)", arg_3_0._network_options, var_3_0)
	end

	arg_3_0._matchmaking_manager.debug.text = "Joining lobby"
	arg_3_0._matchmaking_manager.debug.state = "hosted by: " .. (var_3_0.host or "<no_host_name>")

	arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_starting_handshake")
end

function MatchmakingStateReserveSlotsPlayerHosted.on_exit(arg_4_0)
	return
end

function MatchmakingStateReserveSlotsPlayerHosted.terminate(arg_5_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

function MatchmakingStateReserveSlotsPlayerHosted.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_states(arg_6_1, arg_6_2)

	return arg_6_0._new_state, arg_6_0._state_context
end

function MatchmakingStateReserveSlotsPlayerHosted._update_states(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not var_7_0 then
		return arg_7_0:_join_game_failed("failure_start_join_server")
	else
		var_7_0:update(arg_7_1)

		if var_7_0:failed() then
			return arg_7_0:_join_game_failed("failure_start_join_server")
		end
	end

	local var_7_1 = var_7_0:lobby_host()
	local var_7_2 = var_7_0:id()
	local var_7_3 = arg_7_0._state

	if var_7_3 == "waiting_to_join_lobby" then
		if var_7_0:is_joined() and var_7_1 ~= "0" then
			arg_7_0._matchmaking_manager.debug.text = "Connecting to host"

			mm_printf("Joined lobby, checking network hash...")

			arg_7_0._check_network_hash_timeout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
			arg_7_0._state = "verify_not_blocked"
		end
	elseif var_7_3 == "verify_not_blocked" then
		local var_7_4 = var_7_0:lobby_host()
		local var_7_5 = Friends.relationship(var_7_4)

		if var_7_5 == Friends.IGNORED or var_7_5 == Friends.IGNORED_FRIEND then
			return arg_7_0:_join_game_failed("user_blocked")
		end

		arg_7_0._state = "waiting_to_connect"
		arg_7_0._connect_timeout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
	elseif var_7_3 == "waiting_to_connect" then
		if arg_7_0._connected_to_server then
			if arg_7_0._is_server then
				arg_7_0._state = "waiting_for_peers_to_join"
				arg_7_0._waiting_for_peers_to_join_timout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME

				return arg_7_0:_join_game_success(arg_7_2)
			else
				arg_7_0._waiting_for_confirmation_timout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
				arg_7_0._state = "waiting_for_confirmation"

				return arg_7_0:_join_game_success(arg_7_2)
			end
		elseif arg_7_2 > arg_7_0._connect_timeout then
			local var_7_6 = LobbyInternal.user_name and LobbyInternal.user_name(var_7_1) or "-"

			mm_printf_force("Failed to connect to host due to timeout. lobby_id=%s, host_id:%s", var_7_2, var_7_6)

			return arg_7_0:_join_game_failed("connection_timeout")
		end
	elseif var_7_3 == "waiting_for_peers_to_join" then
		if arg_7_0:_all_players_joined() then
			arg_7_0._state = "request_reservation"
		elseif arg_7_2 > arg_7_0._waiting_for_peers_to_join_timout then
			return arg_7_0:_join_game_failed("join_timeout")
		end
	elseif var_7_3 == "request_reservation" then
		arg_7_0._matchmaking_manager.debug.text = "Requesting reservation"

		mm_printf("Connected, request reservation...")

		local var_7_7 = arg_7_0._lobby:members():get_members()

		arg_7_0._network_transmit:send_rpc("rpc_matchmaking_request_reserve_slots", var_7_1, var_7_2, var_7_7)

		arg_7_0._reservation_timeout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
		arg_7_0._state = "asking_for_reservation"
	elseif var_7_3 == "asking_for_reservation" then
		local var_7_8 = MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME - (arg_7_0._reservation_timeout - arg_7_2)

		arg_7_0._matchmaking_manager.debug.text = string.format("Requesting to reserve slots %s [%.0f]", var_7_0:id(), var_7_8)

		local var_7_9 = LobbyInternal.user_name and LobbyInternal.user_name(var_7_1) or "-"
		local var_7_10 = arg_7_0._reservation_reply

		if arg_7_2 > arg_7_0._reservation_timeout then
			mm_printf_force("Failed to reserve slots due to timeout. lobby_id=%s, host_id:%s", var_7_2, var_7_9)

			return arg_7_0:_join_game_failed("connection_timeout")
		elseif var_7_10 ~= nil then
			if var_7_10 == "lobby_ok" then
				mm_printf("Successfully reserved slots after %.2f seconds: lobby_id=%s host_id:%s", var_7_8, var_7_2, var_7_9)

				return arg_7_0:_reservation_success(true)
			else
				mm_printf_force("Failed to reserve slots  due to host responding '%s'. lobby_id=%s, host_id:%s", var_7_10, var_7_2, var_7_9)

				return arg_7_0:_reservation_success(false)
			end
		end
	elseif var_7_3 == "waiting_for_confirmation" then
		-- block empty
	end
end

function MatchmakingStateReserveSlotsPlayerHosted._join_game_success(arg_8_0, arg_8_1)
	local var_8_0 = true

	if arg_8_0._is_server then
		arg_8_0._joined_peers[Network.peer_id()] = var_8_0

		local var_8_1 = arg_8_0._state_context.join_lobby_data

		arg_8_0._network_transmit:send_rpc_clients("rpc_matchmaking_client_join_player_hosted", var_8_1.id)
	else
		local var_8_2 = arg_8_0._current_lobby:lobby_host()

		arg_8_0._network_transmit:send_rpc("rpc_matchmaking_client_joined_player_hosted", var_8_2, var_8_0)
	end
end

function MatchmakingStateReserveSlotsPlayerHosted._join_game_failed(arg_9_0, arg_9_1)
	print("[MatchmakingStateReserveSlotsPlayerHosted] FAILED: " .. arg_9_1)

	local var_9_0 = false

	if arg_9_0._is_server then
		arg_9_0._joined_peers[Network.peer_id()] = false

		arg_9_0._network_transmit:send_rpc_clients("rpc_matchmaking_reservation_success", var_9_0)
	else
		local var_9_1 = arg_9_0._current_lobby:lobby_host()

		arg_9_0._network_transmit:send_rpc("rpc_matchmaking_client_joined_player_hosted", var_9_1, var_9_0)
	end

	arg_9_0:_cancel_join()
end

function MatchmakingStateReserveSlotsPlayerHosted._reservation_success(arg_10_0, arg_10_1)
	if arg_10_0._is_server then
		arg_10_0._network_transmit:send_rpc_clients("rpc_matchmaking_reservation_success", arg_10_1)
	end

	if arg_10_1 then
		arg_10_0._state = "done"
		arg_10_0._new_state = MatchmakingStateWaitJoinPlayerHosted
	else
		arg_10_0:_cancel_join()
	end
end

function MatchmakingStateReserveSlotsPlayerHosted._cancel_join(arg_11_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	arg_11_0._matchmaking_manager:reset_joining()

	arg_11_0._state_context.join_lobby_data = nil

	local var_11_0 = arg_11_0._state_context.join_by_lobby_browser
	local var_11_1 = arg_11_0._state_context.friend_join

	if arg_11_0._is_server and not var_11_0 and not var_11_1 then
		if arg_11_0._search_config.dedicated_server then
			arg_11_0._new_state = MatchmakingStateReserveLobby
		else
			arg_11_0._new_state = MatchmakingStateSearchPlayerHostedLobby
		end
	else
		Managers.matchmaking:cancel_matchmaking()
	end
end

function MatchmakingStateReserveSlotsPlayerHosted._all_players_joined(arg_12_0)
	local var_12_0 = arg_12_0._lobby:members():get_members()
	local var_12_1 = true

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if not arg_12_0._joined_peers[iter_12_1] then
			var_12_1 = false

			break
		end
	end

	return var_12_1
end

function MatchmakingStateReserveSlotsPlayerHosted.rpc_matchmaking_client_joined_player_hosted(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0._is_server then
		fassert(false, "[MatchmakingStateReserveSlotsPlayerHosted] Server Only function")
	end

	local var_13_0 = CHANNEL_TO_PEER_ID[arg_13_1]

	arg_13_0._joined_peers[var_13_0] = arg_13_2

	if not arg_13_2 then
		arg_13_0:_join_game_failed("peer_failed_to_join")
	end
end

function MatchmakingStateReserveSlotsPlayerHosted.rpc_matchmaking_request_reserve_slots_reply(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0._reservation_reply = NetworkLookup.game_ping_reply[arg_14_2]
	arg_14_0._reservation_reply_variable = arg_14_3
end

function MatchmakingStateReserveSlotsPlayerHosted.rpc_matchmaking_reservation_success(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0._is_server then
		fassert(false, "[MatchmakingStateReserveSlotsPlayerHosted] The lobby host should never receive this")
	end

	if arg_15_2 then
		arg_15_0._new_state = MatchmakingStateWaitJoinPlayerHosted
	else
		arg_15_0:_cancel_join()
	end
end

function MatchmakingStateReserveSlotsPlayerHosted.rpc_notify_connected(arg_16_0, arg_16_1)
	arg_16_0._connected_to_server = true
end
