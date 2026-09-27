-- chunkname: @scripts/managers/game_mode/mechanisms/versus_game_server_slot_reservation_handler.lua

VersusGameServerSlotReservationHandler = class(VersusGameServerSlotReservationHandler)

local tbl = {
	reserved = false
}

local function fn(self)
	-- function 1
	self.reserved = false
	self.peer_id = nil
	self.reserver = nil
end

VersusGameServerSlotReservationHandler.init = function (self, arg_2_1)
	-- function 2
	fassert(DEDICATED_SERVER, "[VersusGameServerSlotReservationHandler] Should only be initialized on a dedicated server.")

	local dedicated_server_reservation_slots = script_data.dedicated_server_reservation_slots

	if not dedicated_server_reservation_slots then
		printf("Modifying party definitions, num_players: %s", tostring(dedicated_server_reservation_slots))

		dedicated_server_reservation_slots = string.split_deprecated(dedicated_server_reservation_slots, ",")
	end

	self._party_manager = Managers.party
	self._num_slots_total = 0
	self._num_slots_reserved = 0
	self._max_party_slots = 0
	self._reserved_peers = {}
	self._pending_peer_informations = {}

	local create_party = Managers.party:create_party(Managers.party:generate_undecided_party())

	self:_register_party(create_party, dedicated_server_reservation_slots)

	for k, v in pairs(arg_2_1) do
		self:_register_party(v)
	end

	self._reserved_peers_map = {}
end

VersusGameServerSlotReservationHandler._register_party = function (self, arg_3_1, arg_3_2)
	-- function 3
	local tbl_2 = {}
	local party_id = arg_3_1.party_id
	local var_3_2

	if not arg_3_2 then
		var_3_2 = tonumber(arg_3_2[party_id])

		if not var_3_2 then
			-- Nothing
		end
	end

	var_3_2 = arg_3_1.num_slots

	::label_3_0::

	if not arg_3_1.game_participating then
		self._num_slots_total = self._num_slots_total + var_3_2

		if var_3_2 > self._max_party_slots then
			self._max_party_slots = var_3_2
		end
	end

	for i = 1, var_3_2 do
		tbl_2[i] = table.clone(tbl)
	end

	tbl_2.game_participating = arg_3_1.game_participating
	self._reserved_peers[party_id] = tbl_2
end

VersusGameServerSlotReservationHandler.destroy = function (arg_4_0)
	-- function 4
	return
end

VersusGameServerSlotReservationHandler.send_rpc_to_all_reserving_clients = function (self, arg_5_1, ...)
	-- function 5
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_5_1 = _reserved_peers[i]

		for i_2, v in ipairs(var_5_1) do
			local peer_id = v.peer_id

			if not peer_id and not v.reserver then
				local var_5_3 = PEER_ID_TO_CHANNEL[peer_id]

				if not var_5_3 then
					RPC[arg_5_1](var_5_3, ...)
				end
			end
		end
	end
end

VersusGameServerSlotReservationHandler.send_slot_update_to_clients = function (self)
	-- function 6
	self:_send_peer_updates_to_clients()

	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_6_1 = _reserved_peers[i]

		for i_2, v in ipairs(var_6_1) do
			local peer_id = v.peer_id

			if not peer_id and not v.reserver then
				local var_6_3 = PEER_ID_TO_CHANNEL[peer_id]

				if not var_6_3 then
					RPC.rpc_reserved_slots_count(var_6_3, self._num_slots_reserved, self._num_slots_total)
				end
			end
		end
	end
end

VersusGameServerSlotReservationHandler.num_slots_total = function (self)
	-- function 7
	return self._num_slots_total
end

VersusGameServerSlotReservationHandler.max_party_slots = function (self)
	-- function 8
	return self._max_party_slots
end

