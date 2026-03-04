-- chunkname: @scripts/game_state/loading_sub_states/win32/state_loading_running.lua

require("scripts/ui/views/loading_view")

StateLoadingRunning = class(StateLoadingRunning)
StateLoadingRunning.NAME = "StateLoadingRunning"

StateLoadingRunning.on_enter = function (arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateLoadingRunning")
	arg_1_0:_init_network()

	arg_1_0._loading_view = arg_1_1.loading_view
	arg_1_0._previous_session_error_headers_lookup = {
		host_left_game = "popup_notice_topic",
		kicked_by_server = "popup_notice_topic",
		afk_kick = "popup_notice_topic"
	}

	local var_1_0 = Managers.level_transition_handler:get_current_level_key()

	arg_1_0.parent:set_lobby_host_data(var_1_0)

	local var_1_1 = arg_1_0.parent.parent.loading_context

	if var_1_1.previous_session_error then
		local var_1_2 = var_1_1.previous_session_error

		var_1_1.previous_session_error = nil

		arg_1_0.parent:create_popup(var_1_2, arg_1_0._previous_session_error_headers_lookup[var_1_2] or "popup_notice_topic", "continue")
	end
end

StateLoadingRunning._init_network = function (arg_2_0)
	local var_2_0 = arg_2_0.parent.parent.loading_context

	if not arg_2_0.parent:has_registered_rpcs() then
		arg_2_0.parent:register_rpcs()
	end

	local var_2_1 = StateLoading.LoadoutResyncStates.WAIT_FOR_LEVEL_LOAD

	print("[StateLoadingRunning] Selecting loadout_resync_state...", var_2_0.join_lobby_data, var_2_0.join_server_data, var_2_0.start_lobby_data)

	if var_2_0.join_lobby_data or var_2_0.join_server_data then
		arg_2_0.parent:set_matchmaking(false)
		LobbySetup.setup_network_options()
		arg_2_0.parent:setup_join_lobby(nil, var_2_0.setup_voip)
		arg_2_0.parent:clear_network_loading_context()
		Managers.transition:show_icon_background()
	elseif var_2_0.start_lobby_data then
		arg_2_0.parent:set_matchmaking(true)
		arg_2_0.parent:clear_network_loading_context()

		local var_2_2 = var_2_0.start_lobby_data.lobby_client

		if arg_2_0.parent:setup_network_client(true, var_2_2) then
			local var_2_3 = Network.peer_id()
			local var_2_4 = var_2_2:lobby_host()
			local var_2_5 = false
			local var_2_6 = arg_2_0.parent._network_client

			arg_2_0.parent:setup_chat_manager(var_2_2, var_2_4, var_2_3, var_2_5)
			arg_2_0.parent:setup_deed_manager(var_2_2, var_2_4, var_2_3, var_2_5, var_2_6)
			arg_2_0.parent:setup_enemy_package_loader(var_2_2, var_2_4, var_2_3, var_2_6)
			arg_2_0.parent:setup_global_managers(var_2_2, var_2_4, var_2_3, var_2_5, var_2_6)
		end

		var_2_0.start_lobby_data = nil

		Managers.transition:show_icon_background()
	else
		arg_2_0._network_server = var_2_0.network_server
		arg_2_0._network_client = var_2_0.network_client

		if arg_2_0._network_server then
			arg_2_0.parent:setup_network_transmit(arg_2_0._network_server)
		elseif arg_2_0._network_client then
			arg_2_0._network_client:set_wait_for_state_loading(nil)
			arg_2_0.parent:setup_network_transmit(arg_2_0._network_client)
		end

		var_2_1 = StateLoading.LoadoutResyncStates.CHECK_RESYNC
	end

	if arg_2_0.parent:loadout_resync_state() == StateLoading.LoadoutResyncStates.IDLE then
		print("[StateLoadingRunning] loadout_resync_state IDLE ->", var_2_1)
		arg_2_0.parent:set_loadout_resync_state(var_2_1)
	else
		print("[StateLoadingRunning] Ignoring selected loadout_resync_state, wasn't IDLE")
	end
end

StateLoadingRunning.update = function (arg_3_0, arg_3_1)
	if IS_XB1 and arg_3_0.parent:waiting_for_cleanup() then
		return
	end

	local var_3_0 = Managers.level_transition_handler

	if not LEVEL_EDITOR_TEST and (arg_3_0.parent._network_server and var_3_0:needs_level_load() or arg_3_0.parent._network_client and arg_3_0.parent._network_client:is_fully_synced() and var_3_0:needs_level_load()) then
		if not arg_3_0.parent:loading_view_setup_done() then
			local var_3_1 = var_3_0:get_current_level_key()

			arg_3_0.parent:setup_loading_view(var_3_1)
		end

		if not arg_3_0.parent:menu_assets_setup_done() then
			arg_3_0.parent:setup_menu_assets()
		end

		arg_3_0.parent:load_current_level()
	end

	if script_data.honduras_demo and not arg_3_0.parent:loading_view_setup_done() then
		local var_3_2 = var_3_0:get_current_level_key()

		arg_3_0.parent:setup_loading_view(var_3_2)
	end

	if arg_3_0.parent:has_joined() and not Managers.load_time:has_lobby() then
		Managers.load_time:set_lobby(arg_3_0.parent:get_lobby())
	end
end

StateLoadingRunning.on_exit = function (arg_4_0, arg_4_1)
	return
end
