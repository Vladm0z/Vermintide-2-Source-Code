-- chunkname: @scripts/managers/matchmaking/matchmaking_state_party_joins.lua

MatchmakingStatePartyJoins = class(MatchmakingStatePartyJoins)
MatchmakingStatePartyJoins.NAME = "MatchmakingStatePartyJoins"
MatchmakingStatePartyJoins.TIMEOUT = 30

MatchmakingStatePartyJoins.init = function (self, arg_1_1)
	-- function 1
	self._time = 0
	self._peer_id = arg_1_1.peer_id
end

MatchmakingStatePartyJoins.terminate = function (arg_2_0)
	-- function 2
	local lobby = Managers.lobby

	if not lobby:query_lobby("matchmaking_join_lobby") then
		lobby:destroy_lobby("matchmaking_join_lobby")
	else
		printf("[MatchmakingStatePartyJoins] WARNING: Lobby `matchmaking_join_lobby` does not exist. State is possibly inconsistent.")
	end

	arg_2_0._state_context.reserved_lobby = nil
end

MatchmakingStatePartyJoins.destroy = function (arg_3_0)
	-- function 3
	return
end

MatchmakingStatePartyJoins.on_enter = function (self, arg_4_1)
	-- function 4
	self._state_context = arg_4_1
	self._peer_failed_to_follow = false

	local get_lobby = Managers.lobby:get_lobby("matchmaking_join_lobby")
	local join_lobby_data = arg_4_1.join_lobby_data
	local get_members = arg_4_1.search_config.party_lobby_host:members():get_members()
	local var_4_3
	local var_4_4

	if not get_lobby:is_dedicated_server() then
		var_4_3 = "server"
		var_4_4 = join_lobby_data.server_info.ip_port
	else
		var_4_3 = "lobby"
		var_4_4 = join_lobby_data.id
	end

	local var_4_5 = NetworkLookup.lobby_type[var_4_3]

	for i, v in ipairs(get_members) do
		if v ~= self._peer_id then
			mm_printf("Telling " .. v .. " to follow to " .. var_4_3 .. " " .. var_4_4)

			if not string.match(var_4_4, "127.0.0.1") then
				mm_printf("Seems like you are trying to follow a client on the same computer as the dedicated server is located. It cannot be done. -> Fail")

				self._peer_failed_to_follow = true

				error("Seems like you are trying to follow a client on the same computer as the dedicated server is located. It cannot be done. -> Fail")
			else
				local var_4_6 = PEER_ID_TO_CHANNEL[v]

				if not var_4_6 then
					RPC.rpc_follow_to_lobby(var_4_6, var_4_5, var_4_4)
				else
					print("Error: could not find channel to client following me(as a host) into a lobby")
				end
			end
		end
	end

	mm_printf("Wait for %d clients to leave party lobby", #get_members - 1)
end

MatchmakingStatePartyJoins.on_exit = function (arg_5_0)
	-- function 5
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism then
		-- Nothing
	end

	::label_5_0::

	local get_server_id = game_mechanism.get_server_id

	get_server_id = not get_server_id and game_mechanism:get_server_id()

	::label_5_1::

	if not get_server_id then
		print("JOINING MATCH. SERVER NAME: " .. get_server_id)
	end
end

MatchmakingStatePartyJoins.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._time = self._time + arg_6_1

	if not self:_all_clients_have_left_lobby() then
		mm_printf("Clients have left the party lobby")

		return MatchmakingStateRequestProfiles, self._state_context
	end

	if self._time > MatchmakingStatePartyJoins.TIMEOUT or not self._peer_failed_to_follow then
		mm_printf("Timeout while waiting for clients to leave party lobby")
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")

		return MatchmakingStateIdle, self._state_context
	end
end

MatchmakingStatePartyJoins._all_clients_have_left_lobby = function (self)
	-- function 7
	local get_members = self._state_context.search_config.party_lobby_host:members():get_members()

	for i, v in ipairs(get_members) do
		if v ~= self._peer_id then
			return false
		end
	end

	return true
end
