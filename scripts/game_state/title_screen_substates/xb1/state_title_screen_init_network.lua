-- chunkname: @scripts/game_state/title_screen_substates/xb1/state_title_screen_init_network.lua

require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/game_state/components/level_transition_handler")
require("scripts/network/network_event_delegate")
require("scripts/network/network_server")
require("scripts/network/network_client")
require("scripts/network/network_transmit")

StateTitleScreenInitNetwork = class(StateTitleScreenInitNetwork)
StateTitleScreenInitNetwork.NAME = "StateTitleScreenInitNetwork"

function StateTitleScreenInitNetwork.on_enter(arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateTitleScreenInitNetwork")

	arg_1_0._params = arg_1_1
	arg_1_0._world = arg_1_0._params.world
	arg_1_0._viewport = arg_1_0._params.viewport

	arg_1_0:_init_network()
end

function StateTitleScreenInitNetwork._init_network(arg_2_0)
	local var_2_0 = Development.parameter("auto_join")

	Development.set_parameter("auto_join", nil)

	local var_2_1 = true

	LobbySetup.setup_network_options(var_2_1)

	local var_2_2 = LobbySetup.network_options()

	if not rawget(_G, "LobbyInternal") or not LobbyInternal.network_initialized() then
		require("scripts/network/lobby_xbox_live")
		LobbyInternal.init_client(var_2_2)
	end

	arg_2_0._network_state = "_create_session"
end

function StateTitleScreenInitNetwork.update(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0[arg_3_0._network_state] then
		arg_3_0[arg_3_0._network_state](arg_3_0, arg_3_1, arg_3_2)
	end

	Network.update(arg_3_1, arg_3_0._network_event_delegate.event_table)
	Managers.backend:update(arg_3_1, arg_3_2)

	return arg_3_0:_next_state()
end

function StateTitleScreenInitNetwork._create_session(arg_4_0)
	local var_4_0 = Development.parameter("auto_join")
	local var_4_1 = Development.parameter("unique_server_name")
	local var_4_2 = arg_4_0.parent.parent.loading_context

	arg_4_0._network_event_delegate = NetworkEventDelegate:new()

	Managers.level_transition_handler:register_rpcs(arg_4_0._network_event_delegate)
	Managers.mechanism:register_rpcs(arg_4_0._network_event_delegate)
	Managers.party:register_rpcs(arg_4_0._network_event_delegate)

	local var_4_3 = LobbySetup.network_options()

	if var_4_2.join_lobby_data then
		Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (join_lobby_data)", var_4_3, var_4_2.join_lobby_data)

		var_4_2.join_lobby_data = nil
		arg_4_0._network_state = "_update_lobby_client"
	elseif var_4_0 then
		if Managers.package:is_loading("resource_packages/inventory", "global") then
			Managers.package:load("resource_packages/inventory", "global")
		end

		if Managers.package:is_loading("resource_packages/careers", "global") then
			Managers.package:load("resource_packages/careers", "global")
		end

		assert(var_4_1, "No unique_server_name in %%appdata%%\\Roaming\\Fatshark\\Bulldozer\\user_settings.config")

		arg_4_0._lobby_finder = LobbyFinder:new(var_4_3, nil, true)
		arg_4_0._network_state = "_update_lobby_join"
	else
		assert(not var_4_2.profile_synchronizer)
		assert(not var_4_2.network_server)
		Managers.lobby:make_lobby(LobbyHost, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (_create_session)", var_4_3)

		arg_4_0._network_state = "_creating_session_host"
	end
end

function StateTitleScreenInitNetwork._creating_session_host(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")

	var_5_0:update(arg_5_1)

	local var_5_1 = var_5_0.state

	if var_5_1 == LobbyState.JOINED then
		arg_5_0._network_state = "_join_session"
	elseif var_5_1 == LobbyState.FAILED then
		arg_5_0._network_state = "_error"
	end
end

function StateTitleScreenInitNetwork._join_session(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")

	var_6_0:update(arg_6_1)

	local var_6_1 = Managers.mechanism:default_level_key()
	local var_6_2 = Managers.level_transition_handler

	var_6_2:set_next_level(var_6_1)
	var_6_2:promote_next_level_data()
	var_6_2:load_current_level()

	local var_6_3 = arg_6_0.parent.parent.loading_context

	arg_6_0._network_server = NetworkServer:new(Managers.player, var_6_0, nil)
	arg_6_0._network_transmit = var_6_3.network_transmit or NetworkTransmit:new(true, arg_6_0._network_server.server_peer_id)

	arg_6_0._network_transmit:set_network_event_delegate(arg_6_0._network_event_delegate)
	arg_6_0._network_server:register_rpcs(arg_6_0._network_event_delegate, arg_6_0._network_transmit)
	arg_6_0._network_server:server_join()

	arg_6_0._profile_synchronizer = arg_6_0._network_server.profile_synchronizer
	var_6_3.network_transmit = arg_6_0._network_transmit

	require("scripts/game_state/state_ingame")

	arg_6_0._wanted_game_state = StateIngame
	arg_6_0._network_state = "_update_host_lobby"
end

function StateTitleScreenInitNetwork._update_host_lobby(arg_7_0, arg_7_1, arg_7_2)
	Managers.level_transition_handler:update()
	arg_7_0._network_transmit:transmit_local_rpcs()

	local var_7_0 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if var_7_0 then
		var_7_0:update(arg_7_1)

		if var_7_0.state == LobbyState.FAILED and not arg_7_0._popup_id and arg_7_0._wanted_game_state then
			local var_7_1 = "failure_start_no_lan"

			arg_7_0._popup_id = Managers.popup:queue_popup(Localize(var_7_1), Localize("popup_error_topic"), "quit", Localize("menu_quit"))
		end
	end

	arg_7_0._network_server:update(arg_7_1, arg_7_2)
end

function StateTitleScreenInitNetwork._update_lobby_client(arg_8_0, arg_8_1, arg_8_2)
	Managers.level_transition_handler:update()

	local var_8_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")

	var_8_0:update(arg_8_1)

	local var_8_1 = var_8_0.state

	if var_8_1 == LobbyState.JOINED and not arg_8_0._sent_joined then
		local var_8_2 = var_8_0:lobby_host()

		if var_8_2 ~= "0" then
			arg_8_0._network_client = NetworkClient:new(var_8_2, nil, nil, nil, var_8_0)
			arg_8_0._network_transmit = NetworkTransmit:new(false, arg_8_0._network_client.server_peer_id)

			arg_8_0._network_transmit:set_network_event_delegate(arg_8_0._network_event_delegate)
			arg_8_0._network_client:register_rpcs(arg_8_0._network_event_delegate, arg_8_0._network_transmit)

			arg_8_0._profile_synchronizer = arg_8_0._network_client.profile_synchronizer
			arg_8_0._sent_joined = true
		end
	end

	if var_8_1 == LobbyState.FAILED and not arg_8_0._popup_id then
		arg_8_0._popup_id = Managers.popup:queue_popup(Localize("failure_start_join_server"), Localize("popup_error_topic"), "restart_as_server", Localize("menu_accept"))
	end

	if arg_8_0._network_client then
		arg_8_0._network_client:update(arg_8_1, arg_8_2)

		if arg_8_0._network_client.state == NetworkClientStates.denied_enter_game and not arg_8_0._popup_id then
			local var_8_3 = "failure_start_join_server"
			local var_8_4 = arg_8_0._network_client.fail_reason

			if var_8_4 then
				var_8_3 = var_8_3 .. "_" .. var_8_4
			end

			arg_8_0._popup_id = Managers.popup:queue_popup(Localize(var_8_3), Localize("popup_error_topic"), "restart_as_server", Localize("menu_accept"))
		end
	end
end

function StateTitleScreenInitNetwork._update_lobby_join(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._lobby_finder

	var_9_0:update(arg_9_1)

	local var_9_1 = var_9_0:lobbies()

	for iter_9_0, iter_9_1 in ipairs(var_9_1) do
		local var_9_2 = iter_9_1.unique_server_name == Development.parameter("unique_server_name")

		if iter_9_1.valid and var_9_2 then
			local var_9_3 = LobbySetup.network_options()
			local var_9_4 = Managers.level_transition_handler

			var_9_4:set_next_level(iter_9_1.level_key)
			var_9_4:promote_next_level_data()
			var_9_4:load_current_level()
			Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (_update_lobby_join)", var_9_3, iter_9_1)

			arg_9_0._lobby_finder = nil
			arg_9_0._network_state = "_update_lobby_client"

			break
		end
	end
end

function StateTitleScreenInitNetwork._error(arg_10_0, arg_10_1, arg_10_2)
	return
end

function StateTitleScreenInitNetwork._next_state(arg_11_0)
	if not arg_11_0:_packages_loaded() or not arg_11_0._wanted_game_state then
		return
	end

	if not arg_11_0._debug_setup then
		arg_11_0._debug_setup = true

		Debug.setup(arg_11_0._world, "init_network_ui")
	end

	if arg_11_0._popup_id then
		local var_11_0 = Managers.popup:query_result(arg_11_0._popup_id)

		if var_11_0 == "quit" then
			Boot.quit_game = true
		elseif var_11_0 == "restart_as_server" then
			arg_11_0._popup_id = nil

			if arg_11_0._lobby_finder then
				arg_11_0._lobby_finder:destroy()

				arg_11_0._lobby_finder = nil
			end

			if Managers.lobby:query_lobby("matchmaking_session_lobby") then
				Managers.lobby:destroy_lobby("matchmaking_session_lobby")
				Managers.account:set_current_lobby(nil)
			end

			if arg_11_0._network_server then
				arg_11_0._network_server:destroy()

				arg_11_0._network_server = nil
			elseif arg_11_0._network_client then
				arg_11_0._network_client:destroy()

				arg_11_0._network_client = nil
			end

			arg_11_0._profile_synchronizer = nil

			local var_11_1 = LobbySetup.network_options()

			Managers.lobby:make_lobby(LobbyHost, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (_next_state)", var_11_1)

			arg_11_0._network_state = "_creating_session_host"
		elseif var_11_0 == "continue" then
			arg_11_0._popup_id = nil
		end

		return
	end

	local var_11_2 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if arg_11_0._lobby_finder or var_11_2 and var_11_2.state ~= LobbyState.JOINED then
		return
	end

	if not arg_11_0._sent_joined and not var_11_2 or var_11_2.is_host and var_11_2.state == var_11_2.FAILED then
		return
	end

	if arg_11_0._network_client and not arg_11_0._network_client:can_enter_game() then
		return
	elseif arg_11_0._network_server and not arg_11_0._network_server:can_enter_game() then
		return
	end

	if not Managers.backend:profiles_loaded() then
		return
	end

	arg_11_0.parent.state = arg_11_0._wanted_game_state
	arg_11_0._wanted_game_state = nil
end

function StateTitleScreenInitNetwork.on_exit(arg_12_0, arg_12_1)
	Managers.level_transition_handler:unregister_rpcs()

	if Managers.mechanism then
		Managers.mechanism:unregister_rpcs()
	end

	if Managers.party then
		Managers.party:unregister_rpcs()
	end

	if arg_12_1 then
		if Managers.party:has_party_lobby() then
			local var_12_0 = Managers.party:steal_lobby()

			if type(var_12_0) ~= "table" then
				LobbyInternal.leave_lobby(var_12_0)
			end
		end

		if arg_12_0._lobby_finder then
			arg_12_0._lobby_finder:destroy()

			arg_12_0._lobby_finder = nil
		end

		if Managers.lobby:query_lobby("matchmaking_session_lobby") then
			Managers.lobby:destroy_lobby("matchmaking_session_lobby")
			Managers.account:set_current_lobby(nil)
		end

		if arg_12_0._network_server then
			arg_12_0._network_server:destroy()

			arg_12_0._network_server = nil
		elseif arg_12_0._network_client then
			arg_12_0._network_client:destroy()

			arg_12_0._network_client = nil
		end

		if rawget(_G, "LobbyInternal") then
			LobbyInternal.shutdown_client()
		end

		arg_12_0.parent.loading_context.network_transmit = nil

		if arg_12_0._network_transmit then
			arg_12_0._network_transmit:destroy()

			arg_12_0._network_transmit = nil
		end
	else
		local var_12_1 = {
			network_transmit = arg_12_0._network_transmit
		}
		local var_12_2 = Managers.lobby:get_lobby("matchmaking_session_lobby")

		if var_12_2.is_host then
			local var_12_3

			var_12_3.level_key, var_12_3 = Managers.level_transition_handler:get_current_level_keys(), var_12_2:get_stored_lobby_data() or {}
			var_12_3.unique_server_name = var_12_3.unique_server_name or LobbyAux.get_unique_server_name()
			var_12_3.host = var_12_3.host or Network.peer_id()
			var_12_3.num_players = var_12_3.num_players or 1
			var_12_3.matchmaking = "false"

			var_12_2:set_lobby_data(var_12_3)

			var_12_1.network_server = arg_12_0._network_server

			arg_12_0._network_server:unregister_rpcs()
		else
			var_12_1.network_client = arg_12_0._network_client

			arg_12_0._network_client:unregister_rpcs()
		end

		arg_12_0.parent.parent.loading_context = var_12_1
	end

	arg_12_0._profile_synchronizer = nil

	if arg_12_0._network_event_delegate then
		arg_12_0._network_event_delegate:destroy()

		arg_12_0._network_event_delegate = nil
	end
end

function StateTitleScreenInitNetwork._packages_loaded(arg_13_0)
	local var_13_0 = Managers.level_transition_handler

	if var_13_0:all_packages_loaded() then
		if arg_13_0._network_server and not arg_13_0._has_sent_level_loaded then
			arg_13_0._has_sent_level_loaded = true

			local var_13_1 = var_13_0:get_current_level_keys()
			local var_13_2 = NetworkLookup.level_keys[var_13_1]

			arg_13_0._network_server.network_transmit:send_rpc("rpc_level_loaded", Network.peer_id(), var_13_2)
		end

		return (GlobalResources.update_loading())
	end

	return true
end
