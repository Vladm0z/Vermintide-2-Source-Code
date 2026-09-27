-- chunkname: @scripts/managers/game_mode/versus_pre_game_logic.lua

local tbl = {
	"rpc_pre_game_request_ready",
	"rpc_pre_game_set_player_ready",
	"rpc_pre_game_select_character",
	"rpc_change_pre_game_seach_state"
}

VersusPreGameLogic = class(VersusPreGameLogic)

VersusPreGameLogic.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._is_server = arg_1_1
	self._network_server = arg_1_2
	self._peer_ready_states = {}
	self._ready_request_ids = {}
	self._search_state_info = ""

	self:_fill_peer_ready_states(self._peer_ready_states)

	self._owner_peer_id = Network.peer_id()
end

VersusPreGameLogic.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
	self._network_transmit = arg_2_2
end

VersusPreGameLogic.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

VersusPreGameLogic.can_peer_change_ready_state = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return true
end

VersusPreGameLogic.is_peer_ready = function (self, arg_5_1, arg_5_2)
	-- function 5
	return self._peer_ready_states[arg_5_1][arg_5_2].ready
end

local flag = false

VersusPreGameLogic.all_peers_ready = function (self)
	-- function 6
	local flag_2 = true

	if not flag then
		return true
	end

	local _peer_ready_states = self._peer_ready_states

	if not table.is_empty(_peer_ready_states) then
		flag_2 = false
	end

	for k, v in pairs(_peer_ready_states) do
		for k_2, v_2 in pairs(v) do
			if not v_2.ready then
				flag_2 = false

				break
			end
		end
	end

	return flag_2
end

VersusPreGameLogic.character_info = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._peer_ready_states[arg_7_1][arg_7_2]
	local profile_index = var_7_0.profile_index
	local career_index = var_7_0.career_index
	local melee_name = var_7_0.melee_name
	local ranged_name = var_7_0.ranged_name

	return profile_index, career_index, melee_name, ranged_name
end

VersusPreGameLogic.player_joined_party = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	print("VersusPreGameLogic player_joined_party:", arg_8_1, arg_8_2, arg_8_3)

	local _peer_ready_states = self._peer_ready_states

	self:_add_player_state(_peer_ready_states, arg_8_1, arg_8_2)
end

VersusPreGameLogic.player_left_party = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	print("VersusPreGameLogic player_left_party:", arg_9_1, arg_9_2, arg_9_3)

	local _peer_ready_states = self._peer_ready_states

	self:_remove_player_state(_peer_ready_states, arg_9_1, arg_9_2)
end

VersusPreGameLogic.request_ready = function (self, arg_10_1, arg_10_2)
	-- function 10
	arg_10_1 = self._local_player_id or arg_10_1
	self._local_player_id = arg_10_1

	if not (not Managers.state.network and Managers.state.network:game()) then
		Crashify.print_exception("VersusPreGameLogic", "Tried to ready up whithout game_session")

		return
	end

	local _owner_peer_id = self._owner_peer_id
	local _ready_request_ids = self._ready_request_ids
	local var_10_2 = self._ready_request_ids[arg_10_1]

	var_10_2 = var_10_2 or 0
	_ready_request_ids[arg_10_1] = var_10_2 % NetworkConstants.READY_REQUEST_ID_MAX + 1

	local var_10_3 = self._ready_request_ids[arg_10_1]

	if not self._is_server then
		self:_handle_ready_request(_owner_peer_id, arg_10_1, arg_10_2, var_10_3)

		if not arg_10_2 then
			Managers.mechanism:game_mechanism():reset_dedicated_slots_count()
			Managers.matchmaking:cancel_matchmaking()
		end
	else
		self:_set_player_ready(_owner_peer_id, arg_10_1, arg_10_2, var_10_3)
		self._network_transmit:send_rpc_server("rpc_pre_game_request_ready", arg_10_1, arg_10_2, var_10_3)
	end
end

VersusPreGameLogic.failed_to_find_dedicated_server = function (self, arg_11_1)
	-- function 11
	self:request_ready(nil, false)
	Managers.state.event:trigger("show_pre_game_view_popup", arg_11_1)
end

VersusPreGameLogic.request_force_start_server = function (arg_12_0)
	-- function 12
	print("force starting server")

	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.force_start_dedicated_server then
		game_mechanism:force_start_dedicated_server()
	end
end

VersusPreGameLogic.request_switch_level = function (arg_13_0, arg_13_1)
	-- function 13
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.switch_level_dedicated_server then
		game_mechanism:switch_level_dedicated_server(arg_13_1)
	end
end

