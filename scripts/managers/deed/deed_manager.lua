-- chunkname: @scripts/managers/deed/deed_manager.lua

DeedManager = class(DeedManager)

local tbl = {
	"rpc_select_deed",
	"rpc_reset_deed",
	"rpc_deed_consumed"
}

DeedManager.init = function (self)
	-- function 1
	self._selected_deed_data = nil
	self._selected_deed_id = nil
	self._owner_peer_id = nil
end

DeedManager.destroy = function (self)
	-- function 2
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

DeedManager.network_context_created = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	self._lobby = arg_3_1
	self._server_peer_id = arg_3_2
	self._peer_id = arg_3_3
	self._network_server = not arg_3_4 and arg_3_5 and nil
	self._is_server = arg_3_4

	local flag = true

	self:reset(flag)
end

DeedManager.network_context_destroyed = function (self)
	-- function 4
	self._lobby = nil
	self._server_peer_id = nil
	self._peer_id = nil
	self._network_server = nil
	self._is_server = false

	local flag = true

	self:reset(flag)
end

DeedManager.register_rpcs = function (self, arg_5_1)
	-- function 5
	arg_5_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_5_1
end

DeedManager.unregister_rpcs = function (self)
	-- function 6
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

DeedManager.reset = function (self, arg_7_1)
	-- function 7
	self._selected_deed_data = nil
	self._selected_deed_id = nil
	self._owner_peer_id = nil
	self._deed_session_faulty = nil

	if not (not self._is_server and arg_7_1) then
		self:_send_rpc_to_clients("rpc_reset_deed")
	end
end

DeedManager.mutators = function (self)
	-- function 8
	if not self._selected_deed_data then
		return self._selected_deed_data.mutators
	else
		return nil
	end
end

DeedManager.rewards = function (self)
	-- function 9
	if not self._selected_deed_data then
		return self._selected_deed_data.rewards
	else
		return nil
	end
end

DeedManager.has_deed = function (self)
	-- function 10
	return self._selected_deed_data ~= nil
end

DeedManager.active_deed = function (self)
	-- function 11
	fassert(self._selected_deed_data, "Has no active deed")

	return self._selected_deed_data, self._selected_deed_id
end

DeedManager.is_deed_owner = function (self, arg_12_1)
	-- function 12
	arg_12_1 = arg_12_1 or self._peer_id

	return self._owner_peer_id == arg_12_1
end

DeedManager.is_session_faulty = function (self)
	-- function 13
	return self._deed_session_faulty
end

DeedManager.consume_deed = function (self, arg_14_1)
	-- function 14
	print("[DeedManager]:consume_deed()")

	if self._owner_peer_id == self._peer_id then
		local network = Managers.state.network

		if not network and not network:game() then
			if not self._is_server then
				self:_send_rpc_to_clients("rpc_deed_consumed")
			else
				self:_send_rpc_to_server("rpc_deed_consumed")
			end
		end
	elseif not self._has_consumed_deed then
		self._has_consumed_deed = nil
		self._reward_callback = arg_14_1

		self:_use_reward_callback()
	else
		self._reward_callback = arg_14_1
	end
end

DeedManager.hot_join_sync = function (self, arg_15_1)
	-- function 15
	if not self:has_deed() then
		return
	end

	local _selected_deed_data = self._selected_deed_data
	local _owner_peer_id = self._owner_peer_id
	local var_15_2 = NetworkLookup.item_names[_selected_deed_data.name]

	self:_send_rpc_to_client("rpc_select_deed", arg_15_1, var_15_2, _owner_peer_id)
end

DeedManager.delete_marked_deeds = function (self, arg_16_1)
	-- function 16
	local get_interface = Managers.backend:get_interface("items")

	get_interface:delete_marked_deeds(arg_16_1)

	local is_deleting_deeds = get_interface:is_deleting_deeds()

	self._is_deleting_deeds = is_deleting_deeds

	return is_deleting_deeds
end

DeedManager.is_deleting_deeds = function (self)
	-- function 17
	local flag

	flag = not self._is_deleting_deeds and true and false

	return flag
end

DeedManager._update_deed_deletion = function (self)
	-- function 18
	if not (not self._is_deleting_deeds and Managers.backend:get_interface("items"):is_deleting_deeds()) then
		self._is_deleting_deeds = nil
	end
end

DeedManager.can_delete_deeds = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local can_delete_deeds, var_19_1, var_19_2 = Managers.backend:get_interface("items"):can_delete_deeds(arg_19_1, arg_19_2)
	local var_19_3
	local var_19_4
	local flag = not arg_19_2 and #arg_19_2 and 0
	local flag_2 = not var_19_2 and #var_19_2 and 0

	if not (not can_delete_deeds and flag_2 == flag) then
		return var_19_1, var_19_2, "Not all marked deeds could be deleted."
	end

	if not can_delete_deeds then
		return nil, nil, "No deeds could be deleted!"
	end

	return var_19_1, var_19_2, nil
