-- chunkname: @scripts/managers/matchmaking/matchmaking_state_wait_for_countdown.lua

MatchmakingStateWaitForCountdown = class(MatchmakingStateWaitForCountdown)
MatchmakingStateWaitForCountdown.NAME = "MatchmakingStateWaitForCountdown"

MatchmakingStateWaitForCountdown.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
end

MatchmakingStateWaitForCountdown.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateWaitForCountdown.on_enter = function (self, arg_3_1)
	-- function 3
	self._state_context = arg_3_1
	self._search_config = arg_3_1.search_config
	self._wait_to_start_game = self._search_config.wait_to_start_game
end

MatchmakingStateWaitForCountdown.on_exit = function (self)
	-- function 4
	if not self._wait_to_start_game then
		Managers.matchmaking:activate_waystone_portal(nil)
	end
end

MatchmakingStateWaitForCountdown.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not DEDICATED_SERVER then
		self:_capture_telemetry()
	end

	local matchmaking = Managers.matchmaking

	if not self._wait_to_start_game then
		if not matchmaking.start_game_now then
			matchmaking.start_game_now = false

			return MatchmakingStateStartGame, self._state_context
		end

		return nil
	end

	if not matchmaking.countdown_has_finished then
		matchmaking.countdown_has_finished = false

		return MatchmakingStateStartGame, self._state_context
	end

	return nil
end

MatchmakingStateWaitForCountdown._capture_telemetry = function (self)
	-- function 6
	local get_members_joined = self._lobby:members():get_members_joined()

	if #get_members_joined > 0 then
		local local_player = Managers.player:local_player()
		local num = Managers.time:time("main") - self._state_context.started_hosting_t

		for i, v in ipairs(get_members_joined) do
			local flag = false

			if not rawget(_G, "Steam") and not rawget(_G, "Friends") then
				local in_category = Friends.in_category(v, Friends.FRIEND_FLAG)
			end

			Managers.telemetry_events:matchmaking_player_joined(local_player, num, self._search_config)
		end
	end
end
