-- chunkname: @scripts/network/network_match_handler.lua

NetworkMatchHandler = class(NetworkMatchHandler)

local var_0_0 = {
	leader_peer_id = "",
	player_name = "",
	is_dedicated_server = false,
	is_synced = false,
	versus_level = 1,
	is_match_owner = false
}
local var_0_1 = {
	"rpc_network_match_sync_player_data",
	"rpc_network_match_changed",
	"rpc_network_match_request_sync"
}
local var_0_2 = true

function NetworkMatchHandler.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._network_handler = arg_1_1
	arg_1_0._is_server = arg_1_2
	arg_1_0._my_peer_id = arg_1_3
	arg_1_0._server_peer_id = arg_1_4
	arg_1_0._stored_data = {}
	arg_1_0._lobby = arg_1_5
	arg_1_0._data_by_peer = {
		[arg_1_3] = arg_1_0:_create_data({
			is_synced = true,
			is_dedicated_server = DEDICATED_SERVER,
			player_name = not DEDICATED_SERVER and PlayerUtils.player_name(arg_1_3, arg_1_5) or nil,
			leader_peer_id = arg_1_0._server_peer_id,
			is_match_owner = arg_1_2 and true,
			versus_level = not DEDICATED_SERVER and ExperienceSettings.get_versus_level() or nil
		})
	}

	if not arg_1_2 then
		arg_1_0._data_by_peer[arg_1_4] = arg_1_0:_create_data({
			is_match_owner = true,
			leader_peer_id = arg_1_4
		})
		arg_1_0._pending_initial_sync = true

		arg_1_0:_request_sync()
	end
end

function NetworkMatchHandler.server_created(arg_2_0, arg_2_1)
	Managers.persistent_event:trigger("new_network_match_synced", arg_2_0._is_server, arg_2_1)
end

