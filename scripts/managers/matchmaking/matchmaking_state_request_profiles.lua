-- chunkname: @scripts/managers/matchmaking/matchmaking_state_request_profiles.lua

MatchmakingStateRequestProfiles = class(MatchmakingStateRequestProfiles)
MatchmakingStateRequestProfiles.NAME = "MatchmakingStateRequestProfiles"

MatchmakingStateRequestProfiles.init = function (self, arg_1_1)
	-- function 1
	self._matchmaking_manager = arg_1_1.matchmaking_manager
end

MatchmakingStateRequestProfiles.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateRequestProfiles.on_enter = function (self, arg_3_1)
	-- function 3
	self.state_context = arg_3_1
	self.search_config = arg_3_1.search_config
	self._matchmaking_manager.debug.profiles_data = {}

	self:_request_profiles_data()

	self.state_context.profiles_data = nil
	self.profiles_data = {}

	local flag = true

	Managers.chat:add_local_system_message(1, Localize("matchmaking_status_requesting_profiles"), flag)
end

MatchmakingStateRequestJoinGame.terminate = function (arg_4_0)
	-- function 4
	Managers.lobby:destroy_lobby("matchmaking_join_lobby")
end

MatchmakingStateRequestProfiles.on_exit = function (arg_5_0)
	-- function 5
	return
end

MatchmakingStateRequestProfiles.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._reply_timer then
		self._reply_timer = self._reply_timer - arg_6_1

		if self._reply_timer < 0 then
			mm_printf("NO REPLY WHEN REQUESTING PROFILES DATA")

			if self.search_config == nil then
				self._matchmaking_manager:cancel_matchmaking()
			else
				Managers.lobby:destroy_lobby("matchmaking_join_lobby")

				local search_config = self.search_config

				if not (not search_config and not search_config.dedicated_server and search_config.join_method ~= "party") then
					if not search_config.aws then
						self._next_state = MatchmakingStateFlexmatchHost
					else
						self._next_state = MatchmakingStateReserveLobby
					end
				else
					self._next_state = MatchmakingStateSearchGame
				end
			end
		end
	end

	if not self._next_state then
		return self._next_state, self.state_context
	end

	return nil
end

MatchmakingStateRequestProfiles._request_profiles_data = function (self)
	-- function 7
	local lobby_host = Managers.lobby:get_lobby("matchmaking_join_lobby"):lobby_host()

	RPC.rpc_matchmaking_request_profiles_data(PEER_ID_TO_CHANNEL[lobby_host])

	self._reply_timer = MatchmakingSettings.REQUEST_PROFILES_REPLY_TIME
	self._matchmaking_manager.debug.text = "requesting_profiles_data"
end

MatchmakingStateRequestProfiles.rpc_matchmaking_request_profiles_data_reply = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	self._reply_timer = nil

	self:_update_profiles_data(arg_8_2, arg_8_3, arg_8_4)

	self.state_context.lobby_client = Managers.lobby:free_lobby("matchmaking_join_lobby")
	self._next_state = MatchmakingStateJoinGame
	self._matchmaking_manager.debug.text = "profiles_data_received"
end

MatchmakingStateRequestProfiles._update_profiles_data = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	self.profiles_data = ProfileSynchronizer.join_reservation_data_arrays(arg_9_1, arg_9_2)
	self.state_context.profiles_data = self.profiles_data
	self.state_context.reserved_party_id = arg_9_3
	self._matchmaking_manager.debug.profiles_data = self.profiles_data
end
