-- chunkname: @scripts/managers/matchmaking/matchmaking_state_flexmatch_host.lua

local scripts_managers_backend_playfab_settings_flexmatch_queue_status = require("scripts/managers/backend_playfab/settings/flexmatch_queue_status")

MatchmakingStateFlexmatchHost = class(MatchmakingStateFlexmatchHost)
MatchmakingStateFlexmatchHost.NAME = "MatchmakingStateFlexmatchHost"

local tbl = {
	CollectingTickets = "CollectingTickets",
	RequestingRegions = "RequestingRegions",
	Succeeded = "Succeeded",
	InQueue = "InQueue",
	StartingMatchmaking = "StartingMatchmaking",
	CheckingLatency = "CheckingLatency",
	RequestingTicket = "RequestingTicket",
	WaitingForMatchmaking = "WaitingForMatchmaking",
	Init = "Init"
}
local num = 3
local num_2 = 10
local num_3 = 30
local num_4 = 60
local num_5 = 5
local num_6 = 2
local tbl_2 = {}

local function fn(arg_1_0, ...)
	-- function 1
	arg_1_0 = "[Flexmatch] " .. arg_1_0

	printf(arg_1_0, ...)
end

MatchmakingStateFlexmatchHost.init = function (self, arg_2_1)
	-- function 2
	self._network_transmit = arg_2_1.network_transmit
	self._network_options = arg_2_1.network_options
	self._lobby = arg_2_1.lobby
end

MatchmakingStateFlexmatchHost.terminate = function (arg_3_0)
	-- function 3
	return
end

MatchmakingStateFlexmatchHost.destroy = function (self)
	-- function 4
	self:_cleanup()
end

MatchmakingStateFlexmatchHost.on_enter = function (self, arg_5_1)
	-- function 5
	self._state_context = arg_5_1

	local lobby_members = arg_5_1.search_config.party_lobby_host.lobby_members

	self._tt_next_matchmaking_check = 0
	self._timeout = math.huge
	self._ignore_results = false
	self._estimated_wait_time = -1
	self._queue_tickets = {}

	for k, v in pairs(lobby_members.members) do
		self._queue_tickets[k] = false
	end

	Managers.state.event:register(self, "friend_party_peer_left", "on_friend_party_peer_left")

	self._region_latency = {}
	self._state = tbl.Init
end

MatchmakingStateFlexmatchHost.on_exit = function (self)
	-- function 6
	self:_cleanup()
end

MatchmakingStateFlexmatchHost.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if self._state == tbl.Init then
		self._state = tbl.RequestingRegions
	elseif self._state == tbl.RequestingRegions then
		return self:_update_requesting_regions(arg_7_1, arg_7_2)
	elseif self._state == tbl.CheckingLatency then
		return self:_update_checking_latency(arg_7_1, arg_7_2)
	elseif self._state == tbl.RequestingTicket then
		return self:_update_requesting_ticket(arg_7_1, arg_7_2)
	elseif self._state == tbl.CollectingTickets then
		return self:_update_collecting_tickets(arg_7_1, arg_7_2)
	elseif self._state == tbl.StartingMatchmaking then
		return self:_update_starting_matchmaking(arg_7_1, arg_7_2)
	elseif self._state == tbl.WaitingForMatchmaking then
		return self:_update_waiting_for_matchmaking(arg_7_1, arg_7_2)
	elseif self._state == tbl.InQueue then
		return self:_update_in_queue(arg_7_1, arg_7_2)
	elseif self._state == tbl.Succeeded then
		return self:_update_succeeded(arg_7_1, arg_7_2)
	else
		self:_temp_update(arg_7_1)
		fassert(false, "Unknown state: %s", self._state)
	end
end

MatchmakingStateFlexmatchHost._update_requesting_regions = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._requesting_regions then
		return
	end

	local get_interface = Managers.backend:get_interface("versus")

	if not get_interface then
		return self:_cancel_matchmaking("Failed to find versus interface")
	end

	self._requesting_regions = true

	local var_8_1 = callback(self, "_request_regions_cb")

	get_interface:request_regions(var_8_1)
	self._network_transmit:send_rpc_clients("rpc_matchmaking_ticket_request")

	self._timeout = arg_8_2 + num_3 + num_2
end

MatchmakingStateFlexmatchHost._update_checking_latency = function (self, arg_9_1, arg_9_2)
	-- function 9
	if arg_9_2 >= self._timeout then
		return self:_cancel_matchmaking("Failed to get latency before timeout")
	end

	if not self._requesting_latency then
		return
	end

	if not Managers.backend:get_interface("versus") then
		return self:_cancel_matchmaking("Failed to find versus interface")
	end

	Managers.ping:ping_multiple_times(num_6, self._regions, num, callback(self, "_ping_cb"))

	self._requesting_latency = true