VersusGameServerSlotReservationHandler._send_peer_updates_to_clients = function (self)
	-- function 9
	local tbl = {}
	local tbl_2 = {}
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_9_3 = _reserved_peers[i]
		local tbl_3 = {
			slot_state = {},
			party_members = {}
		}

		tbl[i] = tbl_3

		local slot_state = tbl_3.slot_state
		local party_members = tbl_3.party_members

		for j = 1, #var_9_3 do
			local var_9_7 = var_9_3[j]

			if not var_9_7.reserved then
				party_members[j] = Managers.game_server:peer_name(var_9_7.peer_id)

				local flag

				flag = not var_9_7.reserver and 3 and 2
				slot_state[j] = flag
			else
				party_members[j] = "-"
				slot_state[j] = 1
			end

			if not var_9_7.peer_id and not var_9_7.reserver then
				tbl_2[#tbl_2 + 1] = var_9_7.peer_id
			end
		end
	end

	for k = 1, #tbl_2 do
		local var_9_9 = tbl_2[k]
		local var_9_10 = PEER_ID_TO_CHANNEL[var_9_9]

		if not var_9_10 then
			for i_2, v in ipairs(_reserved_peers) do
				local var_9_11 = tbl[i_2]
				local server_name = Managers.game_server:server_name()

				RPC.rpc_party_slots_status(var_9_10, server_name, i_2, var_9_11.party_members, var_9_11.slot_state)
			end
		end
	end
end

VersusGameServerSlotReservationHandler.try_reserve_slots = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	self._num_slots_reserved = self._num_slots_reserved + #arg_10_2

	if not arg_10_4 then
		self:send_slot_update_to_clients()
	end

	self:_update_lobby_reservations()

	return true
end

VersusGameServerSlotReservationHandler._find_fitting_party = function (self, arg_11_1, arg_11_2)
	-- function 11
	local count = #arg_11_1
	local versus = GameModeSettings.versus
	local var_11_2

	if not arg_11_2 then
		var_11_2 = self:_can_join_invitee_party(arg_11_2, count)
	elseif versus.fill_party_distribution == versus.party_fill_method.fill_first_party then
		var_11_2 = self:_find_party_with_most_peers_and_enough_room(count)
	elseif versus.fill_party_distribution == versus.party_fill_method.distribute_party_even then
		var_11_2 = self:_find_party_with_least_peers_and_enough_room(count)
	end

	return var_11_2
end

VersusGameServerSlotReservationHandler.unreserve_slot = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local _find_party_and_index_from_peer_id, var_12_1, var_12_2 = self:_find_party_and_index_from_peer_id(arg_12_1, arg_12_3)

	if not var_12_1 then
		return
	end

	self:_unreserve_slot_delayed(arg_12_1, _find_party_and_index_from_peer_id, var_12_1, arg_12_3, arg_12_2)
	self._party_manager:server_remove_friend_party_peer(arg_12_1)
end

VersusGameServerSlotReservationHandler._assign_peers_to_party = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	self:_reserve_slots_in_party(arg_13_2, arg_13_3, arg_13_1)

	if not arg_13_4 then
		self._party_manager:server_add_friend_party_peer_from_invitee(arg_13_1, arg_13_4)
	else
		self._party_manager:server_create_friend_party(arg_13_3, arg_13_1)
	end
end

VersusGameServerSlotReservationHandler._unreserve_slot_delayed = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local _find_party_and_index_from_peer_id, var_14_1 = self:_find_party_and_index_from_peer_id(arg_14_1, arg_14_2)

	self._num_slots_reserved = self._num_slots_reserved - 1

	self:_unreserve_party_slot(_find_party_and_index_from_peer_id, var_14_1, arg_14_1, arg_14_3)
	self:_update_lobby_reservations()

	if not arg_14_3 then
		self:send_slot_update_to_clients()
	end
end

VersusGameServerSlotReservationHandler.is_fully_reserved = function (self)
	-- function 15
	local get_party_from_name = self._party_manager:get_party_from_name("spectators")
	local flag = not get_party_from_name and get_party_from_name.party_id
	local _reserved_peers = self._reserved_peers
	local num = 0

	for i = 1, #_reserved_peers do
		if i ~= flag then
			local _num_unreserved_slots = self:_num_unreserved_slots(i)

			if _num_unreserved_slots > 0 then
				return false
			end

			num = num + _num_unreserved_slots
		end
	end

	if num - self:_num_reserved_slots(0) > 0 then
		return false
	end

	return true
end

VersusGameServerSlotReservationHandler.is_empty = function (self)
	-- function 16
	local get_party_from_name = self._party_manager:get_party_from_name("spectators")
	local flag = not get_party_from_name and get_party_from_name.party_id
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_16_3 = _reserved_peers[i]

		if i ~= flag then
			for i_2, v in ipairs(var_16_3) do
				if not v.reserved then
					return false
				end
			end
		end
	end

	return true
end

VersusGameServerSlotReservationHandler.reservers = function (self)
	-- function 17
	local tbl = {}
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_17_2 = _reserved_peers[i]

		for j = 1, #var_17_2 do
			local var_17_3 = var_17_2[j]

			if not var_17_3.reserver then
				tbl[#tbl + 1] = var_17_3.peer_id
			end
		end
	end

	return tbl
end

VersusGameServerSlotReservationHandler.peers = function (self, arg_18_1)
	-- function 18
	arg_18_1 = arg_18_1 or {}

	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_18_1 = _reserved_peers[i]

		for j = 1, #var_18_1 do
			local peer_id = var_18_1[j].peer_id

			if not peer_id then
				arg_18_1[#arg_18_1 + 1] = peer_id
			end
		end
	end

	return arg_18_1
end

VersusGameServerSlotReservationHandler.party_peers = function (self, arg_19_1)
	-- function 19
	local tbl = {}
	local var_19_1 = self._reserved_peers[arg_19_1]

	for i = 1, #var_19_1 do
		local peer_id = var_19_1[i].peer_id

		if not peer_id then
			tbl[#tbl + 1] = peer_id
		end
	end

	return tbl
end

VersusGameServerSlotReservationHandler.is_all_reserved_peers_joined = function (self, arg_20_1)
	-- function 20
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_20_1 = _reserved_peers[i]

		for j = 1, #var_20_1 do
			local peer_id = var_20_1[j].peer_id

			if not (not peer_id and arg_20_1[peer_id]) then
				return false
			end
		end
	end

	return true
end

VersusGameServerSlotReservationHandler.party_id = function (self, arg_21_1)
	-- function 21
	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		local var_21_1 = _reserved_peers[i]

		if not var_21_1 then
			for j = 1, #var_21_1 do
				if var_21_1[j].peer_id == arg_21_1 then
					return i
				end
			end
		end
	end

	return nil
end

VersusGameServerSlotReservationHandler._can_join_invitee_party = function (self, arg_22_1, arg_22_2)
	-- function 22
	local party_id = self:party_id(arg_22_1)

	if not party_id then
		return false
	end

	if not self:_can_join_specified_party(party_id, arg_22_2) then
		return party_id
	end
end

VersusGameServerSlotReservationHandler._can_join_specified_party = function (self, arg_23_1, arg_23_2)
	-- function 23
	if arg_23_2 <= self:_num_unreserved_slots(arg_23_1) then
		return true
	end

	return false
end

VersusGameServerSlotReservationHandler.dump = function (self)
	-- function 24
	print("-------------[VersusGameServerSlotReservationHandler]-------------")

	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		printf("party_id[%s]", i)

		local var_24_1 = _reserved_peers[i]

		for j = 1, #var_24_1 do
			local var_24_2 = var_24_1[j]

			printf("  [%u] taken-%s peer_id-%s reserver-%s", j, var_24_2.reserved, var_24_2.peer_id, var_24_2.reserver)
		end
	end

	print("-------------[VersusGameServerSlotReservationHandler]-------------")
end

VersusGameServerSlotReservationHandler._print_reservations = function (self)
	-- function 25
	local str = "Reservations: "
	local str_2 = "\n"
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_25_3 = _reserved_peers[i]
		local count = #var_25_3
		local str_3 = ""
		local str_4 = "["
		local num = 0

		for j = 1, count do
			local var_25_8 = var_25_3[j]

			if not var_25_8.reserved then
				num = num + 1

				local peer_name = Managers.game_server:peer_name(var_25_8.peer_id)
				local str_5 = ""

				if not var_25_8.reserver then
					str_4 = str_4 .. "L"
					str_3 = string.format("%sL %s (%s)%s\n", str_3, var_25_8.peer_id, peer_name, str_5)
				else
					str_4 = str_4 .. "C"
					str_3 = string.format("%sC %s (%s)%s\n", str_3, var_25_8.peer_id, peer_name, str_5)
				end
			end
		end

		str_2 = string.format("%sParty %d (%d/%d)\n%s", str_2, i, num, count, str_3)

		local str_6 = str_4 .. "] "

		str = str .. str_6
	end

	cprint(str .. str_2)
end

VersusGameServerSlotReservationHandler._find_party_with_least_peers_and_enough_room = function (self, arg_26_1)
	-- function 26
	local var_26_0
	local num = 0
	local get_party_from_name = self._party_manager:get_party_from_name("spectators")
	local flag = not get_party_from_name and get_party_from_name.party_id

	print("_find_party_with_least_peers_and_enough_room ------------------------------------>")

	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		if i ~= flag then
			local _num_unreserved_slots = self:_num_unreserved_slots(i)
			local var_26_6 = _reserved_peers[i]

			print("party_id:", i, var_26_6, _num_unreserved_slots)

			if not (not (arg_26_1 <= _num_unreserved_slots) or not (num < _num_unreserved_slots)) then
				var_26_0 = i
				num = _num_unreserved_slots

				printf("found party! best_party: %s most_free_slots: %s, ", tostring(var_26_0), tostring(num))
			end
		end
	end

	if not var_26_0 then
		print("party found!", var_26_0)

		return var_26_0
	end

	if not (not flag and not (arg_26_1 <= self:_num_unreserved_slots(flag))) then
		print("spectator is best party", var_26_0)

		return flag
	end

	print("No party found!")

	return false
end

VersusGameServerSlotReservationHandler._find_party_with_most_peers_and_enough_room = function (self, arg_27_1)
	-- function 27
	local var_27_0
	local huge = math.huge
	local get_party_from_name = self._party_manager:get_party_from_name("spectators")
	local flag = not get_party_from_name and get_party_from_name.party_id

	print("_find_party_with_most_peers_and_enough_room ------------------------------------>")

	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		if i ~= flag then
			local _num_unreserved_slots = self:_num_unreserved_slots(i)
			local var_27_6 = _reserved_peers[i]

			print("party_id:", i, var_27_6, _num_unreserved_slots)

			if not (not (arg_27_1 <= _num_unreserved_slots) or not (_num_unreserved_slots < huge)) then
				var_27_0 = i
				huge = _num_unreserved_slots

				printf("found party! best_party: %s least_free_slots: %s, ", tostring(var_27_0), tostring(huge))
			end
		end
	end

	if not var_27_0 then
		print("party found!", var_27_0)

		return var_27_0
	end

	if not (not flag and not (arg_27_1 <= self:_num_unreserved_slots(flag))) then
		print("spectator is best party", var_27_0)

		return flag
	end

	print("No party found!")

	return false
end

VersusGameServerSlotReservationHandler._num_unreserved_slots = function (self, arg_28_1)
	-- function 28
	local var_28_0 = self._reserved_peers[arg_28_1]
	local num = 0

	for i = 1, #var_28_0 do
		if not self:_party_slot_is_empty(var_28_0, i) then
			num = num + 1
		end
	end

	return num
end

VersusGameServerSlotReservationHandler._num_reserved_slots = function (self, arg_29_1)
	-- function 29
	local var_29_0 = self._reserved_peers[arg_29_1]
	local num = 0

	for i = 1, #var_29_0 do
		if not self:_party_slot_is_empty(var_29_0, i) then
			num = num + 1
		end
	end

	return num
end

VersusGameServerSlotReservationHandler._reserve_slots_in_party = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local var_30_0 = self._reserved_peers[arg_30_1]

	for i = 1, #arg_30_2 do
		local var_30_1 = arg_30_2[i]
		local flag = arg_30_3 == var_30_1
		local flag_2 = false

		for j = 1, #var_30_0 do
			if not self:_party_slot_is_empty(var_30_0, j) then
				self:_reserve_slot(var_30_0, j, var_30_1, flag)

				flag_2 = true

				break
			end
		end

		self:_dump_assert(flag_2, "Failed reserving slot in party")
	end

	self:_print_reservations()
end

VersusGameServerSlotReservationHandler.reserved_peers_map = function (self)
	-- function 31
	return self._reserved_peers_map
end

VersusGameServerSlotReservationHandler._num_reserved_slots_per_party = function (self)
	-- function 32
	local tbl = {}

	for i = 1, #self._reserved_peers - 1 do
		local var_32_1 = self._reserved_peers[i]

		tbl[i] = 0

		for j = 1, #var_32_1 do
			if not var_32_1[j].reserved then
				tbl[i] = tbl[i] + 1
			end
		end
	end

	return tbl
end

VersusGameServerSlotReservationHandler._party_slot_is_empty = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	return not arg_33_1[arg_33_2].reserved
end

VersusGameServerSlotReservationHandler._reserve_slot = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local var_34_0 = arg_34_1[arg_34_2]

	self:_dump_assert(not var_34_0.reserved, "Trying to reserve already reserved slot")

	var_34_0.reserved = true
	var_34_0.peer_id = arg_34_3
	var_34_0.reserver = arg_34_4
	self._reserved_peers_map[arg_34_3] = true

	Managers.state.event:trigger("game_server_reserve_party_slot", arg_34_2, arg_34_3, arg_34_4)
end

VersusGameServerSlotReservationHandler._unreserve_party_slot = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	local var_35_0 = arg_35_1[arg_35_2]

	self:_dump_assert(var_35_0.reserved, "Trying to unreserve slot that was not reserved")
	fn(var_35_0)

	self._reserved_peers_map[arg_35_3] = nil

	if not arg_35_4 then
		Managers.state.event:trigger("game_server_unreserve_party_slot", arg_35_2, arg_35_3)
	end

	self:_print_reservations()
end

VersusGameServerSlotReservationHandler._find_party_and_index_from_peer_id = function (self, arg_36_1, arg_36_2)
	-- function 36
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_36_1 = _reserved_peers[i]

		for j = 1, #var_36_1 do
			if var_36_1[j].peer_id == arg_36_1 then
				return var_36_1, j, i
			end
		end
	end

	if not arg_36_2 then
		self:_dump_assert(false, "Did not find peer (%s) in reserved slots.", arg_36_1)
	end
end

VersusGameServerSlotReservationHandler.get_peer_id = function (self, arg_37_1, arg_37_2)
	-- function 37
	return self._reserved_peers[arg_37_1][arg_37_2]
end

VersusGameServerSlotReservationHandler._dump_assert = function (self, arg_38_1, arg_38_2, ...)
	-- function 38
	if not arg_38_1 then
		self:dump()
		ferror(arg_38_2, ...)
	end
end

VersusGameServerSlotReservationHandler.should_run_tutorial = function (arg_39_0)
	-- function 39
	return false, nil
end

VersusGameServerSlotReservationHandler.set_party_size = function (self, arg_40_1, arg_40_2)
	-- function 40
	local var_40_0 = self._reserved_peers[arg_40_1]
	local count = #var_40_0

	if arg_40_2 < count - self:_num_unreserved_slots(arg_40_1) then
		return false, "New size smaller than number of players in party"
	end

	if count == arg_40_2 then
		return true
	end

	if arg_40_2 < count then
		for i = arg_40_2 + 1, count do
			var_40_0[i] = nil
		end
	else
		for j = count + 1, arg_40_2 do
			var_40_0[j] = table.clone(tbl)
		end
	end

	self:send_slot_update_to_clients()
	self:_print_reservations()

	return true
end

VersusGameServerSlotReservationHandler.swap_players = function (self, arg_41_1, arg_41_2)
	-- function 41
	if not (not arg_41_1 and not arg_41_2 and arg_41_1 ~= arg_41_2) then
		return false
	end

	if not arg_41_1 then
		return false, "Missing first player peer id"
	end

	if not arg_41_2 then
		return false, "Missing second player peer id"
	end

	if arg_41_1 == arg_41_2 then
		return false, "First player peer id and second player peer id needs to be unique"
	end

	local flag = true
	local _find_party_and_index_from_peer_id, var_41_2 = self:_find_party_and_index_from_peer_id(arg_41_1, flag)
	local _find_party_and_index_from_peer_id_2, var_41_4 = self:_find_party_and_index_from_peer_id(arg_41_2, flag)

	if not _find_party_and_index_from_peer_id then
		return false, "Failed to find first player"
	end

	if not _find_party_and_index_from_peer_id_2 then
		return false, "Failed to find second player"
	end

	_find_party_and_index_from_peer_id_2[var_41_4], _find_party_and_index_from_peer_id[var_41_2] = _find_party_and_index_from_peer_id[var_41_2], _find_party_and_index_from_peer_id_2[var_41_4]

	self:send_slot_update_to_clients()
	self:_print_reservations()
	self:_update_lobby_reservations()

	return true
end

VersusGameServerSlotReservationHandler.move_player = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	if self:_num_unreserved_slots(arg_42_2) < 1 then
		return false
	end

	local _find_party_and_index_from_peer_id, var_42_1 = self:_find_party_and_index_from_peer_id(arg_42_1, arg_42_3)

	if not _find_party_and_index_from_peer_id then
		return false, "Failed to find peer"
	end

	if _find_party_and_index_from_peer_id.party_id == arg_42_2 then
		return true
	end

	local find_empty_slot_in_party = self:find_empty_slot_in_party(arg_42_2)

	if not find_empty_slot_in_party then
		return false, "Failed to find empty slot"
	end

	self._reserved_peers[arg_42_2][find_empty_slot_in_party] = _find_party_and_index_from_peer_id[var_42_1]
	_find_party_and_index_from_peer_id[var_42_1] = table.clone(tbl)

	self:send_slot_update_to_clients()
	self:_print_reservations()
	self:_update_lobby_reservations()

	return true
end

VersusGameServerSlotReservationHandler.find_empty_slot_in_party = function (self, arg_43_1)
	-- function 43
	local var_43_0 = self._reserved_peers[arg_43_1]

	for i = 1, #var_43_0 do
		if var_43_0[i].reserved == false then
			return i
		end
	end
end

VersusGameServerSlotReservationHandler._update_lobby_reservations = function (self)
	-- function 44
	local num = 0
	local num_2 = 0
	local _reserved_peers = self._reserved_peers

	for i = 0, #_reserved_peers do
		local var_44_3 = _reserved_peers[i]
		local count = #var_44_3
		local num_3 = 0

		for j = 1, count do
			if not var_44_3[j].reserved then
				num_3 = num_3 + 1
			end
		end

		for k = 1, num_3 do
			num = bit.bor(num, bit.lshift(1, num_2 + (k - 1)))
		end

		num_2 = num_2 + count
	end

	local lobby = Managers.matchmaking.lobby
	local get_stored_lobby_data = lobby:get_stored_lobby_data()

	get_stored_lobby_data.reserved_slots_mask = num

	lobby:set_lobby_data(get_stored_lobby_data)
end

VersusGameServerSlotReservationHandler.try_balance_teams = function (self)
	-- function 45
	self:_redistribute_parties_evenly()

	return self:is_evenly_distributed()
end

VersusGameServerSlotReservationHandler.is_evenly_distributed = function (self)
	-- function 46
	local auto_force_start = GameModeSettings.inn_vs.auto_force_start
	local _num_reserved_slots_per_party = self:_num_reserved_slots_per_party()
	local abs = math.abs(_num_reserved_slots_per_party[1] - _num_reserved_slots_per_party[2])
	local min, var_46_4 = table.min(_num_reserved_slots_per_party)

	return not (abs <= auto_force_start.max_team_disparity) or var_46_4 >= auto_force_start.min_team_size
end

VersusGameServerSlotReservationHandler._try_add_friend_party = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _reserved_peers = self._reserved_peers
	local count = #arg_47_1

	if not Managers.party:server_has_room_for_friend_party(_reserved_peers, count) then
		local can_kick_to_fill_server = Managers.party:can_kick_to_fill_server(_reserved_peers, count)

		if not can_kick_to_fill_server then
			return false
		else
			for i = 1, #can_kick_to_fill_server do
				local var_47_3 = can_kick_to_fill_server[i]

				for j = #var_47_3.peers, 1, -1 do
					local var_47_4 = var_47_3.peers[j]

					self:unreserve_slot(var_47_4)
					Managers.mechanism:network_handler():force_disconnect_client_by_peer_id(var_47_4)
					print("Force disconnected")
				end
			end
		end
	end

	self._party_manager:server_create_friend_party(arg_47_1, arg_47_2)
	self:_redistribute_parties_evenly()

	return true
end

VersusGameServerSlotReservationHandler._redistribute_parties_evenly = function (self)
	-- function 48
	local _reserved_peers = self._reserved_peers
	local server_get_friend_parties_sorted = self._party_manager:server_get_friend_parties_sorted()

	for i = 0, #_reserved_peers do
		local var_48_2 = _reserved_peers[i]

		for j = 1, #var_48_2 do
			local var_48_3 = var_48_2[j]

			if not var_48_3.reserved then
				fn(var_48_3)
			end
		end
	end

	for k = 1, #server_get_friend_parties_sorted do
		local num = 0
		local var_48_5
		local num_2 = 0

		for l = 1, #_reserved_peers do
			local var_48_7 = _reserved_peers[l]

			if not var_48_7.game_participating then
				local count = #var_48_7
				local _num_unreserved_slots = self:_num_unreserved_slots(l)

				if not (num < _num_unreserved_slots or _num_unreserved_slots ~= num or not (count < num_2)) then
					num = _num_unreserved_slots
					var_48_5 = l
					num_2 = count
				end
			end
		end

		local var_48_10 = server_get_friend_parties_sorted[k]

		self:_reserve_slots_in_party(var_48_5, var_48_10.peers, var_48_10.leader)
	end

	self:_print_reservations()
end

VersusGameServerSlotReservationHandler.remote_client_disconnected = function (arg_49_0, arg_49_1)
	-- function 49
	arg_49_0._pending_peer_informations[arg_49_1] = nil
end

VersusGameServerSlotReservationHandler.get_num_unreserved_slots_per_party = function (self)
	-- function 50
	local tbl = {}
	local _reserved_peers = self._reserved_peers

	for i = 1, #_reserved_peers do
		tbl[i] = self:_num_unreserved_slots(i)
	end

	local num = 0

	for j = 1, #tbl do
		num = num + tbl[j]
	end

	return tbl, num
end

VersusGameServerSlotReservationHandler._is_state_waiting_for_fully_reserved = function (arg_51_0)
	-- function 51
	local game_mode = Managers.state.game_mode
	local flag = not game_mode and game_mode:game_mode()

	return (not flag and flag:game_mode_state()) == "dedicated_server_waiting_for_fully_reserved"
end

VersusGameServerSlotReservationHandler.player_joined_party = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	-- function 52
	if not (arg_52_5 or arg_52_3 ~= 0) then
		return
	end

	local party_id = self:party_id(arg_52_1)
	local get_party = Managers.party:get_party(arg_52_3)

	if not (not party_id and get_party.game_participating) then
		local flag = true

		self:unreserve_slot(arg_52_1, nil, flag)

		return
	end

	if not (not party_id and party_id ~= arg_52_3) then
		return
	end

	local flag_2 = true

	self:move_player(arg_52_1, arg_52_3, flag_2)
end

VersusGameServerSlotReservationHandler.party_id_by_peer = function (self, arg_53_1)
	-- function 53
	local get_party_from_player_id, var_53_1 = Managers.party:get_party_from_player_id(arg_53_1, 1)

	if not (not var_53_1 and var_53_1 ~= 0) then
		var_53_1 = self:party_id(arg_53_1)
	end

	return var_53_1
end

VersusGameServerSlotReservationHandler.handle_slot_reservation_for_connecting_peer = function (arg_54_0, arg_54_1, arg_54_2)
	-- function 54
	if not (not DEDICATED_SERVER and script_data.flexmatch_matchmaking) then
		return SlotReservationConnectStatus.SUCCEEDED
	end
end

VersusGameServerSlotReservationHandler.poll_sync_lobby_data_required = function (arg_55_0)
	-- function 55
	return false
end
