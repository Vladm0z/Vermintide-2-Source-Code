-- chunkname: @scripts/managers/game_mode/versus_pre_game_logic.lua

local var_0_0 = {
	"rpc_pre_game_request_ready",
	"rpc_pre_game_set_player_ready",
	"rpc_pre_game_select_character",
	"rpc_change_pre_game_seach_state"
}

VersusPreGameLogic = class(VersusPreGameLogic)

VersusPreGameLogic.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._is_server = arg_1_1
	arg_1_0._network_server = arg_1_2
	arg_1_0._peer_ready_states = {}
	arg_1_0._ready_request_ids = {}
	arg_1_0._search_state_info = ""

	arg_1_0:_fill_peer_ready_states(arg_1_0._peer_ready_states)

	arg_1_0._owner_peer_id = Network.peer_id()
end

VersusPreGameLogic.register_rpcs = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:register(arg_2_0, unpack(var_0_0))

	arg_2_0._network_event_delegate = arg_2_1
	arg_2_0._network_transmit = arg_2_2
end

VersusPreGameLogic.unregister_rpcs = function (arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
	arg_3_0._network_transmit = nil
end

VersusPreGameLogic.can_peer_change_ready_state = function (arg_4_0, arg_4_1, arg_4_2)
	return true
end

VersusPreGameLogic.is_peer_ready = function (arg_5_0, arg_5_1, arg_5_2)
	return arg_5_0._peer_ready_states[arg_5_1][arg_5_2].ready
end

local var_0_1 = false

VersusPreGameLogic.all_peers_ready = function (arg_6_0)
	local var_6_0 = true

	if var_0_1 then
		return true
	end

	local var_6_1 = arg_6_0._peer_ready_states

	if table.is_empty(var_6_1) then
		var_6_0 = false
	end

	for iter_6_0, iter_6_1 in pairs(var_6_1) do
		for iter_6_2, iter_6_3 in pairs(iter_6_1) do
			if not iter_6_3.ready then
				var_6_0 = false

				break
			end
		end
	end

	return var_6_0
end

VersusPreGameLogic.character_info = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._peer_ready_states[arg_7_1][arg_7_2]
	local var_7_1 = var_7_0.profile_index
	local var_7_2 = var_7_0.career_index
	local var_7_3 = var_7_0.melee_name
	local var_7_4 = var_7_0.ranged_name

	return var_7_1, var_7_2, var_7_3, var_7_4
end

VersusPreGameLogic.player_joined_party = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	print("VersusPreGameLogic player_joined_party:", arg_8_1, arg_8_2, arg_8_3)

	local var_8_0 = arg_8_0._peer_ready_states

	arg_8_0:_add_player_state(var_8_0, arg_8_1, arg_8_2)
end

VersusPreGameLogic.player_left_party = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	print("VersusPreGameLogic player_left_party:", arg_9_1, arg_9_2, arg_9_3)

	local var_9_0 = arg_9_0._peer_ready_states

	arg_9_0:_remove_player_state(var_9_0, arg_9_1, arg_9_2)
end

VersusPreGameLogic.request_ready = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_1 = arg_10_0._local_player_id or arg_10_1
	arg_10_0._local_player_id = arg_10_1

	if not Managers.state.network or not Managers.state.network:game() then
		Crashify.print_exception("VersusPreGameLogic", "Tried to ready up whithout game_session")

		return
	end

	local var_10_0 = arg_10_0._owner_peer_id

	arg_10_0._ready_request_ids[arg_10_1] = (arg_10_0._ready_request_ids[arg_10_1] or 0) % NetworkConstants.READY_REQUEST_ID_MAX + 1

	local var_10_1 = arg_10_0._ready_request_ids[arg_10_1]

	if arg_10_0._is_server then
		arg_10_0:_handle_ready_request(var_10_0, arg_10_1, arg_10_2, var_10_1)

		if not arg_10_2 then
			Managers.mechanism:game_mechanism():reset_dedicated_slots_count()
			Managers.matchmaking:cancel_matchmaking()
		end
	else
		arg_10_0:_set_player_ready(var_10_0, arg_10_1, arg_10_2, var_10_1)
		arg_10_0._network_transmit:send_rpc_server("rpc_pre_game_request_ready", arg_10_1, arg_10_2, var_10_1)
	end
end

VersusPreGameLogic.failed_to_find_dedicated_server = function (arg_11_0, arg_11_1)
	arg_11_0:request_ready(nil, false)
	Managers.state.event:trigger("show_pre_game_view_popup", arg_11_1)
end

VersusPreGameLogic.request_force_start_server = function (arg_12_0)
	print("force starting server")

	local var_12_0 = Managers.mechanism:game_mechanism()

	if var_12_0.force_start_dedicated_server then
		var_12_0:force_start_dedicated_server()
	end
end

VersusPreGameLogic.request_switch_level = function (arg_13_0, arg_13_1)
	local var_13_0 = Managers.mechanism:game_mechanism()

	if var_13_0.switch_level_dedicated_server then
		var_13_0:switch_level_dedicated_server(arg_13_1)
	end
end

VersusPreGameLogic.select_character = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	local var_14_0

	if arg_14_5 then
		var_14_0 = arg_14_5.key
	end

	local var_14_1

	if arg_14_6 then
		var_14_1 = arg_14_6.key
	end

	arg_14_0:_select_character(arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_0, var_14_1)

	local var_14_2 = NetworkLookup.item_names[var_14_0 or "n/a"]
	local var_14_3 = NetworkLookup.item_names[var_14_1 or "n/a"]

	if arg_14_0._is_server then
		arg_14_0._network_transmit:send_rpc_clients("rpc_pre_game_select_character", arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_2, var_14_3)
	else
		arg_14_0._network_transmit:send_rpc_server("rpc_pre_game_select_character", arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_2, var_14_3)
	end

	Managers.backend:commit()
end

VersusPreGameLogic.can_toggle_local_match = function (arg_15_0)
	if not arg_15_0._is_server then
		return false
	end

	if arg_15_0:is_local_match() and #arg_15_0._network_server.lobby_host:members():get_members() > Managers.mechanism:max_party_members() then
		return false
	end

	return true
end

VersusPreGameLogic.can_toggle_public_private_lobby = function (arg_16_0)
	if not arg_16_0._is_server then
		return false
	end

	if arg_16_0:is_local_match() then
		return true
	end

	return false
end

VersusPreGameLogic.can_toggle_dedicated_servers_or_player_hosted_search = function (arg_17_0)
	if not arg_17_0._is_server then
		return false
	end

	if arg_17_0:is_local_match() then
		return false
	end

	return true
end

VersusPreGameLogic.is_local_match = function (arg_18_0)
	return Managers.mechanism:game_mechanism():is_local_match()
end

VersusPreGameLogic.set_local_match = function (arg_19_0, arg_19_1)
	Managers.mechanism:game_mechanism():set_local_match(arg_19_1)
end

VersusPreGameLogic.is_private_lobby = function (arg_20_0)
	return Managers.mechanism:game_mechanism():is_private_lobby()
end

VersusPreGameLogic.set_private_lobby = function (arg_21_0, arg_21_1)
	Managers.mechanism:game_mechanism():set_private_lobby(arg_21_1)
end

VersusPreGameLogic.using_dedicated_servers_search = function (arg_22_0)
	return Managers.mechanism:game_mechanism():using_dedicated_servers()
end

VersusPreGameLogic.using_player_hosted_search = function (arg_23_0)
	return Managers.mechanism:game_mechanism():using_player_hosted()
end

VersusPreGameLogic.set_dedicated_or_player_hosted_search = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	return Managers.mechanism:game_mechanism():set_dedicated_or_player_hosted_search(arg_24_1, arg_24_2, arg_24_3)
end

VersusPreGameLogic.hot_join_sync = function (arg_25_0, arg_25_1)
	local var_25_0 = PEER_ID_TO_CHANNEL[arg_25_1]

	for iter_25_0, iter_25_1 in pairs(arg_25_0._peer_ready_states) do
		for iter_25_2, iter_25_3 in pairs(iter_25_1) do
			local var_25_1 = iter_25_3.ready
			local var_25_2 = iter_25_3.request_id

			RPC.rpc_pre_game_set_player_ready(var_25_0, iter_25_0, iter_25_2, var_25_1, var_25_2)

			local var_25_3 = iter_25_3.profile_index

			if var_25_3 then
				local var_25_4 = iter_25_3.career_index
				local var_25_5 = iter_25_3.melee_name
				local var_25_6 = iter_25_3.ranged_name
				local var_25_7 = NetworkLookup.item_names[var_25_5 or "n/a"]
				local var_25_8 = NetworkLookup.item_names[var_25_6 or "n/a"]

				RPC.rpc_pre_game_select_character(var_25_0, iter_25_0, iter_25_2, var_25_3, var_25_4, var_25_7, var_25_8)
			end
		end
	end
end

VersusPreGameLogic._fill_peer_ready_states = function (arg_26_0, arg_26_1)
	local var_26_0 = Managers.party:parties()

	for iter_26_0 = 0, #var_26_0 do
		local var_26_1 = var_26_0[iter_26_0].occupied_slots

		for iter_26_1 = 1, #var_26_1 do
			local var_26_2 = var_26_1[iter_26_1]
			local var_26_3 = var_26_2.peer_id
			local var_26_4 = var_26_2.local_player_id

			arg_26_0:_add_player_state(arg_26_1, var_26_3, var_26_4)
		end
	end
end

VersusPreGameLogic._add_player_state = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
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
	local var_28_0 = arg_28_1[arg_28_2]

	var_28_0[arg_28_3] = nil

	if table.is_empty(var_28_0) then
		arg_28_1[arg_28_2] = nil
	end
end

VersusPreGameLogic._handle_ready_request = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	if not arg_29_0:can_peer_change_ready_state(arg_29_1, arg_29_2) then
		arg_29_3 = arg_29_0._peer_ready_states[arg_29_1][arg_29_2].ready
	end

	arg_29_0:_set_player_ready(arg_29_1, arg_29_2, arg_29_3, arg_29_4)
end

VersusPreGameLogic.set_all_players_ready = function (arg_30_0, arg_30_1)
	for iter_30_0, iter_30_1 in pairs(arg_30_0._peer_ready_states) do
		for iter_30_2, iter_30_3 in pairs(iter_30_1) do
			arg_30_0._ready_request_ids[iter_30_2] = (arg_30_0._ready_request_ids[iter_30_2] or 0) % NetworkConstants.READY_REQUEST_ID_MAX + 1

			local var_30_0 = arg_30_0._ready_request_ids[iter_30_2]

			arg_30_0:_set_player_ready(iter_30_0, iter_30_2, arg_30_1, -1)
		end
	end
end

VersusPreGameLogic._set_player_ready = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	if not arg_31_0:peer_in_ready_states(arg_31_1, arg_31_2) then
		arg_31_0:_add_player_state(arg_31_0._peer_ready_states, arg_31_1, arg_31_2)
	end

	local var_31_0 = arg_31_0._peer_ready_states[arg_31_1][arg_31_2]

	var_31_0.ready = arg_31_3
	var_31_0.request_id = arg_31_4

	if arg_31_0._is_server then
		arg_31_0._network_transmit:send_rpc_clients("rpc_pre_game_set_player_ready", arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	end
end

VersusPreGameLogic._select_character = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0 = arg_32_0._peer_ready_states[arg_32_1][arg_32_2]

	var_32_0.profile_index = arg_32_3
	var_32_0.career_index = arg_32_4
	var_32_0.melee_name = arg_32_5
	var_32_0.ranged_name = arg_32_6

	local var_32_1 = Managers.party:get_status_from_unique_id(arg_32_1 .. ":" .. arg_32_2)

	var_32_1.preferred_profile_index = arg_32_3
	var_32_1.preferred_career_index = arg_32_4
end

VersusPreGameLogic.peer_in_ready_states = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._peer_ready_states[arg_33_1]

	if not var_33_0 then
		return false
	end

	return var_33_0[arg_33_2] ~= nil
end

local var_0_2 = {
	"idle",
	"joined_dedicated_server",
	"searching_for_dedicated_server",
	"force_starting_dedicated_server",
	"searching_for_player_hosted_game"
}

for iter_0_0 = 1, #var_0_2 do
	var_0_2[var_0_2[iter_0_0]] = iter_0_0
end

VersusPreGameLogic.search_state_info = function (arg_34_0)
	return arg_34_0._search_state_info
end

VersusPreGameLogic.change_pre_game_search_state = function (arg_35_0, arg_35_1)
	arg_35_0._search_state_info = arg_35_1

	if arg_35_0._is_server then
		local var_35_0 = var_0_2[arg_35_1]

		arg_35_0._network_transmit:send_rpc_clients("rpc_change_pre_game_seach_state", var_35_0)
	end
end

VersusPreGameLogic.rpc_change_pre_game_seach_state = function (arg_36_0, arg_36_1, arg_36_2)
	fassert(not arg_36_0._is_server, "Should only appear on the clients.")

	local var_36_0 = var_0_2[arg_36_2]

	arg_36_0:change_pre_game_search_state(var_36_0)
end

VersusPreGameLogic.rpc_pre_game_request_ready = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = CHANNEL_TO_PEER_ID[arg_37_1]

	arg_37_0:_handle_ready_request(var_37_0, arg_37_2, arg_37_3, arg_37_4)
end

VersusPreGameLogic.rpc_pre_game_set_player_ready = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	local var_38_0 = arg_38_0._owner_peer_id
	local var_38_1 = arg_38_0._ready_request_ids[arg_38_3]

	if arg_38_2 == var_38_0 and arg_38_5 ~= var_38_1 and arg_38_5 ~= -1 then
		return
	end

	arg_38_0:_set_player_ready(arg_38_2, arg_38_3, arg_38_4, arg_38_5)
end

VersusPreGameLogic.rpc_pre_game_select_character = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7)
	local var_39_0 = NetworkLookup.item_names[arg_39_6]

	if var_39_0 == "n/a" then
		var_39_0 = nil
	end

	local var_39_1 = NetworkLookup.item_names[arg_39_7]

	if var_39_1 == "n/a" then
		var_39_1 = nil
	end

	print("rpc_pre_game_select_character", arg_39_2, arg_39_3, var_39_0, var_39_1)
	arg_39_0:_select_character(arg_39_2, arg_39_3, arg_39_4, arg_39_5, var_39_0, var_39_1)

	if arg_39_0._is_server then
		local var_39_2 = CHANNEL_TO_PEER_ID[arg_39_1]

		arg_39_0._network_transmit:send_rpc_clients_except("rpc_pre_game_select_character", var_39_2, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7)
	end
end
