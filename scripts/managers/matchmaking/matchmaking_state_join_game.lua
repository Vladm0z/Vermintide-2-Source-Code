-- chunkname: @scripts/managers/matchmaking/matchmaking_state_join_game.lua

MatchmakingStateJoinGame = class(MatchmakingStateJoinGame)
MatchmakingStateJoinGame.NAME = "MatchmakingStateJoinGame"

MatchmakingStateJoinGame.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_transmit = arg_1_1.network_transmit
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_transmit = arg_1_1.network_transmit
	self._statistics_db = arg_1_1.statistics_db
	self._ingame_ui = arg_1_1.ingame_ui
	self._matchmaking_manager.selected_profile_index = nil
	self._matchmaking_loading_context = {}
	self._hero_popup_at_t = nil
	self._selected_hero_at_t = nil
	self._show_popup = false
	self._wwise_world = arg_1_1.wwise_world
end

MatchmakingStateJoinGame.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateJoinGame.on_enter = function (self, arg_3_1)
	-- function 3
	self.state_context = arg_3_1
	self.search_config = arg_3_1.search_config
	self.lobby_client = arg_3_1.lobby_client
	self._makeshift_lobby_data = arg_3_1.profiles_data
	self._join_lobby_data = arg_3_1.join_lobby_data

	local reserved_party_id = arg_3_1.reserved_party_id

	reserved_party_id = reserved_party_id or 1
	self._reserved_party_id = reserved_party_id
	self._makeshift_lobby_data.selected_mission_id = self._join_lobby_data.selected_mission_id
	self._makeshift_lobby_data.difficulty = self._join_lobby_data.difficulty
	self._makeshift_lobby_data.reserved_profiles = self.lobby_client:lobby_data("reserved_profiles")

	if not Managers.mechanism:mechanism_setting("check_matchmaking_hero_availability") then
		local _matchmaking_manager = self._matchmaking_manager
		local _current_hero, var_3_3, var_3_4 = self:_current_hero()

		fassert(_current_hero, "no hero index? this is wrong")

		if not (not _matchmaking_manager:hero_available_in_lobby_data(_current_hero, self._makeshift_lobby_data, self._reserved_party_id) and Application.user_setting("always_ask_hero_when_joining")) then
			self._selected_hero_name = var_3_3

			self:_request_profile_from_host(_current_hero, var_3_4)
		else
			self._show_popup = true
		end

		local flag = true

		Managers.chat:add_local_system_message(1, Localize("matchmaking_status_aquiring_profiles"), flag)
	else
		WwiseWorld.trigger_event(self._wwise_world, "menu_wind_countdown_warning")
		self:_set_state_to_start_lobby()
	end

	if not Managers.mechanism:mechanism_setting("sync_backend_id") then
		self:_sync_backend_id()
	end

	self._update_lobby_data_timer = 0
end

MatchmakingStateJoinGame.on_exit = function (arg_4_0)
	-- function 4
	local ui = Managers.ui

	if not ui:get_active_popup("profile_picker") then
		ui:close_popup("profile_picker")
	end
end

