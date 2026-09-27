-- chunkname: @scripts/network/network_match_handler.lua

NetworkMatchHandler = class(NetworkMatchHandler)

local tbl = {
	leader_peer_id = "",
	player_name = "",
	is_dedicated_server = false,
	is_synced = false,
	versus_level = 1,
	is_match_owner = false
}
local tbl_2 = {
	"rpc_network_match_sync_player_data",
	"rpc_network_match_changed",
	"rpc_network_match_request_sync"
}
local flag = true

NetworkMatchHandler.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._network_handler = arg_1_1
	self._is_server = arg_1_2
	self._my_peer_id = arg_1_3
	self._server_peer_id = arg_1_4
	self._stored_data = {}
	self._lobby = arg_1_5

	local tbl = {}
	local var_1_1 = self
	local _create_data = self._create_data
	local tbl_2 = {
		is_synced = true,
		is_dedicated_server = DEDICATED_SERVER
	}
	local player_name

	if not DEDICATED_SERVER then
		player_name = PlayerUtils.player_name(arg_1_3, arg_1_5)

		if not player_name then
			-- Nothing
		end
	end

	player_name = nil

	::label_1_0::

	tbl_2.player_name = player_name
	tbl_2.leader_peer_id = self._server_peer_id
	tbl_2.is_match_owner = not arg_1_2 and true

	local get_versus_level

	if not DEDICATED_SERVER then
		get_versus_level = ExperienceSettings.get_versus_level()

		if not get_versus_level then
			-- Nothing
		end
	end

	get_versus_level = nil

	::label_1_1::

	tbl_2.versus_level = get_versus_level
	tbl[arg_1_3] = _create_data(var_1_1, tbl_2)
	self._data_by_peer = tbl

	if not arg_1_2 then
		self._data_by_peer[arg_1_4] = self:_create_data({
			is_match_owner = true,
			leader_peer_id = arg_1_4
		})
		self._pending_initial_sync = true

		self:_request_sync()
	end
end

NetworkMatchHandler.server_created = function (self, arg_2_1)
	-- function 2
	Managers.persistent_event:trigger("new_network_match_synced", self._is_server, arg_2_1)
end

NetworkMatchHandler.register_pending_peer = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = PEER_ID_TO_CHANNEL[arg_3_1]
	local _data_by_peer = self._data_by_peer
	local _try_unstore_data = self:_try_unstore_data(arg_3_1)

	_try_unstore_data = _try_unstore_data or self:_create_data()
	_data_by_peer[arg_3_1] = _try_unstore_data
	self._data_by_peer[arg_3_1].leader_peer_id = arg_3_2

	printf("[NetworkMatchHandler] Registering pending peer %s with leader %s", arg_3_1, arg_3_2)
	self:sync_data_down_to(arg_3_1)

	if arg_3_2 == self._my_peer_id then
		RPC.rpc_network_match_request_sync(var_3_0)
	elseif not PEER_ID_TO_CHANNEL[arg_3_2] then
		local var_3_3 = PEER_ID_TO_CHANNEL[arg_3_2]

		RPC.rpc_network_match_request_sync(var_3_3)
	else
		printf("[NetworkMatchHandler] Failed to sync client %s because of no longer holding a connection to their leader %s", arg_3_1, arg_3_2)
	end
end

NetworkMatchHandler.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._network_event_delegate = arg_4_1
	self._network_transmit = arg_4_2

	arg_4_1:register(self, unpack(tbl_2))
end

NetworkMatchHandler.unregister_rpcs = function (self)
	-- function 5
	self._network_event_delegate:unregister(self)
end

NetworkMatchHandler.poll_propagation_peer = function (self)
	-- function 6
	assert(self._is_server, "[NetworkMatchHandler] Only lobby hosts may propagate to another lobby host")

	local var_6_0
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		var_6_0 = query_lobby:lobby_host()
	end

	local _join_lobby_peer_id = self._join_lobby_peer_id
	local flag = var_6_0 ~= _join_lobby_peer_id

	if var_6_0 ~= nil or not PEER_ID_TO_CHANNEL[_join_lobby_peer_id] then
		flag = false
	end

	if not flag then
		printf("[NetworkMatchHandler] Join lobby peer changed. Old: %s, New: %s", _join_lobby_peer_id, var_6_0)

		self._join_lobby_peer_id = var_6_0

		if not _join_lobby_peer_id then
			self:_clear_non_session_peers()
		end

		self:_network_match_changed(var_6_0)

		if not var_6_0 then
			self:sync_data_up()
			self:_request_sync()
		elseif _join_lobby_peer_id == self._propagate_peer_id then
			self._propagate_peer_id = nil
		end
	end
