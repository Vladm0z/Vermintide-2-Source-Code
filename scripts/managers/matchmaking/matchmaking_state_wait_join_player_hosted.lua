-- chunkname: @scripts/managers/matchmaking/matchmaking_state_wait_join_player_hosted.lua

MatchmakingStateWaitJoinPlayerHosted = class(MatchmakingStateWaitJoinPlayerHosted)
MatchmakingStateWaitJoinPlayerHosted.NAME = "MatchmakingStateWaitJoinPlayerHosted"

MatchmakingStateWaitJoinPlayerHosted.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_options = arg_1_1.network_options
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_transmit = arg_1_1.network_transmit
	self._is_server = arg_1_1.is_server
end

MatchmakingStateWaitJoinPlayerHosted.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateWaitJoinPlayerHosted.on_enter = function (self, arg_3_1)
	-- function 3
	Managers.mechanism:mechanism_try_call("on_enter_custom_game_lobby")

	self._current_lobby = Managers.state.network:lobby()
	self._state_context = arg_3_1
	self._search_config = arg_3_1.search_config

	local get_lobby = Managers.lobby:get_lobby("matchmaking_join_lobby")
	local flag = get_lobby:lobby_data("match_started") == "true"
	local flag_2

	flag_2 = not flag and "start_lobby" and nil
	self._next_transition_state = flag_2
	self._match_host = get_lobby:lobby_host()
	self._friend_joining = arg_3_1.friend_join

	if not (not self._friend_joining and flag) then
		Managers.ui:handle_transition("start_game_view_force", {
			menu_sub_state_name = "versus_player_hosted_lobby",
			menu_state_name = "play",
			use_fade = true
		})
	end
end

MatchmakingStateWaitJoinPlayerHosted.on_exit = function (self)
	-- function 4
	if not self._next_transition_state then
		self:terminate()
	end
end

MatchmakingStateWaitJoinPlayerHosted.terminate = function (arg_5_0)
	-- function 5
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

MatchmakingStateWaitJoinPlayerHosted.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		return self:_lobby_failed()
	end

	query_lobby:update(arg_6_1)

	if not query_lobby:failed() then
		return self:_lobby_failed()
	end

	local lobby_host = query_lobby.lobby:lobby_host()

	if not (not lobby_host and lobby_host == self._match_host) then
		Managers.matchmaking:add_broken_lobby_client(query_lobby, arg_6_2, true)

		return self:_lobby_failed()
	end
end

MatchmakingStateWaitJoinPlayerHosted._teardown_lobby = function (self)
	-- function 7
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	self._matchmaking_manager:reset_joining()

	self._state_context.join_lobby_data = nil
end

MatchmakingStateWaitJoinPlayerHosted._lobby_failed = function (self)
	-- function 8
	self:_teardown_lobby()

	return MatchmakingStateIdle
end

MatchmakingStateWaitJoinPlayerHosted.get_transition = function (self)
	-- function 9
	if not self._next_transition_state then
		local tbl = {
			lobby_client = Managers.lobby:free_lobby("matchmaking_join_lobby")
		}

		return self._next_transition_state, tbl
	end
end

MatchmakingStateWaitJoinPlayerHosted.rpc_matchmaking_join_game = function (self, arg_10_1)
	-- function 10
	mm_printf_force("Transition from join due to rpc_matchmaking_join_game")
	self._matchmaking_manager:send_system_chat_message("matchmaking_status_joining_game")

	self._matchmaking_manager.debug.text = "starting_game"
	self._next_transition_state = "start_lobby"

	Managers.mechanism:network_handler():get_match_handler():send_rpc_down("rpc_matchmaking_join_game")
end
