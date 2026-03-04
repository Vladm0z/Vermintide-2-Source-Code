-- chunkname: @scripts/managers/matchmaking/matchmaking_state_start_game.lua

MatchmakingStateStartGame = class(MatchmakingStateStartGame)
MatchmakingStateStartGame.NAME = "MatchmakingStateStartGame"

function MatchmakingStateStartGame.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_server = arg_1_1.network_server
	arg_1_0._statistics_db = arg_1_1.statistics_db
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_transmit = arg_1_1.network_transmit
end

function MatchmakingStateStartGame.on_enter(arg_2_0, arg_2_1)
	arg_2_0.state_context = arg_2_1
	arg_2_0.search_config = arg_2_1.search_config

	arg_2_0:_verify_requirements()

	if not arg_2_0._verifying_dlcs and arg_2_0._matchmaking_manager:is_game_matchmaking() then
		arg_2_0:_initiate_start_game()
	end
end

DLCS_TO_CHECK = {}
ADDED_DLCS = {}

local var_0_0 = {}

function MatchmakingStateStartGame._verify_requirements(arg_3_0)
	table.clear(DLCS_TO_CHECK)
	table.clear(ADDED_DLCS)

	local var_3_0
	local var_3_1 = arg_3_0.search_config
	local var_3_2 = Managers.player:human_players()
	local var_3_3 = var_3_1.matchmaking_type
	local var_3_4 = var_3_1.mechanism
	local var_3_5 = {}

	if var_3_3 or var_3_4 then
		var_3_5 = MechanismSettings[var_3_4] or var_3_5

		if var_3_5.required_dlc and not ADDED_DLCS[var_3_5.required_dlc] then
			DLCS_TO_CHECK[#DLCS_TO_CHECK + 1] = NetworkLookup.dlcs[var_3_5.required_dlc]
			ADDED_DLCS[var_3_5.required_dlc] = true
			var_3_0 = "all"
		end

		if var_3_5.extra_requirements_function then
			local var_3_6 = Managers.player:statistics_db()

			for iter_3_0, iter_3_1 in pairs(var_3_2) do
				local var_3_7 = iter_3_1:stats_id()

				if not var_3_5.extra_requirements_function(var_3_6, var_3_7) then
					arg_3_0._matchmaking_manager:cancel_matchmaking()
					arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_game_mode_requirements_failed")

					return
				end
			end
		end
	end

	local var_3_8 = var_3_1.difficulty

	if var_3_8 then
		local var_3_9 = DifficultySettings[var_3_8]

		if not var_3_5.disable_difficulty_check and not Development.parameter("unlock_all_difficulties") then
			if not var_3_1.private_game and #DifficultyManager.players_below_required_power_level(var_3_8, var_3_2) > 0 then
				arg_3_0._matchmaking_manager:cancel_matchmaking()
				arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_difficulty_requirements_failed")

				return
			end

			if var_3_9.extra_requirement_name then
				local var_3_10 = var_3_2

				if Managers.state.network.is_server then
					var_0_0[1] = Managers.player:local_player()
					var_3_10 = var_0_0
				end

				if #DifficultyManager.players_locked_difficulty_rank(var_3_8, var_3_10) > 0 then
					arg_3_0._matchmaking_manager:cancel_matchmaking()
					arg_3_0._matchmaking_manager:send_system_chat_message("matchmaking_status_difficulty_requirements_failed")

					return
				end
			end
		end

		if var_3_9.dlc_requirement and not ADDED_DLCS[var_3_9.dlc_requirement] then
			DLCS_TO_CHECK[#DLCS_TO_CHECK + 1] = NetworkLookup.dlcs[var_3_9.dlc_requirement]
			ADDED_DLCS[var_3_9.dlc_requirement] = true
			var_3_0 = var_3_0 == "all" and "all" or "any"
		end
	end

	if #DLCS_TO_CHECK > 0 then
		arg_3_0._verifying_dlcs = true
		arg_3_0._verify_dlc_data = {
			voters = arg_3_0:_active_peers(),
			results = {},
			votes_require_type = var_3_0
		}

		Managers.state.network.network_transmit:send_rpc_all("rpc_matchmaking_verify_dlc", DLCS_TO_CHECK)
	end
end

function MatchmakingStateStartGame._initiate_start_game(arg_4_0)
	arg_4_0:_setup_lobby_data()
	arg_4_0._network_server:enter_post_game()
	arg_4_0:_start_game()
end

function MatchmakingStateStartGame.update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._verifying_dlcs then
		return arg_5_0:_handle_verify_dlcs()
	end

	return nil
end

function MatchmakingStateStartGame._setup_lobby_data(arg_6_0)
	local var_6_0
	local var_6_1
	local var_6_2
	local var_6_3
	local var_6_4
	local var_6_5
	local var_6_6
	local var_6_7
	local var_6_8
	local var_6_9 = arg_6_0.search_config
	local var_6_10 = var_6_9.matchmaking_type
	local var_6_11 = var_6_9.mechanism

	if arg_6_0.state_context.join_by_lobby_browser then
		var_6_0 = Managers.mechanism:default_level_key()

		local var_6_12

		var_6_1, var_6_12 = Managers.state.difficulty:get_difficulty()
		var_6_3 = nil
		var_6_4 = false
		var_6_5 = false
		var_6_6 = {}
	else
		var_6_0 = var_6_9.mission_id
		var_6_1 = var_6_9.difficulty

		local var_6_13 = 0

		var_6_3 = var_6_9.act_key
		var_6_4 = var_6_9.quick_game
		var_6_5 = var_6_9.private_game
		var_6_6 = var_6_9.excluded_level_keys
	end

	if var_6_4 or var_6_0 == nil or var_6_0 == "any" then
		local var_6_14 = false

		if Managers.account:offline_mode() then
			var_6_14 = false
		end

		if var_6_11 == "weave" then
			local var_6_15 = table.shallow_copy(WeaveSettings.templates_ordered)

			table.array_remove_if(var_6_15, function(arg_7_0)
				return LevelUnlockUtils.weave_disabled(arg_7_0.name)
			end)

			local var_6_16 = table.random(var_6_15).name

			var_6_0 = var_6_16

			Managers.weave:set_next_weave(var_6_16)
			Managers.weave:set_next_objective(1)
		elseif var_6_11 == "deus" then
			local var_6_17 = arg_6_0._matchmaking_manager:gather_party_unlocked_journeys()
			local var_6_18 = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data
			local var_6_19 = table.shallow_copy(var_6_17)

			table.array_remove_if(var_6_19, function(arg_8_0)
				return LevelUnlockUtils.is_chaos_waste_god_disabled(var_6_18[arg_8_0].dominant_god)
			end)

			var_6_0 = var_6_19[Math.random(1, #var_6_19)]

			local var_6_20 = var_6_18[var_6_0].dominant_god
			local var_6_21 = {
				private_game = false,
				quick_game = true,
				strict_matchmaking = false,
				mission_id = var_6_0,
				difficulty = var_6_1,
				dominant_god = var_6_20,
				matchmaking_type = var_6_10
			}

			Managers.mechanism:set_vote_data(var_6_21)
		elseif var_6_11 == "versus" then
			local var_6_22 = script_data.versus_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")

			var_6_0 = var_6_22[Math.random(#var_6_22)]

			local var_6_23 = Managers.mechanism:game_mechanism():get_level_override_key()

			if var_6_23 then
				var_6_0 = var_6_23
			end
		else
			local var_6_24 = var_6_9.preferred_level_keys

			print("MatchmakingStateStartGame preferred_level_keys", var_6_24)

			if var_6_24 then
				local var_6_25 = table.shallow_copy(var_6_24)

				table.array_remove_if(var_6_25, function(arg_9_0)
					return LevelUnlockUtils.is_level_disabled(arg_9_0.name)
				end)
				table.dump(var_6_25, "filtered_level_keys")

				var_6_0 = var_6_25[Math.random(1, #var_6_25)]
			else
				var_6_0 = arg_6_0._matchmaking_manager:get_weighed_random_unlocked_level(var_6_14, false, var_6_6)
			end
		end
	elseif var_6_11 == "weave" then
		var_6_0 = var_6_9.mission_id

		if not var_6_4 then
			if Managers.account:offline_mode() then
				var_6_5 = var_6_9.private_game
			else
				var_6_5 = true
			end
		end
	elseif var_6_11 == "versus" and not var_6_9.player_hosted then
		local var_6_26 = script_data.versus_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")

		var_6_0 = var_6_26[Math.random(#var_6_26)]

		local var_6_27 = Managers.mechanism:game_mechanism():get_level_override_key()

		if var_6_27 then
			var_6_0 = var_6_27
		end
	end

	local var_6_28 = Managers.eac:is_trusted()

	if IS_XB1 then
		local var_6_29 = LobbyInternal.HOPPER_NAME
		local var_6_30 = {
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

		if var_6_10 == "event" then
			var_6_32 = {
				"event"
			}
		elseif var_6_11 == "weave" then
			if var_6_4 then
				var_6_31 = "weave_any"
				var_6_32 = {
					"weave_quick_game"
				}
			else
				var_6_29 = LobbyInternal.WEAVE_HOPPER_NAME
				var_6_32 = {
					"weave",
					var_6_0
				}
			end
		elseif var_6_11 == "deus" then
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

		local var_6_33 = arg_6_0._lobby:members():get_members()
		local var_6_34 = {}

		for iter_6_0, iter_6_1 in ipairs(var_6_33) do
			local var_6_35 = Managers.player:player_from_peer_id(iter_6_1)

			if var_6_35 then
				var_6_34[#var_6_34 + 1] = var_6_35:profile_index()
			end
		end

		local var_6_36 = table.find(var_6_30, var_6_1)
		local var_6_37 = arg_6_0._matchmaking_manager:get_average_power_level()
		local var_6_38 = 0
		local var_6_39 = arg_6_0._lobby:get_network_hash()
		local var_6_40 = WeaveSettings.templates[var_6_0]
		local var_6_41 = var_6_40 and table.find(WeaveSettings.templates_ordered, var_6_40)
		local var_6_42 = {
			level = {
				var_6_31
			},
			matchmaking_types = var_6_32,
			difficulty = var_6_36,
			powerlevel = var_6_37,
			strict_matchmaking = var_6_38,
			profiles = var_6_34,
			network_hash = var_6_39,
			weave_index = var_6_41
		}

		arg_6_0._lobby:enable_matchmaking(not var_6_5, var_6_42, 600, var_6_29)
	end

	local var_6_43 = var_6_10

	if var_6_43 == "standard" then
		var_6_43 = "custom"
	end

	local var_6_44 = LevelHelper:get_environment_variation_id(var_6_0)

	arg_6_0._matchmaking_manager:set_matchmaking_data(var_6_0, var_6_1, var_6_3, var_6_43, var_6_5, var_6_4, var_6_28, var_6_44, var_6_11)

	local var_6_45 = Managers.level_transition_handler
	local var_6_46 = Managers.mechanism:generate_level_seed()
	local var_6_47 = var_6_0

	if var_6_11 == "weave" then
		local var_6_48 = WeaveSettings.templates[var_6_0]

		if var_6_48 then
			local var_6_49 = Managers.weave:get_next_objective()
			local var_6_50 = var_6_48.objectives[var_6_49]

			var_6_47 = var_6_50.level_id
			var_6_8 = var_6_50.conflict_settings
		end
	end

	local var_6_51 = Managers.mechanism:generate_locked_director_functions(var_6_47)

	var_6_45:set_next_level(var_6_47, var_6_44, var_6_46, nil, nil, var_6_8, var_6_51, var_6_1, nil)
end

function MatchmakingStateStartGame.get_transition(arg_10_0)
	if arg_10_0.next_transition_state and arg_10_0.start_lobby_data then
		return arg_10_0.next_transition_state, arg_10_0.start_lobby_data
	end
end

function MatchmakingStateStartGame._send_rpc_clients(arg_11_0, arg_11_1, ...)
	if arg_11_0.state_context.clients_not_in_game_session then
		local var_11_0 = Network.peer_id()
		local var_11_1 = arg_11_0._lobby:members():get_members()

		for iter_11_0, iter_11_1 in pairs(var_11_1) do
			if iter_11_1 ~= var_11_0 then
				arg_11_0._network_transmit:send_rpc(arg_11_1, iter_11_1, ...)
			end
		end
	else
		arg_11_0._network_transmit:send_rpc_clients(arg_11_1, ...)
	end
end

function MatchmakingStateStartGame._start_game(arg_12_0)
	arg_12_0:_capture_telemetry()
	Managers.mechanism:network_handler():get_match_handler():send_rpc_down("rpc_matchmaking_join_game")

	local var_12_0 = arg_12_0.state_context.game_server_lobby_client

	if var_12_0 then
		arg_12_0.next_transition_state = "start_lobby"
		arg_12_0.start_lobby_data = {
			lobby_client = var_12_0
		}

		local var_12_1 = var_12_0:ip_address()

		arg_12_0:_send_rpc_clients("rpc_matchmaking_broadcast_game_server_ip_address", var_12_1)
	else
		Managers.state.game_mode:complete_level()
	end
end

function MatchmakingStateStartGame._capture_telemetry(arg_13_0)
	local var_13_0 = arg_13_0._lobby:members():get_members()
	local var_13_1 = 0

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		if rawget(_G, "Steam") and rawget(_G, "Friends") and Friends.in_category(iter_13_1, Friends.FRIEND_FLAG) then
			var_13_1 = var_13_1 + 1
		end
	end

	local var_13_2 = Managers.player:local_player(1)
	local var_13_3 = Managers.time:time("main") - arg_13_0.state_context.started_matchmaking_t
	local var_13_4 = arg_13_0.search_config.strict_matchmaking

	Managers.telemetry_events:matchmaking_starting_game(var_13_2, var_13_3, arg_13_0.search_config)
end

function MatchmakingStateStartGame._handle_verify_dlcs(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._verify_dlc_data
	local var_14_1 = arg_14_0:_active_peers()

	arg_14_0:_update_voter_list_by_active_peers(var_14_1, var_14_0.voters, var_14_0.results)

	local var_14_2, var_14_3 = arg_14_0:_handle_results(var_14_0)

	if var_14_2 then
		if var_14_3 then
			arg_14_0:_initiate_start_game()
		else
			arg_14_0._matchmaking_manager:cancel_matchmaking()
			arg_14_0._matchmaking_manager:send_system_chat_message("matchmaking_status_dlc_check_failed")

			return nil
		end

		arg_14_0._verifying_dlcs = false
		arg_14_0._verifying_dlcs_data = nil
	end
end

function MatchmakingStateStartGame._handle_results(arg_15_0, arg_15_1)
	local var_15_0 = true
	local var_15_1 = true
	local var_15_2 = arg_15_1.votes_require_type

	for iter_15_0, iter_15_1 in pairs(arg_15_1.voters) do
		if arg_15_1.results[iter_15_0] == nil then
			var_15_0 = false
		elseif var_15_2 == "all" and not arg_15_1.results[iter_15_0] then
			var_15_1 = false
		elseif var_15_2 == "any" and arg_15_1.results[iter_15_0] then
			var_15_1 = true
		end
	end

	return var_15_0, var_15_1
end

function MatchmakingStateStartGame.rpc_matchmaking_verify_dlc_reply(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = CHANNEL_TO_PEER_ID[arg_16_1]

	arg_16_0._verify_dlc_data.results[var_16_0] = arg_16_2
end

local var_0_1 = {}

function MatchmakingStateStartGame._update_voter_list_by_active_peers(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	table.clear(var_0_1)

	local var_17_0 = Managers.player:human_players()

	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		arg_17_1[iter_17_1.peer_id] = true
	end

	local var_17_1 = false

	for iter_17_2 = #arg_17_2, 1, -1 do
		local var_17_2 = arg_17_2[iter_17_2]

		if not arg_17_1[var_17_2] then
			table.remove(arg_17_2, iter_17_2)

			var_0_1[#var_0_1 + 1] = var_17_2

			local var_17_3 = true
		end
	end

	for iter_17_3 = 1, #var_0_1 do
		local var_17_4 = var_0_1[iter_17_3]

		if arg_17_3[var_17_4] ~= nil then
			arg_17_3[var_17_4] = nil
		end
	end
end

local var_0_2 = {}

function MatchmakingStateStartGame._active_peers(arg_18_0)
	table.clear(var_0_2)

	local var_18_0 = Managers.player:human_players()

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		local var_18_1 = iter_18_1.peer_id

		var_0_2[var_18_1] = true
	end

	return var_0_2
end
