-- chunkname: @scripts/managers/game_mode/mechanisms/versus_game_server_slot_reservation_handler.lua

VersusGameServerSlotReservationHandler = class(VersusGameServerSlotReservationHandler)

local var_0_0 = {
	reserved = false
}

local function var_0_1(arg_1_0)
	arg_1_0.reserved = false
	arg_1_0.peer_id = nil
	arg_1_0.reserver = nil
end

function VersusGameServerSlotReservationHandler.init(arg_2_0, arg_2_1)
	fassert(DEDICATED_SERVER, "[VersusGameServerSlotReservationHandler] Should only be initialized on a dedicated server.")

	local var_2_0 = script_data.dedicated_server_reservation_slots

	if var_2_0 then
		printf("Modifying party definitions, num_players: %s", tostring(var_2_0))

		var_2_0 = string.split_deprecated(var_2_0, ",")
	end

	arg_2_0._party_manager = Managers.party
	arg_2_0._num_slots_total = 0
	arg_2_0._num_slots_reserved = 0
	arg_2_0._max_party_slots = 0
	arg_2_0._reserved_peers = {}
	arg_2_0._pending_peer_informations = {}

	local var_2_1 = Managers.party:create_party(Managers.party:generate_undecided_party())

	arg_2_0:_register_party(var_2_1, var_2_0)

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		arg_2_0:_register_party(iter_2_1)
	end

	arg_2_0._reserved_peers_map = {}
end

