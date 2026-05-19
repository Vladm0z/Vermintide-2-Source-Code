-- chunkname: @scripts/managers/matchmaking/matchmaking_state_wait_join_player_hosted.lua

MatchmakingStateWaitJoinPlayerHosted = class(MatchmakingStateWaitJoinPlayerHosted)
MatchmakingStateWaitJoinPlayerHosted.NAME = "MatchmakingStateWaitJoinPlayerHosted"

function MatchmakingStateWaitJoinPlayerHosted.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_options = arg_1_1.network_options
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._is_server = arg_1_1.is_server
end

function MatchmakingStateWaitJoinPlayerHosted.destroy(arg_2_0)
	return
end

function MatchmakingStateWaitJoinPlayerHosted.on_enter(arg_3_0, arg_3_1)
	Managers.mechanism:mechanism_try_call("on_enter_custom_game_lobby")

	arg_3_0._current_lobby = Managers.state.network:lobby()
	arg_3_0._state_context = arg_3_1
	arg_3_0._search_config = arg_3_1.search_config

	local var_3_0 = Managers.lobby:get_lobby("matchmaking_join_lobby")
	local var_3_1 = var_3_0:lobby_data("match_started") == "true"

	arg_3_0._next_transition_state = var_3_1 and "start_lobby" or nil
	arg_3_0._match_host = var_3_0:lobby_host()
	arg_3_0._friend_joining = arg_3_1.friend_join

	if arg_3_0._friend_joining and not var_3_1 then
		Managers.ui:handle_transition("start_game_view_force", {
			menu_sub_state_name = "versus_player_hosted_lobby",
			menu_state_name = "play",
			use_fade = true
		})
	end
end

function MatchmakingStateWaitJoinPlayerHosted.on_exit(arg_4_0)
	if not arg_4_0._next_transition_state then
		arg_4_0:terminate()
	end
end

function MatchmakingStateWaitJoinPlayerHosted.terminate(arg_5_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

function MatchmakingStateWaitJoinPlayerHosted.update(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not var_6_0 then
		return arg_6_0:_lobby_failed()
	end

	var_6_0:update(arg_6_1)

	if var_6_0:failed() then
		return arg_6_0:_lobby_failed()
	end

	local var_6_1 = var_6_0.lobby:lobby_host()

	if var_6_1 and var_6_1 ~= arg_6_0._match_host then
		Managers.matchmaking:add_broken_lobby_client(var_6_0, arg_6_2, true)

		return arg_6_0:_lobby_failed()
	end
end

function MatchmakingStateWaitJoinPlayerHosted._teardown_lobby(arg_7_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	arg_7_0._matchmaking_manager:reset_joining()

	arg_7_0._state_context.join_lobby_data = nil
end

function MatchmakingStateWaitJoinPlayerHosted._lobby_failed(arg_8_0)
	arg_8_0:_teardown_lobby()

	return MatchmakingStateIdle
end

function MatchmakingStateWaitJoinPlayerHosted.get_transition(arg_9_0)
	if arg_9_0._next_transition_state then
		local var_9_0 = {
			lobby_client = Managers.lobby:free_lobby("matchmaking_join_lobby")
		}

		return arg_9_0._next_transition_state, var_9_0
	end
end

function MatchmakingStateWaitJoinPlayerHosted.rpc_matchmaking_join_game(arg_10_0, arg_10_1)
	mm_printf_force("Transition from join due to rpc_matchmaking_join_game")
	arg_10_0._matchmaking_manager:send_system_chat_message("matchmaking_status_joining_game")

	arg_10_0._matchmaking_manager.debug.text = "starting_game"
	arg_10_0._next_transition_state = "start_lobby"

	Managers.mechanism:network_handler():get_match_handler():send_rpc_down("rpc_matchmaking_join_game")
end