MatchmakingStateJoinGame.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_active_popup = Managers.ui:get_active_popup("profile_picker")

	if not get_active_popup then
		local query_result = get_active_popup:query_result()

		if not query_result then
			self._profile_picker_shown = false
			self._selected_hero_at_t = arg_5_2

			if not self:_handle_popup_result(query_result, arg_5_2) then
				self._matchmaking_manager:cancel_matchmaking()

				return nil
			end
		end

		self:_update_lobby_data(arg_5_1, arg_5_2)
	elseif not self._profile_picker_shown then
		self._profile_picker_shown = false

		self._matchmaking_manager:cancel_matchmaking()

		return nil
	end

	if not Managers.state.network then
		self._matchmaking_manager:cancel_matchmaking()

		return nil
	end

	if not self._exit_to_search_game then
		mm_printf_force("Search was aborted")

		local _matchmaking_manager = self._matchmaking_manager

		_matchmaking_manager:add_broken_lobby_client(self.lobby_client, arg_5_2, false)

		if not self.lobby_client then
			self.lobby_client:destroy()

			self.lobby_client = nil
		end

		self.state_context.lobby_client = nil
		self.state_context.join_lobby_data = nil

		self._matchmaking_manager:reset_joining()

		if not self.state_context.join_by_lobby_browser then
			mm_printf_force("Abort from lobby browser or invite")
			_matchmaking_manager:cancel_join_lobby("cancelled")

			return MatchmakingStateIdle, self.state_context
		elseif not Managers.account:user_detached() then
			mm_printf_force("User detached - > Cancel Matchmaking")
			_matchmaking_manager:cancel_matchmaking()

			return MatchmakingStateIdle, self.state_context
		else
			mm_printf_force("Abort for other reason")

			local lobby = Managers.state.network:lobby()

			if not lobby then
				Managers.party:set_leader(lobby:lobby_host())
			end

			local search_config = self.search_config

			if not (not search_config and not search_config.dedicated_server and search_config.join_method ~= "party") then
				if not search_config.aws then
					return MatchmakingStateFlexmatchHost, self.state_context
				end

				return MatchmakingStateReserveLobby, self.state_context
			else
				return MatchmakingStateSearchGame, self.state_context
			end
		end
	end

	if not self._show_popup then
		self._makeshift_lobby_data.reserved_profiles = self.lobby_client:lobby_data("reserved_profiles")

		local backend = Managers.backend
		local is_waiting_for_user_input = backend:is_waiting_for_user_input()
		local flag = backend:get_interface("items"):num_current_item_server_requests() ~= 0

		if not (is_waiting_for_user_input or flag) then
			self:_spawn_join_popup(arg_5_1, arg_5_2)
		end
	end

	if not (not Managers.state.network.is_server and Managers.state.network.network_server:are_all_peers_ingame(nil, true)) then
		Managers.simple_popup:queue_popup(Localize("player_join_block_exit_game"), Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
		self._matchmaking_manager:cancel_matchmaking()

		return nil
	end

	return nil
end

MatchmakingStateJoinGame._update_lobby_data = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._update_lobby_data_timer = self._update_lobby_data_timer - arg_6_1

	if self._update_lobby_data_timer < 0 then
		self._update_lobby_data_timer = 0.5

		local _makeshift_lobby_data = self._makeshift_lobby_data
		local lobby_client = self.lobby_client
		local lobby_data = lobby_client:lobby_data("selected_mission_id")

		if _makeshift_lobby_data.selected_mission_id ~= lobby_data then
			_makeshift_lobby_data.selected_mission_id = lobby_data
		end

		local lobby_data_2 = lobby_client:lobby_data("difficulty")

		_makeshift_lobby_data.difficulty_tweak = lobby_client:lobby_data("difficulty_tweak")

		if _makeshift_lobby_data.difficulty ~= lobby_data_2 then
			_makeshift_lobby_data.difficulty = lobby_data_2

			if not self._popup_profile_picker then
				self._popup_profile_picker:set_difficulty(lobby_data_2)
			end
		end
	end
end

MatchmakingStateJoinGame._handle_popup_result = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0
	local flag = false

	if not arg_7_1.accepted then
		mm_printf_force("Popup accepted")

		local selected_hero_name = arg_7_1.selected_hero_name
		local var_7_3 = FindProfileIndex(selected_hero_name)

		self._selected_hero_name = selected_hero_name
		self._selected_career_name = arg_7_1.selected_career_name

		local var_7_4 = career_index_from_name(var_7_3, self._selected_career_name)

		self:_request_profile_from_host(var_7_3, var_7_4)
	else
		mm_printf_force("Popup cancelled")

		local local_player = Managers.player:local_player(1)
		local reason = arg_7_1.reason

		reason = reason or "timed_out"

		if not (not self._selected_hero_at_t and self._selected_hero_at_t - self._hero_popup_at_t) then
			local num = 0
		end

		local flag_2 = false

		self._matchmaking_manager:add_broken_lobby_client(self.lobby_client, arg_7_2, flag_2)

		if reason == "cancelled" then
			flag = true
		else
			self._exit_to_search_game = true
		end

		local str = "matchmaking_status_character_select_" .. reason

		self._matchmaking_manager:send_system_chat_message(str)
	end

	Managers.ui:close_popup("profile_picker")

	return flag
end

MatchmakingStateJoinGame.get_transition = function (self)
	-- function 8
	if not self._join_lobby_data and not self._next_transition_state then
		local join_method = self._join_lobby_data.join_method

		if not join_method then
			join_method = self.search_config
			join_method = not join_method and self.search_config.join_method
		end

		local tbl = {
			lobby_client = self.lobby_client,
			join_method = join_method
		}

		return self._next_transition_state, tbl
	end
end

MatchmakingStateJoinGame._spawn_join_popup = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not Managers.popup:has_popup() then
		self:_update_popup_timeout(arg_9_1, arg_9_2)

		return
	end

	local state_context = self.state_context
	local peer_id = Network.peer_id()
	local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)
	local profile_index = player_from_peer_id:profile_index()
	local career_index = player_from_peer_id:career_index()
	local JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL = MatchmakingSettings.JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL
	local join_by_lobby_browser = self.state_context.join_by_lobby_browser
	local lobby_data = self.lobby_client:lobby_data("difficulty")
	local var_9_8

	if self._denied_reason == "profile_locked" then
		var_9_8 = profile_index
	end

	Managers.ui:open_popup("profile_picker", profile_index, career_index, JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL, join_by_lobby_browser, lobby_data, self.lobby_client, self._reserved_party_id, var_9_8)

	self._profile_picker_shown = true
	self._hero_popup_at_t = Managers.time:time("game")
	self._show_popup = false
	self._popup_auto_cancel_time = nil