function VersusGameServerSlotReservationHandler._register_party(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {}
	local var_3_1 = arg_3_1.party_id
	local var_3_2 = arg_3_2 and tonumber(arg_3_2[var_3_1]) or arg_3_1.num_slots

	if arg_3_1.game_participating then
		arg_3_0._num_slots_total = arg_3_0._num_slots_total + var_3_2

		if var_3_2 > arg_3_0._max_party_slots then
			arg_3_0._max_party_slots = var_3_2
		end
	end

	for iter_3_0 = 1, var_3_2 do
		var_3_0[iter_3_0] = table.clone(var_0_0)
	end

	var_3_0.game_participating = arg_3_1.game_participating
	arg_3_0._reserved_peers[var_3_1] = var_3_0
end

function VersusGameServerSlotReservationHandler.destroy(arg_4_0)
	return
end

function VersusGameServerSlotReservationHandler.send_rpc_to_all_reserving_clients(arg_5_0, arg_5_1, ...)
	local var_5_0 = arg_5_0._reserved_peers

	for iter_5_0 = 0, #var_5_0 do
		local var_5_1 = var_5_0[iter_5_0]

		for iter_5_1, iter_5_2 in ipairs(var_5_1) do
			local var_5_2 = iter_5_2.peer_id

			if var_5_2 and iter_5_2.reserver then
				local var_5_3 = PEER_ID_TO_CHANNEL[var_5_2]

				if var_5_3 then
					RPC[arg_5_1](var_5_3, ...)
				end
			end
		end
	end
end

function VersusGameServerSlotReservationHandler.send_slot_update_to_clients(arg_6_0)
	arg_6_0:_send_peer_updates_to_clients()

	local var_6_0 = arg_6_0._reserved_peers

	for iter_6_0 = 0, #var_6_0 do
		local var_6_1 = var_6_0[iter_6_0]

		for iter_6_1, iter_6_2 in ipairs(var_6_1) do
			local var_6_2 = iter_6_2.peer_id

			if var_6_2 and iter_6_2.reserver then
				local var_6_3 = PEER_ID_TO_CHANNEL[var_6_2]

				if var_6_3 then
					RPC.rpc_reserved_slots_count(var_6_3, arg_6_0._num_slots_reserved, arg_6_0._num_slots_total)
				end
			end
		end
	end
end

function VersusGameServerSlotReservationHandler.num_slots_total(arg_7_0)
	return arg_7_0._num_slots_total
end

function VersusGameServerSlotReservationHandler.max_party_slots(arg_8_0)
	return arg_8_0._max_party_slots
end

function VersusGameServerSlotReservationHandler._send_peer_updates_to_clients(arg_9_0)
	local var_9_0 = {}
	local var_9_1 = {}
	local var_9_2 = arg_9_0._reserved_peers

	for iter_9_0 = 0, #var_9_2 do
		local var_9_3 = var_9_2[iter_9_0]
		local var_9_4 = {
			slot_state = {},
			party_members = {}
		}

		var_9_0[iter_9_0] = var_9_4

		local var_9_5 = var_9_4.slot_state
		local var_9_6 = var_9_4.party_members

		for iter_9_1 = 1, #var_9_3 do
			local var_9_7 = var_9_3[iter_9_1]

			if var_9_7.reserved then
				var_9_6[iter_9_1] = Managers.game_server:peer_name(var_9_7.peer_id)
				var_9_5[iter_9_1] = var_9_7.reserver and 3 or 2
			else
				var_9_6[iter_9_1] = "-"
				var_9_5[iter_9_1] = 1
			end

			if var_9_7.peer_id and var_9_7.reserver then
				var_9_1[#var_9_1 + 1] = var_9_7.peer_id
			end
		end
	end

	for iter_9_2 = 1, #var_9_1 do
		local var_9_8 = var_9_1[iter_9_2]
		local var_9_9 = PEER_ID_TO_CHANNEL[var_9_8]

		if var_9_9 then
			for iter_9_3, iter_9_4 in ipairs(var_9_2) do
				local var_9_10 = var_9_0[iter_9_3]
				local var_9_11 = Managers.game_server:server_name()

				RPC.rpc_party_slots_status(var_9_9, var_9_11, iter_9_3, var_9_10.party_members, var_9_10.slot_state)
			end
		end
	end
end

function VersusGameServerSlotReservationHandler.try_reserve_slots(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_0._num_slots_reserved = arg_10_0._num_slots_reserved + #arg_10_2

	if not arg_10_4 then
		arg_10_0:send_slot_update_to_clients()
	end

	arg_10_0:_update_lobby_reservations()

	return true
end

function VersusGameServerSlotReservationHandler._find_fitting_party(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = #arg_11_1
	local var_11_1 = GameModeSettings.versus
	local var_11_2

	if arg_11_2 then
		var_11_2 = arg_11_0:_can_join_invitee_party(arg_11_2, var_11_0)
	elseif var_11_1.fill_party_distribution == var_11_1.party_fill_method.fill_first_party then
		var_11_2 = arg_11_0:_find_party_with_most_peers_and_enough_room(var_11_0)
	elseif var_11_1.fill_party_distribution == var_11_1.party_fill_method.distribute_party_even then
		var_11_2 = arg_11_0:_find_party_with_least_peers_and_enough_room(var_11_0)
	end

	return var_11_2
end

function VersusGameServerSlotReservationHandler.unreserve_slot(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0, var_12_1, var_12_2 = arg_12_0:_find_party_and_index_from_peer_id(arg_12_1, arg_12_3)

	if not var_12_1 then
		return
	end

	arg_12_0:_unreserve_slot_delayed(arg_12_1, var_12_0, var_12_1, arg_12_3, arg_12_2)
	arg_12_0._party_manager:server_remove_friend_party_peer(arg_12_1)
end

function VersusGameServerSlotReservationHandler._assign_peers_to_party(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0:_reserve_slots_in_party(arg_13_2, arg_13_3, arg_13_1)

	if arg_13_4 then
		arg_13_0._party_manager:server_add_friend_party_peer_from_invitee(arg_13_1, arg_13_4)
	else
		arg_13_0._party_manager:server_create_friend_party(arg_13_3, arg_13_1)
	end
end

function VersusGameServerSlotReservationHandler._unreserve_slot_delayed(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0, var_14_1 = arg_14_0:_find_party_and_index_from_peer_id(arg_14_1, arg_14_2)

	arg_14_0._num_slots_reserved = arg_14_0._num_slots_reserved - 1

	arg_14_0:_unreserve_party_slot(var_14_0, var_14_1, arg_14_1, arg_14_3)
	arg_14_0:_update_lobby_reservations()

	if not arg_14_3 then
		arg_14_0:send_slot_update_to_clients()
	end
end

function VersusGameServerSlotReservationHandler.is_fully_reserved(arg_15_0)
	local var_15_0 = arg_15_0._party_manager:get_party_from_name("spectators")
	local var_15_1 = var_15_0 and var_15_0.party_id
	local var_15_2 = arg_15_0._reserved_peers
	local var_15_3 = 0

	for iter_15_0 = 1, #var_15_2 do
		if iter_15_0 ~= var_15_1 then
			local var_15_4 = arg_15_0:_num_unreserved_slots(iter_15_0)

			if var_15_4 > 0 then
				return false
			end

			var_15_3 = var_15_3 + var_15_4
		end
	end

	if var_15_3 - arg_15_0:_num_reserved_slots(0) > 0 then
		return false
	end

	return true
end

function VersusGameServerSlotReservationHandler.is_empty(arg_16_0)
	local var_16_0 = arg_16_0._party_manager:get_party_from_name("spectators")
	local var_16_1 = var_16_0 and var_16_0.party_id
	local var_16_2 = arg_16_0._reserved_peers

	for iter_16_0 = 0, #var_16_2 do
		local var_16_3 = var_16_2[iter_16_0]

		if iter_16_0 ~= var_16_1 then
			for iter_16_1, iter_16_2 in ipairs(var_16_3) do
				if iter_16_2.reserved then
					return false
				end
			end
		end
	end

	return true
end

function VersusGameServerSlotReservationHandler.reservers(arg_17_0)
	local var_17_0 = {}
	local var_17_1 = arg_17_0._reserved_peers

	for iter_17_0 = 0, #var_17_1 do
		local var_17_2 = var_17_1[iter_17_0]

		for iter_17_1 = 1, #var_17_2 do
			local var_17_3 = var_17_2[iter_17_1]

			if var_17_3.reserver then
				var_17_0[#var_17_0 + 1] = var_17_3.peer_id
			end
		end
	end

	return var_17_0
end

function VersusGameServerSlotReservationHandler.peers(arg_18_0, arg_18_1)
	arg_18_1 = arg_18_1 or {}

	local var_18_0 = arg_18_0._reserved_peers

	for iter_18_0 = 0, #var_18_0 do
		local var_18_1 = var_18_0[iter_18_0]

		for iter_18_1 = 1, #var_18_1 do
			local var_18_2 = var_18_1[iter_18_1].peer_id

			if var_18_2 then
				arg_18_1[#arg_18_1 + 1] = var_18_2
			end
		end
	end

	return arg_18_1
end

function VersusGameServerSlotReservationHandler.party_peers(arg_19_0, arg_19_1)
	local var_19_0 = {}
	local var_19_1 = arg_19_0._reserved_peers[arg_19_1]

	for iter_19_0 = 1, #var_19_1 do
		local var_19_2 = var_19_1[iter_19_0].peer_id

		if var_19_2 then
			var_19_0[#var_19_0 + 1] = var_19_2
		end
	end

	return var_19_0
end

function VersusGameServerSlotReservationHandler.is_all_reserved_peers_joined(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._reserved_peers

	for iter_20_0 = 0, #var_20_0 do
		local var_20_1 = var_20_0[iter_20_0]

		for iter_20_1 = 1, #var_20_1 do
			local var_20_2 = var_20_1[iter_20_1].peer_id

			if var_20_2 and not arg_20_1[var_20_2] then
				return false
			end
		end
	end

	return true
end

function VersusGameServerSlotReservationHandler.party_id(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._reserved_peers

	for iter_21_0 = 1, #var_21_0 do
		local var_21_1 = var_21_0[iter_21_0]

		if var_21_1 then
			for iter_21_1 = 1, #var_21_1 do
				if var_21_1[iter_21_1].peer_id == arg_21_1 then
					return iter_21_0
				end
			end
		end
	end

	return nil
end

function VersusGameServerSlotReservationHandler._can_join_invitee_party(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0:party_id(arg_22_1)

	if not var_22_0 then
		return false
	end

	if arg_22_0:_can_join_specified_party(var_22_0, arg_22_2) then
		return var_22_0
	end
end

function VersusGameServerSlotReservationHandler._can_join_specified_party(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_2 <= arg_23_0:_num_unreserved_slots(arg_23_1) then
		return true
	end

	return false
end

function VersusGameServerSlotReservationHandler.dump(arg_24_0)
	print("-------------[VersusGameServerSlotReservationHandler]-------------")

	local var_24_0 = arg_24_0._reserved_peers

	for iter_24_0 = 1, #var_24_0 do
		printf("party_id[%s]", iter_24_0)

		local var_24_1 = var_24_0[iter_24_0]

		for iter_24_1 = 1, #var_24_1 do
			local var_24_2 = var_24_1[iter_24_1]

			printf("  [%u] taken-%s peer_id-%s reserver-%s", iter_24_1, var_24_2.reserved, var_24_2.peer_id, var_24_2.reserver)
		end
	end

	print("-------------[VersusGameServerSlotReservationHandler]-------------")
end

function VersusGameServerSlotReservationHandler._print_reservations(arg_25_0)
	local var_25_0 = "Reservations: "
	local var_25_1 = "\n"
	local var_25_2 = arg_25_0._reserved_peers

	for iter_25_0 = 0, #var_25_2 do
		local var_25_3 = var_25_2[iter_25_0]
		local var_25_4 = #var_25_3
		local var_25_5 = ""
		local var_25_6 = "["
		local var_25_7 = 0

		for iter_25_1 = 1, var_25_4 do
			local var_25_8 = var_25_3[iter_25_1]

			if var_25_8.reserved then
				var_25_7 = var_25_7 + 1

				local var_25_9 = Managers.game_server:peer_name(var_25_8.peer_id)
				local var_25_10 = ""

				if var_25_8.reserver then
					var_25_6 = var_25_6 .. "L"
					var_25_5 = string.format("%sL %s (%s)%s\n", var_25_5, var_25_8.peer_id, var_25_9, var_25_10)
				else
					var_25_6 = var_25_6 .. "C"
					var_25_5 = string.format("%sC %s (%s)%s\n", var_25_5, var_25_8.peer_id, var_25_9, var_25_10)
				end
			end
		end

		var_25_1 = string.format("%sParty %d (%d/%d)\n%s", var_25_1, iter_25_0, var_25_7, var_25_4, var_25_5)

		local var_25_11 = var_25_6 .. "] "

		var_25_0 = var_25_0 .. var_25_11
	end

	cprint(var_25_0 .. var_25_1)
end

function VersusGameServerSlotReservationHandler._find_party_with_least_peers_and_enough_room(arg_26_0, arg_26_1)
	local var_26_0
	local var_26_1 = 0
	local var_26_2 = arg_26_0._party_manager:get_party_from_name("spectators")
	local var_26_3 = var_26_2 and var_26_2.party_id

	print("_find_party_with_least_peers_and_enough_room ------------------------------------>")

	local var_26_4 = arg_26_0._reserved_peers

	for iter_26_0 = 1, #var_26_4 do
		if iter_26_0 ~= var_26_3 then
			local var_26_5 = arg_26_0:_num_unreserved_slots(iter_26_0)
			local var_26_6 = var_26_4[iter_26_0]

			print("party_id:", iter_26_0, var_26_6, var_26_5)

			if arg_26_1 <= var_26_5 and var_26_1 < var_26_5 then
				var_26_0 = iter_26_0
				var_26_1 = var_26_5

				printf("found party! best_party: %s most_free_slots: %s, ", tostring(var_26_0), tostring(var_26_1))
			end
		end
	end

	if var_26_0 then
		print("party found!", var_26_0)

		return var_26_0
	end

	if var_26_3 and arg_26_1 <= arg_26_0:_num_unreserved_slots(var_26_3) then
		print("spectator is best party", var_26_0)

		return var_26_3
	end

	print("No party found!")

	return false
end

function VersusGameServerSlotReservationHandler._find_party_with_most_peers_and_enough_room(arg_27_0, arg_27_1)
	local var_27_0
	local var_27_1 = math.huge
	local var_27_2 = arg_27_0._party_manager:get_party_from_name("spectators")
	local var_27_3 = var_27_2 and var_27_2.party_id

	print("_find_party_with_most_peers_and_enough_room ------------------------------------>")

	local var_27_4 = arg_27_0._reserved_peers

	for iter_27_0 = 1, #var_27_4 do
		if iter_27_0 ~= var_27_3 then
			local var_27_5 = arg_27_0:_num_unreserved_slots(iter_27_0)
			local var_27_6 = var_27_4[iter_27_0]

			print("party_id:", iter_27_0, var_27_6, var_27_5)

			if arg_27_1 <= var_27_5 and var_27_5 < var_27_1 then
				var_27_0 = iter_27_0
				var_27_1 = var_27_5

				printf("found party! best_party: %s least_free_slots: %s, ", tostring(var_27_0), tostring(var_27_1))
			end
		end
	end

	if var_27_0 then
		print("party found!", var_27_0)

		return var_27_0
	end

	if var_27_3 and arg_27_1 <= arg_27_0:_num_unreserved_slots(var_27_3) then
		print("spectator is best party", var_27_0)

		return var_27_3
	end

	print("No party found!")

	return false
end

function VersusGameServerSlotReservationHandler._num_unreserved_slots(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._reserved_peers[arg_28_1]
	local var_28_1 = 0

	for iter_28_0 = 1, #var_28_0 do
		if arg_28_0:_party_slot_is_empty(var_28_0, iter_28_0) then
			var_28_1 = var_28_1 + 1
		end
	end

	return var_28_1
end

function VersusGameServerSlotReservationHandler._num_reserved_slots(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._reserved_peers[arg_29_1]
	local var_29_1 = 0

	for iter_29_0 = 1, #var_29_0 do
		if not arg_29_0:_party_slot_is_empty(var_29_0, iter_29_0) then
			var_29_1 = var_29_1 + 1
		end
	end

	return var_29_1
end

function VersusGameServerSlotReservationHandler._reserve_slots_in_party(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = arg_30_0._reserved_peers[arg_30_1]

	for iter_30_0 = 1, #arg_30_2 do
		local var_30_1 = arg_30_2[iter_30_0]
		local var_30_2 = arg_30_3 == var_30_1
		local var_30_3 = false

		for iter_30_1 = 1, #var_30_0 do
			if arg_30_0:_party_slot_is_empty(var_30_0, iter_30_1) then
				arg_30_0:_reserve_slot(var_30_0, iter_30_1, var_30_1, var_30_2)

				var_30_3 = true

				break
			end
		end

		arg_30_0:_dump_assert(var_30_3, "Failed reserving slot in party")
	end

	arg_30_0:_print_reservations()
end

function VersusGameServerSlotReservationHandler.reserved_peers_map(arg_31_0)
	return arg_31_0._reserved_peers_map
end

function VersusGameServerSlotReservationHandler._num_reserved_slots_per_party(arg_32_0)
	local var_32_0 = {}

	for iter_32_0 = 1, #arg_32_0._reserved_peers - 1 do
		local var_32_1 = arg_32_0._reserved_peers[iter_32_0]

		var_32_0[iter_32_0] = 0

		for iter_32_1 = 1, #var_32_1 do
			if var_32_1[iter_32_1].reserved then
				var_32_0[iter_32_0] = var_32_0[iter_32_0] + 1
			end
		end
	end

	return var_32_0
end

function VersusGameServerSlotReservationHandler._party_slot_is_empty(arg_33_0, arg_33_1, arg_33_2)
	return not arg_33_1[arg_33_2].reserved
end

function VersusGameServerSlotReservationHandler._reserve_slot(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = arg_34_1[arg_34_2]

	arg_34_0:_dump_assert(not var_34_0.reserved, "Trying to reserve already reserved slot")

	var_34_0.reserved = true
	var_34_0.peer_id = arg_34_3
	var_34_0.reserver = arg_34_4
	arg_34_0._reserved_peers_map[arg_34_3] = true

	Managers.state.event:trigger("game_server_reserve_party_slot", arg_34_2, arg_34_3, arg_34_4)
end

function VersusGameServerSlotReservationHandler._unreserve_party_slot(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0 = arg_35_1[arg_35_2]

	arg_35_0:_dump_assert(var_35_0.reserved, "Trying to unreserve slot that was not reserved")
	var_0_1(var_35_0)

	arg_35_0._reserved_peers_map[arg_35_3] = nil

	if not arg_35_4 then
		Managers.state.event:trigger("game_server_unreserve_party_slot", arg_35_2, arg_35_3)
	end

	arg_35_0:_print_reservations()
end

function VersusGameServerSlotReservationHandler._find_party_and_index_from_peer_id(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._reserved_peers

	for iter_36_0 = 0, #var_36_0 do
		local var_36_1 = var_36_0[iter_36_0]

		for iter_36_1 = 1, #var_36_1 do
			if var_36_1[iter_36_1].peer_id == arg_36_1 then
				return var_36_1, iter_36_1, iter_36_0
			end
		end
	end

	if not arg_36_2 then
		arg_36_0:_dump_assert(false, "Did not find peer (%s) in reserved slots.", arg_36_1)
	end
end

function VersusGameServerSlotReservationHandler.get_peer_id(arg_37_0, arg_37_1, arg_37_2)
	return arg_37_0._reserved_peers[arg_37_1][arg_37_2]
end

function VersusGameServerSlotReservationHandler._dump_assert(arg_38_0, arg_38_1, arg_38_2, ...)
	if not arg_38_1 then
		arg_38_0:dump()
		ferror(arg_38_2, ...)
	end
end

function VersusGameServerSlotReservationHandler.should_run_tutorial(arg_39_0)
	return false, nil
end

function VersusGameServerSlotReservationHandler.set_party_size(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0._reserved_peers[arg_40_1]
	local var_40_1 = #var_40_0

	if arg_40_2 < var_40_1 - arg_40_0:_num_unreserved_slots(arg_40_1) then
		return false, "New size smaller than number of players in party"
	end

	if var_40_1 == arg_40_2 then
		return true
	end

	if arg_40_2 < var_40_1 then
		for iter_40_0 = arg_40_2 + 1, var_40_1 do
			var_40_0[iter_40_0] = nil
		end
	else
		for iter_40_1 = var_40_1 + 1, arg_40_2 do
			var_40_0[iter_40_1] = table.clone(var_0_0)
		end
	end

	arg_40_0:send_slot_update_to_clients()
	arg_40_0:_print_reservations()

	return true
end

function VersusGameServerSlotReservationHandler.swap_players(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_1 or not arg_41_2 or arg_41_1 == arg_41_2 then
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

	local var_41_0 = true
	local var_41_1, var_41_2 = arg_41_0:_find_party_and_index_from_peer_id(arg_41_1, var_41_0)
	local var_41_3, var_41_4 = arg_41_0:_find_party_and_index_from_peer_id(arg_41_2, var_41_0)

	if not var_41_1 then
		return false, "Failed to find first player"
	end

	if not var_41_3 then
		return false, "Failed to find second player"
	end

	var_41_3[var_41_4], var_41_1[var_41_2] = var_41_1[var_41_2], var_41_3[var_41_4]

	arg_41_0:send_slot_update_to_clients()
	arg_41_0:_print_reservations()
	arg_41_0:_update_lobby_reservations()

	return true
end

function VersusGameServerSlotReservationHandler.move_player(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if arg_42_0:_num_unreserved_slots(arg_42_2) < 1 then
		return false
	end

	local var_42_0, var_42_1 = arg_42_0:_find_party_and_index_from_peer_id(arg_42_1, arg_42_3)

	if not var_42_0 then
		return false, "Failed to find peer"
	end

	if var_42_0.party_id == arg_42_2 then
		return true
	end

	local var_42_2 = arg_42_0:find_empty_slot_in_party(arg_42_2)

	if not var_42_2 then
		return false, "Failed to find empty slot"
	end

	arg_42_0._reserved_peers[arg_42_2][var_42_2] = var_42_0[var_42_1]
	var_42_0[var_42_1] = table.clone(var_0_0)

	arg_42_0:send_slot_update_to_clients()
	arg_42_0:_print_reservations()
	arg_42_0:_update_lobby_reservations()

	return true
end

function VersusGameServerSlotReservationHandler.find_empty_slot_in_party(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._reserved_peers[arg_43_1]

	for iter_43_0 = 1, #var_43_0 do
		if var_43_0[iter_43_0].reserved == false then
			return iter_43_0
		end
	end
end

function VersusGameServerSlotReservationHandler._update_lobby_reservations(arg_44_0)
	local var_44_0 = 0
	local var_44_1 = 0
	local var_44_2 = arg_44_0._reserved_peers

	for iter_44_0 = 0, #var_44_2 do
		local var_44_3 = var_44_2[iter_44_0]
		local var_44_4 = #var_44_3
		local var_44_5 = 0

		for iter_44_1 = 1, var_44_4 do
			if var_44_3[iter_44_1].reserved then
				var_44_5 = var_44_5 + 1
			end
		end

		for iter_44_2 = 1, var_44_5 do
			var_44_0 = bit.bor(var_44_0, bit.lshift(1, var_44_1 + (iter_44_2 - 1)))
		end

		var_44_1 = var_44_1 + var_44_4
	end

	local var_44_6 = Managers.matchmaking.lobby
	local var_44_7 = var_44_6:get_stored_lobby_data()

	var_44_7.reserved_slots_mask = var_44_0

	var_44_6:set_lobby_data(var_44_7)
end

function VersusGameServerSlotReservationHandler.try_balance_teams(arg_45_0)
	arg_45_0:_redistribute_parties_evenly()

	return arg_45_0:is_evenly_distributed()
end

function VersusGameServerSlotReservationHandler.is_evenly_distributed(arg_46_0)
	local var_46_0 = GameModeSettings.inn_vs.auto_force_start
	local var_46_1 = arg_46_0:_num_reserved_slots_per_party()
	local var_46_2 = math.abs(var_46_1[1] - var_46_1[2])
	local var_46_3, var_46_4 = table.min(var_46_1)

	return var_46_2 <= var_46_0.max_team_disparity and var_46_4 >= var_46_0.min_team_size
end

function VersusGameServerSlotReservationHandler._try_add_friend_party(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._reserved_peers
	local var_47_1 = #arg_47_1

	if not Managers.party:server_has_room_for_friend_party(var_47_0, var_47_1) then
		local var_47_2 = Managers.party:can_kick_to_fill_server(var_47_0, var_47_1)

		if not var_47_2 then
			return false
		else
			for iter_47_0 = 1, #var_47_2 do
				local var_47_3 = var_47_2[iter_47_0]

				for iter_47_1 = #var_47_3.peers, 1, -1 do
					local var_47_4 = var_47_3.peers[iter_47_1]

					arg_47_0:unreserve_slot(var_47_4)
					Managers.mechanism:network_handler():force_disconnect_client_by_peer_id(var_47_4)
					print("Force disconnected")
				end
			end
		end
	end

	arg_47_0._party_manager:server_create_friend_party(arg_47_1, arg_47_2)
	arg_47_0:_redistribute_parties_evenly()

	return true
end

function VersusGameServerSlotReservationHandler._redistribute_parties_evenly(arg_48_0)
	local var_48_0 = arg_48_0._reserved_peers
	local var_48_1 = arg_48_0._party_manager:server_get_friend_parties_sorted()

	for iter_48_0 = 0, #var_48_0 do
		local var_48_2 = var_48_0[iter_48_0]

		for iter_48_1 = 1, #var_48_2 do
			local var_48_3 = var_48_2[iter_48_1]

			if var_48_3.reserved then
				var_0_1(var_48_3)
			end
		end
	end

	for iter_48_2 = 1, #var_48_1 do
		local var_48_4 = 0
		local var_48_5
		local var_48_6 = 0

		for iter_48_3 = 1, #var_48_0 do
			local var_48_7 = var_48_0[iter_48_3]

			if var_48_7.game_participating then
				local var_48_8 = #var_48_7
				local var_48_9 = arg_48_0:_num_unreserved_slots(iter_48_3)

				if var_48_4 < var_48_9 or var_48_9 == var_48_4 and var_48_8 < var_48_6 then
					var_48_4 = var_48_9
					var_48_5 = iter_48_3
					var_48_6 = var_48_8
				end
			end
		end

		local var_48_10 = var_48_1[iter_48_2]

		arg_48_0:_reserve_slots_in_party(var_48_5, var_48_10.peers, var_48_10.leader)
	end

	arg_48_0:_print_reservations()
end

function VersusGameServerSlotReservationHandler.remote_client_disconnected(arg_49_0, arg_49_1)
	arg_49_0._pending_peer_informations[arg_49_1] = nil
end

function VersusGameServerSlotReservationHandler.get_num_unreserved_slots_per_party(arg_50_0)
	local var_50_0 = {}
	local var_50_1 = arg_50_0._reserved_peers

	for iter_50_0 = 1, #var_50_1 do
		var_50_0[iter_50_0] = arg_50_0:_num_unreserved_slots(iter_50_0)
	end

	local var_50_2 = 0

	for iter_50_1 = 1, #var_50_0 do
		var_50_2 = var_50_2 + var_50_0[iter_50_1]
	end

	return var_50_0, var_50_2
end

function VersusGameServerSlotReservationHandler._is_state_waiting_for_fully_reserved(arg_51_0)
	local var_51_0 = Managers.state.game_mode
	local var_51_1 = var_51_0 and var_51_0:game_mode()

	return (var_51_1 and var_51_1:game_mode_state()) == "dedicated_server_waiting_for_fully_reserved"
end

function VersusGameServerSlotReservationHandler.player_joined_party(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	if arg_52_5 or arg_52_3 == 0 then
		return
	end

	local var_52_0 = arg_52_0:party_id(arg_52_1)
	local var_52_1 = Managers.party:get_party(arg_52_3)

	if var_52_0 and not var_52_1.game_participating then
		local var_52_2 = true

		arg_52_0:unreserve_slot(arg_52_1, nil, var_52_2)

		return
	end

	if not var_52_0 or var_52_0 == arg_52_3 then
		return
	end

	local var_52_3 = true

	arg_52_0:move_player(arg_52_1, arg_52_3, var_52_3)
end

function VersusGameServerSlotReservationHandler.party_id_by_peer(arg_53_0, arg_53_1)
	local var_53_0, var_53_1 = Managers.party:get_party_from_player_id(arg_53_1, 1)

	if not var_53_1 or var_53_1 == 0 then
		var_53_1 = arg_53_0:party_id(arg_53_1)
	end

	return var_53_1
end

function VersusGameServerSlotReservationHandler.handle_slot_reservation_for_connecting_peer(arg_54_0, arg_54_1, arg_54_2)
	if not DEDICATED_SERVER or not script_data.flexmatch_matchmaking then
		return SlotReservationConnectStatus.SUCCEEDED
	end
end

function VersusGameServerSlotReservationHandler.poll_sync_lobby_data_required(arg_55_0)
	return false
end