end

MatchmakingStateFlexmatchHost._ping_cb = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._ignore_results then
		return
	end

	if not arg_10_1 then
		return self:_cancel_matchmaking("Failed to get latency")
	end

	self._region_latency = arg_10_2
	self._state = tbl.RequestingTicket
end

MatchmakingStateFlexmatchHost._update_requesting_ticket = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get_interface = Managers.backend:get_interface("versus")

	if not get_interface then
		return self:_cancel_matchmaking("Failed to find versus interface")
	end

	local var_11_1 = callback(self, "_request_matchmaking_ticket_cb")

	get_interface:request_matchmaking_ticket(self._region_latency, var_11_1)

	self._state = tbl.CollectingTickets
end

MatchmakingStateFlexmatchHost._update_collecting_tickets = function (self, arg_12_1, arg_12_2)
	-- function 12
	if arg_12_2 >= self._timeout then
		self:_cancel_matchmaking("Failed to collect tickets before timeout")

		for k, v in pairs(self._queue_tickets) do
			if not v then
				fn("Missing ticket from: %s", k)
			end
		end

		return
	end

	for k_2, v_2 in pairs(self._queue_tickets) do
		if not v_2 then
			return
		end
	end

	self._state = tbl.StartingMatchmaking
end

MatchmakingStateFlexmatchHost._update_starting_matchmaking = function (self, arg_13_1, arg_13_2)
	-- function 13
	fn("Starting matchmaking")
	Managers.backend:get_interface("versus"):start_matchmaking(self._queue_tickets, callback(self, "_start_matchmaking_cb"))

	self._timeout = arg_13_2 + num_4
	self._state = tbl.WaitingForMatchmaking
end

MatchmakingStateFlexmatchHost._update_waiting_for_matchmaking = function (self, arg_14_1, arg_14_2)
	-- function 14
	if arg_14_2 >= self._timeout then
		return self:_cancel_matchmaking("Failed to start matchmaking before timeout")
	end
end

MatchmakingStateFlexmatchHost._update_in_queue = function (self, arg_15_1, arg_15_2)
	-- function 15
	if arg_15_2 >= self._timeout then
		return self:_cancel_matchmaking("Failed to get response from matchmaking before timeout")
	end

	if not (self._matchmaking_check_in_progress or not (arg_15_2 >= self._tt_next_matchmaking_check)) then
		self._matchmaking_check_in_progress = true

		Managers.backend:get_interface("versus"):fetch_matchmaking_session_data(callback(self, "_fetch_matchmaking_cb"))
	end
end

MatchmakingStateFlexmatchHost._update_succeeded = function (self, arg_16_1, arg_16_2)
	-- function 16
	local format = string.format("%s:%s", self._connection_info.ipAddress, self._connection_info.port)

	self._state_context.server_info = {
		ip_port = format
	}
	self._state_context.game_session_id = self._game_session_id
	self._state_context.is_flexmatch = true

	return MatchmakingStateReserveLobby, self._state_context
end

MatchmakingStateFlexmatchHost._request_regions_cb = function (self, arg_17_1)
	-- function 17
	if not self._ignore_results then
		return
	end

	if not (not arg_17_1.success and arg_17_1.regions) then
		return self:_cancel_matchmaking("Requesting regions failed")
	end

	self._regions = arg_17_1.regions
	self._base_url = arg_17_1.url
	self._state = tbl.CheckingLatency
end

MatchmakingStateFlexmatchHost._request_matchmaking_ticket_cb = function (self, arg_18_1)
	-- function 18
	if not self._ignore_results then
		return
	end

	if not arg_18_1.success then
		if arg_18_1.errorCode == 404 then
			local var_18_0 = Localize("wrong_game_version")

			Managers.simple_popup:queue_popup(var_18_0, Localize("popup_needs_restart_topic"), "confirm", Localize("button_ok"))
		end

		return self:_cancel_matchmaking("Requesting matchmaking ticket failed")
	end

	self._queue_tickets[Network.peer_id()] = arg_18_1.ticket
end

