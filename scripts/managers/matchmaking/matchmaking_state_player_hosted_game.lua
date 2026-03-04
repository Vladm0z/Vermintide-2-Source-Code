-- chunkname: @scripts/managers/matchmaking/matchmaking_state_player_hosted_game.lua

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

MatchmakingStatePlayerHostedGame = class(MatchmakingStatePlayerHostedGame)
MatchmakingStatePlayerHostedGame.NAME = "MatchmakingStatePlayerHostedGame"

function MatchmakingStatePlayerHostedGame.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._difficulty_manager = arg_1_1.difficulty
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0._wwise_world = arg_1_1.wwise_world
end

function MatchmakingStatePlayerHostedGame.destroy(arg_2_0)
	return
end

function MatchmakingStatePlayerHostedGame.on_enter(arg_3_0, arg_3_1)
	arg_3_0._state_context = arg_3_1
	arg_3_0._search_config = arg_3_1.search_config
	arg_3_0._search_config.is_player_hosted = true

	arg_3_0:_start_hosting_game()
	arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_start_hosting_game")
	arg_3_0._matchmaking_manager:set_lobby_data_match_started(false)
end

function MatchmakingStatePlayerHostedGame.on_exit(arg_4_0)
	return
end

function MatchmakingStatePlayerHostedGame.update(arg_5_0, arg_5_1, arg_5_2)
	return arg_5_0._new_state, arg_5_0._state_context
end

function MatchmakingStatePlayerHostedGame.force_start_game(arg_6_0)
	local var_6_0 = Managers.mechanism:game_mechanism()

	if var_6_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.pending_custom_game):all_teams_have_members() or Development.parameter("allow_versus_force_start_single_player") then
		arg_6_0._state_context.clients_not_in_game_session = true
		arg_6_0._search_config.is_player_hosted = false
		arg_6_0._new_state = MatchmakingStateStartGame

		Managers.matchmaking:set_lobby_data_match_started(true)
		var_6_0:move_slot_reservation_handler(Network.peer_id(), var_0_0.pending_custom_game, var_0_0.session)

		local var_6_1 = "versus_hud_player_lobby_match_found"

		Managers.state.entity:system("audio_system"):play_sound_local(var_6_1)

		local var_6_2 = Managers.state.network.network_transmit
		local var_6_3 = NetworkLookup.sound_events[var_6_1]
		local var_6_4 = Managers.party:server_get_friend_party_leaders()

		for iter_6_0, iter_6_1 in pairs(var_6_4) do
			if PEER_ID_TO_CHANNEL[iter_6_1] then
				var_6_2:send_rpc("rpc_vs_play_matchmaking_sfx", iter_6_1, var_6_3)
			end
		end

		if var_6_0.server_decide_side_order then
			var_6_0:server_decide_side_order()
		end
	end
end

function MatchmakingStatePlayerHostedGame._start_hosting_game(arg_7_0)
	local var_7_0 = arg_7_0._state_context
	local var_7_1 = arg_7_0._search_config
	local var_7_2 = var_7_1.mission_id
	local var_7_3 = var_7_1.difficulty
	local var_7_4 = var_7_1.matchmaking_type
	local var_7_5 = var_7_1.quick_game
	local var_7_6 = var_7_1.private_game
	local var_7_7 = var_7_1.mechanism
	local var_7_8 = Managers.mechanism:game_mechanism()

	if var_7_8.set_is_hosting_versus_custom_game then
		var_7_8:set_is_hosting_versus_custom_game(true)
	end

	local var_7_9 = Managers.eac:is_trusted()

	arg_7_0._difficulty_manager:set_difficulty(var_7_3, 0)
	Managers.party:set_leader(arg_7_0._lobby:lobby_host())
	arg_7_0._matchmaking_manager:set_matchmaking_data(var_7_2, var_7_3, nil, var_7_4, var_7_6, var_7_5, var_7_9, 0, var_7_7)
	arg_7_0._matchmaking_manager:set_game_privacy(var_7_6)
end