VersusPreGameLogic.select_character = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	local var_14_0

	if not arg_14_5 then
		var_14_0 = arg_14_5.key
	end

	local var_14_1

	if not arg_14_6 then
		var_14_1 = arg_14_6.key
	end

	self:_select_character(arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_0, var_14_1)

	local var_14_2 = NetworkLookup.item_names[var_14_0 or "n/a"]
	local var_14_3 = NetworkLookup.item_names[var_14_1 or "n/a"]

	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_pre_game_select_character", arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_2, var_14_3)
	else
		self._network_transmit:send_rpc_server("rpc_pre_game_select_character", arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_2, var_14_3)
	end

	Managers.backend:commit()
end

VersusPreGameLogic.can_toggle_local_match = function (self)
	-- function 15
	if not self._is_server then
		return false
	end

	if not (not self:is_local_match() and not (#self._network_server.lobby_host:members():get_members() > Managers.mechanism:max_party_members())) then
		return false
	end

	return true
end

VersusPreGameLogic.can_toggle_public_private_lobby = function (self)
	-- function 16
	if not self._is_server then
		return false
	end

	if not self:is_local_match() then
		return true
	end

	return false
end

VersusPreGameLogic.can_toggle_dedicated_servers_or_player_hosted_search = function (self)
	-- function 17
	if not self._is_server then
		return false
	end

	if not self:is_local_match() then
		return false
	end

	return true
end

VersusPreGameLogic.is_local_match = function (arg_18_0)
	-- function 18
	return Managers.mechanism:game_mechanism():is_local_match()
end

VersusPreGameLogic.set_local_match = function (arg_19_0, arg_19_1)
	-- function 19
	Managers.mechanism:game_mechanism():set_local_match(arg_19_1)
end

VersusPreGameLogic.is_private_lobby = function (arg_20_0)
	-- function 20
	return Managers.mechanism:game_mechanism():is_private_lobby()
end

VersusPreGameLogic.set_private_lobby = function (arg_21_0, arg_21_1)
	-- function 21
	Managers.mechanism:game_mechanism():set_private_lobby(arg_21_1)
end

VersusPreGameLogic.using_dedicated_servers_search = function (arg_22_0)
	-- function 22
	return Managers.mechanism:game_mechanism():using_dedicated_servers()
end

VersusPreGameLogic.using_player_hosted_search = function (arg_23_0)
	-- function 23
	return Managers.mechanism:game_mechanism():using_player_hosted()
end

VersusPreGameLogic.set_dedicated_or_player_hosted_search = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	return Managers.mechanism:game_mechanism():set_dedicated_or_player_hosted_search(arg_24_1, arg_24_2, arg_24_3)
end

VersusPreGameLogic.hot_join_sync = function (self, arg_25_1)
	-- function 25
	local var_25_0 = PEER_ID_TO_CHANNEL[arg_25_1]

	for k, v in pairs(self._peer_ready_states) do
		for k_2, v_2 in pairs(v) do
			local ready = v_2.ready
			local request_id = v_2.request_id

			RPC.rpc_pre_game_set_player_ready(var_25_0, k, k_2, ready, request_id)

			local profile_index = v_2.profile_index

			if not profile_index then
				local career_index = v_2.career_index
				local melee_name = v_2.melee_name
				local ranged_name = v_2.ranged_name
				local var_25_7 = NetworkLookup.item_names[melee_name or "n/a"]
				local var_25_8 = NetworkLookup.item_names[ranged_name or "n/a"]

				RPC.rpc_pre_game_select_character(var_25_0, k, k_2, profile_index, career_index, var_25_7, var_25_8)
			end
		end
	end
end

VersusPreGameLogic._fill_peer_ready_states = function (self, arg_26_1)
	-- function 26
	local parties = Managers.party:parties()

	for i = 0, #parties do
		local occupied_slots = parties[i].occupied_slots

		for j = 1, #occupied_slots do
			local var_26_2 = occupied_slots[j]
			local peer_id = var_26_2.peer_id
			local local_player_id = var_26_2.local_player_id

			self:_add_player_state(arg_26_1, peer_id, local_player_id)
		end
	end
end

VersusPreGameLogic._add_player_state = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	if not arg_27_1[arg_27_2] then
		arg_27_1[arg_27_2] = {}
	end

	local var_27_0 = arg_27_1[arg_27_2]

	if not var_27_0[arg_27_3] then
		var_27_0[arg_27_3] = {}
	end

	local var_27_1 = var_27_0[arg_27_3]

	var_27_1.ready = false
	var_27_1.request_id = 1
end

VersusPreGameLogic._remove_player_state = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local var_28_0 = arg_28_1[arg_28_2]

	var_28_0[arg_28_3] = nil

	if not table.is_empty(var_28_0) then
		arg_28_1[arg_28_2] = nil
	end
end

VersusPreGameLogic._handle_ready_request = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	-- function 29
	if not self:can_peer_change_ready_state(arg_29_1, arg_29_2) then
		arg_29_3 = self._peer_ready_states[arg_29_1][arg_29_2].ready
	end

	self:_set_player_ready(arg_29_1, arg_29_2, arg_29_3, arg_29_4)
end

VersusPreGameLogic.set_all_players_ready = function (self, arg_30_1)
	-- function 30
	for k, v in pairs(self._peer_ready_states) do
		for k_2, v_2 in pairs(v) do
			local _ready_request_ids = self._ready_request_ids
			local var_30_1 = self._ready_request_ids[k_2]

			var_30_1 = var_30_1 or 0
			_ready_request_ids[k_2] = var_30_1 % NetworkConstants.READY_REQUEST_ID_MAX + 1

			local var_30_2 = self._ready_request_ids[k_2]

			self:_set_player_ready(k, k_2, arg_30_1, -1)
		end
	end
end

VersusPreGameLogic._set_player_ready = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	if not self:peer_in_ready_states(arg_31_1, arg_31_2) then
		self:_add_player_state(self._peer_ready_states, arg_31_1, arg_31_2)
	end

	local var_31_0 = self._peer_ready_states[arg_31_1][arg_31_2]

	var_31_0.ready = arg_31_3
	var_31_0.request_id = arg_31_4

	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_pre_game_set_player_ready", arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	end
end

VersusPreGameLogic._select_character = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local var_32_0 = self._peer_ready_states[arg_32_1][arg_32_2]

	var_32_0.profile_index = arg_32_3
	var_32_0.career_index = arg_32_4
	var_32_0.melee_name = arg_32_5
	var_32_0.ranged_name = arg_32_6

	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(arg_32_1 .. ":" .. arg_32_2)

	get_status_from_unique_id.preferred_profile_index = arg_32_3
	get_status_from_unique_id.preferred_career_index = arg_32_4
end

VersusPreGameLogic.peer_in_ready_states = function (self, arg_33_1, arg_33_2)
	-- function 33
	local var_33_0 = self._peer_ready_states[arg_33_1]

	if not var_33_0 then
		return false
	end

	return var_33_0[arg_33_2] ~= nil
end

local tbl_2 = {
	"idle",
	"joined_dedicated_server",
	"searching_for_dedicated_server",
	"force_starting_dedicated_server",
	"searching_for_player_hosted_game"
}

for i = 1, #tbl_2 do
	tbl_2[tbl_2[i]] = i
end

VersusPreGameLogic.search_state_info = function (self)
	-- function 34
	return self._search_state_info
end

VersusPreGameLogic.change_pre_game_search_state = function (self, arg_35_1)
	-- function 35
	self._search_state_info = arg_35_1

	if not self._is_server then
		local var_35_0 = tbl_2[arg_35_1]

		self._network_transmit:send_rpc_clients("rpc_change_pre_game_seach_state", var_35_0)
	end
end

VersusPreGameLogic.rpc_change_pre_game_seach_state = function (self, arg_36_1, arg_36_2)
	-- function 36
	fassert(not self._is_server, "Should only appear on the clients.")

	local var_36_0 = tbl_2[arg_36_2]

	self:change_pre_game_search_state(var_36_0)
end

VersusPreGameLogic.rpc_pre_game_request_ready = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	local var_37_0 = CHANNEL_TO_PEER_ID[arg_37_1]

	self:_handle_ready_request(var_37_0, arg_37_2, arg_37_3, arg_37_4)
end

VersusPreGameLogic.rpc_pre_game_set_player_ready = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	-- function 38
	local _owner_peer_id = self._owner_peer_id
	local var_38_1 = self._ready_request_ids[arg_38_3]

	if not (arg_38_2 ~= _owner_peer_id or arg_38_5 == var_38_1 or arg_38_5 == -1) then
		return
	end

	self:_set_player_ready(arg_38_2, arg_38_3, arg_38_4, arg_38_5)
end

VersusPreGameLogic.rpc_pre_game_select_character = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7)
	-- function 39
	local var_39_0 = NetworkLookup.item_names[arg_39_6]

	if var_39_0 == "n/a" then
		var_39_0 = nil
	end

	local var_39_1 = NetworkLookup.item_names[arg_39_7]

	if var_39_1 == "n/a" then
		var_39_1 = nil
	end

	print("rpc_pre_game_select_character", arg_39_2, arg_39_3, var_39_0, var_39_1)
	self:_select_character(arg_39_2, arg_39_3, arg_39_4, arg_39_5, var_39_0, var_39_1)

	if not self._is_server then
		local var_39_2 = CHANNEL_TO_PEER_ID[arg_39_1]

		self._network_transmit:send_rpc_clients_except("rpc_pre_game_select_character", var_39_2, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7)
	end
end
