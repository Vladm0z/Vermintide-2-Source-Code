-- chunkname: @scripts/network/network_transmit.lua

local RPC = RPC
local tbl = {}

function call_RPC(arg_1_0, arg_1_1, ...)
	-- function 1
	local var_1_0 = PEER_ID_TO_CHANNEL[arg_1_1]

	RPC[arg_1_0](var_1_0, ...)
end

local mirror_array = table.mirror_array(GameSettingsDevelopment.ignored_rpc_logs)

local function fn(arg_2_0, ...)
	-- function 2
	if mirror_array[arg_2_0] == nil then
		print("[LOCAL RPC] ", arg_2_0, ...)
	end
end

NetworkTransmit = class(NetworkTransmit)

NetworkTransmit.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.is_server = arg_3_1
	self.peer_id = Network.peer_id()
	self.server_peer_id = arg_3_2
	self.local_rpc_queue = {
		{},
		{}
	}
	self.local_rpc_queue_n = {
		0,
		0
	}
	self.local_rpc_queue_contains_boxed = {
		{},
		{}
	}
	self.local_rpc_buffer_index = 1
	self.peer_ignore_list = {}
	self.game_session = nil
end

NetworkTransmit.update_receive = function (self)
	-- function 4
	self._pack_temp_types = false
end

NetworkTransmit.set_game_session = function (self, arg_5_1)
	-- function 5
	self.game_session = arg_5_1
end

NetworkTransmit.add_peer_ignore = function (arg_6_0, arg_6_1)
	-- function 6
	arg_6_0.peer_ignore_list[arg_6_1] = true
end

NetworkTransmit.remove_peer_ignore = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0.peer_ignore_list[arg_7_1] = nil
end

NetworkTransmit.destroy = function (arg_8_0)
	-- function 8
	GarbageLeakDetector.register_object(arg_8_0, "NetworkTransmit")
end

NetworkTransmit.pack_temp_types = function (arg_9_0, arg_9_1, ...)
	-- function 9
	local tbl = {
		...
	}
	local flag = false

	for i = 1, arg_9_1 or #tbl do
		local var_9_2 = tbl[i]
		local type_name = Script.type_name(var_9_2)

		if type_name == "Vector3" then
			tbl[i] = Vector3Box(var_9_2)
			flag = true
		elseif type_name == "Vector4" then
			tbl[i] = QuaternionBox(var_9_2)
			flag = true
		end
	end

	return tbl, flag
end

NetworkTransmit.unpack_temp_types = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local flag = arg_10_2 or 0

	for i = 1, arg_10_3 or #arg_10_1 do
		local num = flag + i
		local var_10_2 = arg_10_1[num]
		local type_name = Script.type_name(var_10_2)

		if not (type_name == "Vector3Box" or type_name ~= "QuaternionBox") then
			arg_10_1[num] = var_10_2:unbox()
		end
	end
end

