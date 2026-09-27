-- chunkname: @scripts/network/network_server.lua

require("scripts/network/peer_state_machine")
require("scripts/network/voip")
require("scripts/game_state/components/profile_synchronizer")
require("scripts/game_state/components/network_state")
require("scripts/utils/profile_requester")
require("scripts/settings/profiles/sp_profiles")
require("scripts/network/network_match_handler")

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")
local PEER_ID_TO_CHANNEL = PEER_ID_TO_CHANNEL

PEER_ID_TO_CHANNEL = PEER_ID_TO_CHANNEL or {}
PEER_ID_TO_CHANNEL = PEER_ID_TO_CHANNEL

local CHANNEL_TO_PEER_ID = CHANNEL_TO_PEER_ID

CHANNEL_TO_PEER_ID = CHANNEL_TO_PEER_ID or {}
CHANNEL_TO_PEER_ID = CHANNEL_TO_PEER_ID

local count = #PROFILES_BY_AFFILIATION.heroes
local num = 5

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.network_debug_connections then
		printf("[NetworkServer] " .. arg_1_0, ...)
	end
end

local PeerState = PeerState

PeerState = PeerState or CreateStrictEnumTable("Broken", "Connecting", "Connected", "Disconnected", "Loading", "LoadingLevelComplete", "WaitingForEnter", "WaitingForGameObjectSync", "WaitingForSpawnPlayer", "InGame", "InPostGame")
PeerState = PeerState
NetworkServer = class(NetworkServer)

NetworkServer.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local peer_id = Network.peer_id()

	PEER_ID_TO_CHANNEL[peer_id] = 0
	CHANNEL_TO_PEER_ID[0] = peer_id
	self.my_peer_id = peer_id
	self.server_peer_id = peer_id
	self.wanted_party_index = tonumber(Development.parameter("wanted_party_index"))
	self.is_server = true

	local parameter = Development.parameter("wanted_profile")

	if not parameter then
		local var_2_2 = FindProfileIndex(parameter)

		arg_2_3 = var_2_2

		if SPProfiles[var_2_2].affiliation == "dark_pact" then
			self.wanted_party_index = 2
		end
	end

	self.peers_added_to_gamesession = {}
	self._peers_completed_game_object_sync = {}
	self.player_manager = arg_2_1
	self.lobby_host = arg_2_2
	self.peer_state_machines = {}
	self.kicked_peers_disconnect_timer = {}
	self._game_server_manager = arg_2_4
	self._connections = {}
	self._joined_peers = {}
	self._peer_initialized_mechanisms = {}
	self._shared_states = {}
	self._network_state = NetworkState:new(true, self, peer_id, peer_id)

	self._network_state:set_peer_hot_join_synced(peer_id, true)
	Managers.level_transition_handler:register_network_state(self._network_state)

	local flag = true

	self.profile_synchronizer = ProfileSynchronizer:new(flag, arg_2_2, self._network_state)
	self._profile_requester = ProfileRequester:new(flag, self, self.profile_synchronizer)

	Managers.mechanism:set_profile_synchronizer(self.profile_synchronizer)

	self.voip = Voip:new(flag, arg_2_2)

	if not IS_XB1 then
		self._host_migration_session_id = Application.guid()
	end

	if not DEDICATED_SERVER then
		if not arg_2_3 then
			-- Nothing
		end

		::label_2_0::

		local wanted_profile_index = SaveData.wanted_profile_index

		wanted_profile_index = wanted_profile_index or 1

		::label_2_1::

		self.wanted_profile_index = wanted_profile_index

		local var_2_5 = SPProfiles[self.wanted_profile_index]

		if not var_2_5 then
			local display_name = var_2_5.display_name
			local get_interface = Managers.backend:get_interface("hero_attributes")
			local get = get_interface:get(display_name, "career")

			get = get or 1

			local get_2 = get_interface:get(display_name, "experience")

			get_2 = get_2 or 0

			local get_level = ExperienceSettings.get_level(get_2)
			local var_2_11 = var_2_5.careers[get]

			if not (not var_2_11 and var_2_11:is_unlocked_function(display_name, get_level)) then
				get = 1

				get_interface:set(display_name, "career", get)
			end

			self.wanted_career_index = get
		end
	end

	local var_2_12

	if not DEDICATED_SERVER then
		var_2_12 = self.lobby_host:server_name()
	elseif not rawget(_G, "Steam") then
		var_2_12 = Steam.user_name()
	else
		var_2_12 = "lan"
	end

	Managers.eac:server_create(var_2_12)

	local DEDICATED_SERVER = DEDICATED_SERVER

	DEDICATED_SERVER = not DEDICATED_SERVER and rawget(_G, "GameliftServer") ~= nil
	self._using_gamelift = DEDICATED_SERVER

	if not DEDICATED_SERVER then
		if not self._using_gamelift then
			print("yes, gamelift is process_ready")
			GameliftServer.process_ready()
		end

		local get_stored_lobby_data = self.lobby_host:get_stored_lobby_data()

		get_stored_lobby_data.eac_authorized = "trusted"

		self.lobby_host:set_lobby_data(get_stored_lobby_data)
	end

	self._match_handler = NetworkMatchHandler:new(self, true, peer_id, peer_id, arg_2_2)

	Managers.mechanism:set_network_server(self)
end

NetworkServer.server_join = function (self)
	-- function 3
	print(string.format("### Created peer state machine for %s", self.my_peer_id))

	local my_peer_id = self.my_peer_id

	self.peer_state_machines[my_peer_id] = PeerStateMachine.create(self, my_peer_id)

	self._match_handler:server_created(my_peer_id)
end

NetworkServer.num_active_peers = function (self)
	-- function 4
	local num = 0

	for k, v in pairs(self.peer_state_machines) do
		local current_state = v.current_state

		if not (current_state == PeerStates.Disconnecting or current_state ~= PeerStates.Disconnected) then
			num = num + 1
		end
	end

	return num
end

