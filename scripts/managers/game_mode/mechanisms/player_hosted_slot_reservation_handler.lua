-- chunkname: @scripts/managers/game_mode/mechanisms/player_hosted_slot_reservation_handler.lua

PlayerHostedSlotReservationHandler = class(PlayerHostedSlotReservationHandler)

local flag = true
local tbl = {
	reserved = false
}

PlayerHostedSlotReservationHandler.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._owner_peer_id = arg_1_2
	self._reservation_handler_type = arg_1_3
	self._group_leaders = {}
	self._peer_id_to_party_id = {}
	self._reserved_peers = {}

	if not arg_1_1 then
		self:update_slot_settings(arg_1_1)
	end

	self._party_manager = Managers.party
	self._pending_peer_informations = {}

	Managers.persistent_event:register(self, "network_match_changed", "_on_network_match_changed")
	Managers.persistent_event:register(self, "network_match_terminated", "_on_network_match_terminated")
	Managers.persistent_event:register(self, "new_network_match_synced", "_on_new_network_match_synced")
	printf("[PlayerHostedSlotReservationHandler] Created")

	self._synced = false

	local network_handler = Managers.mechanism:network_handler()

	if not network_handler then
		self:request_slot_reservation_sync()

		local peer_id = Network.peer_id()

		if not (not network_handler.is_server and self._owner_peer_id ~= peer_id) then
			local active_peers = network_handler:active_peers()

			active_peers = not table.is_empty(active_peers) and {
				Network.peer_id()
			} and active_peers

			self:try_reserve_slots(Network.peer_id(), active_peers)
		end
	end

	self._dangling_peers = {}
end

PlayerHostedSlotReservationHandler.set_reservation_handler_type = function (self, arg_2_1)
	-- function 2
	self._reservation_handler_type = arg_2_1
end