NetworkTransmit.queue_local_rpc = function (self, arg_11_1, ...)
	-- function 11
	local local_rpc_buffer_index = self.local_rpc_buffer_index
	local var_11_1 = self.local_rpc_queue[local_rpc_buffer_index]
	local var_11_2 = self.local_rpc_queue_n[local_rpc_buffer_index]
	local var_11_3 = self.local_rpc_queue_contains_boxed[local_rpc_buffer_index]
	local var_11_4 = select("#", ...)

	fassert(pack_index[var_11_4 + 2], "Could not pack local rpc %q due to too many varargs. Only 20 is currently supported.", arg_11_1)

	if not self._pack_temp_types then
		local pack_temp_types, var_11_6 = self:pack_temp_types(var_11_4, ...)

		pack_index[var_11_4 + 2](var_11_1, var_11_2, arg_11_1, var_11_4, unpack(pack_temp_types, 1, var_11_4))

		var_11_3[#var_11_3 + 1] = var_11_6
	else
		pack_index[var_11_4 + 2](var_11_1, var_11_2, arg_11_1, var_11_4, ...)

		var_11_3[#var_11_3 + 1] = false
	end

	self.local_rpc_queue_n[local_rpc_buffer_index] = var_11_2 + var_11_4 + 2
end

NetworkTransmit.transmit_local_rpcs = function (self)
	-- function 12
	self._pack_temp_types = true

	local local_rpc_buffer_index = self.local_rpc_buffer_index
	local var_12_1 = self.local_rpc_queue_contains_boxed[local_rpc_buffer_index]
	local var_12_2 = self.local_rpc_queue_n[local_rpc_buffer_index]
	local var_12_3 = self.local_rpc_queue[local_rpc_buffer_index]

	self.local_rpc_buffer_index = 3 - local_rpc_buffer_index

	local event_table = self.network_event_delegate.event_table
	local num = 0
	local parameter = Development.parameter("network_log_messages")
	local num_2 = 0
	local num_3 = 0

	while num_2 < var_12_2 do
		num_3 = num_3 + 1

		local var_12_9 = var_12_3[num_2]
		local var_12_10 = var_12_3[num_2 + 1]

		if not parameter then
			fn(var_12_9, unpack_index[var_12_10](var_12_3, num_2 + 2))
		end

		if not var_12_1[num_3] then
			self:unpack_temp_types(var_12_3, num_2 + 1, var_12_10)
		end

		event_table[var_12_9](nil, num, unpack_index[var_12_10](var_12_3, num_2 + 2))

		num_2 = num_2 + var_12_10 + 2
	end

	fassert(num_2 == var_12_2, "Couldn't process all local rpcs!")

	self.local_rpc_queue_n[local_rpc_buffer_index] = 0

	table.clear(var_12_1)
end

NetworkTransmit.set_network_event_delegate = function (self, arg_13_1)
	-- function 13
	self.network_event_delegate = arg_13_1
end

NetworkTransmit.send_rpc = function (self, arg_14_1, arg_14_2, ...)
	-- function 14
	local var_14_0 = RPC[arg_14_1]

	fassert(var_14_0, "[NetworkTransmit:send_rpc()] rpc does not exist %q", arg_14_1)

	if arg_14_2 == self.peer_id then
		self:queue_local_rpc(arg_14_1, ...)
	else
		local var_14_1 = PEER_ID_TO_CHANNEL[arg_14_2]

		var_14_0(var_14_1, ...)
	end

	local peer_id = self.peer_id
end

NetworkTransmit.send_rpc_server = function (self, arg_15_1, ...)
	-- function 15
	local var_15_0 = RPC[arg_15_1]

	fassert(var_15_0, "[NetworkTransmit:send_rpc_server()] rpc does not exist %q", arg_15_1)

	if not self.is_server then
		self:queue_local_rpc(arg_15_1, ...)
	else
		fassert(self.server_peer_id, "We don't have any server connection when trying to send RPC %q", arg_15_1)

		local var_15_1 = PEER_ID_TO_CHANNEL[self.server_peer_id]

		var_15_0(var_15_1, ...)
	end
end

NetworkTransmit.send_rpc_dedicated_server = function (self, arg_16_1, ...)
	-- function 16
	local var_16_0 = RPC[arg_16_1]

	fassert(var_16_0, "[NetworkTransmit:send_rpc_server()] rpc does not exist %q", arg_16_1)

	local dedicated_server_peer_id = Managers.mechanism:dedicated_server_peer_id()

	fassert(dedicated_server_peer_id, "Failed to get peer id for dedicated server")

	if self.peer_id == dedicated_server_peer_id then
		self:queue_local_rpc(arg_16_1, ...)
	else
		local var_16_2 = PEER_ID_TO_CHANNEL[dedicated_server_peer_id]

		fassert(var_16_2, "Failed to find channel_id for dedicated server")
		var_16_0(var_16_2, ...)
	end
end

NetworkTransmit.send_rpc_party_clients = function (self, arg_17_1, arg_17_2, arg_17_3, ...)
	-- function 17
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_17_1)

	local var_17_0 = RPC[arg_17_1]

	fassert(var_17_0, "[NetworkTransmit:send_rpc_clients()] rpc does not exist: %q", arg_17_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local occupied_slots = arg_17_2.occupied_slots
	local var_17_3 = tbl

	table.clear(var_17_3)

	for i, v in ipairs(occupied_slots) do
		if not v.is_player then
			var_17_3[v.peer_id] = true
		end
	end

	if not arg_17_3 then
		local get_party_from_name = Managers.party:get_party_from_name("spectators")

		if not get_party_from_name then
			local occupied_slots_2 = get_party_from_name.occupied_slots

			for i_2, v_2 in ipairs(occupied_slots_2) do
				if not v_2.is_player then
					var_17_3[v_2.peer_id] = true
				end
			end
		end
	end

	local peer_ignore_list = self.peer_ignore_list

	for i_3, v_3 in ipairs(GameSession.other_peers(game_session)) do
		if peer_ignore_list[v_3] or not var_17_3[v_3] then
			local var_17_7 = PEER_ID_TO_CHANNEL[v_3]

			var_17_0(var_17_7, ...)
		end
	end
end

NetworkTransmit.send_rpc_party = function (self, arg_18_1, arg_18_2, arg_18_3, ...)
	-- function 18
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_18_1)

	local var_18_0 = RPC[arg_18_1]

	fassert(var_18_0, "[NetworkTransmit:send_rpc_party()] rpc does not exist: %q", arg_18_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local occupied_slots = arg_18_2.occupied_slots
	local var_18_3 = tbl

	table.clear(var_18_3)

	for i, v in ipairs(occupied_slots) do
		if not v.is_player then
			var_18_3[v.peer_id] = true
		end
	end

	if not arg_18_3 then
		local get_party_from_name = Managers.party:get_party_from_name("spectators")

		if not get_party_from_name then
			local occupied_slots_2 = get_party_from_name.occupied_slots

			for i_2, v_2 in ipairs(occupied_slots_2) do
				if not v_2.is_player then
					var_18_3[v_2.peer_id] = true
				end
			end
		end
	end

	if not var_18_3[self.peer_id] then
		self:queue_local_rpc(arg_18_1, ...)

		var_18_3[self.peer_id] = nil
	end

	local peer_ignore_list = self.peer_ignore_list

	for i_3, v_3 in ipairs(GameSession.other_peers(game_session)) do
		if peer_ignore_list[v_3] or not var_18_3[v_3] then
			local var_18_7 = PEER_ID_TO_CHANNEL[v_3]

			var_18_0(var_18_7, ...)
		end
	end
end

local function fn_2(self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = tbl

	table.clear(var_19_0)

	local PLAYER_UNITS = self.PLAYER_UNITS

	for i, v in ipairs(PLAYER_UNITS) do
		var_19_0[Managers.player:owner(v):network_id()] = true
	end

	if not arg_19_1 then
		local get_allied_sides = self:get_allied_sides()

		for k = 1, #get_allied_sides do
			local PLAYER_UNITS_2 = get_allied_sides[k].PLAYER_UNITS

			for i_2, v_2 in ipairs(PLAYER_UNITS_2) do
				var_19_0[Managers.player:owner(v_2):network_id()] = true
			end
		end
	end

	if not arg_19_2 and not Managers.state.side:get_side_from_name("spectators") then
		local PLAYER_UNITS_3 = self.PLAYER_UNITS

		for i_3, v_3 in ipairs(PLAYER_UNITS_3) do
			var_19_0[Managers.player:owner(v_3):network_id()] = true
		end
	end

	return var_19_0
end

NetworkTransmit.send_rpc_side = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, ...)
	-- function 20
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_20_1)

	local var_20_0 = RPC[arg_20_1]

	fassert(var_20_0, "[NetworkTransmit:send_rpc_side()] rpc does not exist: %q", arg_20_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local var_20_2 = fn_2(arg_20_2, arg_20_3, arg_20_4)

	if var_20_2[self.peer_id] or not arg_20_5 then
		self:queue_local_rpc(arg_20_1, ...)

		var_20_2[self.peer_id] = nil
	end

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if peer_ignore_list[v] or not var_20_2[v] then
			local var_20_4 = PEER_ID_TO_CHANNEL[v]

			var_20_0(var_20_4, ...)
		end
	end
end

NetworkTransmit.send_rpc_side_clients = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, ...)
	-- function 21
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_21_1)

	local var_21_0 = RPC[arg_21_1]

	fassert(var_21_0, "[NetworkTransmit:send_rpc_side_clients()] rpc does not exist: %q", arg_21_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local var_21_2 = fn_2(arg_21_2, arg_21_3, arg_21_4)

	var_21_2[self.peer_id] = nil

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if peer_ignore_list[v] or not var_21_2[v] then
			local var_21_4 = PEER_ID_TO_CHANNEL[v]

			var_21_0(var_21_4, ...)
		end
	end
end

NetworkTransmit.send_rpc_clients = function (self, arg_22_1, ...)
	-- function 22
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_22_1)

	local var_22_0 = RPC[arg_22_1]

	fassert(var_22_0, "[NetworkTransmit:send_rpc_clients()] rpc does not exist: %q", arg_22_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if not peer_ignore_list[v] then
			local var_22_3 = PEER_ID_TO_CHANNEL[v]

			var_22_0(var_22_3, ...)
		end
	end
end

NetworkTransmit.send_rpc_clients_except = function (self, arg_23_1, arg_23_2, ...)
	-- function 23
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_23_1)

	local var_23_0 = RPC[arg_23_1]

	fassert(var_23_0, "[NetworkTransmit:send_rpc_clients_except()] rpc does not exist: %q", arg_23_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if not (v == arg_23_2 or peer_ignore_list[v]) then
			local var_23_3 = PEER_ID_TO_CHANNEL[v]

			var_23_0(var_23_3, ...)
		end
	end
end

NetworkTransmit.send_rpc_side_clients_except = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, ...)
	-- function 24
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_24_1)

	local var_24_0 = RPC[arg_24_1]

	fassert(var_24_0, "[NetworkTransmit:send_rpc_side_clients_except()] rpc does not exist: %q", arg_24_1)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local var_24_2 = fn_2(arg_24_2, arg_24_3, arg_24_4)

	var_24_2[self.peer_id] = nil
	var_24_2[arg_24_5] = nil

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if peer_ignore_list[v] or not var_24_2[v] then
			local var_24_4 = PEER_ID_TO_CHANNEL[v]

			var_24_0(var_24_4, ...)
		end
	end
