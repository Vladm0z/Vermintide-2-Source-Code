-- chunkname: @scripts/managers/matchmaking/matchmaking_state_reserve_lobby.lua

require("scripts/game_state/server_search_utils")
require("scripts/game_state/server_party_reserve_state_machine")

local num = 2

MatchmakingStateReserveLobby = class(MatchmakingStateReserveLobby)
MatchmakingStateReserveLobby.NAME = "MatchmakingStateReserveLobby"

MatchmakingStateReserveLobby.init = function (self, arg_1_1)
	-- function 1
	self._network_options = arg_1_1.network_options
	self._network_transmit = arg_1_1.network_transmit
	self._reserver = nil
	self._state = nil
	self._wait_for_join_message = nil
	self._join_lobby_data = nil
	self._received_join_message = nil
	self._request_timer = 0
	self._lobby = arg_1_1.lobby

	Managers.state.event:register(self, "friend_party_peer_left", "on_friend_party_peer_left")
end

MatchmakingStateReserveLobby.terminate = function (arg_2_0)
	-- function 2
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

MatchmakingStateReserveLobby.destroy = function (self)
	-- function 3
	self:_cleanup()
end

MatchmakingStateReserveLobby.on_enter = function (self, arg_4_1)
	-- function 4
	self._state_context = arg_4_1
	self._wait_for_join_message = arg_4_1.search_config.wait_for_join_message

	local search_config = arg_4_1.search_config
	local party_lobby_host = search_config.party_lobby_host

	self._party_lobby_host = party_lobby_host
	self._cleanup_server_lobby = true

	local get_members = party_lobby_host:members():get_members()

	if not arg_4_1.is_flexmatch then
		local server_info = arg_4_1.server_info

		Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "MatchmakingStateReserveLobby (on_enter)", self._network_options, arg_4_1, server_info.password, get_members)

		self._state = "reserving"
	else
		if not search_config.linux then
			self._optional_filters = {
				matchmaking_filters = {
					name = {
						value = "AWS Gamelift unknown",
						comparison = "not_equal"
					}
				}
			}
		end

		self:_start_search(get_members, self._optional_filters)
	end
end

MatchmakingStateReserveLobby.on_exit = function (self)
	-- function 5
	self:_cleanup()
end

MatchmakingStateReserveLobby.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _state = self._state
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not (not query_lobby and not (arg_6_2 > self._request_timer)) then
		query_lobby:request_data()

		self._request_timer = arg_6_2 + num
	end

	if _state == "reserving" then
		local var_6_2
		local var_6_3

		if not self._reserver then
			self._reserver:update(arg_6_1, arg_6_2)

			var_6_2, query_lobby, var_6_3 = self._reserver:result()
		elseif not query_lobby then
			query_lobby:update(arg_6_1)

			var_6_2 = query_lobby:state()
		end

		if var_6_2 == "reserved" then
			if not self._reserver then
				Managers.lobby:register_existing_lobby(query_lobby, "matchmaking_join_lobby", "MatchmakingStateReserveLobby (update)")
			end

			if not self._reserver then
				self._join_lobby_data = var_6_3
			else
				self._join_lobby_data = table.clone(self._state_context)
			end

			local search_config = self._state_context.search_config

			if not search_config and not search_config.aws then
				self._state = "send_queue_tickets"
			elseif not self._wait_for_join_message then
				self._state = "waiting_for_join_message"
			else
				self:_claim_reservation(self._state_context)

				return MatchmakingStateRequestJoinGame, self._state_context
			end
		elseif var_6_2 == "failed" then
			local search_config_2 = self._state_context.search_config

			if not self._state_context.is_flexmatch then
				return MatchmakingStateIdle, self._state_context
			elseif not search_config_2.player_hosted then
				return MatchmakingStateSearchPlayerHostedLobby, self._state_context
			elseif not search_config_2.dedicated_server then
				self._state = "reserving"
			else
				return MatchmakingStateIdle, self._state_context
			end
		end
	elseif _state == "send_queue_tickets" then
		local lobby = Managers.lobby:get_lobby("matchmaking_join_lobby").lobby

		if SteamGameServerLobby.state(lobby) == "failed" then
			self:_reset()

			return MatchmakingStateIdle, self._state_context
		end

		if not Managers.mechanism:dedicated_server_peer_id() then
			return
		end

		if not self._wait_for_join_message then
			self._state = "waiting_for_join_message"
		else
			self:_claim_reservation(self._state_context)

			return MatchmakingStateRequestJoinGame, self._state_context
		end
	elseif _state == "waiting_for_join_message" then
		if not self._received_join_message then
			self:_claim_reservation(self._state_context)

			return MatchmakingStateRequestJoinGame, self._state_context
		end

		local lobby_2 = Managers.lobby:get_lobby("matchmaking_join_lobby").lobby

		if SteamGameServerLobby.state(lobby_2) == "failed" then
			self:_reset()

			local search_config_3 = self._state_context.search_config

			if not search_config_3 and not search_config_3.aws then
				return MatchmakingStateIdle, self._state_context
			else
				local get_members = self._party_lobby_host:members():get_members()

				self:_start_search(get_members, self._optional_filters)
			end
		end
	end
