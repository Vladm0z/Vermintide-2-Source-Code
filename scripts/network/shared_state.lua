-- chunkname: @scripts/network/shared_state.lua

require("scripts/utils/hash_utils")

SharedState = class(SharedState)
script_data.shared_state_debug = true

local var_0_0 = {
	"rpc_shared_state_set_server_int",
	"rpc_shared_state_set_server_string",
	"rpc_shared_state_set_server_bool",
	"rpc_shared_state_set_int",
	"rpc_shared_state_set_string",
	"rpc_shared_state_set_bool",
	"rpc_shared_state_client_left",
	"rpc_shared_state_request_sync",
	"rpc_shared_state_full_sync_complete",
	"rpc_shared_state_start_atomic_set_server",
	"rpc_shared_state_end_atomic_set_server"
}
local var_0_1 = 500

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0[arg_1_1]

	if not var_1_0 then
		var_1_0 = {}
		arg_1_0[arg_1_1] = var_1_0
	end

	return var_1_0
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	arg_2_0 = var_0_2(arg_2_0, arg_2_1)
	arg_2_0 = var_0_2(arg_2_0, arg_2_2)
	arg_2_0 = var_0_2(arg_2_0, arg_2_3)
	arg_2_0 = var_0_2(arg_2_0, arg_2_4)
	arg_2_0 = var_0_2(arg_2_0, arg_2_5)
	arg_2_0 = var_0_2(arg_2_0, arg_2_6)
	arg_2_0[arg_2_7] = arg_2_8
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	arg_3_0 = arg_3_0[arg_3_1]

	if not arg_3_0 then
		return
	end

	arg_3_0 = arg_3_0[arg_3_2]

	if not arg_3_0 then
		return
	end

	arg_3_0 = arg_3_0[arg_3_3]

	if not arg_3_0 then
		return
	end

	arg_3_0 = arg_3_0[arg_3_4]

	if not arg_3_0 then
		return
	end

	arg_3_0 = arg_3_0[arg_3_5]

	if not arg_3_0 then
		return
	end

	arg_3_0 = arg_3_0[arg_3_6]

	if not arg_3_0 then
		return
	end

	arg_3_0 = arg_3_0[arg_3_7]

	return arg_3_0
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	arg_4_0 = var_0_2(arg_4_0, arg_4_1)
	arg_4_0 = var_0_2(arg_4_0, arg_4_2)
	arg_4_0 = var_0_2(arg_4_0, arg_4_3)
	arg_4_0 = var_0_2(arg_4_0, arg_4_4)
	arg_4_0 = var_0_2(arg_4_0, arg_4_5)
	arg_4_0[arg_4_6] = arg_4_7
end

