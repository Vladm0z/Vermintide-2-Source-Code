-- chunkname: @scripts/network/network_client.lua

require("scripts/game_state/components/profile_synchronizer")
require("scripts/game_state/components/network_state")
require("scripts/utils/profile_requester")
require("scripts/network/network_match_handler")

NetworkClientStates = table.enum("connecting", "connected", "loading", "loaded", "waiting_enter_game", "game_started", "is_ingame", "denied_enter_game", "lost_connection_to_host", "eac_match_failed")
NetworkClient = class(NetworkClient)

local var_0_0 = #PROFILES_BY_AFFILIATION.heroes
local var_0_1 = 15

script_data.network_debug_connections = true

local function var_0_2(arg_1_0, ...)
	if script_data.network_debug_connections then
		printf("[NetworkClient] " .. arg_1_0, ...)
	end
end

function NetworkClient.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0:set_state(NetworkClientStates.connecting)

	arg_2_0.server_peer_id = arg_2_1
	arg_2_0.my_peer_id = Network.peer_id()
	PEER_ID_TO_CHANNEL[arg_2_0.my_peer_id] = 0
	CHANNEL_TO_PEER_ID[0] = arg_2_0.my_peer_id
	arg_2_0._network_state = NetworkState:new(false, arg_2_0, arg_2_1, arg_2_0.my_peer_id)

	Managers.level_transition_handler:register_network_state(arg_2_0._network_state)

	local var_2_0 = false

	arg_2_0.profile_synchronizer = ProfileSynchronizer:new(false, arg_2_5, arg_2_0._network_state)
	arg_2_0._profile_requester = ProfileRequester:new(false, nil, arg_2_0.profile_synchronizer)
	arg_2_0.wanted_profile_index = FindProfileIndex(Development.parameter("wanted_profile")) or arg_2_2 or SaveData.wanted_profile_index or 1
	arg_2_0.wanted_party_index = tonumber(Development.parameter("wanted_party_index")) or arg_2_3

	if arg_2_0.wanted_profile_index then
		local var_2_1 = SPProfiles[arg_2_0.wanted_profile_index]

		if var_2_1 and var_2_1.affiliation == "dark_pact" then
			arg_2_0.wanted_party_index = 2
		end
	end

	Managers.mechanism:set_profile_synchronizer(arg_2_0.profile_synchronizer)

	local var_2_2 = SPProfiles[arg_2_0.wanted_profile_index]

	if var_2_2 then
		local var_2_3 = var_2_2.display_name
		local var_2_4 = Managers.backend:get_interface("hero_attributes")

		arg_2_0.wanted_career_index = Development.parameter("wanted_career_index") or var_2_4:get(var_2_3, "career") or 1
	else
		arg_2_0.wanted_career_index = 0
	end

	arg_2_0.lobby_client = arg_2_5

	local var_2_5 = var_2_2 and var_2_2.display_name or "no profile wanted"

	var_0_2("init - wanted_profile_index, %s, %s", arg_2_0.wanted_profile_index, var_2_5)

	if arg_2_4 then
		var_0_2("SENDING rpc_clear_peer_state to %s", arg_2_0.server_peer_id)

		local var_2_6 = PEER_ID_TO_CHANNEL[arg_2_0.server_peer_id]

		RPC.rpc_clear_peer_state(var_2_6)
	end

	if arg_2_6 then
		arg_2_0.voip = arg_2_6
	else
		arg_2_0.voip = Voip:new(var_2_0, arg_2_5)
	end

	arg_2_0.connecting_timeout = 0
	arg_2_0._match_handler = NetworkMatchHandler:new(arg_2_0, false, arg_2_0.my_peer_id, arg_2_0.server_peer_id, arg_2_5)

	Managers.mechanism:set_network_client(arg_2_0)
end

