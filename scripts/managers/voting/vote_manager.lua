-- chunkname: @scripts/managers/voting/vote_manager.lua

require("scripts/managers/voting/vote_templates")

VoteManager = class(VoteManager)

local tbl = {
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

VoteManager.init = function (self, arg_1_1)
	-- function 1
	self.is_server = arg_1_1.is_server
	self.network_event_delegate = arg_1_1.network_event_delegate
	self.input_manager = arg_1_1.input_manager
	self.wwise_world = arg_1_1.wwise_world
	self.ingame_context = arg_1_1

	self.network_event_delegate:register(self, unpack(tbl))

	self._vote_kick_enabled = true
end

local tbl_2 = {}

VoteManager._gather_dlc_dependencies = function (arg_2_0, arg_2_1)
	-- function 2
	table.clear(tbl_2)

	local var_2_0
	local mechanism = arg_2_1.mechanism
	local flag = not mechanism and MechanismSettings[mechanism]

	if not flag and not flag.required_dlc then
		tbl_2[#tbl_2 + 1] = NetworkLookup.dlcs[flag.required_dlc]
		var_2_0 = "all"
	end

	local difficulty = arg_2_1.difficulty
	local var_2_4 = DifficultySettings[difficulty]

	if not var_2_4 and not var_2_4.dlc_requirement then
		tbl_2[#tbl_2 + 1] = NetworkLookup.dlcs[var_2_4.dlc_requirement]
		var_2_0 = var_2_0 ~= "all" or not "all" or "any"
	end

	if #tbl_2 > 0 then
		return tbl_2, var_2_0
	end
end

VoteManager.request_vote = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0 = VoteTemplates[arg_3_1]

	fassert(var_3_0, "Could not find voting template by name: %q", arg_3_1)
	fassert(arg_3_3 ~= nil, "No voter peer id sent")

	local var_3_1 = NetworkLookup.voting_types[arg_3_1]

	arg_3_2 = arg_3_2 or {}
	arg_3_2.voter_peer_id = arg_3_3

	if not self.is_server then
		if not self:can_start_vote(arg_3_1, arg_3_2) then
			local var_3_2
			local var_3_3

			if not arg_3_4 then
				var_3_2, var_3_3 = self:_gather_dlc_dependencies(arg_3_2)
			end

			if not var_3_2 then
				self._requirement_check_data = {
					vote_name = arg_3_1,
					results = {},
					voters = self:_active_peers(),
					vote_data = arg_3_2,
					voter_peer_id = arg_3_3 or Network.peer_id(),
					votes_require_type = var_3_3
				}

				Managers.state.network.network_transmit:send_rpc_all("rpc_client_check_dlc", var_3_2)

				return false
			else
				self:_server_abort_active_vote()
				self:_server_start_vote(arg_3_1, nil, arg_3_2)

				local pack_sync_data = var_3_0.pack_sync_data(arg_3_2)
				local server_start_vote_rpc = var_3_0.server_start_vote_rpc
				local voters = self.active_voting.voters

				if not script_data.debug_vote_manager then
					Managers.state.network.network_transmit:send_rpc_all(server_start_vote_rpc, var_3_1, pack_sync_data, voters)
				elseif not DEDICATED_SERVER then
					local player_from_peer_id = Managers.player:player_from_peer_id(arg_3_3, 1)
					local get_party

					if not player_from_peer_id then
						get_party = player_from_peer_id:get_party()

						if not get_party then
							-- Nothing
						end
					end

					get_party = nil

					::label_3_0::

					if not get_party then
						Managers.state.network.network_transmit:send_rpc_party_clients(server_start_vote_rpc, get_party, true, var_3_1, pack_sync_data, voters)
					end
				else
					Managers.state.network.network_transmit:send_rpc_clients(server_start_vote_rpc, var_3_1, pack_sync_data, voters)
				end

				if script_data.debug_vote_manager or not var_3_0.initial_vote_func then
					local initial_vote_func = var_3_0.initial_vote_func(arg_3_2)

					for k, v in pairs(initial_vote_func) do
						local var_3_10 = PEER_ID_TO_CHANNEL[k]

						self:rpc_vote(var_3_10, v)
					end

					if not initial_vote_func[Network.peer_id()] then
						self:play_sound("play_gui_mission_vote")
					end
				end

				return true
			end
		end
	elseif not Managers.state.network:game() then
		local client_start_vote_rpc = var_3_0.client_start_vote_rpc
		local pack_sync_data_2 = var_3_0.pack_sync_data(arg_3_2)

		Managers.state.network.network_transmit:send_rpc_server(client_start_vote_rpc, var_3_1, pack_sync_data_2)

		if not var_3_0.initial_vote_func and not var_3_0.initial_vote_func(arg_3_2)[Network.peer_id()] then
			self:play_sound("play_gui_mission_vote")
		end
	end
end

VoteManager._server_abort_active_vote = function (self)
	-- function 4
	local active_voting = self.active_voting

	if not active_voting then
		local ingame_context = self.ingame_context
		local data = active_voting.data
		local on_complete = active_voting.template.on_complete(0, ingame_context, data)

		self:rpc_client_complete_vote(nil, 0)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_client_complete_vote", 0)
	end
end

VoteManager._trigger_can_vote_fail_reply = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0 = NetworkLookup.voting_types[arg_5_1]
	local voter_peer_id = arg_5_2.voter_peer_id

	Managers.state.network.network_transmit:send_rpc("rpc_requirement_failed", voter_peer_id, var_5_0, arg_5_3)
end

VoteManager.can_start_vote = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = VoteTemplates[arg_6_1]

	if not var_6_0.can_start_vote then
		local can_start_vote, var_6_2 = var_6_0.can_start_vote(arg_6_2)

		if not can_start_vote then
			if not var_6_2 then
				self:_trigger_can_vote_fail_reply(arg_6_1, arg_6_2, var_6_2)
			end

			return false
		end
	end

	local num_human_players = Managers.player:num_human_players()
	local min_required_voters = var_6_0.min_required_voters

	min_required_voters = min_required_voters or 1

	if not (min_required_voters <= num_human_players) then
		return false
	end

	if not self._requirement_check_data then
		return false
	end

	local active_voting = self.active_voting

	if not (not active_voting and not (var_6_0.priority <= active_voting.template.priority)) then
		return false
	end

	return true
end

local str = "LOCAL_CALL"

VoteManager.vote = function (self, arg_7_1)
	-- function 7
	local flag = arg_7_1 ~= nil

	fassert(flag, "Incorrect vote: %s. Casteted by: %s", arg_7_1, Network.peer_id())

	local is_server = self.is_server
	local network = Managers.state.network

	if not is_server then
		local var_7_3 = CHANNEL_TO_PEER_ID[Network.peer_id()]

		self:rpc_vote(str, arg_7_1)
	elseif not network:in_game_session() then
		network.network_transmit:send_rpc_server("rpc_vote", arg_7_1)
	end
end

VoteManager._number_of_votes = function (self)
	-- function 8
	local active_voting = self.active_voting

	if not active_voting then
		local tbl = {}
		local vote_options = active_voting.template.vote_options

		for i, v in ipairs(vote_options) do
			tbl[i] = 0
		end

		local num = 0

		for k, v_2 in pairs(active_voting.votes) do
			num = num + 1
			tbl[v_2] = tbl[v_2] + 1
		end

		return num, tbl
	end

	return 0, nil
end

VoteManager.has_voted = function (self, arg_9_1)
	-- function 9
	local active_voting = self.active_voting

	return not active_voting and active_voting.votes[arg_9_1] ~= nil
end

VoteManager.vote_in_progress = function (self)
	-- function 10
	local active_voting = self.active_voting

	if not active_voting then
		return active_voting.name
	end

	return nil
end

VoteManager.active_vote_template = function (self)
	-- function 11
	return self.active_voting.template
end

VoteManager.active_vote_data = function (self)
	-- function 12
	return self.active_voting.data
end

VoteManager.previous_vote_info = function (self)
	-- function 13
	return self.previous_voting_info
end

VoteManager.is_ingame_vote = function (self)
	-- function 14
	return self.active_voting.template.ingame_vote
end

VoteManager.is_mission_vote = function (self)
	-- function 15
	return self.active_voting.template.mission_vote
end

VoteManager.cancel_disabled = function (self)
	-- function 16
	local active_voting = self.active_voting

	active_voting = not active_voting and self.active_voting.template.cancel_disabled

	return active_voting
end

VoteManager.allow_vote_input = function (self, arg_17_1)
	-- function 17
	self._allow_vote_input = arg_17_1
end

VoteManager.vote_time_left = function (self)
	-- function 18
	local network_time = Managers.state.network:network_time()
	local active_voting = self.active_voting

	if not active_voting and not active_voting.end_time then
		return math.max(active_voting.end_time - network_time, 0)
	end

	return nil
end

VoteManager._handle_popup_result = function (self, arg_19_1)
	-- function 19
	self._popup_id = nil
end

VoteManager.update = function (self, arg_20_1)
	-- function 20
	local network_time = Managers.state.network:network_time()

	if not self.is_server then
		self:_server_update(arg_20_1, network_time)
	else
		self:_client_update(arg_20_1, network_time)
	end

	if not self._popup_id then
		local query_result = Managers.popup:query_result(self._popup_id)

		if not query_result then
			self:_handle_popup_result(query_result)
		end
	end

	if not self._allow_vote_input then
		local active_voting = self.active_voting

		if not (not active_voting and not active_voting.template.ingame_vote and self:has_voted(Network.peer_id())) then
			local input_manager = self.input_manager
			local is_device_active = input_manager:is_device_active("gamepad")
			local get_service = input_manager:get_service("ingame_menu")
			local vote_options = active_voting.template.vote_options
			local count = #vote_options
			local input_hold_timer = active_voting.input_hold_timer

			input_hold_timer = input_hold_timer or 0

			for i = 1, count do
				local var_20_9 = vote_options[i]

				if not is_device_active then
					local input = var_20_9.input

					if not get_service:get(input, true) then
						if input ~= active_voting.current_hold_input then
							active_voting.current_hold_input = input
							input_hold_timer = 0
						end

						local input_hold_time = var_20_9.input_hold_time

						if input_hold_timer == input_hold_time then
							active_voting.input_hold_timer = nil

							self:vote(var_20_9.vote)
						else
							active_voting.input_hold_timer = math.min(input_hold_timer + arg_20_1, input_hold_time)
							active_voting.input_hold_progress = active_voting.input_hold_timer / input_hold_time
						end
					elseif input == active_voting.current_hold_input then
						active_voting.current_hold_input = nil
						active_voting.input_hold_timer = nil
						active_voting.input_hold_progress = nil
					end
				elseif not get_service:get(var_20_9.input, true) then
					self:vote(var_20_9.vote)
				end
			end
		end
	end
end

VoteManager._time_ended = function (self, arg_21_1)
	-- function 21
	local active_voting = self.active_voting

	if not (not active_voting.end_time and not (arg_21_1 >= active_voting.end_time)) then
		return true
	end

	return false
end

VoteManager._vote_result = function (self, arg_22_1)
	-- function 22
	local active_voting = self.active_voting
	local template = active_voting.template
	local _number_of_votes, var_22_3 = self:_number_of_votes()
	local count = #active_voting.voters
	local minimum_voter_percent = template.minimum_voter_percent
	local success_percent = template.success_percent

	success_percent = success_percent or 0.51

	local min_required_voters = template.min_required_voters

	min_required_voters = min_required_voters or 1

	if count < min_required_voters then
		return 0
	end

	if not (arg_22_1 or _number_of_votes ~= count) then
		for i, v in ipairs(var_22_3) do
			if success_percent <= v / _number_of_votes then
				return i
			end
		end
	end

	if not (not minimum_voter_percent and minimum_voter_percent <= _number_of_votes / count or false or _number_of_votes ~= count) then
		return 0
	end

	return nil
end

VoteManager.hot_join_sync = function (self, arg_23_1)
	-- function 23
	local var_23_0 = PEER_ID_TO_CHANNEL[arg_23_1]

	if not self.active_voting then
		local active_voting = self.active_voting
		local template = active_voting.template
		local var_23_3 = NetworkLookup.voting_types[template.name]
		local pack_sync_data = template.pack_sync_data(active_voting.data)
		local server_start_vote_rpc = template.server_start_vote_rpc
		local voters = active_voting.voters

		RPC[server_start_vote_rpc](var_23_0, var_23_3, pack_sync_data, voters)

		local votes = active_voting.votes

		for k, v in pairs(votes) do
			RPC.rpc_client_add_vote(var_23_0, k, v)
		end
	end

	RPC.rpc_client_vote_kick_enabled(var_23_0, self._vote_kick_enabled)
end

VoteManager.destroy = function (self)
	-- function 24
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil

	if not self._popup_id then
		Managers.popup:cancel_popup(self._popup_id)

		self._popup_id = nil
	end
end

VoteManager._server_start_vote = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local var_25_0 = VoteTemplates[arg_25_1]
	local network_time = Managers.state.network:network_time()
	local tbl = {
		name = arg_25_1,
		template = var_25_0
	}
	local num

	if not var_25_0.duration then
		num = network_time + var_25_0.duration

		if not num then
			-- Nothing
		end
	end

	num = nil

	::label_25_0::

	tbl.end_time = num
	tbl.votes = {}
	tbl.voters = self:_get_voter_start_list(arg_25_2)
	tbl.data = arg_25_3
	self.active_voting = tbl

	if not var_25_0.on_start then
		var_25_0.on_start(self.ingame_context, arg_25_3)
	end

	local start_sound_event = var_25_0.start_sound_event

	if not start_sound_event then
		self:play_sound(start_sound_event)
	end
end

VoteManager._get_voter_start_list = function (arg_26_0, arg_26_1)
	-- function 26
	local tbl = {}

	if not arg_26_1 then
		for i = 1, #arg_26_1 do
			tbl[arg_26_1[i]] = true
		end
	end

	local tbl_2 = {}
	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		local peer_id = v.peer_id

		if not tbl[peer_id] then
			tbl_2[#tbl_2 + 1] = peer_id
		end
	end

	return tbl_2
end

local tbl_3 = {}

VoteManager._update_voter_list_by_active_peers = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	table.clear(tbl_3)

	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		arg_27_1[v.peer_id] = true
	end

	local flag = false

	for k_2 = #arg_27_2, 1, -1 do
		local var_27_2 = arg_27_2[k_2]

		if not arg_27_1[var_27_2] then
			table.remove(arg_27_2, k_2)

			tbl_3[#tbl_3 + 1] = var_27_2
			flag = true
		end
	end

	for l = 1, #tbl_3 do
		local var_27_3 = tbl_3[l]

		if arg_27_3[var_27_3] ~= nil then
			arg_27_3[var_27_3] = nil
		end
	end

	return flag
end

VoteManager.rpc_vote = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not self.active_voting then
		local var_28_0

		if arg_28_1 == str then
			var_28_0 = Network.peer_id()
		else
			var_28_0 = CHANNEL_TO_PEER_ID[arg_28_1]
		end

		if not self:has_voted(var_28_0) then
			return
		end

		Managers.state.network.network_transmit:send_rpc_clients("rpc_client_add_vote", var_28_0, arg_28_2)
		self:_server_add_vote(var_28_0, arg_28_2)
	end
end

VoteManager._server_add_vote = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	arg_29_0.active_voting.votes[arg_29_1] = arg_29_2
end

VoteManager._handle_requirement_results = function (arg_30_0, arg_30_1)
	-- function 30
	local flag = true
	local flag_2 = true
	local votes_require_type = arg_30_1.votes_require_type

	for k, v in pairs(arg_30_1.voters) do
		if arg_30_1.results[k] == nil then
			flag = false
		elseif not (votes_require_type ~= "all" or arg_30_1.results[k]) then
			flag_2 = false
		elseif votes_require_type ~= "any" or not arg_30_1.results[k] then
			flag_2 = true
		end
	end

	return flag, flag_2
end

VoteManager._server_handle_requirement_check = function (self, arg_31_1, arg_31_2)
	-- function 31
	local _requirement_check_data = self._requirement_check_data
	local _active_peers = self:_active_peers()

	self:_update_voter_list_by_active_peers(_active_peers, _requirement_check_data.voters, _requirement_check_data.results)

	local _handle_requirement_results, var_31_3 = self:_handle_requirement_results(_requirement_check_data)

	if not _handle_requirement_results then
		self._requirement_check_data = nil

		if not var_31_3 then
			local flag = true
			local vote_name = _requirement_check_data.vote_name
			local vote_data = _requirement_check_data.vote_data
			local voter_peer_id = _requirement_check_data.voter_peer_id

			self:request_vote(vote_name, vote_data, voter_peer_id, flag)
		else
			local vote_name_2 = _requirement_check_data.vote_name
			local var_31_9 = VoteTemplates[vote_name_2]
			local requirement_failed_message = var_31_9.requirement_failed_message

			if not requirement_failed_message then
				requirement_failed_message = var_31_9.requirement_failed_message_func(_requirement_check_data)
				requirement_failed_message = requirement_failed_message or ""
			end

			local var_31_11 = NetworkLookup.voting_types[vote_name_2]
			local voter_peer_id_2 = _requirement_check_data.voter_peer_id

			Managers.state.network.network_transmit:send_rpc("rpc_requirement_failed", voter_peer_id_2, var_31_11, requirement_failed_message)
		end
	end
end

VoteManager._server_update = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not self._requirement_check_data then
		self:_server_handle_requirement_check(arg_32_1, arg_32_2)

		return
	end

	local active_voting = self.active_voting

	if not active_voting then
		return
	end

	if not Managers.state.network:game() then
		return
	end

	local _active_peers = self:_active_peers()

	if not self:_update_voter_list_by_active_peers(_active_peers, active_voting.voters, active_voting.votes) then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_update_voters_list", active_voting.voters)
	end

	local _time_ended = self:_time_ended(arg_32_2)

	if not _time_ended then
		self:_handle_undecided_votes(active_voting)
	end

	local _vote_result = self:_vote_result(_time_ended)

	if _vote_result ~= nil then
		local on_complete = active_voting.template.on_complete(_vote_result, self.ingame_context, active_voting.data)

		Managers.state.network.network_transmit:send_rpc_all("rpc_client_complete_vote", _vote_result)
	elseif not _time_ended then
		local on_complete_2 = active_voting.template.on_complete(0, self.ingame_context, active_voting.data)

		Managers.state.network.network_transmit:send_rpc_all("rpc_client_complete_vote", 0)
	end
end

VoteManager._handle_undecided_votes = function (self, arg_33_1)
	-- function 33
	local timeout_vote_option = arg_33_1.template.timeout_vote_option

	if not timeout_vote_option then
		return
	end

	local voters = arg_33_1.voters
	local votes = arg_33_1.votes

	for i = 1, #voters do
		local var_33_3 = voters[i]

		if not votes[var_33_3] then
			local var_33_4 = PEER_ID_TO_CHANNEL[var_33_3]

			self:rpc_vote(var_33_4, timeout_vote_option)
		end
	end
end

VoteManager.rpc_server_request_start_vote_base = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local var_34_0 = NetworkLookup.voting_types[arg_34_2]
	local extract_sync_data = VoteTemplates[var_34_0].extract_sync_data(arg_34_3)
	local var_34_2 = CHANNEL_TO_PEER_ID[arg_34_1]

	self:request_vote(var_34_0, extract_sync_data, var_34_2)
end

VoteManager.rpc_server_request_start_vote_peer_id = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	self:rpc_server_request_start_vote_base(arg_35_1, arg_35_2, arg_35_3)
end

VoteManager.rpc_server_request_start_vote_lookup = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	self:rpc_server_request_start_vote_base(arg_36_1, arg_36_2, arg_36_3)
end

VoteManager.rpc_server_request_start_vote_deed = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	self:rpc_server_request_start_vote_base(arg_37_1, arg_37_2, arg_37_3)
end

VoteManager._start_vote_base = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	local var_38_0 = NetworkLookup.voting_types[arg_38_2]
	local var_38_1 = VoteTemplates[var_38_0]

	fassert(var_38_1, "Could not find voting template by name: %q", var_38_0)

	local network_time = Managers.state.network:network_time()
	local extract_sync_data = var_38_1.extract_sync_data(arg_38_3)
	local tbl = {
		name = var_38_0,
		template = var_38_1
	}
	local num

	if not var_38_1.duration then
		num = network_time + var_38_1.duration

		if not num then
			-- Nothing
		end
	end

	num = nil

	::label_38_0::

	tbl.end_time = num
	tbl.voters = arg_38_4
	tbl.votes = {}
	tbl.data = extract_sync_data
	self.active_voting = tbl
end

VoteManager.rpc_client_start_vote_peer_id = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	self:_start_vote_base(arg_39_1, arg_39_2, arg_39_3, arg_39_4)
end

VoteManager.rpc_client_start_vote_lookup = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	self:_start_vote_base(arg_40_1, arg_40_2, arg_40_3, arg_40_4)
end

VoteManager.rpc_client_start_vote_deed = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	self:_start_vote_base(arg_41_1, arg_41_2, arg_41_3, arg_41_4)
end

VoteManager.rpc_client_add_vote = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local active_voting = self.active_voting

	if not active_voting then
		active_voting.votes[arg_42_2] = arg_42_3
	end
end

VoteManager.rpc_client_complete_vote = function (self, arg_43_1, arg_43_2)
	-- function 43
	if not self.active_voting then
		local _number_of_votes, var_43_1 = self:_number_of_votes()

		self.previous_voting_info = {
			text = self.active_voting.text,
			number_of_votes = _number_of_votes,
			vote_results = var_43_1,
			vote_result = arg_43_2,
			votes = self.active_voting.votes
		}

		if not self:is_mission_vote() then
			if arg_43_2 == 1 then
				self:play_sound("play_gui_mission_vote_outcome_yes")
			else
				self:play_sound("play_gui_mission_vote_outcome_no")
			end
		end
	end

	self.active_voting = nil
end

VoteManager.rpc_client_vote_kick_enabled = function (self, arg_44_1, arg_44_2)
	-- function 44
	self._vote_kick_enabled = arg_44_2
end

VoteManager.rpc_update_voters_list = function (self, arg_45_1, arg_45_2)
	-- function 45
	local active_voting = self.active_voting

	if not active_voting then
		local tbl = {}

		for i = 1, #arg_45_2 do
			tbl[arg_45_2[i]] = true
		end

		local _update_voter_list_by_active_peers = self:_update_voter_list_by_active_peers(tbl, active_voting.voters, active_voting.votes)

		if not _update_voter_list_by_active_peers then
			table.dump(arg_45_2, "voters")
			table.dump(tbl, "active_peers")
		end

		fassert(_update_voter_list_by_active_peers, "What?")
	end
end

VoteManager.rpc_client_check_dlc = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	local flag = true

	for i, v in ipairs(arg_46_2) do
		local var_46_1 = NetworkLookup.dlcs[v]

		if not Managers.unlock:is_dlc_unlocked(var_46_1) then
			flag = false

			break
		end
	end

	Managers.state.network.network_transmit:send_rpc_server("rpc_server_check_dlc_reply", flag)
end

VoteManager.rpc_server_check_dlc_reply = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _requirement_check_data = self._requirement_check_data
	local var_47_1 = CHANNEL_TO_PEER_ID[arg_47_1]

	_requirement_check_data.results[var_47_1] = arg_47_2
end

VoteManager.rpc_requirement_failed = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local var_48_0 = Localize("required_power_level_not_met_in_party")
	local var_48_1 = NetworkLookup.voting_types[arg_48_2]

	self._popup_id = Managers.popup:queue_popup(arg_48_3, var_48_0, "ok", Localize("button_ok"))
end

VoteManager._client_update = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	return
end

VoteManager.set_vote_kick_enabled = function (self, arg_50_1)
	-- function 50
	if not self.is_server then
		self._vote_kick_enabled = arg_50_1

		Managers.state.network.network_transmit:send_rpc_clients("rpc_client_vote_kick_enabled", arg_50_1)
	end
end

VoteManager.vote_kick_enabled = function (self)
	-- function 51
	if not self._vote_kick_enabled then
		return Managers.player:num_human_players() > 2
	end

	return false
end

VoteManager.play_sound = function (self, arg_52_1)
	-- function 52
	WwiseWorld.trigger_event(self.wwise_world, arg_52_1)
end

local tbl_4 = {}

VoteManager.get_current_voters = function (self)
	-- function 53
	table.clear(tbl_4)

	if not self.active_voting then
		local votes = self.active_voting.votes
		local voters = self.active_voting.voters
		local count = #voters

		for i = 1, count do
			local var_53_3 = voters[i]
			local var_53_4 = votes[var_53_3]

			if var_53_4 == nil then
				var_53_4 = "undecided"
			end

			tbl_4[var_53_3] = var_53_4
		end
	end

	return tbl_4
end

local tbl_5 = {}

VoteManager._active_peers = function (arg_54_0)
	-- function 54
	table.clear(tbl_5)

	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		local peer_id = v.peer_id

		tbl_5[peer_id] = true
	end

	return tbl_5
end
