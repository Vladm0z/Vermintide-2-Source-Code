-- chunkname: @scripts/managers/matchmaking/matchmaking_state_player_hosted_game.lua

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

MatchmakingStatePlayerHostedGame = class(MatchmakingStatePlayerHostedGame)
MatchmakingStatePlayerHostedGame.NAME = "MatchmakingStatePlayerHostedGame"

MatchmakingStatePlayerHostedGame.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_transmit = arg_1_1.network_transmit
	self._difficulty_manager = arg_1_1.difficulty
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._profile_synchronizer = arg_1_1.profile_synchronizer
	self._wwise_world = arg_1_1.wwise_world
end

MatchmakingStatePlayerHostedGame.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStatePlayerHostedGame.on_enter = function (self, arg_3_1)
	-- function 3
	self._state_context = arg_3_1
	self._search_config = arg_3_1.search_config
	self._search_config.is_player_hosted = true

	self:_start_hosting_game()
	self._matchmaking_manager:send_system_chat_message("matchmaking_status_start_hosting_game")
	self._matchmaking_manager:set_lobby_data_match_started(false)
end

MatchmakingStatePlayerHostedGame.on_exit = function (arg_4_0)
	-- function 4
	return
end

MatchmakingStatePlayerHostedGame.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	return self._new_state, self._state_context
end

MatchmakingStatePlayerHostedGame.force_start_game = function (self)
	-- function 6
	local game_mechanism = Managers.mechanism:game_mechanism()

	if game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game):all_teams_have_members() or not Development.parameter("allow_versus_force_start_single_player") then
		self._state_context.clients_not_in_game_session = true
		self._search_config.is_player_hosted = false
		self._new_state = MatchmakingStateStartGame

		Managers.matchmaking:set_lobby_data_match_started(true)
		game_mechanism:move_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

		local str = "versus_hud_player_lobby_match_found"

		Managers.state.entity:system("audio_system"):play_sound_local(str)

		local network_transmit = Managers.state.network.network_transmit
		local var_6_3 = NetworkLookup.sound_events[str]
		local server_get_friend_party_leaders = Managers.party:server_get_friend_party_leaders()

		for k, v in pairs(server_get_friend_party_leaders) do
			if not PEER_ID_TO_CHANNEL[v] then
				network_transmit:send_rpc("rpc_vs_play_matchmaking_sfx", v, var_6_3)
			end
		end

		if not game_mechanism.server_decide_side_order then
			game_mechanism:server_decide_side_order()
		end
	end
end

MatchmakingStatePlayerHostedGame._start_hosting_game = function (self)
	-- function 7
	local _state_context = self._state_context
	local _search_config = self._search_config
	local mission_id = _search_config.mission_id
	local difficulty = _search_config.difficulty
	local matchmaking_type = _search_config.matchmaking_type
	local quick_game = _search_config.quick_game
	local private_game = _search_config.private_game
	local mechanism = _search_config.mechanism
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.set_is_hosting_versus_custom_game then
		game_mechanism:set_is_hosting_versus_custom_game(true)
	end

	local is_trusted = Managers.eac:is_trusted()

	self._difficulty_manager:set_difficulty(difficulty, 0)
	Managers.party:set_leader(self._lobby:lobby_host())
	self._matchmaking_manager:set_matchmaking_data(mission_id, difficulty, nil, matchmaking_type, private_game, quick_game, is_trusted, 0, mechanism)
	self._matchmaking_manager:set_game_privacy(private_game)
end