function NetworkMatchHandler.register_pending_peer(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = PEER_ID_TO_CHANNEL[arg_3_1]

	arg_3_0._data_by_peer[arg_3_1] = arg_3_0:_try_unstore_data(arg_3_1) or arg_3_0:_create_data()
	arg_3_0._data_by_peer[arg_3_1].leader_peer_id = arg_3_2

	printf("[NetworkMatchHandler] Registering pending peer %s with leader %s", arg_3_1, arg_3_2)
	arg_3_0:sync_data_down_to(arg_3_1)

	if arg_3_2 == arg_3_0._my_peer_id then
		RPC.rpc_network_match_request_sync(var_3_0)
	elseif PEER_ID_TO_CHANNEL[arg_3_2] then
		local var_3_1 = PEER_ID_TO_CHANNEL[arg_3_2]

		RPC.rpc_network_match_request_sync(var_3_1)
	else
		printf("[NetworkMatchHandler] Failed to sync client %s because of no longer holding a connection to their leader %s", arg_3_1, arg_3_2)
	end
end

function NetworkMatchHandler.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._network_event_delegate = arg_4_1
	arg_4_0._network_transmit = arg_4_2

	arg_4_1:register(arg_4_0, unpack(var_0_1))
end

function NetworkMatchHandler.unregister_rpcs(arg_5_0)
	arg_5_0._network_event_delegate:unregister(arg_5_0)
end

function NetworkMatchHandler.poll_propagation_peer(arg_6_0)
	assert(arg_6_0._is_server, "[NetworkMatchHandler] Only lobby hosts may propagate to another lobby host")

	local var_6_0
	local var_6_1 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if var_6_1 then
		var_6_0 = var_6_1:lobby_host()
	end

	local var_6_2 = arg_6_0._join_lobby_peer_id
	local var_6_3 = var_6_0 ~= var_6_2

	if var_6_0 == nil and PEER_ID_TO_CHANNEL[var_6_2] then
		var_6_3 = false
	end

	if var_6_3 then
		printf("[NetworkMatchHandler] Join lobby peer changed. Old: %s, New: %s", var_6_2, var_6_0)

		arg_6_0._join_lobby_peer_id = var_6_0

		if var_6_2 then
			arg_6_0:_clear_non_session_peers()
		end

		arg_6_0:_network_match_changed(var_6_0)

		if var_6_0 then
			arg_6_0:sync_data_up()
			arg_6_0:_request_sync()
		elseif var_6_2 == arg_6_0._propagate_peer_id then
			arg_6_0._propagate_peer_id = nil
		end
	end
end

function NetworkMatchHandler.rpc_network_match_sync_player_data(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]
	local var_7_1 = arg_7_0:_try_unstore_data(arg_7_2) or arg_7_0:_create_data()

	arg_7_0._data_by_peer[arg_7_2] = var_7_1
	var_7_1.player_name = arg_7_3
	var_7_1.leader_peer_id = arg_7_4
	var_7_1.versus_level = arg_7_6
	var_7_1.is_match_owner = arg_7_5
	var_7_1.is_synced = true

	if arg_7_2 == arg_7_0._join_lobby_peer_id then
		if arg_7_5 then
			arg_7_0._propagate_peer_id = arg_7_2
		else
			arg_7_0._data_by_peer[arg_7_0._my_peer_id].leader_peer_id = arg_7_2
		end
	end

	if var_0_2 then
		printf("[NetworkMatchHandler] Sync data received from peer %s for peer %s (%s). has_leader=%s, is_match_owner=%s", var_7_0, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	end

	local var_7_2 = CHANNEL_TO_PEER_ID[arg_7_1]

	arg_7_0:propagate_rpc("rpc_network_match_sync_player_data", var_7_2, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)

	if arg_7_0._pending_initial_sync then
		arg_7_0._pending_initial_sync = false

		Managers.persistent_event:trigger("new_network_match_synced", arg_7_0._is_server, arg_7_0._my_peer_id)
	end
end

function NetworkMatchHandler.rpc_network_match_changed(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_clear_non_session_peers()
	arg_8_0:_network_match_changed(arg_8_2)
	arg_8_0:send_rpc_down("rpc_network_match_changed", arg_8_2)
end

function NetworkMatchHandler._network_match_changed(arg_9_0, arg_9_1)
	printf("[NetworkMatchHandler] Network match changed. New match owner: %s", arg_9_1)

	for iter_9_0, iter_9_1 in pairs(arg_9_0._data_by_peer) do
		iter_9_1.is_match_owner = false
	end

	if arg_9_1 then
		arg_9_0._data_by_peer[arg_9_1] = arg_9_0:_create_data({
			is_match_owner = true,
			leader_peer_id = arg_9_1
		})

		arg_9_0:_request_sync()
	elseif arg_9_0._is_server then
		arg_9_0._data_by_peer[arg_9_0._my_peer_id].is_match_owner = true
	else
		arg_9_0._data_by_peer[arg_9_0._server_peer_id].is_match_owner = true
	end

	if arg_9_0._is_server then
		arg_9_0:send_rpc_down("rpc_network_match_changed", arg_9_1 or arg_9_0._my_peer_id)
	end

	Managers.persistent_event:trigger("network_match_changed", arg_9_1)
end

function NetworkMatchHandler.rpc_network_match_request_sync(arg_10_0, arg_10_1)
	local var_10_0 = CHANNEL_TO_PEER_ID[arg_10_1]

	printf("[NetworkMatchHandler] Peer %s requested sync", var_10_0)

	if var_0_2 then
		printf("[NetworkMatchHandler] Own data:\n%s", table.tostring(arg_10_0._data_by_peer))
	end

	local var_10_1 = arg_10_0._data_by_peer[var_10_0]

	if not var_10_1 then
		return
	end

	if var_10_1.is_match_owner then
		arg_10_0:sync_data_up()

		return
	end

	local var_10_2 = arg_10_0._my_peer_id
	local var_10_3 = arg_10_0._data_by_peer[var_10_2]

	if var_10_3.is_match_owner then
		arg_10_0:sync_data_down_to(var_10_0)

		return
	elseif var_10_3.leader_peer_id == var_10_0 then
		arg_10_0:sync_data_up()

		return
	elseif var_10_1.leader_peer_id == var_10_2 then
		arg_10_0:sync_data_down_to(var_10_0)
	else
		arg_10_0:sync_data_to(var_10_0)
	end
end

function NetworkMatchHandler._request_sync(arg_11_0)
	printf("[NetworkMatchHandler] Requesting sync.")
	arg_11_0:send_rpc_up("rpc_network_match_request_sync")
end

function NetworkMatchHandler.get_match_owner(arg_12_0)
	for iter_12_0, iter_12_1 in pairs(arg_12_0._data_by_peer) do
		if iter_12_1.is_match_owner then
			return iter_12_0
		end
	end
end

function NetworkMatchHandler.is_match_owner(arg_13_0)
	return arg_13_0:get_match_owner() == arg_13_0._my_peer_id
end

function NetworkMatchHandler.is_leader(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1 or arg_14_0._my_peer_id

	return arg_14_0:query_peer_data(var_14_0, "leader_peer_id") == var_14_0
end

function NetworkMatchHandler.synced_peers(arg_15_0)
	return table.keys_if(arg_15_0._data_by_peer, function(arg_16_0, arg_16_1)
		return arg_16_1.is_synced
	end)
end

function NetworkMatchHandler.sync_data_up(arg_17_0)
	local var_17_0 = arg_17_0._my_peer_id

	for iter_17_0, iter_17_1 in pairs(arg_17_0._data_by_peer) do
		if iter_17_1.leader_peer_id == var_17_0 or iter_17_0 == var_17_0 then
			local var_17_1 = iter_17_1.player_name
			local var_17_2 = iter_17_1.leader_peer_id
			local var_17_3 = iter_17_1.is_match_owner

			arg_17_0:send_rpc_up("rpc_network_match_sync_player_data", iter_17_0, var_17_1, var_17_2, var_17_3, iter_17_1.versus_level)
		end
	end
end

function NetworkMatchHandler.sync_data_down(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0._data_by_peer) do
		local var_18_0 = iter_18_1.player_name
		local var_18_1 = iter_18_1.leader_peer_id
		local var_18_2 = iter_18_1.is_match_owner

		arg_18_0:send_rpc_down_except("rpc_network_match_sync_player_data", iter_18_0, iter_18_0, var_18_0, var_18_1, var_18_2, iter_18_1.versus_level)
	end
end

function NetworkMatchHandler.sync_data_down_to(arg_19_0, arg_19_1)
	local var_19_0 = PEER_ID_TO_CHANNEL[arg_19_1]

	if not var_19_0 then
		return
	end

	for iter_19_0, iter_19_1 in pairs(arg_19_0._data_by_peer) do
		if iter_19_0 ~= arg_19_1 then
			local var_19_1 = iter_19_1.player_name
			local var_19_2 = iter_19_1.leader_peer_id
			local var_19_3 = iter_19_1.is_match_owner

			RPC.rpc_network_match_sync_player_data(var_19_0, iter_19_0, var_19_1, var_19_2, var_19_3, iter_19_1.versus_level)
		end
	end
end

function NetworkMatchHandler.sync_data_to(arg_20_0, arg_20_1)
	local var_20_0 = PEER_ID_TO_CHANNEL[arg_20_1]
	local var_20_1 = arg_20_0._data_by_peer[arg_20_0._my_peer_id]

	RPC.rpc_network_match_sync_player_data(var_20_0, arg_20_0._my_peer_id, var_20_1.player_name, var_20_1.leader_peer_id, var_20_1.is_match_owner, var_20_1.versus_level)
end

function NetworkMatchHandler.send_rpc_up(arg_21_0, arg_21_1, ...)
	if arg_21_0._server_peer_id ~= arg_21_0._my_peer_id then
		local var_21_0 = PEER_ID_TO_CHANNEL[arg_21_0._server_peer_id]

		if var_21_0 then
			RPC[arg_21_1](var_21_0, ...)
		end
	elseif arg_21_0._propagate_peer_id then
		local var_21_1 = PEER_ID_TO_CHANNEL[arg_21_0._propagate_peer_id]

		if var_21_1 then
			RPC[arg_21_1](var_21_1, ...)
		end
	end
end

function NetworkMatchHandler.can_propagate(arg_22_0)
	return arg_22_0._propagate_peer_id
end

function NetworkMatchHandler.send_rpc_others(arg_23_0, arg_23_1, ...)
	arg_23_0:send_rpc_up(arg_23_1, ...)
	arg_23_0:send_rpc_down(arg_23_1, ...)
end

function NetworkMatchHandler.send_rpc(arg_24_0, arg_24_1, arg_24_2, ...)
	local var_24_0 = PEER_ID_TO_CHANNEL[arg_24_2]

	RPC[arg_24_1](var_24_0, ...)
end

function NetworkMatchHandler.send_rpc_down(arg_25_0, arg_25_1, ...)
	arg_25_0:send_rpc_down_except(arg_25_1, nil, ...)
end

function NetworkMatchHandler.send_rpc_down_except(arg_26_0, arg_26_1, arg_26_2, ...)
	local var_26_0 = arg_26_0._my_peer_id
	local var_26_1 = arg_26_0._data_by_peer[var_26_0].is_match_owner

	for iter_26_0, iter_26_1 in pairs(arg_26_0._data_by_peer) do
		if iter_26_0 ~= arg_26_2 and iter_26_0 ~= var_26_0 and (iter_26_1.leader_peer_id == var_26_0 or iter_26_1.leader_peer_id == iter_26_0 and var_26_1) then
			local var_26_2 = PEER_ID_TO_CHANNEL[iter_26_0]

			if var_26_2 then
				RPC[arg_26_1](var_26_2, ...)
			end
		end
	end
end

function NetworkMatchHandler.send_rpc_down_except_if(arg_27_0, arg_27_1, arg_27_2, arg_27_3, ...)
	local var_27_0 = arg_27_0._my_peer_id
	local var_27_1 = arg_27_0._data_by_peer[var_27_0].is_match_owner

	for iter_27_0, iter_27_1 in pairs(arg_27_0._data_by_peer) do
		if iter_27_0 ~= arg_27_2 and arg_27_3(iter_27_0) and iter_27_0 ~= var_27_0 and (iter_27_1.leader_peer_id == var_27_0 or iter_27_1.leader_peer_id == iter_27_0 and var_27_1) then
			local var_27_2 = PEER_ID_TO_CHANNEL[iter_27_0]

			if var_27_2 then
				RPC[arg_27_1](var_27_2, ...)
			end
		end
	end
end

function NetworkMatchHandler.send_rpc_down_if(arg_28_0, arg_28_1, arg_28_2, ...)
	local var_28_0 = arg_28_0._my_peer_id
	local var_28_1 = arg_28_0._data_by_peer[var_28_0].is_match_owner

	for iter_28_0, iter_28_1 in pairs(arg_28_0._data_by_peer) do
		if arg_28_2(iter_28_0) and iter_28_0 ~= var_28_0 and (iter_28_1.leader_peer_id == var_28_0 or iter_28_1.leader_peer_id == iter_28_0 and var_28_1) then
			local var_28_2 = PEER_ID_TO_CHANNEL[iter_28_0]

			if var_28_2 then
				RPC[arg_28_1](var_28_2, ...)
			end
		end
	end
end

function NetworkMatchHandler.propagate_rpc(arg_29_0, arg_29_1, arg_29_2, ...)
	if arg_29_0._propagate_peer_id then
		if arg_29_0._propagate_peer_id == arg_29_2 then
			arg_29_0:send_rpc_down(arg_29_1, ...)

			return
		end

		arg_29_0:send_rpc_up(arg_29_1, ...)
	end

	if arg_29_0._is_server then
		arg_29_0:send_rpc_down_except(arg_29_1, arg_29_2, ...)
	end
end

function NetworkMatchHandler.propagate_rpc_if(arg_30_0, arg_30_1, arg_30_2, arg_30_3, ...)
	if arg_30_0._propagate_peer_id then
		if arg_30_0._propagate_peer_id == arg_30_2 then
			arg_30_0:send_rpc_down_if(arg_30_1, arg_30_3, ...)

			return
		end

		arg_30_0:send_rpc_up(arg_30_1, ...)
	end

	if arg_30_0._is_server then
		arg_30_0:send_rpc_down_except_if(arg_30_1, arg_30_2, arg_30_3, ...)
	end
end

function NetworkMatchHandler._clear_non_session_peers(arg_31_0)
	local var_31_0 = arg_31_0._lobby:members():members_map()

	for iter_31_0 in pairs(arg_31_0._data_by_peer) do
		if not var_31_0[iter_31_0] then
			arg_31_0._data_by_peer[iter_31_0] = nil
		end
	end
end

function NetworkMatchHandler.client_disconnected(arg_32_0, arg_32_1)
	if arg_32_0._data_by_peer[arg_32_1] then
		arg_32_0:_store_data(arg_32_1)
	end
end

function NetworkMatchHandler.has_peer_data(arg_33_0, arg_33_1)
	return arg_33_0._data_by_peer[arg_33_1]
end

function NetworkMatchHandler.query_peer_data(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = arg_34_0._data_by_peer[arg_34_1]

	if var_34_0 then
		return var_34_0[arg_34_2]
	end

	return not arg_34_3 and arg_34_0:default_data(arg_34_2) or nil
end

function NetworkMatchHandler.default_data(arg_35_0, arg_35_1)
	return var_0_0[arg_35_1]
end

function NetworkMatchHandler._try_unstore_data(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._stored_data[arg_36_1]

	arg_36_0._stored_data[arg_36_1] = nil

	return var_36_0 or arg_36_0._data_by_peer[arg_36_1]
end

function NetworkMatchHandler._store_data(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._data_by_peer[arg_37_1]

	var_37_0.is_synced = var_0_0.is_synced
	var_37_0.is_match_owner = var_0_0.is_match_owner
	var_37_0.leader_peer_id = var_0_0.leader_peer_id
	arg_37_0._stored_data[arg_37_1] = var_37_0
	arg_37_0._data_by_peer[arg_37_1] = nil
end

function NetworkMatchHandler._create_data(arg_38_0, arg_38_1)
	local var_38_0 = table.shallow_copy(var_0_0)

	if arg_38_1 then
		table.merge(var_38_0, arg_38_1)
	end

	return var_38_0
end

function NetworkMatchHandler.destroy(arg_39_0)
	Managers.persistent_event:trigger("network_match_terminated")
end
