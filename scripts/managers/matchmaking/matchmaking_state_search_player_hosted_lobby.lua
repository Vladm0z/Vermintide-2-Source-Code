-- chunkname: @scripts/managers/matchmaking/matchmaking_state_search_player_hosted_lobby.lua

MatchmakingStateSearchPlayerHostedLobby = class(MatchmakingStateSearchPlayerHostedLobby)
MatchmakingStateSearchPlayerHostedLobby.NAME = "MatchmakingStateSearchPlayerHostedLobby"

function MatchmakingStateSearchPlayerHostedLobby.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._lobby_finder = arg_1_1.lobby_finder
	arg_1_0._peer_id = Network.peer_id()
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_server = arg_1_1.network_server
	arg_1_0._statistics_db = arg_1_1.statistics_db
	Managers.matchmaking.countdown_has_finished = false
end

function MatchmakingStateSearchPlayerHostedLobby.destroy(arg_2_0)
	return
end

function MatchmakingStateSearchPlayerHostedLobby.on_enter(arg_3_0, arg_3_1)
	arg_3_0._state_context = arg_3_1
	arg_3_0._search_config = arg_3_1.search_config

	arg_3_0:_initialize_search()
end

function MatchmakingStateSearchPlayerHostedLobby._initialize_search(arg_4_0)
	local var_4_0 = arg_4_0._search_config
	local var_4_1 = {}

	if not var_4_0.quick_game then
		local var_4_2 = var_4_0.mission_id

		if var_4_2 then
			var_4_1.selected_mission_id = {
				comparison = "equal",
				value = var_4_2
			}
		end
	end

	local var_4_3 = Managers.eac:is_trusted()

	var_4_1.eac_authorized = {
		comparison = "equal",
		value = var_4_3 and "true" or "false"
	}
	var_4_1.mechanism = {
		comparison = "equal",
		value = var_4_0.mechanism
	}
	arg_4_0._current_filters = var_4_1
	arg_4_0._current_distance_filter = "close"
	arg_4_0._current_near_filters = {}

	arg_4_0._matchmaking_manager:setup_filter_requirements(1, arg_4_0._current_distance_filter, arg_4_0._current_filters, arg_4_0._current_near_filters)

	local var_4_4 = arg_4_0._lobby:get_stored_lobby_data()

	var_4_4.matchmaking = "searching"

	arg_4_0._lobby:set_lobby_data(var_4_4)
	Managers.level_transition_handler:clear_next_level()
	arg_4_0._lobby_finder:refresh()

	local var_4_5 = Managers.player:local_player()

	Managers.telemetry_events:matchmaking_search(var_4_5, arg_4_0._search_config)
	arg_4_0._matchmaking_manager:send_system_chat_message("matchmaking_status_start_search")
end

function MatchmakingStateSearchPlayerHostedLobby.on_exit(arg_5_0)
	return
end

function MatchmakingStateSearchPlayerHostedLobby.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._lobby_finder:update(arg_6_1)

	if arg_6_0._lobby_finder:is_refreshing() then
		return
	end

	local var_6_0 = arg_6_0:_search_for_game(arg_6_1)

	if var_6_0 then
		arg_6_0._matchmaking_manager:send_system_chat_message("matchmaking_status_found_game")

		arg_6_0._state_context.join_lobby_data = var_6_0

		return MatchmakingStateReserveSlotsPlayerHosted, arg_6_0._state_context
	else
		local var_6_1 = arg_6_0._current_distance_filter
		local var_6_2 = LobbyAux.get_next_lobby_distance_filter(var_6_1, MatchmakingSettings.max_distance_filter)

		if var_6_2 ~= nil then
			mm_printf("Changing distance filter from %s to %s", var_6_1, var_6_2)
			arg_6_0._matchmaking_manager:setup_filter_requirements(1, var_6_2, arg_6_0._current_filters, arg_6_0._current_near_filters)

			arg_6_0._current_distance_filter = var_6_2

			arg_6_0._matchmaking_manager:send_system_chat_message("matchmaking_status_increased_search_range")
		end

		arg_6_0._lobby_finder:refresh()
	end
end

local var_0_0 = {}

