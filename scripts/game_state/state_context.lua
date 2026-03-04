-- chunkname: @scripts/game_state/state_context.lua

StateContext = StateContext or {}

function StateContext.set_context(arg_1_0)
	StateContext.context = arg_1_0
end

function StateContext.get(arg_2_0, arg_2_1)
	assert(StateContext.context[arg_2_0], "parent does not exist")

	return StateContext.context[arg_2_0][arg_2_1]
end

function StateContext.manager(arg_3_0)
	return StateContext.get("manager", arg_3_0)
end

function StateContext.event()
	return StateContext.get("manager", "event")
end