PlayerHostedSlotReservationHandler.update_slot_settings = function (self, arg_3_1)
	-- function 3
	self._max_party_slots = 0
	self._num_slots_total = 0

	local num = 0

	for k, v in pairs(arg_3_1) do
		if not v.game_participating then
			local party_id = v.party_id
			local num_slots = v.num_slots

			self:_expand(party_id, num_slots)

			num = math.max(num, party_id)

			for k_2 = 1, #self._reserved_peers[party_id] do
				local var_3_3 = self._reserved_peers[party_id][k_2]

				if not var_3_3 and not var_3_3.reserved then
					self._peer_id_to_party_id[var_3_3.peer_id] = party_id
				end
			end
		end
	end

	local tbl = {}

	for l = num + 1, #self._reserved_peers do
		local var_3_5 = self._reserved_peers[l]

		for i4 = 1, #var_3_5 do
			local var_3_6 = var_3_5[i4]

			if not var_3_6.reserved then
				local peer_id = var_3_6.peer_id

				tbl[#tbl + 1] = peer_id
			end
		end
	end

	local count = #tbl

	for i5 = 1, count do
		local var_3_9 = tbl[i5]
		local flag_2 = false

		for i6 = 1, num do
			local var_3_11 = self._reserved_peers[i6]

			for i7 = 1, #var_3_11 do
				if not var_3_11[i7].reserved then
					local flag_3 = i5 < count

					self:move_player(var_3_9, i6, flag_3)

					flag_2 = true

					break
				end
			end

			if not flag_2 then
				break
			end
		end
	end

	for i8 = num + 1, #self._reserved_peers do
		assert(table.is_empty(table.select_array(self._reserved_peers, function (arg_4_0, arg_4_1)
			-- function 4
			return arg_4_1.peer_id
		end)), "[PlayerHostedSlotReservationHandler] Dangling peers remain in the slot reservation handler")

		self._reserved_peers[i8] = nil
		self._num_slots_per_party[i8] = nil

		if not flag then
			printf("[PlayerHostedSlotReservationHandler] Shrinking reserved peers. Removing party %s", i8)
		end
	end
end

PlayerHostedSlotReservationHandler._recalculate_slots = function (self)
	-- function 5
	self._num_slots_total = 0
	self._max_party_slots = 0
	self._num_slots_per_party = {}

	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		local count = #_reserved_peers[i]

		self._num_slots_total = self._num_slots_total + count
		self._num_slots_per_party[i] = count

		if count > self._max_party_slots then
			self._max_party_slots = count
		end
	end
end

PlayerHostedSlotReservationHandler._expand = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _reserved_peers = self._reserved_peers

	for i = #_reserved_peers + 1, arg_6_1 do
		if not flag then
			printf("[PlayerHostedSlotReservationHandler] Expanding. Adding party %s", i)
		end

		_reserved_peers[i] = {}
	end

	local var_6_1 = _reserved_peers[arg_6_1]

	for j = #var_6_1 + 1, arg_6_2 do
		if not flag then
			printf("[PlayerHostedSlotReservationHandler] Expanding. Adding slot %s in party %s", j, arg_6_1)
		end

		var_6_1[j] = table.clone(tbl)
	end

	self:_recalculate_slots()
end

PlayerHostedSlotReservationHandler.handle_dangling_peers = function (self)
	-- function 7
	if not table.is_empty(self._dangling_peers) then
		return
	end

	local network_handler = Managers.mechanism:network_handler()
	local time = Managers.time:time("main")

	for k, v in pairs(self._dangling_peers) do
		if v < time then
			network_handler:force_disconnect_client_by_peer_id(k)

			self._dangling_peers[k] = nil
		end
	end
end

PlayerHostedSlotReservationHandler.num_slots_total = function (self)
	-- function 8
	return self._num_slots_total
end

PlayerHostedSlotReservationHandler.max_party_slots = function (self)
	-- function 9
	return self._max_party_slots
end

PlayerHostedSlotReservationHandler.try_reserve_slots = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local flag = false
	local var_10_1

	if not table.is_empty(arg_10_2) then
		printf("[PlayerHostedSlotReservationHandler] Tried to reserve slots for peer %s, but no peers were provided", arg_10_1)

		return flag, var_10_1
	end

	if not arg_10_3 then
		arg_10_1 = arg_10_3
	end

	local _filter_already_reserved_peers = self:_filter_already_reserved_peers(arg_10_2)

	if not table.is_empty(_filter_already_reserved_peers) then
		flag = true
		var_10_1 = self._peer_id_to_party_id[arg_10_1]

		printf("[PlayerHostedSlotReservationHandler] Attempted to reserve peers (%s), but they were already in party %s", table.concat(arg_10_2, ", "), var_10_1)

		return flag, var_10_1
	end

	local count = #_filter_already_reserved_peers
	local num = 0

	for i, v in ipairs(self._reserved_peers) do
		local _num_free_slots_in_party = self:_num_free_slots_in_party(i)

		if not (not (count <= _num_free_slots_in_party) or not (num < _num_free_slots_in_party)) then
			var_10_1 = i
			num = _num_free_slots_in_party
		end
	end

	if not var_10_1 then
		if not Managers.mechanism:game_mechanism():is_hosting_versus_custom_game() then
			if not arg_10_3 then
				self._party_manager:server_add_friend_party_peer_from_invitee(arg_10_1, arg_10_3)
			else
				self._party_manager:server_create_friend_party(arg_10_2, arg_10_1)
			end

			self._party_manager:sync_friend_party_ids()
		end

		local get_friend_party_id_from_peer = self._party_manager:get_friend_party_id_from_peer(arg_10_1)

		for k = 1, #_filter_already_reserved_peers do
			for k_2, v_2 in pairs(self._reserved_peers[var_10_1]) do
				local var_10_7 = _filter_already_reserved_peers[k]

				if not v_2.reserved then
					self:_write_party_slot(v_2, var_10_7, get_friend_party_id_from_peer, arg_10_1, var_10_1)

					break
				end
			end
		end

		flag = true
	else
		printf("[PlayerHostedSlotReservationHandler] Failed to reserve slot for peers (%s).", table.concat(_filter_already_reserved_peers))
		table.dump(self._reserved_peers, "Reserved Peers", 2)
	end

	if not flag then
		self:_update_reservations()
	end

	return flag, var_10_1
end

PlayerHostedSlotReservationHandler._filter_already_reserved_peers = function (self, arg_11_1)
	-- function 11
	local var_11_0

	for i = #arg_11_1, 1, -1 do
		if not self:has_reservation(arg_11_1[i]) then
			var_11_0 = var_11_0 or table.shallow_copy(arg_11_1, true)

			table.remove(var_11_0, i)
		end
	end

	return var_11_0 or arg_11_1
end

PlayerHostedSlotReservationHandler._num_free_slots_in_party = function (self, arg_12_1)
	-- function 12
	local num = 0

	for k, v in pairs(self._reserved_peers[arg_12_1]) do
		if not v.reserved then
			num = num + 1
		end
	end

	return num
end

PlayerHostedSlotReservationHandler._update_reservations = function (self)
	-- function 13
	local num = 0
	local num_2 = 0
	local str = ""

	for i, v in ipairs(self._reserved_peers) do
		local var_13_3 = self._num_slots_per_party[i]
		local num_3 = var_13_3 - self:_num_free_slots_in_party(i)

		for k = 1, num_3 do
			num = bit.bor(num, bit.lshift(1, num_2 + (k - 1)))
			str = str .. "1"
		end

		for l = num_3 + 1, var_13_3 do
			str = str .. "0"
		end

		num_2 = num_2 + var_13_3
	end

	print("[PlayerHostedSlotReservationHandler] updating reservations. slots:", str, num)

	local network = Managers.state.network

	if not network then
		self._dirty_reserved_slots = nil

		local lobby = network:lobby()

		self:_update_lobby_data(lobby, num)

		self._lobby_data_sync_requested = true
	else
		self._dirty_reserved_slots = num
	end

	self:_send_peer_updates_to_clients()
end

PlayerHostedSlotReservationHandler.remove_peer_reservations = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0
	local var_14_1 = self._group_leaders[arg_14_1]
	local flag

	if not var_14_1 then
		if not arg_14_2 then
			local var_14_2 = arg_14_1

			for k in pairs(var_14_1) do
				if k ~= var_14_2 then
					if not PEER_ID_TO_CHANNEL[k] then
						var_14_1[k] = nil
					else
						printf("[PlayerHostedSlotReservationHandler] Removing peer %s since they are in a party with peer %s and we don't have a connection to them.", k, var_14_2)
					end
				end
			end
		end

		for k_2, v in pairs(var_14_1) do
			self:_remove_peer_reservation(k_2)
		end

		flag = true
	else
		flag = self:_remove_peer_reservation(arg_14_1)
	end

	if not flag then
		self:_update_reservations()
	end
end

PlayerHostedSlotReservationHandler.network_context_created = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not arg_15_4 then
		self._dirty_reserved_slots = nil
	elseif not self._dirty_reserved_slots then
		self:_update_lobby_data(arg_15_1, self._dirty_reserved_slots)

		self._dirty_reserved_slots = nil
	end
end

PlayerHostedSlotReservationHandler._update_lobby_data = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local lobby_data_table = arg_16_1.lobby_data_table

	lobby_data_table.reserved_slots_mask = arg_16_2

	arg_16_1:set_lobby_data(lobby_data_table)
end

PlayerHostedSlotReservationHandler._remove_peer_reservation = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self._peer_id_to_party_id[arg_17_1]

	if not self._dangling_peers[arg_17_1] then
		self._dangling_peers[arg_17_1] = nil

		return false
	elseif not var_17_0 then
		return false
	else
		local flag = false
		local var_17_2 = self._reserved_peers[var_17_0]

		for i = 1, #var_17_2 do
			if var_17_2[i].peer_id == arg_17_1 then
				self:_clear_party_slot(var_17_2[i])

				flag = true

				break
			end
		end

		print("[PlayerHostedSlotReservationHandler] Removing reserved peer %s", arg_17_1)

		local game_mechanism = Managers.mechanism:game_mechanism()
		local is_hosting_versus_custom_game = game_mechanism.is_hosting_versus_custom_game

		is_hosting_versus_custom_game = not is_hosting_versus_custom_game and game_mechanism:is_hosting_versus_custom_game()

		if not is_hosting_versus_custom_game and not flag then
			self._party_manager:server_remove_friend_party_peer(arg_17_1)
		elseif not flag then
			-- Nothing
		end

		self._peer_id_to_party_id[arg_17_1] = nil

		if not self._group_leaders[arg_17_1] then
			local find_func = table.find_func(self._group_leaders[arg_17_1], function (arg_18_0)
				-- function 18
				return arg_18_0 ~= arg_17_1
			end)

			if not find_func then
				self._group_leaders[find_func] = self._group_leaders[arg_17_1]
			end
		end

		self._group_leaders[arg_17_1] = nil

		return flag
	end
end

PlayerHostedSlotReservationHandler.party_id = function (self, arg_19_1)
	-- function 19
	return self._peer_id_to_party_id[arg_19_1]
end

PlayerHostedSlotReservationHandler.all_teams_have_members = function (self)
	-- function 20
	local party = Managers.party

	for i, v in ipairs(self._reserved_peers) do
		if not (not party:is_game_participating(i) and self._num_slots_per_party[i] ~= self:_num_free_slots_in_party(i)) then
			return false
		end
	end

	return true
end

PlayerHostedSlotReservationHandler.get_group_leaders = function (self)
	-- function 21
	return table.keys(self._group_leaders)
end

PlayerHostedSlotReservationHandler.get_leader_from_peer = function (self, arg_22_1)
	-- function 22
	for k, v in pairs(self._group_leaders) do
		if not v[arg_22_1] then
			return k
		end
	end
end

PlayerHostedSlotReservationHandler.peers = function (self)
	-- function 23
	return table.keys(self._peer_id_to_party_id)
end

PlayerHostedSlotReservationHandler.peers_by_party = function (self, arg_24_1)
	-- function 24
	return table.keys(table.filter(self._peer_id_to_party_id, function (arg_25_0)
		-- function 25
		return arg_24_1 == arg_25_0
	end))
end

PlayerHostedSlotReservationHandler.party_id_by_peer = function (self, arg_26_1)
	-- function 26
	return self._peer_id_to_party_id[arg_26_1]
end

PlayerHostedSlotReservationHandler.update_slots = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	self._synced = true

	for i = 1, #self._reserved_peers do
		local var_27_0 = self._reserved_peers[i]

		for j = 1, #var_27_0 do
			self:_clear_party_slot(var_27_0[j])
		end
	end

	table.clear(self._group_leaders)
	table.clear(self._peer_id_to_party_id)

	if not flag then
		printf("[PlayerHostedSlotReservationHandler] Updating slots (%s) (%s)", table.concat(arg_27_1, ", "), table.concat(arg_27_2, ", "))
	end

	assert(table.find(arg_27_1, Network.peer_id()), "[PlayerHostedSlotReservationHandler] Missing self in reservation handler")

	for k = 1, #arg_27_1 do
		local var_27_1 = arg_27_1[k]
		local var_27_2 = arg_27_2[k]
		local var_27_3 = arg_27_3[k]
		local var_27_4 = arg_27_4[k]
		local flag_2 = false
		local var_27_6 = self._reserved_peers[var_27_2]

		if not var_27_6 then
			for l = 1, #var_27_6 do
				local var_27_7 = var_27_6[l]

				if not var_27_7.reserved then
					self:_write_party_slot(var_27_7, var_27_1, var_27_3, var_27_4, var_27_2)

					flag_2 = true

					break
				end
			end
		end

		if not flag_2 then
			local var_27_8 = self
			local _expand = self._expand
			local var_27_10 = var_27_2
			local num

			if not var_27_6 then
				num = #var_27_6 + 1

				if not num then
					-- Nothing
				end
			end

			num = 1

			::label_27_0::

			_expand(var_27_8, var_27_10, num)

			local var_27_12 = self._reserved_peers[var_27_2]

			self:_write_party_slot(var_27_12[#var_27_12], var_27_1, var_27_3, var_27_4, var_27_2)
		end
	end

	if not Managers.mechanism:is_server() then
		if not flag then
			local concat = table.concat(table.select_array(self._reserved_peers, function (arg_28_0, arg_28_1)
				-- function 28
				return table.concat(table.select_array(arg_28_1, function (arg_29_0, arg_29_1)
					-- function 29
					return arg_29_1.peer_id
				end), ", ")
			end), " | ")

			printf("[PlayerHostedSlotReservationHandler] Sending update to clients (%s)", concat)
		end

		local var_27_14 = NetworkLookup.reservation_handler_types[self._reservation_handler_type]

		Managers.mechanism:network_handler():get_match_handler():send_rpc_down_if("rpc_sync_vs_custom_game_slot_data", function (arg_30_0)
			-- function 30
			return table.find(arg_27_1, arg_30_0)
		end, self._owner_peer_id, var_27_14, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	end
end

PlayerHostedSlotReservationHandler.party_peers = function (self, arg_31_1)
	-- function 31
	return table.keys_if(self._peer_id_to_party_id, nil, function (arg_32_0, arg_32_1)
		-- function 32
		return arg_31_1 == arg_32_1
	end)
end

PlayerHostedSlotReservationHandler.player_joined_party = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	if not (arg_33_5 or arg_33_3 ~= 0) then
		return
	end

	local var_33_0 = self._peer_id_to_party_id[arg_33_1]
	local get_party = Managers.party:get_party(arg_33_3)

	if not (not var_33_0 and get_party.game_participating) then
		self:_remove_peer_reservation(arg_33_1)

		return
	end

	if not (not var_33_0 and var_33_0 ~= arg_33_3) then
		return
	end

	self:move_player(arg_33_1, arg_33_3)
end

PlayerHostedSlotReservationHandler.request_party_change = function (arg_34_0, arg_34_1)
	-- function 34
	local peer_id = Network.peer_id()

	Managers.state.network.network_transmit:send_rpc_server("rpc_slot_reservation_request_party_change", peer_id, arg_34_1)
end

PlayerHostedSlotReservationHandler.slot_reservation_sync_requested = function (self, arg_35_1)
	-- function 35
	local _build_slot_info, var_35_1, var_35_2, var_35_3 = self:_build_slot_info()

	if not table.find(_build_slot_info, arg_35_1) then
		printf("[PlayerHostedSlotReservationHandler] Non reserved peer %s requested a slot reservation sync.", arg_35_1)

		return
	end

	local var_35_4 = NetworkLookup.reservation_handler_types[self._reservation_handler_type]

	Managers.mechanism:network_handler():get_match_handler():send_rpc("rpc_sync_vs_custom_game_slot_data", arg_35_1, self._owner_peer_id, var_35_4, _build_slot_info, var_35_1, var_35_2, var_35_3)
end

PlayerHostedSlotReservationHandler.request_slot_reservation_sync = function (arg_36_0)
	-- function 36
	Managers.mechanism:network_handler():get_match_handler():send_rpc_up("rpc_request_slot_reservation_sync")
end

PlayerHostedSlotReservationHandler._send_peer_updates_to_clients = function (self)
	-- function 37
	local network_handler = Managers.mechanism:network_handler()

	if not network_handler then
		return
	end

	if not network_handler:get_match_handler():query_peer_data(Network.peer_id(), "is_match_owner") then
		return
	end

	local _build_slot_info, var_37_2, var_37_3, var_37_4 = self:_build_slot_info()

	self:update_slots(_build_slot_info, var_37_2, var_37_3, var_37_4)
end

local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}

PlayerHostedSlotReservationHandler._build_slot_info = function (self)
	-- function 38
	table.clear(tbl_2)
	table.clear(tbl_3)
	table.clear(tbl_4)
	table.clear(tbl_5)

	local num = 1

	for i = 1, #self._reserved_peers do
		local var_38_1 = self._reserved_peers[i]

		for j = 1, #var_38_1 do
			local var_38_2 = var_38_1[j]

			if not var_38_2.reserved then
				tbl_2[num] = var_38_2.peer_id
				tbl_3[num] = i

				local var_38_3 = tbl_4
				local friend_party_id = var_38_2.friend_party_id

				friend_party_id = friend_party_id or 1
				var_38_3[num] = friend_party_id

				local var_38_5 = tbl_5
				local friend_party_leader = var_38_2.friend_party_leader

				friend_party_leader = friend_party_leader or ""
				var_38_5[num] = friend_party_leader
				num = num + 1
			end
		end
	end

	return tbl_2, tbl_3, tbl_4, tbl_5
end

PlayerHostedSlotReservationHandler.get_peer_reserved_indices = function (self, arg_39_1)
	-- function 39
	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		local var_39_1 = _reserved_peers[i]

		for j = 1, #var_39_1 do
			if var_39_1[j].peer_id == arg_39_1 then
				return i, j
			end
		end
	end
end

PlayerHostedSlotReservationHandler._get_peer_slot_data = function (self, arg_40_1)
	-- function 40
	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		local var_40_1 = _reserved_peers[i]

		for j = 1, #var_40_1 do
			local var_40_2 = var_40_1[j]

			if var_40_2.peer_id == arg_40_1 then
				return var_40_2
			end
		end
	end
end

PlayerHostedSlotReservationHandler.move_player = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	if self:_num_free_slots_in_party(arg_41_2) < 1 then
		return false
	end

	local var_41_0 = self._peer_id_to_party_id[arg_41_1]

	if not var_41_0 then
		return false, "Failed to find peer"
	end

	if var_41_0 == arg_41_2 then
		return true
	end

	local flag = false
	local var_41_2 = self._reserved_peers[var_41_0]
	local var_41_3 = self._reserved_peers[arg_41_2]

	for k, v in pairs(var_41_2) do
		if v.peer_id == arg_41_1 then
			for k_2, v_2 in pairs(var_41_3) do
				if not v_2.reserved then
					local friend_party_id = v.friend_party_id
					local friend_party_leader = v.friend_party_leader

					self:_write_party_slot(v_2, arg_41_1, friend_party_id, friend_party_leader, arg_41_2)
					self:_clear_party_slot(v)

					flag = true

					break
				end
			end

			break
		end
	end

	if not flag then
		Crashify.print_exception("[PlayerHostedSlotReservationHandler]", "Tried removing peer %s but was not reserved to begin with", arg_41_1)
	end

	if not arg_41_3 then
		self:_update_reservations()
	end

	return true
end

PlayerHostedSlotReservationHandler.poll_sync_lobby_data_required = function (self)
	-- function 42
	if not self._lobby_data_sync_requested then
		self._lobby_data_sync_requested = false

		return true
	end

	return false
end

PlayerHostedSlotReservationHandler.remote_client_disconnected = function (self, arg_43_1)
	-- function 43
	self:remove_peer_reservations(arg_43_1)

	self._pending_peer_informations[arg_43_1] = nil
end

PlayerHostedSlotReservationHandler.has_reservation = function (self, arg_44_1)
	-- function 44
	return self._peer_id_to_party_id[arg_44_1]
end

PlayerHostedSlotReservationHandler.handle_slot_reservation_for_connecting_peer = function (self, arg_45_1, arg_45_2)
	-- function 45
	local peer_id = arg_45_1.peer_id
	local flag = false
	local var_45_2 = self._pending_peer_informations[peer_id]

	if not var_45_2 then
		var_45_2 = {
			resend_timer = 3,
			reserved = false,
			status = SlotReservationConnectStatus.PENDING,
			peers = {}
		}
		self._pending_peer_informations[peer_id] = var_45_2
		flag = true
	else
		var_45_2.resend_timer = var_45_2.resend_timer - arg_45_2
	end

	if not (var_45_2.status ~= SlotReservationConnectStatus.PENDING or not (var_45_2.resend_timer < 0)) then
		flag = true
		var_45_2.resend_timer = 3
	end

	if not flag then
		printf("[PlayerHostedSlotReservationHandler] Requesting reservation info from peer '%s'", peer_id)

		local var_45_3 = PEER_ID_TO_CHANNEL[peer_id]

		RPC.rpc_slot_reservation_request_peers(var_45_3)
	end

	return var_45_2.status
end

PlayerHostedSlotReservationHandler.connecting_slot_reservation_info_received = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local var_46_0 = self._pending_peer_informations[arg_46_1]

	if var_46_0.status ~= SlotReservationConnectStatus.PENDING then
		printf("[PlayerHostedSlotReservationHandler]", "Received slot reservation info from already handled peer '%s'.", arg_46_1)

		return
	end

	for i = 1, #arg_46_2 do
		local var_46_1 = arg_46_2[i]

		self._pending_peer_informations[var_46_1] = var_46_0
		var_46_0.peers[i] = var_46_1
	end

	local matchmaking = Managers.matchmaking

	if not (not matchmaking and matchmaking:is_in_versus_custom_game_lobby()) then
		arg_46_3 = Network.peer_id()
	end

	local try_reserve_slots = self:try_reserve_slots(arg_46_3, var_46_0.peers)

	printf("[PlayerHostedSlotReservationHandler] Peer info from peer '%s' received. (%s) joining. Success: %s", arg_46_1, table.concat(arg_46_2, ","), try_reserve_slots)

	if not try_reserve_slots then
		var_46_0.reserved = true
		var_46_0.status = SlotReservationConnectStatus.SUCCEEDED
	else
		var_46_0.status = SlotReservationConnectStatus.FAILED
	end
end

PlayerHostedSlotReservationHandler._change_leader = function (self, arg_47_1, arg_47_2)
	-- function 47
	local get_leader_from_peer = self:get_leader_from_peer(arg_47_1)

	if not get_leader_from_peer then
		self._group_leaders[get_leader_from_peer][arg_47_1] = nil

		if not table.is_empty(self._group_leaders[get_leader_from_peer]) then
			self._group_leaders[get_leader_from_peer] = nil
		end
	end

	local _group_leaders = self._group_leaders
	local var_47_2 = self._group_leaders[arg_47_2]

	var_47_2 = var_47_2 or {}
	_group_leaders[arg_47_2] = var_47_2
	self._group_leaders[arg_47_2][arg_47_1] = true
end

PlayerHostedSlotReservationHandler._clear_party_slot = function (arg_48_0, arg_48_1)
	-- function 48
	if not flag and not arg_48_1.peer_id then
		printf("[PlayerHostedSlotReservationHandler] Clearing peer %s from party %s (friend party %s leader %s)", arg_48_1.peer_id, arg_48_1.party_id, arg_48_1.friend_party_id, arg_48_1.friend_party_leader)
	end

	arg_48_1.reserved = false
	arg_48_1.peer_id = nil
	arg_48_1.friend_party_id = nil
	arg_48_1.friend_party_leader = nil
	arg_48_1.party_id = nil
end

PlayerHostedSlotReservationHandler._write_party_slot = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	-- function 49
	arg_49_1.reserved = true
	arg_49_1.peer_id = arg_49_2
	arg_49_1.friend_party_id = arg_49_3
	arg_49_1.friend_party_leader = arg_49_4
	arg_49_1.party_id = arg_49_5

	local _group_leaders = self._group_leaders
	local var_49_1 = self._group_leaders[arg_49_4]

	var_49_1 = var_49_1 or {}
	_group_leaders[arg_49_4] = var_49_1
	self._group_leaders[arg_49_4][arg_49_2] = true
	self._peer_id_to_party_id[arg_49_2] = arg_49_5

	if not flag then
		printf("[PlayerHostedSlotReservationHandler] Reserving peer %s to party %s (friend party %s leader %s)", arg_49_2, arg_49_5, arg_49_3, arg_49_4)
	end
end

PlayerHostedSlotReservationHandler._clear_non_session_peers = function (self)
	-- function 50
	local peer_id = Network.peer_id()
	local _synced = self._synced

	_synced = not _synced and self:_get_peer_slot_data(peer_id)

	local friend_party_leader

	if not _synced then
		friend_party_leader = _synced.friend_party_leader

		if not friend_party_leader then
			-- Nothing
		end
	end

	friend_party_leader = peer_id

	::label_50_0::

	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		local var_50_4 = _reserved_peers[i]

		for j = 1, #var_50_4 do
			local var_50_5 = var_50_4[j]

			if not (not var_50_5.peer_id and var_50_5.friend_party_leader == friend_party_leader) then
				self:_remove_peer_reservation(var_50_5.peer_id)
			end
		end
	end
end

PlayerHostedSlotReservationHandler._on_network_match_changed = function (self, arg_51_1)
	-- function 51
	if not arg_51_1 then
		self:_clear_non_session_peers()
		self:update_slot_settings({
			self._party_manager:parties()[1]
		})
	end
end

PlayerHostedSlotReservationHandler._on_network_match_terminated = function (self)
	-- function 52
	self._synced = false

	self:_clear_non_session_peers()
end

PlayerHostedSlotReservationHandler._on_new_network_match_synced = function (self, arg_53_1, arg_53_2)
	-- function 53
	if not arg_53_1 then
		local network_handler = Managers.mechanism:network_handler()
		local var_53_1 = self
		local try_reserve_slots = self.try_reserve_slots
		local var_53_3 = arg_53_2
		local active_peers

		if not network_handler then
			active_peers = network_handler:active_peers()

			if not active_peers then
				-- Nothing
			end
		end

		active_peers = {
			arg_53_2
		}

		::label_53_0::

		try_reserve_slots(var_53_1, var_53_3, active_peers)
	else
		self:request_slot_reservation_sync()
	end
end

PlayerHostedSlotReservationHandler.destroy = function (arg_54_0)
	-- function 54
	Managers.persistent_event:unregister("network_match_changed", arg_54_0)
	Managers.persistent_event:unregister("network_match_terminated", arg_54_0)
	Managers.persistent_event:unregister("new_network_match_synced", arg_54_0)
end
