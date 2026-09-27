-- chunkname: @scripts/game_state/state_context.lua

local StateContext = StateContext

StateContext = StateContext or {}
StateContext = StateContext

StateContext.set_context = function (arg_1_0)
	-- function 1
	StateContext.context = arg_1_0
end

StateContext.get = function (arg_2_0, arg_2_1)
	-- function 2
	assert(StateContext.context[arg_2_0], "parent does not exist")

	return StateContext.context[arg_2_0][arg_2_1]
end

StateContext.manager = function (arg_3_0)
	-- function 3
	return StateContext.get("manager", arg_3_0)
end

StateContext.event = function ()
	-- function 4
	return StateContext.get("manager", "event")
end
