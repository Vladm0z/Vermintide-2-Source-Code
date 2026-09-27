-- chunkname: @scripts/network/peer_states.lua

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

PeerStates = {}
SlotReservationConnectStatus = table.enum("PENDING", "FAILED", "SUCCEEDED")

local num = 2

PeerStates.Connecting = {
	approved_for_joining = false,
	on_enter = function (self, arg_1_1)
		-- function 1
		Network.write_dump_tag(string.format("%s connecting", self.peer_id))
		self.server.network_transmit:send_rpc("rpc_notify_connected", self.peer_id)

		self.loaded_level = nil
		self.resend_timer = num
		self.resend_post_game_timer = num
	end,
	rpc_notify_lobby_joined = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		-- function 2
		self.num_players = 1
		self.has_received_rpc_notify_lobby_joined = true
		self.clan_tag = arg_2_4
		self.account_id = arg_2_5

		printf("[PSM] Peer %s joined. Want to use profile index %q and join party %q", tostring(self.peer_id), tostring(arg_2_1), tostring(arg_2_3))

		self.wanted_profile_index = arg_2_1
		self.wanted_career_index = arg_2_2
		self.requested_party_index = arg_2_3

		self.server:peer_connected(self.peer_id)

		if not (not self.is_remote and self.has_eac) then
			Managers.eac:server_add_peer(self.peer_id)

			self.has_eac = true
		end
	end,
	rpc_post_game_notified = function (self, arg_3_1)
		-- function 3
		self._has_been_notfied_of_post_game_state = true
		self._in_post_game = arg_3_1
	end,
	rpc_level_loaded = function (self, arg_4_1)
		-- function 4
		self.loaded_level = NetworkLookup.level_keys[arg_4_1]
	end,
	rpc_provide_slot_reservation_info = function (self, arg_5_1, arg_5_2)
		-- function 5
		self.server:get_match_handler():register_pending_peer(self.peer_id, arg_5_2)

		local mechanism = Managers.mechanism
		local get_slot_reservation_handler = mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

		get_slot_reservation_handler = get_slot_reservation_handler or mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

		get_slot_reservation_handler:connecting_slot_reservation_info_received(self.peer_id, arg_5_1, arg_5_2)
	end,
	update = function (self, arg_6_1)
		-- function 6
		local ban_list = Managers.ban_list

		if ban_list == nil or not ban_list:is_banned(self.peer_id) then
			printf("[PSM] Disconnecting banned player (%s)", self.peer_id)
			self.server:disconnect_peer(self.peer_id, "client_is_banned")

			return PeerStates.Disconnecting
		end

		if not (Managers.level_transition_handler:get_current_level_key() ~= "prologue" or self.peer_id == self.server.my_peer_id) then
			self.server:disconnect_peer(self.peer_id, "host_plays_prologue")

			return PeerStates.Disconnecting
		end

		if not (not self.server.lobby_host:lost_connection_to_lobby() and self.peer_id == self.server.my_peer_id) then
			printf("[PSM] Disconnecting player (%s) due to no connection with our own lobby", self.peer_id)
			self.server:disconnect_peer(self.peer_id, "host_left_game")

			return PeerStates.Disconnecting
		end

		if not Managers.backend:signed_in() then
			printf("[PSM] Disconnecting player (%s) due to no connection with backend", self.peer_id)
			self.server:disconnect_peer(self.peer_id, "host_has_no_backend_connection")

			return PeerStates.Disconnecting
		end

		local SUCCEEDED = SlotReservationConnectStatus.SUCCEEDED

		if not self.is_remote then
			local mechanism = Managers.mechanism
			local get_slot_reservation_handler = mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

			get_slot_reservation_handler = get_slot_reservation_handler or mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

			if not get_slot_reservation_handler then
				SUCCEEDED = get_slot_reservation_handler:handle_slot_reservation_for_connecting_peer(self, arg_6_1)
			else
				local get_match_handler = self.server:get_match_handler()

				if not get_match_handler:has_peer_data(self.peer_id) then
					get_match_handler:register_pending_peer(self.peer_id, self.server.my_peer_id)
				end
			end
		end

		if SUCCEEDED == SlotReservationConnectStatus.SUCCEEDED then
			if not self.has_received_rpc_notify_lobby_joined then
				self.resend_timer = self.resend_timer - arg_6_1

				if not (self.resend_timer < 0) then
					if not PEER_ID_TO_CHANNEL[self.peer_id] then
						local game_mode = Managers.state.game_mode

						game_mode = not game_mode and Managers.state.game_mode:game_mode()

						if not game_mode and not game_mode:is_joinable() then
							self.server.network_transmit:send_rpc("rpc_notify_connected", self.peer_id)

							self.resend_timer = num
						end
					else
						print("PeerState.Connecting lost connection, cannot send rpc_notify_connected")

						return PeerStates.Disconnecting
					end
				end
			end
		elseif SUCCEEDED == SlotReservationConnectStatus.FAILED then
			printf("[PSM] Disconnecting player (%s) due to not being able to reserve slots", self.peer_id)
			self.server:disconnect_peer(self.peer_id, "host_has_no_backend_connection")

			return PeerStates.Disconnecting
		else
			return
		end

		if not Development.parameter("allow_weave_joining") then
			local lobby_host = self.server.lobby_host
			local lobby_data = lobby_host:lobby_data("mechanism")
			local lobby_data_2 = lobby_host:lobby_data("matchmaking")
			local lobby_data_3 = lobby_host:lobby_data("matchmaking_type")
			local str = "n/a"

			if not lobby_data_3 then
				local flag

				flag = not IS_PS4 and lobby_data_3 and NetworkLookup.matchmaking_types[tonumber(lobby_data_3)]
			end

			if not (lobby_data ~= "weave" or lobby_data_2 ~= "false") then
				local get_player_ids = Managers.weave:get_player_ids()

				if not get_player_ids then
					if not get_player_ids[self.peer_id] then
						self.server:disconnect_peer(self.peer_id, "cannot_join_weave")

						return PeerStates.Disconnecting
					end
				else
					self.server:disconnect_peer(self.peer_id, "cannot_join_weave")

					return PeerStates.Disconnecting
				end
			end
		end

		local is_in_post_game = self.server:is_in_post_game()

		if not self._has_been_notfied_of_post_game_state then
			if not is_in_post_game then
				if not self._in_post_game then
					self._has_been_notfied_of_post_game_state = nil
				elseif not self.has_received_rpc_notify_lobby_joined then
					local num_joining_peers = self.server:num_joining_peers()
					local num_2 = self.server:num_active_peers() - num_joining_peers

					if self.server.lobby_host:get_max_members() < num_2 + 1 then
						printf("[PSM] No free slots and peer not reserved, disconnecting peer (%s)", self.peer_id)
						self.server:disconnect_peer(self.peer_id, "full_server")

						return PeerStates.Disconnecting
					end

					if self.peer_id == Network.peer_id() then
						self.server:hot_join_sync_party_and_profiles(self.peer_id)

						self.has_hot_join_synced_party_and_profile = true
					end

					return PeerStates.Loading
				end
			end
		else
			self.resend_post_game_timer = self.resend_post_game_timer - arg_6_1

			if not (self.resend_post_game_timer < 0) then
				self.server.network_transmit:send_rpc("rpc_notify_in_post_game", self.peer_id, is_in_post_game)

				self.resend_post_game_timer = num
			end
		end
	end,
	rpc_level_load_started = function (self, arg_7_1)
		-- function 7
		if not self.has_hot_join_synced_party_and_profile then
			self.server:hot_join_sync_party_and_profiles(self.peer_id)

			self.has_hot_join_synced_party_and_profile = true
		end
	end,
	on_exit = function (self, arg_8_1)
		-- function 8
		self._has_been_notfied_of_post_game_state = nil
		self.has_received_rpc_notify_lobby_joined = nil
		self._in_post_game = nil
	end
}
PeerStates.Loading = {
	approved_for_joining = true,
	on_enter = function (self, arg_9_1)
		-- function 9
		local peer_id = self.peer_id

		Network.write_dump_tag(string.format("%s loading", peer_id))

		self.game_started = false
		self.is_ingame = nil

		Managers.level_transition_handler.transient_package_loader:hot_join_sync(peer_id)
	end,
	rpc_is_ingame = function (self)
		-- function 10
		print("[PSM] Got rpc_is_ingame in PeerStates.Loading, is that ok?")

		self.is_ingame = true
	end,
	rpc_level_load_started = function (self, arg_11_1)
		-- function 11
		if not self.has_hot_join_synced_party_and_profile then
			self.server:hot_join_sync_party_and_profiles(self.peer_id)

			self.has_hot_join_synced_party_and_profile = true
		end
	end,
	rpc_level_loaded = function (self, arg_12_1)
		-- function 12
		self.loaded_level = NetworkLookup.level_keys[arg_12_1]

		local load_sync_done_for_peer = Managers.level_transition_handler.enemy_package_loader:load_sync_done_for_peer(self.peer_id)
		local load_sync_done_for_peer_2 = Managers.level_transition_handler.pickup_package_loader:load_sync_done_for_peer(self.peer_id)
		local load_sync_done_for_peer_3 = Managers.level_transition_handler.general_synced_package_loader:load_sync_done_for_peer(self.peer_id)

		if not load_sync_done_for_peer and not load_sync_done_for_peer_2 and not load_sync_done_for_peer_3 then
			printf("Peer %s has loaded the level and all enemies and pickups are loaded", self.peer_id)
		else
			printf("Peer %s has loaded the level but we wait because: Enemies loaded (%s), Pickups loaded (%s), General packages loaded: (%s)", self.peer_id, load_sync_done_for_peer, load_sync_done_for_peer_2, load_sync_done_for_peer_3)
		end
	end,
	rpc_provide_slot_reservation_info = function (self, arg_13_1, arg_13_2)
		-- function 13
		Managers.mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session):connecting_slot_reservation_info_received(self.peer_id, arg_13_1, arg_13_2)
	end,
	update = function (self, arg_14_1)
		-- function 14
		if not self.is_remote then
			local mechanism = Managers.mechanism

			if not mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game) then
				local handle_slot_reservation_for_connecting_peer = mechanism:get_slot_reservation_handler(self.server.my_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session):handle_slot_reservation_for_connecting_peer(self, arg_14_1)

				if handle_slot_reservation_for_connecting_peer == SlotReservationConnectStatus.FAILED then
					printf("[PSM] Failed to reserve joining player (%s) while hosting a custom game", self.peer_id)
					self.server:disconnect_peer(self.peer_id, "host_has_no_backend_connection")

					return PeerStates.Disconnecting
				end

				if handle_slot_reservation_for_connecting_peer ~= SlotReservationConnectStatus.SUCCEEDED then
					return
				end
			end
		end

		local level_transition_handler = Managers.level_transition_handler
		local get_current_level_key = level_transition_handler:get_current_level_key()

		if self.loaded_level == get_current_level_key then
			local load_sync_done_for_peer = level_transition_handler.enemy_package_loader:load_sync_done_for_peer(self.peer_id)
			local load_sync_done_for_peer_2 = level_transition_handler.pickup_package_loader:load_sync_done_for_peer(self.peer_id)
			local load_sync_done_for_peer_3 = level_transition_handler.general_synced_package_loader:load_sync_done_for_peer(self.peer_id)
			local server_check_peer, var_14_8 = Managers.eac:server_check_peer(self.peer_id)

			if not load_sync_done_for_peer and not load_sync_done_for_peer_2 and not load_sync_done_for_peer_3 and not server_check_peer and not var_14_8 then
				return PeerStates.LoadingProfilePackages
			end
		end
	end,
	on_exit = function (arg_15_0, arg_15_1)
		-- function 15
		return
	end
}
PeerStates.LoadingProfilePackages = {
	approved_for_joining = true,
	on_enter = function (self, arg_16_1)
		-- function 16
		Network.write_dump_tag(string.format("%s loading profile packages", self.peer_id))

		local profile_synchronizer = self.server.profile_synchronizer
		local peer_id = self.peer_id
		local num = 1
		local profile_by_peer, var_16_4 = profile_synchronizer:profile_by_peer(peer_id, num)
		local wanted_profile_index = self.wanted_profile_index
		local wanted_career_index = self.wanted_career_index
		local loaded_level = self.loaded_level
		local var_16_8 = LevelSettings[loaded_level]
		local flag = not var_16_8 and var_16_8.game_mode == "tutorial"

		if not flag then
			wanted_profile_index = TUTORIAL_PROFILE_INDEX
		elseif profile_by_peer == TUTORIAL_PROFILE_INDEX then
			profile_by_peer = nil
		end

		if not (not profile_by_peer and flag) then
			self.wanted_profile_index = profile_by_peer
			self.wanted_career_index = var_16_4
		elseif wanted_profile_index == 0 then
			local requested_party_index = self.requested_party_index

			requested_party_index = requested_party_index or 1
			self.wanted_profile_index, self.wanted_career_index = profile_synchronizer:get_first_free_profile(requested_party_index)
		elseif not flag then
			-- Nothing
		else
			self.wanted_profile_index = wanted_profile_index
			self.wanted_career_index = wanted_career_index
		end
	end,
	rpc_is_ingame = function (self)
		-- function 17
		self.is_ingame = true
	end,
	update = function (self, arg_18_1)
		-- function 18
		local server = self.server

		if not server.profile_synchronizer:all_synced() then
			server.network_transmit:send_rpc("rpc_loading_synced", self.peer_id)

			return PeerStates.WaitingForEnterGame
		end
	end,
	on_exit = function (arg_19_0, arg_19_1)
		-- function 19
		return
	end
}

