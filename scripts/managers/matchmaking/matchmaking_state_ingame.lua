-- chunkname: @scripts/managers/matchmaking/matchmaking_state_ingame.lua

MatchmakingStateIngame = class(MatchmakingStateIngame)
MatchmakingStateIngame.NAME = "MatchmakingStateIngame"

function MatchmakingStateIngame.init(arg_1_0, arg_1_1)
	arg_1_0.lobby = arg_1_1.lobby
	arg_1_0.matchmaking_manager = arg_1_1.matchmaking_manager
end

function MatchmakingStateIngame.destroy(arg_2_0)
	return
end

function MatchmakingStateIngame.on_enter(arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
end

function MatchmakingStateIngame.on_exit(arg_4_0)
	return
end

function MatchmakingStateIngame.update(arg_5_0, arg_5_1, arg_5_2)
	return nil
end
