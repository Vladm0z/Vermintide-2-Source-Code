-- chunkname: @scripts/network/network_server.lua

require("scripts/network/peer_state_machine")
require("scripts/network/voip")
require("scripts/game_state/components/profile_synchronizer")
require("scripts/game_state/components/network_state")
require("scripts/utils/profile_requester")
require("scripts/settings/profiles/sp_profiles")
require("scripts/network/network_match_handler")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

PEER_ID_TO_CHANNEL = PEER_ID_TO_CHANNEL or {}
CHANNEL_TO_PEER_ID = CHANNEL_TO_PEER_ID or {}

local var_0_1 = #PROFILES_BY_AFFILIATION.heroes
local var_0_2 = 5

local function var_0_3(arg_1_0, ...)
	if script_data.network_debug_connections then
		printf("[NetworkServer] " .. arg_1_0, ...)
	end
end

PeerState = PeerState or CreateStrictEnumTable("Broken", "Connecting", "Connected", "Disconnected", "Loading", "LoadingLevelComplete", "WaitingForEnter", "WaitingForGameObjectSync", "WaitingForSpawnPlayer", "InGame", "InPostGame")
NetworkServer = class(NetworkServer)

function NetworkServer.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = Network.peer_id()

	PEER_ID_TO_CHANNEL[var_2_0] = 0
	CHANNEL_TO_PEER_ID[0] = var_2_0
	arg_2_0.my_peer_id = var_2_0
	arg_2_0.server_peer_id = var_2_0
	arg_2_0.wanted_party_index = tonumber(Development.parameter("wanted_party_index"))
	arg_2_0.is_server = true

	local var_2_1 = Development.parameter("wanted_profile")

	if var_2_1 then
		local var_2_2 = FindProfileIndex(var_2_1)

		arg_2_3 = var_2_2

		if SPProfiles[var_2_2].affiliation == "dark_pact" then
			arg_2_0.wanted_party_index = 2
		end
	end

	arg_2_0.peers_added_to_gamesession = {}
	arg_2_0._peers_completed_game_object_sync = {}
	arg_2_0.player_manager = arg_2_1
	arg_2_0.lobby_host = arg_2_2
	arg_2_0.peer_state_machines = {}
	arg_2_0.kicked_peers_disconnect_timer = {}
	arg_2_0._game_server_manager = arg_2_4
	arg_2_0._connections = {}
	arg_2_0._joined_peers = {}
	arg_2_0._peer_initialized_mechanisms = {}
	arg_2_0._shared_states = {}
	arg_2_0._network_state = NetworkState:new(true, arg_2_0, var_2_0, var_2_0)

	arg_2_0._network_state:set_peer_hot_join_synced(var_2_0, true)
	Managers.level_transition_handler:register_network_state(arg_2_0._network_state)

	local var_2_3 = true

	arg_2_0.profile_synchronizer = ProfileSynchronizer:new(var_2_3, arg_2_2, arg_2_0._network_state)
	arg_2_0._profile_requester = ProfileRequester:new(var_2_3, arg_2_0, arg_2_0.profile_synchronizer)

	Managers.mechanism:set_profile_synchronizer(arg_2_0.profile_synchronizer)

	arg_2_0.voip = Voip:new(var_2_3, arg_2_2)

	if IS_XB1 then
		arg_2_0._host_migration_session_id = Application.guid()
	end

	if not DEDICATED_SERVER then
		arg_2_0.wanted_profile_index = arg_2_3 or SaveData.wanted_profile_index or 1

		local var_2_4 = SPProfiles[arg_2_0.wanted_profile_index]

		if var_2_4 then
			local var_2_5 = var_2_4.display_name
			local var_2_6 = Managers.backend:get_interface("hero_attributes")
			local var_2_7 = var_2_6:get(var_2_5, "career") or 1
			local var_2_8 = var_2_6:get(var_2_5, "experience") or 0
			local var_2_9 = ExperienceSettings.get_level(var_2_8)
			local var_2_10 = var_2_4.careers[var_2_7]

			if not var_2_10 or not var_2_10:is_unlocked_function(var_2_5, var_2_9) then
				var_2_7 = 1

				var_2_6:set(var_2_5, "career", var_2_7)
			end

			arg_2_0.wanted_career_index = var_2_7
		end
	end

	local var_2_11

	if DEDICATED_SERVER then
		var_2_11 = arg_2_0.lobby_host:server_name()
	elseif rawget(_G, "Steam") then
		var_2_11 = Steam.user_name()
	else
		var_2_11 = "lan"
	end

	Managers.eac:server_create(var_2_11)

	arg_2_0._using_gamelift = DEDICATED_SERVER and rawget(_G, "GameliftServer") ~= nil

	if DEDICATED_SERVER then
		if arg_2_0._using_gamelift then
			print("yes, gamelift is process_ready")
			GameliftServer.process_ready()
		end

		local var_2_12 = arg_2_0.lobby_host:get_stored_lobby_data()

		var_2_12.eac_authorized = "trusted"

		arg_2_0.lobby_host:set_lobby_data(var_2_12)
	end

	arg_2_0._match_handler = NetworkMatchHandler:new(arg_2_0, true, var_2_0, var_2_0, arg_2_2)

	Managers.mechanism:set_network_server(arg_2_0)
end

function NetworkServer.server_join(arg_3_0)
	print(string.format("### Created peer state machine for %s", arg_3_0.my_peer_id))

	local var_3_0 = arg_3_0.my_peer_id

	arg_3_0.peer_state_machines[var_3_0] = PeerStateMachine.create(arg_3_0, var_3_0)

	arg_3_0._match_handler:server_created(var_3_0)
end

function NetworkServer.num_active_peers(arg_4_0)
	local var_4_0 = 0

	for iter_4_0, iter_4_1 in pairs(arg_4_0.peer_state_machines) do
		local var_4_1 = iter_4_1.current_state

		if var_4_1 ~= PeerStates.Disconnecting and var_4_1 ~= PeerStates.Disconnected then
			var_4_0 = var_4_0 + 1
		end
	end

	return var_4_0
end

function NetworkServer.active_peers(arg_5_0)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0.peer_state_machines) do
		local var_5_1 = iter_5_1.current_state

		if var_5_1 ~= PeerStates.Disconnecting and var_5_1 ~= PeerStates.Disconnected then
			var_5_0[#var_5_0 + 1] = iter_5_0
		end
	end

	return var_5_0
end

function NetworkServer.num_joining_peers(arg_6_0)
	local var_6_0 = 0

	for iter_6_0, iter_6_1 in pairs(arg_6_0.peer_state_machines) do
		if iter_6_1.current_state == PeerStates.Connecting then
			var_6_0 = var_6_0 + 1
		end
	end

	return var_6_0
end

function NetworkServer.rpc_notify_connected(arg_7_0, arg_7_1)
	local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]

	if var_7_0 == arg_7_0.my_peer_id then
		local var_7_1
		local var_7_2
		local var_7_3 = arg_7_0._network_state:get_level_key()
		local var_7_4 = LevelSettings[var_7_3]

		if var_7_4 and var_7_4.game_mode == "tutorial" then
			var_7_1 = arg_7_0.wanted_profile_index
		else
			local var_7_5 = FindProfileIndex(Development.parameter("wanted_profile")) or arg_7_0.wanted_profile_index or SaveData.wanted_profile_index
			local var_7_6 = arg_7_0.wanted_party_index or 1

			var_7_1 = var_7_5 or arg_7_0.profile_synchronizer:get_first_free_profile(var_7_6)
		end

		if var_7_1 == arg_7_0.wanted_profile_index then
			var_7_2 = Development.parameter("wanted_career_index") or arg_7_0.wanted_career_index
		else
			local var_7_7 = SPProfiles[var_7_1].display_name

			var_7_2 = Managers.backend:get_interface("hero_attributes"):get(var_7_7, "career") or 1
		end

		arg_7_0.peer_state_machines[var_7_0].rpc_notify_lobby_joined(var_7_1, var_7_2, arg_7_0.wanted_party_index)
	end