NetworkServer.active_peers = function (self)
	-- function 5
	local tbl = {}

	for k, v in pairs(self.peer_state_machines) do
		local current_state = v.current_state

		if not (current_state == PeerStates.Disconnecting or current_state ~= PeerStates.Disconnected) then
			tbl[#tbl + 1] = k
		end
	end

	return tbl
end

NetworkServer.num_joining_peers = function (self)
	-- function 6
	local num = 0

	for k, v in pairs(self.peer_state_machines) do
		if not (v.current_state == PeerStates.Connecting) then
			num = num + 1
		end
	end

	return num
end

NetworkServer.rpc_notify_connected = function (self, arg_7_1)
	-- function 7
	local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]

	if var_7_0 == self.my_peer_id then
		local var_7_1
		local var_7_2
		local get_level_key = self._network_state:get_level_key()
		local var_7_4 = LevelSettings[get_level_key]

		if not (not var_7_4 and var_7_4.game_mode ~= "tutorial") then
			var_7_1 = self.wanted_profile_index
		else
			local var_7_5 = FindProfileIndex(Development.parameter("wanted_profile"))

			if not var_7_5 then
				var_7_5 = self.wanted_profile_index
				var_7_5 = var_7_5 or SaveData.wanted_profile_index
			end

			local wanted_party_index = self.wanted_party_index

			wanted_party_index = wanted_party_index or 1
			var_7_1 = var_7_5 or self.profile_synchronizer:get_first_free_profile(wanted_party_index)
		end

		if var_7_1 == self.wanted_profile_index then
			var_7_2 = Development.parameter("wanted_career_index") or self.wanted_career_index
		else
			local display_name = SPProfiles[var_7_1].display_name

			var_7_2 = Managers.backend:get_interface("hero_attributes"):get(display_name, "career") or 1
		end

		self.peer_state_machines[var_7_0].rpc_notify_lobby_joined(var_7_1, var_7_2, self.wanted_party_index)
	end
end

NetworkServer.rpc_notify_in_post_game = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = CHANNEL_TO_PEER_ID[arg_8_1]

	if var_8_0 == self.my_peer_id then
		local var_8_1 = self.peer_state_machines[var_8_0]

		if not var_8_1:has_function("rpc_post_game_notified") then
			var_8_1.rpc_post_game_notified(arg_8_2)
		end
	end
end

NetworkServer.rpc_game_started = function (self, arg_9_1)
	-- function 9
	if CHANNEL_TO_PEER_ID[arg_9_1] == self.my_peer_id then
		Managers.state.event:trigger("game_started")
	end
end

NetworkServer.is_network_state_fully_synced_for_peer = function (self, arg_10_1)
	-- function 10
	if not Managers.mechanism:is_peer_fully_synced(arg_10_1) then
		return false
	end

	return self._network_state:is_peer_fully_synced(arg_10_1)
end

NetworkServer.is_fully_synced = function (self)
	-- function 11
	return self:is_network_state_fully_synced_for_peer(self.my_peer_id)
end

NetworkServer.are_profile_packages_fully_synced_for_peer = function (self, arg_12_1)
	-- function 12
	return self.profile_synchronizer:is_peer_all_synced(arg_12_1)
end

NetworkServer.peers_waiting_for_players = function (self)
	-- function 13
	local tbl = {}

	for k, v in pairs(self.peer_state_machines) do
		if v.current_state == PeerStates.WaitingForPlayers then
			tbl[k] = true
		end
	end

	return tbl
end

NetworkServer.can_enter_game = function (self)
	-- function 14
	return self.peer_state_machines[self.my_peer_id].current_state == PeerStates.WaitingForEnterGame
end

NetworkServer.enter_post_game = function (self)
	-- function 15
	fn("Entering post game")

	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		if v.current_state == PeerStates.InGame then
			v.state_data:change_state(PeerStates.InPostGame)
		end
	end
end

NetworkServer.is_in_post_game = function (self)
	-- function 16
	if not DEDICATED_SERVER then
		for k, v in pairs(self.peer_state_machines) do
			if v.current_state ~= PeerStates.InPostGame then
				return false
			end
		end

		return true
	else
		return self.peer_state_machines[self.my_peer_id].current_state == PeerStates.InPostGame
	end
end

NetworkServer.on_game_entered = function (self, arg_17_1)
	-- function 17
	fn("[NETWORK SERVER]: On Game Entered")

	self.game_session = Network.game_session()

	assert(self.game_session, "Unable to find game session in NetworkServer:on_game_entered.")

	self.game_network_manager = arg_17_1

	Managers.account:update_presence()

	if not DEDICATED_SERVER then
		self:set_peer_synced_game_objects(self.my_peer_id, true)
		self.peer_state_machines[self.my_peer_id].rpc_is_ingame()
	end
end

NetworkServer.request_profile = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	self._profile_requester:request_profile(Network.peer_id(), arg_18_1, arg_18_2, arg_18_3, arg_18_4)
end

NetworkServer.profile_requester = function (self)
	-- function 19
	return self._profile_requester
end

