-- chunkname: @scripts/managers/matchmaking/matchmaking_state_request_join_game.lua

require("scripts/game_state/server_join_state_machine")

MatchmakingStateRequestJoinGame = class(MatchmakingStateRequestJoinGame)
MatchmakingStateRequestJoinGame.NAME = "MatchmakingStateRequestJoinGame"

MatchmakingStateRequestJoinGame.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_options = arg_1_1.network_options
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_transmit = arg_1_1.network_transmit
	self._matchmaking_manager.selected_profile_index = nil
	self._state = "waiting_to_join_lobby"
end

MatchmakingStateRequestJoinGame.destroy = function (self)
	-- function 2
	if self._password_request ~= nil then
		self._password_request:destroy()

		self._password_request = nil
	end
end

MatchmakingStateRequestJoinGame.terminate = function (arg_3_0)
	-- function 3
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

MatchmakingStateRequestJoinGame.on_enter = function (self, arg_4_1)
	-- function 4
	self.state_context = arg_4_1
	self._join_lobby_data = arg_4_1.join_lobby_data
	self._game_reply = nil
	self._connected_to_server = false
	self._connect_timeout = nil
	self._join_timeout = nil

	if not arg_4_1.reserved_lobby then
		Managers.lobby:register_existing_lobby(arg_4_1.reserved_lobby, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (on_enter)")
	end

	self._pre_verification_error = nil

	local _run_pre_connection_verification, var_4_1 = self:_run_pre_connection_verification(self._join_lobby_data)

	if not _run_pre_connection_verification then
		local var_4_2

		if Managers.lobby:query_lobby("matchmaking_join_lobby") == nil then
			self:_setup_lobby_connection(self._join_lobby_data, arg_4_1.password)

			var_4_2 = self._join_lobby_data.host or "nohostname"
		else
			var_4_2 = "dedicated server"
		end

		self._matchmaking_manager.debug.text = "Joining lobby"
		self._matchmaking_manager.debug.state = "hosted by: " .. var_4_2

		local flag = true

		Managers.chat:add_local_system_message(1, Localize("matchmaking_status_starting_handshake"), flag)
	else
		self._state = "failed_pre_connection_verification"
		self._pre_verification_error = var_4_1 or "pre_verification_failed"
	end
end

MatchmakingStateRequestJoinGame.on_exit = function (arg_5_0)
	-- function 5
	return
end

MatchmakingStateRequestJoinGame._run_pre_connection_verification = function (self, arg_6_1)
	-- function 6
	local id = self._lobby:id()
	local id_2 = arg_6_1.id

	id_2 = id_2 or arg_6_1.name

	if id_2 == id then
		return false, "popup_already_in_same_lobby"
	end

	return true
end

MatchmakingStateRequestJoinGame._setup_lobby_connection = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _network_options = self._network_options

	if not arg_7_1.server_info then
		if arg_7_2 == nil then
			self._state = "waiting_for_password"
			self._user_data = {
				network_options = _network_options,
				game_server_data = arg_7_1
			}
		else
			Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (_setup_lobby_connection, GameServerLobbyClient)", _network_options, arg_7_1, arg_7_2)
		end
	else
		Managers.lobby:make_lobby(LobbyClient, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (_setup_lobby_connection, LobbyClient)", _network_options, arg_7_1)
	end
end

MatchmakingStateRequestJoinGame.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0
	local var_8_1
	local var_8_2
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if query_lobby or not self._had_lobby then
		self._had_lobby = true

		if not query_lobby then
			query_lobby:update(arg_8_1)

			var_8_0 = query_lobby:lobby_host()
			var_8_1 = query_lobby:id()

			local state = query_lobby.state

			if not query_lobby:failed() then
				return self:_join_game_failed("failure_start_join_server", arg_8_2, true)
			end
		else
			return self:_join_game_failed("failure_start_join_server", arg_8_2, true)
		end
	end

	local _state = self._state

	if _state == "failed_pre_connection_verification" then
		return self:_join_game_failed(self._pre_verification_error, arg_8_2, false)
	elseif _state == "waiting_for_password" then
		local var_8_6
		local var_8_7
		local var_8_8

		if not self._password_request then
			self._password_request:update(arg_8_1)

			var_8_6, var_8_7, var_8_8 = self._password_request:result()
		else
			var_8_6, var_8_7, var_8_8 = "join", self._user_data, ""
		end

		if var_8_6 ~= nil then
			if var_8_6 == "join" then
				Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "MatchmakingStateRequestJoinGame (update)", var_8_7.network_options, var_8_7.game_server_data, var_8_8)

				self._state = "waiting_to_join_lobby"
			else
				return self:_join_game_failed("cancelled", arg_8_2, false)
			end

			if not self._password_request then
				self._password_request:destroy()

				self._password_request = nil
			end
		end
	elseif _state == "waiting_to_join_lobby" then
		if not (not query_lobby:is_joined() and var_8_0 == "0") then
			self._matchmaking_manager.debug.text = "Connecting to host"

			if not (not LobbyInternal.user_name and LobbyInternal.user_name(var_8_0) and not query_lobby.user_name or query_lobby:user_name(var_8_0)) then
				local str = "-"
			end

			mm_printf("Joined lobby, checking network hash...")

			self._check_network_hash_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
			self._state = "check_network_hash"
		end
	elseif _state == "check_network_hash" then
		local network_hash = query_lobby.network_hash
		local lobby_data = query_lobby:lobby_data("network_hash")
		local user_name

		if not LobbyInternal.user_name then
			user_name = LobbyInternal.user_name(var_8_0)

			if not user_name then
				-- Nothing
			end
		end

		user_name = "-"

		::label_8_0::

		if lobby_data ~= nil then
			if network_hash == lobby_data or not Development.parameter("force_ignore_network_hash") then
				mm_printf("Network hashes matches, waiting to connect to host with user name '%s'...", tostring(user_name))

				self._state = "verify_not_blocked"
			else
				mm_printf("Network hashes differ. lobby_id=%s, host_id:%s, this_hash:%q, other_hash:%q", var_8_1, user_name, network_hash, lobby_data)
				self:_join_fail_popup(string.format(Localize("failure_start_join_server_incorrect_hash"), network_hash, lobby_data))

				return self:_join_game_failed("network_hash_mismatch", arg_8_2, true)
			end
		elseif arg_8_2 > self._check_network_hash_timeout then
			mm_printf("Failed to get lobby data in time. lobby_id=%s, host_id:%s", var_8_1, user_name)

			return self:_join_game_failed("lobby_data_timeout", arg_8_2, true)
		end
	elseif _state == "verify_not_blocked" then
		if DEDICATED_SERVER or not IS_WINDOWS then
			local lobby_host = query_lobby:lobby_host()

			if not rawget(_G, "Friends") then
				local relationship = Friends.relationship(lobby_host)

				if not (relationship == Friends.IGNORED or relationship ~= Friends.IGNORED_FRIEND) then
					return self:_join_game_failed("user_blocked", arg_8_2, false)
				end
			end
		end

		self._state = "verify_game_mode"
	elseif _state == "verify_game_mode" then
		if not query_lobby:lobby_data("matchmaking_type") then
			self._state = "verify_difficulty"

			return
		end

		local lobby_data_2 = query_lobby:lobby_data("mechanism")
		local var_8_16 = MechanismSettings[lobby_data_2]

		if not var_8_16 and not var_8_16.extra_requirements_function then
			if not var_8_16.extra_requirements_function() then
				if not var_8_16.disable_difficulty_check then
					self._state = "waiting_to_connect"
					self._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
				else
					self._state = "verify_difficulty"
				end
			else
				if not (not LobbyInternal.user_name and LobbyInternal.user_name(var_8_0)) then
					local str_2 = "-"
				end

				local str_3 = "failure_start_join_server_game_mode_requirements_failed"

				return self:_join_game_failed(str_3, arg_8_2, false, nil, true)
			end
		elseif not var_8_16 and not var_8_16.disable_difficulty_check then
			self._state = "waiting_to_connect"
			self._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
		else
			self._state = "verify_difficulty"
		end
	elseif _state == "verify_difficulty" then
		if not Development.parameter("unlock_all_difficulties") then
			self._state = "waiting_to_connect"
			self._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME

			return
		end

		local flag = true
		local str_4 = ""

		if not (query_lobby:lobby_data("is_private") == "true") then
			local lobby_data_3 = query_lobby:lobby_data("difficulty")

			lobby_data_3 = lobby_data_3 or "normal"

			local var_8_22 = DifficultySettings[lobby_data_3]

			if Managers.player:local_player():best_aquired_power_level() < var_8_22.required_power_level then
				flag = false
				str_4 = string.format("%s: %s\n", Localize("required_power_level"), tostring(UIUtils.presentable_hero_power_level(var_8_22.required_power_level)))
			end

			if not var_8_22.extra_requirement_name then
				local var_8_23 = ExtraDifficultyRequirements[var_8_22.extra_requirement_name]

				if not var_8_23.requirement_function() then
					flag = false
					str_4 = str_4 .. "* " .. Localize(var_8_23.description_text) .. "\n"
				end
			end
		end

		if not flag then
			if not (not LobbyInternal.user_name and LobbyInternal.user_name(var_8_0)) then
				local str_5 = "-"
			end

			local str_6 = "failure_start_join_server_difficulty_requirements_failed"

			return self:_join_game_failed(str_6, arg_8_2, false, str_4, true)
		else
			self._state = "waiting_to_connect"
			self._connect_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
		end
	elseif _state == "waiting_to_connect" then
		if not self._connected_to_server then
			self._matchmaking_manager.debug.text = "Requesting to join"

			mm_printf("Connected, requesting to join game...")

			if not HAS_STEAM and not query_lobby.set_steam_lobby_reconnectable then
				query_lobby:set_steam_lobby_reconnectable(false)
			end

			local flag_2 = not not self.state_context.friend_join
			local _gather_dlc_ids = self:_gather_dlc_ids()

			self._network_transmit:send_rpc("rpc_matchmaking_request_join_lobby", var_8_0, var_8_1, flag_2, _gather_dlc_ids)

			self._join_timeout = arg_8_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
			self._state = "asking_to_join"
		elseif arg_8_2 > self._connect_timeout then
			local user_name_2

			if not LobbyInternal.user_name then
				user_name_2 = LobbyInternal.user_name(var_8_0)

				if not user_name_2 then
					-- Nothing
				end
			end

			user_name_2 = "-"

			::label_8_1::

			mm_printf_force("Failed to connect to host due to timeout. lobby_id=%s, host_id:%s", var_8_1, user_name_2)

			return self:_join_game_failed("connection_timeout", arg_8_2, true)
		end
	elseif _state == "asking_to_join" then
		local num = MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME - (self._join_timeout - arg_8_2)

		self._matchmaking_manager.debug.text = string.format("Requesting to join game %s [%.0f]", query_lobby:id(), num)

		local user_name_3

		if not LobbyInternal.user_name then
			user_name_3 = LobbyInternal.user_name(var_8_0)

			if not user_name_3 then
				-- Nothing
			end
		end

		user_name_3 = "-"

		::label_8_2::

		local _game_reply = self._game_reply

		if arg_8_2 > self._join_timeout then
			mm_printf_force("Failed to join game due to timeout. lobby_id=%s, host_id:%s", var_8_1, user_name_3)

			return self:_join_game_failed("connection_timeout", arg_8_2, true)
		elseif _game_reply ~= nil then
			if _game_reply == "lobby_ok" then
				mm_printf("Successfully joined game after %.2f seconds: lobby_id=%s host_id:%s", num, var_8_1, user_name_3)

				return self:_join_game_success(arg_8_2)
			elseif _game_reply == "custom_lobby_ok" then
				return self:_try_friend_join_custom_lobby()
			else
				mm_printf_force("Failed to join game due to host responding '%s'. lobby_id=%s, host_id:%s", _game_reply, var_8_1, user_name_3)

				return self:_join_game_failed(_game_reply, arg_8_2, _game_reply == "lobby_id_mismatch", self._game_reply_variable, true)
			end
		end
	end

	return nil
end

MatchmakingStateRequestJoinGame._gather_dlc_ids = function (arg_9_0)
	-- function 9
	local tbl = {}
	local unlocks = UnlockSettings[1].unlocks
	local unlock = Managers.unlock

	for k, v in pairs(unlocks) do
		if not (not unlock:is_dlc_unlocked(k) and unlock:is_dlc_cosmetic(k)) then
			print(k)

			tbl[#tbl + 1] = NetworkLookup.dlcs[k]
		end
	end

	return tbl
end

MatchmakingStateRequestJoinGame._try_friend_join_custom_lobby = function (self)
	-- function 10
	local MatchmakingStateIdle = MatchmakingStateIdle
	local mechanism_try_call, var_10_2 = Managers.mechanism:mechanism_try_call("can_join_custom_lobby")
	local var_10_3

	if not mechanism_try_call and not var_10_2 then
		MatchmakingStateIdle = MatchmakingStateReserveSlotsPlayerHosted
	else
		var_10_3 = "vs_player_hosted_lobby_wrong_mechanism_error"
	end

	if not var_10_3 then
		Managers.matchmaking:send_system_chat_message(var_10_3)
	end

	self.state_context.join_lobby_data = self._join_lobby_data

	return MatchmakingStateIdle, self.state_context
end

MatchmakingStateRequestJoinGame._join_game_success = function (self, arg_11_1)
	-- function 11
	local search_config = self.state_context.search_config

	search_config = not search_config and self.state_context.search_config.join_method

	if search_config == "party" then
		return MatchmakingStatePartyJoins, self.state_context
	else
		return MatchmakingStateRequestProfiles, self.state_context
	end
end

MatchmakingStateRequestJoinGame._join_fail_popup = function (self, arg_12_1)
	-- function 12
	local non_matchmaking_join = self.state_context.non_matchmaking_join
	local join_by_lobby_browser = self.state_context.join_by_lobby_browser

	join_by_lobby_browser = not join_by_lobby_browser and self.lobby_browser_view_ui

	if not (not non_matchmaking_join and join_by_lobby_browser) then
		Managers.simple_popup:queue_popup(arg_12_1, Localize("popup_error_topic"), "ok", Localize("button_ok"))
	end
end

MatchmakingStateRequestJoinGame._join_game_failed = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		self._matchmaking_manager:add_broken_lobby_client(query_lobby, arg_13_2, arg_13_3)
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	self._matchmaking_manager:reset_joining()

	self.state_context.lobby_client = nil
	self.state_context.join_lobby_data = nil

	if not (arg_13_1 == "cancelled" or arg_13_5) then
		local str = "matchmaking_status_join_game_failed_" .. arg_13_1

		self._matchmaking_manager:send_system_chat_message(str)
	end

	local state_context = self.state_context
	local join_by_lobby_browser = state_context.join_by_lobby_browser

	join_by_lobby_browser = join_by_lobby_browser or state_context.is_flexmatch

	local search_config = self.state_context.search_config

	if not join_by_lobby_browser then
		self._matchmaking_manager:cancel_join_lobby(arg_13_1, arg_13_4)

		return MatchmakingStateIdle, self.state_context
	elseif not (not search_config and not search_config.dedicated_server and search_config.join_method ~= "party") then
		if not search_config.aws then
			return MatchmakingStateFlexmatchHost, self.state_context
		end

		return MatchmakingStateReserveLobby, self.state_context
	else
		return MatchmakingStateSearchGame, self.state_context
	end
end

MatchmakingStateRequestJoinGame.rpc_matchmaking_request_join_lobby_reply = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	self._game_reply = NetworkLookup.game_ping_reply[arg_14_2]
	self._game_reply_variable = arg_14_3
end

MatchmakingStateRequestJoinGame.rpc_notify_connected = function (self, arg_15_1)
	-- function 15
	self._connected_to_server = true
end
