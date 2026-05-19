-- chunkname: @scripts/network/peer_states.lua

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

PeerStates = {}
SlotReservationConnectStatus = table.enum("PENDING", "FAILED", "SUCCEEDED")

local var_0_1 = 2

PeerStates.Connecting = {
	approved_for_joining = false,
	on_enter = function(arg_1_0, arg_1_1)
		Network.write_dump_tag(string.format("%s connecting", arg_1_0.peer_id))
		arg_1_0.server.network_transmit:send_rpc("rpc_notify_connected", arg_1_0.peer_id)

		arg_1_0.loaded_level = nil
		arg_1_0.resend_timer = var_0_1
		arg_1_0.resend_post_game_timer = var_0_1
	end,
	rpc_notify_lobby_joined = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		arg_2_0.num_players = 1
		arg_2_0.has_received_rpc_notify_lobby_joined = true
		arg_2_0.clan_tag = arg_2_4
		arg_2_0.account_id = arg_2_5

		printf("[PSM] Peer %s joined. Want to use profile index %q and join party %q", tostring(arg_2_0.peer_id), tostring(arg_2_1), tostring(arg_2_3))

		arg_2_0.wanted_profile_index = arg_2_1
		arg_2_0.wanted_career_index = arg_2_2
		arg_2_0.requested_party_index = arg_2_3

		arg_2_0.server:peer_connected(arg_2_0.peer_id)

		if arg_2_0.is_remote and not arg_2_0.has_eac then
			Managers.eac:server_add_peer(arg_2_0.peer_id)

			arg_2_0.has_eac = true
		end
	end,
	rpc_post_game_notified = function(arg_3_0, arg_3_1)
		arg_3_0._has_been_notfied_of_post_game_state = true
		arg_3_0._in_post_game = arg_3_1
	end,
	rpc_level_loaded = function(arg_4_0, arg_4_1)
		arg_4_0.loaded_level = NetworkLookup.level_keys[arg_4_1]
	end,
	rpc_provide_slot_reservation_info = function(arg_5_0, arg_5_1, arg_5_2)
		arg_5_0.server:get_match_handler():register_pending_peer(arg_5_0.peer_id, arg_5_2)

		local var_5_0 = Managers.mechanism

		;(var_5_0:get_slot_reservation_handler(arg_5_0.server.my_peer_id, var_0_0.pending_custom_game) or var_5_0:get_slot_reservation_handler(arg_5_0.server.my_peer_id, var_0_0.session)):connecting_slot_reservation_info_received(arg_5_0.peer_id, arg_5_1, arg_5_2)
	end,
	update = function(arg_6_0, arg_6_1)
		local var_6_0 = Managers.ban_list

		if var_6_0 ~= nil and var_6_0:is_banned(arg_6_0.peer_id) then
			printf("[PSM] Disconnecting banned player (%s)", arg_6_0.peer_id)
			arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "client_is_banned")

			return PeerStates.Disconnecting
		end

		if Managers.level_transition_handler:get_current_level_key() == "prologue" and arg_6_0.peer_id ~= arg_6_0.server.my_peer_id then
			arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "host_plays_prologue")

			return PeerStates.Disconnecting
		end

		if arg_6_0.server.lobby_host:lost_connection_to_lobby() and arg_6_0.peer_id ~= arg_6_0.server.my_peer_id then
			printf("[PSM] Disconnecting player (%s) due to no connection with our own lobby", arg_6_0.peer_id)
			arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "host_left_game")

			return PeerStates.Disconnecting
		end

		if not Managers.backend:signed_in() then
			printf("[PSM] Disconnecting player (%s) due to no connection with backend", arg_6_0.peer_id)
			arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "host_has_no_backend_connection")

			return PeerStates.Disconnecting
		end

		local var_6_1 = SlotReservationConnectStatus.SUCCEEDED

		if arg_6_0.is_remote then
			local var_6_2 = Managers.mechanism
			local var_6_3 = var_6_2:get_slot_reservation_handler(arg_6_0.server.my_peer_id, var_0_0.pending_custom_game) or var_6_2:get_slot_reservation_handler(arg_6_0.server.my_peer_id, var_0_0.session)

			if var_6_3 then
				var_6_1 = var_6_3:handle_slot_reservation_for_connecting_peer(arg_6_0, arg_6_1)
			else
				local var_6_4 = arg_6_0.server:get_match_handler()

				if not var_6_4:has_peer_data(arg_6_0.peer_id) then
					var_6_4:register_pending_peer(arg_6_0.peer_id, arg_6_0.server.my_peer_id)
				end
			end
		end

		if var_6_1 == SlotReservationConnectStatus.SUCCEEDED then
			if not arg_6_0.has_received_rpc_notify_lobby_joined then
				arg_6_0.resend_timer = arg_6_0.resend_timer - arg_6_1

				if arg_6_0.resend_timer < 0 then
					if PEER_ID_TO_CHANNEL[arg_6_0.peer_id] then
						local var_6_5 = Managers.state.game_mode and Managers.state.game_mode:game_mode()

						if var_6_5 and var_6_5:is_joinable() then
							arg_6_0.server.network_transmit:send_rpc("rpc_notify_connected", arg_6_0.peer_id)

							arg_6_0.resend_timer = var_0_1
						end
					else
						print("PeerState.Connecting lost connection, cannot send rpc_notify_connected")

						return PeerStates.Disconnecting
					end
				end
			end
		elseif var_6_1 == SlotReservationConnectStatus.FAILED then
			printf("[PSM] Disconnecting player (%s) due to not being able to reserve slots", arg_6_0.peer_id)
			arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "host_has_no_backend_connection")

			return PeerStates.Disconnecting
		else
			return
		end

		if not Development.parameter("allow_weave_joining") then
			local var_6_6 = arg_6_0.server.lobby_host
			local var_6_7 = var_6_6:lobby_data("mechanism")
			local var_6_8 = var_6_6:lobby_data("matchmaking")
			local var_6_9 = var_6_6:lobby_data("matchmaking_type")
			local var_6_10 = "n/a"

			if var_6_9 then
				local var_6_11

				var_6_11 = IS_PS4 and var_6_9 or NetworkLookup.matchmaking_types[tonumber(var_6_9)]
			end

			if var_6_7 == "weave" and var_6_8 == "false" then
				local var_6_12 = Managers.weave:get_player_ids()

				if var_6_12 then
					if not var_6_12[arg_6_0.peer_id] then
						arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "cannot_join_weave")

						return PeerStates.Disconnecting
					end
				else
					arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "cannot_join_weave")

					return PeerStates.Disconnecting
				end
			end
		end

		local var_6_13 = arg_6_0.server:is_in_post_game()

		if arg_6_0._has_been_notfied_of_post_game_state then
			if not var_6_13 then
				if arg_6_0._in_post_game then
					arg_6_0._has_been_notfied_of_post_game_state = nil
				elseif arg_6_0.has_received_rpc_notify_lobby_joined then
					local var_6_14 = arg_6_0.server:num_joining_peers()
					local var_6_15 = arg_6_0.server:num_active_peers() - var_6_14

					if arg_6_0.server.lobby_host:get_max_members() < var_6_15 + 1 then
						printf("[PSM] No free slots and peer not reserved, disconnecting peer (%s)", arg_6_0.peer_id)
						arg_6_0.server:disconnect_peer(arg_6_0.peer_id, "full_server")

						return PeerStates.Disconnecting
					end

					if arg_6_0.peer_id == Network.peer_id() then
						arg_6_0.server:hot_join_sync_party_and_profiles(arg_6_0.peer_id)

						arg_6_0.has_hot_join_synced_party_and_profile = true
					end

					return PeerStates.Loading
				end
			end
		else
			arg_6_0.resend_post_game_timer = arg_6_0.resend_post_game_timer - arg_6_1

			if arg_6_0.resend_post_game_timer < 0 then
				arg_6_0.server.network_transmit:send_rpc("rpc_notify_in_post_game", arg_6_0.peer_id, var_6_13)

				arg_6_0.resend_post_game_timer = var_0_1
			end
		end
	end,
	rpc_level_load_started = function(arg_7_0, arg_7_1)
		if not arg_7_0.has_hot_join_synced_party_and_profile then
			arg_7_0.server:hot_join_sync_party_and_profiles(arg_7_0.peer_id)

			arg_7_0.has_hot_join_synced_party_and_profile = true
		end
	end,
	on_exit = function(arg_8_0, arg_8_1)
		arg_8_0._has_been_notfied_of_post_game_state = nil
		arg_8_0.has_received_rpc_notify_lobby_joined = nil
		arg_8_0._in_post_game = nil
	end
}
PeerStates.Loading = {
	approved_for_joining = true,
	on_enter = function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_0.peer_id

		Network.write_dump_tag(string.format("%s loading", var_9_0))

		arg_9_0.game_started = false
		arg_9_0.is_ingame = nil

		Managers.level_transition_handler.transient_package_loader:hot_join_sync(var_9_0)
	end,
	rpc_is_ingame = function(arg_10_0)
		print("[PSM] Got rpc_is_ingame in PeerStates.Loading, is that ok?")

		arg_10_0.is_ingame = true
	end,
	rpc_level_load_started = function(arg_11_0, arg_11_1)
		if not arg_11_0.has_hot_join_synced_party_and_profile then
			arg_11_0.server:hot_join_sync_party_and_profiles(arg_11_0.peer_id)

			arg_11_0.has_hot_join_synced_party_and_profile = true
		end
	end,
	rpc_level_loaded = function(arg_12_0, arg_12_1)
		arg_12_0.loaded_level = NetworkLookup.level_keys[arg_12_1]

		local var_12_0 = Managers.level_transition_handler.enemy_package_loader:load_sync_done_for_peer(arg_12_0.peer_id)
		local var_12_1 = Managers.level_transition_handler.pickup_package_loader:load_sync_done_for_peer(arg_12_0.peer_id)
		local var_12_2 = Managers.level_transition_handler.general_synced_package_loader:load_sync_done_for_peer(arg_12_0.peer_id)

		if var_12_0 and var_12_1 and var_12_2 then
			printf("Peer %s has loaded the level and all enemies and pickups are loaded", arg_12_0.peer_id)
		else
			printf("Peer %s has loaded the level but we wait because: Enemies loaded (%s), Pickups loaded (%s), General packages loaded: (%s)", arg_12_0.peer_id, var_12_0, var_12_1, var_12_2)
		end
	end,
	rpc_provide_slot_reservation_info = function(arg_13_0, arg_13_1, arg_13_2)
		Managers.mechanism:get_slot_reservation_handler(arg_13_0.server.my_peer_id, var_0_0.session):connecting_slot_reservation_info_received(arg_13_0.peer_id, arg_13_1, arg_13_2)
	end,
	update = function(arg_14_0, arg_14_1)
		if arg_14_0.is_remote then
			local var_14_0 = Managers.mechanism

			if var_14_0:get_slot_reservation_handler(arg_14_0.server.my_peer_id, var_0_0.pending_custom_game) then
				local var_14_1 = var_14_0:get_slot_reservation_handler(arg_14_0.server.my_peer_id, var_0_0.session):handle_slot_reservation_for_connecting_peer(arg_14_0, arg_14_1)

				if var_14_1 == SlotReservationConnectStatus.FAILED then
					printf("[PSM] Failed to reserve joining player (%s) while hosting a custom game", arg_14_0.peer_id)
					arg_14_0.server:disconnect_peer(arg_14_0.peer_id, "host_has_no_backend_connection")

					return PeerStates.Disconnecting
				end

				if var_14_1 ~= SlotReservationConnectStatus.SUCCEEDED then
					return
				end
			end
		end

		local var_14_2 = Managers.level_transition_handler
		local var_14_3 = var_14_2:get_current_level_key()

		if arg_14_0.loaded_level == var_14_3 then
			local var_14_4 = var_14_2.enemy_package_loader:load_sync_done_for_peer(arg_14_0.peer_id)
			local var_14_5 = var_14_2.pickup_package_loader:load_sync_done_for_peer(arg_14_0.peer_id)
			local var_14_6 = var_14_2.general_synced_package_loader:load_sync_done_for_peer(arg_14_0.peer_id)
			local var_14_7, var_14_8 = Managers.eac:server_check_peer(arg_14_0.peer_id)

			if var_14_4 and var_14_5 and var_14_6 and var_14_7 and var_14_8 then
				return PeerStates.LoadingProfilePackages
			end
		end
	end,
	on_exit = function(arg_15_0, arg_15_1)
		return
	end
}
PeerStates.LoadingProfilePackages = {
	approved_for_joining = true,
	on_enter = function(arg_16_0, arg_16_1)
		Network.write_dump_tag(string.format("%s loading profile packages", arg_16_0.peer_id))

		local var_16_0 = arg_16_0.server.profile_synchronizer
		local var_16_1 = arg_16_0.peer_id
		local var_16_2 = 1
		local var_16_3, var_16_4 = var_16_0:profile_by_peer(var_16_1, var_16_2)
		local var_16_5 = arg_16_0.wanted_profile_index
		local var_16_6 = arg_16_0.wanted_career_index
		local var_16_7 = arg_16_0.loaded_level
		local var_16_8 = LevelSettings[var_16_7]
		local var_16_9 = var_16_8 and var_16_8.game_mode == "tutorial"

		if var_16_9 then
			var_16_5 = TUTORIAL_PROFILE_INDEX
		elseif var_16_3 == TUTORIAL_PROFILE_INDEX then
			var_16_3 = nil
		end

		if var_16_3 and not var_16_9 then
			arg_16_0.wanted_profile_index = var_16_3
			arg_16_0.wanted_career_index = var_16_4
		elseif var_16_5 == 0 then
			local var_16_10 = arg_16_0.requested_party_index or 1

			arg_16_0.wanted_profile_index, arg_16_0.wanted_career_index = var_16_0:get_first_free_profile(var_16_10)
		elseif var_16_9 then
			-- block empty
		else
			arg_16_0.wanted_profile_index = var_16_5
			arg_16_0.wanted_career_index = var_16_6
		end
	end,
	rpc_is_ingame = function(arg_17_0)
		arg_17_0.is_ingame = true
	end,
	update = function(arg_18_0, arg_18_1)
		local var_18_0 = arg_18_0.server

		if var_18_0.profile_synchronizer:all_synced() then
			var_18_0.network_transmit:send_rpc("rpc_loading_synced", arg_18_0.peer_id)

			return PeerStates.WaitingForEnterGame
		end
	end,
	on_exit = function(arg_19_0, arg_19_1)
		return
	end
}

