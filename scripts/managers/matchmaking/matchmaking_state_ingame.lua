-- chunkname: @scripts/managers/matchmaking/matchmaking_state_ingame.lua

MatchmakingStateIngame = class(MatchmakingStateIngame)
MatchmakingStateIngame.NAME = "MatchmakingStateIngame"

MatchmakingStateIngame.init = function (self, params)
	-- function 1
	self.lobby = params.lobby
	self.matchmaking_manager = params.matchmaking_manager
end

MatchmakingStateIngame.destroy = function (self)
	-- function 2
	return
end

MatchmakingStateIngame.on_enter = function (self, state_context)
	-- function 3
	self.state_context = state_context
end

MatchmakingStateIngame.on_exit = function (self)
	-- function 4
	return
end

MatchmakingStateIngame.update = function (self, dt, t)
	-- function 5
	return nil
end
