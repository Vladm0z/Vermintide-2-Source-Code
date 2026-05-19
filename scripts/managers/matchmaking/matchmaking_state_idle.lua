-- chunkname: @scripts/managers/matchmaking/matchmaking_state_idle.lua

MatchmakingStateIdle = class(MatchmakingStateIdle)
MatchmakingStateIdle.NAME = "MatchmakingStateIdle"

function MatchmakingStateIdle.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.lobby = arg_1_1.lobby
	arg_1_0.reason = arg_1_2
end

function MatchmakingStateIdle.destroy(arg_2_0)
	return
end

function MatchmakingStateIdle.on_enter(arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
end

function MatchmakingStateIdle.on_exit(arg_4_0)
	arg_4_0.reason = nil
end

function MatchmakingStateIdle.update(arg_5_0, arg_5_1, arg_5_2)
	return nil
end