local function fn(self, arg_20_1)
	-- function 20
	return not self:are_profile_packages_fully_synced_for_peer(arg_20_1) and not Managers.level_transition_handler.enemy_package_loader:load_sync_done_for_peer(arg_20_1) and not Managers.level_transition_handler.pickup_package_loader:load_sync_done_for_peer(arg_20_1) and not Managers.level_transition_handler.general_synced_package_loader:load_sync_done_for_peer(arg_20_1)
end

PeerStates.WaitingForEnterGame = {
	approved_for_joining = true,
	on_enter = function (self, arg_21_1)
		-- function 21
		Network.write_dump_tag(string.format("%s waiting for enter game", self.peer_id))
	end,
	rpc_is_ingame = function (self)
		-- function 22
		self.is_ingame = true
	end,
	update = function (self, arg_23_1)
		-- function 23
		local server = self.server

		if not self.is_ingame and not server.game_network_manager and not server.game_network_manager:game_session_host() then
			local peer_id = self.peer_id

			if not server.peers_added_to_gamesession[peer_id] then
				server.game_network_manager:set_peer_synchronizing(peer_id)

				local game_session = server.game_session
				local is_network_state_fully_synced_for_peer = server:is_network_state_fully_synced_for_peer(peer_id)

				is_network_state_fully_synced_for_peer = not is_network_state_fully_synced_for_peer and not fn(server, peer_id)

				local in_game_session = server.game_network_manager:in_game_session()

				if not game_session and not in_game_session and not is_network_state_fully_synced_for_peer then
					if not self.is_remote then
						local var_23_5 = PEER_ID_TO_CHANNEL[peer_id]

						GameSession.add_peer(game_session, var_23_5)

						server.peers_added_to_gamesession[peer_id] = true
					end
				else
					return
				end
			end

			self:change_state(PeerStates.WaitingForGameObjectSync)
		end
	end,
	on_exit = function (arg_24_0, arg_24_1)
		-- function 24
		return
	end
}
PeerStates.WaitingForGameObjectSync = {
	approved_for_joining = true,
	on_enter = function (self, arg_25_1)
		-- function 25
		Network.write_dump_tag(string.format("%s waiting for game object sync", self.peer_id))
	end,
	update = function (self, arg_26_1)
		-- function 26
		local peer_id = self.peer_id

		if not self.server:has_peer_synced_game_objects(peer_id) then
			if peer_id ~= self.server.my_peer_id then
				if not fn(self.server, peer_id) then
					if not self._printed_hot_join_sync_delay then
						printf("[PeerSM] %s :: Delaying hot join sync due to ongoing resync", peer_id)

						self._printed_hot_join_sync_delay = true
					end

					return
				end

				self.server.game_network_manager:hot_join_sync(peer_id)
				self.server:set_peer_hot_join_synced(peer_id, true)
			end

			if not self.game_started then
				if not IS_XB1 then
					local network_transmit = self.server.network_transmit
					local var_26_2 = network_transmit
					local send_rpc = network_transmit.send_rpc
					local str = "rpc_game_started"
					local peer_id_2 = self.peer_id
					local round_id = Managers.account:round_id()

					round_id = round_id or ""

					send_rpc(var_26_2, str, peer_id_2, round_id)
				else
					self.server.network_transmit:send_rpc("rpc_game_started", self.peer_id, "")
				end

				self.game_started = true
			end

			if not self.is_remote then
				local flag = true
				local num = 1

				Managers.player:add_remote_player(self.peer_id, flag, num, self.clan_tag, self.account_id)
			end

			local requested_party_index = self.requested_party_index

			Managers.state.game_mode:player_entered_game_session(self.peer_id, 1, requested_party_index)

			return PeerStates.WaitingForPlayers
		end
	end,
	on_exit = function (arg_27_0, arg_27_1)
		-- function 27
		return
	end
}
PeerStates.WaitingForPlayers = {
	approved_for_joining = true,
	on_enter = function (self, arg_28_1)
		-- function 28
		Network.write_dump_tag(string.format("%s waiting for players", self.peer_id))
	end,
	update = function (self, arg_29_1)
		-- function 29
		local system = Managers.state.entity:system("cutscene_system")

		if not system.cutscene_started then
			if not self.server:are_all_peers_ready() then
				return PeerStates.InGame
			end
		elseif not system:has_intro_cutscene_finished_playing() then
			return PeerStates.InGame
		end
	end,
	on_exit = function (arg_30_0, arg_30_1)
		-- function 30
		return
	end
}
PeerStates.InGame = {
	approved_for_joining = true,
	on_enter = function (self, arg_31_1)
		-- function 31
		Managers.account:update_presence()
		Network.write_dump_tag(string.format("%s in game", self.peer_id))
	end,
	respawn_player = function (self)
		-- function 32
		assert(self.despawned_player, "[PeerStates] - Trying to respawn player without having despawned the player.")

		self.respawn_player = true
	end,
	despawned_player = function (self)
		-- function 33
		self.despawned_player = true
	end,
	update = function (arg_34_0, arg_34_1)
		-- function 34
		return
	end,
	on_exit = function (self, arg_35_1)
		-- function 35
		self.despawned_player = nil
		self.respawn_player = nil
	end
}
PeerStates.InPostGame = {
	approved_for_joining = true,
	on_enter = function (self, arg_36_1)
		-- function 36
		Network.write_dump_tag(string.format("%s in post game", self.peer_id))
	end,
	update = function (arg_37_0, arg_37_1)
		-- function 37
		return
	end,
	on_exit = function (arg_38_0, arg_38_1)
		-- function 38
		return
	end
}
PeerStates.Disconnecting = {
	approved_for_joining = false,
	on_enter = function (self, arg_39_1)
		-- function 39
		printf("[PSM] Disconnecting peer %s", self.peer_id)
		Network.write_dump_tag(string.format("%s disconnecting", self.peer_id))

		if not self.has_eac then
			Managers.eac:server_remove_peer(self.peer_id)

			self.has_eac = false
		end

		self.server:get_match_handler():client_disconnected(self.peer_id)

		self.is_ingame = nil

		local server = self.server
		local game_session = server.game_session
		local peer_id = self.peer_id
		local num = 1
		local game_network_manager = server.game_network_manager
		local party = Managers.party

		if not (not DEDICATED_SERVER and party:leader() ~= self.peer_id) then
			local players_past_connecting = server:players_past_connecting()
			local var_39_7, var_39_8 = next(players_past_connecting)

			if var_39_8 == nil then
				printf("[PSM] None to set to leader, so restarting now")
				Managers.game_server:set_leader_peer_id(nil)
				Managers.game_server:restart()
			else
				printf("[PSM] Selecting %s as the new leader", var_39_8)
				Managers.game_server:set_leader_peer_id(var_39_8)
			end
		end

		if not game_session and server.peers_added_to_gamesession[peer_id] and not DEDICATED_SERVER then
			printf("[PSM] Disconnected peer %s is being removed from session.", peer_id)

			if not server.game_network_manager:in_game_session() then
				local var_39_9 = PEER_ID_TO_CHANNEL[peer_id]

				GameSession.remove_peer(game_session, var_39_9, game_network_manager)
			end

			server.peers_added_to_gamesession[peer_id] = nil
		end

		if not game_network_manager then
			game_network_manager:remove_peer(peer_id)
		end

		if not Managers.state.game_mode then
			Managers.state.game_mode:player_left_game_session(peer_id, num)
		end

		Managers.mechanism:remote_client_disconnected(peer_id)
		Managers.party:server_peer_left_session(peer_id, arg_39_1.approved_for_joining, arg_39_1.state_name)
		server:set_peer_synced_game_objects(peer_id, false)
	end,
	update = function (arg_40_0, arg_40_1)
		-- function 40
		return PeerStates.Disconnected
	end,
	on_exit = function (arg_41_0, arg_41_1)
		-- function 41
		return
	end
}
PeerStates.Disconnected = {
	approved_for_joining = false,
	on_enter = function (self, arg_42_1)
		-- function 42
		Network.write_dump_tag(string.format("%s disconnected", self.peer_id))

		local peer_id = self.peer_id
		local server = self.server

		if not self.is_remote then
			Managers.level_transition_handler.enemy_package_loader:client_disconnected(peer_id)
			Managers.mechanism:remote_client_disconnected(peer_id)
		end

		Managers.account:update_presence()
		server:peer_disconnected(peer_id)
		server:close_channel(peer_id)
	end,
	update = function (arg_43_0, arg_43_1)
		-- function 43
		return
	end,
	on_exit = function (self, arg_44_1)
		-- function 44
		Network.write_dump_tag(string.format("%s leaving disconnected", self.peer_id))
	end
}

for k, v in pairs(PeerStates) do
	v.state_name = k

	setmetatable(v, {
		__tostring = function ()
			-- function 45
			return k
		end
	})
end
