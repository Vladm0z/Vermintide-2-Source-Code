-- chunkname: @scripts/network/network_transmit.lua

local var_0_0 = RPC
local var_0_1 = {}

function call_RPC(arg_1_0, arg_1_1, ...)
	local var_1_0 = PEER_ID_TO_CHANNEL[arg_1_1]

	var_0_0[arg_1_0](var_1_0, ...)
end

local var_0_2 = table.mirror_array(GameSettingsDevelopment.ignored_rpc_logs)

local function var_0_3(arg_2_0, ...)
	if var_0_2[arg_2_0] == nil then
		print("[LOCAL RPC] ", arg_2_0, ...)
	end
end

NetworkTransmit = class(NetworkTransmit)

function NetworkTransmit.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.is_server = arg_3_1
	arg_3_0.peer_id = Network.peer_id()
	arg_3_0.server_peer_id = arg_3_2
	arg_3_0.local_rpc_queue = {
		{},
		{}
	}
	arg_3_0.local_rpc_queue_n = {
		0,
		0
	}
	arg_3_0.local_rpc_queue_contains_boxed = {
		{},
		{}
	}
	arg_3_0.local_rpc_buffer_index = 1
	arg_3_0.peer_ignore_list = {}
	arg_3_0.game_session = nil
end

function NetworkTransmit.update_receive(arg_4_0)
	arg_4_0._pack_temp_types = false
end

function NetworkTransmit.set_game_session(arg_5_0, arg_5_1)
	arg_5_0.game_session = arg_5_1
end

function NetworkTransmit.add_peer_ignore(arg_6_0, arg_6_1)
	arg_6_0.peer_ignore_list[arg_6_1] = true
end

function NetworkTransmit.remove_peer_ignore(arg_7_0, arg_7_1)
	arg_7_0.peer_ignore_list[arg_7_1] = nil
end

function NetworkTransmit.destroy(arg_8_0)
	GarbageLeakDetector.register_object(arg_8_0, "NetworkTransmit")
end

function NetworkTransmit.pack_temp_types(arg_9_0, arg_9_1, ...)
	local var_9_0 = {
		...
	}
	local var_9_1 = false

	for iter_9_0 = 1, arg_9_1 or #var_9_0 do
		local var_9_2 = var_9_0[iter_9_0]
		local var_9_3 = Script.type_name(var_9_2)

		if var_9_3 == "Vector3" then
			var_9_0[iter_9_0] = Vector3Box(var_9_2)
			var_9_1 = true
		elseif var_9_3 == "Vector4" then
			var_9_0[iter_9_0] = QuaternionBox(var_9_2)
			var_9_1 = true
		end
	end

	return var_9_0, var_9_1
end

