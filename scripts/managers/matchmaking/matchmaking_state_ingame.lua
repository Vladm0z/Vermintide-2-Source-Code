-- chunkname: @scripts/managers/matchmaking/matchmaking_state_ingame.lua

MatchmakingStateIngame = class(MatchmakingStateIngame)
MatchmakingStateIngame.NAME = "MatchmakingStateIngame"

MatchmakingStateIngame.init = function (arg_1_0, arg_1_1)
	arg_1_0.lobby = arg_1_1.lobby
	arg_1_0.matchmaking_manager = arg_1_1.matchmaking_manager
end

MatchmakingStateIngame.destroy = function (arg_2_0)
	return
end

MatchmakingStateIngame.on_enter = function (arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
end

MatchmakingStateIngame.on_exit = function (arg_4_0)
	return
end

MatchmakingStateIngame.update = function (arg_5_0, arg_5_1, arg_5_2)
	return nil
end