local function var_0_2(arg_20_0, arg_20_1)
	return not arg_20_0:are_profile_packages_fully_synced_for_peer(arg_20_1) or not Managers.level_transition_handler.enemy_package_loader:load_sync_done_for_peer(arg_20_1) or not Managers.level_transition_handler.pickup_package_loader:load_sync_done_for_peer(arg_20_1) or not Managers.level_transition_handler.general_synced_package_loader:load_sync_done_for_peer(arg_20_1)
end

PeerStates.WaitingForEnterGame = {
	approved_for_joining = true,
	on_enter = function(arg_21_0, arg_21_1)
		Network.write_dump_tag(string.format("%s waiting for enter game", arg_21_0.peer_id))
	end,
	rpc_is_ingame = function(arg_22_0)
		arg_22_0.is_ingame = true
	end,
	update = function(arg_23_0, arg_23_1)
		local var_23_0 = arg_23_0.server

		if arg_23_0.is_ingame and var_23_0.game_network_manager and var_23_0.game_network_manager:game_session_host() then
			local var_23_1 = arg_23_0.peer_id

			if not var_23_0.peers_added_to_gamesession[var_23_1] then
				var_23_0.game_network_manager:set_peer_synchronizing(var_23_1)

				local var_23_2 = var_23_0.game_session
				local var_23_3 = var_23_0:is_network_state_fully_synced_for_peer(var_23_1) and not var_0_2(var_23_0, var_23_1)
				local var_23_4 = var_23_0.game_network_manager:in_game_session()

				if var_23_2 and var_23_4 and var_23_3 then
					if arg_23_0.is_remote then
						local var_23_5 = PEER_ID_TO_CHANNEL[var_23_1]

						GameSession.add_peer(var_23_2, var_23_5)

						var_23_0.peers_added_to_gamesession[var_23_1] = true
					end
				else
					return
				end
			end

			arg_23_0:change_state(PeerStates.WaitingForGameObjectSync)
		end
	end,
	on_exit = function(arg_24_0, arg_24_1)
		return
	end
}
PeerStates.WaitingForGameObjectSync = {
	approved_for_joining = true,
	on_enter = function(arg_25_0, arg_25_1)
		Network.write_dump_tag(string.format("%s waiting for game object sync", arg_25_0.peer_id))
	end,
	update = function(arg_26_0, arg_26_1)
		local var_26_0 = arg_26_0.peer_id

		if arg_26_0.server:has_peer_synced_game_objects(var_26_0) then
			if var_26_0 ~= arg_26_0.server.my_peer_id then
				if var_0_2(arg_26_0.server, var_26_0) then
					if not arg_26_0._printed_hot_join_sync_delay then
						printf("[PeerSM] %s :: Delaying hot join sync due to ongoing resync", var_26_0)

						arg_26_0._printed_hot_join_sync_delay = true
					end

					return
				end

				arg_26_0.server.game_network_manager:hot_join_sync(var_26_0)
				arg_26_0.server:set_peer_hot_join_synced(var_26_0, true)
			end

			if not arg_26_0.game_started then
				if IS_XB1 then
					arg_26_0.server.network_transmit:send_rpc("rpc_game_started", arg_26_0.peer_id, Managers.account:round_id() or "")
				else
					arg_26_0.server.network_transmit:send_rpc("rpc_game_started", arg_26_0.peer_id, "")
				end

				arg_26_0.game_started = true
			end

			if arg_26_0.is_remote then
				local var_26_1 = true
				local var_26_2 = 1

				Managers.player:add_remote_player(arg_26_0.peer_id, var_26_1, var_26_2, arg_26_0.clan_tag, arg_26_0.account_id)
			end

			local var_26_3 = arg_26_0.requested_party_index

			Managers.state.game_mode:player_entered_game_session(arg_26_0.peer_id, 1, var_26_3)

			return PeerStates.WaitingForPlayers
		end
	end,
	on_exit = function(arg_27_0, arg_27_1)
		return
	end
}
PeerStates.WaitingForPlayers = {
	approved_for_joining = true,
	on_enter = function(arg_28_0, arg_28_1)
		Network.write_dump_tag(string.format("%s waiting for players", arg_28_0.peer_id))
	end,
	update = function(arg_29_0, arg_29_1)
		local var_29_0 = Managers.state.entity:system("cutscene_system")

		if not var_29_0.cutscene_started then
			if arg_29_0.server:are_all_peers_ready() then
				return PeerStates.InGame
			end
		elseif var_29_0:has_intro_cutscene_finished_playing() then
			return PeerStates.InGame
		end
	end,
	on_exit = function(arg_30_0, arg_30_1)
		return
	end
}
PeerStates.InGame = {
	approved_for_joining = true,
	on_enter = function(arg_31_0, arg_31_1)
		Managers.account:update_presence()
		Network.write_dump_tag(string.format("%s in game", arg_31_0.peer_id))
	end,
	respawn_player = function(arg_32_0)
		assert(arg_32_0.despawned_player, "[PeerStates] - Trying to respawn player without having despawned the player.")

		arg_32_0.respawn_player = true
	end,
	despawned_player = function(arg_33_0)
		arg_33_0.despawned_player = true
	end,
	update = function(arg_34_0, arg_34_1)
		return
	end,
	on_exit = function(arg_35_0, arg_35_1)
		arg_35_0.despawned_player = nil
		arg_35_0.respawn_player = nil
	end
}
PeerStates.InPostGame = {
	approved_for_joining = true,
	on_enter = function(arg_36_0, arg_36_1)
		Network.write_dump_tag(string.format("%s in post game", arg_36_0.peer_id))
	end,
	update = function(arg_37_0, arg_37_1)
		return
	end,
	on_exit = function(arg_38_0, arg_38_1)
		return
	end
}
PeerStates.Disconnecting = {
	approved_for_joining = false,
	on_enter = function(arg_39_0, arg_39_1)
		printf("[PSM] Disconnecting peer %s", arg_39_0.peer_id)
		Network.write_dump_tag(string.format("%s disconnecting", arg_39_0.peer_id))

		if arg_39_0.has_eac then
			Managers.eac:server_remove_peer(arg_39_0.peer_id)

			arg_39_0.has_eac = false
		end

		arg_39_0.server:get_match_handler():client_disconnected(arg_39_0.peer_id)

		arg_39_0.is_ingame = nil

		local var_39_0 = arg_39_0.server
		local var_39_1 = var_39_0.game_session
		local var_39_2 = arg_39_0.peer_id
		local var_39_3 = 1
		local var_39_4 = var_39_0.game_network_manager
		local var_39_5 = Managers.party

		if DEDICATED_SERVER and var_39_5:leader() == arg_39_0.peer_id then
			local var_39_6 = var_39_0:players_past_connecting()
			local var_39_7, var_39_8 = next(var_39_6)

			if var_39_8 == nil then
				printf("[PSM] None to set to leader, so restarting now")
				Managers.game_server:set_leader_peer_id(nil)
				Managers.game_server:restart()
			else
				printf("[PSM] Selecting %s as the new leader", var_39_8)
				Managers.game_server:set_leader_peer_id(var_39_8)
			end
		end

		if var_39_1 and (var_39_0.peers_added_to_gamesession[var_39_2] or DEDICATED_SERVER) then
			printf("[PSM] Disconnected peer %s is being removed from session.", var_39_2)

			if var_39_0.game_network_manager:in_game_session() then
				local var_39_9 = PEER_ID_TO_CHANNEL[var_39_2]

				GameSession.remove_peer(var_39_1, var_39_9, var_39_4)
			end

			var_39_0.peers_added_to_gamesession[var_39_2] = nil
		end

		if var_39_4 then
			var_39_4:remove_peer(var_39_2)
		end

		if Managers.state.game_mode then
			Managers.state.game_mode:player_left_game_session(var_39_2, var_39_3)
		end

		Managers.mechanism:remote_client_disconnected(var_39_2)
		Managers.party:server_peer_left_session(var_39_2, arg_39_1.approved_for_joining, arg_39_1.state_name)
		var_39_0:set_peer_synced_game_objects(var_39_2, false)
	end,
	update = function(arg_40_0, arg_40_1)
		return PeerStates.Disconnected
	end,
	on_exit = function(arg_41_0, arg_41_1)
		return
	end
}
PeerStates.Disconnected = {
	approved_for_joining = false,
	on_enter = function(arg_42_0, arg_42_1)
		Network.write_dump_tag(string.format("%s disconnected", arg_42_0.peer_id))

		local var_42_0 = arg_42_0.peer_id
		local var_42_1 = arg_42_0.server

		if arg_42_0.is_remote then
			Managers.level_transition_handler.enemy_package_loader:client_disconnected(var_42_0)
			Managers.mechanism:remote_client_disconnected(var_42_0)
		end

		Managers.account:update_presence()
		var_42_1:peer_disconnected(var_42_0)
		var_42_1:close_channel(var_42_0)
	end,
	update = function(arg_43_0, arg_43_1)
		return
	end,
	on_exit = function(arg_44_0, arg_44_1)
		Network.write_dump_tag(string.format("%s leaving disconnected", arg_44_0.peer_id))
	end
}

for iter_0_0, iter_0_1 in pairs(PeerStates) do
	iter_0_1.state_name = iter_0_0

	setmetatable(iter_0_1, {
		__tostring = function()
			return iter_0_0
		end
	})
end
