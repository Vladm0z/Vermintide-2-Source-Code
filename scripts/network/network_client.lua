-- chunkname: @scripts/network/network_client.lua

require("scripts/game_state/components/profile_synchronizer")
require("scripts/game_state/components/network_state")
require("scripts/utils/profile_requester")
require("scripts/network/network_match_handler")

NetworkClientStates = table.enum("connecting", "connected", "loading", "loaded", "waiting_enter_game", "game_started", "is_ingame", "denied_enter_game", "lost_connection_to_host", "eac_match_failed")
NetworkClient = class(NetworkClient)

local count = #PROFILES_BY_AFFILIATION.heroes
local num = 15

script_data.network_debug_connections = true

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.network_debug_connections then
		printf("[NetworkClient] " .. arg_1_0, ...)
	end
end

NetworkClient.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self:set_state(NetworkClientStates.connecting)

	self.server_peer_id = arg_2_1
	self.my_peer_id = Network.peer_id()
	PEER_ID_TO_CHANNEL[self.my_peer_id] = 0
	CHANNEL_TO_PEER_ID[0] = self.my_peer_id
	self._network_state = NetworkState:new(false, self, arg_2_1, self.my_peer_id)

	Managers.level_transition_handler:register_network_state(self._network_state)

	local flag = false

	self.profile_synchronizer = ProfileSynchronizer:new(false, arg_2_5, self._network_state)
	self._profile_requester = ProfileRequester:new(false, nil, self.profile_synchronizer)

	local var_2_1 = FindProfileIndex(Development.parameter("wanted_profile"))

	if not (var_2_1 or arg_2_2) then
		-- Nothing
	end

	::label_2_0::

	var_2_1 = SaveData.wanted_profile_index
	var_2_1 = var_2_1 or 1

	::label_2_1::

	self.wanted_profile_index = var_2_1

	local var_2_2 = tonumber(Development.parameter("wanted_party_index"))

	var_2_2 = var_2_2 or arg_2_3
	self.wanted_party_index = var_2_2

	if not self.wanted_profile_index then
		local var_2_3 = SPProfiles[self.wanted_profile_index]

		if not (not var_2_3 and var_2_3.affiliation ~= "dark_pact") then
			self.wanted_party_index = 2
		end
	end

	Managers.mechanism:set_profile_synchronizer(self.profile_synchronizer)

	local var_2_4 = SPProfiles[self.wanted_profile_index]

	if not var_2_4 then
		local display_name = var_2_4.display_name
		local get_interface = Managers.backend:get_interface("hero_attributes")
		local parameter = Development.parameter("wanted_career_index")

		if not parameter then
			parameter = get_interface:get(display_name, "career")
			parameter = parameter or 1
		end

		self.wanted_career_index = parameter
	else
		self.wanted_career_index = 0
	end

	self.lobby_client = arg_2_5

	local display_name_2

	if not var_2_4 then
		display_name_2 = var_2_4.display_name

		if not display_name_2 then
			-- Nothing
		end
	end

	display_name_2 = "no profile wanted"

	::label_2_2::

	fn("init - wanted_profile_index, %s, %s", self.wanted_profile_index, display_name_2)

	if not arg_2_4 then
		fn("SENDING rpc_clear_peer_state to %s", self.server_peer_id)

		local var_2_9 = PEER_ID_TO_CHANNEL[self.server_peer_id]

		RPC.rpc_clear_peer_state(var_2_9)
	end

	if not arg_2_6 then
		self.voip = arg_2_6
	else
		self.voip = Voip:new(flag, arg_2_5)
	end

	self.connecting_timeout = 0
	self._match_handler = NetworkMatchHandler:new(self, false, self.my_peer_id, self.server_peer_id, arg_2_5)

	Managers.mechanism:set_network_client(self)
end

