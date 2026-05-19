-- chunkname: @scripts/managers/matchmaking/matchmaking_state_host_game.lua

MatchmakingStateHostGame = class(MatchmakingStateHostGame)
MatchmakingStateHostGame.NAME = "MatchmakingStateHostGame"

function MatchmakingStateHostGame.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._difficulty_manager = arg_1_1.difficulty
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._wwise_world = arg_1_1.wwise_world
end

function MatchmakingStateHostGame.destroy(arg_2_0)
	return
end

function MatchmakingStateHostGame.on_enter(arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
	arg_3_0.search_config = arg_3_1.search_config

	arg_3_0:_start_hosting_game()

	if DEDICATED_SERVER then
		arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_found_game")

		local var_3_0 = "versus_hud_player_lobby_match_found"
		local var_3_1 = Managers.state.network.network_transmit
		local var_3_2 = NetworkLookup.sound_events[var_3_0]
		local var_3_3 = Managers.party:server_get_friend_party_leaders()

		for iter_3_0, iter_3_1 in pairs(var_3_3) do
			if PEER_ID_TO_CHANNEL[iter_3_1] then
				var_3_1:send_rpc("rpc_vs_play_matchmaking_sfx", iter_3_1, var_3_2)
			end
		end
	else
		arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_start_hosting_game")
	end

	if not DEDICATED_SERVER then
		arg_3_0:set_debug_info()

		local var_3_4 = Managers.player:local_player()
		local var_3_5 = "started_hosting"
		local var_3_6 = Managers.time:time("main") - arg_3_0.state_context.started_matchmaking_t
		local var_3_7 = arg_3_0.search_config.strict_matchmaking

		Managers.telemetry_events:matchmaking_hosting(var_3_4, var_3_6, arg_3_0.search_config)

		arg_3_0.state_context.started_hosting_t = Managers.time:time("main")
	end
end

function MatchmakingStateHostGame.set_debug_info(arg_4_0)
	local var_4_0 = arg_4_0.search_config
	local var_4_1 = var_4_0.mission_id
	local var_4_2 = var_4_0.difficulty
	local var_4_3 = Network.peer_id()
	local var_4_4 = Managers.player:player_from_peer_id(var_4_3):profile_index()
	local var_4_5 = var_4_4 and SPProfiles[var_4_4]
	local var_4_6 = var_4_5 and var_4_5.display_name or "random"

	Managers.matchmaking.debug.state = "hosting game"
	Managers.matchmaking.debug.mission_id = var_4_1
	Managers.matchmaking.debug.difficulty = var_4_2
	Managers.matchmaking.debug.hero = var_4_6
end

function MatchmakingStateHostGame.on_exit(arg_5_0)
	return
end

function MatchmakingStateHostGame.update(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._wait_to_start_game then
		return MatchmakingStateWaitForCountdown, arg_6_0.state_context
	elseif arg_6_0._skip_waystone then
		return MatchmakingStateStartGame, arg_6_0.state_context
	else
		return MatchmakingStateWaitForCountdown, arg_6_0.state_context
	end
end

function MatchmakingStateHostGame._start_hosting_game(arg_7_0)
	local var_7_0 = arg_7_0.state_context
	local var_7_1 = arg_7_0.search_config
	local var_7_2 = var_7_1.mission_id
	local var_7_3 = var_7_1.act_key
	local var_7_4 = var_7_1.difficulty
	local var_7_5 = var_7_1.matchmaking_type
	local var_7_6 = var_7_1.private_game
	local var_7_7 = var_7_1.mechanism

	fassert(var_7_6 ~= nil, "Private status variable wasn't set.")

	local var_7_8 = var_7_1.quick_game
	local var_7_9 = Managers.eac:is_trusted()
	local var_7_10 = Managers.mechanism:current_mechanism_name()

	if not DEDICATED_SERVER and var_7_10 == "versus" then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("menu_wind_countdown_warning")
	end

	arg_7_0._difficulty_manager:set_difficulty(var_7_4, 0)

	local var_7_11 = arg_7_0._lobby:is_dedicated_server()

	if not var_7_11 then
		Managers.party:set_leader(arg_7_0._lobby:lobby_host())
	end

	if not (Managers.party:is_leader(Network.peer_id()) and var_7_11) then
		arg_7_0._matchmaking_manager:set_matchmaking_data(var_7_2, var_7_4, var_7_3, var_7_5, var_7_6, var_7_8, var_7_9, 0, var_7_7)
		arg_7_0._matchmaking_manager:set_game_privacy(var_7_6)
	end

	arg_7_0._game_created = true
	arg_7_0._wait_to_start_game = arg_7_0.search_config.wait_to_start_game
	arg_7_0._skip_waystone = arg_7_0.search_config.skip_waystone

	if arg_7_0._wait_to_start_game then
		-- block empty
	elseif not arg_7_0._skip_waystone then
		local var_7_12 = 1

		if var_7_7 == "weave" then
			var_7_12 = 3
		elseif not var_7_8 and var_7_5 ~= "event" then
			var_7_12 = LevelSettings[var_7_2].waystone_type or var_7_12
		elseif var_7_8 and var_7_7 == "weave" then
			var_7_12 = 3
		end

		arg_7_0._matchmaking_manager:activate_waystone_portal(var_7_12)
	end
end
