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

StateTitleScreenInitNetwork.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateTitleScreenInitNetwork")

	self._params = arg_1_1
	self._world = self._params.world
	self._viewport = self._params.viewport

	self:_init_network()
end

StateTitleScreenInitNetwork._init_network = function (self)
	-- function 2
	local parameter = Development.parameter("auto_join")

	Development.set_parameter("auto_join", nil)

	local flag = true

	LobbySetup.setup_network_options(flag)

	local network_options = LobbySetup.network_options()

	if not (not rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized()) then
		require("scripts/network/lobby_xbox_live")
		LobbyInternal.init_client(network_options)
	end

	self._network_state = "_create_session"
end

StateTitleScreenInitNetwork.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self[self._network_state] then
		self[self._network_state](self, arg_3_1, arg_3_2)
	end

	Network.update(arg_3_1, self._network_event_delegate.event_table)
	Managers.backend:update(arg_3_1, arg_3_2)

	return self:_next_state()
end

StateTitleScreenInitNetwork._create_session = function (self)
	-- function 4
	local parameter = Development.parameter("auto_join")
	local parameter_2 = Development.parameter("unique_server_name")
	local loading_context = self.parent.parent.loading_context

	self._network_event_delegate = NetworkEventDelegate:new()

	Managers.level_transition_handler:register_rpcs(self._network_event_delegate)
	Managers.mechanism:register_rpcs(self._network_event_delegate)
	Managers.party:register_rpcs(self._network_event_delegate)

	local network_options = LobbySetup.network_options()

	if not loading_context.join_lobby_data then
		Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (join_lobby_data)", network_options, loading_context.join_lobby_data)

		loading_context.join_lobby_data = nil
		self._network_state = "_update_lobby_client"
	elseif not parameter then
		if not Managers.package:is_loading("resource_packages/inventory", "global") then
			Managers.package:load("resource_packages/inventory", "global")
		end

		if not Managers.package:is_loading("resource_packages/careers", "global") then
			Managers.package:load("resource_packages/careers", "global")
		end

		assert(parameter_2, "No unique_server_name in %%appdata%%\\Roaming\\Fatshark\\Bulldozer\\user_settings.config")

		self._lobby_finder = LobbyFinder:new(network_options, nil, true)
		self._network_state = "_update_lobby_join"
	else
		assert(not loading_context.profile_synchronizer)
		assert(not loading_context.network_server)
		Managers.lobby:make_lobby(LobbyHost, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (_create_session)", network_options)

		self._network_state = "_creating_session_host"
	end
end

StateTitleScreenInitNetwork._creating_session_host = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

	get_lobby:update(arg_5_1)

	local state = get_lobby.state

	if state == LobbyState.JOINED then
		self._network_state = "_join_session"
	elseif state == LobbyState.FAILED then
		self._network_state = "_error"
	end
end

StateTitleScreenInitNetwork._join_session = function (self, arg_6_1, arg_6_2)
	-- function 6
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

	get_lobby:update(arg_6_1)

	local default_level_key = Managers.mechanism:default_level_key()
	local level_transition_handler = Managers.level_transition_handler

	level_transition_handler:set_next_level(default_level_key)
	level_transition_handler:promote_next_level_data()
	level_transition_handler:load_current_level()

	local loading_context = self.parent.parent.loading_context

	self._network_server = NetworkServer:new(Managers.player, get_lobby, nil)

	local network_transmit = loading_context.network_transmit

	network_transmit = network_transmit or NetworkTransmit:new(true, self._network_server.server_peer_id)
	self._network_transmit = network_transmit

	self._network_transmit:set_network_event_delegate(self._network_event_delegate)
	self._network_server:register_rpcs(self._network_event_delegate, self._network_transmit)
	self._network_server:server_join()

	self._profile_synchronizer = self._network_server.profile_synchronizer
	loading_context.network_transmit = self._network_transmit

	require("scripts/game_state/state_ingame")

	self._wanted_game_state = StateIngame
	self._network_state = "_update_host_lobby"
end

StateTitleScreenInitNetwork._update_host_lobby = function (self, arg_7_1, arg_7_2)
	-- function 7
	Managers.level_transition_handler:update()
	self._network_transmit:transmit_local_rpcs()

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not query_lobby then
		query_lobby:update(arg_7_1)

		if query_lobby.state ~= LobbyState.FAILED or self._popup_id or not self._wanted_game_state then
			local str = "failure_start_no_lan"

			self._popup_id = Managers.popup:queue_popup(Localize(str), Localize("popup_error_topic"), "quit", Localize("menu_quit"))
		end
	end

	self._network_server:update(arg_7_1, arg_7_2)
end

StateTitleScreenInitNetwork._update_lobby_client = function (self, arg_8_1, arg_8_2)
	-- function 8
	Managers.level_transition_handler:update()

	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

	get_lobby:update(arg_8_1)

	local state = get_lobby.state

	if not (state ~= LobbyState.JOINED or self._sent_joined) then
		local lobby_host = get_lobby:lobby_host()

		if lobby_host ~= "0" then
			self._network_client = NetworkClient:new(lobby_host, nil, nil, nil, get_lobby)
			self._network_transmit = NetworkTransmit:new(false, self._network_client.server_peer_id)

			self._network_transmit:set_network_event_delegate(self._network_event_delegate)
			self._network_client:register_rpcs(self._network_event_delegate, self._network_transmit)

			self._profile_synchronizer = self._network_client.profile_synchronizer
			self._sent_joined = true
		end
	end

	if not (state ~= LobbyState.FAILED or self._popup_id) then
		self._popup_id = Managers.popup:queue_popup(Localize("failure_start_join_server"), Localize("popup_error_topic"), "restart_as_server", Localize("menu_accept"))
	end

	if not self._network_client then
		self._network_client:update(arg_8_1, arg_8_2)

		if not (self._network_client.state ~= NetworkClientStates.denied_enter_game or self._popup_id) then
			local str = "failure_start_join_server"
			local fail_reason = self._network_client.fail_reason

			if not fail_reason then
				str = str .. "_" .. fail_reason
			end

			self._popup_id = Managers.popup:queue_popup(Localize(str), Localize("popup_error_topic"), "restart_as_server", Localize("menu_accept"))
		end
	end
end

StateTitleScreenInitNetwork._update_lobby_join = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _lobby_finder = self._lobby_finder

	_lobby_finder:update(arg_9_1)

	local lobbies = _lobby_finder:lobbies()

	for i, v in ipairs(lobbies) do
		local flag = v.unique_server_name == Development.parameter("unique_server_name")

		if not v.valid and not flag then
			local network_options = LobbySetup.network_options()
			local level_transition_handler = Managers.level_transition_handler

			level_transition_handler:set_next_level(v.level_key)
			level_transition_handler:promote_next_level_data()
			level_transition_handler:load_current_level()
			Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (_update_lobby_join)", network_options, v)

			self._lobby_finder = nil
			self._network_state = "_update_lobby_client"

			break
		end
	end
end

StateTitleScreenInitNetwork._error = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

StateTitleScreenInitNetwork._next_state = function (self)
	-- function 11
	if not (not self:_packages_loaded() and self._wanted_game_state) then
		return
	end

	if not self._debug_setup then
		self._debug_setup = true

		Debug.setup(self._world, "init_network_ui")
	end

	if not self._popup_id then
		local query_result = Managers.popup:query_result(self._popup_id)

		if query_result == "quit" then
			Boot.quit_game = true
		elseif query_result == "restart_as_server" then
			self._popup_id = nil

			if not self._lobby_finder then
				self._lobby_finder:destroy()

				self._lobby_finder = nil
			end

			if not Managers.lobby:query_lobby("matchmaking_session_lobby") then
				Managers.lobby:destroy_lobby("matchmaking_session_lobby")
				Managers.account:set_current_lobby(nil)
			end

			if not self._network_server then
				self._network_server:destroy()

				self._network_server = nil
			elseif not self._network_client then
				self._network_client:destroy()

				self._network_client = nil
			end

			self._profile_synchronizer = nil

			local network_options = LobbySetup.network_options()

			Managers.lobby:make_lobby(LobbyHost, "matchmaking_session_lobby", "StateTitleScreenInitNetwork (_next_state)", network_options)

			self._network_state = "_creating_session_host"
		elseif query_result == "continue" then
			self._popup_id = nil
		end

		return
	end

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not ((self._lobby_finder or not query_lobby) and query_lobby.state == LobbyState.JOINED) then
		return
	end

	if not ((self._sent_joined or not query_lobby or not query_lobby.is_host) and query_lobby.state ~= query_lobby.FAILED) then
		return
	end

	if not (not self._network_client and self._network_client:can_enter_game()) then
		return
	elseif not (not self._network_server and self._network_server:can_enter_game()) then
		return
	end

	if not Managers.backend:profiles_loaded() then
		return
	end

	self.parent.state = self._wanted_game_state
	self._wanted_game_state = nil
end

StateTitleScreenInitNetwork.on_exit = function (self, arg_12_1)
	-- function 12
	Managers.level_transition_handler:unregister_rpcs()

	if not Managers.mechanism then
		Managers.mechanism:unregister_rpcs()
	end

	if not Managers.party then
		Managers.party:unregister_rpcs()
	end

	if not arg_12_1 then
		if not Managers.party:has_party_lobby() then
			local steal_lobby = Managers.party:steal_lobby()

			if type(steal_lobby) ~= "table" then
				LobbyInternal.leave_lobby(steal_lobby)
			end
		end

		if not self._lobby_finder then
			self._lobby_finder:destroy()

			self._lobby_finder = nil
		end

		if not Managers.lobby:query_lobby("matchmaking_session_lobby") then
			Managers.lobby:destroy_lobby("matchmaking_session_lobby")
			Managers.account:set_current_lobby(nil)
		end

		if not self._network_server then
			self._network_server:destroy()

			self._network_server = nil
		elseif not self._network_client then
			self._network_client:destroy()

			self._network_client = nil
		end

		if not rawget(_G, "LobbyInternal") then
			LobbyInternal.shutdown_client()
		end

		self.parent.loading_context.network_transmit = nil

		if not self._network_transmit then
			self._network_transmit:destroy()

			self._network_transmit = nil
		end
	else
		local tbl = {
			network_transmit = self._network_transmit
		}
		local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

		if not get_lobby.is_host then
			local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
			local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

			get_stored_lobby_data = get_stored_lobby_data or {}
			get_stored_lobby_data.level_key = get_current_level_keys

			local unique_server_name = get_stored_lobby_data.unique_server_name

			unique_server_name = unique_server_name or LobbyAux.get_unique_server_name()
			get_stored_lobby_data.unique_server_name = unique_server_name

			local host = get_stored_lobby_data.host

			host = host or Network.peer_id()
			get_stored_lobby_data.host = host

			local num_players = get_stored_lobby_data.num_players

			num_players = num_players or 1
			get_stored_lobby_data.num_players = num_players
			get_stored_lobby_data.matchmaking = "false"

			get_lobby:set_lobby_data(get_stored_lobby_data)

			tbl.network_server = self._network_server

			self._network_server:unregister_rpcs()
		else
			tbl.network_client = self._network_client

			self._network_client:unregister_rpcs()
		end

		self.parent.parent.loading_context = tbl
	end

	self._profile_synchronizer = nil

	if not self._network_event_delegate then
		self._network_event_delegate:destroy()

		self._network_event_delegate = nil
	end
end

StateTitleScreenInitNetwork._packages_loaded = function (self)
	-- function 13
	local level_transition_handler = Managers.level_transition_handler

	if not level_transition_handler:all_packages_loaded() then
		if not (not self._network_server and self._has_sent_level_loaded) then
			self._has_sent_level_loaded = true

			local get_current_level_keys = level_transition_handler:get_current_level_keys()
			local var_13_2 = NetworkLookup.level_keys[get_current_level_keys]

			self._network_server.network_transmit:send_rpc("rpc_level_loaded", Network.peer_id(), var_13_2)
		end

		return (GlobalResources.update_loading())
	end

	return true
end