function MatchmakingStateSearchPlayerHostedLobby._search_for_game(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._lobby_finder:lobbies()
	local var_7_1 = arg_7_0._search_config
	local var_7_2 = arg_7_0._matchmaking_manager
	local var_7_3
	local var_7_4 = var_7_1.mission_id

	if var_7_4 then
		var_7_3 = {
			var_7_4
		}
	else
		var_7_3 = table.clone(Managers.mechanism:mechanism_setting_for_title("map_pool"))
		var_7_3[#var_7_3 + 1] = "any"
	end

	return arg_7_0:_find_suitable_lobby(var_7_0, var_7_1, var_7_3)
end

function MatchmakingStateSearchPlayerHostedLobby._find_suitable_lobby(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_2.mission_id
	local var_8_1 = arg_8_2.difficulty
	local var_8_2 = arg_8_2.matchmaking_type
	local var_8_3 = arg_8_2.mechanism
	local var_8_4 = MatchmakingSettings.max_distance_filter
	local var_8_5 = arg_8_0._current_distance_filter == var_8_4
	local var_8_6
	local var_8_7
	local var_8_8 = arg_8_0._matchmaking_manager

	for iter_8_0, iter_8_1 in pairs(arg_8_3) do
		for iter_8_2, iter_8_3 in ipairs(arg_8_1) do
			local var_8_9, var_8_10 = arg_8_0:_lobby_match(iter_8_3, iter_8_1, var_8_1, var_8_2, arg_8_0._peer_id)

			if var_8_9 then
				local var_8_11 = false
				local var_8_12
				local var_8_13 = false

				if not LevelSettings[iter_8_3.mission_id].hub_level then
					var_8_13 = true
				end

				if iter_8_3.host_afk == "true" then
					var_8_13 = true
				end

				if var_8_13 and not var_8_5 then
					var_8_11 = true
					var_8_12 = "secondary lobby before reaching max distance"
				end

				if not var_8_11 then
					if not var_8_13 then
						var_8_6 = arg_8_0:_compare_first_prio_lobbies(var_8_6, iter_8_3)
					else
						var_8_7 = arg_8_0:_compare_secondary_prio_lobbies(var_8_7, iter_8_3)
					end
				else
					local var_8_14 = iter_8_3.unique_server_name or iter_8_3.host

					print("[MatchmakingStateSearchPlayerHostedLobby] Lobby hosted by %s discarded due to '%s'", var_8_14, var_8_12 or "unknown")
				end
			else
				local var_8_15 = iter_8_3.unique_server_name or iter_8_3.host

				print("[MatchmakingStateSearchPlayerHostedLobby] Lobby hosted by %s failed lobby match due to '%s'", var_8_15, var_8_10 or "unknown")
			end
		end

		if var_8_6 then
			break
		end
	end

	return var_8_6 or var_8_7
end

function MatchmakingStateSearchPlayerHostedLobby._lobby_match(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_0._state_context.search_config
	local var_9_1 = arg_9_0._matchmaking_manager
	local var_9_2 = arg_9_1.id

	if var_9_1:lobby_listed_as_broken(var_9_2) then
		return false, "lobby listed as broken"
	end

	if arg_9_1.host == arg_9_5 then
		return false, "players own lobby"
	end

	if IS_WINDOWS then
		local var_9_3 = LobbyAux.deserialize_lobby_reservation_data(arg_9_1)

		for iter_9_0 = 1, #var_9_3 do
			local var_9_4 = var_9_3[iter_9_0]

			for iter_9_1 = 1, #var_9_4 do
				local var_9_5 = var_9_4[iter_9_1].peer_id
				local var_9_6 = Friends.relationship(var_9_5)

				if var_9_6 == 5 or var_9_6 == 6 then
					return false, "user blocked"
				end
			end
		end
	end

	if arg_9_1.twitch_enabled == "true" then
		return false, "twitch_mode"
	end

	if not (arg_9_1.matchmaking ~= "false" and arg_9_1.valid) then
		return false, "lobby is not valid"
	end

	if arg_9_2 then
		local var_9_7 = false
		local var_9_8 = "<no lobby level>"

		if arg_9_1.selected_mission_id then
			var_9_7 = arg_9_1.selected_mission_id == arg_9_2
			var_9_8 = string.format("(%s ~= %s)", arg_9_2, arg_9_1.selected_mission_id)
		elseif arg_9_1.mission_id then
			var_9_7 = arg_9_1.mission_id == arg_9_2
			var_9_8 = string.format("(%s ~= %s)", arg_9_2, arg_9_1.mission_id)
		end

		if not var_9_7 then
			return false, "wrong mission " .. var_9_8
		end
	end

	if arg_9_3 and not (arg_9_1.difficulty == arg_9_3) then
		return false, "wrong difficulty"
	end

	local var_9_9 = var_9_0.party_lobby_host
	local var_9_10 = var_9_9 and var_9_9:members()
	local var_9_11 = var_9_10 and var_9_10:get_members()
	local var_9_12 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_9_1.mechanism)
	local var_9_13 = var_9_11 and #var_9_11 or 1
	local var_9_14 = arg_9_1.num_players and tonumber(arg_9_1.num_players)
	local var_9_15 = var_9_0.max_number_of_players or var_9_12.MAX_NUMBER_OF_PLAYERS

	if not (var_9_14 and var_9_15 >= var_9_14 + var_9_13) then
		return false, "not enough empty slots"
	end

	return true
end

function MatchmakingStateSearchPlayerHostedLobby._compare_first_prio_lobbies(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 == nil then
		return arg_10_2
	end

	local var_10_0 = arg_10_0._search_config

	return arg_10_1
end

function MatchmakingStateSearchPlayerHostedLobby._compare_secondary_prio_lobbies(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 == nil then
		return arg_11_2
	end

	local var_11_0 = arg_11_0._search_config

	return arg_11_1
end