NetworkClient.destroy = function (self)
	-- function 3
	if not Managers.eac:eac_ready_locally() then
		Managers.eac:after_leave()
	end

	self._match_handler:destroy()
	Managers.mechanism:set_network_client(nil)
	Managers.level_transition_handler:deregister_network_state()

	if not self._network_event_delegate then
		self:unregister_rpcs()
	end

	self._network_state:destroy()
	self.voip:destroy()

	self.voip = nil

	self._profile_requester:destroy()

	self._profile_requester = nil

	self.profile_synchronizer:destroy()

	self.profile_synchronizer = nil
	self.lobby_client = nil

	GarbageLeakDetector.register_object(self, "Network Client")
end

NetworkClient.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = arg_4_1
	local register = arg_4_1.register
	local var_4_2 = self
	local str = "rpc_loading_synced"
	local str_2 = "rpc_notify_in_post_game"
	local str_3 = "rpc_game_started"
	local str_4 = "rpc_connection_failed"
	local str_5 = "rpc_notify_connected"
	local flag

	flag = not IS_XB1 and "rpc_set_migration_host_xbox" and "rpc_set_migration_host"

	register(var_4_0, var_4_2, str, str_2, str_3, str_4, str_5, flag, "rpc_client_update_lobby_data", "rpc_client_connection_state", "rpc_slot_reservation_request_peers")

	self._network_event_delegate = arg_4_1

	self._network_state:register_rpcs(arg_4_1, arg_4_2)
	self.profile_synchronizer:register_rpcs(arg_4_1, arg_4_2)
	self._profile_requester:register_rpcs(arg_4_1, arg_4_2)
	self.voip:register_rpcs(arg_4_1, arg_4_2)
	self._match_handler:register_rpcs(arg_4_1, arg_4_2)
	self._match_handler:sync_data_up()
end

NetworkClient.unregister_rpcs = function (self)
	-- function 5
	self.voip:unregister_rpcs()
	self._profile_requester:unregister_rpcs()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil

	self.profile_synchronizer:unregister_network_events()
	self._network_state:unregister_network_events()
	self._match_handler:unregister_rpcs()
end

NetworkClient.rpc_connection_failed = function (self, arg_6_1, arg_6_2)
	-- function 6
	self.fail_reason = NetworkLookup.connection_fails[arg_6_2]

	fn("rpc_connection_failed due to %s", self.fail_reason)
	self:set_state(NetworkClientStates.denied_enter_game)
	fn("Connection to server failed with reason %s", self.fail_reason)
end

NetworkClient.rpc_notify_connected = function (self, arg_7_1)
	-- function 7
	if not self._notification_sent then
		local str = "peer_to_peer"

		if not self.lobby_client:is_dedicated_server() then
			str = "client_server"
		end

		Managers.eac:before_join(str)

		local var_7_1 = PEER_ID_TO_CHANNEL[self.server_peer_id]

		Managers.eac:set_host(self.server_peer_id)

		local rpc_notify_lobby_joined = RPC.rpc_notify_lobby_joined
		local var_7_3 = var_7_1
		local wanted_profile_index = self.wanted_profile_index
		local wanted_career_index = self.wanted_career_index
		local wanted_party_index = self.wanted_party_index

		wanted_party_index = wanted_party_index or 0

		local user_setting = Application.user_setting("clan_tag")

		user_setting = user_setting or "0"

		local account_id = Managers.account:account_id()

		account_id = account_id or "0"

		rpc_notify_lobby_joined(var_7_3, wanted_profile_index, wanted_career_index, wanted_party_index, user_setting, account_id)

		self._notification_sent = true

		self:set_state(NetworkClientStates.connected)
		self._network_state:full_sync()

		if not self.loaded_level_name then
			local loaded_level_name = self.loaded_level_name

			RPC.rpc_level_loaded(self.channel_id, NetworkLookup.level_keys[loaded_level_name])

			self.loaded_level_name = nil
		end
	end
end

