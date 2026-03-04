-- chunkname: @scripts/game_state/state_context.lua

StateContext = StateContext or {}

StateContext.set_context = function (arg_1_0)
	StateContext.context = arg_1_0
end

StateContext.get = function (arg_2_0, arg_2_1)
	assert(StateContext.context[arg_2_0], "parent does not exist")

	return StateContext.context[arg_2_0][arg_2_1]
end

StateContext.manager = function (arg_3_0)
	return StateContext.get("manager", arg_3_0)
end

StateContext.event = function ()
	return StateContext.get("manager", "event")
end
