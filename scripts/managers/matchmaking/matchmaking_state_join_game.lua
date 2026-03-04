-- chunkname: @scripts/managers/matchmaking/matchmaking_state_join_game.lua

MatchmakingStateJoinGame = class(MatchmakingStateJoinGame)
MatchmakingStateJoinGame.NAME = "MatchmakingStateJoinGame"

function MatchmakingStateJoinGame.init(arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._statistics_db = arg_1_1.statistics_db
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._matchmaking_manager.selected_profile_index = nil
	arg_1_0._matchmaking_loading_context = {}
	arg_1_0._hero_popup_at_t = nil
	arg_1_0._selected_hero_at_t = nil
	arg_1_0._show_popup = false
	arg_1_0._wwise_world = arg_1_1.wwise_world
end

function MatchmakingStateJoinGame.destroy(arg_2_0)
	return
end

function MatchmakingStateJoinGame.on_enter(arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
	arg_3_0.search_config = arg_3_1.search_config
	arg_3_0.lobby_client = arg_3_1.lobby_client
	arg_3_0._makeshift_lobby_data = arg_3_1.profiles_data
	arg_3_0._join_lobby_data = arg_3_1.join_lobby_data
	arg_3_0._reserved_party_id = arg_3_1.reserved_party_id or 1
	arg_3_0._makeshift_lobby_data.selected_mission_id = arg_3_0._join_lobby_data.selected_mission_id
	arg_3_0._makeshift_lobby_data.difficulty = arg_3_0._join_lobby_data.difficulty
	arg_3_0._makeshift_lobby_data.reserved_profiles = arg_3_0.lobby_client:lobby_data("reserved_profiles")

	if Managers.mechanism:mechanism_setting("check_matchmaking_hero_availability") then
		local var_3_0 = arg_3_0._matchmaking_manager
		local var_3_1, var_3_2, var_3_3 = arg_3_0:_current_hero()

		fassert(var_3_1, "no hero index? this is wrong")

		if var_3_0:hero_available_in_lobby_data(var_3_1, arg_3_0._makeshift_lobby_data, arg_3_0._reserved_party_id) and not Application.user_setting("always_ask_hero_when_joining") then
			arg_3_0._selected_hero_name = var_3_2

			arg_3_0:_request_profile_from_host(var_3_1, var_3_3)
		else
			arg_3_0._show_popup = true
		end

		local var_3_4 = true

		Managers.chat:add_local_system_message(1, Localize("matchmaking_status_aquiring_profiles"), var_3_4)
	else
		WwiseWorld.trigger_event(arg_3_0._wwise_world, "menu_wind_countdown_warning")
		arg_3_0:_set_state_to_start_lobby()
	end

	if Managers.mechanism:mechanism_setting("sync_backend_id") then
		arg_3_0:_sync_backend_id()
	end

	arg_3_0._update_lobby_data_timer = 0
end

function MatchmakingStateJoinGame.on_exit(arg_4_0)
	local var_4_0 = Managers.ui

	if var_4_0:get_active_popup("profile_picker") then
		var_4_0:close_popup("profile_picker")
	end
end

function MatchmakingStateJoinGame.update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.ui:get_active_popup("profile_picker")

	if var_5_0 then
		local var_5_1 = var_5_0:query_result()

		if var_5_1 then
			arg_5_0._profile_picker_shown = false
			arg_5_0._selected_hero_at_t = arg_5_2

			if arg_5_0:_handle_popup_result(var_5_1, arg_5_2) then
				arg_5_0._matchmaking_manager:cancel_matchmaking()

				return nil
			end
		end

		arg_5_0:_update_lobby_data(arg_5_1, arg_5_2)
	elseif arg_5_0._profile_picker_shown then
		arg_5_0._profile_picker_shown = false

		arg_5_0._matchmaking_manager:cancel_matchmaking()

		return nil
	end

	if not Managers.state.network then
		arg_5_0._matchmaking_manager:cancel_matchmaking()

		return nil
	end

	if arg_5_0._exit_to_search_game then
		mm_printf_force("Search was aborted")

		local var_5_2 = arg_5_0._matchmaking_manager

		var_5_2:add_broken_lobby_client(arg_5_0.lobby_client, arg_5_2, false)

		if arg_5_0.lobby_client then
			arg_5_0.lobby_client:destroy()

			arg_5_0.lobby_client = nil
		end

		arg_5_0.state_context.lobby_client = nil
		arg_5_0.state_context.join_lobby_data = nil

		arg_5_0._matchmaking_manager:reset_joining()

		if arg_5_0.state_context.join_by_lobby_browser then
			mm_printf_force("Abort from lobby browser or invite")
			var_5_2:cancel_join_lobby("cancelled")

			return MatchmakingStateIdle, arg_5_0.state_context
		elseif Managers.account:user_detached() then
			mm_printf_force("User detached - > Cancel Matchmaking")
			var_5_2:cancel_matchmaking()

			return MatchmakingStateIdle, arg_5_0.state_context
		else
			mm_printf_force("Abort for other reason")

			local var_5_3 = Managers.state.network:lobby()

			if var_5_3 then
				Managers.party:set_leader(var_5_3:lobby_host())
			end

			local var_5_4 = arg_5_0.search_config

			if var_5_4 and var_5_4.dedicated_server and var_5_4.join_method == "party" then
				if var_5_4.aws then
					return MatchmakingStateFlexmatchHost, arg_5_0.state_context
				end

				return MatchmakingStateReserveLobby, arg_5_0.state_context
			else
				return MatchmakingStateSearchGame, arg_5_0.state_context
			end
		end
	end

	if arg_5_0._show_popup then
		arg_5_0._makeshift_lobby_data.reserved_profiles = arg_5_0.lobby_client:lobby_data("reserved_profiles")

		local var_5_5 = Managers.backend
		local var_5_6 = var_5_5:is_waiting_for_user_input()
		local var_5_7 = var_5_5:get_interface("items"):num_current_item_server_requests() ~= 0

		if not var_5_6 and not var_5_7 then
			arg_5_0:_spawn_join_popup(arg_5_1, arg_5_2)
		end
	end

	if Managers.state.network.is_server and not Managers.state.network.network_server:are_all_peers_ingame(nil, true) then
		Managers.simple_popup:queue_popup(Localize("player_join_block_exit_game"), Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
		arg_5_0._matchmaking_manager:cancel_matchmaking()

		return nil
	end

	return nil
end

function MatchmakingStateJoinGame._update_lobby_data(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._update_lobby_data_timer = arg_6_0._update_lobby_data_timer - arg_6_1

	if arg_6_0._update_lobby_data_timer < 0 then
		arg_6_0._update_lobby_data_timer = 0.5

		local var_6_0 = arg_6_0._makeshift_lobby_data
		local var_6_1 = arg_6_0.lobby_client
		local var_6_2 = var_6_1:lobby_data("selected_mission_id")

		if var_6_0.selected_mission_id ~= var_6_2 then
			var_6_0.selected_mission_id = var_6_2
		end

		local var_6_3 = var_6_1:lobby_data("difficulty")

		var_6_0.difficulty_tweak = var_6_1:lobby_data("difficulty_tweak")

		if var_6_0.difficulty ~= var_6_3 then
			var_6_0.difficulty = var_6_3

			if arg_6_0._popup_profile_picker then
				arg_6_0._popup_profile_picker:set_difficulty(var_6_3)
			end
		end
	end
end

function MatchmakingStateJoinGame._handle_popup_result(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0
	local var_7_1 = false

	if arg_7_1.accepted then
		mm_printf_force("Popup accepted")

		local var_7_2 = arg_7_1.selected_hero_name
		local var_7_3 = FindProfileIndex(var_7_2)

		arg_7_0._selected_hero_name = var_7_2
		arg_7_0._selected_career_name = arg_7_1.selected_career_name

		local var_7_4 = career_index_from_name(var_7_3, arg_7_0._selected_career_name)

		arg_7_0:_request_profile_from_host(var_7_3, var_7_4)
	else
		mm_printf_force("Popup cancelled")

		local var_7_5 = Managers.player:local_player(1)
		local var_7_6 = arg_7_1.reason or "timed_out"

		if not arg_7_0._selected_hero_at_t or not (arg_7_0._selected_hero_at_t - arg_7_0._hero_popup_at_t) then
			local var_7_7 = 0
		end

		local var_7_8 = false

		arg_7_0._matchmaking_manager:add_broken_lobby_client(arg_7_0.lobby_client, arg_7_2, var_7_8)

		if var_7_6 == "cancelled" then
			var_7_1 = true
		else
			arg_7_0._exit_to_search_game = true
		end

		local var_7_9 = "matchmaking_status_character_select_" .. var_7_6

		arg_7_0._matchmaking_manager:send_system_chat_message(var_7_9)
	end

	Managers.ui:close_popup("profile_picker")

	return var_7_1
end

function MatchmakingStateJoinGame.get_transition(arg_8_0)
	if arg_8_0._join_lobby_data and arg_8_0._next_transition_state then
		local var_8_0 = arg_8_0._join_lobby_data.join_method or arg_8_0.search_config and arg_8_0.search_config.join_method
		local var_8_1 = {
			lobby_client = arg_8_0.lobby_client,
			join_method = var_8_0
		}

		return arg_8_0._next_transition_state, var_8_1
	end
end

function MatchmakingStateJoinGame._spawn_join_popup(arg_9_0, arg_9_1, arg_9_2)
	if Managers.popup:has_popup() then
		arg_9_0:_update_popup_timeout(arg_9_1, arg_9_2)

		return
	end

	local var_9_0 = arg_9_0.state_context
	local var_9_1 = Network.peer_id()
	local var_9_2 = Managers.player:player_from_peer_id(var_9_1)
	local var_9_3 = var_9_2:profile_index()
	local var_9_4 = var_9_2:career_index()
	local var_9_5 = MatchmakingSettings.JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL
	local var_9_6 = arg_9_0.state_context.join_by_lobby_browser
	local var_9_7 = arg_9_0.lobby_client:lobby_data("difficulty")
	local var_9_8

	if arg_9_0._denied_reason == "profile_locked" then
		var_9_8 = var_9_3
	end

	Managers.ui:open_popup("profile_picker", var_9_3, var_9_4, var_9_5, var_9_6, var_9_7, arg_9_0.lobby_client, arg_9_0._reserved_party_id, var_9_8)

	arg_9_0._profile_picker_shown = true
	arg_9_0._hero_popup_at_t = Managers.time:time("game")
	arg_9_0._show_popup = false
	arg_9_0._popup_auto_cancel_time = nil
end

function MatchmakingStateJoinGame._update_popup_timeout(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._popup_auto_cancel_time = arg_10_0._popup_auto_cancel_time or arg_10_2 + MatchmakingSettings.JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL

	if arg_10_2 > arg_10_0._popup_auto_cancel_time then
		local var_10_0 = "matchmaking_status_character_select_timed_out"

		arg_10_0._matchmaking_manager:send_system_chat_message(var_10_0)
		arg_10_0._matchmaking_manager:cancel_matchmaking()
	end
end

function MatchmakingStateJoinGame._request_profile_from_host(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.lobby_client
	local var_11_1 = var_11_0:lobby_host()

	arg_11_0._matchmaking_manager.selected_profile_index = arg_11_1

	RPC.rpc_matchmaking_request_profile(PEER_ID_TO_CHANNEL[var_11_1], arg_11_1, arg_11_2)

	local var_11_2 = var_11_1

	if rawget(_G, "Steam") and GameSettingsDevelopment.network_mode == "steam" then
		var_11_2 = Steam.user_name(var_11_1)
	end

	arg_11_0._matchmaking_manager.debug.text = "requesting_profile"
	arg_11_0._matchmaking_manager.debug.state = "hosted by: " .. (var_11_2 or "unknown")
	arg_11_0._matchmaking_manager.debug.level = var_11_0:lobby_data("selected_mission_id")
end

function MatchmakingStateJoinGame.rpc_matchmaking_request_profile_reply(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = NetworkLookup.request_profile_replies[arg_12_3]
	local var_12_1 = arg_12_0._selected_hero_name
	local var_12_2 = FindProfileIndex(var_12_1)

	arg_12_0._denied_reason = nil

	fassert(arg_12_2 == var_12_2 or var_12_0 == "previous_profile_accepted", "wrong profile in rpc_matchmaking_request_profile_reply")

	if var_12_0 == "profile_accepted" then
		arg_12_0._matchmaking_manager.debug.text = var_12_0
		arg_12_0._denied_reason = var_12_0

		if arg_12_0._selected_career_name then
			local var_12_3 = Managers.backend:get_interface("hero_attributes")
			local var_12_4 = career_index_from_name(var_12_2, arg_12_0._selected_career_name)

			var_12_3:set(var_12_1, "career", var_12_4)
		end

		arg_12_0:_set_state_to_start_lobby()
	elseif var_12_0 == "previous_profile_accepted" then
		arg_12_0._matchmaking_manager.debug.text = var_12_0
		arg_12_0._denied_reason = var_12_0

		arg_12_0:_set_state_to_start_lobby()
	elseif var_12_0 == "profile_declined" then
		arg_12_0._denied_reason = var_12_0
		arg_12_0._matchmaking_manager.debug.text = var_12_0
		arg_12_0._show_popup = true
	elseif var_12_0 == "profile_locked" then
		arg_12_0._denied_reason = var_12_0
		arg_12_0._matchmaking_manager.debug.text = var_12_0
		arg_12_0._show_popup = true
	end
end

function MatchmakingStateJoinGame._current_hero(arg_13_0)
	local var_13_0 = Network.peer_id()
	local var_13_1 = Managers.player:player_from_peer_id(var_13_0)
	local var_13_2 = var_13_1:profile_index()
	local var_13_3 = var_13_1:career_index()
	local var_13_4 = SPProfiles[var_13_2].display_name

	return var_13_2, var_13_4, var_13_3
end

function MatchmakingStateJoinGame._level_started(arg_14_0)
	local var_14_0 = arg_14_0.lobby_client
	local var_14_1 = var_14_0:lobby_data("selected_mission_id")
	local var_14_2 = var_14_0:lobby_data("mission_id")

	return var_14_1 == var_14_2, var_14_2
end

function MatchmakingStateJoinGame.loading_context(arg_15_0)
	return arg_15_0._matchmaking_loading_context
end

function MatchmakingStateJoinGame.rpc_matchmaking_join_game(arg_16_0, arg_16_1)
	mm_printf_force("Transition from join due to rpc_matchmaking_join_game")
	arg_16_0:_set_state_to_start_lobby()
	Managers.mechanism:network_handler():get_match_handler():send_rpc_down("rpc_matchmaking_join_game")
end

function MatchmakingStateJoinGame._sync_backend_id(arg_17_0)
	local var_17_0 = arg_17_0.lobby_client:lobby_host()
	local var_17_1 = Managers.backend:player_id()

	if var_17_1 and arg_17_0._network_transmit then
		arg_17_0._network_transmit:send_rpc("rpc_set_peer_backend_id", var_17_0, var_17_1)
	end
end

function MatchmakingStateJoinGame.active_lobby(arg_18_0)
	return arg_18_0.lobby_client
end

function MatchmakingStateJoinGame._set_state_to_start_lobby(arg_19_0)
	arg_19_0._matchmaking_manager:send_system_chat_message("matchmaking_status_joining_game")

	arg_19_0._matchmaking_manager.debug.text = "starting_game"
	arg_19_0._next_transition_state = "start_lobby"
end