end

MatchmakingStateJoinGame._update_popup_timeout = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _popup_auto_cancel_time = self._popup_auto_cancel_time

	_popup_auto_cancel_time = _popup_auto_cancel_time or arg_10_2 + MatchmakingSettings.JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL
	self._popup_auto_cancel_time = _popup_auto_cancel_time

	if arg_10_2 > self._popup_auto_cancel_time then
		local str = "matchmaking_status_character_select_timed_out"

		self._matchmaking_manager:send_system_chat_message(str)
		self._matchmaking_manager:cancel_matchmaking()
	end
end

MatchmakingStateJoinGame._request_profile_from_host = function (self, arg_11_1, arg_11_2)
	-- function 11
	local lobby_client = self.lobby_client
	local lobby_host = lobby_client:lobby_host()

	self._matchmaking_manager.selected_profile_index = arg_11_1

	RPC.rpc_matchmaking_request_profile(PEER_ID_TO_CHANNEL[lobby_host], arg_11_1, arg_11_2)

	local var_11_2 = lobby_host

	if not (not rawget(_G, "Steam") and GameSettingsDevelopment.network_mode ~= "steam") then
		var_11_2 = Steam.user_name(lobby_host)
	end

	self._matchmaking_manager.debug.text = "requesting_profile"
	self._matchmaking_manager.debug.state = "hosted by: " .. (var_11_2 or "unknown")
	self._matchmaking_manager.debug.level = lobby_client:lobby_data("selected_mission_id")
end

MatchmakingStateJoinGame.rpc_matchmaking_request_profile_reply = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = NetworkLookup.request_profile_replies[arg_12_3]
	local _selected_hero_name = self._selected_hero_name
	local var_12_2 = FindProfileIndex(_selected_hero_name)

	self._denied_reason = nil

	fassert(arg_12_2 == var_12_2 or var_12_0 == "previous_profile_accepted", "wrong profile in rpc_matchmaking_request_profile_reply")

	if var_12_0 == "profile_accepted" then
		self._matchmaking_manager.debug.text = var_12_0
		self._denied_reason = var_12_0

		if not self._selected_career_name then
			local get_interface = Managers.backend:get_interface("hero_attributes")
			local var_12_4 = career_index_from_name(var_12_2, self._selected_career_name)

			get_interface:set(_selected_hero_name, "career", var_12_4)
		end

		self:_set_state_to_start_lobby()
	elseif var_12_0 == "previous_profile_accepted" then
		self._matchmaking_manager.debug.text = var_12_0
		self._denied_reason = var_12_0

		self:_set_state_to_start_lobby()
	elseif var_12_0 == "profile_declined" then
		self._denied_reason = var_12_0
		self._matchmaking_manager.debug.text = var_12_0
		self._show_popup = true
	elseif var_12_0 == "profile_locked" then
		self._denied_reason = var_12_0
		self._matchmaking_manager.debug.text = var_12_0
		self._show_popup = true
	end
end

MatchmakingStateJoinGame._current_hero = function (arg_13_0)
	-- function 13
	local peer_id = Network.peer_id()
	local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)
	local profile_index = player_from_peer_id:profile_index()
	local career_index = player_from_peer_id:career_index()
	local display_name = SPProfiles[profile_index].display_name

	return profile_index, display_name, career_index
end

MatchmakingStateJoinGame._level_started = function (self)
	-- function 14
	local lobby_client = self.lobby_client
	local lobby_data = lobby_client:lobby_data("selected_mission_id")
	local lobby_data_2 = lobby_client:lobby_data("mission_id")

	return lobby_data == lobby_data_2, lobby_data_2
end

MatchmakingStateJoinGame.loading_context = function (self)
	-- function 15
	return self._matchmaking_loading_context
end

MatchmakingStateJoinGame.rpc_matchmaking_join_game = function (self, arg_16_1)
	-- function 16
	mm_printf_force("Transition from join due to rpc_matchmaking_join_game")
	self:_set_state_to_start_lobby()
	Managers.mechanism:network_handler():get_match_handler():send_rpc_down("rpc_matchmaking_join_game")
end

MatchmakingStateJoinGame._sync_backend_id = function (self)
	-- function 17
	local lobby_host = self.lobby_client:lobby_host()
	local player_id = Managers.backend:player_id()

	if not player_id and not self._network_transmit then
		self._network_transmit:send_rpc("rpc_set_peer_backend_id", lobby_host, player_id)
	end
end

MatchmakingStateJoinGame.active_lobby = function (self)
	-- function 18
	return self.lobby_client
end

MatchmakingStateJoinGame._set_state_to_start_lobby = function (self)
	-- function 19
	self._matchmaking_manager:send_system_chat_message("matchmaking_status_joining_game")

	self._matchmaking_manager.debug.text = "starting_game"
	self._next_transition_state = "start_lobby"
end
