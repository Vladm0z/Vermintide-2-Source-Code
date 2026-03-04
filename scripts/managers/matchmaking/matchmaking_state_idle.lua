-- chunkname: @scripts/managers/matchmaking/matchmaking_state_idle.lua

MatchmakingStateIdle = class(MatchmakingStateIdle)
MatchmakingStateIdle.NAME = "MatchmakingStateIdle"

MatchmakingStateIdle.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.lobby = arg_1_1.lobby
	arg_1_0.reason = arg_1_2
end

MatchmakingStateIdle.destroy = function (arg_2_0)
	return
end

MatchmakingStateIdle.on_enter = function (arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
end

MatchmakingStateIdle.on_exit = function (arg_4_0)
	arg_4_0.reason = nil
end

MatchmakingStateIdle.update = function (arg_5_0, arg_5_1, arg_5_2)
	return nil
end