NetworkClient.is_network_state_fully_synced_for_peer = function (self, arg_8_1)
	-- function 8
	if not Managers.mechanism:is_peer_fully_synced(arg_8_1) then
		return false
	end

	return self._network_state:is_peer_fully_synced(arg_8_1)
end

NetworkClient.is_fully_synced = function (self)
	-- function 9
	local my_peer_id = self.my_peer_id

	if not Managers.mechanism:is_peer_fully_synced(my_peer_id) then
		return false
	end

	return self._network_state:is_peer_fully_synced(my_peer_id)
end

NetworkClient.rpc_notify_in_post_game = function (self, arg_10_1, arg_10_2)
	-- function 10
	if self._is_in_post_game ~= arg_10_2 then
		self._is_in_post_game = arg_10_2

		local var_10_0 = PEER_ID_TO_CHANNEL[self.server_peer_id]

		RPC.rpc_post_game_notified(var_10_0, arg_10_2)
	end
end

NetworkClient.is_in_post_game = function (self)
	-- function 11
	return self._is_in_post_game
end

NetworkClient.rpc_client_connection_state = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = NetworkLookup.connection_states[arg_12_3]

	printf("rpc_client_connection_state Channel: %d, PeerID: %s, Reason: %s", arg_12_1, arg_12_2, var_12_0)

	if var_12_0 == "connected" then
		NetworkUtils.announce_chat_peer_joined(arg_12_2, self.lobby_client)
	elseif var_12_0 == "disconnected" then
		NetworkUtils.announce_chat_peer_left(arg_12_2, self.lobby_client)
	end
end

NetworkClient.rpc_loading_synced = function (self, arg_13_1)
	-- function 13
	fn("rpc_loading_synced. State: %q", self.state)

	if self.state ~= NetworkClientStates.game_started then
		self:set_state(NetworkClientStates.waiting_enter_game)
	else
		self._rpc_loading_synced = true
	end
end

NetworkClient.rpc_set_migration_host = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not arg_14_3 then
		local player_from_peer_id = Managers.player:player_from_peer_id(arg_14_2)
		local name

		if not player_from_peer_id then
			name = player_from_peer_id:name()

			if not name then
				-- Nothing
			end
		end

		name = tostring(arg_14_2)

		::label_14_0::

		self.host_to_migrate_to = {
			peer_id = arg_14_2,
			name = name
		}
	else
		self.host_to_migrate_to = nil
	end
end

NetworkClient.rpc_set_migration_host_xbox = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not arg_15_3 then
		local player_from_peer_id = Managers.player:player_from_peer_id(arg_15_2)
		local name

		if not player_from_peer_id then
			name = player_from_peer_id:name()

			if not name then
				-- Nothing
			end
		end

		name = tostring(arg_15_2)

		::label_15_0::

		self.host_to_migrate_to = {
			peer_id = arg_15_2,
			name = name,
			session_id = arg_15_4,
			session_template_name = arg_15_5
		}
	else
		self.host_to_migrate_to = nil
	end
end

NetworkClient.rpc_client_update_lobby_data = function (self, arg_16_1)
	-- function 16
	self.lobby_client:force_update_lobby_data()
end

NetworkClient.set_state = function (self, arg_17_1)
	-- function 17
	fn("New State %s (old state %s)", arg_17_1, tostring(self.state))

	self.state = arg_17_1
end

NetworkClient.has_bad_state = function (self)
	-- function 18
	local state = self.state

	return state == NetworkClientStates.denied_enter_game or state == NetworkClientStates.lost_connection_to_host or state == NetworkClientStates.eac_match_failed, state
end

NetworkClient.on_game_entered = function (self)
	-- function 19
	self:set_state(NetworkClientStates.is_ingame)

	local var_19_0 = PEER_ID_TO_CHANNEL[self.server_peer_id]

	Managers.account:update_presence()
	RPC.rpc_is_ingame(var_19_0)
end