function NetworkClient.destroy(arg_3_0)
	if Managers.eac:eac_ready_locally() then
		Managers.eac:after_leave()
	end

	arg_3_0._match_handler:destroy()
	Managers.mechanism:set_network_client(nil)
	Managers.level_transition_handler:deregister_network_state()

	if arg_3_0._network_event_delegate then
		arg_3_0:unregister_rpcs()
	end

	arg_3_0._network_state:destroy()
	arg_3_0.voip:destroy()

	arg_3_0.voip = nil

	arg_3_0._profile_requester:destroy()

	arg_3_0._profile_requester = nil

	arg_3_0.profile_synchronizer:destroy()

	arg_3_0.profile_synchronizer = nil
	arg_3_0.lobby_client = nil

	GarbageLeakDetector.register_object(arg_3_0, "Network Client")
end

function NetworkClient.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	arg_4_1:register(arg_4_0, "rpc_loading_synced", "rpc_notify_in_post_game", "rpc_game_started", "rpc_connection_failed", "rpc_notify_connected", IS_XB1 and "rpc_set_migration_host_xbox" or "rpc_set_migration_host", "rpc_client_update_lobby_data", "rpc_client_connection_state", "rpc_slot_reservation_request_peers")

	arg_4_0._network_event_delegate = arg_4_1

	arg_4_0._network_state:register_rpcs(arg_4_1, arg_4_2)
	arg_4_0.profile_synchronizer:register_rpcs(arg_4_1, arg_4_2)
	arg_4_0._profile_requester:register_rpcs(arg_4_1, arg_4_2)
	arg_4_0.voip:register_rpcs(arg_4_1, arg_4_2)
	arg_4_0._match_handler:register_rpcs(arg_4_1, arg_4_2)
	arg_4_0._match_handler:sync_data_up()
end

function NetworkClient.unregister_rpcs(arg_5_0)
	arg_5_0.voip:unregister_rpcs()
	arg_5_0._profile_requester:unregister_rpcs()
	arg_5_0._network_event_delegate:unregister(arg_5_0)

	arg_5_0._network_event_delegate = nil

	arg_5_0.profile_synchronizer:unregister_network_events()
	arg_5_0._network_state:unregister_network_events()
	arg_5_0._match_handler:unregister_rpcs()
end

