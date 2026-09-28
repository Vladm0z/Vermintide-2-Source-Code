-- chunkname: @scripts/managers/matchmaking/matchmaking_state_idle.lua

MatchmakingStateIdle = class(MatchmakingStateIdle)
MatchmakingStateIdle.NAME = "MatchmakingStateIdle"

MatchmakingStateIdle.init = function (self, params, reason)
	-- function 1
	self.lobby = params.lobby
	self.reason = reason
end

MatchmakingStateIdle.destroy = function (self)
	-- function 2
	return
end

MatchmakingStateIdle.on_enter = function (self, state_context)
	-- function 3
	self.state_context = state_context
end

MatchmakingStateIdle.on_exit = function (self)
	-- function 4
	self.reason = nil
end

MatchmakingStateIdle.update = function (self, dt, t)
	-- function 5
	return nil
end