function NetworkTransmit.unpack_temp_types(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_2 or 0

	for iter_10_0 = 1, arg_10_3 or #arg_10_1 do
		local var_10_1 = var_10_0 + iter_10_0
		local var_10_2 = arg_10_1[var_10_1]
		local var_10_3 = Script.type_name(var_10_2)

		if var_10_3 == "Vector3Box" or var_10_3 == "QuaternionBox" then
			arg_10_1[var_10_1] = var_10_2:unbox()
		end
	end
end

function NetworkTransmit.queue_local_rpc(arg_11_0, arg_11_1, ...)
	local var_11_0 = arg_11_0.local_rpc_buffer_index
	local var_11_1 = arg_11_0.local_rpc_queue[var_11_0]
	local var_11_2 = arg_11_0.local_rpc_queue_n[var_11_0]
	local var_11_3 = arg_11_0.local_rpc_queue_contains_boxed[var_11_0]
	local var_11_4 = select("#", ...)

	fassert(pack_index[var_11_4 + 2], "Could not pack local rpc %q due to too many varargs. Only 20 is currently supported.", arg_11_1)

	if arg_11_0._pack_temp_types then
		local var_11_5, var_11_6 = arg_11_0:pack_temp_types(var_11_4, ...)

		pack_index[var_11_4 + 2](var_11_1, var_11_2, arg_11_1, var_11_4, unpack(var_11_5, 1, var_11_4))

		var_11_3[#var_11_3 + 1] = var_11_6
	else
		pack_index[var_11_4 + 2](var_11_1, var_11_2, arg_11_1, var_11_4, ...)

		var_11_3[#var_11_3 + 1] = false
	end

	arg_11_0.local_rpc_queue_n[var_11_0] = var_11_2 + var_11_4 + 2
end

function NetworkTransmit.transmit_local_rpcs(arg_12_0)
	arg_12_0._pack_temp_types = true

	local var_12_0 = arg_12_0.local_rpc_buffer_index
	local var_12_1 = arg_12_0.local_rpc_queue_contains_boxed[var_12_0]
	local var_12_2 = arg_12_0.local_rpc_queue_n[var_12_0]
	local var_12_3 = arg_12_0.local_rpc_queue[var_12_0]

	arg_12_0.local_rpc_buffer_index = 3 - var_12_0

	local var_12_4 = arg_12_0.network_event_delegate.event_table
	local var_12_5 = 0
	local var_12_6 = Development.parameter("network_log_messages")
	local var_12_7 = 0
	local var_12_8 = 0

	while var_12_7 < var_12_2 do
		var_12_8 = var_12_8 + 1

		local var_12_9 = var_12_3[var_12_7]
		local var_12_10 = var_12_3[var_12_7 + 1]

		if var_12_6 then
			var_0_3(var_12_9, unpack_index[var_12_10](var_12_3, var_12_7 + 2))
		end

		if var_12_1[var_12_8] then
			arg_12_0:unpack_temp_types(var_12_3, var_12_7 + 1, var_12_10)
		end

		var_12_4[var_12_9](nil, var_12_5, unpack_index[var_12_10](var_12_3, var_12_7 + 2))

		var_12_7 = var_12_7 + var_12_10 + 2
	end

	fassert(var_12_7 == var_12_2, "Couldn't process all local rpcs!")

	arg_12_0.local_rpc_queue_n[var_12_0] = 0

	table.clear(var_12_1)
end

function NetworkTransmit.set_network_event_delegate(arg_13_0, arg_13_1)
	arg_13_0.network_event_delegate = arg_13_1
end

function NetworkTransmit.send_rpc(arg_14_0, arg_14_1, arg_14_2, ...)
	local var_14_0 = var_0_0[arg_14_1]

	fassert(var_14_0, "[NetworkTransmit:send_rpc()] rpc does not exist %q", arg_14_1)

	if arg_14_2 == arg_14_0.peer_id then
		arg_14_0:queue_local_rpc(arg_14_1, ...)
	else
		local var_14_1 = PEER_ID_TO_CHANNEL[arg_14_2]

		var_14_0(var_14_1, ...)
	end

	local var_14_2 = arg_14_0.peer_id
end

function NetworkTransmit.send_rpc_server(arg_15_0, arg_15_1, ...)
	local var_15_0 = var_0_0[arg_15_1]

	fassert(var_15_0, "[NetworkTransmit:send_rpc_server()] rpc does not exist %q", arg_15_1)

	if arg_15_0.is_server then
		arg_15_0:queue_local_rpc(arg_15_1, ...)
	else
		fassert(arg_15_0.server_peer_id, "We don't have any server connection when trying to send RPC %q", arg_15_1)

		local var_15_1 = PEER_ID_TO_CHANNEL[arg_15_0.server_peer_id]

		var_15_0(var_15_1, ...)
	end
end

function NetworkTransmit.send_rpc_dedicated_server(arg_16_0, arg_16_1, ...)
	local var_16_0 = var_0_0[arg_16_1]

	fassert(var_16_0, "[NetworkTransmit:send_rpc_server()] rpc does not exist %q", arg_16_1)

	local var_16_1 = Managers.mechanism:dedicated_server_peer_id()

	fassert(var_16_1, "Failed to get peer id for dedicated server")

	if arg_16_0.peer_id == var_16_1 then
		arg_16_0:queue_local_rpc(arg_16_1, ...)
	else
		local var_16_2 = PEER_ID_TO_CHANNEL[var_16_1]

		fassert(var_16_2, "Failed to find channel_id for dedicated server")
		var_16_0(var_16_2, ...)
	end
end

function NetworkTransmit.send_rpc_party_clients(arg_17_0, arg_17_1, arg_17_2, arg_17_3, ...)
	fassert(arg_17_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_17_1)

	local var_17_0 = var_0_0[arg_17_1]

	fassert(var_17_0, "[NetworkTransmit:send_rpc_clients()] rpc does not exist: %q", arg_17_1)

	local var_17_1 = arg_17_0.game_session

	if not var_17_1 then
		return
	end

	local var_17_2 = arg_17_2.occupied_slots
	local var_17_3 = var_0_1

	table.clear(var_17_3)

	for iter_17_0, iter_17_1 in ipairs(var_17_2) do
		if iter_17_1.is_player then
			var_17_3[iter_17_1.peer_id] = true
		end
	end

	if arg_17_3 then
		local var_17_4 = Managers.party:get_party_from_name("spectators")

		if var_17_4 then
			local var_17_5 = var_17_4.occupied_slots

			for iter_17_2, iter_17_3 in ipairs(var_17_5) do
				if iter_17_3.is_player then
					var_17_3[iter_17_3.peer_id] = true
				end
			end
		end
	end

	local var_17_6 = arg_17_0.peer_ignore_list

	for iter_17_4, iter_17_5 in ipairs(GameSession.other_peers(var_17_1)) do
		if not var_17_6[iter_17_5] and var_17_3[iter_17_5] then
			local var_17_7 = PEER_ID_TO_CHANNEL[iter_17_5]

			var_17_0(var_17_7, ...)
		end
	end
end

function NetworkTransmit.send_rpc_party(arg_18_0, arg_18_1, arg_18_2, arg_18_3, ...)
	fassert(arg_18_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_18_1)

	local var_18_0 = var_0_0[arg_18_1]

	fassert(var_18_0, "[NetworkTransmit:send_rpc_party()] rpc does not exist: %q", arg_18_1)

	local var_18_1 = arg_18_0.game_session

	if not var_18_1 then
		return
	end

	local var_18_2 = arg_18_2.occupied_slots
	local var_18_3 = var_0_1

	table.clear(var_18_3)

	for iter_18_0, iter_18_1 in ipairs(var_18_2) do
		if iter_18_1.is_player then
			var_18_3[iter_18_1.peer_id] = true
		end
	end

	if arg_18_3 then
		local var_18_4 = Managers.party:get_party_from_name("spectators")

		if var_18_4 then
			local var_18_5 = var_18_4.occupied_slots

			for iter_18_2, iter_18_3 in ipairs(var_18_5) do
				if iter_18_3.is_player then
					var_18_3[iter_18_3.peer_id] = true
				end
			end
		end
	end

	if var_18_3[arg_18_0.peer_id] then
		arg_18_0:queue_local_rpc(arg_18_1, ...)

		var_18_3[arg_18_0.peer_id] = nil
	end

	local var_18_6 = arg_18_0.peer_ignore_list

	for iter_18_4, iter_18_5 in ipairs(GameSession.other_peers(var_18_1)) do
		if not var_18_6[iter_18_5] and var_18_3[iter_18_5] then
			local var_18_7 = PEER_ID_TO_CHANNEL[iter_18_5]

			var_18_0(var_18_7, ...)
		end
	end
end

local function var_0_4(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = var_0_1

	table.clear(var_19_0)

	local var_19_1 = arg_19_0.PLAYER_UNITS

	for iter_19_0, iter_19_1 in ipairs(var_19_1) do
		var_19_0[Managers.player:owner(iter_19_1):network_id()] = true
	end

	if arg_19_1 then
		local var_19_2 = arg_19_0:get_allied_sides()

		for iter_19_2 = 1, #var_19_2 do
			local var_19_3 = var_19_2[iter_19_2].PLAYER_UNITS

			for iter_19_3, iter_19_4 in ipairs(var_19_3) do
				var_19_0[Managers.player:owner(iter_19_4):network_id()] = true
			end
		end
	end

	if arg_19_2 and Managers.state.side:get_side_from_name("spectators") then
		local var_19_4 = arg_19_0.PLAYER_UNITS

		for iter_19_5, iter_19_6 in ipairs(var_19_4) do
			var_19_0[Managers.player:owner(iter_19_6):network_id()] = true
		end
	end

	return var_19_0
end

function NetworkTransmit.send_rpc_side(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, ...)
	fassert(arg_20_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_20_1)

	local var_20_0 = var_0_0[arg_20_1]

	fassert(var_20_0, "[NetworkTransmit:send_rpc_side()] rpc does not exist: %q", arg_20_1)

	local var_20_1 = arg_20_0.game_session

	if not var_20_1 then
		return
	end

	local var_20_2 = var_0_4(arg_20_2, arg_20_3, arg_20_4)

	if var_20_2[arg_20_0.peer_id] or arg_20_5 then
		arg_20_0:queue_local_rpc(arg_20_1, ...)

		var_20_2[arg_20_0.peer_id] = nil
	end

	local var_20_3 = arg_20_0.peer_ignore_list

	for iter_20_0, iter_20_1 in ipairs(GameSession.other_peers(var_20_1)) do
		if not var_20_3[iter_20_1] and var_20_2[iter_20_1] then
			local var_20_4 = PEER_ID_TO_CHANNEL[iter_20_1]

			var_20_0(var_20_4, ...)
		end
	end
end

function NetworkTransmit.send_rpc_side_clients(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, ...)
	fassert(arg_21_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_21_1)

	local var_21_0 = var_0_0[arg_21_1]

	fassert(var_21_0, "[NetworkTransmit:send_rpc_side_clients()] rpc does not exist: %q", arg_21_1)

	local var_21_1 = arg_21_0.game_session

	if not var_21_1 then
		return
	end

	local var_21_2 = var_0_4(arg_21_2, arg_21_3, arg_21_4)

	var_21_2[arg_21_0.peer_id] = nil

	local var_21_3 = arg_21_0.peer_ignore_list

	for iter_21_0, iter_21_1 in ipairs(GameSession.other_peers(var_21_1)) do
		if not var_21_3[iter_21_1] and var_21_2[iter_21_1] then
			local var_21_4 = PEER_ID_TO_CHANNEL[iter_21_1]

			var_21_0(var_21_4, ...)
		end
	end
end

function NetworkTransmit.send_rpc_clients(arg_22_0, arg_22_1, ...)
	fassert(arg_22_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_22_1)

	local var_22_0 = var_0_0[arg_22_1]

	fassert(var_22_0, "[NetworkTransmit:send_rpc_clients()] rpc does not exist: %q", arg_22_1)

	local var_22_1 = arg_22_0.game_session

	if not var_22_1 then
		return
	end

	local var_22_2 = arg_22_0.peer_ignore_list

	for iter_22_0, iter_22_1 in ipairs(GameSession.other_peers(var_22_1)) do
		if not var_22_2[iter_22_1] then
			local var_22_3 = PEER_ID_TO_CHANNEL[iter_22_1]

			var_22_0(var_22_3, ...)
		end
	end
end

function NetworkTransmit.send_rpc_clients_except(arg_23_0, arg_23_1, arg_23_2, ...)
	fassert(arg_23_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_23_1)

	local var_23_0 = var_0_0[arg_23_1]

	fassert(var_23_0, "[NetworkTransmit:send_rpc_clients_except()] rpc does not exist: %q", arg_23_1)

	local var_23_1 = arg_23_0.game_session

	if not var_23_1 then
		return
	end

	local var_23_2 = arg_23_0.peer_ignore_list

	for iter_23_0, iter_23_1 in ipairs(GameSession.other_peers(var_23_1)) do
		if iter_23_1 ~= arg_23_2 and not var_23_2[iter_23_1] then
			local var_23_3 = PEER_ID_TO_CHANNEL[iter_23_1]

			var_23_0(var_23_3, ...)
		end
	end
end

function NetworkTransmit.send_rpc_side_clients_except(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, ...)
	fassert(arg_24_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_24_1)

	local var_24_0 = var_0_0[arg_24_1]

	fassert(var_24_0, "[NetworkTransmit:send_rpc_side_clients_except()] rpc does not exist: %q", arg_24_1)

	local var_24_1 = arg_24_0.game_session

	if not var_24_1 then
		return
	end

	local var_24_2 = var_0_4(arg_24_2, arg_24_3, arg_24_4)

	var_24_2[arg_24_0.peer_id] = nil
	var_24_2[arg_24_5] = nil

	local var_24_3 = arg_24_0.peer_ignore_list

	for iter_24_0, iter_24_1 in ipairs(GameSession.other_peers(var_24_1)) do
		if not var_24_3[iter_24_1] and var_24_2[iter_24_1] then
			local var_24_4 = PEER_ID_TO_CHANNEL[iter_24_1]

			var_24_0(var_24_4, ...)
		end
	end
end

function NetworkTransmit.send_rpc_all(arg_25_0, arg_25_1, ...)
	fassert(arg_25_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_25_1)

	local var_25_0 = var_0_0[arg_25_1]

	fassert(var_25_0, "[NetworkTransmit:send_rpc_all()] rpc does not exist: %q", arg_25_1)
	arg_25_0:queue_local_rpc(arg_25_1, ...)

	local var_25_1 = arg_25_0.game_session

	if not var_25_1 then
		return
	end

	local var_25_2 = arg_25_0.peer_ignore_list

	for iter_25_0, iter_25_1 in ipairs(GameSession.other_peers(var_25_1)) do
		if not var_25_2[iter_25_1] then
			local var_25_3 = PEER_ID_TO_CHANNEL[iter_25_1]

			var_25_0(var_25_3, ...)
		end
	end
end

function NetworkTransmit.send_rpc_all_except(arg_26_0, arg_26_1, arg_26_2, ...)
	fassert(arg_26_0.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_26_1)

	local var_26_0 = var_0_0[arg_26_1]

	fassert(var_26_0, "[NetworkTransmit:send_rpc_all_except()] rpc does not exist: %q", arg_26_1)

	if arg_26_2 ~= arg_26_0.peer_id then
		arg_26_0:queue_local_rpc(arg_26_1, ...)
	end

	local var_26_1 = arg_26_0.game_session

	if not var_26_1 then
		return
	end

	local var_26_2 = arg_26_0.peer_ignore_list

	for iter_26_0, iter_26_1 in ipairs(GameSession.other_peers(var_26_1)) do
		if iter_26_1 ~= arg_26_2 and not var_26_2[iter_26_1] then
			local var_26_3 = PEER_ID_TO_CHANNEL[iter_26_1]

			var_26_0(var_26_3, ...)
		end
	end
end
