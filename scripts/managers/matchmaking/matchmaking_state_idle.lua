-- chunkname: @scripts/managers/matchmaking/matchmaking_state_idle.lua

MatchmakingStateIdle = class(MatchmakingStateIdle)
MatchmakingStateIdle.NAME = "MatchmakingStateIdle"

MatchmakingStateIdle.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.lobby = arg_1_1.lobby
	self.reason = arg_1_2
end

MatchmakingStateIdle.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateIdle.on_enter = function (self, arg_3_1)
	-- function 3
	self.state_context = arg_3_1
end

MatchmakingStateIdle.on_exit = function (self)
	-- function 4
	self.reason = nil
end

MatchmakingStateIdle.update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return nil
end