local function var_0_6(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	arg_5_0 = arg_5_0[arg_5_1]

	if not arg_5_0 then
		return
	end

	arg_5_0 = arg_5_0[arg_5_2]

	if not arg_5_0 then
		return
	end

	arg_5_0 = arg_5_0[arg_5_3]

	if not arg_5_0 then
		return
	end

	arg_5_0 = arg_5_0[arg_5_4]

	if not arg_5_0 then
		return
	end

	arg_5_0 = arg_5_0[arg_5_5]

	if not arg_5_0 then
		return
	end

	arg_5_0 = arg_5_0[arg_5_6]

	return arg_5_0
end

local function var_0_7(arg_6_0)
	if arg_6_0 == "number" then
		return "rpc_shared_state_set_int"
	end

	if arg_6_0 == "string" then
		return "rpc_shared_state_set_string"
	end

	if arg_6_0 == "boolean" then
		return "rpc_shared_state_set_bool"
	end
end

local function var_0_8(arg_7_0)
	if arg_7_0 == "number" then
		return "rpc_shared_state_set_server_int"
	end

	if arg_7_0 == "string" then
		return "rpc_shared_state_set_server_string"
	end

	if arg_7_0 == "boolean" then
		return "rpc_shared_state_set_server_bool"
	end
end

local function var_0_9(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = arg_8_0
	local var_8_1 = var_0_2(var_8_0, arg_8_1)

	if arg_8_2 then
		var_8_1 = var_0_2(var_8_1, arg_8_2)
	end

	if arg_8_3 then
		var_8_1 = var_0_2(var_8_1, arg_8_3)
	end

	if arg_8_4 then
		var_8_1 = var_0_2(var_8_1, arg_8_4)
	end

	if arg_8_5 then
		var_8_1 = var_0_2(var_8_1, arg_8_5)
	end

	if arg_8_6 then
		var_8_1 = var_0_2(var_8_1, arg_8_6)
	end

	if not var_8_1.__val then
		var_8_1.__val = {
			key_type = arg_8_1,
			peer_id = arg_8_2 or "0",
			local_player_id = arg_8_3 or 0,
			profile_index = arg_8_4 or 0,
			career_index = arg_8_5 or 0,
			party_id = arg_8_6 or 0
		}
	end

	return var_8_1.__val
end

local function var_0_10(arg_9_0, arg_9_1)
	fassert(type(arg_9_1) == "table", "[SharedState] key is not in the right format, did you call :get_key() to create it?")

	local var_9_0 = arg_9_1.key_type

	fassert(arg_9_0, "[SharedState] no spec provided for the calling type of state (server or peer state)")
	fassert(arg_9_0[var_9_0], "[SharedState] key type '%s' does not belong to spec", tostring(var_9_0))

	local var_9_1 = arg_9_0[var_9_0].composite_keys
	local var_9_2 = arg_9_1.peer_id

	fassert(var_9_2 == "0" or var_9_1 and var_9_1.peer_id, "[SharedState] key type '%s' does not have peer_id as key parameter", tostring(var_9_0))
	fassert(var_9_2 ~= "0" or not var_9_1 or not var_9_1.peer_id, "[SharedState] key type '%s' needs peer_id as key parameter", tostring(var_9_0))

	local var_9_3 = arg_9_1.local_player_id

	fassert(var_9_3 == 0 or var_9_1 and var_9_1.local_player_id, "[SharedState] key type '%s' does not have local_player_id as key parameter", tostring(var_9_0))
	fassert(var_9_3 ~= 0 or not var_9_1 or not var_9_1.local_player_id, "[SharedState] key type '%s' needs local_player_id as key parameter", tostring(var_9_0))

	local var_9_4 = arg_9_1.profile_index

	fassert(var_9_4 == 0 or var_9_1 and var_9_1.profile_index, "[SharedState] key type '%s' does not have profile_index as key parameter", tostring(var_9_0))
	fassert(var_9_4 ~= 0 or not var_9_1 or not var_9_1.profile_index, "[SharedState] key type '%s' needs profile_index as key parameter", tostring(var_9_0))

	local var_9_5 = arg_9_1.career_index

	fassert(var_9_5 == 0 or var_9_1 and var_9_1.career_index, "[SharedState] key type '%s' does not have career_index as key parameter", tostring(var_9_0))
	fassert(var_9_5 ~= 0 or not var_9_1 or not var_9_1.career_index, "[SharedState] key type '%s' needs career_index as key parameter", tostring(var_9_0))

	local var_9_6 = arg_9_1.party_id

	fassert(var_9_6 == 0 or var_9_1 and var_9_1.party_id, "[SharedState] key type '%s' does not have party_id as key parameter", tostring(var_9_0))
	fassert(var_9_6 ~= 0 or not var_9_1 or not var_9_1.party_id, "[SharedState] key type '%s' needs party_id as key parameter", tostring(var_9_0))
end

local function var_0_11(arg_10_0)
	local var_10_0 = {}

	if arg_10_0.server then
		for iter_10_0, iter_10_1 in pairs(arg_10_0.server) do
			var_10_0[#var_10_0 + 1] = iter_10_0
		end
	end

	if arg_10_0.peer then
		for iter_10_2, iter_10_3 in pairs(arg_10_0.peer) do
			var_10_0[#var_10_0 + 1] = iter_10_2
		end
	end

	table.sort(var_10_0)

	local var_10_1 = {}

	for iter_10_4, iter_10_5 in ipairs(var_10_0) do
		var_10_1[iter_10_5] = iter_10_4
		var_10_1[iter_10_4] = iter_10_5
	end

	return var_10_1
end

local function var_0_12(arg_11_0)
	local var_11_0 = type(arg_11_0)

	if var_11_0 == "string" or var_11_0 == "number" or var_11_0 == "boolean" then
		return tostring(arg_11_0)
	else
		return cjson.encode(arg_11_0)
	end
end

local var_0_13 = printf

local function var_0_14(...)
	local var_12_0 = sprintf(...)

	var_0_13("[SharedState] %s", var_12_0)
end

local function var_0_15(...)
	if script_data.shared_state_debug then
		local var_13_0 = sprintf(...)

		var_0_13("[SharedState] %s", var_13_0)
	end
end

local function var_0_16(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
	local var_14_0 = type(arg_14_9)
	local var_14_1 = var_0_7(var_14_0)

	if var_14_0 == "string" then
		local var_14_2 = #arg_14_9

		if var_14_2 == 0 then
			RPC[var_14_1](arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9, true)
		else
			for iter_14_0 = 1, var_14_2, var_0_1 do
				local var_14_3 = arg_14_9:sub(iter_14_0, iter_14_0 + var_0_1 - 1)
				local var_14_4 = var_14_2 < iter_14_0 + var_0_1

				RPC[var_14_1](arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, var_14_3, var_14_4)
			end
		end
	else
		RPC[var_14_1](arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
	end
end

local function var_0_17(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8)
	local var_15_0 = type(arg_15_8)
	local var_15_1 = var_0_8(var_15_0)

	if var_15_0 == "string" then
		local var_15_2 = #arg_15_8

		if var_15_2 == 0 then
			RPC[var_15_1](arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, true)
		else
			for iter_15_0 = 1, var_15_2, var_0_1 do
				local var_15_3 = arg_15_8:sub(iter_15_0, iter_15_0 + var_0_1 - 1)
				local var_15_4 = var_15_2 < iter_15_0 + var_0_1

				RPC[var_15_1](arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, var_15_3, var_15_4)
			end
		end
	else
		RPC[var_15_1](arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8)
	end
end

function SharedState.init(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	arg_16_0._original_context = arg_16_1
	arg_16_0._context = tostring(HashUtils.fnv32_hash(arg_16_1))
	arg_16_0._spec = arg_16_2
	arg_16_0._revision = 0
	arg_16_0._key_type_lookup = var_0_11(arg_16_2)
	arg_16_0._is_server = arg_16_3
	arg_16_0._peer_state = {}
	arg_16_0._server_state = {}
	arg_16_0._peer_id = arg_16_6
	arg_16_0._server_peer_id = arg_16_5

	if arg_16_3 then
		arg_16_0._server_full_sync_complete_mapping = {}
		arg_16_0._network_server = arg_16_4
	else
		arg_16_0._client_full_sync_complete = false
	end

	arg_16_0._key_cache = {}
	arg_16_0._callbacks = {
		server_data_updated = {},
		client_data_updated = {},
		client_left = {},
		full_sync_complete = {}
	}

	if arg_16_0._is_server then
		arg_16_0._network_server:register_shared_state(arg_16_0)
	end

	arg_16_0:_init_immediate_initializations()
end

function SharedState.register_callback(arg_17_0, arg_17_1, arg_17_2, arg_17_3, ...)
	local var_17_0 = arg_17_0._callbacks[arg_17_1]

	fassert(var_17_0, "Invalid callback type %s", arg_17_1)

	local var_17_1 = var_17_0[arg_17_2]

	fassert(var_17_1 == nil, "Callback already registered on object for type '%s'", arg_17_1)

	local var_17_2
	local var_17_3 = select("#", ...)

	if var_17_3 > 0 then
		var_17_2 = {}

		for iter_17_0 = 1, var_17_3 do
			var_17_2[select(iter_17_0, ...)] = true
		end
	end

	var_17_0[arg_17_2] = {
		func_name = arg_17_3,
		filter = var_17_2
	}
end

function SharedState.unregister_callback(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._callbacks[arg_18_2]

	if not var_18_0 then
		return
	end

	var_18_0[arg_18_1] = nil
end

function SharedState.network_context_created(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	arg_19_0._peer_id = arg_19_3
	arg_19_0._server_peer_id = arg_19_2
	arg_19_0._is_server = arg_19_4

	if arg_19_4 then
		arg_19_0._server_full_sync_complete_mapping = {}
		arg_19_0._network_server = arg_19_5
	else
		arg_19_0._client_full_sync_complete = false
		arg_19_0._network_server = nil
	end
end

function SharedState.register_rpcs(arg_20_0, arg_20_1)
	if arg_20_0._network_event_delegate then
		arg_20_0._network_event_delegate:unregister(arg_20_0)
	end

	arg_20_0._network_event_delegate = arg_20_1

	arg_20_1:register(arg_20_0, unpack(var_0_0))
end

function SharedState.get_revision(arg_21_0)
	return arg_21_0._revision
end

function SharedState.clear_peer_data(arg_22_0, arg_22_1)
	if arg_22_0:_is_destroyed() then
		return
	end

	var_0_15("%s: <clear_peer_data> %s", arg_22_0._original_context, arg_22_1)
	arg_22_0:_clear_peer_id_data(arg_22_1)

	if arg_22_0._network_server then
		local var_22_0 = arg_22_0._network_server:get_peers()

		for iter_22_0, iter_22_1 in ipairs(var_22_0) do
			local var_22_1 = PEER_ID_TO_CHANNEL[iter_22_1]

			RPC.rpc_shared_state_client_left(var_22_1, arg_22_0._context, arg_22_1)
		end
	end

	arg_22_0._server_full_sync_complete_mapping[arg_22_1] = nil
end

function SharedState.full_sync(arg_23_0)
	if arg_23_0:_is_destroyed() then
		return
	end

	if arg_23_0._is_server then
		if arg_23_0._network_server then
			local var_23_0 = arg_23_0._network_server:get_peers()

			for iter_23_0, iter_23_1 in ipairs(var_23_0) do
				if iter_23_1 ~= arg_23_0._peer_id then
					local var_23_1 = PEER_ID_TO_CHANNEL[iter_23_1]

					RPC.rpc_shared_state_request_sync(var_23_1, arg_23_0._context)
				end
			end
		end
	else
		arg_23_0._client_full_sync_complete = false

		local var_23_2 = PEER_ID_TO_CHANNEL[arg_23_0._server_peer_id]

		if var_23_2 then
			RPC.rpc_shared_state_request_sync(var_23_2, arg_23_0._context)
		end
	end
end

function SharedState.unregister_rpcs(arg_24_0)
	if arg_24_0._network_event_delegate then
		arg_24_0._network_event_delegate:unregister(arg_24_0)
	end

	arg_24_0._network_event_delegate = nil
end

function SharedState.destroy(arg_25_0)
	arg_25_0:unregister_rpcs()

	arg_25_0._peer_state = nil
	arg_25_0._server_state = nil
	arg_25_0._context = nil
	arg_25_0._is_server = nil

	if arg_25_0._is_server then
		arg_25_0._network_server:deregister_shared_state(arg_25_0)
	end
end

function SharedState.is_peer_fully_synced(arg_26_0, arg_26_1)
	if arg_26_0._is_server then
		if not arg_26_0._network_server then
			return false
		end

		if arg_26_1 ~= arg_26_0._server_peer_id then
			return arg_26_0._server_full_sync_complete_mapping[arg_26_1]
		else
			return true
		end
	else
		return arg_26_0._client_full_sync_complete
	end
end

function SharedState.get_key(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	return var_0_9(arg_27_0._key_cache, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
end

function SharedState.set_peer(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if arg_28_0:_is_destroyed() then
		return
	end

	fassert(arg_28_3 ~= nil, "value can't be nil")

	local var_28_0 = arg_28_0._spec.peer[arg_28_2.key_type]

	fassert(type(arg_28_3) == var_28_0.type, "value type is not the same as the spec defines.")
	var_0_3(arg_28_0._peer_state, arg_28_1, arg_28_2.key_type, arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, arg_28_3)

	if arg_28_1 == arg_28_0._peer_id then
		if not var_28_0.mute_print then
			var_0_15("%s: <set %s> %s:%s:%d:%d:%d:%d = %s", arg_28_0._original_context, arg_28_1, arg_28_2.key_type, arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, var_0_12(arg_28_3))
		end

		local var_28_1 = arg_28_0._spec.peer[arg_28_2.key_type].encode
		local var_28_2 = var_28_1 and var_28_1(arg_28_3) or arg_28_3

		if arg_28_0._is_server then
			if arg_28_0._network_server then
				local var_28_3 = arg_28_0._network_server:get_peers()

				for iter_28_0, iter_28_1 in ipairs(var_28_3) do
					if iter_28_1 ~= arg_28_0._peer_id then
						local var_28_4 = PEER_ID_TO_CHANNEL[iter_28_1]

						var_0_16(var_28_4, arg_28_0._context, arg_28_0._peer_id, arg_28_0._key_type_lookup[arg_28_2.key_type], arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, var_28_2)
					end
				end
			end
		else
			local var_28_5 = PEER_ID_TO_CHANNEL[arg_28_0._server_peer_id]

			var_0_16(var_28_5, arg_28_0._context, arg_28_0._peer_id, arg_28_0._key_type_lookup[arg_28_2.key_type], arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, var_28_2)
		end
	elseif not var_28_0.mute_print then
		var_0_15("%s: <set prediction %s> %s:%s:%d:%d:%d:%d = %s", arg_28_0._original_context, arg_28_1, arg_28_2.key_type, arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, var_0_12(arg_28_3))
	end

	arg_28_0:_increment_revision()
end

function SharedState.start_atomic_set_server(arg_29_0, arg_29_1)
	fassert(not arg_29_0._current_start_atomic_set_server, "start_atomic_set_server(%s) called before calling end_atomic_set_server(%s)", arg_29_1, arg_29_0._current_start_atomic_set_server)

	arg_29_0._current_start_atomic_set_server = arg_29_1

	if arg_29_0._is_server then
		var_0_15("%s: <atomic_set_server start> name:%s", arg_29_0._original_context, arg_29_1)

		if arg_29_0._network_server then
			local var_29_0 = arg_29_0._network_server:get_peers()

			for iter_29_0, iter_29_1 in ipairs(var_29_0) do
				if iter_29_1 ~= arg_29_0._peer_id then
					local var_29_1 = PEER_ID_TO_CHANNEL[iter_29_1]

					RPC.rpc_shared_state_start_atomic_set_server(var_29_1, arg_29_0._context)
				end
			end
		end
	else
		var_0_15("%s: <atomic_set_server start prediction> name:%s", arg_29_0._original_context, arg_29_1)
	end
end

function SharedState.end_atomic_set_server(arg_30_0, arg_30_1)
	fassert(arg_30_0._current_start_atomic_set_server == arg_30_1, "mismatched end_atomic_set_server(%s) and start_atomic_set_server(%s)", arg_30_1, arg_30_0._current_start_atomic_set_server)

	if arg_30_0._is_server then
		var_0_15("%s: <atomic_set_server end> name:%s", arg_30_0._original_context, arg_30_1)

		if arg_30_0._network_server then
			local var_30_0 = arg_30_0._network_server:get_peers()

			for iter_30_0, iter_30_1 in ipairs(var_30_0) do
				if iter_30_1 ~= arg_30_0._peer_id then
					local var_30_1 = PEER_ID_TO_CHANNEL[iter_30_1]

					RPC.rpc_shared_state_end_atomic_set_server(var_30_1, arg_30_0._context)
				end
			end
		end
	else
		var_0_15("%s: <atomic_set_server end prediction> name:%s", arg_30_0._original_context, arg_30_1)
	end

	arg_30_0._current_start_atomic_set_server = nil
end

function SharedState.set_server(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0:_is_destroyed() then
		return
	end

	fassert(arg_31_2 ~= nil, "value can't be nil")

	local var_31_0 = arg_31_0._spec.server[arg_31_1.key_type]

	fassert(type(arg_31_2) == var_31_0.type, "value type is not the same as the spec defines.")
	var_0_5(arg_31_0._server_state, arg_31_1.key_type, arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, arg_31_2)

	if arg_31_0._is_server then
		if not var_31_0.mute_print then
			var_0_15("%s: <set server> %s:%s:%d:%d:%d:%d = %s", arg_31_0._original_context, arg_31_1.key_type, arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, var_0_12(arg_31_2))
		end

		local var_31_1 = arg_31_0._spec.server[arg_31_1.key_type].encode
		local var_31_2 = var_31_1 and var_31_1(arg_31_2) or arg_31_2

		if arg_31_0._network_server then
			local var_31_3 = arg_31_0._network_server:get_peers()

			for iter_31_0, iter_31_1 in ipairs(var_31_3) do
				if iter_31_1 ~= arg_31_0._peer_id then
					local var_31_4 = PEER_ID_TO_CHANNEL[iter_31_1]

					var_0_17(var_31_4, arg_31_0._context, arg_31_0._key_type_lookup[arg_31_1.key_type], arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, var_31_2)
				end
			end
		end
	elseif not var_31_0.mute_print then
		var_0_15("%s: <set server prediction> %s:%s:%d:%d:%d:%d = %s", arg_31_0._original_context, arg_31_1.key_type, arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, var_0_12(arg_31_2))
	end

	arg_31_0:_increment_revision()
end

function SharedState.set_own(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0:set_peer(arg_32_0._peer_id, arg_32_1, arg_32_2)
end

function SharedState.get_peer(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0:_is_destroyed() then
		return arg_33_0._spec.peer[arg_33_2.key_type].default_value
	end

	return var_0_4(arg_33_0._peer_state, arg_33_1, arg_33_2.key_type, arg_33_2.peer_id, arg_33_2.local_player_id, arg_33_2.profile_index, arg_33_2.career_index, arg_33_2.party_id) or arg_33_0._spec.peer[arg_33_2.key_type].default_value
end

function SharedState.get_own(arg_34_0, arg_34_1)
	return arg_34_0:get_peer(arg_34_0._peer_id, arg_34_1)
end

function SharedState.get_server(arg_35_0, arg_35_1)
	if arg_35_0:_is_destroyed() then
		return arg_35_0._spec.server[arg_35_1.key_type].default_value
	end

	return var_0_6(arg_35_0._server_state, arg_35_1.key_type, arg_35_1.peer_id, arg_35_1.local_player_id, arg_35_1.profile_index, arg_35_1.career_index, arg_35_1.party_id) or arg_35_0._spec.server[arg_35_1.key_type].default_value
end

function SharedState.rpc_shared_state_request_sync(arg_36_0, arg_36_1, arg_36_2)
	if arg_36_0:_is_destroyed() then
		return nil
	end

	if arg_36_2 ~= arg_36_0._context then
		return
	end

	if arg_36_0._is_server then
		for iter_36_0, iter_36_1 in pairs(arg_36_0._server_state) do
			for iter_36_2, iter_36_3 in pairs(iter_36_1) do
				for iter_36_4, iter_36_5 in pairs(iter_36_3) do
					for iter_36_6, iter_36_7 in pairs(iter_36_5) do
						for iter_36_8, iter_36_9 in pairs(iter_36_7) do
							for iter_36_10, iter_36_11 in pairs(iter_36_9) do
								local var_36_0 = arg_36_0._spec.server[iter_36_0].encode
								local var_36_1 = var_36_0 and var_36_0(iter_36_11) or iter_36_11

								var_0_17(arg_36_1, arg_36_0._context, arg_36_0._key_type_lookup[iter_36_0], iter_36_2, iter_36_4, iter_36_6, iter_36_8, iter_36_10, var_36_1)
							end
						end
					end
				end
			end
		end

		local var_36_2 = CHANNEL_TO_PEER_ID[arg_36_1]

		for iter_36_12, iter_36_13 in pairs(arg_36_0._peer_state) do
			if iter_36_12 ~= var_36_2 then
				arg_36_0:_send_all(arg_36_1, iter_36_12, iter_36_13)
			end
		end

		RPC.rpc_shared_state_full_sync_complete(arg_36_1, arg_36_0._context)

		arg_36_0._server_full_sync_complete_mapping[var_36_2] = true
	else
		local var_36_3 = Network.peer_id()
		local var_36_4 = arg_36_0._peer_state[var_36_3]

		if var_36_4 then
			arg_36_0:_send_all(arg_36_1, var_36_3, var_36_4)
		end
	end
end

function SharedState.rpc_shared_state_full_sync_complete(arg_37_0, arg_37_1, arg_37_2)
	if arg_37_0:_is_destroyed() then
		return
	end

	if arg_37_2 ~= arg_37_0._context then
		return
	end

	arg_37_0._client_full_sync_complete = true

	local var_37_0 = arg_37_0._callbacks.full_sync_complete

	for iter_37_0, iter_37_1 in pairs(var_37_0) do
		iter_37_0[iter_37_1.func_name](iter_37_0, peer_id)
	end
end

function SharedState.rpc_shared_state_set_int(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8, arg_38_9, arg_38_10)
	if arg_38_0:_is_destroyed() then
		return
	end

	if arg_38_2 ~= arg_38_0._context then
		return
	end

	arg_38_0:_set_rpc(arg_38_1, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8, arg_38_9, arg_38_10)
end

function SharedState.rpc_shared_state_set_string(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10, arg_39_11)
	if arg_39_0:_is_destroyed() then
		return
	end

	if arg_39_2 ~= arg_39_0._context then
		return
	end

	if arg_39_0._batched_string_buffer then
		arg_39_0._batched_string_buffer[#arg_39_0._batched_string_buffer + 1] = arg_39_10

		if arg_39_11 then
			local var_39_0 = table.concat(arg_39_0._batched_string_buffer, "")

			arg_39_0:_set_rpc(arg_39_1, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, var_39_0)

			arg_39_0._batched_string_buffer = nil
		end
	elseif arg_39_11 then
		arg_39_0:_set_rpc(arg_39_1, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10)
	else
		arg_39_0._batched_string_buffer = {
			arg_39_10
		}
	end
end

function SharedState.rpc_shared_state_set_bool(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7, arg_40_8, arg_40_9, arg_40_10)
	if arg_40_0:_is_destroyed() then
		return
	end

	if arg_40_2 ~= arg_40_0._context then
		return
	end

	arg_40_0:_set_rpc(arg_40_1, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7, arg_40_8, arg_40_9, arg_40_10)
end

function SharedState.rpc_shared_state_set_server_int(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9)
	if arg_41_0:_is_destroyed() then
		return
	end

	if arg_41_2 ~= arg_41_0._context then
		return
	end

	arg_41_0:_set_server_rpc(arg_41_1, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9)
end

function SharedState.rpc_shared_state_set_server_string(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9, arg_42_10)
	if arg_42_0:_is_destroyed() then
		return
	end

	if arg_42_2 ~= arg_42_0._context then
		return
	end

	if arg_42_0._batched_string_buffer then
		arg_42_0._batched_string_buffer[#arg_42_0._batched_string_buffer + 1] = arg_42_9

		if arg_42_10 then
			local var_42_0 = table.concat(arg_42_0._batched_string_buffer, "")

			arg_42_0:_set_server_rpc(arg_42_1, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, var_42_0)

			arg_42_0._batched_string_buffer = nil
		end
	elseif arg_42_10 then
		arg_42_0:_set_server_rpc(arg_42_1, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9)
	else
		arg_42_0._batched_string_buffer = {
			arg_42_9
		}
	end
end

function SharedState.rpc_shared_state_set_server_bool(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9)
	if arg_43_0:_is_destroyed() then
		return
	end

	if arg_43_2 ~= arg_43_0._context then
		return
	end

	arg_43_0:_set_server_rpc(arg_43_1, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9)
end

function SharedState.rpc_shared_state_client_left(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if arg_44_0:_is_destroyed() then
		return
	end

	if arg_44_2 ~= arg_44_0._context then
		return
	end

	var_0_15("%s: <rpc client left> %s", arg_44_0._original_context, arg_44_3)
	arg_44_0:_clear_peer_id_data(arg_44_3)

	local var_44_0 = arg_44_0._callbacks.client_left

	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		if not iter_44_1.filter or iter_44_1.filter[arg_44_3] then
			iter_44_0[iter_44_1.func_name](iter_44_0, arg_44_3)
		end
	end
end

function SharedState._set_rpc(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9)
	local var_45_0 = arg_45_0._key_type_lookup[arg_45_3]
	local var_45_1 = arg_45_0._spec.peer[var_45_0]
	local var_45_2 = var_45_1.decode
	local var_45_3 = var_45_2 and var_45_2(arg_45_9) or arg_45_9

	if not var_45_1.mute_print then
		var_0_15("%s: <rpc set %s> %s:%s:%d:%d:%d:%d = %s", arg_45_0._original_context, arg_45_2, var_45_0, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, var_0_12(var_45_3))
	end

	var_0_3(arg_45_0._peer_state, arg_45_2, var_45_0, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, var_45_3)

	if arg_45_0._is_server then
		local var_45_4 = CHANNEL_TO_PEER_ID[arg_45_1]

		if arg_45_0._network_server then
			local var_45_5 = arg_45_0._network_server:get_peers()

			for iter_45_0, iter_45_1 in ipairs(var_45_5) do
				if iter_45_1 ~= var_45_4 and iter_45_1 ~= arg_45_0._peer_id then
					local var_45_6 = PEER_ID_TO_CHANNEL[iter_45_1]

					var_0_16(var_45_6, arg_45_0._context, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9)
				end
			end
		end
	end

	arg_45_0:_increment_revision()

	local var_45_7 = arg_45_0._callbacks.client_data_updated

	for iter_45_2, iter_45_3 in pairs(var_45_7) do
		if not iter_45_3.filter or iter_45_3.filter[var_45_0] then
			iter_45_2[iter_45_3.func_name](iter_45_2, arg_45_2, var_45_0, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, var_45_3)
		end
	end
end

function SharedState._set_server_rpc(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8)
	local var_46_0 = arg_46_0._atomic_set_server_cache

	if var_46_0 then
		local var_46_1 = #var_46_0

		var_46_0[var_46_1] = arg_46_1
		var_46_0[var_46_1 + 1] = arg_46_2
		var_46_0[var_46_1 + 2] = arg_46_3
		var_46_0[var_46_1 + 3] = arg_46_4
		var_46_0[var_46_1 + 4] = arg_46_5
		var_46_0[var_46_1 + 5] = arg_46_6
		var_46_0[var_46_1 + 6] = arg_46_7
		var_46_0[var_46_1 + 7] = arg_46_8

		return
	end

	local var_46_2 = arg_46_0._key_type_lookup[arg_46_2]
	local var_46_3 = arg_46_0._spec.server[var_46_2]
	local var_46_4 = var_46_3.decode
	local var_46_5 = var_46_4 and var_46_4(arg_46_8) or arg_46_8

	if not var_46_3.mute_print then
		var_0_15("%s: <rpc set server> %s:%s:%d:%d:%d:%d = %s", arg_46_0._original_context, var_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, var_0_12(var_46_5))
	end

	var_0_5(arg_46_0._server_state, var_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, var_46_5)
	arg_46_0:_increment_revision()

	local var_46_6 = arg_46_0._callbacks.server_data_updated

	for iter_46_0, iter_46_1 in pairs(var_46_6) do
		if not iter_46_1.filter or iter_46_1.filter[var_46_2] then
			iter_46_0[iter_46_1.func_name](iter_46_0, var_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, var_46_5)
		end
	end
end

function SharedState._send_all(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	for iter_47_0, iter_47_1 in pairs(arg_47_3) do
		for iter_47_2, iter_47_3 in pairs(iter_47_1) do
			for iter_47_4, iter_47_5 in pairs(iter_47_3) do
				for iter_47_6, iter_47_7 in pairs(iter_47_5) do
					for iter_47_8, iter_47_9 in pairs(iter_47_7) do
						for iter_47_10, iter_47_11 in pairs(iter_47_9) do
							local var_47_0 = arg_47_0._spec.peer[iter_47_0].encode
							local var_47_1 = var_47_0 and var_47_0(iter_47_11) or iter_47_11

							var_0_16(arg_47_1, arg_47_0._context, arg_47_2, arg_47_0._key_type_lookup[iter_47_0], iter_47_2, iter_47_4, iter_47_6, iter_47_8, iter_47_10, var_47_1)
						end
					end
				end
			end
		end
	end
end

function SharedState._clear_peer_id_data(arg_48_0, arg_48_1)
	for iter_48_0, iter_48_1 in pairs(arg_48_0._spec.server) do
		if iter_48_1.clear_when_peer_id_leaves then
			local var_48_0 = arg_48_0._server_state[iter_48_0]

			if var_48_0 then
				var_48_0[arg_48_1] = nil
			end
		end
	end

	arg_48_0._peer_state[arg_48_1] = nil

	for iter_48_2, iter_48_3 in pairs(arg_48_0._spec.peer) do
		if iter_48_3.clear_when_peer_id_leaves then
			for iter_48_4, iter_48_5 in pairs(arg_48_0._peer_state) do
				local var_48_1 = iter_48_5[iter_48_2]

				if var_48_1 then
					var_48_1[arg_48_1] = nil
				end
			end
		end
	end

	arg_48_0:_increment_revision()
end

function SharedState.has_peer_state(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._peer_state[arg_49_1]

	return var_49_0 and var_49_0[arg_49_2]
end

function SharedState._is_destroyed(arg_50_0)
	return arg_50_0._server_state == nil
end

function SharedState._increment_revision(arg_51_0)
	local var_51_0 = arg_51_0._revision

	arg_51_0._revision = arg_51_0._revision + 1

	if arg_51_0._revision == var_51_0 then
		var_0_15("%s: revision reset back to zero", arg_51_0._original_context)

		arg_51_0._revision = 0
	end
end

function SharedState.rpc_shared_state_start_atomic_set_server(arg_52_0, arg_52_1)
	if arg_52_0:_is_destroyed() then
		return
	end

	if arg_52_1 ~= arg_52_0._context then
		return
	end

	arg_52_0._atomic_set_server_cache = {}
end

function SharedState.rpc_shared_state_end_atomic_set_server(arg_53_0, arg_53_1)
	if arg_53_0:_is_destroyed() then
		return
	end

	if arg_53_1 ~= arg_53_0._context then
		return
	end

	local var_53_0 = arg_53_0._atomic_set_server_cache

	fassert(var_53_0, "rpc_shared_state_end_atomic_set_server received when rpc_shared_state_start_atomic_set_server had not been called before")

	for iter_53_0 = 1, #var_53_0, 7 do
		local var_53_1 = var_53_0[iter_53_0]
		local var_53_2 = var_53_0[iter_53_0 + 1]
		local var_53_3 = var_53_0[iter_53_0 + 2]
		local var_53_4 = var_53_0[iter_53_0 + 3]
		local var_53_5 = var_53_0[iter_53_0 + 4]
		local var_53_6 = var_53_0[iter_53_0 + 5]
		local var_53_7 = var_53_0[iter_53_0 + 6]
		local var_53_8 = var_53_0[iter_53_0 + 7]

		arg_53_0:_set_server_rpc(var_53_1, var_53_2, var_53_3, var_53_4, var_53_5, var_53_6, var_53_7, var_53_8)
	end
end

local function var_0_18(arg_54_0)
	for iter_54_0, iter_54_1 in pairs(arg_54_0) do
		fassert(iter_54_1.type, "spec %s invalid, missing type", iter_54_0)
		fassert(iter_54_1.default_value ~= nil, "spec %s invalid, missing default_value", iter_54_0)
		fassert(type(iter_54_1.default_value) == iter_54_1.type, "spec %s invalid, missing default_value", iter_54_0)

		if iter_54_1.type == "table" then
			fassert(iter_54_1.decode and iter_54_1.encode, "spec %s invalid, must provide decode and encode method with table type", iter_54_0)
		end

		fassert(iter_54_1.composite_keys, "spec %s invalid, missing composite_keys", iter_54_0)

		for iter_54_2, iter_54_3 in pairs(iter_54_1.composite_keys) do
			fassert(iter_54_2 == "peer_id" or iter_54_2 == "local_player_id" or iter_54_2 == "profile_index" or iter_54_2 == "career_index" or iter_54_2 == "party_id", "spec %s invalid, invalid key_param %s, must be one of peer_id, local_player_id, profile_index, career_index, party_id", iter_54_0)
		end

		fassert(not iter_54_1.clear_when_peer_id_leaves or iter_54_1.clear_when_peer_id_leaves and iter_54_1.composite_keys.peer_id, "Faulty use of 'clear_when_peer_id_leaves'. Can not deduce when to clear value if peer_id is not part of composite keys.")
	end
end

function SharedState.validate_spec(arg_55_0)
	fassert(arg_55_0, "spec invalid, nil")
	fassert(arg_55_0.peer, "spec invalid, missing peer spec")
	fassert(arg_55_0.server, "spec invalid, missing server spec")
	var_0_18(arg_55_0.peer)
	var_0_18(arg_55_0.server)
end

function SharedState._init_immediate_initializations(arg_56_0)
	local var_56_0 = arg_56_0._spec.peer
	local var_56_1 = arg_56_0._spec.server
	local var_56_2 = arg_56_0._is_server
	local var_56_3 = arg_56_0._peer_id
	local var_56_4 = arg_56_0._key_type_lookup

	for iter_56_0 = 1, #var_56_4 do
		local var_56_5 = var_56_4[iter_56_0]
		local var_56_6 = var_56_0[var_56_5]

		if var_56_6 then
			local var_56_7 = var_56_6.immediate_initialization

			if var_56_7 then
				local var_56_8, var_56_9 = var_56_7(arg_56_0, var_56_3)

				arg_56_0:set_own(var_56_8, var_56_9)
			end
		elseif var_56_2 then
			local var_56_10 = var_56_1[var_56_5].immediate_initialization

			if var_56_10 then
				local var_56_11, var_56_12 = var_56_10(arg_56_0, var_56_3)

				arg_56_0:set_server(var_56_11, var_56_12)
			end
		end
	end
end