NetworkServer.rpc_is_ingame = function (self, arg_20_1)
	-- function 20
	local var_20_0 = CHANNEL_TO_PEER_ID[arg_20_1]
	local var_20_1 = self.peer_state_machines[var_20_0]

	if not (not var_20_1 and var_20_1:has_function("rpc_is_ingame")) then
		local state_name

		if not var_20_1 and not var_20_1.current_state then
			state_name = var_20_1.current_state.state_name

			if not state_name then
				-- Nothing
			end
		end

		state_name = "no_state"

		::label_20_0::

		printf("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_is_ingame", state_name)
		RPC.rpc_connection_failed(arg_20_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		var_20_1.rpc_is_ingame()
	end
end

NetworkServer.rpc_loading_synced = function (arg_21_0, arg_21_1)
	-- function 21
	return
end

NetworkServer.peer_spawned_player = function (self, arg_22_1)
	-- function 22
	fn("Peer %s spawned player.", arg_22_1)

	local var_22_0 = self.peer_state_machines[arg_22_1]

	if not var_22_0:has_function("spawned_player") then
		var_22_0.spawned_player()
	end
end

NetworkServer.peer_despawned_player = function (self, arg_23_1)
	-- function 23
	fn("Peer %s despawned player.", arg_23_1)

	local var_23_0 = self.peer_state_machines[arg_23_1]

	if not var_23_0:has_function("despawned_player") then
		var_23_0.despawned_player()
	end
end

NetworkServer.peer_respawn_player = function (self, arg_24_1)
	-- function 24
	fn("Peer %s respawn player.", arg_24_1)

	local var_24_0 = self.peer_state_machines[arg_24_1]

	if not var_24_0:has_function("respawn_player") then
		var_24_0.respawn_player()
	end
end

NetworkServer.rpc_client_respawn_player = function (self, arg_25_1)
	-- function 25
	local var_25_0 = CHANNEL_TO_PEER_ID[arg_25_1]

	self:peer_respawn_player(var_25_0)
end

NetworkServer.destroy = function (self)
	-- function 26
	Managers.level_transition_handler:deregister_network_state()
	self._match_handler:destroy()
	Managers.mechanism:set_network_server(nil)

	if not self.network_event_delegate then
		self:unregister_rpcs()
	end

	self._network_state:destroy()
	self.voip:destroy()

	self.voip = nil

	self._profile_requester:destroy()

	self._profile_requester = nil

	self.profile_synchronizer:destroy()

	self.profile_synchronizer = nil

	GarbageLeakDetector.register_object(self, "NetworkServer")

	for k, v in pairs(self._connections) do
		self:close_channel(k)
	end

	Managers.eac:server_destroy()

	if self._gui ~= nil then
		World.destroy_gui(Application.debug_world(), self._gui)

		self._gui = nil
	end
end

NetworkServer.register_rpcs = function (self, arg_27_1, arg_27_2)
	-- function 27
	arg_27_1:register(self, "rpc_notify_lobby_joined", "rpc_post_game_notified", "rpc_want_to_spawn_player", "rpc_level_load_started", "rpc_level_loaded", "rpc_game_started", "rpc_is_ingame", "game_object_sync_done", "rpc_notify_connected", "rpc_loading_synced", "rpc_clear_peer_state", "rpc_notify_in_post_game", "rpc_client_respawn_player", "rpc_provide_slot_reservation_info", "rpc_slot_reservation_request_peers", "rpc_slot_reservation_request_party_change")
	arg_27_1:register_with_return(self, "approve_channel")

	self.network_event_delegate = arg_27_1

	self._network_state:register_rpcs(arg_27_1, arg_27_2)
	self._network_state:full_sync()
	self.profile_synchronizer:register_rpcs(arg_27_1, arg_27_2)
	self._profile_requester:register_rpcs(arg_27_1, arg_27_2)

	self.network_transmit = arg_27_2

	self.voip:register_rpcs(arg_27_1, arg_27_2)
	self._match_handler:register_rpcs(arg_27_1, arg_27_2)
end

NetworkServer.on_level_exit = function (self)
	-- function 28
	table.clear(self._peers_completed_game_object_sync)

	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		local current_state = v.current_state

		if not (current_state == PeerStates.Connecting or current_state == PeerStates.Disconnecting or current_state == PeerStates.Disconnected) then
			v.state_data:change_state(PeerStates.Loading)
		end
	end

	table.clear(self.peers_added_to_gamesession)
	self:unregister_rpcs()

	self.game_session = nil
end

NetworkServer.unregister_rpcs = function (self)
	-- function 29
	self.voip:unregister_rpcs()
	self._profile_requester:unregister_rpcs()

	if not self.network_event_delegate then
		self.network_event_delegate:unregister(self)

		self.network_event_delegate = nil
	end

	self.profile_synchronizer:unregister_network_events()
	self._network_state:unregister_network_events()

	self.network_transmit = nil

	self._match_handler:unregister_rpcs()
end

NetworkServer.has_all_peers_loaded_packages = function (self)
	-- function 30
	return self.profile_synchronizer:all_synced()
end

NetworkServer.kick_peer = function (self, arg_31_1)
	-- function 31
	if not PEER_ID_TO_CHANNEL[arg_31_1] then
		return
	end

	self.network_transmit:send_rpc("rpc_kick_peer", arg_31_1)

	self.kicked_peers_disconnect_timer[arg_31_1] = num
end

NetworkServer.update_disconnect_kicked_peers_by_time = function (self, arg_32_1)
	-- function 32
	local kicked_peers_disconnect_timer = self.kicked_peers_disconnect_timer

	for k, v in pairs(kicked_peers_disconnect_timer) do
		if v == 0 then
			kicked_peers_disconnect_timer[k] = nil

			self:force_disconnect_client_by_peer_id(k)
		else
			kicked_peers_disconnect_timer[k] = math.max(v - arg_32_1, 0)
		end
	end
end

NetworkServer._update_lobby_data = function (self, arg_33_1, arg_33_2)
	-- function 33
	local lobby_host = self.lobby_host
	local get_stored_lobby_data = lobby_host:get_stored_lobby_data()

	if not get_stored_lobby_data then
		return
	end

	if not self.profile_synchronizer:poll_sync_lobby_data_required() then
		self._lobby_data_sync_requested = true
	end

	local mechanism_try_call, var_33_3 = Managers.mechanism:mechanism_try_call("get_slot_reservation_handler", Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	if not mechanism_try_call and not var_33_3:poll_sync_lobby_data_required() then
		self._lobby_data_sync_requested = true
	end

	if not self._lobby_data_sync_requested then
		return
	end

	self._lobby_data_sync_requested = false

	local tbl = {}
	local get_num_game_participating_parties = Managers.party:get_num_game_participating_parties()

	for i = 1, get_num_game_participating_parties do
		tbl[i] = {}
	end

	if not mechanism_try_call then
		local peers = var_33_3:peers()

		for j = 1, #peers do
			local var_33_7 = peers[j]
			local party_id_by_peer = var_33_3:party_id_by_peer(var_33_7)

			if not party_id_by_peer then
				local get_persistent_profile_index_reservation = self.profile_synchronizer:get_persistent_profile_index_reservation(var_33_7)

				table.insert(tbl[party_id_by_peer], {
					peer_id = var_33_7,
					profile_index = get_persistent_profile_index_reservation
				})
			end
		end
	else
		for k = 1, #tbl do
			for l = 1, 5 do
				local get_profile_index_reservation = self.profile_synchronizer:get_profile_index_reservation(k, l)

				if not get_profile_index_reservation then
					table.insert(tbl[k], {
						peer_id = get_profile_index_reservation,
						profile_index = l
					})
				end
			end
		end
	end

	local serialize_lobby_reservation_data = LobbyAux.serialize_lobby_reservation_data(tbl)

	if serialize_lobby_reservation_data ~= get_stored_lobby_data.reserved_profiles then
		get_stored_lobby_data.reserved_profiles = serialize_lobby_reservation_data

		lobby_host:set_lobby_data(get_stored_lobby_data)
	end
end

NetworkServer.disconnect_all_peers = function (self, arg_34_1)
	-- function 34
	local var_34_0 = NetworkLookup.connection_fails[arg_34_1]
	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		if not (k == Network.peer_id() or v.current_state == PeerStates.Disconnecting or v.current_state == PeerStates.Disconnected) then
			local var_34_2 = PEER_ID_TO_CHANNEL[k]

			RPC.rpc_connection_failed(var_34_2, var_34_0)
		end
	end
end

NetworkServer.disconnect_peer = function (self, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0 = NetworkLookup.connection_fails[arg_35_2]
	local current_state = self.peer_state_machines[arg_35_1].current_state

	if not (current_state == PeerStates.Disconnecting or current_state == PeerStates.Disconnected) then
		local var_35_2 = PEER_ID_TO_CHANNEL[arg_35_1]

		RPC.rpc_connection_failed(var_35_2, var_35_0)
	end
end

NetworkServer.force_disconnect_all_client_peers = function (self)
	-- function 36
	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		if not (not (k ~= self.my_peer_id) and v.current_state == PeerStates.Disconnecting or v.current_state == PeerStates.Disconnected) then
			v.state_data:change_state(PeerStates.Disconnecting)
		end
	end
end

NetworkServer.force_disconnect_client_by_peer_id = function (self, arg_37_1)
	-- function 37
	local peer_state_machines = self.peer_state_machines

	if not arg_37_1 and not peer_state_machines[arg_37_1] then
		local var_37_1 = peer_state_machines[arg_37_1]

		if not (not (arg_37_1 ~= self.my_peer_id) and var_37_1.current_state == PeerStates.Disconnecting or var_37_1.current_state == PeerStates.Disconnected) then
			var_37_1.state_data:change_state(PeerStates.Disconnecting)
		end
	end
end

NetworkServer.rpc_notify_lobby_joined = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
	-- function 38
	local var_38_0 = CHANNEL_TO_PEER_ID[arg_38_1]

	fn("Peer %s has sent rpc_notify_lobby_joined", tostring(var_38_0))

	local var_38_1 = self.peer_state_machines[var_38_0]

	if not (not var_38_1 and var_38_1:has_function("rpc_notify_lobby_joined")) then
		local state_name

		if not var_38_1 and not var_38_1.current_state then
			state_name = var_38_1.current_state.state_name

			if not state_name then
				-- Nothing
			end
		end

		state_name = "no_state"

		::label_38_0::

		fn("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_notify_lobby_joined", state_name)
		RPC.rpc_connection_failed(arg_38_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		if arg_38_4 == 0 then
			arg_38_4 = nil
		end

		var_38_1.rpc_notify_lobby_joined(arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
		Managers.level_transition_handler.enemy_package_loader:client_connected(var_38_0)
	end
end

NetworkServer.rpc_provide_slot_reservation_info = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local var_39_0 = CHANNEL_TO_PEER_ID[arg_39_1]

	fn("Peer %s has sent rpc_provide_slot_reservation_info", var_39_0)

	local var_39_1 = self.peer_state_machines[var_39_0]

	if not (not var_39_1 and var_39_1:has_function("rpc_provide_slot_reservation_info")) then
		local state_name

		if not var_39_1 and not var_39_1.current_state then
			state_name = var_39_1.current_state.state_name

			if not state_name then
				-- Nothing
			end
		end

		state_name = "no_state"

		::label_39_0::

		fn("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_provide_slot_reservation_info", state_name)
		RPC.rpc_connection_failed(arg_39_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		var_39_1.rpc_provide_slot_reservation_info(arg_39_2, arg_39_3)
	end
end

NetworkServer.rpc_post_game_notified = function (self, arg_40_1, arg_40_2)
	-- function 40
	local var_40_0 = CHANNEL_TO_PEER_ID[arg_40_1]

	fn("Peer %s has sent rpc_post_game_notified", tostring(var_40_0))

	local var_40_1 = self.peer_state_machines[var_40_0]

	if not (not var_40_1 and var_40_1:has_function("rpc_post_game_notified")) then
		local state_name

		if not var_40_1 and not var_40_1.current_state then
			state_name = var_40_1.current_state.state_name

			if not state_name then
				-- Nothing
			end
		end

		state_name = "no_state"

		::label_40_0::

		fn("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_post_game_notified", state_name)
		RPC.rpc_connection_failed(arg_40_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		var_40_1.rpc_post_game_notified(arg_40_2)
	end
end

NetworkServer.rpc_level_load_started = function (self, arg_41_1, arg_41_2)
	-- function 41
	print("### Received rpc_level_load_started")

	local var_41_0 = CHANNEL_TO_PEER_ID[arg_41_1]
	local var_41_1 = self.peer_state_machines[var_41_0]

	if not var_41_1 then
		print(string.format("#### Has state machine: %s, peer_id: %s, level_session_id: %s", var_41_1:has_function("rpc_level_load_started"), var_41_0, arg_41_2))

		if not var_41_1:has_function("rpc_level_load_started") then
			var_41_1.rpc_level_load_started(arg_41_2)
		end
	end
end

NetworkServer.rpc_level_loaded = function (self, arg_42_1, arg_42_2)
	-- function 42
	print("### Received rpc_level_loaded")

	local var_42_0 = CHANNEL_TO_PEER_ID[arg_42_1]
	local var_42_1 = self.peer_state_machines[var_42_0]

	if not var_42_1 then
		if var_42_0 ~= self.my_peer_id then
			fn("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_enter_game)", "rpc_level_loaded")
			RPC.rpc_connection_failed(arg_42_1, NetworkLookup.connection_fails.no_peer_data_on_enter_game)
		end
	else
		print(string.format("#### Has state machine: %s, peer_id: %s, level_id: %s", var_42_1:has_function("rpc_level_loaded"), var_42_0, arg_42_2))

		if not var_42_1:has_function("rpc_level_loaded") then
			var_42_1.rpc_level_loaded(arg_42_2)
		end
	end
end

NetworkServer.rpc_want_to_spawn_player = function (self, arg_43_1)
	-- function 43
	local var_43_0 = CHANNEL_TO_PEER_ID[arg_43_1]
	local var_43_1 = self.peer_state_machines[var_43_0]

	if not (not var_43_1 and var_43_1:has_function("rpc_want_to_spawn_player")) then
		fn("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_enter_game)", "rpc_want_to_spawn_player")
		RPC.rpc_connection_failed(arg_43_1, NetworkLookup.connection_fails.no_peer_data_on_enter_game)
	else
		var_43_1.rpc_want_to_spawn_player()
	end
end

NetworkServer.game_object_sync_done = function (self, arg_44_1)
	-- function 44
	fn("Game_object_sync_done for peer %s", arg_44_1)
	self:set_peer_synced_game_objects(arg_44_1, true)

	local var_44_0 = PEER_ID_TO_CHANNEL[arg_44_1]

	if not IS_XB1 then
		local _host_migration_session_id = self._host_migration_session_id
		local session_template_name = self.lobby_host:session_template_name()
		local rpc_set_migration_host_xbox = RPC.rpc_set_migration_host_xbox
		local var_44_4 = var_44_0
		local host_to_migrate_to = self.host_to_migrate_to

		host_to_migrate_to = host_to_migrate_to or ""

		local flag

		flag = not self.host_to_migrate_to and true and false

		rpc_set_migration_host_xbox(var_44_4, host_to_migrate_to, flag, _host_migration_session_id, session_template_name)
	else
		local rpc_set_migration_host = RPC.rpc_set_migration_host
		local var_44_8 = var_44_0
		local host_to_migrate_to_2 = self.host_to_migrate_to

		host_to_migrate_to_2 = host_to_migrate_to_2 or ""

		local flag_2

		flag_2 = not self.host_to_migrate_to and true and false

		rpc_set_migration_host(var_44_8, host_to_migrate_to_2, flag_2)
	end
end

NetworkServer.set_peer_hot_join_synced = function (self, arg_45_1, arg_45_2)
	-- function 45
	self._network_state:set_peer_hot_join_synced(arg_45_1, arg_45_2)
end

local tbl = {}

NetworkServer.hot_join_synced_peers = function (self)
	-- function 46
	table.clear(tbl)

	for k in pairs(self.peer_state_machines) do
		if not self._network_state:is_peer_hot_join_synced(k) then
			tbl[k] = true
		end
	end

	return tbl
end

NetworkServer.has_peer_synced_game_objects = function (self, arg_47_1)
	-- function 47
	return self._peers_completed_game_object_sync[arg_47_1]
end

NetworkServer.set_peer_synced_game_objects = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	arg_48_0._peers_completed_game_object_sync[arg_48_1] = arg_48_2 or nil
end

NetworkServer.approve_channel = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	print("GOT approve_channel", arg_49_1, arg_49_2, arg_49_3)

	if not PEER_ID_TO_CHANNEL[arg_49_2] then
		printf("Client with peer_id %s already has a channel %d", arg_49_2, PEER_ID_TO_CHANNEL[arg_49_2])

		return false
	end

	PEER_ID_TO_CHANNEL[arg_49_2] = arg_49_1
	CHANNEL_TO_PEER_ID[arg_49_1] = arg_49_2

	if not DEDICATED_SERVER then
		local game_mechanism = Managers.mechanism:game_mechanism()

		if not game_mechanism.get_slot_reservation_handler then
			game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):send_slot_update_to_clients()
		end

		Managers.party:sync_friend_party_for_player(arg_49_2)
	elseif not Managers.party:any_party_has_free_slots(1) then
		print("Game is full, denied access.")

		PEER_ID_TO_CHANNEL[arg_49_2] = nil
		CHANNEL_TO_PEER_ID[arg_49_1] = nil

		return false
	end

	local _joined_peers = self._joined_peers
	local _connections = self._connections
	local tbl = {
		channel_id = arg_49_1,
		peer_id = arg_49_2,
		channel_state = Network.channel_state(arg_49_1)
	}

	_connections[arg_49_2] = tbl
	_joined_peers[#_joined_peers + 1] = tbl

	printf("Client with peer_id %s got APPROVED by server", arg_49_2)

	return true
end

NetworkServer.close_channel = function (self, arg_50_1)
	-- function 50
	local var_50_0 = PEER_ID_TO_CHANNEL[arg_50_1]

	print("GOT close_channel", var_50_0, arg_50_1)

	if not var_50_0 then
		self.lobby_host:close_channel(var_50_0)

		CHANNEL_TO_PEER_ID[var_50_0] = nil
		PEER_ID_TO_CHANNEL[arg_50_1] = nil
		self._connections[arg_50_1] = nil
	else
		assert(self._connections[arg_50_1], "Connection was not properly cleaned up")
	end
end

NetworkServer._update_connections = function (self, arg_51_1)
	-- function 51
	for k, v in pairs(self._connections) do
		local channel_state, var_51_1 = Network.channel_state(v.channel_id)

		if channel_state ~= v.channel_state then
			local printf = printf
			local str = "CHANNEL_STATE changed: %s -> %s for peer_id: '%s'%s"
			local channel_state_2 = v.channel_state
			local var_51_5 = channel_state
			local var_51_6 = k
			local str_2

			if not var_51_1 then
				str_2 = ". With reason: " .. var_51_1

				if not str_2 then
					-- Nothing
				end
			end

			str_2 = ""

			::label_51_0::

			printf(str, channel_state_2, var_51_5, var_51_6, str_2)

			if channel_state == "connected" then
				local var_51_8 = NetworkLookup.connection_states[channel_state]

				self.network_transmit:send_rpc_clients_except("rpc_client_connection_state", k, k, var_51_8)
				NetworkUtils.announce_chat_peer_joined(k, self.lobby_host)
			elseif channel_state == "disconnected" then
				local var_51_9 = arg_51_1[k]

				if not (not var_51_9 and var_51_9.current_state == PeerStates.Disconnecting or var_51_9.current_state == PeerStates.Disconnected) then
					Managers.level_transition_handler.enemy_package_loader:client_disconnected(k)
					var_51_9.state_data:change_state(PeerStates.Disconnecting)

					local var_51_10 = NetworkLookup.connection_states[channel_state]

					self.network_transmit:send_rpc_clients_except("rpc_client_connection_state", k, k, var_51_10)
					NetworkUtils.announce_chat_peer_left(k, self.lobby_host)
				end
			end

			v.channel_state = channel_state
		end
	end
end

NetworkServer.peer_connected = function (self, arg_52_1)
	-- function 52
	self._network_state:add_peer(arg_52_1)
end

NetworkServer.peer_disconnected = function (self, arg_53_1)
	-- function 53
	self.voip:peer_disconnected(arg_53_1)
	self._network_state:remove_peer(arg_53_1)

	for i, v in ipairs(self._shared_states) do
		v:clear_peer_data(arg_53_1)
	end

	self.profile_synchronizer:clear_peer_data(arg_53_1)

	self._peer_initialized_mechanisms[arg_53_1] = nil
end

NetworkServer.get_peer_initialized_mechanism = function (self, arg_54_1)
	-- function 54
	return self._peer_initialized_mechanisms[arg_54_1]
end

NetworkServer.set_peer_initialized_mechanism = function (arg_55_0, arg_55_1, arg_55_2)
	-- function 55
	arg_55_0._peer_initialized_mechanisms[arg_55_1] = arg_55_2
end

NetworkServer.update = function (self, arg_56_1, arg_56_2)
	-- function 56
	self._profile_requester:update(arg_56_1)
	self.profile_synchronizer:update()

	local peer_state_machines = self.peer_state_machines

	self:_update_connections(peer_state_machines)

	local _joined_peers = self._joined_peers

	if #_joined_peers > 0 then
		for i = 1, #_joined_peers do
			local var_56_2 = _joined_peers[i]
			local peer_id = var_56_2.peer_id
			local channel_id = var_56_2.channel_id

			fn("Peer %s joined server lobby.", peer_id)
			fn("Creating peer info.")

			self.peer_state_machines[peer_id] = PeerStateMachine.create(self, peer_id)
		end

		table.clear(_joined_peers)
	end

	local game_network_manager = self.game_network_manager

	game_network_manager = not game_network_manager and self.game_network_manager:game()

	if not game_network_manager then
		local wants_to_leave = GameSession.wants_to_leave(game_network_manager)

		if not wants_to_leave then
			fn("Peer wants to leave game session: peer id %s", wants_to_leave)
			self:_handle_peer_left_game(wants_to_leave)
		end
	end

	for k, v in pairs(peer_state_machines) do
		v:update(arg_56_1)

		local flag = (not v and v.current_state.state_name) == "InGame"

		if self._network_state:is_peer_ingame(k) ~= flag then
			self._network_state:set_peer_ingame(k, flag)

			if not (k == Network.peer_id() or flag) then
				self._network_state:set_peer_hot_join_synced(k, false)
			end
		end
	end

	if not (not self.game_network_manager and self.game_network_manager:is_leaving_game()) then
		local num = 0
		local host_to_migrate_to = self.host_to_migrate_to

		for k_2, v_2 in pairs(peer_state_machines) do
			local current_state = v_2.current_state
			local flag_2 = current_state == PeerStates.InGame or current_state == PeerStates.InPostGame

			if k_2 == Network.peer_id() or not flag_2 then
				host_to_migrate_to = k_2
				num = num + 1
			end
		end

		local settings = Managers.state.game_mode:settings()

		if not settings and not settings.disable_host_migration then
			host_to_migrate_to = nil
		end

		if Managers.weave:get_active_weave() ~= nil then
			host_to_migrate_to = nil
		end

		if not self.lobby_host:lost_connection_to_lobby() then
			host_to_migrate_to = nil
		end

		if host_to_migrate_to ~= self.host_to_migrate_to then
			self.host_to_migrate_to = host_to_migrate_to

			if not IS_XB1 then
				local _host_migration_session_id = self._host_migration_session_id
				local session_template_name = self.lobby_host:session_template_name()
				local network_transmit = self.network_transmit
				local var_56_16 = network_transmit
				local send_rpc_clients = network_transmit.send_rpc_clients
				local str = "rpc_set_migration_host_xbox"
				local flag_3 = host_to_migrate_to or ""
				local flag_4

				flag_4 = not host_to_migrate_to and true and false

				send_rpc_clients(var_56_16, str, flag_3, flag_4, _host_migration_session_id, session_template_name)
			else
				local network_transmit_2 = self.network_transmit
				local var_56_22 = network_transmit_2
				local send_rpc_clients_2 = network_transmit_2.send_rpc_clients
				local str_2 = "rpc_set_migration_host"
				local flag_5 = host_to_migrate_to or ""
				local flag_6

				flag_6 = not host_to_migrate_to and true and false

				send_rpc_clients_2(var_56_22, str_2, flag_5, flag_6)
			end
		end
	end

	self:update_disconnect_kicked_peers_by_time(arg_56_1)
	self:_update_lobby_data(arg_56_1, arg_56_2)
	self:_update_eac_match()

	if not DEDICATED_SERVER then
		local DEDICATED_SERVER = DEDICATED_SERVER

		DEDICATED_SERVER = not DEDICATED_SERVER and rawget(_G, "GameliftServer") ~= nil

		if not DEDICATED_SERVER then
			if not GameliftServer.should_terminate() then
				GameliftServer.process_ending()
				Application.quit()
			elseif self._gamelift_session_id or not GameliftServer.can_get_session() then
				local get_session, var_56_29, var_56_30, var_56_31, var_56_32 = GameliftServer.get_session()

				var_56_31 = var_56_31 or "Gamelift Server Unknown"

				print("Got gamelift session data (NS):", get_session, var_56_29, var_56_30, var_56_31, var_56_32)
				Crashify.print_exception("[AWSDedicatedServer]", string.format("Got gamelift session data (NS): %s", var_56_31))
				self.lobby_host:set_server_name(var_56_31)
				GameliftServer.activate_game_session()

				self._gamelift_session_id = get_session
			end
		end
	end

	if not self.lobby_host:is_joined() then
		local members = self.lobby_host:members()

		if not members then
			local members_map = members:members_map()
			local size = table.size(members_map)
			local get_stored_lobby_data = self.lobby_host:get_stored_lobby_data()

			if not (not get_stored_lobby_data and size == get_stored_lobby_data.num_players) then
				printf("[NetworkServer] Changing num_players from %s to %s", tostring(get_stored_lobby_data.num_players), tostring(size))
				cprintf("[NetworkServer] Players: %d", size)

				get_stored_lobby_data.num_players = size

				self.lobby_host:set_lobby_data(get_stored_lobby_data)
			end
		end
	end

	for k_3, v_3 in pairs(self.peer_state_machines) do
		if v_3.current_state.state_name == "Disconnected" then
			self.peer_state_machines[k_3] = nil
		end
	end

	if not LEVEL_EDITOR_TEST then
		self.voip:update(arg_56_1, arg_56_2)
	end

	if not Development.parameter("network_draw_peer_states") then
		self:_draw_peer_states()
	end

	self._match_handler:poll_propagation_peer()
end

NetworkServer._handle_peer_left_game = function (self, arg_57_1)
	-- function 57
	if not arg_57_1 then
		local disconnected = NetworkLookup.connection_states.disconnected

		self.network_transmit:send_rpc_clients_except("rpc_client_connection_state", arg_57_1, arg_57_1, disconnected)
		NetworkUtils.announce_chat_peer_left(arg_57_1, self.lobby_host)

		local var_57_1 = self.peer_state_machines[arg_57_1]

		if not (not var_57_1 and var_57_1.current_state == PeerStates.Disconnecting or var_57_1.current_state == PeerStates.Disconnected) then
			var_57_1.state_data:change_state(PeerStates.Disconnecting)
		end
	end
end

NetworkServer._update_eac_match = function (self)
	-- function 58
	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		if not v.state_data.has_eac then
			local server_check_peer, var_58_2 = Managers.eac:server_check_peer(k)

			if not var_58_2 then
				printf("[NetworkServer] Peer's EAC status doesn't match the server, disconnecting peer (%s)", k)
				self:disconnect_peer(k, "eac_authorize_failed")
				v.state_data:change_state(PeerStates.Disconnecting)
			end
		end
	end
end

NetworkServer._draw_peer_states = function (self)
	-- function 59
	if not DEDICATED_SERVER then
		local str = ""
		local str_2 = "%-16s|%s\n"
		local str_3 = str .. string.format(str_2, "Peer", "Peer-state")

		for k, v in pairs(self.peer_state_machines) do
			str_3 = str_3 .. string.format(str_2, k, tostring(v.current_state))
		end

		if str_3 ~= self._peer_states_string then
			self._peer_states_string = str_3

			cprint("-------------------------------------------------")
			cprint(str_3)
		end

		return
	end

	local str_4 = "materials/fonts/arial"
	local str_5 = "arial"
	local num = 20
	local num_2 = 20
	local num_3 = 32
	local num_4 = 180
	local num_5 = 224
	local var_59_10 = Color(128, 0, 0, 0)
	local var_59_11 = Color(255, 255, 255, 255)
	local resolution, var_59_13 = Gui.resolution()
	local num_6 = var_59_13 - num_3 - num
	local debug_world = Application.debug_world()

	if self._gui == nil then
		self._gui = World.create_screen_gui(debug_world, "immediate", "material", "materials/fonts/gw_fonts")
	end

	Gui.rect(self._gui, Vector2(0, 0), Vector2(num_3 * 2 + num_4 + num_5, var_59_13), var_59_10)

	local var_59_16 = num_3

	Gui.text(self._gui, "Peer", str_4, num, str_5, Vector3(var_59_16, num_6, 0), var_59_11)

	local num_7 = var_59_16 + num_4

	Gui.text(self._gui, "Peer-state", str_4, num, str_5, Vector3(num_7, num_6, 0), var_59_11)

	local num_8 = num_6 - 4

	Gui.rect(self._gui, Vector2(num_3, num_8), Vector2(num_4 + num_5, 1), var_59_11)

	local num_9 = num_8 - num_2

	for k_2, v_2 in pairs(self.peer_state_machines) do
		local var_59_20 = num_3

		Gui.text(self._gui, k_2, str_4, num, str_5, Vector3(var_59_20, num_9, 0), var_59_11)

		local num_10 = var_59_20 + num_4

		Gui.text(self._gui, tostring(v_2.current_state), str_4, num, str_5, Vector3(num_10, num_9, 0), var_59_11)

		num_9 = num_9 - num_2
	end
end

NetworkServer.rpc_clear_peer_state = function (self, arg_60_1)
	-- function 60
	local var_60_0 = CHANNEL_TO_PEER_ID[arg_60_1]

	print(string.format("### CLEARING PEER STATE FOR %s", tostring(var_60_0)))

	local var_60_1 = self.peer_state_machines[var_60_0]

	if var_60_1 == nil then
		local var_60_2

		if self._network_state:get_level_key() == "prologue" then
			var_60_2 = NetworkLookup.connection_fails.host_plays_prologue
		else
			var_60_2 = NetworkLookup.connection_fails.unknown_error
		end

		RPC.rpc_connection_failed(arg_60_1, var_60_2)

		return
	end

	var_60_1.state_data:change_state(PeerStates.Connecting)

	local players_at_peer = Managers.player:players_at_peer(var_60_0)

	if not players_at_peer then
		return
	end

	for k, v in pairs(players_at_peer) do
		local local_player_id = v:local_player_id()

		self.profile_synchronizer:unassign_profiles_of_peer(var_60_0, local_player_id)
		self.profile_synchronizer:clear_profile_index_reservation(var_60_0)
	end
end

NetworkServer.players_past_connecting = function (self)
	-- function 61
	local alloc_table = FrameTable.alloc_table()

	for k, v in pairs(self.peer_state_machines) do
		if not (v.current_state == PeerStates.Connecting or v.current_state == PeerStates.Disconnecting or v.current_state ~= PeerStates.Disconnected) then
			alloc_table[#alloc_table + 1] = k
		end
	end

	return alloc_table
end

NetworkServer.player_is_joining = function (self, arg_62_1)
	-- function 62
	local var_62_0 = self.peer_state_machines[arg_62_1]

	if not var_62_0 then
		return false
	end

	return var_62_0.current_state == PeerStates.Connecting or var_62_0.current_state == PeerStates.Loading or var_62_0.current_state == PeerStates.LoadingProfilePackages or var_62_0.current_state == PeerStates.WaitingForEnterGame or var_62_0.current_state == PeerStates.WaitingForGameObjectSync
end

NetworkServer.peers_ongoing_game_object_sync = function (self, arg_63_1)
	-- function 63
	table.clear(arg_63_1)

	local num = 0
	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		local state_name = v.current_state.state_name

		if not (state_name == "WaitingForGameObjectSync" or state_name ~= "WaitingForEnterGame") then
			num = num + 1
			arg_63_1[num] = k
		end
	end

	return arg_63_1, num
end

local tbl_2 = {}

NetworkServer.are_all_peers_ingame = function (self, arg_64_1, arg_64_2)
	-- function 64
	arg_64_1 = arg_64_1 or tbl_2

	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		repeat
			if not arg_64_2 then
				local query_peer_data = self._match_handler:query_peer_data(k, "leader_peer_id", true)

				if not (not query_peer_data and query_peer_data == self.my_peer_id) then
					break
				end
			end

			local state_name = v.current_state.state_name

			if not (arg_64_1[k] ~= nil or state_name == "InGame" or state_name == "InPostGame" or state_name == "Disconnected" or state_name == "Disconnecting") then
				return false
			end
		until true
	end

	return true
end

NetworkServer.disconnect_joining_peers = function (self, arg_65_1)
	-- function 65
	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		local state_name = v.current_state.state_name

		if not (state_name == "InGame" or state_name == "InPostGame" or state_name == "Disconnected" or state_name == "Disconnecting") then
			if not arg_65_1 then
				self:disconnect_peer(k, arg_65_1)
			else
				self:disconnect_peer(k, "host_left_game")
			end
		end
	end
end

NetworkServer.is_peer_ingame = function (self, arg_66_1)
	-- function 66
	return self._network_state:is_peer_ingame(arg_66_1)
end

NetworkServer.are_all_peers_ready = function (self)
	-- function 67
	local peer_state_machines = self.peer_state_machines

	for k in pairs(peer_state_machines) do
		if not self:is_peer_ready(k) then
			return false
		end
	end

	return true
end

NetworkServer.is_peer_ready = function (self, arg_68_1)
	-- function 68
	local var_68_0 = self.peer_state_machines[arg_68_1]

	if not var_68_0 then
		return true
	end

	local state_name = var_68_0.current_state.state_name

	if not (state_name == "WaitingForPlayers" or state_name == "InGame" or state_name == "Disconnected") then
		return false
	end

	return true
end

NetworkServer.all_client_peers_disconnected = function (self)
	-- function 69
	local peer_state_machines = self.peer_state_machines

	for k, v in pairs(peer_state_machines) do
		local state_name = v.current_state.state_name

		if not (not (k ~= self.my_peer_id) and state_name == "Disconnected") then
			return false
		end
	end

	return true
end

NetworkServer.waiting_to_enter_game = function (self)
	-- function 70
	if not DEDICATED_SERVER then
		return true
	end

	local var_70_0 = self.peer_state_machines[self.my_peer_id]

	if not var_70_0 then
		return false
	end

	if var_70_0.current_state.state_name == "WaitingForEnterGame" then
		return true
	end

	return false
end

NetworkServer.disconnected = function (self)
	-- function 71
	local peer_state_machines = self.peer_state_machines
	local my_peer_id = self.my_peer_id

	for k, v in pairs(peer_state_machines) do
		if k == my_peer_id then
			local state_name = v.current_state.state_name

			if not (state_name == "Disconnected" or state_name ~= "Disconnecting") then
				return true
			end
		end
	end

	return false
end

NetworkServer.peer_wanted_profile = function (self, arg_72_1, arg_72_2)
	-- function 72
	local state_data = self.peer_state_machines[arg_72_1].state_data
	local wanted_profile_index = state_data.wanted_profile_index
	local wanted_career_index = state_data.wanted_career_index

	return wanted_profile_index, wanted_career_index
end

NetworkServer.register_shared_state = function (arg_73_0, arg_73_1)
	-- function 73
	arg_73_0._shared_states[#arg_73_0._shared_states + 1] = arg_73_1
end

NetworkServer.deregister_shared_state = function (self, arg_74_1)
	-- function 74
	local index_of = table.index_of(arg_74_1)

	if index_of ~= -1 then
		table.swap_delete(self._shared_states, index_of)
	end
end

NetworkServer.get_peers = function (self)
	-- function 75
	local get_peers

	if not self._network_state then
		get_peers = self._network_state:get_peers()

		if not get_peers then
			-- Nothing
		end
	end

	get_peers = {}

	::label_75_0::

	return get_peers
end

NetworkServer.hot_join_sync_party_and_profiles = function (self, arg_76_1)
	-- function 76
	local num = 1
	local num_2 = 0
	local party = Managers.party

	party:hot_join_sync(arg_76_1, num)
	party:server_peer_hot_join_synced(arg_76_1)
	party:assign_peer_to_party(arg_76_1, num, num_2)
	self.profile_synchronizer:hot_join_sync(arg_76_1)
end

NetworkServer.set_side_order_state = function (self, arg_77_1)
	-- function 77
	if not self._network_state then
		self._network_state:set_side_order_state(arg_77_1)
	end
end

NetworkServer.get_side_order_state = function (self, arg_78_1)
	-- function 78
	local _network_state = self._network_state

	_network_state = not _network_state and self._network_state:get_side_order_state()

	return _network_state
end

NetworkServer.get_network_state = function (self)
	-- function 79
	return self._network_state
end

NetworkServer.is_peer_hot_join_synced = function (self, arg_80_1)
	-- function 80
	return self._network_state:is_peer_hot_join_synced(arg_80_1)
end

NetworkServer.rpc_slot_reservation_request_peers = function (self, arg_81_1)
	-- function 81
	local active_peers = self:active_peers()

	printf("[NetworkServer] Game host requested peers to reserve. Responding with (%s)", table.concat(active_peers, ","))

	local my_peer_id = self.my_peer_id

	RPC.rpc_provide_slot_reservation_info(arg_81_1, active_peers, my_peer_id)
end

NetworkServer.rpc_slot_reservation_request_party_change = function (self, arg_82_1, arg_82_2, arg_82_3)
	-- function 82
	if not Managers.matchmaking:is_in_versus_custom_game_lobby() then
		printf("[NetworkServer] Ignored rpc_slot_reservation_request_party_change for %q because not in a hierarchical matchmaking state.", arg_82_2)

		return
	end

	local get_match_owner = self._match_handler:get_match_owner()

	if get_match_owner == self.my_peer_id then
		local game_mechanism = Managers.mechanism:game_mechanism()

		if not game_mechanism.get_slot_reservation_handler then
			local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

			get_slot_reservation_handler = get_slot_reservation_handler or game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

			get_slot_reservation_handler:move_player(arg_82_2, arg_82_3)
		end
	else
		local var_82_3 = PEER_ID_TO_CHANNEL[get_match_owner]

		RPC.rpc_slot_reservation_request_party_change(var_82_3, arg_82_2, arg_82_3)
	end
end

NetworkServer.get_match_handler = function (self)
	-- function 83
	return self._match_handler
end

NetworkServer.get_bot_profile = function (self, arg_84_1, arg_84_2)
	-- function 84
	return self._network_state:get_bot_profile(arg_84_1, arg_84_2)
end

NetworkServer.set_bot_profile = function (self, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
	-- function 85
	self._network_state:set_bot_profile(arg_85_1, arg_85_2, arg_85_3, arg_85_4)
end

NetworkServer.set_session_breed_map = function (self, arg_86_1)
	-- function 86
	self._network_state:set_session_breed_map(arg_86_1)
end

NetworkServer.get_session_breed_map = function (self)
	-- function 87
	return self._network_state:get_session_breed_map()
end

NetworkServer.get_loaded_session_breeds = function (self, arg_88_1)
	-- function 88
	return self._network_state:get_loaded_session_breed_map(arg_88_1)
end

NetworkServer.get_own_loaded_session_breed_map = function (self)
	-- function 89
	return self._network_state:get_own_loaded_session_breed_map()
end

NetworkServer.set_own_loaded_session_breeds = function (self, arg_90_1)
	-- function 90
	self._network_state:set_own_loaded_session_breeds(arg_90_1)
end

NetworkServer.set_startup_breeds = function (self, arg_91_1)
	-- function 91
	self._network_state:set_startup_breeds(arg_91_1)
end

NetworkServer.get_session_pickup_map = function (self)
	-- function 92
	return self._network_state:get_session_pickup_map()
end

NetworkServer.set_session_pickup_map = function (self, arg_93_1)
	-- function 93
	self._network_state:set_session_pickup_map(arg_93_1)
end

NetworkServer.get_own_loaded_session_pickup_map = function (self)
	-- function 94
	return self._network_state:get_own_loaded_session_pickup_map()
end

NetworkServer.set_own_loaded_session_pickups = function (self, arg_95_1)
	-- function 95
	self._network_state:set_own_loaded_session_pickups(arg_95_1)
end

NetworkServer.get_loaded_session_pickups = function (self, arg_96_1)
	-- function 96
	return self._network_state:get_loaded_session_pickup_map(arg_96_1)
end

NetworkServer.get_game_mode_event_data = function (self)
	-- function 97
	return self._network_state:get_game_mode_event_data()
end

NetworkServer.has_unlocked_dlc = function (self, arg_98_1, arg_98_2)
	-- function 98
	return self._network_state:get_unlocked_dlcs_set(arg_98_1)[arg_98_2]
end

NetworkServer.get_initialized_mutator_map = function (self)
	-- function 99
	return self._network_state:get_initialized_mutator_map()
end

NetworkServer.get_loaded_mutator_map = function (self, arg_100_1)
	-- function 100
	return self._network_state:get_loaded_mutator_map(arg_100_1)
end

NetworkServer.get_own_loaded_mutator_map = function (self)
	-- function 101
	return self._network_state:get_own_loaded_mutator_map()
end

NetworkServer.set_own_loaded_mutator_map = function (self, arg_102_1)
	-- function 102
	self._network_state:set_own_loaded_mutator_map(arg_102_1)
end

NetworkServer.state_revision = function (self)
	-- function 103
	return self._network_state:get_revision()
end
