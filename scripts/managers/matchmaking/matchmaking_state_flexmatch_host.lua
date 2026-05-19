-- chunkname: @scripts/managers/matchmaking/matchmaking_state_flexmatch_host.lua

local var_0_0 = require("scripts/managers/backend_playfab/settings/flexmatch_queue_status")

MatchmakingStateFlexmatchHost = class(MatchmakingStateFlexmatchHost)
MatchmakingStateFlexmatchHost.NAME = "MatchmakingStateFlexmatchHost"

local var_0_1 = {
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
local var_0_2 = 3
local var_0_3 = 10
local var_0_4 = 30
local var_0_5 = 60
local var_0_6 = 5
local var_0_7 = 2
local var_0_8 = {}

local function var_0_9(arg_1_0, ...)
	arg_1_0 = "[Flexmatch] " .. arg_1_0

	printf(arg_1_0, ...)
end

function MatchmakingStateFlexmatchHost.init(arg_2_0, arg_2_1)
	arg_2_0._network_transmit = arg_2_1.network_transmit
	arg_2_0._network_options = arg_2_1.network_options
	arg_2_0._lobby = arg_2_1.lobby
end

function MatchmakingStateFlexmatchHost.terminate(arg_3_0)
	return
end

function MatchmakingStateFlexmatchHost.destroy(arg_4_0)
	arg_4_0:_cleanup()
end

function MatchmakingStateFlexmatchHost.on_enter(arg_5_0, arg_5_1)
	arg_5_0._state_context = arg_5_1

	local var_5_0 = arg_5_1.search_config.party_lobby_host.lobby_members

	arg_5_0._tt_next_matchmaking_check = 0
	arg_5_0._timeout = math.huge
	arg_5_0._ignore_results = false
	arg_5_0._estimated_wait_time = -1
	arg_5_0._queue_tickets = {}

	for iter_5_0, iter_5_1 in pairs(var_5_0.members) do
		arg_5_0._queue_tickets[iter_5_0] = false
	end

	Managers.state.event:register(arg_5_0, "friend_party_peer_left", "on_friend_party_peer_left")

	arg_5_0._region_latency = {}
	arg_5_0._state = var_0_1.Init
end

function MatchmakingStateFlexmatchHost.on_exit(arg_6_0)
	arg_6_0:_cleanup()
end

function MatchmakingStateFlexmatchHost.update(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._state == var_0_1.Init then
		arg_7_0._state = var_0_1.RequestingRegions
	elseif arg_7_0._state == var_0_1.RequestingRegions then
		return arg_7_0:_update_requesting_regions(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.CheckingLatency then
		return arg_7_0:_update_checking_latency(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.RequestingTicket then
		return arg_7_0:_update_requesting_ticket(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.CollectingTickets then
		return arg_7_0:_update_collecting_tickets(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.StartingMatchmaking then
		return arg_7_0:_update_starting_matchmaking(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.WaitingForMatchmaking then
		return arg_7_0:_update_waiting_for_matchmaking(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.InQueue then
		return arg_7_0:_update_in_queue(arg_7_1, arg_7_2)
	elseif arg_7_0._state == var_0_1.Succeeded then
		return arg_7_0:_update_succeeded(arg_7_1, arg_7_2)
	else
		arg_7_0:_temp_update(arg_7_1)
		fassert(false, "Unknown state: %s", arg_7_0._state)
	end
end

function MatchmakingStateFlexmatchHost._update_requesting_regions(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._requesting_regions then
		return
	end

	local var_8_0 = Managers.backend:get_interface("versus")

	if not var_8_0 then
		return arg_8_0:_cancel_matchmaking("Failed to find versus interface")
	end

	arg_8_0._requesting_regions = true

	local var_8_1 = callback(arg_8_0, "_request_regions_cb")

	var_8_0:request_regions(var_8_1)
	arg_8_0._network_transmit:send_rpc_clients("rpc_matchmaking_ticket_request")

	arg_8_0._timeout = arg_8_2 + var_0_4 + var_0_3
end

function MatchmakingStateFlexmatchHost._update_checking_latency(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2 >= arg_9_0._timeout then
		return arg_9_0:_cancel_matchmaking("Failed to get latency before timeout")
	end

	if arg_9_0._requesting_latency then
		return
	end

	if not Managers.backend:get_interface("versus") then
		return arg_9_0:_cancel_matchmaking("Failed to find versus interface")
	end

	Managers.ping:ping_multiple_times(var_0_7, arg_9_0._regions, var_0_2, callback(arg_9_0, "_ping_cb"))

	arg_9_0._requesting_latency = true
end

function MatchmakingStateFlexmatchHost._ping_cb(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0._ignore_results then
		return
	end

	if not arg_10_1 then
		return arg_10_0:_cancel_matchmaking("Failed to get latency")
	end

	arg_10_0._region_latency = arg_10_2
	arg_10_0._state = var_0_1.RequestingTicket
end

function MatchmakingStateFlexmatchHost._update_requesting_ticket(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = Managers.backend:get_interface("versus")

	if not var_11_0 then
		return arg_11_0:_cancel_matchmaking("Failed to find versus interface")
	end

	local var_11_1 = callback(arg_11_0, "_request_matchmaking_ticket_cb")

	var_11_0:request_matchmaking_ticket(arg_11_0._region_latency, var_11_1)

	arg_11_0._state = var_0_1.CollectingTickets
end

function MatchmakingStateFlexmatchHost._update_collecting_tickets(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2 >= arg_12_0._timeout then
		arg_12_0:_cancel_matchmaking("Failed to collect tickets before timeout")

		for iter_12_0, iter_12_1 in pairs(arg_12_0._queue_tickets) do
			if not iter_12_1 then
				var_0_9("Missing ticket from: %s", iter_12_0)
			end
		end

		return
	end

	for iter_12_2, iter_12_3 in pairs(arg_12_0._queue_tickets) do
		if not iter_12_3 then
			return
		end
	end

	arg_12_0._state = var_0_1.StartingMatchmaking
end

function MatchmakingStateFlexmatchHost._update_starting_matchmaking(arg_13_0, arg_13_1, arg_13_2)
	var_0_9("Starting matchmaking")
	Managers.backend:get_interface("versus"):start_matchmaking(arg_13_0._queue_tickets, callback(arg_13_0, "_start_matchmaking_cb"))

	arg_13_0._timeout = arg_13_2 + var_0_5
	arg_13_0._state = var_0_1.WaitingForMatchmaking
end

function MatchmakingStateFlexmatchHost._update_waiting_for_matchmaking(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_2 >= arg_14_0._timeout then
		return arg_14_0:_cancel_matchmaking("Failed to start matchmaking before timeout")
	end
end

function MatchmakingStateFlexmatchHost._update_in_queue(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_2 >= arg_15_0._timeout then
		return arg_15_0:_cancel_matchmaking("Failed to get response from matchmaking before timeout")
	end

	if not arg_15_0._matchmaking_check_in_progress and arg_15_2 >= arg_15_0._tt_next_matchmaking_check then
		arg_15_0._matchmaking_check_in_progress = true

		Managers.backend:get_interface("versus"):fetch_matchmaking_session_data(callback(arg_15_0, "_fetch_matchmaking_cb"))
	end
end

function MatchmakingStateFlexmatchHost._update_succeeded(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = string.format("%s:%s", arg_16_0._connection_info.ipAddress, arg_16_0._connection_info.port)

	arg_16_0._state_context.server_info = {
		ip_port = var_16_0
	}
	arg_16_0._state_context.game_session_id = arg_16_0._game_session_id
	arg_16_0._state_context.is_flexmatch = true

	return MatchmakingStateReserveLobby, arg_16_0._state_context
end

function MatchmakingStateFlexmatchHost._request_regions_cb(arg_17_0, arg_17_1)
	if arg_17_0._ignore_results then
		return
	end

	if not arg_17_1.success or not arg_17_1.regions then
		return arg_17_0:_cancel_matchmaking("Requesting regions failed")
	end

	arg_17_0._regions = arg_17_1.regions
	arg_17_0._base_url = arg_17_1.url
	arg_17_0._state = var_0_1.CheckingLatency
end

function MatchmakingStateFlexmatchHost._request_matchmaking_ticket_cb(arg_18_0, arg_18_1)
	if arg_18_0._ignore_results then
		return
	end

	if not arg_18_1.success then
		if arg_18_1.errorCode == 404 then
			local var_18_0 = Localize("wrong_game_version")

			Managers.simple_popup:queue_popup(var_18_0, Localize("popup_needs_restart_topic"), "confirm", Localize("button_ok"))
		end

		return arg_18_0:_cancel_matchmaking("Requesting matchmaking ticket failed")
	end

	arg_18_0._queue_tickets[Network.peer_id()] = arg_18_1.ticket
end

function MatchmakingStateFlexmatchHost._start_matchmaking_cb(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if not arg_19_1 or arg_19_2 ~= 200 then
		return arg_19_0:_cancel_matchmaking("Starting matchmaking request failed. result: %s, code: %s", arg_19_1, tostring(arg_19_2))
	end

	arg_19_0._matchmaking_session_id = arg_19_4.matchmakingSessionId
	arg_19_0._queue_status = arg_19_4.status
	arg_19_0._estimated_wait_time = arg_19_4.estimatedWaitTime

	if arg_19_0._ignore_results then
		return arg_19_0:_cancel_matchmaking()
	end

	var_0_9("session id: %s", arg_19_0._matchmaking_session_id)

	if arg_19_0._queue_status == var_0_0.Queued then
		arg_19_0._state = var_0_1.InQueue

		local var_19_0 = NetworkUtils.net_pack_flexmatch_ticket(arg_19_0._matchmaking_session_id)

		arg_19_0._network_transmit:send_rpc_clients("rpc_matchmaking_queue_session_data", var_19_0, arg_19_0._estimated_wait_time)
	elseif arg_19_0._queue_status == var_0_0.Failed or arg_19_0._queue_status == var_0_0.TimedOut or arg_19_0._queue_status == var_0_0.Cancelled then
		return arg_19_0:_cancel_matchmaking("Got unexpected queue status: %s", arg_19_0._queue_status)
	elseif arg_19_0._queue_status == var_0_0.Succeeded then
		arg_19_0._game_session_id = arg_19_4.gameSessionId
		arg_19_0._connection_info = arg_19_4.connectionInfo
		arg_19_0._state = var_0_1.Succeeded

		var_0_9("Matchmaking successful. ipAddress: %s | port: %s | name: %s", arg_19_0._connection_info.ipAddress, arg_19_0._connection_info.port, arg_19_0._connection_info.name or "???")
	else
		return arg_19_0:_cancel_matchmaking("Got unexpected queue status: %s", arg_19_0._queue_status)
	end
end

function MatchmakingStateFlexmatchHost._fetch_matchmaking_cb(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_0._ignore_results then
		return
	end

	if not arg_20_1 or arg_20_2 ~= 200 then
		return arg_20_0:_cancel_matchmaking("Checking matchmaking request failed. result: %s, code: %s", arg_20_1, tostring(arg_20_2))
	end

	arg_20_0._queue_status = arg_20_4.status

	local var_20_0 = arg_20_4.estimatedWaitTime

	arg_20_0._matchmaking_check_in_progress = false

	if arg_20_0._queue_status == var_0_0.Succeeded then
		arg_20_0._game_session_id = arg_20_4.gameSessionId
		arg_20_0._connection_info = arg_20_4.connectionInfo
		arg_20_0._state = var_0_1.Succeeded

		var_0_9("Matchmaking successful. ipAddress: %s | port: %s | name: %s", arg_20_0._connection_info.ipAddress, arg_20_0._connection_info.port, arg_20_0._connection_info.name or "???")
	elseif arg_20_0._queue_status == var_0_0.Queued then
		local var_20_1 = Managers.time:time("main")

		arg_20_0._tt_next_matchmaking_check = var_20_1 + var_0_6
		arg_20_0._timeout = var_20_1 + var_0_5

		if var_20_0 ~= arg_20_0._estimated_wait_time then
			arg_20_0._estimated_wait_time = var_20_0

			local var_20_2 = NetworkUtils.net_pack_flexmatch_ticket(arg_20_0._matchmaking_session_id)

			arg_20_0._network_transmit:send_rpc_clients("rpc_matchmaking_queue_session_data", var_20_2, var_20_0)
		end
	elseif arg_20_0._queue_status == var_0_0.Failed or arg_20_0._queue_status == var_0_0.TimedOut or arg_20_0._queue_status == var_0_0.Cancelled then
		return arg_20_0:_cancel_matchmaking("Got unexpected queue status: %s", arg_20_0._queue_status)
	else
		return arg_20_0:_cancel_matchmaking("Got unexpected queue status: %s", arg_20_0._queue_status)
	end
end

function MatchmakingStateFlexmatchHost._cleanup(arg_21_0)
	local var_21_0 = Managers.state.event

	if var_21_0 then
		var_21_0:unregister("friend_party_peer_left", arg_21_0)
	end

	arg_21_0._ignore_results = true

	arg_21_0:_cancel_matchmaking()

	arg_21_0._connection_info = nil
	arg_21_0._game_session_id = nil
	arg_21_0._queue_status = nil
end

function MatchmakingStateFlexmatchHost.on_friend_party_peer_left(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_2 then
		return arg_22_0:_cancel_matchmaking("Player left party")
	end
end

function MatchmakingStateFlexmatchHost._cancel_matchmaking(arg_23_0, arg_23_1, ...)
	if arg_23_1 then
		var_0_9("Cancelling matchmaking")
		var_0_9(arg_23_1, ...)
	end

	if arg_23_0._matchmaking_session_id then
		Managers.backend:get_interface("versus"):cancel_matchmaking(callback(arg_23_0, "_cancel_matchmaking_cb"))
	elseif not arg_23_0._ignore_results then
		Managers.matchmaking:cancel_matchmaking()
	end
end

function MatchmakingStateFlexmatchHost._cancel_matchmaking_cb(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	var_0_9("Matchmaking cancelled")

	arg_24_0._matchmaking_session_id = nil

	if arg_24_0._ignore_results then
		return
	end

	Managers.matchmaking:cancel_matchmaking()
end

function MatchmakingStateFlexmatchHost.rpc_matchmaking_ticket_response(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = CHANNEL_TO_PEER_ID[arg_25_1]

	arg_25_0._queue_tickets[var_25_0] = NetworkUtils.unnet_pack_flexmatch_ticket(arg_25_2)
end
