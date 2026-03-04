-- chunkname: @scripts/managers/game_mode/mechanisms/player_hosted_slot_reservation_handler.lua

PlayerHostedSlotReservationHandler = class(PlayerHostedSlotReservationHandler)

local var_0_0 = true
local var_0_1 = {
	reserved = false
}

PlayerHostedSlotReservationHandler.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._owner_peer_id = arg_1_2
	arg_1_0._reservation_handler_type = arg_1_3
	arg_1_0._group_leaders = {}
	arg_1_0._peer_id_to_party_id = {}
	arg_1_0._reserved_peers = {}

	if arg_1_1 then
		arg_1_0:update_slot_settings(arg_1_1)
	end

	arg_1_0._party_manager = Managers.party
	arg_1_0._pending_peer_informations = {}

	Managers.persistent_event:register(arg_1_0, "network_match_changed", "_on_network_match_changed")
	Managers.persistent_event:register(arg_1_0, "network_match_terminated", "_on_network_match_terminated")
	Managers.persistent_event:register(arg_1_0, "new_network_match_synced", "_on_new_network_match_synced")
	printf("[PlayerHostedSlotReservationHandler] Created")

	arg_1_0._synced = false

	local var_1_0 = Managers.mechanism:network_handler()

	if var_1_0 then
		arg_1_0:request_slot_reservation_sync()

		local var_1_1 = Network.peer_id()

		if var_1_0.is_server and arg_1_0._owner_peer_id == var_1_1 then
			local var_1_2 = var_1_0:active_peers()

			var_1_2 = table.is_empty(var_1_2) and {
				Network.peer_id()
			} or var_1_2

			arg_1_0:try_reserve_slots(Network.peer_id(), var_1_2)
		end
	end

	arg_1_0._dangling_peers = {}
end

PlayerHostedSlotReservationHandler.set_reservation_handler_type = function (arg_2_0, arg_2_1)
	arg_2_0._reservation_handler_type = arg_2_1
end