end

NetworkTransmit.send_rpc_all = function (self, arg_25_1, ...)
	-- function 25
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_25_1)

	local var_25_0 = RPC[arg_25_1]

	fassert(var_25_0, "[NetworkTransmit:send_rpc_all()] rpc does not exist: %q", arg_25_1)
	self:queue_local_rpc(arg_25_1, ...)

	local game_session = self.game_session

	if not game_session then
		return
	end

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if not peer_ignore_list[v] then
			local var_25_3 = PEER_ID_TO_CHANNEL[v]

			var_25_0(var_25_3, ...)
		end
	end
end

NetworkTransmit.send_rpc_all_except = function (self, arg_26_1, arg_26_2, ...)
	-- function 26
	fassert(self.is_server, "Trying to send rpc %q on client to clients which is wrong. Only servers should use this function.", arg_26_1)

	local var_26_0 = RPC[arg_26_1]

	fassert(var_26_0, "[NetworkTransmit:send_rpc_all_except()] rpc does not exist: %q", arg_26_1)

	if arg_26_2 ~= self.peer_id then
		self:queue_local_rpc(arg_26_1, ...)
	end

	local game_session = self.game_session

	if not game_session then
		return
	end

	local peer_ignore_list = self.peer_ignore_list

	for i, v in ipairs(GameSession.other_peers(game_session)) do
		if not (v == arg_26_2 or peer_ignore_list[v]) then
			local var_26_3 = PEER_ID_TO_CHANNEL[v]

			var_26_0(var_26_3, ...)
		end
	end
end
