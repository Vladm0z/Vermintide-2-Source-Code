-- chunkname: @scripts/managers/matchmaking/matchmaking_state_wait_for_countdown.lua

MatchmakingStateWaitForCountdown = class(MatchmakingStateWaitForCountdown)
MatchmakingStateWaitForCountdown.NAME = "MatchmakingStateWaitForCountdown"

MatchmakingStateWaitForCountdown.init = function (arg_1_0, arg_1_1)
	arg_1_0._lobby = arg_1_1.lobby
end

MatchmakingStateWaitForCountdown.destroy = function (arg_2_0)
	return
end

MatchmakingStateWaitForCountdown.on_enter = function (arg_3_0, arg_3_1)
	arg_3_0._state_context = arg_3_1
	arg_3_0._search_config = arg_3_1.search_config
	arg_3_0._wait_to_start_game = arg_3_0._search_config.wait_to_start_game
end

MatchmakingStateWaitForCountdown.on_exit = function (arg_4_0)
	if not arg_4_0._wait_to_start_game then
		Managers.matchmaking:activate_waystone_portal(nil)
	end
end

MatchmakingStateWaitForCountdown.update = function (arg_5_0, arg_5_1, arg_5_2)
	if not DEDICATED_SERVER then
		arg_5_0:_capture_telemetry()
	end

	local var_5_0 = Managers.matchmaking

	if arg_5_0._wait_to_start_game then
		if var_5_0.start_game_now then
			var_5_0.start_game_now = false

			return MatchmakingStateStartGame, arg_5_0._state_context
		end

		return nil
	end

	if var_5_0.countdown_has_finished then
		var_5_0.countdown_has_finished = false

		return MatchmakingStateStartGame, arg_5_0._state_context
	end

	return nil
end

MatchmakingStateWaitForCountdown._capture_telemetry = function (arg_6_0)
	local var_6_0 = arg_6_0._lobby:members():get_members_joined()

	if #var_6_0 > 0 then
		local var_6_1 = Managers.player:local_player()
		local var_6_2 = Managers.time:time("main") - arg_6_0._state_context.started_hosting_t

		for iter_6_0, iter_6_1 in ipairs(var_6_0) do
			local var_6_3 = false

			if rawget(_G, "Steam") and rawget(_G, "Friends") then
				local var_6_4 = Friends.in_category(iter_6_1, Friends.FRIEND_FLAG)
			end

			Managers.telemetry_events:matchmaking_player_joined(var_6_1, var_6_2, arg_6_0._search_config)
		end
	end
end