PlayerHostedSlotReservationHandler.update_slot_settings = function (arg_3_0, arg_3_1)
	arg_3_0._max_party_slots = 0
	arg_3_0._num_slots_total = 0

	local var_3_0 = 0

	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		if iter_3_1.game_participating then
			local var_3_1 = iter_3_1.party_id
			local var_3_2 = iter_3_1.num_slots

			arg_3_0:_expand(var_3_1, var_3_2)

			var_3_0 = math.max(var_3_0, var_3_1)

			for iter_3_2 = 1, #arg_3_0._reserved_peers[var_3_1] do
				local var_3_3 = arg_3_0._reserved_peers[var_3_1][iter_3_2]

				if var_3_3 and var_3_3.reserved then
					arg_3_0._peer_id_to_party_id[var_3_3.peer_id] = var_3_1
				end
			end
		end
	end

	local var_3_4 = {}

	for iter_3_3 = var_3_0 + 1, #arg_3_0._reserved_peers do
		local var_3_5 = arg_3_0._reserved_peers[iter_3_3]

		for iter_3_4 = 1, #var_3_5 do
			local var_3_6 = var_3_5[iter_3_4]

			if var_3_6.reserved then
				local var_3_7 = var_3_6.peer_id

				var_3_4[#var_3_4 + 1] = var_3_7
			end
		end
	end

	local var_3_8 = #var_3_4

	for iter_3_5 = 1, var_3_8 do
		local var_3_9 = var_3_4[iter_3_5]
		local var_3_10 = false

		for iter_3_6 = 1, var_3_0 do
			local var_3_11 = arg_3_0._reserved_peers[iter_3_6]

			for iter_3_7 = 1, #var_3_11 do
				if not var_3_11[iter_3_7].reserved then
					local var_3_12 = iter_3_5 < var_3_8

					arg_3_0:move_player(var_3_9, iter_3_6, var_3_12)

					var_3_10 = true

					break
				end
			end

			if var_3_10 then
				break
			end
		end
	end

	for iter_3_8 = var_3_0 + 1, #arg_3_0._reserved_peers do
		assert(table.is_empty(table.select_array(arg_3_0._reserved_peers, function (arg_4_0, arg_4_1)
			return arg_4_1.peer_id
		end)), "[PlayerHostedSlotReservationHandler] Dangling peers remain in the slot reservation handler")

		arg_3_0._reserved_peers[iter_3_8] = nil
		arg_3_0._num_slots_per_party[iter_3_8] = nil

		if var_0_0 then
			printf("[PlayerHostedSlotReservationHandler] Shrinking reserved peers. Removing party %s", iter_3_8)
		end
	end
end

PlayerHostedSlotReservationHandler._recalculate_slots = function (arg_5_0)
	arg_5_0._num_slots_total = 0
	arg_5_0._max_party_slots = 0
	arg_5_0._num_slots_per_party = {}

	local var_5_0 = arg_5_0._reserved_peers

	for iter_5_0 = 1, #var_5_0 do
		local var_5_1 = #var_5_0[iter_5_0]

		arg_5_0._num_slots_total = arg_5_0._num_slots_total + var_5_1
		arg_5_0._num_slots_per_party[iter_5_0] = var_5_1

		if var_5_1 > arg_5_0._max_party_slots then
			arg_5_0._max_party_slots = var_5_1
		end
	end
end

PlayerHostedSlotReservationHandler._expand = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._reserved_peers

	for iter_6_0 = #var_6_0 + 1, arg_6_1 do
		if var_0_0 then
			printf("[PlayerHostedSlotReservationHandler] Expanding. Adding party %s", iter_6_0)
		end

		var_6_0[iter_6_0] = {}
	end

	local var_6_1 = var_6_0[arg_6_1]

	for iter_6_1 = #var_6_1 + 1, arg_6_2 do
		if var_0_0 then
			printf("[PlayerHostedSlotReservationHandler] Expanding. Adding slot %s in party %s", iter_6_1, arg_6_1)
		end

		var_6_1[iter_6_1] = table.clone(var_0_1)
	end

	arg_6_0:_recalculate_slots()
end

PlayerHostedSlotReservationHandler.handle_dangling_peers = function (arg_7_0)
	if table.is_empty(arg_7_0._dangling_peers) then
		return
	end

	local var_7_0 = Managers.mechanism:network_handler()
	local var_7_1 = Managers.time:time("main")

	for iter_7_0, iter_7_1 in pairs(arg_7_0._dangling_peers) do
		if iter_7_1 < var_7_1 then
			var_7_0:force_disconnect_client_by_peer_id(iter_7_0)

			arg_7_0._dangling_peers[iter_7_0] = nil
		end
	end
end

PlayerHostedSlotReservationHandler.num_slots_total = function (arg_8_0)
	return arg_8_0._num_slots_total
end

PlayerHostedSlotReservationHandler.max_party_slots = function (arg_9_0)
	return arg_9_0._max_party_slots
end

PlayerHostedSlotReservationHandler.try_reserve_slots = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = false
	local var_10_1

	if table.is_empty(arg_10_2) then
		printf("[PlayerHostedSlotReservationHandler] Tried to reserve slots for peer %s, but no peers were provided", arg_10_1)

		return var_10_0, var_10_1
	end

	if arg_10_3 then
		arg_10_1 = arg_10_3
	end

	local var_10_2 = arg_10_0:_filter_already_reserved_peers(arg_10_2)

	if table.is_empty(var_10_2) then
		var_10_0 = true
		var_10_1 = arg_10_0._peer_id_to_party_id[arg_10_1]

		printf("[PlayerHostedSlotReservationHandler] Attempted to reserve peers (%s), but they were already in party %s", table.concat(arg_10_2, ", "), var_10_1)

		return var_10_0, var_10_1
	end

	local var_10_3 = #var_10_2
	local var_10_4 = 0

	for iter_10_0, iter_10_1 in ipairs(arg_10_0._reserved_peers) do
		local var_10_5 = arg_10_0:_num_free_slots_in_party(iter_10_0)

		if var_10_3 <= var_10_5 and var_10_4 < var_10_5 then
			var_10_1 = iter_10_0
			var_10_4 = var_10_5
		end
	end

	if var_10_1 then
		if Managers.mechanism:game_mechanism():is_hosting_versus_custom_game() then
			if arg_10_3 then
				arg_10_0._party_manager:server_add_friend_party_peer_from_invitee(arg_10_1, arg_10_3)
			else
				arg_10_0._party_manager:server_create_friend_party(arg_10_2, arg_10_1)
			end

			arg_10_0._party_manager:sync_friend_party_ids()
		end

		local var_10_6 = arg_10_0._party_manager:get_friend_party_id_from_peer(arg_10_1)

		for iter_10_2 = 1, #var_10_2 do
			for iter_10_3, iter_10_4 in pairs(arg_10_0._reserved_peers[var_10_1]) do
				local var_10_7 = var_10_2[iter_10_2]

				if not iter_10_4.reserved then
					arg_10_0:_write_party_slot(iter_10_4, var_10_7, var_10_6, arg_10_1, var_10_1)

					break
				end
			end
		end

		var_10_0 = true
	else
		printf("[PlayerHostedSlotReservationHandler] Failed to reserve slot for peers (%s).", table.concat(var_10_2))
		table.dump(arg_10_0._reserved_peers, "Reserved Peers", 2)
	end

	if var_10_0 then
		arg_10_0:_update_reservations()
	end

	return var_10_0, var_10_1
end

PlayerHostedSlotReservationHandler._filter_already_reserved_peers = function (arg_11_0, arg_11_1)
	local var_11_0

	for iter_11_0 = #arg_11_1, 1, -1 do
		if arg_11_0:has_reservation(arg_11_1[iter_11_0]) then
			var_11_0 = var_11_0 or table.shallow_copy(arg_11_1, true)

			table.remove(var_11_0, iter_11_0)
		end
	end

	return var_11_0 or arg_11_1
end

PlayerHostedSlotReservationHandler._num_free_slots_in_party = function (arg_12_0, arg_12_1)
	local var_12_0 = 0

	for iter_12_0, iter_12_1 in pairs(arg_12_0._reserved_peers[arg_12_1]) do
		if not iter_12_1.reserved then
			var_12_0 = var_12_0 + 1
		end
	end

	return var_12_0
end

PlayerHostedSlotReservationHandler._update_reservations = function (arg_13_0)
	local var_13_0 = 0
	local var_13_1 = 0
	local var_13_2 = ""

	for iter_13_0, iter_13_1 in ipairs(arg_13_0._reserved_peers) do
		local var_13_3 = arg_13_0._num_slots_per_party[iter_13_0]
		local var_13_4 = var_13_3 - arg_13_0:_num_free_slots_in_party(iter_13_0)

		for iter_13_2 = 1, var_13_4 do
			var_13_0 = bit.bor(var_13_0, bit.lshift(1, var_13_1 + (iter_13_2 - 1)))
			var_13_2 = var_13_2 .. "1"
		end

		for iter_13_3 = var_13_4 + 1, var_13_3 do
			var_13_2 = var_13_2 .. "0"
		end

		var_13_1 = var_13_1 + var_13_3
	end

	print("[PlayerHostedSlotReservationHandler] updating reservations. slots:", var_13_2, var_13_0)

	local var_13_5 = Managers.state.network

	if var_13_5 then
		arg_13_0._dirty_reserved_slots = nil

		local var_13_6 = var_13_5:lobby()

		arg_13_0:_update_lobby_data(var_13_6, var_13_0)

		arg_13_0._lobby_data_sync_requested = true
	else
		arg_13_0._dirty_reserved_slots = var_13_0
	end

	arg_13_0:_send_peer_updates_to_clients()
end

PlayerHostedSlotReservationHandler.remove_peer_reservations = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0
	local var_14_1 = arg_14_0._group_leaders[arg_14_1]
	local var_14_3

	if var_14_1 then
		if not arg_14_2 then
			local var_14_2 = arg_14_1

			for iter_14_0 in pairs(var_14_1) do
				if iter_14_0 ~= var_14_2 then
					if PEER_ID_TO_CHANNEL[iter_14_0] then
						var_14_1[iter_14_0] = nil
					else
						printf("[PlayerHostedSlotReservationHandler] Removing peer %s since they are in a party with peer %s and we don't have a connection to them.", iter_14_0, var_14_2)
					end
				end
			end
		end

		for iter_14_1, iter_14_2 in pairs(var_14_1) do
			arg_14_0:_remove_peer_reservation(iter_14_1)
		end

		var_14_3 = true
	else
		var_14_3 = arg_14_0:_remove_peer_reservation(arg_14_1)
	end

	if var_14_3 then
		arg_14_0:_update_reservations()
	end
end

PlayerHostedSlotReservationHandler.network_context_created = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if not arg_15_4 then
		arg_15_0._dirty_reserved_slots = nil
	elseif arg_15_0._dirty_reserved_slots then
		arg_15_0:_update_lobby_data(arg_15_1, arg_15_0._dirty_reserved_slots)

		arg_15_0._dirty_reserved_slots = nil
	end
end

PlayerHostedSlotReservationHandler._update_lobby_data = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.lobby_data_table

	var_16_0.reserved_slots_mask = arg_16_2

	arg_16_1:set_lobby_data(var_16_0)
end

PlayerHostedSlotReservationHandler._remove_peer_reservation = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._peer_id_to_party_id[arg_17_1]

	if arg_17_0._dangling_peers[arg_17_1] then
		arg_17_0._dangling_peers[arg_17_1] = nil

		return false
	elseif not var_17_0 then
		return false
	else
		local var_17_1 = false
		local var_17_2 = arg_17_0._reserved_peers[var_17_0]

		for iter_17_0 = 1, #var_17_2 do
			if var_17_2[iter_17_0].peer_id == arg_17_1 then
				arg_17_0:_clear_party_slot(var_17_2[iter_17_0])

				var_17_1 = true

				break
			end
		end

		print("[PlayerHostedSlotReservationHandler] Removing reserved peer %s", arg_17_1)

		local var_17_3 = Managers.mechanism:game_mechanism()

		if var_17_3.is_hosting_versus_custom_game and var_17_3:is_hosting_versus_custom_game() and var_17_1 then
			arg_17_0._party_manager:server_remove_friend_party_peer(arg_17_1)
		elseif not var_17_1 then
			-- Nothing
		end

		arg_17_0._peer_id_to_party_id[arg_17_1] = nil

		if arg_17_0._group_leaders[arg_17_1] then
			local var_17_4 = table.find_func(arg_17_0._group_leaders[arg_17_1], function (arg_18_0)
				return arg_18_0 ~= arg_17_1
			end)

			if var_17_4 then
				arg_17_0._group_leaders[var_17_4] = arg_17_0._group_leaders[arg_17_1]
			end
		end

		arg_17_0._group_leaders[arg_17_1] = nil

		return var_17_1
	end
end

PlayerHostedSlotReservationHandler.party_id = function (arg_19_0, arg_19_1)
	return arg_19_0._peer_id_to_party_id[arg_19_1]
end

PlayerHostedSlotReservationHandler.all_teams_have_members = function (arg_20_0)
	local var_20_0 = Managers.party

	for iter_20_0, iter_20_1 in ipairs(arg_20_0._reserved_peers) do
		if var_20_0:is_game_participating(iter_20_0) and arg_20_0._num_slots_per_party[iter_20_0] == arg_20_0:_num_free_slots_in_party(iter_20_0) then
			return false
		end
	end

	return true
end

PlayerHostedSlotReservationHandler.get_group_leaders = function (arg_21_0)
	return table.keys(arg_21_0._group_leaders)
end

PlayerHostedSlotReservationHandler.get_leader_from_peer = function (arg_22_0, arg_22_1)
	for iter_22_0, iter_22_1 in pairs(arg_22_0._group_leaders) do
		if iter_22_1[arg_22_1] then
			return iter_22_0
		end
	end
end

PlayerHostedSlotReservationHandler.peers = function (arg_23_0)
	return table.keys(arg_23_0._peer_id_to_party_id)
end

PlayerHostedSlotReservationHandler.peers_by_party = function (arg_24_0, arg_24_1)
	return table.keys(table.filter(arg_24_0._peer_id_to_party_id, function (arg_25_0)
		return arg_24_1 == arg_25_0
	end))
end

PlayerHostedSlotReservationHandler.party_id_by_peer = function (arg_26_0, arg_26_1)
	return arg_26_0._peer_id_to_party_id[arg_26_1]
end

PlayerHostedSlotReservationHandler.update_slots = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	arg_27_0._synced = true

	for iter_27_0 = 1, #arg_27_0._reserved_peers do
		local var_27_0 = arg_27_0._reserved_peers[iter_27_0]

		for iter_27_1 = 1, #var_27_0 do
			arg_27_0:_clear_party_slot(var_27_0[iter_27_1])
		end
	end

	table.clear(arg_27_0._group_leaders)
	table.clear(arg_27_0._peer_id_to_party_id)

	if var_0_0 then
		printf("[PlayerHostedSlotReservationHandler] Updating slots (%s) (%s)", table.concat(arg_27_1, ", "), table.concat(arg_27_2, ", "))
	end

	assert(table.find(arg_27_1, Network.peer_id()), "[PlayerHostedSlotReservationHandler] Missing self in reservation handler")

	for iter_27_2 = 1, #arg_27_1 do
		local var_27_1 = arg_27_1[iter_27_2]
		local var_27_2 = arg_27_2[iter_27_2]
		local var_27_3 = arg_27_3[iter_27_2]
		local var_27_4 = arg_27_4[iter_27_2]
		local var_27_5 = false
		local var_27_6 = arg_27_0._reserved_peers[var_27_2]

		if var_27_6 then
			for iter_27_3 = 1, #var_27_6 do
				local var_27_7 = var_27_6[iter_27_3]

				if not var_27_7.reserved then
					arg_27_0:_write_party_slot(var_27_7, var_27_1, var_27_3, var_27_4, var_27_2)

					var_27_5 = true

					break
				end
			end
		end

		if not var_27_5 then
			arg_27_0:_expand(var_27_2, var_27_6 and #var_27_6 + 1 or 1)

			local var_27_8 = arg_27_0._reserved_peers[var_27_2]

			arg_27_0:_write_party_slot(var_27_8[#var_27_8], var_27_1, var_27_3, var_27_4, var_27_2)
		end
	end

	if Managers.mechanism:is_server() then
		if var_0_0 then
			local var_27_9 = table.concat(table.select_array(arg_27_0._reserved_peers, function (arg_28_0, arg_28_1)
				return table.concat(table.select_array(arg_28_1, function (arg_29_0, arg_29_1)
					return arg_29_1.peer_id
				end), ", ")
			end), " | ")

			printf("[PlayerHostedSlotReservationHandler] Sending update to clients (%s)", var_27_9)
		end

		local var_27_10 = NetworkLookup.reservation_handler_types[arg_27_0._reservation_handler_type]

		Managers.mechanism:network_handler():get_match_handler():send_rpc_down_if("rpc_sync_vs_custom_game_slot_data", function (arg_30_0)
			return table.find(arg_27_1, arg_30_0)
		end, arg_27_0._owner_peer_id, var_27_10, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	end
end

PlayerHostedSlotReservationHandler.party_peers = function (arg_31_0, arg_31_1)
	return table.keys_if(arg_31_0._peer_id_to_party_id, nil, function (arg_32_0, arg_32_1)
		return arg_31_1 == arg_32_1
	end)
end

PlayerHostedSlotReservationHandler.player_joined_party = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	if arg_33_5 or arg_33_3 == 0 then
		return
	end

	local var_33_0 = arg_33_0._peer_id_to_party_id[arg_33_1]
	local var_33_1 = Managers.party:get_party(arg_33_3)

	if var_33_0 and not var_33_1.game_participating then
		arg_33_0:_remove_peer_reservation(arg_33_1)

		return
	end

	if not var_33_0 or var_33_0 == arg_33_3 then
		return
	end

	arg_33_0:move_player(arg_33_1, arg_33_3)
end

PlayerHostedSlotReservationHandler.request_party_change = function (arg_34_0, arg_34_1)
	local var_34_0 = Network.peer_id()

	Managers.state.network.network_transmit:send_rpc_server("rpc_slot_reservation_request_party_change", var_34_0, arg_34_1)
end

PlayerHostedSlotReservationHandler.slot_reservation_sync_requested = function (arg_35_0, arg_35_1)
	local var_35_0, var_35_1, var_35_2, var_35_3 = arg_35_0:_build_slot_info()

	if not table.find(var_35_0, arg_35_1) then
		printf("[PlayerHostedSlotReservationHandler] Non reserved peer %s requested a slot reservation sync.", arg_35_1)

		return
	end

	local var_35_4 = NetworkLookup.reservation_handler_types[arg_35_0._reservation_handler_type]

	Managers.mechanism:network_handler():get_match_handler():send_rpc("rpc_sync_vs_custom_game_slot_data", arg_35_1, arg_35_0._owner_peer_id, var_35_4, var_35_0, var_35_1, var_35_2, var_35_3)
end

PlayerHostedSlotReservationHandler.request_slot_reservation_sync = function (arg_36_0)
	Managers.mechanism:network_handler():get_match_handler():send_rpc_up("rpc_request_slot_reservation_sync")
end

PlayerHostedSlotReservationHandler._send_peer_updates_to_clients = function (arg_37_0)
	local var_37_0 = Managers.mechanism:network_handler()

	if not var_37_0 then
		return
	end

	if not var_37_0:get_match_handler():query_peer_data(Network.peer_id(), "is_match_owner") then
		return
	end

	local var_37_1, var_37_2, var_37_3, var_37_4 = arg_37_0:_build_slot_info()

	arg_37_0:update_slots(var_37_1, var_37_2, var_37_3, var_37_4)
end

local var_0_2 = {}
local var_0_3 = {}
local var_0_4 = {}
local var_0_5 = {}

PlayerHostedSlotReservationHandler._build_slot_info = function (arg_38_0)
	table.clear(var_0_2)
	table.clear(var_0_3)
	table.clear(var_0_4)
	table.clear(var_0_5)

	local var_38_0 = 1

	for iter_38_0 = 1, #arg_38_0._reserved_peers do
		local var_38_1 = arg_38_0._reserved_peers[iter_38_0]

		for iter_38_1 = 1, #var_38_1 do
			local var_38_2 = var_38_1[iter_38_1]

			if var_38_2.reserved then
				var_0_2[var_38_0] = var_38_2.peer_id
				var_0_3[var_38_0] = iter_38_0
				var_0_4[var_38_0] = var_38_2.friend_party_id or 1
				var_0_5[var_38_0] = var_38_2.friend_party_leader or ""
				var_38_0 = var_38_0 + 1
			end
		end
	end

	return var_0_2, var_0_3, var_0_4, var_0_5
end

PlayerHostedSlotReservationHandler.get_peer_reserved_indices = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._reserved_peers

	for iter_39_0 = 1, #var_39_0 do
		local var_39_1 = var_39_0[iter_39_0]

		for iter_39_1 = 1, #var_39_1 do
			if var_39_1[iter_39_1].peer_id == arg_39_1 then
				return iter_39_0, iter_39_1
			end
		end
	end
end

PlayerHostedSlotReservationHandler._get_peer_slot_data = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._reserved_peers

	for iter_40_0 = 1, #var_40_0 do
		local var_40_1 = var_40_0[iter_40_0]

		for iter_40_1 = 1, #var_40_1 do
			local var_40_2 = var_40_1[iter_40_1]

			if var_40_2.peer_id == arg_40_1 then
				return var_40_2
			end
		end
	end
end

PlayerHostedSlotReservationHandler.move_player = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_0:_num_free_slots_in_party(arg_41_2) < 1 then
		return false
	end

	local var_41_0 = arg_41_0._peer_id_to_party_id[arg_41_1]

	if not var_41_0 then
		return false, "Failed to find peer"
	end

	if var_41_0 == arg_41_2 then
		return true
	end

	local var_41_1 = false
	local var_41_2 = arg_41_0._reserved_peers[var_41_0]
	local var_41_3 = arg_41_0._reserved_peers[arg_41_2]

	for iter_41_0, iter_41_1 in pairs(var_41_2) do
		if iter_41_1.peer_id == arg_41_1 then
			for iter_41_2, iter_41_3 in pairs(var_41_3) do
				if not iter_41_3.reserved then
					local var_41_4 = iter_41_1.friend_party_id
					local var_41_5 = iter_41_1.friend_party_leader

					arg_41_0:_write_party_slot(iter_41_3, arg_41_1, var_41_4, var_41_5, arg_41_2)
					arg_41_0:_clear_party_slot(iter_41_1)

					var_41_1 = true

					break
				end
			end

			break
		end
	end

	if not var_41_1 then
		Crashify.print_exception("[PlayerHostedSlotReservationHandler]", "Tried removing peer %s but was not reserved to begin with", arg_41_1)
	end

	if not arg_41_3 then
		arg_41_0:_update_reservations()
	end

	return true
end

PlayerHostedSlotReservationHandler.poll_sync_lobby_data_required = function (arg_42_0)
	if arg_42_0._lobby_data_sync_requested then
		arg_42_0._lobby_data_sync_requested = false

		return true
	end

	return false
end

PlayerHostedSlotReservationHandler.remote_client_disconnected = function (arg_43_0, arg_43_1)
	arg_43_0:remove_peer_reservations(arg_43_1)

	arg_43_0._pending_peer_informations[arg_43_1] = nil
end

PlayerHostedSlotReservationHandler.has_reservation = function (arg_44_0, arg_44_1)
	return arg_44_0._peer_id_to_party_id[arg_44_1]
end

PlayerHostedSlotReservationHandler.handle_slot_reservation_for_connecting_peer = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_1.peer_id
	local var_45_1 = false
	local var_45_2 = arg_45_0._pending_peer_informations[var_45_0]

	if not var_45_2 then
		var_45_2 = {
			resend_timer = 3,
			reserved = false,
			status = SlotReservationConnectStatus.PENDING,
			peers = {}
		}
		arg_45_0._pending_peer_informations[var_45_0] = var_45_2
		var_45_1 = true
	else
		var_45_2.resend_timer = var_45_2.resend_timer - arg_45_2
	end

	if var_45_2.status == SlotReservationConnectStatus.PENDING and var_45_2.resend_timer < 0 then
		var_45_1 = true
		var_45_2.resend_timer = 3
	end

	if var_45_1 then
		printf("[PlayerHostedSlotReservationHandler] Requesting reservation info from peer '%s'", var_45_0)

		local var_45_3 = PEER_ID_TO_CHANNEL[var_45_0]

		RPC.rpc_slot_reservation_request_peers(var_45_3)
	end

	return var_45_2.status
end

PlayerHostedSlotReservationHandler.connecting_slot_reservation_info_received = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_0._pending_peer_informations[arg_46_1]

	if var_46_0.status ~= SlotReservationConnectStatus.PENDING then
		printf("[PlayerHostedSlotReservationHandler]", "Received slot reservation info from already handled peer '%s'.", arg_46_1)

		return
	end

	for iter_46_0 = 1, #arg_46_2 do
		local var_46_1 = arg_46_2[iter_46_0]

		arg_46_0._pending_peer_informations[var_46_1] = var_46_0
		var_46_0.peers[iter_46_0] = var_46_1
	end

	local var_46_2 = Managers.matchmaking

	if not var_46_2 or not var_46_2:is_in_versus_custom_game_lobby() then
		arg_46_3 = Network.peer_id()
	end

	local var_46_3 = arg_46_0:try_reserve_slots(arg_46_3, var_46_0.peers)

	printf("[PlayerHostedSlotReservationHandler] Peer info from peer '%s' received. (%s) joining. Success: %s", arg_46_1, table.concat(arg_46_2, ","), var_46_3)

	if var_46_3 then
		var_46_0.reserved = true
		var_46_0.status = SlotReservationConnectStatus.SUCCEEDED
	else
		var_46_0.status = SlotReservationConnectStatus.FAILED
	end
end

PlayerHostedSlotReservationHandler._change_leader = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0:get_leader_from_peer(arg_47_1)

	if var_47_0 then
		arg_47_0._group_leaders[var_47_0][arg_47_1] = nil

		if table.is_empty(arg_47_0._group_leaders[var_47_0]) then
			arg_47_0._group_leaders[var_47_0] = nil
		end
	end

	arg_47_0._group_leaders[arg_47_2] = arg_47_0._group_leaders[arg_47_2] or {}
	arg_47_0._group_leaders[arg_47_2][arg_47_1] = true
end

PlayerHostedSlotReservationHandler._clear_party_slot = function (arg_48_0, arg_48_1)
	if var_0_0 and arg_48_1.peer_id then
		printf("[PlayerHostedSlotReservationHandler] Clearing peer %s from party %s (friend party %s leader %s)", arg_48_1.peer_id, arg_48_1.party_id, arg_48_1.friend_party_id, arg_48_1.friend_party_leader)
	end

	arg_48_1.reserved = false
	arg_48_1.peer_id = nil
	arg_48_1.friend_party_id = nil
	arg_48_1.friend_party_leader = nil
	arg_48_1.party_id = nil
end

PlayerHostedSlotReservationHandler._write_party_slot = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	arg_49_1.reserved = true
	arg_49_1.peer_id = arg_49_2
	arg_49_1.friend_party_id = arg_49_3
	arg_49_1.friend_party_leader = arg_49_4
	arg_49_1.party_id = arg_49_5
	arg_49_0._group_leaders[arg_49_4] = arg_49_0._group_leaders[arg_49_4] or {}
	arg_49_0._group_leaders[arg_49_4][arg_49_2] = true
	arg_49_0._peer_id_to_party_id[arg_49_2] = arg_49_5

	if var_0_0 then
		printf("[PlayerHostedSlotReservationHandler] Reserving peer %s to party %s (friend party %s leader %s)", arg_49_2, arg_49_5, arg_49_3, arg_49_4)
	end
end

PlayerHostedSlotReservationHandler._clear_non_session_peers = function (arg_50_0)
	local var_50_0 = Network.peer_id()
	local var_50_1 = arg_50_0._synced and arg_50_0:_get_peer_slot_data(var_50_0)
	local var_50_2 = var_50_1 and var_50_1.friend_party_leader or var_50_0
	local var_50_3 = arg_50_0._reserved_peers

	for iter_50_0 = 1, #var_50_3 do
		local var_50_4 = var_50_3[iter_50_0]

		for iter_50_1 = 1, #var_50_4 do
			local var_50_5 = var_50_4[iter_50_1]

			if var_50_5.peer_id and var_50_5.friend_party_leader ~= var_50_2 then
				arg_50_0:_remove_peer_reservation(var_50_5.peer_id)
			end
		end
	end
end

PlayerHostedSlotReservationHandler._on_network_match_changed = function (arg_51_0, arg_51_1)
	if not arg_51_1 then
		arg_51_0:_clear_non_session_peers()
		arg_51_0:update_slot_settings({
			arg_51_0._party_manager:parties()[1]
		})
	end
end

PlayerHostedSlotReservationHandler._on_network_match_terminated = function (arg_52_0)
	arg_52_0._synced = false

	arg_52_0:_clear_non_session_peers()
end

PlayerHostedSlotReservationHandler._on_new_network_match_synced = function (arg_53_0, arg_53_1, arg_53_2)
	if arg_53_1 then
		local var_53_0 = Managers.mechanism:network_handler()

		arg_53_0:try_reserve_slots(arg_53_2, var_53_0 and var_53_0:active_peers() or {
			arg_53_2
		})
	else
		arg_53_0:request_slot_reservation_sync()
	end
end

PlayerHostedSlotReservationHandler.destroy = function (arg_54_0)
	Managers.persistent_event:unregister("network_match_changed", arg_54_0)
	Managers.persistent_event:unregister("network_match_terminated", arg_54_0)
	Managers.persistent_event:unregister("new_network_match_synced", arg_54_0)
end
