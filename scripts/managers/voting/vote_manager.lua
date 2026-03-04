-- chunkname: @scripts/managers/voting/vote_manager.lua

require("scripts/managers/voting/vote_templates")

VoteManager = class(VoteManager)

local var_0_0 = {
	"rpc_server_request_start_vote_peer_id",
	"rpc_server_request_start_vote_lookup",
	"rpc_server_request_start_vote_deed",
	"rpc_client_start_vote_peer_id",
	"rpc_client_start_vote_lookup",
	"rpc_client_start_vote_deed",
	"rpc_client_add_vote",
	"rpc_vote",
	"rpc_client_complete_vote",
	"rpc_client_vote_kick_enabled",
	"rpc_update_voters_list",
	"rpc_client_check_dlc",
	"rpc_server_check_dlc_reply",
	"rpc_requirement_failed"
}

VoteManager.init = function (arg_1_0, arg_1_1)
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.network_event_delegate = arg_1_1.network_event_delegate
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.ingame_context = arg_1_1

	arg_1_0.network_event_delegate:register(arg_1_0, unpack(var_0_0))

	arg_1_0._vote_kick_enabled = true
end

local var_0_1 = {}

VoteManager._gather_dlc_dependencies = function (arg_2_0, arg_2_1)
	table.clear(var_0_1)

	local var_2_0
	local var_2_1 = arg_2_1.mechanism
	local var_2_2 = var_2_1 and MechanismSettings[var_2_1]

	if var_2_2 and var_2_2.required_dlc then
		var_0_1[#var_0_1 + 1] = NetworkLookup.dlcs[var_2_2.required_dlc]
		var_2_0 = "all"
	end

	local var_2_3 = arg_2_1.difficulty
	local var_2_4 = DifficultySettings[var_2_3]

	if var_2_4 and var_2_4.dlc_requirement then
		var_0_1[#var_0_1 + 1] = NetworkLookup.dlcs[var_2_4.dlc_requirement]
		var_2_0 = var_2_0 == "all" and "all" or "any"
	end

	if #var_0_1 > 0 then
		return var_0_1, var_2_0
	end
end

VoteManager.request_vote = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = VoteTemplates[arg_3_1]

	fassert(var_3_0, "Could not find voting template by name: %q", arg_3_1)
	fassert(arg_3_3 ~= nil, "No voter peer id sent")

	local var_3_1 = NetworkLookup.voting_types[arg_3_1]

	arg_3_2 = arg_3_2 or {}
	arg_3_2.voter_peer_id = arg_3_3

	if arg_3_0.is_server then
		if arg_3_0:can_start_vote(arg_3_1, arg_3_2) then
			local var_3_2
			local var_3_3

			if not arg_3_4 then
				var_3_2, var_3_3 = arg_3_0:_gather_dlc_dependencies(arg_3_2)
			end

			if var_3_2 then
				arg_3_0._requirement_check_data = {
					vote_name = arg_3_1,
					results = {},
					voters = arg_3_0:_active_peers(),
					vote_data = arg_3_2,
					voter_peer_id = arg_3_3 or Network.peer_id(),
					votes_require_type = var_3_3
				}

				Managers.state.network.network_transmit:send_rpc_all("rpc_client_check_dlc", var_3_2)

				return false
			else
				arg_3_0:_server_abort_active_vote()
				arg_3_0:_server_start_vote(arg_3_1, nil, arg_3_2)

				local var_3_4 = var_3_0.pack_sync_data(arg_3_2)
				local var_3_5 = var_3_0.server_start_vote_rpc
				local var_3_6 = arg_3_0.active_voting.voters

				if script_data.debug_vote_manager then
					Managers.state.network.network_transmit:send_rpc_all(var_3_5, var_3_1, var_3_4, var_3_6)
				elseif DEDICATED_SERVER then
					local var_3_7 = Managers.player:player_from_peer_id(arg_3_3, 1)
					local var_3_8 = var_3_7 and var_3_7:get_party() or nil

					if var_3_8 then
						Managers.state.network.network_transmit:send_rpc_party_clients(var_3_5, var_3_8, true, var_3_1, var_3_4, var_3_6)
					end
				else
					Managers.state.network.network_transmit:send_rpc_clients(var_3_5, var_3_1, var_3_4, var_3_6)
				end

				if not script_data.debug_vote_manager and var_3_0.initial_vote_func then
					local var_3_9 = var_3_0.initial_vote_func(arg_3_2)

					for iter_3_0, iter_3_1 in pairs(var_3_9) do
						local var_3_10 = PEER_ID_TO_CHANNEL[iter_3_0]

						arg_3_0:rpc_vote(var_3_10, iter_3_1)
					end

					if var_3_9[Network.peer_id()] then
						arg_3_0:play_sound("play_gui_mission_vote")
					end
				end

				return true
			end
		end
	elseif Managers.state.network:game() then
		local var_3_11 = var_3_0.client_start_vote_rpc
		local var_3_12 = var_3_0.pack_sync_data(arg_3_2)

		Managers.state.network.network_transmit:send_rpc_server(var_3_11, var_3_1, var_3_12)

		if var_3_0.initial_vote_func and var_3_0.initial_vote_func(arg_3_2)[Network.peer_id()] then
			arg_3_0:play_sound("play_gui_mission_vote")
		end
	end
end

VoteManager._server_abort_active_vote = function (arg_4_0)
	local var_4_0 = arg_4_0.active_voting

	if var_4_0 then
		local var_4_1 = arg_4_0.ingame_context
		local var_4_2 = var_4_0.data
		local var_4_3 = var_4_0.template.on_complete(0, var_4_1, var_4_2)

		arg_4_0:rpc_client_complete_vote(nil, 0)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_client_complete_vote", 0)
	end
end

VoteManager._trigger_can_vote_fail_reply = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = NetworkLookup.voting_types[arg_5_1]
	local var_5_1 = arg_5_2.voter_peer_id

	Managers.state.network.network_transmit:send_rpc("rpc_requirement_failed", var_5_1, var_5_0, arg_5_3)
end

VoteManager.can_start_vote = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = VoteTemplates[arg_6_1]

	if var_6_0.can_start_vote then
		local var_6_1, var_6_2 = var_6_0.can_start_vote(arg_6_2)

		if not var_6_1 then
			if var_6_2 then
				arg_6_0:_trigger_can_vote_fail_reply(arg_6_1, arg_6_2, var_6_2)
			end

			return false
		end
	end

	if not (Managers.player:num_human_players() >= (var_6_0.min_required_voters or 1)) then
		return false
	end

	if arg_6_0._requirement_check_data then
		return false
	end

	local var_6_3 = arg_6_0.active_voting

	if var_6_3 and var_6_0.priority <= var_6_3.template.priority then
		return false
	end

	return true
end

local var_0_2 = "LOCAL_CALL"

VoteManager.vote = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1 ~= nil

	fassert(var_7_0, "Incorrect vote: %s. Casteted by: %s", arg_7_1, Network.peer_id())

	local var_7_1 = arg_7_0.is_server
	local var_7_2 = Managers.state.network

	if var_7_1 then
		local var_7_3 = CHANNEL_TO_PEER_ID[Network.peer_id()]

		arg_7_0:rpc_vote(var_0_2, arg_7_1)
	elseif var_7_2:in_game_session() then
		var_7_2.network_transmit:send_rpc_server("rpc_vote", arg_7_1)
	end
end

VoteManager._number_of_votes = function (arg_8_0)
	local var_8_0 = arg_8_0.active_voting

	if var_8_0 then
		local var_8_1 = {}
		local var_8_2 = var_8_0.template.vote_options

		for iter_8_0, iter_8_1 in ipairs(var_8_2) do
			var_8_1[iter_8_0] = 0
		end

		local var_8_3 = 0

		for iter_8_2, iter_8_3 in pairs(var_8_0.votes) do
			var_8_3 = var_8_3 + 1
			var_8_1[iter_8_3] = var_8_1[iter_8_3] + 1
		end

		return var_8_3, var_8_1
	end

	return 0, nil
end

VoteManager.has_voted = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.active_voting

	return var_9_0 and var_9_0.votes[arg_9_1] ~= nil
end

VoteManager.vote_in_progress = function (arg_10_0)
	local var_10_0 = arg_10_0.active_voting

	if var_10_0 then
		return var_10_0.name
	end

	return nil
end

VoteManager.active_vote_template = function (arg_11_0)
	return arg_11_0.active_voting.template
end

VoteManager.active_vote_data = function (arg_12_0)
	return arg_12_0.active_voting.data
end

VoteManager.previous_vote_info = function (arg_13_0)
	return arg_13_0.previous_voting_info
end

VoteManager.is_ingame_vote = function (arg_14_0)
	return arg_14_0.active_voting.template.ingame_vote
end

VoteManager.is_mission_vote = function (arg_15_0)
	return arg_15_0.active_voting.template.mission_vote
end

VoteManager.cancel_disabled = function (arg_16_0)
	return arg_16_0.active_voting and arg_16_0.active_voting.template.cancel_disabled
end

VoteManager.allow_vote_input = function (arg_17_0, arg_17_1)
	arg_17_0._allow_vote_input = arg_17_1
end

VoteManager.vote_time_left = function (arg_18_0)
	local var_18_0 = Managers.state.network:network_time()
	local var_18_1 = arg_18_0.active_voting

	if var_18_1 and var_18_1.end_time then
		return math.max(var_18_1.end_time - var_18_0, 0)
	end

	return nil
end

VoteManager._handle_popup_result = function (arg_19_0, arg_19_1)
	arg_19_0._popup_id = nil
end

VoteManager.update = function (arg_20_0, arg_20_1)
	local var_20_0 = Managers.state.network:network_time()

	if arg_20_0.is_server then
		arg_20_0:_server_update(arg_20_1, var_20_0)
	else
		arg_20_0:_client_update(arg_20_1, var_20_0)
	end

	if arg_20_0._popup_id then
		local var_20_1 = Managers.popup:query_result(arg_20_0._popup_id)

		if var_20_1 then
			arg_20_0:_handle_popup_result(var_20_1)
		end
	end

	if arg_20_0._allow_vote_input then
		local var_20_2 = arg_20_0.active_voting

		if var_20_2 and var_20_2.template.ingame_vote and not arg_20_0:has_voted(Network.peer_id()) then
			local var_20_3 = arg_20_0.input_manager
			local var_20_4 = var_20_3:is_device_active("gamepad")
			local var_20_5 = var_20_3:get_service("ingame_menu")
			local var_20_6 = var_20_2.template.vote_options
			local var_20_7 = #var_20_6
			local var_20_8 = var_20_2.input_hold_timer or 0

			for iter_20_0 = 1, var_20_7 do
				local var_20_9 = var_20_6[iter_20_0]

				if var_20_4 then
					local var_20_10 = var_20_9.input

					if var_20_5:get(var_20_10, true) then
						if var_20_10 ~= var_20_2.current_hold_input then
							var_20_2.current_hold_input = var_20_10
							var_20_8 = 0
						end

						local var_20_11 = var_20_9.input_hold_time

						if var_20_8 == var_20_11 then
							var_20_2.input_hold_timer = nil

							arg_20_0:vote(var_20_9.vote)
						else
							var_20_2.input_hold_timer = math.min(var_20_8 + arg_20_1, var_20_11)
							var_20_2.input_hold_progress = var_20_2.input_hold_timer / var_20_11
						end
					elseif var_20_10 == var_20_2.current_hold_input then
						var_20_2.current_hold_input = nil
						var_20_2.input_hold_timer = nil
						var_20_2.input_hold_progress = nil
					end
				elseif var_20_5:get(var_20_9.input, true) then
					arg_20_0:vote(var_20_9.vote)
				end
			end
		end
	end
end

VoteManager._time_ended = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.active_voting

	if var_21_0.end_time and arg_21_1 >= var_21_0.end_time then
		return true
	end

	return false
end

VoteManager._vote_result = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.active_voting
	local var_22_1 = var_22_0.template
	local var_22_2, var_22_3 = arg_22_0:_number_of_votes()
	local var_22_4 = #var_22_0.voters
	local var_22_5 = var_22_1.minimum_voter_percent
	local var_22_6 = var_22_1.success_percent or 0.51

	if var_22_4 < (var_22_1.min_required_voters or 1) then
		return 0
	end

	if arg_22_1 or var_22_2 == var_22_4 then
		for iter_22_0, iter_22_1 in ipairs(var_22_3) do
			if var_22_6 <= iter_22_1 / var_22_2 then
				return iter_22_0
			end
		end
	end

	if var_22_5 and var_22_5 <= var_22_2 / var_22_4 or false or var_22_2 == var_22_4 then
		return 0
	end

	return nil
end

VoteManager.hot_join_sync = function (arg_23_0, arg_23_1)
	local var_23_0 = PEER_ID_TO_CHANNEL[arg_23_1]

	if arg_23_0.active_voting then
		local var_23_1 = arg_23_0.active_voting
		local var_23_2 = var_23_1.template
		local var_23_3 = NetworkLookup.voting_types[var_23_2.name]
		local var_23_4 = var_23_2.pack_sync_data(var_23_1.data)
		local var_23_5 = var_23_2.server_start_vote_rpc
		local var_23_6 = var_23_1.voters

		RPC[var_23_5](var_23_0, var_23_3, var_23_4, var_23_6)

		local var_23_7 = var_23_1.votes

		for iter_23_0, iter_23_1 in pairs(var_23_7) do
			RPC.rpc_client_add_vote(var_23_0, iter_23_0, iter_23_1)
		end
	end

	RPC.rpc_client_vote_kick_enabled(var_23_0, arg_23_0._vote_kick_enabled)
end

VoteManager.destroy = function (arg_24_0)
	arg_24_0.network_event_delegate:unregister(arg_24_0)

	arg_24_0.network_event_delegate = nil

	if arg_24_0._popup_id then
		Managers.popup:cancel_popup(arg_24_0._popup_id)

		arg_24_0._popup_id = nil
	end
end

VoteManager._server_start_vote = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = VoteTemplates[arg_25_1]
	local var_25_1 = Managers.state.network:network_time()

	arg_25_0.active_voting = {
		name = arg_25_1,
		template = var_25_0,
		end_time = var_25_0.duration and var_25_1 + var_25_0.duration or nil,
		votes = {},
		voters = arg_25_0:_get_voter_start_list(arg_25_2),
		data = arg_25_3
	}

	if var_25_0.on_start then
		var_25_0.on_start(arg_25_0.ingame_context, arg_25_3)
	end

	local var_25_2 = var_25_0.start_sound_event

	if var_25_2 then
		arg_25_0:play_sound(var_25_2)
	end
end

VoteManager._get_voter_start_list = function (arg_26_0, arg_26_1)
	local var_26_0 = {}

	if arg_26_1 then
		for iter_26_0 = 1, #arg_26_1 do
			var_26_0[arg_26_1[iter_26_0]] = true
		end
	end

	local var_26_1 = {}
	local var_26_2 = Managers.player:human_players()

	for iter_26_1, iter_26_2 in pairs(var_26_2) do
		local var_26_3 = iter_26_2.peer_id

		if not var_26_0[var_26_3] then
			var_26_1[#var_26_1 + 1] = var_26_3
		end
	end

	return var_26_1
end

local var_0_3 = {}

VoteManager._update_voter_list_by_active_peers = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	table.clear(var_0_3)

	local var_27_0 = Managers.player:human_players()

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		arg_27_1[iter_27_1.peer_id] = true
	end

	local var_27_1 = false

	for iter_27_2 = #arg_27_2, 1, -1 do
		local var_27_2 = arg_27_2[iter_27_2]

		if not arg_27_1[var_27_2] then
			table.remove(arg_27_2, iter_27_2)

			var_0_3[#var_0_3 + 1] = var_27_2
			var_27_1 = true
		end
	end

	for iter_27_3 = 1, #var_0_3 do
		local var_27_3 = var_0_3[iter_27_3]

		if arg_27_3[var_27_3] ~= nil then
			arg_27_3[var_27_3] = nil
		end
	end

	return var_27_1
end

VoteManager.rpc_vote = function (arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0.active_voting then
		local var_28_0

		if arg_28_1 == var_0_2 then
			var_28_0 = Network.peer_id()
		else
			var_28_0 = CHANNEL_TO_PEER_ID[arg_28_1]
		end

		if arg_28_0:has_voted(var_28_0) then
			return
		end

		Managers.state.network.network_transmit:send_rpc_clients("rpc_client_add_vote", var_28_0, arg_28_2)
		arg_28_0:_server_add_vote(var_28_0, arg_28_2)
	end
end

VoteManager._server_add_vote = function (arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.active_voting.votes[arg_29_1] = arg_29_2
end

VoteManager._handle_requirement_results = function (arg_30_0, arg_30_1)
	local var_30_0 = true
	local var_30_1 = true
	local var_30_2 = arg_30_1.votes_require_type

	for iter_30_0, iter_30_1 in pairs(arg_30_1.voters) do
		if arg_30_1.results[iter_30_0] == nil then
			var_30_0 = false
		elseif var_30_2 == "all" and not arg_30_1.results[iter_30_0] then
			var_30_1 = false
		elseif var_30_2 == "any" and arg_30_1.results[iter_30_0] then
			var_30_1 = true
		end
	end

	return var_30_0, var_30_1
end

VoteManager._server_handle_requirement_check = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0._requirement_check_data
	local var_31_1 = arg_31_0:_active_peers()

	arg_31_0:_update_voter_list_by_active_peers(var_31_1, var_31_0.voters, var_31_0.results)

	local var_31_2, var_31_3 = arg_31_0:_handle_requirement_results(var_31_0)

	if var_31_2 then
		arg_31_0._requirement_check_data = nil

		if var_31_3 then
			local var_31_4 = true
			local var_31_5 = var_31_0.vote_name
			local var_31_6 = var_31_0.vote_data
			local var_31_7 = var_31_0.voter_peer_id

			arg_31_0:request_vote(var_31_5, var_31_6, var_31_7, var_31_4)
		else
			local var_31_8 = var_31_0.vote_name
			local var_31_9 = VoteTemplates[var_31_8]
			local var_31_10 = var_31_9.requirement_failed_message or var_31_9.requirement_failed_message_func(var_31_0) or ""
			local var_31_11 = NetworkLookup.voting_types[var_31_8]
			local var_31_12 = var_31_0.voter_peer_id

			Managers.state.network.network_transmit:send_rpc("rpc_requirement_failed", var_31_12, var_31_11, var_31_10)
		end
	end
end

VoteManager._server_update = function (arg_32_0, arg_32_1, arg_32_2)
	if arg_32_0._requirement_check_data then
		arg_32_0:_server_handle_requirement_check(arg_32_1, arg_32_2)

		return
	end

	local var_32_0 = arg_32_0.active_voting

	if not var_32_0 then
		return
	end

	if not Managers.state.network:game() then
		return
	end

	local var_32_1 = arg_32_0:_active_peers()

	if arg_32_0:_update_voter_list_by_active_peers(var_32_1, var_32_0.voters, var_32_0.votes) then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_update_voters_list", var_32_0.voters)
	end

	local var_32_2 = arg_32_0:_time_ended(arg_32_2)

	if var_32_2 then
		arg_32_0:_handle_undecided_votes(var_32_0)
	end

	local var_32_3 = arg_32_0:_vote_result(var_32_2)

	if var_32_3 ~= nil then
		local var_32_4 = var_32_0.template.on_complete(var_32_3, arg_32_0.ingame_context, var_32_0.data)

		Managers.state.network.network_transmit:send_rpc_all("rpc_client_complete_vote", var_32_3)
	elseif var_32_2 then
		local var_32_5 = var_32_0.template.on_complete(0, arg_32_0.ingame_context, var_32_0.data)

		Managers.state.network.network_transmit:send_rpc_all("rpc_client_complete_vote", 0)
	end
end

VoteManager._handle_undecided_votes = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1.template.timeout_vote_option

	if not var_33_0 then
		return
	end

	local var_33_1 = arg_33_1.voters
	local var_33_2 = arg_33_1.votes

	for iter_33_0 = 1, #var_33_1 do
		local var_33_3 = var_33_1[iter_33_0]

		if not var_33_2[var_33_3] then
			local var_33_4 = PEER_ID_TO_CHANNEL[var_33_3]

			arg_33_0:rpc_vote(var_33_4, var_33_0)
		end
	end
end

VoteManager.rpc_server_request_start_vote_base = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = NetworkLookup.voting_types[arg_34_2]
	local var_34_1 = VoteTemplates[var_34_0].extract_sync_data(arg_34_3)
	local var_34_2 = CHANNEL_TO_PEER_ID[arg_34_1]

	arg_34_0:request_vote(var_34_0, var_34_1, var_34_2)
end

VoteManager.rpc_server_request_start_vote_peer_id = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_0:rpc_server_request_start_vote_base(arg_35_1, arg_35_2, arg_35_3)
end

VoteManager.rpc_server_request_start_vote_lookup = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	arg_36_0:rpc_server_request_start_vote_base(arg_36_1, arg_36_2, arg_36_3)
end

VoteManager.rpc_server_request_start_vote_deed = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	arg_37_0:rpc_server_request_start_vote_base(arg_37_1, arg_37_2, arg_37_3)
end

VoteManager._start_vote_base = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = NetworkLookup.voting_types[arg_38_2]
	local var_38_1 = VoteTemplates[var_38_0]

	fassert(var_38_1, "Could not find voting template by name: %q", var_38_0)

	local var_38_2 = Managers.state.network:network_time()
	local var_38_3 = var_38_1.extract_sync_data(arg_38_3)

	arg_38_0.active_voting = {
		name = var_38_0,
		template = var_38_1,
		end_time = var_38_1.duration and var_38_2 + var_38_1.duration or nil,
		voters = arg_38_4,
		votes = {},
		data = var_38_3
	}
end

VoteManager.rpc_client_start_vote_peer_id = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	arg_39_0:_start_vote_base(arg_39_1, arg_39_2, arg_39_3, arg_39_4)
end

VoteManager.rpc_client_start_vote_lookup = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	arg_40_0:_start_vote_base(arg_40_1, arg_40_2, arg_40_3, arg_40_4)
end

VoteManager.rpc_client_start_vote_deed = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	arg_41_0:_start_vote_base(arg_41_1, arg_41_2, arg_41_3, arg_41_4)
end

VoteManager.rpc_client_add_vote = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_0.active_voting

	if var_42_0 then
		var_42_0.votes[arg_42_2] = arg_42_3
	end
end

VoteManager.rpc_client_complete_vote = function (arg_43_0, arg_43_1, arg_43_2)
	if arg_43_0.active_voting then
		local var_43_0, var_43_1 = arg_43_0:_number_of_votes()

		arg_43_0.previous_voting_info = {
			text = arg_43_0.active_voting.text,
			number_of_votes = var_43_0,
			vote_results = var_43_1,
			vote_result = arg_43_2,
			votes = arg_43_0.active_voting.votes
		}

		if arg_43_0:is_mission_vote() then
			if arg_43_2 == 1 then
				arg_43_0:play_sound("play_gui_mission_vote_outcome_yes")
			else
				arg_43_0:play_sound("play_gui_mission_vote_outcome_no")
			end
		end
	end

	arg_43_0.active_voting = nil
end

VoteManager.rpc_client_vote_kick_enabled = function (arg_44_0, arg_44_1, arg_44_2)
	arg_44_0._vote_kick_enabled = arg_44_2
end

VoteManager.rpc_update_voters_list = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0.active_voting

	if var_45_0 then
		local var_45_1 = {}

		for iter_45_0 = 1, #arg_45_2 do
			var_45_1[arg_45_2[iter_45_0]] = true
		end

		local var_45_2 = arg_45_0:_update_voter_list_by_active_peers(var_45_1, var_45_0.voters, var_45_0.votes)

		if not var_45_2 then
			table.dump(arg_45_2, "voters")
			table.dump(var_45_1, "active_peers")
		end

		fassert(var_45_2, "What?")
	end
end

VoteManager.rpc_client_check_dlc = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = true

	for iter_46_0, iter_46_1 in ipairs(arg_46_2) do
		local var_46_1 = NetworkLookup.dlcs[iter_46_1]

		if not Managers.unlock:is_dlc_unlocked(var_46_1) then
			var_46_0 = false

			break
		end
	end

	Managers.state.network.network_transmit:send_rpc_server("rpc_server_check_dlc_reply", var_46_0)
end

VoteManager.rpc_server_check_dlc_reply = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._requirement_check_data
	local var_47_1 = CHANNEL_TO_PEER_ID[arg_47_1]

	var_47_0.results[var_47_1] = arg_47_2
end

VoteManager.rpc_requirement_failed = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = Localize("required_power_level_not_met_in_party")
	local var_48_1 = NetworkLookup.voting_types[arg_48_2]

	arg_48_0._popup_id = Managers.popup:queue_popup(arg_48_3, var_48_0, "ok", Localize("button_ok"))
end

VoteManager._client_update = function (arg_49_0, arg_49_1, arg_49_2)
	return
end

VoteManager.set_vote_kick_enabled = function (arg_50_0, arg_50_1)
	if arg_50_0.is_server then
		arg_50_0._vote_kick_enabled = arg_50_1

		Managers.state.network.network_transmit:send_rpc_clients("rpc_client_vote_kick_enabled", arg_50_1)
	end
end

VoteManager.vote_kick_enabled = function (arg_51_0)
	if arg_51_0._vote_kick_enabled then
		return Managers.player:num_human_players() > 2
	end

	return false
end

VoteManager.play_sound = function (arg_52_0, arg_52_1)
	WwiseWorld.trigger_event(arg_52_0.wwise_world, arg_52_1)
end

local var_0_4 = {}

VoteManager.get_current_voters = function (arg_53_0)
	table.clear(var_0_4)

	if arg_53_0.active_voting then
		local var_53_0 = arg_53_0.active_voting.votes
		local var_53_1 = arg_53_0.active_voting.voters
		local var_53_2 = #var_53_1

		for iter_53_0 = 1, var_53_2 do
			local var_53_3 = var_53_1[iter_53_0]
			local var_53_4 = var_53_0[var_53_3]

			if var_53_4 == nil then
				var_53_4 = "undecided"
			end

			var_0_4[var_53_3] = var_53_4
		end
	end

	return var_0_4
end

local var_0_5 = {}

VoteManager._active_peers = function (arg_54_0)
	table.clear(var_0_5)

	local var_54_0 = Managers.player:human_players()

	for iter_54_0, iter_54_1 in pairs(var_54_0) do
		local var_54_1 = iter_54_1.peer_id

		var_0_5[var_54_1] = true
	end

	return var_0_5
end
