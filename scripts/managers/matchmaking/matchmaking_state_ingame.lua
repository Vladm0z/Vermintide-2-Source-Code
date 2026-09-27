-- chunkname: @scripts/managers/matchmaking/matchmaking_state_ingame.lua

MatchmakingStateIngame = class(MatchmakingStateIngame)
MatchmakingStateIngame.NAME = "MatchmakingStateIngame"

MatchmakingStateIngame.init = function (self, arg_1_1)
	-- function 1
	self.lobby = arg_1_1.lobby
	self.matchmaking_manager = arg_1_1.matchmaking_manager
end

MatchmakingStateIngame.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateIngame.on_enter = function (self, arg_3_1)
	-- function 3
	self.state_context = arg_3_1
end

MatchmakingStateIngame.on_exit = function (arg_4_0)
	-- function 4
	return
end

MatchmakingStateIngame.update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return nil
end
