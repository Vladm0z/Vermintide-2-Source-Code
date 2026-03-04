-- chunkname: @scripts/managers/matchmaking/matchmaking_state_friend_client.lua

MatchmakingStateFriendClient = class(MatchmakingStateFriendClient)
MatchmakingStateFriendClient.NAME = "MatchmakingStateFriendClient"

local var_0_0 = {
	Default = "Default",
	CollectingTicket = "CollectingTicket",
	RequestingTicket = "RequestingTicket",
	CheckingLatency = "CheckingLatency",
	RequestingRegions = "RequestingRegions"
}
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = 10

MatchmakingStateFriendClient.init = function (arg_1_0, arg_1_1)
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.lobby = arg_1_1.lobby
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0._network_options = arg_1_1.network_options
	arg_1_0.params = arg_1_1
	arg_1_0._request_timer = 0
	arg_1_0._lobby = arg_1_1.lobby
end

MatchmakingStateFriendClient.destroy = function (arg_2_0)
	return
end

MatchmakingStateFriendClient.on_enter = function (arg_3_0, arg_3_1)
	arg_3_0._game_server_data = nil
	arg_3_0._state_context = arg_3_1
	arg_3_0._estimated_wait_time = -1
	arg_3_0._state = var_0_0.Init
	arg_3_0._region_latency = {}
	arg_3_0._timeout = math.huge
	arg_3_0._is_versus = arg_3_1.mechanism == "versus"
end

MatchmakingStateFriendClient.on_exit = function (arg_4_0)
	local var_4_0 = Managers.mechanism:game_mechanism()
	local var_4_1 = var_4_0 and var_4_0.get_server_id and var_4_0:get_server_id()

	if var_4_1 then
		print("JOINING MATCH. SERVER NAME: " .. var_4_1)
	end

	if Managers.mechanism:game_mechanism().using_dedicated_servers then
		local var_4_2, var_4_3 = Managers.mechanism:game_mechanism():using_dedicated_servers()

		if var_4_3 then
			local var_4_4 = Managers.mechanism:network_handler()

			if arg_4_0._session_id and var_4_4.fail_reason then
				Managers.backend:get_interface("versus"):cancel_matchmaking(callback(arg_4_0, "_cancel_matchmaking_cb"))
			end

			arg_4_0._session_id = nil
			arg_4_0._base_url = nil
		end
	end
end

MatchmakingStateFriendClient.update = function (arg_5_0, arg_5_1, arg_5_2)
	if not Managers.state.game_mode then
		return
	end

	local var_5_0 = Managers.state.game_mode:level_key()

	if not LevelSettings[var_5_0].hub_level then
		return
	end

	local var_5_1 = arg_5_0._state_context.search_config

	if arg_5_0._is_versus and Managers.venture.quickplay:has_pending_quick_game() then
		if arg_5_0._state == var_0_0.Init then
			arg_5_0._state = var_0_0.RequestingRegions
		elseif arg_5_0._state == var_0_0.RequestingRegions then
			arg_5_0:_update_requesting_regions(arg_5_1, arg_5_2)
		elseif arg_5_0._state == var_0_0.CheckingLatency then
			arg_5_0:_update_checking_latency(arg_5_1, arg_5_2)
		elseif arg_5_0._state == var_0_0.RequestingTicket then
			arg_5_0:_update_requesting_ticket(arg_5_1, arg_5_2)
		end
	end

	local var_5_2 = arg_5_0._gamepad_active_last_frame

	arg_5_0._gamepad_active_last_frame = Managers.input:is_device_active("gamepad")
end

MatchmakingStateFriendClient._update_requesting_regions = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._requesting_regions then
		return
	end

	local var_6_0 = Managers.backend:get_interface("versus")

	if not var_6_0 then
		return
	end

	arg_6_0._requesting_regions = true
	arg_6_0._timeout = arg_6_2 + var_0_3

	local var_6_1 = callback(arg_6_0, "_request_regions_cb")

	var_6_0:request_regions(var_6_1)
end

MatchmakingStateFriendClient._request_regions_cb = function (arg_7_0, arg_7_1)
	if arg_7_0._ignore_results then
		return
	end

	if not arg_7_1.success then
		return
	end

	arg_7_0._regions = arg_7_1.regions
	arg_7_0._base_url = arg_7_1.url
	arg_7_0._state = var_0_0.CheckingLatency
end

MatchmakingStateFriendClient._update_checking_latency = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 >= arg_8_0._timeout then
		return
	end

	if arg_8_0._requesting_latency then
		return
	end

	if not Managers.backend:get_interface("versus") then
		return
	end

	Managers.ping:ping_multiple_times(var_0_1, arg_8_0._regions, var_0_2, callback(arg_8_0, "_ping_cb"))

	arg_8_0._requesting_latency = true
end

MatchmakingStateFriendClient._ping_cb = function (arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._ignore_results then
		return
	end

	if not arg_9_1 then
		return
	end

	arg_9_0._region_latency = arg_9_2
	arg_9_0._state = var_0_0.RequestingTicket
end

MatchmakingStateFriendClient._update_requesting_ticket = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.backend:get_interface("versus")

	if not var_10_0 then
		return
	end

	local var_10_1 = callback(arg_10_0, "_request_matchmaking_ticket_cb")

	var_10_0:request_matchmaking_ticket(arg_10_0._region_latency, var_10_1)

	arg_10_0._state = var_0_0.CollectingTicket
end

MatchmakingStateFriendClient._request_matchmaking_ticket_cb = function (arg_11_0, arg_11_1)
	if not Network.game_session() then
		return
	end

	if not arg_11_1.success then
		if arg_11_1.errorCode == 404 then
			local var_11_0 = Localize("wrong_game_version")

			Managers.simple_popup:queue_popup(var_11_0, Localize("popup_needs_restart_topic"), "confirm", Localize("button_ok"))
		end

		return
	end

	arg_11_0._base_url = arg_11_1.url

	local var_11_1 = NetworkUtils.net_pack_flexmatch_ticket(arg_11_1.ticket)

	arg_11_0.network_transmit:send_rpc_server("rpc_matchmaking_ticket_response", var_11_1)

	arg_11_0._state = var_0_0.Default
end

MatchmakingStateFriendClient.rpc_matchmaking_ticket_request = function (arg_12_0)
	arg_12_0._state = var_0_0.RequestingRegions
end

MatchmakingStateFriendClient.rpc_matchmaking_queue_session_data = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = NetworkUtils.unnet_pack_flexmatch_ticket(arg_13_1)

	arg_13_0._session_id = var_13_0

	Managers.backend:get_interface("versus"):set_matchmaking_session_id(var_13_0)

	arg_13_0._estimated_wait_time = arg_13_2
end

MatchmakingStateFriendClient._cancel_matchmaking_cb = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	arg_14_0._session_id = nil
end

MatchmakingStateFriendClient.get_transition = function (arg_15_0)
	if arg_15_0._game_server_data then
		return "join_server", arg_15_0._game_server_data
	end
end

MatchmakingStateFriendClient.rpc_matchmaking_broadcast_game_server_ip_address = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._game_server_data = {
		server_info = {
			ip_port = arg_16_2
		}
	}
end
