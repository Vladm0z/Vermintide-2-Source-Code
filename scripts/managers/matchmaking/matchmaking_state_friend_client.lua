-- chunkname: @scripts/managers/matchmaking/matchmaking_state_friend_client.lua

MatchmakingStateFriendClient = class(MatchmakingStateFriendClient)
MatchmakingStateFriendClient.NAME = "MatchmakingStateFriendClient"

local tbl = {
	Default = "Default",
	CollectingTicket = "CollectingTicket",
	RequestingTicket = "RequestingTicket",
	CheckingLatency = "CheckingLatency",
	RequestingRegions = "RequestingRegions"
}
local num = 2
local num_2 = 3
local num_3 = 10

MatchmakingStateFriendClient.init = function (self, arg_1_1)
	-- function 1
	self.wwise_world = arg_1_1.wwise_world
	self.lobby = arg_1_1.lobby
	self.network_transmit = arg_1_1.network_transmit
	self._network_options = arg_1_1.network_options
	self.params = arg_1_1
	self._request_timer = 0
	self._lobby = arg_1_1.lobby
end

MatchmakingStateFriendClient.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateFriendClient.on_enter = function (self, arg_3_1)
	-- function 3
	self._game_server_data = nil
	self._state_context = arg_3_1
	self._estimated_wait_time = -1
	self._state = tbl.Init
	self._region_latency = {}
	self._timeout = math.huge
	self._is_versus = arg_3_1.mechanism == "versus"
end

MatchmakingStateFriendClient.on_exit = function (self)
	-- function 4
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism then
		-- Nothing
	end

	::label_4_0::

	local get_server_id = game_mechanism.get_server_id

	get_server_id = not get_server_id and game_mechanism:get_server_id()

	::label_4_1::

	if not get_server_id then
		print("JOINING MATCH. SERVER NAME: " .. get_server_id)
	end

	if not Managers.mechanism:game_mechanism().using_dedicated_servers then
		local using_dedicated_servers, var_4_3 = Managers.mechanism:game_mechanism():using_dedicated_servers()

		if not var_4_3 then
			local network_handler = Managers.mechanism:network_handler()

			if not self._session_id and not network_handler.fail_reason then
				Managers.backend:get_interface("versus"):cancel_matchmaking(callback(self, "_cancel_matchmaking_cb"))
			end

			self._session_id = nil
			self._base_url = nil
		end
	end
end

MatchmakingStateFriendClient.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not Managers.state.game_mode then
		return
	end

	local level_key = Managers.state.game_mode:level_key()

	if not LevelSettings[level_key].hub_level then
		return
	end

	local search_config = self._state_context.search_config

	if not self._is_versus and not Managers.venture.quickplay:has_pending_quick_game() then
		if self._state == tbl.Init then
			self._state = tbl.RequestingRegions
		elseif self._state == tbl.RequestingRegions then
			self:_update_requesting_regions(arg_5_1, arg_5_2)
		elseif self._state == tbl.CheckingLatency then
			self:_update_checking_latency(arg_5_1, arg_5_2)
		elseif self._state == tbl.RequestingTicket then
			self:_update_requesting_ticket(arg_5_1, arg_5_2)
		end
	end

	local _gamepad_active_last_frame = self._gamepad_active_last_frame

	self._gamepad_active_last_frame = Managers.input:is_device_active("gamepad")
end

MatchmakingStateFriendClient._update_requesting_regions = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._requesting_regions then
		return
	end

	local get_interface = Managers.backend:get_interface("versus")

	if not get_interface then
		return
	end

	self._requesting_regions = true
	self._timeout = arg_6_2 + num_3

	local var_6_1 = callback(self, "_request_regions_cb")

	get_interface:request_regions(var_6_1)
end

MatchmakingStateFriendClient._request_regions_cb = function (self, arg_7_1)
	-- function 7
	if not self._ignore_results then
		return
	end

	if not arg_7_1.success then
		return
	end

	self._regions = arg_7_1.regions
	self._base_url = arg_7_1.url
	self._state = tbl.CheckingLatency
end

MatchmakingStateFriendClient._update_checking_latency = function (self, arg_8_1, arg_8_2)
	-- function 8
	if arg_8_2 >= self._timeout then
		return
	end

	if not self._requesting_latency then
		return
	end

	if not Managers.backend:get_interface("versus") then
		return
	end

	Managers.ping:ping_multiple_times(num, self._regions, num_2, callback(self, "_ping_cb"))

	self._requesting_latency = true
end

MatchmakingStateFriendClient._ping_cb = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._ignore_results then
		return
	end

	if not arg_9_1 then
		return
	end

	self._region_latency = arg_9_2
	self._state = tbl.RequestingTicket
end

MatchmakingStateFriendClient._update_requesting_ticket = function (self, arg_10_1, arg_10_2)
	-- function 10
	local get_interface = Managers.backend:get_interface("versus")

	if not get_interface then
		return
	end

	local var_10_1 = callback(self, "_request_matchmaking_ticket_cb")

	get_interface:request_matchmaking_ticket(self._region_latency, var_10_1)

	self._state = tbl.CollectingTicket
end

MatchmakingStateFriendClient._request_matchmaking_ticket_cb = function (self, arg_11_1)
	-- function 11
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

	self._base_url = arg_11_1.url

	local net_pack_flexmatch_ticket = NetworkUtils.net_pack_flexmatch_ticket(arg_11_1.ticket)

	self.network_transmit:send_rpc_server("rpc_matchmaking_ticket_response", net_pack_flexmatch_ticket)

	self._state = tbl.Default
end

MatchmakingStateFriendClient.rpc_matchmaking_ticket_request = function (self)
	-- function 12
	self._state = tbl.RequestingRegions
end

MatchmakingStateFriendClient.rpc_matchmaking_queue_session_data = function (self, arg_13_1, arg_13_2)
	-- function 13
	local unnet_pack_flexmatch_ticket = NetworkUtils.unnet_pack_flexmatch_ticket(arg_13_1)

	self._session_id = unnet_pack_flexmatch_ticket

	Managers.backend:get_interface("versus"):set_matchmaking_session_id(unnet_pack_flexmatch_ticket)

	self._estimated_wait_time = arg_13_2
end

MatchmakingStateFriendClient._cancel_matchmaking_cb = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	self._session_id = nil
end

MatchmakingStateFriendClient.get_transition = function (self)
	-- function 15
	if not self._game_server_data then
		return "join_server", self._game_server_data
	end
end

MatchmakingStateFriendClient.rpc_matchmaking_broadcast_game_server_ip_address = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._game_server_data = {
		server_info = {
			ip_port = arg_16_2
		}
	}
end