end

MatchmakingStateReserveLobby._reset = function (self)
	-- function 7
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.reset_dedicated_slots_count and not game_mechanism.reset_party_info then
		game_mechanism:reset_dedicated_slots_count()
		game_mechanism:reset_party_info()
	end

	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	self._join_lobby_data = nil
end

MatchmakingStateReserveLobby.rpc_join_reserved_game_server = function (self, arg_8_1)
	-- function 8
	self._received_join_message = true
end

MatchmakingStateReserveLobby._cleanup = function (self)
	-- function 9
	if self._reserver ~= nil then
		self._reserver:destroy()

		self._reserver = nil
	end

	if not self._cleanup_server_lobby and not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	self._state = nil
	self._wait_for_join_message = nil

	local event = Managers.state.event

	if not event then
		event:unregister("friend_party_peer_left", self)
	end
end

MatchmakingStateReserveLobby._start_search = function (self, arg_10_1, arg_10_2)
	-- function 10
	local get_custom_lobby_sort = Managers.mechanism:get_custom_lobby_sort()
	local broken_server_map = Managers.matchmaking:broken_server_map()
	local flag = not Managers.state.game_mode:setting("allow_hotjoining_ongoing_game")
	local flag_2 = false
	local tbl = {
		soft_filters = {
			filter_fully_reserved_servers = true,
			hotjoin_disabled_game_states = true,
			remove_started_servers = flag,
			check_server_name = flag_2
		}
	}

	if not self._reserver then
		self._reserver:destroy()
	end

	self._reserver = ServerPartyReserveStateMachine:new(self._network_options, arg_10_1, get_custom_lobby_sort, broken_server_map, arg_10_2, tbl)

	local get_stored_lobby_data = self._lobby:get_stored_lobby_data()

	get_stored_lobby_data.matchmaking = "searching"
	get_stored_lobby_data.time_of_search = tostring(os.time())

	self._lobby:set_lobby_data(get_stored_lobby_data)

	self._state = "reserving"
end

MatchmakingStateReserveLobby._claim_reservation = function (self, arg_11_1)
	-- function 11
	local free_lobby = Managers.lobby:free_lobby("matchmaking_join_lobby")

	arg_11_1.reserved_lobby = free_lobby
	arg_11_1.join_lobby_data = self._join_lobby_data

	free_lobby:claim_reserved()

	self._join_lobby_data = nil
	self._cleanup_server_lobby = false
end

MatchmakingStateReserveLobby.on_friend_party_peer_left = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not arg_12_2 then
		Managers.matchmaking:cancel_matchmaking()
	end
end

MatchmakingStateReserveLobby.rpc_flexmatch_game_session_id_request = function (self, arg_13_1)
	-- function 13
	if not self._flexmatch_response_sent then
		return
	end

	local net_pack_flexmatch_ticket = NetworkUtils.net_pack_flexmatch_ticket(self._state_context.game_session_id)

	RPC.rpc_flexmatch_game_session_id_response(arg_13_1, net_pack_flexmatch_ticket)

	self._flexmatch_response_sent = true
end
