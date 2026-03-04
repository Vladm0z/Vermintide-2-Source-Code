-- chunkname: @scripts/managers/matchmaking/matchmaking_state_reserve_lobby.lua

require("scripts/game_state/server_search_utils")
require("scripts/game_state/server_party_reserve_state_machine")

local var_0_0 = 2

MatchmakingStateReserveLobby = class(MatchmakingStateReserveLobby)
MatchmakingStateReserveLobby.NAME = "MatchmakingStateReserveLobby"

function MatchmakingStateReserveLobby.init(arg_1_0, arg_1_1)
	arg_1_0._network_options = arg_1_1.network_options
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._reserver = nil
	arg_1_0._state = nil
	arg_1_0._wait_for_join_message = nil
	arg_1_0._join_lobby_data = nil
	arg_1_0._received_join_message = nil
	arg_1_0._request_timer = 0
	arg_1_0._lobby = arg_1_1.lobby

	Managers.state.event:register(arg_1_0, "friend_party_peer_left", "on_friend_party_peer_left")
end

function MatchmakingStateReserveLobby.terminate(arg_2_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

function MatchmakingStateReserveLobby.destroy(arg_3_0)
	arg_3_0:_cleanup()
end

function MatchmakingStateReserveLobby.on_enter(arg_4_0, arg_4_1)
	arg_4_0._state_context = arg_4_1
	arg_4_0._wait_for_join_message = arg_4_1.search_config.wait_for_join_message

	local var_4_0 = arg_4_1.search_config
	local var_4_1 = var_4_0.party_lobby_host

	arg_4_0._party_lobby_host = var_4_1
	arg_4_0._cleanup_server_lobby = true

	local var_4_2 = var_4_1:members():get_members()

	if arg_4_1.is_flexmatch then
		local var_4_3 = arg_4_1.server_info

		Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "MatchmakingStateReserveLobby (on_enter)", arg_4_0._network_options, arg_4_1, var_4_3.password, var_4_2)

		arg_4_0._state = "reserving"
	else
		if not var_4_0.linux then
			arg_4_0._optional_filters = {
				matchmaking_filters = {
					name = {
						value = "AWS Gamelift unknown",
						comparison = "not_equal"
					}
				}
			}
		end

		arg_4_0:_start_search(var_4_2, arg_4_0._optional_filters)
	end
end

function MatchmakingStateReserveLobby.on_exit(arg_5_0)
	arg_5_0:_cleanup()
end