MatchmakingStateFlexmatchHost._start_matchmaking_cb = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	if not (not arg_19_1 and arg_19_2 == 200) then
		return self:_cancel_matchmaking("Starting matchmaking request failed. result: %s, code: %s", arg_19_1, tostring(arg_19_2))
	end

	self._matchmaking_session_id = arg_19_4.matchmakingSessionId
	self._queue_status = arg_19_4.status
	self._estimated_wait_time = arg_19_4.estimatedWaitTime

	if not self._ignore_results then
		return self:_cancel_matchmaking()
	end

	fn("session id: %s", self._matchmaking_session_id)

	if self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Queued then
		self._state = tbl.InQueue

		local net_pack_flexmatch_ticket = NetworkUtils.net_pack_flexmatch_ticket(self._matchmaking_session_id)

		self._network_transmit:send_rpc_clients("rpc_matchmaking_queue_session_data", net_pack_flexmatch_ticket, self._estimated_wait_time)
	elseif not (self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Failed or self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.TimedOut or self._queue_status ~= scripts_managers_backend_playfab_settings_flexmatch_queue_status.Cancelled) then
		return self:_cancel_matchmaking("Got unexpected queue status: %s", self._queue_status)
	elseif self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Succeeded then
		self._game_session_id = arg_19_4.gameSessionId
		self._connection_info = arg_19_4.connectionInfo
		self._state = tbl.Succeeded

		local var_19_1 = fn
		local str = "Matchmaking successful. ipAddress: %s | port: %s | name: %s"
		local ipAddress = self._connection_info.ipAddress
		local port = self._connection_info.port
		local name = self._connection_info.name

		name = name or "???"

		var_19_1(str, ipAddress, port, name)
	else
		return self:_cancel_matchmaking("Got unexpected queue status: %s", self._queue_status)
	end
end

MatchmakingStateFlexmatchHost._fetch_matchmaking_cb = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not self._ignore_results then
		return
	end

	if not (not arg_20_1 and arg_20_2 == 200) then
		return self:_cancel_matchmaking("Checking matchmaking request failed. result: %s, code: %s", arg_20_1, tostring(arg_20_2))
	end

	self._queue_status = arg_20_4.status

	local estimatedWaitTime = arg_20_4.estimatedWaitTime

	self._matchmaking_check_in_progress = false

	if self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Succeeded then
		self._game_session_id = arg_20_4.gameSessionId
		self._connection_info = arg_20_4.connectionInfo
		self._state = tbl.Succeeded

		local var_20_1 = fn
		local str = "Matchmaking successful. ipAddress: %s | port: %s | name: %s"
		local ipAddress = self._connection_info.ipAddress
		local port = self._connection_info.port
		local name = self._connection_info.name

		name = name or "???"

		var_20_1(str, ipAddress, port, name)
	elseif self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Queued then
		local time = Managers.time:time("main")

		self._tt_next_matchmaking_check = time + num_5
		self._timeout = time + num_4

		if estimatedWaitTime ~= self._estimated_wait_time then
			self._estimated_wait_time = estimatedWaitTime

			local net_pack_flexmatch_ticket = NetworkUtils.net_pack_flexmatch_ticket(self._matchmaking_session_id)

			self._network_transmit:send_rpc_clients("rpc_matchmaking_queue_session_data", net_pack_flexmatch_ticket, estimatedWaitTime)
		end
	elseif not (self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Failed or self._queue_status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.TimedOut or self._queue_status ~= scripts_managers_backend_playfab_settings_flexmatch_queue_status.Cancelled) then
		return self:_cancel_matchmaking("Got unexpected queue status: %s", self._queue_status)
	else
		return self:_cancel_matchmaking("Got unexpected queue status: %s", self._queue_status)
	end
end

MatchmakingStateFlexmatchHost._cleanup = function (self)
	-- function 21
	local event = Managers.state.event

	if not event then
		event:unregister("friend_party_peer_left", self)
	end

	self._ignore_results = true

	self:_cancel_matchmaking()

	self._connection_info = nil
	self._game_session_id = nil
	self._queue_status = nil
end

MatchmakingStateFlexmatchHost.on_friend_party_peer_left = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	if not arg_22_2 then
		return self:_cancel_matchmaking("Player left party")
	end
end

MatchmakingStateFlexmatchHost._cancel_matchmaking = function (self, arg_23_1, ...)
	-- function 23
	if not arg_23_1 then
		fn("Cancelling matchmaking")
		fn(arg_23_1, ...)
	end

	if not self._matchmaking_session_id then
		Managers.backend:get_interface("versus"):cancel_matchmaking(callback(self, "_cancel_matchmaking_cb"))
	elseif not self._ignore_results then
		Managers.matchmaking:cancel_matchmaking()
	end
end

MatchmakingStateFlexmatchHost._cancel_matchmaking_cb = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	fn("Matchmaking cancelled")

	self._matchmaking_session_id = nil

	if not self._ignore_results then
		return
	end

	Managers.matchmaking:cancel_matchmaking()
end

MatchmakingStateFlexmatchHost.rpc_matchmaking_ticket_response = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local var_25_0 = CHANNEL_TO_PEER_ID[arg_25_1]

	arg_25_0._queue_tickets[var_25_0] = NetworkUtils.unnet_pack_flexmatch_ticket(arg_25_2)
end