end

DeedManager.update = function (self, arg_20_1)
	-- function 20
	if not self:has_deed() then
		self:_update_owner(arg_20_1)
	end

	self:_update_deed_deletion()
end

DeedManager.select_deed = function (self, arg_21_1, arg_21_2)
	-- function 21
	local data = Managers.backend:get_interface("items"):get_item_from_id(arg_21_1).data

	self._selected_deed_data = data
	self._selected_deed_id = arg_21_1
	self._owner_peer_id = arg_21_2
	self._deed_session_faulty = false

	local network = Managers.state.network

	if not network and not network:game() then
		local var_21_2 = NetworkLookup.item_names[data.name]

		if not self._is_server then
			self:_send_rpc_to_clients("rpc_select_deed", var_21_2, arg_21_2)
		else
			self:_send_rpc_to_server("rpc_select_deed", var_21_2, arg_21_2)
		end
	end
end

DeedManager._update_owner = function (self, arg_22_1)
	-- function 22
	if not self._deed_session_faulty then
		return
	end

	local _owner_peer_id = self._owner_peer_id

	if not self._lobby:members():members_map()[_owner_peer_id] then
		Managers.chat:add_local_system_message(1, Localize("deed_owner_left_game"), true)

		self._deed_session_faulty = true
	end
end

DeedManager._use_reward_callback = function (self)
	-- function 23
	fassert(self._reward_callback, "there is no reward callback")

	local _reward_callback = self._reward_callback

	self._reward_callback = nil

	_reward_callback()
end

DeedManager.rpc_select_deed = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local var_24_0 = NetworkLookup.item_names[arg_24_2]

	self._selected_deed_data = ItemMasterList[var_24_0]
	self._selected_deed_id = nil
	self._owner_peer_id = arg_24_3

	local network = Managers.state.network

	if not self._is_server and not network and not network:game() then
		local var_24_2 = CHANNEL_TO_PEER_ID[arg_24_1]

		self:_send_rpc_to_clients_except("rpc_select_deed", var_24_2, arg_24_2, arg_24_3)
	end
end

DeedManager.rpc_deed_consumed = function (self, arg_25_1)
	-- function 25
	print("Deed has been consumed by owner, act on reward callback!")

	if not self._reward_callback then
		self._has_consumed_deed = true
	else
		self:_use_reward_callback()
	end

	local network = Managers.state.network

	if not self._is_server and not network and not network:game() then
		print("Sending to the other clients to act on deed consume")

		local var_25_1 = CHANNEL_TO_PEER_ID[arg_25_1]

		self:_send_rpc_to_clients_except("rpc_deed_consumed", var_25_1)
	end
end

DeedManager.rpc_reset_deed = function (self, arg_26_1)
	-- function 26
	if CHANNEL_TO_PEER_ID[arg_26_1] ~= self._server_peer_id then
		print("[DeedManager] Skipping rpc_reset_deed, not sent from current server")

		return
	end

	local flag = true

	self:reset(flag)
end

DeedManager._send_rpc_to_server = function (self, arg_27_1, ...)
	-- function 27
	local var_27_0 = RPC[arg_27_1]
	local var_27_1 = PEER_ID_TO_CHANNEL[self._server_peer_id]

	var_27_0(var_27_1, ...)
end

DeedManager._send_rpc_to_clients = function (self, arg_28_1, ...)
	-- function 28
	local _network_server = self._network_server

	if not _network_server then
		return
	end

	local var_28_1 = RPC[arg_28_1]
	local _server_peer_id = self._server_peer_id
	local players_past_connecting = _network_server:players_past_connecting()

	for i = 1, #players_past_connecting do
		local var_28_4 = players_past_connecting[i]

		if var_28_4 ~= _server_peer_id then
			local var_28_5 = PEER_ID_TO_CHANNEL[var_28_4]

			var_28_1(var_28_5, ...)
		end
	end
end

DeedManager._send_rpc_to_clients_except = function (self, arg_29_1, arg_29_2, ...)
	-- function 29
	local _network_server = self._network_server

	if not _network_server then
		return
	end

	local var_29_1 = RPC[arg_29_1]
	local _server_peer_id = self._server_peer_id
	local players_past_connecting = _network_server:players_past_connecting()

	for i = 1, #players_past_connecting do
		local var_29_4 = players_past_connecting[i]

		if not (var_29_4 == _server_peer_id or var_29_4 == arg_29_2) then
			local var_29_5 = PEER_ID_TO_CHANNEL[var_29_4]

			var_29_1(var_29_5, ...)
		end
	end
end

DeedManager._send_rpc_to_client = function (self, arg_30_1, arg_30_2, ...)
	-- function 30
	if not self._network_server then
		return
	end

	local var_30_0 = RPC[arg_30_1]
	local var_30_1 = PEER_ID_TO_CHANNEL[arg_30_2]

	var_30_0(var_30_1, ...)
end