function MatchmakingStateReserveLobby.update(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._state
	local var_6_1 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if var_6_1 and arg_6_2 > arg_6_0._request_timer then
		var_6_1:request_data()

		arg_6_0._request_timer = arg_6_2 + var_0_0
	end

	if var_6_0 == "reserving" then
		local var_6_2
		local var_6_3

		if arg_6_0._reserver then
			arg_6_0._reserver:update(arg_6_1, arg_6_2)

			var_6_2, var_6_1, var_6_3 = arg_6_0._reserver:result()
		elseif var_6_1 then
			var_6_1:update(arg_6_1)

			var_6_2 = var_6_1:state()
		end

		if var_6_2 == "reserved" then
			if arg_6_0._reserver then
				Managers.lobby:register_existing_lobby(var_6_1, "matchmaking_join_lobby", "MatchmakingStateReserveLobby (update)")
			end

			if arg_6_0._reserver then
				arg_6_0._join_lobby_data = var_6_3
			else
				arg_6_0._join_lobby_data = table.clone(arg_6_0._state_context)
			end

			local var_6_4 = arg_6_0._state_context.search_config

			if var_6_4 and var_6_4.aws then
				arg_6_0._state = "send_queue_tickets"
			elseif arg_6_0._wait_for_join_message then
				arg_6_0._state = "waiting_for_join_message"
			else
				arg_6_0:_claim_reservation(arg_6_0._state_context)

				return MatchmakingStateRequestJoinGame, arg_6_0._state_context
			end
		elseif var_6_2 == "failed" then
			local var_6_5 = arg_6_0._state_context.search_config

			if arg_6_0._state_context.is_flexmatch then
				return MatchmakingStateIdle, arg_6_0._state_context
			elseif var_6_5.player_hosted then
				return MatchmakingStateSearchPlayerHostedLobby, arg_6_0._state_context
			elseif var_6_5.dedicated_server then
				arg_6_0._state = "reserving"
			else
				return MatchmakingStateIdle, arg_6_0._state_context
			end
		end
	elseif var_6_0 == "send_queue_tickets" then
		local var_6_6 = Managers.lobby:get_lobby("matchmaking_join_lobby").lobby

		if SteamGameServerLobby.state(var_6_6) == "failed" then
			arg_6_0:_reset()

			return MatchmakingStateIdle, arg_6_0._state_context
		end

		if not Managers.mechanism:dedicated_server_peer_id() then
			return
		end

		if arg_6_0._wait_for_join_message then
			arg_6_0._state = "waiting_for_join_message"
		else
			arg_6_0:_claim_reservation(arg_6_0._state_context)

			return MatchmakingStateRequestJoinGame, arg_6_0._state_context
		end
	elseif var_6_0 == "waiting_for_join_message" then
		if arg_6_0._received_join_message then
			arg_6_0:_claim_reservation(arg_6_0._state_context)

			return MatchmakingStateRequestJoinGame, arg_6_0._state_context
		end

		local var_6_7 = Managers.lobby:get_lobby("matchmaking_join_lobby").lobby

		if SteamGameServerLobby.state(var_6_7) == "failed" then
			arg_6_0:_reset()

			local var_6_8 = arg_6_0._state_context.search_config

			if var_6_8 and var_6_8.aws then
				return MatchmakingStateIdle, arg_6_0._state_context
			else
				local var_6_9 = arg_6_0._party_lobby_host:members():get_members()

				arg_6_0:_start_search(var_6_9, arg_6_0._optional_filters)
			end
		end
	end
end

function MatchmakingStateReserveLobby._reset(arg_7_0)
	local var_7_0 = Managers.mechanism:game_mechanism()

	if var_7_0.reset_dedicated_slots_count and var_7_0.reset_party_info then
		var_7_0:reset_dedicated_slots_count()
		var_7_0:reset_party_info()
	end

	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	arg_7_0._join_lobby_data = nil
end

function MatchmakingStateReserveLobby.rpc_join_reserved_game_server(arg_8_0, arg_8_1)
	arg_8_0._received_join_message = true
end

function MatchmakingStateReserveLobby._cleanup(arg_9_0)
	if arg_9_0._reserver ~= nil then
		arg_9_0._reserver:destroy()

		arg_9_0._reserver = nil
	end

	if arg_9_0._cleanup_server_lobby and Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	arg_9_0._state = nil
	arg_9_0._wait_for_join_message = nil

	local var_9_0 = Managers.state.event

	if var_9_0 then
		var_9_0:unregister("friend_party_peer_left", arg_9_0)
	end
end

function MatchmakingStateReserveLobby._start_search(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.mechanism:get_custom_lobby_sort()
	local var_10_1 = Managers.matchmaking:broken_server_map()
	local var_10_2 = not Managers.state.game_mode:setting("allow_hotjoining_ongoing_game")
	local var_10_3 = false
	local var_10_4 = {
		soft_filters = {
			filter_fully_reserved_servers = true,
			hotjoin_disabled_game_states = true,
			remove_started_servers = var_10_2,
			check_server_name = var_10_3
		}
	}

	if arg_10_0._reserver then
		arg_10_0._reserver:destroy()
	end

	arg_10_0._reserver = ServerPartyReserveStateMachine:new(arg_10_0._network_options, arg_10_1, var_10_0, var_10_1, arg_10_2, var_10_4)

	local var_10_5 = arg_10_0._lobby:get_stored_lobby_data()

	var_10_5.matchmaking = "searching"
	var_10_5.time_of_search = tostring(os.time())

	arg_10_0._lobby:set_lobby_data(var_10_5)

	arg_10_0._state = "reserving"
end

function MatchmakingStateReserveLobby._claim_reservation(arg_11_0, arg_11_1)
	local var_11_0 = Managers.lobby:free_lobby("matchmaking_join_lobby")

	arg_11_1.reserved_lobby = var_11_0
	arg_11_1.join_lobby_data = arg_11_0._join_lobby_data

	var_11_0:claim_reserved()

	arg_11_0._join_lobby_data = nil
	arg_11_0._cleanup_server_lobby = false
end

function MatchmakingStateReserveLobby.on_friend_party_peer_left(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_2 then
		Managers.matchmaking:cancel_matchmaking()
	end
end

function MatchmakingStateReserveLobby.rpc_flexmatch_game_session_id_request(arg_13_0, arg_13_1)
	if arg_13_0._flexmatch_response_sent then
		return
	end

	local var_13_0 = NetworkUtils.net_pack_flexmatch_ticket(arg_13_0._state_context.game_session_id)

	RPC.rpc_flexmatch_game_session_id_response(arg_13_1, var_13_0)

	arg_13_0._flexmatch_response_sent = true
end
