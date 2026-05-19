-- chunkname: @scripts/managers/deed/deed_manager.lua

DeedManager = class(DeedManager)

local var_0_0 = {
	"rpc_select_deed",
	"rpc_reset_deed",
	"rpc_deed_consumed"
}

function DeedManager.init(arg_1_0)
	arg_1_0._selected_deed_data = nil
	arg_1_0._selected_deed_id = nil
	arg_1_0._owner_peer_id = nil
end

function DeedManager.destroy(arg_2_0)
	if arg_2_0._network_event_delegate then
		arg_2_0._network_event_delegate:unregister(arg_2_0)

		arg_2_0._network_event_delegate = nil
	end
end

function DeedManager.network_context_created(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0._lobby = arg_3_1
	arg_3_0._server_peer_id = arg_3_2
	arg_3_0._peer_id = arg_3_3
	arg_3_0._network_server = arg_3_4 and arg_3_5 or nil
	arg_3_0._is_server = arg_3_4

	local var_3_0 = true

	arg_3_0:reset(var_3_0)
end

function DeedManager.network_context_destroyed(arg_4_0)
	arg_4_0._lobby = nil
	arg_4_0._server_peer_id = nil
	arg_4_0._peer_id = nil
	arg_4_0._network_server = nil
	arg_4_0._is_server = false

	local var_4_0 = true

	arg_4_0:reset(var_4_0)
end

function DeedManager.register_rpcs(arg_5_0, arg_5_1)
	arg_5_1:register(arg_5_0, unpack(var_0_0))

	arg_5_0._network_event_delegate = arg_5_1
end

function DeedManager.unregister_rpcs(arg_6_0)
	arg_6_0._network_event_delegate:unregister(arg_6_0)

	arg_6_0._network_event_delegate = nil
end

function DeedManager.reset(arg_7_0, arg_7_1)
	arg_7_0._selected_deed_data = nil
	arg_7_0._selected_deed_id = nil
	arg_7_0._owner_peer_id = nil
	arg_7_0._deed_session_faulty = nil

	if arg_7_0._is_server and not arg_7_1 then
		arg_7_0:_send_rpc_to_clients("rpc_reset_deed")
	end
end

function DeedManager.mutators(arg_8_0)
	if arg_8_0._selected_deed_data then
		return arg_8_0._selected_deed_data.mutators
	else
		return nil
	end
end

function DeedManager.rewards(arg_9_0)
	if arg_9_0._selected_deed_data then
		return arg_9_0._selected_deed_data.rewards
	else
		return nil
	end
end

function DeedManager.has_deed(arg_10_0)
	return arg_10_0._selected_deed_data ~= nil
end

function DeedManager.active_deed(arg_11_0)
	fassert(arg_11_0._selected_deed_data, "Has no active deed")

	return arg_11_0._selected_deed_data, arg_11_0._selected_deed_id
end

function DeedManager.is_deed_owner(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or arg_12_0._peer_id

	return arg_12_0._owner_peer_id == arg_12_1
end

function DeedManager.is_session_faulty(arg_13_0)
	return arg_13_0._deed_session_faulty
end

function DeedManager.consume_deed(arg_14_0, arg_14_1)
	print("[DeedManager]:consume_deed()")

	if arg_14_0._owner_peer_id == arg_14_0._peer_id then
		local var_14_0 = Managers.state.network

		if var_14_0 and var_14_0:game() then
			if arg_14_0._is_server then
				arg_14_0:_send_rpc_to_clients("rpc_deed_consumed")
			else
				arg_14_0:_send_rpc_to_server("rpc_deed_consumed")
			end
		end
	elseif arg_14_0._has_consumed_deed then
		arg_14_0._has_consumed_deed = nil
		arg_14_0._reward_callback = arg_14_1

		arg_14_0:_use_reward_callback()
	else
		arg_14_0._reward_callback = arg_14_1
	end
end

function DeedManager.hot_join_sync(arg_15_0, arg_15_1)
	if not arg_15_0:has_deed() then
		return
	end

	local var_15_0 = arg_15_0._selected_deed_data
	local var_15_1 = arg_15_0._owner_peer_id
	local var_15_2 = NetworkLookup.item_names[var_15_0.name]

	arg_15_0:_send_rpc_to_client("rpc_select_deed", arg_15_1, var_15_2, var_15_1)
end

function DeedManager.delete_marked_deeds(arg_16_0, arg_16_1)
	local var_16_0 = Managers.backend:get_interface("items")

	var_16_0:delete_marked_deeds(arg_16_1)

	local var_16_1 = var_16_0:is_deleting_deeds()

	arg_16_0._is_deleting_deeds = var_16_1

	return var_16_1
end

function DeedManager.is_deleting_deeds(arg_17_0)
	return arg_17_0._is_deleting_deeds and true or false
end

function DeedManager._update_deed_deletion(arg_18_0)
	if arg_18_0._is_deleting_deeds and not Managers.backend:get_interface("items"):is_deleting_deeds() then
		arg_18_0._is_deleting_deeds = nil
	end
end

function DeedManager.can_delete_deeds(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0, var_19_1, var_19_2 = Managers.backend:get_interface("items"):can_delete_deeds(arg_19_1, arg_19_2)
	local var_19_3
	local var_19_4
	local var_19_5 = arg_19_2 and #arg_19_2 or 0
	local var_19_6 = var_19_2 and #var_19_2 or 0

	if var_19_0 and var_19_6 ~= var_19_5 then
		return var_19_1, var_19_2, "Not all marked deeds could be deleted."
	end

	if not var_19_0 then
		return nil, nil, "No deeds could be deleted!"
	end

	return var_19_1, var_19_2, nil
end

function DeedManager.update(arg_20_0, arg_20_1)
	if arg_20_0:has_deed() then
		arg_20_0:_update_owner(arg_20_1)
	end

	arg_20_0:_update_deed_deletion()
end

function DeedManager.select_deed(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = Managers.backend:get_interface("items"):get_item_from_id(arg_21_1).data

	arg_21_0._selected_deed_data = var_21_0
	arg_21_0._selected_deed_id = arg_21_1
	arg_21_0._owner_peer_id = arg_21_2
	arg_21_0._deed_session_faulty = false

	local var_21_1 = Managers.state.network

	if var_21_1 and var_21_1:game() then
		local var_21_2 = NetworkLookup.item_names[var_21_0.name]

		if arg_21_0._is_server then
			arg_21_0:_send_rpc_to_clients("rpc_select_deed", var_21_2, arg_21_2)
		else
			arg_21_0:_send_rpc_to_server("rpc_select_deed", var_21_2, arg_21_2)
		end
	end
end

function DeedManager._update_owner(arg_22_0, arg_22_1)
	if arg_22_0._deed_session_faulty then
		return
	end

	local var_22_0 = arg_22_0._owner_peer_id

	if not arg_22_0._lobby:members():members_map()[var_22_0] then
		Managers.chat:add_local_system_message(1, Localize("deed_owner_left_game"), true)

		arg_22_0._deed_session_faulty = true
	end
end

function DeedManager._use_reward_callback(arg_23_0)
	fassert(arg_23_0._reward_callback, "there is no reward callback")

	local var_23_0 = arg_23_0._reward_callback

	arg_23_0._reward_callback = nil

	var_23_0()
end

function DeedManager.rpc_select_deed(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = NetworkLookup.item_names[arg_24_2]

	arg_24_0._selected_deed_data = ItemMasterList[var_24_0]
	arg_24_0._selected_deed_id = nil
	arg_24_0._owner_peer_id = arg_24_3

	local var_24_1 = Managers.state.network

	if arg_24_0._is_server and var_24_1 and var_24_1:game() then
		local var_24_2 = CHANNEL_TO_PEER_ID[arg_24_1]

		arg_24_0:_send_rpc_to_clients_except("rpc_select_deed", var_24_2, arg_24_2, arg_24_3)
	end
end

function DeedManager.rpc_deed_consumed(arg_25_0, arg_25_1)
	print("Deed has been consumed by owner, act on reward callback!")

	if not arg_25_0._reward_callback then
		arg_25_0._has_consumed_deed = true
	else
		arg_25_0:_use_reward_callback()
	end

	local var_25_0 = Managers.state.network

	if arg_25_0._is_server and var_25_0 and var_25_0:game() then
		print("Sending to the other clients to act on deed consume")

		local var_25_1 = CHANNEL_TO_PEER_ID[arg_25_1]

		arg_25_0:_send_rpc_to_clients_except("rpc_deed_consumed", var_25_1)
	end
end

function DeedManager.rpc_reset_deed(arg_26_0, arg_26_1)
	if CHANNEL_TO_PEER_ID[arg_26_1] ~= arg_26_0._server_peer_id then
		print("[DeedManager] Skipping rpc_reset_deed, not sent from current server")

		return
	end

	local var_26_0 = true

	arg_26_0:reset(var_26_0)
end

function DeedManager._send_rpc_to_server(arg_27_0, arg_27_1, ...)
	local var_27_0 = RPC[arg_27_1]
	local var_27_1 = PEER_ID_TO_CHANNEL[arg_27_0._server_peer_id]

	var_27_0(var_27_1, ...)
end

function DeedManager._send_rpc_to_clients(arg_28_0, arg_28_1, ...)
	local var_28_0 = arg_28_0._network_server

	if not var_28_0 then
		return
	end

	local var_28_1 = RPC[arg_28_1]
	local var_28_2 = arg_28_0._server_peer_id
	local var_28_3 = var_28_0:players_past_connecting()

	for iter_28_0 = 1, #var_28_3 do
		local var_28_4 = var_28_3[iter_28_0]

		if var_28_4 ~= var_28_2 then
			local var_28_5 = PEER_ID_TO_CHANNEL[var_28_4]

			var_28_1(var_28_5, ...)
		end
	end
end

function DeedManager._send_rpc_to_clients_except(arg_29_0, arg_29_1, arg_29_2, ...)
	local var_29_0 = arg_29_0._network_server

	if not var_29_0 then
		return
	end

	local var_29_1 = RPC[arg_29_1]
	local var_29_2 = arg_29_0._server_peer_id
	local var_29_3 = var_29_0:players_past_connecting()

	for iter_29_0 = 1, #var_29_3 do
		local var_29_4 = var_29_3[iter_29_0]

		if var_29_4 ~= var_29_2 and var_29_4 ~= arg_29_2 then
			local var_29_5 = PEER_ID_TO_CHANNEL[var_29_4]

			var_29_1(var_29_5, ...)
		end
	end
end

function DeedManager._send_rpc_to_client(arg_30_0, arg_30_1, arg_30_2, ...)
	if not arg_30_0._network_server then
		return
	end

	local var_30_0 = RPC[arg_30_1]
	local var_30_1 = PEER_ID_TO_CHANNEL[arg_30_2]

	var_30_0(var_30_1, ...)
end