function NetworkClient.rpc_connection_failed(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.fail_reason = NetworkLookup.connection_fails[arg_6_2]

	var_0_2("rpc_connection_failed due to %s", arg_6_0.fail_reason)
	arg_6_0:set_state(NetworkClientStates.denied_enter_game)
	var_0_2("Connection to server failed with reason %s", arg_6_0.fail_reason)
end

function NetworkClient.rpc_notify_connected(arg_7_0, arg_7_1)
	if not arg_7_0._notification_sent then
		local var_7_0 = "peer_to_peer"

		if arg_7_0.lobby_client:is_dedicated_server() then
			var_7_0 = "client_server"
		end

		Managers.eac:before_join(var_7_0)

		local var_7_1 = PEER_ID_TO_CHANNEL[arg_7_0.server_peer_id]

		Managers.eac:set_host(arg_7_0.server_peer_id)
		RPC.rpc_notify_lobby_joined(var_7_1, arg_7_0.wanted_profile_index, arg_7_0.wanted_career_index, arg_7_0.wanted_party_index or 0, Application.user_setting("clan_tag") or "0", Managers.account:account_id() or "0")

		arg_7_0._notification_sent = true

		arg_7_0:set_state(NetworkClientStates.connected)
		arg_7_0._network_state:full_sync()

		if arg_7_0.loaded_level_name then
			local var_7_2 = arg_7_0.loaded_level_name

			RPC.rpc_level_loaded(arg_7_0.channel_id, NetworkLookup.level_keys[var_7_2])

			arg_7_0.loaded_level_name = nil
		end
	end
end

function NetworkClient.is_network_state_fully_synced_for_peer(arg_8_0, arg_8_1)
	if not Managers.mechanism:is_peer_fully_synced(arg_8_1) then
		return false
	end

	return arg_8_0._network_state:is_peer_fully_synced(arg_8_1)
end

function NetworkClient.is_fully_synced(arg_9_0)
	local var_9_0 = arg_9_0.my_peer_id

	if not Managers.mechanism:is_peer_fully_synced(var_9_0) then
		return false
	end

	return arg_9_0._network_state:is_peer_fully_synced(var_9_0)
end

function NetworkClient.rpc_notify_in_post_game(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0._is_in_post_game ~= arg_10_2 then
		arg_10_0._is_in_post_game = arg_10_2

		local var_10_0 = PEER_ID_TO_CHANNEL[arg_10_0.server_peer_id]

		RPC.rpc_post_game_notified(var_10_0, arg_10_2)
	end
end

function NetworkClient.is_in_post_game(arg_11_0)
	return arg_11_0._is_in_post_game
end

function NetworkClient.rpc_client_connection_state(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = NetworkLookup.connection_states[arg_12_3]

	printf("rpc_client_connection_state Channel: %d, PeerID: %s, Reason: %s", arg_12_1, arg_12_2, var_12_0)

	if var_12_0 == "connected" then
		NetworkUtils.announce_chat_peer_joined(arg_12_2, arg_12_0.lobby_client)
	elseif var_12_0 == "disconnected" then
		NetworkUtils.announce_chat_peer_left(arg_12_2, arg_12_0.lobby_client)
	end
end

function NetworkClient.rpc_loading_synced(arg_13_0, arg_13_1)
	var_0_2("rpc_loading_synced. State: %q", arg_13_0.state)

	if arg_13_0.state ~= NetworkClientStates.game_started then
		arg_13_0:set_state(NetworkClientStates.waiting_enter_game)
	else
		arg_13_0._rpc_loading_synced = true
	end
end

function NetworkClient.rpc_set_migration_host(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_3 then
		local var_14_0 = Managers.player:player_from_peer_id(arg_14_2)
		local var_14_1 = var_14_0 and var_14_0:name() or tostring(arg_14_2)

		arg_14_0.host_to_migrate_to = {
			peer_id = arg_14_2,
			name = var_14_1
		}
	else
		arg_14_0.host_to_migrate_to = nil
	end
end

function NetworkClient.rpc_set_migration_host_xbox(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_3 then
		local var_15_0 = Managers.player:player_from_peer_id(arg_15_2)
		local var_15_1 = var_15_0 and var_15_0:name() or tostring(arg_15_2)

		arg_15_0.host_to_migrate_to = {
			peer_id = arg_15_2,
			name = var_15_1,
			session_id = arg_15_4,
			session_template_name = arg_15_5
		}
	else
		arg_15_0.host_to_migrate_to = nil
	end
end

function NetworkClient.rpc_client_update_lobby_data(arg_16_0, arg_16_1)
	arg_16_0.lobby_client:force_update_lobby_data()
end

function NetworkClient.set_state(arg_17_0, arg_17_1)
	var_0_2("New State %s (old state %s)", arg_17_1, tostring(arg_17_0.state))

	arg_17_0.state = arg_17_1
end

function NetworkClient.has_bad_state(arg_18_0)
	local var_18_0 = arg_18_0.state

	return var_18_0 == NetworkClientStates.denied_enter_game or var_18_0 == NetworkClientStates.lost_connection_to_host or var_18_0 == NetworkClientStates.eac_match_failed, var_18_0
end

function NetworkClient.on_game_entered(arg_19_0)
	arg_19_0:set_state(NetworkClientStates.is_ingame)

	local var_19_0 = PEER_ID_TO_CHANNEL[arg_19_0.server_peer_id]

	Managers.account:update_presence()
	RPC.rpc_is_ingame(var_19_0)
end

function NetworkClient.request_profile(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_0._profile_requester:request_profile(arg_20_0.my_peer_id, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
end

function NetworkClient.profile_requester(arg_21_0)
	return arg_21_0._profile_requester
end

function NetworkClient.rpc_game_started(arg_22_0, arg_22_1, arg_22_2)
	Application.error(string.format("SETTING ROUND ID %s", tostring(arg_22_2)))

	if IS_XB1 then
		Managers.account:set_round_id(arg_22_2)
	end

	var_0_2("rpc_game_started")
	arg_22_0:set_state(NetworkClientStates.game_started)
	Managers.state.event:trigger("game_started")
end

function NetworkClient.on_level_loaded(arg_23_0, arg_23_1)
	var_0_2("on_level_loaded %s", arg_23_1)

	if arg_23_0.state ~= NetworkClientStates.connecting then
		local var_23_0 = PEER_ID_TO_CHANNEL[arg_23_0.server_peer_id]

		if var_23_0 then
			RPC.rpc_level_loaded(var_23_0, NetworkLookup.level_keys[arg_23_1])
		end
	else
		arg_23_0.loaded_level_name = arg_23_1
	end
end

function NetworkClient._update_connections(arg_24_0)
	local var_24_0 = PEER_ID_TO_CHANNEL[arg_24_0.server_peer_id]

	if not var_24_0 then
		return
	end

	local var_24_1, var_24_2 = Network.channel_state(var_24_0)

	if var_24_1 ~= arg_24_0._server_channel_state then
		if var_24_1 == "disconnected" then
			arg_24_0.fail_reason = var_24_2

			printf("broken_connection to %s", arg_24_0.server_peer_id)
			Crashify.print_exception("Disconnected", "broken connection to server: " .. tostring(var_24_2))
			arg_24_0:set_state(NetworkClientStates.lost_connection_to_host)
		end

		arg_24_0._server_channel_state = var_24_1
	end
end

function NetworkClient.update(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0._profile_requester:update(arg_25_1)
	arg_25_0.profile_synchronizer:update()
	arg_25_0:_update_connections()

	if not arg_25_0.wait_for_state_loading and arg_25_0.state == NetworkClientStates.loading and Managers.eac:eac_ready_locally() then
		local var_25_0, var_25_1 = Managers.eac:check_host()
		local var_25_2 = Managers.level_transition_handler

		if var_25_0 and var_25_1 and var_25_2:all_packages_loaded() then
			var_0_2("All level packages loaded!")

			if arg_25_0._rpc_loading_synced then
				arg_25_0:set_state(NetworkClientStates.waiting_enter_game)

				arg_25_0._rpc_loading_synced = false
			else
				arg_25_0:set_state(NetworkClientStates.loaded)
			end

			arg_25_0:on_level_loaded(var_25_2:get_current_level_keys())
		end
	end

	if arg_25_0.state == NetworkClientStates.connecting then
		arg_25_0.connecting_timeout = arg_25_0.connecting_timeout + arg_25_1

		if arg_25_0.connecting_timeout > var_0_1 then
			arg_25_0.connecting_timeout = 0
			arg_25_0.fail_reason = "broken_connection"

			var_0_2("connection timeout leading to broken_connection")
			arg_25_0:set_state(NetworkClientStates.denied_enter_game)
		end
	end

	arg_25_0:_update_eac_match()
	arg_25_0.voip:update(arg_25_1, arg_25_2)
end

function NetworkClient._update_eac_match(arg_26_0)
	if arg_26_0:has_bad_state() or not arg_26_0._notification_sent then
		return
	end

	local var_26_0 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if var_26_0 and var_26_0:is_dedicated_server() then
		return
	end

	if Managers.eac:eac_ready_locally() then
		local var_26_1, var_26_2 = Managers.eac:check_host()

		if not var_26_2 then
			printf("eac mismatch leading to eac_authorize_failed")

			arg_26_0.fail_reason = "eac_authorize_failed"

			arg_26_0:set_state(NetworkClientStates.eac_match_failed)
		end
	end
end

function NetworkClient.can_enter_game(arg_27_0)
	return arg_27_0.state == NetworkClientStates.waiting_enter_game
end

function NetworkClient.is_ingame(arg_28_0)
	return arg_28_0.state == NetworkClientStates.is_ingame or arg_28_0.state == NetworkClientStates.game_started
end

function NetworkClient.set_wait_for_state_loading(arg_29_0, arg_29_1)
	arg_29_0.wait_for_state_loading = arg_29_1
end

function NetworkClient.is_peer_ingame(arg_30_0, arg_30_1)
	return arg_30_0._network_state:is_peer_ingame(arg_30_1)
end

function NetworkClient.get_peers(arg_31_0)
	return arg_31_0._network_state and arg_31_0._network_state:get_peers() or {}
end

function NetworkClient.get_side_order_state(arg_32_0)
	return arg_32_0._network_state and arg_32_0._network_state:get_side_order_state()
end

function NetworkClient.get_network_state(arg_33_0)
	return arg_33_0._network_state
end

function NetworkClient.is_peer_hot_join_synced(arg_34_0, arg_34_1)
	return arg_34_0._network_state:is_peer_hot_join_synced(arg_34_1)
end

function NetworkClient.rpc_slot_reservation_request_peers(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.my_peer_id

	printf("[NetworkClient] Game host requested peers to reserve. Responding with (%s)", var_35_0)
	RPC.rpc_provide_slot_reservation_info(arg_35_1, {
		var_35_0
	}, arg_35_0.server_peer_id)
end

function NetworkClient.get_match_handler(arg_36_0)
	return arg_36_0._match_handler
end

function NetworkClient.get_session_breed_map(arg_37_0)
	return arg_37_0._network_state:get_session_breed_map()
end

function NetworkClient.get_loaded_session_breeds(arg_38_0, arg_38_1)
	return arg_38_0._network_state:get_loaded_session_breed_map(arg_38_1)
end

function NetworkClient.get_own_loaded_session_breed_map(arg_39_0)
	return arg_39_0._network_state:get_own_loaded_session_breed_map()
end

function NetworkClient.set_own_loaded_session_breeds(arg_40_0, arg_40_1)
	arg_40_0._network_state:set_own_loaded_session_breeds(arg_40_1)
end

function NetworkClient.get_startup_breeds(arg_41_0)
	return arg_41_0._network_state:get_startup_breeds()
end

function NetworkClient.get_session_pickup_map(arg_42_0)
	return arg_42_0._network_state:get_session_pickup_map()
end

function NetworkClient.get_own_loaded_session_pickup_map(arg_43_0)
	return arg_43_0._network_state:get_own_loaded_session_pickup_map()
end

function NetworkClient.set_own_loaded_session_pickups(arg_44_0, arg_44_1)
	arg_44_0._network_state:set_own_loaded_session_pickups(arg_44_1)
end

function NetworkClient.get_loaded_session_pickups(arg_45_0, arg_45_1)
	return arg_45_0._network_state:get_loaded_session_pickup_map(arg_45_1)
end

function NetworkClient.get_initialized_mutator_map(arg_46_0)
	return arg_46_0._network_state:get_initialized_mutator_map()
end

function NetworkClient.get_game_mode_event_data(arg_47_0)
	return arg_47_0._network_state:get_game_mode_event_data()
end

function NetworkClient.has_unlocked_dlc(arg_48_0, arg_48_1, arg_48_2)
	return arg_48_0._network_state:get_unlocked_dlcs_set(arg_48_1)[arg_48_2]
end

function NetworkClient.get_loaded_mutator_map(arg_49_0, arg_49_1)
	return arg_49_0._network_state:get_loaded_mutator_map(arg_49_1)
end

function NetworkClient.get_own_loaded_mutator_map(arg_50_0)
	return arg_50_0._network_state:get_own_loaded_mutator_map()
end

function NetworkClient.set_own_loaded_mutator_map(arg_51_0, arg_51_1)
	arg_51_0._network_state:set_own_loaded_mutator_map(arg_51_1)
end

function NetworkClient.state_revision(arg_52_0)
	return arg_52_0._network_state:get_revision()
end