end

function NetworkServer.rpc_notify_in_post_game(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = CHANNEL_TO_PEER_ID[arg_8_1]

	if var_8_0 == arg_8_0.my_peer_id then
		local var_8_1 = arg_8_0.peer_state_machines[var_8_0]

		if var_8_1:has_function("rpc_post_game_notified") then
			var_8_1.rpc_post_game_notified(arg_8_2)
		end
	end
end

function NetworkServer.rpc_game_started(arg_9_0, arg_9_1)
	if CHANNEL_TO_PEER_ID[arg_9_1] == arg_9_0.my_peer_id then
		Managers.state.event:trigger("game_started")
	end
end

function NetworkServer.is_network_state_fully_synced_for_peer(arg_10_0, arg_10_1)
	if not Managers.mechanism:is_peer_fully_synced(arg_10_1) then
		return false
	end

	return arg_10_0._network_state:is_peer_fully_synced(arg_10_1)
end

function NetworkServer.is_fully_synced(arg_11_0)
	return arg_11_0:is_network_state_fully_synced_for_peer(arg_11_0.my_peer_id)
end

function NetworkServer.are_profile_packages_fully_synced_for_peer(arg_12_0, arg_12_1)
	return arg_12_0.profile_synchronizer:is_peer_all_synced(arg_12_1)
end

function NetworkServer.peers_waiting_for_players(arg_13_0)
	local var_13_0 = {}

	for iter_13_0, iter_13_1 in pairs(arg_13_0.peer_state_machines) do
		if iter_13_1.current_state == PeerStates.WaitingForPlayers then
			var_13_0[iter_13_0] = true
		end
	end

	return var_13_0
end

function NetworkServer.can_enter_game(arg_14_0)
	return arg_14_0.peer_state_machines[arg_14_0.my_peer_id].current_state == PeerStates.WaitingForEnterGame
end

function NetworkServer.enter_post_game(arg_15_0)
	var_0_3("Entering post game")

	local var_15_0 = arg_15_0.peer_state_machines

	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		if iter_15_1.current_state == PeerStates.InGame then
			iter_15_1.state_data:change_state(PeerStates.InPostGame)
		end
	end
end

function NetworkServer.is_in_post_game(arg_16_0)
	if DEDICATED_SERVER then
		for iter_16_0, iter_16_1 in pairs(arg_16_0.peer_state_machines) do
			if iter_16_1.current_state ~= PeerStates.InPostGame then
				return false
			end
		end

		return true
	else
		return arg_16_0.peer_state_machines[arg_16_0.my_peer_id].current_state == PeerStates.InPostGame
	end
end

function NetworkServer.on_game_entered(arg_17_0, arg_17_1)
	var_0_3("[NETWORK SERVER]: On Game Entered")

	arg_17_0.game_session = Network.game_session()

	assert(arg_17_0.game_session, "Unable to find game session in NetworkServer:on_game_entered.")

	arg_17_0.game_network_manager = arg_17_1

	Managers.account:update_presence()

	if not DEDICATED_SERVER then
		arg_17_0:set_peer_synced_game_objects(arg_17_0.my_peer_id, true)
		arg_17_0.peer_state_machines[arg_17_0.my_peer_id].rpc_is_ingame()
	end
end

function NetworkServer.request_profile(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	arg_18_0._profile_requester:request_profile(Network.peer_id(), arg_18_1, arg_18_2, arg_18_3, arg_18_4)
end

function NetworkServer.profile_requester(arg_19_0)
	return arg_19_0._profile_requester
end

function NetworkServer.rpc_is_ingame(arg_20_0, arg_20_1)
	local var_20_0 = CHANNEL_TO_PEER_ID[arg_20_1]
	local var_20_1 = arg_20_0.peer_state_machines[var_20_0]

	if not var_20_1 or not var_20_1:has_function("rpc_is_ingame") then
		local var_20_2 = var_20_1 and var_20_1.current_state and var_20_1.current_state.state_name or "no_state"

		printf("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_is_ingame", var_20_2)
		RPC.rpc_connection_failed(arg_20_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		var_20_1.rpc_is_ingame()
	end
end

function NetworkServer.rpc_loading_synced(arg_21_0, arg_21_1)
	return
end

function NetworkServer.peer_spawned_player(arg_22_0, arg_22_1)
	var_0_3("Peer %s spawned player.", arg_22_1)

	local var_22_0 = arg_22_0.peer_state_machines[arg_22_1]

	if var_22_0:has_function("spawned_player") then
		var_22_0.spawned_player()
	end
end

function NetworkServer.peer_despawned_player(arg_23_0, arg_23_1)
	var_0_3("Peer %s despawned player.", arg_23_1)

	local var_23_0 = arg_23_0.peer_state_machines[arg_23_1]

	if var_23_0:has_function("despawned_player") then
		var_23_0.despawned_player()
	end
end

function NetworkServer.peer_respawn_player(arg_24_0, arg_24_1)
	var_0_3("Peer %s respawn player.", arg_24_1)

	local var_24_0 = arg_24_0.peer_state_machines[arg_24_1]

	if var_24_0:has_function("respawn_player") then
		var_24_0.respawn_player()
	end
end

function NetworkServer.rpc_client_respawn_player(arg_25_0, arg_25_1)
	local var_25_0 = CHANNEL_TO_PEER_ID[arg_25_1]

	arg_25_0:peer_respawn_player(var_25_0)
end

function NetworkServer.destroy(arg_26_0)
	Managers.level_transition_handler:deregister_network_state()
	arg_26_0._match_handler:destroy()
	Managers.mechanism:set_network_server(nil)

	if arg_26_0.network_event_delegate then
		arg_26_0:unregister_rpcs()
	end

	arg_26_0._network_state:destroy()
	arg_26_0.voip:destroy()

	arg_26_0.voip = nil

	arg_26_0._profile_requester:destroy()

	arg_26_0._profile_requester = nil

	arg_26_0.profile_synchronizer:destroy()

	arg_26_0.profile_synchronizer = nil

	GarbageLeakDetector.register_object(arg_26_0, "NetworkServer")

	for iter_26_0, iter_26_1 in pairs(arg_26_0._connections) do
		arg_26_0:close_channel(iter_26_0)
	end

	Managers.eac:server_destroy()

	if arg_26_0._gui ~= nil then
		World.destroy_gui(Application.debug_world(), arg_26_0._gui)

		arg_26_0._gui = nil
	end
end

function NetworkServer.register_rpcs(arg_27_0, arg_27_1, arg_27_2)
	arg_27_1:register(arg_27_0, "rpc_notify_lobby_joined", "rpc_post_game_notified", "rpc_want_to_spawn_player", "rpc_level_load_started", "rpc_level_loaded", "rpc_game_started", "rpc_is_ingame", "game_object_sync_done", "rpc_notify_connected", "rpc_loading_synced", "rpc_clear_peer_state", "rpc_notify_in_post_game", "rpc_client_respawn_player", "rpc_provide_slot_reservation_info", "rpc_slot_reservation_request_peers", "rpc_slot_reservation_request_party_change")
	arg_27_1:register_with_return(arg_27_0, "approve_channel")

	arg_27_0.network_event_delegate = arg_27_1

	arg_27_0._network_state:register_rpcs(arg_27_1, arg_27_2)
	arg_27_0._network_state:full_sync()
	arg_27_0.profile_synchronizer:register_rpcs(arg_27_1, arg_27_2)
	arg_27_0._profile_requester:register_rpcs(arg_27_1, arg_27_2)

	arg_27_0.network_transmit = arg_27_2

	arg_27_0.voip:register_rpcs(arg_27_1, arg_27_2)
	arg_27_0._match_handler:register_rpcs(arg_27_1, arg_27_2)
end

function NetworkServer.on_level_exit(arg_28_0)
	table.clear(arg_28_0._peers_completed_game_object_sync)

	local var_28_0 = arg_28_0.peer_state_machines

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		local var_28_1 = iter_28_1.current_state

		if var_28_1 ~= PeerStates.Connecting and var_28_1 ~= PeerStates.Disconnecting and var_28_1 ~= PeerStates.Disconnected then
			iter_28_1.state_data:change_state(PeerStates.Loading)
		end
	end

	table.clear(arg_28_0.peers_added_to_gamesession)
	arg_28_0:unregister_rpcs()

	arg_28_0.game_session = nil
end

function NetworkServer.unregister_rpcs(arg_29_0)
	arg_29_0.voip:unregister_rpcs()
	arg_29_0._profile_requester:unregister_rpcs()

	if arg_29_0.network_event_delegate then
		arg_29_0.network_event_delegate:unregister(arg_29_0)

		arg_29_0.network_event_delegate = nil
	end

	arg_29_0.profile_synchronizer:unregister_network_events()
	arg_29_0._network_state:unregister_network_events()

	arg_29_0.network_transmit = nil

	arg_29_0._match_handler:unregister_rpcs()
end

function NetworkServer.has_all_peers_loaded_packages(arg_30_0)
	return arg_30_0.profile_synchronizer:all_synced()
end

function NetworkServer.kick_peer(arg_31_0, arg_31_1)
	if not PEER_ID_TO_CHANNEL[arg_31_1] then
		return
	end

	arg_31_0.network_transmit:send_rpc("rpc_kick_peer", arg_31_1)

	arg_31_0.kicked_peers_disconnect_timer[arg_31_1] = var_0_2
end

function NetworkServer.update_disconnect_kicked_peers_by_time(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.kicked_peers_disconnect_timer

	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		if iter_32_1 == 0 then
			var_32_0[iter_32_0] = nil

			arg_32_0:force_disconnect_client_by_peer_id(iter_32_0)
		else
			var_32_0[iter_32_0] = math.max(iter_32_1 - arg_32_1, 0)
		end
	end
end

function NetworkServer._update_lobby_data(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0.lobby_host
	local var_33_1 = var_33_0:get_stored_lobby_data()

	if not var_33_1 then
		return
	end

	if arg_33_0.profile_synchronizer:poll_sync_lobby_data_required() then
		arg_33_0._lobby_data_sync_requested = true
	end

	local var_33_2, var_33_3 = Managers.mechanism:mechanism_try_call("get_slot_reservation_handler", Network.peer_id(), var_0_0.session)

	if var_33_2 and var_33_3:poll_sync_lobby_data_required() then
		arg_33_0._lobby_data_sync_requested = true
	end

	if not arg_33_0._lobby_data_sync_requested then
		return
	end

	arg_33_0._lobby_data_sync_requested = false

	local var_33_4 = {}
	local var_33_5 = Managers.party:get_num_game_participating_parties()

	for iter_33_0 = 1, var_33_5 do
		var_33_4[iter_33_0] = {}
	end

	if var_33_2 then
		local var_33_6 = var_33_3:peers()

		for iter_33_1 = 1, #var_33_6 do
			local var_33_7 = var_33_6[iter_33_1]
			local var_33_8 = var_33_3:party_id_by_peer(var_33_7)

			if var_33_8 then
				local var_33_9 = arg_33_0.profile_synchronizer:get_persistent_profile_index_reservation(var_33_7)

				table.insert(var_33_4[var_33_8], {
					peer_id = var_33_7,
					profile_index = var_33_9
				})
			end
		end
	else
		for iter_33_2 = 1, #var_33_4 do
			for iter_33_3 = 1, 5 do
				local var_33_10 = arg_33_0.profile_synchronizer:get_profile_index_reservation(iter_33_2, iter_33_3)

				if var_33_10 then
					table.insert(var_33_4[iter_33_2], {
						peer_id = var_33_10,
						profile_index = iter_33_3
					})
				end
			end
		end
	end

	local var_33_11 = LobbyAux.serialize_lobby_reservation_data(var_33_4)

	if var_33_11 ~= var_33_1.reserved_profiles then
		var_33_1.reserved_profiles = var_33_11

		var_33_0:set_lobby_data(var_33_1)
	end
end

function NetworkServer.disconnect_all_peers(arg_34_0, arg_34_1)
	local var_34_0 = NetworkLookup.connection_fails[arg_34_1]
	local var_34_1 = arg_34_0.peer_state_machines

	for iter_34_0, iter_34_1 in pairs(var_34_1) do
		if iter_34_0 ~= Network.peer_id() and iter_34_1.current_state ~= PeerStates.Disconnecting and iter_34_1.current_state ~= PeerStates.Disconnected then
			local var_34_2 = PEER_ID_TO_CHANNEL[iter_34_0]

			RPC.rpc_connection_failed(var_34_2, var_34_0)
		end
	end
end

function NetworkServer.disconnect_peer(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = NetworkLookup.connection_fails[arg_35_2]
	local var_35_1 = arg_35_0.peer_state_machines[arg_35_1].current_state

	if var_35_1 ~= PeerStates.Disconnecting and var_35_1 ~= PeerStates.Disconnected then
		local var_35_2 = PEER_ID_TO_CHANNEL[arg_35_1]

		RPC.rpc_connection_failed(var_35_2, var_35_0)
	end
end

function NetworkServer.force_disconnect_all_client_peers(arg_36_0)
	local var_36_0 = arg_36_0.peer_state_machines

	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		if iter_36_0 ~= arg_36_0.my_peer_id and iter_36_1.current_state ~= PeerStates.Disconnecting and iter_36_1.current_state ~= PeerStates.Disconnected then
			iter_36_1.state_data:change_state(PeerStates.Disconnecting)
		end
	end
end

function NetworkServer.force_disconnect_client_by_peer_id(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.peer_state_machines

	if arg_37_1 and var_37_0[arg_37_1] then
		local var_37_1 = var_37_0[arg_37_1]

		if arg_37_1 ~= arg_37_0.my_peer_id and var_37_1.current_state ~= PeerStates.Disconnecting and var_37_1.current_state ~= PeerStates.Disconnected then
			var_37_1.state_data:change_state(PeerStates.Disconnecting)
		end
	end
end

function NetworkServer.rpc_notify_lobby_joined(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
	local var_38_0 = CHANNEL_TO_PEER_ID[arg_38_1]

	var_0_3("Peer %s has sent rpc_notify_lobby_joined", tostring(var_38_0))

	local var_38_1 = arg_38_0.peer_state_machines[var_38_0]

	if not var_38_1 or not var_38_1:has_function("rpc_notify_lobby_joined") then
		local var_38_2 = var_38_1 and var_38_1.current_state and var_38_1.current_state.state_name or "no_state"

		var_0_3("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_notify_lobby_joined", var_38_2)
		RPC.rpc_connection_failed(arg_38_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		if arg_38_4 == 0 then
			arg_38_4 = nil
		end

		var_38_1.rpc_notify_lobby_joined(arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
		Managers.level_transition_handler.enemy_package_loader:client_connected(var_38_0)
	end
end

function NetworkServer.rpc_provide_slot_reservation_info(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = CHANNEL_TO_PEER_ID[arg_39_1]

	var_0_3("Peer %s has sent rpc_provide_slot_reservation_info", var_39_0)

	local var_39_1 = arg_39_0.peer_state_machines[var_39_0]

	if not var_39_1 or not var_39_1:has_function("rpc_provide_slot_reservation_info") then
		local var_39_2 = var_39_1 and var_39_1.current_state and var_39_1.current_state.state_name or "no_state"

		var_0_3("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_provide_slot_reservation_info", var_39_2)
		RPC.rpc_connection_failed(arg_39_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		var_39_1.rpc_provide_slot_reservation_info(arg_39_2, arg_39_3)
	end
end

function NetworkServer.rpc_post_game_notified(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = CHANNEL_TO_PEER_ID[arg_40_1]

	var_0_3("Peer %s has sent rpc_post_game_notified", tostring(var_40_0))

	local var_40_1 = arg_40_0.peer_state_machines[var_40_0]

	if not var_40_1 or not var_40_1:has_function("rpc_post_game_notified") then
		local var_40_2 = var_40_1 and var_40_1.current_state and var_40_1.current_state.state_name or "no_state"

		var_0_3("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_join) %s (state: %s)", "rpc_post_game_notified", var_40_2)
		RPC.rpc_connection_failed(arg_40_1, NetworkLookup.connection_fails.no_peer_data_on_join)
	else
		var_40_1.rpc_post_game_notified(arg_40_2)
	end
end

function NetworkServer.rpc_level_load_started(arg_41_0, arg_41_1, arg_41_2)
	print("### Received rpc_level_load_started")

	local var_41_0 = CHANNEL_TO_PEER_ID[arg_41_1]
	local var_41_1 = arg_41_0.peer_state_machines[var_41_0]

	if var_41_1 then
		print(string.format("#### Has state machine: %s, peer_id: %s, level_session_id: %s", var_41_1:has_function("rpc_level_load_started"), var_41_0, arg_41_2))

		if var_41_1:has_function("rpc_level_load_started") then
			var_41_1.rpc_level_load_started(arg_41_2)
		end
	end
end

function NetworkServer.rpc_level_loaded(arg_42_0, arg_42_1, arg_42_2)
	print("### Received rpc_level_loaded")

	local var_42_0 = CHANNEL_TO_PEER_ID[arg_42_1]
	local var_42_1 = arg_42_0.peer_state_machines[var_42_0]

	if not var_42_1 then
		if var_42_0 ~= arg_42_0.my_peer_id then
			var_0_3("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_enter_game)", "rpc_level_loaded")
			RPC.rpc_connection_failed(arg_42_1, NetworkLookup.connection_fails.no_peer_data_on_enter_game)
		end
	else
		print(string.format("#### Has state machine: %s, peer_id: %s, level_id: %s", var_42_1:has_function("rpc_level_loaded"), var_42_0, arg_42_2))

		if var_42_1:has_function("rpc_level_loaded") then
			var_42_1.rpc_level_loaded(arg_42_2)
		end
	end
end

function NetworkServer.rpc_want_to_spawn_player(arg_43_0, arg_43_1)
	local var_43_0 = CHANNEL_TO_PEER_ID[arg_43_1]
	local var_43_1 = arg_43_0.peer_state_machines[var_43_0]

	if not var_43_1 or not var_43_1:has_function("rpc_want_to_spawn_player") then
		var_0_3("RPC.rpc_connection_failed(channel_id, NetworkLookup.connection_fails.no_peer_data_on_enter_game)", "rpc_want_to_spawn_player")
		RPC.rpc_connection_failed(arg_43_1, NetworkLookup.connection_fails.no_peer_data_on_enter_game)
	else
		var_43_1.rpc_want_to_spawn_player()
	end
end

function NetworkServer.game_object_sync_done(arg_44_0, arg_44_1)
	var_0_3("Game_object_sync_done for peer %s", arg_44_1)
	arg_44_0:set_peer_synced_game_objects(arg_44_1, true)

	local var_44_0 = PEER_ID_TO_CHANNEL[arg_44_1]

	if IS_XB1 then
		local var_44_1 = arg_44_0._host_migration_session_id
		local var_44_2 = arg_44_0.lobby_host:session_template_name()

		RPC.rpc_set_migration_host_xbox(var_44_0, arg_44_0.host_to_migrate_to or "", arg_44_0.host_to_migrate_to and true or false, var_44_1, var_44_2)
	else
		RPC.rpc_set_migration_host(var_44_0, arg_44_0.host_to_migrate_to or "", arg_44_0.host_to_migrate_to and true or false)
	end
end

function NetworkServer.set_peer_hot_join_synced(arg_45_0, arg_45_1, arg_45_2)
	arg_45_0._network_state:set_peer_hot_join_synced(arg_45_1, arg_45_2)
end

local var_0_4 = {}

function NetworkServer.hot_join_synced_peers(arg_46_0)
	table.clear(var_0_4)

	for iter_46_0 in pairs(arg_46_0.peer_state_machines) do
		if arg_46_0._network_state:is_peer_hot_join_synced(iter_46_0) then
			var_0_4[iter_46_0] = true
		end
	end

	return var_0_4
end

function NetworkServer.has_peer_synced_game_objects(arg_47_0, arg_47_1)
	return arg_47_0._peers_completed_game_object_sync[arg_47_1]
end

function NetworkServer.set_peer_synced_game_objects(arg_48_0, arg_48_1, arg_48_2)
	arg_48_0._peers_completed_game_object_sync[arg_48_1] = arg_48_2 or nil
end

function NetworkServer.approve_channel(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	print("GOT approve_channel", arg_49_1, arg_49_2, arg_49_3)

	if PEER_ID_TO_CHANNEL[arg_49_2] then
		printf("Client with peer_id %s already has a channel %d", arg_49_2, PEER_ID_TO_CHANNEL[arg_49_2])

		return false
	end

	PEER_ID_TO_CHANNEL[arg_49_2] = arg_49_1
	CHANNEL_TO_PEER_ID[arg_49_1] = arg_49_2

	if DEDICATED_SERVER then
		local var_49_0 = Managers.mechanism:game_mechanism()

		if var_49_0.get_slot_reservation_handler then
			var_49_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):send_slot_update_to_clients()
		end

		Managers.party:sync_friend_party_for_player(arg_49_2)
	elseif not Managers.party:any_party_has_free_slots(1) then
		print("Game is full, denied access.")

		PEER_ID_TO_CHANNEL[arg_49_2] = nil
		CHANNEL_TO_PEER_ID[arg_49_1] = nil

		return false
	end

	local var_49_1 = arg_49_0._joined_peers
	local var_49_2 = arg_49_0._connections
	local var_49_3 = {
		channel_id = arg_49_1,
		peer_id = arg_49_2,
		channel_state = Network.channel_state(arg_49_1)
	}

	var_49_2[arg_49_2] = var_49_3
	var_49_1[#var_49_1 + 1] = var_49_3

	printf("Client with peer_id %s got APPROVED by server", arg_49_2)

	return true
end

function NetworkServer.close_channel(arg_50_0, arg_50_1)
	local var_50_0 = PEER_ID_TO_CHANNEL[arg_50_1]

	print("GOT close_channel", var_50_0, arg_50_1)

	if var_50_0 then
		arg_50_0.lobby_host:close_channel(var_50_0)

		CHANNEL_TO_PEER_ID[var_50_0] = nil
		PEER_ID_TO_CHANNEL[arg_50_1] = nil
		arg_50_0._connections[arg_50_1] = nil
	else
		assert(arg_50_0._connections[arg_50_1], "Connection was not properly cleaned up")
	end
end

function NetworkServer._update_connections(arg_51_0, arg_51_1)
	for iter_51_0, iter_51_1 in pairs(arg_51_0._connections) do
		local var_51_0, var_51_1 = Network.channel_state(iter_51_1.channel_id)

		if var_51_0 ~= iter_51_1.channel_state then
			printf("CHANNEL_STATE changed: %s -> %s for peer_id: '%s'%s", iter_51_1.channel_state, var_51_0, iter_51_0, var_51_1 and ". With reason: " .. var_51_1 or "")

			if var_51_0 == "connected" then
				local var_51_2 = NetworkLookup.connection_states[var_51_0]

				arg_51_0.network_transmit:send_rpc_clients_except("rpc_client_connection_state", iter_51_0, iter_51_0, var_51_2)
				NetworkUtils.announce_chat_peer_joined(iter_51_0, arg_51_0.lobby_host)
			elseif var_51_0 == "disconnected" then
				local var_51_3 = arg_51_1[iter_51_0]

				if var_51_3 and var_51_3.current_state ~= PeerStates.Disconnecting and var_51_3.current_state ~= PeerStates.Disconnected then
					Managers.level_transition_handler.enemy_package_loader:client_disconnected(iter_51_0)
					var_51_3.state_data:change_state(PeerStates.Disconnecting)

					local var_51_4 = NetworkLookup.connection_states[var_51_0]

					arg_51_0.network_transmit:send_rpc_clients_except("rpc_client_connection_state", iter_51_0, iter_51_0, var_51_4)
					NetworkUtils.announce_chat_peer_left(iter_51_0, arg_51_0.lobby_host)
				end
			end

			iter_51_1.channel_state = var_51_0
		end
	end
end

function NetworkServer.peer_connected(arg_52_0, arg_52_1)
	arg_52_0._network_state:add_peer(arg_52_1)
end

function NetworkServer.peer_disconnected(arg_53_0, arg_53_1)
	arg_53_0.voip:peer_disconnected(arg_53_1)
	arg_53_0._network_state:remove_peer(arg_53_1)

	for iter_53_0, iter_53_1 in ipairs(arg_53_0._shared_states) do
		iter_53_1:clear_peer_data(arg_53_1)
	end

	arg_53_0.profile_synchronizer:clear_peer_data(arg_53_1)

	arg_53_0._peer_initialized_mechanisms[arg_53_1] = nil
end

function NetworkServer.get_peer_initialized_mechanism(arg_54_0, arg_54_1)
	return arg_54_0._peer_initialized_mechanisms[arg_54_1]
end

function NetworkServer.set_peer_initialized_mechanism(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0._peer_initialized_mechanisms[arg_55_1] = arg_55_2
end

function NetworkServer.update(arg_56_0, arg_56_1, arg_56_2)
	arg_56_0._profile_requester:update(arg_56_1)
	arg_56_0.profile_synchronizer:update()

	local var_56_0 = arg_56_0.peer_state_machines

	arg_56_0:_update_connections(var_56_0)

	local var_56_1 = arg_56_0._joined_peers

	if #var_56_1 > 0 then
		for iter_56_0 = 1, #var_56_1 do
			local var_56_2 = var_56_1[iter_56_0]
			local var_56_3 = var_56_2.peer_id
			local var_56_4 = var_56_2.channel_id

			var_0_3("Peer %s joined server lobby.", var_56_3)
			var_0_3("Creating peer info.")

			arg_56_0.peer_state_machines[var_56_3] = PeerStateMachine.create(arg_56_0, var_56_3)
		end

		table.clear(var_56_1)
	end

	local var_56_5 = arg_56_0.game_network_manager and arg_56_0.game_network_manager:game()

	if var_56_5 then
		local var_56_6 = GameSession.wants_to_leave(var_56_5)

		if var_56_6 then
			var_0_3("Peer wants to leave game session: peer id %s", var_56_6)
			arg_56_0:_handle_peer_left_game(var_56_6)
		end
	end

	for iter_56_1, iter_56_2 in pairs(var_56_0) do
		iter_56_2:update(arg_56_1)

		local var_56_7 = (iter_56_2 and iter_56_2.current_state.state_name) == "InGame"

		if arg_56_0._network_state:is_peer_ingame(iter_56_1) ~= var_56_7 then
			arg_56_0._network_state:set_peer_ingame(iter_56_1, var_56_7)

			if iter_56_1 ~= Network.peer_id() and not var_56_7 then
				arg_56_0._network_state:set_peer_hot_join_synced(iter_56_1, false)
			end
		end
	end

	if arg_56_0.game_network_manager and not arg_56_0.game_network_manager:is_leaving_game() then
		local var_56_8 = 0
		local var_56_9 = arg_56_0.host_to_migrate_to

		for iter_56_3, iter_56_4 in pairs(var_56_0) do
			local var_56_10 = iter_56_4.current_state
			local var_56_11 = var_56_10 == PeerStates.InGame or var_56_10 == PeerStates.InPostGame

			if iter_56_3 ~= Network.peer_id() and var_56_11 then
				var_56_9 = iter_56_3
				var_56_8 = var_56_8 + 1
			end
		end

		local var_56_12 = Managers.state.game_mode:settings()

		if var_56_12 and var_56_12.disable_host_migration then
			var_56_9 = nil
		end

		if Managers.weave:get_active_weave() ~= nil then
			var_56_9 = nil
		end

		if arg_56_0.lobby_host:lost_connection_to_lobby() then
			var_56_9 = nil
		end

		if var_56_9 ~= arg_56_0.host_to_migrate_to then
			arg_56_0.host_to_migrate_to = var_56_9

			if IS_XB1 then
				local var_56_13 = arg_56_0._host_migration_session_id
				local var_56_14 = arg_56_0.lobby_host:session_template_name()

				arg_56_0.network_transmit:send_rpc_clients("rpc_set_migration_host_xbox", var_56_9 or "", var_56_9 and true or false, var_56_13, var_56_14)
			else
				arg_56_0.network_transmit:send_rpc_clients("rpc_set_migration_host", var_56_9 or "", var_56_9 and true or false)
			end
		end
	end

	arg_56_0:update_disconnect_kicked_peers_by_time(arg_56_1)
	arg_56_0:_update_lobby_data(arg_56_1, arg_56_2)
	arg_56_0:_update_eac_match()

	if DEDICATED_SERVER and DEDICATED_SERVER and rawget(_G, "GameliftServer") ~= nil then
		if GameliftServer.should_terminate() then
			GameliftServer.process_ending()
			Application.quit()
		elseif not arg_56_0._gamelift_session_id and GameliftServer.can_get_session() then
			local var_56_15, var_56_16, var_56_17, var_56_18, var_56_19 = GameliftServer.get_session()

			var_56_18 = var_56_18 or "Gamelift Server Unknown"

			print("Got gamelift session data (NS):", var_56_15, var_56_16, var_56_17, var_56_18, var_56_19)
			Crashify.print_exception("[AWSDedicatedServer]", string.format("Got gamelift session data (NS): %s", var_56_18))
			arg_56_0.lobby_host:set_server_name(var_56_18)
			GameliftServer.activate_game_session()

			arg_56_0._gamelift_session_id = var_56_15
		end
	end

	if arg_56_0.lobby_host:is_joined() then
		local var_56_20 = arg_56_0.lobby_host:members()

		if var_56_20 then
			local var_56_21 = var_56_20:members_map()
			local var_56_22 = table.size(var_56_21)
			local var_56_23 = arg_56_0.lobby_host:get_stored_lobby_data()

			if var_56_23 and var_56_22 ~= var_56_23.num_players then
				printf("[NetworkServer] Changing num_players from %s to %s", tostring(var_56_23.num_players), tostring(var_56_22))
				cprintf("[NetworkServer] Players: %d", var_56_22)

				var_56_23.num_players = var_56_22

				arg_56_0.lobby_host:set_lobby_data(var_56_23)
			end
		end
	end

	for iter_56_5, iter_56_6 in pairs(arg_56_0.peer_state_machines) do
		if iter_56_6.current_state.state_name == "Disconnected" then
			arg_56_0.peer_state_machines[iter_56_5] = nil
		end
	end

	if not LEVEL_EDITOR_TEST then
		arg_56_0.voip:update(arg_56_1, arg_56_2)
	end

	if Development.parameter("network_draw_peer_states") then
		arg_56_0:_draw_peer_states()
	end

	arg_56_0._match_handler:poll_propagation_peer()
end

function NetworkServer._handle_peer_left_game(arg_57_0, arg_57_1)
	if arg_57_1 then
		local var_57_0 = NetworkLookup.connection_states.disconnected

		arg_57_0.network_transmit:send_rpc_clients_except("rpc_client_connection_state", arg_57_1, arg_57_1, var_57_0)
		NetworkUtils.announce_chat_peer_left(arg_57_1, arg_57_0.lobby_host)

		local var_57_1 = arg_57_0.peer_state_machines[arg_57_1]

		if var_57_1 and var_57_1.current_state ~= PeerStates.Disconnecting and var_57_1.current_state ~= PeerStates.Disconnected then
			var_57_1.state_data:change_state(PeerStates.Disconnecting)
		end
	end
end

function NetworkServer._update_eac_match(arg_58_0)
	local var_58_0 = arg_58_0.peer_state_machines

	for iter_58_0, iter_58_1 in pairs(var_58_0) do
		if iter_58_1.state_data.has_eac then
			local var_58_1, var_58_2 = Managers.eac:server_check_peer(iter_58_0)

			if not var_58_2 then
				printf("[NetworkServer] Peer's EAC status doesn't match the server, disconnecting peer (%s)", iter_58_0)
				arg_58_0:disconnect_peer(iter_58_0, "eac_authorize_failed")
				iter_58_1.state_data:change_state(PeerStates.Disconnecting)
			end
		end
	end
end

function NetworkServer._draw_peer_states(arg_59_0)
	if DEDICATED_SERVER then
		local var_59_0 = ""
		local var_59_1 = "%-16s|%s\n"
		local var_59_2 = var_59_0 .. string.format(var_59_1, "Peer", "Peer-state")

		for iter_59_0, iter_59_1 in pairs(arg_59_0.peer_state_machines) do
			var_59_2 = var_59_2 .. string.format(var_59_1, iter_59_0, tostring(iter_59_1.current_state))
		end

		if var_59_2 ~= arg_59_0._peer_states_string then
			arg_59_0._peer_states_string = var_59_2

			cprint("-------------------------------------------------")
			cprint(var_59_2)
		end

		return
	end

	local var_59_3 = "materials/fonts/arial"
	local var_59_4 = "arial"
	local var_59_5 = 20
	local var_59_6 = 20
	local var_59_7 = 32
	local var_59_8 = 180
	local var_59_9 = 224
	local var_59_10 = Color(128, 0, 0, 0)
	local var_59_11 = Color(255, 255, 255, 255)
	local var_59_12, var_59_13 = Gui.resolution()
	local var_59_14 = var_59_13 - var_59_7 - var_59_5
	local var_59_15 = Application.debug_world()

	if arg_59_0._gui == nil then
		arg_59_0._gui = World.create_screen_gui(var_59_15, "immediate", "material", "materials/fonts/gw_fonts")
	end

	Gui.rect(arg_59_0._gui, Vector2(0, 0), Vector2(var_59_7 * 2 + var_59_8 + var_59_9, var_59_13), var_59_10)

	local var_59_16 = var_59_7

	Gui.text(arg_59_0._gui, "Peer", var_59_3, var_59_5, var_59_4, Vector3(var_59_16, var_59_14, 0), var_59_11)

	local var_59_17 = var_59_16 + var_59_8

	Gui.text(arg_59_0._gui, "Peer-state", var_59_3, var_59_5, var_59_4, Vector3(var_59_17, var_59_14, 0), var_59_11)

	local var_59_18 = var_59_14 - 4

	Gui.rect(arg_59_0._gui, Vector2(var_59_7, var_59_18), Vector2(var_59_8 + var_59_9, 1), var_59_11)

	local var_59_19 = var_59_18 - var_59_6

	for iter_59_2, iter_59_3 in pairs(arg_59_0.peer_state_machines) do
		local var_59_20 = var_59_7

		Gui.text(arg_59_0._gui, iter_59_2, var_59_3, var_59_5, var_59_4, Vector3(var_59_20, var_59_19, 0), var_59_11)

		local var_59_21 = var_59_20 + var_59_8

		Gui.text(arg_59_0._gui, tostring(iter_59_3.current_state), var_59_3, var_59_5, var_59_4, Vector3(var_59_21, var_59_19, 0), var_59_11)

		var_59_19 = var_59_19 - var_59_6
	end
end

function NetworkServer.rpc_clear_peer_state(arg_60_0, arg_60_1)
	local var_60_0 = CHANNEL_TO_PEER_ID[arg_60_1]

	print(string.format("### CLEARING PEER STATE FOR %s", tostring(var_60_0)))

	local var_60_1 = arg_60_0.peer_state_machines[var_60_0]

	if var_60_1 == nil then
		local var_60_2

		if arg_60_0._network_state:get_level_key() == "prologue" then
			var_60_2 = NetworkLookup.connection_fails.host_plays_prologue
		else
			var_60_2 = NetworkLookup.connection_fails.unknown_error
		end

		RPC.rpc_connection_failed(arg_60_1, var_60_2)

		return
	end

	var_60_1.state_data:change_state(PeerStates.Connecting)

	local var_60_3 = Managers.player:players_at_peer(var_60_0)

	if not var_60_3 then
		return
	end

	for iter_60_0, iter_60_1 in pairs(var_60_3) do
		local var_60_4 = iter_60_1:local_player_id()

		arg_60_0.profile_synchronizer:unassign_profiles_of_peer(var_60_0, var_60_4)
		arg_60_0.profile_synchronizer:clear_profile_index_reservation(var_60_0)
	end
end

function NetworkServer.players_past_connecting(arg_61_0)
	local var_61_0 = FrameTable.alloc_table()

	for iter_61_0, iter_61_1 in pairs(arg_61_0.peer_state_machines) do
		if iter_61_1.current_state ~= PeerStates.Connecting and iter_61_1.current_state ~= PeerStates.Disconnecting and iter_61_1.current_state ~= PeerStates.Disconnected then
			var_61_0[#var_61_0 + 1] = iter_61_0
		end
	end

	return var_61_0
end

function NetworkServer.player_is_joining(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_0.peer_state_machines[arg_62_1]

	if not var_62_0 then
		return false
	end

	return var_62_0.current_state == PeerStates.Connecting or var_62_0.current_state == PeerStates.Loading or var_62_0.current_state == PeerStates.LoadingProfilePackages or var_62_0.current_state == PeerStates.WaitingForEnterGame or var_62_0.current_state == PeerStates.WaitingForGameObjectSync
end

function NetworkServer.peers_ongoing_game_object_sync(arg_63_0, arg_63_1)
	table.clear(arg_63_1)

	local var_63_0 = 0
	local var_63_1 = arg_63_0.peer_state_machines

	for iter_63_0, iter_63_1 in pairs(var_63_1) do
		local var_63_2 = iter_63_1.current_state.state_name

		if var_63_2 == "WaitingForGameObjectSync" or var_63_2 == "WaitingForEnterGame" then
			var_63_0 = var_63_0 + 1
			arg_63_1[var_63_0] = iter_63_0
		end
	end

	return arg_63_1, var_63_0
end

local var_0_5 = {}

function NetworkServer.are_all_peers_ingame(arg_64_0, arg_64_1, arg_64_2)
	arg_64_1 = arg_64_1 or var_0_5

	local var_64_0 = arg_64_0.peer_state_machines

	for iter_64_0, iter_64_1 in pairs(var_64_0) do
		repeat
			if arg_64_2 then
				local var_64_1 = arg_64_0._match_handler:query_peer_data(iter_64_0, "leader_peer_id", true)

				if var_64_1 and var_64_1 ~= arg_64_0.my_peer_id then
					break
				end
			end

			local var_64_2 = iter_64_1.current_state.state_name

			if arg_64_1[iter_64_0] == nil and var_64_2 ~= "InGame" and var_64_2 ~= "InPostGame" and var_64_2 ~= "Disconnected" and var_64_2 ~= "Disconnecting" then
				return false
			end
		until true
	end

	return true
end

function NetworkServer.disconnect_joining_peers(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0.peer_state_machines

	for iter_65_0, iter_65_1 in pairs(var_65_0) do
		local var_65_1 = iter_65_1.current_state.state_name

		if var_65_1 ~= "InGame" and var_65_1 ~= "InPostGame" and var_65_1 ~= "Disconnected" and var_65_1 ~= "Disconnecting" then
			if arg_65_1 then
				arg_65_0:disconnect_peer(iter_65_0, arg_65_1)
			else
				arg_65_0:disconnect_peer(iter_65_0, "host_left_game")
			end
		end
	end
end

function NetworkServer.is_peer_ingame(arg_66_0, arg_66_1)
	return arg_66_0._network_state:is_peer_ingame(arg_66_1)
end

function NetworkServer.are_all_peers_ready(arg_67_0)
	local var_67_0 = arg_67_0.peer_state_machines

	for iter_67_0 in pairs(var_67_0) do
		if not arg_67_0:is_peer_ready(iter_67_0) then
			return false
		end
	end

	return true
end

function NetworkServer.is_peer_ready(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_0.peer_state_machines[arg_68_1]

	if not var_68_0 then
		return true
	end

	local var_68_1 = var_68_0.current_state.state_name

	if var_68_1 ~= "WaitingForPlayers" and var_68_1 ~= "InGame" and var_68_1 ~= "Disconnected" then
		return false
	end

	return true
end

function NetworkServer.all_client_peers_disconnected(arg_69_0)
	local var_69_0 = arg_69_0.peer_state_machines

	for iter_69_0, iter_69_1 in pairs(var_69_0) do
		local var_69_1 = iter_69_1.current_state.state_name

		if iter_69_0 ~= arg_69_0.my_peer_id and var_69_1 ~= "Disconnected" then
			return false
		end
	end

	return true
end

function NetworkServer.waiting_to_enter_game(arg_70_0)
	if DEDICATED_SERVER then
		return true
	end

	local var_70_0 = arg_70_0.peer_state_machines[arg_70_0.my_peer_id]

	if not var_70_0 then
		return false
	end

	if var_70_0.current_state.state_name == "WaitingForEnterGame" then
		return true
	end

	return false
end

function NetworkServer.disconnected(arg_71_0)
	local var_71_0 = arg_71_0.peer_state_machines
	local var_71_1 = arg_71_0.my_peer_id

	for iter_71_0, iter_71_1 in pairs(var_71_0) do
		if iter_71_0 == var_71_1 then
			local var_71_2 = iter_71_1.current_state.state_name

			if var_71_2 == "Disconnected" or var_71_2 == "Disconnecting" then
				return true
			end
		end
	end

	return false
end

function NetworkServer.peer_wanted_profile(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_0.peer_state_machines[arg_72_1].state_data
	local var_72_1 = var_72_0.wanted_profile_index
	local var_72_2 = var_72_0.wanted_career_index

	return var_72_1, var_72_2
end

function NetworkServer.register_shared_state(arg_73_0, arg_73_1)
	arg_73_0._shared_states[#arg_73_0._shared_states + 1] = arg_73_1
end

function NetworkServer.deregister_shared_state(arg_74_0, arg_74_1)
	local var_74_0 = table.index_of(arg_74_1)

	if var_74_0 ~= -1 then
		table.swap_delete(arg_74_0._shared_states, var_74_0)
	end
end

function NetworkServer.get_peers(arg_75_0)
	return arg_75_0._network_state and arg_75_0._network_state:get_peers() or {}
end

function NetworkServer.hot_join_sync_party_and_profiles(arg_76_0, arg_76_1)
	local var_76_0 = 1
	local var_76_1 = 0
	local var_76_2 = Managers.party

	var_76_2:hot_join_sync(arg_76_1, var_76_0)
	var_76_2:server_peer_hot_join_synced(arg_76_1)
	var_76_2:assign_peer_to_party(arg_76_1, var_76_0, var_76_1)
	arg_76_0.profile_synchronizer:hot_join_sync(arg_76_1)
end

function NetworkServer.set_side_order_state(arg_77_0, arg_77_1)
	if arg_77_0._network_state then
		arg_77_0._network_state:set_side_order_state(arg_77_1)
	end
end

function NetworkServer.get_side_order_state(arg_78_0, arg_78_1)
	return arg_78_0._network_state and arg_78_0._network_state:get_side_order_state()
end

function NetworkServer.get_network_state(arg_79_0)
	return arg_79_0._network_state
end

function NetworkServer.is_peer_hot_join_synced(arg_80_0, arg_80_1)
	return arg_80_0._network_state:is_peer_hot_join_synced(arg_80_1)
end

function NetworkServer.rpc_slot_reservation_request_peers(arg_81_0, arg_81_1)
	local var_81_0 = arg_81_0:active_peers()

	printf("[NetworkServer] Game host requested peers to reserve. Responding with (%s)", table.concat(var_81_0, ","))

	local var_81_1 = arg_81_0.my_peer_id

	RPC.rpc_provide_slot_reservation_info(arg_81_1, var_81_0, var_81_1)
end

function NetworkServer.rpc_slot_reservation_request_party_change(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	if not Managers.matchmaking:is_in_versus_custom_game_lobby() then
		printf("[NetworkServer] Ignored rpc_slot_reservation_request_party_change for %q because not in a hierarchical matchmaking state.", arg_82_2)

		return
	end

	local var_82_0 = arg_82_0._match_handler:get_match_owner()

	if var_82_0 == arg_82_0.my_peer_id then
		local var_82_1 = Managers.mechanism:game_mechanism()

		if var_82_1.get_slot_reservation_handler then
			(var_82_1:get_slot_reservation_handler(var_82_0, var_0_0.pending_custom_game) or var_82_1:get_slot_reservation_handler(var_82_0, var_0_0.session)):move_player(arg_82_2, arg_82_3)
		end
	else
		local var_82_2 = PEER_ID_TO_CHANNEL[var_82_0]

		RPC.rpc_slot_reservation_request_party_change(var_82_2, arg_82_2, arg_82_3)
	end
end

function NetworkServer.get_match_handler(arg_83_0)
	return arg_83_0._match_handler
end

function NetworkServer.get_bot_profile(arg_84_0, arg_84_1, arg_84_2)
	return arg_84_0._network_state:get_bot_profile(arg_84_1, arg_84_2)
end

function NetworkServer.set_bot_profile(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
	arg_85_0._network_state:set_bot_profile(arg_85_1, arg_85_2, arg_85_3, arg_85_4)
end

function NetworkServer.set_session_breed_map(arg_86_0, arg_86_1)
	arg_86_0._network_state:set_session_breed_map(arg_86_1)
end

function NetworkServer.get_session_breed_map(arg_87_0)
	return arg_87_0._network_state:get_session_breed_map()
end

function NetworkServer.get_loaded_session_breeds(arg_88_0, arg_88_1)
	return arg_88_0._network_state:get_loaded_session_breed_map(arg_88_1)
end

function NetworkServer.get_own_loaded_session_breed_map(arg_89_0)
	return arg_89_0._network_state:get_own_loaded_session_breed_map()
end

function NetworkServer.set_own_loaded_session_breeds(arg_90_0, arg_90_1)
	arg_90_0._network_state:set_own_loaded_session_breeds(arg_90_1)
end

function NetworkServer.set_startup_breeds(arg_91_0, arg_91_1)
	arg_91_0._network_state:set_startup_breeds(arg_91_1)
end

function NetworkServer.get_session_pickup_map(arg_92_0)
	return arg_92_0._network_state:get_session_pickup_map()
end

function NetworkServer.set_session_pickup_map(arg_93_0, arg_93_1)
	arg_93_0._network_state:set_session_pickup_map(arg_93_1)
end

function NetworkServer.get_own_loaded_session_pickup_map(arg_94_0)
	return arg_94_0._network_state:get_own_loaded_session_pickup_map()
end

function NetworkServer.set_own_loaded_session_pickups(arg_95_0, arg_95_1)
	arg_95_0._network_state:set_own_loaded_session_pickups(arg_95_1)
end

function NetworkServer.get_loaded_session_pickups(arg_96_0, arg_96_1)
	return arg_96_0._network_state:get_loaded_session_pickup_map(arg_96_1)
end

function NetworkServer.get_game_mode_event_data(arg_97_0)
	return arg_97_0._network_state:get_game_mode_event_data()
end

function NetworkServer.has_unlocked_dlc(arg_98_0, arg_98_1, arg_98_2)
	return arg_98_0._network_state:get_unlocked_dlcs_set(arg_98_1)[arg_98_2]
end

function NetworkServer.get_initialized_mutator_map(arg_99_0)
	return arg_99_0._network_state:get_initialized_mutator_map()
end

function NetworkServer.get_loaded_mutator_map(arg_100_0, arg_100_1)
	return arg_100_0._network_state:get_loaded_mutator_map(arg_100_1)
end

function NetworkServer.get_own_loaded_mutator_map(arg_101_0)
	return arg_101_0._network_state:get_own_loaded_mutator_map()
end

function NetworkServer.set_own_loaded_mutator_map(arg_102_0, arg_102_1)
	arg_102_0._network_state:set_own_loaded_mutator_map(arg_102_1)
end

function NetworkServer.state_revision(arg_103_0)
	return arg_103_0._network_state:get_revision()
end
