-- chunkname: @scripts/network/shared_state.lua

require("scripts/utils/hash_utils")

SharedState = class(SharedState)
script_data.shared_state_debug = true

local tbl = {
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

local function fn(self, arg_1_1)
	-- function 1
	local var_1_0 = self[arg_1_1]

	if not var_1_0 then
		var_1_0 = {}
		self[arg_1_1] = var_1_0
	end

	return var_1_0
end

local function fn_2(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	self = fn(self, arg_2_1)
	self = fn(self, arg_2_2)
	self = fn(self, arg_2_3)
	self = fn(self, arg_2_4)
	self = fn(self, arg_2_5)
	self = fn(self, arg_2_6)
	self[arg_2_7] = arg_2_8
end

local function fn_3(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	self = self[arg_3_1]

	if not self then
		return
	end

	self = self[arg_3_2]

	if not self then
		return
	end

	self = self[arg_3_3]

	if not self then
		return
	end

	self = self[arg_3_4]

	if not self then
		return
	end

	self = self[arg_3_5]

	if not self then
		return
	end

	self = self[arg_3_6]

	if not self then
		return
	end

	self = self[arg_3_7]

	return self
end

local function fn_4(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	self = fn(self, arg_4_1)
	self = fn(self, arg_4_2)
	self = fn(self, arg_4_3)
	self = fn(self, arg_4_4)
	self = fn(self, arg_4_5)
	self[arg_4_6] = arg_4_7
end

local function fn_5(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	self = self[arg_5_1]

	if not self then
		return
	end

	self = self[arg_5_2]

	if not self then
		return
	end

	self = self[arg_5_3]

	if not self then
		return
	end

	self = self[arg_5_4]

	if not self then
		return
	end

	self = self[arg_5_5]

	if not self then
		return
	end

	self = self[arg_5_6]

	return self
end

local function fn_6(arg_6_0)
	-- function 6
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

local function fn_7(arg_7_0)
	-- function 7
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

local function fn_8(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	local var_8_0 = arg_8_0
	local var_8_1 = fn(var_8_0, arg_8_1)

	if not arg_8_2 then
		var_8_1 = fn(var_8_1, arg_8_2)
	end

	if not arg_8_3 then
		var_8_1 = fn(var_8_1, arg_8_3)
	end

	if not arg_8_4 then
		var_8_1 = fn(var_8_1, arg_8_4)
	end

	if not arg_8_5 then
		var_8_1 = fn(var_8_1, arg_8_5)
	end

	if not arg_8_6 then
		var_8_1 = fn(var_8_1, arg_8_6)
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

local function fn_9(self, arg_9_1)
	-- function 9
	fassert(type(arg_9_1) == "table", "[SharedState] key is not in the right format, did you call :get_key() to create it?")

	local key_type = arg_9_1.key_type

	fassert(self, "[SharedState] no spec provided for the calling type of state (server or peer state)")
	fassert(self[key_type], "[SharedState] key type '%s' does not belong to spec", tostring(key_type))

	local composite_keys = self[key_type].composite_keys
	local peer_id = arg_9_1.peer_id

	fassert((peer_id == "0" or not composite_keys) and composite_keys.peer_id, "[SharedState] key type '%s' does not have peer_id as key parameter", tostring(key_type))
	fassert((peer_id ~= "0" or not composite_keys) and not composite_keys.peer_id, "[SharedState] key type '%s' needs peer_id as key parameter", tostring(key_type))

	local local_player_id = arg_9_1.local_player_id

	fassert((local_player_id == 0 or not composite_keys) and composite_keys.local_player_id, "[SharedState] key type '%s' does not have local_player_id as key parameter", tostring(key_type))
	fassert((local_player_id ~= 0 or not composite_keys) and not composite_keys.local_player_id, "[SharedState] key type '%s' needs local_player_id as key parameter", tostring(key_type))

	local profile_index = arg_9_1.profile_index

	fassert((profile_index == 0 or not composite_keys) and composite_keys.profile_index, "[SharedState] key type '%s' does not have profile_index as key parameter", tostring(key_type))
	fassert((profile_index ~= 0 or not composite_keys) and not composite_keys.profile_index, "[SharedState] key type '%s' needs profile_index as key parameter", tostring(key_type))

	local career_index = arg_9_1.career_index

	fassert((career_index == 0 or not composite_keys) and composite_keys.career_index, "[SharedState] key type '%s' does not have career_index as key parameter", tostring(key_type))
	fassert((career_index ~= 0 or not composite_keys) and not composite_keys.career_index, "[SharedState] key type '%s' needs career_index as key parameter", tostring(key_type))

	local party_id = arg_9_1.party_id

	fassert((party_id == 0 or not composite_keys) and composite_keys.party_id, "[SharedState] key type '%s' does not have party_id as key parameter", tostring(key_type))
	fassert((party_id ~= 0 or not composite_keys) and not composite_keys.party_id, "[SharedState] key type '%s' needs party_id as key parameter", tostring(key_type))
end

local function fn_10(self)
	-- function 10
	local tbl = {}

	if not self.server then
		for k, v in pairs(self.server) do
			tbl[#tbl + 1] = k
		end
	end

	if not self.peer then
		for k_2, v_2 in pairs(self.peer) do
			tbl[#tbl + 1] = k_2
		end
	end

	table.sort(tbl)

	local tbl_2 = {}

	for i, v_3 in ipairs(tbl) do
		tbl_2[v_3] = i
		tbl_2[i] = v_3
	end

	return tbl_2
end

local function fn_11(arg_11_0)
	-- function 11
	local var_11_0 = type(arg_11_0)

	if not (var_11_0 == "string" or var_11_0 == "number" or var_11_0 ~= "boolean") then
		return tostring(arg_11_0)
	else
		return cjson.encode(arg_11_0)
	end
end

local printf = printf

local function fn_12(...)
	-- function 12
	local var_12_0 = sprintf(...)

	printf("[SharedState] %s", var_12_0)
end

local function fn_13(...)
	-- function 13
	if not script_data.shared_state_debug then
		local var_13_0 = sprintf(...)

		printf("[SharedState] %s", var_13_0)
	end
end

local function fn_14(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
	-- function 14
	local var_14_0 = type(arg_14_9)
	local var_14_1 = fn_6(var_14_0)

	if var_14_0 == "string" then
		local count = #arg_14_9

		if count == 0 then
			RPC[var_14_1](arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9, true)
		else
			local max_string_length = NetworkConstants.max_string_length

			for i = 1, count, max_string_length do
				local sub = arg_14_9:sub(i, i + max_string_length - 1)
				local flag = count < i + max_string_length

				RPC[var_14_1](arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, sub, flag)
			end
		end
	else
		RPC[var_14_1](arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
	end
end

local function fn_15(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8)
	-- function 15
	local var_15_0 = type(arg_15_8)
	local var_15_1 = fn_7(var_15_0)

	if var_15_0 == "string" then
		local count = #arg_15_8

		if count == 0 then
			RPC[var_15_1](arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, true)
		else
			local max_string_length = NetworkConstants.max_string_length

			for i = 1, count, max_string_length do
				local sub = arg_15_8:sub(i, i + max_string_length - 1)
				local flag = count < i + max_string_length

				RPC[var_15_1](arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, sub, flag)
			end
		end
	else
		RPC[var_15_1](arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8)
	end
end

SharedState.init = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	-- function 16
	self._original_context = arg_16_1
	self._context = tostring(HashUtils.fnv32_hash(arg_16_1))
	self._spec = arg_16_2
	self._revision = 0
	self._key_type_lookup = fn_10(arg_16_2)
	self._is_server = arg_16_3
	self._peer_state = {}
	self._server_state = {}
	self._peer_id = arg_16_6
	self._server_peer_id = arg_16_5

	if not arg_16_3 then
		self._server_full_sync_complete_mapping = {}
		self._network_server = arg_16_4
	else
		self._client_full_sync_complete = false
	end

	self._key_cache = {}
	self._callbacks = {
		server_data_updated = {},
		client_data_updated = {},
		client_left = {},
		full_sync_complete = {}
	}

	if not self._is_server then
		self._network_server:register_shared_state(self)
	end

	self:_init_immediate_initializations()
end

SharedState.register_callback = function (self, arg_17_1, arg_17_2, arg_17_3, ...)
	-- function 17
	local var_17_0 = self._callbacks[arg_17_1]

	fassert(var_17_0, "Invalid callback type %s", arg_17_1)

	local var_17_1 = var_17_0[arg_17_2]

	fassert(var_17_1 == nil, "Callback already registered on object for type '%s'", arg_17_1)

	local var_17_2
	local var_17_3 = select("#", ...)

	if var_17_3 > 0 then
		var_17_2 = {}

		for i = 1, var_17_3 do
			var_17_2[select(i, ...)] = true
		end
	end

	var_17_0[arg_17_2] = {
		func_name = arg_17_3,
		filter = var_17_2
	}
end

SharedState.unregister_callback = function (self, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = self._callbacks[arg_18_2]

	if not var_18_0 then
		return
	end

	var_18_0[arg_18_1] = nil
end

SharedState.network_context_created = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	self._peer_id = arg_19_3
	self._server_peer_id = arg_19_2
	self._is_server = arg_19_4

	if not arg_19_4 then
		self._server_full_sync_complete_mapping = {}
		self._network_server = arg_19_5
	else
		self._client_full_sync_complete = false
		self._network_server = nil
	end
end

SharedState.register_rpcs = function (self, arg_20_1)
	-- function 20
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)
	end

	self._network_event_delegate = arg_20_1

	arg_20_1:register(self, unpack(tbl))
end

SharedState.get_revision = function (self)
	-- function 21
	return self._revision
end

SharedState.clear_peer_data = function (self, arg_22_1)
	-- function 22
	if not self:_is_destroyed() then
		return
	end

	fn_13("%s: <clear_peer_data> %s", self._original_context, arg_22_1)
	self:_clear_peer_id_data(arg_22_1)

	if not self._network_server then
		local get_peers = self._network_server:get_peers()

		for i, v in ipairs(get_peers) do
			local var_22_1 = PEER_ID_TO_CHANNEL[v]

			RPC.rpc_shared_state_client_left(var_22_1, self._context, arg_22_1)
		end
	end

	self._server_full_sync_complete_mapping[arg_22_1] = nil
end

SharedState.full_sync = function (self)
	-- function 23
	if not self:_is_destroyed() then
		return
	end

	if not self._is_server then
		if not self._network_server then
			local get_peers = self._network_server:get_peers()

			for i, v in ipairs(get_peers) do
				if v ~= self._peer_id then
					local var_23_1 = PEER_ID_TO_CHANNEL[v]

					RPC.rpc_shared_state_request_sync(var_23_1, self._context)
				end
			end
		end
	else
		self._client_full_sync_complete = false

		local var_23_2 = PEER_ID_TO_CHANNEL[self._server_peer_id]

		if not var_23_2 then
			RPC.rpc_shared_state_request_sync(var_23_2, self._context)
		end
	end
end

SharedState.unregister_rpcs = function (self)
	-- function 24
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)
	end

	self._network_event_delegate = nil
end

SharedState.destroy = function (self)
	-- function 25
	self:unregister_rpcs()

	self._peer_state = nil
	self._server_state = nil
	self._context = nil
	self._is_server = nil

	if not self._is_server then
		self._network_server:deregister_shared_state(self)
	end
end

SharedState.is_peer_fully_synced = function (self, arg_26_1)
	-- function 26
	if not self._is_server then
		if not self._network_server then
			return false
		end

		if arg_26_1 ~= self._server_peer_id then
			return self._server_full_sync_complete_mapping[arg_26_1]
		else
			return true
		end
	else
		return self._client_full_sync_complete
	end
end

SharedState.get_key = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	-- function 27
	return fn_8(self._key_cache, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
end

SharedState.set_peer = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	if not self:_is_destroyed() then
		return
	end

	fassert(arg_28_3 ~= nil, "value can't be nil")

	local var_28_0 = self._spec.peer[arg_28_2.key_type]

	fassert(type(arg_28_3) == var_28_0.type, "value type is not the same as the spec defines.")
	fn_2(self._peer_state, arg_28_1, arg_28_2.key_type, arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, arg_28_3)

	if arg_28_1 == self._peer_id then
		if not var_28_0.mute_print then
			fn_13("%s: <set %s> %s:%s:%d:%d:%d:%d = %s", self._original_context, arg_28_1, arg_28_2.key_type, arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, fn_11(arg_28_3))
		end

		local encode = self._spec.peer[arg_28_2.key_type].encode
		local var_28_2

		if not encode then
			var_28_2 = encode(arg_28_3)

			if not var_28_2 then
				-- Nothing
			end
		end

		var_28_2 = arg_28_3

		::label_28_0::

		if not self._is_server then
			if not self._network_server then
				local get_peers = self._network_server:get_peers()

				for i, v in ipairs(get_peers) do
					if v ~= self._peer_id then
						local var_28_4 = PEER_ID_TO_CHANNEL[v]

						fn_14(var_28_4, self._context, self._peer_id, self._key_type_lookup[arg_28_2.key_type], arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, var_28_2)
					end
				end
			end
		else
			local var_28_5 = PEER_ID_TO_CHANNEL[self._server_peer_id]

			fn_14(var_28_5, self._context, self._peer_id, self._key_type_lookup[arg_28_2.key_type], arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, var_28_2)
		end
	elseif not var_28_0.mute_print then
		fn_13("%s: <set prediction %s> %s:%s:%d:%d:%d:%d = %s", self._original_context, arg_28_1, arg_28_2.key_type, arg_28_2.peer_id, arg_28_2.local_player_id, arg_28_2.profile_index, arg_28_2.career_index, arg_28_2.party_id, fn_11(arg_28_3))
	end

	self:_increment_revision()
end

SharedState.start_atomic_set_server = function (self, arg_29_1)
	-- function 29
	fassert(not self._current_start_atomic_set_server, "start_atomic_set_server(%s) called before calling end_atomic_set_server(%s)", arg_29_1, self._current_start_atomic_set_server)

	self._current_start_atomic_set_server = arg_29_1

	if not self._is_server then
		fn_13("%s: <atomic_set_server start> name:%s", self._original_context, arg_29_1)

		if not self._network_server then
			local get_peers = self._network_server:get_peers()

			for i, v in ipairs(get_peers) do
				if v ~= self._peer_id then
					local var_29_1 = PEER_ID_TO_CHANNEL[v]

					RPC.rpc_shared_state_start_atomic_set_server(var_29_1, self._context)
				end
			end
		end
	else
		fn_13("%s: <atomic_set_server start prediction> name:%s", self._original_context, arg_29_1)
	end
end

SharedState.end_atomic_set_server = function (self, arg_30_1)
	-- function 30
	fassert(self._current_start_atomic_set_server == arg_30_1, "mismatched end_atomic_set_server(%s) and start_atomic_set_server(%s)", arg_30_1, self._current_start_atomic_set_server)

	if not self._is_server then
		fn_13("%s: <atomic_set_server end> name:%s", self._original_context, arg_30_1)

		if not self._network_server then
			local get_peers = self._network_server:get_peers()

			for i, v in ipairs(get_peers) do
				if v ~= self._peer_id then
					local var_30_1 = PEER_ID_TO_CHANNEL[v]

					RPC.rpc_shared_state_end_atomic_set_server(var_30_1, self._context)
				end
			end
		end
	else
		fn_13("%s: <atomic_set_server end prediction> name:%s", self._original_context, arg_30_1)
	end

	self._current_start_atomic_set_server = nil
end

SharedState.set_server = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not self:_is_destroyed() then
		return
	end

	fassert(arg_31_2 ~= nil, "value can't be nil")

	local var_31_0 = self._spec.server[arg_31_1.key_type]

	fassert(type(arg_31_2) == var_31_0.type, "value type is not the same as the spec defines.")
	fn_4(self._server_state, arg_31_1.key_type, arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, arg_31_2)

	if not self._is_server then
		if not var_31_0.mute_print then
			fn_13("%s: <set server> %s:%s:%d:%d:%d:%d = %s", self._original_context, arg_31_1.key_type, arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, fn_11(arg_31_2))
		end

		local encode = self._spec.server[arg_31_1.key_type].encode
		local var_31_2

		if not encode then
			var_31_2 = encode(arg_31_2)

			if not var_31_2 then
				-- Nothing
			end
		end

		var_31_2 = arg_31_2

		::label_31_0::

		if not self._network_server then
			local get_peers = self._network_server:get_peers()

			for i, v in ipairs(get_peers) do
				if v ~= self._peer_id then
					local var_31_4 = PEER_ID_TO_CHANNEL[v]

					fn_15(var_31_4, self._context, self._key_type_lookup[arg_31_1.key_type], arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, var_31_2)
				end
			end
		end
	elseif not var_31_0.mute_print then
		fn_13("%s: <set server prediction> %s:%s:%d:%d:%d:%d = %s", self._original_context, arg_31_1.key_type, arg_31_1.peer_id, arg_31_1.local_player_id, arg_31_1.profile_index, arg_31_1.career_index, arg_31_1.party_id, fn_11(arg_31_2))
	end

	self:_increment_revision()
end

SharedState.set_own = function (self, arg_32_1, arg_32_2)
	-- function 32
	self:set_peer(self._peer_id, arg_32_1, arg_32_2)
end

SharedState.get_peer = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not self:_is_destroyed() then
		return self._spec.peer[arg_33_2.key_type].default_value
	end

	return fn_3(self._peer_state, arg_33_1, arg_33_2.key_type, arg_33_2.peer_id, arg_33_2.local_player_id, arg_33_2.profile_index, arg_33_2.career_index, arg_33_2.party_id) or self._spec.peer[arg_33_2.key_type].default_value
end

SharedState.get_own = function (self, arg_34_1)
	-- function 34
	return self:get_peer(self._peer_id, arg_34_1)
end

SharedState.get_server = function (self, arg_35_1)
	-- function 35
	if not self:_is_destroyed() then
		return self._spec.server[arg_35_1.key_type].default_value
	end

	return fn_5(self._server_state, arg_35_1.key_type, arg_35_1.peer_id, arg_35_1.local_player_id, arg_35_1.profile_index, arg_35_1.career_index, arg_35_1.party_id) or self._spec.server[arg_35_1.key_type].default_value
end

SharedState.rpc_shared_state_request_sync = function (self, arg_36_1, arg_36_2)
	-- function 36
	if not self:_is_destroyed() then
		return nil
	end

	if arg_36_2 ~= self._context then
		return
	end

	if not self._is_server then
		for k, v in pairs(self._server_state) do
			for k_2, v_2 in pairs(v) do
				for k_3, v_3 in pairs(v_2) do
					for k_4, v_4 in pairs(v_3) do
						for k_5, v_5 in pairs(v_4) do
							for k_6, v_6 in pairs(v_5) do
								local encode = self._spec.server[k].encode
								local var_36_1

								if not encode then
									var_36_1 = encode(v_6)

									if not var_36_1 then
										-- Nothing
									end
								end

								var_36_1 = v_6

								::label_36_0::

								fn_15(arg_36_1, self._context, self._key_type_lookup[k], k_2, k_3, k_4, k_5, k_6, var_36_1)
							end
						end
					end
				end
			end
		end

		local var_36_2 = CHANNEL_TO_PEER_ID[arg_36_1]

		for k_7, v_7 in pairs(self._peer_state) do
			if k_7 ~= var_36_2 then
				self:_send_all(arg_36_1, k_7, v_7)
			end
		end

		RPC.rpc_shared_state_full_sync_complete(arg_36_1, self._context)

		self._server_full_sync_complete_mapping[var_36_2] = true
	else
		local peer_id = Network.peer_id()
		local var_36_4 = self._peer_state[peer_id]

		if not var_36_4 then
			self:_send_all(arg_36_1, peer_id, var_36_4)
		end
	end
end

SharedState.rpc_shared_state_full_sync_complete = function (self, arg_37_1, arg_37_2)
	-- function 37
	if not self:_is_destroyed() then
		return
	end

	if arg_37_2 ~= self._context then
		return
	end

	self._client_full_sync_complete = true

	local full_sync_complete = self._callbacks.full_sync_complete

	for k, v in pairs(full_sync_complete) do
		k[v.func_name](k, peer_id)
	end
end

SharedState.rpc_shared_state_set_int = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8, arg_38_9, arg_38_10)
	-- function 38
	if not self:_is_destroyed() then
		return
	end

	if arg_38_2 ~= self._context then
		return
	end

	self:_set_rpc(arg_38_1, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8, arg_38_9, arg_38_10)
end

SharedState.rpc_shared_state_set_string = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10, arg_39_11)
	-- function 39
	if not self:_is_destroyed() then
		return
	end

	if arg_39_2 ~= self._context then
		return
	end

	if not self._batched_string_buffer then
		self._batched_string_buffer[#self._batched_string_buffer + 1] = arg_39_10

		if not arg_39_11 then
			local concat = table.concat(self._batched_string_buffer, "")

			self:_set_rpc(arg_39_1, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, concat)

			self._batched_string_buffer = nil
		end
	elseif not arg_39_11 then
		self:_set_rpc(arg_39_1, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10)
	else
		self._batched_string_buffer = {
			arg_39_10
		}
	end
end

SharedState.rpc_shared_state_set_bool = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7, arg_40_8, arg_40_9, arg_40_10)
	-- function 40
	if not self:_is_destroyed() then
		return
	end

	if arg_40_2 ~= self._context then
		return
	end

	self:_set_rpc(arg_40_1, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7, arg_40_8, arg_40_9, arg_40_10)
end

SharedState.rpc_shared_state_set_server_int = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9)
	-- function 41
	if not self:_is_destroyed() then
		return
	end

	if arg_41_2 ~= self._context then
		return
	end

	self:_set_server_rpc(arg_41_1, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9)
end

SharedState.rpc_shared_state_set_server_string = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9, arg_42_10)
	-- function 42
	if not self:_is_destroyed() then
		return
	end

	if arg_42_2 ~= self._context then
		return
	end

	if not self._batched_string_buffer then
		self._batched_string_buffer[#self._batched_string_buffer + 1] = arg_42_9

		if not arg_42_10 then
			local concat = table.concat(self._batched_string_buffer, "")

			self:_set_server_rpc(arg_42_1, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, concat)

			self._batched_string_buffer = nil
		end
	elseif not arg_42_10 then
		self:_set_server_rpc(arg_42_1, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9)
	else
		self._batched_string_buffer = {
			arg_42_9
		}
	end
end

SharedState.rpc_shared_state_set_server_bool = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9)
	-- function 43
	if not self:_is_destroyed() then
		return
	end

	if arg_43_2 ~= self._context then
		return
	end

	self:_set_server_rpc(arg_43_1, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9)
end

SharedState.rpc_shared_state_client_left = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	if not self:_is_destroyed() then
		return
	end

	if arg_44_2 ~= self._context then
		return
	end

	fn_13("%s: <rpc client left> %s", self._original_context, arg_44_3)
	self:_clear_peer_id_data(arg_44_3)

	local client_left = self._callbacks.client_left

	for k, v in pairs(client_left) do
		if not v.filter and not v.filter[arg_44_3] then
			k[v.func_name](k, arg_44_3)
		end
	end
end

SharedState._set_rpc = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9)
	-- function 45
	local var_45_0 = self._key_type_lookup[arg_45_3]
	local var_45_1 = self._spec.peer[var_45_0]
	local decode = var_45_1.decode
	local var_45_3

	if not decode then
		var_45_3 = decode(arg_45_9)

		if not var_45_3 then
			-- Nothing
		end
	end

	var_45_3 = arg_45_9

	::label_45_0::

	if not var_45_1.mute_print then
		fn_13("%s: <rpc set %s> %s:%s:%d:%d:%d:%d = %s", self._original_context, arg_45_2, var_45_0, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, fn_11(var_45_3))
	end

	fn_2(self._peer_state, arg_45_2, var_45_0, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, var_45_3)

	if not self._is_server then
		local var_45_4 = CHANNEL_TO_PEER_ID[arg_45_1]

		if not self._network_server then
			local get_peers = self._network_server:get_peers()

			for i, v in ipairs(get_peers) do
				if not (v == var_45_4 or v == self._peer_id) then
					local var_45_6 = PEER_ID_TO_CHANNEL[v]

					fn_14(var_45_6, self._context, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9)
				end
			end
		end
	end

	self:_increment_revision()

	local client_data_updated = self._callbacks.client_data_updated

	for k, v_2 in pairs(client_data_updated) do
		if not v_2.filter and not v_2.filter[var_45_0] then
			k[v_2.func_name](k, arg_45_2, var_45_0, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, var_45_3)
		end
	end
end

SharedState._set_server_rpc = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8)
	-- function 46
	local _atomic_set_server_cache = self._atomic_set_server_cache

	if not _atomic_set_server_cache then
		local count = #_atomic_set_server_cache

		_atomic_set_server_cache[count] = arg_46_1
		_atomic_set_server_cache[count + 1] = arg_46_2
		_atomic_set_server_cache[count + 2] = arg_46_3
		_atomic_set_server_cache[count + 3] = arg_46_4
		_atomic_set_server_cache[count + 4] = arg_46_5
		_atomic_set_server_cache[count + 5] = arg_46_6
		_atomic_set_server_cache[count + 6] = arg_46_7
		_atomic_set_server_cache[count + 7] = arg_46_8

		return
	end

	local var_46_2 = self._key_type_lookup[arg_46_2]
	local var_46_3 = self._spec.server[var_46_2]
	local decode = var_46_3.decode
	local var_46_5

	if not decode then
		var_46_5 = decode(arg_46_8)

		if not var_46_5 then
			-- Nothing
		end
	end

	var_46_5 = arg_46_8

	::label_46_0::

	if not var_46_3.mute_print then
		fn_13("%s: <rpc set server> %s:%s:%d:%d:%d:%d = %s", self._original_context, var_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, fn_11(var_46_5))
	end

	fn_4(self._server_state, var_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, var_46_5)
	self:_increment_revision()

	local server_data_updated = self._callbacks.server_data_updated

	for k, v in pairs(server_data_updated) do
		if not v.filter and not v.filter[var_46_2] then
			k[v.func_name](k, var_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, var_46_5)
		end
	end
end

SharedState._send_all = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	for k, v in pairs(arg_47_3) do
		for k_2, v_2 in pairs(v) do
			for k_3, v_3 in pairs(v_2) do
				for k_4, v_4 in pairs(v_3) do
					for k_5, v_5 in pairs(v_4) do
						for k_6, v_6 in pairs(v_5) do
							local encode = self._spec.peer[k].encode
							local var_47_1

							if not encode then
								var_47_1 = encode(v_6)

								if not var_47_1 then
									-- Nothing
								end
							end

							var_47_1 = v_6

							::label_47_0::

							fn_14(arg_47_1, self._context, arg_47_2, self._key_type_lookup[k], k_2, k_3, k_4, k_5, k_6, var_47_1)
						end
					end
				end
			end
		end
	end
end

SharedState._clear_peer_id_data = function (self, arg_48_1)
	-- function 48
	for k, v in pairs(self._spec.server) do
		if not v.clear_when_peer_id_leaves then
			local var_48_0 = self._server_state[k]

			if not var_48_0 then
				var_48_0[arg_48_1] = nil
			end
		end
	end

	self._peer_state[arg_48_1] = nil

	for k_2, v_2 in pairs(self._spec.peer) do
		if not v_2.clear_when_peer_id_leaves then
			for k_3, v_3 in pairs(self._peer_state) do
				local var_48_1 = v_3[k_2]

				if not var_48_1 then
					var_48_1[arg_48_1] = nil
				end
			end
		end
	end

	self:_increment_revision()
end

SharedState.has_peer_state = function (self, arg_49_1, arg_49_2)
	-- function 49
	local var_49_0 = self._peer_state[arg_49_1]

	return not var_49_0 and var_49_0[arg_49_2]
end

SharedState._is_destroyed = function (self)
	-- function 50
	return self._server_state == nil
end

SharedState._increment_revision = function (self)
	-- function 51
	local _revision = self._revision

	self._revision = self._revision + 1

	if self._revision == _revision then
		fn_13("%s: revision reset back to zero", self._original_context)

		self._revision = 0
	end
end

SharedState.rpc_shared_state_start_atomic_set_server = function (self, arg_52_1)
	-- function 52
	if not self:_is_destroyed() then
		return
	end

	if arg_52_1 ~= self._context then
		return
	end

	self._atomic_set_server_cache = {}
end

SharedState.rpc_shared_state_end_atomic_set_server = function (self, arg_53_1)
	-- function 53
	if not self:_is_destroyed() then
		return
	end

	if arg_53_1 ~= self._context then
		return
	end

	local _atomic_set_server_cache = self._atomic_set_server_cache

	fassert(_atomic_set_server_cache, "rpc_shared_state_end_atomic_set_server received when rpc_shared_state_start_atomic_set_server had not been called before")

	for i = 1, #_atomic_set_server_cache, 7 do
		local var_53_1 = _atomic_set_server_cache[i]
		local var_53_2 = _atomic_set_server_cache[i + 1]
		local var_53_3 = _atomic_set_server_cache[i + 2]
		local var_53_4 = _atomic_set_server_cache[i + 3]
		local var_53_5 = _atomic_set_server_cache[i + 4]
		local var_53_6 = _atomic_set_server_cache[i + 5]
		local var_53_7 = _atomic_set_server_cache[i + 6]
		local var_53_8 = _atomic_set_server_cache[i + 7]

		self:_set_server_rpc(var_53_1, var_53_2, var_53_3, var_53_4, var_53_5, var_53_6, var_53_7, var_53_8)
	end
end

local function fn_16(arg_54_0)
	-- function 54
	for k, v in pairs(arg_54_0) do
		fassert(v.type, "spec %s invalid, missing type", k)
		fassert(v.default_value ~= nil, "spec %s invalid, missing default_value", k)
		fassert(type(v.default_value) == v.type, "spec %s invalid, missing default_value", k)

		if v.type == "table" then
			local fassert = fassert
			local decode = v.decode

			decode = not decode and v.encode

			fassert(decode, "spec %s invalid, must provide decode and encode method with table type", k)
		end

		fassert(v.composite_keys, "spec %s invalid, missing composite_keys", k)

		for k_2, v_2 in pairs(v.composite_keys) do
			fassert(k_2 == "peer_id" or k_2 == "local_player_id" or k_2 == "profile_index" or k_2 == "career_index" or k_2 == "party_id", "spec %s invalid, invalid key_param %s, must be one of peer_id, local_player_id, profile_index, career_index, party_id", k)
		end

		local fassert_2 = fassert
		local clear_when_peer_id_leaves

		if not v.clear_when_peer_id_leaves then
			clear_when_peer_id_leaves = v.clear_when_peer_id_leaves

			if not clear_when_peer_id_leaves then
				clear_when_peer_id_leaves = v.composite_keys.peer_id
			end

			if false then
				clear_when_peer_id_leaves = false
			end
		else
			clear_when_peer_id_leaves = true
		end

		fassert_2(clear_when_peer_id_leaves, "Faulty use of 'clear_when_peer_id_leaves'. Can not deduce when to clear value if peer_id is not part of composite keys.")
	end
end

SharedState.validate_spec = function (self)
	-- function 55
	fassert(self, "spec invalid, nil")
	fassert(self.peer, "spec invalid, missing peer spec")
	fassert(self.server, "spec invalid, missing server spec")
	fn_16(self.peer)
	fn_16(self.server)
end

SharedState._init_immediate_initializations = function (self)
	-- function 56
	local peer = self._spec.peer
	local server = self._spec.server
	local _is_server = self._is_server
	local _peer_id = self._peer_id
	local _key_type_lookup = self._key_type_lookup

	for i = 1, #_key_type_lookup do
		local var_56_5 = _key_type_lookup[i]
		local var_56_6 = peer[var_56_5]

		if not var_56_6 then
			local immediate_initialization = var_56_6.immediate_initialization

			if not immediate_initialization then
				local var_56_8, var_56_9 = immediate_initialization(self, _peer_id)

				self:set_own(var_56_8, var_56_9)
			end
		elseif not _is_server then
			local immediate_initialization_2 = server[var_56_5].immediate_initialization

			if not immediate_initialization_2 then
				local var_56_11, var_56_12 = immediate_initialization_2(self, _peer_id)

				self:set_server(var_56_11, var_56_12)
			end
		end
	end
end
