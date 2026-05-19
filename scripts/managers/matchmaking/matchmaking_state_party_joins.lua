-- chunkname: @scripts/managers/matchmaking/matchmaking_state_party_joins.lua

MatchmakingStatePartyJoins = class(MatchmakingStatePartyJoins)
MatchmakingStatePartyJoins.NAME = "MatchmakingStatePartyJoins"
MatchmakingStatePartyJoins.TIMEOUT = 30

function MatchmakingStatePartyJoins.init(arg_1_0, arg_1_1)
	arg_1_0._time = 0
	arg_1_0._peer_id = arg_1_1.peer_id
end

function MatchmakingStatePartyJoins.terminate(arg_2_0)
	local var_2_0 = Managers.lobby

	if var_2_0:query_lobby("matchmaking_join_lobby") then
		var_2_0:destroy_lobby("matchmaking_join_lobby")
	else
		printf("[MatchmakingStatePartyJoins] WARNING: Lobby `matchmaking_join_lobby` does not exist. State is possibly inconsistent.")
	end

	arg_2_0._state_context.reserved_lobby = nil
end

function MatchmakingStatePartyJoins.destroy(arg_3_0)
	return
end

function MatchmakingStatePartyJoins.on_enter(arg_4_0, arg_4_1)
	arg_4_0._state_context = arg_4_1
	arg_4_0._peer_failed_to_follow = false

	local var_4_0 = Managers.lobby:get_lobby("matchmaking_join_lobby")
	local var_4_1 = arg_4_1.join_lobby_data
	local var_4_2 = arg_4_1.search_config.party_lobby_host:members():get_members()
	local var_4_3
	local var_4_4

	if var_4_0:is_dedicated_server() then
		var_4_3 = "server"
		var_4_4 = var_4_1.server_info.ip_port
	else
		var_4_3 = "lobby"
		var_4_4 = var_4_1.id
	end

	local var_4_5 = NetworkLookup.lobby_type[var_4_3]

	for iter_4_0, iter_4_1 in ipairs(var_4_2) do
		if iter_4_1 ~= arg_4_0._peer_id then
			mm_printf("Telling " .. iter_4_1 .. " to follow to " .. var_4_3 .. " " .. var_4_4)

			if string.match(var_4_4, "127.0.0.1") then
				mm_printf("Seems like you are trying to follow a client on the same computer as the dedicated server is located. It cannot be done. -> Fail")

				arg_4_0._peer_failed_to_follow = true

				error("Seems like you are trying to follow a client on the same computer as the dedicated server is located. It cannot be done. -> Fail")
			else
				local var_4_6 = PEER_ID_TO_CHANNEL[iter_4_1]

				if var_4_6 then
					RPC.rpc_follow_to_lobby(var_4_6, var_4_5, var_4_4)
				else
					print("Error: could not find channel to client following me(as a host) into a lobby")
				end
			end
		end
	end

	mm_printf("Wait for %d clients to leave party lobby", #var_4_2 - 1)
end

function MatchmakingStatePartyJoins.on_exit(arg_5_0)
	local var_5_0 = Managers.mechanism:game_mechanism()
	local var_5_1 = var_5_0 and var_5_0.get_server_id and var_5_0:get_server_id()

	if var_5_1 then
		print("JOINING MATCH. SERVER NAME: " .. var_5_1)
	end
end

function MatchmakingStatePartyJoins.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._time = arg_6_0._time + arg_6_1

	if arg_6_0:_all_clients_have_left_lobby() then
		mm_printf("Clients have left the party lobby")

		return MatchmakingStateRequestProfiles, arg_6_0._state_context
	end

	if arg_6_0._time > MatchmakingStatePartyJoins.TIMEOUT or arg_6_0._peer_failed_to_follow then
		mm_printf("Timeout while waiting for clients to leave party lobby")
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")

		return MatchmakingStateIdle, arg_6_0._state_context
	end
end

function MatchmakingStatePartyJoins._all_clients_have_left_lobby(arg_7_0)
	local var_7_0 = arg_7_0._state_context.search_config.party_lobby_host:members():get_members()

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		if iter_7_1 ~= arg_7_0._peer_id then
			return false
		end
	end

	return true
end