NetworkClient.request_profile = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	self._profile_requester:request_profile(self.my_peer_id, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
end

NetworkClient.profile_requester = function (self)
	-- function 21
	return self._profile_requester
end

NetworkClient.rpc_game_started = function (self, arg_22_1, arg_22_2)
	-- function 22
	Application.error(string.format("SETTING ROUND ID %s", tostring(arg_22_2)))

	if not IS_XB1 then
		Managers.account:set_round_id(arg_22_2)
	end

	fn("rpc_game_started")
	self:set_state(NetworkClientStates.game_started)
	Managers.state.event:trigger("game_started")
end

NetworkClient.on_level_loaded = function (self, arg_23_1)
	-- function 23
	fn("on_level_loaded %s", arg_23_1)

	if self.state ~= NetworkClientStates.connecting then
		local var_23_0 = PEER_ID_TO_CHANNEL[self.server_peer_id]

		if not var_23_0 then
			RPC.rpc_level_loaded(var_23_0, NetworkLookup.level_keys[arg_23_1])
		end
	else
		self.loaded_level_name = arg_23_1
	end
end

NetworkClient._update_connections = function (self)
	-- function 24
	local var_24_0 = PEER_ID_TO_CHANNEL[self.server_peer_id]

	if not var_24_0 then
		return
	end

	local channel_state, var_24_2 = Network.channel_state(var_24_0)

	if channel_state ~= self._server_channel_state then
		if channel_state == "disconnected" then
			self.fail_reason = var_24_2

			printf("broken_connection to %s", self.server_peer_id)
			Crashify.print_exception("Disconnected", "broken connection to server: " .. tostring(var_24_2))
			self:set_state(NetworkClientStates.lost_connection_to_host)
		end

		self._server_channel_state = channel_state
	end
end

NetworkClient.update = function (self, arg_25_1, arg_25_2)
	-- function 25
	self._profile_requester:update(arg_25_1)
	self.profile_synchronizer:update()
	self:_update_connections()

	if self.wait_for_state_loading or self.state ~= NetworkClientStates.loading or not Managers.eac:eac_ready_locally() then
		local check_host, var_25_1 = Managers.eac:check_host()
		local level_transition_handler = Managers.level_transition_handler

		if not check_host and not var_25_1 and not level_transition_handler:all_packages_loaded() then
			fn("All level packages loaded!")

			if not self._rpc_loading_synced then
				self:set_state(NetworkClientStates.waiting_enter_game)

				self._rpc_loading_synced = false
			else
				self:set_state(NetworkClientStates.loaded)
			end

			self:on_level_loaded(level_transition_handler:get_current_level_keys())
		end
	end

	if self.state == NetworkClientStates.connecting then
		self.connecting_timeout = self.connecting_timeout + arg_25_1

		if self.connecting_timeout > num then
			self.connecting_timeout = 0
			self.fail_reason = "broken_connection"

			fn("connection timeout leading to broken_connection")
			self:set_state(NetworkClientStates.denied_enter_game)
		end
	end

	self:_update_eac_match()
	self.voip:update(arg_25_1, arg_25_2)
end

NetworkClient._update_eac_match = function (self)
	-- function 26
	if not (self:has_bad_state() or self._notification_sent) then
		return
	end

	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby and not query_lobby:is_dedicated_server() then
		return
	end

	if not Managers.eac:eac_ready_locally() then
		local check_host, var_26_2 = Managers.eac:check_host()

		if not var_26_2 then
			printf("eac mismatch leading to eac_authorize_failed")

			self.fail_reason = "eac_authorize_failed"

			self:set_state(NetworkClientStates.eac_match_failed)
		end
	end
end

NetworkClient.can_enter_game = function (self)
	-- function 27
	return self.state == NetworkClientStates.waiting_enter_game
end

NetworkClient.is_ingame = function (self)
	-- function 28
	return self.state == NetworkClientStates.is_ingame or self.state == NetworkClientStates.game_started
end

NetworkClient.set_wait_for_state_loading = function (self, arg_29_1)
	-- function 29
	self.wait_for_state_loading = arg_29_1
end

NetworkClient.is_peer_ingame = function (self, arg_30_1)
	-- function 30
	return self._network_state:is_peer_ingame(arg_30_1)
end

NetworkClient.get_peers = function (self)
	-- function 31
	local get_peers

	if not self._network_state then
		get_peers = self._network_state:get_peers()

		if not get_peers then
			-- Nothing
		end
	end

	get_peers = {}

	::label_31_0::

	return get_peers
end

NetworkClient.get_side_order_state = function (self)
	-- function 32
	local _network_state = self._network_state

	_network_state = not _network_state and self._network_state:get_side_order_state()

	return _network_state
end

NetworkClient.get_network_state = function (self)
	-- function 33
	return self._network_state
end

NetworkClient.is_peer_hot_join_synced = function (self, arg_34_1)
	-- function 34
	return self._network_state:is_peer_hot_join_synced(arg_34_1)
end

NetworkClient.rpc_slot_reservation_request_peers = function (self, arg_35_1)
	-- function 35
	local my_peer_id = self.my_peer_id

	printf("[NetworkClient] Game host requested peers to reserve. Responding with (%s)", my_peer_id)
	RPC.rpc_provide_slot_reservation_info(arg_35_1, {
		my_peer_id
	}, self.server_peer_id)
end

NetworkClient.get_match_handler = function (self)
	-- function 36
	return self._match_handler
end

NetworkClient.get_session_breed_map = function (self)
	-- function 37
	return self._network_state:get_session_breed_map()
end

NetworkClient.get_loaded_session_breeds = function (self, arg_38_1)
	-- function 38
	return self._network_state:get_loaded_session_breed_map(arg_38_1)
end

NetworkClient.get_own_loaded_session_breed_map = function (self)
	-- function 39
	return self._network_state:get_own_loaded_session_breed_map()
end

NetworkClient.set_own_loaded_session_breeds = function (self, arg_40_1)
	-- function 40
	self._network_state:set_own_loaded_session_breeds(arg_40_1)
end

NetworkClient.get_startup_breeds = function (self)
	-- function 41
	return self._network_state:get_startup_breeds()
end

NetworkClient.get_session_pickup_map = function (self)
	-- function 42
	return self._network_state:get_session_pickup_map()
end

NetworkClient.get_own_loaded_session_pickup_map = function (self)
	-- function 43
	return self._network_state:get_own_loaded_session_pickup_map()
end

NetworkClient.set_own_loaded_session_pickups = function (self, arg_44_1)
	-- function 44
	self._network_state:set_own_loaded_session_pickups(arg_44_1)
end

NetworkClient.get_loaded_session_pickups = function (self, arg_45_1)
	-- function 45
	return self._network_state:get_loaded_session_pickup_map(arg_45_1)
end

NetworkClient.get_initialized_mutator_map = function (self)
	-- function 46
	return self._network_state:get_initialized_mutator_map()
end

NetworkClient.get_game_mode_event_data = function (self)
	-- function 47
	return self._network_state:get_game_mode_event_data()
end

NetworkClient.has_unlocked_dlc = function (self, arg_48_1, arg_48_2)
	-- function 48
	return self._network_state:get_unlocked_dlcs_set(arg_48_1)[arg_48_2]
end

NetworkClient.get_loaded_mutator_map = function (self, arg_49_1)
	-- function 49
	return self._network_state:get_loaded_mutator_map(arg_49_1)
end

NetworkClient.get_own_loaded_mutator_map = function (self)
	-- function 50
	return self._network_state:get_own_loaded_mutator_map()
end

NetworkClient.set_own_loaded_mutator_map = function (self, arg_51_1)
	-- function 51
	self._network_state:set_own_loaded_mutator_map(arg_51_1)
end

NetworkClient.state_revision = function (self)
	-- function 52
	return self._network_state:get_revision()
end