end

NetworkMatchHandler.rpc_network_match_sync_player_data = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]
	local _try_unstore_data = self:_try_unstore_data(arg_7_2)

	_try_unstore_data = _try_unstore_data or self:_create_data()
	self._data_by_peer[arg_7_2] = _try_unstore_data
	_try_unstore_data.player_name = arg_7_3
	_try_unstore_data.leader_peer_id = arg_7_4
	_try_unstore_data.versus_level = arg_7_6
	_try_unstore_data.is_match_owner = arg_7_5
	_try_unstore_data.is_synced = true

	if arg_7_2 == self._join_lobby_peer_id then
		if not arg_7_5 then
			self._propagate_peer_id = arg_7_2
		else
			self._data_by_peer[self._my_peer_id].leader_peer_id = arg_7_2
		end
	end

	if not flag then
		printf("[NetworkMatchHandler] Sync data received from peer %s for peer %s (%s). has_leader=%s, is_match_owner=%s", var_7_0, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	end

	local var_7_2 = CHANNEL_TO_PEER_ID[arg_7_1]

	self:propagate_rpc("rpc_network_match_sync_player_data", var_7_2, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)

	if not self._pending_initial_sync then
		self._pending_initial_sync = false

		Managers.persistent_event:trigger("new_network_match_synced", self._is_server, self._my_peer_id)
	end
end

NetworkMatchHandler.rpc_network_match_changed = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:_clear_non_session_peers()
	self:_network_match_changed(arg_8_2)
	self:send_rpc_down("rpc_network_match_changed", arg_8_2)
end

NetworkMatchHandler._network_match_changed = function (self, arg_9_1)
	-- function 9
	printf("[NetworkMatchHandler] Network match changed. New match owner: %s", arg_9_1)

	for k, v in pairs(self._data_by_peer) do
		v.is_match_owner = false
	end

	if not arg_9_1 then
		self._data_by_peer[arg_9_1] = self:_create_data({
			is_match_owner = true,
			leader_peer_id = arg_9_1
		})

		self:_request_sync()
	elseif not self._is_server then
		self._data_by_peer[self._my_peer_id].is_match_owner = true
	else
		self._data_by_peer[self._server_peer_id].is_match_owner = true
	end

	if not self._is_server then
		self:send_rpc_down("rpc_network_match_changed", arg_9_1 or self._my_peer_id)
	end

	Managers.persistent_event:trigger("network_match_changed", arg_9_1)
end

NetworkMatchHandler.rpc_network_match_request_sync = function (self, arg_10_1)
	-- function 10
	local var_10_0 = CHANNEL_TO_PEER_ID[arg_10_1]

	printf("[NetworkMatchHandler] Peer %s requested sync", var_10_0)

	if not flag then
		printf("[NetworkMatchHandler] Own data:\n%s", table.tostring(self._data_by_peer))
	end

	local var_10_1 = self._data_by_peer[var_10_0]

	if not var_10_1 then
		return
	end

	if not var_10_1.is_match_owner then
		self:sync_data_up()

		return
	end

	local _my_peer_id = self._my_peer_id
	local var_10_3 = self._data_by_peer[_my_peer_id]

	if not var_10_3.is_match_owner then
		self:sync_data_down_to(var_10_0)

		return
	elseif var_10_3.leader_peer_id == var_10_0 then
		self:sync_data_up()

		return
	elseif var_10_1.leader_peer_id == _my_peer_id then
		self:sync_data_down_to(var_10_0)
	else
		self:sync_data_to(var_10_0)
	end
end

NetworkMatchHandler._request_sync = function (self)
	-- function 11
	printf("[NetworkMatchHandler] Requesting sync.")
	self:send_rpc_up("rpc_network_match_request_sync")
end

NetworkMatchHandler.get_match_owner = function (self)
	-- function 12
	for k, v in pairs(self._data_by_peer) do
		if not v.is_match_owner then
			return k
		end
	end
end

NetworkMatchHandler.is_match_owner = function (self)
	-- function 13
	return self:get_match_owner() == self._my_peer_id
end

NetworkMatchHandler.is_leader = function (self, arg_14_1)
	-- function 14
	local flag = arg_14_1 or self._my_peer_id

	return self:query_peer_data(flag, "leader_peer_id") == flag
end

NetworkMatchHandler.synced_peers = function (self)
	-- function 15
	return table.keys_if(self._data_by_peer, function (arg_16_0, arg_16_1)
		-- function 16
		return arg_16_1.is_synced
	end)
end

NetworkMatchHandler.sync_data_up = function (self)
	-- function 17
	local _my_peer_id = self._my_peer_id

	for k, v in pairs(self._data_by_peer) do
		if not (v.leader_peer_id == _my_peer_id or k ~= _my_peer_id) then
			local player_name = v.player_name
			local leader_peer_id = v.leader_peer_id
			local is_match_owner = v.is_match_owner

			self:send_rpc_up("rpc_network_match_sync_player_data", k, player_name, leader_peer_id, is_match_owner, v.versus_level)
		end
	end
end

NetworkMatchHandler.sync_data_down = function (self)
	-- function 18
	for k, v in pairs(self._data_by_peer) do
		local player_name = v.player_name
		local leader_peer_id = v.leader_peer_id
		local is_match_owner = v.is_match_owner

		self:send_rpc_down_except("rpc_network_match_sync_player_data", k, k, player_name, leader_peer_id, is_match_owner, v.versus_level)
	end
end

NetworkMatchHandler.sync_data_down_to = function (self, arg_19_1)
	-- function 19
	local var_19_0 = PEER_ID_TO_CHANNEL[arg_19_1]

	if not var_19_0 then
		return
	end

	for k, v in pairs(self._data_by_peer) do
		if k ~= arg_19_1 then
			local player_name = v.player_name
			local leader_peer_id = v.leader_peer_id
			local is_match_owner = v.is_match_owner

			RPC.rpc_network_match_sync_player_data(var_19_0, k, player_name, leader_peer_id, is_match_owner, v.versus_level)
		end
	end
end

NetworkMatchHandler.sync_data_to = function (self, arg_20_1)
	-- function 20
	local var_20_0 = PEER_ID_TO_CHANNEL[arg_20_1]
	local var_20_1 = self._data_by_peer[self._my_peer_id]

	RPC.rpc_network_match_sync_player_data(var_20_0, self._my_peer_id, var_20_1.player_name, var_20_1.leader_peer_id, var_20_1.is_match_owner, var_20_1.versus_level)
end

NetworkMatchHandler.send_rpc_up = function (self, arg_21_1, ...)
	-- function 21
	if self._server_peer_id ~= self._my_peer_id then
		local var_21_0 = PEER_ID_TO_CHANNEL[self._server_peer_id]

		if not var_21_0 then
			RPC[arg_21_1](var_21_0, ...)
		end
	elseif not self._propagate_peer_id then
		local var_21_1 = PEER_ID_TO_CHANNEL[self._propagate_peer_id]

		if not var_21_1 then
			RPC[arg_21_1](var_21_1, ...)
		end
	end
end

NetworkMatchHandler.can_propagate = function (self)
	-- function 22
	return self._propagate_peer_id
end

NetworkMatchHandler.send_rpc_others = function (self, arg_23_1, ...)
	-- function 23
	self:send_rpc_up(arg_23_1, ...)
	self:send_rpc_down(arg_23_1, ...)
end

NetworkMatchHandler.send_rpc = function (arg_24_0, arg_24_1, arg_24_2, ...)
	-- function 24
	local var_24_0 = PEER_ID_TO_CHANNEL[arg_24_2]

	RPC[arg_24_1](var_24_0, ...)
end

NetworkMatchHandler.send_rpc_down = function (self, arg_25_1, ...)
	-- function 25
	self:send_rpc_down_except(arg_25_1, nil, ...)
end

NetworkMatchHandler.send_rpc_down_except = function (self, arg_26_1, arg_26_2, ...)
	-- function 26
	local _my_peer_id = self._my_peer_id
	local is_match_owner = self._data_by_peer[_my_peer_id].is_match_owner

	for k, v in pairs(self._data_by_peer) do
		if k == arg_26_2 or k == _my_peer_id or v.leader_peer_id == _my_peer_id or v.leader_peer_id ~= k or not is_match_owner then
			local var_26_2 = PEER_ID_TO_CHANNEL[k]

			if not var_26_2 then
				RPC[arg_26_1](var_26_2, ...)
			end
		end
	end
end

NetworkMatchHandler.send_rpc_down_except_if = function (self, arg_27_1, arg_27_2, arg_27_3, ...)
	-- function 27
	local _my_peer_id = self._my_peer_id
	local is_match_owner = self._data_by_peer[_my_peer_id].is_match_owner

	for k, v in pairs(self._data_by_peer) do
		if k == arg_27_2 or not arg_27_3(k) and k == _my_peer_id and v.leader_peer_id == _my_peer_id and v.leader_peer_id ~= k or not is_match_owner then
			local var_27_2 = PEER_ID_TO_CHANNEL[k]

			if not var_27_2 then
				RPC[arg_27_1](var_27_2, ...)
			end
		end
	end
end

NetworkMatchHandler.send_rpc_down_if = function (self, arg_28_1, arg_28_2, ...)
	-- function 28
	local _my_peer_id = self._my_peer_id
	local is_match_owner = self._data_by_peer[_my_peer_id].is_match_owner

	for k, v in pairs(self._data_by_peer) do
		if not arg_28_2(k) and k == _my_peer_id and v.leader_peer_id == _my_peer_id and v.leader_peer_id ~= k or not is_match_owner then
			local var_28_2 = PEER_ID_TO_CHANNEL[k]

			if not var_28_2 then
				RPC[arg_28_1](var_28_2, ...)
			end
		end
	end
end

NetworkMatchHandler.propagate_rpc = function (self, arg_29_1, arg_29_2, ...)
	-- function 29
	if not self._propagate_peer_id then
		if self._propagate_peer_id == arg_29_2 then
			self:send_rpc_down(arg_29_1, ...)

			return
		end

		self:send_rpc_up(arg_29_1, ...)
	end

	if not self._is_server then
		self:send_rpc_down_except(arg_29_1, arg_29_2, ...)
	end
end

NetworkMatchHandler.propagate_rpc_if = function (self, arg_30_1, arg_30_2, arg_30_3, ...)
	-- function 30
	if not self._propagate_peer_id then
		if self._propagate_peer_id == arg_30_2 then
			self:send_rpc_down_if(arg_30_1, arg_30_3, ...)

			return
		end

		self:send_rpc_up(arg_30_1, ...)
	end

	if not self._is_server then
		self:send_rpc_down_except_if(arg_30_1, arg_30_2, arg_30_3, ...)
	end
end

NetworkMatchHandler._clear_non_session_peers = function (self)
	-- function 31
	local members_map = self._lobby:members():members_map()

	for k in pairs(self._data_by_peer) do
		if not members_map[k] then
			self._data_by_peer[k] = nil
		end
	end
end

NetworkMatchHandler.client_disconnected = function (self, arg_32_1)
	-- function 32
	if not self._data_by_peer[arg_32_1] then
		self:_store_data(arg_32_1)
	end
end

NetworkMatchHandler.has_peer_data = function (self, arg_33_1)
	-- function 33
	return self._data_by_peer[arg_33_1]
end

NetworkMatchHandler.query_peer_data = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local var_34_0 = self._data_by_peer[arg_34_1]

	if not var_34_0 then
		return var_34_0[arg_34_2]
	end

	local default_data

	if not arg_34_3 then
		default_data = self:default_data(arg_34_2)

		if not default_data then
			-- Nothing
		end
	end

	default_data = nil

	::label_34_0::

	return default_data
end

NetworkMatchHandler.default_data = function (arg_35_0, arg_35_1)
	-- function 35
	return tbl[arg_35_1]
end

NetworkMatchHandler._try_unstore_data = function (self, arg_36_1)
	-- function 36
	local var_36_0 = self._stored_data[arg_36_1]

	self._stored_data[arg_36_1] = nil

	return var_36_0 or self._data_by_peer[arg_36_1]
end

NetworkMatchHandler._store_data = function (self, arg_37_1)
	-- function 37
	local var_37_0 = self._data_by_peer[arg_37_1]

	var_37_0.is_synced = tbl.is_synced
	var_37_0.is_match_owner = tbl.is_match_owner
	var_37_0.leader_peer_id = tbl.leader_peer_id
	self._stored_data[arg_37_1] = var_37_0
	self._data_by_peer[arg_37_1] = nil
end

NetworkMatchHandler._create_data = function (arg_38_0, arg_38_1)
	-- function 38
	local shallow_copy = table.shallow_copy(tbl)

	if not arg_38_1 then
		table.merge(shallow_copy, arg_38_1)
	end

	return shallow_copy
end

NetworkMatchHandler.destroy = function (arg_39_0)
	-- function 39
	Managers.persistent_event:trigger("network_match_terminated")
end
