-- chunkname: @scripts/managers/matchmaking/matchmaking_state_start_game.lua

MatchmakingStateStartGame = class(MatchmakingStateStartGame)
MatchmakingStateStartGame.NAME = "MatchmakingStateStartGame"

MatchmakingStateStartGame.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_server = arg_1_1.network_server
	self._statistics_db = arg_1_1.statistics_db
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_transmit = arg_1_1.network_transmit
end

MatchmakingStateStartGame.on_enter = function (self, arg_2_1)
	-- function 2
	self.state_context = arg_2_1
	self.search_config = arg_2_1.search_config

	self:_verify_requirements()

	if self._verifying_dlcs or not self._matchmaking_manager:is_game_matchmaking() then
		self:_initiate_start_game()
	end
end

DLCS_TO_CHECK = {}
ADDED_DLCS = {}

local tbl = {}

MatchmakingStateStartGame._verify_requirements = function (self)
	-- function 3
	table.clear(DLCS_TO_CHECK)
	table.clear(ADDED_DLCS)

	local var_3_0
	local search_config = self.search_config
	local human_players = Managers.player:human_players()
	local matchmaking_type = search_config.matchmaking_type
	local mechanism = search_config.mechanism
	local tbl_2 = {}

	if matchmaking_type or not mechanism then
		tbl_2 = MechanismSettings[mechanism] or tbl_2

		if not (not tbl_2.required_dlc and ADDED_DLCS[tbl_2.required_dlc]) then
			DLCS_TO_CHECK[#DLCS_TO_CHECK + 1] = NetworkLookup.dlcs[tbl_2.required_dlc]
			ADDED_DLCS[tbl_2.required_dlc] = true
			var_3_0 = "all"
		end

		if not tbl_2.extra_requirements_function then
			local statistics_db = Managers.player:statistics_db()

			for k, v in pairs(human_players) do
				local stats_id = v:stats_id()

				if not tbl_2.extra_requirements_function(statistics_db, stats_id) then
					self._matchmaking_manager:cancel_matchmaking()
					self._matchmaking_manager:send_system_chat_message("matchmaking_status_game_mode_requirements_failed")

					return
				end
			end
		end
	end

	local difficulty = search_config.difficulty

	if not difficulty then
		local var_3_9 = DifficultySettings[difficulty]

		if not (tbl_2.disable_difficulty_check or Development.parameter("unlock_all_difficulties")) then
			if not (search_config.private_game or not (#DifficultyManager.players_below_required_power_level(difficulty, human_players) > 0)) then
				self._matchmaking_manager:cancel_matchmaking()
				self._matchmaking_manager:send_system_chat_message("matchmaking_status_difficulty_requirements_failed")

				return
			end

			if not var_3_9.extra_requirement_name then
				local var_3_10 = human_players

				if not Managers.state.network.is_server then
					tbl[1] = Managers.player:local_player()
					var_3_10 = tbl
				end

				if #DifficultyManager.players_locked_difficulty_rank(difficulty, var_3_10) > 0 then
					self._matchmaking_manager:cancel_matchmaking()
					self._matchmaking_manager:send_system_chat_message("matchmaking_status_difficulty_requirements_failed")

					return
				end
			end
		end

		if not (not var_3_9.dlc_requirement and ADDED_DLCS[var_3_9.dlc_requirement]) then
			DLCS_TO_CHECK[#DLCS_TO_CHECK + 1] = NetworkLookup.dlcs[var_3_9.dlc_requirement]
			ADDED_DLCS[var_3_9.dlc_requirement] = true
			var_3_0 = var_3_0 ~= "all" or not "all" or "any"
		end
	end

	if #DLCS_TO_CHECK > 0 then
		self._verifying_dlcs = true
		self._verify_dlc_data = {
			voters = self:_active_peers(),
			results = {},
			votes_require_type = var_3_0
		}

		Managers.state.network.network_transmit:send_rpc_all("rpc_matchmaking_verify_dlc", DLCS_TO_CHECK)
	end
end

MatchmakingStateStartGame._initiate_start_game = function (self)
	-- function 4
	self:_setup_lobby_data()
	self._network_server:enter_post_game()
	self:_start_game()
end

MatchmakingStateStartGame.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._verifying_dlcs then
		return self:_handle_verify_dlcs()
	end

	return nil
end

MatchmakingStateStartGame._setup_lobby_data = function (self)
	-- function 6
	local var_6_0
	local var_6_1
	local var_6_2
	local var_6_3
	local var_6_4
	local var_6_5
	local var_6_6
	local var_6_7
	local var_6_8
	local search_config = self.search_config
	local matchmaking_type = search_config.matchmaking_type
	local mechanism = search_config.mechanism

	if not self.state_context.join_by_lobby_browser then
		var_6_0 = Managers.mechanism:default_level_key()

		local var_6_12

		var_6_1, var_6_12 = Managers.state.difficulty:get_difficulty()
		var_6_3 = nil
		var_6_4 = false
		var_6_5 = false
		var_6_6 = {}
	else
		var_6_0 = search_config.mission_id
		var_6_1 = search_config.difficulty

		local num = 0

		var_6_3 = search_config.act_key
		var_6_4 = search_config.quick_game
		var_6_5 = search_config.private_game
		var_6_6 = search_config.excluded_level_keys
	end

	if not (var_6_4 or var_6_0 == nil or var_6_0 ~= "any") then
		local flag = false

		if not Managers.account:offline_mode() then
			flag = false
		end

		if mechanism == "weave" then
			local shallow_copy = table.shallow_copy(WeaveSettings.templates_ordered)

			table.array_remove_if(shallow_copy, function (self)
				-- function 7
				return LevelUnlockUtils.weave_disabled(self.name)
			end)

			local name = table.random(shallow_copy).name

			var_6_0 = name

			Managers.weave:set_next_weave(name)
			Managers.weave:set_next_objective(1)
		elseif mechanism == "deus" then
			local gather_party_unlocked_journeys = self._matchmaking_manager:gather_party_unlocked_journeys()
			local journey_data = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data
			local shallow_copy_2 = table.shallow_copy(gather_party_unlocked_journeys)

			table.array_remove_if(shallow_copy_2, function (arg_8_0)
				-- function 8
				return LevelUnlockUtils.is_chaos_waste_god_disabled(journey_data[arg_8_0].dominant_god)
			end)

			var_6_0 = shallow_copy_2[Math.random(1, #shallow_copy_2)]

			local dominant_god = journey_data[var_6_0].dominant_god
			local tbl = {
				private_game = false,
				quick_game = true,
				strict_matchmaking = false,
				mission_id = var_6_0,
				difficulty = var_6_1,
				dominant_god = dominant_god,
				matchmaking_type = matchmaking_type
			}

			Managers.mechanism:set_vote_data(tbl)
		elseif mechanism == "versus" then
			local versus_map_pool = script_data.versus_map_pool

			versus_map_pool = versus_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")
			var_6_0 = versus_map_pool[Math.random(#versus_map_pool)]

			local get_level_override_key = Managers.mechanism:game_mechanism():get_level_override_key()

			if not get_level_override_key then
				var_6_0 = get_level_override_key
			end
		else
			local preferred_level_keys = search_config.preferred_level_keys

			print("MatchmakingStateStartGame preferred_level_keys", preferred_level_keys)

			if not preferred_level_keys then
				local shallow_copy_3 = table.shallow_copy(preferred_level_keys)

				table.array_remove_if(shallow_copy_3, function (self)
					-- function 9
					return LevelUnlockUtils.is_level_disabled(self.name)
				end)
				table.dump(shallow_copy_3, "filtered_level_keys")

				var_6_0 = shallow_copy_3[Math.random(1, #shallow_copy_3)]
			else
				var_6_0 = self._matchmaking_manager:get_weighed_random_unlocked_level(flag, false, var_6_6)
			end
		end
	elseif mechanism == "weave" then
		var_6_0 = search_config.mission_id

		if not var_6_4 then
			if not Managers.account:offline_mode() then
				var_6_5 = search_config.private_game
			else
				var_6_5 = true
			end
		end
	elseif not (mechanism ~= "versus" or search_config.player_hosted) then
		local versus_map_pool_2 = script_data.versus_map_pool

		versus_map_pool_2 = versus_map_pool_2 or Managers.mechanism:mechanism_setting_for_title("map_pool")
		var_6_0 = versus_map_pool_2[Math.random(#versus_map_pool_2)]

		local get_level_override_key_2 = Managers.mechanism:game_mechanism():get_level_override_key()

		if not get_level_override_key_2 then
			var_6_0 = get_level_override_key_2
		end
	end

	local is_trusted = Managers.eac:is_trusted()

	if not IS_XB1 then
		local HOPPER_NAME = LobbyInternal.HOPPER_NAME
		local tbl_2 = {
			"easy",
			"normal",
			"hard",
			"harder",
			"hardest",
			"cataclysm",
			"cataclysm_2",
			"cataclysm_3"
		}
		local var_6_31 = var_6_0
		local var_6_32

		if matchmaking_type == "event" then
			var_6_32 = {
				"event"
			}
		elseif mechanism == "weave" then
			if not var_6_4 then
				var_6_31 = "weave_any"
				var_6_32 = {
					"weave_quick_game"
				}
			else
				HOPPER_NAME = LobbyInternal.WEAVE_HOPPER_NAME
				var_6_32 = {
					"weave",
					var_6_0
				}
			end
		elseif mechanism == "deus" then
			var_6_32 = {
				"deus_quick_game",
				"deus_custom_game"
			}
		else
			var_6_32 = {
				"quick_game",
				"custom_game"
			}
		end

		local get_members = self._lobby:members():get_members()
		local tbl_3 = {}

		for i, v in ipairs(get_members) do
			local player_from_peer_id = Managers.player:player_from_peer_id(v)

			if not player_from_peer_id then
				tbl_3[#tbl_3 + 1] = player_from_peer_id:profile_index()
			end
		end

		local find = table.find(tbl_2, var_6_1)
		local get_average_power_level = self._matchmaking_manager:get_average_power_level()
		local num_2 = 0
		local get_network_hash = self._lobby:get_network_hash()
		local var_6_40 = WeaveSettings.templates[var_6_0]
		local flag_2 = not var_6_40 and table.find(WeaveSettings.templates_ordered, var_6_40)
		local tbl_4 = {
			level = {
				var_6_31
			},
			matchmaking_types = var_6_32,
			difficulty = find,
			powerlevel = get_average_power_level,
			strict_matchmaking = num_2,
			profiles = tbl_3,
			network_hash = get_network_hash,
			weave_index = flag_2
		}

		self._lobby:enable_matchmaking(not var_6_5, tbl_4, 600, HOPPER_NAME)
	end

	local var_6_43 = matchmaking_type

	if var_6_43 == "standard" then
		var_6_43 = "custom"
	end

	local get_environment_variation_id = LevelHelper:get_environment_variation_id(var_6_0)

	self._matchmaking_manager:set_matchmaking_data(var_6_0, var_6_1, var_6_3, var_6_43, var_6_5, var_6_4, is_trusted, get_environment_variation_id, mechanism)

	local level_transition_handler = Managers.level_transition_handler
	local generate_level_seed = Managers.mechanism:generate_level_seed()
	local var_6_47 = var_6_0

	if mechanism == "weave" then
		local var_6_48 = WeaveSettings.templates[var_6_0]

		if not var_6_48 then
			local get_next_objective = Managers.weave:get_next_objective()
			local var_6_50 = var_6_48.objectives[get_next_objective]

			var_6_47 = var_6_50.level_id
			var_6_8 = var_6_50.conflict_settings
		end
	end

	local generate_locked_director_functions = Managers.mechanism:generate_locked_director_functions(var_6_47)

	level_transition_handler:set_next_level(var_6_47, get_environment_variation_id, generate_level_seed, nil, nil, var_6_8, generate_locked_director_functions, var_6_1, nil)
end

MatchmakingStateStartGame.get_transition = function (self)
	-- function 10
	if not self.next_transition_state and not self.start_lobby_data then
		return self.next_transition_state, self.start_lobby_data
	end
end

MatchmakingStateStartGame._send_rpc_clients = function (self, arg_11_1, ...)
	-- function 11
	if not self.state_context.clients_not_in_game_session then
		local peer_id = Network.peer_id()
		local get_members = self._lobby:members():get_members()

		for k, v in pairs(get_members) do
			if v ~= peer_id then
				self._network_transmit:send_rpc(arg_11_1, v, ...)
			end
		end
	else
		self._network_transmit:send_rpc_clients(arg_11_1, ...)
	end
end

MatchmakingStateStartGame._start_game = function (self)
	-- function 12
	self:_capture_telemetry()
	Managers.mechanism:network_handler():get_match_handler():send_rpc_down("rpc_matchmaking_join_game")

	local game_server_lobby_client = self.state_context.game_server_lobby_client

	if not game_server_lobby_client then
		self.next_transition_state = "start_lobby"
		self.start_lobby_data = {
			lobby_client = game_server_lobby_client
		}

		local ip_address = game_server_lobby_client:ip_address()

		self:_send_rpc_clients("rpc_matchmaking_broadcast_game_server_ip_address", ip_address)
	else
		Managers.state.game_mode:complete_level()
	end
end

MatchmakingStateStartGame._capture_telemetry = function (self)
	-- function 13
	local get_members = self._lobby:members():get_members()
	local num = 0

	for k, v in pairs(get_members) do
		if not rawget(_G, "Steam") and not rawget(_G, "Friends") and not Friends.in_category(v, Friends.FRIEND_FLAG) then
			num = num + 1
		end
	end

	local local_player = Managers.player:local_player(1)
	local num_2 = Managers.time:time("main") - self.state_context.started_matchmaking_t
	local strict_matchmaking = self.search_config.strict_matchmaking

	Managers.telemetry_events:matchmaking_starting_game(local_player, num_2, self.search_config)
end

MatchmakingStateStartGame._handle_verify_dlcs = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _verify_dlc_data = self._verify_dlc_data
	local _active_peers = self:_active_peers()

	self:_update_voter_list_by_active_peers(_active_peers, _verify_dlc_data.voters, _verify_dlc_data.results)

	local _handle_results, var_14_3 = self:_handle_results(_verify_dlc_data)

	if not _handle_results then
		if not var_14_3 then
			self:_initiate_start_game()
		else
			self._matchmaking_manager:cancel_matchmaking()
			self._matchmaking_manager:send_system_chat_message("matchmaking_status_dlc_check_failed")

			return nil
		end

		self._verifying_dlcs = false
		self._verifying_dlcs_data = nil
	end
end

MatchmakingStateStartGame._handle_results = function (arg_15_0, arg_15_1)
	-- function 15
	local flag = true
	local flag_2 = true
	local votes_require_type = arg_15_1.votes_require_type

	for k, v in pairs(arg_15_1.voters) do
		if arg_15_1.results[k] == nil then
			flag = false
		elseif not (votes_require_type ~= "all" or arg_15_1.results[k]) then
			flag_2 = false
		elseif votes_require_type ~= "any" or not arg_15_1.results[k] then
			flag_2 = true
		end
	end

	return flag, flag_2
end

MatchmakingStateStartGame.rpc_matchmaking_verify_dlc_reply = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = CHANNEL_TO_PEER_ID[arg_16_1]

	arg_16_0._verify_dlc_data.results[var_16_0] = arg_16_2
end

local tbl_2 = {}

MatchmakingStateStartGame._update_voter_list_by_active_peers = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	table.clear(tbl_2)

	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		arg_17_1[v.peer_id] = true
	end

	local flag = false

	for k_2 = #arg_17_2, 1, -1 do
		local var_17_2 = arg_17_2[k_2]

		if not arg_17_1[var_17_2] then
			table.remove(arg_17_2, k_2)

			tbl_2[#tbl_2 + 1] = var_17_2

			local flag_2 = true
		end
	end

	for l = 1, #tbl_2 do
		local var_17_4 = tbl_2[l]

		if arg_17_3[var_17_4] ~= nil then
			arg_17_3[var_17_4] = nil
		end
	end
end

local tbl_3 = {}

MatchmakingStateStartGame._active_peers = function (arg_18_0)
	-- function 18
	table.clear(tbl_3)

	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		local peer_id = v.peer_id

		tbl_3[peer_id] = true
	end

	return tbl_3
end
