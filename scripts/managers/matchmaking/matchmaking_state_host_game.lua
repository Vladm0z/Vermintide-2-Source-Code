-- chunkname: @scripts/managers/matchmaking/matchmaking_state_host_game.lua

MatchmakingStateHostGame = class(MatchmakingStateHostGame)
MatchmakingStateHostGame.NAME = "MatchmakingStateHostGame"

MatchmakingStateHostGame.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_transmit = arg_1_1.network_transmit
	self._difficulty_manager = arg_1_1.difficulty
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._wwise_world = arg_1_1.wwise_world
end

MatchmakingStateHostGame.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateHostGame.on_enter = function (self, arg_3_1)
	-- function 3
	self.state_context = arg_3_1
	self.search_config = arg_3_1.search_config

	self:_start_hosting_game()

	if not DEDICATED_SERVER then
		self._matchmaking_manager:send_system_chat_message("matchmaking_status_found_game")

		local str = "versus_hud_player_lobby_match_found"
		local network_transmit = Managers.state.network.network_transmit
		local var_3_2 = NetworkLookup.sound_events[str]
		local server_get_friend_party_leaders = Managers.party:server_get_friend_party_leaders()

		for k, v in pairs(server_get_friend_party_leaders) do
			if not PEER_ID_TO_CHANNEL[v] then
				network_transmit:send_rpc("rpc_vs_play_matchmaking_sfx", v, var_3_2)
			end
		end
	else
		self._matchmaking_manager:send_system_chat_message("matchmaking_status_start_hosting_game")
	end

	if not DEDICATED_SERVER then
		self:set_debug_info()

		local local_player = Managers.player:local_player()
		local str_2 = "started_hosting"
		local num = Managers.time:time("main") - self.state_context.started_matchmaking_t
		local strict_matchmaking = self.search_config.strict_matchmaking

		Managers.telemetry_events:matchmaking_hosting(local_player, num, self.search_config)

		self.state_context.started_hosting_t = Managers.time:time("main")
	end
end

MatchmakingStateHostGame.set_debug_info = function (self)
	-- function 4
	local search_config = self.search_config
	local mission_id = search_config.mission_id
	local difficulty = search_config.difficulty
	local peer_id = Network.peer_id()
	local profile_index = Managers.player:player_from_peer_id(peer_id):profile_index()
	local flag = not profile_index and SPProfiles[profile_index]
	local display_name

	if not flag then
		display_name = flag.display_name

		if not display_name then
			-- Nothing
		end
	end

	display_name = "random"

	::label_4_0::

	Managers.matchmaking.debug.state = "hosting game"
	Managers.matchmaking.debug.mission_id = mission_id
	Managers.matchmaking.debug.difficulty = difficulty
	Managers.matchmaking.debug.hero = display_name
end

MatchmakingStateHostGame.on_exit = function (arg_5_0)
	-- function 5
	return
end

MatchmakingStateHostGame.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._wait_to_start_game then
		return MatchmakingStateWaitForCountdown, self.state_context
	elseif not self._skip_waystone then
		return MatchmakingStateStartGame, self.state_context
	else
		return MatchmakingStateWaitForCountdown, self.state_context
	end
end

MatchmakingStateHostGame._start_hosting_game = function (self)
	-- function 7
	local state_context = self.state_context
	local search_config = self.search_config
	local mission_id = search_config.mission_id
	local act_key = search_config.act_key
	local difficulty = search_config.difficulty
	local matchmaking_type = search_config.matchmaking_type
	local private_game = search_config.private_game
	local mechanism = search_config.mechanism

	fassert(private_game ~= nil, "Private status variable wasn't set.")

	local quick_game = search_config.quick_game
	local is_trusted = Managers.eac:is_trusted()
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if not (DEDICATED_SERVER or current_mechanism_name ~= "versus") then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("menu_wind_countdown_warning")
	end

	self._difficulty_manager:set_difficulty(difficulty, 0)

	local is_dedicated_server = self._lobby:is_dedicated_server()

	if not is_dedicated_server then
		Managers.party:set_leader(self._lobby:lobby_host())
	end

	if not (not Managers.party:is_leader(Network.peer_id()) and is_dedicated_server) then
		self._matchmaking_manager:set_matchmaking_data(mission_id, difficulty, act_key, matchmaking_type, private_game, quick_game, is_trusted, 0, mechanism)
		self._matchmaking_manager:set_game_privacy(private_game)
	end

	self._game_created = true
	self._wait_to_start_game = self.search_config.wait_to_start_game
	self._skip_waystone = self.search_config.skip_waystone

	if not self._wait_to_start_game then
		-- Nothing
	elseif not self._skip_waystone then
		local num = 1

		if mechanism == "weave" then
			num = 3
		elseif not (quick_game or matchmaking_type == "event") then
			num = LevelSettings[mission_id].waystone_type or num
		elseif not (not quick_game and mechanism ~= "weave") then
			num = 3
		end

		self._matchmaking_manager:activate_waystone_portal(num)
	end
end
