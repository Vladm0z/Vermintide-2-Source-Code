-- chunkname: @scripts/managers/matchmaking/matchmaking_state_request_join_game.lua

require("scripts/game_state/server_join_state_machine")

MatchmakingStateRequestJoinGame = class(MatchmakingStateRequestJoinGame)
MatchmakingStateRequestJoinGame.NAME = "MatchmakingStateRequestJoinGame"

function MatchmakingStateRequestJoinGame.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_options = arg_1_1.network_options
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._matchmaking_manager.selected_profile_index = nil
	arg_1_0._state = "waiting_to_join_lobby"
end

function MatchmakingStateRequestJoinGame.destroy(arg_2_0)
	if arg_2_0._password_request ~= nil then
		arg_2_0._password_request:destroy()

		arg_2_0._password_request = nil
	end
end

function MatchmakingStateRequestJoinGame.terminate(arg_3_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

function MatchmakingStateRequestJoinGame.on_enter(arg_4_0, arg_4_1)
	arg_4_0.state_context = arg_4_1
	arg_4_0._join_lobby_data = arg_4_1.join_lobby_data
	arg_4_0._game_reply = nil
	arg_4_0._connected_to_server = false
	arg_4_0._connect_timeout = nil
	arg_4_0._join_timeout = nil

	if arg_4_1.reserved_lobby then
		Managers.lobby:register_existing_lobby(arg_4_1.reserved_lobby, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (on_enter)")
	end

	arg_4_0._pre_verification_error = nil

	local var_4_0, var_4_1 = arg_4_0:_run_pre_connection_verification(arg_4_0._join_lobby_data)

	if var_4_0 then
		local var_4_2

		if Managers.lobby:query_lobby("matchmaking_join_lobby") == nil then
			arg_4_0:_setup_lobby_connection(arg_4_0._join_lobby_data, arg_4_1.password)

			var_4_2 = arg_4_0._join_lobby_data.host or "nohostname"
		else
			var_4_2 = "dedicated server"
		end

		arg_4_0._matchmaking_manager.debug.text = "Joining lobby"
		arg_4_0._matchmaking_manager.debug.state = "hosted by: " .. var_4_2

		local var_4_3 = true

		Managers.chat:add_local_system_message(1, Localize("matchmaking_status_starting_handshake"), var_4_3)
	else
		arg_4_0._state = "failed_pre_connection_verification"
		arg_4_0._pre_verification_error = var_4_1 or "pre_verification_failed"
	end
end

function MatchmakingStateRequestJoinGame.on_exit(arg_5_0)
	return
end

function MatchmakingStateRequestJoinGame._run_pre_connection_verification(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._lobby:id()

	if (arg_6_1.id or arg_6_1.name) == var_6_0 then
		return false, "popup_already_in_same_lobby"
	end

	return true
end

function MatchmakingStateRequestJoinGame._setup_lobby_connection(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._network_options

	if arg_7_1.server_info then
		if arg_7_2 == nil then
			arg_7_0._state = "waiting_for_password"
			arg_7_0._user_data = {
				network_options = var_7_0,
				game_server_data = arg_7_1
			}
		else
			Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (_setup_lobby_connection, GameServerLobbyClient)", var_7_0, arg_7_1, arg_7_2)
		end
	else
		Managers.lobby:make_lobby(LobbyClient, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (_setup_lobby_connection, LobbyClient)", var_7_0, arg_7_1)
	end
end

function MatchmakingStateRequestJoinGame.update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0
	local var_8_1
	local var_8_2
	local var_8_3 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if var_8_3 or arg_8_0._had_lobby then
		arg_8_0._had_lobby = true

		if var_8_3 then
			var_8_3:update(arg_8_1)

			var_8_0 = var_8_3:lobby_host()
			var_8_1 = var_8_3:id()

			local var_8_4 = var_8_3.state

			if var_8_3:failed() then
				return arg_8_0:_join_game_failed("failure_start_join_server", arg_8_2, true)
			end
		else
			return arg_8_0:_join_game_failed("failure_start_join_server", arg_8_2, true)
		end
	end

	local var_8_5 = arg_8_0._state

	if var_8_5 == "failed_pre_connection_verification" then
		return arg_8_0:_join_game_failed(arg_8_0._pre_verification_error, arg_8_2, false)
	elseif var_8_5 == "waiting_for_password" then
		local var_8_6
		local var_8_7
		local var_8_8

		if arg_8_0._password_request then
			arg_8_0._password_request:update(arg_8_1)

			var_8_6, var_8_7, var_8_8 = arg_8_0._password_request:result()
		else
			var_8_6, var_8_7, var_8_8 = "join", arg_8_0._user_data, ""
		end

		if var_8_6 ~= nil then
			if var_8_6 == "join" then
				Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (update)", var_8_7.network_options, var_8_7.game_server_data, var_8_8)

				arg_8_0._state = "waiting_to_join_lobby"
			else
				return arg_8_0:_join_game_failed("cancelled", arg_8_2, false)
			end

			if arg_8_0._password_request then
				arg_8_0._password_request:destroy()

				arg_8_0._password_request = nil
			end
		end
	elseif var_8_5 == "waiting_to_join_lobby" then
		if var_8_3:is_joined() and var_8_0 ~= "0" then
			arg_8_0._matchmaking_manager.debug.text = "Connecting to host"

			if (not LobbyInternal.user_name or not LobbyInternal.user_name(var_8_0)) and (not var_8_3.user_name or not var_8_3:user_name(var_8_0)) then
				local var_8_9 = "-"
			end

			mm_printf("Joined lobby, checking network hash...")

			arg_8_0._check_network_hash_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
			arg_8_0._state = "check_network_hash"
		end
	elseif var_8_5 == "check_network_hash" then
		local var_8_10 = var_8_3.network_hash
		local var_8_11 = var_8_3:lobby_data("network_hash")
		local var_8_12 = LobbyInternal.user_name and LobbyInternal.user_name(var_8_0) or "-"

		if var_8_11 ~= nil then
			if var_8_10 == var_8_11 or Development.parameter("force_ignore_network_hash") then
				mm_printf("Network hashes matches, waiting to connect to host with user name '%s'...", tostring(var_8_12))

				arg_8_0._state = "verify_not_blocked"
			else
				mm_printf("Network hashes differ. lobby_id=%s, host_id:%s, this_hash:%q, other_hash:%q", var_8_1, var_8_12, var_8_10, var_8_11)
				arg_8_0:_join_fail_popup(string.format(Localize("failure_start_join_server_incorrect_hash"), var_8_10, var_8_11))

				return arg_8_0:_join_game_failed("network_hash_mismatch", arg_8_2, true)
			end
		elseif arg_8_2 > arg_8_0._check_network_hash_timeout then
			mm_printf("Failed to get lobby data in time. lobby_id=%s, host_id:%s", var_8_1, var_8_12)

			return arg_8_0:_join_game_failed("lobby_data_timeout", arg_8_2, true)
		end
	elseif var_8_5 == "verify_not_blocked" then
		if not DEDICATED_SERVER and IS_WINDOWS then
			local var_8_13 = var_8_3:lobby_host()
			local var_8_14 = Friends.relationship(var_8_13)

			if var_8_14 == Friends.IGNORED or var_8_14 == Friends.IGNORED_FRIEND then
				return arg_8_0:_join_game_failed("user_blocked", arg_8_2, false)
			end
		end

		arg_8_0._state = "verify_game_mode"
	elseif var_8_5 == "verify_game_mode" then
		if not var_8_3:lobby_data("matchmaking_type") then
			arg_8_0._state = "verify_difficulty"

			return
		end

		local var_8_15 = var_8_3:lobby_data("mechanism")
		local var_8_16 = MechanismSettings[var_8_15]

		if var_8_16 and var_8_16.extra_requirements_function then
			if var_8_16.extra_requirements_function() then
				if var_8_16.disable_difficulty_check then
					arg_8_0._state = "waiting_to_connect"
					arg_8_0._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
				else
					arg_8_0._state = "verify_difficulty"
				end
			else
				if not LobbyInternal.user_name or not LobbyInternal.user_name(var_8_0) then
					local var_8_17 = "-"
				end

				local var_8_18 = "failure_start_join_server_game_mode_requirements_failed"

				return arg_8_0:_join_game_failed(var_8_18, arg_8_2, false, nil, true)
			end
		elseif var_8_16 and var_8_16.disable_difficulty_check then
			arg_8_0._state = "waiting_to_connect"
			arg_8_0._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
		else
			arg_8_0._state = "verify_difficulty"
		end
	elseif var_8_5 == "verify_difficulty" then
		if Development.parameter("unlock_all_difficulties") then
			arg_8_0._state = "waiting_to_connect"
			arg_8_0._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME

			return
		end

		local var_8_19 = true
		local var_8_20 = ""

		if not (var_8_3:lobby_data("is_private") == "true") then
			local var_8_21 = var_8_3:lobby_data("difficulty") or "normal"
			local var_8_22 = DifficultySettings[var_8_21]

			if Managers.player:local_player():best_aquired_power_level() < var_8_22.required_power_level then
				var_8_19 = false
				var_8_20 = string.format("%s: %s\n", Localize("required_power_level"), tostring(UIUtils.presentable_hero_power_level(var_8_22.required_power_level)))
			end

			if var_8_22.extra_requirement_name then
				local var_8_23 = ExtraDifficultyRequirements[var_8_22.extra_requirement_name]

				if not var_8_23.requirement_function() then
					var_8_19 = false
					var_8_20 = var_8_20 .. "* " .. Localize(var_8_23.description_text) .. "\n"
				end
			end
		end

		if not var_8_19 then
			if not LobbyInternal.user_name or not LobbyInternal.user_name(var_8_0) then
				local var_8_24 = "-"
			end

			local var_8_25 = "failure_start_join_server_difficulty_requirements_failed"

			return arg_8_0:_join_game_failed(var_8_25, arg_8_2, false, var_8_20, true)
		else
			arg_8_0._state = "waiting_to_connect"
			arg_8_0._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
		end
	elseif var_8_5 == "waiting_to_connect" then
		if arg_8_0._connected_to_server then
			arg_8_0._matchmaking_manager.debug.text = "Requesting to join"

			mm_printf("Connected, requesting to join game...")

			if HAS_STEAM and var_8_3.set_steam_lobby_reconnectable then
				var_8_3:set_steam_lobby_reconnectable(false)
			end

			local var_8_26 = not not arg_8_0.state_context.friend_join
			local var_8_27 = arg_8_0:_gather_dlc_ids()

			arg_8_0._network_transmit:send_rpc("rpc_matchmaking_request_join_lobby", var_8_0, var_8_1, var_8_26, var_8_27)

			arg_8_0._join_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
			arg_8_0._state = "asking_to_join"
		elseif arg_8_2 > arg_8_0._connect_timeout then
			local var_8_28 = LobbyInternal.user_name and LobbyInternal.user_name(var_8_0) or "-"

			mm_printf_force("Failed to connect to host due to timeout. lobby_id=%s, host_id:%s", var_8_1, var_8_28)

			return arg_8_0:_join_game_failed("connection_timeout", arg_8_2, true)
		end
	elseif var_8_5 == "asking_to_join" then
		local var_8_29 = MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME - (arg_8_0._join_timeout - arg_8_2)

		arg_8_0._matchmaking_manager.debug.text = string.format("Requesting to join game %s [%.0f]", var_8_3:id(), var_8_29)

		local var_8_30 = LobbyInternal.user_name and LobbyInternal.user_name(var_8_0) or "-"
		local var_8_31 = arg_8_0._game_reply

		if arg_8_2 > arg_8_0._join_timeout then
			mm_printf_force("Failed to join game due to timeout. lobby_id=%s, host_id:%s", var_8_1, var_8_30)

			return arg_8_0:_join_game_failed("connection_timeout", arg_8_2, true)
		elseif var_8_31 ~= nil then
			if var_8_31 == "lobby_ok" then
				mm_printf("Successfully joined game after %.2f seconds: lobby_id=%s host_id:%s", var_8_29, var_8_1, var_8_30)

				return arg_8_0:_join_game_success(arg_8_2)
			elseif var_8_31 == "custom_lobby_ok" then
				return arg_8_0:_try_friend_join_custom_lobby()
			else
				mm_printf_force("Failed to join game due to host responding '%s'. lobby_id=%s, host_id:%s", var_8_31, var_8_1, var_8_30)

				return arg_8_0:_join_game_failed(var_8_31, arg_8_2, var_8_31 == "lobby_id_mismatch", arg_8_0._game_reply_variable, true)
			end
		end
	end

	return nil
end

function MatchmakingStateRequestJoinGame._gather_dlc_ids(arg_9_0)
	local var_9_0 = {}
	local var_9_1 = UnlockSettings[1].unlocks
	local var_9_2 = Managers.unlock

	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		if var_9_2:is_dlc_unlocked(iter_9_0) and not var_9_2:is_dlc_cosmetic(iter_9_0) then
			print(iter_9_0)

			var_9_0[#var_9_0 + 1] = NetworkLookup.dlcs[iter_9_0]
		end
	end

	return var_9_0
end

function MatchmakingStateRequestJoinGame._try_friend_join_custom_lobby(arg_10_0)
	local var_10_0 = MatchmakingStateIdle
	local var_10_1, var_10_2 = Managers.mechanism:mechanism_try_call("can_join_custom_lobby")
	local var_10_3

	if var_10_1 and var_10_2 then
		var_10_0 = MatchmakingStateReserveSlotsPlayerHosted
	else
		var_10_3 = "vs_player_hosted_lobby_wrong_mechanism_error"
	end

	if var_10_3 then
		Managers.matchmaking:send_system_chat_message(var_10_3)
	end

	arg_10_0.state_context.join_lobby_data = arg_10_0._join_lobby_data

	return var_10_0, arg_10_0.state_context
end

function MatchmakingStateRequestJoinGame._join_game_success(arg_11_0, arg_11_1)
	if (arg_11_0.state_context.search_config and arg_11_0.state_context.search_config.join_method) == "party" then
		return MatchmakingStatePartyJoins, arg_11_0.state_context
	else
		return MatchmakingStateRequestProfiles, arg_11_0.state_context
	end
end

function MatchmakingStateRequestJoinGame._join_fail_popup(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.state_context.non_matchmaking_join
	local var_12_1 = arg_12_0.state_context.join_by_lobby_browser and arg_12_0.lobby_browser_view_ui

	if var_12_0 and not var_12_1 then
		Managers.simple_popup:queue_popup(arg_12_1, Localize("popup_error_topic"), "ok", Localize("button_ok"))
	end
end

function MatchmakingStateRequestJoinGame._join_game_failed(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if var_13_0 then
		arg_13_0._matchmaking_manager:add_broken_lobby_client(var_13_0, arg_13_2, arg_13_3)
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	arg_13_0._matchmaking_manager:reset_joining()

	arg_13_0.state_context.lobby_client = nil
	arg_13_0.state_context.join_lobby_data = nil

	if arg_13_1 ~= "cancelled" and not arg_13_5 then
		local var_13_1 = "matchmaking_status_join_game_failed_" .. arg_13_1

		arg_13_0._matchmaking_manager:send_system_chat_message(var_13_1)
	end

	local var_13_2 = arg_13_0.state_context
	local var_13_3 = var_13_2.join_by_lobby_browser or var_13_2.is_flexmatch
	local var_13_4 = arg_13_0.state_context.search_config

	if var_13_3 then
		arg_13_0._matchmaking_manager:cancel_join_lobby(arg_13_1, arg_13_4)

		return MatchmakingStateIdle, arg_13_0.state_context
	elseif var_13_4 and var_13_4.dedicated_server and var_13_4.join_method == "party" then
		if var_13_4.aws then
			return MatchmakingStateFlexmatchHost, arg_13_0.state_context
		end

		return MatchmakingStateReserveLobby, arg_13_0.state_context
	else
		return MatchmakingStateSearchGame, arg_13_0.state_context
	end
end

function MatchmakingStateRequestJoinGame.rpc_matchmaking_request_join_lobby_reply(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0._game_reply = NetworkLookup.game_ping_reply[arg_14_2]
	arg_14_0._game_reply_variable = arg_14_3
end

function MatchmakingStateRequestJoinGame.rpc_notify_connected(arg_15_0, arg_15_1)
	arg_15_0._connected_to_server = true
end
